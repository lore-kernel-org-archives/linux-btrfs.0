Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794245653;
	b=3FrJQJjTXX0+eSMRwma42FVIJjjWAcBXCbTKlLaNd7DeNSW+mEGZgNQEVWpmcXy0+hzl
	 8ULFarYHlhbeCsvFeY8SnqDsj//gdKL/7pAlWKi9B3WTieH01nHi99JknlJdsMjHF5rWU
	 NksQTAg2lKww43ExjPjqboQ4CdWYbvrJuV5rq+EkKXkw6qmKwJr4bzb1fJm7wWJdmxCXY
	 7eCZjVvdu34RbMmySPqiCL3//TFVld0olh1c63MKaLrzUJOnzrmObYYOEFLqXk/Zw2Gsu
	 BVaGQ9gbKPbaP+WKDRUjyzaYazduDEH5XU3yf2YFFsFEl2tKlVKREn2gRmap/AyjYIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245653;
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
	bh=0n7YQQkXCDKz5BMPMVBkdpz9SLd5I5LCM73Od8mU8tI=;
	b=QMJGTjIcC3wiBmOTEQc6BOQmMyo22UkE+hwdK7Ozq9nJRxwE4NLrx4R35+o+YbN3+s9k
	 GZaBhuM/RBRdxMvhjaZonmd9bfvzIVR3YVP4j6uC1OkDZaIuNmAl4yDN1Lad7BfuojSwZ
	 HslTOPF3ZRcc1THXJPAu20pBp3NA/VK7YpZeUjGxUdHtwBG4pmhgt+ShHSj8SBCpM38MW
	 uxbweoGx02615yipl4gNKug8FRHuKs71K14MbLzjxqUo8OiMjVOiRrkuUI3Pmtgxtrbwz
	 d2nNQExYNJrqVBpTy0x0MTiz/Dl+ajpZItAlQO9fBTxXpk6XrFToshcDOTKasABZu1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JUsRvLS2;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=j1GINGE3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65234606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 17:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65234606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JUsRvLS2;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=j1GINGE3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794245659; x=1825781659;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0n7YQQkXCDKz5BMPMVBkdpz9SLd5I5LCM73Od8mU8tI=;
  b=JUsRvLS2CQW2y3HUbMg5wraieIwXojXOEWEBe1r2JZv+lzBhVvD+dRV+
   0jsv/8NMJFr1wnFOHsl4GCXCjPkk6jS/J+jRvUNjgOOsIpOIS2kVx4d2v
   G3Aktp0FoR6qrf3c0dHG4baEAk5Apers0yNIQI7iiuGhmjsHBbKBSM6dE
   hHCDkbPLA5bA/5aa9dCBMc/1Sb3JrH6xk9BW1LSeoI4qPJGgmmmXeTVzW
   Ljbdn5YSBseQL13XSVGldfpeAY30NMydc9EZhDH7JGlQTN6VCF1eM+p9U
   fCKPpBxAm3bMCgBl3Lnd675Etr/mS2huy9YnZMNU+VNz4OQ0aBRmlLh2a
   w==;
X-CSE-ConnectionGUID: MQsM4LjuTce6H4NZdrdIJQ==
X-CSE-MsgGUID: qRksLSKmSL2IokZn3950vw==
X-IronPort-AV: E=Sophos;i="6.27,204,1786982400"; 
   d="scan'208";a="156146945"
Received: from mail-northcentralusazon11013032.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 01:34:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nGG7JdUVfHHkTmtjj55Yx4ELUi7zdLprOCh+ZGnr+JPvTMYenqws14gQDsgjeWJm20JoX3hiU737vSXuL2g9PbrXtTT8a1gdF2qC92p2teW9WlgGwiBD4DiQcjvMSZOIe9c5XZtkVqNc6WmKSB2iGm/44ZIuHNewjP/xT1pk7CvvrvuYCBHEpbOkb0rXIxYCacuZeLLlDhdMjn/q4Pp6pnBv3AAq6y3aTqRqkz5RfCz/VMG0WSr4XJDoKDk4WsGkNlXRgKMRwI+NDOIPhWzu+CS4uc59yebJA2aBrrhfIaPbq2ccPrYIJpznJgNJYwPF+jTSkkG+MlKS+V4y+rmo9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0n7YQQkXCDKz5BMPMVBkdpz9SLd5I5LCM73Od8mU8tI=;
 b=n4r7Wi9YlfB70EfiVlcqCXsuXrhc2IppXsEqkuB3xQKNCuBfCSfJ8w+f2uVaNX7//Y/IZC9upj4e0PmB+lkfhbc+2J+mhVv3mEesRPXdMpqRzMru7KM75ICublaU+5LXteAhyVSBi4vMI4QVBhe80NqKOELTkwG8K5jlykhZvAtx3z0yo6ei2gx+4b2IqYMTuImehLQQhSrxTs4LR8InW52yHrFJ92pOdMPgGnBF0owWAlOJIIb8ZVDo7lcB78gve+6QQ9yKqbykET6CGglYp/oqzkpf4qcU1RGQ+xW6mEUU6kyXCBqvx4gecpqz2ZiZJasHyX3iqfV22e2y2L/3/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0n7YQQkXCDKz5BMPMVBkdpz9SLd5I5LCM73Od8mU8tI=;
 b=j1GINGE3+gp4AFWQhfHYE+nxV8uMR+UUK8dZf7+saOzKhykiZ2gt9otJtCBRhS/KlApHYWba/z3lW6FRr7gvOFsBABZzhQkteQP3EyNQAqIx+qbjUa7SQKMN/tXbA3BJBBgj+nPXJ18PzVH7sGqbhGdIUcMoJkrjEhkqmeuWACk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SN7PR04MB8603.namprd04.prod.outlook.com (2603:10b6:806:2e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 17:34:06 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 17:34:06 +0000
Message-ID: <f98e2442-fad4-49bc-a66b-693c049fac61@wdc.com>
Date: Mon, 9 Nov 2026 18:34:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: don't release active zone reservations for
 conventional zones
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Jochen Philipp <a2jphilipp@gmail.com>, Dongjiang Zhu <zhudongjiang@fygo.io>
References: <20261109172840.1142171-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261109172840.1142171-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0434.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SN7PR04MB8603:EE_
X-MS-Office365-Filtering-Correlation-Id: 546deed7-964d-48db-f2fb-08df3e87a76c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|10070799003|19092799006|366016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	x3vdtaDuVoP6hNHwlpoeb5Im3RH6BoNW4KnloxCgam/N/rN37byvGxeGjFteLpXlP4dSg11zSAdgMi6DDQgly5Fuu1Cfg1DlN2wBE3gdCSlOGnGZR8XQEKXUY1ChJlgEMQDSNHIe/4iHIMz8ARLCNlHv1GZrhk9iAFMProI2CHxBrvsdJK+E3IPUV72rQqZU9IgWAz6m1K+TXc8p3QgpL7dUV7i12jyBL4VQ1ascgbWJaSImdv9fSe56F5it97yD2d68U4ojaMQOJXLu2Y9PURzF+X87LBoyyQK30+ohFFd6EjV6sqR6zFH89U0DUeSL+jLSJuIHp/RCPQN7f66KlFXcCYHIhQV1gg9Y8tfdR4QWAg3+DDWi+VvL9x4nLP66hw9D0vvN85nU2eJjO8XjSGl/d6i3wn3SyVWtXZQm3l4rpW0JDSBPYMGw2fhj+txAauva3ySdyhS/cEQy5qgEWlxtsR1o7Sq3/GCXYahda1aW/OcAB/9I321bIsAvK5Fei4H+VRRkJAYQoSL3+L5pstLu6kEwZCf7g/0UYCF1kNmBZm6pzDaEuZeDKQf0+C8Wu27ZPx546b7ZCo2O6TmZ+/R+ti/YXnrG3/ieAr0aeU4yKduJEFDAcBgyESPeovMaysXMLdw3hTI7Dmy7qAJlsz8/bdvlYst67aYF/bOVdMc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(10070799003)(19092799006)(366016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlBqdkF5S0xRQkxzTVVTM1pQODV4SEo1TlBCT2RHZVk0OG10WUtScktUWnJY?=
 =?utf-8?B?OHVUSE5ITFRkbWxaSko2QUZwL2xCb08zNmVvdkhWMTQ0dHR6MVd5ejJhRWl6?=
 =?utf-8?B?aXlIK04xRnJNV0x1QmhlNmRyUmVTWnV1dTcvdnhkN09CRERRMy9INkdkeDNN?=
 =?utf-8?B?eVBsUUE0MVcrOXRwSHJwbElMWXRjR2xpc2YrZVBLam4xU3Uyc0kyMFlxNU9v?=
 =?utf-8?B?bGYyYUJLc21xT0xUU2RnU25qajBPNzRZRW9zODF3NGgwdDIzcXRjTVFyb1dk?=
 =?utf-8?B?aTVOdTh6dUhBc0YrTGZUcUFKOUNHMTN3VmFxOW9kcmVJdWczRng4b0s1U09r?=
 =?utf-8?B?ZlNKMktpMGFhSUR3ZDNCY0hFVVM3Zk5WM1RQaG5tVzRXVXlwMTFsVGgwTWRx?=
 =?utf-8?B?ZkgzVWdIaWNHNUtBUkxMVEFDT0xDMWlrYlRkQnR3eldDdHpmaEM3TUJPWjVm?=
 =?utf-8?B?bmRwc1VjSEJlMVROREhaR0Y1LzY1eEFTNkpoVm9TVzR6QlRsVC9aQ04wQ0hh?=
 =?utf-8?B?aUIzNng3Ty9uKzBsZ0ErNDBoUktFNUFHTjlLSHM1QnNQOXJYNng5Sm1BcU52?=
 =?utf-8?B?TER2azdRYnhoQ3p4RVVJSjdsNEhZQXgzVURkTlh6ckVHUDh6RHVrajVwSTQz?=
 =?utf-8?B?cUxXdnRpTDJpWUdvc1RsdmUzZGpPa3pRZEl1MzI0ZEJJQjZrQWtlVVFzTVNp?=
 =?utf-8?B?SG1CblhqMHRueGM5MXdvZTJjUFFEbnRJOUVld2NkZHgrLzJvdnV4QXJCNmdM?=
 =?utf-8?B?M1VyLytEVVJ6OEtWcCtpWmFHM0FwU1VydW9MMFRzNlovbHhVNEV2RnJVc3hW?=
 =?utf-8?B?S3h6R2EzSVVKLzNBd0I0SXNkQStXYlA4bVJoQmR4YThlLzNIb1RpRm82bkxk?=
 =?utf-8?B?YmhiSTNDQXQ5YW11VnZreHQ4REcrMy9EaGdBSHcvcXpTeDJ5UFMvbGtYaHd3?=
 =?utf-8?B?bnpHMVdkS2ZmTnFQSmJaTUZBU0lUU1NRSWhZaDRiVDdRblYzSXFWQnY1UU1B?=
 =?utf-8?B?c04xRlhvR2doUzZKcXdiTGc3L09QZ25YOVdFYS9aS21TbUVESmRiZTFhV010?=
 =?utf-8?B?YVhXNENVQWh5M3pnaTJEWTN6bEdCYVAycjRIYXhRcWhzVXNzdUkxWXB4SkR1?=
 =?utf-8?B?MnJqVC9hd0RIaUw3aUkyVjV6VCtuSTYrbVlCYzBpdVlQenR4RmR5UXlUcUVa?=
 =?utf-8?B?d3ltVXFjbmV6QnZCQnFlY0VFNE5XcGxqY0NOTHF2MDlMYzYzVFpGSmhZc3hC?=
 =?utf-8?B?UnpqaGpST3BwSVdOTlRRQS9BTjFDV0prUThabW5LaktzU2p1dUNaekJJc2JJ?=
 =?utf-8?B?QzVLZmthOUhoRzcvOFZEWVB1QVlZTHl4RW00cWVPWElvSCtlcmplbElEUUlR?=
 =?utf-8?B?R0lVM2VJTCt5ZVNCWjBHNXpSdklZd2cvL21NOTJKRjNoZGFTNGN0VHZvWGlr?=
 =?utf-8?B?WkhSUUhTbElhQ3lzNm5iRzhOaVNnSzMvMkJoOHVsSlNjMjFneURIK2g4anh2?=
 =?utf-8?B?SDVGMTViOW9MMFRoSElQQWFTNkhGbjcreVdSbnNiTWx4R2FQMFUxWnJuN2t1?=
 =?utf-8?B?SVQrTVdiUXNIMHhvNyt6V0RGTk9vSTcyYnUrMzVGM3Zld2dWRTBkTy9ENExU?=
 =?utf-8?B?ZjRLUXJvMVRQUEFNd2hFaGp6N3BaTjVKMWJtMXhqQkJDVWpnVXNrSGsydWVJ?=
 =?utf-8?B?Q0V4WnRSVjZoT2hqdEdRcHRMeWJLd0hPeStmUGF4Q0txR2ZQUlZLbXArWXlO?=
 =?utf-8?B?TEh1MStIYXRWSklSamxYVWVpN3ZWaUdWRWNrVXlaVFYySjdjTmVkNU5DOEVK?=
 =?utf-8?B?MzdTTUNUZEhJZm5lVENvenVFZkVva2ZTUXMrVlZudDFObE1hSEVQYnA5Mkky?=
 =?utf-8?B?YTVGL0dyMW12N2JuNEk1aDRDVWloenRlRWF1YUloWTdjMk5jbi84dmZoeDBT?=
 =?utf-8?B?N2V6aHIveU8reDZQaGVqbEZVNjgxVTJpc3VMd2I5Rm4zY25zUlRsNjB2OHFL?=
 =?utf-8?B?SGFzeUtadlAyc0xyMW4vQUptbm10UG9uOXFOTnliVDlIODRFZDVab25hUHVR?=
 =?utf-8?B?K3YyMEtjMDN6TVVrV09wUm1PanEzR3hvbDhVNlNFWTFwSzJwY01odmREVUZL?=
 =?utf-8?B?RkU2emNSTkE2anhiaWl4c2lsdEh1RmMzck13R3ByQ01DaEh5YWEwTmN0c2lQ?=
 =?utf-8?B?RjhIaWZuMlAvbXdaSE5NT09uTHFVMnRNNGMxOFcyTUY1OGVpQ1J3R1dadTgr?=
 =?utf-8?B?a1dua2NwRTZLVldKYThPdStLWUZFNFhYM0p1TVh6a0tuMmFkeW9zRHgvNXJ5?=
 =?utf-8?B?SjMvZkhuT2RMRDh2YVNiSlU0VG1GUmlzRzc5YzRQcCthVTYzU1RycXdqQ3NP?=
 =?utf-8?Q?pxX41m7HsLm1h39Zoi2rJPFZXLHj5SMArknqrNUl+4cB7?=
X-MS-Exchange-AntiSpam-MessageData-1: Z5GJz57PtVTu+wvE5bfDG+IrUmV/LOAxLMw=
X-Exchange-RoutingPolicyChecked:
	y0c5s8SSoiian/0ZQ2j0yQEiPNJXmGVEgwRbE6zBpSTUj9XetiOIS0XA2yfqQGa1RuZ6563RZ83VgwPXraoXqMdvbDnCzOSuM+fh+Ts4IafM+48lDmNDaI5tvZG8qKqwjFDtIwwPh1IqfwKgf3at9tGzDurYd6D1yAaP3Rl0SkzLAu7UHlTmalQZ/9TyuXpOn+3n/eQHq0mRwqUY4YFRoUUIaeDdz3rqxpC7IoHmmHcMlbrM4m0NS80Szy/ORX2c5RcNmdwoSfVIITDRG3EFnenvxaZEi61P9ZqIV7LlgXzF3ert+ygXgrATva7mTLZI/GakYdXL9pLfgskSh6mDCw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V5r/5xWoiFyqX0JwHMh3p19fOHmaC+q9IMHYM+RldBktO6afyi3njat8ZfmKCpEdfBuCdtO5uGASMWCGBEdG6cGL6jGvqZDU86P69bBGhGIXd5D33XmY7Xr/e5vBBeKbFZ5F+ZA/eo9eVogsNLj+Ie4irHJTv/C31nRJw8eswIJ8e3+aVlpy9D7F7wjEmPGnhPckWv5jkbOUhP3bGc7RiQaLbhuvXx2qNs+XasuC2U3uL9e0NgnWZGyuHIbwfH8+rgiXC0Y3l9h9Qq8H97ImLgLKV/JZHTiycA5HKxe0VIZHUcVyT3IrjEjpKLeN/QblYCrxnHvwLY94QW43Zu87t0wfzeG4cPv5Tnxg/seWZThPbRr3+J15HKERKCQsPrq5EO1Jz4pfBpgr6rgXBzfHrobNnCGS9B8UBUMPGN0qo1eY+93EZ15J3OfYZ1eFCRPiJs2YmcFD898b2jncLHzBcv8G8eJkrmV2lBa/0vY/Pe1yJCZYhqe6+E1mfST7nYFC82Xa6b3PRjs2OAkhP15d3cGC7iaijGAgTuJWREXl6Twq5VYE7d7T7lFVLAdl1mpQomqAxY12bwF7/aiISLBaFS5a8bxdH6GDpXmfXSn5XObJDq05kdeSw4YIWUUbsxHV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 546deed7-964d-48db-f2fb-08df3e87a76c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 17:34:06.3705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mQ3q1C49rkstU7DYTjKUJOy4tcuejomOvslk147FNSqXNBkCaXU6FGqNVkjk9tCBs3sgc6nwHPgKs41cmt0ICQW9KKdjJUZY7A7Skwae2BI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8603

I'm stupid, please ignore. I'll send the correct one in a second.
