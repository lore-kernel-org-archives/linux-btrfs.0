Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1B8346E64
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822087; cv=fail; b=l2CS1niypQZ+VCcXf4HSnOpWX4k54Q9S//3SV/rhE3GoUvFVlJe5Yyd8N4FyfT5JTmA6IOl42evpqL7FjEjTuLYfxVFLVCe3vxUFwx6PO7R21QsO031jsXJBQslU1mpk8BIJwCs3TzOMyjVs6d+VaXy0+iNaMJV7qEID87lKgmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822087; c=relaxed/simple;
	bh=7geknjjDZvpvmLtn+OAHbx3S3Vc8fHiWVwfqfb/HP5k=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=thLJzhhRj8pnhg2f+L8OB/qiv6OUPaH+ZBGSiA5zaQmtEHm2DYZPqvfRpG9kotnqcvS4wTV72v/YHMaZciGHHFoWfLiwFS5vlcYAHcpDkEM3wx2KLXJpHKZGDvsZsJ/LXccs6+rh4p5PgS4C8+jRtTabOCa0AbT4KF1JG+/hVgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Mr65NRaC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AxTd9VqV; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Mr65NRaC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AxTd9VqV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784822085; x=1816358085;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=7geknjjDZvpvmLtn+OAHbx3S3Vc8fHiWVwfqfb/HP5k=;
  b=Mr65NRaCO36Wc+5/cC2EA/yt1xjzZknjQ03dq0jKGmDzYaevTv1tsZ2V
   EV0yWEborBx0UPYOUmWb+jxW3g14TcrjHC6GBZ36ajTSpNluOIlgyvnHu
   NeY0Fadn637RWwoO9SNhrp3NGUGkgeUDcSGrbLn9lSlr538hXL6j6QKbi
   i8N3mppdJmKUzDs5ohDTbJAfWZY49b8Zr2ym7YU8pai6S3/hpQkD/qpMn
   9o0C64/a6+2SUY8iBUaOyaejYqytJofY1F9KpJxugU+JPoswp/JRRxgVE
   UqFtkNIXUb37WA88c0GGh513xoRYvAHI9mW2fNa5p5rqipAx82iExiLTB
   A==;
X-CSE-ConnectionGUID: /pTN+EjKR/ODdbijUEI30A==
X-CSE-MsgGUID: UfszSXs+S/awSqYAFH+MMQ==
X-IronPort-AV: E=Sophos;i="6.25,180,1779120000"; 
   d="scan'208";a="150693694"
Received: from mail-eastusazon11012007.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jul 2026 23:54:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zPeHCVZfMDzx72YOMQIaSzrEanwFps2W5DsIZUlFcBvCXeCfGZYMhbl7nMdn/P/9LhxsI1zaeHcJQZTShIPMP8/v6LpZbkOd3KJYZx5uApNnj3moG5GNkJDNMAJHfVY+kbhinq7Vj6XwQzeoVOl4sWYWBI1fXrf8OxCYKuctZ3YLKTD0EyYxbe/yCS05D8za476LNbQJa8Hrf9pgAoABiMe975YzIdOrnEVNJVSurS95e9ogPD+OxwM2SV1l++5COa/ArldGgho3FrbYr52BTT/fqLomrHUcH8s8m+SWgt9onXJ0SMenCSKwmdlPDg+h4YPvzJw/OBJBJUDkuTgfBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIrXywCLjmlXWNwmaVkpIgLSi98v0+TV7uQrr36bZGY=;
 b=TzDXii+Sk3CjIEPbKFAkB5DdQwEdVuzRvRdIL+iZKU3sbmHrO658Abrp56XBmH1wSC6PgERygiRZmAkWx8SQmyrWltzJVxLgUwHDdx7u8EnXjvc7KqXFfBMBAa4/NZ7g0H8CHW7khPuM2wty5GUISS3UtB0dvSjkWVsi8vyvA2Q0UZ4WAhushGDXTfCK5E15khVkqsn9CgNVJ6r/JV5rJtQuREh9JLdXW+P+whl6UUG6UeMnNbi8QZz1itgOgODaaAxrnAZRAMRH3h6swr0NfNwCPw9SMMeaf+5hnkdkYQjdymFTwYev0BS+cHErY0nVVYzYzRGzLZPmEapHKttf+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIrXywCLjmlXWNwmaVkpIgLSi98v0+TV7uQrr36bZGY=;
 b=AxTd9VqVY4i2gn4Z8fuihv5xh0E4aAnBdgvIzDgzHuH8fH8mZGwb5Rs6AXRzPPTCqTS8kyVyScxeGyFgsSJqfFfrwMge1xz3xYsaRF++VcZC5nPqtr2LOoo5U6kMaaASjkJl8o6GJLVxGfSN/o+ILJTtzXfOimi+5bc2xg8LSpc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB9295.namprd04.prod.outlook.com (2603:10b6:408:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 15:54:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 15:54:42 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/4] btrfs: zoned: btree inode writeback fixes
Date: Thu, 23 Jul 2026 17:54:24 +0200
Message-ID: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB9295:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a1b2805-1bf4-4a33-5fa7-08dee8d2b56c
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|19092799006|376014|10070799003|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
 mvFy9lhQs7A2sOIxdBHpxcxWlgzjxt3Y6STEC6+TkDUumufJBAZJ6pJlBYsjq/nKVaiA4fNEK+cGxqtdM1jHXc8G625odhmQraJHjY2mDI94ALrVSontNYNIEcAWq7R3rME4gpb1wkIacdK3dyovuzI9zXKB5wouiFmao4U9aswg8vGdXlHNYkF+4fs6foMx3nhEFcf0XejGLxqPuam+MO8HzN8NYYw+WgKLVq0yWGVNQGPLfPi/ZyYAEe6Jir7RqiE9/dmIN/1TSZORJ/jrn2liPDazEDbTMTNbQQ38PMCsVJonaMrZLk9ji4mlKwt4UokRl277Jp3vMjyHUXJdg+k3iHV0xEUnxKkmt0PKrwB3U65/8tSy6u2sXmVBd3Jp+HMBzUlXUQjTYYd7TGqGVQplDRXoyuCgvUAhnzvrPwxCeWCttVDvXXCPlAb5hwOdG/QLpCyOBGjZkhaHmij+WasCVGa3+DkI7cJRozofm9x1G7oteEwo7zCOhRs5sEPvfw9KbWxKpdyr2lsnQ/sL2lSc+CvvRwwiUvVTxN8V6C5Aob2U/4YLwiyVgcr3tlmpz3RJAKabJ9NQwEpvCgTphEcCiMCCC7H9dwf/Mq/XTArrkI2xrHxrNqj/MtAdlHtBps53oPaHJo4MQ2FF+lIqyum92h+m7PUQEhTXP9O0sKU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(19092799006)(376014)(10070799003)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?IM5ttu5zN+wCjq9ocdC0sukm69+8zqkHZ98EcXBUh+DezCe26xVkQPDVdFZ/?=
 =?us-ascii?Q?eENt2M4a5ZVDawhnyNRSJEICzG9kCLMYX0RMiReQkxLaHwaPWidfpL7jQf5f?=
 =?us-ascii?Q?/dGBAFE9P25I/P/RzKurIkWkKgwtw9M0JHMulQeFjKQvaQ8aivPcw7BmtDNn?=
 =?us-ascii?Q?k11SNlhucndcr0Eg6x0aXFZIGupZJjIp+nUr9XGJNHdXC5bTirbbg4+zdzOL?=
 =?us-ascii?Q?bqQwm2csdZBWZAQiqADQkL9StzrWv61SC9VYHJxls6FEWjlVyOUwWG5RwY7M?=
 =?us-ascii?Q?TnWHJIp2E2XmFD5diXAEHDL60nh7zk5Ly2WQvY+ZCDIEfzQEHCHF3iKSFa5e?=
 =?us-ascii?Q?I0AeX58sDp6XJhnWuKYOYTNDmbuZjr7tu9Pl0xqiBnyuukkcI4ybKL07B3n8?=
 =?us-ascii?Q?bCo+txomYvRvMhD40id1HzCTBS5Tot4KAsKVDia7DOu5+nIKVE7zjLjB8SPw?=
 =?us-ascii?Q?b3unP0BpFmGaRSm4hFfNl5U950ppO+vW9ZWHOfSZtmrejRplTsnh3inXGN0K?=
 =?us-ascii?Q?7KjnrXjmPQbWeq0sPcLcMnRN9L8Qx1a8tu+NQJXw0Zce8og4sBYZJBNuw1Us?=
 =?us-ascii?Q?KTpyTg6V/mG/kbEHKDSoclNOGCSXaTRdYwTBYTWm2J2pOYivsWssGMP7akGH?=
 =?us-ascii?Q?1wcMT/4UgHZw1LBdl/meKjNuWNuOcTP6d3SNZpiB6zvZdSmLadDXDpTeKdXe?=
 =?us-ascii?Q?1PMmuHMN8fi/E8ushZU5owyusAYTO7JpnU5q2piTSgFTaVA4JPBTJyh3RZ5/?=
 =?us-ascii?Q?h4+oC+1jokxGrsESvhPO8gFpOETH0hZvWdjtOnWCIJ1hDT2E/4VQLnGyfvLw?=
 =?us-ascii?Q?yzDixry+AeO/QCMUXO+ulAb6dpgsTf4L9JCiuS9iWLNJdZleanXU734Ble9f?=
 =?us-ascii?Q?pcZWyLPTSzofFvpl8ZCJp+irWf83STOoFWE/1Xeusw0V0b/UhulYKXHWgDo1?=
 =?us-ascii?Q?wPbq8q1rwCrOQzh1VlN821/rLU2yZM8mTzgPrRGo3VJF/eq7ZI7zQb4wSz3m?=
 =?us-ascii?Q?Yk3Ec9sjip2ZsTz/bGd5qbnbi8Bpa052FrTd35zprCt24Pldk4c+Soed4Af0?=
 =?us-ascii?Q?7unuAjj/3ZIXXv5VxJY6SlHWhM9n57QK4cFTxZdqWaZAjG0Mvg32lbUOxBi7?=
 =?us-ascii?Q?3mEj8RHhYhq4JaBAJtXofqnBtTq1Aa6NRAl7XI5aYYbvAp3WcyN8V7p6Qa4P?=
 =?us-ascii?Q?UKl/98P8lSmj33cJGzFkzmUZCOLsTIHO93ZezJIrBxtafYaAhIyNljh5wwBC?=
 =?us-ascii?Q?wfHl1jnrYME/N10qjNCCS7nDNfkJL/O3t+EsHV3hT9fY1nuDbiHPld55waSY?=
 =?us-ascii?Q?hypBxG/OYZyH7834BhwbQZIS6s3YL8yXDjtnUtySx/SH8riD6asVmmnOelhN?=
 =?us-ascii?Q?6XDY9JmgYXPGqiAr7gidXhx8KpWsO1jtEUA+2iYwXbVdOZUoRE7i+D/i9OSY?=
 =?us-ascii?Q?hn3zj+nCnZMBPZ0Mt13w4CPzv/Ano9vDX8i/ZsYwg/oyVtHU3G60FooNo9xo?=
 =?us-ascii?Q?HF6O/88uOezwz6wVL8TCYZWJBkJyEKJ5JSb/IbHweyeUp9JRiw+oQWNPUqnB?=
 =?us-ascii?Q?0mK0kAYiROmSKesepkji5iC9oeL7SdLGxd3F8N0WfXI/GX6gimy68hQNQcod?=
 =?us-ascii?Q?iGiqHEW9Tp4CQoQCxuGxiIeqJQHuG8qr82sM4WUKKa14UjIdOxJJz9Ft5uY1?=
 =?us-ascii?Q?/fjk9WYA8qlLv/eIQf545xZMmmjVXpB3Jb8PQsdjfsjRzTqENaNMeC1F+XgV?=
 =?us-ascii?Q?Ljoz0VLl+yvORG7e+SVXQhyU6n/6v2Am5S7EN2RYufxAuqrXB9/sLtDzC+mF?=
X-MS-Exchange-AntiSpam-MessageData-1: WKpwWpXAY9yPsQ==
X-Exchange-RoutingPolicyChecked:
	OPD/N+a2kW3u4qnSkw6mwg/iGHD/iXi+HCetAeLjuimlBcYbG+dnsjp28utVtxfi451E6Km6dsqV6dQBgiAriTit5SIGWCXGXpciDVixB2mXllqTaiD3LoCzWGR04omOpidwgCDEh4bysWbLCODXIx5dwxIyOEbzwc+3ttLfC3rLxP5YjQHUHXZzUY0I4cqLEiwF5DqRdJil7zFIvq0dVOFqRLlo6gqtYY0d7gygSdP7EovP9e3us0c0A/DRi87o8gi+Fj6doOGuWOA6Ow/DMI4310pKVL/pdmJrR2FMdVkuFpZ6mZtylz1XhL8E8uAA2LTyrCRT/8pzye6d0JKbWw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R5EFSLCY8XFpx3JhmXu/L1TiWFcXUvC2zEFQ0na+2ZEuWeg2HKa8eqM708S3rkuxj2QAgdV8kbw9+sRz6lfew/fqddUggSaiRqHcxkV4u3PalXRrY/J3Jgh+jMRcbeGwlGsYLpu3ZRqiebuqalZCaEj7bWPBmRLSXfOZuNxiwjNM3gtJhk15iVlGRrRQPbWPotnHKntAqIqfZvag7CuJBLh/flVo+JwWFfhO9ZUqxM3njjH0V7Kk5J/useQNpUaf/4nl6R7Harz8z+JIsxcOCtEG6Xq1rSogZ04itWgOu/sK+KOfrHjsQcNLBeJsNK7tIXe67ujzYgToNm43I1811jkwpYpDM7M6jVOIpR6pDGAQZgV/+VK2coYcI0dsBQDycbUG30jZnL3LgBQjEMsqEVi1AQdXLzsSuQy7uz6lF37RUOJkMvcKC9ElHp9Pxo10dL+njsbxB3YfSOcmg+CUKqbaEKbJrGdTkRkdKXo3tg+seJXMK//GsTUKSXwfmSiHzKXJs8mlAz1hp6iw89hhADlPXOyTwuvhLCzoeLr/pUkoIRU4mIsSFAdzZ9zXchk/NS/QzQ+I5M/bv0uNM0lo883Sgyqu93P/OY0Y0QNg+9xiKRW/xJhmRRTBfbBeEyx2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1b2805-1bf4-4a33-5fa7-08dee8d2b56c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 15:54:41.8936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUm59F9wmQCKH8+ZJsylxC7WhB7DIy9gZbXOekamcdJrtkcgpgZbtXsf1SHVD4myh2A12YxBq864fF7dzUQaaQsCeI2ELtgFvm+uJDaVjaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9295

Here's another attempt in fixing the problems with writeback of the
btree inode on zoned filesystems.

The symptoms we're seeing with it are:
- Hang on unmount because btree inode folios can't get written back
  on the final iput() because the block-groups are already gone.
- The recently added WARN() in invalidate_and_check_btree_folios()
  firing
- The ASSERT(btrfs_header_bytenr()) in btrfs_free_tree_block() firing.

Changes to v1:
- Reword changelog in 1/4
- Move per-eb write into helper function
- Call brtfs_schedule_zone_finish_bg() from flush
- Skip flush on -EBUSY
- Only drop ebs tagged as EXTENT_BUFFER_ZONED_ZEROOUT in
  btrfs_zoned_release_dirty_metadata() so
  invalidate_and_check_btree_folios() still catches legitimate unwritten
  folios

Link to v1:
https://lore.kernel.org/linux-btrfs/20260722113016.1896990-1-johannes.thumshirn@wdc.com/

Johannes Thumshirn (4):
  btrfs: zoned: flush active metadata block group at btree_writepages()
    start
  btrfs: zoned: drop stranded dirty metadata on transaction abort
  btrfs: zoned: drop stranded dirty metadata buffers at unmount
  btrfs: zoned: don't clobber the extent buffer when zeroing it out

 fs/btrfs/disk-io.c   |  21 +++--
 fs/btrfs/extent_io.c | 218 ++++++++++++++++++++++++++++++++++---------
 fs/btrfs/extent_io.h |   1 +
 3 files changed, 190 insertions(+), 50 deletions(-)

-- 
2.55.0

