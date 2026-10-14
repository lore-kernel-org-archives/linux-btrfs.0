Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9394AAC50
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979462; cv=fail; b=TeP3b9Xo2J8ZNMth0Zkw2YIVtfbNaETQ9y3BY88zVzbWbOkbdog8rkjacvb04VIoD7u/JVS95rYaKo92JBiaqJLyrrxZzBI6okeWdExpnGFi7VK1YLTsAQiI9lqgIqIZ5YJPHro40ivLqS7zl2J8gJL4haS8ahNuMz68hjPLnOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979462; c=relaxed/simple;
	bh=k0uwumzfvAU05U69J856CanORkN12+p3QnvsN6URpSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p67J5joroGjJLPa0UypmBvsOEHdLZlA1RisvvKErhSA0ENtEfwxSrGSS4BBbY/NwWmplA7d7o6MUYHlAONPT66hwdzK+KrgiXL2S86WnMmZGUCdbICE7k66MiHfgbeodmMTzmAKDx3jPzc5CC1DcAh5HUGnhzssu/BQGkBF8MmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=J484b9dX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nDI3qgMU; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="J484b9dX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nDI3qgMU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979462; x=1823515462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=k0uwumzfvAU05U69J856CanORkN12+p3QnvsN6URpSM=;
  b=J484b9dXcr5eMKbnEOO7liPnHbj5wQrKo/PY/5CnpegZFwvsTJhkk/kb
   CheQAbTqeFHsZCNPCnKqKeojJ7DCFSIxBgzJESs8G3qVzkqaAWVTUW5ex
   Zk0fT4HN79bmQ8WZISXkBIfy8RS/Wa2PbBSplcv5UXv5Kxh8m/Eih4s6w
   j3amY2c7BiFP4BNbBn6sRgSuzcKw/5oiD76KFCy/oh7PpVYty88q6JaLs
   PV0ozYDvzKBkxYAjAhWxzcNaAFQGUSIQEwoUXLqt5l+U8Q4GBltPpMb7R
   UgMmJbJND8sgF3Seleea+ecb5KKuFeFEl7c/Ln6AuU0KyYPc9VAXSMRdC
   w==;
X-CSE-ConnectionGUID: MbirKRtASYSJSoy1r/OKPQ==
X-CSE-MsgGUID: Rwihc+n3Tn6+vhACX5yxBg==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077266"
Received: from mail-northcentralusazon11013035.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.35])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GaHqGsCXJapKaA2eGcS3qO7xbqIEPVSknWSujbxppdKSQgUMHYnS8buYvZj3lXQ0ml2n/Nzs9F17pQLY0bwBTQ42aQpEdSndCPcL79GoCOcMkaqxjcvx+58Gq+kGiP+Sq5sklJdBtdaawGnQCfj26hnVFoVPF8xQ1ZejH8wtgCSoUWUN7/4MiABkVRgmBEJDaDSKTY0dgKCqP4FTiXGTUsYPrG9ZDlIqIepj5kXlCaqUAFXRhLPP7LOG5ijcbMI5wvAq1zqqmSCZIb2DLgK/0Aa/Y+uS1mTuJHtpFcufywjsmLz2dzpU/5YyhhLKy/M+wI9KC5vxbYg9NLKt7HWPmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnfOA5/3T2Ayp1y4gG2Ot5yYMC2AtupcLLhM/mocIOY=;
 b=hLsm2eGgwLWHIPdDzvPh1nPuh1MCPrykLK7xdNB+Zu5KSw0JXOs9f5S8eQqhncIxSEDZfg8AiYHKaXenYfpuA7Ua5iY3vIyr+zptgRwK68FqN8/9CG59/i7noxRK5XpZYGCNqn0XMUzukRojKoXFUpjmYYQTWAQKjeY4Ln1MOXMDxkb2AR7IPTtA0RCTMNuJqbGhWGmVckdQoeBsXKvtSGeKL0dxS9WX01uyG3FQw+xMZ5jxb+3W//oyf7KQpMtVFzhQNFsbTGK00uh35fJS5QLBWL64lFhpd0E8W/QAESTpM5SrIOL8d5emM/qNM+ovY9r8C/tOnHLgJnnrzwNgXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnfOA5/3T2Ayp1y4gG2Ot5yYMC2AtupcLLhM/mocIOY=;
 b=nDI3qgMU+ro8pPpiVtE1X+T7Rb8y9aFKWzgIlzEPKnfcCFdZfHBNuCbj5FaqOricp58wY/iuKskJ6LBz/3ThnZBHLQL3h5hPZz1vnOUsJSrsG+BoQbeyM12+e5uT6nGzNsRYdif0tvA/aCXOGDXUA/6JQd2PrtBt3BCe3AGWbLs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:19 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:19 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 07/13] btrfs: zoned: promote reset data block groups to the relocation target
Date: Wed, 14 Oct 2026 14:03:46 +0200
Message-ID: <20261014120353.757931-8-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: e2193b72-fa4c-4bba-8c07-08df29eb46d0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	/RClpatfs00DphHx5q6o81vmXA4d/zlr5B+/++kiXWG0jAx35tFs9dBLRVGYMaSIUiWm36i+cjZiqul5FqXPaRPXcr9GTjYthWAWeKYbID47Wcb4wFKGZJEsQVbtLEgN+lxiPwLjLqCwUgu2tFiCBM7oaDMDzXPW1s5ro1Obuos++Dpi+2oIAKiqQXZECxujpsKZNfg6uWbpGfdhF23X38Djw+nUic0OZADKb6XkWyzqZkr4lJdFQmgRaQW1lEjWS8J08Ti2nvfmz4As8ghwjLwstJv/BiVTqxx4gvbzi2fu/3Z0Xo8UUV/LgfFXhJSM5AHQoORPcdiJNRizBholxHnfIKPH/6mOlxHlRtZC+7+swzqC4Vq3j5rLxsnRQ5rrmjaS7AilbgrL9V14RgUPqsI4msmouA0cNXPnCL6hoCiXc8xFB58iXUSH6PiasT5XOg/gR91dWo0/wvFktDpmXrVFtDVObX94dV6fKi9lgTiyELV9KQ063fDn3faJ4m721SRxL4vuX4yY0AXpdoAtvFg1EOt2Z7w6WTHL1Tc3O5GG72RZsdX88acZ3aPJApwELHaw3ih8e4TlLRtiDNqBzjSqUkYwRi3wHpIQFCFhrHseTwjK9eK4WGuGesy7bRaJ0ZRYq0hLIo0bdzfI0ouhynHGyQOgEWUd/esd0II/7rg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B3BuNw5wet8twx1IlNP0+K77FopommdtNzVP3/NheGxSjDB3YbQ8DG75LcZ5?=
 =?us-ascii?Q?R1RvtEH94Qp5UrGb3DlpQKrn1baFFckK1KnOvjTA69+NOoKCKdosHdwC97DK?=
 =?us-ascii?Q?Wr9gI4cKkGeakfDQKnjavwKJ9yAjuypX2Z93Yvxal3HW61tAQZTMhOvehO70?=
 =?us-ascii?Q?cWlgefb3LRvPYbTbfCqz8Tdk3ZdUXFGLg1EiCWAuijcitApIyOQSm5inzvsf?=
 =?us-ascii?Q?Hw7psqY3SnAjEWpFAPsOuzmDPZPC+omY3zBAh7Nk9d2vcbGlGdjGHo7T6x6P?=
 =?us-ascii?Q?tNQwqL/xHtm02oE/rmca7RLEChH3GT7KLNHrahNyxWaAQauEcunTGhH0xZVk?=
 =?us-ascii?Q?j8E7+3kowHBLaYHokBhgK9wUyQfM3DI9AitkQ2fgXGzI+yR+FXVnGUjef8cJ?=
 =?us-ascii?Q?4iylxKyQXrMfA1gViULJeMdMCsVd/jHAP1MvtIdYO7tTt4JwEYwCm4BHsyVC?=
 =?us-ascii?Q?PjMF6xWd4gMAWKL6L2DBN9aKJ3be4/OfDGWu/3FApH0epvcxJ3VcO1/o4nd+?=
 =?us-ascii?Q?EHILOD8Siln0D59LM9fUfhv5bsC1VKITAVfzwa74jEavcFvwafbXnvq/oTdh?=
 =?us-ascii?Q?qh2WE+Ugx8jATc1YDjqAk0RU68Ss+9ddwnkZASPqN4DmTh28bSPP/5wDPF1u?=
 =?us-ascii?Q?mKKbknNZSsPSM9CtCVpXmy7k1dg+8YtcJ10+ZCSTPmw//myIr7zBnSdK74ve?=
 =?us-ascii?Q?Jl4AzhE2YD9r6JxVQktK0iP5Yi8UOI1BBoSdT9LCGNUS5o4RO7Sse9gIqnGW?=
 =?us-ascii?Q?VxKujs9s+18iCt1wkrTOKQhyWJsf7Ch15rfnW9EP3xoNcW27BCPbL6Fn8URI?=
 =?us-ascii?Q?T98NIJ9fCiyEKdUl738JaN5IsdGEcNP0pwCJj+5CfOW0vWrh/avjj16cUk2V?=
 =?us-ascii?Q?4KxIu+l4zghCv2C81ENwmU8Nuz9WsN4QpiwKXFq9ERbWTCa9t/PrSbAbpK5q?=
 =?us-ascii?Q?w6yaONWu2LGzmV29SrB2xgP6ESZXVbDEjS7GQBkRfQsWmKHY1pYHrPBQQdqW?=
 =?us-ascii?Q?LmGLXc0bUqXlBWcvTIVru3jyixpylucb/4y/4sTz1CA76xjU19B6Ib5iIbzw?=
 =?us-ascii?Q?hABLwQCgueMCJETTRsTES3IokI5nDfT8U+9L4KBXj5An52TaSEvgCDUxw0yv?=
 =?us-ascii?Q?4nJXwEu3961S6wDC0TIcQiuIRPeqzqz9/Xvc+BRnDauIYI13t1Za6a/jiyr7?=
 =?us-ascii?Q?JTJgBPjSYrRkbkDNcRF+ZHzO6Q/xc23SYIu3Yms/5slCwt+OXKli9rFet513?=
 =?us-ascii?Q?BskWLGUV6BVKP5jDb/28r4YeaTEwyef974iul94z7Z7yJ+/O93NgZWy1AdF0?=
 =?us-ascii?Q?J0nI9xbFgDBLBDzGRvhXQ3qzZ0irt/RvEIs79kULJNAOAmD4ibXNlNi12HF+?=
 =?us-ascii?Q?JiCvcd25tA2mEeSYI3uULhE1f9tl6gLIYxQtSiMU3rw8J7E+1A+jNI/hLggO?=
 =?us-ascii?Q?pJu6SFo+ipEDryFrPgcREe3Dsx1/OD7UjemcHDgon7YFmvXpk8s7ews5Eqk8?=
 =?us-ascii?Q?eW+Bx3uGneP6wIFT8GlA+AX09Kb56rqsM0kAu8IFCoBJnjuMaawhYzMi/KZb?=
 =?us-ascii?Q?Um8djZ4pWsmZK9JtamK+Ay87v5sjQaHy49IbiXDoo31N581EDkEE0D+SGun3?=
 =?us-ascii?Q?mblGooKAnYXYAZSnOw/CORX7VUhUmB5CUJoqYpshzoHELWN5NeUGew2/s2Iv?=
 =?us-ascii?Q?Nyx4w2tgU5Cphgo550TWLBpuGAyitcHY+f9n1fNqZsGqXwu5hty7PKhzooCb?=
 =?us-ascii?Q?PeMGsRycLeYDUmExYONaOCfq1p6XK/AX70Yokr1zgHaS9YNU9vIF7UNkkF68?=
X-MS-Exchange-AntiSpam-MessageData-1: +K+GtLweHhBvUKAtsjlhyCeY0V01frc7tSw=
X-Exchange-RoutingPolicyChecked:
	rYs6nQX3dQZH9UAe0yVpSrcjSi+x/hE/JVsij1Yg3XAxT6zxpNst6zoLI3pXW8/MUYiTlMaNN3+HFEDaJ+xDWns5GpFe0tvKS3ifeR3US2eN6G8bglTO2AxohblUHKEzRkFq4cPMGpcZKfNv6TUcoiZNPrvd2hS6GLfkA80uvMhW+G8NhfzlvWtfxwe9VnlmzZD0IHYSExXWFzD9I8vC6fx0ymt6ZXl0olEUrk1CZDSDQCBzjaOBjiDKtRYdgotMZeVOPZTovVrZZCPBm/N95qdePc4tXjStkIKRKTC4CLFmf/F/rDigiEMhtfyhFk3TeVfz3EDv71JZqQCloXvJpw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RxmioY42IAMIVS6LZKGfwhF8UMv6zJVgenJugW5Df4S3fUxatCyChxNAm4kadTrTjy2z+PqvFsb+maIrG62YQNAsi9t8h/B+Xk2AZyXNfcp9hpqXm/66ByRj8iNCg1JPaxPQJa2mN84rSPJxvvRbvWv53NlqbA2Q8l4E+UuCO4AfvN80sDVSHyTXfkq2GIdD8olU6NHCIlMSwu4FGLpKlXCYgLGvBWNGPew+Cvy9OAPmomKCiaPQ+2vF48PnjD8p4KqiY0fSMczl3ljPm3xv3OYLMnZB9bXPbzPa8K1mSTTc8q7aZcyFfYNeMhQAKkQjSTNBXkGvaNQRUWCwMHsPZgJEGVDbR9oaNb7VRJc3dHTWckBpn5tqrl05+jFcYy9xKnWHXB+cQOa9xWtoyMgEKKWdk5qHvYEIOzlrCS2082mzzbdJ95nVoLRKf38oID8UISOau1ZlXJ/fc4DCdcYfd3zb0kePeQ23jvsY1i1mtuqgpuBBM0f5Lf09u26g0urB7COtsas4tvfsgmh3FZlnsp/Tqhxwri3p2eIU4r1derhUHFD3SYf2n8cWbIOdkPxRR6ubwAmtaaEpiJphNjqxjqdbibGZ67ved7uU12fdwwm8mnLjxSVC4qL/E58bbZVk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2193b72-fa4c-4bba-8c07-08df29eb46d0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:19.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szC+XhVOpvmYgefN/2KDVrB2stCfMOOFM3iQzraZViuH/kAzIA5shmZq/G2K7ixpXxaMjFrZtaXJxwYjw7XvMjk4J+NghjC/0RcC5lP24TY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

When btrfs_reset_unused_block_groups() resets a data block group in place
and there is currently no data relocation block group, use the reset
block group as the new data relocation block group, instead of returning
its space to the data space_info.

Returning the space first would let a waiting data write take it, only
to have the block group moved into the data relocation sub space_info
afterwards.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index cf3a7f675e53..d5e1668652ca 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2975,7 +2975,8 @@ static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
 	return true;
 }
 
-static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
+				   u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	struct btrfs_space_info *space_info = bg->space_info;
@@ -3035,9 +3036,26 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 	bg->free_space_ctl->free_space += *reclaimed;
 	space_info->bytes_zone_unusable -= *reclaimed;
 	spin_unlock(&bg->lock);
-	btrfs_return_free_space(space_info, *reclaimed);
+
+	/*
+	 * If we need a data relocation target, promote this just
+	 * evacuated and reset zone to be it directly, instead of
+	 * returning its free space to the data space_info. Otherwise the
+	 * returned space could be handed out to a waiting data write and
+	 * then yanked away by the migration into the relocation
+	 * space_info.
+	 */
+	promote = promote && (space_info->flags & BTRFS_BLOCK_GROUP_DATA);
+	if (!promote)
+		btrfs_return_free_space(space_info, *reclaimed);
 	spin_unlock(&space_info->lock);
 
+	if (promote && !btrfs_set_data_reloc_bg(fs_info, bg)) {
+		spin_lock(&space_info->lock);
+		btrfs_return_free_space(space_info, *reclaimed);
+		spin_unlock(&space_info->lock);
+	}
+
 	return 0;
 }
 
@@ -3414,7 +3432,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		btrfs_put_block_group(bg);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		ret = zoned_reset_bg_in_place(bg, !fs_info->data_reloc_bg, &reclaimed);
 		if (ret)
 			return ret;
 		if (!reclaimed)
-- 
2.55.0

