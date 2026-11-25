Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602676;
	b=2okq5CeF9qACd/lndTdhjAQ2m/AnE/2fzgnnb1Rq9qHhbn5m8TOGDk8zpcdmUD/hKRP0
	 WjEgEr0SchUp+pS4Jm3i6WS+6WxX9nOoFphLvYvDXukWlzRF7LgCe38lbszNvDvZp4Whq
	 36Y1Pn6uSUiP651dCmOJtuJUeQvuTaYQxzzvyULSsORG2FlV/a/0JYUZXDNMvdJrUNANK
	 TTGJv+PNcFnRSfWC68ZW/IIOBKK0EKOW31uEBe7MhVi2PettSQAmmp/5bk48RanUdeFqz
	 C77kIhfIGF5UHVrpFpNdF/Twm9k/sQpNEbjLuyXnNHDdD+uXhH2VeTtlrucxrEIJtPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602676;
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
	bh=ACxFy6P3i/w5vx+lJGcrDYw12jxp8zHMW7XTFNUswFc=;
	b=sGorrVVEb/Gmwsiw8lZJoEkiaKccVe7R7PcsxgFlyadphrqpUaPeQJofPPmzn1p8/2xe
	 lJbeNQQvRO8oR5vGLw8rAQx3bBKdqNTt6o4DzMXL0CpMTj8PDOjhGVQxanhTYifTK70C7
	 H3xaDr4vpQscIvi4r1VQF4mI3oCIvXT8ng7RuAuEwGE6e9EAdMQncLSno1fpmmXPPEvP6
	 tNTvcCCO3CvwomTLsCwqeQnx/kaBzIYYMeSEH8QE9VKS0zqQgYeNEpcAYZe+yFZchkMUd
	 PRObSzEyfit6Lid8uN4PEHZWkTcuH7PeEcagaA6+iuHh+DmSVyq23XxUzXICpFVla/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=eVng2dzP;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=tvBxeYn0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86CA606A326
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:31:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B86CA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=eVng2dzP;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=tvBxeYn0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602675; x=1827138675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zMs801B5Sum87720yeD/SQg3eH+dbaYzTxgE7axEZMM=;
  b=eVng2dzPlNghsvVs8mw6u4I75Ci9zcMJkBBNQYUgSCB0itHWcWujs0hz
   9R7MPfxFhjDrk/2zIR/Zkijb4fOj5jMUmhpnyePQWGHpUesmRyUQbVem6
   uygWu/ehScUNre5BfqS4JMVVPkVlCpl1rs0p2ifMoeYS7ukdGjCgkv1tf
   OgGOd0dyqhRUDo7NXt65X/ZOvoIal0OUGsIGuwm0SbhIwtxkpIU8g+xgW
   CrfQ295koCCnpSFr/EefayyThtXhVbFRDmDb7uVlFVspZibRWE88UFcGi
   hqdRhw+aEpOAkglbTXbCthVmPR8xZoBoUgkLC+p3Xk/07u6iwUsvbLUwi
   A==;
X-CSE-ConnectionGUID: Gou00Q5fRRGhqZaIMxusMQ==
X-CSE-MsgGUID: VzvcO5wHQEKLZEF9xNhApg==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492466"
Received: from mail-southcentralusazon11013017.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.17])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:31:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UpDF5LMup/dFCCHT+IsuTxp+/swDWU3xBU3FYsETdkpSCGtVeICUIibhICcat915gSqcjnksRKgVdzaq8VBIT2lKiKZSRRwI7/7Nsq0NAg/M0bQPRNUf3r4q3y7D8OIse9Xb79DtX2SVxPO4j6AYH8uJuMa7CXyJFwY0qvPguPJex6tnllXWYZrJHUxXDiRYAJFb4vG6O+5eK/fiDBN8tWiPkaTtiTo94tBafKHJ76ksDh8FlIDaS1bT3oATJHykM0g06UuDzJr+xv7Tp0HcSFoLFBFEw9y/t0klCNMWAkiOa+I7gatJ0H7OEoKpmca/iwQYrATxsJL1RWK6IO90gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACxFy6P3i/w5vx+lJGcrDYw12jxp8zHMW7XTFNUswFc=;
 b=VxSK1bNp6MLJX51lKX6bGI643DCAl469i5RCLXztpffbccdBTMR4ze/DjUYwgMrQ/jn9yC48O8QdjdJo6CmJZbH6Ajeb3C64+RIjHDakduRydcayF2H9NVmbLlR+pm/R5ka8BieFV37GmKjag2IkX/lP9+sGK0TKDGptqpwYJ6mfu769VtPCZXsGP/I10BkZOTUaAOEvOKoW0HGfiJpFiYA3oRdSa4jS5NB/7tkv2f2upHeHtB766efAYGKk3wfMgiaK2yxdfEdPb4wZyEYpdOUvClE4OFOFWP4i85DGjCVARq0uVGXbaSt0x1lba/GV2BA1e0bzMKDanaBf9T77VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACxFy6P3i/w5vx+lJGcrDYw12jxp8zHMW7XTFNUswFc=;
 b=tvBxeYn0veLB17Y9AjMoXYwlFQ4YbqoRZWOB3sto4K5iTGBV1ffRGpGYg6d6GTFVTWE9TLkot8g0chfIBXMQebpqTiKD2u0Ikj0KTRnw4o1fmao8EUY8iPzvxzmKwgf/TnITQ6SCCUkYnzLpzs//UGkEIx9KIZiBaEbiv/T6pqU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:31:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:31:13 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 25/27] btrfs: zoned: keep a zone free for relocation when allocating data chunks
Date: Wed, 25 Nov 2026 11:29:54 +0100
Message-ID: <20261125102956.266389-26-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: 48909707-0794-49b9-2376-08df4adf3a97
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|10067099003|261021123027099003|56012099006|11063799006|261009223027099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LQZowEu15rhIo2cV0G/ELivkA5RD8zsyo5CM5bNczLNgGIk+xk00u7B0A2+lpxDnhggZeEn/QsUg+8wk9SnNCgQLueI9opKMN3Y7I7pfNb8B1ij8HUJ6VlMFMWkasYaOMeRNA9v3Z6MxSQSLvLzhaH/dRckJH9HnM4n7iYws5qFz9GTd5hVaN+IqLeL6Uijqu36+pMQ39fbntZirzv6ogG6bK0JMxt9zP8cESbIGfjxiS7lGkih+fXiDkf4VtUqgeKSpm7a0MnvwSBgfOl+WBV+qb93nGgK9vmOJtwNYv0rYqiYiaIpcUpyDX3UNvIJ5WUD2EE2C8Ql0jGMia2WAMNfXXWOsc1+paVMLxqjFg1EM94hTpZMl3RF6KZjEBjP9qmRMO5NT8krxodApbeHbaZEhvI6jTRW0nbPQhkay3gVhKjC30/7AKiQwrFVPqgTmaVtUKLCLiBUDRBalQASWYSZ5aMsuGhp1HUBJ3LQRhuuWVQU32HYIx9Khdh/hOykXsqj6TXBO48KlPBp8gvv/+G+UMxX0b/OFU90Mjt5rTrvkKPFahWj86VoE4lPYbxxWKlxSRo8EFfDqjQGxkcKH7NYEGqL55uTbMWZKRdO96oufItluF81SQcAP7woIPxXfC3L9gFcYBBw4hwkkGMOz7wZ6raOT8DXVA+5HB2gcl7Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(10067099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xckQvwCgJGVPfbQ2fLqSCzwPNUfr6ZfldlWf5mOXk4pMVu1ZjjjvKVKoAyJj?=
 =?us-ascii?Q?sZq5mkR6kvMvRojlwC56NE6oZFoNzEmHxfOEKYMGXezc85EfyVcMWtv+5TGt?=
 =?us-ascii?Q?/oG7yRSIdYJY3sSBoO8tFlK1az8nFLqCbMkPCqwBI/TL4Aa26OQgXtCuOWoH?=
 =?us-ascii?Q?RgO3zymoywqohaYvDerUTzMUhzkUwyFxmJtlyax8Zmci3wKLWahNIHsEFJvK?=
 =?us-ascii?Q?Z23EjwzzT+BCwmwxY+f1Oo1Q7lxI2yEImqbWjdskyHWsMwGUJCJ8UrV+OiE4?=
 =?us-ascii?Q?05k6LUbTksQdLyxhrzhDE1cvVILOFotayG2AQR4PoDCwwLS9px2C/6uz7bvO?=
 =?us-ascii?Q?R9HcZOWTqrtduJSA4MDoK7GIgu0iICpgkhKl0e+xye1FyaRqdjEwtfDOAcJv?=
 =?us-ascii?Q?1Q/knFV8cod/N+uVVodHJZSmSic3dP4kF66CFRypTb+NOOeZy/86T1kXoZLg?=
 =?us-ascii?Q?CwAjdjjqlKm8SKGUed1O3VW3OW+v+KRGNwvSfsfhGkJ3atJMhabIH/LjbJm2?=
 =?us-ascii?Q?woE5niYbkGxwJ6bo8+7pD4EDVHL1C3zU0Tfxkqna5m7r7R/mFRHG3tJr1IGQ?=
 =?us-ascii?Q?93GRfh3BXyQRLUL4CLACX4Z/Tkrzkka3+42MMaznBzevS0rvIKgUgqSvuaEn?=
 =?us-ascii?Q?UEgdlC1zec3k2oMrf9INfAIlKOGMi3uuUf4xdf37gSR3ISTXvt2oiuxTH9U7?=
 =?us-ascii?Q?uHXkW50Q/AVwLQNcrpX7fKz/EDkwLNrQ/l3zU76jDoBr2xtCibmQ5NjhxvgM?=
 =?us-ascii?Q?3IqPGFZnyza7cv9ioGLAkxP4cTCddfJTARhnM5CVNVHVZc63uQLmLAy1G9vv?=
 =?us-ascii?Q?O6WMbOmFg6mxtA1GombM+/R5EyFpZmJyz6ALzZ3Pw0BRav2xSbQe8SfjX9bk?=
 =?us-ascii?Q?5+3Z5zCFfCPKWEqL98zmVDM6WgyztVtk4PIlJAvPmsSauHtfmRQW3v3dTck9?=
 =?us-ascii?Q?CiuW+o1mNS9CGxgVsSfP8ccMNxsDFHDCYIVn5wIo8Yijf3O18lnvCwcy104G?=
 =?us-ascii?Q?likQ+X3w3m1UIZuYA3fZxQm8ntnPX+AOQ8kzC1MmUf9BUkKSbY06oQX9bGfQ?=
 =?us-ascii?Q?HnZdcgSv80IOz5mxYt2cWKRne8+DsFAhKTjeYnm/t18DouThcHR1K029ESIa?=
 =?us-ascii?Q?0+Z3Pr0unU9tNMbmrp121pASPBpxO6wB09AV8C0J+RYwO/vqKF3W1/ES+6Fg?=
 =?us-ascii?Q?Lb+IRoKpKUK6jQ07gybX8eSVCnxuVjY0VGtX/hY8VzCL7ec4Soq1Nr6ObJBF?=
 =?us-ascii?Q?clHa9LCJrH7ykMDgi8FqU40h8Dk4YgO7G17ibD2168vMplp7AC7bTCxxph6N?=
 =?us-ascii?Q?un4ruMfsA6ZFZwdx9Wjpff6SJMIYHM0ttzTVDMoPLzdRstRVaHQdsYC5KZsu?=
 =?us-ascii?Q?Fx/+nGVKgvVqgqTcOJDf5X6y1b85CC6PRjYkED4mVasG1Oom2ja5LbyWiGLQ?=
 =?us-ascii?Q?aThD7OFSedoL4YtJTaM/vXeaAcaHdmSo6ODkaM4/XfPHLAuREXeYGwKo6oep?=
 =?us-ascii?Q?Fhn1QadUPrU+VSQuipH0J4yW/h/VWNTx8y9dqxmEJj1DZkQqkgBNNAeyjw9U?=
 =?us-ascii?Q?SkeUx3uA2G9oJv/yTIDG1UQ1bDKRMUqMrD118/M0c17xxRcdF5dC7p0ynKYK?=
 =?us-ascii?Q?L8BZjgKU7Rq/csHE0apACSmwX7a71woav3LVFW1NAeF1j1hiMf9HhMFSsFtQ?=
 =?us-ascii?Q?WoafIYQpiseEtAjyIrFZD+EEZVWi+yBvXG4uBt96peoBsQyFxPFo4R48dULl?=
 =?us-ascii?Q?EUnZBPOt8or5qATWbXZR8dsz45Qt1+BHn5kg7T5HhPjCKCYkg0NGRsI+oooo?=
X-MS-Exchange-AntiSpam-MessageData-1: HW9tcIcNc9TopU0/eOCm7Ur0k6hYSMjzzok=
X-Exchange-RoutingPolicyChecked:
	n4ef3X9mqgC8J/3CdpQRh4DP1rtmeJv0tYLe152hllBFP7QXqnE7SuZuG/Gmx3WwdquIyr4eLwKGrwGAHx3RChrN67zeBnyYqJsGdhXZvHLYWdlHoJX6bxj/KRmGo5/jpNHS1O3c7csRspVisNmFJgNgr9PrTNrbvvyfadoYRXiAm1DFuNICnsJizgDE6n/0tKtizttJNiomhmRnizC/Rmcy8YNx9iuoFrddGEDJ25PEY3rOO2wF3OMovAdWS6VVBHk0epxvJL9zb4JgMI9SJH198up3fXwY1lZ2nF5mcsejjDD3ikXPqxq0g/29IIr3wVGZ6E1QL0QVTmrvL/sO9A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+Vu7J1IbyIPvItNxisU1bf2IldKosAARDBV2iQ0WvXoOR6T10nFS6QUmcgrBqNwZoAIr6tO0xb5/a9sDzeubEFWUZFre9mXgAh3Fk23DGowW7eENhrlrxdnlFOKCjsG3FsNDJH8/gWieYp02Qd5WWuvj/k/mf9hDNpOhBD0awuSg0YGt47CX3Uho6vYJ9B+600LRuhSd3tO28kzbOM6n7vz7GZ37FYnp1DwOJM1ykF+aWoA9SHW0UcOjnVc6aAZhXlmCjZot0UAzXF0Vqdajielpe4daS20TZn6iJB7L/u0Xz6+m4ExXqM5n1bd5CGLhZ8o5Y5m4YAQepSnKb7kyLzCK5Xw+kJStg8P/bnvPoyQLx1JHp9SeLJRw2GgbC5C3HEFV+UFxKj99HFPU3W/FLQrsg3+pyszQKH4r8Im68gOg8pl259AN2PvkdNN9w6/nPR1BZpVTDhWe+sIZbm6Cm62Gb774DWN3WZxGy9r2sc8/UhUXKIdvsg9v7VWzTSxu+yb3a7IKndlq+HsldOhK3hfzWGiVNa7c1eEWqskh3aOEz44VjDQaZWPXWevew/a7LNw58YfRK5ful5rDsDAuViqOyh1dc1ba/pYU9zagV47iQa28m8hhaALuKos6aGpE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48909707-0794-49b9-2376-08df4adf3a97
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:31:13.2036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXJycy5QYNo9nE1KZ8/R2hpcHMeaQrhdiiSjt9AaVAOzH5TGtKw4lZCYT23CQYO4vEwNyZ5qKU//Ap6xPiusMz6/2qroyWVK/IVKIXDTTL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

When allocating new data chunks, make sure there is one zone free as a
relocation target.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++++-
 fs/btrfs/zoned.c       | 47 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  7 +++++++
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 73186c555dd8..a11b17abc3e9 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4140,7 +4140,12 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
 			force_metadata_allocation(fs_info);
 	}
 
-	ret_bg = do_chunk_alloc(trans, space_info, flags);
+	if (!btrfs_is_zoned(fs_info) ||
+	    btrfs_zoned_data_chunk_allowed(space_info, flags))
+		ret_bg = do_chunk_alloc(trans, space_info, flags);
+	else
+		ret_bg = ERR_PTR(-ENOSPC);
+
 	trans->allocating_chunk = false;
 
 	if (IS_ERR(ret_bg)) {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a8da6f6592f6..8db1e058e178 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3838,3 +3838,50 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
+
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
+{
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
+	const int index = btrfs_bg_flags_to_raid_index(flags);
+	const struct btrfs_raid_attr *raid = &btrfs_raid_array[index];
+	const u64 stripe_size = fs_info->zone_size * raid->dev_stripes;
+	struct btrfs_device *device;
+	int nr_two = 0;
+	int nr_one = 0;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+
+	if (space_info != fs_info->data_sinfo)
+		return true;
+
+	lockdep_assert_held(&fs_info->chunk_mutex);
+
+	list_for_each_entry(device, &fs_info->fs_devices->alloc_list, dev_alloc_list) {
+		u64 total;
+		u64 used;
+		u64 avail_bytes;
+		u64 dev_stripes;
+
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) ||
+		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state) ||
+		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+			continue;
+
+		total = btrfs_device_get_total_bytes(device);
+		used = max(btrfs_device_get_bytes_used(device), device->commit_bytes_used);
+		if (total <= used)
+			continue;
+
+		avail_bytes = btrfs_zoned_dev_avail_bytes(device, total - used);
+		dev_stripes = avail_bytes / stripe_size;
+		if (dev_stripes >= 2)
+			nr_two++;
+		else if (dev_stripes == 1)
+			nr_one++;
+	}
+
+	if (nr_two + nr_one < raid->devs_min)
+		return false;
+
+	return (2 * nr_two + nr_one) >= 2 * raid->devs_min;
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index d2011f764f87..ddbc93d0b8ad 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -121,6 +121,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -342,6 +343,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
+						  u64 flags)
+{
+	return true;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.56.1

