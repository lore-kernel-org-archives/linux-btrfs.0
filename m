Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211708;
	b=3g2CdW7vqj+7O7j83oo8/kVBZe9v3HaxmLgs4F7aEx/oJecb2SBm7Th/IgtmZw9j2aJg
	 m7TVz0E+o+oLkSp8ZIDwhhsTHW/KuipfhKFoqwzWOsSAc6GdzJ8XlISSoj5jiP0W8qgTB
	 pJqvEARTSzTF5kqA516H8mAgFtZIHsUieREEhylZnQhoMBsVRklVyWWav88pdApBOgTWb
	 ah/Ln6Lf+hEJy5Bt6856KI06hc1SpaDSUKACFhQmZFu6LFcZteVFMb8G9U2HaafsoIWQs
	 Wf79p0hfpnK25GRIbEETi3J40p7xuaVOTgBIWq4Tw2cC2GdLR3trGJanSlsCxTn6L7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211708;
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
	bh=i/xfG4hcr7fmzc92G7H8hZbNulOIC22oeAemrVUhjps=;
	b=1NQDKsfziHQkb3p5Aeg3hebV/hHw3WnvzhikyrPd5C9dX+lB1qkf2gWfLp4CQLxMRTlH
	 be9iS6yvzG0S98WFEQ6NQDp2PmHpEVcKXBxMefNcb0pw1oBQHuSXs7tKA8MMt5yoUUNog
	 pDoiirlCBhP0g8GaNOiunl3/OEleB2VvA5neP8PI7JlUStlHcV2gxcC9NuO0tR0q3pwTZ
	 N4iD9mWWpFlKyW9/9RHqGpWGf3V5VyMNxoPwj3BxczWoIpJwOzeSrt06Mv7Z5RiYTBrQY
	 8Mb6UhA50T8f6UXiNPHizrO2Ci722ONT4tV8gpCGV2zPmpyfmDYbYu/7Q+vRFkOx7pQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=hwnF+Z1Z;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YobwfSCw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC1A60A2605
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DC1A60A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=hwnF+Z1Z;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YobwfSCw
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211708; x=1824747708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=IZzyHHJILAWV/TRgyxGCki/Q+MemZ2ms1EUqmrYFSw4=;
  b=hwnF+Z1ZAqMo+d9dU1di1vsd3TKLOSsSJ/p+0txdf7x9lD8ox7aAHynf
   3mP03ncW5GLKPv4yo/la5QW9cEnhdAIbIJVsffrJ9LrINX1/cq8YzICgK
   7C7p7sI9bxyBIPS02ai4smLIzyI4zzNXzCb65OZwucxG+nVQwAmnEFlPV
   mflRYN+jFqRJcO4CIAjf4BAOzMUGFUCyIQFhxD9/x/x4n89hob5dVrNZT
   PpHDiA/egyeaYdRXUhaV4sscG6ogagxcFosPBvIbI7cnZiAzATuoQmO0m
   U2PWlj/KVm89dt+jkON+5Ml2Uc2ecwFp57JF0UaopNHJySIl2oRzCRm/J
   Q==;
X-CSE-ConnectionGUID: RDlFVWtbT+a+OO+8YN+wFw==
X-CSE-MsgGUID: m3j42+7DQlWh0AjMJhyrIg==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194175"
Received: from mail-eastus2azon11010059.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gmL/xnNcGAbtYg/DyCi4bS9dzxSPUVqMAdptSWeWu2XEjvSNWbi7fbzP3d6XZGxZdjUDcDoyyhoQSrWZIxjbDSp0MqRjjnfGVQaDcIkhwc33B0go5U3XfhgAxA1Jr7s9TcGNXD80EX4dFVT+1303Vq7i+XZamJlAEdL0uvtdV2V4ip9/j97cBQEmnQyyhNb3QemPDfj3NybqXN8Ok8/yEkb6FLvIVmbOw4gnMkrqQhKzxGAP3raFj3IhQw8eSx/fGrOz9pqDycKu+xRRHyXS3k3YpbfFDYAm5yiwgQdz2SBdqUnVH6Sk5m3+KL+rGM800z6oZSdLEVbjJoZIwhReMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/xfG4hcr7fmzc92G7H8hZbNulOIC22oeAemrVUhjps=;
 b=xr2eUp/YkbFySGdMWkyUa+fBe2ScVvsfUi/1lsES4/bUpSet7t3X2u/cN5YVBEKrYbIUarmJXubTYYjOf3P1YULjlDHqZk8IwNDijWvWpjb2SOQgLmH5Uc5XZnfwtmsqb0Uh/PT8HvBJ96ikCWPjpSbpY+zSA0dROBjpK3zsrArfQF56GrzUQ2esjrB6L+YQGeSxbOqMtUtgR4fu8WRxHpGI/VAfbmY0E9+cPmen4r3d8dxe7EWWtNJWkXd/uDdDG+5YTExmic1VAzGVGelSj7Za+aJlwTYsa5gQHuLjbxQlIH453vdm0wE980k9IOW8c1Sr7TbbrOdfg6xHDFizSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/xfG4hcr7fmzc92G7H8hZbNulOIC22oeAemrVUhjps=;
 b=YobwfSCwSASqnboUHFwAwkATx1erStjgvyTAiWcz8RTLuizdJmr0pS7O+CpScV/9lbTlKJarx71whyfO0B9hUGmsweweIrQhGeLTJPjjJw5i1jyxhY5E0HnyF2/3IrsDkYYcBhWMXh7LfTFXTs6zT6rMDygXI0v0gJbTnQmbIjs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:44 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 13/25] btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
Date: Wed, 28 Oct 2026 19:20:59 +0100
Message-ID: <20261028182111.160492-14-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ea7849-469a-42f2-9dfb-08df352051b4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0u96f/iVau2c4uO/vOEMVhOQaO+qzeEwUFWL2K0E8hjtFUMk4U8se9SETbgsP1tGw2RH/pqNivSiTW9ZhGRIyS8+aYoV++TrK6jXE9oYgMYiZ6ciaFIfr7AjlZHDRF/1vW/5BrYkPznWLklI0rU8z7MKVf88qFSrQom/cESmvWBqUyIjWraxm8U8I9oX84OiLe/EAlHEQ+ciBbzWFJSKdQ8oWXflpPinFRqXURjH+W79HxHhdwctje5EuGXx1LlISNUzq+Y93LGaP3+987CiiScMLbhxrE9ZpjB/xyE0XPVqhgZj67WRQq6omcq1kUihyQkr4Of4K5sq240r9YS457tallI1pHMrNXAYqDoILNuv+iMID8XqIU0rxzIPmblafQAuYf+EHb2RZYFlAPZuDut34fbPoAFutlo2wJHA9G5mOpur2DPvm9sF/odYlmpAEIPOiAoFFoOn4+5o8PxUaRLJoiynQ7U5AnIMb31Nk84uTfRMgfgdkDnu35qvi/ZlTiVJNfCagBUZNpfz8732TXZ1VRkeGz+pMJhMWLERNUg8zKX4EiM5w85idx8krH5mfrUivwjRL/P0ED0bUIHNTXwphU35uaEUBdzC2e3EUzPw6CSDYVEz3Bdu2Sbv3xc2TLhANp61xkpk836S7r1KHwq6AZM2lweZrV40lbHI4L0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uOfI7OlDDb15+fcqQ8evPpVklsL7zK3MIDwrGovY22pbYUSk4qa+BJ6lgyyI?=
 =?us-ascii?Q?0M/y8BtPvUbsrxD2yzUth6UWY8yeolyK9NIfGP02Nsj5WYhKEmBirOJgOzv/?=
 =?us-ascii?Q?WvGjgPsgmlNJ5VbMFDl+Pmg7RQ2A7SqPj79mE+jqc1FkhxweaIhtd40GmEzX?=
 =?us-ascii?Q?KGilTmvaJNo4//BIrPoYeObc5zvkn7GU4IB6S7rj30C9h8uqRBEt9Y1lW6Xc?=
 =?us-ascii?Q?O4iCJun3bYpcfTPnPszgPQtEPsPH1Tjz762C2RenbqAPonvIFbp/pZHybORi?=
 =?us-ascii?Q?ZAFchSY8LMo3LrXecRVx01Vu0tVYwO4lJrvqqRfx/lvzX3nNUh2y2tnSQ2/8?=
 =?us-ascii?Q?e+7zZgosv+Rb4tGMkqccJWjzMK5gqI7A7UqkVJ2kcJo0AHeWRlk1XaldH0pE?=
 =?us-ascii?Q?qRHvkP5P5PxHb3Cs6ZhW06FN3cOAmmISMOBjyqEVvtqf/IVA+S6HlZK9AB3x?=
 =?us-ascii?Q?Ugceb0J7B8FW5QmrMPYg+vyM3PVQUB2J3GMrdTCjWU4hwh+AjCPFIzr44uEw?=
 =?us-ascii?Q?hvg3UPnR1iHJ+16ALCbDRQRcNSjcjWmWwQrAlboqIGTTvLqGsBFYF5sWFrOJ?=
 =?us-ascii?Q?uuAcp5ga1NKrT55Io8VgJinJ9W3z4j8Ot7itjw/Ozs1aF6oyuHHgkTyQk+CV?=
 =?us-ascii?Q?GzMABczbYPhbVql+anTFD5X5fx2A9JSBW9NHqMuGMNGb3idI+l2Xx/zqpLq6?=
 =?us-ascii?Q?vSnxa5RgdWxKkvOM1N8lqihbn7JOck2WxwfmJuv3tYdpb/X6RHgsVdyqOvL/?=
 =?us-ascii?Q?Wh6fT8NT2T7x7a6ZPQ6CB9Ti6n/q4whmbVItIPipSeETRvXPhifk8LCQHjHL?=
 =?us-ascii?Q?KpwC6BBqYcA1VpBX5LOZFXSYHXdJNyCyoliBjVznYbEkNnnpEJ1VzDWi6Ui5?=
 =?us-ascii?Q?Kb+2iv9jZYqF5qbLVSwaz9qb6gbM4GtBc3CNwfwIB8FVQ90eWsXvN2N9PMYL?=
 =?us-ascii?Q?TTEVz+H+Yz1VePtX1P6Rm2dhAGCzFaCmFwACHjdDUSa4XgNgt3EUjn3fQ0f4?=
 =?us-ascii?Q?T0OnI6/1rFzEU33qN7tvQWPW0A4NYO4Z7ZwArOCjvxbYgYkKdtn47+TO4r1q?=
 =?us-ascii?Q?vejdaflkwx2xuhowQ+gjfxCyof49qNhZWXE4dyfHSVyGSQI3KCNpjFnYgwi/?=
 =?us-ascii?Q?Qx47JOZBWnrJYi/dESUKKw+66nJ7hwfNWzzSeJgGAFqtxc69uVaYSfI0q0Yd?=
 =?us-ascii?Q?BpE5fdi3xwya1Lz0hd3kax6PVNN+bsMD/y1kYnvgKE5HHdxc2zwKrlBbN+Bo?=
 =?us-ascii?Q?ErTu7W2U47nMA2jTAVRL4wr2nhzBL01Cm2wakCDvB7eFKPobsRjGgcPg6yQH?=
 =?us-ascii?Q?JbGNGq6B4MzdI9nTOqrxt86oHsRUNk2PFdH6tB09R+nZ5qlpUmmYPealq0CJ?=
 =?us-ascii?Q?Hzj+uCUTYlmRw1O1GRPcHIOjpZRKmvOmCKlwa/Im0RHrEzd3WIxhmGZosCfv?=
 =?us-ascii?Q?MdSFHmf+2tVZaqo9rSXzmsj/aJA9JGF6WuTDhNGRRlYIv1YH3SFmApetg93X?=
 =?us-ascii?Q?MljLT5P7s75jNFFXbPytXmpR6JHDsHEjbxk9u8DyHSpSTjHyOiC+k8vtmZ/K?=
 =?us-ascii?Q?OTO7U62WR0yGIB5Kb0jbGojiCKTO6JW13PVwOdgOIEXpTOyL2cm9xIOU0/fJ?=
 =?us-ascii?Q?j4OL19g2MFdzN8s9WAEVkhQBpUv+u8Os1qouwYLD10WNjkmxWB3Ju3p7n0Hx?=
 =?us-ascii?Q?KbLRb/gxOZWatkw3smq2Lm2D9QLPd5kdykh8PVXPAvg4hxtX31oSpi+LxX5N?=
 =?us-ascii?Q?GGniY2V4xQuQw7Ve/ffisdbwZaW7GK/+HhwNDl/Ytz097ppVYXZ5NW1htVRK?=
X-MS-Exchange-AntiSpam-MessageData-1: bi2byz05bR41Hkwu+7NMIgWvhFw4FRtf08o=
X-Exchange-RoutingPolicyChecked:
	rDnA1aC2co/SMyoceRac1i/OxwrCGMkYiz19da7TYQJnIAMQlM/CuziXmt2P5QWQOS/If0yD8wgSOj/N14VPBevsmyqwM73W+8R0dZ9cu+vuT6B3XTvNhrGO9GIepgi244DaMUironJBTDq0Y5dRU0zhnoqTS2HJAMyjHQXlN5gwn+W+LlNAeggcgQXhXVMAyonJpugXHu3awfdIyJl6KIZq9ts8vyfILcF/LQL25FXNXhORwsgdeemxH9clnQfG8U/BBp0ZVmnWjPuLTsheXYX+1918Pc5V4YHFSYk1eff60qOFVjRNwkIXwUBSze7UtBsfjPeU99fPT1/QuPximQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hw8Ez2k2vZZnFNKchvzIYuXHNPfLL4cnbRsCxOFXt1TNe1ZwDilPA6uYr9R6sDKMq6fv2u5YVZt/16z2KblRIIAvwhA/uTqedfbNtLXRyblW8pZq1vNfnHA5gZ3hOeWARUNd1dZCh9Y9LjDLEOTOuw/JHaHipCHNV8Vx80CpCAWjzs6+uif+5sikKQ3U7BCg1lFCDE+mIr89glEDhxH92eFmilFtUGtFxgfNMZNVCLmxuidDyTDI+KmoaNx8lIHWAnTmMEMZfoKhiWXw+XpxfqwgpEDB6DbR8N4xQ4EG0x+pQv9NODXhBMUYu5ZvznSjZ1tzO32WkSIDDd4MyDlJH0Dquh89ZH6eS16i8WjzzDfGvNJMT8xtEO5tDSwQz+/YyW6G+CXu1IcM9FBe23vX0DiQbyUUwA/gdzYPIvlFY3HF7hZVZDG9YMwUASiaqkv1B2lwHZ4ZL9eZUa4orBTsu7wIn6YmoDZJU03avBLsFJ7uUdMvZKLYvE2HCUJ//nocfT9B+Y/T51JCpM8aJEsF4LkEJ1BAT1FO9pgc2wuigyoqaNf4WOzJ56B7FvY6pL+J/Is0Jm1mxY0f8XvP+HULGuwnEpo18eMvEwfVDithrvyzkLs5AwwnZ8hDTMmanWth
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ea7849-469a-42f2-9dfb-08df352051b4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:43.9952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jviKH1gE0HpgwsOSTmSYzmbHa2izYH1rT7jIFeXMxkVlwkpk1QSg+rNcJ5kTIDQ9x6a4cK3CYhHlM4u1aWiIqYYofeUl1CZRf+M5x+3Ai0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

If the reclaim worker is relocating right now,
btrfs_reclaim_block_groups() bails out, because it can't either grab
the reclaim_bgs_lock or blocks on the exclusive operation.

Wait for it instead of failing the tickets while it is about to free a
zone.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d5a84fa97462..bb08294cbf9a 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -913,6 +913,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 		break;
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
+			flush_work(&fs_info->reclaim_bgs_work);
 			btrfs_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
-- 
2.56.0

