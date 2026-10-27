Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085774;
	b=i6MBIpOM0z+LKHQpRfwcN+wGwJ6NDmCIV3K0KZJeU4dK8bMlwYWoIHleoBkkAHAzNgr/
	 sZl2kAXR9HWgXSsos2wlTDWHMbrODp7uQxDjq4FwvTCQ1p+8XJJlYtO9uLRxTJ6yqAvMu
	 3Zsa1HCq/++Bd3Fmx3NkLj7Cedhc9olvwwsPJNr0WIn9et/gImIU8RJmjBNcSvlIYvmco
	 rkQMvgWDI6ek9lWvwf8ueAjgig5pty4RDZwlieffgxiVMLb2gtssOcl3YAD0F0Fk3SZwe
	 zRyP/PQuC8o8Gdj4mIB4rjUVwMCuUfdqRQqyxvfPWAsbpFR23MXqSR9Hj7wm0JQHTPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085774;
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
	bh=uHVMWPaE8EF4K2+t1gSMoKEwOUv3MOvlVkXgSmUptZ8=;
	b=YAIrFEoJnoqQYsCcGEY4MtLTKmF/CdCVk0SUSGtAKQ3sbUCtDfQGmJOqhaKFSo440f15
	 FHapX89/1NGBHfCUEyeAD205zHhuVoLZfA85C00GHMNP+oeGVZUzVxBetPtNWQ02JA1zr
	 0IgsQaalKYdQX2F+k/AJvOGDaS5XVFI5Dg677vrlSwNb7fltBNzNErKn1ly+0IRRAvcHD
	 lAQxutztIWwEMOHh/SuCpZNzNDVzAXNqIV5c4Lzj0DZxTkxlwZFCSMcjL2yQ6hD3kIrF5
	 4jm3jCv+uA6IwD4Ri7wBGgz19ssGEJV9IV5CRK3GNFb1LZ+xA12NNv73GiL3I5TTWOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QGc08evH;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rNmFMIuq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC66606A333
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BC66606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QGc08evH;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rNmFMIuq
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085775; x=1824621775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Dd6Jiuu9GY8Dv73O0hAzfbCKLH3gv7NPousNYhJuG48=;
  b=QGc08evHRWOFB3+wPrEOvUb2/uF2YXqpFf7R0KpWbMqDb8tAyQHgLYv0
   LoGfOuuJSPJX1RBX+ogWj1gMBZzTlbxy7faOIb54BBpdOR8ks4sAwZk23
   0MtobOTumzOtFYHpZ+9ESYAvj63/dsfVkYzTLXjQ88HtV/8DvgAKumDJu
   cS8gU4N5Ix6oSpU5tvI5oj/e9pJ2TAs/0JOFe7hgRUjW/vwywWqLzhtUR
   h2CRVa7m3sr2scmFIsOAYtgzdWC/852Vmgp1nVgfs36mIDpbd5pctO2uz
   EEl4MVwYR2Bm1QleYK7C67yij9/ujYe7NP9RiVuBHAKJKqK7PCxvlP61Y
   w==;
X-CSE-ConnectionGUID: PxY6vnrlRjmECG7tdxdDDQ==
X-CSE-MsgGUID: Gcwkj4klRKC5qElvHmJ9kg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="159092297"
Received: from mail-southcentralusazon11013022.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.22])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZqbPSMmDSax917DGelOb11TaPzPIgMSjdeKLZyI67dbIN/PbYAoTAIiDL+m5zn4K21lqp3n4K549dUfVZWgCJw3Fqhvr7tu+HH4Lg+LiAGlVUi/MdbapWOMZLUPbZPQMIJ6HqWelddi3WJzgcYdhgCSdd5gMmw5ijN4n240FnH+qjz4LONU3PR3mO4XCudlEv0MPXXmmE1YDaTb2lCigq8Q1j4J+m5c24x+njCMidpncU+aYBUHGy+KFyybi/v40kbIqks/Msa8M7ynhAwFPrSDVQ/fgDyVZ+kBHA5w+++VwPOmsMeouBvxyq3ptobf1UCDUeOsRFEfgv5mx4L+ueQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHVMWPaE8EF4K2+t1gSMoKEwOUv3MOvlVkXgSmUptZ8=;
 b=ynwj229Dpi7qlUvl1JdaclhvetajAISurw447uWECCh31lFTerTmuPG4S4Tb3XW/GUVpsBfsd6lv1Ktj4ZgAm2K1yqmapPllFltWAmkVqXk+pflRIGEw6hPL99d59ynLGo9yXer7IndPMUye4w6O29t5ZMlLZH7xm7E1BxwiC2ydlJGqjhdZD3Lw0fikOaLjiRfVZZ/brbB3SFK3M7vp4Oz1vHkX7N8CHH/JAxuzNZAdrnCjZZR+K8sEELbnpcs2Wi9GnmGflGriVeOFbApqP6lmVNKG8EocP4O1IPMOuzeHbRa0qoDhmlW5XG1PbJcuJjPBv7rF9TmxNf5xUdeSzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHVMWPaE8EF4K2+t1gSMoKEwOUv3MOvlVkXgSmUptZ8=;
 b=rNmFMIuq3CWJEChTDvIV/GIBtntG6WLE/av/8D7eh5jYcxYzHxV9c2WaPYf0zyCXJFQVCa7anv4hTR2nFjb0v5c4zuu7mug48PS+G3qy1JXMIc8rU3mU0Y5upxs5z2IHB8s+ovdbW63HyDimc6hslAyXZ1GXtFzgSstmo01fmWg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:52 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:52 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 05/25] btrfs: zoned: use the regular allocator for conventional metadata block groups
Date: Tue, 27 Oct 2026 08:22:11 +0100
Message-ID: <20261027072232.419318-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e2cfda-37b2-47e8-c448-08df33fb1cd4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|6133799003|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	fiREkgHjsjbn/C+qDURHvCzYS4IJIKKtHrQDbt+tuFC0FXPV2/WMHCgDRJtB14Wxnj+bz545nJggeLMYY6FVmG55773S9YcIhi5ajYyflmJeORJ84iMylaRqv9S/3dIZpaSzgMHawYxxU9I1iO/fJxPmj2rT9lFbgxXsXZFEfMq4DJ9GxU5KkjRM25wQ3HimNynJV3BFlB7u5sLH76ZVqd3FnMza3UoaZEa814cZUBV9LgMI6tuN/cET/Rlwez5m1iIja7LjrDnG7s2ZVYJI4i3nKpcm0ZHH22gU++QWzTD/25Te4j5OPDhUyHh4+WiG5UDln1mFV9mOGpmsd4meaCjPJNh+N2pR+N9Z1JzWdnK2hXkGs2IOU5l02diAMbNfhoNMTmVrX8mHqtn2ZQ2vCNyOqnJexh+YdBlEEczl3aIa3KHmVITPcxPLhJLPlHeOK5gYv56MCv0Izl/BtyBfxkDkfUi9zo3GS5tdu748dBYd/66vBBDu3i4Adia7SePPM0KQ++v+3OlMvDR/S16rpRN7O4dWM1QllVgPQDzjHjcp6JmsUx1f/CXSGMwOiAS6Tbdimj7fUHn+YX+YMYR9HqxXb/l+qz1juCUz+bKPM+qv3cYb8thbYYk6eihRa0ju0zYmZvnUrumJ9gmFfI/hi34l/yb3kMMfI22AIGNiZwA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tjsbkFOywmtmh0Kp5evd1y4zmXUeNsE9GKiS7r/BwFSD3d5VCKEj1O1/lavX?=
 =?us-ascii?Q?jl2iP/FCgp1cH3q7lY7gCvnr8r5yu1du2zxKgdiQKkC/g/YUKBXEaHU3fZEY?=
 =?us-ascii?Q?uhB912y7rSBMAATCAwvfGwNfcAHH4eEsZcKyyMgyMyv0fOfqUqGjMFxg1CKy?=
 =?us-ascii?Q?Zuxgul4JV7UOBGt+irYXiYBMm0K1TfVP5ZVwQrxmlJ+9WDgBLg12ufjyw8+s?=
 =?us-ascii?Q?NfjwBLa/EX6gTGkrrVQGCGQVkDM6Rx6cuWuJP1rnZVvu3AiXqdT/NS1lBBWC?=
 =?us-ascii?Q?1OgI2o9oTAhi97O4eZAH92QcmhfkOsjBgVBYrNVXaTHMjOyFfm8gjyqy4r4P?=
 =?us-ascii?Q?xi/KwvVmeO9fFI/NQPMriwoycQcyATfbUVvkQ1UkLT0Hc0kbxK6bk5Fn2R2z?=
 =?us-ascii?Q?yNkew5c52iQTEZoahO8zFEX4aLdJ8ajUKf+06SiwobVQWEk45OBqvu3oJ8K2?=
 =?us-ascii?Q?MqF3zX5ndmb7swP+78NvGFih7mpWWqgyzqX6LLul1NR0qawRoQP1VWKz/Rub?=
 =?us-ascii?Q?q+G3+zAy2e9tDIh91m9SlXi7NThE0aMpTwbwPlItZLmqYlt4HvY6DIsRJ/lR?=
 =?us-ascii?Q?oJEaXn7fLNx/lvmuee8sZZ0PhVeIj+qw3+Tp8/c9fco75pnOUmvGP2A3KzIM?=
 =?us-ascii?Q?KAd9L8QUAJrEbWX+6cjxHu1aQlkGG1AGzPVSptb91uWu0mp6QZzX5vAcx3Tc?=
 =?us-ascii?Q?pYL3742xyyd/uE13xAGQPllXxPy4HVullC2JI7IQnew2OZQvSKOFcnyOj14w?=
 =?us-ascii?Q?qhqieLaF0nPmaYVFWm6vQUGEUzg6wWJHf9TtKF2NFqeTr52ksSQ8LsDF6+M3?=
 =?us-ascii?Q?C8x1WdRGuaPK2aoTyBDXOaH5nzpCV3a4RbMAZbbnV8Ap9eCVlm3CPu/ik47G?=
 =?us-ascii?Q?QrHCgzgdPnFjNS7sSnUSpiO3JGcaMvyCgnggvpICofPEIaZrBhU4NVNnehfg?=
 =?us-ascii?Q?GMMbC78/zDP5WhCpIz6gxftY/0UvOjaI3rQIuiQarRmmk6AsqqpAX4TeCDE+?=
 =?us-ascii?Q?kQ+puqG/Sb+to/smOKTwMKQA9+TjTyGwjZZZBVGoRmcKc7h2aca05+ahs4y7?=
 =?us-ascii?Q?AvQr4ll9MVG9WstXhcoLl/qZYEJudDaYu/V0XoEfBAq3AfTe2qeT2vNRGHEs?=
 =?us-ascii?Q?YPuSnm/P1hGMXu+2BOWOFK24t526vQavw08Tm8w89gYBXDi7UsdoN4gTdd0i?=
 =?us-ascii?Q?qa/m+pAVKUVUKqmAU49Tkw8Ke8irwF2Rq2Swip+rixqmRaP2Ff980CwZXA8+?=
 =?us-ascii?Q?y34XtxDx9hXGz/VyRMlqNAnrmKZDKGVSxCzzX2bWNEQuf8YbjMEbH59CTixw?=
 =?us-ascii?Q?nuQCpH1W1e2dLbPcaWdlH433KmUQbckqLnxBjqmmPsO7TVrjHJxskb/mRH/9?=
 =?us-ascii?Q?nGFb3LcWgvLO2y8DNV61MmixbCppf+Ldbg0E+NLvwLA/FZ7UrO0Bb0oGtGHn?=
 =?us-ascii?Q?JFBAYDEjcxLK5t4XAKWeCl8CC9vjxmuDxh7o/QgIGxWSp9lK8Wy620wcljqD?=
 =?us-ascii?Q?fIlmM1Dr1UWEm9C0qpyv4Iqt8Yvw02vfPvjpUw+l9xQBa1NW9R0ThECfSy6S?=
 =?us-ascii?Q?AC9WVZzGxWbZ0GwJm9XsPrPXVxq3t7Rngrlw1PaMtPli0VSnBpc67Vis7d10?=
 =?us-ascii?Q?s7rTdlKYghIhXU1gH4/hVXNlB01ne7iLLoTd7PhAHW+zZ/gJQfznlbUYC0wu?=
 =?us-ascii?Q?m5h+Kv/S9CSO5ciXq0jjN+8vOdfUbfEBOAv6N+onJQ/amVr/xtyYwXrQXUDR?=
 =?us-ascii?Q?AACL/Mr8m4XUsbGNx9NMAj5xsfS71fJevzoRU6Ot0S2TDUsxkH0ubDOsIl0B?=
X-MS-Exchange-AntiSpam-MessageData-1: IH9hQv9prU6WFaIicPCSCLDdTBsgxA52ZOA=
X-Exchange-RoutingPolicyChecked:
	PFocHF8LQSP5rjJyCY2j2FnUDE5BVDvRp/hyUH83Qm9pu4nYpv93ZG76Hqp7ClE9lcL6tehdTFZN+SleOefws+waLPUfilWWSkOyu0+3321dKXxyouRxlJ9JOS0cGVgK/IQCwdHTYajOiv1BjDJ4CyNd7P2LCP2rZEEVNpeas/w0t1mLbxt9KNvF8O8DfWmo5q7QzBA496Ybx8iQVAbMX6hn+hEqrBhEjM0hR7dIec9IoGMe4TLRQjaEaORB0rL4nTkGOx21nJA735jCdTGkz3W8Z/7HiOOTL4CeogR54gPoa8uebX3FHIM4H4NBIYcic5l9jUuuX3+mlwOHodbn4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jGJSUiAakIFzWGGFMpTlWGxFmxg6lnsZVoV/651kulwbT/DMwNENGjxBhCM3XeuaQ7snOBDOr4NQFJLLsMetAvlD34rFdO9cjbW18iUtpOPtD1ue/7WBpQ4Vs/oJGPvaZC5S0VB2sG3boLfXV4i9m/4vECmV61SCMPjm3b7/nMZlg/9y65iJzhfyrnS2vsBvDCPSZhmTHjfJybcaOAx9I6mKqWi3huwAElX/H4h9sx8xVSZ3inO6i+xfvSz1ALhj05euM1bVciRfnTOlxZyAS7zDg9XzL9mrL1sPbQcQdnMd5kfdoRf8M6Oi8dwOkfwNyXAmkBzuKBNIMjSGrpjvl9tMRlHOYuBVZ10eWxAUx2DzONtn2yzhBfn3/ruGWB1DlQGsBbey+Ime9niyilFciXi8Qz8BYvKEW4CPI84syuSRPUQq2B/cazSBIQHVfSr3DutL04ZLcwIhMfs+uyf0XyVrJsiALmb9KAdvhGUCFldcNpKZvHK5HIjplhqpfsjizFOyzYXA+pPt5Ye2O3326hWpfFpiH2GzCKh9x401EmbWuMzFnpr7a4TPwZmL69PjKpQY2TWKueyC8R/LqdggwkmRN3EAmAD+pSBHMnuHEKrch9/dM0Efe4dY0f9BftCI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e2cfda-37b2-47e8-c448-08df33fb1cd4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:52.4131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AA/YwmDS95rmpWl4zPR34XGW+Fy4aUZWhUkskUcvwp4ABf1U/0r4YSeRyYPiMDbfh+2IxLx/KpxMN4Y2eG5tFejJrcTe9eoQueC9RQFVOf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

The zoned allocator hands out space strictly sequentially from
block_group::alloc_offset and accounts everything freed below it as
zone_unusable, so freed tree blocks can only be reclaimed by relocating
the whole block group.

A metadata or system block group backed by conventional zones only can
be overwritten in place, so it can use the regular free space cache and
the free space cache based (unclustered) allocator instead, and freed
tree blocks become immediately reusable.

Pick the allocation scheme per block group rather than per filesystem:
replace the filesystem wide btrfs_is_zoned() tests in the free space
tracking, the space accounting and the extent allocator with
btrfs_zoned_bg_is_append_only().

Such block groups no longer need an allocation pointer either, so skip
calculate_alloc_pointer() for them when loading the zone info. As a
consequence they are no longer marked active and put on
fs_info::zone_active_bgs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c      | 16 ++++++++--------
 fs/btrfs/extent-tree.c      | 29 +++++++++++++++++++++++------
 fs/btrfs/free-space-cache.c | 23 ++++++++++++-----------
 fs/btrfs/zoned.c            |  6 ++++++
 4 files changed, 49 insertions(+), 25 deletions(-)

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
index 9b0a5c6b96f3..4539a775cdcc 100644
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
index e65ca60f3ec0..99e44de9f2b4 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1957,6 +1957,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
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

