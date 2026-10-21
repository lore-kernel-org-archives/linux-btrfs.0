Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792565228;
	b=4lG11t5DbE+F1hB3UL/uZnB5L5OXbHhNKY3pbF/wpQv9AsFgWz16pcWmCv3gLfhzlN+X
	 0rD5N0Vl45SPgAgjAiVN9mge3dhDnftieBfKxfyWYMLNepg9Q7u41+ttqFezuveeCWZqO
	 ky9VVq0zKWSrHkbykWWU6mimq7lF2dogc8miow3VMBpJCmaFOeInQCwoV3XVtmjLZMA9p
	 zTc76a/A8L0/P52oJlFYbg/pQ8f3qdTOop6DcF1TdIHYBxRfErS5hQKy4UT7fiqL025qf
	 xwJALNwTspsSO9U/3mODTHZd5LcU+W2CjAB0DDifRW1nsLEyXyaOyGu2ctIFWFmC4QA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792565228;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
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
	bh=oU/2BUqSkVI/LKiagXLUGGYsKlsBdmB7H4FBU38Elxk=;
	b=XHnxICaEa5FmzFD21WuXJKSPnBc89wFs8jwKe6EFD1c9jE8r7c2213hNuaVYH21qk+E7
	 iiFMZwXJu/yD2V+0q2PF5uCwpiDLoS1Md2io8l3UeyF8EPYZUsAFrNqURGWqRxPzalY3K
	 KHEldcWheAcsD9XoxBcTpd3Vvrn6yIcH4kSPOequVqoOtCWfj9xCShnQGG2GQvWSNUnTy
	 gugOIQTWxv8W5mcE64GAALpQZFRdrGUOelB9RNEMKbWuM89d0AvSl25P9Hxn3K4hGuz9m
	 1wUsaGJg4bJrNaYN3MsSRr7//B+G0a5ujLwWs1DdAx1XJTDhuHPOAgEJ69zJF0oavUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=hdrfYP3G;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hjLCb1kL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E1E606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 06:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82E1E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=hdrfYP3G;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hjLCb1kL
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792565227; x=1824101227;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=oU/2BUqSkVI/LKiagXLUGGYsKlsBdmB7H4FBU38Elxk=;
  b=hdrfYP3GQ/7oWuVCnK/5fL1wlJF/xrjZQ738yV74q5xyPBZhsOXlgU9u
   HUDun/dRQBuEWnDcgw6a3Mx8CeAnXyhdfvuDlGNlac0UzglyHqbD+Gj3C
   PXThi775ILG3cGsogwQpiOuvHT85RSn2xBw7+RWVEtdvkv9+jxdN8oe8a
   TvMdQ21jy5bJtnO8oXtHj0EFmt3nVWjX1/U89EaSb6CwSRDd2jpAa3nVT
   mLl8Yb3KPPMiYWQtIZ8jp9L1xyO0b/+DMpAPBJXR1fb7bPVL50MoHzO7P
   Gyu5tKyuS52aqwkeSPgBpc6vBG5yiq7ZaOOL5MmmzpY6zZaXz+uvtnUaq
   Q==;
X-CSE-ConnectionGUID: Nr0KLRIhTmqqVFqLQMJk7w==
X-CSE-MsgGUID: lm6qvvMKQS+2DU/RtAzIcg==
X-IronPort-AV: E=Sophos;i="6.27,169,1786982400"; 
   d="scan'208";a="157010244"
Received: from mail-southcentralusazon11013054.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 14:47:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbW1v8MssZb5Q60+wVXqWdrFlKpbe/vbex3AlM8HeW53J2tRa45KM1+pOpRgLq1taXwQBzBMlJhR0ZHcVrHCbIGKtowxvOSmvS0LHWU3DJdHJ2ltmM4pU7pP/PbEPmhbtlHV44yDaO+eK6PJX2zTyMv96ycX6UWe17nve5t+eFZDyK/KkCnRglDbyFZLFjXX2XFsFjwhAE4P41KGoANbhtXoMI4oyS5oRR7UUGBPvnPKvltD6V4qTYAbAjvtOiRMoWzjc2lOB4aXRGScKe6CzR/x0Ey/TP0Cfzc4Z/Mtc7Zd32BKt956rDbfIHzWqnjWSmpLyTAOQ7bxAjhaHrLBJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oU/2BUqSkVI/LKiagXLUGGYsKlsBdmB7H4FBU38Elxk=;
 b=P9VTNkAAYp/OZYvcSRPTAgOa+DeffDfzb1eEvo5IKqAtu1nC7myhtpnqN+5tnhNaVgkvZ1khOOyvl0UheEwVTIQRXr5MiMh5QFOm8haq4PDhQ2Dm4hsxlAtIu+AwzumKQR8+5kcrX6OuknmetyPPNgDLKBwgUoYRExfZE2n1b1D0KY8aTgnWnVwNjPm/oGI1CuWM1IH6Q8iDzLF3rmGnw8bExOUnbH67V8nY2uByhsNsdiTYZJjAS5PUWOvJFhjq9yp6L4vkS1bR99ysjwZK5ys/MweGpBc/ydr9EAY1lymURJE42NnjgU0yoZp/5LJ6nFeJBFL8MJmKUHjkACtP2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oU/2BUqSkVI/LKiagXLUGGYsKlsBdmB7H4FBU38Elxk=;
 b=hjLCb1kLT5WSrXHPzKdUMwTujk0rjmFCvgLJerdcehaIVCYa+ICQ4EmzMcIso6YdTbeg1Wo8JK4EW7L6sZRMru2UAQAdxHd4sKlwGlUr5VQAYz6i1waxNlGnjnsENzqU++X0MYJiVyEjh26onFtnnFqm7LP9xR21A6Tqzg2tmVA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7484.namprd04.prod.outlook.com (2603:10b6:806:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 06:46:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 06:46:59 +0000
Message-ID: <27e69422-562e-4e8b-acae-4491b49ec853@wdc.com>
Date: Wed, 21 Oct 2026 08:46:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] btrfs: convert raid56.c to use
 rbio->bioc->stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792553748.git.wqu@suse.com>
 <2a2d16946dacfde963cf6c2d58e8af03ca7006f1.1792553748.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <2a2d16946dacfde963cf6c2d58e8af03ca7006f1.1792553748.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7484:EE_
X-MS-Office365-Filtering-Correlation-Id: efd2f0ff-dd52-4282-82dd-08df2f3f1adc
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|19092799006|23010399003|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 aUGuNj39jCHJFkKP3y3q6xL/mIDLuu4hW7+s9EhOLv1o5HCFfAHXhYL+jtEiaDC222QWwavuVmX/AdWF/26Isj7yxDPg3ZbFpv7EQoYiE1b8wyUqERsfzwLhyq3nslG1P3kGHLDw6X0IsHn24YCtSNH+0S+j0Pk07KC6jsMh14ahP02owoiGe34+/gNzLZy//jHos1s92jFy4PgTJEF2U4kU+1ddovqLBhD9saBfd/3YHU6a755SF+Q+LZodZglQTAYnbVkL/EBMHDVofypXBWNzMoBIK7z76Cv4RxNuTURZWG8SGcrXqiWgLYKzJB6kPEetbs1Y62nAaWWP81DvdEAmhAF51NHCYkuwZqGM5G+Nfc9gl3a/WXM6Ha2rgI4KVgM7EcSQ2c3nuWx7tgkpMDFZertg5VSgzF0/CDp3ehXLZmMUCtrb/+i1xaWOgHOTNfu6hDpYrRpvaRLpoDmOV/n4JkmnMgiCi0guHXJsy6gQaqdVdRIhMXKDgIcex0fZDT8j5SRWw2MLudWKKivQRsplUVwciwl/0AY+dUdT9s2fOlz/mT5w4t7jxfmiMkJAWVXziB+gcZQWQEk6zbPJeNWO0NoBNGu3WDtoKLVlHZ9nlMlEJwlPf8aYxJn85b2mfP/mhs6ZaA1CVWimpZTSM9xlOvw+xA+IKatm2GUgC7A=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(19092799006)(23010399003)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?azc3V0FabVRpTHF4amVCN0VBTVUvUTAxVjdNMDFqL3lGQlN0aFlpblN0Vzk4?=
 =?utf-8?B?dmIrRnJ3RmVzNXhCY2ZucW8xRENGb1BqM1M4TGM3dHp6NTljWFRiNGhDMkhE?=
 =?utf-8?B?NS9rZ24rVXU2bEl4MXQ1NFlsL1JNWVpmaVdVSS90VjR1OUhxdmJjSTBOdWRB?=
 =?utf-8?B?b3dHWmk4S1RadXdaQldKc0JWa093dTZUNUM5djYxaUVLSjQwQlJSWTB3WmR0?=
 =?utf-8?B?NGVDMlE5dHljakZSK2xaWkJWMmNjM2lIa2FBcGNUMHFvMDVkTWxJaDRxYkkv?=
 =?utf-8?B?a0NtU0pDUlpQMlNzeC9JakxSM2FtNWtpZFAxU2huenBjbm5wVWVXSng1d0dw?=
 =?utf-8?B?dFdXK0lkdzZRM3FEM2kxY2hCMXhWVjFBb1JhTTF3Ylh1a1dYQmREU1VmcnBy?=
 =?utf-8?B?LzNWTCt5bzFJVURLZUNYSVU4cXBHZWtheUI3QVFZY3BodjQ0d3lkdWd6WTRY?=
 =?utf-8?B?RUp6YTU0WUQwOUpIY0dqaUNRVzBMZ0VpL09LRHlJTk0rYkYxVDAzV2xvMlJV?=
 =?utf-8?B?QnpVeHVIK1FaZGVUSTg5OGlnOVhXdHNhZTJqN1N3NlZPTjdYdVlJTC9aaWxt?=
 =?utf-8?B?LzVCTXBWeERvZDFGNW93NjJ2S1hHV0pKN1Jwb05MeW0xekZDeUVGemZRaDd1?=
 =?utf-8?B?S2gza05xbEtEL3ExS2hWbStqTE9sRWJmLzkzTVNLdjROa21yUlZCeVZ3NUg0?=
 =?utf-8?B?UmljVjYrOWpkVWNKQWtQWWNZUUN2RE00d3RRd3ZVc1F6TVN4a25nRGU4QUJp?=
 =?utf-8?B?WkN2WnM2MGJvbDBOVjRVdFVJT0EvZXdaVXQ4cUNlQnpkRG81Q0paQ3ZFZGVG?=
 =?utf-8?B?QTJPRStCbFNFWUdrUjFxS0FKekc2ZmEzQjc4eGI2alFWaTZHU3ppK0Njalg3?=
 =?utf-8?B?eWlQbXFzeVRjY1drbTlQUHlISk1aQ0pPbHlnZWNZL0xlci9RU09vUEZ3RGlG?=
 =?utf-8?B?TStxdWkvNFcwRWg5LzJuYkFjZ2c2SjR2WkFzMjBEbks1MzBwMjkyZFpWK3Qw?=
 =?utf-8?B?RkhyK2dhSXA4K2lnNGppQWxRSDNROWhsSVdmWGdaOStJZzcwaWxNanNXOWUv?=
 =?utf-8?B?eTdxK0dMbElVc00zQzhsd0hZWkVKOGF2WWROWW4xNFk2VHJpSGZUdWR3NDNT?=
 =?utf-8?B?MWJzQndYeUJ0enNFTWtzK091OUJsUTRvMW5Wd0lvK0NBU2dnZWhUTVJ5dG94?=
 =?utf-8?B?L2hZcHB6M0RoL01TRDRTbUQwOGdHN1g3UzJEUWlPQTlKV3dEekFEc0U4ZC9N?=
 =?utf-8?B?TEVZNjVoeUZvSncya1h1cnd3YlZoZGJXK0dJM1dlZjZjRXJDT0JBVW9MRUVL?=
 =?utf-8?B?dFgwWEMvUnM1M21KVk4veGZUTEVncUVMd3dHa3ZBTVYzVjlRYlk1UldOWUJq?=
 =?utf-8?B?YnR3VjFwaWp2Y3BDYTVFZG4vRnNFdGRXWnR6c0crVDB5bUorQnFRWk1zelRN?=
 =?utf-8?B?UlNqTmVKZENaVWlxeDVVc2FCOGkyTTAwOHlCSE4xb1B1UStVaVJ1N1A5R0w1?=
 =?utf-8?B?bjFnMXc3WjF2Ylo1d2ZkQ3djWitLM1RUYUwxT2YwQW5NU0podVNTaWpSZERF?=
 =?utf-8?B?MWh3T0xEUzZEK29mMi9mOHJvNEp4ME1UbTZobmVnd1B5ZDJlZGQvUko4WTV4?=
 =?utf-8?B?UU14cW9IOTZEN3VrNnF4UFQwMWZVN2hXazB4bERwWVI4dW12K1BFdHR1OGlp?=
 =?utf-8?B?V3JCeDVzSGpqQzQ0LzlSbUlkVzYrMlpqa3FJdDZXMGtTZ0pua1IvTERBSDZK?=
 =?utf-8?B?RytZYjN0KzNCdWR2cGY0QWJMNUw0c0xRdjE0U1NNYUpvcUpBSGNGWkZWemg2?=
 =?utf-8?B?NWtnQjlYb2Q1cnloWmFRbTdqWWVwOWFMOGwwN21qQ2l3QTl4OUNxblJZKzF0?=
 =?utf-8?B?aEIrMC9hYXdZQjdybzJONEhoZjZ2RFhaYVlmbW1zUUZBRHFzTERGWnhIUzlu?=
 =?utf-8?B?VWJXUTllbUZWSVp5OTEyVFRWa3p5UUk1VG9vbmVXWXdldUZGMXVLMDNtQVUx?=
 =?utf-8?B?ajFJTEtkcG5HMGFUeWErYml5MDZ0YkdHdllsNmVvblB2eDhad1Z6QkFlbTFC?=
 =?utf-8?B?czh4eWZYUWp6Vk5NK21qb1h6d1BpTU9QK3ZsdUVZd1duNDJRQ0VPaU53ajJU?=
 =?utf-8?B?T05NMlR2ejdTbUt4K3JMaU95cHJkdlA2a0d2VUp0VlUvQnh2V3dUclZrVFkz?=
 =?utf-8?B?Wk9YVjBJRkV3bEtQTDQ0QkYvZFBERmVyODZVcG9FQVlNam5vcmgvb1YxdGRt?=
 =?utf-8?B?VEgxdWZqekVEZmFVYXYyZEVOS0tpSlEzMUFNRUN2T0xWVVZJa0xsV3VHMU01?=
 =?utf-8?B?M0p6WHNRM3RJU2FsS1IyQWRUYy9HdkdUNEIwTUlicXRENXVzdmY5R29Yb3pi?=
 =?utf-8?Q?X9h9VG7iPCKecK/rQSfPERBZ243p7bnDOvv5L6e0ODMzE?=
X-MS-Exchange-AntiSpam-MessageData-1: wupllQFxkwrFRVj5JumbEquS8FcTwQv/eAU=
X-Exchange-RoutingPolicyChecked:
	nsmI8ZF51AVrnaOr+EW3gozeYutOmeT8rmjZmBZox4T43z4mttM6pE1L3TwmTPpshKRQ3ialv11nNIQtQ2KX3IYAtEq7E7MjL+1p7FVBYeNPF+2k3ZXvCewU8YX5XKOdCDvyBGQtZ0t/TbFVLql8JjIRSIo5kCqA0E2jVZTl2ZbhC7LEcCJanytCxxndVRjJPEvoeZPnS06CvN012HkCjKKBAcwDjBBotZz9J4o43EfxONGTOcrI33NvU/jVedQ+MOP1VHKZ0v4BYx5PyREV2ieW/mWQeu9TDhBxplSqDaD0hXlnY0Z+AQGKZzRwhN18w632Jv1NJavXOvd/8KqkSw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	djvxJuYsJrbxfzEvxvvFAyCNNy/Pn3MlU7yQxZUyHnJ+UaLIsWyIhgSQ4FKVabMWJGMLUe/FFEmivVk/kc1lZKPmVsBGE1HWo3yKkMOXtEDx5jtwHb1+r4v6clOyq9wAK7RI/MZNcqtxHliRi7CT+FngD7ef7O528wKnClAMHN8H2tDUlZkvCbSfEBkFdhhBsysQCTi2jAtEstA2J4MYZJuOT3Xtc4uDUVqSk1Ub7l2Xe3H9H2/X8jPVwiEvotpfiMNUUwzNWQbXFdNy3N4QZPTXVERxgxJS9JZenS4bJzLAMkt+LuzML2BLx/bKxZQnO6g3WMlwVE5EuifUMcspoPmX7dh760rpKAe3Nd5kZ5mFXsAAAzelhiDUbhTg/GpyDBf4+smXEWdg3qrpsnvolhqsu+Ti1rrPPXi4GKjr1d/GiDoWMomwuFnbClRHZHOjBE8wza4zy9yChWJLZSJHUnGSxRLsBoVfshLy6N7KJh+XuMjQa4J2Nt021jLbdtZVDjc3jScYl27k5Z2BklhoNOq1RKSkDixOJiOK2FGG/ZObkYfsYrmgc/3v9g4eTcsSjqRiJtCJ65zdCdnt9O2PiYfvcwvbtl+5A4Na/BsaD1uHHGdx1soI25S8MtzFJNHK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd2f0ff-dd52-4282-82dd-08df2f3f1adc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 06:46:59.2584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t03dBz30p13nHm565MoHXze3Zh5txwP82Fu0HAufrVGSNQNPmTFz/EAcgYds9gLc/B1T//Yq0RTZn2Yqa5kOlWzaXIAwxlmxY1U2m2f1BGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7484

Looks good,
Reviewed-by: Johannes Thusmhirn <johannes.thumshirn@wdc.com>
