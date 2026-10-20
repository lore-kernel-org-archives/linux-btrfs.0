Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792494120;
	b=W2woxe62aJWhdzeGO81I0wx9Ys3gF9oqY1gpUNbQeZDl08XGfK7vc38yl76aQ+g42mup
	 Fk9aIa16H1+Hn6B3U48RKLN22Qk3yCgBJSo9G3B6yKcVzwCHO/6wdI+6dZ131hHd71qBv
	 ZBE2gSXlXZRG5LYpG424r6iQwdTvCrjtUxQD1kgXYpRCOp0aigTdnQ2q1kKQUwPkMhTRC
	 yOeFmZnxq/VVkvTVq1ifgvS6wHAq4k1G0KHIPDGYTZ4dNZ+EXqDuBYY849ewiJRTIKNtB
	 LQlzv+WWL7SGot1ujyMBGe52395ImKCGS4ubOxuN39PhiY+XXl73hHoh+BL6njEb59A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792494120;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=zl5bn7Ng0G7w6TOPbI882OUo5Jg+F0unHhBGMW9U9sg=;
	b=RhX5VJCFPTi705bUn7LCWbP3OlfIyyUqlWgqQFHCqJb9yV+e8PEt53jU6UAv8Vn16xX6
	 ALgLrVR3wBpXVX6a6H2l14pceW2/mV5UnMPtn2OuMImzSF1XI7nB09Ea8/2mG+yNt2zks
	 C4umgzuW0cVbaE6hZ7/x2sHPV+VBXH2PojceVxkcCGNy2vuj4O0fXzBGP4NswBr1qIZE7
	 fsLsCc/vg4E9isKfTyTU+bgVGEcpgvohptNbeJITefwDiaFy3OJPOKRkZvIJhYjcHZ05M
	 +BjikmnOGnENwNoqLLhyVqq7dpsJq6gJ79BcqdFF6W1zGXaIA56LdcP3dunQuGtPtMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XKt3y11Y;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=iB3PGGGG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EDF606A319
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 11:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16EDF606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XKt3y11Y;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=iB3PGGGG
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792494120; x=1824030120;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=cNuhowGaA6Mb7/zCNOnegH/UYzwRWCF6gPDTdoutDAU=;
  b=XKt3y11YSIbGE32FtO5Lp4TyLA7J85VI7ylwUwxQ3k6inLSSbbctB9Ei
   KS5BvJZrfMMzFJX6bxhLOTFlCTyJ4oCcucClGDF3Ti0P6WVdPpiMBf4ap
   r87ejeP87igW9lSLucIHRhTxEv7aVn1XIqeSrx2nKSQJ7mxCQ3ZNdDOXi
   E7SdioCJ3zgvDFyhxd/62ibk3jQIm8TV9iKpVYz70i3PQdLiE1YCMKbvX
   m4bY6GVM8k74DlGVjBXG0oJHP+yFkMO0WFVKUSGMECZgXvNRBIQmHVZOv
   BORWq6J/Z5ZzuHRSYjd0wQgZjQi6hUG9ubVj6nIGovdV2UhcGtfPIS8xu
   g==;
X-CSE-ConnectionGUID: 4/UhtHzZRDS7TdA0n6qPfg==
X-CSE-MsgGUID: IEdONOc8RcmbrVNE+raKBg==
X-IronPort-AV: E=Sophos;i="6.27,168,1786982400"; 
   d="scan'208";a="158432731"
Received: from mail-eastus2azon11011014.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.14])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2026 19:01:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rA2lvtsvQGcPOdVr7joIAYS9z/xKufkTyu2IvW0/b7caj/OT0LNlz54UvVpWCglEJAsBw8+U0ATkGiLPg3VbT7HsddXAszHQsBXDBzP20BeQuh0ZFcY5XP/ea0Wi/IECoKg/BWrhMeJVZrZboa0W7bFA1aka1FB/Po1n9qW3ma+A9oRYFrB/Y+VKv3rniHRRYaE+7+wNGZajThseh+ju2Y2aopIVOZwVqfPUKCWraDNq6qZiBPMoaZLYtKZzyJg5r7BL0/lZtXA+yDcZo9LFtrv5G0RAFX/PA/jIC1XBs7UF5Nm4fu5oXooOw1vza6iUy8Ft6aRPgejtLL0e47j6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zl5bn7Ng0G7w6TOPbI882OUo5Jg+F0unHhBGMW9U9sg=;
 b=ED7aG+8E6tuvscl9X5sNSukKEy4BwNsMYoKD3Sfv1IAiKQT3iqscid3kM0hRMQTeht+XXRl2YNhFwNaSMx5mfyfII+7iUuM8NxqlxwG56Bm/ss1EGvP+8Wb7pcfjyh7qzGu87rgNiErBOQIrOmlbYDgq+ncUSri6MHfAFj9ABKx0BDMiZa1UyYhpP7tIhOX26M3uQal+0UIDV7vxDAy+TG994BUPI/HZCZUZWaIhwgxWnNRWbzfQ0f4btiB9m0xm4ho0x2DABWaV7Olbagj6+zJDb8tRajgJc20pcH9vFF/5Mo7C1ihC8mDKkch0BRyeaDrONzGIkiRUF+ZVP4bhCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zl5bn7Ng0G7w6TOPbI882OUo5Jg+F0unHhBGMW9U9sg=;
 b=iB3PGGGGYP3u4dSEwIlxA+pYcVCh4UXzrDG7I7ZXRLKElrrbRNKatKz2R9t8kD+CwqNCn1LJ/ru/kSiue8g2WBU4goW+erNWyBrUH2IeHWBZJ+0sfYXCF5fPxaolKsHeVvS9Bt6URfq7Tep9+bwBIiKJTzrILCbdFlW/d2ngCEg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV2PR04MB9951.namprd04.prod.outlook.com (2603:10b6:408:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 11:01:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 11:01:56 +0000
Message-ID: <d3885d3f-c7f9-4706-a1a6-e22a2b4ff35b@wdc.com>
Date: Tue, 20 Oct 2026 13:01:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] btrfs: change scrub to use stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <5413079aa6e5031a98157e33ec23a5962d2cb590.1792391732.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <5413079aa6e5031a98157e33ec23a5962d2cb590.1792391732.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0283.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::12) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV2PR04MB9951:EE_
X-MS-Office365-Filtering-Correlation-Id: cb2d596c-5dd4-497c-d1a9-08df2e998e44
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|10070799003|23010399003|376014|1800799024|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 38MVOXGdqgQykgAADDYvsqDc2a556wg/s2fDcPM11fOK2y/RnL0gUEZLehpMASYZg1AJx7GzClFEfpYCkJcLo21Alp8ZqO7GRBObHAaCEJtauaqM2BOzzE+ebcafwOh4TVRcvAUvQNGavn495aWCJ40LWS5okSc6ZIm61nLt+QWiXp3MpM1XHAIM9As842IUedzyOnOBfC3bKIrLM58zuJClyU5qjmk/x7nqmDdcyVL78q0bZAWJ6wI81DA6yqjP3xOzh1G6qDBSyY2auKOETJoOmTDPxegr9b2usXgnfPFScpUistNdxdUF6xMr9xfHIrgnRG7PumcmrXSO456iKJOlNAhCRXj5Gmg+AnQw2xeXL9tn/Kg8mVNSNaz1bxAqLO2hQD+P9/uRrUQu1yj4dFLrgad+Qp/GfkYYydIy160n+KtUuWPKZR9r98C8OisiomY98iad6cs5CkeHKeiioQkmY+mt7j3FbVFx0VgrX8PyqyPJbZc1InFqnRLO/P/y1bNTMMBItGmoKl787PuHcXdWn3QJOVa4fjY0H6S+UlDAp+iv1yTr1Cph/ImrZFMBN5XGo5JD3u+t6ufa8NLcEjIpIIOwVq5tF4xF73qdk1oZwxT77JocpwF/Q5s2itBqPWnajg4PVndZSzWHMZSXwRIt5TGOyH+FCD/jZY8dq0o=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(10070799003)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?b1JNbUNHOGE3eXZYZTRiSUtBZmlEUW52dnVMaU9LVjI1d0FNSEluc1JyeVlS?=
 =?utf-8?B?VlVYaWRYQ0VPUS9vaVE2dXdPaExDcUpOTU9FUEJqWlJEcFpROHNhRSsyYnlm?=
 =?utf-8?B?ZkVSOWpuRTVOMGJTenV3TXB1Q2Y1aHlzaU00emhoWWFBSVN0YU5SQXRjT2lp?=
 =?utf-8?B?d25pUmh4SjFscnptVnBnVWg1NHBMQVQ0ZWM1Vk1ldS81NnhHY0gvck5DR2N0?=
 =?utf-8?B?b3dyNFBtMWdlQ0pWTE10amdmbzhDcnZ6SmFVWHNMMHlFMEcxclpScG1LT2pl?=
 =?utf-8?B?a3hWL29yZGM1a0lJUG1JWUl3RDJGQUhnMmNMQWRTQ1JINkc4dW1oQzc4dmJu?=
 =?utf-8?B?UVFrMFpteitqQ2pVU3A5Q0ZyVW5qKys0UXU4azI2RTZTVThYMVdkdjRJV3ZD?=
 =?utf-8?B?UE13M1VuZ0RhYXFuQTRjL1Rqb3hzVVZIbVp6cHQvYWxteXUyWG9kVElZN25y?=
 =?utf-8?B?aWF0VmFaUzM5OW1WNFRoVytGa25LK3RGVHlMRUh5TXdsbFhzMWNLb1crZWto?=
 =?utf-8?B?YTQ1djZHVWdLV1BHWDlTcTdPeTFOcFNjTEtyVU9HcDd1REVTRFEvYVBOcEZl?=
 =?utf-8?B?YzlmVWpvWGc0R0tlaGJOT09FUEVIWU1aN2NWWTBMdWZLRUMydXltaGg4L0hx?=
 =?utf-8?B?SER4MDM0MWxBaDNtZmtnQUxQS1hLZDN4Uy9GVFBFSXRXT1gxVldiMjZPSFE2?=
 =?utf-8?B?R3FPZDU1dmVGZ2l0cll6N3c4VjRCWFBrSnFOekVtcERUQy8ySFBva3hjbllN?=
 =?utf-8?B?UTYwRWswSnlLMnArUlFZY2tFdWMxSUExa0lWUVVJL1R4UjI0alJnYXBSWFJa?=
 =?utf-8?B?Vit2Y3BKd2VGMndIVUE3cEo3UHpuOFdWWEs5ZEsxc3lIa1gvcDBVOFhtSE9K?=
 =?utf-8?B?eFNuZHlUdWtNaWZXZ1E0VXBOeEthV2VaVDhobHMrazFXczNMQW5Fc2p6ams2?=
 =?utf-8?B?OUJrNmFNTWlZcmZUeG91RWZNVy9Iblg5QlRoa3hyZ205OG9BajlrRStYWEpH?=
 =?utf-8?B?bnJ3T0xQMnVHeEI4cWNSeXZsa2dZcGJPdGVrNFhCL2lDRzBpQ3JmUkZqbmpm?=
 =?utf-8?B?VVZwdjFZUDdTTmgydVQ0R010akxFcEE5NGprT2xYSHF0M1psV3BIWjJBSVBa?=
 =?utf-8?B?bGtjbnpPdnFOSFR1NHBPWGpaVnkrU0dqcmN3WG5EZ0s4NmJ4cis0THJzMEJv?=
 =?utf-8?B?QUlNQTVyQkI3VG4wQXpBcGJQWklSZVE3b0xncm5IMW5pSiswRitKb3VOT1Ay?=
 =?utf-8?B?UDhJcFNCc1dZM0tSMnducWV0UlhMVTZpZkQ1ejJOcTA1UkpjYTROdWErV1Bh?=
 =?utf-8?B?K1dFamRrcEp1R1FFQ2xqODNKZGJ0RDZabU9kWEttNk1NVmkrRlNwMDd2NjVQ?=
 =?utf-8?B?dVFWWlZvb1pKR281bHZYZGMvQ2IvKzZSTDB4bk5yVlc5NDdubmxHcHpvZlJ4?=
 =?utf-8?B?ZlRXT1hjODVvYm1Ma3VhTXpKY0dlNzFtMUowdkdNaEF0MklraTVKRUc0RHlQ?=
 =?utf-8?B?MVlvVlYvblU3S3ZKMUZ6bDFNUHN1dnRCWS94cFEyZWZhVmlUZUV3ZFozZk1P?=
 =?utf-8?B?MGpxOVlORXFvVURVMm9CMkJoNUt5cHYzNW1jenFJSzJwRlZzYXJUNXFuVWlH?=
 =?utf-8?B?ZWlwRDBubHRCVFBBZG00RE82WDlVSlBpWlJ3NTM5ek5aVzcrWTQ3ZnZSS0l3?=
 =?utf-8?B?TWUvazRZYjd6UWsvTFBVNC9udUhXK2dkZ2xqMnEwRVV1NXJLMFJ0cy9rUlVk?=
 =?utf-8?B?Ry81dmpaYi91WGJxY2lyK1Q1WlZ2eFMyLzM5dXUyL1BFQStpUXFwWHlzV2ly?=
 =?utf-8?B?ZHJKb0h2Qkt2RUpFVllhTFBrdGFOTGFMTTdQaTVHc0JEQWlPM1dmZzBHRkZo?=
 =?utf-8?B?U2FBTVpVeS9lVkVKMEdNZFpkMEdQWWVyRUI1a21MSjBDbUVOd3ovSXBpZi9C?=
 =?utf-8?B?T09PUGo3eDRxdmZ2V20rRWhldmFVTDFpdld0OEk4VDZxMVIyaU9yK2tVdlB0?=
 =?utf-8?B?amxTcXlhaXljdnBKNlp1TjBlWmxoOTd6MVU3VGNlTHljb2RmRjN5RmdCRHZM?=
 =?utf-8?B?MGFxbmNsdGZrbEZjeUZhL3NMc3dCYjdLaWpmRnl0R3lRS1IzYzdFVmtYMzVh?=
 =?utf-8?B?c3ZDWjZ6clM1ZVBNNllvWjZBQUxzOG1HVFg3NnlXSkZJcnFud1BBb1g2SndP?=
 =?utf-8?B?SGJSbjhGQnhYR3RJMG1uZ0VVQWk5RjdyQW1TQU1FNDNSaU9ZVFczZ1RqeXpS?=
 =?utf-8?B?OEdVaUZ1L3MyQWtMd0JNUVBJNFZlMHlpRDhVMWhxQ1poOTdlbndhaGVQenFV?=
 =?utf-8?B?Mm9wN1FIcHVucldkaXlXUnFQNWhMRG01ODVlcUJLM3dXVXk3SHJoUlh6eXh6?=
 =?utf-8?Q?ErCTGSkcJ3QjtPisIJv0r5Cs9LNVO0+IEQM4MoNN8f6NH?=
X-MS-Exchange-AntiSpam-MessageData-1: UQbkoJHKByQqcNkT1pwyQ6yj4RyywQjOPqI=
X-Exchange-RoutingPolicyChecked:
	IRPLsVsldBPaUscdAVSPKsZaCo79DldvgARJNQzDaZ9HmKRPcQs0hC+yfstwtkRomrPKsAI3acygHd9742IFO7IETe/GxLJdkRd8DaoP1kwv6Is2mtPUQNDEdknVnunwl6ty4A74qh3bNlOwUwcwyvst5r+EjR5q+iwjRAboFGLFHWFa6GSGh8WnuVdvO28AQGOREA+UebxuwtXiX9AwbesYdma+B6fll7bCPhHEtEBqSwgfzEq9QhGSqHpw9rOLww4j2wWxxC4xdHWpN2lzZ4vbC4fXsskMIqfFqzVDGAtuTZmtRI0enJe+pFI9+45bCFC7slO3TNkeC3ozqNewwQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ydECBkD36j816hEcCWvO5gEjwHaV2ueuIwlPF18lA5qXr9kywlxljRohKhFtIJ5QoUdhiPPWp40zM9FbXRsimmehXBrXrh59txhNlU0XlCSI4eCvZlrlNFCE2W1Pk2mVAqEX7Jo+VUa7ASTxb3+ou2C2kCc5IKAG1x4Y9XAQpQXPFofgDewANJe8X/btAJO8BSQ67t74NyujsbIh/0ZMCaa2Npy+um+lACT3ToJtDmUB1dh82hfRsa6PO9sT0LvfAPGV+Ajh0iLALpP4/oy5FclEnr+ZRJnLT/KIB9FRRRSo1d7N+ZS9Y3FgNYLzT9Ad6Ah+lKpx6NxAXKPeyybu33wSIG06mycuvQ6eNb4Av7HT4ZzeaEJxcKp1FzI7A+OOs0W5nIvR0Q63ct/AgZxt0Tma+w5v+nKoVHXAU/VO3HIDE/KJ7hKE5qLlajoRYpKKm5idEcMKLheyH9rhYGI5d5FCm5SxUVZpLxixjTU71P8y+U75iRBGoI1yaHBOT03VJSYkWWDQAX8MF1lpATpPAc3R37yQ2zQpWYx2g/2NW2jrocij2bRRL0zZ/mRZV2Uodu+rlcvzILKEefZgM8IT6c6rhVKSAX4TC2N4KCqy0AJ8pkBcZMhol2Bem3db6Zgz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb2d596c-5dd4-497c-d1a9-08df2e998e44
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 11:01:56.3938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLXbaR9VMleord2zm+ap9vyvVjr2haardp5cMFeiaZM0lxgv5OXdVLLGBd8BL9JeGsHNiPHvDiSfjP88185mZmiCA0UEaXjynZL+wqvKSZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB9951

On 19.10.26 08:40, Qu Wenruo wrote:
>   
>   static struct btrfs_bio *alloc_scrub_bbio(struct btrfs_fs_info *fs_info,
>   					  blk_opf_t opf,
> -					  u64 logical,
> +					  u64 logical, u32 stripe_len,
>   					  btrfs_bio_end_io_t end_io, void *private)
>   {
All callers of alloc_scrub_bbio() pass a scrub_stripe as 'private'. Why 
not change 'void *private' to 'struct scrub_stripe *stripe' and access 
'stripe_len' from there?

