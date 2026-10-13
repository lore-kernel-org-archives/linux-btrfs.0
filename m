Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78263939BD
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876625; cv=fail; b=GdN3xMb8kGHEljgr0grTlyVfQvnxpxsRW52hDPZM8KgmFlepzMe08+yZs5jn3N+8Uke+y7KYWJuwfA8BVgggJoO7Yb7W12/VugvpNW8Xoj13Y8Zq1BEhfazrJP9ayw3+lHopkdx1MfPgGKy6vnuFDPzbE5gnPCZJX6VaAN5mC8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876625; c=relaxed/simple;
	bh=IGvHwv9bvCsrfnKz2GXDjYbMCyHOz9WPlgasiy5NxAc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aI/rdqCVwYGGR1lvs+3/i1mWmfhYJ/OUhLrZXY8Q07v0URb2a5+HFWy/lozsh49uK9MXJlidVC7jLfAt+XqZ3E1PGYcDRfbtcQFmmN6mGewBFjZhkNWvmOKeJ3IzYRIHQ1u0ukqIxq/QJvCmnkXRUT0r4rt524jdrkHMjnUYutU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Z4DxVS7I; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Lh34qsav; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Z4DxVS7I";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Lh34qsav"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876629; x=1823412629;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=IGvHwv9bvCsrfnKz2GXDjYbMCyHOz9WPlgasiy5NxAc=;
  b=Z4DxVS7ILZdRY56ehsF+KdjQNyl9CUsYkd+o5TsUxlFFGKVakm65nPOt
   kVCGtP417x4yDfqjQzby/qHoovOmiwhD/GYo6nTj7dp+zGbvROb/LlTRR
   xAq1S5Bi2/dGlRcMEQJkzj3wQ+1DlPyIrDBJORzWiFSDVQ1R/CUIrITge
   UFB/AIRb4QTtLXzrsHbzWeOOCSNCDRNlJ1RcOA48gQ4Qfz3XwsLU31ccB
   HcyNTX731F8KzXZqN4L7ycM9Ucjqp6mfr/2u+kGhTNToV6Fu7Aul9xLlz
   p+r39TeYkziz9JtS6s9R9Lfwo1kFx41NFtgaixn83krP2UZa0fv57IWIw
   A==;
X-CSE-ConnectionGUID: ixuXHnPzS3S1EnYXiuSXPA==
X-CSE-MsgGUID: nz6w9LCPRNWpOPE5WzdGRA==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917158"
Received: from mail-westcentralusazon11013042.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jS6x2Qi6178hyFV607eL+YoPf3tTbmXUl6fzLRwW0EObECsJG/uTWcQHmKtqrURAMG9Fav6u/VH56/hizoSMo7rjNYykr02E4bX609LSD7uxF+5ypbVzJzujEK1l4OqsHfSpv4gcM0MxPLuNqltAKjMYBvjb//z5zEY93pkTnFFhai4A2zWtfW63grrRAUBUm2PVlEq0WX60/2ILJZf8vaRxQ0qMEy57xPqnxfgYhcIMqZ6N8ETSmlit7cVczcC6munpnWhXEA39gPwB+5EFM8JAHh8MFsuXf6GCajFDqo66c5zv6HJlNBDZTpL9MlOl8M6sgR1noJXkPk5kwykWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wE8/vUOgqy+YbI6W8z26u5cqDMF2e0YzmaICBudgBEk=;
 b=speB+s9xwY6VUcuKU/I8DYkOwetI4uFZZKjePP82g3BrtC1tyYLV1CR7ZFhrxbuBlxIsoplpR9VxqbAijiV8dbDeymalNlet8EjhLyBRnfPhnWwTYJYA6yBFb3j88a5or4yD4KzkgEMeRrfJRy5NRMPu5ch9yWWuqXJb1vHoY6+9xXRoWs+Jqc4aQ+HnLEsafszksu1Ua/rNEueA9xda+0ahDAC8qiineppEjUeDFVhRswC8SfVJvtii94b7bgQaVYTzz7woc3qbNSajDE8PQtZNju5aW0ReXYh3czuJB/AAUBylqp1tZgwERWqYpVE1zmdy29Z2GIAL96LFOV74LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wE8/vUOgqy+YbI6W8z26u5cqDMF2e0YzmaICBudgBEk=;
 b=Lh34qsavcaylylOvG66MQb91ygW9WhJxhH/fUIb+jVPLc8E64xe45up5Vfg67r7jxWf6LQgkuRq2+dQavLDFO4p+7WNSzP9qcSIGiU4gfL8M4TCDyfpxZNy5OrqgI4NATeMtBmbDSYXkVSYPH+wYlPw7UjGXoD6oUvjadyKfWBs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:14 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:14 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 00/12] btrfs: zoned: allocate METADATA on conventional zones
Date: Tue, 13 Oct 2026 09:29:29 +0200
Message-ID: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: 230f0f7f-2680-4123-c444-08df28fbd29e
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
 BIHShxbgBrxqjhZlLfssZbRAujKa8ROFk0riCU55fGsbTih9ZkSI5mQjlIbf01LnpZNA6nuICkmmNFmHWZ467p+icDC238d278wYvt5gHxOJWkmDt9xHl1AVq9SeuaNt7OsvEhBCbOfOzDTwH3nNjzW+SjTwSZ+fjcdC0f4d4EazWzdMTL4QJuwHirMMlVXq0CkixRrKH60ChWRGENaoMY5IcA1LoWqGY3NR3JHH/hQ+Y+hZXVONHmewSYI8ddHaQJAjxn1xYs4DQYvtaflpt7PfEk4Y4Hdfj/d/cD3f3JOrEUhhWY2YEjhVOsjfMYJjFlleAfcVFUYoVlaxq6cnZpahPMo1EvQTmy3y9Mar6d3zHc9EqK6KTsg8IQHSxQ7py63zviTmbuf7HydsJpPm/4qCam/n0Jef/6bSaYq12ZYplQOf16O5imNUdNSY82al/jix95S8b9n0Kge05NnGw/+0jeXuFDhWIww0PbOdr9AgI6bxPgDbVaTebIbRom+ImdP4MRikv2+4K2kM9dOk4hfiEJ6pzmqyhe6/Wws8yVq5PrJTHw1mv9EklL8QM9Gek/9xedYa708TgbjvIOQoru1VouKKJoegj7Ya1b9IwHxadUCoI9gMKRmcfqhcv3b8ZQHnli+Ob2jGAgevYjSFoABG8mHG2eAyMZHnY6qW5Jc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?JU7WNrTzmmGO0OT9/IrNHPV5TjU2slRu9pbuMuKcseB1Vf9TyqeCCHWYs7Jj?=
 =?us-ascii?Q?51Jf8zc9XJc/TWIqtszI/YTGTNcmZ3uhppvtegYvCUgg/RL7bTDpaYBhr5SY?=
 =?us-ascii?Q?PAi0JarjarMVNtuRklZ3Jg2LKE5ClnUw4GRvD+RHeIqb+38KR17vhpZbRwlp?=
 =?us-ascii?Q?owJw58/ovPow9w1Zo2xPwtIybUndGxwNy44yonohUghB0wAbBQTmqZTMypM2?=
 =?us-ascii?Q?MaSepW+QXAPFmcwXF/nN2rlMf+HnHxH2w987Pr0ECqMIKsroVaYbifbIdZeh?=
 =?us-ascii?Q?SU7eUACEL9yB/x1V6NASnThsCysR6coAmZ2BQ470Yqw8DQBcVxjG8H6mtFuZ?=
 =?us-ascii?Q?F6CxHq0qPXDSkE2fFSM06NJePLNtMMBgSRl43vsI89nPkvctyzayXgcpOqJq?=
 =?us-ascii?Q?v73M8qzU15OCak/GC9RlBxHvoCFsQ5a0QeJx3xTWr2TS45XjvvLKS/YFeHC6?=
 =?us-ascii?Q?c1OWO1UcWQ29G8/yVHAm039rrXwTlw6/e6+sCx7p7WfBiJvk4IN339aJHQuW?=
 =?us-ascii?Q?LpJ/f4majOaGK3NmYhl6MCwmJyrdBiRO0vAy3QgnJ6WU0QRAcdixpGnqot1e?=
 =?us-ascii?Q?GNaWEIBITbVHLYH4UR/1R1YYY0zA9A5PR3wjcS+UyUGtylHhpvNZXzio9hrS?=
 =?us-ascii?Q?nrtoWTPFPmO/bAybMrZZu0mAOahigcDB0C/3Z6pINwLe5Z3lIn/IGX42Rf1v?=
 =?us-ascii?Q?4wy3z68iuFYNa/6/suK0CfFAtvj+E4Zyl+EdcHqcUpr3I1cOxbEfSqv3Y2oA?=
 =?us-ascii?Q?SQ0Jqf1cbWvSMFVLizbu4uTbNV+n+K1W4FPK7YY3R7VKPPquiYynwrcNXDuq?=
 =?us-ascii?Q?+xxB5Ppaav87kSVSw35qhAbmk8VJ49GVZKon4kfG73Q0SiqJpsVrfUPl21pG?=
 =?us-ascii?Q?u7I0ciAmXRlSNpAPX1ir9aWgIU/gRi2gd/4rJrx1Vrk4cUp6F+h/fe10X8WD?=
 =?us-ascii?Q?/4y7awCyGTtw5yaeDZX3S3CWz0v55nBEbToV0avsTy4IJoCMIU/uOln9PoIk?=
 =?us-ascii?Q?F3AUG1Bv+/UZW/72QL7VhRi+Ul7MTcFKKW313BJMWErK3jPboiVR8dnDeBOd?=
 =?us-ascii?Q?LSHgpRadiW3aQWCsAviBvEaLpVEOVFNPrg81Asc12jM2MZy8EHlHmxwT59gn?=
 =?us-ascii?Q?4lKb1Om+WsIEyLh87ZhqD7LNsG19IRce6y4oGqcvPBU6+CtWa5ZYI9XzOiVs?=
 =?us-ascii?Q?pK3Xu21eIUfiOUx4qaH3tRovR+CmvyJZv9EiFQoqDIJ8A7i0v6xPCwsrmCEO?=
 =?us-ascii?Q?9voakpCMXSOEmU+V5ig4IaufxuEOKkxKkkV5f/YiETlWlgyDRV2i/ZcWBXVt?=
 =?us-ascii?Q?c4xt6TLy2+e7uiZJpwyFsylhg0cCmwh7Ze++n89a8Vw2Ar5z6575BQuobYzv?=
 =?us-ascii?Q?0QffplVfxriM5nuYyoiZD/B6AoEU5ycbO7n1iGI4BHecxPz45pLM/xk4MN93?=
 =?us-ascii?Q?bJLmDYylCL0xJkE1VCQqqsNuQy+ntrv9AyMR7UVb48mqSA2idLHK3DjnVD35?=
 =?us-ascii?Q?0yzOwWY9B82/hPRWzsCLEtv9vyBkLInFWcR2lLlYM2qEIg6IEL5HsOky6JAZ?=
 =?us-ascii?Q?5B640DcJd9UfBObaCEyuOgbkL4EhC4Li7wrokVN1HzH5iqfoxx46CqymKL5/?=
 =?us-ascii?Q?uhTUOOv26mNLWUJXqzvVsTOVJComTvipnvkCkPICD3jJD0uUAEbMutp0QvyB?=
 =?us-ascii?Q?2avAKtxvfzX8cPWAQS6ujuBJlv6SNFWmTOVFDuEJAtGipqJNJp+cGJXem5IH?=
 =?us-ascii?Q?G4f9hNzNhDrsjOPg5lCf/D5zMOlEEnMTczF5fT4vnblT7YY+/xlPHrQn0eTn?=
X-MS-Exchange-AntiSpam-MessageData-1: n0OXanq5YpkQ9/q2X9nTbsr3m9nTkIxljbU=
X-Exchange-RoutingPolicyChecked:
	dJA6QYxrh4Y7Dos1b2HUKghll7w69HxoaOwUFRf3oJmIfeqR4360aCC5EqKBIrP124vY9Duu8s6EHvIW+75wmWItt5+JheLa6D4hAaYrBatWHA94OuS5S1d5qRY8mx93iNjOF2ZsCokqJSdSzX9xCKEJYiG+IzL/BXbEwdU4iY2hVA5VBH2cjQfL8mquSsd1eyN0YxdK4Oqk6BGk/eQxaxCh6nues83HSR5k+QAhfQ3k+BNaPY7TeNGpbDYTsple3eKrWuYd9XodimwAhnsedrdFe7QIKhSLXW48N5o5vJCgbx7JakfipLTd8qo0AiWsOBft+EXKJE82OhquO4b0gg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	muhIe8oH7kxn1reStGpCLub4agw1dC4HXOyz8KINSGy9BYaPzwC7FnvbkyoHo7M2kGeYspFvN2CA5/fQmO8sS4EBhwiYLiLPeJ3tR6huPnJpETApsnh0+buRQa7RYgA9dAsnIBpZXiSfjdnQTKgCxcsClERHKIFVdiRuHspaiiTAMNGYXGCh71PegQyITEioHQQkt47ZQWnF/sKXmAhc1Ar0AWmFSMOyQOT0/9xbD3CwRq3tLC4u0EZCxE0B9vSoULyyU6Mh/WwAXfQKdmCyHRNS0fcNLvOHXT38njbPE/eJZYkb3Er7HBuFrr8e3kDD1X40L5nNJq0Dtj8oGgIOfLRmWbXFKAa/vAT6rb/EQE9jdPGiHuQVBKwp+JSkv/eCTw7xLkG2KYMcjA5YKvCIvf9tHhPWrD4DNam0vjl2X/rzwVkmsY8WkQwy0GYcWeGs78vh75ZHdREPmlYIUZZcr3E6fG5l/v+vNdYW3/VGP52EXR0Z7jR7s1Mlk2nrvmtWXzBLZRL74im0fis+D8uLkv1oqq/UdDB+fBJqPCMsRjPceBxHItaryopU1GemNAfUbRHhfStt30UYikvcBpZhB5/IGnXEasRkMfxUUg7cPzcgFIjMITGz4zvGxVxc8h1b
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 230f0f7f-2680-4123-c444-08df28fbd29e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:14.6194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0w2Z+OAcr9cJ1p5/CHwN7OpxrxtS3+zPQMOwTOLWXQJL50MFxDEGa5eCdc/KVYizsYtFgI9gvWh4CKBxqGru60f7U4xPyv1Ih7R+MKLBXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

At the moment, zoned btrfs places doesn't distinguish between DATA and
METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
METADATA and SYSTEM block-groups can end up on sequential write only
zones of a drive. This adds a lot of complexity, as we can only append
to these zones (and not perform random writes) and for METADATA we need
to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().

Also the write stream for METADATA is not allowed to have any "holes" in
it and must be aligned to the write pointer, which was a source of hard
to fix bugs in the past.

This series introduces a split in the block-group allocation path on
zoned filesystems. For METADATA and SYSTEM block-groups try to place
them on conventional zones if the device has them and enough are free.
Then change the allocation in these block-groups from the zoned
allocator to the unclustered allocator. The reverse is done for DATA
block-groups, which can be trivially written on sequential write
required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
a high queue-depth.

Changes to v1 (from Sashiko review):
 - New: reserved_active_zones race fix
 - Skip conventional stripes in activation
 - Skip conventional stripes in finish
 - Per-stripe mount reservation check
 - Fixes degraded mount NULL deref
 - Dropped conventional accounting patch
 - Removed btrfs_zoned_bg_is_conventional()

Johannes Thumshirn (12):
  btrfs: zoned: fix possible race for reserved_active_zones
  btrfs: zoned: don't activate conventional zones of mixed block groups
  btrfs: zoned: skip the append only metadata writeback path for
    conventional block groups
  btrfs: zoned: never activate conventional metadata block groups
  btrfs: zoned: use the regular allocator for conventional metadata
    block groups
  btrfs: zoned: only take the metadata IO lock for append only block
    groups
  btrfs: zoned: allow restricting the dev extent search to a zone type
  btrfs: zoned: prefer conventional zones for metadata chunks
  btrfs: zoned: use plain mutex lock in check_bg_is_active
  btrfs: zoned: use plain mutex lock in
    btrfs_zoned_release_dirty_metadata
  btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
  btrfs: zoned: prefer sequential zones for data chunks

 fs/btrfs/block-group.c      |  22 ++---
 fs/btrfs/extent-tree.c      |  29 +++++--
 fs/btrfs/extent_io.c        |  84 ++++++++++++-------
 fs/btrfs/extent_io.h        |   2 +
 fs/btrfs/free-space-cache.c |  23 ++---
 fs/btrfs/volumes.c          |  72 ++++++++++++++--
 fs/btrfs/zoned.c            | 162 +++++++++++++++++++++++++++++-------
 fs/btrfs/zoned.h            |  80 ++++++++++++++----
 8 files changed, 361 insertions(+), 113 deletions(-)

-- 
2.55.0

