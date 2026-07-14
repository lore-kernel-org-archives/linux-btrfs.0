Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D916C3F44CE;
	Tue, 14 Jul 2026 08:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784018911; cv=fail; b=gkNJKQelTEJyh8elctwgqHGgChNrvjiVvqOWU8G+/EkJk2+/QsBzxnz2U26eYo7pZslRyDenmUjF8P3vj3VJKA5RmJ62KTDGZZq56ABZ+DmqoxBMWWBQZcH+7ltbQMO1te6P0hUmOyPm0k05CApyWeOjWToaBzQ52WtaELDaA+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784018911; c=relaxed/simple;
	bh=dd9y9mlUhBC4WY8M35uVzViQ/MaqIkKKvVTYxaLU6RY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KqBxxt80zl+/FS+6SmaW7G3yDs+rR2DlIKGlZKD0xQTUk09803cljNoK+mVhJ8o1Hdqe2olkRlPpjijTS1dQf8myDMtD3Bw79a9ZEIk9aMUbRZJVsDFvG+qRxXJ+u2GTlb1Wu5yQkvrTPPJRwXuvUamRd+CwPui7B9B1x1VzChk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LvE8HAh/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Oi/nqFF2; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LvE8HAh/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Oi/nqFF2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784018909; x=1815554909;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dd9y9mlUhBC4WY8M35uVzViQ/MaqIkKKvVTYxaLU6RY=;
  b=LvE8HAh/nUaAn8ljBpS0nt9W8RL8eIsVFy5C7ubLssd7vur66l2fAunZ
   yWBd6ewJ1IZY+OKrPavx+HCRD1M8hMTnQDUhtyZel5+8Fbclida6NCRmU
   2KT48mKK7OMaQ3vhPYlGJ4ehRihji8IOrW3zqyVHEWh4n29YNPC6OoT+V
   foE63+Ve96zUK4ZgjHHCan8WbMV8oIdNgMZxlwKbNNsjvOV7uEPSITvI1
   iqHQTdAvNRlKfDrdnPg4G1Vl+0ukmQDuBD/dX1vwE26oEZ3+UH1zhGmPe
   bAPBCPlXtRq2aYcMFJRDJ/4TpS4CGQ/SJEtJjEe11bOP6VswHvHK1EaaK
   Q==;
X-CSE-ConnectionGUID: ezfAfFySTMOHBSN/gdyCJg==
X-CSE-MsgGUID: hw6PZAR5SGG0X6VDylDfIA==
X-IronPort-AV: E=Sophos;i="6.25,163,1779120000"; 
   d="scan'208";a="149451626"
Received: from mail-westus3azon11010030.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.30])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jul 2026 16:48:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ya9Etj+IMeGMfjQWplFV7oFOpMQn7gGg8rUEugJWLc7KRTu0t+NI7FOSd56erPLox+oU++oOGbPZViAPfYC5/1j06H1Y67Gjj9rDxPpEUcIBiV3KITbPwr3Jltewi5ZZwYjQhhiqCizTcgM//+rSbR0p/JVlPObjB/2VZkY7nf5FtPqJuxuL4JmAVcGivVr0SU3I5jPZA1Wm/CVnw3KmWDkD+6uXAU+Ye9bbSsybyWzCAjgBVah6rw07RkK2MfeKzhUx/uENhFfhVqod+9Cfas7pWgeieGaiRYfztSgs6JuiQjkPwnzx3cp2SQmHEqZRTbuBDkS38J5VlVsjVTkHZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38LNGW89baXJrz5Ls2urv5YznXI47UnIyseblurcXKA=;
 b=iyXI3P1vvDBiCIwXPMRxL/gGvv9ZqVuT9UgoJNsKpIROnENR+NtY+n3fF4UlXUnNAW66k7fKvlbe17Y84Gsb6mqkfzjuEbEucFqwCN5aUWf3ZnDt4QcgC9R173fOYPDL7H6AKWlS2I5BMnPUgXZveUzxoswkZvEN/vjjZmO6N/dDdPokOXfTPFbI+YLvJyNco5c8+0gzp5XPImIVVmcX2ggdFS2EhLQJfsxoRdtk2T+chzfO0d0QkxGGHLs54zK4ghjTVjOig9y/qUi9O9viL30/UFvNn09NvVAs9Zd5QoIvnbTvtd/pY6++cg7MA879TigH0M0FVonL9cW6PNo14Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38LNGW89baXJrz5Ls2urv5YznXI47UnIyseblurcXKA=;
 b=Oi/nqFF2BmamTNFTN1AHjyKCysa1VKzs5koCqQEDq98fBq1qA2649uJ0j8JwJwaVOBOkCjnfDLurlHfvBV2p5iPmPY4v+Zfx6EKat9uvndQR8+QotTrm99qM1aVSHLdAOO57wLLM427fSBPkL/v/DGgGfuED68ceiXC3iecVlMQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB9000.namprd04.prod.outlook.com (2603:10b6:510:2e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 08:48:21 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 08:48:21 +0000
Message-ID: <0c928b70-3b72-48b6-ad10-53c23882130f@wdc.com>
Date: Tue, 14 Jul 2026 10:48:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: fix missing chunk metadata reservation
To: Guanghui Yang <3497809730@qq.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com, naohiro.aota@wdc.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <tencent_860054603C488A379E3D21126EA610D63108@qq.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <tencent_860054603C488A379E3D21126EA610D63108@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH7PR04MB9000:EE_
X-MS-Office365-Filtering-Correlation-Id: a8b51188-c826-466b-9165-08dee184a8ae
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|366016|10070799003|376014|1800799024|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rmWpU1Xw4KJTLa9za67iL9WGyjd/bS76CVj1XXvg5mxUievW0LOgK3UmnUusQX66/QZEyLounkSMW7U/qMDfF9baRVZRkY/js+GzbbTJOPez4lUXnrksBLDh8rgvZy/iLAIMt8JKM1jlnvGl2GqrWXc5dKB4MI0VAPjVsIZFnpXp0lGfqI8G1Utb8HcNmlEiAYVoLpAtq7xvI4B61pbAVgdn7M0tcNPsYSScPPotTelWr36xXRwbMRCRyKxmEfMGfho9SITNmLDjDmGauxHsXlAoILcUeVS+6RFK68x6dmoU9bZnW6SBWB1LqfIdYCELEO22tytLr1YumaeqS7JqIcQjsDYJn/3akBxBTeUXF4UvSRDM0OdJXGLy1P91Zb5azIM4oxKZ9BIz7M/3ThpVLckKh3VnAaLR7A9eOkbOQqLyS5E7VEc13m9k0mobyUj9KlcADUUvW587p7ouCF76nEXBYheLK9lQMnIKCmWTRuSz9QCRn4NxUvaZnb4880XO9wnyjRDDJi4MWV44dGN1hlzwtkCIWV5el9UXnh8BXujiCLY06EDHCd+a6ycx8a3dcZHT8qkK+fdRT0wJfM8EsPx3+1Q4pq4pQBISctNZyIo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(366016)(10070799003)(376014)(1800799024)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUJMQy8ydzhEbVZZRFphTWpad2JsSElZem5qWUJSc3Jzc0cycTNZQ0Jzemxj?=
 =?utf-8?B?c3BYbnpmTG9OUFJvNGMweTMrNUswc0I3OGhCUENJVk5QS0lydXRUcWw0UFIw?=
 =?utf-8?B?TjVFVjI2Q0RzNXpzc2QxNVZWdkErOWc2QlBZOUEraVNLNFc4aC9QZkE3bkE1?=
 =?utf-8?B?amNZYkJFQzg3dXM4TzhyVnAzMjc3MjRXMXkxVGxsOWRCd2o0a0dZTnhzT0M3?=
 =?utf-8?B?NFZQU2FreUtZUGptaDV5alNJQitpU2U1V0ZwODUrOWExSDdVWmJ2NzJGM01J?=
 =?utf-8?B?MUVrOW56RklqMWlhRUZSVDMwQ0t6UEhoU0haZHY5WEFZalVFRjA3TWZiUmZR?=
 =?utf-8?B?MGJCRkVVdXdXOCtVQUMrYmcwbVEwcnQ4OTFJajIyVUJ5c1p3VWVEMHNkQmRI?=
 =?utf-8?B?eWlqbVJaSFBRaENaWHBhSTFMTXJ4ZGNCeW9lT3NVVDNXQjY0NnFZbTBuNFo2?=
 =?utf-8?B?NElSd1ZjWm1jSnNFN2p0Y1VuMkJBZGxqSWNvQ2dWQXJoaWtFWStDTWRSU3ZZ?=
 =?utf-8?B?c29yMGJEbXg4U3hrRWd6a3l3aEppR01JRkphekRMVjdpRGRpdllKbmdFaGdX?=
 =?utf-8?B?QmhtMHZ3Wm5Va2EvUk9xczNQSmR1eTNPMnArSTZoS2NVYXpERVhUZXZUcjZG?=
 =?utf-8?B?cUdoNlFDa2FqU054cmtiOEZoc2QyclZ1ak5obVZuYjZLTVZTWWwxTUthUTgv?=
 =?utf-8?B?RG5UUTdBa1lxb0RzbTZqVXdQVXhrdE5wZVVkNGVjZUNtcGVoVzNNRVhWWEdi?=
 =?utf-8?B?ZXY5dHlXWHVBaEhzMG1ORXNlMFRxYkZSQmZTcXFYdHo5RlEwSm1tK3dzOTZ2?=
 =?utf-8?B?MTQrQzM4TEFJZ1BUMjRKcDhvalJhWHRuV25KbnJlYjlYZUJFdnhYWVovbG1r?=
 =?utf-8?B?U3RFQXZMSjBjQlAwRXFsRDViYm95NjF4S0xUamZZdW00MlJzOEw2Q1lxb1RC?=
 =?utf-8?B?eWwrS25qNGx0U093NzhVYnhuQkJIRUtIWG5LcFpzRXdJc2I0S1lwUi9iU1Ft?=
 =?utf-8?B?SGlyQWphY2tJTm5HZkt6YjZSTUdnTUI3b1J4KzMvWnFkRW9jZldvMkxxVCt4?=
 =?utf-8?B?RVFpSUxlQUY0ZWZTUVZmL3pHbVJSRWt3c0JYc3k1RXJ1NHVCQnpNaHlIa1pG?=
 =?utf-8?B?eG1mYXg4Y1ZsTFdqRTB5akJvZENsUmtwUHU1dDgyMFFuc3Nta2lvbHB3cDV5?=
 =?utf-8?B?V3dISjVaZVdVZkc3SUF6M0RXR1d2cmFaYkdqN2hvZCtnSGxBcGVhQ3g2WnI5?=
 =?utf-8?B?Vk1BdUw3UjdUZDJOYnNBVUQxSW8xUXNZZGdjL3BwR2JJYUtGVzdXeWJ3YmJj?=
 =?utf-8?B?aU5FN29pbDVwNUVDY1V6MjhPOHhETFljNHI2dkVseEVRZzBGMjVEWTFUMHdY?=
 =?utf-8?B?QXpPVE1aUlYzb2UrSk9EaGxhOURWOEh1M0hVdU1pV1p0cm9UWnpOWWN0KzM1?=
 =?utf-8?B?R1dsaWhBNXdIZ0hrZGZHQ1pWdUNGUzBjR2FXQXByYUduQTU0c1cxUU9wZSs1?=
 =?utf-8?B?QnIwR1orY04rWTBGM0VadnpUWWQ4Z2ppazBGYUxJRGZWR1YwOGcyVWNjY25U?=
 =?utf-8?B?M2pWTndjdUlrQW41Uk1XdVNBQ3JjN3hxZTBnTmpJZGhkb0RFVlIwbUpwKyty?=
 =?utf-8?B?enlWYUM2UUpEZGpBZUlYWkJYZzYyMFdwOVgvVWwxZCtlSGlPVkxNWThrbG9G?=
 =?utf-8?B?VGhtb0VXTXhwZE8yTUdVOTJXVTRNanp3NmdsVFhkNUtiQ2wrYllEVlh4UWM3?=
 =?utf-8?B?RHo4b0lqTW82c3J3Qk9rdCtFYXhzUTRRRkZ0SE5KeG9FY3RuNzF6ZGxKaE1G?=
 =?utf-8?B?MWZ3UjFPQUVsd29SNWt0SFdTYTV1dWs4bWNmNnJEejdRTVgyTk9hejFUK3BI?=
 =?utf-8?B?aVpVUytmdDJxMkxzV3RrT1lUdUt5Vk43aVV5RVFVVkExaGVLVWhlTkpBbjBV?=
 =?utf-8?B?NmtSeEZLckt0MDJId0g0Yng5c0t4NE1NR1hOT1hON2NETTRQcDRIcG12YzY2?=
 =?utf-8?B?SWhWM0p2TFExejMrVE45V3VGa3lLd3krd3dUNFgyOGRqaGxrVFpOYkkzcm9x?=
 =?utf-8?B?WXhCZFVhZ1hxdjV1aEZIV21sOGFiTEJpdjdiR3NiUUcwcHVXMlFkSmdQcldQ?=
 =?utf-8?B?K3hTeEZXMDZSa2VnS0k1cEQrODV0d2M0V3lPSjhnbnhLVXJSVGpiS1p6L1ha?=
 =?utf-8?B?eFc1OE90YUlBbGx2RFpPMTRLY0ZFcWJFeEI5WEh2eUc0blpBaU8rZ0U1WEpW?=
 =?utf-8?B?WDVnMWV4TWhCMjZiTGJrUnVHTnFmTGdqQ1dtSkMvd0JaYjkrZlQzQ0dCc3c0?=
 =?utf-8?B?OTdIcXFFYTJrOW9FQXJVUGhmaWk1akV0THNaRHdPZFBXNFN3NU4rVUZYZVZE?=
 =?utf-8?Q?ipAsi+N2fbPRLbhVdU0xQECiprawzrvc+8tNcte7d5srh?=
X-MS-Exchange-AntiSpam-MessageData-1: F6h7Dtn17TQ82QNezlwArTBwmUQFiLgzEWw=
X-Exchange-RoutingPolicyChecked:
	XpAOj/J3xRYRAcPiF7/ltuj4ZYNfggJOReJsbWu7UxclXRZ8o76AESHUZvAEDFIvU3jwmTIrSotSK2YIzINLXjWGdJPRxa3OLqihNuZBJndUMCa/Edz+EjPMfti4+6iPdFAjmF+Uc1gUWAnZCUbtkWPW4+t63O4Yf7VnhK+pME+do//rGF/dcbBM85CirQjtOuGdU3UMksJq/9nhL9Esg9kLaIOjAf3A8MSojOhjjMnUpiYnEP6JBeftLukGA0cH0iJCEl39JLhMT7BvH7p2PYmhrfYPIJod7gn9kkLkv3ydJu3bngXY/F/P9yr7VRTpD17cnQ2YhZLe6e47YvE+BA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GQ15qZPU/NetiXEl3dBvNfyTPBqtZO1k1o7SE1iF/Oud+keyBZ3WEM+bksg5CRseuPwOzwMU++QKVcV+7G2so45qszcs0uYecV21VUrnbJi6ds7oGdJos1V2QOu86UPkNC+hgTCGlm9LeQW66n30vGTW9ti8uXgBotGL+oxBhmym6mP0mMvKxm/JDfYpIKcUQWKE6SWSgDWnGEe3lwH3NLMvF4IHXI4pkE2nNcP12G28agXsqAY655on3tMWPnBBC44Grxv3+ulxrCBPU3AM12lNDLdNtaPkXgLxxL9Os+PYsPBPjP1/4PYjnfgEXZBRW+kBynqsTHx7+KOJcQxI7/auIhYPZd+oo6VYizctc1G43sLRn17m9osJgc2HQv5qr9tcpau88Dp18Uc3kR35Qg6j28u8lkewAnWnJ/lLmZfoDx76BH2me0x6vLVttViQvKFfMjbnmTapo4lvi/DfpGBdFVkbIOnIEahljVrNEQkyMnGYTFZaTJsSLzhCvV4piSJKKBkWuAu3IFCmUjct+zy9wJL5D5haL27Ir5se7jqBJcjT66pQ7e6k0+Bh3jrMD3fXn34psVIkRqSOVpAPFHTI7OYf4+UCeyvpAnZLbPfqNZEhN60IqD/r3DOgb8M5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b51188-c826-466b-9165-08dee184a8ae
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 08:48:21.7052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cCWhv7MuReePU63hFKxzcN5+Kn4xR+7d0BTLpoavUiF7/yUdBXNQTzzhe3ejEoqwFJEF0V/HnwmkwfPGdzWXDICNt+Ye7D3ooH5pZ+0fCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB9000

On 14.07.26 05:29, Guanghui Yang wrote:
> reserve_chunk_space() stores the return value of
> btrfs_zoned_activate_one_bg() in ret. The helper can return 1 after
> successfully activating a block group, but ret is later used to decide
> whether to reserve metadata for chunk tree updates.
> 
> As a result, successful activation skips btrfs_block_rsv_add() and leaves
> trans->chunk_bytes_reserved unchanged. Use a separate variable for the
> activation result so positive success does not affect the later
> reservation.
> 
> Fixes: b6a98021e401 ("btrfs: zoned: activate necessary block group")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guanghui Yang <3497809730@qq.com>
> ---
>   fs/btrfs/block-group.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ab76a5173272..00540b96c163 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -4532,12 +4532,14 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
>   		if (IS_ERR(bg)) {
>   			ret = PTR_ERR(bg);
>   		} else {
> +			int activate_ret;
> +
>   			/*
>   			 * We have a new chunk. We also need to activate it for
>   			 * zoned filesystem.
>   			 */
> -			ret = btrfs_zoned_activate_one_bg(info, true);
> -			if (ret < 0)
> +			activate_ret = btrfs_zoned_activate_one_bg(info, true);
> +			if (activate_ret < 0)
>   				return;
Looks good to me, but sashiko has a point here:
https://sashiko.dev/#/patchset/tencent_860054603C488A379E3D21126EA610D63108%40qq.com

I think a cleanup is needed, mind tackling that as well?

Also did you do a fstests run on it (with a zoned device)?

Otherwise,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
