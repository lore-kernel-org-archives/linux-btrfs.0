Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602663;
	b=cn3DFfmyqzRQfxfGjt6vDZRucIIBf9kWu4566DF9ja8mTymZXh1RX70+D0dyJUKxJrzR
	 TeBrLRhqYrCdjcoTNBcfrT8Eh1+piNsedJvT+ckuEFdzJm33yfqh2tt0VPm/CbX3BAyby
	 Et8hlWqRrmeLA4GOz9Fagwia8O/fi346oVqKkw9+bPpMDX2OkcSe0UIf5fD/6gIbIR5Va
	 lonLZOANouFl763kCDpSsHr73F7dOFYTArk6QSASC0vbSQBw5CrnaxvGBeTCDBaKfPwWN
	 rm7aSIdLB+IAIcY8sSK3v+xwfJkAXk6/HmcrWhNNtzL97nWmASx7I8N+gQ08bxes+fg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602663;
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
	bh=wYk3ZrLJY9iERHLm0WKtWw2Sh/pGy2Q3Q2oJOgSTj7Q=;
	b=HlRNlW/qbZooGLU09vq88WAzjkC7YrsSwiQWB3bSQBYNWc/jJCWbSIm73pXvFNC5vwKs
	 PwugPIkPSlfnIdie/6km3DoHNE2KZY1mMNLkTqeNaQD47W9FYeOrcYWZ9eoYHPYxF0N34
	 wl7EoFYfhGFjT08rFDyLBEPeZKWDZlDE2PIbZsJPn51OesZiJ69IEz51RyDWE38Xkxsgi
	 AoQ1Qg9GSL+6mjTBo7Uy97pHXZccK5EOlBOfsvrnUVGwV8DWfbpfOe/YWCD5f+nXqlcd0
	 PCydgkLSs48oRQ8IDMJRiGElljKQHeBf36n2He9O9aQH4T+hJ9sinDM798SajBOXA/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=i7+27h4N;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yEIh5dIC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD4C606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:31:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CD4C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=i7+27h4N;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yEIh5dIC
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602662; x=1827138662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QFKUz2/0WnJVEg09aEBkZT5EF30JAJEi9SlWC10PsTc=;
  b=i7+27h4NkpRHy0b6PejOVZxzAOFoT0ijpaRh+DzmKh+fxNVCpBpsybhk
   Y5N2sSdZYCy0EYugli1VmYnENXa9XYZCuciH+M+seQz8cl3j2INJ3Ok8D
   Uyj3Lz8Z2mWMGsBR7zOwqAkjKLpfLDDbB1jae32rcEsMuKCC07sY1gXBZ
   D+jgGJAxJWPMZtjJe+0iVGssBhaqaEz7zHAKN/AC7OKmptBWlOwMd6axT
   gWkqISwctBke7fe+udkfbdtSAudshnioFFmXgAsrX8cKGRlTx2mobxh+1
   0Xi3yrFjmRJEjLorrlXglqeQT7R3yfUHvM2Ann5TpYBbqUr5VvoVz+XDv
   Q==;
X-CSE-ConnectionGUID: 2+11U+VMRt+v4/23Y+JaWw==
X-CSE-MsgGUID: EutNRqVcTDKw6yO3WE2hfw==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492445"
Received: from mail-southcentralusazon11013051.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:31:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VkGVwJinnwNa6RPSQbbQ57LcCfYRScoU6Lij/eATvTbpXLtW3uuTtbNnlemyqZaJS0LnRCKVW7oVpXtwnRNfkT/hDYEONfxzKt0tsrvr4jBGqxoNL4gQMYlFGYf2UHxgSgAzn8m2md5ivaVbYegWBL35+GqRoMoewZ365PXCONSkJ73NQi4C18H/HMrD1VMLV3rwhN8Ny74H7CqVe9C/niwiKuiDqwpbWIOZhem0pO0vbT7ZrKbqa321mWQctfXKzDvw8SAG5Ix8OrRlZG9aLBrzqOujhJNGQBDn/ANG3LJmqYICIGHW53bHRfgNoxayU3zEpkWRakGq2OfA0qDpoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wYk3ZrLJY9iERHLm0WKtWw2Sh/pGy2Q3Q2oJOgSTj7Q=;
 b=SH+59ffnykFOrxKotxvU5zVnbubJj/fAmcGx3C9Wbb55AuJu0WQfiPOKKU+AMS5LcEHSC/SRJPhuaj9gAMTdc4nfZ1+7bNB84A8c36XY1SJXEZ7jOiJXqLzk3PR6wsgLTLjN6x/xQHmzMQoIzcQ6woz6GWIt0ExbsGAKVCqcnN4U+afvNKdoeZSDL8pmYSso0euQX2h+nyzyI+eE68wn2k66B1KmfEhGjGdqXyy8Nf+H+AtWz1YNDct//MznxxRafvuxBf8ig+aaUXo5k8Dt7pwMvLiw0N32cmwfNtopqb84ZOFR1FiZPt70UKg7V7uzajNAo9E+gJXWIo0I/hWsWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYk3ZrLJY9iERHLm0WKtWw2Sh/pGy2Q3Q2oJOgSTj7Q=;
 b=yEIh5dICXSWHlhB2ct7sY70Ur7mBnzERyJjVBcASoO3tzYQFj3G8GV85XKeiiT2/eKaY4PmMBqdFodzF4wZqEUdUDfq1UGBOsVARkET5q9go8+TnEU4ZTpfzsn96PB65rnAk1fjXlls72PmfB37e3yPTBVr9t+vfGan/1eQY45g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:31:00 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:31:00 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 20/27] btrfs: zoned: prepare reserving the data relocation block group at runtime
Date: Wed, 25 Nov 2026 11:29:49 +0100
Message-ID: <20261125102956.266389-21-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: 9645cb3f-b81e-4ab3-62d5-08df4adf32e1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|10067099003|261021123027099003|56012099006|11063799006|261009223027099003|261026140227099003|5023799004|261102123227099003|261021121427099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	B5qV6pB+juqIB5n0eufM+8QCcy0UJqyCuxLJKunlzbV+BfOOr06uIxICjHuXHVamqFlVSJzgdiCr5zJsc3iclGViWlYuiDeTAhhAxUiB96TLvG6qitKjqqSZ7RPtjGykXXEE8Rwl//eQAv1zvYjldIEm943RnMDzhhpPJF9/t7r/Ai4ZVq/6gJUyeo4J78H4/kBXIjgH6eZVgPeAyEfAo7F/UE8L0B+psVP/m/hURdjIg9WGoCLACGVHDJ6S8KN/ba3G8IRt229gZgVZVHUoUgwVn0+QJW8TY1wP33rqEDlZRZzKoppBtUoDs0n0LJFsGdxGy579Mv5MHGYohLHFnKDM0LyKqrgy1RXp0vbbhnSU/IeTIf+9IUMA0MNAof1AP/KC1YcYSuU9RboPdd+U1qQlOZPC2bLnXmDUAPkrdvWyYlFIGa6jZWgYBpfP8GG6iupDvQqJyi/7bMYn7Zwws0mfOpdbxKuCNrm9dwCwCwEgefvyMGcwq2Z5tF+aIsopH3IU5mJOidMGSiW/K+dZisPaPHWiLfWwe8o+9jdQviGIcUUwVYljzWqp6cOb1c0vSpJdaB68UirhVF9ZPAi+DNJvGY7ngNsfk6uux1bP1LyuIestwtytNdN0WE0JzXsU4gA3OuVEqWtWf0HgrUvWAWvYiLsgXcO/D81ipOXZxbc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(10067099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(5023799004)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tU/U/fHdnYmMgrk28ESmX3WtIfGDYDNvHDChFuxqLyBVoweYdTrs17in246U?=
 =?us-ascii?Q?wgnbnkCoNOJAvnxTdlvDkohXxr7HR8lsP1FRWQR0zVn3tWxHUiJRzFWyCtxg?=
 =?us-ascii?Q?dKHl1DaXzLRwzQQeBd3hmWKXmEZFdquvc/9hsaAHgJD9L0fp0YU2Dxb739jY?=
 =?us-ascii?Q?CCWfwEsFLdH5Ucayp959Dp/18CPJI6AfimRwvSAGxzrGP5BxWsjQgC1+4F+u?=
 =?us-ascii?Q?n80xEJTfPqOGNegqIBHUZjA404nW2kFfwE0NhqIzvJ5XUOQrThQX2absSN1T?=
 =?us-ascii?Q?UgZfnS26JBWv/6kAYc51sBDMwBZHMra7FQs8NRT8ZGZ05NVmy+51Yqy6W7XL?=
 =?us-ascii?Q?wS2fQg9bh8Wl+tGHdotbP0C7giAXZ8eMUsfVLXXtDgpYDO7jz6ZJn1PrbBga?=
 =?us-ascii?Q?V/MxRKEY6VSgOvCSGYhDQsjT731pWSBILw+QlhkRJZRC+jKxZwz7Hj/Ebmsu?=
 =?us-ascii?Q?mFbvr+8U3EYJhYrwKeP3HGK/JFIrJoPZR+bVkwnl50GaxwsCfWhN0UQaiSL3?=
 =?us-ascii?Q?kUfGboufItL+Pe8kx6xmoAEWlKbkXi0/gRzTQHUVj0OUuAX1bT/k6YU2Tjag?=
 =?us-ascii?Q?f4eTzR2ZoK/4oWwCtexl/PtuIIV1Z1WbELAxGsRFNLbTIXx6s1JgsDImvVBd?=
 =?us-ascii?Q?i4j8Yd8hxjJpDDdhxwsvTqOKAt+ylwJ8TbdX+NaDrrKkcj0DQTlLtOW4LzIj?=
 =?us-ascii?Q?ijcsOui1VN6Iiqy+pAVeUQAaa0XdjDFU9hci7oZ7snhzvSPJrStpDUxwcnKr?=
 =?us-ascii?Q?MjNz4dAtrh2hIK1CMxLRXqinJ+cLe+68tm/q+5l36/ZlRKpbpCZp+JVp1X5u?=
 =?us-ascii?Q?4mZvHB4pmCX58AVZVgDWVLmjzLh7/xpTpfZXZeJAb3yZHq32hrd3qPEBvA3q?=
 =?us-ascii?Q?0/4XRi82CrSeUNPEFSaWiTWNpAgYnonMxGUhJ9AWaPtQoUqwrZFU/lE506gk?=
 =?us-ascii?Q?2uuvBD+k+bKVGxTcD8YA5bblfrf4P3rXXeCwT9pY4LuuYxFkFBwuqZDX7uCL?=
 =?us-ascii?Q?S05Ba2GkLQHbx7oUzvDT+xJ8/vZ0cRzhKH18BsqtqATa/xXYtcI1gefeSdnE?=
 =?us-ascii?Q?Z2mY5tn9+ifpb7wjRe9AXGF0jDf9AWeV5c65+b4y/2cQU60keHcBErjkQMsI?=
 =?us-ascii?Q?Hsoshc3Ty6GlmyvnhNnBHpqSYgh99N/tmgF+PR/LjLNYGiPcDXi7u546OlEV?=
 =?us-ascii?Q?q+nsmpuEUMyvvmfqe2CpWbkNtGPSZZXJSJxvfGTBQLWxgtHmdXBqjDBO/o4O?=
 =?us-ascii?Q?YlcJI99v+hpYe+RfqerqwJ7rkKvM0z1xz54CVxEkTSR+7ZpaD3jYixKI6yWb?=
 =?us-ascii?Q?q2GYgaRODp76YyFn6ynqHPbxlqEPrY+YJpvvps9jdoEyHnXZE7nf0N1/eEqy?=
 =?us-ascii?Q?hc4A6Mt0JX1ukGqnlP2YXNXhGZxM5RCB3qwWrl78frBss/6of/UPVjp42ogs?=
 =?us-ascii?Q?wwLLn1iha9mdaKZgZ177vxOWVDYOPQd6Vh4uaO94jDLB/uSmFuyBMamjbeX8?=
 =?us-ascii?Q?Kkfp4Nn7+rkHD1k3UTZ4Phrsxdjcmq0xljNQcqkcoG+PdkRqrcWYuS5dSnR1?=
 =?us-ascii?Q?K/fA8ZgnzngrcHNyJwHMTmPxBlkHiefYxStjA8Xxa0YEywkLW6l3g6nFO962?=
 =?us-ascii?Q?m4dtOBm/OKpgCkaFjz5yCzHPiac90i44Drc1LyfeCQsve5CUcuTmCmGmRpPK?=
 =?us-ascii?Q?vO6oSDXROR1AxnYr4Vmt/BDqGUCZIhZZv7PoQ0pxeG3sbJSqkjGK+ZPs2OiC?=
 =?us-ascii?Q?viXxYwLW6MXBKsUKH8Dytiy1eQZ7U1nRQksraGFDwjydbPf8o53Gsj3ID2DT?=
X-MS-Exchange-AntiSpam-MessageData-1: 9yxbK32MCMB2Pk/Pz8UDGWvLUMgL0guFvlE=
X-Exchange-RoutingPolicyChecked:
	V5x6jgFuQ1bH7pKAec5pO7MYeZsc6DU+8E9ftavh3/ZOdAfOtM3kCdN8b7wcqsLnkY5IAkyD3OKemdKyaZPjLRrxlAIJ9n08V3gYN2lTAa4liqyF9ctXRClvuH0szAA+N4RAoHeQ7FsVWBzxV/pQP+ySXYzjNXkaLBBBK8FAsP9eg9JJc4v8+t+F5OpD7isiQktgZx1iBXKyvxkTinEmpJjJopPoTTfLY/tbJ+GhiZIhxhoZHRREmz3qdQ9vJJkc1M3CxgwuEuRdtmiXhw0LqMAj+m+JQxi6ygDgXGo3UhPcCJ5necQNPWpWwAkRbHkkU0NyT16qOLOTHuiC1cVqkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eyiWLTBV4ZyqGRDocAgg1qh6acamLIYK7zBJNxMnL30f/gRN8xXe0uadRzA71bnvtHZTQL9QAhCsY2Aj7i4bG7m8NOc2tsoun2qAP+h2X5RyvsDruAzcsAPg/F68DpvLGVv5rlwIt+8EQmHWI4/qOMcR/E/v1TNSrwSaQqztk1xx0eYOGQwNufPcynWGtjfMlpqtzEHTWnS3lQ9hiP2GZUrCdCVfUQaqegLIfODpsh9uD5l1S88vR9EhExM53BBskbJRwp+trU9UVtrM0Z3wleJJjLu7DXIJMlowUEhCs4lnJOmuJU8KaZMXeFIIHVZ3ISfeu9InrFAnIbtm5rzid6cjo1fs5wTb/eYjUY/b8KwYxZaxjJUQg91ULBEPBvghkVHL8QhorrQPF+jTUO38YAG5yRSyBKpMxAG6QSEzqT1dST3MYVbSG8TglOZVeE2GvShPwNp40gDTLmdWhHGP4twFGIJALBlfnZrvB4sF4Ujdfs9/tAw6jeiKucRWwSL8NCNkeixPp1vE9vUqezX/C48+dt6OBiMocRiAhv1MYyYrqPYX5N0G1BfjUCvMnVDVRwZVmp2UXxLgfYllsVxcL0wMbaM0ncpqHJ0t2hEc4gAuN3q0x+Jg+WK9tPKw6m5c
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9645cb3f-b81e-4ab3-62d5-08df4adf32e1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:31:00.4045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDMT/Y8tK2GG25E+refr1FGKnrlIipAb2ROULbLIFqPOQsYDfMzb73iQYCPx9FPFcCur5/UNygvlzMq2eUrZkxSBy7yXsp8g4OAZljyxseA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

btrfs_zoned_reserve_data_reloc_bg() is only called at mount time, so it
walks the data space_info's block group list without locking and does not
expect the candidate block group to change underneath it.

Prepare it for being called at runtime, concurrently with allocations:
walk the block group list under groups_sem, pin the candidate with a
reference and recheck that it is still empty under the write lock before
moving it to the data relocation sub space_info.

Factor out setting the data relocation block group into
btrfs_set_data_reloc_bg() and transfer the complete accounting of the
block group, including its zone_unusable bytes, to the data relocation
sub space_info.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  11 +++
 fs/btrfs/block-group.h |   1 +
 fs/btrfs/extent-tree.c |  15 ++-
 fs/btrfs/zoned.c       | 202 +++++++++++++++++++++++++++++++++--------
 4 files changed, 186 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index dc6842438de0..ddc421db8e44 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3253,6 +3253,17 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	return ret;
 }
 
+/*
+ * Unlike btrfs_inc_block_group_ro() this neither joins a transaction nor
+ * allocates a chunk, so it can be used from space flushing context. Currently
+ * only used in zoned mode.
+ */
+int btrfs_inc_block_group_ro_notrans(struct btrfs_block_group *cache)
+{
+	ASSERT(btrfs_is_zoned(cache->fs_info));
+	return inc_block_group_ro(cache, false);
+}
+
 void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d567ed822e55..baf8e41ce8d3 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -353,6 +353,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 			     bool do_chunk_alloc);
 void btrfs_dec_block_group_ro(struct btrfs_block_group *cache);
+int btrfs_inc_block_group_ro_notrans(struct btrfs_block_group *cache);
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 213331042d08..067b695001d7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4097,9 +4097,12 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	ASSERT(!ffe_ctl->for_treelog ||
 	       block_group->start == fs_info->treelog_bg ||
 	       fs_info->treelog_bg == 0);
-	ASSERT(!ffe_ctl->for_data_reloc ||
-	       block_group->start == fs_info->data_reloc_bg ||
-	       fs_info->data_reloc_bg == 0);
+
+	if (ffe_ctl->for_data_reloc && fs_info->data_reloc_bg &&
+	    fs_info->data_reloc_bg != block_group->start) {
+		ret = 1;
+		goto out;
+	}
 
 	if (block_group->ro ||
 	    (!ffe_ctl->for_data_reloc &&
@@ -4183,7 +4186,8 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 out:
 	if (ret && ffe_ctl->for_treelog)
 		fs_info->treelog_bg = 0;
-	if (ret && ffe_ctl->for_data_reloc)
+	if (ret && ffe_ctl->for_data_reloc &&
+	    fs_info->data_reloc_bg == block_group->start)
 		fs_info->data_reloc_bg = 0;
 	spin_unlock(&fs_info->relocation_bg_lock);
 	spin_unlock(&fs_info->treelog_bg_lock);
@@ -4654,7 +4658,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			down_read(&space_info->groups_sem);
 			if (list_empty(&block_group->list) ||
 			    block_group->ro ||
-			    (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
+			    (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED) ||
+			    block_group->space_info != space_info) {
 				/*
 				 * someone is removing this block group,
 				 * we can't jump into the have_block_group
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 2a25e483e3bd..ddf4ab530168 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2997,6 +2997,130 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+/*
+ * Move the empty block group @bg from @from to @to, which are the data
+ * space_info and its relocation sub-group.
+ *
+ * The caller holds the only read-only reference on @bg, so nothing can be
+ * allocated from it and its free space is accounted as readonly, not as
+ * available to reservations. As it has no used, pinned or reserved bytes,
+ * no accounting path can update its counters while it changes owner.
+ */
+static bool zoned_move_bg_to_space_info(struct btrfs_fs_info *fs_info,
+					struct btrfs_block_group *bg,
+					struct btrfs_space_info *from,
+					struct btrfs_space_info *to)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
+	const int factor = btrfs_bg_type_to_factor(bg->flags);
+	const int index = btrfs_bg_flags_to_raid_index(bg->flags);
+	bool moved = false;
+	u64 readonly;
+
+	ASSERT((from == data_sinfo && to == reloc_sinfo) ||
+	       (from == reloc_sinfo && to == data_sinfo));
+
+	down_write(&data_sinfo->groups_sem);
+	down_write_nested(&reloc_sinfo->groups_sem, SINGLE_DEPTH_NESTING);
+	spin_lock(&data_sinfo->lock);
+	spin_lock_nested(&reloc_sinfo->lock, SINGLE_DEPTH_NESTING);
+	spin_lock(&bg->lock);
+
+	if (bg->space_info != from || bg->ro != 1 || btrfs_is_block_group_used(bg))
+		goto out;
+	if (to == reloc_sinfo && bg->alloc_offset)
+		goto out;
+
+	readonly = btrfs_block_group_available_space(bg);
+
+	from->total_bytes -= bg->length;
+	from->disk_total -= bg->length * factor;
+	from->bytes_readonly -= readonly;
+	btrfs_space_info_update_bytes_zone_unusable(from, -(s64)bg->zone_unusable);
+	from->max_extent_size = 0;
+
+	to->total_bytes += bg->length;
+	to->disk_total += bg->length * factor;
+	to->bytes_readonly += readonly;
+	btrfs_space_info_update_bytes_zone_unusable(to, bg->zone_unusable);
+	to->full = false;
+
+	bg->space_info = to;
+	list_move_tail(&bg->list, &to->block_groups[index]);
+	list_move_tail(&bg->ro_list, &to->ro_bgs);
+	moved = true;
+out:
+	spin_unlock(&bg->lock);
+	spin_unlock(&reloc_sinfo->lock);
+	spin_unlock(&data_sinfo->lock);
+	up_write(&reloc_sinfo->groups_sem);
+	up_write(&data_sinfo->groups_sem);
+
+	if (moved && !to->block_group_kobjs[index])
+		btrfs_sysfs_add_block_group_type(bg);
+
+	return moved;
+}
+
+static void zoned_dec_bg_ro(struct btrfs_block_group *bg)
+{
+	struct btrfs_space_info *space_info = bg->space_info;
+
+	btrfs_dec_block_group_ro(bg);
+	spin_lock(&space_info->lock);
+	btrfs_try_granting_tickets(space_info);
+	spin_unlock(&space_info->lock);
+}
+
+static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
+				    struct btrfs_block_group *bg)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
+	const bool migrate = (bg->space_info == data_sinfo);
+
+	ASSERT(reloc_sinfo->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
+	       "subgroup_id=%d", reloc_sinfo->subgroup_id);
+
+	if (migrate) {
+		/*
+		 * Fails if the free space of @bg already backs reservations
+		 * in the data space_info.
+		 */
+		if (btrfs_inc_block_group_ro_notrans(bg))
+			return false;
+
+		if (!zoned_move_bg_to_space_info(fs_info, bg, data_sinfo, reloc_sinfo)) {
+			zoned_dec_bg_ro(bg);
+			return false;
+		}
+		ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
+		zoned_dec_bg_ro(bg);
+	}
+
+	spin_lock(&fs_info->relocation_bg_lock);
+	if (fs_info->data_reloc_bg) {
+		spin_unlock(&fs_info->relocation_bg_lock);
+
+		if (migrate) {
+			btrfs_inc_block_group_ro_notrans(bg);
+			zoned_move_bg_to_space_info(fs_info, bg, reloc_sinfo,
+					data_sinfo);
+			zoned_dec_bg_ro(bg);
+		}
+
+		return false;
+	}
+	fs_info->data_reloc_bg = bg->start;
+	spin_unlock(&fs_info->relocation_bg_lock);
+	set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+
+	btrfs_zone_activate(bg);
+
+	return true;
+}
+
 static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -3029,7 +3153,7 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 	spin_lock(&space_info->lock);
 	spin_lock(&bg->lock);
 	ASSERT(!btrfs_is_block_group_used(bg));
-	if (bg->ro) {
+	if (bg->ro || bg->space_info != space_info) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		return 0;
@@ -3068,19 +3192,17 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
 	struct btrfs_space_info *space_info = data_sinfo;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_block_group *bg;
+	struct btrfs_block_group *bg, *tmp;
 	struct list_head *bg_list;
 	u64 alloc_flags;
 	bool did_chunk_alloc = false;
 	int index;
 	int ret;
+	u64 start = 0;
 
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	if (fs_info->data_reloc_bg)
-		return;
-
 	if (sb_rdonly(fs_info->sb))
 		return;
 
@@ -3088,46 +3210,49 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	index = btrfs_bg_flags_to_raid_index(alloc_flags);
 
 again:
+	/*
+	 * It's OK to check without taking fs_info::relocation_bg_lock here, it
+	 * is only to bail out if we have a relocation block-group.
+	 */
+	if (data_race(fs_info->data_reloc_bg))
+		return;
+
+	/*
+	 * Find a completely empty block group. Unlike at mount time, this can
+	 * now run concurrently with allocations, so iterate under groups_sem
+	 * and pin a candidate with a reference before dropping the lock and
+	 * operating on it.
+	 */
+	bg = NULL;
 	bg_list = &space_info->block_groups[index];
-	list_for_each_entry(bg, bg_list, list) {
+	down_read(&space_info->groups_sem);
+	list_for_each_entry(tmp, bg_list, list) {
+		bool usable;
 
-		if (bg->alloc_offset != 0)
+		if (tmp->start < start)
 			continue;
 
-		if (space_info == data_sinfo) {
-			/* Migrate the block group to the data relocation space_info. */
-			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
-			int factor;
-
-			ASSERT(reloc_sinfo->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
-			       "reloc_sinfo->subgroup_id=%d", reloc_sinfo->subgroup_id);
-			factor = btrfs_bg_type_to_factor(bg->flags);
-
-			down_write(&space_info->groups_sem);
-			list_del_init(&bg->list);
-			up_write(&space_info->groups_sem);
-
-			spin_lock(&space_info->lock);
-			space_info->total_bytes -= bg->length;
-			space_info->disk_total -= bg->length * factor;
-			space_info->disk_total -= bg->zone_unusable;
-			/* There is no allocation ever happened. */
-			ASSERT(bg->used == 0, "bg->used=%llu", bg->used);
-			/* No super block in a block group on the zoned setup. */
-			ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
-			spin_unlock(&space_info->lock);
-
-			bg->space_info = reloc_sinfo;
-			if (reloc_sinfo->block_group_kobjs[index] == NULL)
-				btrfs_sysfs_add_block_group_type(bg);
+		spin_lock(&tmp->lock);
+		usable = (tmp->alloc_offset == 0 && tmp->used == 0 &&
+			  tmp->reserved == 0 && !tmp->ro);
+		spin_unlock(&tmp->lock);
+		if (!usable)
+			continue;
+		bg = tmp;
+		btrfs_get_block_group(bg);
+		break;
+	}
+	up_read(&space_info->groups_sem);
 
-			btrfs_add_bg_to_space_info(bg);
-		}
+	if (bg) {
+		bool set;
 
-		fs_info->data_reloc_bg = bg->start;
-		set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
-		btrfs_zone_activate(bg);
+		start = bg->start + bg->length;
+		set = btrfs_set_data_reloc_bg(fs_info, bg);
 
+		btrfs_put_block_group(bg);
+		if (!set)
+			goto again;
 		return;
 	}
 
@@ -3150,6 +3275,7 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 		 * can take that one.
 		 */
 		did_chunk_alloc = true;
+		start = 0;
 		goto again;
 	}
 }
-- 
2.56.1

