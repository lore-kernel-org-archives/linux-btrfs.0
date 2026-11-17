Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941975;
	b=KK/KlQhK8AzqLV7l9K/PYf3vYfE+eOpWDU4X8k2OTUZMxk804cILW0hfImqmOzUFRDHA
	 B1XjT7Tq8fetgekkZPlbVJ9PcYiMVvsN7LMi+AoIUvBzqbN4JUqBBFs+frjeLD0dl/R4W
	 IrF9AqA+B0JzPAYBQXQLbm5w+75M1cY5TV6bN8VpyP4I6u1ioPqoL3ISfRvSwDC+E8FIX
	 7kMeRL2AxRanXrJL+9OBPP3TMtoN3rjbza10ZuKSoHNnPppLAAGAm/vnG6PCti55Vqbzh
	 upx/2fAWS+t4Yw9EK4L+U+EMCD1nw4m3Abkl/kPqWIlTN1l7wyT75xidq2iz+jJF2Sw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941975;
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
	bh=EcZBH5TwG6eRiPieiMrGNyFdGI7BIFIF2eQ4uKavmgs=;
	b=DiftQ+4loLMs/TmRV+a7NTeDXb7yu4w4AKsaYl4yODxCASzocajzZ9liEz8yX8nRGAhI
	 IWkFEmC4oiZ2ENQ3PaOf3cNppRIxER8+lONjqYDvf754XFtlIOfGehvhnpv2Y7RZ9eJZJ
	 6mFHP8scaAgdO2eNSWJkubJXPewbN8/fzKz69F+sAytXJt411rZd78pDnCqW5+s955sTp
	 YpwBuNAsDqmqbUtT7+0FfhMGL5kIu21O02xAVckOABtaUykoWjbn4CBbJX9PzUNEKlLec
	 tpaFgI8KHGavmZCMs8Tw66qfB5Ws/1+Jh8cQ6gtXbH/LPLKPzYppneFxZQcZZDfRlKA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=INMa5hp0;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=a3dnRgl3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D11C606A334
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D11C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=INMa5hp0;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=a3dnRgl3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941975; x=1826477975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uEqvD5Uo7op4Cildkcq+Xs0SyYwIamd+31aq0qNgtnU=;
  b=INMa5hp0Z5WQpa97XIB1RnfexrakIGdxRC4TKMhibqz/aL3cjdWelIHx
   bsnuhHemquA2YzCSU0vPHU/W+LrQNFgVnsFHR34Nw/EEpe5ZXhGlcqBz5
   uH5tAP5GfUUwALdi/ra9qDn1puWkOYFqcg36lKbwZxSvjn2MoCRyqAB1T
   FzsVFpADwq7aKJeWW0OmYVMbb2OhBIeWH9PoyOjdQfTDcECoyO0092hpU
   7/jkOj2H3McNJnq7vBaUKhu6N4UtQmsYme1u0slPMJ6C4A3WsPXrrAm9U
   Q0ae3PWlOQustmva9IKj/fQkFDA5X2ikgqi0BZNzxpEn9xDfq2thJpLd9
   w==;
X-CSE-ConnectionGUID: bX+PnI87Ts+R3v+01Hn7fw==
X-CSE-MsgGUID: WWTCWENJRvyAEbskgOWn9w==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156880124"
Received: from mail-northcentralusazon11010029.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a6QTI1mTigB15kOcDHTbC0mbvxXEcQrbBamnzHLn+HfjUt6vgDIUyvMXglrQdSQ3FWYSTVuQktxGT575ROSWYwRx1Sd3Au9FjpbAD9RVScVf1/IwF1YdMYKRuLUNL8d9iQEykBmg2hr/Jz5nerxHGXZUe1uV/KDZQJ5PT78SMmEiRGKyc0Js6Vd4EG0NG+jaBjHELEI8k6zbX3o20GISBFCfrUbkGL7xOy4bVxVUCu922RQyOMwN1LnoNpAZDv8e4I2vA49jzlWoYxslp6naM2yrnD+ah1zoHVJ8VJ5TmjP3wRQ+xuqbHbMcUAGqltmD9ZqmACLsqEwCPT27EjTWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcZBH5TwG6eRiPieiMrGNyFdGI7BIFIF2eQ4uKavmgs=;
 b=n1XJOpVcsRXnVkGuh+mG4su/x/9p380coXjdSYTuOSjmQzjB6hjzenejEM6SKVeGGrR2KkEiA21Q90UnVI9j/MH0pRarMLFMhkINVR5LZmgld5aQFksm56cKXKfiujpVitW/tTQpRmVnZnLvdFLZHELR9jyvvU/pFcaQiwOwFkQTuqfSJK1sCjwJLuseHJzKenDn/Gm/E8etwIwj08pfws98g+g3kjlHNotY5FZHXsrHc2sYg6S1T9lJpjRU17Pgr8zmAgJAM0U8wa1aiGmBdoVMz6uoricSJvSyfk1jFq26+b7JeDmIrIkjUOdUPqtZkaHbfIg/oP/2GLREHhhWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcZBH5TwG6eRiPieiMrGNyFdGI7BIFIF2eQ4uKavmgs=;
 b=a3dnRgl3GNxcz6/U1CSgrLhk0Iw3DFfHsITu253eD5Qe0RfzHzxTvtcT9WR+PgxbyEiK2VMgcXwRe6iQdKMpgTCH5h/auvuLAweNDVM9MJ34dVx5D+UGEB1/T5D/xH64r7Ty7yJmUaUV0ByESlm2BEOaWukxjC5PP8NtdNQoWec=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:25 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 07/27] btrfs: zoned: use the regular allocator for conventional metadata block groups
Date: Tue, 17 Nov 2026 19:58:30 +0100
Message-ID: <20261117185850.4128157-8-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f78c31f-1d20-430f-2a26-08df44dce5f8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|6133799003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022075727099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	VtNdpMCajjX/sZaIi4UErxH3FENVplmg6a7KELy2s2dvTNy46r1NhoB+MIL9gfwaTPRsOedTC2nEsOp4LP8FtNA/o+gsoD++blsEGIwx60Uwor+lJvwxFIl9CG2FKhNP7ydYv5noMpmzFje67lKwa981itMSM41zenEhrCk9JuSjOoiL4jLjhUPnHljVQAVkQW9KLWQ3FMBjMfkrltHZ3JlEclm9EhJV9JDmtKlh1nuZa5CZuRy98AgTez1ZuGA0Y9RGzwl4RnF2QWCWqd7NFR2Z3pAOTzFZizFy7uWepsyMKV1OEeYh9pjiCDkg6k0QbCvFo7K428a3L1GYhdxtxj3A9Fkv2qvKINZqt03/eLKxBN7f5Tiv1nzwLe7VCjs43S3FKwM1ZBkSq9zB/nULe+GNtOF6WjBL98GFQX5pFLI/9R5czr6Z6AizXLP3prPs/HVkygqzDTfitDwb6Q4Z7My6/ZkyzEaWfvBxuJqea8xmUFafo2kWqUm9Bm4LS0XTzoL6mljW8a+wrEPN1yO4hNLAoJtbWAGN+t3ULgtMrTcwR//0PA5p0jGdRSKGpuz0yj1RoZA05ttprjuif2/+P5b9NmnI/nmgE2M6G4pgSMk23gjOs9Vpb3NsL4ItTu5u+M/p9J4eDTawuggrECdZJ1U8mBSxVZv1cYxmJ50aJEE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(6133799003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022075727099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ttdxl5wgZaDM1//aYM5v1WbmMMud3lKw1Sa2jwpalAFkbm4Z91BF8eIP/FiT?=
 =?us-ascii?Q?WjnfhhU+VIX7QzYgO0mbhFxafzSh0J5+bs3ZLRdYmfiUaQAED0unMCTrbrB/?=
 =?us-ascii?Q?xIB8zg/jopP87KWAnyuXb2ahjVOV3c+b60ZngNmTGOPwW8jTvDmOSEM3tkqU?=
 =?us-ascii?Q?UJ124tL2u/+Pm52JUCZ4RLtSk9GuWIUr2HcbJQV5/4NFuMQRBlDkotw965bO?=
 =?us-ascii?Q?nSwE8AyD0RGTKk/iRjgGMuE0G0o7ngdiGCjN4nuzpQXIJS0dOFPgdsKrrF/D?=
 =?us-ascii?Q?0gB91arkl2P3Rs26EBbnXHV0RcYMKnpjpjB+w+qiMAkwqFLnSSkQbvmKcrvD?=
 =?us-ascii?Q?LKyVXXuGlmoWXIMCFAW1LZIKM+i6nGawzom54PNppE6h+1itJtsXlZIY2eXd?=
 =?us-ascii?Q?sHAB+Ihe6kizgWGoaCkBA0/1w3cGlQkwZQhhKq3ych3CiSCjKHyhogTyMuEb?=
 =?us-ascii?Q?qfx2BGP2O4VCAk40pLcYPgX8soAx3D8iS2C71yKHVK4MiVipc0ZfGMZVomRW?=
 =?us-ascii?Q?bkutY1FVb91KPr8ScbvnwcVudsjjNMxPL7WHq+b8zeRBXumGxKEzEM4PCxRW?=
 =?us-ascii?Q?7WMGhASIOn5hEEWDWdYuV9iFzh+pzHMEUaOebO6j8LM6KjZXPBa4kAoXN8Rw?=
 =?us-ascii?Q?r5b1dJX868S3/qeGcaa71nPAlVBb2uPhaAIWDOFBzayxWPKs1e76hUa5VIpK?=
 =?us-ascii?Q?pIB4MAHkUjOSs5u4ltb1G/w0TnbBHRshABgPb8cs4z29NmdIWtHTuJjtROaG?=
 =?us-ascii?Q?LvWf3iDDKyNYgngkPQP5pDgG33BNDnNmwK/6KP+LeTaJt1hKQvemlj+XWye2?=
 =?us-ascii?Q?umrxdSv2Szm6QzF1VI6js5MAeNHa2PVV5Y86ONbfQfdld9752N6SH9q3pB1r?=
 =?us-ascii?Q?fDXUyzxaCKsCYvIO5wj9mIODuuW3FDUEPo7VdRNVDJ4W33I/KCm+SsS/+3Tl?=
 =?us-ascii?Q?zKdCyQNLtQmQncEa2unNi9cMF0jjIFJ+r6nA1Z6+F6jCH70bgKuwTLUmlDBR?=
 =?us-ascii?Q?QHgEHQL5PkYUTdfSRgQQo3/En5V9uvlJfYCtnSTzXch62aQEnHtrtRIA0THb?=
 =?us-ascii?Q?h4S+bi3E0qZrtyZ624+3PjEgFevPPtVLmoWGkJia8TkQK7UyTpXhReZoiBEw?=
 =?us-ascii?Q?cVuNMQgcFaZL6n3Mr0TBbnQ8+WrITs6y77fsKbJkKMcvgmpveftUM1eCl6UF?=
 =?us-ascii?Q?Ri/wkaQZQFhGmY2sBpH6obx+unXcdKHhWqNN5KPAj/v7eNp3otqE6giI1/3J?=
 =?us-ascii?Q?iEsMmQe5l+lnL3LI+F6FNrXmfmYjPtbT2xVb1tBxWas+eeDGvZ+PtpVlO2eU?=
 =?us-ascii?Q?MENObrFIYyBgP9QjRiIHF0WOtWD+CgkvqM1jbHq0UqrcCm3s3ugrFGJQg91w?=
 =?us-ascii?Q?8oBTdfy4RxAn2mTrJZ7f9AZxDghFlN6yrYwyQOAEFbZjNcgSDjW8TpUPBgHN?=
 =?us-ascii?Q?1HdUwpPnp7nMJQBn97X8YacZsn2H6/0ULDFJ3CpVYFxu5VfnN8GPoEH5jIjr?=
 =?us-ascii?Q?AKkgabsZ8X9zPBH2jnHhpCqA7G/yRxxAEz5HlbRd4t/kPiOamSw9Xgv2SJPv?=
 =?us-ascii?Q?WDVBlgC3WqvALx5oMtmY/+658tbl0tHf1nqzBNNo6eO51NPVjcJ0aAif1lDI?=
 =?us-ascii?Q?OnzHIGlLgz0zbRcoX+yjPMbHGfoZumFgdur+jXge6Zj+Egmj1itkHxxpCwFr?=
 =?us-ascii?Q?KWcCvvPMeEyk0mHU0Hp41BpQbvndNkdHR76dj/02yR8eNV08/trh3DqylzvW?=
 =?us-ascii?Q?jg9G4JnVIcsXs460y+1Ga5l8B00luYFh39wPz5/UpoYeCO+zpUtVhhj1g5qW?=
X-MS-Exchange-AntiSpam-MessageData-1: I68PHIsx8eeptq498RSFxvEusbxqvJpHwsM=
X-Exchange-RoutingPolicyChecked:
	mYTfKl4U6GG6BvW+GLJy24T8jVHnu7u/G+pxVYmDFzVhFcv9oDiLpvwPEBFR2UNF6n+KiElEFC+JvW6NibqpLp2Uq4QR49Gv1r0Ocukx4vMTHzxt/ZE9LLOfWsLvV1xS18eMkMWpJUsZFi4kUTOv+aImEfqtMri+Ub3IAbBGfENPF0HU//S+XuvRVDmyEwW4+/Is7uT5ry1B6v8xP4rmKzFWAsRgHSO9ydhOK6Utix6gaavcsj0fKCMVzR5ZXYXP2OTJggIwpCg96NJsUGFBZKiE/cOVLqe0b0IAKHVIUAN/1PsTl8tdmFyC2L/jbaG6/UbJibQhav2NZ13am3BswQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q5Eq/WK+0rw/wNd0D93m1e3lgz6FY97JNoTnCB7qWPBPDuqG+gHEDMd47FG36MBAbVV0H0wSnbVX1+ErsUIPTUt8pF9lgLohgitYTT69bri8jEwkwgaAZsM5yxkzVags0gTNdpI/zuwgpcg7jXpBYOVKl4zgafxdn2nxZQlCE3XK67nqFI6twDHbLDoFiMJb28Fb9AC342oao/0XI1eWdR6MDaLoCVjITm/t0vii5Ku8QjI3mx8K7XTSm6Zpjnp596dnPP+kUXmWkzS8UGUUi/OgudCyYyWlzdFxtwdM895BGOOyVY+ovOXweKUw9kMBwQehm3aJq6tJp56P/0rEdGkOzvuXM3Yg+Ja3EIWy4vtZrj5De+d8c+FUyfMRC6ymVaARYIkbjDU2hiWDng4azuvwgJEtpIryKvnQ0vPqg7cJTSIDO891VVVj6xIsuJHDUufV167UGX+JNleicxj6BIGsjanXBCDhMSTeRkc575G9UMsX+NscTpWLx+FLQugqLfQ2N172IbcQFRb37r+coZpIPiUrGl4Ez6uAyljOAEhtzcnu7tqsZM2HAz7ZXEV2dXXUEZfC/WSWepWQaXFwxD7K3qYKPDWQEsj7m2PWHh0v6c9Dap7gJo/0FEz9Wh2e
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f78c31f-1d20-430f-2a26-08df44dce5f8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:25.2853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 28GVtxPwZd7plmCxD47En074P/7Y1zJvaUVJL8+2P8JsaV44YIAcRAb47mJnsf/P8VpFVR1P4kFRb7thb8qxqpqnZk0VvUxxLjn3zIHvzQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

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
index 7853d227a204..625f3533ec09 100644
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
@@ -2556,8 +2556,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	}
 
 	/*
-	 * For zoned filesystem, space after the allocation offset is the only
-	 * free space for a block group. So, we don't need any caching work.
+	 * For an append only block group, space after the allocation offset is
+	 * the only free space. So, we don't need any caching work.
 	 * btrfs_calc_zone_unusable() will set the amount of free space and
 	 * zone_unusable space.
 	 *
@@ -2567,7 +2567,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	 * in and be done with it.  This saves us _a_lot_ of time, particularly
 	 * in the full case.
 	 */
-	if (btrfs_is_zoned(info)) {
+	if (btrfs_zoned_bg_is_append_only(cache)) {
 		btrfs_calc_zone_unusable(cache);
 		/* Should not have any excluded extents. Just in case, though. */
 		btrfs_free_excluded_extents(cache);
@@ -3249,7 +3249,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable =
 				(cache->alloc_offset - cache->used - cache->pinned -
@@ -3731,7 +3731,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
-	else if (btrfs_is_zoned(cache->fs_info))
+	else if (btrfs_zoned_bg_is_append_only(cache))
 		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
 
 	space_info->bytes_reserved -= num_bytes;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0008cbc12412..b01b3ccc944a 100644
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
index c90ba5f6a8bb..095784f0f6fe 100644
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
index bc83f4a2577b..9a617842574f 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1969,6 +1969,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
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
2.56.1

