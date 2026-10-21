Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792562420;
	b=KcTpeP4K6l5mtqQ0+aRkUlA9O1PCaNJqiTy1p4W0Xzahf/onUJOqW5Kp7B+iuJl7DfAj
	 f3L2zK4pe5A/Mpu8nn7E2uYj11JebiEw44+uc+IZ31CUFYr8EXTmrPSa7OA/u0DbXvUj/
	 uvi0xNA1AyzUAs9ysxBSbArHUtdhUPJa5vPxQ30sXG5eQjhxs+kzRz3DqnRdugAVuj+lE
	 /1q5DqUHUb0eTyyUC+HdUGbYUwbi7/MzANMh6md4JRAtol1fm1RKxpQiCgiQ4xzzAkMOT
	 m+E0f8FMHG65u0s/a592FCzzvc9E6F9oE9zz44z6ZMNJHLo5ApiyvgD9ALRYpNClK9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562420;
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
	b=1o+sPIcOZs8FWI8m+Le5wclqroTtZaezeLl2DkhoJJ13lNaRR3TVfSWzhTYkag1MpeFb
	 iZCpGxnvznI+fYogQUWfTJ58LfKgCW/QKVDfXSK8mTSmfTxq1S1EISA9a08D1khtFysvK
	 CpqYLQllpIsDiUOHdiYYwlVmH2dOQHQT/tMGm21L7iK44BYDGK8wmlYIh6ykoZkiPJWo6
	 ex2GI9Uh1McGqZFaeGV1fqtyBpwOjuRQwnOxWC4THSlYfYom6wNn6blKE/UYMEGLj+Bku
	 o0r6BfIhNuWYQnJglXB9mjWgqHIpHp9eAG6OXtcRCR1356L55ruVFRJC5tfeQYezAUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=M2Q7GxWl;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uYQfvciJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94D3606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 06:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B94D3606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=M2Q7GxWl;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uYQfvciJ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792562419; x=1824098419;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=M2Q7GxWldA5CE+kvf559bTk9LyaMHKAsmHokzlWTLR3pUXACp9qL9cZQ
   xFkAQu1jyPFW/UApBHTv07RJYmj5fw4TsMONFjs/IsvFDBhiupaycsAGV
   nLR6AHgVAsTvmFaFtDxri+TwIGMoFf4HVoy8YEbMP2RZblhSPqI+3fdok
   qWLxzOxaFx+pJjjjBsXhg+NPR2reEIa/EhWdw3PSvewqvoIlsZxshKegh
   sLZyvkebgXSu4WfZbGZniRE0GK5t/38mU/UIyPvQVn4k/mMRYaK0BS+3c
   /N3VzKuE1ZWZyPvi9U3HHK2R4/B70VcXzrv5NAiVIjA68b99qXF5irypV
   Q==;
X-CSE-ConnectionGUID: qZF1xX2PT3289M4s5f48gQ==
X-CSE-MsgGUID: cc7siGCxT7OPsXZ7+QC8Jg==
X-IronPort-AV: E=Sophos;i="6.27,169,1786982400"; 
   d="scan'208";a="158513381"
Received: from mail-eastus2azon11011062.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.62])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 14:00:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Exi3IvVSNaZWAxV10lfgGC7ultAYRE2ghzuZrwZwHuUTlJ1XXhd/QSp19pfFf7/tbk3X4hmUpj37L0e3KpgioadXE4pVspQXn37qeWQqAlRtmHOoOF9v4j8HWPqG4bha4XsAvJ/XF8UKhPx1qanqaRKG9IEHR7lq8YI36RbZ5O5TPiM0ibBBX6MhYobAD/rkUY3C/A3UKSrSaDNyqPDazn+QsMoyc2lEtqhRyl4PjOiSN6lWVnpKfPUimYK1++wBWj+M8Cfgb+vF8SpsFV9+owxgR6vBTW9SDJvcNxlVL/B2rj3bWyJ3twD+3WbaZ0BckFJWp3y0JKY7fR5Z59iXNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=mR9dRaYAlpuNY76VWFyZ3JsGxgZHs/GjVb6ShJfk0TV1xTdwdgzrBcVWxEY8fGCXieR9Tvdum36haI9/aO0OKMw3+yrCX3UXWiEeWzCbvezvumP7Ky2ZFHrgx3X9SqA/k2yQ/9uaHJRQhxVeWY0DW8/APue0+YWiyrBg5cidMW9kmMO99VLAOXt+L+35UsLLgHsdR8bI9byKzDYBUae28dfLVI913uaBmuT84PpcssrOTsudSp4szL9SJZj1UdBtFHvxAGjIjg+upFh3emM6uJaBYz3dWpIx5VGqZidszOhQDxu/Wfgj+/Fx0TYieyaevyL8fk4LxA3r/3xVcM8aag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=uYQfvciJQ0tDCw4l6ovcbb8AFkZsMryDkJnHhbEMfdKnJ7nKVpAUEA9NAbdP3xNBrRbF/XPqtnN8SnEyjl0akRwyu9BGnpelbJ0mr993Y80F32rgQ07+17ptlrA14Q4pWwJQzCrFQdgCBOuzx98F5qPsqX7RPgieNQEZMHIh04Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9485.namprd04.prod.outlook.com (2603:10b6:8:1fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 06:00:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 06:00:15 +0000
Message-ID: <98f9d0ef-f1ea-46ee-b7de-04ca39a3d973@wdc.com>
Date: Wed, 21 Oct 2026 08:00:10 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] btrfs: add a new 'stripe_len' parameter to
 btrfs_stripe_nr_to_offset()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792553748.git.wqu@suse.com>
 <5c4aca2692c0971f6a28ff25d72ef0e591ecf51f.1792553748.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <5c4aca2692c0971f6a28ff25d72ef0e591ecf51f.1792553748.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0286.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9485:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f3b369-766c-4e71-21f0-08df2f3893a3
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 FMxnjOOqDhztol14DyQBIiWyHZJVz4R/+B/Rka0IrSKSTjqt/Q8zSCjDMrz1cqH6q1aB0PEf7cvP+iJbAq56up9v7hnGQRvtiOikpB4xvImYqzEmbkMW+NeJn/q9lWf4+xRhlHHXKD8aD7GDB7W8oRExmI6Rk+n7p2twXSW553XBCZh4HnDEcWc3QpYcuhaMn+yBhewtsYfJ+EB7J5/mYjorwIy5wpzrF/hRG6KUHS8p8APRu8NfaX8/z2ISmaj1OdBAHea1cT/BLpOiyZ5RyWEFzJdNUYLT+khLSWXoFo/diP9xzeDjzCRaMQx3sAQ+SKZtT+EJAggkpsN2ujPDzd7gic33u65E/uHqkQ9yDFDgzZ9XFtMTXr5lMl8cyZJGLofKVLR40OS+MitSZeVebElEA8WQfmgPpinkS+9HESCkVg223KRFdEv+iaRV6IZ/Aisc3HjzmLYfWDZsBGE5U8l69Ii8DPpXg1AsUTZvJ1WIcTvYjxQbEPMCmVut8rpDyf2TwOMGnqtjueF9ZS6CrbwhtYW/W2hVntBq4+UqOc3FuWVL8xieGd5tTeQkAFNo3DpthoGBoFYVM+Jdk/QPFBKf4m1idcZRpQcpV1lI+hQJ/u9yyDPGq+HGBYDLSvwOWUSSaSEywJMrVA3CUgPleGCYkNy30QfYfeb1+eFRgrc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cU1Jak94aHM0Z2ZhQVpHbklyVDJJN3RHQzgyQVIyYklscUlrS1JjRnIrcFQv?=
 =?utf-8?B?aytXVUEyNkZtWXdabmljdW16SS9uTXZIRFhBZHRPZmo4aGhyRXFhcFlBV3Fp?=
 =?utf-8?B?UHNlTzZtYWV2d0tvMG1mMElmVFA1OWdVNHdkM3gybGFxcXZRY01EV3RTbDc5?=
 =?utf-8?B?N0NqV0NOTVJ3alVkM1hlakQ5MGdLMCtlb3cvMHdlSVV1Z1lXM1l2NlFNK3JY?=
 =?utf-8?B?bGhCZVR5cC8ya2dBMTlOZW9TZlZTYWVnNWZTRmVHUHFaRkRWN3JWWlVGVkEx?=
 =?utf-8?B?eGo0SXN3VXk2Q09DOUx3YnB6Q01rWkVPV05wcEd0VXdKclpEM0JxM0FnZUVB?=
 =?utf-8?B?QmNzQ2R4eEw5L2VkUWRtT2N5VzJDdDBXUmxhWVJNVzlqS0VWMUtkelBkNisz?=
 =?utf-8?B?aCszTkhWNWk1OHVPVU1PQjFobmJGVThQcjhCM3cyMFJwMnJXWXRZOTZDZU56?=
 =?utf-8?B?dEo0WHdWMjRDWFl6V3dER3ZIWHVVTC83cW5CcGhzWE9RVm90ZUFHOFA0UXBE?=
 =?utf-8?B?Tjh2NWxxU1hoanRDdnJhNWo3QnM3NG4ybStMY2dSNE53cUhZdEw3TExGa3NF?=
 =?utf-8?B?ek5ZWGhzc3VhejlMTGM4emUxbG4zUmZWVUdseVRNU1BaRFkzN0R2OGlRRVJN?=
 =?utf-8?B?bG1FLzVJODgxMWVDR1Y0T1BVN0oxRlhna2Y2dW1QZjc0aG4vUE5qR1JLVTVF?=
 =?utf-8?B?Rnk0RDlEU0hWMTVFYjM3UmllL3d0NjlnWDNseFoyUWtMOHgrREovWFV5SSsx?=
 =?utf-8?B?T3BXOVBpYTEvTGZNSFBOWVNJMFVMODMyLzZBOFBGdUFJS3IwS0NLeEdmY1lC?=
 =?utf-8?B?d2FUNHZTdmQ3dlVMTGtZTWo4SjZ4eGlEdW04aUtMZ05XR24rcXFxbFI5T1ll?=
 =?utf-8?B?ajNBakNtRnBScytLL1ljSnhzdG81ei9DRnZJQ3gzWi9mcFFpRlZSM0oveUg4?=
 =?utf-8?B?b0YwRzkyQXVwcTdsR0lhOTJlUWdIS1M0MVVxMzdmdVJJWVlTZDdIdFVNOXRq?=
 =?utf-8?B?QWh2U0RyRWxuVExldW16ZElpWGVjRE56aS9qVG5KVy9SYXB4RWZVRWhOMjdL?=
 =?utf-8?B?OHFSalNOZ0NkV0Z4TjEreEkxOFdwdUMwQ3RITWJ5QzBlaWZwNDB0QUd2cEJ4?=
 =?utf-8?B?VlF1aWtvQmFlMkt3dlBPNlFhRlcrR2ExWmN0TUxMK2Z3Z3JUUmhtSFFTc05V?=
 =?utf-8?B?RzFaaVp0ZXgvbDZneFBQbHcxbWxkZlZna2gzQXFXTXBUR1lzOVJ2NUlXUlNl?=
 =?utf-8?B?eEpTV09tcEVWbG1ydkgwc0l4V0hHQ3NMeWR5WGMwTjNVUUVpaEppRW5jM2c3?=
 =?utf-8?B?R2tUZ2kxdnVzWStsSmVSQm00KzczZzdqUEF5WjR0eUFFREl0WCtPYzJDbmNP?=
 =?utf-8?B?YkFoVXhOUjVoYm5MMlpDMWdpVHBPSnlIR1lMUFBuOVB5L3lNUFlCbzFzQjdL?=
 =?utf-8?B?SXU5S25mcGFmVnNxdmdNYmFnRmdQM3dNbHFMbEx2dXRoU0h2dm12K2xpd29R?=
 =?utf-8?B?UDFkTG5JODhERjYzVmM2c2ZRL3hQdzVKa3I0RVVYYUYrWkVCVFJLekVtZ1BR?=
 =?utf-8?B?NnZxM1lCc3dEVmRFZzZUMDdDdGVvdm9iZ211VWsyUWtHdjBVaXdxUUNSazZu?=
 =?utf-8?B?SE9LRGhBdVBGclFpTm80WXZHd1VZUVdjL0F3TjdIeTlOUkhmNU5FMVJreDhG?=
 =?utf-8?B?UlNUdWdNY1hvYWN5UWN2cXRUaFptSDVKcVlVZUFuVU9ncHZDOUFHNHFhYUFQ?=
 =?utf-8?B?aFpwa1pmaXFlZVYvQjNOQjFQemtzN0RMeDJsbFlPMVUyTHhRb0Z3NHI2Nm9J?=
 =?utf-8?B?K3RUQnZETXVtNkpoUUhpYll6eXdTNzM3QjBnS09xazNkckRJWVFmTTR2eHFi?=
 =?utf-8?B?MTRoY1FqcWlQbWJTTnFhL0hmYytiV2liVmdHSnkzdWJrTlBFZmtGWlVYSFln?=
 =?utf-8?B?UVk0M3gramc5bWpERFlZY2UyWDdhZ0dWaXBhYmYwdGdGMDRRQTZvcmRaYnQv?=
 =?utf-8?B?bGltb1ljbVAvbUFiYWZmRkxoRXhtRXh6bGhDYW5yOGpqZUV1RGdIeHhlUy9H?=
 =?utf-8?B?b0swd28vZXA1QTlJWEZ3bEFrLytLUFlaNUthRE42a296YnNBL24wRytvVG1m?=
 =?utf-8?B?T1Y3UzZGYmdWVVJxdzJTbGJQMVlTbzU2T0Y2NjQ0aWlIS29yQlY3OVNRLysy?=
 =?utf-8?B?aVdLTmNvUWZqN0NUQk9NT1grVG5odkl3dk5tWTVQSkJPODFJODBHcFM5eWxU?=
 =?utf-8?B?bm9XN1BWWWVaQTB0aGI1QzRCYVpxdkpOb1dsODkyeWtOSy84dy9pYmNZbDBl?=
 =?utf-8?B?MnJrYytyK24wWGsrSWNsa1RXMFB0NFVDdE9iTWduWFVTMjViMnhoTFM5TmQx?=
 =?utf-8?Q?Svvqqfw/k8FssHRi68qYBoRjBJvMdD4K3/6kMzc06vQFs?=
X-MS-Exchange-AntiSpam-MessageData-1: QLBNThUX5RXzGeVSEw9rc3AAgmjfuOKrX+M=
X-Exchange-RoutingPolicyChecked:
	BpRLyF7NQOYF6hkP93wbY/9aq9jQrCsSbECl0zde7lLExfYMIKDBy4gZfxuvfqfkgXmlbThGE/VCT2uwDX03sqlMV39D8VpGDq670iFpcR/HXpNx5BYrIJVFsBYpNhClYkK2OVW+YRo+uiKWYz941AP1KWwjkyuzYq4cpoyjmW4JMlRPo0ln43o1/7Xsd+JHnXGMDNQT2cUDqLpzJdvndBo+q4aeO+yyCKYG0Jouf7Ju8Hv4j4Tv6yGtERAFyeZ6x89s1MG1rVAOK0X7gTQK5rO8WAPTldj159sIoxV4QpnOgEOQrgOf3FMM5U2mPkrD/R9YA/i3e+kjlfWLH+6QuA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u6xU8m3C3Wd8lDJRdANbHaq3s+aNWntqvqzaUyqd8VV7itYr1CBjDnqOhiKGoK6kJW2Y1QEVpXIYj5v6iXGFmYm/8ZZtzy1ot7VFj+4YmzsEXxMy/ol/27hn5MBEJUrSy6K/UNKR3IKI8/VCgbgVBruXxSKyXsQh1pFupUZilqhCTIAs6j6xM+mz0TDlNqgn0bV8JpxKrPmdK2LRAm5bRmdEwFUjCcnP5450TIIFQJXl3rULue/tKoJ6BB5eQAGr44AZXwWAPYAEIUFwW5Z36W2szfsbXeBU7YatzIf5RpbuhO9vYVtDjp9BopLNO6rJJzqkHpebCHQU8vX2PXH7AEuc6sQlHJjQclQWmWIVqtdt/bUO0q0A0eB7fE92jcbGR5oR0IuovwIvfY7ARUZALJLdrPWTelgeqVAbQykV9k0bkKaT6OOa9Q0ZSwqj69tq9ctS6K5lEggrhmwWzfg5Qf+di6QPABT9Pkzkkw8SOMQagACvxwdBx0pfFypb9WAuPgLy9xfjFrToe/G7jB2WxAfL+Xh4Ri4DADK8cpAn+s3MepCvf2bYP+jl5GxbWaPoohZ0FZYK1T8nowFOH0UMgea1Z73Y+EVqUVZum+oYL6sE2PVP/6TC7XUFoObSOo06
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f3b369-766c-4e71-21f0-08df2f3893a3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 06:00:15.2815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDVqw1enb6Wu4/hd0tQti5lFnAafDmg+uOlKqt+J/7SVfG9vrzlLfCShpZRhRQfzz65gxmPwSJ10n6/QUA6WX9qw52ojgc/w2moHMTnjX0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9485

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
