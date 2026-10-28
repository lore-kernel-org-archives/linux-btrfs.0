Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211696;
	b=rz6b0eBi3/0yvpRGeATRsj0+ryrZwjyxhgqXwqLSI+cVyfth9tsKAh9BIEdQjJN78fi+
	 +WpA1UBZTQVGgMw55kkkklRMRuc0z3ggtLYCee1EP5ILt+Gr/ptDh7Tn2aCXGEMvXTIWB
	 9xVgZJEZXXOQxf8rIB7o+6mTzhG6yHI6Urmpe1yPa4YnsJG39NFH7D/Q/2lIX7GGOw3/t
	 oFZMa/zz7u0PgJfzSd8dHkjh4tGMLlagOPbpalkLhK5mJxpl16k8G5mkaMgUZYeGZY0X9
	 VjfHI/bQcRJ+DFmrg/993esnx3ZJwOiToJHK4yuXgeokg7JCe8OlybdcYgabJTQJsdw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211696;
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
	bh=MY9h/B1EblA7cVlSOiHaqrEBDcjzZPXCEd8BMNWUFh8=;
	b=hW0kBgsx+6MAKa1+ZYNcLudFrLcHb7Z/ObWmSjTbJgwzbMs1ZdZStpyMhGcqorNDDVkQ
	 jURM+88NyfdWKnO86famVQjKU9xVcgUwtNaVJVg0ERJZ6i5l8nRZmv+2KTKltm9nQ7ReW
	 xQCUslAhEf9icb62htEIG8TlzbyJVWbM1M28myK9uVEoAY8BbcqkwAZorK0FhrwFmgHxO
	 zChSHdJEReVBH59D7jrgh9FjUKhf0LS6AFmYzixBIgyvxNJKNDPhMiDH5PPwe9cjXFJH8
	 xTO7ov7xzvAXay3TUAFLuMU8HOPX6/eyRPiosnAWYs5BCXTAtaD0tSwXyDmKkfMv9VA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rYcePl6y;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=KLzbuNUB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3AC606A32A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E3AC606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rYcePl6y;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=KLzbuNUB
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211696; x=1824747696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cdF+or9D2Cw5oU2b6wIIxZi0b8H2AfVYdiQrM07aB4k=;
  b=rYcePl6yQt8b3X9ybbUtjTRZDs7bK1WV7FARC2SeThblrUgX62uD+Lba
   qRHSKqSSlJnzDUau5jumKoXCmk1snplUmCczCU3M1wCEwP2rD2Ei3p/AD
   66tjpXBMb+uZlKkxiJfFrWc7Yr8zUg2o5VZ8ILFbJSqJ/REuRIIqKuvUi
   0aUMwpL325QRbrlMAstkuv6IuboVGYPCl/rXScFItE206mmgnpWXZz5Tg
   0PUVOF3AjIhtXh9Mxsui5PJycaYIBhXnoTGQaBMcisXSkMgAzKlHtCqcF
   jOieKTzcgNL8kL1q9J5WnY9AoYMRNOmk5CxepVvW5j8/x71iIIOx5zUQT
   Q==;
X-CSE-ConnectionGUID: 1qZcqtSGTz2rYtS8/4kZmQ==
X-CSE-MsgGUID: d0a1jgAiTwazge+tCawiZw==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159234662"
Received: from mail-westcentralusazon11013018.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WW7azCG0h/HiY1N7OaFFuZhMyeDZyyNZN+lTh+mNCykWtZdYV00F7D4207TjsRosDAEG6zjSN9g20z7MybzHaUlZ5ViuuDNiFUPWrifUUtyFk/KoqW75/sHnd3g4PACSXjJ5XGbOiVHQqJrtUARW96NXa0jA7ceeLAreHVyFSl5MPsESxnZVs/KmJFGb1rkOkaAxKWiTjP/i9yk3BbZJGPKVq/3rgPtJ0K3ADK4O3nMh/PgfDXO/KFrtaKreSkmjxVXttTYQFKbbKO7G8WWyixEP8RWLVDw9jTQTZZkyTP4PAgGEqSz62JJLSRxeOURgH5yF2yfMggbEFXSoPNlxhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MY9h/B1EblA7cVlSOiHaqrEBDcjzZPXCEd8BMNWUFh8=;
 b=o1Z41yNtIEXNiYZ1pzw0/clWAQPbD7rTvoPKmzasemaZ9SJNczpWEJChdb+re6EWYSHLHm1twpUQfg3fnEPQlD5sCOkhAlG8nswmOCsOsBSmsx/x38z8PigWhkUwp4uN3hLVZzwOdyyykWO6rUFnQGLq7oK146yGcOew95yb5s6TXYLYS9sKwkO6wMvNkXBJsYSUreoaWnS79pdpkNJjs2CvqzNDEfk6721fM4Yju2tvRYU0e5R92DuAV7uq+f7O0Ejo61RLQ9dRrX5QMhUZIaaS/kEf0mxgjYHKgw4ToAg0I9/fOj30VBPWtxDGkQ9d8vtiOM8oitj5cngx3OAnMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MY9h/B1EblA7cVlSOiHaqrEBDcjzZPXCEd8BMNWUFh8=;
 b=KLzbuNUBdgRnu2D6RWeiCQmjxVRi5lonRcwqtJRDkZ5E8nBdzcXn1toQhIZCSsszB0bFyrM/pfgwaNFJi2bZBCjyj5zmWCryLnqI8oCdFaybpFDg/V4MunMbZJmU+hLSzh6o0ENLhej7KNtW219hAz3CWcP1quRJe9x5eNaF9CQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB8753.namprd04.prod.outlook.com (2603:10b6:510:234::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:31 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 02/25] btrfs: zoned: don't activate conventional zones of mixed block groups
Date: Wed, 28 Oct 2026 19:20:48 +0100
Message-ID: <20261028182111.160492-3-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH7PR04MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: 96be8694-7158-4184-df58-08df35204a34
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|10070799003|376014|19092799006|261028144727099003|11063799006|56012099006|261009223027099003|261026140227099003|261021121427099003|261021123027099003|261022075727099003|10067099003|261022105027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	31tQC5Jv11myWPrqbnaMUe9nmlwcf5fNEg/t9tJwCdfR0irqY463IuhasgvGOaXL7pDFbXwUjMCjbQcmWRuLsIzEB1FNDgDonkqxOiw8O1SFjgK8IwBMllMNmISMbZo8km+7O8+dN+3Ml73oga2HP344WB/UlQEfzMfoNq3oyDfu0bwEOTD5bYuxsPehFnoK3ldGAvlyD8WBi89CKsmPWjRWDeE9HOjRCRpjvfdAHvUEyA9VGKhbF6E+tZXxI+5LxRQ2R2ISyfyCc+4jH5PouX0v9p5syVBz+068CCieUOCbbWIl3Jrc3VFgPaC3pei+5sq6MrH1P7/i7xj6u8ZUQCh/a/pfZN3FU0vUaOkQAuRBavTmxTYgdK7WWGfiXJBG+5yfwI7e+hR9POnu+foBoxlDVe7yKlO1pcRturX8byoGvTmGquDNqW+xAAAP+ex9Rc/3/9xOza20cs/4HksqekwP5H4Cf9caob5bQIe4Yo9EIVXTR5x1SHyPs6h2kvDoJ2EUIRyakKx0thMYUcUpkbDbpKzECk2dAx5iLGgCoNfdtyePKF76P+64/zqURPGOjIz4uL58kyz/8CnM4j/Q7P74pfpTo9aJhswGLmBxVFXiT1DEH7JFDmgU/p4m3Z+K/UGq2xNhiAnquGCy/ktnIQrxKow1lsgmJ2U+VJb+g0g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(10070799003)(376014)(19092799006)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026140227099003)(261021121427099003)(261021123027099003)(261022075727099003)(10067099003)(261022105027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bY1SHOOJQhY2nca7xeffL+DhN8YJezHyd90aHtoCsmI7pEtYLShysFBXvbIV?=
 =?us-ascii?Q?0Oct0d9+yu52XV/LwOk7z2LQMqTisZe3ZcFILBvotC/weGgGBBvnZGvvdnwz?=
 =?us-ascii?Q?jF2OgundAKigOZkMWCex7qDMpV970oH7AkUEbFb1jKTilVp/isyGMSqZeulI?=
 =?us-ascii?Q?HId1WdsPnWVKaEfGUJQ/FfwTxvJ99dWDPfUuCS/0xKHBHxwW8f6GhnxO1t2G?=
 =?us-ascii?Q?ckmY3TjkChY2kUJ42qzbInOnV5JRWDhN6jf9n/NuSVYeZKRNgreOBzGzqWgD?=
 =?us-ascii?Q?cs83bhX+L+Sbm5hpNljvFrQ2mbkZm+dnm/muHQzrRpCfqqJ2Ef3DMH71CT6/?=
 =?us-ascii?Q?jmeBKCWdPJjs7fnyBa+0Hx6VitKI7QqJqd5kI7vdmHZc/1VKrdctUllgfHWW?=
 =?us-ascii?Q?z46PRCqDVBlCbQg4WXj1UEjyAMpW6Kuu3zLF0r053EaF8Y1Mfpo1k8xFO01s?=
 =?us-ascii?Q?ACWvuxateU2DGuIXuYAhCHucb7+OnYIFCYTxSMvVe6Lgn2EqCD24rF3hp8ZA?=
 =?us-ascii?Q?y4+dmlcH7FVLmmFvKlHtXz6YnSq3+sP2iq5S7oeAP00n6zLP1Jq51urbjmWN?=
 =?us-ascii?Q?Jnhu4k3RBGV5yY499uUUD5NuKFo3yhBF8VtQpVHaGyiR+CpDj6ynJ3U6DZAo?=
 =?us-ascii?Q?0Oo+25Ju+JZzX5AYlrt86g/HbMsehmniOW9B36X2fyD81zB0fT7zGPq2H/jP?=
 =?us-ascii?Q?MfiIuqGUW/wG5ls/fvlr7nVx+bMrSULkpbvYx/2PaGmBMiifK+n/X+aL0tV5?=
 =?us-ascii?Q?Xld+BbS3qv+gh5I1tXBs0KzHK+BkmG91xvwyEaB4nwJ8xsuE7KcGYg4YWfd6?=
 =?us-ascii?Q?3vkysR+luNOALmQOXFGrF6xLl1nWY5cPDh/g4H7UZQ5JfC3QOghWu8AILjGl?=
 =?us-ascii?Q?rYWboEs7epsyjRPFnhCz7mZ8uMyk+tk6FUluOBd/I9oavuj9MNqrKvVBiVGw?=
 =?us-ascii?Q?KfNFU6gkwDPOiLQ+1+rW8w7ZizdQLJNJrRAxJCFaoGQL73Ssd5YpdkikrjGd?=
 =?us-ascii?Q?pcDjWIgLTm/jCCSRkKu1MvAPM8kuNWCDOCsiPqvGID9MVqTKDsmJoP0child?=
 =?us-ascii?Q?U2AWRFR8SPawgLVeT+EsRQ5MpldIyl3Lp8BGdGTp9yXcg44dMXji8PnfcNbF?=
 =?us-ascii?Q?7kIXzDHb/wT07lBNRJVsB0SnoO/bH4u9FsS0KGDI2CbgU9CSzKncGnXS6Fiy?=
 =?us-ascii?Q?L024ufJcZ4lE2G/2cgy9Wy81IVB55olsRSD3O+aLHCuJRZsUGKMLrCcZNT4m?=
 =?us-ascii?Q?iyvY0XJy5Yrc84ibpMy7uvLC1P+xWq3Yy1jVaMQngcq/Br+fmt+IDOo8/NGv?=
 =?us-ascii?Q?g6x5N1/nSL8C29Ffo32SZSorcSN+GD0IPf3dNtLCap1D/+Dv2JWBGYAn4uQi?=
 =?us-ascii?Q?Vn0/1g/nu0q6PXIJ3aZ36vFMQ6yN0mzkm7kJXnF6mEhGCvjanTyqChGuRmeK?=
 =?us-ascii?Q?N2WlwK6EYbSu7X4OMecz+VUfT4uHe3TTzjidMYtvJJ2LKWqmn5nRckVNiNWG?=
 =?us-ascii?Q?Htp4Cbi/Hm/vQHVzo7I74EKb6s7VePqI8Ql2omB2uL/Gfj/FMqCkSaE5Jwnb?=
 =?us-ascii?Q?eQjLkteFWhqbnT6lJIbv15+G9HB4sPDAGC33oavY58fVI8lqmM2iH3ju07wV?=
 =?us-ascii?Q?wcfFRADmR4GBJNzADzecEX5aOTkFeTyB8pu5hoyrd9PgyXxI3WpfT0w48Csb?=
 =?us-ascii?Q?ZHrG/Sdrb8BmS+k4uZWvDTddVQxc97QWYFIaw6Scl9cTUpL54Syo5Y4pOyfj?=
 =?us-ascii?Q?sf5LIfG10I4x3SzH9uGhwfkcICKdHvnnXdjOVHg6ASXLqwF3scjc7D4ffiue?=
X-MS-Exchange-AntiSpam-MessageData-1: 8Pyr10rHrc4DnswjwjZ5pH5WXqwe33KUtGI=
X-Exchange-RoutingPolicyChecked:
	gyOKpyALskIs8D20l4JM7oNGlshWy8pxbSqjFGx6JsXP/+SQ5VvgD6lnKWB/LAEpeL/zv6xu4hEHH5u0/b2ns+s76P0z+oEltLBVbnzSABedroxfqi9lZ3C2uy+mvYXy4xg5E6puCQunZywhd3/Erm9OxQHjGUYb9J7GYT437Qo63/JFYtGQa26Et5UXDfm+m1+mNztM6IVfHn2LpE7Q8J+2iTOhxYR0gE2s0fttrxUn70QsolxAX3o/RGLNk9rO1NTTYdRYLvkUC03RNmiK1hGZlm6yACiCdL3DZ0qSxTKU/6Zm6euPy8TLCLe4Ke895tUTFW7rOL/dtDM8JUNBpw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ypj794oKSYhzZ8bs3N/Wg2uV8sTSC3jlrdSocofVraMwo3xJT/vq+jGULH78yc2lu3IKX4UgMrmi/fkd+WQbbd/ERK7ZBlzm7ALXEaGe9GQDnhGczXLeX2UTTtYDJfCAlw3dvjmIXbtM47uyzRSN3wOfgPgZoSed9xTb2Pn0mh4N9pisPcC6oWk5UdnV2LjELgzIJvtepik/yLPLQZU0vXDtni7W/YqiyfFh/KFd4gZvWENFVp9rXtm+dowYkhK7H8H4PYQYPi98uZTDKO0IIYF/IedRopFcAxz4HymQPiQeNIsuSytiW8ss59tsovSO/+dp4zwxB5un3xO8wRfl8ptdv9sBEaC/vFnOzsQChnL2Qo01lfzPSH0ehpy+uSQ4fJMeTlF7ig0p4CmfIpoDf+l2DoIIHx1yjq/eES1ZDvZFpCtYy8R9RulTOtmq0agKTqbhC9Pr6BFbu0teAyVR+82bKz118l+HhpTY/mvauB6K5oufyNRVjHmXevNTFLTy0zOJsTQ/JWd2wXChY3YbwmGW5PUbPqzJIvklOmdIAMNBiiTaJqz5s/Zzuw2LJbGzMg4gvXxAztyS1SJft2Qw24GzPN0S+zOsyFDtBMdLJFZkyoMstT9Q0PxTZFmG6GuJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96be8694-7158-4184-df58-08df35204a34
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:31.1456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VhMQxpvKjG6qS9ZawkSK6Z9w4od8jJYNufRSb5jo6pnOTTEPKvjDEcFv2r9xtME/ucEaB/2rhFdbfN3zcJlJ04T61sMzNTf8jo4bWDR7ZGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8753

Conventional zones never consume an active zone resource, but they are
accounted as such: btrfs_zone_activate(), call_zone_finish() and
btrfs_check_active_zone_reservation() take and return active zones and
reservations for every stripe, and the DUP/RAID1 loaders activate a mixed
block group on an activeness mismatch between a conventional and an
active sequential stripe.

Skip conventional stripes in all of these, and let the conventional zones
of a mixed block group be active if any of its sequential zones is.

A fully conventional data block group stays on zone_active_bgs but frees
no active zone when finished, so btrfs_zone_finish_one_bg() must not pick
it, otherwise the caller allocates a chunk that can't be activated.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/tests/zoned-tests.c |  16 +++++
 fs/btrfs/zoned.c             | 125 ++++++++++++++++++++---------------
 2 files changed, 86 insertions(+), 55 deletions(-)

diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
index 2bc3b14baa41..e11d6d01f505 100644
--- a/fs/btrfs/tests/zoned-tests.c
+++ b/fs/btrfs/tests/zoned-tests.c
@@ -44,6 +44,7 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 	struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) = NULL;
 	struct zone_info AUTO_KFREE(zone_info);
 	unsigned long AUTO_KFREE(active);
+	unsigned int nr_active, nr_missing = 0;
 	int ret;
 
 	bg = btrfs_alloc_dummy_block_group(fs_info, test->bg_length);
@@ -80,7 +81,10 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 		zone_info[i].capacity = ZONE_SIZE;
 		if (zone_info[i].alloc_offset && zone_info[i].alloc_offset < ZONE_SIZE)
 			__set_bit(i, active);
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			nr_missing++;
 	}
+	nr_active = bitmap_weight(active, test->num_stripes);
 	if (test->degraded)
 		btrfs_set_opt(fs_info->mount_opt, DEGRADED);
 	else
@@ -101,6 +105,18 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
+	if ((ret || nr_active + nr_missing != test->num_stripes) &&
+	    test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
+		test_err("block group marked active before all stripes were checked");
+		return -EINVAL;
+	}
+
+	if (!ret && nr_active && nr_active + nr_missing == test->num_stripes &&
+	    !test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
+		test_err("block group with all present stripes active not marked active");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index b003f0bc778b..c3bbe22c8850 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1428,8 +1428,7 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 }
 
 static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
-					 struct zone_info *info,
-					 unsigned long *active)
+					 struct zone_info *info)
 {
 	if (unlikely(info->alloc_offset == WP_MISSING_DEV)) {
 		btrfs_err(bg->fs_info,
@@ -1440,15 +1439,12 @@ static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
 
 	bg->alloc_offset = info->alloc_offset;
 	bg->zone_capacity = info->capacity;
-	if (test_bit(0, active))
-		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
 	return 0;
 }
 
 static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 				      struct btrfs_chunk_map *map,
 				      struct zone_info *zone_info,
-				      unsigned long *active,
 				      u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1499,13 +1495,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 		return -EIO;
 	}
 
-	if (test_bit(0, active) != test_bit(1, active)) {
-		if (unlikely(!btrfs_zone_activate(bg)))
-			return -EIO;
-	} else if (test_bit(0, active)) {
-		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-	}
-
 	bg->alloc_offset = zone_info[0].alloc_offset;
 	return 0;
 }
@@ -1513,7 +1502,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1557,15 +1545,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 				  btrfs_bg_type_to_raid_name(map->type));
 			return -EIO;
 		}
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_test_opt(fs_info, DEGRADED) &&
-				     !btrfs_zone_activate(bg))) {
-				return -EIO;
-			}
-		} else {
-			if (test_bit(0, active))
-				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
 	}
 
 	if (zone_info[0].alloc_offset != WP_MISSING_DEV)
@@ -1579,7 +1558,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1671,13 +1649,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		if (!IS_ALIGNED(zone_info[i].alloc_offset, stripe_len))
 			has_partial = true;
 
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_zone_activate(bg)))
-				return -EIO;
-		} else {
-			if (test_bit(0, active))
-				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
 		bg->zone_capacity += zone_info[i].capacity;
 		bg->alloc_offset += zone_info[i].alloc_offset;
 	}
@@ -1701,7 +1672,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 					 struct btrfs_chunk_map *map,
 					 struct zone_info *zone_info,
-					 unsigned long *active,
 					 u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1823,13 +1793,6 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
 			zone_info[i].alloc_offset = raid0_allocs[idx];
 
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_zone_activate(bg)))
-				return -EIO;
-		} else if (test_bit(0, active)) {
-			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
-
 		if ((i % map->sub_stripes) == 0) {
 			bg->zone_capacity += zone_info[i].capacity;
 			bg->alloc_offset += zone_info[i].alloc_offset;
@@ -1860,27 +1823,35 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 					unsigned long *active, u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	const unsigned int nr_active = bitmap_weight(active, map->num_stripes);
+	unsigned int nr_missing = 0;
 	u64 profile;
 	int ret;
 
+	/* Missing stripes are never active, ignore them when activating. */
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			nr_missing++;
+	}
+
 	profile = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
 	switch (profile) {
 	case 0: /* single */
-		ret = btrfs_load_block_group_single(bg, &zone_info[0], active);
+		ret = btrfs_load_block_group_single(bg, &zone_info[0]);
 		break;
 	case BTRFS_BLOCK_GROUP_DUP:
-		ret = btrfs_load_block_group_dup(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_dup(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID1:
 	case BTRFS_BLOCK_GROUP_RAID1C3:
 	case BTRFS_BLOCK_GROUP_RAID1C4:
-		ret = btrfs_load_block_group_raid1(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid1(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID0:
-		ret = btrfs_load_block_group_raid0(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid0(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID10:
-		ret = btrfs_load_block_group_raid10(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid10(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID5:
 	case BTRFS_BLOCK_GROUP_RAID6:
@@ -1890,6 +1861,16 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 		return -EINVAL;
 	}
 
+	if (!ret && nr_active) {
+		if (nr_active + nr_missing == map->num_stripes) {
+			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+		} else if (bg->alloc_offset < bg->zone_capacity) {
+			bg->meta_write_pointer = bg->start;
+			if (!btrfs_zone_activate(bg))
+				ret = -EIO;
+		}
+	}
+
 	if (ret == -EIO && profile != 0 && profile != BTRFS_BLOCK_GROUP_RAID0 &&
 	    profile != BTRFS_BLOCK_GROUP_RAID10) {
 		/*
@@ -1965,6 +1946,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (num_sequential > 0)
 		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 
+	if (num_conventional > 0 && num_sequential > 0) {
+		bool any_active = false;
+
+		for (i = 0; i < map->num_stripes; i++) {
+			if (zone_info[i].alloc_offset != WP_CONVENTIONAL &&
+			    test_bit(i, active)) {
+				any_active = true;
+				break;
+			}
+		}
+
+		for (i = 0; i < map->num_stripes; i++) {
+			if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+				assign_bit(i, active, any_active);
+		}
+	}
+
 	if (num_conventional > 0) {
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
@@ -2008,6 +2006,13 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		ret = -EIO;
 	}
 
+	if (!ret && num_conventional && num_sequential &&
+	    cache->alloc_offset > 0 && cache->alloc_offset < cache->zone_capacity) {
+		cache->meta_write_pointer = cache->start;
+		if (!btrfs_zone_activate(cache))
+			ret = -EIO;
+	}
+
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
@@ -2457,6 +2462,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
+		if (!btrfs_dev_is_sequential(device, physical))
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 
@@ -2533,6 +2541,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	bool cleared;
+	unsigned int nofs_flags;
 	int ret;
 
 	if (!device->bdev)
@@ -2541,18 +2550,17 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	if (zinfo->max_active_zones == 0)
 		return 0;
 
-	if (btrfs_dev_is_sequential(device, physical)) {
-		unsigned int nofs_flags;
+	if (!btrfs_dev_is_sequential(device, physical))
+		return 0;
 
-		nofs_flags = memalloc_nofs_save();
-		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-				       physical >> SECTOR_SHIFT,
-				       zinfo->zone_size >> SECTOR_SHIFT);
-		memalloc_nofs_restore(nofs_flags);
+	nofs_flags = memalloc_nofs_save();
+	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+			       physical >> SECTOR_SHIFT,
+			       zinfo->zone_size >> SECTOR_SHIFT);
+	memalloc_nofs_restore(nofs_flags);
 
-		if (ret)
-			return ret;
-	}
+	if (ret)
+		return ret;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
 	cleared = btrfs_dev_clear_active_zone(device, physical);
@@ -2991,6 +2999,7 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 		spin_lock(&block_group->lock);
 		if (block_group->reserved || block_group->alloc_offset == 0 ||
 		    !(block_group->flags & BTRFS_BLOCK_GROUP_DATA) ||
+		    !test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags) ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
 			continue;
@@ -3113,8 +3122,14 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *dev = map->stripes[i].dev;
+			struct btrfs_zoned_device_info *zone_info = dev->zone_info;
+			u64 physical = map->stripes[i].physical;
+
+			if (btrfs_dev_is_sequential(dev, physical))
+				zone_info->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
-- 
2.56.0

