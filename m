Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941991;
	b=NmO7p008/9bN2G1B74amdXc1FKNRqZcgNhVaua6OGlt6l5ZfTgZLDvtRc2DPVwv3cHga
	 KvcDxrybiR+v4QSz2fKtwKqoES6d9S5xcgEKbBfgsC8AG0Dl18WrLZTlrtgP6mkpWDZIC
	 LeYZ5urzYWxZfvApiqFlS/H4JVa3CVmM2bCvhSgdk7E5zp2FzvStsoWugT1zhVfT+LXIr
	 PWHqo3wArd3Vq/VzeWR6FybOqSPsBzhIKPb3kHgPO1mNTAePqW5thDtSnlKbL5yZwGBuc
	 lQ1zjzXFe5vkXL67CTA/shFEOcb5OLJIffqe72cCzyM5ek2aRGaCkZsGhUUuGvYco3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941991;
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
	bh=z6Gf4PruU9VZV1UflkJvADUJTuGswDrIaIzDsQFxgVg=;
	b=EQrkJJgg44QWTBj+0lsyBBBjB48aqtxXPmN6nYCfjSRwoUZ0jBI2rdOhYS1mnkFW22SD
	 7u6eqXX13LJYm5Ro3nNykPkpvtpJlTKAh+QeiVjHij+Us5cfpQIUb4+XwDc+CTwI14hdj
	 dLRMgKl7Ey04G0JXlkhPu7Glr9d+nhs97Q29w+Ivmx7yX00Kwr74zyOXQZeX/FsOyKC15
	 ED0CYHHHPVEb7Ajk/uprd4pKfayjTaRyzENvZMunbb8S7gUXtFKsq3nqAqGHwmYtlbpls
	 gWpM8KP41YAIaT8cP0+KTKEKZ6LZ0ua1Z8wBhm1mi8YXyxUIt24xy79lq+vx7qpXgkw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="LYSEl/XN";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CVWflG0D;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220AD606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 220AD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LYSEl/XN;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CVWflG0D
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941998; x=1826477998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EmqQPhWhRFm9PRczsrWfTFTdBKAvuvJO1ndHCg7WQSs=;
  b=LYSEl/XNRvu7yZSQ1zPDOQJl9CP9Z4LJfo+kJEpaWhS/Tzfzgn00OscZ
   AVp1MI+7p2c8VHgLHgDZBg6Krnhsmt5UR5YYpbLuSkVEODLks22Cjlt5X
   GQ3eFlgd17hFmtw1CwiIWcghWrD6mo7o2B2JmzW8vE/w8i+dDBsJ9yZ7n
   R9mGbxFFRmdS23WB7VB4qr9859BQKvzcxDtd6lIWsYxuYp2o78JHHb4F6
   3nU1/wpFP3kdiFpprHbqP1ZveKfSVSVdzlBPA215FPfkeDN8ltJyjxZJq
   Mn3Lug3uUPFo8GCWqFufOce03srrD/xmw5fW57hHxrUK4K2d2wAC3G7dv
   w==;
X-CSE-ConnectionGUID: G3bC4hzxQgy7aTSNoxcEQw==
X-CSE-MsgGUID: e//YYQn5QY6NeRJxXVa9sw==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160149002"
Received: from mail-eastus2azon11011058.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHRCayh2QlueOInuOgC0Uy+UbA3IEEQ1amJal82n1j7zpQa1n1Ww2XdaJ6ES+YW9ld41iPXKjyJRh86ZyncplgXSGlwUpNH3FtcsjoO0p3Sp4zuugUMAUDf/SyJcnGBINkgpWt5zKcTkYn6ZUnkmLFX5r0Ki6dvGgoMZiHLXMmP6Gq9t81PEs1WzE8kCkRAOcSU33O9Ifxg2yGY9pjW4LHLulv8P1tCyA5dSrwrjE0BD0CRP/7kNm6YK0oJ7FIZVnSwf2KPvjFiWuji87f641gkOgvZUjDS7CEUq821RHXC5spLLYt12Z5oX6oFxC1OtI5QtRiZdoax6C/m7j4Y6WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6Gf4PruU9VZV1UflkJvADUJTuGswDrIaIzDsQFxgVg=;
 b=XtT/SQk3IejfGegIY20//ydh2OBje2k9OIwGINP4mffsPBd2LsKiyKbzKFGvSgeIZtSEY4bMRnYDrlJC9xBgZxW8AwsE+7LKOz/pIeHpBloFV9x6OCD9jV0mTw0zsW4MMIQw+IGIIGfpQEHVeapNTQf2dW6N2EKJWnj43NSKC/UILhKu7asS//1Kv5HSkowt1AAq0nlivXSczt2KZFOvtezpXyPGBDDbmAQU9S4Levf30gAQFXc7pzfpwQJ8dKaX9Ry4HmDZHjWwsKi/QcbkmL3RBFj2Z8sWSCbpljeJebKOuzzCRge9lQMbFulYInNZL9ErJqFSCBJAwTBdjokibw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6Gf4PruU9VZV1UflkJvADUJTuGswDrIaIzDsQFxgVg=;
 b=CVWflG0DjNGOhmu8ke1zSm64NRrT88j3FinlNroE8DeV37tm5smD6GPsD0QNwrgTAONmmQR56nWhin4a0v0U48REtpHtpRj9hq3ZYT9g06BemcuNGkuWuQxZ5Jcz4d8LQL/B2TQ9QrPS3uRydSUEycOIqGM1llLUn9sQc4cYxK4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:48 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 17/27] btrfs: zoned: don't recheck the reclaim threshold of full zoned block-groups
Date: Tue, 17 Nov 2026 19:58:40 +0100
Message-ID: <20261117185850.4128157-18-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: c9aa2b19-4b90-4e23-1637-08df44dcf3c1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|5023799004|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	PsUdKi52ICmfZVK6hDCzXkAMH7zjfVoFRtWNRKR4622lCPg59MceCWcOPLXLqg2qCzVGoMl8bodwo7/Oy3+jKjmxlF5zkWqJyv1pwMb7nGu6sMo4v42Z1i3sUXR+2p0bQ8AWagC1kcZbe+J8nlsut/gM1f08ZC+IjJtTeB4risEVtyg50+88lNhis0wVUNXlQ5CfDauzYFZnvjn6mJ0VTk2m9pfa/d1IQy2hdlnyDIkzBIwJq4XLwDaH2At+6hkoPgr/O16Hs1hLdJhAEu5xbJVpWYo8rPt+Z7JL+HBg/lDqCThgCwSu7EXboll2wXHsdWnQr7VqxMDi3L5B4RzByORy/HGL6TbGYauLvfpM4ISkcNVU+TnrjpiXrMbvRH6YHFoTGcHtv3KZcbMbAIv4CYbzEz9+O175laZCH6w9HNT3fLF+eS3zNZWQZdcA/pYBDzpqfwjGOFmQrDcU3WZabQkT1YaIPWxd7P/FSRTPgpWkjs6bQvgyja4Da0icDZib2xu86zyQCy4qtp4PAY6oHeisEUfmN696W51cBNNm9wl7i3b/MOuKrvJkxbZgZQQY2/Ol0i0T/h1W3SBmGlMn98W2pEelavLlr0uwt+ePFKvIn96Azsvfbfjd30Jl5TQl8pahaKOsp0eHvyNeskmFak8J6yn2+VUkqrIwQBRALbs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(5023799004)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Yo0lNodZxP1mADsqqbVdCgET/GFzo7qiOUCMjx/6f9NQjxQQxyYJhdje6Cc?=
 =?us-ascii?Q?JVi3sqGL5HFCu+sJ6O43SvJWRHeCHfQ9ao4oeJegSILWU/Ye7VDws99o2MJH?=
 =?us-ascii?Q?zsbDqgsvTfO+HqCJNE9GD0bo2xmZYLlKl9dlsX4mwNwT7rPBwFeSkJeBtvXy?=
 =?us-ascii?Q?wQv8r6dmac6Qdi3bT+u5K+HYe7a0z70Adxroy2pGL3lkCqa7LvADaoM+wNmi?=
 =?us-ascii?Q?fPIMmvJ/qD6A7si1TRMNrQXXdb6pVDf0enZZPxVsbvcSZslLjapWLtB9i82f?=
 =?us-ascii?Q?T+nSsmvqhCt688vX/mqlvzOIxYVzmdeL2UWUHgRTfYrfbGxj8yUjBiGW4GIK?=
 =?us-ascii?Q?QE+ZYn6N1JEMzZx29sNaEBaMJtmSEBDXkS2OISVXsZ2zcFN2yUN+431x2p6B?=
 =?us-ascii?Q?qMI5fHT+l/iBcEcdQosBhkMAlsvlRWx5DMFCS+D0y3XDtSfU22W7nqEw89AZ?=
 =?us-ascii?Q?b2aJ4Au7xxsn8pdNkNq5LRBkDafyvkDRUrjDCqHZo8X+ooN8QpOtuEasrorU?=
 =?us-ascii?Q?cZ5qr6cwQDa0WoK36e8bFkes5DTuTEcvHt/WZGV69QKGh3+3ovMZMuZ9fe0P?=
 =?us-ascii?Q?1ZB6F35Lg8LEJK4HyWWLbqzbmZdkB9JnLLWWfJpbTXQhoscIkVLj9/JkE/8u?=
 =?us-ascii?Q?kfOXZHnjCJL1Owe/aj3uENv4LI6khGgHkGsaJT97MRvPT4L6uJwBJRHZ1PI6?=
 =?us-ascii?Q?Lpc7wSrCcSfY5HhEr4rF78V6FlHMwF6S9EGOectphsj6ht8yPDl4taug6tCH?=
 =?us-ascii?Q?C8SK8zpxuS0aDNM97XI2rWz9CZUO8dyXLm9JqflEV2TpgikrNsj5zlzHdAfa?=
 =?us-ascii?Q?lzvO/Kcs/vFjIk6NoSnAMQABxl6t0oZE3ar3J/pJSK9Z0bJIg5LYe4jEsod4?=
 =?us-ascii?Q?6DUC1RRudGrUlatIjN5iJqW7sWf6Il9x11Fp/BXVLpHeh9ulAy9moRgXfc+k?=
 =?us-ascii?Q?Es6OWIsy07KzDxxuKVAsFTRVyNmiAlB6wQ3w/apuLJ19UzNgRmKiHv0zvfaY?=
 =?us-ascii?Q?hiUQjys1pQ3a4MWStqT0pecZ0qKobEridDOsXNrot7VAF+OuzqDQkm3GCGUT?=
 =?us-ascii?Q?kVMbp5gE3HR/G3b0mlKt/Z7HlQOOnQx6YxkByjJyZPZfoOeGR/Qk3Pk1Neee?=
 =?us-ascii?Q?8LYqyjib3suWyR6FFmG0bCOyPkuVdR4UrIgYAikE+nUmNBY/e/Qia/wa3Wiu?=
 =?us-ascii?Q?RiTO3oLd9gurf6aAIxk5mmYUXjUk5QY1GlAvyyNcoUqr9Jq1P8px70DonxnO?=
 =?us-ascii?Q?kwR/UEHPxfczoxCiMkPfw1IDzyrsnymNBa5OeU3RdDj+zjDxTlmpJwESoLp7?=
 =?us-ascii?Q?+BCuP8S6k8W4BzP8J59CyU6lsRF/YlyVE1ub8uDdVr6IuWfaWmj01XYPt4PG?=
 =?us-ascii?Q?nbbQZKPu1ng9hzepR/G1um0OVaQSdU+i0qZq+NNiSWgWQEm9mid/LmEC+TvI?=
 =?us-ascii?Q?/WoCQlbeMUIR2WFlajWw0EDgjN7WUR2uXd1agUwjqQjZK7YNXEjffGe4Q8E0?=
 =?us-ascii?Q?r4LaPaZGlTmmLFS2V3xlfoPA33H+vUticmCMK++dMQYk0KFoPMZQ6J3VMNPv?=
 =?us-ascii?Q?+ilALw4bGiaSN7254PtvslETXh5IllZ6SAM2uDBc82o2itvjz5CzSMm0YZe3?=
 =?us-ascii?Q?IcJPLa00nb0AAjWZuNZAFwMqGiQ3OMidya02bbOOH8OqCvbfc/D4+TxKA4nw?=
 =?us-ascii?Q?wYXppr+CKEYorQqKsO5TO9FAsHpDaiG1//MhKlPtlY2hfvYNrOOsq45LpzVJ?=
 =?us-ascii?Q?r5Ya/UZA7aRw9LzcBrBpm61K0AF3NtHxWvpzc3F6yRdpbdn3mRHV6GCWYfdm?=
X-MS-Exchange-AntiSpam-MessageData-1: L7xE3DpcsVBVY71k0yCKqfiA7L44O2eWv0E=
X-Exchange-RoutingPolicyChecked:
	KTCnKKX4wo32AFMWgfkfPcgQlFKbyW2E0dbJY3KNWiodM9PkWqdHc+uSEf3tjOnwSfSMCTtKL9T6FbMc2y3uBbu0Lk4LW9Kh+0ZvLXsPJLkQkWCIYoCMG5xlA8x3sZ0TYGL0KVRE0gZbZINRHvIMtO6Fhb9u0tfGAl67qexa5NEqvkzbrHvUXQgfmFtwyDZFaSmK35qec9xGZxYksU3V1BFLJVka1klMlRcnNsOnpSogGkrF/o9H70NyGz9JI0X5pSBWEUB34oZ7Dl9tJL2e3Xf9ss+AmGfbZwYWh6WVrf2ZO2zncmhEkG6W38WyUzcsmzb8cUHs76gSCEtioRia0g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dST8/x/T0OZCS7RElllxgrIYyB6hpOWrG7gH0yeK6C20v0CUaFsvrq7q/RZ9eZiSLQHNeqrk9QBPCJJj+3ch3ATJGY2BBU5/xVYlUnNPcCtGZOWjcbxRDPRTxv4/0QwNQNof5QnyFI5JbFb+OrGlyH3mTSRc4mgZGGgmJSAq8EbQ+eGveZNq5Y3LRtsWF4m0JrkTUFZdODO3EJwM124sUNS2tbqKlYoWI1Gk+ZEpk2hhd95OXCTfHoB0BwGTNNt8hPIeZ4qkmhYmtfeyXMI4DaRbvxIMqYENzITt9tx3eJnL2dfrZNKSp8mZ1y9Kju1P/d+LZv1M+E8KzXg/Z15UPMeupiwok7CBu8ymPeksSVfJYYrPZ6Ig+lgDbRzS78PmhN4iTo/v4tScGiE46776sugDJuOztJYHct8VW6U6sQYg4p3bRsX3XivLpdrpHlmCNHrd8BWi9fARbmE7CI8g0x9zJJlYYn+glxLRfA2RspZnNoyZfdpNVvlBucGv641xBc0P6nlFrAD12WYCdZMtKia3yvT9asjbeDFVBMJRr2cYbyW5GGiB425Y1zPwG49vB8DeX5IH5sZBH0uY9shNKIWYEflNisC4HXSXkyjkA+3iDary2En9Gay5nsd9U+UL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9aa2b19-4b90-4e23-1637-08df44dcf3c1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:48.5332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnWectRds+w5gDscb6TMazb9LpZJb/oCwxn4KCSM+I6SloTXJrTE2hrLj5ZDfmwVsc8ZOcVFxq7hZ+68JZUA/2P1uzcq6Hn6dHwZAeiAxw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

On a zoned filesystem, nothing can be allocated from a full append only
block group anymore, so its usage can only go down. There is no need to
re-check if such a block group still qualifies for being reclaimed, once
it is on the list it needs to be reclaimed.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 625f3533ec09..6697eaf995cf 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2007,8 +2007,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	 * being freed, pass in a fake giant value to skip that extra
 	 * check, which is more meaningful when adding to the list in
 	 * the first place.
+	 *
+	 * On zoned, the usage of a full append only block group can only go
+	 * down, so it still qualifies.
 	 */
-	if (!should_reclaim_block_group(bg, bg->length)) {
+	if (!(btrfs_zoned_bg_is_append_only(bg) &&
+	      btrfs_zoned_bg_is_full(bg)) &&
+	    !should_reclaim_block_group(bg, bg->length)) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		up_write(&space_info->groups_sem);
-- 
2.56.1

