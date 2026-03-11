Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BFD271A6D
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773236320; cv=fail; b=rtui+URVDfOOMniHN6u0oH/Kkh+DVsfvjOZD1XlQHjby/Fhi5+WuDxuQXomdM3Pgw4yKJszLqwAFykqRLA3zDsqltkdQc/tML8mh34bXjwNWXuQntAqoXexfqsahOi+1NYbI4PPGuzhDwFdWmX5dXTUiTCN68YRj404D7oW3JKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773236320; c=relaxed/simple;
	bh=vPBNWPXJnsyqtn/W7HPMZVmdnl2927xRn6BsCmPmkE4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fhf0lmMK40Cau3hr5Eo5DufRQWdDP0zgTkfUzZnkD57bMN46VgIrQjRmBrzZXWoJA5exd7LmNMUcs400kdigIbBZNmt0wceI44v1AfBJYp1/liH4b9TjY7af75wF19BG3TLzItMgHqZDrFJqgQB2sVPykMyjnV8GkWAUxukbGOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kE5IwGE8; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kE5IwGE8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773236319; x=1804772319;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vPBNWPXJnsyqtn/W7HPMZVmdnl2927xRn6BsCmPmkE4=;
  b=kE5IwGE8vjiGjC6bLbgKkZxWHPdMTTo6hSQ2Nzg0meFZu1gTzEBwccN3
   SzVoO95Eh8WJ49MXzQ441YI1gD4DBM7R2NaNRRTUu80dlHoqWm+lupaz9
   1X9bJ2yG52WKjp+xIEtI1er+cpM+31uxAkl9RUIJjb54W27H2WBhOk63r
   ltdXMfk4JOQ9vOLWRav4kopqsCpfqLr8LEepDwRMIrTGb6TQ2cdRLhPca
   kv4fyLdUlXDp6+/xRvzZ2w7BtG8Avygty74/2wF8gLhbafoBZUSMpxTMK
   9FDs/sjXvSVuqNmBJmiZThTnvRzdfoNYq1u9F/C6vbE9WFtg6mAY2vc70
   w==;
X-CSE-ConnectionGUID: liYd5dJxRpSIeqxHPMAGLg==
X-CSE-MsgGUID: COEjIfaQReaIB1YyYwq/QA==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="74178233"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="74178233"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 06:38:39 -0700
X-CSE-ConnectionGUID: T4ylXSsRQwm3TQEbB5EQsA==
X-CSE-MsgGUID: o5O/6qdeSWKb+1m/wIzJ9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="217936159"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 06:38:36 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 06:38:35 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 06:38:35 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.71) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 06:38:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZqhshXl/SmX861IJHdYw+fbc/ZeaEuVUIBpJjOkqTPqUd3riIv0GrPUOiT9a+R+rNl008mwZd+Y3Poslj9ip/b6ESBTLKhFLvK7GqZSRKCEz6boIWryj8SzBs0t7Y1z4/byjKpNzihwgBQe1O1hlX+tTB8P55L5hLaSiBs8hUh2uwPw6MA9XBzrrFDcyM2BCoR6XMO8vSOKJanmSN7nsnTFhOHXPqqDwi5xDlO9uAyKXQIFSBCyWEUeY/G1YW/CwvQsY8q/sZXw9TeVEZ66Q2FImncD6vUe0Jxc8twblTK92lyKgc3xJ/obtvLJEEKDEUdmPcBbAwyF1u9Chp6MX2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iyf5y4mtxxk/4qGgyibSJfOYfmvwStoA0smw1JjhwmA=;
 b=NjdhsmoHgvbyJSoP8c/KwONoEaA/RLPGEtDmnoD6/sLZ0qFZdzP//5/m3w2Euu2rM+i4K9aCxarqeE3oIfNt0AQLHG8RwgwWcrW2HtJXyMzdBmR50EEzdvzWj33sAiCth//qGbHSsKLjklnqIUo2RnuDQB5Nr531yP7hT4NiuUUq/EtYikms39izvS/M7HpjHgDT380dwuV8SAZTs0r1/zbDe9fNvjDGX1MM4Necz8qYmVuiuykbGcNlCL3zqEbg0svpwPwS3HwJOsjFhVox58AKtml2llMKDQ+V+bnGRt0S8MqaHL/OBW/NeAhgA3ixvvxlXfub8IfgvSvMH6hbOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH0PR11MB5952.namprd11.prod.outlook.com (2603:10b6:510:147::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Wed, 11 Mar
 2026 13:38:33 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 13:38:33 +0000
Date: Wed, 11 Mar 2026 21:38:25 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Qu Wenruo <wqu@suse.com>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: move larger data folios out of
 experimental features
Message-ID: <abFwUThozUfPYfgj@xsang-OptiPlex-9020>
References: <202603101405.288f83f3-lkp@intel.com>
 <933c12fd-0d10-4ef7-b10e-cb64497829eb@gmx.com>
 <aa/Ga0S+ZtmpNWVl@xsang-OptiPlex-9020>
 <35bb4d50-012a-4bbe-ae4c-eb44b69d4cf3@suse.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <35bb4d50-012a-4bbe-ae4c-eb44b69d4cf3@suse.com>
X-ClientProxiedBy: SG2PR06CA0224.apcprd06.prod.outlook.com
 (2603:1096:4:68::32) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH0PR11MB5952:EE_
X-MS-Office365-Filtering-Correlation-Id: e59a3589-ec61-465d-78a3-08de7f737d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: vcoqtbOj+K3Mxy57vEnR4rbrtlM6h9ZXLlT+tbz3JgoDPBTufwUUu9G9PP1tDONRDArU0g9FvR4ft0vFBOxiSuORr1cv0x+PyztKw7n1DowVGyV8abXh3eTN0tiihkk21zYCyEKe9Xwv/mpanYu0q2FEGcEYSeyH9uAiqWLDl9rjkNcnniutHNV0kjRwulJyipbDzSBo7brmbtBzYk84rku3RGYRHhuAMJZElsujDKk0OcWB551782O5eKvH0I4OsQAJDmuv/POai981ylFkOU9FgZSu/vT30UnhLP8p3vs/EoIOciPCqPIE0xyAraiK/4ohge4NiCrhFNYayzzppHrUwzZKuU0S6Tqx3b78R2o9UsPqwawNaGJVQgFCbLUemVe+Qgdk63a1fAThiL/uNIcFgFpvZ2rVXW4AUsEiLof5SoE3iTjdGMuI1X8SPnoAOgc/DZizEA/Vf3nFhlEqaGswrgaOvrNMRAKCRzGv9a3+URyusQLQxNcuf5KAmBjwXdgYssLDxx9Jl3vuxyRLFKfLjiBzA1HmLMOHtg8oZTKVriuT5drC+dnIxNlqYgK6Nh5djIrpyXaLPTKcFusAKB3iZdYI7YTI4vbL9M3zeXCmrROClJfmWnjNBxbHu9W+xQdrYaxLmWuoTxsz627AFeY2ZIYW5hl74fghPGWbiD2NmAkrWmcvurvw1933/rgd7q+1nI3VwJyiZnlLiBsR4K1tCptMkqVgWM7paINPxfQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nTYL5/EacqKrfVy0vcGZjfGi9U7cnEebRu42TqVdrELMlC/hMOQ2VYd1qboC?=
 =?us-ascii?Q?1IGKKtH5LSfcJ4Et4VhCqBGRHQux4pLC2PK31pKTvdegCO/XX1FZArvIYGRh?=
 =?us-ascii?Q?b/E55OGSRjws5GBlzbRl3wPHYB6kZf/Jv2CVMsfFjRihxlMbbboHE+fzRD/v?=
 =?us-ascii?Q?bNejkPW/PoafnoD0rOXBzb/enA/lwL0O4YjRQ1knFY8V/np9c36Akc/pTkNy?=
 =?us-ascii?Q?RqHQCLWaBVw5O7RzszR/+Sw+sJqMA+K1GUvWmyL7Wrcmz4rztVMSET/LNzDe?=
 =?us-ascii?Q?TtdYECMvb99QK19yO63nHB8TY8VaQ24Xzthojz6MYEdkC/wAI3ZBHfx5aCEv?=
 =?us-ascii?Q?raC3ad6CqBUQRRjwT0hm3T1DMkrIRbym2F3RQoSwMj76BJJCvdymOsbf/qys?=
 =?us-ascii?Q?saj43W2K+QEcBOQPADIWtcCBu4j29GFnAqcaQjx4sM2m8WkNV89MOoywj+1+?=
 =?us-ascii?Q?KrijjHT/Q3qa6IGLoAj2QE2D/HuEuwCSLHgqfjzgjHx9WXsvTjwAhsf/ViBr?=
 =?us-ascii?Q?kKclWdrzytwrePMZKswg7QgGB78bVuuI6ASGAEkIa/6MCabM+JAO8M7kW6pK?=
 =?us-ascii?Q?VAKoAZvBsXU4VGYP8hQG6opPCPgL9vDOrkM+cHctO0e6UhebXU7yZyzrsIJ4?=
 =?us-ascii?Q?BilLEogZbFMDUVk6VvKBgPehUxHHlpJQs01CF+nXEpRC1xKXh6wAPSuw8kjz?=
 =?us-ascii?Q?ma4gIATYeSEXA9H81zgira0I2QuCfHvFhvlHo/JR4rufjnTvrfm8AX9E98qA?=
 =?us-ascii?Q?m1WQ2/XCrx3u1CXS9xhMxKXt6Dh3nbVtnKiujc4y7momuoqk0TAJqoeAR10N?=
 =?us-ascii?Q?J8cA9S9hVsHb5kfnY9EHJobWvO6tVcnpYZivuMPg1VhIXX3Tpf4cMWLgIXky?=
 =?us-ascii?Q?gX7VDux8iSo4B/rsMLk5eAdwJ123J93A/XJxgu070725OHU/1LHYmivt93zn?=
 =?us-ascii?Q?MdWYNeg3ff9rmaXijAZAM1FypZf/e0LDmXz2PDcrhFwBEMypCpAhuBg9PmYH?=
 =?us-ascii?Q?g/yYPKMM3x9/M8EqaMYpNgo9MSLvKL4HWpXQJlg6Sa/r0n6ekjcR64NZFViW?=
 =?us-ascii?Q?C5KYvrKuh4BrPC3QpXduAeU7Jz+doS3STWVf6FS6rICiKnaNkgO5LdBgpAsj?=
 =?us-ascii?Q?/mb0vUbDlYtptsPH7ZP4ARrpQnmz/Y9Sm0I8A1x63EMkeQNX1Jlad6hFnGQm?=
 =?us-ascii?Q?Ds0Xygk23wQextlGvqt0rVZ9Jw9OrKbtEg+hdsPtJOX1RUFP5XZnlNmsKGqi?=
 =?us-ascii?Q?CmkYHk/iJ1jEUZAuPHpz16n261grWryywvuumO3Yvj5vBmBf1w5kepfI3rHb?=
 =?us-ascii?Q?1aBMO8zoOZDyQjup03Z7xzYbY38/zhnmo8KFBMeI/tJJu/BJte33Spi+mEog?=
 =?us-ascii?Q?/b1p1avK5FA7N2PXpJpKNQC4FoVduUE5X32bCNMxwUb8enBSi8ujdA2d65Ur?=
 =?us-ascii?Q?whyaM6VejvqNHka36TzywjA+VMh9FZeiYyCIfGjfF4ACeYyf3ilhelqFkRZF?=
 =?us-ascii?Q?/DgY0/tpYRIKRZAH8gwBcU0TchZ4Elr8URxGJvVDunDfopa1/QWnsSfrXBzx?=
 =?us-ascii?Q?i4xcZMll1/u/pjgjatn2oZsNcp4veI78xYNfepTA4rxRsGnxtuicKZn9ulyK?=
 =?us-ascii?Q?SXIO7T5ysOesv94E2mXMb/j/gJGHdQhyI0JDRL3CynEdLehJk1tdY69L9Xyq?=
 =?us-ascii?Q?nC4egzvSBxf7xxkwLGVUUkcBDz5wxT17TRs2prHA7CKSvfi4eAeIHJjlognL?=
 =?us-ascii?Q?LUad94yYsQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: PFQIFj6U94bjqF+2SjEOc5C/bmBFFl0+6No85tQMldb/QpTxtwBaCpQzc+UadlaFbixakuTGvqOj6oAHHDceRUZOMTTpw4D+orUOQPJcISok3F4Xu3J3N1kBwJdNEXTNjhX3aBmydW46E4f5etTxNxbM4x3RB3OYdRDvgf3EFgZsmAf02Ah7BfWKS3gGZ2JiQLq6qykiTcOKqFaDm21p4M310pJNsqrAnmmmSA0tHSpYdS8D3uXTeY+SJKMRqtKPXJzKl+BwKNs3gFbQYWvWq9CKN0vQmCLXNkzrIEQpbZpFcTl/FNDnztpKiTRyP1wUwJpe2s8NyUtBCePTLwYFJg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e59a3589-ec61-465d-78a3-08de7f737d0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 13:38:33.4103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8C3cFKPZvkaPT58TkjUpORLpdIhGBPYWTe58wVbW6IDXooYux71Ca8zTNenibT3K4TeueZgtIfyYQ/A5j1GoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5952
X-OriginatorOrg: intel.com

hi, Qu,

On Tue, Mar 10, 2026 at 06:28:28PM +1030, Qu Wenruo wrote:

[...]

> 
> Thanks a lot!
> 
> It shows it's the defrag ioctl failed, and it's indeed a bug in that patch,
> that I forgot to remove the experimental check from defrag.
> 
> Thus it won't cause bug for CONFIG_BTRFS_EXPERIMENTAL but will cause
> problems for end users.
> 
> Will get it fixed in the next update.
> 
> Thanks again for the consistent report!

you are welcome :)

> Qu
> 
