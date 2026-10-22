Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792646838;
	b=xaEl7wiRESPHClXSkPDwUlPTRAk3pPAQDGdsFcxXWlEi+ec97QfLuoSlnrYhEx8Kp7PU
	 6dfXQJpmPcqQouPJNGfQrOaakhDS5VIBECeYngcxYF83ovwRA4+AckFCgB8MQhAaxF8TD
	 CPGT/3Tb6/W5s+fTtHSWKOXd4Dke7Z7zuF4XYhdumIJjAdG8L7CLYvi5LRIrdcVHxoXuX
	 1jF016ldMFrNqBLrlgOcq8w87ExiGUVw+sffRteur+s1N7ARST30sKmEAwGodf6NiIwyW
	 5+ZCti2gawsHqpUFmKchILXEeZkCC7KpaI1fCDuiZvfkffEEx4bpVQz2aID1V82A4Qw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792646838;
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
	bh=SLzSqv2kO65DGi/gT6igjxJQuqDKX/esrnCgWu9eK2s=;
	b=HOs9DF7THZFo4ewYWp/lRP+i72jWhnTFQrfm6SKMyWPSdyDGh/0crc+RUe27bNz1Q/Ia
	 4jWJIWc1kj46AINi5ndRSrqegs5myeiAh9KFnF3Luvg+rlJCYi/f+duKRTiI9kt+X+N4f
	 gLh1wPyNTks+a5AknAdklzcAtaHm0DGt93Iasgp3NweRUc8zaeW5bZxS1ILZouZUFyqyf
	 QMSr3LN8HF9rP1JLe7hWRHD321uQWhQTOd4LLyULxaffosZ/KP4klJqn+aHTyJkRBRryT
	 3YkM9cZhWakQrym/8mUO4zrEn1HhCnq12NsHxCAqyZaPdbSz4JjiX38O1aVcjaf5/sw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Vilo4kEJ;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="c/PWhQHN";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB41960A260B
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 05:27:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB41960A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Vilo4kEJ;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=c/PWhQHN
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792646837; x=1824182837;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RoUTnD59FHouQWDv5bEgTgmeTdPTK0RBJOkvPRQ+ZHI=;
  b=Vilo4kEJNO5Rgb30Vvt2AlB8NtROmAD/rpDmUyr0NaNwn5owjNMLjsKn
   rzeGMWrPDdHO1+McrR6yEhKd+1OHgIWbYjcWqhw1pHJltZPBieURVaiL3
   kBPUZIVB9i0h3kSNfq30/dWwcT6778V3ZMOTaKoIDy9jeJcRAy5dDJxL6
   MaK7oVBgxpfq37ZNtvbFEKQMI6DiedAfz0Fk6m7wtCEMPdq6o9y464itF
   qx7HHsOGazuO+G5NrKP80e66vzWmQRUpS4RYWXtPxpBd8IhWMdT6QMKpj
   prnsl60EgGOpj4Bj4PkCPpW+AD00nsi2C49hvYPv4A472mB3wT7pfZj5U
   g==;
X-CSE-ConnectionGUID: GKGCk+8mQ02LHRyJFz7haw==
X-CSE-MsgGUID: mczIbLGcSKuIluoJrXOSCg==
X-IronPort-AV: E=Sophos;i="6.27,171,1786982400"; 
   d="scan'208";a="159665750"
Received: from mail-westus2azon11010025.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2026 13:27:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X0x8dix3HjIbuAhiN3n1+IzXxFSRaNJurAOMQMpVj0VI/sZXgWhafA4F2Q7alxSA+VZ1s0HM/Wk6SXgpAFGX6XupBHYumm+DgHVbuyjEIv57XjH49kXWhUmUNWDc9hn9Dp4sP0yVJGxlh+5gi64HMRRGYAb5jOsEC/RC1JjMgQVEHwEg/MY2nPfqazaLKDXBGgiB8GiwAJgxYhkzDI6i7/WYUmq+5IVG+y+bZPPKmqi8WSrwplX2+dDG58PCbJia2gHvQYZYBQKxY0FXGR7qkH6EZjJz06xR86vjBSDTJd9ePAJhvyYQ0XekKIYwKi+D4FLa156gkL5gbuweC4hpRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLzSqv2kO65DGi/gT6igjxJQuqDKX/esrnCgWu9eK2s=;
 b=Jr8fUfIHhw5/nlkDXwFovOSIIx2tl8uyET/S9eCa3fiefnpJ+iEQYlvcxoTOngVgT7gclF9oV4rsCXGlQRcLVCaq+lpaMUk+J12LQD/KKgy6lTD+UaY7vUCb8cWgm742a+WR7lIaQm9+QsDzzkaty2X1EfAj+5EU0S1/KGQ/iPrArGnrJMlL/bj2QtGInl/0fiN4ZkDiHPUxfQIkEPG6JJSs20PUCAMUHNQL8LqAiqKM1gG3ApjUse/7qL7xW5+iPChg4mKPKGHorO5V8LjixLCJ4RGklqvzWPcbQiLDUfZwVQqEp9qQCtfUdt2K9lZKhnprJjKibwKCZDUE6aqvYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLzSqv2kO65DGi/gT6igjxJQuqDKX/esrnCgWu9eK2s=;
 b=c/PWhQHN0rWNPpFBvQnGSRKZCQueSJ/ypJLrYUU/2dlQnOQ8hcZFeS/72biwuNySBnUAIoVpP88pAvKwTXFc86kcLTJGkAxY0M6HfsR1uabWIarnj8sboQrpwuhh56X1t9XPH/QAGMOhFHt9f7bPc0sxX+87iEQ8OPLL6voH1kg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9437.namprd04.prod.outlook.com (2603:10b6:8:1f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 05:27:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Thu, 22 Oct 2026
 05:27:08 +0000
Message-ID: <d4cb6664-d2e3-4804-b9e8-3ecc0925e0dd@wdc.com>
Date: Thu, 22 Oct 2026 07:26:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: force a transaction commit when fsyncing stripe
 tree extents
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>, Filipe Manana <fdmanana@suse.com>
References: <20261021164452.2439333-1-johannes.thumshirn@wdc.com>
 <CAL3q7H7eF4j+r-cyU_B3jrE0qhFbvx1TduAgg1fp38+2nHEVRw@mail.gmail.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAL3q7H7eF4j+r-cyU_B3jrE0qhFbvx1TduAgg1fp38+2nHEVRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::19) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9437:EE_
X-MS-Office365-Filtering-Correlation-Id: 63e212ce-9526-4ad1-11f1-08df2ffd1d8d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|19092799006|366016|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JZRzK5u5tuE1vLrXf2XkL7Ijg5XXOfBnFOz1ZjFvqc/+eIdgRPWkSpwEEbu3rNsf06J+Xou/Tft3xxcOF0x85Q9Z8/CYzROs3eqBDgR1NatI7KHEi3GdsglwGEvlk1egZ/mA9a9Rg7sgA0Z2VTgM3Fxle7tF7JEChrVjiDTprJIhWLo8yQwngVph/BSOGg9wRCaPnI/Ju3QjfuQ396jX5nGugFq4Rh0u+x5Qir5zvpIlmWOY+YctqCC9WS9sAcomFPNlerKz+MEyr5Xx2LvS3EnMEFGe5ay8yf2U78WpBmdBOK7uI8wNFYvhj06ZXEJQEg8BnY3q5Us6AbCfGyI0yCI1MpDn5YvjJ64w838ChQb7yRt83Ug0iczRvNnLUuZfe/UwcrAxhSv3Q41UsfD86PISbNmClZcWv9pbNKU4nfhTciG7wYxWrExnT2XKHvfkkh/5naA+yaxlGmNS/CJe2yekKXTJocj/sMOZohvxGvziZsghwjbkPrQap/I9patrxMoE3DsaczvM6nGlCE9ugn1q7wE7xYC+83lp8hI8TUd8+TaUNMJmUfduiIxZ5v8/8YqnkChUVgj2AL9sS3J09jjI7R9nsszEC/vRKsue7BeDylublAWExyYycxOYNttfKiMj5d+mYTrTh9fH+WTgYFi8WT/Uy9nBb3p/Z/lnjFI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(19092799006)(366016)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmh4NXlXNXNlQ3hrSTY5QUg2cXFUTDI3N0poMmRKN2dtWDRDR2hkTFJqbDJv?=
 =?utf-8?B?eHJ1YzdpR0pFRnJyZ3dsbCtCQVJVWW55QmNEWGNNQlI5SG14U1RwakZYUmpI?=
 =?utf-8?B?Zkh6L2JGRzViZDc1YU1UcDN0cWo5azJMUXdNUXN3bGxGWVE1Q3MxWU1oRSsv?=
 =?utf-8?B?YjZ3bFVpbVZnMWFhNmx1ZFFsQUpxNEhpcmJTeDJWbGpQNEJGL25SeEdEenpY?=
 =?utf-8?B?YUQ4UHZOeHloNitIb3p2NkxvSE9MNWJFT044Tzk2WGhkU1Y4WkxvTzRyTFNT?=
 =?utf-8?B?R2d5N3ErTTZwQ1JWNUhXUHdnbUNJcEZRTU9lRGpZMjBIbGlsWnNEOGNpZzls?=
 =?utf-8?B?Y1IydVJYOU42bUFnSVdadVE0eFJld1dGdmhlbFk3dGp3OGZ3Zk5VcGRBVFRK?=
 =?utf-8?B?V2NoMk8xMzJ0NHNZdkYzWkVSUGJYK2lCaktIekRFVHBETEUwL3QvMnQ0UGxY?=
 =?utf-8?B?TDU3cFUvcnlKMXNuTDNreTBJM1FKV3pFbnpIczBWY0dUZ2pGbS9tMVBlTysw?=
 =?utf-8?B?VFQ5U3A2V29vZnB5dGtUdU0rdVpIbEEvWFBaSWVHTXZ6elRsQVMxejg4eEpY?=
 =?utf-8?B?L043Sk5rZWcxNU9VQmlPRWxidEpGWkJVMW1XS1JiMHlUUWYvcnpIKzBFYWw3?=
 =?utf-8?B?WHpDSFN0WURScXMxWDBkOGVUZ3Z2Z2tjZFIvYktCKzVNVnB1VWhPU09wb2NY?=
 =?utf-8?B?ZysrWFQ4MERldnZxNHk3UFVJQzlkTGVnZjBDVm9sTzdiWFpSNThYMjYrRGlt?=
 =?utf-8?B?bmQreEZHd0xDTm9qSHhzZExBZVo3dXRTSzVaV1FQb1NNY1l3M1RpQXJoZVJz?=
 =?utf-8?B?N2tJb0ZXdGZQMlVDOVAyRUExWVREek00aEM5MjJ2dHkvQXZ2bXp2SCtUVi9K?=
 =?utf-8?B?aWR4b3I3Ylh5ajhjTzRIbzNrN2t2TEdpdHUyem1FRy9aRS9ZNXc0Q2xWTG5p?=
 =?utf-8?B?MGNvR3FvbkRVcTU2OHRXZ2U5YS9Ja0o2T2lVOVJ4RjZoSThybUZPeXJid3hn?=
 =?utf-8?B?UzBVMm5ROEJWWlNzL3A0bEVlRlBOQzBMbDhSMjF4eERkYnExWXVEb3BJWjcz?=
 =?utf-8?B?UitvRU93ZWhheTZsNnFld0FyVHFUVjZXcW1rWDFwaG1CQytVQjAwZEZCbkJ1?=
 =?utf-8?B?a3VjMC9aV1c1VisvV0Rjazg3M1grSEhyZzAxQVRLS09yWXFCS3hoSzZmSnV1?=
 =?utf-8?B?Z0tjWDkzK1JSQ2FNTWhzUkVwOHFERHA0cjM0aHVlbFZoa1cxMnJjT1ZIUlRK?=
 =?utf-8?B?b0pJc2djSUt5OFZTQzV1L2wvOUVxT0F3T3B2d3JkNGFBU0MxbUNvcWpXNVl1?=
 =?utf-8?B?L3l3VDJRY1d0eG1MazYvUVlzYmNBMmdPdWplbk45YVRzUG5zdnNNSGtXSDho?=
 =?utf-8?B?Tlc4aEo0M1BCQk14VFN3MEJJalBWSlQ1RncxbU9TRFFZby9mdUUvUnByYTVy?=
 =?utf-8?B?c0ljbSs1WkNMMFRhbzM2enBBL0tZdW1Wenc5VFp2SnpjcUFJNXJMNUh2UVQw?=
 =?utf-8?B?N2M2WmJOc1hSODB5RUtuUFpVNGZnbm93c2I5akk0NmlacVUydWs0V3VRRnVT?=
 =?utf-8?B?VEdrOXFQQU1EN0tpU1pzcUVETlY5YncxWXlZUEJneFJMV2J4YzV1MFFpWHhB?=
 =?utf-8?B?eUlMNzVsZlNHaXZuNTFuZ0Nxb3pOWFMxVTlEd2tnbjRkU1ZtK1BxWTZkNit5?=
 =?utf-8?B?YTYxYk9JRW5HWmtwZXQxRmdpdWhNWDRhU2R0V2pCWC94MFEzMXpCMGFETDJ3?=
 =?utf-8?B?VEp0QkprZUQ4SUJkKzlQK3BwdktCSkcwNmZNdWNid0F4cjhhSlkzcnpxZjBM?=
 =?utf-8?B?aFB4M1lpOU15TkxyUWpHSlNERnlJUURuWXhQMVFweHRRaVhYbkIxVmtzSHQw?=
 =?utf-8?B?VjNGZWhGUzI0S0FQRklZV3VLNWZESjNpZlgvMjdHclI2clp1TDVIU2Z2NWF4?=
 =?utf-8?B?VmNwUnZhUlR4NEJrNVNlOEFiOHhGMldpOHdySTQ2ZlFrUjd5WFR5ZnNZMi9P?=
 =?utf-8?B?eFozYjF4WTRVUnNrclFiUTYwYUFjZHRzaEQ4VGFPY0dmc05jVHZwRFFkbk12?=
 =?utf-8?B?LytWZmp4RDdHMkFmZ0FtK1UvMnhTVTU1Wk5LdkI3YWtOSjVjcFF2d2dXZVlv?=
 =?utf-8?B?VDBvOWVTU0lnSENkZjJDbzZmN1NDQUlvbjlZMUR2LzdJTzl5eXdlTDNvUjIy?=
 =?utf-8?B?VUx4Y3h1YmhTUEQyYklwZlMwTkJLWHpld3BuSGw5NCsrcUFrVzdqT1l3ZFEv?=
 =?utf-8?B?WGppTXllZCsrMnFoeEhiVElvc3kzVnRHS0ZHU0xDNVB4Qkp6UDN0V3ZOOStm?=
 =?utf-8?B?enhjNVRQeC9YN05pbEhvc1IwSTJ1SjFYWXF6RGd5enFlcW5tdm8vN0t3VVBK?=
 =?utf-8?Q?7MicUe7ww0Gufc77NLool9pDtxT905767I6H4ZS64Tezk?=
X-MS-Exchange-AntiSpam-MessageData-1: Af0nHDGW3RC1y+MQEVH4Bl66QGPS/wfoxxo=
X-Exchange-RoutingPolicyChecked:
	jLWrKpzwE4+2ihA3kqyS0C2UY0d9XxKjORmTxhmcxgEWpqY4isFTmxbCWCLQJ5by2QsIvJ1WLhXfSjXYBGFZQNf1UdMXEmU+qAnwURIiJn0rr6xqVt6p6lpauD3JHhbdGiwE6+mZKUeNm2EY45/X67DCwmGTLb7nfEYem5NVLrT2A/izU3sUWoobN4ermBGvsx6B2N5x0UaCpP5TBm6mXRY34OQaXpS9RwYS1Y2ExeJi4lUjrBiyz/Gwa+L/l6kKTIxfHgD8SmGAAkoOLWV2iBV+9doie63B1LK00u4u0EnhQdiFZeqOjvYl8787ljUltK1sLRVYvWK/JQJm0kzJew==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z+9hXQ2XgvrltCef+QYPxaf5V6tsik8yW1t4JPpfaqH2jsv6w8pNpbV6/EPdhWFw7jIiCXYNmATnWBCHsIgIkD1nlBd3VscrGjyuhhStdIC2bJOFtdeqgPjToOQAjxpoleGIlj2HnE+CRz+XhJn7aQvBL282b4Ga0BA90Zz5E11eITF32V2yHQTRBC0DUWWFFfUbTthSYzOPZlE/R++uEoCk6OXwB3+DHAbTwo+OUItRrVCKf4/Ur/wUe6M43pXxw4jyxwDHWvsaq5QlW7zjQKt55Poonl5DDOvYDOFl3lX+GIIWomaAj8fVKZJsSoYscXJFlCfglgKe4swNucWXG7aehZBPMJvBotsTtfUnqFDA/pqJu8pLzy45XBoqEO78U8IlRKELz7CnuKVr3TQk4I+mIdpuPk/uJcOGSzuLzYEyXf5N0s3sRzON01535GaVnV75u1N/HEkDFEKCF0GxXtfcD6O89wMKCl03LuiFxUfrpC1348dKLvzoPAkuvglbobdZjvhbLasntpvOEKrqrupaF7FfeDPsz8DTWzQtQs4PY18kOkvvzRQs6CPn5+GnE736iaMJ06KG3VJv/O5GPLDQa/gy+mYKElz8PZbwkCYruVnoNWfWuQBVnnAJ0Nqw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63e212ce-9526-4ad1-11f1-08df2ffd1d8d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 05:27:08.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATDoA7IRRlQu7xKh0mQ62sWOaByvEF28CGmUG3Rpf/4MK8qcZUm7jT71cLvM6qbxCDuQRyjOpxKBb9+ClCQoY5I4kyNp5SEdHRr7t9rzfsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9437

On 21.10.26 19:15, Filipe Manana wrote:
> On Wed, Oct 21, 2026 at 5:46 PM Johannes Thumshirn
> <johannes.thumshirn@wdc.com> wrote:
>> An extent in a block-group that uses the RAID stripe tree has its logical to
>> physical mapping stored in that tree, which only becomes durable when the
>> stripe tree is written out at transaction commit. But the RAID stripe
>> tree is not logged in the log tree.
>>
>> A fast fsync therefore logs a file extent item whose logical range cannot be
>> resolved after a crash.
> And why is only the fast fsync affected?
> 
> I can't see why the full fsync isn't affected.

You're right. This was an oversight. I only had a reproducer for the 
fast fsync and didn't think about the normal path. I'll take care of it 
in a v2.
