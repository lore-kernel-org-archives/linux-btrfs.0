Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F42220F2A
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 04:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787892162; cv=fail; b=bByKbeEajsGsg+mV83hsU7+GLi5/MZGEreNwrAmXNGr1wIsznhN6CuUDy8ylRUZ17rRjphHOIhUoKoSodBuxRDddjr22DBwsD0NYwj1UrUkzUzaM3qz/v4bTfGdlZUbzzknQW0GKUPIzfjw2DK2qFrf1DckWnJu+Ss8iFjLKjvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787892162; c=relaxed/simple;
	bh=5VVSq+tQwQnEQoIHUzh50lFHwq84PCpD8N+3lx3eeWc=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=X9cKS/xfc0og/oVRRUkq5bStC8NhAnL3xir14YomPrw1C2HC3zOEF88aVgIJ29BoYLsEpw5Peuu9PjZPcQQBDDLMOP25HVSdjRCgks5xMbzITADerAInCOucJu18OHiDZ/1D/9jrPosHZLrKi6d8eTZlsg7fm5HlFCZ++vZ6Hls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RcjQorqA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tWNHHSZj; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RcjQorqA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tWNHHSZj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787892164; x=1819428164;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=5VVSq+tQwQnEQoIHUzh50lFHwq84PCpD8N+3lx3eeWc=;
  b=RcjQorqA3JpWpVEk+jAv4Cq+q0GjSSjdUTJ6TFiHGAJWECirN6PrtgOA
   X+z4XTPEUVcvCdaeKf9IxvunZRi7Fc1eRP8Jg7w1nPmEFcT3h/y0YVnBU
   ATXu+wBb+bFcnlaQyzmDW3J0zQE14es47u15J07Hq6whIixMKvSiMd8tm
   rOEepP77+NTSkqv6X7pVdmQb2i/h6fR2Y13FVvgQ6fZCL0Cg2YLsEBf0b
   GP78BUt6BRloM+rfa5RdEj9AI3lCFlSTqb/ueQV2Htujil5vHzyEC4jZL
   0Q8YekgvDEwESNRs+xPJZ4tiepOfAaHJEZfbdhuuebIQyUoHuMtlZAZLE
   A==;
X-CSE-ConnectionGUID: wVw12zNISY2omm7XTpG4LQ==
X-CSE-MsgGUID: LvGMMnONQJq/Gig7EbyvxA==
X-IronPort-AV: E=Sophos;i="6.25,247,1779120000"; 
   d="scan'208";a="155356117"
Received: from mail-southcentralusazon11013018.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Aug 2026 12:42:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qJBELXBmJjRNUCfCCWtwm9HenKL0RLyazS40uUC7q1NH+TpH9BYxnpE4DDeaa+2WhrbevK9F6ZSU7OiyvETXBq+LEwmqTGz1k1/jmQbtZMrSUmw7kR1sdSnLmv6FWmqZrQAKIZ6gjAJTKTaQ6ow0v5eeR6jMYxZCXwDu7oh38Dnbq4NoOMa9PmPf1UOtAfiatUsSboU95AB5C7puNXYNgIV0EGmVrAel6CWxnIR38c/2rBH+5fNv96luhNsZpHwLGj9O8miQsgN+M9ciWanzyz1sSB2TfMT0Fnb+4uJmCv8Yj0rptW3Zpn5Tc4V/e2iTZqw4RKiusgWdCOI71sS/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgEvMJojwCwK/0hF6fK+99y0Al9BiHGS0zKk8kF6+Rc=;
 b=KK0uU7coDwoFZCiHRdSbqBoY4dV5YZX5/QSiR+e6LYjzahprxWOiTowA4qbmt/Zf2Jd43l0/gqIY7Si3u5BH0xFSB6FqG8qq+ZNdGcjRCqAWEtH2yGPKgsSCQSFo0V52Jtu8/XlbE6YATxitszkIHh6X0xE10GxQyjfHtf/ane4RYaSG4Br6Xc+TtyCqJe1gKNa5jUE254O1dnNCrxnHLiyKhC5CAphO+exvM92Fc6L1h4pGUbCqQbCdgnI/+54QdsLfvlf+Pf94eu43AZzIUU5EXxMiHlWG5bLOuN62F/DVrqxUBKCJgcn/cgbfM1cv9wgLT/6ogX3/Y80zGP8yAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgEvMJojwCwK/0hF6fK+99y0Al9BiHGS0zKk8kF6+Rc=;
 b=tWNHHSZjZJMyae5dW2Zok9XHdBZycEO8tqOo4Avuj8qs+YUj53NY5nIJ6UoODsphQ2+8XJNt7v4cS1Wjwioct4/lL1ZVjKSFfRMSjO4KCYzIaOKBIQBUtF9yf173APWIyRFhBIQzosiy+3ulVaoV5nY5mEcjEHudCT1/3sRKy78=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by SA2PR04MB7514.namprd04.prod.outlook.com (2603:10b6:806:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 04:42:31 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 04:42:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 28 Aug 2026 13:42:27 +0900
Message-Id: <DL0AVDP5O9C2.1VT2TYQXCL4B4@wdc.com>
Subject: Re: [PATCH v2 1/4] btrfs: zoned: track only sequential zones as
 active
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Dongjiang Zhu" <zhudongjiang@fygo.io>, <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <cover.1787717573.git.zhudongjiang@fygo.io>
 <c51aaf7f4621dedc36c275bfa9ba1ec884de09c4.1787717573.git.zhudongjiang@fygo.io>
In-Reply-To: <c51aaf7f4621dedc36c275bfa9ba1ec884de09c4.1787717573.git.zhudongjiang@fygo.io>
X-ClientProxiedBy: TYCP301CA0026.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:381::10) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|SA2PR04MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b705103-611e-4d97-f7f1-08df04bec58a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|10070799003|23010399003|1800799024|376014|10067099003|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	oD4IEXxD6W37fs2biSSmPSoJ72VLl9eGLfB0gbeWKvfAFIey0QLHBsN0g2UYmdylvaCq49DUokZ0+CP7MuR5ADB874Md2+l19oGFfHLJfd5uNfk2gHTigF7NDtwHlrNbNs0arwdDhPQxhJ91yWZ8lsbhjsOk22s/AHy+FjjTmGaQB/LA+PBLSWUwmhDyFSUZvGHtq4y02xCp200ZdJWznO2csHMZIsvRuxD+nOBkB1YSQF2IE6v2KPfpSrAR30mOXH+qTz7g2X6lhATLlhX9X6abRONFiUKhemgrXsKzHVSTc52yR4EUijO/ZZ82q+eM2cHYqRYczDjJC+bm2eaFUicYmLB/Y6wmR9X9Bmgu91LjqXOrCctGpSNmAaeWKuKMUNN/uFCC9aAqN8wZpsDVIt7hNcYCnROjrL7JqU7kr9tYm/lLCuOO1qhlvemZ+Tzpoua5JFSBgIy/nIvKu/kg4AKCuzvSUCO0E9aitt/U3S0RTk1v12yz/c7elCoqZg+wKqEJbcr/Jkos/YuwZU71L2E0q/M4uD7y/RMXqRTlOp1srl8alkz6wG7cDESfhgruqOSmFxN+ik4ymGZfyJiByCkA2GliOZucdY3nKMwOwoYiAZC4bOcrsPGYciqyiMOP4aiAXUlTeHp4VerV4Ux0k7Not6UdJhHeYn2lgj9yRJA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(10070799003)(23010399003)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1N1VlNtSnVhWEFDV21EWWFtY1Bmc21kSkZWZkZjeE43ck9oQy9LWGZ0dTZY?=
 =?utf-8?B?TWpSTDN6Y05oSDZVLzVOYzhJNytwVll0TzZLb1B5NjFlOEFpZzU3bGdsaGo1?=
 =?utf-8?B?bHlwTjNKTUd2TTk5VUFUenF1RnF5V3VoVGVhaFFpRlo2bVdocHcvMFNSZWZH?=
 =?utf-8?B?Q2t1YncrM2ZYY2RmdllROHg5Unhmd0ZiQ2I5Q1NkRUE4a3p6NDMrdVdoUnBQ?=
 =?utf-8?B?eng3U3JmRGlYWTFFS2JpUWMvTDIyM1d2UFV6SzF4TXNpamlzU09Xd2xGQnhu?=
 =?utf-8?B?TUFTekNWRktEZ0haL01NKzNtVGtCcHRzL0ZYbFRvejM4dVVKcXdmbEtic3Bo?=
 =?utf-8?B?S29UYmdoOWpUaHZiOEFPT0d6S2lBQlZwU1ZGQTdNNnNyYm4zdVBkdWlycmhN?=
 =?utf-8?B?UEUyTVNiclRJaW13bmd3TkRMTndYMVpGeVRrbjlYRW1mTTg0ZlEzTFVTMk5l?=
 =?utf-8?B?TnRPQ2o4a0ZsblRuVEhkeHBtUmJvNHdseUxQc3VOemR4Zmc2V2RQeUY3cDh1?=
 =?utf-8?B?MGpWeUhDb0lFb1ZacTBoZFZMaGFsTm5QK3RyYS9BRUppdWpULytQeENRZy9P?=
 =?utf-8?B?U3E4SHlNT1R4R0JhQTFNaVo3SzZGN3FwZFA3dWcvWmF1OHp1c0RPZW12OXZW?=
 =?utf-8?B?NklkMm1PK3A0MDZQSU96U1lPSFlyZC91SG85MXg5SFM5Y3RYS2VpbktkcVEy?=
 =?utf-8?B?SFloeE9US3dMQ2Q0dURIRWEzTFFvWm5xY2R6ZzhGSlF6cFNMYXZnaXF3TnBU?=
 =?utf-8?B?NWhEeUpyR0lIaS9HUzdnSzJ3WTZueklEN1ROUTZDUmtKQ2lFTkIvSlBMRTBB?=
 =?utf-8?B?R0VSWmtxcmw0Z1BLa3ZQblpVZHhXSjRNUTVtdVR4YTJGN2h6alBCQlljQXo4?=
 =?utf-8?B?OGs5bkVCTVdFYnlVQnBvSXNmQjNTQVo5VDZmTS9GUW83dGZUZXM4MVBXM2pa?=
 =?utf-8?B?QURzQjRZUFd0TUt2cnJkL1pHZ2tJSS9EQjhiL1JwU2lRVzZQZHZEci9LMTVn?=
 =?utf-8?B?YUhkMnpia1dNSEZDUDhvTC8rb2lKYXdYQXJGYkUvUU0zMHlpbEtUVjNQME1V?=
 =?utf-8?B?dzRVR25KMXd1QlF5QkU3SUpEZ2YvMHc2cEhRVnVzTElyMmtRZzR0SzdyRStP?=
 =?utf-8?B?QmZoZWxieVBYSnZMSStkbHl1TGJBVkVWcE1yVVNQamtIRkZDQTJXeHJKOFRP?=
 =?utf-8?B?bGRxV3lKZXJidUg4MStpaDZiNjBHUi9NeDZqellNZmhJMXFvY3o1bERJMGhO?=
 =?utf-8?B?bndheDBYbE9GN2ZDS255VTdOU1dJNEhSTHlVVHdBYXVJeTJ0Ui9NTW50WXY5?=
 =?utf-8?B?QkkwVFlwUlE3LzdiTG1TUEM4T0kwT09IV1R0R2taZXJ3eldpbTUrZHVYajcz?=
 =?utf-8?B?bW5lWHgvRG44bjFQRGx1aWxiQ0RXUGIxMW9oQVJlSkNhdEVmWDVCbnZuTS9K?=
 =?utf-8?B?ZUlCbmd2UWVrYnlQOW9wN1VNbzkxOUdqNitlL2NTcDBES2ZlcmRPUGZrbDhj?=
 =?utf-8?B?Mi85ZDV3bFZzN0FpbjJXTUVqM0hpSlV6eTEvMkxNSnY2blJKdFpnNFNqK1JD?=
 =?utf-8?B?bmdmTFN4YXZ3VkxmWHNFMmRUR0U0MzJ0NEhRdUc3ajNxalRtVzVCV2MxdXhN?=
 =?utf-8?B?SjZzbnZIbXlKeElkd2IvS3ZKS1NSYVkydXVXR2FuWi9jMDV0MUlNSUx4bVVx?=
 =?utf-8?B?Q0tCTGVJTHRwbElmY1RHVjJtd3VIbjk0NGVxV0pzcmV5cmlUdEdYRDZRdGwz?=
 =?utf-8?B?U2pIcHA3RVRUZTJFWVFGNERyTWhYTEhTOTNKMERRRWY4Q21ZeVdLek1KQlhN?=
 =?utf-8?B?RVY1OWlCZHdrYXFWL2RMdURGYU9oeWpNWjRZNlo1NmdTdG11TVhnSGFOakI3?=
 =?utf-8?B?WU0yd21ZK280VWhmbEdIM2JYUStRbUdWL0Ntcm94TG9hV1lLQWoyZURYaStM?=
 =?utf-8?B?ekx1bEZ4S0QxZU5UUjM0aHc0ME9BZEhqVFNOQ0JxdU9aeDRGU2VPT3pBK3FX?=
 =?utf-8?B?SFhlVVN4MnRkMnRwajA0dmM1TjhzK2lrR3pidTh3OEpPdUE5cUNncGF6eld0?=
 =?utf-8?B?Tjl4Vys0K0JxQzBsTzM3bjUyaXNOc1M2YlZiMXFIYVNiaU1MYzZrY21jYnF3?=
 =?utf-8?B?bnl3WU1hbjFheTZxQkNSbXVBRk4yaVJ6dFFuRjl1REZMVHpPRUV5STJlUzZi?=
 =?utf-8?B?MlRmekpYWitrNXIrbmpXTDVWMGhJWWZmc2J3djJxcXhaclVyK01aaTFZM3FL?=
 =?utf-8?B?Y3JDMWwvaHVvbzA5cWpBNE04RTJiMzBqdjAyUzE1SVdtcm8rOXU2L3FwYjhC?=
 =?utf-8?B?K2I5V0U1YzRmeXhqU2o0djQvcmpEL1hEQklVRFZrUmhXWEZKd25SYlR2S3lF?=
 =?utf-8?Q?WX4LhQkZhuBO2Ipwa6y/sglXM/COTT+IUTQ6qJslUJz/o?=
X-MS-Exchange-AntiSpam-MessageData-1: SAEdpnDAUHJTTQ==
X-Exchange-RoutingPolicyChecked:
	AlQEHcf5BHIPxwm25FGG4cRymi1Sbwn6wh8wANqLlajMixjUs1m9zEIQKe7QF+zqy3tTqCc7RZVCFIDBcJ/HRzyfVJA7weE14jZXM/lckfeW75vrlZ1ZNqDHRvjAoURN2EIvc9AMGFfFsreg2e9XLpkUaF31SwiI/mhku2S1PAI2s+iKLCLqBhsqOVwEGExgxWEXVAVrBLH/S5SNIKx96/zJzy858uAFPp57cVvCLiVTRVQ8PhYcrniBiqCBJXYRpZDaD+sMeZ2rJxaPZdWeU7raSnjkgWtSakeghl0cC3Evlgd3aUdItmIPYwbjaEkwZNFwUK23KC1w+PoQsySg/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nqOCL2TM123S0iv8tUu7RMXS/tEW1ALQ/atvxpNFMymwHq3rCVcO3YHnvCCgI1n6shmMj/g/F2iNuMpsazAhdGam9eCZc4wk1c6qunTth13HwIBoam7Xi+ONQSf9TBx30G6et5BkIVG8yK3kAJeywJOsLmpeDxdmni6PLC/4Kb/xq1eM7ZZrSFHT5fc655bjfU4hxUTH/tmXI96z68nW/fVg2cav7bD/6E7xpNvEe7bidhnIxOEltSpmSsRGHIoaoMGv11yF6tKUZadv5phn3SkcPyimY8RAjreMBs7zUS8gEevuKMJkhbwh2zCTOgBAd6BkHbx+fcub9Gd6WUVU7gSDM+Uz4rEveh5wNV98lCk7c/Ms3Yl6RGSiZMQLOSIRXfYouFiAcrp782TFKmCv5Z3SgCpXGm7Ippre+QBw72Ns3ZM+W5CVlxgGpE5BhDlLMHdgGOBGSX+2olqbVSDcSo8P5q0tF4tSlGKfoy05pB46fLqxQeZG5cw+l8QJOLer790SJ3Om3pb/xqkrPv9XxEPVYOhjyTrCdFFLs2Z0iRawTY2SnetdidV8Ka7nZ2bL0a2JW4XrOsPL36obaXuPuRDbizfXK4FRK5PygDSqF/1u3vYRuC7myj9+otXId+op
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b705103-611e-4d97-f7f1-08df04bec58a
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 04:42:31.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UElHFi+GM/aBerm92p8JlMENbbAg5SJ9eJGtlQamiDiXgU+RwZOE4faSpBj56x4MciSwymXQFwNsCWKIfwSupQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7514

On Wed Aug 26, 2026 at 1:27 PM JST, Dongjiang Zhu wrote:
> The runtime activation and finish paths apply active-zone accounting to
> both conventional and sequential stripes.
>
> At mount, however, active_zones_left is rebuilt from device zone
> conditions.  Conventional zones report NOT_WP and are therefore not
> included.  Meanwhile, all-conventional block groups are marked active
> and added to zone_active_bgs, so mount recovery still decreases
> reserved_active_zones for their metadata and system stripes.
>
> The two counters can therefore diverge across a remount.
>
> Each unmatched reservation decrement lets data consume one more
> sequential active-zone slot.  Once the reservation becomes negative,
> data can exhaust all such slots.

Yes, apparently, this was not a problem previously, Because,
max_active_zones > 0 mostly means there is no conventional zones. But,
we changed the btrfs_get_max_active_zones() behavior to also use
bdev_max_open_zones() to set the max_active_zones. This is a regressio
introduced by that change, which deserves Fixes tag.

> A later transition from a conventional metadata or system target to a
> sequential one can then fail, because finishing the conventional target
> does not release a sequential active-zone slot.
>
> If this happens during synchronous transaction writeback,
> btrfs_check_meta_write_pointer() returns -EAGAIN.  The transaction is
> then aborted and the filesystem is forced read-only.
>
> The reservation mismatch was reproduced by creating small files with
> large xattrs in batches, syncing them and remounting an HC620 filesystem
> using SINGLE profiles:
>
>   active_zones_left:     126
>   reserved_active_zones: 3 -> -8
>
> The active list contained one partially used conventional system block
> group, nine full conventional metadata block groups and one partially
> used conventional metadata block group.
>
> To keep both counters based on the same physical resource, use
> sequential stripes as the unit of active-zone tracking.  Accordingly, do
> not mark all-conventional block groups active, and update the active-zone
> bitmap and non-data reservation only for sequential stripes during
> activation, finish and mount recovery.
>
> Assisted-by: LLM
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
> ---
>  fs/btrfs/block-group.h |  6 ++++-
>  fs/btrfs/zoned.c       | 59 ++++++++++++++++++++++++++++++------------
>  2 files changed, 47 insertions(+), 18 deletions(-)
>
> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
> index 69d56864d4ba..37ab8b7eee9c 100644
> --- a/fs/btrfs/block-group.h
> +++ b/fs/btrfs/block-group.h
> @@ -80,13 +80,17 @@ enum btrfs_block_group_flags {
>  	BLOCK_GROUP_FLAG_TO_COPY,
>  	BLOCK_GROUP_FLAG_RELOCATING_REPAIR,
>  	BLOCK_GROUP_FLAG_CHUNK_ITEM_INSERTED,
> +	/*
> +	 * Only block groups containing sequential zones can have this bit set;
> +	 * conventional-only block groups never do.
> +	 */
>  	BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
>  	BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
>  	/* Does the block group need to be added to the free space tree? */
>  	BLOCK_GROUP_FLAG_NEEDS_FREE_SPACE,
>  	/* Set after we add a new block group to the free space tree. */
>  	BLOCK_GROUP_FLAG_FREE_SPACE_ADDED,
> -	/* Indicate that the block group is placed on a sequential zone */
> +	/* Indicate that the block group contains at least one sequential zone.=
 */
>  	BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE,
>  	/*
>  	 * Indicate that block group is in the list of new block groups of a
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 9d448cdd60c4..0d964ada3ad4 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -1969,7 +1969,6 @@ int btrfs_load_block_group_zone_info(struct btrfs_b=
lock_group *cache, bool new)
>  		} else if (map->num_stripes =3D=3D num_conventional) {
>  			cache->alloc_offset =3D last_alloc;
>  			cache->zone_capacity =3D cache->length;
> -			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags);
>  			goto out;
>  		}
>  	}
> @@ -2005,6 +2004,8 @@ int btrfs_load_block_group_zone_info(struct btrfs_b=
lock_group *cache, bool new)
>  	if (!ret) {
>  		cache->meta_write_pointer =3D cache->alloc_offset + cache->start;
>  		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) =
{
> +			ASSERT(test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE,
> +					&cache->runtime_flags));
>  			btrfs_get_block_group(cache);
>  			spin_lock(&fs_info->zone_active_bgs_lock);
>  			list_add_tail(&cache->active_bg_list,
> @@ -2198,6 +2199,9 @@ static bool check_bg_is_active(struct btrfs_eb_writ=
e_context *ctx,
>  	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_fla=
gs))
>  		return true;
> =20
> +	if (!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_f=
lags))
> +		return true;
> +
>  	if (fs_info->treelog_bg =3D=3D block_group->start) {
>  		if (!btrfs_zone_activate(block_group)) {
>  			int ret_fin;
> @@ -2394,6 +2398,18 @@ int btrfs_sync_zone_write_pointer(struct btrfs_dev=
ice *tgt_dev, u64 logical,
>  	return btrfs_zoned_issue_zeroout(tgt_dev, physical_pos, length);
>  }
> =20
> +static inline bool btrfs_needs_active_zone_tracking(struct btrfs_device =
*dev,
> +						    u64 physical)
> +{
> +	if (!btrfs_dev_is_sequential(dev, physical))
> +		return false;
> +
> +	if (dev->zone_info->max_active_zones =3D=3D 0)
> +		return false;

Apparently, since we use bdev_max_open_zones() to populate
zone_info->max_active_zones, we won't have max_active_zones =3D=3D 0 now?

> +
> +	return true;
> +}
> +
>  /*
>   * Activate block group and underlying device zones
>   *
> @@ -2417,6 +2433,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *=
block_group)
>  	if (unlikely(btrfs_is_testing(fs_info)))
>  		return true;
> =20
> +	if (!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_f=
lags))
> +		return true;
> +
>  	map =3D block_group->physical_map;
> =20
>  	spin_lock(&fs_info->zone_active_bgs_lock);
> @@ -2448,7 +2467,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *=
block_group)
>  		if (!device->bdev)
>  			continue;
> =20
> -		if (zinfo->max_active_zones =3D=3D 0)
> +		if (!btrfs_needs_active_zone_tracking(device, physical))
>  			continue;
> =20
>  		if (is_data)
> @@ -2514,26 +2533,22 @@ static int call_zone_finish(struct btrfs_block_gr=
oup *block_group,
>  	struct btrfs_device *device =3D stripe->dev;
>  	const u64 physical =3D stripe->physical;
>  	struct btrfs_zoned_device_info *zinfo =3D device->zone_info;
> +	unsigned int nofs_flags;
>  	int ret;
> =20
>  	if (!device->bdev)
>  		return 0;
> =20
> -	if (zinfo->max_active_zones =3D=3D 0)
> +	if (!btrfs_needs_active_zone_tracking(device, physical))
>  		return 0;
> =20
> -	if (btrfs_dev_is_sequential(device, physical)) {
> -		unsigned int nofs_flags;
> -
> -		nofs_flags =3D memalloc_nofs_save();
> -		ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> -				       physical >> SECTOR_SHIFT,
> -				       zinfo->zone_size >> SECTOR_SHIFT);
> -		memalloc_nofs_restore(nofs_flags);
> -
> -		if (ret)
> -			return ret;
> -	}
> +	nofs_flags =3D memalloc_nofs_save();
> +	ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> +			       physical >> SECTOR_SHIFT,
> +			       zinfo->zone_size >> SECTOR_SHIFT);
> +	memalloc_nofs_restore(nofs_flags);
> +	if (ret)
> +		return ret;
> =20
>  	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
>  		zinfo->reserved_active_zones++;
> @@ -3087,8 +3102,18 @@ void btrfs_check_active_zone_reservation(struct bt=
rfs_fs_info *fs_info)
>  		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
>  			continue;
> =20
> -		for (int i =3D 0; i < map->num_stripes; i++)
> -			map->stripes[i].dev->zone_info->reserved_active_zones--;
> +		for (int i =3D 0; i < map->num_stripes; i++) {
> +			struct btrfs_device *device =3D map->stripes[i].dev;
> +			u64 physical =3D map->stripes[i].physical;
> +
> +			if (!device->bdev)
> +				continue;
> +
> +			if (!btrfs_needs_active_zone_tracking(device, physical))
> +				continue;
> +
> +			device->zone_info->reserved_active_zones--;
> +		}
>  	}
>  	spin_unlock(&fs_info->zone_active_bgs_lock);
>  }

Also, as you dropped a BG on conventional zones from the
zone_active_bgs, prepare_allocation_zoned() will never return the
conventional BG to allocate with.
