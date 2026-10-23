Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792759536;
	b=BsHFJW0/YQ3vrUJRzgBhDHPwY88gE/WCrdOMyowEQSNhGB8c8SK6fwlXKJtzdgt9H8m+
	 ZAIpeI7lg1UMZv6LeNrliF3uue9a/J/0aimvZE1gkTXL0DeJZ3oZmGYh+jXtBR0Dns+8c
	 I9i7W2+6o2LZfi9tW+osLYXWLISritm9SAANha56UiqQFPChlQMZxFEpYtTgysvXnGki4
	 Ca6DlNiJVvWrVcHZm1BvT8/VW+/uwbdv+H0rp728dF0tybZW6V5G87D2OKdaTlnJGlMSH
	 rhOAS2Nw4sBROADfJE+fRIxt2VBaYY0qquC3gg8POVm8Goccpc5rTa7ww6vqC28otFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759536;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=KVL1h+VtmzQuvxQWBhfJ+wUCpg59yMIwciw2WKU2Lkw=;
	b=xODm16U7zgP9kQaPJXMSrsQNdDqxcjNWxrMujZg3Vm6TMSLhiWJ6BpVaq3ywY/mW+wsf
	 1F4d2OOq5JYO/iCfqxyRJ0yS4G5rWx/PemSck7GD2Fr+kvSykZ7R3wx7jLmvj5VI/wCeo
	 XZdSPzlXpX1yBm9sEah6CzYliiB31xR2F2ikWzBOd+nZubWitd2yigwWqQWLZk7BjhFJp
	 Zui/vhR5S8r9AA5uLoETUy8gt1vlCOzaU+vS3Hs7ymVJ7+9uSjXOYGvDp71WJ7LR/L1Ib
	 NaLOKSDdTD4gUutDbqaaJ+u4EI3taLKmVPsJ3LvWKa0suzTKqW+i+i/pVzPPhI+JGdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=fYeVNOfk;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ttjXS+nM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4F606A31B
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 12:45:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65A4F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=fYeVNOfk;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ttjXS+nM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792759536; x=1824295536;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=KVL1h+VtmzQuvxQWBhfJ+wUCpg59yMIwciw2WKU2Lkw=;
  b=fYeVNOfkEB4MyYo92wPvh+M9UeDF8Kuj4KHYiwCoFFb+0IU8Kvu6V8tI
   NEknjTiP/6k8/GQJxO19L5pPKH1dPgz5zP/a0elq8DV2jdGtlH8PRIU8/
   7F2YJXlv1bf51H4scp/xhTm2h1H+5L2P4U90aShEnB/NuvCbqnDl5acHf
   EQ09MCiNGXhuXRRPpt9HxnM3TMA0F9JO6e2P3BROTpODhEp73s2Nnrv+K
   5dt04KYhK0Gk8LUdUb4fH1xUTY3p7kmznn4DDUHWYY6NL3i8HWrLRu17R
   IYovw4WCcvzJmfr0q1C50WXkqv5VzPCFeFdJpxIzFD4CAh0uoAwsYVyoc
   A==;
X-CSE-ConnectionGUID: SYKmyFQ8Rd64P/OPa3PfXg==
X-CSE-MsgGUID: fFG48bN3SwC0B8wTcDwSmQ==
X-IronPort-AV: E=Sophos;i="6.27,174,1786982400"; 
   d="scan'208";a="158840753"
Received: from mail-northcentralusazon11013015.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2026 20:45:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDd12ts+rw2wmMU0Z8K552A27/I4JNjSN6gyJ9EakJR5QJJsV6AHUCTmUUyWQLMwDTWyXEXRgSUUKHAVmroUEhLQhOkFxFix5TzipUyRkaEAO+YH/uStXTkVd2+Po1FVIU3WkklAlXSf0pjeKt6435g7gDtoz0JZxaXJa2IvCN+4SPRLwnQGq5X4lHAzpKCyMBfmdakFPJOklKrvZATHHRyVNfD0SzV2cLzkk0ykBCbJYakY2//fr9ktrcyFKFYOKbUoJQx/58c8SDR9oVYm/P0/PyzqO16fNhu8WrcMY/G4qOrgEXv5D8V9BpTBaWZB2Hq0aDqElMSsr+DNWfaTPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVL1h+VtmzQuvxQWBhfJ+wUCpg59yMIwciw2WKU2Lkw=;
 b=ovVFm3pywtF1S4WKy0JnDD0E8OJ5GCmJTJPar/KLwcf2vi/G4inhpXEV35R+OBTqxhzawp/sFgQy+S5rX2UaI+yBKCZAHDYDMDFG3Gc2YoKu8mD0RBiFW3ObgeKm4cCeupePKK0tnNhn6MjxCxuvawRcBNeRsGqHwC/pEsgt2ZXonHjhc7HkbMYEhm14DtePvCBnku2wVVhUM5ry2eIKViyEtVChmO9YfcuKpUOXecX9g/TEVU1ZntJE1ZJ1DxuH6GWSxBhPNuEV1OWWswRGHoLmGKGj4AiJwm4dLxyRxvA8J/6+xjDNVBM6TaVkMG8ttLTzv3sfhXYzXwT63S7blw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVL1h+VtmzQuvxQWBhfJ+wUCpg59yMIwciw2WKU2Lkw=;
 b=ttjXS+nMkFW6QDYKQmFd4vFwU3bYhrGehh79WBxYFRyr+XgRaGcU69jyeo7Jz1QZ8hoadgmD25D5Z8EacMNgC20rg69SUBoOe7cugTrps7JEZeWZ3qZkUdCpNQ03uHLMydpD0z6gjF5OSPnVk+ZmQz2/AHQ+CXxlxBszyUvMeiw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS2PR04MB994530.namprd04.prod.outlook.com (2603:10b6:8:4ac::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 12:45:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.016; Fri, 23 Oct 2026
 12:45:26 +0000
Message-ID: <b051eabe-2bd3-4a63-84fc-860bd8be7a7c@wdc.com>
Date: Fri, 23 Oct 2026 14:45:22 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove fs_info argument from
 btrfs_add_bg_to_space_info()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <a852cbdadd074819ee4649ab7eddc239ddd046f0.1792747602.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <a852cbdadd074819ee4649ab7eddc239ddd046f0.1792747602.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS2PR04MB994530:EE_
X-MS-Office365-Filtering-Correlation-Id: 96953ec4-6c43-44e6-0a8a-08df310382f0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|366016|19092799006|23010399003|1800799024|10067099003|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	qKYvBExij7CCYK2E1424xA/gkljP0Qo6cz0GW2n01kE36dM82w1bXQDdBLlAICoZvuCqpENMfrBj1YYV/PWHlD/mcjXi8EJN9AceI1EFFdPT5sjHjcWiYrc0lw9yeukyQpKr5edZ6soOk9M7j6+Kyi3iuWSrgyyylgZpVGy6v0dOsfyIgWKY+Ef3x1y1oeTvBc1wj2+V5sCAIpmA8ZDQU1GNiVizu9KXhei/pLcPNd9l39cNksVKzJE9Z0RF4P5rZiz1xMKsXsBZA4dYGDFML6RDsu1K8r1/EAs3lSP6oqpecqmr2AKvgeru4zzXiAcAxFOmAJrHx7NsvuDlhhgo49Ra3W/5ffgpKQKjb+6efctDfyjzSaWem0R382+VIAcZ+v7RedH6uj6Wh+sl7MGt8gNIj2aW9rgrFKcHurDrrV7AceYfh+uILV5Zk6PwD7QfvReOBamtCjuzCPESvoulCrwO5J1HRKsbZnspIsivfaspgUFcFFE/QizxVxFc8YDx0Dx02RrpZIQe6rbPgcKQoeAVlmZnlFFyocPoYvKJoz5nkH6w/FbDVCF796az7CRtzJS5TjsnGaAJQKyYLBbp3CgzdoD3kX4nIDoS0pnVaQmQ3+zR5TNr+0/s7hf2HteliosmPuO8gtqtTB+qcDk0MeewzLXcapy7JK+j7M+tr7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(19092799006)(23010399003)(1800799024)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG9RZHMrSW1ZZVdINjZucnJBektvVngyd3FKc01YMGdjblFtLzhVeHNXc1JE?=
 =?utf-8?B?WkF0TEpJczNBVkhXb0tlUmU2NWQwMHp6WjNIL0FDaFdoS09qSzArL3JXRGxD?=
 =?utf-8?B?MnBFZkFNNFF4Mjloa3JmUnZGVStGUkt6Y2RPWms3cEpvemRQUnNjUllOSXV5?=
 =?utf-8?B?cWwrcURmcURSdDN4UUhLT2I0eEVGdyttcmhzVUloYnJqdmRNQVdYSjd6SkQx?=
 =?utf-8?B?VkpzMXZUajJMUHRZczVPdEFmQzFKTzE5TzdPMTBRYUNneGNMOXloRjB0MGRX?=
 =?utf-8?B?cE1STG9ZUXl6NVlkdFRzdWZFZEdoa1BtZUlWRHYzc1BjQWsvRU9OeXczSnBK?=
 =?utf-8?B?L3lFNXZibnB4bzdlUDczZWswQ2JiQnd1TkdTallMZVg4b0MycGVLREJBSEtB?=
 =?utf-8?B?dHZRQlE0QkVGRWNFbGhPcDZZQkY4QzY3UXFOUndYMW1naFFEZTFrNnBtVGho?=
 =?utf-8?B?V1VSQVdSOWgzTUJwVFFnRlRBam1GRVdtQSt4d2tZaWgvY01GSDB3YmovemdE?=
 =?utf-8?B?a2VseWpLWnhOdm5kSWRjTmd5Z0ZPSkZPNzdTdGdaU2lWTWIxQ3Vyc24vVjRr?=
 =?utf-8?B?MHRYOENrSlVzTjBRUi9rN01VaC91RFNYTjJaUWFBM0dYb2hMYjhSbGhheWR6?=
 =?utf-8?B?YTR4bXd2MlYyRXpjWnhRZllDcm5QRmFWREg1R1AyYTJiWEJleTJsVGd1bzFF?=
 =?utf-8?B?K1hQTHFObmhZWFFVcG9Ib2lBUUY2ak5FTnM4U0FZUThCQWVOTzlwTG0yU0tl?=
 =?utf-8?B?aWtsMGpSR0s1SnlsY2ZnS1dpYVl1dXkwQk1WbVpzaUtFbm5PNWRJSUxrTy80?=
 =?utf-8?B?Qjh4RUZLRkdHQTZ3dE1NWFVaTitCc2s0ZjNmQ2NtRm5tVWNicERVbzhhK29p?=
 =?utf-8?B?SEQ3MmhIc2EyR3ZvMVUyS0IwcUc4cFNkanZLejhoYlhJTHA4SGR3ZFRxdkxp?=
 =?utf-8?B?NkxUd2dXSG5Tbmc3VU9EQ0NYUFJnUEM2L1ZPM1dTbUpXa0RWOU1JaDJURHh1?=
 =?utf-8?B?eTJJT01zc3NMSW9wQWpYOGQ2K1J4SzFUWDJ5ekovajN4VXNvRkZtRThXeHhH?=
 =?utf-8?B?bFYybnRpbkNYeUc3ejhoWEtMamZZeGlZVnd5cTY1aHRqVWRINzNjZnFJa0tY?=
 =?utf-8?B?alpGKzlEQWt2eHNaaEhnc3J2Rk5SdWJ2NHVkTWlRT3hWWVIzVXZCazBSNE5s?=
 =?utf-8?B?dWFoVjRyaXFpSWIyMnY4NmM5cjB3WDJ0MnJjczI3NGQ5TFllR0hLcDZCWjRE?=
 =?utf-8?B?TkV4NzFmY2tRMFkxeThZY3N6d0c5SkV5Q1hvR2QyN3BTeGZCaGVocVpFUUFw?=
 =?utf-8?B?cHNUM0RPVFZtRUVidjJnbEFXTXF5T0hVMGZxUkl0MFlja2hhellqOHpMQ3dO?=
 =?utf-8?B?bEJGRFJhYjl5NUtCVUJkbG8yWVQvQnVxMjNrSzI1S2t5a09aYU1adFpldkZ2?=
 =?utf-8?B?WWQ0OW1GSjZZNk5aWGZvb1cwREpBRWdjYi9SL1FKS0hia2FVVTBlRDNldzJv?=
 =?utf-8?B?MllzU3NpMm9oMWc2OHBBcXh6YnBDSjJyQ0xLRHVVMjBOeC85Rkx4YzgrNWRD?=
 =?utf-8?B?c0tweEVNa1pud0tJaENxTlg4Vi91K3lnOU0vV1o0ZmRNV3JtamJtZEtrTmZr?=
 =?utf-8?B?ZzhOTFBLZXRWWW9uRG5SZ1JaZzIvSDcxYUYzc1R1NGNHcFZBcURON2pTWjNn?=
 =?utf-8?B?U3BTOXZ1UzM4RXNELzlTQzZ1NHRaTy9jWHdSTG5FOU5wVU04MmVkenhUSjlB?=
 =?utf-8?B?OXJCNklsQk5vOVVJYi84YithTW8rSWt1cVlkb2FiMUUzcGhIRkZLTWRIeXVF?=
 =?utf-8?B?dWYrVVBqVUt3b0p1TU1TM1pqdDRBRWI2b0VXNEhNM29KMDl0ZE1yZFp0Y3Zh?=
 =?utf-8?B?R2lQazNHM2xsMjBuNDJjdlEzaTBORTNhc1dyOEh5eHVXTm12eFNFcnU1RUNX?=
 =?utf-8?B?Q2RkUWxyc3dJZGVXTGVaekNPQmFmb2pTbE5DRXN5SXBnRzRrNFgvcFZ6NVNX?=
 =?utf-8?B?cm9FRjZGWGd4M25YemhOUHBHWnVHdEZHZk9pYmRTTVhxdjJoVmhveGlqNTJU?=
 =?utf-8?B?a2Uyemd0SGhnT1poNmpxVmNyTFZlVWpwQy9DVldnWFNkTmVYbk1qUUdQTnRv?=
 =?utf-8?B?REFGQXFVMmRIb2JhVXBHajNHcmUvelBRdHl4eTJkWXAzMUE5a3RmaFFhc0NQ?=
 =?utf-8?B?SEdwYXhTVTF5cjdHYUJVbkxmSVcrRXY3TytkdVcwL3RQbDhBL2hEUFQ3ZjZn?=
 =?utf-8?B?dk40b0N6anpWUkFXM3RJditrMFdDVk1sK0FVQ3R5LytPOUlBdVVLbDVyMHNW?=
 =?utf-8?B?V1JRYXR2UWc2UzdKYmd0V1I1VzdvZDJLYjBONFROeUNObUxubnZ0RDMxSVNS?=
 =?utf-8?Q?Anx91UgzY3uoJNrS5nO0TLadRAXt4zv9t0aCVpcfavOec?=
X-MS-Exchange-AntiSpam-MessageData-1: vqCiSTfftk8puOFDv87M5xTaUJ8GKHRQe2w=
X-Exchange-RoutingPolicyChecked:
	LvGaV/BrF2cyp9w3TEPY4wIOralCptqxyIfjyAT3nDcmkPQAV7IbFiMlsAkWb8o0VKdCtZ0n21JPSRdEtSHtlLDDU3q97sImxRDyMtlcJdThtpA1DzlfQRbx5NrFgE2+229e08uRUfFuFUqEi19UImzwB08B3oFAx1lKIPyDHbj7fWdWEpKiFo/XGPI2Kvaw2U3XGrlNI12gte6eZ/YhvFxa8oxP0JPOEqxxgdoeVgVNkHtM8sHwc2CkX9oMjViXtvKSGhY/0PyEBjm8hLG+WkYGcHm/TH6/h5QLrnqyzzMcPubRq8vwz1o/FH1FKoYdBanDyQwc+K28qjvPqBLSKQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D64Ds4/h1uHvpoxx5oh6NMbxw6BIqx9bXqtbzv6+Rt9XQqJAbC890WtrpEMW8S6F9HxOVbThfXPfHVosIqsyYapQFskT5Fw+Cv80/ZfHLOXK40CCmaP5xZcWXD+ku9saALCqOL9gfxEBsaEqAuyMdtR8tj0tkY/V5/IBe+EWrJf4tTuqyLUavBOwCV/y0uiRx/RDBDWENwZl9OecmoHG7+XJdzZA/LkOz1XtForobxBfcs0oqWAi+MAXKEHCgJE7udGIc8jgXAJ08DVBZ9AmxopcIeaUjS4eTlDQVhjZbhUSYWFZecjbvpAl8P5dsjtOtk6RFjxdclwTiOwTGhGtaZQquxklHLSX/pc+q6XVaKJLcIAbPwL96yietpcwx0MNhiJmt5dWBO/PRFVopDBmfwEUBgCvvFJDt5ZUOsUZMRezYLE7jL0wk3aNySd1NyZh7kz1klYCkQPvLzzhiG6zu9RnPO180Bhndt3eKjeIYff41vh2feAY37K6NWRRMliL6LgP5U6ijhLG+WPa4fYrhVc51f83cpa1OJPjCklbqszKcEQVqmXA2BivwbzVZp0ndyrj/dFmNf0ISipPTDHY2uv4DX3GL26/AEnBx98X6i0rmzC8xc30PvwSDwGGv/of
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96953ec4-6c43-44e6-0a8a-08df310382f0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 12:45:26.4522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30T35c4bJ2F5CHTG6XA2yW+aHZtv47Bdk+ikXeMvbMuvo0J5LgMjo/IZlOl2UDyDdTlwczE/d7VdJaCWoOzjR1SE/HjzwK3AlEUUpdsz3f4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB994530

And a bg does have a fs_info pointer anyways so...

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

