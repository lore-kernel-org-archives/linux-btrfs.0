Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085787;
	b=WgJA4Y+eK4rVmxpzWkntHhiNagd2bbT+lnv4CAfsAnoQS9h3xseouT/QUkrfOm06tjSS
	 iGGw3mJFtngsAaIkfAg3c5aRiQ3AnBDIeJziLUt65KRteNGendzlLBtRtJwXQTkfbEf7X
	 DxLRJ3KeIY2o/CmCRMDHike8ABCJ6kL+IXuoowqwQQAHWphWCvR88SUt5yGY0jYimto/t
	 rCGTdrbHlqYuz3yKsQr6SG/5Q4sIh08s36hlmiPgtj4SLW3jNnG7uhw9+rjMA9dt/fluw
	 wZpMEaqOfH/a+WQUQ5h5a+b3oACoxMAmNI6rEhDrMRPjJxXC3R13ox/RsXRh7FeCeQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085787;
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
	bh=uwZer74B3FSqnjya2h5E1HwB/nCu8uIQbBiWuGOQaww=;
	b=VrpUwZetUUhCpEl1hgBT5nXFORm5I+BW9pCKzyeuwd9eKUyY+KRn7t+TDr31OIefzGFt
	 4NrKi4pRDx1ojRphEOuSycsCf9WxExZ7EMQO/URl4IXnUjdrCY6bo0Z1Q3/ckEanEqBZq
	 Q4bCyiFdBZveJEEgjaW26vEZOIfG8tXXOEhsCbZUyT44sVGf3ShttSZib+YMtpPPV5EPv
	 gxtrd9YNdmALOvMQRX8xkzgECePIx4eakIOi+FEFMllPmbHJv2DMP9nRS66uJp5P0giE0
	 CTHzW/tul7nAFYkSShEuC1o9vmwZDVrY77X3Ipa5fDk5Bb6PdGuIKiCZzr0Qv6Jyy+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QKnznI7q;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XuCL9ZUQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E99606A320
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24E99606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QKnznI7q;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XuCL9ZUQ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085787; x=1824621787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=7B/xca5KbvYlxn481rXWoC+zbs/QyC/jsXcKMUOLu0A=;
  b=QKnznI7qLx3EzQeHN7WSDgH7od/3uhpEE3Kgn+R1WUHx620ILt0g3ibZ
   Iq1mJLN0rPm8vzA2fvlqDtkbHq4O2PliuVDyEI6EtZK8I0n3C7qdjwk7E
   UOyYjW1ztlOKlueh/lGvqOQhWMCeuuyRqyzIjPPfYAFw5bD6TOJX3KLh0
   rMRbfao/XMRVVdZHDimmVzeQfPGSb/+e12Xqobwi7aP+UT98Qzy0DvPrf
   x2aYdqE7GaCIizVo4uEuAJUOkyM2pPPDdjOi3f+Fqx0lBCYu2m4XMVj9D
   zkbxzYiRQNS3DTm+9uBBc8nDfm42Yx7/K9Bh/OQmUKrkHQ4Gc0HCAFYgN
   w==;
X-CSE-ConnectionGUID: lapEt96YRfmDjfws1RQeWg==
X-CSE-MsgGUID: GAOGefWcSnuwQNv1n5gx0g==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863275"
Received: from mail-westus3azon11011017.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.17])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P25Lp+1gFInS5cEpDj7x+zaDPcIgutIvbXNkQohu+InlmGSb/tQv8T4rdru6EaLpxNLB8yJpFF8r8xFAgPOS1Z3mBeZqrkp4g9JP6yunLKFJSn2/iI2noY9FL2DcYLiQs634R7J6L0Z/FDm7CYAbDnfdyLBcjP91ZeYvNHfBDDBfRWznuW1Qh8xRI2C2YHgae41SYRn7FtMlHp4J26CPAeEuQ4mGdOhy7bTjEeD5LqC1L92Hb3KZw6idw/iSDZcN7mPrDz20lAy/gwsJuPKrfK0PJrDascvgJvzD1nZJ12/YtDWAqHfMh1cmCWHq/Ib8uVezgy75Pkl/OBsaJnnQwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwZer74B3FSqnjya2h5E1HwB/nCu8uIQbBiWuGOQaww=;
 b=m8ChCzxnV/BxvZUk+Hl7fAbuI50mDS6qXteU56PZ+tHFSByzGmOr2yD3uGH0xiGkasJQKLdm8gJpsqvy8wdHLxeKZpDOPBEkSpKlr6aSP6/Y5S1Zor7YSUImWMqP1QFxJgN8+/y1axMGZbGIbFPt76mmclWe887k6+wFRBg5qdb479LSE5mS8dcn7UMiI5uB1KXYK+5BfkGloE1ovihh2lXk8duOLpn7BuOoqOtP4eHrldvImMFyOY/fM1dC7HBDXZ+bgATA0Il1i8JsyW/MlbBGrnkN1wIReMxa2GDXZShVk5lGRGsxbBaiyHVxSb7d59w5jtaDLr/o4QkFKcfMCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwZer74B3FSqnjya2h5E1HwB/nCu8uIQbBiWuGOQaww=;
 b=XuCL9ZUQQa0ZGFL0D4GKX5Ca6Whv6HIrxmKzFqDZ78JdotUslsnzUzuL/BkXikqrKcCK739clGnUPXrDv32blkx7+whDPIBxSarwDD5nl14LJq8u1JPG0A89JkR5fRBhI0Gp+2INkeORE07Sgi7266iM2SnMQ73u2w/JID+RQYg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:05 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 16/25] btrfs: zoned: don't account superblock zones as available data space
Date: Tue, 27 Oct 2026 08:22:22 +0100
Message-ID: <20261027072232.419318-17-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5ddfa2df-3444-4abb-77eb-08df33fb2499
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003|260925021311599003|260925021911599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	3FA8JtiOqY1YFsTKDjskHxmTJM+DuGm3HC1e8/qKcxxrAiNuoDaJKtLrkJypaUspVDhHPjAVv4FLU8G/sf1Vy3HkkdkqlZMQ4MqTATISQSjNpvzZL1Uh5HgziMg43UuWV4IhT7oaHesKy6WK7C30oY9A8L3/13QE4CsJoLqKur6ndp8MwEtKGDKlwAqMtucLJFPgO8MgiPTdVowFMGir58q5JHKA9mXHZzVMEXtAoheyHR1bh/rmlkzjCcFlyGx1wKV0IXm74Iq09h8XadhEFUiL/CjpevFZah/1FJe+y4f9zAjR2Gdc/qjaCDhJZ1EPmOV9fJwrap3PGA3GDY69Q9/VFqfD8HA66/2CuW64++iHGmN+7Dx2EgNl9emOd4TIkgE+BgTA4v9DG20fkZUFRutPaNv5Fk930cKcJFv9BIid/nToGmAgT8zRzKhjC3wurCaOmX4HZGYBB04cKx8hGEhvu4lXmLLwnR29vQ/Gzh47TgsqB3LcxCDU0zaoA0pFoCUjhDQjm5XaGa0twNgJU6mmHeqJZ9R3rlEWj5JCQrgR+uMJe3kkjpkmOXNbtuRL8bcfhULsp6PTMbi3zmwIv7HnOzHPPQSe2IS3M1TFiiKU/NNuLJL76rOlJ/D+VXfE7YLKCeKuKcgE/GZ9owWfjxJtYlJtx+YK9RmFYVpoXt8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003)(260925021311599003)(260925021911599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gwb0djEpV9qvOYNFu7ZbThbhuKOaHlDWtZWkh6Tin0a61pEJwqNB6kRVbTlr?=
 =?us-ascii?Q?KWmBBTh/4YPdret7vmtVpHmsIRAeCAl3dc1M5PuNXSnnln0OELycWNdMr7mm?=
 =?us-ascii?Q?AtBqluwiE92Sl32jQysLJQCocGGEu1qkoaDloNWAaB+I5rpyt4bhydwTzuZn?=
 =?us-ascii?Q?44BlN93IDEiMfUPtNUqoykmHc3wgiiHmZffb1qwKPhJPqrLIXxUXNVN/WUw5?=
 =?us-ascii?Q?j0LGVNX5y2vXdpoUdS6urljPogUAomtnHcZxzs5bI05LGk5rXYpLSjRLOnT+?=
 =?us-ascii?Q?DVGFZm5VxR6RszAyweQPJ6PLamMmB/OfbpP4rf6H5wKWu6ap6Vn/X8bN/uBy?=
 =?us-ascii?Q?amN+zOkjk8HYVwFG2nHUBGV02BDFtrM9Y8hRQGb2449TdYnloqYxoYbEwUtj?=
 =?us-ascii?Q?8NWxsF+z9NBANwmf67we2FzfzHC617W1BN2NlkBdMlC9Zo0sdsVtnTqXaRBl?=
 =?us-ascii?Q?5fSHV4QOUG/9avyHstbc/OZj4CfqfFcAj1QheEhriWwcfDQGTsvkOnwTFedw?=
 =?us-ascii?Q?f52DBcOwkXk8VyhpGHh5YR8sCPrZVsflkfrn4zWX+cS3D90dKUBO/Qav6ZL+?=
 =?us-ascii?Q?5ZTXMEoOXqVDeePnp/n+dofspIig7DHnZW+O1bkh/b0A8GKgL+CJL6jSGXSO?=
 =?us-ascii?Q?XvImJWEQi6gbbC6y6BDGJ8/hvygYxXe9h3/NQ3EtQpWZK1MBSJnWp6eyqBUu?=
 =?us-ascii?Q?GhY8jWhVJRDkAjINL7z83vtIod1bbIlkWPwVi9kMypUBWGslVAoSMe9qEkOR?=
 =?us-ascii?Q?kvcnDnTjJYiTmK0iSuETKFDU4zz0AndeRLBfczAnTCl6qgxgd1oT8pv5xynO?=
 =?us-ascii?Q?vzLYUkc7yXfHgD7j2REI2CVRWFJYrg8SXjLRUnCDsQqNH5SkYUoCQDMu01OY?=
 =?us-ascii?Q?rwQozIwvJea1ldQU5h6u1D6XwSSbvdl0zi6mcvBFUdcM6NhU17iODxIBXVU8?=
 =?us-ascii?Q?yU8XSk1oyoXGgfoz/wKTwI7ICOn5IHOz4jBiuBE5YiHckYA0F6SWyPD2ZiUp?=
 =?us-ascii?Q?w9Un/cU39oexzRRn/Z+SAgHqyRNqzxryhsM+fWpvG8gEDGmcHYJMK7pK+QjI?=
 =?us-ascii?Q?2gWn7eJOXSaSum6Cy11FrMksXpx0ChWaL5WlpAuGt7tagOXhW+eU1lv9123V?=
 =?us-ascii?Q?mnVe36dpMCuLKwkYQ8zLOkbg0MrRXwiOvUyEW4g43jFOljmUzTZunLn81XWH?=
 =?us-ascii?Q?kERGnv0pfyNvTSNbqCRcunTZlBrRN1Z2P2vCPvbk7QdjDwxyp17zRDvmgorx?=
 =?us-ascii?Q?0rQl9lDm431dEiTA4zetzLxN9pk4PRzadnLlA/R1AOsMbmGofdYAbS9n9Hcy?=
 =?us-ascii?Q?TByMuFvrDIFn5v6Hb27VOCZmlik6vpZJxAXq+uxovAOJRIYJbZbmdrkRDQiv?=
 =?us-ascii?Q?l095762EC1sImz1KTKSUnaXQZNsi7gIuzydvNVE0pkd/MUn0RnDoWxpuIo82?=
 =?us-ascii?Q?aA73aVptNK1dBcpQ3UIjy+vIMjb8OdvIzPzLjEgBj1AUsuPW0Mm8Jy642rt0?=
 =?us-ascii?Q?P9asJGsYtsT0Gz27Q76pW1Ix5trSdR1GzP6fWeoxSFrWJbKdTXYEHGZizfbe?=
 =?us-ascii?Q?EUDI3pRzE/MBWxh1o7ugf5hHpL32zu/NHGtnzTbZenl+kAEg8aE6J0ehc5gi?=
 =?us-ascii?Q?XFPBz3ldhIP/FP/wKz2l5MctgHOlynqFkMPchD7M2Z31PYIHowZlAlN6PUYW?=
 =?us-ascii?Q?xM1nQ+lZLYrlVzaQ6aHeyG9i7BFXFUvUljT4J2hprWMfesn6Y8QBu7lsPbuC?=
 =?us-ascii?Q?1QvvLNSLYUGo7FncsE/lwCQI1BoEQbVRzW43dVeh3IStYzoU0Q0o3xTiRR/s?=
X-MS-Exchange-AntiSpam-MessageData-1: B9pn58WBwWQy+BT0B9obSCRzSiqBMfASCyM=
X-Exchange-RoutingPolicyChecked:
	QEhr6uOddlBed9EsRnXLMEEwlc+iHVFd731w2rp2xBqixM2i+8k3l1MC9PwKZ6oAW7ty3YiZb0iIml7Q/Qgc80JPj75rIWO75+o9gcoySKBwA7iHYLidiq/xFQQrLiD1zEE5D/acxH5FfEhBW2JsGG++MXQw9C4AWOEiGuRQPJMnNX8jvXiRLTxHugEsJKN2ruiM+jTG7oZ/tUYqcHx6zQ9LzirwLINgFEs+Ir3R2SiX4b5dsVKonV1bE6DZmpK1AINL87K+FnFNO/W1Ncwj4NcDf6SB1WSl1cKM20b4qyg6TVzhZXgnp0Z7tpuoLEzAwYdp/ZhY9fFwz16snfNAtA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sRYFWQOhYlWsPxESTPRQgnwh6oaz/hA+G/7cwQUjNbcKwBGabhIOB87zG5zErcwmGV8d1dDGdVKbFSAHnRqLgEnsJw0AKHeSEICVW8o2CxYyCNF0YADFXQMsyktUhGmdlLkaiJaVaZSWNPI+MEzjPZngkDubFqPycX2r3rJ3FGudt0QhGf3/YJUTLN9Hdcsc6OCKPEgqvhT6Q1MuHLeMMF3dPk8xgyeZPHAEZ3ZYl4dK5kMIcCPA7vmsp3DQR0RPcNZl8ZEmvKSYVpdUrdEaLme2RLy/L25pwerMFKWfLjr2ruYisy737o2gRQajkJ2XgvK3p7B1e/u6Tls3utbJ6qv/gwCmrv11tfpDLHEq4yuAwi2H2/78i8U+Mz0CWJ4vSUh8u1tnD5Iqq2I+tzoFkU0R+RDgiXG/TXyIc4jRKE9OWxicWUp0zsIH8vK+PLyiCgM75AKHx/JtDwkgrNaJHh4Vn5xZzNOYbRZoPV9lnujWeIgyu8dUSxywJMKrhdxD7yazaRN8WbDIZCmcNLI9OQowgBeY5hvtv+L7Yd+jSStp6DjQrpc2F4pdo8G6yRsDzF1cGlh+PNw1F5x3mNT1zjFYS7wHZ8p9yigEvcXvrrICxnBTLRTT0h0uRWQ42jwl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddfa2df-3444-4abb-77eb-08df33fb2499
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:05.4479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAQ59cs/Lw/gXAiRJSxJ7lKSClT77IhQQPBmKzm5fkPXZ0+ZGVEZfgzkll+U3Uzfg2DLgZTQBfu0U6qFRQGz3j6MZZraoprPE0iqTcsGtI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

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
index 1569d771a0a6..242d90c176cc 100644
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

