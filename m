Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FEC3ACF1E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045461; cv=fail; b=Qxuthz3hwLtKj7frnVppQ3KG4kyodHXTeGIAzasxyDu5C1Le68k98t5nbeSf4tn4ZMvTvn09+1BTpN+7iNhb//2y6stoo9ZYLi1amu6fRvXX2UMH077rj0lYe2V+4r1QGVgfCmlEKjMKPnh7sRBLVZcdxjjH0l0faiRSNXnxpQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045461; c=relaxed/simple;
	bh=sQT8MS4OHfrxXsb5uBR2Fs1Y/FDYYckJeFL+j2kj60E=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=ZvJki38uk14GjFk7PT7+miakVs/TZpbXHEy6kRyTfL4aa1vUg7hcvCdBhaNE4IDc7C3KQrl/oa7h1gQOEusJEfc+XBDDhYBbWnJWnRtZpwGRhkgvTCYYTYxGIsBoXogdLUCmHUd51qSABDgygAtgRXZWEn6SYljuqVjbCdpXAnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aP8q8sx8; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aP8q8sx8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780045460; x=1811581460;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=sQT8MS4OHfrxXsb5uBR2Fs1Y/FDYYckJeFL+j2kj60E=;
  b=aP8q8sx8M1rfJ7QiArP1jq+mpNz56pyEwCK598nkxvdSVpxaeQMI2+8U
   lnqLWaJMF4ud3hN5xYykz+coNxeZZKFwO4bcgMY/g/oT6EtBojFcGRiWM
   B4z60aVR3QCHON5z9sGMz/xYoHAES++3OqCz+UTGYhDcCOPjivS+LnWmX
   e4ugr/MZdrIgfUYw5w1NST0OmR7dgq6w92w/xhx1sfXzM0/wyYFlyWrse
   xhyHsLKwm38L4zhxfa6A0JgIbDpuM9/Q/tpKq1UIDv34OPDFrbYYNbPV1
   FzT20q3EvchK5hqC5Db8bRtsKFtQ+ncneYIroKe0f30/YKDrMg/2F5lZ9
   A==;
X-CSE-ConnectionGUID: D0U5l5V0RCuIszqboDj7bw==
X-CSE-MsgGUID: QzGNbPk8QX23gpncmsGXOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="92007080"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="92007080"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 02:04:20 -0700
X-CSE-ConnectionGUID: ON/dFyMPSoi40tI576Xa4g==
X-CSE-MsgGUID: t20y82FxTB2o+EesFj+kjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="236448551"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 02:04:19 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 02:04:18 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 29 May 2026 02:04:18 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.60) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 02:04:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPWGLhDbgih1Y655k7RyaHBCNMPPdpYole7WupqIwOZBI77euio++cCOyC9tQ96XIxbt7FWtFjcooMmU5SRZhqs30jUPf+2lm+hITiEBTaIHUtV3iwfVAf6nW4n3cvbVvNxlghdVY0NNcmIde/cJsKrRNnFmjOKMzGtTxkbCUWdUXXbkk8CgSv2GQdUSQ2VCx7KN6040uobU1Y/34AUD9Aayy3OKTeBi4o9hcDp+gfz5bs3rGrUCIN3HpteEjW5vSOPX/LFATxUO6Xi2ww7EAurntWD+zAf6eZG0N7TVW/60sZcYhmUiGW5EAIC+W81EG3kpaJxQOIfBKPtu2DLsbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8siDW0hO4UpomXFbpjJ6n7SnqfoUj0M/cDnbE5lHjQ=;
 b=uBF+m9tWTgjbhNQXo9hm5atgY18n6sVokn3l8bO31lQJQ0kT0w0EkNBHB8wQZN2E4gWvcwHxd+zW1DpIe53fWHAHvLgdfI0T61maAWMAbcP5wjUD39kM8cWAlker/y6CW96FmlfbfRNlIshLBTVyzUH8b0o5HWVxRdV4TgeA15qdBJlmf/aXCIhLHox/5uU0/8IV89RZgpWYfbNwHYWd8UAtvCK2YzG13lvgflbR+TXgd+1+C3a2M31bjeeVoZBFDWfw/sTQbkPEQzP3RI88GdPvslLlqoFqP263ZiBMo6EJMgDU7PZBGlzDXMexsQqU/BBNwVXkcLtbhW/zBRmAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by MW4PR11MB6571.namprd11.prod.outlook.com (2603:10b6:303:1e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Fri, 29 May
 2026 09:04:08 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.21.0048.019; Fri, 29 May 2026
 09:04:08 +0000
Date: Fri, 29 May 2026 17:04:00 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Mark Harmstone <mark@harmstone.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, David Sterba
	<dsterba@suse.com>, <linux-btrfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [btrfs]  551e510a97:  fio.write_iops 12.4%
 improvement
Message-ID: <202605291631.659bf248-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|MW4PR11MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: 0471c5b0-f1f7-4445-8305-08debd613dca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|3023799007|11063799006|6133799003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: RgJJqCEuWpw0wsDbB1CKjAie4TZweZEF2ggRr29TZlI2zmfPUeSFF7ly+AlVlnV2EunXQk6JmttNICUyV6zkahE3WYRhxFswCZ6rj+AnKwDmSzZoKDMusfpT9RVqvinPEbjNnaqg9nYdkWpG8x0IYnh7CGjA6C9MgV2W+cbMkOgmfwLRn+mMceY2Y/EO9e80aW1jjXwnckL6oA3MvYsAXEayEuCaD3AOlXynCKbF3l8xhalf8kPmee1JK04ZVmbj2qIw77QRhe6tYCDgwvJQb1MutTtZtGgPPTU4XdMad2j1dybWI+6T0DFzzIsGiot9V8cWr7F/T7/m2wb6pEMrDULX7aj9YauvtXywU/WGKrQQVfB9BNNe7IuvoCfQ+12cAeDZSaMu/udHc3MeTJ0pUfmuXPUfmNXowM4z5gvwuIvE8HEtC7JRiGTbR4L3CcuvBdA8GU6n09R8cEl1+Zx7LGV/fyfrKPXJgAEAvdTPn1qFO6xA0uaRa7QXNt9/0Cir/PsjDs+7lcxJxHR553YqL4uCbnvjmG5YBixf7jDbhg+424ZPqzxwAlpikCKh1Zb32og2hiK8QixtJllFsD4yGS0G7P+MnNydaj3ZTZBvBwSGls+qpRwar4U1YbybXwSZlCKrKmAoN/loSYPB588LKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(3023799007)(11063799006)(6133799003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?NF8/VDucsixagCPJdZKaURMphmkWGJn6awfVzD5nWB+ittQ19ml2ufCWyn?=
 =?iso-8859-1?Q?VvhBod1fu4s7P7jGTKgQGYTGDAQTR5t95+ZZHOMDyYzcBNHW9A02Jw47tJ?=
 =?iso-8859-1?Q?nsY1l0GTJ1en3tkK/wNvSYUgbOiTDPHwLAjV+HZ6Xi+oAYYSlahR82sSed?=
 =?iso-8859-1?Q?rAnxmPcXMdkTBRqfW2YIdi/NaH9fVpe4how56L4BpcrcK9D1GlmFng9GL/?=
 =?iso-8859-1?Q?vZkTQ50yFLRZ7Hbie/VT8XLlAiOep01hbrhq/NtT4z8sl1wfOGWBwnq/II?=
 =?iso-8859-1?Q?jhkx+ze45Dwc+I2WkdLEiPMnHpoPcZncVuAV834PRnhJIJkb7Aypp90UDS?=
 =?iso-8859-1?Q?bDwoibFTB7oY36qLWNDP+/Gvwd9p2zdRgbNbeyVe9TcwRo4U5eQPdop9qY?=
 =?iso-8859-1?Q?OmerX1KPVC08dX/HpJ73iwAjqFT8C5XzDbNb38jhbnTeonSkuhlIGtMkjK?=
 =?iso-8859-1?Q?9BJvpqoJQW3CGv0K5v9XWC4QVVWBUjyGlcRaPwp/8k/DkGruSqgAvrH20N?=
 =?iso-8859-1?Q?lP/0AQRVADnrxbKNeVab74IL5EJbCt5uDTkIJl/WL7/5Wkz4KvV1QrOWcr?=
 =?iso-8859-1?Q?W+ASYAI9FdwiOSyeV3LXHOFeLHpcSNYeHxseYh1gWT/mpsFEP1NFz45wFp?=
 =?iso-8859-1?Q?RaarPG//c8yHzsKr2G6YlUwaSAVdStatxk/RO9yephg38zsPfuQkAnlVFn?=
 =?iso-8859-1?Q?fa6M7lXIoSVKYxafyOEHoI3Z+cpRGH15pkQTZxI+JfDsnTfj6mBEXGryJo?=
 =?iso-8859-1?Q?nE3FC9aIpLB8OU78v54DeU7Ce9H+2O1Gvj/NxqWHelt3kUsxeBPjtMdEEb?=
 =?iso-8859-1?Q?VVcKRABUWR61d9mrFFFeGXm11j5fC57fExqfAjiu0zOOVP8sD21a9iqDi4?=
 =?iso-8859-1?Q?4bA3HJ0lWDm6I2wZ9c7Ccy2N5WIei7kq10hYtM3o9/4vvW5/x3uGtaCndJ?=
 =?iso-8859-1?Q?7gJoZHavvn6vH4v3Eaz4wcg3caxgDU2vbEnPSx25PqNbwDSI1UxREKKBzq?=
 =?iso-8859-1?Q?5/tyORDU38wR94EMljdol2xsC9NU6j9Ix6KN5isoXA3qetyo96tpzvTPdC?=
 =?iso-8859-1?Q?1CD3NtxZ5CfxTNhLPY7oZYfBHN0UlmRyKh/vKKhNmvNhJa+adm+6E79AFn?=
 =?iso-8859-1?Q?+gdki8POZHWk+29l7Mg5vaVSoh/90tYJHPhz8Kb/11QDDJbZovbW5UXUUm?=
 =?iso-8859-1?Q?1ESy6r4PevZjEXqyCYstkK/pB6/ytJcLPSWIc1v+W0R+9BA10HNSx3Gaob?=
 =?iso-8859-1?Q?ZT2JcZE/T9HcC9lMVamn668/UIen/uGbqjlLODrSdio/AcRn8qPkxUbkOq?=
 =?iso-8859-1?Q?3th66CbkHp9ESWLw8TpHEdR+0egGWK1aYWz+/iHp2frTzt6+H9w6DF3eYX?=
 =?iso-8859-1?Q?kjZhnNXthfGAGnI0f4/+O0nd89ZP0hYVrE9PXXZ95maRrSrJ4XIbOXU9V8?=
 =?iso-8859-1?Q?x8tn6VawWglMSBZXIUT8/NlnsX7rp5JXMXMurFvX8vJM0564EBoAzKrjAN?=
 =?iso-8859-1?Q?NkxE+Rp3IXAmQt9OKPKomsGFIEoaJKHYXpDCjUtwVRn8vzm8ZktOjW29Py?=
 =?iso-8859-1?Q?8LL7VdnZIcSfGtB0nnpdpNRUWQpqgdg0yH7YRfXWqzCXgnvzOl2nRa6kiQ?=
 =?iso-8859-1?Q?MPXNeBqHy0kwMW9sLPsG6MrsCYhs2fAEMiSi4fg5XTfRmsWNXYkok6t51d?=
 =?iso-8859-1?Q?i2hTYS3PKm+w8KA9UrzN94vYbjIUwuKf1LyAPGuyH4mZxoWDTSk1hoSzxA?=
 =?iso-8859-1?Q?q3rDY2TDDluxI2xrHRdK3MZqmQCeRpPcMFbysX4zA5RtFg2RqYN5rsDPLR?=
 =?iso-8859-1?Q?LkpW8Cj02A=3D=3D?=
X-Exchange-RoutingPolicyChecked: ZRWZtfWQpDMF8yyLQPwP+xcjdN4OEaeTEM/empR/DALI04hUPZ9F3UGO4M5VrlcUGEQMSfdZpw9AwSHATjhUTcEQppsI1Iwd4a3omrKEg2o5qvMx/eCSlrClSQ6Se7vDLQw1hnK5KwDxKGRZY/eeONAY2Ua/z1bbEmEM8g7W7nBnb4FNZglGjfaBKEA5bGxGJXClm2FmOlcyMw334BF6iDvqS4lnk24L0IeB13C26MXPrR9iKc19UfBjphekrMV0bhERz3yHptkJhkLnwXhnIfpEyGr1Ev2+TFGqBy6llFFOGJqUUbCXjgVkMJ1ElNgu6ShS/ZAHJkzzglNa80TYCA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0471c5b0-f1f7-4445-8305-08debd613dca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 09:04:08.0834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpLFNCzNoY5/c+8iDpvvh9miww61hXzfSPyt5UVhsare6KJe454/d7Y1UjMstQOTPg9tFN0m2Bm9SEOl5/Enxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6571
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 12.4% improvement of fio.write_iops on:


commit: 551e510a97a487218d5f22d61d1a3388ef1171ac ("btrfs: don't force DIO writes to be serialized")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


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
	ioengine: falloc
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+---------------------------------------------+
| testcase: change | fio-basic: fio.write_iops 10.9% improvement |
| test parameters  | bs=4k                                       |
|                  | cpufreq_governor=performance                |
|                  | disk=1HDD                                   |
|                  | fs=btrfs                                    |
|                  | ioengine=falloc                             |
|                  | nr_task=1                                   |
|                  | runtime=300s                                |
|                  | rw=write                                    |
|                  | test_size=128G                              |
+------------------+---------------------------------------------+




Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260529/202605291631.659bf248-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/falloc/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic

commit: 
  964f569c14 ("btrfs: limit size of bios submitted from writeback")
  551e510a97 ("btrfs: don't force DIO writes to be serialized")

964f569c14d7778c 551e510a97a487218d5f22d61d1 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.04 ±  5%      -0.0        0.04 ±  5%  fio.latency_4us%
      5315           +12.4%       5976        fio.write_bw_MBps
    510.67           -14.2%     438.00        fio.write_clat_90%_ns
    515.00           -14.2%     442.00        fio.write_clat_95%_ns
    522.67           -13.8%     450.67        fio.write_clat_99%_ns
    496.01           -14.6%     423.39        fio.write_clat_mean_ns
   1360660           +12.4%    1530010        fio.write_iops
  1.67e+09           -10.0%  1.503e+09        cpuidle..time
      1.48            +2.5%       1.51        iostat.cpu.system
     42426            -6.0%      39867 ±  2%  meminfo.AnonHugePages
    165506 ±  3%      -6.8%     154330        turbostat.IRQ
      2392            +4.8%       2506        vmstat.system.cs
      1945            +4.5%       2034        perf-stat.i.context-switches
      1874            +4.1%       1949        perf-stat.ps.context-switches
   1489031 ±110%    +162.9%    3915040 ±  3%  numa-meminfo.node0.FilePages
     40746 ± 46%     +72.2%      70177 ±  5%  numa-meminfo.node0.KReclaimable
     29851 ±122%    +178.8%      83225        numa-meminfo.node0.Mapped
     40746 ± 46%     +72.2%      70177 ±  5%  numa-meminfo.node0.SReclaimable
    126444 ± 22%     +29.1%     163254 ±  8%  numa-meminfo.node0.Slab
   1485610 ±110%    +163.2%    3910117 ±  3%  numa-meminfo.node0.Unevictable
   2626454 ± 62%     -92.4%     200365 ± 69%  numa-meminfo.node1.FilePages
     56220 ± 65%     -95.9%       2321 ± 67%  numa-meminfo.node1.Mapped
   2622239 ± 62%     -92.5%     197733 ± 70%  numa-meminfo.node1.Unevictable
    372258 ±110%    +162.9%     978760 ±  3%  numa-vmstat.node0.nr_file_pages
      7462 ±122%    +178.8%      20806        numa-vmstat.node0.nr_mapped
     10186 ± 46%     +72.2%      17544 ±  5%  numa-vmstat.node0.nr_slab_reclaimable
    371402 ±110%    +163.2%     977529 ±  3%  numa-vmstat.node0.nr_unevictable
    371402 ±110%    +163.2%     977529 ±  3%  numa-vmstat.node0.nr_zone_unevictable
    656614 ± 62%     -92.4%      50091 ± 69%  numa-vmstat.node1.nr_file_pages
     14054 ± 65%     -95.9%     580.52 ± 67%  numa-vmstat.node1.nr_mapped
    655559 ± 62%     -92.5%      49433 ± 70%  numa-vmstat.node1.nr_unevictable
    655559 ± 62%     -92.5%      49433 ± 70%  numa-vmstat.node1.nr_zone_unevictable
     80.52 ± 25%     -58.3       22.22 ±147%  perf-profile.calltrace.cycles-pp.__mmput.exit_mm.do_exit.do_group_exit.get_signal
     80.52 ± 25%     -58.3       22.22 ±147%  perf-profile.calltrace.cycles-pp.exit_mm.do_exit.do_group_exit.get_signal.arch_do_signal_or_restart
     80.52 ± 25%     -56.6       23.89 ±144%  perf-profile.calltrace.cycles-pp.exit_mmap.__mmput.exit_mm.do_exit.do_group_exit
     68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.exit_mmap.__mmput.exit_mm
     68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap.__mmput
     68.57 ± 49%     -49.7       18.89 ±163%  perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap
     68.85 ± 49%     -48.3       20.56 ±153%  perf-profile.calltrace.cycles-pp.unmap_vmas.exit_mmap.__mmput.exit_mm.do_exit
     70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
     70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.do_exit.do_group_exit.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop
     70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.do_group_exit.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64
     70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
     70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
     71.35 ± 48%     -45.8       25.56 ±142%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     71.35 ± 48%     -45.8       25.56 ±142%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     35.48 ± 64%     -24.4       11.11 ±223%  perf-profile.calltrace.cycles-pp.zap_present_ptes.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
     22.82 ± 62%     -18.4        4.44 ±147%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
     23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range
     23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.calltrace.cycles-pp.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
     12.38 ±118%     -12.4        0.00        perf-profile.calltrace.cycles-pp.lruvec_stat_mod_folio.folio_remove_rmap_ptes.zap_present_ptes.zap_pte_range.zap_pmd_range
     15.99 ±131%     -10.4        5.56 ±223%  perf-profile.calltrace.cycles-pp.folio_remove_rmap_ptes.zap_present_ptes.zap_pte_range.zap_pmd_range.unmap_page_range
     12.38 ±143%      -9.6        2.78 ±223%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     12.38 ±143%      -9.6        2.78 ±223%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     12.38 ±143%      -9.6        2.78 ±223%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     11.71 ± 98%      -7.3        4.44 ±147%  perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range
     83.17 ± 23%     -59.3       23.89 ±144%  perf-profile.children.cycles-pp.__mmput
     83.17 ± 23%     -59.3       23.89 ±144%  perf-profile.children.cycles-pp.exit_mmap
     80.79 ± 24%     -58.6       22.22 ±147%  perf-profile.children.cycles-pp.arch_do_signal_or_restart
     80.79 ± 24%     -58.6       22.22 ±147%  perf-profile.children.cycles-pp.get_signal
     80.79 ± 24%     -56.9       23.89 ±144%  perf-profile.children.cycles-pp.do_exit
     80.79 ± 24%     -56.9       23.89 ±144%  perf-profile.children.cycles-pp.do_group_exit
     80.52 ± 25%     -56.6       23.89 ±144%  perf-profile.children.cycles-pp.exit_mm
     75.95 ± 40%     -50.4       25.56 ±142%  perf-profile.children.cycles-pp.do_syscall_64
     75.95 ± 40%     -50.4       25.56 ±142%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.children.cycles-pp.unmap_page_range
     68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.children.cycles-pp.zap_pmd_range
     68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.children.cycles-pp.zap_pte_range
     68.85 ± 49%     -48.3       20.56 ±153%  perf-profile.children.cycles-pp.unmap_vmas
     70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.children.cycles-pp.exit_to_user_mode_loop
     35.20 ± 66%     -26.9        8.33 ±223%  perf-profile.children.cycles-pp.zap_present_ptes
     23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
     23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
     23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.children.cycles-pp.tlb_flush_mmu
     19.33 ±102%     -13.8        5.56 ±223%  perf-profile.children.cycles-pp.folio_remove_rmap_ptes
     12.38 ±143%      -9.6        2.78 ±223%  perf-profile.children.cycles-pp.kthread
     12.38 ±143%      -9.6        2.78 ±223%  perf-profile.children.cycles-pp.ret_from_fork
     12.38 ±143%      -9.6        2.78 ±223%  perf-profile.children.cycles-pp.ret_from_fork_asm
      9.05 ±102%      -9.0        0.00        perf-profile.children.cycles-pp.lruvec_stat_mod_folio
     11.71 ± 98%      -7.3        4.44 ±147%  perf-profile.children.cycles-pp.folios_put_refs
     15.60 ± 97%     -15.6        0.00        perf-profile.self.cycles-pp.zap_present_ptes
     13.61 ±107%      -8.1        5.56 ±223%  perf-profile.self.cycles-pp.folio_remove_rmap_ptes
     10.28 ± 94%      -6.9        3.33 ±223%  perf-profile.self.cycles-pp.zap_pte_range


***************************************************************************************************

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/falloc/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/write/lkp-icl-2sp9/128G/fio-basic

commit: 
  964f569c14 ("btrfs: limit size of bios submitted from writeback")
  551e510a97 ("btrfs: don't force DIO writes to be serialized")

964f569c14d7778c 551e510a97a487218d5f22d61d1 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.04 ±  4%      -0.0        0.04 ±  4%  fio.latency_4us%
      6156           +10.9%       6825        fio.write_bw_MBps
    459.33           -13.5%     397.33        fio.write_clat_90%_ns
    462.00           -13.7%     398.67 ±  2%  fio.write_clat_95%_ns
    466.67           -13.6%     403.33 ±  2%  fio.write_clat_99%_ns
    454.12           -14.1%     389.87        fio.write_clat_mean_ns
   1575955           +10.9%    1747309        fio.write_iops
    556943 ± 91%     -62.8%     207326 ±184%  sched_debug.cfs_rq:/.load.max
    152355 ±  2%      -7.7%     140620 ±  3%  turbostat.IRQ
 1.472e+09 ±  2%      -9.2%  1.337e+09        cpuidle..time
     99291 ±  3%      -7.8%      91524 ±  4%  cpuidle..usage
      9.05 ±102%      -9.0        0.00        perf-profile.calltrace.cycles-pp.free_pgtables.exit_mmap.__mmput.exit_mm.do_exit
      9.05 ±102%      -7.4        1.67 ±223%  perf-profile.children.cycles-pp.free_pgtables





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

