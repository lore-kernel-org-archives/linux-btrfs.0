Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031009;
	b=pinQ1Fh41zafBkeKKCjz4p5UfA4WT+fUU1L+wx7GVkPyVdFB3kGEHUvYl/uc/2ffD95K
	 2hGZz5/X2rKrmkWR2wTEaHvDz9sdqVWwWQYl1uinCY/jEGPvaxsfz+tVycPs6JRTh1JAG
	 gbd5CMDBZ4GUsOCp7KBSIEzHoJ9f+mbuR/l/EDCAQSHQPW2TDjztJSNat2jbtGznEvj+U
	 J6DFAq4q/tubPgLuXisr1s+elmYHM0UiAaoWVrDvcYrQOr4g2QA4l2GybpiFwh/wpVnhF
	 Ev4wGdLPD1Jez9ejh8RLaz3idEqc3zsvMVv7yq6VcdIu9P8sWwDYjY5632RBCQ71FKw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031009;
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
	bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
	b=sjWdAG/SBw+tzwIl1JCvjN9hlEsPPzlucOG5sVFqPKO6/PCJGiMfFTshIwO/7hyrarXE
	 c82At16f/wstklKuWwBra7eVj1tgebWdJWnLj3afUxlX8+f0kPd+yNLvG1VdNBIChIo3E
	 wOx2khkyd+caBbadIoJy7KvxJ37WA26b0RUp+6KW/Z/vVsKZ1nRRHkEow9UIDqm+8ELpF
	 5pM/s3eGhUuh17VemGlV5D0DY66cR4ecEcz4D7KXgUK0ZzEEZKZSrr+3ZCmg3jjF8GpdA
	 ChKPzdP63+NHHDS6UGbCj12kxhK40QRCCTCB2xYzeFl43eBTpfMgdC2G9Ma4+3daP6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=USHN1Qsj;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Q1+To3Bj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F87D60A2603
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F87D60A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=USHN1Qsj;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Q1+To3Bj
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031008; x=1824567008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sdV30EnUMZAr3aVKN/dXLREMkBoxXUp7g1yIiItDRrg=;
  b=USHN1QsjPzwu9LgBW+VYYW0f2DKJxJ1SE8PwLXwkBSTnQhKdR0BYPw7r
   n0RTJlNq5mYV8yIxK4fMVmrCHPdqltIy3wZBfNptNYZ+qWVDTD1KuqUTS
   AYdphIkr1gG09FudJ+5HzkCILy+hImZ+L0+E/7t+bTc+vAoDmUluvudgo
   up1tfrHhjLpQcXNaG2zwZpmbVZnR2j5HWAndGq6/eiZZy31Dj5PDfyujQ
   NPjQZxJBvYNUdZdHBaSJVH7kJ1EXR6Jm4q4eFuDAfnJa4SbBqCLz96QEp
   MGqM3SVnOVucHlQKnxdXYWn1V6WxViRx9ioZBSKKzo3SQsJngqis0nzQk
   A==;
X-CSE-ConnectionGUID: zhG+E7UPRke6WMbWgoAOVQ==
X-CSE-MsgGUID: 4+UqQU3CTOiYX+LmKKpaCA==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033906"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gGloiX3GzGiP+e6nCx1W1Ngm79Mbdil/mMAJzNuOTBlIpsdydaHO/LNPGk3wCXTNLTnXKeRmsRXkOKT/3GbM7Y2nkVXfF/YYBFYy8PIe/lpBENKIiy2pVqfCZ0YQPQbQqYlAX/RcUT9vJ3RhhdDi0zg+BQKJrX5xlaoraLDHEQiwsfNGeHwNf7FlHm1tAojHatpHlhuoP7InNRnRzTAkwHljueru/kult9JZ0r7JosDQDRpz/GDCllpfTJJcplcXXDdxD6xzn1r6I/ZiXOt6k/hm6YOVyCI/GYzMD3NFIFeE1qsfvvODfwkep22xD9Ug4QoDSosRb0u5JaBjNmxONQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
 b=HuuVYvw3DFPl+s9qMEbNaakwnXQwyIdiE1gQTAmXLvAdEVgYg8lXdkDTcbsfgUbqe/J694wDBC1kv2bxS6fuRJ1Lt+I/ndZZMhYEgHZ7JTj2r592eOVQqRqFqPRmGrBjcm5Trj2o4pm2fc0K3AslL1IW+1OT7R9ehoifs5prhsjHZK6f9ATVgmIj6A1KTVgiGojCO1YfvEGUlZvBrOth9sdbhHQy9IkyEtmtvVUG0XQeu6Qckb1x3pH5xssR+obacxxUzW4ovrXAlBKs7m4bYmQIA5Am35d33OdfsoYDz+38X5fW0EFLfyYDW1y0D6Ng/TJU+Ur2TIyGO9ZWqUpX7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
 b=Q1+To3BjySjAqVHlIcU2/+/2jt+x34JkhhWeb55Lm8EMPwmcTMuz9sunHMfg9SwgO/v5/AstSw0nS7xCBewvVOCvPPXlIWHLMs3umJ2YBAP+YS+tq2dWW82+rtf7FkWp+UkIvK4RDSj73grCfurkVrgakrM0PkWgWm9fC7LlaZ4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:48 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 14/25] btrfs: zoned: don't count in-flight data as available in statfs
Date: Mon, 26 Oct 2026 17:09:02 +0100
Message-ID: <20261026160913.207909-15-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 8349b26a-dec8-4242-1de3-08df337b8ed6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	57vc9K/XL/6I117YDtkn7YtMSrxZn/lQDICThhu6EqTA/ud9z2ddgqfcQIVcJMrsXGF4F38BmYxgXhz+GRby9Vx8ENE1WUnn+/ypxiyq9Tg6FDjEJV+C77N+X+l4J1Y3yKWHHWl91v6u2Z3WgYU4Eo/Go/saEXtvybUdWrYrvfRjJqndhqkW6bTLHSw1jC39FxqPQr3q/2HR3inIi40QCMHxGUaNLH97FV647uD4FWQNCKMs6G/mzX6BSpTJdZWAYNjszwIGTYm/kzFCft5ati0aVVhOvQL4oCLh6cQxwJixwVYMdyStPe8exp21xMMxj5ECMFs0nnGXbsWo/eTV/KlgcQHSLN94V0SdbN2jn2opEsRMiMmV++AKw4jkX9nXaah/5gySdKWypwkXJ8lC+uzfGufG+TMDqG/GROSWZCozCtrF3tX2aIxfFScEMA4xR0OnwrVVSRey5HGokjcKDjuD1T4TIwKUPMaOPiSiRka5fPNJ9rx9HobcOuJjcLh5Kt6gzk4FD5+RQMq6KV3PM5gS6b7eyzea7dC6B3xA/7DL+OuUdSB0PjxEt7GjHKI+uD7zjgwgJxTzZQFq7Onzv98J0OSRTqxZ596bhsRCKaqXgkcP97RjRO1X1DCxEtjCQYB+7JE5Pdhi4Qrfe61nqRcRQ/0WLxp1HtObkHCLE50=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bf+rTRJTlVFR5uR8yDO2n7qlv+dameyO3aob/1W+/V3IQSEQuvuSqLsXEe5b?=
 =?us-ascii?Q?a8t+TrSpbyXfyWU3yVGe+51zHvJQuEq4mHIfbMbwmiTKtzJxS6N6haicIclY?=
 =?us-ascii?Q?iwI54TDs3Pa+UprtX5NRMqddytZBbwGqHeKPT5qe7numa1ZWPuXBtjF0UGww?=
 =?us-ascii?Q?u8VdUUiV4O4WJd2Mumm2lechmOB9MjrVPIAXGqooeM70cqHKlneM+kdkIQw5?=
 =?us-ascii?Q?6wvyD0HciZt58hOngvLhtqPE8SrC15bOeNyvlsL/EyOhOSSD6oW8MOWixDzj?=
 =?us-ascii?Q?Q7wB9RCbOKeBKcS1E6exzz7sC3GpCGxsxC3t2DzxudKakVcHVEZRl/6Gxr8x?=
 =?us-ascii?Q?4RfoALms+BxMZSoE3FVomQon8fkyl1MJRwgT3n/vl2mbgEmcYV17YFKDsztU?=
 =?us-ascii?Q?0yz2qdAlZZc0hFKc8OBKxTn/CNGNwWNDMvz0TevyWJkE1Ts32uMfUZngsMkB?=
 =?us-ascii?Q?nYsndKqkF4TJhMoiEz2IwLci2dG9kjpg62czUik6JY34jDs4k8IHOp5vmwz6?=
 =?us-ascii?Q?sltPT/Gvgk+ncRBEI5j9zrsg6VSIvRe+U8txBx3D5QmDxnbKL0lAyHF7HN9Y?=
 =?us-ascii?Q?9PgKI9fB1Si11glT3EG/VeFPW14zqhX0UvoD0gfLqTFZJiOqc1Q/Tdc4cA8e?=
 =?us-ascii?Q?NcqcJ6KY48mCHkXzW/zZCeyn/DUEIpq9LGQQBXTc0FOGstROgFXVpc/Kn9fp?=
 =?us-ascii?Q?+JLSt5h1lIYauIjUJ1EiVXoza/+/tVkCtfyguVoObd49XmuDGl/DhBlDpCKT?=
 =?us-ascii?Q?vsJTLetVQRNid/HwoMH7ab6v/Fom1xqLgqIRFauBXv8gs5PCOCAWY0u+MrN8?=
 =?us-ascii?Q?xTEb7/PXiytq4xqDKAdi7PIU8rV8EOLl8ij5TULIA5UfNp+xEKCioBBlEMPQ?=
 =?us-ascii?Q?ogt54UsjtbnyrDDt0aU6eU3OAJqbqdZ1ol0ioNinJAhv6CcomE0hHTjVJJAh?=
 =?us-ascii?Q?5xOm83pUYlaT6OhKhL7HhQlweXwdqw4GUFJgHhyt44Tuk+TCJDlkqC1Y5eq0?=
 =?us-ascii?Q?FT101uiuqfmlzjcXJgByUYRvrNlIJZfm1e1qqZxt/wqCPW/1Jkx0OrQfGtzh?=
 =?us-ascii?Q?5NO8t5vbsEJAkY970P3v5jmGEl8cpYMOHAAcrpX0hn6jKMv2Wf/WTmG6Luq/?=
 =?us-ascii?Q?zaBwtv5OcoZJkhs0K1PlOQwRgZlHQc1AH+brbKIaUoajHsKDR+hxvGz/uD6M?=
 =?us-ascii?Q?/iwTOnHE47qkNFhvo4mmmVbYADC6KMirI6TTOHk7WRsIPJsRcb001/2pKlSy?=
 =?us-ascii?Q?7Zvn7NxvPM3UMjmYlWzRZjI2913hsI+99HEVvsQxZ2kdTNQZyOjqKKLdVm/l?=
 =?us-ascii?Q?bpQD2Bs3L+b8g5yrTKzXiPNl5Pvo0THqxbyv38oWca8OedBTDJAuSZqrzbwr?=
 =?us-ascii?Q?s2wZu1PXTMoZPSJCXNyRqdmqNgCDVYHvQqphekjKSFyV8z+cBB+1LBs7EvMY?=
 =?us-ascii?Q?rSmfo5A49SEwbrdJkgW6X/IVapwWdPE+rkvrNHFeLgCHBSIqIzLvCBl9EeID?=
 =?us-ascii?Q?5LwFzTOyO07Dwj36ZS/mEAK79LfAvf2UAU6G7S/XoKBelrkz1XhQrAOF0HMj?=
 =?us-ascii?Q?fhslhMG+1/i2oxWOUQTfoV2XPCRZ+q9o8KHZQf6O79D92+kJnvyPknsFN4Qn?=
 =?us-ascii?Q?qw2sSxI0aAh4/CxU3BpY24BffBhzKG/OEzdJ2KvcwJGSnpku7bmWKkhIUFCQ?=
 =?us-ascii?Q?oFk66qDO54p5G2x1FttDofzKduENz5G6a1ZaKOIIPEPE53qK+Gn/VOkWVa0g?=
 =?us-ascii?Q?BIejyr0nU4wfD/04ND3RZ+zB7KcF4wAy6Clu8LYEFG3hnih3WackJzqA/xRv?=
X-MS-Exchange-AntiSpam-MessageData-1: zWbLVQkej8DiLA==
X-Exchange-RoutingPolicyChecked:
	4yAjOHzQqqAlnIsdEDvzMXAV4OESK2mQSZ0YuNdmWBopJogjSj378zy3GGhmjWM8kNCBW/EE7hXTwfJZaE+yhg6489DRgm7x+/IrXmB57o/P/bi7nbyPQvJJsxera/Ta7y7flMpqYAC52fG9gp8AlEkMx2aMnkMZ9MlLheawgsHAPqJRr503zJZ2KDcH/Pf1IA9OMiPVebA/s3XlYvNLrbvkwhtPhj6uyaIyi1f8rZRDkyHIe/R2HYC6eHYeqb7KTqqNFjfLQ7RvN9UW1wSD8UbVbmCDxZZGKRM3SNFrvqXsJQbwSGOhYLgz8FzRPKlpti32AaND8CM2kB8ta5+9SQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B61f/w+/rUJ28X2aoK1bg2tOb933wkJCP16H0nj9QFVt2yt/i6rsMle2kKPmvmCEuCdWXGOILXseGZVXr/S1mXyYNCD4JytOiKkgalnOS4zCcvK//nK0Te3kpPlCJAu3eEeOJoPnHNcTp8b8CF7OaaI3q5SrpjWhV8FzWXpZddCPeMQx4cd4n7HJdrI3lijbw7uloVgiJbYmcsiyeaTIBocj1+II1CVNCZhTs6VA9BrcNBptD6uWqs3EYni/k75t7S8la0EtZorehxn7j38DD/yXBF+cXKnUo+FvrOw5EEFYAN5TBHvd5/pnnOX/ujF487U6PTbqr8qlsI12AnrPidlSk9FFd6jhW71AoMf1wX3ly18lZ/9+GmhIY2CeZVU3JtvfmVf8IIrYJ8h7AIKvw1M3Vf3+9S36QNFw9gW2AI5HGrU91h7svXNYEepPEB2dHHTHPdqoL9PkWn+KxPlJHBfv4bTq1M6iCV2W2UDanouxYWADcYKturLXbQoNfF8++NJBHFw4f1/r4xX6s6vC8izi4o78z0ksL9plnd0D7DcomISQGzkdhX5+pkyLvLKaHEov/PuyV67SF8KUhy5s09Xa0dYU+1Wxx4G5NmQof1sBeqH2b7zMeruiY9O5jHSf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8349b26a-dec8-4242-1de3-08df337b8ed6
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:48.2014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1n7pK9a40GK8iXfKzktX4Uyb1Vt5ZQXS2Jq9UccYyP5oFfxXPYjS1finFu7MXfLDCZpn+MnGRhL5WIzBwKWiDMdh9goI5jJm4I/CrfhqrLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

On a zoned filesystem, space of a data block group below the allocation
pointer is used even before the extents written there are accounted as
used, and freed space only becomes usable again after GC reclaimed the
whole zone.

Don't report reserved, but not yet used data extents as available in
statfs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..9bf211916870 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1691,6 +1691,18 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
+{
+	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
+	u64 reserved;
+
+	spin_lock(&space_info->lock);
+	reserved = space_info->bytes_reserved;
+	spin_unlock(&space_info->lock);
+
+	return reserved * btrfs_bg_type_to_factor(profile);
+}
+
 /*
  * Calculate numbers for 'df', pessimistic in case of mixed raid profiles.
  *
@@ -1730,6 +1742,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
 
+			if (btrfs_is_zoned(fs_info)) {
+				u64 inflight = btrfs_zoned_calc_inflight(found);
+
+				total_free_data -= min(total_free_data, inflight);
+			}
+
 			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 				if (!list_empty(&found->block_groups[i]))
 					factor = btrfs_bg_type_to_factor(
-- 
2.56.0

