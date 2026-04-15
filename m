Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFADD37648D;
	Wed, 15 Apr 2026 06:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776236042; cv=fail; b=JauO1XTZ0ztOlFXVSsBlvSCu4CHd6ofw9EHMVpMUMSbx5OoCgU5SaZl9vdLDZrAw/Jrif+/chns7YoD83eS3HzSFzCSNGgkl8e1XncIGVnCjKSVOUrm8ttClsBv6sUKt/krfG8BbkJBTxMgBe8gqeTSUMaXyITTO9E9O7sR6T0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776236042; c=relaxed/simple;
	bh=tiYWSEQZFurjNcUnSTnSkw5FRw77L5h3bBZYvBjfeaA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T9n0tDqC0AuI1/QskgN+Woi+yFjySTvvmBTYVR7hlpax9Brsxx2bcH8KZkiSV47wwkAa7N/SweF1HDV+ltqhKNIfSLXd9QXbWZ7OXMdg+rcR4K1K9I3WCdLurkcexAdsusEGoPuNDllE8oTBKZblalLDYcjAJO2YVjkyDFPN7bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UmLmCe3O; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TDVjY9vg; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UmLmCe3O";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TDVjY9vg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776236040; x=1807772040;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tiYWSEQZFurjNcUnSTnSkw5FRw77L5h3bBZYvBjfeaA=;
  b=UmLmCe3OQfB/8LWkUK3Dp2VaHG3LOfXsiSJLM3EaYFPogTbOu80NXGmB
   gfZ9HJUKiC4Jy5aep2OgJhtT//CFlds8LbqDOVs6wm6RBVdWuAcDMS5Sd
   Owof0QtQwXROobKZZRT6LOSsm9FkLmPEE+1pCL2xElMVSHOl/CTwyemtP
   wgdZcbn8gYPpcfx4x+tto1Tm2F6zqkCJmsjo9rKLAO2GPQ2u9UcYKnHii
   CHsTnswdj0YcooteBRNTa0u/gPp3h15/O8bQtTwSlwExyIqwLqpofddmx
   bP6mM0WG0Dnkiooo2G/Hsr6h6B9MmR94rqC2llsoOBoQnKBVahBctx9+k
   g==;
X-CSE-ConnectionGUID: lCjrMjO6S3m/hfecDgSF1g==
X-CSE-MsgGUID: 993wVRCTQFezRNhOR+yqKg==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="143445363"
Received: from mail-centralusazon11011042.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Apr 2026 14:53:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FXeRjXP5Ip0kTJfn7BiMwwsEJjWTiqpK+VNbsuo/P8GA5wylVxOltrChONHUzq8C5hw20a3FEsxeVYRUGKTZa/x68Jd9nAfQJn9V4HqMsEFXFwPmoBEQjSDvo++myilPdn2+Jmf2i1KW/8ZCn9IewJnxcacAIZF5ArX4cG/9xKkKbHgRl3UU9b1D6tHnMAzt0rPxpvQ33Hmt50RXLgmE04mAyBRfl7NrFTQNz9ojzkbspQK53jWTs8K7q6jcvzOIECGKnL6LqFZrrxxC3oSQW/gjZta23h89i4/eRPyEhJ5g0IHHmhXlw/ZEXbIX/zFugv9WD6akkD6XyKzaQu8FkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktPKCQJ27dImkGxMaFAMfr9MWXSgc2EfdNbyCEmoHXU=;
 b=FqqAozewvpXeoAuMZEKB3dbmXVFCEAn62l+ei5I2wSuNPDnYEFraAPPzUQrHY7bucMoRnpj7G6MZl5RYThROzEMl6z0e+9vUrNFIrl0ZPWPsVHTcpv4/6PZyBN83V+a0wHlOH4fGq2fCun2vtlPDtflm3ZZJS7mU4InUlnLfye3kMJalAhtBRMYY86vpTPoM6ls0PFY1n1Cz8XCKL8gi+VmajZ/PG5B465900FLH6SEGrgGn1Njcu4DeNsh5eTcYuaoUZSTyD4RTVRU4+ZVsUykr71UALXkKrkTgfH+vTvk6PJK7yhzPq68+HPyhHdo4ZArOMGFiLkhy3R333IGmFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktPKCQJ27dImkGxMaFAMfr9MWXSgc2EfdNbyCEmoHXU=;
 b=TDVjY9vgThCo8Y+RnClvpGNye2Olj1PiZbshNPIGc4MRcx2BT+9MpqPAmwXSzCw8vNWpuoCuR+8b4n8W7VsMdBykgsEGiaGqaAz3lE8D/MmEBHc+fUJ45nrUbuc2JcTaSwoQWGNEOa35Xkco4wUMpcdERm+C7tiHZVr9HcV9+8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by DM8PR04MB8070.namprd04.prod.outlook.com (2603:10b6:5:317::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 06:53:57 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 06:53:57 +0000
Message-ID: <fdabef27-ecaa-4b85-9a88-8a0514523b56@wdc.com>
Date: Wed, 15 Apr 2026 08:53:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] fstests: test premature ENOSPC in zoned garbage
 collection
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260414143341.167875-1-johannes.thumshirn@wdc.com>
 <20260415052203.GB26443@lst.de>
 <6cfca682-4f8b-49f9-ad16-21d90eb5f402@wdc.com>
 <20260415055629.GA27242@lst.de>
 <6a849834-75de-4007-8591-05ff9eda1932@wdc.com>
 <20260415062721.GA27874@lst.de>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260415062721.GA27874@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::6) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|DM8PR04MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: d35af162-a9de-4789-3340-08de9abbc3ff
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|19092799006|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8HNvWDSPRbAs234CTVCqjqgHvu/yHpa722JWDMX8zt2/cE28bMT1n2wri5JVc2u50N3729sEo+9hwNWsUPVk4rnqoXGRytviQqkZeq5UyzI2CpBFjEdzmTrAxAqzXlAaft51vOIgeDWVO/rXymvMXabK5mrITV39jJ4UWfP8gVDWmrvxd/TyPzF4ZFqs6yKwJHVE966UyKT7ZzB8+06tAI709t66hboNCA7yuQo9Ir8eJtNAvxaTJIL4RQKLukgg7FsgStTImJ8XzVnk4S8dczx3+2/vH1qYJRhaZoUfgPDT5aaf1mCrRgPcSspis2gXlNYKfiz+MjikLJg9AdkweTbDK/Vg2EIuM8u+Vwucz9Y4K+ALdHk6jy4gXUK/DJ0IlIJcnCQsmO1VOj33aL6wxoXFa//62RNRRrxT36NDbIy6zB+aJNYYRMeYHiypAd7/gNlhdZculXMrMc7cFk16XqeQezNYEfEHN9LPN9RaWimbAIiHdNppvV5Cgq4O3V4S20qmqe3xdwbSfa8a2vhi1ywTGN0HWGsb+H8NVZRng68r3v/o3kOJR3kWipqz7bAgO2jNtYZOW5hyFMZsZiq8KzxamUgrn62CnuArm24i4VWlsIqRAQbTOvZe0JFknQelOmhzn0ii+b5K9Q3ophJCZOUulGDTMn894JjOWVw7IBTOYliWPI7V0TRmTFcy1w6/u1TdP4aTlt/luw/gRgagOXjvzmXbqCRodZYTe4FsVSs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(19092799006)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXJROVE3bjhQaWZ5Z1pWdEw3c2pLNDBhZDRvUFhnK1dZRjVpWlNyeTJrNHdU?=
 =?utf-8?B?ZlNyK2t5VW1LM21Dd01GYnBoZlBxY1pCeEttdFhWaFZNU1JBMnRXS2wvREJX?=
 =?utf-8?B?WTI4ZmZSSUJkaDhSRFJJYWEwQ0lLR1VQVVV6Y0xnRURnME05THBjNG41SDNp?=
 =?utf-8?B?K2NrWmNjYUI4eGtQSHZ6VDFnNTVHWEJ5dFpxSzVaMEVRYXQzYkoyTENZMEt2?=
 =?utf-8?B?aUkxMkNQb1NZa2MrL3U1bkZnN2NCTGU0MXkvenhhbFdVY1FSbStQRmFmcG10?=
 =?utf-8?B?ZXdINGErRnFiSzlsYXovUG1VQjYvNUFNbmdTU3hRYUZZTEMvMWpza2twN1Rk?=
 =?utf-8?B?MHdwQVlabEFNVzdFQnNFbXVFWDQyQnpHaldraWEvYnN4ZDJJK1dKbC81d1pr?=
 =?utf-8?B?YmErNmZJNHhCMDg0b2VSWVZJOTFsek5UbFprYUladCtnUXVSTURyTEFzTDB6?=
 =?utf-8?B?b2VySzBDZnhIS2MrMDJNVkVsckR1TmQzVEdxcnJQN1FZdGVFR3JJdnZrcUxz?=
 =?utf-8?B?TWdKVEVUWnhPTkZ5c1FJOFhpUjRHeTdEakE2eHpkRmI4SlhoRlFSb1RhdFFz?=
 =?utf-8?B?YlZkRXBGa3pUcHEzUGoxRWFRcklVVnNRUVB4S29GYW9NV2VlZlkrbnB3OUIw?=
 =?utf-8?B?RFpodGhZK1NuV2ZpaVRHVGczQys4endmYW5tZGxzYTNXOHgzNkw5VnVjV0ty?=
 =?utf-8?B?Tkp5ZUtoVFAvMUhpclVlTUpnS1VsWU1JWFo0UFppaU9XVUtGWmE0bGY4OEdQ?=
 =?utf-8?B?Ky80Z0k5UERiSFdGVTgzY2hmVjVMTDFxNnE3VTI1VFdLbVpzRWlUMEhXZkNm?=
 =?utf-8?B?VHRlUkhMNEdqamdlSERXMENleTFyUGFLemdWd3NNemkwNVJ0Nnh6TzZmV2RB?=
 =?utf-8?B?Z1pxbGVMTVZXdHYwYloyZEx0VERpbjdYS1pDUjZlYU5lbnVpemdHMk1acjk3?=
 =?utf-8?B?dVBKMnRCajhkZkxCcWQwRW9PSnBqQ2JmVWJQdTV0YWUvV294RHlWOGY3NnlB?=
 =?utf-8?B?b0F1WGxlb2lMUU40V0cxdVVWQ1l5MURRUmNTUFBLenBoWTMxUit3UlVaUmEx?=
 =?utf-8?B?dlBCeEI5cjFrQTdJS2lLWlYzOU1KVXlyU0g1T210bkd4SEs0NWhWaE9BVnNn?=
 =?utf-8?B?NWxKcThUWElRMzIwaEtXbURmN3VHMkhtaDJ2OGN3clZ5TkkxOEJLZ2lhVkdR?=
 =?utf-8?B?TWtEbGg3Q29zZjdMcGt3UG5MSVFBdXYwNURNakF0YnBiSE84VytHYTI4aWZT?=
 =?utf-8?B?djkyM3JGZE1WNy93aU0rQ01tQlJrWXMvRWtOMGpnc3RXOGF4dWpReTE2WENO?=
 =?utf-8?B?aFcveEFSdWxpb0VpK3pNYVV2L0JCaytOb1g4c3JGOEc0RUNubk45MXRkRitF?=
 =?utf-8?B?OHJKcXM2ektuNFJnWWJaS2RVZG9UV3Avb1ZzU2g0Qit4a0tOVG45c29CTTVm?=
 =?utf-8?B?ZEhmTDFGdWJ6WTBKekF6MXhKenhXK2g3Qk9jRjBTd1VHeVhUYUx1YkdDWVo2?=
 =?utf-8?B?aytoRWNPR0RjS3pxRFR1MWtmeE5EeUFVOEpNNTJTNVdCN3V3dW9relJwVXZi?=
 =?utf-8?B?RU5hNE5HNTZzMzhXenhsMGw5MzFiWStpQ0xyTm8wbXZ0QWs0cXRmaFdnMFZZ?=
 =?utf-8?B?ZHhPTnAyd0dtZUhtbkdNUGFOTS83ekJ1Ni81ZENsVkp0Zy9YV3RhaHFFbU1j?=
 =?utf-8?B?K2pUR1VVdU8wR3RKNE5zejI1TE1VN3h4ZjV4VUVvYlhtY1M0VXBQY2p3d3cv?=
 =?utf-8?B?N2w0Sk01cWNRL0xlOUo5RGREQjdDbG5lWDNsd1IvVCsyRnhvTGEzc0QwcmI5?=
 =?utf-8?B?YVFya1NrRFNVRkVWSnFabGp3dzVXbmNNUE9vY0RQRmx6azgydGpvMFJ0dVRR?=
 =?utf-8?B?L1hDaDJnaG4xYzd5dmVmZDVqNEhlRDdRUk1OVitSbm90cHY2dUgweE50eHcx?=
 =?utf-8?B?M2FXZWRWOUxicGtJVFB4N2drNStvWXhhSkFBYXNaRk90QkxJOEdLZEx3UlBQ?=
 =?utf-8?B?azd0Mzl5bHhjN3pzbEgrbll2bVRwc3M0aFY1eXdod2l2aThWL1lwRVkrcDNE?=
 =?utf-8?B?bW5XS015VDJIV29rRGtockR0V08xNXUwS1c3S3Z0NlZ2MTRURlI4Rlp1RHVX?=
 =?utf-8?B?c0EwdjdmbE9uRExURnpZSENwY2JUaUpyMW10YklPOEwycnpNaTZJTmVKT1kr?=
 =?utf-8?B?QjFFUHhyUlJOUndTSTh5VHVmV2tyMGFyT3RMblNnODhNOHlsWDBvbXpqSDQz?=
 =?utf-8?B?bk5kS1FybE1PSE8zUG9pb0d3VmdvdlFTaXFFaFB6Y3g3RzduTng3aU9JbjJP?=
 =?utf-8?B?Y1MwbFg1TzFNS2llaFdBMWRoOEkrdjViTUpDNzZlcW9leTVvQVVtZC9oMkIz?=
 =?utf-8?Q?LKBCHbgSVd+mmkfy09QmXV6Sb07aRBQF9Ycc0jeTukJ4L?=
X-MS-Exchange-AntiSpam-MessageData-1: Wbtbxye9FvFHoxXcMg0uNNz/nvUwNPDOVm8=
X-Exchange-RoutingPolicyChecked:
	jpZEp5xLnJdiITMWjqJSHiZlKtAfOgYpbV3Hm5FuRBa4S6zq1FmL/wkM6cRKhN4QsYmOco7Sb791/L942ghMCI2KK4s9lsN4xgxmskFWX2G1/PO/W4uzssqVq9lTQK1tJoGRHTmSTU6Egf6zrIz6TH8RCFUFS3rZJIgWxCCrbVyemOOctZo9p+0AhNSWPtWM3b8X40gYcSd+lFMrYIfZxkhP0pozhe6lbUEv/XefNiXwfD0192XyFFT0sA7H7yWyf2sqhvsE7FhQQ+EfsRp129fR0EhFxn6SgmW3690B9mG2u693OMHgFhNgjHeOgKH7MoaFai1jcFOvw/vhLCACeg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fLiJg1rU1HVrXt/X4QgwdE/4AZZpnAv08Cli1BsKih0vE2f9aDCZI0FH+2+eKl3LZ+23kedleg3V1z6xRZUp2EEz9ml1TNEHItcctC5D+3usube4vcSjC1NKu8plgGSJklXnpfhUSIyU9xCkx5yGpfgJGQgiCzLbq1upXTQKizkzuZcS/c5Y2nqSNXmIEsIqz/LRsfgWxZL31+aoKdzLu85pgdZGWKMFPX7NFDNu2m55yq0PbWHxz3BsziuHIQROOpk/YVJWzQ2zV9JNoN5U1QU2FVf1RBOJjNKsBue5XLaQM2mOntikysmvTrR7ZqgAYgAtWbK+6bBoBkbhI0yEAWjlNAYF4VOgwXlglJwkZqPGAFINvFy/NqrlpW5JRmnwriMhpxhaObpq5y0U1+GT2f9Oh+WHEPQdav4KdjBDVL8e4+xQ5oBNHHZOq8JXY/8G3oACAwvqgayc1Wr4N1i/wbQ5QtWjxwYk9+fanVLEvZg8llRf/M0eEpSyiNJhIc+z3h08ql7CR6Zc/ErUNtYcnZ6vBG+pzDbuo2DMDNj7KDqIN1bCJ45BYMK3+WdioPMLtwevc8B3LZmpHjevySZXq/9DXO/vetxP3kDTF7cSxPpko8Xc7bhhCz/EpxGFnM4n
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35af162-a9de-4789-3340-08de9abbc3ff
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 06:53:57.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkACUB7RnnPvDKfotuAkA+peKdWVu9V4jTSAxL+e+m7M7jL8XkCLfMs/GmZiSEGk5S2W/y1A/ePAsVKogz4hv16baHTRkr/ukDeMekr/4zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8070

On 4/15/26 8:27 AM, Christoph Hellwig wrote:
> On Wed, Apr 15, 2026 at 08:10:29AM +0200, Johannes Thumshirn wrote:
>> The test still doesn't run for me on XFS:
> Worked for me.  What does the full output say mkfs complained about?
>
Here we go:

bash-5.3# cat ../fstests/results/generic/999.full
** mkfs failed with extra mkfs options added to "" by test 999 **
** attempting to mkfs using only test 999 options: -d size=17179869184 
-r size=17179869184 -b size=4096 **
size 17179869184 specified for data subvolume is too large, maximum is 
262144 blocks
Usage: mkfs.xfs
/* blocksize */        [-b size=num]
/* config file */    [-c options=xxx]
/* metadata */        [-m 
crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,
                 inobtcount=0|1,bigtime=0|1,autofsck=xxx,
                 metadir=0|1]
/* quota */        [-m uquota|uqnoenforce,gquota|gqnoenforce,
                 pquota|pqnoenforce]
/* data subvol */    [-d agcount=n,agsize=n,file,name=xxx,size=num,
                 (sunit=value,swidth=value|su=num,sw=num|noalign),
                 sectsize=num,concurrency=num]
/* force overwrite */    [-f]
/* inode size */    [-i perblock=n|size=num,maxpct=n,attr=0|1|2,
                 projid32bit=0|1,sparse=0|1,nrext64=0|1,
                 exchange=0|1]
/* no discard */    [-K]
/* log subvol */    [-l agnum=n,internal,size=num,logdev=xxx,version=n
                 sunit=value|su=num,sectsize=num,lazy-count=0|1,
                 concurrency=num]
/* label */        [-L label (maximum 12 characters)]
/* naming */        [-n size=num,version=2|ci,ftype=0|1,parent=0|1]]
/* no-op info only */    [-N]
/* prototype file */    [-p fname]
/* quiet */        [-q]
/* realtime subvol */    [-r 
extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,
                 concurrency=num,zoned=0|1,start=n,reserved=n]
/* sectorsize */    [-s size=num]
/* version */        [-V]
             devicename
<devicename> is required unless -d name=xxx is given.
<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
       xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
<value> is xxx (512 byte blocks).
999 not run: _scratch_mkfs_sized failed with (17179869184)
umount: /dev/vdb: not mounted.
bash-5.3#


