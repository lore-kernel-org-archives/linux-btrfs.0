Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF093A6B65
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 06:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503105; cv=fail; b=XmnfLliw7xEBLNQJhPqzSQ5K4T/ZgXgGqR9dkaGh1eAfkwnKX9jgILaAIfqK2s4RG88D2tUrEU35L6jboXgWHmjNPb9NTBWMV6jzeCQr7BuClHM9vXSFaYJeOCmWSNAdy9xIidlDhGgMFay+peJ0J2+tHdDaxnYjMgoylPAc+lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503105; c=relaxed/simple;
	bh=AHebCT7RvSQPhJUjp0BcWU8GBA553hz8BYormbiJnIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=noLzxVVW6+vB0FTcA1z8aoqL4GJi1zQnXLqrRKDh3DLC/WD6ZzuLMznq4HWjTiGBT+jMvlpqOOW5gGlGHjOKjRt1XQVFkM+IM3dhHpAUFbWg6kxvBfKApb/nxYa7jpbgMFh3GJUGIZ8AIuTpbOC5LfH/7em6DuBRdu5vcVOmgxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KwebAkIt; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vd6V6VwZ; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KwebAkIt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vd6V6VwZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788503104; x=1820039104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=AHebCT7RvSQPhJUjp0BcWU8GBA553hz8BYormbiJnIM=;
  b=KwebAkItMEiyZh0bLthNpnlzFQfD/W/SL+1xWw7+VABx2l/UNcgMpYB4
   ey5/1IJDk6K514DPTmdBs+5wsn5Dxrfklep45+sYSZ21HjN5lUd63X8UB
   VX8iI4o9b5ELBGF0a9pDmdyB2d0uQvi9Egzc8MT89yuKcqHidxLz9ZBEF
   yPGJlgohL7QPB/Ro5zAOpRqBbKDpcZpmjPbRTuIsifAl9R+ncMzBk9fU2
   M4fwUi98y+6sTOownuOH9POAsA/xDDAfe1mRn4r9qmOFL1IffwjJERAkp
   +Gmo43vMWBsv4ZnKQ8NnbG29YpTI6GAek6WgcXiF+evgvxN+6rgATF7CK
   g==;
X-CSE-ConnectionGUID: 5QuLDOBBSxCuA9FGawZuag==
X-CSE-MsgGUID: jRgQVIZ8RTORneOg9sFC2Q==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="154938768"
Received: from mail-centralusazon11011058.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Sep 2026 14:25:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WO/o1+nGL7K7qVSBaE+2b/h0eGNAq0h+LUI+7pNIvQmmdy59oNJ+979wgcsrLpnSkLvlAsLlndAvl0BH61hEepyK//bG7o9yONfMm8oP6Po5fbIW2FO9oCOYeEEdzxG0doGCKio2RUfWP9YbjewP+1j/S14hPZGMdE/bnN3nj2WJW9lwrQ9BOJOeXCuQWK9e8iD3bmh77gys4SodHTGAhGEPW8mQdx0nL5Y8ikMzShh9QSJE0cP1jkI1QiUtmKFPkV5PGJAUtbLg7o7moOKxyivovjYjB4mIhtrQXhJtLc+y5+Z1/x6gQ+FcJ2NR5vfBBvcAxjDBcAHgpQGCgyNFHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJppUM5e+5IJxDoBiLISVUfxKpsFbBJQDG9A5J6TVVE=;
 b=n2D6V6rPa4MSJ4mIjmUZRTXbVYucM0aa+QvjxmAx+t4JMzRCcje4vuFY+O3iYJvc6WU7vbh9GHV1l4h+j+CJU3effeQmLCmEblZuyQc2uBcT89Ral3f0G6SpwwR8cGo0jys2oiiC8pN5kqV4p7DRjFPaD96c9QZ3opGj64Xf3+oEHdYxA2APGKVGtSAHsTEceFSy0X9gkyeiAoYkfJbw7urYBxSxugEqryJflI+7LZ94xfEi04JLK+2iSX3eeSgVWmtDdynEZ1oYQeHrueqiXlg3++U4UHWowIjOlymzudeW5/OQW+CQYk0f220xnmZmU8r99T7alH0a8tlpslWvjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJppUM5e+5IJxDoBiLISVUfxKpsFbBJQDG9A5J6TVVE=;
 b=vd6V6VwZgIQtKjsJ3MK703dNyFaoL8+DHobllDD7IHbfFV0WNuv/zYrnvNHZArwJjXHU8srxdrh+IfswHPVsrtlr3NaOIljyD0q+X7dN4+JWt8MUhiC0DH7gIDhSyyjcWCJVpCEguUIC4QLJGuwGf23DA5n14piJlRyRfubTOrg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB993561.namprd04.prod.outlook.com (2603:10b6:510:40a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 06:25:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 06:25:01 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/2] btrfs-progs: check: detect leaked active zones on zoned devices
Date: Fri,  4 Sep 2026 08:24:44 +0200
Message-ID: <20260904062444.3467618-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
References: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::19) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB993561:EE_
X-MS-Office365-Filtering-Correlation-Id: efcba876-b86e-4409-4226-08df0a4d4055
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|19092799006|23010399003|376014|56012099006|22082099003|18002099003|6133799003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
 UoEPohFP1RsOLTfcvAY+dT2VAZ0SsZE2WMPo5PEMKQNZN7lsxsBufMfIkWqEK4UppDa5B2dLnpkhJYd81mNkyCPVuu1rj1/Ljmb73YF2pjVbl79U8Yfagl3ZJBIwgwBwyT7oKSSc6SaZB1gR1LIaZIx1pvrv7ZWtESHpczQglQdYbka1Po27Kj/th7XaPm2tFxiPVzdum4DjmmdOUILJPhkP+meuYCDVgcyEaeuqzU6aRHqVgDeopGBnjvPquqDNas1tdCrxs5rkRvdyjd/t7y10IIDFam7j9b8lx0SUbfWeDdcCVuOFXuQVKKcAQxoM6ACk+KlG9qSQtYAaJDAcGLhALXU9Gihey1ht+zEzh61k19p6VeSfGW6aSumQEI+VX2UQpxZ24eNw3JbFRS6gkC+HbeB/zhNNWE1GLaqQWycg0gyxkL3Uoz0CSYkS6sxNiZBllHv+45BPJPFZPKXUuaZv9Mnn5aRtfP1MJDhwMyGLIsia737amm8nrVzGdXS18wJMc+iTGBluD7ve9XJDvgFVVE3zon/lCV07faEIp01Kf22GOGRZY43o4TbEi1bvWwvfCb0GecDAXHJ4CkyM1y15u7JpPXckmaXguTHANelKwqEVNwLhfIxhyTJ7EUqWCVB8Zhhbtc2VForbVDL5NE6G0ojjiKqP4qt/dMoMDBo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(19092799006)(23010399003)(376014)(56012099006)(22082099003)(18002099003)(6133799003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ShTyw/T82PIyDc8GM/X3ShroJTLG4wrgYs8X0kZ5keh4BegQ/7Hx6bbWkWez?=
 =?us-ascii?Q?R/QuxUjn0Mkm7TQ9tdtCR1AtrEYXDqGsGd3Jj92tEWxnD6yZFIVz8beaOS1y?=
 =?us-ascii?Q?sRzCt3pNoaJVRKKGUD5+UvNpN7xEg7S8sXwp7SMJGiBV12lgOgUEOO2ZijoE?=
 =?us-ascii?Q?iOyKCOhkg0GUL+8CALS8X0ORf3RmVhxNEn1F8AJfzqerDL1bb3uV3C252NP1?=
 =?us-ascii?Q?SqMU9OQ82dbxsM2anZcsUhQev+zQzYAjC/FFK/uKEbl6d+RRxCNrKMksHk+P?=
 =?us-ascii?Q?VdRBO5L8GnfZ6YKOPetcyT8Wbui4NJSbZ9CqQQ7TNqwh+EdHm5TnQYY15d+y?=
 =?us-ascii?Q?wCuS4LLU8SXa5ytcTBrVI6SYrBj1VlTExRFJT9AeWyYKWlkF/TzmlOsUc/ig?=
 =?us-ascii?Q?RklAxD+brq79jLmZOiXuJtUQDqvv+BKLnZ0yM9wE+KJmn2lNUXQLMhCnzvj8?=
 =?us-ascii?Q?aENgeD+xRbUU/O4SQSQH1JJknRQyL7SgWP/LvQrI8M5AIYnDUSB3wCaawTp3?=
 =?us-ascii?Q?j5oX8RCJTIzF1OEjenn9vYdrMbq+LnvB29MAe04srY0A6AEK/7G39XD5KYgK?=
 =?us-ascii?Q?IaA72Hdhyao4XLbNoq5xrIhwop1QnCDZuSOV01358EikMmkgDc/skySjxMie?=
 =?us-ascii?Q?U1O1pI7h3zFWN1JTjh1VypcjnY4OdEIQFaGBmBJ0/h0PrIzm6AEppyYnDT7g?=
 =?us-ascii?Q?rhO6NC9F7//pauE8XuSYsP0UUbLLiVEbQTOIyh6yqgrxMkT0XfLDmdqJUwGb?=
 =?us-ascii?Q?FueSqoa17idUYtfEqGCl5wctDsPQPZUQ3eL930lNxG7Z/3CayXGqAMbzA7lu?=
 =?us-ascii?Q?ZWydLilU7JNuvydbRTK7qo5MmBJ2xgJ94jk9bOKakS60rq5VqsQ9L4oHGOAA?=
 =?us-ascii?Q?Xf4M2e/ykBEmXzCpGmrmZc9Buk5dAUiQmXB250AUV2xHDdf/b7vsNvXp0Q/N?=
 =?us-ascii?Q?ekyasOK+f5u3w3+uWEyD84Y3k+3P7/FvA/Q1GVGhgGcJIBr2eU7MWDhI1LmK?=
 =?us-ascii?Q?NVoKYKWjHCa8XMueSgPiJgof3Jm8cI+YmCCJIdX77IGZAFM6jSWlQ2cQMdiG?=
 =?us-ascii?Q?Wp26bcbBIjrhmi/wOU3X5i//RQzphVO/SWPPVErEdpJ2Tq03SiPJtyd4oCi/?=
 =?us-ascii?Q?fB84O1rV9A0v1lMQQnuGHaLqmSrsGzgnJL17xSEJCaPTngl7d64HD9vnCd2A?=
 =?us-ascii?Q?U8KOt+7uRArmk4xGbRrXK7bLtR89YL7I1od8wIJ4LSei/ELvszm5/zAqDDNO?=
 =?us-ascii?Q?De2p1+9ix9TWGEPAi/+Z9vpZOakpCECLM+xP9lDQnmjFaZmKldRmkriAO6/F?=
 =?us-ascii?Q?DUI89nu2u6e0jDaPHLluFgvq04f9oVngj5J4UdtvavRNbm7MwxPtZfKrTkJW?=
 =?us-ascii?Q?doP0M7qNXUcqgR36spVyobxjUz2/9SHYyQ+Q5v0EHgaOcnEKszgIb2RZZYNe?=
 =?us-ascii?Q?y2QqmL5ZARvXRX37YwMMbQSmkjE5qH7lK6TPbaX+fyzp4H8U4Pmi7sTkrSwI?=
 =?us-ascii?Q?z/aqoa68w91FCiTestxClGJygjNCOxxE4wuO4m8YOQ7nmeYThe0BcmY08+LA?=
 =?us-ascii?Q?+pfi0uJhfE36nYA7b+7hvH3P2R+eAFdFefjZ2HT8CPVrjTWj728qAH1cNvCd?=
 =?us-ascii?Q?oVYilravJa6jiCej2x6F/XkiYRWdThY3s0xvKZ/tdY8Q7BpSey0PTbIkKncP?=
 =?us-ascii?Q?TGdHvhTeAQuUwl3p03y80OSPYbXD8k183kG7wK8knuxTIcGQB1W0vx7S52RL?=
 =?us-ascii?Q?vplv1lzHFx0kX8ieYmErk4PbVy43TQEgAbfvNzgxt8n2JtPNse2jIwhDUums?=
X-MS-Exchange-AntiSpam-MessageData-1: Txo0zIuBhqARoll9ypDwt3gWftXAM26dLeQ=
X-Exchange-RoutingPolicyChecked:
	xiDZuubMqZk67bYqCUcq1X1hVX6YBl4suWiMOwieT88SQ5yvBQa/HGGGXbjMxWF2B0SlSmRB7rE8jmX6kRoqeTw2j93SeAydQjtiHweICON2p/7qGDljW9e0nW1C/jOQyUW/Gm4fJgiyl1A83lnHGrWjW9AyFrtyd+MlHKuPKA0hpxikedcUpdDY6iqZkw4yR2NleM4fJ6w79FqxzyrXaB74Ermj2odBSOca4QZNA69v7I5yr4hRzZTy7Q6taudLSzKCHrKV7OB6yBe60dzR6SWUI67Upi3EO+Hiaef3/XsvvKxbBNjSpErhjhLTe1OR7MqMXUMIIC44DwB2MTiqZg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ss9Zjd1HHViOP6B5UarJyzkmTC1uhsxRDrQW+h6WhmRJmmUygEzv/oDf7kzd4jl1r+0bITzh+aI1x3m6nwPTFC+siI/eoRxZ1FciMRY3cwNgBjV3m1e3D5w4/BydAT6PPG7IdN+fcurnsv+Zhc/zMCzZtgXYytK+ER6/Lpl+V9N9zsm5sA35vNLgUElJJVkBa9eor1yjOTL8iWXjexNq63l+vGQD0g/9LwycUX6bQ0/EUfZVlVORwHZV0i3KqMtcTfXhsMClv0f0Dy/DJ3iZIUb862mwXdVxaaFT9lfupCPqGH4YtJ1+MMvgzB/rWdKGpb3tiiusNO/8UK3UK7JWDDhebhrA+Rd+RxlZPiqqY1q3YZVcmoo0XRdBq/aiBd+3tvpbxTXBf9iWhEvzAsB7Y85A+l4995X7Hy7LnVq+igsphAHxZALF0jZRjXuu6bjKOJIaqHB+GaDRslWCSHEj7YkIQYwB1GFeyv3k3chokv6k4SohOdpiv7ORyabXvNtmpLIDs3bRLLvw4CdgCBdwe8leTmDrAdB5GPJsBGIQJVHwtx3ehPp0stiSZGxPUaWNPZEUdOKmjXIYzMjP5BgfNjPg5yaMqdVG0aVDFH7YKgOHghOP4ynAOaD46IOMzeWx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efcba876-b86e-4409-4226-08df0a4d4055
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 06:25:01.8768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XiTh9CLhldjtYKkfc8JSDV/IyfQf+UNicTfIeLxNwDXp5PpyO070HAD2UdlNKwqhQFHyjQOvjXMSd8kivyrtgBS853gs3dZrx1GVtZOhLX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB993561

On a zoned filesystem a sequential zone can end up open (and written) on
the device while it is not referenced by any dev extent and is not in a
sb-log zone. Such a zone is unreferenced - its space is free according to
the device tree - yet it stays active on the device, permanently consuming
one of the device's limited active zones. On a device with few active
zones this can lead to premature ENOSPC and/or allocation hangs.

One way to end up in this state is a mkfs that failed to reset a
temporary chunk's zone before finishing (fixed in a preceding commit).
Existing filesystems created by such a mkfs need a way to detect and
repair the condition.

Add a zoned device specific check that cross-checks the on-disk metadata
against the physical zone state of the device. It flags any written,
sequential zone that is not backed by a dev extent, and in
--repair mode resets it. The check is a no-op on non-zoned filesystems and
runs as part of the extent/device checking rather than as a separate
numbered check phase.

Introduce check_zoned() as a entry point for future zoned device checks.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 check/main.c | 156 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 155 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index b9649829..3ea90096 100644
--- a/check/main.c
+++ b/check/main.c
@@ -47,6 +47,7 @@
 #include "kernel-shared/ulist.h"
 #include "kernel-shared/file-item.h"
 #include "kernel-shared/tree-checker.h"
+#include "kernel-shared/zoned.h"
 #include "common/defs.h"
 #include "common/extent-cache.h"
 #include "common/internal.h"
@@ -9129,6 +9130,152 @@ out:
 	return ret;
 }
 
+/*
+ * On a zoned filesystem, find sequential zones that are open/written on the
+ * device but are not backed by any dev extent and are not superblock log
+ * zones. Such a zone is unreferenced yet it stays 'active' on the device,
+ * permanently consuming one of the device's limited active zones. This can
+ * cause premature ENOSPC or, on filesystems with a small number of active
+ * zones, allocation hangs.
+ */
+static int check_zoned_active_zones(void)
+{
+	struct btrfs_root *dev_root = gfs_info->dev_root;
+	struct btrfs_device *dev;
+	int ret = 0;
+
+	list_for_each_entry(dev, &gfs_info->fs_devices->devices, dev_list) {
+		struct btrfs_zoned_device_info *zinfo = dev->zone_info;
+		struct btrfs_path path = { 0 };
+		struct btrfs_key key;
+		unsigned long *covered;
+		int shift;
+		int i;
+
+		if (!zinfo || zinfo->model == ZONED_NONE)
+			continue;
+
+		shift = ilog2(zinfo->zone_size);
+		covered = calloc(BITS_TO_LONGS(zinfo->nr_zones),
+				 sizeof(unsigned long));
+		if (!covered)
+			return -ENOMEM;
+
+		/* Superblock log zones are written but not backed by a chunk. */
+		for (int mirror = 0; mirror < BTRFS_SUPER_MIRROR_MAX; mirror++) {
+			u32 sb_zno = sb_zone_number(shift, mirror);
+
+			if (sb_zno + BTRFS_NR_SB_LOG_ZONES > zinfo->nr_zones)
+				continue;
+			for (i = 0; i < BTRFS_NR_SB_LOG_ZONES; i++)
+				set_bit(sb_zno + i, covered);
+		}
+
+		key.objectid = dev->devid;
+		key.type = BTRFS_DEV_EXTENT_KEY;
+		key.offset = 0;
+		ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+		if (ret < 0) {
+			btrfs_release_path(&path);
+			free(covered);
+			return ret;
+		}
+
+		while (1) {
+			struct btrfs_dev_extent *devext;
+			u64 pstart, plen, zno;
+
+			if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+				ret = btrfs_next_leaf(dev_root, &path);
+				if (ret < 0) {
+					btrfs_release_path(&path);
+					free(covered);
+					return ret;
+				}
+				if (ret > 0)
+					break;
+			}
+
+			btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+			if (key.objectid != dev->devid ||
+			    key.type != BTRFS_DEV_EXTENT_KEY)
+				break;
+
+			devext = btrfs_item_ptr(path.nodes[0], path.slots[0],
+					    struct btrfs_dev_extent);
+			pstart = key.offset;
+			plen = btrfs_dev_extent_length(path.nodes[0], devext);
+			for (zno = pstart >> shift;
+			     zno <= (pstart + plen - 1) >> shift; zno++) {
+				if (zno < zinfo->nr_zones)
+					set_bit(zno, covered);
+			}
+			path.slots[0]++;
+		}
+		btrfs_release_path(&path);
+
+		ret = 0;
+
+		for (i = 0; i < zinfo->nr_zones; i++) {
+			struct blk_zone *zone = &zinfo->zones[i];
+
+			if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+				continue;
+			if (zone->cond == BLK_ZONE_COND_EMPTY)
+				continue;
+			if (test_bit(i, covered))
+				continue;
+
+			ret = 1;
+			error(
+"zoned: devid %llu zone %u is open/written but not referenced by any block group",
+			      dev->devid, i);
+			if (opt_check_repair) {
+				ret = btrfs_reset_dev_zone(dev->fd, zone);
+				if (ret) {
+					error(
+"zoned: failed to reset leaked zone %u on devid %llu: %m",
+					      i, dev->devid);
+					free(covered);
+					return ret;
+				}
+				printf("Reset leaked active zone %u on devid %llu\n",
+				       i, dev->devid);
+			}
+		}
+		free(covered);
+	}
+
+	return ret;
+}
+
+/*
+ * Zoned device consistency checks.
+ *
+ * These cross-check the on-disk metadata against the physical zone state of
+ * the underlying zoned device(s), as opposed to the tree-internal consistency
+ * checks done elsewhere. They are a no-op on non-zoned filesystems and are run
+ * as part of the device checking, not as a separate numbered check phase.
+ *
+ * Return 0 if clean, 1 if a problem was found (and not repaired), or a
+ * negative errno on a fatal error.
+ */
+static int check_zoned(void)
+{
+	int err = 0;
+	int ret;
+
+	if (!btrfs_is_zoned(gfs_info))
+		return 0;
+
+	ret = check_zoned_active_zones();
+	if (ret < 0)
+		return ret;
+	err |= ret;
+
+	return err;
+}
+
 /*
  * Check if all dev extents are valid (not overlapping nor beyond device
  * boundary).
@@ -9414,7 +9561,14 @@ static int do_check_chunks_and_extents(void)
 		return ret;
 
 	ret = check_and_repair_super_num_devs(gfs_info);
-	return ret;
+	if (ret)
+		return ret;
+
+	/*
+	 * Zoned device consistency checks. Not a separate numbered phase, run
+	 * as part of the extent/device checking. No-op on non-zoned.
+	 */
+	return check_zoned();
 }
 
 static struct extent_buffer *btrfs_fsck_clear_root(
-- 
2.55.0

