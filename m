Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794228691;
	b=3WR6GQyCtkQ+3gC7Q6Q0RyNRnJ6fWbLrvqPXlZNeb9AD0SiAdgZOxLlSo2DDBiYjPbfQ
	 5PUkYYnSHCM+LsAYZtRu3yVAcBeLe7DhpiYq7I0MGCtAvSYqcnPbN3oYhIyVTVarkpE8u
	 bFwle+6E0DcFxoT3AYWO0ZwKXTTYwSrkTGEV9ka5ifHmfU/Z6ZCS295nw4So8pB6ybotn
	 nw7vajzCz122xJKBKaEUYHBSSKNwRxgLHO7JVLTLAgPtDNCsF0kCU+PtK9LSII/y1O5ha
	 sEaqB2vCoTa3A5RFcuSJWvi9n8+9f58SauneUMw3IRkNU7anmjxBSwAHM6NcIs9Vwmg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794228691;
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
	bh=YeVp4owKTUlKLbYkvnD/kfHGubArMi0HthuZftWM/NM=;
	b=r+acGqKoBIsJvfPb87PzhGZ9FyOj+ez2D/ieMHHmRvzDB7KR1KwQQfJfXaePZeogIuUC
	 mSxRgEbJ4jUhWcbIadc9yWJyuryjfQbFcyPqE0luzRYb44jQv2mWL0uJeSTokPw8H4O6R
	 tcw2Gnw4y1wZHJuv98o89JeMOoAnt8MD+ye/Kt3f0Uae+BciK3C0ABfwdh5qN15FP7rAq
	 SJ6gl5d6uZ6icJ1HZ+9JltPQOzSV5y/bD270IUV3jH4xiYw19StcqmpTAvzApfL3CwUYw
	 3y6bRYDeMNQd9JoySWf0w0+eBT1kw8HqMxy3HF1ZgsxOJtEflwm2RotiFDoKaSS9QJg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Sks+KUwr;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=oKXp4F62;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCB0606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 12:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CCB0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Sks+KUwr;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=oKXp4F62
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794228690; x=1825764690;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f45LohOqgNVVkbHCY52vzDP14lGaO/eRFlSDf//U80g=;
  b=Sks+KUwrFtc1Gs1HfmMBdq+CvU3QiyyHR/w66HpQwUUWjdt8eNWz0Pr6
   FOv48usphlGy78R6Y1SU/GUvVyHXtIcm6p5BocsecXGn215cyMLvQ/SQ0
   EmjaSB7RyBqBbsBtu/ZR8eM0mi2Rnjjm7Yt2SSGmdjD3iQAfXM4Dsyg5n
   WflQ/gIlIhsk+IFGlwJdUY9O2RVen5rue3IWHkiF7wk0XpsnIT5S5LptN
   gQtTfspHQTKG0SrYSox1eNO6mCYyuu/BGnXCglHWoallDiDMgs33FsOG0
   7/PkjpwACnHytnSPDUMhH6lCSz9UitjolCGXBPiQkoaLKaGU+O7wF7JjP
   g==;
X-CSE-ConnectionGUID: FXenkA38TDSAi38NMdLXaA==
X-CSE-MsgGUID: pAXp+8KaTHisu4v+jFdUpA==
X-IronPort-AV: E=Sophos;i="6.27,203,1786982400"; 
   d="scan'208";a="160280935"
Received: from mail-westusazon11010023.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Nov 2026 20:51:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJnve5xY1ZREMdMPcyuzG4XM8v+B/pQxZ3jDOQC44ugsavVxboYfL2DKB4rn4GAuj+DacxWs5Y/jfgFspbA3hiPc+Bobk7FYNpAj4vREvu3TVqOpkbSSyeqJxVQPLgTrhvB3U4mVW7dxuucxvGlJYj0o8KAJmjjk8b8YsrDVV2ip5/7nDsCdfArlK526KjcBFMZklnpcrGjBhqlzVK0KITJ8PxSVhrEuel3yXZrzQRujPBd7J2splo2J7ZeiMKycUk2iEalhuTrGkpCI006S9hQiTmt09PV7Cv+C1l/MzRQETICbH1z7a2EwzIJMAybAXAnq1ACyg721v9q7oTH2sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeVp4owKTUlKLbYkvnD/kfHGubArMi0HthuZftWM/NM=;
 b=qbDMOE+4726vVcyoe1qL7CtlC/MdZJjLxnKzATgb+1bmHCXInlav4HzbvTWS1DomNapOiljIHXnQ75O3OWAqBFnAX93zrbLdBRygplg6g4EHkKFFWYWl9K02gsoPc1DrvZhL62A4ju8uAzCPXWTrgmXos3PPrFOHg8olhps64LPhpTCJ0CaI6xWITW4rhDLgJ/7VUX0ZeLlMl9Pre+0x5H7kuf9n5LadS67lbQ/l+CCkUfJQliPSOMKme6lPjOyzI+mxgukTeLJFLG1/OtpRqWWi5ElOasbCWKM+YBo6T2HSXPd7bBDX4eVz2XgujDLnWYfeQAwCQtezdLxy9Zy4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeVp4owKTUlKLbYkvnD/kfHGubArMi0HthuZftWM/NM=;
 b=oKXp4F62SzUBzASfLjhf1eebgAfPLJkq9BDpudoiQ+7gANEns1fLtZrPVPJjw0MAjMpLjV5bNm5r8nrbCYIrNyeXu+E5UdZdPTpJmabo38QySswXQiGUBvuiuf1oBz7sUL99m5cQCNiEjOrTogTDuEFe35b0nAc3749oOZMw2YY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7851.namprd04.prod.outlook.com (2603:10b6:510:e8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 12:51:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 12:51:22 +0000
Message-ID: <9eb0c082-c9f8-42a3-9099-3c3807307ec5@wdc.com>
Date: Mon, 9 Nov 2026 13:51:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Jochen Philipp <a2jphilipp@gmail.com>
Cc: Dongjiang Zhu <zhudongjiang@fygo.io>, linux-btrfs@vger.kernel.org,
 Naohiro Aota <Naohiro.Aota@wdc.com>
References: <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com>
 <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
 <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com>
 <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
 <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com>
 <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
 <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io>
 <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
 <avGNQ29RVwByM4HC@mayhem.fritz.box>
 <CAD=K2o9Q2XHozQEY087HUa6AV1obAGQXFsan+B8Aomm0xyXcxw@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAD=K2o9Q2XHozQEY087HUa6AV1obAGQXFsan+B8Aomm0xyXcxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0184.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::7) To DS0PR04MB9439.namprd04.prod.outlook.com
 (2603:10b6:8:1fd::6)
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: ae8545a4-396c-4da0-7145-08df3e6027d5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|19092799006|376014|1800799024|366016|18002099003|22082099003|10067099003|4143699003|5023799004|11063799006|261028144727099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|261021121427099003|56012099006|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	sM5JRjfU10qI+TohaxHGS7melse7EQz1ZB2DEPltBxLt22aWY50mY8ncz9yIPcFVqiVHH83ifWWUkmdbEsuPlpCdoJ3MCWnwGf272QzxlJz73XeS9dwd4H4tN+GZgOZgZB4ppvYsPv0PN6maRFwczg7h6zxN0ytTkwjow5ABxi215r+3QoVAQH+tyMq1T0k8o24Q7wtvqZX8tEkvcHbvHZUlV0m1liIFBB7FUPjdmbt6jTodgINIX/qWwvSZqBXpESkm2Z7kDTvJxJZ+KLk6T+n3NQTBwPzMawpxxJ9U27S4WZImfKwYPn53ZWN5dg3YSAIOAc5U0UqXsRMxpwr1DmTjMaHzqaNcaXUZYj8Wdu5WrSo6CEWBAL7FRtSMF32phuGXLfjU5PjDbNFg5uQb2o3N2v8PyFeu0+GgFZQd3ll3QME5Ze6HMm1Uo0bul76Kea3TlBCWyxQvsgmsW1p7kKPTakF7UO+/a790HTyuKdXhMXJ/f7tt24OEl+M/r2vxxVBXfO/81raIEJmddBzJpPb3JMn+KFWqueS+8Lv39P8AnRWfzJHprJCq0R6bwmoB4qjmuusfh+7xta/Id8PjgypIs0NC6aLq6AZW/qgfagGjjJseSYpwmxHnOdWkSn3e7nNwYKumT0fA9A8AoXKYubRo3NCz5V09l3KUtvLddPo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(19092799006)(376014)(1800799024)(366016)(18002099003)(22082099003)(10067099003)(4143699003)(5023799004)(11063799006)(261028144727099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(261021121427099003)(56012099006)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFVyU2gxcXg1a2ZINWcvd2g4d3doSTlvNllqUkdmbVQ3NUtQcEE5eHhWVXhC?=
 =?utf-8?B?M3VkbUFCbGxpQThpNm1GOWNaNHJTQXdTalRDU1JKclBqcnVDRXFoZFZVa3M4?=
 =?utf-8?B?aVBYN3VHeE9XZ0RwYkFSUFNrcUdLNHNVdUVsOE9yUVoreENBT1BhcThYYkdV?=
 =?utf-8?B?aHBJUDVhVmt1c2ovZE84VG0zc0xwTHNWMEhuT2o4QnNBQllDVFRrMXplMWsv?=
 =?utf-8?B?OWRjQVp1RFp5bnVNUFM0eSt3N3QyQUkyVVBWdnA4cXl2Si9PS1pKT1RXYWZV?=
 =?utf-8?B?N1NxYXRpTEdrdnFnZGJBc3MxeUFaTnNzSEx6ejVaeE9KYXhKQXV2ZHA4Qi9k?=
 =?utf-8?B?S1RmSU5EbFR6MDlIUGRZVW0yckE2ZWZ1UDlGTHUwTFdRb2JCdWhiS2l2OG1L?=
 =?utf-8?B?TktqOGhIZ3RwamwzMk0ydDVlTFFoR25hdnduZEt3aE9EWFhUU0Z4eVFUbEE5?=
 =?utf-8?B?ZWtTaUtUMXJVdDV0eWRTOXJSN2tZYUZ0dHVFVEN2eVJ1Nmc1cDA3NWZDRkg4?=
 =?utf-8?B?MjlFTFJOS0o1Qmd3dTVQa09oOUNrL2VybE13cjNXRUp1V2xub2MwYXpsNHIz?=
 =?utf-8?B?dTdSMVl2Q21NcktRY3B5THlMbGJQYWRBYkJUR2lWeGl0RlArWnpkVWYvNU4x?=
 =?utf-8?B?NThadENsUGVLVTBldU0ybDNmZy9nN3ZHb1FtM21jbHdRM25VYi9NZWlUN2pV?=
 =?utf-8?B?M2xqY1QvNmt5RGNqT2JxSm05WFRQVWkwd3Y3MVk0clBJT0FMKzdaSmsyeUtu?=
 =?utf-8?B?Qk41MHJSbmdIRG00NUw0SzkyR0IxRVAxclhLQ0pZR0xTdHZyMXlNTHk4SGNH?=
 =?utf-8?B?QVhYQnlSc3Uvc2lvSmtZciswMlZXYWkrMW5rditzbjRLNm1qakxmUGlIdzNE?=
 =?utf-8?B?TVptN291UFN6T3NmSk1wclBVbXZ1dVptbjEzdzV1VTR0alEwYWJ0K1gvWElH?=
 =?utf-8?B?c3VLamZGamRkUWdzZm5XQXF0NGpFTHhzRnAxL1FSQS8zc0VYcXMwQzN1UjJu?=
 =?utf-8?B?UUJmSU1GS0dzUUt0THd2aGdWTi84MURNWmVOcEZKM3JuRk5QVVJFMTVjQVFU?=
 =?utf-8?B?NDcveDFnRVZzOVo0MHREM1FxU1Vxcjdha0lqKzdRclZOWEhpSkdSSmtnSVVW?=
 =?utf-8?B?dmVIaC9IbHUyaXdhRFJQMU1xeGY5OFZFWFBGM3dEWW95Zm8rMmV4WElRK0ph?=
 =?utf-8?B?TXVBV2lBb0NxTWZQU0d6YkM1bEUyY2F0USt2dWx0Y3Jqa3drdDFnY3pSSFdC?=
 =?utf-8?B?SnFxV0szSGZaWUtSL29FZUs3L3BxTmhZbThBSzE3SUI1MGFIcHFkNDlYaEpU?=
 =?utf-8?B?RlM4enBROU5mZ0M2d3ZYdkJDUDhZU0plb29rOXVBaUpjbDRySzdUSWpXMXp6?=
 =?utf-8?B?NURvcWc4NVhYYmV6VVhlYkwwcnhNalNMZUFyNU1VdHpSTVEyMWtXUXAweFpU?=
 =?utf-8?B?cDd0M2d1bnhzeExhVnlEUWVrVjFGcm9GNWVFMW5hTUFLUXRTUGZ2UmNXeTdO?=
 =?utf-8?B?WGdsZHkrUDRjdE84djU4em01NGpPQ2g4b3J6MGpTSC94RHIwYk12OGJLSWJr?=
 =?utf-8?B?RGhnN1hSTnNmSSt5NXczdGtyczZjR3NRamhQdStEa0NnSkNLdWs2R0ZRTEVl?=
 =?utf-8?B?bzlOUHZvZGtVeTk2YmNVQXd5SldKYzdtdDJtNXFNM3AvNEFxbFFOVWRzS2ZI?=
 =?utf-8?B?UU1ZRm5DUGNpbFNmRFNXZUpXd3YrT0xucittS09zblpKUnRsRnBKellKaDUw?=
 =?utf-8?B?YzB6eTgvV21HTk1CRHBtWnhLVjJKcHoyNk9LRWxaL0IrVzJuVDdUWEx5MVQz?=
 =?utf-8?B?OWZDQVROeko0Ukk4UThEcUQ2NzhRdGtSYTVCUVVYWUtqNHJrd0NwQ3JVenla?=
 =?utf-8?B?c3V5V0x2TEEyZjZvblpKdXhHYiszRjBhOXJWRTdDMHppZTFSc1NXSzJZTEov?=
 =?utf-8?B?NDBDT0d2clNkSThUQ1VJSUZmUHhpT0JCVC9CdjdyVkhMZWZuYkNHQ016SDJT?=
 =?utf-8?B?bzRCa0s5RktEejE1ei82TkZVNi80alJGdDNqRmJoT2xORmloM2VKNkh1amRv?=
 =?utf-8?B?YW9wK3lYRTlZUW9uN2dLKzhianlqM2U4cGZ1WG5DOUIrU1hFajhIaWJBdFhG?=
 =?utf-8?B?aDNJWGNPU05sdG11aEpqVFdwTFMyQjNLSnRVclU1bWNOL2hxWU5OQ3JoMXhP?=
 =?utf-8?B?UDFwWGt0dXowei9PTXhwK3h6d2lvZFkwc0FJYjlDZEd5RXFtZjVJbHR5OUFD?=
 =?utf-8?B?cXJCYUZBaXdTeU8zMlFDTEJOdDBmeGZ4Y0Z1dFpiUGdGNDJmNjhzM1kvTmdM?=
 =?utf-8?B?ZWlyREVzYjNhKzNvTHcwSWI2bVkyMHN3dFArclBXeWdNa2doNnU1TFp4VE1y?=
 =?utf-8?Q?i63/B1Hc4ZwU0/qiAZJKp1AZs7m5u75JsjGfcKWahGF21?=
X-MS-Exchange-AntiSpam-MessageData-1: Px87AEJTuSzCioGNFK8lSUuLjVTQCZJd2BI=
X-Exchange-RoutingPolicyChecked:
	Bd8ulgfumhAbMWqXqzQ/IP5y4b7MQT3B8mVwYMdXJy5Qqb0nToWsKkIFUSbmnv7Ppslj6DHZ8VS+RKIRBMNRBIAlOXSMKieI/PoIKem9GgNHACY/TPehaZyoQmEk98mwhvVg4FXZ9vFs8glH6IGnuZZqmzrPHc6jz/pdJwyW77b8TqQSVECuuiHy4+0Le43Od3AmEGT5e4KpFYHm9QgxrTr4AQvPH8FJfOVeTLOu0bj02fYpNf0KUYwmHmInmVvl8re2I9kOldQeGlQiexVDaPxtsEzFQ5pfPs2XCCGJuwa6JtWyrRuoXJPNGDTvSapM5KbBcQJGZArSxJVxrP28wA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b6kxk7EcuWWmAZGE1srg54dvs9NOcrxwFkZCIb6vd457Ln7zayWiPhPYSYh//L49gLRJhp0lkTm2jRYh6L8ATiyzXzQ4ZFNUug0uY8yllfpKVWtVonmVOs0TnjgalKlQQimC02yMYMzRmFSKAQZ26v9WpFeb64simNwt3WQDQaDbgnPee3DtxTBWRn+dCoBwAr6z7DzcD2/lHQGq7hedDeMagNFeda0mFxZoLTDiU6yCxgcLFgOpRzLn9MdGySo5rYoNDtAd/w1vFByX5crq0/mQ+eQE0XZfd52+6UZj/+D8QdxpKQv8MwxDgAjReHmLRIoQF5eIvOEvhxdM0khfKzBmVxz5iUI9Dsj6cawnfSkEwOH4ovqC8z3iLfYIzZxKaHKKX2CTnr81TNjyj5YqzA2cYJk0ypr9g5qU2t0WV+THRfR0Y8j/tydOkdhhWfZkrifqxohuSjQeEXjmmoajHRHpto7vVeGwrnGywQd4lWSfGlLJiDX7P2pyoyG61uSCsJMUJNQjgYNV8RfINf9ICeC5kejTqbrE78ZMs5gDnnHB+ZS9MZuaydp6smBm2lBO332p6XtEQE5UxPc3xAqhSQyJvqmlLoB48/fSZW7a2qi2s83l0nixKFq5L3dK9BP3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8545a4-396c-4da0-7145-08df3e6027d5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 12:51:22.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j7AMh63dXGGinqbPdBqejNGxpkETK2+HzL6SyVOErJTTK+AgvvvKohVl/RXrskis2VxBXdleBuyDf7m6g2xv8eHvMIQOXfQKEElQMoiLXFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7851

On 11/9/26 11:01 AM, Jochen Philipp wrote:
> Hi Johannes,
>
> great news that you could reproduce it - thanks a lot!
>
> My test machine needs a couple of days to get ready (new SSD and
> thermal paste on the way), so no rush on my side. When it's
> ready, which tree should I apply your fix to - Dongjiang's
> for-next base, or plain 7.3? Or will you post it as a proper
> patch / push it to a branch I could use?
I think it should apply to all but I can push a branch for you if you 
want. I'll send a proper patch and testcase for it ASAP as well.
