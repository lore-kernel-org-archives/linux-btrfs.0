Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB12449B01
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634049; cv=fail; b=nRfbToFsMYTjxTILhFlec/dqFdNLntviB82J+FGQoMjRF1Tnak4bE2GM2AHzcDycmCHYNDkdRGjhKun1MqHX6E+YeAg1vwDDGzU1aq8i90Vefc1PPWedLjEoMIdoKyXSavhx04gVyaEPg7vyBhbclvl/iATLRbbiJui8wLKPsA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634049; c=relaxed/simple;
	bh=ak7g0CzPHC0fNd/exXEIrxIOsHr2oFqNjy0KqwkgKEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BT2bl1W8ES26WSZwHljXsqFcadU7Q1vlxSXgpN8b1CSPgKTFbNY6J+4sSiVUJWzDvwSPyl9qHFL2tNRhzbGsodXMOd72Nm5ZpCNzgI7vmFKwDRUfctghk46hcNurnmHYKemtGnNGK/qxlCipmh+dudo8iuYqT7vW5jknBIVeRjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Eow8SFTK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ArE/fO7t; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Eow8SFTK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ArE/fO7t"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634047; x=1823170047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ak7g0CzPHC0fNd/exXEIrxIOsHr2oFqNjy0KqwkgKEM=;
  b=Eow8SFTKNeFYNwNwDjJH3pQOmIs9Hv4AsPIaXEb42jz1IgBOTLEji1Ra
   8Huh4rqxvFYc/mcvYaSqIwLg+YLpON9u5LCqFunRfHsC5ixK5OJLUWFqr
   MzXNMp8Fm1B+p7xvxG3Xl3Y95cET8Uoj4wTOIZ3yT0KfArSzf1GkDrzBQ
   2qt/2yq/KgaOV3OITQI6/qq6BGSkV19Y2vXPcJlh0bZXb8smTAOpq+QXM
   n4Whof58AJZ6h4bayZH97v78hgApco81wpK3NC8QVvGYOyABh/87WcVuA
   gJz2KXjSy2cBGp62FK7BeZ3X3+cwiw9xhF91VS5YjaP5vQAw32630llSU
   A==;
X-CSE-ConnectionGUID: kL61L9P5R2qVgbjTWJNuVg==
X-CSE-MsgGUID: 2ERtiQh6R+OqTxhxxrgifg==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="153560340"
Received: from mail-northcentralusazon11012008.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qgpa2t+DS+qov8dPuPrBSLB56Jw/SwqQwhofhBApxEzCouKG7rA5ncg9ALlXAiiyk+35mejQ93bFaJEiSVLU93thMIq3rgZONV+y2TtWGezDECL8xM1fVHhAJOH2aQBrzGaZ3rmcpK5NTLX1bJCihKzt0DDLANsYFxrhkh9HascwlsuMbppxjlVxjDHy471pN6JGwyQmCwdBi77pNMcGbYxwtlqUSkQCf3717d8fT2z0vrCT8Wq44ClInz01TE1FZCs/xsiynZsOeOrRGlbmov8d6JoaczXVqGIRkTVy95g9ensr9rqr3GTND44+kyZdUf/uqzSpe6B4WEnDuiX8rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BszRAVkFEV+2VEO2wymF9dwm/BYbCuNqzSxcExgeVk=;
 b=wK8j9GhjiseeJLIfnDxePGJGzjcSJJ81I+zXWoYwRmKCROB3VtNfo5Yh38czHERRX1Ortue5Pd9Qs+cOcKZWkdj5NuuVGBiG1ODs8JYumQffmeBxWVuXJS6V1Fuab4XXDZeW1BMbNuu2qpBrcVT6wXAAPFsHlV/GdYAjhUnQo/r0LDxnyZpnL5PR27jEFzfal9kH9jwtee+b2EPiR3z5NsjiTimNfCMivmauhtonw5YMNb9M9oqnfqsTKQ1c0MVUoDdxyjd1dHkGx7ZZYldsOa4zjtRO563PDA3VrVwgzy76PJLtn30X3hIKo9yiQrYEmGT2Jz7g/bM4t+AC6srckQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BszRAVkFEV+2VEO2wymF9dwm/BYbCuNqzSxcExgeVk=;
 b=ArE/fO7t0yZxjDyZPpQhl9ak7dlM7egUsTUJnpd3YkCsmq3r9pmofs4wLGuYmQEH9PGWAVnooEH/RWw/7MyroGziqdKtbt1Dsbi6DmRbCfzK1FZZQtOBX15cj1IcGWXQ0YivMjbH/9qsfji1VQj4/BuAd5moXycUbFRN737P/YM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:17 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:16 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 08/12] btrfs: zoned: prefer conventional zones for metadata chunks
Date: Sat, 10 Oct 2026 14:06:18 +0200
Message-ID: <20261010120622.3781326-9-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
References: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: bf8f0251-b6c0-4bf7-1506-08df26c70707
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	rmoi8huswbmiR7PNR7V6U9xZpXp2DMdb86ua0UF9ipkUmNHwccFh19Yzs0allVnnIHw40sVUhBjmnHzOFq54ClDL2BMQNZYrkNG5D72eKKGDCycsdN6MUPQ4F+2Dqo+pqmCAq9g8Ye+fCBzZJsVF8wg3p/UZ1spKtH5/94Arxac5IbkfLJC4grv+MucV/qumGMA/Wr81ysXb+Z/89EWD9PbN7gwyosL/6tuztAR0ODqIqosM2oBp9qGgvm4rcdTcZKx0c/CVmGsJtygZALXGgjVibCKxPGs64cS5Uy2lGwrFZ9HMGf/O2D/rP1Lw7m3kZt9qrZs6pB1oPJ84wEPmqklFqAvZUhon9eMzzZJ0VEk0Zn/K2AVjDMqTym5f1IWm77EYUb4LuC7madhaQViRy4jr5Sm8DiFpkaduaSSEl5pVybWzQzWSPIgZF2iUdj/A5CNgi8VbCUcaLZbXk+0TojyJeJH+yq1i4l1FIDBlxtdeB54g7nj1UFINK/NBaAulkqunI9iTaBjLbvRTamNB/jrfHBFhd9qcLDMiXRN3P1t/ldSml/9uaMChvVYxEbb1ZyL/T/2JfvIr1sK8n1ZJD3CO6c5EY0Ag+5WNzCpjp5WTzcTxq/zdksFGj5s/nsgIJ9Pz1VmZFIf/LDLF3EVBu6/Em88kZCcJIWU6ouU7EJM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pb/TsRlvYHzQtRjj8NMnRqZX0C2d8kZqj497+SzZwr7H0iy+GBW2+03/FdwD?=
 =?us-ascii?Q?EAmQ9bCX0a7pQ1E3tyTF/o2HP2j4u/jgipw3IVB4hH2XjQHv6za7nwrlAn0L?=
 =?us-ascii?Q?92YuKgRYHu6claz5XMrdn7JjDktZi5qflYj3MZ7KDu7J6N9k/Kz9kmpMs7Cd?=
 =?us-ascii?Q?LjcSnvY8RZ342keGAOv0Ryt7KOmHsk5otbCuklTFgfaE4qSsUIFBKdIya501?=
 =?us-ascii?Q?GrflKguVg7SJI6RySj+UHnXoPGBl7fEDrcXWQrLMf220A4NNV9K5nRgipQdG?=
 =?us-ascii?Q?L5JHMOraw5Lo/VdH0g75iwjOeET6ogXKzbfoSVQJUq2QyxMJKbplDDtrU2Mk?=
 =?us-ascii?Q?GhjJrLMEYYU/Ntv1LkBJVpL7YszzQf3WzBbeRPO/Rsw5CX0ANY2qFw7Yh/iI?=
 =?us-ascii?Q?KZw/516scXwSYvTFoFViAh5c9+W7NNcmpcG1VS5vRF9RxOV1JMLDNuDQsrIl?=
 =?us-ascii?Q?Sjh0gMaG5TsaXC333WaXhmAucKYUOGBKvOZRKK5MjT+fmZZQviZPvBrKHUfq?=
 =?us-ascii?Q?FeswgbQWuAzHmmbScMVfPjuEAN06YSu+DrGJT4GVcEnLMTFnGbIHDR4Pgzh/?=
 =?us-ascii?Q?3k+QJDVTebFZxhiJDnjgDhvy66I0+ShGn/KsRxYJj3HOkbzJ7rFf440sxb0t?=
 =?us-ascii?Q?26UN4B33SUobKT8ClID6fJbMOrWZBGsIzd+Xoj4X8JDQcS9dvK+zFs5aODHR?=
 =?us-ascii?Q?3v7ovQJ3BHjytWMmdaYt4RpBYNfFKG15cVK8dk6BxFrtzIazaYnCBy/1jFk9?=
 =?us-ascii?Q?VHDYXlz8hVk7rWXyOcnJaZGuDLRL4hwHoE69mqK2dB9ZLodv5q17o9aeLvN9?=
 =?us-ascii?Q?F1DFnQ1DIoQHxemWBpD2SIBvHhvvlTYaH5ty/b5oQSzWrExrMcCvxa8G28JS?=
 =?us-ascii?Q?aZsLlynHrzgjqOCmhatwFEYMhujvOhjwsVXwC85UrGuWhLMZhFDiAh1Xk6PN?=
 =?us-ascii?Q?Byu5DVWTN26y8QyCu56SYL1AQrgRImSPcbU6ctSrWdLBT+xV7VuExzqLjKwS?=
 =?us-ascii?Q?WQzoReXtLDkxdq2UTo/a9LZh6cEEneO9mXORD+8Tc+Y2ltXHd9JM+3rfpedv?=
 =?us-ascii?Q?qdG33ztoxeS5auvdIUugaS6EyCUqT/2h8AW+iq2t6UNEXAscr5/zCp04CmGG?=
 =?us-ascii?Q?4c37F1s/0y5h7DzaW5MO/KY5oJSXKDj86gU/b7FPdP1an2r1KL2rK3w1oqcD?=
 =?us-ascii?Q?BCWK1FTv/kAOGEjclZOM9M5t0pNXtxLffm6czb0l9UY0a09GoJXNL5yCZZcd?=
 =?us-ascii?Q?/OO45sQ3PoC0apWxAoTfDkdGJRpCIUv3cSnSkfw0sIpYpyncxImrAZ0uzvvB?=
 =?us-ascii?Q?vzTy824BZg+nxKsCaQHz0X+ZmzcM8oarqaBVl/4tYVwfdWouVFz16OxQtJ3N?=
 =?us-ascii?Q?L4QINknmPsqEVhTfqn4LOOI/jkZ299wY43nPHP+UHXac3vbEmiZJzIi1owxr?=
 =?us-ascii?Q?C0NEJj41n0xX7zZaMrnfM1xkykSIA6Su72h6BKCRAPca3u/IHsOHpQ5msCEF?=
 =?us-ascii?Q?nIXIw+9o7p1ia91CU+AIERRWR6xN+jGoY2dvPpstDX4rObNuEhrnSzwgSrP+?=
 =?us-ascii?Q?xe+3GKEmIXXHgHNUBJzHoe+0AJVbt1KnG/K14Euv0PxcINAy3ijCiSjF1rOs?=
 =?us-ascii?Q?BcMzqD1GCLGFpzq7AqhU9aWdEGUv2PqY0iAGAhhMmvdvwCfmTOzzozMxuOaJ?=
 =?us-ascii?Q?buaVaFY5ImvtYtTcwuN2buREXzLxbkQ5xnzMTIADOtvDWXjJ9KmJcM2ghgl0?=
 =?us-ascii?Q?la/O7eGRSCM8640dMM2B+Xc2hXreFDCIiCCx3XfWQrmGOXROq/2Ctj55pxR6?=
X-MS-Exchange-AntiSpam-MessageData-1: rzzdmFj2I+7CpJmJ/KMMswM6uKG6DwDXXd0=
X-Exchange-RoutingPolicyChecked:
	wRWErgwXWI4LxzVDVZgbvaE40K7tbzJKfSGJ7E8arnENp8Has24fVRX3cP8lhD37/ELUUWuD0jpA4oODvsgXFwV19DhBH+CgE/voCTNQdQlkAknJ60f2i6lr/I0rUKC10+2rKJPkUc8eBzm4RCvn6XXFj0F+cFeLy/b2XrTVgSLRxUKZW2UvYDH+XVccwWs1pmsdNwC6FaLctfG71WNcqOcZy2bX8cj0Cge+I59RR3wcKQLhVaBY/BdGyzNlTh743we2DF7ygf6H6RY2RA0L7amZtnV4kwaqQcoe7T38uCDkVLwOsfJLVVR3F7YUQC9KOBHAIguRx3Xs0ytcy1L81w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ykcFRzklCx7lu6cSmME2hs7IUmcZWJwTEckupO+9KRcpfDv0AFPYgtto/FJyTOlB6jiPjZZgfASCLNq0UP45FyVa04RZ99M04jq3UomX3y0fkzUJcVXBjrUNKBvgOczAK0wKWr/3wzkyDLb+bEps9mkemV9ReJNwvS/WZLv5gXx7+c1nkpdUUTbOzbCK5dAqy4jxX5JvjD/gRAEdo1OedCTeCeGVUeIT2l6WcimFbgiV3Wn4XACNzFRUFqgeeyud76xb0mCDVka7GticfHA1AIO9gHda5xwTEN0/9+EEpdYbEOCmeyoc7mhRcKXNGEpPa//phH9spOOj31wG4m8kIOnpKhqLE++d1NoQSuo2Amir6YlcsQm4ThGsm8RXzrzsyRTxkLQZI52DPa7BvkCjf4K3I85yaPOdyQ6FsiSNAtklWSTGFSDPyvSB6xFBWUBqi/wLE0S+9dYz7uBMoH14JpyVD1H21hp3R1dVaztNr8Asclxv8ZsTXl/zUxnNcyhC+82pkGIhWXnscfnLQCzezX89muqShuhM+ge5kYNY89qJOyUL+6pIyvGJ0EpNbEOwDeSKh6OkdiQ9QIl9xsYw7Arz0n0t8m7hxfLFWDwEFvF6vj4REj+9bVkxQeO/atwB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8f0251-b6c0-4bf7-1506-08df26c70707
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:16.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yv8D6uqPwPBuFGnFdDtA0iFvnAn9xf9HkMvjvdCBfOiRAU9mFmFNUIC8wAvioL/iO8DLrfQYmPRAMGh0ggjUQSAtlWOvb1BQFr+xuYufjPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

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
index f41a3e9c30f2..250859087e57 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5891,6 +5891,29 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
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
@@ -5899,11 +5922,14 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_device *device;
 	u64 total_avail;
 	u64 dev_extent_want = ctl->max_stripe_size * ctl->dev_stripes;
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
@@ -5930,7 +5956,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail, BTRFS_ZONE_FILTER_NONE);
+					   &max_avail, filter);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
@@ -5957,6 +5983,17 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
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
index a298b244da06..26bb562165f9 100644
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
2.55.0

