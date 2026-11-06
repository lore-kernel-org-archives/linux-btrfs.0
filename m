Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793985341;
	b=SsLdL1H2Y+b+XUIGTdF6htjv0gPOaNRo9wTdVRhtEuwyUi4Cb0sHDsopzAa9JlVpFcQA
	 frfhDC1USmmjZA6SNnx9klCiHbzWf+MtTE9uWYRzS4iR6XvZ3fm+PijBnbuCyDNg1mRVs
	 JEEt3GU1CGnVu22YvoSg8oHuG28RZo9r63Rv9rIpYZxnVYO945+ZfqjMwoMJe/HgBpF46
	 Nt8zv9UXHjmzr2bx+CNyTkakUwKXuTQ3YLGod++eFexcI3URLXujF9qLcW1XtmLCPPnHV
	 9hcUW9sQtOzFFwadBM5nFolCwzddwxzqchjD34wLXL+6YqVHIwe58ESDuQmzaw6pdnA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793985341;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
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
	bh=pYO98nF71tgVvUv0nuWbHQENLR3HTz7GNB8ElUJqhaY=;
	b=3N//w/BY20T5IBCm1iWkAnB5HBCp/4xWGJFbt16W1LLm7/OCjHBzZYyN0QLrRKlKjXRe
	 iQxaxYc2GTHCRWIIzl6jyLVLSDQ85hsGA/+btogzPAvxpjO0VVKhWK4Tb5IVOr/SUezjt
	 igjsK2avGmlRN3SigbmfpW9TNyDf6zq+4RUxj6hhceXoE47YYpA7iMqWdZG7svbtWi+TC
	 rlG9feKQybaNC2c1Af2SAM1ygCpwrXCQzN6LwAy96taJgBw79JMRjmu7qYULJrC+n3gBp
	 IwETf6r3dbpikUyQHQMB4pvQXEUojEDxhLp8Y5uKbdwWzc6rStjhR9WYkx1ZDka+uQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="ddo5UEu/";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="A++/Fjbg";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BA4606A332
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 17:15:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82BA4606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ddo5UEu/;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=A++/Fjbg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793985347; x=1825521347;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SnzeW4n6VQwMg0F4g1Ko602AwD1Oaf9A+hNiTNjZlHc=;
  b=ddo5UEu/tKWjQbWskutnJ43FCnY9RDWA2aa8XO/LK0fGA9kANcso6JxX
   JaojYTB4IrB5cWi+3pg60I6y3srMejF8a0vyGjM2sRxGllQaKiRPUAfCv
   BekRxh87jjPtekZAkZx+Za5rNFAy9MBsNs2hS77jVYZMu1BbVSVPHAGDp
   /NKrmnfQP2DLC6LkYSQ3d7aIx041aqe05jmiwgH/uawrhaiQwhWBvnh8G
   chPJuPx0HqXQd6bYRi1ukDBRedOaqlAsP3WZlwMDa5FY5y3CIjbguRFji
   uz5aJLjcOMHac7f3elYd/LQUzlOgnP4g5zOm9YIJFiwUdrLIkbpNCw7ni
   Q==;
X-CSE-ConnectionGUID: lC2lV32VS8mEX6qfenIvsA==
X-CSE-MsgGUID: vzjAEXe5SN628233N3RBHA==
X-IronPort-AV: E=Sophos;i="6.27,197,1786982400"; 
   d="scan'208";a="160994705"
Received: from mail-eastus2azon11011012.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Nov 2026 01:15:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpOO+/uSTCyG+sav4p1jfj+R89K8fEsJpclMXv2udtMS7RYG7p/AY574ohBUWa5Y06GJxI4EhZ0MOMUX3noor5RaZRnbzoCoXa+otkIBGXCVtHl8TQ2uOKQoUJvnBfovRqnmYXLgp1plOJdoP/Zm6048rEm/vUG8asmOrp6yh+kya8YfQvs4Cn2li71aAiSekvlqLdrnxfHrVvN3wxz5D2ju1qanU9eIn0+4XlevfPdWtq/EpcrfulmCSwbNbTbi/7mNgcdt39ltdpxdPUvI0xR3HfyBoL2kDgKEYttkZKOn4JNCv2/BXo1+f3kwFQIFAhqr7DCd8won9yXbcIUalA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYO98nF71tgVvUv0nuWbHQENLR3HTz7GNB8ElUJqhaY=;
 b=T7QQF5OwbXLAPxvqx1pQdVxbqL1SSokpJpbWGj3813VkbjoC3UX0ZF2JWRO/YVuNlifjlsmGMPH8W1IOGG1UeyUk80D5fz8gPy26CdSd5kobVAW4J4H0pRqlfYFZTIj4YWswTnP22ob8N415OCuBuRR8RUHN1QGpw8o9orWS9X80u1xYgaoB8ysVzhT72l/b2w5aI4d/WE2swhDDtE2XkzdquzAY5RZ3K4+42UZIhXVhGIPyb7zKenWC5pAOUqouTR0p90ffUUcmgrS5dKD36VG2tffR0wzY2oRyPUoJjfJD+RxIBqJf+0bvDsnuYVJFLH9TIYDw7s6vQTq0L1taqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYO98nF71tgVvUv0nuWbHQENLR3HTz7GNB8ElUJqhaY=;
 b=A++/FjbglZZ3nZ1IkD7gsPpoM6hc5gtTzXoUUgvS3yhjmrPbqhFV2F4k7AhyXrqiQPCRtAMCA9Tpy/mH3WaZfafTkxEhHxp4Sd6F9MWlxF4MYqiKlIXj0jHNUtIrtcMswuWySGL6GdlXLzGtTSMfpi85SqjY8yAuwf34hDx8AxU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB9931.namprd04.prod.outlook.com (2603:10b6:510:3a9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 17:15:30 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 17:15:29 +0000
Message-ID: <ba58a2a6-cd13-4e3f-aa90-7309b2635063@wdc.com>
Date: Fri, 6 Nov 2026 18:15:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/25] btrfs: zoned: fixes for generic/747
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261106171244.GA401465@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261106171244.GA401465@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0433.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB9931:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d758bec-2a08-4c38-c508-08df3c298ecb
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|19092799006|23010399003|1800799024|366016|376014|261102123227099003|261009223027099003|261022075727099003|261021121427099003|261021123027099003|261022105027099003|261028144727099003|261026140227099003|261026121527099003|11063799006|56012099006|6133799003|10067099003|4143699003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	848u1UdKvzXyru5ALloepeRvw4/Ci0L+1MoRDNOdz409iZCVkz8qFY2rhkUTEsaYL7/1D2lpsrn0MLV2O4etz6oxk5hclPUbndc7rgHkWoohen27l1eFVvr8aBWy2bv3axoY0yMGpH2E79RN5gKtQIC+C6szcelSwYxqXDBetqVzUw0n3JVqhaFeboQ020l1+AmcbXQc0/pKUmC69Dp4KiC6+OSYegXquQwR1zfXF5EqqS6GSL5ErfMnI5Lbjf+eS4NVaPjbjwkjZaB2T77gSijctdphF48D4X9aj++Q/yQriiDIVbxQqAT0xdmgkfF3IG2+wMSzjWiiHjvnVRz8bfLdBuCjz280vZTS0D+z8GEu4ZNCUgxHv3PANYPkrYA8U/ciGw2RymI8vKYTzTBK1yyQlfnvglBRxReh4iJ9Z0k4aLHM8TSyDjn6sSOZtqqDe6+ctxZ7M8yDXSRAdh2ov9qPLm10JozA2RDd80PHo4AHKtNd70TYRvst6Gi09slDa9eUSvNsBY0dwyUjxDTd1Wx6onpDG39arFB1krs/xFDY3geAHgZsN+oRAVCcLktMbo13+f4F+HY9GL0QSGw5Sw3hKRetjJ7CwbLyQ6Tvq6u8oS0iFd8OU9/cqW7jQGxz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(19092799006)(23010399003)(1800799024)(366016)(376014)(261102123227099003)(261009223027099003)(261022075727099003)(261021121427099003)(261021123027099003)(261022105027099003)(261028144727099003)(261026140227099003)(261026121527099003)(11063799006)(56012099006)(6133799003)(10067099003)(4143699003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHZFRXVyd1RyMzk4NTlIS0ZucFVBSHQ0dENkY1ZQbyttTldBaUo2Vk4rc1BO?=
 =?utf-8?B?ZzZMVjZOckxvbDFocWlBUFlxYmhNL1BVYjB2ZlJxMGJCMU5wVjlDbmRINlZa?=
 =?utf-8?B?allsTFlHWnRNWUxqNG1haWlSR0d1TTJaak5URm1wbHZNK3pnVVNkYnZyNkJ0?=
 =?utf-8?B?QWFiZTQrcWY5WVVyaEhPS0dJY0I0VWhPR01QeDgydWFjdVBpUjdJR0I1bms3?=
 =?utf-8?B?TFYvMnBHZjJIOFpYOEM2RytRZzRJT3pCYnhDTlEvZDNLVVpBcGoxWmU4VUhC?=
 =?utf-8?B?b0ZJbDlwcGZ0cTRGY3MwTDNWTkZncXZ4c3lwa3JFRW11VllTV0QzN1BIMWlB?=
 =?utf-8?B?SGdmeStRSHg0aGNBNjNDSmdpeUpUTU5JaUVPYjRJOTVPdmxIeVEyZm1KeUln?=
 =?utf-8?B?aHUxc0k5cGZ5VlRzUERlV1prUUlBMTJCaG8rNHZPTzZNWnJhR2tZTWxkd1hk?=
 =?utf-8?B?WksyVWdsOGc0U01vWStQVkpZd1VhT1lMZUJwUXlCUCtPN1hhOGZRV3YwVUcw?=
 =?utf-8?B?dWJ1M0tkSTAzKzdtUlZqZW9lbE51allsYzdINGVlcE5GQ2xOM0xlbXcya2dD?=
 =?utf-8?B?WDdRZDNMTWdFU1lLaTh6SnFQMWtSZGkvSWUwTXUyZ0xwWUdZZ1pTMnVkZnc3?=
 =?utf-8?B?RG9ETlI3K0QzT2V0ME1FZHNwZ29RdzhqSy9aNm93VDZiTkE3MHJReUJLVk01?=
 =?utf-8?B?VmphTWtjQkYzaXQyM05Sd2xQOGNyZnFLOHBvWTA2SUlvNGdVT1VxdEEvZVM5?=
 =?utf-8?B?U2FYb01IV2RzK2xrMkFYY1FrU3B2dTJtS0NrZEcvR2wyTjlLT0F2VXVWU0xO?=
 =?utf-8?B?NGtXQktXY1JoY0VkVWtkOVN0VkEvOUJoT0dmZENLQ0VuZ1RTTGZqT1E0UytN?=
 =?utf-8?B?V2FvRkltVitnZEtodnBNUnd5RTJpbk1MeEs0YnZPVmFxWElBYXlWelhmRDRO?=
 =?utf-8?B?NzFKN1NqMDJRQkI0QmZDT3JhU0FLQjRRS292cDFQNkNzTDh4d3p4dmVabnF0?=
 =?utf-8?B?eVJxTVZBUDJJODdHa1pLaHNFZ2xpbjZUTjMrSXVCZFRYSUxTYjZGK1Frc3Yw?=
 =?utf-8?B?MGJtSENDMUhIU2dUR0dsVXJIdDdXVTJ5eC9JKzVtbC9jZEpmRWFPRDQ2ZkZK?=
 =?utf-8?B?cFV2c0R0RnZuSmo1UnZULzV2K1NuamkxV3BjcFpXQjJMUE5HYUpMaFU2M1BM?=
 =?utf-8?B?VlNEcEkrbm82RWx5WEZ1NXR1UUtLZGRyaDB5SXY2WjZCeWdrTThFT25QbTlv?=
 =?utf-8?B?cGlLeklKbHgxSzRXM2hNaEdxMGtLYzlDT0hLcmo0S0tvNEhFOEdrYkhzd2lR?=
 =?utf-8?B?M3hOblBCYjFEWjhTWGpnM0h6cFBxNGZMZkpPRDMyT1ZWUFhzampMemxIa3Jv?=
 =?utf-8?B?QVRYWGxTek4wMzlLT084SG5JeGdSRjR1a2pHMnpoMURvK2lES0hwQ2xqbVdZ?=
 =?utf-8?B?Z1FZcWJBaTVaZkM0NW9RaWUzWDMrOTl1eEdwWEY4aUN3M1g4TUZUZHRHcnpl?=
 =?utf-8?B?SDFJQmhnU1NjNld3dExJVmJUVjdKdEV3R0M4V3lkM254b1ZsR2xuVmFkVk5X?=
 =?utf-8?B?elJMRytZUTZteVVjclpNMnhmU2dsdlIyVjcvcFIxczAwRFNUMmhxcTdEQUlp?=
 =?utf-8?B?SEFpVi9RZkpSNjNqd3NuVzZzK3pFbTF5RnY2REt6NG5iYW41TmZzZ3Z6SW43?=
 =?utf-8?B?STc0VWFPeDZWSkNXTktYQkM3OStBR2lxZ2U5a25lOGhBV1NtL21zRmc5ejZ5?=
 =?utf-8?B?R3FkTEpjU1F3WU1CZU1DRUVQY0hIMVd6M1dOL1ZJeVdrTVFEdmNlNkVOR2c1?=
 =?utf-8?B?RlV0c0FldUJ6ajJsWENMU3ZIWFlXUWUrWHpNM2lYQlErRGdOeTBUN2N6UEVz?=
 =?utf-8?B?ZW5lU1FRa04yRG0yWlNCc1JvdC9SbFhlcmdmNVFhN1B5ajl2NW9oOGVHcUpx?=
 =?utf-8?B?L3ZPUjg1cEpiSk9HWnJIV0NFRUJMN1g1L1NBcU9TcFp6aFJHcDhmQVd5dktE?=
 =?utf-8?B?QmU4d3JFYWpjQnRNSDcyL3pzM1lISCtraHVJMlpPbzJBM2pWM0Fwa2c1UFF0?=
 =?utf-8?B?UTU5VHhQODByZERMSHNHeVhoSGlFM0hIU21EeWYwVUFzQnFCTXkwcWwzbGdz?=
 =?utf-8?B?RGlHTEZBMHJiOWNHdFVuTWFmU0ZhZk0yQmhSMEpyb01BMDNiR1B6N0dNalNO?=
 =?utf-8?B?RCtSZlFZMHI3QkdYN2h4UkpmL1hoVkJZaVVpV3lpU2Q3VXRXKzkzUWJRczBP?=
 =?utf-8?B?YVVyNFQxNnVTTVUrVDFzN1NKWWFRUWNKNkw4YXdjNm5GY2ZWVGFoNkdCUllR?=
 =?utf-8?B?NU5jaENZRVNIOUhWbTZiSHp0ZmlYeXRsSmloeDBoRXJoM2Z4LzlFNVRRK2pP?=
 =?utf-8?Q?DtnGLMQGX74kInIOsxWr0uuHfd9KneYDmvoKe/0yRc9Ks?=
X-MS-Exchange-AntiSpam-MessageData-1: p4zjSW5Cw9exzVafPcUrxpN23w2jB+ROdRU=
X-Exchange-RoutingPolicyChecked:
	X6qmoxL2edfT70Cte6RAT7XJhtN66Fc/zf8UzBEI4GT1RPlgvGf5gfIGAyxKDAogJy1dby3PKz/hewixwbcmIOGXEF6GHL7CLJ77a17qXN84etV1R42sFaWxVCzH/w4jvxNu/1XSDppeQBgatCaYpBtI/9N6OnSYOqOPdx/o96wza256igT/aNrDFs3ih8gm25zeYp21GhLiT2kJtLv5Ns55nowBCrbKEF6rRo7JfCCRlvM/5tq9MetSYxkq6vmcZF0d4ug7/JdLO28mQxBL21vvmj2VJlTtvlcsSzWobXq36mRr8bV1vaQwDpqsHVAY2gwecBikXrHWokQoZyf70A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2om4hogFCwcDCmGE39BiLErUG+WBnxlV7GV4buD5gI8NP2Kp7fZF1umrIKd1xyAYZ+7EEko444gGpRGPmWIKeelzBsDo5BBhfZFdrOnljMqUjx0bacZjj4bMbi0L3HAMdMqPreXre8z9yqCZwxGuKSEOrPAJaIGNDzv+JAeSXJ/luJkWGNzvJyAq1JdOclbLQYunmy+Wq9VwEvr4ngaMR+F7/8mvOSXLGZ1Xe2PCNBqUpI3laDzApOXQN/R3UX50OYh5BaLt1KBS7BH5UpXdCs7OVq0GS3roxe+so5RXcfcUfvUww4Anl0TTm71dv+BmYtOfdlv170Cm1/DW4yng4yedRYeeKIKTjwuYr4CbW4GOHp68+4buPMMhhj7XTzwH0Qv0D8hdfxCSKvAMNdjkmjRK8vsYrQmVS/p1DCV9VpTPb5NkaZ4+65oO3G5TjaZL6TGqrwN4EOu42iylMQuKN4uFE0M//1D/mVhGBSKnUI4GsUcmdVFn7lTRkmKNJ3QbU7FzAgRpNWNY5dJOHhX8I2hYI77VeWqOy+vG5RAKEbYE7G8Ux9kbdjb4mRhPgmjRUDbRMFMqSAQ3fHJDNZKOXvxkIqqNlN5CAXx9C3ND//5UYg7fbo1CTGNDW8ERnsfW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d758bec-2a08-4c38-c508-08df3c298ecb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 17:15:29.8457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNWjllrUwmgCblv/uB6zZlxuYsp9ww7NvV0XzXYcpmPqSuJUmNX3JZc42/Hth1mGOhuGnlX/kozZCuBQo6noY6z623FOsI4YpVDHpn6FWh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB9931

On 11/6/26 6:12 PM, Boris Burkov wrote:
> On Wed, Oct 28, 2026 at 07:20:46PM +0100, Johannes Thumshirn wrote:
>> At the moment, zoned btrfs places doesn't distinguish between DATA and
>> METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
>> METADATA and SYSTEM block-groups can end up on sequential write only
>> zones of a drive. This adds a lot of complexity, as we can only append
>> to these zones (and not perform random writes) and for METADATA we need
>> to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().
>>
>> Also the write stream for METADATA is not allowed to have any "holes" in
>> it and must be aligned to the write pointer, which was a source of hard
>> to fix bugs in the past.
>>
>> This series introduces a split in the block-group allocation path on
>> zoned filesystems. For METADATA and SYSTEM block-groups try to place
>> them on conventional zones if the device has them and enough are free.
>> Then change the allocation in these block-groups from the zoned
>> allocator to the unclustered allocator. The reverse is done for DATA
> This sounds awesome!
>
> QQ: Why unclustered? I believe metadata generally uses the clustered
> allocator in non-zoned.

It seemed easier :D and I didn't realise metadata uses clustered. But 
yes I think we should align, I want zoned to be as close to regular as 
possible.


> Working on reviewing the series now :)
>
>> block-groups, which can be trivially written on sequential write
>> required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
>> a high queue-depth.
>>
>> In addition to this, this series reworks how garbage collection works in
>> zoned btrfs by a tackling the remaining accounting problems and
>> relocation still being triggered not timely enough to evacuate the space
>> the user write needs.
>>
>> NOTE: this is a combination of
>> https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
>> and
>> https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
>>
>> Because it makes more sense to see both patchset as a single feature.
>>
>> Changes to v5:
>> - Don't overwrite ffe_ctl->policy, pick the allocator per block-group
>> - Retry without empty_size in LOOP_NO_EMPTY_SIZE on zoned as well, so non
>>    append only block-groups don't hit a premature ENOSPC
>> - Perform space_info migration only on ro block-groups
>> - Only set data_reloc_bg under relocation_bg_lock if it isn't set yet and
>>    undo the space_info migration otherwise
>> - Skip a block-group in do_allocation_zoned() instead of ASSERT()ing when
>>    data_reloc_bg points to a different block-group, and only clear
>>    data_reloc_bg if it points to the current block-group
>> - Don't account bytes_super twice when moving a block-group between
>>    space_infos
>> - Return the free space of a reset block-group to its current space_info
>>    if promoting it to the relocation target fails
>> - Reword commit messages of "use the regular allocator for conventional
>>    metadata block groups" and "return finished relocation block groups to
>>    the data space_info"
>>
>> Changes to v4:
>> - Fixup broken rebase
>>
>> Changes to v3:
>> - Fix the active-zone reservation race
>> - defer RAID activity publication until all stripe write pointers and
>>    capacities have been validated.
>>
>> Johannes Thumshirn (25):
>>    btrfs: zoned: fix possible race for reserved_active_zones
>>    btrfs: zoned: don't activate conventional zones of mixed block groups
>>    btrfs: zoned: skip the append only metadata writeback path for
>>      conventional block groups
>>    btrfs: zoned: never activate conventional metadata block groups
>>    btrfs: zoned: use the regular allocator for conventional metadata
>>      block groups
>>    btrfs: zoned: only take the metadata IO lock for append only block
>>      groups
>>    btrfs: zoned: allow restricting the dev extent search to a zone type
>>    btrfs: zoned: prefer conventional zones for metadata chunks
>>    btrfs: zoned: use plain mutex lock in check_bg_is_active
>>    btrfs: zoned: use plain mutex lock in
>>      btrfs_zoned_release_dirty_metadata
>>    btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
>>    btrfs: zoned: prefer sequential zones for data chunks
>>    btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
>>    btrfs: zoned: don't count in-flight data as available in statfs
>>    btrfs: zoned: don't recheck the reclaim threshold of full zoned
>>      block-groups
>>    btrfs: zoned: don't account superblock zones as available data space
>>    btrfs: zoned: factor out resetting a block group in place
>>    btrfs: zoned: prepare reserving the data relocation block group at
>>      runtime
>>    btrfs: zoned: promote reset data block groups to the relocation target
>>    btrfs: zoned: return finished relocation block groups to the data
>>      space_info
>>    btrfs: zoned: reuse block groups emptied by reclaim as relocation
>>      target
>>    btrfs: add btrfs_bg_type_to_num_stripes
>>    btrfs: zoned: keep a zone free for relocation when allocating data
>>      chunks
>>    btrfs: zoned: don't count the relocation zone reserve as available in
>>      statfs
>>    btrfs: zoned: provide zoned specific reclaim sweep
>>
>>   fs/btrfs/block-group.c       |  56 ++-
>>   fs/btrfs/block-group.h       |   2 +
>>   fs/btrfs/extent-tree.c       |  50 +-
>>   fs/btrfs/extent_io.c         |  84 ++--
>>   fs/btrfs/extent_io.h         |   2 +
>>   fs/btrfs/free-space-cache.c  |  23 +-
>>   fs/btrfs/fs.h                |   2 +
>>   fs/btrfs/space-info.c        |   3 +-
>>   fs/btrfs/super.c             |  30 +-
>>   fs/btrfs/tests/zoned-tests.c |  16 +
>>   fs/btrfs/volumes.c           | 107 ++++-
>>   fs/btrfs/volumes.h           |   1 +
>>   fs/btrfs/zoned.c             | 893 ++++++++++++++++++++++++++++-------
>>   fs/btrfs/zoned.h             | 118 ++++-
>>   14 files changed, 1115 insertions(+), 272 deletions(-)
>>
>> -- 
>> 2.56.0
>>

