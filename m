Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085779;
	b=JxNr6lrD76eKnVbh/14kvlyIsoLLfmdKzaydoz5ENkP4kOmQv7qKK0stAtFez7zXGFOc
	 GgI94w6leiIk3N+wF9B9qR/xKETDUtFS2iaN1+wiyVKPAArBs1OLeIgT+6d9yyoUFdGtu
	 H9SnytJt2hpizk/wnAfIgt+li5GE1H2ig4jhQ7sf6X20h3OhrTvqkR478QpeHqndfAd+5
	 PawLU+znChpx6hWLWhBF3sYlcN45+ohYLiAzs/STZuFasMmykWbhtkpT2H/kKLcwNncsa
	 Ziy0y2H4I36ackXgJG2MhUUUhvzjPDqaFfL5Ie4cKtIS/BQhmTOUNrS4FPmrHTZ93Nw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085779;
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
	bh=zkxmcKT/Y7ZSBbQhGBqGQuWRfOSkS5a4SwRJq4SxpzY=;
	b=5YVMSddnnCneV5k9b1aCb3cGTqBRarN0bRPquCj4Ii0BV0i9vd+Dw8UDqJnQxxofQE7A
	 G1PNOV2bdI7qgbsalcozoR4BLU2oeaG5E4uUD5d6afNfI4IYINXBpGDL6E7uYkvHcdhQq
	 naRuL5NHzlG5zNerLGYLfOOH8ZYTqyCesTVadmNEYPGcJc6g/ztz9Aa62AFE3f3KlXDqU
	 5anAKeAqsGmTNN1nh2pSVZz3wbNDy6Lk3pfL7mm0gmkdhIe5s+OiyiFULHEy5OXsDFyMh
	 auagsS83/73+ZEcpbjlvVjfaQRiU1VHKnnhROuoqZ3MRb2lN0PRyFonePLbT7AMExvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="ae8/AuSk";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=nNrPbYTe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9311606A330
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9311606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ae8/AuSk;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=nNrPbYTe
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085778; x=1824621778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=7cK64oKLw1hL7DEE1saSrT6qEFcv9igvSi/6lpFzNHY=;
  b=ae8/AuSkf3SdlYs7J1WN0A0KQ+qrHNbGfbMmCsU2Ai6sphVQJ6fjZuMW
   UHkl0gpcbKNL1gsyXlppCujwTrcQTkJonn8epl6vCNlez4MfYmWbjD2pd
   7NYd0BrG0pRaWRDI7RIrTnJkDVHF+tbf/WacdjYsNmpwUgNuwhtqeFsG3
   dWM5STuio6JQs01WIE0YQaPj8b8wO33X8FB1TVixF4oGCUgFYYQe28wb8
   1koJR9xJhSroM9mYX9WjkiXsCP2qy9CL4/ISEkVJUUugFE06xFN8lEi4Y
   jGhMYGvdt9FC6WDTZH1ZrbmG2UlTfxDc3rr3q6Opwr816GtaYT9tcPsyr
   w==;
X-CSE-ConnectionGUID: 75NBdzEXTYGTmSfy6T7jRg==
X-CSE-MsgGUID: pvHyQR/OSBCVyhQ7Z26t1w==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863259"
Received: from mail-westus3azon11011028.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.28])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cgXPslk35yD5Bn2x1zSkyQheTfi1IUl7HElndxhGnUapA3dYccgFLjKT42zntfuKvttREDqA39XjgZ6tiH97oQsNNUkpRR6qzOALvBcUHJ5csl0946d4BXvE42+ObLZqZ/nw2jUZ6jUC/xc0NcNyKWRWygXjOEHjL7LG4pm/J4sQOCr2p7lCBb6I6lMvv/82FQam2JqiPsM6U1KaFXAwJpV0eCisXYMUio+Dxj16HLukiuQvndgU3JD20kyPMNp1YJmjaFUe2piHEt/h8b8P/JgeRzIzm95qu7377r0EpphKU60eWqj9iCRrLEPf8HOL0UALo8hciwtPlQ28I3RUow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zkxmcKT/Y7ZSBbQhGBqGQuWRfOSkS5a4SwRJq4SxpzY=;
 b=u8yDg5FQok/KhymTFBzw5MdhJ+tUlPKEXK13I/lSgNAFWYakYeyeu6xvyeQ2v+EgHYFFMqENJ9MmP2TJSxX4me5pG6Wcz59MTFVOgL38tTiy4bvOk0pHGgtVof6n2D4QJIbJD4hRhTBDdzi/n6Tjx6DYS067XNjsNodBgWuapu22FaiTQIPRmIgSWCEEVCrAgq1xTuSF/XOwOopuem3Ubopian3+QroWQBZbKc9wtW1PtYNW01om4cOaCGPyrLi/csjE3B1balYviO8wHlgR36d4egPzJudwsn1whGp9DGaUnmZ7zaF19UXzbVSAC7C8aEfWhiP6+RyXLjZQH1oPKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkxmcKT/Y7ZSBbQhGBqGQuWRfOSkS5a4SwRJq4SxpzY=;
 b=nNrPbYTeMVjEZDCNmIMOIg2DtmygWThiKvNzggLF/jc8UzIxwfIEikKdFwSlroivRMTbWspXVlPreLEMCT3FXSscOwK9C4+h+iHWoYOc9ovWS6J3vs+ddx8rkQTIT6Jx9DLBj49VXiI10RQUcc+h4Z5g+5LBh9oxxwGVGpA7cwc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:57 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:57 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 09/25] btrfs: zoned: use plain mutex lock in check_bg_is_active
Date: Tue, 27 Oct 2026 08:22:15 +0100
Message-ID: <20261027072232.419318-10-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6d13377e-44f9-482b-a4c1-08df33fb1f7a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	0FHFemwOakNuqbrk8KW150rvZiubE40vMhhbTW+TzeMlKFfqsbgXW3XwyYVyRTcIS/44tuZkO23SfkH+gxgfmFOu7DbZn0RBHeOEIYyaoVaDJyndmPx3J5h+i7Ma2A0+phB+WAmzOybXWSdWlUsHQI9cyC/VF+h1nQd9SKoS3fq8t2j31SRI2zjV9rotGKEuMNHOSNjeAr56ij+vfc/LRjqNs4IItrKyr9z1zsSrCXm3t41KLA0wnt5N8Up6EJinMNIcSh+CcrFWuax50U87oEHtbfVq7f0BnsVR/TEnucnQk6U7fRedIfDPwonF4CuTB3tfPgR/eKiQGJfeEiTN2ABy1pGfELFOMflXnNkCMuB4coZv/MjRUUfHuFn/K6WOIuPCteoG+ftMd9FZri1g1io3uZes+z8A8JzIS4hckNoorKx47EbsGCpfGwaQqVTafklQXSFfep8aJUJhn0r26f1VTZM4RpKg9wokabSpBT6us25gLL/WGrlHnmCVAmZvVbW2WAK+lIqrzwfmAnxt5JGemIACX7PeKNq2usUzCHp/pD67RWfbFhsWG5IRPqEjOcQJgZX/1RUV0HKpJxXMeK//ZRsgAfu49gV+DpxwIiFfeN8THf2rXIQ4NHn0TTvrLdbK05ZRBRkGcQqg81eL0kqgyNimWaDmnvzxlAA3CiM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pmBpZWUOUYOll9CCqje0QlbJpJ5ZpxEXiRWV7+bjam2Xgc+L8Zy2oVtvEHD8?=
 =?us-ascii?Q?JH+YIfFeBF8cnbjFs9zXjxKrR+m06V4c7Q5b7WcM1yaWokhaqBPRh46Gb3ru?=
 =?us-ascii?Q?4mx8/NwXIZNT/LBf+rgbripIz3Cqe+3ApJ//GtD93b6K51dqPIrMB4tfrjVR?=
 =?us-ascii?Q?hH/lYK16OwOHhZ6gktxKPpMBSxwBWDDB/mgkOg+qxXeLauDcq81KaEqT438s?=
 =?us-ascii?Q?Fd+Dtv4pn1I6N7fogUugt+JJr4jClrcZfFvcxn7QHKUW0yD3RagnodZkediI?=
 =?us-ascii?Q?KpLW+LraRVWyUpzHghc03OAc9V+i9Sr7Dy5iZ6gGNzXi9R/YRIV4NO0KtcI7?=
 =?us-ascii?Q?zlDY0WF7vzG2kyrHOEVWNtlZm3Oih5HhWcFjXxbTE4YjO30GCljBOmTuhFZz?=
 =?us-ascii?Q?UY1JP+R1vTcojwCdVMSBBy+Z0+/y8J2l7CK04sKlZLyk3yGmemK6NpANzae0?=
 =?us-ascii?Q?YlmEOoaR7UToZyFHcjY2nlF5QXS1md209j3UR6KR5o1TWOX6h9mXlMLk3ZyH?=
 =?us-ascii?Q?VG7A/nixvgct+rUlbFFgzkUZfEk2LDBv/fliizcyDFeNM8+zD2KGy5wNc3Uh?=
 =?us-ascii?Q?g1l2D2JS3W5Gn5Q35AYtdNoHEspzg9n3+QjVpz97vhuWgl9/BXSLPGrR1qMj?=
 =?us-ascii?Q?/tA2M7M7u2qdskYWFjrpi5nFEoaBLRyDl2N5o3dY42U9ByL7zEv6H81GHOUa?=
 =?us-ascii?Q?qdaw93Q1wH1eIS4PY+qi11w5RwZomX0Pyor3hzrlltQTatuu36j/888/z3Cv?=
 =?us-ascii?Q?pw6/lwL2yB+bz7ZwbwRxgIevZEhXkFPaKC4iYpPHHRNbLiq89+4PGOfCDX5h?=
 =?us-ascii?Q?yoOoq6n89WuhQcJR2qI0UTghvsST95wlo0c++M7vdz8tWxN2ItEjelAoNvH+?=
 =?us-ascii?Q?OkuZn7RzgSm6gx+0RUCs7ZyteJG3obs9HaIlpIaD6Bz1bLHYv3fZLk+y5F23?=
 =?us-ascii?Q?WiQ+6IxPDuY42MRWaRO3kSRHsPljTuYFNM9jeIxhnh7uulAx5nyeVkXwlSky?=
 =?us-ascii?Q?+Ke7oJu+2FKBIO5qNzbLlzCe/2T5OhJDDAqRk+bRhrJN9YCJH4Fzt/OdaGit?=
 =?us-ascii?Q?8zy8k8q+ES5vE4wj5rbSi28RoPGann0e3EyemWMkU7/BdPe4Uq8PxR8G3bIl?=
 =?us-ascii?Q?W062p+r5+HSUbxzLPOsBGQ+w3HWPjeMPcj8wluT0+1tiwTRpLUrPXlVFCdyz?=
 =?us-ascii?Q?0YUEDcgIKCzg0COJDjY86TIUUx7SVAwgsqaDdem6i1ikk882Irik11cQ8YoA?=
 =?us-ascii?Q?NGMsucb+h006+ldk2ncAk4aEi4HHYSpHchfwLGqFzdznfyVGNPq2f8crvjI8?=
 =?us-ascii?Q?iKQkpmRvsz4NbcUtrZc8mzpgkV45N2nafb8gxK0MUQ2RyN7C0ym+tJTSHwX2?=
 =?us-ascii?Q?LUHujbhhHiwRam9OWka82AmZZBW34yogcikximW2gTCv46zgFL5zfDoI41Sb?=
 =?us-ascii?Q?w7em5XpOnjE4r7PKXN2pDZAGjILBCzdMj5YEgrQy7VCVGlvEhX5FxKgrPofI?=
 =?us-ascii?Q?6+SHzFgUQBi3O8V8OtANiKdtgTxSJncN8JKlPDR+2YIS3N/rC0/goCCerMWF?=
 =?us-ascii?Q?oktW8cQrhKnYLlrkeR2IODvE+cFwBp51AiDP13QzU0PFC99o/vRYcx8fmeUy?=
 =?us-ascii?Q?mShK3DGDBqPJxTKB6b1puYd54NaHKUfCgFnt/4zZ88s4CVn0nJeNaREAS8Kz?=
 =?us-ascii?Q?52UnySCfEYqX8fRVvfJOnkKOx+HIJKuPDv/8CGnTYZZFB/bWiufqsJ0tgzNj?=
 =?us-ascii?Q?xWQMWBw/HNvgHTRP2ZZR4psw0yDVjyTK2lI6GU6nMz1oBW7+FyPD8b+07XBv?=
X-MS-Exchange-AntiSpam-MessageData-1: aafMeUrlIJY4BiuMXbJ7VFjdKCIrV+iskM0=
X-Exchange-RoutingPolicyChecked:
	lSzflNnB7IMPCpXYQzymf+wvt3f1AeCnM0Znkc2rPvUgBNCNMQR0IE6Pvij8192wkx3vSJ77QvpF1DeGWqjNGonZkk5iXtWP63ThknOYAKA8ZlzU9bzCdrP0PZngFQ3NvlzQ94Z3yEb2nDaBdkgxBsNWOib7nVEBuG7VKAzE2yMAibsWmHabIUsC9CMhKGCkiVruMWXREWzgM50JZsImzDOJemtBCOvMIxaJtLphIDasOlkeili1lgjcCHuVhEBYci5ZHcA73SGngncxQE/7OiacOUZDICYEmoMx/HSHwGDXITl7pa7WklCFecB467KP4JfvZM+zofGs2NfD24h4IQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1ynj+k6Klg13J5zd6nSvfur0Wl0a5rj9/sE8clRTMauFM1GiqLIGvT2R1AEbg1wg7qm3n4VCvPhe0FcDGlzQDRhBsfcCKxlsf0fShtpu+sM/V+xE9qonaEUwg3UCKKV+Lv47pxgDzUx0s2wTlpE74fffBWm+uMiejA546OdohJg7osvhv3YYuDOljW1DSEPHEB6HmxVdApMzhzc0GMyRvsv7FvYS86E9dWpislgR4KTvYR6euuejoCRKeY5wFCqpqC0sk41jlmQ56nNyWU9/MycEMklYpHFDkXYous98VLjuc2faxQ3tcyCLys3g9Nu5c83oGZ65hjd5uEyCuRtv2Hd0OF7UffEei1jWU4SwmMCdoeX+6J/BcP4kjUJhLXcp54w4PkzPoGmoe0U8jigdhqxbi5WLU0r/DIPz3dQFF245QKk1vgpI0Jp2rBoBjwpSHk5LXrqHp/ry1788tlAu7C4e7aaaJKpJOIQ4c8KY/UdTzeil/zT6TO4+O4trU2SyhPIEUSbr3XGDAFq7IwxwWtLDljZMwcsR2Aj9QskaDcWowqDqolW4C9orES7HrVA7tvWRCjNUfjougwCTeivADbzTomABgSKa0mJ+dvNJCen/erISoOMcrw/lGgrMEW6w
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d13377e-44f9-482b-a4c1-08df33fb1f7a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:57.0011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZ+85sZbiA6KlBu0suMBvBot1v3A1GJBdKseQJk6Xj0HwZaT33+lRFIrP8uk8phXcOoL312AkpDOaOxVXyMAFghGVJuAq/q76xnOMMgnzew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

check_bg_is_active() is only called for zoned filesystems, so there is
no need in using the wrapper for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 6d9ddeb80310..1569d771a0a6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2238,9 +2238,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
 
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			ret_fin = btrfs_zone_finish_one_bg(fs_info);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
@@ -2263,10 +2263,10 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 			}
 
 			/* Pivot active metadata/system block group. */
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			wait_eb_writebacks(tgt);
 			do_zone_finish(tgt, true);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 			if (*active_bg == tgt) {
 				btrfs_put_block_group(tgt);
 				*active_bg = NULL;
-- 
2.56.0

