Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1397D3BA255
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 14:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773239819; cv=fail; b=KNxxhiXDSCMYCkNNswv53Kr4FouOuHwn8sP2PN90UQph/V5iGv2TZ+Gdeepb6RPkkNfgzB2V3ulXIRINJKKJDIEw+WM7cDLkcHEmkBjOeYPaIbg2tAqIaLVhrG4g1EZg/l4m9JkWK2F+Mrtk3fB453Uk96AD2PaQWdrbf7O8lCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773239819; c=relaxed/simple;
	bh=ex4bF3Bq/AgjWITO/Cd+/QN9dF4XrJWv0Vl5Pv+UUk8=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Gdr40KQCuSz3UbFxHTwR8PyRrDycTLHxKyUC5WZCiYqz22yn/ptDrvSowh/gZ3TH027U53i9qGjlNRscqgIFNUpLXnuIu5mc7dLySDinpNmUJdKemj1f4yNKQE+vfn69+cOhr/e3XjOfyUd1I5GIkFXEIjflf2Ur2jPS2JVUtrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=afjbOBV8; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="afjbOBV8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773239816; x=1804775816;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=ex4bF3Bq/AgjWITO/Cd+/QN9dF4XrJWv0Vl5Pv+UUk8=;
  b=afjbOBV8jqk8fhukZNjIC1cCW31aA5/PG/YRjv+DDiGXj6sFfqSNaucY
   pXs7DtRhpB6m/ZP/9V3cEqFrz+npuDYmtS21ksqFoT+AmmwTXQi1SH4xL
   w61DCVB3dCbNZP/PDe+ZKbGrP1hKe9to/XOXZ7tffcCzdSZhj86LoMO4o
   m1k26EIN7MWSmf2mcBaV6wkcAiIsFpmkV8xoR9Hntdltfe68sZCl/mRdq
   iOmIRp02aavOEfFY7bfvLEd7nfB1yJ8X4vzTtkmZEc/4uRBYLfFLfm/W1
   lJ56gLX2ePxO0i6KqQwpJkzcASRVixn+RU9pEG1MI+neJPhqQIqbE7oxT
   Q==;
X-CSE-ConnectionGUID: Upjq2N3qQqGq2+drkgHrRA==
X-CSE-MsgGUID: EF+Ik/hmSAWT1z3KYQBzog==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="96925437"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="96925437"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 07:36:56 -0700
X-CSE-ConnectionGUID: ewH/llN8Tda0HJaHRQ8syA==
X-CSE-MsgGUID: oZ96DlMYSOiz/ftiEdtwjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="219735388"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 07:36:56 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 07:36:54 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 07:36:54 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.3) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 07:36:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=koNNNCE9DK6itSuLmAoR1ZK23O5frc2vw5Flp290j9LCP2uLpVv7aBrAfVrQa4xY9e9ul/xj8iLzxzfOJ/JQir4baGWBpkvhvJt/XxHXAh0qITn4HFdRsegmK0kCUnBgGbS5Heihm1ZM/yt8UvUhlC84AUu0ZX9ViyRTzU+JCnBS8qHp6IgbjTAy2amG19cRToPe9eOFGdNBSNKxdvOKwkTktH8ZIm5zu+/VzHtYCLTlLBWhPHVmMd0o2HjBwI5D4dc49zDzyjweDrJt5hLuqdftSIKMAddRqEywXEY2CGoQhTo00CkNAU54gX2cIIM+w7LYGOlsrSVWP/T7odOBgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHz5MKOXa/fmvaxthwfJKSBAp/9AzP8ZFfUJbbdJpKo=;
 b=woKP1KvkXpLqbqEebpqpjLWPvF7Hefu2n0IJ5N+KM1xGstOjcVOgP3HZ6YQ3Wjz5vjKk+Z0zcF8EU4W1DEqa8oG2Pz4GzIWsRTjfTid7fPQeOw8FTap3FpRF0bE6w1mfjgQ//5ylF1rV+gRslbTLYjo6pcYto5TmCIqxv+/oCoA/q/ohRf7BagBr7LAam84sU/6U7NeLu8NbwHF/IGj1RXt17YyXun/Q+h1asGozoPZrmSBJQ+jzB4gZLUZHtvRJRchPGXkja8vGgLNR14S28y6+i4t21WvwSHT78Y2QTXM4N2/Yq4Tw/ZzLRkbm/pkooaGqrjoi15HTWqpyxEZ9wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH0PR11MB7710.namprd11.prod.outlook.com (2603:10b6:510:298::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 14:36:52 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 14:36:51 +0000
Date: Wed, 11 Mar 2026 22:36:44 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Leo Martins <loemra.dev@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, David Sterba
	<dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, Sun YangKai
	<sunk67188@gmail.com>, Boris Burkov <boris@bur.io>,
	<linux-btrfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [btrfs]  9a8eec6165:  fio.write_iops 22.6%
 regression
Message-ID: <202603112240.f7605968-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0033.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::14) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH0PR11MB7710:EE_
X-MS-Office365-Filtering-Correlation-Id: 96c8a819-b7ee-415a-0598-08de7f7ba24e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: aQVPZBtonJPqvi0PdKN/vfvBarcmO7x9Loa2lE7qbtDcIEJAHmI0nzRA8Poilkwh6MtMOvJr2EGkoFKy2ZcF02004hZ26qhyVkKcs8pHa11Ygmbz45afQOO2o+OZSJXP1Qk/fmEu9h7dG+MPn4wtI+n7svRDgfjQxmER0jqoUDOvqMSKhXcNw2SlZvQ5yLbI5+4YZ3NpLy4eys1DtUobaNtCxjj/N+Dq2xdL/9HnRNBJNYgVLb4OtEvXXcnh79yuP2cet0uZM37iHN6CEmmQlDpcgchpVNP3Z+tI5mT8xMZ48X8F7JI+B1pLIgavbdK9el66MDU+z/f59lt9Zx9y+y2y6U9TMFcJoHgBJ+Ih7lUAblE2bQEHcmgSrvr2ZvVKI/BkUcvdK1mDcbosZhRJUKqROhKSHTdTueQwB11cL0joNn1oFNWDJBCAvaFM434nu1MhJbqecWIfAEonKnMd9lHIqLafVlHwMJLzPwW6S8tit5LNVevvmyUGf4GWRw8z7Tl0LEFTDrUbT5gFX/Q5FUSGwDyLevaKljmMFZkQQoV4wG/aP0tFoEuEB6Rq8KWFuF4kgJ2tOescLY6q2mIJsegyeXmgqC+FA4rxZZFyLOFmD/m363D0M0UhjSZO3QmZySHfAaCqhFAfzFAQDT7qn2OlPKt87xmUF2t9ff0WAbLR8eCF61WBq5EHMFbpVbSefdDkPtkf7iy7B0KiYEUbnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?eMpFw2e2fF7ROziUdWBOSszveUdiXik3aUXflLJvSacGxxsH0G6CYIppdW?=
 =?iso-8859-1?Q?rK2w6kibEQibFEtzQNw25kNJXhZYTus9FcsNqun9PZKdx/wLI4BQ9CBqIe?=
 =?iso-8859-1?Q?WlLHJGwmUyHe097kQYI3QxiwQpWm2V2VAhFCpYMCLrPfpCj9MMJTc7BdQE?=
 =?iso-8859-1?Q?jfcBT1s90MQDQqWZiZ8G6CRHk3oXJyvIM24tCQg+ykmG1FJaVCZw2r61zB?=
 =?iso-8859-1?Q?vSZGKIMgDf6KzB3dtnIoIGT6ef0FuMYtUqK6nvnP0mNNrz0cnyyVvn+vpm?=
 =?iso-8859-1?Q?Vb31LyVk6Qwn8D0dB0ERCkvTe24Dqq6oH/Ls5lWNq9MgzZw+/RRIUrZ8PC?=
 =?iso-8859-1?Q?FmIeVA3vP/qWRoPqLpMUlgtFa0FY9rCdy86jsIrEOw9k8wC+4cZE7JRu5C?=
 =?iso-8859-1?Q?tP0MpjsLryCYvs15gUwjL/pPeMY1EUxGl5BbmkZpvficbP7pktkd6YJvwh?=
 =?iso-8859-1?Q?5mmBNsAQInd/UgCke+b8w9SHvlv/7x7G87cY5yYC4DGEvYQ03UURocjHdC?=
 =?iso-8859-1?Q?B7PYtccvBkuM9Y1ihcgD97HJggXAR0+n+ayw48bWElA0oNj2vXacL6lf70?=
 =?iso-8859-1?Q?+7hTmuX9o+CMYC+eGboTMxzd/zct1K+yQKJWWmdtdzoZw7QSMR1/MBBphW?=
 =?iso-8859-1?Q?aBD3m0ZrA97PEwiAUae42jW6c5TjIIMIGj8og3SMuhPklAtBiVwAKTb8Pd?=
 =?iso-8859-1?Q?13mM6yl3xKXo3RIzZcEFCB9pb638HizQjjxHm2GI9PRqscbCSvTow9OCGt?=
 =?iso-8859-1?Q?EsbI0A6zodvgBR1F+mO8HP8uV8LeV2KnJyKVT0reW05w03SlJ6Iht0hp66?=
 =?iso-8859-1?Q?JMnrmERc3oDucM/Lel7at781XjpmxuPyukVbT7YpIzWYAPtoWh01G4TEP/?=
 =?iso-8859-1?Q?RA8Kyycp4QC2bNJ4LuN3XOqc/E9Vmvr4zTmEa+917kIaQCo7mQpbd9zIF2?=
 =?iso-8859-1?Q?2fxr5pVzmanVqSZGy9Jwd2dhsp2hjEa5u/Ljc+W8D57frmy3v0Ia06N7/2?=
 =?iso-8859-1?Q?D5fAqPoP/zZ7C0mSIAgsiZASuGxj8Be5njlBI/ZARHqHGH5xeEOPRIaulF?=
 =?iso-8859-1?Q?FllAcIdBctsOW3YXZ1AW86qBLlyFnPnFHCXG5BtJ5HderQFE88ABYRMj+3?=
 =?iso-8859-1?Q?AegdjbJRKPgxR9HDOgUsQW6VCB6SZFxmjigWeoDpmzypUINANQV5h57Ohe?=
 =?iso-8859-1?Q?t3OaZnWlLBsB6zAuHXhzym37KCX0UruQbC6thYkToL3QPWoEk/LhJ6AkDq?=
 =?iso-8859-1?Q?fijKx9MjToCLCPi+WNOqp9yu9DU78Cb321dmwNJYZGE/bVzmb570FV2Skx?=
 =?iso-8859-1?Q?Q/46yWI/+yS2/HRbqFItgde0NaiawyFzswJHwdlIYsfQCNa49CiLMhe+NN?=
 =?iso-8859-1?Q?nlPSigZOhAAYnsI4LeofHk22sW9mQ3XAPmW0B3RGwiGoCaPfBJ6OpSbNA3?=
 =?iso-8859-1?Q?JT48n1MQoc0vPxHDJNKmY+djZ1kOvYzYJ3lKdsHfRR9MmU2/OUteSumoNs?=
 =?iso-8859-1?Q?/cOLAiApKOm5Di5Qu5P5AqvpQIOSZjZD5jndzB2SZ7QaYbFBGQcWMqpXyz?=
 =?iso-8859-1?Q?pov7u4W6zoaos+n5kJaJjQywlHxjDWNMLHL9Y88iDva9IMDcu6gbONbp6R?=
 =?iso-8859-1?Q?8gxkaKUdsiBItZNREiVXtp8EP6M/ZohPhAB0Q0ccf0TMEPEJcUbrDsnj7r?=
 =?iso-8859-1?Q?zoRwtp6uNg+3+ObWPd1kJrVQ2PzHdGdzL4cUh5nENfqdvvuWElXEDMwNv0?=
 =?iso-8859-1?Q?UhmuhoScBoXeGoT3PYa4+ZId0QTXFs2rdoCNaflsVARXCtzPIbcudftGVa?=
 =?iso-8859-1?Q?BFk4mGQ6UA=3D=3D?=
X-Exchange-RoutingPolicyChecked: fZHixqr0NLthOThT2/O7VWwAX7gjh0hSEt9QMl5veVh02kRlz2TFYm9JSKRSTx4n1BaIq+JvO+KoAwlUXLJCYFoKUjZoOtdjnRlA5+4ViGo4I3qFnPJnTQDJpQGPwfolONjYypBlOqyUa3ssMcr3k8+1povbQ+sRmJRwQE6trQCB/Ae8AotkWI/jz7awWJerL3D7kz+rRlY7NFO0ymA3IhnY1Z1J88siPpJba8VhM0kaNL4S+Sn6+u3nvi86WEqxntvXq2E/jmvMklR3DeLi1Bqy1r72204/VemRsG8AJHJa8w9vZi1qz4Ulpx+9cXshgsXv+79SfYGajeWs7DaRtw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c8a819-b7ee-415a-0598-08de7f7ba24e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 14:36:51.8087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kOmC3PC3LdI6vCKsCJiVr2igAJq6pNoHPuwWItkjzzcezrLoAh2nn71oIbgKcVrTG15RWX9BT01GX7rPxmdCAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7710
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 22.6% regression of fio.write_iops on:


commit: 9a8eec6165a01f1aa97619c96cc5dbad86ddbb62 ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master a0ae2a256046c0c5d3778d1a194ff2e171f16e5f]

testcase: fio-basic
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	runtime: 300s
	disk: 1HDD
	fs: btrfs
	nr_task: 1
	test_size: 128G
	rw: randwrite
	bs: 4k
	ioengine: ftruncate
	cpufreq_governor: performance


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603112240.f7605968-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260311/202603112240.f7605968-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/ftruncate/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic

commit: 
  444cfd8d1f ("btrfs: skip COW for written extent buffers allocated in current transaction")
  9a8eec6165 ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

444cfd8d1f160c14 9a8eec6165a01f1aa97619c96cc 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.07 ± 31%      +0.5        0.57 ± 10%  fio.latency_10us%
      0.01 ± 44%      +0.0        0.03 ±  6%  fio.latency_250us%
     99.84           -50.0       49.80        fio.latency_2us%
      0.10 ± 24%     +49.5       49.59        fio.latency_4us%
     58.98           +29.0%      76.08        fio.time.elapsed_time
     58.98           +29.0%      76.08        fio.time.elapsed_time.max
    428.33 ±  8%   +2798.9%      12417 ±  9%  fio.time.involuntary_context_switches
    101.17            -2.8%      98.33        fio.time.percent_of_cpu_this_job_got
     46.62           +31.7%      61.42        fio.time.system_time
      6277           +28.8%       8084        fio.time.voluntary_context_switches
      2236           -22.6%       1731        fio.write_bw_MBps
      1576           +42.5%       2245        fio.write_clat_90%_ns
      1592           +44.1%       2293        fio.write_clat_95%_ns
      1632           +53.9%       2512 ±  2%  fio.write_clat_99%_ns
      1495           +33.4%       1995        fio.write_clat_mean_ns
    284.48 ± 37%   +1017.7%       3179 ±  5%  fio.write_clat_stddev
    572669           -22.6%     443293        fio.write_iops
 3.806e+09           +28.4%  4.886e+09        cpuidle..time
    133227           +62.5%     216453 ±  4%  cpuidle..usage
    107.81           +15.9%     124.96        uptime.boot
      6550           +16.5%       7632        uptime.idle
      1887           +13.7%       2146        vmstat.system.cs
      4426 ±  2%      +8.9%       4822 ±  3%  vmstat.system.in
      0.06 ±  6%      -0.0        0.05 ± 11%  mpstat.cpu.all.iowait%
      0.00 ± 13%      +0.0        0.02 ± 15%  mpstat.cpu.all.soft%
      0.97            -0.2        0.77        mpstat.cpu.all.usr%
     94.50            -8.3%      86.67        turbostat.Avg_MHz
      2.64            -0.2        2.42        turbostat.Busy%
      1.51            +6.5%       1.61        turbostat.IPC
    232693           +43.5%     333974 ±  2%  turbostat.IRQ
      2.00 ± 55%   +3334.3%      68.76 ± 10%  perf-sched.total_wait_and_delay.average.ms
    815.67 ±  8%    +389.2%       3990 ±  9%  perf-sched.total_wait_and_delay.count.ms
     52.14 ± 12%   +4876.0%       2594 ± 14%  perf-sched.total_wait_and_delay.max.ms
      1.92 ± 57%   +3464.7%      68.59 ± 10%  perf-sched.total_wait_time.average.ms
     37.19 ± 31%   +6613.9%       2496 ± 17%  perf-sched.total_wait_time.max.ms
      2.00 ± 55%   +3334.3%      68.76 ± 10%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    815.67 ±  8%    +389.2%       3990 ±  9%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     52.14 ± 12%   +4876.0%       2594 ± 14%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      1.92 ± 57%   +3464.7%      68.59 ± 10%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     37.19 ± 31%   +6613.9%       2496 ± 17%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      1.33            -0.2        1.10        perf-stat.i.branch-miss-rate%
  33302690           -16.2%   27896465 ±  2%  perf-stat.i.branch-misses
      8.43 ± 12%      -5.8        2.61 ±  6%  perf-stat.i.cache-miss-rate%
   6149698          +171.1%   16672847        perf-stat.i.cache-references
      1682           +16.8%       1965 ±  2%  perf-stat.i.context-switches
      0.64            -6.4%       0.60        perf-stat.i.cpi
 6.157e+09            -8.5%  5.634e+09        perf-stat.i.cpu-cycles
     71.04            +8.4%      77.01 ±  4%  perf-stat.i.cpu-migrations
 9.288e+09            -2.6%  9.045e+09        perf-stat.i.instructions
      1.69            +5.8%       1.79        perf-stat.i.ipc
      1.68            -0.3        1.41        perf-stat.overall.branch-miss-rate%
      9.36 ±  4%      -6.2        3.20 ±  5%  perf-stat.overall.cache-miss-rate%
      0.66            -6.0%       0.62        perf-stat.overall.cpi
      1.51            +6.4%       1.60        perf-stat.overall.ipc
     16487           +25.0%      20616        perf-stat.overall.path-length
  32749408           -15.9%   27542708 ±  2%  perf-stat.ps.branch-misses
   6059888          +171.7%   16467123        perf-stat.ps.cache-references
      1655           +17.2%       1940 ±  2%  perf-stat.ps.context-switches
 6.061e+09            -8.2%  5.567e+09        perf-stat.ps.cpu-cycles
     69.88            +8.8%      76.02 ±  4%  perf-stat.ps.cpu-migrations
 9.135e+09            -2.3%   8.93e+09        perf-stat.ps.instructions
 5.532e+11           +25.0%  6.918e+11        perf-stat.total.instructions
      9.27 ± 32%      -9.3        0.00        perf-profile.calltrace.cycles-pp.proc_reg_read_iter.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.27 ± 32%      -9.3        0.00        perf-profile.calltrace.cycles-pp.seq_read_iter.proc_reg_read_iter.vfs_read.ksys_read.do_syscall_64
      8.21 ± 32%      -7.5        0.76 ±223%  perf-profile.calltrace.cycles-pp.folio_remove_rmap_ptes.zap_present_ptes.zap_pte_range.zap_pmd_range.unmap_page_range
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.common_startup_64
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      5.50 ± 83%      -5.5        0.00        perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
      5.44 ± 45%      -5.4        0.00        perf-profile.calltrace.cycles-pp.arch_show_interrupts.seq_read_iter.proc_reg_read_iter.vfs_read.ksys_read
      4.39 ±112%      -4.4        0.00        perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
      5.99 ± 50%      -4.3        1.74 ±143%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range
      5.99 ± 50%      -4.3        1.74 ±143%  perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range
      5.99 ± 50%      -4.3        1.74 ±143%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
      5.99 ± 50%      -4.3        1.74 ±143%  perf-profile.calltrace.cycles-pp.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
      3.84 ±104%      -3.8        0.00        perf-profile.calltrace.cycles-pp.show_interrupts.seq_read_iter.proc_reg_read_iter.vfs_read.ksys_read
      3.82 ±104%      -3.8        0.00        perf-profile.calltrace.cycles-pp.__open64_nocancel
      3.82 ±104%      -3.8        0.00        perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      3.82 ±104%      -3.8        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      3.82 ±104%      -3.8        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      5.49 ±129%      -3.8        1.68 ±142%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      4.93 ± 75%      -2.4        2.56 ±145%  perf-profile.calltrace.cycles-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      3.82 ±104%      -2.3        1.52 ±223%  perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      3.28 ±100%      -2.3        0.98 ±223%  perf-profile.calltrace.cycles-pp.dup_mm.copy_process.kernel_clone.__do_sys_clone.do_syscall_64
      3.28 ±100%      -2.3        0.98 ±223%  perf-profile.calltrace.cycles-pp.dup_mmap.dup_mm.copy_process.kernel_clone.__do_sys_clone
      9.27 ± 32%      -9.3        0.00        perf-profile.children.cycles-pp.proc_reg_read_iter
      8.21 ± 32%      -7.5        0.76 ±223%  perf-profile.children.cycles-pp.folio_remove_rmap_ptes
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.acpi_idle_do_entry
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.acpi_idle_enter
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.acpi_safe_halt
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.common_startup_64
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.cpu_startup_entry
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.cpuidle_enter
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.cpuidle_enter_state
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.cpuidle_idle_call
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.do_idle
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.pv_native_safe_halt
      5.50 ± 83%      -5.5        0.00        perf-profile.children.cycles-pp.start_secondary
      5.44 ± 45%      -5.4        0.00        perf-profile.children.cycles-pp.arch_show_interrupts
      5.99 ± 50%      -4.3        1.74 ±143%  perf-profile.children.cycles-pp.tlb_flush_mmu
      3.84 ±104%      -3.8        0.00        perf-profile.children.cycles-pp.show_interrupts
      5.49 ±129%      -3.8        1.68 ±142%  perf-profile.children.cycles-pp.__open64_nocancel
      4.93 ± 75%      -2.4        2.56 ±145%  perf-profile.children.cycles-pp.do_anonymous_page
      3.82 ±104%      -2.3        1.52 ±223%  perf-profile.children.cycles-pp.alloc_anon_folio
      3.28 ±100%      -2.3        0.98 ±223%  perf-profile.children.cycles-pp.dup_mm
      3.28 ±100%      -2.3        0.98 ±223%  perf-profile.children.cycles-pp.dup_mmap
      5.91 ± 50%      -5.9        0.00        perf-profile.self.cycles-pp.folio_remove_rmap_ptes
      4.24 ± 70%      -4.2        0.00        perf-profile.self.cycles-pp.arch_show_interrupts
      3.20 ±100%      -3.2        0.00        perf-profile.self.cycles-pp.pv_native_safe_halt
      3.89 ±103%      -3.0        0.88 ±223%  perf-profile.self.cycles-pp.kmem_cache_free
      4.95 ± 75%      -2.9        2.02 ±141%  perf-profile.self.cycles-pp.__d_lookup




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

