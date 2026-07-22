Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108222E737B
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 11:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784719853; cv=fail; b=EV74cX4+KeQjGtPIwEOuc6Z1aYuqgmBwaKPdFNSQYTWt/ab10HhdLWPSIJzFFyzJFPEWQp8y/ZINDx1URKEIfRcUrWbduAE8O6OR/wYqNujblVGfgPkZQysf9BVg4cOLFb5sUu8+0PovjfA6RzBZnYUG4Kk98y1f36aWR09pTzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784719853; c=relaxed/simple;
	bh=KkbMi2NAW31maqxmP3atGIPLK1VKaU7DHdTrKlB5ypA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aq3Zzl6IeUtjOWI1b+94iil5BdORCCodqld/J3qRzzTyiCWN3KQt89wQ+btyZGb0kfikRL5jj8Uo51/I+xCQSGX1a4nmbuXPTIYjth864xdCmgTu6m63yojM3rNDKclowSwqnLdeAmjMq4g6sH9Et8Qn4m8M1dZEYOgu0KF6fN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Fxqecyqh; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=twvgZxQG; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Fxqecyqh";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="twvgZxQG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784719850; x=1816255850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=KkbMi2NAW31maqxmP3atGIPLK1VKaU7DHdTrKlB5ypA=;
  b=FxqecyqhA8xG5FowKOpcqCS/yrNkXV3nGuKKnP/HGamNINYSbfNCuMJf
   vPb2jRk+CgBDW+UCdlgHy6p1oE4nDWY0bLDxwLnHl/iXY7tfk1xZzwoD5
   9NP2kfCVtK0KYJXm5pWD5UOYYuzcrFYDiN/+qnjiroWDbT8f9Ecn8tvfc
   JDs02C2bi3SImnzoxTNs7SKfqu2Gw9zhZ8fbsF6v0sBL9QvMrgF/7RLn7
   bZAyTdJ7i4KwoWFcAcskFnyvE112SSjtnXkFuoT4tdNSB0GGKCr/IpOwf
   JafRox9a3M5Af08PGMibOyjD198efaUU7AuBnG75wi9N6AA6uGMg7fp2L
   Q==;
X-CSE-ConnectionGUID: 00pitF5US5SRqa+cPyxSkQ==
X-CSE-MsgGUID: SG/5uJUbQcaCsdQyTq6MTw==
X-IronPort-AV: E=Sophos;i="6.25,178,1779120000"; 
   d="scan'208";a="151556167"
Received: from mail-westus3azon11012017.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.17])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 19:30:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cvWS0tWpYg9KKCIeh+e9aOn9v0M7JYgnj7xObrr4T21yIQqvTO5tvgnxGFdDYDmdq+u4v3dRd8x6PNCq+XRpVQCGSJLL1YYT67Cm/i69vsWxZEHSMNBkMqGhnhs2Cs9yKUjQMSj1UqEXbsceErmeeU0/6UU+kriKSxwXpyve2KUQeUICGeNA+o03oQVZsLodMM2yF+oi70kvPvwthJloAZNSmxpknTrAvK2L1tl+qJ829mG7TAFctRZb+pT40OqjLYUXA0Q/tRv5Qls8AhwBiEBscyOEazYxyxpSlZHxaCNmHEYopZK1gd3zmLBzNvTHhktDwdxN2668almYmvIgRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMyfW2PZlBeqQERvXib2O6qzmbisxyyV1r3vz42RYPk=;
 b=oqEipJhpLFSgoUq59trHcFpu4AqZLS0zVQ5Zg0/008VeyaNvuHFmM1ghP0PK0ny/0V9sMJNFdSpclqAJFYHv/f1QZdq8vJ2HDv+HkJcRRmnjENqoeEIsU5B/JMjFuu6r3Oi5WsPP/wkcOkb5NZrdKPK1q5nPmkC4xolgEiIGzmSURrm1mevDrpxIo1Q99YjOyupT+Ai+3qU4TmXlCos2/QO8a7unTMsbBqRyBc737tI/KIjqdCHr/sz/jeXpWqEmrsZIq1tZRrjq7m83/9A3DLz+f473bAoOj7t7Pwe1tdpWeHT77lyb1wTgPEu22UD4qAYBUybQOP/6KB+XkHmjSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMyfW2PZlBeqQERvXib2O6qzmbisxyyV1r3vz42RYPk=;
 b=twvgZxQGLj/hs9g2g2PfUR2qhQULcHPOGpzhNtWmL6x+qT5Novw4Kh4x5j6RJ7GG9sR/JoRCZ5YUOKTYdu4FR0uaeBYv/ACFhr+VB3MVkFocON3fJR+0b2tWmqGDCNnQZnw4yvFL7Pi4tgzoQsszYubN6A+6aKDWTVU1hztgM+8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6810.namprd04.prod.outlook.com (2603:10b6:5:245::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 11:30:35 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 11:30:35 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 3/4] btrfs: zoned: drop stranded dirty metadata buffers at unmount
Date: Wed, 22 Jul 2026 13:30:15 +0200
Message-ID: <20260722113016.1896990-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
References: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: dff26450-078e-477e-3f65-08dee7e4a607
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|19092799006|376014|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 VUc//YoeHfsHHzt4+I3VVeP1jonyyYb9Pxw+d9EtPx27GZdIR3A8Fme4XhGPWOZRixYNkFaLVpw/nigyi/RYC832MYBz1Fqdunlnv5758FBf8+KikXbU/Y4QYcU9av17tBsNmhLlCdfGw3jPyjxr2OuPa+9PZGBFRLMmp0sq+sNDBc50KbYC0djxZyO+UJC7Bqx3Y1zQOdWj4PzrS6Br4zJHaCqgNl/48Ot1P3j5E28WI+c2A37aPIo9ESjOEDuKAVqiLdlQbTLgKpCT9R0lxLDfEPAVpFLFrOy/E2XSPlMnWM//sFFdVaorh04ATJZZsXFytC9fxdO13Y4frEa6ApI6jD3IEB68o629yG/K1MZRrI/5ZgZTi3t0nlg3DUz4H2unIUVsMmJqq9AhJNLQv1vohhTKvPd96gCXBZTEq/qgNf+SAgN15tgGzVIuFx1rQ4KeV2c4+UhDCrt9gIiITOc3dpqeGX+DlyLgvjHKV/5j1WApj+pu7S9aAKWHFkUNkRfc0xXazuOstdLJh16t0aaTQQVxuvNyTM2RHlTJf5tqllp8i4Jc/03kfM6i8HT/F359HTxG5m2vb+yj+xlMPbiCcoeNDY7czqhps9VxuS7Wske+rXE6+5acxhs6xNer0FkF3l9eXO/bQUQnTPqPxmAr0pQa3Ro2/xnWLu7MknU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(19092799006)(376014)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?W3PbEYi38SKE9mxLGcYTqNtOq3zJY3ievt91QHf9pydYCVDNr84pXWDr/RLg?=
 =?us-ascii?Q?saKixSpO2RWnGZXdPIe2QrD0pBJY8dlTk+wSzctm8Wnua64d72LgkGgVup8W?=
 =?us-ascii?Q?NPWT9VbtVbVcV5gghjv59gwqQKJHWTfJAnX2tEtmh6laXO0wGgovARMZTDnX?=
 =?us-ascii?Q?aWBohOJv2wXyQxmvTqj+wC/qEW46gcAYRV4V1tv3BI6HxNdgEkyL5upjnmgC?=
 =?us-ascii?Q?cH1ADpf0sbQ58S8qR2SYJ1N/Bd/iPNQDzoDcRDXWztxMtdPIHSqY+gAJ9bBE?=
 =?us-ascii?Q?IgGxnhRmRRyIogDsvWZq98MSPy4No4V/SPsVd4Q3G/2M81DGCwt/t9kpIA9t?=
 =?us-ascii?Q?QQCMefr/Y0CvhqHoWDkyC5k4fVjflTUMgz7WCyC4lCW6E56jAuu5ZgJsTNCE?=
 =?us-ascii?Q?mkWT7IHgQDzS0UkNHuWbDFrRdqChHGZ/bbT/V0v1Ob1fKttZFZxQ+pJN6tPz?=
 =?us-ascii?Q?0tvNrRZ5gv/e2uqGo3rMcxW/y3M04Ru77nHcSDC59rcN2u/IJ0bYgAI8rNPD?=
 =?us-ascii?Q?cMMpg4iphmpiVHsoEbARbmfaJOwB6dWx2ZwFeBh0LPG1ynN00bajUCxE2B8H?=
 =?us-ascii?Q?PehOvkbYuvv4XBCDDb2U5oiSh+0nbvvSSzj7R4owGJOLZbIHTPcPm4WpzTNJ?=
 =?us-ascii?Q?yW4XSZHWB2hOzIwJFDyUZ7RghD27x8AQShn2Xu/CW+ptf/jEd7PO92RvhbBy?=
 =?us-ascii?Q?OOK2mu7+K1Xgr2L5AHOI6ZLZHKPHH7RY45d1rCcQGD9+NKNDrajFF2RUlZKl?=
 =?us-ascii?Q?QxmwCFht42I58LDVhBu9vWNwxh9HBJWKk7XSYPH0vVE0oQUI1dIZbkXwkxOk?=
 =?us-ascii?Q?EXxcQQ5i9SaPDPEvxhhv3+OFgDbg2ZDK9GD1qqucKbDqVzsxRBAmwSWpO08b?=
 =?us-ascii?Q?+vYzZIJkL8NBQQV9OQD6gay2miqbLShmyAtF+RAFyEcfx/sky+fRZ/9Gq+OX?=
 =?us-ascii?Q?l8ZiNJSU8k3EJna2Az5DNb9v1XBYFWsTGrU5vOGSFfWynMRWEIQEiiN2X6HJ?=
 =?us-ascii?Q?xyXuHNI2h9uosg8wpCUi2jTWnE4Y0Z5/Gk+Elj9YlazkiGkmIrxQpEtjjGzZ?=
 =?us-ascii?Q?/VsEAyz/gMeEkhIUPGJRtGwxzIWn4FEne/UvGL/f3AyaBDsiTYp361m20V2A?=
 =?us-ascii?Q?V2zTFSE76N9sNn+q7w8J+iLqBK5WTcV8H1EjMiLogS71rvjAp30XnNaxXhUq?=
 =?us-ascii?Q?DRII4VRHyizgTNZk1MKDPvbv0LkwixeDlQzdOLDaAWKrKi3SRUjvwlb4Nc1R?=
 =?us-ascii?Q?STze+dfMIftYIwcvIe/yBZp5MRS7+piFHbGQ5CM+EoBMl79xUPJWGmivVoUb?=
 =?us-ascii?Q?/lbgE4Hq7Km9Byj7Xr48VCDDxQubmjVCdT6ijoeALYqnDSPxUwbJtyTiTYzO?=
 =?us-ascii?Q?SNQZMAs0GNcmtM6F65QHaQOgSAC7Wvn3gmNfDhTI1EWozZXXc7h4z5OwodHF?=
 =?us-ascii?Q?SiBqYVfcpnLSTSiLUFQYs8lBB/RbARsQUfZgiXLOjJch/WKq/79qEx4Vyok5?=
 =?us-ascii?Q?Mqr2SiKgYi+mrW0CBpgqsSIXyFSkanKhFNuk9LGSsMe+FHAzvIuyo/ZkIvHG?=
 =?us-ascii?Q?tIiwKLDCSHMKM+XMNT/chnMtMMWxohzC/psFfmAkGXP0/KtRKwlhPtIAxKO1?=
 =?us-ascii?Q?wMPQeEjGl+hBFnaOypkOJGiVBrTRrrGGj4BoEQZ9ZgXwoYGZH6i1M+Fo3PtX?=
 =?us-ascii?Q?fuGK+4SeayhoOH0Sl7MqYQboq/2JGog/PVhbMEryo54vxv1JcyslrcHoBc+u?=
 =?us-ascii?Q?PYaQ/8riH7R00ZX+hjxnOJP1Lb1ZQufWPcKIRX3UFLijY6O8lqQV8lf23ibl?=
X-MS-Exchange-AntiSpam-MessageData-1: 0reuHhhkFdvk6Q==
X-Exchange-RoutingPolicyChecked:
	RORewnsApwI5kZJCKdoNeJwdXhoOWA8e9R9mpaT+aITyvKPX9eBZFIIt25BLCIWttruSOm8zdTZIbmyr1WsWLCLScF1kcIuSA3wxcYR1LO2YvkHRhHvVsrONgnG02nQ71Nxkq/p0gID/eG4ZD2vVjsNNJ8z4zLZU5BxqmhRLFXOL4ohVl4h7fb/E+uc/SaQ+IMDRko2r6oFOIjFDOCfEGMEFAzL8yeIJw0EWQ0RS00GD1T16Lu3cp64AcZJyGApO6jeRNXHeXJoxbm8T9OqJNJVTRVOs9jOeqpSLPs6INLxJbBNu4tYGimr3Ttl2i2A5MKlRAtsfbFZgJmpLcO28pQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wYuh+HwXZOx0cCS6Ttm/eQ4R61prbh7f/8vO25fPbVd+RkjjgAgbQAs5mPJbQaUh3nECJbosvVwu6QCy1ign+VgoFCEl4lYgZomLsMi/ykckPhEvpSAbWbOy8nUBegeu+xjFA3NnSPBfFLLfwtoQ9ccMPcv4IYwfvwgPvMu+bOre6ROZV+JYsPlkK92KmLpGIAp/Ls5iYHY56v6d4zK+WjV89DVu+PxRwQuMYEwhRI45F6d8zQsGMvEB4OLKRfvcXIXJ7+sdShIIPxjW9i5KZeKbdW6lWXtdKMV37Z+5SnEf2bljYc2wyqj9V0/PKrkFWl/TRb6OiSxqea1IqIytJT44eldSNhGGH6vuK9Phd+5vqKbNkb664kdMLYqqoclvPUSTg7YamMPmGyjvBQPgOjR1avmHioddZxxtK7IGcMtGnhJpaG4bYaJ2Z/ryHLTH340GtawOVf1wInFN2TLegsat/zpw+1/R31xtnRAfwIdfszfrKn9Tzd1y7lyoVtszkB5owaVKmoVz6LAhDoixvUmPGeLP4moEo2nLTefgRelQiQmLU3FztNR/pC8il2A7zpkaNxYKjHQpl9pI3DFdo5ZiX5mFp6KAi+xXY7lZlnT84PD0kgosEJ1qyPF0YUVN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff26450-078e-477e-3f65-08dee7e4a607
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 11:30:35.8224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dSYQcIK5JELJuiBn1qRZzUQHsFtlpSRkwN0Kd6RNWM66O0VGHileAWJgk8MBnBFZZHgLlcLUA6SMX61F+74LXhpqQTt7dpoypjAq/hT46r0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6810

On a zoned filesystem a freed tree block is kept dirty and flagged
EXTENT_BUFFER_ZONED_ZEROOUT so a later writeback zeroes it out and advances the
zone write pointer. Unsynced tree-log updates (e.g. from rename or link) leave
such buffers behind when the log is freed at commit, and across log generations
they can end up ahead of the write pointer behind a hole, so btree_writepages()
can never write them. During normal operation the space is later reclaimed by a
zone reset; at unmount it is not, and the buffers survive to the final iput() of
the btree inode, which hangs in folio_wait_writeback() once the endio
workqueues are stopped.

They cannot be written back from where they are freed (free_log_tree(), inside
the committing transaction) without deadlocking against that commit, and they
are stale anyway, not referenced by the committed superblock. Drop their dirty
state in close_ctree(), before btrfs_stop_all_workers().

Fixes: aa6313e6ff2b ("btrfs: zoned: don't clear dirty flag of extent buffer")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/disk-io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e84ee395ac7f..48374cec77d8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4539,6 +4539,13 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	free_root_pointers(fs_info, true);
 	btrfs_free_fs_roots(fs_info);
 
+	/*
+	 * Drop metadata left stranded ahead of a zone write pointer while the
+	 * endio workqueues are still up, so the final iput() of the btree inode
+	 * below does not hang submitting a write that can no longer complete.
+	 */
+	btrfs_zoned_release_dirty_metadata(fs_info);
+
 	/*
 	 * We must make sure there is not any read request to
 	 * submit after we stop all workers.
-- 
2.54.0

