Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E7A36212D
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 05:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775627597; cv=fail; b=Hbor0M92BNkFu5COqSLSNUEUYTL/4H6JbNVOUpWuuKyXiPOqunbrwtuaoeqa9+du378IjmSWKi2YQf8qKbI7A/f82OkYq2e5KMARBa1SpreeudxUe/V0sMSrlV8/DRUp2gPbtbJVxaSZDy2J7POoR+2a1t4nBHImGjidsYK1U8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775627597; c=relaxed/simple;
	bh=pM0FXJ80FZbl1Zy/hN5qifNc7Scam88axUxjxA81218=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=OXpGcw5GdRAhYNR/9ziC83OtTJBuuzn6HPR6yxBccGd9/rAO2kwvFdNsv90liKmn/STFj8fxMi9okPZTuR5uPBA5nQYFea6eWQaMTFiyNf8EfvCkRuil/b1hqmp+kDzLuFZEy+papvflk2vUQj0PGuwNamveMJNYa8sYay0VXjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eAxb3GQS; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eAxb3GQS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775627593; x=1807163593;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=pM0FXJ80FZbl1Zy/hN5qifNc7Scam88axUxjxA81218=;
  b=eAxb3GQSW9pcNRcgrKnYCsiFViP4F7EXkZ/9SsOD8SEmmHhCu9p6jKDu
   aY6QafWr4M7yezN8HO6F5NOLpBzcQaVMWDBzBYKFQfyQo1EnQHLNTdoJg
   dSPFP4nybrJmMD3KEzPyHL0fNTDZrd3euMTCgDTKfIlpFt1tyickswpIX
   JOqXGJWpu0MXwaSBtpaznH+KnBIzAyRZN7tR/vC46aQn4Kpyx6c/CSoBz
   Y764oHoONYtOUqwwdoXsBKko5CPZgVHRQ1PtkYNc++bKUChVk9AFigRVh
   ElsDuCwxWY4yKZnsVrPqrylBDQ3+z+MIENaLWAcDOZYLah9MElUQqyggz
   Q==;
X-CSE-ConnectionGUID: cnwZedv/QjGpg/CvkVzDig==
X-CSE-MsgGUID: ii5dS4MnSbWBqNFTUCbh2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="76500900"
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="76500900"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 22:53:12 -0700
X-CSE-ConnectionGUID: gMju6by/T5aczXyNgYCxtQ==
X-CSE-MsgGUID: ucnNj9QOTDKJXsb+WPpuIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="258808449"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 22:53:12 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 22:53:11 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 22:53:11 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 22:53:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BLXlcnTEVMDaNq6M3IYaeMT0k8r+AaGe3be76OpAZ6Dg87/HzhTmQvaPRx174aVB3fWh0xKQYNMNRg3kVHjMeK4/7ztyhTUHJY48qMyKhV07pIbzO8rFtlFSTdpL70dwspzHFKyI3wZ1iIRLLEa6X08yqkaQ4dWT3ypwm5fkHHTM+Mu3Z/CkBqCz+3rIJ/XTJgG1fKwtQlvOFUJGrhVXHqHLLFRKTk9+F8VQjQ+ie7lqay/5kM5Us7p8nlFFHy9wP7Txa4VLZfmpdlJ8IX++RP7krMtN3tTYJwKg9e2gPqr1czrGQu2U341k2z98I8umfzeV3VG+jhcidyR2L+aVFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWs+w83tfMY99rL0jgNAyti05IzvfmXfx4remOEr/o8=;
 b=H2rprE1FaKWmTTzx1ZZ0naWI2o8wmV8YsWJNmgZ0ZxuH1wJqEBZxSFThn0hnWZXp13ulRAH7WL9o1EBL6JAV+twvL83TCkx4SSOXBHwu2iYDL82GE3Mj0YBrSNPxMB5TnU2qpyLCFfhMgVB8aKrg7+sROpzaDGVjPbuM4sl8oh8vtMoRyITE9k4JgasD1OOk0zBNYGHBC8m/k9yiga8BVFfHleNmpG9RWMDgeo3eJFzVGfJILwfI/tnLMnBDfGcPDwqBIv3BzUkaLnC6b380pMakYRIU0n2rk1unsnQ8CJuA6lGhl59UEFQdby+ulUGIKduuJj/7SR8SFpyMJJbCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SA1PR11MB8476.namprd11.prod.outlook.com (2603:10b6:806:3af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Wed, 8 Apr
 2026 05:52:07 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9769.006; Wed, 8 Apr 2026
 05:52:07 +0000
Date: Wed, 8 Apr 2026 13:51:57 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Leo Martins <loemra.dev@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, David Sterba
	<dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, Sun YangKai
	<sunk67188@gmail.com>, Boris Burkov <boris@bur.io>,
	<linux-btrfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [btrfs]  f9d138838a: stress-ng.dir.ops_per_sec
 6.4% regression
Message-ID: <202604081348.e45317cc-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SG2PR01CA0194.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::22) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SA1PR11MB8476:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce3bbd9-baa0-4fb1-9254-08de9532f7bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: fWuElMP9p4Jv+xmhWU8mqVElgxtaAavW4Lyeq9fAUHllHS944mlCSwgWMNfLfaZwgo8J9ooUlKGv6eC6zqLISyd82pPESIyOWMcfobaAk6ycbZ3pXutWAArm+wfWkyh0ckVf3g0Qgjfr9A6ejr5om5+5yOn0YHRtYGBaCYaZWeFmkN/Qy6s4dyEP+GZpIARG6BqmhTapfECr4RmivWr+GwBw7m1giF+2KVLaM083Log7WHM50xQ56Kf+TKde1Djo3LauQ37dOxFTdTrcCOpl7bBlPi4LIcmhwAMf+K9Eu6Xsek7r/3AhVv9A32D815tSQtVi/89FkBaQQ3tLe4PU7ZBq6JLGT7vSEVD0EiDOIDOK/D6B7NvQsN2uSeneJBQMKnKrohfXNqDw7rQipGoa0uOKFY7IRobCaliKB9N4mxoFHDkWQ5s6sv5lVzkYYk2TfndhYtcXRyE/jS7l6xG/UDXZPdH7QVS739AMpNksqM087kSuh2bW0ut8ev7lEy7q2npgPlhRq/zo55n2cqeCuPBDa0kErjpoB+LkUjpCDr7Jh7pbyfWetxNH2Bvq8qUm9OmfgUo3fIk1HJkfvuA3U/S5rF6v8on3fY05sdAOzGNmmc84XNfd8NuOyyUrxanV8VX6Nb98CE+H+Obj3kblAqL3l+5OVrDBQhBf5xbQO/49/Gu4Kc1W1IwPPVounEcbEeO+NhaVHDDQvR1AjwJybg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?n02ASNM6UoLR2MNKNtzEfxDM6lyiogDzOA7Ogg2iwaMVd7DZG0Ckr62SLR?=
 =?iso-8859-1?Q?EUdiFBpigetVWB0uxMY/OXHP5ihpz64yqKPuB8gggfPw7FXMdY/x5x/xnU?=
 =?iso-8859-1?Q?jwcIXMBXFpRJafvN0uryDDYX1EuzMthUBcDwQAAFs1keeBvUdzgArSO0vr?=
 =?iso-8859-1?Q?0ufe4BrmZvCgRSpqwfP0y9pwL8Y/UIr1caR9crxnveOuOTDECRO7mL3Wlf?=
 =?iso-8859-1?Q?kq91jm8tL50r8MecorToRHtbvBzTYuDqhZgjsc+03ml959cPe463Wm31sc?=
 =?iso-8859-1?Q?9+MOzp5tr+WmH0vDNqdvDHgSP5q/GTSzOj5JuhdLXpN9HmZiAXhBRRR/IM?=
 =?iso-8859-1?Q?VXoKXp0vKSSNLJGhocBv7zIwTp8RYNjNNwLk3/fpzr7Gn1uNJ7dZQz/GFm?=
 =?iso-8859-1?Q?8+lIbGp4tbq8+LMi37opW+0zU+eFE8Z8mfglbotO8wO2hTl79G5AmI818Q?=
 =?iso-8859-1?Q?9VQ+1qX5+IjqKTQKfC1mW49Oz9XrMb4w83aHM3CvZwnlVt60xqkuMEf1U+?=
 =?iso-8859-1?Q?Qx73Nz3ZX/GWT/jNfG97q8MKG1eVbKfOnBhftLkNGcifyCXf+k1YwPMYgd?=
 =?iso-8859-1?Q?TzFWHLXD3XedUElcHhSsYDEr9bFoSddME3RmsS8FoE+2DkzKq/uuZVu0eD?=
 =?iso-8859-1?Q?FOxFZRe+USRyb/DuVnudR4SuqxGdX4eTrx80VRgc9usGYuMhAD2Wp/djfV?=
 =?iso-8859-1?Q?xj6cuM4Q0bWHPIicfhcjTwck5uqVIuiIL37qu4Lfr7yYDpGm0BP5gctdZq?=
 =?iso-8859-1?Q?jKgf/IripOzXqEQIW9DwB1sK/xNI4/9A1lUyg5loFk882HcYcysBbibmFV?=
 =?iso-8859-1?Q?V7yLSfM60G48JcxkbXH2eywbzEILkZYKCGuZT/WY4gVcRqlFFS6dBbpoC+?=
 =?iso-8859-1?Q?vbavZERstAHILjmFSl2eGYvaYSdqikzoJ6RSzf9h5up0DONxSjJ9WzPK58?=
 =?iso-8859-1?Q?1ZC4nyZ+gu5wG7VX1JF6IWJk4cmf5lW3SKUe4jXowj0zQIOn6oUCEp/Myf?=
 =?iso-8859-1?Q?/7Y0H7Ps6FLa6ugw7En5WehR6HUJmuHbydV9OVq7ou8GQxyNjtykuOsbqd?=
 =?iso-8859-1?Q?xYlZTQdqI6XuYyjMYc9oMhwg3I54ix/2dEMVvgem/C3EFw3h6Y8Ywzj9Ey?=
 =?iso-8859-1?Q?ZCu83w1XSOELQaj/nzElC2lWUv2lOGXw6sx4rc0sbiWl8ZEMjBMpuSDJyX?=
 =?iso-8859-1?Q?+MXzQkd6p+zKvGvgCyBfBayqHt8IC00MzPmQG1V42bi2A5nHzptkoP3qOs?=
 =?iso-8859-1?Q?TVlVeafmFWee9o7ljnSTGNMr2ixm2+eVPU8ZLQB1CSlJJD+VaOG6Z+lHQJ?=
 =?iso-8859-1?Q?soyF62Ko5xvCt3pENGuNpbOP3tGpOlr8bgN9uds8URUoTS8Yy+aZsmFsf3?=
 =?iso-8859-1?Q?R4HINEBFHeMl0dckqsEEGXH5i7HZ0VXdRbXpbVCLhHsXHbaz5aRVhcpAsT?=
 =?iso-8859-1?Q?hwp92iblS93QYFh8dObzkTkyfh76AyfvNGOBUuzGSM+yW905PsXYtEcySP?=
 =?iso-8859-1?Q?T8tik0euMCM9+dWRWjcvBtNqzt+LYugej8sspzLfZt1KGS3mH4wm8T3+9r?=
 =?iso-8859-1?Q?KA41KjloxqyPECEnbIVDWEt/1ISGB/5JHbTlIjGyebG1bPOruvIOaZgs/v?=
 =?iso-8859-1?Q?8YUoBySzCZsZDkYlU73kljBLOs3V/Tyk44htrN9ENHE0jN62ZHRIKoGMke?=
 =?iso-8859-1?Q?hwLyFDfCdCo4Bw8HfvEYiQphpB1xwCA35Xnb+IMdd6QkHsR6iUbY0o5AjU?=
 =?iso-8859-1?Q?MyjL1YZIQDOKCcZgTmW/Fr+P1/J7Z50ZD9L7uunqbbe76I+itvFo2DPrAL?=
 =?iso-8859-1?Q?xOu3gwgpYA=3D=3D?=
X-Exchange-RoutingPolicyChecked: sjuujyh0Gee8UOLa/Mfdm/5IKQfLxwr/pBdCkEOm2E+UQoIkq5cnaoWMcFcUcK7DLmQ0cYPaRoVneuE9XQsfJlnJXfSDp75xuLMRaMaTTtsB5B2itu7YtNp6AVS5yIp2rW6LxtiXe6owpctfX7zlOdl1sHN6YmAm9v1Y4I5VrbsBKmobI62Cx90CCCifj8yVR8SiwwDAU32Mv8Ip3aW7R7IHPEW0apjT4+suaoB04610mQxmCzfnZaqQgKD8bXcSRGn48+SxXlGEmrBoUUdC86lLY0dRToGinLAcSBxg/mZsArsaA7ngsKK2dSnIGslaXrmh+o+ALWgdxuXhTfRCng==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce3bbd9-baa0-4fb1-9254-08de9532f7bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 05:52:07.5561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyKuy48ePHd6Hzc1yOlpSn4V/aVeK97AcbmIXYvP1pdA+Q5iqBDU4yDhj/DwLiZ+EP9SVMH1hnWkPAVZLPL5UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8476
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 6.4% regression of stress-ng.dir.ops_per_sec on:


commit: f9d138838a78bf2a5263ad3c1d3c05edbc0844d4 ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master 2febe6e6ee6e34c7754eff3c4d81aa7b0dcb7979]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	disk: 1HDD
	testtime: 60s
	fs: btrfs
	test: dir
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+-----------------------------------------------+
| testcase: change | fsmark: fsmark.files_per_sec  6.5% regression |
| test parameters  | cpufreq_governor=performance                  |
|                  | disk=1BRD_32G                                 |
|                  | filesize=4K                                   |
|                  | fs=btrfs                                      |
|                  | iterations=1x                                 |
|                  | nr_files_per_directory=1fpd                   |
|                  | nr_threads=1t                                 |
|                  | sync_method=fsyncBeforeClose                  |
|                  | test_size=4G                                  |
+------------------+-----------------------------------------------+
| testcase: change | fio-basic: fio.write_iops  7.4% regression    |
| test parameters  | bs=4k                                         |
|                  | cpufreq_governor=performance                  |
|                  | disk=1HDD                                     |
|                  | fs=btrfs                                      |
|                  | ioengine=sync                                 |
|                  | nr_task=1                                     |
|                  | runtime=300s                                  |
|                  | rw=randwrite                                  |
|                  | test_size=128G                                |
+------------------+-----------------------------------------------+
| testcase: change | fio-basic: fio.write_iops  6.8% regression    |
| test parameters  | bs=4k                                         |
|                  | cpufreq_governor=performance                  |
|                  | disk=1HDD                                     |
|                  | fs=btrfs                                      |
|                  | ioengine=vsync                                |
|                  | nr_task=1                                     |
|                  | runtime=300s                                  |
|                  | rw=randwrite                                  |
|                  | test_size=128G                                |
+------------------+-----------------------------------------------+
| testcase: change | fio-basic: fio.write_iops  21.9% regression   |
| test parameters  | bs=4k                                         |
|                  | cpufreq_governor=performance                  |
|                  | disk=1HDD                                     |
|                  | fs=btrfs                                      |
|                  | ioengine=ftruncate                            |
|                  | nr_task=1                                     |
|                  | runtime=300s                                  |
|                  | rw=randwrite                                  |
|                  | test_size=128G                                |
+------------------+-----------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202604081348.e45317cc-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260408/202604081348.e45317cc-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/1HDD/btrfs/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-icl-2sp8/dir/stress-ng/60s

commit: 
  ed7bc52711 ("btrfs: extract the max compression chunk size into a macro")
  f9d138838a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

ed7bc52711022142 f9d138838a78bf2a5263ad3c1d3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      8182            -6.4%       7661        stress-ng.dir.ops_per_sec
     34744 ±  7%     +49.6%      51981 ±  9%  stress-ng.time.involuntary_context_switches
     25199            +2.2%      25759        stress-ng.time.minor_page_faults
      2310            -4.4%       2208        stress-ng.time.percent_of_cpu_this_job_got
      1374            +2.4%       1407        stress-ng.time.system_time
  23103691            +1.8%   23527155        stress-ng.time.voluntary_context_switches
 2.564e+09            +8.9%  2.793e+09        cpuidle..time
     12365 ±  4%      +8.5%      13420        perf-c2c.HITM.local
      2.42            -7.8%       2.23        iostat.cpu.nice
     33.85            -1.6%      33.31        iostat.cpu.system
      1.63            -7.5%       1.51 ±  2%  iostat.cpu.user
      0.70 ±  5%     +14.6%       0.81 ±  7%  vmstat.procs.b
    755798            -3.3%     730692        vmstat.system.cs
    482003            -1.9%     472809        vmstat.system.in
      0.72 ±  3%      +0.1        0.87 ±  7%  mpstat.cpu.all.iowait%
      2.49            -0.2        2.29        mpstat.cpu.all.nice%
      0.08            +0.2        0.27        mpstat.cpu.all.soft%
      1.66            -0.1        1.53 ±  2%  mpstat.cpu.all.usr%
     60.44            +1.3       61.76        turbostat.C1%
     39.12            +5.2%      41.14        turbostat.CPU%c1
      0.04            +0.0        0.05        turbostat.POLL%
     21.71            -1.3%      21.42        turbostat.RAMWatt
      0.90 ±  3%     +30.9%       1.17 ±  7%  perf-sched.total_wait_and_delay.average.ms
   1471503 ±  2%      -9.1%    1337333 ±  7%  perf-sched.total_wait_and_delay.count.ms
      0.89 ±  3%     +30.9%       1.16 ±  7%  perf-sched.total_wait_time.average.ms
      0.90 ±  3%     +30.9%       1.17 ±  7%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
   1471503 ±  2%      -9.1%    1337333 ±  7%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.89 ±  3%     +30.9%       1.16 ±  7%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
 1.696e+10            -5.1%   1.61e+10        perf-stat.i.branch-instructions
      0.42            +0.0        0.44        perf-stat.i.branch-miss-rate%
     54.21            -2.0       52.21        perf-stat.i.cache-miss-rate%
 2.007e+08            -4.2%  1.922e+08        perf-stat.i.cache-misses
 3.645e+08            -2.4%  3.559e+08        perf-stat.i.cache-references
    787352            -3.7%     758130        perf-stat.i.context-switches
      1.33            +5.5%       1.40        perf-stat.i.cpi
 9.793e+10            -3.0%  9.501e+10        perf-stat.i.cpu-cycles
    109605            -6.5%     102455        perf-stat.i.cpu-migrations
 7.944e+10            -5.3%  7.525e+10        perf-stat.i.instructions
      0.80            -3.9%       0.77        perf-stat.i.ipc
     13.83            -4.2%      13.25        perf-stat.i.metric.K/sec
      2.53            +1.1%       2.56        perf-stat.overall.MPKI
      0.36            +0.0        0.38        perf-stat.overall.branch-miss-rate%
     55.07            -1.1       54.02        perf-stat.overall.cache-miss-rate%
      1.23            +2.4%       1.26        perf-stat.overall.cpi
      0.81            -2.3%       0.79        perf-stat.overall.ipc
 1.674e+10            -4.8%  1.593e+10        perf-stat.ps.branch-instructions
 1.983e+08            -4.0%  1.903e+08        perf-stat.ps.cache-misses
 3.601e+08            -2.1%  3.523e+08        perf-stat.ps.cache-references
    779885            -3.7%     751092        perf-stat.ps.context-switches
 9.668e+10            -2.8%  9.396e+10        perf-stat.ps.cpu-cycles
    108710            -6.4%     101802        perf-stat.ps.cpu-migrations
 7.844e+10            -5.1%  7.447e+10        perf-stat.ps.instructions
     31.16            -0.6       30.61        perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     31.02            -0.5       30.48        perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     28.00            -0.5       27.50        perf-profile.calltrace.cycles-pp.do_file_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     27.72            -0.5       27.22        perf-profile.calltrace.cycles-pp.path_openat.do_file_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
      8.96            -0.5        8.49        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function_single.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
      9.75            -0.3        9.48        perf-profile.calltrace.cycles-pp.__btrfs_unlink_inode.btrfs_rename.btrfs_rename2.vfs_rename.filename_renameat2
      1.72            -0.1        1.64        perf-profile.calltrace.cycles-pp.sysvec_call_function_single.asm_sysvec_call_function_single.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry
      1.75            -0.1        1.67 ±  2%  perf-profile.calltrace.cycles-pp.__start_renaming.filename_renameat2.__x64_sys_rename.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.78 ±  3%      -0.1        0.72 ±  4%  perf-profile.calltrace.cycles-pp.path_init.path_openat.do_file_open.do_sys_openat2.__x64_sys_openat
      1.46            -0.1        1.40        perf-profile.calltrace.cycles-pp.btrfs_add_link.btrfs_rename.btrfs_rename2.vfs_rename.filename_renameat2
      0.82 ±  3%      -0.1        0.76        perf-profile.calltrace.cycles-pp.btrfs_lock_root_node.btrfs_search_slot.btrfs_delete_delayed_items.btrfs_async_run_delayed_root.btrfs_work_helper
      0.82 ±  3%      -0.1        0.76 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_tree_lock_nested.btrfs_lock_root_node.btrfs_search_slot.btrfs_delete_delayed_items.btrfs_async_run_delayed_root
      0.82 ±  3%      -0.1        0.76 ±  2%  perf-profile.calltrace.cycles-pp.down_write.btrfs_tree_lock_nested.btrfs_lock_root_node.btrfs_search_slot.btrfs_delete_delayed_items
      1.35            -0.1        1.29        perf-profile.calltrace.cycles-pp.__sysvec_call_function_single.sysvec_call_function_single.asm_sysvec_call_function_single.pv_native_safe_halt.acpi_safe_halt
      1.26            -0.1        1.21        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function_single.sysvec_call_function_single.asm_sysvec_call_function_single.pv_native_safe_halt
      0.90            -0.0        0.86        perf-profile.calltrace.cycles-pp.sched_ttwu_pending.__flush_smp_call_function_queue.__sysvec_call_function_single.sysvec_call_function_single.asm_sysvec_call_function_single
      0.63            -0.0        0.60        perf-profile.calltrace.cycles-pp.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue.__sysvec_call_function_single.sysvec_call_function_single
      0.75            -0.0        0.73        perf-profile.calltrace.cycles-pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.start_secondary
      0.56            -0.0        0.54 ±  2%  perf-profile.calltrace.cycles-pp.down_write.__start_renaming.filename_renameat2.__x64_sys_rename.do_syscall_64
      0.77            -0.0        0.75        perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      0.66 ±  5%      +0.1        0.74 ±  5%  perf-profile.calltrace.cycles-pp.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_inode.__btrfs_update_delayed_inode.btrfs_async_run_delayed_root
      0.64 ±  4%      +0.1        0.72 ±  5%  perf-profile.calltrace.cycles-pp.down_read.btrfs_tree_read_lock_nested.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_inode
      0.64 ±  4%      +0.1        0.72 ±  5%  perf-profile.calltrace.cycles-pp.btrfs_tree_read_lock_nested.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_inode.__btrfs_update_delayed_inode
      2.77            +0.1        2.91        perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
      1.12 ±  3%      +0.2        1.34 ±  4%  perf-profile.calltrace.cycles-pp.__btrfs_update_delayed_inode.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work.worker_thread
      1.02 ±  3%      +0.2        1.25 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_lookup_inode.__btrfs_update_delayed_inode.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work
      1.02 ±  3%      +0.2        1.25 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_inode.__btrfs_update_delayed_inode.btrfs_async_run_delayed_root.btrfs_work_helper
      0.66            +0.3        0.92 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
      3.16 ±  2%      +0.5        3.68 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_work_helper.process_one_work.worker_thread.kthread.ret_from_fork
      3.15 ±  2%      +0.5        3.68 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work.worker_thread.kthread
      0.00            +0.5        0.54 ±  3%  perf-profile.calltrace.cycles-pp.__btrfs_end_transaction.btrfs_rename.btrfs_rename2.vfs_rename.filename_renameat2
      3.30 ±  2%      +0.6        3.88 ±  2%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      3.31 ±  3%      +0.6        3.89 ±  2%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      3.32 ±  3%      +0.7        3.98 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      3.32 ±  3%      +0.7        3.98 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      3.32 ±  3%      +0.7        3.98 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      0.00            +0.7        0.66 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry
     31.22            -0.6       30.67        perf-profile.children.cycles-pp.__x64_sys_openat
     31.13            -0.5       30.59        perf-profile.children.cycles-pp.do_sys_openat2
     28.06            -0.5       27.56        perf-profile.children.cycles-pp.do_file_open
     27.86            -0.5       27.36        perf-profile.children.cycles-pp.path_openat
     76.72            -0.5       76.23        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     76.28            -0.5       75.80        perf-profile.children.cycles-pp.do_syscall_64
      7.38 ±  2%      -0.4        7.03 ±  2%  perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      8.19 ±  2%      -0.3        7.86 ±  2%  perf-profile.children.cycles-pp.down_write
      6.71 ±  2%      -0.3        6.42 ±  3%  perf-profile.children.cycles-pp.btrfs_tree_lock_nested
      5.49            -0.3        5.21        perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      9.75            -0.3        9.48        perf-profile.children.cycles-pp.__btrfs_unlink_inode
      1.77            -0.1        1.69        perf-profile.children.cycles-pp.sysvec_call_function_single
      0.88            -0.1        0.81 ±  2%  perf-profile.children.cycles-pp.__memmove
      1.84            -0.1        1.76        perf-profile.children.cycles-pp.rwsem_wake
      1.75            -0.1        1.67 ±  2%  perf-profile.children.cycles-pp.__start_renaming
      1.60            -0.1        1.52        perf-profile.children.cycles-pp.wake_up_q
      0.82 ±  2%      -0.1        0.75 ±  3%  perf-profile.children.cycles-pp.path_init
      1.88            -0.1        1.81        perf-profile.children.cycles-pp.up_write
      1.46            -0.1        1.40        perf-profile.children.cycles-pp.btrfs_add_link
      1.55            -0.1        1.49        perf-profile.children.cycles-pp.try_to_wake_up
      1.39            -0.1        1.33        perf-profile.children.cycles-pp.__sysvec_call_function_single
      1.31            -0.1        1.26        perf-profile.children.cycles-pp.__flush_smp_call_function_queue
      0.62            -0.0        0.57        perf-profile.children.cycles-pp.btrfs_update_inode
      0.44            -0.0        0.40 ±  3%  perf-profile.children.cycles-pp.btrfs_extend_item
      0.47            -0.0        0.43 ±  3%  perf-profile.children.cycles-pp.setup_items_for_insert
      0.93            -0.0        0.90        perf-profile.children.cycles-pp.sched_ttwu_pending
      0.50            -0.0        0.46        perf-profile.children.cycles-pp.btrfs_delayed_update_inode
      1.29            -0.0        1.26        perf-profile.children.cycles-pp.inode_permission
      0.31 ±  3%      -0.0        0.28 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.13 ±  4%      -0.0        0.11 ±  3%  perf-profile.children.cycles-pp.__btrfs_release_delayed_node
      0.19            -0.0        0.17 ±  3%  perf-profile.children.cycles-pp.btrfs_readdir_get_delayed_items
      0.16            -0.0        0.14 ±  5%  perf-profile.children.cycles-pp.btrfs_inode_lock
      0.22 ±  2%      -0.0        0.21 ±  2%  perf-profile.children.cycles-pp.wakeup_preempt
      0.10 ±  5%      -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.btrfs_update_root_times
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.radix_tree_node_rcu_free
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.__call_rcu_common
      0.01 ±223%      +0.1        0.07 ±  8%  perf-profile.children.cycles-pp.__slab_free
      0.02 ± 99%      +0.1        0.10 ±  8%  perf-profile.children.cycles-pp._raw_spin_unlock_irq
      0.00            +0.1        0.07 ±  9%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.00            +0.1        0.08 ±  8%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.00            +0.1        0.08 ±  7%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.00            +0.1        0.08 ±  5%  perf-profile.children.cycles-pp.__refill_objects_node
      0.00            +0.1        0.09 ±  4%  perf-profile.children.cycles-pp.refill_objects
      0.00            +0.1        0.10 ±  5%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.00            +0.1        0.10 ±  3%  perf-profile.children.cycles-pp.xas_alloc
      0.00            +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.kmem_cache_alloc_lru_noprof
      0.20            +0.1        0.32 ±  4%  perf-profile.children.cycles-pp.xa_load
      0.19            +0.1        0.32 ±  4%  perf-profile.children.cycles-pp.xas_load
      0.54            +0.1        0.67 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.00            +0.2        0.19 ±  3%  perf-profile.children.cycles-pp.xas_create
      0.00            +0.2        0.21 ±  5%  perf-profile.children.cycles-pp.xas_store
      0.00            +0.2        0.22 ±  3%  perf-profile.children.cycles-pp.__xa_store
      1.12 ±  3%      +0.2        1.34 ±  4%  perf-profile.children.cycles-pp.__btrfs_update_delayed_inode
      0.00            +0.2        0.23 ±  3%  perf-profile.children.cycles-pp.xa_store
      1.02 ±  3%      +0.2        1.25 ±  4%  perf-profile.children.cycles-pp.btrfs_lookup_inode
      0.00            +0.3        0.25 ±  3%  perf-profile.children.cycles-pp.xas_free_nodes
      0.00            +0.3        0.26 ±  3%  perf-profile.children.cycles-pp.xa_destroy
      1.06            +0.3        1.39        perf-profile.children.cycles-pp.kmem_cache_free
      0.00            +0.4        0.38 ±  5%  perf-profile.children.cycles-pp.xa_find_after
      0.00            +0.4        0.43 ±  5%  perf-profile.children.cycles-pp.xas_find
      0.23 ±  3%      +0.5        0.70 ±  3%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.72 ±  2%      +0.5        1.19        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      1.02            +0.5        1.49        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.00            +0.5        0.50 ±  4%  perf-profile.children.cycles-pp.btrfs_inhibit_eb_writeback
      0.05            +0.5        0.58 ±  4%  perf-profile.children.cycles-pp.rcu_do_batch
      3.16 ±  2%      +0.5        3.68 ±  2%  perf-profile.children.cycles-pp.btrfs_work_helper
      3.15            +0.5        3.68 ±  2%  perf-profile.children.cycles-pp.btrfs_async_run_delayed_root
      0.09            +0.5        0.62 ±  4%  perf-profile.children.cycles-pp.rcu_core
      0.18 ±  2%      +0.5        0.72 ±  3%  perf-profile.children.cycles-pp.handle_softirqs
      3.30 ±  2%      +0.6        3.88 ±  2%  perf-profile.children.cycles-pp.process_one_work
      3.31 ±  3%      +0.6        3.89 ±  2%  perf-profile.children.cycles-pp.worker_thread
      3.32 ±  3%      +0.7        3.98 ±  2%  perf-profile.children.cycles-pp.kthread
      3.32 ±  3%      +0.7        3.98 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
      3.32 ±  3%      +0.7        3.98 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.00            +0.8        0.79 ±  2%  perf-profile.children.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.07 ±  5%      +0.8        0.87 ±  2%  perf-profile.children.cycles-pp.__btrfs_end_transaction
      4.33            -0.2        4.11        perf-profile.self.cycles-pp.pv_native_safe_halt
      0.48 ± 18%      -0.1        0.39 ±  4%  perf-profile.self.cycles-pp.rwsem_down_write_slowpath
      0.88            -0.1        0.80 ±  3%  perf-profile.self.cycles-pp.__memmove
      0.79 ±  3%      -0.1        0.72 ±  4%  perf-profile.self.cycles-pp.path_init
      2.26            -0.0        2.23        perf-profile.self.cycles-pp.clear_bhb_loop
      0.13            -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.poll_idle
      0.20            -0.0        0.19        perf-profile.self.cycles-pp.__flush_smp_call_function_queue
      0.20 ±  2%      -0.0        0.19 ±  3%  perf-profile.self.cycles-pp.__resched_curr
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.rcu_do_batch
      0.00            +0.1        0.06 ± 14%  perf-profile.self.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.__slab_free
      0.00            +0.1        0.08 ±  4%  perf-profile.self.cycles-pp.__refill_objects_node
      0.00            +0.1        0.08 ±  4%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.00            +0.1        0.09 ±  4%  perf-profile.self.cycles-pp.xas_create
      0.14 ±  3%      +0.1        0.25 ±  4%  perf-profile.self.cycles-pp.xas_load
      0.24 ±  4%      +0.1        0.37 ±  3%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.00            +0.1        0.14 ± 15%  perf-profile.self.cycles-pp.btrfs_inhibit_eb_writeback
      0.47 ±  2%      +0.2        0.63 ±  2%  perf-profile.self.cycles-pp.kmem_cache_free
      0.00            +0.2        0.20 ±  4%  perf-profile.self.cycles-pp.xas_free_nodes
      0.00            +0.4        0.42 ±  4%  perf-profile.self.cycles-pp.xas_find


***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/disk/filesize/fs/iterations/kconfig/nr_files_per_directory/nr_threads/rootfs/sync_method/tbox_group/test_size/testcase:
  gcc-14/performance/1BRD_32G/4K/btrfs/1x/x86_64-rhel-9.4/1fpd/1t/debian-13-x86_64-20250902.cgz/fsyncBeforeClose/lkp-icl-2sp9/4G/fsmark

commit: 
  ed7bc52711 ("btrfs: extract the max compression chunk size into a macro")
  f9d138838a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

ed7bc52711022142 f9d138838a78bf2a5263ad3c1d3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  18435752           +18.4%   21820507        fsmark.app_overhead
      6483            -6.5%       6059        fsmark.files_per_sec
    158.16            +6.7%     168.82        fsmark.time.elapsed_time
    158.16            +6.7%     168.82        fsmark.time.elapsed_time.max
     81.50            -4.3%      78.00        fsmark.time.percent_of_cpu_this_job_got
   3081153            +1.6%    3131359        fsmark.time.voluntary_context_switches
  9.99e+09            +6.8%  1.067e+10        cpuidle..time
      2350 ±  4%     -15.4%       1988 ±  2%  perf-c2c.HITM.local
    205.55            +5.2%     216.26        uptime.boot
     12643            +5.3%      13314        uptime.idle
      0.05            -0.0        0.05        mpstat.cpu.all.iowait%
      0.03 ±  6%      +0.0        0.05        mpstat.cpu.all.soft%
      0.37            -0.0        0.35 ±  2%  mpstat.cpu.all.usr%
    978289            -6.1%     918444        vmstat.io.bo
    183913            -6.3%     172244        vmstat.system.cs
     99177            -5.4%      93816        vmstat.system.in
 1.581e+09            +3.7%   1.64e+09        perf-stat.i.branch-instructions
      0.91            -0.0        0.86        perf-stat.i.branch-miss-rate%
     19.12            -0.2       18.88        perf-stat.i.cache-miss-rate%
  12573211            +4.2%   13106119        perf-stat.i.cache-misses
  67064028            +5.6%   70830932        perf-stat.i.cache-references
    187480            -6.7%     174988        perf-stat.i.context-switches
      0.82            -3.9%       0.79        perf-stat.i.cpi
 7.006e+09            -2.2%  6.854e+09        perf-stat.i.cpu-cycles
    108.44           +21.8%     132.09 ±  2%  perf-stat.i.cpu-migrations
    571.12            -6.5%     534.23        perf-stat.i.cycles-between-cache-misses
      1.26            +3.7%       1.31        perf-stat.i.ipc
      2.92            -6.7%       2.73        perf-stat.i.metric.K/sec
      1.46            +2.8%       1.50        perf-stat.overall.MPKI
      1.20            -0.1        1.13        perf-stat.overall.branch-miss-rate%
      0.81            -3.5%       0.78        perf-stat.overall.cpi
    557.39            -6.1%     523.26        perf-stat.overall.cycles-between-cache-misses
      1.23            +3.6%       1.28        perf-stat.overall.ipc
 1.572e+09            +3.7%   1.63e+09        perf-stat.ps.branch-instructions
  12495446            +4.3%   13029250        perf-stat.ps.cache-misses
  66647875            +5.7%   70420075        perf-stat.ps.cache-references
    186297            -6.6%     173960        perf-stat.ps.context-switches
 6.965e+09            -2.1%  6.817e+09        perf-stat.ps.cpu-cycles
    107.77           +21.9%     131.32 ±  2%  perf-stat.ps.cpu-migrations
  1.37e+12            +8.3%  1.485e+12        perf-stat.total.instructions
     27.32 ±  3%      -1.4       25.94 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_sync_file.do_fsync.__x64_sys_fsync.do_syscall_64.entry_SYSCALL_64_after_hwframe
     27.34 ±  3%      -1.4       25.96 ±  2%  perf-profile.calltrace.cycles-pp.__x64_sys_fsync.do_syscall_64.entry_SYSCALL_64_after_hwframe
     27.34 ±  3%      -1.4       25.96 ±  2%  perf-profile.calltrace.cycles-pp.do_fsync.__x64_sys_fsync.do_syscall_64.entry_SYSCALL_64_after_hwframe
     16.88 ±  2%      -1.3       15.58 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_sync_log.btrfs_sync_file.do_fsync.__x64_sys_fsync.do_syscall_64
     13.40 ±  3%      -0.9       12.52 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_submit_chunk.btrfs_submit_bbio.btree_writepages.do_writepages.filemap_writeback
     13.40 ±  3%      -0.9       12.52 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_submit_bbio.btree_writepages.do_writepages.filemap_writeback.btrfs_write_marked_extents
      5.17 ± 17%      -0.8        4.36 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_submit_bio.btrfs_submit_chunk.btrfs_submit_bbio.btree_writepages.do_writepages
      4.90 ± 18%      -0.8        4.12 ±  2%  perf-profile.calltrace.cycles-pp.__submit_bio_noacct.btrfs_submit_bio.btrfs_submit_chunk.btrfs_submit_bbio.btree_writepages
      4.89 ± 18%      -0.8        4.11 ±  2%  perf-profile.calltrace.cycles-pp.__submit_bio.__submit_bio_noacct.btrfs_submit_bio.btrfs_submit_chunk.btrfs_submit_bbio
      4.16 ± 19%      -0.7        3.50 ±  2%  perf-profile.calltrace.cycles-pp.brd_submit_bio.__submit_bio.__submit_bio_noacct.btrfs_submit_bio.btrfs_submit_chunk
     12.36 ±  3%      -0.6       11.73 ±  2%  perf-profile.calltrace.cycles-pp.filemap_writeback.btrfs_write_marked_extents.btrfs_sync_log.btrfs_sync_file.do_fsync
     12.48 ±  3%      -0.6       11.85 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_write_marked_extents.btrfs_sync_log.btrfs_sync_file.do_fsync.__x64_sys_fsync
     12.31 ±  3%      -0.6       11.68 ±  2%  perf-profile.calltrace.cycles-pp.do_writepages.filemap_writeback.btrfs_write_marked_extents.btrfs_sync_log.btrfs_sync_file
     12.30 ±  3%      -0.6       11.67 ±  2%  perf-profile.calltrace.cycles-pp.btree_writepages.do_writepages.filemap_writeback.btrfs_write_marked_extents.btrfs_sync_log
      1.93 ± 10%      -0.6        1.33 ± 11%  perf-profile.calltrace.cycles-pp.mutex_spin_on_owner.__mutex_lock.btrfs_sync_log.btrfs_sync_file.do_fsync
      1.93 ± 10%      -0.6        1.34 ± 11%  perf-profile.calltrace.cycles-pp.__mutex_lock.btrfs_sync_log.btrfs_sync_file.do_fsync.__x64_sys_fsync
      4.54 ±  3%      -0.5        4.08 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_preempt_reclaim_metadata_space.process_one_work.worker_thread.kthread.ret_from_fork
      4.54 ±  3%      -0.5        4.08 ±  2%  perf-profile.calltrace.cycles-pp.flush_space.btrfs_preempt_reclaim_metadata_space.process_one_work.worker_thread.kthread
      3.29 ±  3%      -0.4        2.88 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_commit_transaction.flush_space.btrfs_preempt_reclaim_metadata_space.process_one_work.worker_thread
      2.83 ±  2%      -0.3        2.50 ±  3%  perf-profile.calltrace.cycles-pp.filemap_writeback.btrfs_write_marked_extents.btrfs_write_and_wait_transaction.btrfs_commit_transaction.flush_space
      2.82 ±  2%      -0.3        2.49 ±  3%  perf-profile.calltrace.cycles-pp.btree_writepages.do_writepages.filemap_writeback.btrfs_write_marked_extents.btrfs_write_and_wait_transaction
      2.82 ±  2%      -0.3        2.49 ±  3%  perf-profile.calltrace.cycles-pp.do_writepages.filemap_writeback.btrfs_write_marked_extents.btrfs_write_and_wait_transaction.btrfs_commit_transaction
      2.85 ±  2%      -0.3        2.52 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_write_marked_extents.btrfs_write_and_wait_transaction.btrfs_commit_transaction.flush_space.btrfs_preempt_reclaim_metadata_space
      2.86 ±  2%      -0.3        2.54 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_write_and_wait_transaction.btrfs_commit_transaction.flush_space.btrfs_preempt_reclaim_metadata_space.process_one_work
      1.13 ± 18%      -0.3        0.82 ± 24%  perf-profile.calltrace.cycles-pp.btrfs_init_new_buffer.btrfs_alloc_tree_block.btrfs_force_cow_block.btrfs_cow_block.btrfs_search_slot
      0.94 ± 19%      -0.2        0.76 ±  4%  perf-profile.calltrace.cycles-pp.copy_extent_buffer_full.btrfs_force_cow_block.btrfs_cow_block.btrfs_search_slot.btrfs_lookup_csum
      1.54 ±  3%      -0.1        1.43 ±  4%  perf-profile.calltrace.cycles-pp.orig_write_end_io_work.process_one_work.worker_thread.kthread.ret_from_fork
      1.64 ±  2%      -0.1        1.56        perf-profile.calltrace.cycles-pp.btrfs_cow_block.btrfs_search_slot.btrfs_update_root.btrfs_sync_log.btrfs_sync_file
      1.63 ±  2%      -0.1        1.56        perf-profile.calltrace.cycles-pp.btrfs_force_cow_block.btrfs_cow_block.btrfs_search_slot.btrfs_update_root.btrfs_sync_log
      1.67 ±  2%      -0.1        1.60        perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_update_root.btrfs_sync_log.btrfs_sync_file.do_fsync
      1.69 ±  2%      -0.1        1.63        perf-profile.calltrace.cycles-pp.btrfs_update_root.btrfs_sync_log.btrfs_sync_file.do_fsync.__x64_sys_fsync
      1.00 ±  5%      +0.1        1.08 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_create_new_inode.btrfs_create_common.lookup_open.open_last_lookups.path_openat
      0.78 ±  7%      +0.1        0.87 ±  2%  perf-profile.calltrace.cycles-pp.insert_reserved_file_extent.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread
      0.56 ±  3%      +0.2        0.76 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_insert_delayed_item.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work.worker_thread
      1.59 ±  6%      +0.4        1.98 ±  2%  perf-profile.calltrace.cycles-pp.lookup_open.open_last_lookups.path_openat.do_file_open.do_sys_openat2
      1.65 ±  5%      +0.4        2.06 ±  2%  perf-profile.calltrace.cycles-pp.open_last_lookups.path_openat.do_file_open.do_sys_openat2.__x64_sys_openat
      1.85 ±  5%      +0.4        2.26 ±  3%  perf-profile.calltrace.cycles-pp.path_openat.do_file_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
      1.85 ±  5%      +0.4        2.26 ±  3%  perf-profile.calltrace.cycles-pp.do_file_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.90 ±  5%      +0.4        2.32 ±  3%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.90 ±  5%      +0.4        2.32 ±  3%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.13 ±  6%      +0.4        1.57 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_create_common.lookup_open.open_last_lookups.path_openat.do_file_open
      2.15 ±  4%      +0.5        2.67        perf-profile.calltrace.cycles-pp.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread.kthread
      3.88 ±  4%      +0.5        4.40 ±  2%  perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
      0.00            +0.5        0.52 ±  4%  perf-profile.calltrace.cycles-pp.__btrfs_end_transaction.btrfs_create_common.btrfs_mkdir.vfs_mkdir.filename_mkdirat
      3.58 ±  4%      +0.5        4.13 ±  2%  perf-profile.calltrace.cycles-pp.filename_mkdirat.__x64_sys_mkdir.do_syscall_64.entry_SYSCALL_64_after_hwframe.mkdir
      3.62 ±  5%      +0.5        4.17 ±  2%  perf-profile.calltrace.cycles-pp.__x64_sys_mkdir.do_syscall_64.entry_SYSCALL_64_after_hwframe.mkdir
      3.63 ±  5%      +0.6        4.18 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.mkdir
      2.76 ±  5%      +0.6        3.31        perf-profile.calltrace.cycles-pp.btrfs_create_common.btrfs_mkdir.vfs_mkdir.filename_mkdirat.__x64_sys_mkdir
      3.63 ±  5%      +0.6        4.18 ±  2%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.mkdir
      3.65 ±  4%      +0.6        4.21 ±  2%  perf-profile.calltrace.cycles-pp.mkdir
      2.95 ±  5%      +0.6        3.51 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_mkdir.vfs_mkdir.filename_mkdirat.__x64_sys_mkdir.do_syscall_64
      2.99 ±  5%      +0.6        3.55 ±  2%  perf-profile.calltrace.cycles-pp.vfs_mkdir.filename_mkdirat.__x64_sys_mkdir.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.6        0.56 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_drop_extents.insert_reserved_file_extent.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work
      0.00            +0.6        0.60 ±  5%  perf-profile.calltrace.cycles-pp.__btrfs_update_delayed_inode.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work.worker_thread
      0.00            +0.6        0.63 ±  6%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +0.6        0.65 ±  6%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +0.7        0.67 ±  5%  perf-profile.calltrace.cycles-pp.btrfs_insert_empty_items.btrfs_insert_delayed_item.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work
      0.00            +0.7        0.70 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work
      0.00            +0.7        0.70 ±  6%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt
      0.00            +0.7        0.70 ±  7%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt
      0.00            +0.7        0.72 ±  4%  perf-profile.calltrace.cycles-pp.__btrfs_end_transaction.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work.worker_thread
      0.47 ± 44%      +0.8        1.25 ±  4%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
     32.62            +0.9       33.48 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     32.62            +0.9       33.48 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     32.62            +0.9       33.48 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      0.00            +0.9        0.93 ±  5%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry
      1.11 ±  2%      +1.1        2.21 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_async_run_delayed_root.btrfs_work_helper.process_one_work.worker_thread.kthread
      3.27 ±  3%      +1.6        4.89        perf-profile.calltrace.cycles-pp.btrfs_work_helper.process_one_work.worker_thread.kthread.ret_from_fork
     27.33 ±  3%      -1.4       25.94 ±  2%  perf-profile.children.cycles-pp.btrfs_sync_file
     27.34 ±  3%      -1.4       25.96 ±  2%  perf-profile.children.cycles-pp.__x64_sys_fsync
     27.34 ±  3%      -1.4       25.96 ±  2%  perf-profile.children.cycles-pp.do_fsync
     16.89 ±  2%      -1.3       15.58 ±  2%  perf-profile.children.cycles-pp.btrfs_sync_log
     16.57 ±  2%      -1.0       15.60 ±  2%  perf-profile.children.cycles-pp.filemap_writeback
     16.46 ±  2%      -1.0       15.49 ±  2%  perf-profile.children.cycles-pp.do_writepages
     15.34 ±  3%      -1.0       14.38 ±  2%  perf-profile.children.cycles-pp.btrfs_write_marked_extents
     15.13 ±  3%      -1.0       14.17 ±  2%  perf-profile.children.cycles-pp.btree_writepages
     13.82 ±  3%      -0.9       12.96 ±  2%  perf-profile.children.cycles-pp.btrfs_submit_chunk
     13.83 ±  3%      -0.9       12.96 ±  2%  perf-profile.children.cycles-pp.btrfs_submit_bbio
      5.50 ± 12%      -0.7        4.81 ±  2%  perf-profile.children.cycles-pp.btrfs_submit_bio
      5.52 ± 12%      -0.7        4.86        perf-profile.children.cycles-pp.__submit_bio_noacct
      5.50 ± 12%      -0.7        4.84        perf-profile.children.cycles-pp.__submit_bio
      1.93 ± 10%      -0.6        1.34 ± 10%  perf-profile.children.cycles-pp.mutex_spin_on_owner
      1.93 ± 10%      -0.6        1.34 ± 11%  perf-profile.children.cycles-pp.__mutex_lock
      4.54 ± 13%      -0.6        3.96 ±  2%  perf-profile.children.cycles-pp.brd_rw_bvec
      4.56 ± 13%      -0.6        3.98 ±  2%  perf-profile.children.cycles-pp.brd_submit_bio
      6.48 ±  7%      -0.5        5.97        perf-profile.children.cycles-pp.btrfs_force_cow_block
      6.49 ±  7%      -0.5        6.00        perf-profile.children.cycles-pp.btrfs_cow_block
      4.54 ±  3%      -0.5        4.08 ±  2%  perf-profile.children.cycles-pp.btrfs_preempt_reclaim_metadata_space
      4.54 ±  3%      -0.5        4.08 ±  2%  perf-profile.children.cycles-pp.flush_space
      3.29 ±  3%      -0.4        2.88 ±  2%  perf-profile.children.cycles-pp.btrfs_commit_transaction
      3.28 ±  9%      -0.4        2.92 ±  2%  perf-profile.children.cycles-pp.__pi_memcpy
      2.86 ±  2%      -0.3        2.54 ±  3%  perf-profile.children.cycles-pp.btrfs_write_and_wait_transaction
      2.19 ± 15%      -0.3        1.88 ±  2%  perf-profile.children.cycles-pp.copy_extent_buffer_full
      2.66 ±  2%      -0.2        2.46 ±  2%  perf-profile.children.cycles-pp.btrfs_alloc_tree_block
      1.82 ±  3%      -0.1        1.68 ±  2%  perf-profile.children.cycles-pp.btrfs_init_new_buffer
      1.54 ±  3%      -0.1        1.43 ±  4%  perf-profile.children.cycles-pp.orig_write_end_io_work
      0.35 ± 11%      -0.1        0.27 ±  8%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.44 ±  4%      -0.1        0.36 ±  5%  perf-profile.children.cycles-pp.menu_select
      0.90 ±  3%      -0.1        0.83 ±  5%  perf-profile.children.cycles-pp.btrfs_release_path
      1.03 ±  3%      -0.1        0.96 ±  4%  perf-profile.children.cycles-pp.attach_eb_folio_to_filemap
      1.70 ±  2%      -0.1        1.63        perf-profile.children.cycles-pp.btrfs_update_root
      0.12 ±  8%      -0.1        0.07 ±  7%  perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      0.68 ±  2%      -0.1        0.62 ±  3%  perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      0.98 ±  2%      -0.0        0.94 ±  2%  perf-profile.children.cycles-pp.btrfs_bin_search
      0.42 ±  5%      -0.0        0.38 ±  3%  perf-profile.children.cycles-pp.run_delayed_tree_ref
      0.42 ±  4%      -0.0        0.38 ±  3%  perf-profile.children.cycles-pp.alloc_reserved_tree_block
      0.22 ±  5%      -0.0        0.18 ±  4%  perf-profile.children.cycles-pp.add_delayed_ref
      0.12 ±  4%      -0.0        0.09 ± 12%  perf-profile.children.cycles-pp.mempool_alloc_noprof
      0.14 ±  5%      -0.0        0.11 ±  7%  perf-profile.children.cycles-pp.btrfs_get_16
      0.08 ± 12%      +0.0        0.10 ±  8%  perf-profile.children.cycles-pp.sched_tick
      0.16 ±  4%      +0.0        0.18 ±  5%  perf-profile.children.cycles-pp.update_process_times
      0.17 ± 15%      +0.0        0.20 ±  6%  perf-profile.children.cycles-pp.poll_idle
      0.12 ±  7%      +0.0        0.16 ± 11%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.15 ±  7%      +0.0        0.18 ± 12%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.15 ±  9%      +0.0        0.19 ± 10%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.35 ±  4%      +0.0        0.40 ±  3%  perf-profile.children.cycles-pp.btrfs_search_forward
      0.31 ±  5%      +0.0        0.36 ±  2%  perf-profile.children.cycles-pp.free_extent_buffer
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.menu_reflect
      0.24 ±  7%      +0.1        0.29 ±  7%  perf-profile.children.cycles-pp.xas_start
      0.35 ±  2%      +0.1        0.40 ±  6%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.34 ±  3%      +0.1        0.39 ±  6%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.rcu_segcblist_enqueue
      0.00            +0.1        0.07 ± 36%  perf-profile.children.cycles-pp.__slab_free
      0.00            +0.1        0.08 ± 19%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.00            +0.1        0.09 ± 17%  perf-profile.children.cycles-pp.sheaf_flush_unused
      0.79 ±  7%      +0.1        0.87 ±  2%  perf-profile.children.cycles-pp.insert_reserved_file_extent
      0.05 ± 47%      +0.1        0.15 ± 13%  perf-profile.children.cycles-pp.__pcs_replace_full_main
      0.00            +0.1        0.12 ±  9%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.44 ±  6%      +0.1        0.56 ±  3%  perf-profile.children.cycles-pp.btrfs_drop_extents
      0.49 ±  6%      +0.2        0.66 ±  3%  perf-profile.children.cycles-pp.xa_load
      0.26 ±  9%      +0.2        0.42 ±  4%  perf-profile.children.cycles-pp.btrfs_lookup_file_extent
      0.00            +0.2        0.18 ±  9%  perf-profile.children.cycles-pp.__call_rcu_common
      1.18 ±  4%      +0.2        1.37 ±  3%  perf-profile.children.cycles-pp.xas_load
      0.41 ±  4%      +0.2        0.60 ±  5%  perf-profile.children.cycles-pp.__btrfs_update_delayed_inode
      0.29 ±  5%      +0.2        0.49 ±  5%  perf-profile.children.cycles-pp.btrfs_lookup_inode
      0.57 ±  3%      +0.2        0.77 ±  4%  perf-profile.children.cycles-pp.btrfs_insert_delayed_item
      0.00            +0.2        0.24 ±  7%  perf-profile.children.cycles-pp.radix_tree_node_rcu_free
      0.02 ± 99%      +0.3        0.28 ±  5%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.00            +0.3        0.33 ± 17%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.00            +0.3        0.34 ± 17%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.00            +0.3        0.34 ±  5%  perf-profile.children.cycles-pp.xa_find
      1.60 ±  6%      +0.4        1.98 ±  2%  perf-profile.children.cycles-pp.lookup_open
      1.65 ±  6%      +0.4        2.06 ±  2%  perf-profile.children.cycles-pp.open_last_lookups
      1.85 ±  5%      +0.4        2.26 ±  2%  perf-profile.children.cycles-pp.path_openat
      1.85 ±  5%      +0.4        2.26 ±  3%  perf-profile.children.cycles-pp.do_file_open
      1.90 ±  5%      +0.4        2.32 ±  3%  perf-profile.children.cycles-pp.__x64_sys_openat
      1.90 ±  5%      +0.4        2.32 ±  3%  perf-profile.children.cycles-pp.do_sys_openat2
      0.29 ± 10%      +0.4        0.72 ±  4%  perf-profile.children.cycles-pp.refill_objects
      0.36 ±  8%      +0.4        0.80 ±  4%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.13 ± 21%      +0.5        0.58 ±  4%  perf-profile.children.cycles-pp.__refill_objects_node
      0.33 ±  4%      +0.5        0.81 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
      0.24 ±  8%      +0.5        0.76 ±  4%  perf-profile.children.cycles-pp.kmem_cache_alloc_lru_noprof
      2.15 ±  4%      +0.5        2.67        perf-profile.children.cycles-pp.btrfs_finish_one_ordered
      3.58 ±  4%      +0.5        4.13 ±  2%  perf-profile.children.cycles-pp.filename_mkdirat
      3.62 ±  5%      +0.6        4.17 ±  2%  perf-profile.children.cycles-pp.__x64_sys_mkdir
      3.66 ±  4%      +0.6        4.21 ±  2%  perf-profile.children.cycles-pp.mkdir
      2.95 ±  5%      +0.6        3.51 ±  2%  perf-profile.children.cycles-pp.btrfs_mkdir
      2.99 ±  5%      +0.6        3.55 ±  2%  perf-profile.children.cycles-pp.vfs_mkdir
      0.00            +0.6        0.59 ±  4%  perf-profile.children.cycles-pp.xas_alloc
      0.00            +0.7        0.75 ±  4%  perf-profile.children.cycles-pp.xas_free_nodes
      0.00            +0.8        0.80 ±  4%  perf-profile.children.cycles-pp.xa_destroy
      0.53 ±  6%      +0.8        1.34 ±  8%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.06 ± 14%      +0.8        0.88 ±  3%  perf-profile.children.cycles-pp.xas_create
      0.56 ±  3%      +0.8        1.39 ±  5%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      1.15 ±  3%      +0.8        1.98 ±  3%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.16 ±  6%      +0.9        1.02 ±  4%  perf-profile.children.cycles-pp.xas_store
     32.62            +0.9       33.48 ±  2%  perf-profile.children.cycles-pp.kthread
     32.62            +0.9       33.48 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
     32.62            +0.9       33.48 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.04 ± 71%      +0.9        0.94 ±  3%  perf-profile.children.cycles-pp.__xa_store
      0.05 ± 45%      +1.0        1.00 ±  3%  perf-profile.children.cycles-pp.xa_store
      3.89 ±  5%      +1.0        4.88 ±  2%  perf-profile.children.cycles-pp.btrfs_create_common
      0.00            +1.0        1.01 ±  3%  perf-profile.children.cycles-pp.xa_find_after
      0.10 ± 11%      +1.1        1.18        perf-profile.children.cycles-pp.rcu_do_batch
      0.12 ± 10%      +1.1        1.20 ±  2%  perf-profile.children.cycles-pp.rcu_core
      1.11 ±  2%      +1.1        2.21 ±  3%  perf-profile.children.cycles-pp.btrfs_async_run_delayed_root
      0.47 ±  7%      +1.1        1.62 ±  4%  perf-profile.children.cycles-pp.handle_softirqs
      0.00            +1.2        1.24 ±  4%  perf-profile.children.cycles-pp.btrfs_inhibit_eb_writeback
      0.00            +1.3        1.31 ±  3%  perf-profile.children.cycles-pp.xas_find
      3.27 ±  3%      +1.6        4.89        perf-profile.children.cycles-pp.btrfs_work_helper
      0.00            +2.3        2.28 ±  3%  perf-profile.children.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.12 ±  6%      +2.3        2.40 ±  2%  perf-profile.children.cycles-pp.__btrfs_end_transaction
      1.93 ± 10%      -0.6        1.32 ± 11%  perf-profile.self.cycles-pp.mutex_spin_on_owner
      3.90 ± 15%      -0.6        3.32 ±  2%  perf-profile.self.cycles-pp.brd_rw_bvec
      3.18 ± 10%      -0.4        2.82        perf-profile.self.cycles-pp.__pi_memcpy
      0.34 ± 11%      -0.1        0.26 ±  8%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.97 ±  2%      -0.0        0.92 ±  2%  perf-profile.self.cycles-pp.btrfs_bin_search
      0.12 ±  5%      -0.0        0.10 ±  8%  perf-profile.self.cycles-pp.btrfs_get_16
      0.12 ±  5%      -0.0        0.10 ±  8%  perf-profile.self.cycles-pp.set_extent_buffer_dirty
      0.08 ± 13%      +0.0        0.10 ± 11%  perf-profile.self.cycles-pp.rwsem_down_write_slowpath
      0.10 ±  7%      +0.0        0.14 ± 12%  perf-profile.self.cycles-pp.update_sg_lb_stats
      0.06 ± 13%      +0.0        0.10 ± 14%  perf-profile.self.cycles-pp.xas_store
      0.00            +0.1        0.06 ± 11%  perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.00            +0.1        0.06 ± 13%  perf-profile.self.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.08 ±  8%      +0.1        0.16 ±  3%  perf-profile.self.cycles-pp.free_extent_buffer
      0.00            +0.1        0.07 ± 11%  perf-profile.self.cycles-pp.kmem_cache_alloc_lru_noprof
      0.00            +0.1        0.10 ± 10%  perf-profile.self.cycles-pp.rcu_do_batch
      0.00            +0.1        0.10 ± 10%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.00            +0.1        0.13 ±  9%  perf-profile.self.cycles-pp.__call_rcu_common
      0.94 ±  4%      +0.1        1.07 ±  3%  perf-profile.self.cycles-pp.xas_load
      0.00            +0.1        0.13 ±  7%  perf-profile.self.cycles-pp.btrfs_inhibit_eb_writeback
      0.00            +0.2        0.22 ±  7%  perf-profile.self.cycles-pp.radix_tree_node_rcu_free
      0.00            +0.3        0.25 ±  5%  perf-profile.self.cycles-pp.xas_create
      0.02 ±141%      +0.3        0.27 ±  5%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.25 ±  5%      +0.3        0.53 ±  4%  perf-profile.self.cycles-pp.kmem_cache_free
      0.12 ± 19%      +0.4        0.55 ±  4%  perf-profile.self.cycles-pp.__refill_objects_node
      0.00            +0.6        0.60 ±  4%  perf-profile.self.cycles-pp.xas_free_nodes
      0.00            +1.2        1.24 ±  2%  perf-profile.self.cycles-pp.xas_find



***************************************************************************************************

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/sync/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic

commit: 
  ed7bc52711 ("btrfs: extract the max compression chunk size into a macro")
  f9d138838a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

ed7bc52711022142 f9d138838a78bf2a5263ad3c1d3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.89 ±  2%      +1.0        1.89 ±  7%  fio.latency_1000us%
      0.03 ±  6%      +0.0        0.05 ± 11%  fio.latency_100ms%
      0.01            +0.0        0.02 ± 12%  fio.latency_250ms%
      0.32 ±  3%      +0.1        0.42 ±  6%  fio.latency_2ms%
      0.05 ±  7%      +0.0        0.06 ±  5%  fio.latency_4ms%
      0.05            +0.0        0.05 ±  3%  fio.latency_500ms%
   3865002            -7.4%    3579840        fio.time.file_system_outputs
    570083            -5.0%     541708        fio.time.voluntary_context_switches
    483125            -7.4%     447480        fio.workload
      6.29            -7.4%       5.82        fio.write_bw_MBps
    451925            +2.9%     464896        fio.write_clat_95%_ns
   1471829           +28.2%    1886890 ± 15%  fio.write_clat_99%_ns
    620355            +8.0%     670119        fio.write_clat_mean_ns
   9919039            +3.0%   10218735        fio.write_clat_stddev
      1609            -7.4%       1490        fio.write_iops
      1.66            +8.0%       1.79        iostat.cpu.iowait
    145.17 ± 13%     -27.2%     105.67 ± 17%  perf-c2c.DRAM.local
      0.99            +6.9%       1.06        turbostat.IPC
      1.67            +0.1        1.80        mpstat.cpu.all.iowait%
      0.00 ±  6%      +0.0        0.01 ±  7%  mpstat.cpu.all.soft%
      0.15 ±  3%      +0.0        0.16 ±  3%  mpstat.cpu.all.sys%
     11959           +46.9%      17567 ±  4%  vmstat.io.bo
   4278391            +5.0%    4490659        vmstat.memory.cache
      1.06            +8.0%       1.15        vmstat.procs.b
     11633            -3.2%      11258        vmstat.system.cs
 1.556e+08 ±  5%     +10.6%  1.721e+08 ±  4%  perf-stat.i.branch-instructions
    502335 ±  7%     +15.0%     577499 ±  7%  perf-stat.i.cache-misses
   3737605 ±  2%      +7.3%    4009808 ±  2%  perf-stat.i.cache-references
     11695            -3.3%      11304        perf-stat.i.context-switches
      1.03            -9.5%       0.93        perf-stat.i.cpi
 8.222e+08 ±  5%     +11.0%  9.127e+08 ±  4%  perf-stat.i.instructions
      1.06           +12.9%       1.20        perf-stat.i.ipc
      1.06            -6.5%       0.99        perf-stat.overall.cpi
      1746 ±  3%      -9.7%       1577 ±  3%  perf-stat.overall.cycles-between-cache-misses
      0.94            +7.0%       1.01        perf-stat.overall.ipc
    512147 ±  5%     +19.9%     614104 ±  5%  perf-stat.overall.path-length
 1.552e+08 ±  5%     +10.6%  1.717e+08 ±  4%  perf-stat.ps.branch-instructions
    500755 ±  7%     +15.0%     575704 ±  7%  perf-stat.ps.cache-misses
   3728960 ±  2%      +7.3%    4000930 ±  2%  perf-stat.ps.cache-references
     11657            -3.3%      11267        perf-stat.ps.context-switches
 8.201e+08 ±  5%     +11.0%  9.105e+08 ±  4%  perf-stat.ps.instructions
 2.474e+11 ±  5%     +11.0%  2.747e+11 ±  4%  perf-stat.total.instructions
     20.76 ±  4%      -1.8       19.01 ±  5%  perf-profile.calltrace.cycles-pp.asm_sysvec_call_function_single.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
      1.03 ±  7%      -0.2        0.80 ± 14%  perf-profile.calltrace.cycles-pp.btrfs_lookup_csums_list.can_nocow_file_extent.run_delalloc_nocow.writepage_delalloc.extent_writepage
      1.02 ± 10%      -0.2        0.82 ± 22%  perf-profile.calltrace.cycles-pp.push_leaf_right.split_leaf.btrfs_search_slot.btrfs_insert_empty_items.btrfs_insert_data_csums
      0.95 ±  9%      -0.2        0.78 ± 16%  perf-profile.calltrace.cycles-pp.btrfs_get_32.setup_items_for_insert.btrfs_insert_empty_items.btrfs_insert_data_csums.btrfs_finish_one_ordered
      1.24 ±  4%      +0.3        1.50 ±  7%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt
      1.17 ±  4%      +0.3        1.46 ±  7%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt
      0.63 ±  9%      +0.3        0.96 ±  6%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +0.6        0.57 ± 10%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.18 ±141%      +0.6        0.81 ±  4%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +0.7        0.70 ± 24%  perf-profile.calltrace.cycles-pp.xas_free_nodes.xa_destroy.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered
      0.00            +0.7        0.73 ± 23%  perf-profile.calltrace.cycles-pp.xa_destroy.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper
     10.75 ±  3%      +0.7       11.50 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
      0.00            +0.9        0.86 ± 18%  perf-profile.calltrace.cycles-pp.xas_find.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered
      0.00            +0.9        0.89 ± 20%  perf-profile.calltrace.cycles-pp.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper
      0.00            +2.0        1.96 ± 17%  perf-profile.calltrace.cycles-pp.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work
      0.00            +2.0        2.00 ± 17%  perf-profile.calltrace.cycles-pp.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread
     12.30 ±  5%      -0.9       11.42 ±  5%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      1.03 ±  7%      -0.2        0.80 ± 14%  perf-profile.children.cycles-pp.btrfs_lookup_csums_list
      0.32 ± 30%      -0.1        0.18 ± 26%  perf-profile.children.cycles-pp.lapic_next_deadline
      0.42 ± 13%      -0.1        0.28 ± 35%  perf-profile.children.cycles-pp.release_extent_buffer
      0.29 ±  5%      -0.1        0.20 ± 39%  perf-profile.children.cycles-pp.alloc_ordered_extent
      0.22 ± 17%      -0.1        0.13 ± 31%  perf-profile.children.cycles-pp.lru_add
      0.22 ± 26%      -0.1        0.15 ± 29%  perf-profile.children.cycles-pp.update_cfs_rq_load_avg
      0.15 ± 38%      -0.1        0.07 ± 54%  perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.18 ± 26%      +0.1        0.27 ± 21%  perf-profile.children.cycles-pp.refill_objects
      0.10 ± 43%      +0.1        0.22 ± 22%  perf-profile.children.cycles-pp.__refill_objects_node
      0.16 ± 21%      +0.1        0.28 ± 17%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.10 ± 41%      +0.1        0.22 ± 30%  perf-profile.children.cycles-pp.xa_find
      0.81 ± 12%      +0.2        0.97 ±  4%  perf-profile.children.cycles-pp.kmem_cache_free
      0.39 ± 19%      +0.2        0.57 ± 19%  perf-profile.children.cycles-pp.xas_alloc
      0.34 ± 24%      +0.2        0.54 ± 19%  perf-profile.children.cycles-pp.kmem_cache_alloc_lru_noprof
      2.11 ±  5%      +0.3        2.41 ±  7%  perf-profile.children.cycles-pp.handle_softirqs
      0.72 ± 10%      +0.3        1.06 ± 10%  perf-profile.children.cycles-pp.rcu_core
      0.54 ± 13%      +0.4        0.90 ±  9%  perf-profile.children.cycles-pp.rcu_do_batch
      0.47 ± 21%      +0.4        0.88 ± 20%  perf-profile.children.cycles-pp.xas_create
      0.00            +0.5        0.45 ± 32%  perf-profile.children.cycles-pp.__xa_store
      0.01 ±223%      +0.5        0.52 ± 21%  perf-profile.children.cycles-pp.xa_store
      0.00            +0.7        0.72 ± 23%  perf-profile.children.cycles-pp.xas_free_nodes
      0.00            +0.7        0.74 ± 23%  perf-profile.children.cycles-pp.xa_destroy
      0.00            +0.7        0.74 ± 11%  perf-profile.children.cycles-pp.btrfs_inhibit_eb_writeback
      0.00            +0.9        0.90 ± 21%  perf-profile.children.cycles-pp.xa_find_after
      0.06 ± 23%      +2.0        2.01 ± 17%  perf-profile.children.cycles-pp.__btrfs_end_transaction
      0.00            +2.0        1.97 ± 17%  perf-profile.children.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.87 ± 11%      -0.2        0.63 ± 11%  perf-profile.self.cycles-pp.find_extent_buffer
      0.32 ± 30%      -0.1        0.18 ± 26%  perf-profile.self.cycles-pp.lapic_next_deadline
      0.29 ± 12%      -0.1        0.17 ± 35%  perf-profile.self.cycles-pp.release_extent_buffer
      0.17 ± 34%      -0.1        0.06 ±113%  perf-profile.self.cycles-pp.refresh_cpu_vm_stats
      0.13 ± 30%      -0.1        0.04 ±109%  perf-profile.self.cycles-pp.___perf_sw_event
      0.14 ± 39%      -0.1        0.07 ± 54%  perf-profile.self.cycles-pp.__update_load_avg_cfs_rq
      0.10 ± 43%      +0.1        0.21 ± 22%  perf-profile.self.cycles-pp.__refill_objects_node
      0.04 ± 72%      +0.2        0.22 ± 19%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.07 ± 62%      +0.2        0.25 ± 46%  perf-profile.self.cycles-pp.xas_create
      0.00            +0.6        0.55 ± 21%  perf-profile.self.cycles-pp.xas_free_nodes
      0.02 ±144%      +1.0        1.00 ± 21%  perf-profile.self.cycles-pp.xas_find



***************************************************************************************************

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/vsync/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic

commit: 
  ed7bc52711 ("btrfs: extract the max compression chunk size into a macro")
  f9d138838a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

ed7bc52711022142 f9d138838a78bf2a5263ad3c1d3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.89            +0.9        1.83 ± 12%  fio.latency_1000us%
      0.03 ±  4%      +0.0        0.05 ± 14%  fio.latency_100ms%
      0.11 ±  6%      +0.0        0.13 ±  8%  fio.latency_10ms%
      0.01            +0.0        0.02 ± 13%  fio.latency_250ms%
      0.31 ±  4%      +0.1        0.41 ±  5%  fio.latency_2ms%
     37.86 ±  2%      -1.7       36.12 ±  2%  fio.latency_500us%
   3854986            -6.8%    3593881        fio.time.file_system_outputs
    567967            -4.4%     543118        fio.time.voluntary_context_switches
    481873            -6.8%     449235        fio.workload
      6.27            -6.8%       5.85        fio.write_bw_MBps
    453290            +2.6%     464896        fio.write_clat_95%_ns
   1466368 ±  2%     +22.6%    1798144 ± 12%  fio.write_clat_99%_ns
    622174            +7.3%     667670        fio.write_clat_mean_ns
   9947977            +3.0%   10249056        fio.write_clat_stddev
      1605            -6.8%       1496        fio.write_iops
      1.65            +7.1%       1.77        iostat.cpu.iowait
    144.00 ± 16%     -35.1%      93.50 ± 37%  perf-c2c.DRAM.local
      0.36 ±  6%      +0.0        0.39 ±  5%  turbostat.Busy%
      1.66            +0.1        1.78 ±  2%  mpstat.cpu.all.iowait%
      0.01 ± 10%      +0.0        0.01 ±  3%  mpstat.cpu.all.soft%
      0.15 ±  3%      +0.0        0.16 ±  3%  mpstat.cpu.all.sys%
     11889           +45.8%      17333 ±  6%  vmstat.io.bo
      1.07            +6.5%       1.14 ±  2%  vmstat.procs.b
     11603            -2.9%      11267        vmstat.system.cs
 1.559e+08 ±  5%     +14.4%  1.784e+08 ±  5%  perf-stat.i.branch-instructions
    503477 ±  9%     +22.1%     614867 ±  8%  perf-stat.i.cache-misses
   3748321 ±  2%      +9.6%    4107956 ±  2%  perf-stat.i.cache-references
     11658            -2.9%      11315        perf-stat.i.context-switches
      1.03            -8.8%       0.94        perf-stat.i.cpi
 8.761e+08 ±  6%      +8.0%  9.462e+08 ±  5%  perf-stat.i.cpu-cycles
 8.236e+08 ±  5%     +14.5%  9.433e+08 ±  5%  perf-stat.i.instructions
      1.06           +11.7%       1.18        perf-stat.i.ipc
      1.06            -5.7%       1.00        perf-stat.overall.cpi
      1748 ±  3%     -11.6%       1545 ±  3%  perf-stat.overall.cycles-between-cache-misses
      0.94            +6.0%       1.00        perf-stat.overall.ipc
    514394 ±  5%     +23.1%     632989 ±  7%  perf-stat.overall.path-length
 1.555e+08 ±  5%     +14.4%  1.779e+08 ±  5%  perf-stat.ps.branch-instructions
    501891 ±  9%     +22.1%     612976 ±  8%  perf-stat.ps.cache-misses
   3739078 ±  2%      +9.6%    4097784 ±  2%  perf-stat.ps.cache-references
     11620            -2.9%      11278        perf-stat.ps.context-switches
 8.748e+08 ±  6%      +8.0%  9.448e+08 ±  5%  perf-stat.ps.cpu-cycles
 8.215e+08 ±  5%     +14.5%  9.409e+08 ±  5%  perf-stat.ps.instructions
 2.478e+11 ±  5%     +14.6%   2.84e+11 ±  5%  perf-stat.total.instructions
      1.38 ± 48%      -0.5        0.84 ± 16%  perf-profile.calltrace.cycles-pp.prepare_one_folio.copy_one_range.btrfs_buffered_write.btrfs_direct_write.btrfs_do_write_iter
      0.66 ± 14%      +0.4        1.05 ± 16%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.31 ±100%      +0.6        0.89 ± 19%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      3.33 ± 11%      +0.7        4.06 ± 10%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry
      0.00            +0.8        0.77 ± 18%  perf-profile.calltrace.cycles-pp.xas_free_nodes.xa_destroy.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered
      0.00            +0.8        0.78 ± 17%  perf-profile.calltrace.cycles-pp.xa_destroy.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper
      0.00            +0.8        0.85 ± 26%  perf-profile.calltrace.cycles-pp.xas_find.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered
      0.00            +0.9        0.89 ± 27%  perf-profile.calltrace.cycles-pp.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper
      0.00            +2.1        2.09 ± 20%  perf-profile.calltrace.cycles-pp.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work
      0.00            +2.1        2.14 ± 19%  perf-profile.calltrace.cycles-pp.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread
      1.38 ± 48%      -0.5        0.84 ± 16%  perf-profile.children.cycles-pp.prepare_one_folio
      1.03 ± 16%      -0.3        0.72 ± 34%  perf-profile.children.cycles-pp.copy_extent_buffer_full
      0.28 ± 15%      -0.1        0.15 ± 31%  perf-profile.children.cycles-pp.set_next_task_fair
      0.16 ± 53%      -0.1        0.06 ± 62%  perf-profile.children.cycles-pp.refresh_cpu_vm_stats
      0.13 ± 14%      -0.0        0.08 ± 25%  perf-profile.children.cycles-pp.igrab
      0.05 ±114%      +0.1        0.18 ± 41%  perf-profile.children.cycles-pp.__refill_objects_node
      0.16 ± 36%      +0.2        0.31 ± 36%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.01 ±223%      +0.3        0.29 ± 40%  perf-profile.children.cycles-pp.xa_find
      0.22 ± 24%      +0.3        0.52 ± 77%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.61 ± 17%      +0.4        1.03 ± 15%  perf-profile.children.cycles-pp.rcu_do_batch
      0.75 ± 13%      +0.5        1.21 ± 13%  perf-profile.children.cycles-pp.rcu_core
      0.02 ±149%      +0.5        0.50 ± 24%  perf-profile.children.cycles-pp.__xa_store
      0.04 ±101%      +0.5        0.56 ± 23%  perf-profile.children.cycles-pp.xa_store
      3.52 ± 11%      +0.7        4.24 ±  9%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.00            +0.8        0.78 ± 18%  perf-profile.children.cycles-pp.xas_free_nodes
      0.00            +0.8        0.80 ± 18%  perf-profile.children.cycles-pp.xa_destroy
      0.00            +0.8        0.84 ± 21%  perf-profile.children.cycles-pp.btrfs_inhibit_eb_writeback
      0.00            +0.9        0.90 ± 28%  perf-profile.children.cycles-pp.xa_find_after
      0.69 ± 46%      +0.9        1.62 ± 20%  perf-profile.children.cycles-pp.xas_find
      0.00            +2.1        2.10 ± 20%  perf-profile.children.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.02 ±144%      +2.1        2.16 ± 19%  perf-profile.children.cycles-pp.__btrfs_end_transaction
      2.78 ±  4%      -0.3        2.51 ±  8%  perf-profile.self.cycles-pp._raw_spin_lock
      0.27 ± 21%      -0.1        0.19 ± 23%  perf-profile.self.cycles-pp.irqentry_enter
      0.18 ± 25%      -0.1        0.10 ± 36%  perf-profile.self.cycles-pp._raw_read_lock
      0.08 ± 12%      +0.1        0.16 ± 41%  perf-profile.self.cycles-pp.xas_store
      0.10 ± 22%      +0.1        0.22 ± 20%  perf-profile.self.cycles-pp.xas_create
      0.00            +0.1        0.12 ± 30%  perf-profile.self.cycles-pp.btrfs_inhibit_eb_writeback
      0.36 ± 16%      +0.1        0.51 ± 22%  perf-profile.self.cycles-pp.kmem_cache_free
      0.10 ± 40%      +0.1        0.24 ± 35%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.02 ±144%      +0.2        0.17 ± 32%  perf-profile.self.cycles-pp.__call_rcu_common
      0.00            +0.6        0.61 ± 22%  perf-profile.self.cycles-pp.xas_free_nodes
      0.01 ±223%      +1.1        1.08 ± 25%  perf-profile.self.cycles-pp.xas_find



***************************************************************************************************

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/ftruncate/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic

commit: 
  ed7bc52711 ("btrfs: extract the max compression chunk size into a macro")
  f9d138838a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

ed7bc52711022142 f9d138838a78bf2a5263ad3c1d3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.05 ± 38%      +0.4        0.41 ±  9%  fio.latency_10us%
      0.01 ± 70%      +0.0        0.03 ±  9%  fio.latency_250us%
     99.84           -47.3       52.50 ±  6%  fio.latency_2us%
      0.11 ± 18%     +46.9       47.04 ±  7%  fio.latency_4us%
     58.71           +27.9%      75.08        fio.time.elapsed_time
     58.71           +27.9%      75.08        fio.time.elapsed_time.max
    444.67 ±  3%   +2993.8%      13757 ±  9%  fio.time.involuntary_context_switches
    101.00            -3.0%      98.00        fio.time.percent_of_cpu_this_job_got
     46.25           +29.8%      60.03        fio.time.system_time
      6247           +27.8%       7981        fio.time.voluntary_context_switches
      2248           -21.9%       1754        fio.write_bw_MBps
      1560           +38.1%       2154        fio.write_clat_90%_ns
      1570           +42.6%       2240        fio.write_clat_95%_ns
      1616           +93.7%       3130        fio.write_clat_99%_ns
      1477           +32.4%       1956        fio.write_clat_mean_ns
    357.00 ± 26%    +802.8%       3223 ±  3%  fio.write_clat_stddev
    575507           -21.9%     449271        fio.write_iops
      1876           +15.3%       2162        vmstat.system.cs
 3.782e+09           +27.4%  4.816e+09        cpuidle..time
    134072 ±  3%     +51.1%     202619 ±  3%  cpuidle..usage
      0.00 ± 10%      +0.0        0.02 ±  9%  mpstat.cpu.all.soft%
      0.95 ±  5%      -0.2        0.74 ±  9%  mpstat.cpu.all.usr%
     32.78 ± 44%   +4925.0%       1647 ± 67%  perf-sched.total_wait_time.max.ms
     32.78 ± 44%   +4925.0%       1647 ± 67%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      1.52            +7.3%       1.63        turbostat.IPC
    231880 ±  2%     +36.3%     316138        turbostat.IRQ
    107.88           +16.4%     125.57 ±  2%  uptime.boot
      6556           +17.0%       7669 ±  2%  uptime.idle
      1.29 ±  7%      -0.3        1.01 ± 10%  perf-stat.i.branch-miss-rate%
      8.37 ± 16%      -6.0        2.37 ±  7%  perf-stat.i.cache-miss-rate%
   6027778 ±  6%    +205.8%   18432463 ±  2%  perf-stat.i.cache-references
      1680           +19.0%       1999 ±  2%  perf-stat.i.context-switches
      0.64            -7.0%       0.60        perf-stat.i.cpi
 6.085e+09 ±  3%      -9.4%  5.513e+09 ±  4%  perf-stat.i.cpu-cycles
     71.62           +10.6%      79.18 ±  3%  perf-stat.i.cpu-migrations
     61976 ± 54%     -57.1%      26570 ±  4%  perf-stat.i.cycles-between-cache-misses
      1.70            +6.4%       1.81        perf-stat.i.ipc
      9.32 ±  7%      -6.5        2.82 ±  9%  perf-stat.overall.cache-miss-rate%
      0.66            -6.8%       0.62        perf-stat.overall.cpi
      1.51            +7.3%       1.62        perf-stat.overall.ipc
     16259           +23.8%      20127 ±  2%  perf-stat.overall.path-length
   5940856 ±  6%    +206.4%   18200387 ±  2%  perf-stat.ps.cache-references
      1652           +19.4%       1973 ±  2%  perf-stat.ps.context-switches
  5.99e+09 ±  3%      -9.1%  5.446e+09 ±  4%  perf-stat.ps.cpu-cycles
     70.46           +10.9%      78.15 ±  3%  perf-stat.ps.cpu-migrations
 5.456e+11           +23.8%  6.754e+11 ±  2%  perf-stat.total.instructions
     12.96 ± 59%      -9.6        3.35 ±119%  perf-profile.calltrace.cycles-pp.getdents64
     11.76 ± 46%      -8.4        3.35 ±119%  perf-profile.calltrace.cycles-pp.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe.getdents64
     11.76 ± 46%      -8.4        3.35 ±119%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.getdents64
     11.76 ± 46%      -8.4        3.35 ±119%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.getdents64
     11.76 ± 46%      -8.4        3.35 ±119%  perf-profile.calltrace.cycles-pp.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe.getdents64
     11.76 ± 46%      -8.4        3.35 ±119%  perf-profile.calltrace.cycles-pp.proc_pid_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.91 ± 54%      -5.2        1.67 ±223%  perf-profile.calltrace.cycles-pp.proc_reg_read_iter.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.91 ± 54%      -5.2        1.67 ±223%  perf-profile.calltrace.cycles-pp.seq_read_iter.proc_reg_read_iter.vfs_read.ksys_read.do_syscall_64
      5.51 ± 73%      -4.7        0.83 ±223%  perf-profile.calltrace.cycles-pp.handle_internal_command.main
      5.51 ± 73%      -4.7        0.83 ±223%  perf-profile.calltrace.cycles-pp.main
      5.51 ± 73%      -4.7        0.83 ±223%  perf-profile.calltrace.cycles-pp.run_builtin.handle_internal_command.main
      4.63 ± 72%      -4.6        0.00        perf-profile.calltrace.cycles-pp.__evlist__enable.cmd_record.cmd_sched.run_builtin.handle_internal_command
      4.63 ± 72%      -4.6        0.00        perf-profile.calltrace.cycles-pp.cmd_record.cmd_sched.run_builtin.handle_internal_command.main
      4.63 ± 72%      -4.6        0.00        perf-profile.calltrace.cycles-pp.cmd_sched.run_builtin.handle_internal_command.main
      6.18 ± 85%      -4.4        1.76 ±141%  perf-profile.calltrace.cycles-pp.next_tgid.proc_pid_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64
      4.70 ±112%      -4.0        0.67 ±223%  perf-profile.calltrace.cycles-pp.proc_fill_cache.proc_pid_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64
      4.59 ± 73%      -3.8        0.83 ±223%  perf-profile.calltrace.cycles-pp.arch_show_interrupts.seq_read_iter.proc_reg_read_iter.vfs_read.ksys_read
      4.74 ± 73%      -2.8        1.97 ±141%  perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range
      3.31 ±103%      -1.8        1.50 ±142%  perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     12.96 ± 59%      -9.6        3.35 ±119%  perf-profile.children.cycles-pp.getdents64
     11.76 ± 46%      -8.4        3.35 ±119%  perf-profile.children.cycles-pp.__x64_sys_getdents64
     11.76 ± 46%      -8.4        3.35 ±119%  perf-profile.children.cycles-pp.iterate_dir
     11.76 ± 46%      -8.4        3.35 ±119%  perf-profile.children.cycles-pp.proc_pid_readdir
      5.51 ± 73%      -5.5        0.00        perf-profile.children.cycles-pp.__evlist__enable
      6.91 ± 54%      -5.2        1.67 ±223%  perf-profile.children.cycles-pp.proc_reg_read_iter
      5.51 ± 73%      -4.7        0.83 ±223%  perf-profile.children.cycles-pp.cmd_record
      5.51 ± 73%      -4.7        0.83 ±223%  perf-profile.children.cycles-pp.handle_internal_command
      5.51 ± 73%      -4.7        0.83 ±223%  perf-profile.children.cycles-pp.main
      5.51 ± 73%      -4.7        0.83 ±223%  perf-profile.children.cycles-pp.run_builtin
      4.63 ± 72%      -4.6        0.00        perf-profile.children.cycles-pp.cmd_sched
      6.18 ± 85%      -4.4        1.76 ±141%  perf-profile.children.cycles-pp.next_tgid
      5.06 ±115%      -4.1        0.93 ±223%  perf-profile.children.cycles-pp.d_alloc_parallel
      4.70 ±112%      -4.0        0.67 ±223%  perf-profile.children.cycles-pp.proc_fill_cache
      4.80 ±116%      -4.0        0.76 ±223%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      4.59 ± 73%      -3.8        0.83 ±223%  perf-profile.children.cycles-pp.arch_show_interrupts
      3.62 ±101%      -2.0        1.67 ±223%  perf-profile.children.cycles-pp.its_return_thunk
     31.46 ± 27%     +14.7       46.18 ± 19%  perf-profile.children.cycles-pp.do_exit
     31.46 ± 27%     +14.7       46.18 ± 19%  perf-profile.children.cycles-pp.do_group_exit





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

