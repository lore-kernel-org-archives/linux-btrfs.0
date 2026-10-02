Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AF443FD05
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 07:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926656; cv=fail; b=VjXfIiYf2E8qBIqm59EExJ4zXhtJXI2Z0rK3Li/GvG2Q1+nKJNGaBS1BY8+NGGAqTKqnnlZq6rY+/bI2spQmqRNSftVS5j1WBGEvtmGnLp7xwFJzUDxzy6rjnCuj15QRSLPDSxOdDt353/vGtOFmPe+TRrxhwT1yaumKZH9u4Q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926656; c=relaxed/simple;
	bh=NYtRg9r5GJDEmJb/8EvuCpNlqwkl8IBij4PQzJFhflM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AE8rt87sDt5wW9KgN+CzNO03HxHpLONnmaO/pLQ1iBp4xi7T6um9Si0H8VUG5WtyPu1ObYZxb7JUYIg3TxQb73audUlk64EHcGcsz/GP7H3ot8NtLRCl8WZGAFZpOxNLvNNC1ZOk2tAz6/jgHnv7NdxCGwGK0G0CeyEoqgjB2/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Ky4sQC11; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=K2iu6tQ8; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ky4sQC11";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="K2iu6tQ8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790926654; x=1822462654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=NYtRg9r5GJDEmJb/8EvuCpNlqwkl8IBij4PQzJFhflM=;
  b=Ky4sQC11CYqDm9+W/90S7AnPjCE8DxpZDmI6EMgmf/3hPBuVS/U8prir
   Tec6HXjoKOb80lMg9ep/ljpCwF98QdumTf5171FUzdKioTWjRE17viUF7
   eFAIGeuj7smnquZ+EMsNBl+f49soM3upCMcY0LopyCFec7QsIxINuVWYF
   tv8K24awE/0GD7+nYTQ0b2tLQikJxwx+bwvf2Kw40dC0y/1pyFxrp2jAp
   E8rO34KWYj3isYU0t7W74LHsKnQn307BhzoiRCmQ0/2LB1ENCWatDPoyv
   36vd0Sq+LjajoVOBqeyY9LcaabQZ6RvL8xM5t5K9nPxMiw0CWsED/Ivr8
   g==;
X-CSE-ConnectionGUID: nPSMgs4lRKqO8QQ7L2N+Sw==
X-CSE-MsgGUID: W/DHmds5QcettzYS4Tnx9A==
X-IronPort-AV: E=Sophos;i="6.27,136,1786982400"; 
   d="scan'208";a="156966607"
Received: from mail-westus2azon11012049.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Oct 2026 15:37:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8ouOaZ8L38dVbzLWjDGB0O75iNbIurAmC+fqNnVxx8LejNWJ4B8VJuKbVRpuOZXQNsLpcEHDvgQVJ8QCVolOzvdgCC7xl40kjlXQnudEONRuHXVlZqFSJIsxSgv+lGP4iEPy/0OAd+8dqa9k1EFFsRtfm/RoGlrPa8v8BI7ciwpkfs+CqkNgt+qhfcR0FzpW6GVYJIpAtZA0PPPTcrr5yU+knKlIGTf2ysyLutLE6kYWCwwYyARyU5xD+YYjoXRWk7Gi+jDScMIcTNp7r/CtLGo4dS9a9umMpPcO2dJB9UyyZhcIHFsLO2OW1pKGZiphWJX3haFS7VORPnrTOR13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GbYN8wEihalvEKLYjz/inpyrs/i9W+1RSBbgJhm868=;
 b=wl64qPc2GgbfDEbAPT1TJxccKWa/YaQFdvs2zgUOqdFqvBMHfP6ezU2wvR3xm+Aorf2ONm2dFb2Tr/+jVdRUPJTmzHOltukIJh6WgGWfAhGCLeUugD2Gy6nSDvWq78JARPQERVHdkJX9X+NMKqnkmb6MpH+ayQZxN3rRxnx0K3LXQkF/6Wzu9EMZlHQIsT+yvvxi6JcZk1nzujHqNHzjLrCnIa0z8npZzpUXnWzdS6d8GpWopfw0W3d2iSqXMCALGRRjflSNbVStLfJslnCXt/uI12d1zkFLwmtLEdK0H6XwKJCVXTPoyWJSzKlx/Sa6X/hywkPfDWgEx2IhSjH3Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GbYN8wEihalvEKLYjz/inpyrs/i9W+1RSBbgJhm868=;
 b=K2iu6tQ8CbINXD15sDdIX6vmNKb5KAJy8e8dWEtgzmy/Pk/6MnCzAO6C2V2Brb8meZOhwd4z8rxhALBeeq15QONKHfLc5Affjz0oKv1+x1KJk2SQ0sSLpsSNfN5wjUCBsvvuNiUeeLJrB7ObZY43uT7/XUiIBLRK4OFPDr95vHg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6283.namprd04.prod.outlook.com (2603:10b6:5:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 07:37:26 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 07:37:26 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 1/4] btrfs: zoned: only change active zone counter on successful (de)activation
Date: Fri,  2 Oct 2026 09:37:12 +0200
Message-ID: <20261002073715.2191177-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: 95cd17a9-17ae-4a69-795f-08df20580140
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|366016|23010399003|1800799024|19092799006|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0HF+oKSDkj5dLhXwBhlVdSF1Nxa4YJPOHJ9W5JpwpFxDavQbppG2m6muWjzxY07+BISjppmWXlueTIaen4NB0Fypzhnmoi5cr6pqhwRA5r3cN9BnLrLFpzskBZPJMSF3lhOnYbmHjtOx4I5EweSuwsMDIS4T62wOHtZL6A4mELrSjO9Rxcixwp5Meh5J12jV4JAu3+h71o/XIi2008DW1bRnUBluzFPagsFBwy8RVX6B4Xy1hPmYPlsjmXRgKdQxhTjZVaiVcybM/RhZ86VbJ+PfmiGUgTYmzdRZMiKeRWWOEejo2qhfjmcNQRfbOn9ZvZAswP8Ve4cUEk+mOEo/FhPm9yYYS4q8hUb9wNYNhZBFWnLFMuTVpypqGyqnay4j8deC/37AxWG6Wxx2ZTWPqvy/KxXmasWiQgML6fzfRcWF24m3JLgy5SUbNtmLJbFQszoV2/+tzVcWVb5mKR2hC31++LsfGR6ooL8x71pLHgeLr/2QRWtLsflYL4N1yoq4G4SddLKmQtsQ0+EvhALTFgQZZGzdDbo9Sll6A+Roncm9GPaPyqqEAUWxdNFjEV0cRNqSv+FUjHrquXTjD41T9OH0hrwi8J6lGKOjAhVspnq1G5tAOUJYRfMUKi9M0NS1hiN9/VnLYC5QYAUDQjR/wCOoT5xnkU/5+l8Cr0GPuNc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t3FnRqiQG7nSTBCpsOhL2iSSqmasBlSvh2KLXIH8qx7wd9ZS1lDGpG9pNZRt?=
 =?us-ascii?Q?sSvKjrvShUbdTMr5SHLIp82Vh9jOec2lsvwqE7z1RETi7BVuftP6fhsne4qe?=
 =?us-ascii?Q?clhbePd8DC47jS74mI/g9HvZ8AHRQiBocbKb4oHy9GmBF0xpT+S0qyk2jwuJ?=
 =?us-ascii?Q?o4k5LFfDeBSm7M66HwWT9oCTys7uRtTvScsktscQloBnqCoubznR9799qDyJ?=
 =?us-ascii?Q?YT8zDgvvhWmR7CFVQVu0a4BEYjJWYjzdDRnBRRQd+lB0NmNM7fz2dyG2iNZn?=
 =?us-ascii?Q?YEuyd75GwwZ9cRKQ/lfw43rwVVbiWsKwHlC/t2QSEcXu0lFmfDpnFS/CBYkd?=
 =?us-ascii?Q?wCoMpEldRs//Eyxv6yOeiUKxMgRn/h8u7IFr3yxSBkXx8zN/AOgYVPzVtH6k?=
 =?us-ascii?Q?xpMd0iYBIGCir5mVNvG2Q+LGgOw/6si1/vXo0MQOTDWTPA4C95jOzVRVHX/v?=
 =?us-ascii?Q?hqI7Sb0EYulBR0TgiYDEhL/+tpUCfdw+aaAcivTxosfR90vpyo0lQ8so+lG2?=
 =?us-ascii?Q?0WPdJX+QetpPxoeAGAaBS/b8q48lLQ2dAWU9pGUT9m999VAsKDPxJW6PvGAF?=
 =?us-ascii?Q?TbHhG1rlSDgTAry+HDD8YyBF+ydN0i6NakqVhsdK4lGfgpG07+rp+e88DMpa?=
 =?us-ascii?Q?tT80vySXx5Eu+yE3hwbGfXOXEO1e0jjYenJVWlSV2FsBlwgnBP0/O+gtqrAP?=
 =?us-ascii?Q?8xIpIO9uAgMdX0WTHumwLRG0d9wwXHWDIk8tgzNb+453higdn3wNjUqwvIIP?=
 =?us-ascii?Q?K7XTHuz6SyZWYczVMQzIKkUqyx3/FDo/0TD6UaucyJkKfEPXO6116gFlMZH7?=
 =?us-ascii?Q?6dIjIfXByZkuZoWmc7vD/k0YvT14Yl4QVpO7O9xhiehByoa0tPcfczbmMGIy?=
 =?us-ascii?Q?N0WvWsZkjX6KZvIAMAvG5aX3Aqdn2PbJEBCnswbsLtz+1agKNxFt801W6dnA?=
 =?us-ascii?Q?RCiMj4J2+C/4edn1vd7Ih6NJdjSqkm/oC6wbHO/jQ8wkAhZo5GGWl0+uC0ng?=
 =?us-ascii?Q?a8WAeXmLXU3o7lUhyWwVZFqjp1v6waTXRK6cpfmqdymW8xFMwSxX6BsWHiJ5?=
 =?us-ascii?Q?SQd7PqSDuPwQP//7FXl8s5KX5xNrbp3B5Eq+3urgx1hjIyK3MQoHL55SpbIH?=
 =?us-ascii?Q?HzGB7bmtb5O9fzWvCznWvoRYPVMKyLyWN019YX5oKI/VZn7ylc+ykh/hTvE0?=
 =?us-ascii?Q?GD7ocWKlPwU3SospIoOnQBOKnq5bDou0LuM/37x8RhKuKsVB0bPWeII+ZQdp?=
 =?us-ascii?Q?2KPprLo/hddWRdSmqtnMNpz/r5dtyvgagvkbbas93uCqQ+633thAky9j1L07?=
 =?us-ascii?Q?GVuhQW3WEyhmg80w+PshCoY9fD7plYERa6gUS9qXrCswlQIeDdK5s+402Iw9?=
 =?us-ascii?Q?1lkDi2p8nI3K/9Ma6E1XZmtzq8IoDho0Z5Xk2t/EDInnrhzme+aqvkFo+qEV?=
 =?us-ascii?Q?z3ZkLfLuBs9ReLiCzbzAT7COGRKf5ILqgh+2XQ8zUGihdzNAK0gqllG4PDAB?=
 =?us-ascii?Q?JvlK/fRlHUPdj1FTlcW9SQ/jlKyQ94IISfoA8Eoukd6Y/Tel6gAIKDXDaxUA?=
 =?us-ascii?Q?92aNG6+aIR85N8EJBZueXuif1/9TuGbt5uxK7A0N9BXtN3o2dY2wknImMyyx?=
 =?us-ascii?Q?fUVfxaQf3tLjPKjvN9XUkC1xgtTNhc/AJaWb81ZwtZZx3QKeiq5Scds7tf9X?=
 =?us-ascii?Q?rwBHlcV69dXz3qFmAoOaZGAv6MAdrzNem0TJQD+1mSZ/HVkhsZpJKi+hVq2b?=
 =?us-ascii?Q?JIsX6w2auB2HVBaiqHSi1pl9d2t4eKVWyX2uaMwS6MhWIMoF+8d6CSKM+l9+?=
X-MS-Exchange-AntiSpam-MessageData-1: EjUknAp7D5Yqeyq7k3ADUuH1KPnW2ClYw2U=
X-Exchange-RoutingPolicyChecked:
	IPnbrvkDlweJNNreLDQkerMGoh8ndsP7IIwi5zM2OUxR6WCuZGMAIg0SRnYe9/pqMu5DO5uL9lsYowvpY5inaW8pEBxKmM0Zx2tlbCJXQFaxkO5TwQYqHeLjaY2iDduQKbyKuCXJqQwaE+TnAvsfzteaNBECQJaYIk8s8kzcCI4LJ9kzrQ8g6HBzxhU3aEa9Qpk06dqQ2QxpjFk14zyN+MAko4syE8+8LrKM5oNVlyibs9QviNA6MaOJk3xZEmnoAfx47R0aeFuEPw21wp3PYDFL8Z8ftJe0RDpNhLblSDh6j/Frb+QFx2t4NvptcB9ZTKJoq3tXgij7NL17aLvwgg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7WvqTM8qHojX6AspxQyt2b4Rx3VORLiRYBd1wbSPmj6U7Pb9wos0WsY9jZ27uuw51Cgv3J5xJxdcAcjx6/qbv6Yyg1uIUctWzLIpyUnZyBp1nZT0AES2aNyluHv+ehSyxqnKWhBipfMklaxd4T9EGb+iKSeQEyp1qOxhlWjH4YwT4eOQHR8fOPcyylP4YOt1didaNiheJC2CMLtfURyAgyCkt2e96xZJwENiCK6sSQH7wekii9O4OGyVtOcJI2DK1TBzuCI6Ues4xZ0NbCygm93dTvXjuXYSqWT1dt8xiaqOgI46SObZWkVd4ADbLno5LFMwJuH67l9fHyMpekFklms4ig/QoVtNYn3hh9Jy/a6ZrxRb1MWiAMpp+TgE2+Ubzwke26jhowQHlhPsOv1AH442HErH5o9WkQ2nLz5YmsAjgsb4kZwkM6kjoTJNTKhpw63fEIwzHu2YZGuRxxmiH8hIQH4rngrqb20NKcOH0I59lXB6Ej+7wC9ZaT7+YweH9sQMzqZH3MuqXUcBR/nnea3tx9C37i7soXGmf/NldZfGFoHGZOAWPmHyZ2dPFiT4DCpETe0CcrIBGgsJAAuhpZajzHTM+NbPYTcBZrR9ST3E6lmLLtbENhUi/iDJgGJt
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95cd17a9-17ae-4a69-795f-08df20580140
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 07:37:26.1960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0M4D9lldG5YnFyLcdSNgUhfcPYNljyQYkL6sBZd0GMsfRshFWRT3lmsNQGvkwmIXsPMDWjA/SLVPe4HUYP6+CTMJCgBVKJ18A82Qaaa5bvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6283

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
index 9f562cc34e38..d68b91008e76 100644
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
@@ -2411,6 +2420,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	u64 physical;
 	const bool is_data = (block_group->flags & BTRFS_BLOCK_GROUP_DATA);
 	bool ret;
+	bool new;
 	int i;
 
 	if (!btrfs_is_zoned(block_group->fs_info))
@@ -2464,12 +2474,12 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
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
 
@@ -2516,6 +2526,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	bool cleared;
 	int ret;
 
 	if (!device->bdev)
@@ -2537,9 +2548,9 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
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

