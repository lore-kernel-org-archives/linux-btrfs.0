Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085794;
	b=GA/3XU5YJigoF01XE0iIPXuTKaEktrac52hCYsYvPN7xcQ5LrZCINkp2YwtaS//+WT4N
	 KR+s2Ff3916CrW3wXkxAjs3rsMPwVW50aMi6MtMtaMpoEZ0cymAVxIJs5WVQxIU9cQa4h
	 W71oHRuJjYfbB6OOQRTlHT2uDsrJvqO+m1nbR4mqKE5ESBFBCKm6ZsK4Ne252xWlI6XF/
	 w1riwh4H3YRt6BuzK6N4uUmrAp2aLUX75iMMnFOUuoVOIz9gWpmWDZ2sPbqMKsk9BOfyk
	 YDKu7ggYFfsUQ+MCLJvEHoATlVq8JoL9GDt3aHj+AmE528NUi6fhUk603o+9aOtLBhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085794;
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
	bh=j3k7MfVK34nXlkr3DBpV0+JDw3VQXU0LecW2iZspwws=;
	b=P2/VtNI3PaMVUoFfVjIXFg2SW6FKGon/i93R8iPFQoJ+NIBNvJ/H32mOep7RqYeCnTSj
	 1cNmg2RDKVJR0CkOwHUz6p1nc3VQz6KRErJ+MCtiSa44zSV+Tg9T2xkL9c0OwmSUY+4WL
	 5/grUD4mV2EGPF8Qe1prBZseGDqOzC8c9RWUKtf9/ea1M0ypiBEpIba5XC9YriCXHHGve
	 KDpv6AdECfvF00gWUhnmMIZgmtibweHYI+o8bto7gSAnHxBlGAM8qDF4WDi2Sbo7aVRM7
	 RlgKS+1wZYKHuIWZARhq2RPqNmgqOsgOjhL8sVZOYXCF99tejYTfYc4K+06VYq/0esw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=hfh7OZYn;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=DwF7H33W;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8BC606A326
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F8BC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=hfh7OZYn;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=DwF7H33W
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085793; x=1824621793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zWfje66uQFL1y9PtMLeV6u4NJOJZ0c4JIm9gxGR3HNc=;
  b=hfh7OZYnwrHtzYIy4sJnvVfawwQqID4bUeap4semFgl4F90Laj6Um341
   GMsGvKcGyUkZ7GXWlFDULWknNnGyN/NZ3KHvbwxKK+zkDShDFK4Z7CWZo
   QXlrTpjAkNkMGC11Mp6cCKlbDnpvhukexOUzPFiQ0m836Y3WxD9i2tgCt
   zDlC2Z5yQi0osp9fdVpJG9QRcK/U/UECghv6Hncog69ww/QazvtgTdL24
   I2ZTJZaoHkQzDj0XtC+k0NCAyzPfGMENsnm8THrdZv7RXQ1c/DkfauKOj
   /oKS4+SdA2ZgnJubYR05jJtMdpC5BSbQld6P7DHp/vbB+wT3L9PXZ6QA9
   A==;
X-CSE-ConnectionGUID: /XF9TAgZSn2swDKQWwSxyg==
X-CSE-MsgGUID: +TNFQ2nmSPq5RZUwJYvXJg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="158990003"
Received: from mail-southcentralusazon11011033.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O1pJbhs5axMEwPpZu6Dls7fwbGzRGUyBX00mONoTxUl6x3Dps14++UONVZNLSWo7Fgu33hiZRglz4jeHqwMYkFQdFvq1qordB52ErBPinYV8+LxhierAyztx5FTGuXy6IvccmgNCkYZ37yF+ySn17t7XioQLE7IKeE1xYSwN2COiLYim4K4mlktETOealO+NbA/0rM3EiAGbr6GYhe/kI+3rKBY99SNnv7TO3/0e6eizblEgfAPZHsviM92qf15nFkwisnSFjiGt6zlm0eeTCAZ6eppY7Vi4MRZqMoAJ1CHEe2EmiH1txNwUcDBHccKJlStHM4wFd9jZzSLSNCh4hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3k7MfVK34nXlkr3DBpV0+JDw3VQXU0LecW2iZspwws=;
 b=HY/oxWz74HNTVHuGr39Fw9zqttDZ96YwCpY9LXirPkMiUaDd6BhrgHEKSUmzKvhg+yqXXFhEauHgs4zQs2f+JiPQDNnr7RWFcTjoxt1hUemoHzc2Ouh6OHAWO1dy14i7CiBTVkqxfLZlgKTiPbSaS8egrOe0jaT0/OfXdEMFDeX+Wsexq281zgDr3IR56VE3mgZG02x4ayHZoSd7jU0IxGjTV/MisEIGOTPxVg1u8jmm0jQ3bdwK89ez2EG2oyBtIyovWckAacalYj0exBqQ9ExRsZuLXIJYEd0lSiufAlgiyWCtK57q8aqXQ599mmKM1f6KUNLZE86EaqRzqte6Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3k7MfVK34nXlkr3DBpV0+JDw3VQXU0LecW2iZspwws=;
 b=DwF7H33W4q0bRrXl4A8XLwIORP1Oo7socsd90xPzuQo4TB+S0wdXMZdQbevkPtD3oFMQkO9Sr9bgvTqWXF10ylCMWHNIVj4wgsqojTCU4B/N5aVGfaUi6XO3g73YwZ75lCTHj1tOvvcKur2ATndRnwdO8SIfMKvMlbJ7/fegA2g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7064.namprd04.prod.outlook.com (2603:10b6:610:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:10 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:10 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 21/25] btrfs: zoned: reuse block groups emptied by reclaim as relocation target
Date: Tue, 27 Oct 2026 08:22:27 +0100
Message-ID: <20261027072232.419318-22-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7064:EE_
X-MS-Office365-Filtering-Correlation-Id: b84f20f3-2592-4b38-0fd3-08df33fb27d3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|1800799024|376014|261026121527099003|11063799006|5023799004|56012099006|261021121427099003|261021123027099003|261022075727099003|261022105027099003|261009223027099003|10067099003|22082099003|18002099003|6133799003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	nZub0AghfCrLw7rFIPgu2rf7OVI5+HRIFBekMQt3zkVSOI9tmDN/Bk79PE+TQ42tuJBOE0XyQZ6bIniyznPYEcn0YNTQjYHXI1dYz1RaiyO6QLaoLSpXoOl0SCxopGcBmzV1gVnPs/HBT7xgbUhlRpUy1879RKPi7B7uWtN2fgcHKgpMkOC/6jeQ7TZiegoAU/ojMMTg6kRVEtWs8XmE1oZD7QDX9QD4LyM4AnEM1Ta0YSFPMzrxtJFkkznwvxOKt4c3gkI5qe65n6qFAzvnAldA4W1+U2QOW4xB0OcY9FXjXnhq1BpehhV46UvcIS+m9yXNooqP0dkSYAO8NdB1bm5/xP4dXoRJsrDx4G8MM+EYAPOcVCly/xGp598HCg2c4QNWgjgCYhNpGFcNutq8GNNge1/ZJzAFZx1+B6Q4bRXy6W4vy6Swg9xZNZnKZIFi282f/KG7330bxHIK2F0beeN3+xd8Ns/UMv+WbyqzLl0avR7REJ3KG+frKJEfR5IPJBea0r1plCPlwIAABvW0HJvG+pJ8SR7JIhnkvzO9V1TE1KHbJ3wvk/2YdAFJ5m/7AvaNCVInNzsYXN+D7tjeQzKvJX4qx53MJu0AuxDgRVGD663QhWv+/+ZDyVVXDxFUinoS0KVbcCMsZCLxUpgjPg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(1800799024)(376014)(261026121527099003)(11063799006)(5023799004)(56012099006)(261021121427099003)(261021123027099003)(261022075727099003)(261022105027099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A+9RV9f4keqrQ6eOt1jp5UeFu7iVZ8PthkrcyY3ChmzHG8108PTY3BHruvEh?=
 =?us-ascii?Q?5+MwUQoBHVecgwD4qFQU8TUfEOJsW5+97+lu9me8bcl+mISaN7JdpXtb6+27?=
 =?us-ascii?Q?imf+96MGKhJSKkRB2lAbCO0XXu7BSJFbxtxJH/oo9FRJpxgyjMJgGmmYZ0Xk?=
 =?us-ascii?Q?tmvR4TWVAQaZthZRKDoELeqra3VuvDvLTUWU7oxVLlk90fpNDS29hwZgX4JP?=
 =?us-ascii?Q?B60g1/vxrQsFheNaSsa2L7SxTuCO59EX3zQx4rWnbs2hKa+/FBncDBgVZbNv?=
 =?us-ascii?Q?xNUbrVhVuGgiz5d3qMj4+vgimrUnXFKrf7rkQp+Na8NdY9+uiZi7ZF+AmRma?=
 =?us-ascii?Q?dPJaABH0OqfpB4aGMi0sYniGfC/I/E0+elIbERZIjxhN+ALeSiCY+0VA3gaq?=
 =?us-ascii?Q?EjeiOl25cUqu6e7Ndc3GpbYU1PgjPk4rJgRld6ccLVh7k9TjxngTbxLyGfSi?=
 =?us-ascii?Q?EEXITIO49E5/h018JlRLpavs9pSV4/mnbX041BD6XxTGYUKPs83j/rD1i26r?=
 =?us-ascii?Q?pA7oDlSRiUlXwvXhDA2OdLQSc8NHspJ8SpDWBw509cJlVxZCtpMb+CCWW1NN?=
 =?us-ascii?Q?7ID8M7yg+LIVCYuBfqvvA6jzkEKlN/VWu4u4NjOfaxvG6uEFxw3wUgFZv7lw?=
 =?us-ascii?Q?6AE9ArzIA+wko3m2K9lrK83mltTFCB0DPPdEpjmHZNxi1+5YmH5yM9DWhYO8?=
 =?us-ascii?Q?jTFqlMtTmimKMqtHqzmTiEnVkxpC6+OgvY1Gqd0DGrQoZ3dMNVWG5e5sg4vF?=
 =?us-ascii?Q?T4fErlxQwUZkmpfdXVF/6VTRUuzhO9f1hfu2Y0OrzkmaUVRDQ4p/5Y3Rz64c?=
 =?us-ascii?Q?Sp0QhQvi6GHE6/Zw29Pglfl/V+8AxN6pEf8h59nitY/Pl0AlmvvpwVIZ53NC?=
 =?us-ascii?Q?IKlCiL5raSkOS8//O7ITjG5i+V5mFix8dkK8xVae8Gj1HLpKu+kMkwlZCqn6?=
 =?us-ascii?Q?y62XL7ZPdDEb2P52Tfud9rcSGoSnbJQMw5LRSvHsIVOrrGsGQ/BZkUGy0bFf?=
 =?us-ascii?Q?5l9IoThWoIec5EifKzgJ9rEDHK1IcBpQP1tFeFGEa1ZLBiZDqf+HLmymONcp?=
 =?us-ascii?Q?oFLpe/nXKIyarO+t0m1DH6Vg4xOtgB7jlr9r9ZiHqCsoJo8NZOC1o/QlMeX3?=
 =?us-ascii?Q?n9fXwFzZmrOS21d4CJ/QDZVQYaqCouHgGaAElYkKhNxYeKUtmoCTn6vxKKIC?=
 =?us-ascii?Q?gQ8tKbXQxtDy0PFP9yXKa7Z2YG/TKxcFVSucYR3R6FelqxIM8rvZWcLQ7CrJ?=
 =?us-ascii?Q?uqbWa2HoqrKj3GkbaSlpXsGHcylzDY3bd5uZGL0g3R7bgQaUCwiulEL8ae7L?=
 =?us-ascii?Q?6Wjnz74UfKiOe6CQ/LaNMHpP6OE4i2svVeu6VsmjooTOMCb8xjPeb52GkWjM?=
 =?us-ascii?Q?1oWj3uWNWere9wLUqSNO9fg099E/1s9eQBl+BwJhc6pI1hREW/FV3HLmOiOQ?=
 =?us-ascii?Q?6rVqMpI7Gcrf6fLIRyTT3wMISE1yzPIPeHo3VStY3KEvbz1rGhdCRW7F6zCj?=
 =?us-ascii?Q?vWJuqP93b2ACQx/lA1TWOb5r3BwoL5uGfuX4SbfGc+Qt25lhWRrZ3/6k/3kr?=
 =?us-ascii?Q?hKPE12fnB22J4sNgzru71mB+zXP3mhyqXcw7FD1PvoSOZaULGil/e1vahzEF?=
 =?us-ascii?Q?TzFR/EDTXvTlqwHaIdYxrW4U4yDdCBXo1925w0nnA+D8WQIDLapm6HDD6kgX?=
 =?us-ascii?Q?3/kGA9Lsz+PiT06Iy1FNIFqlwaWcB6l0voctLcgntpXSDAw/3jt9ZuWm0xRx?=
 =?us-ascii?Q?6qoHo/78cvf0W7cKlAMz5jolP4XXSgTKN4fMhNkFxYJhq+T7336rcM9bauwH?=
X-MS-Exchange-AntiSpam-MessageData-1: 3DKmVQ6m1kUSl230ieyTx4Z0aY7YdvcxFyw=
X-Exchange-RoutingPolicyChecked:
	yYe8XSmmCvoCGCkStw01LtGhE9QTjdOKWXHBEnThcy51BJMCTM9wIjkSyO3/1Em8xLLXq4/CEH+5V3pfYwDBFQjfppVToOZZ6E3xKMlqz60e+6h8iLX3G7yvgrFSylAW9bR+R/5oKWNSWUbCsJ+DhryLOHXV3OiyMcWsnE3V1cTEXIFIs+n5jdlAT4xv2+63QhPQOMdvLRvAyN2Sm4tjQkXvdKL8g2wh/FtIKhBnQA01AMTGu8KtbIeF5f2ioW2yZWtsXlziNjbALKT5dQ7OGZ4NMeOLPo62YlwN1JKJiSCWE02Nnyg5cCpWzbZGAWx0jQvrrVJI6nPwSuDIEIHNqg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z0pwFPI7XYOGOsXjPv2MWGYHggLTSvxvUKPCRjsV8kUV/8F+MYQwyKWrc48GCH7hr9hVy8YPg8lLbexTpSzWjli8XXRQGxO2Q+ijmka7C+QUU5jXK0/l/ZbPlyEyl2mIZTqqi83hP2AzZmlv4VjAyTvrdiwqx8iRv2EYM5G60YVypKEd+Gy778Pu+gmI6Nj+5Jw637YDvSG1KJ1ab1WsXvkXV6NOKWAwh9Qp6vMshDwzS+7oyTwU42dR4/D0IqUpi+hsqitLe2W5WIibWwLdaiSSXDYvwdwhM31B4r4IS+tQbjWvzHaRnbA32AJHYw4Ul+FAfw2I/8InH+49r7ptN1UQdY8rVkiQxlRy5lsn61QpkWTJLfmPn65pdmO/RgYcX0fcAcY6FHLvEAWCmSk4LQGH7nnsItlv8HPZeu/H44NNxJs5mYPEwskV6z3m5ip06LIjLhSAuTSewHNL+S/3bK1M67qxsm+LW9lFIGrRjggBeIZ1WvdC2882+moZNiXJH5jtbPjN0uaV0Ga1n2TdHskVr+R9m+rol2yKNnb28PLBad5kkGXKTEClLJN145F6Rx5wS8JisrRj23JS8X15gI4x8JLPhY+96LiA5SG8J4YyZ3MIEVB+pfKmCwbiOTOW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b84f20f3-2592-4b38-0fd3-08df33fb27d3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:10.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CftU93wNjnZqLVGyYAWoSDT14XhjCJdDw4r5CK0EmjKzsFXniRXO77bjxWj5X+O9NKRlnWPHuNWJV9v+/51NqsByN2LpdoCU3dSSpwd4zsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7064

When the block group reclaim relocates a data block group, the emptied
block group is removed and its zones are reset. The next relocation then
needs a new data relocation block group, and if none can be allocated the
relocation run has to be aborted.

After a successful relocation there is a free data block group anyway.
Instead of removing it, reset its zones in place and use it as the new
data relocation block group, so the reclaim always has a zone to relocate
into.

Mark block groups that are relocated by the reclaim with
BLOCK_GROUP_FLAG_ZONED_RECLAIM, so only those are reused.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 +++
 fs/btrfs/block-group.h |  1 +
 fs/btrfs/volumes.c     | 22 +++++++++----
 fs/btrfs/zoned.c       | 73 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  6 ++++
 5 files changed, 99 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 3f7bee1b15f5..68844f26e2c0 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2062,7 +2062,11 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	spin_unlock(&bg->lock);
 
 	trace_btrfs_reclaim_block_group(bg);
+	if (btrfs_is_zoned(fs_info))
+		set_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
+	if (btrfs_is_zoned(fs_info))
+		clear_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
 		btrfs_dec_block_group_ro(bg);
 		btrfs_debug(fs_info, "deferring reclaim of chunk %llu", bg->start);
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d567ed822e55..ef7d9d04898c 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -88,6 +88,7 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_NEW,
 	BLOCK_GROUP_FLAG_FULLY_REMAPPED,
 	BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
+	BLOCK_GROUP_FLAG_ZONED_RECLAIM,
 };
 
 enum btrfs_caching_type {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 09449381fe2e..9721efec4e45 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3711,27 +3711,35 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
-	u64 length;
+	const u64 start = bg->start;
+	const u64 length = bg->length;
 	int ret;
 
 	btrfs_discard_cancel_work(&fs_info->discard_ctl, bg);
-	length = bg->length;
-	btrfs_put_block_group(bg);
 
 	/*
 	 * On a zoned file system, discard the whole block group, this will
 	 * trigger a REQ_OP_ZONE_RESET operation on the device zone. If
 	 * resetting the zone fails, don't treat it as a fatal problem from the
 	 * filesystem's point of view.
+	 *
+	 * A block group emptied by GC is reset in place and becomes the next
+	 * data relocation target instead of being removed, so GC always has a
+	 * zone to relocate into.
 	 */
 	if (btrfs_is_zoned(fs_info)) {
-		ret = btrfs_discard_extent(fs_info, bg->start, length, NULL, true);
+		if (btrfs_zoned_reuse_reclaimed_bg(bg)) {
+			btrfs_put_block_group(bg);
+			return 0;
+		}
+		ret = btrfs_discard_extent(fs_info, start, length, NULL, true);
 		if (ret)
 			btrfs_info(fs_info, "failed to reset zone %llu after relocation",
-				   bg->start);
+				   start);
 	}
+	btrfs_put_block_group(bg);
 
-	trans = btrfs_start_trans_remove_block_group(root->fs_info, bg->start);
+	trans = btrfs_start_trans_remove_block_group(root->fs_info, start);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		btrfs_handle_fs_error(root->fs_info, ret, NULL);
@@ -3739,7 +3747,7 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Step two, delete the device extents and the chunk tree entries. */
-	ret = btrfs_remove_chunk(trans, bg->start);
+	ret = btrfs_remove_chunk(trans, start);
 	btrfs_end_transaction(trans);
 
 	return ret;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a42d4fb8d0b7..703851d2b77a 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3058,6 +3058,79 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
 	return 0;
 }
 
+static bool btrfs_zoned_can_reuse_bg(struct btrfs_block_group *bg)
+{
+	if (!btrfs_zoned_bg_is_append_only(bg))
+		return false;
+	/*
+	 * Only the read-only references taken by btrfs_reclaim_block_group()
+	 * and btrfs_relocate_block_group(), nobody else (scrub, balance).
+	 */
+	if (bg->ro != 2)
+		return false;
+	if (bg->used)
+		return false;
+	if (bg->pinned)
+		return false;
+	if (bg->reserved)
+		return false;
+	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags))
+		return false;
+	/* Once read-write again, nothing must be allocatable before the reset. */
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+	return true;
+}
+
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	u64 reclaimed;
+	bool reuse;
+	int ret;
+
+	if (!test_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags))
+		return false;
+
+	if (space_info != fs_info->data_sinfo)
+		return false;
+
+	if ((bg->flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) !=
+		(btrfs_data_alloc_profile(fs_info) & BTRFS_BLOCK_GROUP_PROFILE_MASK))
+		return false;
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	reuse = btrfs_zoned_can_reuse_bg(bg);
+	spin_unlock(&bg->lock);
+	spin_unlock(&space_info->lock);
+	if (!reuse)
+		return false;
+
+	spin_lock(&fs_info->unused_bgs_lock);
+	if (!list_empty(&bg->bg_list)) {
+		list_del_init(&bg->bg_list);
+		btrfs_put_block_group(bg);
+	}
+	spin_unlock(&fs_info->unused_bgs_lock);
+
+	/*
+	 * Drop the read-only references taken by reclaim and relocation. The
+	 * block-group is full and empty, so this leaves it entirely
+	 * zone_unusable, just like the block groups that
+	 * btrfs_reset_unused_block_groups() resets in place.
+	 */
+	btrfs_dec_block_group_ro(bg);
+	btrfs_dec_block_group_ro(bg);
+
+	ret = zoned_reset_bg_in_place(bg, !fs_info->data_reloc_bg, &reclaimed);
+	if (ret || !reclaimed)
+		btrfs_mark_bg_unused(bg);
+
+	return true;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 31d1fcb6303d..74c9a4c70d26 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -106,6 +106,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -294,6 +295,11 @@ static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_in
 
 static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
 
+static inline bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	return false;
+}
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.0

