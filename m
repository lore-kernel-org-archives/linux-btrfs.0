Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602646;
	b=jQLAI7qxjL3dwMjaPDJ76wYZLcbNkRXhDwybdFjTBeGWyJ/IlcjWdY6xBaEqzwO8kAVp
	 9QxIxebvxt9z5Nde9/lstRaIBth46Irm0EsaN3u/Pq3lNTnzqT872DcBTzwoDOAdH1HfO
	 ETh2zwZUD3NICmqMNzm1vrvgZs6RviefB0uUdSdtsLIgsoPjWvWg6faI5imz8QZoKMiWI
	 EcaVbljWL+Sx7FsgKalA+KPBGE4CQlwuxrUEABYjSNnO/yB4BEK4nbCLvgOCO8qS+tubo
	 hcZFczr0EmxBF9c/m9fzaeLhCjuJZpx7V+H3yTKTjh5zarLIBMsTT5RVDyuu7qGDq6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602646;
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
	bh=KseEE9QJPvzob9AL8KWrlqbE51rMPXKclXu3/WDBTvE=;
	b=luA43XpOM4jKzrdBE+51sTibI7eYtCmcMv/HfW1wyeyOnWTCd32H0/5BchS8EIbii6Nn
	 FXjsW4RjD09LOtaaWECUESKEXLDY/ofWghSMkdYE61OU0TQaY6dY0O3fFPevrWSgIGzpP
	 HiA4AOQiDlKXF+JYsgt6kouYA6mkhDyQY/kMMPQiozez9PIaDipDycbTjq/WFuYpCKgQx
	 RJ6RhQTWvJsdmWXzUTQ5LNPZhRJ9k/imHNlLUTmbM2/T0CYV8k5KxUKUNVNgnQrxeRK0c
	 UO2WdzjPuotZZDm4/4Mhhw4zeOlAyQ02eMAvzD4aE1A2xQ6PQEVVx0QpD1I+TZeOtXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XwDn44gB;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="oar8/BDl";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEA2606A32D
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AEA2606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XwDn44gB;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=oar8/BDl
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602646; x=1827138646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=IfrcYSqU++urNcYJg9cf/HZv3DMA/4kykxqV22YhtH4=;
  b=XwDn44gB7TkyRoEmo8atXlZJHnU/PoCCS7Xq1XNMc9kkn8s108jW63zx
   p7S2JwTb1uyIfB9EBnrGunIyJiH4HUV6a5VuaPS/5QPOreJ+lxyP/ye1O
   VFBYms8kqauJbSadqhK3TGcfwPq/xTDo1TU3KCtwxemrLp8OWw7UauJPH
   BhqchCx3ep0OMqlOgPboWUgvOUzjQ4UUg10WZhKNqCA4Qa3AbfENhjbTh
   Kx+tlwQbM1Zlt+0Cg4ZF574EUVJKNsJBjvcXcPYbVDQ+a5vucowAjTMXk
   FmWU3MGD+3U5SXW9cg3GTPwSHCu+nrovYEqzq69KCtph3LMkNWTMLDpKD
   A==;
X-CSE-ConnectionGUID: nYqCy+RqQdGRHtbqpxdGFg==
X-CSE-MsgGUID: X7zlCgg1R2+x24sRGjqNqA==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492411"
Received: from mail-westus3azon11010063.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RV/swRZEosqjeh+Q1qr4kj4b65b6Q4fbHPS1ylLed+AUoF6tUQY8wn96MhhQxAhnu4ZFphzYBJh8YFQcXNpn+LzOwz1xuWQz2F5GHm2HtnKVPrUaGBKWuGW+zKshTLt1hktEYI/o4zEPyoNkjKY+AxfgR9Efv6fwLDhLkj/Q82fIcurblDX43JKA1f/jt6UpfoHn/NC7GH/VpE/S1k0YbijygCC3DZXL+zECrE2mrEGjP17Xasjr8OgpGtPZyi6Vxx33STAiTkEmooCBQzRg2ZHT4HnNwg8Kh/u3B6QWMW6bBK2k2dydqxGO1OPq3MAUrmOEQ+yoYWMPI09eFKrePw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KseEE9QJPvzob9AL8KWrlqbE51rMPXKclXu3/WDBTvE=;
 b=EaJjH0yXYtSHWG1UAmCRnmktqE0T5x7B2XDOQZOxiii94Q2Bx4lsw3rFOfay6U5bT+4azkS1/8fGoBy2CXJmWppxsCnCbRHs7ofFy5kgdrKB8VTAummUEtBAIjPpTDmCLrJfo6bULaJMs1BFIoP7atB5yCkNNb03FhtMkK3b73iXuxc+37sbcDhZXpWQ/w2l5JhUItmXcHPqjMFZWtQp83hlawV2zraBdZXGhGnr0hEQPItKs7p9Fo1mVBwrnIhGowvUgkspQm5hnWj6fAnBE0lZ4LJO6aavIIc1A9qGpeGcNG2iYGySqC21t0zCo37NRHImS8QltlmBq37PaDbfbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KseEE9QJPvzob9AL8KWrlqbE51rMPXKclXu3/WDBTvE=;
 b=oar8/BDlYVNEtpd+Z7IHy4lWGHvUHfXxX7NpauyR3ca5txNuRoqyIYCF433GpJI7+0X6afY2lL6IsTyPZuQJrg5zbdsvIBk5vNBYRFkpx5mkpHqE7qaTrWlxk3SeRc2wx5dYcVFC/MyNzhq1vOhm22iSZQX3tiS8+nj+adyWdSA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:44 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 13/27] btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
Date: Wed, 25 Nov 2026 11:29:42 +0100
Message-ID: <20261125102956.266389-14-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 18998b99-6f00-4638-d5c2-08df4adf28fe
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	umuReS/xn9EM4AJLEGBDCb7sr7DEw03KHBYa8cSuP29kHZ1oudvfF+qt93nveWt0TOiuufseYs7st36o4QxhgpF4lMF9fcfLQbqb5Xox9yCIE5Pjyqb70JBhaYdAlUnlOtnNMfmMw5VC8IZTMAeGRQ/CVH5a0BrBNrv5mViDm7iqxtxSOr0v6RBBQcngnCVDqiDZLZh/psasxZXjuP8CVtmiW+wH7bgV0sJnPlDcxLp7ELlbzU7QRCwEyINOwOzQQg+c8yMyD5e5oVNyn250U2KEaiRvZP+Wh62tcaiUI0p4k+L5FpQ2J2xbrBHSB96omhWkyQAx2IUjcZvVPN0JljOy0xULJVpqf9w8oNdJyqHrEXrNyjTFREbWLXBycdUbqizc91PoToWQ5DdoXdeRBnql6CZMbcycXkf1ehyW/8ciYn4ZoCkxdR/Qf5Zr35dS587WXKKZB2cReL7ucTqyYkDWlBSg/2iL/AYuoDafw8rsYmm658xMjUqSpytLHgof2+xmjD0LwnzqusMjUsKsJPJoH1JmkNGzjyXX0VBpYF/IPsZj2pDNy88NpmlSoNaf1YJLq2B11oUIEE57NxNMIG7ITwF5Vj8UmrqFfNdM242aWgGxH/yh+Nu28Z8V4QQ0GO8zUIs+pypinTPQRSogPQcqKLHxbBaU+9Ui9e/SgXo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m1QuC5fwn5i4op9P2xWk2uASRaGNP6U84j/7h7/SUs4I5MmkQ+/gipHRX2wJ?=
 =?us-ascii?Q?bNj4rksXQnDZGbAk92GlWT3giZZP0YJKVo9aDhGBwhb3ZdkZUYMzrJQC1Quo?=
 =?us-ascii?Q?kUdQ2JbuDJNloeYXk8SP5meAAGJl2mS3NIKUFVZEpORzdEEeRiWG79V/t1gf?=
 =?us-ascii?Q?GoTNOdmNau6XrCWeFGAgSPYh6MLHJtviPWbMWSt9pzpkCEOXtdfFpssI60YL?=
 =?us-ascii?Q?LobWTCtWUEEfC22P2NaNHFrtVWW9Spr3+mxG7c6DbGIMKn1DvyUpBjbHiOla?=
 =?us-ascii?Q?3Eza3HkDN4FyaU4tcWXzWU9j2vxocj6L2Pjnsx46HhTp1P5hiCMDxZDNzbsB?=
 =?us-ascii?Q?JxSIeFp1R/zpnMw9DbrAmb9bWa5+liHOKKRktGcFI+XaKLwpLajxw82byx0w?=
 =?us-ascii?Q?VVI8xxlE6dWo8lmTSWlzgPTukJP5h8Hjl0MWNK3Lp7X/yeiPbK/T6zCyv7M1?=
 =?us-ascii?Q?WiqSTERSKbxZAdVzrsx4o1vtI82UpY2EOSZl4X14Z/p6jCBUNytrCdy5rZvG?=
 =?us-ascii?Q?qDRnP0c/caqwSOEfNIaq0l/3OhC2ARbcJ3enH8IvmmXELSLDbUjSTy93C4PW?=
 =?us-ascii?Q?6QXS0WfWW/K8cco5iuzz22CWmNk2IxepQGOgN5H91v/vIkrYO1kfWK6iy2if?=
 =?us-ascii?Q?+n47d+t3AomNq+NPfpYXp7ah7tcF7eggdK0NnGq5jjd3gMtvepM9O4KiGH4Z?=
 =?us-ascii?Q?YTkrhMuYzHthULfz4xvL4wVcxVF/YHZi12vzhGEWHxBCrpzkO01nVy/RGfoo?=
 =?us-ascii?Q?tnkCIkdhSaRsgAqJiK5rc+XeunoMVsp/cqCLh6C71xBNI2/T8pW/dz0oZC7Q?=
 =?us-ascii?Q?xeLTDKQhIvqzTugT4CbwuLhFlLXjR83FAYPjAaKWLd7taH51aYBa83Sx5TX6?=
 =?us-ascii?Q?22q3QLScmLGHvJSgxOdDzUX/1xDnfFiDHB3TnQBmXMyugqgftCZVfVdckMv/?=
 =?us-ascii?Q?ZeYYW5/a41ovAVfmGQGzs/KShJDqc5T0MfXqbDELbLcNiOnSBFv4W8uBJrLa?=
 =?us-ascii?Q?zTLhBF9g29tyinNfshI7gqPvlNPw04y1RfUtLSEHNeUvP9ohEBqSqZlDfnd5?=
 =?us-ascii?Q?MMgkewSVZz9gHcCa3lLj6PDMOEIquIVnQK1jPGb6f4JwRING16ez08ONjdLb?=
 =?us-ascii?Q?VtzpP17I4n6OBSbRE/ZSlc9DsmGKise4JMtqScTjQ50GcfXeLGTWyO/iDN9n?=
 =?us-ascii?Q?epZ8wK0Eo/Z8w+quhzmPH4E8JvtJ5vqE99DUI+Ed2pxu4y5n5vOdSQkAL6QV?=
 =?us-ascii?Q?0rlYzTVme83tfVHzGOJDgfgPFuKNLj89SrzBzIkLackiUENrXB4k9fjbjFZv?=
 =?us-ascii?Q?YbYM3t/OOWp2aiEeiN3WIvSb0J6jqou+CuCUPuxysd72L0B0OIQA4TfRLEMB?=
 =?us-ascii?Q?8IU1UINjWKZAZm3t79S01dIhpbigzxz8n97/4Qf7uN1XBlbA31Y+szkg0vOc?=
 =?us-ascii?Q?ioavjUfb0ROkTV/tYeDUZFrCu2/vgeYqxrtZ0DQf7h4rZ5m43vtW0SF77tDU?=
 =?us-ascii?Q?2r22g0KaV/DuU6Uv3YJ1IZQnSbRltE92LK0Sdvy7KZPfZCoE2HUSEro4oOdu?=
 =?us-ascii?Q?/Ixn0lwRAYJ8IJgwWHTTlOW+1CMSVYf/j1ZUMBveMhy51LI5noOROPq7yghZ?=
 =?us-ascii?Q?3hBN2q1PMJBeoCN0k8TbvkXeqqQkwXguSvR1ia1/7T97AKCg2h9VUQ1viBR3?=
 =?us-ascii?Q?O7JXVNuiqVGrEDRPFc5zNH33n7pt+SrIpjRqjBfs72TBrePEcWsFg+dEzd4V?=
 =?us-ascii?Q?blO4LQlXaQ8RjQy+8fT+nZ9qa9EYQVAjC5xyo7KQMP8HwSIj7jaFARoBBxbN?=
X-MS-Exchange-AntiSpam-MessageData-1: K963TZzRiFXaaRZemorho4ZrwvcVhohwrKE=
X-Exchange-RoutingPolicyChecked:
	YJq40oxcE+eqWt3TtHOc5XIuKa7fwWUYq7/vyq+m5EoiCO8sydqs4bpp/gIISOWIshnez29ZTC4itptCKOztMlUOQIVtBQqbMgi0DYemTvIFMIZWegYEVaQWM2JbmYRvjxyMmO4zqfs1qKbZxQwzDoSps+dhmpaCGnk29oy1yzbV54UooWDQF4y8wbwoHeAtENMxAJVoZovVKAoKhuUmQPxdpDQXTWBsshJurwP8X6xiuqgdqflfyiEPW0LA3XxOUPSGdcVsXeY6I3X/1OElLxuOx5rtThFeNJX3GBmoKeOqBrFPvoJ6YPxnhXbmIDWFglNyhpHbGALkKhbIHhwoCw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wPHC2lemjRgJSQPLWEAmNLMzZ5/Bo7wvlriNY+tow42aeITDkBfNQ4nM7JVF5fc62jU1nHZd7rL1h8akQoLFEyiMvhUHkvuN14j3TxALJnzJuP/HuzZDuNxKdeAJFfwwZS/w84vLyDVgMh1kW8y9ZWVmE8aloRXsqQkKXNl62WHxXpY0nB+jPrYrVHtYAcNFMk8/UlmwGRtg+2V0IwIB1MIcZ0pUWE18CgZrU2SdqHzgjqBO1AYn3zUMTQcyrqMdsQDB95Oa0jhTAfrlFJ8bNAyj8QpFGm5RQiVK384CUdwAT1AZ0q3t1/UvW/lUM7lY5/ziusbIa3lPihWLZbzkIEiWozRsMZtL15sz1Nj620kH6WT1t7lWDRus0CIVZjIsJQvW3WLFUpYDymdjEWJwunTaxtPvAZoCCZroAHCDht6yP6Fe5ax87ds/Cz2/h6coprZ7i1GQR1sIXQbQEdmgTlW0qdVeqzJ5+FgEefQibPNTOMuYPhEve/EUZqf+6cvOfQ20qXc3EVHng6uSd0+rvvbfM9OFo7V00sBW6wCvKka8jMz16PGhZBX1AqfpyTt+E7qhRHXhHEBiJoCa36zH76QKtc5IPrAeGwVTY1ezhz1qOov7Ds92xOG8YSjebFzS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18998b99-6f00-4638-d5c2-08df4adf28fe
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:43.9868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r6wk8QEBIN0pJHZQTOGaoLoCXuGRvS4Cr3PcCBxlb30S0KusldbkMR6UFDvcKGUWyXqT9opS4spyJDWnjR56vc1ECvVSYfdG45OMUwKRdM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

Now that all users of btrfs_zoned_meta_io_lock() and
btrfs_zoned_meta_io_unlock() are gone, also remove the functions.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index ecce74f67a5d..af03ea8e1754 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -438,20 +438,6 @@ static inline bool btrfs_can_zone_reset(struct btrfs_device *device,
 	return true;
 }
 
-static inline void btrfs_zoned_meta_io_lock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_lock(&fs_info->zoned_meta_io_lock);
-}
-
-static inline void btrfs_zoned_meta_io_unlock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_unlock(&fs_info->zoned_meta_io_lock);
-}
-
 static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
-- 
2.56.1

