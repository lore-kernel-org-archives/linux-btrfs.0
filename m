Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793891108;
	b=wQh2KAAjGlss9IyZb0EHimFGIzm/Z8KtP+P+L2QyQKeGDCWDGX6wYyKTxbTqgEC89FZ0
	 HmiI6HU4nuGs9AQ8loEdPHvhuHjDw5AWkOwYFC7M05tLuxKMuKGmzozW8wdxl9715/jGN
	 nRmBg5KoSymm5nTXMeBk2Id6AnvQXvpMtEcZ3WCyO/fmxeNO/g285mXwk6FHqOSQc/sUk
	 R7/vA2/wrekMJFrlsZ23UrYKHsDGSz+50fZHMvQCGyKVCiRbAzvFH3zmBGr81GU5FLkBS
	 gu0WdrYk/Co1E3K5MmdnkolKtizRnpCg4mUeTB3gsb3wpfXVQnSh9wV8WLEhNL2zzOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793891108;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=/Eu08qFKIDu3k+EbcBFflygFlR8KbrCH5ahh0PUDzRU=;
	b=Rd+37q8YXJWKoJVVxfIYI7bIGI0vQrbSUv0Hod+76oXN8uw2L6Q1oVW/v+hKIyc5HlUy
	 s+YbNLKOLzBYo4rrMMCKeBurzQfSOgkfHXk1qXoWNh3LsltBm2DjVkSQ4uUD83hAmwYS+
	 UJ//9FcfRohdfsjFg/ffelEY8s7PaV9zcMswqPUYyXFzX0lRI9oU4gSiavcKxe0yQORrC
	 23zZ8srxKl0ixyhHhphpJkHBTcOIfOsuHb5ilBBKq4vA/7ZT+Mpkw7hrjYinsHlB/8rRF
	 P64AuKNDz+xXp7ZdY1/zyMQuHYEzqX2is0wwbSd0N/t4+8NJqGqAtv+rFMPnPEIyl0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=psPGh81H;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=k2E9N7Fg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748EB606A32C
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 15:05:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 748EB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=psPGh81H;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=k2E9N7Fg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793891108; x=1825427108;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o51PtKrkZNql3o4HJkI3GJ8tAxcDdCt77yqIHoIv9ks=;
  b=psPGh81HRI4v7e3Eg2IhQL9gqawKqjDE9kM8oi6i8VR0vQjrMsLU/dz2
   Na8BsvAeH7i2OsU6oasnnp0n/yEp5fo17XWsqNRWlZ8YOyuMD8TB0g5FK
   Z0d3ykihlQJn1QbpkQ/XPcKPoyJwrx5jcmA4wkD1xmolX71/dAzzZs7fA
   exipMplOj0eP8stCeeFLrg4eExap6TjLZYTrA/DGugso+1/CyftYtokUN
   ylSHDOY2Os3FcK44sfHpG+RaAHMMpad1qm45jenMg51pbZagdchUWPBUZ
   GBLiA/La0/odz6SHW/hotnw5t0oYaUKxiccbtnXu0+N833ySdkaPqno8c
   g==;
X-CSE-ConnectionGUID: 0tE9OLHOR6uyWIH7Bzbblw==
X-CSE-MsgGUID: WdzTpI+zTVCJIVcNaAx7QQ==
X-IronPort-AV: E=Sophos;i="6.27,197,1786982400"; 
   d="scan'208";a="159900622"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Nov 2026 23:05:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=poL8LT7QxI2zks+fX8eVR0elTAMlUH/aIePoMn6EEWwc2DihtWmE/SPvtEIVIQaGwyYrI5+bTZubht3JUYSBUXSFpdV4Ltn2Ij9oi1ywMpxeN1tGBJHfP56FEgi+u+Lkqt1MOLm5tn4u+tXUCwGeU17FHg4Nug6eUSaK64wM41eDTsoZjaRlPAT55HThc7Dp0IKb58S4SyFdY00Df0SMPGbPbCWsJ3fxRRFHjS6s6mtSizUiZrISJUJwjMa+lgKlihyOgqhbS3IMpAtG0YJlEhnnFXITBF0tl9JtuRikJwVn5JQZh5MISXI31ne3ej0A3HRBBRFagZqPvgosOqB/DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Eu08qFKIDu3k+EbcBFflygFlR8KbrCH5ahh0PUDzRU=;
 b=rwewIcazFFsbYrDMsZj+q5tUUeZpQs/c68we8t40E0xesb4SqKFNVGtVwTheSU67teuvufbp4sWdZC8reja7CEc3L5SbBhSjxlmcUPyy8ficSC2Z9UGUJjGptUZ29BzGAaiC3b/znCPtOVgasH8WpddUZGjr+TmgZO0IPtWMQNvHDQiQVX7Hx0eDYeMaj+6Y1mDdOXTmNv1/O6XLPi9xil5lbIkx1wW8qPf/t/7w3V2US02QAmAdy1CISyq54MSSjNw2XfLSV6tRqbC4WGXRdDwJuNUkuu+zT6dYOxnk7xT3UJyVFizHZNHK4YzDCxsOpPrEoElwa6/mLzzc0tvU5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Eu08qFKIDu3k+EbcBFflygFlR8KbrCH5ahh0PUDzRU=;
 b=k2E9N7FgYZNO71aui6XN+D6rOUi/+B6p3LDpRKf8X9jk0WqPazeK2DFZrqveQFOsqOeeVrmGLRuupHgvgqOh30wrCCr6nQMdV8v/3hCuLXoArAeXcvZDb278t7PTMPTXnFr65Qchc4f52hU8vt33H4TsfEONSjUbPCWbtWvNmrY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH9PR04MB004275.namprd04.prod.outlook.com (2603:10b6:510:3e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 15:04:57 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 15:04:57 +0000
Message-ID: <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com>
Date: Thu, 5 Nov 2026 16:04:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Jochen Philipp <a2jphilipp@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com>
 <ca6f02ee-8b39-4e90-9006-a6f0606e26f8@wdc.com>
 <CAD=K2o_-NwLNpvNE+OreAmsvX+izzZnb2R1nCBV0gDf6fH=kmw@mail.gmail.com>
 <904615c7-003a-4158-922d-c57dee9a3ecf@wdc.com>
 <CAD=K2o_vLPSvm4Qzi8y4t5ay+Na9GNk2t5a3iMO3NYJvwodKDQ@mail.gmail.com>
 <CAD=K2o8xFgYBHMim-KqMysV+Tec9LEUbo6jfD6R-GOAU8N8K4w@mail.gmail.com>
 <CAD=K2o8kWgTRqBBw1sRfO2fopqQOLfdeX61h=OFPMST=Wdo+KQ@mail.gmail.com>
 <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com>
 <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0219.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH9PR04MB004275:EE_
X-MS-Office365-Filtering-Correlation-Id: efa94829-cc83-476a-22a7-08df3b4e27cc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|376014|23010399003|1800799024|10070799003|10067099003|18002099003|22082099003|4143699003|11063799006|261026121527099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pCTo5DRqDDn7HQ1NfjpEYmdzv6NOEnP5YepOi65la4A3Sy5UKHuLWvsLHg44gz+t+YL7FLZwx3dBDdpIMezXYzxpj4yP5qYxRsPEaNCCbg3C7gZxLAaD7qPipoSOg6/NPV2f/VaBmv1smvtejfq8ATrvVWue4By7vEiKWZTeAhF5IVG7oICFx5FY7u4agDGZZ6qe2ZkkOAwBAT5A6MxHShunLi68nZNB/wtOfj0ZjodQ3ScCYBPGf7QDupT8kbvKNU45I62blbtpo5RE5WDAYG6yIIjBdt/YAIV3zP0P59Ub8Lf6L81Xk8ZixrKei/iyHkppFb6L8lqCy/OEE/RMc3lu3NdD/GfTU9MxJMuPrNjd2BCGTe7xq/rfuYTVPU9VSgGd9SXiJE7ICQ2uYdkbCM7LS7xrItDNylQ1UDj+sx31Q1w05jOgSwcuCsIbSFbq4dP56tq4wQGMhRC1fvwXvpYljMZ8nopmLyN/eeXGc5ZfOGndL1EmTtr/UE57NbnlBj4vptuHSRKlyCInTylRh4UGd0/uI4mrcvZWG8selffSLRhzYq67X2JmscRu+Fd6plJnxZJIYlPOpB/sBiAd5qpiY6XiTQdXMJVOjBH750AI+co+YAV6ZWvVZPT8XyUeXg4jKO08v3uyebeiY8IURtKbRqIBCkHqyOEjC1oyr9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(376014)(23010399003)(1800799024)(10070799003)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006)(261026121527099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U29ENEg4SjlQV3lDZ2FRZmMzL0tOd3QrL0xmSDVOdFpSeDlrMWUwR3ZVSFpS?=
 =?utf-8?B?Q3V4bTRLTUlBdHFqb3pPM1pjMnlXSVh3cmVKY1kwNktQWkVvUFZkQlNUbWlu?=
 =?utf-8?B?TU9hdEdsSkZ1VFBqVlVCSTBsQVh2MU5UbG5MY2Q5bDV6MzU2Y3N5blFqQ2N2?=
 =?utf-8?B?cC9wUGRxbzNnWVlRYUVXWlBhRG9uK0s4M1R6b1czY3FmZjhUckxCQTNjZHhT?=
 =?utf-8?B?OUtpUUdQZEQxTjM4WHR6TzhISTR4OWk2QXhDUnZ5VUpxVU9oOGsyK2dSNUJC?=
 =?utf-8?B?N29EZTFLSmVlTExDeFBUNnRVTE1BNnQ4WE5mUGMzMHdNQ2hzYWt6bmdrOGg2?=
 =?utf-8?B?ZnRvQUUvbEJPMTk0L09LRFhiUWh0dVc3dmVMWi9SV3VEVGt0dlFSdTEreDhv?=
 =?utf-8?B?SWx6YStoT2pRU1BjaTJqUVRRMS9zQ2lnV1hBRDBYV3hPOVlZQVFCOU9ER29O?=
 =?utf-8?B?R1pGa05lUSt6amNIaFQvcTB1QlJ1SmdyN3E0K2R0dXFEQ1RSS1oyVmhKSy9V?=
 =?utf-8?B?dUtNTmxkRW5md0dLRGhBRzdMeFBHR01uUkx6TEE5czBCUlJOQnRYOVRKeGlR?=
 =?utf-8?B?VEVTUHQwSitnRzFMaVVMb2RzMHBtMHFQRWRIUmYrTGhVdWVwNk5IL25WbXdi?=
 =?utf-8?B?Q3d2Z001dEJtMGNrNFAreU5rZy8vaWRweGNNdFFlcTBqeHdUMXhzN3lFVkgz?=
 =?utf-8?B?d21JczZoUWg4Q0l0OTRreFNSRGNBZ2JNdjVqVU1aNDczRjg4RzFpN1Z2cks5?=
 =?utf-8?B?Ry9CM0QvU0cvNFZIN3BhUXpsQTdlcVJLT0RNejh2TlNyQ0lWL1MzUG0wYlB0?=
 =?utf-8?B?eFEzd09DbExaL1NXVzNIZkJmSXgzdThmYk5qdzFrallqdXFLcUxJb3B3cFdt?=
 =?utf-8?B?QUd3emtPbHVrMEh2ZGEwdE9maklzSTZEM1FQbjAyQnZLV1ZJS0NaOXJISzRz?=
 =?utf-8?B?Vml5eW1SMXBSc0F0eVllaWh1QWtNQUlaczFoWEx4cjVHWHQrL0RaMm56T2NY?=
 =?utf-8?B?QnBvdzBJOU81RWh6WWRNbklLZnZiTnNPUzc1dEpxUDMzWEJmL1Btb216WS8y?=
 =?utf-8?B?YnN5dXNXM3BRc21OYVI1eXBKRFphS0xxYTBIOVI2ZlRsalJFZlozbjB6RjFW?=
 =?utf-8?B?aGZQVmFlTmxQRHo2bmtYZ1czMTdMZGxsYndncEcyOHNYOUxjSS9LUE5jeHFB?=
 =?utf-8?B?ZmJ0ckhuY0wzak0rOXR4TFpUNExyZWhaVXBqQkkvajJJcHp2UTZreEJMVWla?=
 =?utf-8?B?SGFSZTNuS1hJc0I3S29naCtnR2FSWDZSbURYWktnVTR0UnZOQU1QQWJBaHJJ?=
 =?utf-8?B?U2ZDSlpyNmJnMHBSZHZseE5oMVR3enBKNVJPSVl5a1JEQlFjcTAyYWJKU1Qr?=
 =?utf-8?B?UHlneGtsanNZdW91emZWcTNuOEJ4bk91b0hRUTI2ckdyYnYrTkVWUDhFcnlP?=
 =?utf-8?B?T0swZlgveFNXU1lUNnkxWm9zeTU1K1dkQ05odDYvU1lCYktubGw3bjVZQzFx?=
 =?utf-8?B?WGZQWjk4WTJSNXZqWC9neWhCWHNFN09mRU96cU9WSmI5aEhOTWdvQVlMdjlL?=
 =?utf-8?B?bEZ6WUJOVTRVdzlmQ2F2VDNLallhcGVkSklqWkNOd2tHcml5SGNqbHBPTmJN?=
 =?utf-8?B?TVJMVDdybnhncHFCVFl1ejU4Um1oN2VnSGg5S3Y2VlFoVFQ5WU0zR3l2R1dD?=
 =?utf-8?B?TFdaV2pKeHU0eXViZUFVNnBBMGlwRElTeWtwem56VWRaU24ydmpac0dONkdF?=
 =?utf-8?B?aVBRM3hTMTVFY3pWc1h5alkraWtsSHJ0NGNvVmNSM3J6aURnRWMxVDA0d1Vk?=
 =?utf-8?B?ZUFPN3U5QUR6cmlGajlrZ0UybkFMYktwaUdiQUw2R1BMb3p1NTE1dnRreXV4?=
 =?utf-8?B?WUhYR1FEQ2RocFlLaGJjdHNmcFpDRVFzSzRlbE1JUTlkTU0ybTVFTjdwYmxa?=
 =?utf-8?B?L3hFUGpKaTd2aEJ5UlJONFhkRTU5VjFjRktSN1FoaVZDNEZXWWtRdE4reTla?=
 =?utf-8?B?YkU2bldjU2pXYW0zMW5HRkJqQkZWS0Y1ZjBqdGxwSkRSVUVJV2l1Uk9XakV3?=
 =?utf-8?B?aWVmcHc4ZG9hKzJYZHgxdExhby9EajNGNFhJU2JLUEl1OGVwMjJubDIrV2Ir?=
 =?utf-8?B?UU16c3RlaTdGbVgxVkgwRlcwaGFxRmhXSVl2L2xmVEdyTU9lMzNVM29rZlFO?=
 =?utf-8?B?NDFQc1B6d2Ywd1hXdHdtUUc2ZXBObGhMbTJGaU9ldEhVUVlYdmkyYXN5U290?=
 =?utf-8?B?TlhvQUtOQ3pycDJ5WEpCYllXckRXVlliMmcrZEtwdW92NU02Szc3RmVzdG51?=
 =?utf-8?B?b3d0ZjRsRkVPN3E4Q3AvNklmc3NQTkp0L1JwUE5RSC9lY1pvclZUc25yalBW?=
 =?utf-8?Q?wCjCNdgsJkvgyTmI9jtn3NQ/p6RQZIqootisyA525FbCH?=
X-MS-Exchange-AntiSpam-MessageData-1: VvaWzA6M66iwdj1f/OI00HgIBcfedSMDIpo=
X-Exchange-RoutingPolicyChecked:
	eSdu8tGkooRoqWKjbaXbrQjquHhDlakOU7koCcsX4M10a6CTwcnB8xcJw0v6sBCclYYCyPeG02DN/lfnRQN60T/1ML+VJTGltHiWJrUzUzv1QJgCzQpYy6XYVy6gWvfDE6cFetDTTRKLEapAEe6qgbPeFH6uDUaRaNtrjUlmUmZ6DiSiSXDzqLPNvHlLqQM+DE7igROf5cVrJcbaVSpwlrRDoiz23PLG1CHOH89cEb5R2UUaULLlzCh4FWKk5Zvq3eFm2NexQoOE/ILJ65B4cJSCVh2/tpu9M4IbkZnVEvPjR+JfruemV9zHod6IvH0m5G3NNuU8I9KqKpfP/Xui9w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4ln8BvTfTLKEayVs9iVSmOynXekhES5CZR5Holy6hi2jygSldSkJOvLFMdB9uAHcRoo1neKOkKj/meoRb+HuutWsOXzBO7NF9gmaJMZ50bFQsU1UeTNjS1JsiDEmVPNXuSDZcJ7CWlz94o1mTZHGKHxPqR75mOAXGaJgWg8mha7rdQgGiqG4Sp0tN++9Lm3n2ryvMcfOBvz8wu6IGgMnMZZTutpqcsbWuEOLTmlIgyxQPJmZzTp2NgWwc0n4ge9ewNNZup+6bSJdBF68KvvPgag0OcseQSv6Xo/LY8A5dt4GdIMlnIl0zBBdJhDYDgQlYOYY6ludMiSvZIELvwGCocqVWr2o8imZBHZietHo2BbpIKFjewxJ84wysyvFplKOTRen51jLvrAAAoIhExGJ7TSWVJuYcKH3XIj9khI4WsIrJl/vgl4i/jGYoIIBz5txTiDbYN1JiLD3t9Xv3BLMHOJbIliW11QXGo8EpEBRJDAV07v1ieLOwwWYy7PhuuwNB7by4VfMMc0HE+u/oSUtESmdeZQfo4D70XBpUzS1N7HMaRMIxJYBQ3/nrFgmxGqUj+21NhR3IlJ1LjP/zD7/NjdXZqjkD9ggLoot+Rjs/YNE2JvE2Quboa+TczF5W2qQ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa94829-cc83-476a-22a7-08df3b4e27cc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 15:04:57.2198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hqmbdjYFZeDCAu7i6sO1QAN0h24DIvr3jLPn/ObZhrfTqCG6ZTSM7oqxAc+vFqqEbK9BojxrAwHSOjDuB4n6syzBuaO8OjMy3qdYP4RpOJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR04MB004275

On 11/5/26 2:48 PM, Jochen Philipp wrote:
> Hi Johannes,
>
> small update: my distro has meanwhile shipped a new kernel,
> I'm now running 7.3.1-202.nobara.fc44.x86_64 .
>
> I haven't tested with it yet, the fs is still mounted read-only
> via fstab. Should I try a read-write mount with the new kernel,
> or do you want the on-disk state left untouched until you've
> looked at the zone report?

If it's ok for you please leave it untouched an send me the results of 
the zone report.


