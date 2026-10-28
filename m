Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211695;
	b=Yzamal7BQ/3/eBre1Ju7jHmPKZ42bmSTzoEBo+n/6HvQBVXj2TPg8qvzEuBnw1R5WYBV
	 vuv01lHSsbQHGDA3SDi/4eVraROLQyySZYrALxv8QB9RWUOvlM3BbyCLBA/fdaX3zVlIU
	 Cjs5idUoS0/00xYYn1yE6VWLl+mbnihC/XGBM7THU9jQhMFdBmQeNTqJcvkVAhjH9XqFa
	 z6joucZOlwDdj0VqWHKdaSuBtKeSC+wu/oMPkvu4WXIpa9foxAd/HzLL1h78iXD8g0lvD
	 a+AFLRHUWSNECN8NYCf9PUkk5bdTDVxFDIPF43u1jLNtyNPvv2xypnKsIhGXtiAiboQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211695;
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
	bh=MVJOKVozGppMQ23tBxlP4r+Qz5ohzrpnIzqklpPOtME=;
	b=FDh0krnMhyPxuFcxtjQ+uXWgJDgNNQf/4IMLxOWFhWgHPErANTClyDI4R9K9Yo1DPGUZ
	 LOj2fLONc8mYV+zEGfLN+QKDLqoK1k7EccFBp5wm1TL7E4nKA6Dik17Jz/rmCnQMjSfSO
	 PxsDOJeHCMMAsA2vC4qf6W2pOyw+2SpohLzrd6mjGZ+WEn8+a9NQ5BieHxGKvkMEUyfi9
	 CCT35Px64zF8ZFj5yohWLLMRKD0GGhpAe5xjh4RPt2/fom06jDLIwNaXbSqGsBmY5aCv7
	 DWm+I8oqfoT6W4+QREGzs7WiKRl1KGa+W5ecAToPfw6dO5ST76a6EW86jJwQcL6g71Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nH09A1tD;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="Y38g96/U";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175D2606A326
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 175D2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nH09A1tD;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Y38g96/U
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211695; x=1824747695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EHs90UZKl+n+5RHsjtMb7XabrNpRCsuy1Jz1XExDksk=;
  b=nH09A1tDPCHlo26416jDaaPCnkMD/ZOrzGSoVBHfl/CZou7+/SrL+gpz
   Z+uXvHNt6BeXtx9NGZyG+hZxdHB8IEaKty5BklGRqF7beHWov2k3tH4zz
   Mj5kbM9UlQckOsXtj6BGlE1XKCKKcX+0RpLLfdzHDPVm3ytQm+Ew5vVan
   qLlPR+4cRENoRBW+pHFpcD/H/wErwGQBI+q3lcbrH1dXV7rQTlaNNDLoX
   bG1FW1nnvlyStC22g7q6RiN4di1DoyUZlChkFP3L1ZhWhYbMHfFuzsvP5
   sFXVD5vYUxSdl3M2o5efqpUTAbww06Bh9hTHUq7jTguf0Ea5gngWUkm5Y
   g==;
X-CSE-ConnectionGUID: CTpGI9a4TROrSwLsIg9Rwg==
X-CSE-MsgGUID: cFcU05qwTLiQAaI3u+t3zw==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159234661"
Received: from mail-westcentralusazon11013018.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CmfUa8c5cTqT3gzi4iwHriir7RHggc9AijPfuFMY6RqClDJwst5EWexCwnoNwXuQmzzigS61KrqwbkQPJ7Pya4sFdHxaaYFsadzJo/iFAhk9etDtXrJ5J6qoQn/skLOZkXb7NUCPzyM4wmHnvRhzLCEAW3lhSSp90ZtYLTU2xQUe5upNaXC8dl9tf/XYS04YTebcPKKi5pRow982ZGiD/bVrSJ2mtw1MoiEoDxpYIiyBJXm5cEPP56UIFd9hekCfmA1zgkE97dfvlVeaDylXIifjCh/+vm8BrYrhnXR9c2ZdRflgq6adNeeFxtiW4IrviwhgK+5edX6fagbBH/sc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVJOKVozGppMQ23tBxlP4r+Qz5ohzrpnIzqklpPOtME=;
 b=Vn3ActRGM86mGgz7NA7+jG0xrfSYcCXzdcSIrAj1qdD04U4nLJ+zI18tw7Fe7QAZ8AB0bwmcBM6rNHPBSlj+AIO7nxP8+ktw1Bgc88E7S/owhc/89V+UO9f8PmQm4rIgbbbh7SOc+3K5UHevg+KhAhJIX3+DUDTfzES2gzuZCUa8TDlbyHux6QyKR9w9GqVs7cCbtag5/U+tWA30lZpH8ADtRyg+BGm+iDFEmNBmDJ1d2eCKVJjjpYLw4xb10RNVkHieCOZBuFTRAsq3CupneB6pt2Il3hKgwLN6ivuDUVvqXDJ6tnpQAhRYTT882btcQMjzDQXTfv4j+PscS+NRYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVJOKVozGppMQ23tBxlP4r+Qz5ohzrpnIzqklpPOtME=;
 b=Y38g96/UwGnrPVYNAeZ2Tp4je66fo+cos1PwmYTQZSPTFfU1EdKx7OAY9V4axJPF3vmUO7IdtvEYwJUNWo9H0+XXoAyLWW0EDX2PGI+ajpswWsmwIMGI26D0e6XYtJhPU2DgcKGKLzk5BOTQaQkYguZhCs0ZvtQv5EFzzrqLu3E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB8753.namprd04.prod.outlook.com (2603:10b6:510:234::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:30 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:30 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v6 01/25] btrfs: zoned: fix possible race for reserved_active_zones
Date: Wed, 28 Oct 2026 19:20:47 +0100
Message-ID: <20261028182111.160492-2-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5a34dfed-396e-4aac-79b2-08df3520498c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|10070799003|376014|19092799006|261028144727099003|11063799006|56012099006|261009223027099003|261026140227099003|261021121427099003|10067099003|261022105027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9f/IjiFu/ZzU4osxgJZSiMLJ/2CX1ELmTrmN5lGEKJQUt/MvSCawlgIA8tY+Kd2vTo0KZNqtZ++o42zuTUMgJADukaTDhePPecREtaiEiggBbwAcIGDqxezmBoYP6U93BSrFb6hJhRMrOg5DGyXoAn+n31BIpedINRE7ADVxrqoK9YB0dgXeCmdv497OdwWpZcWg7efFEQomfJuhHDC5X5s6tiK2NBSghhyHDDexfSKWyCWXniRuiLuoUHScyMG1RpepdpyVhtVjjx+AcnkE2j1csWywvQND6mQiZIsv+jCZhqyKCKgXXMYD8vsZ0suY+MMFhhw2NQnNviLF0e+SUlSnQP7LQEMBeijZzZNadZYDs03ZPdhhGSMLwshL6j+ebNN6lvEC+YMm0UEvDvQ9gOY/HUeOv+MiahM6LjyAjlZiNdnuKxVUgofkK3Gb3D6VogBnYTaCl6flyrx6PqSZBMvsK0YBzfkYzkXz7qyvvBEMu5TcvumBobVAFR7dejy5L32I5jJmFiIXiaqmH37hvLjyiIr0YTBl5fP22J5AT7nq2ipK7vqfbwOLyTH6/FvxHOvxFN0N9KYcgOitqdj+2q1ec9mAd0zaUdBLydlW+Vws/mf197HihFz6edcOgLzCtF7D0iziDEchtMz3NVLHb8hquWvBCEZm41S+tYRZaRY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(10070799003)(376014)(19092799006)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026140227099003)(261021121427099003)(10067099003)(261022105027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yBseDTOgqIgrJqK1gtkW4Fxs9Hu/LBg+A1iUVDD+FHxUKMWjA2EUdg19PRgf?=
 =?us-ascii?Q?9xufOPOWsvRCru9AKu0IPiK02sE30rujUu1awK7ZPXNxhCpqkfThGw3/2i5U?=
 =?us-ascii?Q?yYE8NCJPbYEkomhKEUtJWZjPhidCqOQDRv/uvuXSU+XdemZxgLlziJ2HZI19?=
 =?us-ascii?Q?9w1JcnHRCPV7d06XgOVbn3Vf4q4KQbCNq8QSKCrypOZtjOv1YZLYbZ3nIOBq?=
 =?us-ascii?Q?ZJSvBMfpBTCO0KOrLH8sy2h6z7zb9cFYpXQNkUZfgT76undTtQB2041VPomk?=
 =?us-ascii?Q?ErfVLCk3iJIEWzTloWVoWYH0GqQARybZphJN6MrtswZkv0RfaLJ2WhfqcbsA?=
 =?us-ascii?Q?YxIklz/h3BN1zaFZvQ4DHUrmjFBE+rjvJzHPfUldsZRmEBQATBhc7jodU9ar?=
 =?us-ascii?Q?SKm4Y8iQtJYOdxEmaAwdFiYSc2zW4N3tJoefQqIcIKevNb/eCCmlN5/x8KgW?=
 =?us-ascii?Q?9WVA8AOzPpqJeyZjpjfKEt4byvD5H0hjjtRr3Ht6qp6g6Mjlst3DJ3m02ZXK?=
 =?us-ascii?Q?a3REcQDgUlZEJLQgisr7tMx6iUKoc9kwWZHA0gdTui+C38+YrcLXsJpyLc3y?=
 =?us-ascii?Q?9BJn3p33cnPpBK4u7VehKTtnn21GIdMukpWIUnCUDCXbsnCYTn0ZEO5wiTQQ?=
 =?us-ascii?Q?2kadd3b3evkOAVn/06mPJuKP2qnz7JTXlT5y24iAhLtaz/8ZZygfKi9l//sR?=
 =?us-ascii?Q?y6/YoVYm36oIkFY6MT8worfzPGfZrOVg6yHIh+E9J5VUUOV1eUaDeC0SBtql?=
 =?us-ascii?Q?fD49QUQzfk0AmkdXMkac4y5WrYk0kpYPfmhaoWesh6pYuSLDQu0ukGslHtkr?=
 =?us-ascii?Q?WYpY+jk+QdhDUFzglqtzolWnKL1wWEN5lGhuLJZHhUS4D2AYIEgxWMkzdLzg?=
 =?us-ascii?Q?alkZMg/49rqRi1oFHYpDTBVUEHycp946rRIpXrqXhxB5LjvZDWmYCmlZZPTz?=
 =?us-ascii?Q?/4hmTYxSv54rWFvaEgN60ndDQvuZCjT/8jurTP/Wavjyv2vAvEPvI6ezhb28?=
 =?us-ascii?Q?SZ2VxhvDgM+pVNwV6lt+e32Ny3vOYW7YrFL9SoG503fmnYV8IyLjLMuFTw23?=
 =?us-ascii?Q?bf5dpNgaO1ovOD8UTGRzwaLEuPFjwVEwzb84viTpdLvo60A/VHhSokuB+iSn?=
 =?us-ascii?Q?rUyv9lOVBygI0mLdvH8hNu/0UA5qrVwYjLrq457/EIDOep4EbiZnLL+qmBWn?=
 =?us-ascii?Q?D4G2PfSrHQxCU+fDt/w8Ke5UjiWE4M2gdq2YEaYdMWYTjNhnngCl53ubmyFS?=
 =?us-ascii?Q?u8ClvYYHDMjjv7fbIxhAWvJ7g+4GQC1N87jrjC/VoxP97mILpxACGDD87Xze?=
 =?us-ascii?Q?AZLOLvTxuutOdowf5ReNzesg8d2PMO3/uO1zLBC3Gn/fxGOFV+X0a8wDDotc?=
 =?us-ascii?Q?IpqFrCZh4k+48j/cGzPhZS8yuHBtvvQTh9vI0vhy4RS5W0DaGK3ufeyQSO1V?=
 =?us-ascii?Q?ZukHnYnSEcJaQJnwew5EvRsADpY8qd4o85wTxeB/TxiWTr9JEUXXN04JQI1J?=
 =?us-ascii?Q?JWo+7PIJtcHQnWYmoSMGDvK/81Kj9f6i1Ds/yBOZRtqtrWEqELtrOTXw8sdm?=
 =?us-ascii?Q?p6Iw+Z/Pp5o2DQfTImxoPu9rKd6xCLo7v6Umbm1/KD/FADBMoOGqlP4LFGiK?=
 =?us-ascii?Q?QpNXx2j8Qje51Ck/xGJrPlYvfvMoPY3pl+Xilir4nqy7yjaH5+u+OD53pI1I?=
 =?us-ascii?Q?5NsIw6MhPI7P3SsH7/3P1HjsW7CEDTDBxfhGNYprS/irLd0ErqqNyaB6RLD/?=
 =?us-ascii?Q?P1ch9qTNr6ktV6w5LIiLLIQ5NERhikJZK0c65TXoSn4f8qgGLQzgOoS14/x4?=
X-MS-Exchange-AntiSpam-MessageData-1: H5N9gn1xPFwO08RnbRmf7aPuHFCYGuDogyA=
X-Exchange-RoutingPolicyChecked:
	EKTEE6wrCfirhci6NnG6jutZGEO7zYc52L9HlDB1XrmmQdVgXtp5dFJi/IigNbtiKdEzuvkE0S4jw7C+69V7yMNp9kXjoPIAkHe7pzzGeLXA8jSfs0pzAD/qpM47oVP/SrGW7kM4679b+7NIEKt4Ib95VX0G3iiMDBbivQTmdG9lnP1lwGZ40n8H3go/SlqRzsGgfCWqfv7g6dCgTs9knpo9URHG/qM16NYcLkuO3dAiYKb0xHUGNRD0pTbFCZoITixukYdGMIVJcyEFpehS/OK9sijtJsZl4T8Oioq6UPXGMyY8lNBDKrhrAhPWyHUiiup7E/92H4Y138Q53JJmoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pM+vYpTxnstqPvlBOBKtFA/ohnyfpJ/AeFoPc4ASZyCgglTTdlrWsHujoEIZpRZHWfolmkFBNDTGGICkcoufJaZuj8yy2CbmY2UsvYCsQZPUHi32XRXPnHgZWzhaPQK4hlyqZhfAySFx0iS+rf9br7x9MbZEA5SW+YlXnS1k9nGzc6a+ihiEYjbANt/r7p8+/pFtkyFhJlNZ8+EAHdryCOli/5exeqzZ/bw4ptFjtRxgIcXZ23dHYTL0q6cuuxGJeyY8sIOBlWnwM170LoCglO4gWFz44opSMXtyCPHyhRhhwhlTCDuGGjEXcSMwQdJ9BceXv+qXzmy74cEm9nEzZFzDA8pxrOEKjUMvwNJpLbiRX4mmBXetWTqpNzCaKIfhUXFvxzvSVJCTjL/Uf6Z0F+q2oRceqX3JSHO2356Wg7vk1TkdHhWm2AlcJb5mLpgJc+lnW4oHiIxfp9aH5ITZZPI4luiZDv6DbwkmLxAPdDk+0NHyMcXKz57bT29XjLG5AG0uDKEdI5v2a4INcbzdjIqUI8thVKSVN34ZaUuPlw2+tPtMOQvsDXumNHYg9vyQJQjAEJY1EIiC0EHf3AnuDFuWj+P2KAmcW68rngif92Qlp5J2szV/BKGvb9tdLywA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a34dfed-396e-4aac-79b2-08df3520498c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:30.0521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BYPEnacmzicpyg7TVQoMJRjt1TFnqp8ujoKPm934hQsHpnjd34xQ81+4ErrgHC+LE61NqJSBaPY+BxXzGasVtbv7s1l53KYsDjucA7nzvmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8753

In call_zone_finish() the counter for reserved active zones is
incremented without holding the per filesystem zone_active_bgs_lock
potentially leading to a race for the active zone count.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 09a81c463053..b003f0bc778b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2528,6 +2528,7 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 static int call_zone_finish(struct btrfs_block_group *block_group,
 			    struct btrfs_io_stripe *stripe)
 {
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
@@ -2553,9 +2554,11 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 			return ret;
 	}
 
+	spin_lock(&fs_info->zone_active_bgs_lock);
 	cleared = btrfs_dev_clear_active_zone(device, physical);
 	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared)
 		zinfo->reserved_active_zones++;
+	spin_unlock(&fs_info->zone_active_bgs_lock);
 
 	return 0;
 }
-- 
2.56.0

