Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031806;
	b=SSCI+Q1gwKrxoTkkg50tTEOM5U5xjsGQuVW+6cB9qayguRWNOCX9ZrHDbXqPGgMhqzXk
	 sD2RlaR/Vo1LGqfx5IBI+19xLgrGJ8FCGGR3EsCqhAV/VsrrVSSKgziiUPP8EhGyuFw9/
	 mdNfq25+6U18626bJjPyNZUiuwdnDKP+D03TSzB0qf1XPfHj1D5Sjr9ST0Kf9hzVLf0PX
	 fdowqs+bGQG45yT45jotQv4gqn0nII0K40K2yPdf7sNUTLEsODBIkiSW5PKmLblUH259j
	 WvD2KMAZrjml6Q67AL9Q4MBnzi/uRJ2a2BY14kuHLyKUcswB5nd8eHAdjbIy1jB6j9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031806;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
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
	bh=VE6i5xMZZol0yq6ba+rIecz+T9BQtZq1ijklx1sk4R4=;
	b=eirSlg3Mv3+eWGVVSy7n9jz7BxkSowATXIWUlG0WUNRKUwgtafwyKCUmisxg06scPYJh
	 14t7N4tHNsjh8OrhmLlX+oGFF8p1OknzbCp72doS1MIi8aMJGkWw/hQv9Y0RM4oPCpBPm
	 ol76gDXNkM4wRNl2TbfuQ3AhFhrjC0vupS71CEyIyD8ldz+/e868Xpl/Lb4zKKfQJxjQ+
	 GY889v+IG1y7QABYSCGXGD8nbnUMnqIK2ixarIsQSLbHCUASn1eiXCyXaqSBBfO+an7sb
	 DFPPd5Vv8fQJcjJ2MEXI37srEX72y6i09cX1eOa5uw4EYWhR001uTy3hfZjtk63pcxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="XC9Jg/Mf";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=zwPtkS0M;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31393606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:23:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31393606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XC9Jg/Mf;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=zwPtkS0M
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031806; x=1824567806;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=BCgqbfHPSwRTGXXM3J8OpQfR4nvuBOYVUtujJhq42xQ=;
  b=XC9Jg/MfhuCjF9lRxFzkFU4ybmfFIGvI4TlMqsDnH+Ih7Y0G81W8yiHD
   MEndysOMm0qENTTj8ZCoG5mXJKRgNRtvJbSXcoL7re5eiDIVWljean8Ar
   lhlgAzG0b65HoG27d2ue+L/2UkAc/ueV0Escl08svn+bEQ/nxZ90rk+6e
   FiqfBegBKuc92lT+My5M+ifpbuYkOAihmvry5dCvPYis33xuHqJgYcyzW
   G8DQNHdSrexD5g+JMCP6JY4DmFIgp1s5rW8aFW7BRnOOju+UBT8/YiPgO
   vpFsyznXnGjg2CwWiyKOx1/ewHmdMC+nlF8WYl0B2FR2iCRuj8dtYDDYk
   w==;
X-CSE-ConnectionGUID: 97CMVg4uRGGyqzecHZHRNg==
X-CSE-MsgGUID: yiQycY0KRKi4PsxR8XnI6g==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158069681"
Received: from mail-westus2azon11012069.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.69])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:23:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HSUh776xRM4vWCObwwEVgu9C0/VMFNAMjHwLf0l44FiXXC+AkIeNC0V27rBfHfZWIZzUUoFHet3vP/3ZPrprQI/XQQnzx114BGkE2QKfx5TKM4xQrQLrTjCQptWMy0bjurhbDPrXZrXlJEBkUeBkre+MB6Ze+5fkL4hdMUzJIvTTHZTqRfoTqeSnCcB+xirWcb4QAyrqy+IeLIv5oCDVto3YJ7YvgtqbLHHXSvwOiM+oAcwAnd3jDinkPRmwIV7aFlpB7Dmy4XjgStLk23aQ4O3U4vJRVaDj9B4rQMyfg9p4kwm64X8nWblG86k368D4R6INtq0TbcVYtSyG0nmLFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VE6i5xMZZol0yq6ba+rIecz+T9BQtZq1ijklx1sk4R4=;
 b=PW2NngZ5LBcMmpx1LHQLf4/f1C1M7n74QAny934j8gLr30jHNyr7DaRtQUgd03mSy7ObJr134ep3vsJH+gsWb/tiOgL165KziMuJflCpNm60aqLfiPGEIu2VsLpOyLf4mc7kg/IfBB/g8RzNSdEm8DffYqqiAISeya7Rr9TMYPrFCLFPUEogQzaCT6h9xl3IsBcVMuP/6+DsSnSmk6DhV+dcJ8W2Hl6BfCTBsN8i7SS3LweHzhZrZrC+Y5Kj1KM5qmRhHPwGu/tv5qPIcoRcyS7BTgbomYfM6H94GXr1HCdrKvuXbfJIItRXiNL7CfoOfvR+d4dDCNc1Zb/OvfWZrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VE6i5xMZZol0yq6ba+rIecz+T9BQtZq1ijklx1sk4R4=;
 b=zwPtkS0McrtudfT0+6YWBucDIb9DR7zWTrIn7DBXkhLacHrR3hQzGESWNF12bgq5GWBYk0t0WDtZdFapjllv8rTAXY3NGbM7iE0vIfqqU+bR2ZjMybla345JVaWshdUXAp6kBDVCpENivWTgmqQ3aLOpoHMly+px1+P4e6VkaAg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SAWPR04MB993677.namprd04.prod.outlook.com (2603:10b6:806:55d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:22:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:22:51 +0000
Message-ID: <ca8b7a20-3f9b-4f16-b084-fec0d5060453@wdc.com>
Date: Mon, 26 Oct 2026 17:22:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] btrfs-progs: image: various LLM found memory
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792914402.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::20) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SAWPR04MB993677:EE_
X-MS-Office365-Filtering-Correlation-Id: d2ba890a-f22b-48be-4f90-08df337d61e3
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|376014|10070799003|1800799024|261026121527099003|11063799006|56012099006|261021121427099003|261022075727099003|261022105027099003|261022115727099003|261021123027099003|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007|261026140227099003;
X-Microsoft-Antispam-Message-Info:
 LD6LHul08mq441gTBqLcAKYdTy4+8pcM0/NTW79tsEulerbzWBosWC+NvsyrCBR/4OXkY6/fTdPkyBPl3Mp6kUdMywDHEqBg2ctFMBKrgopZGqr90wJqnjANgqJyID9iumCmO2+WXvDZ4wzOMEIZC0Lp60VS7b5p4fMrd5Z/rKAV7aqPCqKBiuc9NsJLHvkNmCzIkNHyTC1qSBSnXiy7JZZ7SGv//ClbEw6fZoljkwblBNtzNPLVBjQD328lXUgJqP0SaXACTKIscWucfiadiQWuY4iYVYDnx54Qhj/RdyyxJ7TPPIVm0r/Ui5n2PvQ21MOtx5aaZM+Oip9e/HMhqrUsU3CQ/kdSwPV/vokRge9G79vUzflHh1yK024cUAu3mWNTShXbeSlc9eJRAg3dr/1dA2iWzht1QBVubibD/ofT9vQfIVxv1xWc/Suga4HouISSknsYjYbgZGNPDYXR8qgcOMmhWGvhWGqmk+5tyalY0c12FLWX0fvl1KjVgv8ieveGwVMC4ap8J+axvJiehGHIdsjrZSWfwGXMRPgmW9TW+HAOTV8A645bA+u2IaWfvjp/5I8cnZf/e5v8f0JBCMo7o67ESdY3LRmxOmkO5uSCHBCee5ZCfEFYjKFI1dyGRWw7q+K3zgNIYM4nkeWQOGDlxpszohM7BfspS2mJgSY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(376014)(10070799003)(1800799024)(261026121527099003)(11063799006)(56012099006)(261021121427099003)(261022075727099003)(261022105027099003)(261022115727099003)(261021123027099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WEwrNTlpYUJVckFha1loYnJlNWpVVllvd1Jjcjk3cTlsVnJTOW5DdXZUVDhK?=
 =?utf-8?B?T1FBQ0xGdXdIbjNjTjRtSzluWDc5Q1hIaCtQV1hmOW5ERVQrN2IxS3hqcm41?=
 =?utf-8?B?aC9lYUpQZ0tnazFlblNhMnFNMWViTzlOdWdnRDhFSkdLendLL2F6RFV2dUNZ?=
 =?utf-8?B?dzZxQlRHSnV4U0hIa2xaUHpQdHZ0dzE4SVhnc3FKSStGTlhiN1ppUUZNbE1m?=
 =?utf-8?B?TTlXQ2pwNXZKcEtrd3U1YTcwQ0VIdEpNR0NMSXQwbWF0YnpGeTF0WE01SXhV?=
 =?utf-8?B?VXFaNWpyU1pTUWI0Y0NrVE14eXhKcHVqcGhwU0orb2EzUE44UEJwZmE3cW0w?=
 =?utf-8?B?VmhQMXBwYUtoTFFrblhQRllpWi9TZWFLeXYxTlhsYkdXbkIvV1Q1TCtLNWd6?=
 =?utf-8?B?NzBnd21GL2E3UnBWYjZjaEFIazJSS2lIYWhkYjUzNDU3QWdYN24rTlB0bGhQ?=
 =?utf-8?B?UEs1OUNxWDRtMkR6cW5PMElUdTArNDRsUlY2MysyYTZaY0ZNTDA0TmNlTlZ0?=
 =?utf-8?B?dWdTd3VnYzBFWVZOSHpGNXh5WmpzQ2d1RnJDanRUZkR5cTBLSW9XQ0JkRjFG?=
 =?utf-8?B?dUE2QitSZ2lZdWJCMkhnWmhQK056ankzYzdzZDRCUmJCQ1lRMjZQbW5sZjlr?=
 =?utf-8?B?SFZqRm1aOEtLOWhVUDEydmtmYUQwcUQvUlhOcEU4NzlIeE9XN0dHaXA1LzY0?=
 =?utf-8?B?TTZ1NERMTkZlZ1JLV2kyMXdqN3VrWERjWkZQNmFmZUNoTEVHSHQ5VHZtMlEx?=
 =?utf-8?B?SVpFZE9idWdZbkhia3FrandwV1h0YjY2bGFRY1ZYc3lmZGEzam0zZ1R1cndj?=
 =?utf-8?B?WG9DbXlzS3BXbldLc0NtV3RSUWVHbGRxQ01KRVpaL3pTM0doL0ttUm9ydGZI?=
 =?utf-8?B?d0RuMHV6MnFCdUNrU3p6Q0g4ekZNVkRwNk45dHJGU1Q4Zk9Fa3lQbVRJQVdo?=
 =?utf-8?B?OE1jWWkwOW5IUzJwekVHb1hrclovYkxVRkFoZzdKYXBPc2lUbm5vS0xLWjhM?=
 =?utf-8?B?djlHaWpzdTlwWEo4ZzZTSFhGeWJXdkhNWlI4MmNGYTNEZ0RXc0pwd2lmN1cr?=
 =?utf-8?B?N05uSm5EbVZ4RGdEVnhmQSs0WkhlQTRMcTl5aWpWaUJuVi9TNTVlYUhhanFl?=
 =?utf-8?B?NXlTaU1wbVJ3MDU2TzNRUDRERDZQRG5qcUN1TVp6Y3FKckVmRDVsVFhidlFj?=
 =?utf-8?B?TVJTbmMyTFBkTHRHMERIZDlmQWljVG15eEdUMnV2S2dUeDRvT0F3L2w5dWVQ?=
 =?utf-8?B?VFJDUW9FSjA0NWxjRXdaakl1VE82U3pvWWNQNEkwZDlhNU0weFFIZ2hRRXJT?=
 =?utf-8?B?b29KQUJhdHBkVXdzTWVSWHNXbk56Uk14SzZHTStEUnE0ZzJCTzIxY0tqQnh4?=
 =?utf-8?B?aTQ1NjgwblpnTnA2b0RZamRRNVVjRUExNVhLQ0wvZ0pnRmwwdUEwVDNMdUlV?=
 =?utf-8?B?djVrT2didXJlYm1zTVlUZUtoeGFNa3pJNVpRcHZMS213ejB1Y2JqODVHWFFJ?=
 =?utf-8?B?RUR6bjQzTThjVFpHdjJOclhhekFGK3VScHZSVXFxTUg2WDFBZUYzdWp1T2hR?=
 =?utf-8?B?TlZrS1NWRnJwajlOaU5TOFNLUmNFUEREM2tBaDRLMHRIdnlTSlRyY2tqWHRK?=
 =?utf-8?B?NERGTDVmbU9ER1VJZEpmV0NoL0hYU1k1aHc2UEhVYVlJNHkyektOZHloYmcw?=
 =?utf-8?B?eHNEb0wrZUhHaGJjOVlWMzJVYldESVJQMUN2UUFaNG9kSHY1U1pRUmZSc2pW?=
 =?utf-8?B?WTRhMHNoM3p6QnFsV3JKSFpEaFJiL0txd01xL1JpVkNxekxtWjhOU1prS25R?=
 =?utf-8?B?OFNaN0JZNHZPbDkzRlo2NU5VRE9UZVd4SVZqdTN1S2lxNE1VOUd5ZVlqS2lS?=
 =?utf-8?B?ZDE4aDcrVHVRQjZtR2xPSGtTcDgrZytpcXpuWElOOWlMWTBxc245MCs4ZEZM?=
 =?utf-8?B?Sy9PbVFISTVoek40Z29XMDhkSlFXaklJWUx5Zk5UWUF6SkQvWnV3RTRURGQ1?=
 =?utf-8?B?N1hDV3BwTlVvRlNQQUJvTzRJME9RS1V0YWZpeUcraXNJWWxvb2h3QUh3WG5U?=
 =?utf-8?B?VXRMbFdmT2ZseG1Fb3VCTyt5S1AySitGb2ZWeWZUQUlVQ2p2NUlSTUNacVNK?=
 =?utf-8?B?NDRvWXlVamNJVmFXaXV3bTlBK24zUnduaXBvMlB4T0JHMVQySlFEdGZjd2Nv?=
 =?utf-8?B?YzhuZWZFVjFtYTZsR1gwRW1BWGZualZoOHZwT1hMUzdUdTFtNzF3blJ4Mmg0?=
 =?utf-8?B?eWF4eXRyODdiT2IwM1R3TFVWTDFiVzNLTVFLTFB4bWdUaTNlaTRwY0dMVlls?=
 =?utf-8?B?NHJXTFNkVmh0TS9yUTVnUWNMRU9XbFVhd0RNZklOVEFKeENPaXB4YkVtT2NK?=
 =?utf-8?Q?DWu3gQPzJc5IVHzJ+jV0p7jDu0p/aF55MNgwucyvoimf6?=
X-MS-Exchange-AntiSpam-MessageData-1: HqUMDL5TEG50/g==
X-Exchange-RoutingPolicyChecked:
	xbdG1IQluLP68CGBkZXbJBOnBbCAJXu6CJwPStsjd2owq5x8lNk9oCUOoDc1kt2ZgZEyEqGYWX3IIiIiHvB99fIFSg82OWscU/mf3Z0GkGWH+zs+pPMZgfe2/vVzmtTFio0S3joXTBMtUPLjK55VTswN0Uedj5CEw9obpikLag4MFuQLXTOos7ohgOux+9MIt3Sc4gXMwyzn/4RS/2y/CQ5VTQdUoKbHsjf/adXXkdUjeZS5bk5weNnhfOnykMoT0/mAvI1MlV8CvWIjZ3yXy9XnzsKg3S8/A/DP7ZI/EAzxJWPoPndPd7JSy3wbd1EHHHGM1A1CTnMPQ52rfZIkjg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	56ksgy7GuCP2xHmnF8i2zFh7Ueu8GSq6/oOjsGUaltJuGgaYir+jvrtIULtLWOZwGHVobWw90j+a87Oh0+NzrBaFI9dpm+OprczTftGjQ2Q8DcBTQ5hbG4m0//Ojz2tUxtR51E1/TAO6GYeK9EfPMV4d+gCICkfWXAZyp9U1yX/HwvJ3f5TLRRkKihO8ddgDBjwqQsVMA4cGUOeu+74WwN8AnFSfQmx7T++Bd/KZ9q9iiJuBBUldKWKateXEFpkJgO9yVs3Sa8kVL6hKslIZMPeXPku8IiaPIVMornIIoOzge/G9jYZPzB/1+SIYG/hsbSWr2mchJFUocHU3vsc47EIkHTDTlfRNDDhISsjaFusTT7f6/MrfO5bnmqBmVa/fkuMTPNrHCrBGcF+UpxiqiVhO6q4+EngCMz7JUh2YEpQcfUiUw7p5g+S/9eYAkO9agI0zsftVClCi2WO3suJPq1nOpotTNStAqcPQe3bCOOurTCq5EnWgYT3o0R/qVSakfPZBNb4r2sMZWDK6iC5O3F5Ds4hDp9Qd3pwTvgANTYeMoSfeDo30GUxSl+VJSQZ3Vh5qFNvAwiZPydjVNieF0RqIsVgt/hZlfsnKRfWm94A6/MU1ZNArdEIIKYtUN06L
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ba890a-f22b-48be-4f90-08df337d61e3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:22:51.7204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKA9LlYCLdZUXblUWK7OSJ4TBShVSZrUmVgBXPLwgGH0OX8mUm3RMYLOKaXbvhJqrQM25ktqXh3QsfHYYxX9zNjD9s5Yt6Wt9vdA/1l4mqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR04MB993677

On 10/25/26 9:41 AM, Qu Wenruo wrote:
> The btrfs-image code base is pretty old (and to be honest, not written to
> be read easily), and some stupid LLM-script-kiddies are reporting those
> as security problems.
>
> I don't want to argue with those guys, so just fix obvious memory related
> problems for now.
>
> There are still some left, mostly related to the corrupted tree
> blocks handling, those will be addressed later, as I'm still trying to
> figure out what's the best way to address them (e.g. tree-checker or
> adhoc fixes).
>
> There is also a problem in the filename image/sanitize.c, but that only
> affects the filename sanitization, thus it's a very low priority item.
>
> Qu Wenruo (12):
>    btrfs-progs: image: destroy chunk tree after all pthreads finished
>    btrfs-progs: image: only remove a chunk map from physical tree if
>      non-empty
>    btrfs-progs: image: cleanup pending ordered works after an error
>    btrfs-progs: image: do not cleanup the thread that failed to be
>      created
>    btrfs-progs: image: free the buffer if output allocation failed
>    btrfs-progs: image: avoid NULL-ptr-deref in build_chunk_tree()
>    btrfs-progs: image: fix the error handling of build_chunk_tree()
>    btrfs-progs: image: fix memory leak on async_work for restore
>    btrfs-progs: image: fix overwritten ret in restore_metadump()
>    btrfs-progs: image: validate the nritems before reading the content
>    btrfs-progs: image: reject incorrect super block size
>    btrfs-progs: image: properly error out when fseek() failed
>
>   image/image-create.c  |  22 ++++++---
>   image/image-restore.c | 109 +++++++++++++++++++++++++++++++++---------
>   image/metadump.h      |   7 ++-
>   3 files changed, 108 insertions(+), 30 deletions(-)
>
> --
> 2.56.0

Looks good to me,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

