Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792562509;
	b=h6ql68xvGFbUS88qTV0Kf1oHkby5CddXRLbkKNgqRvUkEqz/gPF6dQe/Ln2ojvGBKats
	 hgtOIlaELakxczK8Id8O+8BKLiXo8zTZVmfM5XfxbWhPiKo+blXRQ2ENtJYW9E7HEdB35
	 yz7Cuel8dr8P8dyjRKiVO5WZKo1kMQJhXnj98p4wjjvhFPq81ptgcmQ/UgZqbxnTSzE5y
	 VcpE/6pApXvKzxaHQYQPbOHBfsyXmYI/YThOD5CIh2//sgR+iANuQRMKr9MfZ0I05HeTF
	 Agplv5yvEj5MfDOcFo5MYJRc8KdKFs58eETCENhyzqwvtmEJ9R7C2kQUk2p6+ZqX9NA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562509;
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
	b=RgBUfr8wjhdt33ig4/KbH++PwR1Cvd5pRydWxpfRMRyfQXnMd3RK2EnTagJGZuk8FA8f
	 hFthc61u+HbUbnGFI+pVrXiLlRm9OP78myvX4/kmoDVsgjUYExF9nyKdkJSLJ4uA8oA8Q
	 Ltx/ChreIyLFw2JZWmrXBnUadbegfKUaeTPBjrZb5Ni4iQoxWx/0JAy+EipNoOFKmrry/
	 qoi+QfF/BI6qdpoGlU1HODXYgachxZc5JQSSAH2WIxr5jyRhHKYuJFtcWKp74dxgUwUIF
	 b0p3sQHMH37PoE3mktH1gG7ubVAexo/TeiIoJEz/JzuIGexkCL9oqsXS2o16tFpwC8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Wmfv0Bxh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=O+VL3rGT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3601B606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 06:01:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3601B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Wmfv0Bxh;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=O+VL3rGT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792562509; x=1824098509;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=Wmfv0BxhNTKVhs+R1mn5z4FbBwdQQBncuCvk1ywF29g3wyyLneLcT4Di
   /YQ+d6RBURg//EpUi9EKFrYKW98AjRdbKRPkq9VM8Vu8EPxW3TBioBV5V
   qwM++6k97FfVp+bf5TlniG+K9UToDNcbTfqEW8YAVLTyEqO7cEix9IlFU
   8EKvf4ZPJe8YEiij6TLzMCytdmobRcSgtHCNYffQQc0uFDxCofPw9LrSg
   U5PXmcaGEumL2kFj2kVjzSA50X+LxHoOD3WPTJOdfRdq9aCsvQZWeCsF6
   G8ztJprvuu1DEw+n1yu+sRFjAcc6lexvqsrL7yia0rArwU4XQ2mmQhpbO
   g==;
X-CSE-ConnectionGUID: z7PmWus3ToS9lX+kYpg4sA==
X-CSE-MsgGUID: XCYX2cEOTzu1J5VGERcnbA==
X-IronPort-AV: E=Sophos;i="6.27,169,1786982400"; 
   d="scan'208";a="158513560"
Received: from mail-westus2azon11012055.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.55])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 14:01:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kavvx3THRJPKKFgQzkvrxJxBocmai5eYuoKJIlmibcaM7SxN5y2LSqGG3IrL0nMrrab4Lh2Hnf6IHZzgSL7i7+fjXCH9pyEvs5XXViNzHu94mnhl/LLSwln6Xp4y4l7JgHAjTov5zDUDQyJTGDuB83E5KlkGI89zWO2h+Yq+cgZB82a3cVSpUdyLaPbEOBRoLVXWbxIEXVqtHuw+SYiKfz+9CaZzfV4wbTgSyRwXnywa6c1R1HCJ7tBwwmTMwYgBGgeB+vB/9AcPMcgYpZFLQwHLM+j0dhuJ7d3vXb/+UxooeqIkOXvs+Fk3znTioUe5oK3XW7C0YVekLCafyllP/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=l0mcyagYNXyQB8nAM7tiOOv9jgEIajRPy9gmQe+7AbdsqcYAqPNthJWvnkIgxVrJRU5Zjr88cIRMVk8baAYkaAc1qlDTAElX5ZkmMYs6F8ronE86Xy/Gqwa3brFlIi4L2KsSX84pGBAfvQFTrS0s3P2UWD+qJMVUiwQNCvwd2n9QnyJbBCygc7JT6iA3vj8DlCmsiW/Xmg2SpfQVZkExIWAyr7wGn15JIyw+PzEdHwq35uvIVc4XNuPZDOQuiePzeIYPj5AioZHGrF+aok14kEHe0M+Er2KNVyNEBvzObZuRVSnG65NZCq3LkujRPMKXBeLtmsySQn60CGQDP8sYZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=O+VL3rGTW8j1O7RfH1uxJhxKcXQ35DLY58jaCMZ5GGAWm+i1ccAjKsMlp+iWyuBMnQ6EXgqHxVxg12QnvL+CBg7r8bk/ZSHPoSDZKpzSaD8/U4l9EZGNzBGo4sJCWMibac0KIiXfkmCEBSddbUH0jGbmG13mZO3zIqTgicbxhLE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY1PR04MB9564.namprd04.prod.outlook.com (2603:10b6:a03:5b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 06:01:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 06:01:46 +0000
Message-ID: <596273e1-6f3d-4a56-9ebd-786c3aeb38da@wdc.com>
Date: Wed, 21 Oct 2026 08:01:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] btrfs: convert volumes.c and block-group.c to use
 map->stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792553748.git.wqu@suse.com>
 <53faf6acf12afafe6479423fd702dcdb75cad0cc.1792553748.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <53faf6acf12afafe6479423fd702dcdb75cad0cc.1792553748.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0192.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY1PR04MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: 54c4f820-6c7c-47d0-441b-08df2f38c9b8
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|376014|19092799006|23010399003|1800799024|4143699003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 Li7nhbBYz0AbCt8o9Bql9qxE+AgYU45nyaooQF+Mws1SLhhtgWbUcRZS7svrsiaadzraaUvzNV43Qj0mU/4qt6SyCzbRvdTxh/Zt6LFaaAYr+tMDuxjMhQ6z9q9MEvrKWfmaYF0Z88i4iuwwP/pS6rsaDXnxt9DETlwKBoQywye99Eclep4gXl2ZxDurgGZscoUuaBD8iebj9lT3ljTVXNE39sTppvFjrmKeG77oaRzciHyQhOTzsiQaR6XHqxLQgY8vxgmz4ks11GHNPG6uSaWxA2knBNhIuDaUr9K5KF/lkymO5K6WItQnaTAEVPYB/1Ref8NFB7iNExLrPgF2/N8xaDiNGNiJeAk3T60wefH5RiAsExr3dNwmjgE6B9nzBWXYpg9IlVkemB3uLccjunDO9Oh2cQUt5VAQaG4jB2QrLD9T2fgPNVMjxUfGI4ukGV9F9A6rUohlXFLXKa8Nxs/2KWcGWbmO0yxxUTczHWYLcOSk6eSPCon1vJc7FWbrHR7/4fmTk6PlXJ9571ppx7qa7LlqYwYxgP+k5hlo6ZZlwq1t50wbDj1hIcZoracrVbb94tMj902oGllEX9vk/JWGweUtKrSEmCklkAncSQeCgCFoie+shgCSeksXBj+0hDbsA1yNc1dqitY1yBhBf0qliKsEt8MXaz7mt8F+9T8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(19092799006)(23010399003)(1800799024)(4143699003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QWRSOXh6YkhOanFXSXU1cEFzNVlrcDlRQ2FMZFlyU0xiWSt0ZVdRZXVkTVVj?=
 =?utf-8?B?alY4ZDJ2U2k2WUVRK3QxZU9yNnVTSnAvWlY5bGcrZzE4RlUvRVdCaWZYQit1?=
 =?utf-8?B?TktHbDJHR25LNDFOZmFrYlg2N2ZnRXdMMSt6Wlg0T0s3N29VbjVoREVXeUhW?=
 =?utf-8?B?b3ZMMGk5U2ttZ2FqeGpYWkhXa25xUVVwbDFNSTVna29sd1FvMDVzUWE1QkdL?=
 =?utf-8?B?a2o5ajV6cXJQWW1ianA1QnFVck9TaUVRVXZLSVRoTU5xS2RrTk45WC83eEx4?=
 =?utf-8?B?dFpGWWVvUnBwMEZQdlZreEdkaGNONEJETkx1QjJqWXFYVHhuUWtnb2ZvNEpR?=
 =?utf-8?B?ek91UmxGblYyak5tdmsyMEJyTVhoK0QreWduMzZSWUdxQ3FXNkhMZjc5YVlP?=
 =?utf-8?B?VEV2NFFxR2NFdVU2RDBJd0ZvUElpTndCQjFoa2pELzI0US9GS0RLd3VkOVkz?=
 =?utf-8?B?Z01oWmNKb2svMjVWMUg1dVhUdGc5QkJhMCtiRE9TMlkvYkpBZTc3cSt1Rzho?=
 =?utf-8?B?NU5KdE44ZmhpQy9oRE5BZXZPbGZrY3BJb0pjYmFrbnJ2VlhIUkVXNHNoU0lh?=
 =?utf-8?B?anljSllGUHNRRUx5THBrNFQvb2ZHczhRRzBzRnFtYnlZbUdDWC96cXp2b3ZK?=
 =?utf-8?B?dFduaFBiTXEwa1hackFNTUN6RmhQL203c3Y5TzQvbjJVYVZKZjJTMW5qUDR5?=
 =?utf-8?B?aDFscHZXeWEyazNITG4yRG1qbERiamxjbTVNTFgrWk81TDlrNmZUQ21NT0hI?=
 =?utf-8?B?MHJZdU5DSTFxSUd2K3V0WklnVFlORlhmcEQ2cFkxNTFyTm9FWE9xeS9hUU55?=
 =?utf-8?B?WWdXcjdHSVNOekhSbVNXWDVPNkVQRHllWFRORUZiUEgrK2ZvNWxjazlIUEpK?=
 =?utf-8?B?blovMVZySS9PU3JxK1pvNDVUdW4yREIwb3g5c0VEdkh3TjVGMXRRa2ZRU2VZ?=
 =?utf-8?B?enROQmR6RnkxeURHSWxyZDIwQm13U21lSCthaFlPN1FRY1JpN01wa3RzVlFL?=
 =?utf-8?B?a3U2QXF1OUxSUU1VZzJQVFR0NU1zdnd3VXJPcHhZNDE3RjIrQzJiSldyWmNZ?=
 =?utf-8?B?Wk9DWVBXQXNxVDNpRG9XRTJPb0I2UlJZSzlDblUwUzZqNnJubEQrT3BUTDdo?=
 =?utf-8?B?U3E4ZUx4cTVvK0tPa21jd0dyWW1pRzhVbWdtdEJUd2YyL2IyVUo2L1J3eWxs?=
 =?utf-8?B?QnlRdzZUS3hTeGV5ekk0VlMrYkpDZDV0Y3MxbjhycUhZZTFkRXRlckV0amFD?=
 =?utf-8?B?NlBvWEtTTWhRRXR2bVlHZmY2eE1FTXg2dGxWMS91dDhZcHpVNUxoYTVxS093?=
 =?utf-8?B?TkNYSDYzcjJ1SHNpT3NCMDFLTXlMWGl5U08vazFNQ1d2WkFNbWVHeU8rSDBU?=
 =?utf-8?B?YlBuK1A3MXhSWmw3TE1sVTBxeDNueTFzOU9zV0N0YUJVWERXa3dkZ3RCQjNI?=
 =?utf-8?B?aTg5bFRTZDVkenZXbDJINDgzUmp4dGY5MnpWRlowQytsOU9LS29na0U4MTB4?=
 =?utf-8?B?UGtpYmhJWHNXLzZEY00yaHo5ZGlwN0w1S0R4YkFPUkVhdysyU1pkT2FOdXpB?=
 =?utf-8?B?WStIV2pSQWNRRmViMFFuN0RhTXRTV09NWHlXb0tCdmZ1OHQrZUo4bkV4dnFp?=
 =?utf-8?B?c3BEeUpHdmxOZmozOXBod1M2UHppOFNDOVdZN3VjYUVhdkVoVFhmWFQweS9P?=
 =?utf-8?B?d0NtNUg2N0NDUDgwSDVpRXp6aHB0M2tGa3RvbXF0d3Z3SHVQZ0FWK3RaY1Za?=
 =?utf-8?B?OUZpemMvbTRNNkl0eEtucGJEMHdDdUhGM3d3VGJEYlA2bzExVnp1Y29vL3Rp?=
 =?utf-8?B?YVE3YnhUWFQrcXhKZDdKck5JODNidkpESDdtZ2YwQkdRQ1ZQdWJZUy92cXc3?=
 =?utf-8?B?OUp4MU9BQjU1RC81Z2dKak5QRTAxZkl1M00rMEw4Nm04VTJVVExiMHJhUjRW?=
 =?utf-8?B?eUJZUFhQZ1pqUW9pMFhhenYxWFN0bWNJdld4OFg4S25XaFUzbUhBdDBmbkh1?=
 =?utf-8?B?bk1TdnBHMHFGOEQ0MGp6T04wTSt2MmF6MTJydFVwS2plK1Q0WlUrMS8wb0M5?=
 =?utf-8?B?MjErcDVncGp6WWw5RHJlbEtnUm5ESlMwL1RRSHZYUUd3VkdDQWJWVCtCYTly?=
 =?utf-8?B?cm5STHVvcmhjM3RFY2hMbnYzVHpFYStxVzFUeHNRSUZGcW9BTmZTUjVmWHY3?=
 =?utf-8?B?TEVNdWtBS0R3MmJFV0lTZndpMmliZkFHcXZnY1JNWVMxbXBZUnB3U2RFMUNS?=
 =?utf-8?B?OGQ4aTVBRnovUmMvWEh6TW13Zk1Ud3N6dHhlRStaSWRqblE2QjlEVkpwNmNP?=
 =?utf-8?B?WUp6L2UxV3BFZitlTTZpVlN1QUh1dkw4SjQwZzE1VldGbVJWKzNsY2x2dHFH?=
 =?utf-8?Q?0rqspP3GUMRUqPKaWrv6RLO4iFrtkyO16gYBW50ilNcoi?=
X-MS-Exchange-AntiSpam-MessageData-1: jNqOdc3fYu3F7KIsxc/cRCkRtoSdJBWd+44=
X-Exchange-RoutingPolicyChecked:
	GwZV/hHcBUGUsxUr6K2UceKPXjelx/fXfzwpbXSfzTqnA+4edBlzlhdAlGJayobyAlYVB+1im2IQYHhLmi2SCb4ujGgtg2l5Ciu2bSIMyPY6p/v4WKNjaPpb7K/0DKe9FYYzVlYh3qROSbr36ITtnNVP59SZIzlAedcYJo2zt/svh+YLJRNhbycPaRm+hnvYKdK5FtBBAIRKMYkDr/CFGIWigymcFvsBtOGNDnmHWWovTB5FqiKLwqeaO2RqOIn861bnXXOAlB5r0xUfNSGB+4hoV3+vWbV9FXZgPnfhN+JCWI+zQe7ORTH62OWHyUXDg+kItnX+1TFyBantuz4zpw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	owe2F2bkXFXKYzWNRdkF1uDU5WT3NJnlOqb8A5UVxsI0tZ0OdApClvNidKsv3SMo6nxFvtnvXiIdJcfGXWq0s+Tgrzk7mf3exmW6MO7zB7TzhyREb7xzwBqbzJT4Ga90EV91QiZv4AcAlptcfwWSjZHsCWl7XHQGUyeo7yA1Hbg+POUfPjorqaYfMVTw/no5NZ51LAB9fPTq0OdFTis/tjCg6BnLuHowVV9p0K6u8OYtgdvV+c5Tyc9lKDlo9y1YeRUEW/Mg/MWoYeiOX+hw+lRFCOv3V6DxBwUlhOp9YuPxYo0dsi7jVJmyNIJSrsNvUMtJqqnBS9J8Oan/pZleGaLJN5bJ/arRgj29h0Jf5Mb8lk/Fjt6+qz/AWPdsVw63Xz5cGYqMu0HWqFHZgdQlnwSpwC0142qX1XigpDb+ld3Iwf0PTQRq9TaQIVUuZvrgaVAud5o80Ee1fezXOujhUUPIlLzN9QM1zwcA3BqawE/ZlJlCk7Nw/UO92kOW7UNCdV2Xp/SkjGobVHeg2vOOJngx4GTZcj/8+95xOeTmKWJ3gq2wbzI8egvY9VsOQ8OL19Bb6QEbjP1dXV1gzLczUor9pNTyyyI896cysdAvqUxMriNmu9suylCYl98Q1dyj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c4f820-6c7c-47d0-441b-08df2f38c9b8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 06:01:45.9835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4/y1mLZRpo9O9VtfUna8eOZ/rJhdbHnT942bl2rQD5kYY4rvDJyK4pONcHtTG3Mcjb465p4GjyNuwNjhPM3wGJK+Trrhxer+8r7w2qrX+1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9564

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
