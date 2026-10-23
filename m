Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792759347;
	b=4i9Rao+KznuqkcZfV1G7pAXZ6DcnqxeLZ9N55+MWWZ39IhNUE94BaKLkBZ4UldYB3fKU
	 ZasCofafDtDlY3HUbhROYMirq0+KbUiaclztrq2LAWzVSMhHZHXpoMC77Q5p18PD0GWaf
	 SHVmdTzI12cB+kDXsFxQVtmpcloCK34bgS0MlUJx7DdbaBSkEBpvJEL598J71uClGDcKe
	 trylO0lNnxbh7UB9PD1Ci+CS4Zpb0u7FH6/RhrzxoE8BB6W/ymYOHV/ZOhNEkr+dBITyW
	 /FB79RoyKRCPGEtl4sPp6TpmhpqAQyALfk8vYu3JKA07ppdb6jqyS2XV0q6AZxQB3Nw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759347;
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
	bh=VX8HdcoWsMwR+NvX3XMGCvngEwM/foALh3Jm+EPkNAM=;
	b=rviUkUEJHSHsA9jxYz4QRKbZTp53/QvRS4lR6KoFjjmc2ISgxZsvF1ZedXE5K6Ho3dUu
	 wPnzoK0dcDL06LVyOC2bzyhitSry+rD3YNDT25iuC7Yk+QUaO9hd9wDhMjBE2Wa6K+A3a
	 f1/nlxQYxKe+MJKeuBX+/K1u56Js9qhplZ3Su+ZC9d1fCCX460sy36K43dIp1cW7sfD+Y
	 5YVrkh4HAwE5kdUzVU7DNUFiLewq/+yptaqTuwxeos6tMryhYyuUWNmUXFYEhx822lWYA
	 zPmCz+xlRSbYB3Jbr4vGjvOb8inOJDDdeREGw6SecnQwVQRxfrb7nSYzOUs3HwIjflA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mN1CSd++;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=T9kIFRih;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A71606A324
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 12:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81A71606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mN1CSd++;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=T9kIFRih
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792759346; x=1824295346;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=HqBp+6J31M94caR2B4LQztgCNkzzZZw81V4ZvOUuaeU=;
  b=mN1CSd++i0fytHXFijvfbQTgnRgJqhnqJZmwylVJE9lrIzfTUYGWUZq2
   qVw74T363R8l6YTccvxiYR3Aooyjs+UZyufVF68NEEck5Tae3NBuCEca+
   N05eCcZ8olqSD2I1eT/R9s5qCyveztGyayMkUxX/97uCCdovTk3+7//Ht
   PJLdRYzq5iTZy5t6KkyjIZeYEDQoSoVuPxxZ7yOo1+NMmvCNWEa5tb4Pn
   zbGmr63GvV1IxJRpcCi1BQBViClElWscxLYLCAsgswsyCJPYJa4ZR7OJ1
   W7BCaHJft6XBBhxjaDx0ALjP8mcg2aRJ8XA8gAj/cakSqtF9Qoq8Gn4Ib
   g==;
X-CSE-ConnectionGUID: N/KTbgflQkWqUyDE6ufs4w==
X-CSE-MsgGUID: JSR8fMXSSIuDHKfb2ExWZA==
X-IronPort-AV: E=Sophos;i="6.27,174,1786982400"; 
   d="scan'208";a="154613185"
Received: from mail-eastusazon11011015.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2026 20:42:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdoZp3BRItX3uto2iXCZVRPxx3jHrBVUXDpEVSzwmlh/TKZVjH0mi4ETsrG1cFmB4rKoZ6nhopKSWvps+3tG0zRmdR6bNC0iy1sJa8qvXZzIYnZNDr74kiiPjDANhdu4xiX03TMkA23hlqINnsGaVKay57qC2xJgQtKcZ6I1tEu0xJ8lFJRlD2r1ZNOSqgek3wKs1ww/C8K/iLwop0rGAQgsZ6L+BPSG18b7V/uHgdPvRFie2KXEGjMhfky7oloJ1bpFU1+/FOvTQQiocMXQSbxbTCtT1cniHz72jJmuWvGYBa3Hnb/XY8d1MAt9/sWlaEBBmBLUlxr30SKitMXofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VX8HdcoWsMwR+NvX3XMGCvngEwM/foALh3Jm+EPkNAM=;
 b=RIMfDOqCRWYODjGwKq0WyqsmlYzaoLcKGkWLtpL5nZtRjyfQe95DteMYEhBjYqp4GMlVmGWfs7tT6gYsDF87eAK/Dso1xZwbS2ARA7ECIEP208bHvivwhpCt1qLtD+WmmVfMQSR25N0TdShIFSyljTzWiOO3YAcVjd0OmAEOc4ZLx3SDAH00r72O8TUEhNFy3hB29MtjZhM6tP0uNi6qF/T/5wuL7aGNKRuR/mi+hAO3+ogyqYNHUk+Ut4Nrt/oZJd1Z98nckQ6C0fE/gSTTX7F+jwXCWQW3bDzZ9cS9vy+hXk/thLUYH4fpX7DqMs2nX4Gwe4kN3MNVIIxbJgsNAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX8HdcoWsMwR+NvX3XMGCvngEwM/foALh3Jm+EPkNAM=;
 b=T9kIFRihKHI246bkSR7vvh5E/9fpv/0FUE86JK8Dm1svD9mmxknkR/Jofvlj7cI9YoBY+7kqfgXAaiXFVplQY1zWb218/qeQgaWe29ZAJXUP5+5uBf9H1WRH0Oo34T91j/fG5aINf0fYrMBpM0xyBQsHRQtnDMVOx7vi0fRzS7k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB10247.namprd04.prod.outlook.com (2603:10b6:510:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 12:42:17 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.016; Fri, 23 Oct 2026
 12:42:17 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: don't wait for ordered extents in do_zone_finish()
Date: Fri, 23 Oct 2026 14:42:05 +0200
Message-ID: <20261023124205.95228-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::23) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB10247:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e784389-5ba6-400b-c85d-08df31031294
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|366016|1800799024|19092799006|376014|10067099003|261009223027099003|261021123027099003|261022105027099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	YDgGsIXI8QhV9EedSGUUDJ3cqmmIBm6ebWzaqmahNxnQtNjC/J/7kmXy8L9HSTnaaVFwhE9//UqWvW0lxMImDmxjLJ3PvlGXhewKhrm4AlqHEV3jXq9aY48cH9++/R+zPCA6Xu3PDH6Z/hxzBqODX7wwt3g4NXl2EloH/Tz0+GzlhnuamsaxJ1olIIvufQwekSa1dFPWlH2JBJoKEwqYyWXlLk/wMMnO+OfM7U4ANxtYcpZvWhkbj+Jmmu7CExkxLfe9ltEYFefCfDUdXQE76W/tD8PysvLL2rSJYARoYrGqY1oj+SxCB+EbHdT89L65CSNq4VfE/kH+lf2SeeBPCBn4ZHRnDSFJXQnkhMJsoc6Q6VTpz9rsYFXCSPqCKQ+tKnjsnYxkLBiEDpTWJDb3wlnxAAhKTYtxaBjxtsLH27zOUoVoBfJXIP4uBE0lo35BITpKLSIrDvQCTYHf2WrYcHxBvw4prUvcJ/FoiL68fhX25kOuvuNWgadJlOreUplGyYJkZlh5rZ8WEhgZDPhJsqJC01FXhkD6VArBbK2KJvNFtBcu6Nxy8mHTG/0vSSw+DhIgfP55qrHE2QwJKzV44mlNItzVEqdeSxkxE99JlhII232Nd3Vui/Zw7qsmeyc6sX4m1uwwpM7f4IhR1EXGRtsAipwn4TFaq97MNiEwxTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(366016)(1800799024)(19092799006)(376014)(10067099003)(261009223027099003)(261021123027099003)(261022105027099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3mFsfw1r4E2Wy9wFEnbnxyspg5ELWypKgjyOYM6JReEVqqdE9NZPsN0ZflCH?=
 =?us-ascii?Q?562F1c+wHKZvVAVwSZnTT/ys/n/uS9parJuNZtkSY4rGo9JfHLzdRZ5fBucu?=
 =?us-ascii?Q?X5bRwBYMMaY0b3arMqWUXOeaTKIIGI9W16G5U0A9Z5pexl3dW/4j3JDtRKL0?=
 =?us-ascii?Q?M/INe7raAl6kDnxIXPGdf1GlK4LR76ryr5At/sVB4lwhFXv4lN41sheNDEcU?=
 =?us-ascii?Q?WepmihjBF7XPo9VQPgsbw+nNuVd3h7hcSxAG80cYsrYzYtVrDeL7kfiAFy2V?=
 =?us-ascii?Q?390N+hQvW5zTLjhuOok2kUqtSORzIANTk8pS5mkuEbn/suFYutXeDHyFADSO?=
 =?us-ascii?Q?bG83aqWdAPds+dfxlQtyxzP7YWTmjNFigWEjp70j1UwhZKW+pP0hEiZhDfpD?=
 =?us-ascii?Q?AM6FEfKDCdUf4A4gIGovpEL7IX5aaa0fq2ViBXFoqLagtg62x0LhJxvzX8LZ?=
 =?us-ascii?Q?ZBEfrGqaiGtbdxAlKnS5KJ9me4B/8PI+NKseeFW2eQlIDJrQtor9KwL0T85b?=
 =?us-ascii?Q?JZ32YC2QuGNbrC56OzBZpIQlni+I6BUL636g8czqv6lT/VtOep+F/Frq5i3k?=
 =?us-ascii?Q?sjrv4YLFpfYQkM/6YUxFpAH4LRTPNqWY2NNCrGlNmPmR+J5G/TiYbLZfYq0l?=
 =?us-ascii?Q?SK0t48mpljCHfG/uoaqcF39biOewihUGiGIwJ35fMBd8mYmd2Xfu7RpENyIG?=
 =?us-ascii?Q?QMHXPT+/mRW8cXjh2+WQo9hQTgzyb2mt8QPsaQUvE4FwoZ7U8Nqfi0yWDyNo?=
 =?us-ascii?Q?RnLB1qjZRxrqKhqnAHsLTAiFtxoDlRpgVy5IQQu2V8eE3sgDowr6lOXAAb04?=
 =?us-ascii?Q?A7sctI1gxKGW6WkBS/8vt+8/H2aY5sV9fQ80Ffw3DSXe2lrk/HGbfEiADQwR?=
 =?us-ascii?Q?u1RsF7epM+Z0ZWLpNkGil5vblbLClwaeWV2ViYVuzQM8RdS0msWZfGqYUMyU?=
 =?us-ascii?Q?J5/b579Z/GWnPp17iYyVW7DGIWradHZ0cmWPj4c4QYmlPete6ybQBBtod+Eu?=
 =?us-ascii?Q?gmDLxPrYkslGuZIMuYTYteyro8b9xfWITLbwL1ikPDO4Wh6ETVZopwintKaw?=
 =?us-ascii?Q?XQOuDFPqfDYOu+hXrudWzdKuheTGDeSPM7SYUp3wpjof9w7Z5cW8SnTgCuqL?=
 =?us-ascii?Q?SGgBplvDhLlRKlvRiRLjCUemIA702qAMuR9AZV8QhixyPfQAS8dguZUTimRQ?=
 =?us-ascii?Q?xOpVX1C+UQkX/HYeaGK7QnZTaSoHrPUT2KtSnet41vDUJlCgDMh+Ot6zyM+O?=
 =?us-ascii?Q?bZ0xYK4o61KEz9VLlsrbCbrBiLHjL2/V6wCQQoWnF+LB4lPnXUX6gb85R7sD?=
 =?us-ascii?Q?979/BJHe15n5XeHbW2NMbFCjIBlJmtY2ZBRqjtv4T0fnkWN9554+bDnSj4B1?=
 =?us-ascii?Q?fgFh6E+uAUpZW30adHJjuUdJpEowdwYjSLneHK+ZJKOqwFjYRHDUy7kDvQBy?=
 =?us-ascii?Q?LUjl7LSgYNBlm3jKQhiOaINDjiqYtiStYigy5ZYXHeslqrJvuBAuoAeRnC2V?=
 =?us-ascii?Q?58XuC79PmlSTA+O56nTC7o+oTPb9+NK42ZmL2D/eKyxoOb+OWf81e8KTEBFG?=
 =?us-ascii?Q?UhJscRkzj5pdJQOyI3EZ6C/IPObf5MhFe9E7UnGax8tOmuHtapRIdvKk5kZk?=
 =?us-ascii?Q?tsRTRb+DcN4tIbYyWVqe1AklNF8bQ7lowJNklb74NpJVbULBGVCTsLZZPVNi?=
 =?us-ascii?Q?LNIjH2OuJjMJys3tPzF8sNbBfula99Trz0odhuYBM5NQZl0ZDy2sMUEOzvvX?=
 =?us-ascii?Q?Q0SF0oIXc6Sbr1LHJtk74xvQI8i5XC3YI8HeiZi+/gNXXUnHQLzwgI76iiKV?=
X-MS-Exchange-AntiSpam-MessageData-1: 9XipmrNaZ70+5Wk1tDpL1Ir0MlcGYPUGpb8=
X-Exchange-RoutingPolicyChecked:
	rZXKd6G/Bb042ug5ccgcNw3rI3SxOQjnnU02SzqQFTqVpDnrv7G2KLApeEniEt//3p95Rbcs2Hmknz7hIP8mKGVJU8+sGJhNZig37VlJQSB1HEDuOD4VnnU26rSxPwXktSkGH89m6xkRD9UY3P+2gQhGcqV61xdzdyWIs6cLPzaT5lXutqA/cyzKwZWL38yBcC5PCyfctjcEVzKoen77OZHjZkcBAjJ1ClqebVN3kRfpylcNTilFMXNvMEdPaJuGO+X4md5BvrUjvLAfFQzCHsQ/NnVCn92j/YGi9+X85mGtWV82NeGlgDahq0jooDyJO9e8UN92vvLNmAISsc+f5A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	isDepeBBLlXfdx5p+0fo+lG7SP+n9WR/7K0Ee3sOuW/mWTY/cP+Cb2lJTBujMaI23m7w4bNJOqOyEtbYuS0HK/krFT76X6oEKnlNjDQMDe7yuuYOpEe9B/go9XV96Ny8xf2fy6tTEJWHnNXLC9UG7GiwIHbZLEVSTsA9pelQf0uGP8D0EkcenrTeHVNchDPSW2mCgN2kUehycw8NSRLKLfH80bLdXixQvZe5FAnLuxzEvSE/VdXodxSDnxcM3x/BojYSIISEfMbA2ps3vb2a9FmyvSIFMWjtt3ROu8ey2Z9kLCOgq/HUhSF+dwtxXuLQbHp4CRvWK3QTCgXx4XinMng4eN8hHBU6uoEbBT+SzDQ5d7A0Z/BorCkDDII5at0TaJVLNzE+tKbgVVBC4+IWZuXUxlxeadXuYzo7fj+ZJevStsR79SC9BpUdP1OGy/2dH4GzAmj1IHZNGaZLAdtNB2hh3dMEqeP4jVTyO9kgS/SWlzPvu1I9nmusHStFbSjlQuZmghjz/VUbT8BLmqNzn8WFO69vPnl0dYliL0rtjOCmx4kkzvn/lES0ozkXpNaw5vAS8ZSu2GhjRpIFCSqW3TZNeyjzEBmuS3sJCP5A7cQQrIi4G7vvknoIZ/l8v8g3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e784389-5ba6-400b-c85d-08df31031294
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 12:42:17.7239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9Yg9Shirg1e1ILLnh4qsyUgmPL7tWjGEWpmgmadoKVt5kUBtQIMc7dhdEsfTSeK/Np83d7wCvHmjiMzWf1hr+oB6LVC+GykkH1idz3avz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB10247

do_zone_finish() calls btrfs_wait_ordered_roots(), which holds
fs_info->ordered_operations_mutex while waiting for writeback. It can be
reached from writeback itself:

  cow_file_range()
  `-> btrfs_reserve_extent()
    `-> find_free_extent()
      `-> btrfs_zone_finish_one_bg()
        `-> do_zone_finish()

If another task holds the mutex and waits for that writeback, this
deadlocks.

The wait is not needed. Once the block group is read-only, ->reserved can
only drop, and for data it only drops after the ordered extent's I/O has
completed. If it is zero, there is no write left to wait for. If it is
non-zero, the check that follows returns -EAGAIN anyway, as waiting for
ordered extents does not run the delayed refs that release it. All
callers handle -EAGAIN.

Fixes: 393f646e34c1 ("btrfs: zoned: finish least available block group on data bg allocation")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0735e75e90ad..f5b7b3334f06 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2604,8 +2604,6 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 		/* Ensure all writes in this block group finish */
 		btrfs_wait_block_group_reservations(block_group);
-		/* No need to wait for NOCOW writers. Zoned mode does not allow that */
-		btrfs_wait_ordered_roots(fs_info, U64_MAX, block_group);
 		/* Wait for extent buffers to be written. */
 		if (is_metadata)
 			wait_eb_writebacks(block_group);
-- 
2.56.0

