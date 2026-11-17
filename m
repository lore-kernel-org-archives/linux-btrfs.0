Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941996;
	b=bNbmbHCQ3gIDWE0y+m9MV2n7Gw4ANElmHIb0pJwZ8f/jnfaMYvn2RAZJrkb+iIKRakNV
	 neCuqJZW4t+N8DafTLY3bGqKC6+AuBizhufN1H7xxGBJhwT1avjgv0LJO6Elr3DsxlrmF
	 NSLjEtzpPKNZyqwT7+eDvEI5PNlp2vdK7vAHazObVvh8AYPYxSWvZpdxCs5YRNELnwb2v
	 Z/GbHAuUeC6ngHmUUS+XnZpnmmJDZuYUoAvTysZRfNaZBFglMNaOcOKf7A2wrm8YFXesB
	 3O69MN2H9/miVIFfiV6kUNwTJ4jQeD9Xt5WnbxOh65up5c3eyyVh9QXixq4KCdsUwxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941996;
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
	bh=3wfl4Lzwb6XVxycHRpFhqSFuIfxZZovkbfCH1CWOL6M=;
	b=UgzAehY3fB0A8Z2kKKX09rk03K8oy/PpvZ2QaCCDRxC1xLtC2ftGNrp0ERxCMLdg97Rj
	 M6ADzs9fYOhp3la7U9NqgGp8xFJpJtrwqbPSlaOCbydjar5CZ7rvlFOIIc4xolgpeGT+8
	 +P3/0KXxT8DzDOjJkEvRJ4mu28s/KjCqZBkkkoIYIUFTc+7u0UfMvon1t0i/9MslMC5V0
	 7RTR3UmSjZh1v2WU6WfY/LY+kl7E1dD7eHiag6LGk56b13WoVA7uUfhjvnJrLsq4hhfZF
	 jlopULWjurLCpZUa0rgsX6ml0FNRxNwfBaE1jZ6z5gN0SQVEeJxEgFEChzvg/raJoTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=RMYcHYK3;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="VEbUlyU/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9885606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9885606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=RMYcHYK3;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=VEbUlyU/
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942003; x=1826478003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=38aFEOoV6O2ttCaRPORgB9w12/kHHaChjFdJ7mHgNdY=;
  b=RMYcHYK3zd7ytR8+c3z/kzmsrFo+kAur2RaXNh20cgILjTNmc3umF4Og
   4BYkhSSV/Yrn8h+yLE8bEhSRxjkSzDKlP6d758OTeGKWrhwapoBoE25Du
   37iV/IzIEQeiy11EPEH6BoniLaFa8eHGr76XZF85DLTaWDc1+nNz6uwio
   IZGE9BPaer19U7gfU3T7eDJJqR0WpmAYC74g/umY5njB6Eh7OQ9LcR872
   WBdv6XKfL8MILVW9yfLGPmYfRRKmiAOhNrCASYhpCSui0QBVqzs8Q9g7d
   Mwp0nmEYm7JP+fFk7301iKBprXNrDSaign8CaKyHBKIIFtswc3n+UpI7g
   w==;
X-CSE-ConnectionGUID: TQDkkJR5RT2EG/75A1I8/w==
X-CSE-MsgGUID: 19oqrAYaSbewhD2GTG7clg==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160149016"
Received: from mail-eastus2azon11011025.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kv/Yfu1FVg6npoOfH5KRTf6EhDbO/aePvZQzY0HDxLW2oFvCA14DpDY/MZ4dhs2LjZszpOw9SHvOe9KuPMKGerEhCDebQ70ucMrf5NLGFFRXkQOFqHDS6YW3WJXh1W4F0SQ9wCm5X5zvvZt8aOzVOunZwuQ9WXXb/mhPywV3P7i1Cp8tLtK3wx+gxeiu04Vn3+11cDN7aKexDeGJUFA9264EbW+Fv7YyYi80A6TI4/DgVgYtawVkO+91S4B1MydQHpG8xTjNEhPTZ5lHiXNGnQrkoQl4fCtC2BNsneWVBXY5EXS7U1kGrkRLH2LgKqUYrQ9lywwPQO5vsva+Y2RmLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wfl4Lzwb6XVxycHRpFhqSFuIfxZZovkbfCH1CWOL6M=;
 b=NYPIN8/yyTgwNQ85DiVwntOOqwMgEZWTd2NrZl9B0e1V6/Mqbmg6abtEWIcql2vKhwm7+iiayAnWxfEPNEVCJvh96XRS+vxGSbjXf8MC/2u9vJIqjkBkCgvJp+CSgzIFNon5dK3c+53Z1CBvNa+FfcedBRPQKzieMz9uV7VM3qhBUcdWtY2lWiizJaCGUAjkOQowKjSgkOofPmxbBNI6IW4taPu0UCUw7LDCLIyshXknGlxxHYzEUQQ23EjfvEkVV9GUVBnS99ueKjd0zMYEpD90G3D6UiKaiGzPqmCUePN6hRRWBPjjleYzceIzYGX4QUOxcw9kn3bFFyK/VtmdzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wfl4Lzwb6XVxycHRpFhqSFuIfxZZovkbfCH1CWOL6M=;
 b=VEbUlyU/KAFKHXT19/zGc2hb7+U8pYNVC5FAqx79rVzetihRwzVZfPlDRg1vfslaJdo/D1Jbtv40pPw6cSEjKw9Dub/kjU5Aolg/hdDg+QEUsrkDqLu7XUdtRwZvv6NaDoF0hjdzX7yIQXtl/EAlcYQih51ixPFWiE++cBUJ2bg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:53 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 19/27] btrfs: zoned: factor out resetting a block group in place
Date: Tue, 17 Nov 2026 19:58:42 +0100
Message-ID: <20261117185850.4128157-20-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d3c0144-b8fa-4fb2-373d-08df44dcf689
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	amSDZn2LxfLRsnfBO02G07BKBNTlZCF0vsFLXvDIU56TSl8l36TS1MwdzLrofVhb5zAD2MAGOxzrYAG+wAmW/IPSNXPRIJbDcBAxYbA0HtT4GjcD5AUCDQeKAH/ezBx9wLkazdFlZ0l5JNt/NVC5Eg8FDM7DV1qYqBkxVfLCRgYZCa+Qe1AOkxG+mI59YR5hfySh2N2p1hU/8fauSxiOpIo67DmpP5rqLl4PSmRS6twJmdfI5NZqO+cdvNWxAGBs3jxhKCOqIT/zRGX1osAM+uXhJPbYPHRc3xlMm/FUobLyfp/7QtvIwqeVKaWkcsD4EeKvOqxoehb20hJvR1Yp9EVEm2OFgdGkDtySlWXlD2siXB4ON0uGUtKIDLhEmWR7WFkPhKrFw0mYBEepNpn5qGO7qDMXi2vFwRJBr6XOJkAf7gsF710kKo6kB3AEUbqdDbYGzfKD15TX0DwsEjIlBAUk7TrzyCQW1st2b72omXma/qbtMbQ+JdekD5gGOvfDiTMx/oylRXsSDtng5pszmLsNfsK68T3xDvfns02fsA0rLTRzVAtA71nBWEICE5WoJK+UOkhb6LIAXBx+8Sg8Vk/nv/+hNvOHfYR3lHXg/pWnXUHvKMYqRasAhTNK0Qk6mz55l9UNDOaRDNPUHRhhQ75yPhXnbB09zLZyWikBTEE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6oXuqrIAOMgUUwUE3+BETaG/IP790uYGZlrd2BuwwCaYLnWvFqDyBy2ZJBLb?=
 =?us-ascii?Q?Af2ntEVwwSjWchmwBNPwu0VUvphrdhjbY1Mt/JEhtOXpI1GttQgZgmBTxq1H?=
 =?us-ascii?Q?B5XWJk4/9gaCT6Y21Ma1kjiFZFzh+paQ+upfPcZ1c48skOoqCtpMrGEeqXnw?=
 =?us-ascii?Q?1ha39LUXysh8D3EOkHlA/48nFIm0YekszpytrBkEa7aK44wIuZon4Do/XXxf?=
 =?us-ascii?Q?TNfyC/GLyzMGWQy8t9Gp34lPD4+X+3zJhiWKgy2d7s+hmsO3T607T/XuMayH?=
 =?us-ascii?Q?rwMy5Q6xgoIJ+jcVCRyca/L+E25LynsDBCPKPq4ttzYVNdMmHuHgo15Oues1?=
 =?us-ascii?Q?IMjcDrjkWLAYcVtoklbAP6pvJrOB4dBN1D1cXX+oVukMitRXu9R1q6DOXj+Q?=
 =?us-ascii?Q?eIFRVr+0fx63SzjyvTx9YWrPGKn0N71wbJjKZAIVy+bHwwpgbqm9sAC32JUt?=
 =?us-ascii?Q?4h4t/X7+aEXFbYDRtEeHzQRKofmsoSvt00bayEKDud1506XwbSjNmkgqwMa4?=
 =?us-ascii?Q?LxExGSK7JZtOppy7otiJzTLyJbSPoTkjzs7864sLTg2gNgd6702aCaj27knd?=
 =?us-ascii?Q?QzIvWMQhHH7HwnFr3ARxX+3/GDaw313Nfhdhl9W4YG1PGREiI44KR+x13K7I?=
 =?us-ascii?Q?nfN4cxXQtt0uJY+hjcm1BZPwpSNARPNmIG3ig4cs5J93Mg1u47mkVfOPdcHX?=
 =?us-ascii?Q?g7RYhQt0mR6NdA5lGQOLhplzNp+aXZngqBvP8S6nONckL21d+CLu4Sao5urH?=
 =?us-ascii?Q?qhLJ8U+U0Ct8OnvdwZIfG88VhMOCocVSJ8W9RhO/utin0HRuz6qtnJaeRv/8?=
 =?us-ascii?Q?+jHyXjS45stVxi03wGZzr59ZGRK8KCVXM0l2HOXx3vmaeTSQAo7usRu0meI1?=
 =?us-ascii?Q?eEcGXqX1Pq6LDzldsaF6Z9ZrU7xB38p20zS4dgGXCdtHh+o4Ki7DTt+5443O?=
 =?us-ascii?Q?IStyBGck0SfQIBP7y+fawUDufTj0rKALDDyTTfXa9mXfwDe2o5/PKvNKNPq2?=
 =?us-ascii?Q?/ljWObzHuMZIRe5F6+dui2f0NOrTqb4OG0/l3oo5XiCRXxz4oHxQK+fAHLwc?=
 =?us-ascii?Q?3Unf40R4P7Rq3MoKCs6o7u8ODCMPRT7RCVJOieU+WetXg/3i9FkMqttvx0Zd?=
 =?us-ascii?Q?PkY/MDJryj5HajkSEwhUIjKqRtUlL4d9E9//rNy5mULgk9yc+3GxrP68sJZv?=
 =?us-ascii?Q?KlmfJsPohIMHYWN2nHYSNNz+GFfpFWonUDUMpWSCwXV+L6gSZvp+kMpLH4nN?=
 =?us-ascii?Q?3lr8uoImfZCP4SLQlwWFV9kkJRedm9nAj7G2LHrz8uAZNV9t7S6Tb9DDlPv5?=
 =?us-ascii?Q?g1psv1/NZgi3AlHE6EjI3BraBkyHYoygbhcDgEttP1Y8NZkROzEOBqik93zR?=
 =?us-ascii?Q?vvsrlGUUt1ye4QWxWNg4d1yGfbWLRAl2zzJBye4B6hO+QUv8RglO3twOSoKL?=
 =?us-ascii?Q?8D8XeZq9gNxkfHHAt4OJLD4Wq0oBw38sH3eoM2H9s9r0JykB7y9YgKmKpJxQ?=
 =?us-ascii?Q?tr3kQnjmxkUvATlUKAsR8afY2e0S/aEdC5sxPKXva6Wt0mtwSi/cJTQEusWs?=
 =?us-ascii?Q?bKhxmm/WEenT+oycCl+r9NEyABy8OvPH8a0OqqXvi68iai6HzAeSbs5C6Lrs?=
 =?us-ascii?Q?4X9wPF+PMMjaVCEN4NfV8KaLYQ5t2qTZBhffbppwlOAAvdJisxd87KySdoJW?=
 =?us-ascii?Q?YKKbRaLflTQKrhbk7N7zspEHV+h1k7oUt9Mq91smnaaKdmbJkarG3Vro2tU2?=
 =?us-ascii?Q?cO377guihyrB1dcECCizOOK00CiJ+T7ToQitSo7unAC8uxX1522fs5NrOCa4?=
X-MS-Exchange-AntiSpam-MessageData-1: uRJOkKFJGvsRJgj6ipM4zj6PX5LQphcDo38=
X-Exchange-RoutingPolicyChecked:
	IabHmxZFgHlfLX7Rzs09RVq9LsQ5UUVigdItFg3tFujjD9A3G3OospJ61MtBVqoDpKtiun1qFjJFT98X2+JRh9xBcAn0+nK/hZRWUPMWnUfgD00OwRszi0p7MiLLLENgcN/wyXcznfeRCiqbEtfzi7qdAkwuGGd8mXLbn3ajS2IiyYEtLxVw4RPmTNd4yyh/dwscB1tnxJxFMQxkd4sJ/wXzSi0fOIxKlyZ58m6vTB9QPGIKK6X58HHtx2x4yuj3j1UM/Dj0GegjhnDZ2mFErNHS+x40qqkUayw6OhmRqYV2eAibR/Zxu+o8tlYcRRRnZhdKVIDVjlApexf9W1LzVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vqSONg1OAmNz7OopX7zOPi2d7XpXIYI703ny+S62K3yuVLql/QTNWGmdA0p+UTBwjYOmZqxZ42ZawBgm5fnxjy22iziJtCPB9pA4Klva+S4XX2IBEclICBrdQrW03Bwwhn+hS6g6wm8KR3H6iL/1Xm/79Ini7gL5PyHPWssUEAamEeCoooq6TdUGGT39POpCjB6c/G8Kb4ntRXH/s59EuIzdRKZMCbYajDb4NU0HjPPecVztIq/mUpSMsGlJcFJXOgXp5Us0SWFPlPz/XKH0QxAtnznLYUXnAhswJsjfY2fww1ibc5G/yY3OCoQ3m/HhCxrkzqVBjGB56ISOXpYiKT1kx2ZtW3L7yglWif5ZYrtGXLiBQtOl2DwFSqllk1kw7NscYs9oxLOqU7ak7KJJ+JlVHs0RSYQS5lOGhuIXWS/KRGhOywrhadMSFPe5LX3GPrCb6lbIy4kGc9Y7jnKXPSRSHP2zsj+BABzXHQyODs9qZZDym9vhk+YUcAKca8rudUDt9EXIRhZsPRWyCDEFS+Jw4DT2bpggID3HoeWTsD0p+UCN/UwO4s9cfyp2RLYecQY4w/gxn1CmQGoDn5GVuw5Tq0s234GKmwutdfY9uBCoCTPScp3m0+vjf88wE/nW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3c0144-b8fa-4fb2-373d-08df44dcf689
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:53.1493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hP159UGHcndUsLpaC2PtJrs7ac52+FobEdhJNjLbhbrZAHOKzbX05p6qpaiz4H8kspftgq9S7pCTqD/xpACay8XSAeE3CUtjMNfm9rcSFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

Move the code that resets the zones of an unused block group and returns
its space to the space_info out of btrfs_reset_unused_block_groups() into
a helper, so it can be reused.

No functional change.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 128 +++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index cc96a47320e9..8532ef57db48 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2972,6 +2972,72 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	struct btrfs_chunk_map *map;
+
+	*reclaimed = 0;
+
+	down_read(&fs_info->dev_replace.rwsem);
+	map = bg->physical_map;
+	for (int i = 0; i < map->num_stripes; i++) {
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
+		unsigned int nofs_flags;
+		int ret;
+
+		nofs_flags = memalloc_nofs_save();
+		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
+				       stripe->physical >> SECTOR_SHIFT,
+				       zone_size_sectors);
+		memalloc_nofs_restore(nofs_flags);
+
+		if (ret) {
+			up_read(&fs_info->dev_replace.rwsem);
+			return ret;
+		}
+	}
+	up_read(&fs_info->dev_replace.rwsem);
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	ASSERT(!btrfs_is_block_group_used(bg));
+	if (bg->ro) {
+		spin_unlock(&bg->lock);
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+	*reclaimed = bg->alloc_offset;
+	bg->zone_unusable = bg->length - bg->zone_capacity;
+	bg->alloc_offset = 0;
+	/*
+	 * The zone was just reset to empty, so alloc_offset went back to
+	 * the start of the zone. For metadata/system block groups the
+	 * write pointer must follow it back to the start of the zone;
+	 * otherwise it stays stale at the previous (finished) zone end,
+	 * and metadata written into the reused zone would sit behind the
+	 * write pointer, could never be written out in sequential order,
+	 * and would be stranded (pinning its folio) until unmount.
+	 */
+	if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+		bg->meta_write_pointer = bg->start;
+	/*
+	 * This holds because we currently reset fully used then freed
+	 * block group.
+	 */
+	ASSERT(*reclaimed == bg->zone_capacity,
+	       "reclaimed=%llu bg->zone_capacity=%llu", *reclaimed, bg->zone_capacity);
+	bg->free_space_ctl->free_space += *reclaimed;
+	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
+	spin_unlock(&bg->lock);
+	btrfs_return_free_space(space_info, *reclaimed);
+	spin_unlock(&space_info->lock);
+
+	return 0;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
@@ -3309,7 +3375,6 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
-	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
 	LIST_HEAD(retry_list);
 	int ret = 0;
 
@@ -3317,7 +3382,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		return 0;
 
 	while (num_bytes > 0) {
-		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg = NULL;
 		bool found = false;
 		u64 reclaimed = 0;
@@ -3359,65 +3423,9 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		/*
-		 * Since the block group is fully zone_unusable and we cannot
-		 * allocate from this block group anymore, we don't need to set
-		 * this block group read-only.
-		 */
-
-		down_read(&fs_info->dev_replace.rwsem);
-		map = bg->physical_map;
-		for (int i = 0; i < map->num_stripes; i++) {
-			struct btrfs_io_stripe *stripe = &map->stripes[i];
-			unsigned int nofs_flags;
-
-			nofs_flags = memalloc_nofs_save();
-			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
-					       stripe->physical >> SECTOR_SHIFT,
-					       zone_size_sectors);
-			memalloc_nofs_restore(nofs_flags);
-
-			if (ret) {
-				up_read(&fs_info->dev_replace.rwsem);
-				goto requeue;
-			}
-		}
-		up_read(&fs_info->dev_replace.rwsem);
-
-		spin_lock(&space_info->lock);
-		spin_lock(&bg->lock);
-		ASSERT(!btrfs_is_block_group_used(bg));
-		if (bg->ro) {
-			spin_unlock(&bg->lock);
-			spin_unlock(&space_info->lock);
+		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		if (ret || !reclaimed)
 			goto requeue;
-		}
-
-		reclaimed = bg->alloc_offset;
-		bg->zone_unusable = bg->length - bg->zone_capacity;
-		bg->alloc_offset = 0;
-		/*
-		 * The zone was just reset to empty, so alloc_offset went back to
-		 * the start of the zone. For metadata/system block groups the
-		 * write pointer must follow it back to the start of the zone;
-		 * otherwise it stays stale at the previous (finished) zone end,
-		 * and metadata written into the reused zone would sit behind the
-		 * write pointer, could never be written out in sequential order,
-		 * and would be stranded (pinning its folio) until unmount.
-		 */
-		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
-			bg->meta_write_pointer = bg->start;
-		/*
-		 * This holds because we currently reset fully used then freed
-		 * block group.
-		 */
-		ASSERT(reclaimed == bg->zone_capacity,
-		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
-		bg->free_space_ctl->free_space += reclaimed;
-		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
-		spin_unlock(&bg->lock);
-		btrfs_return_free_space(space_info, reclaimed);
-		spin_unlock(&space_info->lock);
 
 		btrfs_put_block_group(bg);
 
-- 
2.56.1

