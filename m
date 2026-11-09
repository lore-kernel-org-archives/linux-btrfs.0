Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794215361;
	b=ZEMpqc9fENed7agzc8AVedGuG3Mt72ZkeNuIbYmLLgF7QX4BIRgbbzQAZ9pjqHM8E+eL
	 t2M3oXFWw//jDV5bs8MQXTPMXtuHV+eeGfKd8nMx5vBwHPv256aVsBE9VE3o1XT0cPskU
	 julGM0bWPNMe5a/pvdfhnEaE18ztdFZNWHpLxRA8OVg3HgwDqE8fUNFR++qbqBnGWdZxT
	 eFXocfZoPeSxNa+dkWorELW9uDEbBBGxcKa2BllvbNULuBDtDtlf1G7Omk1VfwRGQB9Kp
	 3jLGwt/KJDod/Tju4gnUny/pi6p/nj/7hZrp5BbsFdjHgqo/IgPXNe7VWup4btGAG/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794215361;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=Yk10nRTwRUABP6/XNx1GIyAikFpi6ww9hS5JNBqAsTU=;
	b=viIGas5YlFoDl9FuqxwZoE4KVSJ8v5t+aRP41t/XUSdcNX3/B0c2JDy0GsVM5Z45ZYXC
	 Mac+it8q5H6VDV436IvgdWrtaZ5mJTgVP+ZaOeJq4ClNFKjizCX302rS4mHgYIT/7AVnu
	 U+oQ7f1AibLJo0jisJlfDXqJMRdeqBN0DBOCxvLWZOiCVWU+9D/13JQBmwJ6CEmjAsL/o
	 LXMquVe6dMOny/lbJ1WTznKkGHEN117VB5VbUtTSdr0Inq02SEZPgbmqGp9OhqutZm68K
	 EKaXQmwO7QIhTn0i2Pi0o3EkaNSY5191NSZlOBMEVmLl5w+W0kjLVdMkSXT7axkbAPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TI6sufT9;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="L4/LldPR";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED0606A335
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 09:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55ED0606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TI6sufT9;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=L4/LldPR
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794215360; x=1825751360;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Bh7Xa8dbV4DRtP6RiroINMQZxiCpiD6Sk0l1MGdDFYU=;
  b=TI6sufT9Y0FItOgjAym3044022GVRd68jHHM0/XmnROi0WktdaIf7x3i
   t+/XfxanhIJQiwH9LE6D8nHO6occsjq0JrjHo8wE0Zlv92OvkSuPNxBeu
   ztcyzkdo8xAg/neH4AQRZupeO1rSceSanCJHvVZj+zO0v7h8oLwGBm7op
   VUg8rolesytLtvDhMHHYiHSBgMrbiTKWbvDt5oMnzSkg9cIwocBEG1HEG
   BnbG2w4q7BGR3LSF7debn4NVy8rbVMXEOIdsR3s1bJRpDv8jqrrWVHuav
   DZATghqM0XNWcAG8veUi1S8BIIrF01/8SrM2X8ggqY6m7xcg1v6v1yzpX
   w==;
X-CSE-ConnectionGUID: CeKJhEDdQOSoPYsLYqbl6w==
X-CSE-MsgGUID: i5YcKpkrQlON36b4Vy9RkA==
X-IronPort-AV: E=Sophos;i="6.27,203,1786982400"; 
   d="scan'208";a="161323747"
Received: from mail-westcentralusazon11013047.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Nov 2026 17:09:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wTtpNUccVGTRcvIisIM/FgnNtOSION6AES2ApjCvel1YBDhwYRSnYx/Hze7lk291FUxDRPUEETTkl/N3VGXMq52BO3NKNJYlh1OztZakXIKIQdCeJerPHrcZzLzL+kvEYwcXaBNNMMKFupGE4KWdDOe9dPR/U3H8h1BlNn8g1K6c2JdbFykPY9jU9GusumjfZvlOcqSWvTWuoRjsBhXTFtB1MLL6g+U5wZjYM2RcmjRfFzwcrri65feW0ZhswzAuDAwRTWmvyWO9gbrKHJScM7swXq9q0DnBWkHOQrnQyflv6GHd/dzZsuemBIAQq0Pz1JzjULesS4iTFwp1e3npjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yk10nRTwRUABP6/XNx1GIyAikFpi6ww9hS5JNBqAsTU=;
 b=PtxkQh0opY7S++O3i7ilSynt8gL0cSLGjyiVDMkmONhOz9D0IGL7f/5ZqFxAC6IlIhqEWjjcpEioNAjVOJmd5EirITQ60k0j/aIVJgkbNiOgbcgalvJpTrONfJrw+66oBBMXc7Kvl3F5xgMoOwDPLewneHpsHWizVHbUA4STo3Q26QrzrG8tswozZg8oYHbEFcMGaLM/qS23eUoN/N1FmJ9J3bD65MkL19U0nSSstNo3l6RAekvJ4xmf9pbZShpGNA0CKznKWdmzkoN7ikozV34FrTAu2X9IABFELhHj8hdemlVuY+4e0jyG54ohrkbsRxvI3z5RwNvi66/zUmylFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yk10nRTwRUABP6/XNx1GIyAikFpi6ww9hS5JNBqAsTU=;
 b=L4/LldPRlYctGhSWAQ7g1jDPVVKOs+fbpHkapYzsECqBPgdrJptnvQtEyBnViT/R4HpL0QUwFORwCk+fbyPcbKG3sKSr7AuW+ijW2UJnMyo6Alc59BHfPK0t5fUY9pkVi83ValC5VqOsD2P27zfh+07PGLOEPUxI2GMLSs/dvzo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7512.namprd04.prod.outlook.com (2603:10b6:510:53::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 09:09:17 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.010; Mon, 9 Nov 2026
 09:09:17 +0000
Date: Mon, 9 Nov 2026 10:09:12 +0100
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jochen Philipp <a2jphilipp@gmail.com>
Cc: Dongjiang Zhu <zhudongjiang@fygo.io>, linux-btrfs@vger.kernel.org, 
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
Message-ID: <avGNQ29RVwByM4HC@mayhem.fritz.box>
References: <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com>
 <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
 <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com>
 <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
 <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com>
 <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
 <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io>
 <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
X-ClientProxiedBy: FR3P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: c95187e1-0623-40a5-db24-08df3e4121ce
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|23010399003|19092799006|11063799006|4143699003|56012099006|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zld7yMDeaECSiApjFKhxuzTadsaVk4q3F9j+oYfvJt6wwz0PdVEiFTYziB/Vd5Zn0WOJJbp10UQyU5q4fJkddX85X9KCZAilpspWppqOVsyq4gOhouNrwVCPepfm5ToRNlJnrT8SEao7wqgWNIffFcWbcctWN3xbofpjAcaV3jwnY7jPPs3zromZANQp/iV2b/1mXc7azge8YkOuAY5I25P+DLDVY4yAO042VIpyHv60CnCz97bakVmmx2lxuaqYZRQQ2yar3Bk5sxbcT5fmZXBQSXfMuob8yYA/7BCKDPChiGK6aXWXpOIHFuxtFCeBGSXhAOPxqLsRjuUdfASXBnvHm3lDmhxxxreLgCna6UgO9QnVcsyItkWsFdaqijkYx0kJIrfaTUlFCAlOcmurclOYQH1MEjtXF3Tj5baZj7S7dzwuqEYBIs1vWhNzVI5MJOpHlmuXnvxRwWJF+g5/15zNGGyWcFWjuD6Ufz8bU7jmSBHMWzj9WPWPo7RifuiHj+CtMmRnLWBhqsAnvlU0UtszBBfrQa1AuOJrjCvbQH6VbNlPfwZCtKtIBUGlGaiWuR+54QWfJ6MzC9H68keCmBtrms2oc9rGtNAJz11TENR4A2RULAj7wyH6E6xoo/+lUHlK7UyZ20DnCz75AdHoxDXDLtb2OhetlVMJK108uTM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(23010399003)(19092799006)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4Hzx8v0VSfr+FaT3bwwZzP8RkZMTRgAT8NndhvuNGc6aWNib2hJtdRpNK1Xn?=
 =?us-ascii?Q?VNYvs0XrCWN5bBeTI6VUL7+7SqeKjx27fP+yprJMbt39FL+/7nJDKzF9g6UF?=
 =?us-ascii?Q?17pnSfCCkWhDZDYDNwwcioJIUdl4D/++saJChQm06ZwnlLpYfydzNgGjLLH8?=
 =?us-ascii?Q?6fPVyXQttiSzyTCGP4JIOV229fx9xMAnrz4Hjegi+dEpNEEZjwFfGQdaseUV?=
 =?us-ascii?Q?B8SiEEdXvYn/pXnwrEdlZMRHHBN0alRYYeSyaGYVrva8kwO0ikHnMwSILFwj?=
 =?us-ascii?Q?uHFw/J9jdeyuklL7vV5Vx2R/IZcIetvMk7imQWyEqusGCe8yCr0n66PbmW2V?=
 =?us-ascii?Q?SOp3kuR8NbAsD/yjqFSYZoDdp/p77LSu6euasvOBsNDhRS61qB2wXgPfdjxS?=
 =?us-ascii?Q?pxLDQG8pkS4PzTCqN2QJ3sGFx4766/co76geXPL8YoorPnRFpiMxAJz47xsc?=
 =?us-ascii?Q?yhVAgZLBWZv1TGfZnVVs9F3NNnHap1tp4FdhmYRyZNVxbDrpDvL3Z6wOPp4g?=
 =?us-ascii?Q?0c6jqwThMzw5IFyR5NgFgWurEr9ee6oDpR7Jmf0mHIu7kLSQd3iNLTkxkzB1?=
 =?us-ascii?Q?PRkG4m0or+U5CkRi2b5OXqM8Zrp6KHBog7CVl5Yh3z/Ldrvw+thYSEMNNWM/?=
 =?us-ascii?Q?e5emTyszaFs/HgiwWtS0m/5qShHbcYDsSNgy+DNRQz30mkaBH7EI+iP/52SO?=
 =?us-ascii?Q?ud8z7io2n2JPYX7bjWB+PbryDFf+nwk9JW1CQPmTD0Ai0UoUBjRncv3raCo8?=
 =?us-ascii?Q?yjyzUHH17kmumtwbbwoUtQ523S72WW2bZcs/ZGhapuSCOvjdOplquc7GZluO?=
 =?us-ascii?Q?DP5a2Raaet43WcZA33Y6+9qNAE6HF11kcG9rCdPm56pegSRKcApXRVg46URy?=
 =?us-ascii?Q?/PqXK9LGJaXC0wMvReLjiXNy8vWTUF6FtKQXALXWjRonWY2/+5HcSybRZ87O?=
 =?us-ascii?Q?65bSmJrbIU3sFaEs+X7c9+j7liDaPzmaTNZH3yHtZlE90JTlWovpnep4c2F9?=
 =?us-ascii?Q?uzr+Sqt5sToT9/h4UIq4E6J5qtm4yppmfSHopUzZzBAB+bCxcycTBNiTYo64?=
 =?us-ascii?Q?EoJPYJhQkDIhskUzTh+yBi+pvtMLDPoN6DpUdHC0zmz2G8D8R3mS058JxUf3?=
 =?us-ascii?Q?KCN3ki2Sonr6o6u5SP72tZrEk8bQ2Ja1vFbxuK1V9PV2wc6NKuHoxuchB1VA?=
 =?us-ascii?Q?RClju0zb3Asp3SseODF4XAiJ2qbCMzB5cbWLnlWFbzNfw/rscnRzZ24RhuvW?=
 =?us-ascii?Q?TAY8M6r1v6kHVEikbyMCgYBq/w4COnBhPo3Vvs/8/MvqG3nxOym58Z4aoubZ?=
 =?us-ascii?Q?aQ833+KQL5rdCqyHVxg7Rkqd8pMVRzHQjYDsdw0+DppPa1y+YHKBanDivUdy?=
 =?us-ascii?Q?09D/FTHobxd9pE/rGgwmw7VFv9gTEg4ehpOTNJjfO5JS6Yq12Yz0kIgf96H9?=
 =?us-ascii?Q?FfZZBkIcbAMNKuTvisCoJy4XmzL4Qhi7obdW0bxpq+uxOg3IQUYtlsiQNg04?=
 =?us-ascii?Q?/lePPENsZ0d5E5g8pdWHWNqFxQjfh6V+8a9Gw9jEM53OP9WCoWsnNlYPEXnt?=
 =?us-ascii?Q?rfpX+G/7riAOj0/kqR759lhheydP1xBkelVt+25ncdS26R3JfC9xpUG1ZF4u?=
 =?us-ascii?Q?GwUTSEJTW+VXETxgbY7vj7u/gaWOPfrnzoG2mBY/8M66Tj9XOc24IFNARk96?=
 =?us-ascii?Q?cy20hDOHFRKN9HX62GkFSPBWJtjrtNipnXjwVf3PPATvIfRXLNeiOo3zPJZY?=
 =?us-ascii?Q?aBByPwhnEFJZ6VAaS/axrKHlMjw37csahl2YaYpFBOzVD/tcbYnrzXtrJQDu?=
X-MS-Exchange-AntiSpam-MessageData-1: 2nVyY9kHc2xuLoH9rKtXWSYf9Hmtj9Qj6+Q=
X-Exchange-RoutingPolicyChecked:
	qKJayiT8EIz3BQN8/AKo4Fj6G7eorhrWio9EnSMzazELJSF3APucgu1AdT+8fmIRun/ZdKkR2BM1vKvSy/6VByXCdFvp3SHj0V1b434GV0SxetJlI3FofhooPSXaNnOsyIEA4TgMPiwBRiF3zGar+RTdK9mY9ttVdD8Q6LzZBMzrd6w8OnzP1tpVhwRJVzennsaBBpZeQNbRIJIrnwFeNndbL9Tt/ILPAP7hSbttSinE6Gt/FKTpJLrJawPxOREnygq32zd/79IwtxL1qjjuSTbCfVY9HgjXleruefVZ6rtzbIIS3r1zTYkXMNCrI55eFemGZyRJlIABe/4sSoCBJA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m+u/LhDTI5AyjERKNepgC6EXO8uRnG6el2c90RHtbIdSD/tAzQ51anUsmqFHb/jDixTTE75FislHmEjLZOEIJV5HZvmcpZwzluCE0MCzQ77RptuHpQqB0XvBwgSU9O0jYQjntID8E3hFd5ZMJjFWzRCh2kLf+snfVEBedqjOQsymJrua8HCxExpDxi6kQiODq5DXL5WJxpzhXTijX3wmntD5unHel0NsBbHO5uIVpmHxcIpKUtBbNtYZKcYcyn3mSjk9JX7BxIoI/9DPqK4CdX15kAVL05KbbJ92bG7Mnirn0zMSMIJJnyKPM3qdL9tClB9bHerU+dU1+w7xqj0+a8RXj0JlvRhiOkqj4JcSHs23+Fv2t/t5+sNsZ4Jwh04Q4xgWR0oXErMX2D+QgullS4DSRj06CXo3SLbr4kIziEM5wTbbeXUqiKuXjGihQ9T+evpBYXwoTYpPqEQexGn/MaYzpZIgQg7DoKckxeqYLE7958IFYuOj/P8MhotJsYlaAUJjxwI3yhXILqbZwAqvej8WV0lU0ALoRMOngoWdzzxCvHtgL2TXcG6/OATFmDCqaFhpVJzmZYVMBLMuQ+Lv7Zb6WlpqCICe078h6yutDr9S9qyuGsc7YV5ulJUp7eL2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95187e1-0623-40a5-db24-08df3e4121ce
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 09:09:17.1863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgFsOquMLE3RpPWcLFc6ZXCV/TGJK5F5AoIADxuV/loYonIEihbQ3/cSdfhlOZ19bB1yclaAPncNuhSlHiMgeH8zwMO0/McTh2133UXShos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7512

On Fri, Nov 06, 2026 at 08:36:16AM +0100, Jochen Philipp wrote:
> Hi Dongjiang,
> 
> thanks for reaching out - yes, I'm willing to give it a try.
> 
> Johannes asked me to keep the on-disk state untouched while he
> looks at the zone report, so I'd like to coordinate with him
> first: Johannes, are you fine with me testing Dongjiang's series
> on this fs, or do you need anything else from the current state
> before I do?
> 
> For testing I can set up a separate machine (bare metal, no
> out-of-tree modules), so my main system isn't affected and
> switching kernels is easy. I'd move the drive over there.
> 
> Two practical questions, since I've never built a patched kernel
> for testing:
> - Which base should I apply the series to (e.g. 7.3, or a
>   specific btrfs branch)?
> - Is there a git branch with the series applied that I could
>   use instead?

I think I could re-create the issue and unfortunately Dongjiang's patch didn't
fix it for me (I've only applied patch 2 not the whole branch). What fixes it
for me is:


diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3192b86669b9..3724cc0120d9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3115,8 +3115,12 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *dev = map->stripes[i].dev;
+
+			if (btrfs_dev_is_sequential(dev, map->stripes[i].physical))
+				dev->zone_info->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }

