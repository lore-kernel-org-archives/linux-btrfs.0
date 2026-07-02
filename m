Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F732DCC1C
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 01:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957373; cv=fail; b=iP00A1KU8VtEZ4TQQtWp1eGSgWKpAo3t2PcvZegcfbgnG6SyDgjlnhnAMm0Zj4vbupIq3EN3ZYQRwKKT79BMSzWOh3QMD0dQ71zUBU9UBV/vjaJuOSx4Tu2ex3/mHy+cy7kixvYBro6bbRX0AflwYslnmK5QxaxEHGYqwJc1RU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957373; c=relaxed/simple;
	bh=qSljXHzAYhMP2EJthAaGvh6dc4okFJUhk7tLbgG+0V0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DahS2sv0Y5nxaUCsHEe+BooSdbOqWxY9MJS+zDOL42/Xtgy7t0noE1/W9T40tQMvGt2t79a9ZVIzIpb2Ci39nYO+5w7se1qwnl6WopN44/2j9oSc8qT7N79imibX5mJNKMa4bojSTZFdlW+gBTc6RK8GjzinqnB0lc5MYfTwwXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M4ElsnKt; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M4ElsnKt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782957371; x=1814493371;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qSljXHzAYhMP2EJthAaGvh6dc4okFJUhk7tLbgG+0V0=;
  b=M4ElsnKtAkzanL299blxt2QGqG8iFtx9vzr+Ss8Wse0daFbWqwH87pxu
   jwF8wCKMQf3chnFSpac2gKotA7ILfVODbZePqer31zp61gXaBX+bNz4Qp
   ZxZRyCbzj8xC9YB128M6hNzTS2ewM9QfIZJtj30zRoiVjc7eoA6U+4me4
   Z/KrdTQnnAPi8IMqPAkWizXbU67MShzKPAiOrpn1ejPaAS2ZzbrLYS7J7
   ilrUPdrdDPTna8JbmFAiAloX4+A/wSbXWjSsov+T3+hCtVJxZYALYw5CO
   113yg591sy7daCYCRwTYSikyEalDC0BCuTOHiKe1hbNnYOfdiY4kLSpDd
   Q==;
X-CSE-ConnectionGUID: rwgZvXWTQqa5i31bbkXq0A==
X-CSE-MsgGUID: OaxA4qCHT7SJQy1kLJ3RRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="101122638"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="101122638"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 18:56:11 -0700
X-CSE-ConnectionGUID: kX1CDpk2Rf6Tiye2ND43bg==
X-CSE-MsgGUID: M1/8hAY0QQaXrgQVVrWy0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="256639547"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 18:56:10 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 1 Jul 2026 18:56:09 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 1 Jul 2026 18:56:09 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 1 Jul 2026 18:56:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0V+aWNtwfMl264QjywlMFaxvHd/wAFbldIvdPpPL16Eixox4UNf2Rq/pJO+2m9dVPg/hS/certQZp0Yr/Y1vDzAUe5eTE4iC/ZY5JuZkrc0UGvTIEXhcaieccuETUMt86Rtiudov80nijwgC3WXsshGq6Z/YkzqhiI+An0GMo8MZa8wacK2IeJzKtaauHQOG7gZId/kmqGG8ZV5r+M5HIzryeg1bEusKWG9IMzwBMndbCFr8mEhZXTV3F5ATghaz97jEnOzD2YZmO2e5SOD2W+91tExoeCOnh4TZ8KqFgx7fRs6D6VtUi8NkvvXzpmc2DNXFmCo9sLw3cf8cCxFWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWKJQITaqQfV515UX5oD9cJfqgzRy6V278MMCvwjC6U=;
 b=ZXGa+eSChvZ34rNWT7mFiAMba5cpvqY4xwlYRLXxj4QMIeXI9ODsTm9HG5meAuOjnHIuolE5ao4DfTcwwMN+zjVIDj+TgmnLdm2Y6gIvQbmAWzSC/ODfxB3X1YKI+Atn2QErnEpUN2stK4J+0WxaNg9jIcZGbFjW0dIjffntnbzCLne2snjaTKSPFEDpkladMwcc5MsLordcMwrakC/3ZNXfxcZXNC7Fs/PBcnK0lT1iFQdLBMRQCaOmtaVjgLl8WMekUjP8tMriLxJej/k9no/7zjEmw+2WLOMWvyS2nF4zDr4x2XR24OFMlLgyUTJefyulNSyTVP0etApy9XnBCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9)
 by DSWPR11MB9692.namprd11.prod.outlook.com (2603:10b6:8:353::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Thu, 2 Jul 2026
 01:56:08 +0000
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::7c33:9702:ea7:13d7]) by SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::7c33:9702:ea7:13d7%3]) with mapi id 15.21.0181.008; Thu, 2 Jul 2026
 01:56:07 +0000
Date: Thu, 2 Jul 2026 09:55:59 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Leo Martins <loemra.dev@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-btrfs@vger.kernel.org>,
	<kernel-team@fb.com>, David Sterba <dsterba@suse.com>,
	<oliver.sang@intel.com>
Subject: Re: [linux-next:master] [btrfs]  9a8eec6165:  fio.write_iops 22.6%
 regression
Message-ID: <akXFL+G8wOgFEM/9@xsang-OptiPlex-9020>
References: <202603112240.f7605968-lkp@intel.com>
 <20260701234412.4048647-1-loemra.dev@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260701234412.4048647-1-loemra.dev@gmail.com>
X-ClientProxiedBy: SI1PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::6) To SJ0PR11MB5815.namprd11.prod.outlook.com
 (2603:10b6:a03:426::9)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5815:EE_|DSWPR11MB9692:EE_
X-MS-Office365-Filtering-Correlation-Id: aa1e0975-72d2-440f-a947-08ded7dd1515
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: C7NzNBXg1o/Y01P+lE2sP1IemNAtTnuY+kTJGmTWDi1hqqrZmjtQfKUU8KPH7/px9QbpDAFPa9AqdNisIQSeuLnH8bz9N5j+CZIe/xBLhn4c1GXPDmlCOJ9U2+Kh+ZPgkd1TaU4t6npYDqD/Z59ssu1r+Tvi2mekBQ9SioUJwFGPfecfS4exXVqfqP5uXvSt3BfUy0VwYjU0OiPv2FkYftE0eTRyDPbuMgRVLQfqyD3M2+fsJeSGK9q7WJO/kPu6Vj6Av4omxHuvMlILO4DvLWsfaRG9RxpVFulGQtdeYgFmkXnQ4E+wXpgrmEYFjTS5775k6qwanhwCpW5QtVUtjWL84ciKuQ53jhlVJvIpUoXt2lCZ8jwNxrCmBKyelICVqE1wvI65pLC9BQ4ju/DSlmh/QP9ny+8o4i1uvj0jzK4s5Orwi2XZps+J8yYzufXQp2KOKJQgl1Dg2hmavvjeZQ6Yxwoiw6z6uqN8rw9uURSfYx2VJrfH2utF3rgBfbjRp41VIL8BJqHaGjblaBnocSnHHlhGsSNXJbCN8wyQSik++V1vCfRQWU1Vh182HHvIM2Wjo0Hq3D2d3YezB0mVry4LslfaEvuqQmjWleVRtRI7Cj27f2k8tJJSGDNAv+nyrxGM1kfijaZfqBMfPxif27Kqa882Glnys3ZHiFehBVU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5815.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n+D740T9MFVGxLHFRDAAJDbj6xC7yr6hVZpqtXgyO2c5RIdtr1hiqfQdu87S?=
 =?us-ascii?Q?7/72mC3d9FU/n6iX2A1a50kEw1TqL7jsBcLRK2hgiILlM45qfMGN2ZcMQ4ao?=
 =?us-ascii?Q?/C53dKyfZ121+Qpra8M+VQqHOwnc/rFnRRajJuloQa6eHthbF7jRsje3iASj?=
 =?us-ascii?Q?LYUBOOTFFP8ITR+sV+k93DGhcGtP9kYHtchzAzVOG/JO+oIh2IXLEnSaHj3Q?=
 =?us-ascii?Q?oY5wGmAEoH1SbTb/P7oAI0lEc2ZEKx7uI0Pu1OhliBbABYs43yZp3C/d+Ra5?=
 =?us-ascii?Q?hkixiO5rKo4pSs+Ln4YfPoa98lqvPtyB9mG/Nghp3Jl/zTdihQVpuTdtRgAN?=
 =?us-ascii?Q?9BQuZvA0KiVQVsaWCY5zPmS4hnV5gy/vYS/V/c0YgLMsWy3+REtm78M90DMJ?=
 =?us-ascii?Q?FuL0sG1JsWWN9JYf7G1CBYAV7oUcN1uwdthjEYD3yzoY+4ljhI70Zd+kz0lj?=
 =?us-ascii?Q?PSnsIyd7Ix7i2T2rzjopv5PZqCsnksNjIoQuR88wfh/RBSz5EinSbrT2+Pg0?=
 =?us-ascii?Q?1rex8VP7fdEMhlMo88s7lon5nsZ6eWSXAWD1UWssjGBX/luA18re2KdWQL61?=
 =?us-ascii?Q?Nj7VJ1xEpJC9mVbsvNe+7A/rnepo9L10k5qyHURCD2DTpxe7TlM2PdOc2OfA?=
 =?us-ascii?Q?6p+a2DgmUylWdqwDCxVDpncaPx57h57/ag3vkQvs22mYPbqwOl8LjQ5BP1Yo?=
 =?us-ascii?Q?c7IyculBo9r3RzT71MrWXj7tvXfTuKkww9EavCWw6/ZgglIUu3/06FfgfHSf?=
 =?us-ascii?Q?siVA3JfexcUpVEZW/qMimv9dinsctLp2r9axgVB7MgBff795jri7eefnPGPE?=
 =?us-ascii?Q?ELKD86cJ1656Zlcez6Bg1UpOsM3liP3o27fdm062X5KCvLay4MyDQXje8TE/?=
 =?us-ascii?Q?HIF+wuKsG5Ez63PMZuzFo01q+gNEDjF8JSEB085ejkq+FKrEf4Du2Hq7rZns?=
 =?us-ascii?Q?lD91ZqfjYw2F9vZEzZpppVWA5c3c1hN958MOGUk9hjBsIUB6P1lM2s7ZU6ow?=
 =?us-ascii?Q?0gZLTN/XlUhNICWspPsj8leYPK2gF9omB7HKVvQ5/8u52XcLrZG77SvGpPjM?=
 =?us-ascii?Q?er4Bi04NUr8HZCxJ4fsvmEgMumb6M0rEPdhCMZOP1vjmZc9wS5QRDFLY2ytQ?=
 =?us-ascii?Q?4zY/ss159YVSxEeA1OagaQDgjczIr9v1o+Qs+jHfVsFB1I9/5ppFkvuApMIF?=
 =?us-ascii?Q?kziOudOl9G3zd8dswBj59hbLTN1COkzwDUu84d6NnWa8/3STD2Y24CHrPa9v?=
 =?us-ascii?Q?OQppkS+vOZdp3KZg/zUSKGFfRUhiTG5WvD7tDojoo34Jzdyz1qsXSnHqLQ3n?=
 =?us-ascii?Q?tkgL//8YiwWz0qZ/wR4e/qbiX2zEDga0UDHYK7HBjkb9crgb2XKIb1/3QHzy?=
 =?us-ascii?Q?DrogHAiW3s6CSWKLraZ4SHGtfqp9BEZW5sg6aQMOVo8vCYYe+vnyywkKfCT7?=
 =?us-ascii?Q?Tl2pxA+BKRKyIi/PLQ1VvVSCr+M7dHmT6OWqvZ7crhkqmfHJmMb61SLVBeUT?=
 =?us-ascii?Q?Prmm9pkPXkkzjrLXoCvP+FCd0Qpv3Lf1PlIIr/W8ExEKWr6vf344MxkcUaXy?=
 =?us-ascii?Q?VrJDL43KX7H8HnZCXHLcoQRGjEjOrZc9UNSObvAV6KKpuu1Zuoc1bVvcKDt4?=
 =?us-ascii?Q?7ZiJJzCcZekbqijU6Hr7G9ERpW7R2O0VsuPbeWYbhmsbG/DAxLho/S/6EMrl?=
 =?us-ascii?Q?D088ATayF7cmp/3jMPwKfQ62eyuLhXazb7rI1uMCG4Q+ipbuGMxKeGKOMDsX?=
 =?us-ascii?Q?xhcDdY8IaQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: ihyho+3pStpaqzHrolNCQ3SmWpDsZ+haivqz/7Wbv8JkR6Wn6iXYM3kbY3SzxWKZV2PdQYyTjshcm6KsSJDBEOMlGzu5cGTIe8hmZ2eagFtodsa66buazB7xv5iXUrrK4lCV+sUJGDwEeRBWCk3Ky0WPnQiLdccrK3YiZdye6gOLs5ePTYhmLreg4rxO8G7gPke6oUBf60ay40jgJQmUB591nFBwCQz2nSUvyBwI91offtJB+sjCcbjmSmjQyW8Kn1tdbDzs25ZL1nRRK0iFioIOcybDCy8zEUXbsuy9H92Z4lJ+DloITHY3YNkqyVVxSVwcabsYDEfteKy1kf1TGQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1e0975-72d2-440f-a947-08ded7dd1515
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5815.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 01:56:07.7952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XEQA2QkHKiP/TAj6m/fg62mdqVOJhLdbgZU3ymyd2UczQoZLTR8Z6giZdqzBY4b9FcIo1Rn2qMtFyIluMhkBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9692
X-OriginatorOrg: intel.com

hi, Leo,

On Wed, Jul 01, 2026 at 04:44:11PM -0700, Leo Martins wrote:
> Hi Oliver,
> 
> Thanks for the report. I'm aware of this regression and the cause is
> understood: the flagged commit adds a per-COW xarray store on every
> COW'd metadata block, and on this single-task 4k randwrite ftruncate
> workload that store is what costs the write_iops.
> 
> A fix has been posted to linux-btrfs that replaces the xarray with a
> non-allocating fixed inline buffer and recovers the lost throughput:
> 
>   "btrfs: replace writeback inhibition xarray with a fixed inline buffer"
> 
> It carries the Reported-by and Closes tags pointing at this report.

thanks a lot for information! it's always our great pleasure that our reports
are helpful :)

> 
> Thanks,
> Leo
