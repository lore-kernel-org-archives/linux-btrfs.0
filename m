Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794245801;
	b=epiTKzZ1aHd0UwdUdAYnLlN9VaYUxWvGdoYVFkBy781cDydPRQvzlZmY4zFVq7AbGzbM
	 zO3W5pUiMlDVoftaEZNu0HrfGH95IJETh/YLZNKqAT7eZBsDadVhi27HDTkCRrAtsRWco
	 VKnJReEJv7or6QjrR95y0emiwI9ZjBabex4y9zE0gu00dliCeFA+TJ2co4M8Em+/plGWI
	 NZI9MHMhOfFohGF/mQEAWtGY23TpObcJaHBCQ7XzZK4aR0aeEQmmSq/M34zAuPbODqKRX
	 B75tefPh7o/m6SeyQVYSVwdxaE27aP2XGy3qD2af2HSKVbhwpC6HRuWEOw/Wz5bQudg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245801;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=DCKRPJ2+PEdBe59sVJ+X/TjLjHSLf7/+mgXvQ/DNitM=;
	b=4nRenxOJTn2uyjABvQqfKtOcFlU7wrmZhz8eiyWG/nYlEflPID+cgRgflImcujgo2g/p
	 ybnE1nbCWQI1zzShdQmsP/cGRqSWpYPnT569cYxby6R6r2wbWz8VO2FjB4l7QhZ8Oi098
	 Uy7iqpiT3MTTt1qGR7Dt4JtByksHYErSswhk97dQfB8y/KApIkfgk0W+/0f2Z6FizJMa0
	 jfQiPw6SX1cL3K1/NMGfDQE9+9/heEPgbBwQIxhRFjOZ5CObI5UsxzrVL8DC2Ggxul83E
	 n3E5KX0JkHApCM0Z1jybhARQF5DQM9kroyth2bbvSDit1oDGlBkNygFjxnpMVyZfGwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=i1ngRlsv;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="cTk0zd/S";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35845606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 17:36:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35845606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=i1ngRlsv;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=cTk0zd/S
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794245808; x=1825781808;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=VUD1bcmNPZdhs2cQbXS2WEg8z9ArG6IGxg5pyIVrH8M=;
  b=i1ngRlsv+DT+s7sfcoeuNg9k1JQQ5l2lqXVz/HvXr4P8dDM3GSIzhwiP
   A4gs7ICyRqZp76LpVup0cGaecksqibRUBJEpFw15vaMCsZjor0zEeTrMw
   8lSnKnSwEHUDr2/3BEa0T/KplKdf95dWaGpJZ1K/bPWZtmsOq4lrXtWc/
   HeBGHxIghe2m/f0HTottYImv1EUX3xc8dlHv/w3GH4BCOzw8OHCgFycJM
   15H7J8c0s4rzC0irP4fKS5wfd5ERWmTdVOOIYDXJIn9ty9+Zm06tIM5aI
   TnVlLIF91R55Fdn4muCIE+kfVSMc90e4btqytGVxB42ha2qMuLI0KcL+i
   A==;
X-CSE-ConnectionGUID: ZvQ9lANbTKCHW2HeKXiFsQ==
X-CSE-MsgGUID: 3ReqqWuzS7O1EU0rRbIVtQ==
X-IronPort-AV: E=Sophos;i="6.27,204,1786982400"; 
   d="scan'208";a="156147174"
Received: from mail-westus2azon11012053.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 01:36:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=teONFARwXltVVOfTuO2B++km1bquywygP/mG9d0qh2ABGWq8V3rM9i8oQzNMSwVHf2H43HWHTp+f2VHCjf6TzAJOvaakjorh5q3rwlI3Kxe1JSdNG7zEHvMkUo6z1NpMQQRt1jMnbQ6t1iqSmVMzKlIeLTYkb7w56WCdn6pM2LSK2AhAxPXtj+KK+C/QjaIZlTPiWlfrOR0hVHLmJeI1r/0VTAodLgEB/vr7uGYf5n4sL+GLGDl6gCcE5rWUthBGu1psTpXH8NeVCbqOqv/A47XwFrVzRR67lWLy0GOo9anVyBp1ljVxOEI37IypFHU+lEVfCT+wcw8jeVAZ3NuDSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCKRPJ2+PEdBe59sVJ+X/TjLjHSLf7/+mgXvQ/DNitM=;
 b=X5gg0TC+H7s2IK2H95mT9QlSMzGYZoVpLt6Fnvymotv/TjdmqETldUNvKch4DtVAGE4ZxCPCr4fx7sz13CtznLfwx9ibg/YXTyTbW4WlXHVCe+Fk7ILv7TpnEVit6lO580Jq+o+NNVkSZj/o2v/194UT8+cOqVlrLONczMqaoPXa4QjvdPsONWnymKCBLoljp+AVreobmChyHlS/VOsXwJXI2KLdHFO52Ov5VYB8YiNPBuscnTKQ/Z3YUaIfx50mgOK4v6afP2fqi6WqRzzDOg4ehaWhch3/kRusbVEfls3FDutgHLK6RzoPbmhD7cJnGRdeLye2CgJsqTseVBCaOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCKRPJ2+PEdBe59sVJ+X/TjLjHSLf7/+mgXvQ/DNitM=;
 b=cTk0zd/S6O/uPElgx0vT/V50MpdtfJf1PzVPA66SRJq3xN5FFva4izaQl4baaUM85R98pxXQ6SMSXvXwna9OrFwRHGCV5tD4iZOeEgJJj3uT05rxPqxBxQWktRObNpC/q+aouO/25ouZ2BTBRlMbMfGeyg0vNTTfMUhy/V1jXTs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MW6PR04MB8916.namprd04.prod.outlook.com (2603:10b6:303:246::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Mon, 9 Nov
 2026 17:36:37 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 17:36:35 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Jochen Philipp <a2jphilipp@gmail.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs: zoned: don't release active zone reservations for conventional zones
Date: Mon,  9 Nov 2026 18:36:24 +0100
Message-ID: <20261109173624.1144223-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MW6PR04MB8916:EE_
X-MS-Office365-Filtering-Correlation-Id: 92fa5f5d-a0a3-491c-0a25-08df3e880083
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|376014|366016|1800799024|4133799003|10067099003|18002099003|261102123227099003|11063799006|56012099006|261021121427099003|261021123027099003|261028144727099003|261026140227099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	cMmkeGJXw95+sdL3jnSxtmezZfXmIDxcmHuqaB3M/GsEnl5fRaesbNl0+wthrTBdtpTbomshhWMQAi5/5JVzkBcTsBixf5DH6lkSE01ZOcJ7yok8cStLs1RMKMi/0o2Fx4g+Rx+fiSHneuIZzFMwdA1LOWhA5UP0pkYjib/DuXTl3Yx4G3IwmDIk/nTY4IndEqbaBu1bxE13cjwEDJyUos351dPVQZbYsbBiq7S3i860Ltmf6/eXWCG0qWxaKYiwK/Cvkr7D8krL9rgG6lxvWaO6w1daWSgmi5mUVIDt9GmHrDFu4kavmjwNF0MyVjr/zvntDO7PD12MPqUdga92dyp+bHd7lJYK7QaCgyaJ1PLGCrSaxxa51CwN2xO/mOSUEHHlBt+D5jFU56hfTDBiWKjXF0NbLXL3vN0T/dF/gmVyHPUMxrxTcCTxj5v0wb2F2tXF4KUCoH5amVTYLlZ8TNP1m6xatiRMk+VTHQkHsSKQKALvsfRNBvQwP80anqq0mc0c3v9UXuusVv9PCN2mRYspSmOIpP9dHvLoh8voNTHRTpCBeal/5SLASQ3Y6hgZLGH/dD/G8uIWBmoU0PXIUhDHz/MH1GHxGsE5WQKIczc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(376014)(366016)(1800799024)(4133799003)(10067099003)(18002099003)(261102123227099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261028144727099003)(261026140227099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OJtjehzN+sSPrNaJcp3PEewpaS6FVK9KpDwZeZRzUIMv251UkZknZPaK1/4j?=
 =?us-ascii?Q?VfSApuOTRDIO9cTwFsq2gNHPFU98vmmZmFxQsLe54If5keTzPS6fDxVVqBCE?=
 =?us-ascii?Q?g03aw2uKMEmfYVPGIG9mT0K4LT5TVqg7RxU7ydNGUM7bC6tZurTQP67jkJba?=
 =?us-ascii?Q?0az3QVXOh/O48S6/wUUcZOTAIjHMO+kaqBT1QyPphxMOhZoUH6oH890clCSZ?=
 =?us-ascii?Q?ghJI3O7R2AI6+8RNaRW31A4k6n34zload3UjPPdtoRWeKGdpALT8UjzbBDXq?=
 =?us-ascii?Q?ClGMPN4jroHvG6llz1DtgRHIbdMAyPwYLhYVlKpWRJwWfvxtJouGd9Dm5iUG?=
 =?us-ascii?Q?4yLUchfKraV7JHamohWZ8D5HiuspvAGBNKvHu92XHsXqO55nja8UDr7PEWgz?=
 =?us-ascii?Q?7WoMXFMaM37b70p+0+VE9yqpzfbBsXK+LWLcnDJlaSdJaOffw5PjK8rZUWFK?=
 =?us-ascii?Q?3zdySCZsUW6WzoWVQ5JtEakLBMg1k6JqTOYjpmLji40Q1Go2muS1OF4y5xa4?=
 =?us-ascii?Q?hFtQPnDR/JAjNa0HF1fbJUaUCdzcORJamcTOyKuNkOV+KRGz0d3ANHNSxI3p?=
 =?us-ascii?Q?9D0i0boZIiYs4ukFTDWhoMG+NXp7imvIaXk1WKGr4AMU+laJA4V+PPwF1JOX?=
 =?us-ascii?Q?k8OYL1M/4/7b8h212brILQdY5Ud7AXdQxeD2ysnHFfh52G8EzzoU9suA0Z78?=
 =?us-ascii?Q?HpJ0RExMqPa1xWkZqsADYVp8P3tdBnkixGOHxtddPoAKLSxSg3XkuI8RukRh?=
 =?us-ascii?Q?k3Llwqx/pMWGZBKGZWBoGiCCevNvKVeMZ4z8E4VfWAsir3tgn4IbjeUlylyu?=
 =?us-ascii?Q?qB7tWwCztNJRaIitVFFQ/A+jO6H52kgzKhK/LyHe3IzjwdyOfHBaRGedYlya?=
 =?us-ascii?Q?FafUKZPaG7FJVx+C0z5wHH7qxm4+YoYab6R8qJE3O5aznQiVA0xfdNeqmwtk?=
 =?us-ascii?Q?RZLBl80Q6uc9Jhf1h7rDpmRqgcrkf2vICpmkBmA0yqhP0GLDn80bNlzswzJy?=
 =?us-ascii?Q?YcYhJcQczWrgcUJPfdOzLHDt891IteRP+9dEjwKfGUsrOFat7230Zc0/rW3/?=
 =?us-ascii?Q?200oPk4ijLUS0DKI6IPa9lSHQsp+ilxeG8LzTVAvxh6/SUIX7EeN5Jt5hQXi?=
 =?us-ascii?Q?ZsLql3/7alHCvd91RrcSixeT2JNyUg7sM3oX3oU+KxlxS8tbP/wVeSq2I5sz?=
 =?us-ascii?Q?VUgTTYSeqlZyRvpFO1lC4f9/gHQwRAMOeLoGixGiJtsN0xE+EfG83740O1Gq?=
 =?us-ascii?Q?0FNxpBM0iIS8dDQ4KIq3txskx8ZjBiS8IaDBHkeSspsZpicPepdNhMZwHlMT?=
 =?us-ascii?Q?ZMEkYojEMPSg9Vrss4oYDIA9s7YVuoIb53J/4+SxTDF6IGVe12TItSO5AMzj?=
 =?us-ascii?Q?N7VC/Jpd14bSAafxpTJRfv2EgOK+HedYZP7YSbXp8nIw51xa1ZPoq7a2Iafu?=
 =?us-ascii?Q?z0Yr5/FUy5wkBbCNlZIm4bunnmPrCZX5B9oOHBF9t7ZuOJOZdYd35oRsO4Vo?=
 =?us-ascii?Q?mRUzRFlATiTkzOnZvLdA/V77qTq0dY+cOuQgmqMfBXHcbNeTdtEzia7VfuWG?=
 =?us-ascii?Q?h1911i1XypCOnxkDQNO6XBxLZGnHJyaIbHDzADTuf3XMZSu/QwrQ4H7MJjFl?=
 =?us-ascii?Q?3GLdIS0GGWm0f1zqmN+hyU2NhCKbt1s0g9nlDxMUXsXVaQPRjA86CIjWPLe8?=
 =?us-ascii?Q?cqbUZlS0G7iCO3xXK9XLF9Rex1050PBRIRuQM7BtZiBXuE70XSeZNeZak3m3?=
 =?us-ascii?Q?bKLUShXe9eaaGBsTf+3qwf2MDaLWb7NtsGUmvLXvLW7o4zT2BiwfENA61u+r?=
X-MS-Exchange-AntiSpam-MessageData-1: lpf7gQwp24VH8eAMk/L37lqmwY4vLgB0iHY=
X-Exchange-RoutingPolicyChecked:
	WGOH8vnAikQdOjDiZrgJp+wrvnSlkNwn3LH4nhy+bdFQXW/HfpOPLqm639lAn4snclcG1zHVAzgy8Oq5xa3N8yJ0IkSxavAfECaxlXrAXXEsA2ZbXkou+rXdDRsNxL9tfN1ag20D64vZFjBGWdSWJifY0LOSUpWb6nw/z4xE3hVcXbBjOpXn/SPI1xGX4KRB6U0aDNYXYkrTJbrlZa4XHcIGKAlEy+S/7jdiRF9+9lNWkCAdCPt7gu2jQjOdzh1+gSlX+amHyxTX0c8LEVwqj5MlYkuTHhlo7L52GV9Gpcwl6/qmMa1elNxOY6zi5ZjYjT7UnrT6zDRAKzUsr98bWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xTpKmMmrgcbEdtArwyFgno/AAvQXCXnCI7CTlJPsUi2xcl+KCnhHYFHPY0YcfV2gsnIEkcf/EalIANozlVZ0F6uPS7Y5DhRS26JD82Dbp5THpmn5g1aWCyE1wC3594YFHaxOsOJ+CdgDaqHCnTW5OVnsqDLb5X9Kk2R7VX1C81g066K3fBn8eUlFkKOKxZyNBNHbX39F8y4nuehqmgSqpppGkQGSlZV6cfVl/XHOPEfciFWxxuMbw+63m0kczA0G5iEWNii35DFiF9DG+YBG01DmodQ5ACBqO2DIae4f25yX5HtsGnYGMsy3La2M5Zt5EhkhPsLuzCc8/+PJai/6D6YOCHUgG38wngs45OLqZBskYyw8KKhDjYy/sFSQ7NxDVB126H5jcvQGlvtzK9buGDAz2lbjdDOLPIV2Lm7jLKhgCYaGMN/yUPdtunHUyXqdWb68V9R+WgU0IuNtFrAxJ9AKkw4Q1VIkXzRDqHvzFFVFKO85JEVtE9hlX+UJ/0D/XajESVK57O1/VJzYmlLy0Pjk4ZN4091FebKH8zEaOuKEWl2WJzShnfDYWtA5R6nCsqA6gHhLgNlvo3KLoJuY91wMRcPt5KJuxgoeP0VZQaPaJyCFyTJ2/hfMeEj+uuKy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92fa5f5d-a0a3-491c-0a25-08df3e880083
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 17:36:35.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dt/yWgqTszYG/FJCGp9LypkYZ9JRhrgbj4ayt01B3xEqecL20MFM3GZWwcWg6LKHB+SElWuBy8E6Ab393hGitqh2qJPhosLiw8e8DoYtaQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR04MB8916

On mount, btrfs_check_active_zone_reservation() releases a reserved
active zone for each stripe of an active metadata or system block-group.
Block-groups on conventional zones are marked active when loaded but
hold no active zone on the device, so they use up the reservation. Once
metadata moves to a sequential block-group, its activation fails and the
transaction commit aborts with -EAGAIN.

Only release reservations for sequential zones.

Reported-by: Jochen Philipp <a2jphilipp@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com/
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v1:
- That one actually applies to the tree

 fs/btrfs/zoned.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3192b86669b9..7058f712936d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3115,8 +3115,14 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *dev = map->stripes[i].dev;
+
+			if (!btrfs_dev_is_sequential(dev, map->stripes[i].physical))
+				continue;
+
+			dev->zone_info->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
-- 
2.56.0

