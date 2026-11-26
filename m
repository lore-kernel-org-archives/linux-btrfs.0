Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795687693;
	b=v7bk9nKs5DdFzYnjHbLWA5V5J9VDzu9b8iWyMimJV2i45r+9bxStgkrhql4qWYPnhKgE
	 LkjhRdbc6MTdB4H5EK0FWTjfNxUCMrWs1WY/wYa6Ondm7zDPvHCSnCqxDbsUTNNPTtGAb
	 wBdIUJJWL84bswgUwP545Y/KWoS3pECcnuhIy/oENPAn8g0F4Q1LsLP5LDvGnAXK84LVm
	 ZWvqcwAx5XeIwNMhdbXVxEQMePXuvjRS+QPhe9+nfr1w/bDgsJBl0FxSBBY+BN1Pc4oaX
	 GpO2jIdL32aEJNXqIZBPYschX0aje8U2ouNx3mbZRY6IQSu7FFvIZJqOwu4KRLfNlcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795687693;
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
	bh=dFUsSjhZU5rjXiujL4KWpyX6GgX5XLyylF4tGQYkm1I=;
	b=M803FJLFIyRHlgREgSA3UokHbEX85/VmIHQ90AiqPsBCkYd9w8HSJzx/KtOR7nvbTkKq
	 9HfUxjYrLgnKgvxrh0znoLNH5j1qd83k9wqPIcTOx8PCrKhBk9rxbG6oRP6US3WAo2P/t
	 9qg/IX7iQs8pCSHhyY60AkTfcMuU00/Sm5DFwNLCaS9Qh3UxbhUyImi41+qPLU9bu6IFj
	 4gzMB6XBNG4aUsFTTCPM+Ns8ha8aQT3IKL3glutDMc+iiHtb+MpyuFU6kpslXmzct6xu5
	 VRCe8dWs+w4SNRJwJdlM4+I5gAbjuFJO0h/uX/VxsXrzIbssSpw9/t19V3XyyZUVh/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jS7KxTH8;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=x2C2N4MR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1551606A323
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 10:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1551606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jS7KxTH8;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=x2C2N4MR
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795687692; x=1827223692;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dFUsSjhZU5rjXiujL4KWpyX6GgX5XLyylF4tGQYkm1I=;
  b=jS7KxTH846/Go7zERaugYMOgTD01ZNQ3mkm2yu2VyNbAaxHy+j0J3uT2
   rSWQsMPoBCG2z69IMGs2yybiaC7/8uOSnmFdxsMzQitYkc6k2sCfBsD3f
   y2SavSt1YU0fVsLeytJpvF3s56Qi7l0hQC1kDqo1EzIMxf+ZXSy+ke9qQ
   LdMSTcrW9dVclJESYIfIlkOdGF6J7KjGxEEKBYL6xAqN5kFmBR8iaIGD4
   9aAaCxBUnH0kh5+EsHB8HjewZbYIXU2w0WzgXjZDX3LPC/rNNOENiGlOo
   /+6Sn5SD4684pUDnTEi+Pel9bJWwQaTv5xPounyQQbpLBtkLUv7NPNC/T
   Q==;
X-CSE-ConnectionGUID: pVxYkS3XRIi+BAf4Y+8H9w==
X-CSE-MsgGUID: rBC0DTwQRlyJ0x7bfoBINg==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="160849493"
Received: from mail-northcentralusazon11010016.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 18:08:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vWXhUuPNMTYolZmVev43Smf/HnbiKMNVtMsL9wjGVnY/sLnpSpQZpl+y62HMS0R27NB3n4UwR32a0sgKFLHR4JvoWvcEfmSTpqmK9VIaB0JdBXMMaYPT0RKuzCZ8N6pmK9yelobgCk85t2d4AppvhcvuDbPFq9PYKbmGyiQcab/y0A7n3cBq1OM3UKWXJG/HSpHH81GVwvyM6ylFyJQjiBupxni2Jfv+gCxEe3hnCmui/WXX4WESn/xhwI0etOj2zAYHthuxWg0qOHNYFW016oO6Sjh119ZrLu8CCt2Bwadr2pA2pGIt63Qfa2JbYGW8Tb+U/44fbQ1hxDYnbDsqkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFUsSjhZU5rjXiujL4KWpyX6GgX5XLyylF4tGQYkm1I=;
 b=W64GsTQu0Vs74HxCHKePydS8cATJx67wOOiFsSjq6EbL520bNDOlXU187DSrvazkSBPC5ECU97khBPuDIYAUsRGpaA1M+kkQQu0bFWBIdI/+PywKuveOVanVeYvP3kNIR1tD6y7FLz/Yy27C/VihUpXctjPKwtEMFi+y2psQISDTW+zlKf+Czre/mgjflcEZbiSHzvjAEvk89J+ii/vlIiXb8a+kDDYRFmGhzuayqLIPHghqbJTDxiDlxBP1CQI4biyKiYz8XG99e6eDlIcSoEAEQZ8systyX7KqYwZxoaG/5IAx0jJgT4MNUwnkPO/vooUVhzgImnGVc+e6DcgJSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFUsSjhZU5rjXiujL4KWpyX6GgX5XLyylF4tGQYkm1I=;
 b=x2C2N4MRqBoFkeOcxErerSt5vJ/zCdinX8hQ2SnXOIcLNh2sUZaAepsUd/GzGaeMewA899ZYupGCEOsUNl6nGAMhmF6iSqhtGx2MDTztn9vlYtNwe+IJQJDmg0MXf7uDodGWIBEugp0P1sMj0HDFnNfhX0RDeeipUT5RFCHDJ7Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB7572.namprd04.prod.outlook.com (2603:10b6:303:b2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 10:08:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 10:08:09 +0000
Message-ID: <d2998347-9a07-4f30-965c-93dea53c8828@wdc.com>
Date: Thu, 26 Nov 2026 11:08:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/27] btrfs: zoned: fix possible race for
 reserved_active_zones
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>,
 David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
 <20261125102956.266389-4-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261125102956.266389-4-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fe4a89a-2f02-4f6f-808b-08df4ba52c44
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|10070799003|23010399003|1800799024|19092799006|56012099006|10067099003|11063799006|4143699003|261022113327099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1I0KNC7vlI9tPGsTZYRM2VAdf0DVZO1lQb5vZCsO3/ODLd4gOy4PR5mjsY1TCA2T6WxG7emkOvjtitW8T6PipoJRcFeoqGIoaruFPXZIBxNGQFBr6pzJ+rWN3FotuR6wTU2UT+hsKC+3Awy9M39C4s3NR/hra85mepUjs5aivV3fwVkY6U5Zg3I+ro8DoASu5NKIhqQ4AWlar9nOUJfiW6jpXc4LSlwoUIODLcU1eyjT/MTlalE8Nx7kPtQ+70fzQ5q4ushGtDAzHE6lyaeEbuz1RdJKpNBntvksrn5j5Te8MwwRUmETTUenERRmZvZAfy/XOShVxyLZYwBZxrNTD4SIj1x/QovLj+592IvFVfhSFd/x4zhfbymgEsDYMGhCO5D64MZr0uLEB+uvBs9wfgA2C3enBFq7mUdKC31JFJQ5VJY3ccn8FdFzK9LunI9xVc/0FdECXaHrCA28xmqgYVvT3zpTbHbg8B1vjHyq7BE8onlNdIfbgNkdzbHHrzckzP00UkWJq6wpQ9U2gClJq7z446ZzFCR0762OJQVLTeCQ7KLLmKuybVLKonW/rBagnliO91TCZcrWaF2g+ZrPUSYSoyr3rukV70ARTlSJ7FL54khpTz/wmsTmfVJwJruCbfUwM/DMkE7K8s3gr10rq90OBD+yHpTCVwQcdRhya/c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(23010399003)(1800799024)(19092799006)(56012099006)(10067099003)(11063799006)(4143699003)(261022113327099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WElRYUVucHFhamFkS05FbUgrYUYwSS9SeWhudVN4NjhlWVI3cUlRMUNGTDQ0?=
 =?utf-8?B?RlJQaGFxZy9oWVI1ekZZVTNoVW96YjgvMFQ0SWJlRXFoMmxwVVlRcVBacnlE?=
 =?utf-8?B?RXRLVlBETExhSEtSR1RRS1VaR2RieWJQVTRUeXdOYUtGUmlBeHp4MkZZWTEz?=
 =?utf-8?B?K0JoQ29TbVNKekowcTh5OWtuSm5pYXlQeDh2aHFYamI0Vmtub2JVTnc2b2Z1?=
 =?utf-8?B?dTY1ZTc5QitUYlkyanRzbHp5aS91Y2JqZDZmMUsxd1Fnb004Rkw3b09BTjB5?=
 =?utf-8?B?TU13citneHR1Q0pockZwakppbTB6OXRhQUQydTJha1RSYmZDN2VMUVo2ZHFo?=
 =?utf-8?B?Y3pYVGZBZDEzY1B4OWs0MlpiSDdDRmpuOGROR3hyNnhKVHlxZGFIK0hBQ2sy?=
 =?utf-8?B?RlNpNGdMLy9QR3hoRVpLbHpENXg3YlBFY016Rk93RHdaVVRnaGlvNGFNUmIy?=
 =?utf-8?B?NzVhZmd0Ujl4UEpoLytkbmxGaCtvMk0xcUJaUW1WQXZjTktZeHJlOU9wKzdH?=
 =?utf-8?B?Q0pyZWhKS3RoVWdVSjlHWFZZaDFvNEZGZnpaYkJmZkRzMlV5M29BMWJBZ3FS?=
 =?utf-8?B?WkVQOTVVSXI0OGtpbmtRKy9SVVkzdGxZVTgwVUtpTEcyMFUwTTRRa2tHbW9Z?=
 =?utf-8?B?ZUprSkc1eHRUTnAzRTZsS0wzZllIdHBuV1grYk1iS2dBckpJMDJHMWFrYWkz?=
 =?utf-8?B?RW9qVGtac0ZwWTl2K05SVHdYSklrVVlyNTZWV0hScDRFUmtnUFREY1VVL0s4?=
 =?utf-8?B?RjV4azhISmhzcS9JaDFSTy9tdHc4VW1pVk5GUUpNTFZHc0pSVlZwSlJ0TzM2?=
 =?utf-8?B?am5vN0JGOW9xQ3EyWFhkbCs4RE5TUmthMis0b3A3T2U0OTY2aGNIWUgwRDgr?=
 =?utf-8?B?Z05zVEFXYjhXbGwySkpHVWxuRVlreGdUdHZDc2ZRMjVBNEh2TFp3MzRsZThx?=
 =?utf-8?B?U0NYYzlPTEhOZHZBZnF3eGxJcWxyUTJxSFQwcGZXS3E1ODRXb1hqNmg1dHZN?=
 =?utf-8?B?d2sxL2tGWEZqek43Z3RiN2hjZ1dpbld0UDlKQkhpcitoRFlKMndXT1RmRnpm?=
 =?utf-8?B?WG9PdVlzRFpzMFJRMWs1WFBIeE5XbEphY3NrUk93WExUdkVPY2ljL0FPbm1M?=
 =?utf-8?B?VmRXL0tRTEN0Z1R1bmY2SmF2TU02N05FNk0yUlVkbldwbUpXdWpsaGRRYXY1?=
 =?utf-8?B?QWk0OXY4ZHBtTWppelplcENHZVIrQlVPUk13ajViMWRkWllkU1RNR2pVR2pq?=
 =?utf-8?B?Q2tOdzRLQktJejhwNjl3MkFEb3NPcWRlaUlvdmFVUVhDZlJxUDhTcStUUzJX?=
 =?utf-8?B?UE1nLzZTWW9jNUtTb1NqVGwyTWRWZFJpTmdPaFlJWVg3R3pSNkttdTFVYlQ0?=
 =?utf-8?B?ejBjVm9vTzJkMVFaS1ZXd0YxMGtFL0UwSEd5MUZWNXlLbEhyUWJYUnk4QkY3?=
 =?utf-8?B?TUJBRWxaZUljNStkc0V6RmpHeThlMUZiVUZqNWJIRHN5MmpTM3oxR0M1Sndo?=
 =?utf-8?B?d1Q1cnMwTWc0TXdqZGw5ejBmRS94K2hnVW14ZHhrMEJHbTk3ZDlrdTZtWStY?=
 =?utf-8?B?eVhPb1Njc2xwSHl3UGROVE5FNmxkdzNmZXpJUVlnQnJwZlY1MmZ4SUJwcmtR?=
 =?utf-8?B?U2J3TTZOMHhhc3h4NDdJVlZIMGdrTGVCamhGelJhVE5tY3BEelN2TG1pNTBa?=
 =?utf-8?B?SzlkQ3g1STBoZW9jM0lPcUF5VlJzdmNwODMvdFdZVldZT3pwU3VnOG5mVE5o?=
 =?utf-8?B?UHVrVW9uWlRSRFhCNXlJQ0JMMHM3bDR5aDJsaG51Q3QwTVlXS0J1Q1VyL21q?=
 =?utf-8?B?MXNnK3FoRzUrR2Y0YVh6dlVjKzVJN2dYa3FHYmxPRjVVUEY3cEN3cS9qSHlk?=
 =?utf-8?B?SmozeXk4L3hYTXcxWTFBVUNEblk4M29vZlNOQ0NRSHVUbTJYV01uMGdRSDlE?=
 =?utf-8?B?MnVFeHI1elROZkFwYkJXVmlrTVpaY3hSTFpRWkV4b1FjVXdoeVNRNnhDbEc5?=
 =?utf-8?B?V2hEako4NVEzbkNIaEhnQ2YyTHlHZkhKcitiZFlNNkE4UTlvZ25xaFJlcEJo?=
 =?utf-8?B?bEQ3K25Zcm1xKzVvYVdmd1EwZi9MOUVSY2JnVUhoS1I0Wk1nbnJRMVNtREEv?=
 =?utf-8?B?NXBjcUZtSCtzaWhzcEhRMmp6WFJnVnNXMGo4L0syZlk1aHhWVEllUStJcWox?=
 =?utf-8?B?djhqQVZBdnU5NVltMWhHQS9oa2w3eHZhVit5WjY0MktVR1J0amZ1Q2lyUnpr?=
 =?utf-8?B?ZDVvQzQ4WSthSSt3cmlmSEM3SHJ5N0lMZnZTeVZORnRSbnRaTFBmL2Z4QTNi?=
 =?utf-8?B?KzlzYUl5VzZpT3JkZTVyb09YMlkwUU4rSEZsbkoxdzVad0RDKy8wd2UxRUtM?=
 =?utf-8?Q?WyeIufTeDnUNizv5yzxHFHq9++PPlBHdk0uSsdZpArWF/?=
X-MS-Exchange-AntiSpam-MessageData-1: kRyBue30q9jSi6bechEWaNWw2XT5H5qyQ4s=
X-Exchange-RoutingPolicyChecked:
	g9ZNsqdtBJlnq7pAefqAj30RSEBvm7zDklBCgs/WMzyOeFMmwuOKMqoc33y8hYaurf8zISS4smhKsjUazw7ZcthpZxaSdhOGkYKp/+LmYfQ6OKoQGo+zICyt4XxxZSSQGlCEuC4X17JO9/yhL9TqKjXxmkLr0AovBYMVmh1+tyCakSSDP0LXPAfc1kyZCopqFeHjZmI8b1xJznBB+o+4ke+iJ9UoMw97eA0GlpDJjFwOyeMZuFoewex43j6FeKApgilFfS52JawO5g00XxU/qm8XcLHzu5QPGa7DG8H+9S0Y33dxaSVkTk5qe8qH+E+kgsq4fC++aidclGCnCtKnhA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q5/1veSAzLyrk1mO8RL99Bto+DPB6NruzdqasE97uE6IPB7fBChG4Tbj93BYI8c9lYZ7/7U98mxLBSCMxhjzS+iD2lB2DsZtTpTbnvH3hLY5ca8Uv1BKD2E60LJaS8eSf2HFWsFaWanXDayTFOMAHzbiqgsG507nbVhS455X+A7c9EAo6nAONBKmLwJP3sp/GqzU9TPtHNQZaC3woiMYk69uNF2+IqUyVuqbz64fTQFqxiH7c9ZY13qq35+FwbmEHTnD3yKkCUGwGh40NCoUV08ZDkjGtDmGOT509cITMJXjknstPui7Gf5AR8Ppb0wjzCv7wG+WmdT5P0kDURzeWsCmEyRkAr567amRY9OHHhLuylDGwvWHBROhFvkyWpn8Q8x0EqznGPf0EOpJD283Kyth2aaaFU95p4yeO8fNQFtQmFagBU/tSTgq55NvxAfg2D7DhAWa/TabvAB3zsZVIctBEGp26+b3wGx4fDFDtQnf39QA6k9x9H47wiI5HMQrKcLjk8xBKUcdnynNLf9mI4HwuQ/X0iKWvq2rDuotQ+7y/OEw5k5qfb0ri/9LlJT/JcyS+IHjqr9OhZObiutEGziJbpoccUzGah25WfTdnTv7Gk40HMoRMFP2W5pIKZs1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe4a89a-2f02-4f6f-808b-08df4ba52c44
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 10:08:09.5118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VxbguUrnjH1PuBJ2/E3QC4Kso3MlJI0OQz/jd54X6iUW6NLM5d2le6rme6rQF3uL8zKaUlCnwIde9YIBTo0CD73YRs6Y8e0V8HFu/E9APg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7572

I've moved this patch to for-next. It's standalone and has a Review.
