Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794986020;
	b=eWme6QJHpB79MTupIl6Z+GYzvS2aHGIL4o/iOCVxkgHH97C/L8NZJriUSxdepaRnUo+e
	 QUe84Lu73C2oYAKKrIuj0p23Er190k5YFq6mqdajvotKzrYJsiDmmupaIgtZlgmK4+OQ+
	 6Ynqa+WtTUnj0Po4HYFYG5A+ayPXMQJKVEyfemtnbyG3OzF+e1T2RZ3kdi3i8KOnCfKC4
	 oawYklIlmyMkVLGAVas4m/72mTWqp2rrgPATkTDfZKNgxDK7X8MH0b3RqTJjBSmsqy09T
	 yHomo7T7W5bgSHo+pHT9si9p6u1xI4L+XpRdxtKNLle7tiNZkUiGOlHcOnP9YeEPBeA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794986020;
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
	bh=r+oArm9DxZZjKor4DZH9KQOUBxbzRkVk7GoIuBiyQGs=;
	b=bcdhZDVJS1R830ypba9iusmQ9MjRnWC49tKQre89jWCH9HZc/tXB6iHQj/A2iIvekIl3
	 dRQ675V12/OzFsS2Pdku0L9rnxeN5zKwnditwYKvQGjcsmubEcj3nRY7aw2+YLGlChXG8
	 XNRWM8xm/G1fa9kALKs+j10NRGSXLoVa1nseSMf/+BqpFV4SziqJ+8JrOvDrpEvz8pKuV
	 XdvKs3nlviwID/jTvV+Z6LqO0C1iMAQBl1EKmqJVeb2wwNp44J7o8yNm1ZwYIdFZEywYJ
	 Ks2D8QbwLEVkLuOFdXz+DCqerXmzKA6SuwUKyiXhcM3QLm3noKqV4ZuIJNPdTjihiGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iu4BKas+;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Bk6PV2RM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F8E606A31C;
	Wed, 18 Nov 2026 07:13:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6F8E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iu4BKas+;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Bk6PV2RM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794986019; x=1826522019;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r+oArm9DxZZjKor4DZH9KQOUBxbzRkVk7GoIuBiyQGs=;
  b=iu4BKas+EhNDhT0fSfFHonCxOgOTAvN4/M4xzMUW0351nK9d4hIykArv
   2cQHGlm29v4jJnHkmFnw0mC3dEVZn8qcXxx5aYQr0gF2BskWT7knwz+ym
   0bd3q/z1qG3OhXlwCLgYkVTb9h600pB6bMv1egpFTAzdznIsLLhoiR7Pq
   EhqUnxOOAeCUVUuMGmNy7zF5Vlj1VgZJe5pklmnugGKLFoacZujsplBxK
   /9gzFK+Rm0v0IqE2pQkRvgNHo1b3SssKWi2FHXKRldjPPpcr9WNI58OIQ
   FMeZyBo1SiU+Hu5kNf1kM44DoL2Mum3PPn+bVQOmv833Xy4AT20n7ozBT
   Q==;
X-CSE-ConnectionGUID: mRSKM8/eSEGdQkMUZqVZTw==
X-CSE-MsgGUID: tDQ/1jVcSfCyf+vmST49JQ==
X-IronPort-AV: E=Sophos;i="6.27,219,1786982400"; 
   d="scan'208";a="159553301"
Received: from mail-westcentralusazon11010012.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 15:13:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oGoHxoCMJ9581vo/J77SgIElC926YyYnFMuMNYvmVI1Le8lyVNomNbsZCrFqp0FTBpa8uCkz4f0dOTgU97psTbVJSgCuLFy88/3jPlOe+EZGCh+9lnmnx7LdnzMMlFNmzLNN2urrCeNslvufhT445Lsd42deHo00RfJGJcBda+UmDYktpsO04ESEqDpAnbuL9ul7GfVah12xSh1/OfkVZhnUlXaz9QO0iz9Xm83hfSMasBLVzXTZNfa8g1ozgxYCpbVuVsYlfeGejhdCLnmZCvr86vRAJZ78dFgC73B1gbEJbyvaiTSvo2bHrU6AprfB8ZIB/Mcqfy0p6KwiCVPNgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+oArm9DxZZjKor4DZH9KQOUBxbzRkVk7GoIuBiyQGs=;
 b=JfoLlZ5WjcGuy8rdxy4/5qA7C2/o5ya5WjnUyEBoKuZhxtlpLAvzwi2ktrgUhOhF1ps3Wn6CMBUNPP7Id6z1KeESgoWqTg077QvKDQbgRkbcM9mhH69HnncFFgQY3ALHyzLQozqopPhOX0Na4XAEfnvM1L6LqRi7acBiTe6RdXAqLKJ10cOT2EyJzPbTs0OStDUo+ckmrVsdbf2JvjG8PgLay9LBzipx2XKA0EO4t/vFP+tJhrgDtVwZSZ7WSX48t53qecm3fj5cAwFb8PIVfgeHSeQesWjEb0zvhS1PPJj0a7lqjipVcrPvhkswkLIWY32ea67areAOTrVDq9gA9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+oArm9DxZZjKor4DZH9KQOUBxbzRkVk7GoIuBiyQGs=;
 b=Bk6PV2RMfOGw3nuSruZdv5cQOlTt9xlHcnfgc8Oz1gmV8hBW9rjNXQbyBUNtcp2WficrNAymWuIQLtCeaPHyYKUfZPGg68uwbUQFPCu91ZzwYUZtsfOIQh3YlifTKBhQGKfJBEV4CqgqZ8RmbQQNAUn26IjE1UhwYTDVD+KhqzM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SAWPR04MB993581.namprd04.prod.outlook.com (2603:10b6:806:561::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 07:13:32 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 07:13:31 +0000
Message-ID: <dc9f5047-4150-4594-b31d-c82c1a98c694@wdc.com>
Date: Wed, 18 Nov 2026 08:13:27 +0100
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
X-ClientProxiedBy: FR4P281CA0369.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::9) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 1e264ca1-0fb1-458c-5d44-08df45437387
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10070799003|19092799006|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XqCw16zHJYMHDZr3eEUIyL9dMx/fNSiZmdFJql3p8Jqe9mREDfKTWEJ9IGiwd3Qz22d4Q+co+hErCO8QbH9JXVPFPY1yvjBr1/wBm0TIiYwNqHjl8PKZ2rx45hz5oJom5IPt1OtJvZEHoSZmvOPgIwX0LFUWOcxVfgc4n5wzLIhpno/kfZwpZJKfEjkKbcg4/Hf3Dobo9mpx2y+XMSvs4+hrt3we338MqgJ+kTyH5hkc4Z0OZS3PfyqndVDJDWImEQecPoxyoSBSjEN6r5aYlVE8yDTahKkn6zpJnA0/5mFGF33arOLUM73ThLn/LZTEnwMD4G2JnczoTUej/2onFSN1jQV3aq0QAC3PXwp6MugKeD1n9nPdE07XI0xI1ptO9yilTgiY4aw4om4HIQzulgXDxn/6i4MWBn1WY4k0rpMoH1YuJGZtGlaL5quPgG2oKnlDaR04QAQ8XFr7Cn/uGBMHz/KzcW7kWVFgNGJpvpixtuhEVVXbWEnxOS4oX5FGgnnMVuP3T/uaCj2GEV20rW3/PLVGtnvrZfFQwS2aukV2dD8IO7A7wKl4+U+ZHUDwBpFJ34HWD4N50OnYBTVzJVnMJ2FADWaZXPDL1u3Ogu1zWTqM40piivTJLC0IcApux/t+7AmtXCgxoyjwdv5AkBKX/O2/WyYupeqoM9dP4vw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10070799003)(19092799006)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2hUVG9aS1lmTWlVRUNsbW1NcUROakl2ZSsvbllqRTdMRzVhUVE2YWZyajEx?=
 =?utf-8?B?WmJrb2tYYVc2TG1helFaY2taaEIzeE9lQytnY2gxd1k4K2tpVDVMd0w5b2xB?=
 =?utf-8?B?Ky94blBLM3ZnUjJ1UnVYL3lhZUswTy8rS1FxaHFoZHA5eUpDa0xpUUZJOWda?=
 =?utf-8?B?amMrYWlCTUhyNzhwN3RqTzhnaFVzV2ZDbGFnVUxLWUlRQ1QzU3V5L3RpMWFx?=
 =?utf-8?B?Tk1JTlJnMHMxbjJUSHBLdE1zOGt5b3VFRHdxcnd0TENFendINTZuOXFseDRG?=
 =?utf-8?B?RHNGLzltZ0lSR1pmMFFodldvNkhaanh3a3ZOcytaT3NRNDF0TFE2QlEzNDJs?=
 =?utf-8?B?bDdVUXdIUGdmcVFreCtRcVV4WDBOL3YvZVA0STVMSWlLOVZ3enJQZ3htVmgx?=
 =?utf-8?B?dllBUUtaQ29sVHBKVE1Od28xdFlReWc0Mk1TSDE1Z3A5OVNwRXpHeVd6WjBL?=
 =?utf-8?B?SHl2MW5Qem1ZUjE5UHdJaFp6NTQrN2RoNHdVTzgwRzVJTk9YTDZpZWtzMkVl?=
 =?utf-8?B?a1A4TGNtUHpJYVhjc3luNjRhSFQ1UnFzK2NuT29UQ2gxUGt2ZWc4c0FBNDRn?=
 =?utf-8?B?NUpQbzdNUlJHUXdnNFgvL0I0TGtlL3p5Y2dYY3RMZ24zU0VWdW0xQTJJTHdS?=
 =?utf-8?B?bkl1Q0xJbnVCTkc5M1VscjlDUzVPWGlIWXYrRHpoUW0xSkNrOGhVQTFVRUpD?=
 =?utf-8?B?b094b09VbzVaSnVqOU5aQ0RGSWVuK3IrMlJwemw2WHExeDg5Z0FBaFI0anFU?=
 =?utf-8?B?MDhYd3E1MzNBUGtCU3hwNldzanFaOUpxc2NyV2w1K1o0QWVlRS9GT2oyRnJy?=
 =?utf-8?B?M0RuTWx1YzNyNG0rNXZ0V2Y5TGhNdW1PUHFOczlvWUcyRjhpQjM2UlZVYllR?=
 =?utf-8?B?RUR1NzRFKzFHbkU2UHFVSGR5eHY2Tk1qbENkNTZLL3orckVBSG5pcGpoN05r?=
 =?utf-8?B?Qmx5ajYyd1lBYWNRNjNPUmRYZnRDVGNpV1JhelM1Z3drYWkrbjQvbU1xZlNr?=
 =?utf-8?B?bzFkVlUwQU14MXh6TEpqalZmRlR3SmdOWlRhSHc0clBPUGJUVkFaSW9LRkRG?=
 =?utf-8?B?S2F4NWE2SiszY0hnWENmVUhWMVg5SkdEOENPTmVRMENNajZqSDkycVBjUklt?=
 =?utf-8?B?cmFienJqT1JYbXdleGRMQ1hpS3BIN0dIbnB2YURPOHdzY3RUaWJIYk4wenph?=
 =?utf-8?B?VnBLdm1nUE9LQ0I1WVFnUHdEb2V4anZmQXVPNzlIUlNZK3RaMWIvdEY4Uk5J?=
 =?utf-8?B?aW9BNFRwM1lGU0tOTDNBQzlZSk9EcU5KUFVNd3JOYVpvekdRUUtTUjdIdVA2?=
 =?utf-8?B?QVplTlRtSjRkcjlqZG9XMGdzMWErdGtMK2JBTXFXY2p2ZkkxSjJTeS9MMmxn?=
 =?utf-8?B?ZE1oWEVQRnlCKzREOUR0M21FSWk0YVc0ZExjN0QvclNqNk5iSFk2Z2wvbURQ?=
 =?utf-8?B?LzNPajNFSHFqc0F1dEc5TStoemRyVTdCckVucFdxSWkwNWRqOHQ2QnUwMlJm?=
 =?utf-8?B?N1c4eDVzUnpuMTROUlZibU5PUmlNN25NbEZOeGFSdTIwdVBmL1pLeC9JbHFJ?=
 =?utf-8?B?MXNjdS9XWjFzQzJTeHU2a3ZVeWNPK1k0K2VmWmpZNzZlNS9tcjI5bm91VEJI?=
 =?utf-8?B?bVdPWXNzODJxMGQwTFkwQkJ0L0s1Mkc2R2RhbzdZTmZrK0IwVU9SemhzRGhq?=
 =?utf-8?B?V0Zab0Y1VFNTVnlqZXZtR3l2Wkk2TzRkTXJXU3ovcE54VVpEMUFvbVl4SU94?=
 =?utf-8?B?Y0tJUEpjOEdjbE5jbHJhVHJOd3JLeUVKNTFWbDFtbWlvU0tHV2c4LzhnMXJH?=
 =?utf-8?B?TU9MUlp5Y1J1VW5SVDFNTno2dS9jWDBMNUdleUtsQjc0NEdDOGtmMXNLakc4?=
 =?utf-8?B?V3JnQnNyajY3TCtydmM3Sk45bEt2VThwYXVKUks4d1BDbncrUVgwTVJaajR3?=
 =?utf-8?B?a3d2MG1VRmE5aVdJVnZoeGpwSTJneFVFaE14eXpFNGVLSE5oWm5DUDltdWpp?=
 =?utf-8?B?dHp0YytRbmNtZ3ZYL1pXVmx3STF5QmlMSWZ6T2p6TFJpUU9pNWY5d2NhTURy?=
 =?utf-8?B?NENaVWQzZjF1M3FVaXdqSjg0Z2ZZVytJaVl3M0NNMjU4TVluYUlOck1LQUUz?=
 =?utf-8?B?bzRhdEQ2aUZOWndCcVYycGZNczZTa1AyK2UzN1JjRG9iYnlxSEhkVDZlWUcw?=
 =?utf-8?B?R2VvOERTbFIrOFdHYXI1ZE5PVFcydTF3VnJNaC80WE4yWmRLdmk2SGVnV3h1?=
 =?utf-8?B?eEsyQ1ZsSEZZc2tPT3pLSlphSGk5ZlE1MXB0MnBjcHEvdUtYMXZQL1lWckx4?=
 =?utf-8?B?dGczY25jOVo4eVM3TjFBdnErTGpPaXZDdnlLeDh5Ym5nU095YXgvYkxQT3py?=
 =?utf-8?Q?69RfQv4ZppViz/W94J8sLtFSn+ETGXX3+/zlOw/jOkQN+?=
X-MS-Exchange-AntiSpam-MessageData-1: Gm56bNSzw9BIMUxxSTzokL6W0TZ6YydrMis=
X-Exchange-RoutingPolicyChecked:
	w+JTr4fXUy45dF7vxZew74GaCbAPMt0LgZeezDmegc83dKWEi2SVsbiexkn/xu/L3I1J+GTxbyWg7QcBQxmtsVJHuEm4R4UgugX4pHfcmUDNubXTQpgBHyfy5CXt+C+jKuD1qwTZhuMurSTGhqD+nuqRzhrc6j6BdB3MSvr9sCGju7rZE1POuFS+dvB/aTd/z2Ym3t0IKTgIzbubpxwHxFyw5yvYm24lzVu4KKFkUfsAwMubuJ6HPx/U+tjF5rqXavmwFLlS5JHi+ukJuDgo24oJkBJpNus79i2i4x38IMnucHJ4vLHk/bpA5NcKx7kq+pCWs4NTvLNxQv0wKJwa5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QGGWtRROUvsFbC6b8YP2GiKdf42JuKQkW3s9Qt08icQ9yLXSNw8W59tYgxeopM6GPrMCXqt9WWE8i3b2qWx22FmCsuvSfjqL2VvIBSI3rcOO7tQYxHQn8oEBR1IUP8EP2ytxmtKRBxO817hczdN38Ck6nf0TJb30X4wE6VQ32TEBzCO6NKseUG9efxH7CWEq/wvwzrn0Eyc+ryP0molJxPdlW/PEjcfm6J/+5llRbmTfo1ti2pdbRGBjwwhGkTnoPNH4xomB3SiiLtnAwHU4wqiYSaAblZVe8jjuJwx3cv6KCrM6SDI1e5+9c+wxaza6hmCzKubsL6EYmZeC4P7QX5TEP+3uiQ482xpAUyVad55rIGL+FBMJHOLZYLU9DTEbU8ZNRgwD360xUP7rVDHJxYXjbrXW4/8s+Q3Q1WJQiu0/I5m6BfvX6L4bzqOvcFjOEUaORhKwQwtQ+L5yHqKZYahWJUhifPuo5oWFKjhta/Uk29uimXYy8urCJkOvgW/xMfj/a8U1cMTSvixVvep4U91iAblsixVQtZWqIlWfxMBn5qFrKH7oIiKwfsgvQLoIDw4SWlZALfa6F5TTzdzBnFOvTFS9oMl0GwNte26flRJVkz/0D/rlDFZXivd/cw9e
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e264ca1-0fb1-458c-5d44-08df45437387
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 07:13:31.6480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dd2lFzseZycs9iY8Y7gzgL5vOUcLcQZdiF7zmj9r4G6asIRDEUHfX3pLwZ0z1eLfUXkhbQGYxBCKYuESY1MpINfykuqpXtTDVzEG2/PSm58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR04MB993581

Added to for-next,

Thanks

