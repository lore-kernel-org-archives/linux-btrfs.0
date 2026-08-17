Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E459B358D27;
	Mon, 17 Aug 2026 05:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786944215; cv=fail; b=GvXxpsry7ym0quINtEmoiE4sqqf45b/WP+Mjy1RrWXavf9Txqb2erVOGPCKT1sfh4b903llNDYPoYTdAkzTVH4rpvg8PqTBzZbXC1+MIZJyoWz3PKCx3HIWVh6mctKlMFAZ8TAULFMrOU03EECl5FgOLYz8HLhjW6S0nUzPntEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786944215; c=relaxed/simple;
	bh=bdGEoE9meGAlsTF4Yi3vPfOs8ypztKl/XNLmVbP2F5s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Bo51jQXgg5ygYggKwQ7OINsxB+/f3XV2EtH6M9rYaaLoB9y+1I5ZNqK1RCTVZyakFBlfARy+XXKWr8++mfo3pXrV6bqTe6Ji2vDDbSLa/G8WZQOo4ckOf8cfexBwbq8kr6kutvhOBVdoHwcLmDIc4saTETkBV9nFwNf2hwaqkaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XIqoSYvn; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XIqoSYvn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786944212; x=1818480212;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bdGEoE9meGAlsTF4Yi3vPfOs8ypztKl/XNLmVbP2F5s=;
  b=XIqoSYvnZNSUzngo86PaBApWt3vGihczXlOeZ4ZhBHnpQ7hVsgkIOsm2
   Y5Fsnh01QY6mh6C14Tkbk9biY5nyzpiZkLg0r0EqUwvsUJw48T3AD62NH
   nRQqc3IhB5E09sfJsBqQa4eeuOqo5jxP/wUdB0NA/HN2ySOeh7y91jw85
   DTriqYMjMD5ZgswIqwDVkzOfwzwCTb32U4PKXKqHXuU4JwEuLA7Qw59S3
   yZ7yrjpHKqKouJd4Hr/6xzwnQhMICn4gjummyxINTnBf/4plhxpVO2FFV
   ywW76aEsWwkGizw2WgfG1OAc3ELZVVCEIx/zl5erFmnVi+CHZq1PKS1kc
   Q==;
X-CSE-ConnectionGUID: qA5rzt7wROyJB1L4bnCPuw==
X-CSE-MsgGUID: A0/u1YSmSE6M/LlkYoEKHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11877"; a="87333348"
X-IronPort-AV: E=Sophos;i="6.25,228,1779174000"; 
   d="scan'208";a="87333348"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 22:23:28 -0700
X-CSE-ConnectionGUID: 0b0zuqDmR8Kd3EVyhP25Nw==
X-CSE-MsgGUID: EqvlLP5XTcmhtMV2xixNDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,228,1779174000"; 
   d="scan'208";a="260588858"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 22:23:28 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 16 Aug 2026 22:23:28 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 16 Aug 2026 22:23:28 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.25)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 16 Aug 2026 22:23:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZtlK0JfxMWFf5uhup71HiO1ESrBZpZqjpvsJRCtgX8fZI53sl+VE1dJV7YIt3WOY1V7HGQ4SOIw5KqM0MPWK3mBOnnAbhVDSvnjnNx+cx7eAhBj+TRuxWxkSpLDEDRC3nRQbi41ykVT24LNapDq6bzeO2owGfEo9ni8jMSwonJOA3blWmz3rlnn6BvJL4rgygeiovstKRap4NKKh9y3HAgDKmuX4cx+mCf52ON8kw2wssnQG0b+eG7bLcJudmszgbWafSUZZilnM76F4KL0ayEgUwCRPBkrESAIkaclIzJa7c1PBEU+DdzI99C0N0cbn2NeXhjpgimjY4EqZpvJfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbVj7YcqgqcLua1Sb4BJsd3zkznDus7ePE8B9+8wgrQ=;
 b=Puu3u5mmg3ZJt6rNTTibbZoZs+tF1hIavwKg8wibMHBqvEY0gGhSiiSzOV0NSXtwsEZ3nTDueQuNGyAzAEUnZ8GEfK36D/ymol/rbgEejtAl9ib0uWag0Y2N9hh1pfzc/b9ZS1AV2UREzOvTZztkSLpIfU7Bpvb3uJT29VtlNnZBmARqJdFcHzPHDhqz5xZuoXxFRq0Q4WNKBWqJqXh3PpdFz3rL17XRfCbdJC90EHSdBFxaHMV4KuLQCkJD10bwZG9YU50prA2P1XOKmnNf2sXZ5pdHrv/+u/MDFPaqyDt0MRjSAk9vaZthMwlmtwty1lte2hqSQ+IGGQg0MOnJSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by SN7PR11MB7114.namprd11.prod.outlook.com (2603:10b6:806:299::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 05:23:22 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 05:23:22 +0000
Date: Mon, 17 Aug 2026 13:23:13 +0800
From: Philip Li <philip.li@intel.com>
To: Yichong Chen <chenyichong@uniontech.com>
CC: <lkp@intel.com>, <boris@bur.io>, <chris.mason@fusionio.com>,
	<dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <oe-kbuild-all@lists.linux.dev>,
	<willy@infradead.org>
Subject: Re: [PATCH] btrfs: remove verity Merkle folio from page cache on
 error
Message-ID: <aoKawcCHfWigO8Rz@rli9-mobl>
References: <202608150828.VDr6P7DT-lkp@intel.com>
 <20260817023726.1731478-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260817023726.1731478-1-chenyichong@uniontech.com>
X-ClientProxiedBy: SI3PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::19) To SJ0PR11MB5214.namprd11.prod.outlook.com
 (2603:10b6:a03:2df::22)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|SN7PR11MB7114:EE_
X-MS-Office365-Filtering-Correlation-Id: eb60ecb6-94f3-402f-146b-08defc1fa7d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: hYJuP9kz3/DkI9j9RTdcGnQJaQV7nig78Av9Fevhvl3x5PbxCpQEb3N0lc478+82NicrMDp6i1t4I4u/wFtncTNCMpLZy5fXhWpzSDwch+iqEAV/E5DXzk9gC4zjnH1lkw1WK/+/okWe4ffpBnI5UY5E0ECZh0xDdk8M8L+kCnTYmNqNzQboRZ6jnOfLzeWxFN/KLqA3ccfr41DXJuStWWvE2I02ZeIIoYripdiVvwtOEz9ACuWjBLjXL0qnPffK4LkIEemMACJ/o4NK48EjA3UbEZSK4IgJQw/Q1T4lch7L9nw8TZ5AConuCG7cbCkEW7NO6jTn988cYOf6TTQPj5vNRTcZszcay+O6cyQJ2M48mcb1+ptRawpEN8SUWAO2sTfi18E7GsTb709L2zwFo0ZKR1ZfKMmbQEC+n0//J7zQG1SjWtZuueZSTUcK8j3qt9+VWeydtDfe/BVJ/O7jJo38k2ST4qO+NLv1FYkhjVE0lFMz5tNvat0iMLaBqRONbbFxbylL77R5uYDSVFw2XtQs8IVhKLdSLeNcZI9CgwkvuFF4tvEhV6PjstQ2IZ4g+TYe3RITlKBnDAxjVrdZttW5DuF6CZjiErm3Z1CUy1d0Vekil90t7nR2CMuT7IHeXCbiX4uljH5UngRfRns9Ks/q52MUqEyXxmP8gVuDkVs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DHudKJmTjGSvMFVizfu5sgoLdhQAdUcWh+kGAq1VDSdJADqNLFcyyiwcPtQa?=
 =?us-ascii?Q?OR0CSUryDw68deMv8jWHoNURZ5fo8iGZ2+Eqrbu8lP9FPeDpegE2ySCRC2Dl?=
 =?us-ascii?Q?BhkTGO/8WGrom6q5FOFVHn0EVa755DqcbdK8q3JfgPd9d7dtdcYdh+2DsRtL?=
 =?us-ascii?Q?8ZFOXzRoJVYcSzKjrwtuI9IS7mw7MAqs0+eh3w5TP1zKtVuszeERkjMhfOIj?=
 =?us-ascii?Q?8r9VX4Yt5fgGLO3P8LHjogAfM75q5Et76T2paQrNiklu8xZPoP3saGFZlklF?=
 =?us-ascii?Q?lTJywWgOPI7EqIU4A8NcjFDY/lYOYLOqDRp3jeUXdDwjM3D4/XdnyogSmh7P?=
 =?us-ascii?Q?v7I/QczwEruWguswkj2Ktv3lW/znKzHxefMUezsfOPYerRxMCKGZ73B4+hR5?=
 =?us-ascii?Q?nRG+R3QMygoIOemZYcis/G4vACyhKWTCtfu9KFK1CLFDFztkDmT12aifylxe?=
 =?us-ascii?Q?hv5FKO29/MlTiSN+xoffcbIM6jb47blecJFtJSi3/bn1pbgMOpQE0iDZW7P6?=
 =?us-ascii?Q?9MfoMOtA3d0remxg2UUCieRgQuZVnpAKyHIUfYwYl9Iz2I0LrPczlaQLuOdd?=
 =?us-ascii?Q?9wKv1orIBEzIogy7rgkxkxcnkAbdAcKRaHWgb0GO2OCDEcmYrQJEXjYnt9xM?=
 =?us-ascii?Q?U1pk8PDzgS2U9DIUpD5Hjaw5EC+lmCAoFiOM7P69Ia8uk7eHnc7o4bdBMpff?=
 =?us-ascii?Q?nFUtLQI5Z/zyHmY9ETDaYyGbvYbC1FW67ADJVxPvnOE0gR7v3vGB55r/xyKg?=
 =?us-ascii?Q?e6gkS+7TrwFfuLXKQV2xEEE8zjm+ZxgtDhKrNG8rxo0Q6XNcO3k5yVCcGCOh?=
 =?us-ascii?Q?Pj4GZd94xqXzJZdblctH+ZpHq2f6lD/bMaOLIBfi9bkTiYLp5G1KM3F2wGyC?=
 =?us-ascii?Q?pEOpCZPs4KS4aAAOxO5cQ68s6yNMMTGjnaUawmMh7S1fr79RLf4tWspwbVww?=
 =?us-ascii?Q?kl/wIlQk68osAJ3kJon/pqaoXgyZxd56pCaTnXA/WqgscoqNraoBNJqwc8XR?=
 =?us-ascii?Q?pG3Qdu+32BWeD93AFakTKx/SuIU5txCGHzDTjoyBLOfg4icgwnlJQBwSaG0L?=
 =?us-ascii?Q?b8v9LJJgs9PwGdV146ZC7ZTvM02EL1ek9A2ZBcRO98VUn/5FNLrx3b2/tq/D?=
 =?us-ascii?Q?aWTYYAHJX3dnvRGUzca+deRl9Tei+SgmbXjPR0ngutKkUEzZIx57LsewQYdg?=
 =?us-ascii?Q?HyHP4my79schZueb4HTA9Dd3hS3F3iCYvVlhy+I7GRf9WsrrSUy0OdONVRaI?=
 =?us-ascii?Q?s0Qhwp6hSiyxoywhqJn6sdV0ZiS6h/NRMTHpNGtE1ns0ynI436ZG1p2mWwqW?=
 =?us-ascii?Q?AENMCWrJv+HGrNhqCttLfnkQ0SFnvFylf75UPg2ubrQ1v34JuPlVMo8hWhhg?=
 =?us-ascii?Q?WkrPEE7SPIjg5IsLArkLwklgTue0RDKoUvBCJDEVKeiwSKEAGnT+w8r8Onz8?=
 =?us-ascii?Q?CseAV0J6/pOJOq1c/lvgnL6bA6lQrN+EJ82A23xFXdfgg57nR72KsGXxEBKW?=
 =?us-ascii?Q?b4MlC3QJNrKYZZUnHUr8Uy0t3icCKI3MHYXbB2a3xH7gSYhvcnU/pmIdzZC8?=
 =?us-ascii?Q?O1Nx8osZawTHvJd+LxN18EblWImGqd6m9VLrduMONPB4NBn7OX1V/mprbz+c?=
 =?us-ascii?Q?cyN8yEges1QjsCAGSJjxzQMdPq2VPhPlhetf6zMdt0KZOIBsROTewivlueNq?=
 =?us-ascii?Q?K60uQkUXejDos9HrJd1ijY/OUmieo9XVYOg3gvxDoe/esRNm2AQmBsQhPimY?=
 =?us-ascii?Q?8UMUIsclLQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: gLCB5jDdHnQFLT6a8qWXUxtKbtB5YMtRHdR+r0HWQF77qVRtvfyCYzLLB2LqhqhGLa2Pc/jIJY53VBlT2CAxxzBEnjRzLXJu7BWoIEcOT536Qp01vldfX0noUdpSRp8+CumY8qxHo0rfHtzuFnhIfTSt5qurnWcZMt869vSnSD7BXgtXqpUbAne+z71wEz71V31CUL/XpBELk1KlWODFeScrKIRYaggEVOIhXpcJAChPDEKsb93Vo2LpQF07f6SCUNOaGIgnpfrT3lBx5ErkeGYSwWUNuPshcvvbkwL5FJFZPVf6dA8eRHXZPdcR/X8lXEvDOcuPu97Wcw6WY1dF2Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: eb60ecb6-94f3-402f-146b-08defc1fa7d4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 05:23:22.6110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SrsvS58iPvxXIPwh4g1TCuDFJHIwedU+GK99k2cJlHGS1L+ZrZDrVSSFJO9mTRrlxJjZPHD4TsCe7yofTrDmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7114
X-OriginatorOrg: intel.com

On Mon, Aug 17, 2026 at 10:37:26AM +0800, Yichong Chen wrote:
> Hi,
> 
> Thanks for the report.
> 
> This was a problem in v1.  The patch called filemap_remove_folio(), which is
> not exported and therefore breaks when btrfs is built as a module.
> 
> I avoided filemap_remove_folio() in v2, and the patch has since been reworked
> further.  The latest version no longer calls filemap_remove_folio():

Thanks for the info, and sorry for the meaningless report, we will improve
the logic to fix the bot.

> 
>   [PATCH v4] btrfs: retry verity reads for not-uptodate Merkle folios
>   https://lore.kernel.org/all/20260722025435.1493093-1-chenyichong@uniontech.com/
> 
> Thanks,
> Yichong
> 
