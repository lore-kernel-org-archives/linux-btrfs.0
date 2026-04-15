Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1811C84D7;
	Wed, 15 Apr 2026 06:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776233442; cv=fail; b=HZNIg5NzfW6WxjzfvxANpY0ywNLgkCIFcrtT84B3gsXd616XFISWTw4EtR0pr06NxEq+Onj+NG4FTgO/9/Y6uGnD8US3q2pV0qrRtDHhI/ETFPOfhwH1M5PuTE2/m8HJBF5/WQa6J5dd686IqrTMbYyVcg/ourgysIR/LbYM+L4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776233442; c=relaxed/simple;
	bh=07tw93HYCqeviBfNQWqHM/Xa+7FlGq8vPC64BAOodxo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qUduQQh2bcDHxiUeQp3Lj03PWgR8q1kD7h8aMQuJkelGDOkW1WmWRPeuML6FmngVeS9qJQNEkwbc+MWikxat0IV/uHCybt34dRRBI/nE9kJHG7lZdosrXWmmgWEiDGmxMopo/IJK3TcV837Nw/FOp0t3zvW+FEXg5Ld1EnA8ZSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BOKo+lHv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BuxBP0IW; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BOKo+lHv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BuxBP0IW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776233440; x=1807769440;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=07tw93HYCqeviBfNQWqHM/Xa+7FlGq8vPC64BAOodxo=;
  b=BOKo+lHvRW3buAdDskvRmh+huMUXAh0hnKxQdobryqmeluW7+9dNTvHT
   U6JF0NIOsJHmMYZcxSk/mKAO8kX3Ewe8VjK9C1mxVH4Dno/tAkdqB+bMQ
   bh/8ovat/SPD7U9an1TeQ63/rKMLaxWbjPBrEYSgdNH9l6lbQmw2pnfAC
   b7/idW92rn9FHZJEwHIrp/8nyVz8XmMH4321Mspp3G3tkGL8bxmEgC7YK
   dvoKJytN8M+/YhUUQJAiN7eNwvJZqGEJGllyAGOcTMUiyJZgvnkrHknd4
   hZ7TORDGFkEgJ5bwEvsWOV9qB9C1NTpZbilD+wU5znGAML/yStp+rC9SJ
   Q==;
X-CSE-ConnectionGUID: uRKLQvE5TaupxlW4O+FDJg==
X-CSE-MsgGUID: itz7fUU0Q5SqdX/vKxywIA==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="144067348"
Received: from mail-westus2azon11012003.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Apr 2026 14:10:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=duZg1gpkNVNHbvGdVE46lB1s1oc6hYJFeKbBAmKCdbhy/lnybV47PsjZvLWswoJHIt1MHTsK9QwHPHzrM8e8QTYd6x2D9L+VNsvz85IPQEFcosmHy6r3C8+Djf1JbYi00UfInqrJELiC8rgHJLuCMIPRj0qwOQbp5mANkMCkeTPFqMf0xgUctKU4P1wyiPeFCaPZBkq8UDope4hSG65lbD+w0J7B7gfBk1w3unDPh2iWEcfg+/qDlF/xZBb3BppN8dmECNsxaLSH4C3CbqL3FtnIA8I8JSQj540+e2vpFLiLeoTF1qpMJZhgNzajXfR+DQNNa8WvKNC80z4ENLi6pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHLfvE41Nktx2a6eoWoed2WOPJh5DGQX2SLgtk8AAis=;
 b=y3D+QSBfVyzAsI4gEu+zMz28VyGxii9X7rTL+UhFafKwr7m1IvzRQRcq26TbT2Mllvvos70INI7i39XRny32jJYMkvKAKMit3bXV61BXA8zjQH7gW17q8rDTymeQDkQ3siKiGhkZCxROc1lHNlSMninfpnjsIbNRsUNfvfmXiREZZo2zhzHokkn8D9dtQNcNubMvP1eE4URZO09RIsDqK/kJDzvrDrckP4aJFHXG+hsKliYyfHWkHEfAK5l0HYdvg2ahmCAXjPVyqCBBl2dq+KIajb5WTVopR14jpQ54DrwGYPpa3z14xbOQDZT3OU0iFTwe9BhuUKJXR9hdE09ilQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHLfvE41Nktx2a6eoWoed2WOPJh5DGQX2SLgtk8AAis=;
 b=BuxBP0IWI9DVMZrDV6+8HHsm3fGyBS1XFvuyXEkFK/r8WKi3O89lVtREGJVYwS8j0O7leK31FhPTcWR9RB0wKwlRxbUTcIxL2bNRRSq9AO8nkUnKxGpjRzj4l0SK9067FiqyGpU1NYHLEZP5A/X2OIN+I5xGTysYzXkDXxweeMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by CO6PR04MB8332.namprd04.prod.outlook.com (2603:10b6:303:137::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 06:10:37 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 06:10:36 +0000
Message-ID: <6a849834-75de-4007-8591-05ff9eda1932@wdc.com>
Date: Wed, 15 Apr 2026 08:10:29 +0200
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
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260415055629.GA27242@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0391.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::15) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|CO6PR04MB8332:EE_
X-MS-Office365-Filtering-Correlation-Id: dbe1b805-5abf-4460-ccfd-08de9ab5b5f1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|19092799006|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qifJtkmcP3A/3+1zHJNJgbKvX9P0YIQ9LqZooxUiiseUWWD8VROoQHpavR5qtHojgmL2SY9CjcIwq38Ge/95VMd2kWnxIyByL3pAl1UO8wb7tHzXHDb49QVFqLSePbTcDMMbW7zp5XdZCchT19blZoOcOLDPjL7CbgU1s4ScvUB30483/pj2UFtugPVsSksNilyLaeHYTgcsi1r8pZUl0zhzJh4W2dMHdez/J1+1m1qfJe99o4sOmxmJAKN2+Qz9/dm23XJlDGbRfwyuQnH09S8ZnLjpL35cZyyZEI/cWiVyf6qNs6q8+qorJ8m2C6gDvlGrkp9Trb210RjaVopMh7+aJ0jMS40CDsmkv2r1j/yjv51IE6kdGSaUHQ8Wj0FeZBfDt/pqj5XFj5AJUP0v1m0lyVxD0aUskOpdpUEBO5YL7eRUHNj/8a3nectlFp48GN4kcYif7wSO+uT/FZDwAekupAgMI/CnTmMlhZ6+iBXpCbnq66RSnAGj/SoGoGBwaPD8oeG4WCnPRzs1gSTryOgIzAAxQ+UDg3x3wBLGRtBA+M+fUe93E4aaxme1+4BmzoeGSKMXlpQvz5YlHUZs7VOlRpjWRCp8kDJQVlZvO/gzYAgfjB2Yf7g0RkuX47/gHaSovYMluK8oQUa5H0bijJwp6ETB8JW37QVr/s5GUN+E8YdRDK9X4YGR94xSFJzDYucHJkQt1WTZFwbEfntcpdAgUOOOJnsTT6APKIEe+7Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(19092799006)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjc4OGQ2ZFZJZHgwY3hMaldHNnJWQWdETUhkbERUR2c1OE55QTY5cUhoV1c5?=
 =?utf-8?B?WnIrcVhuOHl6Q0RqRk5RUFk1aU93WExKRnhXYndaS0RyUUVudGdxbWNXUzBH?=
 =?utf-8?B?U3lOaHZ1Nk53NHluVjU2RGJEWjVhMUJ0bGFTcHBpdEhJS2ZJaXdJL1QzeFpJ?=
 =?utf-8?B?Sm5vQkJQRk1heWZyYVBPTGJPTlkzRjBNaDdmcmV6eWhQbW8rSlE1SGlxTU01?=
 =?utf-8?B?Slp0Y3ljaUladHRXdEVld2JUMHliVmlkQ2hZbkxoWk1kSWkwRW9qdFhaaVI3?=
 =?utf-8?B?L1FsNlpDaWlzeXE5d1dBc2VpbElxbEJVT1lMQ3U1bnRwUnY4d0cyOHNqdVJX?=
 =?utf-8?B?QzRaK1cxQTlOcy81WEo0MDFMdVYzT3RaMTZzYktEYVFTdjYwVER4QlJ3ZXQv?=
 =?utf-8?B?WlFZZVhuay8rajNPVnpaM01oMXpvcUlZeUF6ME91ZmhYNGRWUk5XOXlSV1kw?=
 =?utf-8?B?V2JFRVFMenZMdmFIS1JOVVhDUE80Q29rUGQ1S0dyOTdkRVQ4WVh4dytzekNN?=
 =?utf-8?B?RURHTWVRZmluZDJwQTBuVFBNQWE2UDZlcUpKbHVrcEIwaVBaVWoyYUhWbmVy?=
 =?utf-8?B?cmdSTjVZYkszOVhsa1E0MEJkOWZnZTdBV1I1VFNzdERUTTVtczZJOUVzblFQ?=
 =?utf-8?B?aXZyWE9Qc0x3ZVFHbjdoQUQ1SmJXYmV1bVNLZmtRNCsrRW1vUGtVdTdqZ2R1?=
 =?utf-8?B?ZTVRTkNHNExmK05OdkdoZHh0Skd4R2hZbmRUeEdUSU04NDRBWk5iUXpna01r?=
 =?utf-8?B?aExqU0dtVXVNT1Q3V1pVSkhscldpR0V4SFVMZ2FZaXVsUnZaMjA1L3dFWGd3?=
 =?utf-8?B?a0U1VHRrRStoaXV0cmtQc05URXc2SXJEeE9xUkphV25VV2JDbDNuQ005UkRv?=
 =?utf-8?B?UnZ5T2JNUmtqUEN4eit0eXlERHFlaWJKSGp4MlR2T2xqYkc2Mk43dUhISnBO?=
 =?utf-8?B?aFppK1VrYTYzajkxM0FsZ2dYUDV6YTV3OUZKK3F0NlN0MDA4ZlFMNUlSMng5?=
 =?utf-8?B?OG5qQXY3bWhGQW50S1dkTmVzc3JCT3NTODNodHpJaWYybVd4cEZFdnhrVmxQ?=
 =?utf-8?B?VUoxNE51ZklZZXJUQ3ErTHRHNXhFYS8zQXJzOXNaV2MxV3hZR0hwNURrZlND?=
 =?utf-8?B?U3FtTm5yOE91QW5taUVoOTR0TTlqeDY4TVNhY2NxVmVCTE5INDg2cGloL003?=
 =?utf-8?B?STNiKzQ5K1JiRTNDa0ZsSmIrWVNLZ1FjUSsvbUF3dlZlTitKL216WjVYYWpa?=
 =?utf-8?B?RUdHN2kzVXFrcThmd1F0QlZ2Vys3TFBUQ2RBQnFzcm1MR1VGL3NQcXo2OTd5?=
 =?utf-8?B?MVVqK0h5WFdISkpGc0RVbm9Sb2E5eUNPelk2UEFaelhad3lNd3BoVVdTNG5M?=
 =?utf-8?B?ejY5Wnc1bGdmdFB5ZmgvcDdIbXpUOGFoa2lwc0pRS0JHVWRxQXVzMXVEeXRI?=
 =?utf-8?B?L0tkMy9UVzdPWTlEYmUyeUNKc0NPc3FDSFpZamlqeFNGVnlOWWlzMmZiTlRD?=
 =?utf-8?B?dHpBWFc0ZElKRFVTQkZsbkM5STFUTGxvRzlMRnJJaWw0clN6MDVMZnZ1cldi?=
 =?utf-8?B?NHNuM3pMaEdWS3V0eEZUSUlaaWl3QXNQWmFqRlNQUk1GaFdWbVpIMnE3eHh5?=
 =?utf-8?B?YlBud2lLU0dDOVByZFp5OHVQS05KL2ZSdXdJUjZkVEhaSzdQOHdrbjJ6Y2ds?=
 =?utf-8?B?WFNiZXphVVgrTGl5SGYzRzk4dkk2K2U1dEJaWDNKeFhpSWFlRlpyeG0wOEJt?=
 =?utf-8?B?ZGVzS2NkRURPNDYwWTdjMWdjNUZMRW1qNW9UYW9NaHV1UHdabURNSk5uY2Rk?=
 =?utf-8?B?dUE4ZDNhL3N4SVRta3gxUmZ6SGRuSm1qaHVZMEdBSFJlSklycjhUWjB6QUdB?=
 =?utf-8?B?MzJ1czIrb3JTeGZOMnhPUUlCeXk5ZGw2WFhzVDZGRi8rWjR4eUF4L1ltWUYv?=
 =?utf-8?B?azJDYmVCTWRKbjNka3ZWMG9OM2kvUWlzYTN5d3I1eUtueDJoWTdnUXN2cGw5?=
 =?utf-8?B?c09BM090VmNuZmRsNUFpcXI1NFJTYXRJZGtmKzExTWdvNmZPaGhrNjhkTGNE?=
 =?utf-8?B?YXY2SGZ1R2VOR3FGT21RSmRUVDBpWFdxMDg5S3NsazRNTi8wNis0U3drN00r?=
 =?utf-8?B?WDBaTGxvYXRTNzZhSEREbVFlNmoxZjBqMFBxeXk3RlBjM0huYTZFc2xkMW1X?=
 =?utf-8?B?MUpxMFRUTWgxeVJ2VGMwOGRuMmYwZm5xc1U5MldVRjdEL0poVTNabS9YcUgz?=
 =?utf-8?B?d3huRVpxSUtGOTVISkZKY0pGRHdRSlJtWVhIUm9US2FBZHN2Z0FCSUZZTHIz?=
 =?utf-8?B?S0FjWHh1cmhIZjYzeHBhYWNYSDVXUms5NnF0b3hScGJVREhGTzczcHlVZUlP?=
 =?utf-8?Q?6bQX0TulmnGHb4jF/UqaCtOvvBbbAqC63puJMLvfMPlkf?=
X-MS-Exchange-AntiSpam-MessageData-1: hjUcE8+LvZ++VUBv5//EszcG9/IVwdlawBI=
X-Exchange-RoutingPolicyChecked:
	OWRTGeIuGhNeOzLLLqaXt4gY4w0klHCVwI9Bkh6E6VG7X0D3q9BIeA587X1GtSPCvqdjwraLGeuLPuNgHwf6J3RZiyGXRGMgd5fNDItoK4Xk2CxlSkD+UyyK3AzRcdQsLALXHc5Ka6jQZTEaBOf80hWIuR8/Cz2SLwp/DV0b/55ZCEdnAVph5TfTwUXQk9TciTZob2Bh2fy37Rx5zSEF4+v0wd8j0WQuhVM71w3h/6vx7ubZRXiIyVYX8qBjDY29b5MgnefZrUU/lm3DA3S5V1GjXu4FRk2dQF4dg6t77mLae5CCGQ9zBW0j1lJDNgFqZHzi3JPFT1zyVxFoMw1yjw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cQYLIwSOTS9hY5NR29aWzUNrlLtzWU1tELnJA+JB0U3Lpg6yIFd10wFeCgYh9hX+7kzW2WBc7+DyZBNlmyi+W1umcxs6qiWgb5hoh85wWDmJzQUc/sA66CkSZXtqQn5VdPyv/tUwp+F/06sASzh6wCYZBl8nrOAEqv8NMml0ZLmMDY8AWQ8wj0mf4Y9ly2x7yu7Fy8jRHuX799qAue3PbK+z/ysKKN5W1avOsFX4nh9nHw41qsBDYQXVeRpkC2MVHs7MkUfgQb9+NclVzDwXYPPqqGJ7kGDclVZidA9YqaS5PsOMdzEY0uInm/nrEvNKyp+tb3S6a5HpZW9dPqKukhbOYl085MnRizMShxm0dH1tbpt8cZwCAiNGYYB8r6e/I5E84QSL2fUB0s5dq1MulFm53SY/8vyXral7sgBN1zrnFbjt4dfitXd4HRxWLCc0o6PtbhuLeGgSCdWCYpHZXd8B+jYzTvqQXazsqSNLOI/rXC3XtCSUcPoJ7P71gAyg1A3d17tV9DbN5Goxs726GGIwvGh/D6P4+1xASeHJIcGatii2aYvTzXWplFCjxTHohOWIKgOno4CrSl+2QzPBgt/h1A/hncCeI/gVW8ArtqAsPtvbophn+YabgcGQFmh6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe1b805-5abf-4460-ccfd-08de9ab5b5f1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 06:10:36.7448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfeycGb8VnEhiFKpnHBPNqifQ5TeZNiIW0EMPLqb2zsHPjutpmYvUxgAYG+7Ai9JYHWvuajjWvyxLEvlrdezOUXgFlzVdIyb20fe/NmT8Kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8332

On 4/15/26 7:56 AM, Christoph Hellwig wrote:
> On Wed, Apr 15, 2026 at 07:53:52AM +0200, Johannes Thumshirn wrote:
>> On 4/15/26 7:22 AM, Christoph Hellwig wrote:
>>> On Tue, Apr 14, 2026 at 04:33:41PM +0200, Johannes Thumshirn wrote:
>>>> This test stresses garbage collection in zoned file systems by
>>>> constantly overwriting the same file. It is inspired by a reproducer for
>>>> a btrfs bugifx.
>>> s/bugifx/bugfix/
>> Fixed
>>> I tried this on XFS, and it doesn't work as XFS uses SCRATCH_RTDEV for
>>> zoned data.  Manually hacking in SCRATCH_RTDEV makes it work, but that
>>> will break btrfs.  Maybe you can add a little:
>>>
>>> if [ -b "$SCRATCH_RTDEV" ];
>>> 	zoned_dev=$SCRATCH_RTDEV
>>> else
>>> 	zoned_dev=$SCRATCH_DEV
>>> endif
>>>
>>> end then use $zoned_dev to make it portable?
>> Sure, can I still use _scratch_mkfs_sized for XFS?
> Yes. It sizes both the main and RT device.

The test still doesn't run for me on XFS:

[  160.045250] XFS (vda): EXPERIMENTAL zoned RT device feature enabled.  
Use at your own risk!
[  160.045707] XFS (vda): Mounting V5 Filesystem 
47eb9ed8-526f-4dc3-a488-5862f403ee5c
[  160.062623] XFS (vda): Ending clean mount
[  160.062734] XFS (vda): limiting open zones to 15 due to total zone 
count (60)
[  160.062797] XFS (vda): 60 zones of 65536 blocks (15 max open zones)
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 virtme-ng 7.0.0-rc5+ #407 SMP 
PREEMPT_DYNAMIC Mon Mar 30 14:36:40 CEST 2026
MKFS_OPTIONS  -- -f /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /tmp/scratch

[  160.375268] XFS (vdb): EXPERIMENTAL zoned RT device feature enabled.  
Use at your own risk!
[  160.375819] XFS (vdb): Mounting V5 Filesystem 
24c36996-2bdd-43cc-a1d0-6fb05f87cf51
[  160.390418] XFS (vdb): Ending clean mount
[  160.390532] XFS (vdb): limiting open zones to 15 due to total zone 
count (60)
[  160.390597] XFS (vdb): 60 zones of 65536 blocks (15 max open zones)
[  160.435057] XFS (vdb): Unmounting Filesystem 
24c36996-2bdd-43cc-a1d0-6fb05f87cf51
[  161.600694] XFS (vda): Unmounting Filesystem 
47eb9ed8-526f-4dc3-a488-5862f403ee5c
[  161.877731] XFS (vda): EXPERIMENTAL zoned RT device feature enabled.  
Use at your own risk!
[  161.878359] XFS (vda): Mounting V5 Filesystem 
47eb9ed8-526f-4dc3-a488-5862f403ee5c
[  161.896765] XFS (vda): Ending clean mount
[  161.896909] XFS (vda): limiting open zones to 15 due to total zone 
count (60)
[  161.897017] XFS (vda): 60 zones of 65536 blocks (15 max open zones)
generic/999        [  161.929562] run fstests generic/999 at 2026-04-15 
08:09:50
[not run] _scratch_mkfs_sized failed with (17179869184)
Ran: generic/999
Not run: generic/999
Passed all 1 tests

[  162.477746] XFS (vda): Unmounting Filesystem 
47eb9ed8-526f-4dc3-a488-5862f403ee5c

