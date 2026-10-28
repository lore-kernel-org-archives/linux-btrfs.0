Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211717;
	b=Vz+1mW9DEPDDh1GfrfyrgV4nM77MshO/imNrGeaboTJ+VYn3ZLmtvdHBU9I+4v4Ot2U5
	 8Q4ZdZjGoihE2yUFP6+lhy+at7vzj3hmaHNbKT5MWmEWaFVDRKnov09qL7748iEb8ERZJ
	 vJcdaIEuPnla91nhteOJwKlGg3r1UILutAGMpTLNHmQJQ/A9BFoFrxTe9VgioY7QuQ7jR
	 6HdpCg2tjUsc47s1dLHPQXQq+Za9OpDvIxmVV9h/ZjV3taqTE90UNp8yjLItE/t9Swtuq
	 a+NmsaL/T4Jk8jNhes6fNbFGyPqIQ+1NyQ/W7u/TztWebWIqgJ9c8pWkuTFoKhFMk/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211717;
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
	bh=curQCPRmJZzs+kGBqO9egKErvnTi4MfCUmUZ5BJ00fU=;
	b=KXr5Hzxqe424nrUtmzMESR+aWV2Cbw0008Bdl0hCEwtMnLFynKF1xHB9ZzoUw4VDUe/j
	 rlyJCG+MINCnpUBhPszxoozQT9SHmPQtkNKtkYI878+Uoj0vZuLaQ8It0ae36mwxf2sRW
	 Y0tK4iHrK2E+hncDQvShNlqjktmkv3PTAEDus9eXm6/l9Ua0ZJpgs/J1jM0IFlohguRco
	 S/qve497YX75KZoS39UwMYxPs3h5jRdgMbmcUKq9FTyrIEo6GKsHGmYTflrKpjEWt7Fpa
	 VhO6bQ9KRPcbwXG+AG4mq/Q8/xpjyQZY8hLbD8pKYPKN8LBR07L9XHEpGf5jr7HQsNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lQbzwFzt;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=r4doAA0P;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA86606A33B
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CA86606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lQbzwFzt;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=r4doAA0P
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211717; x=1824747717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=c1/F3fbrhGz2dGnD2pmZxp8I+IfzrEB7D5Tuo5gpkdw=;
  b=lQbzwFztL/QATnBS+X1nzyZkiIGCT9DW/v3cKFHQyTPVDsY1poEGPDht
   w7ycrEDxbj3o1H3K4afUqVM0Lf2bCU7T24Jz0xRCUIxjNm6XN3N4zg65b
   OwLT9f4oCxcXH/qL2xBZ9nN8En/DMb0pmCGkDusgmvFuNUMX7/sLpBEev
   Q6FcmvUfyNZnMMbzamIG8xLXMsRl8w2ZsAZMsUVUzxyoFAkAcxkmdpFqI
   4SODsNpeiny3WiKk6VFBiynlZ5ODp65mo5lZrBmcyA+SPoQwkkDViw0Rr
   7x9cnguyZ/Ig1g63KJHvkGcsbsmgCZifuMyBokJydGEbCpUskRzPkttcD
   A==;
X-CSE-ConnectionGUID: GmIGTsWKRoeT5YolpQCYCA==
X-CSE-MsgGUID: bUqY4AECR7i0fI2S2gaZCA==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="155004271"
Received: from mail-westus3azon11011052.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=htMsc/PN5nbVIf4GqpXUwiaNKiohKGw47N8IfGjaRw7RGeEjORByTQeO6e9iGprMEPu10o+Z+r0AguO6Bi0fvmG2nE9txcNRWCRMl3YPVzypmrILUzPy/K65ZYFK1XqW/0tzP58XRTu2U7Hl4RmlXW80nrtFBj4S+H2l6hzZVYjfW9rcKoisg/FGNnRQDEV0utsvZgoBV3IDYR8Gp/lDnrz8OmNMcnYUD4GxNc9npVYTRCbhF2byNZ6O4tKLkA0pK6opiGCL/v7/XEfvkNCBHjFXQWredg7ZYfkehxxYBI+gp/wJ9hHTNWjFGMg2z264cePV/UZXahaZVfsT3vkCOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=curQCPRmJZzs+kGBqO9egKErvnTi4MfCUmUZ5BJ00fU=;
 b=D1SA4yZSuHAywoL0LzLkOfbBKZivTIK/HpcBiLQRA8ydoxjDyh9PrZl3r3jrNwjJJO31WksPNlHbz+f57dn3nHH+zId1q9Qc18sIy7A63h/XJSf9szuy0UvqxCjSafMmysH/GJ8q/kG9OquJpRtsHIV4AljT6nGbf/cwJYxGMMOHarqjzT5Gl8kAcyZTEqQZSvc2YhPiZtUu1tcBUXMR8A1LRTennLgvepE0lXRR9CG0QZY9urnfPF64EeM/Y6/ZviXPPE1xvcrdnuLmbrYRh3AmUwThhdQDk0+FypfJCQuV+BiqK3h8Sf/xIKdkaSfdjbVxSnDWQTHk/hfBhZJMqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=curQCPRmJZzs+kGBqO9egKErvnTi4MfCUmUZ5BJ00fU=;
 b=r4doAA0PD61DZcxby3Pc46L8X7iDtdulgzGWF294ATke7VasP4MiR32be1qMpqFaqQOCLBI0DPgk+MnTBJA8OXpOeZNf6EqG/laCjbXH54qdZ9dbQkgigB725L9S9hbsjdGmdoUxmppsSrVvxnGm2BwTVnamBgrvOVuT3vCJ1FU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:49 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:49 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 18/25] btrfs: zoned: prepare reserving the data relocation block group at runtime
Date: Wed, 28 Oct 2026 19:21:04 +0100
Message-ID: <20261028182111.160492-19-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: d8606474-8439-43e9-f82a-08df3520553f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|5023799004|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PDclkt9rAwaoaxPIpB9yhMJNYukGx1wQAt/PkQTkRk1vTjDcl6XowKYhbKNu9UYSmNuV10rfDxG+idx4326ai+QI03ZfyXcb150RbMqXszRdn2l4N3qSPbUaYlYgvJp2JkFAtzlv4YKNVltlgg9zjJlp8bfFgmAqJ9xNYvfWGevwnnPQum06sriKI0qDrYcT4xPSaayLQ/pqbvfr1YDhSu1XuqgD2/UmZsW7O3ZJ/voDDBZjB30j+8bPGZ1sxey7NRnmsM927xe9wT5pN2pIJS6Hiy1NMt2AmD8UMPvJJ64Bxdlv9y3bJFT0FUAM4SVhPHklzL5pRfGWIZ8PsEnnNQCPYnN3+8PPEvr4msACU5NYmGRUosRy4Ludy37rl3FAk9NtzScAb7T42vpVbGOlovCuuk8bGLQNsDpzIcBrOZ4IUamXPr9QzfAVIOCM4j3Or9UyVoOvKli+uorGOQTYxr9iclDYcP50Ii64Fhhci98S3KFOqNKMyl8pvOrqNJy0oRFBwCoZZRLyLMpF8+ixVlPQL6mIN4JibBHXlccdjv76PHW2hQEHTpk1kXR/dOkFkvcSSlWm/W58TRCW3E6R7UoCR8PRWv4YEJ0H0nXdH/YnQF2nzYaF8SaO5zZRBJqKKiPpesSITpeFVCVW3Qynn7QkXK42jBOQ4Df7U5EOk+s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(5023799004)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?++VgpJ4G+tNNw4BHKtMAH0F3vCb6ypL49sJpAhb4omrQ22z2Yc1/yX7WgAVi?=
 =?us-ascii?Q?o1Gq258arlQD3GFGv1pLo9l+TWreyt+f9nwSf8D6ybaEw/aiVS9Bmi78r8zv?=
 =?us-ascii?Q?dEXV9Skx/XeALHvTZUpuBnfuiGmcpeS1HQE5/FdCDEPsVv+oxjC+vtNQsEuW?=
 =?us-ascii?Q?+st5gXJtVECLIplQeKX/5VYtvODwT/ZiaOmI1VYQq/XWZg0s1LwRmM7O0r0Z?=
 =?us-ascii?Q?2yhSrbRbAPxado36+ikkgVon36bcRqB4B2fYFENajR6kCvdPte8dbHQxG33H?=
 =?us-ascii?Q?2YxlinfKA2pcDust3pKPFQzaohpv00obvCmUozZ2/r9NZt9qtctx31bDaAf6?=
 =?us-ascii?Q?GHS0sCT/RhNY394r4Xbxi5E8GY71lGUFrmZW6Q/T2PxUIPQt9sRabd7bgetq?=
 =?us-ascii?Q?Hb0loqcaJQgH3s4WbWmMzzvFBA0TUtEMfdKJ/L6sVettrXQO6EqN98SEu78x?=
 =?us-ascii?Q?tag6+HyOGScZJO7FtWZyoThEmJgeBaYHyU4bAGuEaChreymZxOMVLOWyKDVL?=
 =?us-ascii?Q?7ov6KKZztfgArTimNhpTSN9X7A5MRXd2NXCqfT+WV9pXdxBcvNEBeo9ZtR8e?=
 =?us-ascii?Q?6euTy5XsUjOGEDR4s17+B/U/xErPRaB2fx+Sarx62uvU7De5Gcl4BaWZfxrp?=
 =?us-ascii?Q?HnA/DyloRcVlJ9V8XN5HMimPqDYNlBJxLwz8k9k9R9cuWiDMQdgb0pAEsVZY?=
 =?us-ascii?Q?yHqkd5zoakML6+O9P9+9oegatbmq1d1Zvam91L9Rbcjxu/PHuHlSwZhen30x?=
 =?us-ascii?Q?QHkuMQ+WkCZ1QBeTTxA+KW488R3HvG15weEnuVGOiDhyaBlKj54w4UKdlIWo?=
 =?us-ascii?Q?PcarH5AY/lvxPfRic0vzbORf2Rq+IWTne47FXEeytbPJT9xBF6IiBfOEks//?=
 =?us-ascii?Q?9nEdFhUKomCFK9pXKxvFYXvUZ+LZ58qrIA0SmPR7GY2XOOZUpSYTqo3ekI7N?=
 =?us-ascii?Q?B/fSSpxTPyKLhTtCBA3aUIcskrvnZBNMBBqU/r+a+IeaD+LjyEce2a4tAKp/?=
 =?us-ascii?Q?ZQo4nRvBRh+4CndIDvKQV3uMiGL3gdvGRanr4uwHGxOkoMemXVvEZmMiJOQX?=
 =?us-ascii?Q?UNzZaAOkBjhPI/C8ZBqr0Ly8nA7YQfGSEQ8ffFN0FY2eAKMB/ygG9TB4yIvX?=
 =?us-ascii?Q?6EZqLi7bFX7it+9hkD00e8sc9aT1sPd6Js0+M4OHBxPxXEOTfhC75odW4eIT?=
 =?us-ascii?Q?lwy2iF4oM89ZQI1vMelmVFwAq3nlrsjUNo6VFNrWDyTEDQv8AV/vmu6xiSin?=
 =?us-ascii?Q?pXQ5q/NvOwiPLXyZsev4XUYs9NolUgvnQ11IZjUn9Mlz+tSYxSy5gt64AkQO?=
 =?us-ascii?Q?ePb1zLc08F7t5hfxRnfS/L9fm/s+XEMu1gOgyToPJD9onyxi8+5aFJK2gG/7?=
 =?us-ascii?Q?xSqlDYeHp7Nrve7/SernkjEAkAZ4LLsUXJqnClcJcYx5+40l90OSGKH01jE5?=
 =?us-ascii?Q?aYyQpTrgU+l8f+FTVjizjd15uiavlgG9bRtllvuh9+4kLxXiR29+EybHZMiX?=
 =?us-ascii?Q?YkVZllX0d+FdzoSjFgchUZLYjPQS7QQZgd3iEU6z1FbyistPnHMi3jqXBrkR?=
 =?us-ascii?Q?eXERvbtXVYbkT/3bGwi2zn+D4gLuF/ShD2BUKk33UcMaFCafGvqI4vsxVSWC?=
 =?us-ascii?Q?H8jVTBctI69m3d+AmLcI3k31I2laCKPH5tovkyOhrQS+SDVHswPJbDROV4YV?=
 =?us-ascii?Q?KVJMWL/mPN+2stRoUJY9EjZDlpx8gW1zG5/EKR2zyFEEKIokfjSFs770yNBt?=
 =?us-ascii?Q?TogzY916GCkY9+VHpgPHJB6GdPS3vL1deZL7QMNo7GbsOn3RiG4rJ42FT6TY?=
X-MS-Exchange-AntiSpam-MessageData-1: p1f9xcTqxwNkiA+r1ILk/NCPjbcFnx3m4mM=
X-Exchange-RoutingPolicyChecked:
	ikiJFi4xIxalbLi4gsePU7HggWbPajqDXm/6aUcca1ljQqL+RosBzPV+IFoEIHa25cNpWKDF3cx+vQTgUv18zdvn0sx42tYUoXizci/YXDiel/CNbWF+VwyUkQmGnyfiYJLroX8FMsXgB1HKZw0r9/4f3Zk7zm09hNOP4c2rwYLmll0ocJHO9gfRXFP5Q22CJ7Mk5X8CnINbiN+DFwXKASE/G5QBlQ8NDWZ/nMVRwRqRnsNBZXJfrf3Imbno1WpJs9W3dub3hTTFYTSbbEYxd+EBCCy5JDNnmyM3FULIgqZ0yhpx+8OhtN7sZq1FzS/hytQ+J7r7uN25hxq31qKMig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3Use1g5vW99SLO2AK03RIgTZzb4RGv4RMo1jPsuNUwLnpXKANen90PDEbmASyi5caKPwHtwfGNdab+1FDzuvtPwESGKn0ihsOgjC2+Yggqw6A2yDR35MJe0sDWxLxo/jnIloL7OBeRPKUVP/sRlsHGeD/BQX++s7CujCNq/4DRF28o2jejLNEyKNRc9LVX4/vDJrlNcZfVaR7cKPS/U9hC0K30hPP4TmCvAt9gmnLTkhW+ECTRU1oKFIzlQ82YruMLCOZ3/di8bHKGUau4vT6mszBHoCq+wq0/Rqf/y7WpXj6tXPYOZ2xpe4Cvu2iJTXVf2c5lPCUDBivwEiW4rkfB6/X9qPaO/Ita3y3RbKFv8MlvTgJZ1mEM9UZ4XygoYgEni4MkwBnYYbY2DdypYgOoEEHGs0KlR5XDTchPmLoVTh3v0ekTTeLB7nWIWtsXO/dT74vLzS+T9x+kvFvPjbbYrGXZa1y+6pi4NYAM8hIrX5HacACm1Lp5g9Sy9ZYS/AA4PFYd6bI0fD0SFHiPB72YimHTbGZ5b09OLi/8A1Xtwk+Jjx01HMnP1zLzpTBaXJmiRU5i4QBPAj8/g32ndAMeBWjFSGHYv6bKxXRR9eKwpdXz4iAs6oDT2S+X11w839
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8606474-8439-43e9-f82a-08df3520553f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:49.7129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ot3hM3kNY1Ua2VPZ6+4Vr7L/3pjmGxaam7GH6Dk1Zw8RNQtbrNhMs6oTf0YBqH8OQSHlvv15umvuAt67celkCTP2ABMY+eyBhEaEAhCJ/v0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

btrfs_zoned_reserve_data_reloc_bg() is only called at mount time, so it
walks the data space_info's block group list without locking and does not
expect the candidate block group to change underneath it.

Prepare it for being called at runtime, concurrently with allocations:
walk the block group list under groups_sem, pin the candidate with a
reference and recheck that it is still empty under the write lock before
moving it to the data relocation sub space_info.

Factor out setting the data relocation block group into
btrfs_set_data_reloc_bg() and transfer the complete accounting of the
block group, including its zone_unusable bytes, to the data relocation
sub space_info.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  11 +++
 fs/btrfs/block-group.h |   1 +
 fs/btrfs/extent-tree.c |  12 ++-
 fs/btrfs/zoned.c       | 201 ++++++++++++++++++++++++++++++++---------
 4 files changed, 180 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 25b44932d0c6..70f8ea56df69 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3242,6 +3242,17 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	return ret;
 }
 
+/*
+ * Unlike btrfs_inc_block_group_ro() this neither joins a transaction nor
+ * allocates a chunk, so it can be used from space flushing context. Currently
+ * only used in zoned mode.
+ */
+int btrfs_inc_block_group_ro_notrans(struct btrfs_block_group *cache)
+{
+	ASSERT(btrfs_is_zoned(cache->fs_info));
+	return inc_block_group_ro(cache, false);
+}
+
 void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d567ed822e55..baf8e41ce8d3 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -353,6 +353,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 			     bool do_chunk_alloc);
 void btrfs_dec_block_group_ro(struct btrfs_block_group *cache);
+int btrfs_inc_block_group_ro_notrans(struct btrfs_block_group *cache);
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c33f724fc04a..e5fe2f6e5c5c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4097,9 +4097,12 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	ASSERT(!ffe_ctl->for_treelog ||
 	       block_group->start == fs_info->treelog_bg ||
 	       fs_info->treelog_bg == 0);
-	ASSERT(!ffe_ctl->for_data_reloc ||
-	       block_group->start == fs_info->data_reloc_bg ||
-	       fs_info->data_reloc_bg == 0);
+
+	if (ffe_ctl->for_data_reloc && fs_info->data_reloc_bg &&
+	    fs_info->data_reloc_bg != block_group->start) {
+		ret = 1;
+		goto out;
+	}
 
 	if (block_group->ro ||
 	    (!ffe_ctl->for_data_reloc &&
@@ -4183,7 +4186,8 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 out:
 	if (ret && ffe_ctl->for_treelog)
 		fs_info->treelog_bg = 0;
-	if (ret && ffe_ctl->for_data_reloc)
+	if (ret && ffe_ctl->for_data_reloc &&
+	    fs_info->data_reloc_bg == block_group->start)
 		fs_info->data_reloc_bg = 0;
 	spin_unlock(&fs_info->relocation_bg_lock);
 	spin_unlock(&fs_info->treelog_bg_lock);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index cec160d03806..dc074cb0c042 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2915,6 +2915,131 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+/*
+ * Move the empty block group @bg from @from to @to, which are the data
+ * space_info and its relocation sub-group.
+ *
+ * The caller holds the only read-only reference on @bg, so nothing can be
+ * allocated from it and its free space is accounted as readonly, not as
+ * available to reservations. As it has no used, pinned or reserved bytes,
+ * no accounting path can update its counters while it changes owner.
+ */
+static bool zoned_move_bg_to_space_info(struct btrfs_fs_info *fs_info,
+					struct btrfs_block_group *bg,
+					struct btrfs_space_info *from,
+					struct btrfs_space_info *to)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
+	const int factor = btrfs_bg_type_to_factor(bg->flags);
+	const int index = btrfs_bg_flags_to_raid_index(bg->flags);
+	bool moved = false;
+	u64 readonly;
+
+	ASSERT((from == data_sinfo && to == reloc_sinfo) ||
+	       (from == reloc_sinfo && to == data_sinfo));
+
+	down_write(&data_sinfo->groups_sem);
+	down_write_nested(&reloc_sinfo->groups_sem, SINGLE_DEPTH_NESTING);
+	spin_lock(&data_sinfo->lock);
+	spin_lock_nested(&reloc_sinfo->lock, SINGLE_DEPTH_NESTING);
+	spin_lock(&bg->lock);
+
+	if (bg->space_info != from || bg->ro != 1 || btrfs_is_block_group_used(bg))
+		goto out;
+	if (to == reloc_sinfo && bg->alloc_offset)
+		goto out;
+
+	readonly = btrfs_block_group_available_space(bg);
+
+	from->total_bytes -= bg->length;
+	from->disk_total -= bg->length * factor;
+	from->bytes_readonly -= readonly;
+	btrfs_space_info_update_bytes_zone_unusable(from, -(s64)bg->zone_unusable);
+	from->max_extent_size = 0;
+
+	to->total_bytes += bg->length;
+	to->disk_total += bg->length * factor;
+	to->bytes_readonly += readonly;
+	btrfs_space_info_update_bytes_zone_unusable(to, bg->zone_unusable);
+	to->full = false;
+
+	bg->space_info = to;
+	list_move_tail(&bg->list, &to->block_groups[index]);
+	list_move_tail(&bg->ro_list, &to->ro_bgs);
+	moved = true;
+out:
+	spin_unlock(&bg->lock);
+	spin_unlock(&reloc_sinfo->lock);
+	spin_unlock(&data_sinfo->lock);
+	up_write(&reloc_sinfo->groups_sem);
+	up_write(&data_sinfo->groups_sem);
+
+	if (moved && !to->block_group_kobjs[index])
+		btrfs_sysfs_add_block_group_type(bg);
+
+	return moved;
+}
+
+static void zoned_dec_bg_ro(struct btrfs_block_group *bg)
+{
+	struct btrfs_space_info *space_info = bg->space_info;
+
+	btrfs_dec_block_group_ro(bg);
+	spin_lock(&space_info->lock);
+	btrfs_try_granting_tickets(space_info);
+	spin_unlock(&space_info->lock);
+}
+
+static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
+				    struct btrfs_block_group *bg)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
+	const bool migrate = (bg->space_info == data_sinfo);
+
+	ASSERT(reloc_sinfo->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
+	       "subgroup_id=%d", reloc_sinfo->subgroup_id);
+
+	if (migrate) {
+		/*
+		 * Fails if the free space of @bg already backs reservations
+		 * in the data space_info.
+		 */
+		if (btrfs_inc_block_group_ro_notrans(bg))
+			return false;
+
+		if (!zoned_move_bg_to_space_info(fs_info, bg, data_sinfo, reloc_sinfo)) {
+			zoned_dec_bg_ro(bg);
+			return false;
+		}
+		ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
+	}
+
+	spin_lock(&fs_info->relocation_bg_lock);
+	if (fs_info->data_reloc_bg) {
+		spin_unlock(&fs_info->relocation_bg_lock);
+
+		if (migrate) {
+			zoned_move_bg_to_space_info(fs_info, bg, reloc_sinfo,
+					data_sinfo);
+			zoned_dec_bg_ro(bg);
+		}
+
+		return false;
+	}
+	fs_info->data_reloc_bg = bg->start;
+	spin_unlock(&fs_info->relocation_bg_lock);
+	set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+
+	if (migrate)
+		zoned_dec_bg_ro(bg);
+
+	btrfs_zone_activate(bg);
+
+	return true;
+}
+
 static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -2947,7 +3072,7 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 	spin_lock(&space_info->lock);
 	spin_lock(&bg->lock);
 	ASSERT(!btrfs_is_block_group_used(bg));
-	if (bg->ro) {
+	if (bg->ro || bg->space_info != space_info) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		return 0;
@@ -2986,7 +3111,7 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
 	struct btrfs_space_info *space_info = data_sinfo;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_block_group *bg;
+	struct btrfs_block_group *bg, *tmp;
 	struct list_head *bg_list;
 	u64 alloc_flags;
 	bool did_chunk_alloc = false;
@@ -2996,9 +3121,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	if (fs_info->data_reloc_bg)
-		return;
-
 	if (sb_rdonly(fs_info->sb))
 		return;
 
@@ -3006,46 +3128,43 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	index = btrfs_bg_flags_to_raid_index(alloc_flags);
 
 again:
-	bg_list = &space_info->block_groups[index];
-	list_for_each_entry(bg, bg_list, list) {
+	/*
+	 * It's OK to check without taking fs_info::relocation_bg_lock here, it
+	 * is only to bail out if we have a relocation block-group.
+	 */
+	if (data_race(fs_info->data_reloc_bg))
+		return;
 
-		if (bg->alloc_offset != 0)
+	/*
+	 * Find a completely empty block group. Unlike at mount time, this can
+	 * now run concurrently with allocations, so iterate under groups_sem
+	 * and pin a candidate with a reference before dropping the lock and
+	 * operating on it.
+	 */
+	bg = NULL;
+	bg_list = &space_info->block_groups[index];
+	down_read(&space_info->groups_sem);
+	list_for_each_entry(tmp, bg_list, list) {
+		bool usable;
+
+		spin_lock(&tmp->lock);
+		usable = (tmp->alloc_offset == 0 && tmp->used == 0 &&
+			  tmp->reserved == 0 && !tmp->ro);
+		spin_unlock(&tmp->lock);
+		if (!usable)
 			continue;
+		bg = tmp;
+		btrfs_get_block_group(bg);
+		break;
+	}
+	up_read(&space_info->groups_sem);
 
-		if (space_info == data_sinfo) {
-			/* Migrate the block group to the data relocation space_info. */
-			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
-			int factor;
-
-			ASSERT(reloc_sinfo->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
-			       "reloc_sinfo->subgroup_id=%d", reloc_sinfo->subgroup_id);
-			factor = btrfs_bg_type_to_factor(bg->flags);
-
-			down_write(&space_info->groups_sem);
-			list_del_init(&bg->list);
-			up_write(&space_info->groups_sem);
-
-			spin_lock(&space_info->lock);
-			space_info->total_bytes -= bg->length;
-			space_info->disk_total -= bg->length * factor;
-			space_info->disk_total -= bg->zone_unusable;
-			/* There is no allocation ever happened. */
-			ASSERT(bg->used == 0, "bg->used=%llu", bg->used);
-			/* No super block in a block group on the zoned setup. */
-			ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
-			spin_unlock(&space_info->lock);
-
-			bg->space_info = reloc_sinfo;
-			if (reloc_sinfo->block_group_kobjs[index] == NULL)
-				btrfs_sysfs_add_block_group_type(bg);
-
-			btrfs_add_bg_to_space_info(bg);
-		}
-
-		fs_info->data_reloc_bg = bg->start;
-		set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
-		btrfs_zone_activate(bg);
+	if (bg) {
+		bool set = btrfs_set_data_reloc_bg(fs_info, bg);
 
+		btrfs_put_block_group(bg);
+		if (!set)
+			goto again;
 		return;
 	}
 
-- 
2.56.0

