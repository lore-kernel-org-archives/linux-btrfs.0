Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933CF3E9F96
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 09:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783590914; cv=fail; b=slqxtvjt0LRsRi//5qXkS9+rSyxARlmsh2BsuBpq50lzJgY3RVjC7bdnTEZumMsaxIuoUyOoUMGHxKySbOaWjXaOTObYaug7Y+w/z69JfGlrF589CMiitqJMJ+9JlipqEu0gR54FKnQ3CisyyHOoiy22sw8SbfEZnXAyKn4ly6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783590914; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m264DJ/4e5CIvUnYmYOvgpk+zl3q/QuSMic0HEPZ20H8BP61Ia5jlnsUz9oPmUCfqi0G5LdTRoMAAjySl6H4WsrcfaFfX7RY/JXuKYf4imMxD5p49WkiItnq/iRtsaBoCNyG0CaiQBTGyvLjbwrbonRD+AI+OIVxemMOizpd5KA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dWS8px7z; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=uXVd6Nt+; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dWS8px7z";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uXVd6Nt+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783590913; x=1815126913;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=dWS8px7zaZfBNZqGU9T+z06psCf5DRNj/cz6l4m4m7hmLBn55lvYfApz
   WyNEwBgXOP3nm3KuKknHcaR+/A/lP+aaxEct1Qkt4/N4qIV1sBzgFLgmH
   oItQZrwq95PJordQZTPfcLTzQv4Q7keNZwz5kmhg4oF7icNZKMxznheW0
   k0lbR5XCTXiqfrqS5kEk4gzrBL9XFeLW6gRAIIOt/D3wCi59dA5l3CVx1
   GZ1OOnCdWQKHfvtDZnww9P1fB4RH9bM+ZguSy0radekvfSihmpt/uNvwO
   G+j2VxnBoEL2gtkELQ54tobKjaafKGvmezqd9pnjKsFTHnCmSpUNREKD8
   w==;
X-CSE-ConnectionGUID: KBpFdRUXSRGL6V+hp76UHg==
X-CSE-MsgGUID: vEFz1qZpTJOdCK0Q7izCGw==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="149734226"
Received: from mail-northcentralusazon11012056.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jul 2026 17:55:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDULEXk17GrJWvqkq+JK9plMGUDouXWZ/xOZ3Axhaw8iZq4UP2Q+MeDgKkg++eEe6BBbkrve0HdRnF/gDKlUF/qLa5Ies2yvKNu5Yy/INTP7JurWoDgTJNHlIApAaZlmLDwcue1Tg6nt5KoedyenVvocYSYRsd2ieeMboeM3oQ3H8eg0obU3+F3yrNs0Ty2SnIRIqu3CwC5XRvl0HyjktOj3dESDKag7GUPEVpdJWrdS5omHRF4OEfaT9foo1ufz+qSFIRz0+6GU613ZUYW9XzlPqQyaDiw9YoKU94hITBJLeql8bmWHA1oK1xMY1xmV61T8cCJHh8MI900McIB00Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=sspHnU6tPzOtYKH2DcLAD4Z5pqQpNpxLbQhTFb0m9J89jP0vKrD8HpcXHKrycxgSaYLR+3JbsCPTyeCrOYM9aeZ0sCtfM4LFYwcnTbaZ/HGvx/Dk7l8a3ZN9yZmeBrtsWwbaKhSHlyzf3gpKjQ9VnLx6WKb1vw9lLtNP9fzDQeMDjeoSZHn9GQUb6LQXxNs78ezJNUizC724rOqjF9MCopMZKkCAh2GJtR3Xd3eIpOk456dFEpqZbb/89w6NhpTpzwiBpR6HWuRahHOtnDmghD2S3pgdDyDBSAOiCE1mNnDjun5cQe1sRyyTmccjm0H5PTuZy/MKNgrDsfRldnDg/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=uXVd6Nt+/Onj+zaJ5EWGNR2zcT27MF34L0dplhQJAoj5iw5uhES90BuHJ4NIEr7BP4zHdVDn1oXjlShk6WjHAsfGmXAADadMJ0R0BGyfMYVyCrDI76LM6y0rDpXAAKk/A5sCbaslIFbezRn673HaAJTqKg2Np4VjlSSv5I6LPyQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB8474.namprd04.prod.outlook.com (2603:10b6:510:2a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 09:55:03 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 09:55:02 +0000
Message-ID: <f9e4a35d-043f-411a-b962-0bc1f0d4cfa4@wdc.com>
Date: Thu, 9 Jul 2026 11:54:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: check if root is readonly when setting posix
 acl
To: Sun YangKai <sunk67188@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Sun YangKai <sunyangkai@fnnas.com>
References: <20260709082500.17907-2-sunk67188@gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260709082500.17907-2-sunk67188@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0179.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::19) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB8474:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dc6ffa1-91e5-43ea-3d61-08dedda02553
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	hcstT/4J3bnLcYgimOUiWdgV2DAaYbvct99nQtnO210LpTSiTmKsbg3glUCMdjJJ3gsP5LS45JKbd/PDd+ogp05M021xzhbby2u9gm2ABSF/bVtqe58Wz4DC6Q0bz9AGABP6ZH8grgXgjfQXTPNI3ezk2NzduaH4xxXIyMNmE9MID4CTIyG7gbqnaR/r5W9xAJVDstJW9tCGIkpeu+LuEICCfSLFXvuxNuPvyjIe4gYVfw12gfLZ803AOfDHZXA91iqGYfbP7s73IKhJkiGSyZZMKmCTXpJLGKiIBQEIku506TQhc1HNaevaRiJt9WiZBMrRT7POKEqJfNJQbnHjHidBOKRCAolpVVn9Yy1mirg51jpWY5geZN98DMDIMdUa81Xnn/5DfRTDuYL7cDXGV8deceL8S9HkW7mrFF6Lw6QFMj1APAzNWwxhqtvGTJlhj7kLHQ+1utfNkZXaqSNdjRFzm0i0aoxke5b4KRTYbxxu2K64A3djY2+/FmOp+9AA5ViXSET1MutQd5OV6vXQP4BNVEuYEVE9xkqW8nUpHYGyIq0F3lLiuCXtJnVmkHdDy5/y5GePwgVeyomojhZpsAyBc8XIjiC85YTjsyW9TS3p2lTc/ctgoZ4acGJmMaYyTDXWUEUBypWIeYLJcchrMWAJ3uXMgE2ni2sZZkuI2WE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dm00a1BWUHdIYUo3QUZmS3doTGF0eExrTDI4Z2luMDg3dG9pRzdlYU5lQnIw?=
 =?utf-8?B?dEtkdFVtdzF3clhZRkxlWVdXcWVXVXFVZjF6Vlo0U0dCY2xRSFJ5c0t1bThS?=
 =?utf-8?B?V3hzb2VEMVUrNnNNbVhiN2hNWFJFTUFKT0RxZTJrOGJzUEJQeklVUzUrK1Ra?=
 =?utf-8?B?RUU4QVBndXlqNjF3NERpNFNzRW9zd0JsNldvUXpVWTIzZmNva1VJUkd1SExj?=
 =?utf-8?B?Q1RoT2VrbENhR3lENnBKTkZxQ0ZIa1NoNnQ4Q3VlMC9heVdjM2JUTkp3Y2RD?=
 =?utf-8?B?RGJKMjFRdUQyaC95RUVWeUJoeXorcXlkWk8vUGdON040SEdBK3FqTERCc1pk?=
 =?utf-8?B?bmJyOVE0OUpGTXAvc3ZCai8rczk4eUxoRHRVVnVZSmZ2NjZ4SjhpNzFBTDdX?=
 =?utf-8?B?TXlvSVpVM1hKRlFxei9zcjZkL0Rxc1pIN1hOWE9VTTAvcHJVNGpvaTIwdWZ0?=
 =?utf-8?B?V0hZR0RveVRhUG40b3dpRnM3NXREdGhZdzgxWU81Wkp2VWdRMHRJYm04VWc1?=
 =?utf-8?B?UmVUN2NlNUk2MVhtN0xFcUVkbXhKOTdOVjZ6Mk8rOG9RMXRrT3h3NVNLSXVs?=
 =?utf-8?B?c3drbVpIZThpaDZTMzVTYjBiTG9MaW82cGN0ejdRcGJRVitiQ3BSbEFocm9u?=
 =?utf-8?B?aFVockh3RkVxdzFzUnpES0k2cjBiNDNOUWhYNklKUi80VkNVYm1UTTFpNjRQ?=
 =?utf-8?B?dTJtWDBURmVvellqNyttWkdkMmdmckkxcnYyVGx6VkVQdnV0OWkxRHd6akZw?=
 =?utf-8?B?QXJEZnA1bVcycWRwMmUzbEtFaXphQzJrd1VNQVFoZFgyMFhTdjZpSUtHL0w2?=
 =?utf-8?B?Z1IzY1ZPeU1WNkVQd3ZQb0tYYytuY3FtTmlaaEtpQ3hHT0hYWmVMdmxFWHNO?=
 =?utf-8?B?b2orT0dyaWdlM1k2REVjVEtVV0dqTHl4Y2hnSGNvMGRYWTFGUVZadElZcURJ?=
 =?utf-8?B?UjdpUEhBSHR3TWdrZ0RUR20rclp0ZEM1QUpjRWpEcXdFM0FEYWM0eUU2d3ky?=
 =?utf-8?B?N0g0SDFDK2YybUw2enZSQXVvSFBlQ0NoYmNySTg2TE5UQ3lXazMzZnI4Sm5l?=
 =?utf-8?B?akdEQ04yTUtFL2xBMkJKaXJ4TVJZZHJLZGZzVUxNSzk5c2VCRzF6OVpQVU1X?=
 =?utf-8?B?NEkvNGFTbHRYVGhrRGZIY1JOYk1RUFhUaHgrdkkzNWZjbk1vVGI5ek9taklt?=
 =?utf-8?B?ODlPYm9abitRTmY4WHg3Y3BPZG1KUmtVYkt5TUF5TnRrVHdEOEhoZVpaYTMw?=
 =?utf-8?B?SmhKWDRtdlZ4cG85MFc5WDdVd2I2QXB3MkpMRkkvMnNRaSs4Zm1XWlVXTys5?=
 =?utf-8?B?Y0U5b2Y4eHoxUDdNRFc4YTBlNmYzM3JyR2VXclExcDE2Z3A2S1R0VzJXSm1o?=
 =?utf-8?B?OTl3WnpQZzFsVHljZFVFcC9lbFhlMmFvQUE5NFVLZnNLR0Q4R2w1MlhVb3Mz?=
 =?utf-8?B?dnV0Ym5iNXVuZ0FPczdseTVsOFNrSzUyRDM3V0dITk02QlJ5UE90VEF4ZEd0?=
 =?utf-8?B?akI1dm5mbDRjbVBXMktSN1JQNC9tNHdwWDNVc0VQVXNDK0lpVDVJcWRGSTY3?=
 =?utf-8?B?MGhlNnd0Vi9sZTlxS0NZYWtERVBIVGV4dExzOUFoZUdRR0laSzVWaHV3MHFX?=
 =?utf-8?B?LzNjWnFtdmwza3JTb2pXOURFL0dTdy9zTHFFaUpUZ3ZWNExXY3lWRER0V3VO?=
 =?utf-8?B?VUVoUHlqOFZZMXNSTVVDVFRESllpV0pZOHp4Mm80SHNXQ2c0cW1oYzRXTE1z?=
 =?utf-8?B?RlpmWmk1Tm03alpCa2o5SGxsRFY5bnBYK0tzSE51OGdnZE90S2crQk9LZnBW?=
 =?utf-8?B?VXphRTNyUkxVSnlNMWd2ZzdLWC8yMXczR1JHcFNDWnNkejlJaWl1Rm1URWh2?=
 =?utf-8?B?WFZrSHBwZFFnWTdhR0FiVUxpeWR0RW9oRG1rZEdhL1NMOEh2OEtSTnBNb0dN?=
 =?utf-8?B?RnJJUnpENnl4b1pSUjFFOXRKWE5yTmN6MDlzM1hvOXNmR2JPbXY5RW9heDFp?=
 =?utf-8?B?WS9VTVJIWDNPOGplVFM5cUZSSTYvVHAzN0NXQ1VITlZIS2N5b3pMdHZVanAz?=
 =?utf-8?B?ZnlvNjJtdi9wWGd2NlM3YkEzMVQrbC8xN2JCTmtKSE5KK1R0Tkg3Ylp4eUhp?=
 =?utf-8?B?SUxmSEZ0U3ZhNlh2VjR6d3JmZHFwdUttRFd3KzFiZDBlV3did3ZxbWtuVUpO?=
 =?utf-8?B?L0tUdU4vYmhsM2lHUlBJSEZwRFBQejBZZXJTME1UYTVSY2hhbzNBQytEa3Az?=
 =?utf-8?B?em9mc3V4VTdDUVNUZzVGKzI1VGxPZGgyRWZJcVN6dUdJSEw4TGFVcmJqUm5F?=
 =?utf-8?B?Z05HTlNTZHVsSE83ZnllbkM3NElqb0RmalNMeG5vNEVFR2xzbzVwQXp3VEZ3?=
 =?utf-8?Q?FfgKKKmKlA9JIU1lkfnpCqfbdyBv+l7LwUh/9zhMT1p4P?=
X-MS-Exchange-AntiSpam-MessageData-1: Q+kIHW+IHYVmkQ==
X-Exchange-RoutingPolicyChecked:
	BgYHrQwaSeh9i20KLF1ssuQA3jOSdhq+Dc9gbJoI11RSGOX9C10jMLjDKF6rFGwcx0TwsIf43ET4D7m+9btvb78MBOBm8wVSqxbI/iGNMaK+Sqhfy0HpDAa9G/Ow40rl5M4hB7izLWd55W2EigWD9ccQ2zxRJXbbhNOMaRJJQFQmR5tod2544Y3FGu78vTKxEbe4jzXlgfrxWl3f2B8DkvuZZBVPki3XXYyOtrSf4cv4Q/1cg9fzD+4a+Ccu6UzIUO/Blw+KtIDYFbS0/k+G3UdqJkuqHGZEeL5TUO7ADfV86Q5cwKjux5cG+Q5ta8VHC8XGuJted38j1QcoGadbBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WU5ZTWcANFabQZcswHq0zUxCw8F8HDBKxXBzeuME6bfJB7W4vawavuqP40kcC9nnHBHnnnmQjKbKktwZMafgmebBxOoAxk3k8L1MgjNeaE3JQ/pVBLGokoY+W4YUtfpFOls2Fc+Mpy5icjkGH8aNhe4QJ3vkN+r0b1T3bnUwVuYuMpxf3sZaL3w/uAdc/ICw/2YV2bDYS9OD7fgTTtHhwklx+D6TVLVgcCZtWCvbXF0fkuci9zu9HzCv/ehzUpcWKPVKmtyOm2aoMmN/s21JDoSn3/Xuxa7+/UKPWkGbcKlVfestCzgq4WRwHY8p+IYnI80z4G6LMvbWGV3OpWWk4qCLNTBuqvGdbiNMUCNZj3hQcYleaLQ8TQh9aOdJx7piou/UFS4yQWHj4vzL3mhUgkqKqJVShUYflte6QFRhqcE2cb5X9/mEODS0slNtq52akoGrWTZ75whrSSqzSX1RWe9OHHhVjqZ0TZWFnlnJgPALzAu7/Y+AAVOVTQIGyPBnHlwUm5EyRi/mYAyPqyHk59RM6NdGAShLqNS93bV0O2kjWDWeBXNohySpBVrRWWvRBTKEHvM37OOL/YnEt6NX7Eztt9TjOS43g9vV6eQVQjMB1AmofTuzy5QJvSaWmbW4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc6ffa1-91e5-43ea-3d61-08dedda02553
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 09:55:02.6498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvLX0KZAdm+8P7sdrf+ceA6wEqrCTAUeukoLWekf73AaoPViwbDGoXf1E17C3wvs1nElTmb6r9uZWxkjzdhNra5AFFMG6Mije4CFgWzj+b4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8474

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

