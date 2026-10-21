Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590127;
	b=uwbocANUfURSmdAYOHiIkbUtDGet6qa0O2E6sJ9rHVzIOtDQrfxbTiPGksmZZSTMjzoI
	 l49YhqBbYspRO+Xsx/5JHMW9aNV208M17Wjl3fI4/YUzcjpNfnDqqI2DD5gyf60/s+4rv
	 kPtoP7kc5GzoliuTYF9/hLcOxE94Xcj4/sEZnIaTzmRpYGwUjHd+cJCxmRBhVfOXFZtH5
	 thMkkuK9F1Z/qBh2X6VrFiYF/9o1qrNeqPZcIJN3AVadUh/xsPNyYqeU0g7/l9pKNiQNL
	 Fdl4rkgA7SjiVpEaazDE1u54I9ng9Nm2ZNL4WVslU5vE3uVkB3T0Tz3eX2aV1jyXysQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590127;
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
	bh=lHabdiUdcWUlRyvNTpi9pFYiIueWEjE51HS9LdBbGUs=;
	b=MkybfN/vBmPMnvd5X2/dO6Y0uX+FtDGGDsbg8+ShxizNDBXM8b6aoyax2J4aYzZ7hPp9
	 kc/zfNOnFmkrGgdSWIb5ikCMDyK3n47lIxhOsOdOlfKtGbc91kfje8Rr2Eu5atOoJSyqq
	 eBhRdaohW/IQSPbmiEk0uG1F7llbxCA/6TeeXA/v3+7D29CU8EG6H7+sUoGz+fbEZgFyw
	 sGv5TvLOJDZYe4lHDMSU/ZYDl/CQ3KBBVFfwyRE1w383ILfeWNBDjAwzYPZzwZ2Xc5FJr
	 NGs6EsyjjF1K4tygL+fIWmEQQTDC6KfBur+qVudTtkijBCEkbZnOpqYLRv5BPlZPU1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=k1cHhfVG;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=JMwZHDfV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82153606A322
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82153606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=k1cHhfVG;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=JMwZHDfV
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590126; x=1824126126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+3HXV8Brn2CCgUoOyUUmfzIkLJSxGxO+p0aR+JVFpWk=;
  b=k1cHhfVGcNzbrh7s396aemtoKprQfaNCmI/vXh8jCG5Zy+k+HVjp0gbC
   WJd5gNo1TXYPCx73VsRoAYaWwr5n8i+MjxE374KroRV2obV/OPKl9sUPQ
   mKNzOdaYPpCYJXUO2Eqv/VYCSluhddCdj0izULomwTwAGbDhqTBW+eXLU
   tdJbc3DZpVIloYiL3xgWKV5pHjIEk1ZpvlgVd2mKsw8w9WceCpqWFTAQA
   KGlUMkGgjg3Z6gPLCIFcpI+XqGzdmeeF1j1bZhjgADThvuWffw1scunpB
   cFmwrMD1Wv2C0gkNGYx2Ewy7zS3Njd9mkC2I//s7ePMgFjdIg9fikziwS
   Q==;
X-CSE-ConnectionGUID: IA0z2EBpRfm5ryjBernFfA==
X-CSE-MsgGUID: E/4ahnyESkO1IU7oXMjwgA==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601490"
Received: from mail-southcentralusazon11011068.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IliM4g4rSw/hsVJWy7J8vLU07EwMeohExY54jR5gOILDaejBwDWDYmjaOLeC331qJhW2ucwslEqEV29cweDjWDfh8NaIj6SbzKfkM5cdWh+YHcWQRkGF4T8bB5b1kBitfYHnkjixtWEJ75ZOXQ1S9RV/MzslVaSf1oB6ht7NaVJXDJXklCrjwwjSN/NJofVZgTHWYM3nW9WkWNIX/9JPxwU8y3ebHutt8HAuavAqjOCcsmTQgUtFnk8vG8YFYOg4AJq/RdA7OUePSDv1uyiRKkUlyvCxW3u9B4WcxNAGq3y2KtQE8VplHlJDW4nmFaFAu2q9qiy8P6muHv3VVf8G4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHabdiUdcWUlRyvNTpi9pFYiIueWEjE51HS9LdBbGUs=;
 b=XQtKuZ/yUUmjRpFv3ROUhWLna6Ny1a/qaf+/lHui//XOi7uCMA2+Xse5x8bh0GsrozkI7BMkioWYTq1oAYPJ/4Jr8bWSG3a6Uu+QU5KkCR0DJJZgnpSciwRdxt0sJaQFxbxwb02zwCxN6GwZQvv/GHh/Ie4YLdcP+GZIQTjpd0vAuyeDgVPR20Cl6W7TvyvphIi3IT4HtcaP86TB66kIgD9axIqqcYBF/1wS4OMJfqTib3T/sunQnKN+ZwSc595rwMhtp6dA55/Lm4FdIjAGEn53PrYJ+OvZbC39ZVW9KAfa4abf4kdh18uiSfEMv7p9jzvt1t34whOZUGq8S+CSFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHabdiUdcWUlRyvNTpi9pFYiIueWEjE51HS9LdBbGUs=;
 b=JMwZHDfVAzQa5VlRXmWjAmWEdODxkmDpgWFj0XW5Ytizhde/rDpcSmsI1P6+bimqXTf/oP82TxC8cYhOSurtA6pSQOrRWQlA1SAjZAycP3fn87WGZx25DKfpsEokKwP6jAWc0RZ7dPaFG4nfHD0NX8qvnU72r9LxqVgikDIHJhY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7478.namprd04.prod.outlook.com (2603:10b6:510:4e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:55 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 08/25] btrfs: zoned: prefer conventional zones for metadata chunks
Date: Wed, 21 Oct 2026 15:41:07 +0200
Message-ID: <20261021134124.2338902-9-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7478:EE_
X-MS-Office365-Filtering-Correlation-Id: fc124e97-dcad-4b03-a486-08df2f79124c
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|10070799003|23010399003|376014|1800799024|6133799003|22082099003|18002099003|10067099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 du5gL4V7ZSCFnglJO1pM0Y+Cv0R84Zx3T1CF69MraL3VG2xx2QTJQ7qiLASREmH5dhGJmOQpiw3tAMnDzdA3JAcY8ST3iOG51ueSRxMEyRA62SqjPDX8upDsF2uftylVhx4/D/UUyFUv9Ic9FkCyPSVDrpLkDP6zzViA+UKTZYHZhsM/8pb28/tb3mbjGNagTXLRI+3dPQNluiVaWR6TFoonwRG9d1DIFRH24sqTsfpmOyQPreVTZHhTvj7ionjoAECOc764V4L+jmsM8xiOjt1ededDotfGnBYzztnlmmR/SPm4dTrWZ30Mwinv1uDiZIntKoj2d+peEXYc3vgOTMTo9ciSU2z0UsfgzarRYy+H38uIhruUkJSaYd4wsEtczMWVFstZE0CI8fub7icUpzIidfmomYbRjQCXsTKTze5U1L2esLgm74hT38VZ79wFyyMXmF8kCsrNGmWtbSKUmsUTRcCtxsqfv+o0IzH1KJZPhUkT6LkcIzvs1wKheIaO+vRR4XJcEMu1gMWtWnHRl6iIWFTsw8p/8sAYOv9/xNTCp8GBhBaxNZHxtnq0U2t6Ak0mlCS91bBJBGmxXfs3RkzsW7Zd4yUaUhRnPA8L/F0Rf8OiaYaa8QoasqE0LuaPrPtuqdr0JBmO6IkvOtjLP+6zwSfarH+eQzfRaWDch78=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(10070799003)(23010399003)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(10067099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?B/f6yVIdhVxU6jvMi6gmG8vrvzr3npnUh0gOZ+0oDtOAC9n+5CBot3f4zUt4?=
 =?us-ascii?Q?dy+rsOU4N1ng7fdVFvEyQ2Vp0PmuZ5zLMiAkmxzNZVVwwTpd9tkLv+YYbY/8?=
 =?us-ascii?Q?mBtfo6T1CyTDWkXRhnIlAskrpy/ECKi8lrABqXT9s6GOz2xQQJeDXgwu0AEI?=
 =?us-ascii?Q?XrcAS3ASbvocGPZ8SCtanPC6zr35/g+6/rSzp7HfVQnagjT4gTKhzzFc/WVC?=
 =?us-ascii?Q?rSEyERez7ChnocuFNKvxJHDqxevA0ks75Vh5BJpnwkK0TT59etIJzcZa6Il8?=
 =?us-ascii?Q?YAenWXfe8yFdjt973ulpqY6Hdlkz/6LJHMZAuZZ6nT5QmuKPFrnAVeY6apCN?=
 =?us-ascii?Q?sBPtqMGLsYbACukSlyWoG3dEebWMcbkBmjAaAeHX8RlznyVIsMrz4iw0coZw?=
 =?us-ascii?Q?styCSKuA+paE1h2ynHSD7UBq7XGquI4Uvllll5sBYfOShXJ6GllZd1HRdjqE?=
 =?us-ascii?Q?7tFOeTktroRmA4C5JIkH10DzdQ8m7VxvZjI9hk25lHh7SvqEnoAQRBjUSvbt?=
 =?us-ascii?Q?XIKC6MFm6Zv0Q2dB1BrFYSrh+IlAwWyFmn2EmK3WxDOGM/WR4JzTWhb2AIy6?=
 =?us-ascii?Q?pE3Gy76zVjmgz3H1AXTqrnn/kDTTS7ZWdWp06KkfkrtAeTPOEnKN+GciGbZb?=
 =?us-ascii?Q?u7abpMVBPcMsTEjqoE3TktBwSu0Y5/X7u4mlVpPsbLYAzQHIiIqRjCtGnPb2?=
 =?us-ascii?Q?P+T1XtfarvMCRoF9NchEhToY72WOIxhj1k/vN//CKwB9grKj4Nx4Zh1OZyf0?=
 =?us-ascii?Q?MUpE+MEuRna68TWb44AKxmK+6hnOJve1XyMtfcPvDFtRjx1u33oNZzjeyV3I?=
 =?us-ascii?Q?1IafLGpfp8k8388TVpEGqj3EyyGQpYXl9khtrFcBMoFI9NP/2NBGhPEkqG75?=
 =?us-ascii?Q?czY51vdTAD37Rbpd3RHC3VwEKg3/w2F3nxDLWAhJUQvAInXZF0vpvsyONVvZ?=
 =?us-ascii?Q?/DWclPkndW/rLRf/AsWWJ8KJLlDQfiluhAyibjqR7kKnoNliAsi1PdN58QHR?=
 =?us-ascii?Q?9H+VRziPQ08m7aorbG7wHXrtr/9PLwHDtW9PnJPpk5vA9JyQMrZW783SflDc?=
 =?us-ascii?Q?9LmoD0oYmMjGPjrOJsELDHFNQEKaxcTg5ZKuqKbexRJGemXvtIbFTszlUouc?=
 =?us-ascii?Q?K3vFU4gnKPrV5y1eTGf30hUjmssuxRtz1zn/pA1IZTsBDuHGHqMVZOtFVLoi?=
 =?us-ascii?Q?r3BEBBjttz4jX/q1pdux1FS5JJtx5LdnHCfGkx50clGky8IkU1IYRaznTkbW?=
 =?us-ascii?Q?njxs50V3YHVVPqMDrmYTYXJvlyf6AAhhVrdTmXueWT+COnRKnnM08KVtB8ee?=
 =?us-ascii?Q?o2I41HZ/7NyoMJQV8qzTD68KEVOYpXhYDehWrKYH17PEBUa8ZkKhBD1k5lg1?=
 =?us-ascii?Q?1INq5S4sIh72UJGWpht8bHFeN2GxbFSzWJ5p7egmT5MHBFHD7dlWw8motMCM?=
 =?us-ascii?Q?1aUFhlzLNs/FLaVTiOslwZZqNIrbi83PBeGwmE11fg5k3VyFVik09w2CjJDB?=
 =?us-ascii?Q?BTRZ1oPl2vL9rDv4APWz7ckEsN2EZroYdUCJ2U/cEbGJFVGrSBhNrdx7d+Rk?=
 =?us-ascii?Q?SzkqbqsvqdVeOXsWQxy1PEP3m5g0a4zOIleEQ96BdIfICF2ZU/DJ5Lqt5awn?=
 =?us-ascii?Q?pqhrOSQ46sE81VNkPhDYVYoFtLBgD8GnG4hzdWkyEAHaIblsu/DVjDOnaV60?=
 =?us-ascii?Q?UvJcFcF9OEahjVJKkJEvCS8DdSk+yJfjCbV0q8+vjtIqMjW6mQb7RaMd1Idb?=
 =?us-ascii?Q?jmjcelFQec8d3M8ImTiabWcHRFSQ+G+CQ/RYesFepSOGMDqK3UHMDeTNGPwA?=
X-MS-Exchange-AntiSpam-MessageData-1: 8IShFAT6kT9b2a2wz0sJ2moKuEmivrj0lLU=
X-Exchange-RoutingPolicyChecked:
	mVvalQJJVIDNGt8SkRM353X7j4yofeOl15KNcZhXD5pU5vVFmUx/VkDk0cTubZOHdUqwChZyr352y7BtuJDiz5ezrNFY2PLL25opTBpdyytv0q9/N/SVyRS0qHZH21sEkgSl+KY7KLMi/KDt1RN4MrwLL6rpMtQxFrs/rckCp1Ivfi2KXviQPeQfHQ4MOTP5lXhNfnwrB1luqPjFOlsaoELwn8u9asjm2MTB05KkzhaH22TjlB0wOLr8x7SXYUsZMp+IWPLYA9inC0H07WAfViJjKLDtCXW+dKWi5AZOh0i38UdL+Yn4Nzv25uT6vwGVrcRkc3mPxf/RXIi/GtTROQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hRObZlDKmNTYvqVbSluISiTV8vpKILICNvaXuU36rCt+RRY6ip5M1AJnDGJ5bwJBa+PbRuumVlIltHSyvrf6T3zp9QrY0bSbBcCDDWpe1gl3x3WKPtBQLu6juye+aIOpTpt1TqJpjRaac6ReGoIN4Tzl7AWSQaK7GJRoJd7rT4E1kKuO4+Dl+1nSpo6MSJYl7AWDQ32mrjsZomS5ulDQz+dmiexCtix3D+vJLg8+sKW7LF69ljqUyUkc+JH4U1wR47TgCHDp2GGq+IUl8KJojAsGqV6r3aRH4aNxcKz+O+GZUK8h3khanlAwzWuW98aD5wV7iMVtwSjt/mNvNK/bCxEJEZesFe9UpZd443ZNCeQBW/SqA/6G5o2YEvkROPpgN3voqQIR61p6E40xi8vSl+iJ3oSQZylIbOqlrUfMiuSWF90MFpQ5bzFLbi51NwlWtPwN4sWSfzlV4287OM71dkSu3PkXN7tZNPcrNWj6S921RRGzu/qUGUUm2Kr+S+U0eX/kLJgFfzvRKrbOk/Gu4yl0GQoLiV6NZFIwuihr4qRRntSjLUk5w7bWyHGDpUAZm95skqg0iwJCH6Sa5KIBtJ1ZPbid8KAwZwtxEBqe5P9HGd197F/HM2pr8qJ0D+Ii
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc124e97-dcad-4b03-a486-08df2f79124c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:55.6558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JS+BdV7qxkrmu2xn5/kJqoFH4GmxBdupNfOFwB2cD9N5LiILVlL4kJ8hnDzexmBeFO0JNhO0dIT1zzIssSj/Hym1PCWK67P09oC1BJnSQKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7478

On a zoned filesystem metadata and system chunks are allocated from
both conventional and sequential zones. Metadata landing on a
sequential zone has to be written append only, in strict order and with
a queue depth of one, and freed tree blocks cannot be reused until the
whole block group is reclaimed.

Try to place metadata and system chunks on conventional zones instead.
The device extent search is first run with the conventional-only
restriction. If that does not yield enough devices for the requested
allocation profile, the search is repeated over all zones, keeping the
previous behaviour as the fallback.

Skip the restricted pass if none of the allocatable devices has any
conventional zones, e.g. on ZNS SSDs, so the device extent search is not
done twice for every metadata chunk.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 41 +++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/zoned.h   | 20 ++++++++++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 825d110ea481..a0d37e19ad81 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5896,6 +5896,29 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
+						const struct alloc_chunk_ctl *ctl)
+{
+	enum btrfs_zone_filter filter;
+	struct btrfs_device *device;
+
+	if (fs_devices->chunk_alloc_policy != BTRFS_CHUNK_ALLOC_ZONED)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	filter = BTRFS_ZONE_FILTER_CONV;
+
+	/* Avoid a pointless first pass if no device has such zones at all. */
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
+		if (btrfs_dev_has_zone_type(device, filter))
+			return filter;
+	}
+
+	return BTRFS_ZONE_FILTER_NONE;
+}
+
 static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			      struct alloc_chunk_ctl *ctl,
 			      struct btrfs_device_info *devices_info)
@@ -5904,11 +5927,14 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_device *device;
 	u64 total_avail;
 	u64 dev_extent_want = ctl->dev_extent_max * ctl->dev_stripes;
+	enum btrfs_zone_filter filter = chunk_zone_filter(fs_devices, ctl);
 	int ret;
-	int ndevs = 0;
+	int ndevs;
 	u64 max_avail;
 	u64 dev_offset;
 
+again:
+	ndevs = 0;
 	/*
 	 * in the first pass through the devices list, we gather information
 	 * about the available holes on each device.
@@ -5935,7 +5961,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail, BTRFS_ZONE_FILTER_NONE);
+					   &max_avail, filter);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
@@ -5962,6 +5988,17 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 		devices_info[ndevs].dev = device;
 		++ndevs;
 	}
+
+	/*
+	 * Not enough free zones of the preferred type to satisfy the allocation
+	 * profile, fall back to searching all zones.
+	 */
+	if (filter != BTRFS_ZONE_FILTER_NONE &&
+	    rounddown(ndevs, ctl->devs_increment) < ctl->devs_min) {
+		filter = BTRFS_ZONE_FILTER_NONE;
+		goto again;
+	}
+
 	ctl->ndevs = ndevs;
 
 	/*
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 5f21a360f23f..e99786b29587 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -332,6 +332,26 @@ static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
 	return test_bit(pos >> zone_info->zone_size_shift, zone_info->seq_zones);
 }
 
+static inline bool btrfs_dev_has_zone_type(const struct btrfs_device *device,
+					   enum btrfs_zone_filter filter)
+{
+	const struct btrfs_zoned_device_info *zone_info = device->zone_info;
+
+	if (!zone_info)
+		return false;
+
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return !bitmap_full(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return !bitmap_empty(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 static inline bool btrfs_dev_is_empty_zone(struct btrfs_device *device, u64 pos)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
-- 
2.56.0

