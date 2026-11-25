Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602629;
	b=Oz5Li0d7yZmEA3sv2Mb/o88N+KjtaC3/yM1Af23f5DBjYbpJUuScG0F4URJTUxpavX7O
	 WJOHcsqA9Sr0GiOP3m2yZSntGDlQ41+1q02ZiwRUToBdebP/zfkNQt/0RhtOwm9r5zt0p
	 i9TRuXmktv+rLSc53UHFhHHfbxlkHPUrfufGYQ6kM4IkyX+PhSoJZqIVUF2u16paBeW9G
	 0GZJ5XpbBiBJuBADMnrwP/Jq4kZRlla01a9vJvR2V7wGxMP2a1iXRZkZBpn+1Axo46Cla
	 l072VIWl6cUxda8j1F8i0R3ozzjTw6fNoXefnjnS96HoS067ZPgvAXtkB6QqXS7KcXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602629;
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
	bh=DRQcwMrcrvamTprAlcVoCgig54P2XvUOiTyJ1RmWklQ=;
	b=ZjX2vwW4OlPdTLanZWqWyy12C/iNY6aaXOOnhHluKHM1xuI3zV6Hb8RMiQI1B84FpkGJ
	 DKdvw2sHYJcPjn77rXLuzFdQWkQrSgP8BuNdRBqcv6Z4X3ObYAD0EmJti1d4Uu6I06454
	 AN7AAwSUVUmdhnuRCboDyOj7X9a8Q8nOIGVN7cleKm9qxnJz2l3qLwq3ENgIU3KO+F/2a
	 IgsshUyGpRmyjflU0VJj01DllShHUfR/+gUnhYgswVEMz9wwPh3EJfhHEmfuKMyORpd/w
	 8U6Np5sWcDa76CqfcVXX/h09y9F3jj3d9tObzqYeXSrpYT0GNmL7laOlYohF8ffNVWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="cR/XoCUe";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="PD0/uB8z";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B07606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00B07606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cR/XoCUe;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=PD0/uB8z
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602628; x=1827138628;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=pg1xeXqPwQo+yxDHOzxJ3fW0qhmA3lp0IEYK7Grfs44=;
  b=cR/XoCUeVbrHPoW0puBzJLKgIwq+bpS/lVKlvzb0NqPBSiTtjuWugNKl
   D/YyJDBIYePjEyQJAVwDU7vECrKfLFfjTOOJp/7fwgmEQh1vUpxZw+rOk
   KqBV1hUi/3zLxZEslkyNdiyCNptv3ON8oMxm5woTMXccf8GtzYuWrJc8C
   pKsGaGqVGbbjsXzVwbc5IbHkrgLYFf0lNiXmwXORaucGSKv4CZOQuiQ+j
   HR60tGay09XjfBWjgdwV30ujwHvpYyUi//dW3jKg9I/rLrpRQU/cMvD65
   o8iWdMW27NaqAxlLAl35st9rDf6oaIOLAdtTas2GJx1RK/0402ExTSEG3
   w==;
X-CSE-ConnectionGUID: gO478zaDTX6mSYRT76P5NA==
X-CSE-MsgGUID: k2k/shj2Sj25AqldbvHMPw==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662151"
Received: from mail-westus2azon11012064.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ip7z5v5BbEo696hX8FFUnPZr2YRdRVu+ZKFwVRXGnkaU7qVxIgytQ0Tc/tL8oCip4AKvRZ0iEsxbgQzeNMLLEjmn0tAh3tT77WKErBbZhjCCqv2A2zfh8EDSA6IBfaMwGuWKezZZrp9YNT2j1LX3gjJuvAS1taasE5AfTtt+Xym/6382jcgbN99ZICYOqylWYxmcbUtAmAwYckEgBPy2eBaLUy1bMzBocYh1hEZvFOvt68G3VlO3o2Uq2tFsVFGCBO2TY5SlKmx2o20c/pmQXZeLJBeMmkIhHw5RpdGLJIiaBGYUGTD2wjiWpr8Rn3whUAj2sdVnT4oW7wc2XtWU1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRQcwMrcrvamTprAlcVoCgig54P2XvUOiTyJ1RmWklQ=;
 b=s8AAOW7icRjyKQeREP6WP4JVtJxhZuQE+PS+ALe85jplPYRX4vOId8yKFYIRiwqy4TK2J2LUfqy1ufxfRHwuwmqyeaH4LI34WVupkrdoMseR0D1gXKi3NBvbuEZnSccltUIQxq41APsFH82rimADILKPv/5EfVWEI3VwzRJCnqAstkW6DThGdgaeJlma79GLjI0PmcGEHgV1zvwo3ZL47Sd6DhKYLe1t+4TmycilMGmBoEqG5MMBMHHzHCghPgrNwNsqqdkhOJHVr7IC95MSrVZ/9+OEfG4iBoCPh3fAepf3e0GJbIYI7EevR5MfoNBmhssTQGKMZF33JLsvfAVRgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRQcwMrcrvamTprAlcVoCgig54P2XvUOiTyJ1RmWklQ=;
 b=PD0/uB8zkMRFMvq0JcGffbcjccYO+VvLkzuCsTTgslDf/INB6wRPRKVG2MCVubIwN64hAc2mpm71T+27CEK6qTC8UwRNKf8B3eLYstkxfL+u1O3R9mA5rVLP8oUUvvsbMNXz63nOlCkEoB+5Hb5DSSzLr8yWTD0006X3q5yqaKA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:27 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 06/27] btrfs: zoned: never activate conventional metadata block groups
Date: Wed, 25 Nov 2026 11:29:35 +0100
Message-ID: <20261125102956.266389-7-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: bf5dec5b-6533-4087-c0dc-08df4adf1f03
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Xp2OSb+H3ksOuiRe82MVW72BcEFkE30flAnPewczTppIrVER/zSyoCYvVJvku8vcCVvnJ0Pya/9DciAaVRpsjNQ/WPCKESj883qcKTT1WKVS9/2Zt4uhCUXic3bd64nIAk1YPrZweNhOyXTbmdhaC8UpQWE4ZtZldQLrtsHjZJz14hI4pCAYkAGRyEVPb7be7umepexzvQLXQ0ys7uTac//q/PFnBbDi75uZoR/XPy155SIVt/duFt/10IxOL5ke63WFX2/95gid10AeasxQOMwMseFAAcNfS6josoZC3UrysWpKeAq+QG/4DchnsMNvDkHZWWtmYHuN7rEBZB0tGwF4yr5cHFI4xKtwVpesTm5LOszu+01+k6Nci8wxMyDROM06Xb5wSfoW+YE+eOXWXDufEQqOa7CZzsO+LGxEfScwy4V2csrvDGOtg387YZOh69AA9270KXaH0TBebF6mprLX2n0KjpwP5TooUDTLMGKAGkBN51OlG1/tEOpdrHMxQn5XS2c3snS8EOR3hasCWbLxpuMEpFVKHAcCOrfg6B9gp1EPxV339XG2vd9JWxNWGcKFiD7ITCosRMI19ho71y5NDwQl3oCPjVKxOOGEylLI/4t7LOKKzPA2IwWAAMZ/vL5d+OGAxwdP31KlrUTL742utkFTQX+bdbYg18rARPw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qs6NrqXgTXeNRCdY6e3dwibnTM8/nyzIpRV0ATo+o7ZGDNTCc19aqASsjCpI?=
 =?us-ascii?Q?k2ykHcl6x6I68grxnLovVlog1Hecy3WWSaZzUoKmtG8qBgitZK4/7sQMi7G5?=
 =?us-ascii?Q?P7TJlZZ8X18JZrfjqkPD9zAVvFe8hu4riWGDII3DTLleo/qnbIg1dBuT7SZJ?=
 =?us-ascii?Q?vIbd8bJLWtswbvslw3hHbBJUC972m97Kjuhn2JsUD6UtPPiA1M+qoYEyiFsF?=
 =?us-ascii?Q?IEX0C2FG2VZSviia9j9q3MVA7bQ45WuB82Hgl0dWdTLXxG4dCYKDK9whsRiY?=
 =?us-ascii?Q?s7h9cpCgkbBcjJLgyvQZ1nRyhnUqQ3H+mxiJIgKqAipWDyDiXko0vsaBb7Wt?=
 =?us-ascii?Q?PzEuQxkp0PRHhtmzm6dKNfgoxnsPmyteHWK9xm63J6txpduLWhbKNfua5sT5?=
 =?us-ascii?Q?o4lYkIBEv3n5mDxI0jADlHK2j07SdtQ/i4AyiN8LBxe6Oy2e9S7ON86IiZcp?=
 =?us-ascii?Q?pCu3A8roncu3dePwOe8WHZB4ls2LcrsQ4OBTp98CcfGQVfn2LTUYHxLgY5vi?=
 =?us-ascii?Q?M9IdBLTiFDIkIQCjkZ5FYlqdNquV+q2/FukLQ29IUU3lpS8z/4ij8DY9G5cB?=
 =?us-ascii?Q?S5rgtbnPQB3Z7+MxFM1zpPIY+iaTV+aTB5qbMCDhPX1WqYZuynrU24jo0T0f?=
 =?us-ascii?Q?wDF+S18ulX9ri0oM0n0m9JyKizWC+DxyTS6m30z2lZll9v0ReP20DTFK4kRd?=
 =?us-ascii?Q?5nBHjGajUYDL9/LcG1bERy2UloqOEpWBSIUtR+DVlybgWN+vxHyjs3AHuoYD?=
 =?us-ascii?Q?5siAuyHMpo8Xdm/gHalb0fEkPPWAlSlpSRpSKQyG0AqMo72sQgXYpD2e+gny?=
 =?us-ascii?Q?DnhwFK1hWrdJEtdCzw+lnGg6uZ6coBjQf6FfJsgr1Lmg87pmnqIlmnrVODpK?=
 =?us-ascii?Q?IuQ9YGLHyUQYKW/QvBcfpghQm65cln+bgQFTWbllQMNej3i50Y0iKzDAfXnh?=
 =?us-ascii?Q?CuVctuTvOA9p+PXlRN+GfFD6tDemXPNBlcHqGvvbLyv9moxCvRApLf9bAumo?=
 =?us-ascii?Q?fkphc/ZWbG4txzVgTOjCFVvBTJedBM7wJKvIpQdsjbE+UkTsDiFPcjrC+2do?=
 =?us-ascii?Q?XY+CNFARe0svXjFs/2/zzWiAFFhru4haArx7L47QfdWMjqyq/G6kSX4wf0z5?=
 =?us-ascii?Q?bbHSHboaG/0n4VJbV6aEXUZULeAwq4q9rMYc98GneOyUiu+QSegP9rEZj/1e?=
 =?us-ascii?Q?V+theEpUsI5m+BSs7zMRoGwgvJaVsbzCJEYN2gpnE4XbH8K4/Q//XQhMKgwF?=
 =?us-ascii?Q?R0er+QARw6wj2/1yxHnDNDS6pDYgHTaBwrP+JzeG3DpqNgBg/n6mmC4Ww+Wt?=
 =?us-ascii?Q?PWebmQW+CyokuYstF4Y9PvglU3bMDsbcWPhEZO49pEJC/XFeXbq7tw18XVcr?=
 =?us-ascii?Q?zmP0p03KjvqWAQlOu5iLtJpeQDV0HO/bGc67AzExFMmchXpJj+CE89qx4uJ+?=
 =?us-ascii?Q?UfafqK9CvYkHU9MpBvZ39NZ3JVAVOeCtk5hnvL/Ayf4bukDN6KiZ8FSICOi7?=
 =?us-ascii?Q?yR+Pu5P/gfNEFtThUMQy+UQNelR4TMCMCyA1LfbQa3dy2AEv9eBwbRw4J2Hw?=
 =?us-ascii?Q?FmKVyFbCK2WW31ou/TRicWPqRwdJHADmLoIAyLPwcm/eSAQU958x0VdioCpo?=
 =?us-ascii?Q?NHhPby+w8CS2hcbgIJTOrbqH3KnYd4TqLql3YTJ5okHF+dnbAJyglr9AiarM?=
 =?us-ascii?Q?i3fwla5BlwUYPDcqxre+u6VEmnpPgz2CE65elviclUE0m7OCk0OtGVFno5/K?=
 =?us-ascii?Q?3TRmf4L6dBfIN0bPEV/+zc5oVfRi1pcAeK/NlINX6SXNwiuI+pK8RD1TuspG?=
X-MS-Exchange-AntiSpam-MessageData-1: x5nhojHtY9wI/Kj1TIXYBW5kDZD+Y+aGhwQ=
X-Exchange-RoutingPolicyChecked:
	Qq3qCm2EtpJuhlKh8rft+iqU0Gcdu3lge7Hnt3zIQ8TYgAdf+BV3BuPcSJIfcu5IhfRpV+vfYgASvxXGcLsZWbhMU+FqslhvogLuJs5VDBwVEvY1vggMCKjNlcBhy02YoIeNwxQ+vPPlQ/OceTAuke0194r175OjcCDNFvfTeiRIctYFcyVi0lUEX5fBG9KdkGqlfvU80jDlcfx0tLClVfIxu6nXs939b76fWtJRkBVWHZ2Kb6m+iT0xFtpJbqCtP2K9nri+UfHr6R9xmfT6Z7VkmXHw5munSGwh3AdLtZU35X2HqHr0l2LINXUTxIF6Pzvb2hwP3fM7sqcIhk4M+A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KsFz5HfTmI4C+dSZA0SDatZIKhULpyiLh5n645f67mDnphOc1y3fiZMiBkGAevrBz8qF+PDyUyt5Kok4z/KGX+dQFnitxG9mzuyH667Hv6nqb2JU7fVfjsbc/45AoWZN5CLyFhjERXo4ZICeyJIeppCqCQYBXbVB4IUMVdEuo+HMUMlmLz1JTWKA8DCxRE+f0K753p9dWsUMWGGcLGZCWyDwE6a4pQZtCgDrDcGMoIeonnPKfNGqQzdc8vroe4oOglfpf4U1v2Ui+poUb0azwNQ+dkbSkQdYI6q34n4JM0hEniqceMxr6z3R5k7JzhmZ7c1cI/YjRWFL7Uz8c47ouDpHwvXFwsI1KxcYyvv/GiKSMiq1PHIvdUJI7zjPDMmFNzKj77kzeYwYHABiULdsWe673O4MUmXIeP2hA1SPqImiaUIEyB7F+1MSYnT9EitZpQUCBEBSRDPsSVWdFnN9yR1NrvQwdrQD2VSg8MUR1ii48/5luliRfJMVQYf2r8BpkSJhtI70+f6Gqm77HZGgIIloPLudDSoJQDAq8b2meOue1dCbv24wtKzxGPFE96tLEdGoJrl+u4/ImpcAVorQ4JdQpfCEry4pAcvdvMyip5u1eSHPSj6pODfjB97VgTty
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5dec5b-6533-4087-c0dc-08df4adf1f03
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:26.9299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqbrBkw/aNkln2x0PgiFKvvrI7P+XHfUZ/LN4UPAx70dwC48B1m3NdU7eigF4Ad3SEq7Qk1SOORpF+KUJ72656y7S+CelqmMIIs236cCkyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

Metadata and system block groups backed by conventional zones only are
written in place, so they do not need a zone to be active and they do
not consume any active zone resource on the device.

Make btrfs_zone_activate() a no-op for them and skip them in
btrfs_zoned_activate_one_bg(), which would otherwise report progress
without having activated anything. The check doesn't need the
block-group lock: the block-group type and
BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE are set before the block-group is
visible and never change afterwards.

Such block groups are still marked active when they are loaded. That is
dropped once they stop using the append only allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 2279e5c8ec31..ee315443efee 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2462,6 +2462,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -3126,6 +3129,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
 			list_for_each_entry(bg, &space_info->block_groups[index],
 					    list) {
+				if (!btrfs_zoned_bg_is_append_only(bg))
+					continue;
 				if (!spin_trylock(&bg->lock))
 					continue;
 				if (btrfs_zoned_bg_is_full(bg) ||
-- 
2.56.1

