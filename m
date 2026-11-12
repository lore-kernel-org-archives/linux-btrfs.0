Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794503539;
	b=xvmPp8De9YJLEVZCOV4uwpTYpcI1PcxbDRUR+O6ksr31nxTUa9+DSFmR0V9B/yk2a5wx
	 FR5Q5sPh8ER7tvXgk0eDbajzAgeq3GH7XZ1OevopL2gqxYibCnMLinU9zQLo2zShIP/UE
	 zhE6hrsmBAzXyMTUwwcPpm2otIxi2h7VPKOXhcAGyU+bKLHqKED+sMr37lq8qUQ4JA1fc
	 0bB8ECq+KE/qDXwVe6SC3/c4rm63Wu1cp7ohQr5fIZ/ZemOts0cIPayx0RzJxxui5KFX1
	 f1f/dAIeXR11C01PUc7OzAvZytUTZ3eMwCvWDRZmLihma5YDQDV77i0Yb86n0tdrcfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794503539;
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
	bh=/l9WRHoddJfJFKPKt/vNBHpMtm1OJBFgkOV9dcTiSDo=;
	b=lrRUuo+zSxgn/3PqNG/zgL5MnuxBpDQLHgZ/chnOZd8NkueTCGrcBjFvn9NXz/swLhij
	 bQleC+glYLQ6qLHOHD48TyLEKM7jtEXkBtt1oDoQtgofK4uBvO9bfHJp18LVs4sW8ogXK
	 HrqVvONOTK2s46gLtIZjWcQAt7Fab6wnf49hW1qHkBGY0T5FtKiOHVjgbxymS06K9ZQrB
	 jYf3XTPutNoiprmmg5641NtT/ifX3cAAH4VewdoYPOCk3eRp8QF0YEZIoH8/DLY3gk7NL
	 5JMUbICejYBpV294BpIJzRT0RcJDk9/zXUkjtr5KogFo4wsQ2dGNVMNpLwC/k9mrLRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="k7b9B/ZM";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=b2eSam9R;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C18A606A33D;
	Thu, 12 Nov 2026 17:12:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C18A606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=k7b9B/ZM;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=b2eSam9R
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794503539; x=1826039539;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/l9WRHoddJfJFKPKt/vNBHpMtm1OJBFgkOV9dcTiSDo=;
  b=k7b9B/ZMdncZZuOAOYCj0tvK46vMeRyIOjCENx7YR3OlidulkuFLYKvF
   Wodyf4Cv7BGD+pyJR72rCloNZWiMdGW78yAfCxRDLWZpBeGcNg1G9TN7S
   ssP4gHGtRr7JEhsLqJ1ISfZtIKDyk9a9GMp0KR5gZzmKOf5snyfrrZZc8
   5x4F20jsoCH6Kig7G2kjJCs9Y0HVpFSn/wh3oY8fNfakOk493Cma+3NPZ
   lvJQKE1kFZ3ppQpGq6krcbuiTRIV67gSEI9ZxnEDYbGGpukke/mbo46bu
   VZbb3QBQDAztp9ek2iuOjLTijWbA0ykFYFQEaiZhOSC4MO5Kqq1FKH/t9
   Q==;
X-CSE-ConnectionGUID: uvaIbnivStezHpsYnMeXxA==
X-CSE-MsgGUID: PvLzjGsZQmqlRf4o0knD4g==
X-IronPort-AV: E=Sophos;i="6.27,210,1786982400"; 
   d="scan'208";a="159137628"
Received: from mail-southcentralusazon11013032.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2026 01:12:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tlwvzOoxIr+l4FvBaOcE+Gb5OhrzKiyHOQ6j6704O8dcRI+9Cc7yTO6q2G0ZJDrK0BxzQ9GpEXhkDGmhlYbO8vW8R97SZvz4vMYGphsSdc6wa2MaVXRNK8Ja91f7ap8iw967BnkLV7ZHCYQkaKvTBemZ970AUoZH/YGQBFWMys00KN0cQYmGICe0toLUeoYjmV67ehgpUXrCCvqRJHXBI0hMTzwLtj4pzAgHW364mTayipGxPEBAreAMjEozqG3kCw86aPQpUT+/iwGavF2Nr9jVoMInKCkaiphyFsUReA3O+xdOAC0sl7We2PgltZKHi5QjRlrQBPQwkcg0fmXumg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/l9WRHoddJfJFKPKt/vNBHpMtm1OJBFgkOV9dcTiSDo=;
 b=fnPSWyy70ZBnmZCGsqxckOhErrvAX3C5fD1dqnhYTt4WBi9GtNiRMTSY9qA9FRQ46sZmWfNHlOIKWYq0jwFRlg93bDCFUyoJ/ITMf9V6W1lyLKU2VnhUx5+AvUCmRtD5FOQjaqAlR913mbCBPfB9Ug2BrOzgkRV+ZwmjryHOfgaePwlUVPsq3F5qktoSxEjldV1MYX2YHRDL43G/pgDEWovbaP+37dk1okFkw3WY6qd2muEUl2rM5GZ5moLmhOsx3aRvVoYOAMDEJfwy1NMdDy+JAjiPXPF6kjBwbX2vHesOq4/1K+bPGXLypaFZtuqt6eT+2UHENLIwvAJv5L9/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/l9WRHoddJfJFKPKt/vNBHpMtm1OJBFgkOV9dcTiSDo=;
 b=b2eSam9RBnbeamlAfAv857C1hw2XiKr2s8L1Szsr9AFZkCacxYDj4xLjB3rc+KbcY5IjUHLrThfn8ctbjIHN//C7Kq5uIsaj1ub673HINX8sDStnUjzMv1NfDWDs7FaR4olldkgYdr75Yol6cxUWM6ATpt/IdAr2YDHRYroCGBQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by IA5PR04MB993662.namprd04.prod.outlook.com (2603:10b6:208:602::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 12 Nov
 2026 17:12:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 17:12:15 +0000
Date: Thu, 12 Nov 2026 18:12:11 +0100
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: test an incremental send scenario with hole
 punching
Message-ID: <avXzTHKZIlfu2oAC@mayhem.fritz.box>
References: <233845be4bd0fd12b4c62b5ca5243ec1ef4d44f8.1792613768.git.fdmanana@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <233845be4bd0fd12b4c62b5ca5243ec1ef4d44f8.1792613768.git.fdmanana@suse.com>
X-ClientProxiedBy: FR3P281CA0038.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|IA5PR04MB993662:EE_
X-MS-Office365-Filtering-Correlation-Id: d8003fa7-4e65-42c9-51bc-08df40e01995
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|1800799024|23010399003|10070799003|376014|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	cCsCZjCWHtXvm+ddJ/w+y/l0wZkrARwtEIpGRCcIq+QGe2HWOYCMixCtagIKZ+BapIHXkMiquFuDvNoKJyXjJJPMfvxtVj2/lJD+yClLhe6u5QF0dYsfA/Sq6bfq99Ej+LUy3xQy7vCEoVmlfb3LUen5UB68ISomrqLYjEvY13mjQaC8730RuaRvy17g/rfa9XR/5E4sXGt25WKJf+dkr1PrmXum+IR/5WmTRjbnazuYgT4gSgGFeG8onMYM/7DOj6urR55odfL2r/wdDbQxhZszdxWTMJhK7ZSqCQ2PtwFDStIvvzpwlsaUttF6scy/6lR6PH1hR6XwpSvTuC5f8K2nZO1UbGvlr/5/VMXoCnP+4pqQgRTZO0moBI0u1Ghm9EQfSuXL3WG23oDI9a5Va0WgkvkRMnCtlG8F/qiHSdpbJh/X8M3qFvqvw9PFffV2Bu43OAJ2r+PqNY7IP4RpU4HsOtMd5GrOpSRaz2QUUvgEGyNaMS+gHElJvqbsVr7v2z/+OYWuAmpUPtS2cnBr/Nr6Tj1FcIkvTfWc0mKgqStI4Fg+tfqd4ETcT8TvLUYd4q9BgL3Cju5AB4BxoyVaWeHuJSOHKNcaVivX8cGf8ZI7lwCs5JjJfnPJCaKkFk1hcRbDDnOI8QdylZGvytAeW08+VA5Av25JCc5yc3nUbPA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(23010399003)(10070799003)(376014)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xXjRU/PuTzoREGktvn9dsvvl7LwxSKxJvx3p1c4MT23MLlViQ0AHew1t/fAf?=
 =?us-ascii?Q?dBK1HSZdh8nrlxJ+GpmbqFNu3OEEiqDwx135fZ1Q68doFTrXWIVC7Kr8uwzI?=
 =?us-ascii?Q?BeAYyLAG56O3S7M+9ldmzu7X/EfzYZTq4SNch7nDdltkALz7laU2sWAhJYqZ?=
 =?us-ascii?Q?dmyJlnoJxHUMV/QC0TkNWnwjVP4rPlqphIFaL0lL4GAx7B+hwztzUisVdk8H?=
 =?us-ascii?Q?Ot+8MeGe+afwsMuKvCDldCeGe75tmskOe7AlsHdZwr+/o4phVo+KwbJa72N3?=
 =?us-ascii?Q?sr1xZbV3I82YWkT4mA4uw5GUSOkV+F17OXnR5XOs3wgn/XfjL4WJD+R2dSLi?=
 =?us-ascii?Q?RHAopqmLKmAzL7w8qNfcyS0Ispb2gQZF6GLxf7WBLGctBIOGx2yIj+8yj2PH?=
 =?us-ascii?Q?SvSBTVkUl9jwlcKlYH39FYwK7Qwj1dWpC0R0/68BKJ+z0q7KhlXYd+Utd/NM?=
 =?us-ascii?Q?Uu4wDbb4j7htFNg1T8ledhY0z+X0kg/jVka6MY5bAbhJPWTFfADzJ8LNTbEB?=
 =?us-ascii?Q?9Xe52Ayl8rob/b20GIK7daLjdHjuFYcHn5JP/uRZWX9DbkqjtMfDm8aCHVhf?=
 =?us-ascii?Q?P0yVCjwgcAh4XWtoFuG5MEWIJikDgfpvnTRK1AeZdx0A3HtSBl/mcqiYGMBI?=
 =?us-ascii?Q?QbJjKWgSxsnAWIHf6/Gw9Ku7KKb4O8OLfDxb4FxsUzOz0gDA61WTUTeR6JB0?=
 =?us-ascii?Q?NzsVJtlTHsXBpuwA+fDkjX+NnRoMh2/Z5mUyEqTqIRINHjM/O4QcgLLl+pWV?=
 =?us-ascii?Q?ZXhlv8PtS+n6Zdy7SYFk4JzNPz14YvjyBpfQ76GkkP2R51TcTJ03M5A1hAIp?=
 =?us-ascii?Q?HN9cNQIcs2cDyKP8aznlujpNjN4Vx5ldjJPqRuWxxJr+pRqtHa15Ht2QmwWX?=
 =?us-ascii?Q?oO6Wi2MaSpzB92V8K6n1sLtzUrU/wJYe/sPAAvx5Fphl1ibTYUCThGLImetX?=
 =?us-ascii?Q?pkqwxcyXGGROLguptw+bGLq+j2uz755eWOosQiX19ZVdrQxCUPzvLyzEYSgs?=
 =?us-ascii?Q?y7qcBjWVv3BS+thWc/jL7TpUuF2QURlFNYNkL0pKDdAVGgV/ZzYQAD0+cXes?=
 =?us-ascii?Q?Hh/xohtssLVA0Ihhif1AyVPmmtzozOF6tKZb/Qkvp/iHIzxvlKzjzpaZCjIY?=
 =?us-ascii?Q?rpF+DitXfQVcwuvuqymv0RJ+/LmPmseID5224YCLGpw28xOreVTgr8qisaHb?=
 =?us-ascii?Q?NFi513ZcUJEcoYe2ipPeCKBrR7jMPrwYc/Hgmu4WWCf3USaon2BW1zgG8oH6?=
 =?us-ascii?Q?wZzMCuzFL+/TQymyMBnG8AHC20jjHuygEUMGmppOs8E3QXlMTrRIN+IK23sb?=
 =?us-ascii?Q?cgQtB0AGow1eglPTmbzB8Os73l2DggAmFxSk7/aD5mH8a41P0W2ZNpnHV5+R?=
 =?us-ascii?Q?0FDU0U4Xmpmbxyl0ROaBhmT0lKztfpbgYgdt4Nr7j59MOrjGvZJJ5Qf0eRFp?=
 =?us-ascii?Q?HcW5/hwuiWz9Xt+eUzMLRgg5rFzmmN27x9D2KSjCBozCfU4VurjL2G2JMc4y?=
 =?us-ascii?Q?ARRPdR7oPd1U4umNH4J5FPN1cEXdDa7lwj9lfnCyhUbY5GQInwlAoO4gP+Cc?=
 =?us-ascii?Q?2dnF8k7bLmt6qvzjpl7jCf4HjBmSeo2tgMd5lu3AKOPok1zWfVc3QtG+EOWp?=
 =?us-ascii?Q?rm+cIvqlsUaYDyYNdfiOmEwQ5OdXWEPu1/OZrp3lP/7nPbFESe0/jova1Udh?=
 =?us-ascii?Q?OK6X8BQFHDQOdPGLNsj4uie7G00cnYNAr8oZgBuFt8zem2qfNhM6u/e4aJ6F?=
 =?us-ascii?Q?fILIZVMHQwhVPmuz5FiDnLvns8bL/TuihKf/21cx4l92fUnx1FCbN99+dHLW?=
X-MS-Exchange-AntiSpam-MessageData-1: HPkOpGRLtW8NF/VpPMhfpndsTk15V63Sfx0=
X-Exchange-RoutingPolicyChecked:
	GH+dNLYwdxLrDhlECQGiroDhNWK8aSWabdTxFDH5ktq0wMVNw9a1WhB2d1h10traTryovcndVw0EGmH9631dzbx5ni1sQp9Ckastjt3iutZN46WGw/w28izBntvWktSfse9azrqJNXWxkRlB6kBTK5Ikgd1Fj4KPBjZJzzu8JlR3SR76Nh4GiiWb25OmcC7PXJNFeaFH5+ckIPVeTeWWkubV5qos7khU3tT+oKY6IzzvuolDpBDWT9Ba5viGGaJSggoqzLNUfMl+24Kkmi5rOSSsUyG1MDRfY4aFGnD31MzwAvdSBxYT6Jb3HnrVxRJAVcU6hZucXESEiXE04bR+Og==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZStYFyIXTV4MzHBAmBGDK1x7HWGJpNjUEc3pqAXH4KDM3LiYSziKx9pycS20Ey39Etii5QN+ZWcwPqQ6EHsWqy6tnXW2hbwowO6PoxSTT2cBStEmv46GcDSIvGoNTmWvsE9kaklTevWTo26vSdKPiplsBpaxRAe4fWkLtMh4zeW295hSb7/jXN8o2DCjkmGrGiwxva5XFhk5gO2Tj5zFmZ9vKve8wXd6qStg3Lg8KG0jXsBFYbkxyFBiOyhL4zogShfwMS6s7/19za85nR424PUyAeeDtn/kggT/9rnxmJoiTj6+ZQZMgAcamPM/uqm4UX2bsSnNiU2enejurAiPzZpEldvu9ENVLVxu+uP734Xf5rM4XPvj98RYnIjesDEg22jrlUzXbBZUDwZ4ZZulVYZoXwFaFWEDkLMNWW8bNrGbwH2UCHQ3a98czXYfRgnw2+h5FsTvoiJbi0vuj2/WGTtpqTj84eX2TC7x3x9p34hHFYiKKnaI3qHA3Vx2kKJ+K3YuplxlpmZZY0nT1G6G5ViOv/cQnCtsWBAgHV+i5Jv+OcAz9M1PUd8yjyOwy2XJshjCkxUaksAWr7URAxjJKBz7FjwSjuo1L/KEQomtZqpor5kmhf850zzjQY043GyY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8003fa7-4e65-42c9-51bc-08df40e01995
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 17:12:15.7154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btnRuvxSd6xEKohJUVSdrLa5lTQSzeQl7QZU+fzKV7m5rEj40OlZ7uFPdNRjpzd5ZVsNWiz8uqtke2f0OBAXJYj7SSuZc0H92c/RHdiwiYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR04MB993662

Looks good to me,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
