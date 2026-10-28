Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211718;
	b=ZTXtnCMHpeddgZy7FrDF2iUDE3V8dtXxtqN88y81KRmR4A5QqxUZDh5+UjV3hD+XH6B9
	 5uMqjb37ln7++LVgH3uKvCsFJGlJymNHf3INNi8eqWFB8DMx5RGW32NFhhImvsrAonRph
	 aJqMgF2q28XJK3mcW/MmXfMFWqh/G0zLhUGSEn8fIsZjk9iJgajtFALXN1JHXbK2XPpF8
	 UxD/N1BW1cb3e+n6qAWyNTurX8fV/IHpZBpLUWHF7kTSVu2mnhGDDO7jGgUOdYxxwNIbO
	 SRwx9qtrJp62nX5D0yxms+HjQR6ZpmLOocPEye0te165/RSXEsWkC8IHX23yf2WefUw==
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
	bh=yc+FeqL2X9EQAjlEKumP7NE1T6vD3p2cwv/WBUOmzHk=;
	b=LcdNq4rKScaGbKnHyoFAlpxp9Bb3QBOZGb6taK3vSynryLIPGQSByaJkyWJIYXjOl6KK
	 DpKDzCvlX48R7H+CWNqF+dUpKEmcUzI7+mqZRZ7QvCToKVrnJ8FOFPegsyhnaE5UUHiO5
	 KZFlkvOsThWW71SF1h1kuy6jZI9aK6wD5/QuICcHswsboUOe+/Vb1ObTX5/CtfyDcNhLM
	 xNUl3LoDu9/pIchrQncHX/LeGwuNkKVTZhcZURoeArXImUloW1vaeDpSJp4GrwVBkr1lN
	 krEPeLKG+LxfV8t6Tm0DZ0gV8bLZSqRbepPyJtmnxlrLXRUTHax5jSVvslTBeUnJ0kQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pEiE9JNh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=qk4xMrOv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CBA60A260D
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45CBA60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pEiE9JNh;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=qk4xMrOv
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211716; x=1824747716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=XstrtJUa3v6vDApBuoyyMXOs/x6tAOO/XhyE6k5caAM=;
  b=pEiE9JNhzfzXAkKt5nVYpzFvOo2zeBcPqJ4feQbEVAik4JV+PegucsZB
   iTZLBkMrT7TpaMo5u/KVu0s0Ju/XY9wU5PpDQmNEdnvudrQltNTI0bsj8
   29bYF3GLuD9XubNqRyn7w93/dyrENlzwOiXCVJNavIolzvAzKDnRzWMlb
   PtdrlssWf+HSQMjgqPNknk6v3F8kSSMw6v4p0IUkYnEaoQG+sr/DxsQBe
   qLB8KZ8fZdXKSaHt312PRvVcrqCfEu3iVmX21fcycndFJyqiATKaImEXa
   9ubGvTsWrAxjs6Liajcs2CyxlBhxwaascT9NUPiugzUB87Q6jEfIIHigN
   w==;
X-CSE-ConnectionGUID: YUJrpFMwSMiR1vp2D0e/+w==
X-CSE-MsgGUID: nPIFO6YUQGmCk+uLJTxK+A==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159135292"
Received: from mail-eastus2azon11010001.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.1])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J7sDAW3JrX85KZxHoncxm/HKK6orI+Gec0g9qXy8IyFnK6usYUqB9rMusd3GSeWUPqycXfNfjkXW4sIxATlXKYQQcXt+n6Ds1/1hKciF6y6smzrl+sobk32g/3MK+3U7OoeL4Itj0pOOPxk0ZzKZg/WNGQ4arkeFJqxqMyQnILtPBVMNSaNe5oNCV9FRaxhQTIyMHZsB2ATFq480zRyq0jbAKgXkzzyAHC105lvM4z/lM4ZeAAno7MA23YjtImatWFM8JPn0m2Aju5uzoUox4DFASgGB2/eG1zK0YGPNS7+Ga+3KzRQPTAWd2U+kyuPOTdUchpHrQXH9Ch15aAobtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yc+FeqL2X9EQAjlEKumP7NE1T6vD3p2cwv/WBUOmzHk=;
 b=iNRYyAr9H+NuvOWjNX0cTS2UGoxDLwY8qeCUKTenpoYl0eOu4JzLHyFT58VSuHARG0aKag1Gh5I8tCVX37cl/eQynukyukz9SNO+Qup6wj+2eat4lJ+SYwNm7GB9Xkb3mFwtOjaiuWMp2b5GK5TNxss+lm22iL+rON9Il2Rpbe791cQD8BEQGgA7tNbmTWe2sB4z4RiV8CWTIlu6wy8cpHAB2uuAq1GelJ+UJrvViHHMrtV4Rg2XsRNIfnAZ/b4krsQM44U2wZf9g7oflopiztDX9WnIfqV0io5zhOI8XN/ZEYDz43J8nr3XguLEhea8VOGJOqo/wVIzI7Mh4Krbjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yc+FeqL2X9EQAjlEKumP7NE1T6vD3p2cwv/WBUOmzHk=;
 b=qk4xMrOvY56yfPRLZPNeJ5pAmH1NbD7t67qU2KfBrlyrPAd+y/kipja01JM8Hr3CJT3fq0N2WzCgnCQaZ32fBxrK1xJPXH4vwl9JUyFa12BHK2NLEjyJxKfftNpCohGDi7JhBctkD4Al8iZnzCi4Is5RTSX0u+MQDyNTEjTuYys=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:53 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 21/25] btrfs: zoned: reuse block groups emptied by reclaim as relocation target
Date: Wed, 28 Oct 2026 19:21:07 +0100
Message-ID: <20261028182111.160492-22-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: ac226ac7-fca8-4df7-448e-08df35205737
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|5023799004|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|261022075727099003|10067099003|261021123027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+v1T88n2CXNiCjIoUSIFGfTFyk51MLdB5TQF4oBXxNoPlCWT0ZFQ1EwXgkZshXZvOdZ7P+3p+FpKYXpx5l//m9PByFc/fS+CH2Fch3UZctPRjjhlh4XTe4ku9us+DSwVhXOgpNOXLjhuTWO+umHNxgP480Z4mgNtqk4ClMoRalvX4gniZpBhXTO3uphwzi3MzKdUS6TqtSNEOohHngQYtvt5UJN3XjeaPPTf1dCdeJrxsRx3AJT2k+VUwwzMjbpJFaKcpFEUp2dxHBI7wlsajKkeHtcxnmi7dDlSqfQJNBP74ln9JpIk0KGpzGDpySt5gdx8y7aLim5tmtW0lSBz7Yf3ZNHLDzpjwP9BX7B1cqbu5uTeMDg4j3LF5LEPmbOVj9mVU+kJUV8jNze2IYh3xkH9x28DsxmuBFZ26e2rti+A7XsOkficRV1yJyJ1mpLTEcJc3TRdpQQmq+W1G9CznVK3pxdLo+AcItpILXVZJd5TMUfXOr0i5BiwVbJAYOFtAQPAn8Xesy9sf5TxZ0q7Yjni/gn7Fru/JiY9/zRd2sSVJA6e0DOb4EaIG2g3CqL4V8v2I2kxQ5nRiLyYjU9JTjMpm+Bo2nQhRWJ/zKtmulYQyl9hHeHqwNsw6YWAM6uT/Q6eNzNZfo7caDM8GDWMHQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(5023799004)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(261022075727099003)(10067099003)(261021123027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UAP1A8eqX9D3m+4a93WbSINiNyxp81bLM/e+VC8YEJOLVGuI97o7jmhzGKGf?=
 =?us-ascii?Q?PZco8jy194Rtelomop3D41lmfA+hpMG8Rf2aH0q5nV8gvvz/uHwOo2u1iXJc?=
 =?us-ascii?Q?zQeeJX7wFQBmiM+UPHZjAqdKvc3q1IPi8Q5MkzHdYuYeTzXiN6n8rCA+JEWT?=
 =?us-ascii?Q?9C/wwcfBWVow7S2ygNepV8mJjyiXZxPfSUtyzsDY4o6rHf33ma9WTwkMbhni?=
 =?us-ascii?Q?zvttwvxds6eOqh1XNJITrdtzsrG2eaiN2ANt748RsxFRWuKOlf2DTDYlFTsV?=
 =?us-ascii?Q?XN5dc718nyTOn+OHQLhjtbd6CuRr/rqKlQQLq7EaVgNqjHQgNviKlnSYUPAY?=
 =?us-ascii?Q?4ADCau7guZoXMgnYr6vAQS+N29H8R1I8j+5iOMzuL53qWyIuFb+H9JSoQ64T?=
 =?us-ascii?Q?csPr0P8QuFVGzVOZbMKFhgmN7/0jWhJ32AyWOLHxQ6B16GxJFC1oXeOGLqIF?=
 =?us-ascii?Q?zv50++d+q4uosCHRKrGziCPawFTpMDghZLZlxo3khEIR777xKekCaoTVCrxz?=
 =?us-ascii?Q?4Xe19B83lQBUN05HIYTwRtgWXFTsvZnVg7s+1ysRVXDnIwpPdUhY1XkOl8XF?=
 =?us-ascii?Q?XtbCP7756BgMJF69XNhsTgK7GXO8XPeOXU4I/jFX4Ef9aqQWAnTStEs1vLMo?=
 =?us-ascii?Q?RP1jARAwOdCxXAtMAkjQ5XLyL5KzzAQCLw07c60SBhtQzkfEsKly9Ln2zwQ8?=
 =?us-ascii?Q?Ec0aX6dQwadvk0IKGOnP4O8XjhFAAcT2h8q6y0XgAYWzeBHy9Qv0HPgmGWIN?=
 =?us-ascii?Q?h/6ZFzt0soFypA4J5ienId2LW1uROHHD+gdJ1QxUjd0oqXwfHvp24BOzUJLV?=
 =?us-ascii?Q?pXVE96JPzeBt1cNr1EOxnPmHVqxFbOLdmd6oRqhyJf/6F0KWHe/kAmnHw/vj?=
 =?us-ascii?Q?pVqjsxo6VvO36+RYE0XKz5+7Mm9aIjornTblpcv9vLj+yXFzlclD092+LBji?=
 =?us-ascii?Q?OCTLYkSK5gh4sOvmji+lmBVeXvNQRBiBu73BU7cPNDBA8G16OwSBZ3DcOQlp?=
 =?us-ascii?Q?7y/Ew3GVt3rPMhZu68d6+E25Y8yJ5dGZREw+3RP0Bu9Br9692Hiqv+p6dINL?=
 =?us-ascii?Q?Nuq0NC47L9nTG+eVI+GVb2ykr2xFiJcoxdwm2DMuoE93aGllNfII/bxNKipj?=
 =?us-ascii?Q?8YBZhq9tfM3wyIZ69uqOLpI6hW3OPmID/c5luPrSvx1n7O7FyH7PD6mQzRw3?=
 =?us-ascii?Q?SND9bqWoEG4QBaVx2RqDNKZWg/tNnGtR52r6FkV9irgitDyradNDAyfoeeNs?=
 =?us-ascii?Q?K0ROwEHrcwteAxo8W4OY9LACoWr23UeYMU2cJqK2SMhMz4tnvIF44oEhDfxI?=
 =?us-ascii?Q?yVrK1i8OuLpjkl25kWOxFt5w4B8an8t1l+N5wCvtV51+mKt1JCul5ijhRq+q?=
 =?us-ascii?Q?ldB66w5LEka6qbMghZTdIlelVY8Z61/UiIfOYxcm6QtP/vL3ZWwkm20AQcV6?=
 =?us-ascii?Q?c7+ohZ9futKEvekZbzDLKqMJbaA5cE3Jnd3GeTUpb9AZzkdsxGXi1Uh0BtqI?=
 =?us-ascii?Q?GJlUrtDY+YYDfo+AMoYZ8yXaIwvE55U6JuFiOAdUVE/s9P1kdTtADKyik4lR?=
 =?us-ascii?Q?QmrJu6fGI/ZeNKnlgRKyDplc7tlWVIuKufoCDXAJWCmG9gXkDL9eLFJy04VM?=
 =?us-ascii?Q?6aRmaCPZzLnPfIh3/avOHF6ZJfrXe1GzSuJN04Kj4peVRUNM/L5KbWhiXMjv?=
 =?us-ascii?Q?ERAcoc9YZF1Hh89q0RxctgtQdSmR9k5Il+KnXNfPwO2sSCA2Ea/pD7azaBnF?=
 =?us-ascii?Q?UutprlfTY6k5GxcDuzFTkhZ/oDdcwQ/y6Qc2ngXbIBRbEZKRLqit0FSiWIJT?=
X-MS-Exchange-AntiSpam-MessageData-1: RWBRF17Shp3MfVzXKDn8ZEs7gRQ6bpX6ovw=
X-Exchange-RoutingPolicyChecked:
	hZJXMtJXETP+kJqiqDNxKtioyLmO4S6e1E/BXBIIv9Uj7RZwGuV0sq3z/5sLRbcurKjhZLtcf/4EKk0CClqHbBflaPG1wyb4c9pAHrtzIr7+9emu6ytVidY2OKuBJhgvI/6NXBcPm0comleVPeRb5Jg9fKrm28g90d9srVv+W8zgFLtgjzHqz9Vz5Q4ZLStdtRgMGxd45xX52pbFonnpss2GPhm+mWZ1RJ+T+Qe/7mBRTmOoRuWsSnhWIlMbja2e02esZSSLjsxhlOMT66wjkRhv98iyNq8fOUp1vrbrxO2b3cKnEvkNRvfHldBNYIwkC8iRJDSmu6wiaivlHFMtXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XbYyAHmYQO7g67K+edxKcLczMbqNDMwS5jHUop3tJixFKfCCKI0o3ypXm2VKySa84G4DOsUThtxWE6gjExzarhfUCz/YxqGeNwkqB3JSA/swlcQ+I5OpzWoUareHMo0MN7m+M9yervDmT7jrex++B3UkCd8hk4a7BPcm8uFu6kCtyPkwPTThl1mi+xVjRFlF/NcR6zwZNKNttyBn3GEvH++2cE9XWPNnRsrAds9RwylBqF/XR5ujwk/rtc56/6st38ajzrftA6B5mx4cCrgtJWuCjv4aFTsm+xIaIIRPJyedgHeC8st78u4T5XmWPE2cVsITFRLPwIx4DI4eNyVpnLk71Be2wvzK0n9vgH5go7BZoQYjNRvyUFqKZPXrkoQlFdRnwogCAoY+ipUrhHss6GXoQhRHwaj63yfxYmXeitOtDPVafOicFsqKHGX2wZ1Usy5ahA2MsB2YhVaP2qr8F+irbCPGYQKsWRoUdOoqp3pMMp0cVZCoXLwuINaaxHLh1PQ7O4whkNjR0HX2lZEPSGmLbBvKuFPq4kUTtic3/zgfR3NcfQjZpJrAzV/WDbR0dQRbIAT0La68I4vm/xSKjaI287T0Q6OEGOE0pa6jw6yPoyNyzpWYT5bL3GCxcNfQ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac226ac7-fca8-4df7-448e-08df35205737
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:53.0335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0h6lT8GpuDe07uRNFaw5J00BFxmx2FR//XS678dypqd/fDkhizyFdSGfhXf4vhmJaOqzlMZ+yYcrMhDodnv1UH8ZlsEePkkFkYLZobKNes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

When the block group reclaim relocates a data block group, the emptied
block group is removed and its zones are reset. The next relocation then
needs a new data relocation block group, and if none can be allocated the
relocation run has to be aborted.

After a successful relocation there is a free data block group anyway.
Instead of removing it, reset its zones in place and use it as the new
data relocation block group, so the reclaim always has a zone to relocate
into.

Mark block groups that are relocated by the reclaim with
BLOCK_GROUP_FLAG_ZONED_RECLAIM, so only those are reused.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 +++
 fs/btrfs/block-group.h |  1 +
 fs/btrfs/volumes.c     | 22 ++++++++-----
 fs/btrfs/zoned.c       | 70 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  6 ++++
 5 files changed, 96 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a7e3fa71e426..435af7abb340 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2062,7 +2062,11 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	spin_unlock(&bg->lock);
 
 	trace_btrfs_reclaim_block_group(bg);
+	if (btrfs_is_zoned(fs_info))
+		set_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
+	if (btrfs_is_zoned(fs_info))
+		clear_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
 		btrfs_dec_block_group_ro(bg);
 		btrfs_debug(fs_info, "deferring reclaim of chunk %llu", bg->start);
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index baf8e41ce8d3..9c385c02c1f5 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -88,6 +88,7 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_NEW,
 	BLOCK_GROUP_FLAG_FULLY_REMAPPED,
 	BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
+	BLOCK_GROUP_FLAG_ZONED_RECLAIM,
 };
 
 enum btrfs_caching_type {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 09449381fe2e..9721efec4e45 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3711,27 +3711,35 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
-	u64 length;
+	const u64 start = bg->start;
+	const u64 length = bg->length;
 	int ret;
 
 	btrfs_discard_cancel_work(&fs_info->discard_ctl, bg);
-	length = bg->length;
-	btrfs_put_block_group(bg);
 
 	/*
 	 * On a zoned file system, discard the whole block group, this will
 	 * trigger a REQ_OP_ZONE_RESET operation on the device zone. If
 	 * resetting the zone fails, don't treat it as a fatal problem from the
 	 * filesystem's point of view.
+	 *
+	 * A block group emptied by GC is reset in place and becomes the next
+	 * data relocation target instead of being removed, so GC always has a
+	 * zone to relocate into.
 	 */
 	if (btrfs_is_zoned(fs_info)) {
-		ret = btrfs_discard_extent(fs_info, bg->start, length, NULL, true);
+		if (btrfs_zoned_reuse_reclaimed_bg(bg)) {
+			btrfs_put_block_group(bg);
+			return 0;
+		}
+		ret = btrfs_discard_extent(fs_info, start, length, NULL, true);
 		if (ret)
 			btrfs_info(fs_info, "failed to reset zone %llu after relocation",
-				   bg->start);
+				   start);
 	}
+	btrfs_put_block_group(bg);
 
-	trans = btrfs_start_trans_remove_block_group(root->fs_info, bg->start);
+	trans = btrfs_start_trans_remove_block_group(root->fs_info, start);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		btrfs_handle_fs_error(root->fs_info, ret, NULL);
@@ -3739,7 +3747,7 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Step two, delete the device extents and the chunk tree entries. */
-	ret = btrfs_remove_chunk(trans, bg->start);
+	ret = btrfs_remove_chunk(trans, start);
 	btrfs_end_transaction(trans);
 
 	return ret;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 00b220e30569..a495ef1178d5 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3131,6 +3131,76 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
 	return 0;
 }
 
+static bool btrfs_zoned_can_reuse_bg(struct btrfs_block_group *bg)
+{
+	if (!btrfs_zoned_bg_is_append_only(bg))
+		return false;
+	/*
+	 * Only the read-only references taken by btrfs_reclaim_block_group()
+	 * and btrfs_relocate_block_group(), nobody else (scrub, balance).
+	 */
+	if (bg->ro != 2)
+		return false;
+	if (btrfs_is_block_group_used(bg))
+		return false;
+	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags))
+		return false;
+	/* Once read-write again, nothing must be allocatable before the reset. */
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+	return true;
+}
+
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	u64 reclaimed;
+	bool reuse;
+	int ret;
+
+	if (!test_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags))
+		return false;
+
+	if (space_info != fs_info->data_sinfo)
+		return false;
+
+	if ((bg->flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) !=
+		(btrfs_data_alloc_profile(fs_info) & BTRFS_BLOCK_GROUP_PROFILE_MASK))
+		return false;
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	reuse = btrfs_zoned_can_reuse_bg(bg);
+	spin_unlock(&bg->lock);
+	spin_unlock(&space_info->lock);
+	if (!reuse)
+		return false;
+
+	spin_lock(&fs_info->unused_bgs_lock);
+	if (!list_empty(&bg->bg_list)) {
+		list_del_init(&bg->bg_list);
+		btrfs_put_block_group(bg);
+	}
+	spin_unlock(&fs_info->unused_bgs_lock);
+
+	/*
+	 * Drop the read-only references taken by reclaim and relocation. The
+	 * block-group is full and empty, so this leaves it entirely
+	 * zone_unusable, just like the block groups that
+	 * btrfs_reset_unused_block_groups() resets in place.
+	 */
+	btrfs_dec_block_group_ro(bg);
+	btrfs_dec_block_group_ro(bg);
+
+	ret = zoned_reset_bg_in_place(bg, data_race(!fs_info->data_reloc_bg),
+			&reclaimed);
+	if (ret || !reclaimed)
+		btrfs_mark_bg_unused(bg);
+
+	return true;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 31d1fcb6303d..74c9a4c70d26 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -106,6 +106,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -294,6 +295,11 @@ static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_in
 
 static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
 
+static inline bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	return false;
+}
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.0

