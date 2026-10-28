Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211703;
	b=swfHzQgFS47Zzvg32/eicaHB2Qw2zUd3VY5TmhbIblcHEXyfYndLUY4nj+ItxLNiI9Fs
	 8zbBMvyMFIn2v3YZMMMxa6sN5Cc+KADu6F0XITw0i0wLkqmB0NY1pTVKCOp2Orwrjz6ov
	 OohaUP4X82jwisJX7NxZ43lwn05uJMYR6nnWiVq4Qwtbf+Z7Zwwdm1JxYsGUwoimiMGwb
	 Tk2GlPKNwTTYWmY5nT4ezu8D6kivi+G/mwqNHMxrk/z8C+iDkf9lgmMSGadBUjwS1tMqP
	 ec4PwrUrxcwo+ZnV3SkCS8j8qIKKb7Il+0ntuZZwOxdEMhZmTNkJLsgoDNb6zC6rRgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211703;
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
	bh=vlg9v+TK2v5LBqfsevFVSLgTczcf7Rcccyzisa9IO3A=;
	b=BIThPqJqmgtSU5Dz7mDujjeFAcg9WRwxKK6pIuOGrFfd8Cqe0JK+RNPke7d1R7YAzcmz
	 3NLTsU7YzMJ7TxXww0nJR8W/lx+DEyFymVtQA/a9xplVHZ6uKXHpG09iUOQUy+0G0gtZN
	 CKn1A3tFe66aLxn8zgYZux5qhFkG8DmwjA/pGlukwxpPAAEKQa/duBrJt8epIHYYDuGAs
	 vMf7jqoeHdLgvNCE9rglqc1ZdwVhGLXFjy9vA+jML7p6sQRRcWPsgc24bP+VCllywYT3t
	 VTkz2xOAYr3zyty0zSb6np9bhkk0Ouzwnhl2VpFzlnPQIeeGSBWF5eBy6jl3bn6VKAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mpqDP0FD;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BpEdickn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C5260A2603
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1C5260A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mpqDP0FD;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BpEdickn
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211702; x=1824747702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=JTgb2qjFfNFLJRvQpboDHW0BtQ8VePCpYEyU+ay2NrY=;
  b=mpqDP0FDH5U/30cnEV+O2cuHjxZFlVVAhlLq13ZNLqRm2zyT8Rt81PT2
   Sx22WraketDqowBTja8XVL6wJJ/tVInVgk1xlLOEI9EPzLiJXR0lpHZT4
   wbb8/+updItqCE08+8b8Gltulwa5rd+DMEPYz5X9lrs5MI5qF23l5dmvk
   ZPB1TLosQF9Nbr1shn2jdfcFzVOSPxrACEn+cowRAAhx7E9GP0Lb8d8NV
   3S+GnFYhNTO3Z4knp/PFZKO33StJLx6WM63pibK2DaloDM0watgLJCECQ
   lLr8/0VFtDqi0T9ZH6avzGUP7+ejeT4zwGcjanu9+buNct3FSl9ii3ANV
   Q==;
X-CSE-ConnectionGUID: 4AJ64ERcQBCtLSHGPLsTZg==
X-CSE-MsgGUID: zPrWZlOlSu6Oew4pCQ62TQ==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194162"
Received: from mail-eastus2azon11010053.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LBDPlKY9AbIZwJEaeEz7z67tp9LCVgdzFIF9qOFENNBLLy4m5xOmeAk7ttJV905qUXC+n5MM1Cpl/Lbz7i6lbGyqhny6oqXIo1IXyOQy+OVW9B4e/JXaZL7gGcM+uytI36e7S5fDfWAWE0rAg/ENmSIGN0aS9oBgSBDp5eDs2gfy3n0BTNHFVRJ9ycRaL3/u43pZxPU53mEQIVBd2iZUOEOGrbpoaTc+BbGkX04wd6ArT8faC6HV/A4K3cvHtMIUba29F+ZX25HTcmozBDR27Lbyk24UO3Knt0/89jWEehha0MFkosrkwXFdQSbIiS2eIzB2Dy3PkjYwcjx9tIS5CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlg9v+TK2v5LBqfsevFVSLgTczcf7Rcccyzisa9IO3A=;
 b=bSlTLg8TyX7IHjsBcvEcRwjq5gPw4EmHdP5Yp5BCqe5T7bmhSk77gAmOJHjwFnoafnsUL015P0MlIO+E74v/Ar4s9Q0+Oclk58N1fjziVX0F1I/5Cqjxn8Qg10Vsw2yAdb7hmcd+cy6URZFNcqBLdwUZX94yBe2+Rep77ICIXHDlADKUl83xsUy8vMz2Z6VKnCUrntNdcd/NWkkj68S6lzigBzdjMxfLRW4qP4UF6wOCrIhTUu10vgitC9CHsYycIkjc0LKHRLhwwlpzw0IYHg11bJDwONMdRjRcYPqKyf2SmsTgry/y5mR4GbdRrob5fAXVemuuoEltIj2uG3bfnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlg9v+TK2v5LBqfsevFVSLgTczcf7Rcccyzisa9IO3A=;
 b=BpEdicknV4yDPQ3Ezs5Z3Vn613lz1bX89dHb0F2skwQatiySPwKCkJ0WLszjjDynwI1MV+vk2ZmzOtSddNCU/AlzvEWCAqX6INGc/gxjquBAtZzybgBA+xml3TqzcW92uF1sEi5HthymsiPQsKT0C/C60kkYTFFw0Ovd9XmLQmI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:36 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 06/25] btrfs: zoned: only take the metadata IO lock for append only block groups
Date: Wed, 28 Oct 2026 19:20:52 +0100
Message-ID: <20261028182111.160492-7-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: c9c12a9c-3ab5-422a-38b4-08df35204ce0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qXz36GyVKeoHz0BpbfNJD5Qx1g5mIS6q5PsTSGTlDfHqfhvGJ15yLJMPKGoKHAilSSCSx5x9pLxcx2A3m674jJwF6NGhuVmQD48+Us1akthlc7W0R5hNu/DmyjrPgmJHmP4fb5v4yU54y9E+jDQ+vVaJZQpBmfiF+BNfZDBv5D3SbcPoR2ZAliqqag43HSv7CBa7aULimSGyzo4I0RrN/lbW6YHl6Vh1lEhVwGh3YvtKd0s2YVvxKHiEJlf/M1qrQwpMPnL28iT5r44q1gmcU1oKYSiMgA6jy7Fd5HpP/YmfR5y7HwQDVwHEiFV78T/TyodKHiGxRZUbKqDYCOfRa/0XwqfD2W+OcztFkdPCd7+hkbRhJMlZbm1IVlt0FJOXSDXQ4lXqZQVUJB5Z3jgkMGkI7xhZUbNN1g/88INCWyKjJ0xcDvP8mnFYz6/2iXcr6QWaz5IXR9lr7E3So4v2NGXNnOMSrjY1tq31b70R407Ka8QS2y7us8xMkWFbBCfy/ynd1OG/IMC4+NmP9hyC8ZSA3kOxwbmC3j2aRCuE/33nhoVUyBxnpqqjzfSarkHdCQ2ethFp2UXMzIMcyK/NALgq5GAMrRQz7mBT5lmMXm5tn7k2JgRyqVJRJUSMyBao2NOFr+u9GedK5ZAxVsNNtvQC1AbcrEaK8LaXNHEM540=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ei1XNje2kSVqD+9N8II8TiZuiOl6PbjBvNKqTKefmiAylwoRllxF18O76AVY?=
 =?us-ascii?Q?xt0JyV1YvLsmC2FIQdQPdCp76Tpu6HCgVY1h1+und++OxRGNxJlp+iWLRrB3?=
 =?us-ascii?Q?f4mfA7nLrue0tlbEA+AcBMkTaOqG5XXbZ4PtmCo0fEIrK78uJyXJGrn+tctN?=
 =?us-ascii?Q?VXwE5u8g9rM4oqBDoF15L+hi6qiX/8fssLxmdlKeL3wBcgK36myN6d0lZkgk?=
 =?us-ascii?Q?tzCWh+J3lSbMFtDVtbQRI+7DZzCQRdAUjXCVByk03x00u4uucwgHHNCW7evi?=
 =?us-ascii?Q?HNhy4vsve+qSY7cS6g/makBXY0XDKryNkuSN8cWVQDd+V3JufSw0tF7Nisks?=
 =?us-ascii?Q?Yp8GQWvBYD5pcXXmpju81ZHxFtH2h6YQCE+TOLKD01sG2K+sCmmeWDA9xJFm?=
 =?us-ascii?Q?LDJiB7pQ9juHyl6P3B0xx3pC7U0mIKAxV8IFmP6Q7YV74IYIsTeOCdl3Aubk?=
 =?us-ascii?Q?KyRn7oBTOr9r0zm7x9botRquxUhS201myeG45mappjIvsfOss4Od1DdM1Y8w?=
 =?us-ascii?Q?GxEaV8jZMFOszHhu2yqZCe1a92GstIQrhIZBwU7sV4GOqhZdIla0MI5T533S?=
 =?us-ascii?Q?Rf16AWgb8BnvwJf+9LeA368v+kGO4luon0FGfAAxHnp5MDuS+rBxLXvO3DDN?=
 =?us-ascii?Q?/iCip8KVRVbnXYhmqbqj/yZywputjru2wxDesSPPbF7jiGjALhkuhHXAVsrr?=
 =?us-ascii?Q?IcGcbuUAD7toRiHalXkx76Lan4onTnz4LYTCXak3kkglHJap2NLNZgFxWY8X?=
 =?us-ascii?Q?IwU/63lVffL92jEPpGd3v+IiuREAajpEkouVziH3BFMp2Fm8fbxtmXLPH0Wh?=
 =?us-ascii?Q?Aa9gRNAJfTRFFBku0A4OvFbUUDYOieDapY95634Yri0UtIltJ8Epd2tD+IaG?=
 =?us-ascii?Q?XWNFb39Vh8QsWRT/3COQlQxgn3PedigUDeP8CZxQgDXbLPXOdWehtN0A1kvA?=
 =?us-ascii?Q?CUbsWKO0hL0iYBaAb4MPPNcmIKReqI0w1tGca/W07gezUk8ghuh7TIIGmf1U?=
 =?us-ascii?Q?gEQrEVUGRb0PckM2Mm8Hg+vciRKlYbYcF/wh96HGucVDw++7Obw9nD8R3E51?=
 =?us-ascii?Q?Ue+UUEzFJUbJie54B80DgT+24vhp/Tbj8nMp0jp2cGECCSZJj1AjeeKJ8/xI?=
 =?us-ascii?Q?DQVm6W7pzt8UUl5dBOs6bd9itSNe5zKU26paCVclKd2ytiluhy5gtEhz8Qhv?=
 =?us-ascii?Q?t7MGtPYdpFXvSmE3jibZQ1gYeBjlSSW4ALTmWogBSdm9CQLkGwOO6hME1U40?=
 =?us-ascii?Q?nun7lCyP2nVxvDj0I7hbUASN0Wk4D7P/BTmQ7ia4ada0lG8YYOjBdSLd6ncf?=
 =?us-ascii?Q?Puca8B7XM2n2GY1N4myhGvjOgeXJmrTr/fadY9Ie2ckA/YxNWwfS37Q/MN7p?=
 =?us-ascii?Q?S2OFh+aPvANIiTH6rsyu0cmepjlPIYjNIdD0bhW148+B1T3fh6hOm6SrleTp?=
 =?us-ascii?Q?MHIcGzo4HG+svUp8DYs4WV0xv68m2V+w0RtkoxnXZeL108vas4uv1LVsvdTz?=
 =?us-ascii?Q?auG2wQAn0xngwMZFh+AXI3qPeqtCKr2A/B8xkogvkrxjNy3sPBhWBu2etC9+?=
 =?us-ascii?Q?937xstr7iI/iWc36FcPmgJFndo52+r7X0//m0H1Z80eLXPY8iGYqGdAovrSp?=
 =?us-ascii?Q?XuSa8JXaYKAVJ9oRkHCMUblXiVKAYXNjYNrFJ9HUaS3wJyIkEKngQp+B3Y1+?=
 =?us-ascii?Q?6bYfk4YZNLn747NIJzx6yxMfVMEl8IHUy2qYIKfz9icEK9U5aEdV5ktvbh8S?=
 =?us-ascii?Q?Hhic3ixx2f0iLcpE3zCrB1wriPcJEpVljAaB1qOM3sH5W5PM0eMqotdzvryS?=
X-MS-Exchange-AntiSpam-MessageData-1: TBD6v5p7ap6YfMHaTxEpKpvMdVXArJ6YNxI=
X-Exchange-RoutingPolicyChecked:
	4ZJ+FBD7bD7xbxpzztlud1f2su45CKQDhebx5ZdkPwKIf46HRNgLTiqkcGuSncthTVhJkTYsTn8iiwe6n7V1r/B58kzgFmkoMSi/C8HRd2AZZro8YN56zxGcv8AyPxR8aj9YknlRsTzB6VCYMGBbfXvyfRXJ1xy/9C7J+CcWqQsI1XTEqkgK6dsC86nHRid6aimVnF22eAwafGueIYgMGtcEyLLOo4hm1J5yljw3SuD6mY9UcLWfJ4b8xMv4paNHIlo2PmDP4Oy1wa8X1+jaJxdILGSxuG4KCMm2Zj89g5UaEYRta/zmaJ+AvPBav/Xf8+rb6CwkX1SvRLhvDwjieQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ku64MJsycijCKRvrPb+L9IXRANBNkG9l+1uNla2QF2RZh2ysXhyjA1Y/LeIpV5RA40G4L4ouO1DBV4QnJ5nSVQDHQ9wqtO5nWdiNRa/7xeRGpsK76aPEkc+DOgNiYAMu4VrVP8NIXEss2vDRs8ACQWzALPvyuY8EduUunNj7sBTnfWvt4wKLNF1yLEiFBk1UYZ4Fz/DUVoLCck91W2lpQT2mLIk/0Aq/BP9NXxqaBhIo2St/ut3bMBH0zkF8jZUKy8lLrm9fm5zSZVoH35ft5d+mDIpCz/UmBLjYHH78zYynK7P/tX0+CLK785uQI0NExBb//WaRtHQMSyVCpo4CBzp4lJbGA1t3qHf4vLl2a81GHyc7PvpuiwRp/slUdiuXu6Zij7LOfzfmxRXiE60sLGit0CbutYgKO4oekLehES53UKXf0C10Lq2d7Uxx8/81AewqwKcZySAsvDAALHOrAIK56nV76vfBop8PzXtAo8dPhzbTBO0fBur1K2LEA9k707HEQmrbO91nVqPUGGh+Ee5h8/wQYBUDa1hd+JXiMjUM6AkoL6PQaF15Km/PwDjr4RTc82u9JY/bIyPRVxmfEnqSHu5odkaXsJg21VsdQARDMtCqVlH5DPWY2xrig2ig
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c12a9c-3ab5-422a-38b4-08df35204ce0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:35.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgSzAuDWrotJcKbBXJSwDDgi9Cue1O+LeGqOh0AmuamUoLJMmk1WjzEXcpdslwVsDnIdy+L2ZkS1vCD/lVDMXjtkdQXUSEqLcos2m0C8Ndc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

fs_info::zoned_meta_io_lock serializes the metadata writeback against
the zone write pointers and protects fs_info::active_{meta,system}_bg.
Metadata in a block group backed by conventional zones only is written
in place and in arbitrary order, so none of that applies to it.

Acquire the lock lazily instead of around the whole btree_writepages()
walk: take it on the first extent buffer that lives in an append only
block group and drop it when the walk is done. A filesystem whose
metadata is entirely on conventional zones never takes it at all.

To do so, split the block group lookup out of
btrfs_check_meta_write_pointer() into
btrfs_zoned_eb_write_is_append_only(), so btree_writepages() can decide
whether it needs the lock before writing an extent buffer.
btrfs_check_meta_write_pointer() now expects the lock to be held for
append only block groups.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 70 +++++++++++++++++++++++++++++---------------
 fs/btrfs/extent_io.h |  2 ++
 fs/btrfs/zoned.c     | 40 +++++++++++++++++--------
 fs/btrfs/zoned.h     |  8 +++++
 4 files changed, 85 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b49581eeffa..9a85fd478d0c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2547,16 +2547,15 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 /*
  * On a zoned filesystem, write out the currently dirty metadata extent buffers
  * of @bg. Used to flush the active metadata/system block group before the
- * ascending-address walk in btree_writepages(), so that walk can pivot the
- * active block group away (finishing it) instead of aborting the commit; see
- * the caller for details.
+ * ascending-address walk in btree_writepages() writes its first append only
+ * extent buffer, so that walk can pivot the active block group away (finishing
+ * it) instead of aborting the commit; see lock_zoned_meta_io().
  */
-static void flush_active_meta_bg(struct address_space *mapping,
+static void flush_active_meta_bg(struct btrfs_fs_info *fs_info,
 				 struct writeback_control *wbc,
 				 struct btrfs_eb_write_context *ctx,
 				 struct btrfs_block_group *bg)
 {
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
 	unsigned long index = bg->start >> fs_info->nodesize_bits;
 	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
 	struct eb_batch batch;
@@ -2591,6 +2590,43 @@ static void flush_active_meta_bg(struct address_space *mapping,
 	}
 }
 
+static void flush_active_meta_bgs(struct btrfs_fs_info *fs_info,
+				  struct writeback_control *wbc)
+{
+	struct btrfs_eb_write_context ctx = { .wbc = wbc };
+
+	if (fs_info->active_meta_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_meta_bg);
+	if (fs_info->active_system_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_system_bg);
+
+	if (ctx.zoned_bg)
+		btrfs_put_block_group(ctx.zoned_bg);
+}
+
+/*
+ * Take fs_info::zoned_meta_io_lock once the walk in btree_writepages() hits the
+ * first extent buffer of an append only block group, and keep it for the rest
+ * of the walk. Metadata in other block groups is written in place and in any
+ * order, so it does not need the lock.
+ *
+ * When writing back for a transaction commit, flush the currently active
+ * metadata/system block group(s) first, under this same lock, so the walk can
+ * pivot the active block group instead of aborting the transaction commit with
+ * -EAGAIN.
+ */
+static void lock_zoned_meta_io(struct btrfs_fs_info *fs_info,
+			       struct btrfs_eb_write_context *ctx)
+{
+	struct writeback_control *wbc = ctx->wbc;
+
+	mutex_lock(&fs_info->zoned_meta_io_lock);
+	ctx->meta_io_locked = true;
+
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
+		flush_active_meta_bgs(fs_info, wbc);
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
@@ -2625,23 +2661,6 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
-	btrfs_zoned_meta_io_lock(fs_info);
-
-	/*
-	 * On a zoned filesystem, flush the currently active metadata/system
-	 * block group(s) first, under this same lock, so the ascending-address
-	 * walk below can pivot the active block group instead of aborting the
-	 * transaction commit with -EAGAIN.
-	 */
-	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
-	    !wbc->for_sync) {
-		if (fs_info->active_meta_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_meta_bg);
-		if (fs_info->active_system_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_system_bg);
-	}
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		buffer_tree_tag_for_writeback(fs_info, index, end);
@@ -2652,6 +2671,10 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		while ((eb = eb_batch_next(&batch)) != NULL) {
 			ctx.eb = eb;
 
+			if (!ctx.meta_io_locked &&
+			    btrfs_zoned_eb_write_is_append_only(fs_info, &ctx))
+				lock_zoned_meta_io(fs_info, &ctx);
+
 			ret = write_meta_extent_buffer(&ctx, wbc);
 			if (ret == -EBUSY) {
 				ret = 0;
@@ -2684,7 +2707,8 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 
 	if (ctx.zoned_bg)
 		btrfs_put_block_group(ctx.zoned_bg);
-	btrfs_zoned_meta_io_unlock(fs_info);
+	if (ctx.meta_io_locked)
+		mutex_unlock(&fs_info->zoned_meta_io_lock);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d8dd2ae9ff9a..c73953a2e8d3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -143,6 +143,8 @@ struct btrfs_eb_write_context {
 	struct extent_buffer *eb;
 	/* Block group @eb resides in. Only used for zoned mode. */
 	struct btrfs_block_group *zoned_bg;
+	/* Is fs_info::zoned_meta_io_lock held for this writeback? */
+	bool meta_io_locked;
 };
 
 static inline unsigned long offset_in_eb_folio(const struct extent_buffer *eb,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1235acda375d..442f85e1f1a8 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2269,22 +2269,17 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 }
 
 /*
- * Check if @ctx->eb is aligned to the write pointer.
- *
- * Return:
- *   0:        @ctx->eb is at the write pointer. You can write it.
- *   -EAGAIN:  There is a hole. The caller should handle the case.
- *   -EBUSY:   There is a hole, but the caller can just bail out.
+ * Look up the block group of @ctx->eb, cache it in @ctx->zoned_bg and return
+ * whether @ctx->eb has to be written in write pointer order.
  */
-int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
-				   struct btrfs_eb_write_context *ctx)
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx)
 {
-	const struct writeback_control *wbc = ctx->wbc;
 	const struct extent_buffer *eb = ctx->eb;
 	struct btrfs_block_group *block_group = ctx->zoned_bg;
 
 	if (!btrfs_is_zoned(fs_info))
-		return 0;
+		return false;
 
 	if (block_group) {
 		if (block_group->start > eb->start ||
@@ -2298,13 +2293,34 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	if (!block_group) {
 		block_group = btrfs_lookup_block_group(fs_info, eb->start);
 		if (!block_group)
-			return 0;
+			return false;
 		ctx->zoned_bg = block_group;
 	}
 
-	if (!btrfs_zoned_bg_is_append_only(block_group))
+	return btrfs_zoned_bg_is_append_only(block_group);
+}
+
+/*
+ * Check if @ctx->eb is aligned to the write pointer.
+ *
+ * Return:
+ *   0:        @ctx->eb is at the write pointer. You can write it.
+ *   -EAGAIN:  There is a hole. The caller should handle the case.
+ *   -EBUSY:   There is a hole, but the caller can just bail out.
+ */
+int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
+				   struct btrfs_eb_write_context *ctx)
+{
+	const struct writeback_control *wbc = ctx->wbc;
+	const struct extent_buffer *eb = ctx->eb;
+	struct btrfs_block_group *block_group;
+
+	if (!btrfs_zoned_eb_write_is_append_only(fs_info, ctx))
 		return 0;
 
+	block_group = ctx->zoned_bg;
+	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 3a2ca8bd68e5..f9dbab976a92 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,8 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx);
 bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
@@ -216,6 +218,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+						       struct btrfs_eb_write_context *ctx)
+{
+	return false;
+}
+
 static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
 						   u64 logical)
 {
-- 
2.56.0

