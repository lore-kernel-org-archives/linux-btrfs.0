Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AEB43D4EC
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 14:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785420519; cv=fail; b=cUA+Y/Szp8pqToq1AbPHLRbs60QaRRrH9Tj5dmtQKhSLFwfkTc3GQExZl1aZh6keVvnyO9LlplPLuzLHIVTSmSiineAfKrX4DGycHuSiEUxc9uaJIB0WkoSNbkPy1lQWtdlSuw/gfJXNA8oYV+gHyW7JJmqD/CNEg5hzsYERj3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785420519; c=relaxed/simple;
	bh=uArtQshFddk7WZIktVXJmF3nX7uAFfx3ly7O7lMBUHw=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BJYSkbTy876/jN5G+Row2P1gTLDPkdC/yWtTexd4dUfJ9WzRb1s4nkIpV/KFSlPZmCWgHORKHn1k/i6v1EqBrS4ITJXPXljR8o1/vWDtwgBl//bBOA2TRdR74w6zeFTLBZDv3aFsS7PM/jaRK4ilbYk7c7yYXXPabLkFBVxBrsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YE+VX6sx; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YE+VX6sx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785420516; x=1816956516;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=uArtQshFddk7WZIktVXJmF3nX7uAFfx3ly7O7lMBUHw=;
  b=YE+VX6sxoXDNipt7RFpNkV4Ts0rnNiOFYOx7F0f0SJsG1J3G9GTQTZIj
   41c6Y/gqAPu2DAMhQ8s/OcRyR/oYbRC3D/rr6XbtwUJusBqaRECRnSSJt
   mNoAKdSLGgMpMPOjHCgaeqHgjh+ghfEDjbHOa76y0A9J/gQUxz7yIWe7+
   GUJAthgiJj60An+CWpheRpoYpdNEXAsaJLld3RrlVEObGNXk/jo137JQW
   uJfTso0wtBT7T6jka+QfOehFSUQ9/GzKi68SXYi6Hcnm/UTDxa2+1lpVm
   y6eTyAvUMRUY0mLqRXDyPERTSq2rgvUvTVzmRwNaedvivPoS1JG6bIv1k
   g==;
X-CSE-ConnectionGUID: D3VGFRt2Re2AyVoO6uwi+A==
X-CSE-MsgGUID: QxY9r6KXROOORs65xCIzig==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="96700669"
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="96700669"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 07:07:37 -0700
X-CSE-ConnectionGUID: tdASF2npQamUWheKvyJkVQ==
X-CSE-MsgGUID: Chn9VXeqRpKEM1mPQjz9pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="265362908"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 07:07:36 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 07:07:36 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 07:07:36 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.64) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 07:07:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ypDtcHUpuk4SX/6j4khyVscdpmXFaA8B7pR+sriSWP8VAPcBH12DLWAuxPlZO7EbtXrP6/OEpPTb28HLphyDiphbbKZEW99/vRfFR6u6nWzj0eII2Cqi71OdQR8vhKGqxrmO7UmbHl0knzxKffwRzaV13py5fUMqohnYgTGaOtEA2tpq4nQYgBhUokPcZsPFTBScEPRTEBeziA/m3AfIKK8FbLN6tVp2r+8ZDjTzcxn73fksEPJjnSIkim/l91pgd+hwFCMJ+GHeS5yMgSY+xmU85+x2E/5y/DSFQ0QW7O92DqehO/U2BJinvRwnV/YxwmwV4guHUpExD7VSIwC1tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0aO9AkYW24wjPKnnaOaT6q7MDKJI7fUx8LaAc0ks1Q=;
 b=BS4HlMLIKaMTYFOYRG8NK8lcipZXIw7J+ASTLpvXISKH3ZASiW3RfohYT58UUKgZwKRWjkSDk2m8pjWO64frdwtO8n2fROXRRlisl2m/6giQtmcvkg83qUAw21s2rSBcH7TqDR/TRDW+l/cxuNXk223MbH2Vz+k83Met+SWUTr9U74x/1ooex+GQVKt6sMb5uBuoJehzOAAGsqYDFrH3hstNHA3YoHIcyHbMkmWWt5lTKjqvS4CzGQxtJOVm5PdlRiabDyhbI2k5m0tkngTH6+rwIn+MEPc3ugEyz1qdSkTzMKVcq87O0+1rUnjzt7Awfvy/F2XWCxe5TYZpWDDvIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by CH3PR11MB741580.namprd11.prod.outlook.com (2603:10b6:610:34d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 14:07:26 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 14:07:26 +0000
Date: Thu, 30 Jul 2026 22:07:18 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "fdmanana@kernel.orgFilipe Manana" <fdmanana@suse.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-btrfs@vger.kernel.org>,
	<ltp@lists.linux.it>, <oliver.sang@intel.com>
Subject: Re: [PATCH v2 3/5] btrfs: move condition for log commit wait into
 wait_log_commit()
Message-ID: <202607301616.c4685aab-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <842ef70c9ca3ddf17f8660ad24f63f6272621afa.1784733396.git.fdmanana@suse.com>
X-ClientProxiedBy: SI2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::6)
 To PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|CH3PR11MB741580:EE_
X-MS-Office365-Filtering-Correlation-Id: 2275cb83-83b0-41fc-8cb7-08deee43e25c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|6133799003|11063799006|3023799007|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info: z2kEsW5PRT058x0hqYnLREqdenORloU/4vxf1agOck7G+zY5zUULTQ2HglbR0MpoPJ8sDzwEXgIOB1DG77Wuxth9nsZ9ITfUsiEi8ZBe9AvUwDc7Yy8m42TFxYb0EiP/ZRqUJo8sR3Y9sk+CBV8n7wSo1Cc4PsRmQ0m6IT7KdPn4bNtzZPFwz/twFkcMuFZBwO2+TLrar+LSkZt11HkO5nrEkvRX1LwlEPcejVi5g5LzcNQpWddoTn0YDg5lyFnjsMi8aqzAlHsGfLsybtuU8dekEB0Oi71QxbcQaJ0EyKnTRFBoBIYBWMCi0D9Z6GUvqmJxWezsJBRTEaayysa6ohwd3/ctukiVc6zEY3yFJnH40pYhuuF2sxCp+5wBTtHolvW9T3GR56RqMElVvuPo16x1Y1+R1787czPhKxviXx3UgtTGSy6LmUPY72sjGVXWjKxBsqROKd5IjUUkAPiBD7c9jk0POINWe15bwJpiJeg279C1zxObwJYBrnV9S15TX/xqNMVMcvs8KjAIMvAeiKzmMJkHewvC+NpOSX2SpaGjHZlX1lpNfmgk4Sg8Xp1N9fPSFY+3x4PQpJoSXrpzmxeG4TmWg0xbKnEVAWfK+MtG4swB3O1Z5hg8bBSU23Fn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(6133799003)(11063799006)(3023799007)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FkygfdWb2hggpMUfmGFin8zGrfGzchy4cbQxYbbaWDYgub04SnNsliSvFjrj?=
 =?us-ascii?Q?7pXuTN5e9dxMhaCpZwENEekwvCsH2pj3BWIPQ5+bIRwOX9r77XFvuYdLEvrF?=
 =?us-ascii?Q?eEZi8kWt/NHXg0UahEww7DAcWxjwZNySH4G3hDHSqu6o3VvClcC7duV/WamG?=
 =?us-ascii?Q?/3Ny87/5UO8S6+lHhTdAtKutK8d35siIikGO0eyW/qTS75n22YZRhqYI0tlL?=
 =?us-ascii?Q?4qEIdUxt6AbrcYA2aSEi5lOFbx9R1bXMwJOlZ5GYqHdwTgPGC5j61hX5DI7N?=
 =?us-ascii?Q?wpGILQ1v08QfD8dwcOHdGCiVLvSt+tLXPIRijUadvQR0XnKfYY5//1JAQehE?=
 =?us-ascii?Q?TBhWFLnfzwJuU+i5V9pgbTYhnMEfVJ3znjXUSEzysx2mvCj3DuGOdqFaX6WO?=
 =?us-ascii?Q?tXvWKZPCqmau6IV4N+uIXV10ju5ZDdPYg0Dxb5r+ls5bwjL+DPtE2ZnhtHap?=
 =?us-ascii?Q?3WJtLMu6E08mBF0yAOebkoXP1sUPiSGhQ0OvX+bjamjunf6mhmhGptf0tsgQ?=
 =?us-ascii?Q?nOUDw94AWk8eCIE4jVWWJTpksUvZj2HxDQeVbYNHj6W2+AVLpt+zFpUeB0F3?=
 =?us-ascii?Q?NFVisQ1n/KeU0Y+MDWlOCQiP+EJRvHbrpZ0zfZgEGr5ckh2i2BiVze17sRqY?=
 =?us-ascii?Q?gyFnRIB/boCaxCRYzoiVBocK3NqatCN4cp4YyOfD3xqCqjXUMe/LZ1q3oIRy?=
 =?us-ascii?Q?46waSFliqCQ5XFkuM7Sy95xe6S18r7fynkuuidGIJJsrxifNQm1PfBuWbMMQ?=
 =?us-ascii?Q?ToyqmdGuV7+p3Va8KT8JRONdIUrjokEuUoURabjmv1kI6bOBHjCj8Ek/l1r5?=
 =?us-ascii?Q?dVCHf0DXYT0FqSEOdLYsN9rzxlvUWMgktsFygkF/I2nFcMlp3PxDIni2Nyot?=
 =?us-ascii?Q?WchhK27ezDPFn1XYhJoBgmFqMTME7wrvKsDBvSU5u/odH/OkgMYiJEs8kgeB?=
 =?us-ascii?Q?/E4f6ckTUAFh13jqI4SYz8oeFa/J8V1y9NGyUK3MVRh3OYrK0GEgRglLVV8/?=
 =?us-ascii?Q?FXavp1ZrcKr66RtjyjzUE1eUi3nbS1Sht0mhB96o6gmylhdx8NrccszguK5f?=
 =?us-ascii?Q?cTUmWo94PSKeSr3w94s1Z4eh4giCtNaZCsDOo1hoFu1RZJO54pijuP+8yKN1?=
 =?us-ascii?Q?G6KEwYXxBRnanSgd+V/lkVS0SEHhN571E+jhsvpl/OK+M2hlzilT1w3k695r?=
 =?us-ascii?Q?vIW2+Y0zZ1jtT9Ydt4+/R9GljDItHug9aOygu6yW1m4mMph+ff4KV02Cy7xu?=
 =?us-ascii?Q?HlwoeORo95ADX6HpEL0J7IXej4tOpEbWU4WR8ualMDuqd8NQInmCzWcLXiEU?=
 =?us-ascii?Q?jFiFqchW5H15oMs0N3kU6ggkXnFjePwFYG26tml4uUAPYyiQKyMzKHUybOXt?=
 =?us-ascii?Q?sfvp/WEg1MwOQVAW14OjuAL5FeTCy6wM1Xd+N6yrKmr3IA2eFVahNUljlSYq?=
 =?us-ascii?Q?iWwRQJ1/NZ3TuBsAezCDmM0c4EgOHB1Z0KNavFU8KC8xaBPMxHrRPDIqEtOW?=
 =?us-ascii?Q?sljhVeATuSEZpKYm+7VU/OToCI044QIIsPAhuWF5FGRCnLOJLgzbdjirq7IW?=
 =?us-ascii?Q?pfSskRUG2KK4Q0RAldyWT7rd0wDsZAAXMpUdqq5H8ZpPXqSkUw0R/YzHR8h3?=
 =?us-ascii?Q?lHBShpMwH9kbiBr/rA7Ngx79mdOdCWJV5qMg36bE4WKNxSbdUxzE2djFTkyP?=
 =?us-ascii?Q?4nfrwf3DNn5/NumlODD1bodpqLdZfWndNbB/2TskLdZOPeg+N964tXTn4vkm?=
 =?us-ascii?Q?osW4XGPepg=3D=3D?=
X-Exchange-RoutingPolicyChecked: cS1WwZR9StClNpPm8T+1BhSw9HJKA4iB0k4lUOl15Oo0fVc9Wt5CyLfhrD+7btIg9RgELukxUOgiRE0+oULgcJ8Rn/6hI3PggCKZt2qu0PbD48jMNqN4px6PZBuHwkJqtLNdX0H9n3MBSwweUQlHWLe/GhZKuZUhPvn0NB/T6Yj8+TM8LMR/z9br9gqJ4mxmMuu7Zy8uEoK6z6cNq3s0AiAIxksK26RbS/unDcAB1xEgbqRPZcLMQC/9m0W1das8F8JMepuJTa7xik90R14bqaihWEliy/5xo7KnRdYd2B3TSf7nzyDXhNuH7gTnm0tMw+lCBGH/C8Qacj6gY7MNog==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2275cb83-83b0-41fc-8cb7-08deee43e25c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 14:07:26.2324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZquwjilLjmANc+tgHRVatS4VfodSBSdjG/ymU7ucsrdoBBS7o2iLFk1zXPAIWmET+7PJBAPAXXN1fHZquwSzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB741580
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "UBSAN:array-index-out-of-bounds_in_btrfs/tree-log.c" on:

commit: a99687b4edeead900d714fa0839a302a5a56d7aa ("[PATCH v2 3/5] btrfs: move condition for log commit wait into wait_log_commit()")
url: https://github.com/intel-lab-lkp/linux/commits/fdmanana-kernel-org/btrfs-stop-sleeping-for-one-jiffy-in-non-ssd-mounts-during-log-commit/20260722-235417
patch link: https://lore.kernel.org/all/842ef70c9ca3ddf17f8660ad24f63f6272621afa.1784733396.git.fdmanana@suse.com/
patch subject: [PATCH v2 3/5] btrfs: move condition for log commit wait into wait_log_commit()

in testcase: ltp
version: 
with following parameters:

	disk: 1SSD
	fs: btrfs
	test: syscalls-01



config: x86_64-rhel-9.4-ltp
compiler: gcc-14
test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202607301616.c4685aab-lkp@intel.com



kern  :warn  : [  104.466941] [   T5568] ------------[ cut here ]------------
kern  :err   : [  104.467469] [   T5568] UBSAN: array-index-out-of-bounds in btrfs/tree-log.c:3173:35
kern  :err   : [  104.467989] [   T5568] index -1 is out of range for type 'atomic_t [2]'
kern  :warn  : [  104.468507] [   T5568] CPU: 4 UID: 0 PID: 5568 Comm: fdatasync03 Not tainted 7.2.0-rc4+ #1 PREEMPT(lazy)
kern  :warn  : [  104.468512] [   T5568] Hardware name: System manufacturer System Product Name/Z170I PRO GAMING, BIOS 3805 05/16/2018
kern  :warn  : [  104.468514] [   T5568] Call Trace:
kern  :warn  : [  104.468516] [   T5568]  <TASK>
kern  :warn  : [  104.468519] [   T5568]  dump_stack_lvl (dump_stack.c:94 dump_stack.c:120)
kern  :warn  : [  104.468528] [   T5568]  ubsan_epilogue (ubsan.c:233)
kern  :warn  : [  104.468533] [   T5568]  __ubsan_handle_out_of_bounds.cold (ubsan.c:455 ubsan.c:442)
kern  :warn  : [  104.468539] [   T5568]  ? __pfx_stack_trace_consume_entry (usercopy_64.c:?)
kern  :warn  : [  104.468544] [   T5568] wait_log_commit (btrfs/tree-log.c:3173) btrfs
kern  :warn  : [  104.468751] [   T5568]  ? kernel_text_address (extable.c:125 extable.c:94)
kern  :warn  : [  104.468757] [   T5568]  ? __pfx_wait_log_commit (btrfs/tree-log.c:4984) btrfs
kern  :warn  : [  104.468950] [   T5568]  ? arch_stack_walk (x86/kernel/stacktrace.c:26)
kern  :warn  : [  104.468955] [   T5568]  ? __pfx_autoremove_wake_function (linux/list.h:441 (discriminator 4))
kern  :warn  : [  104.468961] [   T5568]  ? mutex_lock (linux/instrumented.h:55 linux/atomic/atomic-instrumented.h:4457 locking/mutex.c:161 locking/mutex.c:318)
kern  :warn  : [  104.468966] [   T5568]  ? __pfx_mutex_lock (locking/mutex.c:1164 (discriminator 1))
kern  :warn  : [  104.468973] [   T5568] btrfs_sync_log (btrfs/tree-log.c:3331) btrfs
kern  :warn  : [  104.469161] [   T5568]  ? __printk_deferred_exit (printk/printk_safe.c:55 (discriminator 1))
kern  :warn  : [  104.469164] [   T5568]  ? stack_depot_save_flags (stackdepot.c:728)
kern  :warn  : [  104.469168] [   T5568]  ? kasan_save_stack (kasan/common.c:58)
kern  :warn  : [  104.469171] [   T5568]  ? kasan_save_stack (kasan/common.c:57)
kern  :warn  : [  104.469174] [   T5568]  ? __pfx_btrfs_sync_log (btrfs/tree-log.c:3254) btrfs
kern  :warn  : [  104.469285] [   T5568]  ? do_fsync (sync.c:186 sync.c:200 sync.c:211)
kern  :warn  : [  104.469288] [   T5568]  ? __x64_sys_fdatasync (sync.c:221 sync.c:219 sync.c:219)
kern  :warn  : [  104.469291] [   T5568]  ? do_syscall_64 (x86/entry/syscall_64.c:63 x86/entry/syscall_64.c:94)
kern  :warn  : [  104.469294] [   T5568]  ? entry_SYSCALL_64_after_hwframe (x86/entry/entry_64.S:121)
kern  :warn  : [  104.469298] [   T5568]  ? __pfx_free_extent_buffer_clear_reading (btrfs/extent_io.c:3746) btrfs
kern  :warn  : [  104.469405] [   T5568]  ? __pfx_copy_inode_items_to_log (linux/list.h:161) btrfs
kern  :warn  : [  104.469512] [   T5568]  ? kasan_save_track (kasan/common.c:78)
kern  :warn  : [  104.469516] [   T5568]  ? kmem_cache_free (linux/kasan.h:235 slub.c:2705 slub.c:6405 slub.c:6532)
kern  :warn  : [  104.469519] [   T5568]  ? btrfs_release_path (btrfs/ctree.c:173 (discriminator 1)) btrfs
kern  :warn  : [  104.469618] [   T5568]  ? free_frozen_page_commit (linux/instrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 page_alloc.c:2809 page_alloc.c:2881)
kern  :warn  : [  104.469622] [   T5568]  ? __free_frozen_pages (linux/spinlock.h:390 page_alloc.c:2980)
kern  :warn  : [  104.469626] [   T5568]  ? __page_cache_release (linux/instrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 linux/page-flags.h:552 swap.c:76)
kern  :warn  : [  104.469629] [   T5568]  ? __virt_addr_valid (linux/mmzone.h:2187 (discriminator 1) linux/mmzone.h:2269 (discriminator 1) x86/mm/physaddr.c:54 (discriminator 1))
kern  :warn  : [  104.469632] [   T5568]  ? rcu_segcblist_enqueue (linux/instrumented.h:112 linux/atomic/atomic-instrumented.h:3260 rcu/rcu_segcblist.c:214 rcu/rcu_segcblist.c:231 rcu/rcu_segcblist.c:332)
kern  :warn  : [  104.469635] [   T5568]  ? __call_rcu_common+0x341/0x970
kern  :warn  : [  104.469639] [   T5568]  ? __pfx___call_rcu_common+0x10/0x10
kern  :warn  : [  104.469642] [   T5568]  ? _raw_spin_lock_irq (linux/instrumented.h:55 linux/atomic/atomic-instrumented.h:1301 asm-generic/qspinlock.h:111 linux/spinlock.h:187 linux/spinlock_api_smp.h:143 locking/spinlock.c:174)
kern  :warn  : [  104.469645] [   T5568]  ? detach_extent_buffer_folio (linux/mm.h:2124 linux/pagemap.h:636 btrfs/extent_io.c:2976) btrfs
kern  :warn  : [  104.469753] [   T5568]  ? release_extent_buffer (btrfs/extent_io.c:3758 btrfs/extent_io.c:3721) btrfs
kern  :warn  : [  104.469860] [   T5568]  ? free_extent_buffer_clear_reading (btrfs/extent_io.c:3821) btrfs
kern  :warn  : [  104.469966] [   T5568]  ? __pfx_free_extent_buffer_clear_reading (btrfs/extent_io.c:3746) btrfs
kern  :warn  : [  104.470073] [   T5568] btrfs_sync_file (btrfs/file.c:1726) btrfs
kern  :warn  : [  104.470181] [   T5568]  ? __pfx_btrfs_sync_file (btrfs/file.c:1489) btrfs
kern  :warn  : [  104.470296] [   T5568]  ? fdget (linux/instrumented.h:82 linux/atomic/atomic-instrumented.h:49 file.c:1194 file.c:1208)
kern  :warn  : [  104.470300] [   T5568]  do_fsync (sync.c:186 sync.c:200 sync.c:211)
kern  :warn  : [  104.470303] [   T5568]  __x64_sys_fdatasync (sync.c:221 sync.c:219 sync.c:219)
kern  :warn  : [  104.470306] [   T5568]  do_syscall_64 (x86/entry/syscall_64.c:63 x86/entry/syscall_64.c:94)
kern  :warn  : [  104.470310] [   T5568]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
kern  :warn  : [  104.470313] [   T5568]  ? __pfx_vfs_write (linux/fs.h:2733 (discriminator 1))
kern  :warn  : [  104.470317] [   T5568]  ? __x64_sys_munmap (mmap.c:1079 mmap.c:1076 mmap.c:1076)
kern  :warn  : [  104.470320] [   T5568]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
kern  :warn  : [  104.470324] [   T5568]  ? fdget_pos (linux/instrumented.h:82 linux/atomic/atomic-instrumented.h:3188 linux/file_ref.h:215 file.c:1231 file.c:1257)
kern  :warn  : [  104.470327] [   T5568]  ? ksys_write (read_write.c:739)
kern  :warn  : [  104.470330] [   T5568]  ? __pfx_ksys_write (read_write.c:723)
kern  :warn  : [  104.470333] [   T5568]  ? __pfx_ksys_write (read_write.c:723)
kern  :warn  : [  104.470337] [   T5568]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
kern  :warn  : [  104.470340] [   T5568]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
kern  :warn  : [  104.470344] [   T5568]  ? do_syscall_64 (linux/randomize_kstack.h:57 x86/entry/syscall_64.c:92)
kern  :warn  : [  104.470347] [   T5568]  entry_SYSCALL_64_after_hwframe (x86/entry/entry_64.S:121)
kern  :warn  : [  104.470350] [   T5568] RIP: 0033:0x7f28a60b5687
kern  :warn  : [  104.470353] [   T5568] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
All code
========
   0:	48 89 fa             	mov    %rdi,%rdx
   3:	4c 89 df             	mov    %r11,%rdi
   6:	e8 58 b3 00 00       	call   0xb363
   b:	8b 93 08 03 00 00    	mov    0x308(%rbx),%edx
  11:	59                   	pop    %rcx
  12:	5e                   	pop    %rsi
  13:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  17:	74 1a                	je     0x33
  19:	5b                   	pop    %rbx
  1a:	c3                   	ret
  1b:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  22:	00 
  23:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  28:	0f 05                	syscall
  2a:*	5b                   	pop    %rbx		<-- trapping instruction
  2b:	c3                   	ret
  2c:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  33:	83 e2 39             	and    $0x39,%edx
  36:	83 fa 08             	cmp    $0x8,%edx
  39:	75 de                	jne    0x19
  3b:	e8 23 ff ff ff       	call   0xffffffffffffff63

Code starting with the faulting instruction
===========================================
   0:	5b                   	pop    %rbx
   1:	c3                   	ret
   2:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   9:	83 e2 39             	and    $0x39,%edx
   c:	83 fa 08             	cmp    $0x8,%edx
   f:	75 de                	jne    0xffffffffffffffef
  11:	e8 23 ff ff ff       	call   0xffffffffffffff39
kern  :warn  : [  104.470356] [   T5568] RSP: 002b:00007ffcb7666460 EFLAGS: 00000202 ORIG_RAX: 000000000000004b
kern  :warn  : [  104.470360] [   T5568] RAX: ffffffffffffffda RBX: 00007f28a6023780 RCX: 00007f28a60b5687
kern  :warn  : [  104.470362] [   T5568] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
kern  :warn  : [  104.470363] [   T5568] RBP: 00007f28a6023720 R08: 0000000000000000 R09: 0000000000000000
kern  :warn  : [  104.470365] [   T5568] R10: 0000000000000000 R11: 0000000000000202 R12: 000056382db4c047
kern  :warn  : [  104.470367] [   T5568] R13: 0000000000000004 R14: 0000000000000000 R15: 000056382db4d260
kern  :warn  : [  104.470370] [   T5568]  </TASK>
kern  :warn  : [  104.504778] [   T5568] ---[ end trace ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260730/202607301616.c4685aab-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

