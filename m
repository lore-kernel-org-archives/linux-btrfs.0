Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590139;
	b=A39KHCZIJDt4NTU1iXjBplm8wkwzLCTSEdZgas8HNXbgeh4aLo9Ly9qKUfjNbEC+IdBq
	 u4j2qa3YHRrsEgFvkgVaiXkBJRpQNw9/TmcwFgJqlCT6coq3KBixGSjOwzyqrGIec4/6k
	 6vLclkX2fYqytt5lEZX0CFwj15APjr3uDK2pnSNHKS8RBhpCv8GAVMBcdBAZoj7Y13yUY
	 7LGE1gRKx2V4wLs5jxUtMrHEqmCMoE5vgoooPtBiSnjBv7qt5p+ZudqPrAsV9afF5s9VP
	 93fZsQmMXVLGNB6l2CxK5BQPPqd7JCmix2C4jpGs3+pLkD4w6UsxW93JoNL0/SJoq1A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590139;
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
	bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
	b=A6guFahha6xrV3QnaVYVdzwDu6GYSwXkWNlJEctTrH7lm6sur/wammHhQkoWUKAidR71
	 rulhRTJ8UBj4EBF/aYSA1Z2fEHafOqTrJdPkuRJIiEr/DJQ365gtpAvRH/YHf2EwdJFX2
	 EN4nfgKYbGn2CdLeYc6+gpDlsgyXRBl2ePx3NS9pSCYKYSn0YMQP6GErG9T0m06BO6ZZe
	 zLRinpjguU27y52ypGy0K0HIqkwmc1ukxGzwpBJ4y3uMrlW7p/wxWS/bH+jT8KOSoGR3x
	 IwnceO4ZWteM1dEAiSddJhrhUdUlWko6hbgmqOZddoZwCP1sMs9Ug9xyxkgDhLaIl/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mmmc4AO8;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FGxtRLlj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94035606A31B
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94035606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mmmc4AO8;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FGxtRLlj
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590138; x=1824126138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sdV30EnUMZAr3aVKN/dXLREMkBoxXUp7g1yIiItDRrg=;
  b=mmmc4AO8jGEXcatSOuVLW5/WP+WgLEZweSLfpUeShjD/e62KhyDi3PCZ
   xIwRlZBYuKsya8P/iGD12x5Xk80gFjPsQrPp1IALZs/vj1hwWneY0eNkz
   7S90Af6lQHL1+SLlnS4ZKJYVSwwrzOHZZQhB5BgfI3fXjT9dRHyEG/PHt
   WU4Zd20OiGbqCdw7ASXxYhwXTUKkLMdLm644iENvqA8uljUiu+I/zTn/H
   ow+ZCA7F/Et8ps1nkVN2TPKWcNvcTx1WZus7S9GofgaeOt9HtYWW6nc87
   PuA6frKXfCmMBaj1FR8OvWXhgD1DwhSIuKf/B/G3ieQVBbGH2COn8mM+F
   Q==;
X-CSE-ConnectionGUID: bKyOZ22PQCO78aiV28CNBQ==
X-CSE-MsgGUID: eA3ifAMNSwq8EqSbwxOOlg==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601510"
Received: from mail-eastusazon11012028.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.28])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nTK8SP+k69/2CdOPlmSi0nXrn1JFYgaO92gO75WioBp52grhHQG4tNtJ6Grngqcdh+6iL7lfn6zUK3h9pB1Mp349hgxvIp41x9giLhVSeQPcK+ocqiA5YjSs0x7Y3DIhtuwPoUyZHgTI0gARqEzAfZlBzmQTc16Pti3+FEIQtoEuzo9xX8pwwBfwEEyyVNrqO6HKQAO7YNIvBXOzrH+NUptiNuameSCqlTQTf6QwR95eC0/s+PWrLt1ubxYTyvJ5UVtIcYBAMvJ7oX+MrZHnrE6FlGXrdyMBSwND6SYRwd7HWnWkuL2nQ/kS/kCZigNlCU9u2DlD0JUWHa343Iy1fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
 b=BUxi2fBbIRAN9HHdauKWYF95rZAkbKc0a2wnEf2Y0Ul7ZuFYm0vJOmRNwBpKBOiUqMy9/StxEutnalBqWIqtmlaYv5UmILMR+b3hdLFZFypoYItNKSb6um+cGOoYv0vVfBBkowPNJZk+utqjfTB0eur5aP2CteQXFr8I4NIt19cUDnU91nrpVTEylE8wopKQCl0+LU3L2Rkm/QASojefdMSc3UqcNPEfWHyEy3q7Xy5e3nvzCQkcfspUjaH32hXh8E8merFYAvZkpFQQd7U8++r+BSAoeNcLe/a+4223MxhjSlJwRMNvt/UCfAvDmubFovsE9s+Sj2UdKyIMu6yL+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
 b=FGxtRLljDwQphwIMZU/vqQaSSAG2YMYPjLR4udAmGWQCer4Lo8ETzyhRQF4jyHVU58YWaLUpxjkN8WQ99PaERXybh0eYattyhtCK+Z4B+RZ+2PiLFrYL0uiI1KdwUfou5VO360yMHgxCCggTiuZk1LA5GaVMptyP6jZxyTYUnSI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:16 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 14/25] btrfs: zoned: don't count in-flight data as available in statfs
Date: Wed, 21 Oct 2026 15:41:13 +0200
Message-ID: <20261021134124.2338902-15-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993834:EE_
X-MS-Office365-Filtering-Correlation-Id: 9523b7e0-3fd2-4fcc-de01-08df2f7918d5
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|22082099003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 DZFkspbnEJ5tDpDcVXrUGE1dw2fsofPUGTkO/Lbzozxgkvsrw8aWoyB9nywmyv99ar0P5N+RdoxsNy2uSerTPTxLKCnJ4bywc6/icdiyD62R2PGwGZHiNK6omiBBs3TPM0doryAx5jL1de0EiK43TvheOqxoAJSVULZrczuTNdLwvqU9FbeDcfcmXKsad8OLRMamHMo3gJj2wmmF+lixVP2DGOeXfYUBlNy/0lVREiY+2NByQZyD1DSyugHQZ89hriifrl9YcfbtxwCscUYgxwcDmLauJ6RLLG9xjAzZUIlg7/Sbq/suO1XVPTrbnhbYeaWOEOlGYMhdfLEg5XzP+qKPNfpLgyFf8HYbj6K2PHpuu5l//LGp93YMb69okGwo99R3Wz4OezyMWcdxoS4LL20RL+UM1lEJWcFYrkZTzdJfXgHqmoWYnLvU3PoVMnRv3MPrjXOVDDWqvhwQHXMF3rZ3uls+JAoN1YQKpDw0zvPvltywlqkprgnH0HbhvIAxAdyfL+2A5/jR62InmTGKE9zLZ/PcbtpYBcx3QQXIJcAXQ1e9QEbVwkoKmnmW+6jv1hY3glzKxyO1TCuAIQN7bVtSFffs1sJrQp6u4fEErSI15mwZYNkAYX51f0tlOMjsA/25jg9GxotUTCa4dH+YPOtE5c4Nk7wlUD3RcW02fF8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?SM7YKa3sYGPi7TwzroRM3rO5nlJsAa5TFLWA0N9AyK1ig5UfF6nR3pmw6f6x?=
 =?us-ascii?Q?gKXK3xKps5g/gglJ15zJpJ1InhZ5Y6p1xm3TXmPOVqdCJb1DLq8f6kxxlaFP?=
 =?us-ascii?Q?50CIZXcmvVpJ3SnCrDgJq0x1VODSVxOQTHg1SvJDuNTt96NY12gWSMOL2W9F?=
 =?us-ascii?Q?/lojnwXAENhBoHb+2QgopqCbe1Tq2ZDLi7QYR2N3f46scq8IrMgZcdrTm+y3?=
 =?us-ascii?Q?GmXPDoFrTtaNSRF3HsjXHHagAbQw//iKsadhG4BjjDpCLhrqPkV4zPCs6jJh?=
 =?us-ascii?Q?2Sr2zkn17Rc3735aZpqETcdFnxtEGC3wYnQTsb/uLvkM6oqGpw6d/snhfYPR?=
 =?us-ascii?Q?KVsEkCgVbowGtM6k+jvtU5m0jIABFIu4jiKm3VHdMFlUWWKqux1koXAsiXDq?=
 =?us-ascii?Q?+ZaPdI0Z/ZpiZHYwz7g8RlsZnyZjvn3BA+sp9rCGHXktUIKAFW+yZOOeBXHI?=
 =?us-ascii?Q?Xsx1UzyQXwakpg9F1G9jq9oMQWglNoMaC/vpk1Qfl4RIYU5sa/p3HOwSriPM?=
 =?us-ascii?Q?acEDr92WaHhlO0Cvy/Xh/3zpYwNS2a5IlkFWd2/lFe8bYDgfsGgBtnOhdpjs?=
 =?us-ascii?Q?SgRdenXU6Y/lNjXD5B/3J30oeCnx/2IvRqZrVaWUtW4boCBh3gX/KCNCVil2?=
 =?us-ascii?Q?onEkr5HEE/ID++nYCkS3zCG2ka0RvsHyN4LmFzt0a++GAopXrc6s+A2HcrtG?=
 =?us-ascii?Q?YV7DGCuAFZXExi4pBsbSz9UeUHb2FHu0Dk5De4WqRQ5MXjB/jWFMUjhGpjJ0?=
 =?us-ascii?Q?M/dktbwN6NmkXTuvX0cuxICDmuvxxMzlJLyEt7rLOrLKJhcb92UeHAEvyZj0?=
 =?us-ascii?Q?Wo7pTE6cUO9WRu1YXb50E9yOklmHklweMgWlbClxf7GCp929i+Nxi1Rbr110?=
 =?us-ascii?Q?kzH//aJmTtT3VTOisFiT/xVszGMfpIJZ6AnijsYZ+oMsPCHjZplYh2L8KcFD?=
 =?us-ascii?Q?2Hd7bnGJeXbzXw89KVGuMruEDH7IXqns8v+f8qjNyp8AGEAY5roslVZ/SjUK?=
 =?us-ascii?Q?VsL7bgKJnCGUOBXMz+BsStklHVIgeRNB/Po1uUVf8E+QACJNFCJ6IHAYH8B0?=
 =?us-ascii?Q?9tTz0psMDQTJMsgHlwR6B1Hg2oJV/lrxosZzYqcKTYyi4RtcfXlelEDcfNTU?=
 =?us-ascii?Q?ztHvQ4hykZpIqNjRLaj0d0lIpShAiJ8g/Uq+PgOHz2HNFEhKIsmxaHtby1Vx?=
 =?us-ascii?Q?0Ato6/g+LYFpTZLlnLGPEVcX3CkbFEVbW6e1v1Rf8tWfYrA/zBA6TllcjvKW?=
 =?us-ascii?Q?p6MQ/82f6Ma1d9KY2c1Fl6M/meIzt0ANy+rzdNCH/h1x8GjHVlA9m5tyfblC?=
 =?us-ascii?Q?puSbyYfLFtgLIMgnTsCZfLs/+Sg9YwneMoRBk5M1m5bPu9LMPIYQnK55fxSV?=
 =?us-ascii?Q?Pe+mlB0w2IyRlf+iDFbjvgRuBYmvKE6iA9pHjG23mESlL9Gt0oGht7Fv0+Rx?=
 =?us-ascii?Q?yjsa63RhqNYjwR7WPIv49TsL25qinhXdPlpQUsG/vHKtqCTlRNstUBi6s4Cv?=
 =?us-ascii?Q?qyKazsiKgi86jK4cYBdhVIaXyUb4iJkA/btgNtXhSyOef+JeGc9y5CsnQuwB?=
 =?us-ascii?Q?xbvbql4wyKxxp3yqezlipgAp/nbM6hp4NLk+/4h4fpGBPvFXL24wx9EwXp+U?=
 =?us-ascii?Q?6TC3JhXo6bOH8xOihU0bBTykZU1LjLDSuZAAwqzooKk17dIMyu596mj2fc4x?=
 =?us-ascii?Q?e6nqA4aU9lMHA7R7s/vCmTZ5bec6c2uhwF15xkuBt4QzvJWygXQ3ZZsrN0cq?=
 =?us-ascii?Q?N1Dp17EObOMRURHkUhDrM6m2CU2PC1SZtFGZCr+kfcc/bpbNzrsklE4zVqZo?=
X-MS-Exchange-AntiSpam-MessageData-1: ImP3yCtpDtgA0EnO4L+/eUMYxPvmI4qRhsk=
X-Exchange-RoutingPolicyChecked:
	FJmmwMnBl2ps5GhmOsszennGvjjxa+uFjR7Pgj97qiAHuHBS8yjYNQ5BvoRMQo9MRCPzcK1xwivzjKUjYpE0HoWRsug8RaUNpSDFoUUCQ8DWY/PftmSt+i7FQ4zgI8B7XiFAuwiNJeDqhR4hRIcaY48kEdCiP8rUCOc3A35WpARbsZmEqvuHiZzdD07pr9Eb7BRoqeDJoqd/eoCG3kGvVZu4S1VP8NsgSbqxcQt0+a6XYeKeQ2O0ywU28pYJQT+xyGbhspZML2ihTVUDp2+47dtcKDs7dTlWsgUimiM2FI5QnD0Mt99zi/7Z+CNPrNOuMx7aSidDdpeOeFSLPq/fzA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IC3tsw3xCEGwDHIawyjwe1uPMhn+dt9wX5B0lHGwdMs9OlW42iCjqjqeF4/XRclan/Makj47LnTRynYvQK6pPSgT2hF75EeaXqc7XCwaq3lALdOMU1vXzBqFd3I9scBA5C7xu2XuMiq0stqXL0GOsnopJmcpfGe05flaGM47oSfD3RbplU6QE2y+Tcp7YyaNwSKwiB/zTxWUg8p3ER+T52BsokbeDQST1Enj4m7KwUo9gqAKcGQsVv2DBYSbf5BGPSlvcOpvFEQ9b//cFmPQR2WMvq3vslrLM55H34hAfhkkt/JLogGp6jFcr4NTUScSH9F4A99bZdE342IbgIM40zdKvZpCfrDZ5Cai1NUxvh440V/5iu6GHhyLenD+sYm99pwZfpEOHwUfdNTQDL4eoVh3C+o1iMBnvRTdtMhGyoDUnFwDIzKYNYRgy35Wyanolj62ETBOgrWqJCyYE/bgM0YY8/YqUedxCL5p5YeDiy/bAUMoeZwx74uK81WgMG4eBjVTiLPJVnZm4xGMCdxQFV8VL4xbt8f+cbYU1O7oGe5rkrPVhQ1f4B7+0kgal9ynuCAfpZgTlHsUfAeA7L+sMc1QRvKKdmY0qh3R12HgqPnX8UFSV4qhFwViR4wtLjUV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9523b7e0-3fd2-4fcc-de01-08df2f7918d5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:06.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QM25g5YHXwCwtY1kYuK4whmgjp2hEmFqsWPU29vTM0E+Q8MVvxIYwuA9gFDX4E4awZ+L4jARPUDlY8BkONvBV8owmZ4G8IXrprVqlAgkYWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

On a zoned filesystem, space of a data block group below the allocation
pointer is used even before the extents written there are accounted as
used, and freed space only becomes usable again after GC reclaimed the
whole zone.

Don't report reserved, but not yet used data extents as available in
statfs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..9bf211916870 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1691,6 +1691,18 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
+{
+	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
+	u64 reserved;
+
+	spin_lock(&space_info->lock);
+	reserved = space_info->bytes_reserved;
+	spin_unlock(&space_info->lock);
+
+	return reserved * btrfs_bg_type_to_factor(profile);
+}
+
 /*
  * Calculate numbers for 'df', pessimistic in case of mixed raid profiles.
  *
@@ -1730,6 +1742,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
 
+			if (btrfs_is_zoned(fs_info)) {
+				u64 inflight = btrfs_zoned_calc_inflight(found);
+
+				total_free_data -= min(total_free_data, inflight);
+			}
+
 			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 				if (!list_empty(&found->block_groups[i]))
 					factor = btrfs_bg_type_to_factor(
-- 
2.56.0

