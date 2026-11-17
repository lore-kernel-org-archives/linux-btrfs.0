Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941989;
	b=aLvu9Gca5k8yhGqLqgd7q7OO8doDwZFTpPAeKqiWG87hhnAk+oWebphEFW3IAYyblQop
	 QStZ0EzmU8BcpNVRA8ningU472UIZJ0dZnJP3FnTzqnm2yj/qfzFlbBR6lh1uwVVh/0pV
	 kO4Qevh8/aT+raI2Er47xS0p/BDIc0ZAcqQfyfeBMAtfw5r3My+uZLGgCnJAnTjSQCwFp
	 YQmNFgAspRkcyWp4EVcRvGau1fLZ8vt8csmE2+J/9omv49odGf3VY5TYknS6hDq0pWDMF
	 YWQcM6sGjnTdcOm/mXwe+ZcFkQmFIlTbGtWRY8Npj25iTDS65tyHX+c12v9rIfv6UxQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941989;
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
	bh=O0a/o9HvFzIdi7jsb604opTgEpUC22W4zDbRz9ihcYU=;
	b=H9NNqg6qpU3IPxwGu/FdnHxRnsQvA0GCTFM2neB7QPRee6cUMWCOXU49lUHRS4oElucd
	 brm6De0dwgH9h5G8JLxCL/rcKgeNQB3cWZ5cpvD4I1u68UCI9BElzzs37ga+6dwXYc7G1
	 7AX1UO88WbdYdWYDyT3J6U69Gr1Zkk+Je3ZMJC5s7KD8Q2W1LFLYVC7x3prHUKSmQJrTL
	 9Ms1kRaAVc5/WLQJA2YiOUyCYUSme4D8UgXtYXpo16qw6oFdDqkZ5K1bdhaVBFH+/vA4r
	 Fr4TGr5d1ORWKaQl1uCyA1oZhT7/ztOBg1fz3CRIXM/nu2vlArEt7ailcwUoGZK/+HA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=P23nNwbh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mb5CZplr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101A3606A880
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 101A3606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=P23nNwbh;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mb5CZplr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941996; x=1826477996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+/YpDPtz6QJ0CeQo/YmgnuWD93MPI5/4Mnq5QUR9ERs=;
  b=P23nNwbhbVUNmo4Q5qgIyAKb6p7R4aRQh+0ZgcnSV9hOjqS1SW5bB06g
   lCC9KsyCUsijR4yYe3vfH7a2ik/Qg4tt9zgFRzoc3t9eTgo0IWlRwv2+a
   O4b25P5Fzkx388bMPZZVbqTPPacEHXe05d3nFOm/k7frH9mNhxQ84a/vr
   tj8DxNv1APrzBxByMJg1/r5A+NEbd4SlqHe9/J0rm+i1gowuWyG05D2QD
   dFYFOyZg4YS+s05S1mjfbJ6SqkkiTBl1VInzFgIUCzHbA8uUl3ouX7Uzc
   DWYIqTaw5SmHSXtknMKppxmH/6cNhYMrnW/CeRpC+gwzqprQ0Sd8oqusb
   g==;
X-CSE-ConnectionGUID: oZcqJxyJQx2C/wdAjZqJ0A==
X-CSE-MsgGUID: 1qyQvLvOTYmT4PWAfnNtyQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160148996"
Received: from mail-eastus2azon11011007.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udeMB7/NSuXGhqoBeW/1fKdpK0OgGSMhurpzYyrV06i50v7MHprCpZ8iEU5+v/vHEFemv8gVVAXMz2qGHAvDmAC2zki2PQYhdvjrvPN8YdnO4JiQl8IZG+7aaQIpamum5JuXi6WIN7izLfv54BAml5e4+kovaH5PC7ieDFa5qxqQkg0Gd9PU0xlGErWBc1PWskn/6p005UPmprYBpbu8IIPcFrAIaaSe/wcp9k1FYfSybksJSB4NqPlXYGN7rSRY4w+cH/N3zdy+AG0KLemYpb9P/0b59nsMPVhHpcLURbeG9uMp8tCA3HiDEPLUsN1UpVHdrZD5dCA6ATh0+gkBFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0a/o9HvFzIdi7jsb604opTgEpUC22W4zDbRz9ihcYU=;
 b=DmIlI8gE8hvJMMwkOxQrAEbBIldtWcoEBFsLhkWJWsW3nE5DPLTigSPa+UZ5hUIXyykAV1ffuQcGmAA3NA+hCKvp+6bHOGhSv+WLb0QDulMI5aQ7r9JBvaNeky5eA0/uupfxgcpOExIhzQ1wj6N40Lf5yyX6/kHSjmkiSTTx8JS525SvI252SYMKflVR8DoNYsgn/FN7vZ/4m9Fgu4VsfcmoYL7luid8YpqrNFWhKQYHOQoODlpPrDz9RP+QvIZCMZlAOiZFDoxl/ewsv2QW/dC3mGQZrqw7J8C1JQKFi7jzMhsORdGkfC5iN3gh9z/z/yksuWINafiRjncluXsI1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0a/o9HvFzIdi7jsb604opTgEpUC22W4zDbRz9ihcYU=;
 b=mb5CZplretrtaBCZYisvNeJhF+4ID6B6PenOhTdaTKbT4odtmBkw+SAWr9K/g2JcAGsbBmOjrAy88b5U1zIB8dLDlb7l19Qqf6ALRCXlhnmuxLodVczAa/PKVf738c1M0qRKk/nhZsuqPp2Vnmfe6HJc//NZb58yE4lEjn0SN3M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:46 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 16/27] btrfs: zoned: don't count in-flight data as available in statfs
Date: Tue, 17 Nov 2026 19:58:39 +0100
Message-ID: <20261117185850.4128157-17-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f454f5b-247f-4b23-07ca-08df44dcf26d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	u2j0XjJgrYaFRooiZiOOmcwnZ0zhIhOWaKwSNmCoYrXS6xvPVt+ceQnD0BXK1xDy7V2zptOYw9jrj+otmm5lKvVUxZCh7vsa97JVcw/sTOnmpw40hbvwUZ4RQ1botnmAjIxzsOViwzdSwlovNc2RMkOr4nBxgi6c+fqT4pY8Rf5vSg8wMdl0DUXVqHPA8j9qgE7HYtr9PK9Yq9GNfgQL4kEGoe7o/Dg2rqR9lVEDRw7HVZJMG44DMP5TXh0UVAph2l7BQw4ax/LQGHfrt7wTmfD4IXeEQ45nxqtWVOyI7viQDanjY3yvnH/QFh/7zy1ALJERn2KDCfNWpQ7cnZPzTTtsT/Mff9BdjFHGjN5hH1OURDBJDWf//r4+ZhZ439FSuXXk0UF8PDEamLvpoXA4QtCSj1RVeOwo+Ff8B8pcE7yX9r90fG6Ov3TiAfcWjgk4WcEkwepWbjg7LOgdKOydjR38RWbPrWambOiH7DiYpnz7/OPKGn0kC8HfN6Ln2bx/C0nH+U8fkR7/GbHDWxPoxU+CsU6yQFX7v1JLNO5IlsUieu+0pqOb3STarmUAt0bc0dQSAazDuz91EwFTcjXrN+94eIfSokV1VCmpmcZfSc9SLNXxpFK+EopGUvH4atyUeJSFg//gjo58qRUdBJi6L/7KAdR5OYzugbDumc5BRWA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OwvlgFNlsarh1S2tlFKQjGh+QEnfflfd/WO/skW7BY+FB3uCnVbMQbZ3YRDV?=
 =?us-ascii?Q?Uy2m1EBx021tROT0At9gKF1Yv4eOW9TnEHowXi/RNJkt9p3RT9vuYgoef5V5?=
 =?us-ascii?Q?Dc9b7NIhx15lhcdrkDOzt3nh/km9xiSEowbcTCP6lPbw9YCyExTnsc85fZ3i?=
 =?us-ascii?Q?9+q8p9BEL2WlZU8LHmzBLDpY+fTVBRHg40F1EQ8hZyDLtv0TX2W9Kh0rI6oX?=
 =?us-ascii?Q?BpJQ3hYqi0ok0NzIG8lzHEcY5joh+49/KRpbiDY4eUmbfPgcV/SHXBcqLCTN?=
 =?us-ascii?Q?jo7s0IATUBvcLzDelTXgn06IaZVkbRQO7n0P2Jr9GBnXMmT+lAWcNVvsi6ZI?=
 =?us-ascii?Q?TS8eYkq86Er0wfJBv7q0aF2/MYE/onUo4vHPWErRwdZ+MNVWhL2+LkDFWW3g?=
 =?us-ascii?Q?JWC5PM7NvpSjeqBb44dRuHvWtVHh426Tr05uJqQHECoQWEOJGG2nLK6kcWuC?=
 =?us-ascii?Q?8YyYoDzrJa93IjlPXzhT5+xDaZCNGlK8bE277RLp/Lj/AQ2JPlq7xSop9Tnt?=
 =?us-ascii?Q?uh+t9BElo6NNmN5aFnIuf7SabkfS72lBNLh45+cImSGtP1falGa8s8vP7PSz?=
 =?us-ascii?Q?Xb3XXU4ohg6aFSf97tM9OleHEvKK/DekhuvCSMnm+7Qmy5yttv8HLZemz0/p?=
 =?us-ascii?Q?8waJZNthF4dCTGGoChtoN0XifrA3IGIWe7TplMseubd/7N149272cxbcu4ve?=
 =?us-ascii?Q?I6dcA7vpHjM+6lTRpeQDYSL0XrBPZcfb5NpDhZD/HgDlNpkvTz/XzBUrWc3d?=
 =?us-ascii?Q?j/aMb1bh/W4c8N8MqAJoIsVYnXr27wnCi1mfekRtoX2FFesFywaLZqHFLVlv?=
 =?us-ascii?Q?uNP5ECHESwheFxBSgUrHHPKRASeOl3wa6aP1aUbyC+UoF79F4CEUEcMzbV2T?=
 =?us-ascii?Q?JcT8PNW3EXT6VANBegKCSYsA/1U4DSYIMjjfue0xJarr80cNGc6aFwmeAcku?=
 =?us-ascii?Q?qN9OpWI8mc3fEw2n0PowGES+aVRyT+vWkCT7bONG8fJznJorWFjxSWzOE4Il?=
 =?us-ascii?Q?njmBGEYSXDaLxyj3z/FSwtVq7g2NhoIaqjYt/lpkZipKgp9VKhFC8tFgQB0g?=
 =?us-ascii?Q?8pUmKAp+maS/bYbugouKnYyVaG+rOGOZ3ue8qcwas/mva4OxNnrjQn+tflUD?=
 =?us-ascii?Q?xDmBgD7gd7riZHEQfK5dKGGOmw/Yn57ccW0irbRB+9dLlGiMJfJ+S+eXAzNV?=
 =?us-ascii?Q?GAhgT/jgRL2tUvqH0C77fAW2r4eoZTgvg0QbuvLl2dPH3kiBthBllYGgRPFa?=
 =?us-ascii?Q?VI6vMEEyVJ8arZ04PMMeup7doSoj2LKSfKkwtAUoPDOQcOOmR994VQXvB0lw?=
 =?us-ascii?Q?J38hTfz33hZ0b2rfl/6nxZUnwjJVk1NrU2KHsNzAbabNatoEdIoBp1V/72VQ?=
 =?us-ascii?Q?7m9mcBBySmwRc9vVXlmd7Gk/VIzp0EA1qy+5YyDIDoDT/EzvAOohzcdWtIw1?=
 =?us-ascii?Q?GqPabeo52DEcNsJ2q2VgsmPVnFgKrNOIwL0h03qDE4+SRAyzh/lwq/P3y2TB?=
 =?us-ascii?Q?KBhmgx6QCnpbmMX58eksJ9943T+O5DbxVBNfqjH0/nqJmhblVXdZ0kIuq0i6?=
 =?us-ascii?Q?qSSouF9l50r85Lmhxrnk5eaQnWeO4rGFDGPNFI5QYJ9OLgD547b3m3sGE3PT?=
 =?us-ascii?Q?wRrnP44tz+bH8tZdzWq8WvKItsjKToXB0NBgaqLWhBRMKD6Fsy/ZkaiDVTOL?=
 =?us-ascii?Q?BuSIXOyu2OKXSPrpnRgRfZwR1Y14RwkAihTnwdzmtWdq3nK67QA8sIvt1fmK?=
 =?us-ascii?Q?I4lDqaNR70JxgKE0bzEQTui9hsayAXptHFuFvwytX8GRw08ewb3B/fJlT2SX?=
X-MS-Exchange-AntiSpam-MessageData-1: hQYVCJOfczzIt7d/Uo4I/sp3lp0jdS+emFQ=
X-Exchange-RoutingPolicyChecked:
	1N7I5mSfXVww6luapP+/2+3Pz3BG7k+4LRUFm+5pIc2YFugMGPzy8fog0g4LVFMste/0ttVEGEeZn/DXk8p+ABt3xuSY2YOudjUNHBTubjGCytLrVzHd0ZMYEWDK/EzzD8faQKHuSH8CtR7h+NgGtpVaHxQEqFQe5d1rIhQmc5CQHIkIIIZcgK/t5BBJTbrWqRtI5/KTIDpdmcMk6Z1G+CPyiHYfpAOx0AzJX/yiXUVS3oYuCsHdslsvk05edHm6hqBGTbgQprv12uC4UStJub5bu+41m147cmuExiR7+P+gFKXqoicsGyZ6dKeQXPlZ5fy+XMk4ciBKNKhdUKWgEA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GwrPCJGWHPHuM6l7SEyhFlleTpMNVUKFb6FH/KlXQ+y1rFvS4YDTToz1FbbbxFk8fqSNihKFdWska6E4P2WbQ6q2pgH0kUMT0zkiEw2nODnY84rhMl2oFSc0qphqR5JhER0y1HrSC1FPjCiyb+b4P3HW3RXaYwAEJ+5hlJo2596ISJ8xKnzXuIkhSfe/xAjoNrAygewH6Um9P4BfE5Jl1/+QJ5Sgi8kacAkrIbD+rWOf9+RkngX3FkBSpARjs4gHa5BLCJ+IhjamJ9HP2c2s7knOkYoJAlUGBHZ8EADA+QsduIdKcfEq6c7Kenh8V5SfMWkipbTqZxrVnROZIOpg8cbxcVSmNsG4R1NcDctmODV5sMBy7eayXHu8LxEOGsATJWKtFpUkZvucmyIqrEyL2apD6jg2Ez4UvNJT/f1PM6u5NsITtawXxiWwDjSbKv2Y2B+4wUFy/oKTOJ2dF+GKpctE/64cZiq9fS96NzRSIYPpWtATVuXkdhKLBt+xfzwPYZ1OwuRxlw/HNZPHMDKX8HAbzTU85dzToJGNL270RZnNcxer/WZw2KNUA/SF5D8Qr+nvchTKMeZJcs+kFPOOw31LtawVqdEP3uXSeoob/dbs3MmI4f5qtmXMCdfUDbEN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f454f5b-247f-4b23-07ca-08df44dcf26d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:46.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhf8W8IVYcZh6tN6HrI1UfDmxr5S6iVE/gf3OUIQDmGAxQsVo8P1rLLT3ONJuOdQ2rVsiHXT6a69nJRanWj90i1mxXLlZg1Wpx7pkWXTkzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

On a zoned filesystem, space of a data block group below the allocation
pointer is used even before the extents written there are accounted as
used, and freed space only becomes usable again after GC reclaimed the
whole zone.

Don't report reserved, but not yet used data extents as available in
statfs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..02ec4ce8370e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1691,6 +1691,21 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
+{
+	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
+	u64 reserved;
+
+	ASSERT(btrfs_is_zoned(space_info->fs_info));
+	ASSERT(space_info->flags == BTRFS_BLOCK_GROUP_DATA);
+
+	spin_lock(&space_info->lock);
+	reserved = space_info->bytes_reserved;
+	spin_unlock(&space_info->lock);
+
+	return reserved * btrfs_bg_type_to_factor(profile);
+}
+
 /*
  * Calculate numbers for 'df', pessimistic in case of mixed raid profiles.
  *
@@ -1730,6 +1745,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
 
+			if (btrfs_is_zoned(fs_info)) {
+				u64 inflight = btrfs_zoned_calc_inflight(found);
+
+				total_free_data -= min(total_free_data, inflight);
+			}
+
 			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 				if (!list_empty(&found->block_groups[i]))
 					factor = btrfs_bg_type_to_factor(
-- 
2.56.1

