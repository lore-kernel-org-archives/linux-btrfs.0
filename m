Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5E6486BB8
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 18:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784831002; cv=fail; b=Y/ElkPvdp5LbBO3LTEd/XU5Wh24zQMBY82okgVcmlVniYZz9KORQ4ZuSTftkLOdyYusSLW2/RCEPsagiR5g4G/75RCix2HioCz4qlG+yFjNaPjklg0xGJrXUHzwfjeILJS9tM3jbdyLwdLS46SkemrFQOWYMzmuo25VJ+swxOfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784831002; c=relaxed/simple;
	bh=KURahh/UDbnAGetINKgaVITSMMIgthB9uYos0W8XmBU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HBlNr0gJIFgdIqGYY80Q44PcWU6sSsCqPc9RxEl5BdBqG0/ccQnMoEyq8mEjmxzj2mHyYIZvpSgF+0ofmadr6gQyL+pzQBjqSGYo/dL0riZsA1fadNFB+rdeZb4AMTKDqGr6FDAbWyj7kFYhv8qbs6v9z9urK2L1aRzrD7pUaak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=P1wyhGAp; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AYfQSHUj; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P1wyhGAp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AYfQSHUj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784830992; x=1816366992;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KURahh/UDbnAGetINKgaVITSMMIgthB9uYos0W8XmBU=;
  b=P1wyhGAplKFOHQriE4mQDAiaagsTIdjDaVZB1OaPuTy2iyTYOX4uRET+
   eWgGgrDd8/ZNy5eHE6CaLJPXV4vPTaThnn7/hxmhj7lYTkTGubDDidpcH
   Gbvw49VMiV/tqup8QKl2k0S4WQOtyEbtousRUZQakagOT14JrWesuH/rf
   hg5O2z1jKnVjxXqxy9XYhGKPGK3+i9ggcwCOR6gOYl4Gv7tJvS1rh2rLd
   K4prgm0lqOKjhpZ/xYLXX2hYIX3yBuq2K2k3B5BXGDdFMCKwx7Z8ho35w
   TNuulOQTvrkqsLFLF027G1E+kdSUpd66hP03+PyFkNiA64VSkjL4++5FT
   w==;
X-CSE-ConnectionGUID: z1iEU5IeTrSCCNPjgon+WA==
X-CSE-MsgGUID: nUQhTAnlSkqxa1c7g6SMSQ==
X-IronPort-AV: E=Sophos;i="6.25,181,1779120000"; 
   d="scan'208";a="152569761"
Received: from mail-westcentralusazon11010019.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jul 2026 02:23:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QqMx8sImmPn0uZE3k8t7UycE6y09QWOPhyY3i2RbKGp7odsDTddArf6u52UgVMmnj+fTlwLKbqmK9gpGEi6aN26c/lYRSj+ENu5zIwSnSC123hueGL4ePZNDT5Vmo/fUx65Zo1OgCs7R21nsC5KPxxoQj5rcRLPB1qD3gRxxoFPcRX7/SMNve9HmoSW+fHJI/km7cNvXw+k632sVQZglyDMfnHIcUh6R769i9cix16W9/YiLHHuMLbryoUN3ib9H4rKaue22T9IkDjoM7LNC+s6eGlg7AE9R2AKAeitNfJynM0c2dFL6hEWVX39Gn9UvQqrRmf+odMhiOgWLLv4Uzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KURahh/UDbnAGetINKgaVITSMMIgthB9uYos0W8XmBU=;
 b=dF4LGgPVZ0NqAQ+QFOEC7TU/6OW+dbnlRBHN+yvVycnglOXpRKDqoLFw8PBNJvcux/VXGoteNhXKqMm2xFiaCUcmrb/7YMCO/EMpShVJ+c0q7FFIapBeNQhvbOyf6dP6/PknbpjA7YyOMOvNE81sumtRPkzIPPyoIV+X49CS3lamNlo+vucyrJGIwKv3Jd/N2XYiuIY3E7gWhInwv4XKuGvdfPNZH/sMXYpfV96pDha25NoOvaX1LlUKQo88G3JrJasCTv4Ul8JkI7w20OfpO6Kpj2rO3ykDnvmnBOGJ7r2xkmOis8ZwWlXoYdF89mHvZp5ym1LsnXCBAR9xqg2F1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KURahh/UDbnAGetINKgaVITSMMIgthB9uYos0W8XmBU=;
 b=AYfQSHUjNaqJ4R3UJH6TVo+rQl3SvCg8qe/EtTqf9m9PBoYXkBT5Qv+ex0H2U7e3VYanJ2CkvlEasuJkA0vnZXOwt49H3YOuiuX9cGABEJNy/1dmDbNHbRqnY3/ka7/+kteM1Rh4zDL+HbjhcdPo5dQUE1LEuB2YRbrgCPGGlME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7678.namprd04.prod.outlook.com (2603:10b6:a03:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 18:22:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 18:22:59 +0000
Message-ID: <d96120ef-31cb-4e7c-a871-2aa9881db6fd@wdc.com>
Date: Thu, 23 Jul 2026 20:22:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] btrfs: zoned: drop stranded dirty metadata buffers
 at unmount
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
 <20260723155428.94187-4-johannes.thumshirn@wdc.com>
 <20260723170218.GC752950@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260723170218.GC752950@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: b2ae1d49-421d-4e4b-6444-08dee8e76cda
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|1800799024|376014|10070799003|366016|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 vC0WT/JeeSy6UrBVH0ytc6frXcrSVN4Mfaob9ghDIW6CjNX1Mk+cuO45/fp4m35QX+4IASBI0d0OJBlzTnlaSc98nStxW14s0hvIhlUo9lci8As8rmxdJRv8zbKvtDMTkszyAoZ9DPeGYneLDeqYk2OAZfiL7oAXnR+4kh5f4aSbN0bLweCUvx+UKEJkgkhLCg/rWWC04dvRucaGuZh6+Cwb0/kr8XfUax6ss2DSu1xT+WUz0SyM2Rtez89iyQdwfNGg13VWS7CBBOZiSM4F+au2+rxQqfkro38gz71WdXbTZSuHp2PJ4LVMJD+rAleCTIZTqXoin+KwqAGe4Fel1PmQmH0/9DRvJwPh2j9V9G44dnHLQ5A0aCbJz7oNFkRnpUDjG1bH6Iux7KaQci5nf4jAjOJ2FCwL6Ls/jELQLwR5+y03WAP/dVKe5TA0wBlKyL1EVJ9cKfnmKpzL0OmcFpUbQLawlXmmQkijWKGQr9pAFRbQXsTanLAMQ6nxxHrSvlVFvMj4yndQTpG1wMnlSoaS2p+tB+J0QNL613wA1ZMs3v7RcTWXQoez/rfDB7clVqns0+X6Fy4iG1PMrWvnPjTk1tdcPPvVhF0RFvxCQLl4ZV9WI6JIjC0IcKHe0L25AYOnXRm5KKSK1N/aTfiAE1h/yqAlzsag+bM1EPNFxjg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(376014)(10070799003)(366016)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?eXhtUEpNVmtwdnllZTNwNHRtYjhHRE1tSGw5U3ZnTW54SGxtaFJsVS9KbVRB?=
 =?utf-8?B?REZJU3ZjMUZzcmFaWnI1Qk9aVHdkYmhHSTQxSkhCRTlIVGY5RXhpa25YVm40?=
 =?utf-8?B?UzQxMUlSTVBRVmRvbFV3NitTQVFPYjYyMENoY2w1a2ROVXAveUYzUjEydjdJ?=
 =?utf-8?B?bDJRNnZINitsRG5yelpIY1pscFRLQ0ZBOERreEhNN290YmpBQUhVMUNCdXVn?=
 =?utf-8?B?Y1R2L2tyeXgvZ3duUjlwY3hWS0lHRzI1UlVkNFE2aGY4UVU0cmNtL1BPWXlS?=
 =?utf-8?B?ZnpSOHNLUVBYZmg4T1ZpYkFIRlVOZStsNllYVk91cXlJempOR3FPN3NEKzZD?=
 =?utf-8?B?Unp5RkpTMjNZOFhWbDlOencyemZTV0x3UTNFaXpubkdubW0vb1dLcG9vWjlG?=
 =?utf-8?B?eFNFdkFwZWdSNDRzMXpXSTQwMWNORlBGVjF3NklsWFBpZEVRa0QxVStLWGg3?=
 =?utf-8?B?cG9rMFA1UjFld1VxWlYwbkJsSHRqQWpMU2N5d0JMZVR4dWc2dG0wRlRhTkpq?=
 =?utf-8?B?RUZrNnpSU3BMK2tzbzAyemF3Um10bU15UGFjQ09aTDNLMEY1TEpoYVBrUTJq?=
 =?utf-8?B?YzRwdU90VXpwUVcxdWQwN3d3R1JQMjFUU3NZUVBaR2owSlNNaWpaRGxBck5L?=
 =?utf-8?B?NU5XRDZTR1VHd0o0Y3ZJNGNoWWZlSlFxOXZNejZwem1JR2xBUkNzTFVrUkNC?=
 =?utf-8?B?RjdBSWgvSE9QbDdYVS9iOXZJR3pLQlVQMU80QWF3cTlsVm9mY0ZvVUVSaUli?=
 =?utf-8?B?SWlYaWZtVWNpSFVzUFNxQlkzWkozeHRleUcyQnIrQlFMbU94Z3pSMnZ1Vm5j?=
 =?utf-8?B?RHl6cGRBeUFGZm9nTEZlR1hTbnRpZkFYaUh4VWRFbnhLKzBsSVd4MzMycVhB?=
 =?utf-8?B?di9vTG9kWjZLWDU4ZldCcmRqMHArb1lNbnhYa0lCblhXNXBnbWNZdUdGY1or?=
 =?utf-8?B?Q0tMdW54a09mMEJoVDFwL2lMYlh1VFNtaVZZK0tvUkRxSDhRRWg5UFJzSk0z?=
 =?utf-8?B?TU56K0JUM1RkY0tCUXJHWk1sS3J0OWZhVUw2c3h4dVA2YSs2WjJ4c2dCUVF6?=
 =?utf-8?B?eElEZ3Fpd3hlaFhNNjR3UUFFcUNRUlF6bklpUk9hYWtXa1lmaWZPMWttcVBa?=
 =?utf-8?B?cnprQmxyN1JuNnBjMTZPOVBqbjBnME4vTEZCUUtTUi80VFNUamNLSENvSU4z?=
 =?utf-8?B?Rk5KNHdVVnNkTiswL1hmR0JCU21IWHN6N2prMFpudGpQNVJyeVJWRXMyM2VX?=
 =?utf-8?B?d2dKajBNMEhOUkJoWDFrQ1VNZTUycjBDOWMwMkF5eGZBQTV0M0ZGeEh3blJD?=
 =?utf-8?B?Mnd3S3E3VFBVWlVKcXJJaVg3b0RaQ0NBKzg2aEJhVzVWbWlVZnJCOEh6dWJN?=
 =?utf-8?B?UmRhZkxTSjZkczd0U3F0MGM4enVoV2RHMnh4bEFvRWJMNWxEWUhUb3JYODBH?=
 =?utf-8?B?VUE5bjcrTGNwNnVuWjhnbEVFdnpHMGJRRjBLaHZVemZ3dm1OSzVkaE1SVzFl?=
 =?utf-8?B?SXBQTXVUak54UXF5SHVUUDdiUlA4TStaeDl6Wk1XeC9nbGtjRnVJbVZEQ2Y1?=
 =?utf-8?B?bnVCU05iTFNlamRzS0Q0V2J1ODZKUHVSZDhpd0ZLRXpVYm8wVGs0b21vRVE5?=
 =?utf-8?B?Mkc2c3BaWDhIeStHdUQ5THBVbWJUYXVFd0ZLZ1gyOVNtWGN1ZHZvQnRNWjNU?=
 =?utf-8?B?WXl6dDRrZFFtVytiT0YvQ0o0aklJcldOQlBxZnNlLzBaR1JsU3pzMkVNTitG?=
 =?utf-8?B?c0RiWlg0TFJMUXArODNEMlJnWlJWeEhlY3lwdWpPcTR2UWhQODF3S3cxKzJR?=
 =?utf-8?B?UU5jU2NFckk1TDJxSElzSXFBd2cwMzRjckNaaUV4RWZPaUdsLzhERmpDZDhE?=
 =?utf-8?B?RDhXWmFXajQxNDc1UmNmR1dKbk5JQmJoUFYrQStqMlp3NUNqd2NMMlhCRVhr?=
 =?utf-8?B?UWk0TUU5T1k4SUE2Z25Veit0SFB3dHg0enluN2JOaS9sZEtVOGhoYmc2L2wv?=
 =?utf-8?B?MTRMa0hnSkdDMUtDUGFOTzhTSy8rUzBWaEw1c3BXVVgyWCt3YWg4NytWZnVo?=
 =?utf-8?B?eHpGYjBrZnk5SndqT3Y5VmpiNDBHdzdVMEw2N0ZLWkpKb0NOMkhSOFp5ZXF6?=
 =?utf-8?B?T3RaRS9VcjcrK0t5NGt4WWNEQS9HN0xZRU55YytUQ3NnWDY3ZzlDYWdzbXUr?=
 =?utf-8?B?dHpuaTgvb21GbWFrQVpqUTdHalpoTnRFaTdZL2c1MXNkdG1NdUdPSnVIc0tI?=
 =?utf-8?B?QjVNUkFsWWxTUk8rZ2pnUFI0d2xXUk1Uc2dCRkNoT29Bc2o2MEM0TGg5cEZW?=
 =?utf-8?B?aUlkZmlwYmdFTDh1NENLdUJiL0ZSWWJUY1hIeXdjTENoNmFQQ2hVYjEzMUFK?=
 =?utf-8?Q?Gjq6RGahqkpAS0/DuFLBmqSFL6LVPn7LdYhOWuFDqdQLv?=
X-MS-Exchange-AntiSpam-MessageData-1: IPrSaAEubEzamDQ0uRI36m5WQN8j3HdzDw0=
X-Exchange-RoutingPolicyChecked:
	JFnp8Ui9zVPJPQd5SF1w+mNVCqQXiLoegyhOQgcMH9wdrXYgWbIrYo7vDW1KgY1QNivRLZmUpJD/BDyhREryqhrKld1qXYb2E5feiyY3WRR20oww+1h977GWfplkXZUeNoGNBL/WFKlFiwSzS8u/32sb0Y6x+Tu+u0fnxNzozOxQhYa1EXAkZVe4Db3R57Ldue+wMfQaIAzbVf0SQduP2CeVSOmyGOw3+UYvWft9U95JWB7+WGLYYIho1gVMrDbQWiU180afDplfRUJ6ycRmpx6snZMJVjRQBmEH51+QLJzurTbAmSytwvtEKr3CoTRsS/xr/OnYARjLKmp1Z26+cQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gxZY/Qq0WZUBVrbCv5fM0F4r47XyXat/yzyjb3dXdHYVYSDy4n39XDa+6ixcFy3qCuQKfGnaD6OZdmiG75HAzRAa3Z6/rP49FDv/H4b/b5B352F4jN4nnuY/zmoDU5Roa1+zXsiBsPXaU8MB2OQydkR0YQgl3JxhpT/b9vVDGfHeU71SciTBE8qvnU7WNNxFpeV5lDOMt7QQ5H63mbunK+VXYU6mnSiFuqOv11rwSuoj2DToQvb7mlZ9SwoUPBB6d+64vbvA4l0fUmQiQZJCfmQHg7HoUhY/cvjcvfoI3bDlzqbgj11dr+zGjMjRVWQ/992FW+ovZ1UoUx3Sg/D4b/Y0SHUIdhsX9glVyi0FbVMOnOVde+APylNe43q9AcWk3P2/8aYBBjqfKm21+PAK62OKWRPzqZrMTRseIs7l2/5y5G0Xjd8YUBFeOViIQlI8zH9ZseRu5dmzrX46U67Wj+9epRHytEa4L8gbo7h2RtD9JGxZbImT/WBsyhVqe9ra0pX2QlVtGkyIRyY0pZ8daxXTfu9GFq9AzmTsmWo5lr+UcHXEHAZunA4Abtfl+jB/TEsKOi5JL5C34KDeiBNJcmko7OGAKoCrVPA0upOHY57Q0Q2YVgBwLCh5RAhZQ/Vb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ae1d49-421d-4e4b-6444-08dee8e76cda
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 18:22:59.7561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZ2yn7U8Ze/9GP/ScMdxLcvX0bM5YpiXakA2gUl1oo1HrUDE94WMYeTPTctlJpSusOv5PO6O53NobEmoihmkufJjxcivnDO+c2Usn7rbwxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7678

On 7/23/26 7:02 PM, Boris Burkov wrote:
> Immediate fix looks fine, but the underlying issue is a little hacky.
> Can we detect that we have staled them from free_log_tree() and release
> the dirty there? Am I correct in understanding that this means we can
> overestimate dirty? By an arbitrary amount if I do lots of unsynced
> tree log updates?
I did try that, but it deadlocked pretty reliably :/
