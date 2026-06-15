Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF63B3FCB2B
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781535048; cv=fail; b=qiLbdiYTDYJ4JccfH1ADjuFDEAxFqcetlu89CK0tmnmdyr+LaW9FmmegE5TD7c++Kr9eVl8q8yOrHnOlgjDzxOvFsL3GNcEPcXy9L5gwd9qUPkpqQYWUZv+Qf5NPKKQlgmiTwhJDqVKaGeglDa9LfHw+CEIJUV39DGIhi2HCnPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781535048; c=relaxed/simple;
	bh=gC1sYqx8XyxyeaCyAz7t4FEfm8PE97S4BTJVL5N8+k0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=VpcNFVQLQpnRDyJXJzCeX6vNTIirJQqSNcPy/VDV9C14Lph3PFD0ZPxnRTJOvGc1AypFo9gUyyM2lkExiGpG1fI+afXzYFkYfgot/YuQVhBIhNirhnE6LG3YaFlYq4gNmXQOeaKG4FSGEsR4ulnAWnhCDSM6+ux8om34pttmQyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6B7vc9v; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6B7vc9v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781535046; x=1813071046;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=gC1sYqx8XyxyeaCyAz7t4FEfm8PE97S4BTJVL5N8+k0=;
  b=Q6B7vc9vM6h1YDX95Y2CjFR0oi/yaH1BfH9wawV7QyDQnuGgRLiB4rzw
   y55R4telL6JGB+el6t6GdLW7816ZSH3MDAtFjEj23C6TvMgB6L4tcS1Cv
   VxAJRdkxEplU9tyRcQINlp3BXBsmKxya839zIm+dn5LKq82j8ddY6VE+R
   +2AQpkrR+0Sb3I41uRk7oiPfDa9x+5zSoLx8j7Li485KlVvpa73drc/Ih
   c7kUraM85ZGdE6ieP5v3WtVg7kIo9rOsEKShFqUybwG6eDbBszY8bvMmL
   k9qTB7QKSzUEB0bHSRkJDjBIZfyccWjDRf0sBaD4t1LyYJkyzlw9U8R6O
   Q==;
X-CSE-ConnectionGUID: cAHW84iMSYaXpCPSYJsKgw==
X-CSE-MsgGUID: +CPCUegAQ52xTky54BlHUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="82124033"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="82124033"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 07:50:45 -0700
X-CSE-ConnectionGUID: xLMOlY1zRrKa/b5Qf7fIrQ==
X-CSE-MsgGUID: Zp4LNBNSQOGGWlMkpOdanQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="249377055"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 07:50:43 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 15 Jun 2026 07:50:43 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 15 Jun 2026 07:50:43 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.40)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 15 Jun 2026 07:50:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndpf+PRnHhpBHI3VSkVQ7Y2kNVNj3mmgKYd73VFsOjjx1+/OR/jIKSvRa7uLy19KUNb2wfX57Pkyjir1GbujmFi9tk6pmN0jJVH9VWT8SMwDIpyVX062xULMQ02FyVpE/4W7dEgl0ke/uj8B5AJhmz8BWZBoffmDMNd9M5P+9SpLH9KZwxf/NXE1CAq/FiSON/l84m0Qbqh3KbWdnn2yheto7wnN0305hy++6u65JTUdr+dd5E7DBiEz/fV70LufZbL48wHLad9HQQVZbD+lIbd6cwJCngiacuP2KRKc9ccKyiLxA0QBwpcwcvWE04J5W0q4AFWLnL6oGGKun1ifYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q94M0ptWqQE6s6pDk5ffOsEWoKJ0rJjQKs/z6/MbspQ=;
 b=MMYAhX4DedaO5QvzZ2SZQ6l3zd8QQusqar8w8sdrIm4cW5G52GsREI1/sJd6xR+lEoRvNf+H2hfEWXwmKemxXVhEsh1g/xSgB73dM52TRkCveVzjxr9pRXtBB9JyNPRuxqBbqUMubmR+3TOzMlgQ5A4d06bAQE32VfaNYizP3LnSUygOLWRbkz50oNEDrBRjSe5Sqw8unHdnNy4/YrBEojGgz44V2JYvZl2IcDLy2DFIaAzuxyHQNfw15rmXN1JifS7FebKCgx0VjDoD3qvmn5u+W+fvv73Gd8dWhAu7tAf4KP0h7TLkefOy3zCUN1xcBaByarvlE4wUuor7MYNPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DM4PR11MB6213.namprd11.prod.outlook.com (2603:10b6:8:ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 14:50:40 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 14:50:40 +0000
Date: Mon, 15 Jun 2026 22:50:33 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Mark Harmstone <mark@harmstone.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, David Sterba
	<dsterba@suse.com>, <linux-btrfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [btrfs]  14f9161e87:  fio.write_iops 13.1%
 improvement
Message-ID: <202606152223.d5cf620b-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0021.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::12) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DM4PR11MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: 3da7b3b0-9b08-4036-f20b-08decaed77b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|18002099003|6133799003|11063799006|3023799007|56012099006;
X-Microsoft-Antispam-Message-Info: 9aj2N1+Xp+uGdviz1BQoBaqXPI8Bn9K5cz0Db9uHU+Ho2XUr0jrtnBu/UKlP1TRXjRvpwZOBXCHFt2hy4UFAkwsmnCXxJcwYvecWtWLfdyuqrsUW1Gqnqjlf6q7XMSNNaWgpsPrcoG8zkXLLHuaUYX2pkl1eQROz/VMUFVXMJbZvoN0Uhhw0rtPIBrgcAx+rdAIZqweZw2iXFKi4GPr+WTjnqnSGde3J5WaAmpigJG6OTQ5UGgGfJm4wH3FQFPOwTFLVEMzD+EEPnAGaVUmqWYofWLnjA9Kgl/TmFXyBBQYhqk1adMxI/eP7do+eikdbW5jCXx6mxG+s1McId30hr3KBdGIbSurzn60yfNfrXQ025ANloMSAJC5T5s8FDH16eaR0T1BhQrWrn/+QwVCvk//DWB/mUE98uTMJiojEbLvwCl3xy/Du3HhXxamomhoClH1LKDHSLjXpt1clBf8lvFzyu8G7EdI2QJa+l/HZyPjlZOoQmv6Hq9HUy19HFLHZJQz4gmtvrL+OJzslAEuwXSJTUKBCxs9IKjsdQ61QTv6KYo1NEGCXKrgvszi2bvw+g/c/EuZZyIlN/7FaaiHU3vy0m5BxtwLwNU4bd2T/HTxD1+RYhHQ/v4U63l3XiHODn53hTFRveHjaTNr1E1gFqv0HUY03Gf5UmsIT+1PTPORvg+/cufrO264enu7hEfpzEFLqY4YQG4gBSb0IODm3cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(18002099003)(6133799003)(11063799006)(3023799007)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?X9avYtf1sDvFLQ8TqdYV3OVa3crUUuG0l3ZiE8JGR64f0x8DcTvVJLiwM9?=
 =?iso-8859-1?Q?HJvtVWh3rcD6Fwi+5mqpAEG15IK7C/3KgIbt7GWmFGc52Y2IMZpQLo5A08?=
 =?iso-8859-1?Q?SuFxJ6hU6e5FjmtZnjw7iFrFAy8hwZ1HFH7TC33ymSGmX03PiWbzefQEh5?=
 =?iso-8859-1?Q?bX/EYLaIgXJDdCq2Xgsoy3anCbtFvNBHWseRD2ozr1B3Sgd2ba+r5IfIBB?=
 =?iso-8859-1?Q?5BtJY4YuJPQAzBgchHI4R/FvZty/SFaoyI/qamVbe3XiAGjxqIVVu0l1I5?=
 =?iso-8859-1?Q?PD/LW8wvRjcB4BKC2YeYQzDu7ml2wBdY9cKja2TW5GTJsjDh8A2iOkHXT4?=
 =?iso-8859-1?Q?F+dGXNkORfIVUdkFh5MJGfoatpbiLm5/T3FfEILO5kcV5KcG1tt73NYqFg?=
 =?iso-8859-1?Q?KzfsKkHvQ0JtB/5Rcop9KOatnIznlvXWMEEmm2xBuuKon0RwyZ7rLWwbm+?=
 =?iso-8859-1?Q?jgOO/HaT+USXpY+RiAo8F23ztHLrKJISt93OPofvprayqA+5Lmz0xDXctJ?=
 =?iso-8859-1?Q?h8Req2YCj/W3f+NXn5lfNw3rP6BcYNo7dzWLVa/m6iqZ/k9jL3/IZlxzWn?=
 =?iso-8859-1?Q?5AUxK7MvZjaJcazOVkKuA04yETSNlJ3D+hlth3PPHEjI/xbIrbzKo1u3/V?=
 =?iso-8859-1?Q?7HVWqUEli6/Mtw+vUAc4iJ7GsFXwtGQ5LGuDtF9uKlMxqTKtZgwITMEEIE?=
 =?iso-8859-1?Q?ReTRRAgZZstPMUseU6cITY6d8i4E3Eskv2pXP7UvMy0Nd4tkACVn2xzT8Z?=
 =?iso-8859-1?Q?LHbX7lxCYM0UAOtB/ZhfBAfhkjkmkZKbtgJQJwCVL30iG/pjByjmhIGR/O?=
 =?iso-8859-1?Q?MOosm3zvmzwh9xEelXr1WOauTYBnos1jB3OdCDCgmlGjMR4gpGHS3DUyuy?=
 =?iso-8859-1?Q?4DlYJ33oVniwdgPlsDpiN5a0Nx81PABER6pGZTgOatjeXAAbnUcGr18uNE?=
 =?iso-8859-1?Q?80aVUUjFVknUU6bqAy0p6sTfFVtpjaF3c00+2gO55O+RHFTPfgEoWFAvqd?=
 =?iso-8859-1?Q?+nmx+uj/cQQm1o2HXIzppMYU2xs1Ej40iqd9v8wts2qHmzLUhAPJr2di+E?=
 =?iso-8859-1?Q?iDp6SqJgsGa8UCF961QQqp68A2aY1p3U2Ort0GG+rDgQebt7GvhhyjBfBz?=
 =?iso-8859-1?Q?/hxJpZHgK9+QYYjO0J6yPFQ9dg8r4u+Wr0VBl1RB1/tSf2KBDQ+UZicdDA?=
 =?iso-8859-1?Q?L0PYn7q7dTZ2LbkSzqxjSh3k+L0cpbhr/gWM0D61fR1+ddWaK9B+2bn3pD?=
 =?iso-8859-1?Q?QtiYIPnF3Q/Dg4B9lMVQJisNEUf38fsCgEX2GWxDmiUaFjs6S/lD21Oncs?=
 =?iso-8859-1?Q?YGva2t775XYiEqZr9piZmhaPlJhGSZqM8gnbIA1B8paRWEV27wmFyGlNwR?=
 =?iso-8859-1?Q?5tjCUsu0jLIINz8yQYOvJxFApZ7s/u1eJjCRQKIxdzTEwKYrhgfczWdNsK?=
 =?iso-8859-1?Q?ZxnPQdv6esoN4taaPiRk+h/662tB+LdCdruwVcfRERv13Z1JIq4I7TeWSJ?=
 =?iso-8859-1?Q?cchHlk/1eDL8ICh+T1Du5FO4K1WgB4lJk5MPCs77P4bBRxz3cZXSPKDGtM?=
 =?iso-8859-1?Q?v4M0xSoz1t/SIc1n5MXGw8oNiewcdE3Ix61tf/j4PD+EST69nNiAlcqB0f?=
 =?iso-8859-1?Q?Vsxl/dxsDHVlMCs17Ha7tS5eULXgL6zetpD/wgYb52PP3K52RlCOV1FUHI?=
 =?iso-8859-1?Q?vlsySLR0ra5s45qt4k5rbhbqbG/yc3B5D6HAO1QreahBLY9a9dIEKRsqfw?=
 =?iso-8859-1?Q?cEIqf85iNGzGHohMDNVw9ZG38fcVU2NpsxBeJCO8bcvXBJgdwTZAXRIy0N?=
 =?iso-8859-1?Q?Fb5HTafp3A=3D=3D?=
X-Exchange-RoutingPolicyChecked: JfuxSNY6B9ozJaDcKaWjSnZcfgRxvlTjDOvxVj+NDUW3IYW34o7XjuTrTu5BdRyJ8giL+8VVu7hI0l2NPWLZMSqyhj41fAUrdeJtiYyoyERN6i/oOP4j9FqGDNe/9l83rA2PHEfmL1z1QRitVrE8GFkHworukv1HZbsvgr6A80Omb1B0my0aiAWqjzAvD/DG5zPl7dVuNPfBXgdM5zTUPPvcwIRempzUd4kjBme+H8Ve1UNHsGYvbh6C63RVxdHQkAo32qFTUOWiNsEWMpnWikOFxNNT+VObtaU63N3tMaRlVa/YWwocCHy71UCtGXCKu2dWi0U/08RVX/OWffnQfg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da7b3b0-9b08-4036-f20b-08decaed77b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 14:50:39.8456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qv9gpM4C7iQ/By5AK9JXv9KTuJom1A/PxASPEVqf5tmw/+tKN4N1XhsmTDeva6YPP9WaBZHeQmqjgpQ/ZyRvHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6213
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 13.1% improvement of fio.write_iops on:


commit: 14f9161e872072075284b8afa4c3f929e199a0f6 ("btrfs: don't force DIO writes to be serialized")
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
	rw: write
	bs: 4k
	ioengine: falloc
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260615/202606152223.d5cf620b-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/falloc/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/write/lkp-icl-2sp9/128G/fio-basic

commit: 
  9bce95edb1 ("btrfs: move large data folios out of experimental features")
  14f9161e87 ("btrfs: don't force DIO writes to be serialized")

9bce95edb1b4d280 14f9161e872072075284b8afa4c 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      6154           +13.1%       6960        fio.write_bw_MBps
    464.67           -16.1%     390.00        fio.write_clat_90%_ns
    468.00           -16.1%     392.67        fio.write_clat_95%_ns
    474.00           -15.8%     399.33        fio.write_clat_99%_ns
    458.34           -15.9%     385.59        fio.write_clat_mean_ns
   1575465           +13.1%    1781998        fio.write_iops
    134710 ±  4%      -7.6%     124437 ±  2%  numa-numastat.node1.numa_hit
    134733 ±  4%      -7.6%     124458 ±  2%  numa-vmstat.node1.numa_hit
    156867 ±  2%     -10.6%     140262        turbostat.IRQ
 1.473e+09           -10.6%  1.317e+09        cpuidle..time
    103066 ±  3%     -11.2%      91502        cpuidle..usage
     84.50            +5.2%      88.91 ±  2%  perf-stat.i.cpu-migrations
     80.85            +4.7%      84.65 ±  2%  perf-stat.ps.cpu-migrations
    323.49 ±  2%      -7.4%     299.52 ±  4%  sched_debug.cfs_rq:/.runnable_avg.stddev
    323.01 ±  2%      -7.3%     299.39 ±  4%  sched_debug.cfs_rq:/.util_avg.stddev
    253020 ±  5%      -5.1%     240055 ±  3%  proc-vmstat.numa_hit
    186828 ±  7%      -6.9%     173889 ±  5%  proc-vmstat.numa_local
    273378 ±  5%      -5.8%     257473 ±  4%  proc-vmstat.pgalloc_normal
    156448 ±  9%     -10.3%     140365 ±  6%  proc-vmstat.pgfault
    147056 ± 10%     -10.6%     131405 ±  9%  proc-vmstat.pgfree
      8024 ± 22%     -20.8%       6358 ± 11%  proc-vmstat.pgreuse
     43.66 ±101%     -37.0        6.70 ±199%  perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.exit_mmap.__mmput
     43.66 ±101%     -37.0        6.70 ±199%  perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas.exit_mmap
     43.48 ±101%     -36.9        6.61 ±202%  perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.exit_mmap.__mmput.exit_mm
     43.48 ±101%     -36.7        6.79 ±196%  perf-profile.calltrace.cycles-pp.unmap_vmas.exit_mmap.__mmput.exit_mm.do_exit
     43.48 ±101%     -35.4        8.12 ±206%  perf-profile.calltrace.cycles-pp.__mmput.exit_mm.do_exit.do_group_exit.get_signal
     43.48 ±101%     -35.4        8.12 ±206%  perf-profile.calltrace.cycles-pp.exit_mm.do_exit.do_group_exit.get_signal.arch_do_signal_or_restart
     44.01 ± 99%     -33.8       10.18 ±196%  perf-profile.calltrace.cycles-pp.exit_mmap.__mmput.exit_mm.do_exit.do_group_exit
     43.48 ±101%     -33.2       10.31 ±163%  perf-profile.calltrace.cycles-pp.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
     43.48 ±101%     -33.2       10.31 ±163%  perf-profile.calltrace.cycles-pp.do_exit.do_group_exit.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop
     43.48 ±101%     -33.2       10.31 ±163%  perf-profile.calltrace.cycles-pp.do_group_exit.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64
     43.48 ±101%     -33.2       10.31 ±163%  perf-profile.calltrace.cycles-pp.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
     43.48 ±101%     -33.2       10.31 ±163%  perf-profile.calltrace.cycles-pp.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
     26.09 ±111%     -21.1        5.00 ±200%  perf-profile.calltrace.cycles-pp.zap_present_ptes.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas
     12.03 ±120%     -10.4        1.61 ±208%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range.__zap_vma_range
     12.03 ±120%     -10.4        1.61 ±208%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
     12.03 ±120%     -10.4        1.61 ±208%  perf-profile.calltrace.cycles-pp.tlb_flush_mmu.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas
      9.05 ± 94%      -9.0        0.00        perf-profile.calltrace.cycles-pp.folio_remove_rmap_ptes.zap_present_ptes.zap_pte_range.zap_pmd_range.__zap_vma_range
      4.48 ±102%      -2.1        2.34 ±150%  perf-profile.calltrace.cycles-pp.asm_exc_page_fault
     43.66 ±101%     -37.0        6.70 ±199%  perf-profile.children.cycles-pp.__zap_vma_range
     43.66 ±101%     -37.0        6.70 ±199%  perf-profile.children.cycles-pp.zap_pmd_range
     43.66 ±101%     -37.0        6.70 ±199%  perf-profile.children.cycles-pp.zap_pte_range
     43.66 ±101%     -36.8        6.88 ±193%  perf-profile.children.cycles-pp.unmap_vmas
     44.01 ± 99%     -33.8       10.18 ±196%  perf-profile.children.cycles-pp.exit_mm
     44.19 ± 98%     -33.7       10.46 ±190%  perf-profile.children.cycles-pp.__mmput
     44.19 ± 98%     -33.7       10.46 ±190%  perf-profile.children.cycles-pp.exit_mmap
     43.48 ±101%     -33.2       10.31 ±163%  perf-profile.children.cycles-pp.arch_do_signal_or_restart
     43.48 ±101%     -33.2       10.31 ±163%  perf-profile.children.cycles-pp.exit_to_user_mode_loop
     43.48 ±101%     -33.2       10.31 ±163%  perf-profile.children.cycles-pp.get_signal
     28.12 ±105%     -23.1        5.00 ±200%  perf-profile.children.cycles-pp.zap_present_ptes
     12.03 ±120%     -10.4        1.61 ±208%  perf-profile.children.cycles-pp.tlb_flush_mmu
     12.21 ±117%     -10.3        1.88 ±176%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
     12.21 ±117%     -10.3        1.88 ±176%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
      8.87 ± 98%      -8.9        0.00        perf-profile.children.cycles-pp.folio_remove_rmap_ptes
      4.84 ±101%      -2.1        2.70 ±143%  perf-profile.children.cycles-pp.asm_exc_page_fault
      4.13 ±107%      -2.0        2.15 ±158%  perf-profile.children.cycles-pp.handle_mm_fault
      4.13 ±107%      -1.9        2.24 ±153%  perf-profile.children.cycles-pp.do_user_addr_fault
      4.13 ±107%      -1.8        2.34 ±150%  perf-profile.children.cycles-pp.exc_page_fault
     19.24 ±114%     -17.5        1.79 ±185%  perf-profile.self.cycles-pp.zap_present_ptes
      8.70 ±101%      -8.7        0.00        perf-profile.self.cycles-pp.folio_remove_rmap_ptes




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

