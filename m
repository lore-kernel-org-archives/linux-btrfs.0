Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590159;
	b=iW55UwcWvmfamF8Mc/8nW8zriXHuAoXHM+bK8U74yD80tdBDGN5CLIiC5t8jouLZk4Gr
	 NTbt8pAIDenwi5Tmv2KTrdpUJ1/rF6dFga/SFpHADFgkQoH/NPnDkx2ECCKnefmKj7dyE
	 bOvtw6OBeBnnllO53dpruLHl0Y/jjrBotyPtN1cY+LV/kKdJ5pYEX4YWxLYX0PZyVlnZA
	 h2IluZbexKMAWZjcMSxsBLHeivFsIYEcC308JcV6o7TekSXjnO2eRQ2PTgoyuneVoC70c
	 ndnsc7bqMnp+Wc1QTM76ryx5cZ2s92fabiW/0StgXhzGf8xzVtdPn2yMUD6cYSrDS0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590159;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
	b=ZoFGzv3SWyXNLhXjgoENPU1t+ycVOOtTcHqi+jYeLUC3x0ltwsi7i7w0HGG9t93cdvSH
	 NFB0//DY5nGD06/ppDgr2QcPmYu+QGPwxciRnAlD4vU6du6/UREnrwpsxmOuq8vRx6mqk
	 v0N15SV4V75iSaeFNFBxy0yAfBQUEXyXDbbvxZI2GxCp4/GCkbq9WXzKNgNDxlLPQqXGi
	 oWkHCAo4dkaRAbkvIKdy0Z6eP4EaZRCLBzNMtoB+dvY7WLmlszbqP1Xe6Td/LR0c1bFUg
	 7rFboqHYED4RHQyOkQcrp3lGwX0FZgiDetLApJNfKpoEanRjyLU7Az5rmJS8X+kz0LA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KzIMJu9y;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ZU6Iwfmf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2D606A320
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78F2D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KzIMJu9y;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ZU6Iwfmf
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590159; x=1824126159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LkOlxFVHdjuFt0PO30HbLL7YaxB2wpwsnjRSclCD4Ug=;
  b=KzIMJu9y6clj54/7qYQwV1tk2L3rPXqeuuILF2kQxZiuxC8QJni7rE5e
   koonUEA9bpMySmFp/AcW5HAfH6u5clYFh/EPhOt7hP2JHAbKvnqOS/Jzp
   gXXc1tIHZb4hSslPv1MIy1YBKzO8daMKxb67SimY/o6FEMNw5C+ZlWDLz
   KdAP2WytMnQ5HnMGCUSun1FGGE50zWD3a2tczk01ve8aczjXqtWEwTYb/
   xB8vYBgWe7KobH9Dzt3pHjWmZzBSOG4MuZRhG9BTQWt7RLUICCA7VXBTI
   hTcmaFocUbStbBitFHyeilda2VtVhJDEN/wnaRdfZLZgq1aGSx3ATp7i7
   w==;
X-CSE-ConnectionGUID: Fmmhh9jJRcic0kf0hrEEQw==
X-CSE-MsgGUID: zxi7Obs7QiGkjiPxE8JkQQ==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="154422374"
Received: from mail-westusazon11012025.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=txlds+gNhUYXwFynJSrWVesKKtCdkjVoIyEdBDnRROunTFc/7fEnXPXD8B6a1knoG4Lsb8UoHKL+ht5/6RHL8sT1O8a+2z+91UXhMd5f8v6rm1KY7Wz55+pVfcN0hjbIEDJkC0QH68VVN6ygmm5Wf1h0/8uhvD+LRfbZres3FLYa8Ko5hcIRJ5qREbk/tDckq0IIAlNuJ6ABHjnET4/3vApIKZGEhZGwhM0K+9H7cg8WFruAeE7tSmG663ycg7bWchVrpX4CvR5LYVwebla7QCSRWDHew/nAAefbLodJHXwm0/UobC+B4RrNwSKl4ZiyUpEz+a5l1dU0a3cPWmwc8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
 b=mmzegxj1L3JXAo+1CDRy4xJ68y8d2yQWQ5fQZ6mjFtgczlx0cXXN5AhmQ6hsfNjjPCl3IpvN392oRJuqgybjSbDNCnkdFMHnbUNXbrVkbGHov939PqywPZ94DXCumYhcLcbuYbnSoRDwEFhMwSHMYBhFsa1XW3nCAPf6+mM/e15TilClpG/SY9dafDCUXmWPNAItaI8cfNO9r8L4TNp5yF+K5hhZP0TBIQkcQJZ3OqzEm++iGvyhtokwLCq1Qe4nw9KVHjaulj2Z7t8KDr7SUDI/0MGZ8gkUJQC19inExlB3veO5qyE3sewLpnhhzI/vetKnR10Kio0XaS4HkOYllA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
 b=ZU6Iwfmf3UNVFwLneYys9ju+/8mrh4WZ+Ts13foZ+yx4u/dffXjVT/ZlrFK/wxgJ9pkhods4sgUqWPI5yuWej8al1RsQX+t4IXgNkAavm4Q7S9ELAgljqfCEMzjLUas6JiDgt4JOZr5ZBOEbERGObVE2L+db533AaP82mdkRdkA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB10245.namprd04.prod.outlook.com (2603:10b6:510:116::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:01 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 11/25] btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
Date: Wed, 21 Oct 2026 15:41:10 +0200
Message-ID: <20261021134124.2338902-12-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB10245:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a5f27b0-f59a-4433-504f-08df2f79158d
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|10070799003|23010399003|376014|1800799024|6133799003|18002099003|10067099003|22082099003|260925021911599003|260925022911599003|260925021311599003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 aYK2Vi9G/LB2fKEab8FX4UvI+kros2fF4DWrRoBoP0Y1L1Z8EQiYkpbTO1KK3YYbC+e3XR7KAuN2mso3gmFDKn7Uv21rY5ooBvEtcoF1V5DBMUwLPtUkFAJjUHB+zZjB0Hv2yJR7OjDtrpcbpG7pc4gOUT09rnQ+CLA+GoU09MiMId7eaTaJXYX6r2huH81VtzORXWMP7oYC3xYnu90oqHNLFVva2hOtoU9kBdxmPPZqkgyZ1HpbqYniZma+byRvSRvkpTbznnhLRWzHjOVjTYtfxRj6fkEIDW8nrXtDMurDq0mF9UeBd17k2o9FLrXbIxx0v9jzgMcJ8kfNS3fP9phcFJaN4uziNCHuhyaxU+MeeYkEKXHjgHustJ8EebUlv/WPP5kJUdDtQgv4lYEiCNjA2emK0yp0HGU27f95DjsayA90isP3U4hdYL4oQXrLmh3xo2BhmeZ7FD/RxDh7ctrQN3tWVjx4xBHK3/Bowb9PyrDmYueOpkQwd02NM0fl4xW1gx4qfAF3EOu8WcSpF1aLocNnXLvECBhOz4V6iosbzjkL52Au0JkQh3ocOQj5OWrO5a5iqLo/Pbpet4V1HOjrnqZh/P3oXqnHOIgit4+XMGCT7gisku6v+qN+jMwvMHoOJt6R0TRWxeH+0P1XOhRbaAL7HgpoS0eQ8Sa16uQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(10070799003)(23010399003)(376014)(1800799024)(6133799003)(18002099003)(10067099003)(22082099003)(260925021911599003)(260925022911599003)(260925021311599003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?iRnmAYSmA26/z7CJjpiVRAowHW+YELs2zxgOW3xjZmir/zWMbHuo9M9EJD/w?=
 =?us-ascii?Q?BCmITJrdL1kz9g7xd/HNqdR5Biz97tGGGCGZdHbt3Eso/NW5XNe8GpayazYV?=
 =?us-ascii?Q?HKH6QYLSiy0YLHXR8j/MnlNvg0jgG8e9LPjAECh5WyQYeyMBwLBphvn6Nj46?=
 =?us-ascii?Q?U6Rk8bSgJDLWbSroabyMLHUNClkteK/p3QVSl3U5Vm2QQX6T0Bbyd1lIHpod?=
 =?us-ascii?Q?0uqmCpNN82H8/aQQhnUWyRdwz20PjZG81Hy7YbY46nNsqkdvelPm6OruEIX0?=
 =?us-ascii?Q?6yy7S0ClIWQWPsc9neAqEwv1RgvNOwFsjPEb4itCwfvIfNRQcI+vs3TxRn77?=
 =?us-ascii?Q?S1P8oGNI5jCfHu+J3y9M6FrkGnv46xHGdR7tDwbIMNNWas186soZ6GfPK0CD?=
 =?us-ascii?Q?+Ix3CvzgxNd7VMhdaU82+CsGJNXNVhRMJR7b0+zd+Re44DKWULNKA5zDDO8B?=
 =?us-ascii?Q?jK6/xHYaPQLxgmMLQXDqhFVF589p5ukyuWFGCcY9q6lFHzqfHR1v5MHr8QVo?=
 =?us-ascii?Q?cvkXQzF3+b5jmDu6zXULF7fAIC2yyyhB1SeG0H2e2qHgXJMHD8PF0piEp0El?=
 =?us-ascii?Q?IoYnrYr/0wCxW+3Xd5ig7QvjVsSs2ZBv41v9fw2PXCTTGBlxqEtByA1Ddz6K?=
 =?us-ascii?Q?9vyTcokJ+iKUCNqvmD2PbYTUNdPWVy173ShNTbFjCuRUD+N8F306f1WYfgUQ?=
 =?us-ascii?Q?s3Jc6sXAF1mKnAdknbvONvXVMbcxkiNLRbfd7w1bl98bvUwHv6Hh8hM+q/Xq?=
 =?us-ascii?Q?OX4I3ftDYfDzdNkavA5hAL53fsP6Dsb0AH8IXjVFPxCC35eRa+ZwpkyApRh4?=
 =?us-ascii?Q?2DICQK/dc5lrFLb2NJDaYvlpnpn0GTC8zjKZ6emLptNsk1eK4CL/QCUFss1O?=
 =?us-ascii?Q?aGQie9DFvOMlVTUtBQpL1G9uqG82g3D7L4tTS1TwxsCyvhHdjWSKZARxdUAK?=
 =?us-ascii?Q?0Itc+cgyv3nrHkCYjMB6clb463RNn8kDmPPrXK1VuhVwiuZ6zBHQy4EKApDy?=
 =?us-ascii?Q?O+38QBioOOh/XDb+4260sZGer/OPtPTs8+R8yK+6za8rL3Vyf4jsxqWxgXZv?=
 =?us-ascii?Q?cdSFBbEMJrdth0RqqR7FtEbNPY25dO39uy0cAVhMyiqMpc5vqYsJ+yJj9e2A?=
 =?us-ascii?Q?KPko4ySH2NaWkiMII6Q8/Nrld2IPDcIThK0iGOgsXRYSYERXzH5IUM3jnD9K?=
 =?us-ascii?Q?5KnxxOiGR9CqE93VS1kVNZgBC+YW0Lgb+YhDCcj1znNns5Be1XTdJs0jybxv?=
 =?us-ascii?Q?gRyLHxDV1AapgD0YwQOi/MfXhqsXFa8cQpNX6EEnb5YO2ia/qJSbMS2n7EJO?=
 =?us-ascii?Q?pKl5OCRyeiZoU/z7o9LT9EIT7bE1y80Abr3Mgvhew0KvplqNKZiegCkWZqeP?=
 =?us-ascii?Q?jE1Cv2DHkpOHknRjx04VEyRzHn+MALGI1ebQLkfjuYiYVEJga8NroZXqUPIW?=
 =?us-ascii?Q?KhNsl/AOFNfVl5wx1ru75VmaUFCTAiwz5jh5oxRG0eDxtp72aksEr69EjP26?=
 =?us-ascii?Q?mZ2sB5D2dTEPhbVLFqGGrU7DZ+udU/Xjx96Hqhfllb8WwskRNYIyi8jVcFmE?=
 =?us-ascii?Q?AgZpCY9qX3AwEl9t7fSJih8AlHvswVHEfffPs3d12BlVKRW3yIborbhZGFrQ?=
 =?us-ascii?Q?1BMJfYIPE1jGKqyBrlktSeH+jf5VaOHaMlv8JiwL/yvjDCIYSz7qE/c1OSL2?=
 =?us-ascii?Q?xLxKMq2Pls8Wds7pISERpHPR4sD5oVIDBZDmcwo1RJ4JQd74ymc2Ik/w/UiT?=
 =?us-ascii?Q?f8+IEdI/rAp47V0TmehyXQU8SAfcxgbsCLC3bI47YdyYQvXhBgIzYXTfxJm8?=
X-MS-Exchange-AntiSpam-MessageData-1: 9g9JOqbHlZvi4Dr3AT0KU1v1HttytbMew8A=
X-Exchange-RoutingPolicyChecked:
	kGJ2msDlWgujs//gMNz5L7McJ4Xc1JTnYSK+RLChcgTimZZ9vGYOP+Fpuzyk72sshYMsK5pm/C1Qebyn5x+sRIk05W2kY2BHvzxmihka0tEgFkVhV/M1IUbfljvcfY5mvmngUmS2VTLX1oAVwCBtbp4ZNxhkZqgV2C6PZkCZZGF57Vpnm4d2wbxVskoTd+p2xGRLzx6NykNBgki+bHe//RQHb9JLZYIUUXuSmiaI8Fqxb6BAoOahEr4jvNKE9p8+Muy4mrVwwIHRxOK4vIWS6r7n94EO07DjXTvwIcTeOvGVSJGtZ6YAfyw4oBinIAAZeZ04d7MYhG2e3NHZQ/mxqA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RG+oVq1xdDJXn1lO1NDDma42i+20b6ykm2lmSDSWQXCNo0UggIMgNU+hFCjoDElBgRsQo3SJSln/Ibq0bTKkP03Z0nf/JJUbyw4Z0LUB8SnkWGVPh5D6fNmb+YTLPjw0iRFrtZKEOYlw95HrHqCl7t8/mQa9t2w4l2NyX3C9E2QDi5n3nlauupT4HEAhl0FWCLNBeEcWFhjHnZWdXBjECyh5jRiNgktbf/IeuAK2Ob3oHsYXM1oLYtfKtxzqrp2I54HzvPyYD4rbXwnrpMt2+fiGrSwXy1rR8fqrMUMSttwdU9xlW3Ew/o1gVugYP9pIog9eRMPs4cXd8ahhuhZ+eRzy4FflWdkOxbxIWyoR7zsN9J2TmGHwHq9KO5IK79ElI+2HK6e2/iCPM/kOjyq9OGB6vZxXlK0q1u1UkzlHkuqR0Kbk926P2U00MG988ekzjKkGtqqtYyj6jL1hp93ovHwI+MnOY3Rnhz98eW1P6uFYhfNjwr/O9itqCa2T0mUjufYU5zi+BmiVm7t8/DgNxy9nzfCJcMDdpnLMYhV9pa+/lAnlmjxOM+MfLPgbLBMwRZvIr+bbnjSxkW3dKf2q9+xGA08cF//X3H2HGplZFWbFKCkSpDVcq3Cvv/xaxzi9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5f27b0-f59a-4433-504f-08df2f79158d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:01.1574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hyQIWyMS8SncKkGEWxh249sTOmUHikWhBIf7FErmo5ABN2mM5KnCWy8efVMbTjY1blRfycid8X511zDVvDBmXT7MseefEMfLeXWv5hwy9EA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB10245

Now that all users of btrfs_zoned_meta_io_lock() and
btrfs_zoned_meta_io_unlock() are gone, also remove the functions.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index e99786b29587..0e4657347928 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -431,20 +431,6 @@ static inline bool btrfs_can_zone_reset(struct btrfs_device *device,
 	return true;
 }
 
-static inline void btrfs_zoned_meta_io_lock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_lock(&fs_info->zoned_meta_io_lock);
-}
-
-static inline void btrfs_zoned_meta_io_unlock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_unlock(&fs_info->zoned_meta_io_lock);
-}
-
 static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
-- 
2.56.0

