Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223F412B94
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782132533; cv=fail; b=YruR24dxiGG55mBLsZ2YTiOAt132ws7bEOgs6Fmd0vndPRP5EjkdX/KJkrOoWwg6A4FrqR2Wwljihvwmuq46vxNprmPIjVLRbAtJ5R5ndUP5Vd4rKThbmQuuNf1jzjv343RUehcatnnVzsMgamtPGOeWmaueepaWS9GblbzmJMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782132533; c=relaxed/simple;
	bh=+tfTlxfyKdUY7w00pU/TsnM37ecIOwb5CVv/lFnq7H0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sjLBSgB1FYeHInCX/el7PHkHg12ChCqgj8SgmyOiW3abMlUdAlbhJBdtHWO8o8sBf+xFMfhbqd5r4ykJGAHdGGPYGyHSixOwjux7Obgru61NfSp3nJnu9z0EziA28LJXFeikjWwDCR44rJeqYn1PecM3q/KIGTErX33Pl7EbbCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RWHikGr3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=p802SV06; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RWHikGr3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="p802SV06"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782132531; x=1813668531;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+tfTlxfyKdUY7w00pU/TsnM37ecIOwb5CVv/lFnq7H0=;
  b=RWHikGr3NlpXusZEaJz02PDxeZmEgrLL4GZDRnh2hzzUJl7iC2wOdcrk
   JfY6R649Lm6MBDKuZIEaKA/RpBBhhw6Ek9vcse8G4EN8gzRk7/DhqUrbQ
   qPMqIoJGKS9Q1W21+d1uDRvg6Oam8zP7a24NOpNtyS5OAOxC8v7rDsNFx
   y4YVTU0kvU8SO0hl535Ileibw7neDIwkm0+AeFvrB1yBiY8nh00GiWiwS
   XtqAxnNu1VVe0pdHpQD7CWrx9EY7NO9h8T1yEcv613/gK2P8G570c3/8g
   41vi3qz9f29ZUmpOVD1PczGjC+rt+G6nJmIlqjGtkpaCwoqtZpJpYS3N3
   A==;
X-CSE-ConnectionGUID: KXalDqBZQfmd2SRBoMVXtg==
X-CSE-MsgGUID: 72qa88WvTzylCludFKgFuA==
X-IronPort-AV: E=Sophos;i="6.24,218,1774281600"; 
   d="scan'208";a="150489794"
Received: from mail-westus3azon11011041.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jun 2026 20:48:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ft58PWr502qswVrmTfUmABQzwm50Z1UYJ110CC7g841fGEi9MhTiZaGJ0S4pi6H8ERCmWLDuzL4w5VuwxnaUwSlJv+AV+1MRt+9CzrqOjwGW6yS3g0ZOhS6YVityPgjT1bGkZTWXaztXl1TPRmNGxAYGRTQjKhj1NzoLMs22mf74cygdEQvdhoEUWvj661XJpmXTNV6++d3R5m82W5MW3vDyBLN47LW0kdE1VAfEmyeM6Lfw4+8cNIeN1mTQDcRcrtl8bnQGImQCuTxYtYetKJbBnJDpfLYHgNlmxL/+KrNJoqIAMNyngZo9AwvnV1RfJPoueKJ4nohjv32GW4x2WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNiatDkXswpbhYdYVDbJeig2LWzowE6yZysaP7qkPIw=;
 b=bUh5d+klboozgQpPxwf7aMU42jr7dEhrZVu/XrudAayRW8o6wD7CwO4ZzDgLr47ffqqgW3Xe99bGqnM6M04UtVWzGB2c8ogOAX9eQ9irWfhkxKajJz7pWqVdbLTXkwQMq9spp3DO+C5biV8v6cP4yG/R4MSWYw1KRPz5hvP7XnASJsQ6jl2VhjsF3hggV0gKocnpLjO6SuQwwepFJWzxV9sgZCrtZ2AIIaAF5N7iwso9U/QQakyblHkYwimSwnPtzSBRXTqQFDicLdyL8NbjwFrq9pO+I98d4CbZ6fh+stRlVAWz+jl2Ky8GThdyCKa4PHWjNjATASunjqBZX031GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNiatDkXswpbhYdYVDbJeig2LWzowE6yZysaP7qkPIw=;
 b=p802SV06NqqvvVe1suBIl02WqLaqaJrBpYCLnIyli+GiESjQE+kvlShRjdwMkRDmrVgFs1IeCrrihyOS9q/9KE2c1YD2TX7A3fqdQLlrXZiCd8CFOIv3K6i8ssz7qjWw+ly3DFBdWvg7y7q4NZsRqpY21dSIC8A42V0K84Dh5Vs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from DS0PR04MB9439.namprd04.prod.outlook.com (2603:10b6:8:1fd::6) by
 SJ0PR04MB7245.namprd04.prod.outlook.com (2603:10b6:a03:294::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 12:48:43 +0000
Received: from DS0PR04MB9439.namprd04.prod.outlook.com
 ([fe80::13c8:d439:54a3:c77]) by DS0PR04MB9439.namprd04.prod.outlook.com
 ([fe80::13c8:d439:54a3:c77%4]) with mapi id 15.21.0113.015; Mon, 22 Jun 2026
 12:48:43 +0000
Message-ID: <2219d2c4-ddf6-4a67-9e20-4c2f1bdf66a9@wdc.com>
Date: Mon, 22 Jun 2026 14:48:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] btrfs: zoned: don't force read-only on transient
 -EAGAIN from reloc merge
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Filipe Manana <fdmanana@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>
References: <20260622082720.561049-1-johannes.thumshirn@wdc.com>
 <CAL3q7H5yeNXoSBDB4g4pjMKku2k6-Vctk0uEVTd_MK=Wb1s5iA@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAL3q7H5yeNXoSBDB4g4pjMKku2k6-Vctk0uEVTd_MK=Wb1s5iA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0200.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::15) To DS0PR04MB9439.namprd04.prod.outlook.com
 (2603:10b6:8:1fd::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR04MB9439:EE_|SJ0PR04MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fa97cb6-f088-4924-c288-08ded05c9770
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|19092799006|23010399003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0o4jVXpMqjP5nQwpjOk2zaT0TytHSPfDdiZqU2armX32ZxbY7YCBrzcUThXhblF4+M+nSGFKSkQrPGOhdIOUcv8f9rfVbqj3qaGHDZaV29j7gHNqh8GfaCluokcVe32LMLmCThI+zkj73Svv2b0weQCUaXgIXRggbNUoOUN111sd5OOIpiW5vQ2lSXGaTsdYwOfR4uQGQoK7la/ZOGNUJaWxQzU+2I8uhXWxK8jeAagCZib5FevK9+jh1RTcBtGtxDMGyxsiftkQVMATUrh92F5yMGWLUYDbN/a+rBxtQBfPwGdgZmtAY7SXQVbyt5H3DGbqnwhKCF1oq3InHprb3uHoIgcOw1ZTCZk+hLzc8hfv79OsUu7unmuMyLMDmrpkM5+HgCSurTxdzY5WxdB98TXuzEWnAKpIEnxzjhcrj03aVqRng6bfbB6ONQbVHOq23IF9IhV7jvGUhuoYML9bKvkVY/ogiiTwswUaHNl2iSKhLkiKQof8jwyqeBPsGGewBbX1kCnSfBsqDGUXy/WPpXMyqeCsP4MJJJUWYHfjGLiFanSEfyq63ZqjQ13MD3Tf9D1+pft7dHyJ+5RiGHXE9UfOwJ/Jq56htLgckZnHY60RE8L7YtjZEmpZHJzo0yLH5Uwnw/c6i3UBKqiwyKGIP6rIg2jLz1CXE26a6sFp7t4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR04MB9439.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(19092799006)(23010399003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LytFempFaEtrdXV3RG91dzMxMzZxMHRGbGVSYVFuZllkRjBoUGVXNWJlUml3?=
 =?utf-8?B?NVZzSm84UUdGaGVoQzhPaldVcHQ2c1BTYUhqV25SUkk4Y0R6ZDM5NFBKU3F6?=
 =?utf-8?B?bllwN3V1bGtGK3ZwUVB3bGJLTDlxMVp1M0pPR0ZIN2N0dUcrSWprOElxTVhv?=
 =?utf-8?B?aWFIQXF5b2ZDdWJzWmVSUGk2T2F0OERvdy9sWmVLL2ZkU1d2UmpRWGs5MEJ1?=
 =?utf-8?B?em9vZ2VmR3hvc3k0VUZHbEpjWFM3SXMxZ0tJYzJpd0xKeXRXRUN0ODFsVktw?=
 =?utf-8?B?OVpZMTJsQ09ESWQ2d1N2UXFtMEZ1c0hkcklLcDdOZC9pc28zMk5PZ0dRZTJw?=
 =?utf-8?B?MnFDNDNXZkNYRFpBWWUzck96RExITkZlOUFZOVRBRTVFcWJ3VEh4RldvWjZB?=
 =?utf-8?B?WUhZMExnZzN4c0xjOTJVLzVUSjNCZVAvOHZLUWxDbU1YVUdsa0FpeXVDU3Bz?=
 =?utf-8?B?N3EzUHBINzREWloxUzdHLzV5a0Q0WEprOVZhWTZVNTg3VDllYjZ6djZNWVNY?=
 =?utf-8?B?alBQWFNHdjNaWDFhRHRqUFNHbk1RcXRNZm1PSSsrQzlmMkMwY24yQVFHVVJt?=
 =?utf-8?B?UjJrZWxqMFNkajlWREtqV3Mxckh4SVdWTTVqbE9rV21tQlg2T2h1Q0RKSDRn?=
 =?utf-8?B?bTUwa0laUnUwMStNUHVuNWI2SEppdFRsTkNWVk5XU3IxbWY5K2NBZE1rSFkv?=
 =?utf-8?B?LzduZXk5NTlUUjZvanhaSXdIWnRhbnR6b254RWhiRi94SmNFcWgzUWFNa3hP?=
 =?utf-8?B?cDZrOTBZbzk1NUMxR2VUN0c4ZjNheTM2MVYvKzkvU0hKVFZqTjBjOEczTHZT?=
 =?utf-8?B?SHIrdGVjVkNQdVc2dGthUlNyRitocjNDZzd3dDdIdExyL0hMam9IU0w0MDBZ?=
 =?utf-8?B?Z0ZOQ3pWd1g0RUtnRjBzNVl2cHp6RUZkTlBOUmJJdmYxdGxENUc3MkVtKzdN?=
 =?utf-8?B?L2UrNnlnMThNci9QNDRPeEdYSmNFZHVoNnBIT2NOVjRmNmdjYWtrc0hUWnJi?=
 =?utf-8?B?YXArT1RIdnAwV3A3Szl2QjFJUlB1YWJnU2l6eGdSeGlHSTFFUVZXb3g1U09a?=
 =?utf-8?B?QzhxYnZDblJCQWRpUEkxSzNESVdhNVRWUGVia0tmQU5kZFN3L1k4VGpYNlpr?=
 =?utf-8?B?Q2tFOWVXSWZHZFhWK2NJMDF4dGRqRkJUNTFmcjcyQmx4Z0RvL01EY2YzM2hN?=
 =?utf-8?B?aTBSNHVLWWZjMDViTU8xRnJoS2prWHZ3MURacmhic3VjOGFJS3dtOXpSdU5i?=
 =?utf-8?B?c0N2UysvVk9OYjltUk50SXpqWnhRSHB1MTFaT01mTVU3L1RBWWJCSStMTlhI?=
 =?utf-8?B?elFrcHIrdnVDZHlVKzhvTzgvREJiemtsQWZmMWpXNGY0VjdYcnIzMWZPZndC?=
 =?utf-8?B?Mm1JVm9ySFVIVnBNREd2d01nMndFQWdFUWdJWHkraVhiU0ROV28xSlF0RThQ?=
 =?utf-8?B?dnpjZTRoajVFaTZXZlVRQ0tteU9ucXlaU29iTURYWkppSXVxN1NKN09jdmFY?=
 =?utf-8?B?eXFVaERqU3VsSmhlQng3bXdKOGdEcjVwdXBVL1JaZzZ6bm9Zb2UrZHN3Y2pW?=
 =?utf-8?B?ODVVWkNwUW9ZenNBM3NpTFhZdmhFTEZrbUJyYUt0ZGtuaFFlb05ZRXNwQTZx?=
 =?utf-8?B?REIwb3FabmN4dGx6Myt3WmpNL09hVFBhTlpDckRrVnU5aUF5RTVreWxlZUdN?=
 =?utf-8?B?RzU4TGpxK2g5bFlWQjQxaThXVW8ySWFldlAzZDNKbXFJM3Q0ZHhEeGhoaEdO?=
 =?utf-8?B?WVJUbmVGRWJkVFJjajZWSDZ0ZC9VcXhVaktBdXJaQTNPUTViN0RhdXVhVjho?=
 =?utf-8?B?d08yZ2haSzZMUG9zTEUzVDNnZThmdDlSelJWMVY2YXBQVHpLWFFQN0hzWmY2?=
 =?utf-8?B?emdnT1B6Q0hIV0VYWVpDWXRJQUliQ1ZGbWJiTzROWlpDSnVzYS94WTlrQW1Z?=
 =?utf-8?B?U3RGVXI4dkdLZ0hWS0hZT3FpRDRkRDBCSkRidk1oOUhrYlQ3VlVGMXN2UGE2?=
 =?utf-8?B?azZtZGdLRXRPYkNEY2IzMEVyWW1OKzJSOG5seTJ4NjlZOHg4QTVJSnhBRzl0?=
 =?utf-8?B?WDNtekZCdVdVT1JrSDFqa3BZY01ZMzA3WjJRRko1bkNwVVpiK2ltN1VVdGo5?=
 =?utf-8?B?UUJCUG9pN0RseDg2ZGUwNVI2eHI4ZEE5elFpT0FMK2ZpNUpXd1NOWnZvU3V1?=
 =?utf-8?B?L1dXck94YmtTVVZtd2N4Z1k3UFV3VjBqSjdLMURBNDhUNDF4OGN2RTNLSUJG?=
 =?utf-8?B?R2dLZC9pd1I4ZkhPR0FwamNtNGRqTGFWd1VSbGpkV2tCVDFtak1oZHF6ZFh6?=
 =?utf-8?B?blhxaXpnVGFrcklLMmdKanI5QVc0OWp6L2NpV2RYU0VyTmJQdzYzWWdjanlN?=
 =?utf-8?Q?M0xhi5bwGfO1FWMdVpkLPF2rEtA5QSpRxXvvpak4SC7Nl?=
X-MS-Exchange-AntiSpam-MessageData-1: kO8PU9ZlXDb/PkXEiD/Y39N4E4Dx2+Sc1X0=
X-Exchange-RoutingPolicyChecked:
	HjjmHlmq0i4xPy6ck3eIedqQG/peUXU87LSFDTF8LQAGaaYG2jy9x+GyviGGnaiyjcabzmBJ2RJdJKTG0qBv+FRIwq8MGXiGTDqtaujkLKLUdfqrBxe9box66cTzydQR5SJoYhaXexUIlUjjdpoNhu77AshOFV2s6PCwjjoRM9T9PHgOI41VBa2fxgMs5bTX/a6nEHdCkqxxmvRZlVVHBZS4U7TRfVGJfWkT6B6XZUoUMCIYzGqbcBKRbklenO0jT71Fnbnn+Bv7rHQlohpi+ggcejQRtG4SHvbxsKzrFA5Seuucjq4Qiknbvy7phR0dNFNVj0yVmvOZKdcfNWTmew==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V5/3wWZoN5arZylT+jy1opVje6YNYI7hJdfc1VX11WmPX+FjKJ4YdotRytOiDtBXf6FgDv71KwH+i/g2g/J5Frfn9h9n0o4DTYtu5jx/K54hZ7/feqX9B9U3MPsTr1atOA8aAEkWEnmuq7nbiVwDeEopAO5BeKxLkifEEd/GPwyMt+Q/3k8EBbBT0PKa0B6KEhJ6QqlNYZzq7P5HwzStnAY/Rn3DnDNzMM1NsqJh9tbBxhpssEKcb5ibJquHN2stNWfrh0ePgIaQ7MAnZNrwrZM06M9RgqdNunY/CU9F11zbjRZXeJ6LdxhcX88pG8N9IT22irTn72gXyYdxJl6p9ybA1edWQjTJD13XOCfiemHp5WVNlQso3DnC6ny9EPdkn2XPxFW9w/oVAnJ+TMirmZMl0hanCKnD1aBaHJ1+Y/6ILNJJ1urZiqWgcFO0P5k+reL5Px7jCNIqja8JiqDhWbh/DBiXlJqg/gkKzA/FcfztkN3nuO3SYQ9YCuHZoIRCO93MEmLFuDSZPpx2irNZTTcgTHdm/ZmkwbYPyrkS/qUEJBDcIug/uMtz+ahDd1I03XFVk9PfEoBOTXjjIO7Sm2Tiuf3nEhmCRsx8JpHw/ccZuIZjncSMMI/r9YUHCqy9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa97cb6-f088-4924-c288-08ded05c9770
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 12:48:43.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MUnpdoCOBFdpNNUlOSh3wPoyl6djtIFjzesqTbXTFvXrdspvhFpm/kSTA5q/H+Y/6LkbdP9K3R+VlTIMThbYvYs76tMb3oBuWIOji1nx49c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7245

On 6/22/26 1:29 PM, Filipe Manana wrote:
> On Mon, Jun 22, 2026 at 9:27 AM Johannes Thumshirn
> <johannes.thumshirn@wdc.com> wrote:
>> On a zoned FS, btrfs_delayed_refs_rsv_refill() returns -EAGAIN whenever
>> the over-committed metadata plus the zone_unusable bytes exceeds the
>> usable size in a metadata block-group to avoid heavy over-commit of
>> metadata and early ENOSPC in one transaction.
>>
>> If this happens while doing reclaim, the transaction is getting
>> aborted.
>>
>> Treat -EAGAIN as a soft, retryable condition in case of block-group
>> reclaim.
>>
>> Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
>> Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit")
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>> Changes to v3:
>> - Don't ASSERT() for zoned in case of EAGAIN in
>>    btrfs_reclaim_block_group but check for zoned
>>
>>   fs/btrfs/block-group.c | 10 +++++++-
>>   fs/btrfs/relocation.c  | 52 ++++++++++++++++++++++++++++++++++++++----
>>   2 files changed, 57 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
>> index ab76a5173272..1327fd526b06 100644
>> --- a/fs/btrfs/block-group.c
>> +++ b/fs/btrfs/block-group.c
>> @@ -2047,6 +2047,12 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
>>
>>          trace_btrfs_reclaim_block_group(bg);
>>          ret = btrfs_relocate_chunk(fs_info, bg->start, false);
>> +       if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
>> +               btrfs_dec_block_group_ro(bg);
>> +               btrfs_debug(fs_info, "deferring reclaim of chunk %llu",
>> +                           bg->start);
>> +               return ret;
>> +       }
>>          if (ret) {
>>                  btrfs_dec_block_group_ro(bg);
>>                  btrfs_err(fs_info, "error relocating chunk %llu",
>> @@ -2113,7 +2119,9 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
>>                  spin_unlock(&fs_info->unused_bgs_lock);
>>                  ret = btrfs_reclaim_block_group(bg, &reclaimed);
>>
>> -               if (ret && !READ_ONCE(space_info->periodic_reclaim))
>> +               if (ret == -EAGAIN)
>> +                       btrfs_link_bg_list(bg, &retry_list);
>> +               else if (ret && !READ_ONCE(space_info->periodic_reclaim))
>>                          btrfs_link_bg_list(bg, &retry_list);
>>                  btrfs_put_block_group(bg);
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 1819d49d19c3..73d9948b5382 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -1530,6 +1530,36 @@ static void clear_reloc_root(struct btrfs_root *root)
>>          clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
>>   }
>>
>> +/* Drop the reloc trees of a relocation that is being deferred and retried */
> Same comment as in v3: always add punctuation to sentences, this is
> our preferred style.
Yes I apparently sent out the wrong version, also for the if above.
