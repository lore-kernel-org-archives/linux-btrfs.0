Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031026;
	b=CfzqxiMGl4FPRvaA55Lmyu1QDwSajF4Kj8XmkozgKrLCho7KFG06w1K6Ma6fa9ezUDV/
	 TWRtnTjprVVSgVKqxADgG7/k8MgZQqUuYLufEmEYciJHnd/3O3OHl6tGF0rjwl19//WDT
	 qMsKTrtX8GJnAn8q0qKAaKnX3alFb1aB221SEjb3aYrh5S6fpvbB4TAFYQ9auMEJ5EYFk
	 AZwEH+kDVe17de641k7TNQVCoF/40BpB7e6nJnAT4ikckAIWjYhAbbRWJus5TlCyWWllA
	 kT4ApzykKeFd5ONHvOjjoKTWCdc3JYxONu0dI41GgnxFVaQDDRX+ec1r5WVmQWIH7mQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031026;
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
	bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
	b=MHaAoERPFazqpb8fojvWDK4pbl1gUcbD4s0/YwPv38hcoXtWYsbHgqX8cG7v0F3NlzVt
	 euuhlr+Jg2FzDCFTrRzzUMCCek6l9bC6Js1XLCLhe6DFAbqedTYfgnVl1rOFZyrfzpGFm
	 GnAwIPXzBXj8yPgHVKiYcvmJm3aC+5jiuP9xjPYYXhLmWxWvly0tIVI9sju8Ne+OISNVf
	 luoXD0DNFbT4Lyq84pVA2AjMIV1ruZ4lTDNYzeVkXxOHco0vNx/jOFUIZobFNq6J2SRND
	 ZZW96tCefAVIEWh04TleIOg238RNUI50c9f1K5/qVK/zGxcJwqDwf24T9iL197GBQ4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=k+elDI8s;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Iq80P2WK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9956960A2608
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9956960A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=k+elDI8s;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Iq80P2WK
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031025; x=1824567025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cUqYaDxT1RLFCWhH+LO3t06+/blaW3BImS3lqHr7b4Y=;
  b=k+elDI8sOYRDL2U/19kVckKNoiBVRYR1ZTq2is7nqTwXeGDV6mrRp5Li
   u33BlR2ZcOTH2XrGTucwzHgxSmIOAWV9PXhwCEl9GiCh2RXS0/BNf/QCr
   HEH4M5ypqgHPAetq9OlVEZtxpHq0G6khVpCZhBiF0hHMyvRlI68did+y6
   Mbpu0ff5PcZ4gRVc6W5VBuJHOCSY4dgXyHx56r9Httnth87FN+bqLBBI3
   ymWzJt73IrTorQYORc/Ibwh00YkX+vQvsYoT1DJyBNc8Um3PT+TIkdete
   LmVkBZzZYzzqD6tnUhahOQoDWzeHUDCh3SIiIMw4x+RJztJFF6iXSCFMn
   g==;
X-CSE-ConnectionGUID: ygSSUWXJRgG+H+x2Re3zBw==
X-CSE-MsgGUID: hTWId+UsSaqwwFryyeK/Fw==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158929293"
Received: from mail-westcentralusazon11010070.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sBdQ3jFRwKLIgN3JKfDoHf8vzq1cbPGvUMgq5vB0rfAgvl4xycJoYGXb0q3QdugyXL6VKUX3mChrIR+QYzA2hVqT4v/ei1VPMWau5WL6lHnOqqRFhIXzfZ9wMzhWfnpw3LOn625USsYa1HajsNBR90moiL8/meCQJ2vTncfdcWxZRUgLTzG3h6BWbhxU9C2glLPCUZl0oKheThvMdarSM44gfXby97TJU8HKAzP3IkUEc8i1ObKsbFtci833uy2769JRr5m6mYMBVOsP0+WzUKhKq0qRItjAuZ+sfPwyznGClyP4KhsQhHwj37sq/oUQzKFVZhQgOSgqqTMb+WWIqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
 b=RvkaaH5vZUgva5u0ultPmejpPfnEcMKJX540ZcSKaA93VvGAgICQNIxV0CzRfKIEF9TlUA8kMeXUFvmWgXKPux+a326ZXBM/MBRWl0/SgM4fv2+VX1P54WqBP2aQiwk/pPSIbotb+EzFQkgdWCG2hk1B2zuotxirpSYDokYsCO5ffjzNQTjykJwInPxbe1JSi3QpE0fqctgHHYHNWXJ5E/U+zezT2dnXEBJqwPttC5J1DyUkUg4IbsHgd6FahacaitGzMTNWwV6bfwxUB9ZJYDtiZ17nUyK+A9lZjihx7HbhXwx03vQlfk7mXHSCYHfzE/DRaaLhJRXLY0tr1rSpDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
 b=Iq80P2WKj2gX661ZwEjVQcqZZp3bBBApAgJh78/34tNxJfGRRhNH5kSrHzTgBeyCdhImDfDhb7clF/7WIneQCZtLgntAjh7OvuBfBS77BhcPdOkK5ka9kHxJRiFpXTzL+4AAEpknOPMdyL0iUnxwSHgPl/zJb/F53JfPYWFVhyw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:10:00 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:10:00 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 22/25] btrfs: add btrfs_bg_type_to_num_stripes
Date: Mon, 26 Oct 2026 17:09:10 +0100
Message-ID: <20261026160913.207909-23-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be40e3d-e122-4569-0090-08df337b9572
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	X4o4Xbx4j+yMHR8Ja28+0xtsKBWpQcYr2wPrpm7hGXUMWP24A0ZGFIDVO+3QcHAZh4p40DqoiChHxG8RyHmNizLQNukGp6vgs0SwVigZ0Y5fiI1QRfFcftvFT+sSE/IYnztnXXkkSsUP8AQZn6Q0y7Bs5UlZacqgDaNVU4oJ5Z3df5n2bPxOQtEhkL2dbrF/VN/p9b/OlnJMUFvRro10vnD5uzBkGn3Xu4EYHjk8ABtgcC32zK3amQb5hD715a3hMIMkad1JhRTEifHZ53kGSJi649ArwwVVtmm6JHVwEyDH0A9BOKy0At03Oeoo+8YAeBlMpNpm+2N1iITQFhBgj6gKwgxdvvuqBdo9V7ZsesId6p+UR5+vKyRNOvY/tPZO6uB93h/x9pUVtRM5fYUMjVDdziCydMqiLvB6ic5pMPThd05ympciWs+S/ZAdSjX31eGP4ay3z7lbTaUGBtzvPxxLzTR0XXL5P9Bjmr5q+Z/jcTMUVvLcdCKFkGQWv1+gClhhP37W/h2LJ3w36mYtZ/XEAHzskjywbiGzXh63Ur54MM+oIMSJ73ZqYa/wYsoltzgbXQPKlo/NPsHObdnyu0uBmJW8ulSCHuv/xMk1JejW6fiUNge/JW5h2+L/EJFaUEPBue72m0UGidBWB85fcZnHmZZkfGvMyFXdgAn9+is=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NqBJHiHrnuw00mThbu7BjIxPXxAECm+WBkoUCATNhWdBmurM2qByd/1hM5sD?=
 =?us-ascii?Q?LpIxap4E5P6iEmh9EXgJpHT3vep6TDH1/KBtQuWoWMMpQp0yEkrlhGs1Kk04?=
 =?us-ascii?Q?FZ8k0D/jfqOaSa8zTZlDOKXru8fLU64X2G0zg7HbkyLJfcW2LvyBbgeYWBRz?=
 =?us-ascii?Q?wpK5lGBmNprxLIkhPpynoG48T73WwANK0WWREjddi4B3C/G/qkTOeY94sUsa?=
 =?us-ascii?Q?nmDi/yWTu0C3qQZKQKoiMwLKitZ4zI5iFNMwj7pRc4ZMn1ggEhvmtT2FO6LE?=
 =?us-ascii?Q?f+/5cNzKShRahEA6izAPjSoeRYZLRoAIpqGFOdv5gfznKu78U+uaZV7ofmA/?=
 =?us-ascii?Q?qVwqghyNQLrA6DOsUWFdYt685sbG/B8dyT4biZ+/LJasmioJuHXlIElzp8Sf?=
 =?us-ascii?Q?txWHOcNGtZyvO/5L5RfVE65Uj0acgHxJIqWB1ItVYKTFb2P92O4t/je12K1k?=
 =?us-ascii?Q?OxvJjj3jMuHTg3xaxgYVA88dBC9CLhgzkD1mHTNXyxs18P8/J9gnJ8tCctuF?=
 =?us-ascii?Q?ffJKhr0pAqRFGVOEiVNvpyXjY806UTvXbO36GNVbMtw5qQQs9myGc+oImKUL?=
 =?us-ascii?Q?c9T1lssby5eyeqsGSiPaXN6S8rgunEeUW1X9nwrufiA+mDa30jGXj29+l+Qg?=
 =?us-ascii?Q?og4ADksMP42zluOHEKBQwPV7KsGvPaBY72c0klERGtGn94i2vLXZaBcOZ7V3?=
 =?us-ascii?Q?/gqhHMbF4DA6m7xBWDAvJ76dpfbjVTKYtk1hibeS7mg2fbbMoOvjSn/j/wnp?=
 =?us-ascii?Q?7ckirq4HU+qh5l/hGhmwvu1SsCsLWy40ctQ/I7oq7DUj50L/i9rKbMYRgDqg?=
 =?us-ascii?Q?IgVl2tbWYvQ6IzGLMc8zheQ/1wIddfSa6MyAZ869xP6cScZTxgtFe1Ddbq49?=
 =?us-ascii?Q?k6KoOEE7ISjve2U4oMXpcgIk45hhmn0eC/3vAV1J4CYRA9EXRLTOPn6iMoyS?=
 =?us-ascii?Q?eO8DPRGE3lkhW5a7g8bBtRQnAkBndmtHCJAn2PZF90XgUVUOYIYk+ULFKHoi?=
 =?us-ascii?Q?Y5DK333wkt6HlA723+V2hU7AbtmxukyBqWT/ya3rhyQ6Yg9XPVs1w5R7AGXh?=
 =?us-ascii?Q?dWoSOUsp8yXnAIWFt4T/FICp1kDnAg5s6aO6N4HSzuQyIo/e3x2Z69GriXnP?=
 =?us-ascii?Q?P8z1AWyypvkxwEigUexcXYr/TGfm4GwNpvT8fBn7Te9GH0T3HhcQjZ55GC9x?=
 =?us-ascii?Q?RxEMbYKVXhfbFpfB7Y/zdNGOiWT1ayzcF+eqxqKkkKUllioYQJMMLPtZu6eL?=
 =?us-ascii?Q?YzZi2tnxZL5QS6MwwAngGKWi4x5C+3vCdjLsSeKLzgfzvGJHASVJKR/mGi95?=
 =?us-ascii?Q?OTeMGUUUdO64hh9jVH5HikJRXF9tNPQrhiPpuBVgQsnM/d+mH6+h1WMgMivL?=
 =?us-ascii?Q?rLLORKmvmbun2B7eCYqiz+cAkq8rVsliewSlxzGBadsQFbFR9vGcPqVdL9le?=
 =?us-ascii?Q?lYKoKjZlVvf984cNczJgi+4iSwg+nC+C2vArSTffjaKrxtlw7pe1xKgH3uRM?=
 =?us-ascii?Q?6zPJxjdnSxao6F5/Muhj7kAR+nlk+97bgpRdocQc2T9ZwN/Q7DJHupxjq90g?=
 =?us-ascii?Q?iYn/UN8/ssv+aXWoYRKS7zdNRJYeMcdIKjV+aEhpwfZz/DZ3L5dPS+Csy41F?=
 =?us-ascii?Q?29QvVNMAPWa5R2bYi0+d2vzfxO5n4xpAonvpUrCX562vSPV/IM9NyhNmREw+?=
 =?us-ascii?Q?Tz8EjM27qGOPpe6+mqvhfI2rrv7AfH8Brvej4n2G7EiLuNnkZ3VozVMf6QzY?=
 =?us-ascii?Q?2NVfko5C0Tn3E04udrbKmsa7vEKQV/41PwOV5ZFq1JeReGIQ3F+1LoHqoUIq?=
X-MS-Exchange-AntiSpam-MessageData-1: 5roD05pRSEfZCg==
X-Exchange-RoutingPolicyChecked:
	dKY+Emby3+ejotVGWIJHNY3zlg35xyducQ/CKzSfm6ZLBCmzibwPC6c7S/Tkf9gIqa11hjeHo9Ou/vRi9Whvncb3rN8tzRrQCrsJvGgnE7jzEM5H/5ybfLSygMvtzS41sL2WZR5MjSE8BObF11y44XUplPSq2+WuQEgiod4nQPQ2nywMpU2H+8rCP50V0UjeMLohK553LxAYzLwm31JN+zVq043tB0HATzKJYSA9bw2pypQZsQEKyEC0qckUDEPvCWM3+PsPNAM1DD6x4lyc3U3dP7dwF2i2V/1S+iIH0H757ychwWw2Ur60zpWcOipK69OVK3hY3zmU9m2OAaeWbQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fbFjurtUni6an6WFO7PqDpTEdNP9nsrdn9AE+8ahRGhkFCaXxTlBxJRLY+XoZ42dleVAUJ/5Jc32DyZ1xTPO1p7cjRTVPFU5Cxh9f/prqf0P6B7E1Kgk1Ofde2/4IzVMc/C3jl96mmievXRYyid8t+AB1ZQO4guJbnJjijexbGTMgfTl9ksXAFZMlMgW0X+6c4lCEyUzRaM4Y2pKsStrelzcrgK6QBbAR4dsNWE94bbJ/BXBUBe8nfK8EAsIvlN0arQVcsKvZyloygZ9GW144iaYKiCrUpqRHwKGLoDGMNA5I5sfCD+p0kYJQ9BINf6WkMejGta2M/BL6WqNlsaC16YD1ZgUIIDh2g7XU8/oVj57LJ6wPhMHLBLvLlMoJx2ChPwjosMxI/ik/jngmy7Qa5uD3mebkgc7aE0z960O+Y5/ofpcfD2MGAurUrA513hkjVLFRQIHsjTcvr/SUiJPoW/bMRNI38mCPxDbx53WGPMH0aLaKd0OPlP57t8DQ7U+BxvjvffQeBqf/aymyPDA9KPJuAMuQZUu18/Wsno7QFpI2L+DFKsPdXZ4+wAWsGH8Pci14JNJqLoWvMh61wMoHr60NdMULiHJFZe9BXyR6/fl7rrels6Z+Og1et+rdxXD
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be40e3d-e122-4569-0090-08df337b9572
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:59.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u+n8VxrymQrQtSiCCvCZcZFgScOywRKQ19VdtAoDbdAVpheWV2Sc+KvadCVC6d9J++gKFz8TqQXL1V4krbs+9xebQtWILIoOJN27hqRZQ3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

Add btrfs_bg_type_to_num_stripes() a helper to get the number of device
stripes a new chunk with a given allocation profile takes. Profiles
without a device limit span all writebale devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 13 +++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9721efec4e45..56cecb8550eb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -195,6 +195,19 @@ const char *btrfs_bg_type_to_raid_name(u64 flags)
 	return btrfs_raid_array[index].raid_name;
 }
 
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	const int index = btrfs_bg_flags_to_raid_index(flags);
+	int ndevs;
+
+	if (btrfs_raid_array[index].devs_max)
+		ndevs = btrfs_raid_array[index].devs_max;
+	else
+		ndevs = fs_info->fs_devices->rw_devices;
+
+	return btrfs_raid_array[index].dev_stripes * ndevs;
+}
+
 int btrfs_nr_parity_stripes(u64 type)
 {
 	enum btrfs_raid_types index = btrfs_bg_flags_to_raid_index(type);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 75b1179776c8..27e0ac8fcb14 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -914,6 +914,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info, struct btrfs_devic
 enum btrfs_raid_types __attribute_const__ btrfs_bg_flags_to_raid_index(u64 flags);
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info);
 void btrfs_update_per_profile_avail(struct btrfs_fs_info *fs_info);
-- 
2.56.0

