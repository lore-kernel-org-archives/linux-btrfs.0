Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211707;
	b=GOTrFvAD4gp+CZvFHCapeNhCxdWwEjxAfXrIx2t0V+6WVoS5gbXUACexYERORlrQuEvt
	 Pg46p4j/3WXi6H9H6OqrIbrCFE0Byzd8/Zl3BVk3j9/oKjoy0KQQSXzRJf7R0+9YThQwM
	 ionDAK20mtyHzoZcoRbM0sEfNW+/HS4jjxaquc7gJqPmuFTG1uBfoCpl43XnQWHjZoujs
	 myrMLLOipa9tqNVXJH7OYzLFMcK6y9P9iEQDJ8k6+d1XfzXYcehSjwMl27fB+skm85JGM
	 UUUw8NsrxrsSsXtOdJoaCnNzsGC3EMnLF3pwJS7vU5SNzWYjANMx4XWSuhQn63t8a7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211707;
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
	bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
	b=N+Gh1ucOTiJESvDcR3eDpwGGJ0+JMB02lMxihrmCFqqg6/o6tVt2Fp/wCTflQYrs7edQ
	 WogdOlpLXzX6SH/E5/qTrHIQzT1jGJ33NTB10oleFOAedtagx3a51G9/4LazG4MeBnnuu
	 SEaVsSIslm+v0yCPSpQ0lDFOZFMH7D1HBvCBPaGV7zvuEmjlUE2vVlbbk9dz56YN/ZXJQ
	 hBk6wnmwsoG8/eTVXtCuBAlC5zG82wQmytS8vLpxM++9nhY/D39fT6Pr6ZKNwJUqkkIUz
	 fcAT5RLYVL3ln0ZnvB330/Vy8uKRfy2SIkc2CuLFMW9LIpZxUcDdLQ+lgCh3q5coqxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=b6018wmu;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=WHDwyHxE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B538460A261B
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B538460A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=b6018wmu;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=WHDwyHxE
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211706; x=1824747706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vV7uTwbnL2Xi962H8HKrQSM2PsKcF7hodGI1MthiRaU=;
  b=b6018wmuWz2yvMcRzEZpd131ApSWyWmMJmZyzvB1huMq3R7h9jP7D9mB
   rsoThdYG0SsdkyE8lW7GI4EVQNH+EabI53MyHxZwS0BhGre+1BNRH0pFb
   h0KJcrPjYd2c7InmQyDeNeWL6lLxShmtcM9KKfYMFSCRUnUIQgkD1HpMN
   /7T5cBsAHwzH9Fo72M4cwod7IL6RwP9SuYPe871L2gZfWjapa4wr4b4TG
   ECtvBZWROIB0Odmhuem5pAvPlUns76jWM41CAdSld1G1PMDwsspwBiMjb
   8y68HtARz9HjRkz+DUeAWkGQzjAusqTZiIW27bAiw1qSZ3rpqolhfmr8o
   g==;
X-CSE-ConnectionGUID: WgyBI+I/QWyLsKtV7lkpjw==
X-CSE-MsgGUID: X2/iOhDITvWzcF7uX1nLMQ==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194170"
Received: from mail-eastus2azon11010059.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zKT1+Oo1cjOf8/sVMeRtWHLeuy1bfink4cuK+S6cx799Q6281+KPKQsWiryAnbrbhTFDaIYUOp1I0sVJU4XQHSjYJ48mdE46EN/VlLyLJKtf1ZWiJpF5gyv2rsVUrCrcom3yxwICL38S/ZEZbn90tZqDD47v4c6dH4DHxXR9N0ZTmOEwGHrG4yHaVhLvYacNvjxFoikqomIfK5ulWEje6QGilaO7kRNeitbHQPy6doT3uxU7FALlXB2msJyEm/+7B/wnCFyxNIA2bhFnFcavpxN2jXdqPKScx3NUVkBvGAHiqlx9oxUrwZCbF6z6iFGFNuY2u9YuHM9yRACBii0S+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
 b=DmcsLWId7JOV4exdRWllhPT+Erfawgbr63UPD5o4Rg97opDm1mOCVFXXf5sFYJ9D0EqPLO6J2bl8I8ifApX5TYg9t5Y4CG1Kx6YAuO+UGdpx/KW3bPxmU8Hsopo+rttblA34yPFEiyTBJgBDHZrhrlshiYkl1w7n7hrjKPS72bfGRavRMsOU/0FsNeM3Mr1wypGarWzCnoqVo8C8NMGzS0QCKKEop2uOGz7DsAEVrvSKPpbsdLgJ0+6xxC42XDT5hHSfPPRLfGq1b26fmyZil8D9wDqATYHiLfnKBrIl5q5R1wbly6VVm5JrciKE2jk9/AZn/A2XqT66BH2xopZs5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
 b=WHDwyHxECyUaQkK1Qhv0XMi4L9EpNMC5zYoROoeSNPJqTHBBXNmEBEP4diLDQPXlEFCeaXY3RgPBwTbwlbnHvARaNVAevMTyDBVNixAn+evIJgqSqxbeRSW2yi+uQDahdG/vjzAhiZmgN4rtY1vxHLRh4HolMKLBpwHqdup11R8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:41 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:40 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 10/25] btrfs: zoned: use plain mutex lock in btrfs_zoned_release_dirty_metadata
Date: Wed, 28 Oct 2026 19:20:56 +0100
Message-ID: <20261028182111.160492-11-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: f795c04f-dab8-49e1-8a77-08df35204f86
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9etYEvRBec6ghuwvoeFWhPa+67YjtMJUyvTnJsie8Zeysl07d/t/HbEVJKKkyeBtnLZDYOo0dL9dXD1lcsRBtSWdkP6fq8QnaU8y1BrtmPWFr1cJCTSJpGi2RPEjylTFmIP2yU49nsiqB5YkELBMz53DBzY2o62cwGHC1lxA84dTsIugRuku41WJDnox8hfHjMO4LwMJoT+A51yl4ybAW7JgGc1o1IEq4QB9AmnSNRHYMcRkQok7Fnqe4tS/F4meaxLae/reQfQrWmWbJEP4IKX+uXNArh1FsP6WG1NUcA7/RkNWLnaKHdx48MKr9C56iyLkcSE0Q3pDhCNKig6wN36vTbPC1HPaG5X5daTUc0gHfADfbOVs3XBz4VsdkwPWIwNBL8ScjzOVzQW3YI+O3iIMDwpwJSd4hNIpDubohYIQZGQtSXIRcnAdlFpoe911Yu37Zlu8X7XgPUNCKRBMtziswGFT1i71vworP4lJpXmjU9+VcPzX2EqbH0mjaDwTbhJh9p/93ggMyIOQIyYoTEetM2cqI/x6UxPDY0O/8ahFEFMt5+OHz6k9Y6uLnZKKRxcdUOAbKF7Xe9oZz9eM+Q5O4JYPiDoZ95Tctjk+oeoEMTLsLHdbnT4OvnFWlY9KUyqm04DhdOa9CzJhjU/nntYYFD/mDdOpn0iH4n2I8Lw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ctXZUPRDw1/vHN5BtPRk1SbohQJFDJfvF7Qg4s8YrwjU0PHh74IamUqBA5zT?=
 =?us-ascii?Q?k9UW397PLGpmJSK5T73+df6B7P6+n7+8hbmWccW1ST5F8drqoV07Ea5oPVjv?=
 =?us-ascii?Q?SLEYIh+bXJohHvhmxTQUEZRbF6hbgdjShG32ilyZ7A7nnWzpahDRTuaJCsLI?=
 =?us-ascii?Q?Ljs073sOW/tS3tnGf/mYJ1oPwB4qkusiLtDeLayarMjxAGO4ADQXXixCePFt?=
 =?us-ascii?Q?9AaVUJwt0FQYovtPq296LH1VYbMmsZUC8VvO4TsaBmyQPHknEFWpuXWCthEe?=
 =?us-ascii?Q?Se7K46lBjutObV6nQPpHSYfxxrLQ+Rwkhw8IEbiRJ/WJBJNusn7EiV8q+euk?=
 =?us-ascii?Q?j5T2Vq4QZiW/UCPacHVoIpwXzZEbZXkCPQLGqXZR5v6WNeZauN8voaM5Z83H?=
 =?us-ascii?Q?vZwxa3TUoDAznoq2xyoZe9eXQiCaxFxZyWcQfmQqqEfttP39xQveYsWgvNul?=
 =?us-ascii?Q?78gRxSkT+CWyVhxqJUcN7yCMxIODvfAVkrxxblC/5DmTEAIMv0ObcBDq+Jpb?=
 =?us-ascii?Q?BM2BHARcJ5CZ2bGHPPwEGufc/UpfVIhjwh61R+pV9wllHS/gWPHFpPDPaJst?=
 =?us-ascii?Q?Fgr+XZt0nQzllC3XY+RZGNbUfqKGi2S0u8VLtOshSTMxTmd+z891JaQrxgpA?=
 =?us-ascii?Q?k+ASqnmtS40hKs0t53aG6qi2zyaRjyO3E3IGz9ByxaHLowpRQe6n1G/uKqxz?=
 =?us-ascii?Q?4GepRMSJt8UCJqMfzK2dnN0W7QuOpPLrHDu/mpkTUwNTVrhdRE/eaEgBMoso?=
 =?us-ascii?Q?aNoR1nFaB3NseE0WuoAMqrpJB86gsgnDDbyFqmoSDtg37+loW2dPYUPDRyer?=
 =?us-ascii?Q?QP1KRtSl3KvQouI/uZdaAJRVCo9l9xmhJUScdTlraiwKaL0S9aDXM4NxOo6T?=
 =?us-ascii?Q?S2cMS9LesJ9fOyBn9xi/PTHAsih4TNl8naei2Ct+3zo36GG4TgxGJlJtmkMu?=
 =?us-ascii?Q?AxqqvyhrYRvSyEm1508O+4OZAFGY0NPKFgwXsyPEu7/OhUa/MaZhRI+toVgl?=
 =?us-ascii?Q?MTbMF55aUfOQw1og7/QejgY2RwQ4EOP5VtXOgjGjM3pLkrUfkiZQNJ86nLOg?=
 =?us-ascii?Q?YpHA8v4ksL5MgrvfmA/bcnDsbj2SeIJSsvd+UaHOtZo2RocvnycdWdS+81EV?=
 =?us-ascii?Q?YlA7V6qyxaq1LS9cIhltDdgl/N2ifXOV59W0M6kN9bDDjtng23+oOrENnUfQ?=
 =?us-ascii?Q?niAkGx3rDR/AXPG4UNFKBylMjySlG0720SnbaNKXUYI5VA6W7xHig4Vq8ZKd?=
 =?us-ascii?Q?CAsRm5jH9OAAt+4+7qj/0bDnjoq7wT3x+kL94SBI+ygYJoy9UFF0YykPmh5X?=
 =?us-ascii?Q?t2FjOCuHaoyDf1OgTiH6BV5L1IeqWE/1jbIICpGGfkxZMQCSRGPHxOGQcl5o?=
 =?us-ascii?Q?bw2Rpt8IXClCYokVLoQvhi9KEqxyAHXlI89hlcZCX6sKjTHPBdoJkUS5xuCB?=
 =?us-ascii?Q?TTCe1WlXkzYyxZ98+IziJ70GPdNJOq5Yb0YVxcQ7OpWWIbM94s1K+VflBMHM?=
 =?us-ascii?Q?Vrh3NCERekGns8fcI12EoMGBF1VnspJvDdqS45wLb+iJL/KzRTGUa+OxMUTQ?=
 =?us-ascii?Q?56GeIZsqgIuA+5fEczjMpL4GEQ+hwjmtnxUa5O66rmkIEpkqT7yIRCds6WPl?=
 =?us-ascii?Q?e6dRZY5Y8OQGlK5SOcaAa5LZ455IFbHzxc1iBiJK3Nunb5QN/6qVFYura29P?=
 =?us-ascii?Q?uCXHQbiyxXKb1fWBBqSKaadUWeZ1Sl2TccOLLuab/dbxIdJAuf0jfTz4LVx2?=
 =?us-ascii?Q?qIwhM2oi6B33PXjxXhJiEkx7fa4exyWv+uHfl0DAxar+YU6ZITZ2tqZI8/PG?=
X-MS-Exchange-AntiSpam-MessageData-1: hJPkR3OYpBzVv6Oi0+4rUH9HXTKT/L9oNjE=
X-Exchange-RoutingPolicyChecked:
	TJMeqh6ZryNYAoCzcWS4sFy5vkSASEi17VAcEQvOReCAlKMtBrhdW3tG8oGYGiQGw4ohuD3MjLt+L/GC0/XTsrdPSXZEEkDNRRD1fAreZ14c1wA4J/a2UQUAoXZgcLoHKet/TP+MBSDEbbKY46HwdACopqj1EyJsA50Mxd7yWEMhXynY9BH1ybCLq+BQoaYUyn2ki8ik+LQc6ft9C3zeCyK44s57WW395gc65VYktetX59w2PvmYWiec7E5CCbPOkyWJOQ0MuYlI9QgiOyO/sHgeU1RclYvCYId3VWh+LrWu8rpyF5Y0BEP2k/nog4oWAiI1hu2knqJ3qBTcWmzCLg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	84GhcTuSR8sdotB9AzynM07Ipa0C3xMqB0xyIlnjFFrkSXFq73tntz9ISWWXmTtLar2VLhNIseym8BVHw8KqO2Clzl27LE+KpaSl0UP8EyHpqxD5kv8NjEu3wVe487Zpy7fmuMQzUEEWSPJMzaAlUBHeu/E0pq39BIgzypzlgB7TxHTxWWG7Tuiv+yiiIQS7cZrVJBwz1x5tHimd3BO6XH6iCBZr4Q8nDw8yUYeuotxEhwYNdX1i/mgpNNvF5fEipQgFeXFsCvtx4jGp6b1veBe5gCpya+rLNop5N87Q7B8vXDrzQ0jkgfzhMKp8fRfUJhxBoddBeXroYRIDsRu9Vl0yqZFuh5NRnXX45kyUnAkOqRnvHkkiy5ogLGYS87JzRd2s/Te4hrWCyEQWdK9lxTQgdBq6ipWGHP9Por8I+qgznAl67CHWug/AB9oFXfwuioYNxwQ2o3gFUh6BU43sO8yaQVAxiRMxNm7jjJ3dNnjk26SuIpHwwmzoISbuRfS2DP1CWZsGRXQTRvyQKuHwA/7R8UvEbtFgSKoStMVbx+X3crGBnYmHKn5/nG9qw3heej8DbBbQx6BU0uB+D5LHXz66Y2FyR08nGdbUL4ke8El64e07PacoRGoTw9FRPoJV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f795c04f-dab8-49e1-8a77-08df35204f86
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:40.3363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0mbAOB4LOp/lkvN57HNKaez7AjUS3IFct2KFqm3mDaW3qjsZyGqmP7V6NuRD+YlkBM4NS+jgncK2UsD0+GeEXe94TACkg8GX38G00IcOdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

btrfs_zoned_release_dirty_metadata() already bails out if it is not
called on a zoned filesystem, so there is no need in using the wrapper
for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9a85fd478d0c..492e1bc83d49 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4224,7 +4224,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	btrfs_zoned_meta_io_lock(fs_info);
+	mutex_lock(&fs_info->zoned_meta_io_lock);
 	eb_batch_init(&batch);
 	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
 				       PAGECACHE_TAG_DIRTY, &batch)) {
@@ -4240,7 +4240,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 		eb_batch_release(&batch);
 		cond_resched();
 	}
-	btrfs_zoned_meta_io_unlock(fs_info);
+	mutex_unlock(&fs_info->zoned_meta_io_lock);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
-- 
2.56.0

