Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C590721255A
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 02:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785464451; cv=fail; b=SDvtsHPOpK5Iu/9w1Icb4ESPDb/2xPm7dS47ZZGPvRq8h9m0LyiJ2M3MnrZWwcXOnwnEEwwPXuZbYQEm5ng6H2QH5g2doJzV/35Q5rqZDkMRRKagaisYW/s99CJw9cQsksG5+3cTv2dopeaFBAdtG5WypTEFzJG8/h8QFHYdL8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785464451; c=relaxed/simple;
	bh=afX2BMmFb00A99AW/J8/5GsU3nFyKC8mbdECxiW+NRo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iF1HDX+eG+uEdN4pfqCqreC1HpqzG2QoaX7BWBlJniW0BcukM9WDtAm1Jmmh12PId1elpdKgmbw88ItjwY4Y9qOJT5m7acx6+qGPfbNyoAwtTQ1fFK5fg9FZbCuYBcx3CRcBZfkDDqbC3oFTIDQoJWg2jyRtqyRvon93XUUNCSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ClGyQgCg; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ClGyQgCg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785464449; x=1817000449;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=afX2BMmFb00A99AW/J8/5GsU3nFyKC8mbdECxiW+NRo=;
  b=ClGyQgCgxrfUbZSl2HD1MbUNeVUd8PH0mlHEtLaiLMuvdbt8u4D87KgQ
   W5e3QwYrfk51BWGD14NA6mfbcH47Ubd8JjFmf+VQC/4/XHXSldHZW1K1p
   L73c4cR8UOdDV+Vwr1OgxbjAPojvL1jFZYSFEy2KljGCri0qLX/IBmVpl
   N8JSK6GAxLpW7nzITqxkGsuKdEeljOkxJ8K/9QFoS+03b1Co7+sTqUf4W
   O514S7WL5k95R2lKL5YeslThC/75POb8tqQnwcKw/0MbT7TC65H4CBu+d
   vhQWNcU0cIyO/qKU3pw2yi+aRhKr/t5gYe0ZGVgXOnENtXXmYPPdHJIpA
   A==;
X-CSE-ConnectionGUID: GnJfKsxNQn+4QRamN/OmSQ==
X-CSE-MsgGUID: P3R1UL9wRlKaIA2k+jGbog==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="97464975"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="97464975"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 19:20:48 -0700
X-CSE-ConnectionGUID: kSu0cSbcSLiC+ujx+nOfJQ==
X-CSE-MsgGUID: DUvW7cFrTmSaqS9hi9NHyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="285059869"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 19:20:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 19:20:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 19:20:47 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.61) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 19:20:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ed00F3QIzLDbcBok8NIbUWPPrr0l1TlOJZsbBCNMmj32yCJdpPUj98ItN+/lWB3TgGslKhtW9x/Q3VCkIgG8MU/CCZozrWsRsKlPZEdNp0uLDqyzg3+0iGQ4asTs7/zmS9E+lC0P37CT6IlAVolByGrRo6Sk4UykPc9S7JQnGSi8zP86j0K3DfjfWAhfDOwyKRgdoZ4eEXlFF1o59AfsbXZBQGU93ojkaBS+bKGXQmXbCaPKFTf+eJz8ZDLocvT3+9DRx3qbPKPbL4bHK1+kTK8AXzT8SG5gtWSkw5cli0RK3EQ3O3mSjlyauVzbEVZ8FZtb66SW6cYVL4DVxTrbqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HpWwSFau40aES/k2UNApacXy2HaPDceKL2cGDzpa5U=;
 b=tOHcc91PN0PtKCsBQHaJQ7qsbv/3m1ddH7HrYIrHUfE9CiPSb612cTCw2+MFqLVwFVzc8kxXXxckSf6eRUTPNwoyM7D25UQ3bQ4QLETt7G8iPx5+zbpBbRbS76iAkMtuHgKAYZQv/rOO1RcUVYJ2ysqIq9spwqbNuNWlzMCTin1qx4Z0GMnTACsymgFWSUm2aRhvKFbT13sTR4db6scp3aTs7IucoOvE8KDq/PJHhqGJQ5XepedCn9M0MMBjeO2Gn8lVQdMT9baOqFtFJdDJGPI8YaJkjiojk9/RwA/2Fj1xaVRVtisrouVCr5OUck/fou7EWOq3fxkFsVBWf579hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by CO1PR11MB4913.namprd11.prod.outlook.com (2603:10b6:303:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 02:20:40 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 02:20:39 +0000
Date: Fri, 31 Jul 2026 10:20:32 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Filipe Manana <fdmanana@kernel.org>
CC: "fdmanana@kernel.orgFilipe Manana" <fdmanana@suse.com>,
	<oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-btrfs@vger.kernel.org>,
	<ltp@lists.linux.it>, <oliver.sang@intel.com>
Subject: Re: [PATCH v2 3/5] btrfs: move condition for log commit wait into
 wait_log_commit()
Message-ID: <amwGcP7fJYfR4uZu@xsang-desk>
References: <842ef70c9ca3ddf17f8660ad24f63f6272621afa.1784733396.git.fdmanana@suse.com>
 <202607301616.c4685aab-lkp@intel.com>
 <CAL3q7H6=kW73FYPV866Pk5EPJ5paVcH_pmkYU5DcuqBPqa3DqA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H6=kW73FYPV866Pk5EPJ5paVcH_pmkYU5DcuqBPqa3DqA@mail.gmail.com>
X-ClientProxiedBy: TPYP295CA0030.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::16) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|CO1PR11MB4913:EE_
X-MS-Office365-Filtering-Correlation-Id: 77fdf895-dcfe-44ed-16d7-08deeeaa5083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|4143699003|11063799006|6133799003|56012099006|18002099003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info: XKu9u/oVnK2z6ji10T/HbIrSFTifvIT16NMgwj0PXXJ2VQ82zxG7naZR+tgLzL4rvHyOQ2nEiwapFcAkXo3spNnw/HD6K7j3Psh20WRMNu0FMuCOdIhCx3S2cb9XYPN+YPChEQfH6I6rkZAs659xfedLEffal+yW/Xsu0OzOV5y/nyXOj7HCdqTwsxCnw4R2kz5vYbQY8IZPqvub46IPirppR3QzcvEitPeUL2rC/wWdiKUQm7hCLcXhNgsnBPkGP72OdkBSSWuXMnFxs9oKuDKHafivmTThmDtP4TCwAt46fI2DwsATylro+X2Z3Be/k0Ghp0QT9+iNkwKtcieiDN9zNP3Uxf6il2mwV8pRh1r0YmwRMuEbqKgkzxx5WbnQ8QbrahFXCFMjgSHmDwsdd4kFiZ+6kh1LcIviB4FXkQ/fzkf7O6H5Z7K5SCyS9Bhht4HpXpktal8dY3odpP3b7s0cda7/wRCkjzj0k6YMyLeiZSkSUKS/RZ6xiTBGbiFH+G/uSr+//tqiSORcrBmH9CkL0BedpP0o3ZsKbhm2t38u+h1pvQAn6nHC3eukq2+rupEBy51oRx6aOy+D4wSPy+nt4FeBN810SU+pSGC5C/7VU4zIe7towTQaToo4xnGi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(4143699003)(11063799006)(6133799003)(56012099006)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blFqZmw3K0ttbkVSb20reVpPNzE0Q0U1UDB4Rmc3bkNqR0pSVmFrVDFxR3F6?=
 =?utf-8?B?L24wRWJrRzV1VlYyTkNuMnVqQ0ZMVzBuZEcvSlh1SGpxTXpubkl6UlhYc3hV?=
 =?utf-8?B?UXZTWXJTd1EvUi9kL0NoMExXVDBzbi8ySVRQdWR0MFRQTTB0d29xRm8xVWh2?=
 =?utf-8?B?dnBzMVF3Uk15dUFISnNWTXFWMVBoQnBNU3Q3NGMvbVR5bGMyS0NobkdieVps?=
 =?utf-8?B?YVo0cEhSSzBKc3E4ZXFMTXdTQmRFNWd3aGpkVzREcmgyMFI4N0UxamdWMmNs?=
 =?utf-8?B?MTlZbGptcVVkb3J2dzFxZFhVZmdtY0Y5WHE2aXEyMkZTSmpxRGROQ01BTUtK?=
 =?utf-8?B?QUNKZ1M4aUg4c09LOWZPNEptbGFRNFgwWHNFWXdlYXZQSllvbk5VYnhydWJZ?=
 =?utf-8?B?ZjA3TENaNFphKzN1Z2lxUWRKVk5qa1ByUVhJanRuejBPbWJpQXNWUUxhYnAw?=
 =?utf-8?B?ZDdtczBNbDA0Wm11NmJadXNPU1VmK1FmRXFmSmpNU2JXSno4M2QwaG5rdzho?=
 =?utf-8?B?TVVjZlNWbkdJbWYwU0l1dXNMUElwT01sNkNGbFVyTzVXaDdrKy9zaW9ybXp5?=
 =?utf-8?B?SWdzNDRIMk1kbWpBSGlWK3dzeCtnY01BTVprcmNtUlNURHFobDhLdmxKSitW?=
 =?utf-8?B?RVdkYnFRQW1wWWZxQVhKNHdOalBDMmVjQWw3V1ZuWjJHU0d6ZFcrUWtDRlM3?=
 =?utf-8?B?bE1aNzVCbEs4T0F0MlhDV2xJL2x0T0tzV1M5eDRnZjg5dDU1VGJORVBhbHpv?=
 =?utf-8?B?WDA4TUhwYW5EZ296dGdvdnJ0dEdhVlRJOFB6UEMvaThVa1pSNVZ3MUYzb21l?=
 =?utf-8?B?OUNxd1ZHTFJlRy93TlA0N3k0cExxNEdOUnlOd3QyQ0NJUC9WOEJzT1NncDRz?=
 =?utf-8?B?Zi9tMDBjOGNRV0g4Ti9IQnAxWnFUaVAyQjJxVFhhYUEyYWx6RnYvZWlUZFR4?=
 =?utf-8?B?WlVmendvL1RXSGE1TmF2L0tmaWlUdHBpRFdTTUgycDdPMnd0VEQ0bjErbVBF?=
 =?utf-8?B?bHVNQ3ZPY2lMRVlPbVBJSFVZaGFWdVZJYllmOFNiR2xTUTZ4OVVEYnd5d0ZU?=
 =?utf-8?B?YUs3ODl2TmtYSHNpV0Z6UDg4UmVZdHhzdmxUR2dDTnJMQWZSZElOQWdnSU9j?=
 =?utf-8?B?VU5HclY3RHFKVWxJVS9vcW1UdWUzaTBEaUMvb2lGaWF5ZG0wUHI5ZzUvU0xB?=
 =?utf-8?B?aXJPSHFNa2ZnSC84eGw0bXU1cG5RdnNzU3BwdXNtaEs4WHRwQ1RIb3FnOUpS?=
 =?utf-8?B?WTJ4T0k4OUVkVTdJWUhxMG1sRlVQWTg4UDZyaGVHblc1VCtzYnh5YzdsQnd4?=
 =?utf-8?B?M0k3MzRzQVVTZnJNeXdURjhKR3plSDFvZ1dhMEpEdG5TRGxPN1pKVXVVUjZ6?=
 =?utf-8?B?TGVjQ21VL3Q3QmRvWUFyR2VSOW42L2h5WTgySS8rUzN4VGUreFN4ellQYzJP?=
 =?utf-8?B?SzRoTjRiZ2FrRXpnakZadTQ1QU9KWWdvbWNrOFVxK3dCSHBWQmNmRkhUUzdn?=
 =?utf-8?B?UWVvQnNzWGhmcHg2Z3pPSVdpTEtzdE5nNDRkWEpjNkozMkdtVTB2SVRldlA4?=
 =?utf-8?B?OHJpU0ZqeGZSUlVBSGpwU2lpMk13dkZ1ZlVyc00yNjhvZ0I2bkFyMVRVSVJX?=
 =?utf-8?B?bkFkQnMvYmdVcmZUdmoyNWVyWUZHNThyKzU5MHhNNUcxQXhFWElKbjlTTEhs?=
 =?utf-8?B?NVJkS2QreThUR2luQTJjc2RObHp1eXNPaEFMMjU3TlUrM0QxdkNxU2V3S3ZC?=
 =?utf-8?B?dU9LbFNRTnVoaUc5S09jcHVRM2s5dzU0Lytwbnl1VDUwZ1pRcXZIYi9USWMy?=
 =?utf-8?B?SDVNQXJtZEtld3V2TUFZaGRHT1R0Zm8wU2Zrc2hjb0twZ0VaVkkwRGFGOFlx?=
 =?utf-8?B?L1IraE1jcXd2ZTU4dlc2a0VyWExJeEpDL0l1Zkl2R2JDSWZZdVRKM3gyKzlk?=
 =?utf-8?B?Q3h1VXNFdUR5MlMybnlGN28wT1h1Y2F1bXNLWm5TVVBPcWRyaGdRK2dXV0Y5?=
 =?utf-8?B?SnBWank2a20wY3ZSdWh4Mzh5TEV3QUgyY3daL3NuMXZuczgwem9FZVJ1YXp0?=
 =?utf-8?B?a3A4UE9oTTZNeEFIa3NZbkVOMXMxM09xK1J2bGhqa0JXbkxoR1FVQXlzMjFM?=
 =?utf-8?B?bEEzQlBqQURtdWpINkx0cGwzc3ZGWnR3bEtQNEtaOU1hWEN0R3lsMDVxMGpN?=
 =?utf-8?B?dXl5QXB0MkNYQnRhZXVNa1NheW5VY0NaTjRQYS9WalVGaFlOT0J3azZmSzdz?=
 =?utf-8?B?UGN6K3RzYjdLaHhBelVCZVU3NkF6Z0ZPU1Q4TXBwdkNmNUV3K3ZOUFMrKzgy?=
 =?utf-8?B?ZjlTZFVOelIxcHNMQ1pvNk5UdGlnZFJvblpvQU1Ja0ZqNHM3eHBpZz09?=
X-Exchange-RoutingPolicyChecked: BnH7tbx8c0l41yWk9QwvMe0LPet6jnHZ6c5AwCg9Mo9H3AZWBcQgA2NCra2Ob6RtRdiZkAiJY5/rWPoAMUfxzgcC3tANuqN+6eu7d3PWjEAeyqLe2Kr1pOs7ESDo26l34j/d9tm2OmwrwCS1aLqCSN+P+DTjsNiemjg3vlKRkcGBOJVAMcvEKVWnDahMibiSaH3oByJqI2/N99jyIin36V6v/rJvmnn6zIYvUVtKLEDBzZh+l4JsUg93VVuoQAhcP2DQofn5E4S5WVIisiWBXLjM1wJtrfhgOJbBkXTdrULG7XeOhBNPJrPMVCg8KObhL1F3BNQfUpQYukEIRj3sVQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 77fdf895-dcfe-44ed-16d7-08deeeaa5083
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 02:20:39.8534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEiJb78foouBQNpQUxGyKbivYzqVn7B+8gdwD+N27a15nZmgMLBvR4wm/Rj8/e9eJRdnaYC2QCUytm8t27VAog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4913
X-OriginatorOrg: intel.com

hi, Filipe Manana,

On Thu, Jul 30, 2026 at 04:24:30PM +0100, Filipe Manana wrote:
> On Thu, Jul 30, 2026 at 3:10 PM kernel test robot <oliver.sang@intel.com> wrote:
> >
> >
> >
> > Hello,
> >
> > kernel test robot noticed "UBSAN:array-index-out-of-bounds_in_btrfs/tree-log.c" on:
> 
> Yes, this was actually fixed before committing to the for-next branch
> on github, but missed the mailing list.

thanks a lot for information!

> The incremental diff is:
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index e59569770b7b..47046dd14997 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3168,7 +3168,7 @@ static int update_log_root(struct
> btrfs_trans_handle *trans,
>  static bool wait_log_commit(struct btrfs_root *root, int transid)
>  {
>         DEFINE_WAIT(wait);
> -       int index = transid % 2;
> +       const int index = (transid >= 0 ? transid % 2 : -transid % 2);
> 
>         if (!root->log_commit[index])
>                 return false;
> 
> Thanks.
> 
> >
> > commit: a99687b4edeead900d714fa0839a302a5a56d7aa ("[PATCH v2 3/5] btrfs: move condition for log commit wait into wait_log_commit()")
> > url: https://github.com/intel-lab-lkp/linux/commits/fdmanana-kernel-org/btrfs-stop-sleeping-for-one-jiffy-in-non-ssd-mounts-during-log-commit/20260722-235417
> > patch link: https://lore.kernel.org/all/842ef70c9ca3ddf17f8660ad24f63f6272621afa.1784733396.git.fdmanana@suse.com/
> > patch subject: [PATCH v2 3/5] btrfs: move condition for log commit wait into wait_log_commit()
> >
> > in testcase: ltp
> > version:
> > with following parameters:
> >
> >         disk: 1SSD
> >         fs: btrfs
> >         test: syscalls-01
> >
> >
> >
> > config: x86_64-rhel-9.4-ltp
> > compiler: gcc-14
> > test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 16G memory
> >
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> >
> >
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202607301616.c4685aab-lkp@intel.com
> >
> >
> >
> > kern  :warn  : [  104.466941] [   T5568] ------------[ cut here ]------------
> > kern  :err   : [  104.467469] [   T5568] UBSAN: array-index-out-of-bounds in btrfs/tree-log.c:3173:35
> > kern  :err   : [  104.467989] [   T5568] index -1 is out of range for type 'atomic_t [2]'
> > kern  :warn  : [  104.468507] [   T5568] CPU: 4 UID: 0 PID: 5568 Comm: fdatasync03 Not tainted 7.2.0-rc4+ #1 PREEMPT(lazy)
> > kern  :warn  : [  104.468512] [   T5568] Hardware name: System manufacturer System Product Name/Z170I PRO GAMING, BIOS 3805 05/16/2018
> > kern  :warn  : [  104.468514] [   T5568] Call Trace:
> > kern  :warn  : [  104.468516] [   T5568]  <TASK>
> > kern  :warn  : [  104.468519] [   T5568]  dump_stack_lvl (dump_stack.c:94 dump_stack.c:120)
> > kern  :warn  : [  104.468528] [   T5568]  ubsan_epilogue (ubsan.c:233)
> > kern  :warn  : [  104.468533] [   T5568]  __ubsan_handle_out_of_bounds.cold (ubsan.c:455 ubsan.c:442)
> > kern  :warn  : [  104.468539] [   T5568]  ? __pfx_stack_trace_consume_entry (usercopy_64.c:?)
> > kern  :warn  : [  104.468544] [   T5568] wait_log_commit (btrfs/tree-log.c:3173) btrfs
> > kern  :warn  : [  104.468751] [   T5568]  ? kernel_text_address (extable.c:125 extable.c:94)
> > kern  :warn  : [  104.468757] [   T5568]  ? __pfx_wait_log_commit (btrfs/tree-log.c:4984) btrfs
> > kern  :warn  : [  104.468950] [   T5568]  ? arch_stack_walk (x86/kernel/stacktrace.c:26)
> > kern  :warn  : [  104.468955] [   T5568]  ? __pfx_autoremove_wake_function (linux/list.h:441 (discriminator 4))
> > kern  :warn  : [  104.468961] [   T5568]  ? mutex_lock (linux/instrumented.h:55 linux/atomic/atomic-instrumented.h:4457 locking/mutex.c:161 locking/mutex.c:318)
> > kern  :warn  : [  104.468966] [   T5568]  ? __pfx_mutex_lock (locking/mutex.c:1164 (discriminator 1))
> > kern  :warn  : [  104.468973] [   T5568] btrfs_sync_log (btrfs/tree-log.c:3331) btrfs
> > kern  :warn  : [  104.469161] [   T5568]  ? __printk_deferred_exit (printk/printk_safe.c:55 (discriminator 1))
> > kern  :warn  : [  104.469164] [   T5568]  ? stack_depot_save_flags (stackdepot.c:728)
> > kern  :warn  : [  104.469168] [   T5568]  ? kasan_save_stack (kasan/common.c:58)
> > kern  :warn  : [  104.469171] [   T5568]  ? kasan_save_stack (kasan/common.c:57)
> > kern  :warn  : [  104.469174] [   T5568]  ? __pfx_btrfs_sync_log (btrfs/tree-log.c:3254) btrfs
> > kern  :warn  : [  104.469285] [   T5568]  ? do_fsync (sync.c:186 sync.c:200 sync.c:211)
> > kern  :warn  : [  104.469288] [   T5568]  ? __x64_sys_fdatasync (sync.c:221 sync.c:219 sync.c:219)
> > kern  :warn  : [  104.469291] [   T5568]  ? do_syscall_64 (x86/entry/syscall_64.c:63 x86/entry/syscall_64.c:94)
> > kern  :warn  : [  104.469294] [   T5568]  ? entry_SYSCALL_64_after_hwframe (x86/entry/entry_64.S:121)
> > kern  :warn  : [  104.469298] [   T5568]  ? __pfx_free_extent_buffer_clear_reading (btrfs/extent_io.c:3746) btrfs
> > kern  :warn  : [  104.469405] [   T5568]  ? __pfx_copy_inode_items_to_log (linux/list.h:161) btrfs
> > kern  :warn  : [  104.469512] [   T5568]  ? kasan_save_track (kasan/common.c:78)
> > kern  :warn  : [  104.469516] [   T5568]  ? kmem_cache_free (linux/kasan.h:235 slub.c:2705 slub.c:6405 slub.c:6532)
> > kern  :warn  : [  104.469519] [   T5568]  ? btrfs_release_path (btrfs/ctree.c:173 (discriminator 1)) btrfs
> > kern  :warn  : [  104.469618] [   T5568]  ? free_frozen_page_commit (linux/instrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 page_alloc.c:2809 page_alloc.c:2881)
> > kern  :warn  : [  104.469622] [   T5568]  ? __free_frozen_pages (linux/spinlock.h:390 page_alloc.c:2980)
> > kern  :warn  : [  104.469626] [   T5568]  ? __page_cache_release (linux/instrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 linux/page-flags.h:552 swap.c:76)
> > kern  :warn  : [  104.469629] [   T5568]  ? __virt_addr_valid (linux/mmzone.h:2187 (discriminator 1) linux/mmzone.h:2269 (discriminator 1) x86/mm/physaddr.c:54 (discriminator 1))
> > kern  :warn  : [  104.469632] [   T5568]  ? rcu_segcblist_enqueue (linux/instrumented.h:112 linux/atomic/atomic-instrumented.h:3260 rcu/rcu_segcblist.c:214 rcu/rcu_segcblist.c:231 rcu/rcu_segcblist.c:332)
> > kern  :warn  : [  104.469635] [   T5568]  ? __call_rcu_common+0x341/0x970
> > kern  :warn  : [  104.469639] [   T5568]  ? __pfx___call_rcu_common+0x10/0x10
> > kern  :warn  : [  104.469642] [   T5568]  ? _raw_spin_lock_irq (linux/instrumented.h:55 linux/atomic/atomic-instrumented.h:1301 asm-generic/qspinlock.h:111 linux/spinlock.h:187 linux/spinlock_api_smp.h:143 locking/spinlock.c:174)
> > kern  :warn  : [  104.469645] [   T5568]  ? detach_extent_buffer_folio (linux/mm.h:2124 linux/pagemap.h:636 btrfs/extent_io.c:2976) btrfs
> > kern  :warn  : [  104.469753] [   T5568]  ? release_extent_buffer (btrfs/extent_io.c:3758 btrfs/extent_io.c:3721) btrfs
> > kern  :warn  : [  104.469860] [   T5568]  ? free_extent_buffer_clear_reading (btrfs/extent_io.c:3821) btrfs
> > kern  :warn  : [  104.469966] [   T5568]  ? __pfx_free_extent_buffer_clear_reading (btrfs/extent_io.c:3746) btrfs
> > kern  :warn  : [  104.470073] [   T5568] btrfs_sync_file (btrfs/file.c:1726) btrfs
> > kern  :warn  : [  104.470181] [   T5568]  ? __pfx_btrfs_sync_file (btrfs/file.c:1489) btrfs
> > kern  :warn  : [  104.470296] [   T5568]  ? fdget (linux/instrumented.h:82 linux/atomic/atomic-instrumented.h:49 file.c:1194 file.c:1208)
> > kern  :warn  : [  104.470300] [   T5568]  do_fsync (sync.c:186 sync.c:200 sync.c:211)
> > kern  :warn  : [  104.470303] [   T5568]  __x64_sys_fdatasync (sync.c:221 sync.c:219 sync.c:219)
> > kern  :warn  : [  104.470306] [   T5568]  do_syscall_64 (x86/entry/syscall_64.c:63 x86/entry/syscall_64.c:94)
> > kern  :warn  : [  104.470310] [   T5568]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
> > kern  :warn  : [  104.470313] [   T5568]  ? __pfx_vfs_write (linux/fs.h:2733 (discriminator 1))
> > kern  :warn  : [  104.470317] [   T5568]  ? __x64_sys_munmap (mmap.c:1079 mmap.c:1076 mmap.c:1076)
> > kern  :warn  : [  104.470320] [   T5568]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
> > kern  :warn  : [  104.470324] [   T5568]  ? fdget_pos (linux/instrumented.h:82 linux/atomic/atomic-instrumented.h:3188 linux/file_ref.h:215 file.c:1231 file.c:1257)
> > kern  :warn  : [  104.470327] [   T5568]  ? ksys_write (read_write.c:739)
> > kern  :warn  : [  104.470330] [   T5568]  ? __pfx_ksys_write (read_write.c:723)
> > kern  :warn  : [  104.470333] [   T5568]  ? __pfx_ksys_write (read_write.c:723)
> > kern  :warn  : [  104.470337] [   T5568]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
> > kern  :warn  : [  104.470340] [   T5568]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
> > kern  :warn  : [  104.470344] [   T5568]  ? do_syscall_64 (linux/randomize_kstack.h:57 x86/entry/syscall_64.c:92)
> > kern  :warn  : [  104.470347] [   T5568]  entry_SYSCALL_64_after_hwframe (x86/entry/entry_64.S:121)
> > kern  :warn  : [  104.470350] [   T5568] RIP: 0033:0x7f28a60b5687
> > kern  :warn  : [  104.470353] [   T5568] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
> > All code
> > ========
> >    0:   48 89 fa                mov    %rdi,%rdx
> >    3:   4c 89 df                mov    %r11,%rdi
> >    6:   e8 58 b3 00 00          call   0xb363
> >    b:   8b 93 08 03 00 00       mov    0x308(%rbx),%edx
> >   11:   59                      pop    %rcx
> >   12:   5e                      pop    %rsi
> >   13:   48 83 f8 fc             cmp    $0xfffffffffffffffc,%rax
> >   17:   74 1a                   je     0x33
> >   19:   5b                      pop    %rbx
> >   1a:   c3                      ret
> >   1b:   0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
> >   22:   00
> >   23:   48 8b 44 24 10          mov    0x10(%rsp),%rax
> >   28:   0f 05                   syscall
> >   2a:*  5b                      pop    %rbx             <-- trapping instruction
> >   2b:   c3                      ret
> >   2c:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
> >   33:   83 e2 39                and    $0x39,%edx
> >   36:   83 fa 08                cmp    $0x8,%edx
> >   39:   75 de                   jne    0x19
> >   3b:   e8 23 ff ff ff          call   0xffffffffffffff63
> >
> > Code starting with the faulting instruction
> > ===========================================
> >    0:   5b                      pop    %rbx
> >    1:   c3                      ret
> >    2:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
> >    9:   83 e2 39                and    $0x39,%edx
> >    c:   83 fa 08                cmp    $0x8,%edx
> >    f:   75 de                   jne    0xffffffffffffffef
> >   11:   e8 23 ff ff ff          call   0xffffffffffffff39
> > kern  :warn  : [  104.470356] [   T5568] RSP: 002b:00007ffcb7666460 EFLAGS: 00000202 ORIG_RAX: 000000000000004b
> > kern  :warn  : [  104.470360] [   T5568] RAX: ffffffffffffffda RBX: 00007f28a6023780 RCX: 00007f28a60b5687
> > kern  :warn  : [  104.470362] [   T5568] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> > kern  :warn  : [  104.470363] [   T5568] RBP: 00007f28a6023720 R08: 0000000000000000 R09: 0000000000000000
> > kern  :warn  : [  104.470365] [   T5568] R10: 0000000000000000 R11: 0000000000000202 R12: 000056382db4c047
> > kern  :warn  : [  104.470367] [   T5568] R13: 0000000000000004 R14: 0000000000000000 R15: 000056382db4d260
> > kern  :warn  : [  104.470370] [   T5568]  </TASK>
> > kern  :warn  : [  104.504778] [   T5568] ---[ end trace ]---
> >
> >
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20260730/202607301616.c4685aab-lkp@intel.com
> >
> >
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> >
> >
