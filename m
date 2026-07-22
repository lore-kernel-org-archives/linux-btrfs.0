Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC9948BD40
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 11:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784720330; cv=fail; b=YrpahTtCtm3m25+oYDcgTSpaLSgbXAx5CmjO/LRstCynvIit1/bhU75hH3Kw8V8YLiEn6UVtgvpOLCycYd8zltCA79mJsepiuUtY3EIxzQ7UmS6lu6hAU5Ec30v121hfJETaTPj78eJ+EfcWbhessBPnTUn7AvYzD8NUtZEUUy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784720330; c=relaxed/simple;
	bh=BIYVdlB0Gsc6moWWXACev1zgtIOM2bWWVhMvPLbFWKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c9zQSfrXOHPPp5qQxCMPSEsmqTCdoZbejmMJF9FvvUaaqjzJDu25H27W+jL3pCqu5vtkOY3QMd6paQBTDMDcE/MsaTkN3lQV/4E/qhtJy39EzYkKqzalijHRNovklDSF0NR+pQ4JuM0LTiDt+FO8XwZworZQ7UY0hk/4cfT8Qr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kgCJ6+5m; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=I1yoRX+c; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kgCJ6+5m";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="I1yoRX+c"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784720327; x=1816256327;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BIYVdlB0Gsc6moWWXACev1zgtIOM2bWWVhMvPLbFWKM=;
  b=kgCJ6+5mxp8ZzLKuMk1FiZqWdaOKzPim3weIUBwlehEeAOYwKxkb7eBw
   gfx1o71QCd7K36TTq5vT/uWQe/ZCmve1F0YtBADQG10BamKyY+85+pFn0
   Btb03VAOpTmB8kGiL9eFEyrjZeLLCjJdb8Rqro2iWTC1jojwMMYzaUqkC
   qhqDO8coyi4yPsLvvq19jH6aEh6aksOk4OjwioNyRXfu7oZj+FLAfSTqR
   JWxielx9OOctXE20DCB00UJ/4tztLmO02tvaFzvDaG/rashkL7JIf6ZQ8
   8PtE4d8a8/jiK0Q/Xvi1bnzuPYNBWVqCQT8LOUo48S9JduRvga+P3w7Tn
   Q==;
X-CSE-ConnectionGUID: otlQtvEVROezAa38Z8P2qA==
X-CSE-MsgGUID: 5nIYITipSkSVdN81Z9A5qw==
X-IronPort-AV: E=Sophos;i="6.25,178,1779120000"; 
   d="scan'208";a="147386906"
Received: from mail-westcentralusazon11013043.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.43])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 19:38:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dhr/C1sO69RUY9UrqKWwYsTx7VJYvdAkvcLPyXux6hCSrYoopGG/8tfLP3B/45WExtP8VJomYhhINGqQQMUcmWVJfs4s4Zs6YSeIBNa+hWVbngl+sUr0bcgVskpCJxPljehjc6RSroqA+KyKsuKPLXXBsWlwGuTvo262cvko/KO6mk96Q8Be9MKNTIv50Ce4DkSbPOSQReZj9MMm4h8m0a4sm88phGPsCSf+F78ayK+tGt3B9uVqETKies+M6wEyBj7DxTwFYOatoe5GjKjDYmoaJ/eXqmIEjPHnsBRMhs9UWarl/roZEh0n6oxp19wLXDjUJp0WoPV04+KDKl+AdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkO4ZnoQNVld5BT/JDguqMtKZOULCMgdNI9kDiOHV9Y=;
 b=D/zeWinU9CK8NGvTxfXcesmfWJ6AfloOntJXTuDLTapUfveMSfWjRV2ZIUaa9i+ibh9pT2p4epleUn8FOOrgsJJrxhki81UFZ24bZLVaUZt99XKqFylpZSovXNI2IjH2MRTUzjEyppz/ufBLuV3yiJZIfprjSVxGKKm0K5m0Iu6Hqls2miOrwTLwhm9lGV8N2mN/61w/dv248h2OsbxXe1PRN2GwqzFnQ1vJsXoT3ETi2qP28wRKV5yS3yXlXkcEAoo2qP7go9Vn/QcTk82B5uAmtqCbO0agw0D3H7hnKtvG8c+5kyoChhNPvfbQpuoSY2NO+PmfkfhAfqn/p1SdHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkO4ZnoQNVld5BT/JDguqMtKZOULCMgdNI9kDiOHV9Y=;
 b=I1yoRX+cYTF1/5xD9KKDilWCuHlVRnMfKktqrjW1WRrg+oAsI0RSsfeAeEALmv/7yi3+RWvX9ZDh6/BnIimvlLNFa/abzF+i/k1iCUiOf8xErdlzc/fd9AM3wHF7sM/ja5KU3f6+OvCqjhfeJ7Yi7cJFgUhBEVi3BHY3+Pab8M0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7548.namprd04.prod.outlook.com (2603:10b6:806:148::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 11:38:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 11:38:36 +0000
Date: Wed, 22 Jul 2026 13:38:31 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: HAN Yuwei <hrx@bupt.moe>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [BUG] cow_file_range failed and kernel panic on zoned device
Message-ID: <amCrj87j9JjbTJse@mayhem.fritz.box>
References: <FC0DE3FDAD40B4C0+924da345-6000-4644-9b0d-0439e63f3381@bupt.moe>
 <al-O9D1Pv6S8mfsy@neo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al-O9D1Pv6S8mfsy@neo>
X-ClientProxiedBy: FR0P281CA0233.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::6) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab5f44c-4143-428c-eef1-08dee7e5c46d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|19092799006|23010399003|1800799024|366016|22082099003|18002099003|56012099006|4143699003|5023799004|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ogTkSDOTg+DWHL5G0ZjrbKx0BARxEnMBkn81eU35c6kWG+mngXc6+PM/2ICmrdxytbpseFVQsWZJeYINm46nSfpeJ7prKrOmoah2rsr1r0EbU3YGLKfejs11CMG5/tknpQ9f8pnLgdj2wGOFgUDQaOjrhEh3GtUQxEyN6KvstOfywRj8iXA3zDPZZHi1oatGOHt5YgrUwjmlQ22uFyYPnAI/UzUqmnLdvD66geNFwAOksT00YLkrSMkDQFqzbZt9FV7Dq9q9Sc/EeyfUzWK04EQ6bwF3EDqGEP9jybEsWlUKOmR5bxzKVVS9FvXvKrXwXPyyYdgiNA7mJSQDTHImmTLW+2oWNUcXkuG+Pg+LDOzDxcSkGNGU7PVsiHzKivPWyKhLyg7CdWztvK/b1enzj3YwW/279wONeTYeauxDvppqNEBU9gjyHjNIIeGoCRCSMHbbbuQ5Cpv0TQ042925KNqxU839oOk+rgiHzOzOaqHOqiPic1TCxLAtPYP4igX2WJNnl6KZ0sqz1j7vsCMw3phSkRBRFSGl+zB92gZdXhh/v75hzlCBX2qdCAj1PVnHk1TOO6pbIEyYvstfd+BGE6wE3J9eys3aYEOO/nJHkgp6QHfAzfKEdRVfL7B/+eLb3imxJqqK66olvlk1kbU2hrXO3BEAb8+21yelXAeItNE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(19092799006)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(4143699003)(5023799004)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ppPaS9m8d88hYdaZer4FAyu5AyNjsSa9yGUqwxRtQBc/losYhGZWlCe0VOaJ?=
 =?us-ascii?Q?tX1fBHNtfNoRg/362xsvMwi/+Kg3aMjJvLe1t6/DFIIHmxZfXiuRrCliI68G?=
 =?us-ascii?Q?hF7nieEWem8CVLE7UeQR2AK81/a8UFAo3lMT27FYIrSdg3ycPNXJxhGzjexc?=
 =?us-ascii?Q?xSbojuSnm3kv7tfF3WT+vKlZsSorkMQZnP8YERgIVsGLmGIXpklL058YFQ9q?=
 =?us-ascii?Q?ldn3E3qSeGuhjBU3vPkQQ7BWLn5pghGR/222jwvdmliRwW0DWEBQizRK311Q?=
 =?us-ascii?Q?KwqAmo78/jS2YePgPv4DUQfhrrMbWXyMebNYBsYU6T/8KQUf5mVziXneHPPt?=
 =?us-ascii?Q?cUeSxxAM9tQ+fKrv1S9m8FXfF6F2Z9cNUi5E12VlTC2S+JeWy516bRzb8th8?=
 =?us-ascii?Q?OAP6Pp6d6Yxfm/c9ploA7Owr69TVtTBC1nM5tzZdHI7If/GhWPp8TJbht/0V?=
 =?us-ascii?Q?mqnz/KwB5iFhk96JohxtS2a20LlayUiSxednL9UtS2eylTFAoWFhJ+VpHo1u?=
 =?us-ascii?Q?rU9RfJbej1KG3FVUqIVUsc4z1TvytkjOGXvc3O5bXqjVH4UwRbkYa5yJ04tX?=
 =?us-ascii?Q?9379/xRH2nGcEZI42ap3M5rTCQWBhKqj6oK/iCHbHclGBJ+JC1n5DY8CIvb6?=
 =?us-ascii?Q?aMVPDDxq5WMOcfKTzm+708rbStjFhX9epB/SidGMyUMJ3Ac9COntBxwvP0lc?=
 =?us-ascii?Q?hBe7a71yciI1Kw4JafucaNYis7em1ERWlr5LHXXW7cELe9LLYsWMxT7gvhYo?=
 =?us-ascii?Q?STe2MNFhDG1YSFc1SQjIeGOJHm+e8XYRqzhsO4VNlsZTVZ3ji4ll96l+zGKh?=
 =?us-ascii?Q?eZyfxFX/AhClFUsLg4+8VeZ1BezKYVhD2ERhveGHvro4t/zwnhx6ykOqvDE7?=
 =?us-ascii?Q?9xXMi1vLztp+LdG6dhyrWVVWlgSmx5o4452fbiI6IAuEydR8lTwZ4eGXDfjJ?=
 =?us-ascii?Q?LklQTDVRNNd7WL/5c0DiuzhW4dsJ0wPurUHBcVuIOQBBkwYoBcw4TNuQCvUo?=
 =?us-ascii?Q?clFZw6mBRxz7QFRC0UU/xQ8P6QuoKDPfzUp1SkvQE+rsvSBf2AzhQudn3VJ8?=
 =?us-ascii?Q?o4t+W90Jt15vNHOwXxqfd/ZeTP9Mh2zn5FaPQJYD2ShEgc8776lRxNxLl26d?=
 =?us-ascii?Q?jDoT4wpo45NCsj2dca6LCbTY+Ws7X0yz5xWoLDwYkyQFfg4v+XGDYpcUBMNC?=
 =?us-ascii?Q?8j7jgkIfSNPAB8+i0JWNfJCvPiRkfR7HQE6Vqi9IwzdMA7e41vtxpBH9GaEr?=
 =?us-ascii?Q?9Qf3avqqDdBTFS2eU3uupi2R+Y/rXc0tWTYh07uAAw7YTqE6d1Wg+ZUpVoCx?=
 =?us-ascii?Q?UBiXl71vNnd1G72z54/P/eUfAeew+h+rcsMdKGxPvrsRWsuoIZagrr9bFgMf?=
 =?us-ascii?Q?uKbbVa2jcmwZ9iXKv8dz6VoZuh+v1QzpCIeVFKVJhbK0gslhLsNVPwdTkUFd?=
 =?us-ascii?Q?yYjnbotaNdDxv8ICGjTd5R839SgjWTwhagbNpYg6susmbTw5Tn/NlY3+Qox1?=
 =?us-ascii?Q?5FWKmxaFxR88v9ovgo6nDdU1bOJGpoawFdbqqDcEV7ySDoICVXnfHpIzUSzq?=
 =?us-ascii?Q?hCXn/Zxm8ZprWryIIIybJnPNWWxpPh9bdXolWck6rUfi+7mbp+9s2fKJZQgC?=
 =?us-ascii?Q?Y/NUN4VXNr5sv2y8mj3YGDoWR1hLLEcaTeqRbXLqTZP+ucRDJA25iu7CMWsN?=
 =?us-ascii?Q?qDr7U9XmeJsUajYlfYf0gGD3qMAcwsLDCU/iHS0hFfE9p4Ph3r+SHj9pQ7/Y?=
 =?us-ascii?Q?tZ+BYm1hufAjPeIL3cSOALgjazYltXkNhG2RgTP+RRDGzwilCB9erq+HM0a1?=
X-MS-Exchange-AntiSpam-MessageData-1: axXXAWGPNHbwBondUkbEerkLkjcwqNr3xI0=
X-Exchange-RoutingPolicyChecked:
	skmJYv+MqkhMv+9VeiASqwQyjQeyTA9KRJy0R/ANSvCj/B1I9k1hh/7oWF79pGI6G++93Fy3eJywfhVYGAKPDRnBcdaAJ48vj/mAMfqbVAwLj91gPL/jrjvik4khWKA6Fbtt+4wi4H0B2gR5fpvcQKc/hae1tUqwfUhsXimyxY8EfA5bVN1HUwrHZLLfglCSZhQghbPe0iUPfv9Oib/LG4LgDzQouanmfzBrajTh82CnH7oDvaU+I1x6pQ77HyDsu9LfmsboPVxwi5GjRJ8bpwZnP1GcjbD3SoAk1ve54aQKPYqXhbCHtgO1bAWckBSCxERmB+pBkJ2V3CbVag08xg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JmG78Tk+3J7gfAcBPUboitRdONWT1dCSYctk1mT0+spXjzcku+yXvMmApL4elylD8/ogpebn9GVAKANTCLNt/aj1IZTC0y4yucbdrqCJT8vK2ZDuO1lwAd1i29Ur2Y3LbciVaGDYl2jkgVSHbjrbNJa3T7Mg3tJ+NwUp98xiwBVt02uv92NgE+0z/T8+KkxMf6n1HjKxlcyPheaLu2padaP8lHUIMd/0WUvrbjUFOeBpw4SFrOLPslGq0pmUBEgEAXGZpXE8jTdsCrbs/Zx6z1W06BEfwUDY1wy+JxU8qZdDmuncdN/DN6iEe4qM9XfpzEXMo0/9QsGwghY32mXtZr6XxphBBaMunMrEzdlY9zXs8q0bYceFV1T50cx/6U/eF/6gDlx6NVuxFeWlNWtJUKDtJrwlZzbkXUMhr4/oZz/LgFxhoiklkEtY/WjPf3TGhWY64m5mPMdr4STNmPeqtJulEX5y3ez+QhDKTLcjQCkN1XjRM+wgiV2Q6JVTMTQtSVcZWFrxIbKhl3ns9E5RxgR927dFRuONi48u25yMmIgv/d3/61CXx6A8wqKV7Svp1g1xqqV22nylVmNMpB9Eg0wwF9If3+Ech7UfdVTL13oGCtTmTeQddyIPTXaUn+Fc
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab5f44c-4143-428c-eef1-08dee7e5c46d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 11:38:36.4075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vS5sqKeP/6IyyBTjXk1H35sDU0X2oLmJJuF9TXN/DDSvIPzwICyaC7JO3MAbXrhTlOYX27MUFj7XMZxAnxeYdYubZymSSkwSKZIh+DTF+9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7548

On Tue, Jul 21, 2026 at 05:29:06PM +0200, Johannes Thumshirn wrote:
> On Tue, Jul 21, 2026 at 07:46:53PM +0800, HAN Yuwei wrote:
> > Hi all,
> > I have received a report from a user stating kernel panic when writing to
> > HM-SMR HDD in 1TiB. The user used "mkfs.btrfs -f /dev/sdX" to create a new
> > volume. And he tested xfs on the same device without any issue.
> > 
> > Reported-By: LUO Xiang <luoxiang221@mails.ucas.ac.cn>
> > HDD Model:Seagate ST18000NM009J
> > uname -a:Linux pro69 7.1.3-arch2-2 #1 SMP PREEMPT_DYNAMIC Thu, 16 Jul 2026
> > 17:41:28 +0000 x86_64 GNU/Linux
> > btrfs-progs: local/btrfs-progs 7.1-1
> > dmesg:
> > [redacted]
> 
> [snip]
> 
> > Jul 19 21:28:37 pro69 kernel: BTRFS: error (device sde state A) in
> > cleanup_transaction:2067: errno=-11 unknown
> > Jul 19 21:28:37 pro69 kernel: BTRFS info (device sde state EA): forced
> > readonly
> > Jul 19 21:29:08 pro69 kernel: BTRFS error (device sde state EA):
> > cow_file_range failed, root=5 inode=268 start=68295892992 len=688128
> > cur_offset=68295892992 cur_alloc_size=0: -30
> > Jul 19 21:29:08 pro69 kernel: writepage_delalloc: 383 callbacks suppressed
> > Jul 19 21:29:08 pro69 kernel: BTRFS error (device sde state EA): failed to
> > run delalloc range, root=5 ino=268 folio=68295892992 submit_bitmap=0
> > start=68295892992 len=688128: -30
> > 
> > the full dmesg can be retreived if interested.
> 
> I /think/ I know the source of the problem. Errno 11 is EAGAIN and from
> writepage_delalloc() it means we've hit a "hole" or out-of-order
> metadata. This is exactly the kind of bug I'm trying to fix for 2 weeks
> now. Not sure why it surfaces now but I see it failing in my fstests
> setups as well.
> 
> There's some hotfix attempts to it and I *hope* I have something
> upstream acceptible as well soon.
> 
> This is a BTRFS specific sequential metadata thing XFS will not see
> because XFS is not putting metadata on sequential zones. 
> 
> I hope I can give you something to try by the end of the week.

Here we go: https://lore.kernel.org/linux-btrfs/20260722113016.1896990-1-johannes.thumshirn@wdc.com/T/#me996c86cd69671aee67455dfefccf29062ff222f
