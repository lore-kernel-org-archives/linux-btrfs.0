Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085780;
	b=Zpd/OnQzEwL962H2gn6S1uwHsTm4TRHrEd6mbj1FfJb0+TjAQb0UxZ87fRY9FnvuKsC0
	 KUJDzV91M8pyCDQR6gbrhkhDhQ6frAoOVJwiBsmdpiSVAykWwmZcMu6QxNUdqqWC9IVzr
	 L9Kq5qhYsrVEXPn76KoBeuEhZVq6qA0BEFUIiOLylmXzJav9eHyBZX7G+qyRPcjfTg3wr
	 QQ7A0Gw+tqW2a4/RmmcBS3AJYOrr31NqaVf3+OogE0Neu8uyThi43w1Ybr1wUp1mLHAl4
	 W5dbOd6GZotDfJS7SoFF747RdUkGK2q7ecNh+1GXOVD0rVl1S9QdUf6pJQ9cyE1Cpwg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085780;
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
	bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
	b=j2GgOZy7PNfgsxT8z7nzIe8qQAmK1XflkVq+iUxtLxfCVkt6WxlnIkS31VaKgnNZ5Ke8
	 NuCaoy8zY7LHzjEGi/kti6NUe5z6PAQIfcxiOyAP0t8YpjnIFimIPpRWtczdbaN/B2Stu
	 pePueWrMamv6gUou17q8f7p8fz5ZlV5Qsxo8t2xmkawm47xCBBjwHHc5mwlsw+LDo1YPV
	 2H61wP24tzTN98sf1hPzsVrxs6h4O5RLfxeZ1LNf619YBDTRBnEkltgRzVRzum8F4eaMv
	 zHgJ70TRjIpWuRBbSB/XIb1NP9gDJEahkHJSCwzNgeFLy+oW/xu+yq0vpL7omqVWqDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=el3I9c0b;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uGJxqsrK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5460606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5460606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=el3I9c0b;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uGJxqsrK
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085780; x=1824621780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vV7uTwbnL2Xi962H8HKrQSM2PsKcF7hodGI1MthiRaU=;
  b=el3I9c0bMMaBINx8o5Dng+0SFklfgbcpNo4N1LVyKaa6z1RbACcZricu
   jHGvWFyc9QLdxjGv4SBbykabOGS9cFfFjOvqFd0qGcLx7n271c1XtbG4U
   /dx8bvRFTiXlhoPf7EsAZCewIGA/kKquLj2yROZqJ0aS7ILyc9jVo2mtT
   Qmd0AGk5AR+5qljgJjFWgx32ARHnxMkF7jfG2kwnXmV4Z9uRZvDi+ndgD
   b+wNN0bYHXhL0l/q7dEkNWwbPSsm0tf5RU0qbXWAZN666PY2MKEMo4/7H
   DYZ4lIBumPWa2wxltiEpaGYqKxBW/tnofOpIZCLA9gbYflNE7XxBlkjFt
   g==;
X-CSE-ConnectionGUID: CSyxAno2TMCh2DBogHePJA==
X-CSE-MsgGUID: V2h3ibitS5SIFqWksM5i7A==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863261"
Received: from mail-westus3azon11011008.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ito2j2UwrgSsiHG3qJ9UwZ9IvLwegiFCgPnwQM70btiV2fzjdNeLMdHvbjUpEMvm0bRZ6SDHab7w2Mdi9J+CtcTs4vs+rkofkQYNYja7rX2ekLfZZCALa4E/51Zr92n9yLO50VRNG+kfC2w/ZpPGBHakqWadM92gC+UBNsv/BXxmNyw9MN0SQcsceoFsAV11K3Hzq8Us2Yt7miI8MthnrXGiiRF+tePqRJBrfdal28e3xkLI7fbvahAdbphPjf4JAyHnmllhxekvj8OAntm4mXUx2vacFuF/q+BA38Xh76mu5fiQ8aygKyGlnmvaDgP9jqTiCxycLEC715LpZcZ/qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
 b=vmGr+3AnaZByJL8QJHJTGl9sEsyLPUOgqLBKAiyo3RC1N1pSPp7a8c4hN5FZkKcFN/Bab3REpAQrV0gjs8U85br7vOcbN0Fwpy5tQTmkD0t5ZcIOHmfIL7dHrm6ZaaMXlgUH2yIjI7X3bHU/473mtshTb4Mxn3c2PaJhko85GKKZXsGG0illga2bioOe9zZUyEtJy2wC1vMu9BIRRIWdSstikZCyqwg6pkJGmAD3Aag2uH59hhcPWU9faARO4jbD2ACDMuGQWy4BpxGYwS7aZ7EWTRIqq97yf3v3SOJ29eel8EWUBd00HY5OQZ/S3zq6gmzLAIX84sjIP4jn1gGNmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
 b=uGJxqsrKiw+4e+b+95C5RXqgEqGnMvZeWXOpAjBpO5/keWGT855JmGVOyXknhB5TUUhGYsUXCreQmIYvqtZIfvmqLP73ysEhuyVY1UZC5Nl3HS917/1IuRap29yEIz6eRLrjy9BJ2PureieNmL7+JlNviJLpAjd25r61hXIPkw0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:58 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 10/25] btrfs: zoned: use plain mutex lock in btrfs_zoned_release_dirty_metadata
Date: Tue, 27 Oct 2026 08:22:16 +0100
Message-ID: <20261027072232.419318-11-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 376d78e9-0ec9-4e17-08c6-08df33fb2033
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	Ybb+i27nh51v1IgB/ubNJTFMfMWlT76u6epYyMRJ8ezkpRCLIDTJ96kyg6SHUrLlQrui7+Q9wNkvF2samHT4JNyc10FzXfJZf4Z0d5e4TKzgbTufNh6gg7D0Bh6jGaVjlGQ/Rv2T+ROy4EuwC7DY+EE38PSwqh5PweZT3De6VdeZ7UVCHyulaA+TzdOCrFXLGXYzvPsbYZpWC+7j+3yMoyNpBs82VpLGZeiWtIjhUyG8+AdxlpgJWqqUHCsZN8r5QWdDvCf+s7fFvH4678YgGfxo2xoL15fVjEhiBSNeEz8JwJqXS5rI52rmSZsoafx0Qy/8F2nUQkV+QmWz3TP4Mgpbk+T1hForU6FfbKqJ99Zvxe6TtYFOImai8F8qCdKlmeG5hC+YGgiHpPM0MVwwgJXT7Vw3YAMNxZfgFXwUM9Wy4gIg6Rz6H5L7L4VkkEDFbAiSwwEljHT0MrQ0fNHfauBxphxd8IwoyAbmLfcATpETIVkYvomXqZVB1hOnYlQA5uTonm3DpjxHhfHL6ylT8dejKnoRXVcM1GeWD+6vZE972gTABvLAUTlFOTUPS+Y3cwAcV8qRuwfHL28Klzx5twwlIBuSYf3MTgc/2UgxgtkG6Yu+DbLgZ5iOYWmlVYfvryHM1N71o2Xc2BOuYtAs4PFSIAy3hFkXzmH9PrQ4Ug8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iEAcBulD8B2hytAJY98P4gIY5ghx1JFYZGsbAF9ggziT0uFrlnvKad8YqkUo?=
 =?us-ascii?Q?/fylOCOMWGA9abcFJn4hk7hrw71e5riTWMi5PErejAzd6thUCu7rEhdd6HHD?=
 =?us-ascii?Q?GQ/qK4HNeNplws0PMQw3U6WV8WmWJL2rpiLg6SEs+k9U+CceAkJm6LHnOo9m?=
 =?us-ascii?Q?MwtFiS+167mOeFVkti9L65noDbP96kIybKUdeZYAMl9i9OSD97Uf7PKtnJbW?=
 =?us-ascii?Q?NeR+bfwmeCbA981ihRnhSckNqsotdP6gZQPmMT4eg8DPoN7fE6p5yFila/Lz?=
 =?us-ascii?Q?nja53gY8j/Nw2r5SMQxWDgYtIpAfor5/C1kG3BMJdByMkk1yivRSsrwBydVw?=
 =?us-ascii?Q?F4/G+ZnsoknfuDyFgCbCSSJ1/C+Z7QWckww24xGjX4/UZzuo4BqG2lbOyCI+?=
 =?us-ascii?Q?HoDMSVtdNDYajN/rjp8//9gifTkLXk1tgodt6NvixzWdHAq/XvgzHYiz7UiZ?=
 =?us-ascii?Q?i5gDhnmxOZnNfQ3ZaOMXfnkrlWav3FbdribE6h4/AJOOc6WT6LthQ6QBKjNz?=
 =?us-ascii?Q?dlgafEArP9ROElT/445ikiEvx9BhUSYDblnVF+TKQD/dl9MTG2C0GE1juXrj?=
 =?us-ascii?Q?ggEBG5U09QMUHqr+77Gef+/aTJ1TWQ/93VSyKpFWz6EXdk3TWPA4/fzCSkCW?=
 =?us-ascii?Q?+9p1u+t2ApEtX6O0oBk0/XMzq7N5NeEGzb3Qay8hecDGKMT5MBpbxvR6Zzfw?=
 =?us-ascii?Q?98lhvXk6cK6L6zlncUkAWJnmxFXETkht3QlrlufyyY59LlLILdz2Qq3Umh7b?=
 =?us-ascii?Q?+QeTTQR9Im0C9b4x9X8/3y3+m1tisYEJXKP1XWsvOuziVGaliDP9/GcfANiI?=
 =?us-ascii?Q?OLFWUIgKStggCAHXlhG9gwKFcOiIr5yeeGESWdTxLr/NiSfgusM5B00dXnWx?=
 =?us-ascii?Q?pphpPIzTUmy1PLcQWcQCvgBhJG1rddIs0qYDIIJ/Wq0MECc5532jfpy7ERn8?=
 =?us-ascii?Q?C66ks/UqHf0RR5gAt27ppf6qst7FNCgAnIKcUU/cisGXB8hYsosFAOcFcZtn?=
 =?us-ascii?Q?ckEF92pVZkbdH3ANQMxto07spir2ASRvZSqP1gbbZ0KS2PGOnl9W0z4b8xaD?=
 =?us-ascii?Q?F8bwmu7lMVW5HMsDlud5JOwIPZiX21aUht9kl7fgfmLIufdBdIJo7U0LntIX?=
 =?us-ascii?Q?csVvS+jg4yfE3FyvRzKF0OSZgpfhU/NZDPvU/t0aDAp7mePFTXKHjAZzIR6p?=
 =?us-ascii?Q?mLPPBfvTjTOjIUcUcOewrGh7QjnGfV9azhnuhzPrrq7jH3jaHJkZQknUOHlv?=
 =?us-ascii?Q?ywP9/WJyETnjexDl+dNUYBEBO1pPyNkOQ0ribf17/pguFYPbmzz3pa11UQ+D?=
 =?us-ascii?Q?Xb1ckG5mvebxG0RSxxtT/ZDqrMCfb7hyZgRiiqxDhkrxBjtqDNmLSQjOdZlo?=
 =?us-ascii?Q?0q1oZLo26PlKFT1D5RHwIFHR3Kmkro5Y8TCI9JW78BH1UX2FE7IZluuO3BvI?=
 =?us-ascii?Q?LqCl1ENzx6OOJ2jlj6WA2bGLa21winnoOaBED84fs9ZshOSn2+DsFP5ukjfn?=
 =?us-ascii?Q?/zD+lbR34K0CJw2mE7tfzljHkOhaPmx9LaKB8Jr2YGEAjJ31/gK/Y9pryp84?=
 =?us-ascii?Q?jBWSestPlqV9XOtARIgl+hjKs7GOTeE+sjfwxfl1vaT39WSji3M/T/2Xu4WY?=
 =?us-ascii?Q?ocKwNK8Wi/Af9XXBPymmWwF+EceXFkKpBKhEqxLt569QgkY/IHmKStvyK4TN?=
 =?us-ascii?Q?ucPTdCVT8uDACuWSzHuVfdmAlZj4u+5zrKc0RfspjUXXZSERan4XygJGsv5a?=
 =?us-ascii?Q?h/mDIaEs35FKUd6s4tFPEkNfaef1zWkLXY6cBp3D4ywUvA7sC1AnDMCp6/un?=
X-MS-Exchange-AntiSpam-MessageData-1: 5u6dIRFW1SpHmAZoDX2BFsEfHUC1XFHCkDc=
X-Exchange-RoutingPolicyChecked:
	KIzEckcRs78gOPIptpeqwTJBzaVk4PGyoNWR90kH2ik6hN8GOJVPgwGQUiuyddmApqirPIzj0oYM7DwYWaldqzyXmMU1EUpn/veLynOYzdyDqtFSPGvMTRZThkid5FevCbiHX3BTY8QPnVm4tR0lramnywM8FjSwfErsZgEz/owLYk3QUky6Uw9C9JjBZP0liYqNDgrUyxZVDp5amPu8eoPryq1tluVoeKQPAg4IixuVoFyPlaiqtNiYhmP3IzC456duAgnf8NqKkkBueg/+kxHaLOTbVJ+PV6zdSruIcYTFAG/oBQWbSiXVStM0jI4dcVBsdjl0u10jpqSOk13LBg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/qtcAvZzpJIgwiWk8g8LRveL2J/S8zzNGJ25Nnkew5xhD1ku1TV7ST1jTYY+MBrltlHHd4nyV/L83n5Wek5biqr8SljV0PQVIcrtbrAciCEG6Ido50Nnr5wBWro3FwPIAehOUtsygKi8aLdg+iI9yz+KJgKvDZpKb9otf8xC6EWXfFPBxQWJHWj7HZD7P+VB4bRSzaOlh4zznNlZ9urNYcu6Ucc9eoNWBAyw3tmssjNrCM8a5ZM4PJO5200UAWFLOKpoNUSvn11KPQJUyVGE6IytsHub9k340joteNrh9s/hod1OusXAJZgQpb4O1le7moyPu+uneVVn/egszhr2HM/lITbuYYezvcdpQe7WM0csHlxP+Aq/amFSryiSaUwc+cxMo4h5OotG3FWawEn19U8gF1eWdSgAdGNbyLaL1K8e7ii9RRYD9eUdSWeX4QmKqTtsTPZfYJcnxdTkhsS75WDd0PMkaWEZBso+oNHcOVSXbqKmhAO2qj8gl3EgVVOXCCxKV/yFg+izv3BTctLGF7atLOPehpsH5WdLwdH+2+D5ekugPvikfpPv8v4tVTFVFkiK6EGYqLQHQy6IlIphVfeevFnvg7AleiD27WjTRyInM/qzpsmyuGo9rk/uJHqz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 376d78e9-0ec9-4e17-08c6-08df33fb2033
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:58.2162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUfqykg/Aazg7xMZgxXCbmuDMFhhyM89N5Tgcxgif24g4PByFduQz4YspqLlG9pYISmOB/rP9xkI/GJ7CcD+5G1U90iP+DVnFI6p88TUNqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

btrfs_zoned_release_dirty_metadata() already bails out if it is not
called on a zoned filesystem, so there is no need in using the wrapper
for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9a85fd478d0c..492e1bc83d49 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4224,7 +4224,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	btrfs_zoned_meta_io_lock(fs_info);
+	mutex_lock(&fs_info->zoned_meta_io_lock);
 	eb_batch_init(&batch);
 	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
 				       PAGECACHE_TAG_DIRTY, &batch)) {
@@ -4240,7 +4240,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 		eb_batch_release(&batch);
 		cond_resched();
 	}
-	btrfs_zoned_meta_io_unlock(fs_info);
+	mutex_unlock(&fs_info->zoned_meta_io_lock);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
-- 
2.56.0

