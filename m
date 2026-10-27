Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085794;
	b=stiUyaWm55Iy7UNR9cRrSE5z/9KzHdPJ2gtjaJ9gQ3M0iLg0qWD1/5IJ9yKF569bLalY
	 hs4f8A4WjIvnSo4QNQ3BIQv2u3br9VVQEfe+kLToG0PfI/VTEo+0m1KxpPuPttm3DIAND
	 aSE61uzemIKoW1LnCv3QYtP4juGgfR1WwlRNDdRRaIUcMSXLKSq0fgfHsNp+SvXDHjvsb
	 qFD09XaHsnO4aiBTbdf4efMnFywAC6BFh3QCkWTYnEmgkdzS5zM3mkFfAjQLB1u6Mc4/S
	 zZi6/Q7OYhASAC5AvcS6ZI9eLzK6ypITH4GUo8sTdJR8+w4SAJMPENiOB2upBC+6LqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085794;
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
	bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
	b=sLwZRjdZLmnahEuGiYImmgDQCRcx5XMX9KAbWmSawZRQkwWbNAJWGeXu2eOCTsq+aSZY
	 URYt3EqEDcE/fjwVXuWhDB4PnNmuq9exOX4y30NxXhi1DfrzZBuAZKgGWgw99dP1kERYj
	 XPkDpw9tlRxydEdghqMWWpu3WlUHC2P3HVriJ/eA7ygHJ4RkZLxqTFjU+dxi9FAz4c7yx
	 C/gQM8EeW0wpJ86kcjjdQ6z1sM6LNVfTiBvo4zlxrEOI0y8q3MQbjViRXswwN8Rw9NCvK
	 WN8piNKAhPbUMvrobi5JUGCogwQlgwHcMXTddRqNG9bk07KSU+FTRhqtq9tqEcxeFJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Vu6z+L7e;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="cA/6lzg3";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1951E606A32F
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1951E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Vu6z+L7e;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=cA/6lzg3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085793; x=1824621793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cUqYaDxT1RLFCWhH+LO3t06+/blaW3BImS3lqHr7b4Y=;
  b=Vu6z+L7edTO768oIZ71p8z+pCRqRZcM/E0TS22+QwQM1HmJxadd0k+Mx
   dKPyzSrG3xiwcRk30RfZnhh53gaO81qQ1MchSSHwGT9KPihCZOfYRm/7F
   kmWKPJWtlNr5U8c4pqPou7negkzY7intM81ih7OuRV9GfYzm/Ys6uyJ+x
   9a4d8pJC2kr/xZy/jYoDf2fbzzLE0S792hoCkvvdAbqQo2V1RhMjIcRLz
   HGBy8+1d7ujp6RrFx4Yo5xgo6gHGxFrmMNRaXYTkLEKpE9BJOmob3KJLV
   TEJVAoPFTrN7534OPtB5oR0QKxpfSHxb8JYSAgH3lC7DlAo2X2iDqTLOF
   Q==;
X-CSE-ConnectionGUID: Y822zoJQRXS/zBsJf7U70w==
X-CSE-MsgGUID: i/Ajb759SresiZlQFyQzkg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="158990004"
Received: from mail-southcentralusazon11011066.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H3JQQICNFhewEOzH4D9TmYcGqAnuOFUjc88wpYEpulMGbTEzcRpwIcKZmZyQYZNKHcBL8iqMHK7g3+gKq6ziZUDQmBZXvPO6e45NPRc35T/lN0MMIAM8V9mBJA5HfPtO9QAbyvb68kACbsJXz1ysVsNqdG6Ku5enUJQFP9ZAcplC3k43Q/F98IKumJaLJc1wir2uj/tcwARQ7ecc6de6thElnaT64IBfHGMK+JzC+IPZO/QjuQmFhH1tpnU0Eycnl2gzwL7rOCbV8c5ZWLPj/zupGUFqXI2RTbekum+7A0AaT0I7EaESqZac8DTQg9NrLCEhGyacIIJnn3/ckAMzSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
 b=fVf1GrWxDBJtUgBwrI6pEH7XcXZ+gZoHmS1PAZoFokFCMGnABtddMUSAJjL4NtlfRbbpfycjEh+R6AuYLl4BOdq54dOaHVIJ85CXAAE/W+rwpaFtgR9D85AD3w43Me/Lz3BxkYfgUAOew/kqv4x+9ObFOwkvQK4XloR4fDF/kX2ri8IETCr5s0RyHOCK3CgzrIfCyFK6UeF5GO2UYv0w9MYYDHLxTGFVctl2BE3i2VSU+RHKVT1/X06gzRQ72/UpeL1OZW4BNJ/Eant9e6t6stWrKQXtxgbxi6tENtDY/FMjhe8D/d3HkGmB/vFe4WH7WRjXBtYF2+udkGlres/zTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLShoW/f/F/mUl5XVy4NrfcpxcOOH34v5efNTLLxCpk=;
 b=cA/6lzg3deoh1CNRCnQNIrZ9/zlc9f2K8Pw6c27ztLYUAVH/lH/fFHubyU/hd7CnbNsvCl0RgzYx0FUPgbHUadwoWX9xzZOpVV2uKqqmKxMJk8kNRE2YFXJACHHdXYg94g+JayCydOw236Je/aJj1Ufvm76I9OqFhf4yMj6gb3M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7064.namprd04.prod.outlook.com (2603:10b6:610:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:12 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:11 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 22/25] btrfs: add btrfs_bg_type_to_num_stripes
Date: Tue, 27 Oct 2026 08:22:28 +0100
Message-ID: <20261027072232.419318-23-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7064:EE_
X-MS-Office365-Filtering-Correlation-Id: 0403c5c9-d3d3-4bc9-6b16-08df33fb2873
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|1800799024|376014|11063799006|56012099006|261021121427099003|261022105027099003|261009223027099003|10067099003|22082099003|18002099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	Z7tV9XkkiCy65ywkcjWjogyTXUeyvyN/qigNqKC6A6ykL8Q7QRoXPVSCKt0Oloc9I7rhr9tAFxncHe5HosyAjbQUO9WVEd+XRoP291ubRznwRdAtn89QBBSskaEKym+2vl3nfTWSN0aGEhLj2vLoA0uaO/uyVMYcvxjS87jHf9LOouILefEbclk53zfS4YjysfqWqZPEEMnRtMz9fx/HGTrBSD4keMguXWC/Wp1tmvmPSSkhZKb/M0rDH96tDNXZEHl9eDZSwI28PWHLL0GvE7pOzhPExWHEHnNQ82BhhYhCW4nTlUrbsWvPuoFoxzbXbWUPwOEQ/zbnN/Krupl0yXshdSBsPYY8dtQYfruqaVRMulbwOfhNYJtAH+NMX60e+z8PtmsWXV6YUZUQXhN7AFtIcp93aCxJYSkE0UmouYfZGRLqlLZvXhi4KO6XCyjBvhdyJEKti+Oai0l2lG5pDLue5Lk0jIjumODLdN7+arhrJf4bYXcj/94ZP/0XY5rE0XW/tlNdPuWWsqgIIBF+0Z1zKn5cjLhrMTLeDWEBnXcFuaBP721o8XHbjogavL3BxqgKU6FbZRMpU/itAj0VNGo+FHR2JvfQyeHrmbm5ohW2BZL536B6br7gurGCUQ/2Rzc7y70MgYPaa64j7AKpHm3zpT/tNX7G2kr6n63yIqU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(1800799024)(376014)(11063799006)(56012099006)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZOXotR9h4uqj7HD8YeBhAKdCY3bvNcEUihYFy0R+vJgfu6v/UxjnH21TMMDJ?=
 =?us-ascii?Q?JXAcO2qxkTOELLcVnvybeApoKJsM4PoPicvCJ1gN766aaGyc7lFzmlhTYDQ2?=
 =?us-ascii?Q?zbHP74KkmYJKF10/EQBZwnzFWXLxnxfNFnv7t7cDvcRnkJHpyAVr5HEW8r7x?=
 =?us-ascii?Q?3uB6fF+ih7xI85rkviYWFTHPT69Ks088U0lznZrPQ06Lq9mVBG7b5TVO28fO?=
 =?us-ascii?Q?4rNhhKyn1dbuzqlSZ4D8vMjmW0BIKYQSPXCUOT1sR/Ahl2BRN09zpcBplIxa?=
 =?us-ascii?Q?AXSHMe6vxnmep8exZFMl+SVPeXiAdl1yLBoWudO96PyPOX85Ha8CTpOXCR6K?=
 =?us-ascii?Q?Oj9Rp4BYwqPrWaZayw86I1DKygkzmWkMKBs1HlIjzFWU2UZfB7hIbAWupuDC?=
 =?us-ascii?Q?mM7ihPSPvteQ/4zENDewMt17rv6TM3SSmCKf+OoIPI1f9um1nBGT4w0powUj?=
 =?us-ascii?Q?TcZTKc/hcs5Mx24HLJOyL0Zi23Lepns4tkCrkaxjxar+ZjpVK1vSamNuCrlN?=
 =?us-ascii?Q?nZ2e9+MH49QJQf8Lp5XikoJTsULxNf4CHpzf9Dt6YpJdBLeD9Het31F5Om4z?=
 =?us-ascii?Q?00cqZ6amPLp8wTB/3FNOe1wqq+OoRsZKYCkAiqWpS1cPM1VjtmUU12Ty0SBy?=
 =?us-ascii?Q?/kiNqpUu7SSTX5rAeJ8IrxBMc3zirn2Si6acGPNbvBwrYlMORSTwgHHQG68G?=
 =?us-ascii?Q?x8j/k/r3HXCGfebOY9nF9Xr9haSUrDHyV0KvkqynE7LuslX57tza2YX8gWxX?=
 =?us-ascii?Q?SeJylvZ0jDKestrLXsKkDnzWVOGRNoxiUetXSOhZxgHfbfj0u6PbYuPPLE4a?=
 =?us-ascii?Q?zIMNcaGEksmnG0w3qKmn42XCccpB3B032JxoCQaFSibHVvpe4DWxXkcWPyWC?=
 =?us-ascii?Q?eHS+2DfY4PxnFKizz6FgbSxTY9ARe934XbTICHOYudFKfg71uPORKKWP897z?=
 =?us-ascii?Q?FTBptAJ+hTH8KbUje2d/aD+HKcKtmrMGbFpdciJgPdm4Zc48Aga+xiWMY3wj?=
 =?us-ascii?Q?7/A/ob/FjKdBXhOHNkaflYuWZp7TSEeQLdAG4AWQRNkLC5vGX2wXnj/mjNeY?=
 =?us-ascii?Q?R1Up5e6cTeBuarHp/qEun9a7DKx1hvqZQADq0IKWcuUvio8MhklJpMofttzm?=
 =?us-ascii?Q?zMYVQjPpLLUuYJNG81PPQdnQ9kyYfV33cIY1JpnU3smx5yn7bNWOBMB/SrsR?=
 =?us-ascii?Q?/gnLhjT7u1yoe2Tmd3y6jNF0EmjDB49Wr9wPinepQ6KKqQdDzXYLlCIT/p5/?=
 =?us-ascii?Q?QsudvhvjK/wpxPygDe1gtfcWKqQivpTKblN6spxOW1T73Sp0+KuJwjxmy2c8?=
 =?us-ascii?Q?BzMsF8AzLHrca4/yk77h/BrUxbq3qW4MIJ8uwScO1jFDXMHYVzUHMs5MGv4k?=
 =?us-ascii?Q?FRXvO4AgPOSLSNBY+OChdf7FWOKxzvN2pA9mUVazzMWIrw6XpfHwICQqacXC?=
 =?us-ascii?Q?+bHHx0UazS1SR6sycY0KhV2wKjah2W+auVXqgXWU2E/u/6QJ7VkbCx0v2SSg?=
 =?us-ascii?Q?0A/AvUR91L2hWq2XCgkFs5kKaDYq+6S8IAZluOKpi5IorqFE5aJR7674RuKc?=
 =?us-ascii?Q?brULHDpIGwB4Pa5YKi/ztdkw1kccjGWeF/FAsOy1Rexj9ClmX3gbuKrYdXit?=
 =?us-ascii?Q?Md7/XIx+m4nrIePfeo2J5Lh6wdz/TYYXvG7czFk6nVzvvC3pIheS3tGQkyvW?=
 =?us-ascii?Q?PFjFMVl8mbRSWY3fESr1rRd0oTmRi7xn7aPVxflON0vqhfNN5tfN6kSZgvSQ?=
 =?us-ascii?Q?HjviFJSPL9GSi/Ud0YmJpmoU6CQlwkdFJzUsMhH3sCJrVhM0agAhWhURBxf3?=
X-MS-Exchange-AntiSpam-MessageData-1: RNZl0T0o6hN1bRjJiSKsei28qI54Oo2ASso=
X-Exchange-RoutingPolicyChecked:
	i/ZgKPpnHGCWLj0kU89AMbaMxXmEd4l5ZNArYfzjZ1Yi4SHAyuKNNRG1cSfkaxVLROg3Db8EeANKRppHM8pPlO2w/2W7BQIuZeHxjE+kfSFNhmO8n0SZw3GRfsxEpKlQJ9bxtJjCjku9r3b3VkZnxgAWLZQYyJ14FH2kXVJ38+Ox62yw7Eyb6RXkcSGr60XyLB8M9sAimgv391vkqcVuc2sKOWOo5ioXKfTSdqFKBEe18iByANHUWck58nv+HkRebP3kx52KFIB59H7xpo/vPcx+7d2pfVtxjlu5VldlT7iCYf3fJ5yTyDjqoMSubyi6/PQYAVFa4V9yhRPAEbUSsQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pKgAOtupiHsV/k56pXlXQ0uZb3NTKkfeE93Fe/DeWhfB+mosmFpI74SyM06DGDoEEI5CcHmxZ67kHTYtAHWCnfkgpjL0ybZisjdnP1zGRElXMr+KpmK5w51Ricrmv+KK9qi/3TKAjycAzztY+oku70YM3SYIapQWHYN6xJKXXS4K7aZan5jayUd1ZdtfXYOl+6i2j02PwijmoEFNeKeZq2+0ux0IYmKUAJesdskGiOhnROeDps5Lu2rXLDKZfw8HyX19KTPDuYCy6NIn9keEa71GX7ufcwwuH278uXd/0/eAgaoKeUs/bFteQedYD+G0daaTtLlTXwFhQ3mdMrKzlfcwvv7qPv2zfQRiMF6UcRJ6hBFQRD380NB+kI72fDOYLK0Zf1y2ecpCUFPS6gQm/mkDHqOvEuP/mj7/eDL9ShVE1U9o9tgI/OVqgKrwLnFxj4wUD0FLZGA8KcLzghf0zkJ4xGV2fYmWhkS3OmSQuttQqYfBrUrRe6gaiNn3gwUBJFqlgtWNyoHIjZH2DXTTovQHuUYFPuKwcaigaaMQFCaiV451ydU5Nlj26OVxo0Vbgob2o8aiBhl5gX/TcNvlLIYxW7M2Y5M7KLZ7208zS3a+zKTwl7lBFpbs9HcpITIa
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0403c5c9-d3d3-4bc9-6b16-08df33fb2873
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:11.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9TDVM07pn3F9TkDqFESHvP0zCqks6KRnDoxb/zir18BULbE761AZx9onecUCDDQS8DIATbLJw347O96+osd/hc6ycQIma1e/CS58q+o9sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7064

Add btrfs_bg_type_to_num_stripes() a helper to get the number of device
stripes a new chunk with a given allocation profile takes. Profiles
without a device limit span all writebale devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 13 +++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9721efec4e45..56cecb8550eb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -195,6 +195,19 @@ const char *btrfs_bg_type_to_raid_name(u64 flags)
 	return btrfs_raid_array[index].raid_name;
 }
 
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	const int index = btrfs_bg_flags_to_raid_index(flags);
+	int ndevs;
+
+	if (btrfs_raid_array[index].devs_max)
+		ndevs = btrfs_raid_array[index].devs_max;
+	else
+		ndevs = fs_info->fs_devices->rw_devices;
+
+	return btrfs_raid_array[index].dev_stripes * ndevs;
+}
+
 int btrfs_nr_parity_stripes(u64 type)
 {
 	enum btrfs_raid_types index = btrfs_bg_flags_to_raid_index(type);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 75b1179776c8..27e0ac8fcb14 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -914,6 +914,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info, struct btrfs_devic
 enum btrfs_raid_types __attribute_const__ btrfs_bg_flags_to_raid_index(u64 flags);
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info);
 void btrfs_update_per_profile_avail(struct btrfs_fs_info *fs_info);
-- 
2.56.0

