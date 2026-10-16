Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E16380FD2
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 07:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792134117; cv=fail; b=jlkHR1prYEebc+/w4iJnj1IGD3ghrYvbzVqsH0CdzF98KkvYreCQcFaqLRM51fhCT94Zu9IqaFYELpVOCuVQsiJ/jr/KQnw/H8IoZippFL7TbOv5Blcm4nolJ7ti3ODnYjn2r8GEy8QhmhnB/rTA2FPEQrqTamyW6IznrI0gNKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792134117; c=relaxed/simple;
	bh=dZYwwJhepbVCe/Qe3BsdYoVhaQwZI8cg4pNMnNZTpuQ=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=AOdn7E1MUBQeAaqfiS/n4RbRmODOyZLZ6ZNZwc5MZtkZW/kxDQcvRvtnUOI59rHjz6GHnLlee1J5/THKTXhffNRtr182m91JK5PHjq+1I6ncUh1B3FxeGJ0Mcmz4IF/UJhIM2Elkde3pJiy5nNF39bQ3LaUztHc59e9ba7yMkH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=T8/oaLmg; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XiSD60g0; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T8/oaLmg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XiSD60g0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792134116; x=1823670116;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=dZYwwJhepbVCe/Qe3BsdYoVhaQwZI8cg4pNMnNZTpuQ=;
  b=T8/oaLmgBGZScy5CvAUplW6ozB2xIGE71OnQSPNI4V1vU0aAiyj/ci7H
   ufsm2ZEhiQNzjT9FMGJJbG5dqRRf93NZyF6l6MXSiRc+As4L8dZHc0x4u
   9SFlt/3C0ExZzt0T6XowCY4R1MCMTbln9SqUE1jSeAiUKo+AsvWS6qoxk
   Qgut3Nq7J+RPlxvKaG1hWJzqkUftXzYLGq3KZVfot7IXtdaa04LnZucMF
   y5j0q8KeZStN0GH8AfVBW+NY5aJCrZ9wS3zUk/ngD8TvtuaLlOgDWB0zz
   EQARQraMu85EPoD//C7TnGZz1M34z6ZHhRkoqvcIt1nU74qT2jhZDeuhy
   g==;
X-CSE-ConnectionGUID: zEU93lWwQJqm9Ep82eOjXA==
X-CSE-MsgGUID: Rxj5CnjCSOeOnkP1GZtNjQ==
X-IronPort-AV: E=Sophos;i="6.27,161,1786982400"; 
   d="scan'208";a="158250501"
Received: from mail-northcentralusazon11013060.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.60])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Oct 2026 15:01:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=py1ok3E98mgx2iReoL8LnUS7qtetpWdNHHT6HcpV/slEVeoPeKdLDMAmgb//+HbVgt3FzwAZXpmFvHIYDCfyyIn6gGknTEjfDUMWAt7PbPS5dDTaGw14UCiopVZR/PZVYj9fsn9lid9aH9rL50OXliXzSJuUphl5B5XVqA96D7hY7/MtSAJkMKBEw+tckDfqHC71NcKWk1WeRsykZvtZiMQC1odNkzpcMocYc9SNcY60rmqVxG5AaizOCu0DXjY4emZ9+rC0eLPMnvysQFuQH5Ajv2azwbCcHbJxINltmFnU11lKaNVNzeLboKbe7fP8u/HqKHncKPdlCCj2tVQkAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hc8T7h+nJjPTytd9/ut3r5Yt2wD27Oh/doPlTe0a/zc=;
 b=Ytt+Qt92mWfp5FHI40RpVZnYadRolkwg362Iu9A1OSp0DoXqW7ds2jE8GTPPGIcRlCsz2FSbixG53I0MgZTggo3QuQgWe292uX+Amcy1ucY4By1d/B32P8kiAfmzZUvNEOkJObc6YeKD0Xj7907rivckCzzcvV3EF6Kiow4xG3MQxjnQX2JCsS2IeMlY5kk7yFi0Xq6ltD6QuR9pNzZYmWG5WxOvIkSE+2TEHaRJimMpnoKddaRzTARA3qYIlOfM9opHd5Vck4JxMzIbwO6ZsqJGMrh4ml0EVGrrMbQdlbGoxDM21w7TzhNVbqjQ/ciEhM1PIqpjcM61SBvRdQfsrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc8T7h+nJjPTytd9/ut3r5Yt2wD27Oh/doPlTe0a/zc=;
 b=XiSD60g0vIY8PDh/xJ3dirW5zQ4I/L/pBjq5hEx03cvYUmo668BAQS17yZqkTrnNb9UH0VMu3g2PSWEFrWlrYKrneg+2SGZN1BlnDWP9ru7EeAT0CbcZnPrBGgpRQDNgIpBIM0swJkghGQQexfZ3AXcdKbYB2kDA5ULp9yCALs8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by CYYPR04MB8810.namprd04.prod.outlook.com (2603:10b6:930:bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 07:01:47 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:01:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Oct 2026 16:01:43 +0900
Message-Id: <DM62IP78U8F2.SBLRTEQNLPQ6@wdc.com>
Subject: Re: [PATCH 02/13] btrfs: zoned: don't count in-flight data as
 available in statfs
Cc: "Hans Holmberg" <Hans.Holmberg@wdc.com>, "Naohiro Aota"
 <naohiro.aota@wdc.com>, "Damien Le Moal" <dlemoal@kernel.org>, "Christoph
 Hellwig" <hch@lst.de>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
 <20261014120353.757931-3-johannes.thumshirn@wdc.com>
In-Reply-To: <20261014120353.757931-3-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TY4PR01CA0072.jpnprd01.prod.outlook.com
 (2603:1096:405:36c::7) To SA6PR04MB9269.namprd04.prod.outlook.com
 (2603:10b6:806:417::19)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|CYYPR04MB8810:EE_
X-MS-Office365-Filtering-Correlation-Id: 724a9ae1-03bf-46f7-8c5c-08df2b5357e3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|23010399003|376014|366016|10070799003|10067099003|22082099003|18002099003|4143699003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qndnQTRj9Gh4qGkLYJGvA0U+NXBPds7JWSY6MeJpLLxK9ZmHmYb1nYQhLRn5vmKkGUjN/+inhHAE+n4+yo7Fhb3ZGMLchwKBlpMZbiebR482laDTM9OPrB4vYIY/NF+C9kbEyWCTO5fq8IutjNSsj0VZ5mGU14D5aD849WTgY8p9H2lZuWEq3PwADq+s8DEWiPnTOG1gmvTWXCmcmrqS+YJwMwq05JtlM4vTJcyKaTh5f1V+fX0fr6YB4FM6o7vMWGWKs2tM1Ogt34QDQrb1euUXBt3eE6fSG4+W9orujbeides8/Qf8qdHrvTQNsGSPloFBWNqpNflY2w97t8HYTX4wVQ5xtIWKzRcbXo9BXXAEmwErzQI+vz8J3V1O04fdu6iSTF/bugyK/WsOUOvAaBmRLipKpWcaFZ9o6iRe9P5XzkNA6X1t1g0rmPJyQAYtVPWhKuJG6Dw65N+V012LLOTwiezjAUJCnCiN8KUkA4JP3SMYptxAwiQ/7JLAHVBa1Qs48fO25Pt5tkuXK8/lYLo7evDiEn8T0qwYr02v6pjX2DdyhlYruWC2edbeB3C89vHo+qeiB5OnanItkGANVtBFowy2NStuCby4EVdI2Rfumg66AtlzDYo0PIgUF0jkoIhzFLmAwadnzNmJrz7IwO4/E47BkiLGeD7faBBIkDg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(23010399003)(376014)(366016)(10070799003)(10067099003)(22082099003)(18002099003)(4143699003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzZPZG1ranQ1OVE2eWNlajVFN1lVdUxoYTJkVnJEc1loQllhanRDbHBPYTdX?=
 =?utf-8?B?Ym1tbUdMV1JnTndkejVWdllaaDhQSW5zbldYUTdBL0I2RlpZa0NURDFKQ2Vu?=
 =?utf-8?B?bE5WMzh0eURoRnlrQnpaU3NueCtTU3JlRjU1RXFXRElCTHlvNWR2OWtmeE9F?=
 =?utf-8?B?Nk1YaXdqQlcwM283bFZCNDdEdU1FWkZneWZjS0hxUndTZk1LYTVlbXdZL1hT?=
 =?utf-8?B?NHY4UzUySGVmWTVYTkJ3UThGbjd5QWt1RmVIekNuUGVNK0RaWjI1M0Vlb2dI?=
 =?utf-8?B?NlVZSDhyOGVRcVRXSUY3S0svYm1sUmtOaHlVVjR0YzVHelVzc1BGcnN5M0dh?=
 =?utf-8?B?cGNRcmlaWUZhRUI4V3hLR3BiT2xKNHZ0WnVpZS81L2E2d2QrUlpLdmQwcXdM?=
 =?utf-8?B?SllUcXJUdTdUMmxhMURZY1ptUUNDNCs2VTk4UWhCRFhCWEt3ZnY5RXJZK2FK?=
 =?utf-8?B?YmRhdXpHY2RpZ01oQ2hzTS9DRGhlOEVDOVJmM04xdFNtZ1hzRFBNS0YwT2dv?=
 =?utf-8?B?RjhxSEtuS0dNZk4zTEFldDJ4SVFxMVNwaXlXM1h0cTNSaHpzZGI0QjJEejZy?=
 =?utf-8?B?SWdlbWg4OFJ2Mm5kUTU5MlJhaUdtOVNScVZ4bENkSUxLVGJlRGRoWE9TNEJ5?=
 =?utf-8?B?VGhSZ3Z0ZWpxbEhHa2V3NUNVU21yYXBSSityNWZKVFcwZjhqbEo1UmlWdk9H?=
 =?utf-8?B?VmFXTjBxQlkrc1AwNllIaFRzdGNZaXJBYW1QWXpXNUlqVG9zekxMVFdsZEoy?=
 =?utf-8?B?QTdTOFVUbmR3QjNCaWtCVkFITytnMjJaVGdVR1kwemtDczRQY0pCWnBML1lz?=
 =?utf-8?B?YjAydnZSb29jM3NFZU16eXF0cExnRzZLQWRVcXJ1T2JzQzh1Z1M4bUxmVXZ3?=
 =?utf-8?B?SkpRcDBrMjYrZEFzQ0tnU3VXSmlEM0dsLzhiaEdCQVg4SGZPN3YvSHd4ZEJs?=
 =?utf-8?B?c25SZzJzdkErb2ljTU4wcG1ORngycExHbjZOUm1mc2NPVjdYdm9NSWExaW9J?=
 =?utf-8?B?aXhMYkpuaVJ3YzNKVU1xaSswNjZaTWtpV2pqd2doZFN4WVdYSUZVWE5yUEtx?=
 =?utf-8?B?VDVNWlpGQzlvNUpGdGVKMGVqRDBpb0V5d1JwZklLd2tvZmkzZmdqT3pCdzZL?=
 =?utf-8?B?UzFmdE5HZ0x4WlpBQmJZanJKSDB4TWJrcHRwY3NEUG1OM3NvaGxoSEVtYzA2?=
 =?utf-8?B?ZWJXcjZGSnRXT1cxV0dLMHlEQUVhMjFzTGZmSVFKelhPTk1ZYk8zUnFnT1VG?=
 =?utf-8?B?VWZUZmNRM0dkb2NMVzJMK0ljanVTak9mYytXenhtZHZ2bzJQM0JMaGkzb2xT?=
 =?utf-8?B?R2RPMTlJZTFKdm5kZzN2V2JzYnpSK0xaQUhycXVVa2JRamRUaTlySERLbGNR?=
 =?utf-8?B?TGpYRThVQi9tNGJUeXo4UmQwRElzUVJpOSs2NXlVeEpTTzNKcVBaQTJwN0ZZ?=
 =?utf-8?B?T2Zad3F3YWFvbGtkU3FyaDBTMGZGU0pDMllhb0s1Skt3THdKSFVpdUFaditB?=
 =?utf-8?B?ZEZCenlwaU5kOWE4MDJtQTFtSHVUc1orSHlraXU0eE4ySzBaMk1mS3V6cHR3?=
 =?utf-8?B?ZHFXNGVBa1Jxd1djRlY4NmtFdTE0dGgvWllIYUNVNjNUVEMzRXVTTFlCNE52?=
 =?utf-8?B?OThib0Y3UTIreWgzYzhNWXZFQ1hjRTVjeFlJeitmK1dhRG9zTjQxaE5sZG5n?=
 =?utf-8?B?T2NDZkFUTzZCdEpZN2crRGZVVEhMWGYwd3BxOFM5b1htaFFJOEZXY2lpYmwx?=
 =?utf-8?B?cGRIM0pQTVVhWFlKdTNDOWVIUmlhMUR6Sy9nMC8yZENJaGtGZFhJREtqL3FJ?=
 =?utf-8?B?ekNnMDhPYy9SWUJ0VXJ1UnpNbUhCZ2UzWFBsZG52VU1YRnpZbGNOQkRjZnhF?=
 =?utf-8?B?eFFCS3pwODgwWXpWb3AyVlN5UEI2OHRFLzB3SWRqblpETmZNMjgwcGhadTBS?=
 =?utf-8?B?Nnh3UHRsUElJOEJYZC9ydXg3eVZFZGdqbmdMbFI1M3lhYmF0azJVVU1GUmxY?=
 =?utf-8?B?U1dKY2VFcWIwQTIxQXdsSWJCTHFYaTBuTGJTcUlLRDc3bFFmT3hkQ3dZVVVs?=
 =?utf-8?B?SFlIR1UxcEtnNE5uak1rSEx3UEZuKzgxRFAvOCt3UnYralBqTDhsZDFtaWt6?=
 =?utf-8?B?Tis4UjR5TWxKWmZDR3JUdzhUMWNVRVNQQ0t4ZWZUditmZ1ZTcWk4Snh3dHAy?=
 =?utf-8?B?REdDV0xiSnBZVHFLTXUrZ2J1SmF0K3BkeFRFMG1QWVEyL3piVXNSVHEvWVRQ?=
 =?utf-8?B?ZHd0dkwyYkFRem5HM0FweVVMeEtHa3MyRitqZ053WURFWWE2MnQrdzRBbC9W?=
 =?utf-8?B?S29zRnF4WHdXSTVHNExKNTIzTmR0eE91Z0J4blYxbXVRaHdPak5MQnJHRjcx?=
 =?utf-8?Q?1VAfLLCyqnyK+ICCEpZN9sN2rkJI0RxuUCoXLyKFqfhmz?=
X-MS-Exchange-AntiSpam-MessageData-1: 7dJGY44mpSSi1w==
X-Exchange-RoutingPolicyChecked:
	eiN+HCtYmYs0umHKjCH+N/nr+KvUXXlHoCbhDxaBfZ5kdcNr9iFJwvEZg6ODNuSEAkssvXqxb+Z8PC06ludoH90CJ1mAFZ6atF92KnXJjlRhnTbUlycBuTQh2HtBFxJBGLwDZxxoq4HC8dqEzkrbVOysjuRP6gKG0PUOFBbPBXiH9AHS/6UBFPu5RM4xQlgGRkWShI4oFIPXLNW32CZjFeDprjnpZ1WHDJmy2KRpjBzE1BQ1BIJNRj/D9psGPneG7X7Yt4p0/KYpqBgkJ6L6Pt4S/kuKXLL5qyNVuqwoE3EpCdwN6g7KTp7jbkdmFC7p3auZJWqxK4kEByvVPkv5ZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nCaX1VK+ZDqr4Hfpvx+I+ghe10bFE3DWh7zcSKE83EqZY2oi+Nk5haXlvQIHSlGQGBWzUOLH5hXJhH+Y6xaL8dxWAhq0DHfzDxd+4QL5fViuxkRvLeboATRY7Se50mu8iEN+IhZy4clyOmWoZrufrFIQk/MbeX2CuRWq0cU9IC7ItbR7gLz/dolAfSOzeVPqtOk+Cw/OxN4QKewXuoK2zWuct17DAE3ZXisn58lF+khQHy9akjhthPfJkDR921Y/KDVsudPqBzUBfAfosL+SJ2VBoociiPUZTzCQdALlk67Nkny0r8iCKti8s2HzcLZW7Fp+GX0mL1Yvo3V+fR01aBBDEjheTvCeZS0Z2fgkxsGgpPHSzCDMQnKaqhm/DM1BpzQ2OaWfEcjrYwEkHDAQKEWBohlq2xWJ3He3HKk4K6eeN3xP7jvFEqFOi4PNT17j0Gj4PtKq3My52YvZIkOnq5YxM6lYrdud9ymjHJCU9Gj8TV1RBlkwiyJq6C+aDZ6Iku/HYWZVzcbS7VFP8IUcmTGVy+92dgc93uBmXTGC8ZLKcsykMNPJfwGTx4Rly0d4hwP4Ukwl50TUZ8nU1o3UyBpzx8dIBpqd8KuYHlNm9Q3BO/dSB5uEYuq6wRSv9gVY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 724a9ae1-03bf-46f7-8c5c-08df2b5357e3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 07:01:47.3618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbD6uvR5xeKVPMP5PChbAi8L5WUHh8gzlO8J93Y9ShqJc+Hac2C4fHCUBskeKijfp2Z+tnFyrdiiQJaqxC95Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8810

On Wed Oct 14, 2026 at 9:03 PM JST, Johannes Thumshirn wrote:
> On a zoned filesystem GC makes freed space usable again only at zone
> granularity and after the in-flight writes landed.
>
> Don't promise space that is already reserved by delalloc or for extents
> being written to the user in statfs.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/super.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 7fabb775d4e3..cbc1662abbff 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1727,6 +1727,20 @@ static inline int btrfs_calc_avail_data_space(stru=
ct btrfs_fs_info *fs_info,
>  	return 0;
>  }
> =20
> +static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info=
)
> +{
> +	u64 profile =3D btrfs_data_alloc_profile(space_info->fs_info);
> +	u64 inflight;
> +
> +	spin_lock(&space_info->lock);
> +	inflight =3D space_info->bytes_may_use + space_info->bytes_reserved;
> +	spin_unlock(&space_info->lock);
> +
> +	inflight *=3D btrfs_bg_type_to_factor(profile);
> +
> +	return inflight;
> +}
> +

I'm not really sure of this. The bytes_may_use can take a lot bytes for
the worst case tree update scenario. And, that is not really an inflight
amount...


>  /*
>   * Calculate numbers for 'df', pessimistic in case of mixed raid profile=
s.
>   *
> @@ -1766,6 +1780,12 @@ static int btrfs_statfs(struct dentry *dentry, str=
uct kstatfs *buf)
>  			total_free_data -=3D
>  				btrfs_account_ro_block_groups_free_space(found);
> =20
> +			if (btrfs_is_zoned(fs_info)) {
> +				u64 inflight =3D btrfs_zoned_calc_inflight(found);
> +
> +				total_free_data -=3D min(total_free_data, inflight);
> +			}
> +
>  			for (i =3D 0; i < BTRFS_NR_RAID_TYPES; i++) {
>  				if (!list_empty(&found->block_groups[i]))
>  					factor =3D btrfs_bg_type_to_factor(

