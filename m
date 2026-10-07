Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC9C466B08;
	Wed,  7 Oct 2026 13:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791381539; cv=fail; b=qN6cLFzO3itvj6hO2OIGjTYOPJjHHVGQxWa1w0wAqexDgB+RImvC8q4xcDT4OLyPn1QXcQ/Ru3e72+R/KMiHxD9fFzSKUkMdHD5q8WRXjfEev7239NK3w08x+U1tbmK6D3nTMhiJQhUSER5ANo7N9G3O7sPAasrPXNsLA0Rm4ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791381539; c=relaxed/simple;
	bh=QFInKTNezh9iAzjNQZ5tLDBilYwWca/nvfOsugXLz/w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PdmUAxFwwUUZZJ6uOiBxVdBpyQ0JLesMyY/0J8xnO7kzwdhoyWFG9F2UIn8DljhmPfmHpX/13gg/VEkwfuA0d/7rtBOyEacGe1CzwCBu4ki8usr2JXQ2oxxXX/xbSLtvXBSWO605F2UmZ50mGBiYVKsj1M5TBNxcfu4y7sSpyao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=b9AMtTox; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=d5/qc1g3; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="b9AMtTox";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="d5/qc1g3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791381522; x=1822917522;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QFInKTNezh9iAzjNQZ5tLDBilYwWca/nvfOsugXLz/w=;
  b=b9AMtToxP43dHgzhdH6CDkkMXQfsq6FDxcSQwyeIIzSlhSNtxK6mDoyv
   cYcB6XA/uoZaWUqc40RRjzlQmYtIYpsDh/DNdvdvHWLxY+KrQ04w+wSGM
   eOPzQIzhWD7JsOJlC7ipHdg+IUuyITWOLZpHmdgvBhoejsuX4eTNO61Ac
   09gxd1iqwbZHS1oomroK+x97Ph3e8/ZRikK8Vl76q9IwbmdH2FQkMdnRi
   EN1HTbH762/IxeW3BhAzPPii9xU/C6yeR1t8rNYlAkkDVfh/Iq73FlBsx
   XWG6fHJTHO03wjLplWS4g+AOcdbTGpDCFieyLU9mk97s28+4rZFOy3rd7
   g==;
X-CSE-ConnectionGUID: gLTuz1E9Sp2y+FrortxX5w==
X-CSE-MsgGUID: BjWpXnq1QDGlXKPxsen8pg==
X-IronPort-AV: E=Sophos;i="6.27,144,1786982400"; 
   d="scan'208";a="158466582"
Received: from mail-southcentralusazon11012071.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.71])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2026 21:58:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x6U5Qxw0E7nqLQBK/W2pe30WaHHtiDFhgM6OU+RubKboSmJ5Pk+yakoXTm91AWIWunDJ6eRdEavPUo1bsa+SQ59h/dbdM5Zs/E6q+Qh7sYHGwWYZrx+rwcT0ierIVQjfAvJx/cAu7+OKgtUFlIG7atl6xM7BmSAmn28ZELTDIQsHmSvi5pLmCPxc1oi69soy/GpogQXy0UYvnaFJ7eeWkVqJmzvOGLTojDMviW8hYquTIuGoBdr+0LHicKsSOHmqsnUxiFsoki/xGL9Y1GGKn2fPtEUKZkSudI86zXT5116FEXHA9lvL1G3kkjpZ4ZjkWYLi6IYm64iif4r3uuyXIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHkis+f5+WX9KLMEvm7a9Ke9vApggGZ0Bh3F1edjRtw=;
 b=HFnvME+YI6pB5sBNGPSbGek0Q1a921DT9cAzWjJC/qXBfHB+rBurGrBz4ca7zoOPIB5r0TbToMmCc/iqqRTCzMm1xSUYPxw8ep+oBQICCwCzoMHwxrWHIhkiiVdV08IPCGP3GReQU4E1AyjRwoErFPy9Y09h5KbKnE5NimYNKwml4Pjb2DIIzNRITpNeWL2Id2y5O4e42d6/cYqWVvTWA0tfaSP/CtG8f0wef08G17S2CzySWPCoL/HzWw+RTx1szQv6VMa2l2t2FXUSKeTe9CExRe0pEofZf7jV6AdbipuM46bR4iJSF8VqgzX7vNS8Wtu+A+weswKVX/4ABTyHNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHkis+f5+WX9KLMEvm7a9Ke9vApggGZ0Bh3F1edjRtw=;
 b=d5/qc1g3NxSQkV/0bbExUOq2CVsnYjuObdd06H20/axP+aqM0cysAdn5jLAsNN/x0Z0IawfBXMJZ4fzypUTlhUarWBMlVRqJAOqPAY8MD3/iuhWNrQdqUrrKikY+fQN99Pb1sbRcTGZNbd7vfqr553XZJTi3zsSNYOyM6j1Bz+Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB994607.namprd04.prod.outlook.com (2603:10b6:510:43f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Wed, 7 Oct
 2026 13:58:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Wed, 7 Oct 2026
 13:58:34 +0000
Message-ID: <eb63c9f9-a158-4a70-b3ed-30046b15de11@wdc.com>
Date: Wed, 7 Oct 2026 15:58:28 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: unwind device add when sysfs registration fails
To: Adarsh Das <adarshdas950@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, mason@kernel.org, linux-kernel@vger.kernel.org,
 syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
References: <20261003111951.24527-1-adarshdas950@gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261003111951.24527-1-adarshdas950@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR10CA0100.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::29) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB994607:EE_
X-MS-Office365-Filtering-Correlation-Id: 317e8e5a-9ce5-45e5-75fe-08df247b13b3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|376014|366016|1800799024|18002099003|22082099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	fi9DQ/7pcnIz6tEFUX1oErYMcE7mjWAFT0JBf98wuTJlsbINLhah5BvT+zAlxt6YDmqf7ckv0TlMyoPJWkbbDqTnWYmn/Pz3ss6M0WX1M0gUXaJFHfp+Wr/0xo7MxbUx3mVl9E7CwIUXvUDe7gCimqDNQeZ2+t/1C9M+PI3Uo+EAArtWJ4Ov/4mSGn0jKxAUkTWF9QcQpq1ixVDzqInZ7deRnJYNX6fWCW/N1PyG92mpMzk/HLjYGgZEpIVr0KLBtOQ+sm/DAxryz8uuKzonqbfOrCJ7TCv2r4Cmq9nAGwZbIievlerxPToeXtL34/kaRrF5iNNywUXEJQQFvHqpakEXVpkhNx8vRzSeducHnAdcD0UVYBVlMEAAt43DHSVzFxRa1zcchEEirkrUmDSncEWUT/44/D9I2UafYEDffeVdmDKb8OC7+Q3IQEB7bXOcAf+XtbOA6fI30LfOPEsD69RVPvFqzGlyhLuKK97Thwyc9mPCgGC7D1YmpnMaZJUH8p/dZvHU3hrPs4wSluiYokutOLNxzjNkf0od85ikgK+GcNVwG2IEyFaEXPg8TvDXrOiFrG4TuWnCzhDJ+3imvIq3viVjIlzUSV1Rz/Q9CGHNzzRMLMTHN7inT8QjStBT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(366016)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGZYOEo5MzFwWjdCQmNqK1pkNy9UTDBrWDNDNE5KUFNxK2Qvb3A0UkxpWmdN?=
 =?utf-8?B?bEp6MHk0KzJJN0FjdGYvOEdTcVc0STl1aE81VkNBaTF0ak8zUHBKUUFGN0xB?=
 =?utf-8?B?R0lsM1hRWTlmU1hTQmdBbnRvQnc1a3NTNDdsSUZZblk5MWU4bzVXOW5jeWp4?=
 =?utf-8?B?cnR0YUVyOUIxK1dLcGx1R2R6Mmw0Sit5R1owaFVkUEpTYkN1ZU9Wd3hic1Iz?=
 =?utf-8?B?YTBCajYzc1QvSkFGZDdoVDBIdGNYdE9maVpmd3UrV3RtaCtKTkxqNXVlZ2gv?=
 =?utf-8?B?YVFLU2w3VjR1WFpwUnhQRWFzNjBJSUZ0SFNSTzNzNEx4TUVvTDVzbTBFSTRW?=
 =?utf-8?B?ZktvM2dZOUpUNmp3SHdWM2s4TXhIenhCQlZSeURJRHVzQUxPV2l2UENHUEt0?=
 =?utf-8?B?QVFUejZMcitSd1ByNkMycWRnZENyTWZnZlNFejBOcHpBTCtrSG1lSmNQV09v?=
 =?utf-8?B?MGs0VGE2dFk0amRuYStmakNYcWlSVFBCY21aTU9Ocm1PSnN0U0FRSkRYb3Jl?=
 =?utf-8?B?YUt4ZFZGMkJvQW5ESWs5QWh2T3JKRUQ5NllDK2IwTEdOS2xrcWthRlFPblUr?=
 =?utf-8?B?TDh0NlM0MjBFNmVCVUZLNmdrTTA2SkxLTEZ6OEhTZjRwM1JzOUY3U1RrRTUy?=
 =?utf-8?B?NllSM1VlaGc5WFoxSVlWVXN3bWJUbmhKYjdKMm45K0pGT2VCZ1lyaG9GRjgw?=
 =?utf-8?B?eWJwWGlXbDBqdWZUbU0xSmhCazVoc0tYNnduQ1lmZ0xSUFNJNnV0MUZSQ2xv?=
 =?utf-8?B?MG15NmU1bUpPS1NiV1ppVHdtYi9MWjlldEloaGFNbXZNSFRXS05vdXZ5cXMy?=
 =?utf-8?B?K3cxTjlRYzlpWjhXK3lFUGoxZTRScVZhcE41bTZMbFVvRit0QkJSd2dMNXoy?=
 =?utf-8?B?Ynp0eGZwMnhkZmdhclNDL3BpZ2xFR09RcjFaNDZpNkRQOXRZVnBjSXJ5VTdq?=
 =?utf-8?B?RWVvRWlFeWVlY0ZBMUxlZWN0bEozeDE5SERpaVJBeG1JeW5abThORWcwWlVB?=
 =?utf-8?B?ODRvWVVJeUppVVErTTRMakQ0TE5idUxkM0lXU0xFQ1lPcUt5MnM2RlFub3Nu?=
 =?utf-8?B?a0dsdzFoTTJmRVdIS3ZFaHRLaEJQTktqUkhhdnhDS2ZLV3Roamk4TjhSdG12?=
 =?utf-8?B?TFN4S091TDltY3IzbmR3aWE5b2l1Mm1QQkRaRHpNZjRpblQ1d2FYWFRuVFdC?=
 =?utf-8?B?dENmdjFSQW9ST1BJTXVIYzk1eXZRY1dvNFI0MVVPSFI1a2hNNEpSSE02Z1Ey?=
 =?utf-8?B?OTZTWllGWldYOEM2UzFva3ltcFl0Z25XeUw3cWk4ZkdteUZHVHZQb0w2N29D?=
 =?utf-8?B?VXVqR0VpVUFrcGRpeHJkZ0FXUTlHVzZJZ2xyZTFJQjRGNWRmVEFHek8rZEVz?=
 =?utf-8?B?MGVHTUhHenhkUTdrMGF6NERBZ0tEUngvSEJVYTFheWc5Si91WUVhVlZUUXVj?=
 =?utf-8?B?NWtKZEZ6STRNMG4wWTl6ZnZJempXQVhLUitMVURCTS9Db04wSFFDcGJvZndE?=
 =?utf-8?B?M1ZYV3A4N1Q2ZWwzM1o1WEI1UXlkODAwaVRGd2RUT2ZkNW8vbktlYmRsN2gw?=
 =?utf-8?B?NGY5bThMbVBmREtySjFlLzN1bTVwN0xUMEJsMVpBUjcwMmRYOGNwWWRjM0Er?=
 =?utf-8?B?aHVaV1d1RzhTMjVvKzhFM3ZnTEpwQWZoUzRjOXM5TEc0cnFVeUtDR1M2ejFm?=
 =?utf-8?B?T1NTSlh3NWQ4dlRoL3FTZCs5V2FWN2wvdXVGQ2czN0lOK0xTNktuUTRKdDlB?=
 =?utf-8?B?cTg5eExxWUlhQzJWMCsxNnNzdlprNk5kczBHY1VkY29PZkpoa1lkbi9lOE1w?=
 =?utf-8?B?K3R0MElOamdTY2RKZjc1WHF5RjVJV04rYWE3ZEIxZDl5VHBSVjRocjg3OHZ3?=
 =?utf-8?B?R3lqNlNtQW5Qd1NqSXZUd0hSRUtYQmNTVEpGUkg2RlMxcmpWbTViaVUyeGNE?=
 =?utf-8?B?cEJXY2ZRVTkvTFRXTnk5TWhISXVSUHpmSkxmR0h5OWVSdG5MUWxjWmlNZVhG?=
 =?utf-8?B?UHJUZ2ZHS20xcXhCd3VXSHVEOWE2Z0QwNDdyaHk3aC9TUytOT2NrY3I2YlYr?=
 =?utf-8?B?ZDhxa1I0TmFRU2pjSnoyajJ0bUtLb2lKZ29vaUZFejB0OUNkV2pSdXB5dmpa?=
 =?utf-8?B?V1gyZXA2UEFGUU9WejlGNURGS1ZPcldkL3BFNWR2V3Q1d1lqWGpJNVYvY2Uy?=
 =?utf-8?B?Ri9yYy96SFFINUdNMUwvQnhyTWgzdTR1YUkxejY3UG5mN3FsaWYza1pSRDJ5?=
 =?utf-8?B?bnRIc2FkelZTdkcyY2ZtMEsrdGs3R3V1c0NJOEkwREtHVmNxdnRzcGhvcVFL?=
 =?utf-8?B?KzdtWGVBZitVK0NPVVFRNkswRTRxUFhvU1pYWm1UN0E4bTVEY2tDdTBEQVF1?=
 =?utf-8?Q?jn8h1bNGmRHGmr00=3D?=
X-Exchange-RoutingPolicyChecked:
	kPb9Fi5h2E4+nF3piwXQqErCqbDP5xTUkVf8uou9OHzAV05IhWrCzaj48CMWnGEO7MC/8753YsJuzmMtYeF21J6rlMoBUjSQIF/eK4GsKUcdMNw8OZwH+6256W/XT80D5d70QyIv4hbMVFOdHfCxBa9n0A8hw4eLgzAc9dKFvFRVcGS3DXFFiiy6H6gzuj8NJkme+vWBbiJDqw4RDZy9K/DDJr/o+LNOXcTOu3x6EX6lqdcVv9GOUKz7DdugETnGhM2JW9uZnRU5zbAcCSUfCpjIIi+rgykIN1mq6YXXAhywlv7eqwIcfY2jYdl4UZsz9kv0ICXPFoBCfDoXjdeSAA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ggCO2oW/hrU5OrRx6P6ppfPP7d5ggrxGaMO89+3z/DNET1sJn7ZKSmeeYRGUcZwY0Vyl2GCSDquRsiA76n99Cm3FSMxW7boMyD5iZCipmZmIYl32WXinaE6W27yeppG7XNlzVJZVf9VKBQCBHbUI3IVZUgi5xmBC7ryc83ceV5bv7/r2YyoiD7/eGd4rd+/9dcarHez4u//gTBkwRvR/9DSamw1ghm5Azamc57C2QzzE0/On1Fz88/CPJRyOKQky2I0bM9YIs/jb67JyYojlIRaBM4/vjB3oWavrUMSle2kOpaB6ZBDs98p4W4rlJZV2XNs/jtWtlzlWk90gO15d8/VEYyjihQ/iOr946iUsAJiiH5/ucc+t5i/rFTnO5EstJJEgyIVj/UPGRS26tic7GDUdx66NVBtw6o8IhckqB1oPKvVMGVIEzdcOfxiyFYcMAAot16t/p4fOzNzv1wAzoOb8MIW6ey+D3V6hFR/PzIry6P3nD0oQpXdTRVNE50u7zavvevKhGYVeVsWBkCk89YrajYX5+5brDXwHJIKcnC4mzsx2Dug4cW3YDSMzHVa3zumDpUPcyNeyKn4TMMrOCjt1hJidYFHHLVPzm/o9QXKDtfNRYAbwPuUmgVuVmTfU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317e8e5a-9ce5-45e5-75fe-08df247b13b3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 13:58:34.2413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +N7+r5Y1/GIOpSEeHOcdASjstMLHTiSbKA4igw7ZKXeCIx5kYChEUFs0po7ANz/0S4CqK3FHoP7KQpWJMRj6MMv586OiPYCjA0Z+/LyzRv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB994607

On 10/3/26 1:19 PM, Adarsh Das wrote:
> btrfs_init_new_device() ignored the return value of
> btrfs_sysfs_add_device(). When sysfs link creation failed (e.g. -EEXIST),
> the add path continued, aborted the transaction with the same errno, and
> tripped WARN_ON(btrfs_abort_should_print_stack()) while leaving the device
> half-registered in memory.
>
> Unwind through error_sysfs when sysfs registration fails, matching other
> failure paths after the device lists are updated.
>
> Reported-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a791c94.01d0871a.3a0d52.0099.GAE@google.com
> Tested-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
> Assisted-by: LLM
> Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
> ---
>   fs/btrfs/volumes.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 85ea9c5d4536..1517ed3da22c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3066,7 +3066,11 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   	mutex_unlock(&fs_info->chunk_mutex);
>   
>   	/* Add sysfs device entry */
> -	btrfs_sysfs_add_device(device);
> +	ret = btrfs_sysfs_add_device(device);
> +	if (ret) {
> +		mutex_unlock(&fs_devices->device_list_mutex);
> +		goto error_sysfs;
> +	}
>   
>   	mutex_unlock(&fs_devices->device_list_mutex);
>   

Are you sure this is safe? If btrfs_sysfs_add_device() fails i.e. at 
sysfs_create_link() and you do 'goto error_sysfs;' which then calls 
btrfs_sysfs_remove_device(). That one then calls sysfs_remove_link() for 
a link that was never created. This is only working at the moment, 
because sysfs_remove_link() doesn't check for errors of 
kernfs_remove_by_name() (which in this case returns ENOENT).

