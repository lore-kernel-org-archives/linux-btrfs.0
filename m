Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792750847;
	b=EnDWCF9ztzuUw6tWsjDnNerjEE0vZjC1UCcPqdQdi41tOlS7CJOW1ewpHbicGGbQaBLm
	 PJKaubZCkHO8Sl9tiebMgV8kOP7htfNq47RysVRSDabRTeGsxiZCjNx6AyI1cfLL2J0Pr
	 rJLBkizfotk3RldYxp3QWKtIHZuWOK3hBQ1mwCmsBEQAE9CSGA3YAMuwA+0k90oAzhKTh
	 zCXFb5EWTIKVYN2/hEg7HamxxKagQ/KfLmwp/gwTlyUnsj/HRjQ7M6gCGMYrttDHE1pVT
	 QM7YUnyysX0OyJUU5FjDPlzpVYtIV4LjdGJyunFuVBhKMRDNXw/y/SxwEIoOMz0njuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750847;
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
	bh=YhzBVDHyp6D67d5A2CTs9NSVNJWrk8/qIysDEQLF7Ac=;
	b=CSVZUS8508ZFgnVsH5nMOwlvED60dhrRQIeCVky+Nd/VOi57Wj3tDR073Kb41OLAzvYV
	 iakzpcDBrIalJIjczMHFQ3SLPhaOJEFe6FidN/TC0smKlDQxgEwRlCGuIU3cnLePp9eq0
	 BsSjJ/YNy7Y3RC5l77pPtH5e3QcLAr1pR/UxKydnSjRkJbAX8T/uNub563WPlWH3kTRqf
	 TOdhx7A1arLKz8XrY3Bp3jDTNncQYTSWNnbnq7fiZrfiMUorBUYOTab233I/smi1BxAip
	 dwv4kOrIhtFhvtACagz8S6AJiUBUud8fi2RHmmjCb781d3xnk+Xxh4D/+pAryJqHoYw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HFxqWlIy;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hEHZN686;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B308606A31A;
	Fri, 23 Oct 2026 10:20:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B308606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HFxqWlIy;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hEHZN686
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792750846; x=1824286846;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9ltVQmaD+c1bs3oWOTXW2zSWb0CwchmRBL8Qq0sqO4U=;
  b=HFxqWlIy+z+HxuBbzW2LpLma8x9gg+2mmvKxyeVumuFvRPwXR+jdXvT1
   PZ71OGH71QtsDszbCXRrI4LRnAfn//kMUfnF1HCNax78rpLAn7OUO2Ghp
   yr/CS8n8p6baYo/BwK/Z7wQeI8PZroUD4oS1mRoqfvj5yyxJKvERZr4BY
   XvuFBi4Mob8Jo7iOGbFDxMAJ9tQ0/lQhnbr5m1LaDYXFViMMnoFrVfZtb
   YhxjUAspBqPUkhJ5ldtUDA/ok/I7rS/IHtruoSvJ9i4h8/EwWSmyiRub/
   4q/Xlqcoxnw1CzBKtwZ8ST0Avuf/XA+UYZb/N5qnmmOvJnLWcUo3LKW9P
   A==;
X-CSE-ConnectionGUID: iUD3V2TBRGi7JkewkyWYFQ==
X-CSE-MsgGUID: aihlc/s9R22W6PXJPBMlrQ==
X-IronPort-AV: E=Sophos;i="6.27,174,1786982400"; 
   d="scan'208";a="158726430"
Received: from mail-eastusazon11012069.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.69])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2026 18:20:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCb5BVOj8jQu2f3ybaRdPdQ9/3pp75w9l7zhfSs7sWSF1fGxrymI7giC77uR/CPL7MtsLW4mpEx2H7YZRsL1BrdpJ0XyG7KAL3ufzpMvkhtZCLh5u/A7ePyX7gr5TzkDIiSi2Cj2ClQd0GPkUJwvKuKLR8wg8LCJXrp3N148lpBClkFq9WsOfAUmS+7TIrSV0w1wiiZfmf7HuynEHbWwXlWO+YjTNvS+3T+U2fIO+0g5ImNCrA6Y0bboG0fyfkyilwSwOFMGfbfP/LRbTFF9WLulAt5KsWcpA9F4Clfu6ist+MVEV4LtaB+lAUZUnb1FnG27fOaWkTqKAbbuWIiDmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhzBVDHyp6D67d5A2CTs9NSVNJWrk8/qIysDEQLF7Ac=;
 b=YiSKZBl2do+Ec1v1/lI3fBzKQwIwMk7L+SFWoMJy9nlqeSO2mYHaFJ0aJ3kyu1vxdwcqKV7DqQfhoKndVKM+BgXA8Snjw5s4ITd4MfaMFm6MNyXy5XcnMlb6Lf9AV3p78lxHfymzUnAfxK4ZmSt7lAdpPyXu6D19u1RF3OkLQ99UrmS9RWpg1+OmvVRmCoMH13oFtpxJWC8WEas35Rq2KXlAd1+l1+WKLXvBqQ7gZ+8MR8fRaxjW7GZhi8+eVg8dKe6Lh3wn7T+qvnox1+USHu+dulR+RFCqKYkogAIA7AtX3+PKTDWrwfqQoTTvc7lB8Jq1DN13I+4JJWEayhfqXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhzBVDHyp6D67d5A2CTs9NSVNJWrk8/qIysDEQLF7Ac=;
 b=hEHZN686SSXM4FyimmjQkQf6di6JRS5wMtut1VoXksLma5u0263UnEX7RFYy1W4G7h4Ue3ejZLIiBfJ044MvjzWJfZr+B1LrC4SWqG4Fa9KZZTUnBSbKdhRIJqywAi7Q5+OqkS7FzdjulM2CIgVG/zLUac84cHQobhBaZ5EfqbI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS1PR04MB9210.namprd04.prod.outlook.com (2603:10b6:8:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 10:20:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.016; Fri, 23 Oct 2026
 10:20:36 +0000
Message-ID: <b7c30713-9983-4982-a729-bbddc0593249@wdc.com>
Date: Fri, 23 Oct 2026 12:20:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: test that fsynced data on a RAID stripe tree
 survives a power failure
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
 fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <20261022090754.2584747-1-johannes.thumshirn@wdc.com>
 <CAL3q7H5sKk3+P=AUf1OQ8mgD3Sb6hnDiuhgBMmovo-Wc1Ub99A@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAL3q7H5sKk3+P=AUf1OQ8mgD3Sb6hnDiuhgBMmovo-Wc1Ub99A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS1PR04MB9210:EE_
X-MS-Office365-Filtering-Correlation-Id: 317f9681-43f5-4519-3005-08df30ef4776
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|376014|19092799006|1800799024|366016|261009223027099003|261021121427099003|261022113327099003|261022105027099003|261022075727099003|10067099003|56012099006|3023799007|6133799003|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	s/yvH3N9poKe+R3J8LJINdAL735XtzLeyYsu4QhZvmvJWZuX+aZV4Hq3sQ/R6rjIFVD49ZmYQZXRpEzYR0L7WWJdJxzskAgfv3WPomkSd9LhhMih41rtGG5cIHPvVtWJKKEO4n5Fy/bYg794IAAQiH3bCDRljpICznZJmeeKOX+r0+ae8UZ2844NVXeUXp1n7Sv9CO0igQJdWhq5pwifS/e2muqAZ6Q6ekCUlMq1sKd74zHIskPAl9EgLhkcfOY4JiCl6Id8natFq3mYDCdZyPXX1T0MgeMRMloO6W+lEjEHaWSTWSssGIKpOgN9hWqV7igHc+mRLG7oBdIoY3ZkuW4/RfOgXaqn/LQaCzJezM4lDT4sp0CQmRMfNtyMuJMnsppqHJX805Q2AjdqE4TNxr4W7awZCPqc4EgV1cHRax9fuR/ZrXBIcl/h4iT98BMj1QabdA1wBw3VZRcVpvOndY1RCUNeXlj2YU/FvraNXHle9Z3/zxUNw+AkUS/kcVeDl1IK+7283IDrJGVkGpFZm+W3bftWJVCdjp8aqlrui9t+yCf+2n1+OChtmuEGZddH5kk+I9LRZZc3GPOvWYfz0uMbdFYyGcgRBh+YmF4IVk0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(376014)(19092799006)(1800799024)(366016)(261009223027099003)(261021121427099003)(261022113327099003)(261022105027099003)(261022075727099003)(10067099003)(56012099006)(3023799007)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTdhazVXRXJkQk44L1U1WTNNZUdlZTBxUzVVdUF3ZEVyblVuSm53RlZyM1A3?=
 =?utf-8?B?ZVpNb2ZvMFVCWXZIU1pEYkd0Tm4rZnZVWTd1K0FBK0lBenZjUCtGZTB4a2Vh?=
 =?utf-8?B?YmpGZUlkdlcxQ3BLR2w3aUpqRStTc1MzVktvaE4rWG1qcWZ6UDdMTTUvNURr?=
 =?utf-8?B?SDEwQ0FiU1NMVDhkZTV0NWpOU0RTMFlTODlMQXFKcHlQQi9Ba3Z4NVZNVno3?=
 =?utf-8?B?c0QyYTNlVTgvUlo2Um1GTXJwb1JQNlRBa25XZHVwNU00SFNlaDdka3Z6ZWtj?=
 =?utf-8?B?SmF1bWgxSDNjcVBubXFTeUVIL1VvT250T3BXeTA0SkFtMGIrNjgwcUhBTEdr?=
 =?utf-8?B?TmZucWFJUkNzT2hYOTVtRkV0MHdVOWphZDFxSk5LK0ZoVnpTaWlQc0M4MURS?=
 =?utf-8?B?cXp2ZWNwUG1PNmdqZVBxemk4M0lEeFhwTGhULzBNanlQODNkL2l3ZDBXUmhB?=
 =?utf-8?B?Q09sUGhiNjdBdzljb1VjNmkySDExeThoTGl6bE9SeDE1ZzRBcEdiTk44N3Ay?=
 =?utf-8?B?RXFLWEI3WG1halVNaitBRUFlWXAvSXIzcTFjOFlNUlY3bXVCaEpZZkdZcTYw?=
 =?utf-8?B?QUs3SHRXYzdQcHVPV0xsalpITERldENCTWJPRFE5N05FNS9pMVpiMVBjQU5U?=
 =?utf-8?B?NEt0OEVsSlpJb1p5aUIvNUhMNjhsZ1BwWnhETU95MTByOVE1UUxvak12WGVK?=
 =?utf-8?B?MW9FQ2ZmL2oyU1dQcEhkbmc1eGF6YkY4RElEQjhhVlFwbEtkVkI0cXJPK0ZY?=
 =?utf-8?B?ZHBlQnhDMTY4UGRKUE8yRFR0REZzTnRMaS9rYTlhQXkzSVEweFJRSEYvZVls?=
 =?utf-8?B?dTFlRlpockh5QzQyRDgyM3FDb1B3ZXJvaXN2bW5HeWNIcnlhUWZOR2Rpd0Fi?=
 =?utf-8?B?RHpoSC9yMVpMZUpuTlRSNHkwNllhcXlEWmxJSzZ2YS9QYm5aTldSd1ZETVl2?=
 =?utf-8?B?UldSSjNsYkdwSEZmS0xBS1JseGlnUkl4eUZMZ205ZHN0djVlL3hVSGcwU1hz?=
 =?utf-8?B?eEdkMnppdUpQc1VpeklySzh5MWFmTUJoMWhaa2tnL25ySFNqWktORXNkd01Y?=
 =?utf-8?B?ZHVMd05PMnVOTFBWc3VoUHNDRTdRT1UrejRoUmVuWGtiV3ZmU3RPTU1tY3VK?=
 =?utf-8?B?WnFxY24yRjh3WUJIVEZVMk5sOFBIeE8rNGZ6K0U1dXNOUERWa0JzNE1OQ2po?=
 =?utf-8?B?S2diSDk3ZUJSVHBWTzUvNFNNYnQ4QUFBMUdFRDN6R2RETkt2b3B1dXI3TFhl?=
 =?utf-8?B?MWhzZzQ2ZDhFOCt2R0QxN0U0WFNiQmFqVkFJaG5MTEYyM1J6WDZuVWJ4QW90?=
 =?utf-8?B?T3o3aDhYNU4vQnFKdFhYeHpnTGdhMm5OdGdHZ3pjK25wQ2pSNDFmTVRkblRy?=
 =?utf-8?B?cS9DNzNvVmNIVlo1aDVKdUI1alBkdE5iKzN0ejA5ZzBFNnVwWndvUXNvZ2lp?=
 =?utf-8?B?aHp1ckJMT0o3ZVVVNkNhYW12OEpXUVkzUEcraEhLdnN5VjhqSmVxbmVkOW5B?=
 =?utf-8?B?ZjllaW1xS0hJNEZPTC9JcGFFNzFaRzZ4cEJmRmQ5RndsNHNwb2tCUHJQaGxY?=
 =?utf-8?B?Zy9LZG5YYWwzeHZaeTFmSGJUcDZPTmZ1U1ZRUytyR3ZMQnBiT0ZXRWY3MTlE?=
 =?utf-8?B?STB5SnhPZWNWQ0Ewa0MwaE1rcGxjbk52anRxandURXdPZ0Z5U1BOdlJHYnZw?=
 =?utf-8?B?SFlYM1htdVZRTyt0K0doNUVaSjRkQU1wQUwyOEF1bytwSWpHVGFvcmpaNGxm?=
 =?utf-8?B?eDdsUU44TkV3a2F2OHRENDVLWlZ6a1RvTkxISlAwUFRNdW90dWtTS3hxcXNS?=
 =?utf-8?B?Z2I3SllTcFFaWHR1OVppUlVQSmljVkJOTzRZMGlacC9Dd2EvQjRhYVdRSXlG?=
 =?utf-8?B?YkFSTEkrWE9SRVUwK1ZhMThQTkJSWWFyZWZ3WURMelB4WGdUeFk5Vmg0NnVr?=
 =?utf-8?B?aEJXQTNqVlQwWUpURUFCMHo5K1hWOUppOGRoc2s5YTdXSWdRUTB0S2FpVS8r?=
 =?utf-8?B?emVjZFh4VlJKdHZHRk1tTExyOTVJNjVxNWs2MXdmTzBvNHYyZkZlS2VZVDQ2?=
 =?utf-8?B?Zmtkdnk4a2xsMGMvcjVQUkpRTVhtMENEc2VYcS8veUJTTFVhMFVGNEY1bGJp?=
 =?utf-8?B?cDEyZWFTSnFVd0xkcTdnRUg3NnR3eVExbFJqUWF3TUxudXhXQUJMWGZEV0pu?=
 =?utf-8?B?UlJJaElQRFBHRzdLVjQ5VDRFcEVwUnAwNTFMb3FKUUtWZitzNUJ0WVVWVVdM?=
 =?utf-8?B?aml2TEFNREphRUpKZjUrSzR2MkxZODZTQVNSQW01TGQ5RUpUbXRYd1hxdFNL?=
 =?utf-8?B?UlZXVFhQemUzQXZJZ0ZIRVJIN1ZqdDJMSS9wQTd0TTgwUjRNT2JvVzhiYUp4?=
 =?utf-8?Q?ROXYjpuBQvZLydNWEY4uJISA6pgsZ89ZszJfI0YrrXg9S?=
X-MS-Exchange-AntiSpam-MessageData-1: qnHS/aVHATRxtD2Vl36nBzw3H2jcBSBuJjQ=
X-Exchange-RoutingPolicyChecked:
	d21JrIU35FSTsmhoxUvUDKw+g1ikRo8FYe+l6LmigvAAmDAIHGOLMtMccdy6E0q3I3dbPHjEV8Hm4cCaIq0Dw6Nx7JgFEiq9gbBbSEjQ1AMxOKsuWgba/JRjwQo/9VhEkXv9CDvUUOMKo77iDOQtmwMfyfJ9IenvyfEXqgFH/zPx+MQT6d9pCbLn/FQ0sm8mhvSI2qitzCa2J+LaJ7vhSZ8m9+bQzsbukIPDfEI2SV4Xrd4vMpIyq6xiL4pKxhMIr214SIiseovFKl7ohk7+is48S1Hh08ohT9wNFn0P1NCiyQUshS3RfkqLgkVNcYL6Wn9Ffl4zKJrVy1fUfOI08g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jBYNcIC/Q+g1VLYN0jzh/TCxAoRBnoEJfpN0ZerPh9drQpUMUGZWUk9zVw2qqIqovnhnjASO0YzLPYeD79I69TSMBSVp8M3kr8qptpUuEcEopEp86hZiLesdgnQFTaQKsNrT5+ToRYLSoMzd1AY1DpyPSgi2mAgl8cZ7/H3ZrGY6vLiEgxh+DeE8O8smXKnKBWtGb/cn38AXSxsOMD+/D+wR/fqoSHdtGIxxleyx0UjHR/5K2OnH0x4GBiHR8VQW1SuPioWC5gmS1hc2qWuQZoKD/oLnUwDbkkL04t5BTRUrwaGyPnSWT0oKXspPKejmexF/0zTC/7o6vdAhEcC9z1EZDyd/jry5hUHq3n3M4MHkAgMRPIfDAbZNntdGhqQWPGmpLUy2XOk08+VMNiZW8Dd0n2zCDUaqQlawjg2akYZamfO8Fd4pfWgtZnmb5/mJuSMUsETejFvHM0Y7JDWuDSCWu2xzCsLqLFRovjdrIIbP4qVjepsr5pB3vFR488DPwiq11oZPzaq1G5hX0XlUUx/efn9r+jQtgQ3VnmWN0Du2P68cuWc2IO41QJxzTWvFcS07/p8l9l5n19JWEb+zDWwwOccZkDvtwUtOGtOhqzAtXrdKtL8Tqt6z7oF+svq9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317f9681-43f5-4519-3005-08df30ef4776
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 10:20:36.6194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNxHlVpu0WjMnhJShmbEfM08EsIuDsNyRtXGZMqWI+DRrTWWbCDnjgBZHTD24Oy5fRjz83aB4T7fEdGsxuo9h4c384+vg4T/z6JWRdVUA1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9210

On 10/23/26 10:58 AM, Filipe Manana wrote:
> On Thu, Oct 22, 2026 at 10:15 AM Johannes Thumshirn
> <johannes.thumshirn@wdc.com> wrote:
>> A data extent in a block-group that uses the RAID stripe tree has its logical
>> to physical mapping stored in that tree, which only becomes durable when the
>> stripe tree is written out at transaction commit. The log tree cannot carry
>> that mapping, so an fsync served by the log logs a file-extent item whose
>> logical range could not be resolved afterwards. Log replay restored the file
>> with the correct size, but reading it failed with EIO.
>>
>> Extents reach the log both from log_one_extent() and from copy_items(), so
>> cover a fast fsync and a full fsync.
>>
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>> Changes to v2:
>> - Also test full fsync
>>
>>
>>   tests/btrfs/363     | 67 +++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/363.out | 15 ++++++++++
>>   2 files changed, 82 insertions(+)
>>   create mode 100755 tests/btrfs/363
>>   create mode 100644 tests/btrfs/363.out
>>
>> diff --git a/tests/btrfs/363 b/tests/btrfs/363
>> new file mode 100755
>> index 00000000..834f2673
>> --- /dev/null
>> +++ b/tests/btrfs/363
>> @@ -0,0 +1,67 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
>> +#
>> +# FS QA Test 363
>> +#
>> +# Test that data fsynced on a RAID stripe tree file system is still readable
>> +# after a power failure, both for a fast fsync and for a full fsync.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick log volume raid-stripe-tree
>> +
>> +_fixed_by_kernel_commit XXXXXXXXXXXX \
>> +       "btrfs: force a transaction commit when fsyncing stripe-tree extents"
>> +
>> +_cleanup()
>> +{
>> +       _cleanup_flakey
>> +       rm -fr $tmp
>> +}
>> +
>> +. ./common/filter
>> +. ./common/dmflakey
>> +
>> +_require_btrfs_mkfs_feature "raid-stripe-tree"
>> +_require_btrfs_fs_feature "raid_stripe_tree"
>> +_require_scratch
>> +_require_dm_target flakey
>> +
>> +# DUP keeps its mapping in the stripe tree, so a single device is enough and
>> +# dm-flakey can be layered on top of it.
>> +_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || \
>> +       _fail "mkfs failed"
>> +
>> +_init_flakey
>> +_scratch_mount
>> +
>> +# The first fsync of an inode is always a full fsync. Do one here and then
>> +# commit the transaction, so that the second fsync of this file below is a
>> +# fast fsync.
>> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/fast | \
>> +       _filter_xfs_io
>> +_scratch_sync
>> +
>> +# Fast fsync: only the extents changed since the last fsync are logged.
>> +$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/fast | \
>> +       _filter_xfs_io
>> +
>> +# Full fsync: this is the first fsync of this inode, so all of its items are
>> +# logged.
>> +$XFS_IO_PROG -f -c "pwrite -S 0xcc 0 128K" -c fsync $SCRATCH_MNT/full | \
>> +       _filter_xfs_io
> Btw this is not a very good way to test.
>
> If we have a regression in the fast fsync path someday, this test will
> miss it, because the full fsync on file 'full' triggers a transaction
> commit, hiding the bug in the fast fsync path for file 'fast'.
>
> So we should test differently:
>
> 1) do fast fsync
> 2) trigger power failure and mount
> 3) check file 'fast' data
> 4) do the full fsync
> 5) trigger power failure and mount
> 6) check file 'full' data
>
> Sashiko pointed this:
>
> https://sashiko.dev/#/patchset/20261022090754.2584747-1-johannes.thumshirn%40wdc.com
Yeah that makes sense, indeed. I'll update the test
