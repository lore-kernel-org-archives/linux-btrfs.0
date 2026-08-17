Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C98E433023
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 13:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786972819; cv=fail; b=rm9ILi0K5uocL/0Bo0KsWodFEBthakI8onZQaWqlNce1dvxaIcxQD+ryHSJYgZ+A4ooTHOxKpI+ZdF2Cvra9Rgrr8DwNC2k1osJthvLaKDPgAXS0c2SKN65iFalEjoJYgEkgHMmgDCj5ngAaTHjhoQbsEmNBhKB2cbppvOUj/WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786972819; c=relaxed/simple;
	bh=Mg6EaowBKZ0+4flPYlfgZcWAubfX8aLDRx+6u7iUjaM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OIp1AHUnTvtHQgk1l/gxy0chmYZAxHe51XIfcKd7LSmEjz/yMCZczOo/ShEpjX63SaqypXoxZoLkkDMnXFMRuburOONbq7wHeJqMgAbo5AuvoyeHeG0ZUkcpIAn/fvtKVVPiFQaMl6UldE433fd/N0T0D9ju6DOlF25pugqLUyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dLzwOX0K; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=DkcBxY7q; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dLzwOX0K";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DkcBxY7q"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1786972817; x=1818508817;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Mg6EaowBKZ0+4flPYlfgZcWAubfX8aLDRx+6u7iUjaM=;
  b=dLzwOX0KIiXsiSMvnFJWnSrafEB1XGLwiVOtD61lQollKtG/Hxd3/XG1
   60uHvKKQ6e3WEyLBdQ08a2Evb+WbeK+2F/futWNNK/QWApoZwhq8GFoOh
   WlQE4wbpe5g9+SyH8EoIWwN29jQMfW6SEU6orWYtKDq1PGcWTzUnFs72Y
   ugL9oBCFmZEesgfAPNO4PFVfk94LcUgVHrnV59OS0xpugDjUnSVGDNVZr
   ADf/TzgRUhEIiuRvjyQ/7dTjOWtOQ0F2Kix/z1Mwn6LRI90J30KryKLwe
   IeACnVa8xR4fpKtCMTFXNGk5Rdqja/JuVMXLDJ388fciWuo6+cV+RnHC6
   w==;
X-CSE-ConnectionGUID: scAxhr+iRQyienzAcmYysQ==
X-CSE-MsgGUID: WbRHx5ESRj+26JeoRJhCww==
X-IronPort-AV: E=Sophos;i="6.25,228,1779120000"; 
   d="scan'208";a="154244779"
Received: from mail-southcentralusazon11012000.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.0])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Aug 2026 21:20:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPpQTJlVeb0jeDsD9xOYoC8IO1HYHR3TqtbRS6x60OhLU4qUQ55q6JXLc6RvFbB0jbGXQV2MhL/QSCB57+JJty8ChF1H5aNPfm9k5KI+p/usmFlkGJEEQL4Hi+Rp9kiGntHQU1exOU3eOv78Xkob1/ZEXNW0iKAvJiNqcuHDPY5G+w66Ivmgovc/DWdxYVx7EcS8fW5sKzZgPBvf8gH5gVbd0JL0HD0/ASFr+jWchorWPjkhEhqSfIBYjqP/zLkI7kHEviAOHUIgPPl6V4XfjbD3hJkATl8AOlI7qwQFiDD3PUaJKX5Isc//hCmpxaEVVpMG0HlCjGPdJhkiSGZQbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mg6EaowBKZ0+4flPYlfgZcWAubfX8aLDRx+6u7iUjaM=;
 b=vNgTMPC8eCIKp9DlpUyqhGd5RCqLcDNe7gpZqIuHPTH3e5/ehntxj6Khq3ogu1B7vh1qJE/HUExA/sdbbObSHWKrRVt7yTeuIhO4YVNbAFnOthPlQ3hQmBOKMssAIjRILYIbD6RKqj9PIJkvEqi8BH8QsGK52VLpD9h9jr5Dz16v1Az66Vv8CiQF5yOFVf/IJHuknH8iyBBOVS9OB01y7rnZ6hASPtSg96YKmaez0tMVWSWHuZZODT76Lt9qW9gf639kOk+mce4aKBBLDWgtySOSLUKD40fyKXzOfaMV4Tzpcj5UpHAcO6JCt/0YYQdblqNoHOyM6A0/xabQBFRdcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mg6EaowBKZ0+4flPYlfgZcWAubfX8aLDRx+6u7iUjaM=;
 b=DkcBxY7qFfYnwDSd8HFG59R1U1brTCcpeGuRQNEoNl2uNNLlJrO8YZ+vvedoLB5DSIPxNdAQE2/cmaYjoupepf/1+1I0qRvopdJmX/MbmP701jwSF5YVZEslADQO+lu4+UfQw7h/JEaclp8iwKX7wcm4VVBYCrgbPrWh/bPTO5M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7125.namprd04.prod.outlook.com (2603:10b6:610:a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 13:20:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 13:20:08 +0000
Message-ID: <2bd55736-50c9-4b17-a969-93633f164302@wdc.com>
Date: Mon, 17 Aug 2026 15:20:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: rst: minor error handling fixes
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1786943382.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1786943382.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7125:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ba2471-32bd-46de-21fa-08defc62420f
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|23010399003|366016|19092799006|376014|1800799024|10067099003|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
 tOzdTaJc9nvvkBEva/uHwEn05iSGcWAXFHxKr0h4vgj4+GL7qR3d45fxyaFJBLnMyI6b+GHXMXew4/l0mkUtjXxx205wEDUqSt4BH4tOfWS0vEjdPZXYHuk75I2HnBtZCjuLWH4weKytREGnfWd2Tbjhkc9WhjNCvKXU36dUyaXxXW43h3VZWq9WZM9Q429McRHyGISaxQspN009qtm2saqr7ioB+9GhqOpNDO4os2NVNQwDY5eFtKT1AomCPSSQq7K/bsNhfBcvvL+ovaAHD93Ao+u2CZDA2/kcGd+c3Z6vHSmobac+Iu3lmg29MwKtwJb7zqERgUW638uCUspo/cMDO5ddLEmYX4fYo5giYYjLdBf2W+nPHbPJPKRKEg7Z7v8fW4Fr/NLo6yY8JY7XLjFmTjA7Y2jqP7iS5sqak2kcgKGVl9VyNhMOG3GfaoF9TkzdUCUI9bY08wgq4FJv7fv7qO08AGF7Da2rwCEtwL4JJVGzv86Jm9RjVyg/+94UV9NZlQwG4hsB7Al7gAkC8tbqEg8IuQQjh5tm6en6DG2GgwHRNeud+3RmmF5I8T+Dj/Sa8sqATjuNyXCwoUvkdL9w279udn/5AN8Jwt7qOdBzVaIj2XRDhXkHaRlLflLUOQSHHGYF2QCpu17V8ntVLQq9lgwAoypn5R/23F1miB4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(366016)(19092799006)(376014)(1800799024)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MzZxQ1F2cVRvZ3hNK1d6SkZzR1BXNDMrUjVPSjVKNDJXYjFoYXRDME9RMk5n?=
 =?utf-8?B?dGRZWVMwRkloSXo2bHVtN2NmbkhSUXBkRERueGZISGV2QWhZT2c2UmxGNzBS?=
 =?utf-8?B?NXVNOEEwZ05BcGFXMU5OdTBHYnNERXhQam5wOGlYVG8zYVRteHZoMHpaRVp6?=
 =?utf-8?B?VENSWmFDVFZmbThXRVdHRGUyaUs3N1BVRXJOQlVpUXRlUERVMjlqUzlRb05B?=
 =?utf-8?B?djZGalkwKzV3MFZMaGI2dlRJSldHc2tYVFU3NGk3WW9BSkMwc04zMUgwRi93?=
 =?utf-8?B?V0grV0VsOTVLc0FQaC9Ub0QwM1FVT21JZnlRZTVIdUFUUW1NVlJjWUtXa202?=
 =?utf-8?B?ZVEzbTZua09ldU1lQy94MGovUk5DRWprTlNnemlhQi85aVJaRlJ5Y2JEQ001?=
 =?utf-8?B?aXJBVWl1V21raFJoQWk1WHFaaXRTR3UrQ0JBOXdVRlJLRjcwRVY1Z25MUTAy?=
 =?utf-8?B?Q1c3K0xpcmsvVktMaHBTTGpxL25PZHpVSzZwbUE2N1J3WXA1ZllmRFIwbkJx?=
 =?utf-8?B?ZjZMa01DaXZpTENQbXpYRWlkNnZCYXJkK3RaTGhNZ2dwV0UrUGVkM2diS1Zk?=
 =?utf-8?B?MGo5Ni9BM01UV3h3UlRFUDlqSnRJTUY5aWZmNTRwVkVMZWxlaFZ0YWJ1VUcv?=
 =?utf-8?B?eHVCSUw1SmRrWG1qZllka3RwLzIwQ2FhNDNBbCtvVVkxUTZhVlNRdjUzaWVq?=
 =?utf-8?B?RDNyemZQM3Z4dGxEQnVHWlBTeDBBU29uZ0puWUR1bWhZelhnUzRYVG9BUVVy?=
 =?utf-8?B?N25iV04vZ2hMV25aajlUS2dwWWZlL1djZmZOWHJ3eDF3Vlg0QnFNOWNyTGJF?=
 =?utf-8?B?VitqcGNxSFRid1hZcGg0KytVc1dkdU16Q0JGRktvTlhMUlBjZllYM0RydGxt?=
 =?utf-8?B?MHJacnhMRHgvclZld29PTlgrV2IveW9CYUhXRTFCSytXL3ZjOVpuNm5KTU43?=
 =?utf-8?B?MDNYaVBRVGxua0RkZGQwRU9GbDlhQzV2Nnl2WWw0VjFobGltU3lDNUxzWHhC?=
 =?utf-8?B?TkFibFJWMlplSmdla1dTMlJIMENiQTFMU2kzeWM4YXRhbDkxcFBJOE0zN1Zq?=
 =?utf-8?B?UURWaHNETHRtTlplbVdmQk9QNjd4dEhuRDMvdSt1OW5vNmF0VUcrQVVkbEZU?=
 =?utf-8?B?NHBnSU91Qmg2dFU5UXc3WFpWN2kvbzFDMTFYMzY0Z0F6dm9iTldjVTIxQnhQ?=
 =?utf-8?B?RWNBSnp5Zk5PdzFUNnBCamdaV3IvZ2ZHb3NDNThab3BZMlF5UklrVURUK29a?=
 =?utf-8?B?TThOVkJhWGsvMXo2S3U2S3lzek1CRFlMditZbi9KbVlZdmR0aG5oalRCVFlo?=
 =?utf-8?B?K3V1R1BHYi84Wm81Zks4Z2RPY0RVcmtUSzFGUXBSTXg1a1JPd0tlcFhlZVNB?=
 =?utf-8?B?cW1vMUNFRGhRNnpmcFRHcTdKNmxnQ2xGNVlvMmtKZ2gxdEF1dEtUQVZHYXV2?=
 =?utf-8?B?UmhqU3k3dDdpeitIV3Nmbzg3UEhjK0I1NFNjSC93VFp5TDc3b2xKVU9Gb0hh?=
 =?utf-8?B?T1ZoNnR1VHpidSt2SUI5am9wdFBQYm1MZkI5UURmeUJCTUZCTzFVWFFZTW5G?=
 =?utf-8?B?ekJTWG5uRWVEUlpwQ3JSdE1hbWRvU1NyUFFsa0ZGcCtZTzNraXZXRm8vVEFi?=
 =?utf-8?B?WjYvWkJzakFjZlhOY3dlZzdGVFZ2RXFId21wNW04cVFDOGZNb0FFekdIVEY5?=
 =?utf-8?B?Q21lYkkxcTRQTEZXVjJJNG1CbGdsQ3pkdno0YUFSeHU0blN4bXA0TXZxczRw?=
 =?utf-8?B?cGs5YVYzaXZrWEdyZEErOURxZmNRSjJOOVIrRkx0Ylh2Tm1iMHhmZVhuQWZ1?=
 =?utf-8?B?MFdaekNaMElQMDlhVm1uSFIvM2NydmdKdk1XMldoaFR4VGNNZDYwekN3bTVC?=
 =?utf-8?B?OVQ0MUpNY2lTZm0wZGVFelRINTVROHJNenlzSm4wRk0xYm40L2l3ZGwzd3Vs?=
 =?utf-8?B?N3FLVG5UZnJORmFCdExoTWNlWmt5SmtRRm4rL2N3b245Mm50QURuclZMbWlG?=
 =?utf-8?B?YWlXQWhWdXRiamxPVXJsNDRtY2VPNWUyNVFYT2dZSzFHYkNNZHhEaVEwR0xQ?=
 =?utf-8?B?WkFFb0ltMnMrNzE4RGl6Ti93ZFhiU0J6bUtnSnhGbFZPY0Z5SkovZG5kWWhJ?=
 =?utf-8?B?QVkzbUN5TjgrV2tURnFMZnVUSldtK1gxV21FQml1WWQ1YUI4TWx2R0RNZTZP?=
 =?utf-8?B?dVpoMW1aZGxyU0xKR3dkWDBvcVpwOHgvWnl1dGEvSmlVMWw4MHQ0YjJNa0E0?=
 =?utf-8?B?Z1hsNjRtTGhheWVNR1RRcEIyYTB3MStXWUV5RTJKV0F4dzIxV1hIWCtObnVk?=
 =?utf-8?B?eHQ5TzdTbkVWNDIxKzJMcmw3UlkyZkp3TVpjL2l5djNBbDJVUE1reVlJaUhp?=
 =?utf-8?Q?I0GNBr0oOyispe+E880zZm0E8jo141AYi3YDrWwUERRGL?=
X-MS-Exchange-AntiSpam-MessageData-1: M90oHrK0/AUOBK4USgd8uQLXRVU2pcK3DjM=
X-Exchange-RoutingPolicyChecked:
	RfgroOk26YdAJrzo+UKWFvuLd7C0MrVkrOa8SCPa7sachw5QUK/fujRfDgtMU7tFAGEvonwRvvQT3wUnbDV447qOUiBH5EhLZNsc8cJXRQht8NpYSTZsfGu5C1YuLCPV73gvmZDlKLIpMrgraMI7+17ZX/iI+RA0g4w3jgckOw23jjS0L5W5uM2wztBdTeqap9SLvNmPIGa/sBAmPBaZJcPlyvqF1PeDcJQRPYw1IhojFkNSix0i58XgBwZk7qc3VQIJ+U+yQRnN3GmhyRpuGMmTUkzMi4wSUAK96drPF5bKfXVGQr9vFBAw+udsfbhi8uYhU50bma/Tzhh7MdeEkQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	agE3CX3KNNQYlBGDCSNgtCAFaD/8lQsAlfYcIXyouZDJIb3VVISx6saocOsZfYNe1VciUFz2kgTaPeTOde1PkkvpZPX7+pzFTQODNKXdCN/Yq6vBHK+FAIGoXgLslR9C4JpYxbSQxXKdLlg/YPNAbDh/orbDdfQEGzABywKOPpys1shwygXK6OGjYbqoVKF7ufwSWOkd9ob5Zeowyoa8kFuMAdwF59h7dqND7kq7WGSKtkyi5XZ2e9HHLml22/jLONwd6B2MFthncdck/osaGZlgHGm398421xVY9Px+gfur3OkXupLEdCSV6W1eJCVE71rIBqr5ZZWnqgYRPkiupgrrzIe9EDxV04ZE7WCKM9aU96Yy8IVt3JaopTcRsYaHfcd5gURuvAZ8dMV0Am5Qh66DL/aHsPUqXP5FeziPkCixaYllF4YU7V33cTrJzRo97jsUHMShht4NUWygzTnOpwHiStKPgiUinQFebq2bRuopd+mopT+JUGah9KyAWi6HlhZPn+FkUZ7GNRoktkWrTc1YZifEb0Hrgyuz7nwtUThk/LnnV7MdbSMbl4Ku6XnY8KbiO1Fp/uYkRMgVClnb+8rVKIlYdy2VH1F9WlbyM+8LMvLuMdCVEV7864jFzMWj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ba2471-32bd-46de-21fa-08defc62420f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 13:20:08.1543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nRM8mY+NJgeNtTZ+g9Q/EyKj31v+DSyNUvkcidFro25XEwOFBEdv7KxUMVjoEfXqVpkwueRBn+rnQzh2XGsy+IruzbUEFQBR3Q23hN8JlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7125

On 8/17/26 7:13 AM, Qu Wenruo wrote:
> Sashiko found two pre-existing bugs in one small patch unrelated to both
> bugs.
>
> Both reports are validated by myself manually, and both should be fixed.

Looks good to me,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


