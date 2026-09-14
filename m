Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B9F40E8CD
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 08:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376099; cv=fail; b=VJYJJDxOn+9bAj86PWX6mw8/1LVZSvGaZOs1CGQAqvCmlsQkmo0mIsJeZxP0dUOkN+mDW9yJUYYzPXNM7RDFhduLxb6txfdO445K7y5e0eIfNouLhiucO2xhzerS4cBBwpXyR7OpCjqEFFlN5j9dQtO2FmAz44N9nnusMbUIv8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376099; c=relaxed/simple;
	bh=E9R5Hqdt+GW29fsQkA8GNOE/Q5qrVBVJTZJfGJDbVfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k5u6CpGQ5ikZgo30TALX2LCUd8MCsRIb65V6Ggq6Vbw1tkyiQnz0fwKclBZdDE8eYa2P9K6rqhQoTOIaz0J9ur7+YRGzIKa/ltdKAiT/3BxmXEVkhilss8aCGWkGxwKjvOJca8QT4UiXERJ2Aflszh1yGuuP3gCfgLWdLbP3BUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bP2p5dvi; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AC+mJvFm; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bP2p5dvi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AC+mJvFm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789376095; x=1820912095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=E9R5Hqdt+GW29fsQkA8GNOE/Q5qrVBVJTZJfGJDbVfQ=;
  b=bP2p5dvi4dcYdxqY422wcW8F9GCxL/6HvKsOWk/nSkHYD9JV2RAcWHP7
   AdX21TyyI/UTSN/MYyY2eQUHhmSZzl3lrc6rFjglOTKnvLbjX5Sd15KNC
   gOnwAWWeLhUU278l4/Augf4jghvTUMkHJlB2s1tbum6gWslRmNOC8SR1l
   sSAnj30rVsDY4884025R1Z8HM3EnAJoBU2P8gjatL2sToxTx/RFvJ4OdW
   mw52hd73nV7uNOeakzUWgUcj5qEWYLwthGGpZpt2Mjzbq2w5fs4LPdp62
   dpWg1Mk725NzAVJi+QqclhCaapGm54Pt9vokv+MJJU2KG34d7a4eT34ZD
   g==;
X-CSE-ConnectionGUID: QG8YNVz3TTe9SAfPRZsEog==
X-CSE-MsgGUID: zYk7Ibg2TWeXrjDucXJAcg==
X-IronPort-AV: E=Sophos;i="6.27,102,1786982400"; 
   d="scan'208";a="151403843"
Received: from mail-southcentralusazon11011049.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Sep 2026 16:53:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i2sBlSMVKBQpprdYtAePtXWi50PXrFvhcxPTmP0OZ5VnvhNGS6xCgRTAtgpJxUQBTzoMVWOOgxv/cl38OT3Tzq0fUpr761gl5fLvQEx5YIK1T0WUQmRG4JM6jLUVpNhaPt4D99WHGGr+dM7mc67M8a9zE6fGSeh/KP+y+HrayiM8sbCyh7wiJQABbTE5fnMtaNVu97D5v3ReKFCAWZpavy20l596v58Nd7WpOdCYJKpNQOkWkg7k+yj8A5pMWfV+6779UsCU6LgKkhhlm1PAWw2qZLzUAubKiOUg3aG4NRH4ikhIR8BN9mpFxZoTDlrwtP39wyIQ0Ko1VRSCx9dMqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+tePzz3y2klWCDgq4xfeO5EJ02UYcl15ZrFsdLHb4A=;
 b=O8TFSau3T6Km3qS03oDvc49VCgtZrrU23+Q5P0asQQRLHcTHtNpGjmDvauN6QuiQplfQKLz5Gh6UmOHGQrcGPVaUwzhPlmZzBRZSC+m5WWkEVSnk9M08E4grDJVVECJj+Ud0Ucuxnq2TCIG2rSYVEjX/rw6hqYPB6xTNlqVZtdP/rns0MuCwlZ1QyFPV66dch5x7Eh90YDobHmJD1ZmlIlYBKA2bc+c739DZnDf4k9jcGaZdnVNfB67SPX51Oda7sgwL+g5XQlj8Zex8797+hrdtq9co/WcqQ9CWHxuv+uq3Z/mBhvzXCi20N33kAENLJsn2XMO85W4MkbERgVQT7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+tePzz3y2klWCDgq4xfeO5EJ02UYcl15ZrFsdLHb4A=;
 b=AC+mJvFmTxnqUa5lyW0SVoIQn69Cbsbl2LkPiCJjNG32SwIuinwJWBCyidKll2w3TCrIXlbNHjVI0lhGVvEaDvKt9/wGfSg69ZNkefxmcq/LyOWZpM6smUTxkez1rjm47J1j8JyE8Z5SVvRqVTWqhqANBxe/kXwvL/HUKYkIrP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9263.namprd04.prod.outlook.com (2603:10b6:610:223::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 08:53:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 08:53:41 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 3/4] btrfs: zoned: requeue block group if zone reset bails out
Date: Mon, 14 Sep 2026 10:52:47 +0200
Message-ID: <20260914085248.347198-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
References: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0314.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9263:EE_
X-MS-Office365-Filtering-Correlation-Id: 60b79c95-3df2-4737-dc7b-08df123dad3d
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|19092799006|10070799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 NT0sGDM49OlBao1w88HPtl7AI0s8CRYU1sJkrmk8wRfgOPluZY4/y6b+CUzVdX885zUz+msTSf8LASLIsBM9Co/G7LfUYHGtYXRFsdK2sD5aSgi6QhpQAxi2A/GPEmstqQcCGAMnPn0FgCe/9srD68baFpLr+4MpGKc/8aXQrDGJIM2Rdm4EI9TgtYQ5+eI50v+GaFBV04lulRWOn6G2Tx6DYNwFjo3Ga8cwZh702XBaxBgajzoa6k6hTXTd7z32Am+9rVpeOBgtPjxlxqzwT8HtQZ06DjJZ5u+X5MTS/lj7zrO7crTUV4V2SbFIvrKy/0gpPxohzZ5YkDWGyEUTkoesm2LVNK8nzHMRyYxHkKGm8bq+Hu7RsLAG35f9a0qRHt4kqHVWxn8vlhtmsI8tAZuFRuJFp8s7ihIunEonYoVaBQlkNmRDdj8wT0cGZtkYdCQOXN1RMfoI2qEKzckZ/Tn/o3UBTD7b9fanFWaMqDo/LZJSOmR5aMUqTp9HdXc2jY8mYEUrAZrV1fKXaxrNYK+8DQgFcY+joadR5G/TffWnfwOqZ6Bqu8NHv0M+PnkxUFJMQiPRqX8eY4lCBYznBRMjq5UhTaDHkMu8NP4xzm2fjfJb34nC4XWPlDuT2zEicqoNJLth9338tJ3+18EqfD0ZyWcnta2ssWHr5YOScyI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?gMsRRovuu0GZt6AaVfnpTSOYgN/W/zB25ENTvzgDh2RGPKmjS4bAkNp2O/tE?=
 =?us-ascii?Q?JQ4XYV5k54KSgjupNVcnYkfCs7gJHoZ2paBg2IKuG2qJAAc9LZLkyC1IUhpj?=
 =?us-ascii?Q?2t55Zp59JhYkYDdqGeGbpP4qgPeWEgiqCzpkSgtPUeSW7poGh31MhWX/rOw7?=
 =?us-ascii?Q?HzjScGhtdbTgPcsU85Q9fS4GhsU2s6CSSMTh9ON2b2m4/GTSgztMB6VZiBes?=
 =?us-ascii?Q?3APbSHhZTmvubJ+Q8Zlp1+S/i/IVVt1xt2JKuphIzNWAhQQi7bmz7oGe2h7w?=
 =?us-ascii?Q?5APXQ1/O1W70WoL4OD9WDTmkqzo9GnTmnJ0Fi/zp48fO3mYIYiV4b6CDmvmc?=
 =?us-ascii?Q?I8230bQnbHg3TnsxdbetX/jhDDWKzaQo7cJyRWoDsNL8YhJbRGjnk9KcwfgO?=
 =?us-ascii?Q?8eCfRaVd8c3teMMgJqlH/MFEWNuqi0saP1vtR+jctdsBdmsr3t50DwAQr48c?=
 =?us-ascii?Q?3hk+/6gWiOCcWvFACJQg9QkHbw1gEh3Y/KTdtPn9zR3+3rQIsNPBAK+4cfMM?=
 =?us-ascii?Q?SLD6v4DmmANclfcLntAt1lic3Aqi4C8S64NidbVjXKZb+9DjUytZYPWO7gfa?=
 =?us-ascii?Q?0IxS4y0ubBbv8oAgHZyCwLUCNQJKi+daLH59fMm2XBJR8Jz64YYd3VE0Y38F?=
 =?us-ascii?Q?qxXaIUN5ae1EfUv1t47D3dubTC0yDvcLBTIvWMBF69Am91YQwLiZy4iLRlbr?=
 =?us-ascii?Q?A0FGeFs/sMpLdaDhwhPab5q+lnG6FpOflagaiu0O1+uNtV8n6TxTe3KLmlLY?=
 =?us-ascii?Q?RRNpCKK2Dc0QXyCMMt+/TIFACKOPe53ok/OqDLlzxAj6d6B06PdYIAd6uu3n?=
 =?us-ascii?Q?1FOKsLCDO/R6uRXHW31jNBJ0hM7P4qMwJQlPGsqW8Pbe0XIcA4F6uV6qoPEC?=
 =?us-ascii?Q?WMnzFrECwuxdpGz8PCOxUOrAoUnbjzIqmuXLckM8MaW2IxGONEJY6xb+DUhj?=
 =?us-ascii?Q?KsWMSR4O1RMDFZonUolI5Z5eyEJ+hhQWPFmjtsfQc/QWuwq0nI1lGr81pq7l?=
 =?us-ascii?Q?mung4Olj0tBs8ofEhhDlMHX9EKlW1ybllFfyZAC3Ltb6iOgQRa5EpurpeJvQ?=
 =?us-ascii?Q?7PtwhkRmT4BH0fau43iOKUj7VnjJzoKp9wmPoe+QQO87oq1tLGjt3akZ/YtP?=
 =?us-ascii?Q?WYqOqpssKtD6zaQmek1zJBInfW04YFT6lPmIKWne2mrvbZL4YXClSkCmYnEc?=
 =?us-ascii?Q?cR51pdOPTTC/8QE4gOnihQRvIX3MzMpjgLVzXJmTtp+MncNmyp0cu4v1VaEd?=
 =?us-ascii?Q?C/wd9NDh28aMxU5M3so5OZgPLCz1tF2u8XVCrW4Y8AKzaEbivlsFCe40r2Wl?=
 =?us-ascii?Q?zisHzemyZ6mXhPksKvHyRZ1a3UYvAEuC7v2oCczX4/MMOtESabfFseUTqWem?=
 =?us-ascii?Q?mZwDHhL86bXyNakAQKZWGuaZckYl4MsJe2/W5XuVg51kIYgwAJiFFDsxaMkL?=
 =?us-ascii?Q?8NZy+8uxsjA4kihAh5j32RvjlsqHTNifB42CKKs7H0yKgJ4RKE2vE0Bfi+7B?=
 =?us-ascii?Q?SNSntRwGBKRGOC8yoxz5mwVO4JKpvyuWGHphPK9RnhQd7GQPjNMtcC2KxP00?=
 =?us-ascii?Q?rzwNzQ9gzN2vlhIQxyGwKaqq5e+PWQ93onqKQNP4a/96fs7rPfdF5bKkTOwB?=
 =?us-ascii?Q?0PjZBulWq3/DYvzm9rXTQQ+oCwFvEOlR8Y+eKEdLaQuuypqVfCRDXSEB1+w5?=
 =?us-ascii?Q?JqiLwp2rlZSqvV/cNVNaJy4bsA+Rz7BmHXr6oFHmfRcU1TV4puiqMBKXX0n7?=
 =?us-ascii?Q?f6ZEVEEyT8DSvP/2DlwMVG950GpD5tCJHWMKtrU8+j0lXQmRGiU2akkw/qA2?=
X-MS-Exchange-AntiSpam-MessageData-1: rvam4OZCV4uyzG5+WrNOIqHhPJto0mbZxuY=
X-Exchange-RoutingPolicyChecked:
	YOEaUBqaW0HCWIC9LQNdk9kp3Mg6QSfA9UWk1R/eNYmZlw3j+BxOqcAgO6KcLrQu9b3sym7sY3+kXupfoKJWrIFbU9mJ1SzMmqXHT6cM2Gv+8KmKIEVby0DgmnXwsF5NNJmVsAbGw+e7AVD6JA/WYDMJuWGaTNrNIKt809hum/CBH3wltH1C/FmCAs/AcfDFul6z1re6k0Pg6vuBtHLyEv7PyNvH3M5POU7PiuVYPwrmY2dCnL28Qr9DHfuv5vCpTJ71+RcddbFf2L7bQ9SuYAkEc+HAqQ/j0d5GiZPGcetNKNJ5KfdKLpvpxhQcoer+syrY+fxoVmo3uFa3+v4OeQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ExJh+CP9m/PXpnhqLasqz3BlMFxwtysretC89Qkvnqlz6w3NRKg7mkXoWsUaLWNaBeRuDYxH44uTdLTt4rUWpd/b/rIaUGJph+d5qNQMUkWYarYHy79Ho+kRWfiP7RhZniko8CnYX4qgqkauf+I2XmZjyscnwIG4yTSPg3mzkdJREJ2w1WBrbVlo5xHFQc3dlCVZUgtOiRxTbZmIzi/jRO/X9HZbLPtNc8sMTF2BLT8yxYUbTDnP9UHcpiCmn6ul2O5liJF0kKgOtUvJ7O+SqK09NTbiD+dGiM9FZzjNhXf2U6mcWlvEXuRJxVXXpOGx3ezeBv8AceJ1qtkydoTsgUedEKtDtiJSGApo6F31SzzAiTDVRhRpNTsnS4fH3yMZXaoFimkGmaB1Z7/1mZbOXpBDkCTBdzliHHD3Omz7boHMS83mghWSNRLkWo/a0GddgV/794/pn/qeqiLMmlZNyswvK85xUF0cLdcyUUmJbg4nZxxCzob/b1FIz5Ok/tXLAHYVxK9FfijWkMZNHPImrZZmZpZKolqKMo8U+LjGPJK+3LEBARxpVCNWXxChLYC5QJptJk3dGVtwkSQKhWfxS5XodaVVVeJFJnak+3TEnw4XyKLml+uyqOaOdE3z9XZa
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b79c95-3df2-4737-dc7b-08df123dad3d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 08:53:41.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHH4yVWmwelgLnX9LGht3ehQQZ7xEBG5qNKJ50N3SD/LWPNmNhzv84zqI3XhkyYptOa5iAYNmwyyC8NEfMbIkN+KWSdosz0vAWUzoC4Yn8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9263

btrfs_reset_unused_block_groups() drops the block-group from
fs_info->unused_bgs before performing the work that can actually fail,
the actual submission of a REQ_OP_ZONE_RESET.

Every failed operation after this leaves the block-group dangling,
physically reset, but the in-memory structures aren't and it is not
requeued to be reset on fs_info->unused_bgs.

Instead of bailing out, re-add this block-group to fs_info->unused_bgs
list.

Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c09e32904caf..d9b9be0a5496 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3130,6 +3130,8 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
 	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	LIST_HEAD(retry_list);
+	int ret = 0;
 
 	if (!btrfs_is_zoned(fs_info))
 		return 0;
@@ -3171,11 +3173,10 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		}
 		if (!found) {
 			spin_unlock(&fs_info->unused_bgs_lock);
-			return 0;
+			goto out;
 		}
 
 		list_del_init(&bg->bg_list);
-		btrfs_put_block_group(bg);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
 		/*
@@ -3189,7 +3190,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		for (int i = 0; i < map->num_stripes; i++) {
 			struct btrfs_io_stripe *stripe = &map->stripes[i];
 			unsigned int nofs_flags;
-			int ret;
 
 			nofs_flags = memalloc_nofs_save();
 			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
@@ -3199,7 +3199,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 
 			if (ret) {
 				up_read(&fs_info->dev_replace.rwsem);
-				return ret;
+				goto requeue;
 			}
 		}
 		up_read(&fs_info->dev_replace.rwsem);
@@ -3210,7 +3210,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		if (bg->ro) {
 			spin_unlock(&bg->lock);
 			spin_unlock(&space_info->lock);
-			continue;
+			goto requeue;
 		}
 
 		reclaimed = bg->alloc_offset;
@@ -3239,12 +3239,30 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		btrfs_return_free_space(space_info, reclaimed);
 		spin_unlock(&space_info->lock);
 
+		btrfs_put_block_group(bg);
+
 		if (num_bytes <= reclaimed)
 			break;
 		num_bytes -= reclaimed;
+		continue;
+
+requeue:
+		spin_lock(&fs_info->unused_bgs_lock);
+		list_add_tail(&bg->bg_list, &retry_list);
+		spin_unlock(&fs_info->unused_bgs_lock);
+
+		if (ret)
+			goto out;
 	}
 
-	return 0;
+out:
+	if (!list_empty(&retry_list)) {
+		spin_lock(&fs_info->unused_bgs_lock);
+		list_splice_tail(&retry_list, &fs_info->unused_bgs);
+		spin_unlock(&fs_info->unused_bgs_lock);
+	}
+
+	return ret;
 }
 
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
-- 
2.55.0

