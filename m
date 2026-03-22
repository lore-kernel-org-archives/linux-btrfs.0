Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D74279DA6
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Mar 2026 10:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774174836; cv=fail; b=upP5mUHw6UBzjPHON4PCJFMTCRDYSMFXERz8f/CNvg8dZU1YTEvD1fuVgraNMdtd5bVe/aeheabGiWxqVrCptfVwS0Tdy29YeMLYmbLtBtd0b5uUpoOwf7kDZmnBgazoKWA3c9BjEauFZGgpOQ66tF0EPE7kxvIlLt6dtk9t1eg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774174836; c=relaxed/simple;
	bh=njKU7p22BYZcngUXvAjYk7NX8Tdj3KBiJ4d8lfKGsGY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=ocbVfoPo8ZlaEukWvJUPRbDe3H/sp7PDY52vBr558t8ff16QDd/LO7bB2Awe/Rl+zNE+2eL9YH4TY//Xtl4lHm8Necpz/I9bUac47MR6HfioEKYA2UbgpQTEf3fNfPu9WbQBJNa6p2GUW+R9dLfMBTZD/ZccIXslDUcDYtodeeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SExlNSYX; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SExlNSYX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774174834; x=1805710834;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=njKU7p22BYZcngUXvAjYk7NX8Tdj3KBiJ4d8lfKGsGY=;
  b=SExlNSYXbLQAZOg5hxEh7MQg7HcMkdorURqbMM7t03qshqyI9FNMvGiY
   gJSBuAhk05YigPO3RI/XrhB2CN3CFSCZd788v9JBy5R41ouKKiGoPPXCS
   +kmGIXgcpJGTrroij5/L5KDE8Rgl5wI8DOoW1sV2SK6eDNYDmonFBNhbn
   72IIS4ZodmR4N2F68ga4Jlr+QGiVlxXkzYpL/EMLEf67QBeJUARNQlQNN
   oTUDEb99qAm5VkMjMIvs4TAIYX1TQ/x1f8ZkBD4HBX5Dt66rPEz+xMeLE
   VmmMVYEpYo2KrFrA1S55dPZr86njhThL6eP/TuCl5UGa56YaqJQGLJIIj
   A==;
X-CSE-ConnectionGUID: t4MRj3xkQdyuc5Pqja6+qQ==
X-CSE-MsgGUID: pOwDt7yURgOevVjO1HGlUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11736"; a="97821916"
X-IronPort-AV: E=Sophos;i="6.23,135,1770624000"; 
   d="scan'208";a="97821916"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2026 03:20:34 -0700
X-CSE-ConnectionGUID: gxjLcsA4QeS7zykTOMWUAA==
X-CSE-MsgGUID: nu6LyUfeS3mrqPXzGsJSRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,135,1770624000"; 
   d="scan'208";a="220982210"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2026 03:20:33 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 22 Mar 2026 03:20:33 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 22 Mar 2026 03:20:33 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.54) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 22 Mar 2026 03:20:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lL44m4e2Y8ojdYqg3qGhit3ckmpMg0z5OuiK/XEkZxhTatSEFg9muRmBwdfoUl9ew7G63nxfaUcNM6otPdRqZRNn9JaBd2eJVgwe0skM03FOCixHlwEWic9WQ8EiFa/3Epc8be83Vm/cSWZfrAJE6NIkL8Qvgz++gjVYAvVeJJhiiGSMugmX7gLx8FuTz5YrMzw6IRGeBrJnOfbTHtKaOHPUBX6Oc1YcvTCxiwn658CfDOBzqYSWykXVML8vGocycACbg019oU2Z3QVawxABQgGtZ5Dgyhoomb1RRuW91D+z+M6yL0rTWW0F/0EJwL73cLcNVFSzHQK/UHbu2n2gnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3jr/ZvrIB9us7gFjmcE+CDUHt6ssl8ymGeZHL2JHlg=;
 b=O7s1VRlf0qdQ9u+HXfc/R93075//n8xSZTlIqjFcaJWMypk3LlIDZDB9HlvO4+SLlIRYIA9wh9APaPnIz7cZKzQV7MCsRvSOwd0np+Emaxl0GNJ+6MIFq9IIVFcaT8anYTcL5OPTDEvPTghxBo/AVcI+zQx6fwOlpbKyOhLiS0Bqt2NJHpHs3RQ7UWVsRVM4T28+ROZS+vIC/HvfisztT+loHuvGJ6Uk83SkY2weo+bPkzNPtirc5lxIj0PQ/PZN4yZIuKtiYbZDphmaBkaIwxU4n2WWmlAKFf1pGBEYs97BpNdWT2hnppUi+dh+GSywJ6udIZLLr5SLOyISkH8X3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SJ5PPF8622363CD.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::83c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Sun, 22 Mar
 2026 10:20:25 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9745.012; Sun, 22 Mar 2026
 10:20:25 +0000
Date: Sun, 22 Mar 2026 18:20:16 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Leo Martins <loemra.dev@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, David Sterba
	<dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, Sun YangKai
	<sunk67188@gmail.com>, Boris Burkov <boris@bur.io>,
	<linux-btrfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [btrfs]  aed9dfbe32:  fio.write_iops 6.0%
 regression
Message-ID: <202603221745.e399d455-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR01CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::13) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SJ5PPF8622363CD:EE_
X-MS-Office365-Filtering-Correlation-Id: 53f73446-2efa-4ecb-91a2-08de87fca1b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: ooVbuHYCI0kG5cFIVz1eVU4nc7n1Nv69u4NtsUWm+Kj7bsIipmuA0Ndkbku12JCKcABKSC3lbAMTfz0BQT4lA3c8Tu9JIIWs3reiV26NWQhE0GlFsvSimeR0wTvy11boBTVxjeu52Kb7Y2Q9htgVaQkoI+MNYv7orHLyGOGd7mAZ7MC7fZIPLh83syDLXUG/WibFtDcMw+JcGiexi1HD4BQJCHgCcRjtAthMQOj9CbSchxkQ96im7X4dK2MtMjZj9cJKrKnHUH9HFsrLKv9b7H3U04qWyrJs/rkIP4ZGEXLHx023Q1c8/YWb8k0XjQ07vCpW6yc/bN+eSmUr8gBlmYbztcD1C5mEVIpSxDXj1a23Pvhl/1rw3U5604aEqmNfZVUU1XD8uKVbvMz4jtDOFgbBQHgE8Y8sjsF/29kmbVugZK2W5Do/WRHoxqsMz4zxxUA2hnuEkzNKGncDyhwJsMhntuzG2rhFs/1y5PZi2Fi7t6vRGFyUzKuXljmTnq1DozW0frRTELfEC7Keb3JTGK3SbskiDQLQgoaAdnFF7hQswYbHdOE/5ZYja3x060yCxeDogweVLe7ZSyloliLqs7qaPYnEap9H5+xIyaYcio5CkhiJr/MelBVXLuhbD2hE8Sv+N0CbZmHCWSclZAnr6CPGp3xfcJ/ef59IMoRfDYHm2ucRTgJlXnELcprjiAlQRVh4f+o6ttY1qeSyXNiM8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?LZrjk20yl8ANPQ32/Wd+197ULKSLJM7mpqHbJcYmYSX1EnvNG/i9GD62Vk?=
 =?iso-8859-1?Q?5/6Xlt3Xmhryew8j0Yg29ombrduH8LX27Ki11kHxbtxnAcVlMR9slBrpBR?=
 =?iso-8859-1?Q?P/f31vmB/7wTQ2yyQu8XnCcg5FzCbzG/Y7jf5szWm96dIg0Hnl6EIBDrjy?=
 =?iso-8859-1?Q?t+VKUju3/tcuQyAUok9RSP7t2RXbvtXJM8xX/JgGk8HqWEZc4G56se2gfA?=
 =?iso-8859-1?Q?u8wxTLN7PqcZX0uZ2mwXid1LBkSAkZISnJ/RHm/6n5hR2uOlKPtCKNfB66?=
 =?iso-8859-1?Q?qdmM023cgmq/4Z+ZCQVQNWA6+wNMqHgX5yjKfDJ6FavKP6mV7fJKtOgcz6?=
 =?iso-8859-1?Q?fcfV1eSsL7hv+1VDky/3IuDSqfN8nUfpLYuNp8d8Ur9k4Xi8xLgApORwo/?=
 =?iso-8859-1?Q?z9iUBdaxyziPYPdrr9qOnp/uRdKKYRWXNnr/oqrS7EGNnVMP5yQIMTS3Yt?=
 =?iso-8859-1?Q?bnTKcU18M4ywyai7k1UEeaLo26MUXBhvafm2Fn7ofiQdqxaB0Ylxw6QODz?=
 =?iso-8859-1?Q?Bc3GK9v1plxaAUV/X8eKTizVSA23vzqNCBuf5W2tJwgWzUGAcJX1MkiluF?=
 =?iso-8859-1?Q?89vxKqlXFAkegaFBwTPr0pXpQeXkAcLBZNblq550K696rHpji1+R3RSuXi?=
 =?iso-8859-1?Q?vm43ew+n10MvvFmFxEVg6Mc/CHumN3O5Ne7bmEyVoOMl6MHjjbg4u39x7Q?=
 =?iso-8859-1?Q?DImo7nn0iIc3GFE57arR6V/SYDWeku/UC4zPTI05p7TLBqScwDTYbJIEop?=
 =?iso-8859-1?Q?3oyceb9Wt5NydvOtGr9Qmxlr4/w4txWfZ9i/QlGuxVT979Ie2fxXT8JlO6?=
 =?iso-8859-1?Q?YnCxSxmzP0cmLRgqgwizGBiMfNWHZvwgFHbDBnOclSViDKP4Z3dACKYqV/?=
 =?iso-8859-1?Q?w9Vfjha5lHMohwn/WT9DtRPHZGqYbadbPnksKDMTtvp4x0BF6zhU4s57Uv?=
 =?iso-8859-1?Q?Rl+WCgZKboQaLbnIKqxyQfgjfLjEHsSeznNbKzW52K44VpnfuvrzaSnI1f?=
 =?iso-8859-1?Q?bubZe0kqTG58EqPle4CPRJuqjcjIn8U8IDDa5fX+GsrOZZR4UIqLIg4h0I?=
 =?iso-8859-1?Q?+p8jaRRsXWVSFM5VdkE0vrfSUAa01e1Shys5BDUsl5YYBWVdFa1EnVG9Ka?=
 =?iso-8859-1?Q?b8hTR81X6iio1KyKxR0WDu3PULUskbwg8QD8P+eqIAS/ZLP1/CgEEepW9K?=
 =?iso-8859-1?Q?iKCfWWWnKSEPe8c7yIzo1bbAZNL7Tp9xV3fTJ5esNpy5l4lCHPYVpTrabr?=
 =?iso-8859-1?Q?bSNpK9nfynT1jE8QXuTkF17iTzBtbEPbUSmIFSVZb4zMc9rFOzPDRRfGSb?=
 =?iso-8859-1?Q?9FfIIhyL3DwH2/LEBuUWj7MQLzkHw5nxCX6RhKS/fLAoqnC1Nwke5hvbG9?=
 =?iso-8859-1?Q?P4DLcVdWZBihlNvBkA30vI9Y0OHCur5NRVBF5y9ZOMx3VED7erQPbgd+ZL?=
 =?iso-8859-1?Q?+jhRA613nHF9ZKwW6nQhp5xAVx38m4toSXiq/ET5V5qnfS6zGaiPxzfRKH?=
 =?iso-8859-1?Q?TmnAXxeZzHrcroO4Jkfyr1cztYTHbg2mcI4GLYGFrxcBE1UKdRKOrxOcqT?=
 =?iso-8859-1?Q?kbxcgZVFiGZ2oGzmUmdzrqkCOYmUFY9E01eQVzPzsbvjionIzKH/QRIJEz?=
 =?iso-8859-1?Q?Iv9BXwQk1hHBoLRIke/SRshynHHOrdZgj+4RtNbDv5kR4MkSg2Zgqxkdtj?=
 =?iso-8859-1?Q?4rviG3JjUjUrgdfOSJL+D6ibguzm/gSNVKC6aC07wHVlgraYyw5pQz9kgn?=
 =?iso-8859-1?Q?O8y49wY05q2i5isqgS5xOU+yXwaMhTA4NOUCnen9Y0WULEdRSbt9CWIGnO?=
 =?iso-8859-1?Q?HhCPFYAZ8A=3D=3D?=
X-Exchange-RoutingPolicyChecked: CUYsIG9Q8ic+HrTD6ElmqCjXJoGRzYqmwjXt4rDflS4C+9VqwynVD4Fn8EckFL3LkhD7bcXaGVev31tbdfGe3NW+zoDMDD9AZpLL9gbR9Ssfcm83XV4pFx8NkmbzfX86hiOShpakNODVuN/W28AmQXQTj84MyKpu8pmksYPVxzxnrAtJwRpmrQb61clGZARqB4ydafbNeVCigWq2zbR48ilDsY4Qlqs8DkGAnsMrvVPJJDhX5ZQQnke/BLcVeeoF4WNHLmo4w6lT+T+Zl4UTrQo/OIJg1rQaKFLPj9yWBo3XViqRKMjvuT4dq1OeA3C8E+EuYL3WvlDKSBN/zjU9hg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f73446-2efa-4ecb-91a2-08de87fca1b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 10:20:25.0256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VL3m992jJTTgB1Vkx+zruSaWfTAXtt8nOin3C0uxFA/uUIPN1T6uIteuXPmlPx/0NSE0ow5nrvWOK2OWcKFTxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8622363CD
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 6.0% regression of fio.write_iops on:


commit: aed9dfbe32e50cd99a0022529d54a1a9fd035aca ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master b5d083a3ed1e2798396d5e491432e887da8d4a06]

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
	ioengine: sync
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+--------------------------------------------+
| testcase: change | fio-basic: fio.write_iops  8.2% regression |
| test parameters  | bs=4k                                      |
|                  | cpufreq_governor=performance               |
|                  | disk=1HDD                                  |
|                  | fs=btrfs                                   |
|                  | ioengine=posixaio                          |
|                  | nr_task=1                                  |
|                  | runtime=300s                               |
|                  | rw=randwrite                               |
|                  | test_size=128G                             |
+------------------+--------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603221745.e399d455-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260322/202603221745.e399d455-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/sync/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic

commit: 
  711f4cc50f ("btrfs: extract the max compression chunk size into a macro")
  aed9dfbe32 ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

711f4cc50ffd7fb0 aed9dfbe32e50cd99a0022529d5 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.91            +0.8        1.73 ±  8%  fio.latency_1000us%
      0.03 ±  3%      +0.0        0.05 ± 10%  fio.latency_100ms%
      0.01            +0.0        0.02 ± 15%  fio.latency_250ms%
      0.32 ±  3%      +0.1        0.39 ±  4%  fio.latency_2ms%
      0.05 ±  8%      +0.0        0.06 ±  8%  fio.latency_4ms%
      0.05            +0.0        0.05        fio.latency_500ms%
     37.80            -0.8       36.97        fio.latency_500us%
   3850324            -6.0%    3620652        fio.time.file_system_outputs
    568359            -4.0%     545774        fio.time.voluntary_context_switches
    481290            -6.0%     452581        fio.workload
      6.26            -6.0%       5.89        fio.write_bw_MBps
    452608            +2.0%     461482        fio.write_clat_95%_ns
   1460906           +16.4%    1701205 ±  5%  fio.write_clat_99%_ns
    622742            +6.4%     662332        fio.write_clat_mean_ns
   9948994            +2.6%   10203906        fio.write_clat_stddev
      1603            -6.0%       1508        fio.write_iops
      1.66            +6.4%       1.76        iostat.cpu.iowait
      0.99            +6.2%       1.05        turbostat.IPC
      1.67            +0.1        1.77        mpstat.cpu.all.iowait%
      0.01 ±  6%      +0.0        0.01 ±  9%  mpstat.cpu.all.soft%
      0.15 ±  2%      +0.0        0.16 ±  3%  mpstat.cpu.all.sys%
     11917           +38.9%      16552 ±  5%  vmstat.io.bo
      1.07            +6.2%       1.14        vmstat.procs.b
     11584            -2.4%      11304        vmstat.system.cs
 1.554e+08 ±  4%      +9.3%  1.699e+08 ±  4%  perf-stat.i.branch-instructions
   3759835 ±  2%      +6.9%    4019376 ±  2%  perf-stat.i.cache-references
     11649            -2.5%      11353        perf-stat.i.context-switches
      1.03            -8.9%       0.94        perf-stat.i.cpi
 8.214e+08 ±  4%      +9.5%  8.995e+08 ±  4%  perf-stat.i.instructions
      1.06           +11.4%       1.18        perf-stat.i.ipc
      1.07            -6.2%       1.00        perf-stat.overall.cpi
      0.94            +6.6%       1.00        perf-stat.overall.ipc
    513899 ±  4%     +16.5%     598695 ±  5%  perf-stat.overall.path-length
  1.55e+08 ±  4%      +9.3%  1.694e+08 ±  4%  perf-stat.ps.branch-instructions
   3750681 ±  2%      +6.9%    4009862 ±  2%  perf-stat.ps.cache-references
     11611            -2.5%      11316        perf-stat.ps.context-switches
 8.193e+08 ±  4%      +9.5%  8.972e+08 ±  4%  perf-stat.ps.instructions
 2.473e+11 ±  4%      +9.5%  2.708e+11 ±  4%  perf-stat.total.instructions
      4.36 ±  7%      -0.9        3.48 ± 17%  perf-profile.calltrace.cycles-pp.btrfs_buffered_write.btrfs_direct_write.btrfs_do_write_iter.vfs_write.ksys_write
      1.71 ± 33%      -0.6        1.08 ± 33%  perf-profile.calltrace.cycles-pp.btrfs_unpin_extent_cache.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread
      0.87 ± 14%      +0.3        1.17 ± 12%  perf-profile.calltrace.cycles-pp.btrfs_cross_ref_exist.can_nocow_file_extent.run_delalloc_nocow.writepage_delalloc.extent_writepage
      1.18 ± 15%      +0.5        1.66 ± 10%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt
      1.12 ± 15%      +0.5        1.62 ± 11%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt
      0.20 ±141%      +0.8        0.97 ± 18%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.25 ±141%      +0.9        1.11 ± 13%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +0.9        0.90 ± 24%  perf-profile.calltrace.cycles-pp.xas_find.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered
      0.00            +1.0        0.96 ± 24%  perf-profile.calltrace.cycles-pp.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper
      0.00            +2.1        2.14 ± 25%  perf-profile.calltrace.cycles-pp.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work
      0.00            +2.2        2.18 ± 25%  perf-profile.calltrace.cycles-pp.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread
      4.36 ±  7%      -0.9        3.49 ± 17%  perf-profile.children.cycles-pp.btrfs_buffered_write
      1.71 ± 33%      -0.6        1.08 ± 33%  perf-profile.children.cycles-pp.btrfs_unpin_extent_cache
      0.51 ± 65%      -0.3        0.23 ± 18%  perf-profile.children.cycles-pp.folios_put_refs
      0.41 ± 58%      -0.2        0.20 ± 36%  perf-profile.children.cycles-pp.extent_clear_unlock_delalloc
      0.53 ± 12%      -0.2        0.36 ± 19%  perf-profile.children.cycles-pp.tick_nohz_idle_stop_tick
      0.52 ± 12%      -0.2        0.36 ± 19%  perf-profile.children.cycles-pp.tick_nohz_stop_tick
      0.38 ± 15%      -0.1        0.24 ± 27%  perf-profile.children.cycles-pp.hrtimer_start_range_ns
      0.42 ± 20%      -0.1        0.31 ± 25%  perf-profile.children.cycles-pp.filemap_dirty_folio
      0.30 ± 25%      -0.1        0.20 ± 27%  perf-profile.children.cycles-pp.lapic_next_deadline
      0.25 ±  5%      -0.1        0.16 ± 18%  perf-profile.children.cycles-pp.bio_alloc_bioset
      0.27 ± 12%      -0.1        0.18 ± 22%  perf-profile.children.cycles-pp.btrfs_bio_alloc
      0.32 ± 18%      -0.1        0.24 ± 20%  perf-profile.children.cycles-pp.llist_reverse_order
      0.28 ± 23%      -0.1        0.21 ± 27%  perf-profile.children.cycles-pp.unlock_up
      0.02 ±141%      +0.1        0.08 ± 25%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.56 ±  4%      +0.1        0.64 ± 12%  perf-profile.children.cycles-pp.dequeue_entities
      0.38 ± 17%      +0.1        0.48 ± 12%  perf-profile.children.cycles-pp.update_load_avg
      0.09 ±106%      +0.2        0.24 ± 30%  perf-profile.children.cycles-pp.radix_tree_node_rcu_free
      0.07 ± 71%      +0.2        0.23 ± 48%  perf-profile.children.cycles-pp.xa_find
      2.18 ±  6%      +0.3        2.47 ±  8%  perf-profile.children.cycles-pp.its_return_thunk
      0.87 ± 14%      +0.3        1.17 ± 12%  perf-profile.children.cycles-pp.btrfs_cross_ref_exist
      0.70 ± 18%      +0.4        1.10 ± 13%  perf-profile.children.cycles-pp.kmem_cache_free
      0.03 ±158%      +0.4        0.43 ± 13%  perf-profile.children.cycles-pp.__xa_store
      0.03 ±158%      +0.5        0.52 ± 15%  perf-profile.children.cycles-pp.xa_store
      2.24 ±  9%      +0.5        2.75 ±  6%  perf-profile.children.cycles-pp.__irq_exit_rcu
      2.08 ± 10%      +0.6        2.63 ±  7%  perf-profile.children.cycles-pp.handle_softirqs
      0.47 ± 32%      +0.6        1.06 ± 17%  perf-profile.children.cycles-pp.rcu_do_batch
      0.59 ± 25%      +0.6        1.22 ± 11%  perf-profile.children.cycles-pp.rcu_core
      7.26 ±  2%      +0.7        7.97 ±  4%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.00            +0.7        0.73 ± 12%  perf-profile.children.cycles-pp.btrfs_inhibit_eb_writeback
      0.00            +0.8        0.76 ± 37%  perf-profile.children.cycles-pp.xas_free_nodes
      0.00            +0.8        0.79 ± 37%  perf-profile.children.cycles-pp.xa_destroy
      0.00            +1.0        0.97 ± 24%  perf-profile.children.cycles-pp.xa_find_after
      0.65 ±  9%      +1.0        1.68 ± 20%  perf-profile.children.cycles-pp.xas_find
      0.00            +2.2        2.16 ± 24%  perf-profile.children.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.04 ± 73%      +2.2        2.19 ± 24%  perf-profile.children.cycles-pp.__btrfs_end_transaction
      0.30 ± 26%      -0.1        0.20 ± 25%  perf-profile.self.cycles-pp.lapic_next_deadline
      0.32 ± 18%      -0.1        0.24 ± 20%  perf-profile.self.cycles-pp.llist_reverse_order
      0.09 ± 54%      +0.1        0.18 ± 16%  perf-profile.self.cycles-pp.xas_create
      0.19 ± 25%      +0.1        0.31 ± 14%  perf-profile.self.cycles-pp.kick_pool
      0.09 ±106%      +0.1        0.24 ± 29%  perf-profile.self.cycles-pp.radix_tree_node_rcu_free
      0.09 ± 84%      +0.2        0.28 ± 31%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.37 ± 14%      +0.2        0.56 ± 13%  perf-profile.self.cycles-pp.kmem_cache_free
      0.00            +0.6        0.60 ± 38%  perf-profile.self.cycles-pp.xas_free_nodes
      0.02 ±141%      +1.0        1.01 ± 28%  perf-profile.self.cycles-pp.xas_find


***************************************************************************************************

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/btrfs/posixaio/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic

commit: 
  711f4cc50f ("btrfs: extract the max compression chunk size into a macro")
  aed9dfbe32 ("btrfs: inhibit extent buffer writeback to prevent COW amplification")

711f4cc50ffd7fb0 aed9dfbe32e50cd99a0022529d5 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.51 ± 13%      +0.7        1.17 ± 15%  fio.latency_100ms%
     25.06            +0.8       25.87        fio.latency_20ms%
      0.58 ±  7%      +0.6        1.20 ± 14%  fio.latency_250ms%
      1.53            +0.1        1.66 ±  2%  fio.latency_500ms%
   3825693            -8.1%    3515380        fio.time.file_system_outputs
    684007            -5.8%     644492        fio.time.voluntary_context_switches
    478211            -8.1%     439422        fio.workload
      6.22            -8.2%       5.72        fio.write_bw_MBps
  29185365            +5.8%   30889301        fio.write_clat_90%_ns
  39671125           +11.2%   44127573 ±  2%  fio.write_clat_95%_ns
  20074679            +8.9%   21862659        fio.write_clat_mean_ns
  57435038            +3.4%   59383937        fio.write_clat_stddev
      1593            -8.2%       1463        fio.write_iops
      1.66            +8.7%       1.80        iostat.cpu.iowait
      0.99            +7.6%       1.06        turbostat.IPC
      1.67            +0.1        1.81        mpstat.cpu.all.iowait%
      0.01 ± 12%      +0.0        0.01 ±  5%  mpstat.cpu.all.soft%
      0.15            +0.0        0.16 ±  3%  mpstat.cpu.all.sys%
     11874           +52.1%      18056 ±  7%  vmstat.io.bo
   4263635            +5.0%    4477347        vmstat.memory.cache
      1.07            +8.1%       1.15        vmstat.procs.b
     12308            -3.8%      11847        vmstat.system.cs
     10620            -1.3%      10481        vmstat.system.in
 1.534e+08 ±  4%     +13.1%  1.734e+08 ±  4%  perf-stat.i.branch-instructions
     12.94 ±  6%      +2.2       15.11 ±  7%  perf-stat.i.cache-miss-rate%
    497236 ±  7%     +22.8%     610681 ±  8%  perf-stat.i.cache-misses
   3927589 ±  2%      +7.1%    4207861 ±  2%  perf-stat.i.cache-references
     12366            -3.8%      11896        perf-stat.i.context-switches
      1.03            -9.4%       0.93        perf-stat.i.cpi
 8.092e+08 ±  4%     +13.5%  9.186e+08 ±  4%  perf-stat.i.instructions
      1.06           +12.8%       1.20        perf-stat.i.ipc
     12.65 ±  7%      +1.8       14.49 ±  6%  perf-stat.overall.cache-miss-rate%
      1.07            -7.3%       1.00        perf-stat.overall.cpi
      1759 ±  8%     -14.5%       1504 ±  3%  perf-stat.overall.cycles-between-cache-misses
      0.93            +7.9%       1.00        perf-stat.overall.ipc
    509423 ±  4%     +23.7%     630234 ±  5%  perf-stat.overall.path-length
  1.53e+08 ±  4%     +13.1%   1.73e+08 ±  4%  perf-stat.ps.branch-instructions
    495683 ±  7%     +22.8%     608750 ±  8%  perf-stat.ps.cache-misses
   3918083 ±  2%      +7.1%    4196905 ±  2%  perf-stat.ps.cache-references
     12326            -3.8%      11857        perf-stat.ps.context-switches
  8.07e+08 ±  4%     +13.5%  9.161e+08 ±  4%  perf-stat.ps.instructions
 2.436e+11 ±  4%     +13.6%  2.768e+11 ±  4%  perf-stat.total.instructions
      8.49 ±  3%      -3.1        5.37 ± 23%  perf-profile.calltrace.cycles-pp.btree_csum_one_bio.btrfs_submit_chunk.btrfs_submit_bbio.btree_writepages.do_writepages
      7.73 ±  3%      -2.8        4.96 ± 23%  perf-profile.calltrace.cycles-pp.btrfs_check_leaf.btree_csum_one_bio.btrfs_submit_chunk.btrfs_submit_bbio.btree_writepages
      7.47 ±  3%      -2.6        4.82 ± 23%  perf-profile.calltrace.cycles-pp.__btrfs_check_leaf.btrfs_check_leaf.btree_csum_one_bio.btrfs_submit_chunk.btrfs_submit_bbio
      4.57 ±  3%      -1.3        3.23 ± 19%  perf-profile.calltrace.cycles-pp.check_leaf_item.__btrfs_check_leaf.btrfs_check_leaf.btree_csum_one_bio.btrfs_submit_chunk
      1.37 ± 22%      -0.7        0.70 ± 57%  perf-profile.calltrace.cycles-pp.btrfs_get_32.__btrfs_check_leaf.btrfs_check_leaf.btree_csum_one_bio.btrfs_submit_chunk
      1.01 ± 22%      -0.5        0.48 ± 73%  perf-profile.calltrace.cycles-pp.end_bbio_meta_write.orig_write_end_io_work.process_one_work.worker_thread.kthread
      1.12 ± 21%      -0.5        0.62 ± 49%  perf-profile.calltrace.cycles-pp.orig_write_end_io_work.process_one_work.worker_thread.kthread.ret_from_fork
      1.50 ±  9%      -0.5        1.00 ± 23%  perf-profile.calltrace.cycles-pp.alloc_reserved_extent.alloc_reserved_tree_block.run_delayed_tree_ref.run_one_delayed_ref.btrfs_run_delayed_refs_for_head
      0.88 ± 22%      -0.5        0.39 ± 73%  perf-profile.calltrace.cycles-pp.folio_end_writeback_no_dropbehind.folio_end_writeback.end_bbio_meta_write.orig_write_end_io_work.process_one_work
      0.92 ± 21%      -0.5        0.43 ± 73%  perf-profile.calltrace.cycles-pp.folio_end_writeback.end_bbio_meta_write.orig_write_end_io_work.process_one_work.worker_thread
      1.47 ± 10%      -0.5        0.99 ± 24%  perf-profile.calltrace.cycles-pp.btrfs_remove_from_free_space_tree.alloc_reserved_extent.alloc_reserved_tree_block.run_delayed_tree_ref.run_one_delayed_ref
      0.86 ± 22%      -0.5        0.39 ± 73%  perf-profile.calltrace.cycles-pp.__folio_end_writeback.folio_end_writeback_no_dropbehind.folio_end_writeback.end_bbio_meta_write.orig_write_end_io_work
      1.44 ± 11%      -0.5        0.97 ± 23%  perf-profile.calltrace.cycles-pp.remove_free_space_extent.btrfs_remove_from_free_space_tree.alloc_reserved_extent.alloc_reserved_tree_block.run_delayed_tree_ref
      1.00 ± 12%      -0.2        0.79 ±  8%  perf-profile.calltrace.cycles-pp.__folio_end_writeback.folio_end_writeback_no_dropbehind.folio_end_writeback.end_bbio_data_write.btrfs_bio_end_io
      0.72 ±  9%      +0.2        0.94 ±  6%  perf-profile.calltrace.cycles-pp.__push_leaf_right.push_leaf_right.split_leaf.setup_leaf_for_split.btrfs_duplicate_item
      1.24 ±  7%      +0.3        1.56 ± 12%  perf-profile.calltrace.cycles-pp.push_leaf_right.split_leaf.setup_leaf_for_split.btrfs_duplicate_item.btrfs_mark_extent_written
      1.88 ±  8%      +0.4        2.31 ±  5%  perf-profile.calltrace.cycles-pp.setup_leaf_for_split.btrfs_duplicate_item.btrfs_mark_extent_written.btrfs_finish_one_ordered.btrfs_work_helper
      1.55 ±  8%      +0.4        1.99 ±  9%  perf-profile.calltrace.cycles-pp.split_leaf.setup_leaf_for_split.btrfs_duplicate_item.btrfs_mark_extent_written.btrfs_finish_one_ordered
      6.98 ±  3%      +0.6        7.58 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_duplicate_item.btrfs_mark_extent_written.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work
      0.00            +0.8        0.76 ± 21%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +0.8        0.79 ± 25%  perf-profile.calltrace.cycles-pp.xa_destroy.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper
      1.09 ± 18%      +0.8        1.88 ±  9%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt
      1.13 ± 19%      +0.8        1.94 ±  9%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt
      0.33 ±100%      +0.9        1.24 ± 14%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.18 ±141%      +0.9        1.09 ± 18%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +1.0        0.96 ±  8%  perf-profile.calltrace.cycles-pp.xas_find.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered
     10.80 ±  2%      +1.0       11.78 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_mark_extent_written.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread
      0.00            +1.0        1.02 ±  7%  perf-profile.calltrace.cycles-pp.xa_find_after.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper
      0.00            +2.2        2.17 ± 12%  perf-profile.calltrace.cycles-pp.btrfs_uninhibit_all_eb_writeback.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work
      0.00            +2.3        2.25 ± 13%  perf-profile.calltrace.cycles-pp.__btrfs_end_transaction.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread
     19.60            +3.7       23.33 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_work_helper.process_one_work.worker_thread.kthread.ret_from_fork
     19.58            +3.7       23.32 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_finish_one_ordered.btrfs_work_helper.process_one_work.worker_thread.kthread
      9.88 ±  3%      -3.6        6.30 ± 22%  perf-profile.children.cycles-pp.btree_writepages
     11.98 ±  4%      -3.5        8.51 ± 15%  perf-profile.children.cycles-pp.btrfs_submit_chunk
     11.99 ±  4%      -3.5        8.54 ± 15%  perf-profile.children.cycles-pp.btrfs_submit_bbio
     20.26            -3.2       17.04 ±  5%  perf-profile.children.cycles-pp.do_writepages
      8.49 ±  3%      -3.1        5.40 ± 23%  perf-profile.children.cycles-pp.btree_csum_one_bio
      7.73 ±  3%      -2.8        4.98 ± 23%  perf-profile.children.cycles-pp.__btrfs_check_leaf
      7.73 ±  3%      -2.8        4.98 ± 23%  perf-profile.children.cycles-pp.btrfs_check_leaf
      4.68 ±  2%      -1.4        3.31 ± 19%  perf-profile.children.cycles-pp.check_leaf_item
      2.91 ±  6%      -0.8        2.07 ± 23%  perf-profile.children.cycles-pp.alloc_reserved_tree_block
      2.91 ±  6%      -0.8        2.07 ± 23%  perf-profile.children.cycles-pp.run_delayed_tree_ref
      2.38 ±  8%      -0.6        1.81 ± 11%  perf-profile.children.cycles-pp.folio_end_writeback
      2.32 ±  8%      -0.6        1.76 ± 11%  perf-profile.children.cycles-pp.folio_end_writeback_no_dropbehind
      1.67 ±  7%      -0.6        1.11 ± 22%  perf-profile.children.cycles-pp.alloc_reserved_extent
      1.88 ± 12%      -0.5        1.33 ± 10%  perf-profile.children.cycles-pp.__folio_end_writeback
      1.63 ±  7%      -0.5        1.10 ± 21%  perf-profile.children.cycles-pp.btrfs_remove_from_free_space_tree
      1.60 ±  8%      -0.5        1.07 ± 20%  perf-profile.children.cycles-pp.remove_free_space_extent
      1.06 ± 34%      -0.5        0.60 ± 20%  perf-profile.children.cycles-pp.crc32c_arch
      1.06 ± 34%      -0.5        0.60 ± 21%  perf-profile.children.cycles-pp.btrfs_csum_update
      0.99 ± 36%      -0.4        0.56 ± 22%  perf-profile.children.cycles-pp.crc32c_x86_3way
      1.12 ± 21%      -0.4        0.70 ± 21%  perf-profile.children.cycles-pp.orig_write_end_io_work
      1.01 ± 22%      -0.4        0.63 ± 26%  perf-profile.children.cycles-pp.end_bbio_meta_write
      0.69 ± 20%      -0.3        0.40 ± 35%  perf-profile.children.cycles-pp.csum_tree_block
      1.74 ± 12%      -0.3        1.48 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.50 ± 19%      -0.2        0.28 ± 30%  perf-profile.children.cycles-pp.btrfs_comp_cpu_keys
      0.50 ± 22%      -0.2        0.31 ± 24%  perf-profile.children.cycles-pp.btrfs_submit_bio
      0.32 ± 27%      -0.1        0.18 ± 49%  perf-profile.children.cycles-pp.__rq_qos_throttle
      0.35 ± 19%      -0.1        0.26 ± 25%  perf-profile.children.cycles-pp.rcu_gp_fqs_loop
      0.13 ± 24%      -0.0        0.08 ± 22%  perf-profile.children.cycles-pp.blk_mq_free_request
      0.08 ± 56%      +0.1        0.15 ± 17%  perf-profile.children.cycles-pp.rwsem_down_read_slowpath
      0.05 ± 52%      +0.1        0.15 ± 50%  perf-profile.children.cycles-pp.lru_gen_add_folio
      0.22 ± 25%      +0.1        0.33 ± 19%  perf-profile.children.cycles-pp.__push_leaf_left
      0.12 ± 29%      +0.1        0.23 ± 31%  perf-profile.children.cycles-pp.radix_tree_node_rcu_free
      0.16 ± 29%      +0.1        0.29 ± 14%  perf-profile.children.cycles-pp.refill_objects
      0.08 ± 62%      +0.2        0.23 ± 24%  perf-profile.children.cycles-pp.__refill_objects_node
      0.24 ± 20%      +0.2        0.40 ± 23%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.06 ± 48%      +0.2        0.23 ± 21%  perf-profile.children.cycles-pp.xa_find
      0.33 ± 12%      +0.2        0.58 ± 14%  perf-profile.children.cycles-pp.xas_alloc
      0.11 ± 24%      +0.3        0.39 ± 20%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.88 ± 14%      +0.3        1.16 ±  9%  perf-profile.children.cycles-pp.xas_store
      0.40 ± 21%      +0.4        0.79 ±  9%  perf-profile.children.cycles-pp.xas_create
      1.88 ±  8%      +0.4        2.31 ±  5%  perf-profile.children.cycles-pp.setup_leaf_for_split
      0.04 ± 47%      +0.4        0.48 ± 11%  perf-profile.children.cycles-pp.__xa_store
      0.76 ± 12%      +0.4        1.21 ± 19%  perf-profile.children.cycles-pp.kmem_cache_free
      0.06 ± 51%      +0.5        0.52 ± 11%  perf-profile.children.cycles-pp.xa_store
      6.98 ±  3%      +0.6        7.58 ±  4%  perf-profile.children.cycles-pp.btrfs_duplicate_item
      0.52 ± 10%      +0.7        1.20 ± 16%  perf-profile.children.cycles-pp.rcu_do_batch
      0.62 ± 15%      +0.7        1.34 ± 14%  perf-profile.children.cycles-pp.rcu_core
      0.00            +0.7        0.75 ± 26%  perf-profile.children.cycles-pp.xas_free_nodes
      0.00            +0.8        0.77 ±  8%  perf-profile.children.cycles-pp.btrfs_inhibit_eb_writeback
      0.00            +0.8        0.79 ± 25%  perf-profile.children.cycles-pp.xa_destroy
      2.22 ± 13%      +1.0        3.19 ±  9%  perf-profile.children.cycles-pp.__irq_exit_rcu
      2.03 ± 12%      +1.0        3.00 ± 10%  perf-profile.children.cycles-pp.handle_softirqs
     10.82 ±  2%      +1.0       11.81 ±  4%  perf-profile.children.cycles-pp.btrfs_mark_extent_written
      0.00            +1.0        1.02 ±  8%  perf-profile.children.cycles-pp.xa_find_after
      0.59 ± 11%      +1.2        1.80 ±  9%  perf-profile.children.cycles-pp.xas_find
      0.00            +2.2        2.17 ± 12%  perf-profile.children.cycles-pp.btrfs_uninhibit_all_eb_writeback
      0.01 ±223%      +2.2        2.25 ± 13%  perf-profile.children.cycles-pp.__btrfs_end_transaction
     19.60            +3.7       23.33 ±  3%  perf-profile.children.cycles-pp.btrfs_work_helper
     19.59            +3.7       23.33 ±  3%  perf-profile.children.cycles-pp.btrfs_finish_one_ordered
      0.70 ± 21%      -0.3        0.37 ± 28%  perf-profile.self.cycles-pp.__btrfs_check_leaf
      0.84 ± 13%      -0.3        0.56 ± 22%  perf-profile.self.cycles-pp.crc32c_x86_3way
      0.46 ± 34%      -0.3        0.21 ± 46%  perf-profile.self.cycles-pp.check_leaf_item
      0.46 ± 18%      -0.2        0.26 ± 32%  perf-profile.self.cycles-pp.btrfs_comp_cpu_keys
      0.05 ± 52%      +0.1        0.12 ± 39%  perf-profile.self.cycles-pp.xa_load
      0.11 ± 26%      +0.1        0.19 ± 25%  perf-profile.self.cycles-pp.btrfs_clear_extent_bit_changeset
      0.00            +0.1        0.10 ± 40%  perf-profile.self.cycles-pp.btrfs_inhibit_eb_writeback
      0.05 ±118%      +0.1        0.17 ± 22%  perf-profile.self.cycles-pp.xas_create
      0.08 ± 62%      +0.1        0.21 ± 23%  perf-profile.self.cycles-pp.__refill_objects_node
      0.02 ±223%      +0.1        0.16 ± 34%  perf-profile.self.cycles-pp.__call_rcu_common
      0.03 ±102%      +0.3        0.30 ± 21%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.00            +0.6        0.59 ± 25%  perf-profile.self.cycles-pp.xas_free_nodes
      0.02 ±144%      +1.1        1.10 ±  8%  perf-profile.self.cycles-pp.xas_find





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

