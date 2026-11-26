Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795699733;
	b=m1rgoFFafxuyVPCbaqE4ZbvQgxVf5Zfl0PniIL/1IavM9xs+Xt5F7CG1URZeMI2miDL6
	 BHscJ5cwGvSDm26tUvQCl1l6DzsTqkC+2R36qK2iMZhlbkdOyBmRhnPEBG+UZBG5hQIDU
	 jH26IDKWUBFOS/FIvYfqnxfRhv5zYbxJCc706QsoKRd4+iNIiXGUiVcSx51d2zSjkSrh2
	 +st1eJr3eiGilvHPgUlYAsbGTqZf8b1M/O2y33eNhilblaI1wbE+mgic4Y3W2ptj+D0Y4
	 C/l3nSd9KmG9ngKy/HlnzShpS74BZ6CNHXXmew+EGYHO7kpkCT5R376k/StV2qefeRw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699733;
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
	bh=vTqZclAnge5O2Xd5mn5P972xU5C7r6ufeeT2XuGYgVo=;
	b=ds/oTmAkqdLOhBdIdvjLmXEqn3ZyRt5pwS7wJoA5OZHO7ySCHiLxlzNPBwDNPEWYwUKD
	 s8FakIwGr7GJzoAmnmB8r5/hQXNTsO6QLX+7Y8gI75QaW+UOEWt0yiBRpb8RJun/UhSMb
	 w5his6GHoq50Um6FEPjTFx3BAQLGjHYSDfuYkFx934DozOTt5YvQDuIUZIaO7cmDkZ2+E
	 9P4cLFBcZmS8fed7kpj6INypvChIuDtMNZgnYtD+K/sYMDHkdrfd9mURhZlX19uOJExAR
	 jjYIv0jpIa9Rs6fQbbSoaEYXbbR1LXFm2y3CHaUURhz3PIGDQNznOkNksTXbQkdFwAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=da+Czim8;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=RHgTOmBL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51770606A326
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 13:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51770606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=da+Czim8;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=RHgTOmBL
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795699733; x=1827235733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=h0dB6vLFLCCrvfUSuQxhWmD/+24eaMdWTSgRQhopd/Q=;
  b=da+Czim8ECehVhvbTVMzzhg4btH7FIUA6K96AX8n/BmUyI+9/b9diPyj
   ZgNed0FxMqEtUX0u7zVodIR/YLLku0pIv4uUtHrb61HXJ9l4YAwuhFDrR
   ilEEs6yIckz3UJvgGdBvPF9aWp16HhBfV01cKl2A/OYv3HVjymTcQVIh2
   1ZXYIcpyDhuuImBkBuO3THn6oTgM0/xrJpfaWU8dERZNcvrM/FNII1qgu
   lesH1SMUqo8eQ+x+iSLpd6bNHsoYxKkZzq451Ne2rpibWp09/hutGc68y
   R0z83jXrummUM/YcvuJZNsX9/zBSDEUvUZc+2Kgu1zY8XqIviueUV5Oox
   g==;
X-CSE-ConnectionGUID: bCH1lRhoRJqkNX3PdnrhHQ==
X-CSE-MsgGUID: g7CePUaGSV2G3kAsKgRHgQ==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="162817805"
Received: from mail-northcentralusazon11013015.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 21:28:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PQioxwE298c0suG4RG1CD34p2ge9DVgYiuICYa7aBbL8uHclw3gphrlzYWsbEmQOu51R5GW8Srnh7Z6eQOZDzaBqMqJKf+ztkc5971ELw84cacgnC5OSoiiYRD1YhyM8uNShL3ovcGm7wT47WXok8vCkbs9O42KLAP2v/xs573bk4tlORP+p+npDKgeinyXeDQ3pZPAWWxauwD5UFIm7IYalF3/TxMILUeIR6pdefcicoe2K5v8x83ftCMWZvsYdPVUuIoZm4RyLPh1nPXQPF9olW2LnHvpmoiIvdvwHvlM2uxalkPbJtCuY7RbXp+v7AkeJQDmwwolupGWH7P9mVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTqZclAnge5O2Xd5mn5P972xU5C7r6ufeeT2XuGYgVo=;
 b=YurvmQRSsoPgDBXEk96Yomu65EqkK65d1r72UPKKqbE3WuHn9d0cifbItC9Q+qoZgSD7OQozUdyPlUvrwRowYoc8mQwbdfPxkAo8WbD5Doe6fgHD6i0YgKCfiwIp21RapuwbF1pRFDAoRD0B9Wunq7jWMtW8P5JroryeTsEXOahExdY8bjnT1OnydTSuuLdO6ZdrU2UQ6CqwrDN+ZYfFtN1da8qNBDC0cGl6SOwMlcfM4Jot4EG5u4Arob07NXRqDe0OheefQt3jILte4YHsIfCAjRNa9Te27A2LwzL2OOmDIe798DM1USF50M0QN+So0kIvydHpcAO0qm2BRRG6KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTqZclAnge5O2Xd5mn5P972xU5C7r6ufeeT2XuGYgVo=;
 b=RHgTOmBLEuQSzogPIyg52dTPElqSZuVguiY7jMseua9OyHfC83Bmjp2bU6qi6RYF7+l0jnAfSX01ZUR0dyQJbwLcYK2Bt+7S8bqF+FNOqCMSOMtAi3qC2bw4LdqIXzGRFFCpHpe+xvwL0fvP0jZ34FeA9/vNx15F29p/iIb0byM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9155.namprd04.prod.outlook.com (2603:10b6:610:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 13:28:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 13:28:50 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 5/5] btrfs: zoned: break concurrent chunk allocation race
Date: Thu, 26 Nov 2026 14:28:20 +0100
Message-ID: <20261126132820.570379-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9155:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e26d24-d856-4b9f-0e73-08df4bc1355a
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|376014|366016|23010399003|1800799024|261009223027099003|22082099003|18002099003|10067099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
 xdjHnDsG6J1IYLNejkPs61JTTuikdIlPKsB3r7iUKGs6BPFV6iXOIIXqGx3u28e1NY+qPnLQf8NsVjwpMQZMlVI5PJU1PZL075K2y3utrs+ARlz5+ejW7L09uKQYec5v2nzKmg4JHUfVVcwdIKoqmlYsK4s/1NXdadKjg/6zYy1DsIMe6KfbCGx6TqzOk2kDJ52AlUD99uFY9MlT2pb3VrbyYBa11VB9z11EvbPTe7HhjS5aLtvWwS21gVleUTqzBEHXZQwrc71rr0fxrp3a1dJRkNcAouWkd7HE2Nw9LW2G0LXCI+8DobNYeS7n8OMBHZE29vsHgDxFQyklSvhv4EyR0BklpOVZwFU1WNQtu5YzAJTWKpfJsTSoJ8rwo9JhoF5Z4pgfSUNyE+Xl4KRqJLyzgFJi7bkmZkB3zjy9Yn4246sTZXZwVB3o57ePj80F8iUceGYn7mOMaVqvVqE+FxH5TmARJ5Z+hin6bLEx7RrWdrXmh/85OZIxzmcD6Pgcc9w9rmYuc+8elMQNxEvlOHkumBffCvuXUqv9nfYt1Vlc4Z02APosl7rW8mwz74HJbkkAokRqYpUD+sTRXjCE8rQHySKYw21LWfBTA4nyMzjb3THrLp0N9s7qtscHaqzUN3OlxOpVvl99ba3bY3Ex+VNfC0s6SCzeiLjYQsqTV/M=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Oe/X22gNRipd+j//qdAyfxEIP7EolSdqnsf8Ra9SVbr2He7FG71i7uGZKs5f?=
 =?us-ascii?Q?rusLzkh+fM7KgWm8dHWraH7q0dAFP6XJB14mdEeWtTfPcNlApwjW91KtjDzK?=
 =?us-ascii?Q?tPoMSTf2Fbue62h/acU+7t+Vw4p4J1S+pfE3Yjvtz83F6SlWxt9SSgV5kqrF?=
 =?us-ascii?Q?NmuGBBbYwglCRI2VcOCm/K9urHs0BBCFplWDggKi0DOipBU5jdwG/btRAtPu?=
 =?us-ascii?Q?QHA+XRO4yuV9V/l41VjCrIAPUKtLSTDUmk3Byk43gA12m1SSR2KJGhsoB6Zq?=
 =?us-ascii?Q?pSu0UB72zOTSRZwb0q03POSu7rpJrIjK6/x4RFoy4gTURw9IStQ+21ud/K1k?=
 =?us-ascii?Q?JiLIr9B/HTaLNTVrZHgqJL34dmmY6j5n/B6ChkgoG0XD1PNsiyJWzU6bL/9b?=
 =?us-ascii?Q?v1OKsIpKY+1durhGcuBMxqh3fsa189NmBd5D9Q00dXpNEBpwwHXrHQgDRg4Z?=
 =?us-ascii?Q?nd//7sdB9bGgHWAfUVzH+2uOtuTK86hIHj/gkxmdATIG/eQ9wu49dniLlQpU?=
 =?us-ascii?Q?eOqGarHZIowQkEt2ujqYd5NfZWpzwxBx7gdGslTqNNWPGC+DEqPmwF0ci8py?=
 =?us-ascii?Q?yaQIoiZKgGFg6XJkqxRnef3yB3/YlU3gMCXhQlBhG2gMhflWuKeWsf/lJ2d5?=
 =?us-ascii?Q?XvU+E1aZd1i7LpPAhZlMMVf3Lp/EH+B1z/5j25Na11GZeGot8HU636/koyL1?=
 =?us-ascii?Q?TjItckF/p5Ti6lYIFpnsRHAt2CyKU3zNcWMFJ4NoFwcYAUMJ79xO5l6UBn3T?=
 =?us-ascii?Q?C0WGWznRVkjyDnWDpT2bgZ05JUcw7wjBJSPZnuZFmGAYjGiTwGvXU4+Yemt1?=
 =?us-ascii?Q?PYkWQ/EDncoO6S99JqbIxyW5plC1Jsr4owhgk8e2f/aOkaxH1pjx9rB2Q+Kz?=
 =?us-ascii?Q?df1PnARvhxz2PWHBO3i7/0UB3/mxmmrOIio79X8JHrJ3H/MuE72AOpkqeiBM?=
 =?us-ascii?Q?octd63VjzK6lfu/4cg50aXfirR0lc/KWk9I+hgpmCyeATUOAvfXUYkV+m/ju?=
 =?us-ascii?Q?ln1OR/jhG8PSx7ElJE/1MAy2mjOLfvnrEi25DwFiCKZRR1y+sX7jQJQABzir?=
 =?us-ascii?Q?rPnzZyYyfFiFJ+ZSrKgt1iOwwaS/ReyynbvO3v9O5GZaVhge14fSxxDLcbDY?=
 =?us-ascii?Q?vu96QFEshSRZ9kPEDn7hkAFCRBTpxKMUwazozmqx8XyNI0k1kF9bk62+oPq+?=
 =?us-ascii?Q?Sy8k2E9YKqVgxOA9fCM1uHrgLfeI3jN+8cG2Gt199m1o1XToQZBCJPwTwcel?=
 =?us-ascii?Q?tCJqqZa+WJnM5G7q7w1zPkTM6hQqQC0UsLs7B3a9skECKJ3bdAaolikCrSEQ?=
 =?us-ascii?Q?dRiUqnl4QknfysG9/W2qMo9qVSqJQ7aGyKBu83OgMTL2koqrmiOcLXmYCzEZ?=
 =?us-ascii?Q?XNqrKfI77Ru270LXmjsW6aPjFnZQXOrrE2dW28HAsUGhIk57fxqfA7f4PmUE?=
 =?us-ascii?Q?ppRoADTT3CRkm4m554a27lbFYlq1DJPn+n1yJgq30UwwDc5Biz4RnUTB6SMY?=
 =?us-ascii?Q?YLpAOnr+N9O0Wf6ErvxeuBF2YDHbAgyHTtvDfZjQ+teetF6HdCozs8QPauzz?=
 =?us-ascii?Q?Cnb2DMR91Enk+OEh15YMCSFc1k+kmSBbbTldHKppHDh8m7JGydMZBTxJtuRo?=
 =?us-ascii?Q?qk4SxQ5dQ95k6gWfUuhsx+Hf7nPnEFtCoDTY+wVHeGHPo5QO2mDwvjf2TWYj?=
 =?us-ascii?Q?dnOROXnkJ0dLJWWzSKtaU1+gmVEAqJP4LdprNjvWuRikzkfoDOVdfGv8YwGw?=
 =?us-ascii?Q?c8zXsxVUDktGv24aRVyX9OjsEeG9kdETIMzThdt8iLxqR14U+pCY511iWLE/?=
X-MS-Exchange-AntiSpam-MessageData-1: B8FzElcO1+Peyop/U0RXxrI+9NyBcMuo+9I=
X-Exchange-RoutingPolicyChecked:
	JPACEBmnXSCvHcO1pxwZUpno+HcvaiBAh33dG7o2XZzKIz8je5pPhiJGPr4JNU/qLIEgU593Mrhq/AAFV5YppMvpDk4EB7ah+DRSEy3BssfGjhTXVl5LLXWvMdGuG0XCTBR5N+580rPUCuCrzXr6DloKRXm41VwoY5XzgpHP95akLUh6cGpvj/UEIv2+q3ezPZlStLghQxl0Qhd/IJ0RYr1eTy6fGgDKOeXdNWTaO3QtSLcLdPgIAdUQ3IfEvQqiuf0Y6I2uqoGO11LvYshgm8uN3udbJt+kSdVmW4So7iFDCvtbNmBkBrKNe4CyAftvsAgPlJUdJ4HoxIv/YkYrtg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4DRwq6UKcTEFXPkcQIW8SKcVti99fneWZ6YKzlJYqok2Oxyk5tHOmRG74xLPMb3LoLRgdkQ+3QcIjcxv+V5xJ22P3aupmWG+QevY0ObGJNCaLL3LKQ5vPhVn2EhCH01dKmcK5hlXpB0qq7LqCeziar6gy38gHZVkdBous4pXFT+VPcCyj60Jnmwd/ZOfx3vGjxvQuY7qkGaxnT+Rhcb/mkjtk2maWIj9cdfHkzuiVcP76A6WMrSnd2pWJqzJVrG71g+hqDzZnvLUOktJHXh+gA6fuOFdHNq0Xdo5wR3j4ox9GPp5sfsgVEdfXNnPlxjm3vDpyhns9id0VtCopi/LKyeJd5FhZgURSObbRo29T+yf7J7noSYh7Ynf/W9hpev4dUlVT6IWv6rCaqUtyjmjR3Nhsg+amuUrDvFuehPjvV/kCOFK+5CLMh8vtIcg3rDly6yS2LZmPCfV+ZA1YtGIOGf+LMyixwZHUHdOctPjqLC3khTya8UQ4qUoM3cb/HibzCmf1k1J81vLurlc78Ofkaxwe6hJMnd+WJtsCbywydbel3kvJxXmTRvrOprm8R9WSapLpevm1w6JOqLorS1Mhy8YBYst4JXA1ZJyRC+ndUMlmFxJEDs5qOWxi1HRksHv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e26d24-d856-4b9f-0e73-08df4bc1355a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 13:28:50.6592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UexOqRGm49VA+dpxaLPfO3UWR2b+PCEbaNmlEgsBU7XXMphVyCsGTCFGtl1P/r/qucBABTmw5fZl/10gPZWNTzAHdzDcn4lZ+OJf5spkS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9155

btrfs_chunk_alloc() coalesces concurrent allocations, so a fresh
block-group request can end up without a chunk of its own when several
new files race.

Retry the chunk allocation a few times before giving up on a fresh
block-group.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c | 5 +++++
 fs/btrfs/extent-tree.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d8dc43655b16..d4f809af75db 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4367,6 +4367,10 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 		return -ENOSPC;
 
 	ffe_ctl->index = 0;
+
+	if (ffe_ctl->loop == LOOP_ALLOC_CHUNK && ffe_ctl->want_fresh &&
+	    ffe_ctl->fresh_retries++ < BTRFS_ZONED_FRESH_RETRIES)
+		ffe_ctl->loop--;
 	/*
 	 * We want to skip the LOOP_CACHING_WAIT step if we don't have any
 	 * uncached bgs and we've already done a full search through.
@@ -4648,6 +4652,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 	ffe_ctl->max_extent_size = 0;
 	ffe_ctl->total_free_space = 0;
 	ffe_ctl->want_fresh = false;
+	ffe_ctl->fresh_retries = 0;
 	ffe_ctl->found_offset = 0;
 	ffe_ctl->policy = BTRFS_EXTENT_ALLOC_CLUSTERED;
 	ffe_ctl->size_class = btrfs_calc_block_group_size_class(ffe_ctl->num_bytes);
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index 50e0a16d2d8d..c5d5fd5c0196 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -90,8 +90,13 @@ struct find_free_extent_ctl {
 
 	/* Allocate a fresh block-group */
 	bool want_fresh;
+
+	/* Retry counter for allocating fresh block-groups */
+	u8 fresh_retries;
 };
 
+#define BTRFS_ZONED_FRESH_RETRIES	3
+
 enum btrfs_inline_ref_type {
 	BTRFS_REF_TYPE_INVALID,
 	BTRFS_REF_TYPE_BLOCK,
-- 
2.56.1

