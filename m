Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590132;
	b=mi2TbXRmgpyS6SihBNyWG6Ca06uok/UwfY+GUZZSlhqJrdVMWMQnH3QITXr5P2U0MuAk
	 fx/c4RejFuPKL3xYoFXIV5b5urjlGcJEgg6GxK34raZc5JpmulKpPa5IWzTLJEbs7W5uW
	 1V+N7Zd4y6ObgHWG14+WpETgkiTFXyB/H0ft2xfs/E8ixlF2JljSFCmLsUJRbIYfZUDUb
	 koj2HZ8OBqv8EWobCfQq+u8Xf3BNZSwAjUkO/o6JkGE4GyTsa+HQcVWpX+dRSaze5GnEF
	 43s+kCeCZp43sAh2CbCPCsQ29M7q8LuRe9HPmrwwOGCj2z9LRnkUHUEPn8XvJevXbHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590132;
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
	bh=hZG3EisLR6vd1hBMyPbq3aJ0RERmLprn32+NkdXi6/c=;
	b=tTK/cCZ6vv56EGag1HnjVLzAYWBxq/lBFCkdRT+pekEr9Mz0giATe2Sr6znz2DOp4T/u
	 lVYI8X9HUOEP42BCB51160kAOD5F8V0rOXcG1sx9O52ZirxY8bV3/lI3HuZO4bQYxRH8d
	 phbQ5nhoKrwt/Ht6sHSU0m/ar5WbY5emU6JKIrq+ngK3Cj/0tnjEuMzmW5uvrPXCpwVKg
	 BlX6aGFAgHJUTU6GnpOtUHRPIdTvVwZsDg2Ke1D6YNe41Nvi6JOY4OFmYwNjun+jVmu9I
	 NbfcFLyFgMslLgC5aC0Q1MMY09hqTARdkkPQ6mywRD4aTrVj/IucoWFp0rxjnRsk5ow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jtyu+Jue;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uWkBD9pw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB99606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BB99606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jtyu+Jue;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uWkBD9pw
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590131; x=1824126131;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=rlU0PZmOnMsVpM99293BFcI0CO4Fq5oxnCNQxSEvvZY=;
  b=jtyu+JueGc7F9i+Lx2RsFtz2ThUL1z+sfc3qPKg/Jv1UnXWNskqlvRcm
   EqlZKfPaeNpUfUMmm/c38XKk4MGrEYolrbF2BhWBLUpKP0pqbE5m8wTqM
   XtaFxDvRxPk25nLpWwsdOTOYZmG7heWxEVUUx0f7h8srrElM1TxfoJCUQ
   VkXfJ0l5qdJfyP/ebQnpN5fMKCrijTVSl6U61q2zdPc/6Eaec3whB01UG
   Gt/asLMWCosK3FK7u76U0YsgfchtAdFjS1w1fUYPxK2MCDVy6nFeclDVs
   ZssEGsH+DopwsXYypd3wQtecYbFp1RAgNKsyLHO6PjNfHSm+5UUo/GeGj
   Q==;
X-CSE-ConnectionGUID: 23lEy1mUQOqegLbyE/zpKg==
X-CSE-MsgGUID: w955BKLhRkGw/NvueJfS3g==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="158541729"
Received: from mail-westus3azon11011066.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:41:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wi4mlGaD3TtC7qfq907N0CyN/ghESEUhF/c/C+rTB2HXQuwmiW2wbt36r2HL95aKsWFMdZjHoiiRKiV/Yk8iawZABUvTKLCA1+um2OFMX3rHBZYncfvQ4I5FH+pAtFR6PjJ6UPC93+F56yUsVgGm2IlkXK5o+YMlBGENpvmIOpYPIs+h35IPFMkxupxPWBujTib1st9ZcajSue4bNnAuVXst6G2sJ36vyRIiy/A2eaDhIwzh9JCcD/blw9KFhNi2TDbPRjkDjVh+Wj4hXcoitZlt5ZJ9VE569LjygW2UjOHn3r7caNt23N50Q0FOkAAZYAHRTn0bry3JAw1v+Wbewg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZG3EisLR6vd1hBMyPbq3aJ0RERmLprn32+NkdXi6/c=;
 b=sm4k1Kzqkj4CaMVITe2s3giRfQfOc3uplg0fCxDF/b9Z5VMhBH4EbfEvNVnCTxmSQSJcn4yHNf94CLDx5iBGVUijj8OiFH0+dHjpgg3qXm92HGi4Sf4QGiT9z+jvDFZ/YLVRJlQtEk7hiXNyKIoMb4pno0R279gW5XWh7JLmsjfCqXOXb7aIl3QvcZBpPllIC0YURqjej9t/SS+4y5Eliwc710u1/galC+6twsSmJWBLUoRoLf0rIoF3tWtVNCCTDyN4+sIfaOisO7I+EdpVNyES/LvnqEuS8YxOwWWT+GOH4QHGSiTMyTV2uawqL2t96Y8lpl5lW25AMGwiLxZaQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZG3EisLR6vd1hBMyPbq3aJ0RERmLprn32+NkdXi6/c=;
 b=uWkBD9pwNS48yAPnSvyKBoAdVgRZIf9wd4Ww+0ipBVOQIudEgFJ6HNG7j8OYbma0ihLXwBWVecn0nVb4e6K1r4JCLJsEUd/rZ+cGjcCjzCbhnjgN0YZh6wsLOFwgLZIAWPH1V9uTmDwrG519reSP7SZxbbkA1tCqxBLq2tF4Uwc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7582.namprd04.prod.outlook.com (2603:10b6:a03:32a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 13:41:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:47 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 02/25] btrfs: zoned: don't activate conventional zones of mixed block groups
Date: Wed, 21 Oct 2026 15:41:01 +0200
Message-ID: <20261021134124.2338902-3-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: d1346153-eb6c-4c2f-1342-08df2f790cd1
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|376014|19092799006|10070799003|23010399003|1800799024|18002099003|22082099003|10067099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 gmTuz3AjlQey0odXyM2wkAwpr0tGoSNC6VVaOY8sR2FH0OCHW4B4dOfzmMsCUJf9vmVkUnY6TJCjIFXSDOLZO6y3NWutxNpKZgoKXfVgC1ak2MHTMwjCou4s8yYw97J7R4IsrrtVOdJPBlH6cXw5keQ0d4L1IXsGRajGoJvHrYgjXOiYgRbtOdjYaVjlKfqMAAcPC+QIhbhkUZNBkje/SB2vqE3EnFj/C/dJRk9z4LWnGP2PKtUSJADlfVHi6hsMia/luziZgm/H5EpOJqNXF3C7wu7JAFzFsEI5ZeUbmuCRnfrjBto3DHLl4LssQCt9IQ8Hn3EhOGaJQcxK/0zHP066QLubIg9BHWbTdXdk7ReCihy0xeaUYpo1NbqIDHoeN/LFEb3akIeZDGPkz+GdAWrKC54CLRHPPHAWDbaUcfFXbXKLfKS0BoQW30VLawro12f08dsh30PZAQ3N15G79Kw2xJ7f54EOIBdVrGKUDTCSRP0Pv4bCI1o6hbHesqLCvJm4Cxuv2/u2z3iAcRPQ5hv+HLW5q15uJSTIJnz1CVE6jFOHyi9HvVvQI8eq+v7/QbIOT8IkNiPCwfSRaqLv5+Jhj2lJvZqJKGnC6uqIUe+I6FXcTEPzRfFaj7bfVcXO0Zfp07PWbgn2ycfj4184/t3E/mY6waXTPWP7IVo1Clc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(10070799003)(23010399003)(1800799024)(18002099003)(22082099003)(10067099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?BQuRmT4x9bI/g6xDkN2XZP8Fl/SijbXT2pWRNyO8tgGuuYoZ3wtIoWuqCk2i?=
 =?us-ascii?Q?mfzXNsj5k+yAmuOeNCTL5EOAziuwoAdyVnzToZLeDRn2mynuWBvlAxCrWVWj?=
 =?us-ascii?Q?OeSi8BOrChFW4oKOMdKetDYAYYiVjgTjYoGxjp+kcRriUJU0PCbL0/N0GVbD?=
 =?us-ascii?Q?whg1oU1gMwcf1B9Pe1KOuhwCmiJhTzacdX+1sg0R/eFNNW/m16GhyRC13iW7?=
 =?us-ascii?Q?5evC7V2hvqeHcG3GM4/jFspp6PRdHInDbgT5vR/AOOITzQC5vKzD+QVqzoE2?=
 =?us-ascii?Q?GB0pj/VIcRh8FTPZP0EPDUKQU6C7IMB/2yQ8lChwAh0WIQ8dIP4yo2S40bAH?=
 =?us-ascii?Q?kV5QGVzJqUmV5sMF+YvqO1u8Coj1lZDmzeVM2+P1K91DGJyXNvOWY1YB7OA7?=
 =?us-ascii?Q?VwdUpXNQyqzW2LwVOnkU8TMKHyg6rWE7RBP86KaqtJxKLlyWIu/au//FYS/V?=
 =?us-ascii?Q?CTdlO1VQFqIT1gdDagH1H1XoNQv6X+OPOD1sxx5cscVoK31BiTtXsusRoD8B?=
 =?us-ascii?Q?3SCkHzQykYDdlmoM0LAo42J9EL5C5bGV9axjFbIuHbhX6rRyiEw69DGY6rzz?=
 =?us-ascii?Q?CXpilDIMFBmP0u2X00XL/ztYX2hLZOAvlIKqe7TDmyhwqelrIT6Wrkhs1M8r?=
 =?us-ascii?Q?Ayl5B/CSBU1TaB3mDvWqIJJTBdtoNafSwrTUoj2TRwFZeMGQTkkQP1P+aTG5?=
 =?us-ascii?Q?qmhqBlCv0ci32q4GGMaLtTsK8G9UDJJ3yBD2xhyVc7F6PeMi+YfNuIdEO/Z7?=
 =?us-ascii?Q?YuDf4GvHhdeoeMUMfvo9ZPL9UgANO2f7Z0kv3panxIkg2VCHaWrKAapE8mTh?=
 =?us-ascii?Q?kC/OnE8SBYt50pDrVGFYnkOsZHlBhZW07PKSdGj6oItYWGW7pA6j3twNSr+7?=
 =?us-ascii?Q?aS0fitUhQibT9OiPpmfrMX5BTwFlNKLgTmHnYMJcn5PNQI+H02ocfu0CZgY/?=
 =?us-ascii?Q?BICDfBXne7RT6y6YOKNRAY1PqvXKwu8FSd7yFx6hFRwAtRjp6r/9EwOSdCW+?=
 =?us-ascii?Q?uOwxlwKTSgbRPKP6yxwLc2wFFkshfGM3yyIJQjWLJB/UsWkqHZ+j2jZl3UTs?=
 =?us-ascii?Q?iIefKROedWYfozmcAViayodhKraZWd4fJTXm12tjoGZHDPAsoun1sY1GQglf?=
 =?us-ascii?Q?WVjJMMUpIM+IJoQqq5jL0F6BN1Zk4SjslD0f2U3IF70ZaGb7GGEviGq/M0cb?=
 =?us-ascii?Q?S0fguyFIriOveGVvzvvyGiSiCsGdE38fwNJEtUjxcjXb3lMuar2rEuscCXn7?=
 =?us-ascii?Q?lnmMW4+uMkU4eEpQbk3iUditnCFN2s5qc+RptnHxiKOwig/mWvVdX/mWqAbK?=
 =?us-ascii?Q?o+MUq8gY3GgbHctdDxcR+q+pBT54dJWaeU2jc+JUPFPe3Z90S9YeQqGkXUD4?=
 =?us-ascii?Q?TaKuJK8qWkH4R+rLvM8dzyPUun7CU50ZlbCM8gLSnLfksSHZy0JlfTbIoDY5?=
 =?us-ascii?Q?G5CDtKpQZjf9B/5p/G0V7pBazHHak3YRdTXp74Twjk83c40+luSehS14+qpD?=
 =?us-ascii?Q?GDSwvYRx0MyoI0rkH16ZCqklxoI0jByJR3iIUvoCYJRxZfoGPsZ1NsOIbKBO?=
 =?us-ascii?Q?qW1tGn+YNfdSwvj743EDEZH31PpuBo71DJR1qjN0i9ALfna9+YNHHEUedxbR?=
 =?us-ascii?Q?eJjPpPdVIOq5XonyRfIVuIXJ59FsC8kbK2xj0vUMyQaekGQFVPZ2yHhNFqV9?=
 =?us-ascii?Q?I482afmP2PAv3Edrd1FTLOnp2rZg7MlRmQL1VcUnfyo/8XMcvEXa8Akhqtxp?=
 =?us-ascii?Q?Kv8pc2EsFqDh1zsQnahHUfMZdDWFLGgKfsULDF62Gkl7BI6AUAhC2PCyygl1?=
X-MS-Exchange-AntiSpam-MessageData-1: ZY4ARwd6Fp/iL7p6OGi6jLlL+X8DQ4haJUY=
X-Exchange-RoutingPolicyChecked:
	UPbiTVvo8gLiQTMjGNihC7hWPSAxhE/Bizxfuwbc8udRBWmJPLRHpUY4/tAlCvDWx4lE3YhhKDT+P93Fiu/ifrfDsfHjGTVaC+kNl8QOc+8E+cYbGQxaCc+ZMTM1QP6xsnxyn/A7mqz0G1ei9K0NwzHVNkgJwwNNUqAxpq1v5/qC70R6qtxDAeQYsmkKomI5VlOF+hPKmVeWbimGsHPOZ1bmKKTl8RSPZFdbqLF+fbo0dnk3alP5t9QvxiN/GcsFhKaJ+HRGIhsxWch/AJHYxhq/Dy8UEVtb9arplXvVHUOX0UwtMHDoNMq+8H7zITP+ZDqGCHaLd5V7HFHb4w7giA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oqyuLaDud9N5IAaPTUSCeJqDSwpPDefIpxhArI/YjshB8x0LxT8OdXJA55hs67yA+7L6MB3hTZtWRQ3x6u5cDwsDcXoaGPFQiN6/BsI8HQjRlTIMvY2dlcUW7Tx2HSjGxI02c+Bhgz0pgPt3clrDwZ9rBuPqFwEf4fML/aA5ZlA/SAdMSSyUYn8b5k14286xwBTzjpiGs+Yw+1OrdO0Rzyb9CAhjSsfD+pHGbKaCVEpN/ldYBp4j/Kk0/F1QoFu+D4mYsbjjYHGNJJvms6+GiEObqNhP0TzL79lMYuJqTkN/y3p2ysGiupM9GrTG16FrGG9kZDU4m6N/9ec0HgRXesm0Zsp6Oqu2Lv5hJCmWAnYSHUaw9Czt3RoO4HsTz3HOvLaoDVU9GAiUtYxbLEx0zIh97XY+PKtrsGCHw44oMqKtMPG/2fFHh8X1CF3egpwQQ6fcuuya6MpxoLyQ+8803wqw5QuHqoz60e2CaoJyMI4yb+7ZBuyayJJQK19rZEQcafPNsv8gSJhEhrcqEHn5FvVgugJCpzGx/YjWawfuybzf906S683BPlfX+ES6CWwyX/vsPCUQh3pxIe+Nb4V8m+yKNJT7wayZsL1YQQyYifnrF/O6EReNyvSBL1qvfYVO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1346153-eb6c-4c2f-1342-08df2f790cd1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:46.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+iXELBElMI9IllMZz/YWdEodZl9FewxcBaNnJN85Dx9DKlzWWdzDNpAsxxsEOKqbri3mhKOL7r9E71Si/HhrxSqCCPxG7LdlRnK/9cRHjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7582

Conventional zones never consume an active zone resource, but they are
accounted as such: btrfs_zone_activate(), call_zone_finish() and
btrfs_check_active_zone_reservation() take and return active zones and
reservations for every stripe, and the DUP/RAID1 loaders activate a mixed
block group on an activeness mismatch between a conventional and an
active sequential stripe.

Skip conventional stripes in all of these, and let the conventional zones
of a mixed block group be active if any of its sequential zones is.

A fully conventional data block group stays on zone_active_bgs but frees
no active zone when finished, so btrfs_zone_finish_one_bg() must not pick
it, otherwise the caller allocates a chunk that can't be activated.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 51 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8e2de2640457..ee5998b8e269 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1958,6 +1958,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (num_sequential > 0)
 		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 
+	if (num_conventional > 0 && num_sequential > 0) {
+		bool any_active = false;
+
+		for (i = 0; i < map->num_stripes; i++) {
+			if (zone_info[i].alloc_offset != WP_CONVENTIONAL &&
+			    test_bit(i, active)) {
+				any_active = true;
+				break;
+			}
+		}
+
+		for (i = 0; i < map->num_stripes; i++) {
+			if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+				assign_bit(i, active, any_active);
+		}
+	}
+
 	if (num_conventional > 0) {
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
@@ -2450,6 +2467,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
+		if (!btrfs_dev_is_sequential(device, physical))
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 
@@ -2525,6 +2545,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	bool cleared;
+	unsigned int nofs_flags;
 	int ret;
 
 	if (!device->bdev)
@@ -2533,18 +2554,17 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	if (zinfo->max_active_zones == 0)
 		return 0;
 
-	if (btrfs_dev_is_sequential(device, physical)) {
-		unsigned int nofs_flags;
+	if (!btrfs_dev_is_sequential(device, physical))
+		return 0;
 
-		nofs_flags = memalloc_nofs_save();
-		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-				       physical >> SECTOR_SHIFT,
-				       zinfo->zone_size >> SECTOR_SHIFT);
-		memalloc_nofs_restore(nofs_flags);
+	nofs_flags = memalloc_nofs_save();
+	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+			       physical >> SECTOR_SHIFT,
+			       zinfo->zone_size >> SECTOR_SHIFT);
+	memalloc_nofs_restore(nofs_flags);
 
-		if (ret)
-			return ret;
-	}
+	if (ret)
+		return ret;
 
 	cleared = btrfs_dev_clear_active_zone(device, physical);
 	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared) {
@@ -2985,6 +3005,7 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 		spin_lock(&block_group->lock);
 		if (block_group->reserved || block_group->alloc_offset == 0 ||
 		    !(block_group->flags & BTRFS_BLOCK_GROUP_DATA) ||
+		    !test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags) ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
 			continue;
@@ -3107,8 +3128,14 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *dev = map->stripes[i].dev;
+			struct btrfs_zoned_device_info *zone_info = dev->zone_info;
+			u64 physical = map->stripes[i].physical;
+
+			if (btrfs_dev_is_sequential(dev, physical))
+				zone_info->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
-- 
2.56.0

