Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941975;
	b=ueskFaIPmfySSxShJMpZP0NaX9W0tQA/l60/2syCrjTUtFlZwJZ45mngClqkS9KqbPvu
	 XwyMnXa5XxjmvOO5ib1VgP2T+uYgqBgeMVqAKxcqxNx32Kt4qAVZn+M8Zu0fz/9c1cZdK
	 Yrdlug01SU7diMLtBSog8bYFpoepmyUawr4li0t/+6vSj7gyxp8C6mhxLZ6xgBSWad3Sf
	 S78yMqqMoOugFsuUFSZ0feGiVRJ1iupCxcp5ExHLxEtE7AnZ1jmt41hQ3kXoKLzR4HwPt
	 C5wwt2+sg64d7lqe5bhXq8w8ntlJ7dERnXVYuPAsrYlgAAPOsP8KoHvM32RrNgZx+Eg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941975;
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
	bh=PfdUixaCF8oVOTP32r30uuMdqiI75i7XkqXP9C7oDsg=;
	b=Vqm4WFj3+ceoof8A1rUGS5Zm6djbWwwPNX7oCh6e5Dk93iW0UqtoVzfCEgF3jABiFHi8
	 QSLeqoWdH8oIMDLKmqcQ3zARZpq1fC5/csR6j4v9h81O2W5AZRp767w6F2slcWUcv51Rz
	 OCQUxtWBmmLZtwRhDgMDNUPh5OYjxzuSebhjr7EPGYuGMRjoges24Vrppcb2nsv1IUydr
	 2NnkmHNuehCJAB7eFS1QO3Z6PkEwCa7h+x90RtNEfJsDLkwYCDlABBZGRWbScGq8JaoGW
	 yDjIdeajt4DhE4ZY/3SfRPUkiWNVKL+6JpNnXO0h7eZLUrnnlj2nJr2mu0bm2QtAD8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pCssYrWj;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=xF0fxGsf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94173606A32C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94173606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pCssYrWj;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=xF0fxGsf
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941974; x=1826477974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=knYpEWRNOQZATRuFpQ3Gz4Q78leMJIK873nchUMHty4=;
  b=pCssYrWjjr22E8QBCZcZ8yTCTIwomaP4nGs4pOMkC5BS9ky36EJXnaN0
   IlefEOsIHTRDmHwIZ586zGQfHVY2El+EGRJqlCilSQ3UihhudVIvw3NUA
   ILmd353EycyFm+dJ4CYrLzcp0xN3zh+hnDgaPdUZDWpNmBx5jShrBJG8n
   Hy3b6rosynDlMydO2F89aS/j9ntaxkR8mONasNiJvTpi8FZGCt2H+BXHW
   DRug0cwYfMDGaZSZcRsR9uX+UlWqkud4i/10KDXS3Hcr5fLiJcpD48mO7
   POrIZzMrF+ajw5tD2+Oc3YT0keA2mrlvASZxYtnsveogw/4AONVM6QhPO
   Q==;
X-CSE-ConnectionGUID: 6ueHPrbNQsumSsqFHGXJIg==
X-CSE-MsgGUID: F9mvrjcIS7Ogwj1vEy5wng==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156880120"
Received: from mail-northcentralusazon11010029.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nDKUlDG9WkfqwJ3Hh+zIpf9nvq3eFDafYsl5VNfN03mQ3MatF+sBh15CBc/f6V+qJieu8Jx8/wjl9AR3taBD+nsCgrpIFTon6eA0CLhZYyaK4AP83e8ywRca8Km2+F1TQF0ufp8D7XM6DIHS6KU4gXqTy+nkVdrANKBzIO1l9+vK8kD+K4tLIws4ZwKnu7qPdIWFw/Fwf3Gh2lPVqlgIYirdv/iJowW6Fb88xRvpVB/BI9bi8kZ4n+hanydDdSHKS6EMhzgP8hDzkuLRlRXHByZbZl+3lfcaYV/hpKBQuWVG5IAmvhrgix8DDph/YTvr+Vyo5OagJ+0oxWiOC2JdOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfdUixaCF8oVOTP32r30uuMdqiI75i7XkqXP9C7oDsg=;
 b=FcdiZIBggH1Ok9qi1GtNqtO/Ae4NIylPMT4zcgBPLCOFlySdLVPpbjwRvrQT3vsJ+dFIUYX3htcwT4FTsRATvuQBswnKi4hBrB6fmzQU5g1FeBW4iaVYnYyv2n4LN10pvoD5U6hYpUbhwwqP/mwYZEPT5Zg248SCT7fHsQSFK0BW5u2ePxDMbkAvkgyM+aiAks7FfG7gulCuzFKFiGJw9gMrycbudhD1TWOfauBKbjesEXjpV8a189FV+HanidaIzMaFXTjBSgHBZ9heh+zcGlye8gzradtW2ccxf2APjKu93T96mFIksK4Zfrq8ieaQepjA7R2r+k2Nj8w5aBR7og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfdUixaCF8oVOTP32r30uuMdqiI75i7XkqXP9C7oDsg=;
 b=xF0fxGsfahK9zBUAoKeJqr49LgXT9CcgVputHdDDQstV7R5EeK2t8S8/yPbVtzOO1qS9yuTOJeCu8PQ9X1OUyhbGl6Vokl3j6h91tBHM3xNgB1k+FnRVxOLmQ4OzaeU8NswNDkNpl3Ua8gafXvpzeOctc1YZmKgGeirYHbwNC20=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:22 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 06/27] btrfs: zoned: never activate conventional metadata block groups
Date: Tue, 17 Nov 2026 19:58:29 +0100
Message-ID: <20261117185850.4128157-7-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: a9e47595-757b-4f0d-e4f4-08df44dce465
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	wB80eBmNoca+37m8Qizh7Gc/whvye6OYL0H54sq8AIGFf/rqgSv7Z9UYcfIe5hb6lQpaaKSc7ee2sExM9jfXD3ZZtBOl9LAb886FZ6gewyjoGZ1Q0APv38gHX6w3a3qXJBl0QHJhasOMpRvoKaMW94ukfD9r4c9d3e9Tl891omS0ABJNoMATPsIHBUJ/LA9EhRYykK8TFdG9CUGATO45Psn71nJA43sxHLEpzg7U8WyA2GmnKHLGufR96lOQuSNlco3teqq18ctFnvmjxh0mnbDr+fV5bjrfWjbw4PqIaMH0Ig2PjYXzHl/Kp6ypYoeNmn7jyL/zP54Iyyw0/Men0emTWe9FJ4AEL3QCOueY+FiwkV++tg+U4Ink/SI8wOGluk9vJeIhjkzmTsk8wHHRkvf0yyY536xVEAnoAnJddmbWmxnMQgJLaXn67xqDUupKIosaM509ghROpPNboPCcCKKRV+ERGOWCN1VkVUaegEeUAy9+ittj6YZ0+nu+cxzR75xPdpQFMcn6qGU/PO7fknynvGNXO4bLe39g+lOQUr/Aj05cdCTySW92WCkxcBSggKvhpD20UIHpJ5sQAIfwH1byswndh0D8+PdIbUh1HecN0nrTerDEzUoVBUN4omu/dC261NDnulOpRRYchT8lM3nrkk1A8cbKz5PNALMLsU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9nUSyjGwipC03tdokEmk9490jHtqStbxbqLxEW0MMTF1UJMJlp6/bYBqn762?=
 =?us-ascii?Q?3U/yTrX6zva7v4FYej1945AnsMHUy/m9JLTSyVsiiEb3jhBhepsbW14pWf3/?=
 =?us-ascii?Q?szM+9lTkT57l8e9O4oYgWhqAAvUAGj56wLlsLpK9ppBpqfINclvRHkyHpd61?=
 =?us-ascii?Q?eJFzbmkfhGfp3Ivgw7w5R4rTDgpmhBHUVVBNA44ggJ4knx11yNhIidJFkZfE?=
 =?us-ascii?Q?Em20MAa1GOco4GtxbnIbiVnBLyvpULiv0c+TYYTcCdH03VjlKPgWHhq7WOAf?=
 =?us-ascii?Q?kbxwXhE9g5nUKaWBDC/7XusshKZT5EFHHscDVoqWscHvznJvVCiaEi7YFvjM?=
 =?us-ascii?Q?GG1yrdAuucvl9R2iuw393r85vuGd1Q/bvMlCZ3YoBhTIsunpWCfRp42tpjlw?=
 =?us-ascii?Q?z1UVpWIW7Lbp6B1KmCYq5HnybZMFrTVi/1R/xrMI0xYnG1M1oNiKyIvPcsVk?=
 =?us-ascii?Q?id83FVpIIjCAxxIvvZ4yUQVCnWD6rSCs2X4T5aPos5SVi58WBuONa+FtUVjq?=
 =?us-ascii?Q?Txgstl3+tTUqd99NuXtSFrjmvm23CI5m8DvyK9ygSfMzgav3WaH5TxIqJqQK?=
 =?us-ascii?Q?5habjA+eaHUuBGAQ28X2rQRLgi7/Xu7c4AWZV0hwdwI7isbuhHU9rVLLbUcu?=
 =?us-ascii?Q?ixdieFtJIb7P9PdLq2xSqC59SevSK8wZvpFZ0RMlw8XRf969ZwVcl/JIPQV7?=
 =?us-ascii?Q?sgOTYYSgrI3tG3e6ErD5tW//AJChjeDc5KQ5u48vTo/z7jvBKC08BZKw+FTG?=
 =?us-ascii?Q?7O/bx0JvWY+YLCy7WdxSgxZcHmH3PYQGqfme9nBtFThaOlMh19P7lWc81wjn?=
 =?us-ascii?Q?mXr1sHYKUQZ7XylDaP648D6odOi3N/6j2huJjPMrsaBppEHctZbWOfJLkwbo?=
 =?us-ascii?Q?gMX85jA+hhGuX4q8cZvDJc7rho7cXUdMFsvaMfXt+YntHw8A7au8gU6Ev8up?=
 =?us-ascii?Q?1Yt+NyaBuYApIgB6JqV1TPzdOdgDVEwYgLHAGTYhMYIodNYUGEuUdscPnYGb?=
 =?us-ascii?Q?FJcRCMDDyKICHreVGVj1Q0wafbfoFU+MhkZT2R+OvJUyWX9q2qWDKobvLiRE?=
 =?us-ascii?Q?XkPXO1Goc5YcKO7pJF5/GIofLfya4CXOqqK8+TOlsh9Z0btK5xTdPijs3o7H?=
 =?us-ascii?Q?nRm8nuHoY7P8dMotrSAXmzL0sSGbVV9W8Yx0IoN9H3gk63XkYJ90Pak1xEA3?=
 =?us-ascii?Q?nJVu1nbpDg+PZVRn0jZEDyyVrhV+e8UGcrUR08EXdhW7iQoaks1juppJFj55?=
 =?us-ascii?Q?Y1KkShNSVGOJNMsTH9AbVaBKVN/wr6Vn15/+pEnz5J938/5SAvUj60YUDozA?=
 =?us-ascii?Q?7MIBNaM+ciCtj3UF17cbeUTN6roKWGa/xP9Qqi22vABFDEsgsNNTEv+4uBSJ?=
 =?us-ascii?Q?e4jZVjfCi4wkukmt+kdp9ij2C2GJETiraTOeCARUTIAToX+ENasEnFKdkwF9?=
 =?us-ascii?Q?Bh/l8Ga4GJ54t7D7tk942ZWsqx26tSZGw6gcdjsiPjbFf+11R85u8wDhNq6t?=
 =?us-ascii?Q?Rzf+ymMqwKqGDxFYWs9U7S3NszIcforNLR+3/HjSg/G1jdGI/HepzZ/gSefp?=
 =?us-ascii?Q?ki+D35i7tejiKkr5vD9ZnOkBI7n6eo8tdEqwLJD5sWvW6Qon5imMNDf+EcBy?=
 =?us-ascii?Q?JxLJvnSNneGowsoHxEXa+Wqkxg4Ssqx4KFX+gQMy8n60mp3nEN6dE5D7X5hw?=
 =?us-ascii?Q?xyRLRx2vazhhEMLyXhbQGoIVIyi4LYosd/74k5SXJhFa5Jso0GeB0I1kxJws?=
 =?us-ascii?Q?WBaXRD2Pcp38CYdvdsv/Mq4S1KXtr+KdV6uP+cRMF/Bo34tN4N3oeLybE1fY?=
X-MS-Exchange-AntiSpam-MessageData-1: tXDHjrVqHDzQbB52W4Ey1TzMclKCaeR3L+8=
X-Exchange-RoutingPolicyChecked:
	TcMJhP4hJxbG2suUPA+8vZ6yFk+rHDGrm0+xUue1nSDDWgbuU+IR1ms4MKi7SvCD5kPlv6bF51pc8czbi9alLmL8Wrm0SX5klso+atH5Xrz3B4tYFO6g2StorV99yy85KOIm8FlDU8QGr+UB5IGgYFHbRopZcK+gxTP44LouwhOOJP1yu2+14QEXAYid1jCDsnX92Z0TIHzemCXxYxMLeTkNW9doVcz4PpE858WCDKLXZxVFucU9zo9MjXjRUIUvQu5XXA67vn9nixLGGqoIRFEJz+zgI4HXjE9Qtpy690JWHl5H4Pp7qIm3Y0KZnU5Vr0Pfl9o27kBU5AnjFqNLcQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gt2U1GXkBp6cflxvvDw60NUTPzQfDvaTg/edwevx0+Lt49j7hzK27ABszCHMRU8ywlB1QMiXLkCSIqKCKSjlIfYOx6m0aJDAIqZ1o2df3iqGLsL2V/Zya48R4etJDIlamEApaodwa3C3ToypgJbfPrdiBjDwJZ12i5WYT8l+kesVzBjYPY3TD1aSBjyo+RdgeropV8UG+Ut9uiCr13GLwHScCubjZVxWY9IaiVOkGzCbR+gEh1Kg9GlDoSg002wrOa4JBT/QGOYpMeZOIuCnWHzR+wOo47vEapP71ZMBFviQJGjAkV9+zWoKzbkT/x7EruRFI6rQGeXngJxyy3s5/HgRVOqNg13SC4DMj27WIuvYCW0YEidei6y7XvwlA0nUohZHdfhzUsppZIv7fG/JZutu85yfeDDOvKhfeerfm0OOvqulJAHg9TiE35hXCE/IhMttKNH/87u/u13qzmF3w5x6y+y1tkbjH9Bq9Rkwl25MyuWgCYKgVPqcazrKU0XDoPiBXVyMXEhhv7xWlpghW3KJpDydh5EausFvZgLKNWldiXw68Sn8ULt69wyv8Rw1bXwES6a8C3kRkF/17G8b3fMh5GuEtilf/x2yomq3vPVXle+VJ2F1eId4eRNGEesv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e47595-757b-4f0d-e4f4-08df44dce465
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:22.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eInC1SIbCE/Z7zNST1PsbX9/A1Rkh86JvlcxCPPcuq1xNHrPk9UJj5hArzEIXN6Lpqx78tr5/VJp810RA0Cbn2yx1qjd8wGovj934JbqVjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

Metadata and system block groups backed by conventional zones only are
written in place, so they do not need a zone to be active and they do
not consume any active zone resource on the device.

Make btrfs_zone_activate() a no-op for them and skip them in
btrfs_zoned_activate_one_bg(), which would otherwise report progress
without having activated anything. The check doesn't need the
block-group lock: the block-group type and
BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE are set before the block-group is
visible and never change afterwards.

Such block groups are still marked active when they are loaded. That is
dropped once they stop using the append only allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a8762033e44d..bc83f4a2577b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2463,6 +2463,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -3127,6 +3130,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
 			list_for_each_entry(bg, &space_info->block_groups[index],
 					    list) {
+				if (!btrfs_zoned_bg_is_append_only(bg))
+					continue;
 				if (!spin_trylock(&bg->lock))
 					continue;
 				if (btrfs_zoned_bg_is_full(bg) ||
-- 
2.56.1

