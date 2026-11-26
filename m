Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795707511;
	b=GrO5L+ieeciok7cL7PfjnTdZnjQEhELbhIvqueLZFgvqOBvcDYXza9sw1PPjv/gUAUxd
	 TTT1HeUpyfMNuDbytDVRNPX3/YymkqjXqpbXix3P7vh0OMrJUnjR46f86hWj/a5JZXI0h
	 JqpB8+7SH9yvsMpMG0NkdJV1NxZC7oRL6rlSn+CNKr+Ha7P3A++91vmU54C2X4PT67CQF
	 Wep8CCaDAw+MxMYI2M0Ui/675vyN/EF7a0VazQjcMpaf21CBL1UeqNPu4tEur4DFDsrdI
	 rPEddZ+hrqvuxJHpKIzhit57v9ePOJ/HLcjZ5FV9hJZmtHJSud+FAxG4xzYoy+1ChOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795707511;
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
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	b=fkPPawwZGfVDc6O8K2OMccbUFETxSRKOAgcgXkJ3x5CtmFtjXai9G6nQN2G/K9k5q9f7
	 FuSqNRvB0opgmNDJcG1HgM3xLGCBhdFxj5KzS7l0HuK7NUUA7jpG89nBaYkNFwywYohhM
	 XdvygmwbnC3w2VmGLK57NRGVldTWGfIy2hXiU8sic/3K7IaFvuFBnWA+FSH4FwhPSv7eM
	 ZPFAJY9fyU4Ww8dEE1SauSIAJeBhOvYTPWBm9VKdCSUnYa00zjVAb+D6TJ+cyHbWZ72Xe
	 qLUHBID256VlLaADZ44C7BFtL9/f4EGLjAiuwtJdJwA0SXRpsihUaFNbx4LR2YrMlKA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="jBv0QuA/";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=KVMzwohz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74607606A31C;
	Thu, 26 Nov 2026 15:38:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74607606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jBv0QuA/;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=KVMzwohz
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795707511; x=1827243511;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=jBv0QuA/R9b2qtnmkL1dkvetDWHmt0DRcKIl2rk/Uxx2ZJRsN8SV1lPy
   ypNOcm/2020mt9BT3vIw4XDt9a8X+NfubFD2sJd5EUZ3T3aez6N5LycYH
   kRTvE+abt77Xp5Ccs3F8G0v5FJWIT49ZIBo1zOZaLvcCNL7SnAa8N9Qsz
   JHoVPyjTQBBnT5hMvrINUCbCFVZ0z6/6G87tUp2FXLtwHd06BPXnYStgY
   TMqEnHaUWeEoL4Uszyt6Nmtr4qyuO1IaC5ZETDtsiIGRPbMB+WiId2aJ5
   5BHgTd/Yh2+FdvHEqbN+oC3SJJ0SEMXgyWfcS9QINMTqnHE1qvDjORYBd
   Q==;
X-CSE-ConnectionGUID: ag31ASQAROuf+HFi7xpa7A==
X-CSE-MsgGUID: NbRNIV/YTMq7HI7BEUTG0Q==
X-IronPort-AV: E=Sophos;i="6.27,235,1786982400"; 
   d="scan'208";a="161768332"
Received: from mail-eastusazon11012070.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 23:38:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gUSquy9vt8XrW4jAKsd+ppeni25NppWa2TCBhGsft3EleDnumm38tS+lz2Rw8aHPuvdhYHUpJwc+n8FWm0IeAxZJ49c6o0s6QQ8syTM+TkoAg+TADd7J9EFezbVGzwlEwytTm1apoDNFljRhb793ZIJWO6kdwEQAiyVjw3cp0UQeP4w9KhDW3AGMv9JXaJYSQKfHMAkNfDWjjK2INAr408VrFWJA/w8jwfJlow8THZ82j90adcQABFxCiaeAhLgS5zCkc5U5XuX8AOMw1Ba0Rc5ac2Y7wpRZIdNL3bcVz/EmHNM9GBYpcB6rCMaMVTRsgX46S7TvXsgTaigrpPzFhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Whvp8KNOXYv7XSMXOIUvzFm08OOc96L5vxGzpi0BR7p+WQ6Oz0BsByVweN0vHmkFwvI7RbvH1BxQAExM4wY9FyKJJRLXmnWCTGH6gq5vQkI7nWSNJVdpu7gTyue+WuyuD6EAbdWP3XlgSq02LKMDwzYzIVWzyED26zxHwk8vLUhAZcWfUcYv/4zbQOtL7aWpY3cSEvRC3T3cZ02oIOeeL9gtt5YerIlWvDFZ1dVipN2YH96hP9Nr7FDCSpaPTwbzk2oan/E1VQ9YS0cN7t1DE93TSg4Go+aqitnfzCYpy3lxr0/KeqYZ0ulXYYrDuyxvWuS1n5f6paK4cutCSRNNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=KVMzwohzmln67+PRbvnznSf7YCyMxLV/ZQNsxrJ3cr57kwV6d82uQL/0UWEwoLm7d+YUiV+tJIQiHs34NaAAO8EUJVYMuJvIrDBbIpQtp0k9ajSZtEhLobpqIxcByESQdCRpmzU/cMevjHdSt5CL0vApJMYXBnftEnBjNvSeW0w=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993738.namprd04.prod.outlook.com (2603:10b6:207:301::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 15:38:23 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 15:38:23 +0000
Message-ID: <e4ef898b-3414-40d6-a2e0-488edc08280d@wdc.com>
Date: Thu, 26 Nov 2026 16:38:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] btrfs: zoned: tolerate a failed zone finish on a full
 block group
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
 Damien Le Moal <dlemoal@kernel.org>, linux-kernel@vger.kernel.org
References: <20261122232310.4099580-1-mc@raidlab.org>
 <20261122232310.4099580-3-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261122232310.4099580-3-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993738:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d7cfd6-c53c-4cb7-9f2b-08df4bd34df4
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|23010399003|19092799006|366016|10067099003|11063799006|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
 Q4gRIp7eT3nsNmZgza/ATo8f3GFvi5cXe6H/akwGBwMQgxuRyXXyi9xFGkBNjfSbMUp6sm7rh5koptPj9eZYGbUfpk26t93tAs3N3F4kzsHSzp0bgFBDodyCES3ta6IPxmNkd7cVZ02rZ82Hq2tUUynVQgY5a1+QvirE9vSMycdJpUQfO49T3YtlCeDqJah5vux22eCb8D1PX7kzJt7cMqbcVPs3xRRDFqYhsfnKraeY7C8nyBadu3ll+SSd9FVcxL6AzSwwqhQW7Zercz3khii0OjG6v+Jmjgeywgq6DN5MERDpwGAUGWdlUnf82qhlrrZZp/koFzLMv34jFl5w+nvmgX5LD+SndV6QAE8F9QAqWyTJqLL1HxTFczyAbNuf4CT4C9gtl9tVrlWnniCE/gH4wwNKr5+Ih7SoZQCXGmjMcHJgSk+uh596NDTDIjMpT1170IzOOZ0/zEYoX2qgQowvOrunsamzbXfRlZxmVi9beMeMsgXtMlORzLCJlKfTgxXKR0WIgO7dczAAUFWnFAip7WsG1/9uSpmb8i+Z8fTXBjsBQjTRuY7pavEzFsoZPmnUGwV5++1Y60563dyppb6F6tpr8FddJj7bDNYgRGHuomwqfzXoO4Ow13kAU84ed9ylI10TFL/kABJ/+TRP20C5fRtJ5zaGZp5SWULC3/c=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(23010399003)(19092799006)(366016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dGxaeXRqWURsb3BrRkxZajhXQ3ZDUGVQdTFKekVpVEdYV1BqcWlPV2huSXp4?=
 =?utf-8?B?M3F6R2w0RiszcHBNbUpHZW0rb1hnMVRPYXJkR2FxUThDZzFleDlUNldHaWNK?=
 =?utf-8?B?YVpxQVgwUFlwTlpsMHh6Qi8yUlV6ZVhwNEJneTlncGVnWHk0bWZPYUdORzQr?=
 =?utf-8?B?NlZSODJYalA0SGlhYkRsM1VKMGZtYWJLc2ZJbXBPUmI4ZWVtQWk0aTBwMGE0?=
 =?utf-8?B?SllYbVdjM0RDUTJVbUpjdUNSdEFhZUlSWTRsOVlCM05sMGxhWFpmOWhScTlK?=
 =?utf-8?B?bDlRVjNaY085OXg2Mnk0V3Bwdnd4aTBBQ1UyVjlLTG9uSXNCTmZQb2l5Y0Ix?=
 =?utf-8?B?a2RtTm9palpZU01pbG5IUm03VjkwVTA0L1k4VjJsMndRazZVR3pvRjc5ekxo?=
 =?utf-8?B?cVZmRVY2aTJkb29IMGk1Q0ZkK1JsWk44VElmU05uY1QyZHlNczF1WmVWTG1a?=
 =?utf-8?B?QnNUTDVLY25nR0tGZHJvdy9OS3Z3T3BnSzgyNms5SURjekMvVEtyODdwejU1?=
 =?utf-8?B?SmVUN0VXUmNxY3Yzd1FGMzdHTHQ5SkY0N0l5ZlN3LysvN2Q5blg0V3VmUDBi?=
 =?utf-8?B?VlVnUzVvZlFxdzl4U243Z095NDdnQ2ptaUVBNVhsbnA1ODlCenphODdRNkJh?=
 =?utf-8?B?MGg5eFFlUTFUbnNVNDFEd3lEWmtXdm5tRUtZOEd4NW9PUUx4S2p3NHdwaU03?=
 =?utf-8?B?dXZxcWFvZHFuL0JRdWZabEdYVUVCNWpyVU5vNXhNdUM4YSsxbElvcTlpVk1k?=
 =?utf-8?B?eHRGSFVHRUo3cjBpS2l0aW1tUEdwQXVNa1BrblB2WE5ZbWkxTVU5S0g3OHJq?=
 =?utf-8?B?WW5pYmJpZEcyNnhrM21EM1gyNVJPb2gyaWplUGhIRGhjRUFrZEwxOTFidktq?=
 =?utf-8?B?Tmh6dnNpK3VHRDZwdEJwT1BKVjhIT1VPRVVXWlpXY2Rzb2JDNkMzODRpMXg4?=
 =?utf-8?B?eDFjcFZLS2g1WmZsVGFNcXZWUnpKNHBIM1FIZzgvd1Myc1licDNIT2xEREpZ?=
 =?utf-8?B?bWlKQkNGK3hOdzE0bnFUNHE5aE51WWM3NU8xVElCZ1g1SDFuSFo5dmFyRlIv?=
 =?utf-8?B?UmpZQlUvUnNscUZrL1FBMDVkZHhlZVFNTzlNU0oyTjZvMkcyVVVVZlpqUU9y?=
 =?utf-8?B?MUoweG5acGVwV2JYS2luVnBYaG5hRW55RFlFTlF0b3F2dytBS2YyQUtjWWhs?=
 =?utf-8?B?blhhSEVtQTlRUEdta2FxZ2FFdk4rdWc1ZXhib09mRFhFaHNORXpXbXBEZUJN?=
 =?utf-8?B?RTdjbXY0S2dWSks2QnJtM2M3Y09LZ2MzdlYycTZIYU40K1NqWlZjeGh4dWpJ?=
 =?utf-8?B?SWw4ZWp4YzZsN3BXVU1Fb2lsaHozZWh5YkZEZDFsTHV4dnpFVVB0V1VmTG1E?=
 =?utf-8?B?cDJKVitkL0h1a3FhckJOTUkwbzByTm5jMDJFMFZKWXgvSlVabWhOcGpCbUVD?=
 =?utf-8?B?RzZkd3FtUzk4ZDJCeVhXZGNTNEdlTUF1eUpUUHRneGd5Rk9oT2RqaFhoNVd3?=
 =?utf-8?B?RGxEWkp2VmxHamVYQU5zSDBxSkkxdEJxanNFbnlETk5EbHlDaTNjZXdPNFRU?=
 =?utf-8?B?OUw0Sk9LZXlXRXg4bzhJc2hJVGpQTlVJQ2hhY3ZBVnNCRTdpTlRvVEVnLzFT?=
 =?utf-8?B?WGo5eGVTRTl1b3laS3hSdERVdkdXaFBkdW5rblZ5QXZjUktIWlpnZWZvT3pF?=
 =?utf-8?B?ZEI0U3BmRmlZZnA5SEQ4UmdpQ29rTy83NDlWNnZjMDFzSWRBdS8rYjQxZmNz?=
 =?utf-8?B?TW9wTzR4Y0hSMTBrbUcyekVuK1R5M2dGMElnYlpwVFFRTzU4NFFTQ01uL0xp?=
 =?utf-8?B?NnNKcTRVVG9SWno4Nml5V2FnREtITjhBL3ExN2ZXSHBXVGJWMkRycm5Mdlo2?=
 =?utf-8?B?TTJTdmFMYmE0L2VwdlJObG9JNXhsU2Z5RGRGMk5iazRRY1hVM3JPWDRwTkNl?=
 =?utf-8?B?K3hhcjhGdUNCeHdBQnd5elVhK1FBanlxQlE2MjlBNFluOG41c3FGUkJqcGU1?=
 =?utf-8?B?YitQeUdQaVdLamVaWEhjSExqUDl4QzhvQTlxVjNvbzM3ZGJkOUJJTE16N2Vu?=
 =?utf-8?B?aHVPYmZleXorVlBQN3Y5eTRvVVVjOGMxSFA1SUlUaTNNRWNaOWVCUnRabVFR?=
 =?utf-8?B?MGhWRy8xL3BsaWo4MkE1VFNCalVPdXRmaHpsRThPVHp0c2lXWUg5Q2ZEVnVI?=
 =?utf-8?B?RkZxM3dVYUQ0UDlBZWRIVGJqa0w1aWR1L0xlT2x2VGo2N2l4eXN3bkk3dE1t?=
 =?utf-8?B?bWNFTHFNaU9ibWhQU3dNeGtNeUs4ZjdSQURNZml4Zyt2b296WnlwL1I5UGh4?=
 =?utf-8?B?dmdlTEpxM1F0RXhvN1FQN3p2L0pUbWtEcDUrVDZiV0JUdUtLREc2T2FCSC91?=
 =?utf-8?Q?Sm9qRf/B9gV0T5IXwtXXZCkqhtG/iDfhvhYW1905C2K2o?=
X-MS-Exchange-AntiSpam-MessageData-1: Ot12b2w0nWiblG4WLprh5rOCGY8ytLFTP04=
X-Exchange-RoutingPolicyChecked:
	Ja9DK/Ex3yMMv58c1Sis6OdCCxXEEW9SX3MCox9zJhc6ePlnACqrdteOCAjDFLrfWCDMVi8vPA6YH6ygJrzHIeAjaVlK6JGA61iAxjs0ST+ujI4sRlbovlhsktUvcXdrV0BEuOCjr2ECNcNv2zLxTl8o+Xf7CJE2FtQ+dpVDd/xYc/2Q22bdTcCqXHQigyWu84QT8b/bFmRSUxLMpxrpJebp9ATWy7wlS0RtuPEetuQ2v2sD/W7pxxF/yLiFFbpKbsdxFq/1RRZ6oOCmIu+3U9EkP+bygzTF1cdPlVRg+wQ1aGA8UPTMoydkKOIYi10p/y31zgBlfWhv8fkK+ldi0A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	COt1N8t5AuoJoQNA9yTZrmQtqWBC05J5en4qTn736uugEhGu5fv7JOrBch+p5X7mM4LQ5+WIFS5SlFtoJgF1fkFb2MVd4P31Oiw7E9ZxKcNWBDm6dCkws9uQEij1z7jNBFJT0Hj5nFb+kefmLt9AkKqkyD1sFqZH8vFrFI5TAwYF2wvIXhHDDDZkSDubVxYQOqcnNZAc/gtBpHS21LYJodMqfFLmi2vobffCxhFjkbWX5l+kcE6jycmGhaf7Nc64DEP6g8H4ajLF5T2A0uwDOyZyQ0oX2AtI5M3qJWI6J5JrLWX4Nj621UTtbyNOLEdRqlB1kvTM2GKPFcA89oM7eg7aJe0yhMtVzKQXVkfq0aKt8C2SKAQ4H482mMgwxQedScyKKMVaKRjHNJ7rQK3uaR/TYoWcvcY5I0W5Ne7ejOPp0S7lWQHHgw92c9SLJ1gbvxPiHemlYGoOIcJwwQI42F6KfUXi0rDjvWo5d5/BMjh5b/WPG0kpoPtl1TsdDj372qalJYTiDD9rP/i7fdB7O/9RzAqbqkf5Z5AG7ehoXtmUFxEfvpxbmC4kRx9nm3il7eCxh6fquC0W5KMnloX8r4ej4MIwgCWbXSmrjnbqrjfh95OZnrzJ0J2wRcQpkIXn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d7cfd6-c53c-4cb7-9f2b-08df4bd34df4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 15:38:23.0317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZjckhDeGAyvE+ITR/+ZY8dkK8t43ImP67kiH71hEOnO8qX3fMDVgqcZ92Q5DpDrwhem5iX4UcWLQQImTDwYVu0JvlaFvuzMYeVya38bJr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993738

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

