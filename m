Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792565265;
	b=jAsxJj7EX/L4a2QxYeKxXztxL5cFgoAGmXU74AvmRgHxVFbyDmDOcMS0kZEXduXM3fqu
	 QCPs/4DF8laKZI8bY08OydlcfbqKd154e/D8l7BlGJYJMN76V1hBfcplojXrR8gE/jE9L
	 UFpMs254w44CovdbTz/Yrp4Vasl0AouK0mRu1rDc/VGwG+5GtZGgciQkdEQKT1Zql1Yki
	 PalO5iNCu2VuoSPmEKx89ERHLA5czKT0PdkquJ+BSBRcobsoMXPc0gdG9ERlR+BLvnHyb
	 KpFsnnU9zwuFRAitUZvKI2X2qNABHcj2+7wij1ak730KsuymeExZi2GXoJteIpd/syA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792565265;
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
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	b=OYT0GonfDTu+irMS6HM7SwDC5cJMXB5A+M55bHsK6T5Jf8r7JA01RQ0gatQeT002W7sC
	 6vUAsQ2vEv20wJl9UYrzAfeAeYluONq/Td8HRT6GWSgIvJg9Y7yXUftT0AGuxp3Wrfloz
	 fXDdYxsszY0VIIYcLYzsn9DMiSsGQBtbZ7VKCswpw+wMv45RkGEcqO4kDPLZ/9PqqNr4B
	 GkllBuzeRmgi/ObklafokRlVYfphtFU+B4QIba+V82oH+lQTwyBiRA5FcvVxYtLDVBuPE
	 H9MQMAHDIVklyQqcElmcEljCJeuhOL2kuI/A9FaKiqIYfKh4jH5B/yL+MHER/zIy7GA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZXceqD+0;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hIyjsoFj;
	arc=fail smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC448606A31D
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 06:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC448606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZXceqD+0;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hIyjsoFj
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792565264; x=1824101264;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=ZXceqD+0sb56hZIVcTMazFKSpWdNPXnCySU1ndodHZqkb80OQrdiQZyX
   IknV5ih/KqvaVMgiH/UsjJrjsArAxF0RJ6Jdou7GmFFDvvuhT/+hwsJZL
   FYJ95VBWr0FiYhpdVq9jvqAqyRu6MBDMkjXZgU+ziWc1f1ybKbPRZgi2D
   LczhyYci888Yf2NgJJVq9AHR9UhqjaCOmTQVoHp0uJ6ZYrpKlsE8qr3HZ
   ysGovJGGilrLwOV5I7g8Jp/V7Jb/254SSHj79yp1Wjv9otnuCTJ6CCr5y
   BUmiY0x9KHGw+cfb3e/V6aKyeKnERg2YkWA0H2JktI1MOZOQ2XF85iqPI
   w==;
X-CSE-ConnectionGUID: mHTklqi1T8eFznRNevnTiw==
X-CSE-MsgGUID: v+UF2R/3RIOobUCKGqn9rw==
X-IronPort-AV: E=Sophos;i="6.27,169,1786982400"; 
   d="scan'208";a="154397291"
Received: from mail-eastusazon11011052.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 14:47:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KttjJSH9y77KFKhViXaNOBYNJHAVNF0rk2yFSL6PN8j9u1JHm8JAczvKRQofDJriRykeiby7Iz2S4m9dPgLY0H/T5wnlYPKqi+1DXnBFhEyGrc1YtXQyY8fkxB+p1us5ADpw1qCBBgGcPxIgoLxQXy0f+dfD3cblrEfUSH7GAkCOw+uh0ZfsyXEOnetq5wJsCsr0SsXlr1BzELDEnn92EgSu6i3Y9PwB4eMEzM3Hv0cOkp9owrRCiVSewaDlhItzJ89fqwJkPqIkJGiEdwDSuOdOKiHtk/nkCFAuKgHUSGjOhrxOsoaKA99bsW2fTy1AqW/pIQMyBctJEnWB07JpqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=otwrqRMRW3j9sTeQUvZUBKD32CRfRMfeiqTNCa6qhB6Zh2cq2ktzCssPbJjD8SuuHjP7Bu7IeIcL9px6X5Wf09a/6kybeXEvnEtIPqavDXmpqmTAfACh+MCBcY8QedcofXEddjZcCm2pa+7rl7IHRzmgqBzjGJZnAYpGP1pGkUvGUUAx8hju48BJoEEkLOPpbac9CnW3CqyMt/BHJ6Jtrtzp0i3rBofiE/FLreSrZ9rNG8mhCvL9XUPsgLHMxbLCLLZcQ9GARlsfAhpd4vSRefJr2bPMVCDOV9z+D8YwqAoFHJejElIZbZjFkKE4XqRj1VwVYE7llprHUyH7VRZVHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=hIyjsoFjFtCTMNVpHY/gOOs4jiRmvstgkDFb41/HiAhHki62d0mBKRpe4kJGA0haC3SzBkVXWF2ymz7JB5FPUKw00mQWTOYVDj46MAIuVV1Lc6zBLu9VPCwXHZCakUQZhMFBbIgV6nlkrLvvmmxYgwydIpl+oWxrhMa5vXWyrNc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7484.namprd04.prod.outlook.com (2603:10b6:806:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 06:47:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 06:47:42 +0000
Message-ID: <09f0611c-ecda-44c8-b089-42667450821d@wdc.com>
Date: Wed, 21 Oct 2026 08:47:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] btrfs: convert zoned.c to use map->stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792553748.git.wqu@suse.com>
 <1d86ab0d5458e27fca96d860d07be79ee812994d.1792553748.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <1d86ab0d5458e27fca96d860d07be79ee812994d.1792553748.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 459b45a1-559f-4842-b182-08df2f3f3459
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|19092799006|23010399003|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 gJeTb04bkNZtasor77M4dPwwjGZBGTRAO3hP2RgoxOA2uW2ZrbeEiQ/4S5UwqJqJtetOtez2YNxB8rS0+9S22zJGfOg1NWZwD9vKIfWFLA3rjzetM82kt/g/jTfotr2TMK5kRusmTzCc1yngqu9YzizzTXx1x3LBDBRJHySaM6ERzF3AGJO8x9wbmcF9GeUK6GD1tbmP9qXOodtYawtwSPToiw4ol8bUGMVm41Fm8CKqyYf9xQ0l8DWbFCpHe48GX7LsTnt/rHmsyT6HoRmgf28ShVnhgVAKHDM7N3L3Wtl5T1FrLPiEXhRpbLljv8YbQKDMHIc61Xa2V0lFJbB+SqkWcBKFy4u0Eq/xF/mmJDc244iGaN7ZIUHCP+vnSKoOz5NKv5Suhcww81gtrups8a7iRDGe49CwX9EqTFC12YZBqnchyrlYcRFA3K3WEemet8mzovUnmpWtS4vz5PEuGQC4oL62DIP0NzqyTswff01QWsTZsr0OAjZZJ3IYntZjK9KVuKpaakM1lNNt4OQsnT965dqnIVN4dfE84hJuTj07+r3SOBnaFp6JeTFi2Ygl/j7OCfVmR/UseqyM2wnGMcaiBpyRi3YhrSEYNenNWrvKXfbnRBjR4VB1EMovbJmkBWMK9wivuA2IO5v1VcB9N/TUnXUKesPf+Y4UIeZVinA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(19092799006)(23010399003)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?eDdYNHJWWlZmcTF1NUFpTEFOZ240bENCMklIbnhSbXpkVkc4ZDdlKzVJaHZQ?=
 =?utf-8?B?M0QvRFFuUDJyc04wc0Q3VllTMTZNQnkzaHRibytoeFVnUk9rWTFSWnd4enFm?=
 =?utf-8?B?T3Z1ZVFLaVF0eTRpZ1RaYVZmZmo0R0Mrc3V3Rm9sYS9GTnBrbWxnM1Z2S1hE?=
 =?utf-8?B?ZnZ2UG0wMnN1TVU4cDBveVNMQWV3MFAzTUJ4K0EvMmtDKzJNOHVwb3gzSlhR?=
 =?utf-8?B?UjVVcHVtRXZFYWwrczAvbEh4YjdxVUJ0cjA5YUN6WnVDN1B3RzN6WDUwU1Ix?=
 =?utf-8?B?Ung0UXNoSVJwNXFvOG1ma0JYVTNyZi9UVVR1bElyQ1Y2bXIwSlJ4SDdac2Rw?=
 =?utf-8?B?Yi96RkF4WG5LcDNQYlJmZnpHVHg2UmtvZ1VlTk5XQjZ2cTVPWnczMENhM0E2?=
 =?utf-8?B?bU85ZG5Xb1lRdTB0Z09HV0hBWFVoanJxVG45S0MwMHZtTFFZc2lpSzZKR3Fo?=
 =?utf-8?B?UUQ4MkFObjhTL1MzTUtIejVoRlp4S2lVRFBNa3VscXdyZjVFdEExdVpKMGMw?=
 =?utf-8?B?UnEwaEozNGlwVGtoTkQrbENJWnlEZWZmazcwczFWWERoUzFQVk9RWGplWnp2?=
 =?utf-8?B?OURUSFZ2UEtxb0s4U0h1M3k3elVlZlI4elpKbjVRT0pJYjA4Z29vUldZbDZG?=
 =?utf-8?B?dGpyRHJSeVdHMHB1SkRrZmhHQnp5bEtZYjJJQWxPSkJuL2xCc08vdWJzWVFC?=
 =?utf-8?B?VG5LTjYzNXVPWGM4LzBxNHI4R3RvVmNwNUJjUWQ1N0JCMUpOUmJYdmJvQnF4?=
 =?utf-8?B?OTNCby9xTEhQSFdLRVN2VjREdzFOVmF4K0NJVW0xWjB4SVdCTjlMTXFqcHkw?=
 =?utf-8?B?S2xhQUkwczVHbmFLMitydzlTWnJKaUhqV2MvczdhMVVPSXlLeS9ENUpMUEMv?=
 =?utf-8?B?MzlkYURNc051M09wc3dZVGZaZStkSGlMcng5aWErdjJWS2tRTmlsalMyVXBv?=
 =?utf-8?B?OWFQSld1N3dtQWtYWFczQjJ1LzljNnA1TGQvUmZSdjNNTkFLTFJFOHpwMmVG?=
 =?utf-8?B?NUJra2FmWWZHcUxFaU9tQWdXV3BxWG42TlgxdVkvYmZlTzB3bG91ZGxiby92?=
 =?utf-8?B?Q3JLdkNTL1o4NmNwNHdxRzY4MmxlWjR5WVFabjV5V1ArUFV2MTNNNTRSZzVJ?=
 =?utf-8?B?NTNUTllZYXk0TXhCT2JUNGRCWERCR3lOK3VVb3ZHMGJIeElKd0l0Vng1VSs4?=
 =?utf-8?B?M0hGcE91VFV1UFF2RGsrc3A3T3A4Z2s1MTVpWjhzNHhhVVFhZHN4SGZJb3NB?=
 =?utf-8?B?bnhYblp1aE5QUkdwMTlIZW1VcDg4UFloWGFEZmNwekhqZTVscHV1T24ySWxt?=
 =?utf-8?B?OC9sTFI0VURpY1VHYjlBMDJ3T3lFUFVzMjNqK2NUUHVrNFQ2dXJsajdyQmZh?=
 =?utf-8?B?ZERibTZKMm1MYkM4dWE3NE5PQ2U5cm10UU1aeVp3a21kYWREbmM2dkx4VjdU?=
 =?utf-8?B?ajU5MFZIeW92OC8vUjFzbnk1K0FLT1hMNnVvaXBSS0tzRnBCNy9kRFZsc3NF?=
 =?utf-8?B?c2FDdTVUeW5mYnkvSmh3QjJ6Znc3eHJhQ2FwSXZHY1V5aU9CaE8reDcvQmIv?=
 =?utf-8?B?V2tnd2c1eHROQkxVbkZLblBheXZISEFtZ1h1OXl3MlhqbThMSDNYc2ZmY1dR?=
 =?utf-8?B?cW5DbmVDOTFVZEJUbjA4cWU5bVB0bXNsSEV4S2ZON3pQZ3FaM0tmL2ZQZDI1?=
 =?utf-8?B?T2s3eUIrWExneEpldnVrWE9RUnQ5WjhWQjl4ckZxbkQxVXVXWXp2ZStQSWEv?=
 =?utf-8?B?cXJMTU13aU9ab2J1NUE2Um81OGw0YWg2K1plSHZSUkNmT2w4cU5ydFVEWGda?=
 =?utf-8?B?TG1uUzdvZ1k1MWUxWlpUdlF1SVZibHVYV0JzMDVGTFdEWUFJV3Nwbk92dUEx?=
 =?utf-8?B?dGt0aE1TV0V3dHdJcmErYjRUWnk1ZjhIdmFNQWZ4bEQ3VUVON09RdEpQN0JO?=
 =?utf-8?B?dXNKaFlrUE8vRkpYS1VSdVZ2djNUcnBjN0xSa00vaXlWcmVlQk5YZ3V5d0t5?=
 =?utf-8?B?REVVQThXN0JrT1Zic3ZqQXBqTnBxSmNWejI1QmdaRXV0S1R5LzNzOEczVGlN?=
 =?utf-8?B?V0NacktMODVIM2tNL2hKbW9oT1paTFJUSTM2cUFsbXR1RUNtOU9nd2t6QXZr?=
 =?utf-8?B?Y1FOUWhUdDc5c0VlMEpMN3pMRlFvNUdCM0pQM0JIQ29pQ2ZNVytYWUpHamcy?=
 =?utf-8?B?Zm8wWnVnU0tCQUh3RXRseWVmUjBkOC9Qc21ORk9YNHM3bEk2WitBWU1pdTR0?=
 =?utf-8?B?U2tKeHhBVnhibHpJeWV3M1RpRHczcFBhRndOU2tGc0J2WjNSSzdadVk3a1Er?=
 =?utf-8?B?dXJBTnIySEpiNkR6dllZTGd2ZlRHVGVLMHdkVHI0d3lQczUrdjI0RjNadEJ3?=
 =?utf-8?Q?370e5Uo4Tx6UMkgf6CzfrXqU6MqO2zDFeUewFVSO3nl48?=
X-MS-Exchange-AntiSpam-MessageData-1: 5X0pbr/tlfzuXrXoTbB1v2/wgxUt/AXncc4=
X-Exchange-RoutingPolicyChecked:
	ZmX1yBRtTu5Xmxx/ug9hF3/Xp5Q1CIGHnNS+41lOh3yWU1Hb4yUGIvR+j/Cg6kQ7vW8LjvPdyH0jEmZLhveXwKVaolamRIOVBoogwEdNoC3pGP7ARDEHdZkrXZGBXanBI1kuZybz5Zx3i+qo0BEbkcguIYIUen2NZa/dsCskS2fkBOdG/btSXaimogxyuLrmD2lA/i1dIP4qzQP1HzqE37tst8PRq8UdYRF9XOO69YoXzuKds6YAn8X6IDMsihWJ0JdFHgbaTVIUoPoXFXbQLcfePkV7PjJSLLdhQ8j/36XKO8W9AWDIZrgjdp93WlXVVRsKXuX0Insr8CQ17Frhow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	noVpfQgF1+nZ+wTIDBnEu5QDxJCgc17Ik2/QadtUIeXpMZnHMbFkolyGCQWBC0G9bD+bWNZcEXTyGrPd3pGzvyRQAzI9etmaLn1iutStbnUBhiqtowbavuPovEZDW0WvBF59VhnPwrDOi8jsEFVWI4zcVwHvoJqeaAqgneEzck8ZFKZwczldgtVqMhmo/dO7XQRhDnmXeG8oTmtAASdCdLsLicLxPEc5efsEueRydgVsFZ99dXcMWwVaIS/9QKIA3Twx6Zf5S8RioYZNvA1ZmQOVzqv38uKAIeNHrylHEbuLMjt+l8oVVLNQ+LXeWTQd2+iQpuVIMKxqh4iFcXBEKqerUJ21PqAEHjZXKc9KlCkggD4kyZ2bYqxwW8LqdzfUewKg09lzQTWJEXBGZKMl7A/jYZa3e6cg88wqHsG4GAyMfz5dKWio9NjHkZ1P65AvLJ6F36wCHy0hiTYvlpaJKY1UP5iNh+PSFz/bvcEFoOcOCA8cvncBtcO8oGAWdMBm5f6sb2o45qeMw8bNNFgsGpE84bhDCYpRTf4HfQPZrfHp/m5/3utZyaSAG0+8dwuhX3oUIr60Zdo4+FGi6rncHtqVUfp2PY6+5UJRK22/SHou+TOgdX9NSHNXko+5wDWp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459b45a1-559f-4842-b182-08df2f3f3459
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 06:47:42.0404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4EbZjHGzHUkR77ms9zqBa8Wo7gPLWRrYcIXHCWTlzSEt+QpEgVolTuID2C17fimF5d7FBh6dwHdIpSKBc8Xta3HrmlmbOoQ5ILdAn408X+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7484

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
