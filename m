Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794942001;
	b=WXELMklikWPa5StNm6en5Uw3UvnqsyYOKDzXiYM00g123/lHrVkqB6uKssaDfbP7gKeO
	 dWPport20zm5/DyMl7Pqbbodni214ZmtjMbmDYE95NfV8nrA3gnvCOwwueBIeWHXk8VrT
	 6JMctGvjGfef4B86B3IFog/MDmy96J6Pf31lzjW0G1/u+Gg7tiCAxierxs625QTVapaKV
	 7fJppKPhIRjDjIjfNT/TztJNT/CZ+mgNJq7t6LuPDgXiEYVCA5Nt8d8jU5MzHykd+wgfu
	 Lw9G0lWuI6n7J6XPH+V1fdn29gklj7DUWCwapZYNH42bWfqhzenUr8TACy5j1GEIC7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942001;
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
	bh=YW3ZOMstSc8+s5Ddhdd7I4FYHgZF+Z/pQ8v3C1tJ5zo=;
	b=2r3LFd0JwDr9cDQEQSeJ1uYH9UlG0OMV3+OY/SMix8q3uL70GFNywyxR5PsevQaFBxbp
	 Eq1mptRb+Emdb8KRzWILBHtbrh4wCNs860HMnrNL62ROD4n3ca7MoC9gj8UcC2lKoOfG3
	 9wZgS6W14cnjcp+9BdVpxhMeI6PqtS0e3hcF5pnG8gLzrd+oarOQwsXObssZimxoM4YGF
	 OGEQmPWwWgNckFDwmU4sGA6jS13dWmGbCDVHwJ60K6ftYk2zmwe7LwUvdSjQpPO0Ow5/I
	 pntH+ld92CYxaZDwcurUI/6nTFvk/D7qGqWA8yFTJHx8dTcLsEuEGxyL55XOgVQeQxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="c/BmD+04";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GZT2pujS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318D9606A331
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 19:00:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 318D9606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=c/BmD+04;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GZT2pujS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942001; x=1826478001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=I+LFoIKJiBDYf5EdJ1fsLzvjj4drFvJJKbvWu9RKYCE=;
  b=c/BmD+04vUZb0yG7FsQnAwk9HHBCWJciIPkwUi3HbVKnvrykHJfDS0iN
   bQbxvf8TX02XM97FC2D02k8b0sdgPTYi5cXEiiZKFr7XnMt/TUPjZd6lC
   ivGmNmCYgNDGgUxvAHlEyW1JXA3ZHaZIlE2F55+61u+wsiBaj3rHAQ67S
   MQeqNymAigXzcqcyus1368TI7QMOosxi4eqIywwC2rRqZTg+uLIVqpjMP
   KhMNykzXeOXE4XTO6hjAJxGLCfv1YSs81J3X6+6a6/FOv5ZKrebQamDlr
   DZmNwsMevKcdlJSfYl3M6M1D1L/hrtHDDKXttRk62E4tWMUXhPZpRAQxU
   w==;
X-CSE-ConnectionGUID: RhMNlmE7SZ64pK1jnT1zGw==
X-CSE-MsgGUID: TdFdziHARTmxUMOXi0arzA==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161122891"
Received: from mail-northcentralusazon11013038.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.38])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IqFVzSUMEEZFvwlqz4raaAG8CljmjNK9QK9oiBt9t2dJsy3/s2JfA0Dvw68YgKIG4ssskDtPEwPU+L0ua5ooS4izx0JrrYslm/p+bsbuwgimtutjT9Oy5896vGP3KA7obdbpTHjSGYU0BmP9o6XJDS0uUgAv/2wGZ0q+rOnh/smE+BEi7VD1twmWW6scZjF5GpUxHxXn34jz00ZZahY3ZVuqnHInYDkEj+Odtp2MUSKESkPmJJegOtH8K50D9HqkBK3YhhjZqX9hNMi3dZh+gQOSIhwXIKB2TL8/YKgToOkDAdVVBRZWEupiSwLv6Z2FZnNVUlgbtfOQthas+Bse2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YW3ZOMstSc8+s5Ddhdd7I4FYHgZF+Z/pQ8v3C1tJ5zo=;
 b=Z8pbks+BfYRyfLamqy1VyN+8wQlCtgKTkoBOiLANvpMS+nrKOjjWBXAgpRSNSkp8X36mRhyjvu/9OgvbPGl9NNNdRDc+snrlPDzLfwp/op+/qHt7A2qmgaA39xzOHyPiveCgzN3VSc+/Cbp4sFkV/k9kMtqdimAL/cBgPw8ruNzfU3XrhoW8QT56uBc5jBPmpd6Jx9LyvB4P8OmJw/KcKxiHiaM0hJqNyrcJZIbn4CfS1E1QS8Ja93gL932J+045qcI7Qkwtstxrhy8A6V7cf6e20wiKhEkU9IL4ldOjHpmOYSfbLvNjuIqk8Y5dx37zpHLuT0/DSMxo/cEGkFqJxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YW3ZOMstSc8+s5Ddhdd7I4FYHgZF+Z/pQ8v3C1tJ5zo=;
 b=GZT2pujSrxQzEeewg9oBd/eC52eFV0LCt4P1IlZDU/EDpfgOOuEgr/yE2ImkGZi1HgFNITPb2e88aAQHR7Ep9X0H/tu79qkhg3iRLqBOCjomLbCziKBpIKp0MzIVDe3uZB85agcxbxrthJ/Ja32139WOE40KRUNn+y34jRk5fxI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:56 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 20/27] btrfs: zoned: prepare reserving the data relocation block group at runtime
Date: Tue, 17 Nov 2026 19:58:43 +0100
Message-ID: <20261117185850.4128157-21-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9b6ef147-4c93-4a16-d563-08df44dcf816
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|5023799004|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	AZ2XXCZY6MzLEGP4GBxgSbvtfCKlo3hTJWNqrb1bqtIEQfRnV/vNtZtl8TyJ0LGzh0txTH6E0RAVr/VxkQQK74wc98iI59NpQishvYrwvKBphPT42xIYA/TexJEBWiUTkM+QWZNWVsvA9Zjrqm029zW3o3hf5yUfJtKVBXz67QAeFR/evX0Jp7Q+S4p7rs9zvMdu/MYVuZxlT7dZZZfVmvU7nSwWGIBuYWlDDyA5qj1R/KqmICDWvn1xYPwcmzHmeC4PMvLwjXnMU8rdlL2WBLQwETTPUy9fgjysFkW01fQQtqXxepZU5qI/V5F5t1SBOrlbP2seMwB1Vk/Au8vSrjCLzIsBADu6X5TmUZv2xnu2/BY1fwvuJvIczgnza6W0m2YWJR+YN1J9dcgKt3/bP6mKJut0rzLR8b3dqtjRtrKFDZUOsSNfHHbbWCUvGtJpKQKdIhfvBEN3nhCn4cDGC6ujyHpqxEYPgpTlYx4EUTd9hfLR+OjZdhMuVWA8lBwhQupLc0XRupZ/jXZv4V4MvUPd8JtRjeI9C4CLSv7mCrRjVY7UWWpUZrUFVHPNfSUsC6NBugFdsdttAJwoGl2XqI1q284UOeGZDDoCxooGL6b4Og4WGDKa6N0JP0SkQygaWQK7HZQe6rtXMDTSnmL9hxp/64MA5RsdDJXRjZD23ns=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(5023799004)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yvsuMdwj+2+QAcQzx0tDMO15gFtDhuE8BeZbynZSE5oLmOv0obtsy2jny+lF?=
 =?us-ascii?Q?Sofh0XKjRM9dD90l86fGmxQkFHcwsLEeNwTiO31uhnumfHJTKSJl+zeV3z/y?=
 =?us-ascii?Q?5kqKDm99QVrnvcEfIVpQWv8jUVksCTBLss2EeBtV3JBy7S/ZmuCGR3mY21Tg?=
 =?us-ascii?Q?ahLXwKITKLBpZA+4CXPFOE95HK2zDV4M1jimYh3Ki/ifeIl+2ggkLdU3oWBQ?=
 =?us-ascii?Q?reIgxLenzSm7Bdl7IPRPUaqo9D3b3K4/+JjEVhlStW6g6TUno8wCoxRjL5YK?=
 =?us-ascii?Q?rTXxPGvNzdTHICVTfGCzsnHDuIJBlbnibDO+p5yX7R6I9FY/hJpkQtUg2kg1?=
 =?us-ascii?Q?ec23NekNtiFot0Len5CaY5kIIexiw9NiSvpq1huQh6awwDqFyVtreV8O48dk?=
 =?us-ascii?Q?87OKet869xxGU4K5XADa0+Bg3FVH9wvo2HBBBpEWR3OZlgtK1m2wDYDvC75X?=
 =?us-ascii?Q?VR1SPWKTU8tKeM5B6EqXql7eOom3pTaebY7D1JvcHbbMS4f2F8YX/eWluUT4?=
 =?us-ascii?Q?qVlqtwzbSDIkYP/mYCNWm/MyYdTJ3k+lDX2gGFFSqwzyEA2LK8JyQXd6vYoY?=
 =?us-ascii?Q?eZYbyfrfmBWXYLZZftnA4KXZMwuyoEuHMdcRf41uNrV1udAZANjPXmaiFGM3?=
 =?us-ascii?Q?TAZcUvvBO/SqydszfoIU+no/TegRwmX/Bv/w5PaYOszr2mOcg2xqNfTBsY9K?=
 =?us-ascii?Q?pR8Rcd9xL82UCcAIOK8fUf4qQQcl0O3kKb7ilqWEATtmhdXGMdFOBNAoj84c?=
 =?us-ascii?Q?HNjUJXvk5qNUeVnL8mp24+bwv5Ljt9sma+zNPS9b1jqJ0h+4H6g4TiMxHFps?=
 =?us-ascii?Q?LwUoUEdHdI65D1a9ZQJNjdcQyTEg7ILqduE53cHDhqepzlIQA1+r3bDDT/Ra?=
 =?us-ascii?Q?eHZUmEKE6j72+pok8C5g8MPbHdudXRTKAZUIkCKorrdkxP8OXJisvyhCwxt9?=
 =?us-ascii?Q?DBAlOwUKVfhCOuG5I0QGHMUjy+uBi47ouEfStmHkirzBAFbvWe9uYfLzWrLO?=
 =?us-ascii?Q?DBEuQLcMpCtIvrZjYefpH5cVWvordIx+oQDKMDatIBqHXPrrND7HvLg49il/?=
 =?us-ascii?Q?92wwoFyzBOZA0XN7NNT+O/uALmL5Jp5ssJPurMFH8PBHJanaJbnPBz2Kc7vQ?=
 =?us-ascii?Q?zxhw5wquzh1818vKvOCuYEsZzpaOTjyOCpUWkKOgz8J/XYHY9TSq3wXPXu3l?=
 =?us-ascii?Q?faiRjphqtjLv5vNQbFQQzdshJyiiWnXHLN8714MiOh0XHDDnLYtClE8P1BoY?=
 =?us-ascii?Q?5WGeek0MeQM6lTM41wrozRgWG3mCv+04+jIWNHpy3lcP/XlrZLO6MymritVa?=
 =?us-ascii?Q?RxFoHaKJNt2pXAYRfIYsy40ICbvHO2ewhtABVhh8ERY6NtFswTe9waraVOxj?=
 =?us-ascii?Q?WOIhw5RQBqgp0+Zhjw6nnAXMqIIObYbuaMx8+N4pJOvHiyeuFXVb/R4J5Sh4?=
 =?us-ascii?Q?4Ybb7mykh5npdupLaNxkP1ezEwnshRuPDPspt9UkANpM2OzbwEh8KegTN+79?=
 =?us-ascii?Q?tO+MICpcfWnK7uQ/91CQzERd+v6Uf/SUnQNqVXoeF/7wf9gvs/+X4sDd9EFF?=
 =?us-ascii?Q?A6BKexc2DBb/YalhzFYbSmU++G0ZJJvMpeNXgoed4UN8KCnrSO138VdoGKj+?=
 =?us-ascii?Q?d8TUGNJARe3HlqtPgZCNxR8cevW+I8iukOB0p7S8DM5wpTkgkrBMnZYW3Nxj?=
 =?us-ascii?Q?hBDizwSBLcH0aAXe5T2oOr2tmv25sGVbAts+dBXpDiHYaESAWh91S4ndNotV?=
 =?us-ascii?Q?y/+wArdTmnGV/WDAnxdY6vyV+tKU2pfXxMt6hRNHQE0FtXW43VdLtPBjWzGu?=
X-MS-Exchange-AntiSpam-MessageData-1: KP2LQQpIqcYjtZSTlzOgxKsvTp/3I0LTBiQ=
X-Exchange-RoutingPolicyChecked:
	qZBlz3mwjZp48mJx+NORMlp1JvtVNrMp1tmSXTmSdOcosFh0WX4Wzg7UR8p997ZKmLpiv3bAjTweH5CLAa+M+h/HCJvO7JncaSEijR9Lavll/0wdA1kBhWkTWWd/DT0AzuMKi7ptwyrkNhCbYLl14AkRuwSqnwr7ePtIxSeXvyd7bG0Un5cJlMuYEl58Ivv99UhaiR5pzzjJSqUs4pEwlnnafckRmjsN6FGKvAlIduWrmIjxrI6eX3H+eAIkKVHa39trgKz2VzyCIFoTHq5HfCH32kRx/x3VUW5/KYLKcpXpgMztKtfMKXzJvu8W/sGuIt/7ETvqR3lmflE1NlAhuA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ik+Up3FWA/XS/ApExuY6Vyz6tZYUIjMKNKUPLFuu6/rcQf+P91gEi+xmvF7Xr0qy9mfCzqBHDpLdajKpBDc+ZYfuGk5eJ0zKaw6YIuFcEJjmZ37d6gl2vS1ODJO5rT51n0px6dnY1rS52mJZYk0CU2APymzRIonjbDfrxbFK2OYK0rMiQcNtfKTnItvwRmbfFH7PBP6e01TTq1SQLHAgrPr6vH/oINAVCutaayKh6pNzcxkGvfVTV7cg7/7zUzNMQzQfNnfoje95ufd3skZc+afeX6ZjSKvNuxjd6UXlR3otmcmH1qkxFy4MwahZXIs2gt2GUL4YXeRRZqRFk5AXa8+BLcqtolB1E6I/PaRcLSmJ1GK/Y5Tn3qeJyDCtnCuoFly4iK8LIWzCnYEi9NiTJcBJUqbS+PFjxISyQ4wt2Gu5w5gQ7MXYZxXMxQVkBUQ/te/4L6hwziJEW/i/6+7p1SE5dotaNYGmVA+y57CPTUOUAxgQwYBh2TfiRt02+y47TrYbxUmcySfXIw3lY6pbO4K/tbOiypyPXmLw6iUMpdfUKVd16Mhu3ryPDIGFVlsU+6EKfnAYh62/djlb7EOF75IKeIqWMuPFD+ZkcacKRnoStxkITE47PVB/imN/377H
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b6ef147-4c93-4a16-d563-08df44dcf816
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:55.7974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+vvpE0EwfvR+YMKjl3rn/K3YclCr2cNdSMcgGJRkVmp/S9MO6bj7fyLDZFPZjPfzvSroS+J/FJTBiKPFuKI2q35nokZjPlFLH4e6B0SeMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

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
 fs/btrfs/extent-tree.c |  12 ++-
 fs/btrfs/zoned.c       | 201 ++++++++++++++++++++++++++++++++---------
 4 files changed, 180 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 6697eaf995cf..88ed3609fe50 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3245,6 +3245,17 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
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
index b01b3ccc944a..7ae03168ed91 100644
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
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8532ef57db48..5840c97aa9a3 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2972,6 +2972,131 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
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
+	}
+
+	spin_lock(&fs_info->relocation_bg_lock);
+	if (fs_info->data_reloc_bg) {
+		spin_unlock(&fs_info->relocation_bg_lock);
+
+		if (migrate) {
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
+	if (migrate)
+		zoned_dec_bg_ro(bg);
+
+	btrfs_zone_activate(bg);
+
+	return true;
+}
+
 static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -3004,7 +3129,7 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 	spin_lock(&space_info->lock);
 	spin_lock(&bg->lock);
 	ASSERT(!btrfs_is_block_group_used(bg));
-	if (bg->ro) {
+	if (bg->ro || bg->space_info != space_info) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		return 0;
@@ -3043,7 +3168,7 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
 	struct btrfs_space_info *space_info = data_sinfo;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_block_group *bg;
+	struct btrfs_block_group *bg, *tmp;
 	struct list_head *bg_list;
 	u64 alloc_flags;
 	bool did_chunk_alloc = false;
@@ -3053,9 +3178,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	if (fs_info->data_reloc_bg)
-		return;
-
 	if (sb_rdonly(fs_info->sb))
 		return;
 
@@ -3063,46 +3185,43 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	index = btrfs_bg_flags_to_raid_index(alloc_flags);
 
 again:
-	bg_list = &space_info->block_groups[index];
-	list_for_each_entry(bg, bg_list, list) {
+	/*
+	 * It's OK to check without taking fs_info::relocation_bg_lock here, it
+	 * is only to bail out if we have a relocation block-group.
+	 */
+	if (data_race(fs_info->data_reloc_bg))
+		return;
 
-		if (bg->alloc_offset != 0)
+	/*
+	 * Find a completely empty block group. Unlike at mount time, this can
+	 * now run concurrently with allocations, so iterate under groups_sem
+	 * and pin a candidate with a reference before dropping the lock and
+	 * operating on it.
+	 */
+	bg = NULL;
+	bg_list = &space_info->block_groups[index];
+	down_read(&space_info->groups_sem);
+	list_for_each_entry(tmp, bg_list, list) {
+		bool usable;
+
+		spin_lock(&tmp->lock);
+		usable = (tmp->alloc_offset == 0 && tmp->used == 0 &&
+			  tmp->reserved == 0 && !tmp->ro);
+		spin_unlock(&tmp->lock);
+		if (!usable)
 			continue;
+		bg = tmp;
+		btrfs_get_block_group(bg);
+		break;
+	}
+	up_read(&space_info->groups_sem);
 
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
-
-			btrfs_add_bg_to_space_info(bg);
-		}
-
-		fs_info->data_reloc_bg = bg->start;
-		set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
-		btrfs_zone_activate(bg);
+	if (bg) {
+		bool set = btrfs_set_data_reloc_bg(fs_info, bg);
 
+		btrfs_put_block_group(bg);
+		if (!set)
+			goto again;
 		return;
 	}
 
-- 
2.56.1

