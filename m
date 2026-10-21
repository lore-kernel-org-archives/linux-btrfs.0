Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590147;
	b=JMNLW+BgI1GJ4qx7o4TS31nt3gPPpbfXfm9tutD6FA0CjF+0u8rbWZE1W9fCRuE9JoYp
	 XlAe5OVT2Q/UAZQ/QiNXV74Xd2LsUTBGqF3zaMO09V6pbqfLdsch4Y0pvszDgOEToG7Pd
	 kc0ACCjKjUu+XqJZzjWHmRm8m/7oGftkecSnhXE/r0pS9MwB1+af+0QsUYR/Zg7oMIkTQ
	 9fMinVRgaVKP6ixlMPxZhp3oum1Wlvs6kmn1I4F4LQzjWOrbDtAADH7gfy2IzT+wGc7Z2
	 H5WRJOna3JzN7k5i+ewUNSzZtkNRbrKg3k0fKZ4nr/DCQXWqW1CyRBkNLAMuEqwJ2/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590147;
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
	bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
	b=KoiQ2ErjVuJeJ+xkfjlNSJXK8pEpMzTg7lYokjFmAl1HhpyDoLkMgKtFnKXaXWYlXw5k
	 X415ZfxxwXYDQWzN3PWQ7pei0S4xYYlFzYcq/xQM+HE1+pLNmPiCZ4e7An0azLRPufTDC
	 tmG5EaGlrvnwV77vCzpXKBGcA5lw/1Ab+AlwTmvQO2f+UWWRjmejfgDjoiwm9hNZ+fbD7
	 tO6XLvGz+h/MiYLWJXasN+FfOAFnx0cSZtD2qkhKFz7QmhTq3zV07wfnS0DzXpAR4Pef5
	 ojo+3I7+DqmAJ7/1qYpgYfPr1NFwpwGdECpJJiuCgFT7Y6//VXSJboc8Q4lmHlSKLEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ihJyoSFg;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hUd27cYm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B410B606A332
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B410B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ihJyoSFg;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hUd27cYm
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590146; x=1824126146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wbw7DS6pxoc3sA2jc2RCA/+zAMEhTIuxK5pcieUieaI=;
  b=ihJyoSFgmiQ8qMwQ7SsIitk/J/E+5SHtQ4FhVby3PHUKFXXBoM5IlH2h
   AlDebmrEPsFlRkTWTLPqAasrAHy6/suWpTzwcjzQQLSnk8SYwcMTper3t
   WYSEIAEoAKjgC73XIEuVVwzYa8emlimjg4JIfUmPigiDGzq5F3qI2MLyr
   aSE17ayZ/fC11N90kWpmE1m4hhib6d8R2cs6I/9E6a2WHmi/LYDIayjz3
   FH6JavMWyqbCODjFBo3XwJhVrzrr9lXiPfwHgiI6zMfHa0ybEbK+WpWLN
   O4+oniRns0FT8tMxfwlWDaCCRAIp4nNmaeDHno/8gE56IsnGhuGWoJSUC
   A==;
X-CSE-ConnectionGUID: GKFUbFb8R1qXm7brfUm/vQ==
X-CSE-MsgGUID: G9m2RVtNQQWA7LwQTNcLkw==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601527"
Received: from mail-eastusazon11012011.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rh7E8IrBonjZ/VcrkFxWWzXNY+LKYi8ztWlKJqLaWCB0JqYd368r+pbiK3ADX+hGF/syhIEkiC641EtQYUuLlVyqo6UZoMzZKsPj8u9kffVOOjfudtkCXPcbRLgow753OpGIPinPlIVetKgOOMcSchbiwVM7y6y5QXyN1QMrdchQ0810gR3CHZwKyI5B5ovN7NUHPxf+0Wa5ejUwz6u+H+8mUeoS6B3JWJ3WpgirS1LTdpJnSIbMfXia0uUKXwQfZmwweT+4FOMiKIdG148IIY4/xf+IbdoO5RHlR8X2ZgodustrIa95j19oRhuCA+JsogsaErxfiZ5/CCj+CrgaeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
 b=wZaG+0dcD1QpE5uDD83x8ToJKOXaMqI2zzqdT4av65XPz/XdA6gR4kFQasqLxHsDb4DD10XHHQ9CGEJ1dzCqKfRoKqMKgbzaiNoyLWIJtIG4aYJz/0Rc2HggpoVFKUod2QQy8Fg6C51imMiMkuP0OiaU7XJf23i5Ow8mlIP7VUQluTAtDgV8KZrSAHIs55LBtAIgc8PRzAOpeLSO7yVvlSxS8YyC2ps5Lsf+zAG0BVrSzA0jIFH+gAsMe+rXm48zsjZ15M0m82Yf93Dqvj97DAWiCOrWmHKU/FpfMRi04X7QpwI12jLrBdLWK8yu94uxihCofscnP2uzqAjjKSEuHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
 b=hUd27cYmuswP/rcf5UgA2Fm2FmxffXrnkTNwKdIzuyMQrfoT62/s5LFttPwGppzlkDLz/BWG29feb6SJWyTY42y+rWRAOtFErAMCz9T+GjvmlunRe6XbG2RRUJP9Cvm+uHsrFBryGaEYQe1i3zpEHoMUW6HeB2Wo+VNJ3tqiOw0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:22 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 24/25] btrfs: zoned: don't count the relocation zone reserve as available in statfs
Date: Wed, 21 Oct 2026 15:41:23 +0200
Message-ID: <20261021134124.2338902-25-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993834:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c7077df-8338-4f00-300a-08df2f79223a
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|22082099003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 vCmlLRnRw4bYBwoNjTiFkgJG/AoH3jQoPz9y9I15z+U0JDqkeFa/SVgVj9b4y7vr7lKICy8Cc2BtVj69gLJdLOAyaRjQWjPT6PJxWAXG/xXMqHfxb2D418wUNv9RawPnYitr4D9KX8D9OWFHOHoD6EjZpckp1VJPly84pGMh8LVbpXWdADrZkTtqry3cKQHnMqzWteaovoF+s9uaaTlIMZqeS0ERjM4y4aIFhNQ3K8ct9XK2Ds3ePH9+ZLhr1S91T19uwapZsDqFOgZdaRGhL6AcnTFOpa2hE5ovJMFJw6X4T/rVMEgKQtjPtlriEO6rRhC1oKcfi/GpBlSR5SHL4txjxSaY6Z1GRJq+T0uUVsDiSWqwSNu7je535adzc09NpOuDKwO9pWa9BuEor9EXiUDBxA7SXYZ95m2Tprr7xplFDR864TNO1bEoqGSbgOz0NxPAe5+CiGnd5A0runn3QcURzBhbum0Gz6USwgzD++JBg48oZwvuOFVj//GBQCcJzoPjyWaVbV1opHbt+6/XkJmGWUkINhY7RpGs3TXfN6ugcuvOW6u512nWP1cE1v+yLLYx8WBWzvPFZlSh84lNDxJIAwAXhaIfEC0Mamw9+PKRya9Fk3GW7bK1SPmw+Sqg4gIELQ0RW883WLomYtgkwptpMtEHTStAfatUrVG9bdI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?vo1YhFlnvImqL8I6/utEMCYVVMBqYKfoKTJUHzzi2rTG143hcFe3iNW5WcrU?=
 =?us-ascii?Q?5NWHBBvg9XaSPAxDnsCTmoRve8ayJq85hvjj0pFtX6t/B/pBKkHPYxFVew6r?=
 =?us-ascii?Q?iSExwUV7ZpzQcfpQQx6ZCZo0yUyZOmeyoWsLsaXSVfjpU83dmi0blxBNbT5M?=
 =?us-ascii?Q?3XdRpmDcqZ2y4oU6sID6mAHyIFrZbicWbSC/oZL1zzzLXoWOddf7C6urJyc+?=
 =?us-ascii?Q?jL6Sodjrh6GYkCb9NLN/JaB7t0d+Qd5QXt+xOy4xgy0LkLSBieiW7G0lMUCl?=
 =?us-ascii?Q?GOvkT4RKI2lK2gzfwOoQxk0KXmq79OXJFRC/0kAGygFE3hVVM/RuzisFP+Gr?=
 =?us-ascii?Q?2LOV2vqMDS0iIOMqkCU6Xel5wUr0i/Mu74PHJ+HyQ3ihF3qcdd8XUIAN+c+W?=
 =?us-ascii?Q?ft7a7dS3KQhoAMs7rIhxoyhM4yfoc6YuAF5IfqIyfPKYRG7mvSTu7yjQUtC+?=
 =?us-ascii?Q?knAJEDpEUkMxBOUaxBEVyDhknmK9OTeDqsHp3hEHVj/T3DRwAc0o5KgW17Pa?=
 =?us-ascii?Q?L7uxROLyUjhjWrVYhG4rfCmcm7GKkZXxjMc+9IBgWUlRGwAiwnIlcO9haJ/I?=
 =?us-ascii?Q?UZ4ESVmQ5fcjCfH8jgXEvo793Z4f1ylgACLXzBbpYNnEb+aHIx1bSsClScr4?=
 =?us-ascii?Q?8N8x5YK+HpgaQRK2Car8OcftIEjWdNTbAEkQtOKkzLGkcLY31LbU2isALnWR?=
 =?us-ascii?Q?GL3qbIaY8AbzU782GzzPH1s4GoCXFWIvusyGgJUHzkWTn9oF136Ut+1kAGiT?=
 =?us-ascii?Q?q+wgxMduFElaRMsR3oJiM35QXfQFUlnEtktLpKS45WHL6PfgiLAumSjbyAdH?=
 =?us-ascii?Q?o0RAGnhCrv0prdiFyZCTmVvtmdMlm8R4uMleCbhj+pHHou3frcJLextX77KP?=
 =?us-ascii?Q?CqCfo6x7IcNK1ozzcTXfUhRsmftbeBTWdk0KwclD9YEww5ReLQWFP3MdPyR8?=
 =?us-ascii?Q?VEpcFndWzdFV7+/4Vlb1JJlKEocioisnvvkf+U1YiJ/9Z4oYhvKpBDh4hAoG?=
 =?us-ascii?Q?5Upvuq3yBL/EzfVvblRkIKBIj+E7SLRHscd0Ptu/uNGmhoCYzkIPOMp3iEPF?=
 =?us-ascii?Q?qihQmIGKe50b1dA7KZds4mE4QVGRNBUqPHkqq5RJus7ztIkIFAii36ccKz//?=
 =?us-ascii?Q?D83ylntcp54SqYY6zn4tqin7cDZDGH0Nyx08HKx/wvsOhm/sY6CeFzj3G8fJ?=
 =?us-ascii?Q?CYMTd1jC+nic4diOkV0iZVuYJU0kuwUNMMxP2fkZvY3Xl0ytV4REgIPd0Yr4?=
 =?us-ascii?Q?C+RU80tAHR3KFB0g8xgFZizAYCHEAnkCA/EL8pb5Gs22+fAmFSZt/TNNw7M2?=
 =?us-ascii?Q?yQAgTBtv+5NenwAiQwiYCwu9wjlsGkx6btFMiet+M1Bi4afKa49q/wy6oYd9?=
 =?us-ascii?Q?loMWfsSSq6MiUDn7ubGyAelP/AugvrqssbQojLcjRBUL333WW5k7oEnurXCa?=
 =?us-ascii?Q?bFwcKZPw8iqa5erYJXEtvbt8WtHaq9YQT2u85Ckr/m64f7tinXM17aWglTEv?=
 =?us-ascii?Q?nKUxbW88mL0gTVxIW5NbDw2IWLmCxPGyWAFcCN8pH+2ZU9EsjDrHaAOAs1ff?=
 =?us-ascii?Q?BPpUCJ+ZOve5Z6df1guLNNf2jJVYfdciq7ODKg4abkIlwEatBrsq8U1s1e4/?=
 =?us-ascii?Q?kBuJ5OsVJ9S0nAyRq03cOvRr+QlOUoa/nYfcUWCaUscVCsT2mXUgTfhgYjSC?=
 =?us-ascii?Q?u0ltrre6OHbneAH383E5fNBI5u1i8iFD7+5SkBz16zjI9Lue6a2LyEVMv2OD?=
 =?us-ascii?Q?xtq1gdXSbouydEcDgBn30z2IlR9opi0TwgbQtqWenxahUS0jiFB9Gnrn9mVD?=
X-MS-Exchange-AntiSpam-MessageData-1: UFR5oLQXXtcC5jIXHplg5AbstFoPhaxJGcE=
X-Exchange-RoutingPolicyChecked:
	y5+nWLifItXJWe1vTyogHfEIxLoj2sbSSVLSlQmlXgfPodCdSqoduqh1LBFnD7my6GXG0JmmaJyT+FBIzFuar8wdpnneGvdG7q5QKrQdHz5yuL4BKIBrfx8j8IPN0DaZCHHWpd0ZurzbMDkIno0BbipHY184pRh+SQ8DA3tHhPcG3nzEli8MyGukl7aZ70C0iSSVRzvBdKOofZ91noI+xRZzC8NiyzLy1cytEnzEmaGIaon7g2LH963a8GZP+ilv6mfY/UpvBEyGEK+E89cteYpsVFKPPZpd84+Pgcf0NswqsZ8yMo5+t5gkniz2F3ppf2jGk/2+f6hI9/wrQYWbzA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GRYOSJDFel1bAE+B95BpEUHZy0E0JypyICZQiBwWVoo83pcwmVuWpKRcZiGELFp4cKReSPsmSn9NIglyKWkrHWhTpP8Poent5FbthT9/LunW70j6UmuONSsBY2M6+m8oY2hZafPPyBFZbGcuugN4rScixbJCgB71T1+BFC1L1PHQwaMqDsY5UDXGEQ3lolcnLr+SUL5WNdP/16Hza1g8WqdomwZxRhcNEZGRgKX63UCfrjgEIZb6IdBav0eB0ScO6q/5pQiZ3rbns+kn+lIa0HrX83xaOqtBxkxURVjZzaQ6P/n923iJpn2cXsIsU1+g5eMRslw3qJq0UlRPre+Dq8vUSATMo/DymyarcjvJD73BhjA2+dqk3OkxuViNtAc5RF273/HeofALK0ehFxxTUAUa/Rdt0lqGe5uZKbwSQYWMuGoprESqlZ4XTPaAKQa9/eDBFXvNpf0BdE6cvXsPGnMMsZsZS/j9rZhyKvsbd+s4woVh//nuV201NYHVVtoxmq6sbG3TWjFfWc2o4oLc9YY44sLqbWGgLAQ3JYr/fCBRaZl0EXOG+BZ2XldBAHe5KpNfZKwqqmRjGTLoAAGEp8AQUM6WDImLQlcijEXrFIA2WUBFhg4vg82Mim2YBr2Q
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7077df-8338-4f00-300a-08df2f79223a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:22.6032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Otb7CHFIsSYnYDcTqRpU1elgAukqHxyKv6Cda9d7/5Zfpo19mbeH88RsPu7VfmL4/gtBswS/YdR6NDbJySFClrB0/Sz2/rv/te3ZaRpEBig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

Don't account the space reserved as a relocation target as user
available space in btrfs_statfs().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0c8b8e392c84..16d4bd5c2d9d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1731,6 +1731,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u32 bits = fs_info->sectorsize_bits;
 	__be32 *fsid;
 	unsigned factor = 1;
+	u64 data_alloc_profile = btrfs_data_alloc_profile(fs_info);
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
@@ -1790,6 +1791,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ret = btrfs_calc_avail_data_space(fs_info, &total_free_data);
 	if (ret)
 		return ret;
+
+	if (btrfs_is_zoned(fs_info))
+		total_free_data -= min(total_free_data, fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, data_alloc_profile));
+
 	buf->f_bavail += div_u64(total_free_data, factor);
 	buf->f_bavail = buf->f_bavail >> bits;
 
-- 
2.56.0

