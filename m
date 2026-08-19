Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407DA36921B;
	Wed, 19 Aug 2026 13:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145444; cv=fail; b=dCoB6ZUkBIpWHgn2cg8EudHsBXGDp8twUEJyWlI+twUfMQuVVHcsYwODNoEnNBQHKT+yj4+BVex5ZIJZvQ2S5n2eu1AmoE2AYz0T+USQHOz+H4KbUNYllDc/WEUqmh6tu66W00ei/FuWjp83KncVbK5wcu5BHJHMIWLGFn8hisQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145444; c=relaxed/simple;
	bh=broGoVfWqiWh7sEGeeEXwksOOjn+eJk0lfeIFTnERs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fgJJLg5fgmG18crX/ZgGzCKZTM/EmY523ZjdPDSNZf9vPIu4DtfoE2f+wbhlOxaS5oYIRigdCqNLWTLWFs64BmzPG194klNIUl+A+Y63xfGcED65KYkH++sqprgOz8PjwM/LPgfjHtcTEkD7TeWg1lwaRaZfV86To5AuaRVs+Kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=axHfXd2g; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LzuscdkA; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="axHfXd2g";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LzuscdkA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787145442; x=1818681442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=broGoVfWqiWh7sEGeeEXwksOOjn+eJk0lfeIFTnERs4=;
  b=axHfXd2gWaN2ZgiZXSel81xcS5PkqwbvNEkOaz8/YNF2ZQoCSGdrsE2z
   dUJNVYsap8SG7AuM9K7rXzGhDy5UxRrw2jWziroZsSdX/U7zDEKcMXQ7H
   ia1uTTq33Xow/a2BTkjH/0trV7FEvT5TpupO0p9eWRRQPOL4PzQ/TRl8M
   dy0xl62AIJJkNDiWEUw1gOQfjSyLSZITjUXk3Ul4Mhlrty9gh7UKP0gIF
   sBJodPOoxoLuVUv1a9HxLBOzOd3vHjeC4xdx8J3qnGprq1goWeJTiDaYm
   8tieBep6WB1C7By09T2EXanLftWij6VI9F7hQGZaFXVhlJBTRJvFLbxj1
   A==;
X-CSE-ConnectionGUID: rFWuNbL4ShuVLIAMRYkG9Q==
X-CSE-MsgGUID: lxhCC9sYShuZH1M2PzleeQ==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="152276631"
Received: from mail-westcentralusazon11013029.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 21:17:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w0Cd1Dt9gj+8rDh+QY6wBln18M/aCXv5iBhGeCCjikS0B74tT3DzF/llnt7WwzE57U+70BpbrQcj4m1whUV/QDN0+BPj8s7kkhAlhuLGi7qd/kCbQWQn4LXjB4rBs75lv5y5tnVnpOGFLlkeY31ZkkbJMe+YpUs+wpFWuEdIHdf5/pX+LTn0a8hrwAnf+ghswtcyorE77Mk8emQ82g4q1rHZ5SAzjYjfHZ0p10R5vFOcOGXXIQd6PEIEi5QLpSQYvwrP0EjHxBDiT0RV3VRhalSczs8RfTWnpvSoXLIRowYV5JGDR9gQYoiXk4ymd5JRtmYsqEqVldr1mJ3KN5zEDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EN8VFsjt7BX40TDIAvRP9AIUVD1YEwAPpmnXDXoZ04=;
 b=t4rd3GkHUG8/C0qwZpvySDhR3fB8X084ljGsgL3H/jbLGL7g5X3l83xwaa5AvowOS5w+gooJRpVTbIlJ9sBShv4Yd7C4r8fykj9U7FeZnoRarhyLuhqhOTYesOqLQiLhv/rHrtBEit+ompb1sFfzNPtkdyaQy9D5ZtJpxI+PT+8lXR0nu6dcypKiIo1X8cayM4JFqCU63/74vQLaRlfj2gSkkXL9GBQ21NzXl9RWDrQg3bVQyasa8rzHmQsrTwJVle8BOzCgH4vjO6OFE7ymGt8jM+0FLjdXkgPnYqZjSvwqig08Vm6jSs3iscCvI8IV0N9gqfd05OcsofpUZ9gBkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EN8VFsjt7BX40TDIAvRP9AIUVD1YEwAPpmnXDXoZ04=;
 b=LzuscdkAfJAI1D40EozZbCb3v2y700aMduAE1uxgtQOF5P1cxICxq1WOcix/e9UXAtm2pnTdE49Saw0Kn9ftMKz99HAFYLBk1iIoT8p5hxt/Ep+B7ip/QJ+l30AmxlcazHAuYwNDPvpWM1Aj/G1PRu7lsr3gdGYlvF5U/I8vHj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7385.namprd04.prod.outlook.com (2603:10b6:806:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 13:17:14 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 13:17:14 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 5/5] generic/781: fix copyright
Date: Wed, 19 Aug 2026 15:16:05 +0200
Message-ID: <20260819131606.1478488-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0396.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA0PR04MB7385:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ff01e3e-a9ac-4b00-20cb-08defdf42f28
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|23010399003|19092799006|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	95ApFpK7gh7BiXmoiunARd5ceNK2CCThu9hFDHK7KUj10i5Fzesm1RlkucHFOx9L+sCKesmiKjgMxDMYkJ3uZ1Wub4FayH35CS5Lc4TD7Ld3xMlBPGCY9mtwaYYjBeeIHj98fh0+waW6gC6i415Z55zHfrmImw+SbLHCpEDwwfAnCmgYibFkeV/Mzo3i1XYZh+CSpelAOZCdR/VajHyVG56lZYe8x/sA/SjqkoKthZgeVikfOOnN4GUdQnOB+EDJUd08L//FPgJUEi3GKP5odg3BOw7OR6EmdYhKsMl8RJR08ZRrMZlDyayn73eG6+iCm3MQH7QrczMTy1dX0RyZ77n5Klz3N2wez3uBwjK3TvsFqIEAw+QAwYoiIfZxAeliFipspDDOrjN2PqwhKIt9dFRnoju5l8KRXSFDZLsHs1apEgM8spGJTzg6+NuWujd12aCVC2NZE8/7rEBdEak9Osb/qkkL7PTfUrp+LQsTn0iVyimXM5OnNOMOfR5aMzSEYI/mKWz+5arLEr5hQeA2L7GY80yoScLMPOikKZa/yjc5Pj5PygenFCPxocRi5/4Dip7NLPX0hnCJaT3Ex+nj4bDSybLsevoqPSN5CCgcfarxe3320KgP+UfLcVvw/b0jxPD5Xp2kRtAWyppGHTcb8k0p5upkaR7611+rmERHbO0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(23010399003)(19092799006)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ft5aivItL+gUoA/VFSIS2qafGBLnlAjEcrAq32sXB7aIqdQ+Z4fPMVFFDuT9?=
 =?us-ascii?Q?a41v+URKdzQll3/Xf3hxUVYgdZaIGUVRILBKhVZapfnM08IaJQ5FxWvgbasz?=
 =?us-ascii?Q?R7oIrUGAHogfVbmEFqDyKKhlY705yd1J31lx1umVGr6AKo6qfef/hLRmHjZp?=
 =?us-ascii?Q?6XPoykICBuP7W31Q42ggbhETCWKveJFE6KNh+RMNUeQpPaVRA7BUYyDsIGYW?=
 =?us-ascii?Q?uBr375kOI25YjqWuB3npgCy3usM/b1VC9Q8sOqKU0MgkPhwhDiHV4kln4SGa?=
 =?us-ascii?Q?Od5SFWRHeAxT7eu9pizJTkBPWyDr5XRt6NdF1JlTKnttv1iZZacNy9ARNv+p?=
 =?us-ascii?Q?YIOlAEjJHpk/LBtcrdNsdN8JExGv1YPXsoIMdFGE7PKj8acx08uh3DTRiSgj?=
 =?us-ascii?Q?0BuHvnTLJVwjquxois/peiRoRqqjcyyGhxYF2UeDpg8I09PGvNeOCk+RZEbR?=
 =?us-ascii?Q?vEG52Vo0khYp1OJXvjDMwnxlbHeHXGq2iw22d87s3GD99Z83ECcMMMYD9eHy?=
 =?us-ascii?Q?XuycCYGyWIDggCGmdiJ6hCg7nuSvaWJK0fBSyPBsD8X2OqvQcBPr5Um1Ijlj?=
 =?us-ascii?Q?zy0Dsf5Fbud7jZbe15hW3qyjgUzipjzGEYmlmleZWRvE9rZWUZEhj4iXFr9d?=
 =?us-ascii?Q?c6UIYFuVv/Qn4/NkcHBDDr8rVsu6UnJW31cHsjvR6s9ozE+JZqaJ2ATHOaFb?=
 =?us-ascii?Q?A/O7IOJfUUF+tIXchY4DujbzrOIxRPiIEPgKAI/IcEQ9d9uxFB0Wi5bMSzhA?=
 =?us-ascii?Q?Fho8EIcSfB8eYA2eyj4/H1UAJgRrXCgF+RDQ5W/RqqSwXE3qNy0ll+EFJj7z?=
 =?us-ascii?Q?9h3OzZHWowBLAr3eOS5mOKmjaA+/pxdhU9OO4Kq0BJjf+sM7nS+xa+E/3nY5?=
 =?us-ascii?Q?aQErDa580U3VJT3i3F2/J5qiU7WjezzOLlAt1sasd7mbY7abL+TKSgNpr9HR?=
 =?us-ascii?Q?f6+TpTBZprUCbNxwC3MUSQG49cuLLOAqM2s7iwnLAlpp8CuFs+dtIzK6cwI/?=
 =?us-ascii?Q?TZNlOZ9k9wVwvek0LBLzVHY6/7em8GvxVyWbXzt85zT9GwHqQHTvIKlXwSB/?=
 =?us-ascii?Q?D1CuEvhG8US6JMSE2S6C1KIy92ybUQeHgVJDmnWDmAv0SejNw20Fzr0MJ2K6?=
 =?us-ascii?Q?GC/ASpw9J0P3tdZSTkAZa42MT1HDIsaML+MoYk54o8XEW4mB3dLROfcQxGiz?=
 =?us-ascii?Q?ADUYNeGpHsZDIIQ8Xo3UiL3rSGI8XRisKiN+8OsWNtHY/XEuBQ3ZvaihAbTi?=
 =?us-ascii?Q?AC9t2sk/nhcq/9+r36+0EsOtM1IwCT9hDyUdjMng6KF3Q8U3SlH42cWSkZpb?=
 =?us-ascii?Q?by7qV46iTFWzpVBsWhq8HdB5lS/yMkq87pV+p/Gk8F1TGm+gkWIb4yMaewXh?=
 =?us-ascii?Q?pIeeJVaizNRd1b06PulU/2a8mN5VkDWsDsrvjjtInbFAX/BNO8iBbZqutC2N?=
 =?us-ascii?Q?z+A7C4Mt419zdNzo8gsjHM7ydYiR8faHaQZ1UXIY4qiwhlpzVnyRCFJzwpZP?=
 =?us-ascii?Q?cpH4+7crjTcAtFjPLcDC6Kq8h2P5joEZEbMDkbhzmwTT61+EQ5XUhpdOkSzy?=
 =?us-ascii?Q?2KNYLs6KurJuTDwFV/7CFi1aRlu1YTz41XeOr2pN+Aq08PIwytLEIKYZgMHT?=
 =?us-ascii?Q?V06xldsBv8xIIGavwM5OiWNl823wNHO+CAWEt/xbFGHcXnYsVdlJARwxr9a1?=
 =?us-ascii?Q?389Um8+zzKMKyrZmHiTZ/57t10lQOd3FnXYrL/13/XyZ9xfLzBp5yYRFT2M/?=
 =?us-ascii?Q?ktdm2YuipFCttphfIvysVGIMSoAiiSFva9K/KPszNd3xD+WRUfMsKBfQrFzy?=
X-MS-Exchange-AntiSpam-MessageData-1: deCU4P20i5U3RnHoyyspnfaqKTgQWi0Dtzk=
X-Exchange-RoutingPolicyChecked:
	Z7pBE6iMOApk95iiS8g4vnxZfgp8jmIECHvEcK2Xr0fcjF5IYkBhlOYOd9rMEKsqrJQsApgnf1oHfEN+Z/uLSHIWYkUz8uPszuq/q9FlVtbgxxJYKGRE9+e9quvPvJbgEmngCeG3wWpadWtNKghr4i//QN+/vsJa9ystQLZJMt0YaI9E/kaY6N7kXerMdfQywOJCvAzP/GEGqB1dPIqDnSLMlUijyy4h8nQLRAV64XM4nyZEYDii32X7bNmLsJ8oMhQRQOCFfq35zFDtuo81OX5SSUKUwkFtHt71kJos40jbgA/pPiLvq5sLNUnefymXhY0/QuMwuG6R/YtbiW9/TQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KuITibXnlvRLiGomGWAvmDxB7VUJM6sLNo03h+gle61xn8+SQbfzYZhr0TfXMQ2dtEqja/F0sCXTuJ09T+op8SeJ6dLNreJY10fczzRaG/f73+wMuldqAUf7HFc6atFkZlZtybgXCJT3nrZof2PEsQvznSDDF5w/LWy84AMqFZa1TjMaLpYjocauqP2yYtMr0bBpNXmM638w8vTSZJEjRHhg+gbkPuTUzkvnlSe7zSvubY5WHl2xlzJt1buYNyiW6FzqGM64GmSIddQG9+7f5SpD2PlZaFBAXAECRrsgTbRwgCRqaiO7dizgSL6IneF8iq1vImw6S+lCHhy9UD8vvIm3DgfnwVqU0zV31EdehpQH53EG4JyMZaVCmHj7JuCOlE6ykJ29r6xS0Klyk6xHtHVzrWsmrw1KisdaPoLeHK5LkbfkK6ugo1uuZuE7UyQYJ3yuVUNoz+Ru2cmOIK6J8HYa7LbAuKGIPq2EBFFvedzS96JWWDGmNTvxxNCEazsf+EfiSDriN45hb/4yMBHXQPdtfri9ntRPvvOTjrhaZDzRxjQ7fVoP3S786OFHMdey5q7oSH4u/INV/bf6aosq4XJA3ga/UwwtAd6xvpeLy1a9k/J9bDh0G26W3VpaFtE4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff01e3e-a9ac-4b00-20cb-08defdf42f28
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 13:17:14.1115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yoWOMAv86HR7wyeZsDC0nPk0a+eatQe+fDn5lD0YczRbF0r0XvdoxyMABnblmNfI72dpWV14RwkuMGSh3QI0wUNKSMqUQ24bircSfEit+fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7385

My employer is called Western Digital not Wesgtern Digital. I'm sorry.

Spotted-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/generic/781 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/781 b/tests/generic/781
index 575cc4ab..38536d64 100755
--- a/tests/generic/781
+++ b/tests/generic/781
@@ -1,6 +1,6 @@
 #! /bin/bash
 # SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2025 Wesgtern Digital Corporation.  All Rights Reserved.
+# Copyright (c) 2025 Western Digital Corporation.  All Rights Reserved.
 #
 # FS QA Test No. 781
 #
-- 
2.55.0

