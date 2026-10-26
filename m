Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031011;
	b=PA2h5bijaX/POnI8oBD8EMRgf71/CT1fDjGkzQWALcZCi+ADm/6fPXFXgayzV2gpH44e
	 WrHCtR+WRep4bznhkqoGAkR59M18yQUkBgJfQTmxKDpVj6vARD3W3Ci1vHOoq8BySuKiM
	 hoOeCbGUyhS+kUdEo7oDsR2gOFfEa3mf2Lyx6/yJlVDVZFX1FOp24/+j8/Et32DY0ZXVz
	 JhDC5F2cv2TJuLzK+mlohYJUNK2WpNrqoJtsfs1Cr+dnzzw0t+XRk6k55euTJBL3RJ5oA
	 2fhSRS5llYqKzK04rMXP0HDZFzFB+Ca6Q9kKxb1NePuX4SthlANf4vmc2np7S52vfMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031011;
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
	bh=WonsSo1CqF7jutiyd4cUfHcttUPKc3E6BHswm4VmO7Q=;
	b=cL1TIxJZO6Xm4twcDFpIxlB33CvrPrCsgDsp+gX0TeubY0wryXl9AKxkxg1iea0Z/DkM
	 x4AwEprzX6hP70Jt6OwWjzrG8JN660QiK8VIMFcyRjZbmYD51vUaL+KfK8YxyAXqSpJFl
	 VZbAdF32h8mtxLI26/jbf7wvSVeczqUZ7vOnSKvpm3CnDF3ZGK+Kd99r/NUqqPyJFulRy
	 ypBObhT1vlIsKvw1VinCzxGxhUK/JSXH1msPc2fS9kG1oqVblk6ZchzIKZHPGYv0H6Lyi
	 7RrTGrryherNvbyE3fXUOJD3f0+yX+ATwGanV9b3a8JqhJHGuruyjdnY3ZOxPV1Xr4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=M+WY1Jx3;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=pDfM4FaQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC8460A2610
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FC8460A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=M+WY1Jx3;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=pDfM4FaQ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031011; x=1824567011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=VX3BotDZxIu1/VwZ2DphFxFklbgEpEP1GE3PzOy7jSI=;
  b=M+WY1Jx3vFtqFKkhM3Ymrze/N7KusuzG4CvZ1AUFkydjGoSMQE4sZe7H
   Vd5xHi637RJwpWfK0JT73qnuwMNbgTywIMn/5KK1txr1LPIjZ7ZzjAusB
   rHchE8PMETfMBS/NLxMYOKNkBE946vx2RmpwYCWvvzHrtX/GEnCI72MX2
   A7fXEfgQoxWo+ub05wZhwS9H+6QFAHJoumY1ZWpyMfEdCNdqnArO9Dd5K
   8tPt8ql4uN0De8FCspmRuRF2RxGIjjrr5rU1hlY5sn+hwETyTL38Nq3NR
   V3rEd4W24JXORziYdvIRx1+iCX7SP/GwNkyGns33Qukd7Y5roKKLY37Rq
   Q==;
X-CSE-ConnectionGUID: S+2tKMp7ScayMALaDDxiAA==
X-CSE-MsgGUID: 362hTmdcT0Svh/osrUG/Sw==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033915"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HwrFHEAncrsxmT7VUwF+Tg/ATiz4AcA2mphs5r2Kepy80LGFexBve9D59ayaBEe3kx14SsuPzxlzY+lQjwLvIhhNS1Gfy4FY/Ze65fVENUexJJDPRtmTxWK8UAo/eyhUXh7pVl7oQXTdCWuXWkWHH/6eUONdSUw2J0g+Q/RkFbXu+/H0xHw8DyTF/PTbZfFEq9EfFV4TU9SW/r7FF9OWuOQ9JanDUGWhZqEMM+dDT7c0PbX7le+rtuVwTfM8QyqSeOMmBtfwcly/88NEkGzWrLLEZCCTW8VZglG/sbLLK22ZztamsSvANlmneBaQ6ntw9CKi2TEV10JANcAl9dyD1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WonsSo1CqF7jutiyd4cUfHcttUPKc3E6BHswm4VmO7Q=;
 b=t8TLNdCzqnxPQxaLBZN0W9DcEyw3AqFbIyDEu1hw51xs8EW1UOxhabIuS6vr1WLAkBzzGb5eFS+bXF0sobjYPp8oepvb21tAn6UaT+FuYxr14YNFInWnjpGN6c2ICAinoIOB9LpkuYLbDkpRQWAzS7szw+YlvJDSrai+WDat3BfN8Mdtxi+SWhLYQlkN1FZk00c2rxCVbu7lzkCCqaOUYFHOU/YEU7m5XrcflJ5P/FM4r9taL4nhZgFGUTZrZ0D0I+3Rkn9Het1ALyp+7VTzL3nS6e3Ci/DjH+an4Vp8OUaoCqpY/ejcufFPMwRK+ihmSzMsRjNIN1FnF6Rhivkx2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WonsSo1CqF7jutiyd4cUfHcttUPKc3E6BHswm4VmO7Q=;
 b=pDfM4FaQiP5oHcc4VO+I/FjmJsv4dBYI0cef5z1mvJyp2JotTHWk0zUcY8Xyu5150r+hiHXfUnV1r8cRnqWw0kj1/Qn0anbosS41WBw80Abx/G8ht5bQPbNON5S3hJb+Xe1tzpccGfECC6gBWJ1T/WcD77hpUbR0d5yKTDBuMWQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:59 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 20/25] btrfs: zoned: return finished relocation block groups to the data space_info
Date: Mon, 26 Oct 2026 17:09:08 +0100
Message-ID: <20261026160913.207909-21-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 67c07dd8-9c44-4cb8-b16e-08df337b93d5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yp2rtWwM0liNKpLxqtMGVlJEwUMk6heLoXhjbyIUBWGPI7/xj13rNufBJzThQ6HTyziMWBieoXBrdthLm0N/CCR5STCEpRZZApf/Dzmv2pEtQXgqgtXMAh2OjCB8SXLNsHdtcEBbgvzadKzg2HTqJQo974Y8lgFY/dCctriENZ2LEYpHKpzL64ygMr9qg0vQaqidgCchnAA9NrZmQ1QS7wjRs7AfF3AiKQvgSXuVgN8LrgcVXQDcDn4TK5xasyWjswe+rNRB7Tt4k4DTEovruUPvUMewyiDzxw++/K0i7q1jNtzJjRosaM6EokkxcK9cwpjLiM8QzGwi91XIzdqZWH45k08XMOe7dpxiKPAN5rLXcCfw3kvcH0ayZlObe+X9E/yT5CBXm7fhWFiDiKufBMWThX31e7kW1FYBFFq4QDxwCG8cPue9CRMGfFyL7pt5rs4Y/9/cEUu5qIs59waoz2MtlKZp1Y+6IQQ/N4ZoZGPqAxe9jv5PyNDNwkZtkDrxiZwEispZc1uZmgE2v9dRbXwHnnEOhSR8G11//iDLxspSs4fpnEhoiQlsM46uEMfZCynBbTo8NMHcBSShsiQiA2RkKLt4v8tHeCpe6FAxKudkL9B1KoM6iNGDtWhkGnD9w1vfsqEP/DsRKsBq9ZuvGIxc5eFbAPAk87WfIu+DPns=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eG60ueVYrDS/vu6uXhV156k3+QjlPmOcqDpxFTQzTlebzRJlwNOtvAAk3fOt?=
 =?us-ascii?Q?5XFhuu/dmD4zDNIo178vc/ZNLgBGVUImUZMNu/a+XKm48EaFOMfltT32Yrfp?=
 =?us-ascii?Q?o4wpblEUhobHRVZdO50zWC9RrPB/oYJtEZ/6Zy3c7/L5fdk3Kzz4hRVoejPT?=
 =?us-ascii?Q?6yFNQL2orJmifyYlqZAwYA9ks3XjSDVcaxOSMH6kXsTr6osMlLE+DXpyNgNe?=
 =?us-ascii?Q?z3bysI/fUaoHg2YxrVvLgo5sruhlQ8b7SaZVfcNgJlo7hUjbVILp1tzVL5sR?=
 =?us-ascii?Q?yElNEdskaFwJa8TimcASN1XyYGJlWbdTIKwOOP7ATLJponEEAb/MelT9GXOA?=
 =?us-ascii?Q?FoxI2+t065MtBxafVWJj2m3LpcDes8X0fLmy7FwyBOJO/8WrFtyJRAFlHW3a?=
 =?us-ascii?Q?MrxbhDLvEfBA6crvrVQRMv+1ozM3ed9otYyMYHG+74Eam08dllueYLXcihlC?=
 =?us-ascii?Q?O3zfDl+WpMO90wSAOZlzWxexDVH9q16Q72XGdy9r4lRHU90I01uDJ6JqUfCA?=
 =?us-ascii?Q?MQ/WFHrXZV3qkmLYEbtDrPGS3cUrg4tuHEJTSIE8Xotvy/R4TR9E0SHT8gcb?=
 =?us-ascii?Q?USYVJkZ/XRlUSRj6qY1n3UZCxqmUme8IpNe2LxvDA4KmlKmxJFackPS8WE0O?=
 =?us-ascii?Q?7c7lxRqY4e/E5UwvkHrEDfLa5de9xArJuiT8Q5YnuAAdS77aY1+9prEPgCaS?=
 =?us-ascii?Q?Y4IYGy0TN2mM5QRAg/PcO2UztDgq8+yQLa1smBRjYp25GWR3Cs/hjapBh2HV?=
 =?us-ascii?Q?AhGe+3rwknF1sWhLF8fv+4O3YwyV0Pojjfgg7sB7NC7a28MwPYEr1GMB1HIh?=
 =?us-ascii?Q?Gy2QMbh3FhCgMnNUGC50I6QIGJPttUIdb1exsdvImz5oIMhxgBTHHnQg9BkT?=
 =?us-ascii?Q?xYn+hz5ti0sebHbssYq2iMFjZVOrokWZZ/LCbPTo/nzmKp8unHaN4DSHBDjY?=
 =?us-ascii?Q?AsM1kOtiChqZg2F0RFk/6q6PgvkJwSPNSw3PTsWcoJXRBOznbRR8zANYK+kd?=
 =?us-ascii?Q?lbr7IYoSKBovwLN12VsF7nU9fhWrpg27Sow6BnetfOp6dWz9tnhhOkt0LaVt?=
 =?us-ascii?Q?lYkd/9t78527VAdl5WVTcuKNcvdCWkxQOhoDUk81aHPnqrRZz7xuIAHFPFcC?=
 =?us-ascii?Q?gQ7+xvOQOu7nhELsIek5qIC7ToJPvOsIHU3q8J4HdrZIW1J45v3robi9L1/I?=
 =?us-ascii?Q?H8StYn/CUL+KPqT13be2ED5ZF3Xnva0Fe1Sz87tA2V0T9+tx60XUmFyzL93b?=
 =?us-ascii?Q?coMwEHBSX5xvY1X8ajLZEa4eXzxrZdZ/mOsOJDE2fcsF8eKNDqtRu3XOKcb3?=
 =?us-ascii?Q?ALP5Atevk9cKPRKQBh3FXJ/r6cef1g+xxbeeHhvvdNcVFJ8Vk4pwyndhCzeK?=
 =?us-ascii?Q?nzNlIR6fXlv4l9t+5Cw4aH6U1/mOhoz8zT7AZGWmCVnijPGE87yWOeXcEEp0?=
 =?us-ascii?Q?NULw0d2f3gWcUvEDcsAsY1VX02tddlYPTkimgU29LdqDTA665B6WpUbkaY0Q?=
 =?us-ascii?Q?ijs369odb44MfSXgv9Wd/YmGkyPKOgkVasy/sUIJAzgaXEsdmy5M8QDi69nn?=
 =?us-ascii?Q?WJWsmAAGyybcNxoEiszvJUYcyWRZV5XJH+IcedPRlFNTQ17BZYhTWXV4NlEh?=
 =?us-ascii?Q?GcCytHcCoZP6uapLetjmJDh2fdkfM3V2EhLS54AFu/XmSEuW1Tbez59RsFld?=
 =?us-ascii?Q?eNY9Qhq3Tp7hJtF2MQ5X62zcYc25Kx16wTvlqSBxj8J2iS2AnR4o+9x0NfvC?=
 =?us-ascii?Q?WPqB7ika52NnLF9WxDpLSKnLw/oqQezp2xJ03mBgABHOwaEnJ6A3+wWs3h7m?=
X-MS-Exchange-AntiSpam-MessageData-1: Zr5cSSImklidYg==
X-Exchange-RoutingPolicyChecked:
	ihkMWzC3xt2zT+RMlpZCzDPGT/8nbd1iuJG3lY6s5jB2W1vvKEHhycguD+EvRRaCrVk48j3KnP0hYOpkjWKkHl4iDSWohpK6GOugMUelYmSKGeCRv0v5HYTqq20mWm3gAcI5DAhz+YogngR7nWm0enwaOyBcbxUbNZxuUWB/iAch50XXt+f3NoKKu9zFs3emFt02/y+5bu5DIl2OpZoB1WodQE9bVvzun0Sjn2Vmxxt5vumL1Ua3C0CHDK60Q/iTpB79yPEW8YcQMMIYFM6cXkknin4DNszs8Ca/M/yoJ/mAUQdKiXUCGXInK+yxMBgxevIaUUvNejlP5uPmOFUkgQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oIh03CD7DKJsXunMa7NdTZSzVVEbuxyX+5PJdpXTLhb0oO4+3I2mJfMRBF+6zorbCqLXHxwuOwwMKmwnH5WVrrvjqdbs782XOgdILF6PSks0Pxs7a5WGVrnqxvNKpsoRG9YnxunqgTnd9dZKJgJ9D1saImCLG2Yy9e6En25rXcEjh5cOQxjoVb887QIKDGLm98RYGoa/JLKQxtJeE7kVpgwZyr5MyttJSSRrMAfkNN4iB6AxSzXAXHoOzWrcfX+Gvv6gjNfoXEiHnVyPF5ODS3+wriBalLBEYdEnbzW9GOk1GzrrOpkbJw6H5LSkvSMrdwWdgvb9v04YqkXQkeWbfODZtzeAdeQp3OiFMWi7f8H00EDyktMGqmVl3MA3NCq3n7HIr3wu3KFf59JId+hyFYld4oEujL/U3A0FgHlZc3mk6lvC1YWcZVuuF8q7N0G0qukP4xlrK5hJSQAGu5/oFwhxA6C5cDYXdwxpNnSyPdYafy1bFx+3C8ENTPKwITIfSekC4NFZ04QtHwLK91/S1HbRflSJHl1RFnRa/6MUtAFrYWc6jixS4gcP5HSyaBYPdHkL72kk7Lw6FzYuA2d3YEw5718L4ssnf7+GusGmIK0EmKm8BVbFye6hL6kZ8zXm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c07dd8-9c44-4cb8-b16e-08df337b93d5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:56.7111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZejO0P/rEWZYuEDStN16oQNGHCFGtpH/z4p/JLbXneHxTrEpHDXiVoKQG8v2LRICSbi4tX1cmR+gfEg88Hd/uJM/obYADdwZW+6g7S3FoQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

On a zoned filesystem, the dedicated data relocation block group lives
in the data relocation sub space_info. Once it is no longer the
relocation target, it stays there, so filled relocation block groups
accumulate and their space is never available to regular data again.

After each block group reclaim run, move the relocation block groups
that are no longer the target and are quiescent back to the primary data
space_info, and reserve a new data relocation block group if needed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 ++++
 fs/btrfs/zoned.c       | 48 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  3 +++
 3 files changed, 55 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 4878a2377de9..195d299c8401 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2161,6 +2161,10 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	spin_lock(&fs_info->unused_bgs_lock);
 	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
+
+	btrfs_zoned_return_data_reloc_bgs(fs_info);
+	btrfs_zoned_reserve_data_reloc_bg(fs_info);
+
 	btrfs_exclop_finish(fs_info);
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 181b8caad2fc..7c28527f8b59 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3139,6 +3139,54 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
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
+
+		down_write(&reloc_sinfo->groups_sem);
+		list_for_each_entry(bg, &reloc_sinfo->block_groups[raid], list) {
+			spin_lock(&bg->lock);
+			/*
+			 * Only return block groups that are no longer the active
+			 * relocation destination and are quiescent (no in-flight
+			 * reservations or pinned extents), so the accounting
+			 * transfer is exact.
+			 */
+			if (!bg->ro && !bg->reserved && !bg->pinned &&
+			    bg->start != READ_ONCE(fs_info->data_reloc_bg)) {
+				found = bg;
+				btrfs_get_block_group(bg);
+				list_del_init(&bg->list);
+				clear_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
+					  &bg->runtime_flags);
+				spin_unlock(&bg->lock);
+				break;
+			}
+			spin_unlock(&bg->lock);
+		}
+		up_write(&reloc_sinfo->groups_sem);
+
+		if (found) {
+			zoned_move_bg_to_space_info(fs_info, found, data_sinfo);
+			btrfs_put_block_group(found);
+			goto again;
+		}
+	}
+}
+
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 20180934aff6..31d1fcb6303d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -105,6 +105,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -291,6 +292,8 @@ static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info) { }
 
+static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.0

