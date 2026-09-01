Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF2F3AAF40
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 07:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788246894; cv=fail; b=pB2T6SjLp/uqJr31cXtb/+DIrFTmOhp+LruFScpv3iKw44u4ORLep8yuFenfOchlPXgvGJqeEZXusUX46+tHV4nlxSV3nRvPPjeSnS2g9SiGMx/IUCHaHbw87J7cqrUf9xQpYVTdtE8Bo2ogGODytruMiFgOPmjpsKYZ0vr2iHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788246894; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=npqbUf5MWELdJbYcnRCrTiLizw9mopjTBnOawCX6yR/Z3G41MHCgUrKHA00b5qR0fLtQsCs6b6Pp9DmTTra0CeVHscTZ4uCO1GikGKc73i7EDbrdv0Q2QCArhvqz5MwsThJCOPsOCrwkeVb3o/BnVi1U86huIvQ3y1gn087gSkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Xj3moVHN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=MdlBCrl2; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Xj3moVHN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="MdlBCrl2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788246893; x=1819782893;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=Xj3moVHNt+txKl5YDc6qii4Zmm7iqJfrlV7YxcuCm/mcr4vFCesg/epU
   1OXW5js0wyMxjHal3FMvYhKaIUGWJm4ZzvWSMYDYtYAu54z6i13CA27pZ
   q0ymO47+h8WAX79CF7+o1UG6TsHAe6Hi0w2J9Ke6LM3vkPGwKWCKw8IFW
   Zt2iXONBRBJPd8dDup21z/F7vGVo4j6JNO5aH3SRXujcpUYc25buMwkKL
   /pqffm6EaceUcauWaktkCb0LaeW+LqsZ4JhZlp2ctUcTWxLd6O9+upuWt
   qFly+hFnSCdF2mhtk78IkO2Lh+g0AuhOBIQSa0Al+Nmj5hZl/Jz9IBHdP
   g==;
X-CSE-ConnectionGUID: u6vc8TWMT06kJTAMQSVh2A==
X-CSE-MsgGUID: ZhDjrAGdQoKZYyM3ffvh7Q==
X-IronPort-AV: E=Sophos;i="6.25,255,1779120000"; 
   d="scan'208";a="155600260"
Received: from mail-northcentralusazon11010044.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.44])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Sep 2026 15:14:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xlLt4K8yW8Yu4P2xox3u3T/Y3tupzlyIFwuwZIi5mwdP2627A2WjIZk7rEfsODUo1SujR82v9bP4DqLH1xcGXBzQ9vVI9p3QVra/rUwxllEOXjCQ2X79n6biBmjdOGwOhe0BINy1DUhrUOO8SoGoReXyYJnqEAhPQwwsfROyAgONUIU4f1hi3xZHKkE2L1FK/HOqVQ9dYCQgMpcT50B8jl03lDRixC/H89nHsnoYMsVzK/hpSP9Opb7TgBJ1KTZfkmi2CCaYYBaATX6DVk8xGH+X9FnUdn8uHLRjIfNOlq2SIitciMNJsGk9wd6UpORMzmPXl0OdYXsWYSeykNfkXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=LkV+cmemRTtgWkglHWFdyy3N4oqkfmS6T9pv60KSNVYL66Gsn7ivnGQLfKB8ILQvn9xttLPp0PG3ZIDR8N05V3k1gjebLtwPnx51Uny4NyhBcOMYtLtABtScZI+QQ6FqE5m3pPL2MY+Koo41gGUWw128dAVY5LF4eeAL10T8gnyY8Sf8gKF0WF9xd3iXR0V1umWGmZtK3hWV5QomhsN5Uu5McjvckxQOprMSnr40XLBaaOQYbE91+8F9BHJotrMGPuOaWtWE93zzIS7BPNgwU7h2m0U0FDmDByuj4d67X640YvJC8e/gHf3zqt4GOTcOvcXT0uBJTpZB+qn6dnCLnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=MdlBCrl2xTD2V0CVykX0OK28nSnkwE+9P2WmyKJOV33Tq0rAkb23QaxJuebzVn2j6+s8g0gq4pmkNuiI+9+g8lr5J2yBWp0m+XxJvbk9Qs0MwZLB88/MveyWqfDiwCVxOOxApB0HP1WvtMtFYi78wJ0vn7T7dvFT/RTGQLs58ck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB8310.namprd04.prod.outlook.com (2603:10b6:510:10a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 07:14:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 07:14:43 +0000
Date: Tue, 1 Sep 2026 09:14:38 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, ZhengYuan Huang <gality369@gmail.com>
Subject: Re: [PATCH v2] btrfs: tree-checker: reject file extent items for
 special files
Message-ID: <apZ7NMP7dJhRb9UB@mayhem.fritz.box>
References: <e77c711bbd260df0a79c8fbf78d324fb58ad46ed.1788222663.git.wqu@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e77c711bbd260df0a79c8fbf78d324fb58ad46ed.1788222663.git.wqu@suse.com>
X-ClientProxiedBy: FR3P281CA0109.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::9) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB8310:EE_
X-MS-Office365-Filtering-Correlation-Id: db039096-68e3-45d5-f240-08df07f8b27b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|19092799006|23010399003|366016|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 SfTF1C+hPRWg/7l6oSyCMSUxjZeQtT6a7wdm1cOhpIoWogaSiTPW2zW/cpcrlfgKq7U3hLI3ESca0SZWMfSCwoyK/TyRoISc3ZTbmq0/uVEHBC5Ee22+O3EqQK5YTx3Bz8iQzw1qc5rAcmnm+fFnnlHz9Gj3XCfz1a+CtXdy1T9rWxyYhN6Ek4cmFPqq49iokkgFe10r+O59ydK9fszTKgbGYf94F8vFM/b2z7Gf4UmK9QPLq7R//3J1GzyOJFo7tDxR0M4IWxutwwkLHr8jJoQSVpVbGSgEaNigdBHc1imKdoSM1fRwnB3Dgb9R7v6gnpdHWrKM/vtzMYgTxBvLpv96hqSpbflKw0Lz70t4k95HxBE54GGBChZQdZ9wFsMlCOJ3qT4ekD5N4ozg0irADotfULYiesTp7cFc6JLw4d8NnMC782DbNkg3sD9tu/ThCEHvzRyad7Vr9S3YA+DPMJDSL/YLyK5aZpI7onDT/Vet5zZ2KRSY0snGplW/pcgJSnizYd8209pvmmBtzkYSvz7lLp246gnrorC/O25CJKrF5m3DHtNVnSATog2vx68I/+SECbKrH4P4D4C677A1vXFZN7uKg7pks8wz+QVxLDy5lpsAC22oZYAGgAWxrSBCJsCIs6WoBIwCdtiLnv2unBD/6vwtmMrej93taq1Poq4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(19092799006)(23010399003)(366016)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Xy7MTRHDCohKhdY93fYH2rKd5YYphMSlRSARJ/5dr1k4YMXhL/Yhxfqolv3e?=
 =?us-ascii?Q?ajqjzZxFiNGx3HqN43wTq5Y946AKBcPjPOo69X/JzT/PZ7n8J/MixyZUAhex?=
 =?us-ascii?Q?a7mk07i8DnQeHfgif+vD/oXG+YncAX5lDvPbsBYCVtxU6GVsvdT5srQYgScK?=
 =?us-ascii?Q?UoE3D0q30oKQkzgx5yTqJ6sTpIgOcqNgftBsYzHJUWrgnV1BpGrCPqUvgbGl?=
 =?us-ascii?Q?v6PVe0ZvgZYtOD/LQHLYOgN1wIyhpteO/m2IxsJUS8pKT5NjpKL9rz4/J67J?=
 =?us-ascii?Q?wgv/fFeCXnuuIxNZcq8r8PoT/nf94zB+WMl3RGIAQvBCnrmKgh8mVO7OYiz+?=
 =?us-ascii?Q?PHlpTgErKsFKvsie/ecf5UZVUKNfJxUP54OfuJS1f1uIUwNV7Je+wnY8NRzr?=
 =?us-ascii?Q?wLqZLjq1j1OMk08XoDsIJ2M883bwDQkbBy80DOgJpYDgtEtE/96z4Pw3L0z+?=
 =?us-ascii?Q?F504j7NQ/kBxUvJ0lpH6rZfEPCiS64+FHmEd89867GYcEVTiNrh4uu9t5ytd?=
 =?us-ascii?Q?Ape3Uyz7za2B9+TXPlRdAgIDc1yl9DPl7L1D2OhlNuabXkqbYfnN773dbiM7?=
 =?us-ascii?Q?pUTpKjXtF5uxTItPkCfd/FFJ3Cc+kyjIyx3qKuOUYhMN7JACI6sNKyXtvNuT?=
 =?us-ascii?Q?CVhyGuGiH5W2B/s65XsGVZOLHL22X45ffbEQ/wIf8hoJslwolCABdPqHdszG?=
 =?us-ascii?Q?wUI2myWqYvjiscUhw/FZB9eJpIC7HvoROc44TG7EhooffrdGMJemF+IGO6Bq?=
 =?us-ascii?Q?u23OmUA8mhUmIu6ykw6M5TSu7Jg9rfpB/n9nMEUCnKnGWZ5uzxB7mgZb7c+d?=
 =?us-ascii?Q?TbMnHGiaTlHHK7TN/nKSqa3DBLlRm0BHgqp6j3aGyfAN/Y4ns3c/CwiZ1+57?=
 =?us-ascii?Q?3meD4oOPoAgASXFZIgpVzsVdfce7TP9J/tQEpj0GwE9MrnnqWuijS4PcReGL?=
 =?us-ascii?Q?Bcj0cavUZoiSyXs5q2UucMnrKRnAEwT5Uw7skZHBAJU7A0/PcQz8cc2xbD8h?=
 =?us-ascii?Q?I3qkDk23MIG8eTRl/ryuOBzKjypXzeoj1Yscf+aU/kMUgCiv5J0788+fwxqf?=
 =?us-ascii?Q?3MSIbnyiNMyAf7FhbbLLjdnZOQEd2wxPZ+yrqZh/feeHaJ7/7jPr6xPLMsJB?=
 =?us-ascii?Q?S7pBE/znS/R1kH1vN0d/yN6yat++VsRy80bF1udS0U46KoNdZHPO8wu5p0S5?=
 =?us-ascii?Q?NyXP0QS5yKWYxUbNhzwOGpnOI8+lQuV9xFoGfFewR1+yGg7mbq6rA6Q8X/uH?=
 =?us-ascii?Q?k51tDqH2hUcmVfF2N3chq3jS2nQ6L4XeMCGB6avkfdbXWuhJohh1mb/O4aHQ?=
 =?us-ascii?Q?+zAdt3vtB/dZE1TLa8Zm8vvx01M+TWNqmBLfaar5CCj4IpI262AIKj5p4DUz?=
 =?us-ascii?Q?JgvfRY4WW93jyeacSDpyLNwL+C/Qs9L9pyV7lEyNLTI6JOXaun96Xjf4cqdB?=
 =?us-ascii?Q?T/I/1pXj0D3i1p1YNInUoJRDc5Alrz6VdUdAuw2u4cCFPQE8NFRh7jQJTtza?=
 =?us-ascii?Q?CQHw2M4HpJW0na0IXNZUaG7YscVUCtzqCWS0zjJj/UvTuG/uP06H7IRaOzqd?=
 =?us-ascii?Q?t4Fvvr+a4jrzrw37ecbB6j//VPyZePMkGkbIr3m0RG6uoE9r3gVFReugGqaa?=
 =?us-ascii?Q?eczd+3mPlVWH/bt23go6NQ1P+vdRxR7pgL2A9+VxbgtgYRGfVUERbCtZrvSx?=
 =?us-ascii?Q?EBC4KrPfCsiTaYIt1f3KeDRWx/1wpzG99U91bfom9XLlS2+ZaM/o+JUWhvF8?=
 =?us-ascii?Q?cD73EPJmPhy8hDGC5ylk66XORhrvqFMuWRDAVIfK/XjUSxLhRsgpxVsl9v+c?=
X-MS-Exchange-AntiSpam-MessageData-1: g5P0jfkjQ/NSag==
X-Exchange-RoutingPolicyChecked:
	r5mkpX2ObSNgZrxgIr3kykIfrHoz3+K2qANHcFviI7ZwoOVuH0Gm0KEkrzgFbm8tQ4wS6W97yrUj0uUwlezAhfdy9AkdDFOZ5aa6EbqUJTSMnvYKlIN2je2FEwsUxUKnGUnJ0dvsdwWNa/Ip0ECNsQK5Oq9eJT2T1UTXqL3JKjkuNxdCUS6KNojvpnLHMdHY11o4o5Ahjqen2DTr7iQLYqgP0mJ0jOOL0bFH3iGF5fmH3Cdywi4+h0V1PaRbSTzg9lpbWYPU1uSqDuQVMnmmOb9Bm6/lLN9aTW7xG45JwK1GrZgOZJM0tZ618exGXzMrpLMA3DZoEKHAzJoOV1lg+w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QPxskOSmrqKwOY0jGpB1yRwDJG4dd+0cthyLMDEQCP23/ETCwgINIJdTbsLCiZl3eduRIJNYZxHtBjSpQYfrk5Kj9Ev9LQD/stFwrytiYZC0hDkUr2lLLdj/Loe4PMm68Dw4s6YXuwEMtETZL/ppEfDm1r27U04vMnY1/ceA8d/qv/FwKhowf279vdKLuh3FD6INWmjOrZTOjai0kJvOsKwZ+8e2xqsodcmntfRT1jCD09FZyPupbA60DkDmFkJf0Lg/zawcu8R8gLAq5xc7LOOE2RPwg+U7PA/zW0N/dwQ5iefEj+UTliADsaF/w9uZDFb03NRgg1dMMcaS6y6f+ykRmVtumZGtINY1HIzT4Lphqune7loWcLFztuo1BL7O8FJVJ/LOjyFkl6XMTAaLRhc0XvD6Om+yc4vCDiM2JBo2g9iyoLPIhQNrEGBEtS+Hp6wkZ5hfQIcGbC0cleX3p8JPdjwq8YAGY7zwgRV8mZIF8NYjeu8iHMX5IxgHMSWjZhqH7CMQAcgF+LmeD5yFq50AWitAbKWrgrYMAwOjoi5BcaE/VtFYzYdalna+U8ZT2BOdnE133Qe7+dbdWJgiq9xXsaNOte2PPIcObSyTE2xHUchFRothSSkXzfxdNdN1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db039096-68e3-45d5-f240-08df07f8b27b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 07:14:43.8463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnur53bl1F+yt4FiRJ5GKLkmIZN5jx/m8CYnuEtQ+9uqx3OWAaRrWi3RwRRE+NIx1/EhrcD79kJi+ha5KaTPaPw6GLaQbj76POzdmw8wFQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8310

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
