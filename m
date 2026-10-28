Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211697;
	b=UeohPKY+DiVaiLfHphKF0jgtYMj8dc0o8Gs3uCoRy5ASuOPgwdPcp1joQKnFzxx9FrDl
	 /uHs9vpDpTFTkunTMBJCQZNjDBrGU066oKDlslQoVpVaOfTXQIeCQmoYaHPWIiHbuTVYV
	 zkjB8SwbaSJjhjVboeyKqCzpJIZIfwqCRrRUfkLoLwqGNJarDyEk+ncOOixu7BZwXZ4Qc
	 K0XXz5wN3w4ffKFeeCv7kaZCj4T3u8+m3kJ7+d46WCQQEpsHtca3CdwmTVwVG798NQvLh
	 bF/Ubr4JBpT+izUi80StHH+gO4CuhrNdVsWiZd+NXXtEoxhezkXGwDrjrkCaz6QwBhw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211697;
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
	bh=390q9DlCkPLsRpmL7VQKPID+SM/0Joqd5lNY8sHuTT4=;
	b=ZkrjC9rwxHnZQ/CkZgDVk/XfMuBnkdJcWp9nXq7e0F5FOqCjU9KGjBLiJBbKUM/R8jUm
	 eqSy1MXYObU8lR46POE11NKa7tgQymcJzaWNRhUcie0p5yl/fzkIXD6D0qDJEzow1bkTA
	 lbvTItSvil+n/U/tcHg5UVzFPFMulj+UwBssZhzTFRUMN388TKIxToj8BJb7XBES7HdkM
	 Lz9DSWINpq+2ZyuViYhhAZMC+fXv+96U6stdLhDeOW2IR1s+VT0GFSu0CKTNpS3/e3s/q
	 0xxeX3fVdm+xU3tnf4t3DB79BdcK+2uyVOZrINrKN4PlMrtlttJOmOfMJCItv9Dou0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XiWCk8xG;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IcZp1ViC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1872606A335
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1872606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XiWCk8xG;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IcZp1ViC
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211697; x=1824747697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=CPQMitNaQYpX3Z00kMNZDOLkZstSMUN7LX/usPZ7wIA=;
  b=XiWCk8xGX+ahzcTs9QkgHQe+i3jm2Dt5lwXTM/wheGKEZpkXTQS3O1Uc
   63CPw0sYaKK/OjgGznGdhbP6sGTUkLvZ2uvuhwosgHTU/cw2Wwmu137PZ
   UV4k1kCYHpajXF8iv7yAK4M6GOnEEutERRr89JFkXuHLHegLb7zc2/Rle
   YoRpBJba3L8VCSj1U57dGn/NxHj3ip7d7DmUwwT9geHCGYZkNToKMKxMj
   uHHdDxEmnHxg9hQUwCVziHEwsJhMIonxDSxbIE60RRZueKLCuMRSJTTv6
   b1XRYgn6C8WHL2qy2jYiIB7Q7aE46yDc66gqjUQ/p4VQrLLUT8dzozEhy
   Q==;
X-CSE-ConnectionGUID: vBHoqExoQOa2bhReuRdJTw==
X-CSE-MsgGUID: 9jrjHvhTQUal2dInVXCOrQ==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159234664"
Received: from mail-westcentralusazon11013018.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ohGKXe2ej5/6knEw7QytSFTvJ8njYSnE0Nf9ink2gw2A2zusxfq0sNB2chHcjCCDo9xtPyeK701LCYNe2xsiymqx7IX0bsLmT6NgspMO3/NxJfHoz8vPNiNKSigo3DrvVq89w4UwCBWNMaKXpOhVkrPiM1P4eY+Te7OA74VMO9AsIThhdymEKb9Wc8yyAvqXeJ1j+bwjLLBV8aUDQydJnNJbmC/oOLqcJ59a0skxSGIDVgZ1vDxV5kIR+6qVcG8biEel0f6AmCz1aHBSiGaGXvmIF+29Sf2MNSctlDwGZrk/6PZ+ve2kPf0/zk4w72AvlEHHfx/sL+pG0SodQFeKBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=390q9DlCkPLsRpmL7VQKPID+SM/0Joqd5lNY8sHuTT4=;
 b=Ws3VJZCiz23XEw6sGmbHR3cNydSgryF5CQqB3ESg2CkuEXwIwq2J3gjFKo419LTxBMkZha81D1sOZfDLTUReXJqj+1G92iJvVdvyF72CIWSNcaQqfHMeFaCIaWFzch4uwS/pZci79yE/rge4tmg0Lq9C8pjW6qYnH5nvU+egG0qiHS/zrwfEevDxB3VA+C8PIhxmn6jUMPD7aHj+/BOZRKInmTJkt0Hevu8mnIBz+kN76UHuMsx13Hu6hRnK70CjYD51fpQMFPODQBCzutm0EkiPpw0TqX1a4zH4LwGDPwG034KqMOLCIUTZ1SgP/cebQOEKccSZqIHVELC3TcO4+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=390q9DlCkPLsRpmL7VQKPID+SM/0Joqd5lNY8sHuTT4=;
 b=IcZp1ViC8na4V0JKVVzS/+od5eS5+h4EnaA9zaG+MH0l0zXTb17SIxikU46DWAJUWXrm0KjavevMV83XuTYM8FdJ/cjQCZoyjB2MCINZJdC+5zdpixe7w2V5RvDmesZINemMDi3jXkW+ryNSvs2moNa9t/DLCd1Bz88K2vpxO/Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB8753.namprd04.prod.outlook.com (2603:10b6:510:234::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:33 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:33 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 04/25] btrfs: zoned: never activate conventional metadata block groups
Date: Wed, 28 Oct 2026 19:20:50 +0100
Message-ID: <20261028182111.160492-5-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH7PR04MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: b996f0b4-cf4c-48e2-3a5b-08df35204b80
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|10070799003|376014|19092799006|261028144727099003|11063799006|56012099006|261009223027099003|261026140227099003|261021121427099003|261026121527099003|10067099003|261022105027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TfTQTED4aWJdKBk8KDxU0Ew4hOkgexJhaTdsQIQOJjMvuzzkhnlM8RmEPTTzj89/VI3VhOw6lxy3rZmZ9dFD8xULYEDBpRXBPpIkEgu/bZ3I6HHBNEMa9gwuQBfPUZ1Ryi1Y5NoQlnp4ZTQgY0luh9o9dmCgxwycE9ih3RXa5s0EH8+kr1Ta/zCEXyz9R59pTgUxCYi3zEaRRm8xNzZHNH6/BwELBP1/v1hSWe0eKD4i0q4KIXtN702TIZWVEMOQa7MS3SHSzziNplf1Cgs5SOAWZut+b77MH7otdRFh7WbhkkePwum8MaFuXAEv200dKLlsg2AaAEtv+pCsmNQubV/z0B+6+8Z1bGnNsiNWbbYXhFgbxQNsEoz9TA5z4dXFMog36oFK5VTpfXsBQRx1CwxNPxInUBRehDknsvKWUah5DotN/kvxb1+ZHyEXiwmWt7TkfVHGDOE+Oer9O8GaQ5zWuWaJGQRG2veU/toLyRzWsaiybLMXoHWPXu5us4DEsS7V3S0Xl+Vlo/VCYs6VaN4WMklBFj6sKx4S4NCkP6mgByzTS2R/Sor+NJCvcTjmoY5di9wRfdbTBOu2LSrJSqAxfjlugtj/zNGp5P4TN4fahH4WiOYBYm9dsTuDQln4eBKCaSpL+ZYpOSn9clvyRc1G/NXijHNDA7yY6bhpiSc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(10070799003)(376014)(19092799006)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026140227099003)(261021121427099003)(261026121527099003)(10067099003)(261022105027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+oQzt8KRfrRF0cdVoj4HO8sFkOb/RT9Im95Xmb2oeg/CCHUWRdx5zIZ79j9c?=
 =?us-ascii?Q?OlCOMcBpwZDsjsAHZOdQ/zJqi9RAvmjGxwxuV8yGAqU6EfO6512eQyROgye1?=
 =?us-ascii?Q?iRu0yFVgWEOQ+8oGqGcm/SJko4/5az1EKk+0ndPHtXBpWQWSctSBeVyGjoLA?=
 =?us-ascii?Q?DdAQv97B+FFWIgQKsZoKRYIeJSOK97BG3biWHQE0BD8YV8MLMiNSI+ivZcYv?=
 =?us-ascii?Q?TDudeDs++J9lCZM3yiK4CGwwaiInt+sH/ENY0iSSWOvTsMNoELHSGRzGXfks?=
 =?us-ascii?Q?0tGvYUU+xeUDAJ868iE6RZ7E3W+FRAzbGbkzVfVH2lJKF9pOWNMql94twHfM?=
 =?us-ascii?Q?DcIs818BK7zP5hBB2v9Cjek4L9yjKQidEuGP6WDoYtK0kEGP3eOy+/lx4a2K?=
 =?us-ascii?Q?XQn0I+VG0cCF6UoNOapXbSLZZ2xZRNQrgARTeumU7itT07J6H1ZjZN0EwnZa?=
 =?us-ascii?Q?dY6zHNKD7h9JZlsoc7EM+DF1wnFzDsxlUMCpi8U1ulPObX6y25ineeaW+ZY0?=
 =?us-ascii?Q?bERFMB8J+wHs+Ly2AvppzzfPnW6hcQM67vcmAKfQopzAyOSJ8f4MGa0tGtr0?=
 =?us-ascii?Q?HKKhKGGvnCsKhd03WxvF5deWTT6fURQ3UspBFvQzrs9XyWDcS6nj/teEu4j3?=
 =?us-ascii?Q?Fo2ckN+Us7GbxMe/7wFKqMMD4Bq/95IJIYWpphQGXFTv8ryd2glq35UjVLfn?=
 =?us-ascii?Q?RycR/XFLweXcZZlXBBHnKyEUodwn0f6H+7DDmYyTqApTD5WX265aobAoxY+/?=
 =?us-ascii?Q?+EmOYf0YjM//nebR2YQDuXlLo1hOHUO8m4SQvoeuzf4r/cHgz0EhBNFRs5A/?=
 =?us-ascii?Q?SqS+Ry9pYKmNx5ZY8ATK243RThsN0c/bcmwAW5wZ/3KfrW6yQ+ctTeTRe0QU?=
 =?us-ascii?Q?bnRw10Sw3cnbbQaTQbjk2dliWq3qClYwLcnbom33++ujRZiqdXeDW/z0yX6N?=
 =?us-ascii?Q?Uw9t1lg+RpLqq1/O+yjsMDNm9oWYp792Sh4MdDgEtVxRerPwLAriT8w/JEBK?=
 =?us-ascii?Q?yJ1yK0u2+wHdKJZmP7lD8K5cugnuvrWm2+R9AIr9BaCGoL+H/LaYC3TDdB7f?=
 =?us-ascii?Q?Yb+9k+GC9SrhdsY0mDfb7CWTEignlRP1mm693i3sxUhMtHywO5yHyf2nHeVI?=
 =?us-ascii?Q?Pd1mo2R31Yphi+CDSc5M1XWtXHNdkgzD+a/NKaOlG9/lyOH5INLiyZKlJAGg?=
 =?us-ascii?Q?C/PFEvHgkB2uTqJdfeRF4ppVhyFeN94MzBC+nMOo+BZXmTbL3NHUMW0WzyJo?=
 =?us-ascii?Q?IBE9X0I72fHZzIcU81MK9VHNx5CBAzhUpmULPKTUTaoieQ9IJiQK7M8pCmAP?=
 =?us-ascii?Q?L2rab2XwRc1QxdDsF291SD0tLa/MNjG2+Pr/uNFCm6MdvW/6RCkzD+kNo3e/?=
 =?us-ascii?Q?vYdVnQM+mHUe3ohmaukpxNvkXV56V2+piUMG5EwBJqsi0WcyBwfBWiYx33yD?=
 =?us-ascii?Q?rYJ5Jd5DnYtlqMac/11n3eaW2WZzLS8JVY6fu/WXk56Yqsui0AjkI3ZUWSua?=
 =?us-ascii?Q?eiB0g17w/oxryF9XuY+MC4TPboSqLVfYUeyBhQGVk3lnakMfaKhoeToh2kry?=
 =?us-ascii?Q?z9m7RwBI3MNt76r++8yJT01aNlj209erI3mncFYS4DuOCSl+viFwJPml6cMU?=
 =?us-ascii?Q?8IHjF0RgzYnwfTG2CB0LpziW+FQp6Xlht5YEoP11OT/zfzDAbv2lCnpaxkrQ?=
 =?us-ascii?Q?yqnk/4JWYmKaWFjbZyR7TUv8QUlcdfG9tf3hBooxO2mU6BEoIlUmbOqrPyBH?=
 =?us-ascii?Q?M7MOIXgB1Bp10r9J3dKldjULW219w33hG2iSDjWtdvGXTd3fIMzKXK5g41+J?=
X-MS-Exchange-AntiSpam-MessageData-1: 4PUwAPVWIvm/tmj64ooGROE/+Cox+dFqEFg=
X-Exchange-RoutingPolicyChecked:
	z5XUJfDQSKBmlcr4CzEQMtgfVTw3aPyEKf5XIMkbKz5kZANdBjwNyPP7kx9i9w0n7gmX/6Q2oFeNDqyddkepNMm3ncIwRaVbcte09KyZWJpsuwg0qC89prx44L4e9gc3kM4UpJ9AmRQh5mFZnTKBJBY5iwUfo7MIHYG0TetnPRah0o1zk5OHNgP9AVNN08e5tdCdlnTotwP4Y/VxfwsiO6q8aoxmGhNLVf3RnoCmhUase8+DI7IlJ17Ke/jkOtLHJ6czV+k2+mo0h2g2BufUqpg4PZSjzdJyrhK7uOLlI3Eue/9uNBgSiV/mxV4PMqXsD7bF6M0etCyKIimEjEJOEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	arQoTxtKV+lVDHZTJmlgADo3d/bwqEX/4K7iDOMU7qi1bRXTU5Q+lBzL3rr4xgPdbcxuoJh1xDSCl05MfmeHcG3UNVPXx8i4QCdOptt8LLt+WXMIc9T4b1NdEikAjlxs3NNGdGL1IPNjW9qBIUfRibAALod/aKn076VUiMDLMRlRpFQ4cF/W06fZIKpinT2d1cKf2z1jkGEIiycBKszbHJJUx0O/rSXQzTD0F1+2iAhi6r/SLwI1eKutFp7H5qPD/w0J/RRa//VwSD1uf9p9HcuLbS0zmSJJK7dYZAxSqOVVlv5HSx6YPS8d6yDvjfqx57XdCZxmxm2iB9rBicRizEsR9Zs4oS5i7pRZxXVQf4O3ozuNKuy3kwAdVLkByMHdt6DpsWdDXOq27qG0Rv+/mwzyGjvCaUPo61RcUrgtfulXVPuaS4fpJAMk0sBRSlP7syQUvkds/pPnidic9V7PHca7mA89lX0Wmw0KDwqs5ad/EXyO/H46bLDUOANEVUzHzKnUIa0wgMWJQRcbJySsmxT3VCRkJZkuvPkV/rjovS9rAQ7p1JkOqFG7vEln1ugMOPns9WO71oDUNVIvMxfLlTm8k/1XjhmmISVSAy4iX02e0SEJaJN4gSVHMGWWtKpT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b996f0b4-cf4c-48e2-3a5b-08df35204b80
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:33.3198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LU3GqpeA/XrMamyvx71Hahe8WIgbKnpBCzHgiz3fpu5QzguTTh9LVlKIWFEUG1HCZ8I3eNKbGirxDd7diiUM0GidF2c05wBETTssquGOfgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8753

Metadata and system block groups backed by conventional zones only are
written in place, so they do not need a zone to be active and they do
not consume any active zone resource on the device.

Make btrfs_zone_activate() a no-op for them and skip them in
btrfs_zoned_activate_one_bg(), which would otherwise report progress
without having activated anything.

Such block groups are still marked active when they are loaded. That is
dropped once they stop using the append only allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index f2d99fe50ebe..554688fc7030 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2458,6 +2458,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -3070,6 +3073,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
 			list_for_each_entry(bg, &space_info->block_groups[index],
 					    list) {
+				if (!btrfs_zoned_bg_is_append_only(bg))
+					continue;
 				if (!spin_trylock(&bg->lock))
 					continue;
 				if (btrfs_zoned_bg_is_full(bg) ||
-- 
2.56.0

