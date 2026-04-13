Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D93E3AE1B1
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 10:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776074528; cv=fail; b=KepmyUnwr7Se0joWUrk0rwcWx028yKVbdJAUM3HgRc2CToRH6yvki+sjAiBLuOxFgc6juTWZeJcv1jRGmhsBN1OQQaH+6DJG6XDNXOG7SsG4jF/8rnYfFWvA60WNM6zd2q2kk9rtU5/mhvtFHuz+lYhihRvjfBGtF5OB1Q1X35I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776074528; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S8nT2nJ9dDxLeDt07QWEJLiCyZfBX5NY+z3aYUy7xxqC0Bhxm8yDC3sK3Of/tB5Kz1OfvM1tzZIA6wrJcw19VA9ioU35JubvqzXxje0w4yJ7bYTYLvhiDUO7Kx8fZ+abO5hlkgS5ClfDV4LD2p8CaI1McG7QXKDK/3LLq27NL1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iVqlNbkX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=SqUfG/3O; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iVqlNbkX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SqUfG/3O"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776074527; x=1807610527;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=iVqlNbkXU2DDhCcZDvcEql+54TUxscBPpCTq4ud4QZdcPDWIT2DKkRw5
   MaEK+9S9+oLSbN2MBd4NrB61mCf7hdD8UnYG/wVGRkRRDYTIn8mYaBZwk
   sd7QgV51bI/ABYUgEA5Fxgpt/UGAVJ7HWUjcsK5nkBHH94cR7x3/xey14
   OGtz5RtGMFYoeSnK/lkq04OPM6Xk9LkkeT9iyicbne4H0LZyftOt5bYE6
   ymS08psuQQushk6syfBDJJr1ui7aperwEqW6w1gWnrvnaG3ssbB/x39Uh
   VkV9E6PmG5nZCOtworUFhgG7uE8fpgxsQqwd0K7/vE7Dd77M/Y5gvKJJ9
   w==;
X-CSE-ConnectionGUID: SfdKhAwcStmvp6NU37jBfg==
X-CSE-MsgGUID: 9WRRpNGFSi+WUQVkS6EfVA==
X-IronPort-AV: E=Sophos;i="6.23,177,1770566400"; 
   d="scan'208";a="145545588"
Received: from mail-southcentralusazon11011070.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 18:00:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YdVfFMIwWCH7C4o4B6CDHQ3tqJamAwx1MJrTZRX9GiJnv/CS+sWVeJEjXtLOb1abB8UWJuaCzQHLPzZngJmdbFMdc+v+Ze3AWi4NhqGcCYMOt099iCmw1XIAZEsboB9Ijy1+2CHBWSdm+rXRPEAkC9MRVReRmiy03UuwXQ7UvLMCvVSLaIY7jknIqmKdQu/vqa65Mnm3Dumsz0fuigXxWqRl1sSYGNf6FV6ZEKD9yW3FY6aGL2fD9+kfAHWSAi944DYuKKlCVfHUXAI8tcjVyFyyyudtG0LcblhVEAQZe7bkHDyQpm6x/dmKCXnRhjA+UCI/AWvVjB8odxieUYsE/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=aeRWcbXlEMG1Ywk11z4b/uk7uQ6YE6rVM11e4CT5dxV6IaPPu5t7CqYu0ziogI1oWD6bwdWRHAKurZJPKYepRmLTNV+OHENMdAuPuFcm/bVb6cq7ClkTWhTNyKK2TvmTa8FMsJeHNzNEakeVqpQQUimPdZbKlqkddqMmfFvmDiR+hf8SMdbjqd9EK+if8G2k99scd4IRmI5yDkrb4Z3DUnf5bilpJqQvvF82Qmq3XgzZDOEzCX8Wm/j48rXVfhp1QTVyYzsiqXQ6Y35K/v7ELIDxk3j66fwGbzu95GV0j6EXngGxKXmrsfM65t0AqoANY8fBJVYQ/yKjPVHghV1YsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=SqUfG/3O1UvmJJiZFwjb0edi0FS+x5xPiTX9vuapeyppepvuBwpcEz0M4By62gke+VrBaSXXyjJMhY/8mQal0iC0u0Hs+771NATKfsGFGnwZZdGmi89or4tH/uKvh9EGiQFeCqwV5etrnKjHgiwPJq7v+5frxDWn2EqHnj3IUS4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by DS1PR04MB9653.namprd04.prod.outlook.com (2603:10b6:8:222::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 10:00:56 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 10:00:56 +0000
Message-ID: <fdac449a-5a35-4d26-a861-908566067de8@wdc.com>
Date: Mon, 13 Apr 2026 12:00:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] btrfs: check return value of
 btrfs_partially_delete_raid_extent()
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <20260413065249.2320122-1-robbieko@synology.com>
 <20260413065249.2320122-7-robbieko@synology.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260413065249.2320122-7-robbieko@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|DS1PR04MB9653:EE_
X-MS-Office365-Filtering-Correlation-Id: 37f0e39c-cfe4-4812-637f-08de99438e12
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+5MuFF5+Qq1rfF/vmPu9wkBzoEcWymuK7c22LDBhkTPqqLcAnF32zF9d874eXoSYIvnPdaFiD/YssmCD5IOVmnjgqtuW0aY5L+RwPtjYMdaQ6g3GdWTx9LjmXZMlXLQN9S4MGkicLNnF+rA981Va9FU/cWliG4LEXkXsBjZ3jmMYiVnEmHMYQY77Vrh6q3Gi2JkFGDeMT3UqQIdRf9mXLrwMQrxjfhupeyQNOT7io75cv4TSFcaBXsZiUTVoMhMp0xoZJz6I9qeHUHOBx9teFF1Zr7e7MgB2+Dj4IE7ZsxX1v9+wp3l8O3WrEw3186ueJmJvHWFt46qNJ5rjafwUiCISuQQR64zKkT5BcRCcJ8s2vyCtBIvwIIBIoPwR/Y4BaiOXm24yPEywNklTPvwE0YMmrGVnNG9bVZBbcyCqR+GdTFcYKPFZY2Q/nv19oqWi3GRyb0ujEQFvOVJtyPexMmewOjiJ7QAKiOJ4mjdQ7k79RrxlRIMSrSrn0GtMiSjafJraVBXKPtdkTovYofz8D/tK/VA0klLYRIYfl0HxMqy/LaR5G/Y+cs25iJHJ52N5ufLNVLkqZ6PjfkVju9jBOwDOcST1tlDOdl+mFHnPCVOCPVNWsd6M6+3EarD2RGVfceoRzbaMcQwCUVy3hB82ku5EEkBc7/IkmUDBKH4R1YgHiGYwGT2sfUdOFNE8403TUbHfb/BHXlVqKpgSBZZIWa0TQUTkh5Q1sOvRLGq4wIw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UCtUV3JCOWZmTGFoTjFzTjd5L3lGTnJMK2c5cjlwVnZIWHQ5WW9LR3FWWkpq?=
 =?utf-8?B?NThnalU2dG1OUmU2bURGTXhCQ1IzYitlMWdxMjNVUG14dG9HTU9UTnk5QkFm?=
 =?utf-8?B?R0RhVEJzdmNCRStsQUFEU0lmb05IUEJUOGNhMDNCQTk5dGdEYkpobUxHTTBB?=
 =?utf-8?B?ZVUwQWd2aXc5M3lWYWxBWC9wRmN1QWZ5OVRKZXRlQVVTdmFZWW5UMVV5dllx?=
 =?utf-8?B?Vzd1UXNUeit6a2wwK0ZzTkZ6bGxrUWdhRGF0MkRRZ1ZHM1pSZzVvWTlUUU9j?=
 =?utf-8?B?U2FyRGs0ZUs2S3UrNHFMTmp1T0xDTURPSTBKckRnU2h0Ulpvelk4NGFkRWVO?=
 =?utf-8?B?bTBIU2Fva2tjb1dCY1ZuTFdvVitXQjVrcmdLL1pzR1ZLTFhUbG9vY3FDemxz?=
 =?utf-8?B?cTlaNUd4S1MzMlJhL01VTVJPaWNzYVJweGVVYUVaS3dQbzU5TURBakxRVW9J?=
 =?utf-8?B?b2Z2Q21MRHZPWWdjVk5ybWhHTHFNQlJwak1UV3V3aURpTkFZVmVyZ25pMk5J?=
 =?utf-8?B?dXVkN2RpRUNPUVE2Vzc2NXRlRGQ2K1VmSC9RUjlDQThYeW9OY1U2NDZpakRl?=
 =?utf-8?B?cmFYZ2QvcUNxZEcxa0drWFZPQlF6bHB0UjBWVTcyNVVhckEzWWhwNm1Ld3FJ?=
 =?utf-8?B?YkhLanJRRFhwYVc1U0FHWHBjYmFCdzc5Q1I3MWpJTksyRWxGNTRvQVdScXU2?=
 =?utf-8?B?NHRVakMrYVVoeUdmeGUzU0R3YjZTU2U0N0lkMjAvYjZDc2VWL3RvRG9KaUc1?=
 =?utf-8?B?QTJvekQvc1F1dmU3U0pRMDF6MzFIbEpVY2ZCM0xMZkdyT0RUaFhpV01OdmJF?=
 =?utf-8?B?dldvT2c3U2RsZmhpN1ltV3BUcnpsdXAvL3NpcDBld0ZyZCsyak9jdzFuU0w4?=
 =?utf-8?B?YjNyeVkrZ2M1NHRNRHBxV0E0U0lvaE5FY1p5MEVGVmFvdDJkUm14dUlaSXZ5?=
 =?utf-8?B?MGZMellxU0tsUTdkYnNqVFNiT1hHaHBzS0NGem4xTVlpclpESVBQQWdHTDQz?=
 =?utf-8?B?eTd5OFpKYTMyYkc1cGM4SzFnKzVOdEpkOU5QK0VlUm1BNXdJSHZqQVcrdE1w?=
 =?utf-8?B?ZU9yWXBsV2tuMEhXQzVEdGp1SFNwQ0NuREpxUzJTRXh0SG5nQzUrd2ZIdjlw?=
 =?utf-8?B?dGpTaWsyYVhmT3QvRWRza2tTemxlVDNlT1ExZzMrNzVFWXROWVo3Q0JJR2Ju?=
 =?utf-8?B?T3F0VVIxNnF5OTZXZjlVQ08rQnFwTm5ETTJmN2lPOUhJaGVOQmYrcWdEai9i?=
 =?utf-8?B?clVaRkM2NCtnS0RPSUhORWNXY01QazFsRGI0RlVLeG5KN0x4RnRBL3I0bE80?=
 =?utf-8?B?K3JxRlkvS2xPUC9Ya2VBbFZ0UU9pY2JuQUt4VjRMK3ZFZkFKcVN3ekxBemRw?=
 =?utf-8?B?cHMxL2RNZUNDSWRTU24yelZIdEdXcloveHgxZWlmZTk0WmE5VXBqSlZYQnRl?=
 =?utf-8?B?TG5BdmJ3b0IybXJEMG5LV3dYTUxQUEhNR0hmSUtLVGpFUWc0bnpnZHRXN1VR?=
 =?utf-8?B?Vks3UjM5ZlQ4RWJma1Vpak54bFpyaGMwR1Y3SXEyZ3pQNW5OY2dEcFR4cU5K?=
 =?utf-8?B?OVN3RzVPZi9xSW5GUk5HbFVZY2orbVRENCtKYUIySFh6NHBoSkIyL0JmYTQ1?=
 =?utf-8?B?LzhzcDcybzduaEwzUm9zRGVTQXhVWE5ZUEovckM4WnJMU3hub1ExWUZKYmlV?=
 =?utf-8?B?MTVTcU1yVndFbjlOR2NUVXloNCtuZzBsa01hVTV2NlFrR2tmWEx0c2lMWU9i?=
 =?utf-8?B?NnR5dzBjRisxU3FzK3JhQnV1THVnU2xHakhBQWVCZkQ2eTAwZkl4RjdEWVI3?=
 =?utf-8?B?dmpNeGZoaUxjU3lNM1B4V01FZmh0d3doeENEQVh1NnlodzhiVG5XRFZBMlVz?=
 =?utf-8?B?dmFnSFh1S1ZkTnVqUmMxYTdsWFhFSm9OcWVqd2taL0d0SE03VVlyQll2U21j?=
 =?utf-8?B?SDhtVk5tUm9yVElnL2VtU1VZNENscEZtSkZ5ZUFzbEFmanNWdmE1bzk4Mkcz?=
 =?utf-8?B?QVFHZWhUbHRSbG1mZ0lIWnhhazBYWkx0M0Vqc3B0dk1vYWVheEN6RE1laXNp?=
 =?utf-8?B?eXQzQzYyZXJxeEgzZVJPb21qR28zOFd4MGtGVVJmZm9yeEVwZllGb3U5N2hJ?=
 =?utf-8?B?YTFsNUlRcW9pK1cyenZHb29CNWZjNGZjY2xFVFZVcTBuN0hYM0ZoalFJaXFI?=
 =?utf-8?B?OU9USkxSS0JWZVVKOTNTMC9yWWo5Z2t5Wi9FenF0Y2ttczZzYU8ybzFjeDlj?=
 =?utf-8?B?SzR2QUVSU2JzSU1BemFaS2plWEtTakJsMkRHNWRncCtwWTI5SkxVL3ZwSjNi?=
 =?utf-8?B?eDBzT0JISmhQVWtZM2M0ME9yTnlSUGcvM1VLa0szR3p3NzlwL1g3Tjc3MVBz?=
 =?utf-8?Q?9n5EGthN2tDSy2jtsVw2fNcztT/LhYq/ZoOQPyUVot3q2?=
X-MS-Exchange-AntiSpam-MessageData-1: EA1olDth33uULPCaB0oYkZscfSIqUZRydSg=
X-Exchange-RoutingPolicyChecked:
	YNaCSc5VulJBCstWrm9BC9npo/G0TBKWitBCiythsWKc46OKI5cHD3v0Mtle/w+jH0uX4HOm9C/TC0VSIXmjcTDN60Py+UlKUp9l3iXLyHqUtyY5fqtkIKn1pH3bTdBELL4IBIARgpvGgnR1b3nWVPfDnziDOZ5Hhsitc4oFX+VMOl6JBi/dhBxBrgr6RVBOP78/c1E8JVE8KQ0t+LJ9N8qB8gQSpQL51VAYKGG4ROmAW0YTVcbRpjEuiwCcz4AIy230xsC+d7mYnTZN53RPqCME6P/A5xGNASVinJPcF1AA3NCfCLOXdSr9/eAEBJbyMZzIvYoKTfPSAfHjOOTOJw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vd9oghuyM4uc+zuAhKNDXu8ZO9388GaUW/+wNJH7qRhFXbT3wBDtzH6F+rlpMlgbhNfRTYJUr4CrwcLHvWg99ihenFj6V045N5lw9nRMSiUfx9vVEqekTpbrAsH8x1PRVXY2J3U+kMRrVC2KdqdaeMsU2QAOI7A8GOsdVDGtZb0SmOp1n6pN8BQHtftHjM7OtsXZrUlljqwfFyMnCK/pmQQfppwcviR1/TTjtpxiwLsYo5TFP021VBca/Fxx1f9O9BwGD4garJw6hKnAOXAdxQE61GYhgEEax1/+sftCM18Rbhd7YnmvGhbMEx46PL9sD/VIjFXO1CzkXdd1j89q2QVJ1hLGjLmvMS2u2LWWSQt3RfvvhIHrhM7mTGBgQrakzCIYC4cFVLBzqci+UgtmZ/Jk3wmkh9QHf07xq3akSO25curBbBffTBso44EhTFOt+zxGiXvQZhsaRzZxL5H3Kh51DF7N8Jjv4kCAEM6QzOORPeFRJs4xhNu9B/xacA1pk/QZLxfcHJKa4kJSWk1CzdxXbjTl3NPaaTdRj7xg0PYS5x0lgVlFMJ0cKGt/vdG9IFakxt27joFUpIZbS8qKHrt9lmFaM2CgHyAKQjdGFZ7morAJaxWdUvyxWCmoddW4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f0e39c-cfe4-4812-637f-08de99438e12
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 10:00:56.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qmAkKQhlmnl4t7esbtypvK9HYoC7LSQvR9sJvpLRrvzyIIBo3gfXy3kDfMLUEg6VbZmHLwm17rDfEi2wRip5yKfsEIQEiPNE64iGnZviNc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9653

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


