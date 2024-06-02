import * as LitJsSdk from "@lit-protocol/lit-node-client";
import { uint8arrayToString, uint8arrayFromString } from "@lit-protocol/uint8arrays";
import { 
  decryptWithSymmetricKey, 
  encryptWithSymmetricKey, 
  generateSymmetricKey, 
  importSymmetricKey 
} from '@lit-protocol/crypto';
import { blobToBase64String, base64StringToBlob } from "@lit-protocol/misc-browser";
import { ABI, CHAIN_ID, CHAIN_NAME, CONTRACT_ID } from "./constants";

const client = new LitJsSdk.LitNodeClient({ debug: false });

const evmContractConditions = [
  {
    contractAddress: CONTRACT_ID,
    chain: CHAIN_NAME,
    functionName: "certiExists",
    functionParams: [":userAddress"],
    functionAbi: {
      "inputs": [
        {
          "internalType": "address",
          "name": "wallet",
          "type": "address"
        }
      ],
      "name": "certiExists",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    returnValueTest: {
      key: '',
      comparator: "=",
      value: "true"
    },
  },
];

let litNodeClient;
let authSig;
const chain = CHAIN_NAME;

export const connect = async () => {
  await client.connect();
  litNodeClient = client;
};

const setAuth = async () => {
  authSig = await LitJsSdk.checkAndSignAuthMessage({ chain: "ethereum" });
};

export const generateUserKey = async () => {
  const cryptoKey = await generateSymmetricKey();
  const exported = await crypto.subtle.exportKey('jwk', cryptoKey);
  return JSON.stringify(exported);
};

export const encrypt = async (certificateDetails) => {
  await connect();
  await setAuth();

  const { encryptedString, symmetricKey } = await LitJsSdk.encryptString(certificateDetails);

  const encryptedSymmetricKey = await litNodeClient.saveEncryptionKey({
    evmContractConditions,
    symmetricKey,
    authSig,
    chain,
  });

  const base64 = await blobToBase64String(encryptedString);

  const objectToSave = {
    key: uint8arrayToString(encryptedSymmetricKey, 'base16'),
    data: base64,
  };
  
  return { encryptedString: JSON.stringify(objectToSave) };
};

export const decryptArray = async (data) => {
  if (!data) return [];
  if (data.length === 0) return [];
  let promises = data.map(el => decrypt(el));
  return await Promise.all(promises);
};

export const decrypt = async (objectData) => {
  await connect();
  await setAuth();

  let objectToDecrypt = JSON.parse(objectData);

  const symmetricKey = await client.getEncryptionKey({
    evmContractConditions,
    toDecrypt: objectToDecrypt.key,
    chain,
    authSig,
  });

  const decryptedString = await LitJsSdk.decryptString(
    base64StringToBlob(objectToDecrypt.data),
    symmetricKey
  );

  return decryptedString;
};
