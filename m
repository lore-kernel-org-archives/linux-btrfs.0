Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F40497B6C
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634102; cv=fail; b=cTBN9wp1P3JZM3bwXAxaAVWfWEbNvsCVibq0IKkys9JmhPfB13VRSubu+Tmb5FlhfBA961PVNpY3sXbfBr5A8oPc7hM84yO/K0lYghaIK6AWgze30Na8FySC50dbBKwt/4f0DpoHYdPIrjL2zdHFIOReywQ9ubMtv6TQ0MFDI/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634102; c=relaxed/simple;
	bh=AWV/QXw8xUhXVp8sD9qrlHxd5aoyemegFXKL0T10ou0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rZWB37Qogot/elVQ1Zlk3K+eNFj2+VahwIC9cDDNZze61mnrpCzzTGDGBhgHWSuakW5zJ454rZUZbYX+ImMoGofwp4FNRT7w1phoPE5yTUIio309PEm41pNOWIIZQbcIRYjwN5UGwJo4dnfP6X0FpDVzTOj5lOGrvHrKCePhF9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KtTcYMl1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=bpB80a55; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KtTcYMl1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bpB80a55"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634101; x=1823170101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=AWV/QXw8xUhXVp8sD9qrlHxd5aoyemegFXKL0T10ou0=;
  b=KtTcYMl1XkT9EUT4jw40wU5CE46BqtEqBBKsbavIKsm6qZHgERII3zeJ
   Yumo+Ge1IZtIer8c/mgm+6/WQTcumlreKiQvvd0r33LqPfdNixrBBY/vd
   AFPSZP8zctoIi6UKr7wr6MkbL4fyrSxImS3sAWdGiOIeV3tcVZYQy4ber
   jIhWlXpZycvDTD2DG3O8ISDQxg4b6PNW1gjccNuhhyImDkS/i9CdOfYGi
   ZmINeAFs+JjHbpY63oiXANzDSkmU4nAT874Jy4leGECMoTrZ/2r/HndnC
   aSNWAIPNXNI5MFHtiEiRch1b/ep6oDRFZKNaA0WY+E90MZeEUtKn9V3uT
   g==;
X-CSE-ConnectionGUID: Nlo57Ad+Q7yjb9M7uqtXNQ==
X-CSE-MsgGUID: f7geS/aXTa6xBkLAtohgaA==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="157785442"
Received: from mail-eastus2azon11011064.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CBF29zO3DpT2kf7Ivsox7cAmlthGMXSxzbrCN/msfiE+ghIb5EK5cEEsbFIdDiVz3vJ32hzsRjCDxf+ALdeB3kpVQ7zfOu50kJzrZ/7ZZdmc7+mDYYmqfbUM+TMOg8Kzl26HBqZckSs/kfc/MkCfpjn8F/1QRM68Cgnsg+lQOLkP6v1/Sd8A9vU3AYJTpWI5RPyhKPO4A1/OrU7gMFTe/w6G7X+arhTmL8lPGFy9lYkMcv5hrqEb5PDyXTD6/4PpFs65wUdZMMcPkdAs1kPejudafYPrHpIUTQrfuCk95BMlA3O/4wQq6GGRBok0OePsTtT/HcTc771uE+LYVcsKTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sg91KdTjtq/pDnudkMcE2PZVK8wWnprYLy6WGfq5MGw=;
 b=vcNL9dSYQc2bkXpKOiH9/U8FU9EhBAkeiUzJiZU/AiNewdqMHu5nSjJnW1stWaIW892Xd4/2BJETc2qz4uGWsMc60yB4pO5gkFMSw86770wwJplInD06dTcRMh+Z+DY8sMPO1KVGp3TzHF+rFgACqDun/yIzh1d3Wr9iW52nebzZ8OYlrj5wVugucVzq8eFLKM41bwlHyu0d9ZLgb/MMm0b8IoVKtNBZ68RNMNpWR0IAlzwp1zsvHKarsqTyg1JTLWLm3ymaq2/nY5jBx85qY4iy9jB9kWIsv2gPhO2emRjEgqFk1s1PbwbRmGbkj4duKM5r6GperrlVhBORbEwaYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sg91KdTjtq/pDnudkMcE2PZVK8wWnprYLy6WGfq5MGw=;
 b=bpB80a55p1dEwCbpXFg9vijdX6NVX0s41NAO1h7PJl2PDtsjQA3XEN6L0OgnoFWNIsyPfifaXgGEW/5GSuG4CpDwF6aWoe8FURQ1oCZ3Wr5Jw3uB+Z27UbD4FaXzpSrlisIYzYBsI6mvtYL/ckBGCKJj924yc9rLkkAE/c03tpQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:12 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:12 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 05/12] btrfs: zoned: use the regular allocator for conventional metadata block groups
Date: Sat, 10 Oct 2026 14:06:15 +0200
Message-ID: <20261010120622.3781326-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
References: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: b4418472-acc2-4ea2-738e-08df26c7047c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	GzSol/z+eNZ3fpZ41Hwc4v5VmI38k1URQkLHnFVB3cvjCyxF9BNG4FELz9wjXINQ1BE++hE2ERNBYQfZwVQZTHMFZ7PyQo4AOomtryks9Cldj7jLdAvxoEA23MKA3Z7g5gLDG04wOQ9UjwOmvw8kdGU8l2iMnLyxT3QUvYIeG25ixqO+oqXTWjfKFyRyEYck5ShAErqhFXDVs2Xc2wauzwG8zvzH5/5lG4twPWeWEE4+cf1wLd5CjPaZQRmtnPP/UYGU4gln03DAvhtg+4SQiPAUGpH45vBcstflPkm0Zocc+j65gpJKjF9+hEoB6Et69dJGM1H4xmfdTLolZ/cjl3LJpgWbYmmS9W+9AmgwNrONvPEoRD+uYCYwqnqfUelLRfHEOzQA/b83L6YHov1QCFznUz5dWfbJ4ZkvMsBImB6SWMdWJ/1m11GQr/4REY9McQFdmLkbAQWPnar9tN/mjPzbyLMFBNkLEKDl8OTu6zbyHV4qgCTfLqEeOea2e/VuAgo1H0P/yzpWPERsfZNM31HBshbpOFrMARUln7wIMQcLoRznnMdT+DvTCEGTrIr5LQADcE2F+HTtro2YsSIlFAzeKbrAImXI1c1s7X5WACRgmSc6R88R5mzXOAlwwwg3WMEtZjMUrSDXUV//mOHH5BXn8D5RNIm8vyvPpM7YNSE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HA684+ZYay1oW1GFQFVYa/NSo0PaM9BNawU8B6G8i+J6FUMCyQHwAGaWiQjd?=
 =?us-ascii?Q?iueReGI3R4dDm1GPypbKzk8oN3iez5YyX9VQerStuNMDaSn1yxuQYZjN3//G?=
 =?us-ascii?Q?4j5fYrDwzy8b2AZZOgYSlL1F9tJwDNX2/kDHgDkymIxOECM9HmOo4jKAGXJj?=
 =?us-ascii?Q?+H6IS7eL995XZVQLqC6LIUrMU8LOXrK08T59Z1MSMVNh1OMUpTeHC7mufAx/?=
 =?us-ascii?Q?j9bpTmO2gKrh0ruzR4AID8LbkGeHV/gxj7lMjHY0AsiSXb75i/vTkIe3Sotm?=
 =?us-ascii?Q?8qhDNJTcGX5FBO5bdDV8coLFNI7Ur/8q4+0lvCG05/kuC/UJQyexTFfIbCxa?=
 =?us-ascii?Q?+tYzEhwhvwlONCYhiUOBdSdQ93CyAg40XifKHx9vyCDMsdbzGLV9pkm1CmGy?=
 =?us-ascii?Q?0dCaYxsErIlcHM5CqzNt0FWv1RV6j7ThV2CZRW0KP3E+6gKj1nO2IHZOLI2G?=
 =?us-ascii?Q?fWbH8Mp4qQOrRqJigOYd2VjRdWL99NFNqzSp7BMgc0bBy9/z32qOt2tdQ5qM?=
 =?us-ascii?Q?iiMHKv9W4HvjmfkctA+YULJeBeAgnbooXMu0fx8nzpR4UAkIzBAqXMT0l8mM?=
 =?us-ascii?Q?voXnFvvkCFrwDx4e3pR+3MCKp3z+P/VaEjzLp0nYXPL/oh9JcdsE5oLLhOHz?=
 =?us-ascii?Q?FspDBKqJUMmjsPmpwvtBlLq5yVMRblYlA2QyMwmRCbLsbnLTZwEzfFQooHx3?=
 =?us-ascii?Q?Hfeai7Ti+4Ahsxvvuvz9NKAGrqORrKGw1dLHgqF02e8jUwzwyMSJtXi2+DHX?=
 =?us-ascii?Q?A6/md9qKX/ktIkPspYzb4R5i7WdS8Cm4UKhG9br6vU4NQbyX0StSzj6X63Vx?=
 =?us-ascii?Q?NR9EAXX+/rkcQNW4YdXdC7N5AE9HGQak77QTq/4pT3NA1tD9fEoYJaLp4xfa?=
 =?us-ascii?Q?avjGUADuHs38DtetgVXFY9aX0yYVyQtR3Ac6ABbjImUMQNPX++hArrwdmDow?=
 =?us-ascii?Q?e47fjcOeIx29w9RxJSAckrh2Tu797js61hOsuvzw1jdTOgDOMMeOzLn7Vrhc?=
 =?us-ascii?Q?WkobilvOYE7w0yvvAqfoFZkxPOm8Wn0oCZzlGSfEQYQt7gTXSTJ16lf0/86x?=
 =?us-ascii?Q?r9PMS/iSbdseVfu9sXwp6taem0A/4+lgW4lMcHSMlT48uGezO0D0igNlkegD?=
 =?us-ascii?Q?pBTsl/hzJpZawcrTXArR/AwxRedOyGihcfPWH/HbGDWrYlUNHjg80u8XLZg9?=
 =?us-ascii?Q?AkoBOW/pEGAuPtSRW8E/it3k/2+1070/Ar1ZJR5KTlXycJAXvVL5eEbSCqZE?=
 =?us-ascii?Q?p2PzgtSPYtBhnrhnoJ9y3SAKcghHMEEm1JmDGjLzSzsD5HrZ269Pjb686PGA?=
 =?us-ascii?Q?n6iSk8PrzZwXWRm9qmL01RCLerO4eEeHCSXbu0qpsKYGn86xW6wVEeAPP1hk?=
 =?us-ascii?Q?V4nw3fFfxQr58F4w1iKcO0lFLAz2uC1cwggWw25v3nX12WaliCTMF7rqpRry?=
 =?us-ascii?Q?Inn+KNVCvOONgFgNkNwi06PPCNocJEpTplhCEy5GcVunkDRR+eqKsk+6I+8i?=
 =?us-ascii?Q?pwMJPNge8P4N8zrLnOQBep67gNy0FRUgIsj71Fym+Icdr61so7cQ49gZ1qtf?=
 =?us-ascii?Q?2kkfeKoLbZQK6asVqH6rljY6m4j2U1L0V5MGts/2paaAHTbZBdYiEQgt/uEy?=
 =?us-ascii?Q?PZoiAR8ei9wfEstbgvpLZbGa7lra37y3e81fG5psxp37uLOveL3xJHCqYARj?=
 =?us-ascii?Q?E/YT4zYHtVZ4/ECj2fVeOTw4dYCSli6eFLbi5k18jg4CgxAYx94R3x58YSSi?=
 =?us-ascii?Q?ExSCMQJGKu/QKrfgN+rc2iTFqB6zkmfl+raWmOlTBjbEi7rIC35nMjNoAirA?=
X-MS-Exchange-AntiSpam-MessageData-1: JmjPjLR947xy9w0UXRlAkqiUp4t+c6DzHoI=
X-Exchange-RoutingPolicyChecked:
	izzNlqmgA9TxxAHx8F+cT7KSSeSTh4N/WrfXGH7rMuOjsiIhaVxgxnUw5GP1ERQBk902U4vDjMdSspbp/skAyNgEkblqzIWlLV0TLbjqiKBblQDhnMISSzSUtI2Rqs3qo5hIwJeuWpHGmYDJgMAf4LuDQrt5ZlwbaQ7d0WWncg1XH9ocIurTVcinsKsdtiVQIoKiAmlnO2DnoEKUF+UygcxA6OJ97gqRMmcxVRGr1r2leN2ne3Z+f1jufI6XhFJHv2NvHkuWx/P+3tgUb2ut09dzCXyq4q8qNMKh/uQ2AA8ulqdZ4QWqugzHHUf/RLNE1Ly5/RssYXxrSTfVB4aKNQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BgPognOU42EmhUZ0pzLAhHnxedtAUDUf6cCyk3h+G/Issudby64KMwlVBKpF13issdxk8ip4cHzcR9/K3F0kqqYND92+bMw5GJMRkvDE2w1XHleutC+xJoaRMVjHrjtt8wjPi/Q6NL+1jiBuUxI9b0Ah7LAJTUC+jlIF1wgj7aky7SQJguJua5YLX2xkjN5ZFu+WKvDQQNe+khAfiBEKbLZ/qBK2FzfG7/XHvUd+ywrSn/lHY3xhr+j3cRFZifAAYjCbZ+XFuKfcnE9NubLWRCxvq+2ExJYmQ+lfjtcXplc4vGWwNRDohshAQRqqUtIpgjvrzdZAJO4sRZtUdkmgY6H7qi/T8s/WtqSaaS46X4T2Bs5NDIB/4aM/btcIL3TOYVnp8qqWPJliQ7gCIgoPPbzMTcP1Ea5Dx8c7//1/xbcsjX4yE+uTlKpjKNTKE7F7rK/uliUtP11qhlU38bd9UbFHUPG2xPS46iueDr+i4xfsvuigiiL9c5HGhXlGywNX75812jdlKDzwjCYyzY/uIds8v6yifVJ0FUDKZ+PvHoUjR3xuI2wofqbiBf4q5qjl+3Z8YKeX/DS4yr/lceZElWwxACLFZWp9GOjxl3hxMQQseFVxtXD/4WI/mUMgqD/E
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4418472-acc2-4ea2-738e-08df26c7047c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:12.7509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQCqrhLJjtmEeyjKjBTYYoy0LeaxVxq366IOx2DWmxWF05bbUQUeD6BpvnoP85vXFNvTR3pZ9wpu/nC2R6ghhBN+eXS2phKTONpmNShdbU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

The zoned allocator hands out space strictly sequentially from
block_group::alloc_offset and accounts everything freed below it as
zone_unusable, so freed tree blocks can only be reclaimed by relocating
the whole block group.

A metadata or system block group backed by conventional zones only can
be overwritten in place, so it can use the regular free space cache and
the free space cache based (unclustered) allocator instead, and freed
tree blocks become immediately reusable.

Pick the allocation scheme per block group rather than per filesystem:
replace the filesystem wide btrfs_is_zoned() tests in the free space
tracking, the space accounting and the extent allocator with
btrfs_zoned_bg_is_append_only().

Such block groups no longer need an allocation pointer either, so skip
calculate_alloc_pointer() for them when loading the zone info. As a
consequence they are no longer marked active and put on
fs_info::zone_active_bgs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c      | 16 ++++++++--------
 fs/btrfs/extent-tree.c      | 29 +++++++++++++++++++++++------
 fs/btrfs/free-space-cache.c | 23 ++++++++++++-----------
 fs/btrfs/zoned.c            |  6 ++++++
 4 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index bd17880039d3..34ce3bac45a3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -969,8 +969,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
 	struct btrfs_caching_control *caching_ctl = NULL;
 	int ret = 0;
 
-	/* Allocator for zoned filesystems does not use the cache at all */
-	if (btrfs_is_zoned(fs_info))
+	/* The append only allocator does not use the cache at all */
+	if (btrfs_zoned_bg_is_append_only(cache))
 		return 0;
 
 	/*
@@ -1484,7 +1484,7 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
 
 	if (!ret) {
 		sinfo->bytes_readonly += num_bytes;
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes to readonly */
 			sinfo->bytes_readonly += cache->zone_unusable;
 			btrfs_space_info_update_bytes_zone_unusable(sinfo, -cache->zone_unusable);
@@ -2597,8 +2597,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	}
 
 	/*
-	 * For zoned filesystem, space after the allocation offset is the only
-	 * free space for a block group. So, we don't need any caching work.
+	 * For an append only block group, space after the allocation offset is
+	 * the only free space. So, we don't need any caching work.
 	 * btrfs_calc_zone_unusable() will set the amount of free space and
 	 * zone_unusable space.
 	 *
@@ -2608,7 +2608,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	 * in and be done with it.  This saves us _a_lot_ of time, particularly
 	 * in the full case.
 	 */
-	if (btrfs_is_zoned(info)) {
+	if (btrfs_zoned_bg_is_append_only(cache)) {
 		btrfs_calc_zone_unusable(cache);
 		/* Should not have any excluded extents. Just in case, though. */
 		btrfs_free_excluded_extents(cache);
@@ -3299,7 +3299,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable =
 				(cache->alloc_offset - cache->used - cache->pinned -
@@ -4113,7 +4113,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
-	else if (btrfs_is_zoned(cache->fs_info))
+	else if (btrfs_zoned_bg_is_append_only(cache))
 		space_info->bytes_zone_unusable += num_bytes;
 
 	space_info->bytes_reserved -= num_bytes;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0d5ab03aae2..035977e4df92 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2896,7 +2896,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 
 		if (readonly) {
 			space_info->bytes_readonly += len;
-		} else if (btrfs_is_zoned(fs_info)) {
+		} else if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Need reset before reusing in a zoned block group */
 			btrfs_space_info_update_bytes_zone_unusable(space_info, len);
 		} else if (return_free_space) {
@@ -3689,8 +3689,8 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	 * contend with.
 	 */
 
-	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags)
-		     || btrfs_is_zoned(fs_info)) {
+	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags) ||
+	    btrfs_zoned_bg_is_append_only(bg)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, true);
 		btrfs_put_block_group(bg);
 		return 0;
@@ -4041,7 +4041,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	int ret = 0;
 	bool skip = false;
 
-	ASSERT(btrfs_is_zoned(block_group->fs_info));
+	ASSERT(btrfs_zoned_bg_is_append_only(block_group));
 
 	/*
 	 * Do not allow non-tree-log blocks in the dedicated tree-log block
@@ -4195,11 +4195,28 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	return ret;
 }
 
+/*
+ * On a zoned filesystem ffe_ctl->policy is BTRFS_EXTENT_ALLOC_ZONED, but block
+ * groups that are not append only are allocated from with the regular free
+ * space cache. As prepare_allocation_zoned() does not set up a cluster, this
+ * always ends up in find_free_extent_unclustered().
+ */
+static enum btrfs_extent_allocation_policy
+bg_alloc_policy(const struct find_free_extent_ctl *ffe_ctl,
+		const struct btrfs_block_group *block_group)
+{
+	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
+	    !btrfs_zoned_bg_is_append_only(block_group))
+		return BTRFS_EXTENT_ALLOC_CLUSTERED;
+
+	return ffe_ctl->policy;
+}
+
 static int do_allocation(struct btrfs_block_group *block_group,
 			 struct find_free_extent_ctl *ffe_ctl,
 			 struct btrfs_block_group **bg_ret)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		return do_allocation_clustered(block_group, ffe_ctl, bg_ret);
 	case BTRFS_EXTENT_ALLOC_ZONED:
@@ -4213,7 +4230,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
 				struct find_free_extent_ctl *ffe_ctl,
 				bool delalloc)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		ffe_ctl->retry_uncached = false;
 		break;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e2af75a205ea..cae4f4f38ae4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -28,6 +28,7 @@
 #include "accessors.h"
 #include "file-item.h"
 #include "file.h"
+#include "zoned.h"
 #include "super.h"
 #include "relocation.h"
 
@@ -2627,7 +2628,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group *block_group,
 	int ret = 0;
 	u64 filter_bytes = bytes;
 
-	ASSERT(!btrfs_is_zoned(fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
 	if (!info)
@@ -2756,7 +2757,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 	if (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)
 		return 0;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -2769,7 +2770,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 int btrfs_add_free_space_unused(struct btrfs_block_group *block_group,
 				u64 bytenr, u64 size)
 {
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    false);
 
@@ -2786,7 +2787,7 @@ int btrfs_add_free_space_async_trimmed(struct btrfs_block_group *block_group,
 {
 	enum btrfs_trim_state trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -2805,7 +2806,7 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
 	int ret;
 	bool re_search = false;
 
-	if (btrfs_is_zoned(block_group->fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		/*
 		 * This can happen with conventional zones when replaying log.
 		 * Since the allocation info of tree-log nodes are not recorded
@@ -2920,10 +2921,10 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
 	int count = 0;
 
 	/*
-	 * Zoned btrfs does not use free space tree and cluster. Just print
-	 * out the free space after the allocation offset.
+	 * Append only block groups do not use free space tree and cluster.
+	 * Just print out the free space after the allocation offset.
 	 */
-	if (btrfs_is_zoned(fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		btrfs_info(fs_info, "free space %llu active %d",
 			   block_group->zone_capacity - block_group->alloc_offset,
 			   test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
@@ -3097,7 +3098,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
 	enum btrfs_trim_state align_gap_trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 	bool use_bytes_index = (offset == block_group->start);
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&ctl->tree_lock);
 	entry = find_free_space(ctl, &offset, &bytes_search,
@@ -3230,7 +3231,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 	struct rb_node *node;
 	u64 ret = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&cluster->lock);
 	if (bytes > cluster->max_size)
@@ -4075,7 +4076,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
 	int ret;
 	u64 rem = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	*trimmed = 0;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 761986825af6..5f2b690a41af 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1977,6 +1977,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (num_conventional > 0) {
+		if (map->num_stripes == num_conventional &&
+		    !btrfs_zoned_bg_is_append_only(cache)) {
+			cache->zone_capacity = cache->length;
+			goto out;
+		}
+
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
 			btrfs_err(fs_info,
-- 
2.55.0

