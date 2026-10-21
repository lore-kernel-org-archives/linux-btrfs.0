Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590155;
	b=JUFdcvw9ijOPRqxd0RaghZHV76AhXbPi8cd1rDKR8NcmJ9dN1vsx8LNh30VxJchUy+mE
	 6EXVqhwxN3mhgnCv9sHRqEMJh/oWRVrVlTrOge2wLYwt4zItbyN9mF9VWLqPs2K8u/PWM
	 X/RDe9fszcVLhk2v/y9XOXx/cO7Tznd8OzKBFMUQTiU8/5LbXtZrpVEvGZlVoQOj9seoL
	 wRAJjDQvmU8gozwibl59Qxcsf8XqnUzIjd7IbL1WZLr0N24twApeoWTTEg0OGbxpLR0Up
	 A5JAbR3JtDoYNM/2LNPF2gUMspWhAIr94Y1zpER0EXBXqKvve60c8CnuLxkFmlgT0yw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590155;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=nE6hskYX00fE+5qBm5/4BEsshXyrNJRddMgcxP91c9w=;
	b=ykCGsLv2ZZwLa2Gz3gavELv5hR4GMrAk+ZMOKIfOttJOUjEzJ49DNUVXaKK4seKagLsx
	 GY1qItsAmZVTSBPyhJFHugsv7wzPcDava/HXN87NKr4z31JPINpZvmHcL/tlKFvNieHec
	 rsI8ZJdMDarjBLdTy9a5PN8XFmw8KKHqvpBq8EG+NKtFBwrkcShAJgEppijXz7gGK0fU/
	 7KFsIoAOlDSdm2UiLAQyUGDgm5/Sopxes89hY5Pu+HJpFQxlygw1qSmmkkhO95Gcv6eKB
	 0tJ+b1/akcViXT586k90HKq0gSBWjG+ThQXwy1UTR1cUqmRs/8wLQVfY//xnpsbBOCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=S+JviWJ7;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wNx4zUhz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8F0606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F8F0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=S+JviWJ7;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wNx4zUhz
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590154; x=1824126154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=a0YEd4SKYZthD1yNhxElOX0DmWsNADaD+vKd3MNZKvY=;
  b=S+JviWJ7Nf7cGf/WBTic+NMOfjIlyo3ntmH+sUj+lCgv/moLLb+sZ2Ch
   hAXNoJH9H/4rIeqt3H/u23e+1lENQ27Rjwx4PhxUvEn5OuvFyM7Ffs3/y
   QQnidEQUwDaZl5MYDEwjeMJ6vm1n/9ZAgKuQGF5OXz1GRy7T6hzFhwImV
   l2hnHJN3cHtoBFm1kyWany5s2WW4+Hud6lhEy1zDO8T8PYqki1a3p/k92
   JnKk32RwsOROPz1/z57mg1itk87ocNyZDJmNtc6/aVI3tk/OB3Fc7g2oF
   q1eHHmdiirGvW46kFxWgMQyfrpmXJShGnhwSBPS7wjYuPhHLXVJSD0VZc
   Q==;
X-CSE-ConnectionGUID: /1VKXHm1QqK1HmBHfLipcA==
X-CSE-MsgGUID: QZUYBMkDTcuCaQwVDCeG5g==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="157035002"
Received: from mail-westus3azon11010024.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.24])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sdOAIrctKpcgdtqJVa4eA9SL8KwKRQ5AcFHsV/OrUE30UZnj0IGj9naqa2AS6kACYirXQI1JRzhI17cFNoTDf0hOa+L9eUBLQwOlMfgV0r1wKKNM6rxU077e+7ixmFYhyYORRQaRFBxnjMcr0/K8pGcfupZGIqFBSnWyOEggeEMd3Na1ZBZlDV/BYrkYyJixRDp0TAj/SX4Z/lBUxJpVMXVQXnA/hQydFQObPhhrq1yWixOwJ+PkGnREXzrRDysbev7TKVCw8wQLCfUMRqMor/z2ISZmJMSdS2Ekg5O5ojluBZaq7VftF4stOtxfafdO6EvXVFxmNyts2cZOUuBQ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nE6hskYX00fE+5qBm5/4BEsshXyrNJRddMgcxP91c9w=;
 b=Gxq352iL9A+qS6nwzzdbsRwoC+Uuk5l+6zqZJMHshxlJLbimNy0LXzoBgceo/5mstOpfi0Xs5L6CLb5fDnwtG/MbhV0831/IaVAN16xCMwzUNJ2RZC7TwjveQ3zLJyUwu7ML9gNjpDe9Z58tNh7HaVxuc4a9IXCZTboYvWJ8x2US93vecNRyzAqmXcxLS8gdx4mGTKlnzxe1BHNXEuMTRJsGGKVumHqWJ4fpB2NPO/0aJvGy5sUDbVnHwkD6YX7iITfCtrFquxjKP3IOPt1PgXVWPIrLDffQe+nhS8FNZU/vTYxRVV+SVZrvXfDbBw9I/snpUs0gDr6WszsdWuD+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nE6hskYX00fE+5qBm5/4BEsshXyrNJRddMgcxP91c9w=;
 b=wNx4zUhzJcIXZwNfcmg7+BYEyfILolc9wZiSMmPZdh0K2mHArYsuWj4QNssqnfGN3QmucoRFUAOtBpuIPUgCci6abYzgHTIZhC2rK0a4jRQWwYl3szGBRrvehAY2YE/z33ii3JoRSnUIn+dnXDpIQNDFT2QYavP2syIW9naltLI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7150.namprd04.prod.outlook.com (2603:10b6:a03:295::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:05 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 13/25] btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
Date: Wed, 21 Oct 2026 15:41:12 +0200
Message-ID: <20261021134124.2338902-14-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7150:EE_
X-MS-Office365-Filtering-Correlation-Id: ad23af47-4be9-4617-f283-08df2f7917d7
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|1800799024|376014|10070799003|366016|10067099003|22082099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 sdE3atuTBEX76qOFqkN2ENsdglODqzmxbuvZeylk5nhkz6B175i9nHjTsjBKZ+RKuRLTNIKrn2FOaHdhlaGy4y9hmquWOg1f4THpI3bTqQbfvqMRMsXP7v5G1MgUqLPRdtqaM4ArqRnQQLMyJ0m0Re+vZvL1+/KqfOSUbMuxi3IGi6uIKXl9eydAdm2DSXJ7Itcn7r4tJmWBF0uXmfkO+MVWt0TC2Isx3uQj3yt32891ANd+67xyS0/Mow57BLHHYREXeXDuYSI1+f+N+w/0BJcI71TMPZyd8hcvYghJ8sQ0y1Jg1L3KJcupiW71RoLLEwWKZHdlnqaO8z0kbR2Ny8ZEDfqtkikqctA9pb0mCX0xFAqK9qZDPl7Ofv3MFtFX1CwKyJ4WaXQsuV4QRNyjCf76KPNgMcNatID6POgTirYfE/nxhBhvUWzZfdgN++FXhbeCb9853ve8l5QBj7e9ah378AZ8ka6WEYPjV3r5MRc60xhiYzNiTATA6+fXzkwjo9luF/8kSHgpRl8AqCd7k9rn1JwpreQdLsNUCUw+6N0K18sIaRIjXzuqPD1//hufkxnaFS6adQWuv2cYjULKnM7Ie6Z4h6WFtuJEQKtLFzxHl1Fp0QE/016caKY7rNHbQKe+Q8IodEYb4YbglSRUJKqc7bgCKs90cmquHfC2Okw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(376014)(10070799003)(366016)(10067099003)(22082099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?dso2ez8a72F61L2/QHJFhADrj9umgg7H0v52TjGo4OovEB8ukvBOznFbuAWG?=
 =?us-ascii?Q?h9R8lJ+YZq0T2CvazlI72DMBqpjlRHwj3JV5WgEQLZwMU+itgx7iY/9gWoSz?=
 =?us-ascii?Q?0pMuGysRcc1E5dSpoJS0fXDTZGmAVE9oIL/iuJ0Y0FLmj7UEiogqBttKh7L/?=
 =?us-ascii?Q?pdmCsForA82p5Tmzz5HgAfzWnocs7YYsfTtK2ykmqkJ/69+AtbyEZ3LYA7Hq?=
 =?us-ascii?Q?oRa6e7yu1q6Nppo95RRDHoSfJyhIctSDuCxrN1exCtFS0XCn8VnChiu0nV/h?=
 =?us-ascii?Q?Yn/DT/8sKdiN97gQXOkv/OWwr5QX71uO9+BpgO9uD8N6gh8/SLyRN1Qx0ccY?=
 =?us-ascii?Q?Jmnrd3SncrBEDLYc84IMB+bfdFrW9Mc8BVfPE8mAkqLBm+WhiRMLAqiRVvR5?=
 =?us-ascii?Q?97xwCGihRVUEy2nqTWvpvNYDepn/XBRedfLUG0VDnsdY8MUPIPoXX4qt+q1M?=
 =?us-ascii?Q?h0Og1Yu/LeNus6JOZE+D/o3qRi5zNTPIsXvQW8Oye7XZOtg+57qYxG1saESc?=
 =?us-ascii?Q?i7qT2Xd7rbl6SAtaiefyZew1c2t/oNIkEfFZ7uDIYE/Rd5dKY9igGdKbqJJ3?=
 =?us-ascii?Q?SVeBy/EmfyYNoT8pJm7ArgWZVX3Gp3RxpYljZFoRoMFndhb28Ze490J8OIHb?=
 =?us-ascii?Q?BEVkwDomc/gZV8SQq4DzQ9wDf5eSlaucYeE/4gZsVHPcCGCh6Z1uTPM3ebr2?=
 =?us-ascii?Q?mN5HOcSTPFzK2+5FdDq2fhBnUOpoIaAC4PkjwIg9MLJHmoyznb9y9CgBNbr2?=
 =?us-ascii?Q?ypYRu/suEiWPZ+HhkI6ihx3qbB8HIFJEf5tkkMO72WgbeQ0wxJrRRwIxNmo+?=
 =?us-ascii?Q?UdX8GbJBhd9lR2R+/UiiJaCHwHFu2rpMhBBC1zsh0p+tkuRv3IVZA5fgF9tQ?=
 =?us-ascii?Q?+IftmSczNZSNHDLFGPebt6ZyOTYgbryAdk98+8KZO9R2LkgSDB0ZQHIreTDi?=
 =?us-ascii?Q?Ii9gS7ghWRzPCJeJwxvoW6zNU087H3GjW9gd6pd0VO9VN6TmxxJY/Gx9BAnF?=
 =?us-ascii?Q?v6W41qtADJoM9UNYTy5GplRodEu0Qlbga7lIND0VTO/OF4NVH0iuauGnJuri?=
 =?us-ascii?Q?UoZT/O58A56ieUVGsaX2SRCHARSqDldjFx8P7cDGIhre3/37nxpRxctL+we1?=
 =?us-ascii?Q?HpRKhrSm4AGT9bNm4AcRF1UB+UdrrUR6VqsE1IJDBmA2Rs12b08vuQSMQIB3?=
 =?us-ascii?Q?/dHVsISkLXGqW03K6abSgZDlf+aHTvsfJN/GupZ6FSjzyuoNlvObtbKks4hE?=
 =?us-ascii?Q?vqPx4MIDoJ5KPS783u03MXYYXOq/iOLU+3fRlJPTcCGBc3GhUGwf1OB5xZro?=
 =?us-ascii?Q?B3V5NnFiIW1vy8khSeSpTJdMZ0zOLa3bEwFw4RXKgfuaqm12/hLqrjT+iFS4?=
 =?us-ascii?Q?cnGdCvP3GA1GB3IVOuNq/oaM+1KOpfqZ5dJKtrDFoK+4Mpe72JitzzkoZT3y?=
 =?us-ascii?Q?xf4d1M2iRoBAP0Q8kVr6Q8X+4sCte1rHRqXC5Sd9xqtEWY2nIv9RrmRYhEHQ?=
 =?us-ascii?Q?YRjysFPWsj2zo7uJ8j6/Dps2qDZ0vUIS/uHnuCSbk0YaoqvNo9d8nweulp7i?=
 =?us-ascii?Q?ZrrlkTTz06R6YrCeeDG+bAjM2A8QINL7Bp/4F+m9gfs0L4oFnUR2IPu3Kbe/?=
 =?us-ascii?Q?je9VDhKs3lMjjko6YD3sE5+Dxk/au1thhdFzmK68aERwxOUa+eP5q5l3eC/4?=
 =?us-ascii?Q?8vnouV4Lbc8dVmwXIzUxRNkgy3BYne3fs7K5GJXOSqaBGGDRHokltRY6F1g4?=
 =?us-ascii?Q?iNjmUPkvtOkUSiTmaS5ya8iB4+KnjMpGz8iJHgQ3wbas8zbwRcvFbbJuZsQM?=
X-MS-Exchange-AntiSpam-MessageData-1: aA3noXDZxfi0DDYp6+2jGE6C81OogUsaPe8=
X-Exchange-RoutingPolicyChecked:
	sO6Mf/QJZ7ncLg6U3QDvZb2yojHOQmcifAlWk+R1Pe7Sv2ZP1k4pDV0Qg+9u60NKv8GMR0whYb4fw0XkGdi+HtAPJp8X96wZImuDwca5aAk/CbLRsrOokLnvl/cIzQxtWvBjLWev/cxtyOeA7KuFpecUzWLGghAED9ugy0wBuaVQeKGn22OcLkoTWAvoLIWpsWu5x978zTT6eUXLujXIwR/ThoKPwTdekiUeqanqs552oHzLHBzHkuxpnwkstAfnaQI7EXyoY41PzT9r9Vxi8BMyw76obP00JXU5Sy6MpdhlqtthDsEkS6Ke8PKaS8eSO96S4s2WZoc+N1LlHVL7+Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Svvq6P/Lfvkx7U0iHs2oINuWLU5Y+wMUFqk5GrIb3Yh87Idn/XumOCBh0diSlwCtm318ugInCXENcbv8KCjf2fG/0k4bXUoeOFm2Ey3lISejYUXVGu/gJy1QJ1LgirhXdRudbcXO55d162hRptIqm+/kUALPp7kLFPHHOz0dqnvQhbv/cQh+VpQh2UGgPQqlUo3eHwweA6ONDQ2Uz8J6VKNzUJj5UGXDpkezkCqGaOGj/Ol/NpNz2nPyOv7rfY/ktrgUIIgjfP8J4hGEQvfUNP7ddZSYxFPBIBDGoB0N7UqMMuHE17LDpF89nJGM2HeyJlOtKt6xdVhqVc0HYEFMkT4UfRuLisOcuSVHHrcbT3eFfN2UcOMsduzVntlSPH7Qap+YDL1Kw74RGGefiwVxGDj2pXK3F4kFcjarkEkMf8BvRyNfjPwbBVv9WfY78fR08uqfZIlzbyiZCPZlk8mTPGrmvQAEopSKaAI+SNOolzhr/Z3CX+CEofr3GQyCPZIjK4VclWTOovgWb2I8hueVsc6PpwSvjsSRv+AG+36y9mWKs/kf1sPy+dRn4AjqODrfi7qLXhNMB9//EswM4zLG4nG2LzRotJyVk34HjaHAfrbUL6ZeHgoa0VKHLEQrZfec
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad23af47-4be9-4617-f283-08df2f7917d7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:04.9917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7IYod93JkRtVYKh1nh5/BYK5d5BzgMFNke/3vo5EOJSbQXsKVCJgENCfO7N8nOTxp8vrmgNZAPa8Y7XUOH1rbPsHe35aoCzwnqrEaxZEd0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7150

If the reclaim worker is relocating right now,
btrfs_reclaim_block_groups() bails out, because it can't either grab
the reclaim_bgs_lock or blocks on the exclusive operation.

Wait for it instead of failing the tickets while it is about to free a
zone.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 82d4ac418a2d..77a133ea6d5a 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -916,6 +916,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 		break;
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
+			flush_work(&fs_info->reclaim_bgs_work);
 			btrfs_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
-- 
2.56.0

