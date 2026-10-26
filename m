Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031019;
	b=Dr4W8EzSMU0gsSitBhoC1Shggr11/OmfOI+nfWW7h7O3lr86YRn5f1CjY0VwAP6VBwkp
	 7JDld5JQfQTrNFx7G6yr6h1RjCczt1cUMLgy8jcGZRgpjVmEECyDxVYt11+1w7E+PVjTz
	 UEn8t5Bn4OSzyF2dmQYkKilCEkG/voYpxJXFkN2XkjyA3/wvOOlbL3tRsJWeaypF+nfMC
	 vYhoXCGJTNiingkTdu4EAtT7LB0t+/su90HrNGfdYVKrXGy4zCCxn0xaVUNOfLjGEFPco
	 X3q2SXnL19wtT69inJSbZfOvIgPBwng2mO+oDcWaw6MpmJDARSuT40q/hboAV9Yc5Qg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031019;
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
	bh=Tdd8cOeN+7UGJeqjsXmRCt1Xl2ywfimfoJIlosZxI8A=;
	b=hd8v4QNuNvUnN3dYMTGRNb8ILPN+x2Nt0p6bcZoFjMr+A2fNiK+xiVw6Vv9cF5HSZUz7
	 FQwEHaH1emWFhn0W11KDrQOACvm87QY6RX1DGSeulR76YGLRifILSXMQ6S5azCAxbsZHA
	 DZyV3YgZsUyjJ1xh3nOh3M40nob2VOPiI1PcO0BgyFkaGYvDq+iL/ddHTntisx8ogSMkH
	 2fKTejiPvWOzb9DF4qG3PjME8S95zNEukhW6CtwGGts8ZtnakUCOkprcMWIcK5QYQpcdu
	 o37pbkO0HwIbLYWsTRkz+QZLbGDm11d73Nv5Fy+vBq3YTkOP59ZCNqLray06u7JeYQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="Juh+hmb/";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mjJJEqrD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BBE606A321
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30BBE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Juh+hmb/;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mjJJEqrD
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031009; x=1824567009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fRGlv6Dyqnis1J3+dav4ihd8Ut38RhDmvRRmio5Hka4=;
  b=Juh+hmb/HpdwetNGEJC0yBKWz/uHzY9bGK+mAOgMVMQUIiYWaeTcd9H0
   vcVeFaPtmhLLxSgVhcahuMZuApWHNBaPWZIzsZFcKQ5WgmUuciWOghSz3
   TkXzRaKyMXKz/stdDyg3vPbfc2f6GmNZ95nZrZMnLz141Xp68s04DNKaA
   1AlwAkKyHkGkCzsQ0VQoHVja9E+R0lkQpTVfPIc0+be5MAZovWOGL5BNE
   f2syv1KmGcwqNNEavXn8YxUJY8g+j/IHdmiAkUf1PqoMjAH03o/IJiXTo
   eyJRH6Jg1Ikb+od+ZzuVOrhobj8JOE5szNXH24UQkPUkf8SGzRcgOLe68
   A==;
X-CSE-ConnectionGUID: us1a0oDzQfawJdXhk86HWA==
X-CSE-MsgGUID: BJXFEfTGSUmzY2Zl043o8Q==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033908"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ph32RAQr5K6r1Zy3lBuvAEfaYo75Y4K+L+UDcA+Q67CFBHjGf+GvmCrRcJYpGRGBF5ob69kh5PBVTR94KcL7c9zuBhtyeVP+o1Y0B1HpVDXLIAUO5aDeIphutMZ6kN9RgMdqTn1ajs0ljW0vOUzswnxB53UKdU9/XKck0dP6IFqNfV2VxSbwj7yCIc2ZwjLU5Dy58zKhyvZ1PJU1Pkn9OZMOxwmY/Fy/BI5cR0BlHktW4BriZokICCX8jze72ohwyHGk8rn45QC1OUsOfotigV0+V6D+M3ukrIbWL0WG8MYEAzBm+Yg9Vw4JWJHTj5Jx4nYjMP3Zpw1N20qOibQYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tdd8cOeN+7UGJeqjsXmRCt1Xl2ywfimfoJIlosZxI8A=;
 b=J9GQGKkKy9S7XrbnkluqV80vQnjJ2eZlab8fSr6ciBOF/QV7SNcVsno2yu2gMHRQ22Qt9ECsyDNPR10oyCVEX+8MLDVua9HTqrVfobiQMe3wwmO1vkZlTl31R/pDDkk4Yc/kM/8g96qf2paaRIKFRMZGwoiRW0beMWKRAh1F7nRcAD+RdAL2GlCFyY1qUaKNAg22GALxFsuFpd8OhBcL8gPD4y7FpdZD0q8UVbbSSYr2uFyxYMm6Ff0OlliW68qhWV50jf165MN1a1CRjTduFOEWt03gLc04oOWoAuXpCgguu7SHWxnoOQIR0dMFloofiCfbxIeIcaSa+6waiZY5bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tdd8cOeN+7UGJeqjsXmRCt1Xl2ywfimfoJIlosZxI8A=;
 b=mjJJEqrDXv29+oivjFdeGqYa4YB4GUtXiNR+OtpfMmlmKBQS2/YxKog8hApsyNbKrUGsMqJm4L3H2PWrQPxmSXGDSLGPUWoyscfGbc1IPWbnxxLrPbSBLlPr2tAgX30jAGH+i40aLD4LWerZLnLq+enGp9Q8ZwB/ztX+crGLLMY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:51 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 16/25] btrfs: zoned: don't account superblock zones as available data space
Date: Mon, 26 Oct 2026 17:09:04 +0100
Message-ID: <20261026160913.207909-17-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: ab89d358-7708-4861-21d4-08df337b9080
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|260925022911599003|260925021911599003|260925021311599003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fjB9JnBdcBb4g+8P6zJvRtw5KGaS5OXrVLxYayFGfHl9VS5VqvGjK8IPdmqRgLaYm0RozPxQGKuGJipCTrCvakUChJhNTsBI/KoBhU8Q6jREXz3fDMbMr/I/iuc+1pX0c0f8COvLp2+mq7rC5DTZuK9qRTCaxepKgGUyz0A8aEb8zPCO7h4b2V6xXixZsXbqGCV+N6xx7Cz/ORMTgnd2dkCTf0lU/QmGcIuHonBxdNEEJ9hR7pue8tx6WSdajmBqR6QJh1Go0Y4UH4+sryavBujaz2xzMEaZKyroYiXQcRJHvZtxtjHoO9mM0pyuHkZo0ZVuDggDB0jYFNrimPB9RPd+aHCQ+mie4L2TcCs/X8Hpr1nxk3LH2wGDcigFI1UNlCj/7Y8AbRKoCjKpbXvKyi4UXpzeA9I+piMT4gXskpz6L6Eu734lAXLO7pCat0kMyljQVNVo6/jd6Gkc/V3sm6Be3NbR5jLsei9hr7HbmaS5nEuHp64fRezEu9NodSJuNwCoDRJmMahyNlSWXyNzC0EOQyufYYRwHxg0Cze4ClvAnoetiRmQSHlv22oXKoKvpPzDGer0jEePqhsExaiJ0EgI7lm3mR8+P0BhbhG6D9THAHHRVl35DW0bKwFZ0IA262KsRml4gYfGKZd4McqYevYVEMP/slg1Mv+1yVss3MQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(260925022911599003)(260925021911599003)(260925021311599003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0D3DbXLh5iULHLrTuAqk4OCV3bjhL3KX0Diyw9oFWi7JM9Vlr6e5OQ5T0XI6?=
 =?us-ascii?Q?JBtGfAD4pOsFfRuCrh9gG3B1VrilcytoXyeI5ANt8SEd+CBFdIuE21ZHj0JL?=
 =?us-ascii?Q?UaZ4xPNNo7tCLIoe/9JbuICZb1bFmYWlqM6ds+ShYzvJITjAOwl4sA4e+GLr?=
 =?us-ascii?Q?bWdGJqJQmDZrnoaX/oH2QjbvyXpR79CkgWOjVVnVctG7NQ6Q7Jxs5S/PnsbE?=
 =?us-ascii?Q?dVzH0ihgPEhtWjV1kGCPXdjCbU57dqBomLXWNdAg2qB/2arC48lzeDNF1/S1?=
 =?us-ascii?Q?jhsTC+jPrFPoAbZOYbTKuqWWZIUFdJBjWeic0zRp2uNuBXu1h6iAJXpwg6hF?=
 =?us-ascii?Q?DGywGsmLE6/z/ft12Q+p4usOs7ZgXVyjktXPfzq3aS2Bm1e/4SSdx/goUEsm?=
 =?us-ascii?Q?1j2cptELUsTwFA2gCsQ5KiE427e3K+janQytDLa9kXX8lTCWOu9TfRtCuO79?=
 =?us-ascii?Q?dAUordLUn4MIsRxj0dac67bTLsYJjJbD+987TF4Hr+r3656kf7TV3Es0ZQ8c?=
 =?us-ascii?Q?+A1VBwwCV9c+EbHj2rWf4yRPugs9vjTjIbANmL57NIYnboh2f/f2YX515qfd?=
 =?us-ascii?Q?PrCAYDKKtSqAI+URu3G53EU1gArVd88OwSL17vMQPbk35uPdTqfaYxc7+fP5?=
 =?us-ascii?Q?RF0xneT9m9gWujRm31oYQz4rNuVXSq6iH0Q1dyt1vWrStlBJ8p4MHCq4OXX9?=
 =?us-ascii?Q?MCvy44kr+t3GnxIia1HtcGhmdOHDLmlklirvTtReY5gVnOZ/84uZBUdSXqKx?=
 =?us-ascii?Q?IctXzEEadyn9CPVo55o71LWdyVtY7q73BZnf2/18QqDBXjk/Fl82DHDlmZYr?=
 =?us-ascii?Q?BYu4CP1Du7eiW5MS6LWamPk/tG1u0vOhGtsAxeWz9rmeODCRuIg1Yks7PMp/?=
 =?us-ascii?Q?6xAsCTeUBdBVgjft+Tm2ATjobv33rrHSmDkuO28dPow7NJOPhzgvoURNCu9a?=
 =?us-ascii?Q?mrZ+ycR6QYDLKcDyjhtWpgzr/L2/QmYnkFitpENC9X0XpWzuklaVa82FsuK4?=
 =?us-ascii?Q?5WifbS8pXmXWSB2iJJPq654CDmnwe7qx02P2t2SskkeJWl+EYeRmRlN9yAcP?=
 =?us-ascii?Q?HD7qR4Wrq+3UUXVbgWzPChyRIwyyemCK+2kle9/6VNKzYhvgWmJq2OxC+Y3D?=
 =?us-ascii?Q?FZMoSsktvgLHO3Dk/JWC78ah6pty6W8nuLs0fqNVMjoftmpxhyGEHMuHzGK6?=
 =?us-ascii?Q?Jzm7C2rJfgef8dA4bWmPfoNHEEOapc/T/YhZHetHkQsebS5zQdQLy8SjZYJJ?=
 =?us-ascii?Q?TEQ8iPGiQ4Q0vK2K9TG+OXDrMFV/4RCN78WGVy7dwHeAXLKbxmEIoOlIkQRU?=
 =?us-ascii?Q?8E3t4gSkX0rKDkd8/5T/Q/WIYLAmltyawE6jIRnnT8yBtopcFMa0c28JeXB2?=
 =?us-ascii?Q?BSf/jmBSK7FVs5LbvJg1zCWEI7+s9DuKtmU23Wif9pH1P9j4rvp2TNv7iswB?=
 =?us-ascii?Q?BfU8apnmKqLUXkVfE9eye1ALpEKbkoXDfev/xsSois52NaB9Rd/gpXTZAcJp?=
 =?us-ascii?Q?+fifKthDbocijZ9YG4R0vQXcXqdDDa7DqVAohoO2T8MKMduwJUDXi27DuC+q?=
 =?us-ascii?Q?atr1gkOpkOalN4m6r6MAswP21DqKvta+vBIX+aJ6t3Ap5yn1swtCKPmI6dhj?=
 =?us-ascii?Q?BprzWKyZNpZIL12R5CAaNP6BRjgNM4+8KUoupIrhLNlbrlBJBrkuu3Z97djE?=
 =?us-ascii?Q?f+d604g1ORrs3bMINHSnUcDjnX6jLceDtSC9mxiXWD1EXzPJSpLt7uTetEud?=
 =?us-ascii?Q?zIMa8wXG4NKlnCznPAj8GVV70Nik59XykaypfMVLajhU+LHDEi7r7+6J1+Nl?=
X-MS-Exchange-AntiSpam-MessageData-1: xbc22e0pE+cWvA==
X-Exchange-RoutingPolicyChecked:
	TJIDmjx+PYAHHVhgyjJ3iBvWgn0i3ZQP3w1ATARs1JqkmB4hya6/D2gzo1hfSN/ptmoVWIEE/IHkob+npTcUttNg/GwOY2Elpf23tS6cDLIfbbK51Or8icSamd5lqrHoS3o4K6Y1LWdhH+rN6WH1zSyg74kzOoh/n6smK4sqPKTzLpy6JwMqXJ4GaMJTwWRihB43uHGqAU4/x4omJEGCSWBcfScPedyrMOyT5BnodLh0tCbXWbUa+NYhqvxR85hTkD6QgbFj4rMicCVk7RbzezWrB80Ag0nIoQgWNwesHpSNfSVr47r8JmvKHO3Lg8xnBJdvg202Tq3DofVarj8hrw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/z26hrU06kDw9f5L8BkMfuOgryrS/2Angb8cRrA1IWD9iFLsg2ZmowYTrvTNvZj7SBjgzK7Ns8OmFub4m6z9i55PlQffc4ckj6Rq+W84TKj/wrNYGK/NY08iNYUaH6npLRgVHAZJLn+UJDFypjN7/igMr0ALZQ2guH+Vy6rOL2/xbO0fylvxpe47NEDVUEYnWgCJQKjRH9cPpN5Ft7zTMTR/2yRcV/FYRsMqseF7zoAu77Dc8CW4PCfQ97Z+WY2NsqNbHR1t5Q4skm2Duut2o34n+AAqmpjnOoqBiivoH4lF4ArYnvj2WdZilVdxWa6Xr5lWXgOnZgcKDqgIMKAutcn7GCubJFiPGTIuoHnPNqYhyKGTgvDTQCAFePLI09mUwohSLHhqilRFFUr7s6Y4i8J6bR2y/kTrU2tZ5WX09FxxzDRSktuvG+UPfBxkVat9lKvB67TTgTJBqaDzLxfMeJMETmXRFGROwvwKeepSKaKBPzoCH3d1N0laA+qEg1IX0s2SGuWBDxsdwSzMy26jMbDuwF4ZY72eu5xq5fEAgaLhEK4+yQXWLt+4DDLlkCinhr4L0zwmR5DmkbYmiwPyWTR8XAVK4m7Lz/bMOy/tkXogmvHFAbcADr/6bwNmfrxK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab89d358-7708-4861-21d4-08df337b9080
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:50.9739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IqGCEMLM7mMo/8Y7UnSb0CxPUbtC6s6T/Yr1MQodSnUnTOcTMEXJUzlk5qpzA7bbQsdYoxPqJ0b6kLBtVBUVR5MmhrZ5KRUAhcqxeh7zwVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

On a zoned filesystem, the zones used for the log structured superblock
are not usable for the allocator, so don't account them as available
data space.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c |  6 +++++-
 fs/btrfs/zoned.c | 22 ++++++++++++++++++++++
 fs/btrfs/zoned.h |  6 ++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9bf211916870..0c8b8e392c84 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1646,6 +1646,9 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 
 		avail_space = device->total_bytes - device->bytes_used;
 
+		if (btrfs_is_zoned(fs_info))
+			avail_space = btrfs_zoned_dev_avail_bytes(device, avail_space);
+
 		/* align with stripe_len */
 		avail_space = rounddown(avail_space, BTRFS_STRIPE_LEN);
 
@@ -1656,7 +1659,8 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		if (avail_space <= BTRFS_DEVICE_RANGE_RESERVED + min_stripe_size)
 			continue;
 
-		avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
+		if (!btrfs_is_zoned(fs_info))
+			avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
 
 		devices_info[i].dev = device;
 		devices_info[i].max_avail = avail_space;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ed00060986c8..1a16beaa299e 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -963,6 +963,28 @@ static inline bool is_sb_log_zone(struct btrfs_zoned_device_info *zinfo,
 	return true;
 }
 
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	const u64 total = btrfs_device_get_total_bytes(device);
+	u64 sb_bytes = 0;
+
+	for (int i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		const u32 sb_zone = sb_zone_number(zinfo->zone_size_shift, i);
+
+		for (int j = 0; j < BTRFS_NR_SB_LOG_ZONES; j++) {
+			if (zone_start_physical(sb_zone + j, zinfo) < total)
+				sb_bytes += zinfo->zone_size;
+		}
+	}
+
+	if (avail <= sb_bytes)
+		return 0;
+
+	avail -= sb_bytes;
+	return round_down(avail, zinfo->zone_size);
+}
+
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 0e4657347928..20180934aff6 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -76,6 +76,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 			  u64 *bytenr_ret);
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 				 u64 hole_end, u64 num_bytes,
@@ -182,6 +183,11 @@ static inline int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 	return 0;
 }
 
+static inline u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	return avail;
+}
+
 static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 {
 	return 0;
-- 
2.56.0

