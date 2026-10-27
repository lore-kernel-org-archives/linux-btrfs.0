Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793084759;
	b=M24AYN2/lvUezVG3Lw9T5Qfld1VqASWJKZKoBdKDiDLV2nPxqWx53sfXt5VQuWhKCbwO
	 MWhuIz1F/O2RJvTKeJzPWHVc8+sDxkDDPBg/BKlcDgAglmdKIVIIPEuZ8DpzzdRDYKeUe
	 UZ+UHN54atZzVY00xU67KgLBPtaMzGls8ca8vmrT4wuqIkryJ6Us5IJjnujkrKgpRgfYq
	 PfDJMUHnUtiPURmuZ+owk78+sM/gkgwY6AqRbOuOweDcay5IyT1Yk3axEk4ypq0yF+0Nl
	 L6PE+w7U4pA0xIPMkdDQT/SR5hcXyfQQeXB92IpmkIau4+KLKHMja0xhW8Ap1bH/Lqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793084759;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
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
	bh=Y3FtvIOKb/Vlrav4bVrXRBvkgCqHBy+WAErY7Rdpxws=;
	b=JOYoGljXC2SwoKbI+rjqeab5Y6DS/TT0xB4kWDH/wPhN3NphzceOC+L98JI9qHTGHE7i
	 8y6HKO4cncpOjh6jxF0jAB8Gys+jpiHdevzOWVwppN3SOMp2B0NDxe8m03itye11gfCzc
	 sdJacr1WvsmSrNfyO+mSCdff692aPbuUfDhueLBZeKEqxKtV/7mOiPzmaZth/HvofKq4h
	 7/6hX463K8YAp09y35iBfqQ0T9d0Z/0f4QHOzvaufkxYKdZ0IyKnc4rGcs5PvlfObBjIx
	 iMlnJFHkdWMB7umpwSptAJPworlu2aAIZWHRRSYh5OO0RC15MqkYSi/Byn6j7ScfPpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Vrp56dXB;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=R4uMvPtu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D30606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59D30606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Vrp56dXB;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=R4uMvPtu
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793084759; x=1824620759;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Y3FtvIOKb/Vlrav4bVrXRBvkgCqHBy+WAErY7Rdpxws=;
  b=Vrp56dXBA6CiOkRiCN8SFhm9WEqtqh7DUtAvSASEUNJLpuqBtdw/mwz8
   LYRaP8XR/Q5not8Py8aOkkslzX65GBPDoOhB6/EU+rpP0iBnSzSwFmYep
   cjxPu6PWF3y1SSBGqUyR3eYRwG8HbVSMqQ5Or3NbjnBMiU4BIj9ZDxReG
   OtqrPRcg59dtIUkxjpdsuYoBxwOlj/tXF1eeU7PRUG18GaDyGwK4niNtB
   BQ+YEdJJ4aKdfq34+RkYM4oyYHKZO+lITyi/7zlik/6kakHdiGMf9Jtcy
   CJdL14nKUef3h9qwnLh8upYifxsNCkGWll/trPylizY/84fY829KyTvOo
   A==;
X-CSE-ConnectionGUID: PsuMgYPMSnWVuzW7uHfeIg==
X-CSE-MsgGUID: TZ6BxrfJR/yRcQmOI+tXcQ==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154862050"
Received: from mail-northcentralusazon11010057.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.57])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:05:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aQSvoNFTCjF8lSGzi3O9L+LQMvGiQiq9hNQ+QWafa8LEf9FYIAOSeQpWwXMI01K2PFTz1HQ3qbOcnK0EnL3OItuSKUi29oTgK1cc3Grg/gx4kRTuORdZ9xZR3lPzmAlWko1X5V2Bw3LGJGRnvZmZ87Oeo896e8Q0oWggcdb9vcnz2iYR6Vtb6EAWphD6sUfaGi/xEgwaXf+gwVwujJuDDOUikeeJgGW+9iKuYE20SmL0bIQZPvaeE/47LIyZkXX4yR5K202CtFSpxNIRifrwtbgduOPVDIeVWePR3kHrChaXPIO+bt9A5x79K8BshQhulr+3Mr+7rWVy7sgg+NqLJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3FtvIOKb/Vlrav4bVrXRBvkgCqHBy+WAErY7Rdpxws=;
 b=SNKKJAB6v4QL+ZRkhTK5FJhPfJrWuRBO/KdGOV07PGCtcOvpI2lJ2Aw6MmhazKgpzaYd37wyRjYc+oTvtiR/NdnDTP937XVXKgEpoD9hvcgRI4UMOl8T8YR5mSNwoXEOombmMnY8LNtoPqtMaVDgxR8+UuATfaCA88m4ANZpG4GcIWH0qw7eNpgEexPOn7uj2NbzZMrcl6Aao536PYvRD5xq231vOVvhqeHDoo+bTy9xX71UHCTVZPjTjvY+gTu9iTKZsdDIJPbUL5Lscl7Km3kk3dtKCUrASQkRM1kuGRmxsilYFw/we8oO+TvkJQ9fNorK+5rtUyowQN8RJDzK/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3FtvIOKb/Vlrav4bVrXRBvkgCqHBy+WAErY7Rdpxws=;
 b=R4uMvPtu7MSHjn8fyrayPNuoYABtyFFz2j60DQ7B6FQhXvEAZBIL4ay69BvskjuEZby0FM9sulLn39PwoEKmMnpJ924gMKDhnkKA1OG20JojhlQZLLvP0hxRTIZJTsS4NrKZe3FLsw8tSDsZUOUJxSX2G4ovURg1cBsIbOk6r54=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7867.namprd04.prod.outlook.com (2603:10b6:510:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:05:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:05:56 +0000
Message-ID: <7ab1d3a8-86c7-414b-a7ec-4f875ee90977@wdc.com>
Date: Tue, 27 Oct 2026 08:05:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: lzo: use memcpy_to_folio() in
 copy_compressed_data_to_bio()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <2f15acc9dd04f6a3ea6d0895f9e47ff20886df7f.1793036279.git.fdmanana@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <2f15acc9dd04f6a3ea6d0895f9e47ff20886df7f.1793036279.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::20) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 60b27953-5217-4c09-07b6-08df33f8bf59
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|19092799006|1800799024|376014|23010399003|366016|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tPpvdKRkQ82mmTh1fbnWlqRWzEzadqeo86UJkfuZ/su6QD8A0gva5sbzXHOPPuwuiDAw92Qw6psXafHXbQ1T/Uf1/imXx/rQPl1vXJRHj6aNY+NLytZASKuCq3QSxnKUbQkrVxgRYYyHE+Vdqm1OoOBMMUxCLX+PT1tCqOZkD7OZW+64/+jJ1f8mL1vGFELwZi6tTs1on6rIUvk5G2tWbLbPpELCxfQmRm+swukEYexG6XK2RH4xxEpTk22kH/AxvnAGhFy0QecOr28P3VgxuIPInUEbFqTVW493L1SW9gTEH3RVOx5W8sjiWxIxfrmTerX0YO70t7GVhhrfkYUGxCfSLAvoxaGzMkloyZjN5/0zGdsDEg2GcKlX6N5ejNwiuWUQYMD1pQU4kYR5pcoBNIE+myaAipXHEaTjjrRFxQAK1Eiw1+098HBWpwnHEQzSBxqt4akRAH/FisGrt7Sve9IzgXPw/+bwGb/z+q+py9/00zcG+WcW3tS7zqQrXGX7ZEEHOmM77H5uT4xjqhz9yS/QaTRmUbCzsE5L5xcxBoMV+Ak/0fgK8WTQNx8PgiD1diIakxQPFz2CPc4Ce2+1Gqpbh5dqQbVs+YKumvcjh+gO4oMC+wQb8SSDTZEahGu87XdurVSSf31Q6eIDWAj5ocUPqKSGud/ExCXtCaVRkBA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(19092799006)(1800799024)(376014)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzZqMjZIVlNwbWhvUFhMR1FQZ3BnNWFsdDZZdkVPMEluRytQc0NYQXJZQU5I?=
 =?utf-8?B?RjRZNUhNTVZmNkNmdkl1MGovZ0dTeWlGWGZWR0c3SmptVW5QK21VRW9Jb2p5?=
 =?utf-8?B?WlAvejZDd0F3NHE5UjJIcG56dTJ4YUVhY0Y0c2JyNTFSU2ZUUzdEN1I2WEk2?=
 =?utf-8?B?NmZURFF0TE8xNldmOWN6SXg1MGZaRk94S1kzSDJ4N2hSY25EWmpubm40M2dk?=
 =?utf-8?B?c0hXUERLbFNZZ3BzSmlwbEFBamV1Tm9EUy81ei9mTG1ZQmxPZk5kaDhGZFRw?=
 =?utf-8?B?OE40RVVNM0pRUEpldnk0N0lXY2Zpc1BaOTg0SjVtWFJZNnh4RXdyZ2txaGYy?=
 =?utf-8?B?V0ZkL0srRTMzb0lSUEZIeXFHT1BqOGJSbVRnc1Z3SUxGUmd1RUhaUjE0cFlE?=
 =?utf-8?B?RUo5b3ZUN3FoNlFKdC9aUEFiZyt2NkxCZ3RmWVB5SW9Wc1hVLzd2MTI3UnhG?=
 =?utf-8?B?SkhleldQMnJsM05hMGVZY1JHUFJKNTJzYlNqalhITmdHNWoxcVBFcjU2aEtz?=
 =?utf-8?B?UlNuTHB6ekFUOGVwVVY0UnhyMU1uWkRiRkNJL1d5NTdhRGxJeWdsK2RuZ2hv?=
 =?utf-8?B?VGZSV2NRU3FSc3BTQkFtbnNjeVFhZGlXb01aaTR4czZMVEkrQnFJeWpveXd5?=
 =?utf-8?B?ZUp2ckpkRnA3TnFIWWZnQlhhMlc3NjlSLy93NFlNT2I1VG1DOHh2K1kzQWhy?=
 =?utf-8?B?bXU0dEhSQ0w3VGFjSFduS2NZeXdKeExzSmRSclRzY0hyVkkyMXkvaXNsNmdu?=
 =?utf-8?B?V3JLRHdoNWhoSWRXWkEzMXVoNVQ2N0t1T05QNnpKTEVGOWVkQ2huYXU5Nld6?=
 =?utf-8?B?aHc1VWdJc2RFd1VOS0g4R01vUks5YnhiNzRNcHJHVnN5cG9mRWJ1ckFCdW5r?=
 =?utf-8?B?RWFRa3ZDSXhMVmV5Qm5SYUV1bytCZW9hREJDNVU4Y3YwVXlBY3FkOEFySGc4?=
 =?utf-8?B?Zk1KZXpYWjZyaDU4Y05GeXdzODl2MFBPdzcvc0crUWcvOU1oclA2cEdZYi9w?=
 =?utf-8?B?WFNpSm5zaW1SelhkTm1UZE5NMTllSUNGLzdOY2hyY25LWXQrV1NNeW9NOFpW?=
 =?utf-8?B?V2RhTXcxOHcxQ3ZGcDZyREMrYjZGMCtWbHJCVTAwTEpJSnFzM3ZBVXpMTXNs?=
 =?utf-8?B?TWxEVzZJbEI0Yk5PYWJ4eUxGaVhKSXJsK0VxUUVJTU9ldzFYZUM4OXdSaXJP?=
 =?utf-8?B?M21Ec25SVXBHT0xUdE5uQzBUU1IzdG9MVFpvczZxd3hJcXJzNGRIbGpGc3pt?=
 =?utf-8?B?dHRQS3BqSVJNNThnSWxtUFZHb2xMeFZwZHM2VExjL09XMmdvMXl6dUhxYWFS?=
 =?utf-8?B?T3JGSVlSTGlQRTkydmU1c0dNbndSbC9MUkt1RWt2UTV1eEh6T3d1MHVqR1RD?=
 =?utf-8?B?UkMxakhnODZsSWNrVDhPQ1JZOXB5VDVRc1drNmgxNnJ5cVg3WFAzMG5pYUdU?=
 =?utf-8?B?MWV3dFd1bEo0bHNNaVIzc3RaZVh0TFNRb0ZtbjZ4Nm5HWlJZWTNJczU4M2JV?=
 =?utf-8?B?VUVobWlMTGJzTmlVek05V0ZEVEl2MG42RXkxaW52U1VCaEVFeTJsQ0x2TklT?=
 =?utf-8?B?QzMxWHo3WnNaYXlWNkhTWExVWHRkU1FtNEpveDlIM3FVUkJzSjdWUjNaeUJF?=
 =?utf-8?B?N2hmTjJKak8yZDZ3UVVEVUF0RmU5cFlhKzIvRHBCczJQUTJONVh6YkdONmNE?=
 =?utf-8?B?U3JXSUNHNnVYY3RQOWY4WERtRmM5Vm9jc3dUNGpzVG00RXJ5VU1EWWNaSHlU?=
 =?utf-8?B?bmJPMHoyQlcvMHBrd1YvTHpZanhFRGJlODJyNS91eHR3VDdpbFhDZlhaOFIw?=
 =?utf-8?B?d0NLSlAwMlUvYUlSQWlTMlpuZnRlUVNsRkZyVHpFaGdSQWJDUmRFeURrTjR6?=
 =?utf-8?B?THJWazZLWUQ5T3hWYlovTTh0SERJTWJ4UmN6dmVsZ3U2eFAxTndEbmpkYkU5?=
 =?utf-8?B?N05wMkVlNFcvc0dJcWV6dDdwUU1GVm1pREQvRS9ISCtsNERxNm5tWGowN2Jq?=
 =?utf-8?B?TEcrdlQrYnRqdWFac1BmM2lLUUVtNnpxZUFCcmZxNW1ZeFRWRGpncEZkak54?=
 =?utf-8?B?cXJTbi9yZFAvcngzcFB3OW4zanFvMUxTR3JDcUg3TjlhQzVPSTU2QUdjQUs2?=
 =?utf-8?B?ZWVRcGdwSVBWM1pSd2ZFKzJBaG5FcGh4b1RwZWxkMkxSQUpTU0t0SmN4K0dp?=
 =?utf-8?B?ZXBvaGd6aWd3M3FpVW9jT1FIbUpubUltM0kzWnQwQ1pOaWQ1RlNTQUFsUE1N?=
 =?utf-8?B?ZjFoQ2pLaXp1UUtrdlBKRzcwMXMxZlpwK3NXMTdhU3VGKzZqV0tJb1pxYnZH?=
 =?utf-8?B?RTliaHFzcmZRNDBiMTN3NGNlTWp5K3VKdUVyOE1Ldi94TEF0aHJ0ZWtMVHNY?=
 =?utf-8?Q?KE3qBBAa6ELRukj5AE7FD1ecIEQItuQE9v7U9NqdaHM2/?=
X-MS-Exchange-AntiSpam-MessageData-1: Cahwkg+X2o7rBg==
X-Exchange-RoutingPolicyChecked:
	yfNJcz74Un1wsdFcIDsB13ZRYCptAWPA7h6jkWhU3HyCTqBA3kJXQ50fJm1xk8T/f3Meqqoo0GuNScLvKvrExxIW+Ev6FhA391EeHfZ5xYYlT2Ri4kmj7W2nwBYsto9LTpDz44ryO0Z0k3iuZPRz18uxgycf0pkNCFx4Cs5YEpIuJ05keKzRCMPzOq3Dnz7BmfdpixdJxRL0cJAkP9RzbYJpEi4UTyF4VeO8vsr/qrpdvtpvzx56y/HDWVOrDsOJTsijpvLWReGTEXPhg7mtTyMCCBpurQnwTz3B59aYjk1p3DtmvV7PaS2oheTEW2V947zc4IIdNkfJz7P/MHAGyg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2UHs9jWV3QFKVEnZ9MlfKWx0zHRHHWJBLK5cgH0Gx+UL414Tp1xDIEPHntVRv7ADLl+/a0hgkYE+/MY56vs6HsqE6JJZrkx6HKArG8Q05gem89AXV1VWPW4M+Y2oSrV676mvhet8WKGgFSOt088iqiDiaucjW5nlL8JLQL9JQfrO4by4AI5/U4OzlPsZX4WbtmqbRusbOKXItiYMTit7csn+XNVe3FYVEk+dj9DCQsp6fZNQTXoDXgKD1bVCn0AeLpUNJNDq2+VILr1QgOyUsV5V3tdWbza88VbT7puAmPPU0qsKFbNTRkK90OB/aWIzgn1SjIdy8KEHU3Rrnh1Co0icuM9E7ctcH3QEhDWzpoNwRf9I0zEXeKmRYgfZBwWg3+Qqfz2DVe2fuVg+YA4Swih8+tR23S2cslXZsFuhqk1IdqR5Zvttr43soqEhHa5zGGlr3bFpNmx+cpFJmRNGLJoktmnN6Kxhulrw6F/0TxovEUVB1aKH1JhiVxRsdwM5y1Iqco+xwePqZrBYn48ofd3wLnD/waiPodW/K9XHfSldWqkhtAvjdlyOULQMXLGTl4gLdRKny4+Vk4nFjcMLg7aIi/9sBVsh6tx2oxajF9gHxRAQeZNQRVbwXsYA+16D
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b27953-5217-4c09-07b6-08df33f8bf59
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:05:56.5831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9B4c/+HU96rYVz0i08l9Vwqhhwzd2zcL1pL2sSH7BiuTZ/YIDgYqvbVVVGRsG8SyyzdRTXOIf0pCqSDtJl5siYC/Lk85Or8yT0EOBkhzCGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7867

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshrin@wdc.com>

