Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211704;
	b=Vlf56xa4Ykx6CbiPYEKhQIXDSVQkZSzAhCapzuMcARLcUZxW4S2Ba8NEOUrWR4rgQDK5
	 nY1KjSv9ie1ZCsS14ZrrX7vGEyPY5199I99Hgy14Q9uk7/KB5Gz8/JrLnQlIObtBkJDQX
	 vMCSaSM5r4vfTwDEV7CEfxB6weCIN4pQkXFLQ/KQoTCY3VCCUSKMGzrwVHMD1dMimxh0C
	 KfhS7ashAq40z7eDqBKi1ckOa+lYOqX3KD/TxyOKyvedwFBCOzjl9E1OntFVZ1aDscq+V
	 OyTiJ5EcIUuNQ2DBnjbYgijVD51rwNseDh1x+cdpOGJC2mcqiY6fpaeMZWFPjTPfTJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211704;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
	b=MOxRNLWAiVNfuyefHzl8jCpSTjgBAIU9ZQULwV6iuxu8D/LycFubhOUezUWMJmNixYEd
	 cHw3ZZHJLgkfkgUkCFRLNq9SU5zglJ8J0U89UlBAww7TSn4YUrZMlvH4vAuyMXxQPpQ5h
	 EOJzvS9hoVu4gW3b4P9Pe33+kfgWJN+CvW3soKmSM93yCBKW135plRjG8zFfM2SBYcGlq
	 NqqRU1S0FeWHn3dHQYT0ACpVAL7O98EMlUJYxfRMxKPRVhnrltTHf+pzswdQSVD469Zpz
	 ZCJabmm3snQGRrB+Ge18S2GHA+YDcc9snI6YgBlDM5mMg1vcNuT2tT5plft4X+JbWDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DmQ3+ZXc;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=VRMCO9aS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48E360A2612
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B48E360A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DmQ3+ZXc;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=VRMCO9aS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211703; x=1824747703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=n7Z3S3UVq77GFxPux0/6hqx9Zoiz0xtpnnqUlX9oMUo=;
  b=DmQ3+ZXc2TC7pTRATinvaPr408n5dK3gi6ihvj0rtQvvqQsE9+b2Stev
   FdzZIUbqdDGn+4O7na45izh659bLRjBg6hQUvepugEEluQRxhmIr6/b8g
   ye3oUgYX28JZW2oIIyhqc5RUTGEvex4npIfg5jd7KRlhhnJun9Qw/0/OV
   7MavlJAXA+ce0zzp960RE7BTcvGjfRCLDVJKcLY/BzBqlpeE7kkv6joPu
   0F/HdC7lkV919rsgcy2pL+kPSMhFLh4XlXUqM/j+IOi5c711y9BPO04tg
   WS6nka2DC4Mt82in7Fyb7BDbFlm5KghREkHRR4OO6myVWyVDz62aYF3Zl
   g==;
X-CSE-ConnectionGUID: lfltjh/7Tmy5E2yTwaJZcA==
X-CSE-MsgGUID: FUoAG7OxR1C6qWlwM/XSwA==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194164"
Received: from mail-eastus2azon11010053.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uf9e4m4EKFaLBqOWmGCTSyOKtPxCvqSXMGjPZG+PsQ1JhZLvsFQaBuB97kPnbdl83FqFbjrUA8Dz2fwZ5cXcBg5ZAd/byH+/uLryj2eFsG49dvrg3kqKPz7LnJiOX/PDFWc47JIABdNNPenchS6IyLDNsvhaqSzKox232mwgXTsw++aA3zjCNZdf2bXUwIGGg1N4gkLwDoEJh4GjIR5dG+LNssHxudUODTar5zppW5NSSxzLqMOkvU+3seY4aak5J3UoWxykWviKfYDgEsRFA9Ua3+otFY0AEs+LJUqOdHJtRNOe/rm0Gwzbpk2Lc0XmMogBmRgxEFcKxfOK1YMBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
 b=iZw3ixQCMAIU8DIki+nw2cr6rL73nLfWVXEZ4Auy0mvp7wS01mcN7PQwnHHVzBE0BfqpNjnaCXU/FA1f8JBBhXg6uY5PUgAc7E39tYsIqdF5ssB+0pU5rHhGAQpdQLjeoZfj/IcrvY1PcsaEF1DPfHVxDB908+/QBWXj1rrudVncSkbuNOYEqWEvTPsDVJddmocKfwaYNyVx61UUAc3yH5Kf/IfidXJUhimIvBu67l+Xjl3O+VjloWxvEZi6sUaFViR8z6b8yJjXbb06sABDDQ5zApu1GnyOF4o0dTGWbVb0ZkML5YbSNcS/YP3O9tZMQ2EfEw8vOTzSuB4nLBO1BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
 b=VRMCO9aS5RezUFFwl1r6jpiO4AgShkmMNnIELzomrnLyhzqYd+alQf3qufkaMPY4jtSqY9TdKIJnpaeDdgmuA1/f3ot3AWjWDeqOHgZfFpBAYiyYXq9hyPj/TZzPW9zWTjUoDMiKXsQo3LSMURVtI6tqWWPYjWq+b/cGUBsyz2k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:37 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:37 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 08/25] btrfs: zoned: prefer conventional zones for metadata chunks
Date: Wed, 28 Oct 2026 19:20:54 +0100
Message-ID: <20261028182111.160492-9-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: a26a4a70-1f3e-40e0-39a3-08df35204e2c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	NpDldMj7wzNFCDk0mLkIZ1KJ2BeLkVLu8K8ZP34ySjkjOtDHHBM5IDWtRO/+HI2W3O3gUKZULB3Xm9R7UR8RWcC+NHvR2fRXhsUfVQB6yBfzzOgFKuAYi5Ww4JiXs50i+vZZoIhAR4q1WzW4MRnTRoRblHbvylsKIu0Di6KucX9oLqI3fXWWDh8Dl22DWYnUEvEtb7zucedoIGci/6QTCOqNe8ys5dixKv+vfTIFD6trxc8JKQ6hv5jmLfIG1OENbdGuKJ6YncfTdDxP8tIPyZFb+CxW7VVLS/gZmLG4jXlloFec61Eg58QI/WXVJpWKRQmcAxN64pmNjtTS4LGyxx66pMuDbLqFUZM4hxTDsIAOOseHZwRSmfRA4PHjRISM2wFFiCBggAM1A2r8yrINn/FIGnVqKpmdICYzoUuHZzhELXDHHv0A25Wvvwy7YHPXOVmC3Q32mTmThoUvPEqfYJhrNj8aqjEB0gYyBtFJdeojMF5lU5pVvCEtW6JmjGNtBdH7ILQKDx6iap84q1R22EsPC35uKEAjBZ/ILZ/Cn2xdH+dMOOC/yTixwi1I97hJUl169fokJ+NQnW0lKpsRaatHKJj+3HCZnFKbSOm09GiAgSpuWTX4IEhGm0D67AlD6fPnZhIl/JpADOmeS212uCJ3lifvgxXDCdfaqbWvcU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vUJvvMcg3qjj6+9LJwqN44D/JUez0IPIXrFWH/Uvh/9/Fh7whUtRz0OrygYk?=
 =?us-ascii?Q?uyT5RatQhV9/xBTlix+sH+pGl8SUzt8xlRYKZ4C20ql2O65IW+7hhKZ+S5p4?=
 =?us-ascii?Q?LxrmhF+MXgiDOU1Gm8L1+otfbTsTh5ikn6jv11HUT6RPoS0s0fwgeAQkySRE?=
 =?us-ascii?Q?/gv+I3Hn1vF2mw93MQ6+v7HJfzyJ2DM+8uYwIhZj57e0NpVZ5gb0TXgSzslW?=
 =?us-ascii?Q?eFvISu1uMYUocy5JaKOaGWwsev2GQh1a0z/wiOL7AfueP25uU/ZSq37mTRUK?=
 =?us-ascii?Q?i2lUAOlQTIzJkCVm0J4aSY+5Pvwm6AUmGn8oHPNvnR+rqVer2x/Zb/wnwYZQ?=
 =?us-ascii?Q?V6jYwBtD/+eUfjd0BTsmek4Mvs5x0Czkz7DjEvmJBxw+3HcMJ2HkRKNB7Sot?=
 =?us-ascii?Q?tduQJPIjXK1CZfgfpULPR3+Uuisab7SF1+AhJKGmkZZ7W2+ihEdKZOJ6ikvN?=
 =?us-ascii?Q?QYzVZgxbii23wnQ4Henok40zv/5prGcb/bnDcTPG3Id2zC0S/XuAgMrQyQmn?=
 =?us-ascii?Q?RMgEgctoAi/8RIR4JqArSN3OvKt9/NMHj9y9VHUd69vqKWR0fnXz5imFkv0z?=
 =?us-ascii?Q?nsK82Cn6vJZ4SUFPjEnO7YK6HrKOB9UH819YEAGq4E68vqF25sdZ0Y7Gv3Hi?=
 =?us-ascii?Q?Q3a9oYA2+uLuYtATcMxSsnyhzhX7rqNAKrkqB1M0hxm3klDnhs458FL6ynnk?=
 =?us-ascii?Q?n0L913gX/LnrzGKj1r8WcCQ99DcOBy6KBzLv2NHm8Ac6vCe8QTrnNT4kufi0?=
 =?us-ascii?Q?vz7l6v7tb8YMEsYNAmOEbd9gb5CGp3ZI85YbrG3bcczS7HfYn++URpM6G/O4?=
 =?us-ascii?Q?CzgwFOziMGVZo0vq6X3XKHHCZbGFfxk3oXVCU1FD2Ye8wagymL5GhZKHMR3J?=
 =?us-ascii?Q?V3gh2epJFzspslWdhkHpDebCLI7s77I3WPYH59ApJpyWSdo0So1KlkMQlDTE?=
 =?us-ascii?Q?bSYXNiKEsY2ioUD1fs2E2OqdQxA/4+YHjwKAWcu17CS/0n8CAA1iaGcQxvZA?=
 =?us-ascii?Q?SnUHnmS/BZ1kpt1CMhus6kzwufXCheISOny8xV2uAFYwMGUcpxbq3Cv2bBe4?=
 =?us-ascii?Q?RNrgxadq22i1naKLQPWrXdOUteBzNmMasSKSIM/VHo/1HWDkTA3USNneWUjc?=
 =?us-ascii?Q?oDyMXo9Zb3wRW9xs/JUU9zjDEJHVC6zaUDQYVJF/DkBL+ae5X28n2ggWfNpG?=
 =?us-ascii?Q?qlimNZZW3fr4/KSJLPnTgmwKzC5ERX1f2wDr9RHqFo94oVgpjDj9xNMgcIsq?=
 =?us-ascii?Q?KI0fN56ezl0zqRikfU+3XcTBaWV8WHjzHpP9JMh8YaA77NCktE5q5wj3QFDY?=
 =?us-ascii?Q?ESqlYuq2HIt2Pw1jDG0JNuKHBKZe4pgqyMJCw1PX1FSoKbT6HYY1m4e9SCDP?=
 =?us-ascii?Q?Wt2BqeA68kajO11Nfg11OMN/TONh2fYZRxcAaoyyUdVsnJtEGgio8HiNhU3J?=
 =?us-ascii?Q?thKC8BYvLIV+645cMo+2vPQ/9xjcff43yVDjPuWhoeDGlwq4razLdJwxbka2?=
 =?us-ascii?Q?r+au8Hgc86c9qgKRdvR64TaZh7Lz9uDRcB+5D9DI6N85prbyW6vZb0lYBKIG?=
 =?us-ascii?Q?Qy3+u14+ASt1UlU8hJXfMGfZ1yK3oQe0q7XvHpmvxfgxCMYB285u0Zp5AGxY?=
 =?us-ascii?Q?K9ayIPMOltb11RYmOr/HmTHmnAMkzHjEzfAuoVD6tpk8CU/HnEMsRS7GkiJJ?=
 =?us-ascii?Q?8ZebNjhexTnE/JXTm7NeyzO8QqI6Dfe5WJ7oDkktLDEGbFkWVZQa8UeWVbaK?=
 =?us-ascii?Q?PnFJup2EO4BjNMF16DypSS6zsFHK0xwnfDCPa0iGv/xFjfWcDGwbwdm1FTHP?=
X-MS-Exchange-AntiSpam-MessageData-1: lZYWJ3BV7h5voN2bEmfJNvuLGBoiOh/d0uM=
X-Exchange-RoutingPolicyChecked:
	jkIV6q2kocuzegDZsoyvcAWbcKsWBRDmTwMb1PGjzD5ft4kDhv7TsbP1I7vfVJjTd5UdmyOzGSI74NRKbbw2M87SBZC39w5Dvx5rVOfcp+yvHWPwLf3npQOoDh0H5gjXggPqaU0kRrbaVOlDo1r25IOAIbWbXmmQrGpcsyYmcGJkrDusodm12y5rJ+G+JD3DeVhVr26/yJ7uoNie9BdXg/T0Mf6fCQrZ568bbBXYVEBhoJmW/Xikg5dVXqy0IaVSN37CKrByKvMdHlpfu0oR7T6WrYhoJuSHKgKXIwPvILS5jqj1Z9eCxHp5BkyFFz25jhHR7l4T2x38M4uoxw8suw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wxuHAsoZ0w9Zp0KWP0BCNM4lST8PrgliH13rWuqMJeYTIwd+1FsGrC1p3y2dGpKZpBoO76B5lhXHRX/Ci/iDvL6NFpi3sUM1l5xP1LVu/WckLMtzx1XSvypTGnekCBxm2i8RdgB1Tfpr+cL9XOyS/IKC3AzpnjBsPrzCUOEgq6m6TsNv9bsLMIpXOtW75/pjK8VDBDHdv7DH4BDFJkcpyE657SNjt56+iFaF0cPF71ypHrDj4UlfeO/Aa2i+sXY6eZZJeQ+m7jl/B+XO4uwdbFnrHHvIJ/tzwOBDm+QEsZY1UCJ1Rk6z1a/94iW7rN2q4TcLSJoimcmEYR4aAhcqzTkuaVhqGKN23XxE1BNJr8VYpTgvu2qHg0j+m6Wh/c36Ttj4sG09Y8Sp/eQ3paaJobvm+UHYxoPqG/oyr0V0u7UwG5xEECMeiB9EJOzbdDxC5oB0170PgvZCu9I5fXK/2dRGQjm3lYcaishYNFd4l+mC6QYFWylVB/7lc7FOcvumW40V/oBwrBdrvJbgcYYxOFtQwWRXUMuPmDxxvCEl+SQnTXSm0WT0MZ/lvvtPyBgUcyhOE+bQ7q848ry1yEakj20x4q5mCZf1OVwQcWfrt6zWC78/9gCKof9RHKx7mcU6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26a4a70-1f3e-40e0-39a3-08df35204e2c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:37.7804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxLw5cWSgyTDakM3oQjmvZeiH1/0diQL9jdCOwgqrYgrPcYviT6J/O0yJeMAL4r6WxkdWwqkdsCv19ZfMeGO0zEOf/4iigBgV0F5oROpc20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

On a zoned filesystem metadata and system chunks are allocated from
both conventional and sequential zones. Metadata landing on a
sequential zone has to be written append only, in strict order and with
a queue depth of one, and freed tree blocks cannot be reused until the
whole block group is reclaimed.

Try to place metadata and system chunks on conventional zones instead.
The device extent search is first run with the conventional-only
restriction. If that does not yield enough devices for the requested
allocation profile, the search is repeated over all zones, keeping the
previous behaviour as the fallback.

Skip the restricted pass if none of the allocatable devices has any
conventional zones, e.g. on ZNS SSDs, so the device extent search is not
done twice for every metadata chunk.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 41 +++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/zoned.h   | 20 ++++++++++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1fa4ee803251..76bd54af8720 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5897,6 +5897,29 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
+						const struct alloc_chunk_ctl *ctl)
+{
+	enum btrfs_zone_filter filter;
+	struct btrfs_device *device;
+
+	if (fs_devices->chunk_alloc_policy != BTRFS_CHUNK_ALLOC_ZONED)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	filter = BTRFS_ZONE_FILTER_CONV;
+
+	/* Avoid a pointless first pass if no device has such zones at all. */
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
+		if (btrfs_dev_has_zone_type(device, filter))
+			return filter;
+	}
+
+	return BTRFS_ZONE_FILTER_NONE;
+}
+
 static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			      struct alloc_chunk_ctl *ctl,
 			      struct btrfs_device_info *devices_info)
@@ -5905,11 +5928,14 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_device *device;
 	u64 total_avail;
 	u64 dev_extent_want = ctl->dev_extent_max * ctl->dev_stripes;
+	enum btrfs_zone_filter filter = chunk_zone_filter(fs_devices, ctl);
 	int ret;
-	int ndevs = 0;
+	int ndevs;
 	u64 max_avail;
 	u64 dev_offset;
 
+again:
+	ndevs = 0;
 	/*
 	 * in the first pass through the devices list, we gather information
 	 * about the available holes on each device.
@@ -5936,7 +5962,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail, BTRFS_ZONE_FILTER_NONE);
+					   &max_avail, filter);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
@@ -5963,6 +5989,17 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 		devices_info[ndevs].dev = device;
 		++ndevs;
 	}
+
+	/*
+	 * Not enough free zones of the preferred type to satisfy the allocation
+	 * profile, fall back to searching all zones.
+	 */
+	if (filter != BTRFS_ZONE_FILTER_NONE &&
+	    rounddown(ndevs, ctl->devs_increment) < ctl->devs_min) {
+		filter = BTRFS_ZONE_FILTER_NONE;
+		goto again;
+	}
+
 	ctl->ndevs = ndevs;
 
 	/*
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 5f21a360f23f..e99786b29587 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -332,6 +332,26 @@ static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
 	return test_bit(pos >> zone_info->zone_size_shift, zone_info->seq_zones);
 }
 
+static inline bool btrfs_dev_has_zone_type(const struct btrfs_device *device,
+					   enum btrfs_zone_filter filter)
+{
+	const struct btrfs_zoned_device_info *zone_info = device->zone_info;
+
+	if (!zone_info)
+		return false;
+
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return !bitmap_full(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return !bitmap_empty(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 static inline bool btrfs_dev_is_empty_zone(struct btrfs_device *device, u64 pos)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
-- 
2.56.0

