Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085773;
	b=QRt+6b5yQxRHRSDjf780mJI34mZDoczwMkfVh7eBK7JUsCOjK6iCWBFNIKxsSgfpApj5
	 wuk+BwhI8jHtaGX01nayPzhHbysAVa0dcwzpqZx5XiyPSrfbmPnm8qaeE30tpZ4GLjvTk
	 Llz5i+00QHwXYsjH5cWvEAqGzjP1GF6mIaVsWvfr+T6P0omkUFf71Ufd7qgV5UU2A9Lfq
	 flWsieM2SSRVdbIOfO1V+yPCBwhfCu1QqE+EQBvEx2S1zCg8/XqRHkOxlFgp0Qnclbt2Z
	 vyXNdtRzHRWw8MR/SP4hLiCIOyMruEhzukVten40p95GOeY0Ws2XWNSp/RgahAl70Qg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085773;
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
	bh=zfPYA/mHo75lmjf8Mc3CHGHEr65eru0BBwyNYLsYOzw=;
	b=zd5E6QUDHvHo87yZli5apgvFgAaJpmnMoRv25FG1BUVylyLTRl22k64m/15rk61J8v1r
	 1Gk7jrrI2ssrzhFrmSMOrKd9NJp7pjM4feDY43RfP3A/7MzmP7ASS17c8+bztWBCoJzEJ
	 UTcUzIgn2oQ4hvxGhMR2D2T+cP5iJa8c8Ruur9y9rktIX1zPw6OFfW13A7CwAH1j1HiM4
	 xp7LB78ROVzRNM2xo6hYZPSULYrjK9M76Coh1LG18dRLNx0D5QYWkenSfemQ2fu2RwqpS
	 pS6H03iQO/XKvN11i5NRRADaGSeacg3uU5yLhNijAOsE4W+QucSjslfm0m2BoKTyRaw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=AqAZTy9K;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=qytTsTds;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153B4606A32E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 153B4606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=AqAZTy9K;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=qytTsTds
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085773; x=1824621773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=pLSoubyB0WaMxIAdcMGpR38QW2KrUDhhFeh1NXuP2EY=;
  b=AqAZTy9KLtVh2WkaCyCvxZM+Vbm/EZsMiOP0RB1ZLexT/lXl2bIJFj6f
   Fbi4tuyD4IfYSafcAj+TWxUe70Yn5/BeGq6rcckLLUZEeGA7kDPJ+GhF7
   gdojyIyplvNC8tKnA8UnYXw0cuDNHzABDXcxj2nVScZ+lVAaoVyFsp5ma
   uN+akGn4YxRC6qNdE8nMFnST1gobZJOWAIOafUjAnNLXUsMxdUsI6B1Pm
   sWoMRYO7jHsfsb1/q4smyRR4TjkSBuLL9pajHM37oQgj6+R4VASfSEJ8r
   jXhjq/IIqWREcMlq6N6imjHqhzK2WcPUd1WB1H7VLIf0NKpNZfRKX+V1+
   w==;
X-CSE-ConnectionGUID: +ix5VNa+TzGHXFk6glUWcw==
X-CSE-MsgGUID: oAb+M6QITqOvYXP1tGQS9g==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="159092292"
Received: from mail-southcentralusazon11013009.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sfhs+3XZqSXitbkZGcqJSI6yTiZdueOSLImak5t3mj3qAuFJ6aCdpnAfysOUIz2tb8Du8kMqwcQVvfZjeM/WQqOIBzaOo9ZOt0WGjzVhcmCAbmw2+gGrkbkDm/zCGQlBue5fiRnxJMN5iOSJbIsW8xzeim/0zbCxVd7ll50prQVMcioGviCUKI+bflP1JMur1xoLxshz1FFkkkzuSFxBJkW5zT5uqkupIF9sjFGEGGWzuGV760jchfQW/qxblQQ9qwZcxdP9NkmTaz1gaGkSDM68Q8vwaKXIiADgFSLD5hTMDFRbNIV52PLgwXXVOX4DyIfKPqtqVd0+tVJrRbbJCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfPYA/mHo75lmjf8Mc3CHGHEr65eru0BBwyNYLsYOzw=;
 b=ADqZsVJXxwoje4e4uK72Fux5JhR+1I/rMip59B71bJhrP9azT8QqlDy3aaig+DD9A+dxOPJNA0GOZ5OXA5SL4qmuZviN5tYc7MvMCsQvCxTgwIFC8V2LzsGOTpQr0GDczMdhIwdAUEum7Qh0ipMmiA3UCUxWcBCYJApYX0mmY/OmPRNbPkr+ixHp/lGTC0JWwIfuIEjtfaqvJLno7WECyaR2kwcxhT5/fL4D5VkZu6K669ajVMh3CN+C9HPul0k5dodgSk2Gt7xjqAIomcjSBeFrtHwnccSn2H3ujOIdcFpwSYboTXMWJmcmxo44OYvZ5V+TqVpw9+Al6j9eFUJjMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfPYA/mHo75lmjf8Mc3CHGHEr65eru0BBwyNYLsYOzw=;
 b=qytTsTdsN8+j4Q2cOCCc2mGxJU6KIftXIy4AzqwxlJJEmK6r6uIaUeE02dp0Bb0F8VWbmYK8x/T0FPCOYkLTR2uF6W1hBJ8JV1I/SgcUYR2zGkHIrdoef93hQat7P1t8neKdbg0twhpS4WVX+SqJ7/2JNxT6zcTF0fg8CTJG4fE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:51 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 04/25] btrfs: zoned: never activate conventional metadata block groups
Date: Tue, 27 Oct 2026 08:22:10 +0100
Message-ID: <20261027072232.419318-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 615cfd53-11e3-4c2e-0b1f-08df33fb1c33
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021121427099003|10067099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	wMnIZ5PPiN+NyHPOLfIulSRh1YonYWdUtk2tl63Mr4a1jhU4YdJNtrVIdA+ULMl9Rtyp0+Qegfg9pn5aDCFlLEmZWPod42a1oGM9VgGKBJwVLTE4y69GkGG2FpX7Z8clcVAmR9/2lZ68IHqAwIgq8oADHLZ9cxUPlEwDWbHC0YrvcpRLuv/q+vjDQpuZw9L93ocC7YBPIFmmInLGVwBu12EGci5yYGE8PSon7cRi/AmWapWQuPj/QLmkXSwJnIN9hJO1VC6PEOBJ6wCGEPrrK0XqD0p5bS2qAMrW6/JgDsFEVPWOsyl/qxx/Z2Vh+DUiPvPr5dsAEOqYWuPTtfl59giAuTsDXan7sY0XR7CibCpyy9gj+ESdD+FZ2i5JrrKmCCBXzwONkCiWPX+imy12fly7U4MKRX2yrDNQOjdTCf1SZalP8z9+gB4q540lUo6MU3m7Ivw8cqCkf7XEZsWE/pMK31aeSjTJ8T+JQVAM4AgKrpF0mR3QvCy/PfAw9H2is2St38jtxUfRZlZQvmGDYfsC71pDZOLrXC8MtzV8dgi+R17+EKmz5KRIcAI8W7jCgJjWwZGuHERdXqq7573JBwPcrfz+Ka7xIDb5i4T4DpSzxrLNQGdaxt0bYc3FyNNFR1s+6qbbMkVb4AH8/SRE+eb9I6b39kYCtSn1O+SfULM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IuXeJBI6wPyUNNPee/l9Hdgusu01+A8ik3LddIaCIcs5ImglVh+ICWcaLO+Y?=
 =?us-ascii?Q?99SFFXHaAiluuXrhgm0EWiwgETrPNW8IwNTPJWT8jS9ZtOrWshoSKNiaQkzB?=
 =?us-ascii?Q?0I/ugoqf33oApY0NhhjQLowDMUTx8xKmCY+L5AuJkBJonakk6xFm5Sy/rvsr?=
 =?us-ascii?Q?4jx/g72ulqZtjOElJ7upfFukEkjH4RmIRuGaADpoBcZXlgP0YpgXo6vsakdB?=
 =?us-ascii?Q?eKF6aQqzw2wFa7d1FRd+ZZuJhN7N3yMGw+IYbjCJCH5MqKj+5JDDNvafxCBb?=
 =?us-ascii?Q?t321Dgvx/8cabyoFqgTKrSi+Av6abzXGfW4zepFnbxru8QUA9Nu2oV0MK6Fg?=
 =?us-ascii?Q?/qbfznc72TdfcFA1GMFkWsSE5EcUggLrq3qOjzAkEaw4hvnqIBjFUWxBjrY6?=
 =?us-ascii?Q?KsAB9EAR680LnDQK5puyqMUXSBeA9s0QCoImLmUIT3GgnBiRKlNvNmIWDYS2?=
 =?us-ascii?Q?qLu7Qj+Csqoyzs0sX2bMqptcdgINHsuSllLdncW0wwZq+YYJwHGTYdy+YAQ8?=
 =?us-ascii?Q?vmRusRe1wDo4TOMAckBXc6FXiJqp0xGWboXinpkHFmiQ8Ez2U815WvwAMCFb?=
 =?us-ascii?Q?Y8K27qHiYGzvDzl8CmSdWeQ01zVq1RO1Xl8ocosvZZ+zM06XbBfOWCz2Q7Hh?=
 =?us-ascii?Q?c2VbOxB+G5n/GW2ckhd7PMrWPwQMwFWwAvH79nLM9jMZMUj2o53Y885SZ+wl?=
 =?us-ascii?Q?X0zgDTNzIrvKaw6P/RVF1EezMZKx5vWf0/aDBHQ4w+LsJ9QEYlqDSgCZQ0oc?=
 =?us-ascii?Q?oT3K9NsIS0BfAz2r5pHKWMVphwqJrxL3wpdV6DJ6dF2zcCtpkoRQ58bO73o3?=
 =?us-ascii?Q?guIl1sfE6Q1jxBo3KETds/lXF4OXsoTp1b139RYMkeJX00XCiXbZsQCK6tem?=
 =?us-ascii?Q?Bsjvm12UGwxqnXRSC4fCdI00BQd0XfvaaFPox4t2wZTZDaDChaV9nN7pBsMb?=
 =?us-ascii?Q?5SgkEeKAl+d+OeAIRAFjcgNJ1hcR7AFkN1n2ktCC85FY57029ZM6/p2M82XC?=
 =?us-ascii?Q?Mn3cs07de/6Xpmp9STBwaIdXg8h7q+N1p5yY0qYtYM8h/o4Ts6f1dBZFFF0m?=
 =?us-ascii?Q?VUdiToTZ2wnMOxE5XDlibvJyB32b5VEoAJfVrW/wQATK4rAILaY6nwPuvb5H?=
 =?us-ascii?Q?uhaT2EWaKu0bUm97rcdX4dnmdcqEyAQvcUD70Q0B8KPyRlouiHebW/dhFiYB?=
 =?us-ascii?Q?0fC6flo2vlwweqRbX6VTYHHYLPtoqwRxCYA1iNjvcP+9SDfmwlqhjXF2z4V+?=
 =?us-ascii?Q?fWuX6cw27kFY/gBIxhKftFHHtabSqSLH5ZlT6IYA8Lu6o4kLHhccruQHpKPH?=
 =?us-ascii?Q?KaY8UHDxT7XU6SZ4wy0bgrfUYNeIlLgDlXYbJST2BwywEPv4xjbrTCs4MxhM?=
 =?us-ascii?Q?wRx8DkrudyHVY8ElVWgawjb7cSDcx2SiDQBzDy5f/wtL7OVDCyyg3ANfF20v?=
 =?us-ascii?Q?Khlnsiq4PaYxvzbkjlXv5hzLyCSljO+xFYyA+FgZivkbbAMynJges3gz01t1?=
 =?us-ascii?Q?Rr8WeMT9f+1t9FXcMgwbB27ZprgKKr88uiggYrM61ZEijoRIXak4Y7r4U0Tf?=
 =?us-ascii?Q?LocRvBAXpvhUfY6AYDzIZw7FcRqq5LAfHvaH0IReYHy3OUbrt9dHkUKNlTNm?=
 =?us-ascii?Q?4F4QruCdXEJaOquNSfQnSRKcwq2miweYLElZmTtHgCqSuVsDYuM1A8kMuDfJ?=
 =?us-ascii?Q?ULRc6vHkDOXbTeznpK8onJZu9qJ1afWtb0Vo2vpAdt23wyP0+5jFrgHLGrk1?=
 =?us-ascii?Q?960BN1pBj4ZT5IHuUmexPqwCsHogUcC2ef3nsfgseWuWb6PqRCuMUnayPPkQ?=
X-MS-Exchange-AntiSpam-MessageData-1: P//Krq3+i0k/3ZiDdBsaGIQ71TaCIdalk2w=
X-Exchange-RoutingPolicyChecked:
	Rm/xAK2IOlJo9Vjv/uhjsZxazNOc4Cfdx6b+9vT2KnO8hjKDyKQ99Vol3GI7aLLrsi8Tl93uPx3lP6mLv3zvKGh3LRv9TS+2t3mvB42J07YuPbAxtCy2daxaxcghbLKs1smRtpREwVTb7tcaIjZWBTE8yGZPjJuYXgI5HvO6rZRA8rjdIv04lLb+qZ+iuBKH/WnALVYzlHmSPserSLm4bo/Bo/DVfU9qly0dJVCWqImfFYDmR9g9FmCns7gCpVh/u/w9eGpuLvflIHO0tFWWkCaE2p1FOb3qRBYQ4D4mh/tTJb6gtQ/ljDxW/RPK4RqTgf8ORCYc59Ugo37zAxkRqQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8F1+H/HUhSz57dSGxh0lKB1cVQQkxHO3EqvXXwHz9YByivd775jY72V2M/EAPJtpQNgsBjuYAqPtF/IV467viavckg6aflRGUP7WyPKN9kCGfoqY5qkRx09+Z/p4UGiE8tg8zwGPApblU32wPD/uw4MXTQQwscVdP3Qw36fjDQUL4OaUHyNzJnMVhzgFMUh+izXy9y6gNtCE5XQ9TMXpx684rTiSMngqd3VaYxxZTcn4X+abR0+6HjONfLnLIaQ8GoU2tq482N2t6BG4B/uUL4fvgYhYG9r6+cyiZ6D0BHpoPXv3WGaEN0yk+m6o0Wav/tN0WS8EqhueQA3XWrxlh7Stf9FOWVqlZ4+rpX16+OtsuGE1fSYUrgJ0smsAnOvn7zeOt4GZYpPCozByGGAVsOAm5UnwQAc6gug+Yq+YYCeBFVouASrCroUlYJx+1VBNRV3T8/QhJec4iBtEF6s7CD8Aqm3c0Vf50u273/GFAq0px4DWru725wLEO5zL539GXNO9tXmSuvkz9PXkVY5InUjfnIRn+mILXb7Lpolgl8aMAMnhBuJ4WE/PoiNyABMUAeJ/AngYBUxCYLiNJYFBFwO04EYxV+zqJ3ldd9YH2/RYZtTuc/v7oSGqEr8uBOvf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 615cfd53-11e3-4c2e-0b1f-08df33fb1c33
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:51.3491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHFuSU0pKmWe1JU5pCaUEwW8yCe/xAG5z7nZRTQCcwBBDdsDrBA1YWUc85K2IdNmiLzb/vb5I/B1sPnQXSftX55Wx1c+1xePKG/TcsJeabA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

Metadata and system block groups backed by conventional zones only are
written in place, so they do not need a zone to be active and they do
not consume any active zone resource on the device.

Make btrfs_zone_activate() a no-op for them and skip them in
btrfs_zoned_activate_one_bg(), which would otherwise report progress
without having activated anything.

Such block groups are still marked active when they are loaded. That is
dropped once they stop using the append only allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 02c15b2da344..e65ca60f3ec0 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2451,6 +2451,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -3060,6 +3063,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
 			list_for_each_entry(bg, &space_info->block_groups[index],
 					    list) {
+				if (!btrfs_zoned_bg_is_append_only(bg))
+					continue;
 				if (!spin_trylock(&bg->lock))
 					continue;
 				if (btrfs_zoned_bg_is_full(bg) ||
-- 
2.56.0

