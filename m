Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031007;
	b=jXmCdMTSFL0dGeXgUT+Ruywy3IR5TtM9FnpsoZeOpsDaO7qoYqdsAKZusfR3H2ImesNc
	 JjKT19GG7typCEKFj/yzsOHaDZGxDAQ1EA5l4VS72aVgYwuxVgpytCr18d4b8eloinq78
	 tkbHITR1Peng/61X4YfGlAtqMlyOet8l59vWcKugfMY3S4puGrxsDVD+WDtYBYMdrJHuw
	 qjULOZFPuDEGMUC3YhnokRuBGnZ0bvpnf9pzsg3EBvwO6haTAPrCx75dxXsPTuf66fZVh
	 ddFQUEyzhHieOwrHRWBcYWmBFc9fQQ3I6cfMbLhRPKMk5sha1BEMdNKT54tqu+mvpGg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031007;
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
	b=os9s5YgGtyKyDct4WcmqYythlccKnoH2m9MwMP0S3sTXIi2ORLNK55khp/dAVhVJC3TF
	 XkcBxLHyz4H33ieIImzXvHTYabuCsJ093+qw/IOJFUqpdBam+jlarxrHtt3cPREEslXRh
	 I2LCFziXeqmGPu8qNvabKSgptGXt+WN0TWmNRkbjiyftfRB5Nw3yVIc9AEntgJwNfofu8
	 VQbNd3wbXo/UjEP9CqftipPUkbP2YDQhQutAU960/MpPUQK+GR7ZbL8H++W6yXc2JXm9N
	 guIbjIhGma2FNnZfOHTbu/LY3H85hNQcF1zJjHmXyUhIn7F790kbQu5SmYqV87QrC1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mI3yp9xY;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=bbiG2RaU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5CD606A329
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C5CD606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mI3yp9xY;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=bbiG2RaU
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031007; x=1824567007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vV7uTwbnL2Xi962H8HKrQSM2PsKcF7hodGI1MthiRaU=;
  b=mI3yp9xYyDg4vaBU7uFDkuHbs4UiZzQnmAszeQ/yLbN9tJyheYsqPJTA
   DJW86dzKgYWLKNvBqsOzSusARoGj/dRqGFUjiViO0+ZURXxZvCafrTQZY
   ZKkHrvsDq8hn6GJ+0iN4SompI4hW+JkP1jvR8Oq4kwrjsHhliS2aizjY3
   G+hw7XjFzSy1fZRB76skbJIx0Di+kuyvb4G0bZKvJJ9EN1HKYL5VL/sIU
   rTPfDgxsYUwkufqOGM3OJXoCMhn4zfuEDGP/2OYJO2SzgwiYXpdqsK3fr
   SZH1pbfIGpQ7SrrM5j6s1EdS/224wnD9sZM5PV4/yCoFrcPPNBZVUr93r
   w==;
X-CSE-ConnectionGUID: whoBxZCjTpWjtd5prU8/Hw==
X-CSE-MsgGUID: TeOtYhLxTS+n4LrJ3cWFZw==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033900"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yMo6wQjk8pfgvJ+cH08xVbInaOLY+Da784HsMTr7TcZv+AOlthillEwLZhkE7CQqQEPZOh44IoOU3jTHO57THbFmc0+ZOGWKFSWxZiNwxELDmB7UjWTt3EOxY+fXZZZ3sRkZ0+IfpzLbIEO3Xr7IajDGnFZZG8rfG+2dMEMYeCO2ggXOejjw7fImp+0VW4+yFBYPaI4fBntyILL57XPfCyuRrH/EHY8wyRN08fBYWGxuj49OLNeWkKbUjHPscbQbXhyKMgho+RImfn3NODz/IG38wqOvmNA3tPcJBzYaC2FviAi6cAutRN7f/fgk9lZeJRRYi8EHB8CEo6vZXe/GEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
 b=taZxWcQgW6MtgzjT4ouG6KLbP0UAXcsXzPiCRb/fbwvdwsDYypQJRe7gRNn8KXLUPDSNDeMRSpla3YFegY4Z3o5LDo3jq2JFrgo2SACWFGzPuJugGHJotrKeGkbu60bzrNNHn+iA8PH+OvEaQ1jVpUoocT6vzbTfKtHkCR9pVYkhF3wyz0Qypde7viXa224qvys4GTpZlMxK3ixQrameHQE43nvHgVgEU/FBiOoSFGrUYsdoBiLQgjpmAYXUeApqtVUdFNzHbXjMPLFPF0XvGGrvdpToOPW+f7p85IF7x4NXoJy/X25VKPRuVtHJMZOxiOjTplHuIzZvVIb3hhF76A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
 b=bbiG2RaUrPS+AzMqUtu8SUvd5fghRXfaaMTdIonZfvDm4jx6rZ9dbS2kC/sPw3tWLtMGwrQBywpnrGOToIL2YlP9LOL7I3u0ImkQ07qkaUJ96PBnQ8miSHl/upgn0Qhg+schaFtEwpN5qSLgozOC5VpQE3q5MCMBmu/BXRHU4/U=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:42 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 10/25] btrfs: zoned: use plain mutex lock in btrfs_zoned_release_dirty_metadata
Date: Mon, 26 Oct 2026 17:08:58 +0100
Message-ID: <20261026160913.207909-11-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 1650f706-5475-4ef0-fab0-08df337b8b6a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KfKnuUmDgKgj9wZWJz4plHQ9/4XJCWwOlBw7mqxbZIPg+NiAe1MMot1Ex1mRij6+SNGDNsE9NOA38u+WbDcXDljnGpxc5SVN9Zlwi4OMrVPPVjZtYVS/+8DCrq6/1z3MnZd420PYaHDFt8qL0Mtfxesj4Ion07Ku/1F6+Qb0w3B5MjGajIx94CM1yjfqh7W0US00j4Hz1dhqO9YAZUGSNaoDk88l3d9QRL5dlaqav+37iRJfEKYtO73e9cq3wgUGNOGnWl6bGKvEBi8HzyJqfAX1RMl6FZtpKKizHdSN73o1BkJE01FtAcqvdV/c+sl4JXwGF2S5hQIoyAkxrPBd1mdUBO1VfA2SVH++c+UJdFbrjGSRUvaLShY6iw++rdMuy7UjxyBgmv+/ghR7/5lMgHURtcsxDETsDKO8RVqxhz1J3aG9mEg9WHhJOvtd28wGwWE2WBy15RXrWgJ/zrfnoFYGOVfwm8Hfc7hIBVJ1cpnAcDIGJ9cX+dT4DMiyemHNIuyXsT9NXWYFtjeT9hAUVQQBEva1kIt4GytbvDZCOxWE1b4IOZj2Pz3XukCEE83yYAlojvv4YdR6CzquljkgZLPRH5FZCxLlP6Pd6ljc/Ry8sjg22HbXvArK9FG7ZWnj/FzayjnwG9e4kKlSNBPg10H4qsgsw8v0qC1a6VUnkOY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t1PR5k1X4GsNYNSsbvNK5PjsZZ7a5NlhsnYay/efNJinoti4iO1HcrKlsf4Y?=
 =?us-ascii?Q?JwlIsUpkuzZWJzvLLixvVHB8aQStQwoU9iMyMyqpcofcqMRuT2zj6of2ScEw?=
 =?us-ascii?Q?1Dmw08RssWaV6fGADMdXzhXsR1tbiaogEQkQBQTIDtcM+1NEqeBbEHQH2WQv?=
 =?us-ascii?Q?VXwHiAznScxsYrvMmHD5MzQi0tiMHy8/iyj7V2uGAftcifHuotFT2bZ0fK8K?=
 =?us-ascii?Q?+FK/TUYSJw/GL1nWn+cBHVkKhSFIuRBJIDWevzZf0jMrbe6eyQxJgjdX13D0?=
 =?us-ascii?Q?3c3UcmqERUleNsSVEYo2rSwzBshkmZ3tSbOngQrXYzGGbioMijVUsnrAPFH8?=
 =?us-ascii?Q?pTpD4D3RgxPx2pqLsHBOxvinKo/blbFHgTIHeL1kvoUHrz/n2T1zo4O1liZR?=
 =?us-ascii?Q?W9xqkKGAqgtwGd+EoViXxuycYIfnsY+BJ5zsTkQsm19vxnfv+wmGMkcA11oL?=
 =?us-ascii?Q?ogT71MIP/XoJd7KrhIzbEWLmXbeFdK9De5/wFSNwOsqwxwD4gwZ0U0v4u73i?=
 =?us-ascii?Q?HsDIMVGvvpz3A4Gtk3kAOHLsTNa2eim6gvcXpxznW0qf+jw5zgbZL5J8q3bg?=
 =?us-ascii?Q?uRpx41Xv73fXRMdf8+wpTpgrWeYedwlpKo2h5PWSISl4RrzlhAvnJRjnQc78?=
 =?us-ascii?Q?Xdg/FoqcM0yrqzelh35XqT53yzHCYqtbdjhr6RG9VvXJFFdUL7kU/ocAMbke?=
 =?us-ascii?Q?/Wx0Dtm+8DVZMM63LeC9XHQ+l6NDoXAmjLQVR7oe7IZiXvOObeUdPw0lSu5r?=
 =?us-ascii?Q?I1DaUBfLd3YFEkddKmU94mkoR7x8jy0w7rhPRekApIyvTu1At5xyqtyf66jJ?=
 =?us-ascii?Q?NukaXyzl0DuSnWQCp1YseTnEhaXyoT1UZUWdr6Xv9Px0OnWrPZx6x7v7MQyn?=
 =?us-ascii?Q?Lc20D2O4EhqGXR45X4uhgRjebb4/v8yqJJlfCi9INPlSbpZpgI9LIB5kwKgW?=
 =?us-ascii?Q?ktI6SQhPaAbnjUaCnZIyFaTBbqXKnWTCHw3R5LRU0f2kb2wfmIRHM5bOWEwo?=
 =?us-ascii?Q?xIneJWK0qkZD67lOfvzqqAGiGlxuPj5PhOjC8wZov2aaI4PuLLm+ZCciYkSa?=
 =?us-ascii?Q?thTJxtmNFAhm/BbRrdifTFRt1qwsY7pAkdz1c0Mbb9N2U0gPjDsU89uLfxb3?=
 =?us-ascii?Q?+Y4vDMS2WK851RHAP+l0wlHti47eYL9K2IxML0My/cknpao3sFLNjh1E/Auq?=
 =?us-ascii?Q?c7P1e3e6AH/C6pvIpsrjpipyNUo54W+cbFP+JG5ls3akdh1jwVTEqqz9mD+v?=
 =?us-ascii?Q?eZY86NIIF569kvTcbbwfIkCYddLKOUgEOjGN5sGoUUF1gzZKEGaxeqLb7n5P?=
 =?us-ascii?Q?6fwqsu9htmAcqbEslPdxWV8e1AwvYIWpG75xPHAv9RR49eSQjKVKDVpKm1a0?=
 =?us-ascii?Q?OsyD0H5eSNoy4odIUC6ElpwTBEb/FauAgTJlWX0EgBgRJRrQI5Q6wC1mosf3?=
 =?us-ascii?Q?czMZrznxsNJAxhg30wBhf9UJG7AmuZ60vCdhX31GLl811QXCopwiMy8ym7C2?=
 =?us-ascii?Q?GuMMLeeJEdWUbloS8iIgV0OmUMKTMcm4GA8VEFiKdp5xSIZAMNkfFJDRmdtu?=
 =?us-ascii?Q?dxxF64EwPGfdGn+mvvEa3lAi6fa7zuWX+3E/eVHpZf6UM52JS/lx7jcLeCfQ?=
 =?us-ascii?Q?TuDW528EjsqyxiVwMw/JfEJL2mWqe0fWjYXaF3Ussv/qrfQUNsBio06UqJT0?=
 =?us-ascii?Q?sIrxyfo8xDo5A7xQkM36ktMAJMm14H+U5wZVsFVKOcQ3hug6Jw9HLTAgTbtS?=
 =?us-ascii?Q?Z2AGuTHyDik2hhyk1Rn3MuFnb9aSgQ6FvEPFaPP//IOJ+u9bJzC8nYW4GtQF?=
X-MS-Exchange-AntiSpam-MessageData-1: 8zAS+dIxfF96SA==
X-Exchange-RoutingPolicyChecked:
	xeGXH5YpRz9U6X8ugFRdQUKMqVpvHRw4qE1HoC+JNw/TV9hro+nfXq3s9KIS2Uk8y9CZkRmhqY3hRoRWiRzhQM0SF4Os0p9hTLnRBIdigZnJ5SdA2FesBajbq4ROafLoJbDOwDneR2rGCV9bxFeL7XUUwwFE64zZ+wiNpSJ1GAbsD2t+o2F5QQTJPTmEloKVnZbXuIK8LtWfCaF1NTr9/5SNgewUqAzJf6TTL0WePRIeyClOLJuy5oznqNkeZxwS7AczZl4RU7mVkrSgiKQ2ZZ5Irn0E/9Xu19TXzK/daa9r/kDLxYF5DyMSNolKbGnwnZQBWDjzM2RhDXKPyYPGGw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HrvIvCqkx+nFZEybQT6aoteoBuHSvurY/XhzWCGKEMG2uksZJ7swTwPNXOXUwHWpqEOiw5GvP6r+HlutPbHSbxyfdCKylLocYUvSTkaJTLjlA24QXkaxQ65QUiO1cKLt5kvVUHo1mZFSs9/3wsR+Hwui6BlLj8omZdSd5iuRl7P9GDJTwebtUSJ9b0HlLQmBZuW5pFKJfbV2CodbwuBua4nMn+UOws/4Q2DSzbocbKQ27GGCsuJ3QrizStr7yxYJRRQp+glJv/Mq7NULZn7eEQjvAs2bCcI9mgMu5Jo9l1iKQgEO39QrFKCl7bHmjmPV7m5kAsFYO99+3OaZqDXsQsHFkGVNx4lHKwltuWsEyJME6/+FF9UPcXwM7BLwmkxNzxmWFR2vap8gxSioVYRh2DDlBLzcsVIvn40rZwuXheSHEc6Flcfl9y2D/sJFSjeZxnMvY0iqHRxQ4ftk+R+gSeDnUThx08N6ReMoF3fn1TZb7nKI9a8DIxjOrhSYXoSxqkVmFqHYg1NqElB18o/rya3eBHAuksiI7Jrfr2sQu2DrI8cr4hnO8A+0EHZMCsJ0v8iJpiX/43SwQjmIqGJ6pfhfWu/n4RFKnAinddVI0LjgNDQ9tEbKVizWVi5yRuHj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1650f706-5475-4ef0-fab0-08df337b8b6a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:42.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VGxr9ILi9vYZYg/92RJVld2OU1sT1FnvMyVepKJh7ixbj5c8lKD92gaajeF2P/vYRzmDf+APj6jcRyJtY37Poa/qYmjw/mjtvWoiXUt3i2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

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

