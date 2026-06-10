Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AB23B95FA
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 09:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781082793; cv=fail; b=Gaa5gnJCciJiQ0Bs4cWHKt/Tte7dzxqXfzor3hCy/3QW+vdCd6yXStW01hKaJGWKDtmDyaVWVJpFcHZuN8xpMHw62AMS4Q/DzrPaEXMFYBKi/Ww57b99sFCT5P718txGEagnZqiNPl/1mfyL26XcWqzlUt5pJwh80MuiepkS1kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781082793; c=relaxed/simple;
	bh=d+Vjezxkh7/DaO5q6QjS/mHgWlK70nUv69Ce5kKzLFE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PjT1LRHpejfB+hbHykj1dqYRqMPO1Nwu335VwsGMQ1iJiQGjfqCWc/rP3qkTMAZylshonFheJwqwjUScfwZDXdHnFtlEpDSQqSIk2zj6SycTBAvRtqbwbVFb33HWR2Q+pTt7qNfeJ6SIRKfkZu0V7c1EbMNlkbdQCvo77pMl2zU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fdv/uxkN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=D3LjaZeS; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fdv/uxkN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="D3LjaZeS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781082791; x=1812618791;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d+Vjezxkh7/DaO5q6QjS/mHgWlK70nUv69Ce5kKzLFE=;
  b=fdv/uxkNSydFgp1IuVZgnXxv9RhsU3fPGGYPUGb/h/dpSCqLXNTpsj3E
   rv2hsHhCFYwLwgJuqf2CmHCI05qWmgoO6Wlzp7SGw1ZVQOASyYhvxPPhv
   ocbdcXpayZF4fC3bc8uQqFefKuPAJg0IAHrLmo9c1kLT5uoirKkkQWpc9
   l4n8+gUNET55g3+/yS1fWhWaGw7I6pRh7tF58DuSe69vs4FaIR1EryYMG
   QwMEC6OeiNttA6esQRG3fhX0vtKeJCNzsGfXn+30yIcENotwM6ZMqZM3/
   /x9TTiYmxFMBusauYqPkP2MZGsOQIOus9CJKGHmRStogDblpBnaPXZUom
   g==;
X-CSE-ConnectionGUID: tDYuHa88R6+KBmMgcs9eeQ==
X-CSE-MsgGUID: HNDB3/lKSfKqSTwmgUWaBQ==
X-IronPort-AV: E=Sophos;i="6.24,197,1774281600"; 
   d="scan'208";a="148475907"
Received: from mail-westus3azon11011032.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jun 2026 17:12:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5KQd4xE9vRJSm17vkeN+Bnn24EWtWIZoop0cc+0KHJucuuZEcqQOwvTPTk+pDdk+wAqDhKx2hrHiKsl51immcW3tmwxnBywMcqLiQfbpkOP8brC8SJpfgSMM/NoPaPDnJAaeY3c3vm7rMKX9hij7p8HSugRyi9KdPXiD3WVy3/uICv/oTisrwEsy+ZOG8Vy3N2oRgu5bv17ErTxlA/1Vc2Lvcsb02dGsnQrPN6GsZiZyMeDrKYunSreF7fdtDOBw2c5Y/SzHa8GTW5JedKRItrvp+j8glZjpI3n4wspdA63K4ZsWDV2TwWnUpxHqsft4TozrvtRux6bkLcwhz2PVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYxBKP22BsWakeHc4SL2nkpX8JFPi5oaOd4KRPTa5mI=;
 b=YT9IyMNTWuKo73dbQfTSK7M8rfnpok0kClYQme0SSIvXsioGUoA0RLfCratu8PJYrZxS21HFeYCxUl2QyWAWylwCyC3PQszEIIzCQs0tvPww+0pHTkvw6b0sCK9KZCqz+gnod9zD1sYHvUs9lwU5l0vtSVPb188eE6yYanrB8UehqWJCXg8xRU3Br5uO/pkDKvfclEDYHvtN+fuXIImrcJyELVebyosvYU4k0lE+I8hV0UFmi5khs8KEAx4GwNhDpdEy4BRQ5C4ybUHT1hWp2nKo8vuNbRXT0a2wpVNhhg3cNugqECW99Syjwl0XxRyMlwuRwERFzdRrENbU02rAfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYxBKP22BsWakeHc4SL2nkpX8JFPi5oaOd4KRPTa5mI=;
 b=D3LjaZeS/YuQEz9/BDa1Jtyi9I4YkwhwQyB6e5GfEIB6ap8LylRfrnuna6EiJ21pDNUp8w1Ma1HKJoM/kdunxT0Pe1+7SSuvKqjPQGQJFfAZUbEfOV8WuxCICf1fbSTqjbIm8/E4rjDkW1QwK4lU5A6mb2lfpdFNUtm3zMB+zrI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6941.namprd04.prod.outlook.com (2603:10b6:208:1e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Wed, 10 Jun
 2026 09:12:01 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 09:12:01 +0000
Message-ID: <e956bcd9-7ebf-444e-bba1-b131251ce201@wdc.com>
Date: Wed, 10 Jun 2026 11:11:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/11] btrfs: add support for inserting raid stripe
 extents
To: Alex Lyakas <alex.lyakas@zadara.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20230914-raid-stripe-tree-v9-0-15d423829637@wdc.com>
 <20230914-raid-stripe-tree-v9-3-15d423829637@wdc.com>
 <CAOcd+r1PCM8t6zuVh1jxkQzEGr3_p+qhuoypE=6Cj=HWovQ_kg@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAOcd+r1PCM8t6zuVh1jxkQzEGr3_p+qhuoypE=6Cj=HWovQ_kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0166.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::9) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6941:EE_
X-MS-Office365-Filtering-Correlation-Id: 6971275e-507b-4814-d478-08dec6d054f9
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10070799003|19092799006|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GyaNk4UPyL1QGLwg2sUu58ImXhfVl2R+sg+kaDa9OmoJwpvg5rPYfFoWReKhqIw2mkGzbrxzuLwAzFH65bzhFnznwiCpdeSNylnFMcN2Z6mCGRTKuuI8afmXyaAllU5Mxag2yNXYK2iw9v/Ugi4dhWqy1q0RgvxnvY2c7Ifi7INdOReaExY5oRgCzQ1H8Z0hqjeyYeT1qmHu9HNEEQkZqM2pM848XW011sc1iMVupfkRcGaJ1VDEXHFVaUc6ppZcLde/V3IyTnoUQ3nqJiZzr2oSKtOgh3QXWZRSZtRrEaNjZSry8xOCyKamoRDpVsBy3NKMrNNUaaY/O4YPVZ7KvV2Q/xzBXCJ1SWLLDCj9ul8pu0ZlP6qBYn1wev1i37+NZJoFuzNhrgck9fTQMakeJEJ7/+16Q5GJ99BZadIm5un7rDR/JO+UDuRMkI8YfC+GVAkQsLQ8FqjaarLI9C+oDNgu0kdRs0/FdhS6r3/40ftSxyUb+8PnK+Ej65wdqJTMggH3E0pYCHikJWGdPhM8mvVKtVND1aD+FG9ajIIHB65prtPIiWH1NN1ql1vJ3H89e41LGjfdHBFpm7kA9EPMPMGbd5amTSIWdgsRbjZqDEpQlgO3TNoDRTeaMH3H+UthdtT0xYGtmsZO/x4HgblSsvuEsAxuf3XVUuzwh0ADxz3wlV3r65lVipy5uXgZOF13
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10070799003)(19092799006)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmRXREFJS0xtVGY4NlJWSHV6b0V2ZitNTElsRGZpcVgwSjR0Yjdtdkl6dTg3?=
 =?utf-8?B?OHNjMFFkSFFnVDE3SUpCN0cwakpjSWVkdUdqS0kweGovMExRUVV2RGo0OXdC?=
 =?utf-8?B?eVdvVmJCWjR6RzgrUFRRQ2NLVGljR2t0TVRlRDI0WHIzR0J3UFM2MmVCVmlH?=
 =?utf-8?B?MnJpRWNIWEpMWXRiUVJjek5nTER6ZEgwNE5vZjZIcUtFZ0NYcnVBVnBwQjVZ?=
 =?utf-8?B?T3FzWHpsZThTZ2VoWE13b3VLYUwwbzU3SzBEYTFmRDlDZnZtREFSeisySDNV?=
 =?utf-8?B?Z0ptVXgyTUVFTWRRQlkwa0VoVnI1bFZNZ0xIOFYxc2hTaWdSaVJ6Y2dpL3VY?=
 =?utf-8?B?RTAyb3hnUlFqaUNSWmRueW4rWC8zc2tjTDdXQVZ0azhIVGlPRWxTUUwrZWF5?=
 =?utf-8?B?RDNjS3VsNGI0RnNCWG44UXBIS1pZSWRGWTVqRmNEUlJ3dkZGVTg0TUQxcFJL?=
 =?utf-8?B?VkkzQ2VsdU5JTG90dHBCdHJ3SGNiWWRoL0hNN2xPRlk2Z1Q5QkRlenMzSUtZ?=
 =?utf-8?B?VGovM2VTMzd3NTF2NUlZUXdrOTg4WHJKbHlFYXdTcUt4UUZaalVXRTJJclJM?=
 =?utf-8?B?cThkM3dEaWkyREhuaVQxSVJFcnhIY2Z5TzJVUXo0Rk1aTEQxUWZVNDB3emh0?=
 =?utf-8?B?NFJQcVYxYUNWMDUyZlducHlPNThYTExhNmZ3ZURYUnp4UXd4QUlDNXQ3NjNI?=
 =?utf-8?B?NCtrL2RvMUtGRXNTcHVuZ3d2UFdZaHlPNUZoaDhCTUo3Y1BOenM1RjdReFVm?=
 =?utf-8?B?TjJ4S2QyMFhQU1VwbkN4bHFkNWNGTjdqVGx5TmczZmtqZFN4bUw5MGxWMTFh?=
 =?utf-8?B?eEREOEYyQ2Z4Kzl0cDZUTzMzSGpXc2ZhQ3J1cnhLT3F5Y1VwYTNnZEhqYkhs?=
 =?utf-8?B?Mmd4QXZYQlg4WExOelViSGxqOUFnbWlrSnlwcVA0UTJ4RHg2OGFjRG01ZVJE?=
 =?utf-8?B?Y3lNVVRZdEJFM21ibXZpUFN2TG1xMTFyUzNTQnpmY3k4dzR0RWluVkR5azky?=
 =?utf-8?B?cGZPbXhQMXhKYVZxQjVqTCs2WjYvMTFjN1VkbkJRU0M0dnErYjFqa21TUy9x?=
 =?utf-8?B?TG1PSGxuRGdHb3Z5UXcxVEJ0bTdYKzdRYURsdDdGM2I1dzZSL093cjg4SVlF?=
 =?utf-8?B?NXdIQWxqbFdkMGYrUTZpeXRvczFkZ2JWQ1prTTgwQTdQUkFKNk5reVEwMmhU?=
 =?utf-8?B?eTdFVEc2WnZHWURIL0RPY21EaUZrWUxVQ1VZMkhhSXJxUld3ZExtaHhUNnp4?=
 =?utf-8?B?UDhhSXZ3MngzTjl2R3RwZjNUTUVpS1drM0FjdE9iai9ldmxQV1dST2J2eHNh?=
 =?utf-8?B?dGg0N3dZNmt4TmNHU1k5Vy9QN3pqZklQVkZWKzNWYTIvanZKV3FycytHdElF?=
 =?utf-8?B?WnJ2RHd4UUxhNzhJU1VrVmoyelk4RkdPL2NFVE1FTisyMEF5QjhrWWNPVkhi?=
 =?utf-8?B?cmI1Sk4vVW5xNXlRcmwyOE9CMEQzVTFkYXUyMWtObkNsYTByOWFKK1Z0Rmpy?=
 =?utf-8?B?ampDT2hBSGlpTnZ4bGExTzVSMXRjcFJpckRMZUtsamJXWEhLNC9ENHlpVHZF?=
 =?utf-8?B?SVg0d2diNzNBMkNYV09MdE0wL0JORTE5QnZ6b2FUVnpqTk94UEQzWFE5TXdQ?=
 =?utf-8?B?VzhNN1JzN0RRalVjekRLbTluY3FMU2ZuTW1oRmlsNmExQUw5WFVrQ0lpenNq?=
 =?utf-8?B?Q0FvYTJUSVM1djFUQVhCTVJYaVdZNkozL0xWUlJ0a1JtUWVYZ0NXVmtaeTF2?=
 =?utf-8?B?TXE3bUJuNmJSa21UTXV3T0RKS0kvdHRDeWlOc2ZNSFR2VUlQazllT3RlbE92?=
 =?utf-8?B?dHlXUUEza2lWNFlhc2dtc1dYNkJMN3RGbmVuRTAzRWZnV2dLWUxCZDVNWjM1?=
 =?utf-8?B?QllpS2U1eTRLbDFUd1BsZHQ1ZVdwYmdZelVhQnhPczdHYXIraGNoWkhMK3Fp?=
 =?utf-8?B?ZUttOTJDVjMzVFVDNzg2b09vdXNHL2VRTUxOUVBWRFNmR2NRKytwdHpjZnZJ?=
 =?utf-8?B?T1FwQ2h3azFLZDcybDcyNnZLQ2hLQWhkcFhrZ1dPRVhUQXZhbHFLb2JjdU44?=
 =?utf-8?B?bk9PK1NnNkZ6NjJ2ZHV5MnIvMU1aQ1BWVVdQR29IL3ljbXVsR00rWUI3cUkr?=
 =?utf-8?B?L3k2bzBCUVE5RWxaSnJGLytBdUk1U3JhLzh0UWtPdHFyMStQVEZ3ZENWK0lC?=
 =?utf-8?B?amNmYkZoOFgzZFJtK0VjakhoalJBOUpncEVja2tnVCtxcUVZVEkxSmJPdHh3?=
 =?utf-8?B?NmI3RTViVGIyUHVQVXFFSStEQU9rRkxWdHFTUjFXZWZvZ0ljWVNEM1dBV25r?=
 =?utf-8?B?N3RlVTdteGtNam5UT3FlanlKOGl5MmpXWjdlSTNrSXJoaXRaei9paW9Celh5?=
 =?utf-8?Q?Db4Z6wvK004Z18bbnJq9Fx/S6XPsW9QnofccqxxVZY7h5?=
X-MS-Exchange-AntiSpam-MessageData-1: PWQXo1r8d5oZjQ==
X-Exchange-RoutingPolicyChecked:
	RC7cRIujrSKqr7/TK0dVgyQIQuOf2Fx/VEhtokmDzVWQywWwpNd06zAo+O0QNkfXDXNdCyUblBa+Xw6slfK3RQ/KeyQI1QMgp3AdVBfCnfVSQa3SuiPT6haOdFI+Z3yW/+kBGR77L9oYVNVvSqWAO84ULc1cKWdBhLZuFizzWGex9cSaV3AxNgm9aQ/8uVENbiJpgO6NmnxGK2diZT/CDtyN3Haiid2ZtXX4mv9qTVgApTROcBTlbEod1UEZAfCi4l/iq8JWkINy+EZqjRbugcY2fE2egxk3KgAmSsBA1FnVZsHEHvN8kP1gUtsRt1vubnbsIwxawIENTfpgKW1mPw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6HAMPbygQ2yD6b7DqSC4FfjpPIgLgw+cJmTra9b/70Bi6ANIUTE7B575eQuQQ/KWX1fJai0CHmBdqEcb+bwie8/x/auwK8tdYqgZ3pYEc7K/XvrgCAn6T5NkGNv+kQAD5QNOGD8Zo3IZfHLc7IJsV18u6ZTF4oUkFVjOTVLfnojfZgjh/jbAziJFcvc4Yx4UCfyRXoY8t/jgqpA9EybOmTh0iyzf9Y3SyVpewHEOrRT56KU4GTyAgxak/ZPUptPD39EuxIB5A/B6zlvNG10zAaCPtYz1GWBHySBobF4uCqoTxz++VCCje0wfBD2bn7I8y2OMiwjO1NRsXwzK961HjZNdprLPb7Be8DqyX9NAjnCgyEziThX6ESwLcjCgJv8gZWiy8y3rf0Ot7MpskND3JT5m5zg6l6LD/RMAP3NI622T7usLmZNxqh/yXPGHqRCPAwGNm/xJ0193tNMLqzEFEPobKiOShtrn4wAeDoZYmZCEY44lBVc3JIKOt0TRDq5vlqPpqd955i+bVGLq4/hHXa/NmV39gavv75VFqYbyKwzakDRF8+ylR3k0/ZpGZAbYGDYY3h45U7N/Yt2N4iGUPTIdw1WHNjWc2csRKbA49xsVjWfgL/ntf10lQsDFCLFU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6971275e-507b-4814-d478-08dec6d054f9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 09:12:01.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtRK8lpBfOFyUhpTbZz+cCNfINgEd7dFakQ/uyNyWx0/mBhT5DvECtknZKntymzrLMTaHz4o967lJzrDdaKyN1EKZIet/bIV94NrP3ZaIgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6941

On 5/27/26 2:34 PM, Alex Lyakas wrote:
> These two lines now appear twice. Is this fine?
> At least in linux-stable 6.6 I have now:
>
>          if (bio_op(bio) != REQ_OP_READ)
>              btrfs_bio(bio)->orig_physical = smap->physical;
>          bio->bi_iter.bi_sector = smap->physical >> SECTOR_SHIFT;
>          if (bio_op(bio) != REQ_OP_READ)
>              btrfs_bio(bio)->orig_physical = smap->physical;
>
> Looks redundant.
>
Hi Alex,

yes this has been fixed upstream a while ago with commit: c4e5b7470a3f 
("btrfs: remove duplicate recording of physical address").

