Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E7B44E667
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822088; cv=fail; b=Jeos7afiS4G2YNZbZPgOvzMIkQXLtCRD1+MkSxyd6m0RXfPnGDNCM58fug12G0LWHxkNMTQWrDvxrBOy/B/co8qVijl9azGfMRA3oc3lE07XGfLpOMHiGMuIQu0tBdaDl32qQ7qADHNqIjyW5CdBziAJDpLHxnsiTyfnAe5ajy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822088; c=relaxed/simple;
	bh=tMFukF8ivIc6klRfWK+xEk5g+pRZ1D51Sdzka+kyBG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BzRwNHQGeGBhETxPEjsi1nyzTWgUVOFYbgRoOp2EU8wkNFlIJGbNnDat0ZhW0k45UgEAp4gjOCmu7aGZlCKIb/jMNK92APeqYlAExcQQkKiVRCU4UHNlVYTLqXWqMRbgoVHCNiVr+zLW+rdoCfqi/XbwcKXEKE7fZ643n5hL3aQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=P/cG4eyP; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=D5S9/WLa; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P/cG4eyP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="D5S9/WLa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784822087; x=1816358087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=tMFukF8ivIc6klRfWK+xEk5g+pRZ1D51Sdzka+kyBG8=;
  b=P/cG4eyPuN/fxQJBVjW958fvr6O3Dd9rG6pD0EgcWUXdheLWOSbpmM19
   HT0F20oC2V4zPzV0lIMFvOg08KxEUkBmluT5Jxhb/XA4Fa3b+hP8ABbZE
   RJDojfvX6WZbwPnJ+nYol80VtTfCIEM7MwfKxssLkbHdkkUePhgIDPXY+
   foPEYwSP6aAAeL9AiLkmIg16mXJUY/f/J9dksU4C6WH9RvVZbR4ogTZJg
   pOWKZ9SMvbjNlAD1egOS5yKHF96hgFUJpWjQcgiqyIc3gegCGqvF4re3c
   eVnToprhJGsy9L1bagYkF7qWZdOt0Hpz5sVaLYAqWn7oePEUjjFhZTB/y
   A==;
X-CSE-ConnectionGUID: h6IB2I0GSbGiHPRAWKRfxQ==
X-CSE-MsgGUID: 8075Gfo3QeS18q0gSTjALA==
X-IronPort-AV: E=Sophos;i="6.25,180,1779120000"; 
   d="scan'208";a="150693701"
Received: from mail-eastusazon11012068.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jul 2026 23:54:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfaI/VL/lEKKGf7N5Qz1hEvtWaEVHyFtpHIImqbdaSme/WC6sODf/Z3nML8GaM4mf6LU/C7neJ+28AbDaUxSLn2rIDrPExB5E/Q2jjOM07B3UOVhOIhuSebm1soaTkgaIPXJkKyfhW0U/osqX5U3Bgrwsgu2MoK0um7WWhqp4fnSCXPl6+wF1YU45fU0nZBDGSJExqzzt27EZfVazi2AdkqgKbWE5otdBGexKkJ1FmmMwJ1tTvAvzm3qXBVgaWQlvyO1A2ufaVAHAgGVu/opauIa5Wc+fqz54WFyH6FFGXgL75VEQTKdyP6ukMOJfowU1sQyGGRqRBn0B3IeMtwMDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5VVt7HsKqu55iwudwqM99YVCw2tAxpZCsSjhDfwl5k=;
 b=jkSNu6HlBh9cfmwCz0zgOq48V6raJMKEXtQBfOHzkMSEYh+Fwo98A9XzZE8l0Fwxzaz7xxVKUxhU2Z4rRmfC/oM1A8XjwFwJRACMpSyUDDYBnnGAG02F3/oibF8nvSo1FtXbEaTN6ohgYhrdQWwLK3XNnUwwCW1M8SXjOva+Qz09HozjkQTJZksYe0masDviY6K0klKwUL5rRwPmNANvuIGhTKE+oPeZ+8+VGnHFDwc7bLMK5G45MwoyHMRny1ZUhd3guCpuzXS+crAdxMNVsbVwLMJ7pspPXfZjHhsR81pBComZjOlK9Apz83/pa9ZrGTlgqN4KEezF+e1W8e89lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5VVt7HsKqu55iwudwqM99YVCw2tAxpZCsSjhDfwl5k=;
 b=D5S9/WLa3nTE6ORefFFKC+anK016KEGVzenjO/epK8a4bQ7It2RXc63/CZ383e+cV3mcr0sC0s4Ka+XG9EO9OwSAPP2St6ARjDWRrP85xw0s/xVnpumB+TUC28eiWXtSplSuhtV0DyxVunSHSLVgOMJvuFznx4Z4rnHjFjHuMAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB9295.namprd04.prod.outlook.com (2603:10b6:408:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 15:54:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 15:54:43 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 1/4] btrfs: zoned: flush active metadata block group at btree_writepages() start
Date: Thu, 23 Jul 2026 17:54:25 +0200
Message-ID: <20260723155428.94187-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB9295:EE_
X-MS-Office365-Filtering-Correlation-Id: 943bfdf4-ae23-4a25-9e87-08dee8d2b661
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|19092799006|376014|10070799003|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 oSKWdtKTK8pVb4yki2xCxW1QusCukHW2UwvmY84DrsnM45ZnoLkld0GuwZMCOqgC98vYoUT0loUAikry1WOVQ+EBbkl1zagtbKnZxaVuV6V7PTlDq8nfOjH6UnG4jBd0hWUZ7p/uuznb25vmZWWuyPNrffcNoP1XKiBVg3FtoCGq8jQoCpTFEj/msARLW6yUBNZQF6LMgehe0CqA1n8K0frbeoQ/+D01lzCp4eamdfxdxkd4XKfCNyP8qRemr+jz40yUbCjlaG8DhPX0nDv76VC0CkqKbDAnwMWM2R/RmE7V4KGy65hTxls3WbPKuXF2xrOdHpaspcDhHro27WvwOBXi/FErGO7GJSANe25e+s/0hh7GftfO2qCsrvlVXZYMGoWUUTrMZMyvcCg6Z2uNqskzyW4z7BcQILqlBFGYm8tUJcTrDzckM1oIzzSpWmxL044MfvbZ8QCuwVznh67HaXkKam/i4IntJ2DsPKsebC/OzOk5XdgaVCIzlGcQh8wo3q+9cmhXWYBKuF/XLeNADZonvUJCeLBhR9J9kToZAeEdshTrbb11DkrM7NB/Bp7HOho8Egs/8PIKACn+Zbga4PcxjQdZcm38RSv1C/rj1hUL2edxysGyO/JcH5eKhHHKcDarOjkEp8oZRxtQ6jC+TSyZOsTWanOgnvfpJeW3Aww=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(19092799006)(376014)(10070799003)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?BQvZkCSSjRHFPuKxOkURubtSOtUYwD8OJOZBdG6XDoKnxeyA3fhNhl5M9F7D?=
 =?us-ascii?Q?+119eLzFCj12DliR2dfDR7T3/GW5w2ld/GB99RpI9/ggJurX59o8GxOX1NEZ?=
 =?us-ascii?Q?v+BeOSqXxHcs68vxQ8+ZXQTaOKwg4ivFURpWSK4pp4/EzrtWWkiVU/4vEpni?=
 =?us-ascii?Q?t6UBG/4GAqQCgEGp1Au9AV4lTAqlvIq37tpVSIMazKaX/7sTHs/c8Fay2mVx?=
 =?us-ascii?Q?k6LnBiX6HDA5SSyFW/E6Iqu6/wrTdPHtP0N6Fkf4NL+JYXyANWWZlY4BIAFm?=
 =?us-ascii?Q?fmAhHEmFx++1xE2OkKmp0EHyDJ38MWGpjLvk8eOuUaSOHe0Yk3j1syWlxvW3?=
 =?us-ascii?Q?sdfewH/Q/bdIroL8nPaw5rbYwV5WWGvnneVo4L3sDYpxGd6wSxN50sEXfUg0?=
 =?us-ascii?Q?w0sMDUnfBxXxL+sxVZ9jI6HqPEIv7QXWD+R86KKjE3sbNcoSkPee5LnOvd1l?=
 =?us-ascii?Q?IoMcgUP/9tSBuMF6eoL+Ri+B1WTBlj8aFQitkQ7V5OdYwhYr467GQOm2QovL?=
 =?us-ascii?Q?0d73FlAklnaAs0R7mvTXXwDGXQbZp3EZ1mtj/z4EvVTLpcwzT1N7UMAVWMGK?=
 =?us-ascii?Q?w6tk6dCIDr7oxjHjeZZOfOBbIVCgc9/bqx9UqYafKTcc04OjRG2YnrRiJbQe?=
 =?us-ascii?Q?Hed9n5MObYf1HcNMKNY8SfePsSxUjjegDbezGQgt+DN4jhJjfu9u7fFc+fL8?=
 =?us-ascii?Q?wqfoP28sypFeHSc7W6f/hXWze8ROsVNLlF+dn42pas/y6p2iNB7+DUdtAkKb?=
 =?us-ascii?Q?xns23UBThsHvAzJ5slauE/qHVXT4FiFrwIILwJWZ98hksBN5E4L0MIwrm6Sb?=
 =?us-ascii?Q?5CXDpSNpHN/PJN6EWBqnARlg01LpbbIAQDQE12yZSQQa/FpatiVKr1Srthzl?=
 =?us-ascii?Q?wIami7JVuHHKNT58zp41TklqKawe5qkXNJZY4Dzxl0U72+9jm73K8lF+ZBS9?=
 =?us-ascii?Q?2N082e0i27k2DNDCGtZa4HwNV3x5wlVuJdpDWpNCnwvLWsHP9iZ0/qBXzOpa?=
 =?us-ascii?Q?EwAJ4Q+LpO0wgQsnWK7ouxcNl51Rt3Llm78SGgCOKS9rFL+5rGfqXQZMxubX?=
 =?us-ascii?Q?GtW6PnZXvA7MAAXLY9aGOHsnO3/JDEs1pqysho7wYHYa+z00jVLkGjNCJ/6T?=
 =?us-ascii?Q?nER6ploqTGyS/FTB8FxFngTQmIp7ucLybu9Lk/jg8nKS7JgNSCqByMg5zTi8?=
 =?us-ascii?Q?Sm1yQybVACs436QuMeAyfdfysynHmEHyD0In/SbG1D6pRRDtfHm7tM+SM5Lv?=
 =?us-ascii?Q?q6F9gwOlVN9lbBk3Ii5vLQAn0VG9srrMCgxg7aKrX4lki0a01prhRYNUJaPr?=
 =?us-ascii?Q?6yZ22pvg+HQA7mUcwI3hKnrc96BISKlncUtNGrS5uZcu8HndKiCBwkejG3hm?=
 =?us-ascii?Q?z3io3zwC1UFBcm/kR8oxk9cheq2sAMJaPuKLIdz09EvnDb3LVyjpumNPtG4u?=
 =?us-ascii?Q?FvLMtKO0brSOKFEtDdrz7VEcjvrHwgr3TwvBAKsmH7ZUjw5ZeMIacF+e4K74?=
 =?us-ascii?Q?zLmZeP60CH4iBeS/GWNhUn+2yLQImd08Z4xEObC90ma2ZFEaedKRFpW9o5km?=
 =?us-ascii?Q?zMZEOyCqjFTgJoGCPi6JjQ5+2khwj2YCczxtEMjLm7KUTeM4iJtYc6KA/2r0?=
 =?us-ascii?Q?4H8kLEy20S7U/+1NSAiWTBV4dh4sjX0HKSL3kN8/qMKPGHLpAwoscvgi/HCK?=
 =?us-ascii?Q?uCOoe4svrH30UdkaQmNIhik7kmXgIiiAZsrbapnJnfVWyye4IPo7UhxLjugW?=
 =?us-ascii?Q?B3TFIQptzLJKCj5/1p/7SfYjUqdKokNrIQCiygnx0b14e3gCXEbXApBU7r2L?=
X-MS-Exchange-AntiSpam-MessageData-1: HeYqbujRjkuwNg==
X-Exchange-RoutingPolicyChecked:
	E6j6dOyFyWOmecFpq3oRLl9Yso0V6d1ABxeTjBiDZsHJXdz1nbIbcac89u+gxYs3KTgkHn2BrgSDkrUZQzVkBTy8feVUrURJAAq4FFgchdCHHfGXWUtwOxCQLmzpFKmRuKa2mJ+gCr0ADmamL0DTVy4PGQhsw5PDiOjFS0uHtoxdRiNY/wj8u1IfDvAj8kWs68rG2T2xI59tV4Ka/oSxFQDQ+eqy1QtC3sqIMjhtaddT5OYviyMkNv8MZjY8NZ6uxVLp6y2HRP4RbPmy5KgnU/jzbkM2/UmosE+uAlkVfmDsM7wPHN2JM9Ivm2Oh8LB03or+ShKxzMMOE7N3abD4pQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j4SFerwYL1OtuBF9U+pEfwLxdQfZklGH6AuNlmZ6m2vpB/ycc5IBuK872SzT5m9XgCiNdUun8wB66xkAmSLtGbPelnP0G+LM77dGJEy0udyajpNu6tcl3DXrIFjSF88Oh04OM21kUnv5l8fAhaIHA9PMOiTMXfDaT2nj4TNBI0z9Pi/UE+0/4l+ufvqiBZWEZRyjtPufGcXSA2bAO96xu0vo3/8IP/jgWAcpphdnfIuLBz56TGZSgsjysQX1wGZI/gzipImT0XCslCIX2uM+EY/ek/B0pPbbNjEwtaKsi0jfCDmGhLOFlt1qywutrMLi1flyf+aCGF8yFPJckgqQPZyg6Nb4xJv87eac2vgtG69HYRVrfEqCq3iiU29mDjcjpegj1G6xsjyDgN2kqwqgJMbZE0//u1Pc3roLzElZ5MP0eKv51nBhzh3JAEM1PHBkb2awvVhOpvQKrKK9f/rdcUJ+K4IepQZAi0c2JYrr6YzOMdlzV1UtCmo7ifrtZlTa1A3BL01hO9COLQC8mjWhKxHY0Nxy0aGBfJknnHUCXHR0BaNPya26K5IkaRC7TC+Pw6J7tBiPZN7UCWtOYQbVsMjNUfSIkPDkHWY4WG0aGSuxdmlK2PinMlBDIzc/jDpG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943bfdf4-ae23-4a25-9e87-08dee8d2b661
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 15:54:43.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJwe8Le7v7NlrDuUdWLHxVLImRLKZxeBaEtKM2bHYsVYDEAB0Jcq6LvZL9roUO8aRBKRmTc+AR3QMpUD6ThNQ9zUFVg7cfab868X59T3zs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9295

btree_writepages() writes the btree inode's dirty metadata in ascending
logical address order. On a zoned filesystem only one metadata and one
system block group is active for writing at a time, and
check_bg_is_active() (via btrfs_check_meta_write_pointer()) pivots the
active block group as writeback moves from one block group to the next.

If the active block group sits at a higher logical address than another
block group that also holds dirty metadata, the ascending walk reaches
the lower one first and, to write it, has to finish the active block
group and activate the lower one. It cannot finish a block group that
still has unsent IO, and during WB_SYNC_ALL && !for_sync (commit)
writeback it deliberately refuses to wait for that IO under
fs_info->zoned_meta_io_lock, as that can deadlock. The pivot thus cannot
issue the submission itself either, so it gives up:
btrfs_check_meta_write_pointer() returns -EAGAIN, which
btrfs_write_and_wait_transaction() treats as fatal and aborts the
transaction, forcing the filesystem read-only. This happens
intermittently under metadata-heavy relocation (e.g. fstests btrfs/187).

Flush the active metadata and system block groups at the start of
btree_writepages(), under the fs_info->zoned_meta_io_lock it already
holds, so they have no unsent IO left and the later pivot can finish
them and make forward progress.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
Assisted-by: LLM (debugging, commit message)
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 113 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 92 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d119dcf9e34b..e3125ef701ce 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2383,6 +2383,76 @@ void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start,
 	}
 }
 
+static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
+				    struct writeback_control *wbc)
+{
+	struct extent_buffer *eb = ctx->eb;
+	int ret;
+
+	ret = btrfs_check_meta_write_pointer(eb->fs_info, ctx);
+	if (ret)
+		return ret;
+
+	if (!lock_extent_buffer_for_io(eb, wbc))
+		return 0;
+
+	/* Implies write in zoned mode. */
+	if (ctx->zoned_bg) {
+		/* Mark the last eb in the block group. */
+		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
+		ctx->zoned_bg->meta_write_pointer += eb->len;
+	}
+	write_one_eb(eb, wbc);
+	return 0;
+}
+
+/*
+ * On a zoned filesystem, write out the currently dirty metadata extent buffers
+ * of @bg. Used to flush the active metadata/system block group before the
+ * ascending-address walk in btree_writepages(), so that walk can pivot the
+ * active block group away (finishing it) instead of aborting the commit; see
+ * the caller for details.
+ */
+static void flush_active_meta_bg(struct address_space *mapping,
+				 struct writeback_control *wbc,
+				 struct btrfs_eb_write_context *ctx,
+				 struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
+	unsigned long index = bg->start >> fs_info->nodesize_bits;
+	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
+	struct eb_batch batch;
+	unsigned int nr_ebs;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
+	eb_batch_init(&batch);
+	while (index <= end &&
+	       (nr_ebs = buffer_tree_get_ebs_tag(fs_info, &index, end,
+						 PAGECACHE_TAG_DIRTY, &batch))) {
+		struct extent_buffer *eb;
+
+		while ((eb = eb_batch_next(&batch)) != NULL) {
+			ctx->eb = eb;
+
+			/*
+			 * If the eb is behind the write pointer (-EBUSY, e.g.
+			 * already being written by someone else) skip it and
+			 * carry on. Only a hole at the write pointer (-EAGAIN)
+			 * stops the flush. The main walk in btree_writepages()
+			 * then deals with it.
+			 */
+			if (write_meta_extent_buffer(ctx, wbc) == -EAGAIN) {
+				eb_batch_release(&batch);
+				return;
+			}
+		}
+		eb_batch_release(&batch);
+		cond_resched();
+	}
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
@@ -2418,6 +2488,22 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 	btrfs_zoned_meta_io_lock(fs_info);
+
+	/*
+	 * On a zoned filesystem, flush the currently active metadata/system
+	 * block group(s) first, under this same lock, so the ascending-address
+	 * walk below can pivot the active block group instead of aborting the
+	 * transaction commit with -EAGAIN.
+	 */
+	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
+	    !wbc->for_sync) {
+		if (fs_info->active_meta_bg)
+			flush_active_meta_bg(mapping, wbc, &ctx,
+					     fs_info->active_meta_bg);
+		if (fs_info->active_system_bg)
+			flush_active_meta_bg(mapping, wbc, &ctx,
+					     fs_info->active_system_bg);
+	}
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		buffer_tree_tag_for_writeback(fs_info, index, end);
@@ -2428,28 +2514,13 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		while ((eb = eb_batch_next(&batch)) != NULL) {
 			ctx.eb = eb;
 
-			ret = btrfs_check_meta_write_pointer(eb->fs_info, &ctx);
-			if (ret) {
-				if (ret == -EBUSY)
-					ret = 0;
-
-				if (ret) {
-					done = true;
-					break;
-				}
-				continue;
-			}
-
-			if (!lock_extent_buffer_for_io(eb, wbc))
-				continue;
-
-			/* Implies write in zoned mode. */
-			if (ctx.zoned_bg) {
-				/* Mark the last eb in the block group. */
-				btrfs_schedule_zone_finish_bg(ctx.zoned_bg, eb);
-				ctx.zoned_bg->meta_write_pointer += eb->len;
+			ret = write_meta_extent_buffer(&ctx, wbc);
+			if (ret == -EBUSY) {
+				ret = 0;
+			} else if (ret) {
+				done = true;
+				break;
 			}
-			write_one_eb(eb, wbc);
 		}
 		nr_to_write_done = (wbc->nr_to_write <= 0);
 		eb_batch_release(&batch);
-- 
2.55.0

