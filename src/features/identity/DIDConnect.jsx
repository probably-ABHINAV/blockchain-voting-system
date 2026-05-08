/**
 * DIDConnect.jsx
 * add DID wallet connection
 * Created: 2026-05-08 22:07:37
 */

import React, { useState, useEffect, useCallback } from 'react';
import { ethers } from 'ethers';
import { useWeb3React } from '@web3-react/core';

/**
 * add DID wallet connection
 */
export const DIDConnect = () => {
  const { account, library } = useWeb3React();
  const [state, setState] = useState({
    loading: false,
    data: null,
    error: null
  });

  const fetchData = useCallback(async () => {
    if (!library || !account) return;

    setState(prev => ({ ...prev, loading: true }));

    try {
      // add DID wallet connection
      const signer = library.getSigner();
      const contract = new ethers.Contract(
        process.env.REACT_APP_CONTRACT_ADDRESS,
        CONTRACT_ABI,
        signer
      );

      const result = await contract.getData();

      setState({
        loading: false,
        data: result,
        error: null
      });
    } catch (error) {
      console.error('Error:', error);
      setState({
        loading: false,
        data: null,
        error: error.message
      });
    }
  }, [library, account]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  if (state.loading) {
    return (
      <div className="loading-container">
        <div className="spinner" />
        <p>Loading...</p>
      </div>
    );
  }

  if (state.error) {
    return (
      <div className="error-container">
        <h3>Error</h3>
        <p>{state.error}</p>
        <button onClick={fetchData}>Retry</button>
      </div>
    );
  }

  return (
    <div className="component-container">
      <h2>add DID wallet connection</h2>
      <div className="content">
        {state.data && (
          <pre>{JSON.stringify(state.data, null, 2)}</pre>
        )}
      </div>
      <div className="metadata">
        <small>Last updated: 2026-05-08 22:07:37</small>
      </div>
    </div>
  );
};

export default DIDConnect;
