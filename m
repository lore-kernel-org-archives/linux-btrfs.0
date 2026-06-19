Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824C82F8E98
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859873; cv=fail; b=T5mtApJApXG61xyoWzN5L7wq8Ysf0Nn8FcUyD9q2mmVkeODSjB9timseS2cglgTRJQhkBNnc0INQ12MeF1JwgQiHBUfq15aRPQD4DtxZP+YJ9WSTSD2v6KqKEuCZr+ET9tOFcZAZ9AIa0dCeQ8DDG77IxsG1hgd9HAd6TDxhoCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859873; c=relaxed/simple;
	bh=ixgoHCV1204tu2ZrIs1nyX7Hc7ESuUQONO3Atb0w/zQ=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LtA+pI/+vgLja5dcuEEYTsBf9DTLRx04ZWca0HTgvB8QmGm6vTWdKCU0a7QgOoyysNuGdGvlkT9BDA+EvdA9hEy316HPIefZwBixSKz7vjFvrfCAoPDA8FWVawBGdfH7W3Dn+DGKFI+JqQCSMqWBOGMFjlxQkOwMAAlQliBbzvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Mo0CzuQw; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=S2B1vDXv; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Mo0CzuQw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="S2B1vDXv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859873; x=1813395873;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ixgoHCV1204tu2ZrIs1nyX7Hc7ESuUQONO3Atb0w/zQ=;
  b=Mo0CzuQwXY74+DRZf3HpggMdYjMKo0vuFF1vowPZ5JCU8MmK3vF6+zp3
   FfxIsR71ggnjhnCQjSaPjHshVCrO6RsAwmmNnWSG54hsKhP7qZ09H8mGj
   4H7zTHcdq9Nap3ZqLxpQjxdsmukScyzTvzUCNXngDM480fELK8K6nGTz1
   +0HX7PFlGS+iFiUPZT17EA2FzRZLFG7TGsxA7ztWIKjsw/46QFa4T3k2+
   h2HeW/AtOqhEUTdQ0ZQrhdaie/ZrnYAiOgtUeQteBtCGwgaJzUlJ3FhK4
   PRfiav1Lw2NPsHPzhF4+x45O46pSwoFWVgmV+a1n0KFeE5xPkDVo9XLzT
   Q==;
X-CSE-ConnectionGUID: SoPbxrC0RrCg1e1xUcbK1Q==
X-CSE-MsgGUID: cBsdJW/bQ2iMKzDZCkwgSA==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="150349865"
Received: from mail-eastusazon11011051.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 17:04:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j29WX3FVCtXr3LOkSztwWzTW7SZxqPwk5qLWa2ylYjTTA/j05n5CdNjiskSfYro+xUx6fomAtP6+b2sYIYirXOphiDUB1QRWvcdWG1m8BX84KOL62WbddeQGWo9hBIajsyNFlpzXo27QbveIjZTn4K4KiSl0H7ZkWCh25tNEyXWM/DwV9PpcI5jOkK+R6w98mlYK8jnuEvwmMrlfrpSASGTCcYfQJpY5cqeJU3M3805NdzTdVGWAKe0Bkb7yDPNtcf57+FflIlT57s8Uv912Qs/Sby0yf51tMdiiw+umxz3lDUJNEc0M8B5UQHiyOqeQ6818xIvLLceWXHpVmbH63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixgoHCV1204tu2ZrIs1nyX7Hc7ESuUQONO3Atb0w/zQ=;
 b=lM1JyF45HQ8NOtKED9HMoDIJNq+qNiyr+l7XK+bx9KqbUHNv25DU7gaX/qTrkA2P3HJFEyEwcTHDe9bWh7KkOVJolEAAZpULB7wN5tGJ3E/BC1jFFKFQp53yJCL0QM4E1lPeRD/sorFWAKRactTwwxkvYb69MCX053oF0Y5uXoWY3GRuhWvmb+UFb8lO4aiiFS+mzx61LVCUwMpuKoyIubMjsmT29Ti+QkDf9Tjb2Kjywa6rlo06himoVSMy5DgdE0KX86TAuM5q8tSYKnBdG6tGRRu8PHfijcsi6Lqg3cEpB1+zXu8jAmV+sKtrYvKryu+ihQCNDxVNAajtald/dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixgoHCV1204tu2ZrIs1nyX7Hc7ESuUQONO3Atb0w/zQ=;
 b=S2B1vDXvT4GRjDKxunaBuX+fIu6C9wNeXr968Nd6y+ahUQbvpxKOmqzURhD55rZ0QjoYxLUHA9xKQTBvSCJvsbK9Jq7RJWMrY+lAhJXEqTqeh4Kv4NobsISFfveF71+YbkusU7P2YBD8RcYHJsEzo5H0hU2IJFNa2yMsotVKybQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB8613.namprd04.prod.outlook.com (2603:10b6:510:259::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 09:04:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 09:04:26 +0000
Message-ID: <e081d35f-b93e-4349-a0ee-2a1c976e8929@wdc.com>
Date: Fri, 19 Jun 2026 11:04:22 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: remove the out-of-date comments on the 2K
 block size
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1781859111.git.wqu@suse.com>
 <b6fc790b78bc5147aa67de3850ced872eebff5d1.1781859111.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <b6fc790b78bc5147aa67de3850ced872eebff5d1.1781859111.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB8613:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e6f284-b7c5-4c28-1140-08decde1c36e
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|19092799006|4143699003|18002099003|56012099006|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
 qHm2vfEsj1Q5UCab2c/NSOIctmlpFRVrIXfco/MZFez+fdsJzuCwd2JanerWbsKSE5dG8TJ65d2Gp2rikVQ37LHxtsBC2d9j3aRwF3nPzpaVnG9BM/MrLWa3FWH34qpwtIW8gMh9DVppEYlNxVm7FqDTq8REDYjwLcs4hTt6K13vUGJfHFPX4MC675cavUYInlHCo+xAIO4fByVMy0MPitiBkYzBz4gA5C+Xzq2qRN1TVDbSj1h4jJu75QJnFq+e4olmd/WxXeUg+TxPyubcPVrZdne/DIvecUvI9D/SJeolP7vvmhiF3LwLpu/AGLWvW3hEv7+wSVS9ZrPzHTux1JFxVc1LBOXzrePpKHyHlnFnV1Wu5td91H1apJpm73o+dpCe/pyKHStEIvqmdTZ1E3b/hDjnrYbSpZ6upl2HW5DLM6BNd6z11AAEWR0XWouV5UabH/54z9azMdewyAgJPhD7xq4Cm6dbfxAwXTaiNlhUFOO+VXGwuBNVpXRXlyTZXdptf5uvJO6tQOJVpbRanp7CYR3yfWbWKW1r0/3GIRuxozBiHYAxCDfvA5b9HWbUq9PqO1bsl8ubt+l3Qt/Aep7gyl6YuDb2wmVIJUejJ4uR2bc/bD0yW3sWD/SMBB4hYm7jRo8+OflV5IWmQDp4pnOiw8E5uBtn4gpAxH2xtto=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(19092799006)(4143699003)(18002099003)(56012099006)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?T2ZRbnZiZ2hqa1k3eUdyY1lkanBqOUdSS2g0WmVzdytSR2E0djVzYU1zYW5q?=
 =?utf-8?B?L2o0djFwVU9HMjc4Y0VVdFBySWYxeXBTVStINHkvU1VtTWgxeTlzaklQSjdT?=
 =?utf-8?B?VlJIQnNDd1YvRHZacis2YVl2b2tCb0d6Q05zV3MvUGRuZW5odzZxRE53U1Nw?=
 =?utf-8?B?aXNaR0NkVmxheHVrUzc1VkFGakpHL2tzVDhyNDV6cGJsQTR4TlA4Q0hpdG5s?=
 =?utf-8?B?bUtNNGRQVVZKQUJOWkFsNkkvMWxYRlBZREZtdkxJQ2FVVEhBa3BhZ1dHTmVk?=
 =?utf-8?B?MWZaQkJMbVE4T3g5UVB2UEdQV2pVcVU2bldFM0V6TUlFUmxQMEs3eWdRT29C?=
 =?utf-8?B?QUtCMVMrSnRuMUw2dHJiUWVaQ1ZNMDhWeldXWkRRY05PTHJWcXNsbTU5cnpO?=
 =?utf-8?B?WnF0QldxR0EzS1hkd3ZyeURNQzgvb2tDNk9CSmptam5BRUUwalpZaUNGV21F?=
 =?utf-8?B?QVc3ejBnS2M5eDc0Qk9vTW80UkkweWVQR1ArQkJtSzZDM0hxcmlVR1RpNExn?=
 =?utf-8?B?RnJuRDJIL2FYUzNEUWRReHN0ZTkrWGdjODR6OFpZNkN3Zk9sOFJIdGQzVnhs?=
 =?utf-8?B?UWpQMlo4RXZ1b2pVK3FmRkdwajdDQXljMUhPcEZJc0piTDBKSWZQcWpGT2VO?=
 =?utf-8?B?cm12SEl0QVBrS3BIVmhxVEVzWjdJaWVwK1lsZVJBMXBHYitjdzg5Vm5Ra2c0?=
 =?utf-8?B?bDQ5dkhiZHZONVBZMVpnWGh4VENTWXBRRUhKY0YxQW9SNHFPOVhwRGZ3bFBX?=
 =?utf-8?B?M1BtTm9LY0I3TjVhZmp2bHBtcWZGQnM5bE0rUk1HQVBFTW54Ui94aTJoejZp?=
 =?utf-8?B?ZjV6NjRGV3VGSG91K0Nyc2ZPZ3N0R2pVTmMxNFdQcDQ0SzJNbGdpZ1V4T2Zz?=
 =?utf-8?B?YmpoN3RyME14UHhUTU1rYmdHRkx2ZW5kRldHbmFIdHlZRkdBUjVmZFlLRVNi?=
 =?utf-8?B?U2lkSmJ5VE9LcENTR3lsbzNEbXZ1Vk5oUlF3ekovRFkyQ1hZd0ttTElxU1N1?=
 =?utf-8?B?M1NmMjhSS1Y2YUZQb1o3K0oyblBmSW5IUERjT1Y4WlhFdmE2ZVFTbjM1K3lD?=
 =?utf-8?B?NXk3WEl6TEhwbUlEWGhabFpSdXZUNWM3U3grOXZFMi9OVEZnMjhZdnJMVlJq?=
 =?utf-8?B?NXR4V0g2NW56Y3JmbzZ2dFRvd09mYk9zVDY0SHc1S3ZIMGM0RWhISUlFNnkv?=
 =?utf-8?B?aTJOK08xYmlaeVJ5R1FhTzZFbURYTjVVMGlqNDlaajVER0RhT0VLMFNJTGFE?=
 =?utf-8?B?OFhBOUFBUHZQMHRjekxMNERJa0VvTS84WWlHRklQTkNUMHFTWk1UNjQ5eDdY?=
 =?utf-8?B?d1ZDYU1YM3d0a29MdkpjN2V6eTdwZHlqTkt2cEF6eFBjMHRjdkY1czNET0lM?=
 =?utf-8?B?YmF0TU1yS2FsU2N2djRsVk9XMys5SVg4ZHB1blI1VjRqR2FMN3JrNUJzZXlC?=
 =?utf-8?B?cVo0dGx2Q2g4bHVoTzc4U1JpMzNRM21EdnBmSk4vNUdMLzZkemJIMnNZZng2?=
 =?utf-8?B?SlRxQjJGYWVwSHF3VGVYbzVOV2s4cEZ1dzhjRzJiN2ZpRlFjUndHalVSWTJR?=
 =?utf-8?B?dnZkbityVU1jZXdKWklCVGpQd3V5aDE5UXd4Zk16dS9WakNYOVd5ZWxiV2Vr?=
 =?utf-8?B?d242WkxMR2J5YnlFQ2xELzNBZjN5OU1WNUgya1A1d3ZjdXNCa0Y3L1RmL1py?=
 =?utf-8?B?U1pEQUdFS0JJcTRyOXBPYkFXenFNWGd3djZBOVZReWEraG95NjZSbXVmWHQ0?=
 =?utf-8?B?RndjOElOSk8weG53NXpidXIyU1lKY2NjT3M4a3pOd1VIenRSY21BdEVwb2dz?=
 =?utf-8?B?L01pZytDZEhZQ29IQjRkaHIxSEJ2c0xGdzhXanlQN2JxU1prYzVLd0REWFEx?=
 =?utf-8?B?aUFBZ0dmWXNRRi9WRWtyNjBYbCtodi9pWTdBS0l6RDVlV2VMM0dkVVpyTTc1?=
 =?utf-8?B?bldrMGJzcU5QbVIrdE1SR0NpQXFGdGtDYVpKeTlqaXVIeEtKOHV3bWt4dWQ3?=
 =?utf-8?B?bDJ1MkgxZ0dYTWM4aGw2ZDRid3NWZDZmUkVXZHA1Z2ZZNUpDTzNoWEdwYTVp?=
 =?utf-8?B?QTUzZlYzemdVc1A0TFF2d3lHMTZmbHkwUGJiVEQwU3ZRbkloMzFtVldSSzUy?=
 =?utf-8?B?T2NHSDJoQnM4eVZnTUlCNGFITzd1YlpsY0FGcXN5c2s4d09Sc1dpbWc0MHRx?=
 =?utf-8?B?ZHhwT3U1Q0RJTEM0Z3Z3ckc3M1VRQmNianhaV1A3WExaU3pWVWYveWx4bEVB?=
 =?utf-8?B?eUlJQmZkV1R3Rk9wR1Nkak5KaTBWUlZFVzFwa0JxSzVMK0lQUjNyRjlIZURj?=
 =?utf-8?B?Mi9pY1I5K0loY0pZT1YzOE05MzdqQWc0UUlpYkNsSWtTWHBVNDV3Z05Na0VM?=
 =?utf-8?Q?0penPvvpyMkl+wRg=3D?=
X-Exchange-RoutingPolicyChecked:
	WrV+Cf4klDijxbxYkZkMOHzs3R8exl3Y1xkRrqqaL7IqeUMBDeP13CDUtVWyQw35j2BtOHHx+za1DUYxU/HVDZyIo4s2MDqcsXpfDs4EyEWEqSbfm3O7K8YTfCbhelBq57HwZQTjUc1yy9OLyGJs8VlgJJn6LrROoFDT2O9HN0c8+2S7BJ3iRgZeRR6hs/GI6+rrFk4S7tXHLaEc5sgs6kQdUlQ/R9X3eX2I7EjSsV59INujm8l53qkjhXXEpbTAX8hvDV8+E5YpWIcD7x9LIfrOhAUXKFAiuzM5CFyTz73P231ij/ksSk9T4rfECwV8e8Otsv6FQaPz/uDYsZUD3Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KKNKw6en/f7SVXN1NhOd595pnvClCqW8n/n+tQlrQVKPwCit0mH76032MiZJGOpQ63V+S2P2icBjtrHugo2f3krSvs0R4XzcsAWB7C8INj0qUuSuY8kOEP+sgH9OAm1gj84hQpY63LRb5oTaSHjTn+Ba5/no9ozJyLWLtRrbRWg05rHwVQvMNkfEOV3E3rEB5Er36yc+p4+S9x2l9/5xY6xqfHU4amVSfbs8NDPbfiEke18J9euns+7nDlzz6/vpPZ1MlZcApfzYr4/6ZAOM4I33vPUZta9AA4iOI3vyikd/t/chvXqxheK7N6gxOU4kpH0GD6UaFSBRnUCPnCMs4qr1ObuYNHkV25Hvgt/A69P/yVQyjm2T2g16ZmwBJ8hlyVbjFjXVhPjNdOcjZN3T4LOJCVmxR7gYY2kffPdD4trBM5tTpYiWuHEEgbkl2srJKFeKOICYpCyrw/qSRWxlyJDu12w8ZQRARbSJqLVDDs0oVcmUNFUhBwv3L++5aeQ4l+DBQBf2a38RcklDYNFB7Azq0s7X2yGkqHmRgE4XtBcohZDfSZSZQnm7hZYkoKqLbmWGkcLOPfZ568reKrhqRlgJZWD+aWumh9mG7j/J/TDTp6uMyTwuo2HQXYmh3POd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e6f284-b7c5-4c28-1140-08decde1c36e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 09:04:26.5799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zUz6qn/D3JBaHbVA/0pMcWZ64CazFcOWczvVqgJ+a/2D0NoP4vAoIS8nigitL+1WZsV+5FjDVfOCOfYihlwloKVIx90JuVdRUywOZy2A490=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8613

On 6/19/26 10:54 AM, Qu Wenruo wrote:
> Since commit bac3c2910c0c ("btrfs: remove 2K block size support") there
> is no 2K block size support inside btrfs anymore.
>
> Remove the stale comments of btrfS_supported_blocksize().

  Nit: s/btrfsS/btrfs/

Otherwise,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

