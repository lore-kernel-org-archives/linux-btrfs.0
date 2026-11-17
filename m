Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794905415;
	b=WcNKXbW4mx63v3dVSLff2nW9db97LR4uz8WBd6ts2urXsIFSlQ81OmE7yNeAIaNwpi2b
	 PWp9GVqypmwU4CEahqYFYJOZRoN2ALO7dB3KMxyzcjrnGqef4SWMAFSIPQep/wJ8hxbLc
	 unC7x8WZ4G5PCIvcYRta1K+5zyV8BgVyjKALTD+VAWPTd9Nd0W3SjDA5jE+zTwehEAMON
	 dSYbte637RLE3V9n8pOHUGWsXdw5JdSg0tx6Ni/Tjm0xbO7WQhbAIDxCjc1anUoNupger
	 uhIuLnDSb+m1DEYXG61YkcqfvTp/ZFUB3gIWqEqoH6jdq4lh5uiENGh7ml64qCIq/jg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905415;
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
	bh=luJRTRdeZX1gPtiYHOSf9RMEwITll5XpaTNQQqueP2E=;
	b=YgwEWhZJeWDXmHdYDhZ2qWnj1078VNuKMpdeMT2hyy16Qk/ZAYExnh2TdzJ032dOdM/f
	 SolsVn1w41Y9lJjByCpR3lym7bXAqX2CUXkwkCu7LQTePQzE1ZS0C+nwdHJBJML34zJNx
	 cu7FeYlga8ABM/vO1xHSdgl1jsBmq3pLfvqHMVs/RbO2quKCsy+geMxwWsVVcc73ENvtW
	 mF4yBd6VBnTjC7EZzO/rMAbus/lN/qINRPX9HglcMiidxTYiordkEPP7CzFOMxN3ro5QU
	 IV25dyuHLSo5s20i1Vbzl5WxLSGEoQaEYIAze2KNw0nizsh6XWaJT1YECv9jPwAF0Sw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=kmarY28v;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=eOq0d1mo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3849E606A88B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 08:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3849E606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=kmarY28v;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=eOq0d1mo
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794905414; x=1826441414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=5OxRmjQ1pvtPvHsON/l+8Ma/pyj8UZ0JRC9gOE8Qv5g=;
  b=kmarY28v0m06v8XmqMDRq9Px3AUxIs6RhPZ9jaRFUJ6r1qydHfjcFkVA
   yUFa02J+7T9DRvNE6/S31bgj9ooRGnHDhCH/0r6EbKS4hz6CtrnWAL2Du
   fXdlTXqZjLAdJC7qFTSDBvCuulpOd0u4Yy52qsJKv24uAgVRQpkhC2p+7
   27MRS8yDl5DXDPMiMbR2FfYt9Dw9PKpw7HvTwZkt3QDN6mYU+aNJx7f8x
   9J1eJSrblLhLlhhL/TE59uUnwMXkPPMhF7PWhNE6KLHvuge5uPmJJ6FiM
   1wB6NrRn7fYr/+AZfWna2fA8HhR/9rdcakc33sRYLThKHjbNa1Dniwt1y
   Q==;
X-CSE-ConnectionGUID: +ohq6hnLTDu3hNUdzXRwJg==
X-CSE-MsgGUID: wnaIgbD4Tjm/97uAsGhb/A==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161007160"
Received: from mail-eastus2azon11010015.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 16:50:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OIuqu9HSq0LuPV7H2sn2FBFkTRs/g//JqlcpH81H2RZl5NrD/RYxwx+5+kof6OGI47O+qBq8/oYnBcnvcmtb6ImaBwmEwJ+5FKbJYRt9v+a8Pk+sNrUvdK/V97YBh0gnLpwHM12QFBOjfQKf6PJIXWiplQgSoh5+WshqsCoKGmvcTQwU3PJr1/4UExDqvT59zba50oFuGhdSJmpxGRj5xisDRpsND8pobZCMZQmJdg/i9kZy2+0h00ZBzFTgB8MciFPzGh+wcpHXwETImIoVWYNhMRORbVjqn/RvSW5XpSHbmqSVBIfltgOXwFewmgyaTPlEethvHk3bt3HiqPXVaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=luJRTRdeZX1gPtiYHOSf9RMEwITll5XpaTNQQqueP2E=;
 b=Cy/sBI+6a9lqTgs53WMdv8QSQQVJZA1YTlvV7DvgZMCMt/Txjg3aO8Brv/EQ+PRgbIUS0DyL3KV8kwihVMOtIbYKd37ndbbmMwf+o1Rb2VWnHHU3iUlpecHydawks2mvrxkJouZvOjIWxtvSoDxmFCG8ABMV+j5hsLFpzYezV+KFefsOXlVpuIQnRSJZZgoTXHLUH2sPBbNi0eU/8ZntLEgeNXApP7sbomxFF+8yLEuaEiPWT87Ys4dn261Ohy8x02VfoO+qCSN33W/9Pdae1hP08m81RoM9v6r0oSZvTz0SR737Xn0Yn1uRNBLw96jIE8+sgW28iyQOAwKzLMLowg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luJRTRdeZX1gPtiYHOSf9RMEwITll5XpaTNQQqueP2E=;
 b=eOq0d1moYIjfh5cNc2ghfdojDZOksEmLZK1TSqmaCmnUxJ5RR+Vwg/aexD8B1v+uXwTMff5Sd8Na0q3UMWcKrb/TweoiFcdHH9xtqTIBIBdF/qpXV3/pztbdKjsjLyKQotaNR6Xvlx7w2RET9m3VMaJgItZjYaPhMpI3gS+vhyw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8145.namprd04.prod.outlook.com (2603:10b6:610:f5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 08:50:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 08:50:09 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Mark Korenberg <socketpair@gmail.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/4] btrfs-progs: zoned: add btrfs_finish_dev_zone()
Date: Tue, 17 Nov 2026 09:49:45 +0100
Message-ID: <20261117084948.3848762-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
References: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0401.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f2a9e42-a972-4838-e68f-08df4487c922
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|10070799003|10067099003|56012099006|11063799006|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 fFXdFzdoH8eK77ngRKVc9+jtoukk0XJ6GxL994gkv5YKhvgvrVOecK+ZffxU/3V58kskglIqJzvT5S/YCQELgDC8GndT4/zHyX2w31mVfKtBWSAwr1FjF+1IqETd4AZ/xeYU1wmYnmV+ZmUP/I2tL0M6lLlO4FUTpqBN3vaMBJBeMsyNdExKPvPLY6IQNXkYlZEdEzwatN4rbYSBs7sPZhJy3m+fLXIxbFlCt83U+AiBD2LE5U9wqRHqBYoDVp66Q2h+SeMs3GxU8hOEP0tL3vDtWM5ZyjsFRQtXR0E28QQlo/4bNW58iuwHqBM9dkhj4SWMGGzzPk9C8E1/IfqygTKdM8AeetQA1YOG93E+B6rSJnUxrNlF8hzlgnk8WBROKeGSIuuUuwjjlfocc+/12RpXYCs2srzJZ3IFWR/O2QBWwjmnc8dmuzPt6kLtrCGr3VdEme6O3CfFYBy1IDApFP/1aBtYu6le8wMbb3hm4I7Cv16Y7aqPA1wVHMMSnpVBOV3zAneXEW1vWAznNbk/ALPe6b5pSikWdy9fLFFPablwqv96axSK2SnM+Oz6Hcxbwa9/YaI1aFRedXYdvVj4PAWyzG91yL99yh7UG/obaiVisKWbhZozZHqFezaHH/kGREvXdKIUDWyXWVZLlwLFcKmXcnZy4XDb/rn//9xq1Dc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?7Q8e/V9uHwujJhDwf44ZDFlHoE2l/QnxJYbBYIHWC9KOjWJUXstFGzWKfVfR?=
 =?us-ascii?Q?Q0AojQDA3RnEy19z7rLOf1PSm3nYEYuI5dBN6J8mHwE6kLHBQstaBUzaN3te?=
 =?us-ascii?Q?u4TkAwn0y0+Fk9HiR/KoiBlgZi7834g3GmPbCvJWOWJXsMGEIR9MloDsT4PY?=
 =?us-ascii?Q?qUqqXMnqU1N50UAN3WtfJ/iltQYM/W6Y37JsVCQEVv2sKzBEOnzitq55vq02?=
 =?us-ascii?Q?coWHo1tbAGvVnqY3rUzPydUK7PG+QQ394ZZrHj+vywOQJED/2W9MxZAscy25?=
 =?us-ascii?Q?kZGR4JvVAxAiiXREzjFZtuLYDv6m0og6aU9I2gGKrxbVLHCTbxuo9s+67cJ3?=
 =?us-ascii?Q?g6E1nuhgCD+1u1JPFpw41Mt/fgxHRbN46jqJ6+cchwMqcu05VA9FrZm/FN32?=
 =?us-ascii?Q?GK3ZbABom72V1RO726fYtMvEJzQKBxUrzqzQ9XIF9k7yvkVPVG8zFJujnGCb?=
 =?us-ascii?Q?Fn9ALliRquvsdfAdCUuFuPvZUbBLP2h/VxuK8UsUVSd7CgUBp1XilaXNwevh?=
 =?us-ascii?Q?0Owa/vgemHSeues5NZZlCA7c9+xf3VcEHFvdiu1Nghr8wzqpjGwLM9huBuZe?=
 =?us-ascii?Q?1968lBdNRTchND0DkJm00yuomnFJEJdQ6/qvW1cipBeXt10jIi5apP+CbBw0?=
 =?us-ascii?Q?lPRAziekPKVE/WhLEyRtWb0CKw9GcHOnWraMSxzhCW54bQ5ltLl+TAWXgilO?=
 =?us-ascii?Q?JE3XmXVd8gBXMRed15MTxlstq94LGCH4DP4wU5920ThGi1ZkhyZfda/a2jF8?=
 =?us-ascii?Q?OD1xaA6EemEys+7+9WcqwZ6fVo+/na1YjuQnoj59hfds9fIaRRlk0PqNTlCJ?=
 =?us-ascii?Q?HSA76f59+WX6iLSfRrNJ3Zb+nV7DK+7DfeqikC6bhB3bB6o+1iXNZJdFD65i?=
 =?us-ascii?Q?q9qHjdbQmVZv+xRki8MpySEdZVB+AcNTpfrARvEOUXx9mVW/S7lLFqQTWJep?=
 =?us-ascii?Q?6znjVwBdkoaDib9up0OCrDBwErFqTOp7oZXa8KdOqDubAZxna6i4jX59cqlw?=
 =?us-ascii?Q?4iru7JjvVrWpvkEzCX+ahPFTdH+KJv3+6bYDRy1/hS2C+/9JjtUjC82lIyVg?=
 =?us-ascii?Q?d16iWrl9YSDoYdUMY8yRlMkuHNtSfFnc7kpISkro+w1/D1BY20MxGiOTlHtB?=
 =?us-ascii?Q?DoMMijKmOhl2frT9rioRFGKfl6ZhSDh23N9h9AsfDa4aR1SDJmjW57YmMVG/?=
 =?us-ascii?Q?ym8MHxcU8UW/4zmLNaAKOVkY9z8t7l026ol7bI223wZ3v/opQDKbcfyEjs3Z?=
 =?us-ascii?Q?0XnIVLbDvLqBofr70zz809W9OBWcpHtKYuAiGu/mDkH7Z1Vbu9xc8HnrLtYV?=
 =?us-ascii?Q?PemEreUZLU0+P4LIszQMu2O49QdMXEeQO+N0NTusxZzs36M85bVy2IkSgyHd?=
 =?us-ascii?Q?U1Mxqdil497qnORgMMR7KUVWmvQcjRxHJ86f/HvFzt62bfjxmEO9e/sKGozD?=
 =?us-ascii?Q?wD4PEhXQvyZuo2O/DQjpmc5bqG0fh+1eHKsU5LkCG0N7Swqp/bxdOUmDJjYe?=
 =?us-ascii?Q?xHWvP4mEry9rKiKOMnwS5dOGK7yTRx66cbxANbC5atOT2qK77AH7aP24q2My?=
 =?us-ascii?Q?Gs/jbUNFzZKY1dbfiWohMdVmMX9t/a/oxSCIS5uS8uYACw4ooJALrvcctHfm?=
 =?us-ascii?Q?FFvaLbqMruy5aGJ1AX2peRBuZgboJN+lpTy+wB0C3+oAXpnx1IDltqk/6+L+?=
 =?us-ascii?Q?NAMtaoiOj1LaFlY7zrA14hB6HpBY+fyuOLt5tBN30WnKi5SJQTNbTt3RgD6n?=
 =?us-ascii?Q?OMiHv3eudS2heTdtnkrzJfxGrSak689qC2EKlIhnLedV3dzesP2tptzfOOPP?=
X-MS-Exchange-AntiSpam-MessageData-1: ar8jCB4cM5vj8iCAQW7L9g73YGGG6SKKY94=
X-Exchange-RoutingPolicyChecked:
	n5uEXb29mjp7mKaAsIOXcERCiJQ5TKldjuCgAEvwfKakEJF6ja61OxSv3GCeLoKhNLwdZOTiEh16AM5jij5muz0FMYqta3aMqzb3dnJgOZrn9XUxtmuZk92wBPAi+QWOujIIKNo8mjDp8+ZLKzqFIrj1BvW07VTpDOb4LfyW3/q/zwhaQbXMNgafb29mI6oBAIZ1FDkgIE+/Tfsy810XDSBRN7AZWTte7ejSiSHE0rxPVtsAq1HbQ+Er1TdDu/kn9o2QSlVu8BNJ5AJoF5eYlLFZKtawBovjP8pj/ZoSxF3zm3+b02QU0kEQzKWX6sKBenEQSarDdULYoZvUladnNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+6YkFiEIFyYuH//8R+Nx8eC7GA9wEbs7s/5xE1KCBMWtoPGn6zH/nguN1r+siEyEtSxrFdoucbftEFKWdUiTMhWf0/rIutslCxSYV2t1Uq1t25lDh5zM5tss1j/xfWQjF8IXZWJb0IupZkOpjgXMWTGsA6iicL3D1GD7L6SrrCwWsXuHIkyzRuGp2CF+LO3x53+oWtjPRMx3Ze/V/jlK44sxU6WUpHwAFngzPg13ZT6r1SvGXsnGGRPsxvK+a6i4bETtmkWoRYEa0pilF7MpQvqPUJNwXTIjePcInmvNRD18JigVOgVPLbObvZ+N+BbPxj4+zUfJYrBSmwLZMaH5QjOc7zA3qshtJ2uvOuygPiPhX3T3nOKRi7K8YRAwXOFPJ7shKKKPbp3OZB4d55faLIXkY//WjW6VrKOhmGpVH+k9qmMP8yrkElLGrA7aZkSKPPcQO0kKELkUhIuda7P/ERqOtna6Q2Oj2CdyhUHwm0pSy2YNNdkFoytiLIUVZDrY/yfvq6qKHBDVQN0xhqCpsVr/31Z44wA3VZchragtH7M9NXv218fI9hikIt6vOGMbQQyp/hgI+NbyuJKVPCUZFCZNd4/FvBw4EKmVjYLg0RElT0O4xqakYCK75UX6Z/1K
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2a9e42-a972-4838-e68f-08df4487c922
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 08:50:09.6483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZ8nzHfQlJwpyehZ7XQy46f8ZTqEpFudCtqUSLQW9bTHcNFvIwT2y8Ziug2JFyLbAf0/AlAV2CcNHiCVFsXZGUq8L59/rv84bxCozlH/wXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8145

Add a helper to finish a zone with BLKFINISHZONE and update the cached
zone state, the counterpart of btrfs_reset_dev_zone().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 19 +++++++++++++++++++
 kernel-shared/zoned.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index a06abdea..48313ccc 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -329,6 +329,25 @@ int btrfs_reset_dev_zone(int fd, struct blk_zone *zone)
 	return 0;
 }
 
+int btrfs_finish_dev_zone(int fd, struct blk_zone *zone)
+{
+	struct blk_zone_range range;
+
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return 0;
+
+	range.sector = zone->start;
+	range.nr_sectors = zone->len;
+
+	if (ioctl(fd, BLKFINISHZONE, &range) < 0)
+		return -errno;
+
+	zone->cond = BLK_ZONE_COND_FULL;
+	zone->wp = zone->start + zone->len;
+
+	return 0;
+}
+
 static int report_zones(int fd, const char *file,
 			struct btrfs_zoned_device_info *zinfo)
 {
diff --git a/kernel-shared/zoned.h b/kernel-shared/zoned.h
index 7dd86e4c..363ef4a7 100644
--- a/kernel-shared/zoned.h
+++ b/kernel-shared/zoned.h
@@ -158,6 +158,7 @@ static inline bool btrfs_dev_is_empty_zone(struct btrfs_device *device, u64 pos)
 
 bool zoned_profile_supported(u64 map_type, bool rst);
 int btrfs_reset_dev_zone(int fd, struct blk_zone *zone);
+int btrfs_finish_dev_zone(int fd, struct blk_zone *zone);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 				 u64 hole_end, u64 num_bytes);
 int btrfs_load_block_group_zone_info(struct btrfs_fs_info *fs_info,
-- 
2.56.1

