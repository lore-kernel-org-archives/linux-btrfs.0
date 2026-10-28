Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211698;
	b=EklE5LiZVP/YYZeYeMLHYvYZy9P0sq+B+yfV4svZCI7sLcOwE8qRX6+JPJUB7aePWLJr
	 mK5wcLruB/c7yRCrrlIGdKy50Naif6KoEiEqafXTwZcoX3XjD0Ywyq3UcWcbyG7+72IMP
	 hr3N5ubzlhSzLyYr2yxvWMrgHPG1zFlUdpo0AAbPetr8P58S29/OzfUEwIfaFQCCkLbLW
	 KX/xWC0WbtU7ZQt++T2vToIHF9O6Nb/2WVOtV3w/PApGjfVn2OwPo8CgtqDLumWbd5MU3
	 qvOdfi5fV14JZBwu84/bBINjKJjF0bMjou8Fhv8UHLCDR3EdilsDRNSb2ShJn1Hw+Ag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211698;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=GjL9ry0/uDacaMMCIdT2HJjstFj3dLcI+5Myt6so+ns=;
	b=jnD7DMOeSvSw96uEAfTYdLauSC4u49gU0kKLnV+viotitJdYSfTm382ZBtQo656dW2ZX
	 hzWO9PYcsXOc2lbeWrVDQSF2mNgMHTgMSBS/aqzfZqqJe1Uttbq7LHYpkDTTlQuqveYlb
	 tShftaiAwqhEuPZIFWlkyChybvyVStx32eMEYsKcDt9EjpB5IaRin9+FTsf8TqoGm7GVf
	 UKgjJ6TdRTDYAGhEa36vg1Qv8qhmZV2+pK6zsP7NjvE4zXT0p1mdp8kzeZ8slzMosCag8
	 DoGj8gnvo33bgVg7lpwMeZ2LIfSJr8e8MBsPAqAXyhYpf2p4uuBV0aMIpSUBFRJwabA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lVmvWutG;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=DPbBm2jR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3097F60A2603
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3097F60A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lVmvWutG;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=DPbBm2jR
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211699; x=1824747699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1WT9OrhkAwWqq626b6saOWhd+yorzUoBi/n9Z4/gOHg=;
  b=lVmvWutGCMCYFf47mQha3OXTZtcE97ZtT4+DBEEDNqK5Dsy6Vd/d/f4Q
   7uTmKX3rEwvqmc+4OD50wgplLqKYz7AE8B98LKsAuOQxKLgUz7FOnERkd
   j4hJkWytRr8bNVq+yv6tJa5bvizajgVIUC49FplCC9aKoPRSqI6edZETV
   RcUujHY68A397hRxNUl2+7tXlmeyuOLufN/HmF3MumxyyUTSOWYGAMwOs
   Yyy1DLGOK8K5BOX++nRe2hMQ4isVdhxL3mWelfLBw7IbHlCxCPBEyHYkn
   pr8cUVRWmNkv8lGINXvtNa/LozBH45uq/yYA9AjihK2Y3f70VbLYMFOnn
   A==;
X-CSE-ConnectionGUID: etkN5xLZQUCEEz73pexkUQ==
X-CSE-MsgGUID: 6HOSAUXATq+wLBKrVF/o+Q==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159234666"
Received: from mail-westcentralusazon11013067.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4rr/0b0yovn75ClFjyMZAG5StTXIqjSG7GFdAM0LuuLd6kE1eUpYb9UOPw7iZ7tpGXD9TF4vHPj+ufs7zGQTY2S0EMGuT5SJ1f3cPxLeyiNPDpfmPTElzcNfF8Wm0d8vNrwHSNBEWYjGXIX0BEH/w9xWv9F9PFEgdbDCr9PEMB1/BxLfbIoeWmNcgYqK7C1dhk0sjzKV//WESQ/dyIQYrCQ7gzIkIZHMchsj3pwFiFnrEJT84VNOnJZmg7dFvtrsuElxjcpo+Qf5WFxwupg7gGj4lWpiitWrJc1AvWKkCKTXiWZnKjPPGJwQf4fr6XU4Nx4217ZTyWBWgtsp3+0Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjL9ry0/uDacaMMCIdT2HJjstFj3dLcI+5Myt6so+ns=;
 b=U3/pu1OT9X1yYrcSDrEL//3kZ4BbpKiqJLePvEIt3lmDNuAtWmuVhcLP+M99j9wAbuEYUA8D2WzbIGfyZEMbOh9U7O7bUf6BQloTUsWBJKGKBMZvVC9mW2A4HSzZfWYyg/Luk4iPVMEHXQcrq/lbsECrJOldB+QZf3B9w5MbbCoONdDEg5ShGlDyW1tU8kW9W7vPCmxk2g7FSd/zVwRU9bCNyux1Ybtn7fllmgpZ936Evv+PbTcq8VJf4RhRXi6B19kja2MLKkDhZiqryGNSdpq6aSkWwA4uoahJi+fLLiZdKWQNBiQ71fsLrGfmnjVZXGjzlJ/sMLxWNxHkIK24PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjL9ry0/uDacaMMCIdT2HJjstFj3dLcI+5Myt6so+ns=;
 b=DPbBm2jRCP73d4ayOkTXA1S4PWRhYC9lJ408tS4cbdxNYjI8D8r3gDi4msXENDcTX5zdWQVky55h5SA1flzXYGVQEs8Urx1o+CdIOKZoe+gdnKPE1wCetku6N8Uf/EDmskDYfwmtIFw3p45r0u1tyfFkTJ2ANHkx/0HFBp+SsqY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB8753.namprd04.prod.outlook.com (2603:10b6:510:234::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:34 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 05/25] btrfs: zoned: use the regular allocator for conventional metadata block groups
Date: Wed, 28 Oct 2026 19:20:51 +0100
Message-ID: <20261028182111.160492-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH7PR04MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: 934e5b57-df3c-4f9e-9064-08df35204c26
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|10070799003|376014|19092799006|261028144727099003|11063799006|56012099006|261009223027099003|261026140227099003|261021121427099003|261026121527099003|261021123027099003|261022075727099003|10067099003|261022105027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	kP24caLawz7EZXLqNsj/1WKaUf+//yLFTEZ+pvPJ8XY2fist+bZ5RXgO4HlS/TQmIVMc6uwGRZpYLF0EABAwNKq4IRgslzrp1VHIjcUksgbgZAu0LqrS+sQfuuB7IztU4vWphNKRE32ih+v4YhYZMLZy2qMkIn5HfFGbhuLTv+mzrJuKS0optZ+OqK9c8U8IF3XtZrEITxaRRfxLWRxRmtXa6UcAE6lGtdjikjvj0PAyST3FF0qiNM1zBmS4VJaXgOGhH9ZT3oKqbKiGKvzvUhh3nX2j/DF3ESRZN8NazNij07S5ZOGrKnyhTLytkvYSSp0p2r7gCkOmTYCaJHGsTAxImgPPs/qgIfZVbZvK+wRyMa9N3rGO7BgoMr2ex2o/6wgucZ2P1bX1KMkIglZ2IHGsau217nWMcrII/5aPJzePu6lCcxBYYGXusr15zeIS+J/92ANOL4WN1YrKQAJCsJDTmgaoJ+tSNpMRJkpcYmWPPFDiTIc90plMd86ylzTgyH5/vdj6wXByX0nf3VmXeSxe43SsZ2k5fSEbf4ubJh+X9DKM4xuiqzQXmwzMncvNDZ1ZvC7X7QLc8Cu+I8fmxsDTXO66tQLmUw4tYyfEMT40zbrfsAo3NdPISyaSo12WtOywtorrYEZuemu0gZRmWPaT1tq+5hxCGRj2RXQXqZo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(10070799003)(376014)(19092799006)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026140227099003)(261021121427099003)(261026121527099003)(261021123027099003)(261022075727099003)(10067099003)(261022105027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FofwPVfNgu8fbfRQgxNPiu3OdwTowu2UMmi3EOUyXEdXqn695Pfq8RphvBUb?=
 =?us-ascii?Q?0nY2P6cSfKqrzNw0dVYMCrWyqpYMcJHe9hzTuBmDLaALpLeLq7lP3PtJQKmp?=
 =?us-ascii?Q?U57y9VQUlvQmGbrgo40bBam8kYetmxDHKuXMFJbtGsaaPhpaqglz0CZA+k7X?=
 =?us-ascii?Q?Ma1fGj9jnCODbIdmaKMeNoD/qXKjNCBbWx5nxdsPVL5Y0rS7l2a50fRTrbrQ?=
 =?us-ascii?Q?q5jgag37HF/JRTVhU8GX4jeeWEy1fjZA/QX3NEknuJYsLnIToHlZOhPmGFO7?=
 =?us-ascii?Q?BjucZXeUf4XKALntbdXh09Ji11qzcagnK/S6H6VntirLgc8hjx3pjV4jOWAm?=
 =?us-ascii?Q?yE8EDvSq5nAoxdVsQO944kvQITeupzvUOYB40sUhEN9QFh00M38bmzSyCJfH?=
 =?us-ascii?Q?s/52i3gXqF42oWFw3vrDNFq7BiWKh4bedTegeLOkfySyb9UMdUVPGJ2PTWNM?=
 =?us-ascii?Q?TveHRXVC3nYZlBhYJMsbkNCH07bT4Cgb3dx4kM2DUii6GCpTior9tRJ02c8B?=
 =?us-ascii?Q?vDEZ7YLZR2fYAYR4cE6ZVkSmwR3qrxCzJkZ0PfrHrs5c74S6p0jB1XHbljIM?=
 =?us-ascii?Q?8nGaCL7Vud3a3gGxTteQQ4Xjkr9MLoz5jq5xR0VrI4TjaDOux4dMWZYT9ADR?=
 =?us-ascii?Q?tlaazzMhU8PZlg5wwzFylH1tMLireGODOMZNt2Fn7ViAQSK29sLWpXDOktiV?=
 =?us-ascii?Q?sOB8cjAZQ0eNGvQ+UI1WgleNwoa+FwkC1wn7wV9uSMN9K5X400d1fEYAUX82?=
 =?us-ascii?Q?Xh3PQKU77NQSl/Q7+1LppLWjI5PGc8jlZ7FOLksB/xu/xA1cIh+/obdx/tvm?=
 =?us-ascii?Q?gaQpStMbN5PmWxGmzR2EiBMZHgRt+Wa7AnRO5z0Y7WAnvDNMnLMDSiZjDowU?=
 =?us-ascii?Q?nbJmW8AVra+GP/5exgyZImPMlHPjwxo4r8J2rXmsrjBf+R7qnTklf1yBo3h6?=
 =?us-ascii?Q?QZp/7j++GWVSiAXVGcZhosNCpFmUG62iSASvN33UB4jekbwED+YiTHfDFGpr?=
 =?us-ascii?Q?6AP+azJGIXkgs7vQqT1S16G+8NKIKmHdVVIemOWbCHuET2cYR0kW2X8NQSYq?=
 =?us-ascii?Q?fN8lXhYvpV+b2Up1PpHjUTI0etPKtdIccvBiINJHhkmUmCst7WIwrxBPB8wn?=
 =?us-ascii?Q?yaEMJ9oYIMcC94YjfweEp7KNGUOhhwMcUv8ZcgLQ+EAxq/OPc/EbzOxM8aTe?=
 =?us-ascii?Q?oODhSDFOTeV3Cla6KoAN5UwzpS27txpSFRxh/cvhxhl5cPBKSA0V8lCUtGmw?=
 =?us-ascii?Q?UB6nPAuBMyidOUiZjfmgqhXLiy+nbdRhRH0GkxyOUBW2WjMFIE4J93fNxW3c?=
 =?us-ascii?Q?9mTGHAzIBAQZUz25TodNWdPojNG+u19R150E1y8He8ZrNMw0tuXlLhT1I/Ju?=
 =?us-ascii?Q?VFQtoh4NKzOLC+80x4hWIDd0JL7VyMqVXLK4JRSRkGKb7XI9ATePpTZIn41Y?=
 =?us-ascii?Q?Z4ypKYuYnnK/vf6ZAPBx/jT8kq0GER10FwUzk88277wimh0xp23nqhHOiZMG?=
 =?us-ascii?Q?2+a5v2qoTh9xPACRSS5Q/bokE5GGzJ3iigVZVg7y8UE/V4OvE8ULZPA73sRL?=
 =?us-ascii?Q?pBFe5BbAzqGJQzZP0MyAkbpJuBRZ6rF8wKjFJ/XKGDln5HNddQFojEq+B+Tn?=
 =?us-ascii?Q?ELQuHaC/cfI5BlZduz+FST8rnynVY2EXn2gkrB6WkBzlB0nZqZwqHZWkOVc3?=
 =?us-ascii?Q?puF+oq6Qosg43EnFX+FpH8z8Kremm3N65neKYFQj+w9C88I4qWDBRSyVhH8j?=
 =?us-ascii?Q?YiRCI1PF0QbW7+udonuDY1XIlBf8CL4QEPVlx7tC7bKMxvYSs7nsbfh1Hpku?=
X-MS-Exchange-AntiSpam-MessageData-1: LlpWQrpyIvDpWrsknZ37oXm+U1fO3NtzakY=
X-Exchange-RoutingPolicyChecked:
	zPW1OK9jsX/xCds4A+rJboIdATcDGfrEm4tU+GHAi5e5uCgOSX3J1rW6odPeuKvMca4iqQaUf4Egxo5/78WfDfXSjx+3vW80PUfvOJIQqU4MNiGJkKgn55bBPLQ4PEEBHWSe8vFx45fJpqY/N/F2gkXVwjWxzPhmpdQaYodm7qM9kDPzGkCSX/kzTAIDgsrqe2dNb/MPE0t+ol6BB/7IY8uD3EJV+9I/bJ7VovcIzEGUf6oJF0zSDcZL29NQVIAEpaZ2+bEoCz/Tu36hdHAE997G6Pj2UpV8TAADRW/an3aKfJCx+swHD2RnNHVOYvdchuxTQqPdrKVgPf5Ozl5FSg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	INpA3d7AdorpxCMLVr8IVpekhLrBQ49zUgsxjuAEfbB+xbFFrT1HLphSgrwqMRzDMGPl7V5d4IxllqP3zwWR49DPTt8iN6XLfO5a9mJI8sFLVqeq4rCXBLucv0JxoDBUv8x/z2uGYLtJlKSSBjZvZZ4kapAmsZScD9up3O5R9REYHtsPCKCx+1d8PL6iKWQru8Vdss5DHW7bLzKAp5jVZepTQTKCtHTcV2MUUrhEZUfGCJS3LNgQGyU9poItlGqADz7E0Ja0nraktbKAHeVhp3UcRrEfCmK210O0ELccqtmklLlPpKKhrXJ0JnMAYd7cdzrbHhzOic3yXxAWHSidEGF8wHEoSGVq1YGb8DMg+b2pq/5lgHd0uU/27R2aFuewRmBi3tKaCoWiNOnXLP2KMPR3WDsKNg7rzTP8vMUwXQLooxj9jjxEIs+Yvbog18ZEdVrsbdXh2mf4rGQwqEYRFE2UV1ChO3brY5mERXlf8kZKTRsmY6yzPB/5o7fH9iltKgzyrlIJVOu2gSzZU6ixci06iTqf8iMlSpV1XUkbzFw2AYoh4I7Caf8dhxee1fY8wKcWdhFpH/vwxEOeQaxLbtoFUf0PygWRFpTeS9mpUCmXNtVjsEbF35rdi1p9xjuq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 934e5b57-df3c-4f9e-9064-08df35204c26
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:34.5129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBh1/OEqXyHC3kyvoNy/SKC/HEjoxpNpPB51UsZtLSiXswaKOXvEiIRBFutdHgyMhpJJhudj4glTyhLN63RI9PtCkKB8kG1DaMJtzPLyT1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8753

The zoned allocator hands out space strictly sequentially from
block_group::alloc_offset and accounts everything freed below it as
zone_unusable, so freed tree blocks can only be reclaimed by relocating
the whole block group.

A metadata or system block group backed by conventional zones only can
be overwritten in place, so it can use the regular free space cache and
the free space cache based (unclustered) allocator instead, and freed
tree blocks become immediately reusable.

Pick the allocation scheme per block group rather than per filesystem,
replace the filesystem wide zoned tests in the free space tracking, the
space accounting and the extent allocator with a check if the
block-group is append only.

Such block groups no longer need an allocation pointer either, so skip
calculate_alloc_pointer() for them when loading the zone info. As a
consequence they are no longer marked active and put on
fs_info::zone_active_bgs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c      | 16 ++++++++--------
 fs/btrfs/extent-tree.c      | 38 +++++++++++++++++++++++++++++--------
 fs/btrfs/free-space-cache.c | 23 +++++++++++-----------
 fs/btrfs/zoned.c            |  6 ++++++
 4 files changed, 56 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index b29070b51b92..772b6cfecaa5 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -953,8 +953,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
 	struct btrfs_caching_control *caching_ctl = NULL;
 	int ret = 0;
 
-	/* Allocator for zoned filesystems does not use the cache at all */
-	if (btrfs_is_zoned(fs_info))
+	/* The append only allocator does not use the cache at all */
+	if (btrfs_zoned_bg_is_append_only(cache))
 		return 0;
 
 	/*
@@ -1455,7 +1455,7 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
 
 	if (!ret) {
 		sinfo->bytes_readonly += num_bytes;
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes to readonly */
 			sinfo->bytes_readonly += cache->zone_unusable;
 			btrfs_space_info_update_bytes_zone_unusable(sinfo, -cache->zone_unusable);
@@ -2553,8 +2553,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	}
 
 	/*
-	 * For zoned filesystem, space after the allocation offset is the only
-	 * free space for a block group. So, we don't need any caching work.
+	 * For an append only block group, space after the allocation offset is
+	 * the only free space. So, we don't need any caching work.
 	 * btrfs_calc_zone_unusable() will set the amount of free space and
 	 * zone_unusable space.
 	 *
@@ -2564,7 +2564,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	 * in and be done with it.  This saves us _a_lot_ of time, particularly
 	 * in the full case.
 	 */
-	if (btrfs_is_zoned(info)) {
+	if (btrfs_zoned_bg_is_append_only(cache)) {
 		btrfs_calc_zone_unusable(cache);
 		/* Should not have any excluded extents. Just in case, though. */
 		btrfs_free_excluded_extents(cache);
@@ -3246,7 +3246,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable =
 				(cache->alloc_offset - cache->used - cache->pinned -
@@ -3728,7 +3728,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
-	else if (btrfs_is_zoned(cache->fs_info))
+	else if (btrfs_zoned_bg_is_append_only(cache))
 		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
 
 	space_info->bytes_reserved -= num_bytes;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..c33f724fc04a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2896,7 +2896,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 
 		if (readonly) {
 			space_info->bytes_readonly += len;
-		} else if (btrfs_is_zoned(fs_info)) {
+		} else if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Need reset before reusing in a zoned block group */
 			btrfs_space_info_update_bytes_zone_unusable(space_info, len);
 		} else if (return_free_space) {
@@ -3685,8 +3685,8 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	 * contend with.
 	 */
 
-	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags)
-		     || btrfs_is_zoned(fs_info)) {
+	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags) ||
+	    btrfs_zoned_bg_is_append_only(bg)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, true);
 		btrfs_put_block_group(bg);
 		return 0;
@@ -4037,7 +4037,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	int ret = 0;
 	bool skip = false;
 
-	ASSERT(btrfs_is_zoned(block_group->fs_info));
+	ASSERT(btrfs_zoned_bg_is_append_only(block_group));
 
 	/*
 	 * Do not allow non-tree-log blocks in the dedicated tree-log block
@@ -4191,11 +4191,28 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	return ret;
 }
 
+/*
+ * On a zoned filesystem ffe_ctl->policy is BTRFS_EXTENT_ALLOC_ZONED, but block
+ * groups that are not append only are allocated from with the regular free
+ * space cache. As prepare_allocation_zoned() does not set up a cluster, this
+ * always ends up in find_free_extent_unclustered().
+ */
+static enum btrfs_extent_allocation_policy
+bg_alloc_policy(const struct find_free_extent_ctl *ffe_ctl,
+		const struct btrfs_block_group *block_group)
+{
+	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
+	    !btrfs_zoned_bg_is_append_only(block_group))
+		return BTRFS_EXTENT_ALLOC_CLUSTERED;
+
+	return ffe_ctl->policy;
+}
+
 static int do_allocation(struct btrfs_block_group *block_group,
 			 struct find_free_extent_ctl *ffe_ctl,
 			 struct btrfs_block_group **bg_ret)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		return do_allocation_clustered(block_group, ffe_ctl, bg_ret);
 	case BTRFS_EXTENT_ALLOC_ZONED:
@@ -4209,7 +4226,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
 				struct find_free_extent_ctl *ffe_ctl,
 				bool delalloc)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		ffe_ctl->retry_uncached = false;
 		break;
@@ -4349,8 +4366,13 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 		return 1;
 
 	/* See the comments for btrfs_loop_type for an explanation of the phases. */
-	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE)
-		return -ENOSPC;
+	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
+		if (ffe_ctl->empty_size == 0 && ffe_ctl->empty_cluster == 0)
+			return -ENOSPC;
+
+		ffe_ctl->empty_size = 0;
+		ffe_ctl->empty_cluster = 0;
+	}
 
 	ffe_ctl->index = 0;
 	/*
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bff6e5b372d6..5d830a827cda 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -26,6 +26,7 @@
 #include "accessors.h"
 #include "file-item.h"
 #include "file.h"
+#include "zoned.h"
 #include "super.h"
 #include "relocation.h"
 
@@ -1370,7 +1371,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group *block_group,
 	int ret = 0;
 	u64 filter_bytes = bytes;
 
-	ASSERT(!btrfs_is_zoned(fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
 	if (!info)
@@ -1499,7 +1500,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 	if (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)
 		return 0;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -1512,7 +1513,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 int btrfs_add_free_space_unused(struct btrfs_block_group *block_group,
 				u64 bytenr, u64 size)
 {
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    false);
 
@@ -1529,7 +1530,7 @@ int btrfs_add_free_space_async_trimmed(struct btrfs_block_group *block_group,
 {
 	enum btrfs_trim_state trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -1548,7 +1549,7 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
 	int ret;
 	bool re_search = false;
 
-	if (btrfs_is_zoned(block_group->fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		/*
 		 * This can happen with conventional zones when replaying log.
 		 * Since the allocation info of tree-log nodes are not recorded
@@ -1663,10 +1664,10 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
 	int count = 0;
 
 	/*
-	 * Zoned btrfs does not use free space tree and cluster. Just print
-	 * out the free space after the allocation offset.
+	 * Append only block groups do not use free space tree and cluster.
+	 * Just print out the free space after the allocation offset.
 	 */
-	if (btrfs_is_zoned(fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		btrfs_info(fs_info, "free space %llu active %d",
 			   block_group->zone_capacity - block_group->alloc_offset,
 			   test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
@@ -1838,7 +1839,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
 	enum btrfs_trim_state align_gap_trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 	bool use_bytes_index = (offset == block_group->start);
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&ctl->tree_lock);
 	entry = find_free_space(ctl, &offset, &bytes_search,
@@ -1971,7 +1972,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 	struct rb_node *node;
 	u64 ret = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&cluster->lock);
 	if (bytes > cluster->max_size)
@@ -2789,7 +2790,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
 	int ret;
 	u64 rem = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	*trimmed = 0;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 554688fc7030..1235acda375d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1964,6 +1964,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (num_conventional > 0) {
+		if (map->num_stripes == num_conventional &&
+		    !btrfs_zoned_bg_is_append_only(cache)) {
+			cache->zone_capacity = cache->length;
+			goto out;
+		}
+
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
 			btrfs_err(fs_info,
-- 
2.56.0

