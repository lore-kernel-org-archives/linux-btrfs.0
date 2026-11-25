Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602625;
	b=4vQsC3uA5Y4sWs8bFTmFkaUtIivtN71VyGiX/uH1TVcUUXTGawNkqJyWifYRBYKkSfxC
	 vjQMlY7fTLo8peZxkXE9EY+5YhezrDjPYqN7r1OpyG9OoirCGHT/h6QWWjQtORwzfCs8S
	 SQZfci6tIH45JcroDpfmdZD2iS0OHzPhHpKa/6FcknCzEhji1T3Fe2ChJlDPqvZpzxpej
	 COTQQE6DWMJ9LF79rWf5IdmeqKkJUWNJSZTK406DU8TbGa3kQpblPs7FEE5be7mt1um7P
	 xwX6QOJ68P0ZKrHOBtkb8exoYJ5pxzR0aHveNYZL1VjJuncqYERGn1p5lRQsVtqA42Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602625;
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
	bh=zaMhJMytpqZkcHSZMLTcGdDI/97NKSurzYHdN2n+5mE=;
	b=ntUhv0pnhozO7AaZfoMahQuWsJ+6BmPBZX4XzOUIVXrhylpeGn2Nl7DTT/B38JhUvgYW
	 1V8+cIZTrR2kO6+mUpdqttOvODAkJZ5Be4fOG9VLVVP5gNVXAB7VM6hHymDErFGQRrmXR
	 cID95H9Y5EZcKa4GcxzwY2TOWidEcvCIfc9CpBcH5xIW+7ty9TUCUWI34RahBWan2FAkn
	 GjubFksD5YUxbgf07PqAw1sePFofHjM/TluDBaJbEJK94bsSdwn9TLnRTAKnOwIwOm64+
	 6o3ufQhLTEW8I3ao+n3GxU9a30tAGkKwH6/xng0dOQz3aknC0WFn5uOg/hkWuFaZHaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JBoyed1+;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=L5BIq59s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0563C606A327
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0563C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JBoyed1+;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=L5BIq59s
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602624; x=1827138624;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=gitAiJO+WbMawl2I2q9GiXoMj5hgdnenobG3PyKSPek=;
  b=JBoyed1+VfIFrfEw6L0RvJ+cLH9L+GZAfzD+y84CHj+mB6Wgymtfszg2
   4EaGBEz4sZDV3CVzErVMKBrkr+hA2W1wd3we/Uvi75diPK8WKqOQiMj30
   h3HbY/uHCdOCE1XLa1gDRoA/eHkT7d/YWXWULEDZwenHnfuHwTfT3q2rj
   q+TF77W/vcr/BbV6/OTUXmxbMZBpAtaR/rRquKP5lnRO3KSYcii4gAJ9j
   NLWQwOJAcbYYJiQTwp3ElCXEHNjMLXywq6qiWCIYc4Q75pms68yY+tFNN
   /SdBhp1WMJCMNTv5IhkDAjcMzKIR7FqMp7DFmo3v4xkWTGAxEDwOmu1C9
   g==;
X-CSE-ConnectionGUID: 9kGcjLNmSeWc356XkBqvfA==
X-CSE-MsgGUID: B4Nr3zIjTq6sTJDAoECLpw==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662136"
Received: from mail-westus2azon11012010.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.10])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r5h8Eue4zhycZaTlj63CssBo5eDEj5CMABjKEJK4SbRHWf4hyAVPRS4mBPLTdnHJ9NTi0EuNRzCeogSM5CY5583xPxrHQVjUmuBeZdiIgeVV+2JN3br2UtGaHhqVhnDJo1s+lFSDWHDRnzS8+JKW1JSxVBncQ/ZU47KRF0EVxOpqpNNSm7NAdkBcDki88G9l2VJg5hdy3uy1c11we6S6DqW2P0rKa+F3BHDqHX5EAQ7yw80EfSbbhGf70t77GwGtEMO3NmK6JohWCqNZd0DrThjYfSSO7on1jyRw5QyBLGXkPiUF0XKfeUuCPiSbVlcFTXIvCjwlBlofPq4IBjoRFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaMhJMytpqZkcHSZMLTcGdDI/97NKSurzYHdN2n+5mE=;
 b=FWv+X3q4tlOWmJ/7gJkws2ugoiw4ISQbqpmc4PoH9b4mowvLHMHlkMMADXJc9HBVHrLhpUHfwztA27qa+OlqC8p9enoH+pZs4YcNgvhKl6OEQGzNBjFQTspOmFpZVMPVuGN73wYCpDd6gyycrCWlYRJeb/6PZ5scRHY1WA+pOIngYpSva2syR+lQ4/8w8NROcAY/PiJqi8bgLwexFYFaQkWze49izI5PBPMc2+K8gRvqT1YqeThC3eMyvA2JBIlPJWxvGPCX7ykP0G95uDBoG8xUEErpGte+8zev41sBXidaqjBXESysLY9W5MX8/BZZfnbfWOAby+DaosNaq1t/sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaMhJMytpqZkcHSZMLTcGdDI/97NKSurzYHdN2n+5mE=;
 b=L5BIq59s22X7jArQX/lg0vrF6Y3feYHvoEizk2iRuh6KCbJDgf3XztYLnwZ4kixc8mNpYMn0AIvgQ+auaO7jlLqEZ9XaKfHINZS2MvAMrDUqq5Io9/VpoG2FDU9OBVPLO5nhwCxhj5lvPcS+hK1WW04+PgBqdMkOJrCN1Lw7LWI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:20 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:20 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v8 03/27] btrfs: zoned: fix possible race for reserved_active_zones
Date: Wed, 25 Nov 2026 11:29:32 +0100
Message-ID: <20261125102956.266389-4-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: fb587df5-83c3-4154-b790-08df4adf1b35
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026140227099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BV4W25ce7SzPjxkLVUjCYUHkRfxE7CBIlzKkPBuWnsqdwQBOTv9uxQK+1wQgx2ByyfjhFvB0yuS3JBko22XwIw5GYR3NS92vC/thC+urgS1YlEMpQt9MbaIw2cG5kYFjSZwTLlsi0RpCGk21bWD/bNlaB1LVZxNzrPQVmKxRqgoDvyQCwe7rWeWeqNCLrZS64gr8TjHpfwwma5ukNpZ9JSVHIPxuCmxxTp9n5uaLm4wZXmdsqcdmI/+cLU6l+Jbvt5SjoMEbLu4gg2rlZGfkAT+mUeYt82ZvkLXnsNwaP0paHu/Hl8RdB5Ux5F/cxIEJIQWs0earMrbN73Y6xaRgOauAUHHk79Fy+pRQev/d+bCiji1bzAA1PDYk8G5tJL8ExEsv6R7BiwkOvTQgMZ6INerLGIK0yJ9yuPu2tJ5WElprAwse20Cz/jo6lxpFABtn9RLn1Qc6LdnmxnDO8K/naatx2KSBT93DF5Z8yhs2QrV6GWwKY3LCnNsTgGqs2OtTGU2LLP0B3uF8gXY2pIU5mQZF1E8VxeTQwfiwAy6tVwHRrhukUSyp+0zGr5i0+Id8+z/jcA1oLZrbVnWesCs3bISc7gFJZcD6Ex+Cjgx6cy4EsfbBGKvXD2bxHZfxUumGNunu57OXu3CsFsojQekU5ruBxFV+X+eE+6Ypt3NELGc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026140227099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AfJEpQJfuiRwkLDxuHe/2c9E1U/XRLZFnzJVUX9wRjr7pjHlYijktS4HIRnJ?=
 =?us-ascii?Q?fymfeE+HI0DwRnYR8DQ8nwvriIQxQwA0NE3O8/RYwEAhIruPU8Hv3NZhEREf?=
 =?us-ascii?Q?uban06kPiCVdK1vYyGerZmb7mAnnaVZ23+lKHX8B+r6O6PCRKYh123EIdYW1?=
 =?us-ascii?Q?xUBVd2VYrzSMmBmLAp/1+yydDGiwCdCatwaFwVOqz3zbLYgSNAqw2XpVmqnV?=
 =?us-ascii?Q?1KgfbY6jsaBPcvdKaykG84D7IqXVnvL8Pbv2P6Ppza2/lE9AkuDuzAN82gFc?=
 =?us-ascii?Q?VfrHRYaiBPBYsfREnUY3QcrRehZ4v9Vxb6M2NSG0R1LXZ/RWCA5bAXisRdgx?=
 =?us-ascii?Q?BRrNfL2LBu7w0yA3CXPhtFx9otJmqZrg7mLvxhAqY8M4eHdGZ+FSqEdNP9fg?=
 =?us-ascii?Q?Ol57lRMtv5p3srYdfMVh1GBnuWD3kY6gZmoesk+61KnCML6BrtU11Pt60Ybo?=
 =?us-ascii?Q?o++WFO5muiDfHptsxBKXRDtvcoRrvvWv0EmquIp82gSCC7dEEBt2sctqyQSX?=
 =?us-ascii?Q?/LP3F8rLZfGbArb1a14TT6ZMf3BUR8etXnOmaoiZITyni5TPB24lrq9h15Wb?=
 =?us-ascii?Q?eT3ZoT9UGUNw8Goh6O0KTENninN+4DzfHY56cLLCuI5FgUrf6jn2iZFX6hel?=
 =?us-ascii?Q?ioLHQ5l8TL9tN9hxBCFaJriKRnJoq4TkUSKyVnOEtT2gpkLekr3xPcFrtL24?=
 =?us-ascii?Q?ublJQ8uB/sKuAWn7Z77biI/LS4yt0LTjdTPPpw9+csRc6vd9vQYHvnBM1H2W?=
 =?us-ascii?Q?sPuw6BUjBnL3tfIZw0PKC+BsCltrUR7n+nE8RL8WEmi5WqHJ72D+8Fc0BH0e?=
 =?us-ascii?Q?/IkuYDRTH2iFFIe+lo5FPIuAoNzeXpCS9TVzlpmDhHU+RIoTWGQepI8ntorn?=
 =?us-ascii?Q?DU90ybykcn4gqzpdD5IUq0itWi+VOxZSPqW7qx8KFQGKwN2zrKX+OAano9dT?=
 =?us-ascii?Q?nYgKaqRBe6oEY4Pe4XoRbyai+BgFuMbXvsWIWxTfD0HX7ti4k7FWI7UCrcR9?=
 =?us-ascii?Q?f6NampbuFwqn+l8eDXrRmhfO/Xam/vTZmvLAY+QrLGzwabPLPbswgEt7fwON?=
 =?us-ascii?Q?lDT25yRDFcG5pbZFWvLK5MbU7mRio4sdS+aKS/uQhFT5j06fj+shDy2jPJxB?=
 =?us-ascii?Q?f1X9d2Tlwo+yVNL3+uSG5vO4jcXIiAVnNZJ/d8o9CophNhbRBAPnAG5L7uZk?=
 =?us-ascii?Q?2OqscoG2befcsdqPStDsHH5DxsQncoT+2NC4rscjoA9hieipzYGaoE9L17Ew?=
 =?us-ascii?Q?0DioSk/lljnBcV87jegU1Zu70U5UegvnYjQRLBMzYFZL0XWcimtUt51Qgom/?=
 =?us-ascii?Q?o4gP+8nhjWCeFIemZgARD77vS8aIfXoIZ+JFDDjeTdTSnelDP/0Bqk0x4Bql?=
 =?us-ascii?Q?w7H3d1z7Uzl+ST0Yd0I24/HF0+OkyXJvdfxFWfQQ/qwhDP6SyjoA3YE+2yYe?=
 =?us-ascii?Q?o1fwvrWWqXF9RdjKI21nMQDgsvfd/DLXNgNzCX7GYEqbxy5S8xWXhre14zQn?=
 =?us-ascii?Q?/CT+r5h41wKq2YLRcUyCx4cI9Vj3UJLLVGnxDLMVy8jK3BBdMsBASdTQ4ryQ?=
 =?us-ascii?Q?cuB0ZsLZqMphQFMthuDda1JP5V5pAxck8ofSzhwEuAjMyFQW/j1YkOUQTwb6?=
 =?us-ascii?Q?iwc6Hc/g6nlgYbvTkwcQU82gqoK9RpTGDKEyw8yz3JNHVbBx8ktRRotlaDs3?=
 =?us-ascii?Q?UCFYQzgIk/n4sr/YxcBWLfTiENHELCdR8gyTDgYZdhAE+V3qIjfuOJRqf02p?=
 =?us-ascii?Q?YkraSbJbzvELHzzIXIjzaFhNCYunE43dByxZgVLpKCD7UumtHqJoygRjVF7U?=
X-MS-Exchange-AntiSpam-MessageData-1: uNiKGDmT64CT+wDTz+N2xovnyT0jdvGY4qU=
X-Exchange-RoutingPolicyChecked:
	WuUvoALCBvvce3Yv4FsyDJOMRGVr+DppiU+wCOAoJSAsrV/lE40ilDqlmMng+pQrmWrNmxym9RH0KhV1cuid+t9VtKAQqJfMGy415AB+zbNhKzfpglkXA3rjKLL/yQj5l6gnqTpK+KScwEiBPNxOcNTrKCh1HTi1Yrt+StB39y0VmKkDwHNi14XhNTMm9Ss85v+CHhP81H8z0+xmI2Wp7RZK91KOt6Q8V1eJ630uVNpgznkJuAg2UYum1qLM9fBnN+CwNRlz9vQdKHLcba7xfBZo9xNHbI5GbvNnHo/TwH+fjvA7d6DQBSTBbnvqLQ6ooEHR6NFU14h0bIm8KLxLXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5UxI9Qs1D/ea6kat2WczZs9y6GreyiNfrnZvfk/giUdT0ORMYUad+k/ot8Ziq8sEj6Ml92ywcqoD2/Qxyw3IhkeCYkOJ18QqwZPXqWO2zNAtyTLP2FZX4sCCyLWkvVy3af5nLSXNQUS3zDz1+QAoSwfOwIwqlqX0cVQy92LdxwavowNnnm/WoCZaqoQOgacvqEOcg43s5o6ymGeinSP6w6jjJ+3vj7rZSmYCwKjfgvMDAUzT+cu9C+qWUglqr1JFLHGFDJvSfO5AdkcDgJaQ1lGMcd09khEO0i9XQ0WiViXrA6r9JIhriH2wGU9j4L10aLqdnJYGWW31z5YcepqrmuqDQUsP7PYdb0fneHDChINm9fNHOdRx28DYnmQcGBjwXRs+mLQZg+sMlMyxcpea/oTEUuyl6qqugF87NDzVz2KiwxWmK04eskGBQMZdSSgX3WCHJJQoIfax3di2cSpJ9f/1YdcMeRToNlg6ao85wdK9+xffrH/sgoA1QjmdmW317THSgZAKRkH43bJQlzvmnmdeob8nGStF0J3C6lTLUQJ8NnaE6fYv4Arg7PzCrsSQQxOOnl+GsKhoQV4XjJwXSwKAfYb22FjvKM74GPJOnsKOxq6wUYeG5C+DHNU8O800
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb587df5-83c3-4154-b790-08df4adf1b35
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:20.5434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUfNZ40qwwNCtmDMwn7IXlHt4rC527HAGOFDwP6QyzjEpvNW8DBbdXSAn/Vkx1T8NTAuHuYKXyVwf/Sog3YvYpItsng6zhl493byv/0sawQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

In call_zone_finish() the counter for reserved active zones is
incremented without holding the per filesystem zone_active_bgs_lock
potentially leading to a race for the active zone count.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4057f3f21b85..4623ebe5dbd3 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2534,6 +2534,7 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 static int call_zone_finish(struct btrfs_block_group *block_group,
 			    struct btrfs_io_stripe *stripe)
 {
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
@@ -2559,9 +2560,11 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 			return ret;
 	}
 
+	spin_lock(&fs_info->zone_active_bgs_lock);
 	cleared = btrfs_dev_clear_active_zone(device, physical);
 	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared)
 		zinfo->reserved_active_zones++;
+	spin_unlock(&fs_info->zone_active_bgs_lock);
 
 	return 0;
 }
-- 
2.56.1

