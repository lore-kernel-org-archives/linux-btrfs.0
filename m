Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590156;
	b=mlAXk/n4Qvi8KTnoNBKvHWdvrOtguqfM0XCV90ccVptRaSQchrg39XCxsJJmA3VimOk2
	 6tyxIVuDMW2plDjiTUghIbvk0gu+YXyIVrv3489FyrgVu67BSy+DBkEoef5HG+k7pObWK
	 /bdl0qwJSAlk8wK5NdBq244j4e0vetrsQwETQPT1FGHjuMp/rcCuYWrss+Z9QU8BfwjIk
	 wHfqho9XdZOcAMZq2uxLdYnFrwFZuW5+IdkffQflyK++dX5wklT7ve/FZMXQgCgfCTz2l
	 1BGjznIumtogA09uyqqahAyCXhQjQVT1LqYaiUsi4/b8Fz8xUfh/ekhDVQEVuIFJjEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590156;
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
	bh=ShNRu6QT3QTsCHCEmhz5w5FXtdLaSgolE0eBdr63bwc=;
	b=dg7fZbk6ZSQ5ADsLVkU8KASivZF4nC0NU3fUUd+d75C0LNfAQcqxNzS7IpZjLZ2rvTE2
	 8iRU6xNJZ2IZxZM6Q3d4qLtuacM1KRqSH3vJ8I1z/G+55hAU/EXK5KjnOH0G5tCu+VAfe
	 qjKAmZBHIX+yQIbUmSQ7hL9+pPAYe2mn5DP8zzWDpisGRgoQI8ogOjv0jAl3uiESIEo3l
	 cpNspAGYHCioyqETz1DhWNi+C4DVEYBc16/0SH9iximBA+5qKYAe0RBYBw5fbIAbRjR4B
	 ok+Hy7VlHBnn5/grWMvUfZlgG1bJkPVq6MXRBwKXL/SPAMVaDST8Wt4bX8YNjqUSyUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XCQ5qG4T;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="UU/xNd7t";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E1460A2603
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6E1460A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XCQ5qG4T;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=UU/xNd7t
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590155; x=1824126155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=FmOcuOC2xQNYN3qOX2S2wP9H9j9fu4F2BTS28DgRW7A=;
  b=XCQ5qG4TFnAaI+LWSJCAOVf7QCJbaYXWhYc/2Fo0CnqlboIs6mznez3E
   dQQi9wI5uDtqZCYvflZQzJ37f8h76fqfxRQVrperi+JtrSBeNZkW/rg3+
   ccd3t7MPVMxklhn+XoJJs2XyhZK5e0du5LvrPN1ZMVK1mnjdpKqSWh/u9
   MQ+fSNPRCHRKILzfU1KddYYCCBjozoqQT/vrbXdpzzKes5GJm1Wc4sqf3
   GmJNPOOQRd0C//+Dn73yalKyO4LxFtvUpKDuJIAejgOfiH6vlv4KNl6MW
   nK0QdAkivasX8VNeA92AGbQWY84+n0m8fSTyn86mxBf7atTlUXkHGKd8o
   g==;
X-CSE-ConnectionGUID: 9HgQtLI+Ri2rvtG2v1Sk8g==
X-CSE-MsgGUID: gcRAtsrhRy6IB/pz+Uy8fw==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="157035008"
Received: from mail-centralusazon11011023.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=niBTyTz35D4ZLBoqt0oq0egaQ/rWwPYxSs/IdDi2wGG2wVN5RwoDxftzZdbJ4u2n6es2k08h0XZO35V7R6iJXZFPRBFwCuZ5kRbx9YHNrceIssw7uCVIdNAqg7BQ9t99Sm/4HrovK7kxuchCzWTp3DZrtOJtk9SbCrBuogWGCNCfeI6z5gRomsA6Q5kK/YvNNkfppWJ5oH+uI5QiCs5Re1rpqL/EWWnNMR2KenXqfAVCDVDNBdX96R8kEU947RNQp820TvsXytvRu4mFeYxJA+9bV1DZDGBsMMvbIo0WMo2eNaMd6hT8a0we3bey6izdI51g6pn+0rCVMbs/LBrfYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShNRu6QT3QTsCHCEmhz5w5FXtdLaSgolE0eBdr63bwc=;
 b=CCliqs+Ghsd3w7tYDKI3GlBPaxxcAUHF+fXXRDttLgh516JlgsEXpGrcolhpIx967VxfKVCvWIOZzFGxhGLCvyY3UpM/YiPDVOOFSqRYtrmxvm7SfhlZSnElXEsG5L0qgUd6XTpjm63qKaOXuTjO7s0hBuDVeJBusOXX6UDlM7pQi9etww196wo6xq8mRQzVWK5DGuND0o8nQz6WUpHmczhLJJwHuK167jv/MRkEV2BB7JvT4TyVtKDhwloLppz2ZCY/KTmIJhIjlJ7dOc6OwVAxjzL4L6tz0MNHjwh4iD1q0paOo961xyMC7v53AHQpoTh99aVMYtZSEnwiadiz/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShNRu6QT3QTsCHCEmhz5w5FXtdLaSgolE0eBdr63bwc=;
 b=UU/xNd7tmKpj64T7VaWwOqeelbNb7OAJQLHr2lzNVYKIK8yMfXXQJrUlDqs1jIEHQU061MTEIXIro3mWItyKIB2B2KoRNdFxQGt90QWHND5G+9vYHXrcWkmCVd8zfdrRdrPVfOFWtnv2Y1F3KGJh14vlSSCdvPoV2rHWhm1wzvs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA6PR04MB9661.namprd04.prod.outlook.com (2603:10b6:806:42d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:03 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:03 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 12/25] btrfs: zoned: prefer sequential zones for data chunks
Date: Wed, 21 Oct 2026 15:41:11 +0200
Message-ID: <20261021134124.2338902-13-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA6PR04MB9661:EE_
X-MS-Office365-Filtering-Correlation-Id: a699cd14-df91-4c10-3d77-08df2f7916eb
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|56012099006|11063799006|5023799004|18002099003|10067099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 4+ibTNSkYCDWeJIgJNMrQa5s7TbiWLqcWzMHorpQ8hkFgurVptNteHMGmen6/cDSrTqw2wF4PALt+XvXUjdJcu8KNTNbT2K3JlIHOefhFKSWFcMlCZ7m44azs/DQITW2WJF+c3fklmt/NvnhMaYcAN7UX2WJ02ODbOSl8YU1FlK6OWRo2hbHI+JrahE2tdBM6Ia5Nh3PFC+8Uo59ModlwW60Q6NXNxj4DXB9HJy13k5vFycufEi7VSxKEo1nmJ6vaf/lHOgYtAtGcJCu/lJPiw+DRhcsiUNKieaIgrXoOfa4lneWsRDPZhSCxEy3WOmSbEybdO1DrPdBZ0UxCqdaYCjD4Bo47GsiitDC9MTm9lYJOClyGd9w1blmYQ6vtQtkRL/xaWWX7R+uEBLwwiZuorUsBPh1xZqfRwHCCHShLwZFpCYmV27tu28O0+rtzvH2b9O6gbSh9wgboKV7LXztI824eEpQKe1WBJMkfJ8O41qdNTmTsZcdiT25+d9XTY0TiS4QuhykC6uHA9IZATX61SKih8eDwgFu6GBLHCdShRjKBoheyyH5shVrxR3zqReOJ+PGPJ9N6Y95jwTANeCBR0VQvFnZUCqCYgY/mQR+RtcYmUH8f1y4O/wwSUgZD8lGp88rsNOktrolm4bvn2QPSc57jT+poel/D0/77/yxCCU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(56012099006)(11063799006)(5023799004)(18002099003)(10067099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?NR+rLgzonrRgpU6s5NGJB7hiEKtxi/RQKdCItaL08nl+DNi+V51JRfW2dp1t?=
 =?us-ascii?Q?xKrO0oQOc79D3BFDrHvXQ4N4XrjQGHEu7FCG0bUKtok7Xyf3TRW0FTF6ZTpm?=
 =?us-ascii?Q?2S9iUgl3TzL4VNUbRyI8Fwn+vhB5R3CXOoaJ14PL29mCx3Rmi/KsvCJRZNEz?=
 =?us-ascii?Q?vx9pU0qPm1TZDo4P75LI72zp64dPF985Cw3Bu5y48RX14zgMLz2pKy42O1Cz?=
 =?us-ascii?Q?dlITnxYmdo25Tzjz7FEG1FL+CDKXZgTiLlPEn0PRQumZdEvjDSNoirZIzyXZ?=
 =?us-ascii?Q?uGGn5ypxZfy2yAtGEx+cAC4gh34FCjPJUzEpOEyj6+yKat46k/NgALd0XFhL?=
 =?us-ascii?Q?wLIC1zGLjNJ+waq607Q4h4HA3jf8sAgr7MM3K/xOlMDjs/PIQlXAKCnQAD4e?=
 =?us-ascii?Q?vtqe417SFuYyM5G1vwsggvnEevOymyeq6izPZNiwHznGc2yvPKroVmTH4M3l?=
 =?us-ascii?Q?F2wcCUrf5d67cQwZtPvdUZIPm1nfNyn6t8Fr9UprUGc+uvN7z5SwozJeuCVD?=
 =?us-ascii?Q?jbldqpMN/FyU9/mBjONbZt9zBSPW0pNWuLhKd4MEOl9uwb04W75zXakLkmQy?=
 =?us-ascii?Q?AY9t9IdflBBdnNvBQ1a4t8Rg/5t5TySc9gK1jEMvw8IBK1T2yViJFAPE7lGx?=
 =?us-ascii?Q?oQM93bgzO+jjFaRO6ejuFEoiRCTuIqS7sb0MLvrYIJy7hJ4MIhq2EmjtQa7v?=
 =?us-ascii?Q?dxz8Js2lqNrPDzvxnSOUMEL3PuSz+VgZHmQrxM9nERKl07TIeMj3yHq6Rk1i?=
 =?us-ascii?Q?PurJffBGHS24jI6MyBrjstnSLeTBiUMdUn0eg3OlHf+JgAvcDurBbJIvwm+M?=
 =?us-ascii?Q?lRnDwCt5ZqsCLTyvAOAqWxaSGzPs2761oPitC5SK7gyFoQmfUFvGZr1ZKCO3?=
 =?us-ascii?Q?Uh7Nz7zLS3MOhgvc9LZ8CJdD05kf5CpzsOIQDt2ngjyEF6r50ZKyeiZQjMaX?=
 =?us-ascii?Q?RLZ0n4wyoTzPXXmJBjutWy/RWQIIb6+/Ftpr1oOwuuXCdexNn0WgjfiQoRcX?=
 =?us-ascii?Q?QXo2VkxOudrsl1DRc70s39McUAp0m6+Xx0sQMts/Ty9gKpwEtMqC0qaSi4sO?=
 =?us-ascii?Q?XS7peX4iUSNoowS3bzE8SOFqDz8/OrTL+dg5rxJdUxONh24P5Z6HVQzH+lN3?=
 =?us-ascii?Q?KNJ0IbJdv18lh3qjFGVtHRxKF1Qd54G7BtCJH5jjF2PxIrWEU6OvdwVcCFx1?=
 =?us-ascii?Q?P6g7C4qswg9FiDU0v9nqZzo7Lb0NYLvgtvrT6TYjvUlpXFslW6A/9OBf0EKq?=
 =?us-ascii?Q?HWNO0hJAU22s9xdDBF4smkhUb0+jTTWNz/dEfxUsVYe+PT7TEQsdtvrfXXnq?=
 =?us-ascii?Q?wzUaDowlmctTzhaJCX003y6Gvm65eAxNlj5ocDccBaFuaVWjpcuYApbcDDqO?=
 =?us-ascii?Q?zT8uP5GDlUv1nyyN8qxjFYlrbL8ZccSFFUSMdpycKMUhKNchCahEzR9JmU67?=
 =?us-ascii?Q?buYlNmqc9dexlqA5XqTxQeSveNr2TEznGR4hDji+uFKk5LUPryMdImBbOC92?=
 =?us-ascii?Q?RoZYeG6SrZ5gxqbr5pDzN+tv76X02O5eK3bBbbxCL5RNDdKXvKcUM5kWxGZJ?=
 =?us-ascii?Q?+6v26GydfG+8jdL5GCmaxqnT3V6gR5vdzdC+N4PF0Gm50hRfHpfFqJS4jH8f?=
 =?us-ascii?Q?2aTPa7WXF9x+o08GTJlvhsddZKXtQ9N4wsC1KACTc+gYK1WzWnpbjqp43FOT?=
 =?us-ascii?Q?gwewckGdJXXVbx3cE5D1uYD9S8MYgLvmS2njmp4Bf21Z0Qusc0NyyQvRjeiG?=
 =?us-ascii?Q?WXneTzOeEnyryaCRuvFa+g3dwPhyuXeAc10T4al8ylduvLwzjRXiO1g8WoVj?=
X-MS-Exchange-AntiSpam-MessageData-1: Ig340TSVEKWW8Z7QlwKQ1aiaph/VxFvTxLs=
X-Exchange-RoutingPolicyChecked:
	RJZp0FYg/Xylsuml9CUJOMlWa0/WAI9qHOoeOrlT4sRfX0i8e1OMz5e6UxICmkExvHRaFyANsrbd9lumdppTdpCyT4NC+z4ICuUAouFRTEuLvxkPiTUMQrmFjmjjQYDiBgAuhx1zHEKmcMU/Oh+9UPE/MC642iFEWR+QmrirCwV2XsSyPi5Cd/5k2/JToCuekemOFQ3wRY9q7Sc8pMbUCM1UTZhvxXR9iijoCEkw8ShtbiwFX21oPzOlLZPrw4mQr/vN6n34YOXiZypl9r9n3vNoKYcsyVFdLrr6r80IuJN/Q2slZ4Jxnw/hSqdidlo1XNlaOuSMVKkGqIv2lfGwnQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pCeTSMs5pXUiTnX1vZEAGKE1O4JmgUYYMcta8GFPZnBI5nzbA3NZ7Fh0GcZh9RIrwg8YcHnE5HqR1KgRZQdpgKKTIeVeZe2I5Xs4E7/jPtPVJz3bVzBbTGDuwi6cB0UJQI+I/G6TPtCdrlonpGwSq7mj0of0r6dvf/Il7hb58A8wnejjSWIsEEd3TZXgMKFUw/5IxrqGgdTweSvuB5zG6Gs87P1gj+t3Nk4AL26qhCvfrIkxyOSyY9eVMyuw0eZUkZpYZdgFwMgbEwHPgGN6jy/hbXKxPM2ig4SxcZHAlgEh+nYLrcCD29Ay2I5BmuJN4QVtac1IlfmEdxP5ia2RvrdTzgLiQEfBC2RmLEHGHzM0AXxzBJZmHjours9xf9Vibc+xUrGH9gM7pCmUGk+0uL0hlqEVcJSkeI/7hrl4e1gG6LG1dACc839UrcoBDiDVuAVK6V3ra71v1wmjSB94B4X2MOod8b3zGNYp291OkdR6AATzwfv10UotmWg7wkbDQbGuFTmMWdcI0lXrwYp81S6v9NufyeGydWODiGnAmqTg4iRfSkMnUCJe9W+Y0UGKEh1wTXJs46kHLEJFbn6pv5ILxgtteeEa19h5QQ37xg8tNXBukXZrPMjq1UKbGctK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a699cd14-df91-4c10-3d77-08df2f7916eb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:03.2978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BGIf/5OVNOEDxnHAl3bjlMsJvFTGH5NGH0eHcf3w7iQwiGpZ9fzsZ9gQrrltrZren3B2UFGCkqCwhs6sspisBmUZoOEsHTTOkPqvzxJ0x60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9661

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
index a0d37e19ad81..631ebfdb5185 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5896,6 +5896,15 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
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
@@ -5906,9 +5915,9 @@ static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *f
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

