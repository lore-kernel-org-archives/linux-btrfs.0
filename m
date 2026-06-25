Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C7CFC0A;
	Thu, 25 Jun 2026 06:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782370032; cv=fail; b=sSpTmRmsrz5d4hommgRZk2j/SJ3Ke0GtyOMGYeEjXtVGWTi66+EYwcft1ZkrMBKPLtK1MXeRVFmBOGH+qchpsu7rj+bRuAkmAGynxdjgCCLrk5SQS/8RM55/oqAum6wv00MzOlL1O/HPMWvgUJByUjWdTwZoDeLm2z1PHgcra2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782370032; c=relaxed/simple;
	bh=h45K5TZ7XLVwIcZJWCPg3nSGnyYNnaOe7wpSRdbuZd4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ChssJfQN6blAdu0O+XP3ZSUNRAsNYLNwZ8SNOg5thl7Tv+gxcJlUoVrhdhQ/PAB07c6HwtwM+9jfE0Thu/+11C6+w7n77z7wqAWZlCJrgHBjUI5R3LybJRHZnWjhwPiBDd7/DU6Qyf2t7coNH+81hseZjffyyUhnwr6NEjALsNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=GJYSvVL9; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="GJYSvVL9"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65P571Hl471081;
	Wed, 24 Jun 2026 23:47:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=6Esbkfsnm9eLJ8j6FV6o2W8GHqjZx8/UGJJk4zE9mW0=; b=
	GJYSvVL9H1stZP1F5IrZtNfgH3yHKpxQW7JkRThyoJ5GzvwONtXiaPH6GhsAiAu5
	mKocUl1LyMVqaMq4rnQYZrJkqQDIdKByJcAZYtRLAgxBsLdFJwWMMwfm5EY05i3T
	F3Se8b1wZC5YrkGTIRygb8qnUWAU0l4V5ljGG+wPVVoNOpA8X31pe9x6SaHuQ6Or
	K/7UuJTU1wn9avP8ljWcEViXSNE1u4akOS/XgsqIjLNpKR54FDiErb8CWX088A+6
	gg9VUy5hfdrPlocJYzgvFuk01ojBEfSgwzfY8gn69wFGiCLu8uk372+06Gc5Z2ok
	t/IZlYxPbc8F54HE7+/Icw==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011049.outbound.protection.outlook.com [52.101.62.49])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f0sybg8yd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 24 Jun 2026 23:47:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dQH67SI6+Yf8Um0RGdJDOuT95RMwIe/ccjgBmxrrw9Nk9pqg2+NiHzxLlDAnK1byJ6A40YIcFHknT85YDhLVXu+LjJvxVx3MtiqI//zAVR200/q24sLpTopRbMvMnmhrpaBqzuLFtGHGcBgQhi5Q2/ZLWlOaTXLt2cHaokcl7MA2FEIaYMsfSLAEdVKd4sPzFnd+GEoh3BlSx5hXUlJB1LYLiP2lgUQVBaU3H00p07p3cyxGDFjnPBP8XiDVqvSBIym4O6xEsHZwAWIWg+tZPL8NXgv+euWDgoP7gOqiRseYxO7VTltcvl2NRfSucikdyCw02RzTYgtF93Dj/M4LUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Esbkfsnm9eLJ8j6FV6o2W8GHqjZx8/UGJJk4zE9mW0=;
 b=fKR73WkDs4oUYyA4CrxRtV35Nnj3APmAPVZozQJ0jI92c7laTh7d/N2vH4F20bg3n463gjkXnDqMJXiVVUy/AB06YBO/jDtZmeEKAlHB27Xf/bosAGY6BEX53sc0FrUFTOXKVCvEEKlrDds/elSgCZkpCmELqFcAa6hKgkXjGx+fWvUsd9lJx/UXqO6qUE9DPA0a1BAFW7iroWMwoNv0om3ZRlu9GLqKnst2igCWH97q1eLXmCVwBfSvuXl567iuxf5z78YpwN0fOPweNKVGePoZn2iOm+CLivnQMXJRmJ2WNtyqqwBEm0IzURYQkcvsWnlI8He0Qcz9NojPtesy5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by DS7PR11MB9473.namprd11.prod.outlook.com (2603:10b6:8:258::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Thu, 25 Jun
 2026 06:47:01 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0159.007; Thu, 25 Jun 2026
 06:47:01 +0000
Message-ID: <f192c12e-135f-4f98-a1a0-df2470eb8a86@windriver.com>
Date: Thu, 25 Jun 2026 14:46:54 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for ordered extents before buffered write
 fallback in direct IO
To: Qu Wenruo <wqu@suse.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260625021456.724803-1-yun.zhou@windriver.com>
 <aa009e0d-a629-44ed-bb68-202ff2dc5063@suse.com>
 <c2afdc0e-6e63-42b8-9a8a-fc77d2ab7383@suse.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <c2afdc0e-6e63-42b8-9a8a-fc77d2ab7383@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: JH0PR01CA0014.apcprd01.prod.exchangelabs.com
 (2603:1096:990:56::18) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|DS7PR11MB9473:EE_
X-MS-Office365-Filtering-Correlation-Id: 8899c1e5-6963-4f6c-4195-08ded2858f7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|56012099006|11063799006|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Uk629CSJ3G1rYvzvE7dSQ0lVpTIj3BPHS7tqUa0VvdOh3gV4GX3Y2HuMbrYI6LSrwVcyHs+m6E8B4jxO2dKNzVYThIX9zLK7/VruiOnzL+Mor2Pq9/0MtETjorGuGRa6gcPgeSPKb4SFxQ5x8BC9W8mO5njlcyMUbsZ+atCVEZn30RsYy3gf15pKTBLTR9xtu3OqX31yUn1PKozevepd7xv8K+BkbCdzf0pkEbFZc28NG4QoIbV+bp0BHF7+sI44/K7/Yj91upCBXX6CtJ35lt3eYyIuIRXGLreUoDpsDzWoXy49s1vmDGT2Gvd8rfq+ZTDBdyGKFyLlv8glDwcFfjTgkLJkc4iJGz/QmdNkJnVcp+q8BgdLrJrbZsz5v7InMxgmAUbzvp6O3Kk2CBxrYcX7Kv9R/x01m9d+aPJY1sjmEVxk+7h0zPWyYVj9c1K1sF1TSy4qBGIx3uYCN0miJlf35cRobF/JgcLtJUeJUTWqy+4sKlZ0avorF256r/0qi6p+Fq3iNdr9DNEtHBHrYjb4yRvR/1lfs8MDQ9+fFSetlMVgylXn21tQfPEwrDxiwRTq4VNeQF9sFGYnWtHZO5QN7Hi7Vwkc2dsr3lNTGdd0LIo0zuRMnUQq9ArBbD+6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(56012099006)(11063799006)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFNsYjdFTGRQc0xwRzFqT0xKTnplTVVQdWQwNGtzNGM2dVZxUDhuWWo0SjEv?=
 =?utf-8?B?eXRqUUN3emw3a3NpeVNhRGpZTHFYR1ozWTNTY2lKOHc0L3hzWThrR3hPZDFj?=
 =?utf-8?B?clV0bU1ERmp3MTRFYXpyNit3TTdTY0RtQS9PWis3djNDdzc3cVlvbXZicWRE?=
 =?utf-8?B?c2JlSzIxTExpakZBZ1loM0lIc1EvSFc2amRnMkswUWtMdGtPaHBqNkh0ckxP?=
 =?utf-8?B?RTRzRVZldXM0MmdiZnk1ZXFHa2JLMHROeFc0QVhuYi93ZzJ1WjdreDNyelV4?=
 =?utf-8?B?eTNTeS80ZE9ZYmhVajkxc2VNQkN4bDFtK3Q0eDVUdTBrMlVnOXhkdTRodFNC?=
 =?utf-8?B?eExMZFEzbWpiT1NmUGtWTnRvWkU3SGFLR1YzVlJHbzhYYVViYW1FekphV0lP?=
 =?utf-8?B?WU0zWlpxZ0NKcDJTSDVjUXowL2EyS25VaFMyOXo0MmVCSHlEU2FReVUrYnlE?=
 =?utf-8?B?OUE0aVlkclVobTlyeEQ3STBjL1RudlZsUzZ2V0ovd2pydEZ4VDc1d1RhMjFO?=
 =?utf-8?B?aXkveHhPU2Ewc3BLdGV3OENZYm8yZk1ZZFJDZkk0b3NjTFhlalpGYjJxTWU2?=
 =?utf-8?B?TlRiYVdsUTVLZGFIVERJREhuQ1RxTmdNb3BVV1J1czVvcGtaMjdTakVCRDdQ?=
 =?utf-8?B?MG5UUHVZOHJBdmpJYU9yNnd6WVFjOXpKUE9Xb0hsVWVnVGpYcldvcDBGS3p3?=
 =?utf-8?B?UlAzb04rL0g0eFFXWERzTWRzN3p2aU1mRTFNR0pielZSL3ZJdVAzR3lvOEtq?=
 =?utf-8?B?aU9WTHhRVklRMWVXaHMxMjQ1YWJCMFkzM2U4b3M1QnBGcVE1a1ZPazJhMXo4?=
 =?utf-8?B?QUN3WVdWTjZLcEtUOHI1c0hpSmRsVWFxcndOVWtVdEk0N1JoakRNdmZKY1Mx?=
 =?utf-8?B?ejBaNm4zS1hWLzBiVlFLQ1dlWUlPUUNoWWdvbFJMUGZRWERzbmtRTllkeHVu?=
 =?utf-8?B?Ykd0T3M0bDFnS3B4SXpxQ2VJaWxOMTl6WlBTNGJOWnFwYTdUb3ZGbTNkb0Yz?=
 =?utf-8?B?d1pwQ0ZWdEtJcGY2VTdDNmo5OFhEczVKUmFXV2lWTC9vZnUrbTViamlwTDB2?=
 =?utf-8?B?QWluVnY2dzJzanh5SGdud2JXQmpsZXlwNkR0b3FsSkhhZ29LaWZNeE1hR0hJ?=
 =?utf-8?B?T2NOanR4K21JS1JGalNOYlJheVlWdjRXcnd1OUZWSkxybUFPM0cxSDJ0M09o?=
 =?utf-8?B?UkZJc2UreXlnTDRqZEl2Rm1SdzZVVDgyOXlWVmN6Yi9aUCt5RVRHb1hiWlVY?=
 =?utf-8?B?QmZ1ZmI1TUZkR1R1LzZkVzVKcm4xQk91b3BnUlVBaG8vQTVjaTAvbU9NVTlB?=
 =?utf-8?B?MTF3eHgyZkRrSFNPU0t4dVJZNGJjbmdDZzVHOVhnN3B1WFppOGhyMGFYQUQw?=
 =?utf-8?B?SlJLWVFDdUtreHdsdjBMR01tLzExRTRFaWJhMVMwdWhyMWJpMTNUS0VScWpJ?=
 =?utf-8?B?NGtKUUU3akp0c1pFcmtaejBQMGJEWDhwcDJBY1lYdWRNRjhsb3AvemsreUNT?=
 =?utf-8?B?YzlQaXJUbFErejJQNklvdmFYN1BJWkVxVnRwQWlsZFA4YTdYVHdNazArRGpF?=
 =?utf-8?B?UllGS2tLYzUyMCs1aEZVeFJSaGF3ZXhWMUVVZ1l1SlpHanJRMzd4Mk8yQlJQ?=
 =?utf-8?B?UERpcGJsei9oU0xVMmdoSERmOElNNEQ0eSt4c2U4am52SEZOS3JhTjVFd1Nw?=
 =?utf-8?B?T0JRNUNiK2pVZmcwNmpLSnBmYUR4ME5lZ2Q4eUJrbmRITGhaN0VuN3dYVzVr?=
 =?utf-8?B?YUFnd0xhOW55LzlhRVg2R2lVbTB2bG5vNlVUd0NoTEZkRmZYRVp5WktYLzhl?=
 =?utf-8?B?bkNkSU9oMTZqWHc3TFpINGxObzFSWXNWdjRNUDdwQmt1MzFKKzREN1B0S29E?=
 =?utf-8?B?Y3dDRXlPcDhJbDBYd2JXMTlGMGJ5WG8zUmRvZGZ6WmpSWGQ4UFNISHl2MndB?=
 =?utf-8?B?dkNPUGJxTnhrVzE4MytST2JuNmt3U09aVU51cnc4Q0lhTTlSQ09UUG1peXgr?=
 =?utf-8?B?TXNkL0d4V2E1bG5zbkd6Z3Q3VjY5c3psL1ljKzB4N0tVTjJEQWtIS3RaVHEw?=
 =?utf-8?B?akg0ZGRaVDJEMm93VVZYYXJjanI0M0VzOU5HaUh4YWs3amtoOTB5K2RvWXV0?=
 =?utf-8?B?eXFMWFM5MDB0d1ZJUnFTamtRM1lqU0hhMVR1RFdzT3VvN1NsazZsY0U0SnZy?=
 =?utf-8?B?bDVvcEt3NCtaTVhCRGVsWDBIMHFwRkZvY3gxSVd3MjZ1OHdFQWdyYW5tN2hk?=
 =?utf-8?B?SndCWi9pZG5mbklRVFBONHdWaklLZ094NDZ2UlBxdWgwZlhGZHdPSmdzaUJQ?=
 =?utf-8?B?a3JLeTZKdklkQy9aZFlNTnRUdnNKenluSmNQU1FFVXdVMW1tWktqUT09?=
X-Exchange-RoutingPolicyChecked:
	iJ0QlVbzL0USFlqeGpoI4FBQ672hVTvUTuhm+X0VIlnjT+Ox/lruq7TRqdvIFSWLRmlkQx61AVtoNoIoh8S3PaQCTeuA/NLahw41SwjLfKlvo5SK/bU0qOlwNgvQoixOCPWN6V6iNKY0GI7F4ycSkeTLCRODStT0GZ6/8F5K3jZnu3gycLGg3yvLRcfMRgRHav5w0aNe6njmxtT6XbZ5QGQE0wvgEfRG1d+5/dJcavUoTWjb8FOxbxRmZn70OUQqC0p0MyHqIk6YQNFB6hSq3yZuj0PCJ7gwMoGWutv8L/1xfTqnh/HYD2C4dzBJXet4aa1w6FbLiWeEuke5n7hNcQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8899c1e5-6963-4f6c-4195-08ded2858f7e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 06:47:01.4443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZHfwTy12jX1UdYV8ZiWgPktCPDKFv4XewlgBYPijUtOIlMRB24vKPH+I03wGH627XPfDTnkivZvdeAFwooVYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9473
X-Proofpoint-GUID: b6I1JPJqDHl2Y4MihgK5kpD4ojAAxgNy
X-Proofpoint-ORIG-GUID: b6I1JPJqDHl2Y4MihgK5kpD4ojAAxgNy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDA1NyBTYWx0ZWRfXzRKuRu96JIMk
 BV61SOjZMGSPXG6nK0jVbLN7qITy6/QV7QDngqIUVm+xQR9W+rXSWwuhCzRHTLlAVpvE///5J4m
 NSinpdGizlNnja8FUzlhyyJE0JglGo+w9QpE731+kdNblv1UYtDs8AwxcX+OPZDyKkATSneEGzs
 IGsHkeziX/4o4+9rLRvDq8/5SkkUaBUa/i9f7kSPF0cojGL2fSuLOCjUzimEyf/VTke9JpHQ8hG
 GfNo/saH1seJpdxO+y6SI35DbwLAd8uw9Uwrb2Wf+PT3XLWIsPIh3qg5SRJJ02g5yYcmkLY5n+3
 VlXRFmGnwy7MPC6QCROUE4MvKkFhwAxQ17BjgaX1PCRfduji19pe8Y54Hs1I+NIGSNycRT1wmsn
 M7PKaxRm3VSAzxOlux3b/AC/w1vyJo0XUEcptWkT6yrDLF7Ce5dUzyvam6E69Zi6dWsY3t8cJ52
 GR2uxs13tGpFT3aJbsg==
X-Authority-Analysis: v=2.4 cv=MpFiLWae c=1 sm=1 tr=0 ts=6a3ccee8 cx=c_pps
 a=M+4CHf8fKMkYOwSYEMZyZQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=LZGUViC0SG0KoVoaqnYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDA1NyBTYWx0ZWRfX/s3bx8j0fgB2
 9RLa6AvjRbxCKs5RaMnacxY2KbtryZmu4lKtpyA/VEsuheWBlhJhchkheA/Apfc8vfMwORQ64St
 6pbBN3/gBQq62GCCq5IfvIAG5vTeoaXD1kGwZSxMbg0bAi/N1h2H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 adultscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606250057



On 6/25/26 13:17, Qu Wenruo wrote:
> 
> 在 2026/6/25 14:43, Qu Wenruo 写道:
>>
>>
>> 在 2026/6/25 11:44, Yun Zhou 写道:
>>> When btrfs_direct_write() falls back to buffered IO after a failed DIO
>>> attempt, it may race with the asynchronous completion of DIO ordered
>>> extents.  This leads to a BUG_ON in insert_ordered_extent() due to
>>> overlapping ordered extents in the per-inode rb-tree.
>>>
>>> The race sequence is:
>>>   1. DIO creates an ordered extent via btrfs_dio_iomap_begin()
>>>   2. Page fault occurs (nofault=true), no bio is submitted (submitted=0)
>>>   3. btrfs_dio_iomap_end() truncates and finishes the OE asynchronously
>>>      via btrfs_finish_ordered_extent() which queues work
>>>   4. iomap returns 0, retry logic faults in pages and retries DIO
>>>   5. Second DIO attempt also fails, code reaches buffered: label
>>>   6. btrfs_buffered_write() dirties pages for the same range
>>
>> btrfs_buffered_write()
>> |- copy_one_range()
>>     |- lock_and_cleanup_extent_if_needed()
>>        |- btrfs_start_ordered_extent()
>>
>> So your explanation doesn't makes sense. As if there is the direct IO oe
>> remaining, we will wait for that OE to complete.
>>
>> There is still something missing.
>>
>>>   7. btrfs_fdatawrite_range() triggers writeback
>>>   8. run_delalloc_nocow() -> fallback_to_cow() -> cow_file_range()
>>>      tries to insert a new ordered extent for the same file offset
>>>   9. The DIO ordered extent hasn't been removed from the rb-tree yet
>>>      (btrfs_finish_ordered_io running async in workqueue) -> BUG_ON
>>>
>>> Fix this by waiting for any pending ordered extents in the target range
>>> before starting the buffered write.
>>>
>>> Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
>>> Fixes: acf9ed3a6c00 ("btrfs: retry faulting in the pages after a zero
>>> sized short direct write")
> 
> And the fixes tag is also incorrect.
> 
> Without that commit, we will directly fallback to buffered write without
> retry faulting in the pages.
> 
> So by your explanation it will trigger the same problem, with or without
> that commit.

Yes, my previous analysis does seem inaccurate. Commit acf9ed3a6c00 (which
added retries) merely amplified the window for the issue to occur, but 
the problem has actually existed since ff66fe666233 ('btrfs: fix 
incorrect buffered IO fallback for append direct writes'), which 
introduced i_size revert on DIO short writes, causing 
lock_and_cleanup_extent_if_need() to skip the OE check (since start_pos 
 >= reverted i_size). I will correct the commit message and the Fixes 
tag in v2.

Thanks,
Yun
