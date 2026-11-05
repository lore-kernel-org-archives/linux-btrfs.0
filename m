Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793894964;
	b=tsziFFm36u3m5ZwHwwd+xIQyB9AB+QsL7+cNu6Th54evTISTTM8LwT4lIHYjAt1pfXwL
	 6Lc9gXiDtYZeqvmB/zsVreLzdTh/4Ren444e3qfEzP1N6hFhFKHihWTZZsOuqtSCVPhno
	 +wKPoW+zQ9l7TQpkoOJtEjF55mpmqUxUzfYCTrEDkvfkvPxHuiYNr5Yl6zwFnpJ4CuW/9
	 X89hRa84NA8bYyzmD3g2s/57dDe6Ux7H/o30EURtPFNArZR1FO7kG9yTynXBfpysgq2F4
	 Mn8/Zj/uY/8ddUEzHMJbji+1MzYbGZ6WHTe5NfvKxK/zogWSxpCsmicxlo9GZMxnH0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894964;
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
	bh=oWhVNTD1/faj2NOzGvgQW16NTAgAIW9pPQ/4NlyM3ps=;
	b=jsItOKVYB8LlJr0yUfhAwGnOmQyu/BGsFuAepGGn+NLxZhgDTpySjvVfjSw0u0g5tc5l
	 gReo0w1enIjKEGLsSZT9HM+2zvsgd0H6njdDMRtzoFPnGgJqn6uGogHxWHid2VLDyRau8
	 x0+7NirHebje7uPPy2JDKvlgm+MhNuHYlDFelz/b1o4t+30FTfCWXY3WO8romTA26QWXh
	 s1kGYqJJCvoRjXhtjOV/4Z3h/CkgM+juzTNe98E/QNFrcg8H9tN2PkSFe3FBG9IFdIikX
	 DW90aX8AaApe8nCn18HF0p7xXEqR6moiWChte9zZLE2udaSNlAwqN4RFUmXiz5kVmJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QQL50u3L;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=jPuxrSyw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21D4606A328
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 16:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A21D4606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QQL50u3L;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=jPuxrSyw
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793894963; x=1825430963;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OHg1Is4/NpCYIKTkhQPwZLGCZx21aqOvIGYV2dtt2qM=;
  b=QQL50u3LrTvu1Tpesr8VN0teDyTwqxIQevQdv5tKH8VGBYRV090wPmIL
   C/2n1Qofb715TOeSR0PzrZ2P6GOsLLvnX9CWb3R/+KQqkNWNo1sJFo8/9
   /gtDt2EemFDvIE7mBGyP9AT+NNQ/vmEIY+DszwUJWkghDTIE5qhk/m4gE
   PIeiLsTC7fQB/FS0U7xCF+IaNGb3VaSVRJ4K/fo52/VLO5NdJjp3NAyYJ
   rPKugmedkz6OctK/2kkScWlZbr1oWYHtJdMaYOOEYlHdo+/e7ucwl8ALU
   4FGWYPyc6QnJLneGaJzRGALG69Uq/cVBVzlnUdD21GmaSQQ4QYGRRmJ+l
   g==;
X-CSE-ConnectionGUID: gg4xFLWpRNm/xj8gjMa/cg==
X-CSE-MsgGUID: t63bL3uCQpu7KdqTQgAL8A==
X-IronPort-AV: E=Sophos;i="6.27,197,1786982400"; 
   d="scan'208";a="155673480"
Received: from mail-westus3azon11012010.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.10])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Nov 2026 00:09:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QKpqHl1Ce3gjt4zmiu6gCknsXwGFERN3lpIiqeYLtF4t37I7L4dFC2ceccrgV4M9jPbHnL3QaSJPJdeh1uh2acXNoVjF//VYEEifcPEDCg6HGyu+593ZyNKdJu3hH2WzBBlqjDPJd/W4MlmNlE58Xq5TpGD9b1p0/xbATaITrRvYZYR3X6964fb82ypiyfoCeNFZW1mmikDqjVGOpk9daMKYwioPF+nQexoZ9SbsQbHCeHEN9vKAJ7GvQstBsp7qGC/gxuwfUmcTVUwCUOErmasO4hmiKEMmTkSfjf9xR73ayW3NHIrkuY8Bu/kOvQ8zoiq9lAnWn/HbqOjE+7RgnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWhVNTD1/faj2NOzGvgQW16NTAgAIW9pPQ/4NlyM3ps=;
 b=Q+5ybcS6xj7h/zyUxUH2Uq/OEffaG46u+lZMMi9ptIM5Svl94lT89YZ2wMTl4OY4yTRwu1gfYXUWayzZ2BTWnQcWRl1sFclt9Rzot7tLGzlm7U8E+iEPlw/twLKtGmLyYCSCS/7Y8Rk1ZrWMicH9cAkFIpzLpQJU9Qvuei/JaFG4GuEsKNyycgWrnU/tRUxcKZapbInP24kToSiAWCQWw0FoaV/1zFkZ7PcSWrOAaDBkR1vkuD3JPueEFg+rPUPPIp1WNVo/KAX/jR+6cZgeXIZd2UmTkqHujO4kAOGfv8SAllHJ4005TpYKGjsBjAhFw0T6tAaS4ZvC43cZ1FxyEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWhVNTD1/faj2NOzGvgQW16NTAgAIW9pPQ/4NlyM3ps=;
 b=jPuxrSywWtw0ao2QtNTfm55gwFligrHDbtprGjVwJ1VLdQcMWiJJV9Df7Uv0bhmlEWcyWtjLrfcvyV2xM+Urrt2+UVALLt3K0lIFbFl9F+T/e4hRvMyOnEXh7vc/Q0tr/V9+XyhSjc1C7uCq04MMPl6lpd/faQhYE2XDcydkZV8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH8PR04MB994048.namprd04.prod.outlook.com (2603:10b6:610:35e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 16:09:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 16:09:14 +0000
Message-ID: <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com>
Date: Thu, 5 Nov 2026 17:09:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Jochen Philipp <a2jphilipp@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <Naohiro.Aota@wdc.com>
References: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com>
 <ca6f02ee-8b39-4e90-9006-a6f0606e26f8@wdc.com>
 <CAD=K2o_-NwLNpvNE+OreAmsvX+izzZnb2R1nCBV0gDf6fH=kmw@mail.gmail.com>
 <904615c7-003a-4158-922d-c57dee9a3ecf@wdc.com>
 <CAD=K2o_vLPSvm4Qzi8y4t5ay+Na9GNk2t5a3iMO3NYJvwodKDQ@mail.gmail.com>
 <CAD=K2o8xFgYBHMim-KqMysV+Tec9LEUbo6jfD6R-GOAU8N8K4w@mail.gmail.com>
 <CAD=K2o8kWgTRqBBw1sRfO2fopqQOLfdeX61h=OFPMST=Wdo+KQ@mail.gmail.com>
 <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com>
 <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
 <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com>
 <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0171.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::16) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH8PR04MB994048:EE_
X-MS-Office365-Filtering-Correlation-Id: ac9ea331-3c74-44f4-1fa7-08df3b572306
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|10070799003|1800799024|19092799006|10067099003|4143699003|11063799006|5023799004|261021121427099003|56012099006|261022105027099003|261028144727099003|261102123227099003|261026140227099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	20i2xsA346N/hmT0P6cJTz2nmXaeMpClaAaqSNkiejGncQdg+UASQ9odur9s5+cUYBJuTWSjxyeKFy+gKYtVsm8A5loTKWcgwKDiwc5iHedsVZJ6O2NCItsrd6xVhrUp8bN3mqnecQEnAE5D5oi+S0M2LePATf6AQ2nsSe45SGhWgggRabw2YwMWxCpQyfIexQX8QvirKlHv+COcIeVEAZ8J/azOnqCqspDkQJxlTBPsEotF9ukX4BUwBYSrZL4X79j86Fm3wos9LwnEls+k0y4dG3jDuBuJub99QvIj9U9kIcQ0fpYNuRd/d5s3YSLZDMr3g89tIEAEcPaoOQNq5CwwlMVtec/pI9p2glrwgwGHA5S8l/mbcp6NzlUDrIYoi+B5M9h9O8AQb2xFJYTwDw5Xl/E5TllYqLYV6Z7QD7s4q12CHWDXLF93g/zxAWM+9AJ5bPl2E3PI1uAjOgLWzTtSYZq9X6rj0w7HoyRqIUQWNaXAx16Lre/anezWa0F1JRxb5bVg420SmLT9Oo41TI2YNkzVsjRag95lW8Aj/DvTKkSq1lwVHq5bYkLlITlAc8FPnjaj2ytMQeQVEGkucyYZGl4w8xBlRgnQ78VcUSQphp9tGsTCiz9Vh+vorUOrhNLPpHN8diSQLGcAm+bxtI0jplKrxd0ta/BS9I5YQ8w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(10070799003)(1800799024)(19092799006)(10067099003)(4143699003)(11063799006)(5023799004)(261021121427099003)(56012099006)(261022105027099003)(261028144727099003)(261102123227099003)(261026140227099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDQ4M1grOVc3RjBpbVhHT2YvWXFpUEJBanZRWUpCcThNVkNSeE15UyttNjlP?=
 =?utf-8?B?SklVY0ErK3NVVHh5cjFab2JEblBZQVdsWmdmeG5vUitLd3NSS0NJZnhYeFdr?=
 =?utf-8?B?MDA5K0VOaXMzbUt6VmFLdE03SVY1b2xlMlVlS3Q5Qll4dWtWZ2YwcDVlYjhB?=
 =?utf-8?B?L2hJdDVLWmdCZWM3bVJtcFhycnc4T1JMMnlLRWdsNlp2MkVoZlppUjFkWnY1?=
 =?utf-8?B?dUZQVVB6T2hlWEVCMmk0U1B3aTdQN012ZW9hbkNYR1F2RWo4Y00zWVQ4cVVY?=
 =?utf-8?B?alRUS2RFZnp1OXI5cVhodmVUaC9MMm5XeVRoVHNZN3k0azNmZkhLQXhmbVAx?=
 =?utf-8?B?djBNcXorRkdsQm41U3VxT29JMFFtSmhrR0g2MG8ycFdiTWMxeDBvNUFrT2dI?=
 =?utf-8?B?cHRteWwzc2tyYW83ZDRaK1YrK29pcEpYVWdHaStQK2VLMDlBRDAwd25OQ0pl?=
 =?utf-8?B?QkFxN2t2THhSVTJnSWlPYWx0cmpuY3ZwcitnS2RvRVM5WXpVN1dCSzAreUR6?=
 =?utf-8?B?a0cvcnZEcVl0dkhCVnBTNExIYTRNdFdPV2ZsZmhpTzUzbHZ4UnhBbmdBRDNV?=
 =?utf-8?B?NG1BVlpoQ1orWDFPUGtKYVV2QXBIbmN1OSsxT0hiNWt0eE9wb1Jnckd5Wloy?=
 =?utf-8?B?L0ZCZzc0c3Z2YVQrSGJoYWRNUTM1bWdZZ3lXZnF3MzJGaVhMR250UE9nR0hl?=
 =?utf-8?B?OFA1aVlOZGRXRS9hN1BwTVRsYkpZSE0zZ1hZbk1HN1pnZ0hsN1orR0RhY3BJ?=
 =?utf-8?B?UTVFQ0hvWVNPb2RoTXppVXAvNS9sSWlMZ0wxYjlhajZXL1BPMDFNZys3OXNJ?=
 =?utf-8?B?Q1VGSU9SZmR5bWQ5cUIvMi9VdXkwUlZReGR4QVVCTm5nQVNtRm1RQUQ2QU81?=
 =?utf-8?B?bW5wY0FsL216RU9pYjNrY0JJY3c5VDJPTGN3VndGUS84SVpmZnY0RmVSdndB?=
 =?utf-8?B?bzJJZEh1aE5pUVBQbnFqMHN5WU54NlVoWHJjZmczZndEYUkzaDJaU2l1YVVN?=
 =?utf-8?B?aGhpSlEycGFFTXJ6aTh4eFRHSVN6M09EZ2h2WHNVeTEvT3d2OXpiNDZBeWJI?=
 =?utf-8?B?V0l1ZWs4NFR0UlEyUmFCb2gyTlJnQytmVlFUTzJ5OE1oQWc0TyszdjBxZUlR?=
 =?utf-8?B?TlMwUmY4dm96WWUzQVBRNXgyVUJMRW85bTZTY2MxUVVRSGVERFNpTVZWRWdr?=
 =?utf-8?B?cWcySi9JbThwV1pyYTlRWExCRS9xcm5IQVkwVGNRUExTMjlCVkU2aGtCSHNR?=
 =?utf-8?B?UlJKYVJRR1hCN0F2Q21sOW93YXdkVWdhU205U2ZyeDJxNXd5Y1liN1RTZFZH?=
 =?utf-8?B?eHh1RmU5Z0wvbnZBOGhwTk43YzJEYnRrNlRPblQycE5sUmRtMTRaM3lqN0lE?=
 =?utf-8?B?dUVaWm9PeTFpYWdTbHFScjlqNWM0L29YRWRuSEF4UEZQcjRyVzdpdnlRWDFY?=
 =?utf-8?B?SENLNTMySzlSU21uRnFTQUM1T0dXQ3ZHS1RlY3RZWFBuQkZHOXRyWjVZVHk0?=
 =?utf-8?B?cm40ZU1xTHdLVFRyRWtKZks4SXUwZ3pNaE9qcWVTNDlrcnFVaERVVEsyVG1o?=
 =?utf-8?B?KzJNdzFCZUY4YzJDOWhIb05lRjhLb3RXazJ4b3YySzkrWldCeFU4c294SHhm?=
 =?utf-8?B?L3pCZkRCTGk2VFZKamVBU25XU1hqRE05L0dDZi9QT2VqN2QyMW55dXNEWHpl?=
 =?utf-8?B?ek1veXZDSG5ZblRVamZ6ZmxLVlV5QjJ6aTdQV2pEREVRc2pCQ1lQOWFCK3Jj?=
 =?utf-8?B?LzVxbEtERXNaZVFDUm9rMk1rd3cyU1ZHY0tzaC8xcWE3a0NzNld4YUxBL0Jl?=
 =?utf-8?B?bDVpRk4zTXJkUjYwVUVzNUlzVTNBUGR0YVFSczZIUGVjd2J1ajl3Q0JNNllM?=
 =?utf-8?B?OHZSajJtY2tMemM1aFI4ZXMwc2tqc1ZRZFRoS2dJMWNpRWxSRmJRRVBEbTc5?=
 =?utf-8?B?d0QzbFNoN0psTjkxVG9EOTRqRDZtdTR4YTEyaXkvOGpHdEpiRG9zOGtQYVk1?=
 =?utf-8?B?dEd0eFVKQXRWdEZsL0dWbW8zNGxpNVRwZlBnbndsTjdhbWVvVUlKMEhibWgz?=
 =?utf-8?B?TDcyZURmd1VmM2pGWm5EOGZnY1RLdWhydGZGUUUzam1NZ1V4bHhOZDdjYmZK?=
 =?utf-8?B?b3lxVjlCRVpJbU9GaE5hb1lhN3k1TE5ONGJaL3hjbVBCOHpJekVQeDFXckEy?=
 =?utf-8?B?ejh4czZqRmJiL2xFZlQzR203Z2pCdmRaeHdIYzA2ekhUeGFVbVJVNU1OSE5t?=
 =?utf-8?B?bTlPVFVZbmZ2dkZ4RnU0YjhsemFzSGZ3SHJHMGtzQTFWajExT0RjRXc5RG0z?=
 =?utf-8?B?dldpUDhCVnFOQUtTYlc0a25vdFp1OXhkWlZLb3ZreU8yVytMYitEUmxzaUgx?=
 =?utf-8?Q?4wQVPCfhILjJftDcESpeG11AkAxQYvSz2xyl+vekEdlSm?=
X-MS-Exchange-AntiSpam-MessageData-1: muSDEXIpLB6Xp44aoz7Qsbrono4HijgJcAU=
X-Exchange-RoutingPolicyChecked:
	GtMTi/thkc3m1u1hO3lTWp2ZmhzoUstL5zvILg+DS+01LTfU0AR2b9wXHd6l2lDa+mO8YjGZxoMXyPu6qhqkHsw6lgjTr5bM0r3H26ZJxpu9oQX4Zz4pGa3VUfwVkcX2UfIeW/59NZuYF9vdSV4w7HhcWX5nZYOrEgmL7tivFDnaJXikrQsGJc9uyUN3zmtB+kofyYP66ph9tnvx7C3txOGW9DnvIrxtVSIgzcXmzuu5UNtu9jZxl9xvU3Mr6UQsoNfDzlSmYRNpVTVsKpqWZd06Wa+p+HTJKRwWetnFbR7L1iQdf/4xir8JFSmfc6k1Kv90UOIgpya6azoWiSDIdA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZV+omh4XJdHnJij6Q6twXLn64lv1o9bs3c0UjsrfxvBMmp3fXpdttPCKzdAo4627RaCHQoVT3bYingnDweBcmgR7ppTvpgPqxKpBP/Z+iqBmLwUB3BfhWkO8mqV7aJxMzfTZqZF6QdlgEzwE5Hf5QG+sYvkMYsk2jyTN7KbVJhZwKTn2Jr/tGRJ7BNo0XOT+J6IklRu29UPtzULSlKIMTaxNmLHJuw5MVwaQThSNBeQ1zJrjw/jZ/Titk2bHeyWssm8HdEomyLtv1WKNlGGvm81vsVPUs9sqymS/w1q6ZJ39wdqiySkvWL5RIXnR7YWlEqwD7pNpSJ7w32tNasiP+GbA+cVkiyN346wEgWrvvbhi2sfv3Pm4mFiuslRotXJOl9ilDpxxU0CpnVevaPukx7ETLhl5JBZDY+Y3l+QK+kgbzhG3Q5Ri66FUhPidRRzIFISMUqfPL5tl61rX7uWS5bftu31fc6NvoacvNps/Sp27tdf29knJon2iq+iEm9IVgTdpOBuYdCrqLrnJcfgHuKUrkxgSJFt9R4bAHedERL9BOyjIaSIzJTpbGFC3p6M8gWnhfV5fnpCJnXEFZMxk+IqzvodmWM8zkTY/lpB0Hw+oWenuveyACTZJa5jxVniB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9ea331-3c74-44f4-1fa7-08df3b572306
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 16:09:14.8030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78S6oOWpJICbkDJR/KP7De2zCkW+3W5xFieBmeWtBcgJwgZf5tG71tSyV/mKPMCs2MI3w6udriT3rm65kC5Ug6vKA4UGN9vWL1x126I5AQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB994048

[+CC Naohiro ]
On 11/5/26 4:19 PM, Jochen Philipp wrote:
> Hi Johannes,
>
> sure, I'll leave it untouched.
>
> I had sent you the full report off-list as an .xz attachment,
> I suspect it got caught by a mail filter. Here's the condensed
> version instead.
>
> Zone state summary:
>
>     1918 zcond: 0(nw)
>    30387 zcond:14(fu)
>   159343 zcond: 1(em)
>      128 zcond: 4(cl)

Thanks. I'm a bit puzzled why we have CLOSED zones, I was under the 
impression that a FINISH set's the zone to FULL not CLOSED. I'll have to 
re-read SCSI ZBC for answer to this.


This is different from your problem (which is holes in the metadata 
write stream). If you could upload the full report somewhere that would 
be great. Also if you still have the full dmesg that would be awesome as 
well.

Thanks,

     Johannes


> All zones that are neither empty, full nor conventional
> (line number = zone index + 1):
>
> 4097:  start: 0x040000000, len 0x040000, cap 0x040000, wptr 0x001ad8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 27890:  start: 0x1b3c40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28076:  start: 0x1b6ac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28136:  start: 0x1b79c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28152:  start: 0x1b7dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28273:  start: 0x1b9c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28275:  start: 0x1b9c80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28318:  start: 0x1ba740000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28319:  start: 0x1ba780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28372:  start: 0x1bb4c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28376:  start: 0x1bb5c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28377:  start: 0x1bb600000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28400:  start: 0x1bbbc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28435:  start: 0x1bc480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28516:  start: 0x1bd8c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28524:  start: 0x1bdac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28556:  start: 0x1be2c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28641:  start: 0x1bf800000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28642:  start: 0x1bf840000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28649:  start: 0x1bfa00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28721:  start: 0x1c0c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28727:  start: 0x1c0d80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28728:  start: 0x1c0dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28752:  start: 0x1c13c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28895:  start: 0x1c3780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 28957:  start: 0x1c4700000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29030:  start: 0x1c5940000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29308:  start: 0x1c9ec0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29331:  start: 0x1ca480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29332:  start: 0x1ca4c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29395:  start: 0x1cb480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29428:  start: 0x1cbcc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29432:  start: 0x1cbdc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29450:  start: 0x1cc240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29528:  start: 0x1cd5c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29690:  start: 0x1cfe40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29696:  start: 0x1cffc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29705:  start: 0x1d0200000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29727:  start: 0x1d0780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29792:  start: 0x1d17c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29885:  start: 0x1d2f00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29921:  start: 0x1d3800000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29938:  start: 0x1d3c40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 29939:  start: 0x1d3c80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30029:  start: 0x1d5300000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30038:  start: 0x1d5540000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30081:  start: 0x1d6000000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30083:  start: 0x1d6080000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30155:  start: 0x1d7280000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30156:  start: 0x1d72c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30196:  start: 0x1d7cc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30291:  start: 0x1d9480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30307:  start: 0x1d9880000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30355:  start: 0x1da480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30410:  start: 0x1db240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30524:  start: 0x1dcec0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30538:  start: 0x1dd240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30576:  start: 0x1ddbc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30637:  start: 0x1deb00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30720:  start: 0x1dffc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30754:  start: 0x1e0840000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30764:  start: 0x1e0ac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30861:  start: 0x1e2300000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30939:  start: 0x1e3680000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 30961:  start: 0x1e3c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31006:  start: 0x1e4740000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31007:  start: 0x1e4780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31029:  start: 0x1e4d00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31160:  start: 0x1e6dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31161:  start: 0x1e6e00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31218:  start: 0x1e7c40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31219:  start: 0x1e7c80000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31226:  start: 0x1e7e40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31280:  start: 0x1e8bc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31281:  start: 0x1e8c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31375:  start: 0x1ea380000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31478:  start: 0x1ebd40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31632:  start: 0x1ee3c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31659:  start: 0x1eea80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31660:  start: 0x1eeac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31711:  start: 0x1ef780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31783:  start: 0x1f0980000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31834:  start: 0x1f1640000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31901:  start: 0x1f2700000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 31966:  start: 0x1f3740000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32010:  start: 0x1f4240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32028:  start: 0x1f46c0000, len 0x040000, cap 0x040000, wptr 0x03fb00
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32050:  start: 0x1f4c40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32053:  start: 0x1f4d00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32118:  start: 0x1f5d40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32119:  start: 0x1f5d80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32121:  start: 0x1f5e00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32156:  start: 0x1f66c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32261:  start: 0x1f8100000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32312:  start: 0x1f8dc0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32330:  start: 0x1f9240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32331:  start: 0x1f9280000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32365:  start: 0x1f9b00000, len 0x040000, cap 0x040000, wptr 0x03ffe8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32367:  start: 0x1f9b80000, len 0x040000, cap 0x040000, wptr 0x03fff0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32393:  start: 0x1fa200000, len 0x040000, cap 0x040000, wptr 0x03ffe0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32394:  start: 0x1fa240000, len 0x040000, cap 0x040000, wptr 0x03ffe8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32441:  start: 0x1fae00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32442:  start: 0x1fae40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32444:  start: 0x1faec0000, len 0x040000, cap 0x040000, wptr 0x03fff0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32445:  start: 0x1faf00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32446:  start: 0x1faf40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32447:  start: 0x1faf80000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32448:  start: 0x1fafc0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32449:  start: 0x1fb000000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32451:  start: 0x1fb080000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32452:  start: 0x1fb0c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32453:  start: 0x1fb100000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32454:  start: 0x1fb140000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32455:  start: 0x1fb180000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32456:  start: 0x1fb1c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32457:  start: 0x1fb200000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32458:  start: 0x1fb240000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32459:  start: 0x1fb280000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32460:  start: 0x1fb2c0000, len 0x040000, cap 0x040000, wptr 0x03ffe8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32461:  start: 0x1fb300000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32462:  start: 0x1fb340000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32463:  start: 0x1fb380000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32464:  start: 0x1fb3c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32465:  start: 0x1fb400000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32466:  start: 0x1fb440000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32467:  start: 0x1fb480000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32468:  start: 0x1fb4c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> 32769:  start: 0x200000000, len 0x040000, cap 0x040000, wptr 0x001ad8
> reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
>
>
> The full report (191776 lines, 24 MB uncompressed) is available
> if you need it - just tell me how you'd prefer to receive it.
>
> Thanks,
> Jochen
>
> Am Do., 5. Nov. 2026 um 16:05 Uhr schrieb Johannes Thumshirn
> <johannes.thumshirn@wdc.com>:
>> On 11/5/26 2:48 PM, Jochen Philipp wrote:
>>> Hi Johannes,
>>>
>>> small update: my distro has meanwhile shipped a new kernel,
>>> I'm now running 7.3.1-202.nobara.fc44.x86_64 .
>>>
>>> I haven't tested with it yet, the fs is still mounted read-only
>>> via fstab. Should I try a read-write mount with the new kernel,
>>> or do you want the on-disk state left untouched until you've
>>> looked at the zone report?
>> If it's ok for you please leave it untouched an send me the results of
>> the zone report.
>>
>>

