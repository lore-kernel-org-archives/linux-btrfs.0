Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D8332918;
	Thu,  9 Jul 2026 10:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593556; cv=fail; b=PNONxyGm3l92Po1bHEG9SEOb2AOvElmPD+Tav9atQ9mw3uN6Ad9pPNdpCbfo7X6CoQCjhAcq6VUOUAqOt2z9RcnkGX4dfiF25kK2HcN7vJ+ZyslgsQxnAUYaq7usO8r7waG78FRaqFUzG4K1lM7+XY8XDBxjDnmvUJHvc5yHTx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593556; c=relaxed/simple;
	bh=9oJvpGvo4gw0avcAFb+wjK+t6RHzb+X9WHfiMijqT9M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qjRVXfrM3ph20PlghH27sp8NYVEidDbMKwgDV3Yst972u3vjIfWEQc3FMHnp31F4KnELH/Ff8HSbT10HcDjRwbufhu1/mSu2zCIYBD23pRDtaI2REitOxxVR4E41L7gZfnWi5Shf4OOBcpb6WoL3r0MRZF1CF4fA+e+HtmMTbXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XlSJQTU2; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=URtyYPrh; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XlSJQTU2";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="URtyYPrh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783593556; x=1815129556;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9oJvpGvo4gw0avcAFb+wjK+t6RHzb+X9WHfiMijqT9M=;
  b=XlSJQTU2DIQmLTDBYseHWXah2TWdyOcdhyZ4p9Ak3OCd0GsadMBE0Y/T
   xCDXEm/czFGgDyjzwSE70d5Tbfz5YHwiC9YUnMDbcM9u5KDMdfpav4r0G
   E0PqhyGWc+x4vU8Ilf28uOIW1QqIp3oBuOAmIBWl8XIAGj/pvwuBspAS1
   z29QnFe7eKypgxVDS1GQw6Ww4a54wREJuSesMReT1AStpcufH5AL3y+2H
   Q9lI2N8DnfkJI846uRwVHpsGKbjk9xJ1wSfd8OW2sh6XkbCqLXzx3URav
   mbg9JIfXYtXFG49zvjXIv46+KURLnJq5xuQ08CnFA7DUrfjjQcDJbPeGl
   g==;
X-CSE-ConnectionGUID: e7XWI6YpTx+vwcQxUaUDOQ==
X-CSE-MsgGUID: MVWrXj/zSnKh8HF1SM4l0g==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="151596427"
Received: from mail-centralusazon11010042.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jul 2026 18:39:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hfHR/JPpkKf921PdF04S7Wea/I5AQjruoeWWoXpCKyM1ogJg0WFw6agV8PjaWpUDzR4MTC7llWX/wnR0Tup0BnvzT2msGTAb7UslslQVem5QL5unTFbmpc7bI/cYHcsqIAIeCL2CSc81CgKc7WmxRc/KSpF82dp4NG3ubATXCrlSHx2Sbdnic3kHF2woMwA/i+/wujxSGxTd+OjkFwaih+DP+oa8aCn8iFsZqltyzgfMVNEPezVtZFN1j9yGFzlNiBTMSzz0XhJLuw0TT0RG3afoz3se8YlswipmpLbqiabgfudEiwd4sCYtN1VRl2Yvfwm33/4KLk21eYdbRsNt8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8LGlBiPEbXzw3CB9CeDpSuhR+sRoamdM/KR6hG46LQ=;
 b=EBaC98oW15bTej1X4uYMevibKQAdbzFkhSlq5p25ONbqvNKTwJ3L+KjBAY3OsNi38hOt4SoR8ns4AyIt7pJ2k2a9tt+rp0ugSpP0dYquWCEPb+8dpnXGVFOPCmzWja0Pg02L2v5NLu1y3PnVo3dCpSQIrB/Mh/TsQCYe1GXKvWriq1V0BNFqPugDiRDsWCjdYAXWZp6NAu9ovl3vU+04AFURjPLzfHIWD69fRdghwH3naWow74rl4kmtn1zaEIonnXb+gkynvtPEi8qH0yfj0o73URppP9EI3+n2U1A3wfVdMBwvmBtROey5I4TrqX6t5v7DNJ4rlVVyNLsIbff2lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8LGlBiPEbXzw3CB9CeDpSuhR+sRoamdM/KR6hG46LQ=;
 b=URtyYPrh0SBriM8FGvHMIcklrmueweSDW+Iut2zKND4xicHHLsCRH1jRU9RDkBjkILigpAXzUeFm/5DYnqpOPVQtfWeM1YvL6iooI15YDPryuBHnv8I8c5P8LXDS9QIQEftGY64cAUXDiOGVndEUWpXN6IsKIuTbBbmj1MyGbo0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB6691.namprd04.prod.outlook.com (2603:10b6:a03:224::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 9 Jul
 2026 10:39:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 10:39:02 +0000
Message-ID: <da322943-0b16-4819-8370-6c801f836eb8@wdc.com>
Date: Thu, 9 Jul 2026 12:38:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: don't submit orphaned extent buffers
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, stable@vger.kernel.org
References: <20260703055431.117181-1-johannes.thumshirn@wdc.com>
 <38704f1d-5880-4162-9051-4e6d0086f8aa@gmx.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <38704f1d-5880-4162-9051-4e6d0086f8aa@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0073.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB6691:EE_
X-MS-Office365-Filtering-Correlation-Id: 23234c51-7284-49d4-cdc7-08dedda64af2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|366016|23010399003|10070799003|376014|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	ZQfZqjHlEcyBGg/l899LH3bu0NrqcA3kYI8rl0bA9QlPypiaWYrgnlkSd74Jh0YYwxtGC2GjGxfBEWhlUVAH8td8qF+eq0usHftuzLZ0EmnPji/NA5xm4QWVxFQb5ZfdCUo1rA7Wqsdgi6rdXrhI1oTam0Gq3XTMwZ4Rm/EiKGoM1vpFIR7iPJFWRUenfF2Vtj8jbCbsmZqi0tlHNVejCKc13ZDoXhBNGBU7qkT2oXZh49dxwQorTkCx/Eo+SbQMCUeiQCJiN6QXvvIT7I/ZMCe1/iAcrfnAnIS29PAlChubWbxRxAiPw/kqTvSXZ8fyHcxxnfBIiJpY7qpgrg81ynGgtCzYEJwrSCIWo36NkqoOVdsVL32iYm/NnCW3HENXP5Y5dxQPVbe+MHcAKpeGeGOgh45up7CTLL2oa6mDQdyuzUeCrrBOPz2lyB1Ebuqtm2lMeeyBu5uqLsFYfl8FzVC/S4jG4WCILgpTVVSraNtxjOR6k0r7b/lYLV3pvqJuRNpe7fRGtZoNtmi9XoCCTKaJwy+9IB3Xu3mHl+rslCS/fiGULDjyIpbyL3MCL8GNtUE3iPHZBQ6uVa2KN0Ak/CdWqCr6vZF2OD13gf4ioDJ039MArmdgyAPrlFZt11Mn4NvguV9qwiZjHKS+Br+zqjQPwSZJoxk9rjk3NOLhLpo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(23010399003)(10070799003)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzZlSmVWQ1ZuZjE3RWRmWENqMzlmaWEyUWlMR2VQTWw0MGdKVmVlRWJHUFhH?=
 =?utf-8?B?aTBOcDY3RWo4REdYWWE4MmVDNWs4bWtTa2FRc1VaeFdkL3Bqb0d1TU5VTVVQ?=
 =?utf-8?B?bmFVK0ozY1lXRW9IREt2dVBUQWpLSEVyZHdLN0FENWVtVlVGSFJndXVyZ0xt?=
 =?utf-8?B?N3hBdzgxU0wrWFhybFY2VzJIam5BU1l6T2pTSUVXZlZRVzRDb25tZkFQUnlR?=
 =?utf-8?B?YXEwbGc4dmVIZVF1NHAxaTVjZHhtTXc3SkcwLzVBVGdCTjV4ZEN1MHNCb05G?=
 =?utf-8?B?UnBrenp4SUxKdXpWQWJFblU1OVk4SXU2TjF4Y1d2RVNmR2NiY0IybGtEb0I4?=
 =?utf-8?B?WmgwbmRWMXduVnhSOWQ5NFF1bGZEcnlLZkQvNy9wZnNYV0p4SS84Q0g5V0tM?=
 =?utf-8?B?aUFaZ2RHWkxsRHdXSUcwWXJhUFRJVnN5aTlFTVFBbk45M0F5ajQ0aUIwK2Y4?=
 =?utf-8?B?Zi9peUpLMFllbnhONVRyUW1COHY2Ti9wR29DWU01dmJESnVvbCtLWUR5QTZZ?=
 =?utf-8?B?VmF2NEM3ckZ3cVNPUHNxZU05VFZiSlNCbnQ1TnBaVFp1dVlIUzljbDhUSitp?=
 =?utf-8?B?L214S2cxcWxXMERrQlBPTmdmVnJXN0VjRUJTSU9YK2hlSHZVZGpUWU9WUFM1?=
 =?utf-8?B?VDYrYjh0aGtTdlZJS2N3cDRuVzJiNE44SE5YMGR5N0Z6RzVhSzI3allVTGFx?=
 =?utf-8?B?UGhZZDBaV3IvOGsrV2o5ODg5dy8wZU9TL05sOUpNTmdibHovTlcyeHhqS3BR?=
 =?utf-8?B?N3hjUzFPcEZvL1loL3hMbEdiZk12OTB2cVNlT2s3d3NLckcvNVhDVmk2YzdL?=
 =?utf-8?B?SDBXQld2MFRha29Td1Z4eXRGSzJWcUlPUVA0ZEFWTTFwam1RUkQ1UjZDb0JJ?=
 =?utf-8?B?cVAvb2d1SzdQMUZQR3RFR1I4L1N2K1QrZkhqUWdtVGI2TTlPVU44dE9lOXdP?=
 =?utf-8?B?b09KRUJkUUtETllHSzlJQXZ0U0FTN09uck0zU3VMbEk3TnFUaU5nOHpPd0cv?=
 =?utf-8?B?Njh1U1Z5ZjI4dmcxSHhJM282NHA3a3Q2V2dnc3dhQXFiME9yckZQSEZGejNH?=
 =?utf-8?B?L3lFZGN5dDlqM0Q2ZUowV3Q4R2FvRFBnZXAydDVsM0RSUy9mZjVheHg5REZU?=
 =?utf-8?B?RU1qS0NHNkl6aEcyZGk1VmtjTFhIcUVpb2hscHVSYWZhQ1AzT2NaY1hjelJk?=
 =?utf-8?B?eGRFU2hmVWdYRmUrZkVuQnltcG4vOHRaeHl3VTJqWnZmYk9MVk9ENHNyNTkv?=
 =?utf-8?B?ME5Wa0t0dENsY3FuZ3RkVzJkRTJmQnlwbkhGM1ViUkUxSzByVDFyakwwM3ZH?=
 =?utf-8?B?YjFTdTRGbUo3b3BPMnlXZmpOMGNzQ2lnYjFiYUlGazJUREdWM1laSUJ4N1FG?=
 =?utf-8?B?QkViU08rbDJvRkJtbUVlbzBPVTNvSEZ5KzRQWXFtVjluS3BjR3hPcTR5STVP?=
 =?utf-8?B?MWJId3Q4MVRydkdpekloVzRJUzljWTA4Myt5ZmRyRjd4MWZjbk5JN280L3d5?=
 =?utf-8?B?bmo2VE8zTVd4SzU1eE92SUo3WHhoeUZhNXFkVjRkZi9jSUNwNnNGRGs1OHcz?=
 =?utf-8?B?WEdMTVNJRE9KV3h6d1Rhc0xtZGhaQmlselNndUJkOHFKcFZodDcrUEV0VlN1?=
 =?utf-8?B?OU5KVDhOQWZuSm5jUUVzM00rQmJxdTlxRmVHNEVsUmV2aTE4bFI2a2xXQ3E3?=
 =?utf-8?B?bTNTdGc2Tno4N3JscWJqVjd0bE9yRm9MSjFJMFQ0bTRsY2pLbE15ZjYrZzJD?=
 =?utf-8?B?RXN5cmNWL2xKVjllOVo0QmRKbWIyd2VWUEVMZ0dRdkVIeEQ4ZzlXSWF6blFw?=
 =?utf-8?B?R0FIRGVOcVM2RXA5MnpacnZzQUVRWlJDanRnOUR4enB1Ty9UMWNmeEcvdEtB?=
 =?utf-8?B?S0RsczJGbHBJWExoWTNrOGZLeXMwSjFnaU9NZnNQck4xQVBQaFRVY2NLU1BY?=
 =?utf-8?B?dElaRHVYbWFXZ25EMEVxTnJJakpsdXhJZFJ1ZFhOaE42ZGVPMkZQenlidEdT?=
 =?utf-8?B?aStSNVNPNERkaVl1eUFKSS9JRGp4WjBaYVR0RDhyR2daSDdaTFJRZjBoSTNC?=
 =?utf-8?B?V2NiSU9QeGd2VjIzTGdudURpQ1UzRGlhNnFvc1gvNzlKRDYrd1hFMGdMZXJk?=
 =?utf-8?B?R3psd0VEVHZ3Tzd4NWUxVVMvVlpYeHZhWDNRZ3lta213a1I1dTllTSttRGJ4?=
 =?utf-8?B?eWp6WkVqSndsQWZDbkROQjY2TFU5YnVKemV2algrWTdIQ2hPVnI0UCtLcXV2?=
 =?utf-8?B?TlhBMXFpL3lzVlgyZk5ueXNrSCtLS2JpS1dnQ0QwWWovelhmWHZIQ2ZBamhR?=
 =?utf-8?B?SmZiOElDUTU0SGxza0FsdUV3T1E4cmMvT0dhRmMxUUl4RDdzOURSWGRxSGEy?=
 =?utf-8?Q?5GN02PSDRQ8ed1jKYtrgvEIeUez5O+lnByy6+LQmgaucA?=
X-MS-Exchange-AntiSpam-MessageData-1: Y3YgO2+aR6ukdiOwVn1leRdaLl4KExesucI=
X-Exchange-RoutingPolicyChecked:
	cILw3NJbTEzygpETXLdj6xrImtjOML8/Hhc8w9eaNWR8p07LDQne+p7HUpGetCAzFZFxdzLmOHJSG2lpv9mCxcf//HR7CaRBa3wdWHA6RlMjElflrE4nR4YfEF64RFNKZJSh2rGckm7z6s6Jg2KcNZNoWtkmeeRXeUivhdXffXmMLlxa71XAHPLi1Ak9hQ1YwCRXe4+1caL0FZHKVV/gZwLXXI7E99Y8dIbkOJydeebHjfG/FF9qC72GPjWcVzGAJ6Lr542HUqRh7K9bZE+9fsUkUR6099EwDWXc6qg83kVkNqQ3FoFZJxAbpzcSnGuLQ5zMC13gy+ghteUZEkRyIw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p3B22pwTFW84rM6QfQEdQ+bvhscgIXSJe2dG5e7Ubt5trx0tb0voLKVVLGxAZCe8RAr9R9SrzFD45NSbVzj9M6vAzsyfCfdzlZ2M4itofivd5+OewfpSDEhGdpJqT81l7fLiKcz/6HlyAX/J/NxL77cq4d1AsoEoz0/VY6d314iUfS2QcvvZG7+9P+9Ix7xPCDrvGQZFLypAqQFmVuyhV1GcNTevJnU74Lyhg7ZDsJlrzF2UGYkgCl8ffPUmZcgKOfzBiPB41hSxPPOERd3amooFrokNEbXKvPfVxGHb3/YWEXM+/OiBxTNRAYqvmklHw3Oj1oHYBjSrmYqr4H48yCR3R5B0dj/TnbX33FG2lHPuehI9mpCiJkNwOwasaC4uFBKlt5Bh7gxzi4Tm/k+qIxjUke5RCtewacsRYCHSh1Io2S5MhoiInOVE7J/AhUvTNmntpZmfa3graqptbACzMrKWG1hDH7CN1315tY4FMOAQxpUeTKjOz4LgSTYTzSFG6N+5ebasNTgfB+Qwm9Dxp6/ONukIqexw1XCvE5mbDOFmS+H5AO15FB4H/HIqeBn2WyXugoYAz70tnSPAZ7Whb6ecud1QzYiUw56byPafTGktS3YH0r23N6G44EyxSdd2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23234c51-7284-49d4-cdc7-08dedda64af2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 10:39:02.7143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCngH5cWSkEQXoqt/gldW4S8ZHx71VEz0BuD1WrIWvRGKNS5ubj/yAYfcEIDFn9UezcY++5uNBiUoMy+QCjm2akmhuo6dXP3WoS9mKpM+xY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6691

On 7/9/26 12:31 PM, Qu Wenruo wrote:
>
>
> 在 2026/7/3 15:24, Johannes Thumshirn 写道:
>> On a zoned filesystem btree_writepages() can encounter a dirty metadata
>> extent buffer whose block group no longer exists. Submitting a write for
>> such a buffer maps it to a stale/removed block-group and leaves the 
>> folio
>> under writeback forever, hanging later in filemap_fdatawait_range(), for
>> example the iput(btree_inode) in close_ctree(), which then hangs 
>> unmount.
>>
>> This is caused by btrfs_clear_buffer_dirty() not clearing the dirty 
>> bit of
>> a freed tree block but it sets EXTENT_BUFFER_ZONED_ZEROOUT and keeps the
>> buffer dirty so that it is still written out to keep the zone's
>> meta_write_pointer advancing sequentially. So a freed metadata block
>> legitimately stays dirty until that zero-write completes.
>>
>> Dropping these buffers is safe: the block group is empty, so they are
>> stale, unreferenced, already-freed blocks. Once the zone is reset their
>> zero-write is unneeded. Instead of submitting a such a write, finish the
>> writeback immediately.
>>
>> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> Fixes: 7db94301a980 ("btrfs: zoned: introduce block group context to 
>> btrfs_eb_write_context")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>   fs/btrfs/extent_io.c | 16 ++++++++++++++--
>>   1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 0edd532174fa..4a029ae719e9 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2280,7 +2280,8 @@ static void prepare_eb_write(struct 
>> extent_buffer *eb)
>>   }
>>     static noinline_for_stack void write_one_eb(struct extent_buffer 
>> *eb,
>> -                        struct writeback_control *wbc)
>> +                        struct writeback_control *wbc,
>> +                        bool submit)
>>   {
>>       struct btrfs_fs_info *fs_info = eb->fs_info;
>>       struct btrfs_bio *bbio;
>> @@ -2310,6 +2311,12 @@ static noinline_for_stack void 
>> write_one_eb(struct extent_buffer *eb,
>>           wbc_account_cgroup_owner(wbc, folio, range_len);
>>           folio_unlock(folio);
>>       }
>> +
>> +    if (!submit) {
>> +        btrfs_bio_end_io(bbio, BLK_STS_OK);
>> +        return;
>> +    }
>> +
>>       /*
>>        * If the fs is already in error status, do not submit any 
>> writeback
>>        * but immediately finish it.
>> @@ -2397,6 +2404,8 @@ int btree_writepages(struct address_space 
>> *mapping, struct writeback_control *wb
>>           struct extent_buffer *eb;
>>             while ((eb = eb_batch_next(&batch)) != NULL) {
>> +            bool submit = true;
>> +
>>               ctx.eb = eb;
>>                 ret = btrfs_check_meta_write_pointer(eb->fs_info, &ctx);
>> @@ -2411,6 +2420,9 @@ int btree_writepages(struct address_space 
>> *mapping, struct writeback_control *wb
>>                   continue;
>>               }
>>   +            if (btrfs_is_zoned(fs_info) && !ctx.zoned_bg)
>> +                submit = false;
>> +
>>               if (!lock_extent_buffer_for_io(eb, wbc))
>>                   continue;
>>   @@ -2420,7 +2432,7 @@ int btree_writepages(struct address_space 
>> *mapping, struct writeback_control *wb
>>                   btrfs_schedule_zone_finish_bg(ctx.zoned_bg, eb);
>>                   ctx.zoned_bg->meta_write_pointer += eb->len;
>>               }
>> -            write_one_eb(eb, wbc);
>> +            write_one_eb(eb, wbc, submit);
>
> I understand this is the minimal fix, but I can't help but wondering, 
> would it be more instinctual to release all ebs inside a zoned 
> metadata bg when freeing the bg?

Yes but quite frankly I'm still hunting the root cause.

One thing I think I've found so far is, we're re-dirtying a eb, then 
relocation GC's the block-group, then writeback comes along trying to 
submit these ebs but the bg is gone.

This analysis could be totally bogus of cause because I missed something.

