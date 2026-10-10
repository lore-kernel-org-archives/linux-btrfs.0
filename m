Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81151497B6C
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634050; cv=fail; b=dLHlVckYgGpTxI2NvjkXT1qg84LIYdBVfHRpCkaRGlZGFpSNyHqSdw7gS9AqjJbNM0F9frvMvksXFi/odobIqRVsR07jO1qmaNebvzW46UbxYV7NGYL6qzziAAH8h/iiQC4DtwlY+mx3E0UMNag9l54hJNo/XiDqfuLMyZb8Uak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634050; c=relaxed/simple;
	bh=vUixHDeqy/E7jzwG3itUX8ri26y02iRLBO1hpa766Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rhCunXp6KYlFshvjtWIqcvjaq/OKqG8eGJICCVydTR1VAmYns0FWLV78OcucnIbo1a0blQVOee3gKjvdA6EoZygYXEEtTIyt4vfdA+8pkCcfoTvaNAnvEdNEkFUUWacd0RjIZaS+99as7Uj+Le/OWDzQ3w18PTdD8TJnAEUT/3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cUihlyyY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=KCPaYvYp; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cUihlyyY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KCPaYvYp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634049; x=1823170049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vUixHDeqy/E7jzwG3itUX8ri26y02iRLBO1hpa766Z4=;
  b=cUihlyyYadhnxXfMhp2P9RJigvdIrjOynym5d9Ci/RzcKgj22L/LoqHE
   a1Nzx1/2tpX3NLJvLIc3kR2x+F7JKiw5nCudySU3HzJFsI+oHH+vGOW/0
   eNdO3rmCGMtxnCQ0Qd8YK8wGCpLBtEe7vG/gwvAf3BTnqVFM+qDnA2Tbt
   G11tmieP9HPH8dqrcdjw/J8LV6QQIXTxjTLUdxfDa77KtzOCfW0EEuwOh
   Xj/vUAYbq6x+XJ+FbZkj+dZTeYTwgOZVOpq1OeBm6hDGob9Y9xH396gCF
   Z/VHMBmjFdK/ZB4tsDn51RwthHrPRe0LNMUv4DG+Zp2z1DwPXMdxmY4b0
   g==;
X-CSE-ConnectionGUID: Xfudo6ZZTZmoDzr1L0ME7A==
X-CSE-MsgGUID: 1/6tToIHTqGv8sDgHuTn/g==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="153560354"
Received: from mail-northcentralusazon11012051.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDqwXKUkO+p5RI5NCFnFriT7jYLv3jXm0JY1HXO0Nj89NAruFf+9+/cLpevawuJyhn+Uahkx0Tnog9hbTH0kq3dg+W9oS2mZcEQLV/DAGInmdqSSuPSEQyyKZKrM1kPt5s26hHuooEuFMfKYpq53xKBD2gvSNLv8+IANZyTDx/cF9HIx4J6GrFSuevL/0V0dJcM4KZene5RFLShy0nXjvDQk3aTdnrmDM+ie/2ModN14RiV+196O4iCWHLFaLNrs439N6lEthfqlH/gam9c0qol2ctGrY5/si+aPiu3GgkfuO9DpGs7Us5vs163drs7KJ4I/x0HisNf3eTXLThXegw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4T5YT8g0o8Aa0BEznAsRON2zHgU5wYY33z+tFXxdSM=;
 b=QNSL7hJhTdz2AFSfm3bXb6ZzTwn1rlYjwKe1HE62orlrI4j+F0jmJfBBBzWcKe6lDNSy6gmCT4AhHFevyrRjUbqJBp+HP/GMJ7RdbeAIhps+urL8Z84Vkdev6y+MOHozxqJr2eTGvFwjM0EaPVK/SnqxCBK/DWgYBQuQmOc9j2a3pSOFzbudRuKNEY/ejQ0y8VkdvWLCKRkM4PG+1x6370ThNYZaW4uSBLWr7L5s5O/zA0MLjbxgzAgPttZGsX0y8JDGz6E8fy0jm6IpiCka17nOE+bt4e0UB+D0HMVARtBFNMQofL+/eDD/cScyI01bSNRrwyjUipzC23YUziEMeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4T5YT8g0o8Aa0BEznAsRON2zHgU5wYY33z+tFXxdSM=;
 b=KCPaYvYpx9LZnx7+HnKSbmOwf7bT7NRrohJS5ZrOtXIbv73nVyDlCI+jWiN536oj5sa8Etw4C5KQT5DqKGjmC+x9dGUYstlP0AjSkTwynzQFnnBBT/IJiIuEHw3gTbzQiD8wjvFEy6ebiKiM9hpqWNB2fbc10Q1BYxdzlvk5dIo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:22 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 12/12] btrfs: zoned: prefer sequential zones for data chunks
Date: Sat, 10 Oct 2026 14:06:22 +0200
Message-ID: <20261010120622.3781326-13-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
References: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 40b28cd3-940e-42c8-8025-08df26c70a48
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|5023799004|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	T5+4bOlDXIe3NbKJ+w6m8HzgVWEfW75Dr6S0ZuNU/Rp/G1fv08mdpp4FNn3+EPPw3uoDHdpC20kvl2Pt58SmfUuLr3npLUIJSypK67t/PZWN5oUI6AWG3upx+lEYPEOQcCMMj69QdW6sy3BjwjajViuVfIePuJtSut08BTwLN3LpakCH8lVWbAX0d+qKXN7ntPeJYOyyRgy0o6mNRTPLey5QialjSytkPIoGOGguRISgQFDVz3piJIi7muvJz/9dTn2/6fXo1mH1r0WsyGSzwo1yMUnjXVDirrvog+GnGVufKwXNuioC5DjpfJvuc83Lf35kiOVUC33u3I1HswHLK6Pp2cy5yr32nViw4bNG3Yjs0V3iSEgA9WWGXgaxVWXlIf2BqtGg+xil8pRbkevDtbs9VnoaHY5u3wVfddtplYK82Cv33fIY0VUlG4md4a16QY7BmbOnszB7GrvE1pyJMWrAGHm02p8wy0z47HDlSjd7bYyj7u9+M98Gf4+OJV9mJ4+h0w4eSv3n3n15eF3Gd4uU+rpZaK2cCTdRSYkbHpk/MFwL7e9x/GVJ1dIOchNxCLVGqBZoVJS0LISYlPPAMl+98yADD1TBzLDSEyF3tQwA+Omw+LnLGe2fweZv7irVLUEXdmryZ/UVvo9fhQtdxJxZAcNrbupRkGpeFEhF+6c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(5023799004)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SlJ0+Rb5THQjOliq6MSP4L+CUAnvVDXJTIlCcCW4LHlK5aHjCIFYL+fwOY8b?=
 =?us-ascii?Q?nz5mkHikckE9sgFw8EMnONCuePBU+RKpz3c7sWKsSDY6d9DN/36Y663y6NO9?=
 =?us-ascii?Q?geJBprhT/31qHO6wIYa6Km3gOL5BTIMrp5ysrKrSdGPieFFcgiVe/b3NqtUg?=
 =?us-ascii?Q?YhS4Cvq9+yR6g+tzcxc8OGG3CLHcpiXIQObcUzjmRkkEnaEb9TPvfnTp6Smt?=
 =?us-ascii?Q?qy7g6o0TKAVfYwjM2WZSu9gK0lO+R+btNeu3CGYmwgAj/tOdhS1HVgILDS4Y?=
 =?us-ascii?Q?hrmU0N+iYOogpjlOF5SpW8Kz5a0z4L9MmtMBwj2w6XKxoy908AiYnWqkQwHR?=
 =?us-ascii?Q?Tj/aGG1+YBL1rAahLni9ZCIImSHhMcLonTYRfETHPmgkTaLwEL805kZfiezv?=
 =?us-ascii?Q?8ygB5GQSNb46R8VuUQ/ifksUY1yRt9eA1c52ekjs6scDcwlInrg99qI7PxRZ?=
 =?us-ascii?Q?j/YyR+XYggxusbcuGDmw60sGbQetd8IvXSnE5zOIJ31Gl252cljVCBlaM8qW?=
 =?us-ascii?Q?+XL4b2T3D8nyuOfycAQgwCHn4kGa8i0a61w7FPk8m7dRn+swl+cUtnQUhJbG?=
 =?us-ascii?Q?VIX2C1vc0GCG1ORF96jf5OpTYfFSs0COe9yjxLgvjRIBmYV/M6UeuB7cjo6O?=
 =?us-ascii?Q?0q9LQeuPHfuRvH+CfwoSxsZBALdu177IWJ8URoz1ZyG3OuMpbbqQod2N7MW2?=
 =?us-ascii?Q?1sJR5YxcmlXwFJWqb7YmlgQ8+9MSg4b+SzVqvMRh6JWrfj1d6uSQUg84eW+v?=
 =?us-ascii?Q?2kNy0S/dlcmWDk/rtnV0H0b3RCubOwU0NQpL4/oSOFnQ8gMZL2ymOIRPnkd1?=
 =?us-ascii?Q?UfZmVrGQTgriUmr1YLQ0NPDXYIbqzL8Ewn6vxq0A0oU/2ceGLEp8fLY1+HT5?=
 =?us-ascii?Q?hlPg6x8lyxv/lUNPj14oxfTCQU/gcTkchJn9bnXMEJrQfqU+yd77+zssSzew?=
 =?us-ascii?Q?/cn2qKrgE8StM7/QtQLm+nqLz2a0I+AxMzsxeSevUBBjk35RH5vPkHPOiaFO?=
 =?us-ascii?Q?VWG+kwPjkMmXaTRfgGMWlwBkez8vgBo8lUYfbXsdHXfcMtG/ECA9PPus+FSS?=
 =?us-ascii?Q?CUuGCAu0fuq71yyNIdj9b3O/OQp9a4cA/bKU0kY2C4tGhPyWxDSnryBtUOFo?=
 =?us-ascii?Q?Wd6ILdnCD+uwqmfvg6NG6gu8JvRhZ5uFP3cHkQuK3nN0jIJalJ/8OyCAUlUm?=
 =?us-ascii?Q?Dy6TRTYbE33K5PRjxmtzecCnVo9bo9NfnjVW7yiGZEm1iv0WRZQgJieLpKvS?=
 =?us-ascii?Q?672wTPPQbszuAn/Z5JXrfSB1ysSFiCAV70KutnNONVspiewX+RvPWXFTAdSo?=
 =?us-ascii?Q?9WFFOLb2OwsoVBT1sjhghgTGt1tZWDCZrZc1ceJC2eXU+fE49HA5OMZqC7t+?=
 =?us-ascii?Q?rdWldeBBPWPtND/Zxdi6FY6zhb861dr55Dk8ONc2/4ySXQqIN9fb1kVXBI7R?=
 =?us-ascii?Q?GCoYmOW7bSjig61W+4qCuGj1+uIZLLU+T9iS/ECeoCvHEMqMXmARVkfZldVA?=
 =?us-ascii?Q?9W772B6uFziVTaiqvi/s8HYQQMs+jQ1at8Ek6Q2HzkSQPRa5gtPMc5CCYCqc?=
 =?us-ascii?Q?qWzUblGs2bzpS/v1/QX3fSEVEg4VEaAPF4aVLYTKuCHcM9Y9hEDBnSEciTku?=
 =?us-ascii?Q?dCjWQhleJg/ootuffBVdt29hyvv1d7/ZKPNOcYQQqcRXGtsSb6IvIjya0phB?=
 =?us-ascii?Q?n7xXqv97Rf/1XiiwNiloGA1yZwCU8O8FZOqesPvJbmezh4XkV67UGc+ibS0G?=
 =?us-ascii?Q?/9tWFhyw9D+F03A/rcLiOR5nbV/Wa9AC9oOj58p1ESDcCTAaCy/yZIG5UFSR?=
X-MS-Exchange-AntiSpam-MessageData-1: 8XWHrxwr93w6uXgIn2j2NqxoPaY8VogOd9w=
X-Exchange-RoutingPolicyChecked:
	UyK3uYd1zgd3PR9uf88yBcNZSQC/vbZC/0D1WyMTRt2As983F+duFkbcH+OJzBae0H7O91Ns6eSu2ss5PcdTWxpWb3MBFXzvYkYKeImiLVuCzfwnxAdNPRISVIZu7sQahM8l6UNeaiDDDSAZHa7FRUJFMv9Ka+oVh0Lz0QoJzj6AWl4nqyTd/Y+jtQoWkUt4bPsX1XfMA21ojcrYBP5x+/NLdREpx1PcAtMo0VNsxVc+feFmhjlTho5RK10tCoEyGjI08vzMtuCNuK54bZOrSr40ZH8Ba2BKe3uYO/J289eR/r3PS7uqxbbSQwuMHE6apQfBqdswbmA32wQFmu1FIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gmtPgtpGWdO1MnpiBRYVH8kBRPPDWuIIJ9OPPlLplZ9Rh2kdt3OEJF1Q1MRIearFipgPr3flvXjf3yhD8SaztY3kIPwFtEyjmn0EIwHRRzg6aBiFsXl6cTNOCry3mQWeoWzwXxjIHhpoIKi26GsKh94dwi45D7iCxjtNITPekZRwwmDm5wJbp/IQaosMb2J0a47LYYnzwJS2iDar/G4eATm/FjKh1gQ//aTeL9LvhsnqVFVAP/HV1pxnu8hu0Hd9Oz2/vVsWBPD0icbH+5NRc6h/q7JxaiQpeRRmjLRG7kEjbwL4P1rX9sO3fOW302cll6h8Lh1vCwH35V9bysxuxxBm4zRT3BZwjOTPLc3GyV2cBIHabZRHu9kPXRYb248Gk17C1UTGtxyLUAj/TJ7kB5bjgYVNaMlqjbEswjQTKoq95jIx/t3QfVLe5qkJ7f7msGnnsoHZupZdq0BsR61NE943pW1x9ojFwe99GqtR04dZ4exvGU1uAZUK5sbCA+yz6kWrYpzgsqQ9K6G49dM7z65inp3YtMXGMkXaRvlUW9rHbrYZnpL7XOx8a5xPD5+bCcl85yQmNt1VJlsQzW+52JP0HFfqWB5tskd7tC01UpQga5NCkc0yk+rTPbzj7Fcq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b28cd3-940e-42c8-8025-08df26c70a48
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:22.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDC/lxqx/VPmPZXIVbo3yH3J/fkmiantp9TYVyyqSiPLE+VAUiTg1gJDWZg++YYrShVUPvQpgXILP7hHWZpeg34yj0kqwOImixtUWTEgdAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

Data on a zoned filesystem is always allocated append only, even when it
is placed on conventional zones, and its volume dwarfs the conventional
area a device typically exposes. So there is nothing to gain from placing
a data chunk on a conventional zone. Doing so does hurt though: it
consumes the conventional zones that metadata wants, and metadata is the
only consumer that actually benefits from being able to overwrite in
place.

Mirror the metadata side and search the sequential zones for a data
chunk first, falling back to all zones if that does not yield enough
devices for the requested allocation profile. Devices without
sequential zones, e.g. regular devices with emulated zones, skip the
restricted search and keep working as before.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 250859087e57..0c8bc47a8d2b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5891,6 +5891,15 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+/*
+ * Metadata and system chunks are preferably placed on conventional zones.
+ * Those can be overwritten in place, so such block groups do not need the
+ * append only allocation and writeback paths.
+ *
+ * Data is always allocated append only, even on conventional zones, and dwarfs
+ * the typically small conventional area of a device. So keep it on sequential
+ * zones and leave the conventional zones to metadata.
+ */
 static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
 						const struct alloc_chunk_ctl *ctl)
 {
@@ -5901,9 +5910,9 @@ static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *f
 		return BTRFS_ZONE_FILTER_NONE;
 
 	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
-		return BTRFS_ZONE_FILTER_NONE;
-
-	filter = BTRFS_ZONE_FILTER_CONV;
+		filter = BTRFS_ZONE_FILTER_SEQ;
+	else
+		filter = BTRFS_ZONE_FILTER_CONV;
 
 	/* Avoid a pointless first pass if no device has such zones at all. */
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-- 
2.55.0

