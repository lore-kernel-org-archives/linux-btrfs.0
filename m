Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085771;
	b=p4IIGZiQcekXlKJLLLHRHA6H3F/PN3T+rUwcaoAvJlAcmtacn8basjPSXmOZE4lSd+ct
	 Qn5GytcqlQ+pobxU8HAbXUx2xa6NM+zqy/JMDjlftkUChpWjfLdX7iaJ1rJjCCulmCI8Q
	 ZvGIyteoEQQzi0vrcjTOH+xbTl03+xLczbHIV58Ys9S8LJIm2G1bTflWgUsiAU5r3gH8R
	 HPj0P5P9hCxFTm1BPTfOrrZWGKzU0IoFY9odkeyby4WJmK+jzMjzRaD+ij8RyuW826hdL
	 tq8VpAoBhycro1U4s8kBsAB8Bb/n74o4+B0zcmARh542zJfAb00W1kPz1J9GX1Mfl+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085771;
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
	bh=ekanEK6aY+SjLef5re1W9hjovtr1U1qlDGczF3zWS14=;
	b=WIjGQGG1hkLoReIN3+QD30FHBFDNJqmEZCRPD2IVtL4YdWtq26m/MIW82jqI8G3fZWAk
	 2swgb2WLa14wB95FtWToGk2z7+yLxFhzhL4XbFiRE7D7xKz/ktvhlbaIMP3zM78dFaXbH
	 HYrZWZ9dXMyV3S8Y0hiGN40hsnQwi1g7Fmg782/unjdBT7p78dJl5fTshoozokxgknB59
	 hZxU3QF30mtfQ53+UFQdhQvgDoMTz9WwfYpHuI2qsBlzme59VHh04nMdwtuuJfJNTRNwO
	 ygOH4gF8s+9IdsI/OSS58fHgQXJvUDcttH6N/PM7Cdo2asbuQAKSzq2MJvBU5F7UscQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=PZaMZPUa;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=diEbPbll;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7683D606A31B
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7683D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=PZaMZPUa;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=diEbPbll
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085771; x=1824621771;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=4Bqp4Cc3yc/MRZBLCm5If3qYJWkhkcErELWPqauAZbg=;
  b=PZaMZPUaHKEyeTr/a9CSZuW6oB2PlRZYdMT1SZ2qwGjpi2CKf6ZiJdyM
   qbk+y7BChrsl9H1YQL45s++T/zmV1V2utnTWYwZtiPBgHbd9WJMJAGWTn
   GVP+ZSV/w7V4/juUkBGBr9BZQn3MPErI5rSBWy953iuI17owpVv/n8QcA
   8Ncci/yC3F5eSlibUize9zixPSPt83ZBLNC+fdEJPrRFF4S7aXQ/EIMSO
   WRuBFjf+MD2t1jgC41huPWMsYpaECgr+0YFuiQQJyHE2zf37E2meLIMa8
   CVPEy4SRXuYATqUwvoFS5YU+DGju7cbqxRxBJmEUgQ8m/e/yxaiKDDAqY
   w==;
X-CSE-ConnectionGUID: 1z415MKDThih4ZSYCp8f3g==
X-CSE-MsgGUID: dx7bwhyARjiLXYnp6VY/Tg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="159092286"
Received: from mail-southcentralusazon11013026.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnllFVNpDmVs0Mjfy1iA///C49fCol/eNgtgUlPD2XFrTfrjCFN30+x/5u+/KugXHt4TaxpdUG76oKioXzMet/ilLJpYesnoY2kGz0x/oEBdFFePUl1qFjnK91cbi0VNKAqyHPKAiO6HASC0DzpYyqaoLm6O/3/imQzoBOe3vtoVRI/wxfFiowGrTBHlq3t3+zKObGAqBPldDjt9Tj+k981zi2Or+7Rw/paZ189Z7HFevEOpNbgGYnGthY668F0nyAtBtsUG98zYWe+09tZurKPsmdy6wzzHTqljsKubdKaS7uScBT4M7pmv6cUTx7775dOEC1jyw9ifP6ZSV3Rpqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekanEK6aY+SjLef5re1W9hjovtr1U1qlDGczF3zWS14=;
 b=GMzTZZg9qa2peLYDXZSwmiAgQA97bVK2SmMsNGIlg9s+oyWD2UQDa2iyBdNyKSiXtXcy/WuuRG7XpzIFpRuE0tGvVbZCqP2RiHLZFztaEEw7gzdFq0UcEJJCrjcNq88gA0mKS2KM+3G95mttbtvlOflGWH1xWtJQd2Ry0dkXI/V61MOQDV6K74CgnedggFs+7CO37REtdXLPjYIJfS1CeehSUA6ZT2DYyijOB7hBfD3hgq3JzvZEyuK2oK8gAdGqd8rbsIVg01Bl6GSYCEI86BBcnKA3lpl/kXNlZZLDBXzeKW6p2crQGoat/Nzs6/bGmPFeERbVgfYdufbeMK2vww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekanEK6aY+SjLef5re1W9hjovtr1U1qlDGczF3zWS14=;
 b=diEbPbllNbnp+dfzk1HhSwzx3dtSyw2GUvemvvnRG27e2tpjJIgm4LOYRXDId6FT6PvyrHESSfqllHA0HwdDAmYiNlXHbmu+i8ryRiHQTVZIQ68MxU7WjlsFiTImbg5bVuNqKudSVzZoW8d03nGdBK36EHWNLbU5KFue6kqPfbw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:47 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:46 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 00/25] btrfs: zoned: fixes for generic/747
Date: Tue, 27 Oct 2026 08:22:06 +0100
Message-ID: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
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
X-MS-Office365-Filtering-Correlation-Id: c242cfb3-a706-46a4-994a-08df33fb1973
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|6133799003|18002099003|261026121527099003|13003099007|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	C+b4Rtr7LK3Lkrvtn/RiyqCMSijTjCXamVKjh6tgw385awdcgi2vG/2KJ98J/Y8IiSPGWbhO4aqP7rXd8qAz9eRWerVKYkFd7rFJ7qwMvSomYVqVCx09QXb4YUOXv+nG6xmOs245NgVrfmVH3CqMfxLULlO5RB+yq3b86md9/s9IzTRFGxa81HGSx/sAtbOaFctS2QaxKot5wdxqa0QypI5UH2TbXKYnYJDibtA8QcZEHI0f6KWZuiN/GcuBKN4zgTpOHtWheJp+5NZPXbmreOa+/yrHFXRv1D9Q5aRdaDqiQU22C6cclu79BtCpN0dy+n9B9xws5Xn7jHWFVn8BaC9OrYNvjr0DtpoAKde6L2Mknjsjh5d55uOSw41u5cf4InrUNbavitzDCoV+7Wm7k9m82TQk7G/ccddt9n5cj9XQ6GLQiCXCc1U0gjl5VdSFnpTyK1jD6DpZyjc0O46HTCBxNlcWjvaHsd06azJJ/NsqV2eSq11eM8/o3ZZgHK5jB3WgUtt65CWhlRKy5DOK7izdpJd1nbQ9xWJGbeBz5m4hzmIBcvXGJd0h1B8h1Vqyn5UlOgetUO3zjS6QxnNO4Q/WqYWwO8+r0F755iSOVHIEjMbhwvV1isZPdPNBh1HH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(18002099003)(261026121527099003)(13003099007)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AUpmbuGUSwp3sXScZr7jiLVVx2STqsowVmmB2PkweRpIQ4piPnpv41gJcRWN?=
 =?us-ascii?Q?seLbNHKRHjvmVK7mVr/RUfUN5i0wCbZvKXebQqVQBUdVMya7OYzANiTFS2ke?=
 =?us-ascii?Q?y5GDDFItXxwVhhKYBYXqsGu8xfUKtC0LQfWdXMJTDOKmrag5p/Y4R8qCsWbJ?=
 =?us-ascii?Q?tbichD4XFrso6LMutHk40K1sX0FoxvRqaoWt4rNbs1gmnAHQhJOtOebxHIET?=
 =?us-ascii?Q?RBNaOTi/+KPaZSe+tKnvS2wuH00+fOG2N/dtrjewigTYwveNIy02z1pjCkQD?=
 =?us-ascii?Q?ZVKogRgJldcVvuHePvd+NSF+UewMi9PNdSBQO5wL0nqA4UjiIelkX+nmVPhI?=
 =?us-ascii?Q?Lwif1BPV2mg2PSRmb4QNGOnpgt5nF7WHDA0vAf8Y8wAUskddHYKDIbn8lA2k?=
 =?us-ascii?Q?LD0FLZMBks+2gnRVQFnAB6+75d7yD6JV7ltRSyy0DEE5hsb8RKiHZoXjv1fg?=
 =?us-ascii?Q?g9EokSzJt7olUTOfWzwZCn1oI+W92/SHKJxRZXFqtLJHIVLVAJCrKvlC3Lue?=
 =?us-ascii?Q?toQ8mFrlN5+iWZ/gwBUxeLLCV6f8MFLKU7zpsy6wmxkwVUV2y6KrvqGTjAzX?=
 =?us-ascii?Q?w0ZpIgy22WZ5c+jip3KZTqQDKqrOpiXmnl3VG7zRkK/W2jJq4PVtzm8wmYIE?=
 =?us-ascii?Q?iZHM1FJrFg/e33a3U+1mWHZiwNQBfZKKj5MunhfUzp7kSEp1tTpJ1WnYhP0A?=
 =?us-ascii?Q?PiVeLhTZGxP8I+9MYymR8VZRwMBVw/6DpNRXwQCwl6QiZwqwD/vrkO6yBL8A?=
 =?us-ascii?Q?qKz9GOVs7c3ncgU79bJT+iqRwjdYL/yRAbzvrg9y4xY2tIqC5dNzLvHyxwHn?=
 =?us-ascii?Q?dtzLYIqikxd7fKHPo168fVnzLm+WJbgFZ/vgUyiRQAAS35fJVYTaxSEu7g+J?=
 =?us-ascii?Q?cKBy8qud14HHYfJauwECKTlca2YU+9PYkqOx4ApYtbZy75GlGXvD+ceNA00T?=
 =?us-ascii?Q?wf5AJnfvB2SHS/uy1pO7QoYxHrU6Agxt747fDIDJ9yl4/HGeIDICvk35C0bc?=
 =?us-ascii?Q?seoMNsS7Vz5pBcGVu7ReU1mrfPnozEuq1DNqLI9zoFTVrp+PDcysDV6i0436?=
 =?us-ascii?Q?YvdzB94rs5z8+R/eV0OYmf7P5TNBR6vzzQEGeWni+18ldFpfdDWwy3PwPyQe?=
 =?us-ascii?Q?/ZaIJcYj3qMLvEQs6M58OGnFv819BM1kLUkcIPJn9awNDcrzPwpLNOhTAd63?=
 =?us-ascii?Q?/Tm4LdB5NIIWqVG6TkutmCTfTS7REstkevVlBr/TsVeMtMIpQwh+BqCGBgWe?=
 =?us-ascii?Q?Nn8aEYPkBq34lm6IK+CBc0A6Uvr1qNFLi71Sky7vQGRxuV8lY7I1ENLSaSb5?=
 =?us-ascii?Q?L7Nw17O1z+cjBBTY+6Krtf1QJNRpENP2hJk7jGcMXv2xvo1qQppqrV7XDdcE?=
 =?us-ascii?Q?hLIa7qyVMW3lX+CmG7NazLEc65rM9NVrQzKNMGBQjjNCZJbpwsTROGLF3Ur9?=
 =?us-ascii?Q?47zkvEWVVE2GugnSdKTP34pEQxU29wn2WINr6U9DfrHZG/S38ZpxRB4zcJNf?=
 =?us-ascii?Q?v4Zonn6d6OPEwgq9OoHuiOOwWDPPo0f7LvfSikmTTYqss/9hnmxpx9J5OyyJ?=
 =?us-ascii?Q?0+aUdKkh9q/etYS7EsAM5wq1N8O6Yme1uNmiA4sk5i50GxH7GSBQGRkSW7Il?=
 =?us-ascii?Q?CEcmUP2RpBCu/R20yAOEVBzvyApYipTRyHmPsN3RoQTdkL5ATGxi5/JO9WqI?=
 =?us-ascii?Q?tRBFSJNSP7pKK04MegiB19881qDoqKhJtxxUOe5t0j7tgxwUXAhXGhkRFwcH?=
 =?us-ascii?Q?f097mVVb4+auEFZT70BCD/eV8+lWKdB7CPmABccb3ywJTFBZEnmLKYaY/u8V?=
X-MS-Exchange-AntiSpam-MessageData-1: agGtKiudz2BBzGfNd+m+TbpnjyCa6d9VYnY=
X-Exchange-RoutingPolicyChecked:
	id2+sGY9PRX1amOWFn5CFtCxicJCONQuWconDKQwGBI3tsPDHNZrgKlWG4WsOc2NYqa5Uh/rubqKh7aIxR86ne4xCDgKFwdS5uAKQfoEseypCksoOUvb1EI3IiJJSz01BNLVWZFT6S5tE25mqprlhcNvX39ChGawAwWMx6TNodJXs6+EZ7NW9IG99GpfTzrvvpFWcpi35Sv2ZNE1x6sgPFRD+7SCedx/S8ZRHfLg3XsAGzqfT+NLEdGlCLj0LeH8XvZYyV/bzNXligXOTBCJ0oX0l3kApbPaP2KGi7Bm1tPHBrJ87qpmWmbhE6ckHbo9PtYdftNgw53TE/6hDFcA5g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S7jKBVyopdzTFlGCEuNUKAEv88gdFFy8RXJa4ueDWOvEpfzQ+Co2HI60Y8tU9PekcDYf/SWe/wlHBEi1hDBc+fWN1IZ6MMt8ejA3RoxT3XJlkZAQCjyQz+VwlGEjd3MfVv78I1M/eRhcjVJosDo3KirsZrfGfwV92iZQTgcw5Wj3e5CeqEMMuuSWz+qvegd02Sh1UeLrXvwW5BvqhOv1f/gvKoBmrrb3fv3eA+UH4Fh5EDtkX0CZbK1znB9tZruLBEIPP8WVRlYoMWRFnu69l0HZIGALRTDZPXIjGdiTLc2rQf07D8I/auqJDQDpefmr/Sl4DShp750QI1FPAGvN1H6BPNGzpor5GJ68/G9bDaTwwaVMkSgWyvA8LZxmOzruYs0Z8jBkrAC7Y/bfsZ3/k1HvXENSS0jaD5ttiXu7n3wrIrczoOw6/tXyO1w+twW18gvV07ekyFvOjMJldWV9IQk5XyDuctaKGuegkzs/TCtln+dU6wUOYiUzGcVQdiE480m/tujUzBh9fyK1seqao4tBIAVx5Vi/KlANb6z7j1/cB0Y7HTJb+S8YXeL8uukpoQBHbRg5luUVhSkl4C3FC0WSEL032WB9ZXtU7dzsgmqWXFfVBw5U25ag7M7Bi7Uw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c242cfb3-a706-46a4-994a-08df33fb1973
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:46.8066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/N1nS2kxUmlMEeDt0qtR5Q2E1oC400iV7BkWBHS7VRsV2aLxpU4faLqnrKbXyqgwjG6gw92L3J95y4qClD0KYZhAwnVsVwQodzKVxx3zAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

At the moment, zoned btrfs places doesn't distinguish between DATA and
METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
METADATA and SYSTEM block-groups can end up on sequential write only
zones of a drive. This adds a lot of complexity, as we can only append
to these zones (and not perform random writes) and for METADATA we need
to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().

Also the write stream for METADATA is not allowed to have any "holes" in
it and must be aligned to the write pointer, which was a source of hard
to fix bugs in the past.

This series introduces a split in the block-group allocation path on
zoned filesystems. For METADATA and SYSTEM block-groups try to place
them on conventional zones if the device has them and enough are free.
Then change the allocation in these block-groups from the zoned
allocator to the unclustered allocator. The reverse is done for DATA
block-groups, which can be trivially written on sequential write
required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
a high queue-depth.

In addition to this, this series reworks how garbage collection works in
zoned btrfs by a tackling the remaining accounting problems and
relocation still being triggered not timely enough to evacuate the space
the user write needs.


NOTE: this is a combination of
https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
and
https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/

Because it makes more sense to see both patchset as a single feature.

Changes to v4:
- Fixup broken rebase

Changes to v3:
- Fix the active-zone reservation race
- defer RAID activity publication until all stripe write pointers and
  capacities have been validated.


Johannes Thumshirn (25):
  btrfs: zoned: fix possible race for reserved_active_zones
  btrfs: zoned: don't activate conventional zones of mixed block groups
  btrfs: zoned: skip the append only metadata writeback path for
    conventional block groups
  btrfs: zoned: never activate conventional metadata block groups
  btrfs: zoned: use the regular allocator for conventional metadata
    block groups
  btrfs: zoned: only take the metadata IO lock for append only block
    groups
  btrfs: zoned: allow restricting the dev extent search to a zone type
  btrfs: zoned: prefer conventional zones for metadata chunks
  btrfs: zoned: use plain mutex lock in check_bg_is_active
  btrfs: zoned: use plain mutex lock in
    btrfs_zoned_release_dirty_metadata
  btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
  btrfs: zoned: prefer sequential zones for data chunks
  btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
  btrfs: zoned: don't count in-flight data as available in statfs
  btrfs: zoned: don't recheck the reclaim threshold of full zoned
    block-groups
  btrfs: zoned: don't account superblock zones as available data space
  btrfs: zoned: factor out resetting a block group in place
  btrfs: zoned: prepare reserving the data relocation block group at
    runtime
  btrfs: zoned: promote reset data block groups to the relocation target
  btrfs: zoned: return finished relocation block groups to the data
    space_info
  btrfs: zoned: reuse block groups emptied by reclaim as relocation
    target
  btrfs: add btrfs_bg_type_to_num_stripes
  btrfs: zoned: keep a zone free for relocation when allocating data
    chunks
  btrfs: zoned: don't count the relocation zone reserve as available in
    statfs
  btrfs: zoned: provide zoned specific reclaim sweep

 fs/btrfs/block-group.c       |  45 +-
 fs/btrfs/block-group.h       |   1 +
 fs/btrfs/extent-tree.c       |  29 +-
 fs/btrfs/extent_io.c         |  84 ++--
 fs/btrfs/extent_io.h         |   2 +
 fs/btrfs/free-space-cache.c  |  23 +-
 fs/btrfs/fs.h                |   2 +
 fs/btrfs/space-info.c        |   3 +-
 fs/btrfs/super.c             |  30 +-
 fs/btrfs/tests/zoned-tests.c |   6 +
 fs/btrfs/volumes.c           | 107 ++++-
 fs/btrfs/volumes.h           |   1 +
 fs/btrfs/zoned.c             | 810 +++++++++++++++++++++++++++--------
 fs/btrfs/zoned.h             | 118 ++++-
 14 files changed, 998 insertions(+), 263 deletions(-)

-- 
2.56.0

