Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792494229;
	b=nsbCCYF6wSZ7KIK92aM7x5lA+bmsbzf109/iiZFFpcVviaIXeeXOI7MuewuM/dBDKUh5
	 vkEsdS5yGqxB/O8v3kD3NAJbJyX20ZT0zlT9ZL2/lmyL5EjxbVh2zqFnsmIumRdy2mKJW
	 ar/3NU383wIFaq4OuGA2hRbfII0aKs3Jipbnkp+e7JWf4n+jfiqVnlvA8KNdN0uzc1XWp
	 bTk5FB4AGW1IHFiBoyuLojwBPJbJYpdEpJu5aIMJ4EF1lPK54KXLU7fbBICh0v/TbWGZR
	 fUB6CExxboUyF331i6QWrEJRVigJCDiqynttauDTamzC7kK55v0+owyuIbyVgmpvYyQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792494229;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
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
	bh=ByXUosOei/zB3Jn2+Y+cD5QhjEU5WgC5zeDF3HWztp4=;
	b=ZWCaB98bhgcBQPg7O6f9Ra6CqtbLVrZyGnBGTRo/GLw3Y7/joICdMCH79tV5U/hj7pmR
	 91Qm0mo5zIcsRTFDe8Hf+UYELdGlMOTVWjd3Cd3HCFMSNm8IJTBRvmCqw12SU4M0vyLfT
	 yscQr/b/yBoTT3oy8UF4RCYSG6G/rxC+Ew5ezyyDdsYZ/aF71Z1oPGrM9th9cPmllooWU
	 FVYAzzTTzufqfKZdOMrEBvDDl/8tlPq0AkXl1hCNyYni7M9WfGIPIyR5Bh+ccG/sQXaCk
	 39EKdnkjuEnlzKRay0AVpgoA85gXbN2zHQCtRTkxcyAkShGW1k6V0dB9CdQ1PF4zRZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=SbJCktsn;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Nfi63wVh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D2606A31B
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 11:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A9D2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=SbJCktsn;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Nfi63wVh
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792494229; x=1824030229;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=6a4Ubp2KBKT7Ng13U+rol/g+SewXMWLWZ9fsNXRjR4M=;
  b=SbJCktsnlwcTXLnXgM5fVnlegM1FYaN2jOircUUH3FcGD/SQ1XJlc8Ce
   XLtmcwA8cGMih16zCuDTlmJSMFpD8WAFoyvw3f8i86EfVNwmJy+l03g6I
   BuD8/rqM6YoZzV2wlmkNNwV6vhR1mPuCjXuixG6DrJftJjrbv66ZsCyn/
   fo9FhSUKA9g+50f8PcD7PH7JKLSJ7VS5vLDuD8SdAAO7X5dEZwWRYrIDn
   rIMbmDDrbUsaM8IFZ/LVh1Z1kfSueKhu0e92wzDUX0WzyHO+g2jlHT7YV
   GUdDhi+39ereip9n6GRBMj1T2JZ1IRAbXBwWzhXu4Vu3rWZ7swvWJvYKM
   g==;
X-CSE-ConnectionGUID: Vn1aD3f/T5evLpVC/JFzNA==
X-CSE-MsgGUID: wVYG16yfQJy63i0L+Hkwbg==
X-IronPort-AV: E=Sophos;i="6.27,168,1786982400"; 
   d="scan'208";a="157581853"
Received: from mail-southcentralusazon11011063.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2026 19:03:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kay/1XJJHBLl7KhaTbpiZuWhj/CVB5RutEyeNYqiL4WQ93jcvLGm1uAtfiz3iPLDvTN8B7FjHgO1ie3g6HrBe+CGmbWgIptdLQbhwODRYJLT7nH+wDsJA8KhHqWACEtRHT7EhxUuqk2tcn3Ctma1C1j7y443QHjHM1eCvTo8Rds7cdb05VqPZNggX3btOMFpkaZDc4PE+UWxFTHm0Aq7aLMHqvQLNv0H5QvNWqYDdtzossVackmmRTJFYtGcunHUsmpyNNkcvE+I8XdRteKD5h3mmsZVIVmA/WMoMjf8f5HL6yVEi4P2PHKA4NRgGWtS31k4IEpspBHRzG7TtskUXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByXUosOei/zB3Jn2+Y+cD5QhjEU5WgC5zeDF3HWztp4=;
 b=ALeU8U7ij9MJLfS6m95iGY2wYkC+RWWmDGzxrNFS3lvGfJfn6d96UT8ZAF8zk2OtC4VYUM0Xco9Sv85aRgHUqh21Y0l/lzohgm3IXNoC8BGeo2VijcIrmV+qpXGI3copxYwP+PnpTSESmnF5w01+gmPsQ2Gxvs5NjZ66vXamSQj5W9jISE7vOE6SpA9B3sX/djQ9mv/b+mXBQtFRr+qlqZh/xSw1AUU/SsrI1z8IkBzaQw+Bj2Y6wYfddA3bnjIuIOPqqCTx/XcuLuW0TDKTxZmiJ+KwRAHS59KVBvrl7A3E91RP+SHu1+ZWrqpzCw97lMgP56giT44JhCmmuDqa/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByXUosOei/zB3Jn2+Y+cD5QhjEU5WgC5zeDF3HWztp4=;
 b=Nfi63wVhkvturOo9T7dpOpvpCrjMYuAX2cWkQ7HpubG/blu2c16xmXZdlgrcm85pvoTfEHyLNt6KrrqyUzGVvjDUFK64qfy7517gqje3vQ+rI6Y6CPPIqXCV58Z2/XNj+6AYLzc/hCxaCcoGckGlb0RVq3Yb0fkxCsdBvioiTn0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV2PR04MB9951.namprd04.prod.outlook.com (2603:10b6:408:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 11:03:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 11:03:46 +0000
Message-ID: <9cb0bab4-c82f-4fc1-9789-818d98c1928f@wdc.com>
Date: Tue, 20 Oct 2026 13:03:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] btrfs: convert volumes.c and block-group.c to use
 map->stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <ce051c4b36def7f5104945ef5402b36d175381c1.1792391732.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <ce051c4b36def7f5104945ef5402b36d175381c1.1792391732.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0275.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::17) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV2PR04MB9951:EE_
X-MS-Office365-Filtering-Correlation-Id: d65fd8d0-959f-4dfb-e86d-08df2e99d01b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|10070799003|23010399003|376014|1800799024|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 7xh8k2o/a89BedRbtt2hbhfou5uObDqNVIj5nEAxA8tOjqt0lrYlKhKqWUJ70JyfFKs6GrlDfont4+RpHuYva6eeggPEmh7vOC5VvXEL/zrPjaOv5V2YPzjzpLlHcLdXmXLNsYRFNb5CtFwjTh2W8VlTq6xURZxZK1B5k5zBBq6O5RAH1/A8m7MnEZDXqWMZgPw8ucAXEMUupbXvb0A2mv1pDUzBBSAW002gg/cVeCpFdcf2JBbeE9aq/0DsXmvYq7oKfsS1pIqNTuME0UwCRJrLJQ7PxRHr3N/+2ztz9c9h8IntGD0/9CdB/XJrKEkDk4lxkF6GLcpj0gC+uQEiSLZxeWSeuFoHkIP7D4ehs0io/tE2GCUNaI+JcNpievlCRd3NQO7PgsIDPkc6v2pXQz3HgcHotdCbx/8+IyoOHq8CyQKhJDzym5a5SU6vhAJ2h5i4SRdGRx43jzU05wFgQC8C6VplCV5Tsom2DVgbI3s2M5hjylJRDc1jSKSXCsbtFx0RDdDaKD77lFMW+RgM8fyYZEQn/ssaz44i3wKurzL73vJfOcEZGmF81xKm7tejAekUdQoO7uA6kmTmQyY2NDiytZSVECWs5OlR4iqglVhXooz1uYFQxjhObexz8FyVMWTBLV5UAeChhzhtQsuxzt1Lh3M3gYyxBsTqDyuuovM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(10070799003)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZTdJYktpQkxzQ0NMYWUrYzUwOWVYaTAyL1pPSkprTEdCb0dBN1Y1QW41VXJD?=
 =?utf-8?B?VlhKSGw0bkd5aWRUVldYUTQ0Q2kxZXZqOWpzK20xbDV2NHl1VkhZaWU4M1Bk?=
 =?utf-8?B?OWZEdnBGeUNPRGdiczB2MGdMa3hKTncydkJLcUlrZFlrSkNSOXVON3lGSU1E?=
 =?utf-8?B?Q2tKa1dTUXBxNlhRNXdNenhBTTcvSnE5dERET2tCQTVRTnVoSnpuYUJ3amFq?=
 =?utf-8?B?aGZlenE5c3dBZmJFUVlaNWIvb0dHQXdhOS9HdnJ6YlBEckFadlBHVktaa0Uz?=
 =?utf-8?B?TzdTWmZBWGxFRlJvdUE3enpyVTdFZ09wb1hNc0M5Q204eFhuMklSam40dE82?=
 =?utf-8?B?TjM3UnZpdWJmemxLOW9ibUZiUFdMZ2JJa2xiMldIRzVKKzE0NS9nNjdrQ0hG?=
 =?utf-8?B?ZW5UMk5KOTRDUjUzcTBUaExjWWQ5UUJtK2o5RmI4VUdKN1ROVWxRZnl1T0R0?=
 =?utf-8?B?b1RmTEFYT0Rtek5KeUZrcnpNVEhBNDJiUGo1b0c5R0ROcEU0dVdCY1VTY0xm?=
 =?utf-8?B?Z0l1by9BNGR3TWxkUGphUXdYUjVtN0NNUEF5RlY5UmRMbGFUbUFjZ0E3VUg1?=
 =?utf-8?B?UFdzUGFxMWgvUERoSHVmRjd5M1JWSDZBWGRvNUo2cFJCSnpsMTlTRDhYcHNQ?=
 =?utf-8?B?MEhyZFpXaEV2R1NiYllIMW5MSGtHZlpxdUpHaGp0V2c0NGxOQjlabnVMcWVT?=
 =?utf-8?B?MlkwTnRCZkNkcFhyb0FGWlVHYXp1TnNQTERocUJqWHp0TVhYWG4vUms3cm01?=
 =?utf-8?B?dUNxVzVCbUZxZThYU2FFZjUvSzk5TTI3cFI2T3U5WENTUWRLbUNJUnB4K1Vm?=
 =?utf-8?B?a3ZPT2R2UWpjcnl0UG52NlVaRHQ3dEFteTVUQXNJOUE0aWg3NzdjdlJIWGhT?=
 =?utf-8?B?bUorNGViOEhrQlo2TzQrbnBTRTI3b0UwZUZ6QUVaVTZKdWYzcFZ5UDJ1YWhl?=
 =?utf-8?B?UWpid1VOYnZ2dlkrTUFJcE4zczFubzJETUhjVVZoUHMzUld5Rnl6ck1HYkRt?=
 =?utf-8?B?bkRHajdYQ096MTJQL0JVemNHNGN3RVpxWTZmM0hhTEFjbDB6VXZJVHVUNzhz?=
 =?utf-8?B?bUp3bDJxb3dUVGNaSjl5eXhxU2hjY0JNV3hKR043WWNWK1VkYkxDUnVxQlRm?=
 =?utf-8?B?dHV6RFRTUXhwRXRmSEJ2eGJZWHhEVUVkYzhZWWRpdzdLOXFrNHFVNDBoZ29L?=
 =?utf-8?B?OWMvcEdQajAzR2dKUXIzby9JMStIWWI3ZDJ2ekg2Y09BQmtxeldTM0Q5YWxD?=
 =?utf-8?B?T3RjRlZrdGJ3UEF2emFEcFFuS213ejV0VllrQ2N1dlU2QlVRaE5jR0dCSHBM?=
 =?utf-8?B?TTdYWmYvT1pZdGwzZ0FLN29sSTF6VS9jTFVXVzNRL1JmUFJPWWl1UkF1VXF1?=
 =?utf-8?B?RU1Fa1J0Zno5MXc4a0xKVndmYTR6Z2NKZE91dHR0Qmlnb2kwSTF3bTVRaTRq?=
 =?utf-8?B?U2Zwbit3VjhIcGtDQ3dzS0N5OG15T2NGSk1PaDh0ZmtYQTEvbTVDd1hBTVZG?=
 =?utf-8?B?bDF2eCtVTzQ4MUltdnlEVDJFMFBDWHF6a3g2MVJaZDg3cHY5S1o2cVJESFMw?=
 =?utf-8?B?RFFndTRrS1VndlBrN2ZNZS81N2FuZVppVGhBR1l2UHlGdW9wazhUSHc5cHFY?=
 =?utf-8?B?VjI3QitlSnRpNWtyZm9STmJadllMckJxcVcwTTBHU1VYa2VsMUxvRWo3ZUlk?=
 =?utf-8?B?RVFQcnQ1blBkOUZiLyt6anhvcHYxVkxYdWd3VmpDUWpVK2UrdzdicUc2M1dM?=
 =?utf-8?B?RVRlRXZlNXQyV1NYZ1hhaW1zWmQrbUVjdHFxUHRRa1JsUjZSZGV3TVJKUUt5?=
 =?utf-8?B?NU55dzd0SEVYaS82SVpvcXo3NmJKTnBFR0w0R1JBYS9hTW4xOHNxMEFUeWpk?=
 =?utf-8?B?b1JFYVFOWTR1bUFGQ29PbXAyYkJScXYyVDJJL1pSUUdzN0pJVVRFU0dyMk9E?=
 =?utf-8?B?ZTJrWUJGUnhUdHFGR2NtY2ZaSXZIRkhqYWRrOXZCY2h2SUVGRXFjSUpqRWRz?=
 =?utf-8?B?eDhySk90Y2h1TTU3aUJvUWJCelBqUEp2aHYxN090YjNRMHpOT0NNR09HV2Z2?=
 =?utf-8?B?Zk4zdXZyNVZrTUE3Rm0xU0xtVEdaZ2RWZWhTb1Bqd1RObTdOdDlRU1Rla3pJ?=
 =?utf-8?B?Z2hWVkRKRlBGa1RaR2M2cHdxLzFEWFBtL21mdjljSDJkOWJDaG1XdUF5cXZj?=
 =?utf-8?B?R1l1dFBiQitkUXhCMkxzMzI4V2ZlVXIxc0JVR1ZLUWMyMmV4Yy82OXNTUlJh?=
 =?utf-8?B?aER0NjJyUGZLZ3RhdnhSNFRhZHZQVGJ5WEc2QVZqT054RzFZZFFvbEVueVRx?=
 =?utf-8?B?WXN3aXpXUlN2YmlDNHlva2pEZHR4UFByUXI3MWpuWHN0YUs4ek5ZbnpnaDhx?=
 =?utf-8?Q?Omr1tdibi9//e5l4Fn9i778vTr3FhGflmhC2FBvFoPIJa?=
X-MS-Exchange-AntiSpam-MessageData-1: b5Uws5VNUnv9S62kVfIxzfGN4bYFchcgiRw=
X-Exchange-RoutingPolicyChecked:
	LLSztezBYDnuf7Cor/tzkbh6EhZpoYqFj0xeIgSq0WzrIGki0rMDbCKBXdfY+yurJymA88LObme6K5cQLrqqRBYDQLFdFx8VrhsPXqjtCUNYGrMS1pM2bpHCFRgEqdVPDYgGdv+/jze9QP+afCjoR7aGE7Syv/FJ3RX2SwHDvBP9Mcz5oI/8nsLhXi1/RPYXvldqlkZvfuM+t0cSCt92hzW/NYd83skpir0nXb7wjVl/9L70R4gW2fA7BpFkxZMEDST/DzksPD9y3wPQePPfYs3JYWPeAdV0w5fAxnpoe4j8wSVBTba9cQpv+BlDuI+49XNaC/KV4hE4dUSFiiElUQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t5Akiucpun/QF9DEPYa7k9dQLYNGRdIiCqP2+YYmvsixkgj/VfHM+sIH6/MXwhdomIe7TMmO62B8ytzlrmnBg2xTeaLRAJXY1Po7SDvBSLordd2pujC9prvhJ6TBJne0VgH+5wTpEqoUSS9tA+54hXtO3PqBKW7AwvAJfjb5vpg0S532wq+NJpskppXy7KUzvD2Z1lP9MuVZZE52QhLtRzDOTUr9cqn2KEpX69X0RjWXRDFHvqyPdA1tnuxs5nPnlYalO7TXc9soMUFkIGW7E6aa+VpQr5qNPn7MHVAIl7IvNoDSrdZE4J8ixbTI7mwL9xSBLOSxY+nI6KNcgg9vkQBt4hbmpx9X9TKGoNUmIrsVRLwWq/fw2wZjES2DVJOyOuiDUgOgqb46zgqgRciphCY56QZ1pScrO0XwcgN2hGBiZVs5XTl77lVZlwNwRxxciJ6+sJYQyU5fO9VaUm5xm0FaUyUt2UQtcKlL9DDmX9B54cGPzBMU7HMd75XGW1Qtg+Wt8E2jTr9eeSVSxKyep59RJXN3e/noAnLwkwl7zCpuT+llY9II7PSiBvdfMb+2xO1Akep9cuXtGw4BusCAqkvD9+cqUDKEwTFFpMCtAf/uYymAtdo6uaRQpSZnqN5K
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d65fd8d0-959f-4dfb-e86d-08df2e99d01b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 11:03:46.7451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HFCPDsTU7iW6m8fbQZq0Xg/ZEqWHPgS7YDjTZzwaLW/ie7/oD4I3Wr0aJN59hBuYlguSL5Fuc2FLpwiie0TusEkvx14ufIZQT+T+6hCn4Kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB9951

On 19.10.26 08:40, Qu Wenruo wrote:
>   static bool is_same_chunk_map(const struct btrfs_chunk_map *map, u64 logical,
> -			      u64 length, u64 type, u16 num_stripes)
> +			      u64 length, u64 type, u32 stripe_len,
> +			      u16 num_stripes)
>   {
>   	if (map->start != logical || map->chunk_len != length ||
> -	    map->on_disk_type != type || map->num_stripes != num_stripes)
> +	    map->on_disk_type != type || map->stripe_len != stripe_len ||
> +	    map->num_stripes != num_stripes)
>   		return false;
>   	return true;
>   }

While you're at it, can you untangle that if? It's barely readable.
