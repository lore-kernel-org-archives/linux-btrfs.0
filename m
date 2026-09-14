Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0598A414423
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 08:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376099; cv=fail; b=V44Lrt5CfrUVmYUUpscpxlvm3CKQyCTRHtEEV5jjun53Jl4reuitt53zU9fuaQ6Cz6CJPZlomC1PzF2HTeHKtaO5cqFfDUixS9E20nu0/5iw9fAdDaPSAEAvp9zpQL5EFtIMyPdGffaH7tooLTnhcfSSLlSLfPXTn9XTlIy3izw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376099; c=relaxed/simple;
	bh=zuwefO/Q3l3g0UOZq/T2fvFlCYuVYUBDzWEb1X0rM0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s9BM7Eo7RQLBwojWsWZRqJK4dZM63nPDRG111ygSEWTM0kZt0VY15usxcCWloVAiTbGA0BnF9lxDzT+ixMr7YrNC0+x2ChKbLFWOqTdaGd+fqsTqYHsHxWPbnhNoXlqN4p5RVjS4akPZP7f+rkRkNp0imkh6kvVClhyIYXBtGhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ojPAsDiH; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Sqxost5m; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ojPAsDiH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Sqxost5m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789376100; x=1820912100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zuwefO/Q3l3g0UOZq/T2fvFlCYuVYUBDzWEb1X0rM0s=;
  b=ojPAsDiHxvHppvNc6MXt7fJrFax1HHia/EUY7Z+9jg1efD5niJW1qVyj
   aarAvKTZRF7DB7iqW2uRMBNBFWe0wC6fqhY3GItbePFb7NTYsGfvyz5D2
   aBRnMK6TugpfwMaXDPYw0n5q99D9XgpJ2FILe9rL6bYzK6GG31VvmnqKF
   WcPkhmvyLHl+2av7KcU44TUdr9LY7aZ2SrdcSqxmiMzlsZurWfM8jeTA5
   EkNrwplJQ4uGIt9EwbrNfCxz5SDVTu6XgPa0KUpTGqNSTkv6HJiB+7F0/
   t1VhB7dtuPPJJ2hKtABo9jkWyt5SPX3h87RXDfTO8ZFAzpBM+F+LeGO9E
   w==;
X-CSE-ConnectionGUID: axXAQLouR1e1ID/V1GHI2A==
X-CSE-MsgGUID: gCKHhdaWTqaC1OZGQubqog==
X-IronPort-AV: E=Sophos;i="6.27,102,1786982400"; 
   d="scan'208";a="156538425"
Received: from mail-southcentralusazon11013029.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Sep 2026 16:53:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qrg8xjO0v5JHASa00zQ+fllfH31CRN7d+GQx13pUaQH2XwuiITG5gsSAkgcSUVl6qQG4hcgfbX4VDVuAWVhyJVhNJfikZkhvqsj/G6xiCkp3rLlPCUExLm86WDnlgpsfgYgOy/7auB9luvsZ7jWTaEeElnmcUHPVTIEWCV50zvf9EeQwBgb5oHcMGAGNIS4Iyv8jV3fNSO4q9XzlqipMva1Ls15/0KqbOtKnFfsMFCAOSnjhbWhwO8i3nY+zhfXMFCQlTuKS7ewYYAWmduNDtqGd9VlfTeTV1gfy3SrD/05exldCTFOCLUE0hbnyhbfUfFITDGHVcdFNY/euJs5naQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9rtLGk7j23kuGujhzBRq0O9wtRiCF5x2Wn2gYSWaPI=;
 b=pcddaAcZS2TYke0jMIjVOx5WYm+1MvhtOaWvcLYnKamExoNa4SnO9781lgnTJM7TZLMwHjtztTH2pIUIXGhn9y9vRw3KeTWzFHXglV2MNrzd4cJTeedA+54pFdzGUaD0k36SL0CXcmuIrnnqvGKAP0QB8wKboBSU0o5ntJzvZKxP5NVUQang63cDqAFtqlFppVf+JpH7zeb+5lheTofur2TNKY4ICiyvIUMnbEBlsrStHwWEHaexmbmNm/v5XFzKX25AaaPw6AzXCi+/ba1OHDhC5IoGhuVDsUa1KAcnaz5JB6BpdjbiFF42+YYguopqlTVWsj5pjf21arLjh6KyPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9rtLGk7j23kuGujhzBRq0O9wtRiCF5x2Wn2gYSWaPI=;
 b=Sqxost5mzgsuo7AWj6vsyvdQnjbmmTWT/1v/bLOkGa0kPkdr3AZSUGpuZTvht6IUioLRB5XTKQJXeGqK4GKc1HmZ/177z3rO6v1UpcsrgH/XB8VbJwfapVWINPoyMgMifXKzKxEc0+vzboBTyWftaLcHHerKcESmblyuAPeNdTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9263.namprd04.prod.outlook.com (2603:10b6:610:223::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 08:53:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 08:53:39 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/4] btrfs: zoned: only change active zone counter on successful (de)activation
Date: Mon, 14 Sep 2026 10:52:45 +0200
Message-ID: <20260914085248.347198-2-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: b5e95507-b66b-461b-f0e6-08df123dabd1
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|19092799006|10070799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 uVCrz0YinFXSeNpDkmlaMBVUC87gtF6y61j5/eSH+M+zDQl4af33q0S+d06caC+QCiAVIcEnRCmENmxSQI4DKbATHUOk/6Wy7tsAeB+PwME78neTvpbFG3oJDLtTRnpSgsoKXwLw7gZpXYL2pTLQmmIF6vBeZ/YvhXH3umlbFfwIkzkFtF4MO5SAHjhX2cJLRnwHoWUScvcARtRnUw25gUkwy4tccpwLRAHcoErKIMdgfjITDvIpxVL+x+okXlfUIatR3uF2SdZYLO1KwHBmW9+tDnMPZaiuBJiSeDQz+o7tRFnbX8wCGlBYXaR1EghFIoWOV4yaeIreFdTlIqNane1R+1ltqhqhuVnfl5OpbDXgoePgLurw8ClX2SwLyFtGFIcwHfytaVyQ859KuNaqeJTh+ZOvTS/5H/kRuDT7GKHB3fxO8hrGf8yhdX1nYkMDqsnVLbniaFZJ3ElGLPbAPSUa6ure2L1W7fmoRbzcbi1y0AqfQ7569BI5r58c8kG+vXL7GzvN3iEp3SrByJ9f2dgW8dWbgDeCaYCyAOAnbJandldzgT7W/VZA29Co8pL97vvau40wB9O/QzWL27NXirrNUavzI8dlwKNmPZJOv9FM59V1CDpYIiSs6JJMvWzcH+rP/9KGKb6AUmJYoZ/ymBHdvMbP7FMd6nrYuMa+MT4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?22OlW3m92Wndla34/0dzErY7ESfg7htIp3wCu61KxTh1zE6umwoXcfE5hy4O?=
 =?us-ascii?Q?pIvDBD7nrLW6amp/jwDMISH9XqFvhpdUSUhCpZg0rt+Z+cjWiapMeq0gDxZ2?=
 =?us-ascii?Q?UHQZednLDb5cNJrjMd7lwk20nRuw/4cMllw5O1akxTICybxqcPUFaBriFgGu?=
 =?us-ascii?Q?HQwVPK1lU4tGuUdEbPj8LAJbf4ab3u+EuvWh8rOuL/jt6Lu40OjqwL8oxCC3?=
 =?us-ascii?Q?N6DxO4Ct7ChKxF5c1peBlGYZJxGvgv1TOw1hH3s1DSU4QTScOWmImcsiida6?=
 =?us-ascii?Q?gOS9z2lwtj9tvVF0rRDH/mkzyurFBnfCqkC6A1px0pifMOp2CzpsQayje+km?=
 =?us-ascii?Q?vWO1PBGgle7/EO9mvEs+pWVBCiqr3X5ZxyjIkioa4PdPDlaD33zSXerqmOgX?=
 =?us-ascii?Q?bq60pzbTtjhPXfWjy/B4c4q2feiJnQDpcfBmAPqmFsL/P7EM4/UnMiPZaEpn?=
 =?us-ascii?Q?HfZmu+yQnuRqs6EvhXEQFQsiJbjTsXOhRWKx+dc0UOq+QcLtczSjcdJHUji2?=
 =?us-ascii?Q?9x0QdkWgBxBpgvG2FHkU6yJabGp3o4Du634awZASvbexFopIQaS4+iwpMadH?=
 =?us-ascii?Q?OAPfdXVeS8ZZV7fi8oCd/MnKsEZU7v4clDoq4Ll6F/woF5O2RkSeDYxqlemF?=
 =?us-ascii?Q?EEug6EbwmReOxeo0G9uLFNDSMxXSxcGMzRw0yqmrrw0YMnRutNrIAsWh1d94?=
 =?us-ascii?Q?BdQfYLy0LucpCWNA5/kndtcSg+88dMPLkJp/OSCzUH8yFCrExczZJs0LqJO+?=
 =?us-ascii?Q?W2bS3nZg0MJxGkeq/OEjh90JKdsDIe5HEbZANUmBiPK614veaxl78aCuKUDv?=
 =?us-ascii?Q?ibPhCjvIa0iEIab+I/G6KYxGsbcdOjYaFju8bVFD5zIJSvBBaGpON/V13k1K?=
 =?us-ascii?Q?5muJozWsPCu57HDWZHqdBf1d7V7VF6rwN9/nq+jDSfY5w55DOAkbpcmDUTZ8?=
 =?us-ascii?Q?yLQxzf4QI9SkOH0sDkqYv2m5nsaq/iDKWtmZ4GKhYMBNf8qAXZCWJAQAtZ/u?=
 =?us-ascii?Q?XlhyiOE/6qpBnCu45mB5LUDiJdNQuE1yjZh2vZc3/ZlQfTTY82tO//tSV/wo?=
 =?us-ascii?Q?Fv5aGuT9v/1ehCu5wpylRhOMo7DOiK4ZsbgQ/qV6lh73GrrIP/iFqvMH2IlK?=
 =?us-ascii?Q?XPJVD19yG0xJBZ8AQvEhLnMyt4DaLOOoEf/qMjU8G7F71I88lutGBNQb4r5b?=
 =?us-ascii?Q?WZMSo5dbODepiHEPcYI121Tc+TdaaD5GrvxC99JphwkX3cqxR/vIHcECidPO?=
 =?us-ascii?Q?RX3/4eUvbE9e/mxUJvv1L8zuQlcgL3Ivbx3FITZuBw/Be7FuLncbZ07SjXss?=
 =?us-ascii?Q?e41XYvz8K9xuNQb2O3/wYYN7pxwR70HhKzX6glXp+LTbvCBTKxhflo50lW8s?=
 =?us-ascii?Q?kHKXfzAjkpxRafmOyH5VFW8ekiufCirc79B9rfhD13SVT58Gxb405KYsHuwT?=
 =?us-ascii?Q?ZLHGw0GMLfPJArfJxLTVqMTU+DywbMFAT1hlpMJvbIt/DPQr3ZaqQwZJXgZi?=
 =?us-ascii?Q?QFzPR+lyVyg6cm/NHkvU7G0s/slFSRktLSrH0ejNsDeJhCfdhMUKPH+TDwWc?=
 =?us-ascii?Q?Ij4UejH0nEFaeEYxzI/dF3bPXv1yX2YYcuOpDEAu9/pmc8yaBYioqq1pmTpM?=
 =?us-ascii?Q?yVlmuzT/nfrxXfmOxu1ZEhKWO8r4VF/OVV6/+w+Per4nfpz9pDKUrARLiDnG?=
 =?us-ascii?Q?eju8d7Q1CQc7mEf5a/3U5XW5/GT3iOWVR6ZkU59vMqJBAcoiDZ365ofxnYTt?=
 =?us-ascii?Q?UsdBaatsAWXEHHh39GNsUBf8y6VI/pGgx5Mnrue/S+L+SqRFEoziqOBHmIxu?=
X-MS-Exchange-AntiSpam-MessageData-1: IrZ1iI/ZhFzsA2AEHrajDsa3x5mM087N6Ic=
X-Exchange-RoutingPolicyChecked:
	VDidmHlbbotjM57Lo8t7SI7Yb+YeLfiOpm5DxmV6FT3ifIjZVRA2XEC0XMG6EHbItLZOtzWQTyIG36N2Kfq/V2+W617J25m0b2+9eKNAO74BT+da2s9xf1K1xys4pYcngtSPlJ+fuRr/AbIWXPsCx2ay2xm4Ze6VmD07uXgqL3ttgj8hiCIigpiQbdnWbHT3VYdCQ92ifPK7MyGv14NGYeriCXPiWKz7SE+674oqDK5vQT/kYQ/E7Eb0AVF6SRRkbqto9OFPRgTuv840/xjvajkhVV4J2pElIzR7pQ+F9nWd78NagLXkCpJo/WqLbam7zJ6RdXzRBM86F25Fmxzw0w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GYjiC/lzNNrXo9494lx+ZNscRXwgW9dQZQp1MTg6algrI7KAAhcQVJV9tVpAQ+ePgGdcyQlri24ySlNgCbkOf5Ck40x+B9JG7+WRlKsotMi/C2rT7xCA8eEYfPlfTvdsfcLdA7j3CdZrinnwUja5z7Xm1J7hLbRsI2B5EGVcHmtwZSF+njU+8SM0K3gcXk1AipeI3OKoeung22PEPYYHOmSgBiR+u/70eKduAjyocmD92qcLjpq7EURSKddLNRI+nZFJVVPn1hEQ+U7dmI3nym8MJi/EZrBiiyrHKNHD0/EeX4a9hHi6MOMSqmxh4GR1PHCQBbfaByhMslbtCE47LLiSu0xY63E6HQs9BVxwtlWo2SC8IATJ/DaUPaqEa378En/hNIZjoWxQgpqLrFc3eGa2WXoajq7FmX3F5cTqDTG6rKxVcRSysRoyUrujoNdhX683e+unFb4QUW68tSHqQXd6QeS9f76Gmr60xfAq+5Y9WVC9ZPqyzkLq+wudeHSn8N8lHajJlE5QgXaFNOuxOOcwKAGpRU78lee8DeVCVtpp+IisNMSCWreRl1hYrhj2udaiRUsOAkq7geJycwFbLlllyS7KFtIhnmLUsByHdIqakJEU92+4apoU3LQScn9t
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e95507-b66b-461b-f0e6-08df123dabd1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 08:53:39.6525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TbbqxJ6oe/kN783HebPPWYRAPjj20vfPfnwJKiMF8zuoABt6NYTViQD/283d6H4eqm+mu1HociqkJpR+p2txVEmrZ7fwQ1n0Z1+BjXvL7eo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9263

btrfs_zone_activate() unconditionally decrements the reserved_active_zones
counter regardless if btrfs_dev_set_active_zone() fails to set the zone
active, i.e. because it raced with another call that already set the bit
in the bitmask, or not.

This can lead to a double decrement of the counter in case the bit has
already been set.

Only decrement the counter *iff* btrfs_dev_set_active_zone() successfully
marked the zone in the bitmap.

Mirror this behaviour when clearing the bit again.

Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 08a15465a087..12391063304b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1126,11 +1126,13 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 	return pos;
 }
 
-static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
+static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos, bool *new)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
 	unsigned int zno = (pos >> zone_info->zone_size_shift);
 
+	*new = false;
+
 	/* We can use any number of zones */
 	if (zone_info->max_active_zones == 0)
 		return true;
@@ -1142,23 +1144,30 @@ static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
 		if (test_and_set_bit(zno, zone_info->active_zones)) {
 			/* Someone already set the bit */
 			atomic_inc(&zone_info->active_zones_left);
+		} else {
+			*new = true;
 		}
 	}
 
 	return true;
 }
 
-static void btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
+static bool btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
 	unsigned int zno = (pos >> zone_info->zone_size_shift);
 
+
 	/* We can use any number of zones */
 	if (zone_info->max_active_zones == 0)
-		return;
+		return false;
 
-	if (test_and_clear_bit(zno, zone_info->active_zones))
+	if (test_and_clear_bit(zno, zone_info->active_zones)) {
 		atomic_inc(&zone_info->active_zones_left);
+		return true;
+	}
+
+	return false;
 }
 
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
@@ -2409,6 +2418,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	u64 physical;
 	const bool is_data = (block_group->flags & BTRFS_BLOCK_GROUP_DATA);
 	bool ret;
+	bool new;
 	int i;
 
 	if (!btrfs_is_zoned(block_group->fs_info))
@@ -2462,12 +2472,12 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 			goto out_unlock;
 		}
 
-		if (!btrfs_dev_set_active_zone(device, physical)) {
+		if (!btrfs_dev_set_active_zone(device, physical, &new)) {
 			/* Cannot activate the zone */
 			ret = false;
 			goto out_unlock;
 		}
-		if (!is_data)
+		if (!is_data && new)
 			zinfo->reserved_active_zones--;
 	}
 
@@ -2514,6 +2524,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	bool cleared;
 	int ret;
 
 	if (!device->bdev)
@@ -2535,9 +2546,9 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 			return ret;
 	}
 
-	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
+	cleared = btrfs_dev_clear_active_zone(device, physical);
+	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared)
 		zinfo->reserved_active_zones++;
-	btrfs_dev_clear_active_zone(device, physical);
 
 	return 0;
 }
-- 
2.55.0

