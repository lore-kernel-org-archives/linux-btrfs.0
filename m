Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795707729;
	b=ZhQbg1W7G8qopZQerdYcRDbrSr8HMkxrzzJv3HVrG4wNueTxvnjDJzAj2SxgA2nAV11J
	 9qgMqqVhh7FuRGWxeGwaUnLliiZyXNxJd/r/+8TAlRz8djZumrMDbAUXHUYa/daa2LqU8
	 MmaTFoV37fWHhWx90sv4yrlJNoYXcimFyVKhTIStLgXD/uQkzrOoG/UDobzCfdhcUHbVY
	 6evf41q5rEQ4RuaIo7tV+IlfRV3CVR3nVCovRPjw2GGrdW/NYi7IkVYLDsQRJnXUIQoto
	 +d1lfen9WqrMHvL3evkCzunt8x1gj6HDqXSmN+1GXl7ML8O8tFDZjGdkrLALro0vOLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795707729;
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
	bh=f8FzAuRIFJOVYgMqDZZfwFOr4pM7ys4HIeCsUpU/uzA=;
	b=dWAYKCkz9gupWLklzdcX7QW3DRtD3xAqBEVR8zH54A1Q32UJWe/rs4O3YIuJMmArqch5
	 YrW9TjyYPV0XNq5sB2yleSHz0W8oVXkSlahqr3AM8a3Z2ps/Xq8R8+IWsve5kBQLjVqUK
	 CqQ+Oc1U8uLPwryAYcUjxn56eVB5C6yARg3+vnwEGhQjavBr8YzyqrdIXajTd03SQED5X
	 ZgNRd2iIDdBc1qqWG4lzTHu5Cai+IXZ5rBPimSMyyK4RrmGFjNL/PHDSjuw0yp/sEpHx7
	 HvIRBLNZwxYJZCifMIP8r3bhItQgugj7znKsg0VhzFZxGWSjt8GZHvLteunnlN0qaag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=gF04tSt0;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=tXTKNmme;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713C2606A321;
	Thu, 26 Nov 2026 15:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 713C2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=gF04tSt0;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=tXTKNmme
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795707729; x=1827243729;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f8FzAuRIFJOVYgMqDZZfwFOr4pM7ys4HIeCsUpU/uzA=;
  b=gF04tSt0fECKYxgN6ZfVbzQZGHnfnFTv8IiUiQ5lMxwECGuwcB/eRgFD
   UFDiuQAbeDg3Kyt/SeINJw6/2ahBbD36RNDnfaAodFij07mx0sNNL/jdv
   DM+JJBd6p9tMRotz4nUQpAftp/zNVdkValLAXRAVXKzP+VoJQnEvfvuV6
   z3frlOjaW3/48WDlnXqJWl8o7zqwKmisS5/W8LxeZalKOeSRDebGqguWE
   SQASoOU3SvDF2OYjgcaeiNR2KeWQO390q9D5A8eqTSPEX8M7tAY4cRglo
   WOjxxtrCm4Q4d0+OAd2/pc3jdtMVQe+4LPZpDH7Riv6yatYoTq78Rox0c
   A==;
X-CSE-ConnectionGUID: LMsb54frRG6e4OwQIRDL3Q==
X-CSE-MsgGUID: BbdwAsFkSqKPpFxj71Mkzg==
X-IronPort-AV: E=Sophos;i="6.27,235,1786982400"; 
   d="scan'208";a="161837515"
Received: from mail-westus3azon11011034.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 23:42:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TBA9SnOqsaTseDINfqKOAPurBarE/caLxvZ6pnsUNqB89I8ZhdPovzQFW8QvBT8B5rLyAAHL4/TXha298AekgIYLo+EeUNmkM0qRlj8TyZCAJqJ1QGBRwzNaZMWm//3atdjlFyBzRVtHywbFis/rz8VQTIbi9Vw8hDSraQywiR9Tdve6AvdhafMEqCk+UzC/HwRo3jLTJpKaoeyROjudLzi8CPnn9e0PHuIw0G6O5fF4YDF1EJu+JWosl7+vuQWAjiHTusyxYwKPl1SUkozXcgUHigJVTCNkm7eZ7d7W1fNFo0SUdggsjMtVHRom9kaKlhGbT1Ne7vUEAd5w63oa9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8FzAuRIFJOVYgMqDZZfwFOr4pM7ys4HIeCsUpU/uzA=;
 b=C67eWL75nRA79LbhIOd6AAApnLSHp4ogSfX9kAmPwA6cJiSWzRm48ULusKuXwArhJ8erSf0aU/TLlR5dfo4IZzRfNxTu3tohBv/yKr2Sl7XpaI7t1SStGrQY52CG6c816A4kcIyMPJ9qqfAK32DggpqpJGajMn4DkqVvF/7Ys3XFfqfM0pS2Ypzpi7MCQn9F2k/lgT08e6wxQih8Pk9PpOS94aZ79lzPg0701BEVn4ModPKTjbBoUjBDrwYx/RcWZfkx1/CwoLhGtnIGb1pzWE/j7t0kH8hyfwyvWHu8O1Z3FoSzk2eivHFkt7WNFJbC7zhjfrM3dHgOELYhFJRuMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8FzAuRIFJOVYgMqDZZfwFOr4pM7ys4HIeCsUpU/uzA=;
 b=tXTKNmmerwLS6QlQCNMtdYXGsNQuR7H4xjpvb/4OyBpXuZGzSN0pB36IvQJpiB1DmvXUPufflYTcYBjM7Gh5zGxBPpWtek0DE9mc50p43vSCcZXxSWb8hM3HMRF/tbAwh7fTYNpEqjtgyb6QJih55KHOvz5ncU32BPKqcl1PwBk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993738.namprd04.prod.outlook.com (2603:10b6:207:301::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 15:42:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 15:42:05 +0000
Message-ID: <5130364b-be16-4c4b-a756-cd8fdd281a32@wdc.com>
Date: Thu, 26 Nov 2026 16:41:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] btrfs: zoned: handle a failed zone finish on one
 device
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
 Damien Le Moal <dlemoal@kernel.org>, linux-kernel@vger.kernel.org
References: <20261122232310.4099580-1-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261122232310.4099580-1-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993738:EE_
X-MS-Office365-Filtering-Correlation-Id: 817bcb9d-f009-4bc2-fd88-08df4bd3d275
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|23010399003|19092799006|366016|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 kS+BZ1uThHp69EfKBkHzntyeTrICrG09uCou1VdlHqiUc+RRsh1M0Ef+n7R00JLVRlgrdl31amFh4yPNYPjfsIXpvqhJP+1H1MDyM82PjevM8KYT3kK+Myg+Rg7juBwDeRMVwfjXJnclzuhmpfbzPH/TMVMpROCt3sZFCoVVACmBadTJvG1d3XDnx3bKdaGqobuc+uMiVjWUkMhJaXc/rB2Spm2oBAjt8oqcm93s716d9zxbD6GyfKJU5Z/6AqSMmbfMKQGw9qYAoRu0rPfVLU/uPlSngimt17OIhw1GQ7LK+3pcRqC3+CIlHO76l4y3EAnvebGmnh9Feb5fd1Ypb4IWRZMwCjXx4RsBu6om24xOTYsXIn90pTEkNTXr4RsruPRC8m0KWtVcinscozd6mu0A3GiJY5GbUVU6sX3RscEuh0kS4oT+FxhPKBFHcobyJVUTR51qZpecT2hPqwoCbJU8hWzAqhvY21dAvcXhehQ/VfbfhQLJnqlYxDGd8rtIzgOYL+ZET5gDdgM/yuaakAkteYzKm0y9PEFmHTw3Y7LPlKlJyOsHfA5AaS/kH8zKV2yGO2YFYsSxtRE5itxNh9xa4eOvp7XUvAUNIaowjjU1MdKJ55KPNHLZAJUxGPE+o2MRo60d4z2OZZiBKExJ4Hqxy3z8e1aZYEZPozujd5s=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(23010399003)(19092799006)(366016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZXF5SVBkdFNFUG03TnRGUzhwVkNwbFpCNGI5RUExeHU3akdBUEZ6NlpCSkVB?=
 =?utf-8?B?bHdkYzlpaHRSdWhhUkQvSlgvMjRud2lNV0JFVUZHWFN3SHpMWTJqUmpRbFBi?=
 =?utf-8?B?TFVYRTllL0JOY2lscUFkd012NExoL1JyamZ4dm9qbythcUdVOUNWQzExSU1O?=
 =?utf-8?B?S215V011eWlObHNsUzVtMlZOZ09kNXgydWJndmQvUGJUWEg5ZjVSZXBqcHFW?=
 =?utf-8?B?bmV4WDZ0b1A2UTNkVTIya21CM1JmRmhTMVNuR0NiNjRBdkZIWWpyQXNzOGt5?=
 =?utf-8?B?dzRUZDFudHlGaVlvMGsyeFNiQ2NIUkdlYU8vbjgvQm13WGkrNUhWOS8wZ0FY?=
 =?utf-8?B?dUdXb0lKeW9vU1k3U24wUkdFN0JQVGRhT3BlbE9GMGp2YVEwVWZudWVnRnc2?=
 =?utf-8?B?OTFGWS9WVlovMExxT1pDOCtIeTdwNUtZcURnZXdPZFFaazVzZWN3bkp0QStI?=
 =?utf-8?B?VU85NFFwQ1JDYTNhS3Irb3ZmRjVTNEFXN081OTVrNyt5TVlUUm1oSTFKaGk4?=
 =?utf-8?B?cDNyaVpWdmsvbUp1d3FpWXN2R29DQVYxSjZ0Z2ZTVXMrandKdXllK3o1ZkIx?=
 =?utf-8?B?QlJoSmZwSTkxOWpvcGtzN2ZTZytxVktGZGJMZlVhemZESSt3TVVJYTFHY1Bh?=
 =?utf-8?B?YWpsZGpoZnhmQ0E2UUY3Q28xZXZNYnJ4ZFQyRzd4RHVlV2cvenY5S25lMkVS?=
 =?utf-8?B?RURXaHB6WnBFcmJwSDZucVo4MmFjWnUvalpUMzFWa0U5K0pnNUEwbFJPeldl?=
 =?utf-8?B?TXdDWXlERlVpOGEyYlhZWWRRQndmWmVnTE9JaVRjM3Q3am5LSG9ucGVnd2pv?=
 =?utf-8?B?TkNnaHZnYnkwTnlVODlzQlBIYTRTVnQ5czVKUzFLYnFVdUI1czF0dUtIT0pv?=
 =?utf-8?B?MURLS2Z1bFRnZlBYRkp0dkU0SkVaUFVuR2w2eU5vZ0pFclloeDRwV04rNjVN?=
 =?utf-8?B?Z0JXZ1ZGVkJsN0k2TTVwYU10ZDlFaDBYQ1hPaU1wYW5NbVRMRFVlQ2xJNGEr?=
 =?utf-8?B?VThQeGw3enRyOVpKZldFclhoRDdwVG0vR1ZUU2VnZFg4a0tKZEN6MWYvdnZ6?=
 =?utf-8?B?Y3F4V0JuZC9VUW9DZ3U3OFk4TmxCSmh5WlZjcEdPODhocWFmTzFOTjIyanBW?=
 =?utf-8?B?d0ptUHI3dERXOWM2ME5NZkNtYXZvUWdieDQ5KzJ2VlNwMkV2SWhLb0thUWRK?=
 =?utf-8?B?OEJnT3ltRk5FeEN1OWhiRTluYXFzQ3g2TGYya3prZlowYWVyL1dkYjZBMW9p?=
 =?utf-8?B?ZmFPeXBhamtFZlF4bUtsU3U3ejJnYStuRlRLRDNmMXQwZDJFY0Q3THcyZ0Nw?=
 =?utf-8?B?LzU5VW43MkVyTmZncys4T2M5NzRBM0NzVitEZjRqRkJXNlJLR0V5Mm5kSnhB?=
 =?utf-8?B?REpILzZVTkszRno5bzllbE43QXJ6bmtHSy9XUW9ZVWJGVEFLQXM0eUdTVU5o?=
 =?utf-8?B?ZUVqUnhVbWJFeDJ5N1c4V2N4Mm5pTk5PQ0R3Nm5aZTFyNUJtYXFjT1VzVUw2?=
 =?utf-8?B?ZFdDRXl2VVAwS1RiRzNoSWh4cHFzYkQ3cXZRNEtSRTZqcDhBNVRINWlqTjlQ?=
 =?utf-8?B?MFl1TWY2eXFxQ1czeExzQ2JzSnhRdy9xbm9jdU95K1JBQ010QjlnUlF4RnpF?=
 =?utf-8?B?ZWpFTDdCTSt2MFhRRHlaS1p3OTZNa1dyR3ovWmJmS3ozYkE3Q2FjczlqWDZq?=
 =?utf-8?B?T0NyVzZEVDVralF3UlpFUnBSMG92VVVvUTRDRlFzbENZbnZ4WEVxdTRpOTkv?=
 =?utf-8?B?UHFabnpockFYay9vZ2hTcDRMMTFyNWVLSlRjeXdicXRGZEZQMWlRQ3M2UjZI?=
 =?utf-8?B?R1oyOUh5TGhiQlJVcDc5NUhKa1JjNHNSQmNCbzBUaE5iZFFSeFZYY0VxM2Zv?=
 =?utf-8?B?WWZqNEFLS1Ayb08vc3p6eDFiVkZGdHVSaTBYRHlMUS9aYTB5cFlMY2xTVXhT?=
 =?utf-8?B?MkJCcEYxYzEwVmI5bitQQ3h3WXdhSWpJRmFCSjNhV2U5dVRUTk5nV1F3MExO?=
 =?utf-8?B?aDA1LzhlNkFkZHBBV3RMYTBVTEN3NElOcUpHMk1KajJPaWRYZkJ4RFNoQSs0?=
 =?utf-8?B?QUd3MFd2Yk1wWW9Pa0QzYzJUeDhoU2ZpOGtFdXREUUNNOTc2TnpUSFFDTisx?=
 =?utf-8?B?S3F6bDlBblgzaEdXS2p2M2phbDhJTG1QOUtMa1puTkEzSlhDR2VTSDBhc1Zk?=
 =?utf-8?B?SXlZaXJ4dVc4N3VkNHdJdUJEUE4rbkdpWDBQZ01zZ3QwWVJmc3RRUjZNVUF5?=
 =?utf-8?B?ZkUxQ3FQcFVSR3ZOZDNkUjhKanZkcVorYXdjaTBzbnBteVUrUk5mWnhGcXZ1?=
 =?utf-8?B?NmxKZGo5TUI3aVkvUnhweHNsNm85QXZCNHJkbmZkUDdkaDBUcmJpQzZMWXVw?=
 =?utf-8?Q?LW3J/bt+yEO1DQwgmwm7L5So2GNaJcRf1s2CnhyLMBNds?=
X-MS-Exchange-AntiSpam-MessageData-1: w/sil5COFPkkkq1zEWDra1imqsOOJCIa5ck=
X-Exchange-RoutingPolicyChecked:
	WDtYCxtMHbxrY8Nwop54e8BJCoAnfkISw5HfhUJieAD9wLLKUrTMJeRsr4hzHbfUS0ML+ieshhSBE2eHE5a2pQ8gn3nwWoY16bj6/+NKK3bmySn+GEZlUMF3d2KLNVTMFy3HdWr+1x5ZV++u8rPm+DUUwizMJJQ2pgxtb9pL+Gf9Jpst98eU895djAGtm/1NGU1qXk5zoMG7dNHb9o2PBNp9cxLv6Vl4x9BZiUY1jWElAta7SUlU68M4oSSs4JYeNxqLurJjh1wLPulc03Upm+9rJiYpGvTpnI1F1dTw6dsBTki1YKrO7wRRctNnGd5ZTQheu+TnqGMTCtoO9X5Ipw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EtD3w63mzV0YUSdXoFwMG8/vkqd+Qg/yrAIe4tgovHyLwUxMFabPuVh7uZ31UlExImf4DHFkV+oH32Nw5LoZJTn6eHqXF3/GMaR+K0R0MPUQQR08tfP2DlTw56X+eYYrfH65j+9BaK/SxYflX7H5DgzEwXb7tjBmlQlGF2hq9QvwDtyhAIjFiwLPO9IUdDRyYXtnRviNMfWOKu8bnoOFtYPcH55YRAhGlYiSU30wwtvP5XhZgAeFJEwjfP0i/80xilEdNESZScsQXx8+oze9JhKDzYSnX/b9VDqad6Ck1wd/VZe0IFahrDFI1bCv4UuCpteaRPpvmthsx2g4vrPORhKZUROhXEhvS+lMEkEDkkTupiXNq0QI3bkCR41ktaLnUhNgyaeAbfjHsx0BLBXZi4fQ1WqaNdU1PveaM0llbHzjQX+rPBduhpxy3JFJUOkX9pyNJzgHgsJ4hUnzQs5H77bRat3G85rM89VKUaDlTJHmYAIZYkeEwyI6I1Vx++WGsEfU4qqww8SwSM0JmD/TAdtvXeRHvzNGtVb0DiFfFLF+qOzDrQWvAuZyPHSn48Z5Dcy/dSkRSyrJGTEEMwkNVZhHYwWSJctziCAv/yA8epwZZ/Ge6qKf2DhVWDorX973
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 817bcb9d-f009-4bc2-fd88-08df4bd3d275
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 15:42:05.3561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pOCgYTTKE4QUr6Ea8OOQPIkpyHVFetS2ePEhCeE6/8IitaEd7gpqLjyhZV4jRw85FadSbs0Z7sHd2GephniW1/A4sGGywr8nJlYT6rYWbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993738

Pushed to for-next,

Thanks.

