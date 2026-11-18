Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794985862;
	b=QSkvmoek5eYVuLVxBWYgHrvdn7gUqvIAsv/8vqHesQ6UhdM1CMZIsWV25hdIm1NEocXE
	 1Mbxc1SQpQVsUfpE3txWR+MmjiEe2nbtQGiNIz/5EAqH4g5Tnk5x+R+nuF/G/YpuDNtC+
	 beb0YK7I/D4WoSDHN1lfcaS3rXwlH3biNSJVO7TO4Wm6IntyyeTRnhiFb7NqFaCLNJK1v
	 D1/W2ER6DaNKChYdfK+x1/tv5eI05LLrg9gWIKCnd6H6Xhp0xvF23oL+nXe6K+X3Hbf7p
	 kFb3mAes4CIudJFtDqx5ysPU7j9yrmDPG/FTfgrNR50NtkozzdQD8kccyh3HFJmWRHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794985862;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
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
	b=tyvf6ejN1z7YcfNwJVVUpRpmDJM376R7/SezE6+tSV++T9BSQX4D9KA1ZEy7zVgGES0H
	 rmf2MCdln5KcE8JFR9dv5rCvExWgqR/kzooAmHUXZ59rzUHVrStQZJYpBsNbW6KhQxh6J
	 KSdQzayM8EzRuGvIKP6zgFlVBN1NisSs983a5TUVjj+G4Gc778h65imyWywVHOcQyYnLn
	 axtb4JIPT+E997PQT5j8H92vkvde2Co4pfTxbrhvcd9XptZtTkLna6NneEdyfy3QjGNgN
	 lp1nRtKo+tiySCol4cH98qpT32cEwzH8h1r3s6LHv8vtbyHEgPtIrg8T44ootUSVUrg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=gjIzy4dC;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MIuuKvg6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727EA606A31C;
	Wed, 18 Nov 2026 07:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 727EA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=gjIzy4dC;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MIuuKvg6
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794985861; x=1826521861;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=gjIzy4dCVnBj9tn1J1ciRC8hl7EP0r2gSGqUYHL1L1m7ZE0J1aZOR/7h
   UzH8zlkAX+Sp7Auc0HbsbOejUqdVQNlkCrDZ2cGj6xWNh66B0lZlfV8cS
   ihn2H2SKW6IScybWBo7XMrTdl4KT2/qapGeXC1FTYoL6jm10a4hW89Gg9
   nV8gEkoI49vJ847N4y/E1ttyIS28ysicNDfCCAIVb+4cCkDNAiM5lUe0l
   QdJHRtMnxC4OelKfF+Qr86zw3EIzK76Xd72kl9WqfvBB4FhS360WhGtAC
   0KqB+BjGQVFvy23UhLSbdDCw9RfkLFOOvLCL9DtI5npXs9iT4FhcO6YVq
   w==;
X-CSE-ConnectionGUID: S6/iALJXSlG6aths9cVaqA==
X-CSE-MsgGUID: wjLxLryUQHGZUs2m9Rc5Qg==
X-IronPort-AV: E=Sophos;i="6.27,219,1786982400"; 
   d="scan'208";a="161170927"
Received: from mail-southcentralusazon11011009.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 15:11:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xtwnb/VHOi+aKNFB2tuDF87N9MILmIo2xkygTz3C8sPyRNFPzTYWTRJNFC27W4Bjykbpx+3WBUD3lWuezr4W9il6z3g1cl5J6pvg8BhjgRy9pji1rznfqqVA3/eNTb+554SnF7chdq9p6JZEgsLZRRIDGiLmzeDB/rAEJ/cmZZRZ/V5xop2Fo2+92ifH4sJ6m/eRIRVDx3jodtYuozLMzyk9X8ZcgM6veiC5zuIWJcBW0PKcceEcxYicCjB0BS7DtWDMnWWtnUFc4yZNh0XZYwEjsi8byDFnmssbCOhan01XvZu6o6XavpykBMZpoCex5NlBvGCQNVPc98f0PF3blw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=maO5stBECZZem1LkzAsd6eozYf2z0mflB8mTjlmpnyWZ++mECoQATAEC0WdKwX0jalZWJfWTDw2RB4cH2keSLuki1mQHI313arG/bwCo+0lsyAbVvZF8Uo7IjGbN8KMuNtKAX4BCZcSrXFPvi0fNSA/v3+VTd2eQETqYDxqdz3rPAzhnDXWlOerutpPcyv8SZVMQdvxGLC3CCKuHjScb02x+Gse5dtW7kjODtX04fg5CraTOfq3MmPywLJNBvvCjhr1hQ5JPugr5htS4pTIczV3zlBUQcJ6ymWofH6C+BotF9eNqmWkmfbH+4P52F+u+RSUrYNWRe/08LW/UUoFKGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=MIuuKvg60ICJRBdmHQw3SQCKr9LEKT7bguEmU16+4e3wttBdpb5wk8SLRmqhWN9R5ZZSTyQCCVbsVkVyA/adPSY4RcQBJ10ucXuXJyD88zPsh1KNBrjABAqEp1DxmLNjD0xf9ldFYA6hkxSb2+nmqTCE5CTOpn11lJRgEG+tq+Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SAWPR04MB993581.namprd04.prod.outlook.com (2603:10b6:806:561::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 07:10:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 07:10:59 +0000
Message-ID: <d3b2473c-d292-425d-8745-0d4142c95c90@wdc.com>
Date: Wed, 18 Nov 2026 08:10:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: skip missing devices when releasing active
 zone reservations
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, linux-kernel@vger.kernel.org
References: <20261117235557.187781-1-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261117235557.187781-1-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0310.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SAWPR04MB993581:EE_
X-MS-Office365-Filtering-Correlation-Id: a513a6d2-06b6-43f8-17ee-08df454318d7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10070799003|19092799006|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f4sq14tU5hIw6E3Ay4PWFU7e9GIqgQDsgJ3W0XqKs68Tpnk206qKCav9iUhb2cY4b3DHgFbwCYVfxsXJN+NV8lJ4fGIOsvm2Q4ogYvQ5NDwJ/RYTELwHTTjZQMtTiB/57uCZoS+GuWnVJg29dVrcyOklqCCalWRIJUqcT1aK7iBfH6VTxwkbH+zeSnyRWt8f+xd8OZpVyg5pj0RRrBWEW6RcytDi09maS1ZSo3cQNz4S6cNSfWGAQzj193gZBn4k9bOV6yQQGE3H1sy6qINXtat83rTMBnwsujAEVFm1rd84GmX4V8Wp3ulFWiq1xjSGMwgHSYs4d5VRYuOD8XGPK8LHAZD6BJhaDQj3DS8qCsmYYaB9f225Jbqun59w2MhsoqKt4ooHfjfplJYjzKonY7io2Keg07/gbSN3VbX6+PJlxVM0FQwrMqLWjUfv2V1IALGSTsrnYy2bUcdhgnW3cB3HCKfdDX6y6FCcd4lz5T+hYftJSaW+dNY04I5XwNok04OLtbuU+oIhc7l/o0RGELpoZRl843kHrxRAak0m0IjVeU2ltCjUfHZd1B8rq/2GeOvOAO61xIwuoUL3+topV2Ja88NkEQk/9prDIX2s0QPWZe2OCDQWN4qzQO7mZUD+2toikGnbt6c4qcclAQ2P5Vu4KyeEVARVQKsewBuqDCE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10070799003)(19092799006)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejFiMm9tdVh0Q0xQMEdRNnk1MkZDRTU5TWFYQ2pCVFFtSUpNVVlnUG5LZzM1?=
 =?utf-8?B?YUpON0xlY2Z1bkZMNVIvYmVkZ3h3OHBEMTFkQ0VmQTlDdGRieDdabHZCNHlM?=
 =?utf-8?B?bktCSHNrMHNpWTArTFVhSXA3ajV5aTFVVFluZEcvV1cvalVhbDE2SVBGTzVL?=
 =?utf-8?B?WTR2bWYxWlZydW5OMXVBN01JRjRqMDRDemU2aVZPbFBTWTEyVEp0c3hsYWdL?=
 =?utf-8?B?eGtaWUkyVUJBV0RFV0JTVmhQaXdCS29IOUxBd3VUcFlYSGhjaFZzMEFFS2wy?=
 =?utf-8?B?a2ZiRTB6bDRHY3R0Z2tWTDExalpxVmtTbktaYTVzeVVBV2tPQzU3eW15dUlh?=
 =?utf-8?B?VVVLSUNMM3BUc2FzUXh0NlZPc1lWaWprVVAyZjJwQ0NPa1BnMW05SUxPM2F0?=
 =?utf-8?B?aDI4T1dQOSs4TFpVWkFWNlRyK0lNanpnMmJwYzEzOGlpcEJ4dmlURjUxYmNr?=
 =?utf-8?B?WTE0aW5iVnlrREYzbUQxR2VTZ1lvNUR6ZmFwVlRHVWVGYURnWG5Rb0lXQ21O?=
 =?utf-8?B?YVVMVUIrYXpuVll3amxXZmVOU3o2Z0w4QTNxc3BtVllydFpsUkRTZnJZVzhr?=
 =?utf-8?B?UkMyNzhLcXI5MkxRNUpGYTNYZllEd1BCMUFSMzJEcUJ6cGJXVHBtZzFJUmUr?=
 =?utf-8?B?TWpCNXBva0lLNGlUeHNmNUVTdUdmODUzblpzNXdlWlFyZlRjNmhxRnZ1aG5s?=
 =?utf-8?B?Mzk1Tjl4Mkg5VU5IazM3Z3EvZUg4QWtUQ3VQSFc0dFM5dHJjZ0lmS08yczRN?=
 =?utf-8?B?NS9PWmJHUmxWTElkQ2NWb0NsOWhDT3JDSTNDZG5zUFA2eEV0NVFQYlIyUVFS?=
 =?utf-8?B?OVNGT1gyc1RuSXNpTGJrYjVGMWtBUExRTlNQb0ZOVk1YSzVBUm1zNjRQYWJq?=
 =?utf-8?B?RVdxMStVT1RjUlJYZlJYTFl4eXRKVHJJMkUxcDBPeW5wN2d3TlAyU0RxcGRs?=
 =?utf-8?B?MTd6bWMzQU0zRlY2L051Ync1Z3Y0dU02QTRpK2owV3J2RTRJTHFCc3hNRml2?=
 =?utf-8?B?QkQxREc3bTRQbHVOdDhoZ3hnc1FvNFBrVmgvdDJZczl5OUdDMnBjamxTUStV?=
 =?utf-8?B?UXdxb0pyTXMvaEVNa3lKTHdsL1hJQjBjMjE5OEN0U0FDVVI0QXo4eVdtUlpi?=
 =?utf-8?B?SkRQclJaeTN0N0xST3NXL3FmS01wMVl2cjZwNTZ4M3hXK0xIMDhEeVp4ZFp5?=
 =?utf-8?B?Q0d5VkZ5UlpEYStvZ1d5SDhEOHlWTmwwekdSUUVyaFZhWGhxamJVSXN3eXhi?=
 =?utf-8?B?c0lYOHBWenFuZGQzTVNKMXR1S3BxS1QxRzNXS1BCS1p4SUI0MVlHeUtNekh4?=
 =?utf-8?B?YUtsZDlDZG5qVFZncFE3M3Jnd0lTTDgwc01kNUdnVVpDeUNHbTg3SkxMTUVj?=
 =?utf-8?B?NEp1OU1GWmZsQWpjNm5nbnZaak1ySGZ0VTMrRkRpeGhzV3FkN2hObmVtYWV1?=
 =?utf-8?B?TEljN2UxZUNUWmFDSEFhTkZML014dWY1M3NDV1ozdTNqRGNNSEhDQy9DSlhQ?=
 =?utf-8?B?SzdLcTZRRFB3REI2MnhGMGpFeEtPZUtES2I4WlZaYzAzTWFlSjNNL3NRWXdB?=
 =?utf-8?B?cXU0MFhPZWs4SVR2TVZKdGIvOWw5di9kZkNEVEhtUVc0T3hTcVVzL0o1L0ww?=
 =?utf-8?B?dTNLM2dXMW1xWHVqNCtYZkwrZGYxdHhhS0VzL3RzRDIxdEhLSVZiNW9ONW9P?=
 =?utf-8?B?akdYbEc4djVVMjR1aFFrbzZBTHBxR3B4K2FQTTV2SktscGIxZ0ROcDBiWDZF?=
 =?utf-8?B?ZmtpYnp4Q2xseG4yN1ZtcmFyV1dGRXNNbUJsaERHMHNDQzA0Y2g5S2dRcldr?=
 =?utf-8?B?OW5JZnJJOU5mZU14MUQxVmJNQjlDL0hHeWplOVhkd3F2TENjWm5pTm1ZMmJ3?=
 =?utf-8?B?WitaMFg4cDdvNXNYRmVtNXVQZ3lka25VUHluOEh6OWYwWGZROTBrK281VEhK?=
 =?utf-8?B?ci9vNkNDYk1ZekxVaE1HWE9OMXRkYnBsVmZtVURwekx0MnkwWGJDc0dvekk1?=
 =?utf-8?B?S3lieTBMKzU2ZWNpNXU1eVI2TTViNnFQQlYyWFA0dlRrQ3UrNEx5NlkzNGNQ?=
 =?utf-8?B?VS9OSjlKY29IcDFBRHRKQjBEd2xrWmgzWnlBQ05kK0ZSYm50SDdNTENQS20z?=
 =?utf-8?B?NWt1VzMxS0ZZd0dGZ1Y0cTF0VFhYRWRJMGV5VlRUQ2F0eVBxM1FlMEdHZHNK?=
 =?utf-8?B?RWMrTlVNVEtPOHRScnBjUnlCak5wNWJjVnRva2lhNmZpNTV3dW82Sy95QjlK?=
 =?utf-8?B?U3R4a2hVNDFTU0JweXp4MmR4RFhDL1M1OWtEbUphbDZuWXpiNXpZVDVJVHBq?=
 =?utf-8?B?UzRRTUFSMUhmZ3lqZWNEYUVQUE9HdlhweXZqRzBkZXMrUTExY1RNelBobStw?=
 =?utf-8?Q?Wp9f6TBsrD5yKKX3dSHR/IRIMhG/l3ZQjl9FC5UAXk2Of?=
X-MS-Exchange-AntiSpam-MessageData-1: 2/plAtsMScZ46yLPNzlMsMvsh5Da7c+clpo=
X-Exchange-RoutingPolicyChecked:
	xA2wRwcrfW98YxIUEictaZo2zJrg3TEZIJ4pE6cwtyDYztOox9+/8f8zFGOiJP0c4c5ZrLBPMt/dLRpogz1jArCatP1aAEh1iQfMAy1AUrhc+1SNbQ6XwpDdvsrYWFHH85tBBYk4ZQt2CEPgVWJYvlgRAkktAw6Umhw0a3Q5/33hHaDM1j0jkSr3ZA+Zj5hmmRgx2PbTa36TTfxHe7yCnfA8R7V/s025+oGKs72kXwMBR/LVHKSSBlAczvz9tXsuwHupbOh5syJkY6NBXjm5fc8p/nCzvy8h/x6p1qMFN+qKWiCRtrxRyGCVkQkfarQsAhZ1dkYkbfbxYjOq6hciJg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iLOEMx6IbDVVbG1WHzwCbky1k8VP886wI4OjFt/LjTJNsMaxQQIWUfu+ewtXeK8fqKG0qorrP5OXeaGJSZatrgJ8Tr9KSbATRQ4KrONhtCTIsIXWYphEUnp8kMl0sA36FgCn4TkwHegIqFkE03n0o7lDGK8a1VnqkbVCp2JyTZY8gHJESuMEnGPl42czFuwGoFRATWPJ92a8qA8gXTckJayKMqUZdbpw531u7vdJUk96rJpK73/+g427FWtk7I2w8oxqs+My/FH2BJiQVDnyENLMQcKoIVTBsQR7QqG0B0Rt2fxSLd4I1SsbunScponJnRxZF7TMmMsTHMvVE8UngoA2dFpbtAWfM9ytrmEGVqyCyaapie4c6Xwgk31Bc4nIZyao6oabnSuz6RJaKFh4HEkg3E1b65qg+9uo60ol2N9iViOsXu3l88xqXrpDknDD/Yv3D0+5rSW6Lc89v42218zxp9uY7TSLGaNL46qkNZt4bssyAohsCk8TjRHOJ//REkjpFJzc6R1sT71s4iU507fN4CstmDkNjTFBrYPuMojiSOcEHTmeqV7v3yNDX674hl+eMWgXDx3/mfgFRGIvtXnjiJmUZ/xZjfPTp0yryOiFv6m1o8bWvpt/ZDOcKaO0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a513a6d2-06b6-43f8-17ee-08df454318d7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 07:10:59.4465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DiUrygGWYsGsIYxPnCxMzVOpp4EfVs6guxHJdxq9xfODFvMKsb3dqqlUVee6BPUGhB13lW6qYlW1MuD+ofXuPFQnYeVJQW2aLiOCqXjXFig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR04MB993581

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

