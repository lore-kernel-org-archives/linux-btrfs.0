Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD55318EC9
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773127294; cv=fail; b=DQtq0SFwAB4RexSNzq8Cf/ZY0h7t/AyFViEG/o16gSRYkUMfjXz7dpbBjSh9HwoXCxnBQrvxA8spiSWPTh8FLNHCsfJsNh+NFL5SYxTTdXeNE+5ipWQO5M7p5iY2OMMPTIGZWNkL8FDecyMpaJoCTuL7v6LVXSklUlU5zHGej2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773127294; c=relaxed/simple;
	bh=mV5u0XJhb3WUxJlhMnwIcgq1eXmWXpdkM40876v0/pM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cMDUCaKL2btUytzEadAaoFOWC8QqscRKxHzKh77OrPlWqn3sByiyhK8nsEItN+BIRgZyZcP29MLUYBWtwko7WdWDcYlEO2mou6vc6mmJgGAI1m8macUyWW3AwKKBczgUY/0LOzIomdHP4S0I0DeSdKYe4OMnGo3Hws/xfOOQT9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kqgfSo22; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kqgfSo22"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773127293; x=1804663293;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=mV5u0XJhb3WUxJlhMnwIcgq1eXmWXpdkM40876v0/pM=;
  b=kqgfSo22Cj5uQBdUeO1U28K1kggbo0rup+gPiGDzW+96fJxXEj2yraGW
   hCENUxvBPBVLDG5r8044VmFOAm+2DP1gHIAvrbyd+jl60lqHKJoqM+nia
   Kx+F/2UQTqwCWpWiwcjG2MTLnIAgy3Fg/BKvoO1TlVsgdmLwH4MjNAbtx
   UsXLCKvDtc77hs2DNEDIrQHik9+5UsaN5fVapZdYSTLzM9Kl4g6aUOTq3
   /tyHG2gEhQuXlL4sUw0YBgK1dillBcOJKv/0DRkr2ARuGKQpOJfYcuYj2
   GIoomKxGDKEEXxe2ZWRVKisPa/4EcwoHKRjtwXWtPNE7n2D3cbFKXWKeQ
   g==;
X-CSE-ConnectionGUID: ZOb2SSbiS3626cZ35rd3Lw==
X-CSE-MsgGUID: R0PbnoOaQOKC4/MjUBL/Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11724"; a="74041741"
X-IronPort-AV: E=Sophos;i="6.23,111,1770624000"; 
   d="bad'?full'?gz'50?log'50?scan'50,208,49,50";a="74041741"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 00:21:31 -0700
X-CSE-ConnectionGUID: +uNbp6QHT9WmYfC6REMI9g==
X-CSE-MsgGUID: vdRmCRK9QZyQitAiEx0/lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,111,1770624000"; 
   d="bad'?full'?gz'50?log'50?scan'50,208,49,50";a="218015440"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 00:21:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 10 Mar 2026 00:21:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 10 Mar 2026 00:21:29 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.29) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 10 Mar 2026 00:21:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1BdCfT61Msps06AD+Z+OzMYPz37+UVm4nS9uZ/+ErZwMo+F16YfwgRqflgB0JmxU6JuAtlxRf8OFn79pxcFV7fp4goikW4hdQOYn7SYuuAz1KN/GgdVeELuIxHElFoMPbfmzaVFZzk0yJf8BdRygtZLFYnzzY1T0BPx+paGm/jfcFp6li08O3ZyNKb7Z90sUVTWt6TFIKzTvCB0aytb6QFByplx3R2NBMjWWoeK09J1NY7AB9dkNDJFWcfTa6focd9RoUk2kUa+SmWcIcL0sgp3GT322SnLOZkAqPHdajknnYa2B3tXIYvAkoZQ6qJovRt4cKw7kIAiDS8mJA73rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjMjixaBXk8KueJnZyNqqs5ZKFBqrYFGL4oEnS/HGmQ=;
 b=wauDAug4i85J8e2n/ejDws94DQkOgb1+67UQfOVM0niK38Sx1qyxWnYiGJyawsC0kG5wxBuD87VgJu16gjBsXzLPYdGzw8iKtu//OOmCruijYJmphBm11VWTW1J7HA4DVejfUf5/KA4ouCghsnIidB+t9+TFPc3w3tzY2Wfso5/8ill5NCx3xu++qxSGb72FpEdXtU++XF8bK/xJOJ0UyRnXT8kSoYP+PlzWL+TlMzY5bFYrBlpx1DXt3VGwAXBkn5yYPQRpWf8YVptq6ztWR2Dm4QAiKaQUJGAUFyTQH7eD6FbF3uuGtQcxMnkTklIWtp/eQsk84qbOrGBgID683Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR11MB4033.namprd11.prod.outlook.com (2603:10b6:405:78::25)
 by SN7PR11MB7592.namprd11.prod.outlook.com (2603:10b6:806:343::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 07:21:24 +0000
Received: from BN6PR11MB4033.namprd11.prod.outlook.com
 ([fe80::2c28:2983:2947:24b1]) by BN6PR11MB4033.namprd11.prod.outlook.com
 ([fe80::2c28:2983:2947:24b1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 07:21:24 +0000
Date: Tue, 10 Mar 2026 15:21:15 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: Qu Wenruo <wqu@suse.com>, <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
	<linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: move larger data folios out of
 experimental features
Message-ID: <aa/Ga0S+ZtmpNWVl@xsang-OptiPlex-9020>
References: <202603101405.288f83f3-lkp@intel.com>
 <933c12fd-0d10-4ef7-b10e-cb64497829eb@gmx.com>
Content-Type: multipart/mixed; boundary="wmrXy9HJV6rNqZoR"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <933c12fd-0d10-4ef7-b10e-cb64497829eb@gmx.com>
X-ClientProxiedBy: TP0P295CA0019.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::13) To BN6PR11MB4033.namprd11.prod.outlook.com
 (2603:10b6:405:78::25)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR11MB4033:EE_|SN7PR11MB7592:EE_
X-MS-Office365-Filtering-Correlation-Id: dd0df72d-5907-46a0-d3b3-08de7e75a2a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|6049299003|366016|376014|4053099003|7053199007;
X-Microsoft-Antispam-Message-Info: 9xQDKr+MRE0qusY88Qj8uX36Izvdy995N28/klbZvM07RX+ujSyfm91VL4E1NCvFTNaYCkrlMt2cSDU2gkBpyyrODdYyTd+BDKAz8N4VQFA86AfGLaMNhGVi3LznJCmnhB9Bcvrhcv6+szynhcOW3RzJe6b1x+vAhGkwUzgGBZhTFrh3d/TVS/NQqhjAHQX8Q4XPvRMTEGjC78Z0ISbSP8rbjdrTbamP0EgRgwKIAkvtCoR8S6KmyQLKeE83gTQZmjYuslhLhPFxwc3rC6CjSC9GksdEBewEUjr7bSDC2eUMqze30tuAQJ2OgxFffZAg87l6iknbPXm7xqphlUD7XAD6L6cfDRS61oQZ8hDXQHqRTjtfAJxqAbGMbUxY9QmjQQ+EU0zlInssEqoTDqTW7NawaQJCoPq8G09aT90WXcvl51XdKYfs0eu9NUjP/IAIIb5s3fjIiEgDlJEsSt7qgacEN6/BZAECQqIAIiWPwYgvqdvuNy7nJn09UHkSNxGk1VNUg94jBHwRFcWyTKxtmACL3ep5LD7EsMNGY6TT/Lc7pSIYvoLm4B+JxemzNMgeCec/DBQd6zv+89Mqa6RDz8F4DE00yd6hJeOjofDj7Co06lr+Mryw0JkrJztGzANGeHhoIJ1JMUDllQC20agsRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4033.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(6049299003)(366016)(376014)(4053099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDZ1VXNxQWZ2Q0tPd0hLT2xDTW5kUDRTNjRWc3ZHT0lwcGNDNHN5UTQxSmcy?=
 =?utf-8?B?a2QvSE8zSTNUSHpIbnpwM29tN2Ezemw2dUdHNTFsaHhUaEVUN1FPVmw5eDBq?=
 =?utf-8?B?T3p3V3dqdnM4aUhpQWlhbjV2bU9pb2g4V0U5Z2t4TTBrNzhzRThaSnVzcm83?=
 =?utf-8?B?T0dZSDRRZ3pyVUNTSk52S1ppazNsdHhCbVFIVVlJZHU4SVpRaWR0WGt6Rkc0?=
 =?utf-8?B?ek5KVHlnZnZZdEQ4cVBwQTJhNjJ0cy9Vc040VlgvenV6QlJVK2JaMTlVTkZz?=
 =?utf-8?B?K3B0U0h5MDlqUFhIOFNBMVhYNE1EekRTbUxBS0V6bjAzbGtMOXFva0M4ZUZF?=
 =?utf-8?B?M1FURzZodHRXdjdjUDNXZEdRcDF0REl6T2gzaEI2TzQ2SysvcnIyUUJvTGxC?=
 =?utf-8?B?WFEzajk0eTFXUUJMOUxnd1VqdUplK2xnS3lBUWEzTUIwbndLalg3OG9aSEdB?=
 =?utf-8?B?dUVVa2JzMytDZVUvQUlHQU83UzV0aUZ0L3l6VjFaVXV3Q09lQnQydmRxRFJk?=
 =?utf-8?B?ZDhuRXZ3UU5IT3pjOC95S09ibHJXdjQzWVBzeU5pUVNmNEVxTzBEdm9MckZl?=
 =?utf-8?B?ZlhiWDdoeVlkZnBwOC9ZdHJCQnBya1dtVm04QmZoUSt2WkUyZlZnNTdxUmt5?=
 =?utf-8?B?bmRJT1ovUG1rdGtCTFRQZk1ZVm5ZN0VKZ0pZZGtiSzlRZ2ZpVzhkdHJVQ215?=
 =?utf-8?B?QkovUWQ4NlYvaVBvN1h0NnA5blAwMzhXekhpclJWa0Vlb09tZm9IRHlFdWdG?=
 =?utf-8?B?SVFmQ3ZyWUprRC9TeitBbWZ3S2Ftbk5qa2hYY1Q4NmpzSnR5dWxYaEdMaSt5?=
 =?utf-8?B?ZHkwd3hsdjlCWVVGQmhwdEZvdEtncmpGR00yZmM3cCtEcnpMZjJoMlFoYWRh?=
 =?utf-8?B?cnRjRXpQZkdISTd2QWtvTmJ1czRqVkN1WjdaUVBJeVF3ejhNcGkveGIwT2ZV?=
 =?utf-8?B?VU41NzJNOUc0MnlyN3ZDRUMzbkxDK2xGcXI0WG1kdURKTkJZR3NhY1lDRVJx?=
 =?utf-8?B?eFgzY1AxY3ZWMndWZlJ1cjRlSUt3cnBiOVl5VEpNbTdRM2pOKzhTVTcwWGVM?=
 =?utf-8?B?UVEyMGFObEp6NmozVi9ERndCYUlublRoUms4UEx4RGtBSjZxTnpDSk90a3p5?=
 =?utf-8?B?VW1GaHRpM3hlSVZ3eWRaSGRKRGhxelhYaldaZWxFbG11Sjg1bDBQU01OYk4r?=
 =?utf-8?B?V1VFK2hjWGh1bXJiLzNwa1JtM3ZMUXhoT2JjTTZLV09NQURQUkU4QlVlRmdr?=
 =?utf-8?B?UXBUVTE4Zy9pSVA4azUvdGRkeUY4T3JPWUxEamxKWHB4QmVYTW1pUUNka1Fm?=
 =?utf-8?B?ZmdhdGpQZVdoVGZaZ2JKc0lsSlRvWGxCcXkwMXNvWUExVXV5N1I2USt2d2Ru?=
 =?utf-8?B?a0tuZ0h5RFRoVUtTczNjNlptckQvR2pNWHRLTjNqamJoZnZBRUtsdEJFdGhp?=
 =?utf-8?B?OWZYdE5tODBxZlUwbXNZbkRVaHBGZTIrWjl4N0VPZjBKc21tcjFyK0lGN0hn?=
 =?utf-8?B?ZFMrMTZqQllwUGU3ZGNUN1hrNzEreStGNU94Z2lLNWw4SWVLSW91aDdMZEpu?=
 =?utf-8?B?UjlwaUxGRnNnVWJhU2V5bktYNUI1bC9mUzdQb21VdTlqaWJYUyt2aFlmSE0x?=
 =?utf-8?B?VjZ2bVphaUFzQ1V6NkNyRWhWK1NqVGJvZ21FNEg1VkxVQ1p0ZlppK2JJVWpC?=
 =?utf-8?B?MmtLaXhhQVpZMXNUaEpEUkw5ZXVEK3dQZzRFOWtzcHhraDYvM2lnVGljV3JP?=
 =?utf-8?B?bzA5STZvZFhUbjFUaGdrQXluaEU0Wm8rMGZpSnhDeDJ6MHA1S1FJcXlhU3pR?=
 =?utf-8?B?dmFWUG5qWkhBbVhVQ1c4NW5kZXRSODgvQVIrWkJkWVBadFVreEhEQkFlL25S?=
 =?utf-8?B?Qm1Ob0VxVHRWT2xxTUIxZWpZQmd4ZC91bEJYZFNPbHd2YmNlaU93ZGFELzcy?=
 =?utf-8?B?NnRzaWVuT0ZhNUxncGpwTzJ6Z3hHaWxMOEdySHowTy9hSEhDZVRpbEFTaFlF?=
 =?utf-8?B?ck9ZNkNMMVVYS1VQeWxRQzlqbkpMcC9KU3NLbzZQL2xrcmh6d1QzS0lNYlF2?=
 =?utf-8?B?U1JiaVY0YUs4TjJ5RUlVQ2ticUpuSldpdC9QUk1XL2xjQTlYcHFyQ1NwZUV4?=
 =?utf-8?B?OXgxTi90VnlDMUdQZ2NSNS9hLzc4VUovaytBcUE1VUhnNzRiREx4RjJLN3pl?=
 =?utf-8?B?UU1DT08yS29MNTdncEZmNUJBUCtWN21vT1JRK3RCSE95NWZpUGZmaDdPNGgw?=
 =?utf-8?B?ZHBMRVlIMHE4UHZDQ0xJS0lEK0xGV05rT0JTZkFOL0xTWkRNNEhQRHM1a3NB?=
 =?utf-8?B?NHY3a3IvRFd3OFRPRDlEMlBramUva3RyRjBGaThNWmxnVDUza1BJZz09?=
X-Exchange-RoutingPolicyChecked: J5Ll7VBujT1C8DGgbr8qwL7rr5B3uhUsn/YYtezEPbDkXuiNiurBX28K61d4y74ByYO0BJQAd/v0s3mFeFb1Br0d+bS9W8BqR8Vg5rnQOwCgS1fx8mx3dgb4uIO5UjxzZyEgDPETjIw8qECUzXhFWsnwxt8E3Vj4GyP2c0w6MxpDHf0ngzjBnMYOWOWNXdL2OJP5fXiebJCvrY9kGi2ISLgSIxK2ivzG+rYAOcJIUKUk7IvSfq5/roSfS32u/bQVVjw2YRgQAZEmAd9Y2sR+77FFbOGe6bOrzlYS7M7Q3DFGLxZ2j4SU+o45Mv9I9BhdKKvJ6FXlEopmej9LVfdnTA==
X-MS-Exchange-CrossTenant-Network-Message-Id: dd0df72d-5907-46a0-d3b3-08de7e75a2a3
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4033.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 07:21:24.0283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z28iAE5RaPKUZ6cK26jEJ1iVgNU6SI65v7xE96+g4MUnlHKyHBH3s/n3Hcg8XJ70s4n0orhYQtP616EhfyLSOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7592
X-OriginatorOrg: intel.com

--wmrXy9HJV6rNqZoR
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

hi, Qu,

On Tue, Mar 10, 2026 at 05:33:16PM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/3/10 17:13, kernel test robot 写道:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed "xfstests.btrfs.052.fail" on:
> > 
> > commit: 50bb0fb60d1d55c7447535d17081ea009700cfd7 ("[PATCH v2 3/4] btrfs: move larger data folios out of experimental features")
> > url: https://github.com/intel-lab-lkp/linux/commits/Qu-Wenruo/btrfs-drop-2K-block-size-support/20260227-113649
> > base: https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git for-next
> > patch link: https://lore.kernel.org/all/0d8fe02f58ccbc0c53714ea45b0a4303f2ee8206.1772162871.git.wqu@suse.com/
> > patch subject: [PATCH v2 3/4] btrfs: move larger data folios out of experimental features
> > 
> > in testcase: xfstests
> > version: xfstests-x86_64-63a29724-1_20260218
> > with following parameters:
> > 
> > 	disk: 6HDD
> > 	fs: btrfs
> > 	test: btrfs-052
> > 
> > 
> > 
> > config: x86_64-rhel-9.4-func
> > compiler: gcc-14
> > test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 8G memory
> > 
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202603101405.288f83f3-lkp@intel.com
> > 
> > 
> > 2026-03-06 18:12:00 cd /lkp/benchmarks/xfstests
> > 2026-03-06 18:12:00 export TEST_DIR=/fs/sdb1
> > 2026-03-06 18:12:00 export TEST_DEV=/dev/sdb1
> > 2026-03-06 18:12:00 export FSTYP=btrfs
> > 2026-03-06 18:12:00 export SCRATCH_MNT=/fs/scratch
> > 2026-03-06 18:12:00 mkdir /fs/scratch -p
> > 2026-03-06 18:12:00 export SCRATCH_DEV_POOL="/dev/sdb2 /dev/sdb3 /dev/sdb4 /dev/sdb5 /dev/sdb6"
> > 2026-03-06 18:12:00 echo btrfs/052
> > 2026-03-06 18:12:00 ./check btrfs/052
> > FSTYP         -- btrfs
> > PLATFORM      -- Linux/x86_64 lkp-hsw-d01 7.0.0-rc1-00110-g50bb0fb60d1d #1 SMP PREEMPT_DYNAMIC Sat Mar  7 01:56:32 CST 2026
> > MKFS_OPTIONS  -- /dev/sdb2
> > MOUNT_OPTIONS -- /dev/sdb2 /fs/scratch
> > 
> > btrfs/052          [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//btrfs/052.out.bad)
> >      --- tests/btrfs/052.out	2026-02-18 09:47:02.000000000 +0000
> >      +++ /lkp/benchmarks/xfstests/results//btrfs/052.out.bad	2026-03-06 18:12:03.421371379 +0000
> >      @@ -91,553 +91,5 @@
> >       23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> >       *
> >       30
> >      -0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >      -*
> >      -2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> >      -*
> >      ...
> >      (Run 'diff -u /lkp/benchmarks/xfstests/tests/btrfs/052.out /lkp/benchmarks/xfstests/results//btrfs/052.out.bad'  to see the entire diff)
> > Ran: btrfs/052
> > Failures: btrfs/052
> > Failed 1 of 1 tests
> 
> Can you provide the full btrfs/052.full?

I attached tar.gz which contains all test results. thanks

> 
> I checked my older logs (we have enabled larger folios for a while for
> experimental tests) and can not fild a similar failure.
> 
> Thus I'm wondering what is causing the failure.
> 
> Thanks,
> Qu
> 
> > 
> > 
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20260310/202603101405.288f83f3-lkp@intel.com
> > 
> > 
> > 
> 

--wmrXy9HJV6rNqZoR
Content-Type: application/gzip
Content-Disposition: attachment; filename="results.tar.gz"
Content-Transfer-Encoding: base64

H4sIAAAAAAAAA+1Y32vbMBDOs/+Kgz20HSSWZFkuftvGCmOMsdA9jT3ItpyYOFaR5Kb973dOmtGm
CZ3TJBtMHyImPp1+3PlOn84o29bOhoMjgiCSJF4+Cafdk1HCVv9XGNCYxkxQHoloQCgVMRtAfMxF
rdFaJw3AYLFYDAvp5K5+9ezmFMs5NcyD//Opymejsq3rw8/ROVgIvtP/lPMN/0eCov/J4ZfyHP+5
/9u5bhuXQlja0OZGunyaQqMdLN+rYhT87lGo29AWGd0l3znC396jx248jf9aT44wx0vxz0i0Gf+c
xT7+T4HgszKNquFWGVvpJoVkREZkaHI6xMRMyXASkywjZSZIQYvgylTwpbOXAHqZUpaSCL5ffwBG
mAjGEvUzZzARkJgFV7KqW/y+Nt+pAijoEn+css769PA3sY7/lYuOM8ef8r8o4YxTlFOWiMTzv1Pg
qf8xREe6daNMFgec44X8z+N4k//zWHj+dxJ8ewfo8JvWQW6URLoG2T10mfoac3PVTGBRuSlIyPUC
SszdcF6oUuIncxG8r3U+s0jziqqsVJHCDwJDoD+3CBgKom0CjoJ4m0CgINkmuEQBw7EIENqrBW8D
BqRfQx0OeMT1aagjgPBeDXUobiju1VApIkFe60ZBuTxXU/jU3Mq6KkCaSTtXjfNm8mbqYyayx1ze
Dvvbwe/pFXtiZI/VMbqPGaL9TL7ziCRQlr2a98VrfbHO/WdhVjUrvrtkNPbeOjUHpDVGTrrD4HEl
Kyy1PgvOrVIQIgMMM9Xk07k0MxvelXZ5fw3XFPoRh+7qqFBqg6M6nNZe/LOX3Of8//A14JfqP1FC
N/k/Fb7+cxK8gb7hEHwcj7+O04ceD5QKdLPZL4VrdedWl4astfeB007WQJcaXV3oNRHpi9IeHh4e
Hh4eHh4eHh498Qvllf44ACgAAA==

--wmrXy9HJV6rNqZoR--
