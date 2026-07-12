Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600DE3770B
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783848594; cv=fail; b=IywyyKZUdKnM6zPIIWq0JYAs5s6sY50BfslbD0vX5mJhq7ItkUL0+u5hl428LgK+Lalyctx6AfTWz26jG7PcR5OBKb2qpm/LJiA+MgeBjjKA+afj4s73Lvh4rYQVXXXUdfL/1oI2Q8JJWQupmEpB92KXZJo+vQ3HUlnyuhQUbgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783848594; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IBYtDNXLVoHMpttIZj2w0qVQff6f63O/lAz/d7EWpnQTiBRjR4mdB5eVGxcEUcv507QM0JXPpVoqBMyaGbif5fYc/4JzoJUEE7LoLmQla0tV5bdfxwhjycRO+7FbQxeAsGXiarVDBB0AqE6MkYF81Zybx42OskeNaSXDUtCqTxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=le8XMMaI; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JWwISYBn; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="le8XMMaI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JWwISYBn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783848593; x=1815384593;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=le8XMMaIjhfaRizggRMG/6ptFQDZEvVpgY3vf6ZZf38iLOPIMWDmmL/T
   IpNyp29QMBSP6GK+QJXSSMhPk7p47SWhl2FVzcnGIEgH/eRHa2nfRMUq/
   BJ7ClK/s2ddeNh4ok9NyYPdc23MzKYxrKa8uUXLaK6HN3WG1yfh7louk2
   N7FQOrxxi+kJ3dQaHWlM8CMHeZ+JYdn4cpLDYtmiRDhSPm4DuaStzybOn
   dNAQWi3AvSYSi4LyNe62Okg2wlPHmrr0KoRaQU7AEKVJlJVKcqble/DXQ
   ZXNG2l1CX0sW42CIvbilRaf5WYlO7CIAcT++8tE2EQKBVMHqt8zwCHEmk
   g==;
X-CSE-ConnectionGUID: IWhiYcSiR/m9Sn00i1Ln5g==
X-CSE-MsgGUID: UzapB2b4RHWrEq37gZ8WUQ==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="151773090"
Received: from mail-southcentralusazon11012026.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2026 17:28:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPW23PHjcM91G0JgizBTppQ/n4IpPXrVCXWBSLUoSZUBKIe1af4qtHuyQ9yV/lAMqqhdzyF2zZlYMCwNBO9kfbrMLuEr9cLREcaCMN8V2CJqxVtO4ts+xehQcfhdf7k7eG8zE33/83kSWAW5fb7IrwQjN12KE5LkoDaaf78bqkfX4x3K/MDqn52TpFzh+lekj0P6wNxkKC4NMxlSLTaGM0td7seNh4bcHSMKvx6pUhpRbnzzr0BuuSXRzgLnthMwLZvDuRML09t4xjDhIkX+Iw/2bYWrLgXgC/Dy/haXf3D9ju9di/Ph8jcfCtADSw1gRcTqPqwoG1V5RwHeWDfhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=kUwE4NblzynqELeBXx48zYLJMN3YlSfoucqHm5vJs4yelLE3PG8eqba9GLH0W9AWSeiJoAAjJpMGMj49hpEFJ4qch9WkkcDOZ2Ll37kB2DXVqyVNniC8YdyWmNt5tmKKOlkPKYVjATe1cKcGp/76J+4cVRG1u5iE90gmHrH7Amq9u8SEHPRdQOXtZ4OREZR2aGNZW8zmyM11EgvC66iSj1ejulGEWmdwHUu/ux1xyVg45Hn6vkp3W2sZLjBadPIoLg5SJg9H/Ma/YWRbqxslqKtffKM/zFf9AKIG49rwXyAeTfW3mdkaIgl+omSRn42kD0yD8lenLa+gjj8zzqdCAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=JWwISYBn1JA3zPErHY4J0wvJ2Byd1pOf//YxFlWjltewxi4Bs9Y+/KgSzgCRU27/o7ZrIdLkc+D/EFSvrKh7/xfVISxogOwmtKsHWkt03U10b4j1Fnu3iNsuS8QP66VSdThNnbjrxQPPxQ6HOeVOQ5O5tD9JAT9E2wMldSMCqmE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH5PR04MB9645.namprd04.prod.outlook.com (2603:10b6:610:20e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.18; Sun, 12 Jul
 2026 09:28:43 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 09:28:42 +0000
Message-ID: <e36ab0e2-47fd-4b50-948b-2d13a7b9b88d@wdc.com>
Date: Sun, 12 Jul 2026 11:28:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <60a629f78bbd03c07e8907101a23368722c47662.1783153727.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <60a629f78bbd03c07e8907101a23368722c47662.1783153727.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f2::16) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH5PR04MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: bcda2f58-1088-4398-5661-08dedff7f6bb
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|23010399003|376014|19092799006|366016|1800799024|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 /yuy4TF4xlhUhfulnpw34bOeN7ldVGAi3364eCiawrNRiuojIBf2xPkJsE2rh7deK9eZnyG8x05BjIMWJZLpMO3dY1BJwZ3zOEelu6JfG56vYqfA3AXL87aOfptkeCwa+nRdVIQbi/bu31Lh7S+2KsBdScmuEEZVz7A/PsiUmLjqCtfeqFerEYoNt3IvtT0rzgoqDG9U+HmBR8icE+Abrl2L3C6wPLx1sr0bNNNLXfQXxRmHOtEqy/UspZrBel2Zawc8Reuo6niaMDexobDt0EnPVNUdoCylTDaX5arUODILoklW2qIYsA7x8eaPtqzl5yOoSiBCCK86Ddzrvfa/jZvD4rkik3We1uTW3lRQuTwsf+y5WeSSL9H149C2NaktbhNzvkY2JqHcw0g7+YGBIh+Cle6MEepDs/saZCR+ExCMIjRr8BjVOXAPhkU8/z8+phwuGLBOB8OfrmKX3nW+zhyfOqrJgfQwt+JiDlXZReiB5dc/8RE1bbGm8+sFBqAPNcmz5gx6iyM+58SllQMe30EMXSaiusDcrNkZM1jwRpwQ+JDw+lEKzSKt6PpnPWtwNbOlf197dt8TbxF6ORbWscgZ9BATl6/tiFMvxXZEoNXxcMhdi/EetYNq7jZ/4/ByPOWEPgzUT9xDOAMEN632fisYz3YNQTJBegM1Fh71mEs=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(376014)(19092799006)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SlRmbjloSFUxWjVOVXNGV2RNclJuZ3ZmNU56eUpFc1dyZWUyQ2xWMHdoMGsv?=
 =?utf-8?B?NGtVbktvUFliTU8rL2tpcFd0VVdlYzY5b0xsenFITTEwVU5qU21mMTVhS0ZN?=
 =?utf-8?B?cjBVODJZQnRKSWxMK2pzeTVUczBVdmsvbWI5eHI5M0dRbDRuTFVPNE0xWU1K?=
 =?utf-8?B?Y2tqRWpWOThnb1FpSVVCR3J0ck5QWi9BQjJoWHQ5VVNhVWtIL2c0cEk1Z3d4?=
 =?utf-8?B?TTQxVG4wdFpDYWVBTDhweU9SRjUyL2w1QzN2M1hicFYvT3dzRzh4aWFNckZs?=
 =?utf-8?B?YU05ZWRYeDJ6ZnkzRFNxZXJQRVJrd0NaZ1FzdS9ScTJJb1J0amxTbExlM1po?=
 =?utf-8?B?d3dRczRMUlhqa1M4SWtVbldSdzJSQmx2YTZqQnJ3aGRRQ2YrbGY3OXJCMnQ4?=
 =?utf-8?B?eDlJZk1hc0JTeEZlMy84RUU5Ykdxc1ZGOVpFanNNRlJxMWFNcVRGbW5lRElL?=
 =?utf-8?B?NkJMTjljcnhQNkZRVDhBZWtnVERjTllCaFlVTElVekFhN1lIRVdJRlM2TXVq?=
 =?utf-8?B?azRqeDh1NXplWkFLc1hWN2o4dWdZVCt6djUxZytDRTJSYW1aL2xROGFWYnJR?=
 =?utf-8?B?WlphVU1HTmVqWVNXeElEOEhMMnNpdXQwYmFyTExCTHFBSnBQWnZCTExPUFhF?=
 =?utf-8?B?RmxacjY4Zjk1MDFCTWZScXYrelFQSGRRRnJrU1ZXU1ZUckpOQmlXOVFvem5l?=
 =?utf-8?B?RjdzRlMyOUlLYkdNd3hSN2hvNG9mRmlMTStGVmRkb3orQVNGWCs4NzhkTnJn?=
 =?utf-8?B?NUFWV25zQUVXQy9MODNMdmM2VVRzL0xIS1dpdFo3WjBEWTlhcGZPaUxoL0hO?=
 =?utf-8?B?d0MxalgxSmc5SU9zcDJGUEwvVkJobC8vT21mK1dtNkh6d01jZ0o3ZFFqRUR1?=
 =?utf-8?B?UUg0V3FVYkVlQUNobnlqbjdGOFBrNU5hbmp3U1Y1TStMT2xIOUhvZFE3a0Zj?=
 =?utf-8?B?b0RjVWNJcHc2K3Jjd1FDTjh2Vy9CbVAvZ1hDTFV1Uy9CMjNDbGl5YktaRU9J?=
 =?utf-8?B?am9hT2J2VjRlL21ocEtwVWJna3dmb0FlTHI3Ri9xcFBqTUVVQ01CeVVBaVRD?=
 =?utf-8?B?TXNNcjhuSDZSV2ZaVEhMcC9xcWJxZ3ZUU2ZpVzRIRlp0dnJoOG5mckMvS2lu?=
 =?utf-8?B?QnNQT1gyR0x5dkJjRHdvUStKNlhnL3ZXSTJWZmxxZ2dLSEd1RFBGWXNmb1N1?=
 =?utf-8?B?OEVkREFnNnpVV21WcnNPUGRHbWcyWEdZdStTY1V1a0VGL2dxcE00aXZnWmVt?=
 =?utf-8?B?ZEk3YklxNWJHSUEvNEVZMWdYd3F6UnVlWUY3ZFducXpISGR5MFZQT3RVY0lS?=
 =?utf-8?B?TWQ0WGtEVFI1SkdhVjR0MVhmeitXMCtEQVFObU9vSXY3WnJMZVFjQlFmVDhV?=
 =?utf-8?B?dlpRTjFvOElWdE12L1lSLzNXbWVPa0NlT2JhRGZCbUg1cGVldjlTbkpUeG5u?=
 =?utf-8?B?ZnZSQytpTG4rSDQ3QU8vamg1Y0JicW1tdEhicFFyQUQraERFZGI0SFJIMDJ2?=
 =?utf-8?B?WjYvZEFjZ2xaUnA4Z1UrckhCZURpSkNXbVozRUV0NmRpbU5SSWFUT1dLYUFr?=
 =?utf-8?B?S01xTktubnMxc2xwSkFCT2FpTVVMSWlrZjlrYk1BMUhJeW1KVWJUM3JsN2xB?=
 =?utf-8?B?U0hzODdsN2ljR3hiam1OZmdhQTdLM0NiYUYrMERZaGlpM0ZQcldFbmpnbFQ2?=
 =?utf-8?B?Q0hhV1VkRWpWcWw1Ym1jNjNuWFdhaXZGZUlUODlOc29PNTMyVDkyUW04bE40?=
 =?utf-8?B?Uks2Nml3YVF5QWo4VytnWXNveVQwWlR2NER4d2pBdEc3R3VOUVo5UUNPNVgz?=
 =?utf-8?B?OWwwQ3ZvY2VsRWZJbGtVdDZtTGdTZWh5bDk2Yy94T2dBM2VDcHFjS0pKWWMy?=
 =?utf-8?B?bEcwMi84ejUrdnF2YnVQbTc4YmsxWnllTlBQTDZ1MlRuemVxZEVKV3Yzemg4?=
 =?utf-8?B?YnZnZEhQb0J2eDQyOElmRWFLRUhOSC9Ta1l4bWExNXN3RlM2SllGODNvOWFx?=
 =?utf-8?B?eU5SOW1yeW1pSGNnMkg0Rkx2TTlWK3JWb3F1WmY3UTJvMG1OSVR1dEYzWGxl?=
 =?utf-8?B?OHVzcHZQa09rekhPV1hVSDNpcTUwZnl0WlRPZzgwalkyM1JUOW5ONEh1akVS?=
 =?utf-8?B?YVAvL1VuSmc3MW9KTlY5MHAwRFdSUzVLQk80L0syYmF4c0RaTVJqdGtwdGI0?=
 =?utf-8?B?dWN2S1R0bkdjNFFHM1poVEN1MFJBUkVYdnNNMUtrMUVDSGZXREdtZkxLR1NF?=
 =?utf-8?B?Mk4xemhzVDk2T20yY3lieW5PZG84YkxXN2VQWTdtc2l1elFlR3hZWGZseE9Q?=
 =?utf-8?B?RUdPL1JiY1E4YUVySVNmSnNhQlVqWllVQkhNcWU3ekl3MGo2dG8yUE5kTGtt?=
 =?utf-8?Q?bEqAfSnQ7lwye605WrJ0i/dLOX0wHJ6N1pb7MqpOsuQ3J?=
X-MS-Exchange-AntiSpam-MessageData-1: muTGmiux8UaLapDI1VI4OzgAUpYlr3l45XQ=
X-Exchange-RoutingPolicyChecked:
	JQ2+FaA9hO7bnjqYhkjiuaehGmJn7BKFBVYRGF28fShPcxP86ZIZ9Eqw8mweZD4AO33bbpc56r3C+Cm2jphUC6R3VnrklWL6eU4WHT/ry/GD1Do0A2U+0Q52CztoiIAo0Hx4LoS9GJe60KedhBJtPmv8vlsUMS+aQr3DRygWoPBfsrt4edLthzhsZfaGzZQGJIBKlsPewfcj+njsa+t+1fjltNeOE9jxIRnnd+R4nUEKiRCVBhQjSxYHSFzICBLrr8tKZEUc+YhCVIrO2/WeIYa9nOlBeJtqsd/HFvCS52qFk8fsG9wC2YCvlTcgGad+MqfhW6r+90WT6c7xDAb3uw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D5S0HdL6eUymwIEqrygRWQ8DmPTHmClA+H8cjxB0pPKscVeJ8m4DorqNweuqmads8ZYl0i7HEMr01aYdnYcsh48xurKjtcxJ/byVOblSBGoZaqdDouS1ES3+8swuC67B/YuxKhyMt2fcNYaZZKK3u1huxt/Mig2DXRKhS0TammeRz7JTV0d5fZG/L3friB7dLv2g/+y3T9RQTk+zOAYs5KDlBoJSmODaPEmV+e88YLBSI1rMunKw1ZTOU7UMEXznMc+TyQrhgEfje/RlI6I+Y68ZVccCRzi52w3i9RX7HdnygtTpbxCrNiC91fw4kvhQiNN6OXe1G5YUjibD5LW1RFP8yxZTYva+zhkvUNwJEWcMww2DdDqmV4m5B/4sfNzyZKVUi+1QrF7f+hCfaKp81gNQhXscB0kPEOoJqv4SAOb2epwO87p/wqnewGdAa4JT/hdfTd110Q0REwmM6EHMT2X6GRmoW/PJPzUFs9KnokmjzHR5P3q4bj14FrGWqxCDD955fcXTfZQxRVfsQhML24+RJxfp6tixtDIKNS5cRYutj6P9xbflHUTAmS9dtgu88PY2GOCsBHYJF6wuSOqJWE83XZ5qU1DK3+pCR5ltWMNhRYjpt/UvDzIWTNGee3hX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcda2f58-1088-4398-5661-08dedff7f6bb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 09:28:42.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJgbZQKFpu13l6S9liaC7re1alSKE3BaIA6Za3Srv4YOa38SEGcw74m0BYjuyLCO6ENM0BYV6EkHorS3slKAJSngbPQgJJu3eWLVDMD8Q3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR04MB9645

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
