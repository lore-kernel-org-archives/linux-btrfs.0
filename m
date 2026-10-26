Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031024;
	b=f9sKpBSfYoyZ6q5UKzqA6eB4BpwuPPChKfPREZJKM5sIMs328p1L7XndCSJH7lo+aV8f
	 ItsqhTn5KzkTVyeotr0ub5d6GHLdlBfYrmKHiaggiTtLbNodlaYlW1Ihm5h+3DWrELsYj
	 5YSI8YYsEyMNT0Pokvqkc3Fd8uEQdufKkiEx1mgVEgorgXrZqDzOabgybvcQjoe8rN/Wo
	 Ek0bOrmZ30pxNIrbLLgmviuCqLOEGnhkCYE0Ru6P1d8Y0M5TMuw8ks8IOa7fW1nzHifMY
	 veTVeB9lCuVq2GflRpHrei9ERIYdHFKtLYz9bcSiiaRyqm0+7IODYRcl9crtPzUHrZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031024;
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
	bh=CNQ7AxIbx2qmEiTZTOHxaEmnrV9DSmeWs9GFrmnTJaM=;
	b=i6xtiLWnZkcigERDVNCvkjiLeOlpf3wrI8NvUw1uDOJ4zp8rf/MQwD6c9SvoIM/qoACV
	 In8Jnn+3n2VQD+S0uVFesqOIOyboX9+H6qwUhH79yZIjLlxb6LwWH+LcuLfpQpVVeU7YD
	 CNDiynHmeJ5zEIz963/dW+RAW2A6hTZV5Pk5Xi0ebsKtCafBexlmqLZnHjSCvIwWdUIXd
	 aFnN0JT57s0QXe+ydClGBgbsecS8HuDTeWW14Ck/0loTkumrvRT1wMsBpwgFEN4/D9vfY
	 SrsFovIz1RiSdGWowqx937hZNAuhfe4TD8cwIAe9zlTr7nKn9UnXPzhi6GDbVi8Jb8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="qiueIUH/";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=bLzC4WSz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB8E606A325
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EB8E606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qiueIUH/;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=bLzC4WSz
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031024; x=1824567024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=5g6qcIPJJZE4Dm91Sa/X6wmg1aL4KpeJxzfvckrTjbw=;
  b=qiueIUH/4ZBUEcXoOoAxmhWFV3L507XmlXudeFPRxV8kZp6j46vtNauV
   JR/C3s7X1zhYnR0+yBX9QU/wpsdQRKKlXHvCLHeexsAXMWnkz89yXeFwq
   2dsOVTDz1+fFpbuBTgSP3qlSBuztersA5Ar4/x1w6a/4mJ+OnKkzTVlJI
   UKAs9/amHiYSov8hhZSe7vDkNBcMSJ7L9NDrc+mwkK+jNVHU9Z4aTasP2
   AtjcOdW6X+FoSoGihEvewlvEnJDq3lTYARoamSRRKOdbmASMbCysgolQd
   TKvINrSF7T4zYwG2Bgt+UXhGZRHSpHizAaz7UhWF6hw+ZtI2Dr82pBQiX
   w==;
X-CSE-ConnectionGUID: E5o0QwVDTuSl2Q51qR4FUw==
X-CSE-MsgGUID: UZzxl41PRoimUDMRkMLa6Q==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158929287"
Received: from mail-westcentralusazon11010070.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V/aaUCo2Q6XpOWfiaKUE9ua3sd3eUCTbPm08avBRIddPOWYHwtmnRuUJ97LSQGtdiCs+QZbMtCGNgF8P93oREFJm6GskWPfF1ar/Mp2zgp86G5cYIQ7A4tTrovROHMbffl6gBht+nP7/bPQLLP6uiEybHe0g1ZfxuY0I9jnKrRDuHEzzrS8GnrqIaEoqM+5CLdvzFGxj7hgjE10V++R+airoZnYOSFZ53UZPiA00QXwoBmO4CGlojtgpR2jNCCvkAGIoKoUItkP4gJoOWSItmBYAWbbISSqVxG2piFzUuYkQUCAqqDctWvqPtKItt6cCfNaaCTo8xu1WB5R1ML/njA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNQ7AxIbx2qmEiTZTOHxaEmnrV9DSmeWs9GFrmnTJaM=;
 b=mlU2vRzEW2YT35ZUzTN1EgQw+2Ojb7uKqhrpAlqDbkFh9T2v1dfOa/h1rfwcYSo6oqWXr6xkJ2YX5CE/cCNPVD2+fwcrxjrBbrghcGn8b1LkP0X7Pp3089PVJNw/YT+q0Mw1mNx9I1o8qabasNyLFsQ0fn/QVi5pVMlhiDkA4EMB6DIPr6632kakVkZIX0bQGEGHpWvF2w0fU6PqR/BNzqq52Llc2FWMLxX44LP5vWn+LTyRVMqjkrOxkeW0rhv3EEoSOdAjg/s2hV0tqwQrMukrjxmsk+kvMGAoLA1KsCScYOrf1zPKQnNuIeiCMHwDvp9K4bqmV79++nixLURwpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNQ7AxIbx2qmEiTZTOHxaEmnrV9DSmeWs9GFrmnTJaM=;
 b=bLzC4WSz6KOaksAodBZQpJ1ugYgR7Z1MQ5nTWM7/olqOSmx1l93pIGAAUer4ajPy8p94heyDDhWR+q6pmefOgWHHwu/iv1gt+9tdBah9YXpRvpXpCGU4f/33ytqTdRbVsaGqI2cmK0Y74CI1W5xd1BTsl6rWyHdLMPh6btj8jlQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:10:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:10:00 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 23/25] btrfs: zoned: keep a zone free for relocation when allocating data chunks
Date: Mon, 26 Oct 2026 17:09:11 +0100
Message-ID: <20261026160913.207909-24-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 25d265b9-ef92-46dc-5959-08df337b9627
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CdAWLSC3FqSSCaGBJm4ssY6o2GwGj/ysZ80d4ic53wuRtXmL1IyjbFFhegH1q0I5BqV74wGRxaBmwp7a54gdEmsFOsACsQuUbo1dZSxg6f7svt3CJHPU6831cZrcjjXuVDZxpNC12UyKzXsSVgxmMRo1pdcHxco0Fju6UdSTrT3EM4krnLmWPuJPBoG/wfupoEEukoqDAgIsFmnl+xxD4iHhX8j4Uze9Wlm1cnqu+86lJjDAkUX9IhNi73CHlxz4Czqj7wsuP5Txm52TNIj9MbNvCzelXr6vmo/dnrYFTgaDZdzNTrczsx7nAcslbZ6nA98iT/bDThlG1oSZf1RyvnNOX0I6JoGrzxawPWo1RriQ6v3gh4lycvUUM+FE/UsNo1G/EwTwaEiFItPAawvZLjC4fYCtb/l5QBGcLKYHq+gPN6z68Q+iKFj1zF6sj7YG4ZsPiBxTTk6dYmeseipk8v7eWVeAiqjDVTPp4j30gCBV2Z37F4oENWbMVx6AGsIrGUoluLoJses97zUQnvM5yJhHbd89/47ktSMfeQ7t/EwEKLAQZHjLG+6anaW3vNBdZbJCwxnj3WFcW2YKoaj0fMrRt7+w7HetSbrbMzgOgx0Y/bsFf1X31eXvHvuUnydSUyWTdWPTnu1Y1+wONczqyKQqfBjOo5N5WB5phi9YpMU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8GxOFHqhZIkOJdLv44t8rFwShu65SJEbR+I+U0q3ub6c8/l7utXF8cHJwYUt?=
 =?us-ascii?Q?FkzDBRHF7/qQyVKj6brAc8l8SGa56Q+7SD6Lc3k6ORGn9+n5zSGzOQTes1Ng?=
 =?us-ascii?Q?5ihHAOtEwDH9p34k0pcQ3TOY4whKLdtwI3eod8yBlkYIWnBhfkJEtFEsuKji?=
 =?us-ascii?Q?LucIc/o2B1arJmvVdArqlhbgThPBOHncDVUgS29ucTZR3yuwz/pGZQSclHia?=
 =?us-ascii?Q?GBrz3uaIfXQpLBIykLrYyzjHt9ZVraCNKbwa0wNsc0lpedVy11FZE4q4qfUO?=
 =?us-ascii?Q?a4KrfT3UduyzgeyqZgKbIsUMjodi65qlrQAhqHPIUwK2+xYqtDkWRxh/O8Ps?=
 =?us-ascii?Q?eDdBAsvbBS1x9APClShEXWy2i135hWBfLcaXId89AcDcQ4qekpwkmg3+EubZ?=
 =?us-ascii?Q?0cxkyrfjUDPwvVfGZFiafH3ejpgtl+b9bxAeh1u4foXImFb7iZLAramPKykR?=
 =?us-ascii?Q?ETPyQmrQ4grhTJnZ5Z+kqwZFhcScVHOb4sMOSiFcbjJ5dp4X8fy2k3tlvdTu?=
 =?us-ascii?Q?0j1mi1dQYJcux08NHPnuYX592RmRKmg9ENHKU98JngQoUcNIByE9lFVLjQ3j?=
 =?us-ascii?Q?tqln4h5LcTGRIW4xkpivt2B9uDW0t34pSoyxXDvCoOhGpGGbRZQkTzGrYaQy?=
 =?us-ascii?Q?5V/ZsRRKk+0yIch2S0MUNKHoljD9MMOKnsJiJFFwBRQDnDPDXyA13Pe6JaYl?=
 =?us-ascii?Q?af75Ts6x3yuu4t3/l4Z8V6PFz5oxEXHZJtAvGtLFOpEJecFpu5fnM8olKoJx?=
 =?us-ascii?Q?cYMQO8yp+92dbnH3aWvDyBCOM3Lu6Tq4yAtzq+DCkeVzSRf7h/TR3q61E08s?=
 =?us-ascii?Q?Ks2hy96aDgI521QeNMkvR8ePVQUBVVc6zg9KZHFVXrVB38KeJbIxRhnsaDp3?=
 =?us-ascii?Q?/bJ5UsC3Wm7iVJoZiQzNSfZa8nXTSkLNh1VoxScx5lzhUEihl2wbpmM/FbGq?=
 =?us-ascii?Q?P+ww+WY0nX8nR7Bdo07u2w7wYkpLiFDn1XLN3HgPbKhZ/4DZU7UpiMzdojch?=
 =?us-ascii?Q?4vTacwUY/vfavdlWCcBvNiYIO99B41/puMMRqZOPDiMqA+PvvoAOK3NI3SqX?=
 =?us-ascii?Q?ZG6/2ScUC7qxh07Qu2E1sobQUUk5gyfP/VRXeyGorq1g0Rupb+Wv8CiraQ7+?=
 =?us-ascii?Q?ZU9VPmeZoIwmnmV3veviBFnneZTm1jcFWs0ZxldtjUC4gwoIO0GW5OIIe4uC?=
 =?us-ascii?Q?iT4nIUEeMpdV2hXAMItmk/nL+BWarhkGBleDYjlhN9HhjwOAdsTqV63mQC89?=
 =?us-ascii?Q?GLhBg59xkYwVo/1sarQGylmFeYDSYs1OkGKidgfnIdH7p6nQVcJnZLVHtNUy?=
 =?us-ascii?Q?Af1oWxlu60o0UnWQESXz2gi9wX+w4YpVqZpbUUrf/gIdogRdpbge7dus5g6i?=
 =?us-ascii?Q?vamxCLMzyrFOF4bpeG5FZBZxaikt3/lIEhX0TYFfM7EyiISUyUc9y3SEHqtP?=
 =?us-ascii?Q?VgLaeRtlFFhLqHavdZHXAKRcZVBw+DXG/LfcP/Nhyd3n760+UAaUjTTJ8o+U?=
 =?us-ascii?Q?F/X7CBLJEcPjH5j95tMC8u6vwwnh0F1+tSUQg/ww+x9Q4UMVzrLynSLO/MCv?=
 =?us-ascii?Q?gZv5jh7yxrzvqjpui20JMl8UJdp5MiqIVvZCiqcCoekDL4QzXFwdKoj4yI/N?=
 =?us-ascii?Q?uubJV1cK1osBDgQWbEuAniqQpVIiGltBiPfhYh4XNgCI6ZM4+dHPIn3OftWh?=
 =?us-ascii?Q?AqeWdnafRA1MYUanJqAcvHQ3ZU/E0bPxI3MNRKb9OHHbhwNkf/uLooj1cg4y?=
 =?us-ascii?Q?elxNVcT3RRjmcjZX6uh0Au4jiUCy2yghaBHuBZOyeUHxeqjkvKJnyxP9sHDL?=
X-MS-Exchange-AntiSpam-MessageData-1: dtJkQyNzontTYg==
X-Exchange-RoutingPolicyChecked:
	uOlHJy0YtHn7VZBTcTKzI6bXPCgibXiViZw9d8FTvzpRDCpfbKKHTioHRSAvcEXb71lm7aFjQPz2x29AkpkgkBuhBmio1pYwryk4OPieFQcFTJluW9gm2haBk75CFY/0V8dH9gL094Y+y8zwt5Bm/vYRPkHaWQJh7X4EDlvLXJh3E5Vn87CfrOIG2jkmhpgWf3s+lN5xfdPQL0zs5ZBEzZb4FDBWFdPR1+Y6qiO29NyLW8F4uCHvUbouqJrh+EXA+QNgiEOo3f948mTfp77W8rub3MM//j1Kl5zs48+hjt6C31i7IquEe/XjkGkiLX19Y0tOaVXMvHPTXuh+v46z9A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r3GuWBGlQUzRGb34/ZcKJvVh4oFdozl/hELlSV7AjvSS7DojEg6AIBj1ogAjQLVLjgk1z1shGXY9VStaXVlRu+Z3mausEz2KAmc5Awf+byl7EgaKmXWIh+h+vBYqBSooSc5wBaIVwpFl6P2lV6l/Niv/dlygKMUQliJPiaHqkmtyMS5bTmOAoGocODmo5n2vFfYdj+ay3VdrH1XBLiTQ3KyVt+jKVof1LNSPAaiYSOByRsNmcVSi4isPCDbt9THDm5eOm5GtpiWgpAgKovOcRT7pZ6xP8yxLqqqeOfTnUDNah/xUb2ODkeQhKan3peul6/Xy+owtD/42D8VWxq+P7YjPTLI6ZOiVCcdYbIGF4sI1nrqbPJvkFEesD3tJX//c2+m1SA9HEkBia+sHzdfXly7pVkiB4SpD7KTAtElX4JD6IXHfsyPmSf0B/sNaVJxzYtMJ2sDFYjNlOtVd/NrM0FE7b2TNScUbuDXEnBIKyKIQmJA6A8v26sUwE1+UlzA3Z3P0lMDdLWOlPDCPdkclsSC/GKCwQvSL3jUOxIOnkUdz6Vu/+Tb34C5asnzOYorr1aJIwdgpclsD7AJQhKpEs3cjoEbZ9bmKcJy8JGPoBKcPbGtkIA/FoZoe1LJrn5uq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d265b9-ef92-46dc-5959-08df337b9627
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:10:00.4506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Rgyc+QrbTKrEiStq+Rr5yhm/yAzh2ZlmdifrrWiEUf++cp/hHYoFcQybU1mXUakXSBKMZ4cdVIt817r7q7Vi3eHZj/pOvGSzOfEsWHSH1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

When allocating new data chunks, make sure there is one zone free as a
relocation target.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++++-
 fs/btrfs/zoned.c       | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  7 +++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a527dc1b90d8..98b9669ecc0e 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4118,7 +4118,12 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
 			force_metadata_allocation(fs_info);
 	}
 
-	ret_bg = do_chunk_alloc(trans, space_info, flags);
+	if (!btrfs_is_zoned(fs_info) ||
+	    btrfs_zoned_data_chunk_allowed(space_info, flags))
+		ret_bg = do_chunk_alloc(trans, space_info, flags);
+	else
+		ret_bg = ERR_PTR(-ENOSPC);
+
 	trans->allocating_chunk = false;
 
 	if (IS_ERR(ret_bg)) {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 26177eedc010..36865426432d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3635,3 +3635,35 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
+
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
+{
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
+	const u64 chunk_bytes = fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, flags);
+	struct btrfs_device *device;
+	u64 avail = 0;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+
+	if (space_info != fs_info->data_sinfo)
+		return true;
+
+	lockdep_assert_held(&fs_info->chunk_mutex);
+
+	list_for_each_entry(device, &fs_info->fs_devices->alloc_list, dev_alloc_list) {
+		u64 total;
+		u64 used;
+
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) ||
+		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+			continue;
+
+		total = btrfs_device_get_total_bytes(device);
+		used = btrfs_device_get_bytes_used(device);
+		if (total > used)
+			avail += btrfs_zoned_dev_avail_bytes(device, total - used);
+	}
+
+	return avail >= 2 * chunk_bytes;
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 74c9a4c70d26..ef5292ec771d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -335,6 +336,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
+						  u64 flags)
+{
+	return true;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.56.0

