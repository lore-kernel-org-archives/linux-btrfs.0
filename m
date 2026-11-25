Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795620156;
	b=gflLLm/fAIf/FpNHahUq3OXypAMFzHBNIqgPlEFi8LEsxNEjU/e8PNLdt58avmIXb24a
	 CA3V+c0Cup21ekIZfT2iM15JwxgPdCpFU+/ic1CZPlVwIILqAT62IlA5WdqKxhgtBqZ7+
	 qTGxy5404M50t5uC58XZX0agRyRqVVEqI24N6aevn1ycnfQ85zzWLS6IPDMfRCLvaPehu
	 zMdRTJvO0OSWn7DdTgDu0jEaGBdlh/lj14C8m3bRjeBjxY2Q+Emxvyo5OXxQPcepe7ejN
	 TaDh3HTkyG9RSUzcdjVwykZfeBlbocVm8Lw/y1qjeXiszbXXwVYzzvbAghHvBbH8f3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620156;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=GO/yggTCjBir18AxBTSsPGw6vS5VNoua5QiamPluytI=;
	b=J792wXKE3pyLRYiVS5B1aU9Oeab/1bW4OLVm5SzMN/v+pfXmgWviZHIvHrhCgorofxbt
	 ey2gftVImqd8p9t1aERHo2q4sQBuVd3HKcXMcTo9StqOhWeKaVpzYlQdk8v60n5ZXnsuy
	 LBiGsRwbHPKrOY0eAIBlVatZuZyIoZKED3nKVJjyw1Cumr1sYDTCnqvhZOBeG0kphpqxV
	 OiAhJjuBF0YeciqOzZrS2TIFYxUEISF+lOSAig60fAXie8aibUxI0/Hi9cX57qFOC2wCr
	 QkQurbdunN60p8ucMeoOxRQlMquYHKz5BqjczR+Jx6Fgbnz9oTXRaXIKs7ef8n9RcTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="QjlFQ/dq";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sjDghFfs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E338606A338;
	Wed, 25 Nov 2026 15:22:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E338606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QjlFQ/dq;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sjDghFfs
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795620156; x=1827156156;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GO/yggTCjBir18AxBTSsPGw6vS5VNoua5QiamPluytI=;
  b=QjlFQ/dqiTV6u9t3ZZal2qyEj80U6J3c0N7Ey5ky0xe/rAumKYxgZM3a
   iynb8bxfggDL2+Tcf2KkHIy+1u3ZlSsiKj/+SZVb8oZCTcQPbk2m77zHz
   vIqWlaJeCHKGbxHMP26xA/YxB5UCeWagdnVS4JO/Y5w91+kRzJ7TdmMLj
   mWVvjRozqh7Ua2MKPm4NShwYls4yYw8sceApyrq8aEN3fFEJNDbBuHXvA
   pREDa+AUw6qmz+ngz6qNaym946Q64U/NldeRvDQCScdfqg77wVhE3bvVI
   o3VoAcQ9Os5uBE2pDMhpPRc98gLYlcm+D+StTlp0nFOKbWSdXq2Qo/6Ed
   Q==;
X-CSE-ConnectionGUID: 6Gf8xko7TwyArJ2FFZowcA==
X-CSE-MsgGUID: r5o0y51sQAC2CmkkEXnWOw==
X-IronPort-AV: E=Sophos;i="6.27,233,1786982400"; 
   d="scan'208";a="157508131"
Received: from mail-westusazon11012028.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.28])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 23:22:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tyuCqyiFPfmBljmjapWi2NpZLh2+so5Kwwv2Wy5RBSVTpqaauKh5d2xYYuI7tGlEKBrHA9HiTHpPaUbEuVkk9RhTxhBXWtxq+zBO/evDJQcqTozZ9A4ihaMzfluXqTAXVcxBRsthnuB5Aui5M/9sP/VNJPxvgC1iJCmTH6Vp4VQrY+RyUicWtGL+fGqckzYdBTG5zlsaqCG98tBcYR2KqMbzjdJXMl9zWP228MtXzUJhchYqF9ieaEVqSgJ5eA5OjsvbVFMNQlhPNw/tVU4xXGzl2PD60S5Ri8ETGMaus3ytPrQuh6KSesSMyElnWdiTbtTyHaB4mfToxmdLiWEZLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GO/yggTCjBir18AxBTSsPGw6vS5VNoua5QiamPluytI=;
 b=zKhl9iWJ6S9Cd5RV75Vzp1IPyQBXUyI3fhSBIwfOZEO6yozFpZf+TeydUMDE6ZwE+543CtCuJafdoUa2/anc4BmmqmYM/jExr5OoFzlp++XjGvUVcjUy9bm+MM1JhigvF9ffIZM31dC/IpHFTX9q3wMvZEFqpcktfT0KsZqIGIW19ZcXvOKCCm3mlVxlw+siHblU93r4/y3wC6jAu23qQATvVQrzb6UaVelIO8Ih6aa33cezmTkLyO+xrVKV1mX6vR32fTG4KL9HWh1gqLaqViGjaxheknMrb9VjerFETOdP5qOq7QCfYF943LhOZsVtJnSZiHuzCL/BK0bexwe+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GO/yggTCjBir18AxBTSsPGw6vS5VNoua5QiamPluytI=;
 b=sjDghFfs4In8eoKdTKa680aAEoSqf97t3NQUGJW8UA7qWQcDKyoQPyR0PC1X8l8wOlqxpvJGo4EFv9zWQetYX5tzgjjdkzS9phJKMikgodAik6piDuKezyQHZGo1fZqpvZRyITfi7/rlYC37tcfyft/xvGGtA0ppXnjRjuD32D8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB7908.namprd04.prod.outlook.com (2603:10b6:610:f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Wed, 25 Nov
 2026 15:21:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 15:21:58 +0000
Message-ID: <54577fb4-7dba-45cf-a723-8c703d664f9b@wdc.com>
Date: Wed, 25 Nov 2026 16:21:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix use-after-free in the raid stripe tree commit
 root search
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
 linux-kernel@vger.kernel.org
References: <20261123182354.2091665-1-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261123182354.2091665-1-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::11) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b98965f-c8d6-4a96-6492-08df4b07d89a
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
 JIF7ZYdCX7C9Aqq51uYO32x/UAkgtQCcT47+AU5uGKlIKuBtGysF9q7fpEgEra1bLUPI0IvSUT4lKhx0kjTpJyunMFxGWs8/FxAtyjvSlKfSmkI7Gdw8YrjQAmNJxwsZyoRRYcSKkqntTNKkR772vfkfEOUGByRG5zf9y1iWd0JIfSA7LfULMc4aDsFf7lINiyUv8MCpjopGq4ya1Ep0AG358dONkYNVlh26aFOQ5EQGXKUZxP/1bJJM/ZLQ7ww/fH7DywNQ4WI7DZkJMj7jvCu7RnULOnpJD68uoFvxgTvzKwJRUntV7CTd/ahjndnWZuo1i/gpxBhpfrPFnJIhkI5IoCTSlFR3Mx5ITfYZORIr+12mCjI1rtNOYUvJ5aMTvq+ly01l8qDQ72/mGBeRBY2DytjgMwNr26ilWa06W84hNET7A7IDg1gVeaMP/yG5oz1xV/MmMWcuv1144ZhBtakYu0r7u3I3oS3JWJJ6yjJTbyNBSr3M/5kMQvTRHNUnI6GFlCvJYQVqTbnsgWdRrGxUZbYWpb2AfCx5hPIrXnvq6R3F5riSOj8X+CU8K/p0/5RnIvWbimuCvVoKd8xxaQaqn3OZ6JU/609/+58jjj52Pef486QswS0r/F7kLoJKdECtO3U7HxbVUWmYCWvnZcQHt66sM6p0L98zkk3Rfb4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cGV4aTBYbUJlcUN3bUs1YUlURjFDVUk4d1lNazN0MWZyKzMyb1dGWUdDT2lu?=
 =?utf-8?B?QXhhOW5kdWZaZnhVaXhyTmFrZm15dHRuYW1HNHg0ZEhDSVhPNE9OOW9KL1hL?=
 =?utf-8?B?Z08wOU5YRk1FTXo2L1I3azY5dkkrQXNRekhpbnhMMVRvRDVFbE16ckVMOStP?=
 =?utf-8?B?OWo5TlBhOFpWY1JnV3JpN1VUTzcrbkxmQjNGWnV4cXNhZTJzN1gvVTZFWU84?=
 =?utf-8?B?cGpjQm5qYjJ6cnlZSGhHb0wyaXRZdTc2YWV3ZG5RM2xvcjNjNlVKOXFtL0kz?=
 =?utf-8?B?dWFzWkljWklFRG01Y0pxQ1BYdHdHeGNHZGZISHlXNktaY214QmJVcDl2RzRq?=
 =?utf-8?B?OERncUZYMWtia2dFMlpHNHoyU3Vwb21CYkxGeFdWK3A4VUN5L1dlenRoMHhr?=
 =?utf-8?B?dHYzTEs5WDZPNUNkNmthZ2c1dHJISmVhY2pQckl4WDhHMFZPbDRLY2JQNlUy?=
 =?utf-8?B?M1RHYXUxUnZEL3N6OVdsV3FlNVRmUHo2WDlaazFKS3BReSttdXNqT2RkdDkx?=
 =?utf-8?B?aTRjR3RMSnNUMjUzdjFRbnlMSXhnOXZSRlZoRFFZK24xZk96aDFYNFlwd1Vu?=
 =?utf-8?B?T0w4aWxIYjlRMnUvczlhMEFzVGlCVi9TdW01OWVKcGZpbFBtL0lkeG5wSFk4?=
 =?utf-8?B?WXV3L0ZPQTlyY2lhTjI2L3lMVjRMNTdEWFA5UlA2Y3Q1V0JlVnBKajNQUkND?=
 =?utf-8?B?cUs2SlJtTmtCUWxhUVNlQStqTXRqMjZubGlyTzZNSEVLU3FzQXN0OWRKdlk3?=
 =?utf-8?B?SWgwY1NzNmI2TVZmbU5lalRjTzJsVU1mUnYvSytwM1VNY0wyaW1aT0JWUzhX?=
 =?utf-8?B?N09Bd2l2eit3WXBSRG1FbkhyOFFrSmhFUjVqOHA0bUNLL0JLNDNRMFpTczYv?=
 =?utf-8?B?anZDUFI5NEpSbktoMm41NjlKZkZ3RTdiRytzM0V3Ym4ycGZja1dkREFLWDdw?=
 =?utf-8?B?K3BEWVMvNDIvR2VrRGd6Vi9MaFZ6MktNRHVTQml1ZE1XVDV1RWdsbWQ4dkhs?=
 =?utf-8?B?VW5QR3dvVUhvRHpNWFNQeHNTZDhIZVVXOFRJa21jaVU3eFJsbTN1R1RtR1hW?=
 =?utf-8?B?ckd0c0FBRS96Qm5Eb2JCUzhpREoxMG9YTjFkU2JmSHQyajkzNjhsbjc4eXRS?=
 =?utf-8?B?czBZZCt3dTluRlh5L0U2RUttM0ErTzJTUCtGN1VOWVVLbUxGV3k1NGpyUDhi?=
 =?utf-8?B?dUR5VVJaRU95K1pJS0NybFFDVW1KQmpBeVR5dmcyNklvUzFkb0dHRVZTbnRX?=
 =?utf-8?B?aXdTckgxdEdDS0JSeWlpMlBqUDBvOWptVy9zSW5VbkRZTlAvajNKeXdBTDN5?=
 =?utf-8?B?cW8rQkY1N0tVYURQSS9IZmhDeHN0YjZBVmZ2U2NpendyclBHWWV2Y0p0c0Zp?=
 =?utf-8?B?TEY3cWU5SWhuTWxjYjJnOG4yVkE4UjI1MnllVHNhZWxMc05ycDE5WEw3Yytk?=
 =?utf-8?B?VnRXMzE0S2VhdVhtWjhaaVh6NTNJVU5KRVBrK2theHBsb1dzcnFQeXMzYm1J?=
 =?utf-8?B?Y2dpU1QyNTlBQW5ETG11TTBCcjZGK0dwelRKYmZ2dStDMldpUktOZkVVb2Jl?=
 =?utf-8?B?K1RuNEN2SkNlVURGeWFrSHc0VTc1bGQvcTBnWVNQOXd5QXlwZHF6dVdWTE00?=
 =?utf-8?B?RkJJNHFDL0w1RjF2a2svU25JQnE3em5OZ01hZERSK3JCUkpCWUR5WDdzMmNa?=
 =?utf-8?B?QnVISUQxalBZVjUzdmlxU05QaURWNlE4aEpNbmllQm9heGRmYldoMnFvUENE?=
 =?utf-8?B?bmJvWTBCeGpWTWNLWW01M25meGlKcTdhbFBIMnMxMExJWDI1eldWZVhxZGds?=
 =?utf-8?B?dDErZ1A3bUNPODBidnl6OWQydngvYXNUV2Y0Nm56RlJGZ0ZNVWVLQWJkcnhK?=
 =?utf-8?B?SFNkU2RiQXlDdTRsR2dPcEhSbkUwbGFScHhZaU1TS050cWZkZk8ydUFEeUJG?=
 =?utf-8?B?UC9qczROWVJpanJ2eVNsU0xySU1vZUlQOWkvQTh4VVNNRXo4NXZGdUlKWDg1?=
 =?utf-8?B?Q3phU0ZqbmttS3NXelpxdHpKZUd6b28xa0xQK2pjWW5pdXpWM2lPTklBN3hY?=
 =?utf-8?B?VEpReTROTHpOVHpvRFd0eHROZjRpU3dMbFh5NGxhYS94VjJDSTEwNXZZOGNQ?=
 =?utf-8?B?RXZlRnFmVllzcUdNNHd2b2ZhU1MrSkx1MVdTV1RobWtHZkxTRGdvbWY4eUt4?=
 =?utf-8?B?WkNIT0Z2TWtFeHZTckpIVzVkVHdieFkwdmFMd3UvR0tKbnJ1MWl2VXpIK2tj?=
 =?utf-8?B?ZkhZYlN5UmpkTllZTk1PRUY1Nlk3cE44cVppQ1BveEZsRkJHVE4xY093Wit2?=
 =?utf-8?B?cTFsRElwMFVib1VweUpBcmFoejVzaC8yM1JFSXZlNDZPbXNoK1VoZ1lLSXpL?=
 =?utf-8?Q?VCWGTEW2HNS6Ekpq+1Sojh0WaMb7T4asyJACV0sPOVBBw?=
X-MS-Exchange-AntiSpam-MessageData-1: mnmBtDaq/pOA15t8WPfDHiJsr87jFH2PEIk=
X-Exchange-RoutingPolicyChecked:
	kqj7VdI7Z6jMUOxVoLmf8wP1CtLJTKluGogVjEe1gWU3w6Nc52MiSXk2sYd9GdUylVd/eHP6EarU3nRMGpUn1x4epm+ZBoJWqyWt7Yr15lMiq/lA5z+jBXL+DU2GcmylZJHRQ4GgyLcdQLOANtaqOfW/ldUP1KBc8A4suCuafxd+B6yb+G89T3GBBhkVrM8tULWSYygQhfdC7TIJcA7a/FOT/HCrMfPY0Q8wLSkmiFPil4xwI/qJ+rTUuMZOc0lW7nZA1EGdw3MjVxXu2LA890dh9uVVXcNj/32Afwcs5qUjLTkast/dsneGqnFBKdjUOi01Ohpc7X5yV0IQaHA3jA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WEUb/AXDNHtKH/t0Gpw8NfwkXDOOVqgFaDLcRTqaMrHRTy1uF3OQLXtARO+BPglCBbthl6wu8tzfn1hcPYR698wGj3RLdRnK+Ig7vUaeilaaFU1rWuSv/UuqeNKtFDF2L3H87y2jmn3xUWGK/5H704pcDrowdrMBDTH8QFuoW9OvFlM6DRKjRk3ogE07eb37yHc2bErjIctVq2l6KShgq1pbFDLDBwvA47Y5/B0c4kK+0JFXNnjsx95JJVsi6s/qp5gg+9wkpOD/R6/SY0XwAlx07NRT5AAaN1Dn/pvHcjZOfs60S/BNpp7QEX2Pd9NtLDoLA9lCGkg2aK33DwUV5ikuqxmytnp4aqgvfliTfhGWaICLC2gndYIS3e2PdgS/6nIKRSR9YHgIz1hGH0hxft/TQJJUAyfDka+c+0UK9ZSd+9tQ9cm0XsYmrH02jB18edokeFCvO6vc8aI43bGzoZBuZoXML83d7SWNX9zqa18K3G+a5VcQSlCY62U6nD40aQt7Dcgktk6eV0ffJKUsrQdwnYHJXdstt7fYEcQhT5AeyXfCet7NiT33pKuoG6qFLZVw4zkurNN1ggmyXW5UgOzZgJI0DgVZ/Y+UKbEN7bc7z4JMEZpbsoOqA5sGB3/5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b98965f-c8d6-4a96-6492-08df4b07d89a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 15:21:58.3295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lwU31Xc43GuqzM3VM/MjhH85RlcdjRVgo+VXMgHuJtkOTrXxEbZCS88vq12/eKM1yHDdSQuIvKo1/6SoxlDaGQYJcPfyHT5PsSJnyt2NXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB7908

Applied to for-next,

Thanks.

