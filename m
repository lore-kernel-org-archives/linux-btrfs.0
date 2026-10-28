Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211718;
	b=kHoCGxdihNwTSI1+/FkXYo1qXA70nOUW/nZydGvxnjkAkXksgtOsJuXQGLyOPwKvsdbj
	 36wSe8ewhFBnv48XEpgJX07FRy2BTM6RrPvbzkbiqGCmNlaRx8wsoQQVd2jrTRmcNOvbP
	 CDgPH1IaROL7AZH7tqu2RGqVwVjLj28hAR6cgmKRb2D3E9m1SDn9VXxuQWgDrn+xV8nv3
	 5Luoe1Upk4KAyVw2ux13J+39SElD1HT/ds2QW62w9cFif1Qp/PxW9DuvEk6DfCXfBP9f7
	 jaV8sWP6hsBr77VKGZa4U6Dtv72yX6kgm5/3Wp24tX+JSTJqPMovEJIYt7KxDFM5GlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211718;
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
	bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
	b=QBaJ1nSCMBx73CwK6iseXUs+M6SbCNsaNN28ce+cZ2AHnfomYuhqPyK7IZX1UgLiwoZ3
	 3K5bbZXpvlHyt0OXo0v3vRI6rpCBoUjw1RxGtSeOeHhbQLS0GOeaILUxlg840YC+dO3bw
	 1rUmSyE+2FLDaInxxYhUwmVkTNhTNbrV3rrsIWorbTvr8mK1+hvE1gKqIWYeRTdxokGLR
	 0x8DxO0nb8wM802nI7LRA3ddlO+tDQA9fSSxw2TjljiNUxm3UwoO9G08ZM1IpoyVYRYPq
	 e4gKAzGZeU5ZnsQvCpt0ZpvWXVBh8gXwQ28SFCRtliS0q/+CCAMyDLeqsUyMYRoThHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rytHfm05;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OfFkYmmr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95500606A33F
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95500606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rytHfm05;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OfFkYmmr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211717; x=1824747717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cUqYaDxT1RLFCWhH+LO3t06+/blaW3BImS3lqHr7b4Y=;
  b=rytHfm05rc+fl9GyGwA5dp5ky9CFQNXEKvLVSQMB4pI7btyXg67c6oUF
   k3fuJmC/Kx4z23CKZ9dxLsAWCQ0ClrevL7pF665RnAt5DiYRYdNnZKIQ4
   1OcUOr4bA1CFw1PmDzeUclpBjpYc/5f/27MRmd+g6yoJMtqs2o6ZBqLpt
   OWKfvvKyOMfPuW71xroqDJptHEp8T2FLtvfhP32HQdRI6gsCQCesvcnKi
   m2CtVRlLgYCsarr2q7GEKGcIlyCOqyU3J1rFr9TAFUGNM4ie+1aVyeQ5J
   BK0lpIR5IURwb2ck3ga+mHr74IEy5GBAiEOjZ3UG0pyNMpcbTPr2R5utG
   g==;
X-CSE-ConnectionGUID: zzWK91ISQDCNOWS/uvAU9A==
X-CSE-MsgGUID: VpLpQ+A+Q2CzUrhMBPZ0Dg==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159135293"
Received: from mail-eastus2azon11010002.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.2])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWnCV0CYyLMiBVIpDAVcax4cTOGyptv6kLkl1BZE0YSa9eOQ474sDByZkK3BTpc0W96jsEglP0pvnrC/UiOYdO5hDq+nO2P8byYufQkv5wWUbfwhKySommbsLHnnmbSTrw/Ft12ne+eu1Wk91qakytfHEPljx1HEr7WDs7BVAy98XrG1FgOUydJ5adB8sMdJu2FWfXT9tmrxlZ7Znn1vUhaIVVXP5jmbAAIcwcgOxsDOqrW500i5xQiAJTwDTo/SR5MevUG1WCJoXmJkYY5laDinfDFH1J7/FZNsYtGIpVPVAH9sDcJUIC17dLoxa4WXvE68cEmMynrzTUV1Kuf+8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
 b=Mf6B+HVFI1JVotWXW1m3zXp8iifQ3YZgflyUHg9QdzcyHg60cZ96uLiPieLyt3qijMIBKC1czF8BTg09a9XiiXJ2Ru6R5dra/ty/3/wE7brfdEXmZptrL6JcuyokkV7VmOWVI9XWKAIEsgr9t8HdsMptIXOhUVPMcEllb6r8QLZ+XAWjFKbOhaSeTmITW5iCn4worVp1AdomHCi9mBc/tanto+tKvHd/trpqjmFy4Q5Coqu4wQlidu3kNAzodqsSRftnRlE5nuWO8vXhpsG/PbUVvzdizpIEnpN9Ws6DmpEMOqa/t4FFJQAhG3cDCMIGT1YPQZ0ZzCDczVDGVTME3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
 b=OfFkYmmrNXFpGMB/u0UPLWlTOqCw2VMQW+av9JiQ1bzshNsUjg0vl5FiUYTT+SyBpkGkvkKKKxvoGxsMVh0JtnMY912J4UAcUNnr8QnULAxmnXwSINO2CU3B3TGDyuzwSIKxUOJGxU9ANKlSBvwiARk3ekHBvbNRfSEJZJKDTrY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:54 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 22/25] btrfs: add btrfs_bg_type_to_num_stripes
Date: Wed, 28 Oct 2026 19:21:08 +0100
Message-ID: <20261028182111.160492-23-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 11fabd78-87ba-4045-2c71-08df352057f3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261022105027099003|261021121427099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mxCjF9flEwtOzp+CYvOk+G5S5QkZ+12tbKcOv135R3XK8xDX/yUdI+AQRCC5riQE0koKA4vkGohkXyvgXxMsVTx96IBIrl6gqDi803DrCG2JyO8Lil+mX/dnJeNGSTdfDQ1llQyBU7voR14+L6AxYabXdL8jh47a6Umz2HmcPtVPx26CuWOZEgbUGYVV1drK8/tfQcCi7nEg5j3D/psTjJ1KXMzFV5XAoyUs/5NSD9eb26qHuLsQPaN59kFYW7g3I2IWQqLvtHt/VBNZBb85hqal1tDfwiOGF+bfKF5+jc6qelFhgGMlHwrnKTttBvbzDcdsCXEzS4p6dSqInVZRTIYE9wrQj2ES1Ke4IcY4Njrw85GE8WXvOFAtoa8tgmnqh2v7WZeqOGWPb+qBcW92ucyy4Hp4fZhRWFYYFNxTpKWry9QB1moTHekgqLMLpqJVzgHyetubn83rMDMtVNwz7EYjUklytnJZHvE1W/SRUUWyLg/Oo1UEX+ro8I4Zjqq1o7Vk7V6dJr7oMzm1V7a2pRl9loL1U27Va2fywJ/EYqHOpc2NnRYE2qiCN+0rlb7ukIg36qVavYnSqg8GTpCUzyRzUxTagtnNET+bzRTe5xuX6mv05/WUn82GEJcI3BLWJAAO9/02OiMmEYydN8ET9Q/aph3C3eF3bB5UPZJu0W0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CGWdNQBTCRfdS85N4+odk/097Yr7N6mmLwaezvmaHQ7ysF8rNKiaOmIY1i3j?=
 =?us-ascii?Q?3JvGOlDmEETHBG0eefSsJSxAB0qCNTI4jZi4voMIz1In9LBmL7dNb9gC7jrF?=
 =?us-ascii?Q?LoOJk3tBHbSKRZ15IeMjGBzcUoCipyZXqoGC2cAxvhY9+Y1/H/iew3rFFamf?=
 =?us-ascii?Q?48Fkeyy6Jaw3/Fs8r5ZEaYzm/zk45KAQLRxRwbwKpQU27BNJtAM9W6ODKaqQ?=
 =?us-ascii?Q?X4B2kfdbnmDcoq/WwVwkJhdM0QFZRewgKAXzroX3q+gd0Ga95ppjo+1tsi6H?=
 =?us-ascii?Q?vv6WfXMT6eDsu9HxmtB6PJgQO/gJMC6FkyhbmwYHCaprv9l9SffIZ2rhI+/4?=
 =?us-ascii?Q?SRD7+9Mhh4Lqd8T0LhmuUV52NrHxU5xpLwO+d54ySw8vY2nxmiGV7eA9saur?=
 =?us-ascii?Q?G/p8JrMCE6fLwFM3S+M+VC7rBtmmn9FTUDW6diYqpmGh/fiO3LIG+552dYQ1?=
 =?us-ascii?Q?S+XqXihsiepA3gz1tsfL3QidqSvmEw0TX5hS8gwL0IJjYAoDwFS2xNPGHMlV?=
 =?us-ascii?Q?d4sozvU2o+qzv+Qe+ie8mrMRLr6AqmnZZ1IT0rieuMdPEat3irYIhyhuuaan?=
 =?us-ascii?Q?xjyHz6YOdhjPcq2G+ipGGYPeZB9xt/0HPh21nyXWza3e3LIeX+zqb2f+lhZf?=
 =?us-ascii?Q?ArWWQAXjOw0hsLRfJIobN0TckWDRAMfXjeD551LuXyVCQycCCThjti19Pv9Z?=
 =?us-ascii?Q?Hg0EXC0Gq2wFejvtBpFUZ+BUdn8GsyrWt+xAQm6g+CIpBdL31rSyiWhwaaAq?=
 =?us-ascii?Q?GaskhJDbciRo3sJAl/WsxJrrrJzrBLFlbErlJ3PoXBCqLWmbWcTCc6Z4wLM1?=
 =?us-ascii?Q?9GRv2oQ5Ev6ckg4E8wTFPPmxmFDAIYpLtxrIIM0A724NetVDaV3UvOCInbrc?=
 =?us-ascii?Q?NL9Tq6zrPWGDqw/LRzM0d1W7z+nk1lQcbohrAESKqJdDvdkXfk1qCoRzOJJU?=
 =?us-ascii?Q?8sNhvqQe1EgYVAk1t6baWoSvv3X/59Ps9dnpnUQdbjPl+Tk6abs5mof6KNs9?=
 =?us-ascii?Q?/Dvyh3RvghqTwMeT+SeyL6buM9onwbLmkY8PhMH5pkwufELt2Qqntgy6T7So?=
 =?us-ascii?Q?CbjS+N6Dg0+iqK+A69YW/k4QNEo+QzYgNCOH4Gjxs8Q5Utvn/2T+WEMESDSJ?=
 =?us-ascii?Q?aZJ51xkjJbNHceO2/27IenmdbkthqKCDvpi7b+xTsMx9hKoSBTW8gNpfex/G?=
 =?us-ascii?Q?RnxFfMgmbbDxFLm8YHOAXx227xGUiobKsVkF4zzh5l7nLD3GcBfu2Y2F+oEb?=
 =?us-ascii?Q?6fwuCPbWwMr32b7SXBME6FLXm3w+h3pa+NHRl8HKybqMQMvgBzoDm9JsHwqs?=
 =?us-ascii?Q?LxqjkFQQHrs+V65GspySk+Xi4yNGalXtnb64INVAW2ZelpQVM7C7+a5QCPDs?=
 =?us-ascii?Q?LN+Ji7mTBpnS8UMcSZ0TFZSZa9gGgaNbo7fryyh64yU353I+sL/YKWwNuqkm?=
 =?us-ascii?Q?5Glz/6zwHN2wKb8QS0Yk8b24yIdti9AJKE7VgNs4UENCFgIM6YEW3NW4Z/Tc?=
 =?us-ascii?Q?zvkQ+0t+meFr65h8l+8gSUblF5FEw4n5tQ6tliyONPiQI0k2XBxu0yHYgqXJ?=
 =?us-ascii?Q?JSD1xDgaALraUWnXocJEmuJZxjrbYVmNoV5LVKxwlpMZFMT2PU4Z29f8jpOG?=
 =?us-ascii?Q?FRR6t4a0R1uiL6KuOUbcBGFMJdw2sAq5X4Mp4US4ejH6WPSIxTTeVMHhn+IS?=
 =?us-ascii?Q?+vuAyfrRu3hzsdz+0PhbaxZ8+rSss+viA/yFvmAQBrF55oR12II17AsxieUa?=
 =?us-ascii?Q?t5HMpkkhF5u6ruan3cxXPyT2huci6DCblgHgNKYBttPfVGRMWjkjUotB7MGk?=
X-MS-Exchange-AntiSpam-MessageData-1: oqqoWNUoYnF6VGRwaZl6dB4/5XtlhKdCUw8=
X-Exchange-RoutingPolicyChecked:
	pnp/Eb3VnGf7zwlQX3GFM7d1jVl2MK4ahOxg/ngbIe8q/h3+cROjzzhalTPxUgC8urKiOvtyyjb19Ry0xiMtTr6kXWld6q2jNEJD5R1I8722QJEWFyYTqi0iqCwBOfV8ZMbDpnHQiBOn+nPFzOX/3CplkVcyfRLVpdPYxbYzal0w80Chium6llo+g5DXOFmkPO6WtXqflpINIOJ45y5h/fzWgBmbWJO6igdFGSLaNrr8NxH4H3RWap0e+rSB5YzidH5KG8obfyZm1i53ThJ+LEVKPepQg31Atei6tFVvNIrdaH3k60TfnWYRnTjfqcJ0XAG3xq3X9CCH3jWBSAPqrw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DLLqweJ2pvbXWeEJB7xebD+tl3g7p749zOIQgiqAkSJ1xiM/3rJTIXNnfx/9qltoL78+TKXdNdJInIO7OlnLp3MRT0IYqs/VP1e175QjjeE3jz6rurG3oUyWuROR027jWLAForuKb/MzKum7QjS+26vD4CuDxzkzfBtzhHSC+FrYHN0BMsGcEA/QJPnPepBfY1Xa6B22xT3qmHdT3Safv004wU3/khWv9TIzTVVPxGYDlzp01YpZhk7xC2ytLhzRZ4vS+bqlUocT6b7agO41/NA4LBdw0zo2Jstzeekiw2BvcfNwd2BjS41yoCAJ6f0XdJkV25Fe7SXN0xQDPIVEBf9s9Glcl9W6M613QchRv8nc7eiaDSouqPLCNdsOxnvUPJo+drNhSnedQyEKl2rC2SKZYNHkXuEz87uGjHlwZkpkBOu5JrNfkG3hQHmUXAIw1T62Xh7jzsK4Q9ohn8EQ/2TH9XyBF929cXrzw3vy0a/DQO/sij+H+JtpoSeq+wc4Pn1LFwkikR/E59UHa41yV68F29O5IS0gOpXLDjflEjgHHHxGMrI0jCEPScTdEKc6n9Ww9W7xtYUwM/MI6qBC2sxZYl+kQJdu6SpjjM+6wl7nTANrBZ6HilLScRIl0GbM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11fabd78-87ba-4045-2c71-08df352057f3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:54.2897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wUolOyzV2QmU07EgK0dQhzZ2zXDknre6HTb6DL1BFokDUeFtj+7wlU0fvSDQcgMNXMVFDeGVjL6i9Jn+LkGBEFYaE2fm7S7u+zZsZ7bk39g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

Add btrfs_bg_type_to_num_stripes() a helper to get the number of device
stripes a new chunk with a given allocation profile takes. Profiles
without a device limit span all writebale devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 13 +++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9721efec4e45..56cecb8550eb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -195,6 +195,19 @@ const char *btrfs_bg_type_to_raid_name(u64 flags)
 	return btrfs_raid_array[index].raid_name;
 }
 
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	const int index = btrfs_bg_flags_to_raid_index(flags);
+	int ndevs;
+
+	if (btrfs_raid_array[index].devs_max)
+		ndevs = btrfs_raid_array[index].devs_max;
+	else
+		ndevs = fs_info->fs_devices->rw_devices;
+
+	return btrfs_raid_array[index].dev_stripes * ndevs;
+}
+
 int btrfs_nr_parity_stripes(u64 type)
 {
 	enum btrfs_raid_types index = btrfs_bg_flags_to_raid_index(type);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 75b1179776c8..27e0ac8fcb14 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -914,6 +914,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info, struct btrfs_devic
 enum btrfs_raid_types __attribute_const__ btrfs_bg_flags_to_raid_index(u64 flags);
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info);
 void btrfs_update_per_profile_avail(struct btrfs_fs_info *fs_info);
-- 
2.56.0

