Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031004;
	b=gd1b9B6ADSCTT661+H5V3wCp1PWL6TrNF+V5tGGnbnIWkF6E6CIdi6gqaNM6iiLJWi7L
	 SMMB9nMuf8lPNe7+Pj9/m+GzILWdfxh52NmKZmF2PdHabU4XQ428mOdJuQQavEdCzuoiC
	 e5sX+NYx85lEZz/ioXHX3ve573xwtAA7549H0NiQdpjw3YZa6gkEegFYsbxLDAA5g5hfi
	 fH2xqFWrlJzebAD2t4EWcpQsP/Rl71zd8Jl/j0b+3F1MOUi4jXDSevSYEc7iaLdldFBeF
	 cYITYRglFLa727VMy9AYtqLGlMUAFOXNHXBzAQObT9cMEHUa2LWeTYy86EFD71t7Qnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031004;
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
	bh=tQjq1Rhj+N5EsKP45GWN6MnqWZTuaIyNtuxeS66r6bA=;
	b=Mu6IzjgE3BXJ2cTD1dP+zM+KVDdSSi/C2wnk2xH9kkZJDcLQOwGeoOsGhv9F4evHjt5V
	 CaEYp2/N/X2ToOrI6fPGi/yn3f1BOKW87hwjnhHDMQZN3TTB6Ab9LDJO5Ogf16BixLy3v
	 0eqTWaQ3C/2bNDe2UnUQj5QfmQYzarET5/KuqRRJ+T6bqnOtKGVhWZC0Pm2SW/+Du6Ez1
	 /bQu2Gb3RxU9uP8rxAAkShUH3ATWlb1jRPukYMnJ8OQq7MDuzMIBoV87crdVgorCdDxTt
	 JJ5FXmxz6dIE80jaFnxqSVODdlNpDH6HK9paMfd4vrdJcCeIBkx6HqRKP2S4aZVPWoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=AoZ183Ez;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rwMXqflt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4A9606A31E
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C4A9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=AoZ183Ez;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rwMXqflt
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031004; x=1824567004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=MMvkdrq1le/ceVpBvT5nmUmBqeV4c0MbR2v9aZ9/IS0=;
  b=AoZ183EzfxT4ptybTEcDqBsw8lXA2wxCnTIRI6dMLhy7XfhU4hrng6o2
   ZUTimQsP//zCnMDanBY0OH5XdScgCSS/7/aQASxmUoveP/JzwazGmlEN7
   QiogSjvaIDQbp++LJy3qLkboY83wBV+GErt/LfWGb9hOv2Hnjd8s/dziG
   WlJG7fivf1Q5E4K02sUOlfRL6lCIPxnTLfMC1+8HT8lsmeQ03jJjZC5fk
   VJF1EU5nqbLD9bL8YEdpxY9ol2TrAE0eMqJN/U7LhBm7cBjku8id6d/6n
   vwkV890neKoRXz2spUvWwG0jyLo8iQZzZi4fKtSjFTKYG0L9LYY9h2gBJ
   A==;
X-CSE-ConnectionGUID: iWCPlOxuQ/a3oN/o7zlHcw==
X-CSE-MsgGUID: Mf7uL+1pShCDm9YI/SElQQ==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158068809"
Received: from mail-westcentralusazon11010050.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KlJr3snZpmfx2gawqq3kcN9RTERfh9SgOyGWdAOLIarFoKflutCkGDG39Bna9EjHxLmq3M2gACY5A+16dHdj9g88HWMIw6knXUO3EKCBtKRzSU5J+nPtnStAIuXAK3JUcSWgvSa45Chpr3YZ9U+T+9AMGwHkO2ZwpflNWvKcuYs3B8+oLquWB/P2sdJeO1I1MI5B1WH1k4jZ7vvDc6K4oYFSyD8P7ujZwA4jAG+ric6j5kGuu3uwIb5hNgPRx5FkmPC9rLHNwiSdc8/RYq5j2Bl+GZhvZFNeHpeFeX029kbalB9tupH37rPODxyF/4ymFDq7mVKyqb399i8OxJ4DoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQjq1Rhj+N5EsKP45GWN6MnqWZTuaIyNtuxeS66r6bA=;
 b=o62D3lyZrHfquPfitJXlxbhaMQe6NMZKjrKL95M/u8ZI0Fs6sjPTGSr8Wkc6ys/SDPXNXHcgrA/l1ImRS3rTQ1AT7Yk7pxgAOuAWPUJi5U7kI2bf4hRpYVtAv2S9VvNv8+M8q65xduOqYlJu7ZIgFSS1/fpxZ56Oi4UXEarFpVGEacKduowkqn5b3YDxwMsE9oBF7AaHAbO+yYTGtTqoom3SE8om/CdURGFqXr8AVE/desu90tk0wMiotLCkJpuEhnMwYBl4OJyCyuL8jKIi3VZpGPn0z4HKEex6qPdYx2yJPSvTcYzLhrjSUQB2Vtj+Xm6Kd9x5dJBCB6GswGHIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQjq1Rhj+N5EsKP45GWN6MnqWZTuaIyNtuxeS66r6bA=;
 b=rwMXqflthV1JgmU/fPCxRGTjBXI0tIaX2kFXK1WgmN5ESmmycCHfpitqMW0syWiLW5pOx/fKK3r3CgNA1ym39WOFBf9ToN1WploWKwr7F8avbgLIJHJ4nBykulKjaWbPXVxT5SlEDrvr5eYnwgug7Jp9nk8N68aH+SxgPzhbG9k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB8472.namprd04.prod.outlook.com (2603:10b6:a03:4e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:31 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 02/25] btrfs: zoned: don't activate conventional zones of mixed block groups
Date: Mon, 26 Oct 2026 17:08:50 +0100
Message-ID: <20261026160913.207909-3-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b7d24ce-61b5-405c-9d68-08df337b84e4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|366016|1800799024|261026140227099003|11063799006|56012099006|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vKhslpD53OszN+LDIa+hRpD+p1Nk80kbLYa1cUgSWe52C7WYX2O+C5DbYYaj2zlo9PxTqAZ2fuiLQaioexRjpFAt83fxYL5+LlWgCk08ieTzIisZUeB8BBOjegDgMOLmFwe1hauBF7y1Nx8teaWgD3B3kE2IGm9P/oXk6EK1IMdKI/tf7UH4Q6BjYEXpiHdXxUzUffRpuHFbNfBbHL0CUjiUi8Kna/lwE4tieHan2dC+AO7hn2i5j2ZZkgGBkoFf1qslTiJmEYqFUmgqUi3dveiGVYL6olWYxOds/RGqZQJkZ5wltoOV3IYk1YfjHaLkZ+QpNpjutZv1OrYvGkSwxpHIKKUztcM+hz6Rwb9gdKQuZ1qMy0BlhWpz+yn8WJxV3+Qan9prFPi08zOXVh8vtHbLF7KYOILFRrsD7Qw1PF/Hd7z9nf2YLrTUqAoSbLh5/xqRcOjdPqqL9/YrmmOO6f37aFvJ+lBmembPKZwmjRj0dVGOZCIjq9XN+1C3l4RKu/8WH4XWf9quCRV66HDh6PS5jUY7ozpOD4jAxu8Rz5W+W+NKtxldKDEXpvVBBkJmasxLD26V2uanr6e1P5wurYUKJit1fd4AP2bzDTaxdQehR3pCuK9GKspcnT0McXC4/4w3QeLJn49un9iean1rTzjOmjKlpcdEU79eTrhy9c8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(366016)(1800799024)(261026140227099003)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X8LeBYHOU+qXyK3wPBx7kEmxN0j7pKkfJE1D/hU/REWqDTbG7e5EYArMHQIg?=
 =?us-ascii?Q?oQQkZlf9xRGP/7ZpRs089hVfHTKh+Ha38HfABvwhvoHJsDfI2wLkyY80EK+G?=
 =?us-ascii?Q?Sjf3Q0YqAwLJjXrfAHIT2txQ4bHJyJOX3OH2n1SwsJBTmhMxSLuwVZifEWPJ?=
 =?us-ascii?Q?2Y5PzWBY/aMuw9T8GDPtoQDLyYTnWQJS5cXUSBG+xcfU/x9z1+fjyIwFNIfG?=
 =?us-ascii?Q?WeNeEzRo3JzS3oq7yNLRO0SjF4rFW6+QkCVelq/m87QrbTdOozWb37Wwbi/S?=
 =?us-ascii?Q?HckBeX9op7BLo9lQp2Im+z7i4CgDaDBQXQQcY8AfxGzja4PDpSzYzBwUiGlZ?=
 =?us-ascii?Q?uZYp2xOTp6/8LmTsrGN/tre4FHgS9vd9MR13xBIgD5JpZVA8AzoOrNXCuWnO?=
 =?us-ascii?Q?ByyvEiHOObYpOSZUTa/cZKQVZXN9llCABjfjBzJtB0JnRpslYoVcaob9BO1d?=
 =?us-ascii?Q?rGT8eEfuWWnK5YcLTjh1u/4QbfM6YJztF+k+bpoFRDIjhNE7dTG4Q4Df/Qip?=
 =?us-ascii?Q?NwFWu6KVIwvC3CTGJXEPx58/8Zwfue3lxwZgRFhEm/MSEHnLUgewxRAruWjM?=
 =?us-ascii?Q?nsU22yTRVm6MMfJR4Jkt6sqkwuO9nDj5cLuV94I69D8I4osqCjl6JTFuByJ4?=
 =?us-ascii?Q?w3yIawyiCKs+PvE4qNyNOTMTJqVjALCuCdgmyEe8uNtgTW2CXQ+Xgmc7LAtP?=
 =?us-ascii?Q?ZsMQF5z2DiVbyBSIpcf9ZjRsgkaO9i1h1B99BbhrWcq876Z/5tCqGXYnbw5G?=
 =?us-ascii?Q?tAL/yR6wdtnSBVJ5claP6KdSWxK9dXuSIz38k/WbNoOKXLuGQJPaSdAl8h+W?=
 =?us-ascii?Q?IHdfNA1m8uLPCQzq701sAtD6vNp9yCetFReXy89NMPj9uZWe4VdJOAD/4vXh?=
 =?us-ascii?Q?N4W1dZZC+GNxo5xmD5rj+jd8dHXRGu9cCkMfpUzjpHB4rFjVGV6vmE6+X3FG?=
 =?us-ascii?Q?y1LnsLT5LB8PsrwtiU2KirRSe+HKKPrXt39by6EKfTNNLIdG/zX/FZIKzmlh?=
 =?us-ascii?Q?CyadQ1PV3OffW1itwkoOwYHCURS9mlXQpriJGE541CMw8c9f1bgQKaXQjBLt?=
 =?us-ascii?Q?tG1ru1+mwznCXUgbdJPj+ooUsrLbUeXEmGeKa9hIlWoaFejwz2d/4NpeoVpq?=
 =?us-ascii?Q?4O/K5Xz26QBMNQm6dRz0aLLhNbcmy4c1f4utwBenVqhg9Fg763p36wGlJ7Y5?=
 =?us-ascii?Q?DqrqJEgZSeuqhK+uobp3vHrtagQUr6nEkljOD7igEBh52KqdvY8cZC/oi4zh?=
 =?us-ascii?Q?ZsU6plpMQe7ouxn0H68X89jzVQ5WFv/zu8saZOLgHi9TFrytroWdOwOaT06B?=
 =?us-ascii?Q?FXkethdW3SYjFIjBUkn9nyde8kMkEAgmb+NuG2hw/Hrzi/FvWtXu0cbaJMMJ?=
 =?us-ascii?Q?kmA5aJMWgqeEJvkwFVFZ5uYd3RGZCtibrF4l/Zsa7FAcEx5+jMe6gw+g27Dg?=
 =?us-ascii?Q?d1KUeTcJdo5VqMGE/Kz+0yyupi0pYhpbheo/pMZ8U8SClgcrGx5HJ4tp9fdg?=
 =?us-ascii?Q?t+soio694pflecudGqGf98GTSlyd/XqO6mSCELnFtXlLnsVAJSAgGTmB2lTS?=
 =?us-ascii?Q?M4zjxvjypuC8TkdnMPVyB+y3E0SZnFb7tN5QYO3BcWAH+uySOQ9JCeJfP147?=
 =?us-ascii?Q?bN9unG6LH1gdEfdsqG86im/7cUwQgWRjiCqegeVFY0JdqHW+mTVf9E8rI8xX?=
 =?us-ascii?Q?q4L6eJLuYat2rGXs0eIdjuvOHusuevaG/d5mWcqqteFaBka9U2maAyfCXQZS?=
 =?us-ascii?Q?h4Udxh1hnF+uPOdL5SdqLn2Yzs5bynIX7woN87kzfQWBzEwGrvJbQEGImcZB?=
X-MS-Exchange-AntiSpam-MessageData-1: WyW53NaZ0SF4Rg==
X-Exchange-RoutingPolicyChecked:
	Vt92smCf0bhvhz9M4HpHjrSrRMSRkyp9OO26UhZJtiUaFu7xRMwH3W8+DLGSGK0a+djyiOP0Jce/uAq2htx2YdMbKovjD/aCC/eJhdXR285an+U4s6s4YskP3vdgMF0lTNYnDTZ4Q+l7sMs3+NMeoeLcursEwIJP8SszyNXyp9LhOBoGAzd6U/kyff13JEbKX7ci28KxZZBrFN6022EI5q8WzWaNtmgg6dCnRyf1c/jxyFmGzzs1irIg3mcYle6pZ6IGA3xeZf33BSK2GZQAWz74ZQlPGCIO9hhggkGAPlFAtCVJN351MFbcKDq9HlfdzSyp+P3YSS03s4jyQsUe8Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1PiqU1m1Oelh76D0A0Wcj9+Ds7jVOCNaMClg9nJzKlRSMUS0nRSsLnpbuipH9Ycn9x+81WWqW19aGgi/iwAbjLmayBMwezgHIHm8onQyc5efZGoyWzGtAGsy8RLyDx/tiFBOjqcntj9Blv5Rs278EJf9sPxJTutjA8dBeP5TjnhkNKXu8k+UGpIM1bULYslg6UlCUDykgKKPebRdq0gRf0P1FznTfCtuitsxySgFsjdIly9BjrEwFf/efL/Y2J80f805dgJ6g2yik9qz7kdPTApy4ziGP+rIn63jNtQreoAq6pIwpwAVd0d5TrEQOMcnjWvx8wjHfZqalmu/6rT6j3dTsMctM32m2oh4vpkHk+HdoZQfGD20PeWUVV0BGvrmYtqkucwAfisICVi5BIeArD4Fmt3Hq7W5jKP4N7Njo0etj41XJnMEEvlwrurM4oMBes+M9jH0uaFPBTZtjLTriIx3PnOQLctYp+RSzjEw5GKKZAZPkJDokrQZJyB/apk+b/uyl1eZwUd1OMJufTwOJdPQUrJZEKObDiHWWw7mJKlESl8niwAVsaCwxVd0ZFNYYKNAZYAEqyXD/EFtXfkIPgpqZoUHviJ2sj3wkX5YgUMOfz77jKkiRB7tr0VEwLYP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7d24ce-61b5-405c-9d68-08df337b84e4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:31.5972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2/2HfHesR6Hyk7rTKXc83vCOVa7c1GXKPvAS9p/jrZlGHeZegodTTfTs4xnSQAOIEQPzfLDkovVpO6Otm7g2DEWpiYhy4Fsqehe+XY5YZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8472

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
 fs/btrfs/tests/zoned-tests.c |   6 ++
 fs/btrfs/zoned.c             | 117 +++++++++++++++++++----------------
 2 files changed, 68 insertions(+), 55 deletions(-)

diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
index 2bc3b14baa41..c46d59337020 100644
--- a/fs/btrfs/tests/zoned-tests.c
+++ b/fs/btrfs/tests/zoned-tests.c
@@ -101,6 +101,12 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
+	if ((ret || !bitmap_full(active, test->num_stripes)) &&
+	    test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
+		test_err("block group marked active before all stripes were checked");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ffa85cff8b71..1fc3d1e418c9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1429,8 +1429,7 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 }
 
 static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
-					 struct zone_info *info,
-					 unsigned long *active)
+					 struct zone_info *info)
 {
 	if (unlikely(info->alloc_offset == WP_MISSING_DEV)) {
 		btrfs_err(bg->fs_info,
@@ -1441,15 +1440,12 @@ static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
 
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
@@ -1500,13 +1496,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
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
@@ -1514,7 +1503,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1558,15 +1546,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
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
@@ -1580,7 +1559,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1672,13 +1650,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
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
@@ -1702,7 +1673,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 					 struct btrfs_chunk_map *map,
 					 struct zone_info *zone_info,
-					 unsigned long *active,
 					 u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1824,13 +1794,6 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
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
@@ -1867,21 +1830,21 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
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
@@ -1891,6 +1854,16 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 		return -EINVAL;
 	}
 
+	if (!ret && !bitmap_empty(active, map->num_stripes)) {
+		if (bitmap_full(active, map->num_stripes)) {
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
@@ -1966,6 +1939,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
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
@@ -2009,6 +1999,13 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
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
@@ -2458,6 +2455,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
+		if (!btrfs_dev_is_sequential(device, physical))
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 
@@ -2534,6 +2534,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	bool cleared;
+	unsigned int nofs_flags;
 	int ret;
 
 	if (!device->bdev)
@@ -2542,18 +2543,17 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
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
@@ -2989,6 +2989,7 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 		spin_lock(&block_group->lock);
 		if (block_group->reserved || block_group->alloc_offset == 0 ||
 		    !(block_group->flags & BTRFS_BLOCK_GROUP_DATA) ||
+		    !test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags) ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
 			continue;
@@ -3111,8 +3112,14 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
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

