Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602623;
	b=qJczobjIGKs0W4YDI+KTYhPu2ovBlFNbsgjPTuRwZQ97O7vQ2AF6wxVGeMf8ib235dnn
	 qywWJ5SE9o7nfYvj4kzdWTB8LO7ukTmo6iUiy7dzusWnOaigqxqLLVWV71355lndLX+tk
	 449X8H7Vk+1WTPgqxq38KGkszg3DpGXA/XIKSxVl7F+aWf/RQGzbHyJl7M9Kstvc/l+8e
	 ptUQFDUSUyvzes+9wvL/45EVPdvrE9DidQo59CZ5q6YnDXr243mx5OarqxaXAzS36lsv7
	 IuYUefeYHsfSUBgShAkjBQnyMrntvO7ITcQFSHKPdBqzhB1qMROe+Tc5BSYeuHoQl7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602623;
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
	bh=LaY6qgJyOURb+TvDZwKaL8vgcMAWt1uOPeX6uCWAmoU=;
	b=zD5gXkZ4xP1B8Ju49qgRR3IrLD085fQVpf09nIXqccvbNA2e+d5IBvlqQZ5ZusR7Lrp6
	 QodqIoZy44mi96AOFq5RRCjjj2+fYlm3xeItn73J+NhokgJuMLktD/GrxUOmlvaOrdFlZ
	 RSLsmx/dEZl2YP5Ei2a3m5B5hLd90V+Bpg+UDizO88cQdFdoPjQex+yEyn1dRd4wEk3at
	 GLvY2rVCXl7GwqWCvwlmYUQU33kV6emuq+ztyc78BJGzw4UNl3Oa/rza4+9iE1dkBxRvg
	 n/Tt6PMZ54nloTuVU+Eo21pCLz3ZLBnVyBRLFSeW2AepCXpguC2NjfUI2O4iO002fJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nfezH0u9;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Wxm045B1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BB5606A327
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42BB5606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nfezH0u9;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Wxm045B1
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602623; x=1827138623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=j/ZIb1jrp/pmkqvDaWKb6/wo/PQe8rxxXlcwi9C324o=;
  b=nfezH0u9I1sNKFALcHZTmJfSf3Bxggfoas+kBBvtO4KIsUP8gPDcFiX+
   Zk5xkUk0/Udv8+F0JHEnf6kaM3pH9wr0QG87MD30Ax/9Rh9ac0G5H+vE6
   7S6kgZjHyToNdkLTA/J0KD/GONZwSYCgqumV1Fqy87SJciogh+ooeLj2+
   +MtinYdbbubfjFDy/cX64o05mPLcl+/q8m0hyWq6WlH+Cyo4/oF9S7UBU
   mGitJ6ryWtkT2uviExmT7De2q6S1scLb7t0+HcnCm6WAPX4G8ElcldBJE
   bN4EjOaV/+Vsct/5T3oPXeHbi96M+KAZZ3aucWAjT6A5E7KmAzFxSbHeh
   w==;
X-CSE-ConnectionGUID: e2zZZPwnQOm51CX4k0huSA==
X-CSE-MsgGUID: x/os9JIVQimnjBsY4hsMJQ==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492372"
Received: from mail-westus3azon11010027.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bqqDVLcfsKbCtu/aO+B3EKJ99lMeRLZXpT7QRe4YJN/JBAj85gNABJ1Orp2/FAxy/WkxZzVLcExJe4QH6tFNXV0nTaWXQk5sQjNCcaXBlj+MGr7/7mu9lABPCir7d2MruFXVJ7KMboQTYGIfDL3HKo1H3uptJOF2JGwHYQgV6Hwu/i0ZkT9kxYu/bDt49Nal8/GmenYTQPAvxwRdQHWM6CmW3uvTtN3lKflyyTwQSsVdUEvw2e29etD4XDWDBfVVGlQZf+naFFhmDSdXB+Pd2zOH4eEryXMXw2v4xdOoqPuvro1XGOUXLsDTtGe12kcbIsoshg3UD4qK8sFBsedxuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LaY6qgJyOURb+TvDZwKaL8vgcMAWt1uOPeX6uCWAmoU=;
 b=iy8pPIKGxZLG0NlatFAHa/oJNGkbn4X0RArkZYroA+3XaTN9hxdx2kTuAp6FYUdKL5bogWJkf7W87tYHbGomGQx1b4gX41b3jCv6qNVaBVpPlfRtCcoCf/ljQx1ZS/D2vteRrjHnLPDLB1jqQzSKTjZsjJLxDCS9Gtq07HxI85zcmXoN5YFuwYHLA28/PtYivzivbDgbhrhSwQz+U1VRs1H9OGAxNk9bpVT0xGIi2LOG+VovYkJ7xS7jai2QEum6KT6Ca+mZ7F3Oj6CCuwvEE8cC02KFSJolNSpWOIfwlwMKOvK68O8/je6GrEeM49x5KaacjX44keUs1Vt4LwJOig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaY6qgJyOURb+TvDZwKaL8vgcMAWt1uOPeX6uCWAmoU=;
 b=Wxm045B1zYtL4XFRLHN517TmSBrvDnN3AS1AbAx+d8BHMb/bYVQeQuognABtVV739gFWNs5vcSlccXWVkVAtmHC8lAYY1zkylmkClcvoxlOjt8tFp9Nbt4gtZV9Twyo4DQBpi9M3emUnXmRyWS46YnOMpMj2+jSxdULKw5/QZ6k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:18 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:18 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 02/27] btrfs: zoned: reject dev-replace onto a target with different zone types
Date: Wed, 25 Nov 2026 11:29:31 +0100
Message-ID: <20261125102956.266389-3-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5b48eb68-95be-437a-ebb9-08df4adf19d1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261026121527099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4aNqDLHIex2msliy5Hbj8nK/PLcDYxNrj+OOaJeTQ3VRwrN3mR9cyNomiyYa2570qmZ7vQ5/o7cROT8Y8tgx0kopnJS4mAhBetulysP9gZCuYUmTqCUGjUtZLGTtqr4TgrsC+LGYWEMA3xedZlBeNxcFO1bZMRiR7pZ7FrDw9Tzrplpz7MvciKFz3Sfb49U9mtXDS5GT1AJ2MnaeGNLaWpNR5VMaH+sjXVpR98M8AdGw53XVX5olLwc7rl4UojIoyvPtw+i31+Yhku13LcDzSLc3CGsfR9dbCLPARwfJhjN01KrZkMcfBYuhe2porgjSDu7MZ6RqUonL4SZBXaEuOKnF8dG9cYIibkLyMgwY9XL0yDQw55/82W8i8WzoyvUxa4Qq6Rg+PpJ5ZwJVU2A4UxVjHtZG9w4eun0a6TopVR2ovNz3y9cttU7Ojs16hrX/6slto74ArubU4HMD3DX1n90/4uBQTWPSZ62LAQ6Lj+hJpn8dtiXXQnhnFGZJBmKZ9+j+0X7jR203utl7SpVuogl+SMftgBe4M6mEMfBX7Lfu2v6GaQ9m9Gvz+/5yatlNVdm8uP2cKeyXzwrrCaLz39LFtzX8CkUhjwmYwtrohjkNxJfDITpbNX7Yh2IivdhxXjXZ6vJXRPJ0jhQvMbkq2J6dSFYhpi/PjJ7F/rSgnYs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261026121527099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PO5QONUjw16qpSkzwoBLOXfxok/UZZttZzdNBv1lkIGQOd0J5vTyb7440KuI?=
 =?us-ascii?Q?944IIagTcYxauYHDh484helLLvzd4Vwqm8axj6aanpjYjIt5Qfwdik4PmX0p?=
 =?us-ascii?Q?5nxLtrJLrQxeqkngG66J8qxy2w/9UOE+lM5+eqtpG5pvRteW2vGA/MvS2G9S?=
 =?us-ascii?Q?eP+5NQlj/syj51nJxrWPJ1gCb6qnRHzs0IhsFBE9xRY34rMzo7qLVKmqkbBi?=
 =?us-ascii?Q?z7SGLTDVtg1zobYx6FTnoKE7iabS+PxY6eS1Cccysmz8ag6La9yjD+PP1w0o?=
 =?us-ascii?Q?MBRXb7CiegO5QQYHDCMC/+ajID7CeJG98MnqE85pvXPJp3u1flu3jL1FlJjt?=
 =?us-ascii?Q?/tGakNp+gMcwwIKczaXAZO7rvkT1Zhw01edp+UgqH0zvEV8tSBO1/IlmIO/5?=
 =?us-ascii?Q?N4bUUOYDUWElaa0zaoYjP8cenTz7vPCw1v5TbWeUemtQ8jH6VAXxi5Eju3Xn?=
 =?us-ascii?Q?eJwKkkozJVddYu8P/PcH2Dhr2qq/nvynqCC5+R4noosVwZG9uphMB2YUAf/U?=
 =?us-ascii?Q?LcCoSa0+FWxIdDVlFJ9dNdd+husz7x44KWtp371bmYhsREUgmtpXgOhW1AA1?=
 =?us-ascii?Q?ZOHZqV41w2oD3YZUd8NBhVaXtqW/ISP67lSlMBmAOoBCxJS7v27oKpJLxteM?=
 =?us-ascii?Q?RM2GrJB38U9c7+Eg8OVJOsl+0dC0H04jUiakAn9lArxxg8qUHBwHs65p3WpM?=
 =?us-ascii?Q?wR++p+JeYa8YBQsYQ16JmGi61n3pbIMhd/jjpM5hdvJv4f6AHUctXDBvu46b?=
 =?us-ascii?Q?5pO8wV3GPRxcOC3DshObrV6VAxRg/44+MbgerqAFi9+uN0ubsTZX9g2Yg5AL?=
 =?us-ascii?Q?Puwd01ykcWlyJoCSl5yySm8tlGzGIABS5/h0TSH9FqFj+/2tmJei/1DNJAUo?=
 =?us-ascii?Q?p/GTZ24OXuevYMx306G2XFMfP9YrFDWq8kRiJnKr8MPmprsp6kIFpU1Rp9h+?=
 =?us-ascii?Q?Bzxi9Pl7ou4daFSRedVqLW8T2llqpAwE9XwnDkEcLLUjnBJxY3Gj3ViwM5jg?=
 =?us-ascii?Q?yyD0HHu7xx1+O1QfPYRdZXUYQ5l9b6tcYKqme/5M8s3YGXOT/0gkeGuQ++R2?=
 =?us-ascii?Q?2d1QLmM3JLjJGHi3VAePy5Y4Ser1EMdktdjj0RQJaM3OfpJQloNdi0SPWIDQ?=
 =?us-ascii?Q?4kOHZdoMiLgXATxeEtHK0v960TC3pYM3SN4ka5izdQ7tXCZP/CQgcQSSAYiG?=
 =?us-ascii?Q?/g4gLK8XzGaT5JrW1zozsezzOmtxVmtHtDYzNsKh/UYhSrnOEQLpcTtvrQmm?=
 =?us-ascii?Q?7Jg9E2IVhqT74lkJWlFTXIpeVXjbbsIYaD+svPtnzlQMvuuLpQskFilbcdSi?=
 =?us-ascii?Q?JKag1KPFIwgk3qSvl/vwW8uMWPQ9E/jFb5qjAGbJcdMNHITnUXr7CNROQK0Z?=
 =?us-ascii?Q?JiPjycpO3mymNyhZQ56MlA1Iv+kA1GIZjjJYyvz1UeJU9gR3urGakPpq7IGi?=
 =?us-ascii?Q?+k2KZFXihUpHNP4Qf0F6ZZRO6VuXJo7psVqxJhaxcj94N36uOsJOoTGpRHV8?=
 =?us-ascii?Q?wZAEFDH9dLwgwGP6xuZ+dW/wyw4XRT+xoz9lpnc1OBkV5VF4neX//ULTr9MH?=
 =?us-ascii?Q?o0ZOruuiVBbN5UCvQ4nSIIUTlRiCdUL/vJ9dAmA7PKvdUuVRjjukzjtxxiLZ?=
 =?us-ascii?Q?etMssNBoT+fS/pK7NN2bqsAMItRPha7GGO1tIDBfvSF8ZnVSPXWsNQt8+c6i?=
 =?us-ascii?Q?2syqOopVlZ/B9h3dqTnb+Obpu8dS6cAMmG52O4vkSEViDt3TGnb+0PXnx5f3?=
 =?us-ascii?Q?o5x3otpYwmeLGFBBewVAQJPO7bNuRuVQuUQTQ4CkxcTBdtXX+6TGVdu+yOL0?=
X-MS-Exchange-AntiSpam-MessageData-1: vZSrD/rlkG+mcXxn2zJgIHxrQW1LcX0ATWg=
X-Exchange-RoutingPolicyChecked:
	JQbAIsWEjfoedYwIIs5vUPORQ8eJp+nUQjuCw/qmyIuF29x20R19/t1laGdoRlhbGRscZ+8ZXBGFHI6XHLS5rkmCsLZvuyRKW+IVJFt+GeXglw4sRDu7+c3lxkbpOpDM5LifIJ5p9+mnvq8NBZm3G8+i1cm1xUdDUzNygJEOCKeCA7OX6R0dCSVASydqrQ9ykZ95bzXjz79SXzEXAZzwIsj6auMRM8Ytug0+XiOAj+dOEapLrWiHGwA4HlNpFzA0VoPsmQguv5Q4DZL/cekczLmiaGdH96W3FASJgZSAyMuFBkRDby41wdVF8nr1YaCeLyH855fAWkSKaWGlqwy5eg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0o034qjPX+c6KAg2cnUoPE+bOm807Yd5bbV35/KLW61C5V/cRN018nbX0wB3/wZ3pn7sH+1z3gtvZK8aLXPwAQYSQC0M65bqPFOVH+kDmD4CYA4f71TiiA+Miga0SZC1lqFvKOEiSMJZM6Kn9MnPMFpcjyyhEDeSutmNYSXRRtyOpqvucIF3yQ748Lkcxdvr1bHfx2dnu/8mSVKQMn3+LPTgb+0pnNExdiZCI8zdyQZduJJWXp04ZD9PGRIxPakfUtz2Hp55T+k1kHgeCVDco0rEOXe1TnIy3qEioSxFeLGj3xB7RopQshrG2mhoodhy1+FOndcM2CfRQHSyTbUtsVjzNF4YfaKd3fZ5/+7cTdXyEZsqLyi5wdt7rgeqG9wW7kiftMrMHFBny4yR8N5cGJXxqIZACF15/peU772f6PV5Cn/DVv5NtoW8ssm+XAboZ+m+J3WH4TfTHGLnqgviZP3SjykdyGo0OF95VLXNulTTFCGHcYq7ztqofXLBF+Low9Pqg05uxdTfyiaSK/PabyfbKRdLDPwPrY1bCx1KnwkRQTpfWieX6yRfRzWfHU5qaxQUhbtxZx6Lmn0PLQbMBp99eRp11zGkeJIkkUYmHiiVrr01aRTdMkLOIOcij9YF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b48eb68-95be-437a-ebb9-08df4adf19d1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:18.2326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7soy5Aty4WY2tgbUo7ZlAtDweJG/9gb5z3IUxrsffrq7JOzC9HZX2pTJW7KKasw+FhhIJ3L/81x1x0pM7vlSfCr5ssRw7/1fAeNqIykIeb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE is set when a block-group is loaded and
never updated. Replacing a device whose chunks live on conventional zones
with one that has sequential zones at the same offsets, or vice versa,
leaves the flag stale. The block-group then keeps being written in place
on sequential zones, or written with zone append on conventional ones.

Reject the replace if the conventional/sequential layout of the target
device doesn't match the source device. Missing source devices have no
zone information and can't be checked.

Fixes: 7db1c5d14dcd ("btrfs: zoned: support dev-replace in zoned filesystems")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/dev-replace.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6f04d0a49d86..048780dd4002 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -318,6 +318,26 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	if (ret)
 		goto error;
 
+	if (srcdev->zone_info) {
+		struct btrfs_zoned_device_info *src_zinfo = srcdev->zone_info;
+		u64 num_zones = srcdev->total_bytes >> src_zinfo->zone_size_shift;
+
+		if (device->zone_info->nr_zones < num_zones) {
+			btrfs_err(fs_info,
+				  "dev-replace: target device has too few zones");
+			ret = -EINVAL;
+			goto error;
+		}
+
+		if (!bitmap_equal(src_zinfo->seq_zones,
+				  device->zone_info->seq_zones, num_zones)) {
+			btrfs_err(fs_info,
+				  "dev-replace: zone types of target device mismatch with source device");
+			ret = -EINVAL;
+			goto error;
+		}
+	}
+
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_add_rcu(&device->dev_list, &fs_devices->devices);
 	fs_devices->num_devices++;
-- 
2.56.1

