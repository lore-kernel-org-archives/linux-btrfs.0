Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211704;
	b=2q0rpqKtPwzkPw5fGIL8XQScbNyNlODEdvfS2Z6WYL9rUHrDtjr6jixaZOU96+gmlVjW
	 9+OOjaI9c8raHo/fz+9tj44WBQObWW3aTGHjdrYnkW93IkUKXJxNp1prMMtXSoUitWqNW
	 cMgCO35VqrCzZhz8aVJu/RdP2BXOjpmc1FaV2aFWjnLahGHftzlGmDDpa68k8ostrypGl
	 17qh0PhHkyn2iD7Btyo9zQ84AHEoWergtEpFVqVDMFE2/oH2MnQTUkQF8QzTT7ZutYR8N
	 De7LafPAuRC8jfpJVWg56JAQ/oI/wG0WYhVZrzV8C0Dr+ubkzY5YPcM7OqWlRBaCe4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211704;
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
	bh=TkJZo18g1/N/10hSYEVCx+k3AJ00f3U9wOAl1b14wSo=;
	b=ICA7RRNV4eynNnC/6ZF4JsOb25S+6/0sWPtSUEWfIB1W+nWWdwttsfU7myWTVpE/nWyX
	 LIIs4oflGVsAG1C7BvI4sadiOy7nY5KAdKFJzBWxxSYETldx3GIiYLm5ru3VW3hEu2muO
	 KlDNMFmwIta4zgQjIqdemjMKhgYq2AgTvuqNwVaK4Q8TspD0b55EGyU/GvB4feMh3ExAw
	 a8xuE6HGnNniKARhawFoL5k83Nn8R9fb2b/fIJZBYL8RYeHmP3dcmoQiLjNJPs36SE451
	 QoDfIKUgMWa+J4V5XkW/H5sHOg/PipYPVzu3rmjVGQ0oriMTZVUnmNkvw8Pn/2TXW+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=fqcXXR0Q;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=aJvByJMa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65817606A337
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65817606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=fqcXXR0Q;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=aJvByJMa
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211703; x=1824747703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=dlzCoLcisWoPwydqXqQQCuZFZrLQJfBKff4dfInO9aU=;
  b=fqcXXR0QQegZyQkBAMAovMHGPHkbI6X0uFgGozarJMzpdC1NQizwFFHi
   ByRcfdcLn/EtS8tDCQ5/MB0vSl5CeD1nw0qlC8GbgC3TLbR4d9RacnSZw
   EiWgE9+FOJ5JhZEKclNelqk4c+Z812fqZ5eTDwLjiCFkK9io/TNQem7ha
   Ea4/+ELplU5ioKLWQD2RVMehM8yjpr7bIE+0G5XhHe43tlip+2/u5Gpvw
   gxnplvgo7TSlSoCCzYdh3GoLEZpqH2RHIMiAI0l+bMWhkP1/Wf3mbpVw5
   aeEJK4044E5Xzs2tkjcMWd8j61Qhnx1Q989Xroinxmq3b2ZZswPBEtT1Q
   A==;
X-CSE-ConnectionGUID: zyoyKcZuQheRKCROhQR6Og==
X-CSE-MsgGUID: sncmphorQnu08cfr457GoQ==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194163"
Received: from mail-eastus2azon11010053.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w4OduwCz0QS6Dpvoa69GekLxJaAxnMSzPvoYoSLs6V4e2YEBL6l993LfH1qvYBDdk3W3sQB0LgHN4nROconDbno0TWv2GlT4PMhx7+Z4ZB1uohl4kroZ1Ra2iWYskz5zV+InEeKY4Eee9mRiKG6rsltv3hC72ni34wIQnp176168q5Rhs7XiUZ07t77rS0ToKQiL67xHzyAjTdX0kD+cVnkyBsc/Qn7QIQsa1+ZR/Ty08SMVPDQs0PnvCIEH4t4MT8UhAwZTFAU2gHOijfR1rZebG2jJ0zY9+pvxiIS30MyxgKxqHl3jAKmQpkMvQozTpN+sCTm0NUEveYtJIiOu2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkJZo18g1/N/10hSYEVCx+k3AJ00f3U9wOAl1b14wSo=;
 b=gQIc9qXgGkFe2ModYApPNRlBYg9pdmp1TzRlZ1xaDCw+znoG4hs30jFysEDHYYG8BwsN52BFFOYsNf7mgZ4w1MAWlaAamJ8IayS0ZnXV+XOlrGElIlNfRbGUFBNZq2VC7Z0jOAcOZ2rvOWfHH4J/bXARPICN+yDR2hxbgEul+90U6qwPkB7Pyq/7et9gzqr1BQmppC+Yy5/Ms3DCVFR/OPBGgGDCHDppkXPKcDvrRbQ82lbhGOheIDGzT81GYqtFS07zDwnp7sszwM4XXitwXprqfrdJv1tlAgReY17MMKjRUNU8QnirNYIjzX6RMPcDw5G9CfFyTyCA6+y2k5zVUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkJZo18g1/N/10hSYEVCx+k3AJ00f3U9wOAl1b14wSo=;
 b=aJvByJMaZpVoHUJu2KaqJRJ1In+d4QsoRKONWIGzUTjAsR02xhLlcZHnDTZ8KA2OOu4kwCp4q2C7ETY1XogXJbTxDW4OQboBTFU3cU4wG/2I627ObB0WD4ozKvxNYi4m30EPIykKsIV1q69WCI+v/8nrRl11Fo7gjXenxps7s+s=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:37 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:37 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 07/25] btrfs: zoned: allow restricting the dev extent search to a zone type
Date: Wed, 28 Oct 2026 19:20:53 +0100
Message-ID: <20261028182111.160492-8-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 743022db-cbe2-4fd4-83ff-08df35204d81
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	3x1bAYyiT0+jFYJP4IKyfiJ2Qsof//WrC6B007bNqNaf80kO8IT5D6NbRIBwVjNZv9wU81MEb6P6/9b0UgzEOklksdVYuxiMzV9pv6PpUkvvdWWZBi228dtDo0TMKiM2PLNKJBTwW6k12XA0ldMg/Eim/D30vVbcOX02O3ZFZpM1d7aFaesx66J5G+/IaBjYvs+lLvQyHS2PVSwRhVLBYkpwma1EzCSMA8IMXAWdzq1q7xquNU5ELKJz6xM2dPAipYRRyMQANq6864V6YsXmGqrjvEDJKeVJQiI4bwM6CCrXM6zFkCwihv6NWy4hOXCtQLhvNhIuMu23M2eTA4UPaxjHyAU1vVsTXMFigvMJM0DlAxVbGCUdB7+x8vIgwooJwlkXJSdZ8xlKui8uvLM/f0inos+bn4cUMv575Lq1oGxfnxy/Cyc0Jk8CUfgREE5aSAeSqxHuVjONe68PhO8eu5e4eCLPE/0sxK6KSg6U89MmLkhVfwGEJytj+7WgH2oWDCn7ho1Sk6Qkpy1HrbgNCQa5L9Qr8gXvxp8/13FZjZ987fKBHPkLJactRJ+FPMDJrbGM8Tza0ekJs5SFuwNNwjTVvt1ZGiteqeusOdg81yA7R1xMLgtObhEt4n6F/GA+Y8VjOmau6G+1KfLwuYTovt7Y+B7ihJz0Cd/qG1ZkqJY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Br0JU/avDL8axM1AWOnkeveZ80UrOa3j1e7rEdidUl8QRkunUVIr4kjoVXUb?=
 =?us-ascii?Q?fuI+PR27CLHt93EZCg+Fpm1s2b5xL9gHq06nEFN1aT7nlWpvKPrHa06kADnO?=
 =?us-ascii?Q?KNTnDNAayYam34EfcAig2Wld2YeUpTURsYt2sNnqfWy2JKKnD60rWsDOK8pv?=
 =?us-ascii?Q?sILKb6xRvvX3mnNbkoC6IvgPAyMoxgZerq4l/3b2ptxopCrnrxwTGfbLyUJv?=
 =?us-ascii?Q?dc89ibkeOou+qEeN2n9lkpeOjkMeK8MaDOX5dVOZ21cYWKBRdXv/l4BXmZq+?=
 =?us-ascii?Q?5CVAdb6QbaImlUwMAcVPv8Lzp2KHBvWUXiumtPSjgJ5/KpdWI4gjFh3uABDt?=
 =?us-ascii?Q?Dr1YFYVxK5XCDCoqMTC5UWix5mBmDYH6Ni6p1vj+9gpB2tU5K5mJOwxxj3Yp?=
 =?us-ascii?Q?P1M1SYk24MlDqrf/u/vjt7xp2A5G1cSO+9DzHUKa9R6qS0+MsAASNDUVOkte?=
 =?us-ascii?Q?LxB8s4ULTXbHINHRpjmJxFiWa5YZXw6dgkfBH8W2zezYqMf0pc0QmxJ+X/Lk?=
 =?us-ascii?Q?DETOZL5CDmDRClTLR5bqzeaZYhBp/ww/qv/093MLbvF0EN9MKg4TmX2OsAyR?=
 =?us-ascii?Q?T6BZnpKsLvRdFYqPKpL3hmbkGIMXLB++Oj23nOnXngAq5YmuL+QgJHeF+WPp?=
 =?us-ascii?Q?ucd8xWzXVo3rzwtJMLS8FuW+RywUwC/k6ITAv6BLpI1Ciomlqk0dDmnAbyOd?=
 =?us-ascii?Q?gcC6WU5eHCUA5QNDQhY7YXBMWYqXuR2MEvmdXzdKeX7WlLOybClgulv0HDbL?=
 =?us-ascii?Q?Cuqc416dAR++wulA0tT0GR1CU99PXLdlzLtuvW7QQST26FVp3ZEmOD0jVz7l?=
 =?us-ascii?Q?HQB0USXbMjpdKAK9kmFU5ihVW4+vKtLQYsvnDxziSnekEfMK1R2ywxCn+jj6?=
 =?us-ascii?Q?hkxDqG3YWNzzhLrXv+fDVI3NRyyzXk8so+vb6n2dM1G6R2zXaymNoXHETAMy?=
 =?us-ascii?Q?0zDz3galYuUh0cGZbt17clOpO3EX8UH5vzDErFRnuBTHUNz9gHj8NXe2ocu5?=
 =?us-ascii?Q?q67THASBgzK3zxS4icl3soCFhIw7QriYmsVjCojufqVhLJOeSFsChvpJhHfP?=
 =?us-ascii?Q?uGZH3aPtYTh5OOFyPgT9j+f5FgliOYX4RyveFOV7St9Inng8wyzzprnMcZSB?=
 =?us-ascii?Q?yfrJKy1BQpxtEWnpvOhsbqAyvw4iVWDMp+SALr7RGBsG+hI7zlg8lkiqzOLI?=
 =?us-ascii?Q?/sFkhvMGQzXVgi2es59loXcI2ZfzGpCcVRDSWsz7o3TmF91KDWdVNbuwCdzm?=
 =?us-ascii?Q?0c5rhhf1ovgWoY87WLeep+R0Scr26jPDVthcq438ByxM9lQWmGZBhklkfIp0?=
 =?us-ascii?Q?KHxHbPUkjYJroGYJ1hl+LYea4JBpXij+O/hOOa193mHW/M8AFHhknDfJ1AOw?=
 =?us-ascii?Q?Yw/wU07YWdrusvEap/QsGSp9HYGJCfVnH2cOUCLBTPVYdb6Tij8wKUHiz2fq?=
 =?us-ascii?Q?XGYkLnDhyoiDslG43yQ0le3v0DNtAMznkoywaZn/O/gi/Ake5yvHcjN1aNp+?=
 =?us-ascii?Q?+ABXj/Xc5c3gM7u675RZf5rgaM90Jvw4Mj7/Uqajs1xLnSw5SUcJajLW2g8X?=
 =?us-ascii?Q?Cm0vSOL4Tyd8i7Yjw+6hlErMPsfl2Qj+1UKp1RdIFMhvkqMOgllhmV2ywZ47?=
 =?us-ascii?Q?xBRJOM6xZlorQyE1kttEJmixbRz4ee0UaPWWadmy/LcRN5XrUputMfoM/mgB?=
 =?us-ascii?Q?GGcQou0v17Ao7ljV3IcyQQgBSMv4p9tTUh0joMU5pEydFZMxCim/F7obBhKF?=
 =?us-ascii?Q?+gbmpJam5LgGbTjHxWcjcvz5IqSYfCL4QEzSDUgixD2mm7ca+sclU+c66CJl?=
X-MS-Exchange-AntiSpam-MessageData-1: 2UhPEWMgLCP7r7dQZhMdQ4KsYSDmTaOjqwg=
X-Exchange-RoutingPolicyChecked:
	0zJPZmHpGLbY+rvi22yy8/ShdGt6mtT8i9OrKVHOf4VlcIgM4JTXN/shs1gLavPJC8f+kioWc4xwe1Pdl3sCLp9fUZE+tT6QvfKhMy7hKbYelHX9x35VeQvbRIYG3zCwORTmXzdVq5/VGCXHeI4SiXprZE3VKNxoINsbtP2266JrKCPLBmdcdXf5KsNd4uWaY7Mggv8EWW040mvz4BaAe9GM5gvtEPMzZazGveQgHUkTk2dcnh0n+bAb1m54Jauk1ukZGK8uHV3IFxhgOlR63HUfNV8vjJw0ni9TxNCxyTq0z1v/XS+OeUeeE0EDehV56gobSgKIlHoRrwvrAIy0mg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qv6RcQLvWmfHDUxcF97X+VzrXivhvVpseP67GJCDirLnfWYBdG4Kc4m3hLS3H+jdnZHArpWT4jzxccVRUDnFYDh2LubEqRIP/Imfs0zoveZyENTrrWMsqLUDFI6HFnAXu2EwJx9zcr3ljtcTYZ5Urjn4VG8qGdrwZBMkgY7ex6mgr+7hvQSsP2p12nVVCmJCrizaw/QQEeOpgO3aPwQupj+fwegWk3a7K808qsixQiNVPm+tVN1xRUYIO9lLK6oU5ARfi3SsiZvI1jPe+G0Z75flQaRlyU50qoj0oaGW+yfd+He15qD2KI1Qk69hVMOYfNcUqV0qrAKpNBBu2SM9rJkVzzUEUxU3g19zrg1Ke2C0INQSCh09vf103uof5Kc9dc2/THeKeCDuRPtlgumXX/wGP1U3/QGP39XpHtYlo5dK8f4yEWVyVXT+B2ibUcKZcbnX53UVFIpEdNi9SiOS6FEyXqhZ7OcjtJ0GmJ26Lgs2Rzw8/6pvNBbq5nxAQHoO4a9rSEHAUJFZHUSCAIJHr53qHcrDcufS+OdJLTAZ/6e3sfjaDdYd7DhKMCfpGgNZTKp7xJC3Tx2IzaSrvIXnuTUV0xKuyd+DWtVuC5QQsMOVAnuaXlPiCqH7rcGdcqD5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 743022db-cbe2-4fd4-83ff-08df35204d81
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:36.7493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 90Grl7zbsxopHg/KYDHaCikIOfes6iWwbbBcOARqGxW1+to160Pv8VusDtKpRf0u5t3E8VlbWDgmdtnT0FTMegWvF1U1p7SUvLEDwkkejnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

Add a zone type filter argument to btrfs_find_allocatable_zones() and
plumb it through the device extent hole search. When set, only regions
consisting purely of conventional or purely of sequential zones are
considered.

A caller expresses a preference for one zone type by first searching
with the corresponding filter and retrying with BTRFS_ZONE_FILTER_NONE
if that does not yield enough space.

No functional change, all callers pass BTRFS_ZONE_FILTER_NONE for now.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 24 ++++++++++++++++--------
 fs/btrfs/zoned.c   | 25 ++++++++++++++++++++++++-
 fs/btrfs/zoned.h   | 17 +++++++++++++++--
 3 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ce78a9441c64..1fa4ee803251 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1704,7 +1704,8 @@ static u64 dev_extent_search_start(struct btrfs_device *device)
 
 static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 					u64 *hole_start, u64 *hole_size,
-					u64 num_bytes)
+					u64 num_bytes,
+					enum btrfs_zone_filter filter)
 {
 	u64 zone_size = device->zone_info->zone_size;
 	u64 pos;
@@ -1717,7 +1718,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 	while (*hole_size > 0) {
 		pos = btrfs_find_allocatable_zones(device, *hole_start,
 						   *hole_start + *hole_size,
-						   num_bytes);
+						   num_bytes, filter);
 		if (pos != *hole_start) {
 			*hole_size = *hole_start + *hole_size - pos;
 			*hole_start = pos;
@@ -1754,6 +1755,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * @hole_start:  input/output pointer for the hole start position
  * @hole_size:   input/output pointer for the hole size
  * @num_bytes:   minimum allocation size required
+ * @filter:      on a zoned filesystem, restrict to a given zone type
  *
  * Check if the specified hole is suitable for allocation and adjust it if
  * necessary. The hole may be modified to skip over pending chunk allocations
@@ -1772,7 +1774,8 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * and *hole_size is set to 0.
  */
 static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
-				  u64 *hole_size, u64 num_bytes)
+				  u64 *hole_size, u64 num_bytes,
+				  enum btrfs_zone_filter filter)
 {
 	bool found = false;
 	const u64 hole_end = *hole_start + *hole_size - 1;
@@ -1793,7 +1796,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
 	case BTRFS_CHUNK_ALLOC_REGULAR:
 		return found;
 	case BTRFS_CHUNK_ALLOC_ZONED:
-		if (dev_extent_hole_check_zoned(device, hole_start, hole_size, num_bytes))
+		if (dev_extent_hole_check_zoned(device, hole_start, hole_size,
+						num_bytes, filter))
 			goto again;
 		break;
 	}
@@ -1810,6 +1814,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * @start:	  store the start of the free space.
  * @len:	  the size of the free space. that we find, or the size
  *		  of the max free space if we don't find suitable free space
+ * @filter:	  on a zoned filesystem, restrict the search to a given
+ *		  zone type
  *
  * This does a pretty simple search, the expectation is that it is called very
  * infrequently and that a given device has a small number of extents.
@@ -1829,7 +1835,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * is not reported as available.
  */
 static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
-				u64 *start, u64 *len)
+				u64 *start, u64 *len,
+				enum btrfs_zone_filter filter)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_root *root = fs_info->dev_root;
@@ -1905,7 +1912,7 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
-					      num_bytes);
+					      num_bytes, filter);
 
 			if (hole_size > max_hole_size) {
 				max_hole_start = search_start;
@@ -1944,7 +1951,8 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	 */
 	if (search_end > search_start) {
 		hole_size = search_end - search_start;
-		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes);
+		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes,
+				      filter);
 
 		if (hole_size > max_hole_size) {
 			max_hole_start = search_start;
@@ -5928,7 +5936,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail);
+					   &max_avail, BTRFS_ZONE_FILTER_NONE);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 442f85e1f1a8..a95e1bc9a982 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1045,6 +1045,22 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 	return ret;
 }
 
+static bool zone_filter_match(const struct btrfs_zoned_device_info *zinfo,
+			      unsigned long begin, unsigned long nzones,
+			      enum btrfs_zone_filter filter)
+{
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return bitmap_test_range_all_zero(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return bitmap_test_range_all_set(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 /*
  * Find allocatable zones within a given region.
  *
@@ -1052,12 +1068,14 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
  * @hole_start: the position of the hole to allocate the region
  * @num_bytes:	size of wanted region
  * @hole_end:	the end of the hole
+ * @filter:	restrict the search to a given zone type
  * @return:	position of allocatable zones
  *
  * Allocatable region should not contain any superblock locations.
  */
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes)
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	const u8 shift = zinfo->zone_size_shift;
@@ -1079,6 +1097,11 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 		if (end > zinfo->nr_zones)
 			return hole_end;
 
+		if (!zone_filter_match(zinfo, begin, nzones, filter)) {
+			pos += zinfo->zone_size;
+			continue;
+		}
+
 		/* Check if zones in the region are all empty */
 		if (btrfs_dev_is_sequential(device, pos) &&
 		    !bitmap_test_range_all_set(zinfo->empty_zones, begin, nzones)) {
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index f9dbab976a92..5f21a360f23f 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -28,6 +28,17 @@ struct btrfs_fs_devices;
 
 #define BTRFS_DEFAULT_RECLAIM_THRESH           			(75)
 
+/*
+ * Zone type restriction for the device extent search. A caller expresses a
+ * preference by first searching with a restriction and retrying with
+ * BTRFS_ZONE_FILTER_NONE if that does not yield enough space.
+ */
+enum btrfs_zone_filter {
+	BTRFS_ZONE_FILTER_NONE,
+	BTRFS_ZONE_FILTER_CONV,
+	BTRFS_ZONE_FILTER_SEQ,
+};
+
 struct btrfs_zoned_device_info {
 	/*
 	 * Number of zones, zone size and types of zones if bdev is a
@@ -67,7 +78,8 @@ int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes);
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter);
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
 			    u64 length, u64 *bytes);
 int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size);
@@ -177,7 +189,8 @@ static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror
 
 static inline u64 btrfs_find_allocatable_zones(struct btrfs_device *device,
 					       u64 hole_start, u64 hole_end,
-					       u64 num_bytes)
+					       u64 num_bytes,
+					       enum btrfs_zone_filter filter)
 {
 	return hole_start;
 }
-- 
2.56.0

