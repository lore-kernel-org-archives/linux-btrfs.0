Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C5E3403E0;
	Tue, 21 Jul 2026 06:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616234; cv=fail; b=WWvTf274vUCMdubS2erWvTF6OYSJDSuEUekcadxpK45t+ymu44ey1rL8G4zi4Wu5V6WPMwTx7yxbdfp49VZODp5APS7xM1kujJIIfwdTMsnNZH5opYpyWpaS2hpbZKvtFSoFxgK7Xrh1HO73en0gi4LZt80/X5r6zaenYeIlupM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616234; c=relaxed/simple;
	bh=P+paPPbRFK4PzIRKKFhOTJNkdDsF3GDTypKHONK/KVU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TuUPirDMG7x2PSDJaVuB8J3q0mnW85sLI1hDREXng7voDGcO++6lAjaxewBVOsVpqGrBOSETC7/TH6+zUe+OcoaXtmR/462+CZeLQMyZWM9BpG6B39kj0wadcsZSF7a7HDbl+sYqlDR5CrF8tsJR7RGJlQHl5hizfvmycOnWmsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RONo7MB1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vfkBH2kc; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RONo7MB1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vfkBH2kc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784616233; x=1816152233;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P+paPPbRFK4PzIRKKFhOTJNkdDsF3GDTypKHONK/KVU=;
  b=RONo7MB1+fLv7r66iHue7HkXf+mXIZS8mUIjD6sY3CFWEGd2Wh+RBcER
   OfQfhYIgiwYzTytu81nuLqkAaD2MpeCB6WPj81WvZgi/cW0SPP8eHg+/Y
   KgqgGW2Qqd6LqmgiL9pky/GyynUdNmHNWwmURIT0fok1jfTRlRLxbbXvH
   wyZPR/r1gPQnGJ05CEafVUkO3kjaQ7hNn5nCnf5kGuvqTxK23GSbh4QEZ
   FMYWq4WrKdyg85azgcWBguILn5Qi1XPvjqPVL6z724xtI0rY+AX1JuFYe
   pR8MxpUzA75HCZlxGJbziqSUczhTA3tui3FADNgC1REmhve67FUvFSown
   Q==;
X-CSE-ConnectionGUID: d9uYPgeWTtat5LgkGWR/gg==
X-CSE-MsgGUID: Rutid8IoQSiPgZP3mVrndw==
X-IronPort-AV: E=Sophos;i="6.25,176,1779120000"; 
   d="scan'208";a="152365588"
Received: from mail-eastusazon11011033.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jul 2026 14:43:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bRHUX6GeEyCLQ6M9X15QYwh/6Gk+HYkdycV0SXnaDt7aiZNAWBGsJtlve6JGsUA4L9xWDxiAJvds0hThA2tzXrl8X27bGyDaPvybzOiTxS2bMf9LC2qL3hpcPf/iwAPSo4f+8sv//W17DZbb/wp6XF8kK7Jtwmgmkq4vmW6ZYqR1wD+r99luzmUI5ICoFzbBo8Jq1qQaqnC76/47mWrmaSJHmgnVNvObpWLT/zUugqqtRuzNtmQmKKmUhAG7swczFYOU/LwSecLoJpVxtNXXuH3i2bsPkFOwh4lsWf5KnFnCwCMpwHdJEsYL2JRyOze2SBMSuL9P199PKXPVvGvj5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Q96yFJItHal/7lga3Qsm0CZDMHe2wbtp44mDGchwAU=;
 b=nr3SMKtAGIfQRemLh4AfR2Cdg5LdvHDzRZFm0mtVzqhimUUjKtJk3K5Qj4U1qmgnQ7ko1gQaSHC0Xiur24eDYjgjfG40Fu1GZEVnzcHzdAaZGJBLSSSfnE75jsHyHrInIrjdjqhxAZWG5iOrUqfM5jydBj4Jke5ZUlNA9yYOXFCKIhP5R140TjCuRpbw3eU9mNEd2pr7EIOgGfyzSY9buGEq/YgmTjkbxyCILXHQeMKw72MJn0Z6v8DXeB8osuK7xDxIWx0phnjzRie9k9/PORcPZ9lZV0V2zTz3exskQ8S0bv6mIb7QwTbyGH5xAUUlivZMz9I2j9rrUSFe0WJ91Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Q96yFJItHal/7lga3Qsm0CZDMHe2wbtp44mDGchwAU=;
 b=vfkBH2kcBVW4qOpSs6e31Q8x+eVXpSjB1vOjj8wtKfAvCjZw/nGds8odbqC4lTR/ObGBzYvnSmGt8H6SXNrApfLCEC8GRFBVG+P07bsTFqu3pDUtKZ9wBFWq79mGu4UuX/9e/iQ8UUHUfJyQ68Lt+c47FUGRNFCD+lfzWUcW/9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA1PR04MB9899.namprd04.prod.outlook.com (2603:10b6:806:4a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 06:43:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 06:43:44 +0000
Message-ID: <fab7934e-8561-4eac-9b54-1fcf71a75af1@wdc.com>
Date: Tue, 21 Jul 2026 08:43:40 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] common/btrfs: fix awk field separator in
 _check_temp_fsid
To: Filipe Manana <fdmanana@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
 <20260720111849.1659111-2-johannes.thumshirn@wdc.com>
 <CAL3q7H7dvTuj+cuemk9qo3YK5Hqec6nM94HaaLjBHnRDL1hwrw@mail.gmail.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAL3q7H7dvTuj+cuemk9qo3YK5Hqec6nM94HaaLjBHnRDL1hwrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f3::19) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA1PR04MB9899:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d98001f-d7be-45b5-6d22-08dee6f368d5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|10070799003|1800799024|19092799006|6133799003|22082099003|18002099003|3023799007|56012099006|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	dF+mSSiw9cljbIPkuRnXr0fzXy5TgCWnUS9pax+vtS2YbXJ9fSLdZyKu4BVHnzTRMUT7guv5o6u6YpQXRS7e0Itw8qQC9BAo92Sc9MdqCdF1S4i+vFUdwfnuXvdtUjrD62ishvj7dJ/U/LXImksS5KDoXt84idsz0Jj3A9Ig9PEu8rKBtAgxpPY2jO+n52N42HbEVVWyUmel0fydm5EIHcK0av6ShgFj9RrYnUXWIXQ5YJVzvdjVjeiveNy7I8Ds3w5l+tL3Js1JpzzcI95sAZbgXsk1Sv1QL5bobUew1o+Vf57N8ffW0doRZqGSEJriOMoZ9kwIILCinu4jCWrgzVYB1dOdzlhsDPmYvELiCyml9plC/F02tssBg4FdEubCTgyx/ZG/EXYmjihZwS9w6RbSP8Mj+hRN+mX7G04dPZ4MJfBcdtqwLj/g7w+3DLwl+yp9aTE/ruS4Gk6cMMLkMRGQw8VAqkp05LaJDVbjuG5SHXTk6HUzFLqVPpEiTE/AWIz/eP1kBBiv6aYMycdoV2AXkjue0oY9/8FSTH0B4cA2uZ0C6WCaIiSfHYIK+UxdxBmkbprASe9kBMLWTjO3hisUcBuzKmYh//72NacW63TaDK5ucU7wbj0X4BS2cthKd8y5gBtzEE71sw5DjBG996/DT5LDQsqQkyHq4E/7dgs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(10070799003)(1800799024)(19092799006)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czA1VlhkVGh3eTNSRUtlc3RBdmRpVm91VkY2ZDFjNjVtRmJMalJZc1NwNkw1?=
 =?utf-8?B?aTE5aWdpTjhKRzFwb0d0SitTSTFCRXhBQi8yc2NtZkJkRDhoMUpORUJpU3pU?=
 =?utf-8?B?UkhJZ0haZEdFT1pkVyt6elRkQkgxbjJ3dWJSNlhYRTRtejdoNWFyS0hPZ2Fh?=
 =?utf-8?B?dVFDMVBPV2lKbEdWckh2UlVCeGVuck82OVJraUQxcTJQeE9GRnlOS29iMTBi?=
 =?utf-8?B?bDIrR0xUNnpQbmJpVDRYeGc2TStiWldkeEhNQW8zeFp4Q3Z1VEF5dElsRFUr?=
 =?utf-8?B?T0ZkeDB5bjFkbDRFWGRmNVBubFJEem9XYmhVdW9neWdoODV3ZDdwaklRcUFW?=
 =?utf-8?B?Z3lacDhaV1Q4SnlSMFdneUJVcmxQb21uL2JXcmNyajR5a2ViQjFiSWJLUEZL?=
 =?utf-8?B?Y0F5MVJQTVNteW90NzU4MkVnZWN2SVZSSjljVlR1K29QUDFuejlsUkRJeWI0?=
 =?utf-8?B?MmRBK3MxbDJjL1dDMWY2NVg5QVpSZ1BZa052RkNFTTZiY1JrRmoxWEVhYm5p?=
 =?utf-8?B?UXRmVGg2Q1NsdjVTanJhNG9sSlRWYk8zUlFkbE1YTEtxUmZ1bzNML2ljdmh0?=
 =?utf-8?B?Mkx1dGFuRm4zZkNWQ1ZEYW8rSHlhMXR1MFYyeW93cmZINGppRmd2ZDRSaDhm?=
 =?utf-8?B?Z3ZXNnFieWQ3MzRoWmo5MzB0cnJHRWNrWHFobXNaRWR6UmhxMGtqVUxtbWti?=
 =?utf-8?B?UDBVZWtZelM3OEo3QjZOVGljS1BZQ0w3MFpPR0ZpUkVKYklJZkdkMVNyMFFY?=
 =?utf-8?B?NjE1Tk51VzZuSXBNNE84eE1vTWZBaXdySXRMRnJXck9lSWRxa2FNdUJwSFFo?=
 =?utf-8?B?OG9vRTNzaTlYN3Vvek9ESGdjckFnVkRiVlROZnJqUU5SZ0dNaXd2YjVMMWNs?=
 =?utf-8?B?Qk01UzgzcTVKb1ZLcTdmR0NBUXlTc0xIcVV1NWdYcGdqanN1blpXYTlXNk9p?=
 =?utf-8?B?QzNVNml1RmQ3WFZuWW00MTdiWmI0dkZrbVp4WWdvYVRzVTlJa2FPWFMvaXpX?=
 =?utf-8?B?YkgyUzhWZmNObHhVVGNFRU15dHM0cFM1emY4ZWNQMnl0Sm0yQmxPanc3bXJh?=
 =?utf-8?B?dS83OE9YdTBPTHFSSDExT0JjSk5CL1laUUZuWDFWcHdHTzZiUkVmUGsvU2o1?=
 =?utf-8?B?YkQ4ZHlhcU5TOFp3Ti9KS1JIdnk2azBQcDh3ZzU4N2Q4ZjFveFRibzlmYVVk?=
 =?utf-8?B?YWRVeDVyUk1Ud3JEb0Y2YUU2RFIwOXFod3BDemx1ZWo4blZkdURJZS9aZExy?=
 =?utf-8?B?Q292bVRMYWkwOVRJTEVYTTR6MmxWbnU3MDg2a1BnZ3d1UGttLzkxNGsyOWVr?=
 =?utf-8?B?bm11bFpCbkdCbDRmNmY1WEpaMUpxa1kvZnQ5RHpMNWlEdGdjQjlNN0xEQThL?=
 =?utf-8?B?TGdBK1dzcFdkZzR3Vlp4Sm9aUkZ5cXpkbmdGTi9UMGRVVyt3aHR4cDdhSWh3?=
 =?utf-8?B?SUhaT0RLWURUQ3Jhc0Njc1JGSUFYdVF1VlAxQVNnMStBL3IxRU8xUWpqclRO?=
 =?utf-8?B?dVRGeVZ6UVVOK2wzQVN3VmFEK3JKenJiVUNaOTErZTk5VUh0NEYrQU9zRkNx?=
 =?utf-8?B?YzBNVHRsQmZqN1I2azJlb3U0K0lZQ1JGNzZ5UGU0YTlPcmJzYlJibWNhdkd1?=
 =?utf-8?B?QWNrV254NWx3MzlkdkFBaWdIejB0QW5BbFowdmhxejlEM2VJeGtJMjd5RW1H?=
 =?utf-8?B?bEUxL0YxbG5BalNKWU1XRlVMZERjUjY5bnAyMkVHOGpDa1dMRUZkL1RHVkVi?=
 =?utf-8?B?N2g0VUVKRklxa0xOS1JERDU1dHhnMk9vWThZSFVhcXFwaVYvcUxnZG42cHB1?=
 =?utf-8?B?WXM0V2Fkc3NUbnowM2ZGQm95Z2FKWjFkOEF4eDJ5emlLd2NMWVdsNlJGZ1RV?=
 =?utf-8?B?UDR4blVTR0hyeExnUmVqL2V0Q0pNVmluRE0reGRnZ1Nremdhd1BGRlEyVTVW?=
 =?utf-8?B?SjVKcE5IN2VkQmpOeDRTSTlubnBTUzV1bTZvUStHa0hNYmRySUpObkpPYWhk?=
 =?utf-8?B?Qmt0V0d4ekdWYVhmbzhNWlg4TFNmNVc4VDNnYjVyT2FHVEQzK2ZBeWdxdDBi?=
 =?utf-8?B?ek5HME9YRkk5bG5OUGZvOFh4MzBvekUxc29vb0JZN2FqclRaUHhBNTM5U1l1?=
 =?utf-8?B?SjgvRzBQTjZlMVJrSkpCSmFtRVJlWUprSFAyK1NMN1lSOFhHQ2tlaXFxcDQx?=
 =?utf-8?B?RW1VVlEvM2pjbW00VEViUkpGMlRacFVPMzdrRHE3RHFEYmZpYVpOUFFpSDFG?=
 =?utf-8?B?VDhINnJ5dFBITmZwbmx2V2RKS0plMlN6RHFYbmp1bWpzODZkYXRCcTNBa1RI?=
 =?utf-8?B?eCtVZGhxc002d0lWMzQ3b0p0OGl3cTNTTGgxaUhNYkt1bWc3L0JFQkZLN0RL?=
 =?utf-8?Q?oGDeBowYAkBsNnhaM8kvORz++FBTX+aatDPhDJ0cEiXXs?=
X-MS-Exchange-AntiSpam-MessageData-1: npTyTAjcgj77FB3PiHqGwGWHZvSvn6tKGGc=
X-Exchange-RoutingPolicyChecked:
	fC6NsknTrGvaXEYWFFsFwJ1cPy/Jjc+vVQlhgl9xS8yEHkpn07xqq1WfcOu+GGS0uo2+MPIKQOsO2ljYX2bBRsNv1bKr74GtssdHGez9BoB3frtbBbgNn6VYCsV029hcwJKidrHTy0lQzmYityE/PMlpuvtg4JFbnvHYYOXPNBeu8z0p+Z1rJazer8K38XvqIneQN3JbV2DBBry4MRxyMgABT4J14fbmVniA5lvafPZzvTBoYOEFPhSMtpHBhYVj+VO8Koa3TrZM9MwaixBqfFKWFU+SuKcAj4RoJ3ysFtjTHfNmTR2WCu67Sk9UYqbb4ysVVDIyPH4OQHgDGaVxqQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V7XYCQjYA1T1+2ghBiK4Es09eZE1ZoXkJiMelMW/UvKNRvQnLSa4gOTKOADMoZ4aJbjrqaCn6P0iuEx3EARRoYF5jyzkzuEpOOUg+YOAcctYazh1ckeE1JsrBjui2TEHEsnwvl0+jC864j8891EnZI+eSaUtCqezrT0espYPTsHuQn9Th0EC1eapWoVtlbukCPV16l/bZhSD7VUm5C1B1Wvg6l28sJqlnHdK4Ccsiwh2nF5K6Zj+8mxIvZ31DPSAZ2gZyU8aarK0PRvdQU4o4EvowcZDbQIXrSFCkXZqGSv6oHO+OUhA5WEnA0YzQdnxpedsM/bOsr1hZMgVbXTDX49sWvXMx/wr1nDWaw7sSELOGxEs7ESBFfQYmQBfO5GkllWaOrva8J1CCVP/25lqWnEvqbZx2SbhA1kqmjPgAeTImhHjXX8nUGuV9mA602OHiUCuw90luR0bozQQsvyIwnqTiBGx+zOp5Ez17qocU+eUx1v7AxYe4CvvkbiFI73djdKh0l+J78m0mVQmgu8XwK4ugtfomZkwHvzboi9amfpgZTYYn+fFpgqcra99rn+ntSinz9sIZgwRH9eh8PkQ3wiH4uaF3bpkVxuuNeWh/ptxkVRQ3mQCrgXmw6jvHH+E
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d98001f-d7be-45b5-6d22-08dee6f368d5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 06:43:44.5487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q2i341lAjVxIFWEIU703PrHhP8+GngPBxGXOMdj8p6j85RxdcLykC+4tbVavYLSmXf1PDR/QYoeGws5wq27qXF3DDfub+EggYIKmb/+grLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB9899

On 20.07.26 18:44, Filipe Manana wrote:
> On Mon, Jul 20, 2026 at 12:34 PM Johannes Thumshirn
> <johannes.thumshirn@wdc.com> wrote:
>>
>> _check_temp_fsid() extracted the on-disk fsid with "awk -d\" \"",
>> but -d is gawk's --dump-variables option, not a field separator.
>> As a result awk tried to open a file named " " for writing and dumped
>> its variable list, polluting the test output with messages like:
>>
>>    awk: warning: could not open ' ' for writing: Read-only file system
>>    awk: warning: sending variable list to standard error
>>    ARGC: 1
>>    ARGIND: 0
>>    ...
>>
>> which made btrfs/311 (the only test currently exercising this helper)
>> fail. Use -F" " to set the field separator as intended.
> 
> This is all correct and makes sense.
> 
> I wonder why the test doesn't fail on my Debian box.
> My awk is a symlink to gawk and the man page, as well as running 'awk
> --help', confirms -d is to dump variables to a file and -F is the
> field separator as you say here.
> 
> So I'm puzzled. Any idea?
I have no idea. Fails reliably on all my Fedora boxes.
