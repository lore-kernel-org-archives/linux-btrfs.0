Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F9B3BA244
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074454; cv=fail; b=sa1zoyfSydFPe6kqNjnbep87svrhoucurkQkyJZrUyYdWPLUgRcPDfHpL0xvQ6z+9LKwYZxi55y5f7rmkN61YCJYPwIkQ3uKhPl7VFEVaMBuEfJOQDDO012vBpwJ7qr1/5hMTBN/cOgUF/iQphwgG71HXXT5O2kC56Ggw++KLjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074454; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fClp20Iis9P1qojadKZ+fxluC+RIEsQglFZiE9yJf30fFoQF+TcnLuGXPolLuCkqm2vqh4YgpqVXQvFHTkTQhWIZTUn9Q2oJJD4DXhJMOORfvWimhyfT27/MeGR65TdGxoupoEsNhVNGNCtm77wwessF6EPmiqh4OSFVOUwADIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UDlZpoad; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UO7PP4yr; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UDlZpoad";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UO7PP4yr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783074454; x=1814610454;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=UDlZpoadStEEmC/i/hVWxcahcNV6vhn/RurVdxcKxKMLa0SqUXtTV26j
   9gfiR5GifdQBhaNKJpD1PflgRMDFGoDum9VZAsl0ho8f3EZV2/JxyqtZQ
   oXZCEEFJE2z897ZT+dBSSq73tNwFVUMkBVhgGO4wqQzewQrYezoY1N3E9
   QAF8qMpN8MiCOq/gyLmEvv7ThaSIKkGGH9zLgoJ3EIChtcCxaTl6MkW+r
   YzsOMvzWMpYmJZS5TT6/Y+KA6RxOYpI6dOBNRH1uw/b8eQlgB4/EWGKq3
   A5EFLgvfAiuPZdkF61Ar2eRshThL9f2Odk+107Jo29kLoXY0Yxb18MFHz
   w==;
X-CSE-ConnectionGUID: GsfTN8aPRK+rOwZGPqlVig==
X-CSE-MsgGUID: 2o7Uk1fxQF6dp1Qkyj7m7Q==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="149356799"
Received: from mail-westcentralusazon11010064.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jul 2026 18:27:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xj9wwUDu6vt4IwO2WuXcyoQc+8Z3MsDhcaXNXIKUG2DVTwEG3rSoPgF2Em5LwtD9iF6hXHV45OrWH5ggpF3oVXUNk5lQqPA2SIXIXk8Fns00TepkuzS7YVFDE/8UzpIAuo37lal1D/bLTMXQ1M3JA94K5H+A8DCGF2JONEPArP8mXWLAP49r5RNBbQTSp4aVbf+Sz/5uhp5JMOvBaIY3bwY0pryH4aXPWYcrNMJZNyVL+tyq/bsiMRJjFryQ6z2IB3gPxTo0sm6rxhvogWYjnxu+/opBJMWea0T+VIrqjJEA1tOGAQtzl7/yDaWHvZ6Et4pgTQ8aH0p5uytjad2Flw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=T4ryFzich/rSf6YaMw/CX0rvheDJCm8BmihpyDxdHcQXkydYWw/0/2u/nat+lErQgf9GrQEZdy+cyrrdPHfIgGdmybWlgOtmaVAOopL3TArbAhSa/+8ADE5EEmcvFju+hSVMu5Eh7mD6XWug9BS9DnRvJ4yvNzYxwBhmjnieXzx4KlmfLs0xS44dPIbl0FHY3Yp4IjENGKMJmP7+fkc2RuoniL0fXvhyj+OB9Oj13RF3OWQRaKnKEdvYlFCWG2HQ9XV0iecncoofUtVA482GkSwrrqZRCSi507zi0DJSmQ9RPP2hJN/9JhaAD83LaFvFcMPXYHakb/s+ca6GisbTfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=UO7PP4yrM8ho8BLukPblo519+Cp6ff6n/J+BlaPApUinazY/Pbfurg+TZKN+fXoTTm3USNTSIPAMudPiNMUyr3zdoGzRiK/uzNd7ODrhSSVfV9gAH3JSic61KzLCDLqlMVJuoqXG0b3xYt214rhpg/FJJyUeNz+8eY9SFSBOvLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7900.namprd04.prod.outlook.com (2603:10b6:510:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:27:24 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:27:24 +0000
Message-ID: <23d589ae-bef0-4014-81c1-32ae0def8a18@wdc.com>
Date: Fri, 3 Jul 2026 12:27:20 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] btrfs: small changes to "usebackuproot" mount
 option
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1783071857.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1783071857.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0269.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e4e0e82-2f27-4fec-057c-08ded8edac03
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|19092799006|366016|1800799024|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 IM1Mh7HGtT5XQnPf8WKVNkFEi9aYU5k8tZV3V0F9aXAf4QJziiGpahmfaTwyrGWkEGvN+bFJKiAuKOda2T948LbF0hsB3DgbqQ8Il2igkCsJ2yyLYZN/ZiPB92S3gWZhYmGKgWo3y+5RvZCtG/VFWRjDVs+mfRmEoFQIUA1VJnCgJ7hoXgItwRIkys3KLwD4lmQV/raSrmfgIgGw8UPQVjfWURysLcVj+UE3S2I2AfeObQd/89bnk/IUC1ersjWJAt7DBLaQkOErr7WGtamAXXOIQb77qAK0NLWxiQ8KPzDzlFlBPoIIovPupGK7PhOwjDuTh5I+m5uXurkLyXgO+ZrYMKojB4dDu4NkbK/GyXzNflH7WHvCurxFpEnlwGNd4J8H746Pxt2ZImsSPpXpTeMYOk+E7KEcem0pAtWKyOkKXL9SDXTkRaKEzAtLaRuoI3Nu0+u4QzDcukMnUiODHqtLOEDNfdWBNCI/tqZc9BxvB9vNteU9iRmW1+fILlyQL+i0sSCPWEbyd6CbsLII22DpRTKy2LnzrN/Mz606ux3VVIeyvCZNQgOWf3mYRH1EgBiTQjZ9iY65Diuh8qjxBg+hhbofRhFQnnSN0QLlzW9mTQgEBsJnDs3r2GpMYhpnNsEtxvY+TG/ajD+3HB+ifZjN6kN83X2CgNg2VVxcqhY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(19092799006)(366016)(1800799024)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Ny9KQzNUR2p4UzQwcXZFclpFVGFwU05SSm4xaVlrSUJ4UTk0bThNTXp5WHNO?=
 =?utf-8?B?TUcyeW81dGhmQVRvS1lVSTIxeHViZmNUb3hJWVpSTmQ2eGhwSUp6Y1pLUHpi?=
 =?utf-8?B?NkMvc1NsRkpkaHdmN3ZpUStLVGdzUHFLeFBGOTkxQU9jS0JaVFNiNTIvUVoy?=
 =?utf-8?B?b3JqMk1VTUF4dVVRUXV6endMbjlFUGkwd3lDT3lDQmxvMHgxTW5aNHNsa3d6?=
 =?utf-8?B?ODF4TWU0dmRyanJTSkFuMG1RN1R3dkgvcEg5Sk1uQXZORHF6QlhqQWw3LzdC?=
 =?utf-8?B?bFcxd3ljcXNmY3hmazgybWxaaWZVaS96b1lJQzdYK0dUV1BxN1AwU0RSZ0Zv?=
 =?utf-8?B?cFdlZk1ZZ3ptSlBhYlNUWG14bnRHMXBlSTFnMjlyS04xaFFHcCswYTMxTWRI?=
 =?utf-8?B?U044RVpsZzBlb2R6d043TWM5emZMd2p3NE5MQlVsY2hSekphL004eFAxQnND?=
 =?utf-8?B?VktKZGNSVDJmbS9hanp3QVpPN0dJOXh2clNDVnhDSDBlQ2E3V25jMzRxTlJX?=
 =?utf-8?B?QWNHdWhWTy9ycG9GM2VpTHJvOXcwSklKSng5cmlqZzlHNDVoWThRREliemU4?=
 =?utf-8?B?ZlVUT3pQN2xsUXZNejd1WWtHN1AzUGNrUzFQYVpCSWN3RitHWkxHMjlSdFo2?=
 =?utf-8?B?SkhCVXVMdElEdWNWZzhaRTdzaFZQL2tWYnczQ0x6eG90TU5MUzVVejB5RkVR?=
 =?utf-8?B?eXhCMXJuMkZXL0Q4RW9OdElhTExXVUp1andkMjh2TDNLd0lBaSsxQ3A2NTND?=
 =?utf-8?B?SlphSi8xWGszdjBZUEpGc0RIVlRvVnNCci9GMDltc1BNZ1FZMVo2Q3dtaXpB?=
 =?utf-8?B?V05CT3REM0ZiT3c1MVFZb1dhN0wrUGNic3NvMCtxNVpaWnhFN0xldDhKalg1?=
 =?utf-8?B?TFdsa1VSRmhOYjM1cGlQQVR3d2pLdXBiNzhHOWVTMmVlNlpra0J6cXplSUFs?=
 =?utf-8?B?NGRnNFZaeVVKcXViREIxUHFEbzdybk9tWUxNUWQzNHJLN1kvRDhoMVYwSHUr?=
 =?utf-8?B?TlZoNmo5Nll4Nmo2Mko3Yjd4TkdmYVphOVFTeUcwSlZiRVdsMVdTZHRwMitK?=
 =?utf-8?B?K0JqSVNEcWFxYS9tN3RtVzNtdllESDF6enFZVk00ODBXNmdwMTRKZHZwckxU?=
 =?utf-8?B?RWJGNlVnTUZLcGNVMzlFZTJ4bkl0Rkk0RFlnbzdTcm00WHhFRkZpcCsrUkt3?=
 =?utf-8?B?ajhIMFhsdWlLOFkvdW0vcTlvUlpxUjhFclFNUC9Na20zbE5mWUdmUkwwaXE0?=
 =?utf-8?B?SEs2VmRmeTdxclZBSHg3eXo1RGNHZVdVMFNuK3htR3VueEFSVFpxT0w2Qk9O?=
 =?utf-8?B?TmFvS3lzald1R2c2WWJRNHF1VUcxVWlsdmJaMWhENVBVUytlenNaRHEwU3My?=
 =?utf-8?B?NHpQYndydE52Ykd6NkFzb09qdGhTd204S0w3RG01cDV6K1Q4eFZ3QjdyL25y?=
 =?utf-8?B?NGpzQnhkczRSMVJHYWlmRG13VUxPT0l6emQ0cmhudVQvQjgzUmxsaWUyTDdC?=
 =?utf-8?B?bUZRdUdWOXcxRnk0K1NESzlJaHI3bmlHZXVZN1lJTDhWSlBxTzRWTEhRZzhx?=
 =?utf-8?B?elI2cTB2bkt4SEtrVmRiS3NWU21WaHBFZk9EWkhaMmJmWUMvOTF5M1hVQWhy?=
 =?utf-8?B?ZFdITFluSDhydFBRK2xiUUIwTWFOQ2NobExJQmRMNk02cDE4NHdtd2tIQlpk?=
 =?utf-8?B?NGlsc25HV1E0UzZabGhDbUh3YzM5clJJa1VoQWREcWJGRDN0eEw1VmRwMVpG?=
 =?utf-8?B?Zm0xZm4rVUtRVHBacldUZ244MjJ4V2RHN1hvVEpIek9GQkltOWJxMFF2S05O?=
 =?utf-8?B?enhJNjdKUTBHR1BiV29sVVlMQWhIU3JxREx3OEwraGJ0UjgxSGhLY3RkMkhx?=
 =?utf-8?B?bHpuMk5OR3ZmaUJWdTdNMG5Od1pFQkVxZmVRcWJyb2Q4dyt1VGhnZVhBMXY2?=
 =?utf-8?B?SFY5RmdabG1xdm1UeWNSbVREajZzOFdZWVIvOHh2cXZ6NzNOVVpWd0tHWmNM?=
 =?utf-8?B?a3NZYVV2OXBuTGFNTFhYOHN3QXNmTzdnaDhJMDh5TUE4UnBxY2VpMldoZXR1?=
 =?utf-8?B?eXpWcmhkY0F4MFlWZWRndmtXdDhxblN2RHQzM2plUk01d2c0VGZHZkMyaEta?=
 =?utf-8?B?U0Q4WkFmTmpTTzZ1SkZNWTJxSXZyYXJpZ2FSYWdmemRiTXJmZGdIM0p2WERG?=
 =?utf-8?B?enRlbXgrang5Zktrb2FnQmVHRHQwNXgvMWp3OUttWFNwRiswdkN5MERpRTlY?=
 =?utf-8?B?Z2xra0xVMGovUXo0c1BWcFdBQ01Fam1NWHlxRGpFN0lFbEgrZk1UODJTSzlL?=
 =?utf-8?B?T1Z2dXMvNmFXVlZLTDBJTzUvR1YxY05pcGwybGQ1RWhjM2U0TDMxOVdVL2Fn?=
 =?utf-8?Q?RQFLbxWreXe72wu0=3D?=
X-Exchange-RoutingPolicyChecked:
	fZ9lbJGnz6rfLWGUyf51gvjf6SooNpEA+3fZypz9Wr/VY9j5HKO2U9UBOiaOCcbCVBV+AD4ITeP2MayR7O8BhOGiTsnI28azLgQ51hJVhdQmCWUTWR1ZUb6feLcF+Ml2Jx8tKOp3AkuX4uVcix1rAasi8seboKj22xaRn95HVH/KozgbOscByXFy3k+q70aSfaylo+2g3+WV0CIOBJ9UIKwxq3DfB4mK6/F+q14iVqguWg7F/hv5YkMGvm0sXCjojqcYYprcon3mU/SG0sqG4obndCW6oavxPzFr+w4htBq2J8of0OXHvcad4kXBfA0/kBgrtvynUVXJZ/2LjWSQAg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RR+whiqf0NQjbJYnqTwasvOZfniTsHM8Ylh5BlL+mPp20r5BEqAPAWtc1m9rweOwn83WT9OK7CCEgWyETYB4CVnVYB453cl3s/boyt7YGus2HwltOnOANdjBQXOklmtXkZ+cjBtWosM4/M7W9MikkfxeE2LZSKFWEI9mVNI6xbaW/iVyW3oy/colvRX+T7TOazbxP8eXIHaIYU00/7X4oj4dTr7+4I6PHFUemYbOM9kQM9DJgiwG66pti0cWZUW0oQJ8gtZaeoL+Fa4BE9G+3oyCGzcLkDv0l+NrUVj0UhUjuLFfvlpSyTV77rBTWFJiRoTE9wtEAFA8uqeutVAvFjjZXYTVa7N09qgM89QI6C9BRRxIdJCYwx2ZLMG72zhVK54HTklOqJsuI3n7Xwec+T+2Yw2y7QnAHJJ2femHGO3w9btR9k8r1BlGpSkwsR0hgv4SQzma6MsqrVVts/O2GPAePvF9PW7Ymju01dgUstPJMvWmljjnzITZYErMvC66k3HwW3ZADj2NACyniiBJzucdZfwfFYCrSWwKODvtbCW3CFKoZwmta3W0FQMV2huzu7x4Z3oF5hT1x4SSWwiS0tk+Ei9oLtZYDbrw9NUZ5EyXQAS40/KJLYCCXh9RyIGS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4e0e82-2f27-4fec-057c-08ded8edac03
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:27:24.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0wBGre7f/guJcr+S5C9OK6KL0+/w/EhSYSCML0xwdO1iZygtKyuXmpgFnkrgcr7MG7IpHEwewgb8PAMqWNaBE/jmcwbRr1K/QcKfGZhyrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7900

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

