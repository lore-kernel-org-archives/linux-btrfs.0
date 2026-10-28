Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211708;
	b=WimrLZdo/cU6gDJs/OiwfA+n4egv+ETWxDy/mpwecUmZRJHjaVnUgK9dCyc6BRctBfvT
	 WS+HcaSdX/rG4+SvWvAbfYZwq68uXBLGCraF0X4iPtqllmWjVAmb8RE8KpL6CwUfPQCHT
	 3NaEb/K8B/09D/kIt7xAJKul5dR5fcRhsAmr9bvOgA4Cs04g484K/AReXyYgXWM3VWH+L
	 uGm5WlT+55geufZzDerx90376t0Y0TPMpCeGJLCZiC+E/MCzjE94wa6JnjQSuAVfB/6vq
	 i0ZWi9ul38IdZ+ae/MoVpxYABITcSM4qgFhLfBL+C5eKIoqu7c5WgI2UsYrXB1gAmJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211708;
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
	bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
	b=LiyMQyPNiQGjDfm6JcSPSh1t9zb2opxGOFWcTQPxXHuUOTUR2siGRKlgBrA1JtQje+KR
	 PmcDb2+wdNP/ARV8BrIZcpmQvjIIqLZ9yyCn8KptEVrwFSreeN03JD/QDQ6L2GqXW/yP3
	 vggpY1+R+KDQWvT10M4hrHV8OGv/bEmb8WEx1KD91q6J3gm9aH0G2q1x2Em+CcW/AOx5M
	 Vj5Poq3GFpZkIkBjSsDUBxIwkE1R1/jnfB9k7gaCiDV8tFmr2kB2xB/Pc573C9lwDadPZ
	 eTtt3REZiwoJhAdINb5E1pRN4L1g8Auk7o+TIGMrlEnX8ZrrDeeylnLMahxkPLVEq2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nTf9FVHW;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=fCfAF9wS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E136B606A33D
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E136B606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nTf9FVHW;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=fCfAF9wS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211707; x=1824747707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3F4P4/q6IS5daclCQNXs6rcgHM2VTM9cAuRMwXON0Y0=;
  b=nTf9FVHW9ay1fVQDLFrRSFgW7j/zuCAM1swZjRVsCGRF1ul9zq+V5diU
   muW8VzLZbE6fNEEyG80vGp1twEqWHKm4C6zdsb0jT8vdLSgZLprAdVzQu
   c4OafCAJlucJW8gipXwPRPTMlGb8P+eBfHDpjxlU9ri7A4r9Wxvh4JpOj
   rNmdwh4x83rU7FSyU4peQbIrwuQRDbnUAkNYTuf3CsjZfHJ1IwacLHu0l
   HD15bSZsL0Ouwm+ivyUOFgxIav8XS9mSFlVp2ZxbPRhExi+SILCM+OR9Q
   uHZ4t0T6RnIjY5vfk7fdSFAO84xUVjgchtpAI4AmZo2BWoWD6bkoAEAZ9
   A==;
X-CSE-ConnectionGUID: 0p1qEVv7TMOopmkWecG6rw==
X-CSE-MsgGUID: 0aCnFiVuQQa70qMQ4W5FOg==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194172"
Received: from mail-eastus2azon11010059.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAdlcpeBVopcjJ5oXIKJFdYAmj+xJp+WBkODiPdMNoaRZbqggQUO0Bl/fdyWVU+D3OUCUWIVA0CfnuWgLeafsrZd9HCBqRLa/vqOEICyIskkSahlL6qts8yOZosPepYNVhM58mq+SQ0VjPDrPx1p5ndz7rZGjMPtZ52PrASUnqcLOa+sWAjW47yC8zuaq+lC3rZfosHdTb31LlBS67fJPpSmhI0ml74GEviGGkwFDxxanGn4SGWvxWZ6TejOOJQxy7FspoJZQRb3cO3zf2bcjSS762dCzM/kjIIpMfzz8MIVogLMW2J7AzUzjjYZpx2qZ/QJrxqjpkOLSCtiH5chDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
 b=BrI8bTx8XcekMr6zTMtq8sniZ7OUgLJO35W+vljvOxOVSW1G87cPgXnDt16GBwpnpg9SJn4qP/QigpkVa50GAGOGwX4p76Z9zIbUn1g2lVubDdwkW5r8cyDql3Ivopj7JAkWMPMzm0quW5w5CvS5u1EDegdgk87fjY8l+xm3OSmAFsQImmiyKoPdtrNrXhWB9RwTz+XBhNcqCjZiUaid0mQNPpCnOCiJhiSF3NVHcMIbwnBgek5sQnyRb+YW7rKUPkcIOVfHv3+iVQbW+px0iDea0bxCBm1NTzIWkhDhkS5pD7wTsUdZn4U5mbnA0RGfciSD6ObYFXjTuM1uYoxLuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
 b=fCfAF9wSz7ZrSnTQmlzZF5XtiiyWqxEmMmNRpr+OS7C+NlulMlpxyI2lXexlCu3e/aIajJ41WTMMVMn9JebE6vK+p+aBpQ8NEdgfkHB5P0wfNYIIDHOrukJNvL7/hRLtZril4ZZxTQlVvUIwdZRhhYdz9Rhaa9pI2wrKy8bo2Uc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:43 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:43 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 12/25] btrfs: zoned: prefer sequential zones for data chunks
Date: Wed, 28 Oct 2026 19:20:58 +0100
Message-ID: <20261028182111.160492-13-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e83fbb9-a34b-44a2-6126-08df35205113
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|5023799004|11063799006|56012099006|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	G+1fy638lkwcZ9XcyOwcmrLZM7rYWljLM3K/9A6OfC56UNOpoLDRe/xukdjpXeF/XIZ7jdPHH3Gk1+zAKe2gtBOhP99y1ksKDYtng4Wzs8lM2C4FLJT570mYEsh74Z/1XuZhY8hZpephVoHNc3LOedt0rmMsguJsfIG21Oqi8xur9eyUh3KJnCrlGoL+kMgR2gS32w+dnXsgvXXzUOEzohDwDsi7kG+g5zWWo9ILxMfYW3ZSenSsbXVYPYyXdt+J2lKfT2e1TE0HwA885Jo7+oxlp6u+49+j73VkUTlzVSEI0JgMagt9NHsNOrYwzpviDyKZCflWy6lz4aiuhzLvGY8gzpBKRHLqtEpoq0Jz2lLXawdJncQw5L+3d7ag4JSJLmxJ4wHmY/rRfCW1DScswmEMM6fuBV39hhpxUMxslArW/1E7Ix8moQdS5Sx5nUwRPpX3J4vnCjxdCEZSyBXcnhdTPcTkX/jutLfxmdOKPeFnJdXILrX2hY/9Xk1d0NUUQmVP1AqyvxM3ty/m6r3gFP/szaStnEi4UzfqHdnrBpQ1wrlSEhMQoKFEqCwsTBtjuPF3/QeAXvPEo9Vr0drbSfhP/k9LjVUtr6UXebNv8a+fEttak37m/WSHDNW203tE+7wLw8+3j45ANtiPIqHuc6cIIiGL4JekOKtQRyOmK/k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(5023799004)(11063799006)(56012099006)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qNgU8gjYnaqyBGSkYamC8pmsEcg5b74aQ+2PiIuqO9HoK2VJp4Pc5BD55VPa?=
 =?us-ascii?Q?v4t/Ny82J4U3fm55+hEuzubvNXERS9ddKcmxJQ7xya7uMzH+WiDJahuzQSMB?=
 =?us-ascii?Q?bo1IGA/gki6LFBMRDoERiL66DIwgvnEYqfWG+ld1s/jdWsB82pqkbmJlrYRR?=
 =?us-ascii?Q?GErdMHfKrZgIgGCbfKvxgGK7yKrhTFSqtr44fcTyG8nvqnW8xq7nbP2ZLOFD?=
 =?us-ascii?Q?G7Nb64o9YNr1GAxotyMRoFg/ENlsQ1tXjR2bQr8STT2G2uQWi9nOzzBjVJzs?=
 =?us-ascii?Q?s8ZvBr9VYKOYRccrLOdhcbeFtgvn8m6fdaLGILfeQUHu3YMHsFQEspTUD7za?=
 =?us-ascii?Q?d7hVapWai6qAiBJuDJzYoq9i9qeepaXBxjHd8vqxUhJDDWHHKQAOflEPN/i8?=
 =?us-ascii?Q?x2m94n5rcC2H43l1i9sLVE3F1kAd3y4isql3tl3EkeMFDoWKHgWbKnL3yrq5?=
 =?us-ascii?Q?e5mE5nDVmZJ/y+EBtIVzCs9+FNHSUoUdHrDqY/sOy92VxVuDJu5EDqS7M7of?=
 =?us-ascii?Q?ERxXmq0Jiq8T9UWTPIQffgZjwB2Nwdhg3gA5GeVKB/QDj0ETfWQGdFkku6IG?=
 =?us-ascii?Q?p6CKe4PpRIDK3sgYSJ2+NzBuzKEUK8on1Xx2PlW96BVyMSrgMB9EBpPCk2Z/?=
 =?us-ascii?Q?zHSKwoHLldR3mUTTOfpljL3GMKIHwyew1dpJEBaRojjXAjULYbQlM/yI7/j+?=
 =?us-ascii?Q?1C9hduZXhv8IngrEtoBdMTvy3s3WI3sw+d2Cv3H6NdMQluntt9gax3rn8ENi?=
 =?us-ascii?Q?tt9P2Zymf3P4SPWE+yK/acQ/akbFJkk9Q2CcYeUnxuLBYdK68WMvClZlZU9q?=
 =?us-ascii?Q?ZdZ0kGEq2iijn/gfRlAdncnCtKVRbHZ67QKEnxZ+QgMMD0sLGw0XdE2HoXdZ?=
 =?us-ascii?Q?JxpmdGtRmy3Xmly99WhdtnAmfK/2Ms7CrnTHhArzjhicq3zh02aV5sNEjHd5?=
 =?us-ascii?Q?VNRWmD3wHewAP99p88ckD/87eBVxjAlvfV/FklGIyXWltmamin6hvyc55eOz?=
 =?us-ascii?Q?avqf1S2zWN3Jtcrz64NHPC/cFpDFx+V74J1kxKWozEQ6dbB42YCs8iAnWsJk?=
 =?us-ascii?Q?jJP1o6OkOOq+KwTgK48Cj/2tlXZIv/nBFpCcXTr2d15g4xwl1F0IPXTnOCoZ?=
 =?us-ascii?Q?vtBnvidu/shlLe4RovIj+W4ObtlZNEUhGVqt9v8K7Iye6shNHiIyN+2QOUYn?=
 =?us-ascii?Q?+rAR2bCibESbratRvQ1Da6c3pXktGwj68ebv3rDORd0DA76OotSZpBRbmqLn?=
 =?us-ascii?Q?wQcsfk7hLtGf3iot7tNYaWZdgeCjDkDVPTVq+Oac1Hc+6JrLlVqR0Ne/kv7W?=
 =?us-ascii?Q?pFUavogdxu2mXsnn3YclCFoWra7FC8yeG2d/uN8IaK7cJifMygD4McTfk/Wb?=
 =?us-ascii?Q?HdrzWj5fa5/AW4VlOOEOc0yXq4sytUr175nh1/dKDRod/76sSMzI1i0ucrqM?=
 =?us-ascii?Q?dOj+fLvCj7P7Pv1qJOZI3+hxPTnqSd7gXwaXzqOSwibhVC/BieN2Dpm2ZQbi?=
 =?us-ascii?Q?Brr6WIpAuEaRv+DEi1xq9qBqYgmuKJvonWQViHSiw089mTLzgNY3rbC/346x?=
 =?us-ascii?Q?kTYiAMheFJ7Imd0PkEsqQRqggJGwxTqM3hE6ETPZjr5/bZYlT5YaVOVx5vBd?=
 =?us-ascii?Q?5MXVZ433FKR2uoBeOgaVoLNk/+JzKM+fmYsKWvLrxNdlOUNqH9+1ApCMZ+J8?=
 =?us-ascii?Q?hXrtUmW15qLbpBjKabUqXvjmPS09DSu28mn+52Jws9MRwI72/WXnV99GjkHb?=
 =?us-ascii?Q?IPqI/rDRt9gvsnLhFk++meQIn8SdS4hqYRMYv8lINt/EmA2GodX7g+Nkk1Ta?=
X-MS-Exchange-AntiSpam-MessageData-1: 6FDehgUuYaDws2QvQg+iHYeSVmFFTTYTGNo=
X-Exchange-RoutingPolicyChecked:
	ol6GuqBSwR0o1VMbFu+LZJ6O3/ZEtgO47NJMtzcih3wTgQtLDh3jj2WXSvVj3O3Yf0Ek1n5ngCAxbsbs/bGSitMhGghLgE93rwadf8zNj35zMlYV9cLAmh+ugv1NGoX0oRRuFXA+8+KqOC6E95w6fjCAySrTzUB9xHpGgGULUF1m8OWFxegp+tyT99E03lVeXv4eYse36wwIRKA124mrtDGGQUFgpZSuglBv5E3RXs9AcOgpKpB0pOKHi21yETDnGOIaNE9zxLbejt09Q05OrQHmlMeSoaG95UKpmtMdLadZ9q4DST49dn39CNkJzL4cMGt9MWq9FsiKrt39vX3hsg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TwfZLr41OidQCtNlNow6MR1zNHKzTDOFtzxXw0sajzEYMvQOaVDNydtO8XtJlPRoSnZEiezRnwZRaG0Uz6AOaPid00+mJa44CwN3RxZEeL3TgGaDIAk+sD+mlssyclM7/mstUJ0xTxS8IYKq0pMje6OierlLixLHVUgaKg2+hBxBEFvvKPL9KrSXZ1ZbNHmEAxDfA5pQkRPmFWAkLxIop9WKL0BC23P3FcrbPK8uNlYUXSHHDMZ/C0yx5f4hh73/r87cILiAfFERs0XMowCvzQ0B5K0p0s+QN9u58q+DmL9aPw3zEr2MSPLRF1rBm2vOYc/RhYXb4YN6RADLg062iwtY5Umo6LpYBHjWWQoqyFfU+voWUY/pY7xS/+8DKrcESMHA1UK8owFFoaEziZgIRHnpNlSBnXgv3PyLA58+qYIymAJSg2y5Sv6SsXVKqphNyG9/FJt/tsvqbZHWVUSlDa/GgFaFYTaoiFCJk56wL9ozyzENa0cctvHtTXg+Ln9WFK4GNohqfpe+Kg5JwCeHpUmzNgtOLwLbaqIDHih9cm8AAG8IYb3tW914h+DxA/Klt9bS4ERbS1B/l5xZpY7FpmzIcvKumxZKw2//5KHrIbVRPyl2tLcTRs40e7Qp2Irr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e83fbb9-a34b-44a2-6126-08df35205113
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:42.6366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: udofUBE3l5XYyBoYkO/2OBupjbgFYQecYV8a9cEF8eh5w5w2wHl4U3B024URlJkOm8fMOx08gcdEpJZgs/UhyilNkSP0mbOJg1QZLU24NBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

Data on a zoned filesystem is always allocated append only, even when it
is placed on conventional zones, and its volume dwarfs the conventional
area a device typically exposes. So there is nothing to gain from placing
a data chunk on a conventional zone. Doing so does hurt though: it
consumes the conventional zones that metadata wants, and metadata is the
only consumer that actually benefits from being able to overwrite in
place.

Mirror the metadata side and search the sequential zones for a data
chunk first, falling back to all zones if that does not yield enough
devices for the requested allocation profile. Devices without
sequential zones, e.g. regular devices with emulated zones, skip the
restricted search and keep working as before.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 76bd54af8720..09449381fe2e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5897,6 +5897,15 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+/*
+ * Metadata and system chunks are preferably placed on conventional zones.
+ * Those can be overwritten in place, so such block groups do not need the
+ * append only allocation and writeback paths.
+ *
+ * Data is always allocated append only, even on conventional zones, and dwarfs
+ * the typically small conventional area of a device. So keep it on sequential
+ * zones and leave the conventional zones to metadata.
+ */
 static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
 						const struct alloc_chunk_ctl *ctl)
 {
@@ -5907,9 +5916,9 @@ static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *f
 		return BTRFS_ZONE_FILTER_NONE;
 
 	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
-		return BTRFS_ZONE_FILTER_NONE;
-
-	filter = BTRFS_ZONE_FILTER_CONV;
+		filter = BTRFS_ZONE_FILTER_SEQ;
+	else
+		filter = BTRFS_ZONE_FILTER_CONV;
 
 	/* Avoid a pointless first pass if no device has such zones at all. */
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-- 
2.56.0

