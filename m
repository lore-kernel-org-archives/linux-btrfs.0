Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795707374;
	b=Qz/l6T/bcHAkNLwCSNMWqAeZsRqFEMPAdG2ifH1czq0XmA4mVfJ4u5crAzonzhpNsL/L
	 JfkIxPoz3d0uKZh0jmeIWwbyj2mvMtmZ2M8bvd3qWrTqyh9ApBRIQYkdC5cVi+2aflX7Y
	 hwC3oVzpUSGuzUyhlCqz3BJ2UQP60YhU+rAB9FOn9QUcDQu4X2kNI6/35D8RMwP5fMtdG
	 PJvIxb20MFpL9YuefjpZ9Yx+H6N1TLnE7Wko6dLDdc1BXdXfcO9vaADCZZInJIpTqeSH0
	 2eR+5xQ3cb2AjaSnjO+5RhZcmXARHbuA6F6uYRPk5LY2rETzMMjb/wQCA0mF+3cdMTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795707374;
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
	b=EKWtuDc7DyL4ZumyNEv8LGppkCbvxbuJOWwepCVXe/fYh3SlY3s9jSmYGnarEBzsj27b
	 i/22CZsgN+NIHwMYqJxudtZjGmlUSJaaeqWory1Sdxv4x9dlr0Mrmil+n8DGnncNhkFol
	 AQzuADOh4zzfK7UNIHlbtBvEBBOTeu+tY18FQ6Mb9dfqrDL8lb5S22TQkHJzj7Ta/QAzM
	 yKLexJtygn95HUD9YW/vAW5YW1bkSrqB606YRt29AcvFnwxwuJafBbWSAZlcnb2PWjKrM
	 33pmGQybTbz1wiLD0t9db0k28CT4a3J2UJWaxfFqber7dbSDSOhQyhhvOO+MvTYBZvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=YH4ug2tL;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Hym9p9qM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0AC606A31C;
	Thu, 26 Nov 2026 15:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D0AC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=YH4ug2tL;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Hym9p9qM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795707373; x=1827243373;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=YH4ug2tL7mT4Vkj6b0Nnp8HOVAgS2/0A2TVLz3Uhw3QqfsJ0IDDmlBKA
   OyKGE4B8RFWP7ddlTyiG9oR1A6geQq8GdmvUF8dAKNxV9NayXtLjKukeo
   4aQ1yRwy9TMHHXAXE99Z9TuB/8PQerhSCnPsLsvhJnYclh69pZkWNS960
   VvUctWVNBIRCPA90alI+vbdSApZNOrl+HAc3nNVBhC5joHqsN+qZF/ikS
   pe/7wpOQWT3AlV550JNgDmlVn7ul174RGPitQf7h0l/zbCKg4zRIupsQP
   GUVzWmIAbXz+WMfvyloHFoODJtWsy/TlCh9joPIiSJ7hggF/2KWJFL09e
   A==;
X-CSE-ConnectionGUID: 0NMMaNKYQRi1d1cYhMZgMA==
X-CSE-MsgGUID: N930uqhQQ6eG8sYspeJOpg==
X-IronPort-AV: E=Sophos;i="6.27,235,1786982400"; 
   d="scan'208";a="161837305"
Received: from mail-eastusazon11011004.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.4])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 23:36:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vftrn+JnHy5CanAHKd/4ekK/8OG/6dujvCu+F0JEX0G/HT6f7yvREikleqQ4HAOPJCuvFLdbPFSZ3IRuoG5Q3KIDqKjUnDHVxCVDCLNu5XBSHt87I4bEzgdmldWEGF/cACogzLlUnR1/ZF4cKvfdUn4M74VIbDvbjP0fTAVo5VQSQC9LpytbX3jlKmOsHyzNJVNyHDvsiDMTTzUGH5TexlBH6tc6cKferQNlpR8kvr3IeoWh65Z4Jk4UKclK0prhTY5/HA1Q6DD3iUQ4NKWkpk1IjD+WrwxbcSmj/2n+joJGwBiJ1fqmoLw/iiMOVtVQ7KhXjLAX5SvUerrw13MAWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=ZJULMG4Vje/551eUeZZj/lE74tBFZSrVMSOkegobmavfN4BXZsX3YMJreQr+/Ok10Pa8L8R4ip6bL08LkwEPACu34/ZvftU3FvL69sqTQMZ13miXHWTCsoWGqOIRk97OhltDDAWIHKWzUaVUiK2N6xFJGj8ZSKIkPTKBl7YYaJ93ISIvozK/NFTYwN5/xS5oE8yj/tvmvThDAMAqIr/wVum+TqfZdTiWk8L2q2LW+EtKcJJl7gIBX4N6+/+PSH8uS2vTrhkvhSp1xMWU2sOe+yR5WV8xlsYR39AFA5OkN5KXYM4i9EsqYyHgY1HCZX4RCfpenynSU7p4PCJd2EmbiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Hym9p9qMGd6nDTNXcNkcKYdTlBbcXd4wdYdv/NIaqtghBAJxVl8nARstEKUg8fjB6dYp6KbhyE8cT3ljRW5UaZIhFdtx34/IzIt9LIXNRDUqHw7XCzFFfiwWgd5Ah8WO4slCwsvSxI1wcio2weqD1VYUUWmTxzWiqixNgWRTMdE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993738.namprd04.prod.outlook.com (2603:10b6:207:301::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 15:36:04 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 15:36:03 +0000
Message-ID: <8ca954f3-c458-4d19-8c23-d79d53a61b50@wdc.com>
Date: Thu, 26 Nov 2026 16:35:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: zoned: do not fail an ordered extent on a zone
 finish error
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
 Damien Le Moal <dlemoal@kernel.org>, linux-kernel@vger.kernel.org
References: <20261122232310.4099580-1-mc@raidlab.org>
 <20261122232310.4099580-2-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261122232310.4099580-2-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0103.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::19) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 8afdf398-4984-42d3-cbea-08df4bd2fabe
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|23010399003|19092799006|366016|10067099003|11063799006|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
 w4OJHbIhC7AbE3/+/tAQrTPvddouONhKSzN/Mpc098W+VVj6BNFlDPqcEgB0HALk946l77C0rC5JrO5/5/OM3f1Z/TGIbkyJvdfXO0fvniYXhDYWyQ20dAGLw/9LqLGd33BPXB3FRhX4eHdaQd18FpTv2XbHsnDSVrfNpZAu0iwqoaqSlZnRFmojP8//UFv69q4O+7MQF7OoU3KXKubP/jsAob5kEsieypQi2L3tcBUQ918/Am54LlluelOVLKvT8TEITUd491GvZ3PwaZQp2iMf9/+fBFSzUSRasunmampI+BDTCXBGegCtbFmdRiWv2vgAoBXTuvnEhB5zXGcGNADh0PPWTAu58L+La64qdSWF7aAO44MhU9ocyoRzDlYURzIRs9U7Ehe0m7VNGaH/RD8b2IsfXcrZPDnXkQWtJQNkFnk5i2U2bDUjvCqZnH1ExZlzda5aNEpl/BGfdf65szk/Y7o5PfoV9bt9Dbqtt4j88PpvL6Kzp5uRX9Bwgh/O7/fHGvx7YGKHfMNTR9gv15vgT4ZxTr8hIHRkjKKgulQpA9n/wBn9eaOMmwp7IlRWuQQnbRaZ5ZXMtLxmdqXnq8OFZuS8IE/fwEmQ6eI7NipzNhWexvaLki6TP4keu+aue3QCfUjM8qyl0H8ybBYy5qx9arH7bhsmIdHOynbddgg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(23010399003)(19092799006)(366016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?KzByQnJVcXRHQkZrRi8xQmFLWWhmM2U1YU1DREJaN0Fhd1Q4YXdxUHExN1JY?=
 =?utf-8?B?dzV5MDRHY3lJSlduZ28rcWRWZzI3Y1lVVlBKYVVPVTQrQ2k1a3licDJnaDZp?=
 =?utf-8?B?d21zRTRnZU9MU3g4eGRGSTNEK1loRGEwaEEwRDhTTHJIVVRYWGVmRURQLzI0?=
 =?utf-8?B?dVI1ZlNxdFJEd0krZllodE1hVFdmdUtUa0htdUdlazBQa28rR0xYOWhJVTR1?=
 =?utf-8?B?b2xhbnlyMmNSMDBwWFo1V3cxZHJ5cDVFcGd6Z3FmdGhoNWpJVjhJZ0xLeUYr?=
 =?utf-8?B?MmdyZi9TRFJxbW02cE54Snh2ZDd3VFlYbG5vN0F6Y05jNi9YZXI3c29YWVdi?=
 =?utf-8?B?MXVsYmkyeHpvUEgwai9xUGYrSVpHM3RZMGEycEtZVkVOcG55dnJOUGNGa1pF?=
 =?utf-8?B?U2d6ejVST2hqUXU4dnAraTFaRExCazMvMjZ6RlhoR2ViMGt6ZzN0bVVRY0tr?=
 =?utf-8?B?T2JhTGlseGFBREhaRlBXbURCVkpkM0JNbHo1dTloU2NjS1lRV25PLzlQWTZi?=
 =?utf-8?B?eVA5VCs0dGx6UkUrVU94Q1hReHdSajIvcnJhMk9rOWVEWnE0SlpncEs2Ty9j?=
 =?utf-8?B?OW83b25hb2Z2ekVoSWk5Z2xiQ2xFaDJoallmb1Q4R3h0NmdGOHFRZmFYbkJM?=
 =?utf-8?B?ekhVdWhEdnRib3pCN0xrcVJtWXJBcWwzWnFtcWJzRGlXK2ZUdFF4NElrZUc2?=
 =?utf-8?B?TjFlang2UWlnT2VXdHEyVVhoRlJCU1JtMEJwZTNpK2Zyc3g3bVpOVTc1OHlT?=
 =?utf-8?B?MzU3SGZyYXpXNllQVldMN0RjTGF1UFJ3ekZwWHl3eWlzaTJGUUZxQXlGUUJX?=
 =?utf-8?B?NlZ5bW5HT3NqTHpmOEgxUWR2blhaVzhiQi9nT0RnQWpReG9hTW5Yems2Z0dj?=
 =?utf-8?B?WUxaNkpSTkphbHRGOGFGcXJ6WjlXcDRramh4OHVaSlFBQnd3WHo3SDA2Sk1l?=
 =?utf-8?B?cHozVXpYam9IYjNjVGdMMjVFWS9BV2xPbERpb01tV2V6b1NOeTEvZ1FmejJk?=
 =?utf-8?B?VFFYbmliZUsrZHdOazAyQW9SVjlwdys2cXZFKzVwd2orRWVIRjBaWjJqSXNY?=
 =?utf-8?B?cDd2SW5xWENzZkE0ZmpVY1k2S0dnRkxFc01NRHl1Szg5WDh0RXBxNkRrQTlD?=
 =?utf-8?B?L1RWWGJpS3ZFUFBpbVpjUzJTcGI1Slp0SWtoMzcxbEorWGF1SGVwckM5VUlT?=
 =?utf-8?B?RmMxU01RVUdkc3AvdVExMnlld2hhdk0rV052blZZQXROa0xaUlpXUWpEZ0hI?=
 =?utf-8?B?TTd2N1pWRW1xai9qNG1NcWNxV1F2blk2VVFObXFEeWhGeEhyMytrR0ZFcUJs?=
 =?utf-8?B?MGpkWjNQR2lPaStzOXpuK2M1OWs2enRqMCtPSkJnMFhFVmdSU3VrcFhTaVli?=
 =?utf-8?B?cWFuRnN2ZDFJOHFFSUhZY1YwcDlJZkhWVEpYU3JMNXdDU2pEdkthL3VKaE16?=
 =?utf-8?B?RnJsOEI3ejhXNEJFOXU0dGhrbzlUQkdpTklDL2VoKy84NHpIZ2pPaFRaTDAv?=
 =?utf-8?B?bk5sdGw3WmpVeTJsd2F5NE93TkpKekN4WUFXR1ZtZlA5Y2J4RGcvQXIzWU5z?=
 =?utf-8?B?Y1QydStOYWk1VWpJRUx1NDB0NFpsVktDL0RueHZTNVNVK1FIb004Rm5MV0l1?=
 =?utf-8?B?cjkraDVxdlB2Y0dSZ295WjJWVFlBRHRCeWltYTNMaEJSTTl4cjdwWmxBWjRZ?=
 =?utf-8?B?WnErWkgzbHQrc1ZzcVgzMmhveFVLUEVmNkhSVWx3cHNOMXI1OHgxbmhSb0gw?=
 =?utf-8?B?eXJEZGxMOXcvemcwTXd4NWQ3NHhtRThjbFMvMHMvTEVwTWw4cUVqZWNDcDg4?=
 =?utf-8?B?ZDVVeHRhY2RjTlZSYWpWNnBFKzNHdU1MNjlwbTIrRjBUb3M0cDFFY0lNTWdZ?=
 =?utf-8?B?Njc1NEYvdG1vMm53V080ME1GZnByeFpaWmk2bjFxQWFjSWpVWWpzdkVhRmhK?=
 =?utf-8?B?Q0s1Tk9jOFk0dE9yenNnQkkyU1lJTUhydWNoR3M5OGtYdGpreGk4QkdOendC?=
 =?utf-8?B?QUF4WUZKZlIrYmo5ZU9qcXRkODVxbEM5TW5tbGNUNTZJRHFZYTIrK3FzQzVX?=
 =?utf-8?B?VFozODNlV05GbXJOekJkMnhzanc2eUhoWEUzQjdvbjdSeXJ1NnpmbWh2NTMy?=
 =?utf-8?B?RFFZUVI3TGlmL1hqdkp4SUZFaDd0QmJnYy83QXMwVzhycVBGVm1tcW1UbkFJ?=
 =?utf-8?B?c2FXWW9IUVp2YVd3MkpBbForekVFS0NNQVVCQmFCS0xNZlF6dFhPSkxmMlhQ?=
 =?utf-8?B?NWt1YXMwMThRQ09TVEM5MFBQOHZMZG5odVd4OE1hWGRGQngxRjBDME9JNU5p?=
 =?utf-8?B?dXhRMXArekR0KzRXNWFsM240ZCtuZ1E0WFlBcEhkSWpkNGdsSUxkU0xRVHhj?=
 =?utf-8?Q?2cd2Tnogr/Ijp+4t7mmhMzorGeOQ9peFDXTNLsIjVQcW3?=
X-MS-Exchange-AntiSpam-MessageData-1: whUWb/r2hGywYzVfXQisLS4JQOxhiyiDBwk=
X-Exchange-RoutingPolicyChecked:
	P801YM5STs7v0lbOUKl11smO8gb5SgZHtj3xvtfao7y8DcrsDAqHud335oWnWeSm7evvjdKxVQA+E2ou9QbUzLr7MMuAt2gQphv/CsW99sm5pGsZ6x+YlcLeGcYjWf3svuIF9SAAZ6ZQDQdMw7pKUKSLAafvHmKumQphmCQA2QTjKeEs7o3YQiL0UB4kCkOr+JQVKEMIZ6WjLLBuS8fosPkpyQBl9EQ637lyz7fKuhPEQYuhiHfA4crEyG0VOsLIkZG6X5r2WtbMcLiVU6moggfopmytD8DM45Et/IUOaYUUJB6cJSkvXW6VTus4mFFXLz8X3Bgo7IXjW+qbL2ju8A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7mVB3yUMNMew8ppmTdMdLsIVnp3n+XJ12/K8kLBWQxNJ9dA8FgS2Y5hpZS5AFwshPfMl2+VGqZYW84IwpidD2T74+b4W27IlMtCQ2mIXTH8EphVSarPEsa5Is75+k9cPNXfbjGGuSsArJ7VoevMDvb/9TnndelpH3W9uhQEGZ90HQ4dQ2ueGnrI5zIgu3JYbdLQxyx6HaXQ0o5sDhgdhraMB4JDNBn70rUXCjm5ohW0IAHUe9fljwz3NZjtU+wSVVKwlEdbk+U+Uy5Fk/320dtL84TI0Ix4FR3C0Wq0ebkth5eB/PqaK8naLU12StG7YspQFyB4H3h15baFd7mC0HROSxm1CuYnDBUbCiT4o/EJHo17iwwC5B2bfjPPiv3bDAAVyqnhZdVPWxajFV4THzvWmoty7hol7lJA4Da0OUfpLc4VnSR697JODc3JU6jE76/e1tdIqIEfTqN9+Qr7XGNQKSSx2xONNVHli/R6ybXemvj7hPh/K8c0ReuiMBXcZTcO8Mb72CdqWCj+dlbREGYgxwFgqZ6YvRBmmV8tgnJGJkuklMsbrY1L2WXiorzRL+Uu/xYx7hYebzt9lxajU24M5vBF9zVvNUtWJidN60pj8GU/fOJbXtQm5NPVwc2by
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afdf398-4984-42d3-cbea-08df4bd2fabe
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 15:36:03.4946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +enWvQpbLJE51UdSZvojVzisJ+OvM2dtEMnvPvrkx+rs9K2IOeUmVTvmiT9YsIrYsIL9miHH06+Az47rLqFVbjHaYb2dMxXk6KkD+bAOJYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993738

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

