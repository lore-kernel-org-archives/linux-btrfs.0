Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031007;
	b=GsK1i9TMJaPWWaLL/yBGfOdBJJfzzPZsmu70sH1oCJXdSdfA72Balpv4L5xxngNgnPjD
	 /p1GAH41FEhMWd0ZckgkCzFRs9uoIBmuWFylYXWTK7OG6dnHiFQD99u7EVS1hyEjZaon3
	 YV2HOgrSObySTk75R//37f9Cm6WQi2W9ByAiXgngYIYoRA3PWMVURMTOhbmWOvgR/CqUv
	 f94Wm98PG1dKs2RAYXu+uALBYzXZrgkfUfr3fXtrcM7wXFOqZpHrn1r2vwbDvGKo8zEYZ
	 zjjxelYsZEVfYbDytQkvsAG29GcxH8xeeholwBDagPlxtVgqj6adtm3LnSoavTYW4QQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031007;
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
	bh=knLEkP9rxOm4NXg7YJ6IkF6+Ev6ppbU7DoNe659mIAE=;
	b=hvu9MIP0eLYKbi/j8nzJaMHxMmObsOb0skzTq07Un3I2oVRcZL2EQHXvEh132NwxApQt
	 MEpd9l7b0/cxOxxbc8FKz3ms+hpsqLEvJ78dVEGqwvTp6Zy/YIDUuPJ0o9zhPhxWMkUN4
	 Q5bH1PRLndfWWdqem5+5rNxpm9kFGy65GpjFuP7/V/qJ7O8fmdSxc40dN4S7sqvBUJAr9
	 HQkan3XcobwVYHyQkoArlcHcJPsMSSSI90erU9DLCNeT/W7zSKNILqcIgjvCPvbuLxm/p
	 M1U8RfVMDn42bd2XC/aDJ7u5mru+xnnMAJy++rGsoa0LfnTe48u4PXrzTX7tiRfNgcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XLczHHVr;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=UcQWqMgE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72132606A324
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72132606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XLczHHVr;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=UcQWqMgE
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031006; x=1824567006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=++Vbj/Z6BOO/yy1fbEc9ye8C6/lxC0eo5F6jhvsl+HQ=;
  b=XLczHHVrqcz064/6JIOcJ7NNB+nMrVY/O0ZQeLWLghWy1iyhjsQIT2jt
   lyvBa3vJA8foLh6dgr7s0bxpVH02tgD/NQDrrCQ8il3VvlEPDGHNYkuNk
   YHBTCVm069vzWCxFoKwWqucL5Zeoh5qn2LiX/SaxWkzaO2wfyMHxpgI08
   1xHygJDsnTo6iw14Kp4BmU/qAX3oZS/1DQ+7WzHvmxUfGfMyi+OOR1Jwm
   qUut2s6Bb3iSZ6XXnbbNkDMKcuAryzYoP8dTd3RrxUpZTtkAEOQPGsyWi
   D1PIJ5/bIuKUVCi75zRj+5ZwIjaXBU/BeEn4j01v/sv/lyNDWAYUtuGZ2
   A==;
X-CSE-ConnectionGUID: 6pPKiZJPSdmLMm+0WdQAjw==
X-CSE-MsgGUID: ysmIHMR6RdC7pvNBJUBf6g==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033896"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:09:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKEeXu5/FnuXcr1ihW5tdm3QJY/A95+fOGhHikWpp1HxX/yRoLXMO2G7aecGF4h5FcDBuIzO+j3iQEHoysjfPkF4+XE0CoxbExylqiz0OqNdN5wo/qLrWdOCGL22EYG/9J9RSFLWJBrrZgdkc3sGCTeRxwDRktgfVT60sDByl2Xj+XTh1W/5wiwq5KHMdeoam8YIper6jdzU58qS37QF1PT+pG40FTHzezuRn+p6bnZGcxXNzWky9iYcj8VKXeu+7flxRdv6MU8WYkGXqFFQvu4MA2EpaEEA4KwbPgnSrcvxGKZfLQTparheLEIK8sbOwhrDxep5mJKJkvxldsriiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knLEkP9rxOm4NXg7YJ6IkF6+Ev6ppbU7DoNe659mIAE=;
 b=olGgChieR9U4qm8mn0EefUizUPMLhNYpUXEZ0wxMpqgjFmA7wiuICg4qlCzLUud5XHkDDC6cRRb4d1/9eW7L60qhnqEPkOS2lwN9+MwqwEEC1HfL8C0txju47T2OzzqzE9SowMyt298mQ6fNY+/aXg3xKfMc1ZS9DVUunLmEjkmAnpC4QFhm7oVz7HNd2cs+/rTlOZ6D92Xg/IuiTiGIsb5xHPG1MpaSIvm+vaGxm6VEXO8GW8euwCvYsHnoguXAFoSoMVt447hyWlAczjszSRJG0f/pA48YuOCCgAPLNPA/J8iTcl/a1ftD7pMZyscUcb+fXx4IJixSBfjMhO9i6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knLEkP9rxOm4NXg7YJ6IkF6+Ev6ppbU7DoNe659mIAE=;
 b=UcQWqMgE7c7W3T/IKS1KlsEXD0r+XWDKHcZFr0w3Dx0kJ2WCKd6CcUhJuKraruf6VhwQ5ZDR8MQy5MNgP0n1Jvvm6iHMrsNviYKMOLgFGDl5ve2UQBEJfgHzxhyPgvRC0j9nC8j9Nbb/8FJAbdWd2uL7IlJiHOdVvAI/EAjIxtI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:37 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 06/25] btrfs: zoned: only take the metadata IO lock for append only block groups
Date: Mon, 26 Oct 2026 17:08:54 +0100
Message-ID: <20261026160913.207909-7-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 228ae46b-e34a-463c-4926-08df337b885d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	D03JelW2hE8TOb1tYReyBuPsTjZ70AeEk/rLD00NezlMXmPhKbM7asKGeNON8O5JeqXLlY01D/4W5Qu+hLKrMKJhxBKjYo5jNr7ccJ4cdwH6zl7eOj9CvlPDqXlXgiAqalAqugDjCIiOkUIRdu9+nQ/cytsQDroMVlcxKPHS5zQsgeV+wmue65dSM4gH8wwwtT8ffNXYus3Inmp3EkEAfSqztoDn0OQZqwCKgx/bZjjHbUf+KIOtRAjP0mCWshYpkQkToXcC7E5AGm0jUsm+pN6rZaR1sV4YtoaFWgN8iiakeL4Zlpei8R8iuKZamC0AMB1kud5ZsWAcA/Iqd6qI54yGoJMtFXhGpxYoYmAc/3ymtIXTQ8E7WwR4F5FajAOEuytZzn3MpQZq88pDHLY7F4GwcuEJ+tn4v8kueteanuqgEQ1065N4H/UHxsV3guwzlllLR89Pf+ZQWi/iqCIZBpMmJwchp7En9TSOE/+j1yx0EmmK4cp5RSPJoaUlVz6nIqnUMrCke5JlaE50Co9bwtU2h+Ysriz5sjfdcfEEj8KFVQlPapezc7Jk5Z48y9KwKej29CtWWMdr/T5U3Y3xPG7nYmSokVwdZW/b+pQsK4J8EJzi/0fDztnRtF4KynHQFiopJ0ACffkK4CLyZg9MqNivr9sEz0jKc7ui4UvRWYE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OzgMYgWRF33VJP1apx6Bt6zpz8NtL6oFHR2RfNQ+w3k4Kxy2xLd628tP1btp?=
 =?us-ascii?Q?qX2QVFcpV5gRhQsxe6VQzdoA8MSxcg3aDjlvZuGYAUDGCj3Vx2vInwGKf1Dq?=
 =?us-ascii?Q?3RdMOGifk8vJ+qswaXctUfVfURAaSg6weergaxlAxqphRagIdfMTQZeqDw1q?=
 =?us-ascii?Q?EadtqGIk9QOdiPQMGnxV8AajcihbNq9YA8fw84ZlMAvNxt1ax3tA2rICSB2N?=
 =?us-ascii?Q?Id3RPXcsP2ZLKmUB7rO1M+IBFVte/KGqqv9sOWVqgFjUzgLLBUaqdcAteGga?=
 =?us-ascii?Q?pmnpg+sWbyhVDtHHuaNo6zP8YaSw0vy4UwgR3CHkPmNnDAdPWSvB5Ok8AH1i?=
 =?us-ascii?Q?vJMdIA2c4ETSdiAtbhWctLG919foloNKiYIQZvtdorknG9SPFH+owKDnqugz?=
 =?us-ascii?Q?JCSSOeisB+5IuhIAZMH82jsGQCVkAKk20cUILxkjV0K6m1pDR93CoDyYWg/L?=
 =?us-ascii?Q?I4n+HiTggEFTCCBTUQr8SyholB7p8ydg1eZ3hV5Vkoacfz+FiapyErjeewyG?=
 =?us-ascii?Q?IMkA6gNdg3YDLJkstYsHFqCiHyYoEBZ6IueMGw0LTMcYuJ0LZygbHx3T34pl?=
 =?us-ascii?Q?vJ6TuHNUy836yRdjrEPQ/jKCj4B1BdPs8NVuSJgnHCI5Wz7WjL6fqt3rHC4e?=
 =?us-ascii?Q?VwUCpkdheTp5FX3xo+nRMWgnhOFBkF/suNLY/582JhA4wwYjofY6p3pW8JHM?=
 =?us-ascii?Q?y1nLT65zNF1XZterKp7qL6TnHfP2QslPNqeomdIreqlXU9BUiJmbP8hfpezP?=
 =?us-ascii?Q?gUE6XbOYdjg6Rdc8INRu0tePucFQSQ8jUvH8LPTy2Z6yR1dn0Y71M4B1t0Jm?=
 =?us-ascii?Q?6vpwLUZdSnQOAHlsvWI0gBvo2x9+8Vbt7S0M3TRRoy/oGlxjkLFImhSNzKgj?=
 =?us-ascii?Q?cpdmgfYtqI17NGTSM6LlG1Qs2DpmpFPejBgu6JkREREPqsMx6lSzbZ4fIVAh?=
 =?us-ascii?Q?tfDcOBG+sODGEFIVRgg9NoWvP8To1LOwFlCEMhipUq+UQ8CCU6XFss+1mkps?=
 =?us-ascii?Q?nHdazCP/raWBX8cYfzMeG2IrkmeSk+Wa8r1NNaiS4mJOZkWJGeX1tYK04NAp?=
 =?us-ascii?Q?orwCmsFI0WAytITrdOlfOy6hJLJ9Mg13gZJZi6pd4W1F1Fnu+aKFRMm2VJqH?=
 =?us-ascii?Q?iJtmv7xVJouIZ7bBKgWjARCxedJy8eDKnyxaxp69ZLorUhOz0kVMWZu7QPbf?=
 =?us-ascii?Q?IDWzjG6JoUleenGnl8OmdP8S8o6N7j4xmP6/LRSSpL2KlWNfU/X0eGuUnyY3?=
 =?us-ascii?Q?8P2VCTqGin2x42jHwXeEFOODd1xziOJ+fZMyITI5Xl3d1a7WpeV+79Lj3Q5q?=
 =?us-ascii?Q?4irAq3OO59z7T6agTXzoN+gBj52z9F3TZmWCFXSVep0OmmXBt50eT9ciz9FI?=
 =?us-ascii?Q?ykTCO+LWLUEwMGpLWB7+H/68RMkj2d6OforLB9+FfyUd6ttyNtil/k2Q1O0+?=
 =?us-ascii?Q?c91mTGNGSG7dxGxmP6GID+rWG+LoJLW9dkCPQxy5owInXRKowoG+VGYZsv17?=
 =?us-ascii?Q?tydw4YLFvH4IsTHobu7UQ8xUj6kXaTer5zFMfIgWpMLs+IPv0ercYA3hWf8B?=
 =?us-ascii?Q?kJsJCCFgGRTsXgDrRGRsBSPQoiPBOlM46yJ1ZJjPCQjpruT/9KzYqvJGm7QE?=
 =?us-ascii?Q?TcZ04TxUGnKV/1y6wD6siGqRjVync1qORTGWnhcXEn5ekWDFBjea4wN+IZCf?=
 =?us-ascii?Q?duCU0+Am/aJygNlzgqFTKnB64BiNRbipntAez21mpzokQ+u1YsZQAROgIzJ/?=
 =?us-ascii?Q?mCsj5LpFiS2s4kNCxx0FRl+gCAJr+QFp+2jSAvUTbJMsQe0P6OdUg5CC2g2g?=
X-MS-Exchange-AntiSpam-MessageData-1: YMOsIPlIyVAyNQ==
X-Exchange-RoutingPolicyChecked:
	Gg7p+logQCPnqg4FVw+DTi2r/LqSBJdTYGSC3K0CpJeToGUJZRuasz7fyKld8FKnOFNiyGNfu3HT4bVze3IdHcy5Ylgx8A/fmhoBrjpMsx06L9Psku7o7eIMURSNAlJBmMLDTNbaYHdnj9Y+8Jczr4CdlBbrYyayNq1OTUNXcBKb7Q251ZF6oXok3Dzde8H3ptCECnEwDB/Gh7PcCk/AfHmfknct6O5uaO5BlDQiWUExPeJMDLkQcHJ4CqzU/wzbUrfPcYQeZOCdwimi6ctv7cqTLuZP0xkXNZUNg+CjxU7U+2zAygwzDGVzhvZUFbt4nS5znjvcd8cUZixWqgZNqA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DJARANRBJc2UkaEkkmhEVf0reyRAQNaihlM5g+C8Lu1XC2YtyVdFco91WH3RBrUpaFWLVKQ4v6XxAvi6pCQbepclM9txTJpmEYIkcQ7ESDDwxcXkuRo+IjY//OpULcJERRqzKRIbb2pt+5jPv7los3d8GNy0kgDvRTEqa4CLTMLfJgty0475WvbZIjViD4mHyDnw5Z3InYtCSyQLLDM610bPAvr5DDGpKfINEXeWqQCmBUVXUWbMxtzqWXhMtlBGZSma10+9qwkEgNwoW5x/AKj5LC3GVAsHnS0FiDzc4mbn9QnhX2+Ih1iAjIMIXFHEcYSwbi8ontib4YBXTKIbqtHROotuVS7J8jNAph/5FUfd6irAIFEGL+JOgcNz+kFO0LrHmocUzgnA6abp/oZU9YSujw3RSEt5dcYeIYx1gbwZcB2kVJdmXLABFdIZE3gauXiZqZQdj6gp+GOa6DjBRDroryHKugNjVq9T9w8GhkJjViYNdULNPXIaMr8OFmg1m+Q/Sf7/e6OLktLu3It6uHKZOWzk1MNykDX3FbXBqx1G31mO9Z0F+wfaVlrwjjswpbohJwFEiGUjbTWpmy0e5igMXzQodHtm4WbnSy/XRdkQoU0HVQ5yTG815fyPcJFD
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 228ae46b-e34a-463c-4926-08df337b885d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:37.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLO0C/UPLIyWTdOl846KkfwnZiNXjJSj5Zjb5MqG5uBDRHuWjNaBmcxvgb6xFPHzYNRTv+sbmikawLWEAkMrViHp5MGlX17wfxPorh5Y74A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

fs_info::zoned_meta_io_lock serializes the metadata writeback against
the zone write pointers and protects fs_info::active_{meta,system}_bg.
Metadata in a block group backed by conventional zones only is written
in place and in arbitrary order, so none of that applies to it.

Acquire the lock lazily instead of around the whole btree_writepages()
walk: take it on the first extent buffer that lives in an append only
block group and drop it when the walk is done. A filesystem whose
metadata is entirely on conventional zones never takes it at all.

To do so, split the block group lookup out of
btrfs_check_meta_write_pointer() into
btrfs_zoned_eb_write_is_append_only(), so btree_writepages() can decide
whether it needs the lock before writing an extent buffer.
btrfs_check_meta_write_pointer() now expects the lock to be held for
append only block groups.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 70 +++++++++++++++++++++++++++++---------------
 fs/btrfs/extent_io.h |  2 ++
 fs/btrfs/zoned.c     | 40 +++++++++++++++++--------
 fs/btrfs/zoned.h     |  8 +++++
 4 files changed, 85 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b49581eeffa..9a85fd478d0c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2547,16 +2547,15 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 /*
  * On a zoned filesystem, write out the currently dirty metadata extent buffers
  * of @bg. Used to flush the active metadata/system block group before the
- * ascending-address walk in btree_writepages(), so that walk can pivot the
- * active block group away (finishing it) instead of aborting the commit; see
- * the caller for details.
+ * ascending-address walk in btree_writepages() writes its first append only
+ * extent buffer, so that walk can pivot the active block group away (finishing
+ * it) instead of aborting the commit; see lock_zoned_meta_io().
  */
-static void flush_active_meta_bg(struct address_space *mapping,
+static void flush_active_meta_bg(struct btrfs_fs_info *fs_info,
 				 struct writeback_control *wbc,
 				 struct btrfs_eb_write_context *ctx,
 				 struct btrfs_block_group *bg)
 {
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
 	unsigned long index = bg->start >> fs_info->nodesize_bits;
 	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
 	struct eb_batch batch;
@@ -2591,6 +2590,43 @@ static void flush_active_meta_bg(struct address_space *mapping,
 	}
 }
 
+static void flush_active_meta_bgs(struct btrfs_fs_info *fs_info,
+				  struct writeback_control *wbc)
+{
+	struct btrfs_eb_write_context ctx = { .wbc = wbc };
+
+	if (fs_info->active_meta_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_meta_bg);
+	if (fs_info->active_system_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_system_bg);
+
+	if (ctx.zoned_bg)
+		btrfs_put_block_group(ctx.zoned_bg);
+}
+
+/*
+ * Take fs_info::zoned_meta_io_lock once the walk in btree_writepages() hits the
+ * first extent buffer of an append only block group, and keep it for the rest
+ * of the walk. Metadata in other block groups is written in place and in any
+ * order, so it does not need the lock.
+ *
+ * When writing back for a transaction commit, flush the currently active
+ * metadata/system block group(s) first, under this same lock, so the walk can
+ * pivot the active block group instead of aborting the transaction commit with
+ * -EAGAIN.
+ */
+static void lock_zoned_meta_io(struct btrfs_fs_info *fs_info,
+			       struct btrfs_eb_write_context *ctx)
+{
+	struct writeback_control *wbc = ctx->wbc;
+
+	mutex_lock(&fs_info->zoned_meta_io_lock);
+	ctx->meta_io_locked = true;
+
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
+		flush_active_meta_bgs(fs_info, wbc);
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
@@ -2625,23 +2661,6 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
-	btrfs_zoned_meta_io_lock(fs_info);
-
-	/*
-	 * On a zoned filesystem, flush the currently active metadata/system
-	 * block group(s) first, under this same lock, so the ascending-address
-	 * walk below can pivot the active block group instead of aborting the
-	 * transaction commit with -EAGAIN.
-	 */
-	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
-	    !wbc->for_sync) {
-		if (fs_info->active_meta_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_meta_bg);
-		if (fs_info->active_system_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_system_bg);
-	}
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		buffer_tree_tag_for_writeback(fs_info, index, end);
@@ -2652,6 +2671,10 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		while ((eb = eb_batch_next(&batch)) != NULL) {
 			ctx.eb = eb;
 
+			if (!ctx.meta_io_locked &&
+			    btrfs_zoned_eb_write_is_append_only(fs_info, &ctx))
+				lock_zoned_meta_io(fs_info, &ctx);
+
 			ret = write_meta_extent_buffer(&ctx, wbc);
 			if (ret == -EBUSY) {
 				ret = 0;
@@ -2684,7 +2707,8 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 
 	if (ctx.zoned_bg)
 		btrfs_put_block_group(ctx.zoned_bg);
-	btrfs_zoned_meta_io_unlock(fs_info);
+	if (ctx.meta_io_locked)
+		mutex_unlock(&fs_info->zoned_meta_io_lock);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d8dd2ae9ff9a..c73953a2e8d3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -143,6 +143,8 @@ struct btrfs_eb_write_context {
 	struct extent_buffer *eb;
 	/* Block group @eb resides in. Only used for zoned mode. */
 	struct btrfs_block_group *zoned_bg;
+	/* Is fs_info::zoned_meta_io_lock held for this writeback? */
+	bool meta_io_locked;
 };
 
 static inline unsigned long offset_in_eb_folio(const struct extent_buffer *eb,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a78f1f4c7dcc..42c9b120cd0e 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2262,22 +2262,17 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 }
 
 /*
- * Check if @ctx->eb is aligned to the write pointer.
- *
- * Return:
- *   0:        @ctx->eb is at the write pointer. You can write it.
- *   -EAGAIN:  There is a hole. The caller should handle the case.
- *   -EBUSY:   There is a hole, but the caller can just bail out.
+ * Look up the block group of @ctx->eb, cache it in @ctx->zoned_bg and return
+ * whether @ctx->eb has to be written in write pointer order.
  */
-int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
-				   struct btrfs_eb_write_context *ctx)
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx)
 {
-	const struct writeback_control *wbc = ctx->wbc;
 	const struct extent_buffer *eb = ctx->eb;
 	struct btrfs_block_group *block_group = ctx->zoned_bg;
 
 	if (!btrfs_is_zoned(fs_info))
-		return 0;
+		return false;
 
 	if (block_group) {
 		if (block_group->start > eb->start ||
@@ -2291,13 +2286,34 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	if (!block_group) {
 		block_group = btrfs_lookup_block_group(fs_info, eb->start);
 		if (!block_group)
-			return 0;
+			return false;
 		ctx->zoned_bg = block_group;
 	}
 
-	if (!btrfs_zoned_bg_is_append_only(block_group))
+	return btrfs_zoned_bg_is_append_only(block_group);
+}
+
+/*
+ * Check if @ctx->eb is aligned to the write pointer.
+ *
+ * Return:
+ *   0:        @ctx->eb is at the write pointer. You can write it.
+ *   -EAGAIN:  There is a hole. The caller should handle the case.
+ *   -EBUSY:   There is a hole, but the caller can just bail out.
+ */
+int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
+				   struct btrfs_eb_write_context *ctx)
+{
+	const struct writeback_control *wbc = ctx->wbc;
+	const struct extent_buffer *eb = ctx->eb;
+	struct btrfs_block_group *block_group;
+
+	if (!btrfs_zoned_eb_write_is_append_only(fs_info, ctx))
 		return 0;
 
+	block_group = ctx->zoned_bg;
+	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 3a2ca8bd68e5..f9dbab976a92 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,8 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx);
 bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
@@ -216,6 +218,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+						       struct btrfs_eb_write_context *ctx)
+{
+	return false;
+}
+
 static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
 						   u64 logical)
 {
-- 
2.56.0

