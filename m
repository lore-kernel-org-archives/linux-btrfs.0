Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795775532;
	b=eNnbaCvDKFf/91U5ZTe1muNSDArXwyGz5SvRApwkgHv9xjZpBnWMINIxl82Z4MFqim5T
	 6L3e8iuFhA2mQ9+9ih/+gs3Roc01thWVyxCLRMdkO2B1xrSvJnY4cAYpTbujAhUFpmrYh
	 zKWNsZG+FskgBbdUqqA7FhU5SW0rIVOi3RNfJH9C4eh6K6yD8R1zQGURchE7KTczpd7za
	 BQHOO1bIlZ7s4NLlbgWZ59jSoiiN99pF0AMLI7FEt7ZKCL3b2koCMtIuHinkdN4ad4How
	 H/oa6PWbFNczdPaF0+QFJGLyPUjT3/+dP/zWnAX9BcYl6p9MpGiGguwcTUnE3IItP2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795775532;
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
	bh=8DkJLJj9F1sbnqyD3ebsj3SFujHLf/PsouGpT1UD1L8=;
	b=C+yDqa44YAM3kCvqmFSBnwwcdC1iGaglGuTNYL3Gls7WdGU4XD03dwem9Bi4LMIP/2pJ
	 Bc/5SzclTfkWSDv1yk6ZDQwp61CJBE1xWLCGNi+Eu+cz8+jSCZsbh0YNKfnQL2SdA5qi9
	 mIduNC16jnVVxAAnN5WJj0SVbhFelSYWTlqBIqT0F7zJACavfrPak8gPV92Ot4Yy2mSpo
	 5IXRwkYVGR0QEROoYBxfiaad38mUzdjVC1mgZqOwC4J+u5JPCaFS87WIjRyvztDZi5hTG
	 XGviwknZZg3LZEoi3hnZHAtnHtcADCxmTFFtZBB7y+sNn+MGfdojBftRU/8B0TNjhyg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZzYBMDz8;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=SvNfOVHJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C77C606A326;
	Fri, 27 Nov 2026 10:32:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C77C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZzYBMDz8;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=SvNfOVHJ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795775532; x=1827311532;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V3pDFEVA0Wnm7Yj+54cheCdHlXVCes3m7jtSARvDjMM=;
  b=ZzYBMDz8waw4oFhaJyqfU8PCw52lCp4nVGsPCcLL6fk6FAZLWdLqpU1x
   IxJ+7baFLOdauJpld8jvbCJNyVChwVAc4QWAWXMB6Kp31jDAtRRZxigW+
   2ShfL4jcp1MMfvyc0FwYFH/YdoH6PIcz/36uR1jxI8AuEkqZzaoY4LonR
   6kUIsc1COF+7dbdP+aAW+pz6OTY5Wr/aCiwXXKhueh5jvDXxfUK2KEFQb
   lOgU8Ri+n9ndnu+RCqHO/1LxYppW/NaF9atfR/xruLKIxKmTtNJ/tGjdi
   ABB7hRnSyaHQKNDTo1SycUu0ddMAw9ZrHA1vbRbFv5VDpyjHCdTrZOAjK
   Q==;
X-CSE-ConnectionGUID: fKPQSICYRZ6+P5UZ8r4pwQ==
X-CSE-MsgGUID: 7BwVG4ImSj2AKMLYFjKuXg==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="160928165"
Received: from mail-northcentralusazon11013067.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 18:32:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Moslvc4owM608nca0Rjyv0UXz8w/ih9gmnAX8B4grhHtYoz1qeXOeT7o17nMPpBj1GW59aCJfwPn3UkcaFQkr8kYIW7DqTPfIaRMVhc05GXqXfsQN4IQCEZHk27NCbSVjssniWYpHMFpvhaXjHVrodO51vrqEXWXbAYxG4yD4aGeP8u0EOP4FSseHhJr3srPOY5xJcyCDkul34V1T6WjpQdN3IyuDgy1bOc3pL59PaBGghYOSb2swvNbAFP42GXhNjSe/hdF7gzYwB3t5Ll1hXeHiOccRaS33mihUxnIyQrRoS86tvtANjL9OrQwMxfCKoiNcq46B3o+vsUDGR5LDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DkJLJj9F1sbnqyD3ebsj3SFujHLf/PsouGpT1UD1L8=;
 b=moA7oem9U3DU5n589cgGizRLmXnyTMn8CIIY8VTHSOP6AB7fSH/BSXBLZZyyXcRnnL51Wzp6M0KDKX5akWRAL1mG9YTNe5sWtqYnQYhqMoI54aETja035z+S6D+mX7pl5x4STI88LEOSFuPXlYu5Y3c82bRovLnJcR/W+pAfxjcMP4P4JLzUKwyWMiAxaHXsMZj7XXP0vxU8yYXUCmFgLX5ZGPojjQKG5e0ZevEB/vjf49vlYZ+rZd/HIWYrDnDCtrRTy2bk1Lj/RQJwseNNvhTkgVGLkI93OI/qT2NC/iN5FV6El7uYAEaPs1buI6FjGHm2H5/OXjBFennSUmIuyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DkJLJj9F1sbnqyD3ebsj3SFujHLf/PsouGpT1UD1L8=;
 b=SvNfOVHJ4b3UIcLn8dyv1/j8hGSUBtrHuyjJRpWPkd1oR9oqmfxdw9wWH54NF3Gi21OkWzjCJyxObnPMv02Iyw0wopLebBXurBR2RKPUKWiZG6HlTmo6MmNYCfv6oRFqPlpyVkTEImsF/ydcu6uVfx+IqlX/xmdxCQlnjnt8R+Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ2PR04MB8777.namprd04.prod.outlook.com (2603:10b6:a03:546::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Fri, 27 Nov
 2026 10:31:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 10:31:56 +0000
Message-ID: <955e6403-c039-469a-88a8-4231cff6c8d7@wdc.com>
Date: Fri, 27 Nov 2026 11:31:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: fix deadlock between freeze and
 RECLAIM_ZONES
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Filipe Manana <fdmanana@suse.com>, linux-kernel@vger.kernel.org
References: <20261123012459.436826-1-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261123012459.436826-1-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ2PR04MB8777:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ef0ea66-ff3e-41e6-d85b-08df4c71a8f5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|19092799006|1800799024|376014|366016|18002099003|22082099003|56012099006|11063799006|261026140227099003|261022105027099003|261028144727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	6sG4BrqOkQfls6Zs8LMy9mji0u7hufnVkNs8lQeWsMutiVLAC05jQCOe/+orqFwftfKDjbpQCZWEgJNh7F6zXWp1T69qRlCu7YBLlAMUPF064d4NFVRp0hDzcLJVdfphIerve+pkus5Rauy2YpsNGWHRNKKzmWzmoCb/QRdhOHtfLA7u4F32jQdUFe8Osiycapg4tU3Wj0KGmsu57OtEd4G7TI/xJx+eIUIcL+V+fJ2RKg5uZDHUvo4dBSyHR3R3QtAjc3Pxup3y26GBM+LZ+EmUZt/zBUkEAeNELU03vRqSaC1WM2DvEAHv2Esu9QIUQ2VCWkKpQQ8jnU6/93PbFD2q/I9YqA8jBajEAw08WUt5O2GhydbJIzhvOGgNMLwk2KuQoFSVBxkcIsdDUJGbre0Tu8zjtZ/mgCVrneihGdza97NzjRngbTQLxRw8i0kcus3sRMGOLxfd/EuCHzmWz/szDeMJC9PJnzXLnm0+lB34KXi86QqCwkybk+V1qOW5Kd6yDJ/FF+xIQdSI2QmT/ABgqBHYAt00XUKFtotQYpF4ztAn9+HPLO2L8j9N/xm27AyfIxnIFUFOIiK9hViq8CbJ3+ax9M+8ZY/iAWpKZnlOxeArw5u9is7nDvaAkXEeQylBcioqMMqvlA96n6xVQYhVz7suXJHBv/ClFJq1eAk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(19092799006)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(261026140227099003)(261022105027099003)(261028144727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEpwcEtiS1BvQUowUnExd2djbTZ1S3BrT2tnZmViRTY1K1p1OFlOeUM4dGc0?=
 =?utf-8?B?WTBnSFpMVDhTRzIrclphNUpZMEtSSE5tN3VjaWRkYmJVOVdRbVVZb1RRMmt4?=
 =?utf-8?B?RFk3amlHdW1uTnRUS2NvaENlVnN0U2taUUVKTXk3VGMzcTRZOW14S09zS1RU?=
 =?utf-8?B?akpZSUptQVJwVzJ2cXBHMzlZWmN4NHNCd3hNaFhLTHozdXRvdTNFZGdHU1lC?=
 =?utf-8?B?anNjejVBR3BmNjZhL0tDN1V1d2c0dUVGUTc1RlVFY0JaSE9XcmZQWkhPOHVF?=
 =?utf-8?B?QUFLR2Q3bkNDU1Bxa0tYNUVySFcxZ1RaOVdFZzhaNnA4KzIySFhqcWVoZ1Ry?=
 =?utf-8?B?YmxxRVI4bVc3a2UveVV1Y0lIN09lSzR1bVFZN2QzZUNpRGRrazRLc3FoaSt3?=
 =?utf-8?B?c2NTUXo0ZFV4bzdaaUsydXdqNStwZ2FjeFBnbDZtek9DUkY5R3FLRHdGdjAr?=
 =?utf-8?B?WmFPWHNJS1JROCtFcjRPaFVhVWhHblFzTkdZMDhsaENvZjhzUlhRR3M0MWRo?=
 =?utf-8?B?M0c5bHVINUFvamZPeUoyTDYyOVAvNmtORHhCVVgxU2p5NXd1czgyUTRYL2hB?=
 =?utf-8?B?Uk1WUXU0SlVoUHNKVzNKYTV6Nk9YbXVLNjdXSHVVS2V4YjgwbzNvYlNqdjhS?=
 =?utf-8?B?NUVyODE0bnBQNWRNaEI0Vjd1ZUIxTDBYZWdIaHFIdFE3dnFFcmFQV0dkZVgx?=
 =?utf-8?B?RGVUbkpPYmZsY2xoZmJmRURFeHZXQWY1L045cmdBRnR3WERmc0lkTkZKNitD?=
 =?utf-8?B?ei9McWVkOGFIQXBxWlRGWmhBRkwxaVgyOUFJc3BIcUNZb1JxSzViKys4YlZ5?=
 =?utf-8?B?WVBhNHRxOFQzYWlTNjZrdnFEYjB1SGN3b0UwZDhXNmlHWlluS0JnZUU4Vzdr?=
 =?utf-8?B?bWVlZjdNY0c1eGlyRGxDU3F4Z2NZOElFWDcxOE9abG1HdnpWUk5OK21VRnFD?=
 =?utf-8?B?S0YxUjlpRHltRFljdDY1eVl4YXg2ZVAzMHVSMFU5blgvVi9QSzVsS2poWXR4?=
 =?utf-8?B?UERDbFJhdHozWVNnaXQraW1MWVlOM3F6cTBVZjZGTWlUYmJySTBhMnNSRXBM?=
 =?utf-8?B?NHJocXlzRUd3QmRrTE5iMzUweWhBcUc4dHpvSlNSV0pYNXNsdXh1QTVmb241?=
 =?utf-8?B?SnlmVUtISEhRdG9OZUpBVUN2cHNMeE9oYkdPNkJNdGhNVTQzdkprb3Z5NHRF?=
 =?utf-8?B?VXVXNWV2bjQrV0RVdEhoVnpxMi92ekFCczg5T3NnVFZPcWU1QXVQbmk4ZXV1?=
 =?utf-8?B?d1JsdFphZTBtd2JyU0RRN2kwdVFOTlRHMVhGNVcxTGZGK1JRSCs2Q2h3NVda?=
 =?utf-8?B?TnJBSUJOczd5Z3k3MWVsanU5bnEwUjJYZWQ5aHdhbTVPOEdBTkIwa2tHNFVD?=
 =?utf-8?B?QndLYStsTjRPVkdka28vM3BxZWZCUUtxOUo5Q0t5L0JoY1lmb0NHNEs4V2x5?=
 =?utf-8?B?a2ZFeExURVU5dm52WGVobWlic2JRamNSNnFCTDNTcjdOSlBHR2tWS1pvRzM5?=
 =?utf-8?B?YlAwQ1g4bDJBWjJFL1RRR0FjYTB4NEw4S0x6cUt4ZTFFdUlNMncxM04xbWpW?=
 =?utf-8?B?VXQvZ3BxYWtaVTYvMEloV254RDJzV0YyK1NLeGJqVWRsOXFQSWNlVTRVN3I3?=
 =?utf-8?B?Uy9JN3NJSmNray81eWN4ak1aYnVUZTMvZVJyc1RQdWwvRGF4eVdVY3FrRm41?=
 =?utf-8?B?ZEd3L0NnclAvUHJiWnZKcEQyY091ckExWWZmUlA2OGlRMnVnUTNuODdsdnlq?=
 =?utf-8?B?MjNrMWd5TDdaeTJ1TUlEamxPMGthemZ4SFIvOGFaNm82TS9wTmF4MGpYRCtm?=
 =?utf-8?B?Y0JEUlBmUWN0NDJIQkVnd3YwRjNWOUd0Y0sySk5kR0ROamNhMi8wYWVCQXZx?=
 =?utf-8?B?Ry83dGhDTVk4aVlkRHhDelhJR2lnT212a1ZicnowWUo0c0R4dFI0em5nODVZ?=
 =?utf-8?B?Y1YzR1Erb3lub3RlQ1JleEVOdE1FWW1hdGtDYnpNSUIreGpTSXc3clVaeFR1?=
 =?utf-8?B?Y0htbjB2VFJZblJWOWlOOXFmTHk4TTZ2VnZvTFRRQ2Z6bjZIdVBWZUNBYjFZ?=
 =?utf-8?B?VDhIaUVxMjdWQnNFcW1vcGNDM0QwTkFlanpvVVZ3R0VqNWsyUm81ZHBMRjg0?=
 =?utf-8?B?WVVBbm9GeDZIdU0yc1hJc0h6NzRyN0ZMalBhTm5UazJjUm9WK0U0cjFZWVNB?=
 =?utf-8?B?UGFUc2tvcmZWUEtDdlJaQ25UOUdOejU3Yy92WVVKdFgrZm9DUXI2MkljVEp2?=
 =?utf-8?B?WmNIQyszc0dHQlpEUzI1NHVGdXFPNVNBaFRrODBPZ3JjMnBucytjM0JCb293?=
 =?utf-8?B?TVhjdnVKTHV4NURYSjErc3BFZmQ2djVVUWlWUDJkdlRYWW5OWVRYS2pnRWxx?=
 =?utf-8?Q?eDPYUcAfmiLMg8jC58tMTEkRVgVIKj97eGxrz1iPKquyt?=
X-MS-Exchange-AntiSpam-MessageData-1: rSB9/1c2bbItOSX110HqxC1Ij10S+y+yGGA=
X-Exchange-RoutingPolicyChecked:
	ox14+/43Qoxdn8cjjBKb9yeQSFEwpfkVYU82ONuHL1KM2fgofMT8zB6yiziXrRe1WZ//JjQu1mhNvBezIpl58sPVS895oEXQjzljFwLigtxQbWzNdtlGJ7W2Kd3Wk00fGmxVFrhfZ5fpHbv5s1YvLiLeBRb++ErN6sCiBa2SLroUY48RVZJ93uSdsb+rqXguVIwHJAXPqCLUuKCVwsjHimYWMLGM89/DI7+tfZSADKuH8jS60ZirPCEWN13Mjl6uj1odiOOaVdQ55kqQDmVp39JvTL2ARqcQ1obVILhIR+tGv0yFfHyVy+ggMNEIrh8tRMh4gj4ezCFmYKhTJ/S8NQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FtXX24hW98KaTdGQO+615lPZqZiEmugpWsxK55oY298qz82lGGJ5QRaLWuljtNOoaMr/iFknU5bs6MfWzHN2jfH9ju6J5Yt4DnsQFzTrSpT3XxbmPcR+dRkeOW1b3hmEXU38oyZax3WVNSP/eGVvdqvdJ2EuathhPbPi6cTEKoLcPNHtHXn82ts7ajqwgEfq642yKhGtvB3IfHqU18E3xa7DXjXoimFB2SzbUVKnGyQvzlBP45DtQsyeOeEmZUA8SmoU7LFvcaY+gZ6bi8Uetxb/ZTYurOx8+PS+2JEHlCRdu7V4SHWYGNngqvLS+p9Xsnk78otV/R4dMlrKl+libBMdRrOzfSNowz3zueCfMKWGutAEjFk7fNA+aWSy154VnfZBC83tQzzRv5jp79YzPE9wQO554jkZe6N4098eIPgJ6lBgOm14Y2LIsaNECJiFSTewRPO6PtwsOap9CBf3/JxSCbR3tEMEUBMGnwNJYo6i5Zz5iysSz07ZnihoBYsJayrjKwmnhmaHWsXxupEVwjufn653yKdQ095e5ZbTnuBsSl8s2lyq4Nflaz2ntev1DF2bwPaSnMAjOl0WvTDm+4J+X+P07jV6QH9e6BqZw9dHRD9qx842CQ5VG50zbsoS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef0ea66-ff3e-41e6-d85b-08df4c71a8f5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 10:31:56.0402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qa9S795rsFTG4A1aJum7z7Cwsas8dfIJcvtaGPfXtUbPuYMonH8hnyLLljYVGsytSh1EBrs+RwSXTA77fjlkbGafYORcsOd1KVMek+UuaeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8777

Thought I already replied to it sorry.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


We have the same patch, but yours is self contained, mine is buried in a 
gigantic patchset.


