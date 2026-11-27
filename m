Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795776394;
	b=YxDSwuK19+2c7dwQz6Im+Y5ptOA4Dnd30p4xI3QmxrRFA1ZA4o4gG2R3d+knN0p0mxKr
	 3GcEoMxurqwwQI6tZDe2WY5NDi8/dgCddAU42n7PUO58v4WrrDfwSvXoQyFP8qIQQocu0
	 o8RXPJ7MS6ApbbiRm6Wn7Sz4aqTluHuUgyJ7wZTfRBmTvndi06lZbIJm6eSWl+8zvZVeu
	 jVW4OFe4HFIrFCuEfYEbWuoEWWR7E3jsFZ8F45ck3vv4+OTXmkPqhA+PJ7EOksnL33382
	 6XtfPD41MxjZCP5vedBdTyLru/f/TRAp596wR7fvHUGBzAdK7GjGj/sk/+Wgoto6M+A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795776394;
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
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	b=vwdRYCaZVy51Th7fmJpOsiGV+Rxq31/6xVCLOIK2uc36m2eEFp1NKTNA3qJKunFq0jGL
	 sbEZLrJS0mWCr2OZS4L9Hb5MCb0xjdew6DrlTxRQ6LQuJuZ+pseiwY+Py3KwxS4QChuAd
	 YGD5EwAdMlQrFB+F+wPBzsV99Zjc7+u+pF9WxEHJg//CWFYo34xUFGXNcm35t34suybU4
	 haC86eciZ/sDlV24PjTWlL95t3QiygK8FFKhxI5ZeaFm9LvOMCjA9v4nulFfx6YV98XF7
	 5XXOvR/dpaTOpdxkSRX1A393aAQVAMIk8kgez6UMWvu9ytFBHwZgTQ/R4XcKdx4ro1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QPlIyRKC;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HkQC9oYE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339F9606A31C;
	Fri, 27 Nov 2026 10:46:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 339F9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QPlIyRKC;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HkQC9oYE
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795776394; x=1827312394;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=QPlIyRKCbyOoG7u0BRQQCvO+rtyYti7g6ZP4U00m3hRXX22kkfNC1ujj
   oUxGaC8uId6GMkTkafOpujrHI0IWKPMg/Fzz0NbEmKZ7/IAUiF6aPoWVz
   bX+hjGjyH9wHzXYKPWl+iewO6OMT82h4QmL3pgTX71UeSJ2KYtO1kg+UN
   tueVm9ywTLhQr4c3O/c6dXAA3arlD21mFCpmZm/D1L5VnG26TimaZfzkz
   fUhN3WER6DuaCqhkHzPRFTzqMfVcLVkG9/1MUuBZGqX8vs0VVEhsVih+X
   yR/n0IDSLVxLA2dYbTb1VjDaiMU/iqy6Qma/w4vC09dHw9i8YpZhY/9kr
   A==;
X-CSE-ConnectionGUID: yOlwtTtlTYSxDerch5rDpw==
X-CSE-MsgGUID: WXgHSRPDS+uEGmbmoJ0S6Q==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="160282022"
Received: from mail-westcentralusazon11013056.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 18:46:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OD2rr5YYyvx64wDZ89JPR4dU9IRIP1619wS26v2UDRwzfzPqHZxoj0vd3F1i257ugUe2fHv+t9nlp0rCSFRErs6Jh1U7yylrqDYhQ8KXWLsNcS6tW7z/jkNXuA6/LWWCasutgv5ZtgxVSuvorxKnjE2+K+0gGOIGy/cy6YzCFfqTBaQ3SteTPQyfbDYwbRGqt4lrLjf+reTxDQZ6zGq1gY1iFyQ/lEHbvxnRnIZyS8gRPdtcbIti/3RxGWAwh85di8QJbxsHpElwhWmQPgwV1rx7tQtNoDUXeVZeOBJfbV1yBZbE57gxAJzJNHnnC6xJJcuewd5NwNAidpjIbXdPrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=aV3suy5NA1/mfB/tzY8AJX2QlPudMxo9VyB7bqO7FrevWrl7ftJJd3gtzBitYV7GGRTX+0cYJy+JAqxHZvDLWQSy74FxQlO9Iif0lnjso/Df9CPYWbEd/HI4zcVZ2jYPJ6NrG2Q1JXTqntlJTaGVRGk1aiqWyp0fsa/KQqAY1kFL+mY4D1uDcJiwrgSszS2EZ6XLS5ahFpWT23ziB1DVqhu+JBDEBK3eR+pc1MoRkX9pXKAIFgsRFwsffM5MZF1IwZ6xAXWjIGoWGMjRaPTFZaCXljjjiFFPe6K9p6grs1YtCiKuFy2HVVtxjR8Ol05SG40BAcDYT42iRn+/o1cTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=HkQC9oYE7OexrDzMuqDeIkDuxmYP2NevieIHoWC4u2XT8K9jOuKAkZ+RI9age9Ub2WrdTMX07kFvBiYawMqMPK46X3h5MuoLrhCUfhS/gfTnBUsRdIBcb50oAJm5fvMD+nCe2CjC9E6Cfevxtbh9k/tojxGAyU9QthAim9cqxfM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB8711.namprd04.prod.outlook.com (2603:10b6:510:255::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Fri, 27 Nov
 2026 10:46:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 10:46:31 +0000
Message-ID: <7d66112d-a7ac-42d6-b147-351ff7b72eba@wdc.com>
Date: Fri, 27 Nov 2026 11:46:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: zoned: use zone append for every copy of a
 mirrored write
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
 linux-kernel@vger.kernel.org
References: <20261122034826.2333981-1-mc@raidlab.org>
 <20261122034826.2333981-2-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261122034826.2333981-2-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0218.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::12) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB8711:EE_
X-MS-Office365-Filtering-Correlation-Id: 06680ea2-5b9e-472a-9959-08df4c73b262
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|10070799003|366016|19092799006|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
 ulVZS9XXlCoeLsXRCMTTZHxeqG1RXLGGIG8Do34ZFIzGMbqmvfqRK500IK9+zvsa2MSacb9fN8JJz9gRydIiKonARv5CL6IkoSzmOoYs04uyo5fRxanJwJWFCc/baGPv5juf4GSf0LmFaGnCvOMVuB4P/uYxsh7PyDaIEU6+XePbulsjEXj/jLPJ8cMLMpKguzvG6vcZIOn/D21OqauEyWciB3biA1gc99vAyVOLHIQhqdH4rGkVsDwbk3YmgdyZcur+IsGVfZQAuOwkTTjQaSR0PCJ9QpJ2IMiOnkyGUK5PCFMuaueKeCsECB6cczjSphFG0xbSLhRpY750AejFRVv/r8lJo9Ql4XHvkDoZ6TOcCEDK5SkfntwfkHaa372EivMAsSXa8WSYlB0VNqex2afWF0HRYpGPmMI9z4ixjWxN+84wWu/nv2ylGWWZfgUVwhyW9IFwCqnU1GsnltJLpADtg0A/v0ZfgVLkUQEz7oatu3IufqwD5DKsCwyNcTZh9fiBtoK4ZcVelWVGhvrFKitUVxov1QmjgvVZvBcn/C8IB0CzUF5twhOHi6q8uIql4XIzAOrvZgKkaiqER2i62KGSL0zoae1Fhewv74RERno+Wy9bsKi+OnZ04kO4Y0pl41Vzbo1VLFkJcl9MPBCbjmjjRxReFbEEZdfJctqgYeY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(10070799003)(366016)(19092799006)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?amxNdzlxZTU5RzlpZXM3bEFTYVM3VGNlaEVoRTAzZCs0UHcxV2ZaL1YzUDZm?=
 =?utf-8?B?MWRRTUlLdnJqZVlzalVpVGF5WFpndXdFaTNrNndxYyttSGRNcVhwWlUweG1w?=
 =?utf-8?B?WkNwYWd0ZFRQbXZacCtxNWhxWnJtckdOUTErL21vNkZDYXh6N2xLVUdlZlpz?=
 =?utf-8?B?M0Z3bWdRbU1yRlhvQW9zTEF4YXNZYW5TeDNzZ0JORlZXQmF0U3JTemNrb1B5?=
 =?utf-8?B?ZWVxVWgxRVFaQkF6ZFFIK0xYMjlWajNDNjBSOFRPdkxoZVlkK1puSzRiLzMy?=
 =?utf-8?B?d3lXeEFKNWllUkc5dCtPaEVHK0hYVGxPR1lRYUZhTHIwUHJZbXhSVHRwUGVZ?=
 =?utf-8?B?QnQ0c05NVUVyakoxTFpRMDFIZGRjc2NPVlRmejZ4bGRlczhWOVhUTEJxcVJW?=
 =?utf-8?B?Nm5qNFV4VEN4cXB4NSsyWUlxL1I3TXA3U09oa0JmYkFnRS8yd0JYSExYbDZZ?=
 =?utf-8?B?QkhoREY5MnhVcnk4Ymc1Z3NMN05lcG5IaXpDTEhiVzFXMEphNTRYTC90eHI3?=
 =?utf-8?B?Z3FzOGtsMmd3MGt6RGFNVy9idE9TKzBFVzcvSzh0MFBOV2pNdS80blFnQlhv?=
 =?utf-8?B?MXlPWTBXems3RUxtSlRxQmdWRWhzelExdWd0Q2FGS0IyVlNPa3VtUjJtYzlo?=
 =?utf-8?B?eVNVclEvQlliUmtWTHVmTkFkV1JSenl2eGNhSitsbmdnUHV4Q0VJa0lLN252?=
 =?utf-8?B?cDJ3MGsvcjRTVzlwNDYyQXRiQmI0bGJJK1AxZCt6SlFlRzhGREIyQ0I2UVhz?=
 =?utf-8?B?OVVGZEUzaWxuNGd1dGQ0Ry8zZ2t4UmUrSlB5VjBKVG1PS1RVOHNET0Y3K2xR?=
 =?utf-8?B?d2lsVDR5bklMdGtXZTY2TmR5cE5IOVRaclhFZEVJTXgxQnB2WTZ0eGVpUE82?=
 =?utf-8?B?ckV0RzBnekorWHBBcHlia2tISlNuVjZSWTFoUzlOaHNrWW16UnpPbTBpUEwx?=
 =?utf-8?B?R3N6RnRVb3FUeGNRWlNFQ2JXamtDWHd6bWRIVmhlek8xNnZNUHRKSmlDQWNm?=
 =?utf-8?B?dVdzMXF5UmtHa1FHRmtVZXNQRXZseCsrU1dFL3N0ZlovVDVDaUZhZUl1YlFm?=
 =?utf-8?B?c1c4Q3BCTmhmYStSTE5BOXVoLytjQjFSNVFVMWRSTjNLbkdzb2FFelN4RlpX?=
 =?utf-8?B?cEZEamtBY3BJdnFqZmEwaEFYT2VoMVhxR3lrdXVwbnRScG56ZEpzVWpnQjQx?=
 =?utf-8?B?YVl3Z1MrOWh0cTdCQ1YzWVJPazdHSml1ZDI3cjdzVVZEREgzMW5zaXBZRlp4?=
 =?utf-8?B?NkFSaVJvdXFPYzVjOXd4dGJkdWZraUpxYU5qbEhXdGgxTzFZZFRXQzM4OTFI?=
 =?utf-8?B?VEFEZ0l2SkNreS9ZeTMya0NMTHdNYkV6SVh5VUhZbUFKczFpZmp3MEFGTDdW?=
 =?utf-8?B?NTloWXlVVkdrb0JPRzhvb0RXNmpUUC8wcE1rSENXMkJ5eC83azFIUGZmenk0?=
 =?utf-8?B?ejNrbzAyOUhaMk8xWlVuZDBMS0Z4L3BQckRmVHlNbnlBWHBURlMvVHdJYm9L?=
 =?utf-8?B?YVJoNGRrb2M5VkxuTmFubzhXZWw4NWU2TE8xYlkzd0JudWdMUlpHckhmeTBR?=
 =?utf-8?B?aC9ZNEhYMjg1RC9Xcm4xMzdwMW1TU21Sa0VlbkV6ZlA2b2d1TXdQOGw5OWxS?=
 =?utf-8?B?NGJqWjZ4alNUeFNsbGp0MStSa3RQbEVTaWNLeVY4RVRad1pzMmtKOEwyU3di?=
 =?utf-8?B?cHFhbFhKU0ZQdkZCa1N0WnpvUjVWeEpOSlRucUNabS9McjBmVGVKZEk4TGhq?=
 =?utf-8?B?SzloTW5kV0ZyVjloSkpzdDAwK1JPQmdMekNFeEF2U3dWcEp1VlVvREhrNENj?=
 =?utf-8?B?UllvUnQxb3J3MmZJSEMwL0lvdmhPZnRlTTBYM1pPYzluVC9COXpPUW1wbGJY?=
 =?utf-8?B?VVAvV0ZWUmhObVgwdHRGa0ZaR3dBSVorNU9jUkZib3pmbW5VdURiWXNobXFF?=
 =?utf-8?B?Y1ZUUS8vU3JkQUFMN1QwL1VqMi9acVVFQzhUQVpmVnRWaCs3YjQzaTU5SWFQ?=
 =?utf-8?B?UHdhZU9YZjBNR2dWSHNwTVFuMHd5RldlRkh0b1VkVFZoVlErMndPS0NvajNN?=
 =?utf-8?B?Ny9yYmwrR3hhOGcxUjdWZVN2M1FUODlWRnJ3bXUwcWRUWWt6TVRlKzJVWFdM?=
 =?utf-8?B?VVhoS3UwTW9sakZNWVpYVDNreHdYTUVlU0pJdGc3ZmZtdUlPaVlwenVOU21P?=
 =?utf-8?B?QWUyczVXTzlITzhxWUVuMXRCZlhpb0EzcFdVRFVyQlpzTUY0NmlESnI1YlRp?=
 =?utf-8?B?d3BaWmc1c3BPeVJyOWFyVEJna005MVkvcElDOFJLRHIrZFkrbEJUQkxaS1cr?=
 =?utf-8?B?MzdSY0tlRVlQNlhNQ3hmOUVWUWMvSXR0WlNJWEkwa0kxY3ozRlowZG1nOVBF?=
 =?utf-8?Q?Pl4EQT6RKpcUio0wGpK48GT+T5zGP60i79vRNOFpTlzM2?=
X-MS-Exchange-AntiSpam-MessageData-1: sp1p9cRJ+M/QqW/xAmbes9AIISazAqAqzT0=
X-Exchange-RoutingPolicyChecked:
	CGLSkUWKlJXaw/unpKdXGPOKxPdk2bf5VazlAJcE1rnYJxF+1DxZKCcb7FOiFZWj3AJoy23er4GHDmNkOGdPdBXQQQb0MYIYOe+6VFBF59WmnepkZnKTDQ+QLfhAYAcycV139QHhAQENecI7BH5eMOplgJ3hF5yEWJ6Yq/A5fdi6HMk+w2+h1W4qmKukZYgBahPBfRs4n3GUI9Ug9j6GrrWKx46CQY9nCFLqdfvOskbNDjHVg3koPa1fHXPzj3pj38cHgI3P9Y1jH19388tW9WsJ9meQeF2aO+w/fRDI/RN5O9aQ9uROYxWVt15IxOrKkbjP0MXOtMIBJ+SaSqeVQw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Su7dnXnvvLF5rROEiXhnPVC1L0sOUEAxa6uTvFcgN/78IP3c7GOIvW/qvkOtOEUloMZyokhvt60QjdZFzqLnVXC6Hc03Pl7ENIS0EPff2p2uCSIbimtqlfsLkBLENC/5n6D0odACMEF2iiqxVMhd+RGWHvlooEnk+p2CMHiaOfK43/XUyftdeg0v6HyLQLcSuuckKtVMYACn+2hLK1dUZAlPT1iGs45S/iH1Dn35Mx2FcjYp4SysJ6shcNboxmhsZjzb7pON7ZYqzyAkhNom2BcDrg6Ke/B/fJJnMI1gvtcH2RVk2i3gFK4d9VXXY50AFK765jOEB+y46Mj2RUheqcolcs/MACSD8fBTWr2QDRUUvrdZXpshXiOCQf8kIS1jHgL01Rc5NLn1uPsGF51/WmZKTyV1aXrBqVEH3pF9y+HJQ9BD7N42yih6lEF/EzhZ7rQ4J6Qrbejz+VYhrZJ1j+wfUh7s0icd/gYPQ1Aw3LRwbRlq8O2I/2J9sI2kMs96bYAjULgwGZeX6dYJU2stICnVdBVtcXbbGIDrdL+u5wzLD/Q8tReOBNSajtG1Pr3UhB/hEDSFBrvhHL+vzXM5nLeybfzzNyB8wG7n61Kk/i7Ls43lbtkenYqd0MdhLKAm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06680ea2-5b9e-472a-9959-08df4c73b262
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 10:46:31.0379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrrkkyCuRBsfLCWQHBzs3fVbhNhpLAtMi0NZMf+Q/dbDFqD5BWE6of1kUnGszoOUxqQArflziFReAbOIwlZsh8X9/BoXyGdL3ZQgt8wh3dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8711

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

