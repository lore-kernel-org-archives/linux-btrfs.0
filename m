Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795699729;
	b=nR09D5Y/Qc7exkXFEj4sxh5UMd70k1dJ1qvGhQKLUqIpCWb0mA+D2fjcJzlMy67YSa0F
	 GfBiXDrTSrwOTOipqUqcM+MaxpYy7V7AsnGxUEL78Xv7HHEc9c2b952byILr57fE2mTQE
	 c3aySJ3vDb86Ro+arbyUaMtKCnPtS/4ivvE2ypoXjp+IywDGWOUMuBgtzac1oHhQcerEi
	 LnNtlUGDgDk/53kGGzoWkAdLdyIILP8ge9v4VSFxc7Xw8j9wSBiBGdBjp0E5FHdgpZTgb
	 dFwTs4wXin/9eZ0GlWZ+StlXWWa7erk7zGR1KmTxEr0oxXJJrN0mIQNMzJOqp4X6ZyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699729;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=rf7+PHuoPEwVnUFDqoxuKorWOnHxptspk8dhQpno+6Q=;
	b=Y8ds93oli6cBsS/mwwtm0g949iOtZqwdD51e9S9X3k29JKrT1XAFyYHaFcv2pN5IPs0O
	 0N1HPsbVkEedul8ksKa7OAjEO1q+QXC+wmS4HraMi4uHytTmdr4Ps0DhSn1JeDy8r7TsD
	 Ri27XD+x6ZK/Z1uH1X4Xv6RLPdqGI5Du8pwpRoDeQobUSBdLKnpoEd3QEmqljyVU4KHak
	 P3TIP0rKIjndE5Su0V1qgLFsIjVj6hJAeY2pJzzmgnJvx7qaDj//gEso0mkjSBTSmzXhF
	 bCWFXvuz8DGFMqoww6BaXSQiBWd0VGgQPQgxh551W/4ekl56WRpB8Yp3ra4KiAyo7CQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QU0+7qee;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Ls3axXT5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3217606A339
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 13:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3217606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QU0+7qee;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Ls3axXT5
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795699728; x=1827235728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=75gkb+MInESadEdOtaRfuK8ZXkb0DJ01TCu3QW+rPbI=;
  b=QU0+7qeetnQBxPtr+j0IazbbBCvi9zowykbe8JnVX+BYOSgH8H4je3xE
   cs10YpIIlwXundFn9g4DeQsk6vwiZJ8GNNyivofhb1ouZuroh9PblK5uK
   tmMmpacd7lskcl+hhUBE7wVUHSq6YzuCmf3caSq7QWI78KjtoqfnKF1rb
   2CUjxYIE/xehAetRdlVeK8vn7cF/c27zzvmYLjbarnfh+KffU9L97/Zpy
   xZ6bQerVgXX2PlD2nfIgsXOo0NjTdy/KoOp7/bHRk5/ddk7Cf5D+y3vhu
   bq746R35W6mv7bJqQT35ps6TwsVVtF/69kbiTqb4ycIUEXweGs+6aLiCV
   g==;
X-CSE-ConnectionGUID: Bdw69AciRz+0u6sxC15Y0A==
X-CSE-MsgGUID: g07D/vTQTQuiZKyaXdxLkg==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="162817786"
Received: from mail-northcentralusazon11013032.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 21:28:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpbSiRQP5fcp23suOJSD7MW8PURjW4FjAKK17WGDAaB4b/HoLvYwy2TXIdCSBrKHSmOnRmL/La0j1wBfAwBD6bg6U6Ygqff3Xjs0lFMMomccuH3iJGkjya002BsgMxZbQjqQQ6S+MSGNwqVAIbYG1vDM2uP/1vdMOIKlsjHBu8db1mmCPSTVUVAA7PwsDGqcVKMWnkbsBOE3IkFl8m0HQK4cF0ruvUPBYwjeMYjA9yYdyJ0CLAyI0TpnClv9XOU+GvOO4v4zRvTVYBTK7AFIBZF2Mfd4b9GHoLG2rj10nhjrYLrQEW4m8h0k9p0RfORmul7iYro/rSifT0LJ4nRNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rf7+PHuoPEwVnUFDqoxuKorWOnHxptspk8dhQpno+6Q=;
 b=lruJIV0biC7maRc+xjiAPQStMk+4mAlxikm/c8Lwh7vPOC+zrB/kU37MbFopSuCKDDAidqNNzuJy2m2tmOM62OLBGVFXmsWJNwDkKfL6KdfPMSjjAK7IXvDEc+8K00Vd5SfcUHFksW8hFBH9gUaxh3GBVPBbd0jDBnL/CUH3o32qCrrqSK9kRQb4JhapkcR3yw4xgeR9U8m69qrU/BmEru/LLuvNqsKWNOO5mo4vkmK3b59XiAlrBB9NKZzv+CV/Nd3jZKU7XQ/DEik6XUJmA3mfqTCr8pwsKp9XZpzhmp2nmeygqGeQkwxGghP4L3a02ue9OFvii0IWf8hmJMem2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rf7+PHuoPEwVnUFDqoxuKorWOnHxptspk8dhQpno+6Q=;
 b=Ls3axXT5SDV9iSWBl0M0D1xkttHuQf7pFkdX7+EbiiLVtcHECkY+w6MGuMTXc82OWocBpuajQdItP2m6Zgoe94gg8/FTEx65N+559Il3WU+6+aAFZgCSh82ERtAq5C92lnYdf2PrUGgkI/xxpYCqLfiS55eakzl9ItHmlAHmfb4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9155.namprd04.prod.outlook.com (2603:10b6:610:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 13:28:43 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 13:28:43 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/5] btrfs: zoned: save last allocation as placement hint
Date: Thu, 26 Nov 2026 14:28:17 +0100
Message-ID: <20261126132820.570379-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9155:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ac556a4-af9f-4a78-e943-08df4bc130ce
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|376014|366016|23010399003|1800799024|261009223027099003|22082099003|18002099003|10067099003|11063799006|56012099006|261102123227099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
 na69xp/tJgGyAuzDMMlNcNeq4gpOmliSkv/TXP5bMWd7EMPkownKTGPTSIP+WGRDGCokx7Dazz5kM1muU2kT6rFgwqHRZu6d6xmXK9JXr8qfB9CpdpUkafp/Koq6IBsi/tyo+WUUuVq7w0KxvAt6RYVGkBRWXdrNhkncXOV1QMJconX/+nybgLfDUvEU5YF5ZjjcTjG7omZPmMmIXJNm3MCVnHToRhyPJU3NTi7LyUrRIK0mqpemvoDm38+WZBbLv+ztLgtJkFSkf5rwS0Jxl/QVjPXQ1k7OI9HWLwjCkuizASNZkRKgSFGg0a7JvyvCp3jbzuKOJrCOWfdCnZKzqMZem0DbxKikJWwukxNbWgCYqxl3T/EPNSrWicKqrI69qpm8g//lHVfTmqwAh0rm6kgBUlwVQG8vFbWb2Ku/Giw8CdmlTOYI2UeRdi7Ie6lQeldNG9YpJSTrF4zISZeXxm2+jym81aCDGlkAbivQQTM8hcuGDL7CBMYxUOFGzZiyOOA9Xc6u9PV2udzgbPA94hDNUu5FLO8OAEvLz8lpXHapzj7sFXerFD7vnNPvRD7/ODVPAKFYMTqwu70mZQS0Ur54FE4j+62+vEeNZX2P0gvRiFXRvRRoljYZNCOifH0LfeJXypH4aBcuX/1TAU15HGAd7aMx6ppXkoxFqJnz7h0=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(261102123227099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?2U5LIkBP1oD+lZoxrx55lLE6KRqT1xHRLnmo+kzvcB1/gp2VfjOREUhyHw/2?=
 =?us-ascii?Q?SznghKvI6agvnDHDqqe/Z3+brsYKrKUFvm0kyzPHmt8+7k/s98y8sDX1tCfC?=
 =?us-ascii?Q?Fmnynw7Fs62JW34yW1x8nKTj3a1n75AY1iZ3z1VJCvXm57Shh4iQEnK90mS8?=
 =?us-ascii?Q?pHArapOc6s06YaCN9iKDVv4gvESxVteRphIhun2JvQsL/COmzRxcFefxH+jF?=
 =?us-ascii?Q?QabAdRX/PZN7Ah7v83plrOZAmwjkrBEirFMUtqEUsAbFdylAp2NffAmg4tc5?=
 =?us-ascii?Q?Gk4Jdydo2Sqky7zOYeLk9Bb2jCLgxjWpRAfR7VoXfHpWqqweVQTovs0TxcUF?=
 =?us-ascii?Q?nc2Mepj/SRRnBPTTTGRtLNSmu9zAn4kJwcp8fWy8kQmyFiIB6yU9EmBQN2aA?=
 =?us-ascii?Q?o0DnBlAirIcHqpZtPcHYJeIlRawKd5TAa6LPKIJFDdTfL4l3VX1cis5RjPRI?=
 =?us-ascii?Q?nidYLlLauZqWI4H7k4hSfyngKgCXgDFZzzcvUmFJ+FGZWufa0SOhC8Lpeb9c?=
 =?us-ascii?Q?pYnUt9lC5L7ALqVlPxkbX8knrCtPSBA1axdkMs5t7x53zXo7E3yoWRtdHKny?=
 =?us-ascii?Q?3m8TmMg+IjSWX7uaEjWQZNiDQeT/CBNt5xx5MdLOUlvcz+46LcW6jRFGT9LI?=
 =?us-ascii?Q?2bsQnoI387jk6jJ3ofM4s/sveDkXkO8YyAsuXlYQNrfAuo/X7v3sgF+AuzZy?=
 =?us-ascii?Q?6IC+IFwsVMByVxbe/qXibB+l8eUbCZEKD9ifnJG2hmh7iLcpC9ojguDcZtqC?=
 =?us-ascii?Q?xtbc0F5kLwEsUblDGzxI8Jk0SOmcsOjiqP9WpEByzwSGvhUA8bHIikZF/GJd?=
 =?us-ascii?Q?jn4ukoEAG0jM6q6lTO5BPo+sewtr3lEwRiLmKRJEePVmdee9KigkRgn+H1mx?=
 =?us-ascii?Q?LCj3Mv8LRcKj3/gcWFo+GnRYJcvchesOypI8Tt7nVJtVE2JuJK7c47oXMCIb?=
 =?us-ascii?Q?l9YNVbGi14YOeEZWIUsYtu1PekdZIH55VLAtyDNwMP8n9N1Fl2eFk7FCthJT?=
 =?us-ascii?Q?e6kpYEFdV4RlIFOhi2+Df9KXmmVxFs4XEwQKZDFUeJwYA/2Q988+rE7yGlyX?=
 =?us-ascii?Q?eZygOkZsmigNaBCEwhYmlC87z2kxYs2weozWucIOXvoZVFzV9bhxwbc8uOg0?=
 =?us-ascii?Q?3YC3jNEyuXqJ543GL35Dn2WdXuiDIX2qykrXOgwBE6dcN2ToCYzBG5Da3AZ1?=
 =?us-ascii?Q?7uax8HYnUaqozy9KWdSOmU/i9+nZuRtHYiZy9/BFVQzvBpVpdaVUQpC+hW+o?=
 =?us-ascii?Q?6dfjuu5qUa1LG4GlmjEJGfM0jieuyZ74CwSgbkSwwRWvSlBokQGBTWlfPW20?=
 =?us-ascii?Q?4YQ6UEZBTZ7NuEUK0be/VL9ZWD6z0fH8FuQbQX3359epdyiPlAqLIXNTJ4Yc?=
 =?us-ascii?Q?yeUTSJg6L98gnj5+IfHe+xgtUs4Idp7Wn03xGlSVvSVX5VN6LaWd9dpkD4UI?=
 =?us-ascii?Q?5wfuCeZHHRvi2s/vtGKyQK78o4ggzLvgvTamq0nVqYYy4FabduMy1J2x/j3K?=
 =?us-ascii?Q?CqeMMO6ppANAkML4plmiKTsY6sdhBcpd+1cUTO8As3hYc2g6w/mhQOTZxaSM?=
 =?us-ascii?Q?esCdq/f9qtZ5sWJGDc3SZlvELg7Ao378HsmgfWx84BnRuGGpjMBjqOn1Sskw?=
 =?us-ascii?Q?/aM3jVHUQWu0FFsY2r2zhpxrCO0TxHSvoSFDJ3/lHCQui29XaYI8VJ0F03uG?=
 =?us-ascii?Q?o3V3Wn0Fy1kJbgrJs2eWyPIheggxs8jehSCbS3qc6CfRCiS3VLBYkC7sIPfP?=
 =?us-ascii?Q?w6KGcMZ8mqRwcj4ewrvRQo7oJpE9cK0tzfAAA4QMNS+hQ+urwztCvwS+SvX9?=
X-MS-Exchange-AntiSpam-MessageData-1: hZjkYEc/G6YOL6xIcYp1+0t5bSeYypKgUJg=
X-Exchange-RoutingPolicyChecked:
	R6aGY4rMCo3F/iSiNxZk34jEKhT1rfMH3bpJD8eBijYQMe60HqlLsrt/ARKznuDTsBtkqKP7b8EpulO5bYuRsJqWTgDdtpIxbrJsQWgGsNToJjaa9LNxpC/EMg5Eu3vg2Ny2RmW0cregbvl+LklUYHPIYib5jf50uMdDE0Ff1ZQL9OHD30iLLnvkrNuM4p6PhsteQD6cVsVHE4EMilwGgl7iQy4vJXOcEYFWEwdmMHjumLY06L+jgnjCFdzFT76sv4Od+XJDvHfJikQPP245SeCGV3RMYMBAabOiKr/1Imt7cZ7G//B71by6iCa8tRnlNzjDJtNkE1PUksmNEiyVFw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ef3VAKFIAF1Pb8c49tbPV1fQBFNnpMWN5IPgegEZVpKID8F2U+/88NvRSHxMJwTP/i8KZpCQGBLHVIYOK5dHqrPdKSme8CwuBfmlFJ9oL3l0IseObIvcJbBvdPuFTf270nwj+UR647J3Ba2st9w6+2A2ry0/envyZflVTc3V8Ywy6JJUV/YQN5uFzbiiAsL7Y8GQ2IeXXcbtTmOIxL0gQe4LF/yJq8BpiessA2B9r/538cD9Hrdr/8EHuQN7YGhG/+oIuI3nai9oifhFl8QKDAXBbTwcObErB/V6vp9OWHkqc31+2/3fraVKOUQO4AbTrI5/7e0UjYFbJLerjRJ8yON4nKIsscdGlADEydkyaZ20Jy89LVBQduihGLDjUdo3x+J1/gINOpFSqHe5Ow8G7TIZaVq2g5wvdyy6/qAXfBj18NYE5qX+Ca1OkfHkfQFIIpvWwwF5I6iC/1GEzNVJ0MYCiTYZ+7nWQWtN4a4nk3OIFEiiWpwQZ0aVqKYF2kDJ1nedPk9wlfVcCYxuFUpL3zGFCZcQ6uCIA47RMRF2db8Bjp+Wn7+CuOHTsQxkFlQUfFMLk9Xv+lijfQkVGsJ4b794snddPdJ4WE/1os0s4UrvZzHJsZA3Xj64mB6ZfHmE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac556a4-af9f-4a78-e943-08df4bc130ce
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 13:28:43.1488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmeHh0BSKumyJKtR7wagpRJxFYTpq4Qmp/kfNAuQXlQDyBzmboMtmCDdrC5Up8n1IoYLG10I5ElUG0v8rVcRjyBu7zg4iyX2MR4O39K6zE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9155

Save the last allocation of a data extent in the inode and if set use it
as a placement hint for a subsequent extent allocation in the extent
allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/btrfs_inode.h  | 2 ++
 fs/btrfs/inode.c        | 5 +++++
 fs/btrfs/ordered-data.c | 7 +++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 357a797c4f6c..34baefc826c2 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -334,6 +334,8 @@ struct btrfs_inode {
 	struct rw_semaphore i_mmap_lock;
 
 	struct inode vfs_inode;
+
+	u64 last_alloc;
 };
 
 static inline u64 btrfs_get_first_dir_index_to_log(const struct btrfs_inode *inode)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40dd87276cc9..402bbba0b11a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1142,6 +1142,10 @@ u64 btrfs_get_extent_allocation_hint(struct btrfs_inode *inode, u64 start,
 	struct extent_map_tree *em_tree = &inode->extent_tree;
 	struct extent_map *em;
 	u64 alloc_hint = 0;
+	u64 last_alloc = READ_ONCE(inode->last_alloc);
+
+	if (btrfs_is_zoned(inode->root->fs_info) && last_alloc)
+		return last_alloc;
 
 	read_lock(&em_tree->lock);
 	em = btrfs_search_extent_mapping(em_tree, start, num_bytes);
@@ -8038,6 +8042,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->new_delalloc_bytes = 0;
 	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
+	ei->last_alloc = 0;
 	ei->flags = 0;
 	ei->ro_flags = 0;
 	/*
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index df74c75d6c29..3b0925a13660 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -317,14 +317,14 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 	 * So here we always pass 0 as offset for NOCOW/PREALLOC ordered extents,
 	 * or btrfs_split_ordered_extent() cannot handle it correctly.
 	 */
-	if (flags & ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)))
+	if (flags & ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC))) {
 		entry = alloc_ordered_extent(inode, file_offset,
 					     file_extent->num_bytes,
 					     file_extent->num_bytes,
 					     file_extent->disk_bytenr + file_extent->offset,
 					     file_extent->num_bytes, 0, flags,
 					     file_extent->compression);
-	else
+	} else {
 		entry = alloc_ordered_extent(inode, file_offset,
 					     file_extent->num_bytes,
 					     file_extent->ram_bytes,
@@ -332,6 +332,9 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 					     file_extent->disk_num_bytes,
 					     file_extent->offset, flags,
 					     file_extent->compression);
+		WRITE_ONCE(inode->last_alloc,
+			file_extent->disk_bytenr + file_extent->disk_num_bytes - 1);
+	}
 	if (!IS_ERR(entry))
 		insert_ordered_extent(entry);
 	return entry;
-- 
2.56.1

