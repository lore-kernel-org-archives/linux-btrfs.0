Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795773445;
	b=rgLHbmxKLPHtASDyeDKPzi9o8ej02E8J0znTWz/GCWOeEihRoiu7O/Pk+bh3BmsMKDwd
	 aO6fpDlWZz36q5mcswspY5fd8ccRyaqFjn7KqyVuHVhyq4QIikU97e6q6LIgnsqR8BKJg
	 U0IX0YFc70XKeowJFVVUD8fz0lRASFXsPWxN5ZXlboGpVOHpy0aRYnrXWnN5K/t20j0FE
	 xduZDjPtnouStn3uY5qCUH5zVrW7eEQPKiJVeREineh4iRvh3cmr3e2fVAtffcbSvQSth
	 yf+NYIhQXrZq+ELZyLhFU9ubDbW2yD42KB/gm7+LLkeDJnU8CMJdkbm9MB+Y+7H+MNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795773445;
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
	bh=r+/5gWo4fojPkiFrwA1Qu27revTZ1bHvaW1Qu5R/SIY=;
	b=gJjwBL4bqbe526Y8MeZsNmvrIjP9jgy+L2RhDsGJcPjCcxgdu3G9ThBqX/Pn62Nsyhvt
	 afOEbeVLK3yQjKX/Cv3pEaeoyyZlUtOHxki6JDR7fWgXpc6xKxGGKAx+DoGnRU9LpXZgH
	 O2n3WIdAU3QAghcJsagWWdixRrIZCKvW/+PrS3cVQ84NE5F5svfzddrLRuHGCie9uLcKb
	 76f0zckgMOXpZIutmeUof+678gWcQw34aCqChtnNFGSRR1jbK2HtoZOenT2MxXaUsPBOM
	 KdhpaFQtyKNwUSU75xgFR0yXZJOqVFcsZO1crKtUrezjj2/ZXJnb0w6uViUqrRHfdiA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="G4CWcr/k";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YTX8sTAg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6A4606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:57:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B6A4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=G4CWcr/k;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YTX8sTAg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795773444; x=1827309444;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lEnUeTg/H+1clpBOGeZITcD6cb3pD1nN6bXASnfTrws=;
  b=G4CWcr/kw3yDWp9B1STuB9nRrwSxmFB4LRlmbwB6H0RnV6CH/0NWk9Ss
   WHJGTCH6raTqiUjlHDrisa4C4V6nXwsrRmA3MboI3QCUQJWw/3mKMKC65
   n/TtkJTRvb7kgZ8tiVKyKDYPdMOjci8iMEUwD3TgKgZCuUWF9uf6mtV36
   wiE6OOU2CBCzfOrwQxWbbYBJvatQWYha1EiZVi/kwmlBzqzGu74FbsvEO
   R5n1EDMjp0wT8md/OkEM1opuTzaeRvtUlkVFiqt7fZ3tdJsGE9TkQo0ML
   RtGsFRCDjxqHOWMHaGKr6BGQgB2mOmHnaATEyKmvYhCpStknW+MQjBwEr
   g==;
X-CSE-ConnectionGUID: ytwkiuwYSYqH8JaOzlUxpQ==
X-CSE-MsgGUID: jOlbRHLBQaSW1usrPYvVWA==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="162885417"
Received: from mail-westus3azon11012036.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.36])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 17:57:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MMXjjHTn4HyO2S/2DDTM5W0AcHazbGgceXaAtghJ7CcJ3AgeUIP2TnYIq76/RBvnTQZSZyzuXKydYJavO7FJgveTZrSUcKaFTPa937ajcVELVl9nKjG40LTyd5RP8NbJPRqNVGW5r8WPynRcdUI9HCsUfsW3HYW5QgBihAWEUrwTehfhqacb8QLSs8Wnv8mok+rHomqfbYqjrMYI6HrdefA4PsUSRH3+ttzjmH9u6+lMDNqNtD816MP/fz/OTPUkFm4aJTHD0jM8IZh692daOfqOryQ68XxKIsb6DmZGEIwDH3q6SdvX6Lfi7MTbSejioGowUtuMGIV+sFydwm8KHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+/5gWo4fojPkiFrwA1Qu27revTZ1bHvaW1Qu5R/SIY=;
 b=jBd0G094ZDDnfak/WMWGi48YGfBm1efxW5kLTSSpk6UTSQbpzrdkHHDbcmsiDK+1rU5Qm3ITrDtz97oMi2BFZEtho+ECZCkle9zO35WEM7h81Fu3yFClod8jk7DC943rsaOkbG3hlmoxhEkirDn8s2/m9S4jp60/hu7Ip2nBxfiCRQtgyvDf2siIQU27Bulhi4Ktpfa0ma4j25U/wjyopDa77cKSiu82cbE/KrTBCxUCIeLDheCUe+Ga6giIeeLiMYvoWu0FgeQin9QMj2BGfB7r8ZkaXpTEE+7LCE9bV/8Y1JTz6JGHSwkUAih1NsHIKzC0izq6oEKFZVGlXuEkJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+/5gWo4fojPkiFrwA1Qu27revTZ1bHvaW1Qu5R/SIY=;
 b=YTX8sTAgqTA3rVwN1yAPWXWfYXAk00amlaOka7Tg2laBptMCy4u61+5JQ+8suuNRDJEpMJGOTCeIYG/SJ62ns2I2JqyAY+wfrPIBebih+q816o/5ukC/lrDOEsaoMkINCFutX+b9awsMyCub2E8cmjv0zH5BgqoKV2WBs+q1t4I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS2PR04MB994410.namprd04.prod.outlook.com (2603:10b6:8:4aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.9; Fri, 27 Nov
 2026 09:57:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 09:57:22 +0000
Message-ID: <7d254a04-9bcd-4f23-8900-edebd03fdb36@wdc.com>
Date: Fri, 27 Nov 2026 10:57:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] btrfs: zoned: search for hinted block-group in
 prepare_allocation_zoned
To: Damien Le Moal <dlemoal@kernel.org>, linux-btrfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>,
 Wilfred Mallawa <wilfred.opensource@gmail.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
 <20261126132820.570379-2-johannes.thumshirn@wdc.com>
 <a70e0150-abae-4545-95bd-e9bf7f594458@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <a70e0150-abae-4545-95bd-e9bf7f594458@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::17) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS2PR04MB994410:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fdfbf23-c8bb-4ed4-22cb-08df4c6cd3c3
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|23010399003|19092799006|10067099003|56012099006|261021135927099003|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
 iUBGxipjEb9EmWluu+cjQrHoAQh60jPPVhP6RT9Lf3KPadIBBpPWJr/cdGHxmW5FvXlP7QN9wNtwjU2j6uTDccsbadMfXT8I3yA6Lxxhl3ZkuU1Oj/vhzPX/zUnGjHOBGlu2I/LS8OzdpZRNV9FIVhjklv+YVNDcUFgFUJbltvlEu0p8+zwG/Q0islCGjXxp72LdvQad0toIEY4PBoZspvdtpD2qS1Dy/YZzfP9cPLZLZ4fJYbTKYR8Xf+qXHE5UmjaOI6tFtdBQDa55WmMrEhx/6erkRovWXG+8yNurWuiHoT9ij0N0O2DjrwBYO5ItSPyvaslpgDJcx7uTA7EAj7A+pXK2+R9n05o5jQE4o83yoITVhxJPBvHSrgcQTVH4Iy+Enn4BYttVD7+r/4PmauErozpFntKEvtfXn2Gvx8SviG2fyN1TnkkiyPz/Hc1CvJ6VCD3ynCyeWZ95KpVG1QCogI1BU24P6C16fNEzRgUSsj7frJVI9Pwn4SxPYfu/rHcrFJ93v84qbbtLSHKsXqvk5XHXXlSVo2ryfHifDhXBZ8nNBHjYZVCYGACVIh/WL/7LDzGHiuxW5VAFoFy0rO0fbl4DWQ2k0kvgY+uzhMasdscoRYK+acqsUHjAa/T2Wzma+4kaJTCOyN3vuPXB8gfoaT4g1tI1BkmJQOBVWwY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(23010399003)(19092799006)(10067099003)(56012099006)(261021135927099003)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Y2VaeWU4NzBKZGpsOUtmUVJHNSs4NHkrRW45V0t4VjV6anRUWXFBN01WTEwx?=
 =?utf-8?B?d1lYY3lqRHpKdDFFR0NCYkE5OUs2a0dJQzJIU2FoM1YxUnNnMWU5akZUNEJ5?=
 =?utf-8?B?cm5LZXl6dUl1K3pNVXdSemVLcE9PZ3hObE93VGJJYU03cE9WNStjVWJUUDBk?=
 =?utf-8?B?a3BaN0hVbWVGVE5vVTM1TEFnMUNScEc1QnJJZ1FwTnZoRXpkM3V3ZWJGYlRw?=
 =?utf-8?B?UEpHSCtkL01mOWxONXpYa0FPRWtXWmszWFJabnlmWmZnZnBVZnVrMlpyY0dK?=
 =?utf-8?B?WWhDcGp4ZkZhSDVHQ1Y3SGo0SlcyQ2RKdS9wVG1nbWRqek5tSDZpKzZJSEw4?=
 =?utf-8?B?WDJpMWx0aXdIK2IraitwVUVBeWlLRWNBKzFCWjFoNXVWd1FrdVpjOHJKTXl0?=
 =?utf-8?B?YjY2c3d3cGttMFFkYmdnTktrc0M0dm1uMDYzMkVYUzZFQ1ZIVngzQkMvbHM5?=
 =?utf-8?B?eE9jUlJGV2RXbXp3R2FVWFFUS3kvRHdGUUpzM0dlcVFGZXFpb3ZQTDRJd3dZ?=
 =?utf-8?B?L0ZiYUlRekJ0N1haRnU2ckdFdHhhZWR5ZisySnkrSDF3RWtxcVBFRnluS2dU?=
 =?utf-8?B?Ymd3QlVlL3ppSm5VM3FBWVFXTmNFcTdCanEyM1Z4RkFKYW1RMnh6ZHc3U3hD?=
 =?utf-8?B?SnhtOExWaHlSNHcwTng4aUhVcHYrRGtsWFE4c2s1YjM3UWh0bmprVFBkQzM4?=
 =?utf-8?B?ZFc1VG1nOUs1WjM2SHFKT20wc2Ixa0dqWm9iUTB6cDVLRitTZC82SFZScmVV?=
 =?utf-8?B?Z2lHK2RzUzY3eXM0SmRBcHBpcEYxNkZ0emJBYkV2di9xcTJrS3ZLLzRvKzU3?=
 =?utf-8?B?NTQyUzJKZHhyMmZWeTVNVS9iU2M2c3IzaHVidDZCVXBEeXkwb3QvSy81RmdY?=
 =?utf-8?B?Z1pDR0VjV05FZjJXZy8xTFE0dkJyWGpUcmJPK05YZ0tMeVdBWngyRlNUVHNO?=
 =?utf-8?B?dzNSc0h5MWNmNzVQSWFETGdRSkJ6SFJaVnpxaVM0WXRHcFFCUGNXbDAzNk4r?=
 =?utf-8?B?bnpXaUZuQmMraXgzZW5wc0NxS1pPeFNYNE9MT2ZNSW0xdGZHYitra0FXWVJM?=
 =?utf-8?B?Y2FrWUI0WTd4OHNiQStES3VLa3NpUThtZ2dMQUJOQzdZZ0doK2FMVzFzeGZN?=
 =?utf-8?B?c0Rudy80eExLVjB4bVY3eWFRMUdDNnN4dW1rcmFTWWtZVkwzNUxGYWhtSGRU?=
 =?utf-8?B?TlJDZE1heWFUaDZjTnBob280ZlNOanVZdFNwNGhya2ZoMWlZOHRUVjRRVWhG?=
 =?utf-8?B?b3RqamVBYU0rWjJ6MGNuSkcyby9QNnM1cHZPcyt2OEpSL1JmamNvNVdIeXFP?=
 =?utf-8?B?ZzhNODhuRzU3YUVjWWZrR2MxR1VqUnprQ09nUTRYdFVVZDd3NmxpTEd2U3Iv?=
 =?utf-8?B?bmxLVm1LN2dsbmNSOWUzNHhsSFJCUngrNTlKTzVnYVYxZ1hiR203UkQzcEkr?=
 =?utf-8?B?V3JZaThiSExWaW9QdHU0ajJXcTkxRW1LelUvSU1ycU1tODhDRXR4b2tWSWgr?=
 =?utf-8?B?TVEySXJsVzVPQVR0b1A3SnluMEFJRFo0VnNaa2pqeG0zZk5ObjY5M3JGR29n?=
 =?utf-8?B?bHBQQlN5MFNjajcwa2Q2Mk1sNFVPWUg4bnVaQ0hJVmliVDVIVmt6ampLUlFm?=
 =?utf-8?B?emEzMGhZS3RXVlYzNWtNMEYxNkhIRkUyZEprZFVhMEhCVGsrUzBzN0hrQkRv?=
 =?utf-8?B?MVBFb1MrS044Q1hIanc3OVFiTU9vd3dQcXh4cnlPc1MvVkxyVTZCdk5sUUNC?=
 =?utf-8?B?QzZkaUQ1ZlVUcGljYk9sclVUZXJ6OFU3cjFjOFNlcUdKL2U1aDhsTkhwaGkw?=
 =?utf-8?B?Z0R3V0VQRkZyL3NETnFhTHJCRVJONGVrTmQxT2JNbFBma1BHS1lNOHlNWmVq?=
 =?utf-8?B?RkJiYjdjZ2hWOVFnMjhXTTJ1RjZDcXIwZHZlVEJzdnBaV203UWVUY3hDMm1x?=
 =?utf-8?B?UkdncXQrSGVobHo5bDRodWRPRmxxeUlrcTgvK3dMaFRJN2xLZlpkaWFBUFZF?=
 =?utf-8?B?S3FWSlVSOERTOTAxN3lpOHJZWU5CR2hyNnl4cXNaaHdLakZSYWNOK0JvOVc5?=
 =?utf-8?B?SE05a1ZqQUhGTVNNeFNjY0g1K1huL0RWOVljZEJaZ0hRQzY0bk5hQXRBMHhI?=
 =?utf-8?B?L21ZZTJaOStxZEJZU2VySHZuWUt6OW9LTVo4aGFCN01IUFdESk5qcVA2T3dt?=
 =?utf-8?B?SWZyN2Z2Mnp3SlJwOVNVQ3hGNGxLNElzZ0RmcFpIUEFPbDVnOHFuV1pxVFBO?=
 =?utf-8?B?dkFFL294azJDYmxZaTUrdmltS0lGdGlFbTZoSEVsTTQ1RUIxUk5hTEYyVTg0?=
 =?utf-8?B?SHNUbTM2OEpLeWI1b0w2QjhSYTRSRUw2ei9hVzY5UFVlT0tPbUhqR3FUWHRM?=
 =?utf-8?Q?VRn+Dy12BaMVRKG2MbO4d6+tQwbbAQR58Am+8ySRKhjFS?=
X-MS-Exchange-AntiSpam-MessageData-1: t/bPOtlLNiFU3Ntfw7m4b7ecc69v8ig7zWY=
X-Exchange-RoutingPolicyChecked:
	bCmP+o1D8IoaX5eG/qoG3DJiRBg+7sRDxvUCXLEbqPiXJ7agBn1569JlTHgGMe8HHXopk6+S3FTJWPzcae6qADWTIh3MkNy7O2jk4e5zXlJxWVxcYQthhtoR5OZOHd591E+cgnpiUmNda7yemudT+KAPed1NdQpTBklQ0WjsSWW6qQtd7awmv1/MViZW/1646wy3VLp/CqpPKw7SsxTOAvnbjoArQViXwUIcPCwYiPMKI6+c7rG1R67JUSZkMdih4vwmdNd5bK9PRJUWfjzFVg7phpSgE1YYl1E0JgVNwcq2Wd2og9u5y7kpUvKsNuKgzP3Yu59DyTfKAE7qBlIJAQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7QxvALbozYhBC6hiX2eHidGU9toys2vekz/s7AEVu+Zbp8QT9553nk6jXAq1QnE4Q72sv0JN432qqk2XnYhA2PBiScy1ke8zGa6F5xgv/hAh47kjp3cHmpDRSl7/ZWWnGRNYCE/csXP1twJ9V3dt8oGNFGJS5Z7fbZ+blTxZJI1SUpEesf6TqzgmkyCKv9pgFhND4r00WN9gMaDX3FNr6AZKtAEwmdwYaRalY4BzIUj52aweFgaY9Liy1bhddzRR2RZiC9e8I+2INVlpjdjY8aCm+gZgprPbE2Cdkkq6PGmK2oIm+N+5B3u1zmkD5l0FqoQ2O7BylI9+3plDGFUU9dTJSDUK/m5D4XySnX9YXu4hVMz0xbel8Fsogd6LszSFddVrWgPHox0ogvfIt+D+cA9JZSWcSCDBO/pTYqZMruXGotvBAEh0ed1eLMH6o3gFBmQzFQoBbXl2JvuV9bOE1BINEqC4pR7zluFARdbk2YJmh3J/KP7+zxnlh2X/KBYDdGR5wXCbDYvbCFdpnqguU8EEiwvJ3HQ1OAYtiywn8T5qDe5pwowREvnxV2CfpkIFT0yk3SSxoIlosNh781cpv0h5K5lRgyLAl6ScvIS897eOGwV/NO/tHP3hqsxm0rve
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fdfbf23-c8bb-4ed4-22cb-08df4c6cd3c3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 09:57:22.0403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QetHCw5bsexF/S5/oGL7g31rV8RXv/cmBkZTDghPrQpGiXz6xja2Or2kASoxP4MCfVPPG99vYgKfbgqtIPWkgG2THAfrZWyI8JZEwUlXa4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB994410

On 11/26/26 10:09 PM, Damien Le Moal wrote:
>> +
>> +	if (list_entry_is_head(block_group, &fs_info->zone_active_bgs,
>> +				active_bg_list))
>> +		block_group = fallback;
> It took me a while to understand what the test is... To make this easier to
> understand, why not use a "bg" variable for the loop, and set block_group to bg
> if the in_range() test is true? You can then simply have:
>
> 	if (!block_group)
> 		block_group = fallback;
>
> That would be a lot easier to understand and nicer to read 🙂
>
> Other than this, this looks all good to me.

I was kind of "proud" of my clever solution with the 
list_entry_is_head() for this, but I never came to the conclusion that a 
simple tmp variable would've been sufficient :D

Thanks

