Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793085771;
	b=rY5OnTU8B4vSzyfuH2ZMiQgNbCxcwvhOsW//vZi2PygGzf0VeoViN6LPl30QIwbe/lR2
	 0txTelCWdgC2GHMOCY/CvEsmNPGb0FxFk/x9fB0XkbkuSwMrnZ/Ucf+trwxy9oeC/9Vpw
	 2rwZELNJkqk3X4UB01WQ965b0zNPEr/TjB0BoqIT+pdaD7hx4ize55ZTOXZ6P4VyUe57+
	 nLxOQ8Sgf8t1ZK+EGvmjJHC/p2JfRskCzoIYjiAFqto0VnTLnBjQiHI5HTwhSPiKOQ37O
	 yuhhOXlOnFFWHNRqwspyzaDcRLMh2UzT7oGxarDBJMnSg/soz7aoTKCxzMWgMQGoHBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085771;
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
	bh=whodNtE8dB1gCIrMV18ykK6ESACrhUgYnlewfBOv+C8=;
	b=TgaG2NPG0btguFvaFF93SGjMuVl6r4G6pNxRcG8b04z5rkSkQMT1Sr+q9e89V/OZOErN
	 gYFLyWHQnAFJmrwzysQ7A8M5bVEY1EFePcSaEPlfA5XOoZH0iAa2TWFJaly2fgwN2pWEf
	 jodkGUS+z9AMU185Ihf+7ZcbOAL54yh+Va0k0Mqs3jTlX06YncqTwu3rbVWf1+lJnOqA8
	 qCIg6bv8RLOVcefUp0TavIhr/il4xbYbHyf00WRPwKJKTieYmagat2r+zmNmvVV8Vs3h8
	 TTTO/5J8JGICk6WEwPmeRFSjyqhGIXLomp1HspIrsJ9DYVEGx94ZcAedPz5KUmWWi6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=n2l6AZJp;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IWIzYYqP;
	arc=fail smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6960C606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6960C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=n2l6AZJp;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IWIzYYqP
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085772; x=1824621772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=G7DBV9s/6MLpNUgbdLkKnfrgMZgktrMavRgHw4PYpbI=;
  b=n2l6AZJpb1Y9kmpBPyy6bSDX1Jm2BOVPvT470i8UDJka5lNXrRf4qgdz
   50SqeeYBYfJliIjOdUGf+a2PHJBPXKaqeKx+Zg7AiqT5Z+Xjr2x2makYp
   UuRdgIf0McmO7plyO8YQA8dhA3yocoaMn5XMilYJuU+GOGUcXzKHLii/g
   orEjLnE5kQHxqxkLLEVXiyxZvEzgwPXwNyzcX6DRtF516orUws7mSe1Xs
   7JSbjExo6IuYP+/NWwLpuxB8Ip5fs1IIhFZHeAGnJLS1UjDQmRzoT2Uzs
   sohE3s+gF7lVmu7ARFytWYfSZ0nI3PSsihQ00msZXHz5ncBjUDY7A2qc8
   A==;
X-CSE-ConnectionGUID: 2qWAmiiJQ/SWG/PqIWZSfg==
X-CSE-MsgGUID: 4AkLeweGR02kpbc83pgckw==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="159092288"
Received: from mail-southcentralusazon11013061.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QIaMx0ggoNpttQFdArdTlqqGr2HT3M8pbPFuhx1NugZQulK+MVhPa2QKg8dIcMuRmW1lxWrMxyFrzBdzSruAb788kTYvv/u4Z3r5sUzIqn1iqoSS1zF7++nMCvBUziOurspw91U47fyejaxYHwPU9zh760L7Go/J9qSomaMBv5tKHL8Ej4RIXQgbJrr8wSczfoOXmY/sDGuNH8A97DQlnXwl99FLHppk115LdOFFnUUS0BN+2m232QT/4qv5hjtvdnJGaJS3o9myouEVlcwZkqvQbSePffomNRIRaQ57v0MlEwWi0c8KsqCyVR7AfvlbuY3qs8Gnp11+kewjj/p27g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whodNtE8dB1gCIrMV18ykK6ESACrhUgYnlewfBOv+C8=;
 b=vJrmw00tzASOZSr7nE9P1BY+DGnixiy/vHRB16P7PS1d5t45mg5e2V2NwgSAHqE55c+eXa2vLnz9ZJsq+lCVZxVKikbdNh/f5NwmjaNISYCZQ/U8kvTOUAZarcdM0WlbXK72kYTDfuORqfFdN9ycEZX30O4ehAAUa6kN8ZngbGk7O8Bkia7wyuBWaGuwXAvzSklEaZdjWA2ZheqAqIxV8cWxOxEk9v/wYk2gUC/a7QmRAoAIIbSht5DXsXj0HoW4fx9eTvDNaHOSzT5q6icTu1jR29gRVSugSGiKheYL1ZslMdtr4HzSX1mBRwQLrCph+xYBtJbKFlvWoohfJtvVGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whodNtE8dB1gCIrMV18ykK6ESACrhUgYnlewfBOv+C8=;
 b=IWIzYYqP4Si3psmpwwbg73WQAdGr1Oohtmk3za5wBrUXkqjQPoTuFOOQdxCCvrc2MqAm5VU9/+MCFmmAs/bfRAceKlWnU4BApIexqRFBld/edJmWqqn0ea9lw4hqdzsGvbJLrRUNy0Et1vLIrCtBXKKG/ta43+ifw26FhtdnFq4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:49 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:49 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 02/25] btrfs: zoned: don't activate conventional zones of mixed block groups
Date: Tue, 27 Oct 2026 08:22:08 +0100
Message-ID: <20261027072232.419318-3-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: e52a1cfb-e632-4688-0c43-08df33fb1adc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003|260925021311599003|260925021911599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	0etRKzE1bKxoojyxppOoeVP/pKS33T6MH7Zn3dazpEyTIRkyDpcRd6VwZuDACPFRqfugu6CVI2CLHTSK/fPy9UoEH0NArjDt2yi4Wl+H3FnaXnRJvmtnKOzwJQFcxRwO4fTWSgUbwodYBHYHrW3Hb1teg9JPvXsRkZIM8pHzNfpkRycaXL+ZAWby5rm2W8sIDkZGCkKa+cAxpugQF8C7pHzR9tyLZX7U7gpE4Wg/DHSaYLC7IzTk0+dkUhHc6f4kWm8QAN98nqObIKcv+JBaBxOgQkI+uwN/y5DVv1N6mS7OxRaIMFTorASNnEquTDOSWlBnQStAYcVYxVHnTe7Jt0BVKhk0/GZpvSLovfAdKWUMLW8xmdU72lfQV/y7lVVdL2phjD6KcQ5e2dx58shn2L2TIMPuZLT1DC3CDoI+jo2eN9jSJRPaC2YqYlJ8crEOzuqU45/fEH1/rKCF5gQN7rHoOZG8kC+1jvlie+n16Ay3VsTRnaI/QcE0/ZE3eQmgmILTJr+PgREJSV8D8QzQlUAsjo3NYYrV8bobdokmaGB7S1PW/lAFtuonD40FHOdH8KqZAz5H86cWr32vZEaF2UisB/d5fZthDGo1WBCsY1ZMm63Uu9sD22bornFZVcDuGrHgyNxK1tejtckn2CiLgTaP/Nv+oFPSj3GYogVnMa0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003)(260925021311599003)(260925021911599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6LdbzqTj0Gr7h4Ldhe1F7TMz/NdqECM2iLzl6IvoreQCpeJb+gddtKk8uFWT?=
 =?us-ascii?Q?1sA2rSUNj5PzgwTB9EUKocFC0eacq8mU7x38qwg/nRqr9Me176XhCqY08os9?=
 =?us-ascii?Q?VQVy6OEFtadNqKx/k+HibfMFDv8NEqIqumQq2q2Bhj+QU3fyH71B+ZaB+jGK?=
 =?us-ascii?Q?xLrGSkYvhv6R40BSPqol/kIKNsnxgIAqKr09yuvxQqhLdQ4z0Eg6UCWG+8nf?=
 =?us-ascii?Q?waTek6rVZVCB0hi8Bv+Q4YnNwG/Kdanko6VMrtrlDnbQM61rOol7jVrtlpfr?=
 =?us-ascii?Q?4RI5CuZc7JAWjfssPKFY7wzWaiN3lrSoJXWmXBBvoWWPA0MLjSWrQs4YWMc5?=
 =?us-ascii?Q?wsRcQRJZxYacfxaPd1bjiTBYwHcuBLVPzsaqdaaVn52lHge/8u832bouo4eS?=
 =?us-ascii?Q?YBh/kDxLwpPKpMKEK4MCugEWn9i3SMzTMOK0J1OdSc3QnmKo/ORVmsNF42rG?=
 =?us-ascii?Q?G/4ukbfb6FMIXJQGFLWcP5Ub2zLwUK1RWZaPQ7Z6fs/j2ilv+H/+LLMBnSa5?=
 =?us-ascii?Q?a1hz1QUNAgJftXgvKmUr8tGgb7UHWATJlL67GyfYrU18QYkRgYUe8DsmYcFa?=
 =?us-ascii?Q?CmwehQpDqazpOk703dm6Lfur6ue2NW0gbD1rLR1h/Qu2KuHERrpO1vxfCKll?=
 =?us-ascii?Q?UetUJdB23AIt7IKqR07LqGO7AD+OaSVJEv7tVguj3foyhAb9rZkr6en/wpQL?=
 =?us-ascii?Q?YQzvZUKiJq8QkhkKLBfoTSvzGxoZVkXVO5FCWI8QVhJjiWuo1coXvA/5WZfP?=
 =?us-ascii?Q?ZkQd1JLifAO61qcuXqWzEit2QyJoQ8AdQvvATvtBvUkmKB3iMuwLDWwtQqTm?=
 =?us-ascii?Q?AyRsKD7uphJuecAbmxvx7FTCNYTdUeRzlVu4wXhOY9ZfDqEf3pjknDg90Wc0?=
 =?us-ascii?Q?Nbj6KNS43qlaYR5L/7fkb6PUT4/h3K/c/bznOMeHE0ro2ushouDeUOYQchT/?=
 =?us-ascii?Q?8wE8HWWdfCKLAarEVrK8/+APGJG59wfcbx3PYiCqajdLe/RT6zJLanODsH34?=
 =?us-ascii?Q?NBx1XBnyqby/ZoaJXlwGq/zIGAmoyvpOT44B+ewUKTgni3HcyKHejlJbkVjE?=
 =?us-ascii?Q?ANb8xobw1rfJ0jJK9gwGwdgBixI9Iei5fLvy5+AvT2uPzl3jine1H94Fe7gS?=
 =?us-ascii?Q?PvqMy40zAn5wYQfujdpMUqm7oCyQBjwp8XcNcSM+UH3YNRQHlraAwW/nloow?=
 =?us-ascii?Q?bpd58G1Izb29eMkFF4k+Zlv0T8U+I9ZBWOcO6Menior2uWFt5oTlJCzgOVZH?=
 =?us-ascii?Q?HtgWpOpT6OJy80MFtc08loDENTTQ1C0wBXqYJivSxZ3ejpjBrNprsIWermpj?=
 =?us-ascii?Q?UrGSEMN/xofn4emfb2ySGG7xvazWbyQRi1Luh6EihkaLJhaexrmbqNNYcEnd?=
 =?us-ascii?Q?A/mutImuJNZ39XFihyRnm6foKkmxOrnExcnRkCCivsp0Ll9kx+Hzek6wCfcW?=
 =?us-ascii?Q?O5GsXy60ANM7nXWbLVl727ZnyTIK6oqV2uN0/3xvM6mTQEfJ7DWUYWXq4+9n?=
 =?us-ascii?Q?F7PSwnqk5LKG5Q7wEJfmtLaohPnV/p1DO7v6uxQTgDEAHdnO4reUc/lgENEE?=
 =?us-ascii?Q?TmvcYByCcxxQCmLBTkIJ9jZvqVE7eyg50GKomjXYrG1/N6E9VAYRjslRbAzT?=
 =?us-ascii?Q?KwhlIgTuWQWMtfJq7jmr56539tX0hlVB5CTGaSi3TCOiJTjW4nj4iG3Numob?=
 =?us-ascii?Q?52U4ulNtxj25BBfpVBZNIH04Pg3QCnvbMujTa6qMS8g9ND7qrG3vj2tQKg67?=
 =?us-ascii?Q?fCKvygwTl+Ov5n1ERCblx3cJKHUomry5yw752KSquHtbzRSZK0cWX1/sbyTq?=
X-MS-Exchange-AntiSpam-MessageData-1: qlG2aDHdd6tSFLZPL775+0BoIotPVgMNOOE=
X-Exchange-RoutingPolicyChecked:
	W1nPCc/qadmquST+8pvntCv82+0CIdsQKGS0F1ABrl3cE7Au9Pb7w+PDuwSY7vTI5tPHslhP7yK5/Y+S091zXjp/Po/7psyWL1+Xsry2eCK5qH7JHy6+mUxLI0M/lxS7P5/j2WRkt13F0qtB2nbYyV+TiiU8sCUPYAKbj6d71/TS/dKreMyyX5oir/FNmBbz/JxIArXZEYnGT+215jOoSeWwo6/t4ej3qRZvZwdwaT8LuWFLIfEuAneYd2Ho4xa9yohpPVExKAZqSxIFVVQ0ZixvnD0lu7SLpUDYY5wtwp6ZJPDyTK8+XwOYlFxacCWN21qhBroiYrMVj4fXj33epQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kMjlyEAwH3gFTHjncFGgSKF2tVhCVtdi7uyvi0WLHIQ8V14V9eBjiQSkt1KkpLw5pjGY67Q7ZzMlajuU1gx4QmXcPY051zlNnB5eSzrMj4OnD0MD8hQ9GnMiItKXCJk+M1Mho3ZHsJrpgycRGli9xAxw0aMLx1S1aGD7KLRbDP0Ny/Wp6UpAmzVXUnSpaLAOgQLYJVUPV50j09+3Wwt810Cv+dN37qkMBYUYgAfeek241IV0vDb1+Ul5i6WeWDbc9Mi8Ln2/qgyL2qJSTnFlzBSTnrG5qaCkyY6ZDRXwOoxuKoaSSqw4gjPSsYkyb4UvICUkUl8yiiZPaWs2WIyRBxo3K7QjCGKUfJnf44YqJiCkxCo6CgG+bKr9ESJG9UCBNko8rzNmM0qWEQRXKZ17e0J6I2MvV75Hego17jm2EtPTMTZvy7vP3gv15cTh7VNHRiC3ujCnhGfQpPgY8qgHVfL9sU464CLPoLQ0BXMgp/Qnd0nD+UK51Y0jR1mX1e6y6qN9y8SyN/WFHNOcyGv4hJDfpNz5unKM6IuRv373LvKbiH9R6Hp490HpdT4uue/nB59dKJvJTro9MsJWKTJcpmA3mYUk9UfkMnrPsXCFzwyzxK2tWG/fXF1GCs7h6Dv5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e52a1cfb-e632-4688-0c43-08df33fb1adc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:49.2238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jg4/MsQOdYne7/cz2q5M0kqgTyhjTaKFLuMVsDFRZ1BRTcUAdrhACnEX7SxYqN0uGdymJL2Vmuqibim9R8Q3LcxW1T8G/9zHvx3Ukkz68Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

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
index d24b5bf026f3..6991912701e5 100644
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

