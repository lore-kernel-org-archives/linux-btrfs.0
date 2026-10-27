Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085789;
	b=gLAkl9muqF0LlO8O1cvpkuO6EKWiYLHjneGKJ9QjpqMacAJe9EtOnKLNikgp5d7yyDUF
	 Bapms1hLxfhsTKNAtVdA5jQRSqXO6kXp+cm33Mn17Op7u6xqDqf/3+dBkoxQ9PvOfRF55
	 ydv3goAGXbTJz4jE+4hwGjw1n+bRhjbLVz1iyryM6F8Nuxegm/xxAGzzDCnP+/561q/mE
	 nfvawS5LM6H5bwfTZ6elP8D9OByz0w3BftwSARPV2JD+cJ/V58gCyqoB/71sSfxxbGoyG
	 GcVINaKks+9RF3BcuhFdVvQEKqb0OW8f1zP9HwnMo7UqSFkNJPVyHLxzx3t3R8/nJ7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085789;
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
	bh=fBjPXTiDTjcTursfe7F1MvtPe7WGh98YIAcvDu09P6U=;
	b=deb+m+rk9paVrrXHCXrUCDeXrs01ndumIkpx/i+bIg4W2WrTsKKRf5Y0ZvSkPabIxAqt
	 YCQH0WSgcVyc5PNEFciJuCeWIhFQ/GnPQSG144v7Hs+XArpPBNfP27EKGqkSQM9q88wzx
	 Uya62yoUFF/N6E2+6kj8cAdPMEf/8z0VFtGUZoFJLcvfORdeMUl+jC/rR9SfmVIdolBJp
	 ntysiridEOgVWaZfcZrvf9Fhdy1eoi48CJeyHRB7IQ7H9pkliSokdlkQMG7E/nVLM1jIV
	 L2BFbzREAhIRuxebg1BUJ1UqNjoTNxqe3nfSdwpCitdhZDIhZxsyRAFyiPmJwUKjD2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nog+wx3p;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=tjB0fPX3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9058606A32C
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9058606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nog+wx3p;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=tjB0fPX3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085788; x=1824621788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+7s5MMVZSbGMiHNZcZ8CCqQX2NjdP4oeOi2OQ3qGv4w=;
  b=nog+wx3psEkm8lqEBCIJ+efXLqySNqZwlpw0Hy5ICqdF6mfl2Nqm5CXq
   ZRVDCb3EqA/9nYGkeOZ0btMlkH6nr/ElmK3b8HTmGXwGj9uTnYZv2Sycz
   w3j8NwrgBgqQWMUc031n675YbCr1ZzX6VUtb0oUK8AYLITyrtyY+0KhGV
   Li3Ievfnq8s6E3Q2N7cZyb1rzkxuyFb/cbB7kWvKsOxgvhuYLVnz339yb
   q2iJGqJqrPqY6q2/LFqNp4h5QrhLY/fp9tpPKOaQp0Lj9SD35TONkAK0k
   +GZJhJ9Ykf0nUtTHyYJBFfmuW5Wh9WM0CGOO0xTslaxFgrBVdiC+ZiOXy
   w==;
X-CSE-ConnectionGUID: gmKbvcqzQQifWSfzCb1a6A==
X-CSE-MsgGUID: uuvWYTnxQo6qpwoqTrHxrQ==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863277"
Received: from mail-westus3azon11011055.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.55])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HR3XSxv/Z/8zdycjG1k8M3e1Kg0jrDM9zAcfT84r5Nk/Ki6yWDQeW7piA0BZwwsA7XOL8IzoUbC30P5DOkNLmtVRrs1RwzKxgh0+g719ri9MaC6j+laFvoQJIb51H49NDXKqudWG5JeA91ShAocgIPhrXZTd3xTzb6RmCDxft/Y+g9tvw3lK3fuivqVVUNTekmf8pHW1pP0ibapW6qLDrvxOIEBPxWpdPITf94Udj/OplKWK6kgF/Rw6yE+9ILpCZA4X8uw/HW31aOCq7S3b6tIwR7PZ6aOR8XGj371ZZUlEZ9QzQltJR2b96B4czu4k3kdklyEwE/ucLjAv51tuCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBjPXTiDTjcTursfe7F1MvtPe7WGh98YIAcvDu09P6U=;
 b=MVGC7MvugTVNy3MmBjNEl2S48HhvQRf8FJuIQEl6zUph0fmKptVI7fJKSqi30ZjZEMjMHsVswzTgaLeSK2L+VBaIu4JoVNYEpcKyJowT7zFseLZ87VhtJEhoSLwKPVglzSMB6BDO1pD65TloWLR8mXUdN4ALrWl7QYXgT5cXd45bVplIwh7trnuThnusf0v+bKkub5JFMeQcjvmhGQ+gZMk277m78Ag55XVGfQr5CVd43werjsCStqrXrgAedg5lt715/w6Lg5oQnnqNC2uQcbvxGFSVnlAR+qJ1coBuSFXqsNhAsAXD3EFIX67nvkuIldKkSw6Z7b1y+Fpavcdj1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBjPXTiDTjcTursfe7F1MvtPe7WGh98YIAcvDu09P6U=;
 b=tjB0fPX3Qv+3miUutsBITgBGoee+i4TleRlyyqM0T0FTabfY3b4DRvhD2/lukzrfUq1y6pSM8WqRPwf98LAQqA1KeftncvNPm0HCA4dbkVuA6R+mZ0SsiosUV3wKBRIvuJXAwU0MxoUCBMVE9HG1z94+OLU0JV3FOumk8dWfFy4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:06 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:06 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 17/25] btrfs: zoned: factor out resetting a block group in place
Date: Tue, 27 Oct 2026 08:22:23 +0100
Message-ID: <20261027072232.419318-18-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: d64626d4-51de-4d31-db0f-08df33fb254c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	1SfDLFMc2O3Lp2ZyCD9lfFRCD8Ddo47rcXsnN4cNIneBMN8vsEuzA3U3Qz29x5D9BxRA3y14CAiwRv0o/5BFnldxwoJUIBtd/XXJVFouxgB4BxD2vs1P2keidmqdo45ismXEv2QMNt/IhGX4Wp2E7GoA0FxjzqV6CmEqdxJjljDP9BOxdvIlSt9Oy7CF9Pu8E7X+FfYvczZRdKy5DTjmSQo1hkhwuJNmi0mxashbb178US1L7GP2eTWasQoXL+HzygwIHQgYzOub8Lg/QFGCJELbE3IXY56pWZNT+l9EPeKGmPP3kQlhUj/i22I+Toi2rRX1zKtxuJ+6+0u5MMPRDbZHVifv8EBfoU48Npwoz8Pa63cDYUGbMfGy8G/2vLbtLSAWyv/xuPUAoYvYsG8jpExSPj7rdXEdtImlq+6htlYbUKJW5aSsY7cVQ+xE9aMBvvzeRieYPYxsRxuneER74V9aH7MS8oPG68Ay6D/HCwjmMxproR89tWfcKaXKy9/79OI4nM7XXkaEECVhkX6JSSU+7WPQVAza+rfTCaq8+0n6CZGJhQ6+NwZZlyE0mSso2z0Kjmy9XTtMNgtbSIAS43akIjSmOvq3hga8Bk0DPCFsZcpBKmhC1zrD38LchLKpU88zo5kwHN53akLJPJj8r9aaZ/mNBw3Az5WsilvNaNM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7OHhKtRmdV3fIDD2G7H2VvlGDHK+SD3LhX+w4Jjsx6gia9nb8LP52PU0uHow?=
 =?us-ascii?Q?94UKBpXrJlYnnA1iH02U8dO6YOhZplE7pI881GlgHaH/jGWofylHjPoz4xTw?=
 =?us-ascii?Q?DnyVQudqcl85Car75/+1SKlIqjz/PFdSY9gkCzBRVClmJ9PcMi5rcD1LbmHO?=
 =?us-ascii?Q?KApAXTYvODdMLGDPNB+yfgS160KP/+Dp6oKjqbN29MSlv4xVv5/epYKsuFIH?=
 =?us-ascii?Q?qwB7OivxoDN72UU4ZqISyK8l4f1sBS/35jdY4hJMhAvKIfexD9as4cCo27X1?=
 =?us-ascii?Q?d9Wisn0+ANt3BF1kQF0a1ZYVTh37qM7NpXiIt2+psalZsDf0RIo3tRRObwc+?=
 =?us-ascii?Q?diDfYBR8wEwHJjjAGRsrD7Ud1ZBUpFii+BHfpgenPhvLPyiLLIfc/46iumPd?=
 =?us-ascii?Q?kFCh+8eUtf0bIHcD6OnRwemJjhpd8IMhV4hp9RMYA6PzdhAFRUhDpPsUnXmg?=
 =?us-ascii?Q?gJfVXCLZEWxtUXKtpeYdliFiDapbu+7xPQHzJGUx0+Jebgx3ldsQKCnJSz2u?=
 =?us-ascii?Q?V+JDvS1MmopPFBVcfeJXw9l6RbE9/rVTn+b0SCZOSZDdOvz8eSU+3qNT/r6N?=
 =?us-ascii?Q?GxJIzXEYlQ036Cj/jHzOAT/txOJqn2NdY59Wd2615Fr8hkMsEAZKS3EYZmGL?=
 =?us-ascii?Q?4eyo0vAl/8GyEE9/rGGlOnFVxmg4/UKfjzprkmzgnqd9SIVABjVws4t/nDWh?=
 =?us-ascii?Q?2VeX3pnhxMhfu6s4RVWkKjgvBy1R+wL7P2CSBYH9vD8NETjLYqv1lvnqa8/P?=
 =?us-ascii?Q?iEfbQdo2tkTtTbcuJeTeMn5YEO7huZFvKIhxGhqeUJTaxEUoqxjTtQ2qDbAi?=
 =?us-ascii?Q?/S49WeVvFnmQdMMTfX25LkJiFocAs+2Tk9buvFr7pfcFzuJ66ptsFqsNf/Dj?=
 =?us-ascii?Q?j/l+57TOToPgQiVOe3JHcJUCLGQqAPDr5CyhIoL6+N3JfjNo+DgG0prGw4Tt?=
 =?us-ascii?Q?+EY4rPopxNQb5SV7t9/mTIsxBclEVGsqQJ/ErUc0lMJ3uHHDFTYuxwSUOiA5?=
 =?us-ascii?Q?YYroT3hJsQjzUVHnahtB4Dc32rmV2nWvnm1xLg4BqUoOFJko41jBrrhSBO4f?=
 =?us-ascii?Q?EL5k3BKQmMP+yg9d7QiOIN7LSYq+F/Otatv2xNF3UA14vmIAKyZpva83JcYf?=
 =?us-ascii?Q?t+ZAEjHLlZHOGKzTYVBIooonvx4PI3i1J5QkfSzC5F5S1nM+ppj7rwHWAB9H?=
 =?us-ascii?Q?ra+9Gow5hVaSJQUSWTeYK/FkzlBAvwOILxayOn/sVnP1MxmrD4H0RrJGjR6f?=
 =?us-ascii?Q?gMlAZk8zJAq8UoFBI4GgOYaeGc7WmAOmP3HjRgvKJcYZr1FrdG5hl/LC4XEr?=
 =?us-ascii?Q?zK/gy/B7pqBrFKBja7kg0wy9UbAQr3TmZtM3ZbiqulLgtK6xzjUm05TPxSiQ?=
 =?us-ascii?Q?gIW5/KuBoHmwJK3RSXMDTLB1CM79W1nVQF8tM18PcGh3+6NdVbfzhi7wBI8G?=
 =?us-ascii?Q?ovNeJvzh91PKpow0huwTf00w5nCfP4lzXb55XLB+dkzP30k4GA3T4ezCxJ9R?=
 =?us-ascii?Q?Z1l15J+mK9+MLzdIa8OqlRmVFdiIOpkDcfTTv/QJp8G56Mmd/RP8rcIH9PYA?=
 =?us-ascii?Q?9j8g1/EhUoyFS3G0di3MyKolLN3swoFZ7NsEafJqyq4p83/3vdZaCo/LMRzp?=
 =?us-ascii?Q?A0qBBk3M4mB+iE299bKq9YT38m7ML6LVr0UhPiUS/jU6fDIVEwA1YLHg4G7J?=
 =?us-ascii?Q?GUvZm7U7N27Yx7j+62TUs4ec9TOJCztDTfLO3853YHJNyi67LjB01MoPYj3t?=
 =?us-ascii?Q?e8s7TeLOoGes2IvdOMJ5Krt1NKf2g5unGUnIIj3TbjhZ5M9eL/fflKbCIuwL?=
X-MS-Exchange-AntiSpam-MessageData-1: 7fKL2JUUlskBCuJTfpoKfOYHGBx73HvCUzc=
X-Exchange-RoutingPolicyChecked:
	mgVMdl5UU4u8b3fbcmrWy4fW6YumnX3k0ekpM3O8raK3x9Jn85f611YcHZxkeDFKx7dqnA84g9ra+d34Qk4J9mEaslSaNxGPbgDgFzXJtV8D7i4hjt6/uJzDFll3mSzka7JJmpbm6SXOkeH1EK03p7ptgwY0wsJbKHsqWqCUlZrbj5ogykrqXZmFa7kb4OF7zLRRi0ZsyKyHc329OTFlXKg5dNeD6PqIvH2H57nzoFQYc+ElczFzkNX4rFUz9j3dgm6oD15pzkbP6axUFqOq+4L2mimuniz/rUIuH9DSlYj9g0aiElzYX0Zr3Yb8Z4hDmEXFDLZ9FO7Fplgmq0M9HA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MOMDJwMX40+6+x/m+axp0603C477fLwXZUbydhw6AtMm9rP4l0/qtrEicKKyKwN5ZYUX7ih0tk9aEZeHBKeVyWKRgLzp+a2yne4FN4MvnhTLzIc7w1bjT9CJe9hUWIw1qgHMXn27dhjGASHjTa5n32RuKCa9GGZHv87kvC5HVDrFpmurtGI0uNIOE5r1OLHS7iiTOuOBL8DrjmLgk3awym/lsvYAYmM+z3ncxDHorKp2ejw+ClrtR/vyutckrPEfPD9bH+ARCSJajJD2qKV/blBRvQSwWs9vajZ8WOz9qbNHKk/v88Qp5xswte4rvCzmYN69kQOcxJbe83Tb+Lmxe2n78EHcOt6x4+mcwUoTU/SBIs2E/FJqkrWYTBvNIlPvp2taDLwciZSYynzWz/AEdnqPHXPrrpRvH0suy/S0558q4zOreMO5dwSlQZu74FE2gfSlNVOCjGUTkL+zfBm0e6mC5NQg9/7NqPnO9WGeOSH/2QL/pAZIlkP7IXm8/28N1bMkEzoifK71rG1u8dW//YLFPFrRwDtK69mTixPc5IO4dBhk9Wbc4NdYXXGEIY+aGCtQzgQV7XJbgHNgmd097DI8unm3dPnyr2Ei5DIy+S6rRFllZa7QqMkvgH1Pg8A8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64626d4-51de-4d31-db0f-08df33fb254c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:06.6202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +uM7S20nJYxJXW5zO0iArGauNxbCyoZBBzKeEX+zKNyxnXMNXc1lv3LPoiDaKIqQHiGMKoa3vQSgVoixjqntu+fihon2i7WnpMce5TB2jRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

Move the code that resets the zones of an unused block group and returns
its space to the space_info out of btrfs_reset_unused_block_groups() into
a helper, so it can be reused.

No functional change.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 128 +++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 242d90c176cc..8a94f7cfa1ff 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2905,6 +2905,72 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	struct btrfs_chunk_map *map;
+
+	*reclaimed = 0;
+
+	down_read(&fs_info->dev_replace.rwsem);
+	map = bg->physical_map;
+	for (int i = 0; i < map->num_stripes; i++) {
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
+		unsigned int nofs_flags;
+		int ret;
+
+		nofs_flags = memalloc_nofs_save();
+		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
+				       stripe->physical >> SECTOR_SHIFT,
+				       zone_size_sectors);
+		memalloc_nofs_restore(nofs_flags);
+
+		if (ret) {
+			up_read(&fs_info->dev_replace.rwsem);
+			return ret;
+		}
+	}
+	up_read(&fs_info->dev_replace.rwsem);
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	ASSERT(!btrfs_is_block_group_used(bg));
+	if (bg->ro) {
+		spin_unlock(&bg->lock);
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+	*reclaimed = bg->alloc_offset;
+	bg->zone_unusable = bg->length - bg->zone_capacity;
+	bg->alloc_offset = 0;
+	/*
+	 * The zone was just reset to empty, so alloc_offset went back to
+	 * the start of the zone. For metadata/system block groups the
+	 * write pointer must follow it back to the start of the zone;
+	 * otherwise it stays stale at the previous (finished) zone end,
+	 * and metadata written into the reused zone would sit behind the
+	 * write pointer, could never be written out in sequential order,
+	 * and would be stranded (pinning its folio) until unmount.
+	 */
+	if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+		bg->meta_write_pointer = bg->start;
+	/*
+	 * This holds because we currently reset fully used then freed
+	 * block group.
+	 */
+	ASSERT(*reclaimed == bg->zone_capacity,
+	       "reclaimed=%llu bg->zone_capacity=%llu", *reclaimed, bg->zone_capacity);
+	bg->free_space_ctl->free_space += *reclaimed;
+	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
+	spin_unlock(&bg->lock);
+	btrfs_return_free_space(space_info, *reclaimed);
+	spin_unlock(&space_info->lock);
+
+	return 0;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
@@ -3241,7 +3307,6 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
-	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
 	LIST_HEAD(retry_list);
 	int ret = 0;
 
@@ -3249,7 +3314,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		return 0;
 
 	while (num_bytes > 0) {
-		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg = NULL;
 		bool found = false;
 		u64 reclaimed = 0;
@@ -3291,65 +3355,9 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		/*
-		 * Since the block group is fully zone_unusable and we cannot
-		 * allocate from this block group anymore, we don't need to set
-		 * this block group read-only.
-		 */
-
-		down_read(&fs_info->dev_replace.rwsem);
-		map = bg->physical_map;
-		for (int i = 0; i < map->num_stripes; i++) {
-			struct btrfs_io_stripe *stripe = &map->stripes[i];
-			unsigned int nofs_flags;
-
-			nofs_flags = memalloc_nofs_save();
-			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
-					       stripe->physical >> SECTOR_SHIFT,
-					       zone_size_sectors);
-			memalloc_nofs_restore(nofs_flags);
-
-			if (ret) {
-				up_read(&fs_info->dev_replace.rwsem);
-				goto requeue;
-			}
-		}
-		up_read(&fs_info->dev_replace.rwsem);
-
-		spin_lock(&space_info->lock);
-		spin_lock(&bg->lock);
-		ASSERT(!btrfs_is_block_group_used(bg));
-		if (bg->ro) {
-			spin_unlock(&bg->lock);
-			spin_unlock(&space_info->lock);
+		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		if (ret || !reclaimed)
 			goto requeue;
-		}
-
-		reclaimed = bg->alloc_offset;
-		bg->zone_unusable = bg->length - bg->zone_capacity;
-		bg->alloc_offset = 0;
-		/*
-		 * The zone was just reset to empty, so alloc_offset went back to
-		 * the start of the zone. For metadata/system block groups the
-		 * write pointer must follow it back to the start of the zone;
-		 * otherwise it stays stale at the previous (finished) zone end,
-		 * and metadata written into the reused zone would sit behind the
-		 * write pointer, could never be written out in sequential order,
-		 * and would be stranded (pinning its folio) until unmount.
-		 */
-		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
-			bg->meta_write_pointer = bg->start;
-		/*
-		 * This holds because we currently reset fully used then freed
-		 * block group.
-		 */
-		ASSERT(reclaimed == bg->zone_capacity,
-		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
-		bg->free_space_ctl->free_space += reclaimed;
-		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
-		spin_unlock(&bg->lock);
-		btrfs_return_free_space(space_info, reclaimed);
-		spin_unlock(&space_info->lock);
 
 		btrfs_put_block_group(bg);
 
-- 
2.56.0

