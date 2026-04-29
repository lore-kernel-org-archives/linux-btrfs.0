Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B33E2E7BD3;
	Wed, 29 Apr 2026 07:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777448438; cv=fail; b=HgyHqB7m41UnuJ4cWvhDKwS+1aUlTJ1KZqtuql0UspGnjVT93sWud1JtxUnfUjpQDuaJmNFrAcIcvXC2NbgoI5e0d5cW3e3miy9q3MnX+VdQSuDRvFRcttsha1RsI2J5QW4koUrn3pZ3yUhuvOZXLU5BS3HIVw8YJ+R12fcmlT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777448438; c=relaxed/simple;
	bh=GtluU80nRcscGUeMmmiviWCSgpxTqiPzjDwlzDD3+aU=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=RBXyhKJ05nUbiOvXql8KF5OFn1fsuSHjebXiSNpyaQJDRhKFkq4x3b+4BsfSKoplOvON9LZEByDo8aN7/mBueT2gW8dgynU8vLkSHH0BebiyucrQJCaxRRtrOadxUC45GdtzBZD/TVJHYhSMCrspAegGpiFIjTUBc73tIZjFaSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NbqHaR4b; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NbqHaR4b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777448437; x=1808984437;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=GtluU80nRcscGUeMmmiviWCSgpxTqiPzjDwlzDD3+aU=;
  b=NbqHaR4bUNgeFX4QCa59KIvlsqzHcgIUYG9BGQ4kG8B4OkYpym6Lnw2R
   cenuocUFVAb/kkGz5Kf+UbKbuI2KhNFpYVARmRcl9E25kRIs5o4POVSh6
   hU2lfaR4qNdVVLeaR3+COzid49UJjarTZX1ASR147K5zg1BSnfoN9Pq2a
   oy0j1HJ+26fwUHMtrXHyqc44k9MuXNKBfPOPIDV05KoC112f6wYq9xeYu
   fgUTO1KBnQHKjfq/xRWIeJUCVItE3LeIDtwYNkDRqjjEt+ILiE3JYnlx/
   GEMw57fkMVi0FBwgKBWDegD/iSHhfWPlBKHZteREZ0jrix2b1WWnEJDLX
   Q==;
X-CSE-ConnectionGUID: Hb0N4MDnTf2i2wxO7pZkLA==
X-CSE-MsgGUID: i1fQ088zRNSY/GUnIyekHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11770"; a="95937793"
X-IronPort-AV: E=Sophos;i="6.23,205,1770624000"; 
   d="scan'208";a="95937793"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 00:40:24 -0700
X-CSE-ConnectionGUID: tT/Nh6BCQMuaSjflYQJsNA==
X-CSE-MsgGUID: rejsC4fbTz+26GF+VRvC4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,205,1770624000"; 
   d="scan'208";a="239233102"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 00:40:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 00:40:22 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 29 Apr 2026 00:40:22 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.71) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 00:40:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OIeDRLrcaHVBga5rJjGMiPayrUF2usATW7r7dz/GqITqNMlMYaA87EgtDMG4UNR4Forj4GkPlKNtn1vCM1FERjHSWDHiEDiKEasqcy0Q0qf8HqZfMrRuvrLI0rSHjN6y3ElGmUQS3Hymum+ngRpG9p9KnM0vBejO7A9h73gECis81/wUH5f0WPEwss5QcjpMBabJ6aYUubqJ3Lf/vpLmZOBf5ctG2XSctlO+85Gmo0+o0uqKQcuZqLrKxR6o4gOIcE9ORRlPHRQ08CsaeDPvZcPSktb+zD7Zwqt8oHSEREFDWvVqxEY0wbuz+NX3jEWJocl3f2bc/DbAMDaJSSLNqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ussoT1mWDC4YN/zC6tKz/WjopAG15RY4Vzbs1u2v9oQ=;
 b=Jea/4RNkpL7vIwL18xfjQfCGS+JIDOAxpMjPrjD1fdiTj1cKyjYZZoBA5Xlq2X8auisFjgzcQSd5599IHNFTin5+DQAqUuV6a74bF0epjFp7dmP38a4oTEif2zAGTFbx7iY5BzrC26OVUsufQt5aFQQDYFlgid8gR4FNJO1FMXVtAgcws2oM30UjwiQuGXSqMDw1hEHwOpK1VyC6uq/oSxMS1RaN/yxAjZM0YC/R4Yx20l/AcO1KyP4df7lFvFfmGAlh1UfLcuubbGoX3v+t4uQXd0ZD3Nk2kPZla5iQfDQmMdY9OYvKVW0TA7cik7SdQIHoc83/7gW6QFpQcgGrGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by MW3PR11MB4618.namprd11.prod.outlook.com (2603:10b6:303:5f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Wed, 29 Apr
 2026 07:40:20 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 07:40:19 +0000
Date: Wed, 29 Apr 2026 15:40:13 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Leo Martins <loemra.dev@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, "Sun
 YangKai" <sunk67188@gmail.com>, Boris Burkov <boris@bur.io>,
	<linux-btrfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [btrfs]  f9a48549a1:  fio.write_iops 6.5% regression
Message-ID: <202604291540.72917ba4-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0042.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::10) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|MW3PR11MB4618:EE_
X-MS-Office365-Filtering-Correlation-Id: cc89fd1d-56d5-4580-474a-08dea5c29055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: Yvf6arFVVJOhxLrguaqxNRjeOE2rbIHV0UeEQxXbokerbDuijKLzt5DFXElukNTWWAZLQixa53MWSZetl8gvlOPNirsRA3fMFlVtOYm+/A9hONGT/485XC250hSrrwD/Gr2N7VRBJBIsmZg5sqjSI0HX+sbmpmbBfkFZrbmIAY7v9uTjMvVEH1VCsVKENPI2dRKdp3WcI7sAlHWidm+bzrr6Js8wDw+XJqRj4M1hNSOJmYGNkIuG1AqiOhYzaecbFBoIACsVYJahHNbdfcxqqVqUgYITLpdYKhmCi3YI3UwDog46Aik6FAMujvpYkny1WPqJabLxPRi70LuXJpxKP4pZTWweu9ywV1B/2WJg9I0UOZdPv2RzEtPwQbCmW3Gq1LLAjbVzlU65dZE4iyqSk/0B+qX9sIq/Qc9wtm60dFvIId2EPvt4alniYfpi35nciUggdH2PySsDHU3b+tM25VxyYRrpTXJba8N7hIsATm33S5A9DEZqIrcISTJFnwJu08NxGR42YiHTM6y/1Uy02nyC+HjAJynjvd7mowIuXInIta7aRFvvvmO4co9yNUnvaYhD0pvI8L+DaVVBbfBHKWZpA6rju/0Z3uDpyI184yXcx1NMUaTP8FZ+Df6XLS23k5NBoSK+prH70UxcUnq79j2RzDpVquO1ECLXR3Y1anIGAfefstfSE4MPQ0imDgF5G31gDJ4JQUQlP8Xap3L7zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?EDla9DyRcauNZCDVNMHVf03bVe68td2w8rglOqUbs2IqEo18YMHn0VbbWt?=
 =?iso-8859-1?Q?oVsJCwkssq5ljwJsxDq3UScOuF8hXLhBm/Ckt//y8Yyyo9JVzOkfVbxPO7?=
 =?iso-8859-1?Q?JoDIMwXu79DzzcWOUBIjFbCgIHxBAJeTuQnAHdfqG+ITuouOrFw8/W9tGZ?=
 =?iso-8859-1?Q?nk4ah4lb3cPRQjb1mtoJgop3DrwCD+tNAlQl5Frx4JMJtli9Aedo9PXPz4?=
 =?iso-8859-1?Q?AwdrQ/uNOcCMXjb1RvEmDzdYvQe+GrBR4brG3a1DTg29kEg1bz9rDp4lm6?=
 =?iso-8859-1?Q?xyVzS4qaO/A4vlGpniXrno98hwK6j0PYC2ev0TwYKOZUhRxAi0pl2xtaMH?=
 =?iso-8859-1?Q?UXo2CVDHZ0elaiImxFT9D9H+e8WlmL48Pn8KHrbWWb6AHSFvvHZg7PwpT4?=
 =?iso-8859-1?Q?IFwvq/LzPdYLtGEX1qTGJcMegZ24hnEv4LDxApGpB3THoOmwoEiImu7xhA?=
 =?iso-8859-1?Q?XW2cj4+l6Fg6weY31B1Z/Ki1aKQWCuyyfvKPXrEkxM16LQCl55uruRC50z?=
 =?iso-8859-1?Q?V7rgLe+bvNo517HUkqPtp36+zhFL6XqVweAh7Qxwi3kcR3ehoSX/W4JT6k?=
 =?iso-8859-1?Q?Q+YXSB8BfOiyrY3s0XBKDy88uVFleZ8br6uJpHGLPheC6h6rZZB9Io7gon?=
 =?iso-8859-1?Q?pphnuhzvnJ4ihZxJd0t0p04w89fHRHjV1FpZePfVI3foMFTFaOu8+/BNjg?=
 =?iso-8859-1?Q?oyXhI5mVSgJYudeHUAtG1s5Be3Bvs/jDzGbWPPShfSwFztmVvTCH/vcen1?=
 =?iso-8859-1?Q?jNT2lGZet5Sq7ifmy4EDQRzEhrPAoElnOqnz3PVRiuJdbFKQB2kNGUOA9b?=
 =?iso-8859-1?Q?rPUB8/FHyqQnhG/O5fQqItYRQARSSbtWEDPD9IFXJRcvXiCuVKXNMuER33?=
 =?iso-8859-1?Q?uNCDqUjHlrvs9u+zI/L+DpFXqE6h3jnArks/e7i0fWVMdQOGBSqocJLyEc?=
 =?iso-8859-1?Q?iT4gwqK57E/GqgFaKhQn3JTl2QHL4dAq/U8OLcnU6eU//cOqeFU53ut3m/?=
 =?iso-8859-1?Q?FLlRowmyuKBmBIUaPt42TdiwdhaGRppzQsd+oHbuxRJdjR7q6T/8vu1/vC?=
 =?iso-8859-1?Q?srWUSl8uicMx2fPSJM/32Aw1QQD4aQIDMTF6y6eYJfEGS2HKI77+yRBdKo?=
 =?iso-8859-1?Q?9kWE6G6/wEXFi9/7wIWWS5iQqP2Tz2NqMKd3dyOkDF/foHugxcpjn4I8Tf?=
 =?iso-8859-1?Q?G5HM/9BeEKpcNd/sr0SDEqCFLnUo/aTiwTE0jwoNbNyYrrwiQRVnPfpzJu?=
 =?iso-8859-1?Q?svCTFZJtQeEeCfhVIbwVpbFdbpQCLlhwXHJoNoIimKkF2bi2iJNcXI6Akx?=
 =?iso-8859-1?Q?BKEB7zsG0w2dKMnd1daA9blrPW0iwkuqPqLkge5a4Pn5iJ4gOuJuLtZbJF?=
 =?iso-8859-1?Q?H7AgSzX2/99LlFknJU1/HmelEA4OuD9t52CuPeuNl782SrEkqimKCaqPix?=
 =?iso-8859-1?Q?6IhPK8d1zjM+EzqcACYk6byGjydjYexGem1AMBI+7Bs7mQ92YCwwjU6cpm?=
 =?iso-8859-1?Q?4MwclXKXNT5On65vmRrjZLvvFPN7giNVlZO/nNwuhan+1jIrBb7hIo8i+j?=
 =?iso-8859-1?Q?jO8avrjpCzePrGFvwlbPI7O92UaMAfvTxdhaK5U/kweWKbn3CikN7poQ4n?=
 =?iso-8859-1?Q?AOTTrBfPh59EWnGiYRA4H1xYb4bnBBR7PScGtv/Xvs7LGfe7ylRRA/+Vj2?=
 =?iso-8859-1?Q?K+FSTn2UKT187LKDmlKyjNgwzXYstAXPmwp0WSBwZueuxIdh/bW2oHs/aO?=
 =?iso-8859-1?Q?oCNk12pPvOFDKWwqdeAQ8YJxVgwUsVgWM0vAK50axhRdX4HxVZcQaATkeW?=
 =?iso-8859-1?Q?n70bBTcxQw=3D=3D?=
X-Exchange-RoutingPolicyChecked: iNdt77APslaq0MiHSIZ9djmsq+QTxsiSqQfvmlzTkVwN1/64lgE2wCO+LnZb2ji2A+Unmw8YGu1YscWd+S1QcUAWILbqDhu3cR//2VAzHMGZ8bU0owKdd6RGCHN9BD/84CWjfjY7COntxjFrt2J7CxGjowFzt+nCvjM8dUOQaJcjka+6RD4/AAMUa2LqKD5I0pTmcr2edNUdZ0nDp5ahjZqjoIjHZ6RioIRerjSgLbWEIJ5mPXbUoYi/dsXz4kK8SxIBBpKNmcxuDsCUZ4Y2vzf/N1r9NFp648C0X91Pzgs4B4/tHLkKomelKjqQajwn3qLJjarId5kynITb+1G50A==
X-MS-Exchange-CrossTenant-Network-Message-Id: cc89fd1d-56d5-4580-474a-08dea5c29055
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 07:40:19.8214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZdVEILegBsrimZlBfebcyVLnqSi0s1LxOa5jh3izO7roiMOmm6pAEbdJztHmoVGI06XA4cf2ZSBre+ZDOP8JKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4618
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 6.5% regression of fio.write_iops on:


commit: f9a48549a15aa369d42cebc08a6a72b71a53d547 ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      27d128c1cff64c3b8012cc56dd5a1391bb4f1821]
[still regression on linux-next/master 7080e32d3f09d8688c4a87d81bdcc71f7f606b16]

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
	ioengine: vsync
	cpufreq_governor: performance



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202604291540.72917ba4-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260429/202604291540.72917ba4-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/vsync/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic

commit: 
  cab4c8b594 ("btrfs: extract the max compression chunk size into a macro")
  f9a48549a1 ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

cab4c8b594e23649 f9a48549a15aa369d42cebc08a6 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.89            +0.9        1.81 ± 13%  fio.latency_1000us%
      0.03 ±  9%      +0.0        0.05 ± 14%  fio.latency_100ms%
      0.11 ±  4%      +0.0        0.12 ±  8%  fio.latency_10ms%
      0.41            +0.0        0.43        fio.latency_20ms%
      0.01            +0.0        0.02 ± 15%  fio.latency_250ms%
      0.32 ±  3%      +0.1        0.41 ±  5%  fio.latency_2ms%
     38.01            -1.8       36.25 ±  2%  fio.latency_500us%
   3854021            -6.4%    3605989        fio.time.file_system_outputs
    568393            -4.2%     544573        fio.time.voluntary_context_switches
    481752            -6.4%     450748        fio.workload
      6.27            -6.5%       5.86        fio.write_bw_MBps
    453290            +2.3%     463530        fio.write_clat_95%_ns
   1452714           +27.1%    1845930 ± 12%  fio.write_clat_99%_ns
    622412            +6.9%     665559        fio.write_clat_mean_ns
   9945919            +2.6%   10208918        fio.write_clat_stddev
      1605            -6.5%       1501        fio.write_iops
      1.66            +7.0%       1.77        iostat.cpu.iowait
      0.99            +7.2%       1.06        turbostat.IPC
      1.66            +0.1        1.78        mpstat.cpu.all.iowait%
      0.01 ±  9%      +0.0        0.01 ±  9%  mpstat.cpu.all.soft%
      0.15 ±  2%      +0.0        0.16        mpstat.cpu.all.sys%
     11925           +43.4%      17095 ±  7%  vmstat.io.bo
      1.06            +7.4%       1.13        vmstat.procs.b
     11590            -2.7%      11278        vmstat.system.cs
      1.24 ±  4%      -0.1        1.15 ±  2%  perf-stat.i.branch-miss-rate%
    494667 ±  4%     +13.7%     562455 ±  6%  perf-stat.i.cache-misses
   3724781 ±  2%      +6.8%    3976385        perf-stat.i.cache-references
     11645            -2.7%      11330        perf-stat.i.context-switches
      1.03            -8.8%       0.94        perf-stat.i.cpi
      1.06           +11.7%       1.18 ±  2%  perf-stat.i.ipc
      3.98 ±  5%      -0.5        3.53 ±  3%  perf-stat.overall.branch-miss-rate%
      1.07            -6.9%       0.99        perf-stat.overall.cpi
      1739 ±  2%     -10.3%       1561 ±  6%  perf-stat.overall.cycles-between-cache-misses
      0.94            +7.5%       1.01        perf-stat.overall.ipc
    504122 ±  4%     +17.0%     589787 ±  2%  perf-stat.overall.path-length
    493093 ±  4%     +13.7%     560650 ±  6%  perf-stat.ps.cache-misses
   3715678 ±  2%      +6.7%    3966204        perf-stat.ps.cache-references
     11607            -2.7%      11293        perf-stat.ps.context-switches
      0.68 ± 20%      -0.4        0.30 ±100%  perf-profile.calltrace.cycles-pp.__schedule.schedule.io_schedule.folio_wait_bit_common.folio_wait_writeback
      0.70 ± 19%      -0.3        0.40 ± 71%  perf-profile.calltrace.cycles-pp.io_schedule.folio_wait_bit_common.folio_wait_writeback.__filemap_fdatawait_range.filemap_fdatawait_range
      1.18 ± 15%      +0.4        1.57 ± 11%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt
      1.12 ± 14%      +0.4        1.51 ± 12%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt
      0.45 ± 72%      +0.5        0.96 ± 12%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.30 ±100%      +0.5        0.84 ± 11%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +0.6        0.63 ±  7%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +0.9        0.90 ± 17%  perf-profile.calltrace.cycles-pp.xas_find.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered
      0.00            +1.0        0.96 ± 16%  perf-profile.calltrace.cycles-pp.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper
      0.00            +2.1        2.09 ± 18%  perf-profile.calltrace.cycles-pp.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work
      0.00            +2.2        2.16 ± 18%  perf-profile.calltrace.cycles-pp.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread
      0.34 ± 79%      -0.3        0.06 ± 73%  perf-profile.children.cycles-pp.memcpy_extent_buffer
      0.46 ± 12%      -0.1        0.33 ± 15%  perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      0.16 ± 40%      -0.1        0.04 ±107%  perf-profile.children.cycles-pp.lock_extent_buffer_for_io
      0.47 ± 16%      -0.1        0.38 ± 15%  perf-profile.children.cycles-pp.update_load_avg
      0.13 ± 23%      -0.1        0.06 ± 62%  perf-profile.children.cycles-pp.menu_reflect
      0.04 ± 72%      +0.1        0.10 ±  9%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.04 ± 73%      +0.1        0.12 ± 29%  perf-profile.children.cycles-pp.scsi_dma_map
      0.10 ± 41%      +0.1        0.18 ± 34%  perf-profile.children.cycles-pp.lookup_extent_backref
      0.02 ±141%      +0.1        0.10 ± 30%  perf-profile.children.cycles-pp.__dma_map_sg_attrs
      0.02 ±141%      +0.1        0.10 ± 29%  perf-profile.children.cycles-pp.dma_map_sg_attrs
      0.04 ± 77%      +0.1        0.13 ± 33%  perf-profile.children.cycles-pp.___perf_sw_event
      0.22 ± 16%      +0.1        0.31 ± 19%  perf-profile.children.cycles-pp.__call_rcu_common
      0.14 ± 30%      +0.1        0.24 ± 24%  perf-profile.children.cycles-pp.lookup_inline_extent_backref
      0.07 ± 55%      +0.1        0.19 ± 18%  perf-profile.children.cycles-pp.__refill_objects_node
      0.14 ± 54%      +0.1        0.26 ± 19%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.20 ± 26%      +0.1        0.34 ± 16%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.38 ± 18%      +0.2        0.56 ± 11%  perf-profile.children.cycles-pp.xas_alloc
      0.04 ±110%      +0.2        0.25 ± 22%  perf-profile.children.cycles-pp.xa_find
      0.09 ± 46%      +0.2        0.32 ± 97%  perf-profile.children.cycles-pp.__pcs_replace_full_main
      0.46 ± 26%      +0.3        0.78 ± 11%  perf-profile.children.cycles-pp.xas_create
      0.04 ±108%      +0.4        0.44 ± 23%  perf-profile.children.cycles-pp.__xa_store
      0.66 ± 26%      +0.4        1.05 ± 10%  perf-profile.children.cycles-pp.rcu_core
      0.52 ± 29%      +0.4        0.92 ± 10%  perf-profile.children.cycles-pp.rcu_do_batch
      0.04 ±108%      +0.4        0.49 ± 23%  perf-profile.children.cycles-pp.xa_store
      0.00            +0.7        0.69 ± 23%  perf-profile.children.cycles-pp.xas_free_nodes
      0.00            +0.7        0.72 ± 25%  perf-profile.children.cycles-pp.xa_destroy
      0.00            +0.8        0.76 ± 20%  perf-profile.children.cycles-pp.btrfs_inhibit_eb_writeback
      0.00            +1.0        0.96 ± 17%  perf-profile.children.cycles-pp.xa_find_after
      0.50 ±  7%      +1.1        1.62 ± 15%  perf-profile.children.cycles-pp.xas_find
      0.00            +2.1        2.11 ± 18%  perf-profile.children.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.04 ± 77%      +2.1        2.17 ± 18%  perf-profile.children.cycles-pp.__btrfs_end_transaction
      0.12 ± 23%      -0.1        0.04 ±105%  perf-profile.self.cycles-pp.finish_task_switch
      0.01 ±223%      +0.1        0.10 ± 35%  perf-profile.self.cycles-pp.xa_load
      0.00            +0.1        0.09 ± 33%  perf-profile.self.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.04 ± 77%      +0.1        0.14 ± 34%  perf-profile.self.cycles-pp.__call_rcu_common
      0.06 ± 58%      +0.1        0.18 ± 19%  perf-profile.self.cycles-pp.__refill_objects_node
      0.05 ±104%      +0.1        0.20 ± 22%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.06 ±100%      +0.2        0.21 ± 23%  perf-profile.self.cycles-pp.xas_create
      0.45 ± 25%      +0.2        0.65 ± 17%  perf-profile.self.cycles-pp.kmem_cache_free
      0.00            +0.6        0.56 ± 19%  perf-profile.self.cycles-pp.xas_free_nodes
      0.01 ±223%      +1.1        1.08 ± 15%  perf-profile.self.cycles-pp.xas_find




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

