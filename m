Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECB11B142D
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 01:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780278762; cv=fail; b=kGNdWC8asJgKhYZKAly4E0VONGYkbeHwHbeNcRhRW6hKKZ8KRVDuK73Mh+NeflQNjlv6SO2NdGMBzByjWTj583/TV+Eba38a+rQYYEGwAXoUuftVEMN0BCkQ7ORGGf+w+JVpUSO/P5yKg4gK9QdJIDzufyMdxCumlANYHT6xPjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780278762; c=relaxed/simple;
	bh=REeG3U/fnpq2sXeQnRkq3hTzz3OTxEH7DJVWQ6sFBPA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HQGlGE2C5+mlL72RTb/QIaEe+BttzNEpqz9aE4fUO6LPF88YmQ32bni5bjJLw2ritsrYJWzReMmB+ItYd047BjgA9/qXfyEtTU3qSN7xNCCpCiYdbvAY4clAIoQqHWdB3icijjtNsoy4UsgTGhse7UFZHWDTiemX99mQjqvE6Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OCw3zmjn; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OCw3zmjn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780278762; x=1811814762;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=REeG3U/fnpq2sXeQnRkq3hTzz3OTxEH7DJVWQ6sFBPA=;
  b=OCw3zmjnG+OswQ/5ZZJpyztMq/CSTeXM7m0IzkPVekgybVC+dBD0HP4G
   KX1cQPD/QZZ4F6YLXg9luEUPKi5vxzWRq+1YZ/n04ENqrONspbGWQ7WOv
   B31GhtLbRUlUUTq5cwgHS1iYLQvwZLuOj082HlSGJ93b4ngoDANlWWPPm
   ERqvKfVi4EAdQuoWyJOx10BZjx/mD4Lr07Zw2TiflAvSoMn2BxAYC9v6u
   E57CUCjsBNK/YxXMULXCjEBu4JtImOt2/BNii5a6fNDI2lLAqRmk6TQjq
   LYi+V5Zfab/2TyzGRVQRBQS8tNvf7Aj0qj19/uiEx7nUxV+0YauUgF/UQ
   A==;
X-CSE-ConnectionGUID: p7R2a84tR/m/kad23LsEEA==
X-CSE-MsgGUID: cj9xbA2TSGuXgCd0dDJzxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11803"; a="80760583"
X-IronPort-AV: E=Sophos;i="6.24,180,1774335600"; 
   d="scan'208";a="80760583"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 18:52:42 -0700
X-CSE-ConnectionGUID: WMyQqN12TIyddzwXVtyYdA==
X-CSE-MsgGUID: e19wCwP0QeCu+viv88vrNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,180,1774335600"; 
   d="scan'208";a="243271355"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 18:52:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 31 May 2026 18:52:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 31 May 2026 18:52:40 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.12) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 31 May 2026 18:52:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F2b9YhPzrseO0Kgj30haVAegHfIswRCDYINzD+iZXh21lpPOc4lxBVOX/JCyrhD/LO32y8PifHG8a4dMwKVBl3gzFuJ0K65aFJwfqeATtVnxT7Ifa5swF5vx8/lKYvxQYj2+vEISOnp0CkI9G4k8he/wSudKcUxs5yjClCI7McvvwoxUTqz2916PgAmVfI7yOCBOPnwkAvyxVo6fQglSaMr8qqsKgOY5Efx55RzPD/KQtA3U2TdnLTx53IbvbXBXmMez6E0fYHvxzkl8lPQMVbVSW1JxenJ35Pv5Fzslq938jGNLejQBCKLv5mDyGw9ezE1Fobvi03rItThMgLf8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvLG/JrHFYKkR3YBfm7UuD6g5lMqR2CZpny5gysE21Q=;
 b=RRGu6VX13y47wBvNjhJxbDsFw0VmbgHkhmSCPbCBEupHc/ljOFIvYDXKOJAUNC9C6XNIgNWPQ25CcCqz4dyrZNWTOg16a0HfBmEyAky8jb61dVKGvTI5q2IPbmbN9Ib12cwCoyYIiSebaJ9W1dtQ9hDISddBq99Pm6E2YvLAqwAzMnF74GZ+sjhivU1m2yKLysvcZfB0sGHeKFMZedTl+CLIrNCZnmYSdT7D9bI1hX7aAXhaXXuDmnvRHtQfy8ZqKIB6a3XZUIT7frevSELt6wNi1N8wvy195WrNasBQjCHDtlQrAxeAUDvPvGtVuBEsMZ7T+v2b1FdXbvI1kimGXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by IA0PR11MB7211.namprd11.prod.outlook.com (2603:10b6:208:43f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 01:52:37 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 01:52:37 +0000
Date: Mon, 1 Jun 2026 09:52:31 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Mark Harmstone <mark@harmstone.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, David Sterba
	<dsterba@suse.com>, <linux-btrfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [linux-next:master] [btrfs] 551e510a97: fio.write_iops 12.4%
 improvement
Message-ID: <ahzl3454AkoRjv3o@xsang-OptiPlex-9020>
References: <202605291631.659bf248-lkp@intel.com>
 <c62070b7-c852-48d4-890c-6e1ed9d2d430@harmstone.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c62070b7-c852-48d4-890c-6e1ed9d2d430@harmstone.com>
X-ClientProxiedBy: TPYP295CA0052.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::18) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|IA0PR11MB7211:EE_
X-MS-Office365-Filtering-Correlation-Id: 197f8ab3-4e9b-4f55-ee03-08debf8074f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 3Lr+jCX4WrPUod7WQ1j9DXchsp/feeChfaF+fVQhj8P1XC2NDkF/FOdrmV8QbGtQuyP11ai5K4ZtZls4KBQZTpkSnbPYKyvJUPLiOUXDi8Nd/IM8liCfbUUA2bFM14kpQCGhovFKDQiB8SAX5qP6RlJv74TpUShl80TuI2EsR7W6y6kO4T1BvvGHV44J4jvA10WHABbGGe9TO/SPw7ifUXFR5RsfSr7CJ8JXFxzAfLvN/aZ0BhUYiNEX6JWwVoa1SD7UURhhv05/edkkDfjpo3cyDDa9M4y4xXbuxL90peWtc+PWz7ssHZ6k6plfmLlNOiRM1mh580vanDwPRc0SPvXNjaGVRepy+HPJFFDItpR+IZBcZu0sYfLAnKdIy9X8E25QlropXeh8aoUZQUr4nkOHc4M3CdwXL73JK1LY1Rj4JJ/ETPBfE0deKy+0BDPB09H8AE9Hf2fJHsTQ77E1sgHBdtg50w4RLqSkrk6sPqJxRMKPlmDRK+XQJ3rpsABji36zro6t/fnncU23Nh/uDy/MEY4Ud3vKzjnRBLLcUu6EKoPBqLRaDhCuDNiP1z/gEIgabfW8iwPDldUKh1mzDUDrzu8HD0XNeRLlUsU9d/bbhERZHbvnUcLmufLwpM7CWvNGKyDRpW6w5EdNGiN9gx3lS2VRiUJyETWlDfg+9VEJvfHcbO1Dhvg/mcJftkLX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LclKsSJQGiUtVb2r3cP6OZRLmKV0YbZV/lo1RiqFS9pG37Rv2AObgTNqBVHz?=
 =?us-ascii?Q?AoHP+YW8FuNzh08+nk1/EuAatJQLLGhRb3ZZk9K7HTW9oYAgIBiEaibijiKP?=
 =?us-ascii?Q?pBzjp+vpJUCjGforqwDLo3qEmyPWFeBH842QzGujNLWuOjmYZS+RUbqlD0Jp?=
 =?us-ascii?Q?VT4LEhgUrYCW05ivgQe/rjZcQ2CvTJRDkcqVnxmch+NawBC07rJlpjhPhh+i?=
 =?us-ascii?Q?R+E+wrLmcyMvTzq/0TK5FyUKT9VL8ZJJPKmpp7jLOgwXxU/Ps3DHH1jieG8j?=
 =?us-ascii?Q?pMrhLE9rf3hUsJ7a2N+GbDrraTA5SKQ84r7SsclJ+oUZTry/G0U1DkH5qsRh?=
 =?us-ascii?Q?ac/Yf7TrfDciQGGBKiSgEIS6ByKPO22ks/zjq2hpZNN9R4g1pL7NEGTSGlrQ?=
 =?us-ascii?Q?4I4GYRsv6zsJrR04IHtnpR7yM9bB2pIfUExT3pGvJJSaXearR64kSUSd6SnR?=
 =?us-ascii?Q?Ry2nDDfcnfT1Z8mXW4GiwHKsce74wG8UylkNfEOPZ7BoKWMdEP+PnssvAx3H?=
 =?us-ascii?Q?xBkjpOV1ZABd7AXOpDN5M8l+rUizUR7nLRuyFQIFDVPyxQkn96wxhMQ9mWIi?=
 =?us-ascii?Q?S2WZ/soqs0kRFURMWbWhNXhpeENC7eH2ikjettGQJunDpxlKuwQtpf2Vhzlr?=
 =?us-ascii?Q?ZttJUI8yfA2aTtPqjkKIY05deP1lke9/jyxGjExDpHdTjHWwYyY+Qga94xcv?=
 =?us-ascii?Q?E4rkD3M2fpVFjPKkDh2iwhLDIn9aHnOuOAVEntBQ1tKV6gXwAg/D+9hWRtrG?=
 =?us-ascii?Q?jPoyZzB0DAd5raVl/zMBfe1zr952jGjb970KoqRQuP3xLc4UcS7gONvs2PRS?=
 =?us-ascii?Q?ETzn4OAiilG/N0Ifo3vMxrPoRJbP4DJ4OVyLJe+XDXCyNXJr7uCU238wO6Wc?=
 =?us-ascii?Q?fNyhUl3woY9N7p+kHiWcfbQGHAYcdSlRoan3fz/fXz+uSkzsPyDUHuX0jQE6?=
 =?us-ascii?Q?hOF9mpOJtJM5zZ/4gG8OJFrI1ZDJZrVMLRo8gLnGzCKTdCNLVxGQqzsjhqBh?=
 =?us-ascii?Q?CU8AZXwDGRU2a/hrdbRxs2B7daDbF+LSD9OaBp2uq5e1yNdGoFvFbTCQUSFJ?=
 =?us-ascii?Q?fIP2LsKp9LWmPfj5DadvbHuJhipT0WdSbvTHBsM9ZRykdryZwGTF9ynMlWOB?=
 =?us-ascii?Q?jpwyPzYnG2tvXOWYtoD1qmXCLezPZTJ5r+Xyja8SRt/JfN5gdkSMM+QnooUa?=
 =?us-ascii?Q?eiQIo3u/CHjZK4gggayss03034xfawSCC3J7PD7MaYCuSNbMp8dKOVglQ0MI?=
 =?us-ascii?Q?QGUZBOR4RFovhWXSXrGfWZzCd/9/vH1vD9w5nL7Uc/8bAfsEpcMbllKVfBKV?=
 =?us-ascii?Q?CIVdBF6nQmZQozDvfQbIFPIpfaksxroHQMN7K0UCaE6xgNiTvI/3Wv7kCdVi?=
 =?us-ascii?Q?1wFwoc7mgT3naYd+nCzDm9XdCwPwmHyj8ILfar0WbD1y9Jzv/L2j/m9S7ovw?=
 =?us-ascii?Q?LUb/dQItiyVlJ7ilLBbgE2WUtLxfKF5GjeAoK0nJmY0I+mVJTz1LqGvckDm2?=
 =?us-ascii?Q?yJZIvll944tHxthDnl/8gQ+Ia7C4zwgegbJCx07nhOf6HCfAOzWoIp9CF4Kn?=
 =?us-ascii?Q?WnbQiZ0qbYa/IY5A2czrZGZbVn3Y7/dtKUvqgLxcU2ZUEpEeqBM6/j5kc9ut?=
 =?us-ascii?Q?PXisVQ7g5OKz9VQhJiCuR8bVuMziy4x7uTpNdkydYu323Va2nNgwPVoekvD4?=
 =?us-ascii?Q?2KIVA2uKpxR0dBjSFMEp0iAG0jZCqv41unQYEZvZgIYxmG25PdBB00kvcrnn?=
 =?us-ascii?Q?kcPaEy8rWQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: i84vEEIfJJLpURUsCAioR5i43ivfIZcuhhagwMngsNv2WkwRL2sOpNNx53iYTmMbEEhsxHK88wlzLuICpOyQHQfQlWfB768VvD8Yk+OyYnfW7kt/piR6BlPHuvsqu8OA+mnPgVQNxLFvoG87EkkXmB+gfuw4rDW7ut2SkcnqO4ttzWOT9HSvnPw15kWbJ4BBlXgqeHY6+b8+PvlkW2IPLMcFgAhH5eHccWpatZTwMpbNL/byPbioFp4cOG7foKc4Z/dDb2wbFUFRPjayiRZzfzmhit7Ml1Ueu6C+MnbPdH71BWqEE9RUukXRWNVMc7a0RYUo4uDe3uld5aPV2bfs5Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 197f8ab3-4e9b-4f55-ee03-08debf8074f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 01:52:37.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBz7b5IsJ02s+hjZQYWG9nanps0KQvA5wgxhN0Mbb3hCCPWy83/NCL4CUZqbuFCGzQ+KrnQtzMmlNpYsWe9rrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7211
X-OriginatorOrg: intel.com

hi, Mark,

On Fri, May 29, 2026 at 11:39:39AM +0100, Mark Harmstone wrote:
> Thanks for this Oliver, mind if I offer some constructive criticism?
> 
> 1) Your fio script has both "buffered=0" and "direct=0", which are
> contradictory. It looks like in this case fio treats it as "direct=1",
> but this probably should be explicit.
> 
> 2) Recent versions of btrfs fallback to buffered I/O unless nodatasum is
> set. You probably want to add:
> 
> 	mkdir /fs/sda1/nocow
> 	chattr +C /fs/sda1/nocow
> 
> and then change the directory to be /fs/sda1/nocow.
> 
> 3) My experience is that for FS performance testing, the only way to get
> useful figures is by PCI passthrough of an NVMe drive. Otherwise the VM
> overhead is enough to skew the figures.

thanks a lot for these education to us! we will investigate further how to
improve our tests. thanks again!

> 
> Mark
> 
