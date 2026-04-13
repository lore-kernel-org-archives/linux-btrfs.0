Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170393AE71E
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 09:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776071684; cv=fail; b=CLv4pBwxgXru6oQEpuzcyBHHwFkMbWakn3d25cjuxfL2581MqjLsX/Q+QZ7SqT1aiQu29ZjR1BkQh0VKTHTYQZN97MVTUKTUXBm8QVdR8NGzDUZ8EK9+oSoZymN84yP11Z2llSJ1h+7BtBcxdnjhZyc6N0VN3mIUeZEq+2uwRng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776071684; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t+PtNTVSGuVxsJzLmQYdC+KG/vBJ1UkicVo6dP34O/ItEE+UWxHHcu0rEaVfIwNlbX72FcIbbIBqaU2LsXbJv9pYdjiVK9ZVqCG6q8ODnGeYBTyrVs+xxSUwTXH9y4sfhvPI/wRpYN3X5U3sMsbx1Yp42Qk6K1IBEXWLyJLzeco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=d4pULGln; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zvSgTgIg; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="d4pULGln";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zvSgTgIg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776071683; x=1807607683;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=d4pULGlnLUN9g29kRFtY3ptrvdZNGN1a4rQKQL0yk03nfe9AhYYgnhwv
   PNO6GIGT74VLAltswMF9ahcj5NtAHs+G6kaAy2+ocSAW+HpmLufQ8r0R1
   14G7n5qwA4ZCGhGALNSqnMaxUX052iP2yX/IMWa8PhevqsrLQc7eDpvWO
   NdXRFnAbRIMp99GkRusf3QLBZHZYZRmIDkqdXjYGGdyLBdKyQ32v/29Pe
   709r2eonftBWoPsV1ykWmBeIJqGQ6GeXFaaXQnwseqDWfJbOdy78L4yfd
   LHbGv301DIOZXBS2jEXPYwf04FyQVHQL7k1OMLxbtn9mgW1oxghf2igqS
   g==;
X-CSE-ConnectionGUID: rhrGrv71QiCuZYlIGt2uMA==
X-CSE-MsgGUID: J0NdwXeLSL2wsg4H5pM70A==
X-IronPort-AV: E=Sophos;i="6.23,176,1770566400"; 
   d="scan'208";a="144875598"
Received: from mail-southcentralusazon11013042.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 17:14:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CE6eHFTKT8QBgWdwrKxmbS8Ut0zfEmZaDL7FhnbFgeRfzDgjsPLglZLi/rKLNujPqbLLoXPQENoGxKEHXzNtjJqpV21yctNb/P0vK0HIbOs8+EZy1DYPa5t7tPfL3PLmC8iQYOsB2GVj7uHqNocMqAcDjWuoD57Yp35OaMBTWk3gcCVxE3TyA6wqz43oTzHqq5+lKP/2ojxcbuWE8sABCdFI1zdSbHmPVpf65GsZbt24HkpwTkHPs3eo4YcD+9pvP51/MAUAdtYD9QF/I8WHM4WhW+woLpM3tivg3a+ecJzGfq8Fye+fwydlxQdt3QNIPBwkShYIjD7LvAeZgOtj9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=FtGJ10/pyZ4iHA1X3S14E6H3W3TBYi4NiVqOv8LnlYkIk8z2txcew/dzhgd8RWN8HnToiSv9yZvfNxpw+7Xgp5yzL8/rl/tqzjXs3mC9Hpcd3KfS+Pw8sbV5tzi0zktQNr82snYeyoOscj0I3f9AqAmXJ9fcrSXzBjDT5OjzZKej6i+gi+/iO577L33N3blxHmTrsQfhLAYSgfJyy+PvC8K/wTsvBLYfdMG0/pQZDgznRLSc78v3Ei7mJXB/AGvDZfXoK5B+1oF8bB/hWxSUx8sdMpwQdWkaaO6i3TngRDiEh7dNVOljX7fdPR/mmDEsPOWrOcNTpnWs9h+St+2nzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=zvSgTgIgEPviCzCxgSq7q/p501/AhTrah0Jz/xB1QpCHhOBISo0vnSKa8Ck/rikd0upB0+LJ78mE2SMQJR2aZEtoj9Gtr20WLu89wZHSiOofozqJuxvJnxo+cNgFSc+sV6MwkcPFu+fi05AsODrUnikhdHNjr/z1uGA5NCk+s40=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by SA2PR04MB7499.namprd04.prod.outlook.com (2603:10b6:806:14f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 09:14:40 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 09:14:40 +0000
Message-ID: <da1bba80-bb3e-4285-8a5c-5b733b11d7bc@wdc.com>
Date: Mon, 13 Apr 2026 11:14:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] btrfs: copy devid in
 btrfs_partially_delete_raid_extent()
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <20260413065249.2320122-1-robbieko@synology.com>
 <20260413065249.2320122-2-robbieko@synology.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260413065249.2320122-2-robbieko@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0272.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::13) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|SA2PR04MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a323ee8-9481-42d7-687f-08de993d178f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|10070799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mmliQSpVbd3KlxZX9tSPJ8GE8ubib7lyNYe8R73VNIklNLDzRHkxBeqAWXpB1/G6JGd6Xs9PvYDrwHmdOUkXQPq0lKiLaAIb07tsp8YH/LbwWi5DAwEI5fwkwN2wuJ22Uyyiz0Y6l97mwZPhv2hg839+h4cWGmumw8oX+trgMa0SYIKigqnjb8ZWtfDfhIxUYu4O0qHSr50WZ/aP129nm3CXnHoiy8Km0A5NsOz29WAlxQL+nsdLyoQY0ogBRKHHFXmmzhZeVrMQz7AUs3Y6hgm0q0JI9WZA3NjklN8soQL1+6QMZz0Dh4gxXad/UwkrrWanvnZnwtIdwjmQMS1EOQebJDrhHCRCy0Vn0aiJZT5X77PXEtcVE87wyrRzXxRKuWS6p6paUryAEjsfWkMojw9WAWZiXeBxFt3yWJ4Nlrfj3yD047YH7raiQCnBmIStPaBLaI985+rxUhfR33SMGuUnWYszB4XeVJ6swMlJsBI7o2wXKkXikTkYz5zs8D1rHsWR9U20DZgM0X9rtnALLhnaUApity7QqBZe8YXBp1fYovmnZdod2mfkPGdk4imN5c5OuyNyxWezhpmYwDcTLYhOAV5RY/R2GwDTv9mXnnk4fZwQ2tVbQitPckEVdJB24NZM8X3zNddxJ4NeuErnPAUel15c/EQieujxTc+3OEXB5Dfy81MscgKg/u5W8eVzhW+XdJpFCFPUBRLQmswFcQ666tnYbhNXQqd2xMAvQ3A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(10070799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3hlSUIrdFlFMW9tZFcrMEVyU2FhMitwcEZ4QVdsV09tbXJ2VjZaTzZGYjd1?=
 =?utf-8?B?bmtJTzVpWFZ0YVI3L2IwN1ZaZmxnZnczS3ZvRXF6aDNoVFk5S3d6Nk8zSjlN?=
 =?utf-8?B?MFJOemZCSU5TdjUvMFFtUlRXc2tOSWhzQTE4cU94UkJFTkp2dUNma29uMlFB?=
 =?utf-8?B?Y1JVdWxSOEVhZ2JmdENLVk4vNUpzS3JhSDJkM21TNExWQnROMFJBckh4ckVG?=
 =?utf-8?B?dXBHWGVHdElvR09Bcm5iTTBYV2ZHM3NmN0M0aUttZ1J3cnFBQjhsRTU2MmZD?=
 =?utf-8?B?enh5Qmx2RGlQZXg3MVlZZEx3U09nWC82aEZDODdvSElvajFPMDhsSGJVcDZo?=
 =?utf-8?B?UFBzbkxKVUtjR2xDTDRhR1FSMm0zRnBFWjR6Y0dYMHVjVG1SYUtFV3FicUJP?=
 =?utf-8?B?VGNHSGQ4THQ0akhKMWdYeERTUDZEOG1WVkdVWGl6bFFPNDNya09BR0RiUmR0?=
 =?utf-8?B?L2ZvV0l6V0ltb21Zd3haa2JsQlBrRGowczNDdDFlTGhZd1dMcDFwMEdKSG1E?=
 =?utf-8?B?MXdVT21FdmNEYnB2NDhGK2pHODA5MDRmaUhEbFVsV1BvOVpISzhTaVRWU1ZQ?=
 =?utf-8?B?ZkliRzlHZlY0a0FXUVFnNk5TanBabXpVMG03NzloRSsxNEhkRDN1bk8rZFlI?=
 =?utf-8?B?Q29xWjlCVmVqcFBVeTcyeFpYSzlPWHkxaWZrNjNqNkxtQ1pvZjNwUDYyNkdr?=
 =?utf-8?B?Zm03N2c1ckZEL0JQQ0pNZU5vZExjOFZGaHNWd0xQTURQL3krZHgrUHNqQXRi?=
 =?utf-8?B?d1p3NFNqMCtzRHJQNjFYVUIxNnBNVUE5anZzODFXbGxoa0dsNk1IYmZjQXZ0?=
 =?utf-8?B?SzNIN0Vha25JOWlFN1pFLzNlclBHQUFQWEt6cFNhWTl6LzlZK3B3dDJlUUNG?=
 =?utf-8?B?S2NWOEFIa3NiMHRjYXlQYkNzTncyWG5tQkdGTkpIZDhjVWQvQVJqdXd5Mnd0?=
 =?utf-8?B?NDZNWDhSRjlqOUpRaUFZNlBnNmVQQkFVajJ2YnA2K3J3VU9LYnZiajZ0eFRt?=
 =?utf-8?B?eFpzeHh2MHpDcHBvNXlDVjd5Q0ZsTStWUUQxajA2dGdDSzRCVXZuTmlsZkdQ?=
 =?utf-8?B?YnI5T3QxL09PZnRFWkZ3N1o3MmN0cmVncncyWE5wcnZhMGRSV1Z1THFGY2hn?=
 =?utf-8?B?WTduTlNSczV1WWo1d3ROeHBXSWdUQ09VMUVkb3VrRmh3Q3lvQkpmcmpYSGZ3?=
 =?utf-8?B?Z2xVZlQ1ZUVxWGh3QVJPU2ZpOHpOZnIraDkyNnNFb3A1WGdUR3pzY05vVmZY?=
 =?utf-8?B?Q3NVM1BFWWlwZGdKQ2ZsQTVmU2svYU5ldHZyam1XZkQzQmJubFp6SExRYmJ3?=
 =?utf-8?B?RW5USVZOWVVIc3VZbXRsYnpES2hBSWFDWExJTUhibHdNeHhSWUk5U3QvZnlw?=
 =?utf-8?B?c2N2dC8wSUFJRnhpREs3TWtKdFVnRWtzbUtsbzJGUlJzdS9xV2J3VHB2cnlo?=
 =?utf-8?B?VTVFenFRcFZ3Sm1GendtSUlqa1JlRXZUUCtkaDlxMEdBeThVd0lGTkYzVU96?=
 =?utf-8?B?RUs5djFVd3FmeDFuTDNjU3plY0tud0ZqOXRNazFtOHpmaHdvSjZmK3c5YVcw?=
 =?utf-8?B?M2ZrVWpOeTYybksxSDZHMzdJdGErSkxQZWtLZFovZlFFbU0zSmhMenBESEs1?=
 =?utf-8?B?QUxvalF5eUE5UUVLWDVMa29TbFRrWnJBbUxiU1pHY3FFWnUzZ0hHTFo3OUVQ?=
 =?utf-8?B?K29LbjIxdVU4bXM5Y2pHSnZwcmN6bThTckU4NXdld2xsalQ2WXdqMUZzQ3Nu?=
 =?utf-8?B?QUMyZmhWeElhUzZMY3hYNVhsUXBJWjRYYjlXd1lXL0EydUlCMlorV0UyN0t2?=
 =?utf-8?B?VU9uclZYeElkbTdVZzZ3TzFRc1phcFFZanM2UUhXUnRCK1dPY2kvQ1pvVDlo?=
 =?utf-8?B?S3JvU004dTRKaUtMM0oxU3d2OGpVdXF5UjQzb0UwWStWM2Z4N0hwREZnYUlx?=
 =?utf-8?B?VTVOUndxZm1obi96dWVvZzNnNXBPaGI5aG8wc0p6M05aeElFYXRMS0dtWGpv?=
 =?utf-8?B?RVR4V3VPQm1JaXF4ZVVUSlVZaDlOTEVocTF2ektQN2UveFUybjM0L2NzWU9n?=
 =?utf-8?B?SElZRDF3ZGZNMGE5N0g0VkcrUWpjU3loVEVIU2dLZFRkS21DRDJvZExYUlds?=
 =?utf-8?B?WHFRRzM4TTRRdlZMVGxEcEpSY3dYeUxCNlBwd2NqSVJTYmpHZ0JNY1prQXdt?=
 =?utf-8?B?VUUrODc1VVZWZnlyeUdqMnFsZGVKeVBwVGNscnMramEvaC9SWVJIOWFSSWNQ?=
 =?utf-8?B?M1pjZXRWWjVCZUQyQVVkQWx1bEVxKzNVRURFalNUYVd6ZlhRNVBESDNhYUVP?=
 =?utf-8?B?aXYrL1cvakYyOXEyVzhKalRjajdrcXFzT0syTEh5c0Ftd1AxR1IvTmd5OVM4?=
 =?utf-8?Q?9lIdqsabwXPGQz7deWDglySgtjK/qiUzAhwWJqzzPTmoF?=
X-MS-Exchange-AntiSpam-MessageData-1: hrV9DTu0GiuPucUg+5NawrEeDPmjUEQkPoQ=
X-Exchange-RoutingPolicyChecked:
	LEZ6SdwrQsPatEqRWii0y2qgSU9JcBE2WMcTH5udn8j0CI/33HzBQuAdi3WwWLnrpt8zcypqIo75pRpVRg9EqVAJE7OB021DYWiBdpEQuVOdXpIdidGYCU6zMz+tE14GBrE2P10AbelDfGHkU/eFWsB+7cWFWIl4SlkPegZ46o0T0mZAYou+3Yngtt+mz8+TJNnjjpX/xtN24WM+5d/FiDgrReKDWnTdaOTE1wIejQ8XZujNdxIfGaVmR3Jcqq1DqIg1rm+xrLrhiEdKSbkyqhzdhEOGqK95HaOLp8BRjx41qfzycvW7Jbdp9k/F7UIefVRoG+M4Hd/mswpxSRlg6A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PZqFWz22NOQQTSUZ+RsK0HGv9suV2PuncI+XS8V7z9TB+jzlSpbT6cpYtzlCphmAxtQmf1z1lygb5/wNlWY22el/njt7HluQSsBQ2khf/9la2JKuH5IqB8Q5bViTjlsZGYVHhvEn3MUelc6YXom6OHl5cFOCFvJUL88TBwOgGloAh/Og1qF4t+eIjU/A+8uvTlmVdlWct9RSGCc1KK/4tiwvelUPb0YoxfaVsg+KaGsdptaj9syE6bgMA5t3eOknMQ+Bqz1VpkKnabjhW477eF86Jwx7DxTF0SZXbYA81kMQRA1WIihVwio/6xLZNXfKQl/oR5iPlkuRr/kQi/qi0kBQmag8FW/1mupeI0cOU4Gxe+YQCI2mj8nesWxJasGeKXGQdsfufQ8BSnqFyYLupwvY4kcYqWjCTx9503U1Jc9y5NDtf5CD+O7sn1V+52gDkWH7nvL2LAYpmmR/7soXFVTUDpFJ9dH+9Za/fC2sHtkSWiRgoP4gOYN7shUVu4PgZt3HZq/3b+vLyye5gWHVBADY6Hwt4XGKMQNxoQStKFzxETxyGqlq1CrK0p4PtlfPqWUS8PO7YfSCUif2UHjRTVTc/CrED41iv8EJzbx+JU2tP6owLZyDTHGupyVoQiWF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a323ee8-9481-42d7-687f-08de993d178f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 09:14:40.2831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMe/0X7+4HPWtYFyf1EYYPO1xkaDndF1HRaHaVvtaC7n0BQleMKbkjVrAjJTIomlu942gaUcLurWioU5TgC31oi3uoyJYOEcCsPDEe0d0DU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7499

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

