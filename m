Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2B745BD7F
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787586725; cv=fail; b=dewWy+d7wx1aVCkj1QwUQ9A/yJ3QXUvB3kM4RALZUn1koswK6Ayubx5jG3Xzk/LlJQDbSgOxoeZOAKw3P1yuHnSGrCVEDbUlH2OswyplOAall46fwyO7AUAqcRiO9BdNAY464u3JyEkHtMwbKkzkpCVzagTq4DIMRcJ2GYMijIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787586725; c=relaxed/simple;
	bh=2aZjk3zS6iMONB3sQUO5sRYxkPCNBtl/+vufq6P/oMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GLqmguElMHASqFasl00xkyX+yT4nmUij054fqEt9x53IP6KmvNCzgKhxFNUkPc0tJ+BwBMV+eRS0ChLck0ttoDtsKYrpaEwxElQWiokPALLwGI11PF0WMaw+eUO37tUwnhuqKr8vhiaiu3dPvmOM7rPXNYDjAdWcVnpuyfjWc3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nB8H+nrM; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=bQLQ+LnN; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nB8H+nrM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bQLQ+LnN"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787586723; x=1819122723;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2aZjk3zS6iMONB3sQUO5sRYxkPCNBtl/+vufq6P/oMM=;
  b=nB8H+nrMqkzgvvNdHXYUyljvrYLpDncpfT+cxpU0maioQMZSlbFfkl74
   w8jnzMap7MqN+IHk0fTM3alt58Y2gLDBFh5OA7dmf5abeweJTztxlIAyu
   GJXQ8yakFCxDzaVCCBKz2RNYwPRygJTXaSw+l0dDgR39fVjR94+VrHdjY
   hKPwKrEpFkQeVc4ktTskoYHFmJJexbU8cic7PDK9boP55UucluQp7XOb6
   dOJRNGARK+RLXH6n9SOSIW3+mmkWD+s1vz9Y7BwI3qhebIBBqhceOO0vk
   SwD4aeqRY0tVHi8Uf+/cW5N2IuoIG2uBL7dQTuE0HeQQx5ub9B9X2IKNr
   g==;
X-CSE-ConnectionGUID: kb5Vy3vJR5eGcqhUXYIznQ==
X-CSE-MsgGUID: n72eL4WwRGOA7hjILbrLpw==
X-IronPort-AV: E=Sophos;i="6.25,240,1779120000"; 
   d="scan'208";a="149966801"
Received: from mail-southcentralusazon11013051.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Aug 2026 23:51:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEUBww308LdFuWPPSCg6xSho4ydwfnBAYkXQc2j1iN27rjolt/unrIcrRFBJ6PHO4ckCBrr1tsXeb4V951YJBNgyXP39pPMyuApTTOCB5aWb7sPGqs9NjQU9geDswG3OH8ZvSDuzqpI834r9bduHGlnkDG35GDoGQMK+t2y535BcH4cR3ZXodlz1M+I8NSxtIK9Bt+/y3QYWZvArjrz6IvALNHrPk5lPazykwo9PS7sxfspFL+o+uH3wMmmqSXOxEbyjLGny4vOgJNSJmD9/PeYDXazSOB1b4fBrPo7TI32vKiJTjnUTzNJM8pjwO7NyLd9mDIt+CJBHQQtqqFsq9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aZjk3zS6iMONB3sQUO5sRYxkPCNBtl/+vufq6P/oMM=;
 b=qWj6eak4HQyZWrI6mJhkSK+uEvTgMZrTun7viJ1jE2qr7WXFYE9RmPCLkpOROistn82h/LkqJHuAEma2nnB/smLxaNLa0OOtSrkI+gTrZgNdb7iBDdYLvWoPL/McF4AzFi3wdRSXxKBG0L12Vqu09FO32g0+mfh2hZPIJaDNweML9LIW50AnC9Pzh2xc1STqRVbr20mc05NWR6Lr3eQliMYE+asFF0jCZrQNPfG7AZ25qi28pcqIPzgTONk5fq5FBNJebDMJjq2BFiN49Udmc0Z57IoJkOkWsj2DBvbIw5XfjTwaWj28M3CxtI6b/yNm7648q91FHdv120Fsr0idjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aZjk3zS6iMONB3sQUO5sRYxkPCNBtl/+vufq6P/oMM=;
 b=bQLQ+LnN3XWYE+SPY57Bv8Lccovx/9pDSfBeXWii23JlSDoRLyAigYrHOrV9PgCcHuG4WbbjyCZs04tP7dBUUdvwudKoOWSDVjO2BGod5FFRyWb4c/oq3yp/WMz3merdsYY6Yy9lGhJLD4VIyx0k41Hxm27ddm2ta0RH5f/+NJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9155.namprd04.prod.outlook.com (2603:10b6:610:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 15:51:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 15:51:53 +0000
Date: Mon, 24 Aug 2026 17:51:43 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com
Subject: Re: [PATCH 3/4] btrfs: zoned: remove obsolete non-data block group
 activation helper
Message-ID: <aoxoWY78ZKJS3fyv@mayhem.fritz.box>
References: <cover.1787551793.git.zhudongjiang@fygo.io>
 <4a9260cdc99fc4f720cd50f11e2c343feec24b05.1787551793.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a9260cdc99fc4f720cd50f11e2c343feec24b05.1787551793.git.zhudongjiang@fygo.io>
X-ClientProxiedBy: FR4P281CA0244.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9155:EE_
X-MS-Office365-Filtering-Correlation-Id: a8265c31-1dc3-4174-4bfa-08df01f79e65
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|10070799003|1800799024|376014|10067099003|56012099006|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	3icJL5VW1NplqWcnO/TU2zdYQ5ELH8hidEAZ9VEdlECML9yBFPEPhzKKvlm9gCIQUW5iFbu21DvwiRUP8LynuQ884nKqJe1JQXVwMeGAqtyumwEUYayLwp9yeRWweD3vYbjrADAATPV0BOrU4a5xp3q3HbnSRRP9I6gE6z7ZWmFj0yszChf2OC8GatpoVWosbMXleFb1hP+ZaX0dXn+G8cxsJNiMPhUtvU/JnCizt8q0P8D+36Awz/Kclmdb4XMaHGI7e4OpNgMy4aB8BXdUzaqor0aMaYztNJyChFrzGX+/f30xlNAGIJs0zDrEOcB+BNTZZttP5fWIRxgwfesJ3zzBUdC0+OAfmuIV2OZLTUeYZPpCZh/raGCwA5RjlcOhFuBWjkspD9IpE3cqk8Q124Ji5ZjGEEepblll6pwFO8gtFgA2amGdy4VheCrVCCf85rDoJLjyG/O751B43LKnZxNR7LqbgTTbT0jz516qgZr/Dw6rajNoiBa7y+rtbUgsbsshHLwDvedHVuAXvA3PQoLww5OxM2Vx5WdxJ89yVkRk7a9HmShugMpwfMrId2tthmV07zgDGFh8LAdCY/JCrBlF0mfSwMDNOp/s9FADFlUSYCzvaRXdL30lvkOmrP6OCsXWgtRsJiuSzGmQLsV95GMSmxdTmA7DkYjv/rdXGSw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(10070799003)(1800799024)(376014)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D+Ibtx3cD7kh7JqEuhI+tDD/bZQK1SMxKfXzUVOz7Dl2wLaiJsUb2Tx0GFaW?=
 =?us-ascii?Q?T+BhiZqcC8dr7M+XPcJufPbhH2hzHPQN7yPxx37YRCdRTU14X5bk/Rv5G5jt?=
 =?us-ascii?Q?y1I+nEaQQKyOI+0aO+1Uty+D4qbxsZJa7acSkLQGDNYBMyk0jwN3h56RbD8V?=
 =?us-ascii?Q?8NosPaauwGuUycq9WCC1XBh2s7mgZb4d1u3RWmFYRdODo6mvLk9/Yv1r0HH2?=
 =?us-ascii?Q?HSpNBjzOPa/jEdHCuhMIeIGbkKdeWE/xo800LuGz0g5evAqfSlET/Vw1u8z1?=
 =?us-ascii?Q?mmClRwN+kuT1nr/c5pLMuKIsn7eRf3Ng+e6tWnVhwmet69/vqCCAKmk5dzbT?=
 =?us-ascii?Q?7NkmVaoRZF9KqV7CeUNS9ZNLEt8YodohHGjVWKwRgVfkULEZkPuma0hNEfJe?=
 =?us-ascii?Q?w0zuIxwFf7WwtCkJDYwytaPTwPgnecQWbH0aXRXa2NXABEVyKtwzhuzdR0Ch?=
 =?us-ascii?Q?mymsDDG3i1pQnlSndJwvTAy1gjoomQh6+F/6OoA/LNFDNiLclwjYKtkKOtwe?=
 =?us-ascii?Q?RCnBlZTwBiF9x/NQOycuNpEFfDBvSJw0mDPnXBzYjuwMcRRKQ2DLmDR42kXJ?=
 =?us-ascii?Q?asp0e9ypRIEG5eltQhqSqEmvHPJeC0Ak8Kn7C0MruXOi9bqSOiNtMq2geD7s?=
 =?us-ascii?Q?cKq0f0frIPQqnPb1hS+RWSUMj+3SxhL8DY3eIb3i27G4m+rZkd9KV56qYRv4?=
 =?us-ascii?Q?YZvJd19QQixup7yQaVe3pB/Tc5MK3KI/pBFSuc3RDTYplHh7RiqKer7vTucA?=
 =?us-ascii?Q?vMIN7C80EyUsA1pxI8S+bgtyOEzyPjajvN1+k7Wu2G31rx4TsQogKCTC52HR?=
 =?us-ascii?Q?04J98tunKR36AuiktrwQw3FFwV4p9fiCUR+IYc/URNICn78nkGdAlv59dvzO?=
 =?us-ascii?Q?OGtvtr5RIsRA3wCpqfqQarcj0OAu6Qy0KamjZn5/LRe3nqkVHKt1viMG9Hhb?=
 =?us-ascii?Q?dgt18YqM4JXiocqMTAsUrsVwMvN75qDeWuoG2JsLWOxrbJBb9WD/N1TVG4qC?=
 =?us-ascii?Q?03Nwx0BoAOXEoey9dBUwRrYCsbaKrKWOy1Y/VcylY9KGOEzI/Y1tI5nP8yel?=
 =?us-ascii?Q?44l8irP6y0ih0/iEQRWtpYlXDBYknSlVl6MThB4C+vlvoCZ/O9ygKUoYWATQ?=
 =?us-ascii?Q?RHaRGRXOe1zRDoWS5gmpcqloXI3uIuYH1b9H+D50rj58XrABakF0iUcLFNuN?=
 =?us-ascii?Q?EWUSjcggj8d04AHu8bzKQpRKlw4dXplEOkZz0KPGQOUPPLoumwab4Lf32K5I?=
 =?us-ascii?Q?5Udb+Y50AdoXcTKjsaBPlc0mIFwfBaznJBygT94i+GDvWi7rXH1ZseT8foQp?=
 =?us-ascii?Q?3VpwS30EjQS8IMTNzzVNq4thjAKhi+uAMNTrmENF9mbbRQ4QH1XuFuwtWmtM?=
 =?us-ascii?Q?l2e3xGFhdw0gKCkfxINgujA98g9LDu+LwEUQ96B6MGXA50zJUkeMBahhypYJ?=
 =?us-ascii?Q?INpfFc5daj0DwAfhfcIAjuU+MvoHgJAZKFifxkaeSSRNEegMz5iez9fnxWrs?=
 =?us-ascii?Q?j6eQCrxekhJifw0R5mK9D8MLhePZuph8XRuO4gkW9NmG0wblc5LIrS/iIXPj?=
 =?us-ascii?Q?rvbMRYuqXKfw13qw3CXqr8toLtFuCIc7EZZH+xTfAv+ixtX29Msvduglf0aJ?=
 =?us-ascii?Q?qAAFOme3sCTFLWmf4zScIe3c//GAWG49eeVxrLo6y9V1KfG9W/d+w4PmIO40?=
 =?us-ascii?Q?t+LCMSYmAmbDNuE9ii3AHsMA1/s/EPQOxUCneDEXLRR+C5StkQnnufclcFT2?=
 =?us-ascii?Q?WOOXSsJgf45qySOWa4VFgqf4gZHs0Zo3VVreJFlcMUMWidbYIQpPuOAEVZrK?=
X-MS-Exchange-AntiSpam-MessageData-1: D1kCWt9VS43KyCat127oIZ7J0pSdEWbSoSE=
X-Exchange-RoutingPolicyChecked:
	QpWx82afBf1gXtAg8/mwmi2+6c5v5HI9KZaVeSLQptGPAZOkXcqbrPDGzc68fbpTxEpfY5ZztrO79JGGHQiMtkNEyTImqv70l4nZkQFffL0smmI9/oPT85k7XNhLaYTtwBLGu64NL+nmrSHlt/VNDwbDhWnARschmEpYkiD9uWWr5nmlMJBU5nZfiXnq0+aMqqEmi8iFnFpZ26/c4ZDagI0pgbb1PdL0bGNv5RJRCarqg8MAfzmQ7blK422nsiYmMns5Mb9Xt4CDV39EjGKGDgv/n3VaGr8MrJyQ4qahzkFTMkw2wVUwEqVSQkqU+ipTLbrDaBYA5zbUdzH8Wqv40g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RYUsY5Og4vl8MfKfkkSqk0bYJ/rNbbxsTk2Ko9IQqaiEaZRXj3LxNDyfEPqUhXZwiGTGh+YBjqwxLODeBgWSijqOvWaHC+dYryPKfbhByw5t0yc0ciY0YOMwPCb69ju3PSjTSM7BBsKBT6id90F7o1xyUBBa1Zc1nYbqkJPIX4Inf/ibD+igG1uBevjDMP3Ow6zrdC/khBhhfn3Wh5PI0tab9uiwKJ9ikXFy+NtHQrqNJF9uKf3SbbHbfaO+IOmhFRn1ri+fxU8nCM51MCVZa4bUctfs5fkjd7z643IBhVQUN3NKVEMnPi8KGQqZdgceLTnQ0C8n8iN9Ed1q/LzoCgU+LmuyOw0uavdnS/XJzA7mrBTOqzQ4H7IPh5dP+DKw0FJ7rAPgB8ap6atK0JVFU90fY1Rh62CTIxlyxkDno7xobQBTkp3hDUQOQuY/VHy9SFvmgP1KOIepkif9Y4RNhozwyYSRaNs+D12B14dvoOTaho7MDzoNKfeZezQRrvDqVYx7+uE8zEHvwaAeVfYYSuuBZHv7ZWZ3bfOPO9TOqX/yvIwmMLrr8sahB4TL0sMElYA04kDWIGoqJLkM6NfK1f3IUTQQDkS2CeStRmigSRGCeAMfTeit2l4ECwiZpDr7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8265c31-1dc3-4174-4bfa-08df01f79e65
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 15:51:53.7151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bq0GK0t2L21ngIydczjE5fgUiqclDArCzw07jd84qwpuURcEEeHDyrl9G016LSzF4FnJkaEI5alhPmX/diTB4AIuVU73J+mKmJ9SQ6TUJ50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9155

Apart from the commit message style nit
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
