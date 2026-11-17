Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941976;
	b=Fq7hTo8A3mkS9yis1ITLAGL0X/KromanzvYKNXTs7+Pc3Rh2dVQT9HK/0wBD/tyE1OYV
	 YI8NnQWeL0Rk8hzeTxt8TISQ6v9X6L25bZfTKVJ/3+dYeHjOv1h+hv2Kh4OA8Ioaswali
	 ja2EEJeuITjoVY43z/sgKY0+e7+ymKjVS0U5uVjRZSRRb6iyJdG8HzPVXuOqo4baQ8+vJ
	 hGrP3HOK2dgvlzgMXix0W1EQeei2R8pJdzJEOiiOeie3SyE3ZwuTY/8FjowRL2cgUs25Z
	 MySvS//fxdn0Mth0qaWMsmpMp9nyqVt4xyBo+8QDveNC202qpLtPPRq7JnWhV55WOcw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941976;
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
	bh=QmVhwY551c8lTjl72OTPzVQ5+topeEqxUuEKGkLJskM=;
	b=Zc6erDYI5g8uUZZOuLXYUgwgNg1f5bx9uDTszKPRQ738zXAmZuJBGak+8ebo1urHDSx+
	 oGFf3z5z7JbGOg/Gx0N7NZuLHTPoNd8P63xnSc6kLvZnR9msJgiIqCGLIeqNoOaeGQMkf
	 QP1XdBgSQ4uUO4FF2KWV1MLWsRw2VkSr+NrcXfyOOpT6Fj9DkMs9ZnPoo6Jhze00IDlxn
	 3vBchn/mUZ3+5hvMpQeR6o/4hgHbSuOFZb+S3Lg3LQ8H6re+gaGhGF+hm0QTGYgFArlq7
	 dq8r7R7Isz5vqkOVJi0ALjPJWEkwt1byVlOxoCN4dhWLB+iejVPjIXJ/2/4c7B4s0dQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=CiP8R8xY;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=xjAJhKpk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E18606A882
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22E18606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=CiP8R8xY;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=xjAJhKpk
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941976; x=1826477976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=rWoeM1I2fi8TMFm3JV1jAmIFtg9drwwSJWb8g6zrE1I=;
  b=CiP8R8xYDpd34ZGywk2Fw8OT2JbTQccsG662lRz+zZ4mqEAv7JdodGg6
   b4B5bEdGAxaXUHVs4E2Fp/TcjAsjUpRlxnFsc/HLG1ZpkuCo/23zAw9q+
   vvzzJDwaGsbAomL6LLd9p3jl6K9JRLUHnx2r0sxZ81MaLXlxykLYz2Y9H
   uxBfm9SVr+X0oKnAGeXLWdEHpZ/2axTt6pOsqdnL8N38aYJDq9ofv+IHf
   zzb1ByRndKfi0hoHRmLRfhQ/AIv9+yluf9pzSuBCfts1vt0v67PI0z43Q
   gAMbT0LLRZkTDWqOv24VmNfy2f51TxOmiJ9BKAQmWzO8U+sYUnTA/bYeg
   Q==;
X-CSE-ConnectionGUID: OOcq56n5SGKzMLc6R44f3A==
X-CSE-MsgGUID: vKRWsd76QoewgNi++2jRdg==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156880134"
Received: from mail-northcentralusazon11010029.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AQduANnPSWm6/dD/IL8m+fzl25V0hlDS9E0leYsKATwaAvhuqzLP1n6jXZcg6ezSHwA+SL0Pg7ILqZiuVaTITGKL1N+XwEemg4H3ML4nl+lNC8IaKxTjyb07T9G/ZmJkycuaVuTvrGTKTlKVLE8E9W9L+dGHJ6J/1SR7KumVhW/kUmmFr4/0+6B8ZeoJEMUn3Xifr+4qF/87FHvLiqFWsGPZq4279wDEwqFEpT8o86SPGaqrCBA3dy/jdRrM51iaMM5rUFYogHMUHA08qGRF+0+8Fm7KClH8j1+HHM9XYTgKLsXrzZQsC/QkW8DI2AOjz89mXiXHckX0cRgeLRxy3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmVhwY551c8lTjl72OTPzVQ5+topeEqxUuEKGkLJskM=;
 b=c20Ax3/5w1kaJvh/qKz8fJtGWN6G7WHY0dp7xvvhZLF4cOlp3ROjt3eqZHeWnENHyeHXH+XoSxSEsTS7iFWbzb6mlkw1+xu7anCWhAfHiZoQYow3wOSUmUtLuoL5iN/CPUIkSFyJmpcLNOiBZNWuZsUfts033EexPU1jDFyRNOz7XS435m8lB6sFxVMIio7ETWJblnF0Uz0J43anxgrlaPSiNkufq+NHdhIma7bvd+736jWAl/qpcpIdN6jCWnvuCVO/xD1uhAylhaMbENr/BQl/MWsYdTfEvWNKzRCgn86yIQejoNYkkHltK2q8p0gKQLXeFvoAi62bQg0/s20YZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmVhwY551c8lTjl72OTPzVQ5+topeEqxUuEKGkLJskM=;
 b=xjAJhKpk7dyH675gGuDpNWAG9LowfItnN5li75KJQP0NeC3IF3CZgSkQD96yId57LRzAF96zSp7nMhSDuNaV/qnlODD7VBQDAk5yQaWdN/iZywri6R5ZytYp1K5PMoDgkDaHdpPbCA6b0aIx0cKMKWrb1Rh+NtXJWUMadPHQLLk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:32 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:32 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 10/27] btrfs: zoned: prefer conventional zones for metadata chunks
Date: Tue, 17 Nov 2026 19:58:33 +0100
Message-ID: <20261117185850.4128157-11-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7c0c295c-c168-4de8-2230-08df44dce9df
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|6133799003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	aYXubFyCOR/W+cSe8cTmnaszLVMXGRs8hCjQY9L5tNwJhnPrOKDOgf+UCZQhobTiC9KEGEbtrRupwBNTJfhSJRvO88FLiKQbLCixvFSUScmZKMTepCPwo/rgw3anBtp4c4uzevObu0yXJ6YbhvWBP4kihisTXxD/lSQipfuiRf7+US8k5AnHVVuoP8DTiLvuB6P8kOYbAcO7x+VIjNcT+0nKgStqMOkCsYc/kkM2R2ufCqp5rBgu5Xq1ss+PCuynlNPKHQ6PpDvIw4zgOsTOtt/4jTJQSqVUvvGRvwKOoO7bIF0dCHoyOrvMBKjpKagllOFw0z8fYHOUTD1ra2oUctaAhF3/t/DPLq9ABtBuTTCnUDfN1dkKS5gT6OP6N24yNhDzHcd/rwztTHCiG2gf+g0DgTJpat38wjG8Eja8gQT2YTfkNMx5JXciFR/0z6vNDOfgY0YNOTKqZvpaEXAzoMDRGloEhQYbY/6GIpVRSCq3fVt54bWauKRVIwWMmINTJ2wGve7ar04YEENEHspvdaxc9TOc6mDtj4IqRgjZ+reLQNKgnAiZ2Y528ZkbBR6fShC8k5evfPlvt1DUQjWAwMiiXbW3uPrlDH/KxyORy8q9wJaHtfRO42wuJ/wVC+S/nLRUocPBXf8CkUKGle1SX00QiyFG3n6+rXZIb8eQxDs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(6133799003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KucJW9Qx3FJaBNGiXKQvxhIGEflkPB1lcnqNQ+W2b51/5IfIMDGKxrmCVTej?=
 =?us-ascii?Q?CYWFbrVqYHXcXawsR+n2QKGHyfCrsqYMBMLhsUXImFvcb6jejvhH3pN4QuM4?=
 =?us-ascii?Q?VT1sz3okvxpAx2t8Xiq/naJs3kWNcSwsqWr/N4BhWpr2cn1ob4mNN1m+xAiK?=
 =?us-ascii?Q?ZnxKBRaDGFGv3OOiSqhk0A2djoCojxlkmqwJi4jneTI8p+A4l9qMfoPpOtKo?=
 =?us-ascii?Q?W4GPqDYExlpmMZSTa80SYZSTfLLaNnwOcm5KTOI+C6fEPfTMJM9zbpmvQcd6?=
 =?us-ascii?Q?30NfjGeErfwWb5DAsBIy5G4Txb7xIP3EwxxSbwzCMN8fQgqiFirW3KV1nrtu?=
 =?us-ascii?Q?M+uLVh2zg9IVSCyzOBYL7rePXvZXMosMK2DJk+JuYI5uGWErpc/CxQ9am/ok?=
 =?us-ascii?Q?D/FAyCERcs4lMTcEBgnwE7z9rIsoXRX//CKeS3zNxgIpPOM6D8B13be60bOK?=
 =?us-ascii?Q?5U+3LQVV4TTYYAiynv5bVZXT9qkQBkQD6czyL/H8Uxx6gVt6drDPVgMbrMtC?=
 =?us-ascii?Q?3eQHxlSQHVTh38nk8NJS6Ma2jNlVvpHkDnRxHTtDk6+eFkheJUzf80gqohCj?=
 =?us-ascii?Q?pUx6zlnhqJah1cm5leRTRpLEZLBR44UH8VOgu2eA8hNcSvKuIJWfIg0L/1rY?=
 =?us-ascii?Q?D8ylG5ApHXNJ7O6ZQ/MJs8pnKXQbJYLYfU7SrkrA2MhS2cA3Bet8tXCd8kdp?=
 =?us-ascii?Q?oxWzIQ0qW95PWxIcmPVfE+wi/rVYIVRZe4YBOvx/kAsb2aHDALrG8P2Uy/MH?=
 =?us-ascii?Q?xpGGsGnL8rkJd8ZCQiYBFxnv7vdQ4OUhIQ1WmsuxDxzmvc5PAwV9ZN0GjZWf?=
 =?us-ascii?Q?DSXZotTMQ3/1q/rjtx3w3Q8GlbKYMXa562fWi6+UFMX8ahyviA0AEBxaSSW6?=
 =?us-ascii?Q?A0I/y/N5W7WUlu/gyYAwAKolJhMa+0QFs5k47E6p/8MGeEUoAmAi/L+X3E5n?=
 =?us-ascii?Q?3SVX4XEz9XlEtv4JD+I9n7A0sJEyqdcR1Nf9zKErQXFuIu89HwvNLDlqVq9f?=
 =?us-ascii?Q?dnob50WHP1Lwi9Mh4gLDKMYp9UF4OKXW2yzHvglpfU5Stx9TP5Kd5VxReFNk?=
 =?us-ascii?Q?u0k4cf5pBlrJ4hqVplkeNyELn6+GYHS/mYNiCXGCpG1Q3rvGI7y8uf0SIyKC?=
 =?us-ascii?Q?HLnyr86uC1jzVA+HBss7rWimPqBQr/w6UJIhlQUnF36iWC9cpN38ZTfplxKx?=
 =?us-ascii?Q?kIcbGAd9h0I171IEK+UK4yp5QrLUthy93/b9VerSQ9StJer8dES2kkX7++Ry?=
 =?us-ascii?Q?clI7A/8QyX6PrEJ0dmVqDlk34OoP9ktLRp61QMQx8nu0AMYyjf/rLfnMNBqI?=
 =?us-ascii?Q?BsxX4WF/XHU7yiH+gsFiZdMl42qe1ru0DSehFRzoKtS6KWdg1h5Gc0XlTSQS?=
 =?us-ascii?Q?OqExgiPV1R4xx6DIRUB5ArbG3OMZXk/0JiUz1LhHZj5VIizMHDnjws/eGi7L?=
 =?us-ascii?Q?pJjybC5UTHfQPF5nrHcXu709csllRXdgwgnGDw04LqT3fqgz7TmQ+PGMQ/NQ?=
 =?us-ascii?Q?1YVeLRGb6vICKsEaaKz3JbzSXbDEWr1tP2UWS5PMVrNQgfxo0oqWMfRb4gFs?=
 =?us-ascii?Q?Zkr6STbCe94LjgjBanaRsBpCtFmyatkZs/T/bEvWNxWhK4FUFVbKRIEcEi7M?=
 =?us-ascii?Q?RIcaNPq7UqndNwYp7U41ucc5PDo4z7GLOamkTwk2J9AcVJtrkHJuWv1qAWXQ?=
 =?us-ascii?Q?MHJ22d1sLPLQKtjdpTOxQ0i/5/LmqAII+Gzu9cEyZJKRCVg5MH6nfdC0TzXo?=
 =?us-ascii?Q?TQRdGGlhLerYyRd+9W3/79wERA0NbkC/cCB6c7uCnLioYQmkdMaJaslmicop?=
X-MS-Exchange-AntiSpam-MessageData-1: bN6sDbTmVm6VWeQtss8FlffOTbX+K02kwsA=
X-Exchange-RoutingPolicyChecked:
	0T9Vq2rwuzOHa6o/ikMhtk2szZa/folISr8E/X5wReU5o6bxGBBzi4avTiRT0nHsBkWQ+RgFR7v+nkKEvx45uM9XvKDMaVPoXlLQ2vDWKVv9IoAA/insM3Hdt7NW5WvvPpwAijqRt+UtIpOLXhJrLFtGhRUqqHgjaK/VXCU/I//3tTXPiNfxf/BobgTZ7jK9Ig2vIz8WDC5vDHImM8ULdecgK/w11QfcnpOQPTvgEhhfA5yqWddPOeBlXs+ZDyiTtmha5tWwEH8qDl88UgnEkPxpyft4m23Ya/gCnINCzGz5M9D8q2wmAnDkwlPF9VITI9+iuVcquNAdVKQmT27XZA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zslGYrCrvcJK2cCeW0T0T47JTl+VbED0c/IOgEx0JIQclXVUdVhr2XbbV5dyibUxCWnBtsZ0MUPrW8bbRm0BH6xxuK2oIJAeIXhQ0gQ7iPqJsDFjFUvW/gVhCt37DRpn3alqHmLX7kTTELdVl17U+aAOg4zNb3XCXlo0PpRDsFOLkbSOet8khwTqiaCHq7+cte5W+mTpEo+mpC5HtLeozc8eIFyVpmL5SMfprvKfNEygR2h0k8LdRaVHpip4FaTZa171nk4Uxz2R8qxwfeLi7iCuYmmTY+3jj8dSpn2eRjtc+SIt/H9Y/1HvvTp0e5QKWMGXjGbwLSUc7kfg0to2IAR8q85tMm751glqfxzYAVh0zP/gNB53aF1QdoT5s23YVBxX0i9NZ1h+ul4T3u2hrlHVGIs7V5vogzDtcjSI/oylfdbaQlpvXbSD4E8S5d2fOf6XDW1Xib2JCT6J2+EGAXVa01cKUyiBA9J/6ILWWK1vizVUuXtIQL2ut+nyI9EC5jKHEJLlbjvrgs9RHQv2FuYjQeeyCfwV7p7Jmgy7Gr+Oo1gJemgVBU/BAL+CFJSxHOtD4MLZYrbacfKAaSGHYM8kYa8NG2awRYvk553R2az05YloLytMPrtsuogZR1ZT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0c295c-c168-4de8-2230-08df44dce9df
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:32.6617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyJnZHT+PNAmg+VbYNUbo7RrknOoKUvgiBpM5qXoan+JCCobEJ5a/HoTJSbKAoikXCCgnXDPK0UfQl/jYDG0nq+FvirFz5x6nT7E8DBsGYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

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
index 4b6bafd144b9..4c37fd93604e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5910,6 +5910,29 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
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
@@ -5918,11 +5941,14 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
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
@@ -5949,7 +5975,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail, BTRFS_ZONE_FILTER_NONE);
+					   &max_avail, filter);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
@@ -5976,6 +6002,17 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
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
index 174528e2c312..ecce74f67a5d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -339,6 +339,26 @@ static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
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
2.56.1

