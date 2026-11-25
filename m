Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602655;
	b=bP9XJF4UkPukvsZn1pJlqoCQgqmERMLcfsD6FF1OmprXaavHbOX2bBPhxmUCxDRE3Fpc
	 ajxUv1MdODJfqcxiqj+FaQKRpmGB+qc2Lga47ZwCQv9pyuxkuVTJXujLEUUWWpZg/+ILR
	 8PrzSaItXX8t2sctOEQJlvhhz/JoU0HCCq2bVEsXL+Rzjn35Sc6FZ3Xe534le1UjDz5hD
	 zSlmYeMK74/wf1LdBPmxNmVoxyRsYrHms93MVmLKwcH0Ybuwj2g3KNM60Uadr2yX3+Dgh
	 Srb/3oAZwuCpZezHDUjN/uCjixwqSQov0nHBxtCm2ztdK/QxFrayWH5ZdnBmQME67AQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602655;
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
	bh=i/YGNB2OsWdMirv7ZqT/P51Lj5+gw97MhlkVxBzTlm4=;
	b=xMqQn9N3BzmeEEr7sLUXQylo2d1Z3X4rwQCD1E9tDpLuEN17rHaucxZfhw+763ixNAz2
	 3B/We0+E8BWVEb9XVhFEIjveAkOq6Sa7eFqpMVNK4CRA+M8mtwdLk27nZWd9DAHNpmEY4
	 koWy4O4aYucQ51MxxtAscUhqiyELmTrsaaIybySBe8BR68vXCY7ZGe4kstBIhjy5yf0Fk
	 AXM8D6pOGtSkvBDiQgqEIrhkKNIMKhWdmxReTumqHM8t8yVgyjEsRhdtBZoaL5VuY0tcs
	 n9s7JlBJ/1/fAYvapbOp40ODctrDnwVTf8sr9JiFQSEM6LxM9RZI47TAMKzDY12Guww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=B2wKsrP0;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=lbC6DX+5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD76606A335
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BD76606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=B2wKsrP0;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=lbC6DX+5
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602655; x=1827138655;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=hHFxsspCnfX8MwkMDEyrGuSftUZRXxHivK5Qnu8sDCo=;
  b=B2wKsrP0yhfj3bGsq1lI2KnrXEfgCCY/O5fbgfXH0ow5mFWL/6r5o5bc
   p4Akg/9BrqlxM01lP9LlInfv/b74RArRFeEiG7sksmv9g2RMunsBA3ciD
   M9RYLy4dQHXxG54fLQxFtjvGAECFmMa58zEcjVu+vTyL75gHTP/akq80e
   ion1RkLdjYcBbiQekwWwwUM086QKxIEwZFAd731UmAg9XOyiUKhBrKnmO
   FhOpOiwIMEMeBM9gY23M8u1RZYA7I9lUWgVm6tr/9+2pQHnbGhEpCooYj
   5mes1NoFFA0kijIp5WVGHlpz6WoPt6RpHX3rJ6pFTA5Myt1AC1YkdY98W
   A==;
X-CSE-ConnectionGUID: vuYfDzpyQ9qhaH32Q2fx1w==
X-CSE-MsgGUID: ZtHWacoOQ9qcEE9kb7oSjQ==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492421"
Received: from mail-westus3azon11010037.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CrbVxkjkI50bKgl39cCmrw4CZn8e0ChwDTh7VZUr9hfwTbX4T6fSi1hgxFW/JuTJnL3IbfUoFbHv7UN8/rNAVT/rnugXvQ4d6byP04+Et9bkg89EzRvBMouv2Q9xFggQMfzhu9a2W2rG+FpThbIl8h8TEtKBLCl2uKQn1RvrfG5wJkU4tULIHxW7xOoi51EJHdqf6yPocynpdEqPC7pfHvemYIpfNf7nfK/Sc4y+i24K2VX7PFHx++6CSXYCa9XJDcHcvy30j0EXsWbiVkulX7BHuIQkRaHZUajv8c5E92ykFMTpvP55KVgbdrtteHFDa51lPIkCYJGf5LS+oPkkGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/YGNB2OsWdMirv7ZqT/P51Lj5+gw97MhlkVxBzTlm4=;
 b=Zds0sYSHz1tcdUH7ZBXsqKnmekPUrQ8xc6JuxyCLb0X5IPr2qp3lZ6c0zG6VCFYPU8T7pj1tVPVchXe33Dyzwvu5bqdPMd4GnwEKISHMHjLU9U1U81VMmQLeX9I4n4kRlBcgi23A3oMdH07Q2dk/oDFPejHoHPXzZ+atrnc2YrJYOPE4IGGBZV+zMZaQwM6soj/97fJsdfNlcNgqG8ulXKNvH/xWwr1ylaNInTcvQ2hUPj3QF7Rw/+IPH7Byv5H5tak6+ho9noe2PVInTCeSVDKq9IOGA3QGD04GnsPIBEjvbKcsYavO7ztsjWNeTNtuQE6vYLIMXrOYCa4Tg+HY2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/YGNB2OsWdMirv7ZqT/P51Lj5+gw97MhlkVxBzTlm4=;
 b=lbC6DX+56WgahEnUxIHNCvyXwG6dZVM6BVPRDRTuIzcM2ZAgup5GVh3Iq+8Tk6Seer/rmzcllSxE/tQhYI0H/bVcKl2nEoY/gYIPVvvC227t59DCEbwg4OBLXvcG+eTn4kphjTnFLwvjYmrlgbTDaB4hzAvg/wc0Kfm6u+pU5uQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:53 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 17/27] btrfs: zoned: don't recheck the reclaim threshold of full zoned block-groups
Date: Wed, 25 Nov 2026 11:29:46 +0100
Message-ID: <20261125102956.266389-18-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: bdbf4396-fa1e-4c54-cf59-08df4adf2e89
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|5023799004|11063799006|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	A6WFL4kG5M6iOx7dPzrt5gojt5MfoS3gTUAddG8InUKnGY4rPhNTcnTmdX/RV4CEzfHreZA7fYqBpf0oK0MNSlmYaVJCAABG8J49f/p9gB3KXiIFsiGqFbB3trbj4QDDQAsuzhrceFZXHvfCS+h+Hgh3kbWMrOKq+1WLmCvzQ/dj+j4EDWhbbSr1nOZlPm2P5l9URBtTjZlIMo08ddU6DS7aM/V4wXn6W0UVpeCL9Wv2VO/pwx2ACJ0ODJa8TKueMWLh99hbEY8nc+dT8+aieY1YnCc/Tn9TX2gHfUUwt0Nf/i2zsQFYmSWvxcfMvs3uW9iFec9PXfcJBmKdjXKSg2YIBl/egTRnEnUyN+ZRiv85kvmtVf4x2F/IcnPFfgvXT/VLuA98N+ccpkBu4CzEkZ1qicb9cbvwA0mH+5PYswVXiLa6NDplWj5QbYE+BCbkGmZoVEOLSWbpRueQT0z46MqhJbn53WPHO8A/jzM2J3unCepdBpNwUWCMa40ZqEqRi260Lonb/Ek6BBU573Zc34fU24eBYpwbxVxehxKA9C8upCZoVD8ztVpmf4dxoHYGWff/Nuew0Lo+Z4pILXGAyVvD+tb2f9IYxCbdXyATkTPpoQGBgzFLGOw6BoeUN9M6ybDq9J3FFha7C7bE5pUAPciOyjeb3uN1lSO2CWBnYno=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(5023799004)(11063799006)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R2bxOEFcQz5PSHo3DecloydH3CHhrkzl2Sip53UhGEAwAuW2GDY+brpdY3UI?=
 =?us-ascii?Q?Oe+YNEx0W/tWv9HTbBfNKTcVc93MkFryofeAU3aNofsHfuAVCedoNBPw9bTk?=
 =?us-ascii?Q?TtbtdTxPI2l+JSNYdIGwLntmxHCSA2RP0Bk9LgXWNi+PNPxxIfSl51kJWPrx?=
 =?us-ascii?Q?OUwQudD8L5CsuYwLW7lM629Wy2tzzJlGd1rfN3Fgrm3eD6t9VNsBZUAuA6rp?=
 =?us-ascii?Q?/WcPiUA+OxePdXlaxJaEl2RVfo+YswUCzEgYJANJP4oDqjWcJFTeX/OJ703c?=
 =?us-ascii?Q?hf2cjXCCTEcrh0Vno9zhgTBJwXNXU2kR3uFWGRrYUYVARchN0et4oKrZ+0Hg?=
 =?us-ascii?Q?Cul5YQVW3XIKtztEYSytw59dJ9zQRItlK4t2qIKIoYzZG7qzyydi5/UmHRmT?=
 =?us-ascii?Q?4UJDp2PMSjvtZJSZ4OzezPaUNpAok2J8jNta439+5/Xwws3OadJIz5pwf9Kc?=
 =?us-ascii?Q?bJLEezjUlRij4lWH86aNId337u9mJbHzb2HMfhSgtP4Ouzv1z9Oh2n2ci0jG?=
 =?us-ascii?Q?cAMsPhzdtuu1Mjq40AlX6AY7BEEdcMTakN0pg3hqIt9vda21wqcqVildyjrm?=
 =?us-ascii?Q?Pi2O5T+UM2dosw+9UqHHv1AjmW77ifhzWEZcaNYUDbxLtQv5R2Rb5TFhq/OY?=
 =?us-ascii?Q?eB/xBGt7qCPr3C2Jm3uU8PEPb9W9VnWGAG3YTrX5ma5qSzEnXr+ldF5lvjcT?=
 =?us-ascii?Q?5sYTzP65MxsqT6dr98qAVktZxKgcF19mD3e3IYZidouNHSUEIf6NV8Cm8+Ws?=
 =?us-ascii?Q?rLx7afZJwF790Ir9OTKOgx2Ohr68UmIXmX5E7O1vnd6CkuyP87p2o8JBV3op?=
 =?us-ascii?Q?t6JXO/dsotmoj5CGANkmUcGF3KvqHJ84dUpe9SMgoZ/bpdKpZ6lsjs4xGtqW?=
 =?us-ascii?Q?SnJ9KazyBmIT+4XJKeOcZQSwFaoJd6rR4g3dzVRRWUZreVx4NQ4Aa7qkVkHr?=
 =?us-ascii?Q?oeMxXpWi4lF63Q29IGGpOSykMgSiO4s9VmCJBBr9CQlGTxn7zvfoCeiILBJw?=
 =?us-ascii?Q?uz6cPf6Znxud5IzXEGOWknNvXjM78l+5scuf43p7zqaOf8OF/6jZOOb+o4rd?=
 =?us-ascii?Q?NtiX5m4d8iM4mHAXvpuiP/XWpObBRuRu8Dk63OESmMSCyyxdeGn1PUUiYN1N?=
 =?us-ascii?Q?PqraN6OQgnuqT6zQ6UBBluuwf055uyrtmpxs2MS4SFOsrxwr7h8oA0A7a2qY?=
 =?us-ascii?Q?VZJjetd+Y1ve+fCJPPGuF1ScGdhEHaUU/rKvgl3FKcOpNbE4FBtyGhhrZZ3J?=
 =?us-ascii?Q?937Fw7w/Xz+bspwLE35KhXqFoi3Wg9VB8a3K/Ufab9PC220rIS8VWc3XT6oK?=
 =?us-ascii?Q?dZLigLFDwIU7J6wot/F/P3YAStINQMAMTFxQcCS9u75rUC3XfJ4RRWgb6XmT?=
 =?us-ascii?Q?Yz7whsBa5NazLY+KBaK3fMnLtdtCtNRMT5/zLRwkPwXpJE7kBmxc8iNOPC1H?=
 =?us-ascii?Q?+E7NWdWxjOVsUNQRQ7b5sgPEfoDYEfCq8hofUaZROP/q/pxCRUwrWymqebwF?=
 =?us-ascii?Q?CShgD6jPQec5jCfW4gASWXj+DRA4O6UzkPjjORSN9/KXOcqilEXjTdLytbav?=
 =?us-ascii?Q?iXKokPHQgp4M231D1PJTo0ZfxsNFLwCYxh/SgIFjuVcZIqfjgX33f6R7sa/n?=
 =?us-ascii?Q?wmtbFMnLgo5EUz4xmdeOk3gbSdKqUUyT5LkoIBL8/0k/aP0FIPd+H8JoEmCl?=
 =?us-ascii?Q?ozozP032iVuwQ/imiyAT+ngUZRM0HT/Jj7TBHy/hssEMD4D65ATjEno2fCXz?=
 =?us-ascii?Q?K+7am/943OrQ0mA5mqx4lVWnIOF6xAYhm72Ds17o60Fa6w+6SpQKA1ClQHgR?=
X-MS-Exchange-AntiSpam-MessageData-1: /4Hkty8d7NMwqhBl7rtK6OW6ZC+ldB3L9e4=
X-Exchange-RoutingPolicyChecked:
	k6MW+V32MWTTtZy38Qwz8D/0lnSr8kSBQliQVfzXJs8QBMs3ifUZMFPuGYtiuNT7jPUF98FS8FASA8fuARZQnu2WTSR9Rt+yVXazQpqwTTxu8ufUt93IV1nsawvzwEBdeZfiewHbQ938lhFp5AwTDt6F3l/vCT0sYJWe0D6pp9R8IQX9uzKRRccZfeFIXPOWUcbu8gC2XL7FPnwCI8zc7eUaclt5nmz/QrIx7DyeZca00sApYzyCqIhboS+QGX5vIeRUZvreKxJvL1jpafCgHoggXUPekRg5H/IySncC5Nz8eXtU8A/fEaWZbiWh1h2ZMX+Vel66SctREKTuDhnc/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uurrq7y5/LfgtLrfft0IZ1isWVysLe4BkGFu3vAgzGfZqOe33YbP5Nqumud01dCjvl5DT9pQmwoK/zIIjmVi8x6FWAtAvyCjOXeE6eF1h/jxW21NjmcgO4S1M7vuSdJxi9mtlToKw8hflDS+CeH/w0g0nUSi6gIzENl3UBFq0Jy9MEbmnGuctJVPiSc0hFbDmRtH3OF7Xe1JD7y8Tw/vgYHA6KUxgfyE9zr+qBj3wvNFyEFvBPSRfOwQavObsJUnWY+GdvatRit1xNulp1olbKOY6GNQJ4zB0RBnu627SfEw9cvVuv9Y+UC/oW5frQtbhIICo0msO3QcyfwhgwaYWlN3QaIgKOTWX9gEAR0cMscQQPtrDhXew2I6Uu01J7x1vE+gJ5vzHRF7mg5tkq2nXJ9JpDdXXAkJSrE9uI8YSDaiAsBIOU0yUhtbO/uDxc30LJG5XaXkDErVAihT85nfer08a5fRJG1jsyZZDddbNhtAhmtxdiZUr2yNIFrFO3O1BV988KtfM6hLdy23QFlE5QEYTBfrNOE3gMGWTvz6NQJKXB/Tt9oor68lnY+fpw2HHZ6AjF6rNVJR/NECC4Z+dEZaVHbMRnDZatni+G+n+HhrclxN9SErB+v0/9BUkZi/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbf4396-fa1e-4c54-cf59-08df4adf2e89
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:53.1627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V69lVYRiBseMyCACZTkwTaULaXfuN3mCaaAtZWXnEWibKbQ9SgjX8H1Hl47LcHm4fvb5T3cvF07zGLup8TZWVJS+qq0T+ja3WaReif2C/L8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

On a zoned filesystem, nothing can be allocated from a full append only
block group anymore, so its usage can only go down. There is no need to
re-check if such a block group still qualifies for being reclaimed, once
it is on the list it needs to be reclaimed.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index b7b1fabeb081..dc6842438de0 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2010,8 +2010,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	 * being freed, pass in a fake giant value to skip that extra
 	 * check, which is more meaningful when adding to the list in
 	 * the first place.
+	 *
+	 * On zoned, the usage of a full append only block group can only go
+	 * down, so it still qualifies.
 	 */
-	if (!should_reclaim_block_group(bg, bg->length)) {
+	if (!(btrfs_zoned_bg_is_append_only(bg) &&
+	      btrfs_zoned_bg_is_full(bg)) &&
+	    !should_reclaim_block_group(bg, bg->length)) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		up_write(&space_info->groups_sem);
-- 
2.56.1

