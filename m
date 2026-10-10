Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0076E48595C
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634100; cv=fail; b=KuRfSjWte5VHiNjnC6vhk7XgPAuH7epjm122jvgsFI75/3C+IJsWxNB6qGDIt1V3ekEoujDNhgbUQwdRJNfy9EdJRQ4yDSs66II4Gmd2Dc6XFGNP7RxQ+BM/6AwzGkWeJExRy5L5JIf+VRnO87GR9GzPlI2kFKbq/leaZ5xlsMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634100; c=relaxed/simple;
	bh=w2h3N6OomPvtAAiJXLuAV0qY0IdSvnmuXjBMNb69nBY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sP/gEKuBV1pPu8AR4qGagSUBkjt0TuZabeilYux9f0Blu12uPQ9HyvmB2AGiyfkdtziF22jZG6ByzBwZomVAcwa2zkAIPYDu4jCvqa74UCabEmIGOya2F4B6ueB15A+IUyG0XfeQfe2Y82kV1IZhTSUxGhIvR93MbUOxiHUy8Js=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UfEu4V1K; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EcF9mo4m; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UfEu4V1K";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EcF9mo4m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634099; x=1823170099;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=w2h3N6OomPvtAAiJXLuAV0qY0IdSvnmuXjBMNb69nBY=;
  b=UfEu4V1KzsiNQGFshecmRzTxy71PuV6F1IuLBmvQq6dSqahPbgdft7Nm
   GCKObtYM/x63IF58UCNxVcYqcfFXtMjjNaPoAv7jNKlMWX+mDH03GG/l2
   5leOnOYom9OAI67WjlCoRMukWJW5tiHj0tLLoY7HWWTaHx7s52LQIKb+z
   zYsarMlj52W5Q9j+aOdKUB0Gccdv6sgULxGwGTS9HIoKpbGOXvaG5j429
   8TIhU3wUhg1KTmDehscJP09ZsTlvyKTdFB6V0yuL+S19f2uzCFE0zGRAy
   cKSKsFaZbgOnzvNMwdRGk8UucfOsTygzCHPpnPpfCCV+zLKJl9zsKg+NO
   w==;
X-CSE-ConnectionGUID: p7rgQxnHSZeAf+2fP5kodQ==
X-CSE-MsgGUID: Z6Us7rZCSsOUnlvPSsaUZw==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="157785430"
Received: from mail-eastus2azon11011020.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.20])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=agw69x3LeuZUpbr42NqmcXz5OzRy709+fe+lODkvNhWQHbSRYJuR8jf+qiSYW0ytwEAhrAJ7qwX5gQ6ivlFcA+ZuHDQDOm5KrAYh237dH7dcqNMKQ4cxaNw7orgn7EuJ/beir/edcKDkh2YHt3MDYUEatteEDY2+bsdENsqkRLEsOVKVrunJHx+6j3E6Rifcen+yN/E9fIso32nn7B76VSj/+hASeEd1qCLHiPfsy+6Tkxz0yTqMiTQF2r80H7FYgrCWH+UtXQvRrprB+OdZKV6IDAc29VbaJtmxPqxF/vO4/iUnkPlLPAkGZRVKtdW4rG4yzrjigzbKUFh4GoUatw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHyRVAliG8TApQ9hppHJu0xTtUxfD8IR/spiOIHdbh4=;
 b=MkLXlTJ7tvUms0RGJOchEZE32oLMBF/yJZCfJOQKyydSxTje47XIa+VGuYAaFSzmil7lDoTsfHnQjzUVkNSvqcA/6rEV+TW+zIuf+rTP/+/B5E3C92Kwqj9ijhbisM1jBzmnIf+h/uE+EEP8GwmI59dbV5SJ56VRMkLgOckdchS9RpTixfs1ibv3K+xf4CqcuOocagFc+uXUfhotqYIAJL5JvI66VgX+8e1XbKwrP01yg53P+Pn63b61IoFPBvqpNeSWQYRihS6cp+iH1T1bEAIYAVNMaPD1QA9cgRhxLrkIl2hEnOGuvz2C/8dFRWaqnTyJSLn+7WMfM9FcOhZ5iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bHyRVAliG8TApQ9hppHJu0xTtUxfD8IR/spiOIHdbh4=;
 b=EcF9mo4mGjMDqsE8JI+lm7EospzRXtELVaMOw8Pf6lCy+ECLpjHZMks/Dgi5XHMXEBZgtkzeS0hrfGxt4oXp95hMSYYhjKZL30ZUlg+onYF/JoOcS10JtyaS1/6W8jmYPSJpaoMf2JXhqEnWFdl6s3yK4CcE88XS7wyF7ZOIB3A=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:06 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:06 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 00/12] btrfs: zoned: allocate METADATA on conventional zones
Date: Sat, 10 Oct 2026 14:06:10 +0200
Message-ID: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 00452c3a-fb18-427b-0d77-08df26c700ab
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Tez+IVnEBKFT1DumCCUlq1f6TO8G5sVME5AcwhoxyXbxecNuD1/At+F/nYpge6cZsSDC4OJcel74j/7wR85Pu0uufyaSHwj0+ZNT9EUDFj99qqHwalecE5bKjQbsIFZQZsFYALsOVIvuPqTQrxkRIJoym0HsXBm4OHosTAkMhVZ4mtCzsGovG+4eLLdQCKfpsP/mgUc8iImLYT3KGhsDUEBDiqlQ+CnG2kIsjcqKCPNq7RpSETgt7ntHtWCqWgAAW0UQF9+SDMxVa8W5+8FqQV0eKkHzQTw5hevqw3dbzgk+nca7H93DMCvoxSVrpXPJDAOZ9YeVXFf+FS1RcYLfrfycqvk68Ee91j1RTOpYOVVQiIqIUHp06hkUSA/UnkSdt98rlO3ydapK4LAkcwFwAdcEdjc0OC0uQuLX+LDm31ogW7K72i5aCL/lGLEKR6IeD1ABvyZIhBokaOiRaI3emcS1+wW5n15bFelJ+Dhi/IMgSbXuHtONBF1vR0vV0frntCl9FI4kx69WXB2ucA3kJka9BEsHp+j+qqafKFvdDqBkwBng/wG4J32rmlUsEg/hAJmtLJVv7/bD5kS9USCb9SUL9xZz8v0b4/w5+0+SGmcorEKyglmCvsztE7xyXWqDnGIDk9/BkaNv5kxJti51FivB7H25QFQZJ+eVri3hCdc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kDEX6sUHWg6Hcyhoz3REIh/nVD0JUlA1CN9GRVOI/6xZXp9hm/oDpFBMnOE7?=
 =?us-ascii?Q?i8Tj0tKMH38COW7by6xO0YzofCdE0OWthqJOdPkk1C7TITkFMOTj/Nq3NL5e?=
 =?us-ascii?Q?R0/Q/oqZavBpEjdSD/gKCh/zyZLlC7BFnkSk4YwzmSKWzNYadKxr3QhSE7HS?=
 =?us-ascii?Q?Mvie15o3hmXU+y8inhReXxfICC53PMP20u3HLo7h2OsSB3JM/jY+UoFxuXco?=
 =?us-ascii?Q?xLBA2ZQbuBLoZUNAJDRv4ARgpvxAZdbII2B54khN1ByKrMQUKBUstjsKsn58?=
 =?us-ascii?Q?lGX3vUavMUutQqXpucKBWmr7H7nThW05pjA1nVRbzRfs/sae4022ZbUxuncx?=
 =?us-ascii?Q?+KdG5BNX3eY9Wyav/xu9c0+WLEc9M1YbvcS5ivNr1ZzUci+l8dBhq1t6srDY?=
 =?us-ascii?Q?V5pkd9bZLfddROVvrGk+dO/PEW+/GK15M3VnD8tlp/xdLhBfDzJMILGbQVvI?=
 =?us-ascii?Q?MLZABSw6+wMMXN0XI0KtjQiHvILjtgrpbQWQNwYQVQwN6UOfRo1/+G/4Pk1/?=
 =?us-ascii?Q?3ORQhXAQZWh8mM/uFYufFyVhmkt+WLXNwB+s1/KyridDZXAOemznMm5dSJCY?=
 =?us-ascii?Q?oW6AG2lEFF64ce+l5pNE3B/Mt/i+WWPO56RXPkKprPgNv2NUS/gO9J4fWxxk?=
 =?us-ascii?Q?TE4577ZrbHQ5JIdY0EBaxeOt6fnOLvlMC2M6AWrW6oWSJ24dSHQpeFUcS5hf?=
 =?us-ascii?Q?fBZQJiSYnHjQLGQTktyVLpDAuntCIXYWduCJigKF6mlR6ryTIl5A2ScUMzw3?=
 =?us-ascii?Q?HUZTLKzoMkz8vHjOd7AcOdDgNxCPKQjkbSWCm+xxVCUdasccD1BU/jAjscBd?=
 =?us-ascii?Q?hFz1NMx2faUqm4KGHuADjSRRkmEDpUzK5g2gWA+Dx0oxPWkVOa6HH50zk+Jc?=
 =?us-ascii?Q?X87Fl0Y1/EWNc3ttTp68+CDcbnJwRLP/MV5/F82ElP1j64/z9QEtDE+j7SwA?=
 =?us-ascii?Q?kMIEJivOONafOJM5JJ/BDp+jcE0hxGfwT1dgAiJFeX1oTpwD6sZOY1fC8xA1?=
 =?us-ascii?Q?+rQ3Au4eBRjuSxpJdvnSW1RKx6w67XbLoCkwWyevcgibsAPoPuOzc/p1fM/G?=
 =?us-ascii?Q?2bsVt1CrtR1ubrKGTs99T21iSiC7ABuFbYRvmVjt6gtmn1d9YZWsN9GoV8gE?=
 =?us-ascii?Q?X97a8gz3Irlc37uWZJ6nizAEeEjs8bDdlqWoyaKKiKTUiHpAHVW8P1oT2YxX?=
 =?us-ascii?Q?vRisJcaIyjFWWq5In+2k6rGvQ/yk/SM/E1lDP8n6RM8c0C59fucUemv6OtJK?=
 =?us-ascii?Q?l+mS6CGQSzqO9Xo+DxOpr9V+HxXxYbAb3mQq08j8Ycjl1LSA7OC/4+Xd/Sy4?=
 =?us-ascii?Q?qwZVX7NBF4YQFS93IIaZ8l9Cyb3/PQnMbWZOHo65psZapacMUtB/VK960L2A?=
 =?us-ascii?Q?KwA+qiPl2rGwz3HznZJ61sxhwPAH5YI6nJPD/OMmL06WpuID0mfOFfhKRoZh?=
 =?us-ascii?Q?QVi9HrScjHdfLQpeuededwaAHTbTQOi1EBqv/5C/dAJDJq9QBwzdiQr45O/7?=
 =?us-ascii?Q?TlJtx0Mg71CfvRRrJKnhRk3Fxje7QuFeV3E9VVraVpTRt8PLgMFiCZqX9Nf6?=
 =?us-ascii?Q?33Nn5bTCQGt7GbOhxGnTpoEkO3vBwCfiSQ/+t8OL+O6he0EyVGdDq36kurIO?=
 =?us-ascii?Q?Bm8euFeOR7Q3arPUgUAssj+oER008kUNjx58yMzmKQdwdUolAghxurX3O34j?=
 =?us-ascii?Q?9n9ouzroYzQ2Pl45w6RZB17NVenI+R1Xtfw6OK3MDB/ICVjnamzg/LoBKb6T?=
 =?us-ascii?Q?43Bf78cDRsK0Fqmcl+Hczf/VZG/350tw4GYKLCSMe0wYt2MzHv9ys7RbRRdu?=
X-MS-Exchange-AntiSpam-MessageData-1: S1er0D382rkUsw3stoVl5FYRUgyBg+KqscQ=
X-Exchange-RoutingPolicyChecked:
	Oh8mj0JP9dgOX7lWvE54kfbMXxMiUHsQ2VbEymMTyIxYONyQL7IInLm1Uf6VaOgDpiIrARRkR0TscwLgh0dhgO8uH3j3K235idSu6Zwo5aE1oZ89mMiXdaFDbZfxt7RbE1bomQqdEcWMiKW+EygCbf1i4FgmT8yFevdwtz0LAQ9GSBiUV3vtZE9I2W7vmUNYQS4cczWJzp420gG1fYxuR7EFvCIiO50MOrbufoBHfc5vLipjrseQX5eC9N7bBlFTiMaAb5cHqN7BLCrDaLxuGj4u7erNUNen1PUdgi5L3rATCb9zb9kBvQa9uWZ0lFcTa729SKUpA2M/u6+z9oexnQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BiLLZTPPn2gAlarWp8h3bwZwsxr156JQvr1rRaUlsM1HCb7YQjWsTcjDddjpVND8b6/wcc8e5etYXf1lxpGc13QiChh4KyHrG5fdXXuOKtMCs7xlL1/2sCO0YpqcwavfHsxr3M54iTPB9PI+gWrCVEeNU1U0xWlE3zj3gWGP9IwHsQkx9H1o2kZGCVDaDYrXJqIETaS3V/hqTNBj6Fd0TQGUB5wzqBjPwlQgiggvq7X5q6uAfG9kFdikrlW83zjuvnMluUpE0CdWt64mrdBG6w6CoaoJCOiF4C6PjTbUpdrjDFh69ldGR6HiYb/QsYiQP5DXDtNzAHdxujK3ZaPXf2WejiDcIEqUBhXb3MEUA0RUPQwbOuVmU6a81/WJPXoAqIamBGPm3BJVKX8s9CrV7xMKgmjGyQV9gxFXJys+bzkbLeuQkFPY7O5Q7c3ETCPZXtQ/DsQVGxSpB0vJ0TwkWOWtrJMEu21r7EuBfediof7UtVQRljEWL5sromb/aalqqQ112UWJ+pkwJujnsEOcuWT7jy3g5KlAbdN2CnxqX1rFnV0rmrHnOR5kAJWFbMxwGF9cjDx7vubenuWdQ8x2n1PU7nhfrB9I6aQyQQBTSvYRVYuMk62BaFwkPoAYKgOD
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00452c3a-fb18-427b-0d77-08df26c700ab
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:06.2640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgOc0eRxOXBeZxHvQK7QnpTIVrByvGuAP3ppKS9AYE2RpJjct/5onuXoY+AsuoBc+iFgYfnZv1LgPBYZCq4IsL0yW7BSOPSz2mpNewagcRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

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

Johannes Thumshirn (12):
  btrfs: zoned: don't activate conventional zones of mixed block groups
  btrfs: zoned: do not account active zones for conventional block
    groups
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

 fs/btrfs/block-group.c      |  22 +++---
 fs/btrfs/extent-tree.c      |  29 ++++++--
 fs/btrfs/extent_io.c        |  84 ++++++++++++++--------
 fs/btrfs/extent_io.h        |   2 +
 fs/btrfs/free-space-cache.c |  23 +++---
 fs/btrfs/volumes.c          |  72 ++++++++++++++++---
 fs/btrfs/zoned.c            | 140 +++++++++++++++++++++++++++++-------
 fs/btrfs/zoned.h            |  85 +++++++++++++++++-----
 8 files changed, 350 insertions(+), 107 deletions(-)

-- 
2.55.0

