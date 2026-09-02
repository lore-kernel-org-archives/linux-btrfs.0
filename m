Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34F24302FC;
	Wed,  2 Sep 2026 09:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788342976; cv=fail; b=EoRMiAQaBt0htJONNuomjXqM6kDjR1fuoYibwziYja4qdAYdJ3Y8YL5u0W+hRBIybYqO4XFwGGIr9Jn3egrRIzQuy7PFEc3Xf15a12XGg/Mb68DGFH5373I4xIyuyIjyjeYzeF6HfCeAenuf+Z5/kvN46SqSgouD6LuWyVg7CjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788342976; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CfViTTZ4TSh0+MMqpi4jKud5ogeplXmB7YXIL8QlqcybwGfjmTluePvzZFGGGYU7rH9M+V64B3LARn/ZQoGqUCWUZ1ufx8kw1zEyNw23RKSUrjKDRMmpC8fn7k9h04u3LtdaVXy/u7SCeOL7onheoUSiSoYNak9/C2MeMqQPLO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VKl4NVQ0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=bWgAwQgd; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VKl4NVQ0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bWgAwQgd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788342973; x=1819878973;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=VKl4NVQ0dIstkqRaz4cnrzTiGtapk96OB4bRqG8i7p8e4bMhblh0mbr4
   odzbDxSQp0oTUs+zqXgnK+pRWqONduETMpNki775cg5wTNQ/ra5/7ilzf
   WK/nbdXPOhDyON8nOa/qS96DszkMfSmnbilcOfTdAvVPCS1Ju1rpXyHNO
   jJ0EGCwlqeF0yVaJvZ5xuGi5gxy2y5ZPyf8Q0YTRyVJf4K48vJYQVxwO/
   RNyXaVpvHM1wPc53uT0Q/2Z2E6lYcddUUgaxvLZlU59OXmsSWqf84NUap
   hB09ylhWDznMyCorgaS7Jc/b/rHlPE1CUBp/BCBID5iVeaETpCYVCa9Fx
   w==;
X-CSE-ConnectionGUID: 1SQIJghwSSalF+TiXYWYSg==
X-CSE-MsgGUID: 5cdVq2p5TLyPxvPoINgSew==
X-IronPort-AV: E=Sophos;i="6.25,257,1779120000"; 
   d="scan'208";a="155696277"
Received: from mail-centralusazon11010062.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.62])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Sep 2026 17:56:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiqOBpXdnOBfJK8N+74asnoxh6opPDuWbwmJ/Ezxzmn4D8pSPCj3ekBou09xJlcUbngltfjvO4mG7tbG3EqGsXkjcCAS2B7oeZ7/O8w8A+1GfD2YRxMl3v33or6yxuk2RnNxQBiOiw8eJaOPV91issymLWlarcjrpeGsZfhnU9GtisV52rWSMpznOt7Zf3jN9SC9vgOSYaeT22rO3QkiC+yrmdw98cPQgM5R3RpqZnoj/ChYfwhTs7LrAdcMun/gR9NsqQbRW5EMAVATj0apW+LXC4mKSVs/xrlCTN1I33trOlWDbDU0nhiZ+xrNgJ4LlOBhvimcxAu2T9kSPxcQKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=Ae6I/TzScjT3itBhbKtSBySzdWDhaxfglbPC3T279ndalAD5Vfs/kYQGUtlLZSMftFTNp5FORFy04alwiF/sK4KNEDvms6WLbsFFDXhGjPGFF4mrkLjXQ7XLKYgV8g60NO7s8nhaPXof7zi2iUy1GmYIXkOb5Yu75oj5XdIhGQ4ImgtVG0xYBXHkwMAng4mRc4aUQrjiOi/QLml/bJ6e3Vd7LpRMZrVjyNrXv7/F+A7KHYU4jjzFd76Tpuit4c+zNSc5FtLXGRACvfhr95l1LI+y/O6VxbnZJVdIBopo8VuXEWGFgv6fvbd1f0zymdwd8UGnaKJhz0po3ovrQ/phBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=bWgAwQgdDphifYXGPvqbbwk3Z/8528HTQQmbvooWPtiDmMb3XFWSykwuhEG6scvwspLSUruPidxjiM0n2Lum9BovUFWuU6g5y9SBCKmbrMNqw0mF33Efg+k6JZScEzIFwfm2SHvcFlOXkofaPQcXXbaOp4POxJqBr7JES7B+J8A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by IA3PR04MB9378.namprd04.prod.outlook.com (2603:10b6:208:50a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 09:56:03 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 09:56:03 +0000
Date: Wed, 2 Sep 2026 11:55:53 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: clm@fb.com, dsterba@suse.com, naohiro.aota@wdc.com, 
	josef@toxicpanda.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhongling0719@126.com, stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2] btrfs: fix use-after-free in
 mark_block_group_to_copy
Message-ID: <apfyk1BTmN4xyeI_@mayhem.fritz.box>
References: <20260831053801.51572-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831053801.51572-1-zenghongling@kylinos.cn>
X-ClientProxiedBy: FR0P281CA0118.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::19) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|IA3PR04MB9378:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c527fb-d7f0-4df3-419c-08df08d8663c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|19092799006|23010399003|376014|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	7/ynR6mHFhAjvoKkJq3ekCfA0xDnxK7UWFFfuZbZ8UgcvW+cBx1rpR9iayCFk5NBEvAYMGJ83f6hpogLvMG0fVCYjJfX8VT1N0dHAq3IiYlT3lPJwFzuKuF4Qb1Grm5E6vG9qSAUXRLCZX0+Hz59c6MrfOe0dhga84wykyLKMQH+Vm6DzKw5u5efJP7MFfBtYSXkTwBGMoMPvNA+EJfO+Y4lR15LVR2gGDa45UwRMZtdI4scIrHbx07utPhvR9KWIfVmw59ptM9CGxOiS3pgiif4Y1qrmBqc4CiPwrFpdzhehZOlssaD4myRDN7vctJJkN4bbkkc5nc7tjKtXqCrOzyh0fyXrjZp1nPcNrXBj+9p0v/JB+nToUpazCBdhRuEzQbWK8CxCAWkw5kvx9oaMu1vTm6ppkPihRQZtCxgS22JTLajKWlO68cUBl+oHE27ATx9OnJaufbmLG/yrxNLUsE9uYMju5ZPzhA47qtkQ7LtElAYDbVV5m/kgBwV0mgn+28iFjWvE+7EeY0FxXN7yl1QlK0PHibFeBPLq2L+ORFJybtreUbLFIVtGZqqJ8fCOraB2wmofPRsrpg7rKhIQpfUKCDAzD9kGOOXehn+E5k6MDPR+Z+pcanT+Yn0oKETV6bdXSCy3BqXxn3KXV7nhQaF63/NTUFFDCE5SwRSZEk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(19092799006)(23010399003)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9cApFhXNxRESpgmX80ydjcoV1/3qxR/dMduVTMx2iC0fk4ESi230LYrJ5ywx?=
 =?us-ascii?Q?iPuk2ioHpyxbGe1N8Sz4VdMdJRkkRjd7IiwzPKh1pNQAcljlIk9SaoHKmHx0?=
 =?us-ascii?Q?NNdC40E0yTXHSYn9ajMihiZXwwZJVhpBTT8bC8oyc4SSCpWEJKfn1xocnZ0c?=
 =?us-ascii?Q?PgI8VvQQJiEqqR1X+42/rS4UERmkQp/dEshIaAqLO4CLWtXCkNlreORM3V1Y?=
 =?us-ascii?Q?XzpoqaT4/jdMv15eMknQTx21W4H4QmFS6NlJkBbAkdsZlhEObyYSvuxRgPRa?=
 =?us-ascii?Q?+WnFp0YBDD+QSjga7+XPhDi7l7FbkCdtOU1C/xx0gN141LQTzOFDo4hRpFmc?=
 =?us-ascii?Q?p10rDW8rA2T4YsurMRaOsARxbEMFrPrhii8Whu5ewFIWGV/239BjtclDvD/U?=
 =?us-ascii?Q?/tXBiJA45F99Tm9065qs4Vz9px7q2GKetcHHjrw8kQDtiuhPFFMPGzMXLTIV?=
 =?us-ascii?Q?dAOE9nC+sRExSa8VLFUwtLtLf02XjrMmZHWIE56IMOzj3BFxmP+DtATC1MZO?=
 =?us-ascii?Q?4pj6mqfIwdETCvUrZF3m4CIEh7gL9a9zmmDx+DkcOYBGyHjTqt2J4BMDiSZu?=
 =?us-ascii?Q?Q6whml8ugTTXiLnTr2J7jqPIFx7dlPAs5k+PFuK2dGbwT6LVw5zMloWRTe7N?=
 =?us-ascii?Q?kqm1IBd6VY11mRj3p5gKcz+OiyB+xhiwY2ZrfjxW+iQvomkLztClztr5kMxe?=
 =?us-ascii?Q?gxj7x1kMMuCDzVXJmKls0J4pGWWIiHqRnda/09cLOuJQz2j1ldmMR4XZn5zI?=
 =?us-ascii?Q?zmaxJ6VSWYO77rmaVzTveO88E7RGXG5kHgmkKNgTuy80jtU4wC/PJStG/6TQ?=
 =?us-ascii?Q?DaAY3ayRXzMTUZOPBQQo+9S7TVzSt2Bu8t/dicm+iXzQCLdOA0kjSkXpoU8J?=
 =?us-ascii?Q?jR1rjwAq4Oa7MXSpygChg6URE1XzgFXWGxNfZzOXFUQCUmrnZl4fNOHS1jtH?=
 =?us-ascii?Q?Xh6sNpwIr5ymkTQT95OQsjBSusZ+vow0140SFRm+fi/N/5cAt8jTubXvNFm6?=
 =?us-ascii?Q?bRdgp0lFL8g0LIZiFr1hOfMBMcJfJY9x+SdcNG/5dKjve0s4g6CCb6oMNgBH?=
 =?us-ascii?Q?1+ZeWWHdOuTvKVP9ZcmJsuxrnYZ3OKrbXSLa8XCboBAw0Ka9psJKbfe6kR87?=
 =?us-ascii?Q?XMJK7kzNCqx2rPEVkMV3Fg4afaQ7gwGEANoCSbzLZyhDAxXXqQheIF2sKNS1?=
 =?us-ascii?Q?AE/rsOEI4r0JUOyrr5oLMt1jqtt68bT5CBcKOhE0/fpOTTfe52PYG9wnqOh7?=
 =?us-ascii?Q?HKZaxNAdbN81QFmONJ67J7OG/ws4eVaFLxTVX2i2gqyUiTY00fyyabEHk9gE?=
 =?us-ascii?Q?lgr2HARuz7/yt9f6gG/Q7qkcPN6ikHMVTNPEJn5r2F2G1Q0QImG40DtiUr7t?=
 =?us-ascii?Q?vOCzOZy45j0/sKDWLIq2LuLzcLA8RqewjnxeN5C9j3CcaYMBh8US7IxqGiqN?=
 =?us-ascii?Q?+EwVOQkphtFln0e7nzudeP2bkVUWqX8Pm78GONewQ8l5tl5QYCgA6Hb2IF38?=
 =?us-ascii?Q?BURCPQocGy3SQD4h8jOwQv2PiIplepdGFiu3WD82mzcqK0tfvj+tJMSxK28F?=
 =?us-ascii?Q?8siWPFxCvJSnlcBfoS3GqnHrVZcfxxCt7xlaq0ptovQR6JnUirFWuS44NoQP?=
 =?us-ascii?Q?6WZ6FtGcuvHKTfXYJYPc5yhcnDkEFqV8WlwNAm4Ejb9HMVVFOIrwF9/ya54I?=
 =?us-ascii?Q?jrBEnU195fiOp6bV5BDu2jS/uODMyfZg9/rM9J1h2bbqE1/mILGvnc7j9YsY?=
 =?us-ascii?Q?r3TXND/BQAl7J1SJPooyADT+S03gH3lXYDgSTn/NtDEwUN7A12OlYSh4LxzU?=
X-MS-Exchange-AntiSpam-MessageData-1: EG8kuiH1U2aYBYQZq7GSJp61Yi/aJd9IDus=
X-Exchange-RoutingPolicyChecked:
	O/YrUeMJVZktffxOY7K/Ib25w+MjrgALS587p8nlqAAYtDzx4OBFQVMieL6dJ+DP7CGKayAh7ON57LmbpIaz8RW1rz8QGAlHC+1rZQeYca9q7J3+Av2fUB3vb9iqGsLqg1nU6l4kcLcoENP7tWRew3UJPd+XlF5inJItJz1xn/e57v32wtQ6KEOqTGtyNWkVRNHw/GaTO6azFXusE3ehBwM0BHauviZO29mBXe0/kcwRUsbet6lYy3AK0LVOh4zC+7PZDs7SPzqim89bDSAgrM4tCy77BYuZECA7GbuK5rqXocxuG1KxOjFKyicraYxSgGxOOnHQdZxHYC/1LV522Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mR8M815LMtfFDhGXqKpVPKVQPJ2tRRvVI4J6OaOh35VYdWBhhuHK6yryCv02ZyMBtWfvWRETWBuyUXoQcJUt1Ny5R73yadKcqzZU2SucRIQKPElFjTnhrsIEre0NnBf5DPmg0a+KKCO1OHDBigqn72T00zj4OKDIttWrtwy1qKc4B4Fh17Z85SCtRLcBdRzCf2SAvRAc2blGgG9ryQrz0XWgCspTYn/xkMNaoxopY4uM0boccdM7TEFRLK7yPtOJ6/SlEzNlcaVLM1R+gwVdQmfh75unik0AdlwwEhNwm6aEzIkZJp1SSM6riZXwerawY0q5VjLWhlfcZLUIS7Tq/hGmc7ntzPvQI7pDm8CfDxLRkxC4ple/ldougPJTw36VYWwG8alb5eWDnu4Ltha/2hsxdhwrJoTATatyvURAQPfI1ejmBYUYeRQRv8WgzRhB99h4G/eFxbVKZLVxQL9QI7U6w0xf3k7u7TQmcwsAcsUnV1+AcYtJrtb7YHTVgPsIfJyJepk90nxiAf/q4zE09diO8gSxaAzeKPSNckyyZn5xa6fvHFAnJ5NCJyU3FNg4p3E2wubjBK3hnw751UKKfdrvEuZdzpLAbSaJaMR9zVjNM7N6JEepv1A1qwIdRZdC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c527fb-d7f0-4df3-419c-08df08d8663c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 09:56:03.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+tSytA6BEAx0JMDSHCG4nOJuAQxNdqW/cB8za7lIk/oR29DDiSZhKkcCfoqNHchZwcTb22kofcI+BJO3uuoyRsxD1xzHoi7UaHbjAcJrrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9378

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
