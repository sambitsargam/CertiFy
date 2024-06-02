export const LIT_ACTION_SIGN_CODE = (fileSize) => {
    return ` const go = async () => {  
          const temp = ${fileSize ? fileSize : 100}
          if(temp>20*(10**6)){
            return;
          } 
          Lit.Actions.setResponse({response: JSON.stringify(true)});   
      };
      go();
      `;
  };
  
  // export const executeJsArgs = {
  //   code: LIT_ACTION_SIGN_CODE,
  //   jsParams: {
  //     toSign: [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100],
  //     publicKey: account,
  //     sigName: "sig1",
  //   },
  // };