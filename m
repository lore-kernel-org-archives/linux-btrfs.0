Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795791984;
	b=m2xwNWgg8VREGF7cm1EXmxj+/IzuhDmaZVIBIrPndr1GhRQcERsSUNs+N9uSYc2yO1eX
	 /LYfcP9WYldDLkopS0X7u1TF8gx2HsdPcf6DtXiG9ynyoJxveeMb3d6EppUukEQ9l7FCc
	 RBOvGo4GCDEV7h0I/v9pXeA47d159Q3XguP4Qc8SsnpB6A+11KI4QqL8N7OwGSmVLq2C2
	 JPvNjbX2XbNMe4Yokh+vbnSw5Q7P5/zcIK5vAF/0tgmeh4RC7W9INpO7FsmI9+FB82vfQ
	 M3Q9k1ldFGkNKOprl2I4As8KjGLXiBFvJuR0m9QvdpS4hc8rl+Z4MGMXtFbq8RtL9mQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791984;
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
	bh=0w6/noWfxgJSCE59Kv9vMrAWt8mONmWpFAFy29rSIQ8=;
	b=r89Ewp3e+ynInXLz9TUAIW9nhwiYttfb7rVhk8jwN4+0JNt+eDlph3Sjk4Fu1x3yJhOc
	 T2U02ucpEWa+pFPmD9PlMdhI75sHwMTSL1dY8k3Q9yc/J+cIHsZqfhWuL5GLwx4kUFsCL
	 UQNbUcj3SVshIf4QKb6o7Nvz7+YuCNlUTxGlCEo5OIuVzsBtr5VYRJl26Wk2H4AjZX5OI
	 iCLjFBRnX9YjgozmZPOAldArPa8NOPClaZq1Njtx2p7/3NrjpgDNuntwdP6pMiSPxDtup
	 xaf+PR89jzOJsFVcV4oukbbdVBt2SKFKU3n0YsOAgsxuERaxEXVThKaBMdi9vSanOGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=h+rQxtgx;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=fKkp27CH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5B0606A337
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 15:06:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD5B0606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=h+rQxtgx;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=fKkp27CH
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795791983; x=1827327983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=IRDeuMbds0Sxg1JK/xNVlPDOPLAebapfVzf6WSlVuj0=;
  b=h+rQxtgxIg5xn1a6TWmmomjBebJDJ4RcKjw2JArWSsNIEs2VTZgFg/qN
   tqAYoV/i180OeCMwMSQFOgknLTM9WhAr2OTJ466pyCDyUjjZppPntOCzb
   J/yqrQt9EG6LdYA6aNon2KMcvEdXwGIMfFY3gDmT0duzqgWrDye84KJ0/
   DTDtq+8be1VVKaudhoTGpgsWacwmSi0Z24yVKgbQu+THWGHR8WG4INXt2
   SAbNe5BpwfOiTLhMCY1ZR0RRI7B5qjKS9YUn5eU8donI14lthzh26t43r
   D+v6GwJSB7zBVKtk5ULuLhnWfT5eP1BMl5QLuUK0iAO9FpqCd0t185+7M
   A==;
X-CSE-ConnectionGUID: TEANfbOeQiWDgFYk3FfArA==
X-CSE-MsgGUID: DG+AM8UQQf26CQZf3Lqttg==
X-IronPort-AV: E=Sophos;i="6.27,237,1786982400"; 
   d="scan'208";a="160943179"
Received: from mail-westus2azon11010021.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.21])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 23:06:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOqedcnurDuLSnj5I/3qmLlW43RgblbcRTBTbpjj8TCHz6CL/6ok5Vo0VbjmltfR0ztmdpNM2g40B6qopncqGLwTwmP8iJaC2wLRTYwZ74ghbiVMvl67GvqBLbXQDnCwgDXZ2xcD9AAzVDDZK1iyD3R5AdVaH86jKRcdXaJcIw3rSbSumC9bgrSy9MDzTpMu1Xn9r0h4XgxcE9isWGeLJLwtIk06fmt/fiSR35d0c6U0Mg63sgftLhooy12YF9V2m5ooN5KZNCdVD6bK7dmCS6RWr1Ydrw7Svh0PvZqrfJkd56hBLWz818EUCj9Op4g1+ds9Bo3v8MAWolqO6c19Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0w6/noWfxgJSCE59Kv9vMrAWt8mONmWpFAFy29rSIQ8=;
 b=gIDC90bOGXf+KVNS3xfASKKVi1wNoGvCrOT12MQ5h9EjspLFXEb3sdd1kRLupOnUlyOaTzvKFapcwxNadHuArSNBkdWPaP/r8TuuP5JlHMnM/TGn7nbIUAIVm0uI0Li/7VFGYH00Bcaj52Vzb9wEAc1gN37fwYbcp5KwL/ztp/Jkz6K/A2WD/Ddyt2cbFAdvA/1STmUjNadmzQgEYrN5x5JTUF6fOgu8H4CmFudg/i2SNifx00lRG3dZ2JRR9NZEdAiZBOcKCuOYiPyIsizRlBXaAI7bizgyZQ04Ieto/3HrU46qD87GPP0bKt+V8HWDXFsF0BijU6tf64KNGeNr7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w6/noWfxgJSCE59Kv9vMrAWt8mONmWpFAFy29rSIQ8=;
 b=fKkp27CHW3241JVeYJqmWbK4xe+HpaV21ReYv4dJ1a38cy5MEGFMCgy/G+vo7Z5fUKC+WDM9W3LPkvMGH+Iss7XQJ823vVBmHTaMHIQJtquqdBB2ckxFv8x7/c2TB4GFRSGrdd6zZPfeAmyDZSNvtPl8MvfY8LIDthF8qrlmg0g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB7960.namprd04.prod.outlook.com (2603:10b6:8:6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.10; Fri, 27 Nov 2026 15:06:21 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 15:06:21 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/5] btrfs: zoned: save last allocation as placement hint
Date: Fri, 27 Nov 2026 16:05:58 +0100
Message-ID: <20261127150601.803290-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
References: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ca6ca3b-8706-4c33-0525-08df4c97fed3
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|23010399003|19092799006|10067099003|56012099006|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
 nhumHlQfuGaE4M9v6t/iG2R8gCEjtt1D2jh157BD5+ozap1zNFNqu4C0WWncBK4/iLGX6fQT/a8qa2lxmxz3AR71xR0Hbu0g4q9s12VGLu/uP2EFJPBF8WUjwnpTkhK5pdl99wq5HDkB8I9QBlz9/GgHnI8T4cg0kvMHAJzGkn43wDGNpCDW/UioApmzAFhFszjpxf70JbDqcPh7Cq1NjRlwPk3YW3wziAWB5Sq90H6Y9RImYaYjMQSMxzlXyI4jXIIlrtYf1+rBxDzvpqvPfzCFMu20dC+WZDXUH/G+Q4yaLIy6u4K15NqSWbscGVsEBhHC428G+nJrh+juklKHO++5g/EGceHTwiglYVAonGLU3tH4XDaWvdB72Uv3wUGiQ61LAOUzpKhDIIPuVLIzRH9d2xnCA8VkbhxJMZcKBIWVQYmKYO3V1s6floYbt0McpB5N7DqHYgOJj14PE2/mHqseBrwNRIhiy3JABexh3wraOPEZzDaZBxZPKQ2/c0fKBy0ammgARUx8baceBD2LmqGCIATb324Ptw+kb5dvcfSgxO2NUVwXA40jxbAvkVLOpTESRLwPmcHynFAp9J58H03VLeLgP0zDCOK9WbcEdvQpW9w5pn8Wl0Qm1fDiPBZ9Ri3WpO06Z5aWrf6LIwc/JRGpEUe7ldMUAtqF/OfAaQ8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(23010399003)(19092799006)(10067099003)(56012099006)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?7Py/CZwwVHTUxO3Ubf6ku6zKPMEwdlJZu7V5V3v1P+JzUk1RBVqBY57R9o2k?=
 =?us-ascii?Q?5gRO4NJctlq0iTYF2EP3rUDS4yiDY/3maxY9HhdUt+qrBp6roAZLL6YparRW?=
 =?us-ascii?Q?xVvVd4NwVhq8RwMbZXxYJ0JXLPAblXozBlWe/qAohD+FXiXHqFcodHgw0kW5?=
 =?us-ascii?Q?nZQuSAa/IFPjr23dIZywzG5lMB9bqruDg5bICZoOszXoWnUDE8JZBt2ga56m?=
 =?us-ascii?Q?jYZvB4WDqZL36u8lxcvsfovTDFaodlJBvnRbucNZ1XIIrsBABD9nKbgv60Lb?=
 =?us-ascii?Q?5N3orB36KUZJ13quflm5LJYIBGpXc+TfYECV0lSZ4/srEHFVIqrRtdmXM1wS?=
 =?us-ascii?Q?CoWiMXEJLkXJ+95NFSTrf1yPyp/hu29sOScnwCqOjXUf1yCZfFWcH0d0Ur/Z?=
 =?us-ascii?Q?WulWpEEaul6jDZZVd2kgQMvaMD9aY3/NCorPkouUhuK245IyQoP69MWO6ziG?=
 =?us-ascii?Q?KHYIQacwMZLZAW+eHu44Uv9NHagASoeeSuiv432wsi4G46cTRu9Cp1zJVM3Y?=
 =?us-ascii?Q?IBQcV5adMPRGNMgn0hH2xkuuqrMajZFVwspb9Psxi9AT8j5nJAWwyaioxIBm?=
 =?us-ascii?Q?lA8TCbx5GOq+FXLjuBi9vutNrAonyc+qaFaq3XT6GXiaaoC7QC9pIhF6DiGR?=
 =?us-ascii?Q?UlgSjShFf9Q4fNXHNRGhbqA9YrglvxF8XOai958SjzQXLqJzb4gOdJ6J81Tu?=
 =?us-ascii?Q?w282Hz8f5ffwzmkIsEzfDAfXaONRTMAYkj3h+b0tKob962tR2piNdEtlZWVC?=
 =?us-ascii?Q?yprhtX1B392U+DKcPBfcpo2dSa/azFEB6Nwg0zpOxWSQvpOJfhiQPt2iAXSw?=
 =?us-ascii?Q?9c/rumw+ktSHhtjYm/HmAD0aVaK0QEL1eJ4xCJaTT/97pdrBSOLbSA8E/cSG?=
 =?us-ascii?Q?a/Fm7c0yjTJ/E/YeDwBaljf3RtgvuPduAGonlVnRblLRweJwskiUclC2+khr?=
 =?us-ascii?Q?kspL4Z2FBBtIhbAah1NRwTZkde0/O3TgAmb4Y2wO06fDpW0dhHsfQPJ6Dtcy?=
 =?us-ascii?Q?6MhKvvj4wxXDJcJCm+OQRSA0K/MCzF2bvA+8g/InUkXU7lPJ9F0x9ICIU14L?=
 =?us-ascii?Q?VCQYKVbKoeyqAR4Rs2t0vwjEvaxRxxODm/hjXdRPJ5k9zi8/Qn2/8CGunfrQ?=
 =?us-ascii?Q?KKx+VEMIZOrg/C2Bx+/byM1vqQc6c0icC0JJhScXqqX84wMmJB3BiZVIyM7M?=
 =?us-ascii?Q?2t+MD53BxNMUksvK4xhzqjzO9Ecy2Vk7/KUZBl6/IdUeKDwuO9JQR9Lm5aFc?=
 =?us-ascii?Q?n33x2YQeJrU6ECUSVi1Hqwke+IF9pSa6RYAS+gavq0NhznExQFFGhQUeVofG?=
 =?us-ascii?Q?HBb5kv/3tZPujbnNkwLtmUzmVnoHLyb+J0UxAAUlyYLfzYf0U3Mootlf4Cyu?=
 =?us-ascii?Q?07djW/ltkXfX22e2PvTjhySgxwYyv68uwQ33/x2GxFqCFOJohxq9qs9XtfLp?=
 =?us-ascii?Q?3oKfjNyKFYqondQYZqgLf407+b/6mBVVYgzkmu9f6jL8d/RS0PdpTvAcjx5F?=
 =?us-ascii?Q?zfQD/M/FZj125ICO66TKDqgUiLzTulxEOKYbJjcqEd+e1IgD5an0bWv5kZaY?=
 =?us-ascii?Q?6DYkB+aWiFIMm5gakRT9TSsXFoy7GATMgX+VQmx0XoKALoA7UzdxONJWZnaq?=
 =?us-ascii?Q?e1m27caOC3LhBjfc+N4/zzSN2iYsZMDQEXp8ymMA4kRdufikSHXg6rPG/kPr?=
 =?us-ascii?Q?71RKZTCRlZWmitkyQNFg4t1FXQ/onJJDQGPMjAcTI3W7yjw/RUgYBeu7cmbl?=
 =?us-ascii?Q?stT66h2UBB8oCEzwbtaiiNKEmcbM8qVGfqc7Gr07AyqqaludGDa8qDf/WPDz?=
X-MS-Exchange-AntiSpam-MessageData-1: lMdb3btcbTlRobT2ONIUs3aaxqZLsjolhZs=
X-Exchange-RoutingPolicyChecked:
	Xie6djeUg/07kckFR7RwzAsuFKXiF9Q/ut36NE4kcjNGvR31GhEUNdoSHIHQ5weSkC+bKgguPtjZtgWchHD9k6ntFVbXG16EU7ZIEaJC1cezV//DuXt7kl23DT0BrzKES5cp3q+swh3UZOYu1kE2ldBsxaDYqgGvDY2LOiF/X6ijGbMBNVrH9W/WIGDVIjcy96quvee4BGsNXAYmw3Y572v51CXZmmo5CN76d5VRcG/9zLSHN4TeTVesA6tDkZETiuX3h0tG6ZsIMEQ3g8VeV7mWB3mMvK+RXryIpqzB5bmjC9+HxhIVunVmGIHhnBZe7jwClwb3K/HLyTi4gqrJTw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l+0GEVE55pnHXAE1+Z1QsW8E7n1NZrt2WjELrbS5bI5Wa35PoT7fz26WxwDVT7gq3fkdgyfh6lgZqHDsFEi4q1PLcndJbb+AGowQ6NLEJbSdOvezxPjDpcDOjnHu6BqtsENH+BXXM5w0kY82gwMMdI2487cwpKgEh+OoZyFnuLq25MCjiDeyV8QLtllbG9blVS0YwoK6EVTr15EWeSk9VVhjrCTRXvhs8DOEaVuZN2Z7UtfxmVumU6GKFesj4tzOF99/M7gsdZwVxMT2RJH7X6pItVFnMclUcFbR0myvO4uqCUsGc7NUZTZ+Ox7q+GeCEPdKfnxpLZxiJYBNS7X5NSwRY/T+IUNau6d95JHeLVml27nHO9W7rZOw2mbcSgG1IDHG7NB6RC5qRu1sHAF/Xtc59bBg912kTzpIO/i0rQUQ0qFb6qIAmqpGfaY60M4xh7KCJKfAQE7cTw3OZzWnPeOIWFmjX+GLqjV+Cv3JXw+PtNEf5b2LwJO85FdN0mJVX82194rfY5jqxcYSPTQ+4vKIk+eR6yO0Tw69ZilOmjFRPBnQ9eJ1ZuhYSsrXsaIHpgonRszXlzY0/AZMikQlYyFZNZsqakbsDKMlTjzVpHlqVe4htRFB4QoIfwKknQfm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca6ca3b-8706-4c33-0525-08df4c97fed3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 15:06:20.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJHM4w2ps2JxYAKGOQe323g/tTiHHOQB1TzNh4JmRu78sV2ggg+pL7HUR6dMnkoUMWwsMTxHHlLmhX/MKtR+agPCsGMITQZrALNLs1fpx1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7960

Save the last allocation of a data extent in the inode and if set use it
as a placement hint for a subsequent extent allocation in the extent
allocator.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/btrfs_inode.h  | 2 ++
 fs/btrfs/inode.c        | 5 +++++
 fs/btrfs/ordered-data.c | 7 +++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ec1b57d95af4..c9893a1e433b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -342,6 +342,8 @@ struct btrfs_inode {
 	struct rw_semaphore i_mmap_lock;
 
 	struct inode vfs_inode;
+
+	u64 last_alloc;
 };
 
 static inline u64 btrfs_get_first_dir_index_to_log(const struct btrfs_inode *inode)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40dd87276cc9..402bbba0b11a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1142,6 +1142,10 @@ u64 btrfs_get_extent_allocation_hint(struct btrfs_inode *inode, u64 start,
 	struct extent_map_tree *em_tree = &inode->extent_tree;
 	struct extent_map *em;
 	u64 alloc_hint = 0;
+	u64 last_alloc = READ_ONCE(inode->last_alloc);
+
+	if (btrfs_is_zoned(inode->root->fs_info) && last_alloc)
+		return last_alloc;
 
 	read_lock(&em_tree->lock);
 	em = btrfs_search_extent_mapping(em_tree, start, num_bytes);
@@ -8038,6 +8042,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->new_delalloc_bytes = 0;
 	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
+	ei->last_alloc = 0;
 	ei->flags = 0;
 	ei->ro_flags = 0;
 	/*
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 728e73baf15e..ec8ca1ee7967 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -317,14 +317,14 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 	 * So here we always pass 0 as offset for NOCOW/PREALLOC ordered extents,
 	 * or btrfs_split_ordered_extent() cannot handle it correctly.
 	 */
-	if (flags & ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)))
+	if (flags & ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC))) {
 		entry = alloc_ordered_extent(inode, file_offset,
 					     file_extent->num_bytes,
 					     file_extent->num_bytes,
 					     file_extent->disk_bytenr + file_extent->offset,
 					     file_extent->num_bytes, 0, flags,
 					     file_extent->compression);
-	else
+	} else {
 		entry = alloc_ordered_extent(inode, file_offset,
 					     file_extent->num_bytes,
 					     file_extent->ram_bytes,
@@ -332,6 +332,9 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 					     file_extent->disk_num_bytes,
 					     file_extent->offset, flags,
 					     file_extent->compression);
+		WRITE_ONCE(inode->last_alloc,
+			file_extent->disk_bytenr + file_extent->disk_num_bytes - 1);
+	}
 	if (!IS_ERR(entry))
 		insert_ordered_extent(entry);
 	return entry;
-- 
2.56.1

