Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6BB352014;
	Tue,  9 Jun 2026 17:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781024713; cv=fail; b=imzjNgBVsxQjyhw8mA1enxkfIs2UR24txCq687+Vpk1M9ko6bXyP1Yfql/WXLtkV+gi7WxLTk+cCjLjACwXBoIk4a2qgA5hIe4TXfGWQjoCQBmP8MzcNtHAyyKuMmIX6hw6/JMWOvjdGdJRbDIYoD6KoVnbBgB9rVh96ZZHMIi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781024713; c=relaxed/simple;
	bh=nD66cIeqp1WWd26XPUyzGNMlqXx3WLM+HuFH3DTlWu4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sjg5jwZpssOScJY6pU7Gq0m+Y9N0XK0QoF/JxaHxBin03sYg7vvOuk5BCBCxQgVlKIF06qVVdRAKZ54JZflry3RiK+kiRzFtvUzNJmyn1pudUeG6ws2r524scraVvOv8pXepKHiYRuYM6eR2PfHy4uWAN/0LGln4/VvjpZrDazI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=REVph9Ft; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oPJ75hTr; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="REVph9Ft";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oPJ75hTr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781024712; x=1812560712;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=nD66cIeqp1WWd26XPUyzGNMlqXx3WLM+HuFH3DTlWu4=;
  b=REVph9FtSNDWmiuGli567N9IKt91NWovS7fg6eqPA1e9QpW3alzMOJQi
   XyD+p4Oof1Smn8jPjpuI1dgHRGD12kX+h7b0NPgk95X44PhUE0UL/x7Jp
   p6Id1zxvfBbacrsqTvqEiH1QxXFj402qWd4t+V12S4iSe+ChRITqhORpH
   eU0bAMENwhv1a+lTWAK3/PsJnUHrGPdVNJRFMuiPmgXNtXJrVc4tcxXZB
   TCPr437Dj3tcUdNCEE9Rmx/daRfbX0KenCBhYlidgG6TvSPQsqNc/UBik
   tle5SLl1c9wpADUecukTkRaXziK5R7gL8Z9St7FAn9WRXXI9fVAMVAZuH
   A==;
X-CSE-ConnectionGUID: AfPxen/tR6OlVbnks9iGZA==
X-CSE-MsgGUID: fb9MJ2e8SZOVksIcCRAuBA==
X-IronPort-AV: E=Sophos;i="6.24,196,1774281600"; 
   d="scan'208";a="147282135"
Received: from mail-southcentralusazon11011064.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jun 2026 01:03:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkg1YoBNOpbo9PVrDIf2lfZcTuM6mA983i6Y/eUNh4Be6HPwio+IQeNGTVajtu6gmSzXIUpbprC9QGeVIaVCjWH/82nJc9nGU9hw4AeSrB/VF+gnpXUcNzXgOl+mEBoJ5I9WGp0wnvgyFVqtzhr0tq3dQ0djD+g4K4idlFO45O0I2GtlfATrzEAXsDecVfLrwh+7X6l6g7oRwom7v3KJeQmAU44D08MRLFFW1qFeLNyLy6M4j3RS/FPpmnTCRSKdMgsmCxb2zUM16S5Kaecf2XjREmzQwj3oQHpdUFkfEhViUJtFJuXN6cq8ABs/ZKJim8I6lwGiyfm9ftiIRra37w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dG1GKnB6pODFqSpFAGJyib8wXVjL40p0TTIpkaMSXS0=;
 b=BaH2SR2dAWcLA4z9N0+TRQpEx30D8qvjjMFa85d3uKO0iutzgzSmNn+p6AMAvBdrMliNYFL0oEA9JYlv91mTvij8t0sKwDBukxu4110G8po3LdSfmLz/pX4qJ8piJGuq9nphAy9vhYyuzSLlIOmkc19l3I/m23Fz6pOCMOkQ6yr7UrUcSkezfbaIrmXxfASc4K2cZv4Hh6wao0iwbuHkiSVxr/bbqrbUqCiPu7sHFSHQlQuRKjgk0mD6zFv7pKpxsPeEQQbdilaNbFW4AJuflNeqYSfM7zE2NSPPc4Y1YmplsupP2OqcQYB39IYhw4MQJVYYhyR5jOMEVP2gL6GgOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dG1GKnB6pODFqSpFAGJyib8wXVjL40p0TTIpkaMSXS0=;
 b=oPJ75hTrhXaQLFUe9HXEMYDjXcZ5V+IYVbVZUcqov3+Lo7O961828SAE6HnUkPfP4AFqpfoxMFx86sK4IHRdrLh5vfbLcNcBOyF5ViFPI7bz2GRhCvioJFUYoSzVu46/fpM2HtaLI1iTOxCV/E9K5+bPlz9sIR1ZwDYXyGaSmyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8019.namprd04.prod.outlook.com (2603:10b6:610:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.15; Tue, 9 Jun 2026
 17:03:45 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 17:03:45 +0000
Message-ID: <0820a329-0f33-4f23-83b0-a4b849e9ae1d@wdc.com>
Date: Tue, 9 Jun 2026 19:03:40 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix zoned sub_group leak on space_info sysfs
 failure
To: Guangshuo Li <lgs201920130244@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260609152015.1586599-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260609152015.1586599-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0234.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB8019:EE_
X-MS-Office365-Filtering-Correlation-Id: 709cb90c-c55e-4354-4dcc-08dec64910b9
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|366016|376014|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	v/R+XLMAcbklsOA+V5i5W2mnxQRKq/rV++Oau6Xk1XJEq1FaIPme/XbJ9WkY0JszyokNLc/jbwDiLJE6E45PFl1fOLfry33BVS2ltRQM671ZgYSKh85y+b+sYVS/wfLPIK7PL7T3f8QDFrPxWkIbZ1qB/Ih2v2m0zKtJcSAlRmwloEquV+RThou4IpfCfzFg3z8RzGFzlLeCRiYGzUUB/EQ+ScN4YVT9vT2gt08a8Ms0OojLiiKelUL+TilUvZXHYw/xe5mNliWv2R65kKjX98LnvhYiS8K1+zWk2W8A1AHNcgmBBVJzSzrxUJCn9jesXHNWRtaTHH6DSRV9ZaaNEDay7BluM+LqzHtxLYCfFR90xjfpxypOxnwcvHbXG2I47RcoPhkKATDrGgiLB/DD6+SNQoRqpOkge9w7Uh+4/DAGqTP6O2yuv6noHMxjYaovinwmc0TvAOsbhLpM5DWMpvzlq/YFoRFds2+ilR9sotyWWaWU2TkfDfay5COsPNSw+hxlJgWHbeRJ+qZTsQCI4qh7/1zeFKoOQk5jokX5gV14keyKW3fbza9B5LmET2+IpHruUzj1zY1DXsd9/PZd/zVXc3D+wX+excVaIYZdyVXcBsEbapSt+lqubPsSN1AxNHsjXtInDHgkhJx7kybMoXuV3agCCxmYxA9/Pl7qp3smq1QY3dLrLn9kB3f3ioFV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ulpqa3pXOWR4Tk1XZUFxVEZEZDY1UU85VzNFS2ZGRlREWTRjYUVlanY4NWdJ?=
 =?utf-8?B?V2gwMDFOQndHMDBhNFlFZXhGYVdIVnNBWDJzYndQMTVJZmNkeDFhTXg0dzU3?=
 =?utf-8?B?SXE4elZtTjlDTm1PZEVaVTBtZFVDMW1QNUcwK1hYUDViZFNkeXNRVUhTOHlh?=
 =?utf-8?B?QWlOM3JJaDMzMDNQUklrdVUzakpoWVkveUxWOUlmQ1VvT0U3ZjFiN3ljTmFv?=
 =?utf-8?B?anhMQjd3UjdueEZKbmRWZzVWV1g5a3d3SnVzaVIyVFpnZXVzQ1N3Qk03SHNN?=
 =?utf-8?B?M0VZK3Zudm5IKzVDTklKVTJKMFlnVDNDOUZ3dW9OdXZDTXJ1MHFQZVIzTHYz?=
 =?utf-8?B?aW9GaGdHSHA3R1FmSDhaR3BRUHVIWm5pRFFYVTB5eU56L3U4Z3hNcVpnR1V0?=
 =?utf-8?B?eU41QjhYKy9wZWdlRUZjNVVscTVWVEoxNkpHVnkzdTVPSm1rTVA2WCtqL2Jk?=
 =?utf-8?B?N2drSXVRQzdUc3FJUnZmdVNqempQZUFRUTloRUY1YmxYNVJMMXlxUHY1MGor?=
 =?utf-8?B?VnVSU0h2M1hkQlczNDR3RWw5QnJyWTBJbk13RUJwSDRsTFVNZWFnVHMrQ0Qv?=
 =?utf-8?B?eUJia2RuU29YNU01ZmJnZmhUSlZzVjhRZlB6eWNKSHlBSWtOOWQ2dzQrVkYz?=
 =?utf-8?B?NzBibEcvbUFqWmxRcFRZemRhd2xRdXh6MkdTUFQ5Rm5SMW5wQmhzOUovZkN1?=
 =?utf-8?B?U3I1MU1JU0lqZ2p0bzI0bTBuRHd0dXJGWG0weS9iRkZPRm9qOUpObEZmZ0Ux?=
 =?utf-8?B?V0syWjF6Y3VLdHhlQWRSWmFiWGlocHBHRkVDcEc0SFNyUDZpdXI5ZFZjSnNk?=
 =?utf-8?B?RExmNFNGUTYySFNUTFdWa2pvTzc4MldhNEtrcnJ2R3pkNHhjMWFJTTRUczhz?=
 =?utf-8?B?OE9wMG55Zk1uMGJwWlpUTWhkdndVQm92ckRjY1dVZ3FRYjgrVEZRb2Q4cUhN?=
 =?utf-8?B?Qk5hVG9jVDFIZWhIanNIdzFLank0ZTBDZFB2THFnYXBCcWJHNkhoUVh5V2NX?=
 =?utf-8?B?dERFd1ZhOVJpTW0yL01OYms5Ylo4VUJUVjJOWnA3Q0xCTkRseW1qSjU1MldD?=
 =?utf-8?B?akt6S3IvUFk3bGxyUjlaWVdZZU1WSko1UzE0S283OWpaQ1BBWVpIdWN3RU5h?=
 =?utf-8?B?OXFBcHdxcnZST284endBaFhjclV0TzlMTVQwVHN2MTgxSHZUNVhLbHk3Wmgw?=
 =?utf-8?B?YlViTEF0QThiN3QzR0FBUDk3OERBaERKM2E4Z2hJNXRIZkxNTUYvdG94MGhT?=
 =?utf-8?B?ZFFwa3haZFFteE1oTGpHajBQd0lsUHE0OGI1VGVFN0JEOHZVbkJJekxrN0dW?=
 =?utf-8?B?T0lkY1hxOVBzUlQyQ1BxNndwM2J4NHkrVVhxcmRDaUtGSm9FMUJPcVF6OFpX?=
 =?utf-8?B?bUZSWGhDbjNVRXFpRjg4OWhGY2NHRFdPMTliRTlpZDRYU2VySkI1UUxqMFdy?=
 =?utf-8?B?dGUxa0dwYWR4Qzl5S2VsZStsdHhveG9rK3RQd0VvWXRLaWFnTy9aY211a1BW?=
 =?utf-8?B?SjlyaGVFUnE0TmdIL3hyVUFIRnhyOUIwL3FTdFdpcnlobzlTckh5YTRPeW5L?=
 =?utf-8?B?MmRBOW9FeDFhYnpoRnQzSDRNUmJtUkNnK3QvNUZscUJPTk5aTURYWGpudXRz?=
 =?utf-8?B?UjU3M1RwaGY5Qmc4MG1nelhVRkpUbUg1bC84bXlvWWZhYmJWWHV5ZmVhRVds?=
 =?utf-8?B?Ulp2Q2NodHloMlhVbmpJT2ZqQ1pMUW80Q2VINVlVWXRuQmJsNzV0T0lIMjYw?=
 =?utf-8?B?R0N4MVc4RUNGaEllYmoxYmZzcVk4Tm5rYlRraDdXL3pOdjkrekwyRjA3dTVB?=
 =?utf-8?B?Q2tXc0VudUpZdlZVSnpUOWJBcFpHd3AvMVJJRGI0SkxDOEpqek9jVk1ibFoy?=
 =?utf-8?B?ZW5UNkVtNmZKSElKejVOdnFXL3dING9od0ROaXQ4V2NwSzBydS9CMUR1MGNO?=
 =?utf-8?B?cGdmL1dQamcvTEhSckZod3Z6UURQNGdRSytWemVSUWhvdHZhYUlENkVMNWxz?=
 =?utf-8?B?dkNvR3RnNUpmQUVFQVMxRzdQbVJtSFJ0L0lRU08yNmJEUU1pQkkwcmhiT1hu?=
 =?utf-8?B?Q1JpcDd0cTl0Z0xKQTVpaTVFMUZpK2lpR1UzUHdCOTFZZ0xWeFV4bFZkbGw5?=
 =?utf-8?B?OFF3OWYyZXVsV29FLzhQcm5PUlJ3VWYzMVdGZzhobmU4d3hMeW5Bc1V2Ny85?=
 =?utf-8?B?YkJGRk13SCtnOVROQXU2cklZYWlnRE9XNzVUQ0tXc0NSQytTRHJVaXRObU5Y?=
 =?utf-8?B?UUtUem1DcTg2eUdkZnNSQ2VJRnlyNlBaZDVBYmhGVEVYQVpBWUlJSkxLRlJz?=
 =?utf-8?B?TXpyRFFheHJUZHVzQkZHalA0TXNsMDRmbnhYRVhnaEVITW5WeHllR3kraWkr?=
 =?utf-8?Q?KR5FDPn8UBhdfQQI=3D?=
X-Exchange-RoutingPolicyChecked:
	frTVfONJnJUkSDoFlGhKaP5EtOdP13W4Xq8akyVdT9cR3tO0XOo7Xgdi2pz8DzNgEAKZFyafLySOZK2BjJbpGXBg/bkeNRbBhaJBq7QoUokgQ6DmME8V86GjM1v4h+MKDbBn90yZ5ZTiwPQMRVATbFSiLIoS4ResWbrLZGX8qRGkmB9vGRrNFPQN1erutCpIVcqwxUEslUG/b5oXW/7p9OxorYqpING5P+BEMBoDCrBk6zry8Sih6CEb2eMX7eENUjnOPsKkJil4B8JzulZNnpifJMtmx2pXHLL9cb5gDYoW2WvcwbrruVYXBiO9ub1W2eeb7IaEj04PdsupLxXb3w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R7TQRA2DzGFiJFSOkFwzmX/2Ni0ysR3NHJ5qyszOVRrwDTZmHEHhqrR1IwOVhSTwi1xqoLp3kYuc/JpAA6f0tanDu91Nk5whpch4g8YTry7sPnvQxav0nTQPspP7MoOX63qTUaXK1FNnPnNKGpGQOMmEjL/r2apfLsXwR28yq6QWCOahEtmjuo99R2Or3pU62drwP3yEqcrbwuHRK7vPSeoPeHn13s0s6rca3UT4f6RfTjogckEapLFbPen8YAWBgKctzwYceSHC7YLX9Zh6SVVLOpyZKPChL9N95hlL3r1PwbEfaXCHUci4GQAZL0z3zmS4WBLiY7cpUjnNzpb7AVZmHHEiBRSACYPvgmJlH84r01O/MyV/+4XcuXOCtVGbjd4RvmzsdjFjB9Mw+MLToLXwrGoBN9DMcKMguj5iD5bU6U55qFQ48GSC+jl/7zUdBH4TBTlE9lJdUHL8N1Gr22vjH6nr3TnLfc4uMALa8nLK8UTS+v1ATTBD09z5RPN9t826WmZ4xkID+VL9tnRkpvlrSW/WrgBGa3/1ev9rjgt8aUeHwqNJ+GVkhmEdm46d6TYF9L/wFriNpfTnVvLGWC1AMK0W4/YGVcQxQEHyOJhMTb0nj4dm6WZ9GZn3kw7K
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709cb90c-c55e-4354-4dcc-08dec64910b9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 17:03:44.9815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPlzuxI2QZ+6u03rqe5OKQDy2P/aUTYJ+epJoXAxOKvw5SvKh8OeqE4bsSNCigx78PoAm259klb7nx6sWVZG/ohTOh1aiNt9Bgnkvfuw7r4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8019

On 6/9/26 5:20 PM, Guangshuo Li wrote:
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 0d14570c8bc2..ce1109e47cc7 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -1885,6 +1885,22 @@ void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info)
>   {
>   	int i;
>   
> +	for (i = 0; i < ARRAY_SIZE(space_info->sub_group); i++) {
> +		struct btrfs_space_info *sub_group;
> +
> +		sub_group = space_info->sub_group[i];
> +		if (!sub_group)
> +			continue;

I think you can break here instead of continue. space_info->sub_group is 
not expected to have holes.


> +
> +		/*
> +		 * Remove sub-groups before removing their parent space_info.
> +		 * Clear the pointer first so recursive removal cannot leave a
> +		 * stale child pointer behind.
> +		 */
> +		space_info->sub_group[i] = NULL;
> +		btrfs_sysfs_remove_space_info(sub_group);

That comment IMHO doesn't add any value.



