Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793084338;
	b=NX2eB4UNtWWWNUJGvQV6P8xeqodrIt8cgI8udMsHxZDVs06Pqu8epP2odSHZUIig6pvz
	 lKOoBJeWUTUd7k6VTq07Att2jddpA+u9ubFDldLKzhzju0pN+7QYswoaatxnxqRWQw+95
	 el/+gQaWI5bb3ykawUB2fx+w7TbWll66+0ESWNG4tEr0oKQHyv9pItgI3IeHM27Qm42UR
	 bIA8d2ZnyywCxCnKWYFx95hK25u96VWVYqt6u7XgxT+RHoDlWUGr8VgyaFrlUNvghlLR5
	 rid+sGG1DF+zcSDBY8MQoG3JyKt9a8bILWljvPuQojuSHQzw6vKkT1yBsp0ibJlv7Ig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793084338;
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
	bh=hi22QSonnQ8/wjf7gEMSmzVvdoJt2bCCrTDSdRwUDOI=;
	b=nKfp47KY3yR4trsoF6uXpyfOiWf1j2IOUaiWhAnRKKuFijprV4CSlYMmVwiEG1CqFiMP
	 ZMKXsgUWjre/cADStIIPMYug5PJ06ETO4OKWpGPnstTODyXTng13l8rGNA5qeATpYGe2T
	 XQ5p2r8UpJqc6c7PTlEzvwK93nAMRu8gfBFUhvafVHq3Ujg+GwBQvfrAJ2gDf+Ng2vPHR
	 5TC5wuzSKz/ucrDbvdeIpB6Iey3zv8nUFDohJmocuLzVksjI57USCrhMfEn0AkY0Ag35F
	 KL0ETgFlUKXzqcu1eHqJWy7vIyGMbMuON1GkDO1ydC/rIBpeBmlIXXpmYksQQ+aKu+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KBvDE8LO;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=0G7JY1EI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FFD606A31B
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 06:58:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4FFD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KBvDE8LO;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=0G7JY1EI
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793084337; x=1824620337;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hi22QSonnQ8/wjf7gEMSmzVvdoJt2bCCrTDSdRwUDOI=;
  b=KBvDE8LOwArSGy0be7ugqBxyYGLy/DGkbFad/9k1TLRWMoKXHuT57nwE
   YEuwjevWJR5msmB9OQeTAbiF9Vn8eCEYHTDGCX1PFLam6z18eQ9eK3SWY
   FQRnIQ7h07lgVrgQMaUWDsGaJpdUjb9K61/M2vgZrZ2Tz7/k4+3B+mfME
   FEWzMVsEQLNsSNMweJT94w4p2OxeLxT5ncVzYqxCevXiWLSjj6sq+qFJV
   Ei/m3H2it+/vqrMaTmIXRsAD2P2ud2l1HYt8SV2ed6YG4ThXxdpwULz9r
   T6yKoFykwign54gekpBp8mq0BNqykxmu3BJD0sa0mkwYiOcUXUAw/1qZk
   g==;
X-CSE-ConnectionGUID: 3RbZdRZZSqO8GbsrKV01Kg==
X-CSE-MsgGUID: X8vTIbsLRmipJi8f+fDnow==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="158126070"
Received: from mail-northcentralusazon11010036.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.36])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 14:58:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ruxU23q8bKSX00vJBH99nromEHiy4aZUAlMy3vyonCJsEeeWMCZ+2PinCxvZlQCD9VcrDsuLGu6ULIXBkRbBK/skH4NzPGp+yrqxmxemtnWqwt267DZowx9u/kT9lGUl+GYvkHzEdDU8WyQPSf4XfcARoEfVrocm4QlFjQ7mY2/p8eXC1lEYtNrNbcWIxSfTsUf2Fk6vuVjP1ZOVTP1bnrv+VG12eBhJD0HzFbfCIlt2HfUg1Tor3x2RrBbsrgz2Iqm7Ycclbrffr2N9HUqrB715eHCeLs9lHV60kcYj0dZNfckklPcyqlYLpJABkFdDWSDkXmxOP2NOXtkmMq6Htw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hi22QSonnQ8/wjf7gEMSmzVvdoJt2bCCrTDSdRwUDOI=;
 b=ZEKJHA8iq2FvUKIV9guQ3FGzjO8065twH+DYW5gZwZwLJ3yIMttymxruJXGEY80rNr3uZikxzSJXQY5heTAAdoyFvlUqnSQh4jHOOP8SkvvKsWkboTEz7+cPAqlAYx4JdBnJwWIKcs+H06G6+/zBjrma1mi/WmQy/VyS2QXS/MJlJjL190Vck8mRj/A21UZ3aqM3XwuNXwLumYP3v6ZyXVhCH9+AF9XNXzyjenqa8XAKUO7v87oVDBAp/7ZfWY89OUhBPQHl6/jm1SKJWa3N3+msRzli8a29h61eiRGCzg+Nq/C2sxsyI6SP7TysbBS0E06dhq1iPwULfsMh12QWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi22QSonnQ8/wjf7gEMSmzVvdoJt2bCCrTDSdRwUDOI=;
 b=0G7JY1EI9+ELU1EUyCBv4er5mv+pjuHdtL6DfO9UrnV2ucGKAyHkWWLmrWxaFuKjUUxbqN+69cx3Tl3lCO1Xr/tkiJt91OMu1lSQOeJH6zWH0spOWYjXsMFkMlBYIIVhNxXVMdDAF4hWXSfNYxtnrwY84RHSbUeeu0tdCH6uKu8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7867.namprd04.prod.outlook.com (2603:10b6:510:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 06:58:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 06:58:54 +0000
Message-ID: <a5e14fec-587a-4987-8c25-91e4bd2db5ea@wdc.com>
Date: Tue, 27 Oct 2026 07:58:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/25] btrfs: zoned: fixes for generic/747
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>, David Sterba <dsterba@suse.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: 758f7e61-4d50-45d4-fedd-08df33f7c3bc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|19092799006|1800799024|376014|23010399003|366016|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wBFmJMBEIz9eqXTQRd1bNtdnyA/C/R653qV5plGTcpigX80/Wh/DKBYvRTA3B2tmY+pmW4kmUvXu4o2spRw2Uc4o5A1H+cQ6Aobtp+oD9jBDyazrLw9jDpl0eSfmOAcn3Xm1hMjbItzi3dnNDSUeHS/0v8wukL3Oto1wtI6y9NA3lk9Wp7ynZXBeQBYLvmwvjG9z6BDBHE5//MWZcg/Afbc7rwVq+O/Q8WAtp/HY9hl3d6rMaP2GTsE+LstXKvjtewCK2GRhIsKnX1UWsrkQXkn8V9bG2jdQfMYCV9QVeekwAA+uII4c4vIRv36mYw/XHVTDnNdzQFmO4ZORfW1YjDOIc/w5IlBLUVunYt4LqgLiauPk3mwWfa4wd+0yyIfHXY17M0dqZRMajGpqY+XBxLQ+J3jEjLER8lTaJeU5BBkoMojtws0EPCat51l8zxRBb7+rm4+YL0eErHIZmnZHdTwt/duDqhUiO9oQFHl9f1Angy32s1GhI35Qk49PPzw7JtsGEPDt1x4b6rXlfNO8Dki1yYnUBN/JutcZhL/V98fqtNmB1LmDPOEqwaPUIXcPsh11BrTzqWP3Vnbmmuk+z5KPUtnp5H+48Ut0srxaj8NOAA+lg38cbKV/t71pN529X0zreACJZYS74WrOGntgwIlj7+c3JN4pkSbd2Q+Hq+0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(19092799006)(1800799024)(376014)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SE5mcWxaZUdEWjg4S0s2WXgzaTBVeFJpRnA1MjYySVQvV2d1V2V3SHZ5VUw2?=
 =?utf-8?B?T1ovbWY4R2pRZUlucGJYcTlzeTVST2tLbWpITUVybHVkckdWUG53R3VidFVY?=
 =?utf-8?B?RTFLSmFFRCsxaTE0anBuQ1Erc3BSVGowT3I1STJvYjFDei9UR3JxM3liMzMz?=
 =?utf-8?B?NmtYSldaTk4waW9SWUdtRyt5a2NzbGhJVTBvL1hZa0lNdXozSUw0Ly9VQU9X?=
 =?utf-8?B?R09KMFdjd3Y2dS85dGJtWk1wdXJZTEFiWmQzdHhha3JDMTdFR1drdUF6d09q?=
 =?utf-8?B?YlZYcG9xNDdYZkt1ampBM21NZU01ay9XMVAvNVV0NE1ueEhiZUVwK1Faczdx?=
 =?utf-8?B?dnh4RTN4T2IzM25EaGtBUm9hYTkycWVPdEpMbzM2c1NITGlpaWsxcUtzUVdK?=
 =?utf-8?B?dTc1cGZQZytXOXhuRDB4QWNXRzZhK3grSHRtWS8rRjl6OURhL3J0TkVyamRH?=
 =?utf-8?B?WHNnUVFUVFB1MTdHaDFpV0puQ2djQ3o4V2Jtc1dvNEY4V3Z6NmZIK1VOQ3hs?=
 =?utf-8?B?NzcvNTlENTV1a2UyeFJKaXZrWm5VVWVsWlNTR1RaSUpsSG90aUxqQnNaeHRZ?=
 =?utf-8?B?RSsrS1RPQ1FoNElGNGdRTVdrWTUwOVM2S0ljVDF2S1d3YTZnUDA5R3V0dkV5?=
 =?utf-8?B?QzZlUmtMc1ZNTklpREszV0Y3bFRXZy93SE1lM3dqb2RjeWV6S3g5REFOV2dV?=
 =?utf-8?B?NUFjcVBnSGJJV0lvZUl5SE5VR2FDVGFjaGdIODhkQ3NIdTdCcUJJOXRXdktm?=
 =?utf-8?B?Mk91Qkx2VkFWaEY4RnJoWmp4YTZlZjFMYzNhQk5MOUp0YTkwZzlNYm9rK0E1?=
 =?utf-8?B?TU45NXJnZnZLd2hhQ2Q4WnVNakwya2VrYU1HeWZ6UTJmUWZMWE1DTkg2SVAx?=
 =?utf-8?B?RG0zVGNybnp2MXRKdTZMNVpNWVdEU2Y5WXM0dGRtQXhsMVB1bm1MYWoxOXpQ?=
 =?utf-8?B?WEg5bG5LYndLTjlFbnE3VHhSMjZSL2tINEZCRFNnSWVSWjU5aExXMFRweldF?=
 =?utf-8?B?aXgvR21ic0FqelNWUjVxekpKSEdxTTBac0dOc2dpUHhPR2J5YW5lZ2FBby94?=
 =?utf-8?B?MGNaMjJVRWxQcXlFSm0xM0o2bjRaaW9idWd4QnlXSG5GRHVyeEl0d0wrUEJH?=
 =?utf-8?B?VmxkWFJrWGozSWIveiswSHNIUjlsZzZMUkJvei8xUkxCZGszUVkvTmZrQXlF?=
 =?utf-8?B?VWRnZjlnM3p4NUZWZTEvL1pvT1FGSVBaVkJLZ0x3Qk9JT2VmN0w0TmpVY3Nm?=
 =?utf-8?B?SmQxU05pNlZpNzhRVVpVL2g4M2ZSWmh6R1Rrb3UwL2NCWnYyaVFQZmRvSURJ?=
 =?utf-8?B?UFZRbXBUWFMyQjEvdzB5Y3BkT2NUU1JmWDdxVURiQlhHbVdoSzVBZzNzckVP?=
 =?utf-8?B?QitIRkUyb1ZxZ2NtVWd3RjU0STdWSzRMbmFrZExjRDQ1KzVGNlZzK3haTVJK?=
 =?utf-8?B?RXVpVG5aMEpsYmV1cjQ3b1ZwSXZXdUlpaE02V1l2aHducklTNkRVWS9SeU10?=
 =?utf-8?B?clIzVzFvS2lITkxrT2NTL0JGMVl0N3Vwdm1KZ1dvU29GMy83NXdLeXVZdVA5?=
 =?utf-8?B?bU8wVk8zQ05BZW1adGEwblhRM2NTUU51Q2k5akxmY09mazliQkJvN0J0L0FM?=
 =?utf-8?B?UkpueDc5ai9FMEtJcHMrZGhnTVROZGFjbVYxT1czbmNweVh5Mm81V3kvNW5B?=
 =?utf-8?B?NDVkTXdqTXpYeGxWTjV3Tm4yYTB0WCtISkxra3prUnRhVkZFRlJodWtpdC95?=
 =?utf-8?B?TkhtNEdPYVNRUWlyYTFkMU9FVEtIV3pBbVQ3RHNPeDhscWUrcWxITHRCaTg3?=
 =?utf-8?B?djcvQmRVR29rMGIwMFJDVUdMVzc4VE1YQ1B4d09nZWt1akFZeVhqbXRyZFBq?=
 =?utf-8?B?c3huL05IS3hRaDFBb2FBdm45UFBZaGRTd2JXdVlqTDRHakZUb1AxcjgxblBv?=
 =?utf-8?B?Y29mTW5Ka0ZqSllRZ3FNUFphYk1wdHRHdjFKeEtxd1BLa0pidnZVMWZHVjhZ?=
 =?utf-8?B?clpqZUFTKzBEODJrUjFhRGs3Q0cvTit3QnhWSUh0TmsyVlRwM2FiN05idVZq?=
 =?utf-8?B?Mk92RU9zd0xjcS9KVGNrRHY3ZmJ2azFRSTh6RmxqNWlNUW8xcis1WHlWWGR3?=
 =?utf-8?B?TlJYb3lsY1Fwd0FUN1IzZ3hLN1FSb3hLcFpSK2w3TzREVkNIYm52b014YkFX?=
 =?utf-8?B?NHJsdGk5aGtDcVhSc2pyK1I0S3pTZU5KeWIzWis2U1F2TitMWitsQmpxZXk3?=
 =?utf-8?B?LzVSSlB3dEdraTc4TmJLK1ZDWDloZ0ExelhxN09IUURwOVYvQ2NoREszVmJV?=
 =?utf-8?B?NWRxblZzSXFpcGFCeEcrTE9LRUFxbDg5V3FWV3BqY1c1N0FLMldpbHZxUnBm?=
 =?utf-8?Q?xhPregI5KU3ENOCVW4HMAF/ljEPh7chNvR9gmJv8LSiNm?=
X-MS-Exchange-AntiSpam-MessageData-1: ugulXKD0n4F/qQ==
X-Exchange-RoutingPolicyChecked:
	YUzNODp2dwnrZGIXJs39KVKZLwR3zzA3lFX0QtpSY0yoqHT0WPKZ+I7g3h4nn5C0v2Asbv6M9GxjLURmDsWx+TMtanR5NYOaomtBwuoIAlDI4pELwRsnib7EhdclS6mrgNxC5SW5dfsNb7lJBAZKyO2ilszblhUrF7h8AcWHwQjP5QnfMM07JaF7gBKB5seFmIBRhXCVbzyaK2I0AiLJdkvAL9z4YWk+WInD0jpLr+NR7H/FiAuCzibt2GaQNyeEXA/p7aA9No+KhcffNnuqRPvC+7zqMn8E0PGCgalj92py67YRRbCe+AJmadJfO2E+uE7vDdGmFtikFQfZeNVxzQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o/yPhR7ds8u6IEqp54InPL4xil/37Q5wH1DXL0X+Ei1z5O4E7hgcb0RO0m7n9PdL0EzTDlgCj4AyxK8tcouo0RuOvxjiLHLlbqOXPi2SFpVqean0FhF2PQfKsDxriJxChQHVa1hqiHmHbTKDJYXiyZG9aohkY/WkwxMWdmDNjSV0QLnJdcRdN9aVWXJ0GZ/7+t18qLIi/HpcG5Vt4CmBZSO9BJQdLskMpAyNf+iCgjqurjoGKF+W++eCCgyPZ0RXq2AV3K0fRxK16vYU2WssRc9NDv9wAbnZdpaTLcqWfmrNo87/ercf1WZtVudfhQC9P6gdvx8RSG4izbLAa1P5BziDxlGkA9GbZPONXaEYO2i9qLL7Jq+HmXbfWS20lf9gLe+fI4R0b8RXaTVsIdSwTZLs6m2Q9s5/GaJV4kzbBD4+ZR7RrvLeT7Iwg/9kCv0OWN7rmTdIHEH6lb/SQ1rn/0MTAu6NsccBb4/iEL9CrlKboCQ65DCGmlrscpIp/3ptyabvCMJ+n/DyvizMpufdb4rHX2IuZmvpZNnxahdasadG1kkvUaLTzg3rrvlkdYb+Ns0SEn1vqwNDplboqQ48jWRJqv92+lZFj9+nSlVMtxfJ/LXg72VvMtBRW+oKAzVE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 758f7e61-4d50-45d4-fedd-08df33f7c3bc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 06:58:54.5031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oh2CVVit8N7pkqQ5LVENuA5OESkfaZtBYE9B6DQNY3b8V4XnHC5F1kkdnvT0BvtgJu86QhAlaV6YUw6TEg1/MpHlVS4wuN7jre5eJI6fmts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7867

I messed up a rebase for this submission, will send a v5 shortly
