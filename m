Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793111634;
	b=30zx06ArFAk42FDw+2xSNPRotyrvqihlUnngZ0/ToCwtowv/XKAqM4Ey0FFMPOvd/pny
	 50AKP+YYtWOphgG0eUbSzyAEVa40ccvEcHXCX4K7OAA0UokrW58MBVIzfz6AhMR69nCif
	 OdvckDQnsYYrjJGmrRiPG12LMFJ8K7zQJ4oQcgNDxgk0XVBYTr/ovYH3z5krE8THz4CM3
	 EkSmNozH1NwIQlmsQadDGe7ErETACzkYmUz3wxgSfj3UzKOCUjs1Xxv6JeonEWO9D069M
	 A1H4LbG0WQ7DZRi1esyQ7ra42aT/iWikV8JypH5nsyltyCbqKPpISSZy1B1iFbD/2uw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793111634;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=MJzVLWLfZs//qd4f8lcJ807fa9O9LEv9XXqMJ2pRoB4=;
	b=zq5n/FSfv54iZ/pNHWBa9/SbcamiLlPn01IbvqeaCOO2TFjooOAeuRY650CVn12KZJAT
	 q9VKTVh7BVL1hHMkDBBQRpHv0/Y8pR/W7km0/GgHDcOlD/2ytnJXLUszMnLISYQi8Uwyj
	 4XVovhsjVC7/y/J9PnrHmEWDe4pMA9vhcMSKb1RFonkKJaasZqbLZzgwlzgtugJjrRoGl
	 xUCw2Uyx8xScjYZAX381M3LyztBXdCx6PBR/leXCD+CraxY37IaPWhKoo8LSWJJNd/Kco
	 5p7MVtGt1N9XbJBsJCxWp9NAKgw77ubvZK0feLSzX45puvyDkmzMQsBz6EFd/M8vYjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Gfll8ep6;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sM43bab1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E315606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E315606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Gfll8ep6;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sM43bab1
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793111641; x=1824647641;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=zXJ5Ejozxnu0VF/pTQQxKxe9dDW+KaZFXcho25URiR0=;
  b=Gfll8ep6kMlOY8fK73LLFAWVDw4fQ+PSIwX7YZ1G9NVKkESk0Sar3zby
   OG13miiY13C1nxuI56bqWpyjKHAU1oJHYM15drw/qTjecxSD9Z/LC8QSD
   MgKudlKKg6dqqrjg/BXO2qFsKpef2OIYV8+6b5ZCJYhAUfGtRDUedvoSi
   XJXwdEKLm0l+XdK5GiZRYQCk24fve4NvHFDQXS72JdfuKTAnvHGd9iwdo
   Ro6WsMxIVBo93rGxXxiTfuOyI23M5AsXoKCauYxftFb7zrYKns9tcfFp7
   /BwbO/sxd0v834w++gL5KN1P6w9DiAvY89zwTCy3BE7V409yxhnmgH1NS
   Q==;
X-CSE-ConnectionGUID: X7G6A7pCTqKMZ60WzQi6Vg==
X-CSE-MsgGUID: tRwBcn7STHOXkzzRt4xKQQ==
X-IronPort-AV: E=Sophos;i="6.27,181,1786982400"; 
   d="scan'208";a="154890914"
Received: from mail-centralusazon11011047.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 22:33:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s4n+mVzWYnxbHw1UdVyNM9fb19SD4wcIqxEGWYNaJnqq3b4Z3952j81zAAXEE76nx2IAhvGqsTG4PeW4jCgyTAoZU2kKIzT/lYyvHWr5xSYxD14K5HUuuKLyThp4v5GK9vJqfpdtjX+3pJCU0i4KsLfqHTKBprhBPLQwdvl9/YBESUAmFhnVTc/mrBlSTdlF/GH5+tLeNMtMz9r1FLO7WYxBu8kg9iXlmFj7mKXyI8waxllmR6RTjIatUj1XeiChydoAhxUmcH60khy9S+/e1krOejVbjXTPLY3dHzqjhTACaYnl8pAoGJnosHUnVLd8Wc15CnRDbm2t5us2MAeRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJzVLWLfZs//qd4f8lcJ807fa9O9LEv9XXqMJ2pRoB4=;
 b=tBakjGJXC73EP5M/WHyvGC7uHswrTwvzWc4xNbIxScYkRvGKZ16vNLDlA9u49TFoEnQPFs6sGVHbsG9yHipRBHs0rxSwqJFVtBkAVqiyxBNl2zEPSFgZfSMXQwXng6NEiNyetHrem2WGkISrnK0OGlOekEVo3QAyvNVXKK2oUjVY0gULLyUDLFwrPs7/V9XXZxohKnQdiaNS82P98JPXHn8uQFVpvexYG+RfJSTc4BmaELlbEy5VRxdm3XEHTbnGhUbQ8j58n7dbWOl73oN+itC+ruLAWzk5QNQPBmtzYMUk6ey1vIpkXQqx6j5vdhqNb/JIuL97jpXy/2WP2zR5pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJzVLWLfZs//qd4f8lcJ807fa9O9LEv9XXqMJ2pRoB4=;
 b=sM43bab1TruHarjGlBJtyUR+i7X7shlCadDwfY9a1Qx5ufgSutIEN+9obyeGGi7B1e77H3qrcWbbWjV7hSYQg/6xD78SuPK2cy3bETdH8nC8AiGpco04hP09QvH28o5/yVMKYUdsUhRaaTt6WPkdBjOeBaU+E1lm5x+j2quIjz0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA1PR04MB8563.namprd04.prod.outlook.com (2603:10b6:806:338::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:33:24 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:33:24 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs: zoned: don't wait for ordered extents in do_zone_finish()
Date: Tue, 27 Oct 2026 15:33:05 +0100
Message-ID: <20261027143305.4001082-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0401.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA1PR04MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: 0794bd3e-b124-48e0-ead2-08df34374203
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|10070799003|376014|1800799024|23010399003|18002099003|261026140227099003|56012099006|11063799006|261021123027099003|261022105027099003|10067099003|261009223027099003|261026121527099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	Xd+yokqBuB4tuYP1GZL61ofqr7xADJIg1yaKKfiwpuzgRU82Rw4Bl1/oiqx6KYCoPU8CVxtOZIx4uk8w0xCzB28Y+h7ggApMnuk1C/RE5eoC1UxbbJbMxFshAvxme0m3r2yhcjPhDDmKWGFsffgEWjFG8kqXxzqi8Pro5nAaP/Pv5a7wYKMmV4JrGZcKT2L08lTISGq6jsDpEWR/APqAO4oNfOLMgoaGXndE968YxNouejFHgCL3feCRryVPEwHCAzFwKBS+5pOEv4Kb/RPcDgOKhpI1jQV/WevkuDqAvoF8L5RLQaFmiQZdmY6ZWSDyISkLoHVNlWMDCupucfQj2RgPAvqVUdvESjpUEq66U9kBFakRM2Gg0SPnL+SXwa7BWNtq8xNOTZfig/gHcWOqzGNrIW2L8MAQXLOE8tEY7d1aomaLhlcG7a/lpfQI4P9zkHXs9MdBSe/47zza8uMGoM2WhqxInLSpXh7CcpCr+U1Hv1lEtzg4IdaqE8vwYfLPaScLMan01zoo8gn8RDa/SOk6ImuEtoy+tvdNOtXVXTMvoQH36vJJIMg7NcfnMn82iZW/XJ7HkG0HYXJbG4c6agtPCPSzH5CcPcld3pxZghhQRmLCVudA7fcSsKx8V+AYFR78x7MJyYENNaq/n8UIaNokCoehI9ZiNYwYEPQhoss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(10070799003)(376014)(1800799024)(23010399003)(18002099003)(261026140227099003)(56012099006)(11063799006)(261021123027099003)(261022105027099003)(10067099003)(261009223027099003)(261026121527099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NJk8m4jIaPPkqbnlFAGwCMo78Z6Bv7SnUmUwrjJnJAKVDxCGtOL1sXFAS4tj?=
 =?us-ascii?Q?yVJXo1FRouPlxhcgwq7671+cx/v68kM7OcMZD2nMi9kX8riCGXHj/hbGhF7X?=
 =?us-ascii?Q?ePy/WjLEVxCg6Bkab1pa9Lf3IQF99fQ7FJjg9/RbqzzeQWffz5u7YpsclJ1I?=
 =?us-ascii?Q?pd0PV04exlZa9I3wmTBAzNGAnoWKBIYQgfIyaeXpJaKaVMNlbVB2yuVxtYWE?=
 =?us-ascii?Q?aT30Y4+GFLpY11BKzoJqe2E8PUAGBGQh/+j10NM9AdT6bPasYEZplRnLTNJD?=
 =?us-ascii?Q?j2F3VlhFiQX3FTBENX6K5bCqFN831mWfFD6RQ5Z8KwE3jPbQQJTI2wwCXce7?=
 =?us-ascii?Q?WC4U//ww5gpRio+xfuPDPK8XHfcT289HIJgqNa6vnjamTCP/B94o8yYLA02s?=
 =?us-ascii?Q?eFWqRyRGfFz7OWp8gpLUCjmuZJwUoO3zYPC0AWAM9aVhCYpO69ZV5GSy5tII?=
 =?us-ascii?Q?7UoxBvYY8vt8hl09L0r/suVtji39hZdiD2vnjO5ofBhfbefIttDdfp/XL8Fj?=
 =?us-ascii?Q?+esT8GTPSHpwWZvPFYWkIOF91eypNVyzPFzmWt66z2pGRBSAkd1Y+bAjyGV6?=
 =?us-ascii?Q?ddd+3/z7rBwg8pQTK1YMbLQOrYGotOXyNw4dSyyCSw69LDMHbnmENAum5Qw5?=
 =?us-ascii?Q?FuKiiS/w4ttq0n4nswKoxXRmgW3cdSPVx7D1Q3MRX6TM8V9EA6DaixghXlbf?=
 =?us-ascii?Q?IXaQuv9gNtemKjIOHzlfsgnZ0L4k18W1sRM6BoHnYFDo5qJ3PKYL4idmJ5Y/?=
 =?us-ascii?Q?0aylDUbMj53Zv7dp6MKNR65GypCnN4pUMjHLc/9D5alU9W9aNYdYcWftKKxd?=
 =?us-ascii?Q?tnLEbnA4S1eHQJukXeoYsY5smzI4sQNkVhqUV8QLdk9wCHr4Mr4MZnndn79R?=
 =?us-ascii?Q?tFw38dO8IH0GTCBCKEHM0bOyzpIE1AGhXoQeU6770/iZf8r3kxY7uRX5KL9K?=
 =?us-ascii?Q?sr3UmIuhnSgQuzckK87+1GQxlJPOl+yl7h5vqhFGtq0/ettykGUlhJQ3ktid?=
 =?us-ascii?Q?4rsYYl/LnwsK9/VMLq6DCn9//BNdF3dd7iEJHlowfRgiSx+X1niDUp5n3gKL?=
 =?us-ascii?Q?1pY4qVJWSOgPje/r/KDigq5UpUQRJOodN6+XrtBdQDMP/7SXbFI2QtCMrSjk?=
 =?us-ascii?Q?HiM3ndpzm/GWOknAJD26zlnhXcAeN9LVhigHawF9orgnYZIPmVGqilS1koLg?=
 =?us-ascii?Q?r2J2hAvsQxbnkEXc6gBN5CujQsVoYXnBHLwCPnW7jYl9DFtI9uKK73QK/JhL?=
 =?us-ascii?Q?a4rJvNBUYjN8JRbywM/tdXn/A2E2FG3Y/0dMwFc0aqcPpbriSHBwh9jXPsOG?=
 =?us-ascii?Q?ibGiBokAO2zjt8M74sT+DsTsyqlsxQXd2YluA7BBIt9eg0UBgVMFQn7P+1ZI?=
 =?us-ascii?Q?ZwRZgsXboURKzjtjs3R8iidqiW4Ep3xxQcHC0odVUEDTLW0LO7b1VTX6pocx?=
 =?us-ascii?Q?dG4/x3RNFFpWbC9CiQseppIshMXqqdRk9l/H1FQIX+GAJQ84D/6XQugIrcCU?=
 =?us-ascii?Q?H+++u2fy01tEWjnTLsEboGqnWgsgA1q619k1VP798LVbR0vVt6diGTPYD6x9?=
 =?us-ascii?Q?tcf03Ydj9nH+JClGPG27s36sKj2YaMNgimaBqIFC9UnxIxsuLKwXJNvCnxCq?=
 =?us-ascii?Q?vrwPcuJJtwsXzPSOnHctKup4Gi0c5lTN3JdNPfqN8ImaKFkBbqP+T1kuvCq+?=
 =?us-ascii?Q?867wHzliR3M5B5ul0sEgAe3/23FTLiPuNfj4r5eD0vrLm8CZ1YXu1vQl5SFC?=
 =?us-ascii?Q?e7+A6TLDt3v1GJIEe4a8cGPA2Ozr6Nk76F27+/ONdOR0OdD3hkUV7D0A5o+z?=
X-MS-Exchange-AntiSpam-MessageData-1: T1JAOVpkojq5E5G0ZeRB1/fC4xJcv1C1des=
X-Exchange-RoutingPolicyChecked:
	xcFIlUnM1Guk5unijQKcmlPbw3pAQNGP3gywHvU9XGtXAfwJqY7k/EM/YHxjGRxVQO0RPHnAav0naHUuzEqZMnZ06ArskqJX6A6gqaETlAzGX3ogfsvhlNmQpA386V34T30KPGkjKShZHBtb+acYZDHfNyFqJ8p1pwaa4+GmJas2JEQyUPZvQQCg0iC394DppWS09ErZVZ2LsyhjP0cQqcpjpGlKAXpL2yuE3eDQpa7Di4QNyIFRbr/nG9rIoN73MeAJCAyM1EC5ee4ywaY1KHq9DYzK31ys5MURAObP+RFmMvf5FvVNL+J5D0+K2n/IN/bepwcvXB52YhGoJQnNTg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XlvoRnnNQV3PDBJ6Pcm9k91wGA+1quRQNhIJr3/Gxfec65+Nbm3V+15xsyBJaNLoAHzsCJTn7PWkDBfzbTCxougbc9DygZjA86H5eF3Zrob7brc2kR7WxaeFfiH9PCNxtyDaRynIYB2KynnJMOfKglb66O0HAZxUWDzt2/dQ0S8VvqhCPYLuSLy0I4VkTabL6ssf4otGup1GuDnRDzJ//rP0M+sQZDBxXjTTK5TLfL2TV0fcJvP1/fn5p5lndOLWkKA1LkTfhm510mXOIGJGGzkx4BkuJa6PquDplP4/LPd6lbup9gt6vgZ2KvNye3Z8omiTYnHIHrXlQirA54F7UM3lumHq+WKG8tvRRF28TO1HiNMBncDulBqBvtHWJRH8++wXMWny3KrDV9Kx7IggmEeJ7aHavZT+L0PmxcZ5xfbK/2a8rVaZ7KFID3O4QNu8T+7OqrECU5ABypmZdRfHY8+K8CVLDQovWG+shzoYf+wYoi0ueoz+U0fHQAArc8k5xME115r9m6+cd/kdU0PS6fcDcZH/Iu15tAnr04j4BwhVknuY9JDyX3HyGuXLDATy2cSHl+o/3gynZxlPzAXESBj2vI32yKI2ysxvU/fc4pdzkYCbbRAkWUEVFX5YFbrm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0794bd3e-b124-48e0-ead2-08df34374203
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:33:24.7384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/OL0tZnqFH6anQZJB2gIxmc9WgqklgCXTxH11c6hyo08sb4JfFNQisLxeDB8hMJLX5p0GjfNN40h1zLaANEB80quULFf28IjJXcf4WTjY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8563

In general, we want to ensure all writes in the block group to
complete before finishing the zone, as relocation does. However, the
current callers do not need the wait (or cannot wait) in do_zone_finish():

- Relocation already waits for reservations and ordered extents itself
  before calling btrfs_zone_finish().
- btrfs_delete_unused_bgs() checks that ->reserved is zero and sets the
  block group read-only while holding groups_sem, so there can be no
  in-flight data write.
- btrfs_zone_finish_one_bg() is called from the allocation path and
  cannot wait.

Dropping the wait is still safe. Once the block group is read-only,
->reserved can only drop, and for data it only drops after the ordered
extent's I/O has completed. So if ->reserved is zero, no data write is
left in flight. If it is non-zero, do_zone_finish() returns -EAGAIN,
which all callers handle.

This makes btrfs_zone_finish_one_bg() fail with -EAGAIN when it races
with an allocation in the selected block group.

Fixes: 393f646e34c1 ("btrfs: zoned: finish least available block group on data bg allocation")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v1:
- Reword changelog to undermine why this is safe (Naohiro) 

 fs/btrfs/zoned.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1fa855a0c31a..35b422a53e2a 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2604,9 +2604,10 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 		/* Ensure all writes in this block group finish */
 		btrfs_wait_block_group_reservations(block_group);
-		/* No need to wait for NOCOW writers. Zoned mode does not allow that */
-		btrfs_wait_ordered_roots(fs_info, U64_MAX, block_group);
-		/* Wait for extent buffers to be written. */
+		/*
+		 * No need to wait for NOCOW writers, as zoned mode does not
+		 * allow that, only wait for extent buffers to be written.
+		 */
 		if (is_metadata)
 			wait_eb_writebacks(block_group);
 
-- 
2.56.0

