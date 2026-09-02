Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F4F39A815;
	Wed,  2 Sep 2026 10:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345842; cv=fail; b=GtLxcKOtlWRJz0GpJR/S+GdVN8pkQx4dnOaCdzcl+VeH84z5dFWBa69y1jww1sxVqgufezbsJv2Z6CaafUl1Hey7tsHU12pW0VAXvfImj5GZGmVsA051BGn0uMR92Lll3WEApop1m9yMhvNQRT7Akep18xFIlRvTsrjoXCnmLkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345842; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iitNFaDjk2RUqJsxiPCA8n8nIKNt/6dsmcBdDwKrEYcysDgSexUaKz7F0xGl0I3eg0M3z8hI9slowO4zVBP8v5pzOLCtzoRYb/KXFtmwI7kQXq2bQZESsCKvD1pVEwDR3b8YmDLo1UtULvdVn3JFrkUJT10Qgbw1KcpglMzZcas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lZD3pMRV; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FmQiNG9O; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lZD3pMRV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FmQiNG9O"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788345844; x=1819881844;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=lZD3pMRVmeoPC3BuXY1a85qANLw7F6HI3LiW9x2TZYDLtXG2n1Tju6yL
   mG2l8Q/n+uDPq6VJli39MQPszKMzJxoNM142OkrX9WwUQVHvjgWdvRqPM
   rY+T2JT2Xvd6/KHt95BZ2+roLKXO+g5ljnM4FM4wm81JshQfLKK1onOqT
   PLpmb70Ea3XZqtNyr7TzHMBkUrSW2d8xbdisa5c/0hQqfsgiLaWR5znBv
   9rth9s6k2KUlxrBQji61p+M+bE/GGvNFdldobpOAcuGHUm+LF9jTE8M2/
   qUC1Waz0EpCW5EmE8/zxaoXvUK/TuTdIm4/fKh4cMFotl1F6QJmz6RUQU
   A==;
X-CSE-ConnectionGUID: K7yXBzr2TO2f/p82mtiV3w==
X-CSE-MsgGUID: dkvp0+EsRu2lqWy9f/Ispw==
X-IronPort-AV: E=Sophos;i="6.25,257,1779120000"; 
   d="scan'208";a="153197569"
Received: from mail-centralusazon11011051.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Sep 2026 18:43:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DC2oFjKTVN8GeOiggOeRbqepm5Zpl4x2Tw6inuOfbof5y1IApNjRs0eejymWGccotDnHYLU4yiq5rmWGNPAj8aCSE6H5i45rT2p+R+9GkRAWWshbS5gMG52mLcsEaE0gxQITAot2YiGN0/HF8fvewRYrjd/80C2dpLxW52uYumZlBkKFME+DZ3p8U+EwIN/qZrtdSPgDzjPg0sGgzXzvLBes12R5CTDNDbzffXPtaKg4cpb7DwAA/eqN1gR4Og5jICb0bDxJ5SffJ7DsQxZdLhvkI8KCkQSgiAoaEYaTBR8ufTHrJ7io9kSljnRSMb2znxFIuA54cldnlDv+Di5Z/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=a+jL0v+mkxiTjqhAZoSXZe0Oyq1qGRL8WcyMgUUkw3yWRcRYruZaEYI5MRF8Wx5y/OcavaWv2MgztCfpLTq1psbOzopPj5UyFGUOKof/ZorUKkowTT7sEpCAhSnk6zxvWHSn1V+UhO7FCaa6fVwaaEZzGhwj/GM6oMooVWBMIsHxHcRIH4Vx5QGuWifbxgQREFhhkQyPXpPUKCLnn2Hy+zhVOqLAEPxrSn0K/nOu9sBzZHXgLIAvrF7mm0OhJMtjZNSYLPav/Ofp5cgGqLu6OuBB5IZ1Blq+TwmV3yxHICJ8jv86717eERfrsRzt5vtYQbTwN3l6wDUdlHXKC/Dlww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=FmQiNG9OjLjkcf3+exrzKG7e5aiPF4leUa7/fVnMDWYQkpe7P3svkr/MgaGMcPlV8wiq5ZUKqQzco3oB/pWv2bsM4fiivGm/qLzZVVWgwoVSb6BVYUprapFvIo1sB+6KXlZlItFm2iebB9YIygFPlL8nEV3r4wX9kYT9LGA83rI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS1PR04MB9583.namprd04.prod.outlook.com (2603:10b6:8:219::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 10:43:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 10:43:48 +0000
Message-ID: <47267630-9cb6-411c-a25d-b0716e4dcfa7@wdc.com>
Date: Wed, 2 Sep 2026 12:43:42 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs/273: add missing _require_scratch check
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>, fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
 Filipe Manana <fdmanana@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
References: <20260902094200.6270-1-prabhakar.pujeri@dell.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260902094200.6270-1-prabhakar.pujeri@dell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0118.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::9) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS1PR04MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b8f819-8216-4c97-85be-08df08df11c0
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|376014|23010399003|1800799024|10070799003|366016|11063799006|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 9rVHh0JLqDLBPEWvGB3GGnDI8TDIhARMOt3vy5ssbRyAmvL7UD5x5uZeySeRxUCZmNVb/lJpMw1wtq/nV5YokH6mwuyB72Ec26KEcCxrZNkXVgqfi+AxY8otXO7wOlXY1cEalTE/USrHP8y4Dpc1xJmFgv5KQWNVb0kJ43zCGJccOiaTM0nT5buxOfEEKlNkVfJINwq+7yoCQ8rV1G9/L6EeMnt2RvnZe6IAmr2agz1JZcFnFPgi7D/7qvLxaQNzHO5zXkuKl5MYPaebPB+2V45wwaGNkvC2c5KCWGWCLv1C0rhN8zl7LmuVngM1W9t2s999+lGIjwL0ajygssHHlDKlC227PTZTrh+i1AQEiqpn1K4x6D64TrPofy3E14VvmkfBb8vad1n2ljqGnOaC8y7HRdNnG3VHkIAoXQX+8owU5L7z3MQFWujBLzLd4ygOVOSJI+Xqe7BpVoSymSi+R1nzonkkxRR/Z9ri8ImTw9sy9bmwuFy4Ubj5t+N9NSWtpKIGJZGmKYT7WbfBTzSLkpScqnVVD12auiF6q5801nU/DNfZtTMJAd8jqpK8BHVakvjWD16X/t61AV5XpxycRpm5+SQVEiTMibZMGAbkRNtbt2ui+dLTo7cMLE7uWMsT2UH9ewogBuyilrGYy55dXj/C0cA95MFIuR9e4zuG1Kc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(1800799024)(10070799003)(366016)(11063799006)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bGtsR0d6OE1wNnZ3Yzl6UEZBVkV4am1vNVdRb3NLM0tRRjhjbjhHZFJqRDBz?=
 =?utf-8?B?RXVNU09RRUlRbWs3WldNNTM3Qy9Dcm5MOGYzUjdvS053elRvaFFYT0NZS2Vk?=
 =?utf-8?B?bUdhWDM3SGpHRnYxVE5jTHEweUpVNnh0SzlIZi9ZbnlaUmJWOW4yL1E0M0Vj?=
 =?utf-8?B?YUFPcmp0QTBHeGJQM3pXNURta2tlQ1Y3WkVBa3o5ZXFwNk1PUHpiaGUyUVZF?=
 =?utf-8?B?bEZ2NE13aFcycGNWT0J2MnRhK2wrOUlqQXVSUUlncjhPV1c0VVQxWDIxdDdp?=
 =?utf-8?B?RFNhSXJ3QlBZbGRKMi8yOEtRQjZvZDQwZkVTZjQvamlwYmdPU1dvWnZ4TGN0?=
 =?utf-8?B?cmMrZUN0ZTNWeWtHRHhxUXBucEFpTjZtY0NYaUdGT0Z1UHcwN213T2R3S2lY?=
 =?utf-8?B?cWhiYlY0UXVhaXplZWtvdVorLzBJUXNFUmV3eUVKdUxCZUFGYk9LTHJ0WS9C?=
 =?utf-8?B?SC94UWdQT01lTno4eGRmZi9xdnVLZ1AxVndYaVowZTJDbFpuOG5DdW5oOWFH?=
 =?utf-8?B?ZEU5VlFBRDI1ajMyVlVGRnNjWHFscUpsS0plZ0tMSEUzY0hYbW4xQVpGbjll?=
 =?utf-8?B?TERjckRmUUx5QmFxTGdpSk4wUWlVZ2FBQnpYRStZL0wyVzh6QU80ek9zL2xy?=
 =?utf-8?B?OEp1M0lIeTd0WDZlTU4zbnBGQ0w1SHltSFVYTU9IcXVZL3FUUTBNcHFZbUph?=
 =?utf-8?B?OTFzYmZXeGRHMHlwVmxLSWxwbnA5MFV2ckgxT3NLR3R1aVdRZGVrcGwwU3JW?=
 =?utf-8?B?MjdGUjZrNjRLaTJGR0JORHZKZm5JdDBUQmRqZExuZjVlWlRlNExVa1JpVGsr?=
 =?utf-8?B?NHNZNHdIcGJHaWNFdDArLzl2M2FCK1orVDIwbEtsK1VZMk41YmU2NWNGMHk2?=
 =?utf-8?B?ZjhMcEJqTVNXVVZMQVVhUlFJRjJ1dkVlajBxcmVOdGNlaVVpeGRiVXRJYklk?=
 =?utf-8?B?ek10L1ExRUZEOEZ1WHZ0cDFkM3czenJpSEUrdEtzVnVWTnE4SmsyY3pXdTJt?=
 =?utf-8?B?UVMxWm43QXllUllvOVhkTnFHYlhLNVJ3c0hlSURXQkJzOWUrU25WZkc5eXBW?=
 =?utf-8?B?YUxSS3VmNDhEMVpxSWEvTzhqNXdlWlV0T29KbVVUNFUwaGd5RUI0RklWVUo3?=
 =?utf-8?B?WVRzWHJRNXRVQXZmT1dwbUM5MW1XWnF1QVFoRzBQZkFCd0d1M2ZPS1ZFdys2?=
 =?utf-8?B?WkVDSjVsaXVNdndqalZoVlhickdHdk9FaVdJeUtZTFBWd3V3N1N1UWk4VjFr?=
 =?utf-8?B?T2czblUvTTFyUkJuRWJNTUhQL3NBSkNjTzhhdndxbkl0c3FMZnJ4WVA1c3lu?=
 =?utf-8?B?TXdpSTVxdFZORFdTWmxRK1NMWi9mUkhJU1RoOWpjclM3WkxXd0UrSG1wSVFJ?=
 =?utf-8?B?Y1dJa25GeU12VERQVFppb3BHckQvYzhESGhkS0VCbU9QeTk4Rk1kMnNFR1dV?=
 =?utf-8?B?S0txTTNyNXN6VnN3dStUYzhkMjA1QUpRMGxCNDdzVHlTMEFwVnZIWmk2R051?=
 =?utf-8?B?UU9Zc0J6RXd3b1BydFNobEczR1M0QjBteElPUVFQaUZHZFpiZm4yWXFyamt6?=
 =?utf-8?B?cjhRZ0RybjFXdW5MTEhoWEU0ZkRjQ0c2MFFkbTNpaHpmNnNSZENxR3NMQkRE?=
 =?utf-8?B?QmVNbWQrYUU2TnVrbkJ0V2h2YTZkcE8xNXpmcVJDSnM0eXZGamhwSGxnaHNu?=
 =?utf-8?B?eFV5bklCVStxb0x5YzQzTEl6VndEbmZGVFZXSmV4RkZzbnhGUXlRNk1yVSt4?=
 =?utf-8?B?TGIvckh2RnlGTGxzalp0VEM5alovZ093VklJL3hCR1VtWGRGOXB3Yk9RQU5C?=
 =?utf-8?B?RnFPQVFzd1NVMldPeDVQd04xRHMvbUtURDU0KzlXVFVtN1ZOc1pCMTRvUHBT?=
 =?utf-8?B?QTFrMmxFN3VZQnhOTG5EdktUaFoxMTJjazhseUNJcC9jTmxqY2h2bnJ5aW5E?=
 =?utf-8?B?S0pKWm9rQk9QVXNWa3AyYjNBRC9KUlRCbzd3T1lEQkM3bnpXNnJtKzRaM01y?=
 =?utf-8?B?cU1OdnlSVkZCZEtYMFppcVpmZXBIOFBGaE1MRnA1U2tJaG9ieUtqK2lvVTZI?=
 =?utf-8?B?NFlPNm5YMXRDeTAvVk1IN3dqczRZY1M5RnREa0JDMi8zUlVLd1lpZVU5OWVB?=
 =?utf-8?B?eng1QkptWkVTUXRWeGRCd3hBQXNjWkhPa3VSaWlXN1ZyWjdXcGhyaHppUk5V?=
 =?utf-8?B?b3gwb2JCZi9iUCsxb2FCOHExdzNEUDgrcG5jK1dnUWlVTGpYQWlDaG5WejVo?=
 =?utf-8?B?VVhWTTRRc0ZkQWNGSE1yNWRGQlFEOGoreTlZSFRFK284VlhpZFRGNWlUVDR4?=
 =?utf-8?B?QkdRdGJrTUdkZ0h2ZWFPNUxGNnlvS2FnN0RCWmFpeFhJR3VnV2V1bkhaOFJU?=
 =?utf-8?Q?m91T4F7feQ+9e4kuOf8biVOn5fQgIVIMN8bNs4o7nl0Jv?=
X-MS-Exchange-AntiSpam-MessageData-1: KaWwAeSYu/iTKNWeONw0tr8NmM1Qxe4HsuY=
X-Exchange-RoutingPolicyChecked:
	LpIyebiGK/tLccZhHVNJ+FX54+YpPiK0tadMMnHSUu3VNfNhsFU1QgtNmyrPWIfi8yZ4EiEDoKV/qikxdm3iNK55HsYfGsLTRn0ohkT29cKz2r/Ctzzg6vVJUqtSjpMsK4KUkowlRbof+qq/y7q/EQ1cWu6KMR7EcttG+0HDmMkbPHcna3d1tkjjrYetCDDFQ4xx7CdqnSfl37ip8bX41hn58Pi5GEw1fat9/oCQ/3Rd6vAw0s0XrdKBgLqjFw+TLxJBkboduCK/4T+WTbuIsIRJBAv77RL51qjrSSgVdp4rU19/FSntCqeCFQ2ss5z5q96EEmtt/2Va3UsBK3jZ6w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WPOoy7QP5Zphuur/8TWBwGS4Mi7R/Hk5h/uH4yJ8G7Qck58m+GBio8eP15zHUSse4ceZwDkEzEKCFS4Qei11NysWsy5XSs76Jc+Um7/SopA6KB52fAQude7/gBb0WdvVK2KmljzTW+t95BNU3wR407KCPPBeYeUtwy8J8/Kk25EViM8WfL+0NiyGh1oUvjXG/6kOylVi0Bmk1uGuLkMRN/lfdikJCy4tKJi+kycbCPKjoBSmJ9vBqIhFsTpTjrcYHkwQ8tM4ZJJFsM4TSF2Bu4a9MY+QF/EwWPkmoqegFciWDghLS7QvLhOeh4/tZrradxgGqXnFrv80LoyJh1b5cC5lqLcHOi0tnqmwO+VLReuJVrs4zGogWDs2JcShdA/yY8kHjIz47aixHW6SkNaWHXb+GWuuk5yQEcsER//Jy8/EknxfeTnaRbwHaci+tbhrW1TQl600gHe7i459srvlzIJ1VEWV8JCod4W129VEewzV2NeFKvyMJOnFNwlofeCnHZqhdDlVQbum8dL/Zs4+TMHox29WsNt/dm0/9LKgoVxMQ9N+egSWwRrMTivGz/DuVWdCtijjXwFWV/xKOsjsizGddgO63Qhj238ufzFmCcdyiIusVzSdAJbvS+HSVSXh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b8f819-8216-4c97-85be-08df08df11c0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 10:43:48.0935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5cbTNxzrrzc7e9q+Gs6ZwJUjsvpS4PDNSdB4SmO5KNmV+G1nzUz02IVRhjW7NOFEHh2gW6mirGjGwrxy7PRKBZyP5P36qIJcotLKO/q0mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9583

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

