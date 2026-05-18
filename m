Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CD03CCFB8
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 06:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779087530; cv=fail; b=toZhB4V121qYngSFxQnCiHB5NwqAmRkRmBQKtVqHjU7JLoHnWL9GoBglaTEp61pBhfv40SikQFLnQcCmVOJxxxqooOTdgq2qhFExVFVXGyk5Hu9iqHQxlg045LeF930UJnPYtTByYY71TlGsvOw0qU0FL0YLa9K7sk8ntjVKU9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779087530; c=relaxed/simple;
	bh=kxUoIIZk3ydPecscm3FjM0nsihn4v4VV575blP4cPQg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tWJ1SN9J9Msi9brM0AGKN+brjJp+VlL7C18N4IRedw688XDGa56luWJIPxAujEol6ze1+FZAtcWx3We2abYStI1dY7VHCvEvzPhL9vUfDpDfrNuWin6+wNYJFkcsKlhzPCFyO4FlGTLaSIYkSs0/O4xBPC4JjQZAwEw5gc/WS8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AG2iDgvy; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Gagwr+f2; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AG2iDgvy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Gagwr+f2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779087528; x=1810623528;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kxUoIIZk3ydPecscm3FjM0nsihn4v4VV575blP4cPQg=;
  b=AG2iDgvyeANDYhjwwwXxsumq6ElfSTCfzWvpZbFr84rjTe1QWy6IfG7t
   gjAMsv+0NZpLUFajN6biol3z/mV2DYMMfq2/mgEtHsswpioqs48MVWPM4
   7yKVSs7qDBWtx2g6MRE6iD0Bzsi++TNwlLV/o3g8ug4auQ38G7udk+m3A
   kXJlJxTWZ83y47tPuDb6emporln7rkVlWkv25BFAj2FkHch38Sb0wZC2z
   5636qHx2dI2LgVh5ICxLinn6PcX/rlIAAaONoqTABXvOjI0ewQbcxY6Vj
   REGQenJb76XpNiazEC9hDFtpv+cHWF3A/a1TzEQ3nVVYe1Vz9LL4a17Tp
   w==;
X-CSE-ConnectionGUID: bAULun83SzKuz0IQv3+tgw==
X-CSE-MsgGUID: jhc+qiwDSwC0/r5/p8rFjA==
X-IronPort-AV: E=Sophos;i="6.23,241,1770566400"; 
   d="scan'208";a="147972025"
Received: from mail-westcentralusazon11010057.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.57])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 May 2026 14:58:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H0Imvm1C6zCr99giXgNI3ubnVt8g+NuzIqbMlhbnVlYo/Au7G+djY6utuNojn2Vn2cj1Egk9raZlDa/9kL6f7oqKI4TF14ymVW9ZfNxh2zS53i9jFP65uHK6fsDhW8eDFfM6xVQAL0wXqGvSAz2mI+B+VAm2YxnR0gBCJn3lG5jbI83T/AsVtXGdmvNz3fkkCLk1TAvssDBLEywUL6+MPesdD17TEMU5B+ZlXCIBc19TJuXS0A+p9fITDjQ0WcA78SDFHmQM9UwfgofQvOUdZ8nogvD13Ni9FKEgrTiVFQvlQ1ee5j0w+IISNoQhHPStsXSX3SEEXqlcE1Dlnoe0WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EI2Uie42uwRoEdTqQe0IBTP8/mDq9i1au4BzHpXunjM=;
 b=EqPAti0cPwQVWLov4PtYfZMJO5U8QK7OCr62BxH6dD/OJXtrpBtrKnh2TVeMVvCEzwFGAIRGOLASCMXnL/KSq5Yu6LLalDo3qBWvQyuBH+eJAZiO7w5NaezHkmk/bilzHjV215zFiGw/jiixtk3G+tZJ5Bt1vfOjiCq15BBF5ZnsFTSzPWNCY6VU+W9XxeqDBlkwvePl9TgUue9j1PeJLV4bsFK4aIh2KvPlI/MvsD1ifq2SJuuN3eBObZq1SkwDMKv68AnlEBWYLPThQt7WXU4XRCFUhu8gRNpT1xIsNW4PfFjGl1HoTQUmLZ9h7OG0wAuIoO2BHeAMF6cEKWrGUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EI2Uie42uwRoEdTqQe0IBTP8/mDq9i1au4BzHpXunjM=;
 b=Gagwr+f28HHv7eocskSXdersdPO/6i9EX0grdQpkTEoMyAjHiocc8ihRyLA5jTlVlU91bIvhUGYcN58JQX8VnvnX8sAsXE2QKrF6QPeRmZLvv2vcuF0uCGkjScaNubJWv0NY6Os96sT5785e6ystGstRr6S3yMZG6NgSGlTGohw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6783.namprd04.prod.outlook.com (2603:10b6:208:1ec::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Mon, 18 May
 2026 06:58:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 06:58:40 +0000
Message-ID: <11899cec-4015-4ef3-a697-c7cc7cf1b424@wdc.com>
Date: Mon, 18 May 2026 08:58:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/7] btrfs: zoned: add RECLAIM_ZONES and RESET_ZONES
 to first async reclaim loop
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
 David Sterba <dsterba@suse.com>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Christoph Hellwig <hch@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-8-johannes.thumshirn@wdc.com>
 <20260515183827.GE1197064@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260515183827.GE1197064@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0216.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:88::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: 48512067-bab2-4041-c78f-08deb4aae463
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|4143699003|11063799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vYlCjd8OTJjvzAE8rBoayTbkqufpXw/iiFYe7OydLIi7bFm1PKQnDV16RjTcgy0tYPIYGCOfYjhkLtusWPon0Ac9nmBoYOyn5hY5jF6Kih74zEk7IIyGAlHUs4Foqdhjo+Pv3VOQKPrVQdFuMAF9ppDiuNXDQAkVgCsadhci96fcF3wXSyyjKiybSmGjZ4ZQbySf7JgkvRzWfzMblgfeXQzhYxuhfrkJv8/7qzHO/aQ4m09Uu57pJ+uvaDj6We3PZZoyAhaoha2G6uHku/Ln9lCEVyIxzxAwwvJxsCNdBULIIYUbqnNaVk3IuX9s6lfKTgjI6xBEImtUdzpEh3PBUQItzu9aIOlbvzYi94vQrSzfUITzbQYQd09fNDIfl15/P+s8Nbo+IVd+XTpmvLfM5WHMfU7fNhIlyQdpGYHTitFZ8fgH+JasRPVRsVq3yB0PRPn/YOlCGKHcrPzDDYNMdqidZNwd7g0XmbuD2b+drL4VgdTT2Aa5SIHL+4gzEbOZJeKqWrm89S5CxblMxARUY/e6KAeBSg3lMcPnRnErR3GBANVB1wDl6nEAtqRr1QRU/tS8I4by/JfjTG73oWYtrEw2W0R5jbXupK6JNyXEMmpu4Vq89dBDj5RzaXGBqWPAgOpPrnuXWGXbAm879AaswL7u2yj2vmlybiho6rqot43GUETZspb8eEtzqK4BpNpT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(4143699003)(11063799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFU1R1JJUG50UXpMbTd4OFRNRU40Q015blVEeG5za201aGVyYUgrNis2dG5N?=
 =?utf-8?B?N0JCZFVwc2lwdkdRL2Q2U0M2RHNIc0MxenpLQSsyRVNqN3dSYXdneVpjbUE3?=
 =?utf-8?B?bjVaWjloNVV3bDl1anRyREM3dnN4R05lY1k2NnBRNnQ1TmVpRWxvRlBYREJr?=
 =?utf-8?B?NGlZdis5bHlva2p1WmJ4NDYwVGUwRzdsZnNrODNwRkdGdTBSamc2ZFRBQ05o?=
 =?utf-8?B?VVRXMWMxZmVDNElRZG5IZFhwWmlFaHA3N0w2K0hjOTJLWXIzcCtRVWNPSk5q?=
 =?utf-8?B?RHFjYzlRZzdXcDU0NU11SzBhZWkwLytUQk90cVpoQ2tISUhoU2NtOCtWRE5n?=
 =?utf-8?B?TTY1M3J0Rkd6ZXRuVDRtWTFRVS9pQlBBc3gxTWliSkJqL3JHcU80MzM1ZDQr?=
 =?utf-8?B?bXIvTVZNL1F3cC8xTE4rN2xtcEFaK3hpTTRVWXZwL1Z4a0huSkxhaXBHNmVn?=
 =?utf-8?B?VEk2RGFOQ1k3QSs1NnNlN282TGRTRlhnUytoQzRSbmIwNHcvYm1Ub3lkRzZJ?=
 =?utf-8?B?bURFdVVuQ0FFMVo4TVJTd2FYQVZrUWZoeW1GMjV0eHBUNElUSWVDQ3g1Mjh6?=
 =?utf-8?B?U29tWjNvRDJUczZmaTJmRFp6QU9TeVl6dmMvV2YzWldVM0NiN2FacStXdVNu?=
 =?utf-8?B?d3MxRURGNWhVMzF0OGNxZ25oYnI5UkF6NXoybFBDR1MzeTI2RWhiR1N1WnlK?=
 =?utf-8?B?aHpkNzVGMmk3R2xKUytmVHdHMDcwYmU2NTlvWkpyb3A5L2VzcWhiai8yaXE1?=
 =?utf-8?B?dVhaN3NtVTc4Q29YKzg0S2Zmd3I5UEtHZFJ6a2R2akcxeVB4WUFISVMzUDkz?=
 =?utf-8?B?SnBZWmpDajFrbjZidEpZbGRJS3lIRDBQdDBMaytST0QxaDNiREtqMjI2cEdV?=
 =?utf-8?B?N0ViV241enFBSVAvZVNURDU1TWk2ZU1YYU9nQ1pLa3had2VRYm0yRElSSy9n?=
 =?utf-8?B?bC9KRVZLbTJSZkgvckV3YkpXS3JRNjJ3U3A5Y1ZSWkg2YnN5NWRaeFQ1NkJR?=
 =?utf-8?B?VmdmMG1GamdPeHVZeDJDUUVndUVGQ2ZlZUFGQjFtV05iVGV1R1lrQm8rbFdJ?=
 =?utf-8?B?QzZzYkNTejBJN0pYWnBTU3Btd0g2N1FqdDZUYm1wRGhjSENqNFB1U05yUWpT?=
 =?utf-8?B?aTZiMnpzbGJCeFM3WVI2eHJpVG1VNlI3cUVqbFNaVkRFdUx5ZFY0NEJUd25B?=
 =?utf-8?B?WUlPWjFrL1I1SVEzemJkUHhzZWdWbU1ONTVZSy9HcE5oT3RwOGJtMy9Za2Zq?=
 =?utf-8?B?ZE42VUxsT2V4bUs4V0ZFZFViditPNVF1M2dUWEd3dEVkYlZlLzZJcjhjQjYz?=
 =?utf-8?B?U2l4QXdqNFJzMjBNa3VORTlVZ1ZzeVlnSENvOXJ6OWdEK3RWNXhWNjJ0cXpE?=
 =?utf-8?B?OC92SWF1TFNNenNqdGQ1R1Q2ZGVUSk91YmMyZjIwb2o5UzBNNXJiSUpicHhU?=
 =?utf-8?B?ZlcyOHJkL1oyRW44dGRFS25zUnJVdHBOMlRWV2c0d09rWlNtV0VXQ1pnRTlI?=
 =?utf-8?B?alg5eVd1SGxETjlCRnV2ZFBmdDFLdXE2NWNkaHE2TzBldTlMWUlyYURFOTJJ?=
 =?utf-8?B?eTB1bituZUZPbkNVQm1ycnVqKzFLQVpRU3lTQ05ha3NKc3VBdzNWM2VEQnhK?=
 =?utf-8?B?eXVMelZWOHEwTDk0QnhHTkMzM2JyTllvbGhLakZmenZ1bzJwblFKZk0vcUxZ?=
 =?utf-8?B?UmRQKy9QeDMrdUxmS3NxbThHRVhyTVBsQmNzc3NBazhmcERhcDhzKytoU0Rq?=
 =?utf-8?B?bXVTVzE1Mjh1RDE0bjBudFNxbUxwVWlJcTI0OUNqUzdkN0s0ditJTXFZNUNH?=
 =?utf-8?B?OFduTldMbnJHVVJPVWhBOEFXcWZKVXVPRnVtRW1LaVNaVnVVQXV6Q1hySEJa?=
 =?utf-8?B?bVZDVDh2ZEdCY3FuU3haK3gzN3JaK3VTbEd1ajJ1azlsYTVDcVhoek9nRFpG?=
 =?utf-8?B?b3g1cDJaY1A3V0FRLzBSVU1qVjhHb1FSU1RWd1N0NCtmQXFnMG50THpiWnZl?=
 =?utf-8?B?MlVHOFFEZnlLTWYwc1MzWmUvb3paOVh5OUFmS3dFWFBhODZHN3R2K3RDVFJq?=
 =?utf-8?B?VVg0RW82SW54bXNNVFJtd1pJYVdxeUFCQlY1Mm9SU2hVWVUzczYwNy9rVXcw?=
 =?utf-8?B?TFJMZ2h4aUwvWXgrUVVjc1dCcEVWU0EzdjhWK0huVHovYTVzMVdVcmZsMWkx?=
 =?utf-8?B?bmFjVXNFcXB3L1E2aTJIOVRHTmxMWEhXS3JGaTF2Z2FnbDRzVGpyUGpmVjhW?=
 =?utf-8?B?TGNJSTBDTE9wRHIyQ2lZWVdrdy9TS1NSMlNLVmhQNWdFaHUrRE5SWjdDSUFI?=
 =?utf-8?B?blliUHpqcXpNYzY0NWQzWkpYaktrNHBDaWJRdkdPMlNCV0d6TWVDbVg3QmlO?=
 =?utf-8?Q?fG8eQIyRZfjKNXdM=3D?=
X-Exchange-RoutingPolicyChecked:
	Xd7DgD5FNu2jtthn7/BlLuGKZ9wmI0aR3SH70q5K88Hvg4RGlCh0EvCrrzbRrC1hbV8Utqu2/tokCJLYkMMV5FtHpK2MmhTtCwkjdm6THNdAIhti99dsk+lo82SIkz2emicBlG42GnOl5C3eR9jZ1u7CuOeR2c0CnpB5ewNulmgJ6bVcIHH6sG62V0n38w8XoXkr88CydjvTf/qP1v8utVy8P/pzKSG6rBY6bKMwps47gDqjfVKAW1pa+ziBkQqkH09hAMSz9Ic5IwQ+VYWEKlyqSn89JoDhShx6znxy25f21z7hKYaLcXMOWkDYqiMGpRQ0zPslqi15y/xYPIVLkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vpkYeUI6jKcT2VzqBmEDNqqFuReVBSp0h0oZi9UES+yC8wkgYyYKJtg6TwP2KB+5FW7eLT7yvac6V5QRiA31VYT/nZUCs36dBiGSrEKLvseiklieDcMza5VgKxaFzoEBjJC7cLx9HD+yghaA1KR6s7n4D5Nk6oqXxUd0gtg1uY5DL0uWKFevBz+5ZQyu9+UcMESKWuDOiNG1pJPwowwm/OkbUYSz+OZOoxYN233UK9fWVd5S8u0JhCryMYDAE/1XHLbH02Nk+N75QfTKDLLeQCrLEOFfOH3yS0RwQvlqh/kzf8/RYgElF6ZexSoJouX05j8qpzYZjPi+6FvOhwAISDv3phFXlSPiNH9YsbQuxIbUuamiZwTkoe0yQFEh+kWIbVty3OUcx/3ir4vJKMQ85rV/H1IYKYVQDGR83ixd9jzSWK3h2UM1Z7gTOtI8VUmJCmOnQdqHydTc1YU9qOVRI+A8bkWBTz0yN2evu70BBWSvCpuyaNiKIwsQ70dBL5mW8WeQ7Ri8D6PIXPUpmQG4hGDcHM66xKzGkdZGqHx2vjV1Lif7v+CVVd7SSsO6gYxz4LZY22142NiSFOdE/IJ5o9oZRF79mA1Uqrm/tm/xBscxpX3b5t2E/qZuGo1buzlv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48512067-bab2-4041-c78f-08deb4aae463
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 06:58:40.3699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1Volq6j+X6QEhHFwp44ZGCMufYNvDPyrBGlbK40eMxQ6EKT2pGDyECV0BHftn9/YxsZM39IZA5ZiVF6axMA26S7x247He2QBFVKwn2Wgok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6783

On 5/15/26 8:38 PM, Boris Burkov wrote:
> On Wed, May 13, 2026 at 02:34:45PM +0200, Johannes Thumshirn wrote:
>> On zoned filesystems, when waiting for space tickets during data
>> relocation, the async reclaim flush state machine may starve if
>> RECLAIM_ZONES and RESET_ZONES states are not executed early in the flush
>> sequence.
>>
>> Currently do_async_reclaim_data_space() only executes RECLAIM_ZONES and
>> RESET_ZONES in later flush states (FLUSH_DELALLOC and beyond), but by
>> the time these states are reached, the ticket wait may have already
>> deadlocked waiting for space that can only be freed by zone reset.
> This explanation is a bit confusing to me. Does your previous fix
> prevent all known deadlocks? If not, can you describe the remaining
> deadlock in more detail? If having these flush states in the general
> flush state list causes a deadlock, we should not leave them there, even
> if we add this earlier pass.

I think deadlock is a huge misnomer here. It's more of a space 
starvation. But I need to rework this patch anyways as the frequent 
transaction commits it causes make performance go down the drain.

In the long run it is probably better to set space_info->full sooner on 
a zoned FS.

> I assume the issue is that some other flusher can't make progress when
> we are out of zones and also lands on a ticket, and so async reclaim is
> stuck on a ticket and the only way to make progress is to reset a zone
> (hopefully) or reclaim a zone (painfully?)

The issue is with direct I/O filling the FS to > 90% and then start 
overwriting. With the old logic we're trying to allocate chunks/zones 
and once we ran out of  zones on the drive it is too late to start 
reclaiming the space. BUT I think this patch just papers over the 
symptoms and doesn't fix the root cause.


> Maybe we need some high level flushing logic like "needs zoned help now
> please"? i.e., if we are low/out of free zones, do only zone flushing,
> otherwise do regular flushing (including zoned stuff if necessary/wise?)

Yup sth. in that area.


>
>> Fix this by adding RECLAIM_ZONES and RESET_ZONES to the first async
>> reclaim loop (FLUSH_ALLOC) for zoned filesystems, ensuring zone reset
>> happens early enough to free space for pending allocation tickets.
>>
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>
>> This patch was AI assisted and I'm not sure this is the correct thing to
>> do (the flushing, not the use of AI), hence the RFC tag.
>>
>>   fs/btrfs/space-info.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
>> index ec811a77ebb1..a1235f114f3e 100644
>> --- a/fs/btrfs/space-info.c
>> +++ b/fs/btrfs/space-info.c
>> @@ -1451,6 +1451,17 @@ static void do_async_reclaim_data_space(struct btrfs_space_info *space_info)
>>   
>>   	while (!space_info->full) {
>>   		flush_space(space_info, U64_MAX, ALLOC_CHUNK_FORCE, false);
>> +		/*
>> +		 * For zoned filesystems, also run RECLAIM_ZONES and RESET_ZONES
>> +		 * in the first loop to avoid starvation. Zoned filesystems have
>> +		 * sequential write requirements, so space cannot be reused until
>> +		 * zones are reset. Running these states early ensures zones are
>> +		 * reclaimed and reset before we get into a starvation situation.
>> +		 */
>> +		if (btrfs_is_zoned(fs_info)) {
>> +			flush_space(space_info, U64_MAX, RECLAIM_ZONES, false);
>> +			flush_space(space_info, U64_MAX, RESET_ZONES, false);
>> +		}
> Just to set a common ground on the existing algorithm:
> The current logic is to allocate a chunk (which may satisfy tickets)
> then check if we have any tickets left. If not tickets left, great we're
> done. Else, allocate another chunk (till full). Finally, go into the
> various flushers if we can't allocate a chunk.
>
> The way you have changed it, you tack on the two zoned specific flushes
> right after allocating a chunk, regardless of the continued presense of
> tickets. That feels off to me. I don't know enough about zoned to
> accurately judge how you want to order it, but I think the question you
> want to answer for yourself is:
>
> If there are totally free bgs on a zoned fs, do I want to run
> reclaim/reset zones before or after allocating them?
>
> Given the fixed number of zones, I would assume reset zones at least
> should come before grabbing a fresh bg? (Unless that fails in a free
> zone aware way?)
>
> OTOH, if you put zoned reclaim before chunk alloc, we may block data
> allocations on pretty expensive reclaim work when we could just make
> progress now by allocating a chunk.
>
> Long term, I am planning to refactor space flushing to try to make the
> separate work less sequential and driven by the demand for the
> particular type of flushing, but that is way longer term than your
> immediate need. I am just saying that to hopefully make the pain of the
> "ordering" aspect a bit more clear in greater context, it's not zoned
> specific. (it's bad to keep running delalloc first if we have a bunch
> of ordered extents out and should instead run delayed refs or commmit a
> txn to unpin, e.g.)
