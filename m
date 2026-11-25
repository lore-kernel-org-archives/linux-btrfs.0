Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602679;
	b=fbP9f3ILiMfkKxYfJY9MLmcmc5la8HskTE4x6Bn3xoznOTNVdc5iyqs7a34/mMrPJuNw
	 mZwsHZ4Yc2mbR1xpGBQf601LbEgrovM1q+VICJ65lPRopQLuGzqFoarpwSW7GVSEtwa+r
	 i2OiDBKVpYPGB7WuJ2V6W2O3QY0uDil/7MCKeXkpYbApE7t/Pj+5m61ou8ERg5RIFGOlp
	 pRTf6kX/C43xq6ojH4c07NfBsnPEdsShPSp0mVZAC+uC+iyC2MEhQov3IUrQdvhbuKrn8
	 o9oDOIiU2m5ZeQ6X/eaH3NNXJE4bGwdafN659Uf+RFNiJ+zPNpPXsU4ab6viXaXkK6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602679;
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
	bh=d76iY+6bZOmKrixO3qYQNnY8f/qq63A56nS9DTYlxiQ=;
	b=Rl8hWuR/5mSUfsdS3kExavNSxyXBiHvs1Pi82P7qAEOwBAtj3W+X5KZT70dKHJfaqR3G
	 xFsnWujlvAvR7QXfE3ODqmjg+f89Z8E83Fkpu7Lig28TzJfK+uWKc7KglPS2k3boN/Bvm
	 LayMRUq5z9fkJyaUySKqn6rGjEVkS2mVlixnGOzKEIaa1bGduef2sbpjH/ZmdPc5VpjR4
	 V95Zlge6vLO/N7PKogsj/j/vPA8+fVrncc/09IodG2H1z1FSENi+szTYq9fDtglM3ZaCM
	 8c+fRICr3V1dZNl05jvIuLeGbUE202eNMbIHljaHDClgLoYuDEUHisVTjBMBCaKxM6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lEN+EyjR;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HORIbOgd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B92606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:31:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80B92606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lEN+EyjR;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HORIbOgd
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602678; x=1827138678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Y+IiZuLpfOVIfqynBgiKdPVpZ3P/mMPm7QrAuF803GI=;
  b=lEN+EyjR2YhvHdQQCpPz/o9XN7O6iaTQVO/Bf5l6k3LQy2MP89ThoW/9
   +sq6sx8+HHPfUeHOGEJdAAlaqiHN1Dz/AWdFmyWrjulvZvQ6VNgznPcjw
   LlomwPU0n1jUVhMk+F9R2lpfJWmjzaDRMaFGUB8aCaVpaOlffdn77iHAs
   avOb8dRMY358I/8YP/hw8DIb5u8FfDZUHbs6ahMGUdMvDuErmE/QCNfGh
   HeMHMHT89k+l7EHWZVw/VCLd1iJI21x1wXeUQWhJMwmXGgj4/3DSlN6tg
   CTZsPtuGXXYWnUqVxjS8wfrw230bII0WYpdkowQjdbU7NZEic6UkbSjXQ
   A==;
X-CSE-ConnectionGUID: m+cSvoStRUqknNkcyBms/w==
X-CSE-MsgGUID: ANfHZcUtRCuh/0L80cBSig==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492470"
Received: from mail-southcentralusazon11013032.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:31:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aE+kKCj1IfwAD+qGaKh2RYyme7ex9Nyp7ty8W0gOR8Fsdd96Kwsk/n1NdMQfdldXTd0fxDOFLszxS0uZiMmw+MgziLKe07c6lGi9rHcjBcbqeQXXjrCJv/NBp5pTX3E3/05HyemnSEUguK9B6f7y0CbgfjTDwUxCgDW5ad2ll5zjbnC9IVzb4AAlw7U2CWZ0j9iZ6p525cWJDDIjrV469gsJ6xBNzzQE0WdEccjSSZAEfvi/KNfswCyFfeevDlXPkgeL+jdnV4O04ZN/mwTKXZualdufrVt70LZucueHcLSwO1GAAh12fOglE/z8IaZ8FZP5DxhcJ9sArPpQPQTS0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d76iY+6bZOmKrixO3qYQNnY8f/qq63A56nS9DTYlxiQ=;
 b=aCu5f1UtJfdTkZFBTBXtKj3cAUfuai/UhCkiARqci4iYXh9VjFuSi+rmRVSyEFpe5g68xihX2+LjtyevUO9jWJiFkE/w1cHC5XS06yDRYpgOC5Kh8e818ZUsalY/ruNu76wF2/sGqTDZ6YfJnrP4GMkhzmiLTmkkk/E7Qu66YC4/s5aGTzeSSdTmWRg/qXL7Gzg+2tzttnz7byMCm5LxueWgOpi/SwFC6QL1JuWuj2oRRAYl03T7gYIyDGFHw3yumgZ+FHeVpqU6BtW8udLdYqcjJeq6Nw9PKx2DcXLtqjo6mXhDBbTOvF4Fc6P+ZsLqiMTJyor94qzIYf0wIfSOKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d76iY+6bZOmKrixO3qYQNnY8f/qq63A56nS9DTYlxiQ=;
 b=HORIbOgdjdSWgFUrdyNNh9DRv7kPBe2yHU9ECanmUW0pK8RI6okdknGc8HVzViUXYPbazub3cE+FBMZqnWwt22QxdKrTYqwb7UkYoA3mfA1Rx2Nc2hlPadN3CuLjLJ7/NW93w3XRTVjD5hCUYW4syLowuDrUiOIpkyKvcSGt6GY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:31:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:31:15 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 26/27] btrfs: zoned: don't count the relocation zone reserve as available in statfs
Date: Wed, 25 Nov 2026 11:29:55 +0100
Message-ID: <20261125102956.266389-27-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: 38a415c9-b74b-4a0c-b904-08df4adf3be9
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|10067099003|56012099006|11063799006|261009223027099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	snPHtWiXX131nL2FVrVwOr6ig7NhRiopB1086XjU1gY4OsPIWSL3a+KIQm0M8y3zrYRd4g8aDdUgySH9z7yBAfXzBS/w3p+4BB72B+vG2VD9rjgXkvFmD12V/gbz/ft6MPkflE8t29uJH8wEbT9fR09MkNvZPBs3yF95p3BX5toDCDcYhDEUnFJoaUr0ie+7YsGCia/jzhgT3bOhZpLBL04qvYLq7IQlvmMZTOj+WasiWY1/wY4vvBh7a9tTa8aFv3BAdL/c6sYvM6iftF3Y0lAlBH5eWibQGYnWl2TzTVLDGRTMmdgjL/jw34umYU1pdUgHyFrpp2peLZxBxtlKn7tw1fluadhKQOuqtO1alLJvJIHmQM32xtrKvhuejIwOE4tZcnQQhYHihur2xR+X6dwITVGdF+fOQbW87J5OnHYEKoYupTQhPhIsnXrGhehSexBwEuTowo0YOWR+nqY+wlbH9+4E1ziRuU35kJbY6O9bcJ2a5ZFEP5pIUFONILWEh7DFUhRTlRy5viYBxrUuqFiQdMvij+thSwiawx1slpstgy7ZlFyiLA3OD/OFO09IkwwPR1BeL3p8nKSSLMrbvIZsPz8ORTSD7LR9JAU1qjeEw7AmvDrVSdtPZEOKsxljzSdj1ICVIc96HeIrb692Wvp1xdvkB5Xv+1Ru6aUcZf8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(10067099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zD5MRzWiPsrAHUrXjg2HWaW5ETGOXoqEANxArWa6CjRxOOcnTLrObZ5mz97x?=
 =?us-ascii?Q?IBAT9p3cCnnb8Xm78833M3xnfsb+xynn3FjArdOsMLTjysmziX4WtOgX/gt5?=
 =?us-ascii?Q?qLDArZr6Ao4/AqAf2AJdbsPVmQSmQnRYHlQ/tgMytltdmaY7jihMvxDZ/WNQ?=
 =?us-ascii?Q?cQjBsqjRFwvTa0eNXP1ZL2k+E7F+kXzhvPtKUkDgwF7zIcrejpvnPVBxaE6x?=
 =?us-ascii?Q?GobrTm4qn8ued7iP4bVWgioqV/U5zzh+AsCfE+F4oXr9eEX0vIM3bJL6mRb3?=
 =?us-ascii?Q?Ou6J5Y3CY4u8vZdpJL357ZnczvVxlloOD3FRZSv1hYejRnYabjn/Z5AzioLV?=
 =?us-ascii?Q?k6gb9wECBkC5EHUKZdZN0C7+giGynrzHetNkWNuQ6zarU95tG8qxDJoQw2Jk?=
 =?us-ascii?Q?vQKMyyB2bbM4k1bAJ1AjvQVWfBt6Ha5IMnubwpQeoRnZrqOqOxbMpBdAMQdX?=
 =?us-ascii?Q?aZoBZVpU/latqqm0e6rj8wDfvKvdhPM8zd+E0Hb+HXPCazrXrLdWuGcykWFb?=
 =?us-ascii?Q?YAPhLH6RkRuPyI5LIY4nuaCY5q7BMzjb7ouhrjSZidhzyYPfOIe/fGN5Xy9H?=
 =?us-ascii?Q?v7aEhf1O/J9nnz5eUhl/JHc867XcP4ZymiieFG1YjYK6FHUODthH7CWUQZDX?=
 =?us-ascii?Q?BOQSYjr1q7JSU3+If3bcgMltJVmjj0zbzMvJWZ1d2KPICqmc2lcPjBah71Jz?=
 =?us-ascii?Q?eihZU8qHDbZRrKM5IPfnPUL8dBU8uBl+A2PP8kvoVDyr3vsVUJtVndvSrTuA?=
 =?us-ascii?Q?+NlHbWgf8TflbrTnc3EKL+2cUQMqSHFTeLgbiZs5aGRPh/uZU7rngriHb/DT?=
 =?us-ascii?Q?cw/vUugj1SispQiKR3A3009x7JRQu8aOrRHPdqJyosbK+Ouxtqx97hnn21rF?=
 =?us-ascii?Q?075iauWlZThvkq2jtuNGmqbbUEHnxXvfgyA87B6MR4M4Y/socYw6P6lrNeax?=
 =?us-ascii?Q?r+H/uQzB6S2SM46NDlQ067B47wB5j33AjIjIoigxMmR+nquA2Po4xQ4kQ2uw?=
 =?us-ascii?Q?k+U6ISqedPreRf0lseZxW1NSR8qjVK/377t3EPePDomdgp3ksRVNXS0MY4zR?=
 =?us-ascii?Q?xFblT6GgtWm1Q3/VJkkBgMYmQpibfwokWz5LXve5lHcNW13mool/ptpi4oSL?=
 =?us-ascii?Q?wv5FVpNqgoOqHiwSlWIYCzL5OVUZ6XiQFKvL1H22XSATpD5YvUxM0Q2WvIiy?=
 =?us-ascii?Q?7NLfbSvUSxGnTZ94imPU5MXaAjcFJAtxaRwxq0eWuSeam1srfDpzrs+/vC4R?=
 =?us-ascii?Q?BQ543Yb0b8qIWnDo3eJ//IkoSVduN8Er52pzlRI+w78Z1OcRDFtu6PXzh04e?=
 =?us-ascii?Q?YGHkuLQhACgw+TQnYdESbPSW42XDF8yyqto/UnKVKFmDnlY2SITL8nfoZqy0?=
 =?us-ascii?Q?RiS2UdLX87S8hkRYRRhHAJVydHG4J+SJcKzc/u3viVTQ4D1sEmFfH00nMI+o?=
 =?us-ascii?Q?Yn7QHrdMlwOTp5seI0HQ8q7lxUZA4Noj3/Yni6mZNsFWMvRoDjwp74cHcwca?=
 =?us-ascii?Q?GVAq/ofgEuZ2Z8fv1f3cexiHyArzElxZjUOjj+hf0ojE31au0b41/n/vRuP3?=
 =?us-ascii?Q?ia4y9asWZb7WY3sxFw4ecuhW1s+24YOpMmoTHqmGu57v5lHupVD+qXayZ1H6?=
 =?us-ascii?Q?G/lZEMnOVl+wIGbeYTooqPYUowC1ox70/fQga/xBirW76Q+1Pg3erLxTfuvh?=
 =?us-ascii?Q?KoqoM5XOX51yrV/HVVgANhTP2F4MMwPd/gcFQxDmCGV31UBTuMl+7zP1QO6D?=
 =?us-ascii?Q?40I85gBhhccN62IneFvY6rxM71oBLLDaGysInFYBno4G0LEiGptonIQoOezL?=
X-MS-Exchange-AntiSpam-MessageData-1: ynJ+mnVNfFo5+5NsuXv80cuv8psecdJRHQs=
X-Exchange-RoutingPolicyChecked:
	eATkk3c+gkTBevogf0SuLm9TVpYyqhlaIf+eMzL8FWDSTNtv6x3IfgmoCGh0O93Sr+Ro1Sf9rvYjVjZ9yCGD3a7jSIv58LOklzXpQ2SNu8sG5D4FSPDg5YOBUXAYx8OVBE3P0TaSPusDvPYTwz60AcJMgZHvbUjSMrqsCfBZ8W18tS8LK4fx/5NAhJXlBIZ+3CT9OKCLrbMCJtUFcswzWaTgfBD0dIl7PbWTv5JhtoJtRWKg/eufb5CctmiAUsm+bC9JlL5A4kzaqVFMthxa+nYKMEt93eBAvT3PMM+yOO1YLL7IM7idYo4bJWZqbCQZjgBiqAzKsYL4UfEebio6qA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5vEY31NlAlU7iwhvOaaClWdHt801/dWTjQmrGnQiNOZfS6IxQKp5HSz9rTxqEFL7lWd74N0SfcSFy6vijk3hphSc38E9DBfTeyrBfS7uJlEmpAxY2ZlgbzkqSECUFcmDH+Z8LekgKTm/SOB3wgGSFpsb8TRhilXWbE3A81Gm6opVrEA0wqvIH6d6TsC1EIjseLKno2GMS1NWrQkkbbkkNoxbYPVeB7kf7qQrWuqoVdjA8Qw8GYARAZVGtgmSEBUBSVHRswZNk7N7awdK4x55C2HvkijTaerGqgmFxOV0/aWwBsUI6USJAOALjrZcfcpdpTtnnOPchiI4dGK6TUOSXCpFF//kKA4eUfENBR8Di5QfeK8GgaGOKFEVAwb4MMpQq6F1TbDbSIMlt7dSGrHlqTF8Rv8ptVGnFgaWjTwFWP/JQtMHPUr5ePUL3r2J29p2odUtp2Kv5VlQLsSe9QJcYAuJJR6qxRsdXWp0WaNhr396+QdC0ntkrhHMUdDxdlM4vogwqX3xtmNp8tJGVQ/BV7EHaNKpu7wWGDLpyWWS34cafyCy6QzwpZPEWGN3axM+x/Nd+jVZsjuBkAp9LXqohP/EaeQ4RZczA8ikNb1MqToNPixiKeUMteGZdyUwoXOy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a415c9-b74b-4a0c-b904-08df4adf3be9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:31:15.5579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWujPoUJeYIAfyGahKPd2DLXCBpovCbXwhbVDBQbTzMHmWiB+mP87immLaFeNb9RqVf25GVxSBHE+5lFTDUTF11enNqF0UBs74xfU4AtsSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

Don't account the space reserved as a relocation target as user
available space in btrfs_statfs().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 36d352e4116e..e21c5748c6c9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1734,6 +1734,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u32 bits = fs_info->sectorsize_bits;
 	__be32 *fsid;
 	unsigned factor = 1;
+	u64 data_alloc_profile = btrfs_data_alloc_profile(fs_info);
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
@@ -1793,6 +1794,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ret = btrfs_calc_avail_data_space(fs_info, &total_free_data);
 	if (ret)
 		return ret;
+
+	if (btrfs_is_zoned(fs_info))
+		total_free_data -= min(total_free_data, fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, data_alloc_profile));
+
 	buf->f_bavail += div_u64(total_free_data, factor);
 	buf->f_bavail = buf->f_bavail >> bits;
 
-- 
2.56.1

