Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792567142;
	b=d2gHQv8ipex36s8I1bgw6vOMHC2lP2HxLRXwqNCRZnb6vYo4THhzqal7ZmfJ1cr7NO5W
	 N/u2ty6/YLFgc9XWUx2xqAwKvoJnMzpth4ausJsyWvakwm4f434NQr+OUFPNk3gORoyhx
	 jZvzxlazbXkm2jIpXmLV0D2sSVdJ9/soNeLoG1dZZWHHASkbunVoETwpoiFzXOGTELXqK
	 O8mzGLDD1zIYBOORCeGArIWberHd9nQkUC16T3d5b0JgXrw4zV/mvOsckGJ3/AwYi5QEd
	 uprOvBxcrdKUWC7JBBflinpawj3PGG7EIqw2NfRZgYamK3fLPWN2GyvIBBdnmX/fERQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792567142;
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
	bh=KS+s0Wyuutw3LTpoEwZaMz65XJ/Genvq85uBZDOyePo=;
	b=hcHfaFE4wvzD2Fzhmwj8Ag12xlhawnhMZ/lKewS9lSXxB9L93Eok4EhREiNQeofrUW2w
	 90F2EYFjNx5qgfVkkQA5DLXiWdi3guJlLmUwxgRDnSVkK0QWPdifOKk7tjYN7X/P9auVl
	 suPkFokcP/q3zVX30qM3LDRzDljUcRwJBp8sgkIWPneSS9gOca2DdlCP+lw5suxY2RJCV
	 Uaied/rUvBjNJDFn2F7VrMzaFeK6yfZFV5lU7wwvVVImRv1Un9SLv/f+qI85kZW2wphsJ
	 ri5v0skJpWbU45ICSQmbWeqXTShZ9ghoHHkA0xjSwRmQ2YnZQ1c0mPnl7+hdQlYNHcg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=llgQwx6d;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OfKa42zz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDC2606A31B
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 07:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DDC2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=llgQwx6d;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OfKa42zz
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792567148; x=1824103148;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oyXTdyokcoSDxCFjL9/BXt4MDVqEaNM3vxC61cqEvgg=;
  b=llgQwx6d7B+C/JCXGQhMK3sljlDCJ716FqAZeIDdjhxOhevY+GS9kEu7
   iv03AobyZMepbGJnyqafWe5nKWKyHAj7mmqb7WKL/l1vz/n6P7ZXvG7Vm
   MP/fpElqrfZ/zmmPwOQFDewPVASONtpW3qbDXiGszCQ74mJYu9c36Ocu2
   0IP8mrExgjEeybBj4ofo1REwxoZ7Tx6WZqqEryEavD8aoYScER642wBLu
   ksAzcBI0/D3p4/qr4osEX8aSx3j6vhd9lCSVLqXC6AmkO2dJD8KKLUeyl
   7JAWcdCmznJvHrnTCNnkgz760FHiWPSPOVBFRD46AMoXY2JkrtxDf1dYn
   A==;
X-CSE-ConnectionGUID: KafM96ngQmW3EbYu9VYGFA==
X-CSE-MsgGUID: aiwh8oL0QLGRcs07y4bNSA==
X-IronPort-AV: E=Sophos;i="6.27,169,1786982400"; 
   d="scan'208";a="158518789"
Received: from mail-westus2azon11010010.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.10])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 15:19:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQ+g4IIMEUSWwdLuiKS1nTJzF0tApZf2VaTxnmuuAFNpwcR3xMsH0ewy361SxgCX8CDp6B1AIvzjYDlzdK6qKoB8qp87472mqmQheOTdT75BtQuUAUChuXnzPqbE7LmF+czkiQqkDGdOPXu2ffmj0G3CqC7UR68et7LoJ+axKPwPAt/slaGpxqVS0dY8A87MRyPC9KNW2UNjo/6Ph3Zb/wfw6EG6OTGmGUrDykCO2gLNwXXoKRC6e8sGs2apoy317W3f2zjKruEtxwdyQI0lbvK3bS+8o+amaTziPsefJExlLD7iQgWuOGevRo992ojTqNEW6Vqm8xAmT/qbfzYcmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KS+s0Wyuutw3LTpoEwZaMz65XJ/Genvq85uBZDOyePo=;
 b=lwC2aiGA/EARQZNbTjVJ4D3CoO/f5Z318K2bgipOjzU0HOvSzDpusEWr6BQIW4KL1kREwaOzh9ihIXdkwHi5DjRdCsOigbKm8580EKA2IWyIbmzL5uhkcGUta1FJj+lq+IOdQ6yDRjxyrClNUByqjd2QYogw8isefVCwki/R55VCy2NgaTLeo3WNVcbT0E7RTn0jSmFbu6Ni1bc882oQvs4DcPMM00qBf6gZVLFVP17cpETMWqgK7D1fYw6rh7wERVVV8xzp4aMS7ks4o6BM1a07lhUWPemT7oohOEDCerWjLXGGayvpLlc1+dMJJJMd6CI5t+HEzcZJZsxSfxAMZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KS+s0Wyuutw3LTpoEwZaMz65XJ/Genvq85uBZDOyePo=;
 b=OfKa42zzAmLtgf8VNNun7+gf9gJU/HsyFlewGMPZ8l8xrKx6ZfFqmy7639k3Dz7hDBnVnmTinSB+lFmOaLgCYqLJf1t0mKI62M/Tcz5+siucxcMnMSiUEtuYopnVu6KJRZ9b8G5ujPd/INNXX3RUAokjXGeeqs9P5AdotZA9kTA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7198.namprd04.prod.outlook.com (2603:10b6:a03:297::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 07:18:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 07:18:59 +0000
Message-ID: <73892aae-3631-43bb-9121-d2c10305557a@wdc.com>
Date: Wed, 21 Oct 2026 09:18:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] btrfs: zoned: only change active zone counter on
 successful (de)activation
To: Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
 <20261002073715.2191177-2-johannes.thumshirn@wdc.com>
 <CAPjX3Fc37rdefgPUS1pwWMK9gMUEeoydc++TPZH3jKvGWDYVMQ@mail.gmail.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAPjX3Fc37rdefgPUS1pwWMK9gMUEeoydc++TPZH3jKvGWDYVMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b032da2-34c1-4587-2a64-08df2f439347
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|19092799006|23010399003|4143699003|56012099006|11063799006|261009223027099003|22082099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zmUyiC8mO757fk8uk9jMALD8PWSa9wLEbgKz632Glc2H8PrTxD4WbWvHDtP71/VWy0C065nx8LEichOMptETI0qdndVFl6+hu+cD1kmSAz+WzhhDnu5Y9rsRUXwrgEPlXiNylbWdNjJmmwHYYXRrlwclOWvVQPoF1yZ1mk5M8Up2WUWzyWgB0JgvGqNEDQVw/YMD8uEwssICYwTILhfnzxW5NkbQbCiOcbIWq71eLoNEiJn7CD+n9MX6XZKBJw95WCOaVST+/zwp4YGTQDR9k5VntOxHrJY9p9qouSTqdip8eTK5AhpEk+8mWkWwC2SUnUNbVb4KUNE9UEJC4Z+4g269DeZWis5gtBPsGjHZngkGGQZTR753AlJelOBPHXxKO4OFlh4hidOPKYiU/iXYTJlkL6tyGDWOIhoV3VGD+lD4AyaM8dXe+xsEefcaxlx12NBo34lSa4xwtR6yQaX+FUNRcJWs/YNflkW3ruEl+Rr+g4kfVUWQ1YvpRaC2YIfyXIuKApOR4304TSBdyrO7TF5R8X0rvT0lAf2QCZz3OK2+vn9gLtjlfY/+YTYg3/a2fO3fv0V4ESoSaPgWgTAtfWbziLJ5JUkA5wv+pZZxqmFkxyFLuyGx/LAMaJ1FBXuJZUHDImm3Z+uvr+kw0b3J8fa67FKUHvYRBekiVfL8aQY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(19092799006)(23010399003)(4143699003)(56012099006)(11063799006)(261009223027099003)(22082099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVVMVS85NFJMeDFydlFQOXZuNmY5QWNMbFZaTUIvV2V4MmdOMVpia0o3OGoz?=
 =?utf-8?B?ZTZMOVhVcWp3YlZBdDNVQlFFMi9MVDhTT1B3RHZpaC9tNzNGdWxSOTZIbVVz?=
 =?utf-8?B?c282Zk5yTk5waFlydnE3K3dpb3RYR3BKclNJSEpwaHd2THBNa1lFdVNvaDk1?=
 =?utf-8?B?TGVQQ3RoQW9VS0Q3SDJKdnA0U2dXamIyeGZIeVNxaTgyUFFtNGR1V2NJNHpD?=
 =?utf-8?B?bXdvSzJJVEp5VUlWRHJXRU92azNwSGJtRXdFVktzdVhuUjNVUFYwSjhxUk9j?=
 =?utf-8?B?RUsrcHZaSm1ud2cvZU5FNDZpbSsrMURMM3U0dFZ5dVpNYm1kbUtmdTJkeDR1?=
 =?utf-8?B?djhuZjU1TG1ReUZBL3ZlcldEV1NZYXQrSytwWUJya0FCSVJWalZaaHJkek53?=
 =?utf-8?B?M3FjR0RCK3pwRTRraTJqRlFqOUpyMHMxZmJLSk9UMG9WU3A5QkFwSW9pZWZQ?=
 =?utf-8?B?d1hRd1g1cFMxQmcxNjI0dENLRVJ0ZWNnNmxaUjdrdnIxTVJMdDVwajZMeHBK?=
 =?utf-8?B?NElFQnBvOW9WRC81MUMyRTZ6a1BrOUkxaU9IOGk1Yng1OVNIdFRuVm5yNG4z?=
 =?utf-8?B?Ly9VclNPNmdRbFBLbU8zTVl5bG5LelVaRWV1VlZHOXVZTG51MDdqVU5VYXMw?=
 =?utf-8?B?eFV5aksrc2hvREM1My96eG1Cb0U4MzFPQVAvQlQ1WFNLVDVmaWJkaG9JdDFU?=
 =?utf-8?B?MytVZDF1K1F2UVVlWU5MK2JUOEtiQWRWQ2ZnZ1RaazF2cTl6N2d6RFhQbk9j?=
 =?utf-8?B?aFBTdEU1cnBGd09OaWlJZDluLy9CMUNJVm5wMVBqUU1hL2VHQ1BOSHlXaWRE?=
 =?utf-8?B?Z3FPNk9xbWhRNU5kalZjRk5lN2FoOVVUZkRldkZxc0t1b29xRWdKUlh1RlV4?=
 =?utf-8?B?MFlkVDY1alZWcmlqd3pmaXdOSUV6TzBmdEdJcEE5OU1wUFZyUnhkSXoyN2RW?=
 =?utf-8?B?dU45RmxTVzRFaDVqMlNsOHo1WFpEZ3R0TWlJb1pmUUIwdHFmcnlhdkFyYXNw?=
 =?utf-8?B?enFQVEZHSDlLNUd2ZzdFZ0lPSlhmblo0NnFkRHFMNC9na2c5Zm9UVnpTbm9r?=
 =?utf-8?B?NEd3ZW1kYUx0T3FzZ2R3QXRCby9VTHJaU1ZGc1RabjBSVnY3akVNeElxcG03?=
 =?utf-8?B?NGpBV1lmV2d3S2pqc2VrSHlYRm5PSEZUQnBUWU4wcUFHbCtHVmxDVy9Ncm94?=
 =?utf-8?B?T1B3YjJzMTFZWDZTNTRhV201NHFhbU94SElaUTE0cllsdkdPUDFSNDZOYU9h?=
 =?utf-8?B?MzlSMUZKOWFoRENjN1E1eERuUkI5VWtLaEo5Mm1YaDBVcy9wRjhDUlhBWWlS?=
 =?utf-8?B?T041bFB4N1BtbHQrK3YyMDh5WmRUY2N1T2g2QmhXY0V0VVRwRTRIOWJRTk5S?=
 =?utf-8?B?K2JHL3RuVmJlVWdoT3dnd05jSVV1TDFMV2V2cysrQkF2QmpNR0RZNVJ0ZFEz?=
 =?utf-8?B?c1c0SlJsRlIwWlJvbXpSY2xiVXRTaS93OFl2SC9YTXpwYVhSSWlCZHdZckVK?=
 =?utf-8?B?ZWZ5MG5vc2p6R08wYjg4TjJkZDNqQStBZmpxUElnYmlLQ1E2UmpkR04zSklt?=
 =?utf-8?B?REZiN2tISmFuL1dENmg3RW9sOUFDU3Rlalg4VWhwOVNBYktFQVR2ZmpzK0VF?=
 =?utf-8?B?WXl5YTQxQ2w1aUROU2NZcUFzSDBXZHZPbkR2ZG56SE1WVnB3Q0VJellDcWpr?=
 =?utf-8?B?b0RqK2hPY0RVNGJmT1RrMFJNZHlFZlk4ZXJYRTRnVDBqazhaWlRGd0o4Rjho?=
 =?utf-8?B?M3FzM0hJSm54eEU0TnZOdFNlR1Q4QStoRkpqVy84K1BqdkhVaGp0ZnovMll6?=
 =?utf-8?B?bmZhLzdOUW93STJZSy9RTFAzVk10TTV5QVVCVVZ3MFNxM0VaODhCMHc4T1ph?=
 =?utf-8?B?eXV3cXRuSndmdTJmV3M2OXF2bXhUaFRsSjhhdDA0NkxQbE9UNkdhZmhrWFdp?=
 =?utf-8?B?VEoxZFZxU0xYMnFJdlkyV3F1SXpZQjF6N2tUN294QXBDU1A0T2NqVkxYbU9T?=
 =?utf-8?B?VHpub0IvQ1o4YTVNdVVjOEZhcElrNVBtMmFOU3hhWkMxN3N0dDNMWWRMM1BL?=
 =?utf-8?B?dnhybDBVcGpLVjhITkpQQ1M0WXNUVFoxS0kyRHVTYk9xQmMvVXpIOHFvdXJh?=
 =?utf-8?B?dFMzR3V1Ny9DQWY3ei9FNHhBSTNTL0h1eDIvdGMzL0U1YlpOZmdBUVJtVllE?=
 =?utf-8?B?VWxYVkdDK3RQQncvYVRFMEU3UXFxdEpUNUtabSttY0x3QTZTOS9RZFBGV3F5?=
 =?utf-8?B?bXVINlZkaUpDOE9mR1dsUW9qQVEzbG9LaGp0Q283RDJhTDd6VFF0K1dBOU9N?=
 =?utf-8?B?eHpWVmRJdTJkZVJEbHlwNXBLam93OTRvR0lHa2ROQjdCdkd4Nkx1R05Ib0Mr?=
 =?utf-8?Q?4UpCpkCexhKEb2wAfVgovydgqk4SEBr8TtIzL4+UrQBml?=
X-MS-Exchange-AntiSpam-MessageData-1: 84KMPmI9MYJZPMi4mXGzJfllJckWwaTrg1o=
X-Exchange-RoutingPolicyChecked:
	SD3sbns8my7zdc2QEVpsag/IQglbBwz4RRwcGtRL7G1OXHhbdEhsThgu9RNjVeotuF6Rr+eefC4FcxZB+XwJNE55YFZrh4w3fRUpTOvcn5MbuiuTmIUgk6dfuaDZ7uCX+szLo1s+Fgy2SEssuEs2cESFL3zLpG6dPvnzfUtSnEiK+aXuSZnOO1xWRZDPl9Bnihj/iwvMyHqpQZOyb+LEM/oq7k+WDXufUNiFmZ8bA//oyJug+ZdbaY37PobJgLJE6IUMgF7Q4uWem8ApTO8DJVQWeZL/VsgR73Rg4qlyOtgNo05V6N8yc0P44PsQJBFcbSsT6eOFzZOqLVXvuHZ8Ew==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2YFTWh9o+vvZpdlo5/iRA6sL3w2vJHcIni+ycwoZxhFwHiIjMBqe6/uMZdpZ0oaSqGLdTxEN//YmsDVItIB+T0Yg3RWTpIAfTMkav7eH3cxGlPjJ60BHXQF2Y/8bzLv/n5E6ioib0rqDxokOdTCeSVO6xgLiXTbywJdstOZiS18kfd8oJ4eGOb01XI3+nOkHrB9L/d8TrqMCYmcWLLb/GO7MFaFLlLWZcI3WmU81JgZ7YvgB1Wyq2fnfH5i1h0L9nLyb1a1oScaJr7lWcvoW9OhpNtcdVc2M4zSxsybbbFq1wU88Bfvhghyp14FmMorm9h+8V0vHikpcXj/XucRqgPf9VmsIxK1PMF1HS+dvRD8d21G2VfBWvnDzAW6oUmE0D2r7aRyYXzq1P9SR06kxCUtT1V4Ihja0pGtwIhZCRgMYKIoCM3byUm1TPykEO174v9+Le6NxhrTWU7zKdYxyfrogBF0tmqt/A14OCNKWaGy8KR6A5pL85ri1zYoCe1qNcDL1fQm4A8mDbgntuLTR4eABXbkOeImYdAPU2nOmc5CRCOdhupBKJulasV61a3DJFcr2LXrkr5OBQ6R6yOs3g8Loi9I0bGLb5aCMYQgONC67p0o34P6/ejpRZam8qDDF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b032da2-34c1-4587-2a64-08df2f439347
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 07:18:59.2666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7/fhW5C8gahhlYPv2t+me+FkK0KJJQ0epiVOItOrfCehRkeFqr1anzvjI2H4RLsl38gh3JvjLHDi2ZgMmiVaEx5FMxK29tYy68DPU2rDSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7198

On 20.10.26 14:50, Daniel Vacek wrote:
>> -static void btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
>> +static bool btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
>>   {
>>          struct btrfs_zoned_device_info *zone_info = device->zone_info;
>>          unsigned int zno = (pos >> zone_info->zone_size_shift);
>>
>> +
> A stray line?

Oops, fixed
