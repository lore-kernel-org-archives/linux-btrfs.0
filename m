Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF49A3EBF29
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776181958; cv=fail; b=jErUA7g92x1ZedAstm8Lk6HDSmrIwb2j4QN70ReJsKk2+POXh4WABHqeFoedPmCZ4VE9UiZHvsKtgxgBE9+T3q1wP2WcGtCRE+uOyqoIwXZCV3eYPdk27kO/8Ru19za1nk5uHDZ899ueVUrdWBL8zNdTCKASYE697ElzSj5l57M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776181958; c=relaxed/simple;
	bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GXB+XnrIEFXTqM7E1F1X0TCHofPV8A3dlTO5gIbyFrR5T8zG6Tm9Vw4fmzQmCuITXu1N+7enzN0we5D2r72/efi+M2uiG07mxSjliHkY8cdMSnMvKTrzKnDM9L5IvkdVfLCje9weAYII015HqpOLc5W3qVOmk3CtVou1tCDvbHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ODbVFYDx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=q6JMHHeY; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ODbVFYDx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="q6JMHHeY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776181955; x=1807717955;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
  b=ODbVFYDxx27QNm1I63iKi9Q7LvPhUVDJDI6rA1yUKP0JQV7GPvx4rsAK
   MkkjwGlhVUXuT0d7KXYeFQMyH33/dPGXqx+qLDEy8bCEmdk6KyR3umFNX
   NoW6Z5zb/PTh6U3t7DgNgI4xGAVZ2YPhjveSeTNLzjhbAnD42C1hFMKeQ
   zhVB+xd9BaGdl6zIqHuI5q7JUhBJj18/CFN8SKBIEc+OOy0jmmi5ykuHB
   aL/MifYMjz6JIPxjNoofRUekkn5bJeaU6hJXaCsvExmbG43aV39OOjCM/
   HhMbo7t17ai5JNcdF5tubTc/BNJy2B1x+nuMwJfrwtJ3TREmJGu6avkCs
   w==;
X-CSE-ConnectionGUID: B/BvJATSTU23DMjDaZ2+tg==
X-CSE-MsgGUID: 8pEsbbQSTaOUZ26jrmINQA==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="140758469"
Received: from mail-westusazon11010012.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2026 23:52:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yjQMfpnvU+MrUDHUGdFASCeW0viBsgZ1iQZFkdUB07HvAYlhWAxkIXfJY5pGDZTEHXIp7H3pzJQ+BJy19Jn+eW4+3tcDzyY/vfeF9i9FwltE1EtLCB/w1rJGoN911piTtUK7hEg8R4FoleKgc7qxIQgfbPReSIMiYzpgbL5mJ8YIpAMfNiw9D5EN7ZsdYCDVMylO/AlypSIQP96HGm/e56cwpvM3nt978/QOWziuZauxcmXdFY7BdgDsXhvLXFOP9fWD6QCvblGn1SVfDMO+WSL9vVdHTfQDcnVO3h9sGZn4gCLPSGcSgNDj9AnPWKmvgeGNs2tOaXQ9sWjAzcezSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=ut1SfjjVUpGSkKh/0K8vEJYm+SeT70uGEkMuN4zvxZPtlw6eddJkl/yyBWK2hVHjVBFu7x2v2XqXCiHmvgqVC8Ohgj0ZVNEzLpkDqItYImoJlCVngh3wi116EoOiWYV/XrYWXkZYVGPPqIEhakBYstNDsA62uBIq3ByoW1J4xV6iWuhC358iH/MJZ0DVfWghA1U/WJ9jxCf/+BnrPl7e5plnm/5hdu/52+06F+pvIoc9eScoJ+O54j61eKZeBZ1W0LRSIIhBOc8OtPf8Auckndhj6ebsUq3gZJAOV8LvdMtHi0LN+Fh830+GTViXkJN2ydCEI2a+ZQx+unqSsQXj9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=q6JMHHeYcdJjViilaWcHLJixaBoobPCCnD9trgUAEYXrn0wm7NLMIjlxYbxNxF7kP/4MV1sYT/yQDEHGW5rdYibW8f9E7vgzwrARUGruvay1E1i5USS8a41r4cAdFTRkXFZ15blYWgqwAw0QeRsGykPc+tV5d4UFmgo/Xw7UsPA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by SJ0PR04MB8276.namprd04.prod.outlook.com (2603:10b6:a03:3f0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 15:52:27 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 15:52:27 +0000
Message-ID: <02a96901-b929-4020-a5e5-749351cb8416@wdc.com>
Date: Tue, 14 Apr 2026 17:52:23 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Debugging macro and kmalloc_obj* cleanups
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1776180388.git.dsterba@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1776180388.git.dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0179.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::19) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|SJ0PR04MB8276:EE_
X-MS-Office365-Filtering-Correlation-Id: feb05967-e9f1-41a5-d8ad-08de9a3dd3c6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|10070799003|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	aiIr61X1BHQ8PX8egH8TTwahn4knVBWrt+Ng03HQMljUekIWluxXF9cZ4p/yLanjTFXOUby2lxbIB+xQ6YKSs61/782BNjLblXuKYFdM8SMS+D4rMBfs8Mkfv+5h3xmAoK/WcWLeXi83cbwIVwqOg8j0A0yyArqDeWhU8li1vXOvXZ91QPshSBY2vXDG4ArcJi93TAdJHueL1F/El6awzRJen92JXaG2rzTRJsOcpzHhSdfn8tWXUDAFeDn8sHQ33k1URdQ1TlVNh4S0Qtg8Oz2s+62VOc932rYCiPrUPngefzF0+m0Vx7bc15Um37dyf5aEznly/wJbCZep8EWF0EDF7aqBNE41IqZH21GnJQSph/X4iu02nu7/31QbCjRQR0FOBxChZaMNK21KWsO0enYXRJ2yaToyL6MLkQvpUHm6Hs5QsuotyKLjY9R6vLlGv4iOPU920WtB9QhuQGpuQl0jeU38ONcxnwSk04g9bCtDgT6fcjiIwYRAk+x2TRqVOhvcd4mHxEoYhYV5KiFvvIf1njFwzr74+hH4sIuaCEPWV3FCn2S6P0HX89OHRaZyNbj90UyTKfrf2OE0EYWPCNyxhwjiSj4emoDNob2PpXIPVJPoscU3g6DiT7G8w7IcPm68/LCeXD7WPjNXX3e5RMXNovQK2bkb3qYWpKFFcSYo2rElqgXsLfWCPF/Ibnvi0FU2Ix/vkzwGBNCfOVuXO4vpsBER9ReX+agVDCJor2k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(10070799003)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGJLMW04T1M3MGw2K2VZZXZyQlNiZ29hd1MzMWIzZjZ5RXN6MUpMc0FTWTR1?=
 =?utf-8?B?NkQ3bE01ZG9GZVNHODNZaWxDSzRRN2YwdHhJUXFHVjU5RzhiNWw0MmlEbU9I?=
 =?utf-8?B?N21xNWJDQVZDM09BQ29TY2x1MlkwNVJJUmVJclE0b2E4U3NLOXdlRWM1ck90?=
 =?utf-8?B?K2w2VjRaVE5NUkQ3ZFNyWTNva0U2VHFLbmZvbjhlUFNnT0RkNko1U3ViaVZv?=
 =?utf-8?B?Y1BvQ3NBL2JEcVRyUGRrUXVMRDhqZ0xsZnk5KzR6ODMyQjJPMGVDbHJnZXJy?=
 =?utf-8?B?TitzYlIwQit1Y2IrL09YODhacGJEVVlSNDhla2FhMmQ4Q3Z2QUo3dkJ4Mk8w?=
 =?utf-8?B?dFlmVHAwT3RMV0xMUE1aUDdBNUphQkdZOExaeDRiY2M3bDltMUR5d0ZuOFN5?=
 =?utf-8?B?a3p1VUpNN0w0Sy9MWXhjRUk3akUzNzN5cjQ0ZmhCdnZySXd0K1RYendNU0lC?=
 =?utf-8?B?bTNBWU1GVU9KQ2NNQk9mWXNzc0dVeWpNZWRjWHlXTWdDN0ZzMEZQcklqMFMy?=
 =?utf-8?B?M1Bvb2c1SlJtUjdDdForV0dIWUlKekFoLzRabS9VU1RPbEp4WTR3SGs1RGMr?=
 =?utf-8?B?R0phM1VXNkViVzh5eGNDVCtQUUIyWk5Wd2E2amVPMVNjL3l1V3J4ZG1aTFpQ?=
 =?utf-8?B?WkhlM1Awelo1OUNjb2hxTmYxQzAxcnBuU2w0c2oyNno1eGt0T0NJVHZvbmpy?=
 =?utf-8?B?MzRXSnExWlpHeUYvRXNVMXZ2ek5YZW5uMFBLdzJXbW9kYnRHQmZZOE4zcGxu?=
 =?utf-8?B?WnpiUXk2dTVzWHJhZU5KYlVuYjJGQ3RHd0gxbVdkWjNPUC9Nakl2UytCL3E0?=
 =?utf-8?B?OEpKRnNNdVhpamZxU2RuR1RhS1lxTHJUSWM5VnFMT0xLcjgyV3dDNVo4eXUr?=
 =?utf-8?B?alFGY0w5K3NJVGFhSVB3REVJbm1NdEVWNlRhSFpZMEZVMlVldzVxaUtmeFMx?=
 =?utf-8?B?bEN5T3ptUTczZEIydGJKMGhaeGt6RzF2VUUrbW1jYm9MT1FpbzRDNnVSVkFU?=
 =?utf-8?B?L29YRjZaWEpxVG1GUmZibUl5VDBFMHpHTkYvZHIwOUJOZXJ6ZzlBdTYvWVl6?=
 =?utf-8?B?aFh2SmovNjhTZk9sNGo1dFdYVnYrWTNwbFNvUHA1bVo2TzZDdWZvZHNJNVhD?=
 =?utf-8?B?eFJyblVGSzN3U0w4MWVybVJsRk53Y1BjR0NQeUtZMjdJWjc2MjdmbVp3MTBl?=
 =?utf-8?B?TExFRzJvUUJSUDBvMUZLNHhDRGwrc3lic3czbVRHbC94TFFyajJIcEJLcTRO?=
 =?utf-8?B?OHRBMStXbnpJZVZZOGlKazhOMEwrS3NqV0hJcmp2L2FWZ2IwaGxzdUlXQXg0?=
 =?utf-8?B?VlZ0ZjQ5M2JGK0VHaDQvMEozb3J5cEx1RXBmRUJGSG56VmNQZHFocjBmMzBv?=
 =?utf-8?B?VmVjdUhRZlE1NVpVcktld3VDRXZYNnZKbS9UYVBheXFuSmdVR3RMS1ZNb1FX?=
 =?utf-8?B?N3l4UnVRQThGSmRtc1k1amducTFMT0V4WW4yOWdPeHJ2andoVWhLb3BFNVJz?=
 =?utf-8?B?NnlwTXpTc0JKMVRJbndTSlBDMXp2RFMxWnk3MnAybHY1U0U2THkrZzdjV0wv?=
 =?utf-8?B?dUcxMHUzMFVsMWphUFFvWDQ1Mk9wQy9zV1FwVzdWR1V5R3gyMFVIQUJaK0RJ?=
 =?utf-8?B?aFpMcURsd0orcHhCMmRkWW5VbjJiRVQxK2RrOTJPMzhiME1zQWtGank4UzFm?=
 =?utf-8?B?clIrVFMvS0dYR05mY2UzcjBla2w2Q1daTmk4cmJVNVFZYVRiNWpRYTY4anpL?=
 =?utf-8?B?ZXJkb25GQkEwajNPai9NWWJKQ0NXZXZvTzZmT1lhNzdtRndzYXVUbzdFc0dP?=
 =?utf-8?B?ak12OHRzM2gwSGZPQjBzbGNNMHVGUERtR1hxU0tuK0VCSTc1RnF2MXA5K1Vv?=
 =?utf-8?B?NmpraHNlRVB3UGtXZ2c4YU0vcWVKd1lPVkRNVm0wK2lNak1HU0RyV1lDUVBB?=
 =?utf-8?B?U0hsSlg2TjdCWk15SGtIVVMrOFpGQWJDT2gxd1Y4S2hJV2Q2dGowZjY1akJ0?=
 =?utf-8?B?VXcxVlgraWJlVW0xVysrVXA5R0prTlRqU252a2kxSHU4THloRWp2VTFFbGlm?=
 =?utf-8?B?N0tnVjZwcFBycU1JQUltZDM4M0ovQlYzangyV1ZyR2dsYUp0dXo5MUlMRU9V?=
 =?utf-8?B?R3RqWGlVQW1IQmszVk5zSWh0WUZJS244ZEZHeFY3TWVHTEcrN1E0Y045ZlRy?=
 =?utf-8?B?SUVaSUNlRmFnTFc5M1ZXZVFiYlcxZ2owQ2IyczhId3IyaENSbnNWRVRkODlt?=
 =?utf-8?B?QXJNY1kxQzE0MDgxOERFTmg0Ymc4NjBlV1R4aXFFRWg0alZILzUrSW8yUW90?=
 =?utf-8?B?b01PcEpZWGZWa3oyckhNVEl1MWhTanlJdWxyUU00TG1JalA2Mk90SzVDUThL?=
 =?utf-8?Q?N5h9JF0QwKC/d4DrQb1nVyvHo9M/ihmLEDb+Elp1PtYi8?=
X-MS-Exchange-AntiSpam-MessageData-1: 2NTjK4NCSxNXWwzjHsDG8hkdavQ5Zu/VnTM=
X-Exchange-RoutingPolicyChecked:
	wdgUNOxUAt6Ab3IUpf1b71WlZzMP0XKxLpQzWowstdGH8s1JQVOYdpcyLJtS1+2n5a9C5iUkh5pSzrgiE/aWBH8t2VZcrFmTZ4XpSrcLVs88y+K5kkOhCN/x8C1RYM4eqFQ1NgjUmXhAXuOaZvi1N6k5rO9FACA5vcqQtFCF8Dsdy9ffX0SgEOArljDMW8jaUX2BKQqN/WibwEhJzSAUtYSlJVZh7AIkJGDvtYs2WILLFgXEZ81us1KQ3jk/8If63FTmaRYTmsUiXpL2n+bbs4ouzxuwkmjOPeOER5cQOKFFOw8Gqe4kYi/EDmlWYy7i9a1iTw5eQSdujB+YTOlTiw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AK4baYWkngd2Qjvzt3sQSHoiMxDujpRX4RFHKGStlHjX1CIc3VEiyjDo143eh7kTXc6/MncLRWcctdusb3YFZhg+GtXF5q9hz5jyR893uo28Hqzbs0AeaKgh0oAEsSbCc02hHr1JiJGVUeWH+4DB9cJoZTtvTYPvVbjQCu5yNfLvkyw4lGi6MZJyKL2/MmjJYraQ4Pr/TuVKxBvkngWnbLhYD31Rtxr4HBZUAaMLZCIC/TUi51UmSxL1x0xXhVp/vIAQTAcgWn9W4kc6LKqCVCtcJl5pp/5E/W0GAqtu3R063ZYEpeI/0e+Yt7xKHBNzcXIeSFRD0R3tf4QFMvKv/yyT3VZb/guhXLkIIaHsTsR7SvMPTMc7TG+JZ1gNStRzk1ZYhn9tCONmpnWDAi4Hl3BUatFRzvRWFgXHClf4VSUpugZ2uZ2/i+fswYZFZ05sO1lj5yqiogKk4Qr+N8FiCYAn8piJ4kVoiJSCcaWF+9SDPvIPwF4FeeYWnVL8I+qsya0n1W2wg2sjMc1xZydkCFii+h5PidCb8CSFOhhY0TlBgqLhWzz25yL4CI5Qcj+syKDIf6pGVUKqPuu+xSvDfQirLKlbKGzuMJMhKyy5+vafDWGR+BqBdGSLB13XOcmY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb05967-e9f1-41a5-d8ad-08de9a3dd3c6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 15:52:27.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1n/kSu64ySSNl36ZIkbZkEKjVPmjhledDI+B7EfK8UlaaWSmetCrGOfaKVWECQ2uIYWqLoWTM8Tveib7yQ15JOeDbJAkG5VS15wHwlhcvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8276

Looks good to me,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

