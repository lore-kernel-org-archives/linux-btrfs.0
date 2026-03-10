Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4849B34404A
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 06:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125027; cv=fail; b=q4KBxhd6w5y8YQrZcwjWH9NTonaV7NHuG25JHcIDp7EJJfsaKkY96EJ//OfAtuKwkkF8PmXbFyo5MLNy0ZzpMv+a3zz0jrCsRViU+8F4V+zOITR6H+/TjdVU8pjmNPG9Q0qK3r4EBCICgw4q1ahbbXx7L3CpsO66bfVNMtgE+uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125027; c=relaxed/simple;
	bh=NIIQO8ar1YlR98uJeDxfwB8Wkwe/xPoQa6R4glzihrM=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tDhayBfGJRZLOUJF5fwwPIMet0Zi6ywd5AoQrwygXZbVHRsIEdR/VuF1KhROSOJ2Tl3M9pglcWi0LNcqnzW4d/pr+JY68GP5mKFPJXN6GMKnPpsig2TUU+fUkyincpdWXnTkcT9cQweA9WoecOaio64e2uOJKz8dP9yLqQRClxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PcUtEHic; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PcUtEHic"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773125024; x=1804661024;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=NIIQO8ar1YlR98uJeDxfwB8Wkwe/xPoQa6R4glzihrM=;
  b=PcUtEHicTvCBz9Yj4Vgvg+cPY5fYLY7zlc5+ajfZIkJCIcm0CwyZuCFj
   aKLhcd3g1/1tScSkZai99ts1j0SFY5fDqW6pAcGdrLhs4cRAfwQBecIUN
   r5TuKlX+DgRdmohYuZJ9R/vmJAQUojmNeNVDAgXgYmlT3uu0C1V91eviI
   94mgr42kczPUEZFnjvILLGpVesG8DkSMwDlFCFfTq4aEAS64KYP5yz0wN
   43Q/FIRHYktKZ4qdQO6nMluwwRKi4Pe2SUi19p1tj2gBv8QyzsuXdN6uK
   y3+bjz9f7ALPqWf1R8z4gmNhJstETG5OYVbrkbpDY5JYKPuBg8VaXBPNa
   w==;
X-CSE-ConnectionGUID: mE3slLG8QGOn/7Vaaqe27g==
X-CSE-MsgGUID: jnCYVQXtRpink17q+V6ykw==
X-IronPort-AV: E=McAfee;i="6800,10657,11724"; a="91546278"
X-IronPort-AV: E=Sophos;i="6.23,111,1770624000"; 
   d="scan'208";a="91546278"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 23:43:44 -0700
X-CSE-ConnectionGUID: Snfoq0jySESyzeo8woChcQ==
X-CSE-MsgGUID: sZljBsFhRpiu3PCJBfDuPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,111,1770624000"; 
   d="scan'208";a="219139783"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 23:43:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 23:43:42 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 23:43:42 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.12) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 23:43:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1tiodY49/5fAjmkOQ/u2q0Pfr8xfLRenpw9Kouf95yhFt1SVh7i991SbUVt9da96te+pJpEOJ6zmHb7knD5nEhWYJOKy1q3+pFdAX/vTbE8k1kWfVkEYn1Bs9sPEeNifWGwDMkAnqshLRLgqxev+5ADOH6uOZaFKVKubgerehJ7lEvDm/K/bVaMbJnTB1M7NQaJWlj6EHoS+bfG7lOTLPX52OemlE7VE7DbKoZ56Ri6lQgn6DacJirJhvavqxQSxuuDQkpbmLr0bnoCE+L50nT5+mUSgNNOTNfZ5NRKy/4DxFRrUaZpAPBCczWpczHGnbiNAj/MVUoW7E0YXg9NBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RGWSHxLLREP9h8GwLqSgBgyc+D3mArj7UoB0YyuE+I=;
 b=kOddhEtwH2XMsKP0gBDjzD5LYKstzVkFT9nMcbShTlWO+9qP+fOGfeCF/fLL6trKRJt2xefFxe9QXQIUZgtGBVvqdvy/Pq5IVnoysTje/VyEwspc7OFhtm9IjrXiYd+XB+r3HMAOV7mq5DAuKgMCmz0fu53LqvADYXpQ+LEAnahZIWU2WKhWaob07AmwAFySESN4aN8LH/9wr07CJ5UxM9Fr+P6qE9UuRYFNBcPCp5nZAxRJ5xOHrKH+rMfyUOXRQUKT/XtGfZr9nHVBUPangepn4prlpTEQUFfRUMxiijfnLBo5LuApJjEvHknlduvr3sAlkzNDCeQmpXT2/O2P3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR11MB4033.namprd11.prod.outlook.com (2603:10b6:405:78::25)
 by CH8PR11MB9457.namprd11.prod.outlook.com (2603:10b6:610:2c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 06:43:40 +0000
Received: from BN6PR11MB4033.namprd11.prod.outlook.com
 ([fe80::2c28:2983:2947:24b1]) by BN6PR11MB4033.namprd11.prod.outlook.com
 ([fe80::2c28:2983:2947:24b1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 06:43:40 +0000
Date: Tue, 10 Mar 2026 14:43:33 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Qu Wenruo <wqu@suse.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-btrfs@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH v2 3/4] btrfs: move larger data folios out of
 experimental features
Message-ID: <202603101405.288f83f3-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0d8fe02f58ccbc0c53714ea45b0a4303f2ee8206.1772162871.git.wqu@suse.com>
X-ClientProxiedBy: TPYP295CA0009.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:9::8)
 To BN6PR11MB4033.namprd11.prod.outlook.com (2603:10b6:405:78::25)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR11MB4033:EE_|CH8PR11MB9457:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d57ef44-9492-4633-4e51-08de7e705db7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: GMbT2tpTAELXRLAA9dGicf4XiQzzS5J/6cUibYYrzwCK2bhyaFF1Il/7hScs/eCo5gUA3Fx5EaqS+oGfpy1ivcstSf5rCXmt8hwoherfS0fCoBH+veatOsZvCgaEGmfM9tFDQy1ITtkOgd6lpX69QxuISTSUJCVvR0ip0lANXsKMvnYyqsScISwrN2kldypcMbpVqMRzsx8wU9tBDyB4OEVX/dgHbGTxFrzEOe9eJ10DZHqiVF2UfFwborKBCczf5wOJrEyXYjau8stpN2EFRAjzHdqMO5Chy8/NkEU5kUOfH47250850WQ6ne2spue4NusJMdVA2e00y/gyL1Y4Zp2nS5VCV/AP9uaAkCao4XWaEXYr9H1hPVlVJFD0RS+63Msa2b6Gmqxfk1irsNsO+sXuLg7v1uUGxxK9OXbHBxWNN2axQbmfyVGO44YWT2b6JZk2FIk4tpx3LohHnGsOKuSc8Du8V2mNezpk6UR4P7i70XZVN5EdEBQUidfl/baXN3gl+pMkN3U3u2+YF4ubHo0EPRArHil9sacnyMIjDmPu2j+g3zr8kzE5z0YZuC6h+nvIlyVVoemOp7Dfmh98j6sLEFXMtwev1Z0QZA0z+GsZHiwrMY2RAvxNSnPZ5usG62ppaS0Uu9JxKIqoNnvIipE3ETSAbA9tjexJRqxeekxhBCtWtPSeKiH7k+iX9y4B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4033.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z6n3ceFbgNXBejAGcTQr35HPznYAAUGUCEroPeslovKc0uHoMQ8P5zVBoc+4?=
 =?us-ascii?Q?VdMDbq9p3jlvn1U94azgjchodw+fBKkoc34AIEjgVvvnLJyfKGNjoPiWh+LG?=
 =?us-ascii?Q?ZRJ6yhDUSgPKZZljhJN+oe1/28lyBSYwJNssXSL00PTu3Fedi2BZfZzKcH8V?=
 =?us-ascii?Q?V9nYQnUo60x93a8xMKJhOJdqGgavBBS27HUvOOo+sur97iB1tlOFiWgsNJ9T?=
 =?us-ascii?Q?haohKNhAzERfd050JGMWd4dQG3x/1ImF7nAHgyPp/nPmTLKqmrbjtoJTMvPO?=
 =?us-ascii?Q?uKIdM9uIpUEpaO2gbuFCK6zJ3AupHo8Cc3UaRsRRUB5YyIqBjCkSu34GaeHI?=
 =?us-ascii?Q?7yi3IHLOvhaoYTe8W9y4I04Sy9/Wry5KoB9RQMGKq3c1h82dgw/uN29Qz/b+?=
 =?us-ascii?Q?y2GU85LtW2uHfyt+j2v2AO8fTzK8JYlAMhwMO/mv0vrDHg867tgKYbFzCMqb?=
 =?us-ascii?Q?mNeBi996/aSUtE/eUlin0A9Vlihb0ForZeIx/NjGT4/nxyq/jrXOO+v1Kc8k?=
 =?us-ascii?Q?qJlpOQQXYg/VC0Yhxj530GjFKPGH9KnJgnVF7Go8KnKw1xvEG3Lji+dp4h5C?=
 =?us-ascii?Q?wRkpJ9OkLIyGOVc93KpsTwsJwcw6vPIW0PK/Jfkls9rkmKgrEz+vwNZK0vyU?=
 =?us-ascii?Q?ve7upP3lkJUl3/akrBPWwRF4jO/AHo3xa56BtDt9iwNQnyrx95p0iSta6FXr?=
 =?us-ascii?Q?7DWW2ELjcgn8YLivOB7H+cZqgY0XtOl+oDudsvBqyBwgNvBlT86R+AXB6vCh?=
 =?us-ascii?Q?5cmH0aDwxO0GdkMP/60sjhZMZZSxiIZ/g6xmMq6a69pNn1OcERea9o83Vqps?=
 =?us-ascii?Q?7FoAZo5UM34j+thgoktroWOULCFGc8D5nk3LPdJsC1zaCvszwuMuefkL9EBs?=
 =?us-ascii?Q?zn6RjxUIfGgX2EKe6pj1jOX1xrTY0fxtn7meQnpgM6bW8PTGlrpOw8wtvJc9?=
 =?us-ascii?Q?jQTA9mYRIMwWcg6AjMCZj1eZb30EAUtSZXQMP9ZTOvdGh2hU/R1maR1r5dk5?=
 =?us-ascii?Q?Jz2NBKyoQRCOdRXSB++WQjQKgNQ5yjaOHfOvu9l4hd7ejQEFRbkEYbQM4ALi?=
 =?us-ascii?Q?KKXi63HbON5es7In5XE4n5ySFhfHLeOAWsGDG2NfJS1xma2fFSrwnBMOrF0V?=
 =?us-ascii?Q?/+9pDcbe9AWvoglPg3dtiD6q9z+8UmA5HUYDoKrxC0ALwZI1jO3rKsHKgdW6?=
 =?us-ascii?Q?WAf2wBR5Y7u2zVU1bPnk2XbySLVpfO7H0TLYeEaqAf1/FsecQc0od6C6a0M6?=
 =?us-ascii?Q?z81YsYZ+Tu4Ewt9z8MTHftOh9C6mFeMHSobvYKz7WTef3LySh/1Dc2alayvS?=
 =?us-ascii?Q?06J7MvoB9lKp3+IEiUE2mMD60i0eQa0ev8Zd5IwMdYXpq/5i/hc7JTvMMFLQ?=
 =?us-ascii?Q?hUKrEKXqgmuTULm1HhBg3mYzELHr2TKR7/Mxw9OzShrNkOpPW+Y5hLcYE/X4?=
 =?us-ascii?Q?1KDN189Y5D4DvFp7b5HhF7PuVkdIv8i31HbQeSLk+L8fQj/eGSg3FEbLIioh?=
 =?us-ascii?Q?Jdo/qDUEj5OBsJ4cZr9bpCQ546fTMFtCpNEHgoLJJAYbd31jFsyhwB1UG9qD?=
 =?us-ascii?Q?Y8NBE/T3XgUjfSU48nbGpjUp9uQ4Cw+cbAhSkkOHSwk7Qn9CWennKU7H+HFw?=
 =?us-ascii?Q?A8cTYVGjiT5Fx9s+RNc2lkK1CuzPog1lfghTZPjtSl2zGypzJ3sMRmfbXszQ?=
 =?us-ascii?Q?bxcnOyAVNWsMkYZ5786YTZUUIQ8lyrF2nlmXmlms0xsuEJFQmFCnKR1c2v+1?=
 =?us-ascii?Q?LJ6spNBMPg=3D=3D?=
X-Exchange-RoutingPolicyChecked: RX5qKEQK1YGHYJn7eRt+/d9Z2vYQZx7RvnkYshBukbvq1Yv5FRYzU6Y+ozG9SKHVV/NyW5cWqy3F0TAER3Rp3kbWeOMMlO5Vl7zw8Bp+o3c8czNOgm1N5WQSX56OLL0uK9N4sghpQNy8hfJ7bvSJoZ7W9vJq4LcDhy+InGZCLHJZtwvQl+y0AhXZx/YunfAjvz7+0zpRVrOlBD+8hW3rFGoZb2JhBG/umi/m2EoqBFBCkiNgZ+9vplYaXtxuFOsP62vozm3QhzUvYbu+lMQYhjkg2vxRaLQABqx7Q5Ch+mUfaGMrLTVvlXtsEhNrnM8t4EtON1Nr3y1wz9KI2B6TJQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d57ef44-9492-4633-4e51-08de7e705db7
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4033.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 06:43:40.8532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5coEeNxCCT3bRBWCdQvYtCC/Lq8vdpG+bbqQO89KUHMSQn9uL7x7ibFYtE8SGV7iS2U2R8tyPvea3Xf2/T+rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR11MB9457
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.btrfs.052.fail" on:

commit: 50bb0fb60d1d55c7447535d17081ea009700cfd7 ("[PATCH v2 3/4] btrfs: move larger data folios out of experimental features")
url: https://github.com/intel-lab-lkp/linux/commits/Qu-Wenruo/btrfs-drop-2K-block-size-support/20260227-113649
base: https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git for-next
patch link: https://lore.kernel.org/all/0d8fe02f58ccbc0c53714ea45b0a4303f2ee8206.1772162871.git.wqu@suse.com/
patch subject: [PATCH v2 3/4] btrfs: move larger data folios out of experimental features

in testcase: xfstests
version: xfstests-x86_64-63a29724-1_20260218
with following parameters:

	disk: 6HDD
	fs: btrfs
	test: btrfs-052



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 8G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603101405.288f83f3-lkp@intel.com


2026-03-06 18:12:00 cd /lkp/benchmarks/xfstests
2026-03-06 18:12:00 export TEST_DIR=/fs/sdb1
2026-03-06 18:12:00 export TEST_DEV=/dev/sdb1
2026-03-06 18:12:00 export FSTYP=btrfs
2026-03-06 18:12:00 export SCRATCH_MNT=/fs/scratch
2026-03-06 18:12:00 mkdir /fs/scratch -p
2026-03-06 18:12:00 export SCRATCH_DEV_POOL="/dev/sdb2 /dev/sdb3 /dev/sdb4 /dev/sdb5 /dev/sdb6"
2026-03-06 18:12:00 echo btrfs/052
2026-03-06 18:12:00 ./check btrfs/052
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 lkp-hsw-d01 7.0.0-rc1-00110-g50bb0fb60d1d #1 SMP PREEMPT_DYNAMIC Sat Mar  7 01:56:32 CST 2026
MKFS_OPTIONS  -- /dev/sdb2
MOUNT_OPTIONS -- /dev/sdb2 /fs/scratch

btrfs/052          [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//btrfs/052.out.bad)
    --- tests/btrfs/052.out	2026-02-18 09:47:02.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//btrfs/052.out.bad	2026-03-06 18:12:03.421371379 +0000
    @@ -91,553 +91,5 @@
     23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
     *
     30
    -0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
    -*
    -2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
    -*
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/btrfs/052.out /lkp/benchmarks/xfstests/results//btrfs/052.out.bad'  to see the entire diff)
Ran: btrfs/052
Failures: btrfs/052
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260310/202603101405.288f83f3-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

