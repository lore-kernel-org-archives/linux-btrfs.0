Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590139;
	b=K3b/+FH0ORQnARDIndcrVEm73yv4Ye8kmdMiFwKR8/p/lzzTmnjrkJIt+BN5u4Im5aFA
	 bcsMgSFlKZtPTqpq/uEqOeqxo23GWaMziZCuCeleFlFhCUYCOWOLS3KQaNhvwZoH/de6l
	 YXLP2Ot0nxiKn5shayFTcqVxa9fc3gXTXu+hWt7FhdPec7guLmI/QzWilg5OiqNsgR7ku
	 otsn9K3xvsX5uE1PbEljQVs+9rrdBgp51RKjtVnohrhTLrWNcl5Qc6hJxEfdlyJfkZKCo
	 H/CGYwpY2nFD8NN8NCCDpkV0kNPP7z3YXqI9H4RfHX8PFiHdRIconk8YAFY6Sx3Ma7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590139;
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
	bh=1Uq41MObaxjvAr5h3N6/wAxhUK156h2zs0iqDX/YO54=;
	b=cPIamkPfGQP1ltcrxer6kwFLflFBcO3ycNw3R6Nx40EslP2a0sS0kSsN3JXOAuLmHGqb
	 Sr6fi0M1uruQVmfu9P/9PyQipvdrz0HiORurvx12khw5dzfptoRWZGBz+DQJciK4hO9Mm
	 D//cdviv9QTKmpknRDCrIg4YsmkxppoJVszDpv4TzSu0wuRNx7JHPstjkWs+3rO9H8QLC
	 G1kSKp1korYBmp7i6TCDPbZbqKyQ8SbH29mnxilfgoE7UHs2uL04vpqp1XMs73R8cpO5w
	 MV+qhjSJXaQqRqNEXuyx8rBYcERFnuF6jUdRItdl9LC6pdBJs7OniAgElDWfFihjgMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=GcWuUDBF;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=udeAbSAe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A00606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76A00606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=GcWuUDBF;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=udeAbSAe
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590138; x=1824126138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9e9IiyJq5WERSSh+OMRs4EyDzzOmp5sE3ekQ8r5xXzY=;
  b=GcWuUDBFSWvJipRM52dZo3vHHRbL6o0hsdWmBeIj17iqBPa8zq0si0Pw
   NzRcG2n+DgpaQJImO4RZGbr/BJAH3XVz7fDF1g4u0AX+WMix3JkddooSq
   quWsZcr7fKXak1G8tX1tHT8szlwzdi7U5/JqjLs5Gb4CuOgka2NpHfUPS
   NE8jymjN6Jv15zXAJjd2P89gU3UytJzz7EbPm+9m4Is2xGDdRKfxA5T/6
   OMpECq9NKpAGZDuQm6xVHas9jMuTjQRHhAgmv1kecnzFWIDgFTGY/Ghse
   AcSQnjLDmwVFgg8yze5gyKIthkUqU7Y3YYoXfX9ulY4lU3eyx40LqtGVT
   g==;
X-CSE-ConnectionGUID: yEQoYP0ES+ewyqaVcQws5A==
X-CSE-MsgGUID: Mok62gVxQ9Oen36j28ALNw==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="154422337"
Received: from mail-northcentralusazon11010046.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:41:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wq7RoPpuhdwSAX2FodXg579IB6UtfKH9jwhbQj2t8C4b3nfblzkGhwglFVhL9PbGH4Fw9bXgVUBr5BpYCrwCI9r6WLdUxDGAA9HdZNUiSsls8Nkv/YA45WgPPEvwKOKg4415y64w5/pW55SYRgV+M3KdYOvj39UUtemFYvR+UyzaAnxgg2Vgp7lCQi1s5sRHLqfgKpMoy6WDIfBQnMVQRB2cVPVT60oLPqjR0lBR1B424joHIXdSr8TSkpgYtK1NwXGFPvX2TxV5Gyt7VLEN1YtqdMLtT5eesDisOv0rO7Ggrlvv8ecMuutAOMz4bPwnyzp6T9fB/KtjBKy6oHv3Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Uq41MObaxjvAr5h3N6/wAxhUK156h2zs0iqDX/YO54=;
 b=LKAFTi/EKYho5IaZVAXYJnRnkrovAg64jjor/u/zPQNGtbtJ3SbVUqaT6xu4jUFotHoPlGqgRpe8XALyIdVkhwP+fF8/j35oRcbAAF8HQX3bk2uQMyv6cSIrTVWaL650+UVNC+Ea9bBwzAHm7Fyrlcucq6Rif9sCwkRKsJA78aMA74Kkmw/5NPpaE6+sfBfjmXr2xHwTFpmV+U/v6C0qIzhqQ1av8v8zTRvYZ0yu32ClRtq0XXndgMQnt8tb1uOliksaFDdm+3HWlcj2AyZxfw/FpQO67xQ+lTBTkiZG46QYXRx0NKunqLfgAJ2uUz58Uq5we0aNYVx3m3YKwDJenA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Uq41MObaxjvAr5h3N6/wAxhUK156h2zs0iqDX/YO54=;
 b=udeAbSAe29AHcGArNk13/am5FurtKJR1f8qNaBJXRTLAJMvKcN92ebRIV21Oy0E0j5J54RjrjePzubKDcjfigKCMft0ohb3VzSx86ZBAqBnSYfz8qVYkO5Bsf42CwaEZIzHC6vExDW8c9BU74M/Rp9lU3LnZuFBvik88tQjmRBo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA1PR04MB10180.namprd04.prod.outlook.com (2603:10b6:806:4fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:54 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 07/25] btrfs: zoned: allow restricting the dev extent search to a zone type
Date: Wed, 21 Oct 2026 15:41:06 +0200
Message-ID: <20261021134124.2338902-8-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA1PR04MB10180:EE_
X-MS-Office365-Filtering-Correlation-Id: c189f5fc-dd71-43aa-cbdb-08df2f791161
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|56012099006|11063799006|261009223027099003|18002099003|10067099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 4JJtyht3XAk6eP03DNkwViFTPSSwPzOcEz6mbDrMlCVknTOYZt2kULIZb6vxgNpTzb5KrIN9cjDL1FxY86SNTQSDESGhLJZ1bmoNkv7Mhe6PwCNRayutvmbGFRIFSbJHMKGzJbm5jMxLzGWplX6Ub4BLjPua+GLOCp7s9+WfvvpJOKJL2YEuiHzyIamjO9vBBzzcehHlWaHI1nvNWWNHDldpLBqflEm2ZMfQAANz5w0UQx+1kOi3fAgdJ9boz+cSc6PvaAkEB89nVG4ipSg2IKkv4/3kFYDlpa3Hv3gs/m/ePFHZI28E5PXqjBfQH7+HsnpfXiwclLSW8wnAvBduX1FvElJ+43lK8/s/WkvyvmDKrVRM2Z58yx1y6qlq3pJgio2t+qvyRAvVrW6ILABYUlFyjCpfcvgz4z0gzwq4htyympoNdDhpsU+Dk+6kTW2hKo5sBBGLHkK3ibN2koNoT4V9a3sIc+l9YevQz5KZAGnZCXURm2HC5pKSufa61pQlKixf4YCw4+VflAjC8DGWY0elBUxL0ssdlhW3dahUNEVj9jvsj2aXIXOmVCPkEjT73ZlkALQcx8yFHLRDntYWd9isVrqB0cLpj+T3FI1GgEABF1vasglwY1aapg6GRIHuE3TGu+VXnbKwErrhHXuwuaAJoV/IzGucgrg1tGFgpEA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(56012099006)(11063799006)(261009223027099003)(18002099003)(10067099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?nD+poXXew+Egm5ozVkCmZSFOZ9zPxlRLt5UU9Hy6smZ+XfifA+xg3evT+1ge?=
 =?us-ascii?Q?2e6Q/u1+/Fz18/BsXrvGoRJ+zaLQAfQFmuEBlulykkwuKsjTRuBcUIj7qfK4?=
 =?us-ascii?Q?Tq41YAqtWgE19u0tXPzrXZtOCpbOwsfqFeonWik8gs34LS5RM7ulQOomzdG+?=
 =?us-ascii?Q?B5bR+OIm6mV217YHufontqxnzAlaXZodenuawvoCO2/P3uhw1+Q3ak38/xA4?=
 =?us-ascii?Q?e9NuKux0VrVhzJ9i54pFubkz4Vfxr4Bhek+ZQV0M6C6+htTY3+qQVHom9Efz?=
 =?us-ascii?Q?ObHKK6xwPgG8+lDsEXdwwTunNWau3RVVSYpv9QuUyx6bMmvyMWoU40eKCrWR?=
 =?us-ascii?Q?B1Cuos4wSQg34+umUBqMCZStjM18HHi/sQCnVxayxwY+vC/vg66hXfQR9ZS+?=
 =?us-ascii?Q?bxuloaDZFNjMt99k91iWevKKJb8F4J2+1xKwCKHFOCctLFdPiflZGJoG4WHp?=
 =?us-ascii?Q?kOMLP48YWPEb37wMOF2SEBPqnfnb1vWe7hrDOntCB9XtMfdSyrSYJFSEVQId?=
 =?us-ascii?Q?bhkZ9ILS1b6l250gbeV0a0LooMLcw4KX202StM+8UUstUrjbU3y0zTfjrKad?=
 =?us-ascii?Q?OFkDgEQObwwV7YvlBUpl47uiwL01PVbWuPk16+N3+Ip6XRhU7/abUk/AWKHe?=
 =?us-ascii?Q?PUL7eq1p3uEgYM4CSmUJslBFip6jDx39TqrX+hBqUzrzegtM1FbdfofhaM9N?=
 =?us-ascii?Q?L7f0xXY5Duigm3ws1o3U6VzKBrk/VpneoWFReYz3iCQfCjWuHSYg61pJpkmJ?=
 =?us-ascii?Q?6cIajCo5dXpWj65pvBB6R04M6XOSv09UMg63J+KMlVU8ZHXg4aS1ONkizUQM?=
 =?us-ascii?Q?23LHBGMCuqJ/V0qTsgtkCRmRYeLFQNdNSJgwRqbrjKUHh3lqHF+//ew9CQQQ?=
 =?us-ascii?Q?ErHCR07aG5bCy1dPhUrGlRY5maVETZNxc6wIPirwZMk60oHgEK+Q75WG1D/w?=
 =?us-ascii?Q?n6SLU/6tchbMNoSeuMHNJvbdNOHDFoTwSjO94sOdvpE+grurtPHYiRQHaR6G?=
 =?us-ascii?Q?bP+nqLnqV5uKMvbT1J/PXGOOkAC9G1L3urotBRHGG+ppEbTANzx3sIXLSFQb?=
 =?us-ascii?Q?xKcBSjcBbM4HFCRrX0FlXv3r3ZBI0C7Gy2f6AuoeeQwxkQD1rLOcbncra3cj?=
 =?us-ascii?Q?xc9Vca6+eCNpkuy6SfEREDNdz6eaADDTFqZHB+p0z9SM/j3u9rA3/yZufLL+?=
 =?us-ascii?Q?fm6Z6FafglMSx4l/Ri6QKcUaVD4okAVVfTdtAoFM0bXIqtr6fAAu0h02grS7?=
 =?us-ascii?Q?IS7DIemlnP3Tq7eCoG5hQzOrQ9P2wGXG06Ei7OFfHZakbFDkt9v56cXbSH/X?=
 =?us-ascii?Q?HgZ86aeo1CxN+M8kwJQ4rB/lQq+UH+2M+AtzK9lIkmZdnVNZbQmYUkGA1n8h?=
 =?us-ascii?Q?vP6OYmMZsiHSceZ4cDvRMAzjonl0+iTJpJhf8ndpS2e9sMmzbYCQDpeThDxv?=
 =?us-ascii?Q?gcMFBSHqeE/BeZEEKO/dbLHxPfq5KMj2Hwpy5J0/81VotANlRisqdd24S5nw?=
 =?us-ascii?Q?G3YNYlXKp3WeqLW3Xm9CMGToKYAphwqowqN7pdZPFk8ip6G9AgtcZxdwuAJw?=
 =?us-ascii?Q?++u6NePly97OLesIWslhfIibSvZYHOywDjhbFY7oL3DlUL7b1e8WkMCYxgic?=
 =?us-ascii?Q?6nUHcmsP2INN7HBR4TStF77sYZPJy2SRQf7BDvzxcnUAy1plnjBcg+FWmuQq?=
 =?us-ascii?Q?nFQ2G+pj4Zb7ZD33OVPNSsLO/5QvqP37d9H7lgk9qcvF4wD87doSBoL2Ug4H?=
 =?us-ascii?Q?sdxOPbrKicMRcvhRdNt7rWk/Bo3i+LaQDbLKpuW6+UBcBr+kPHw0G56udTAJ?=
X-MS-Exchange-AntiSpam-MessageData-1: /K/dKwhICudd/8LcWeuJen/8/4bLP6OQNgA=
X-Exchange-RoutingPolicyChecked:
	U69FqO797S4HYQgk2fXuNbf2LtXqOpyUesKKs3waXq5ZwNqYgebttnQcWi4wSl+5cORhmqbKn0E9sjf5RY/XrXHGgEcz/lgVPUjLZKfoiP+W3RfDKnf/OjJUPqKVCAJk3cQd/4rrfO5J55vW7XZVex7Mh7csveV60ESQp75L7Na/+tmEC2OToE7b3vsTSw+Brp174AoPpjzENqriC4yiTpaHOHNCU7kLQuXxlKM+oNZSPiXn5ctqs6y7Hojfguj3URI/DMivIyrbaEUg9ob36Aq2U6MftKGyzW2kEgWO/13dhUHUSN5HGevUcdZLbl29xTs1R1lzoNHI5XsZHLcfZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	reLHOK3Pxds9dbJyHFACaX6zZmmI5ERfDEML5GhQNoSvwAkQNwO5jNt6CjV5m0cDOQfg82k6FHfewz2M7lizZhR4KFN5mIGzh/czqqERSXXDadG6yLQqm0zz4EgADpSmy4jQ8XC7IJd8VPPhPalJnjMBzdcZa8QJsOBppms+2/OE4qMxxH6d5bxAWf1DDZS8iuhGzm7/yFrF7Qb8QHic6/KjZQXqqK9YJuATTDacIY262gvi3TswJds5fcUoFHSp8sGjCsEy6yGMyP0rRZLdLsy9KxCSMuxroXjtzHvLqHwqwK9cSxgCb9LhUljqlrwcjxYcB02jRY5xeo2C36FYF59I0Sd6iDoGUgrhAE5g64qoVLeNDcF6e5sylycv2a2zVssM/WOGPWpnnZE9BP1zpBurdln26QqaBZvEh28ecdYVfHH642yfalcockZ/lsQEVyg/G6lmliGLULdw0aVZc/AibxXF2V1/jhk3e2lglPDL15YlPwerS2j0roRufdBzj/8y98WDP8vrg7YDR+m4Uc4UGkviLv8dPnLBK+0GIIarCUDAfXI62DU0iz2RRgUMnygC8wvwjCAT3VIQ0iRvgewmsUcHLNztvlggFYLFJ3sfkrXem1sSyPg4yIaywf1n
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c189f5fc-dd71-43aa-cbdb-08df2f791161
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:53.9994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pVHiblpxdAmsm28fDSJ6uln/RiX3ALR6d1qEynGsG2sKlAV1j693EQ2ZlHeByYFnWTmpRv37rHpWtIZIHPOPRnj+oAVe2Dw81E04YwJLHo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB10180

Add a zone type filter argument to btrfs_find_allocatable_zones() and
plumb it through the device extent hole search. When set, only regions
consisting purely of conventional or purely of sequential zones are
considered.

A caller expresses a preference for one zone type by first searching
with the corresponding filter and retrying with BTRFS_ZONE_FILTER_NONE
if that does not yield enough space.

No functional change, all callers pass BTRFS_ZONE_FILTER_NONE for now.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 24 ++++++++++++++++--------
 fs/btrfs/zoned.c   | 25 ++++++++++++++++++++++++-
 fs/btrfs/zoned.h   | 17 +++++++++++++++--
 3 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6574939e1295..825d110ea481 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1704,7 +1704,8 @@ static u64 dev_extent_search_start(struct btrfs_device *device)
 
 static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 					u64 *hole_start, u64 *hole_size,
-					u64 num_bytes)
+					u64 num_bytes,
+					enum btrfs_zone_filter filter)
 {
 	u64 zone_size = device->zone_info->zone_size;
 	u64 pos;
@@ -1717,7 +1718,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 	while (*hole_size > 0) {
 		pos = btrfs_find_allocatable_zones(device, *hole_start,
 						   *hole_start + *hole_size,
-						   num_bytes);
+						   num_bytes, filter);
 		if (pos != *hole_start) {
 			*hole_size = *hole_start + *hole_size - pos;
 			*hole_start = pos;
@@ -1754,6 +1755,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * @hole_start:  input/output pointer for the hole start position
  * @hole_size:   input/output pointer for the hole size
  * @num_bytes:   minimum allocation size required
+ * @filter:      on a zoned filesystem, restrict to a given zone type
  *
  * Check if the specified hole is suitable for allocation and adjust it if
  * necessary. The hole may be modified to skip over pending chunk allocations
@@ -1772,7 +1774,8 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * and *hole_size is set to 0.
  */
 static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
-				  u64 *hole_size, u64 num_bytes)
+				  u64 *hole_size, u64 num_bytes,
+				  enum btrfs_zone_filter filter)
 {
 	bool found = false;
 	const u64 hole_end = *hole_start + *hole_size - 1;
@@ -1793,7 +1796,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
 	case BTRFS_CHUNK_ALLOC_REGULAR:
 		return found;
 	case BTRFS_CHUNK_ALLOC_ZONED:
-		if (dev_extent_hole_check_zoned(device, hole_start, hole_size, num_bytes))
+		if (dev_extent_hole_check_zoned(device, hole_start, hole_size,
+						num_bytes, filter))
 			goto again;
 		break;
 	}
@@ -1810,6 +1814,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * @start:	  store the start of the free space.
  * @len:	  the size of the free space. that we find, or the size
  *		  of the max free space if we don't find suitable free space
+ * @filter:	  on a zoned filesystem, restrict the search to a given
+ *		  zone type
  *
  * This does a pretty simple search, the expectation is that it is called very
  * infrequently and that a given device has a small number of extents.
@@ -1829,7 +1835,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * is not reported as available.
  */
 static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
-				u64 *start, u64 *len)
+				u64 *start, u64 *len,
+				enum btrfs_zone_filter filter)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_root *root = fs_info->dev_root;
@@ -1905,7 +1912,7 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
-					      num_bytes);
+					      num_bytes, filter);
 
 			if (hole_size > max_hole_size) {
 				max_hole_start = search_start;
@@ -1944,7 +1951,8 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	 */
 	if (search_end > search_start) {
 		hole_size = search_end - search_start;
-		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes);
+		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes,
+				      filter);
 
 		if (hole_size > max_hole_size) {
 			max_hole_start = search_start;
@@ -5927,7 +5935,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail);
+					   &max_avail, BTRFS_ZONE_FILTER_NONE);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c4a655a2fd24..4339aed14d2c 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1045,6 +1045,22 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 	return ret;
 }
 
+static bool zone_filter_match(const struct btrfs_zoned_device_info *zinfo,
+			      unsigned long begin, unsigned long nzones,
+			      enum btrfs_zone_filter filter)
+{
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return bitmap_test_range_all_zero(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return bitmap_test_range_all_set(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 /*
  * Find allocatable zones within a given region.
  *
@@ -1052,12 +1068,14 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
  * @hole_start: the position of the hole to allocate the region
  * @num_bytes:	size of wanted region
  * @hole_end:	the end of the hole
+ * @filter:	restrict the search to a given zone type
  * @return:	position of allocatable zones
  *
  * Allocatable region should not contain any superblock locations.
  */
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes)
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	const u8 shift = zinfo->zone_size_shift;
@@ -1079,6 +1097,11 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 		if (end > zinfo->nr_zones)
 			return hole_end;
 
+		if (!zone_filter_match(zinfo, begin, nzones, filter)) {
+			pos += zinfo->zone_size;
+			continue;
+		}
+
 		/* Check if zones in the region are all empty */
 		if (btrfs_dev_is_sequential(device, pos) &&
 		    !bitmap_test_range_all_set(zinfo->empty_zones, begin, nzones)) {
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index f9dbab976a92..5f21a360f23f 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -28,6 +28,17 @@ struct btrfs_fs_devices;
 
 #define BTRFS_DEFAULT_RECLAIM_THRESH           			(75)
 
+/*
+ * Zone type restriction for the device extent search. A caller expresses a
+ * preference by first searching with a restriction and retrying with
+ * BTRFS_ZONE_FILTER_NONE if that does not yield enough space.
+ */
+enum btrfs_zone_filter {
+	BTRFS_ZONE_FILTER_NONE,
+	BTRFS_ZONE_FILTER_CONV,
+	BTRFS_ZONE_FILTER_SEQ,
+};
+
 struct btrfs_zoned_device_info {
 	/*
 	 * Number of zones, zone size and types of zones if bdev is a
@@ -67,7 +78,8 @@ int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes);
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter);
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
 			    u64 length, u64 *bytes);
 int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size);
@@ -177,7 +189,8 @@ static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror
 
 static inline u64 btrfs_find_allocatable_zones(struct btrfs_device *device,
 					       u64 hole_start, u64 hole_end,
-					       u64 num_bytes)
+					       u64 num_bytes,
+					       enum btrfs_zone_filter filter)
 {
 	return hole_start;
 }
-- 
2.56.0

