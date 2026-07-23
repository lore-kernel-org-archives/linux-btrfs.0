Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AD445D186
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822093; cv=fail; b=JSgGXGMt/hsVOZXKxSnMQSYZ3Z2KjLtLUrV6OXYuwH5ornA9rZILdp9/ILGXv2VuclqEtif8F6oew+hsn0ma5V4Xwbk/j6Z84kCGjf8XQESci0MRZJyPJ7JTmimk3iarKP0VCv70YK8yaLsza3g94SPelA3nFhl8QvHULhySbPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822093; c=relaxed/simple;
	bh=GIbhD0+rrZSYR+Jim01XRyNdjZ99ejlGh3m/fs7nm8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VIW19RxRzraBrYyj3gUfIWqe3GjgIsMIoofBRO65Pw4D2Cg44r95LCIwOFbIIG5Bpyd1aLGxvakgSzRFZHUaAK0LkFUpbUigrZHIvlIaYNWp99Xd5rljs/+it+l/OACfpNuVHwT+OnI5u66OGjvBt18/sQ096PmH4WAZIMfkXnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=j+PwSD2F; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=J1RsChk9; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j+PwSD2F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="J1RsChk9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784822091; x=1816358091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=GIbhD0+rrZSYR+Jim01XRyNdjZ99ejlGh3m/fs7nm8Q=;
  b=j+PwSD2FJeo95S6hwvGAT6EEOBEd+WZybgvApz1d2p5izHRk68h73jFV
   BQ2WWawAfUGdCxwG7jr7aVCTRVJfPFZWewuzSIQdf6/gQpol2xZNaXRB+
   31opulWuugCYd7xhcaSPVdEhV96ng6HyMJOaGldRTrmSteS0jlaC+InPL
   bDv1SN8wOcC7zZuwWL67kSQzWobYiWLNk2vlHMFmB8u1XNSfMJJm6l6QF
   ig3cN5DUXDzMHp0FDoQntdcvLyN21o5eEybIHVHgFIZeIGD80Msn2m5/K
   rWIQsPzuCkTr1RvaXZAHlly/t8OxBENC8I7rzqBcqbNggvr0SvoSMyZp1
   A==;
X-CSE-ConnectionGUID: Mb040xFzTd6A6i8v6jnsLA==
X-CSE-MsgGUID: ZNs+AIJuQ9GdA2er2KOqRg==
X-IronPort-AV: E=Sophos;i="6.25,180,1779120000"; 
   d="scan'208";a="150693719"
Received: from mail-eastusazon11012053.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jul 2026 23:54:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpJDJ9n13M7o0I/thkWlNXV4PaoKiTjMy1/S662Mw4+m19+UhcEnoVbzRNSG4pf2Bbcb2qxcfttibFb2D6/O2sEybsKScBHN+7pjYu0Thdmr9NZQiuBFRiiyszFWxWfqS8C1/LQqIcZEPwSUvbYYiUtgbQSVVZmO6omXDU2IVVTam4tXIc4nSeM3YrSeMfi2RuLrfVN1i/KIKymkRULXbxwsyit4eQc08JO+PIGmsMiDxag6Arvqym4YDxBv3wpItCNTCyrWdRQnX4B6qNUBmfT4ooubHH79kv5251NaOt5cmno/B/afu3ftzKZVkQ8YzMGk4Wlo5RhRMvcla9aiww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNCKKS8mVJfF42c8XvbxOYV/oicMqazA+uvF6CA5pmM=;
 b=tz8kwwWsefzyqQBus+3vSno84+Z67GmPAzng7VXolElAy5Bibp/FT5TJWS5OCPHgdW1ES/FSGExweI35O2/pLTEGMHo3YrDaxLk1Ko552SBTpO/DBRzG69jB5DC003W6rz96Rn90pTJt48Q95prr5zHAdLi1HJZMBcL4uBU+P8ENsPvCD2fOcKceNUA/d7quggvOVgi/hb0cdwq/XPeJuZnEVYkfhulfho4VvVI2oqUpJJSgWOwnHLU0NxByqgHk98v+U/Apgtr18NKdv6x5YXu0dCZbJy4GK2MxFAh+gGXo0kGh6MbL/6BpTGp+iYysDPM7e9EkTc0dID4U1Y6dDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNCKKS8mVJfF42c8XvbxOYV/oicMqazA+uvF6CA5pmM=;
 b=J1RsChk9C8aKeQpqHzKrKpcqsTW5MI89WY9PMbFdWekgFpxUjFWUcYc6dkhrVGGSc+vG6VtiCfjl/a/a8/6UFKY4RDsXJOeZ3MikcpKhCOVd6r+vZWSpckYFLv3M1MLnJykWRC3JQeL2oNp57HO2sg8SKmYuQt/elAVunis+rrs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB9295.namprd04.prod.outlook.com (2603:10b6:408:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 15:54:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 15:54:48 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 4/4] btrfs: zoned: don't clobber the extent buffer when zeroing it out
Date: Thu, 23 Jul 2026 17:54:28 +0200
Message-ID: <20260723155428.94187-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB9295:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a721cc-842c-43f3-d4aa-08dee8d2b94f
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|19092799006|376014|10070799003|56012099006|5023799004|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 cevqymaJLXmnSivMTw1EnhhGNjTlVst9uN+bjjJeEY5HhirxZuBfNo0iHhzDiJl49PNnYkTBZCmgMzxrp3yQVoea3+luYZjX7B7N1ozpMGMn7fdyFB5MZ9YM1bd0bYGOJlTGDeRHEdUH8Anlenclm9j3mtR3Qyi/PLaLrwoKGcl9G/N61kTKC0nadG/9VvFnVwXJYFHCX3bYMIjpPgxaKtwyx61Z/souo3Sfci2tHoaUsZ2Fau8pIqmIDhR83twNCZEngpfKCIYz17QZUomjXM1YM+iUgmMwfEW622ZiPYIYr1aC9o7ykUc/G3y+1jYURwVO4L+LL1/vMAda/htM2aD3xmspFa0HXPq6v/oE2sJZj0YIV6BE2xOp0v4925IflzrrdnUEV8ytCPXxbA8Y0+eqpPMCD7t4hXqGWyHwB4UwC/Os4FlHmY6FDP/ALsc6daoCKdrpdNog/bQ9m6hTnPdoerJQJoV6jyQ6LlmIV2Ce48BvAaAHkxNQbR96IHoqsxvil7R8b9EybMGFkps7S342s0Ksow4sP06EuJQU72JIBvXskaw8d4oYY7lTp1p9fAQSSPrFOJK1sIACRIswudjq58kmicHxXE1Np1HmxZlmWCbvdUeOXgOxF92W7Ayor9A/o45fbOeyoCyVFNHQBaPxhl4ZNLpWB+qbzfOqh0Q=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(19092799006)(376014)(10070799003)(56012099006)(5023799004)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?NOJg86bM9ZIxaEP6e3z+XHFYQiw13NYRKqqTPGqRCyymChiGUIq4v5c6rj7i?=
 =?us-ascii?Q?DtFId0SKxJYY1nIU+VpLgoh9NQu/0HP/uBw9lJLKirTwPCJKdYeXSe31o5mT?=
 =?us-ascii?Q?+m+KBhJCffjKF1vzWYNTXbYk21abbMFIZX381vX8pdVrVCfHb18ZbUezkyIH?=
 =?us-ascii?Q?q03c6wOOPVGI42gk7PETfU9P4WmmR5ugzLt0Th/v83PhUmwA0k1yFL3tKikw?=
 =?us-ascii?Q?fhS1WWcv51m8DQeXmybKdU2uJgsdPkJglBrMvIklkYFyzDrzUDmpXoYHhAow?=
 =?us-ascii?Q?XznVZM5m5P0tc9uW4rNHye4KUuMfNqEWcwbta/1rHd2JfG5GCd4XbK2QXE13?=
 =?us-ascii?Q?d+Kx0XLZB57cQ6cQtXs6A8rWhAoyiAkbmX6E+aaAhUkOY0GCztrmXcg5EJPB?=
 =?us-ascii?Q?ro1ttAIy4BnMlxzNrvhBGYrpDSXqDLpFGKUcReMPfxm4VZJMA70z+PEt6DcF?=
 =?us-ascii?Q?zzVAanomGJuEODXhVf3rzYoBQt/vDmbxztgwfkeXdxOr28R812S6QuvLtyeT?=
 =?us-ascii?Q?0dWWGgk8ct/HUDacTRJOv9bZLG0GbPHg3PBeY7seZQpXOtdt32SjsNA4i37J?=
 =?us-ascii?Q?VUJ3qmyOOwMKbwheBiVuvgVoNpuDHoHEtE4qI9zsYnA7V8U32sEI6eCuD8vb?=
 =?us-ascii?Q?2ufqui5/LwtxPJ8sgbv/sZuwsJiRKys54K9Xmib8Iafl12A1jRqljVe93j9c?=
 =?us-ascii?Q?Wu3rK6fQqh/3MCUyPN19E8E2UgiDbBP5NKU/zirWRhC6rkgduw45xO5hQfPx?=
 =?us-ascii?Q?VEx0M1YC4MV29iDhwt4RKgdfDydn4LeZxBJbtCuzReOTHZ1iG9wwLolVjlUs?=
 =?us-ascii?Q?C5MVC8Kirj+pR0VFZGK9iUCrDCXvvuNQYT09WO6IdTGd1KYwlJ2BzKs3WQFX?=
 =?us-ascii?Q?mpxrCDOKYhKnU4KnuOCNa9zpGO/iK+KDmtTxC8KGCbkXjlQVQuRfK3C0Yhoy?=
 =?us-ascii?Q?Ypj2I9g/ybhwtCXTaaCdek6vaRKMwLrcW/1E64tBXCSNsVtZ5pv2vg+5wJo8?=
 =?us-ascii?Q?GJq+8TOjQlAkJZ5Y5LISOg+LkqlGvk4Kt0wvIqFQNAuektUO1EIkY7AECSDO?=
 =?us-ascii?Q?SSaNA2fkX2o27pfQ+0a6mfPgxfUUuDCAeI7ZmOStnu+VlRirxZdy4zTk7gDT?=
 =?us-ascii?Q?W5wWVp8WTvhRXVmMz9U4kmgKkoruZ2k6PRzxO3S/ejScmsTTONNN/iiGffUI?=
 =?us-ascii?Q?CgCF1DPzJRmKhVQ8fd9PJcVqM86Yy7uQUoBvPiPl0D+qtCgBXRso/PflcqfX?=
 =?us-ascii?Q?aOrpnLeyAtnYouZ11dO1nZpan70XbAwEarj3pEFGlftseFRjuUjMPYDLEL/D?=
 =?us-ascii?Q?GWvSCVtBmqv2tvxAV2WhkuXklVsdhly2UTHeo5X7dT2DllPj1iWyGhNiw9hw?=
 =?us-ascii?Q?kTxD8P99SsiUYdzRJz7WZ128cnDsx5XlEEiccTwiM/RMlIiRMriROfbcBJCH?=
 =?us-ascii?Q?Fq16dSm3fcQeke1IVjhPC6PBkDpsta12hFfz33pNV2P315XCZR3ffD2zOmUa?=
 =?us-ascii?Q?5/bmIIMcjyOl378pxruN7sX7gPli4Zt5jDybhXNZ2LFlA8W9o14HMuUOXTWy?=
 =?us-ascii?Q?zQqMqX5w4pdHCwYXeXmg8R5FB3gzZ4auWV4Vp93PSg+/25Bbl5Y1O6CUN6s+?=
 =?us-ascii?Q?qoeJFl2zl/GaFrQblBYSNuzqnpmnK97RxLRY2+/iaV8/gTcOc49yAlJxPIoJ?=
 =?us-ascii?Q?WhUd72/ZPysrqDZ8V6a2+rMkPE3j2aB7Zkg5TY/fTF1sC8HyY0cx257dI5PS?=
 =?us-ascii?Q?IkyfS03zKEk5fwUxOMxJKfpLRAvbSvcT92j81L7NideHvf7B0YEXkG2FjWsK?=
X-MS-Exchange-AntiSpam-MessageData-1: aIyr1ASEywa33Q==
X-Exchange-RoutingPolicyChecked:
	jjG1BHmH2aYL7IyP+uAc9JSdOyMx3jeqG5wb/ZQcp826tyV9I7yHY0LJFbOqyAbobwRt5vukNyF4l7VCZQMRcwjZcovGeYz4Qm7qjCW5K32YfIKqNn1SeeTvJ94+QAl/tG93P4WW8KiIzNJcH9J+3LFCAidU0yQ7o7nWaT1VMzPVFcQLPNvdxrC/Yj7XAGdxgq6aJ84OmPYUxlgIbauR2KlCKoxkLdXY/oURYNtryYWZYhj57er++5cwjehVwvm/43UFmRMOXUXzfalnUZSjptHHLMObbbO9tHuHBTtH/J8N/1/WicOtCRUkgoEc490G6trkTgEdaj/I7e5mmOKoCQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CWVsnS8mLItzd7k6UnWOSvDOq6YtXK0DGN9jmMFeBOQ8LFqK4ralD1nYIPwvSTgM85qK6xX9wcaTNWdcUew5u7h7czCiJ02oQZ5+Z0Oalek+9P/QTV9rYo3xrTt/ZLETLcjM294Ds0In5SkVa2WdBRt5tvFHVDWBZrIlVhYPq4ooBKQXpXiLFKuTjk107aU9vTR/Zz4w7REbvKGs8mW6JlhwUkbcxcjNfHChTYyDToZhARrB1hKLorYBIuV1rp8SQvhLtKlB5jxqyzjyW36miidFv8BY19QoCmSEopnBkLqf1b4gPfnDgt3xfMBh1frIYW02+MpXFTUgeFujkR3mW7sdMXWkfXvC+FzmoA631f7ZHA5dUDv4Vqb7Xqo0fsD076OG5ZpM+B1luaDXfmjt3LZ1poXCt92BJE7jO41s8wMkCyOq1rQgg1MKqaJDjRb9luNpZOd5QAHvAnZm+/T01bR+nC0eZbEyRFZJASfU9eQ3IEJURbcAlsaQdnv/35IqfBRekHXGMg9cFF7JNL6AQuR1MWPogBtfnHibyUVWKh7XUAR58PMa7/BJWearPlASV8MDMyfENqt3oZF+QT6iPp5LFlMWcb7vxYj31+23gq59fx6epwfJiuhwCQNWVgD4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a721cc-842c-43f3-d4aa-08dee8d2b94f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 15:54:48.4865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JD8+uapYdYStjDyxs219szARC1Gu3RWkKyd0+tQ9lyQq1PXV3W1DILlPrpWNn2C/pybvL+LoMaJri+CB0X3A12VvjEX34i1TZJvBdIV9XFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9295

On a zoned filesystem a freed-but-still-dirty tree block is written out
as zeros (EXTENT_BUFFER_ZONED_ZEROOUT) only to keep the zone write
pointer advancing. btree_csum_one_bio() implemented this by memzeroing
the extent buffer's own folios before submission.

That destroys the in-memory buffer while it may still be referenced. In
particular btrfs_free_tree_block() can run on it afterwards and reads
the header to add a delayed reference; once the header has been zeroed
it frees bytenr 0 and corrupts the extent tree (the
btrfs_header_bytenr(buf) != 0 ASSERT in btrfs_free_tree_block(), or an
"unable to find ref" abort). It is flaky and reproduces under fsstress,
e.g. generic/461 and generic/013.

Write the zeros to disk from the shared zero page instead and leave the
extent buffer content untouched, so any later reference - including the
delayed reference from btrfs_free_tree_block() - still sees a valid
header. end_bbio_meta_write() now clears writeback on the buffer's own
folios, as the bio no longer carries them.

Fixes: aa6313e6ff2b ("btrfs: zoned: don't clear dirty flag of extent buffer")
Assisted-by: LLM (debugging, commit message)
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/disk-io.c   | 13 +++++++------
 fs/btrfs/extent_io.c | 31 ++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 01d01e10d000..a1277c8f2871 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -271,14 +271,15 @@ int btree_csum_one_bio(struct btrfs_bio *bbio)
 		return -EIO;
 
 	/*
-	 * If an extent_buffer is marked as EXTENT_BUFFER_ZONED_ZEROOUT, don't
-	 * checksum it but zero-out its content. This is done to preserve
-	 * ordering of I/O without unnecessarily writing out data.
+	 * An extent_buffer marked EXTENT_BUFFER_ZONED_ZEROOUT is written out as
+	 * zeros to preserve ordering of I/O without persisting the now
+	 * unnecessary block. The bio is fed from the shared zero page (see
+	 * write_one_eb()), so there is nothing to checksum here. Crucially, the
+	 * buffer's own content is left intact: it may still be referenced, e.g.
+	 * btrfs_free_tree_block() reads its header to add a delayed reference.
 	 */
-	if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
-		memzero_extent_buffer(eb, 0, eb->len);
+	if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
 		return 0;
-	}
 
 	if (WARN_ON_ONCE(found_start != eb->start))
 		return -EIO;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fa473476b7db..e88381a40600 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2266,14 +2266,17 @@ static struct extent_buffer *find_extent_buffer_nolock(
 static void end_bbio_meta_write(struct btrfs_bio *bbio)
 {
 	struct extent_buffer *eb = bbio->private;
-	struct folio_iter fi;
 
 	if (bbio->bio.bi_status != BLK_STS_OK)
 		set_btree_ioerr(eb);
 
-	bio_for_each_folio_all(fi, &bbio->bio) {
-		btrfs_meta_folio_clear_writeback(fi.folio, eb);
-	}
+	/*
+	 * Clear writeback on the buffer's own folios. The bio may carry the
+	 * shared zero page instead (EXTENT_BUFFER_ZONED_ZEROOUT), so iterate
+	 * the extent buffer folios rather than the bio folios.
+	 */
+	for (int i = 0; i < num_extent_folios(eb); i++)
+		btrfs_meta_folio_clear_writeback(eb->folios[i], eb);
 
 	buffer_tree_clear_mark(eb, PAGECACHE_TAG_WRITEBACK);
 	clear_and_wake_up_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
@@ -2314,7 +2317,8 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_bio *bbio;
 
-	prepare_eb_write(eb);
+	if (!test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
+		prepare_eb_write(eb);
 
 	bbio = btrfs_bio_alloc(INLINE_EXTENT_BUFFER_PAGES,
 			       REQ_OP_WRITE | REQ_META | wbc_to_write_flags(wbc),
@@ -2334,8 +2338,21 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
 		btrfs_meta_folio_set_writeback(folio, eb);
 		if (!folio_test_dirty(folio))
 			wbc->nr_to_write -= folio_nr_pages(folio);
-		bio_add_folio_nofail(&bbio->bio, folio, range_len,
-				     offset_in_folio(folio, range_start));
+		if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
+			u32 off = 0;
+
+			while (off < range_len) {
+				u32 add = min_t(u32, PAGE_SIZE, range_len - off);
+
+				bio_add_folio_nofail(&bbio->bio,
+						     page_folio(ZERO_PAGE(0)),
+						     add, 0);
+				off += add;
+			}
+		} else {
+			bio_add_folio_nofail(&bbio->bio, folio, range_len,
+					     offset_in_folio(folio, range_start));
+		}
 		wbc_account_cgroup_owner(wbc, folio, range_len);
 		folio_unlock(folio);
 	}
-- 
2.55.0

