Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792490378;
	b=azp1Au3Xlkml8gzJ7Y/t/NEPnp5kHT4DLvJJ8+gzNWvPQ/2XwWhiwQ7vjyFcbZX28256
	 IAaKGnnI5HBya/L9XcPetzKa7/dXB5WyxSNyTx1CE59sOnt5cbzLc/VyQ4yBzWacNSAp+
	 6TOwUvH42TcLsgK882YkMav4BzPJiYCuBcRcMJQ375hGEwRn8E6ssqSHKtq31bPk+iRQ6
	 G4TyE7YLB/XCKGI3mxdfqrxJLJMUPYsJzvxnEV0yvub2WQr3D+jNogciWYsFA48F00/HN
	 bY2s47XyO4G8lY1PnvnjsybMG4XV/jrycDEbkDBy9c6jrwnnHSqcKjzQ63HItsnNVFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490378;
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
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	b=1aqgup+hp1dxY4yLhSktg8v5lZH22s788Bd0ADzyvcxPsdUvBMS87SlvePgVMubS5snW
	 7p3mS7KovbKhxMo2Q3ox01uCVDoIEqS+vYM5LILH/iB7jTVA8sR9oW1fWUc5m3vGRBbC4
	 YKPyw/BdpHGTrXuJxVeRCbNiue5Roomda1fNe9aHKzZBRlkXBWRgwvXhjM4bmJ2Rm7xki
	 omBsyccAi3OdiF+DoAapZ+Nvo0geK8jjtjh3sMMYIlbyDzjOD/sO4ZNjh7zNifcRcNNLo
	 XS8YhPGVwXe7DvsF6XLNnB0v0BxTrK/YnL+4HYjRHWeBTvELRCKvloyFtVnPWLS650Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HxMfdEDE;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=EkaryCdl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF48606A319
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 09:59:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DF48606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HxMfdEDE;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=EkaryCdl
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792490377; x=1824026377;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=HxMfdEDEnEKCKHV2bmWi8Pt0tzAVB2hLe4VxFWKSsDalk5iuZnK1JAi/
   XPAjxIQ951e0pEKGa0xz6Kb0bApvy3iV+Enyr2s0aliw6aGN9zLfF6T1Z
   y92uDuL2tXNjdNUxJNP24dtkpCvKb9CqPNZCIUh+22cC5YQFGss8jNHga
   nS9sxhVTB2vXrUrS51uD9Dk9mnKa3WSkQHpWKfTgfUuok1XMNznxJ4s9F
   fGOvRkJUK29gj0sa3IK+SlqaTKlUhG9hFkTelLP++EbVh+HyMfkBsM8GR
   onGYyp9YPldWmkjtpO61Qav5Gve80fTkpXdDL4+pqTqt1H46vCKq6P/sS
   g==;
X-CSE-ConnectionGUID: SHhug98fRcS69kHJyNX1rw==
X-CSE-MsgGUID: mtGvqADMSgCjpMAmS98lAw==
X-IronPort-AV: E=Sophos;i="6.27,168,1786982400"; 
   d="scan'208";a="159487726"
Received: from mail-southcentralusazon11012022.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.22])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2026 17:59:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UEYoEqqQiBg3qL8go9GTYlQtbwbhJ/ip+54TKr3ZnGeEY9LuoYg/DFiQmvR94RcdyDiKL0YKo0l1y3rBoko1r9WHRhbHPgBEHBdpDt5Mygs06cU4+gskCc3oHtniyPDfXW/Xv4/knY+jNegop9waMmWt3fF+wMfmCpQ/hmDwAt6SLjBJMDAnkLySGlyQJ36NtKki7vJZTWvcF7+hsxV5/ngmqOoh3dMj88LOIUL6rE5FA994qNrycESlumJ2DzKQt2DN5Mq6vlh5i62MmxqnjvsNEBWahaVkYsItqghIxfwE9g854NY1FxWkGrpgono5Hsma2qBRXHYeEyhVjAST1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=AgXpXS8ygoaIKNY/Ukzm54eEkeN1SnPnVlD4cz4fyIT/pFeBVOOfy6m8kfi/e4Iqu2kwRy+Mfj/0IMPZcDOno2qtNskO4Jva2gXxVDcC28IcjQEVnQXOlrq0PpQHYZYCeiyLpIsC2JRvU91cIYb91TrgLx7r7kcMWvjuMqMjSEGntkIBW+0zV1jGduqZI1kvUyX2ir2VKZGySs5fT2qmCXGBd8qXyovmV7CPIFvUGYeYQr6ZL7gdQ+l0rpGD0mbaMr7MYnh1aQVCOy+Vtlp76P3+bwpWFg8GBD95WKBA5muLqqEdu+G7VJe4K1xy9ORfJfM4udc3lSI7FCCp5du/Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=EkaryCdlKVp0oll6Qu/I4ogVceUW5fDdeQZUpm67AZ3UAOBr73lS0zpaFrMVCUx4O4A2PkTDD379thFh0u0FJyO68jzrQdODjm/EQFBjqMw+/8Ao3FXdJ+pr1zmKwkDWsX7lcZ+pZoCOkKa+B04ORPTRgRirjP+LgQQ8KJSwSO0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB10219.namprd04.prod.outlook.com (2603:10b6:510:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 09:59:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 09:59:34 +0000
Message-ID: <816210ef-930d-4f1e-8daf-41f44fdc306f@wdc.com>
Date: Tue, 20 Oct 2026 11:59:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] btrfs: reduce the width of num_stripes and
 sub_stripes
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <a5234783282dd9dab22442ee9bfb3a4b2424b931.1792391732.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <a5234783282dd9dab22442ee9bfb3a4b2424b931.1792391732.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0352.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB10219:EE_
X-MS-Office365-Filtering-Correlation-Id: 604173c4-13e7-4338-21be-08df2e90d7c1
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|19092799006|23010399003|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 v3lYvIaOY6CqWZ89QNmURZrrtzzcT/zpSHzQ4tsEe9Op7ozlaEKEtpKXUplQ4geScJpT8kSOXXW3ZQN/NCFel848avEVfK7zYBqqKRau8h85Vn3wtHIOoXqDjrVfGDgUNfuu1rplA3P7hlAVXraN3ukDQznjpgslj3utzfq0E0QfMuIUnD6RDqL0lOYpyARbcTFAW1TpIZZknUnlJcYHPzk4wPy60W4++EznBK7vIPDfi9BssfPxG+q7xAe0wRjJ+3Z9N9Y4jB5WaI8/64LQ3XhdxTd2jgoL5zIBjS7nOpEhQxC91UzvhhsGbr/oive3CI64hVGCnmUYn4iY+zN7eQA7sanZpxc8e+CNBlbRuVVLKBkvxr/lXE4tk0bRfer9ejQ21JNJOgWpySOV1EKXGgJeCV8S5QeE5Iy4qcDWKKNJqqHjaibTW5FTEO3oBSbrD3WlxWYk9++sfkBCQCnvTCrdkag1J334Y9bSvnH99cXd4G0XlnPcl+9c+D+mD5RyT5Lzhitf3i6hVSjbJNXYSfpJfXn14Ur7AsAxneucZ0QLQ0kZa07gn+2Ef7LqPqd6Rwr+Yif323jhfcJfD3MR3VnGzzwKe6joMF241dN+3AMhzuZwXMYE/HLZ7Qshxdf6FPDtvuiTc3OnqF1ZW9/CME3YB3AFP9JW6/Var33VMo0=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(19092799006)(23010399003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?STFkTGorTytQRVRTN2p6NGVmYVFEUndUR3c1VnZhZUNuRWo2Vm1IelhnVE8w?=
 =?utf-8?B?czlxaVFUbzdON1BjNVEwdG5xTE9TOENaTGh2QmVoWmtNTVhBc3UwUTFmU3hV?=
 =?utf-8?B?TmV3aXVadUNSeG1aOTAyc2xZSjBaK2t1TWQ2SFhDYjNJZStNM3lJWGFlRVZB?=
 =?utf-8?B?bVExdGZxbGswUWQ4Ni91S2tubWExK3d0cEdSNDEwVVBOMFpDdFduNC9teDNN?=
 =?utf-8?B?T2EyNnFHWmF2K2tjZUtlTEg3dE9zNDlBck82enRoMW9HU1R5Z2IxOGp1VUph?=
 =?utf-8?B?VFBpajhWaHV0U0ZkRlNjWlJjRUs3NEcyMFV0TjN6ZFljSHpGMGIyZEJra0M2?=
 =?utf-8?B?UXVSODA2Z2owS3Q4STlGMGhGKzJOK2htVExhYW1UMHRGSmZ2RTVQMTVMdEhq?=
 =?utf-8?B?UDFqYTJTU1p6R3FWbFVrWGMybU5tQS9OazN0amJieS9FejB1UjB1Q1NtQ1l0?=
 =?utf-8?B?dlJwWC9kcVdLM2pnNEV4YjVjMzJFeStFcnlMaFJBU3V0dmY2M09Bc3lUS254?=
 =?utf-8?B?c0txNG4xdmJySjRndC8zVkk4M05aWStXNVB1SkNaM3hod2d1R0pBZkpjWnky?=
 =?utf-8?B?NUtpMndFaVhVaWMyMHlWNDIzQkVaVGpCWERFb0JsMXBybUd3MjBxU3E2SUVK?=
 =?utf-8?B?eUVmOHNQNXF5bUo0dG1yZWxtaFhpeUxWWUNuZ3N0WG51c2J2YTFTVnQ2TENr?=
 =?utf-8?B?Nm9EY0tGanNYZW8rZWd5T1RXUDgyeEhBb1hwa0dhbHZWeEZDWDc3ZlZ4RStn?=
 =?utf-8?B?eThBaUlNTlk0bTQ5czB1bi9rajhyYzB5bUFhdGhMSUhreFpDMFNwdUVDemFi?=
 =?utf-8?B?SUdpaXMwcS83bGhPaXkyWTYyR0pZbklTRHlUdy8xSktVUUxISVNFTmNFUjhh?=
 =?utf-8?B?T3NydDRjd1hnY1dwMk9UYlBtQko1UWh0OWJZYjVEUmhIeWozcHRMK2R3OWZJ?=
 =?utf-8?B?Q3dDdThIRVZZd2NRbGJkdW9NVGtGOTU4WGNmNGIyOUV3UlBJMlJabE5RQytj?=
 =?utf-8?B?Z09EMkVqbGtMT1J5bk50aG9LbWhVdVJRRlhpRlZ5dkg1YTFkNGNmUlhwUTVK?=
 =?utf-8?B?Nm53dzluY1o2Vys2TFVsb2FRUEZwTVVib3BuNS8rNGZJekNmMUlsUzdDamJh?=
 =?utf-8?B?ZkxWbTRZbDlSekdpeE0wVTRuYmdGa1dKa3ZnNmdsUjgwQm10RUxjdFJIeVcz?=
 =?utf-8?B?MmFoYlNubFplQjZpblAzajhwYWpLZ3VubEhhT3JJL2g0QVJyemVPbjUybHI5?=
 =?utf-8?B?STM4L3MydjRISVY3RnJRZFFjWFQwU1hhRG9QNkZpQit4WmtnN3NjYWV3Ykc3?=
 =?utf-8?B?cXpySFdaNDhkRU1CYWM3VTR6N0lWVWFOR29ITUJvVDZGbkJuSkVWSS9JMEE1?=
 =?utf-8?B?Z3ZtR2V1NzlIdGhNT3FOME9xT0lLMG1DODUyZjk3VUpJMC9ZQXBHekhhTGM5?=
 =?utf-8?B?c0JrTTlpWUhsbWlPaiswTFczS2ZDM1dka05xVm90cnVwbnNObDRUaTZKZ291?=
 =?utf-8?B?RUt6MUx0UVNmMWxZbmd0ZGlEL3BJYitaZ2RZcWptZTBaYSs3UjNsM3Q3a2ZY?=
 =?utf-8?B?K0x4NTFieHZHMC9tYnRsVlkzUWIwWTRNV1REenZhZzJtdHczWjZqQkhFL2ZE?=
 =?utf-8?B?YlZLMXdHY3ZjWGcwMmdnenBycFVMcFB4b3JHNFRkS25ncjBKK2R1KzRTUVM3?=
 =?utf-8?B?dzZGQW9GQmIydDJEZm1EMHJJL0toUE9jZSs4aklZaVRhTFQ5azE1bDhTVjMw?=
 =?utf-8?B?QnYxN3piZCtyR1h0N2kvNXVHZFBmYVpncXVYNlZwOHVuZUlhc1gxWVlCOC9w?=
 =?utf-8?B?ckdjSFhiY0F4VGxFWDJxQk5yN1ZvaHdkUlVaaC9rZ2lWdzNMTDdiTkY4QmlY?=
 =?utf-8?B?VzRtNGZBT1cvbnplbXc4eVFsSGxsTml3RlFhTGNKVWo0YmdxZE9sZ3oxYmZo?=
 =?utf-8?B?V2dnaUpmZmt6b1BMSGNZajZCOXdSNUQ0MHkvTXNneUFhTU4xUmJaL1VxK0VD?=
 =?utf-8?B?VFV2dGlpM0hnVTZTQjRtQXV4bWhXQTFEcm44VzdaOUtXNHQvQUFVaUU5WHV1?=
 =?utf-8?B?V3hudE9VWTc1a1RWU0ZFaUJlU1BwK0pYc3VnL1FheE1Wb1VoMVZ1Sjg5OUhm?=
 =?utf-8?B?WEtUMlZubmdkRTY5cFZKbFdieFcwUmovRThoOVA1MnRXSFl4amcwL1pCeWRm?=
 =?utf-8?B?SzRVajZZaU9xZDF0THpxUVF2V0xvc3BOS2Zmd2lHbnFVYk1kc2djSzV0OEd4?=
 =?utf-8?B?b3Bpb0VYS2dabllWSWhiRUg5WXBYNnhBZ09WYm1CUTJVOEJGRnYxam5aR250?=
 =?utf-8?B?ZldpQ0hRUGxnL3Nhcnc2cHpidWdNRVBDMlRoT0dGQXYrZmw4Z0VTZG9LTzV6?=
 =?utf-8?Q?+Cw73JuaCR6aOIE4qjMsJQwzf5IYNdV4Xu7mRS25PUvzd?=
X-MS-Exchange-AntiSpam-MessageData-1: VDmKsMR6mEhyi+dxC6FH1bRd0ZHAY5XIa38=
X-Exchange-RoutingPolicyChecked:
	CjpL8+jLFjEkUSNzJRAnl32l6DtAP3ZD7qvmESwolcdRsneTqnyqUOLA+HCFo1Ruxs6t++5gbCG0ATyo1k3LxtohHUw0Ur9jWvpL1r5yjPUwx2lL5Hwb59nTLTu7uEyqG97yPkceY7KuH+96X3NEuwHvJzFOKlTFM6wI7smJVDj6JHJfBMAlKCRjqg6TYIZJj1XKnfhT8SPAfIa+NtaUypNLSrvWCCYL4BzMD7b9uga52MuLrYlmIddW7vHAU1qu+i9xcweCPC+ntUCTKEttLi/3oVy7tGn6IT0TG5cvtOCUIKZohmGpKf5zoQ+E04OZcpLMg6ukipClwVS0fagVow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MS2QbT5FiaSdH09UY+jFDsOwUh73s9ZkYYYDebigy4yspzdPhgXan2WXd3nbUHeQpYg8IDH6ZEYQtR2GFcLDG0MaRbs0FhVZJninEu1iuxs2s7CziyFRQC3DJW7MY0jVNALjUt0vxCqt3psVM5gVkAvWbnJZ79E3uwNcS7tgg/f2CXpFMnVeSBXA9mWG0lU8OhKvYczfLC+6MGNJScv20ugP7xO32D+SCKX83HzkZxhvNCgNjjldkJT5w85gjqlLG49LDxisvJf6YElmYv1xFVHeMp0KGKS90w7O+qwRu4vYxRfU3r4g02VEq+Oltd4PEEs7q/IfQ9XZzF+TbI/E1YCWd8vIpoz7Jk1yY5Pms018b/7/Zrv6e22829Nrm2IVyEzaph5qNheo+2xG4OY9if2ISAz3Hu3YiAbIWOc2UsPF6lP35ha64V1kYtsS75Ryv5r+KfYHFUVkii+mygHogDGUyko2QrK+uHCsxp+QvLzApRMCk8nLbZqeePZqIr4LNis1vsvbPtPRszXAEwV30qzwsDKWFKg5MWjn/kPzuSbe+3Zz7Ag+Nkwa3IoRp/BCa6O8Zfy6c/Ondfknx+nFG7cFv3KQweb5NdHF5rPGul9chIBTfJLEonWmzVPXuwnO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 604173c4-13e7-4338-21be-08df2e90d7c1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 09:59:34.2536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Na+N6/5CeOxRAzjTpBUP5koN4qsTv0DuLbBXwSmLr9uPe7i1C1enZebXI0iC5T6f3rWVafha5PGWhCX4NRZuNzsDf35Rrlq96QvCQImsZIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB10219

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
