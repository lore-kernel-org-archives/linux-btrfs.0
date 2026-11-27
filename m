Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795777297;
	b=AuLOQI9n4sLDNHGmjxDzTpsTZWEHxkvCnWDQ+1xEt2sulHaSowVOUxtvo41p6T0PpmvZ
	 zBp/BBkiMFKTAq5PeRjxjmiLlE+TAs/wo4k34Pb7En7QKh5cs0YYXq3X+iKb+EwzzLRT4
	 kd+F9aXOD/+AQ/PCS7e09B5cSWCU1+s0466rPs8hWr9M4fO32njASp5ZYMsQrDQOyDskp
	 weF3AE/BYXVeKjhTC+ADO6pZieoAMcPZzTxNRrmBbYdXbqMTI5fbMDDD0FgtJb4IP6+bV
	 FtOx5BlnG9X73KctbbzGpJy5MaWUIUzzc1VL7JpgVXrQ8z+fMhD4WHQ7xzC/IysAgZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795777297;
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
	bh=e2ILxeAESzk3qqpDT55IYLF8Sp15PML9jxAm5HL/RDQ=;
	b=gNd6hOn2hROk55hcA53+o15fogWD41z32RG/TqAjvgoJf5khyAZW07q0Yql6RBcrfQPP
	 6DPmNeKrE0OXjt3kcv5eF8+nEX29AV+uQuGF+C65r0/D0iS8hJJHU1w02umYv0ga6Avlh
	 U98rEzKVSc66wS2+uIyc8FnryI7gYgColkow4J1EGEqoa3b9HtN3LeeQ3GSZcYpo8BTOm
	 rpErotlqQhL5NfWma2Vfiaxkxz7bPvK6QeekbLzCuhPaafkwvsOrYSMpryFVl7IvVJGOU
	 aKxodUM0MDE85rEfwqopWcyL5Dyebxb+AqUJTdcNrflYLZ6o/l9YyQ4TFfa+2DAKA7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=GtEKJDjB;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=lfaK69ny;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE73606A31E;
	Fri, 27 Nov 2026 11:01:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAE73606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=GtEKJDjB;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=lfaK69ny
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795777296; x=1827313296;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0Td3K/PE+gXHfDTRmUpjZNRJkG3mKcuAer+iWiuVkps=;
  b=GtEKJDjBDwK1Fx+z5DQIobafow+iNuxTwQZo4MMEuORxCf2LgOcluPTZ
   JGZhSu8LuNJy4gg39r/uwSv2FxAYBxz7pYBJiA33ILACOsAQuc1SlTtKv
   EYwUAAamOB59U1EGVmCeeRdLgJqnxMGwLg129dAB87qQH/JNrce0v5H0l
   DgtP3eRQE2jOvpMtasLSAoRYDiLEUVORy9IclKqQVFZNuuuWypRzHTITH
   971LWRtITjf1rjv2JlkjPppIyK41OOrJjkhRVBBd8EbD+hmhTK0V6Cg8j
   rinXJJtmRuxxy7iA0UKBxNK2zB2fGaZwJnjXBqoSN06Md5gK89Sk8Hi1k
   A==;
X-CSE-ConnectionGUID: vSVLk1sGRTSLrSWZNXjfsA==
X-CSE-MsgGUID: 0kAOxYxySoaTGw5EINyEyQ==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="160929537"
Received: from mail-eastusazon11012027.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 19:01:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wie/IEOfThUq1Reb4Ab1EASeRV8n4fsXViC7SPDBlHS4U9c93a3txCYWKq+mqtpagDCdWjfOTUhq7pQh6qaM6iH8KZJ4j8o5t2eOpdU1oaFUK2zoUNN9pzLCyBH+XQ5GAVKkZ2PHlb3OpIIRDlghUAPOORA9VAC8ERQ2lbNcV4wIbtTucWneykNmyhDfzIJ+c1z2x3Qrw9i+VXDFZYGhp/xDy2JMDEt8AnyjlaDgTicjXPbWWNIFS9drWMQNVkMzFTxGlyd9Sstj4paqtXHAC5PxnMK59DLQF+KjkFXM89plwUbN8gSrbnfyWTmyJ99STlurlO4ldq9La/NImqmDRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2ILxeAESzk3qqpDT55IYLF8Sp15PML9jxAm5HL/RDQ=;
 b=wiWqHvEZcyzgq1hFzpI5ILvd1insuSWnJrzeco0/jwop4rvxDEFKD1B8M9pwxnNDbOx6peN00aCbICDVd1JqeqAUh23TpzhxixVVvoTlMWZapP9HBQJ0yQEETRh6DSmr/I8k6eFrPMFQGdMXoJG0b8ll75IJ9kYyCV4ukYY4Be6IjUGBOOp7jDK2XWxn7uMlo4U0wLrR+033b8HNVkOhFPQBDJhbDhyqDV/Q3IgGlrHJScOvaimQsESpDe0MNm1br+FjY93A+EDuuwVEhDhRBehP4h4npVTZwZZ4xVa/mShEfqt6ApX415l3IwpRx/8uloYaUre5FNg81WGfERqXQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2ILxeAESzk3qqpDT55IYLF8Sp15PML9jxAm5HL/RDQ=;
 b=lfaK69nyuFbkovqjqlvx75eUkeyRif4B2rwIyfSlNwVRWPixgTjOS/UdBmNoSejuggLURSkoVFl8pBPwpvSE7zVFmBgPlveAwKMCXOZWmJ7aHgQQs252+Tlw5rH14CPJc6BDHA89VBG7cI0utA4whct+nMftEkhXR3lSKnoJj18=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB7990.namprd04.prod.outlook.com (2603:10b6:8:9::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.9; Fri, 27 Nov 2026 11:01:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 11:01:30 +0000
Message-ID: <14601324-079c-4e79-81d1-1d0a59d8bd6f@wdc.com>
Date: Fri, 27 Nov 2026 12:01:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs: zoned: finish raid stripe tree zones once all
 data is written
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
 linux-kernel@vger.kernel.org
References: <20261122034826.2333981-1-mc@raidlab.org>
 <20261122034826.2333981-3-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261122034826.2333981-3-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0016.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB7990:EE_
X-MS-Office365-Filtering-Correlation-Id: 838efcb7-ea57-402e-5a28-08df4c75cabb
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|19092799006|10070799003|18002099003|22082099003|10067099003|261026140227099003|261028144727099003|261021135927099003|261022105027099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
 6mSFzQylmKIBRLiIjZRYFYc7la2V0id5KmvgsP5mMeRZc7h220fg1ECuMKlKgbZpM3siL/21fv5sPYOk1D908HFCEz8/u6yaq3EVdM7ObVBcz1XfA2Wjm5QrR4m3ymKVt81eC9hKk2RzPT2iSCHsxzSImPNBDy0zE1HXIat0kThddFwo/2wNjeWQjXqE4upoCow+DEZh4cIBqSaSR+9daqHbLhKzaCga2zRs3yQfDbpgNMHZiz7T1BU13hTFqPe1FrajRWdX/xrseQuH1ePZAfTNLShvmYZIM7kj5jsrDJuVMhEWO5YwoMosENm739RfUFuTdLcffCuK/V5wgFdSFO4wiCyC0Fw88kq0cdv4Qyrce/7zps5qDeSIsF0NDkU7sEHtSmktuZnKNAbU7XoEbzXPacbBjHhIffFKz5GyEJyRsMP8EnHTPnPDnkM4wGvkCJbW1HVaTVTxee43HUJpcg/p8+DuzZ/CFjPn7IB71FlBxYfANp7M7kAKLNZcT9xuHvJMMk46Nunq88eBj6akaH91Xc8+rD6Hg9ILy6e0BejKk9eU+lXGvSTok7BMbzfsqLlGiuMkVW2o872Lq+kDs/ep6120eLk622deH5imqDoava8hIreYZEgVEJa0lbAbzW/QmK4z8aMuhl5ID1QapmomxzEJjEJOE10HmbnY4Yk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(19092799006)(10070799003)(18002099003)(22082099003)(10067099003)(261026140227099003)(261028144727099003)(261021135927099003)(261022105027099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZkxydStwcktRckFVMm8vdTRzbkRKaFI1aEpGaThhMGduQUpLVXl2dzVhY1hn?=
 =?utf-8?B?NFVkVFY3Ulowc1B1RFR2UmZTS3p3RnY0SlpJKzFEcHljVFRhTDdaRmR0akpu?=
 =?utf-8?B?dWc0THhIR2c2L2R2TEluaWM1WXZkL1kwVjEzMmVLSFNCRU9xRXVhSkVyZERR?=
 =?utf-8?B?MVpjb0J4cWU2c2NQYmRFbHhXcDRnVXhlZTg3YWowWWZzMysreTB2NHBZdUpF?=
 =?utf-8?B?V1B3QVBQSXcwYkFKd3BqeWErdzlhRUw0V1FGcWhJM0pmVWYzSnNrUmRlOC85?=
 =?utf-8?B?ZlBRaUJNYnRBY2ErQm1UclNXL0crdDMrNXROY29JZEVodEx5RzE0Z21WWkZK?=
 =?utf-8?B?ZGJmWVp5bkxXUjI0Q2xzYlBzY0YwWlBLN24ydGJ1azU2dFB4enJ0RHdGQmhJ?=
 =?utf-8?B?dmJRa0w1T2lLR0VVMmoxRjlkMjBkS08rMjUyUlNhSTBTVEdqQVVPS2hvdnZO?=
 =?utf-8?B?UXhIcEllOEVZOTdwWXB3U2tUbmtMbUZyY3ArRVRLWkdzNThkK3VvU2VNdWlN?=
 =?utf-8?B?WTJyRjNoWDc1WE5Md01OczEvaGtYNFNEY0VPNmNZZEl1VWl1cHBzWWtTMjBp?=
 =?utf-8?B?NlBBZG8rZTdQU2xzMWk2ZVdOOHhaY015YXZyMVlhOUg3VDB6dWhUT1hRQklN?=
 =?utf-8?B?ZGlyMUhvVVJYZmJlWVMxNXZLQThBc01CZWQ1elVOd21xNSsvdjFrdG9lQzF4?=
 =?utf-8?B?Vk0xblhaa2hjVVU3ZWxOc0pRMWlCN2pIV1kySXRNU01VV1hmZWZHVGsyMzVQ?=
 =?utf-8?B?V3RHQ1RaK2JwNmRCMDVHWElNQUlmZGprc0M5UGhXTStjNHpHK0ZGSllrRlFP?=
 =?utf-8?B?cE9YTXVONzhleE1IZVIwQklNS1VqMzVCUUhrcHlEaEEwbHdJRkZseitTQ0ty?=
 =?utf-8?B?bloweEhLYzBnNFBDeDhWWGwvbzdxZWNuOE1qVFFoVmJ4N1RrVkpDQmxnRE5O?=
 =?utf-8?B?S3B4aEtvd042MWYrN29MODRuMTJOT1ZPNk02bkVxQ2p2Mm9oNWpmU0F6RjRm?=
 =?utf-8?B?VE0zOVlqUFFVdVV5Qjg4OEpNNXMvSHdDL1c3VEoxQ0ZNdldyeUdkbE1KK0NC?=
 =?utf-8?B?SXJCQWVXMEwvWnUzS2lSbzZTKzlMRXp3T0VMbVUxMnR6TEI2cU5UYVhQL0dw?=
 =?utf-8?B?a1NGOHRMaTRhbUxmUVVxVS9QczNGYmNXR0x4V3VZZ1AxTi95UXNJL3FqYmd0?=
 =?utf-8?B?K2NnZFJwSjZyZEprSUp2RHNEV3FLZHE5YndEN1NOc3VHdWUzOXJmcG5lbE5L?=
 =?utf-8?B?NDhiYkFYc2tIdUgrYnpPbE5LRGxXNlZOdlBaNWhEZWN3K1liZWNiMDVzcysy?=
 =?utf-8?B?OW50SFVJQVZ0bCs0OVBNSGpoNUF3R05PZW5BYldjOGN5SnhwQ0QvZ0MxZDJa?=
 =?utf-8?B?MWhKR3lTbHNNVGdmb0VFQzNWcndKeTRHM2JmbExBdGM0QS9VWExoWjFVanNQ?=
 =?utf-8?B?YnYvTTFON3B4YTZ4QjVrK1pqLy9kNlB2SFVkU2UvcHRVSmJTUmRHcklWUS9r?=
 =?utf-8?B?SzlYNEtLVzV3M3VSWlhraWl6cXNGVitjYXdYb1hpelhWK0hlQTZrUnRCV1Nm?=
 =?utf-8?B?RkcraUQ0N204eUU3aGoxdEpTc1U0UzA0bVdHZzVPbkJQK0E2OUJRMG9tR1li?=
 =?utf-8?B?NTFOZEU4Qk5pdlFvY01lM0t2UlBoV0E0aHRCZnR3T0h5VXJ0bTVaUFgxdUxw?=
 =?utf-8?B?ODh6aENPOGZvc00vWEY5TWJmbWZkZ21mWUVUN1dNWmFMQVR5TWVLTE1FYW9O?=
 =?utf-8?B?UHl5YVR4MkdRenlPaUN1WkRaQVJOeFNlSEVxbTdPMUQ3OEI4UmttSnhmcllx?=
 =?utf-8?B?ZmZVbmw1NUx0MXFmTEhVUU03SCsvSU5yYUpOVms0SUg0anYwTXA2aU81dHZr?=
 =?utf-8?B?ajFQM2N3U3NNaS9jalFEcGZtcjNPcHRRWEZDMTd3THdWNnc5WWg4T3VPK3hY?=
 =?utf-8?B?QWhLMHVkNVp2N2h5VFRhMHRDcGdtekt4VVRuSWRINTdHQ1E0aU1XN0ZqMTFR?=
 =?utf-8?B?R21BaVR3aS9QbVgyZTYwNUlRT2NES0tsWVZJRmRvUkNqaDFUL3FvZFVIbGd2?=
 =?utf-8?B?eGhxSThoWWU2dXFXMU03WStqVjFvbkJldTNhUEgvSXdHQVdrcGREN2FZZldo?=
 =?utf-8?B?WUIvdHhFSnhjVWRyejRUT2VDRVB3Qll4SFdqYU9IOGVCV2RaR0hqUmpYNVpq?=
 =?utf-8?B?Rmp1bXlZVWFlS1cwQ3h3b0NIaHBrTmplbk0xa2lsc00rQ0QvZnVmdWdJVmR0?=
 =?utf-8?B?ZkpIcHdSUDhMcWs1V1FqTS9SaElBU2YxdE1NdzYzZ0VkWUpyUHNkTFFhNEli?=
 =?utf-8?B?VXFGWVZXWkd4M3FwMk45dm5RSEo5SXQ2c3VzMFl5L3J6ZVJTbHRoV1M5am41?=
 =?utf-8?Q?rMFEhJdWV66M2IQibIzcqayPDZb119Tebri6pDmGweJ6e?=
X-MS-Exchange-AntiSpam-MessageData-1: GN7OpJ/S7d5Hlw6siecfyFPguj/uelqIDRo=
X-Exchange-RoutingPolicyChecked:
	gutO4oyRUtIm6vyEHu3SNGktVPsRlmEq6iMp388ZsyP8cK/Id24MKEulUWEGveLc3nitql6Wv3cXIjs4axazAlwo8qYaE/G9JIFUsLkORmGA3yZAbxQou701eDNTH1pVmFhH4Hl2N33zlqF8612M4/mO0TfsGE9AhxWWdLDAaYLW2wdxhBoIrROZ2BAVgHoZkHdjqXffyPVPrSzpWbgQsDwDuFFpuZ/cbCe4Qv0XnZwqQ7ldQSHKR0NPNidbrMMWrTqW65OLubfLeG0/7xz3OoySMi9U6gEYaMe03ptkxL7Tm09uajOD9vDQkBK0doSDFhaZSiS6t0LlHIP/tRb6UQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	noz2Gw1GYClxAsnY+E+Z3ai8PNSMOBbxCbB64KSFOAu+SjC7jYCS1b9X5mK5BoiyF31N440AFJ+5t1gUI8E9GAkzYzQW4gceYI/n64p00Zzg+ZPALRBWrhl8uNJLJo6XWoJx32Gf8SDfwgp1PTUf+hFQdk30coKmHLV4JIIMS56ywuzlTg23j4P1USCSHYiQKZVG1210wXMtrdmy1YMspJfjtGCTXllYpxzw4ICR8NW2jf2ox/7qGpXO0EycU5rX3r0spGV5nMopieMULc7DtRGY+mjR5V8iHX7oNmn/yQEjTwXsGJhMztzc48Bs2Vm9St191+1fA60OezDirzXEyyuDZAyIrZT1a/BC7nlAzRSLid0HvbDlmGyqVq2zYvR6xRw2ka+ySf/dtzFI6FWpFLX4fJvd48QLYCyKQO/v5Uv4bFc8lBgYyu15O0E8qoLqHyAJDk7HlpgPEEILACv4jxVuhVRrbfXQzyI5YLwXzsoGR0CI5lh9wzxyRAD1ibo878mW6bsPQ6MA/PDXyHVJrkM3PfH1rEaaIMyL98TYPL1kwvykWJ1UENDZo074US1uzIW6Edhp1cpn3gs0dbDf5g8WmP0PNUNTtrPMXha3wh7p6WeRrB1IWd6GHoP21I8G
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838efcb7-ea57-402e-5a28-08df4c75cabb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 11:01:30.7060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xAooKMmM7H8nf/i8+C8Wts6iB2101AAf2IMyyqE41/A3hP+IwxyHufvkTCEZ89+TQayTXvbm8h2tqgaygK29cu3+kRj1UHBhgO79pgLFLLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7990

On 11/22/26 4:48 AM, Miroslav Cimerman wrote:
> @@ -266,6 +266,12 @@ struct btrfs_block_group {
>   	u64 alloc_offset;
>   	u64 zone_unusable;
>   	u64 zone_capacity;
> +	/*
> +	 * Bytes of allocated data whose write has completed. Only used for
> +	 * data block groups with the raid stripe tree on a zoned filesystem.
> +	 * Protected by the spinlock 'lock'.
> +	 */
> +	u64 zone_written;

Not a huge fan of another field in btrfs_block_group for a niche case. 
Can we solve it differently?

Otherwise looks good.


