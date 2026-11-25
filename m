Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602670;
	b=JiDrSXvOOyx2lQ9BRjqX8yXqbW6gQTzBZsqchoQflXMpp7AptlcmWrBNiuGrW6nJ+VU3
	 PZMeMVRta2S5SCceP7pf5Mmxr7jdZzL0GNQhgpYsyIjnPt2bajQysNjIHWbzC4YegosYe
	 DXJtTQuhTEgY4X+kGiT6GZrWuU3lbJwISuh6ZTOPROd6FwOqTeT0DgVmq1zL0+CRxlDM6
	 EFm/8e5CTI29Jia2CzYci5VGdtz562+KeKfiZh/llIvH+VBVZQOFpn8zLXqACMngiqs/9
	 EbveZDyDxiphQUpOgcnzlt0YuGL2Y9v7oPsDVXDdeybPDxrjXM82rCnC1roMSwscDqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602670;
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
	bh=xUpYenbKejj12d80k8iOT3kV/AdChAC9nUuK1naq564=;
	b=MjGhLdpsmKBRmWTZISkZRLYCvBZ8qAyuYgDQ2CRmw9/M8Oh78VkXYf2hr9c0VpYJTp3S
	 8YCVVlvSJ5KcipRTsPFceOSf2PwqffoxC8iDu2LY5WdmPkca2vrxI05rk+QlNp70i0uhA
	 Vp2w0K0Ybw5KN//Lw57nz4hz6tML5DpeuD1LPSAGSwLTN6WYlMZ6XVo/oxWmdZatONZOZ
	 BR78MUJ55Dyn9eFRCRKBfXf6IALFRFAIQ9MSy0rdG+vxvcwXMOIXX0GJSP10U7qCFbVtA
	 I1iXcPn8aVPMCtFzQVebx7nfkJfHmKIuBwQ88r6MgTkpvAmg4sWDCop55SOvBIrYJJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=EHWkwD2O;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=RaScHrtD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DE2606A32C
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:31:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46DE2606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=EHWkwD2O;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=RaScHrtD
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602678; x=1827138678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0sal49oniWp2qMGhwY7zCeQMvUDmx3HN6lIVcNCWGGk=;
  b=EHWkwD2OIOuGZeryT1HUSQrBImMZAX6EJFgcjp1NuVa89tcpdEOHWsqg
   D4oNGsHo2fNJKOjTGzEosZiG+Y8pFraZOcy7xl5bf/hIUyYqHniuKLiG2
   /Itd8Yz8rsKBrHlBxIj1QvIDOOUQ2B4oybUhsGUl4bJqu+7l40MXRUy3N
   u70zqjD1+nrhq2ak5Vqq2y725sAlZkNvy8Radvn2WN1G5OAcyHu8DtaWI
   KPbWWqyvRoRwVwO3Vizdww/qIZFfQtLJHZeXSzbK5MlxlSfd6o+0z03f5
   P/AssI13GGFmsL4qe0dlDMTJ9ISJRPm1qxxn+k1EtqCUzUc/Hdl4FQCWy
   A==;
X-CSE-ConnectionGUID: wrW0mTdlR+uS4M/aGvMwbw==
X-CSE-MsgGUID: ZuDYAT+xR42es21ZiyIf1Q==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161732723"
Received: from mail-southcentralusazon11011025.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:31:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkEhSqQItKpq+ptcdQmCBImLXBheoCTq5B+LSvJwwBZaf0M2sCKbE/rJrbVFMoxp5+LegrDKMxrsPaljwGf57oh5WwOm7POFmzvigUvMx7VAkKS4ILrGvZ2Ih5kDQ2aC+QHVIjbAo3p5eySFkEKOili2dYI62SZ/k4dRkbhZrLivavEKSraFe3qL9isKPF8fN9LlLYuN3DILA04+4cf8Q0j6lGEHuIOMIujf1lqWjsRhXrNvLVepkJDrBDkMMJSGMK8LMTUNLZF2uxHBOLByvKytSPkizx41J0+/PhfLUYk4jEKz7q4iBYzGWsySclZ70Wsig8//4WjXTsPOFUGcTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xUpYenbKejj12d80k8iOT3kV/AdChAC9nUuK1naq564=;
 b=KixnsmBhQy7Cr9DNrbOxUBeBDJIF6bq0lPgyFE2ZpvUhzR84PhK5LfnTAHP2TKjcj8SnjMyU4pRuhJQQaax10BY6gQvrFs4FN5qSo9DuE+DSOILvW2zYRpYk/mCZfpMrBLqKuuVK+sVhIjP1dO9NedQQoPdFFcM/R+3iPjcsVOUL5SQfmD9MbsaYEkdni+bPZJVjoP5tVjXB8Y3V55Q3JrsgmXceVHhRcyFDPFnJY3JrRxO80lkUMmu3R1GkoU4+RqsctTv56Uh+gRzazZc8qTcshVoHua+aqbNbWo1eX3a2/NxzBMBVLQSqM+kxp5r+uYzIV+724bw2h4gKmR5myg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUpYenbKejj12d80k8iOT3kV/AdChAC9nUuK1naq564=;
 b=RaScHrtDNHKli9JVp2ZSFduBgZCaa8g3FHRzfZLuXt2YGLqzISyA0cTMKZtOs6yJ5QRM9MRHrNz7lyCHIIStNHXCTieJIozzbRQiIK5B5zzXgHe7ckXJwv1uBrEv618gx/D0bqSNQcv7nvUW7IysvNCpoInCEuFiCZ3+o/NQM4M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:31:07 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:31:06 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 22/27] btrfs: zoned: return finished relocation block groups to the data space_info
Date: Wed, 25 Nov 2026 11:29:51 +0100
Message-ID: <20261125102956.266389-23-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: bc4b71d7-2f7f-4424-48ca-08df4adf36bb
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|261022075727099003|10067099003|261021123027099003|56012099006|11063799006|261009223027099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	otbv/TYhxutucpP8LAjUib/EdNxXg9RXYd9b/Ld8dU1nhLU06XbtwIW7gwh8oabhNmFze6+ICpLZV66vdYkd7gPLEjN7vGapOh2fAvkY9c1nA4LxWzcc8RgaHa3b7VylRPQlHMjsLSczjspZdUlEN/dT2AM2JvB8Kt/Pjt866uJQG8P6/Ukwg8Hhulw000CQHWtLbIqDdKZZtZ/+BM+wJEpjNnV5WiWAtRlXVtJ9s12xcqHmT/ctYqwcPlrX6ANgJ4D8DTjHABYcNR16LxUN2+sCvLNu+upLGSWEaUmDrVhYS0OShPrrSEuPHTxF9By8xsYNG+VrYoEScrb5ZUMknyepNxrqBWDRy+hDNG2ZQeGQdKx4VgK1nQLRtF2+yybVZKaPXMZ+z8a30L2fqgTyfXsHufw6svBKd8fKZVqupF7QHFsrvs0gxIpdqQ9UkuxTnSMLxQ8LNgRSXlte9VYN8pYEs0lTqx8geQFakwrX+D3V52AVSnnP7wv31vypPqQxxiFLhGzXdnKfApwVHpar4IjaHb4ti7JI06bW+xktC579pmOLNCA8AfigE1JGitL5khOP4cVKBPC5Yl60QkSFydPhBXhimEA8NonPB4MANJ0oKphKsOLtETc/H0ugwFbz5H7yVoq/i7K5My8cHcn7TLHkfD98dmFAbuh2HdTsRMo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(261022075727099003)(10067099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RHTlknHdtcubNRKA+Gwhz4xgcWyzrBQaZ+fcPGo0T2Sq7OzRE50bSaAr1e1N?=
 =?us-ascii?Q?nvkPKRx5NjrrGlkkTQve14vrGkCt6mk8hS6aV8XVYFWC7NrbHJolY8sYh4UN?=
 =?us-ascii?Q?ZHun+nlPg3/8+/fmbh9vh8olrAORhqGtR/Mw15qSwdOh6LgLOxba4+kWhSng?=
 =?us-ascii?Q?6hX1J0PtfOZ9FF8HUT7z04pv1RLxeUBBFbGUISw6HpPXT/cEsc6gLIbcZGQZ?=
 =?us-ascii?Q?T6CfPdgMeGFAJlJ4bWxfpBrRHoqbf5U8rXF3eujnXcuOz4oYwvKXHL3PmuSx?=
 =?us-ascii?Q?0FmJxyfKxho7u5XvWkR9wWADCs6caeC4G00ZneJFNmrnF+0XoKrSSEQ497iN?=
 =?us-ascii?Q?TYfa8c5IjXBfGp3JZnJOubTc1YrwO72IK1FK8rnUD1diSGPIcksB/eNfqXSi?=
 =?us-ascii?Q?G2VgcF9sY9jb9IuqgoytwBuMckrrQE5Mz0ypi80PE/wkfDNlD9Vg0WHxwypN?=
 =?us-ascii?Q?4DehvXVohp9a77MxhBj2gyTWaDE/t3hAs8AFpKRQGJMOpLrC4kvn3NnJb092?=
 =?us-ascii?Q?8OoJrOMtTEuAUrjohXORuD4A3LNwVm4WwCDI6PQhxCwrQXlA7BczUji7p2Be?=
 =?us-ascii?Q?1mR6b+7jBB4RaCkGhYI8b2cNCLbYaOqi9yIhqLuD+/chP1XqWxO/S9I6fTKp?=
 =?us-ascii?Q?aH+NLI20vbHwIqk0MEH2GafdW3G/1VHoj9m/4ynmVA0tP+ZW9mMggj4CjWvi?=
 =?us-ascii?Q?7vVS4bLY2670cYIUJIVYXnpX1Zl0ciYnCL5gBDA55YzQ7ImBC03l7xdCgvGE?=
 =?us-ascii?Q?FMN+rVFtCuB8IUcNcZUPKWn9iaaynHn9/l8VH1FkXiR+aN99ftytGpjjXQuf?=
 =?us-ascii?Q?znmEIbssHt0BqA3eLKIApkmsnOd+NPmQspAJx7dZAclqOTA88gvmoJgrgOUd?=
 =?us-ascii?Q?G/2/dmhVZwsiY4uhnzUMR0w/B66COk1Ld4Va6MDlBioZGEpiuKTZgyNQZJ/1?=
 =?us-ascii?Q?XEVEBSzCzyGOk7nui65PjGJ4Z8cwSSjhAA+KywcCAT19/IizzVB/xrsWRBeY?=
 =?us-ascii?Q?XwYwqIFVR5n+inbgaw0xZlwQVfb0IWv4yoDg06Dm0e/GZno1FL1ajvSnYBI0?=
 =?us-ascii?Q?PeFbPMUGT1DxEPoIUspwe6ahtbmcogdTon50mPVfl3pAYyCEB/GJGYFXdi0i?=
 =?us-ascii?Q?nhocGTi5iJoJaU6q8hOUGZ06peZOrlpghnhIIduRFCQPUyhzI5iT7LkqPg1u?=
 =?us-ascii?Q?raCEmlDWlUwTzHlZEW4FWU/jEYI/8uF8rjEaLLDeH5TbgqfMxvSJMCanY+ra?=
 =?us-ascii?Q?qtVq+2Zh/6MD+pjpd7fJKuFv2KYQRquojrW0Uao/3B7IqCElap8xWlFBfMC4?=
 =?us-ascii?Q?j6rUzBjKic0CzHYg9hj/l+9WGnRtsv5ppclug5NjQs1ZxBBKlBTRSSUXwAZ0?=
 =?us-ascii?Q?WMfTgOTpLUFHhW8cM9fnhgks+rUIST3pD4XNElDoB67QgxiLBgdvvnxaHuOP?=
 =?us-ascii?Q?sUWV5YXdE+0WwRfb0S7VmTuu60j78pAzc0oAQPtQKO3M6eZL+1J05j6R8oWk?=
 =?us-ascii?Q?h7LiQ5sKxYJjWml5KBKLmk07rQsQsFUxUPFG8LWFmVdFFquysnkfeftP51oP?=
 =?us-ascii?Q?v0L7wUAsf9IxTONsZO5/q8XMDR5X3QHWDwWMlIaZu6P58vj5V5VZnPYg7/ZC?=
 =?us-ascii?Q?jwYb3MZlwuG9rGY/FpiffAacjonR/8wZMkAfMbf/Mvm9jr9ncd/sag8rL/5M?=
 =?us-ascii?Q?B2UFdJNgU/50Auc6Ro54ua8vRuBoA8V5sAZzZp2b9klpF8IwPzOmD4Xfzwqt?=
 =?us-ascii?Q?01kKO/cthYfyi7IT3F/cmIqSmYzxbwT/7h3OQCNeI5jfZ9G4CMu5s5RromXA?=
X-MS-Exchange-AntiSpam-MessageData-1: Lc7IvH7sp5aMMhCOA8rLbFZiKW5E2rl2DjQ=
X-Exchange-RoutingPolicyChecked:
	XePrjcrrIkUDQq2zSSPt/d3QUf7uv78TuNoP2y+yY39p9Fq4zFk+PAU91HDn02pAcqTmIaeU+xPWLtaZUSHbkue8D3duuQjjbdXh2fyAmpGO5cEg3n7tkvekJFZrFIM6N1x/oNFH4BrHDGOyAsW86gCVWfhTDO3Mv9KnAG3cNfHABn2XmwUH/MCQPcChRKBNbwKdnft0IP11clbViFxJD8oWetee8TZUv4i9LAI4TzXRJd3dxssxHSkHtXk+kzYaEJJdWjea+y9VwQpmRsBD4RfqyzchtIC0cmlsYHSASK2DMsvgXL1tgnBqcGJquQNDAyhaHB73SkvJKbXVR1D5Og==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GLY99ohngSvaY9faJ1fejZr6wMTXZsLoJO86Y8CWBsK+C856Dj7BiaredtnT4NjW53y7ABKCf8UqNV67mdcxrBPLm++NCPRMhXIOs5wYW/BPb0QzcK2kB1CMcctNiODlX5B3JrJXfEtK2QfpGBBpDYP6/Z//d/iVCZdLXF3CFW83ThtCtJ52SIJ1tsCYG+pGOrMpmPSYTczsW3L7qRdVqo/HgLTjD/8tIwZ7uxTCd48PJ47QDdzoby7o60hJp6eJi0xJVO6oliZ2NgABLnLcOzCqZoXEPB6uR53IgUv0HcizKi4ZrS0aDX7QK9eyHnQE5SBZ+eDpWViJ9tiCx7K3CN4LAATwXgioQgUrlq6bDMyrtNZ+U3eLoUOpszvd9jsPjRNUD7rX6zqR/IdrFC1TIA509n5qpUAHj/UXNhtgoh0PB0TMkfVz09Gj6lhnpHnwBKP2TanEm+2jO06axFOTV7BvPF87Irlj9Wc8B2S+LNZEykQTH7tMo1PopeMFluTFaIYioF1ec7sbh88KdNFEEmnCmFC7w67y7P+OB9mMOhXNRu8beimZAL4dNhfJ0FKSidL+l+LrR649b5zLS4ym8h9NldAwFFKIKXR3i0QzXnhKSAp4RzlWolUgsSphXY3s
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4b71d7-2f7f-4424-48ca-08df4adf36bb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:31:06.8787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MyuzYQUbuuswz007YinF2G8uls+bAzfcwAVPAug3/ulVpeW6gHc2uESCWJU5686l18wNVSBgC8iG8wu1l2/ddzjUYwpJgzoJpWc5IJ1N1vY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

On a zoned filesystem, the dedicated data relocation block-group lives
in the data relocation sub space_info. Once it is no longer the
relocation target, it stays there, so filled relocation block-groups
accumulate and their space is never available to regular data again.

After each block-group reclaim run, move the relocation block-groups
that are no longer the target back to the primary data space-info, and
reserve a new data relocation block group if needed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 +++
 fs/btrfs/zoned.c       | 63 ++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/zoned.h       |  3 ++
 3 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ddc421db8e44..dfe3b61e458f 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2171,6 +2171,10 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	spin_lock(&fs_info->unused_bgs_lock);
 	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
+
+	btrfs_zoned_return_data_reloc_bgs(fs_info);
+	btrfs_zoned_reserve_data_reloc_bg(fs_info);
+
 	btrfs_exclop_finish(fs_info);
 	sb_end_write(fs_info->sb);
 }
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 6c99c28bbb45..7111b55d4aba 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3027,22 +3027,29 @@ static bool zoned_move_bg_to_space_info(struct btrfs_fs_info *fs_info,
 	spin_lock_nested(&reloc_sinfo->lock, SINGLE_DEPTH_NESTING);
 	spin_lock(&bg->lock);
 
-	if (bg->space_info != from || bg->ro != 1 || btrfs_is_block_group_used(bg))
+	if (bg->space_info != from || bg->ro != 1)
 		goto out;
-	if (to == reloc_sinfo && bg->alloc_offset)
+	if (to == reloc_sinfo && (bg->alloc_offset || btrfs_is_block_group_used(bg)))
 		goto out;
+	if (to == data_sinfo) {
+		if (bg->start == READ_ONCE(fs_info->data_reloc_bg))
+			goto out;
+		clear_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+	}
 
 	readonly = btrfs_block_group_available_space(bg);
 
 	from->total_bytes -= bg->length;
 	from->disk_total -= bg->length * factor;
 	from->bytes_readonly -= readonly;
+	from->bytes_used -= bg->used;
 	btrfs_space_info_update_bytes_zone_unusable(from, -(s64)bg->zone_unusable);
 	from->max_extent_size = 0;
 
 	to->total_bytes += bg->length;
 	to->disk_total += bg->length * factor;
 	to->bytes_readonly += readonly;
+	to->bytes_used += bg->used;
 	btrfs_space_info_update_bytes_zone_unusable(to, bg->zone_unusable);
 	to->full = false;
 
@@ -3315,6 +3322,58 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	}
 }
 
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo;
+
+	if (!btrfs_is_zoned(fs_info) || !data_sinfo)
+		return;
+
+	reloc_sinfo = data_sinfo->sub_group[0];
+	if (!reloc_sinfo || reloc_sinfo->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC)
+		return;
+
+again:
+	for (int raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++) {
+		struct btrfs_block_group *bg;
+		struct btrfs_block_group *found = NULL;
+		bool moved;
+
+		down_read(&reloc_sinfo->groups_sem);
+		list_for_each_entry(bg, &reloc_sinfo->block_groups[raid], list) {
+			spin_lock(&bg->lock);
+			/*
+			 * Only return written but now empty block groups that are
+			 * no longer the active relocation destination.
+			 */
+			if (!bg->ro && bg->alloc_offset &&
+			    bg->start != READ_ONCE(fs_info->data_reloc_bg)) {
+				found = bg;
+				btrfs_get_block_group(bg);
+				spin_unlock(&bg->lock);
+				break;
+			}
+			spin_unlock(&bg->lock);
+		}
+		up_read(&reloc_sinfo->groups_sem);
+
+		if (!found)
+			continue;
+
+		if (btrfs_inc_block_group_ro_notrans(found)) {
+			btrfs_put_block_group(found);
+			return;
+		}
+		moved = zoned_move_bg_to_space_info(fs_info, found, reloc_sinfo, data_sinfo);
+		zoned_dec_bg_ro(found);
+		btrfs_put_block_group(found);
+		if (!moved)
+			return;
+		goto again;
+	}
+}
+
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 02298f408102..1f5f62f7590b 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -110,6 +110,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -298,6 +299,8 @@ static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info) { }
 
+static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.1

