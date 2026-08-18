Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B42444719
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045076; cv=fail; b=DyJV0MvLowuZ+SkMF4gfVE2Th52I+bG/X2b9BdYRVgIyOh+CbNPbXf7bZ+Ba1RurIvcKys6Dq8C7rvvnDQEOj7X+ZLqXPqxtxDvtZPfj/ZN8qYkKI6HziqE4QuD2MbUZw9ixKSV9v/Upv0lXUoA+nY/7qrJ0IjnJXPQ69G4AX+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045076; c=relaxed/simple;
	bh=yktoATXTArKQxyLoIbdvA2hK1GIGviz4eZR8MfL6bwU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=D2Bt3reWVauFFkROVNN2Pm4TvT3YrJG7F+AjjB5aCAAmNKVPPAwp94C2odSjBmFdBziePrFFeCRwHGG1C212UC1pjm2uY2Fguo8+KeuGSgE/nX9eNwOb4HHiTlmcACGHlY4cQ2KwyBUqa3wnIDzLaGR7VmFLZ/3FVy9E2Qrrzto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ma042Hg9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=T3pVxZ19; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ma042Hg9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="T3pVxZ19"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787045075; x=1818581075;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=yktoATXTArKQxyLoIbdvA2hK1GIGviz4eZR8MfL6bwU=;
  b=ma042Hg92457ZU0JHurHnqPE15Xs01EFzGB1+omSRxCKCdJS/Cf/BUpj
   NPXH7o0KQZZYmF8EZ9PWlSod4AaXVkvQ7juU16OA7OmTp4cduhbi5AK6i
   s0P+sd7yAdc7lQ8vxptGCrlqhSZP2PE5yE8oFUeutZl6LPGH+oY++Utq3
   TFUVXzTb7ngYXgZUkT5kr54ROsBH9V4PR7Ql8nhbyDZhA8BRP5f4NOd+6
   EItpQA2J0ZIcO3/jf+N+3ooFdqa/4kYDYepb/r1xza3nR/DJyEPJpypGy
   LpeKiFQkoF5WAPnzjiRvm19ZRTwZ3QWfvN24ehmfvR6LjwWQ0aI6UfH32
   A==;
X-CSE-ConnectionGUID: RqG00Uh4QDGMDeUoVRDvWQ==
X-CSE-MsgGUID: biA/Xn2UQ4+kANrzTrB/zw==
X-IronPort-AV: E=Sophos;i="6.25,230,1779120000"; 
   d="scan'208";a="151931448"
Received: from mail-eastus2azon11010051.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Aug 2026 17:24:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e0xEBOuDyGHcZWX8JmyPRQDqcpkrtGqVZ6T5l41ir82VUwofIIVO4qHo3gU12v3lmf+3fJywpVMxfIyZ1RGULgmSqkYvKxQ4SGIZMGX5BHCN/8ufP1uXJeVM49dUtW4/shLTRMXOXVtqDke8ZGCQ5/Z1ZNmcSkJgxdiAZAYS+sQnjSXMIjkeoLv4GywHxYxh+rdVHe//y/aaj5EihBsSwRVFc1IhN8ebdSkuMaPi6PzB/HUA8zki9o5AgmM2yGaOYvqw/oA0Zhi1FxL3CxNGSw76WnYo3knljrAVD9xr00jjC8RJHYiRz6K7cEVt/KxCBIoSpLNoZxHHjYnxgqiWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XWQY4Rtmwr4vBFn4eWaJicKXJMCPZnXyWXGrpe0o4w=;
 b=iuq6zw/ikqiLzmB2kHQGw9Qxgh4cYVYFaOhxmPFSdvVUUqquPJ3GaDYoHikHoKUY7fvAe9YO1UCZSgAjwtysdR1naRlL1Fz1Kq5wIBehYsWufZhct6VpxcCfl4s1NDcg2IHH2Y8G/UxQ7iR6OaGpfHD7rBHCBlVMgqKyUa69NnrMSr0+twqmzb/OvW/GbUTjSxqtuUBiQ123ramvfiO1VwZEME1FzdYLMfUf/EpRnM78B/CInVvgb8mmZVnpgL7ylqEO6pEiOrJnY+Fe931SfmKakO8RT12yie8YkrwUlARlZANnDJfG0tY+9u2uvWAhi3I9SzpMZfGhEd9VlWdj7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XWQY4Rtmwr4vBFn4eWaJicKXJMCPZnXyWXGrpe0o4w=;
 b=T3pVxZ19Nkx4Da2yyg74Me1Zfi8BTYW98CCfR5QkIb3UWWHOoRxdQu1LkOiZs+m9zV6swe/77b5xXJYCc4RaxFsfgJwoiFxBcnRI0WkrD32nyZbPdmIR0Q/z/T3TJ50SOGmAFqpxww7Bzl7E5wdbnISKUkIYzp/ywKVYzeSrqwQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH5PR04MB9623.namprd04.prod.outlook.com (2603:10b6:610:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 09:24:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 09:24:22 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/2] btrfs-progs: fix stale active zone after mkfs
Date: Tue, 18 Aug 2026 11:23:50 +0200
Message-ID: <20260818092352.1364853-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH5PR04MB9623:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c401020-0a0f-4fa8-c9a4-08defd0a7d20
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|19092799006|376014|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
 4LzauY1WJ1YJnjYHBWRRnxQ47gFXW+leeCrU/M6QseWZpHpBOlg15EMHf2y9nGdprNh2Sw5yTvyA2g023gWC8z7HRGY7wtPfAVayD8H68Vh6p67S6KHXO2sF/R5Mur3IG0KsiGZ46wy9YpYxgDGSes0z8dwE0gEdzjT31Stcns0jsUcIpiq1I9hREbk0QPr5ahdgI7YEKx7269IfVq7wDpZfScm+qp/TW1O/aVfY/QI1/7vGL59C6TPZkkgwXFkf9p9Xppj42ksTW8rh05ZVDHBQBtG2r1mwVX66A5I6+8zZhysvNwBYLN9jqjEwQibWJtRaip6fngnhfdYt4kXr7vaxKRnJ0vAERzbvZ2ko8ZItDK/SSuiDBFc3PZ9XXdwU0sKlKcXR9AmsX8+s1/ABVIkmFhCIVS173KGpwDx3YypqNbyKCTgxIXA44JavtZJR2EFCygisWDalCTye3mPiBXhzVi5hV8rS8+8liZzDCBPRVcaCrPzKw+o5LN+EEW2MkFrAjhIeuVdu8J/P0KpJ+J3uHLQVJRktvRIAYx5Yp1QHBDlvlyRVPwyFA4NJiiRuPYw6ph2pwz2Yp46I9KufiVsoSwdH66eSGxOSB5mznny3hWIVuSYY9GutLtfm70umG0zIIHk7dj96vK4thBPCzyua/ymavkxqgWTQaMLNw6k=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(19092799006)(376014)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?nf8r3WXBskdggCnx2rdsxH4GK1iNrqwsULEaJtPcloeWhgKEOwPm9kO+geqB?=
 =?us-ascii?Q?uG3G5YRxSVEkKE3+yJuapQu7J/ulKxhGs5O0jr2KhfDqgo1JQIQwA5d1o6g/?=
 =?us-ascii?Q?YLIkhZb3CKZgv+ba7Wdlc0Qt54uco7Nni8VOuj3VifUp3DrqY1U7dozX1JYp?=
 =?us-ascii?Q?TQFLb2jRIVvKKpSIhBkqVYszq7QASwcbOfbmYtLQZ+vA24o+ClSCLC9fOjzo?=
 =?us-ascii?Q?VtKXfNAE1VNV/ppXu6lx2XwHLDttzUHwAaDE3Zl/tvS3xm2SVjUBKGJoKOAg?=
 =?us-ascii?Q?Zv09qoslLAkU5VqApuyE04+4+C8pP8FOkazSj9oHNRSWOOJS6MvxAobDrPaX?=
 =?us-ascii?Q?DdAvbSVWmxllFCQeXkuLj2M7a3GJH7XRB7UO7PJzRG59xeEUL/8mRkPFzN5O?=
 =?us-ascii?Q?Jav50tZeLDKEHi9zcQuNxxzxSS2PWd/wLao5TZR9JU6WLXE3teWM1sPR0WZW?=
 =?us-ascii?Q?M461vC8FPYuZKgZ1cLctUBHtWF23/haZ1m27SawsYXZzFvQmVEUgXHWvoTuD?=
 =?us-ascii?Q?JeWIolGXP+s0ibY39GS1SPXn4c4Lyk1WzeoxQrLR5NcFHK+FlfXrUTduF7H1?=
 =?us-ascii?Q?3bG+flo3Q28Z32byT7y0nj3dgQtJ2dN2pzqq5GQ797e5xVRmNt0mUQSYKz9Q?=
 =?us-ascii?Q?jEPnO4AANWYFHhbjo/Kw2fLZ2Xpe6Z2cRCTuV4wBn7+czgXm9LwJtqz4nYBX?=
 =?us-ascii?Q?Ar1H8XDZMomt+t5yYy9kOwfV9umhj9AaPq5RHAdok4kkrwqA6dgRxyDQIOwt?=
 =?us-ascii?Q?UH2XBg1AiIKti9YYzQr1b3ypxkOMYmG06/YCVrZQkSHM76P6JsFIoo9VTuZc?=
 =?us-ascii?Q?PWsLEfVieuioivtVUr0VwKX6dS6aGlsovsIZy38xIXIK1hfe1ymUCndCv7yS?=
 =?us-ascii?Q?NI1n01ud7AmBcgAO8Kf4Bdh04qG5vm+Jb+csYJl7Ru3IkeqsYoia9+/DQfhX?=
 =?us-ascii?Q?giqnsfU2/5kpKAN+YvYXdlcMUXtDZm+Fp0IYBWSZlkpbmPXzMsOTatcWKR3u?=
 =?us-ascii?Q?YWbFu3TR2pXKaOEyTTq239eBrra/8O7pE5gltI7IY7Y7KGRtJWBjuG4RdobV?=
 =?us-ascii?Q?+f9UTiz3P2Xyv9xDeWJlKVG+/Oz3YUv1/fwICgLJKD5PkJaxb7UVTnWKBe7T?=
 =?us-ascii?Q?3ZM5WPcwhW0YD0nTMwbjJUUGQJ/cxgVz3QwJ1YD4qbkyGeITx8TWPhWF8IVt?=
 =?us-ascii?Q?RbqvwlK4++zsqbxsaVerJWab3OgBJZNEX66PVDi6LI6Pa7wB6mCroOkarQW2?=
 =?us-ascii?Q?VmxhO4MaOtcHL8dfzQe8IdQYoF7q97MLnAcIrv+jCBpz2VpDFEuTw3LFo0sV?=
 =?us-ascii?Q?JMZ3VRrhou9pk00tQI0WoMTBaSImo5PJUJJGwABaTDPUieP/Z6IzyvYkTsuK?=
 =?us-ascii?Q?9ygfYftjc5DkyKAO9emTMKtZ4dzwLRYruK0PbkfJBL8+KvqN3ETVgDiF+25k?=
 =?us-ascii?Q?w8nkVbM455etssrj1gtSVEMEiYEVNkuuu/qX+JpWXTDVxgrO+3/9plf32YeY?=
 =?us-ascii?Q?rS7ZqZsM6uIPxA7mVoAuMWWkR/gX7hlZQ4V0jqabXBnI5t+mJRyKJwMSKKvu?=
 =?us-ascii?Q?WeKB/lee3BWlomQ/B9Lg6TeasqiDAcXUT70ZOzWRh89WBAyjR6OOcEXjTzpR?=
 =?us-ascii?Q?NRF+kwehKDJxXCiA/rW8iCYIFmlQaQnWan5RyCDFY/LKFgTpjW9FeFliKE1j?=
 =?us-ascii?Q?Fvif75A7AFrl+IHjWZXRF7VCLaBMH7YidyWYICx2PBFL/5PpO9GSWaTKJN7Q?=
 =?us-ascii?Q?Dd4Xgi62DZuNpSTXzK4ZrdvRW0ln3hyHD7jjXUZXjWenzdp0KJOBRXGo9Och?=
X-MS-Exchange-AntiSpam-MessageData-1: bxZB/a3gWwmWsaDHaqpVWmZRps/rVwwYZis=
X-Exchange-RoutingPolicyChecked:
	DwdOMVETWYge/tD1qkjVPSiwmenOL5KNvyasQhFaQd7IhhvHVZon1yV9pxWRughKNiegcXm4RVrp9xP8w3nP8DnSOyHhRXeKBfTLV2VNfwS3HwPN/AVaLWGXsOPCogwqisnLNy81yFOmYr/4pM906X0fnmeCJ72ZxyUEinTu2xZlf54/BN5GtS8u8qgefN0aqBHTLnv94TdN4Tr/uYnGK8CF/N6nzb3aK3420rQCZOmplAQHiwoqayFI2FOQlpsV5uu6ZYOwbRHT7MOCm9UX704uCgLALl+Y2xIZuv8bQoQqRp2Tr2WSNa0l3j8JLfF+b4k7e5KhkqCMWi/hoU68Rw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PI5g6FDqoYNL6CBBAbqZ+4JvWdsOxXa6rb1JHlqwdqxL+Kc77kS+c8DHJ1uvFcwF9xEhiUwLLpazL5sCM0wv8wOEW4JQ9NoGEI5g9IF1/tnIcmHOEOsW4FhhkrWj5pnoZumHoW7NidMO2cnaUUib+NrnCTFICgbB14fRR83rU/6Pw0yYNnv8QJJa6cHO4uY2D356IeqF9yEhkK9ZLlN4JOQlV4g2y5iT0sNeKlop3LP7ERUQ5Jd/yALa+10Jg4upWJj8rDJFsPPaKCd0xq475TFLrPsLW3vo70rp9vkhJ6e6kFi5y47BTacGi8Vr8pbYK5ClUoQuTX8fpTO59fhPamtwZmOkfZWhe4uP0GGB667k2qUHpxLUx4Mg5g9isi5Fhh88FjHvnDW6Kwqq2CbYY0MbjvHKm5XNtGDixF5J79KwBBs+6tLWFC6XE7YrUqYbQIKUAMD81pWnLG5haIsXS7N3DX4p9bQwxToHPPINn170xBabbHWfEExEdjIVyT00hLk//Rywt0me9MqNDKeLJ7hAOMke/NokOYbnUWHNNYgafpHKhBVgIfKaMxb231Y5teKcl+FeCuo7c1q0IWOq361D7ZUZFiwn12ppJLsBat+c7wkI2eA2GgxF2acdOUUH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c401020-0a0f-4fa8-c9a4-08defd0a7d20
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 09:24:22.6364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPCsdqzicWSE28/yVtoGG1kFB5ccfeHJjNeOQvKGrveWZQnBDgFRxpLkSBL21g+8hSSGhBnCC9Ix+roTysyXMRfDsHNAcKxQL/7KhXuUCAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR04MB9623

On zoned devices, mkfs can leave a stale zone behind that is used as a
staging area but never reset. This zone is not backed by a chunk or
device extent, so the FS itself does not account it as used. On devices
that have a limitied active zone budget this can lead to premature
ENOSPC and/or an exhaustion of active zones.

Fix it in mkfs for new file-systems and also add a check to fsck to find
such zones and repair them with '--repair'.

Johannes Thumshirn (2):
  btrfs-progs: zoned: refresh stale cached zone state in
    btrfs_reset_dev_zone()
  btrfs-progs: check: detect leaked active zones on zoned devices

 check/main.c          | 154 +++++++++++++++++++++++++++++++++++++++++-
 kernel-shared/zoned.c |  18 ++++-
 2 files changed, 168 insertions(+), 4 deletions(-)

--
2.55.0

