Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941987;
	b=ieuV9YRZpKtvvKOe7yQ58wZATJI1fRFBfzvsSX8vHHuVZsYnbVVEoKVkJC7ptwFzOGt4
	 7HiGyaZ1IfGU5oOlQuH9iYNUYZKgyHcNX0Defha6FlEI+eZERhP8SLEI4RhAJB1wTxVeD
	 kayAPLh/Aa9u+UuZtEIolqrq8umEW3tbUVwPxxuUXTL0nwN3bUQ7RS+vwMx6rp/DHg3JS
	 OjEnDHk0SVXQNOxoqYaCSQJ8Ft63rE7qm8SUayQljHdj/6rAPnbiAfcM0+bUepSZ9nPxJ
	 gEmwWx9W7dLFHrzyBKV6V3Hd+W/YFWZHQj8abPq0lcgvuKaW97ucAOQ5rqnsWFpgFqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941987;
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
	bh=/ygvmclcoi/QCeW5nM46zHg8b/ghyEs6gTxjqAk0D3Q=;
	b=DwM2oHJj/uf64GmRuA97zvKgu4ue6GcFE/rBlHorpjIhv4eqajxgrshmFOepjUCscMNK
	 /uX1NSOPeaKtjUPfmISEhlsubXCq8TwvvHx6nqiFWqjXCmivjNH28eG0tZuVt11n7DZ81
	 pwEc7Uelx0QNxmnYBP97xZVVY/5GiS9d2ydznyAwWRWeKj1sUdgJhrcvUXXILNf30R0yB
	 3RpZsDGnMuuy/t3B0QmOhkWyi4m/afVItCkSpNNYTIyQsa/bqpmuj8fInfqOI5QNwaqLq
	 TJsF36Yb0CdjBtEe3kxMOr8c96srTwYwznc/NScZp1ge7/0HOInrnlf0kUM16EF7LCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pwNmsoe9;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=trYLV1a+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F6E606A330
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0F6E606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pwNmsoe9;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=trYLV1a+
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941994; x=1826477994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Xg/e/LZAJuv597CW7eg3eY8yz6yQBq+N5071A1tFNwY=;
  b=pwNmsoe9WmFruXAQtpy44FZmBE5urtdNCI3r8DklKfY44QypYFiiyVCg
   L375kL84kGxt/B9E+rq4MqLkpzIrEZe/Js62EIKdTHnrwto5XD44Iv9j3
   x7nRM4o0QNjN/3jvkVs165+S1BvCXLJ9bkgA1khlKtArEKpk49eVdSecu
   LW0quj/C67+/cncb+YRBfvm1MJXea5xjx6sJPqNOAyZhtWiDke9z2gKii
   copFCAkpp5kuM2WJpZj7h+FSCg/Wch3ztpplYe+sP2DbBbVmh70yK5LP1
   RKnFGRQIt43q0FevaUlTAcpYrW6f+a3CpFH757lH41OF6iC93fb3NwP5l
   A==;
X-CSE-ConnectionGUID: eN4hLBuXQTy0Y3jiKMGGLg==
X-CSE-MsgGUID: zowd5384Qx6s/T7Tq9QLYw==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160148990"
Received: from mail-eastus2azon11011018.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=awEPfAs8KW8sBVt6U2sdPn/MwtY67k/XmMW2eAYM9ClD+aC/yGJRZeBi7ki3ZV/Z5PBK5IdbGra9M4iLH4uVuubA1ND85iDkkueAgo3nZJmxn8N4rJTshedhykZ7KZZQz/m8RsO7o2ZCO4Gd+GOaaGvtiAEChTZPMIheWtpj0BgdcBua9pUHvVs74CqcvJFdb1et7D9Asb11CJoPHo9GlNwiW4k9ndlQ5A8wd/idCJ/RE83LBB0b672mXFPBNx14g4f2qL9bfB88Ty9j9ZamIXdlkc81qVjj9r+sKPetBjwO35n/Ox8I6LUtxydMBdSI3qvSYV12KlLA7p46DAbC+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ygvmclcoi/QCeW5nM46zHg8b/ghyEs6gTxjqAk0D3Q=;
 b=snLW4NhxJ4Fh+T6T4TMFhDwZe+c3hdLuEM5Tp/mO6F7uXCJihzPnhh9sasSt73O8avo214+RFTEjwOSacqgjCdtmSCHRJhydhRMv9cfRs2bM275hTEdiyDgQ3S4ue8g3n20LJU5YecpDUnCiJ09OuEeiMheSKgbAiXlHEo26aMHnAy0XRlDBRmEQQTcz0G6bGdKlWRsmGKpc4M/1IB/ELzmdNX7QZOBKWuTc/OWIzAMVGgwU6RxJZxlgd3cC40JaL7dennjwN+/MAUMVCilIiwsBAlJ/b8ZV8wBVwzE5fCkRlyhqxUplszpx6iIQ9GMwz97e6vubyq3m9kn0UkrfyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ygvmclcoi/QCeW5nM46zHg8b/ghyEs6gTxjqAk0D3Q=;
 b=trYLV1a+G/NKSwT0RQgeNS/X5R4LqD9QoZSnTFfKGSBe8ATPOsDulZLKe2GDA0NxDUKQOdlgqSaZXooSIdyRhShbMw0YTDkL5amdDm/4dri2jsiY/Cb02eRk4ZOF7xbA6Q2KgXXvXC0y8ve+QYavG58FFSB0PfVbk6AVvn72DRg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:41 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:41 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 14/27] btrfs: zoned: prefer sequential zones for data chunks
Date: Tue, 17 Nov 2026 19:58:37 +0100
Message-ID: <20261117185850.4128157-15-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7f2c05b0-bddc-4f6a-f331-08df44dcefc1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|6133799003|5023799004|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	CKaP4hAlzWXksUvHjDiRXn5kXLCC3olSR5Ry+fFCfVk5Thq11HTjzfXI/YAmOEj5p0RoLObLxu2olfRyb88ap2VrUBns+2En+zgk2H8aJoDmT+6ppYrzeROIreCqnrxvGiyj7wT+GMUiQjOC7KBofcz3VdHSdBybla01ULCjC9AB1WxwrcQN9aEFD9PV8iEUM2FznM8rBfXSzdxlflG20I1fhvBANz5eUJ5vzgXoZGKA8gsENekJD70Lf+B/P90oseiktJkYPxr/+b9mY6j+sPQhRzx14JcEeKGr6b5gkgCw27nmfCZBOSW51do2LoV2CUSZ6IM/Nfx5IzDiGuxGpYZ/HnGB5HqKHD9AvjtzMMpB2vRs4/ecqrnzM3UuNehfmoWLCUBRShHrYW+5zCMjnM+VlvcbWYBagiSkHfwop44AjJelAaAko0ubit3nUIYKHBY3asd8VULLX2E26zjIVG0WkXuzkO5TWN23oL/XNasoUHJiDDH5kP3gwvC8/VRldGy3YtrIZfqU3cPoOLKuccuoEwoTVg6k9kS7htYzn53x0ZcTl1gI5n5KrGEbgb5cKere7C+QHw9TxOY3fzljhsU+ir/UHnFZT2lPd2mYxafWJGp/NWHK02AI2wETIfvikNWC4GYP6PCThr69ACw0B4XXLsI62klIykx01ORL/AY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(6133799003)(5023799004)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v42HeoryvVEGGZuG6qPTFbH21ARe/3Jv6b9nMgUCw9Zf/wmDO4no7xy/Jx9S?=
 =?us-ascii?Q?Rb7S7nrIUK3zW6z0gH00OaBbQzl5yoPW99IIH0Ske7B4PQj7JaSDIBQOS1OU?=
 =?us-ascii?Q?3q5eArQHqIKWounqc4Qg6kWm1ON/+0X7uQoDUhgihplvkRFo2S8dROZJaXMa?=
 =?us-ascii?Q?Ho4rnCk3Nw8Me+qqGCGEOT/hjY51TZuSUCV/KkQqWlX11QvgOV5SfJak9rMb?=
 =?us-ascii?Q?qlmuoQqtzUbnkb3okb2TSUxEm2HQ8M3MgKVwjN7ocvHBEiwHq81+Ow13efPB?=
 =?us-ascii?Q?YHgeqRczj5kW0Qx0Pe5ynLAtx384WXt2/gGnWaNrQVC5ZdVYALRPrcnKRyly?=
 =?us-ascii?Q?M/RKyrV0iGZph3owBMjmk1mvQAeyOt0OCZbozqJXFRKXxJ1GKOK6Q7HsqswQ?=
 =?us-ascii?Q?rseJyThLf+UmZXydWMFN3kQDkVW5R7GI8cZRsIicm48L5tfDkYrkLSJe3tLp?=
 =?us-ascii?Q?n+1GkThx1yj9bTg3eskoD94G4cpLGm4q6kCdHKdjrMVZ7gYt1HB1lSpmDLWd?=
 =?us-ascii?Q?5YsTQ5zVQwF74HFlGvByHB46Ccv52yIGEEFZiBCGvDt31deZNI8Z35nBMP8f?=
 =?us-ascii?Q?SBs8s5CzWuzteg47fSIEbdkjtzDpUgoDSN1GqqZU9fCXHexE3kjeqmYHJ0H+?=
 =?us-ascii?Q?QoFEPOXMO23F7qYGep4CZZ8xwfAWNBgVmmPnBwG0nzYmPslOVFjbrgG8Gkl1?=
 =?us-ascii?Q?OepOeuyPN7nsQhLbHNWyiGrNUG+DscuoigWvEC/I8TkPz9h0J8C6pihGCPA1?=
 =?us-ascii?Q?EAeHPnWjz0eaJMiZ85pH2qa7AokPzK8+jP7svXMPZYQbNtjiX+eO8Vnb/srO?=
 =?us-ascii?Q?s0FOzEI9LEyDVjlUSfYPsvPFPrxH03x9HvWYF+xXojYN77U/LsOyocuC9qYE?=
 =?us-ascii?Q?iRd07Skf1QMTawHNmP4ZtrhZFa5fSIZH93v0LIZ2k7gB/nQYk4YU513nnAkd?=
 =?us-ascii?Q?khfD6D6W82upDVChoFZKBb4cJV7WnVmxBS5RQeYLAKH7+rZN5zlSB/GM8Uaq?=
 =?us-ascii?Q?4u4aajEifciqP6ZzjK6UQNlVXaIgAXXOryhGrtcTpMzhrta90lMAvlfOqty9?=
 =?us-ascii?Q?nEOePnl1wWhQtBLU5kiPJXNuUgxfqCYUlQn7RRfJsQHJDWLt9XHdZUazKgsK?=
 =?us-ascii?Q?mOwlb7IKJu3L4Hf+VsP/w+Bt8H0nojuq84iB4dYGm4kX7TPKGud0/pMyt/xv?=
 =?us-ascii?Q?CBvqvH/VkeLQhSYsePo7mevOCtdz78Fps8oeYizEGoMbrCJDNKtNSL8nZveI?=
 =?us-ascii?Q?J1ewG2ON605LacCeHz6RNeBPXSsYyE26fRzTf9vKxk1FBhwrr14qZGe9GL+j?=
 =?us-ascii?Q?LEVxv0OMzH0+fwnE71rHFIjfdPDoPhGJ14aTy8zU9Co6yACcmsjdmn4qdMAN?=
 =?us-ascii?Q?yFm3inthCgUDV2RZTa2HJmnWH1dOFhY3/cDjODOPvGHHJU0XjhkymjbQ1Uix?=
 =?us-ascii?Q?Ytg2M0MO333oFIOsxPo+BDvQIUAK3WTEoV2MiOyo0KiO21POWyW9qBHr/1wz?=
 =?us-ascii?Q?kNOjqEN17lCp5YBisGpt5r3GeZRWjtXdlxzTBkdJYy91CV3ntcu1Cv22AyPD?=
 =?us-ascii?Q?LSwk8R+P9djZK/3lYtNWt7ztrhVlcoXkIkMvH2Uzs5YucJRje/cIKlK+eGJ5?=
 =?us-ascii?Q?vtmYZYiFGuzVIAtgrxv3Sjd+8gL5EgdngcROsd1LfRCSs3MiNu+4htLMtAz0?=
 =?us-ascii?Q?IV/w/AjIt3NqC3RdpwLp3RI6kLsktH029T3yktw+dCNxtKYoO1cntOGsQovw?=
 =?us-ascii?Q?34KPipjFmjComsRwj/lxyDethrp9TBl6fUTro/6W1GRn9NL5S9VfUuHn7Vu5?=
X-MS-Exchange-AntiSpam-MessageData-1: 0L8ZtU5WlyaKzVJiyDy8F5BPxyqBqF5J90E=
X-Exchange-RoutingPolicyChecked:
	PKOymJSlOSR+ImZCKShCk5Q8gseLlZkpuBRCEBXmLIskA8NCgw9ErvizS5TYXsyQhINVQoDtLX2KHVGg39OnQuf+Mw91CBFQLvFkHle/0HyXsvei+ToriOanrIzlhTZLkM7lKLm0+nLBxNouHCTdlOJC3doyKQ/GVU8XU1QR5eXZDOTYn404bZ7DqfNRqv34P7y1wJHaHWvpItEqNK3yfvf4AkJnLRySJM1IupKL892I/sSYniwx01C5aVwvNrHlxOhhd88ksOp5+jmZKnceK8+hD8rPf6SiVAhXbDMXUwPeHkvPzJ0dQ+G+eEevCPipuzXZ5jwgi3Vwy5+qS8jCVg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dx2lyt2f3vYsddHvODJIN76eoHHfIiZxqkhH0QFJUwjPx+iFdvzXDVPBZZxcRyvjgJa0lWO2bEb/fX31Ux8fEbhFxLAYdAC1Za6gHERRtmX6GJliJ4se+SEfA46nMZ6iw7aQDghRs9qNk0CES6y14txj+cF/On7Q2bf5tSQSrnMhVm1CvoWkOc7LZqIxH0nKTi+lnhyZ8wWJ+bcNfAE0d8qKW6gFiL/ADGVQeQbT+hEcKCPHqmMC68AsaAYsunGBzKQ8xeHSvUUdetxz6gsoIo0c0HDfo0hCmNvHTpNWxx+CB+lGqgr2c2pQ1hB2wMqVTyL+ETExYyKpvP9UcYL9xl0BhMkDAn06kSl9UWEEvh4/Vz1ZxHp++H56UssoTxGUQMPui6SVdkNbnASbo4OcWelXx6A2W9jnEVXpJ9MOO73WoR/khf5ru8z2YdcDGFRqWywBtqmnKa0onVdjrKylaVrnF4G+2XGi8eZUTmRlGJuObMRekXXJOAdniq4LKCIVoMH3u9yH9QwO9lmbvJlhnfLrc8gae67QF/oQRjduFM2VfmzOYFugpR7EiRCWXfhT2fsHSESf04JmM4oDndKQuv/ikYvybY+aWveNST2VZPjDEVHEyIJC2c+YytqQ7ONP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2c05b0-bddc-4f6a-f331-08df44dcefc1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:41.7472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: paz5nX95DEurEEQ4z2tYmJ31qH68ESioxEa8J089/GvftWJLmQpOHR2X71XqpBMXzXTV2ijzHyhEB0TP0HSiUE4QIdFBr5FGH5+mXT5bT/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

Data on a zoned filesystem is always allocated append only, even when it
is placed on conventional zones, and its volume dwarfs the conventional
area a device typically exposes. So there is nothing to gain from placing
a data chunk on a conventional zone. Doing so does hurt though: it
consumes the conventional zones that metadata wants, and metadata is the
only consumer that actually benefits from being able to overwrite in
place.

Mirror the metadata side and search the sequential zones for a data
chunk first, falling back to all zones if that does not yield enough
devices for the requested allocation profile. Devices without
sequential zones, e.g. regular devices with emulated zones, skip the
restricted search and keep working as before.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4c37fd93604e..bf6dacdb2571 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5910,6 +5910,15 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+/*
+ * Metadata and system chunks are preferably placed on conventional zones.
+ * Those can be overwritten in place, so such block groups do not need the
+ * append only allocation and writeback paths.
+ *
+ * Data is always allocated append only, even on conventional zones, and dwarfs
+ * the typically small conventional area of a device. So keep it on sequential
+ * zones and leave the conventional zones to metadata.
+ */
 static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
 						const struct alloc_chunk_ctl *ctl)
 {
@@ -5920,9 +5929,9 @@ static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *f
 		return BTRFS_ZONE_FILTER_NONE;
 
 	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
-		return BTRFS_ZONE_FILTER_NONE;
-
-	filter = BTRFS_ZONE_FILTER_CONV;
+		filter = BTRFS_ZONE_FILTER_SEQ;
+	else
+		filter = BTRFS_ZONE_FILTER_CONV;
 
 	/* Avoid a pointless first pass if no device has such zones at all. */
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-- 
2.56.1

