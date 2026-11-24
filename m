Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795502455;
	b=FworVT+obBcKq4CAEqDVkIlSRh/QTa1LMcM3xUmQjbXlCdo/GSiANwkle6fHw1ljXMzn
	 IUCxClJA6M4L2rbLx4Yvopp53WlNelRX8AGkTyiJ5s1k/Rb3A63t2BkGylRBNwQkO7HCT
	 XaD8LC3/Uhl5SbYWFny4eGSe9HS2DwkJVJEoZRgA0iqcBmb7kRD7JX93Q4yaJ9OPDdvxO
	 PPn1i+TR+NP/zUEmCwO2/LYQyOLQFZuLHmeTff0bKQclvec0Os3WomUnTz1jpA98ELgSn
	 cDucI7ni1ldqF+H0dL2yJyjxY6af+ws7QBrb+g2FeSELLV6VJgk1K5Slkq8OOectXkQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795502455;
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
	bh=f1ftmYhRH0bui8M9XqDADxxa4nhhiAWuCw9vbk5DdZA=;
	b=tS+l1rX9X+Ou0aOXqcqsOwcQkxNOMoIzhxDNS0S1JxJ4anfbY2MGAAJhN57NwsM/5FN8
	 EBYda7szKapsb7RV9u0bILS9wTh0XpPGRxs5h2ekDn+ck/bXFpqzUjTnI+bNwVNzjCuft
	 /hbHZxwWg+zTHC4zcsGvrKC+6dAClEunZaI9EsVyBHBITjQ2EONM1Av0Oq0bd7Fy6C6u2
	 fK4z/Vd8PJg/MWNn4S3YH3ibzZS6a+fL/+H8n45Db+S4teYlP3aHR6NkOrIVDKOZ7A6C0
	 zYeCNURkR3Rffh58GamlWi+GzpApc3aAMtXnaEueeoJQ8HZ0wMjgTFD4pZ6Xv908DOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qnyqiWQH;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Z4uLX1lv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC53606A327;
	Tue, 24 Nov 2026 06:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFC53606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qnyqiWQH;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Z4uLX1lv
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795502454; x=1827038454;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f1ftmYhRH0bui8M9XqDADxxa4nhhiAWuCw9vbk5DdZA=;
  b=qnyqiWQHqXj6zmkJXzgu6OLLRVZ7pMX5xOZ3CB1Tt+305/K/mfKsXK5g
   0q3i8wG19950fDl+UPej5EP2ZMXG+jefpT9JfBk1eLtnLh7UWzyuidm6E
   2+aYcLZDMnsPAxpXk466ddqEtIPLETS64ECDebszTZtSry+InsRWuzFje
   d8uQ82mVtGALmUzos5Nkg4Sh940Ej1CoQP018ip8svg0kYABbTXa6E+Lw
   SAr+ZH7zj0SCHecE+1UFoG2mgKWRpIi7hGFnT4ikniz05BPSotpV2dhLr
   EMzXsquLtWbTgCL7sc85nGYyhAp2ivEEpezSLjdHTDlxkHDotjebRL2GP
   Q==;
X-CSE-ConnectionGUID: /GkIKfvoSMyMTLlf1Iv/TA==
X-CSE-MsgGUID: 2xwECXyJQlifDcwHdcSaNg==
X-IronPort-AV: E=Sophos;i="6.27,230,1786982400"; 
   d="scan'208";a="160653891"
Received: from mail-eastusazon11012040.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2026 14:40:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KE7jsYQ/xu8gDgCjPFZ3qjTm/XPW9o8IDjA/ba7fcfJlkEgyAqSV4phlbHrb4aNHiRDxUtHYoC9xbFtmADw2cP0knA3vkBkILY6bdmj5sKTw8sjTjIJuJK5WPir+2KM+d+Dc1cv2ZCL4kNaw913ApW5XUsb9yPmApu+GoSs3rb/lUOPXGOGobF0mLC/4eSMm+HieslK4FufdKuzz/cdinhz8ogxjrk7AbxNmbaEiZFY3vnNsTbYSOprU4XILEEnuGX/64gfPc6YiPXy5S3ACdG2Ky9eSXySU0Weld+B6V2caAozeJ6l7FwYD/zKW/OUl6kQapeCwETcfyarMTLpL2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1ftmYhRH0bui8M9XqDADxxa4nhhiAWuCw9vbk5DdZA=;
 b=K+fAxDthCLe1nVKlq7X9oFxoB160BQAl2SY+lKH+Wf/SWRh62jd5fSc2S+uIaiy6XbJMmh2Up59WeUf5OCdF2tsaa3naLpk7LZubf9WA1NbWv7JOyrOep5DSrpQgzpVo0hC4F9uaqZFqGaCZ/8YuDbOp2W/CE59t+LjPOkP7kVGPnl3gf4Q0IfZkpkMPl+46fqzJAX8GRuy85z/ZnEIGMKWt1t3Xull+ARiDBdBYtlGs5Xbn0+lDTnAn5SObtjtrea5kHmJDIHrboSTsl9ewwJcu8ViAdX6Hn3WSuVZXKdDrSVcvyi8Vg0oj0t1s3xYFWJw86mlONPephuuy8rwuEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1ftmYhRH0bui8M9XqDADxxa4nhhiAWuCw9vbk5DdZA=;
 b=Z4uLX1lvM7JgGr1DWLCLO3Q5CneQB+K9oJ2W7CwWlQg+wVWhcXgc6ElxQqlw+o2yzCstys3simNhL2vbK4k5NbpVucYOwxmlSnvMvw+5t/FF22Vs6C30VqI+wIj+ZRDyRu8gn+NTmK85LSI+ganxyr8ccyiy8bCcFtuaEM+cApQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA6PR04MB9297.namprd04.prod.outlook.com (2603:10b6:806:41a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 06:40:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 06:40:51 +0000
Message-ID: <50046df7-9a5d-427a-9a3a-79a77eed48d3@wdc.com>
Date: Tue, 24 Nov 2026 07:40:45 +0100
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
X-ClientProxiedBy: FR4P281CA0370.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::16) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA6PR04MB9297:EE_
X-MS-Office365-Filtering-Correlation-Id: a6bd1d50-11f2-494d-723e-08df49f5e168
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|366016|1800799024|376014|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
 QvHZzauxBAdaprJAkG8hwYqyJhTwrXJ5BckCm0BoA1iK3RIn53Ya4EFyhocE9WLrk4qP5IaRYBx9PfdX+VHSInNjpYDqL63laz4LoDPIbKX8hf/ouWhMRrSX9cePoslFCdrTonl7WO2g3CpQWjgsj5eCl7Z1BA6A9cRI8RjZQXWQTRsezQX+STpXPh6iTymjb3qxJSlZtn0N/5Vo5B7GWY7TCJ2lm4MSEiPb+f+sxaR0B6JcGY0UW8iPhsvrchBDnHVtgQm+tMKt+3G/UxH/jjyao0ltwFgABIFK99ic8yiRvsRvisgCQB8NKdI+OnqI37Y9H65Si5P8CAcH5Ay7HlIPOLQUss5r4F7I/4xwruZ3LkObFEkuqo46ThWhKAJctNZIhitvkTFyEa30AeP3FHxVDhCv7GKyqXm2ittqOy1BHbGtp/tOYZW8tMKlN00FSp5xAUPK68hpNcuIt7NR+ab5OVHDqoITwBb6wSmfeCk/Pjt+YvgQtnb5rwVWsD5pR6V/1M8v8F1heW3vU0MHcr/4S9hH6VKl0bUOaC7xA03kMEJTTUAbP82z1V4ecTKGzmiY4jpMsANGcRvv+YEkmmNkUDTT5FjP6bKhL2sPb478ICM1jb12g3+CI7Dl/kjx80SILrFT+lU+II9fsFwuTUh3ELUzne+brahQvXBVmEo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(366016)(1800799024)(376014)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MkxNRDlDUGJ3RDNPeVd6a2thYlpqZ0poczFVemRjTmY1eWltVnc1Z0FhWlR4?=
 =?utf-8?B?TkpYcmRZRUZiOGQ2ZnI2TUM2VmNQMzlhREJ4SzNMejFXNkhjWnZ1VzZkNlgv?=
 =?utf-8?B?R0RrUW9CSUJhUXhNYmlwRk9pV3VwdnlHOGcrMjFFaWYvcW96ZkhoSGZvUlBX?=
 =?utf-8?B?SFdJTWtVd3liS3hzczYvYUg3VHdtZUZRZGdhOTNnRkR6UFZac25iQy9EQita?=
 =?utf-8?B?by8vQTJnQVM3Z0dTQi8vS2w5WHJrcUNxWEg3MTdDR1l2WWpFemNJZmw3OUZy?=
 =?utf-8?B?VURadHJuUEdiQWYxMUFzMTM1ZHVnOG53dTluYktnckhYNmVvNFBLTXZ5K0px?=
 =?utf-8?B?VzVxVUM4dHB0djF6UENNOEJzMGN5cmtpaFBUclNYV2srRGI5V2VFR3REY0RV?=
 =?utf-8?B?RE5rU1pRYTB3c05zdFEwRGdQSFBNK1J2Zm9uaXhTeTQrRHBaamxySFpaM2dJ?=
 =?utf-8?B?OVU3U2pOdlMzL2FUYXB3RG9JdmhkRHA3WXEvOG0wU1NIWXdlS3dKc2VCbWZ3?=
 =?utf-8?B?S2o4OVlMeXJxUlFGNUUza2ZmMXFSUC91MzQzSHJqelp6bkxMd042V1FxdnV5?=
 =?utf-8?B?dmQxdVJ1Qi83cWVBS09QL1F5S241cmNXaGxqMnhFOUZkd2xhNXVuaXBqaDE4?=
 =?utf-8?B?b1Q2elFycnlQT1Q3KzE0Yk14bEt1czVNbGFpU0NKblBNTmZ6Qms4U1RpdGN6?=
 =?utf-8?B?akxVWWM3YytmRDF6eElMSmhBd3dLR1hBSkJsTXJidkRRR1pBeFZtYVM2OWtC?=
 =?utf-8?B?RWFlZVExcXZ2dEQrY0hKajNmcXVRMXJEbDEvaC9adDhkSjdKQ20zcS9CR0hm?=
 =?utf-8?B?TjRPRXY2SldEN0Z5d0p1SFlQR2UxM2R6c3BVYmhPanBvWGpHN1Z2aUs2eEJD?=
 =?utf-8?B?WkluYklTU1V3Y1p5YjVuVDNjb0haU3hFcFJxeEY0ejFHa011T0VrK1lhdnd6?=
 =?utf-8?B?U1V3RmI0NFBaYnFTREJvL2dpbUZUM0ZZdGVKWExDUkFLWFBoU0poMjFuQzZs?=
 =?utf-8?B?KzB6WHlHbE5lT1FLci9XUmF3RXdzY0VXTHB0WHFURDlkcnAwTUNGSjN2bnpl?=
 =?utf-8?B?ZGpXaDJVS3QvSFpBUWlYUVZNV2RrM0xBOHYyVmViMFN4QWN6cit3TjN1WEMv?=
 =?utf-8?B?SUg3T0NpNWtiaGVYYzc4Z3NLa2NVMWpleHVUYU5OcWg4MGxJcWxhOFpFZWpT?=
 =?utf-8?B?WU0vcCtGbHp4SU4vWkhsTCtVY3c5ZUxBVUVzVThKYnhUWFRqVjY5VitVdmRO?=
 =?utf-8?B?TktVZjRUN1pwcjcyYmdRMWJOVVFka1p1bnBlR01OMUdYYU1SdTN0cXVYY3ZD?=
 =?utf-8?B?TUpLUVp0S29TNGZyVXhNdU9pWDVFUDFFanM3Q1h6YXM3eHE4STVFU0lSM0k2?=
 =?utf-8?B?Mkxwc0pBVjI4OGVRWTBrZ0d4WUdyenNVelh2VTlwQ0UyRHU2bFVSOEowVkJU?=
 =?utf-8?B?L2tVaE5acEZBTDVCMFhTUCtOV2tlVXVuOVp3eklGRXQwWE0zMXNmZVpiYm40?=
 =?utf-8?B?Uk5HVGVpekpkQmZHbkRGUlluTXZNOStVVTJ4RXZPSG1IOThyV3ZodnN2bXg3?=
 =?utf-8?B?OXB0UjRKdnI0RDBmMGQ5Z01tNGl0RkhPSU54MzBXcHkzdEZjem82M3k2U1I4?=
 =?utf-8?B?b2VWZDd5WFVnWjdsYXR0bmZNQjM2M2NQMVd2WDhLWk1xYzJOWk5QcWpRVE10?=
 =?utf-8?B?QmhvYTZVTWcwNGVOY3pMUExCcW1ZYytGQithenNBZ3pFOVpvdkpSdER3US9m?=
 =?utf-8?B?ZVhhVzQ0cjZKdGZnYVdSVEk5dkF5NGN3SXoxM0phVmViYVQ1RGIyV1hkUWZs?=
 =?utf-8?B?NWovd3hYdUtYMTR2K0EzWG5hUXRoYTk3TFcvbnBCYXNLd0MxUTNuZ2xTdkor?=
 =?utf-8?B?QnZLK1c1MHhjY2lYZGViOUVtUmhjWGRnUDd4dXNOeDNOYkpPdG02Z3kwNERD?=
 =?utf-8?B?aER5dXZsU3VQVjR0a1k5Sit3bXhKYnduU1pKakxodXhjQXRyd3ZWZWVxVU8y?=
 =?utf-8?B?Mi9laFByL3NLU0JpMDZjemxESHhldFk2TytQVTVXSzFaNGx3cTAzWjZIV2hx?=
 =?utf-8?B?bHNzR1RDTVdiZ0JEdTVMSlE3ZzluVERkRzRyTHV5WE5sSVBMdkFBdUp5L1o3?=
 =?utf-8?B?dlRwSnNPVzhkakpHU1g3cUo4eVU5UktoaXE3a0lkRzFvTGV0RzNST3ViT21Y?=
 =?utf-8?B?QVFLZis2VC8vL3EwZE5sKy80VkhNOFhIODR4SGRBY1BiTFcrVWFJVmprdUxj?=
 =?utf-8?B?YTlJZW5QSVZmM0VuY0RPaTBWWmxWc0pwWVhRSnFQOXpIWTc0OGNYc0dYT0dX?=
 =?utf-8?B?aWp0bWhVaFJHbktRZzlVVnJRaER2cHpYeE0ydnpzUU5yREU4MmM4V0NaOEZY?=
 =?utf-8?Q?/UJmHQvGE9d7UVoGHK5NzGSAsD7t4Jx12/n5OCmpstTem?=
X-MS-Exchange-AntiSpam-MessageData-1: pjlddmBEK7Y1NQ6mBrsXC5n2AbAyQJk0sMQ=
X-Exchange-RoutingPolicyChecked:
	k/fRwM1B8op3AvmjSnrqncH9GzMqtl6GwdChV5/C8KidkD71+P/qzfTGJMRDsCiqUaMQODvfdEKm5T6B+w4BY8fBBVTe0mZli7t5bXnZd+A3C0wBwfKkcpCL5b0CE9vLSfROJ/Big2t4QY9d94z6GA+bxZg/j/goYNg4A9dqayzi6jEZhpEMjPfrWug5NSFYii6Oya/K4kOKmEgkO4wS6/gvHmFFmizxU2pIbGjFA/gVkWVcYqDM8VU8c5eFSWlJ5Syw9ji9eU8HSzJw2M+KXm+PUvenZVO8q00tSXMt2Ce0KJKwU/77fcAmfb0VBQMsxTfWUYN53bM7qXkhChShtQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U8dqi/+diqmrjZzUQC7O3emU+g0K+pTCThXW42iTuureAKDnFFK1zoilMRHRamcWgBhqjR1F1IqdK3BC31w6DGxfY6ueAkZzvUAphxc4Es704Zg7ZN0TCwoJhfN4VOuW9NJv3/ZuRBqGnyjtVjvdT+a+3t9qXXasva0jl0jUfSCDBbey/C/hnBnnO+/hVnp0UTVHlZhXna4BXTTs3/cYUUvzNpJ6kkPblok2O1HFlzQRxsXla7jUxMFBoQraKtHpiEfkfZ2P9sms1Z2DGnl79bZrMCMIfF58+KArwqyi0E1+JdKmzZcprdGlR3yKyFDBfnFykk+0rvMRgJ70XONfh968Fqc5s3WhiLK4IMjKwVp5fkZ+GJXLe4LIrt6EQ8gXrJ/SEgAZ7dgcugTTy4s0ZJyd3PhPb+mQVY1Geon6yXNKptq71j8/EVYcRUIOQbJJNPZyoarEQIgqKGmuCINikCxSJwU/5gGq4evmrRtKABKG/TMpQum+UGHgRHrcuBX6khiuNEk+4dSOiR18yaCU7c7qKRP0FzJ8WvFTDZjKnJgfTfY243DYIIdHfmJo/JGoMNnluyJUE5C9fk8zfQ3uo70Yn10xcLF9s0k0aANBMDeXkCA8T2ddtj6LcORWrzAr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6bd1d50-11f2-494d-723e-08df49f5e168
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 06:40:51.0109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imv1xvRoy5A2Z+x6yS1bVfwnWcXUoT/JMEqfT7NM2iWi2f5MH+M8hYijD4Yr5tm5dtd0hbVPaXmt4jnzqyfJ0WK1t2jjizkrdx3mzJOiJEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9297

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


I'll add it to for-next later if no-one objects.

