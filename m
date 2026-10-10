Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6E7497399
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634050; cv=fail; b=st0AXMnPPWamj6CQY796rJRTKnJHrDbtB9aVh29LsLRBi1APhgRM+kSBHbKUosg6Lsz9H8hNRt0tfcbVOhs4Y2HfhTvmnoQ2LY5+zOtN4KhOZgk/CldE8MBEX8FQxSYGYz5PNe3dKm+m3nIMs8Xbmaj7bJeylDpCsPfyuxDEV3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634050; c=relaxed/simple;
	bh=B9KaqwQt30M/N/8CPD+2FU/UCc9hYi1pUJEvoaVPjQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jigLQkNqEUURqdNYdABUWUUxb68HEESvqjqcSoi7/ZbtVHydW7uAo/bDjMfWVINVOoADILBLcUzdpVg8kQt5UCH/N+qEPfndx1P8IXnZRLiv1+LpNQAuOGeCEpdI5oMJ+yTipWDxV7COYVyBiMNk7h0+lOIZu2WiuAN9s3OEvwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=S8RQQx69; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wN8cPF+3; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S8RQQx69";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wN8cPF+3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634049; x=1823170049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=B9KaqwQt30M/N/8CPD+2FU/UCc9hYi1pUJEvoaVPjQ8=;
  b=S8RQQx69W18dVUuD0oP8igx4oGwlJWgAS/a7WbWbpDt3ehhZRYz8fvqb
   cVX0zVmNbQyrV07Ab7IwVjPfS12+BqykqokGCE5KkjzFHBbmX7E65kSU5
   Ej6OttkQr6B++TxUgEPUJ7lJQ94BmgOvRI89LAuYTOWHRLwmp5quK0d8k
   LJCurTLAk5A3wXsgE/8ht+poituzcF0vZNwPrwiZ2kq5zsaDsB448LeEO
   crrIlxB9HzjnxfUE1ooRAPs04LVYhh8WGho6Nncz93KP3HXShOVupjflt
   HVdcJ0jOcFvyj5NkVebLB/KvDi6y0yHO6uVG1BGortB/98rUbb6AW9/E6
   w==;
X-CSE-ConnectionGUID: qdn4BU65TymUj+VuSKvw+Q==
X-CSE-MsgGUID: jPo8ZElcRiuqENgVNf3iwg==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="153560347"
Received: from mail-northcentralusazon11012032.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dXAqG5yvXWEvyn9t2JQ+2uKNDlkhz0WzYugbqbo8tVlhoODnXu81BmkNnsqxofxEyguoyxP6IiYFfWXc9Y5Nk2Hds/3Wue9DaainKKzjVKKjGYjCs0d0mYZMFArY3v9TkPSRB51IOTsXe3WZaugVc9qOtBVcroSR6ZPxFWbtXQhKdM5c+2ExXJcYLNsit733YJXBLKKfR9BylkVJle/Aj/V/sPA+vJ9FQOJs8+gMbnBCJZu3n0k3ArCjgT4DcjJCnkgdh1nRu7oVL9OtFgW9R08CUCw/geRQB9hQq4O3KA7gABsVRXExsUvCogNBzf3kHBegFkny4OmM6sULAozgJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1w4FR3ClHtC7lc3Ltvm7r731XFoLiXgHtYrUKH69HQ=;
 b=f//jKve3hOc8itd7We5bBelcCoa5CjCDetoZdaU+RfngKcBlLZ9UWuQdOlIdsHbzWXSQZvmXuXA+A73ZgPA8v/V1suSn3W/blX79orjNbaMdDgAnfayoFkc9mewxWiULl1vuoMrNS4F14NIgOqAo1maZzSnjISNqG6pbgtZ5OYUxRZgCOyoqZ7fg1Vzxi6IZZEZymk9H6tHAYcVZLwss/B1/XYOoZcrPmGNGce7979pREf0JbBGGfjX0Gb9l0DT4RtIwQmcLJwl0KvHzMCBx0hg4YuVHhuyoi7HAHtBwUwIhkAv8ked4aV0yiJumF74y3eXwRbY/6rWo26rXHNJBdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1w4FR3ClHtC7lc3Ltvm7r731XFoLiXgHtYrUKH69HQ=;
 b=wN8cPF+3bs0CDudnhjzfDxBIka8meiFo9ImRLeb/Qzx8Xg8b9WvqsAjD3bl1UHpO++IeNxZ+Mk8+PFlkBKeceY8uq4iRi9TVu44cb+CPnagNXgD6HfI4tnBkDmWq8ODN/9wGdOr6fC7AWU94Kvo4QPs7ZHauAJxuOEF1Gi48/9Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:19 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:19 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 10/12] btrfs: zoned: use plain mutex lock in btrfs_zoned_release_dirty_metadata
Date: Sat, 10 Oct 2026 14:06:20 +0200
Message-ID: <20261010120622.3781326-11-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 618cb746-435f-4f87-844f-08df26c708a1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	M1dwR3PL2jW7Ba6YGLIUFxQfMSnSWVyM/pJdYdgrmw2m0mJWMcNNhEH6ASjzf7Dt2dKvDuEXQ7IoMFfeSi6SIzbhFVVfNiWD9ZEfc3yKawTREUo85aNOZ8GCKVAq+Ppz0noH8RoNFIZ1Rhn3bsPEnUHt5s3EbuwYl1BPWOafgU9pPq+SEfaOW1ErED5U3G8b18dW4CL8kvQFboU7ZCEnJO1RwumW9h0sN53HbenRFQqqEYdzpMO4C4eI4YT8jeB603CrWGG2ogBP4u2Tgp2z60pAYbOgcm/lK9R4EqQyfb/8dVXfEsQyifIQNDzAtBp1Nz/G/u65NyW7FYDAPUf64jTOpqVSNG6N6jtOP7Pr7Euf5rulRxf8tUN9VgVUgDKWF/cj2tKXGFMqTKUWUyo4trmbmv5vwzRXErRULdejLklQuErEbZ1t8lVvRYbGlLL0btYFA7e06jVWvVW6GUobFp+rdld9dggO0fpBwpU9p7Cvvrj+PKTbmz/MMqp9I7/rG6jIl6Zm2+k1oTAt3xaiN8IdahbgKqfmO6b9LHYSENMtblinylDi05GSjZ05Mzq2nRsrvh9lM5hraiAX41HiZ2ftjPcuepZL5Uah9BI1tA74h18h7NNSe9TseAuQHjZXofYOa62Fs5ISK5D5gnumUU5eAHLnjRvaMyKs3sb6XHg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZLSBtfycZZyGy7EX0mXAHZ0x06+72S4ZwHjKDhBsqPSzXoIDwdIvdlufxe48?=
 =?us-ascii?Q?9nFjJ8cWn8BB/vZCxIorBZw0bMf7BMxRcIW5E9Y7cgqeR8ytYc9JHcwanCQF?=
 =?us-ascii?Q?d3Wuvd3Z572w3mNku1/vDg0x4Rb17qNoJFgulEsMPVw56HPmArg1sAlD1+U9?=
 =?us-ascii?Q?F+JuoM5IyQk4eW19sCzbjLKCpWIxzIHD3qEXI3TGEGhr18K5xN4JamDdC0j8?=
 =?us-ascii?Q?PihUg3vwdV1wrW4udYgg8bwvzR5qNrZ47jVBw/+HHsOPQ+8o0WsGyeSZ5Gxu?=
 =?us-ascii?Q?Y4MmqROQTOEpvSYlc819R/SQM9n7QAad0DcBipRpLNS4Aaxoxgl9/qRzXyEH?=
 =?us-ascii?Q?vSOqGBjKQkfHE8IlUY7s4APD8V4JJTwkpFJaLWWIv8E7zTzuJUoVERTNqBXK?=
 =?us-ascii?Q?NoPyphNTaHjSo10fwrP0l2S2gDAnA8oNICnSi1cOo0/3kbcT6G/xyTkIFWAG?=
 =?us-ascii?Q?sWSyJxmtMk/CNZNbSOyG23uSpt8vGUqYsV1OS2MsA1QSqWd0y8Xb4BSYSpqJ?=
 =?us-ascii?Q?jgKqvbhcPT7w3J09s5OJzQ+vBAlY7zP5RlKCdmRc8QUoIddYWP/YWGcFfn6c?=
 =?us-ascii?Q?tKPTuaQadL570dLFx6KlC9FO5isk2LAUiCGCvmptOCtApV+sgDTRelpoJUSl?=
 =?us-ascii?Q?bzwd30XyKkZ+gNInVIbXBAyW7GlFYQ7EAS0GDIKmbEhUCJ4CN/NeRbyi7aaW?=
 =?us-ascii?Q?pTGDZqrpXCYA4Qg1NxRz7BKR831rDaE8vafcQ6D6MdQcYdFBv6T2dM//0A2r?=
 =?us-ascii?Q?M8gsB7wStVu5AS1cSZLuUw//Lcnh6S7VyMuc44gl0HsDIUcgx2CxKZHCqJbL?=
 =?us-ascii?Q?+kggjz/LkqvnLrDY1vsduHBBd7uRiAKDvuEpQjLeI1LhnRtmvAmiakCyTGlp?=
 =?us-ascii?Q?2uXfWzRSZubqy7DA8yESVDRCuZi0kla/VaEMh5YH+AHC19nudNWhR9KF4XhX?=
 =?us-ascii?Q?hyzbjyShxOXDFIY8IvLLXCxEA0vkpmapjE5KBkYD24Dwdx8d6q6nKwf9FlKS?=
 =?us-ascii?Q?8823raZW5bJ/pjoYEUvJjRv8oyOPm+g/WEIVCE6xKy861JIwr4/r/FjHXeiB?=
 =?us-ascii?Q?YKxFWko4nfXZA+UmY7IFgGX+EDI0EiBox7LeQUOEGr1ml9G7uwHvZ3EA6v1Q?=
 =?us-ascii?Q?m6wHY7sZ6lhnyb82mFDggUTeliT2RcbWbqyjCejNaXQVWmN949jWLN3hf9lk?=
 =?us-ascii?Q?uDKGBOYcs52o39nMDYtYphmmK5J9MLROfTvXmQZUSffXGcLvtiEE9BJSIlnh?=
 =?us-ascii?Q?ODC/eaLCwrl4eJovAfIOTu83HktuKfePaYQTEI+Xx/l8jvBLBx1870g8vNFW?=
 =?us-ascii?Q?lD/lbTIf9dSN3J2meLn9Bn1/+rFudNisU/KBBx9aMGOs+kPsZ0cMNVXUCKOw?=
 =?us-ascii?Q?lJ14fybsHWCZaTFAX2WplmA4/v2pB1tVTB6sO7B9mg4JyzZVb8zn/x4Kv9DA?=
 =?us-ascii?Q?k5S6mixnVqNZQ20C8r9smuAtj6CvdJpqfzXivqk3XBuYZN2h6df1obHi2uBe?=
 =?us-ascii?Q?8Oso/jtGPnoByHQtKfB4pNfptQHYH5CQPTz24WRS+HFUczkRfd+dbBszDsuZ?=
 =?us-ascii?Q?pSRHrMMqWWB5mj0MGVpx3q7M5vIwjfp1YWlEWCZAkFpBxqjTpphLMEO2FYNn?=
 =?us-ascii?Q?jLIrVgAKfFsr3XBzrfWRVHjejHI2HAEjXO0s14D0Weio/QfbkTLQmNJWcYUu?=
 =?us-ascii?Q?I0Fm7FcWC9KdKJmwMvcPsjrldcDSCFHQzev6eY1pIL3HWkZ6c41KR3lKOMCf?=
 =?us-ascii?Q?8Js6sYbE7ecLixFeZu+iKb6DiS8n/kQnkKgNDqGzbcaKvzscawInY7I5aoir?=
X-MS-Exchange-AntiSpam-MessageData-1: LYUFsTgZkKmI4oPdl+OK2WRq7AUZ7FqK8NE=
X-Exchange-RoutingPolicyChecked:
	H9c20IqmQDAswZShLkLISL+kVOE5IJbSbpAfy9akwV/sql7MyUaaO03DXquouo3LU6YKNMveNIezwmTmETrrmiKoGt13IeIBh+9DHeUN8cBHh7zzuzrY/DdVMv/ryp1t3y/oxwvBjytngLNU0S2zz5S3h/75qb6JBJ2q8ragSZaBkGSSBBO4frpNfX4Gf4bvh8kjGizCsOpufHLUpbNMxa450SUZ0SXzRegkc/aJr5PXvHb7vtAhzrN66Z84b3l1j9iB8bqPDgAwA0+Wq6mHl/qBihcla5YJeA67PxnjgX1HjeBBFRdHxgORxFcHMEOtd41zv3eWU0bhaM4FAvXx9w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a9OiDQeb0bVzJ4LyrZgnf90LpZa/hCy/JjwjVUDxyz9QX8Ush5d6hT7fYbWKuNuUzA78lQ0psjrRnPPKIrWdX5d0952EXILQ8hXUgu/UFfg4qknHhGBHv3ljiBR2KqYiDOWOwZOYnJ236wpt/7+bp62C0aPQTV78BKfg1KlsDN3pXvjThuZK2/trgqIkr7GaoaQczuYefHLRe8Nj7AsX81DM1vKx4jndaQUllgp0J6HV5h4tMc4/eP5GDHk4MD7yvA5OvLIcaq4KRBn5yQkGS25cpkgJS28HOmQgDDD1rtIi7m5k+fqXqBOMqJ0Wg7EAXZU331xz6VLMFeBTTCz3XJgN4fv97NdXy5U6WEah/n4WQMFpYk3knMzP5693TBR9VU8P1FyiukbLt59Gr0b1Fv6uW7bpAHx3E43EwTUYlKT4TQ/V0I6/Lh5ejz2JYLyt6NAWi1wRv4+WVsYcUmYeweV44Kzs71agTxPgXJvlcQ0k4AMytEKQwS4QQNycuwvNjYk8bKW7UlWGvMLcEwaOca3H/3X9HgqIkp+pOAq36KtiGOMnzasNLgJOKox7QJRb3r/yuZb/ZHzPxG9nC8P45BguGjwGA3UoQI7PwA683E3ss9cOrqbBlkS0wcVUKEIh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618cb746-435f-4f87-844f-08df26c708a1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:19.7309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvxlknjlB5W3mBytVmoODv9MMzfURfGCB7b2XvC6HDpFIczQX+Xa8rWxzVEIjzA6poYsIHvYcjBZ+8faKnRtVx+g98UL5Dda58GVl4lAOf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

btrfs_zoned_release_dirty_metadata() already bails out if it is not
called on a zoned filesystem, so there is no need in using the wrapper
for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9e3166a4c66e..b5d9e29bc5d6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4224,7 +4224,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	btrfs_zoned_meta_io_lock(fs_info);
+	mutex_lock(&fs_info->zoned_meta_io_lock);
 	eb_batch_init(&batch);
 	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
 				       PAGECACHE_TAG_DIRTY, &batch)) {
@@ -4240,7 +4240,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 		eb_batch_release(&batch);
 		cond_resched();
 	}
-	btrfs_zoned_meta_io_unlock(fs_info);
+	mutex_unlock(&fs_info->zoned_meta_io_lock);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
-- 
2.55.0

