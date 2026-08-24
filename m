Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A43845DF4A
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787587263; cv=fail; b=efMdB1kdiJvZhjFLclSs4okJdY61L/n+f9DPWreCmxn0sYGvcwtSuti7kMcs1aNaMCd+FYWysbg46nE/mGut7/c3OQX6GbUMwUMbULJPEzc3m1jGPbTOY9E+tygNrkSXnSPE2TY9UshNRDStn3V3S2fROzOrMdauPlpMsfsl8/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787587263; c=relaxed/simple;
	bh=D4yDjskLypDpbD7pNIgV8hy7iYuFLlZMMZIGepe2ElY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CS16gOksEZoBp99MSHjb5fBXr3cc08POWQ3Co32+vpzG5sP7OG4d6fCuMG8UfkCwhmp+VHkzvydEt8B05Tx/09ZqyLzQcMuynbS/2ELEaHL8Kq0XlWYOFo3fGRkf7zq3H2wcGix53tZq+pszAmJG6Og76QUtE1N09A+YJBmSGvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EICnf9re; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=C6DbA8Yu; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EICnf9re";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="C6DbA8Yu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787587262; x=1819123262;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=D4yDjskLypDpbD7pNIgV8hy7iYuFLlZMMZIGepe2ElY=;
  b=EICnf9renF8lYy/6Kkhldwo69E3S4RTJCSkV7si708Uhl5R3SacbqrCD
   ePBVt8dsJNbeFHTqcVibi8mwfGKryCtSjH6r/NS924bES+RIMHNZ6QsVt
   AbCYANGGlWhg5Dkd2eVYXa3Kd8UdoOwFGx3nrpV78mPy1GSV7tWkL6FMN
   ap201XrtewdO5WGfC0HbXMDi+pENlHUS3fwKi7xIjZVX9EZM03GnM1nyE
   0FVb5CFdcD32YCFsyXAoLQhCoc/zlfUyf75Z3dgVGB0Ae1eX4R4Yg6XwX
   GndXC1IaiGcbl2m/N+tvtUZr2bHFPGIZmhWEaI2j7G1152zuC21v3tDD9
   w==;
X-CSE-ConnectionGUID: 1j5wjGf8S8CvrQ+kCh+Cig==
X-CSE-MsgGUID: mQP1I7hlS3qjZWsNffBxkA==
X-IronPort-AV: E=Sophos;i="6.25,240,1779120000"; 
   d="scan'208";a="154163949"
Received: from mail-westusazon11012026.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2026 00:00:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E2G9AIZissPLIGghAJdkb2IR18gqSCBOVclMK4Hdn3kSwl/aUIXQGsNmiqDBPRf4FUQ6U/RPUfaGjhMzP/xbxnCPFgI1+L6zJRDDk6JUwDxoQZSXtj0hpLjmD9XgWRWnkFyVB4lfRlhIYLMBUgigX4pGYPvSXkGLuzLQZC2FumJalgB0a0cwhVutYyfISgogDj3sKbNlv/wwrBdaFO+RJ9flznxrE21dEhsgg1imtBdpsHoZh/S49ReyUVMHsIZFdwmViJFoEujrjvpSRo1j4hcngJQguPdhD2inGl3WWp04xwafbT+sqWvQ9P6zT1IpyrNsYz6t/ZIhLBlNV58A5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+LDb70HyRD6NuxfJRSX/f18caGV+hSCIvkT1G8YyoU=;
 b=rtnXxcr7izOSnZ7KfGc6ErWClcOqZRlo5ncXqZroYD+nrg4NTdXVY+jaSHFeGsYOL3itOGlIKStD5+fBijiMI8/FTwWpYsF00G2G3MDSvJl35X8JKj5K6gEt0XtwtoDfbH8IvGH95igzXAelWH3eii9k8YXvVWN+pM7TOlkBA0nfUV5iRzkM6/Sfpd5KWn6v88jpErrsPF/O2k1q4rr3VAC60mxEHBBj65Hxm0Eg5ti+HaGWjb75tVC3iLUkNUpJwqW4s40zmp0nx+7DLKzfOv9DjUlVpbpC05z0KfJAxGZ6fDguBCh4BMueYDo1o+3P/YfwCHys12mGhyNI8I5qYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+LDb70HyRD6NuxfJRSX/f18caGV+hSCIvkT1G8YyoU=;
 b=C6DbA8Yu6wha5sbYHpkkjBdF8kxQyZBrXyRoz11Qe5qxIN74tqAubw9RNK7UO/UUv+jgpQtX4CeFNUmhkhJ/s3Y9QQ2hwQqEa/1PiPisaaF5BJRgx23YwHQQXM2xYYQXUiSzEZbF5iC2dWM9oNWqFB+8cPa9X6uSEpLtVx5q/r0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9872.namprd04.prod.outlook.com (2603:10b6:8:302::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 16:00:52 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 16:00:50 +0000
Date: Mon, 24 Aug 2026 18:00:45 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com
Subject: Re: [PATCH 4/4] btrfs: zoned: serialize zone finishing per block
 group
Message-ID: <aoxpGiMYRNdRX0wA@mayhem.fritz.box>
References: <cover.1787551793.git.zhudongjiang@fygo.io>
 <388e4a6778d65d6d08c7f921c629d4645bac9959.1787551793.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <388e4a6778d65d6d08c7f921c629d4645bac9959.1787551793.git.zhudongjiang@fygo.io>
X-ClientProxiedBy: FR2P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9872:EE_
X-MS-Office365-Filtering-Correlation-Id: 5377b077-a113-42da-89fc-08df01f8de61
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|19092799006|1800799024|23010399003|366016|56012099006|10067099003|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mATQ27GHbOSbUZGdTBeMSV4FMVGzVhiRzY9SKjywIAN16aWPC/Diaf9VmwlU7d4/lQcMpZQhvABSChwRULAKRa1LgiW0hsPwAAF0m/RveipAY3L3M7ZVvY9IiAXWmVuSdVnn+wJZ6ZymnPJLhKAP3RsaKa2Do6/oOa0tanAGYqKMqS/ES160sc7Y+5B9XW2ehby6bF0I797XbyF5x8mNVDgzDPjYCQbKw7ZpYl2uZpgf8d2ED4gpml+DVDljD7In5KhN/uClPKG6ThBhFbldIWLXnutxTcjUVhEt+BIy70GwdtFXW/lvvsp7AFg053tKS0E4kUCbAcTWRzhWPmrmOISVhe3DL9jLSxv/etQozTB1Ob/BPBCOScvbLPMfSFhNB2gIKQ3ptKCukySmHz3Ic/g9t7I/frQV6rQHC5BIQTqF3Z2bihFIHuezOBQZtqfLCHBBAEE894PoRkUEfJC1bGXNV3S79OvPt5sRyZVhxEFc+9lJ9vVOFKNxwO5BX33kamTSmUJOCJBRlz0LuID1ZSM6eMyhM047ohojtDgfYocwbvYxc5Ntxw8J/fv200PtYwldXNTILjSdglHHbfx1dRKaTRiC6oM1hwRZQPBc1Dv9arnehEAhNgG0K1uKnPTv7joqDnlwi0M2NlivQhqkPjWowuPJSuTCuEXaDB2T+CI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(19092799006)(1800799024)(23010399003)(366016)(56012099006)(10067099003)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OQKb2H4PqqkR2xcQs6vPvrfiXuUoMtEoCpiBOi64vf4APRUdN6MtMQ4PaEiV?=
 =?us-ascii?Q?0hXsEQd16XKvR6At1XzESfYCPZkSPjLiIwX9KKfvjduV884J5Z3OJQWIjAEM?=
 =?us-ascii?Q?mEegLq7w0yBSPAr0S4wyzk2HsRRJvDvyE/cqLhY/RTTV/IO4b6ukOhAXi/1v?=
 =?us-ascii?Q?cRUc/uQ5XFjBvM88h90oFRXERyUqmX0MYaokPx2wGngUu7NO3MWbqlFweB2X?=
 =?us-ascii?Q?/dUfn+zzBWfwt0a9tShwdbjBdmRsB6lF6ZmN8AxuR3fcFGRBvYn0mHvjBFTz?=
 =?us-ascii?Q?YjXqOUTvX+xruHzHpNwVNepg8QHHaw1LPeNkqY/k4pGEpIlCgMfSWL6s5HZB?=
 =?us-ascii?Q?SGstyutcemzn1aQGf/ynlTC3NpbhdIiDOKEHEnhgo8FqUxqOHa05R7CZhy1b?=
 =?us-ascii?Q?eKv+X2O94RmPLVoKZ30LOSAMvry0ZRkePDQ65tAOUv796LsqgOHcBE0KOXC3?=
 =?us-ascii?Q?1rGWVkdo5rlfPbFrOPdWrCx76vdN8J5Ldc87cU6G6olKBkaQtq1sMjIG25VW?=
 =?us-ascii?Q?eM1CLEGcqVRIdHKEc/6jq0O+a7/o4jCuzcem7jg7th1S+LBLGRumq+wja9Sf?=
 =?us-ascii?Q?fISqD5SuAbmtGjv4W2HdIBSBkKXy55Et9jmv5/qDeGzm2cYhVEQ1c9nLoiiC?=
 =?us-ascii?Q?HiSVyGllqkBWz67XR6xW1LJkyPVxxl6942EnRQ5SA6llGtb7rTHwwKdbAmuh?=
 =?us-ascii?Q?xIiROvSexqZM7ZmfjM4EkDyBolYVN+vZhk7bl8tkYHwVdhk9bf0EFj+LM4GG?=
 =?us-ascii?Q?3f+Xo2zntVYPS+y4XU7ZB/Ck27G1daQIu92becIEzE5nu43amdKk5Lc9hNJR?=
 =?us-ascii?Q?la0UUxX+kRb4T0Qufd9d5JcX0X+dqhS5ZgKvIuzynZmo0ghQIAbOmWmbU0lJ?=
 =?us-ascii?Q?dhlNbwzJaEuLyvmgFV1hpkw6etAO1SfwM8uOBoi1xLkbpRWKq8823y1NiBhx?=
 =?us-ascii?Q?9AeqcacyEFh0TllAhdJkS5M63vqLiIJpJbTslR/ZhtQiPNAOw6ecfAqFbEwR?=
 =?us-ascii?Q?HD1p7E+H24lwtKak8S1WtB5uQVLdnzgSvcSHbE27UyI04r3SrioOCxJEtYVw?=
 =?us-ascii?Q?6TGT0ZFqikTpEBQcZd9/4WZ+6LUVM+htrELlJ3KU0pIHzVXMy13NKf1Yq42g?=
 =?us-ascii?Q?mfy2KUkGCdsJmF8MbOFNHPjfvINf7qopvUytgKmpjWHGilqYPnS6ZazLe6Ak?=
 =?us-ascii?Q?sX3/P2pBt5tHOuZUCNUTpRsIw547M49Wr6THBCa+z/ltYJ61/TXZfFeCUTZ0?=
 =?us-ascii?Q?2m7hCpBqKAiqdyU9YHHaY8JBUfdmAR2xx01gqi4RrsR3iUR9VhVVVquJ6L4G?=
 =?us-ascii?Q?uuS5xCv0hcf6Q0FkhRXiPCMygGIAaJMsw99UKTkR6KRKtdlTk2Qmnfh998am?=
 =?us-ascii?Q?FkVh+OiRnLkoG9aevbXUAStsO4LmlVNfYRFbgACAxcHknYwAWdKe/JmuUWdb?=
 =?us-ascii?Q?+i9nFJtgsWls1zbyMqQmLfChZ4wUS9WqBKAWzgDwIvBo2gcIsC873xLpJq2Q?=
 =?us-ascii?Q?pN1tlz4YRjd7uosS8bh3LMRVcEho3RKAqz8h5zVURuuC1RinNUVwTHh+8u7I?=
 =?us-ascii?Q?Zg3GOP4V7u5RUxzc9hM5SRUYXWrJZhZbBoHY+w63yw/xSgx1woTPlOa/SP55?=
 =?us-ascii?Q?UFxvzaAm6FUe4lKFqmdYBk6oO42upXjCo5leHomRrY2PUWOQcahqT2HYYtgO?=
 =?us-ascii?Q?ZRfhWtoTlRvgFMuJNEWyAIVvkiMcqAROjcoyMaexw3oUnltW90zGtyvBRKrD?=
 =?us-ascii?Q?3bY7w3VScU7dAdOR57MC0kWtD1Xr9hSoMFDjvy8JCTDdFpV4izBRjpZnfryB?=
X-MS-Exchange-AntiSpam-MessageData-1: ndUmRvc9Tw1AMbOZeMwMaLilSyn9f3CFj1E=
X-Exchange-RoutingPolicyChecked:
	X0V8DvYv5YNeu54nnzZGGa/GvquGakB0cULaSiJm2Jrrw/1vMVrRtXlcuXfk6uGd8XcFIBDvTAYuvTeHWyHulIKBcaX8u7hiqEQlALgOmWETTJ7+nu+ZxgPw9JLOHs2ltUVEc/FYKi+b7IKyQ4uEbujcv4KO6sXBjWePZUBZiU9zTf+A+/lM69FyFdwoD6gR5KMt+IUp1mK9ey0WD6Ep7mXuiMvX++w2IZ54IvdGSNTx6dd5It6B4BZiambATrF5GFh7IbGwoBGoLYOrolH1ehfHAmP0rgTHf2Avo9ODuugpCDGOzJ6tYItivlJAcGhPcspIn9nCPGL0HD5ddbRDnA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SLitzYxUb2hWLljLprTX57y4GH7aYy43rOWYfkaWTS3QOHONzkWl+ilexo2BINlEhca4rsE8VzD4bfpC+ltwGl7b6Wy//nPXuAedlHf7pV2/DJpR79+ayCzPtOBxFs/0ttUlL90D2XLELzn+sxCf6IJup8/1VSkmHWf0mQY6V1fRrgCJZuOO0OLL20rm7XVOCIGxn5BZiijxA+aYUr591TN17eBSgBNtzzLpyxV5Ej7Ei0IFwbEVgjyQsfcYJuUgrj2kEWtSz/hylKx4rmUOq/QP11CNgmZL/U41uaDgwhH87aiQKeHdCT2d6DlodzyAD4QBiy38cHrlLiyQSADtoDhnJvm4b3Tbk8tJZonwkDK4eAtJVuMHaprOcktQraIXPeMP3gcp4s73oDgNKuV6vIbPJ4nXSou0iMOObUSN712RS5FaJVtPH4cn8EGxxXQ+CnO49SNAM4wHgSJBgHFgGmBG/j1zFxJuvGC3wUse7MDy17x1kbOaLUiBDnyax9QEbgfPz72FgaNy2SDgpG9lSIwes83DkBjpl02tOuvavHgpGBSw1m87WFainT/a9D2MclY5uFOHbVjfax9tjVd7OqnOQNIAIhze8vqPOsocdVHQvQZWJ8dCsa89jD2LXJm4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5377b077-a113-42da-89fc-08df01f8de61
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 16:00:50.6049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1z0xNrdMr3D1sztC2XS472cZc+HgbrTYr1CrpAIkCX2YyHW5ssvgCXY5atIAiuhvRRf3J6nyuZUtiKTnKNbPOXArNoGXcYwcC8yJmav188=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9872

On Mon, Aug 24, 2026 at 02:49:56PM +0800, Dongjiang Zhu wrote:
> [BUG]
> On an HC620 with max_active_zones=128, buffered writes occupied all 128
> active-zone slots.  A metadata-heavy create/delete workload followed by
> sync then forced a metadata block group switch.

Can you explain that to me. In my mental model, if all 128 active-zones are
used and you call sync, we need to add a treelog-bg. But there is no more
active zone resource available so we cannot create the treelog bg. This is why
we fail, so we need to finish a zone first to then create a treelog bg.

> 
> A kernel with additional zone finish tracing reported:
> 
>   zoned-debug: finish clear-runtime bg=140928614400 caller=btrfs_zone_finish_endio_workfn comm=kworker/u8:7
>   zoned-debug: finish early-inactive bg=140928614400 caller=btrfs_check_meta_write_pointer comm=sync
>   zoned-debug: pivot finish ret=0 old_bg=140928614400 new_bg=339839287296
>   zoned-debug: activate fail slot bg=339839287296 type=metadata left=0 max_active=128 comm=sync
>   zoned-debug: finish zone-mgmt bg=140928614400 ret=0 left=0 caller=btrfs_zone_finish_endio_workfn comm=kworker/u8:7
>   BTRFS error (device sdb): error while writing out transaction: -EAGAIN
>   BTRFS error (device sdb state A): Transaction 67 aborted (-EAGAIN)
>   BTRFS info (device sdb state EA): forced readonly
>   zoned-debug: clear-active dev=/dev/sdb pos=140928614400 left=1 max_active=128
> 
> The transaction was aborted before the old block group returned its
> active-zone slot, forcing the filesystem read-only.

Ah now I see we're on the same page.
> 
> [CAUSE]
> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before issuing
> the zone finish operation.  This allows the following interleaving:
> 
>   Thread A, endio worker              Thread B, transaction writeback
> 
>   clear ZONE_IS_ACTIVE
>   call_zone_finish(old)
>                                         observe old as inactive
>                                         return from do_zone_finish(old)
>                                         activate(new)
>                                         fail with left == 0
>   clear the device active bit
>   increment active_zones_left
> 
> Thread B treats the cleared active bit as a completed finish while thread
> A is still performing the device operation.
> 
> [FIX]
> Add BLOCK_GROUP_FLAG_ZONE_FINISHING and keep ZONE_IS_ACTIVE set until the
> zone finish operation and active-list cleanup are complete.
> 
> Concurrent finishers wait for ZONE_FINISHING to be cleared instead of
> returning early.  Wake them after clearing ZONE_IS_ACTIVE and removing
> the block group from the active list.  If a waiter acquired a temporary
> read-only reference, release it after the wait.
> 

Stupid question, wouldn't it be enough to re-order the call to
do_zone_finish() vs the clearing of  BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE?

