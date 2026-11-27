Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795791994;
	b=ZShiCXxL02J4z2aNNE2WTA3/pt7UXZtd+GIBfD5i3iKIr8ddNrgDAQJf5t+WcHlG+Kl/
	 +qkAbOB9IJlUKnoxyxTXUwolGwRKgINxiHhExoEQja61PGmT8Qow+2u7W3TIut3fGzuTB
	 TD2uwyvB9mijEXkzAPOFZRb/Yw7n0LqPrwTgAacQbl1zgUDM4+9dJjwM35/+RbmnRUv/G
	 8CZqW1YHgcQaEnwy6w+3CVFhEodvIXG16nenmutmWkHkDHcn38j02wCY/cK3JQ8CtKWkM
	 v+GonCLzKEBmCN1QOsOmO9HOH9Siv6Y4T+85zsyTDRBrYLAqzqbfI6OzWE5sqoyHfIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791994;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=IZ4z6+s6dhCKGn7Xk+VrHn0h/GDK0ownCP5ZmP+8IaM=;
	b=Ol0wI1ATumIFV4v2yGRF6XXczUJzSx4RJjIre70Lt/ZD4v5W5YcLSwvtg+t64RyzF+SG
	 teEbUQKm249PvOxFn0u0eWozTuXw21Z2wkv/rIPAX3zWMCaAe6MaSBFq7xKHqyew5VRX3
	 JLR7QWQ3VvQMqqkygrcgFXggOPIrEImyDpY0XdGR7zwEKKyvFyDhgCEQZ5UyowJ4TK4JY
	 TsFn5GABLmC3vt6O7du245nacqgcl9KObHZl6/ZIetGWuGu4uVsx8AzzApBhNXH32sRC6
	 dkjSzeQd0I9rdO9NBBAI5tIwYHyNcgxRYQnNEtfz1H58t5xAPzHOWDn477xPtVWJyEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=m+8YLBvF;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=R4yYuSsk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0D9606A334
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 15:06:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E0D9606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=m+8YLBvF;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=R4yYuSsk
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795791992; x=1827327992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LwG2SsUHNaf0PQQx94TsqGjS0CraKwpb0udymADmI/w=;
  b=m+8YLBvFOJIRLZvlE4+YDmPI3Bk46pom2+kkQM0CtsPeuYeK7C1VTdM1
   gDmSwYUdy7vSWrjLkw2nhm/NBYEvnbIT9rCoWDNKNzrT2qpyqVC/JZTmd
   ayw1+aAPKTqcjnId381UGJytSrvOEdq4jNoOEIGRfnMY+hDLUa3HI+E7m
   ZYT/fLA2zFU+LEX5/W7JGzJFrp4c6Fs+xArVU55HOIBsnotWHq68cfq5v
   zyDamEn2QfF4oVTydekWkR+P59UyoCInj8FdcEXTUW/gCsAHtSUo3+btc
   GQ8I+Jd5yli6RczMIeGXjK5ljvbVE6LJK8b+mnQ2BzXYmBKIeYVpFf1yC
   w==;
X-CSE-ConnectionGUID: XZYRRvtIRoKrNDP1NJDzYw==
X-CSE-MsgGUID: q65d9FHGSJyvMy9XhWzcSQ==
X-IronPort-AV: E=Sophos;i="6.27,237,1786982400"; 
   d="scan'208";a="162902171"
Received: from mail-eastusazon11011019.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 23:06:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LouDpeGC8Vfd5w6PLPBnMuBL2TYkZ7nAezDvozVuVKjqmAXKOU0z58IDkbwalPuaxWWOG4kFfcOscfwViMTr2+knzNf/zoKldiM2Ng31aGM68YQ2C5/OVQHkxcMUDlAE4tWn8IB6f8FuUNPpa80XvGOZtPLna/TKH0y4Q6rNMkaTyZP5havSAvw7Z4iK66tezfwTyyfrAvNPLdjFpJ8PtKm5WqkA/MpZMGIht597DYh1X9QUQtY7ATtrsMPblw2UIy7g1qBLIQjvLI1yE4ttWwM9K+Fv8s2TptmEPsBlo0v62Ccnp+61gtnpEzoiEoBBDeqJbAWCFBiGcGqsOoOvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZ4z6+s6dhCKGn7Xk+VrHn0h/GDK0ownCP5ZmP+8IaM=;
 b=kZRg8kdPdR+K/2+U3n8Vk5UQRJUEWRFxxYADXb3+7RbQU65miZVnuEXu6/DmgBQzt/GHy1xuYBZiBJbA9/N3SDvu+3B71+gSIsTPcvaJ5htAcdtP6y6o8qUpAmEUFw8V6k89ZVgNIsLiETLLMgB+9Rm53E8FQLRfSpeqnA8FlQmsy894Pb4dYsvbXm6xW3Jr9ALRGzjcOTocDmEwwQexnbl8LVkf7CRlTzLU5hxHDojYwmX2fT+qTNAfO7deSU7IegYYq4R8z6CZsLvsXTpbgzu588eT7xwrK8HElTsT+RkSjZYSeX/NG5pwf28axYp13FY8YQ22kPbkzSu+DPNC7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZ4z6+s6dhCKGn7Xk+VrHn0h/GDK0ownCP5ZmP+8IaM=;
 b=R4yYuSskSpfZhyAS9mHJvuv3EYOudJ70/AaI2lF2Y41HMs22RqPMYJfXsI3lYYwXxXVIbpn7i47tGZO9BlY34h8WzssD5IhqqmIvZk7JKVHp86bfG73F6nKLbLmUsyOTvy+f2IpWaKe6ZzA1JUXkFej0i0pQ/4W1w17lSEZxjDM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB7960.namprd04.prod.outlook.com (2603:10b6:8:6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.10; Fri, 27 Nov 2026 15:06:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 15:06:25 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 4/5] btrfs: zoned: try to fill hinted block-groups
Date: Fri, 27 Nov 2026 16:06:00 +0100
Message-ID: <20261127150601.803290-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
References: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: 141b54b0-4abf-4e90-fb18-08df4c98017c
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|23010399003|19092799006|10067099003|56012099006|261026140227099003|261026121527099003|261022105027099003|261021123027099003|261021121427099003|261028144727099003|261102123227099003|261009223027099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
 FvO+gazpmA3jYY8p1xPe17BCupzCIZCngKI7wY4DSDGHzzb3+IfYTyVWYDd5g5yOXOqh+fcGjAykNodYMkBPWhnqb1Nx78wzBBfzstF1UsOsLJ3eSem6WvhVzE57Hjy6/76fYw5x6RIfCAN6LCZ9fYobTCfeGUW6Y/PduYPkzOKUTZTaUzblzFh6f77yrRHq0DWOJDoRqApmS+E8wqlT8OEyWHsEIZlOVhYDxgzZkvGjq6U9YPV0/TGJbcThzOshVSFg/zWrh6tUe3n2VIe0IKb3t0522DqQUSSI2OQiJUHeqU0D/aIPUmr1oPcyyQPBANUAfqFrGJSO8G0if/vUb9FM3Cr4E48LWfBYYgK3rm4lUrKrwZb6ysWRTNBO/slZS8YgJUBhM1Elkdt0THlKcFPR5w5vuUx6sQGxpVzk6Ukg3dD4j634/yxO9+/j8I4WufkI4+qa/wrKAjXm+oBDauUJszCr4l5sbA3rRCtMTN6jiKaf5B5axrl8DAeNZMiNBv3ppSqvsxJvMe0iebadHctflXPNLlE4b3B61o16jlvvwgk42YSOZxCrt3vxUpY8r9UarZvLaatAN5IE8hDqIAmOGbIM6n6OO0yJUp0dqkWAH3uKzLAC9qfmRKabVJldemxJRGOD3MMTVoWNKtk/ueF4WBJ1ZwGaOJI6rNNUFWA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(23010399003)(19092799006)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261022105027099003)(261021123027099003)(261021121427099003)(261028144727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ch1TVuSrg0yVQla7LzB5gqYhLsgZZGIYhLmeV4EUzN6uHibsJIj5D2Et0MR1?=
 =?us-ascii?Q?+EWhRtkIXadFTq/ANo9uyEm4Pwwp3MVyjJAbNwaPenPWZlU5+aRvIJK5Oqw5?=
 =?us-ascii?Q?Pq+bAHrbpX/uQm/rD/Bg6+rpodie3Q3UN76zc6PdtR4Mh5Dqnmz3JrA12/LX?=
 =?us-ascii?Q?qNZ/hUCwoYVVUpRLDE5LyURZbfahqqdngCsRtpdH9Dcef6ArxnvgDpSFruFH?=
 =?us-ascii?Q?i+i9JNBGQNkTN4UqkKVAhPQ+fv1emSmyZDNWvxMJxg/Vpyh+YlSJGRyM6uOP?=
 =?us-ascii?Q?3f3WmzGhtYaU46Z9EEzY0vLcrmGLDhxUSut3aGGeht1NV06ICnPc/rHEUajh?=
 =?us-ascii?Q?RarH6WIYHLvkVn5FwLAnH+bDVGtZo7e8hZAaaUnX7cBQdiGQV3j29f2j8+Dt?=
 =?us-ascii?Q?lnxQmeK3xg9kh38IYZaI0nUb+gkyc8Y0GWT/5Y2jnsYROLgGKl3wfjM+jrbC?=
 =?us-ascii?Q?6uGFKZCO0GI9zu1h3plQMyMjwKLczStT8EaztLOK2VVsWwlT7YwlVhwUfR0w?=
 =?us-ascii?Q?8y2yyshqEC7U8eED3v2ekTUb1MjBv1Eo7KmdE7mkeHy5HUfjJZFDNcZHOR4Z?=
 =?us-ascii?Q?OFMXqNG1A3ME4FAOgJTZVV2dRY5t2DTm6okFrElbLMv3W4vdvARY9cVthH6T?=
 =?us-ascii?Q?1AWFEm6h6ymhZoc9NGQrSv57fslXBLvNIGhKqsVwNvSXJt0oenBqKeLLdPXA?=
 =?us-ascii?Q?+hpqDdarxt8v7g2iFyqofybAXTlUpUlLpRIEQG/STXN9NotPDwe4eL1Yl+gq?=
 =?us-ascii?Q?waIYCbpBxh41LxC10nPotj29KIA0f7vKGNnavW+s6Hx243/AJJ2uy9QuaLyP?=
 =?us-ascii?Q?MjEJAw5qlOqx0bz8BV4idr58VlJ81NLeudK7hCSQtyu6ax2IEGp4qIZd01Cs?=
 =?us-ascii?Q?bjGLrOpvNrCx63WbrxavOlJvVeyNP5Uz8U9MOa2R0kqkXrqgSI3URM0wSr9c?=
 =?us-ascii?Q?cEBnkQ0qM28EL7OINfCecIxUoZCz49bF/qcjlfzCiIHO9uOIGxqvsBV23mF4?=
 =?us-ascii?Q?l5y6wU1IFbAHHQ3kLCFnnQJg0Rb0jM6Ug5H/DbgUdIq3Xg0m1G0VytuJ1dpB?=
 =?us-ascii?Q?dhCWQnMgS6hOLVtTn9Ss+Xn+pIqoyRuNbtC8rQZXcvJSrbOlYJGf9r/VLfEO?=
 =?us-ascii?Q?+IXII++yRM7YajLFlX+DE6VEcFoj9MQIFu8+60+YGFC5DgysXce1GwD1g6DT?=
 =?us-ascii?Q?XKtoHJcP+RnFLBPcsApA2V+5wl+hfzfwf62mpV152Q375XFoPo870Lrxkaas?=
 =?us-ascii?Q?0Pba5rTPKZ0OGl90a++qRUze2RKc1udZZIlpvRsUJvvbsL3ofBhenECbO+99?=
 =?us-ascii?Q?pSycIvgy9Zg2jN6JQWlAKy8cIV7l8LtA6WpfnGaHqTpMd2sLGqL9F5pEBO54?=
 =?us-ascii?Q?cPcShm3tS35uNwr1gvmxg2Ut+OXsIR46KZouUzZNJt6NX6DUh43M87ZcXbnQ?=
 =?us-ascii?Q?sESQ3w29blTNCzytVlRcyMwV3bkSA5fvHBgG0ThhTNRfVv42Hbn83MRcwA6o?=
 =?us-ascii?Q?Tuqj4x32N9goKNj9fWbIGFheCMLBoIJNUJ0snf0RxgQufKZOqPqGoeuWbAbN?=
 =?us-ascii?Q?gOpmbqtxi4ZVHW8qxp/nIxmeP6K3c01nwNkJ9pzgTzqRLGI92N/Sc17eQrDS?=
 =?us-ascii?Q?+/HyEitdm78BuZQD041GL2yHVJdCAAw9O0ZWjXyJKXedHwu8AJGkR+Oc/9ld?=
 =?us-ascii?Q?pLS6+6Cl6K/sYM2SEVa8eU9BC8Vg8hLHGs5r0Z0vFDbmUbUPqL6+ULmB5fXu?=
 =?us-ascii?Q?JX/uIjQM7X4V4VxYgyT2l+3f6jSJpP2uAPkfGmzLzbWkorEp99A2p17b6Fee?=
X-MS-Exchange-AntiSpam-MessageData-1: 5ZBULZNYsoUc9CsfOjcmG6x6X9YxmKWYMPw=
X-Exchange-RoutingPolicyChecked:
	EJITBYFTh5DZFKmnKEIY61og6HOGbG2ZNIqP0e+Yij0wvKPtq8woqvU8FPmtXgnjeQSvVYVAiwjIOKWbgyBbJoIfbiQHyr9AhTvvh2xVF0rls9c873Hxh/3hufTVJGwSB8oyEuZ4CI3Jn8sQWpn1TEhuIf/c+LbvygRYDxbTqMb17tCvFwUriEmrcrvfRu41Uij7/kK9rEn6BTAaipH5y6uF//Z/z1Ny8otL8lZlv6G/jmYfsh6R43oDmh+yrD+x2yc0lr6D2PmC8/oiQqB44bFgWvZYxGE6LQ1FFaY3f8FhqO6iK59ra7jRUwY1M+3GdEIPKDvjkqcRPnt+eeyP1Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ydQR2Q4Up/3F6mIQf9l1awGoAq3RC2Cs4cSJPMuf01NzjC3P2oE+WqBdJhLAf5lbsEHZwU+5KwpAeb6NwfAIc6sOUgu/Ay/Kc1PvdqASWHGJGLcjg1hFiEGmfUrEkfsat/+ZbTvI5fHRkrhDjrK97y3GYWTh/GPEP3ridmg1PiQG2zw5IsTgULvIUEDLvS87fy+Z6/+0n9sigfiZBeyb9Fbscazni2FvZLqWpsw7AFdL/IblKev4R3inMeEFLP7FEkXb0tt29wRa10n9YpnUY0zYdBtsJsFUK0VoZEvVWZkyN9OafXefOC3evvB1eeTenmyaFqgA4+l2Frdd+HvRDIEFL0wpLs8KKduvwD3T1RGvaOVzqTLRzNBxHHgLJVhcrPwu9aQHnL4mZiuA50TakATZ5h2XZzmtomRpxZRH0Q9sWPMFigdke4ajjdMrlGvApXfJKMHZwVhWS/5yjUIyA5+JEOcsj64Dnuj1zfzuF8atAH3jzfkFj+4fVO9ic2e0aooRxnC8qoBXkKk9EftCy6WixmoaGwAxjbVpf9j0BabFYFBlHUSWmNz+oakwB5oiUEnQG6kojl7cVn8r1K7P8kBuyz7W8s5e4a6dTenKPrYI7CjBG3+7/QIF+8IpUT2A
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141b54b0-4abf-4e90-fb18-08df4c98017c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 15:06:25.4461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ad9NppHxTvaD11mXxEsYZXATqzRxon6zJ9f48NdOORXPhEm3B7zmgmvy/tdc49P/MY1jcYQw58PPiKqiPvaTzpZn3E0YXc5h/lYebjZkHik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7960

If the hinted block-group has less space left than the allocation, the
allocation goes to a new block-group and the old one stays active with
its leftover. With buffered writes this happens for nearly every
block-group, the leftovers use up the active zones and new files fall
back to round-robin.

Shrink the allocation to the space left in the hinted block-group
instead, as long as it is not smaller than min_alloc_size. The
block-group becomes full, gets finished and releases its active zone.

5 parallel buffered writers on null_blk, 64M zones, max 12 active zones:
files per zone 3.09 -> 1.46, extents per file 29.6 -> 5.8.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 26f159b293f6..74ba7dd6e560 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4526,8 +4526,23 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 			     &bg->runtime_flags))
 			continue;
 
-		if (avail < ffe_ctl->num_bytes)
+		/*
+		 * If we have less space available in the block-group but can
+		 * fit the allocation into the hinted block-group if we shrink
+		 * it, fill up the block-group.
+		 */
+		if (avail < ffe_ctl->num_bytes) {
+			avail = round_down(avail, fs_info->sectorsize);
+			if (avail >= ffe_ctl->min_alloc_size &&
+			    in_range(ffe_ctl->hint_byte, bg->start, bg->length)) {
+				if (ffe_ctl->ram_bytes == ffe_ctl->num_bytes)
+					ffe_ctl->ram_bytes = avail;
+				ffe_ctl->num_bytes = avail;
+				block_group = bg;
+				break;
+			}
 			continue;
+		}
 
 		/*
 		 * Remember the first block-group that fits the allocation. Then
-- 
2.56.1

