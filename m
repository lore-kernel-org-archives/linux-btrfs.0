Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54A64322FA
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787662440; cv=fail; b=fqOR358PV87ZbY6+bPA8h6lyIR7elWvu9A8qNN2tPTb912SolCl/mwlavoJpyzU6yrVQDAgLB6OP8eAzaR+NRaulVOqWogBxju06MNACZ4OzDO1XuSgE4zwNmOl72C1ziLKczQClw+fdJ7lKKaqWmxFSmXNpLET+2tP0bELr/pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787662440; c=relaxed/simple;
	bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sN0LvfJJe92PJfF9lHpAW18F1JqRuNz1A7FsUQfIxCPCH7iZqRtnvmZ+xQbd1x+ig89plw6snLhTdVQlJtowThr+DoQRVD/r9dN3sznXDmBrL6s2pDKq+jQvOeXg4eX1BUpGXRxlhh5OfPf4OmA2/5cA6txWkFlX+AQ0kGl8G+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c/ecYnH3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BUH8KuI6; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c/ecYnH3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BUH8KuI6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787662438; x=1819198438;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
  b=c/ecYnH3DjoZV6b7RTEBu2+szoXG+cc0WZi8/z6rhk40JN6Kef+SJ9jM
   ypm3HZ+ZmSqQW0znLXGvE7pXZ6tgFenMi00hFlP6IilnJ8RIQqe1B83sk
   KLa+oeJakJFL7JndgWTIm5Vu5TeH+NJJipk+LHWv00JwcZhhoHjJDBRwb
   Ce8FyIA9YKgSXOyFUiSNiV4d4jRQRZHu2PYAUiYzpxs2Nbn9ti3OtJpdT
   +sEOn5Qy6S1sdeiH/Tsvhov4qCv7CE5qcjuNaYGO8q93CbueYD6ebCAIU
   Cev2gy21qvfWEb7m72PhV89qllaYUP1jz+x8lhteGpn8c/j/jHYOB3Zuv
   A==;
X-CSE-ConnectionGUID: adIWY9c7QeCsRkvZyzb7nA==
X-CSE-MsgGUID: gMayC3kPSJiTV72kDeDSbw==
X-IronPort-AV: E=Sophos;i="6.25,242,1779120000"; 
   d="scan'208";a="153271613"
Received: from mail-southcentralusazon11012055.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.55])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2026 20:53:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAei3/eQIt9DGoldkilEFd0xzyT6iHdTek4Om7SGqUo1cDJzggkt4qFjdQjrTMKFmLSYB1fXu+WYEQU2ocUNPTk3lAoVGLelqecINLaFdMA+E9TNvdplPjzlTCH6PBEz2/h6UWD6zanfZA7WWoFfsDfI5YXuVW0ALx/NZ4N3aa4N9AzBOQXbU05BtSz13LBmvC6XFXBwRW6fJk44HbJVRSfdOxXi29XBI+Qg9rhRxDHyY6328gz0UtLWF4dbg6pDTlkNz6KSqueW6OWMZsH9Zw++HgX+nfqh7bYe9yKPbIsjlvK0C/TnNFISc+wn1wLv8eJ8pVgcUCVKr+pkvM29BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=ueITy1K4cO1jIuiL4D7gfwAzDnyRrxfRKsBxjlvDqZW80KnyE2vw6nhKIS8EIvc3QEhFBuWm4jcwKnclHChFofZxVPXLA4pNjBmvmPBXv4h+KmlSFzDMacHapnZItZGgVcKwkrq48IR16E1xszuIHhFAxsM6h1yRnHQH3ZAyqavi6jq00lrsmbaZOe99i9DBOutoCw6w4YY/fFs9hKQuEngLQDTyEGgNLcn0HiHI/bxuG8D8uRFnEX25t89r5MYduSOloqdQiUJXHXXY/HYRAzLXYk4gZU75nLdRJwyofN323nNDOStJ00NY6zmNEQJsZEf4eLZoNsBCT93H0DPnkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=BUH8KuI6tyRjaP4CYhcby5ELvOeBzunDyDmNm1YHP+e/FANvLOowtLQ+v3+yUXk/vAqZJiNhQLC1IWrlYN0sAlkRMN1b5R4oHdng+qz688zHBtHz6QtR2fFe5UEGvXozeWV/GHzt32R2axpCdKHuJnMcxHQ0+iIIUZoYVOHKR9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB10205.namprd04.prod.outlook.com (2603:10b6:a03:405::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 12:53:49 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.005; Tue, 25 Aug 2026
 12:53:49 +0000
Message-ID: <af6f347f-6e13-4075-ad61-5f67f055c4c7@wdc.com>
Date: Tue, 25 Aug 2026 14:53:45 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: qgroup: minor cleanups
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1787631065.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1787631065.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0317.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB10205:EE_
X-MS-Office365-Filtering-Correlation-Id: 18a42b52-b523-418a-94b6-08df02a7e875
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|376014|1800799024|366016|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 LwIaFoHH6CK+T6aLKohZiTHW2QMOEVN8kmHKOM3QTAdCGAdg4eUSDkTYGLuOmCUlpXX7BiRPU+sg27DfEjg3VU7hzsezVXMUFWMBj3SFmUHnU9HiEDk7yjMtxXNZnIxW+Sl88tFM5BfXYZsFUOcwwJ+5PHmIJgwPMXh3/mSNDaelxD1V8g8rBzeVSphuuBaCybFeUC8xpygl3KRxLRDe8ZAjVFSJVWZtA8OlxLNpRaMQNtAwDpxwhM2S5GYua0HL6fEGxIg7u0yDg6t+KLEMfGKHO3B+TqYHWNr+mHtdVv9tVVDs3inDr6/JfI5FLZHA0Os6231D/sTNR4segoq2NotFQ86eLUtgIAMm6e+EmXULCErQtxwk4HyEcSbbYoR2WXjhXtgqtNonF1pJ6euwhGqtFflwsoXKQqXdksu/V1TKk1bF7PgMGvuy4doiYF/pjkOcQ/tga2WG1p3Lx5lrWFty81xLbVX+bjZSsoB7THihIMHMaBHvLsayni7g6bFnxRlPEET7JB6nWpdKeWIL2UVPe8PLMXYuKBu84jXLicjdPnbk3PLO+IA90Rj5Nql1PsQTtPSdhqkeakwa8N+qV7CVHI3l/D3hOmyqFX0c1vxt5lK+tuCCWUN6o276cstl5GemE7op1KopJNK59cisYkfoVWhV/AABF9sZdL7kT58=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dTYwdzkrZjRLSEQ4b2o2bVkyVzBvMTJrak42aGxwR1grY1RERG5RL2VVMUQv?=
 =?utf-8?B?ci9VZ1FVbWwxNUJhQXJ4VmNjaWx1SFlVUDlpTEhiODY0ZzhXZWlFS3dhWDVI?=
 =?utf-8?B?UWt1TmRlOTk4MngrUXRXM1F5M2RFSjltMkRNNjQ1NTBQNlFRTWtKVHhmcU52?=
 =?utf-8?B?akR4anN5Zjh3TjVoMzdaQi9UKzh5cjlzdmtIRVEyWHNHSFVGRlRKaXl4WEZt?=
 =?utf-8?B?N3F1a2pod3hka3hIVjNQNlRDbzdIbUdYczNGRk5OTC91ZlpUQUs0cU5jNGRx?=
 =?utf-8?B?cHp1UVI4d3M1TnIvT2pROExnS1pPY204amFUMktlU3lYd2pnOTB6UXB0eDlB?=
 =?utf-8?B?RzRiZTgyZzhaVzRrK2VLQWRYajV4ZHBJQ0Mza3BKRzgwdzZ0REZhdXBZcVFh?=
 =?utf-8?B?Y1NTRFU4V0haT3NwL0NIUDNkWjNDcm45VTdUNlhCZjlNUTY1ZWR5cU4zTzhJ?=
 =?utf-8?B?bXltaDEyWkRVRGlwc2IydWxzWTlXQU8rclh1TzYrUE9YajNjb0NVNlI3akY3?=
 =?utf-8?B?c09TSEoybmZlUU5CcHF0czBNZDFKOVFjVFVYZ28wR01Qb1dWR25aWEFpTEFY?=
 =?utf-8?B?ck9zYmNvMjd6UTZHT0dLbFF4V3l4WVJiaFRqb3VDWk9Nbk9EVkk2WnF0aGNq?=
 =?utf-8?B?WnZrZ2pSMmRzUGtBYndvdDk2T1QzbnltNWdaekdyOGxpOEJNSVFHS2l2Rmdj?=
 =?utf-8?B?UlJBeGNlY0RPK0FQS2REYnVZN002enNSQWJQa1dCRncydElzL1VKZkFwNU00?=
 =?utf-8?B?WUQ5aDVINDZRSHgzMk1DQU9oWTR0UkFNTThsZmxxNUgya2g5UUJ2V29CQUZ5?=
 =?utf-8?B?YWJnelQvancyZ1ByMlE2NGFCbUZlREl6a1ZhaTY5MlZKMmxLQXkvbmh1SERF?=
 =?utf-8?B?MGF2L1hwRGJwMXpIeEZ6RWNTQXRuYlhOZTdkdG0yc24ydklDVlNzWjlGV256?=
 =?utf-8?B?NkdZeSsxVWxhMysvNi9nYkFrb1U1eU1BdzMyclQ5S0ltWmhmNDROUXRaMWxn?=
 =?utf-8?B?RUs2UXhXRUNRV1Q1d1NIQXVwaFFDbHR0SXIvZ1RGa09GTWdYOWd5TmJ2VnJv?=
 =?utf-8?B?WStNUk54Z01EaER2T1FuNWxOVnZRZnhTWlRuWVpYbmRXcEh0R0tyS1dlelJy?=
 =?utf-8?B?dERQT0ZQWE9sdlBYRkh3YnZYRFdKV1pYR3Uwd1V2eitjSE5NeU1IR0tNckZQ?=
 =?utf-8?B?RW03YnYva0FCWTh2a3hQVDFXKzEyVUNPN29YVHVoejg1amcra3BPbEcxVXN0?=
 =?utf-8?B?VWpSSDJCZis3ZWYzTnNicU5MTHNyNHJncHM0enVYQU4yTWdMZzZPM2NxNnhL?=
 =?utf-8?B?aU5rQTlXcFlna2NDQ2tLdVJQWWpEUkpUR1lCMDVlMFhjR1ZiUDFrcmdUbjAx?=
 =?utf-8?B?VmxiYjVRbDRORDcyVkJXZkNUOVNkcmxISFlpdWJ2dEhZSlZ2WXVxVWoxcFFT?=
 =?utf-8?B?RXc5Z2FPamNFOTNIREswR1VsU3BWQXcvTE5kNHB1ZEFxSDBDUFZUb3RVN0pn?=
 =?utf-8?B?UzJERXNTMkQxRmx1MXVCMFdwN2JoTGVXUnd4L3pDaVA5T0d3d2IvVDVjd0hw?=
 =?utf-8?B?WHQydWJYTGh0UnQxMzFCcmQ2T1RmSDhsQ1N4dXk0REVMUEo2amlVeU5FQjBn?=
 =?utf-8?B?cDdvWWU4TGdhVHd5a3VnRnRkdGtrWEdqTE1kZ0FhL3kwVWJWMGJFTVhESXVO?=
 =?utf-8?B?dFhENWpNK3BUM1FMeGgrR2ZjRGIwK1pzVkVGZVllQVgxbVh0dVhvS2RlNWFv?=
 =?utf-8?B?U3NLcGxRL2dWMkc1Unh0b1RSOUlPSkZmd3l1U0ptQk1IWkFsZHF6NHJ3ZG9K?=
 =?utf-8?B?MkRtVTFoK0l4cENWL3RZa3JnYjBKNmZnTzMyTVVuWXFaWDZCcTN3ako3Wmxv?=
 =?utf-8?B?UC92VHNGL1RaK1NJWUQ5WnUybGxvYlo5aytDQnZNc0djTVVQeUZjSWN0UC94?=
 =?utf-8?B?WGV3OFNaNGY2bmVTNGoyM3Nqb1I4dDNKNGlLazllMHkwMFcwMlNENmhjTnZk?=
 =?utf-8?B?YUZDSm9BU1YzRytxQmlvamwvV1ZGK0xkdXYySGo2TEZvdkNiWFkrUmJJT3Ra?=
 =?utf-8?B?Y3RJRXVPVWV5Mmk5aExWbCs5UmR6c25Hb3Y3bVBMTXJqYUJjQ3prdnNOTTBQ?=
 =?utf-8?B?ajlVZWE4WXZhdUN0UWtZTCtFaHp0M0pQTkxhNkZwb2g0YXRZL0Z5cDlNeHhE?=
 =?utf-8?B?eDhyMmtETDMrc1N0TlB1OXlhdWtwYlljeENoQVRSUDNNQmpPWGk2a3BrbXpx?=
 =?utf-8?B?Y1FBYnpyNzlGa21BQzdSeFhaVlVDbU03b1hSVlBJaFFPUzZocXhsZTVsVzFW?=
 =?utf-8?B?R2w1L1VMc29XdEJZaTVTT2UrN1hpNnI3eGpCVUs4Si9EOUp0RDZkdDl3WU5H?=
 =?utf-8?Q?HK/apoNs1Hd3idr0=3D?=
X-Exchange-RoutingPolicyChecked:
	GwtE3f2uYNhTCUhzcYu1Ww0B0JHQ9t9w5Xl91FKAK26kHZV12zlWsWQndGROh6t3Pv9XihhMhjji+aW+dAdPK0Mp9cZidQpXdvunz+pDfuYV2NzS++L+KBujA5x/1skfojJzYGsRWh1LTimZg22IpGTTG0437CM+94jNT42PuA+CSPbSDMPcyrcxt+rzN52cKzVfvp9Jo99WmZbyQk/8W6+2Vc9dkugFnGHjMo1QaYgUo4YkUkOEF2d7v5Xr9tTJLzTQhfzZUwlO1yBn7RNmx/cSeuInUBihhiIq9xqwzld1h7najSWZtKWopVy3K9gJ2ELBP0QYlaaCDgWzOf56QQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wj2SiMWcmilkYWi3hunOp7W4i6+EsWrkbTfyAg26gbd50CE0QxF6el0iBF7UkqKm/0gd8zvQj9DZ3v9a//hKEHNDK8I7JE/J0gmaOsnIaqOv+e3vHRVkpIezO2n5xOEGTmtSZcXALirUuASvl3Gxfufngxy+k9M9Il2YuiK1zTNOgjUAROMh8Psc+/JwC1+5Y+1POUqhlnzN+AMNmCK51P44/y5Y7vp8wK6WzoUtoohXmhrpPDxpKU/rGsIIy5WkgsSh08sVsXNBy7029iu+YeOKUDC2F8rq7SV/yMFk5rO0136xBtFNVxTMumQZrpwtY7qQDY9ZfnijEpAU4PpF8QYsjgxF7zBQOHRijhY4SmnjiVwviK89JjgTlp+9RKVxDLdV8WHnBM5+7wSxgTLEp+75kunpq9t2detIT5NvfB++ORdjbtfCLs2888Lr2H6uAGZDmOW03nelqyc4hW3t6v2lo+oQX8N0vUK8FwIuHN8GnS1XJ5qs8r/0DNbb4M3aZbvdivtEab+cEXsjyQNuad5tctwjwM4hNIYRM1yuthCoEMrHKhdXqN6J5Lye9EnyeLPAEHI5VRJbK1IFBMsprUxeGoBVfXt4rXUHL2prwVpgC1aC2dHmKoo2+YM98LV5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a42b52-b523-418a-94b6-08df02a7e875
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 12:53:49.5106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JVgHigkh3O4S9iD8L9CM1TnUIJKJFpa6ncSlNTcUY8idHuNLzx5r65gh62Oy2ddGty6bUqmErcXjoFJC6Avu2WCrzQuzXg7wo80tYNJPWAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB10205

Looks good to me,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

