Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968953DA5D6
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 10:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787653731; cv=fail; b=uNkid1WrdEe3ofJGal3+HdDcwJiqZKhY3dPP0Elb587Dbv2BH+pZroSQ/jgSxofbRUYkuLyrbjwOaRK2T69mGZchE3imZJV21wEg6VmuIr0QBBdQD8oZda0OvXgjYUICu0vUQqWkaA8cJUSxu7cYPJZfDOkUDhyXNqup2l2/mlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787653731; c=relaxed/simple;
	bh=QTQrGR7YZvtc3UvzsaoSS0haSiGbHQD+gNEUFi3ykpM=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K+7O3TIAWO+x+mM5BtYGq7Nz2J9S8wOOMlTlkTFu1G3yJZbGZLXUeICmVtX+cq9kSd3uqXjOoTOcfynBVxBj4288402PQgZRG2tz8+6ZcrWg12gIPUQ9sml1lkrq7I9/M9ZAVya4GknGjpA/Zmjm/zIMqveHQ+FhIafrU4YHRPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iJXeiAPN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=NNQR2G6M; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iJXeiAPN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NNQR2G6M"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787653729; x=1819189729;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QTQrGR7YZvtc3UvzsaoSS0haSiGbHQD+gNEUFi3ykpM=;
  b=iJXeiAPNzjtx3c3BXZRPaoPBR2+wFCtcO5RV1Mrbce57qGYU4NRp+R9g
   kPnwvuZ3KUpgmqgNI37EFlgh44RIw7fEMWWHeKU+ywrp0xP+DEP415Lf5
   /BoC6L2TTko7ji8oS2aFs8kuZed7/xqkws8gPlyVGCgFWJxqzmr3IV6WO
   P3bJKvFZPCqgpk5urq2bS7ehEf8APLkD2i70rOwa2tAELyLsm0K/tlBc4
   0GieARbuA9bALGzi1YtudK3IHE6wwXIjxWPYUeiDwUSD3cckN8sXkCXPQ
   lgeF3YmPsfOyZQ2vrAdpjjMtyt/IvXlggeR4EimL/TwbCGxzP0yosNyT2
   A==;
X-CSE-ConnectionGUID: zC5X5M3iQXu/Ch83X52qNw==
X-CSE-MsgGUID: VY19ot3ySl+B+6wN1JQMDQ==
X-IronPort-AV: E=Sophos;i="6.25,242,1779120000"; 
   d="scan'208";a="154222230"
Received: from mail-westusazon11010007.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2026 18:28:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRoSSQyy4HSyUd2RHwEOhNZaPRPmSOzgLtKB+8IZOWv+mILyXJLBQ+N32R6hJU8V6OI01/XY7WR+P1FTbRoeJpQf5Ne0b+cRrjZtleem5hNzRIwG5hWGyvZgDQ6LATPWpix+NoVbF26mS9TVZIIKD3oPsmf9ESSRIMxigm0iMqqHqSwOpgkY3DuU2+gmfqtHbypsMg8g/cpUFUKqJ2S9u0zkDR8FVG2doJh0DLDVe6MiTZ/9p/ROqXZz1WwVQEuxaAU2dgZnDpvJrvkhA0oIkH++QVpl0LxX0NV6fi2L98ll2MYjQVABs3kaPRPBN4pcrANxYgpy1HOi63EVJkpxgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdCY/7qeXhV93xojqn+cvNDQ96XxRSOfuLWfClpxjNU=;
 b=c4FTF00RYIXi/P8wCXhMj+9xD9GSo3n0y2vOYIrEVma3LqqN/b/ZwgjSRWPYb97Ie7ygN8g312uOYZE50zU9GL0eZiGYcPFwnHrjPYbl1PvZGqp5bI+8ncGO5jnxZv5PA1FKnxxSazNjDrzGMQPzWY6gSV32k/4L64lZEyAqCz2bGp+0YA0iInTN3xRprV/VE6TNhnaJhl7JNgCufSlXMbEc5tYwAPNX4pbn3+2xU39i7gJJt7odY3z1NF2R5dyXeRYWAMERbltN54hvcde55DXGKSQYV4ehMoCPzKXNMRLTb35XwZr909/GKymWlHD5nNqMkYwnb0FTLZK+Dm50Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdCY/7qeXhV93xojqn+cvNDQ96XxRSOfuLWfClpxjNU=;
 b=NNQR2G6MrHnSr1e4l+6ZdzNgZyKsgqD3T1q4CAW/9QzQYAj43b9M06ovzOiHAiiXjntz8g3NmHuZ6ejuLDDnssRK94Z1qCbc8zWorBlcAJAcsvzjl6CP3R8k1c0gN8pjJPKVGmf8xhhPcioOHW4XrZa0dwKDyNfX+0g9q4ANqIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MW4PR04MB7298.namprd04.prod.outlook.com (2603:10b6:303:75::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 10:28:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.005; Tue, 25 Aug 2026
 10:28:46 +0000
Message-ID: <a64246f3-5b89-4a57-9333-0200a8f7fe7e@wdc.com>
Date: Tue, 25 Aug 2026 12:28:42 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd [sashiko-bot@kernel.org: Re: [PATCH] btrfs: zoned: handle
 RAID profiles in btrfs_can_activate_zone()]
To: dsterba@suse.cz
References: <20260824165805.GF9053@suse.cz>
Content-Language: en-US
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260824165805.GF9053@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0191.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MW4PR04MB7298:EE_
X-MS-Office365-Filtering-Correlation-Id: 51c54876-fbc5-49f5-2deb-08df0293a511
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|19092799006|1800799024|23010399003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mO7xnBlZw+9oTf62+RUnhs/FKbjAmOKI/21+tKunbPq+oWxbqY5bHAk5WkvYRXEDZVePbVCvXypCjI49rPJMWpMa979uRpCRokzlkkgrtC+v5itXn4U7vrINZ1nD/8PGH/NaTy0bzUz9YGMvel/AgCAWrBkzQcS+MRxmtUk5TwOKhHNGQ5AcayCvgSMpx/N8kKGFfEFbjbuIKNSyugl+C2oEhJBEzWGCstVAT4qYbmTwjfHRrgYbslAJjE3m0V7DVMiZGmzWipfdVG2UcsZjj2ByuOw7DVblVSUyI/R0eWrtNJ1DUuUc5x30SDfPyqkpB0LXUbKwaSqwlfdSBzdI4igfWSFvExxtbvViCQaItrl+Wv6Pwg43hS6V3UYJBuRt3fVAXHSmCEV2noxNygKKOndbdOC1yuTY4FLrgS0S+ThffllCLqayj3ii4CsWFyhAExm1zgvTm9v6CMKadPl5bqBzmw9TBrdQOShWXzYH6j3fcRjtSC10YhEshs0SCa5fH7khQOGK69jVgCfijYT9NfQmrifASSne79wIJkxGZeqCU2CC8qo4/fpf7iCme6uCI//nD/GdDmiEVv8AW3nZYTocmvIlFjztk9OQfnJBEzIAnmr8nCM8Tzxk58MP0eKR7wWa18U2qf2QU515O1MFimuR9nFuoyUtuzgmIzfhMVo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(1800799024)(23010399003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmdsNlFaWmJyT1FXeGRQRWdIN2JndmI3RExTT3JRSnVPUTRpMm5neERqcVEz?=
 =?utf-8?B?OGxPdzFuMXVvajU2ZDZUQURLajMzZVoxTW5HcTRQRmRteDZYaElUVmhjTUkz?=
 =?utf-8?B?b2NpVWQ0NTBqN0pXMXFFMkZxWkM4cmN5eUh1L2J6Y2JIWUJhSWN3aVI5ejUy?=
 =?utf-8?B?eE1PeDM0TUsrS0s5MUo5VlBqT1ZmYVhDd2RrL1h4a0tVZXpxL3ZQd1k0eWlQ?=
 =?utf-8?B?aEpZVElBNzhCT1VtY3FKYit3ODV3R09lUGZYRnU4Tmk5V2tibDJVM3JiZzlw?=
 =?utf-8?B?YTFTSENWc001aFhZcktWckN0Q1hlcGRodzJrSGFGRXNFY1pmMGV4dEorSE1V?=
 =?utf-8?B?cW9jRWNZZUZRNnExRkxpNlRYVlhncTM4MW1pNzVSZ29pZFhXUWhKRHJyeHBn?=
 =?utf-8?B?Zys1SlpKYk84UVV5TnAzVVNaTUJMSFNBekZqclhhdnpSdENYcWNPdzdjRS9C?=
 =?utf-8?B?b1diSXJGbUovaTVHOHE1eHROdjUvb3NZQ1lDZ1cwbGNyQWMrdHR3VkhSRzFK?=
 =?utf-8?B?eTdGYkxSUXdRdXNMWjIvL2VnaEJUNnpKNmFzM0IxK3VYQTN0SzE4c2p4dTB3?=
 =?utf-8?B?TXA0WWdRWDFlRjZUV0VRYWF0ZlBISUVZRDBNQnRTYXRkTklGSDhyc3VETito?=
 =?utf-8?B?dWZZSGR1elBpWlNBYWJTbllTeUZCL2ZBVG54S1NTT2FVWEVRTFFCNEJ4b2Y2?=
 =?utf-8?B?MlY4VSszcmxUNDBjZUFPaS9idGxGcnZsL0JWbGcxSFVwRTh2TUtRQkFMUW10?=
 =?utf-8?B?K0tuZU1aY3VQeU42M1AwTWVkOEZyMGJUUGxSNkQvSXNHMU5jZ25tLy9ZUW90?=
 =?utf-8?B?SFdheGtzcnJneGNMOWhKMlNSWU05K2R6UG1hWTJHU2ZRNU5FTFBOSXhCM1Jl?=
 =?utf-8?B?UVpONjkxSWRxZ1RrcTdhNVRNM3VCVlZHN0Fjc3loaGxPcVFhNHV1Wlg5U0VV?=
 =?utf-8?B?STFWQlNQWWUvR2pFeTZjMlNlSFplQW5Uc09DNTZpdnJYd2FGZXFKQjZTV0lo?=
 =?utf-8?B?UkQzZXJBYktDanluMkR5dUNhRTg3SWVFMHJRcTBVRmlPS2xCTEdTNmJmRnJZ?=
 =?utf-8?B?Z2ZrRnd0a3AvQTlEOEZ1MFpmRUhaNUM1dXB6MHhzZkk5QVlVbi9ycmRZN3VR?=
 =?utf-8?B?SFJTdm4wRm9DTHhtUjVrVzFxVXROQVVaOWpGOXB3U1V3MjVEaVRONmkrSFJ4?=
 =?utf-8?B?dDdnQ0tLZ2hNaGhtVHpGRTlFUHV4Sm9rbTdaVGo5UDRJeDZLSzBxS3N6MkFo?=
 =?utf-8?B?Q096RDZlRVFyVmpwaFdTWE1hUk1iUlZ1MjZwdjJxNi9NNDBiWkZjVDJQZTdX?=
 =?utf-8?B?VE1Ua3ZpUitnVW1MY0VPZGEvRUFPUjBTUkhpTkxUUjY3Ykt3SHhyb1ltdmpt?=
 =?utf-8?B?ZCtETXZFdEs4UUhvMTJHZUxEUEtremx0bTVKL1hwUzNZWkZiNHNsdWs2OWxj?=
 =?utf-8?B?Yk1KV0N2UjE1dUdRY3dmUkpTRGtzWlVKMmJ4QWlJL21GNVlOUWJPTTdlTFBk?=
 =?utf-8?B?VFdxMXRQNm1TQWNPanBuVy9jZXNDRlRHMVdDUGR5SXZNZTdhS3ltV1ZrdC9a?=
 =?utf-8?B?bitkRWdGa3R3YWNKUEJpbEkvZjVSMlhhT1pQcUNZVjI1YkM1aTFoZHdzdUpE?=
 =?utf-8?B?WkpsU0VCcnFGMzFHUTAyQ1AxNGI0cXNINEcrL2IrZDE0M1ltTmxZZGVaRStT?=
 =?utf-8?B?c1Fxby9JUmFXT0txRmFUK01PNER3T2kyYWl6MmhjY2REeXgrWFFESSsyMVhP?=
 =?utf-8?B?Mkl6V3NuUFFBU3U0L2pLbWlTbkZTTUg5aCtuRVVCcDk2VlhuOFJ5YlpUWnhC?=
 =?utf-8?B?eXVQT3BjL2xVRmtpbCtjMDZrM09mTU4zNTJjcnE0MFI4V0Joc250dVZlUExj?=
 =?utf-8?B?bkNlK3FjSjFYckZlSStQSWRwVGNYVHk5RnZ5QXhBdzV2Q05KOEhoeXczVy9E?=
 =?utf-8?B?K1dIbHBUS2NPd2JPQXpxMnRaMUk1cU9EQVhPcWV6cTFLQjFQTUcwcGIzemp1?=
 =?utf-8?B?eHlhS0xneFZGbEttK0M0RDFwWkw2MnRrRDlMTUh4QkRuYy8wL2tMUUdkaHRx?=
 =?utf-8?B?a0FhMXd1MENiME9tV0F3NFFFSVVnbDNlT1Axb2FqR2ZPT2FTc0RXdG40eGV1?=
 =?utf-8?B?MCttdTRLWFVqTXN1dmxQY1pXNzVVR0t4VmkwaXdISFBvY21Zc2h2UDVaZVpL?=
 =?utf-8?B?RmJ6dy9tWjlPV2dhQzFNQWcvNjZqSEwrZERRSVByZzdFQUVkYW4yaENra042?=
 =?utf-8?B?ellDV09wZnVzd1ZqK01ueHNqdERkMFU5WC9VNFo5WnpwNFFwcnFNa3NVSHFw?=
 =?utf-8?B?VFd1aE1pSGlPSzRVdndhTjNqK1BZaWZwbzF5aXdIdXlpV0RmREpyUzE2dEZs?=
 =?utf-8?Q?d7v0Wl7fow/AQW2c=3D?=
X-Exchange-RoutingPolicyChecked:
	xs6Z9ldn5rUHUVwsB01tnwa+VpY1UGoW9MP9U9Kq4XXfMKKaRGiv+FgONGncqD87WjS6+hsXLSM7i79JXUgjLpv9hRQ7FYxhkmZdv5j/IgyXrSXBrdMQD+KDEU9UvxJ+THaTYPNWgEIWpp6mxDsVWo6ox6tclTHphRrFvDjt3iH9Rlv6trHBqOMrwvVGyJ1wy+T/ZVKxm5gwdRRpvxmi4NKmHGNiRy4rX6N9b2fbufWjmxlIOYIN2o2ARnnDjpIgfag+nxZnkn6w/03pJ9ewTjyADK7owKCt3wJQ9Fc0HdC769j2BtFx/K+x8QK1QdApLPCC0DgUSpjS3otZ5nf4kg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cUjUHb07viK6Ltzxylr3yJeYM9ETTKjhbP/gzWvQao2oC01d95vayX6/TgKDgWO+4JkRFzC0kX5S0JeREzEMqz6mbfPhJqR3teFnafthVOVSMbh5IH9PEZ0o/xqZDLFsKZsDa9mN5E01U3teK4Mt7HdoWYSMB/tLjSwXDcN7Y1GNk1a2VWra6FK8aU07rUfF8IVK6dPbPvHsKpJjZqZmxJcpbQFuoKHJ3Z6R1Vs/pbkc3Lu3+BkRHhhYocwD0D9lqIZahfPfgg+NZXt9DGVki1QI9+2xRC+FTf8M5++3RG7dmzL5OZSwx9TrHMAC9lDYN4rrvJ5EBjQUTd9rYRABtW/n+yvNhq9kkgUogEHVoGZ96seC6E8pkqcc5XlqcZWkTAqtSRjSNaj2O4qcLJXFU9H6XtOSMS/xeXXerPQBAkDg76liHmIY7n3aBGLtc9wp6rTREFoV/GtLNEmt7bFoFgOeW/z2Y1S7dVWOUT3Apuk3flnDEvN+i+/BvdLlUj6BMjOfLOaHcuhPdaKJXBjWnJ80uwjrPBnAaUBafCXRpyvi57rUr4J1pazRC6wvHFRExFDV7VOQkU0QVLC5o+PxdL7mVIUaWcKPg9MPOn3lf6LRr1QEIs0cZD6tiCTT26zj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c54876-fbc5-49f5-2deb-08df0293a511
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 10:28:46.4482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6m3mJCGHx+8ZVDEsgHRjFGheMp17+JGEtp4p+HEZIX24CQ7tRBZ8hdJo9UyyBrXKwk/h1eUJG2d7tww9C1SMTPgCmi+7XswFKqxtQu6bXm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7298

On 8/24/26 6:58 PM, David Sterba wrote:
> Review comments don't sound unreasonable:
>
> - the switch allows to continue for multi-device filesystems
>
> ----- Forwarded message from sashiko-bot@kernel.org -----
>
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>
> New issues:
> - [High] btrfs_can_activate_zone() incorrectly returns true for multi-device RAID profiles when only a single device has available active zones, leading to chunk activation failures, infinite allocation loops, and premature ENOSPC.

This situation must never happen, if this happens, we have a bug 
elsewhere. If only one zone in a block-group is sequential only, active 
zone tracking is done and the total number of max_active_zones of the FS 
should be the min() of all maz of the devices in the FS.


> Pre-existing issues:
> - [High] btrfs_zone_activate() permanently leaks reserved_active_zones and temporarily leaks active_zones_left if a multi-stripe block group fails to activate midway through its stripes.
> --

That one I need to look into.


> --- Patch [1]: [PATCH] btrfs: zoned: handle RAID profiles in btrfs_can_activate_zone() ---
> commit d42887c3b92e69264b1963962b3b0d4b608afc5e
> Author: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>
> btrfs: zoned: handle RAID profiles in btrfs_can_activate_zone()
>
> This commit adds support for RAID profiles in btrfs_can_activate_zone(),
> evaluating multi-device profiles to check if they can be activated based on
> available active zones.
>
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
> [ ... ]
>
>> @@ -2691,6 +2691,11 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
>>   
>>   		switch (flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
>>   		case 0: /* single */
>> +		case BTRFS_BLOCK_GROUP_RAID0:
>> +		case BTRFS_BLOCK_GROUP_RAID1:
>> +		case BTRFS_BLOCK_GROUP_RAID1C3:
>> +		case BTRFS_BLOCK_GROUP_RAID1C4:
>> +		case BTRFS_BLOCK_GROUP_RAID10:
>>   			ret = (atomic_read(&zinfo->active_zones_left) >= (1 + reserved));
>>   			break;
>>   		case BTRFS_BLOCK_GROUP_DUP:
>>   			ret = (atomic_read(&zinfo->active_zones_left) >= (2 + reserved));
>>   			break;
>>   		}
>>   		if (ret)
>>   			break;
> [Severity: High]
> Does this code incorrectly return true for multi-device RAID profiles when
> only a single device has available active zones?
>
> Since the loop breaks early after finding just one device that evaluates to
> true, and RAID profiles span multiple devices (e.g., RAID1 requires 2
> devices), a single device with available active zones bypasses setting
> BTRFS_FS_NEED_ZONE_FINISH.
>
> Will this allow can_allocate_chunk_zoned() to proceed and allocate chunks
> that cannot actually be activated, potentially creating an infinite chunk
> allocation loop when find_free_extent() tries to drop and retry?
>
>
> [Severity: High]
> This is a pre-existing issue, but it interacts with the newly added
> multi-device RAID logic. Does btrfs_zone_activate() permanently leak
> reserved_active_zones if a multi-stripe block group fails to activate
> midway through its stripes?
>
> If btrfs_can_activate_zone() allows a multi-device chunk to be allocated
> but only some devices have active zones available, btrfs_zone_activate()
> will succeed on the first stripe but fail on a subsequent one:
>
> fs/btrfs/zoned.c:btrfs_zone_activate() {
> ...
> 		if (!btrfs_dev_set_active_zone(device, physical)) {
> 			/* Cannot activate the zone */
> 			ret = false;
> 			goto out_unlock;
> 		}
> 		if (!is_data)
> 			zinfo->reserved_active_zones--;
> ...
> }
>
> The error path fails to roll back the decremented reserved_active_zones.
> Because BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE is never set, do_zone_finish()
> will silently skip the cleanup:
>
> fs/btrfs/zoned.c:do_zone_finish() {
> 	spin_lock(&block_group->lock);
> 	if (!test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags)) {
> 		spin_unlock(&block_group->lock);
> 		return 0;
> 	}
> ...
> }
>
> Can this permanent leak of reserved_active_zones eventually prevent
> metadata block groups from activating and cause filesystem deadlocks
> under heavy load?
>

