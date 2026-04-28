Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FBB3E3142;
	Tue, 28 Apr 2026 09:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777367004; cv=fail; b=Lv3OH9IYQ7Z6xyIYO2XjilHWVKfBke4CmZTfDV/uzpTwzFVlGqwA+0zLVUnOfT7AuKsXggkINdYhrsDCi33tePYiqf6Wi9Zp685RnpuLSh3q1+oCeXh+xj3FKnNPG/R7xS09coJx7UW6EFVA4VDRUrTzxYl6XqCCNZ88LKSIU8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777367004; c=relaxed/simple;
	bh=IIj1hmJLq7v7TLtSqyk90CsZ5cYAoorNrZVzCi1b54Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Iuj7bLmW7ajwnC9KK3iS7qpk19pIP+SZB/oSc1I5rTnawTIhfQsPaLjXzuL+ydq/RtDN9hbTaFQjOwqpIp7JiUYXwpFau3iO9PVv6CgKS+GqcI5OC7vPeJOI2wygJCfP1i7MeCyIASu6it5slIvvAhBxS/i0zmAjmCpTiIWb3as=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kbvxwVzg; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=c98eNbgk; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kbvxwVzg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="c98eNbgk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777367003; x=1808903003;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IIj1hmJLq7v7TLtSqyk90CsZ5cYAoorNrZVzCi1b54Q=;
  b=kbvxwVzg5h3pZFQwClRRvdhihLQhlGqTKGMW0pbvIS/qwkdkMnqKxkz1
   ekPirKEHPOrsXazhTMUxsZMHqz9uULoYsK1NBHKB9MHWvwMypbWsQS13i
   pPBdNekFSd+0CAhfcEALXuU6rJw94iVxY+T/300c8GCVUXkP7Jan4mFNi
   SPTjW72H5QLg9z0uQ+64J9EXPObyC84ojjIfDi31Ejsq7A791KaLF8zpl
   XV8hQDg8Hd8h0zE4BteDVRqVWHCEE/lDsydMo6bWDw2J9bMGyUaG1z5Pg
   BhbkLx8b+FcbAEcwfBpFd67e6WZup+A7cs5CZGXW66MA/lJLhx+UsYoqF
   g==;
X-CSE-ConnectionGUID: HUfyjcJZTI+pABkS7IeeLw==
X-CSE-MsgGUID: xHDuIQp1R5WXNlqIxrffyg==
X-IronPort-AV: E=Sophos;i="6.23,203,1770566400"; 
   d="scan'208";a="144908894"
Received: from mail-eastus2azon11011003.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Apr 2026 17:03:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RepNQ/98+SxvMr4VkeNwIkFFN34a9YH6zSK8XhpF8HdGLFLE+yz6z+LYKaoQTbZpPaTTpQSq8NCX5ttDNFCRZgxylG9PGv+mxG6gAZvcB72pAEIvy8Gqg9x6pJgaTmg+lyWR4ADABl7nvxS3GbTfOlvt7Su26Y3zzepbs3LLktMwOINeJfH5skzMJT8+P4d7Cp9Kn0ndTFzgCI0ZNRCIjBakmaN+0VsBYWKdTvad8ph4caqV5RPX0Uw7HOY59Zm3VOhrkAaS9NCvaglUaIEGIhBZCUCwJ2PBb3gQIyoZtI1zeDzU93B011PqY+fh1CEO4nLsZFOw6dm5EXwmtJ4v8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncgr5bDmO2mcIwLigT9In985as9Nyimo5xsW/Liz4QA=;
 b=D72mkDvPE/b6s3AE84Sjc0EGokqbOjp86fixl704bdSBZUEJ3gh3XN9BDT917eL22WvmFWcyK5UrH4F/IKs3u5E4rLEIvhuMBHdvDI194eqGMlVCC/P77RWguYFRh/wkXZObvAqgl3782gw+ChP5P7YMY2QNR8/85ewk2dGAKdBvjywY6ULUlvyVcd9SxmQqxXZ1q50CP2yQoteR7DNuXVVFBoASh0r36E9Z1lHZhd7ZhQiECJikznn1ypd2lp0vjX7s2lSC7gc2IvCnh8x52r9BtoRm5jtbTiiNabonlmbIRxVHo2aSuOXredUeFa0KreL6vvaCxaUOUKmMg9VoTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncgr5bDmO2mcIwLigT9In985as9Nyimo5xsW/Liz4QA=;
 b=c98eNbgkD47A9+baBB+/yrZ3SO+brTi6/yv01AwTM1/DJ7UeJm1mMrZ18EQy2dMutZEGj35kK9Vr6JxasXkBRTqj384M9fvpMU/FY42vsijIpnJS4xpdMsqiqt2kq+IooVYXvxQd5k1KWus0rj1Dbjqv9Wnztbh/1goxc5vxkc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CH3PR04MB8795.namprd04.prod.outlook.com (2603:10b6:610:180::10)
 by CH2PR04MB7015.namprd04.prod.outlook.com (2603:10b6:610:95::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.27; Tue, 28 Apr
 2026 09:03:14 +0000
Received: from CH3PR04MB8795.namprd04.prod.outlook.com
 ([fe80::e95:fb73:513a:f50a]) by CH3PR04MB8795.namprd04.prod.outlook.com
 ([fe80::e95:fb73:513a:f50a%6]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 09:03:14 +0000
Message-ID: <1a9a9d46-7015-4806-b630-6f75a4835865@wdc.com>
Date: Tue, 28 Apr 2026 11:03:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: validate data reloc tree file extent item
 members in tree-checker
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, wqu@suse.com, linux-kernel@vger.kernel.org,
 syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
References: <20260426201605.36626-1-27rabbitlt@gmail.com>
 <20260427202822.278326-1-27rabbitlt@gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260427202822.278326-1-27rabbitlt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To CH3PR04MB8795.namprd04.prod.outlook.com
 (2603:10b6:610:180::10)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR04MB8795:EE_|CH2PR04MB7015:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ec4cbe-d899-40fd-7227-08dea504fa99
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 X6zqWgDz62MxoGZEnrttqBGgBW/ZhY7dMx3hYjmXWN+GDpjzZoeoAUXIuqAOiQMJaz1njtNGsXvqJwLxK5UTDKr6118+He7R+XAe7DqIPoOHKtEUp+0udUEzOmnULhkafOj/19/iirJi0DRGqkBaDSA/76gIymPjKttBedvPHlbF/0gEyvxpU36lUXFUrzwfcuM6yauW+WeHspfsz/e+8l54SUgZBJFrkePV9LAVeubLc74OrgNEawnbkD6YYwhlXcquVTZG2y7GpcSOHvOB+ic+6dHlaaH/HoaDldxACICN+D5SII9uMxfUbh97ijsFXLARh59Iu/m7r9+hThoJI0cP4ffToefsKzakF8ylpxUJVcUhz+Bv7QsAKyEJGjlzQ74E/SjECf1ek9beenmIy1zxegRqOqVP4B4XTLU9jf6rrMYmp+LDvH2wnXp6yE1oFrBkKWw9tjSysyKaNCjMu+jg+pXvKAzHD7QxJd2uPSCUPgKswmoEFmh0goWlQY0Y0P+XOQd5NpVQbEflZf1Vxos77XIJqgLvUylZBlHehjTPD5GEtJNrbs2yfGyBpPeEpqH66TUJlL9R//pK/7o1IkIHY4rE85hqLKfqYofIwIgG1KaWxztld44HnywSeIhnF6IovRFIBcyqvEBPMyyylLvgPwMWFJfpq/M6l+tGVKbnWHbnRVRMSmal5kTdymWr5h5en3BTTbj5s4yadqsEamNzuP6HsKwnGsxBZd9pCls=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR04MB8795.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SlZJWTFHaGVaekMzL21kV3o3U2E2YjU4MU1JUm53STZaV2pFdnB0MmNXVjI3?=
 =?utf-8?B?cU5KRWpKc0M3SkQxcUpzZzE0OVAyZWFsS01PUlBUT2dsMWF6OHdObWJlbzM4?=
 =?utf-8?B?eWtubVVGaVg3Zk1adTZ3NWIzTStwaXIrR0pMV3FFaE9RaDB2WFZlSUxVcVlj?=
 =?utf-8?B?WkF1QTBGRENMOVJnK2lJREVkYTZJTzlzbFQ4dlRQeTZVYUhNN0VJL0tMSFFu?=
 =?utf-8?B?M0gySm1TK1VFY2xYcWtXTnFqSkFYUW1VdXNrWWkxWFNJb1UzbFg1LytIU09x?=
 =?utf-8?B?dm1Sdmh6VWorZkFGa0tsU3A0bFNnYldhQXFWMkFJVm1NY1dvME9ZK2pySFRj?=
 =?utf-8?B?YTducmVWN1hPdEhaK0lKV3JVV0YvNzZtTDZ4MUxlakIzNHpJdjE1YXk2RjFC?=
 =?utf-8?B?N0s4d2RyTWNGNVpjaWxkRHR0WkRZdTQ1aEZmQzlRelk2ZENXRy9OLzlOT1A3?=
 =?utf-8?B?WFg0WFJjOWlXWXIwYjZ6bE16QlNxNmNOU1Y1Mm1oREN5QXV2SHdaMDEweGNP?=
 =?utf-8?B?dENtNS9DYWVyeWlSRURyai9hVldJTGlpaHJHUjZ4UkJPT2ZVRndLUlRuQ2Va?=
 =?utf-8?B?TGM5WkpGbzRwRmpzbCtlcVlteWZrTWRlUVdPbnlBTHJENGc2LzNOa2I0cVl3?=
 =?utf-8?B?U0tTM1ZFdGN1RW1xM1VlRjZzQ25YMjFLbEJXN2VMRlVCRHJPRGFGS0Q4Q1Jr?=
 =?utf-8?B?dUVoUzlteDl3N0NOQlFDV0dzZGxvaUNtZ2xJNm5TYXFoOUlLWDNoYXlCNjNB?=
 =?utf-8?B?cjhEYmdZL0Y2VWtGenpFY29zMi93bVJqSHZGTGlCb1VNenk5MVVNaG9CWGk0?=
 =?utf-8?B?Tlg0UVBBaFIyelREYnpRZU5YU3pDek1lZzZ2MVVNSGRaa1JtNWVDZ25nRmdk?=
 =?utf-8?B?Q0xaWnU3QWtrMHpiK0FSMU5xWUw4SG5GV21FcG1Wc3ZPcWNXZENMNTFhZHhz?=
 =?utf-8?B?Q3NvSmtZenAzSGsyLzZrSU5sM2xwc2FDSUlZMDBLVXBTelBQSW9Ra1lFOHdi?=
 =?utf-8?B?WlJHbFJsbFBVOXAyeDV3TlB0dUpkMkFIMHBOU0RYdjJuSUhQZGxJUlBLVjRX?=
 =?utf-8?B?cTlGTkNyTjIxNk5yL0VTZzVWT3B4RE5obEs4RnJCbkhrYzdoMnRlNE5jR1I2?=
 =?utf-8?B?QnV2TW9nMDljUi9MSlJLaHRFYmx4V1pWeXpRVXBocmo3WjNVeGh1VjZ6NHBG?=
 =?utf-8?B?aHVlV0lqclY5S1ZzUERMdmtlZnhkWW5Vc0huN3VEOS9wZHNxZGlYMjJKQ2ZN?=
 =?utf-8?B?WkJwYmMrN1BGazZkeFpoTThCdGtnOVpOSjV2aVFidFpLWXo0K0dXVFg1dTZK?=
 =?utf-8?B?RjNJOXZxVkptbEhOVnEyMjBhTDlrTEo2ZkpCZU0ySnhoVFdpa01hOVEvazhR?=
 =?utf-8?B?TzlITjVRY3dQM3ZFcE5pVlN2TXcwQUoxMzZzVGNwME5TcThQd25xcDErdG9G?=
 =?utf-8?B?TGlQK3RiRlR4WkY1TzVwUElvRCtPZERQSXNlbFBleEJFdUQzR0VpMkNNamFH?=
 =?utf-8?B?SXR4ZW1sM1FTMW8xV2NjbFlnSDBpQ2dsdWpna1RjNW43UTRxaHVFbU1wdzBn?=
 =?utf-8?B?Qng0OG94NTNzOTllZkNKM1drWjl2OW1FMThnK1lxT3FoVHZyMG1jNWUrZXo4?=
 =?utf-8?B?WEZuSm4zZENscHZrZlk3ZzJyOXdaR2M2M3grNFR1cmFMVU9wRmlYcnFDbVFM?=
 =?utf-8?B?S2dJOFJSTEF4akVRWUllN0ZyL1BxSTN4eU43YUMxSmdubm1yNC9DT2xrWE5C?=
 =?utf-8?B?RlFhYUpwaHExbUU0R3NYZ1J4ZHlFeFBLQ2JyZGZQaVhBNzdacWpxeWEwZ0JP?=
 =?utf-8?B?b2l4YXkyUm54Q2ZJa0FLd0FJMjk0MS9BdDRvRFJUeDVWSVR5azUvZTNlODZ5?=
 =?utf-8?B?dU0wZ0F5eHRvcTBnT1NOd01BaDl0bkRtWlVEWmZweTd1V1M2MDBjUkRrVFZ6?=
 =?utf-8?B?UDNWWSt5b1VpQUVaLy94cVBHc282UStQV1dObnBsWTk0UWY1NDVtZ3dVSk5U?=
 =?utf-8?B?R3dkMjlpYXZ1UjlXSmQ2c1ZWRURrZU01UHlWNzE2QU96d2pVeTZUckNuNkl5?=
 =?utf-8?B?NEkzeXhTL00yOHQ2TEZKL0FzNGNnZklMWFNhQlltQkJtVkRmaHFycUJ4V2tu?=
 =?utf-8?B?cE45NEJEdGRFMm5CZTBqMitRb0EzNVdCRlJVS0czUTFRVFpPaGUrTENyNlBi?=
 =?utf-8?B?OE5oQXpLdjJ2WTRGQ0NTbFc4d01yTngyU2cvUmhGNnZuMUc4ZDlMbm41V2FV?=
 =?utf-8?B?VGtwN0JYR1B4SHFiZTJqcEZWcTVXZnRPWWFBRmd1M2hucG9hZXg3dy9KS1JI?=
 =?utf-8?B?UHRCdURVRTBLbEFER3JPaTYrNFByME1QNE1zcW0vaitlTGhrei9vazJkWnVz?=
 =?utf-8?Q?JKcT1HBS+oT03n+w=3D?=
X-Exchange-RoutingPolicyChecked:
	mWWncvHnTWgIHa9ws6KBujvFR7d+wxODcpyUsFrqoOzA86troIXmG7zMTIDcmQSX8+k+yPazKycTirf2AfUbcD1I7IYNgOSiP6kihPQeGJR3j7h7BEBwNUDDmK2OEBMbOV/cWmium51Bb04SDG6s/eVGSQhjwa4wU2Ycj9oqyXiH2mMBgrJPTOzKxxFuhIzCWgUWO97PDGI0EAsDDrCGlIv3MHxZoKy/PJf4QiklWmGYqkGqUrvlRdu8fkWP9zzBMGUER0vozE3WNuvqIDxev5vXxf4u7/S2CecCVkQM3Bs4UId365jaIZ5xW2ikaolleKwIXWmUMREEow/Cq4eI7A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RFu7qsZN6l0at1NdamSgFrohYRiZS/ifbo24eb6Qq2wq9D7qSVnwo4TJtBVO1pTfSe97dx8pQU292BvR/N5xMCrC7/FjBHEs8xDiFB9Tv4D4fUpHG03N1RWqslS30HU5gsiRpjFhGUKPQriXq9C1d9FY54zaxAfbFNZMTKCUk/5HRrREUmq8OHOjGiFY9RY9lgGptr/T6SuwJfxTgnIj5Ywa9Ii9WLesiWIm2Lllrqkm/dCHiyV7llFmAGoBHekCYUXta2krmsgqZfqI6A8F8kZVjp0bF+QcBf0H9zsxFLbL5Bb10U4UopjXHWMDoXyC8mMHokj1NQyQfK6A/GWr1s19v/7B3jRUf8g2KXDDNM7yBrqAfL008LacxUXGR8QzkylkCFIVQHVL58lA7NUvbGG1vGTQ+PjLibae4Jw9RvZKgc0SEkd90nmmXsn3a60S1RtEI+4D1Bx4YkIpvuWdcKUZ/bmeuVCECZ09fTfTgBB66vLUFcgczvi3H7ydVikoyODYyLxkKqXjAe1pSgkiNV8UmYD4jAQ7FfEyfkMRSsCEIr9FXksrUQYX16C+oZjmYX7dg0Noguu6WGvAWh+jfC2vvfoPVnrUTa2YSs2INZFf5jEDHEpp/ySy4RFsnlak
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ec4cbe-d899-40fd-7227-08dea504fa99
X-MS-Exchange-CrossTenant-AuthSource: CH3PR04MB8795.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 09:03:13.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cDmWyA0jVdGn8wjm7Op48svnDLLiYCYiXStpAO5OPRQ+ZVNTZxdM9SxwKhk5yE5B85mpF2dGQbJAbkWb4pFHKEvbA3ORnojXJ+bsaL/d/rE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7015

On 4/27/26 10:24 PM, Teng Liu wrote:
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1c42c5180bdd..527d4dbfe31c 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -835,10 +835,10 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
>   	fi = btrfs_item_ptr(leaf, path->slots[0],
>   			    struct btrfs_file_extent_item);
>   
> -	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
> -	       btrfs_file_extent_compression(leaf, fi) ||
> -	       btrfs_file_extent_encryption(leaf, fi) ||
> -	       btrfs_file_extent_other_encoding(leaf, fi));
> +	ASSERT(!btrfs_file_extent_offset(leaf, fi) &&
> +	       !btrfs_file_extent_compression(leaf, fi) &&
> +	       !btrfs_file_extent_encryption(leaf, fi) &&
> +	       !btrfs_file_extent_other_encoding(leaf, fi));

Can you split that into multiple ASSERT()s? So we quickly see which one 
actually triggered.

