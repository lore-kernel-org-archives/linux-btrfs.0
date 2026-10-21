Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590114;
	b=NU3bDu+SCAFwfhSPOYC+vQFILBBtUHnscs2qas/gH1oOcRWT8pks7A5EfmGvGSp4biiO
	 M6oDhCIHOVwWD9Gh/u/BgkKdNC6OHfbE4F4imFGybH0ZUpQ6pptvjlcVApt9Uf5kgylJQ
	 o6mdNEHoY2ruOPdTIx6mY1BXGEZJiwzxCaeQ8WkwDQhlPbQA61vHrO69DU3rS1w/ckfcx
	 SDCaqYGs33Us89Mt8CLmsIUktIhk+zxz6x0mJCxYn0LYwaj9b0zd4QvGFv7pPIB1343H+
	 5t3bvOKruRx99TUHRlABdaqpmUH+TR9vQMo9mUdprOHhhsaEYgBn0PGHr52zW9VJkDA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590114;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=ju9v+PHDsa6SWr/WyAG2jqIbn3BEm/2YI0pGm5dbNNM=;
	b=Wn7ebzHB5sqrmqRSsV9sFPFJY0msmg3n7MtwloQcNS702IFRQSkZ487G87VUWf+S0ufR
	 5YrTPrmFp6UloqK/2JD43XAuSp2AXlJgYHz5oavSg50mQyIPF+myd+tPfCAhEltKOKEzc
	 yj22RCvRqGeGq6URrLw7AeZVP6f41Ck420flQyShTdozjudyAS7c7zyqRcOCCW0FIlUiO
	 QYqIXR3p88q9dxnnm1kxXaantYtVuAiwlvpnwu1PzvNooJUP8Aqc/YxgJv1HHGrPzT9Kr
	 rtgzgsHO24X84B5OqSgc2vTA2hIDaBat4z5Yg8EaewH8Y4UmkxdLbk4kSM6gnLGwARg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Wyijcfbc;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=fJ2A6VwG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1D7606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:41:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C1D7606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Wyijcfbc;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=fJ2A6VwG
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590113; x=1824126113;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=8VYj9Qzt01Kd7TBrNzl15rGWDxfyfGE3dY23j74WubE=;
  b=Wyijcfbc3Hwkw+20HtE7jMaeflrK4bw20Qh7HjurBWcevZiLnqXXP785
   uInQK+3ta76/oOoeoE7TATNRtrrYXnxqec3ibUeXHDK3lL3+5ymH9rUpc
   hXYDvygQs7SXYHQ5q6OjN/qiuKjrk37fgEhvP2hja6OUBefATY6CZ0c48
   8S6Ve900ELen9CuaLWmnsRsMccY1w/AvKQapA9KL5g6t9F/zauelmGk1V
   rgnzxZ4gcxBETmUtJFj0hdPzf/eTKTPwrtMdZi9TWFQrQ8YwDHOpQaHdF
   K7bGocxwZS2FCDEDnoLaqYyyGV47M0XkDrKjSd8LsW3/9tLZN2uyjEfog
   g==;
X-CSE-ConnectionGUID: Eu9jKtSdSMKQctGTwn8hnw==
X-CSE-MsgGUID: m+hgCaDyQtGdM2BwMw1j6Q==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="158647852"
Received: from mail-southcentralusazon11011021.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.21])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:41:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jplh3cBbsqx1iiClQbKtS5PnD8NggTRbKwvGgHG5eQkUQDIvolfVrL+agx3NMmBk1CjfJ90o2AFeWcvUdwF/8bsJkpWvjbkFqSEMUY4+gt3Hab4bGp84dtqH5eDYMu+pahs4PqWC/A4PHd/t37ZwU/STF36IGJ9VKSGaNkVpL9+4vwYXZv89Kkp2gJ8YgwzZ/vNx6NqnYOmTeZpYPkqptsJDGEpg1c5FT9b3NhKoPeKHItVpmGqhq6Ny0EBwH6O+RdgCcX55W51BL/ZIt5IQoVwYd7efBXICyot9TPG+Bst61Zy8/G32RogEWHAnWYRAf8QQqn/Ql6cpScBj293X9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ju9v+PHDsa6SWr/WyAG2jqIbn3BEm/2YI0pGm5dbNNM=;
 b=eo0B+OmSH3L3KTRJdM8IaBKiMpnZY1HCWiKUxe5TGVr2P9JNTyga0sPG12zBWtMWz7nqntHKevSavLg54dWmDPp2Lb1j1y983cf/zTRDjCefI5L7hgJ1eunw68swJDwTUwS4O+IxKK6lQnen5nlkr/gO034hbRd3WKzilO0jnDBAXdj+1+2hFX7jXtqkaoIFZDjAQIflvrbKuME48rpjVwLE6mKlHG+imR+B6GtSAgooPFtudYYDPSdJC2VqGVucB06aGHXX5UAqEmIbHfhrVLtthCU9iXQMSM081yazU13kp+ja72GoEahTymnqdmn8psA/VNEth2kpgVn3vLLJ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ju9v+PHDsa6SWr/WyAG2jqIbn3BEm/2YI0pGm5dbNNM=;
 b=fJ2A6VwGAgXyxsIt01dxWRyxqcjh6OHw7bvXgYYpqs0wgpMlM4vY7cQc3y6w2Utp7rk8sJuQqS3hsDRNzQOHfxgaqjyQ1Q1DD0VG5Ne4zn+GfYuQaezVpl7OYtQgjyKnQm3KYVycB+Gmgz/CRS8CQvWelCExdiscqSzHx9LKiS0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:43 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:43 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 00/25] btrfs: zoned: fixes for generic/747
Date: Wed, 21 Oct 2026 15:40:59 +0200
Message-ID: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993834:EE_
X-MS-Office365-Filtering-Correlation-Id: abc3a40d-c310-4836-456c-08df2f790ac7
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|6133799003|18002099003|10067099003|13003099007|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 Juq+78DoxVQc5nIVjRapWhRWBOXqlMp0kFI1AbX2yEUaEnx8rASpjsAKLNVeUNpwwilwe0T7tTud5AFp6m3W2/AnwGwWpo/f2PprfpsOZWfQMRggwPeq0Dpmytbhc3rhWPmNpeMY8zMqH1QeZgUFlBF5SK6wUdnlNuHUa2y8MJK9Emj18jbFFWeU2wdnTazIV6zBRne5OwDFWt69WM75J/d6US5CHml0HH7NoqvY7iOrdZ7EV7RgKXg464sBg3FaOS3mzwYup+8l0R7hMH9I5l4TojDut7bsynTbYmIatWt/+Epqe5r9kVPjQ9v0QdFTa9e9hO6bsv9REW1rD7UzTYdVBiSgBvaIB7BxHA4GD2QXJ7y/eTCrbuDe91HmWrGBqgk9dz7r39HfeY0jFhBFml3BKRvw55AgbmVGcHyyWZCj+ykcVod9/ybxvdCA3GFSnBBpuUAj7lmQXSKyl2Wm46s8Eu3Lvz7ufe5S8Hf1pfzfVgYg3DLY3ktuhtSDj8+wtomP/yAybqlg/6oHADTmdDXir5cpZOT+jys9N5Dn6+0H2PFWEy0bG2TX08G9KD9i2o4t6+57gkyGOg67D3F16DDwE3v3D9DkQNQfn5YYfUQYhMMVh04pJHbJZjQZoRNA
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(6133799003)(18002099003)(10067099003)(13003099007)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?TSvXVDAlwggbwBkVC8kH87XJ3Qhub+FM9nYcBghNK+7qJpWmb7oCAeYe0Deq?=
 =?us-ascii?Q?AIvBXOCscXeJPm/16A2Ht6dvdTWVVsYlX+miFhzPFjsqa0sQRSBmr10+iG8F?=
 =?us-ascii?Q?vtJxs1HlJuibB0EjN0Gua8WzrcVRfBahrEgI5XDs/ZerXvdbJD6eNjVDUsFt?=
 =?us-ascii?Q?1EHvHvbJ7x8PuRlBHl+xoVBONpOENavvSHVVIsoLVQTZ3we8Fl60QLpH5K0F?=
 =?us-ascii?Q?zrZaSKFRc6A9cMljpmjDWJqH/F4b7U09ZgAaxtLl7De7IHqKwTKD1jL1XFEZ?=
 =?us-ascii?Q?9wVi5xM5h9jbepT5SWjMeGU1A20pVCSC7UXD2xanq70h1PukJQKUnxY3aBBI?=
 =?us-ascii?Q?7ffe+wE07dGrAuEkiB8DItaGVdjFf+BdEi+8DpIarAz1ZO8uQSCvNqQMe6y5?=
 =?us-ascii?Q?bBG0kdfJeXrVdG+SmBP+GUxbaOe46qLnWb0Od4Ju1/XJbZK570qg44txiGe+?=
 =?us-ascii?Q?eoJlsPjE+Eb8ADjf0VHx90EYJQrTdFV6k4pI++NvSkpEZqEuefwaRjNOq9R4?=
 =?us-ascii?Q?XyGRvLDI20e2lLeqeyp68scIzYXHSghldzxMMb0UutHb9WwH9ycUFL+UlTpm?=
 =?us-ascii?Q?IfiaeVhlcNpF08hTp7Q7itWomzBsWZw5xH7sWr+8XRqYeGY6n7qKjX1DNBcl?=
 =?us-ascii?Q?FskISeI4U+x1tEBhoINtDtyh5wCFnd8hDaGhxvkWhzUitkQj+0tJOlToba2P?=
 =?us-ascii?Q?eIn9YvCVIZhw/TNLKQQGELLwvRxj0YGBiGnQbyuUm3JWoTvDFEFrz5YRnilG?=
 =?us-ascii?Q?ZUgjITsQT0ToUT3L8vUMiqEwOIAA7wDCzWVESXqIHPUu8pnzQoFSFI/U/68L?=
 =?us-ascii?Q?Cbsb4B4NyvPP1kM1NZNNjVGGAheAv+ZdNmJlIFHyE9VkoGwoc1ESTYAxu8cY?=
 =?us-ascii?Q?H5A4ZQZltmoL286WcrbC8tQyug1WvBbr9RXBJx8YMzCdH/hPohGzmrZ7icUQ?=
 =?us-ascii?Q?W+CQNUvHJrdvCzCzFqc/SpGzQtSxLvyKU8B/bHRpFBvS2Kia+f+1hTwBrtu/?=
 =?us-ascii?Q?0Q2aj6Yc+rfXG85hTmNu8dP0y4f3AHuCrd+GROqsdUmGHDthE96fdUv9F6Lz?=
 =?us-ascii?Q?Jz/66HKRoS2EaKxy91/Sb3JP5KE2k9//urTqF0mOWQSFUNGQzuxseQ5GDYd4?=
 =?us-ascii?Q?+2qvbg95eSdvaHh2y4BpCmKNeCMneZavNPTeNB7cb2qjkh229ryVrrL1LCjU?=
 =?us-ascii?Q?Hy9N7L8oVfy3h5T3uv9gxwxsubRpSib5xcBiFsvzkt94z1NiOctmOPiHKthh?=
 =?us-ascii?Q?hNFrEL303mXxqm62QvHouCulCuelIut9lnQoB7PU25mDwjO+6d5hjbtzSF52?=
 =?us-ascii?Q?RFChno1BJ6puK1dn7Z9KghhSzIGjHABPm10p0IkdjJ12W85emmwY5/LKJWHz?=
 =?us-ascii?Q?FirN2R6bEvZ8wREnrt+jOQc4coTlZTzL4oE7voT1Qk7f16RGKq8vSrmlq56L?=
 =?us-ascii?Q?s6bgrgRKcsVgRarM9dTAHu7gPHe4rL1qvykTgOHN0bQBPqTbUmz82JAjjtIz?=
 =?us-ascii?Q?tFt4OMWs0gusGFnfpAusowMtYD/0s4ahnaMfT//IU+ODzSlmoTyoxx6mTFvq?=
 =?us-ascii?Q?yGMzkYuJ9GTVO2NPRrAcav77jbmVEeFE2lYUXA0zzEojD7An4V0miRaQNoUu?=
 =?us-ascii?Q?rPw4ZTOTBVeYkRKi8sXq2WGvSezbpN7UE15e4SC2lRHgOGg3oqniY25Z9WSI?=
 =?us-ascii?Q?vGy3bfiR0SPXTFGBtOUVLJI1GpUMYxnDXMnRQ0PfJEa0+hTaALjds40BrZ/0?=
 =?us-ascii?Q?XXKUUZ7BZyh2QSw1B1zA2zjA8gP6tbdZmmRp4a/5rvWsaejHcNw0CFX1G9HH?=
X-MS-Exchange-AntiSpam-MessageData-1: 5SK6gdV4KNP9dvTjdmhp4v/kSQeOY5RhkHE=
X-Exchange-RoutingPolicyChecked:
	bFtKtYvnfMzki18kLqxce8qWTK+1fcLZupX8h+MqNuBMMgJfsFnq+gyQ6qQpCvdUh1Ocf7fX4nA1VuTrMgL1wr33WrjXsFbpLtqJ+iN3TgIqjng1gG1+aIk4oHXQbPDzqM6vpklChLp9uXzWn0nR1+4pWA9VxqXieDnBSEismOhcb8Xu1+8juFaaNB3QUqBlo1k/VcuERzVn6S3CCuOW10AbSjHPjs5ouQKFTAjKv5Sy6XQQuXI5rtnYECybLkuCnXe8ibxnocDZF7ZcbK+iVFVwwgHuk4kcaT60kRtXQB1JgXzJwGOyE3Aqoe0Mc+ozlVg+5t01hpMS+VQMZcIF6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WASRoxOKkoNl9NRCwPZ3ivhMW36DtFTnlSLT8NwCzrK7MpEI4+9xfdZtesxBIRvh/2bl6VKf9XPtoR9R7KRwmhoyD5cQIvjX4Nt9W028hyzDEmj6cCmHxn3TJ9BwrKj+tBETK9P/8ylbB4YWfPD+hSwyjkSL2KJSPocPSBTgdLeyiAIM4ABanZ8dP1dt6zRHoNplfo3/h9Z/koVY7aE4L9vorCoB1mSqk30fcG67W3k6sTSpCpJrErBlI0bd89CgDvRj6xTbMT5o90zMwyn2tBQDfAZK41/yPf97txT1geWApNqA7IBSZVzjFOg1BeDusm6VDC5wI5cXsmVo9J9hsYd+21wvp08UgvGQxYZOXVt94D2qyqrykP5lj7RGoe0clemGMiEt/ZKO6crWsAyh33qwLBUYOnftvFg9e1p3nrGDPmFhocow0k73nsDmCtg7HAmArBsc+2wGJQqoYEiR83m3gQ7USGBkCxzNRG35X0H54p1kfoVKjCpyQc6G1s8IEura8WHM24w9izXrutOWc2rGLyOjHIaEZkib3t1JFTbtNeCUYY7CajVhURnC8n9u7UbnLcraiFkV0oTgwMyKlRadmfo/Q6aAYN95rbvdH4tZUXxDnb15aMTi/eTVmRKP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc3a40d-c310-4836-456c-08df2f790ac7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:42.9446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uW1GViallmbCFB7mNxZjpDyc9ZFrsME0cA5fkJijhzFDgXE1xMO2k4VivEbDAUVYrc8tLfapsXcHMzEGhGbsSlBDZvpl15sdz6TvM3ZL2Ag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

At the moment, zoned btrfs places doesn't distinguish between DATA and
METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
METADATA and SYSTEM block-groups can end up on sequential write only
zones of a drive. This adds a lot of complexity, as we can only append
to these zones (and not perform random writes) and for METADATA we need
to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().

Also the write stream for METADATA is not allowed to have any "holes" in
it and must be aligned to the write pointer, which was a source of hard
to fix bugs in the past.

This series introduces a split in the block-group allocation path on
zoned filesystems. For METADATA and SYSTEM block-groups try to place
them on conventional zones if the device has them and enough are free.
Then change the allocation in these block-groups from the zoned
allocator to the unclustered allocator. The reverse is done for DATA
block-groups, which can be trivially written on sequential write
required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
a high queue-depth.

In addition to this, this series reworks how garbage collection works in
zoned btrfs by a tackling the remaining accounting problems and
relocation still being triggered not timely enough to evacuate the space
the user write needs.


NOTE: this is a combination of
https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
and
https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/

Because it makes more sense to see both patchset as a single feature.

Johannes Thumshirn (25):
  btrfs: zoned: fix possible race for reserved_active_zones
  btrfs: zoned: don't activate conventional zones of mixed block groups
  btrfs: zoned: skip the append only metadata writeback path for
    conventional block groups
  btrfs: zoned: never activate conventional metadata block groups
  btrfs: zoned: use the regular allocator for conventional metadata
    block groups
  btrfs: zoned: only take the metadata IO lock for append only block
    groups
  btrfs: zoned: allow restricting the dev extent search to a zone type
  btrfs: zoned: prefer conventional zones for metadata chunks
  btrfs: zoned: use plain mutex lock in check_bg_is_active
  btrfs: zoned: use plain mutex lock in
    btrfs_zoned_release_dirty_metadata
  btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
  btrfs: zoned: prefer sequential zones for data chunks
  btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
  btrfs: zoned: don't count in-flight data as available in statfs
  btrfs: zoned: don't recheck the reclaim threshold of full zoned
    block-groups
  btrfs: zoned: don't account superblock zones as available data space
  btrfs: zoned: factor out resetting a block group in place
  btrfs: zoned: prepare reserving the data relocation block group at
    runtime
  btrfs: zoned: promote reset data block groups to the relocation target
  btrfs: zoned: return finished relocation block groups to the data
    space_info
  btrfs: zoned: reuse block groups emptied by reclaim as relocation
    target
  btrfs: add btrfs_bg_type_to_num_stripes
  btrfs: zoned: keep a zone free for relocation when allocating data
    chunks
  btrfs: zoned: don't count the relocation zone reserve as available in
    statfs
  btrfs: zoned: provide zoned specific reclaim sweep

 fs/btrfs/block-group.c      |  45 ++-
 fs/btrfs/block-group.h      |   1 +
 fs/btrfs/extent-tree.c      |  29 +-
 fs/btrfs/extent_io.c        |  84 ++--
 fs/btrfs/extent_io.h        |   2 +
 fs/btrfs/free-space-cache.c |  23 +-
 fs/btrfs/fs.h               |   2 +
 fs/btrfs/space-info.c       |   3 +-
 fs/btrfs/super.c            |  30 +-
 fs/btrfs/volumes.c          | 107 +++++-
 fs/btrfs/volumes.h          |   1 +
 fs/btrfs/zoned.c            | 748 ++++++++++++++++++++++++++++++------
 fs/btrfs/zoned.h            | 118 +++++-
 13 files changed, 972 insertions(+), 221 deletions(-)

-- 
2.56.0

