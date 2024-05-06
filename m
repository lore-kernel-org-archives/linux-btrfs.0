Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8312A14386D;
	Mon,  6 May 2024 11:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714996167; cv=fail; b=nd9v2P5qZUSXXX6AlE1MFdB+tflG5GM4sl4HioqUwcYCXfxSU59QYQtJJkEZXIjeiZOH85AI88BJUD/SSmm/IWBX1WFYwcz3XwXJ7b2//HbU9djGL95G+5cJkR2fJX/2eubQPJn2yOV0RmZyX/qvcuP2TwbnsZ4ID/hpJqroCfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714996167; c=relaxed/simple;
	bh=l1WowlP3vU8nZj3wvk1BQMHwLeowB8wFT3wi64Giyok=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eQy0EZ0kfnVwZPAoM2AzMbWKbexMz/FDjFtTewtkJdmSy40zz865XNQj1m7ThB9c1ahdUpFI6IXYm1DupiCRELW0wnSaXc3i14Wgu9vwjvJH69Ag4g97nFX0/Lz7/ma7dgh1XzYUc6OgpLO/nScMfYQvUUvG/zrCXv3TOi2u5lU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DKqJYzNW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JAi07tt8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DKqJYzNW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JAi07tt8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446AnBjP031903;
	Mon, 6 May 2024 11:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=AvkraYQVpjCsA99NSj0qxcVzLGlxyDZUpiTCS0U/XJs=;
 b=DKqJYzNW8+JnoRFXCvsU/Y4r1IgQBWho0+/Quap32mjmcuoUY3ItU7u1Rkfm/D3cndtC
 +bf9h+93duu1sRI8yQAhI4C+zbeaV4srGc/0k0544PO4fam7pKMSV5Kgdq+xoy6Rfl8i
 IU+Lgu2FC3UBcguh23xhwJessqvGZO65lhYTDDNNd0q5i/sHLEVbqRxsDKwZH1iX6I09
 7h3WD7g1wWDD6VBxn1CHpZbGjcToYrKolCm3QC/glbFsdtBqeBooB3I/5kEaIe83Gb8E
 9vLg7lHroHQO2OcX1LWTJcWXME7BJihfJqQLUjkT5bnXsXh+69fnex4h5ryfE7rme0P9 Nw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbt52dq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 11:49:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446AoGr1040881;
	Mon, 6 May 2024 11:49:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf5rem7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 11:49:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScD6kSDWSdfRJOmlDg2zLg3PDtv/635IsgpnO02wX4unfqrVFVsrbBKDgdXDywLlDs/rfqOst4idmef/KkubBsQFUQWHOGvvE3isuy5uZd4BaWf1X/MD2QHUy9fdgdBJmzG3PyEDBpBRlc0FGnGPPpLgURHGf7OtE2C9B+pTnrtqFfqNSnRyk9g//B69SOR81O7zRBhB7gxgrCPGXEDe2A/NsmmD7otK3WBHkydY45gqOn9EdUL0Rer4KQNL8XZPOVnu5lFMlJ7guurRyjdIuKVWIL7vuRsR2Ei/KLnvcojboZ46pOkS6TpOkvcT3Sdk1ST6DEL7AXVjT2jvRzU4ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvkraYQVpjCsA99NSj0qxcVzLGlxyDZUpiTCS0U/XJs=;
 b=IZppwML2Om1vfv++jjKSTgxuK12UR4GHt3OKW6M+2j8gQMeoCvAkOGP/2blZZxkJjn9PYES2qvsNxqHdY9zVF6nxiv/XPvup8vnuOKOROkuuY7/0XfyxgkgigpZAbAYi6zOUrDBjWMP0/d1fg3qME0Z/kMiFKqathKydKZDl3RYUXaMnRPQ8DFMVPCrrLIC7QxTOnFKih3rl0IgWbBFatFO2rTF52PX/mxz43G2ezHeSnDspy+CqQKtbp7VZEDyUoGcH0OPtWaMYCzKzS+KiSyiA6k/rwhzGoxBJBkw2/Wd0fKB/w3VknX+it/td5XNiDbWUKwbAmJ83K8YPG1YQ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvkraYQVpjCsA99NSj0qxcVzLGlxyDZUpiTCS0U/XJs=;
 b=JAi07tt8Uyj8MMT1GfrcmOyerZ0NBwa2NoHrezI+sTSXkEn5aXrE3kMpP/67DfZAFaqCdp73nbaW1K+1wcAy+iHG3DAYxbPNS2PgveP311cCK8annRC3gscmbEagdEFxu7tIeRKmpIvYAh0IN3nn3UNFszCe6TR6tIN8WkwLG6M=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by SJ0PR10MB5786.namprd10.prod.outlook.com (2603:10b6:a03:3d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 11:49:11 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::fea:df00:2d94:cb65]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::fea:df00:2d94:cb65%5]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 11:49:11 +0000
Message-ID: <c2300be9-648b-43fd-be07-6144de35b72f@oracle.com>
Date: Mon, 6 May 2024 19:49:03 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] fstests: btrfs changes staged-20240418
To: Zorro Lang <zlang@redhat.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20240423220656.4994-1-anand.jain@oracle.com>
 <20240424154923.fo526va22bplhaug@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Language: en-GB
From: Anand Jain <anand.jain@oracle.com>
Autocrypt: addr=anand.jain@oracle.com; keydata=
 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
 y4F0QrzFk5Hg4pvnpDur6Cbp
In-Reply-To: <20240424154923.fo526va22bplhaug@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:4:188::23) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|SJ0PR10MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: c9ae2910-8cf8-4ad9-0cf8-08dc6dc28ba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WGFQKzJ4UU5uR09NYWl2REFhV1p3OTQvVFVNYW1QVzNpeGZLS1VTRllpR2dF?=
 =?utf-8?B?UnZVUVRlRExLVWNzek1abnpSS09wa3ZDb1lNSTU5SFNIT2lIU0xDYzJLNW1X?=
 =?utf-8?B?OVNlY2xLSjFweHRiYkFROW53RWE0UE9keUNKNFY0SE5RNy9uMGp1REF4UWVE?=
 =?utf-8?B?RXJMZlZkYmEvTy9jeStkVktlS0dyNTVmaXk2WVkxZHErVVlaYzNmZmhaYTRY?=
 =?utf-8?B?S3FENGY5Vm1MWkkyK2dVU1V6MkpJZEM2QUF2OWtwRVBNQjl2d2ZpOTVpQkwy?=
 =?utf-8?B?QVRIZE9vd0k4bDhmNmdJdGVnbkd5SzFIY3lVVmlGQkErOFRhNWl2enNoSG9y?=
 =?utf-8?B?S1Q0eHI2U3M2MmZ5bDBOS0tobnZLaG8ramlnaUtSQXUzczdIU1B1d21NdkFv?=
 =?utf-8?B?QW5rblY5aVE2Njl5WVR4Skk1eGFkRlpmdlZMaUZPTk5zVEorWVE3dTRnSkRZ?=
 =?utf-8?B?RmQ2bEFBMG9NSUE4RkQ0aDl3RzZZTXhxR3NGc0h2SWZtQWVTVHJEYWVTbmZZ?=
 =?utf-8?B?MFppbTFMWlBIdjdkU2t3Rm5QZXppcG1IdmlDSlNwUlBuajBqdEt5d05SV2pw?=
 =?utf-8?B?aHVDa1EzRGRjZDVNWWUzSXlIUjRCQW8ydXNkSUlmRDJIcFc5Ryt4NVZtMzRt?=
 =?utf-8?B?b3FxazdIS3l1elVOUnZ1TGdNVlp6Y25OdWI0bHlta01Gc0FvVk54ZEhFZklD?=
 =?utf-8?B?THBBUCtPWE1oRndNRTlCdVF3Vkl4cDg2bUN2ODgvMXA4M2JicUc5YkFURkVo?=
 =?utf-8?B?SlJPU0lCZ3hKZjBrLzhtR254TURvSmdNV0FWVWxOS0svNjkxd2xMdjgyVUNL?=
 =?utf-8?B?RUhEYm9ORy8vMkRTdHIxSTVaaTFKd3E1d2F6UWI5RWMxRUh4dldhY0ZiMDd1?=
 =?utf-8?B?TjlSb1g3alFRcnJOSzdQTHJ1K1lYMUxWSFlrdVFlakFxTlJLUmVKMjhEaGZn?=
 =?utf-8?B?QjR3eHdpK3ZiTXBzeFBtL0pqdDAzekNZSmxETHlOdENoaGRYdE9BdVhpV09U?=
 =?utf-8?B?L1A1YTlLaDRPZnk1eVh2WnlMcC9lL0xWbWc3V21PYlB1dEIrOWV2cHgwQjFl?=
 =?utf-8?B?WmhBdUU1RHVwRlVyRTFHNnZheGJmc1J3TmFvVjkvbmtEaWUzeGdxeUl4LzBo?=
 =?utf-8?B?U2dhM09RTWZSa3ZmdmFYRzRCOGN3TXJZTWlTUEwyL2xRY1ViM1JGa09abm9X?=
 =?utf-8?B?TDRrNWNzVnBzc21OTFJkTnEwRVBZS1czSWVlZjZlYXpWeVZvZlhGYkFYWXFt?=
 =?utf-8?B?cTYxZWFJY0taSEJkVGI4Umc5RVVlYmxGZFVFRWtCTXJxS0U0VDNYNitJTDBq?=
 =?utf-8?B?aE9ETkMxUUY0U3FQMXI5YXNkK29XUlV6TFdURk52bGVGYXBaZXJSdjZIVU1L?=
 =?utf-8?B?Mkwzemc1L0xHR1ljU3JoWWxEY1JYdDlPNXBRNUk5VXJNQzMrQlJqb09pWXZL?=
 =?utf-8?B?MXBUaUxWdVlyZXlySE9mQnZNaUlWK1ZMbkdrem5tSmZLUFRzY2hmWmxESGlG?=
 =?utf-8?B?SlorZ0RSNUE4cFk0OFh4NDZMN0VjYldDUkI4OUVFMVNoVFFjbEVIdzlTS0JX?=
 =?utf-8?B?UUtITWFXT2syTmEyWE8ra2llT1VYem9mRS80K29mc216WW1VckxLZmd4bWJa?=
 =?utf-8?B?ZTlwdEVtcGpqSjVqb05XZU84YTBqSUhSeHdPRlRzUFpzS0pLUXNnMEhwdHlF?=
 =?utf-8?B?Skp4RjhmK0dvMGwzSEI4M1ljN2V5Z3FVOG10RzF3R0IzQVFhUjk1b3JBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RFV2aUpGZ2U0K05SR3NnYUNabk5CcVBvLzVtWmNzVlY0UCtWRGdoQVpUTitt?=
 =?utf-8?B?SFhKM2cvaXV5cXUvajlDS3NUVXBGQ3BjTTdYajc5dks4YlY1N3NHZVVuUFY4?=
 =?utf-8?B?a1ZNYndyYnZVZHBqRkEwQUVwRVVFdit0bTExSlVIOXdQVXZBcEk3WWk2UXdG?=
 =?utf-8?B?V3Q3b280Q2Fha1dGQnR1NG5ISGxUaGFVazRLMmNiY3kyOFRPT1VSTGxGUzVW?=
 =?utf-8?B?aVpxQmF3U2ZxemZoNVk1NmFJTG9wZkc4bXNXUW1aWnAzTmVucFFFencwQ0V4?=
 =?utf-8?B?UUNVVGZHTGZOYnBYcFZKaVNZMkM4K1RwbFp4cHpYZXcyS0VlMnQ1OTNudTB0?=
 =?utf-8?B?aWxEUVdrZTd4REVvZjFwaU9ia3hUVG9rVkY1dndBNWJ6YTVIOHgvNE5RbkY0?=
 =?utf-8?B?ZDN0YklOa0FlWGJsaTVzdVI4VHJXL29RcG5YWmZBZnFjNXl5SjBtaERsbE51?=
 =?utf-8?B?eHVLMlRwOHFVU2dwMVZ3YUs1R1hUbWppNTdjUXNpelcvd2h1ckVJVFUxYytV?=
 =?utf-8?B?ZCtyRG1NVCs5OWZlSHI4N00ya1dQeU05blh3NU5tTDhoODZqRHhDUXJzWCtI?=
 =?utf-8?B?d3pxdkRRVWVBSTdYU2l5UEI2R09zVG1PclN0cncwelE4MEIycjBQRGloa3dG?=
 =?utf-8?B?Q045TnY1RS85TVFsUWV2VVJrUWNHb01YQS9MamtJeVhvdVl5TG5UTWNMZFFM?=
 =?utf-8?B?eHJ2SElIaVpJamNDL3ZVMURiWTNxdmNscis0WUpYN0xZdFQyNnNMc0FOS3VH?=
 =?utf-8?B?WXJ6MjNBazZMVTRkclFRUk9IQnJqajhiOHRuMVVXNW81M2RMUXI1YzJaQ29p?=
 =?utf-8?B?VythZ0NVK004bFNSMUptT2hjUGxnVmtHMWFXTWxhNUQ4WnRtd3lZVHRZTGxR?=
 =?utf-8?B?MyszSjh5Y29WVGtGVzQ0alBmUDVpRXFHWlFRMURFbWtVUld4MjRGZGl1aGda?=
 =?utf-8?B?Y2FVYVFCbWEvUlJGSy80b09pNjNsemo0K1hFMmtpL2dRdnNMYnplT29hVHBF?=
 =?utf-8?B?dnRPL3RuZys0SXluMFZYUWhhcTRCM2NWUkdZQ2dVUXMzVENRaEx4elBTTlVz?=
 =?utf-8?B?RDF3dlRJcmVqWENhb0xydlo3ajZ2VVFWU3EwRW5NWEVndUdzVWgxTEJjelkz?=
 =?utf-8?B?aVRGT0kwMmlSQWY4bCt0RHpWVzA3SW1XZmh4TC82djBFNVY0cjdmMmV4a3VD?=
 =?utf-8?B?eXEyZWlwYWJVMXdHd3ArRGprL0ZiSG9DUlBtYXVyVlpsZ0NDUC9NeUlZSXBU?=
 =?utf-8?B?Z1V4M0M2bUkyeE9GSWlsUUZtc3A4SjJZVURRZGRWZHdhVkZFODRoU3BxZHFa?=
 =?utf-8?B?UWVwdE5nRkZTaXNNM0FYZ053NHhkMlBXN21RT0ZzM056bGdzZWJ6S2dGaHow?=
 =?utf-8?B?enZ1cTNtbnkwN2FrK3crajFKRmpJQU9LSGZPZk9BSlBHZ2ZWeWVMQmF6eVRR?=
 =?utf-8?B?K3JLajNtclQvN1BBcmlxVW1NZ0hQR1FqeGc3Ui9yUTdVazNiNk85MjUzeTdq?=
 =?utf-8?B?REZLZlNCSVlhTm51cUxtZmNXcTluVURqb2pGNjJueis1WEZ6M1hEMjR3RzV6?=
 =?utf-8?B?TFBJMUk4NU5lRkRvT1BJVU9VbE9TRVVLZzRzUTRhZ3pyZGoxNUw5SDRtbTVp?=
 =?utf-8?B?elRRVGtQTlRiK0xBRTFnOWpDZXZHWDM5RFpDOEtVTVJHZG1vM3g4ckxmQTRQ?=
 =?utf-8?B?aFRwUlFpSXRKMlNyQWt0QmE4RXpiRHE4MXRxMDNDZUpBNjJGdWUzK0E2Tjc1?=
 =?utf-8?B?Y0dTdDNXR0tYdlZWZllYV1oycjZqRXJzUmt2dDk4Uko1VitMamRXUm04RVJ4?=
 =?utf-8?B?U1I5R2xqcm1nbC9odVUvU3BXbGFjWXorRkNaZDhiVTNVeGZPZ25KZHBNeGxS?=
 =?utf-8?B?clg2cmtJM2ZRaDl3WHc2SGh6OHB6VHlNMXhiL1F3R2FyeFZIdWxFRXB6bytq?=
 =?utf-8?B?Q3orQVNYY3JSU3l1WjhKS1BZVFhobzMrSzJjUUt5Qk1iVjEyb3dwQjFWME5Y?=
 =?utf-8?B?ZGNDeDJLa0tKNWZML2MzN0tKbDlHOW55bjdZTnV0NGkrTmkydjArQ0w1UDZx?=
 =?utf-8?B?TC93Ym1JanVXallua3RIbjdLb0Q3ZmQxUVJTd09MRENWNHdnTjlmRTRDYkls?=
 =?utf-8?B?OXhNcURicGJqRWVrd2VNQ25mRzJDOWxScmc5ckNXaEFkTDdBSnlabXl3cDNF?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	qzNnkCMP34/xF5879nfFkDMOW/7ffllOZGU80Fl/uCxM0eljb/wZK/HDVza1d0hWXhjS23ENkWcdptjruCtitlcpC2IefAADaYCHQUoTMEUv96BhCJtEZxOGLE4YrT8PBgVJ95qbtT4aKIxv+7iYuMzCeCbmXcdRlRECBjriy71aetwvpnPWt0QY1mVsh0loiqAYku1wFFIYFe2eGM1xdL6Ouc8HNrLii6SPuMwObyxiIN/4df8cKaI1GYJ+8UgTjq3MyTwt7cUW+YAtoR2f2mKJBQRbQV8hZM0xZVGMNbn25mBU1UcFvkCNbGq+x/pea361klMxV/GSTs489vUdHcNFA+jdj6W9fyq4W1iXbsbDZR+/ZyjdD9yk3VrMtxs5EkiOeGbKl8YiKlas6fHdawercRMpTgFBc0++DZlWYJXaTGkem+VkqFBUVEXYLJhC63Bi8m3lc1a2VjA7KEvVO6utDoPuugq/rj1qjJoNhagwxTe5x2sA7FlrW+Uqb4rFuzG8xWuaOkLjTumyMYMzK1ADdvkGdlWjRwgy+T+SuMcqALUocPH27pEo8CAHOTXlazXdLCtU/F0imFIyYIk434Ed/LE5Xdz6C5DGL3/qO48=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ae2910-8cf8-4ad9-0cf8-08dc6dc28ba6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 11:49:11.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: niIliAdaR8jEfjICvg2H2dHnYpI0lc7TXSakRzWIu3+OuxG9wC3mmHYkBnXSow8HGBtfmTTZeKdjXIsYBO5/hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_07,2024-05-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405060081
X-Proofpoint-GUID: pKLkWp0JD-OiGEy5eln05QiCxMgBpK7o
X-Proofpoint-ORIG-GUID: pKLkWp0JD-OiGEy5eln05QiCxMgBpK7o

On 4/24/24 23:49, Zorro Lang wrote:
> On Wed, Apr 24, 2024 at 06:06:43AM +0800, Anand Jain wrote:
>> (I just realized that the previous attempt to send this PR failed. Resending it now.)
>>
>> Zorro,
>>
>> Several of the btrfs test cases were failing due to a change in the golden
>> output. The commits here fix them. These patches are on top of the last PR
>> branch staged-20240414.
> 
> Hi Anand,
> 
> Thanks for working on this! Now I've merged all 12 patches with below changes:
> 
> I added your RVB to:
>    fstests: btrfs: use _btrfs for 'subvolume snapshot' command
> due to I trust you've reviewed it as you'd like to push it.
> 


Yes, it's fine.

> Then I reviewed those 4 patches from you (refer to mail list):
>    generic: move btrfs clone device testcase to the generic group
>    common/verity: fix btrfs-corrupt-block -v option
>    btrfs/290: fix btrfs_corrupt_block options
>    common/btrfs: refactor _require_btrfs_corrupt_block to check option
> 
> and merged these 4 patches with the review points (to save time).
> 
> Please check the "patches-in-queue" branch of upstream fstests. If you
> (or other btrfs folks) feel anything wrong, feel free to tell me. If
> no more changes are needed, you'll see them in next release :)
> 

Checked patches in the patches-in-queue; they look good.

Thanks, Anand


> Thanks,
> Zorro

