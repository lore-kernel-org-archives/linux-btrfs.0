Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BD83CAE95;
	Fri,  3 Jul 2026 11:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079433; cv=fail; b=bBw2k3fiMoTi1vBpeAEbizPYU6fb2TPbAdApBbsOofkBmeWJmNRWuUAWWI1iRopPM8hMN7jhd9iFG+PRzuO6c+yqiQ3uuavGcEfO4PGkgptZqoBvJEkKCVEMmZiMcut+piA6sd3SIHGMK9WPMWAqXUy3CYlzLjzWlTFvCFGIT/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079433; c=relaxed/simple;
	bh=pDa/t3M87fnx030Z1BMz6zw1E6NFP0zGbPCNSIcurh4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZY2/PNHjiqzOHc/gVR+rO37fMq975wkf0tKXlKcq6SW+xFRPMWrnjD+kQjOEa+nVGIf3IstpCzwu8KNHQ4a6u++XVMA+ORWmSd99ZE80+CRGPoXpTBQfhgMyIcXAVfEJHYZ4YjfwSc8BRVG+Vo7WZsSRX/CwGdl6rOqYf+g8lEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RopXxNNG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=raI4TDfG; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RopXxNNG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="raI4TDfG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783079434; x=1814615434;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pDa/t3M87fnx030Z1BMz6zw1E6NFP0zGbPCNSIcurh4=;
  b=RopXxNNG8XcWOoCWdwnrxFYdYRCC0ODxbHfoFAjBYIDDfSNv3TRy9TZj
   tUwoEUajAkDEvAlIxsTa00FiHvzKm1YSSjAIaSlrPGYD9nZYiJPjvcQ/o
   MaHf/EY5njFwhRdvbli3hsqUsamVr+/Y+r1IAHJAVTgX++0wK5on0+Qva
   jra81FrDVaJkOmqGpAuFd1MQ2K5rpedWsO1FjiIBW7tGxDsD3g+8KvNw6
   W11qI/ZWQr0zCrcXirv6e2tV6Hb+OweUpxJG8fKQoNQHiWr2fix+rjWUX
   7fIYTkgcjCEyngH6/sNtWLo62gd5Apbd7Ob2DNiHBLCD86eV/n4dphWUK
   Q==;
X-CSE-ConnectionGUID: EWn7xD0dSqmBxhRyffOeFw==
X-CSE-MsgGUID: 1bpLA6VrTh2/yZjREb/gYw==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="146164501"
Received: from mail-centralusazon11011024.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.24])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jul 2026 19:50:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wUrOpenK7d+K7ZiKMsAMybf6Pw0Xw77mDuFYdr5TXoKRFt3RTZhzIS41sCKeKS3fyZAqrMhXmt1QffPvvCvQMvac8p0MWAtP+8ct6rmE+5A2w+UmsFsJQ86LA20V1pwzud7Or7tO+aevsV9sBzvImjDW2unUfVZQDkghR3Yz2SmiNTnxiLauZD4NsvYjvHj9ucZq0pEwRXm0jAF7ciQAeumejGpRfhZaKMd2pfJY344B9cswuKseIPyaxPMb0ccckT21UjTsdFCfQv+/Enmwfbsss4d/vx5ofok1f0jduBQXKoYCV6XEprTzAUddTBfA8aWuDOChqCl0kvUwOC+MNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcfJKy2eN167zRLSjJJEPhnVn2/bsIpszxSmCZh7n5w=;
 b=UYJ0joAKQZ9Ttz2dqLQn5MxT3jdHnNHIRmPzxMSr7HaKGmElYJkKu3XonRRwh0YrGEwdN0hhrcf+hIRbsNv6+j34bKPyZyUcsJk10qlGG2T3RYgq/hNQpBqYjFiZ3Q0s8eRgtodqlU6TfzPAFH5kpu6XwXo9m4LbS5/sy4NJV2fhuMYq7vVq3GYQholVRFHyB4MkTYIQr+Av6yWtkPB8lBW/e3xswXxySP4JzxJLKN99xhYk2mB+Mv+IrYPc2TGaWUlVPP7ZvMElLhuSi4oai+d58s6AWShmguvRR66oRrRswjME/PU1uYqnEoyWi54qiBPjdikvi6Dv9B/tXyKhBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcfJKy2eN167zRLSjJJEPhnVn2/bsIpszxSmCZh7n5w=;
 b=raI4TDfGVglv2Vvi1hcKneoTeksSSEMyuqfgm8lVxiI0BVo3BQSDG+BUvCBLTUg6mgM6aU0OcMq+0GyXsb+vKfYbdFYTYPbNjmmULoJ6pvWvJXlCIU/KrBmylYvQWA+81tIV+fmTi8yJEtAAYmsddn6leD7en17EyWA68bmWyuo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH7PR04MB9545.namprd04.prod.outlook.com (2603:10b6:610:24d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 11:50:29 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 11:50:28 +0000
Message-ID: <626b7b48-f49c-470a-84cb-459c7c7f124d@wdc.com>
Date: Fri, 3 Jul 2026 13:50:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: reset active_meta_bg on zone finish
To: =?UTF-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20260703084559.136605-1-johannes.thumshirn@wdc.com>
 <9c8421f2-7f17-430a-9f87-26fab7b1d73d@wdc.com> <87jyrc70tt.fsf@>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <87jyrc70tt.fsf@>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH7PR04MB9545:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d0bb5ed-51fd-4c8a-89ff-08ded8f94748
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|19092799006|376014|56012099006|4143699003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	yN12N3Fe99DwPzgP8eBJtRxgEANUiYtMpiKmV1wMnN+fNohNEDAzHz7vXHN8j7ioB2p8zJ9okBNg7T207Qn5ZKbiH3ay1W57GA/+V4u5ds6BcKLZCg1pWbOw3De/RobCoELFRHsZHnQNGyecT3YA1ivgksExOGTWt9phb0Uucc0fxUnUiFiLUBRGkUQUD1Yd5zEfc4xmtHG9RxRMQH7QLFlL+RmlCu1Zkpp3IGWKRVvuRBhP9/+vd1iaS/9ls8aRiujnvZJ+iWKZ/I8mC5q8uQKof3qpNKSlxfg7QYvsjUbhCfrosZ5NIJPLkChoxsaOcXFqfmOpBx1apspq+H0BIl1eE1OL8CPe/KiK+7hNR8+tBdX/ihZwFl/2FFf80kTKDgume1WTjtt6UQ5jCnu0RXrNvZjjeENVWvbeO3qU4d+LVeKwrS08Y5I26wCEPL8uAyPVMI7ikn8hzAkHpLXC1R/KhjZD7c7vIiCkDKCEkKIF4gx4pm6Kzuc0VGzkctsL8eJFlvUrGk5gTt3WyvKKSNH0ntN+nvpmfN8KA6MmwWUvqs1wK8gi+dm0LXdhT4ggAy60ImuDDumOeEnogXceqKdwprNDl+YYvT9/W1HYPaY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(19092799006)(376014)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnRzeFhEWFBPekVFREZMU0hzcDA3VWZ0R1FQWkFyRHFvSkNpKzExNkxmZzZ6?=
 =?utf-8?B?VXhxOXhucDVQcXZaNU5UVlRTTWlJYjAxdU9xSmc4cmw0akE5VjZMeXRnZGZP?=
 =?utf-8?B?Wk1ORmFCRXZVSnQvcmxRTExpdlJSMDlsSWFEQ0xSOHZ2THNnbkJISzMxYmhV?=
 =?utf-8?B?c0tuLzJQYlRxTFBYWVk5eVcwazNFWFpuWERWejV0dVUvN3NKMk1kTEFsd0JX?=
 =?utf-8?B?a2lNalpSZ1VjTHh1Qm5VZWdKYzhYaUVCTWo4OWxoVmhSRXZjY0c5UHBEc1F1?=
 =?utf-8?B?TmVzaUxWTXJUMEtTWEs0TlQ3bUJ5TndDL29ER0pMOHNnZ0JoVVlFQlBPQ2xZ?=
 =?utf-8?B?Y3kzb21nZ1JQTXhYcFQ5VitZd0c5YTFhVEtTV2YwWUYrVHR5UkJYWVhPYXVS?=
 =?utf-8?B?aGNTUmFla2RZOXQ0UFkyUzQyOVpxTFllcnkwN1l4U2tlTHo4Vk4vL0cxVjE4?=
 =?utf-8?B?b2VuWG1hMUdibTFHK0txQXBEOU5hWnB3aVYzT1ZCMVJsK0ljL0xWNENFQ2Rw?=
 =?utf-8?B?ZHk2OW1uVXJiZzF5YzN3YklxNW9BOURudUtxeXVRRUliSXI3Q1lnbTRFRG1N?=
 =?utf-8?B?cVFFYnNmeHpwRzdOSlN3RjFnaitqdExoSlJEaDRhQjFTVXU0Z21qZ0I5bmxY?=
 =?utf-8?B?ZURNUzJFSmtDblpPZ1FBc3BpZGFKNkpET2d0dGZXVGZaVnI0SU41SVFyQ3dJ?=
 =?utf-8?B?Nkp3M21scEFlR1RiVW1vWGFpNDBnQUh5bTdEVFZObGVsVVplcWlLTWQzQnhr?=
 =?utf-8?B?Q0R2eG5HT2dHOFFaZm9raVhCVkFQdHBTSEpRcVRUNngvSGNqa0RpWUlqeGhl?=
 =?utf-8?B?OHd2dGtGV3gyaFFXT0x0eEJRVEJVYW1kNFJISENOcVBrdDMzOGRsbmpGNS96?=
 =?utf-8?B?ZFd0dDhoM05PTUdsZDNjV3JXaWorTDdaN3BHcmdXcS9GRkkwRjZQUzZlaGJP?=
 =?utf-8?B?L1Noc3AvUkIveDJua3ZJVzhvU2ZKNFRpRHZ0aUpPaEwzM2NhTk9zYVlSWmJq?=
 =?utf-8?B?ajRFaExEVXBrcFk2TDhmTk14N05vY1F1NEY5NXVRSkJaeURTN2pncVpLenVk?=
 =?utf-8?B?Y0ZLbzFlV1Y0WDlabmFBVSszNCtEeHZPalQ3SHlsdFA0Z090MEhMR0p3c2RY?=
 =?utf-8?B?d043L3g1L1RPKzNLbVlrMnlWdXhPSmROaFBpZWVsNDZNeTk3dXIxTjhDWEd6?=
 =?utf-8?B?VERRNlIremJjY1hUV3daOUduT2lkMTdQanUxMVV3elFrbUNPZVdBdHowaTAx?=
 =?utf-8?B?QzdqZzRhdnIvcFB0WG15REI0aCtZVjNZcTNjZmM3ZUVaMXNGQjZ4cGJ2OUxX?=
 =?utf-8?B?dUwwLzAxaThNMWhSMUM3OGx5bmZaR1lVNERkeGJ3eDJTV2ovUjlXVmpENmNl?=
 =?utf-8?B?TWI3SlBoNW9oQzRsTUNDN2NnYklTQ1ZpUFU5cGpid3M1UXpTd1BIQ2dnTWJH?=
 =?utf-8?B?MjFTTjJqallCK0h4YUN4WkwzV2N3RFBvTEdQbm90eUlyaUdNZkFPUnhvcmpr?=
 =?utf-8?B?UXVQLzRBNndsQ05FSTJYbUpxbWFJYzNNMmw3VDIrNVpBMTlBOGRTODArMlJl?=
 =?utf-8?B?R0RSeExydDRubFd6MVBvWHZNS0VoR0FaODU0RXArMy9XVnJqYjM4T0VEd1pO?=
 =?utf-8?B?Sk5raCt1N0VKYzRlQU1haVVPWjlKK0xiYnZBNUlrNVgxUEVXbHp1WHVxY3pu?=
 =?utf-8?B?ZjVQSlJUVzdqd3E0TStOak5kKyszUWg1RjlYSmQzZ00yRGVIdlJ4eEd4RW1n?=
 =?utf-8?B?QnhuVXV4VEMvNHd4SUsybkhUeTdZUFJTdUQ2RFoyNnpwK3ZVU0xuR0FqTzhI?=
 =?utf-8?B?MlR4UFU0UXpOSVdrN1U4VWIwZHdubUZRTWh4QlN3QWZVeDdLdE9VYk1aNWpU?=
 =?utf-8?B?S2ZDRXR3REMyZHY5R25BVEQxZzl5NjREQkNCMVIvRXZyUk9CekJMZTRvamNl?=
 =?utf-8?B?Ulc2aHhFbkhocUV6TTV2MEZlMmJkVXpjbDdXbndmbnFNMngwTFBLb1BTcGJi?=
 =?utf-8?B?OWxUZGpjN0MyclFDVXlZa2pwMzU0TmlhYm9HcnNSWTdZRWtGMXRYVy8zR3pN?=
 =?utf-8?B?VW9OTDdxeXBUdXdSdG5WSWN4cVBucEtvZzd1WENMODRFeXlmay9PNWUzMjYx?=
 =?utf-8?B?Umw3QUVNYTZiRjEwU3FlYUM3dkJBN0xYNFJKQTlNbVBrQzhBRXpYVXRXRk0y?=
 =?utf-8?B?K1E4eG01NTUvRHhoZkNkZWx2R2NQSjBXRmg3NWF3YTJqWVhkVjU1TTJOTXdp?=
 =?utf-8?B?TVBKUCt6U0hTWW1sekJHSkdnTU04NjNSaTVEL09EVmErTzNBMUZQenNMQ1ow?=
 =?utf-8?B?SFhFbHR0clJyYTRxREQyU0hwRTVVSjdUc2E3dFVNS21COFpxKzNycDRLZjJO?=
 =?utf-8?Q?eQRmVxSfDRJLEkOQ=3D?=
X-Exchange-RoutingPolicyChecked:
	M2PX56ACNBeVmnOyrTP4fABj++FHwRVvyzfMMVDA3y4KjDlCBBsdYQkX35j3bua8yDmwwyGMrg/uBCUSVrLcq9TEA564U21rKLvRtfvXLEL1E4KHDUuDnUdoTqakFy2pB/HBb/2SlASHZJqaA8WvCQB2QU8Njel9+QP1UAVnnbJPpz7WWIPF2pZxwmFr48OK2HrA6bhd9OFDtJkp4Qa/PH0cZ1B0OeEJqZg2E399nBScawSz+IGKXaZC+bDG5DkQwD5eQUC9RDOeyBZ0IP8wFnxspQ/wh8e0H0Ur6u9ZQX+M+641WAQDeSPK0aNWecNnJjViF468G9KE8mCURp2mnQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iE2i0Y9LVGmhHc+nuVa+c1PVqoSnhphzrZiBd+CV5MdD0TIM1ZfKkGwUVX4u5SLrhV02guveynszpEiwU4EKCtNejSnhgLynrcf3R71yI/DPY8cQ5dV5iPgDhT74KJG/t1LChcpZ/pMnIqrHAh5FdO3wSqU7lfE6dqVcjP8IR1SEiC02O8FO61xtQm++helLJUMO5JrYZbwwlNg5HpDUBpowvhJjyUUgpYN6/OdH/PgVep6n38v9YUDY3wM+5h+bIPeafXAyEeo0kCVjrPsgrE/hlvJ1Ma/t7peGWLEc8UgYsiHJUBCgptfHgtrYCtbrwVwruUAEUcNZ3weDXhJQ2kpT3ss2lOE7JmsOWidWFdDBodvJRsw3aZieOl/IaZtQyhlHNq+i2uHEA+pO/Q65Wd+Rvsyvb/VlupFXAkVmu4vh78tjv01Su66IpD86AZB/R0JIdBCXlQWAZ/qu8eVOjLZCnxQL4VNFLOElCq7LR0dRgNaoIz+RGdp/mozFBjEt9DFVSCzljfrFqyH0Ze9mMtTkcV6Y9M/9QzhNathyKWcTCsjqzx38s1dgXKnLlTZViThpp9HeTVbHlR2Q4vc3QVX0hde0gzCyIuK4xo5azNTs0vFheG4gwOzWZUr9wRFU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0bb5ed-51fd-4c8a-89ff-08ded8f94748
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 11:50:28.8681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QVL7g2d2oZt8kGeSryxWSlsTd6vnM0TMDErdKszFgZPMcmhQQLr8krcdWSsZLK/R2tl5kKYAtZ28kQj+pP2TSqnf+iF6agXof1c0bOwxx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH7PR04MB9545

On 7/3/26 1:46 PM, Miquel Sabaté Solà wrote:
> Johannes Thumshirn @ 2026-07-03 12:01 +02:
>
>> On 7/3/26 10:45 AM, Johannes Thumshirn wrote:
>>> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE and removes the
>>> block group from zone_active_bgs, but only the path in
>>> check_bg_is_active() resets fs_info->active_meta_bg / active_system_bg.
>>> Any other finish path leaves active_meta_bg / active_system_bg pointing
>>> at an inactive, fully written block group.
>>>
>>> Reset the corresponding active_{meta,system}_bg pointer in do_zone_finish()
>>> so it can never go stale.
>>>
>>> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>> ---
>>>    fs/btrfs/zoned.c | 15 +++++++++++++++
>>>    1 file changed, 15 insertions(+)
>>>
>>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>>> index 44a13ed6b8b2..c8c850de1702 100644
>>> --- a/fs/btrfs/zoned.c
>>> +++ b/fs/btrfs/zoned.c
>>> @@ -2539,6 +2539,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
>>>    	const bool is_metadata = (block_group->flags &
>>>    			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
>>>    	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
>>> +	struct btrfs_block_group **active_bg = NULL;
>>>    	int ret = 0;
>>>    	int i;
>>>    @@ -2636,6 +2637,20 @@ static int do_zone_finish(struct btrfs_block_group
>>> *block_group, bool fully_writ
>>>    	/* For active_bg_list */
>>>    	btrfs_put_block_group(block_group);
>>>    +	if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)
>>> +		active_bg = &fs_info->active_system_bg;
>>> +	else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA)
>>> +		active_bg = &fs_info->active_meta_bg;
>>> +
>>> +	if (active_bg) {
>>> +		btrfs_zoned_meta_io_lock(fs_info);
>>> +		if (*active_bg == block_group) {
>>> +			btrfs_put_block_group(block_group);
>>> +			*active_bg = NULL;
>>> +		}
>>> +		btrfs_zoned_meta_io_unlock(fs_info);
>>> +	}
>>> +
>>>    	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
>>>      	return 0;
>> I think Sashiko has a point here:
>>
>> https://sashiko.dev/#/patchset/20260703084559.136605-1-johannes.thumshirn%40wdc.com
>>
>> check_bg_is_active() should take a reference before calling into
>> do_zone_finish() or actually clearing fs_info->active_{meta,system}_bg can even
>> be done in check_bg_is_active() after calling do_zone_finish().
>>
>> That'll then also eliminate Miquel's concerns.
> I'd maybe take the latter to avoid adding more complexity to an already
> complex do_zone_finish(). Besides, I see that do_zone_finish() is
> already called in many other places throughout btrfs/zoned.c, so I
> wonder if having the changes in do_zone_finish() would also "spill" over
> there.

Yep that's what I did for v2. But I didn't want to send it out too 
quickly, to give other possible reviewers a chance to eventually spot 
another bug before.

