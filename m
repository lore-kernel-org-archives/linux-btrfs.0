Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795774568;
	b=OD+dS7qLwRkmRAQeQN2A6UMOOfjjorTECh7fmM78LIQKOfQEguLm7nSi0gtW3MR5mWMQ
	 9fHMQ7QIDTzSYAym5kWEt0DjV9PKWpzwIB56VsEZwERSBTzC/LE6zcQTpmD52rFFlXG4B
	 cBQfJqDEmx8vd/tl2A3vZlKmzs4nspoWStNKfWmQMeVUuJrasxMJBiAlohHtM1iw4ZoIh
	 So553rHSU4m8mcfRJ12cdbJxas7h0fvobC7CA2lROX8VLOEt5LkuvUi0XuKqBLpyAth2n
	 O9JMuJ36t8BhSSJqoZuwP2PmFLxlrx9xjwR3T9vm6IrqcJ4UGVwlOtMddU86hagclUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795774568;
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
	bh=JcYqZl6oObow+rHlR66DLlwBwM2PcDqRD/vd3lJ5NoU=;
	b=HulpePztemDvn1utsXPmCV105I70a+OgfU3eTm9WVIJ2KtzH0/v+I5daWFlcjfw7Ggj2
	 FUk0aaj34RANrWhFCSa5GEUOVjClQLbuRlGny0oTpgffcH467vH5F4MJYUzwrrZrdSCPB
	 zzQospJ2YgqSekh4o/gKK/o3h4+cM8QdRlrPo5JzZV3zLWqWxEmDwLRdI5NpMPh82y+9P
	 +/bLeeQ2aQ7Ke5kQhXluQDjp8D/ZInMTtp/FzGBNSHWI+g6is16pvIQj+QD7tjLmFCF/n
	 wKMiXQ6lIpi5EYwiXhjj4ypom7oy7iqsFILPr9gq+rIish4mDZ96v5r0W+Ndf5GG6sA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JiZBee4Y;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mOCRFYiU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310C9606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 10:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 310C9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JiZBee4Y;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mOCRFYiU
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795774568; x=1827310568;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SEvLuvnRAjYmdivKP68QDvThkdvArEfZtStt1n6gDY0=;
  b=JiZBee4YiiU0Ln3xRhUVVzb8zGnYyrzWSZNU7UpFoJbRnlcsupqDpAtw
   ZuqvIqg5TaURk/MlYkzAJVfvpCrVLcpVrXCJZd1gJkccfw+NVHFjObQ6r
   FqrtbcgS0+4JSN/bLHxefOlX6CLZV5c8v3vl96IvQs9g1gzC8WVNlM16g
   95xogmjJw/UoLbc10tXcITHrFbgSjf1cVvHc9kOrpbda9RQ6+PZWmi9nA
   PtszgVc912LKN7EjaKQ5sAIORMblCZkrrGOZo529sr+umE5JvNNjxM5U5
   oDNci3f8lyo2fyEkr+asuAwckIwdr7ROxN3UAxULaIDDxWO09lwrNTGoc
   w==;
X-CSE-ConnectionGUID: MEXuDIlMSK6Ym+4duc/QYw==
X-CSE-MsgGUID: aP7e+93UT3K2tKEjVk4Bjg==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161829760"
Received: from mail-westus3azon11012064.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 18:16:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wGIJe34dp07C+p6VGFS1adlcWwhd/Xu2UC234KGzudy2oJwsDTt32f088GPqU2z8TEln9K59yEuzzczNhJYrHUDdfjADe7pyjbfO5MdmGw94ho6rHfyNm7m9BWaWgF+xw48IWMUz8TKMQUXAV0ck6siU6jaw55CkGvJb1zk2XbsPb60xDiDu/98La71HnZU9/JvX5iEy6GsvEh/dCT/WUk0tWuVn7fVVRjajOEho3U4CmFcLKYaW0N9nlkml6Rcnx1/gcq8nIFz/8L6D+GD6NE0VBub5BIxr5jqQNsyDtzG9AyrEb6JOjkUIBpGqsQa1QE8s7m9pUE1S1jbrjEVqFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcYqZl6oObow+rHlR66DLlwBwM2PcDqRD/vd3lJ5NoU=;
 b=n9AssW8Gi1jAh521dRxeYzglMF8f0sQv2Tzfz+Zz3rPuZbjkbnZ0AYlC/vIki1VKdYhec1uThZ20op/t9SVHx2JaQduIQPrj7q4ZeznbtZWf7tGw+7HQKEFet5TWEzzoz1wDzZ/PIvjK1vEn9JJc4jm2VerGhDlXYdomQQpiiJYkRLjk2bVkt5xj+XBPIEpR6zVu+Vu22erKFn6U9B5pbiDgECEaA3nLCf6cgVrvxH/GlkR0Dyd2KFfSg5cohSY6GSWCriRlD9zerkmULDSEqhp8DGg+SCjBzm2iGoYaYC5Q0SZseXxr5QrBtU8bxH4p6+5H01T3Ud59UXl8MM5v3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcYqZl6oObow+rHlR66DLlwBwM2PcDqRD/vd3lJ5NoU=;
 b=mOCRFYiU97s1/29RwhIg8dVTdqDdncp0btX4CsQJURIYBLfK6wnMMlKVMl74Bh5nV8KOQI/ptv7KtG9mz6OgPdbRKe7bYO0WQdYbo4VathLbHB27HfRSct0/b5QWrNkxjqOIJI2y5K8ot9LJqlTKokKtfq4EiPY+MLad8/XnoKg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV2PR04MB9810.namprd04.prod.outlook.com (2603:10b6:408:349::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.9; Fri, 27 Nov
 2026 10:16:04 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 10:16:04 +0000
Message-ID: <22db6fa4-c6a7-494e-be1a-bfae29231713@wdc.com>
Date: Fri, 27 Nov 2026 11:15:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] btrfs: zoned: try to fill hinted block-groups
To: Damien Le Moal <dlemoal@kernel.org>, linux-btrfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>,
 Wilfred Mallawa <wilfred.opensource@gmail.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
 <20261126132820.570379-5-johannes.thumshirn@wdc.com>
 <27d2151f-7806-4bdd-9bfc-3107a04bf0d6@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <27d2151f-7806-4bdd-9bfc-3107a04bf0d6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0243.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::11) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV2PR04MB9810:EE_
X-MS-Office365-Filtering-Correlation-Id: 8501f71e-f592-429a-695a-08df4c6f7178
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|23010399003|1800799024|19092799006|10067099003|11063799006|4143699003|56012099006|261026140227099003|261022105027099003|261028144727099003|18002099003|22082099003|261021135927099003;
X-Microsoft-Antispam-Message-Info:
 iubEtk5io1uXy1GxDlBbOie4fN9maEPmjsyCsjt2SkqH/pEASbdww9N2lYS4kfss7kzAyD4UOyyna44giKwnCWFX81WeTa6UleDhr46nkffpG3de58lll8O+GfiyUryuoHp0lEMvEuteoLn2S8Ri7DuOpSaeOVVJ2ve/d8X+CIAh6WexBlWtoeUSJoDYMefsbv/LCEBwCw1lgt4i0pqSLCfKO30f+kRGdfFKw8waWHcB4nuZzKf1Nr2NrF4ArHkjsQf2QJUHwhBljSnOZ+0obZiXFFGBYrr8cfKxIf8WMvVrTX0mMDf7Ui2LUDNmXryof0wn2MkXVDAjt8kvWWjEBlRbKEuRieq9gcQEh/TeElbgkaYTlw9XefWB3ZPWFGbLoa+gKtqdu1oCq40hfLV+BSrAzYfD86KQHx3lvKTbNNM9zJxlBwU6piUu70iOl8S1Lw9SEq/9q7lWmghTp8b4p4UtVHK7rsyKK6pEg5NpZYmrzY873Dm6BYAogy5WNPZ/K62RsDUylGbtvMZZjVWbdTGmlq2uTQ6Ojr7X0u0j1KX37WbGqksuAbHW11vIo3sJGOiHLCZv1On/2e15fSExeQiXvAav4aF/wn0FRnBfBUngf5mTATfdfqqh6gt4cgZpt2xH0Y+GIEvNxU5vDE59mkuXQvy2QDqiotq5Tafu5Kg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(23010399003)(1800799024)(19092799006)(10067099003)(11063799006)(4143699003)(56012099006)(261026140227099003)(261022105027099003)(261028144727099003)(18002099003)(22082099003)(261021135927099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RStlc2ZsTzJnaU93RU5OOTJ2bDc3bXFybFcvM0Jod01uN2liV3JCZEkyMHRM?=
 =?utf-8?B?QVJFcjBvOUVjM2VtM2FUNDZzR1JBSmozMEdjZWRZOC9kb2p2b1BKbS91Z2pn?=
 =?utf-8?B?ZVdlcDlTdmhzTFV6YTlvc003Q3RZQ2l2Y2xWaVhzYjIreWRuZzNveE1yOWVE?=
 =?utf-8?B?VkFiMU5sTjBlMjNLV3k3R2E2c0VFbEluU0FUbVVXMVNFNWJYemJkWnl2VEs0?=
 =?utf-8?B?SEgwaWRydXNqbk1PVVFuaVc0SzBaQjJwZjFRMTBUdnZiYVUycjc1V3NvQWFH?=
 =?utf-8?B?MU5DQU5kdUlSMTEvZXVucUdjMVUxY0hkaUJGbUNkcW1UK0tHbXZxeE1XS00v?=
 =?utf-8?B?cENxRkM3QWh5Q0VXcXZMbDZnM1R0MmNKdlVzRHB0cUZnMzV4anlzcVQxbmdl?=
 =?utf-8?B?SUR5S0o1YSt4TllrN0xWUWJHa2hPTCtoWlRNemp6ejFWZzFrajNvZ3NnbVU3?=
 =?utf-8?B?ZnkrZVdlTHJtKzRMMUlMWmwvRUlKNmNvUjhrQkdzWnVoRTd6Q2YxelRkdG02?=
 =?utf-8?B?SHBmWFVINmlmYjlEOGxESFNNU3RiK21EeWxqc0FKNnl5UnBUNHNDTVdSa01I?=
 =?utf-8?B?UFRWMEROMGJjL3ZMK1NJNkJXOVdXd3JEUEh5UWdRbTJXNTYybHFSc05ueXRN?=
 =?utf-8?B?RjhRK0dVVWR0VzgyNzRzaW9YeXlKRHREQTNzZW9nTmVPY3B5RjZaTEVIQVRs?=
 =?utf-8?B?REl0elViaWp6ZWdNb1lqdDlmWlNIcHdjTUN6bFh5SWh2aldPMjFBamNxYXlO?=
 =?utf-8?B?Nk0weGlCSDh3MzB5NWJnYmNkQ0tkZTNOcTBtRzhJRnJSWEVKUWhsdytEVERY?=
 =?utf-8?B?U2hrMzNkcmVLYUpZS2wySks0VE1hTDJEN3BUZU5LaDFhaFBLWWJFeGRxbkZq?=
 =?utf-8?B?ZzJTbmVFNlhuUWdMRTE2MHZwTWxYeEUzaHpoQTMwaktRVWlmdlBhSzJTV0VN?=
 =?utf-8?B?SHBvZ1BrNmMzcVNxSlp5S3NHMzYwUHZCbnJmOEdtcEtRZmRybVpIWXp2bjNj?=
 =?utf-8?B?MG1Mci9UOFpOdDdjR05uRGhZWStBVmhrc0FvbnY5cm10U3lqTDZaWTQya3Vx?=
 =?utf-8?B?Nm9idW01V0I3elV2bnJzVkN1MHBGNnNnSnB2RTJhZGp1K1k4aUFQenhCZWF5?=
 =?utf-8?B?ZmJReFlCbHVYU2psbmJhNndSVEIwU0RWdkhNYTZHUXJmdkdoNUVjS0ZjaTlU?=
 =?utf-8?B?MHh5Nk9ieitCTG1NMCtOYmd1alNpM1F3VXB2Ty9VUUQrbEFmMHdCQzE4WC9R?=
 =?utf-8?B?K2dTeTVmWDNJZTJhRlFpVTkxOUhUWC9YZ2MwcWo1bkpqUmNGbWRYZnpxT0h6?=
 =?utf-8?B?V0JvazJKZ2VlOURjK0g1T1pZKzU0UmJxc3Q0dk1DMGRaQnlraHc5ZnFQeElF?=
 =?utf-8?B?ZXBYM3VqbExRV0U0ckZGMHNwWkxLc3BjMEYzYXN0MEtxb0tEelNCc2JYbWYv?=
 =?utf-8?B?UU5HU2F2aXQ4QkdmK2hjMFJxa3QzSVJzQjFMUmc3Njl3Tzk5TjVMYUtsZ3pp?=
 =?utf-8?B?VzUvWnc2c1QzamI4WXMxS3Q3QWpYTlI0YlVTdElNMUdXTG5welBMeG5NekNN?=
 =?utf-8?B?b3hrQ2t6dkhlaGVrVEJ6dG1UdmtKV0Eza0p2RlBXMm9ZSnNzMEhxLzJiRXNH?=
 =?utf-8?B?NlJvRkMvTmZSRVptNkhMYVhkR01xWFY2YXVHa2lBNjVZM1l5U0NjdnJUM0dt?=
 =?utf-8?B?eVBidkoyUGdYTWJ0VFBGaVl1VXVBY3h4QmhqeGNFbG5obHNrNU5RNEVGKzRn?=
 =?utf-8?B?d2NEZWxTT2VnWEJpam9ZM2I0RXpIRG85TUdLMmlDVmh5bnRDRGVXNnpsNklO?=
 =?utf-8?B?YVBLS2lKN3JsOTk3K1d5YXdoZkp3QVdHV3B5Z3QyS05uRVdRZ3Nqb2Q2TE5k?=
 =?utf-8?B?T085VGJMMkgvZ2E5ZjZEU2JwaG1uZFk3cG5UNU1TcVZEL0JPVnI3ZlhtNGhi?=
 =?utf-8?B?MlhRTlN3eXhjKzUzSTlqUzdHMkhneitFUGczUFJxZlNFdzNsckxmaVQ0QzlC?=
 =?utf-8?B?a3RkZUVpNStIUnlRYzRrWlVmai90emxndForR04yUzZraElDZDV3UVl2OVh0?=
 =?utf-8?B?UmhDZExQZHRiNHYrMHFXT2k1RFZTbldyNnNMYStTdTdjYWU3RjA3c08vbTQz?=
 =?utf-8?B?aGc5NGVja0R6dmxDams1RzRZSlJuVVR4QTI4VGc3Zk91b1hZZVpwYVQ5ajZF?=
 =?utf-8?B?aVFiS3JKSkRjbCtGeENWTk1vbG1EeDJlUWVwZUFLYVdwcURIQlIwOXdwUXcw?=
 =?utf-8?B?V09wQ2hFY1loY2lUUUVUeFBGSnhjVmtoOG9BeFlHeHgxeDcySnlBS0NPWFdj?=
 =?utf-8?B?S3VtUUNJaXN3TlF6Q2ZpWkRHTmMxZXdTVVNwRCtmSG10ZEFURFFReW1UcE9T?=
 =?utf-8?Q?9U/nr8Y4LDYcVrvrYysxMlrD//k78n1YZlUDg+ONQjhH4?=
X-MS-Exchange-AntiSpam-MessageData-1: /LmTh5V+Mh7MZwmyX24fl4fsOrDiW2urWoI=
X-Exchange-RoutingPolicyChecked:
	hFsSpRrWQcevnBeVDQKAOZaIn0xjn35S7ocdp6nTtjbSXCUDGLl3D116QLG8eH1LjKThVip5TSy1V8FXs8uQFqplDM/cU3qEgoiATW+0Ai8I1HDHvDcAGvyMFbcpxiUMfprv+29N6EB1yyw+FWgUqzXRbshG+jqBXhIv1G19l63weu8DY8V2nuP71sPWz8R6yaPJTNuUR44qpNZYX/kB0Tg8pcAexq4GRbkK0AYbWPPWCFENO/sK+2AEx7EEUWMg9/IBCzMI+NfQ5l41hpQII7M6Ud7kLrt2S1l20Pmq+NlwszLPmMQJ4NViq6RWJfRrevWSRkxv2yOoUbS5Yl5RIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xcOT3FJM0Cd+sYn5vmlphxanJ+dcry40vKxcIptowc7p06wdKL4w2uVUYhUEqArKsKAZam9zxuMRvBlDhx8P+abv2S2q9fb8YwfvNXXXHtr6kDRZ1V30QDPfzV6X+P/1EqewCG2oSZySEVsm3Z2gelKFOhTuMc0KCq9+cCXULAmAnqzzXXZONLmDrgUrTCCptNCl+C8H/PTFmfnS7P/zfYyov0HWD6Pon5QbRrd+tHtNZUZZ7172ab4+SpZfFUTStT4uOqtc4aCBLIro30t0Y1KcFKFdsuRBBDYiEKC6PKENcFqrrPAop7v4AvXwD6RmelIRF51WuRJZ0WfAqmY0IG8xd6N2a4Ps2/46rep/Wqfb/tF2y1V/RuOEwPlEUwjcUJgabF2jKgeF6l2H1gLotBuIRaHskrguq6lhJ6RhfFZgpo4X5gvrClEc5BH40F2YD2xJcqVZUG+v4nb2PUhlD8qvSk6l4wHdihsc6Qy7MH7OBQpiGl6M6rjIfmLzlPJfNCy2XpmVsJ7oLxZULqXX4kVl5fDRX0qE1JQPmK1e/YD9r4Srd73EaOzmUdBd2oRrIXuCFT26M9b7444QD8e2PDXcjqHbHFfFPxtSSGwQgfx7VVrFe4xMIKEDNkqZaiK4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8501f71e-f592-429a-695a-08df4c6f7178
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 10:16:03.9723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQirXU1LaAZtvBFxXo6qdeLItFFOHeXojFOzV0VkhHA+MHJ/vYdZySvhdxKOUbz9UcLxbhWr2dyqQRxSIdVoXJqI8Y2JtWYiaHz0XIrVT40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB9810

On 11/26/26 10:25 PM, Damien Le Moal wrote:
> This in_range() call is being repeated. It feels like an inline wrapper for it
> would be nice. E.g. something like:
>
> 	bg_contains_byte(block_group, ffe_ctl->hint_byte)

Yeah I can make this a follow up cleanup on top touching all of btrfs, 
as I suspect other files will have the same pattern repeated as well.

