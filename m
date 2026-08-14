Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538EE43C05E
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702603; cv=fail; b=dXtD6OgimPNSi9QtuXCi5wK1mcw4C2/Zx0ZKnW2qIoEn8WwEtSPoeX8UNdesLQ5vM2WT+AlWR9aOSuVKhJ7LBxJM8j+ClDp2g0M+TRkIQbTAyM0AQ5Lg+lqq6pKhsLnWVzywtUL4XgJINDf9YsM0b0CSADpg+7IiNL4olUaHjQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702603; c=relaxed/simple;
	bh=ciTcBP86fFcrJlKiHubXSZuLp/EMeALe57KLNP369co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a6DRb6lK3R7wR2HaBBuSP8xm2Gm/tyOVkSkQg1xx/ycVDRfbwIe9/vHx2zwb9c3ARSUzpLg7itH4DpK36UaBE02O4x1zdl6Y1NYcF711w6Kn4DjvAbturWwlN80yGhnEXepmpTWN0JBKRnuAwTydvJ9NSKMG+b9bwlUIM29Io34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Qm2PjzxW; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=N4P+dDUK; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Qm2PjzxW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="N4P+dDUK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1786702598; x=1818238598;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ciTcBP86fFcrJlKiHubXSZuLp/EMeALe57KLNP369co=;
  b=Qm2PjzxWFUaF1+H6LQj7ak2c+cMZ3feEk1VJltu5ctFFHXORMsBaO1SS
   ZD70yRtnN9X1AKfw5u2cbuS9eF8sJrSnAm1OInPy8h7EDBlM5MItiDraR
   xkecSj8r+DksNNQKKVOIfEFO77ik/x3SSTKQVnQMitL/qqQWSKRVMlMgi
   pRu8uOZWvJ3QDW/AcU9oK+e9LBkMmaQ9YRPj89c2Ck59QdxQXerwHfGd2
   keOSW7WQu17GDm3rsV7nI4LFD3rmIcee4kJEfh8ZvWASqavGiJlaGQy0e
   TvHTsluOhW7fYtLqopZb30Ovzd/nfW/VeZ7y9oytJQisYUKpODE9SzHhJ
   A==;
X-CSE-ConnectionGUID: NFddCz28QD+L1rpqyXu9vw==
X-CSE-MsgGUID: gBAW3OU/SJKnFu9ex4ji1A==
X-IronPort-AV: E=Sophos;i="6.25,222,1779120000"; 
   d="scan'208";a="152198043"
Received: from mail-westusazon11012041.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Aug 2026 18:16:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KR3asOPnUyjke43D2nDMnnRlKCWkdy8t3Tl8r+BdKJWdySCDVJXJng/VR8m14dN5/l5gbO9vCzakt63aEq3iUt3yxodZ7iz01WC4lJ/CLSAjaT9gesOzgciDr3w3ty4ToxxmkjAgvaHR4TbGOtfOx4wfjir7MJcEBkaoAbnQDV0ebctEd5wzmen8HcBKJUlQmGsVv/SV7PDkAgVAxIiHPn5vautih6wReMsgJ1bg3kSUzFBH5HHjpLo/KDCUlIUeCm9koYV60VcZgdhUl74liTY4Yow6EcvucmMf17TQofUqGwjhGFt5oRu8J7JVdisZDrPKiDM4lVEuIe6kq2hCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciTcBP86fFcrJlKiHubXSZuLp/EMeALe57KLNP369co=;
 b=WDV/o83OYcIgpgMTnRG13SBZ255x//f37474RGDOOwWdE6qwQASmS2QSlPKPy4JBEJTM97fLE65ZCKMfecWStPdGEIstIDtFhZAcCyEa4J7140D4tMJ2R//pJP4BO2/nDSiC1pRFmGl70WUTv5eelxsKvKLdPDGNrDGx8wAVHgaFqhxZqFGfbyB/TmX3OBJOC36clok7FuXrrjCKtQytpIjNQJN76faJPtngk+FfIP2ID+aXHqaHcBtYNLXCb4yEaAsdW3VQ5Or6IS93PjMyHLngJZIrDFlI4qOav2HZXVmLnx9ri/oE7aU1WsLAbtgQ0aKs+eeKXM0VVt9iTFnaCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciTcBP86fFcrJlKiHubXSZuLp/EMeALe57KLNP369co=;
 b=N4P+dDUKNC9ktyiClwQNKCn6PwMIdYw0MfCM/X0Sv0yISAAu3tl/iJiOI8HvwnCaJEAyChJa5T7I7fJ8yox2Zga4WPOBGirtSyEWBgIWUh7z7xFS6O7XhPWqAjZRHCnzh79hFALbnVo+c/gZkNHF+DCbXLF+qIVzh4OFz2L1FbE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB7001.namprd04.prod.outlook.com (2603:10b6:5:24b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 10:16:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 10:16:27 +0000
Date: Fri, 14 Aug 2026 12:16:22 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: properly cleanup replace_task when the replace
 failed to start
Message-ID: <an7q3Lsr_n1E3qrq@mayhem.fritz.box>
References: <8e4f535ac093c7085ab0641114e2f082788585f5.1786576348.git.wqu@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e4f535ac093c7085ab0641114e2f082788585f5.1786576348.git.wqu@suse.com>
X-ClientProxiedBy: FR4P281CA0164.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: 39b237d1-7d96-484a-a351-08def9ed1a17
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|1800799024|366016|376014|10070799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 D5dXzuMYV4z/U1O6fW2Vm0dCDUPmTbNpvKtLLKmLWn0WHojcfH6ywpdwYNmuf4YEhzP65LpXzI95x1S5L+DWCMpuHNc196n40RWhfidJUonfKv40niRd0Yf+tGcdloSw4mwCfz+lRl6SIM+QUk7QPiPc3PaPSAWuBssGr7j5dMiCKoBNNBvqTvLT8Evx+zO2cIG4XCmYaW/d+enToBwrpKfji5gioQLkR2rxaxdgUmGz21BYz1tcL3b62QKyW5qDNumYoKqpSvCgSA37WYZsjEDyw+yN1OeUeFIAUJjxl17o64+L0fg9KZNt3xILHug8Wg87pzfGeNKRTno0Cmw/w3fOTGvV9m6W96KuVP7RAOXLRV5fQH3icMfTpdqTX9AADgFqJKSEjtu2TWMDiA8xcwhLqpXvdqE5IF81G/EEs11XrW3+3kCZb/Uzb9Mu5taCpbi3LYQtErjp25VGqDlEuVCI+5XDgFVy4mBa+dzCl5qdpee0ftIAb4KLhAiK6nMrUS4TUByvjD0p7adrbraqLwKfPTx52SidOdYKQzY4+2Gke3Tp/QfIgVpeLD2ixIzsdLcQK0Xa0YgQ4yiCKxdAX4jv7KCOGVt+nAg333leCpfOarLOsBeHbzrAb9E0sjhBW2Pw/l/Q27rzkmZgGAGeQQPUcKlWcR2SMd0jhcwUtCE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(1800799024)(366016)(376014)(10070799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?FIyjgm2aJNoY1/Ly4P9C2gf/G1VBSXYWNeQHPydeqr9QY+vyJhCOk4x14MRI?=
 =?us-ascii?Q?hTLTCiTeTOuOW8+TAzdap0Ps+wnPq2cP6yegbfT+ViP1Z9VI8ealsIYShU5l?=
 =?us-ascii?Q?/qGGbha3JLRCUiWdAs3jWVfGOzBd2KrTiQTLpOdwX1IS3BWvF1FqF/aGKBYH?=
 =?us-ascii?Q?Qk2WUhmnxe7wtSxj8rQVXJzGsVLKcZZUHVedAoiet76+m4dR7pbT3S8kr7JY?=
 =?us-ascii?Q?Zy7Nfu+uUZHgn2oMMrdYBr/umJ45ix7NTuH5kjEArrdybLtfMQmYoHY33gp9?=
 =?us-ascii?Q?g05AEFm6xnp7bzN60arFOztLQ9qIVvsJva6hWFwI9amu9SXxq4HYAx+N2MVT?=
 =?us-ascii?Q?eHZQpOekkCCtIbmsEaoG6xri+VKZ0b/6xMk6iH57w/BJSaPqgc0hLLcfcunW?=
 =?us-ascii?Q?sxFr6YpjvMlN3PRzYNCmiB4dbLEDgrShv/sr9GV3wH1/yh4cCjjWp1Fnl4a1?=
 =?us-ascii?Q?ANjOEFo3y5hlNKbkOXguQFJRHy7KsUpnl0+tDoY1NrhqKhF9fREWUzS0tEGf?=
 =?us-ascii?Q?sMH4eMe7mD3cgEL5hOIas5G/MdC52jksphAfrXrx2v+DBP0mWiHELC3dgfeS?=
 =?us-ascii?Q?jIPmpy13GJkb6ErZIx5J9NrqlDGBb5ol/ZjwdhqbevdL+fnBVSrpdPEYp/BP?=
 =?us-ascii?Q?1EGXgGSCuE2xnWMW4iucKIt0Lpe8M0Xpzp3dioOCurM9YdymE4qHjYWgPS3F?=
 =?us-ascii?Q?1OeA6nWdBB+v+bom5mdw+GvHQyN4owSUPnaZ2Lr2wHtUKcjE7CFVAtYMyWdT?=
 =?us-ascii?Q?r6bsf2x7+fXo3+iXQb/0lfENGlymSCuRISkSCYKAqNj8EnH1BQDhmj4r1JTk?=
 =?us-ascii?Q?zwyTuhiNzF0CEj3PO11UpnKQSo1J3JABsj7F4Ao/UrNwwYbPINlB9WvorMzg?=
 =?us-ascii?Q?6yGzJHwSrE/bus6iBwnTdcM6KYyFvk4UGOhOwIOCRUQnZ/OHlX7tU8QSIQkX?=
 =?us-ascii?Q?S5ONx0+zSgikW8mgmr49RvQ7/N+pnMxYp4SIwQ/8wy2VMpiTBJDnVDHOHQgo?=
 =?us-ascii?Q?wWPD1GLaqBbErPe7pTipwHGCZaNjCPrEJmhxOVgFwTSFLeOPmGWcdd6zmzcy?=
 =?us-ascii?Q?sq6yA4kXvE0yKUA7h5E4OPv6OcL52V9JEMvOapCDtS3RMCsdLOEehiDb9/bK?=
 =?us-ascii?Q?tGWRD9Y/rVOuoYD9tHxNWRQ32W1CGnLVdp08Ov9ZNDvByaTDcAtDH+K3QaH3?=
 =?us-ascii?Q?pEK23PLnRJ4tRR4WDDl+QLIqpGGubYLr8S4q8m/Xy1H0Ln0DmDoAAUxXO4/a?=
 =?us-ascii?Q?6nROwhdDQ/bFqWuF5VbOGiEDAAd2GRPvhZ+y1cQ5abJTfOLBmN5LSf2A/Qgq?=
 =?us-ascii?Q?r6PlMPHJ5pmh9dq7/I4ezejsMCvwL18DxWfVOl6vFuxYv7jVeVK2blcEha2R?=
 =?us-ascii?Q?g9kSXUpXZc78YKb7dOQfBSDKgBr8SBJULyozx0NknR5XpUPSTuUe+MTaY70G?=
 =?us-ascii?Q?rMG2Q86u+P8mn1PqtNvkYPOxRNKnzsjK410H6iJ7SZoC713mdfLdoIK0hFcT?=
 =?us-ascii?Q?Y9gOgOtO1dVDqVzdDNvVUHtRkt6zbbeBL5p+8HsRoo0vu4qVj02gyE21WfLJ?=
 =?us-ascii?Q?e2kuDCoWDBZyZbxBN+SjvJtFUB7qNeghzEag4qaUl5R+i5K9becu7DXHAaim?=
 =?us-ascii?Q?PC5mNkHzM2dBu46EV/GYN3xzbV/AK9YtY69fy//AHbq0xSC6iMGwiDmunD/p?=
 =?us-ascii?Q?kc0VrqtXUL/PiZkc4d620M2RMGyVvBAEcQq3AIVIqAbZsUz80VXDCyUMMxbk?=
 =?us-ascii?Q?t1vVOXQV5BM7Ph6QVynHaeCjqYRGASV0ZMeTPdmKfODyErDS8dk6Zicqiut5?=
X-MS-Exchange-AntiSpam-MessageData-1: G8i1FRp10K5ZoGRfwrfjAFUwdifXC/RRT/s=
X-Exchange-RoutingPolicyChecked:
	oE4XnVVOD0b1ycAfyA9RtzZ+kbhpC1PL5GWggYITk6bNm4ktr+Vq5HkpMFApFSXpqy11/G4fUkDS6Sk9YJtLlC8/uiOULTzN45Ax6iBy2ydI+31MV7AomR4cMgKghlMvH8D/v1TK1vGoinvu3AjuaIcJhEp4nQcJrG3QUhdVMmaKlYS9pRfEdkklclnSesfVcFryxAXD2/ihde30HSi4GW0nr3h+cEzuGBDiNOp7bW3iijuEn+gyGpRnlKKKHMONHF3xGuirRPcr4B3IeqXk/5Te0orrSBgJfBlIgVFiBfcPmJTiMjdMGs1Qbn4cKO6Y48XPK2tGgEmT1zRfbFVKaA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IGYsikqz1r3/tY7nwf9K7W1LJ18702N6+VHEBN6bGNG2ehQ3fwcCX6PjfMYvez9kuMjfJPdlCmpfhy6Li/V1+S3JC0i4+LmQxY4yCjpO1+sEjcEqaao99sYkhusSWbWenOOvqdVVpFu71XuxFse2rLI50eGqK0TWWyXrbW2Yap4yGBQY/yCKZYYA/gzqMn6vqESzsEPEY/5Rw2tV/1Xlt566epEVTcte4tZNhPVazCOa3w0sFZspxvhnZPx/cQ5/5cDNVgf/WKnu3HqMu24maQ/OIPCviT1Xkg77PcP8UvXfscKdrJG5VXTR1WBm+8KqB3+7fMh1BoF8KmunjP/PfK3UCJMl9ySkVUP5P3Oj2drngt2molt7GM2OFVqe7UUycK9LoBc1MgCxLIykX41GKJjrrKdSxqVJ/im8ilnwrMBXl+J53mBjRtcB/+FdBQGjAjpKgy/Ka+W5+ifDWYA7IaISaKzJm2mQpelcHOZRrMdNHjXHP8ucJ44ohL1e52qGNpLHUQtkkLi/+SfkEV6imjOf2+hsPsrQHDdqoFHHKbveFohFdL1z0cgTcZyp4rptsWmRs9sX7NgGzyPwwfdkMS7YIxFJJaHkuae0DHVO5VUlbPG62v3dTXMfKZ/syh7F
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b237d1-7d96-484a-a351-08def9ed1a17
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 10:16:27.4733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U0HrJLJoRHotgqAj1M8qNA8z7dJr5sBv7xvI1ToX1Ckzle3BjxroLzi3YOuAEvuDFq+gPq8eqmuojwwx2ChQnYbnx6C+fJ/ivZsY65L4bdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7001

Oops my bad,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
