Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34444973B0
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634101; cv=fail; b=CKvcslMIPv4gYEcwzYBRJBbfmQDJo91dIyDfiEalPFCWSpfH0ivGaOJmIFFldW8Z436gUz2kogYkvZHaMm8xNoAq77rZF2vMkkFWd4SS5qzOr4CzH70Oif1X7Ld8rjKshsEzgyFFHdP+CfKMfN1Rz/zyHMBUdKCjuqnGVuKuB00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634101; c=relaxed/simple;
	bh=n/98HgaXZYSjuRf4FV/TkzizSt5VLC7WQRsoPKlzPtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JEPKuiyAR6IUWAeDnkWFNgMn3B5vhny1RSSyfN4o01jMoqOzan/yzd023tBSo8KGYbnzjlGWvg5+ubAmJAWLP/PHaDPw2pxWA8LUhYz43Ug1A4JEQQoQ4JO9fYnre5bzbeMDqaxopUjC+DM01wjnRn5ovlfMSLxiGu+tTBPLYTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QzI6xpWt; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=PDrKjijI; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QzI6xpWt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PDrKjijI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634100; x=1823170100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=n/98HgaXZYSjuRf4FV/TkzizSt5VLC7WQRsoPKlzPtA=;
  b=QzI6xpWt69yqKAsKZ+RZ6dQmlkS8YqWPG01VeAshd+0f6uSCOb/KNYdE
   vAwp7rA/uazTgbNx2ycg0DxJYXNlSs0G+n+ZryEpLgkpOljziSjmT3+7/
   Kl/lgIIVv+nM3DOPLs9Y01FbRmqVCeqUO1Re1bcpiyGvnrg6XHNVqcWX3
   XnxeN3JClkL+YKSwskFbEuG/BoVfkDEs6Xw1CX4To55hsAvJzxMzYP6ll
   NqUDCdjyliHFI7xkguTmIxNl01GKBr6wMtdDNR7QKVB8zfVJh4FC+4aZV
   Egkzbh3BjlAddRx5sJD6SgDh/4bxULbS9UKKao8+mnoatb5vzRe9aA6qo
   w==;
X-CSE-ConnectionGUID: 3GTSx0zwRGe7TGHxBelgsg==
X-CSE-MsgGUID: 97zsmkxDTze8KyVfoaO5vw==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="157785439"
Received: from mail-eastus2azon11011020.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.20])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQexYWCm63H+uPQ/aL8E1XP12Q6QuJdvsb2TGx1kqP8l6wtwdY+3QIAj4dsmiAx6TgiuACbhUHNRw24Sm5fRyw3rMeN9PUK4sqXP/k04X+wZlol/7bmGJuggegqOe3h5IKlzruZDjkFmqjPoEIfrfKCmRXVGbCqKBLtrK3M7ov0VqAMRFTRrQMbf7MJDZNPt5fEoB8GTNAfbhjvhchTIB1Vz3C/5IM7x10y3V/VO+DulD0zxKQvbrHMsJ0DlCbFVNQ0pbCdZ4TpQbq8lOeJXDXFKV4/2I0erv6Qm+XNmiN8wLbr50vkEqusnkWUU8o9EIi3B0TwqAxKby40uS2PZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ApbWcMrrEJUxnVrRpo30xzs4m0FFf6Em0YHGeNIWRg=;
 b=NvXZyzRHeNPBsfqqbIBVJhQP9xFoH1TOENJ0GyeBGHg9RcRAFPnf5mgRTE+tqBNEgDXhHg2zIBxwaw5lcey/hYOrDIKYmGYLrujND6KCd7RxZUk06zvMisxWe2iTw9E2SPDon/V1tmrfk66p/92MH6FdajWIbTQEbvsuoUu2us8SqYHKhGL+iimU/QSXEry9w2uO12LOTwl3eXi0HJXl1hK9Di6pJ9Xprx/J43Ks1iEjfQ8lUiM3Ykl3ZjW22ftjqn8GxM+gO7gdGhyjKmjjdo4i4AJI52a27TqZdP/1UPtHQyK45fhYOieIS37Vqsulk7xqcl9KEUvfyybRfVsePA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ApbWcMrrEJUxnVrRpo30xzs4m0FFf6Em0YHGeNIWRg=;
 b=PDrKjijIjafpHJtg1v9B3PSJpy17Wace6tQRJ4ZANBWBacDesvAPZ/zGnsB9hUzEngRZJbedgHMOV0Qg53liaUzFroIx9xwusN/4WicjeDJT6dHBXcMJjt6tEKPqhgp7Dzf+D9kokp0XLDOlOtGuE4gdvW5Z4AjbjvT9ugA4Go4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:11 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 04/12] btrfs: zoned: never activate conventional metadata block groups
Date: Sat, 10 Oct 2026 14:06:14 +0200
Message-ID: <20261010120622.3781326-5-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 09d4d0b3-4f2b-4bcb-5711-08df26c703ba
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fTlLjJL0atPX/++9qULrOnk2rD0b5atKE2NlWVh0ssATH4eoxoaBO/cymD7P6gtHxFW2qqdVdYWeuKPQTwAFOfdSFeFkrHhhHqrBVbqWeHWIRbrxCCq3+9G/P9scnwrA/DS1UMOJ3bRbiOAx6j+5m0TAwbn8yA10XfVx8iPUz47QdshdftQz1SQ1flcOM2zZecmJu7c8O1trdvCziGXfHeJjs4VmIw+Y5HJ/fNT9vnnVoBSZywnfe8soPkqQNQ5sXJ9fT5q6hYhKdIqmVoTjLoHx7QFdCg0mveo3FtsS9Midd2N41UqkalhONT34PS5hBfUvs5d9AMV4RnQvYm5F6w+9PslFELUR5ajwyGmCwBTN9exqMQhsgbjYZX6ish1SwhHMjT3LWTppITw7irnvF00JHyQ4rP7RRw3HMnUILYvGdMMM5a/XI2ZX3shEK/qsG62Jea8zSv2i0Vzw3z7llNDnkbtdK0I2qz8t7kJ4viggr3p2ZkCtNvs5XHeKIlJhAGnnqiU0j1D56eOP7xF38dqEB0BmrZhsCbSOTrrsJXNBoiUY/zpdCYJOZF9RQSjRaOwCTsoVsM6VFcPbOeG8YpR8ZDqWJAvfn/38A1mCkSY9AWdy6hmOCD2WspWPimIWwtsK5QlsiBnhBqu529hLUQMHjLtfwGIAsh96dFG0JWc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ir1JDfbLB/mYpYPKOYTQwdH3EsO1AXji3nWrak7mSvrkUWkAr97gXiim4/V7?=
 =?us-ascii?Q?5RpXYeTJoA6A2JCBnGTvpRp7EjreY1gZdFZkXvkAacpKzbAk3+MAZ8iKeJIS?=
 =?us-ascii?Q?BkhpOJOpR8ihpZWWSN59863qysxS/teHkqw/XntCjrAApJnYWsA4Qyh/Zx7V?=
 =?us-ascii?Q?rhPgM//oBSZFMIx2uHeWJL3tSb4H83iCcPw1IlBAC9gRs8b5Jr1L8nqTI6jL?=
 =?us-ascii?Q?wQUsbzxNAt8gD3qT6lKdS58cvRKrqKhH2+95pHWQzgfIJIyDgzdPoqm9orjl?=
 =?us-ascii?Q?OX0RJb9poBImA0tno7QDxbWaLLp4X/BsEIsb9JYyBcDdhp+RjeYLioFvNY5A?=
 =?us-ascii?Q?yV6adWi7dhpeNfBDfPPl9JTeYoDMzNReLSjV1MFB03DYcg7Gv7c6F961/JCl?=
 =?us-ascii?Q?pa7LGenksSnj8S1WRli0665IJD8pgDsFXTNz7mdx7U8vA8sD2SRjU+aiFEVl?=
 =?us-ascii?Q?ypX2S8ntBv4BOxN+QPh3UighQQhOzawgKdLrFBhWFs4v/RoRBKAgtsr9aZYh?=
 =?us-ascii?Q?601E5wqSpIuli+RCvSlpaZSltxLDSvfgDOGSq0oNpDyXz3YRivpYtNmUjhAD?=
 =?us-ascii?Q?67oTi2i2ZRVuPcQgYej4wcG2RYQDhCfuBuGXLNi3IQ3OET9+vWFMRKOId1ww?=
 =?us-ascii?Q?jNuEiMeB5b2pBZP0a/6OGEQQBFNxiYsazVi4sGzuv2NqU6yBL2x0yPfV+cP9?=
 =?us-ascii?Q?pu2qd9zyKK9jqVCjZPn6E6+2bdWpl8OoX/5cEbquu8vqAR10S+hea0rOJIya?=
 =?us-ascii?Q?Na/4lUTACQMdDuYWckgGpO5kINBWnUgDqULn8vYo/ofQCwJiL+G/AO35rLLu?=
 =?us-ascii?Q?P8jhQMmq4B9WrHU88Xk6HTjlBenj7kwTWhQ82s4/HKKjCB1O2zm2jPlXu2ig?=
 =?us-ascii?Q?0JFubK1CRmEI6Vb70AcBfQYgD6rD0mgD4y9Rfj/Hjk84bM3r4rXHq2si9MW2?=
 =?us-ascii?Q?sUympBpg/JA3RW+G1nkUWXO5bgH1+a8g2uFnbu5I2yaBmivdBOcN0/ivQ6Xj?=
 =?us-ascii?Q?PrlPWlkMgfjbtgSZTFmHpHLnXKUoZIQKK1bbzKKDDope35MhJBixDe6/MFiO?=
 =?us-ascii?Q?TMY4vH6yfWY19kU/NgQq84RWbq8j5Z0Wd85iZtJOkqsBy52da8mV0DitNbbt?=
 =?us-ascii?Q?2pMDqm0p2x0vJtirhLQN9833Vt8KXvZDO1ZPW9kSWzSHbhOR9gqc9yNooBZV?=
 =?us-ascii?Q?QXIi+Xpx1Tmn6yZu26cNkLNT7c8ap3L5CSpvjCFDMe0lKV2f+OxqeECSHKZc?=
 =?us-ascii?Q?pMVnnsjcSy0SrB/PUbJ5K7X0qKMYnuE9j52BSDQQvbkWkSLEbpZy8DLpwNMA?=
 =?us-ascii?Q?wy673RxieZ26oyYl1yEBkrzreijTZ7gJXHeNkQV50xChXZXi4pKUR3Wlls2r?=
 =?us-ascii?Q?Mv+fzKL4qRULS7O2lRFh/DCrNqEhPbIU93ZovFurOjh5sK0B1UZGo+xPHTsN?=
 =?us-ascii?Q?+duiPHQ5cv4AUROWVlKbWhoqQur8rsg5LIM57ks5YsafwkprTLINO8L+yhwY?=
 =?us-ascii?Q?7pS7kj4VSgZcnS3s1ueeP/WSsOZaVvXBfePvtREf8NTFad1YMSNSSG0EiIdR?=
 =?us-ascii?Q?MfcqhNnxkU1tEp6YLpMesnKjPb6s57xy+dKof1CVuma3NdsMu180L9Li4wCM?=
 =?us-ascii?Q?tGn9oG8nmYR+EcR2l6ppM90edhjvmwu30vw5vsCW+CLWQMXBkI4/6TEhTEVM?=
 =?us-ascii?Q?1nM/Wt79gYTfUB1FFIRiXr4hNdBHLJpVVrvxdHKvwv+G3g3jhloSEhjsJY/A?=
 =?us-ascii?Q?TQ+/q4DAoCllNZljX7p4vowWnTptnWW/eXZ4B0qP+S9SdKktueVcX3LKtjPH?=
X-MS-Exchange-AntiSpam-MessageData-1: gb+wOkxDh+Fz7A3YwoJV4vyAnZpcb+r3ZF4=
X-Exchange-RoutingPolicyChecked:
	Iw7l2vQL5akFG2zIP2nO7qAjognrIJApOobA53jFoZaG3yMCbkTv7GKlf6cR2AfcDEG0sFyWunaw3IkXux/GfsJnU6cE3AiokevCjzMYdWofZp+L620vi/6QTSFWDL1bNkLWbwrxLALaV830L1HODXZBobHel/AwH1dbkNYKA0mXE809iW/TPYF0MzWMd493tPFhWJpqXNU4MGKbG0mOC1egW7ZChqvJ88EHEQZaryguzohgYyfGk/J/W58viW8463pYzizZBWFf28hoenLGAcNw969SQpb/WuwczAQ9CESU8PYD4jHFIdQpHABDcD3JFPX/00Mx6eecTu1Mvb36QA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a+Z8DATE3MdaveHTqSKGV5i3XM5H1IVYh5n8vdMoU0FvBkAPobKdVjUgUp51bsPfBBF15NIn6iAPrBe/eOcJxsrytc8uudIulzp0w1jxK5IC7v5x05ufVtQ4MwxgNmHDUHd2jkNSiSTBwcqjWKJ4naLMIeG/xwXWQgk6QhAFZyV4+y/XsxVfIhcO8/5IsQqHPQWABZULysJ+hpwxJsrbI8goiF21Jp/17SClc0a0hUZhjiRyjyNN/fJRzEvGcsA5tjWovDkIuIaq4cDGDm+Z2qmYe9XFMWTXllhyPiTq1EoG4Oodi8I4hzflLIolzoGWLytnPTEikteAFF55x8hyV3L9XemcH9iXw6pXnhYUCf7ZsBBZZFErtLks5tevVkDiLKJ29v3Vx6Ah0T90OkHewa2QNMvepdrXeNvg9wxjPbpNXa1kwQ2LTbagZoGoTh1Zd7PQIS0avydEX5wQdKCYu6zQYvE3Ow57it00vwXHPehZWwNZxcGBz9/avYHWZqmeGYNV96AlNUi9bloQ178Mc8N2TTQytyye1+UEWONplr6Zk1Idc+E6/e+43OWv9yESxrsH15JpavJE23/yii+/9vdZWl+2UXQbiQkQeTiHh0SzmSohaQEnnOzMddIci8j0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d4d0b3-4f2b-4bcb-5711-08df26c703ba
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:11.3491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BQcvRVHsGgi5oGGrjlSiorEmWr40gXtRBaZEhO1fF6MbNjrKbOKWWyS7IOvy9ff5j7n0JV7kAyUfc02JPkwvKOmHzyTM2O5bT4YKStJdiHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

Metadata and system block groups backed by conventional zones only are
written in place, so they do not need a zone to be active and they do
not consume any active zone resource on the device.

Make btrfs_zone_activate() a no-op for them and skip them in
btrfs_zoned_activate_one_bg(), which would otherwise report progress
without having activated anything.

Such block groups are still marked active when they are loaded. That is
dropped once they stop using the append only allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5d1bf158b7b6..761986825af6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2457,6 +2457,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -3054,6 +3057,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
 			list_for_each_entry(bg, &space_info->block_groups[index],
 					    list) {
+				if (!btrfs_zoned_bg_is_append_only(bg))
+					continue;
 				if (!spin_trylock(&bg->lock))
 					continue;
 				if (btrfs_zoned_bg_is_full(bg) ||
-- 
2.55.0

