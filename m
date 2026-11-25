Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602671;
	b=VdRzpwqRsnGgk+Kw2LME4RzF9E9JLo8DGvRoXbn9tJ//ZJh87mLVXQDiX2IXNYy9DWjo
	 BIZEuN86pLpP0bA98/ksQlDnEaxLbZM9BbBZXC3kt9TSPRM2BoKOVzmCiiHLUeeEneuYW
	 bEiFOFFfI/BjtHsMWO4sO0eGg16dkVgienvwEQZ8oaSEcjbxr7yxvCmqUZP8ZntI2IKNm
	 f2ETbGNPIkUo9+9mLd1vNDWlGh9JzqHkKAKEqVuFmsqW01qouUlBW2p8xAAQVZavLAX9R
	 Kp00EUR176AMpP5NaWHVwY/K7orvgtwzEmQz5MS6UZmsJA3O1YIm2rl3BMKsOts/L3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602671;
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
	bh=y42q0T05o7GYn5xPQRlc6rIPfFCzJYoyBIXbi7GGeOw=;
	b=qwQdE/8/wJz7hQAprszXqhXQNhzBVMXx4y17QlbjELD6G2KTX+ONzCdut6rbcrvIs0CH
	 eVeNIkSBBtIYEk9ir1ugY3xcZc3ZeNX6nns3hIZHxVcSBSQjwmsFaEOIZoxB8pZJVPyuR
	 UYi19t+H3Hcc78FvQ0haSMw0TdV2a64+HGk+fHr2/HqJ8g00d1GFmyWAO2mGc19EQ+qip
	 ymDv1yo7G9MS7lq+9gFfXs8IatBh5mGx0UJNA14rUUHOBUYV36vQf8fiVsarKMeOlodzV
	 Z/kv3gyGP97k7gB4gj3Qr2MKbRj5roHT0E/8q3DjTWqodkljTptW2i5VfUkZRQ4WCIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iLDB7XY3;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uUKOgcVr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FC6606A338
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56FC6606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iLDB7XY3;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uUKOgcVr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602679; x=1827138679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ub6CxdYJHU5Jp0b1PII1px8oOYjqYZ6QIvd0s9nk4u8=;
  b=iLDB7XY3RvlMBrsb3BNxHXmN1mJYT1iroODp9s1me3PeIr8dtl0Ocukq
   3dZLqhDYQ6XmhJ1XUyLP3G/ww/qmj13zDNREofjWEmhKU5rphyBTHn9vW
   obvdy6nB0obJ52sOi2LCemhfSST+YQSsI15Q5kcRkrgUc7y7JoVltP9Ot
   0Mw3Z7qb+8KOvnhAFGUy7p4xSGX2LTmCb3t3r1g340Ne5sCUOZYAjxvYw
   6a1VMK50AsW4i7lqQ/uRuvNj1O2dlRwgu3e7CL3tPEppFJDJFKZtRR/lx
   tqAdMdcEZTd9g26GglZJjErZTQIifiCkmTQX8JcDBFgHDG1+wqjopCzCe
   A==;
X-CSE-ConnectionGUID: ngiFy/mgSrOTd+a3L7d8Uw==
X-CSE-MsgGUID: 5uH2NwvbRgGBsN+aR94RhA==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161732729"
Received: from mail-southcentralusazon11011001.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.1])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:31:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CrEXpIng64pyTOg1iNoa4VchVWz5ffraaFZeoOUN9I6B1Aj+8sTRVwQvLTQMKnidXubINJlUgdL/uFEkPJUhXlZqrRjrv9u/GXkduqefWC/kAahjjYB86g0puJwf0xKsCVnAAuKr/bKA9tdkpgznVpUN0pzMOSLNRitaiMCP2lKBF7n6j4wy+xBd0mY/3msufurMfJ/2DUi/TPgXyM+TEzKpNFCTUVRIXVN0JqLAKST159rMDy3Fq7BIezupfBGxndK5WSB/k7FYqE8UBq9iBL8xIpSkoaNaD+AoypJDKMM0N6rKubQgkYTvTT/F+t7FtwoC8G+ILTEACdjr2gaZyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y42q0T05o7GYn5xPQRlc6rIPfFCzJYoyBIXbi7GGeOw=;
 b=PPEu6Sl5OwrIQ4BURsB1Qsb6RXbI+1D7Nv80M9jhiXDQMO56vZZBDC1ZMCnlCUZMtsHnwB0AHxq+YKvENJ8eaSTkr1XD5rB8ToQgi3JqIZ1qbv2/EU1P2iTekdjqKBpKyhi/PAGcBa7O95YojhlfkoQa5dCo0+YUgSFEir8N+/f4IpxWwLbvsm4rDyhhqhbAP3d+aN9logejb0RZ6gZpgGmVA+oeOp3avrMn97gyERw0loKIw6Gwn1CQoti2xSbYV9Ap3Qjf1JYsgjvWUb1eVLW6WkHpsecrXXrGdGSu1pppTZhHiloYfbYAlDkwjKRPYGvPYoSlkSgeulLDK2m2ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y42q0T05o7GYn5xPQRlc6rIPfFCzJYoyBIXbi7GGeOw=;
 b=uUKOgcVr8VECHOWYUxi/TjYSaAwt0VRcCZLjBMG6QxMaq+d/qv4QhJBZO+G5842Q3jp4IXF2A3myLMLKXsP4C3tZNLpFVJW6blG5vykImbgJ5q/M9amM7sEA3ZpQNqTRDrtqzb+X/w6hCCXUc/Q7imrkKmrOE6C1JUMPghihOJI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:31:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:31:09 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 23/27] btrfs: zoned: reuse block groups emptied by reclaim as relocation target
Date: Wed, 25 Nov 2026 11:29:52 +0100
Message-ID: <20261125102956.266389-24-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: c4cf4e98-ad76-404a-8cf5-08df4adf380a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|261022075727099003|10067099003|261021123027099003|56012099006|11063799006|261009223027099003|261026140227099003|5023799004|261102123227099003|261021121427099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	KoUJGUGCX+usBPlSA+/mxofo4elbdnQV8ZF/NCAJPf+P+bC30h/squPJif257xeB6ImMrPVmEJ1m/lEotzM/fFuCbHQ7Zkh+p5r13FxxwdPYVwHQ5Injln3bc71dheKyKdC05CXmcfeBi1w6o8eIOrIkyHbtM/dsMZjZLVthb/QOnrik+qa5/vyvUbK2i3OEHQlOpE1ayASlFWCfU8dmafV7RZaqEqvQKw08YbK5qErYZwWxyQN47Tx9p5CCn9wQhWMci5I4OXZUmCMcS5kGijmxL/R9rbvhrdeEeifRFa6a4RDHNn8zHPeWrbmuJDFJPk8oPoF0sYdEA/+ye5hg9Gty3aydqf4zjt16ej6Ljw1UsrxpTat4Jg/TfYxep45ql2TNocJcMhQ9honaL0R3lZ+z/95qS3pDMSP7LcYG8l9Sli3bIEgAXgzUd9Y+TChJ178pEL9srMOzFv60yb4k7hjXSumbX7m8RvI9GfJmYApLTby8mn+uK/SImLnfcTLywtma9slSIKjc+Nl+zXRo7hjd9wsazCDNIy5xdvBeqwhcmTm8Y0J8ANRYhPeiBt6zIsR7AjPBAcqIpzRPEh1ao5CWZWra02p6OdaNaUjY9o/BrJvmCHQRgzuqTgvrcOKSYgEb61ZQmbZ65u87wyhVQX5u5yFivdhi39aEmIEco+Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(261022075727099003)(10067099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(5023799004)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4sImm+4eD/BjuucL+PcXpnrYv6UvNaKvqmChqeYPbck11x1KBsP9Fd/TbinM?=
 =?us-ascii?Q?s/8CB+Rn430hgk5rhvlnpQvja3TaDSe+t5KIA57ZRA51ItBBbHkn0PbeRO6J?=
 =?us-ascii?Q?spBOf3OV7V8znCqzvqxoDGhAaGKYjSkv93QrVStbwiNlRHb2BXCmrlibUICx?=
 =?us-ascii?Q?9/JrYZmkg0ALN5slR3vGLBk+3JH2OtgrDEI5c27gjzsxaGVkBZB/hRtfem//?=
 =?us-ascii?Q?zSPCYiYL7yao3iKDixN2z3r0hsTsAqRH6ANXYs0hy7u2l2ig9A0iRLpWkwrb?=
 =?us-ascii?Q?TIuo3VS4qzGThKNASJkW4tu+Ji3XvELxt9yhyMopWPVx/oCC1sUvLJUoDqat?=
 =?us-ascii?Q?blGyR1H3qrQCED/XjSGFyOpbz5igfeahJ6QNXonBu+E+iHMPSnsPxeLfXach?=
 =?us-ascii?Q?io/ShCzptj/Y++rRB1oW7UkXCmkw9ucrHpXZVr8AXIrzvF3OfEvHFZmfrm2T?=
 =?us-ascii?Q?tTen6oy47lMcedh5zahCDW4EZ6AMVSmk2cIlYOtQDOTf9E0ZBxZAY85sg/KY?=
 =?us-ascii?Q?Smh/mfNRYc0APMcfCuO2kSmfzvrEq+FLXcW/ykk/L4E0ZakY1nra6At/AQ2H?=
 =?us-ascii?Q?j/ITx7tATrOgl/hFyytP2nKZJAEHuW/Y/B4Uo69RpZ69d6zvPMTj728Mb3OO?=
 =?us-ascii?Q?+3IUIBWCOwIbmjrDTlfO9UMU8V8K3r06Dv3TBSJ7Ko9YNK37Joy/f0SVvTuj?=
 =?us-ascii?Q?kPEwNz5ORBOzNKnjMtLdssCNgS8bf21KsuS0qitFNYElo6/oY5C6ppsUYqX4?=
 =?us-ascii?Q?dElu9Mu+zMOk007sU1vcjKjnL+5Ev/CVdzfhFkzlDOeLPd+aer09jqtIJe0e?=
 =?us-ascii?Q?7hbNGZ22pyigehPziAJJUE0jrLOBDI4pVXlcUgOBfLOcVUWO7ASkPv/x+iY9?=
 =?us-ascii?Q?KtM/3g6AKl2JlRTxc3IjwfWrqXCa5DRNTP+CbRy2e0KbwDNMKIfenc8UTFIJ?=
 =?us-ascii?Q?OBbbHWe13iho/0PUl7z3eXfjfBG0J4GSVNpQ/QoxucK3yI0rSkhSVD3Xg4ck?=
 =?us-ascii?Q?WUAKJUgXOZFZ80NPUeIVR0FnAuZTZwJNkyEmhhP2ctoEhCxUekHtxIHsU+WR?=
 =?us-ascii?Q?ybG67TjUsZOI4T28REQOYXQGLYWuPFDsKMY3mScxxUhOgUex25hvJnQ0SKwq?=
 =?us-ascii?Q?GZLTnK+wV8UrnQ+qgMOVmAqwCzcN1dU2y3sOKStVUyUEvkDvJ5hv8nwxOxTX?=
 =?us-ascii?Q?cwJfve9toUQnQKVOQqs6OkDml2IC1uOTvRYW7vQbfiFdNpGQcg92FHMh7B3V?=
 =?us-ascii?Q?vFzw8zn/ny6CgOIiWMqiS8HAuq/2cmAF/RAUEyU9k1ISCm1iKksflmSbMO0t?=
 =?us-ascii?Q?xAQVSlyIxJqMHEoCDWKPYe24CRJcML1ODZBm+2Jq6C+IOzfpwq7PLCLU1IH+?=
 =?us-ascii?Q?FNye5x7JC+1wkCZFbW1OGLDtdsaoRQ4maV6/cXb8eYkfsEIrGsqziEePv2fm?=
 =?us-ascii?Q?Gy0/HHPqBBWX3w4zZhS/aTrlJUrI6Zi75iWdVtZbRPJtgFmVS1Lzj/F+DCi5?=
 =?us-ascii?Q?HLrZCHNA99xvjEpr8fikTwgplHExURmmLHljQY42ZpUuA8/Kz+7rUaEp8agK?=
 =?us-ascii?Q?w5z5iDa3i2APejy/sUx1zACpaGjH44847eMUeuJmT9UiN/Tqie6jcpm006po?=
 =?us-ascii?Q?e97WLjGxL7Hb3yM9N7dOm1Tn88mGRzRNiK4ZOjgcOVvkCU+zAvoeA/Poi2sw?=
 =?us-ascii?Q?xftazQnuCZ6MRLs1pbGV2gB+HI+8J8jfxYSZqkjrUZGBUbGODBuvKKP1HvY+?=
 =?us-ascii?Q?6y1YGEhBubGBCEDv64qebX94aOQks99lx8cO8aj0X/gQ0WsAOoQ4pwa/FYXt?=
X-MS-Exchange-AntiSpam-MessageData-1: YHGwAPmSBffIbpTjwWe+Sm+G75d0AQvyLVo=
X-Exchange-RoutingPolicyChecked:
	X+OWV3GDjh1tCCbDhLMp3ADNgH0DUFAo3HNLAdDi7zfqyQjXFTSbe6Ul/6wCp6nlAFJZwlR0iR+AFmXOBeY0IUlSQJoNisYZfjzMqEgKCugzl/i28vKlNRVwnJD+DD+CO9tlcFh5Cix8XEU3JG7OxKGclicXJzRI5QqNtutKgNPzE9y+I6A3yWnVjL3jeca7g3+SZUfPOADHV7iEU8HU/VhJX/Sqik/y4TeHWNfliuY5wy2kSscJWIMSvyDzWIahz8zRjooXgitKGsctpTcPTQPhylbpJ6Uzx7eKHO8/pz76ErpvRAdCX+lrF2FzadroyOQXpVqk3gDah3a78yNPiQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m3HNN6Bv6KWDuyJFCnoHNWLGw6uIBsWNdtFt2cdRe2Ea5Eb395bb9QnPhfiwIE6MFDe+oxw4nlsrTBmNuf+Toq+wH/m7HdgrK7OXl1sbMSgOPNg72iq83127B2I3geBoB0xTAzne6cZEDDTAukMpYcM0VBsgN1JthVruguhLM1cXlwW/p+ubUtstSygLxzQDU+RiaodkMeA8KD3etAHu5m+FU2mHvdAqugl8lxRRyTAwLeLAqgoqsHuHHlZuue9kNrweeSHEX8mKonpNi4uvzpWwzKBC66rywoomO1uBrU/+WSQQ+DU3wmpch42bWyF3gqFkv81y2SXArv/brdJcYA4LN1ILvfN/u+az/h0PV9Bzklafx4Mth63GS6SXNCmk2Yh+64MWMd94awwtNxQXnWpo1MuWzp3dlmshXcc8dDoQkbL95AjoXp0qCxqNjmuDbpMkLyU8avIKZdnbL6sAmlw9snUMiSi16FPgSjsmcvSv52xxVAsQOS+ILN2jlus99MzY8Awp9sTxoBeiy12aT8csKWRD7ayscyZFForrQ25ZaoBhJct/weDnB4GKNNRPzYnfkzEyyBbTCLP0v21o4EAwwn/V6VIrg4ZVBMhFveaZJqtnFY2wcEe1S9BB4LKk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4cf4e98-ad76-404a-8cf5-08df4adf380a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:31:09.0678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQpA2ZIdPjC3XA1GfvuEZsOfZ6pXiEz6rT2BJt2VpjR0B5LBzV1PyI7HS3NIv39tcZD4ilMrNC89j/l/U/VTpySU1G4m+hfMYn9r6ADzwpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

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
 fs/btrfs/volumes.c     | 22 ++++++++----
 fs/btrfs/zoned.c       | 79 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  6 ++++
 5 files changed, 105 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index dfe3b61e458f..73186c555dd8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2068,7 +2068,11 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
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
index b9b5f32c4362..18cbadb01b4c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3734,28 +3734,36 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
-	u64 length;
+	const u64 start = bg->start;
+	const u64 length = bg->length;
 	int ret;
 
 	btrfs_discard_cancel_work(&fs_info->discard_ctl, bg);
-	length = bg->length;
 	btrfs_zone_finish_relocated(bg);
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
@@ -3763,7 +3771,7 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Step two, delete the device extents and the chunk tree entries. */
-	ret = btrfs_remove_chunk(trans, bg->start);
+	ret = btrfs_remove_chunk(trans, start);
 	btrfs_end_transaction(trans);
 
 	return ret;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 7111b55d4aba..a8da6f6592f6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3145,6 +3145,12 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
 		unsigned int nofs_flags;
 		int ret;
 
+		if (!stripe->dev->bdev)
+			continue;
+
+		if (!btrfs_dev_is_sequential(stripe->dev, stripe->physical))
+			continue;
+
 		nofs_flags = memalloc_nofs_save();
 		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
 				       stripe->physical >> SECTOR_SHIFT,
@@ -3229,6 +3235,79 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
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
+	if (READ_ONCE(fs_info->data_reloc_bg))
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
index 1f5f62f7590b..d2011f764f87 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -111,6 +111,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -301,6 +302,11 @@ static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_in
 
 static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
 
+static inline bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	return false;
+}
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.1

