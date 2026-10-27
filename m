Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085771;
	b=cwgOSIsjrBlN0eKfFn/jOnWFcjKeJs44C4lunWN1YojdrgvG14dlzBFwIZ8FGivC5O2H
	 TEZO/hF2qyUm2qWYR3sr/ZgiLpY/JiE3ph2Zx+3O34JMRh3ETiSwx0plK34DsdqcUjAin
	 JK2oZSZh8883nLVzUAFJTbTQGH9qsU0CXzSwaW8cKIItvKWI7S/MngufvLOJ29MV37Lc3
	 fnAwJlwv9uuo5mi1i8eT6dzDD607UxnnLkhnlGQG0DjcLaqmInbklc2OQoueaOIPgDV4o
	 cBR2PwCbtvEEW59Og83z4LwvfPYzMaPZYW8Zk3d0FwRCVKGbVm25R+BoC9KGQGH4W1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085771;
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
	bh=n4EOjjyUviNjRBHg3MutTj5JldmKzBguVRSqRXBO1Zg=;
	b=1HYQJ+8i2VPXwDrjOWeZRW82ggsljtlvgwMgc+eyMVhd9bELR4bZEbhl/pELq1R1HG1z
	 muQq52tvPw56YNFlSip9WxSIHSG8fBfx58bh2JBOKtOarwEZdcmZSipOOGRFprdo5ycqo
	 tVCXisDUkpT3nNcqlJrsZPtTmzW8gOca4qrJ38GgVlXWQoxyNtDWCAYI9zeOh7S3S+Gaq
	 f//83CFHTObuD1ExDhBZbeDwt3lnKKfSDwGKW/IR3Xcpu/87lbTXGvlyyQrMjs9walCoX
	 2stwTQvVN3iuohfSGwi9PH94zy2Lg1pc4UiXej6pgV/m3ztyr2Z7vKwAunqgnfztmUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="Vf1sRJ/u";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=E5k4ExPC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E56D606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E56D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Vf1sRJ/u;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=E5k4ExPC
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085772; x=1824621772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=hnbCc7yJE8yv8PXPzEUgFMa3kVsYGjiPecTwFvEssJ8=;
  b=Vf1sRJ/uYKB5K+rFa0YU34dKfTKmAckTGTpXU4CYkExQgSOCSrf+eWTI
   TedSYsbxhFcH48g1g96NKZzr18/cmpbHoxhEgeI/NjSTisZSpZ4lzD/DH
   FGFUDYTG1PQraymtf/hp9XyfGT+Wlsrtb7wHp11UksX7m2BuZwSAbUt2R
   0PJqjGUVphQivF0Zu+m0oi1qXJz8FiLOqVEkafbLsFZOp1Sk7pXx2TcUY
   d5Ideg7n/da/nNgamuNvmjqMX2nzaJU9pBY2pf+s6cpivPKKcbdeeUuk7
   g2M+CR/qu+y6OVa7x3UMyJEsIh9uamcHmoVEwx3buQKMKOkgLNyOfJO+2
   g==;
X-CSE-ConnectionGUID: P0WP7b5FSNOSjp/qAQKKRw==
X-CSE-MsgGUID: vWJqeK8DTdaWELpIhTxCog==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="159092287"
Received: from mail-southcentralusazon11013061.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lznpKK+JhMxfyT0JJGhyguFRdjKEs8aGMArHnKm2psIcm3PXBx98gVjyqj17XiCCUhLg9dOKqlT1q6RitjisSbwuQOQU2SPWTW9BlJpudepw7dkDVQr68HU2WyS8ZJiZ3CW021uW+06nykeEJV4Pzftdg2AoCpJzwVzaDvVXf3dKzmTW8Wwok+EbLWpQFRKEXBhv7r3v5AoViGIr+jR+eZFGCsDtUYIlPMuFmX6YupcO2zqCZlMjPC31QsHHM1FklTiH+YnOj+pUsGNexm/YVnagg2ee67t8UPriDvSeJ3UnosbrxjWhqwNM1YrSbfmpKu1ABF1FB+UtaRj8o+zHKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4EOjjyUviNjRBHg3MutTj5JldmKzBguVRSqRXBO1Zg=;
 b=W0zHPsuuR3A7W/J+8YKAiNxWEC5z3TP3jlVeP4FVVLsPzDe1RqIRi1Icd+gmEqzPcepfOz31R7mIdS4BEFW+mXyQYdkbn4MdazhIp3OjS0iVZmopQGZOWOuPAzkkWvjrCZgB1JF6NrId3MDeej/RBshiCvKyuNlGhhLYVdtVnRDCEZRj0ZpRhYEK/WlGjohS9W9J8nGU6M1fQhi/pTBYB7fol+44Yehtb6HiTxeN7OXHrunt+cezHr+LiBb6RjdcjOWMne1wXuO/+2qT6j6QQUXBUCDT3mjBQLPOXifZVvG/PCafDbT8iPSaea/BBswWByxgjeKXXjOnZUTQPZ9uFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4EOjjyUviNjRBHg3MutTj5JldmKzBguVRSqRXBO1Zg=;
 b=E5k4ExPC0J4k/IsLi/Ui8P/lDktplR8Gl4pNVhVvS0iiT86irJqn0av6TMNVcxrdNtf9VwyRBP8Uj7gvvv9C2dngAg5pg3RxMUK3iqpzw6z0EfZY5WjJf7Gjbk5RMHNUb6hg0i8XogA22cgbQz43897u3cInCPIydD2y1YeDzMQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:48 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 01/25] btrfs: zoned: fix possible race for reserved_active_zones
Date: Tue, 27 Oct 2026 08:22:07 +0100
Message-ID: <20261027072232.419318-2-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 95ef900a-6c61-498f-ed4b-08df33fb1a35
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|56012099006|11063799006|261021121427099003|10067099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	Z6AA/BQ22ERObscoCwn38nhnurHVdc/HG/ypWaG/JGNLq3jKFtF5yEXKQRfXTpTYI13lk7I1anjdJbURTLQyDTD8sSD5a6DOKxkE2dWjwPVQ+X4hczsRsswQ3SAj931IMjdjLgzHnOB6oljumFkbyBaV63DgjdhfbZbATsqm0w08q9RWoFA/VdyPWp/xc70/AMCl8q1QZvRRQloATzVN97DT71kDMVPjJRpYRRq5n0tbNOhHFYnqWQuXnr9er3BdTmgYBAdvoLknOiLAhpOXbEQbvmw0xIPq9ZeUl/UEaOj8iJSGj+U04nffeoci6QiN3AyZXukz//t/eDSAI2XIfiEe2P1L5kVyIb2GgAmdB4H8b+l6qmNWv3yY/xW5DsUsc+QEDgFhntwGUqZGkEB4Jok35vIoRfOoMoZuzlrUOJhW82TnnAPienjOnROrTnwspspNhUHd4Lrxu8k1Z/rTmeyIRdtu+vkNQi+stD2zJBzLGVnw3E32XMPz2b1+4wlMLdYVBGSPuo/5KvygJgJmxN96wMql0GWdwSdBWm0pUZf+1qiyL7ZAyNKZ3DP2KM1P/gek3iTCxmOBx4CjAudzwVrAuhrHeFM5HXucvQJ+Hslsk2cGOpYBFMMWpxwzA9Bo3019qAjKEq7ci/jYOxdyAs8qPFfN58b6HBEeSabf8KM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L4/7l5G2revwimRVi2BbPCUXgq7M0muxpdg6bRgZsgB45VsIICjaVB37vYox?=
 =?us-ascii?Q?dh/UYGNyVWiCIm8I55U+3d4R82mMdznOgloaLyU15JAslI7gxUeqMo71eeCH?=
 =?us-ascii?Q?yALFrHoQ9KzshA4NSoycgClVGQYGkp+1tlTBVla++djHNFjit/xYJE2cFXpT?=
 =?us-ascii?Q?8QuQwkFpR5aSDJBWfEQsbOgt/m4ONWvEsoV325d4W3ajye1h88dm9eidnuvC?=
 =?us-ascii?Q?q+ALYCOzNczP++0J6euo9mRgcNS9eHiXNKNU0eI2J8Z7xysWDmKwd6PttbuL?=
 =?us-ascii?Q?Lyy8cfZCam3YZuKQdCNYytr/93J2ALUNi6CkBMkFCE++elH22b/QWZ7pygfH?=
 =?us-ascii?Q?tgbFhxSpgrTgiXqyiPMjzv7Qncmshed51r5CVbhG5r2pdtoeSjHQgxzsltYf?=
 =?us-ascii?Q?3TjId02hsyPi+8xlixXehBRgdAxQ3U4QxkO7rM/7RrhYH6gHX1nmJrcnQ6u7?=
 =?us-ascii?Q?fcMJSX1wv5DULHAeW2/LXJWTg7aMmSYQRZANjmv7wI9HEL/P6SgWf9MkEyn9?=
 =?us-ascii?Q?Qgci3pK3puGNzGjrn4w6w72Nk3OaML+R/9jkJZYhlyz/J4kL3gyxe2xQPUgP?=
 =?us-ascii?Q?pQjkG2Qg3QflZ5SbQKUR850b09gVKoOX4WWeV/la5GwajOWE5gNL5ngoOpBQ?=
 =?us-ascii?Q?tAJ99I61wMWtqpLU+ll/M6xqKdnjj86+zFrYsVzzevNiwB3uz6sqb2ZmJuYW?=
 =?us-ascii?Q?/uWAvxlhVubCRL2IvvfDaT5Ldnj3OwL4/r/eU4f4wyXsspVUXMHb7K8qXVsQ?=
 =?us-ascii?Q?gnoVnS0i59vWpzc2QCMo5vE8nGr9tKUGnVRcOCgXmvWTkFu1/cR4Tarv9Ofk?=
 =?us-ascii?Q?3p1dgW1gZ1eBnsd/ZKUrC/vIPgUvGOpjRVS4HxX1VQlrkfGMqGa7V0e36DI4?=
 =?us-ascii?Q?x48dX4iOFdTbqUZUkVWVqbbHFK9LB18/zhOUQssFcrHYMOUokLOYrEscOMb/?=
 =?us-ascii?Q?L/3pttF5eB17Y9UAvl7l8yrc8z3fVzZbpaFXzj3cjHKkT5fg+LleKyjdHxVH?=
 =?us-ascii?Q?AdrkxdmpZL/7K2pP4tF/03XjdYbW9mj/TXjM00Btq1mEuF4nk8ihlusDK5cL?=
 =?us-ascii?Q?ORrd1w7Nt9oCtJJujK5IBZHWe369r6iXwYtZim0xGbMb+uTvGGNPzEinhb2O?=
 =?us-ascii?Q?JugYUlTOWjtW2nwLKFn8NuWow6a3N0LVyj76Hv0AWF7Qf1GDaxXccDStTxf+?=
 =?us-ascii?Q?HduRVNCWxwifiHFoa8LimFCxpz+e3/5Jk17l3zqgwtikhDbkPzB03nEf6LD4?=
 =?us-ascii?Q?auBnZCia2kWAynPe0aOkKj8Yza0QLGdGI59i8RBllRzjCAki8TCOU0aOddfn?=
 =?us-ascii?Q?YWYLKqkgQF+6BcWomBuInTMDN0noM4gtX577J476RY86UF1TYOl6AdFwr5FS?=
 =?us-ascii?Q?8H2WeAb7UL+I0kCE+GliKdin8MkxsS6vfpF8cz1+OG+m6iClHtNjK4g9tssR?=
 =?us-ascii?Q?hz0dcRegzOBgY1xb20IF5xiUS3lM6H3Y4l/XvPbhd8Uo7ItFJrila6hXbPxA?=
 =?us-ascii?Q?fstz2ZAyqUEgDDEvXL8wyJVKez4OfKCipxGdILo+32TadEgrrDwO5u9tu0+0?=
 =?us-ascii?Q?Tj88N3fMVCUv5yJL1dvirQLREAYbNQFmxo73OjEELmAtBHGcL6dtqiW2jts2?=
 =?us-ascii?Q?pWLzftHBr1/hIAwN4gYqabJFUt8hFj3cDL4S/5qvabpl77ce4M6E/Md34kxY?=
 =?us-ascii?Q?4V4yzetrvL/LYYUI6iDgvk61VieIPyK1RVesFrtaTLOBOwgYwzCFUg/zJATH?=
 =?us-ascii?Q?4XcYVgrqPm4Vb+9rNfR3p6iFJBj33qK/dqGc+WFk5rOW+167HjYLypFKpT8w?=
X-MS-Exchange-AntiSpam-MessageData-1: n3jH5AqQHuhCEfVy/WhglwXXCllFKO1mSAQ=
X-Exchange-RoutingPolicyChecked:
	I/yPLo0EjH4NrBCCp44tY0OSLbO62iDlGs6ti6RazCVSuSu8kYT756T+c/dIIQSXZv2nwebm0LfqkaMwjgH6ZoHngPuINkyVQY5RVB2+ydrMb8Jqv94nbIDYKqBXCHqwjEl0DX0ew0jyk5HJ+y4jl8KW5APt5keW6b+YDETED6LJ7Kyzr4zCwrjQD3ge0fTLt4m1l1aDonaHynmiCHDVvqgooopyKrCTrAbT7Fjau0W6HOb3g6Bq5plINlGU4WUeUipzuR9QvUgrRuIkDozPZSdlhQyh59F/Pc8NCcdl+FyrxNxFKMHrqmHafrmAKJSmiWpG1BUGymzsTR2WV6QuDw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NFcUP//ePjNJRnFMJwCvQDx6b6Mv2FV1XIK3i9gkMFK6FDtgRetPVFgATTHjeKDzf7VihXUBU3CUiQPbD2rjljJ+0MB18x8yq7ncncgWsNQ9GOX4DW9su8xtha/KpWEf68j/klW+krQrHKrHHVuhbj4h4jSIhF98xCW3EcIvf3/qkJYbmjqR+Ly2r1PtxJaX6nLMou3LlI11p24nuWPRBhPm9fp9aachFg8a0H6V2Lw7MBx702PiHSVj6mlcWnGZoy1Py9NJEyaqpdCGfxfhMks33g6DXHB4bSogmJzEZhcdXBxGWWC2ZhAsz1baES+vSYOrKndSMS6XyVUvbt1SFGCx2UGdLUgQQ9HvPs3lqzuPJaVA4yfVSvZfF4Fc7K+/Q9lJH+wC8Cli1ZD2xbWhkuBtb+fr5l+cQFCMPUuoHmbb97i9/otk1ZK0Lny6HRN7uAorsLha+7C2jylNwNF3GOD5ckIWUDoyWMagqFLcQaw28g5HD2236A7xiatYGKY9QtP8xGTmu0pXSPd1czheWElce13VGvUROYoTDqirfQPuCDFSqP7iJlO3UsyaYfxIfqUg8T3Qgu008zMIziWl4HhxzS1xB8PxOPGBtyNBhxS7fK+OxgzfKWFLI/MkbVAm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ef900a-6c61-498f-ed4b-08df33fb1a35
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:48.0268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bp8/KMdtv3BcCsE+5xR+rkGsLuCEFLrQTYtFp0mGakUZDpxm4oD83BqlYar16BZooIGWM/LsaztWUSeDD+kbqrcBKpJWprJ1ZpfJXcX14Hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

In call_zone_finish() the counter for reserved active zones is
incremented without holding the per filesystem zone_active_bgs_lock
potentially leading to a race for the active zone count.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 194d632b49e5..d24b5bf026f3 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2529,6 +2529,7 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 static int call_zone_finish(struct btrfs_block_group *block_group,
 			    struct btrfs_io_stripe *stripe)
 {
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
@@ -2554,9 +2555,11 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
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
2.56.0

