Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031009;
	b=c3yuzalhTdJmaLLDK4gIVgGsrbYrTWQm4tCzgbbStDE1gEDMDNqGdnsOYjU742EErN5C
	 TJQ+/k1KqGNY9scD6NfCTFwZ9EXoByjvWOhZ1r+WxKY/yjHUcNplzH2aFVa5MCTH5mgPx
	 LMo4CKLzm68kx8xWN410o+78LUMBgBQG7HKaXUlhrLfy6QItVAz47vruYUIvgklEaPGsT
	 FsvCNqV9ce7CW5B2H6/cNtZGwl826oGhWrlKWPTcMoNvK5JIzl3RkOkT6n3MUysaMcJPs
	 otF7ZDcS7zCwxfxyF/XvxrQna01GTblxvW6HYCpB4FKSiW1w7dywnrSUzBBi8EwDeEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031009;
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
	bh=367byuETlFFNB+L5OmtsvUYLDKbrnDB21f065dlIorY=;
	b=YWVd1qqVAy2PaFwvysOJf9QLkj8QYxVTWpdpF81TFtifmHOtSMrO/klU+dB6xmndbh7w
	 fUZ8z7tfsZVVzei9PUZrc9vbz2gqbzs6Bo4mojswieKdHdgSNaj4E3RPnIhQe7iPPJP3t
	 N7K+cvC0R76nlEvzvJuyTdqC01F0YCWzI+92zeiu2ixhub7NmYnX73psLGrEOUmRgzP93
	 DfNIRPGjguHtYqyhrA+KRVI9TqPxnzqKuVicv5KW+IJTA48MLQrC0ADpRVpbDWdinSIa1
	 HnKs8/LotDCxk9uGPQ37/wdu6rtVfH42NPcHFR8qFnKOoN+GFx3Ha2RcpzHFoKIyEZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=O34i3sQQ;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FigFOPnW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71164606A325
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71164606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=O34i3sQQ;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FigFOPnW
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031009; x=1824567009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nasMsbEFp2DOe3zeHH83zzNDLTjBw5NRy6Na53cueFM=;
  b=O34i3sQQ8iOzcxPf4Bkr4omMszNX6vuWvvq9VOEPFtLP4TAqLRbpHMoa
   8en0IoAL9dEQ4itwQSHz7ktDi6or1ur/jupYEJCCev4kbrq9xavReu3xS
   P0vqDjfobZYp9P6L5ixeodZyhaHoDIStCgjH7bpw8gmGeuwDUQR4kycj/
   Ybb/MB2vk4dnpreiLZjariNWRRFfarMKTDLCzKRsMBoU6fgr0aefluZg+
   Y4M/u9nVeKwIJwB4y8cEcQjgOEn8uWzripT9SlTzlsFnCWn+ixIclipj6
   +YRqXE2r0/73OczKOA0yZ2ddk0fhpWtHwk9FrMalLcrMdI/Nyu4VV/9Kg
   Q==;
X-CSE-ConnectionGUID: YCAvOj7tTl6+E/24HbpZLg==
X-CSE-MsgGUID: 5XgeamXlQPyWZvT3vSrtFQ==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033909"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=idcQoPyRKPhi+Y1iAPYpklyDIwtwQfnaXuNd2tIkDCz2xmu6trT3ckSJx8CdNF1dG056/d8qZm5XTRwF9tHo3EDS33eMeWJ7eoy50X9wFrsKF00whRg1qkzDO3rcArUKj7YqD879gWpXQqSZvaFtPAVSi1lDXwcqnV6yotQr3E2HYjh5XrUVxVmHcWppjeO3URNG3QKdZo36VoQzRPVJRPeyUyczDN20MYz6kXuHzAXJv7Jc4WjwLj/xhe5EKbo/rf8bLHliyxUj4Mfd3bXQhn9oMCs0FXUskmbOwHD+RulZ7XWllA1TRooNdNWxRwEeC8l0ecyeQaMkyxYl8Zi+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=367byuETlFFNB+L5OmtsvUYLDKbrnDB21f065dlIorY=;
 b=liRTIQoDbMCFMAWSLM8ZE/56mPsJ/xNpehVUPXEY1o6kSM6hX36J8vucAU6LzELjChBmLSMpqv33LWc4IV+Davb3YblprOjpTSd2LlkhkuuF9PhSUnljZMRzjzWApmmNEL6j+syEtc6IJqrqlLmBeFqZHHoXJFti6gs8frEqp0Vaay0X1JVPBXdyZIjb2LntMBJ3HTQpnJFm6YU3I5AiTRlIUBgsVTvKHzMkHxyLUnh9dOnDrVGevU+p7Te18zRLoJgeaKWDIvYAB1i5W2VMEvvYwbQVZH6g9HhEtFA1+PHX69qjk43BRXMcn9FfSho6TSu2MISmy0b//zR4iI6gkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=367byuETlFFNB+L5OmtsvUYLDKbrnDB21f065dlIorY=;
 b=FigFOPnWWH83rY/Xw2GZR5hxsql+Fr6Ey3PIvYHUYe0T+UgQH9uYGwrqYoDAO/jodmdjlBE104AtxS+JbvgdtVUtZMw2wq2ADSUaW5n7qCDE+r+d0rfNzJ/e121kNdE1lHS6iUfmb8GlphVIzciYb7JpszfqDahoQaz5c5qD1GY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:52 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 17/25] btrfs: zoned: factor out resetting a block group in place
Date: Mon, 26 Oct 2026 17:09:05 +0100
Message-ID: <20261026160913.207909-18-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 73972aa6-9673-4b2b-7e04-08df337b9138
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cARc3H50stAWOuUPzVSEuS9iw7sH0NTPAJdfHoibeuADBR8WZ4+7n0Foc0SH8yNaAQVKAadT6MwCVeYmvTNvzEzW4rRE7HM6a4tZDSoEpMzuE2polkdzhQ+u64c3kKeuGcZl80vHJTVsxuJmj6CnYgqibLH5SXSPUTlZqTes8s/sb7qUNRf4NbDYOKzTPoJ1hgpQbC9XCNWSvVFMiwYfgbL94sojOHnTgHoExtYf0kFiedCg/WY6Zd3aGYVSGbR0X+vxu6wc4PsVwR+FOq03E1/f7USud/j6aSlhp8iG8VYQxsljU4CSFdZdL6nZJsc4iO61MtCLOCJF8luBNHUpNLUD5dieG1r5kjCqOLjuHu5/phTTwLFAUilO0F8C3PfpONU5wmma4AslPFMG//2x28SYz6GS365UJgRAoBStKowCyuFcVMDZ//TkKsxDPMK3uj1ZgW/keSz2I6oLbVOE+lngOv9vzEsTAgKBs1t0X5teHg3HEgaIB0PfwFA13cbC8mLnDl5qFqbAVaQhH31atsQlApkLXJgsrYTs+bP3lLSmuZJW1FwVbia/TisP1LwTVMMSj+gDq+2zgkILmi3voL0UixKgLAnKBDU3gn+v5CutbkZe5uqsKeUjz69nfIh3cwJkdb57SeCr+QP8T43RjFcA+ieiy/czqDWhB8tPyx4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GMd6+XowEsNfVaH6jgmk8Qi188cIHMvLt9KyMxLACtWiAbbmONT3laNik8Q/?=
 =?us-ascii?Q?Grlva1nz+fjPocTZ01FEgdJpkqpVGmr2g9fHJPNq/VShUYbFdqZNGJ/lmbD4?=
 =?us-ascii?Q?BpZfaWiMtjpc9JE04FLVSwKnUNvqj/ZDn95Jj+SEtgY/n+qxjMWRTI1uVZkg?=
 =?us-ascii?Q?xmCDfM/jLiN//OJUqLaRPR6ZIRYKsmLXvnVzAYUSjlPXcwC6BeQ2lfhYN2qX?=
 =?us-ascii?Q?emSnaIGaOp5babcmCk4NIfHuqos7uAoLkCWZ9S5OCAaaOkOWvR8xCHBZKTrF?=
 =?us-ascii?Q?j25lSvDNVqXww8KfChY1v9ZnUhJ6yBWHWOrWKMcq2HmosZOjSBbBBc/gbHcd?=
 =?us-ascii?Q?bc/ZTXMJCP6h8DzPt/3kdNBE+LoKtDctyZvH/TP4+6LoRFLZoot9bG7rfbOC?=
 =?us-ascii?Q?ww2Ezaioyazt58W3lzUxxaQfQl93OziX88GZ7xGjd8bOD/yz+eqFejuFnjjF?=
 =?us-ascii?Q?xJ72gSiBX9UZ1xMCcoZHRCSliH4TLj8Xkd9CRccitTYWyCcEWPfMVXdEi81T?=
 =?us-ascii?Q?R0ZsgssG6g5nXndmX9oN4qnYutarFCfWr4j2BxDgqpaZoe4edNMa5DvhzPM0?=
 =?us-ascii?Q?thx8nszR0CJ0fIK1r2HMNJKK6DAKBjsfxw+T6coM7WrEgTV94WMIczVj1bco?=
 =?us-ascii?Q?dL4m7ZsJlZt4kvl33qznKpL00umUD+64L5WDe6Tmpu9PQqlr9Vx0ceOtjzug?=
 =?us-ascii?Q?6sJZ2F0oCZSe9PNA4JJj0zJqm90inaAQKyKLBbRRq/TEmL0KTX25UcCjLvxB?=
 =?us-ascii?Q?XsPqBJSN1L1oC2OIcK1t/ircVWDxFwI8Taonu6VjGyJ7xKwq3rK9ajeL9OXX?=
 =?us-ascii?Q?HHwVL5Wct1U9QnFtXPtUtSzCPPzG3guCd10g5e05RbesMzQ1Z71ksQ2FarTI?=
 =?us-ascii?Q?BxQessYeHU0hm6nnW5XKS1BUw1UXlUVBA2ld5zmIPDlKy5/bjJ4WMbXVTl7b?=
 =?us-ascii?Q?Eg3XSPXBtst5Pr87lIP6I9m8751Iy1O56hfvLniZOPpM67t521vHUCNHiBc1?=
 =?us-ascii?Q?ERgrAZPzZWRBFJbbmlbPgIONu96RaxuDVLAcb7Wn0XOJgOrHmZWEkUIiJF0T?=
 =?us-ascii?Q?UixCWcK+ZjGDiVeOhW8hoatN0a86aE1OKW2Ou+LA5MvyaDnMtu37oSDg7axC?=
 =?us-ascii?Q?grhAUhhRAoDNcH8Yql9A9km9Rx+qPw+JTyca9o4M0LFIYiSJ933NL4YO7zLC?=
 =?us-ascii?Q?15qpj631DwuBsVBcEYeeB9bZmdby8OW8dJ6YHESMZC+EwMe/IeH48BFuQcAy?=
 =?us-ascii?Q?YgUpQByYyrDCJGf2h24T2S2V+8CydZTqDZFJJ+Cg5Qx16oVH5yUG6n5Z6qLA?=
 =?us-ascii?Q?KHLufAilB+OcFRiJLH06sJJIunh9Z2cfYBaAY/5H6mcTHD6DGA7T2cLZnBeB?=
 =?us-ascii?Q?ggu9wPS/AcFnAxkgPWoBi8SLue/FqwHIQdSPIpPVeA8a0DV7ag+U0IlZUKVi?=
 =?us-ascii?Q?mkYI4spKSXzi+byDvilm6iXYlBbi7gOY2BeH5ZgmhWSCpZwV5C2F+qITC7xE?=
 =?us-ascii?Q?iZb31eg98C3AqqZ2qGgYoRC7KAZ/tFKZCX8SdOWaBoNoCmxuC7Dle5UlInXq?=
 =?us-ascii?Q?XPN7JnnKdJn97xuFAdzSyWGTHTWL2innS6yLD/WHYSuo04jxvtcKSBvulEyd?=
 =?us-ascii?Q?DPlJcOdWTT2QGSk6co1jvlbUniq4xZcbtdpitfZAMTHzx9MwS7qfw0mytHzA?=
 =?us-ascii?Q?vzDDjZv1jFcF8QaqX+0SbSHBWSm6UQz8PCwrC4mGxpNrmlaPwLEsvljxLeWi?=
 =?us-ascii?Q?H/+ja/tpXRCjtCfi+16/aTfcXV0ZqiV9wIQh5x7/rCM8IbheJMpiM65NqYXi?=
X-MS-Exchange-AntiSpam-MessageData-1: W/0QJa+HmYTX/w==
X-Exchange-RoutingPolicyChecked:
	WMfU3WsSomjnnptXkhxXack2YkyY5qAAGybFz7i6ZadLIndTAUEY7ckd2K6ha88p1b7OLj/ahiSxqQ+XC7vMGJXZkrp0j4I9vDXmBJp09NuqS2O93yC1Xb2YVTZ/87CRhfHvvXpDv7zB+rR0KYzxgUOibU3O3DARm+HtnL0mpXSk1ikcyb+Vmq8gUA18EpWt4fR1UAdzLfaxxY0Gmzk94X0k6994UKLLZQemMvaI3Dli9nTjbIw7ZySUxEtITOEhmpQ2WufOqlDrs4sx3xKjY66K8fSKw/Xme38Bopt4LpK/yhRdRXQrfq1HH3xxmqDyjsuP0wh+GoZF9iEqqVp5yQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iaMEu2yVXmYLkAjzOI7+P3Tq9C8Crkj/F0SrT1DvtRFGMHErkXJA08yLTMmeriiiMhZqhSIr05A1NyY0jSZMNgjBI4FHS4JoNhl+luq6/K+CfkeUqU//kbdzz/PRki5VOPHNEs5ava12Z+OIq3FnV6TSqPkk1Rc8vFDoHyQXiWhdCeaD4l5LagS/IZ24A3OSP3lVPCpeaIogWnwShvlejcCcOhETbpulX2kZ9fyi3q1PWanB997k1jkPSXdBFUuHllejhkx/wQUnuWk8ydhbZpZdS72bAcpc7fCWAa9/BnKDbrkTfGtzWlGq4K/RCU1ngxloOOksVQzEVNjHlR+2Cel3I2E01NFslMiu5CEKwzG/GLCu+WGR/cIAx3RN6+10gFbEHM1APHG//K0fojxp5bmxRZdmz8dmyHWYMqgKPXtVyXkhvVe87fFe3VeW6lTvHMcCzqRmEKhKH7t+r0ZWyQTBhetvNaB50MiHpdkBleOIHD1RdTD41bDaE3AP0DtUHrfXCmWvAEq4dU4uwFT2l9A1ZsqB5NzqUqwe2qgUV548USBAJrIbDIzSx6rfkSHGeB24rGZMWjxz2JZPUGjIAciZuGWA1wQ7Rgds3K8vMf8Sai8UHJ/OuVgfKSwZhaZN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73972aa6-9673-4b2b-7e04-08df337b9138
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:52.1723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bc6j8wTCfOyZWRwrOPI1nk9IEG6oLj+QFSuFB3qVZe6OyB8kAXBuFJ/oaDU7AcZ0P70EAzLeWRzjogdhDLw5HOgCCX+mPTR+Ibhmwq28Z40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

Move the code that resets the zones of an unused block group and returns
its space to the space_info out of btrfs_reset_unused_block_groups() into
a helper, so it can be reused.

No functional change.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 128 +++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1a16beaa299e..ceb7f54e838c 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2905,6 +2905,72 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	struct btrfs_chunk_map *map;
+
+	*reclaimed = 0;
+
+	down_read(&fs_info->dev_replace.rwsem);
+	map = bg->physical_map;
+	for (int i = 0; i < map->num_stripes; i++) {
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
+		unsigned int nofs_flags;
+		int ret;
+
+		nofs_flags = memalloc_nofs_save();
+		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
+				       stripe->physical >> SECTOR_SHIFT,
+				       zone_size_sectors);
+		memalloc_nofs_restore(nofs_flags);
+
+		if (ret) {
+			up_read(&fs_info->dev_replace.rwsem);
+			return ret;
+		}
+	}
+	up_read(&fs_info->dev_replace.rwsem);
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	ASSERT(!btrfs_is_block_group_used(bg));
+	if (bg->ro) {
+		spin_unlock(&bg->lock);
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+	*reclaimed = bg->alloc_offset;
+	bg->zone_unusable = bg->length - bg->zone_capacity;
+	bg->alloc_offset = 0;
+	/*
+	 * The zone was just reset to empty, so alloc_offset went back to
+	 * the start of the zone. For metadata/system block groups the
+	 * write pointer must follow it back to the start of the zone;
+	 * otherwise it stays stale at the previous (finished) zone end,
+	 * and metadata written into the reused zone would sit behind the
+	 * write pointer, could never be written out in sequential order,
+	 * and would be stranded (pinning its folio) until unmount.
+	 */
+	if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+		bg->meta_write_pointer = bg->start;
+	/*
+	 * This holds because we currently reset fully used then freed
+	 * block group.
+	 */
+	ASSERT(*reclaimed == bg->zone_capacity,
+	       "reclaimed=%llu bg->zone_capacity=%llu", *reclaimed, bg->zone_capacity);
+	bg->free_space_ctl->free_space += *reclaimed;
+	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
+	spin_unlock(&bg->lock);
+	btrfs_return_free_space(space_info, *reclaimed);
+	spin_unlock(&space_info->lock);
+
+	return 0;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
@@ -3241,7 +3307,6 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
-	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
 	LIST_HEAD(retry_list);
 	int ret = 0;
 
@@ -3249,7 +3314,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		return 0;
 
 	while (num_bytes > 0) {
-		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg = NULL;
 		bool found = false;
 		u64 reclaimed = 0;
@@ -3291,65 +3355,9 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		/*
-		 * Since the block group is fully zone_unusable and we cannot
-		 * allocate from this block group anymore, we don't need to set
-		 * this block group read-only.
-		 */
-
-		down_read(&fs_info->dev_replace.rwsem);
-		map = bg->physical_map;
-		for (int i = 0; i < map->num_stripes; i++) {
-			struct btrfs_io_stripe *stripe = &map->stripes[i];
-			unsigned int nofs_flags;
-
-			nofs_flags = memalloc_nofs_save();
-			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
-					       stripe->physical >> SECTOR_SHIFT,
-					       zone_size_sectors);
-			memalloc_nofs_restore(nofs_flags);
-
-			if (ret) {
-				up_read(&fs_info->dev_replace.rwsem);
-				goto requeue;
-			}
-		}
-		up_read(&fs_info->dev_replace.rwsem);
-
-		spin_lock(&space_info->lock);
-		spin_lock(&bg->lock);
-		ASSERT(!btrfs_is_block_group_used(bg));
-		if (bg->ro) {
-			spin_unlock(&bg->lock);
-			spin_unlock(&space_info->lock);
+		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		if (ret || !reclaimed)
 			goto requeue;
-		}
-
-		reclaimed = bg->alloc_offset;
-		bg->zone_unusable = bg->length - bg->zone_capacity;
-		bg->alloc_offset = 0;
-		/*
-		 * The zone was just reset to empty, so alloc_offset went back to
-		 * the start of the zone. For metadata/system block groups the
-		 * write pointer must follow it back to the start of the zone;
-		 * otherwise it stays stale at the previous (finished) zone end,
-		 * and metadata written into the reused zone would sit behind the
-		 * write pointer, could never be written out in sequential order,
-		 * and would be stranded (pinning its folio) until unmount.
-		 */
-		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
-			bg->meta_write_pointer = bg->start;
-		/*
-		 * This holds because we currently reset fully used then freed
-		 * block group.
-		 */
-		ASSERT(reclaimed == bg->zone_capacity,
-		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
-		bg->free_space_ctl->free_space += reclaimed;
-		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
-		spin_unlock(&bg->lock);
-		btrfs_return_free_space(space_info, reclaimed);
-		spin_unlock(&space_info->lock);
 
 		btrfs_put_block_group(bg);
 
-- 
2.56.0

