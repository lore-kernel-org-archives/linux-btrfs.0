Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1B53F928B;
	Thu,  9 Jul 2026 10:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783594247; cv=fail; b=arTAyZt4/IX0BLTq36R3mkN0si52w3fj/tiUV8M1eil9jYCfG8s8caw5lJ4ftqRj6ZuQCEytfAbCx0CPOVPbz00eyB3MiWOiuM5i5lSvEfKWvqApcJ7nldPVHnvTWWVcwIuV6YH+izKK8OPZe8bGTDCnvFWB5iFL6jB2qFJPVAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783594247; c=relaxed/simple;
	bh=NKGqy6GmdhLQOjmL9hcCuXXKTvL1MaAghLZuZ6DiyQM=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XCBlfMcq+QTYz7/EXQA3EkaWkSK6sojZpU2X55cARl6G93kSoT029X2pMFdZAj7WrgimjSEkIUag9DxlQmPVqfZ007zoQIbK0/zljQRNti5B/1SCvqqWTtGMQ+5px3P+zBdHwSn9ZAoRngb+kG8dWODkBZtPNajFZ3BSiy9eWeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WSmZilSY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=lq1jA6/y; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WSmZilSY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lq1jA6/y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783594246; x=1815130246;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NKGqy6GmdhLQOjmL9hcCuXXKTvL1MaAghLZuZ6DiyQM=;
  b=WSmZilSYWXYnIZlMFL09FaB9WtK2+pADcDGcgiZ2UZX0V3Y7dmKDEFCf
   bDhjYYJkm4wH13t2zzchl/exLRulc0pZ75b51DBmyFzLMy4PBn2sQY8bc
   E2wNCQF9IsnoUpgGxsgQ5ZKs8BxnxF20RX+vVE/bTkt+IqHPtlpgcsBws
   CI1ZA7Vb7h1DSrHm/Ugf8Gwq+/EpZLB6/54FY0Uqv2n5gQUSOuWQ2gabc
   62hqzptr+aWuLMVNiGHvmk9rtunQeNzi1YZiDca0P1KLAEQOFBEXDdYOP
   XerVrX/ihLuiY3rlgp0NNQAACKDgcXDOXVszQLzdpqHq0a//X4EnnGUhO
   A==;
X-CSE-ConnectionGUID: dcmRxBNNTFu9YlxKJqhusg==
X-CSE-MsgGUID: vDQpKeQxT1Wo5Z/oehiHfw==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="150392884"
Received: from mail-centralusazon11010040.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jul 2026 18:50:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KePbghZkDDUlRBEYBSQVp3JJw5oWw3sKJdICN/Im+EpvF1oKDWWftw8NEji4KWH5f3jGmrwgV+kfcFHM8jlM/mBnhhPz5wGibDWA+OQyHIaoeJVMebpG0tNYwEPF6QG4FHeaP6aazNf+P4EQ0hAhHpNX6xVyLEbCIhYdaP7tb8TDf4uIL2EWJdz3/N/I1YqQ4SPZRjkBSfhu+vMhUoihTuTzm32Whd83ACe6NQ9v7sFXVhVD7wzVlVFNACcXj3vJ4QNQozYE6Qqq7ISHduwEFBXAfCwcmaWu6/Xvzl+pneVtA0QWdQWkgxRchhlLVdKIYVwDjo82BCy31NDdas+1+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWi2oxOSRAz/x8K/cc8pyYcMBDZ7+odyrQEZqGI8oB4=;
 b=ez52hSeFmMI5FLmPjDuuKqhuC68C5t1uAtCXDKf+J+8J/8MCIKWIedS6mx++j0WzlrkQihRhpQS800+GQmwFK7Ripe6MggrJc8QK/GBJzuMHDD4aJ/4wSpcDzOuV2SThQhFDkHVPc2jNX/+7MFhJTfbxOyq+3mH75qkiC7PW83xSlBgXuO0iPjP3wD9PzTPLayHF6Jy07JtRVR7VIbHsZw9LcUQZNN9/WJJmbvLYf1GKHTCo9gGhpC80T7RpVbvTIDyx8Bco6o/3VezAxN25CCcvcQY5PjLgzjRbjAuvDmPZv3+j9YAmBj3o48bgx4jSFJmrqaF77ZxbtH6lgl5V5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWi2oxOSRAz/x8K/cc8pyYcMBDZ7+odyrQEZqGI8oB4=;
 b=lq1jA6/yCg9F3X620uhwSfVZEzCWHRDuVwxoeZ8WimDGJGbvNC5UPLdw5s25IBzX8VEeSGXqLeQuK3gs2GwnsXck4dAZ/nUQ9tA4emgcVBVDqanNuUcFxMhOdT/jD9IvkQnMoWTuKS9ZO6kZX5kALAm33JIN4m/1xTO+8fSWYa4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB8474.namprd04.prod.outlook.com (2603:10b6:510:2a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 10:50:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 10:50:40 +0000
Message-ID: <0caa7fb6-15c0-44e8-9592-8e7ca09cf921@wdc.com>
Date: Thu, 9 Jul 2026 12:50:36 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: don't submit orphaned extent buffers
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, stable@vger.kernel.org
References: <20260703055431.117181-1-johannes.thumshirn@wdc.com>
 <38704f1d-5880-4162-9051-4e6d0086f8aa@gmx.com>
 <da322943-0b16-4819-8370-6c801f836eb8@wdc.com>
Content-Language: en-US
In-Reply-To: <da322943-0b16-4819-8370-6c801f836eb8@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0371.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB8474:EE_
X-MS-Office365-Filtering-Correlation-Id: b795ac34-bc7b-4e4a-4854-08dedda7eb21
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|19092799006|376014|366016|10070799003|4143699003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	+VUgixfWMAM5gwTgkoKw1yIY0gPpoAuq5NFphjgF4bamOOPuXfYSQUQTOdqtL0dcFQ5WMk/h5UujlcJfgoeqqG99defVaoDZGEBCnL1iSZ9SY6ao8eR3Mx4hhDyxPsI2yhTM394F7H77xFph9SGXDQaFl/fGljMYQJ9eCfJXXQ+dl+bOGArt27GgXgvNSief32WPvQZS1+UBL8UD5rulnbs0uJpFO6jli7b43Tt0xVi6BfhZE3rIuYEeK+JRH7M1vIxFRJP+3zXuLnYnlcLt5faRhTAvGUZQ6PM/0ODBY/AxhUwrpHHl+uoR1/l6uGuMqRnSU2AU6S/UPnVKyNOx7WeWOQwOnA7zhIxOgXzl1VQ4mP1w+hArkd6eXRANT7TtT01UeqgnD70L+wP3Vo0dMvPhMgXKvgt3OJxtvwXIrWySpw4XICm8SKH/6Rh9xukNgugP6jDBkY6UQgCEKWia1GdDxloF5BOUy/4TKNrBqARQKE1IR36xspLzKJQyRNzUNDkxCzHwawj+HuTjnQ40+5S+7BZH+hEKs9vqetN2LGTatSqPBs+ii7TOF8fRm5uPxwYOwpVN0B7+i7kFi7YXLDVg07JleylBMAVHeKeEa4qIok4X+qo6TFfcGHd4/2HYXtH2KVjMhvBiV5Zp9bc/qDqcfHIc2Nf1pvWtcwpbmY0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(19092799006)(376014)(366016)(10070799003)(4143699003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0czSlN6Mmx5eGlISzFFVVJQR1JaTTM5ZnFML2Jab3RKVkhNajE3aWNEVEtO?=
 =?utf-8?B?SWRNaUwyWHRJeHl5WnJTR2YyWm1VYVBETmxiVk9qS2h6UDRKMHNzQkhrYXpa?=
 =?utf-8?B?S3pRbG8xRDRySGZtTnhWSGFuMXJOSUMvcHVhUHBWQTZRUnBnREgwbW9JeDJI?=
 =?utf-8?B?ZnBhL0JqVnpTSnZsWHQvTk0wK2NTQ2hGYml6ZmY2Y0VHd3ZWN3ZJTDJaeEp2?=
 =?utf-8?B?cG9aUHJRcjFGWi9yVGNFSXpVUm5ZRkNoWW1tUmlPR041aWFFbTlvQUFUaGhH?=
 =?utf-8?B?dCsrMGQwTFg0MitzMjFqNERYRmtqZHU1cjlFVWRtbDBnRjJGQlRFNkhHWDRD?=
 =?utf-8?B?b2pNR1czVnJ3bDE4MjVZa20ycCszcnM2SmRUQzJ0VlBJZkJ2aTNPaGRlTE1y?=
 =?utf-8?B?NzVrYU0rS01yVFZkNkRYL3J3SDhaU2ZWcHBQM0NVNmMzUTVCdm43UnphN2lr?=
 =?utf-8?B?NXVVcGF5WGVLVThma0xNR3hHd0w5aGZRckczcldSTzVjL2NhNGU5Tzl5L1hT?=
 =?utf-8?B?bVZPTFBvNGdOckVsV256MFBQOUg4ZWxMYkEyMWNHMnZNMnkzdHBaa0Q4Z3hH?=
 =?utf-8?B?b2h4b3dpYjVSMUU4K3U3aDNHSXdybG9RUlllRUN2NVlDcGhLU1lYeUFHdGFF?=
 =?utf-8?B?bDUvcTBpQzNlbjhpTmg0VUZzcUIrdkVDMkpyNkVnVlc3ZTdBdFo4clMrQVBh?=
 =?utf-8?B?YkQ0cUFGN0hyQUcxS0dMN1JDN0MrQ1dCMGVoS0hOdzlIRFhkMzh0WEQ1S1p2?=
 =?utf-8?B?cTNRMHBnQUkwbDliczhXNzM4OURFSmZkdG5DMnlWQk1Kd3NVU2RRVHVsREdD?=
 =?utf-8?B?VkNWN0RXRHhlK2M5alkvOXpsWGNGTXZyMmwzUHkrUXFaRzNqcUo1b2t2WXZO?=
 =?utf-8?B?RXdSaUNORktTdGJ4bzdCK2ZaT3UwOThEWlVaeDIwKzBPOFZqZDl3Nnh5ekEz?=
 =?utf-8?B?Rk53NFRtbUNiNVVVTjRmQ3EySzRDbU9pY2tQaXJxeVQ5aE5VaFNjenJONkwv?=
 =?utf-8?B?M2VUYmlrVVRiWGpwekFGeXBYd25oOEVuZTN3N1lsNnhXTlB0N2NXMFdHTXcw?=
 =?utf-8?B?TWpueWNUaWtUWktwYkV2a3VOVGhNaDVaZlFQek9YRmlCaVliTG5pd2ZBRjNJ?=
 =?utf-8?B?MEtLWVFPdEpIcDIyRWhCQytOQ1lwMlJmU2JMczFjT1JidWc5Q0RoWUNScE50?=
 =?utf-8?B?QXkxU1BEdm50T0RiZDNnYm1XZmwvN1k2NUU4WXdqQW1ra2kyQVRpSHQvZmVp?=
 =?utf-8?B?S0N5b0cwa2owR1JuMzcwYSt3cmFJVFhzQzBjb0VLWXJBR1phZXZsQTgwMXdu?=
 =?utf-8?B?TlJKSGQ0VGVGS2NJUTFadm9DNnNxVk1zdmxvTWxVNUEreWVkOStvVk9zS3Ja?=
 =?utf-8?B?elVIU1lSQzhQQzRIRUZyWjd6TVU1bEhpYW5ZQ2NNczFKWVlGZE94Q050SFAy?=
 =?utf-8?B?QmhLaFlmL1dDMzUzVjlSS3RlYTBPbS9QVFArZjFxUWJqcEQ3N2MzZzJNcjNr?=
 =?utf-8?B?UmM5c2lwR2FvMktLQjVSSHNqTkc3NVNmcXY5L2ZzVG5qc1NSMDhEczd6WGE0?=
 =?utf-8?B?Wk1xTTBvRXpHTEpJNTdJNFo4eEtNUzg2Q2p3czNHN1BrZDIzaE1HUGd6R2RN?=
 =?utf-8?B?YkIvcDVOVGlMd0VRTzAydWdGckFmMEN0cm56OGgrbWttbGFsSFVhbEZHdHdK?=
 =?utf-8?B?V0hCRXVtbUZxS1J6dUp4VmV4N1MrbjRxN0tsanZ0Q2tNVEtKazhiWkdJTHZq?=
 =?utf-8?B?UCtmVVJteWJ2Q0xVd1ZSMmxoUlVRNFNtYllmM2dUaHNWMllRa2k4WUcwc0Mv?=
 =?utf-8?B?bFF6ZjZ1VU9PVkhyL0I2ZEdnQllneURMYUVpb1lrVm1rM3EvMkdSR1F5UmRa?=
 =?utf-8?B?dC9sVmJjS1pNWXUzdkk4c1lhV0dMclVrdHU3TS9qUEZwR3p0Y2MrSjVPZVc3?=
 =?utf-8?B?NTBNUjNaZTh4bDFzcVB0MVI1cXVkVk1lTjVvMFFzSmE4Z3RPS0NoYnY5aVY5?=
 =?utf-8?B?Tlh1Sk4xMnk1b0pDRElaVVlEMktIQlV2RWxyYWtPNEpDOFgxc24vby9VcWlX?=
 =?utf-8?B?NS9nQUtNeGZvNUNYaHNUV1VkVkhjMlZLV2pqbklhcC9BR3pYL1FmbzhLUjkr?=
 =?utf-8?B?ZHhtOWdIaC8zdEgyMVkyWE5zQ0swalVpQU1IdkZJdlM5cE4vVWt1VUV0R3FR?=
 =?utf-8?B?V0FxcGovSW1XbmQxcDhpZ1hhcXhGS2NpaGVqNUVPY29vV1E3bHd3anllMC9D?=
 =?utf-8?B?M015MEsxUXltbFBjU1o4YU1zRldPV1BqajdLWmhadXFocjhyR1N5ZVlOMTNq?=
 =?utf-8?B?dllXUTI5bFhUem5hMjN3TThVdVR3b2Rjd0ozMGFxVVprTGVuWml5Y0J2R2t5?=
 =?utf-8?Q?Lj6gJMpqm51kuLtKfwVZbBzHKk4bVggrEdeeguJRF1BCu?=
X-MS-Exchange-AntiSpam-MessageData-1: 6v9kdQn1IKASyW7P0WzRHXaNp34ZOqegCIQ=
X-Exchange-RoutingPolicyChecked:
	SBEV2blWtdp524jT5zv4++bEiDmiWaT/Rj72Z2WJBWvBfN/idDGzo4oR5rXGOc6/HYM6QzAXRt9Go5U27wTDvz3Vk4FPmPE7nta72dDv9Q3dizKtN376MAZ2ugWZRvicaLGUL/JXhjDDmZPZaQ7FnyWnTu7YqiQFlF1C/cgIqt1G6Z41hpCYgSgLhi/q7kWYiQmFqukqsUlxmnfzwKDEmLRElsUTL1A9vOq5DP2w167B5dTjHYFEIpGOYfsrByZ4VKc0SXbKUrEU2wEbuhyT8EmO5KZYR9qVO6rUydeug2yUOomxaiEeepqw/oOdFHpZhsvO8wR9Y8LBXAngiAcdWg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lQL0W446XEY2Z1IEC4hMD2ra1B4t2mLIGKOg3xQFEayDdZ2i8hhK4HyIe/DJATmHhen9YibfEtLzS8U8xmipmvyUipFDJoGyv0equbY/K4Jps08olMeWvVq2WGk5XwH0mIofnMnegheABpVx1ICI+YCpQv/K80LPmoW42MZZx2pB2lMXfFjMbpoIDr9kADG6DIRS6sM/pOjdXLwANusolJ9N2deJf2QGljeQw8JUFQ/hd5sG+DJKlXaf/xMweFi5xSFevtWlZbssp4HQSopwH524RYQI3b+dPil84ir7nowsYmDBkrvBEVnrWRtSI1WZBC7RyUAiiYFenz9zt+rHvl0yPBi8Y52owMJuf9/G7xiJFmG0uPyAeTjOsFmyBveOhgX/gMQpqbT/dnMuVtsfW/7Emgx280lK9iSootTrlKbb/NKvrMFtKs6SiePqjDHJEUgKB/aRL/YWBLF77BGhyXJWNmtmhKVjw5mXUrKqTEdXPDRoHKcd5jyeHznq31JDS6siAby9uSXbQ59T107eWNSAw4XXR4SvVkxGtPkdAd95iJzScbEcFeGp6N/GagXCA5Zt86IyAW5PtM/uHpns5/7Ab5r2Ci27jZH5kEee6I8HORK2mkFZCrC4elqtMiq1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b795ac34-bc7b-4e4a-4854-08dedda7eb21
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 10:50:40.8345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9Kdh/1GhWXq4MmV4SCJyjOKcbqJ43gp3JCXnym+wW8UbjiOCbiOm3wMWrGkpcxPi8+/CEaAmtmn2yVl56qWW4XPIfDPSir9XfYvRhx0oOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8474

On 7/9/26 12:38 PM, Johannes Thumshirn wrote:
>>>   @@ -2420,7 +2432,7 @@ int btree_writepages(struct address_space 
>>> *mapping, struct writeback_control *wb
>>>                   btrfs_schedule_zone_finish_bg(ctx.zoned_bg, eb);
>>>                   ctx.zoned_bg->meta_write_pointer += eb->len;
>>>               }
>>> -            write_one_eb(eb, wbc);
>>> +            write_one_eb(eb, wbc, submit);
>>
>> I understand this is the minimal fix, but I can't help but wondering, 
>> would it be more instinctual to release all ebs inside a zoned 
>> metadata bg when freeing the bg?
>
OK, after reading your mail again, I think you're right. Let me have a 
look at your proposal.


> Yes but quite frankly I'm still hunting the root cause.
>
> One thing I think I've found so far is, we're re-dirtying a eb, then 
> relocation GC's the block-group, then writeback comes along trying to 
> submit these ebs but the bg is gone.
>
> This analysis could be totally bogus of cause because I missed something. 


