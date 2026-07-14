Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C5C3F4107;
	Tue, 14 Jul 2026 07:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784015973; cv=fail; b=XoXbSAIDKgeDxOoJSYEvzSKmEI2MwkPCrpo7A7JAXrb90uMdPI/LoBBCvuZpcZ8Ki1k+wDlPETIcSkwGr4rogci0jIOCyr9kZ6V5BwNA+lpyjnSd+AVNraWBf9HrVjk0X6WDjkTMs+qtZdjZ3aVkTvIhXyzeJPcxxhj0LDSWbUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784015973; c=relaxed/simple;
	bh=/wT2UQl8NcG+pEX3vDqezgJJCBAVX3uCGmR7anPmQD0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=edWHdcL7+vgtWiUx6I3Clm62D5OPyZMZMfWLjO/1wVJ9wujjKBDvJ8+y9UihdY5zmao+ZB7Oa4d48mdxR5R6eTB0jVoi7jsQsj4QgQggK/CQWLEbg8TU3vMxMIMbMihgR6sOBNaodKm08OuFM8ZNjEZMuBu30+b7wPT0pngDBNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gr9P/Val; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gr9P/Val"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784015971; x=1815551971;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=/wT2UQl8NcG+pEX3vDqezgJJCBAVX3uCGmR7anPmQD0=;
  b=gr9P/Valk335dUsr7/RCjOFdp5zLN/+egSJbJtPnKDHrxY2RaiHP470M
   CS6TH9D7ClLcrSIReTjDT3fNj3c3qmNIuh+91bRKj2QesfM2R8XSXufvx
   AJk2w3fD2ETCBVpclPpYI6v1ZEisZ6KOe0aFjleLmAIkm5gXUIr5IKj99
   S9TU7acKcDaALuRRLUmH7ccceoEtIdRb7QWVYqSWTxR337H7toMBEZ9re
   4kesfSCatEpRxTPnV9d3FM7N83ukwXFY5hHKYEZ4H/pNj252sBKWTotkn
   4zw5ocasH7zJvB4PNNal7YEyox1h18IaNn3pDGxnd6t2kaZ/4TC5QDPSz
   g==;
X-CSE-ConnectionGUID: eIpElbRMRROo1mUwbLrm2A==
X-CSE-MsgGUID: ugj9lHWATzGR+h+ZYgjW2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88454384"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88454384"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 00:59:28 -0700
X-CSE-ConnectionGUID: abxi90pGQP6Zlvv+QbYbNw==
X-CSE-MsgGUID: DO+tfN7UT0+/XbDrRO0EVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="257756185"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 00:59:25 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 00:59:24 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 00:59:24 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.40) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 00:59:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jFXoiqjAT5i86+J4V7bJoO+6l+w5NrBz3d8+teg/sL1k9rctMxoeW+wBJu+jTJgcoCYsj4uOFFJ6lfg/a9mn9yHXPN1fctmLipA+5W6RH0/x0fkAUBzepWqMsJjRkzL3f1bMLnJFYjpaiJEQLWZlHa3Vu8gPJQOFyHrV5NMn3NinszuVK1GrQZAN3CglVo4bI5BaF3Yr8lxMO8QQW+Zcw4Qs3bLnnqZJa6gQLfgvGxM8heniFhzlDnEWfCq35uH5QMNudBdm+XiNsiumZIVCT8Fi5dDrNdF4fcRFM6BfDPJ4D50EZEQXl8au4gAo3abq2vz//JAOGkdc2YdtLH848w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6HVEuRP4mFQcDptRBXwGdRuD5c5J9kqX2t/HDrnl8U=;
 b=vUnN0ssOCPOayFViA7RkW6nAqY46Ket1biwsfltwHwvqYmHjIsU2aoRCOfXvSbwzAwQ2oOrAyX44eT7eT2IT+izHBikbSGdarGsw9rDlYNYW9NnpUfFqPrA0Nl1Q+vOvNN3gIt+pNzbHZLMfLHIMUhsk4o0XleLO/pwGj4CV2UaOYfRqhFfcLREEbFuyTisD6JWBzgxL3gqEHK4JCUl7Oa19Iz+zeV+4vlIhUmo1QbQroasBpPp4RWqHzdKAS4zrB4ElQrCJWoae57X5kGGgx82nDGb3lHoFlWK0uPv1ABKzVD4oEeH9i0UycbtXz4lIiHFXXp+1L0YPQ8Uualh3hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DSWPR11MB9930.namprd11.prod.outlook.com (2603:10b6:8:3a0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Tue, 14 Jul
 2026 07:59:23 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 07:59:23 +0000
Date: Tue, 14 Jul 2026 15:59:15 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Filipe Manana <fdmanana@suse.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Aleksandar Gerasimovski
	<Aleksandar.Gerasimovski@belden.com>, Qu Wenruo <wqu@suse.com>,
	<linux-btrfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [btrfs]  574d93fc62: stress-ng.dirdeep.ops_per_sec
 25.9% regression
Message-ID: <202607141457.e5af425c-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KL1PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::7) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DSWPR11MB9930:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff3763e-8be6-4237-edcf-08dee17dd11d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|5023799004|3023799007|18002099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info: aPx0LHRI6yB6rlNnC3PJ92MudbkEcyuMtRzKMr6vLYO08kIWGrNLCZDH9ypEP1XXGN08g/z4VldjJTyeXvD3Hm2pWqvZhczntIcjb2efIohtMto6E5eWxFFX95RYZbIf/rLES0/hJxUX1zI843R2kQEVbcRrbwCL7vt+0u3PYkk2d8YZp0UzWN1Zar6AX1nm28eFjb1KKjugJMmgVqrorCDjsPc+tPXnNnWOOgo5xexQYaWH9Q2VKIOUreSWKFyAcEh0B4qWCwsHi8EGOJzYAzefWh2LuRC2PSNWGFPtZzeklizZoyk1iVtK8BvheOCR2iHXXpos5rUPwGhxkKwi30aFT3ZhOMPtFKe/Su1Eref2A/ycveOQnbrnGvqaJ+M49V8mM+74I+1AYIZH8Xf5StpdZCHIUuEkJFdJrIh08Gp6ugx1zWMchYRif1voK0ingidaj6wycupPta4cE2r5pvZtk11+w8k+IkKEJIpVJToxOWBqVTfy3Rc6C7PvEZ2kl2bbM+JHMAgzfeNI4MGI6qw7vYiSVbynYZBuOUsYBei/txc6f5vhb+5eXVPiNc/UXrorHlfqdPWPg1lqLDHeMvF7OhVSTwDLr8Jwh0GShCYClFgavuIAaN5S/cXhO7cT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(5023799004)(3023799007)(18002099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?yNd3uzMnHL2NuuAWvXQXJP+F9kXy3uWue1kuww2tJXt+XfNZh0wKW1AoaT?=
 =?iso-8859-1?Q?VU9s8DTobBwyZwVzI0cAp6aNOyLMSevcL8g26A0LfL5xLOnY79oz1TBdr4?=
 =?iso-8859-1?Q?3LHxQ/4qgWblAWiz+6qG7qP0+keY/t8BAnc1l6HLgYyeESqnpDgF38tOEA?=
 =?iso-8859-1?Q?Hq3SAREUATbcd8IhrucQw6qrH74JR8WEycFfEkMD6llwSUvmzol7X/E8ga?=
 =?iso-8859-1?Q?JUxJlT43moqv7HMFEIk/iXrCs4XAe9GxxF6zxIuAfgBMoKw0f+2jPfK9S6?=
 =?iso-8859-1?Q?N9n1WbnkvPwDZiCmxsz+ebvtXUFuQT3Q+d8BJePfZcDiSsjygr1OFM1O0S?=
 =?iso-8859-1?Q?hBLgxj5GmM1xZgu+VT0ZedY0aZgvqZSJkkzPPji8BsNVk5u/W0JmizfO0z?=
 =?iso-8859-1?Q?i5DP7Igc3VnGrIAeRGjNfbkXVBTzg65Gjc5elupfr2AeS/k8KLE09a0HCe?=
 =?iso-8859-1?Q?oaFY+SY+3V/A0s1lhlYGy8TDdQmXVS58IkBvMvFvkXPyM3tJjmyUvnTOz/?=
 =?iso-8859-1?Q?CapI15114JNXM6CjWWGn5d+jyNk1fKHkX41V/hUT23qjlUwwzjGvHn3GD+?=
 =?iso-8859-1?Q?U13aoaBqEAgstjBsX5VeXzv2wfZOKqgUFNzG39zXbRuXt27k0MKC1jn0C7?=
 =?iso-8859-1?Q?oxZpHwUswZK0OTxC1E6bLX94nqZ4+iLgAiNr0w+Hecy0fZAa7bGPmcS0AG?=
 =?iso-8859-1?Q?Jy38NOrkZBlmzW9iAzi1vYEuDYBIHOYB0XGDQ6QcCHCgOq83X2RxBbwrJn?=
 =?iso-8859-1?Q?1lqOLrdh3AR7ae6Xf3qEZb+T3MxS2QnvdC6OETCHTmDS6zYRFHBwO3f/ok?=
 =?iso-8859-1?Q?+8DBUUKEseuPyrGiJtXxGjck4templvYBGQFQLqeQN0DEOIk33BZTgSe1P?=
 =?iso-8859-1?Q?3uTbRPlJOMMD7rzTEpCoZ8BnJf8QZ7/LHCeOJ+nC/AC1ThT1R9/Y/xpzkC?=
 =?iso-8859-1?Q?90CreBzqgcD4UJybJ5OO12/LAK9XpLoxCLwWXwoBHaPDDfkbNUvU3E2Y3M?=
 =?iso-8859-1?Q?jOhVyiaS6gjFSfp4UDcwQIkGwmY3XFHvMbgC20GwuM8pdZOgIjrFEe59QS?=
 =?iso-8859-1?Q?kRfpfkMbkiUxGL5iPgp0AxQKYi1x2fVT4UPRHNRpMDqI0fwKT3hBjOXFUN?=
 =?iso-8859-1?Q?yg/Tp6we9Do7vAVUDT7ls4pryqpGYHJUSHMefJlkbQTv54praEPNVH1Ut8?=
 =?iso-8859-1?Q?8h6+JXbO5/nMZY6pxIzYe1TRIZUPUIM899fseOOXiNNiaZVA8y4bQ9PnVY?=
 =?iso-8859-1?Q?7ushThasNokXvm2I1hzBVPz0gi7GC80L03GJqn3wAxsgtfMpipHIpuBh7b?=
 =?iso-8859-1?Q?FcjC9iX6v/iRrDPfXMZNNnT60XyczIFLgpb+KcbZBTZFBZRYtVuP79g6a/?=
 =?iso-8859-1?Q?osotUf5DUWErjSLrMy843tAAjbDUzdlK6yACRQaHl3yldaCv83cFcHq/6p?=
 =?iso-8859-1?Q?47fu/8TIy7Pl4OPBkcgSL4zNUg86Z+lA4o9ay8yPlpX+nNrEMhopA2gist?=
 =?iso-8859-1?Q?M+hyF4kAi2Xt7ZVkqJBidbMKsjWQzXpxxiEjh6gwAe+V4Cgw38kIgH2mrN?=
 =?iso-8859-1?Q?mJnjexQ1zzWmZrnTAijlq+6KK4y18Md5Qo7EWRjFcY8Tm7X7EtXD1C6Tpb?=
 =?iso-8859-1?Q?qifFgO7WpqouuhnFy7qTonBC4a+/MwCn8QDWYD2fNW+o5WjmU529ldAuzL?=
 =?iso-8859-1?Q?7nDkWAZDzRRGRwjIMd0pUldmSAQbyoNXHqmVLWJn0Rb93qI1qDTVKzlRDc?=
 =?iso-8859-1?Q?SCcDsdj6un7LpwjzkaxSM17zD41Qjp97fJ+4tpXLsiE4bV3tAdxH85RD7c?=
 =?iso-8859-1?Q?gpkBnEEKVA=3D=3D?=
X-Exchange-RoutingPolicyChecked: M3jBp3P8CklOODkSmzQ+VhhXbcuzi2f+hbsQM3r/AsOFrbq5IpN5DjSLQ2TL98V0YJsSzxDW2giEpOT5L29O+akQ1pqhVXLK94WDOoRc3jqgOy1q2ND4JxKzWjobPetNHWxT4Lk1rmLjeaHSh5fbuHOORgEwdqaZCoQkGXyzVYkLBYwrxSR+9rpA2CSreZmpjdrLVN1csHo+xAC8m0iTKs02Y1FFzSNnJqoRHbpAiUN6IXpvKDozL4GHdu7YLWC2NS9Cwzoj8PRjjNrmNRTX9FhEgcD0dgP4EpjKbmWugS2DbDoSmat7iZpNJLMwXYQ3VF8Oi+b+TluVxHqgFXZcxQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff3763e-8be6-4237-edcf-08dee17dd11d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 07:59:22.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HfXq/m1mGPhum6lyc9Twd2LailRzcaNKZjHIVULjVMCvcseJg9Xjbfw2HjB4nQP9O6o/gNIJ9AlLcpFkizED/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9930
X-OriginatorOrg: intel.com


Hello,

kernel test robot noticed a 25.9% regression of stress-ng.dirdeep.ops_per_sec on:


commit: 574d93fc62e2b03ab39c8f92fb44ded89ca6274d ("btrfs: be less aggressive with metadata overcommit when we can do full flushing")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      f105f3631d51e8d7c49bf18ec21b873e4f38e648]
[still regression on linux-next/master 2b763db0c2763d6bf73d7d3e69665222d1f377cf]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 64G memory
parameters:

	nr_threads: 100%
	disk: 1SSD
	testtime: 60s
	fs: btrfs
	test: dirdeep
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+---------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.link.ops_per_sec  53.7% regression |
| test parameters  | cpufreq_governor=performance                            |
|                  | disk=1SSD                                               |
|                  | fs=btrfs                                                |
|                  | nr_threads=100%                                         |
|                  | test=link                                               |
|                  | testtime=60s                                            |
+------------------+---------------------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202607141457.e5af425c-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260714/202607141457.e5af425c-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/1SSD/btrfs/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/dirdeep/stress-ng/60s

commit: 
  2672a26a75 ("btrfs: use per-profile available space in calc_available_free_space()")
  574d93fc62 ("btrfs: be less aggressive with metadata overcommit when we can do full flushing")

2672a26a75517a2b 574d93fc62e2b03ab39c8f92fb4 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    117363 ±  2%     -16.1%      98491        stress-ng.dirdeep.ops
      1503 ±  2%     -25.9%       1114        stress-ng.dirdeep.ops_per_sec
     80.95           +11.1%      89.93        stress-ng.time.elapsed_time
     80.95           +11.1%      89.93        stress-ng.time.elapsed_time.max
    748101 ± 18%     -31.6%     511328        stress-ng.time.file_system_outputs
     96878            -2.1%      94808        stress-ng.time.minor_page_faults
    268.00 ±  3%     -31.8%     182.83 ±  2%  stress-ng.time.percent_of_cpu_this_job_got
    214.49 ±  2%     -25.2%     160.46 ±  2%  stress-ng.time.system_time
   2266976           +10.5%    2504029        stress-ng.time.voluntary_context_switches
      1.20 ±  2%     -21.4%       0.94 ±  2%  iostat.cpu.system
    164785 ±  3%      +4.8%     172650 ±  2%  numa-meminfo.node1.Shmem
    258.83 ±  5%     -11.7%     228.67 ±  9%  perf-c2c.HITM.local
 2.085e+10           +11.1%  2.317e+10        cpuidle..time
   5089937           +23.2%    6272862        cpuidle..usage
      7461           -48.1%       3870 ± 19%  sched_debug.cpu.nr_switches.min
      1604 ±  4%     +66.4%       2669 ±  5%  sched_debug.cpu.nr_switches.stddev
    363526            -5.8%     342356        meminfo.KReclaimable
    363526            -5.8%     342356        meminfo.SReclaimable
    173426 ±  3%      +4.8%     181730 ±  2%  meminfo.Shmem
      0.09            +0.0        0.10        mpstat.cpu.all.irq%
      0.07            +0.0        0.07        mpstat.cpu.all.soft%
      1.06 ±  2%      -0.3        0.78 ±  2%  mpstat.cpu.all.sys%
     51044 ± 16%     -26.8%      37389 ±  7%  numa-vmstat.node0.nr_dirtied
     35411 ± 24%     -33.7%      23472 ±  7%  numa-vmstat.node0.nr_written
     51354 ± 21%     -27.7%      37120 ±  6%  numa-vmstat.node1.nr_dirtied
     41218 ±  3%      +4.7%      43169 ±  2%  numa-vmstat.node1.nr_shmem
      6730 ± 27%     -39.4%       4076 ±  4%  vmstat.io.bo
      3.55 ± 33%     -36.4%       2.25 ± 16%  vmstat.procs.r
     59229            +6.2%      62928        vmstat.system.cs
     40891            +5.0%      42921        vmstat.system.in
     62.67           -43.1%      35.67 ± 70%  turbostat.Avg_MHz
      1.67            -0.7        0.95 ± 70%  turbostat.Busy%
    218255           -48.2%     112999 ± 70%  turbostat.NMI
      6.83 ±  3%     -63.3%       2.50 ± 70%  turbostat.Pkg%pc2
      0.64 ±  4%     -38.7%       0.39 ± 71%  turbostat.Pkg%pc6
     61120            +6.3%      64952        perf-stat.i.context-switches
      1119 ±  2%     -46.6%     597.86 ±  4%  perf-stat.i.cpu-migrations
      7740           -10.4%       6939        perf-stat.i.minor-faults
      7740           -10.4%       6939        perf-stat.i.page-faults
     60341            +6.4%      64210        perf-stat.ps.context-switches
      1105 ±  2%     -46.6%     590.58 ±  4%  perf-stat.ps.cpu-migrations
      7534           -10.3%       6757        perf-stat.ps.minor-faults
      7534           -10.3%       6757        perf-stat.ps.page-faults
    221519            +0.9%     223526        proc-vmstat.nr_active_anon
    102399 ± 18%     -27.2%      74508 ±  2%  proc-vmstat.nr_dirtied
     43395 ±  3%      +4.7%      45434 ±  2%  proc-vmstat.nr_shmem
     90876            -5.8%      85585        proc-vmstat.nr_slab_reclaimable
    142863            -3.0%     138579        proc-vmstat.nr_slab_unreclaimable
     71167 ± 26%     -32.8%      47791 ±  3%  proc-vmstat.nr_written
    221519            +0.9%     223526        proc-vmstat.nr_zone_active_anon
   1219551            -2.2%    1192725        proc-vmstat.numa_hit
    959412            -3.2%     928953        proc-vmstat.numa_local
    748058            +2.0%     763271        proc-vmstat.pgfault
    569352 ± 26%     -32.8%     382357 ±  3%  proc-vmstat.pgpgout
     39441            +3.2%      40705        proc-vmstat.pgreuse
      0.22 ±  6%     -22.7%       0.17        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.btrfs_tree_lock_nested
      0.03 ±223%    +611.2%       0.21 ± 15%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.btrfs_balance_delayed_items.btrfs_btree_balance_dirty.btrfs_create_common.btrfs_mkdir
      0.34 ± 21%     -27.2%       0.25 ±  4%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.mkdir
      0.34 ± 11%     -26.4%       0.25 ± 12%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.symlink
      0.69 ± 27%     -34.3%       0.45 ± 13%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     49.25 ± 18%     -41.1%      29.03 ± 58%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.btrfs_tree_lock_nested
      0.45 ± 45%     -76.5%       0.11 ± 69%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      4943            -6.7%       4612 ±  3%  perf-sched.total_wait_and_delay.max.ms
      4943            -6.7%       4612 ±  3%  perf-sched.total_wait_time.max.ms
      6.06           -51.2%       2.96 ±  2%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      7.45 ±  3%     +30.8%       9.75 ±  3%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.btrfs_tree_read_lock_nested
     10.12 ±  3%     -68.7%       3.17 ±  4%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.btrfs_tree_lock_nested
     24.00           +10.4%      26.50 ±  3%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
    132837 ±  4%     -11.4%     117748 ±  4%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.btrfs_tree_read_lock_nested
     34282           -18.2%      28059        perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.btrfs_tree_lock_nested
      1051           +45.5%       1530 ± 31%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      4943           -79.7%       1001        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     49.25 ± 18%     +21.6%      59.86 ±  2%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.btrfs_tree_lock_nested
    536.87 ± 11%     +31.6%     706.39 ± 17%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      5.94           -52.2%       2.84 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      9.70 ± 12%     -79.0%       2.04 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_preempt_disabled.__mutex_lock.constprop.0
      7.26 ±  3%     +31.8%       9.56 ±  4%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.btrfs_tree_read_lock_nested
      9.90 ±  3%     -69.7%       3.00 ±  4%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.btrfs_tree_lock_nested
      0.00 ±119%    +420.0%       0.01 ± 68%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.wait_for_partner.fifo_open.do_dentry_open.vfs_open
      0.41 ±223%   +2098.3%       8.93 ±137%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.btrfs_balance_delayed_items.btrfs_btree_balance_dirty.btrfs_create_common.btrfs_mkdir
      4943           -79.7%       1001        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     34.34 ±  2%     +73.9%      59.70 ±  2%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.btrfs_tree_lock_nested
    536.77 ± 11%     +31.6%     706.26 ± 17%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread


***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/disk/fs/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/1SSD/btrfs/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/link/stress-ng/60s

commit: 
  2672a26a75 ("btrfs: use per-profile available space in calc_available_free_space()")
  574d93fc62 ("btrfs: be less aggressive with metadata overcommit when we can do full flushing")

2672a26a75517a2b 574d93fc62e2b03ab39c8f92fb4 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     81.81           -54.2%      37.45        stress-ng.link.links_created/removed_per_sec
      2.66           -53.7%       1.23        stress-ng.link.ops_per_sec
     97.80          +115.5%     210.80        stress-ng.time.elapsed_time
     97.80          +115.5%     210.80        stress-ng.time.elapsed_time.max
  17882304           -11.0%   15920320 ±  9%  stress-ng.time.file_system_outputs
      2505 ±  2%     +32.2%       3311 ±  2%  stress-ng.time.involuntary_context_switches
      3307 ±  3%     -56.0%       1456 ±  6%  stress-ng.time.percent_of_cpu_this_job_got
     23.03 ±  3%     +59.3%      36.68 ±  2%  stress-ng.time.user_time
   8774191           +33.1%   11674174        stress-ng.time.voluntary_context_switches
 2.177e+10          +134.5%  5.106e+10        cpuidle..time
  21478753           +23.7%   26577804        cpuidle..usage
     85.32            +9.3%      93.25        iostat.cpu.idle
     14.44 ±  2%     -54.3%       6.60 ±  5%  iostat.cpu.system
     33.64 ± 44%     +36.1       69.73        turbostat.C6P%
     51.42 ± 44%     +57.8%      81.15        turbostat.CPU%c6
    339.20           +33.6%     453.20        uptime.boot
     81764           +35.8%     111020        uptime.idle
      3879 ± 10%     -28.1%       2790 ± 10%  perf-c2c.DRAM.local
     20392 ±  5%     -15.0%      17325 ±  3%  perf-c2c.DRAM.remote
     22676 ±  5%     -24.3%      17169 ±  8%  perf-c2c.HITM.local
     13374 ±  5%     -21.2%      10539 ±  5%  perf-c2c.HITM.remote
     36050 ±  5%     -23.1%      27708 ±  7%  perf-c2c.HITM.total
      2.93 ±221%     -99.7%       0.01 ±141%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      5.84 ±222%     -99.9%       0.01 ±141%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
    482.82 ±169%     -88.2%      57.17 ± 22%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.btrfs_tree_read_lock_nested
      2.93 ±221%     -99.7%       0.01 ±141%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      5.84 ±222%     -99.9%       0.01 ±141%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
     85.04            +8.2       93.20        mpstat.cpu.all.idle%
      0.01 ±  6%      -0.0        0.00 ± 13%  mpstat.cpu.all.iowait%
      0.48 ±  2%      -0.2        0.24        mpstat.cpu.all.irq%
      0.15 ±  2%      -0.1        0.10        mpstat.cpu.all.soft%
     14.08 ±  2%      -7.8        6.31 ±  5%  mpstat.cpu.all.sys%
      0.23 ±  5%      -0.1        0.14 ±  2%  mpstat.cpu.all.usr%
     77560 ±  2%     +24.0%      96205        numa-meminfo.node0.Dirty
   1401994           -37.7%     873378        numa-meminfo.node0.Inactive
   1401994           -37.7%     873378        numa-meminfo.node0.Inactive(file)
     75441 ±  2%     +30.5%      98468 ±  2%  numa-meminfo.node1.Dirty
   1381144           -35.5%     890646        numa-meminfo.node1.Inactive
   1381144           -35.5%     890646        numa-meminfo.node1.Inactive(file)
     85.28            +9.1%      93.06        vmstat.cpu.id
    178103           -55.6%      79108 ±  8%  vmstat.io.bo
   8168025           -10.0%    7348711        vmstat.memory.cache
     34.03 ±  8%     -58.3%      14.19 ± 10%  vmstat.procs.r
    196548           -36.4%     125085        vmstat.system.cs
    254061           -51.2%     123913        vmstat.system.in
    204078           -37.6%     127394        perf-stat.i.context-switches
      3715 ±  2%     -51.0%       1819 ±  3%  perf-stat.i.cpu-migrations
      6949           -37.8%       4324        perf-stat.i.minor-faults
      6949           -37.8%       4324        perf-stat.i.page-faults
    201465           -37.2%     126444        perf-stat.ps.context-switches
      3667 ±  3%     -50.8%       1804 ±  3%  perf-stat.ps.cpu-migrations
      6799           -37.3%       4261        perf-stat.ps.minor-faults
      6799           -37.3%       4261        perf-stat.ps.page-faults
     19421 ±  3%     +23.9%      24063        numa-vmstat.node0.nr_dirty
    350162           -37.6%     218355        numa-vmstat.node0.nr_inactive_file
    351038           -37.8%     218491        numa-vmstat.node0.nr_kernel_file_pages
      2.61 ± 70%   +5535.2%     147.26 ± 63%  numa-vmstat.node0.nr_mlock
    187.74 ± 14%     -60.4%      74.36 ± 17%  numa-vmstat.node0.nr_writeback
    350161           -37.6%     218354        numa-vmstat.node0.nr_zone_inactive_file
     19578 ±  3%     +23.3%      24136        numa-vmstat.node0.nr_zone_write_pending
     18887 ±  2%     +30.4%      24633 ±  2%  numa-vmstat.node1.nr_dirty
    344969           -35.5%     222676        numa-vmstat.node1.nr_inactive_file
    345803           -35.6%     222812        numa-vmstat.node1.nr_kernel_file_pages
    188.42 ± 17%     -59.7%      76.02 ± 19%  numa-vmstat.node1.nr_writeback
    344968           -35.5%     222676        numa-vmstat.node1.nr_zone_inactive_file
     19074 ±  2%     +29.5%      24709 ±  2%  numa-vmstat.node1.nr_zone_write_pending
   1527629 ±  2%      +9.7%    1675899 ±  2%  meminfo.Active
   1527604 ±  2%      +9.7%    1675875 ±  2%  meminfo.Active(anon)
    289398           +31.4%     380364        meminfo.AnonHugePages
   7721951           -11.2%    6857309        meminfo.Cached
    153419 ±  2%     +26.9%     194634        meminfo.Dirty
   2780170           -36.6%    1763891        meminfo.Inactive
   2780170           -36.6%    1763891        meminfo.Inactive(file)
    416275           +17.8%     490455        meminfo.KReclaimable
    188223 ±  9%     -27.6%     136295 ±  4%  meminfo.Mapped
  11439798           -12.7%    9983157        meminfo.Memused
    416275           +17.8%     490455        meminfo.SReclaimable
    804925 ±  5%     +19.6%     962444 ±  4%  meminfo.Shmem
    971588            +7.7%    1046636        meminfo.Slab
      1404 ± 14%     -61.9%     535.35 ± 20%  meminfo.Writeback
    381942 ±  2%      +9.7%     418969 ±  2%  proc-vmstat.nr_active_anon
    181535            -1.2%     179344        proc-vmstat.nr_anon_pages
     38312 ±  2%     +27.1%      48675        proc-vmstat.nr_dirty
   1931000           -11.2%    1714553        proc-vmstat.nr_file_pages
  13547942            +2.7%   13912320        proc-vmstat.nr_free_pages
  13461624            +1.6%   13679317        proc-vmstat.nr_free_pages_blocks
    695262           -36.6%     440935        proc-vmstat.nr_inactive_file
    696983           -36.7%     441202        proc-vmstat.nr_kernel_file_pages
     47106 ±  9%     -27.6%      34100 ±  3%  proc-vmstat.nr_mapped
      3.92         +5932.5%     236.47 ±  2%  proc-vmstat.nr_mlock
    201270 ±  5%     +19.5%     240603 ±  4%  proc-vmstat.nr_shmem
    104059           +17.9%     122643        proc-vmstat.nr_slab_reclaimable
    354.34 ± 13%     -61.6%     136.21 ± 20%  proc-vmstat.nr_writeback
    381941 ±  2%      +9.7%     418969 ±  2%  proc-vmstat.nr_zone_active_anon
    695262           -36.6%     440935        proc-vmstat.nr_zone_inactive_file
     38650 ±  2%     +26.3%      48817        proc-vmstat.nr_zone_write_pending
    815243           +29.7%    1057739        proc-vmstat.pgfault
   2292624           +33.2%    3052827 ±  6%  proc-vmstat.pgfree
     45576           +28.2%      58408 ±  3%  proc-vmstat.pgreuse
     14530 ±  8%     +25.6%      18255 ± 13%  sched_debug.cfs_rq:/.avg_vruntime.avg
      0.26 ± 11%     -35.6%       0.17 ± 14%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.26 ± 11%     -35.6%       0.17 ± 14%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
    636.58 ± 59%     -64.8%     224.08 ± 54%  sched_debug.cfs_rq:/.load_avg.avg
     29250 ± 28%     -59.3%      11910 ± 23%  sched_debug.cfs_rq:/.load_avg.max
      3062 ± 40%     -59.7%       1235 ± 41%  sched_debug.cfs_rq:/.load_avg.stddev
      0.26 ± 11%     -35.7%       0.17 ± 14%  sched_debug.cfs_rq:/.nr_queued.stddev
     37.60 ±173%     -90.1%       3.73 ± 63%  sched_debug.cfs_rq:/.removed.load_avg.avg
      7871 ±207%     -96.6%     269.92 ±  9%  sched_debug.cfs_rq:/.removed.load_avg.max
    516.54 ±195%     -94.3%      29.53 ± 37%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      4.54 ± 32%     -58.6%       1.88 ± 67%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
    309.25 ± 19%     -56.4%     134.88 ± 29%  sched_debug.cfs_rq:/.removed.runnable_avg.max
     34.78 ± 17%     -57.5%      14.77 ± 47%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      4.53 ± 32%     -58.6%       1.88 ± 67%  sched_debug.cfs_rq:/.removed.util_avg.avg
    308.92 ± 19%     -56.3%     134.88 ± 29%  sched_debug.cfs_rq:/.removed.util_avg.max
     34.75 ± 17%     -57.5%      14.76 ± 47%  sched_debug.cfs_rq:/.removed.util_avg.stddev
    118.80 ± 25%     -51.7%      57.33 ± 33%  sched_debug.cfs_rq:/.runnable_avg.avg
    126.83 ±  8%     -32.9%      85.16 ±  4%  sched_debug.cfs_rq:/.runnable_avg.stddev
    118.02 ± 25%     -51.8%      56.91 ± 33%  sched_debug.cfs_rq:/.util_avg.avg
    126.09 ±  8%     -32.8%      84.69 ±  4%  sched_debug.cfs_rq:/.util_avg.stddev
    810.17 ± 16%     -57.3%     346.17 ± 19%  sched_debug.cfs_rq:/.util_est.max
     76.34 ± 14%     -56.1%      33.49 ± 24%  sched_debug.cfs_rq:/.util_est.stddev
     14530 ±  8%     +25.6%      18255 ± 13%  sched_debug.cfs_rq:/.zero_vruntime.avg
     32692 ±157%    +645.4%     243681 ± 25%  sched_debug.cpu.avg_idle.min
    149262 ± 14%     -40.7%      88476 ± 18%  sched_debug.cpu.avg_idle.stddev
    270327           +22.2%     330227        sched_debug.cpu.clock.avg
    270354           +22.2%     330256        sched_debug.cpu.clock.max
    270294           +22.2%     330194        sched_debug.cpu.clock.min
     16.39 ±  2%      +5.5%      17.29        sched_debug.cpu.clock.stddev
    269888           +22.1%     329584        sched_debug.cpu.clock_task.avg
    270063           +22.1%     329808        sched_debug.cpu.clock_task.max
    251834           +21.3%     305583        sched_debug.cpu.clock_task.min
      1135           +32.9%       1508        sched_debug.cpu.clock_task.stddev
     10849           +23.1%      13359        sched_debug.cpu.curr->pid.max
      2290 ± 14%     -28.9%       1628 ± 14%  sched_debug.cpu.curr->pid.stddev
      0.25 ± 12%     -36.6%       0.16 ± 14%  sched_debug.cpu.nr_running.stddev
     35133           +80.1%      63281        sched_debug.cpu.nr_switches.avg
     50004           +97.6%      98788 ± 19%  sched_debug.cpu.nr_switches.max
     25067 ±  9%     +92.3%      48191 ±  4%  sched_debug.cpu.nr_switches.min
      2519 ±  4%    +143.9%       6144 ± 20%  sched_debug.cpu.nr_switches.stddev
      0.45 ±  9%     +63.6%       0.74 ±  2%  sched_debug.cpu.nr_uninterruptible.avg
    270295           +22.2%     330193        sched_debug.cpu_clk
    269239           +22.2%     329136        sched_debug.ktime
    271733           +22.0%     331628        sched_debug.sched_clk





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

