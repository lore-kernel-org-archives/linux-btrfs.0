Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031025;
	b=hw1L0t/xGOwwzW6c8oFlvm/1MsiQeDcNmwDNBTZOwP2XDEl0v2cgsbQjrmIRPWYxo+Fc
	 kaxpYZEJEkT8C0MuA2aJROaOekUqM//4wx1rXIKX+N19WZfboswF5STwbV0wRtv2Ws2By
	 ump6nIKnuXpvpvJFzrd6fs4pdJ7nsSknbKvJbfEPVRMa5Ek/n/OPgsPRp7mtsqMdUSuiJ
	 eMmxtKvMDIcKpYBw7/vtB9nWk+osmDQOZWQrHrCdtgirDPWrpoPiFyedXcjZN7UPkOFMd
	 B+TQlc2/mEd3dTwJhdHk9h2CL7Y36F+ZmMHXzjV4wGiUgZnNhsZocHR6PD3utNAjbSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031025;
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
	bh=f70JuDIQp08KtKOAXlrB8okarmHhUPnNzOS//mzbHPw=;
	b=zbcJr6t6WaJB0aQvZoMtfUqRC2pgTv9ekmmQ8LDijEFfb716561k+wbqDLCjspWEoM4G
	 J6TjKAT8/12n8LhpfMtgNyn/48RJUqwdcLTJr1VoT5HpbG24+uLDJXc9+RMHd5jXcHZJi
	 GK5fgaAaVPAh6ZwwwpDZ50Px17BlFYBfB4VUOauaXu0JZaA8VQ8gGohXn26WWtUUCQ/oU
	 nHj5JqR15licr2W5Mz4s8mDvjvT0gx3MJM9NJtN/g69jkJAVNT2YWW23bTuzapskW/Lk8
	 Drn4quGebNvYAZObv/SDC6wyjG9RAeyvyyhPqTVBII4j/fFr5XMcWiB5rr0P740v4ow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BOioXHsf;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=z8QsLdip;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D48F606A33E
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D48F606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BOioXHsf;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=z8QsLdip
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031025; x=1824567025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=74Tpq1YUbMtLwQ7ppzbt6MXun8zfzBjQA9AY8lCUoFI=;
  b=BOioXHsfbSLdqApNctU6frpErIX1aTJsRTwvrp8r6h53YFfYduCRkixM
   awKvIBfshAdfsqUCGRcjwMpNX0TIWa0j9e+KMCav/3nZ4DVhZpFSkWRqm
   IwyxUH3dNJYTx0DGwrlQ3NiVQzjrc9H0k3AH9YwKKNOu5QWg560RFAsGN
   hv4HiCuj4dHcuK0tzmlWONHTcw0GtJI73hCZjrBqYIxzP8H1iIRlTMBkp
   6T5IVwFu0WlCD9FxGtaqm1MFEHmL5Jt8yvUZndzxFe4DCs5ACOs65iW62
   rRNwwjVPO97zjEQveM6AeET33fhVW1dgtMna+sTkSHg8TfGdXRoW11zCn
   A==;
X-CSE-ConnectionGUID: SwQgNryyRAyh4MB5J0c77Q==
X-CSE-MsgGUID: bgz1d1sdSHe/jXqKWhB8UA==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158929291"
Received: from mail-westcentralusazon11010070.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MpQmvshAobvDuRVq7IDjL7CNc2qy3n7SFjLb9Y9hYxyyj6JSXNtIuyooVcVapMHXG2F7eTWlpsuInPAJJX6SqL4uWAvM8RF8pohNk6CY/WOIJvxIwCb3OOPK6hm71XhMiNzXI7ea266ZYRwblJFmNH0gKYkpQaL3ER3wCxo5X5h3fExRekugQnI5E/usnM4FZexw1FoQhT00GlhDwEVx96RZdTL1REA5OIL7TjpK0q/mzUW3thaC5LvYqygul/1dbWxzWuYw+1Xj/okAYVkM6+tpsoXiiPTnu/ErqqU74RRDnvs/zH5MQYD/RE/j2bgv8TA5L9ilBlY62EbeGzjNnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f70JuDIQp08KtKOAXlrB8okarmHhUPnNzOS//mzbHPw=;
 b=RP9lKpt0xq+42a1yMLxygS5dUZhZnR924w2dlTi4wWIlNVj8jzZK7vsDzY5MoBU6iy/6RBatLBVDNUpOCzzh3U5NHq3/hm+W0Y9dDDkY6lUqpkQCNLiWAV0RNHC+HfbzQdYLlvgfdwb9L9knd5wsKGly+tprEnmcLysQdIpUKVYbqFlfdD9HSudSpRj0na4No+zI/5icOFpdLPSRw3bDFhS0GfpOkRS6pLwgvD78815GWX0ePolJXbjidYwFUpMkBNGjNnV+oRvIksgE7VaXLUHGKY3gwqzt8JxL63jJvXfny0hz8jcniAbRdcCUIs3A83QB2LFCbkhNYRW6olQN8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f70JuDIQp08KtKOAXlrB8okarmHhUPnNzOS//mzbHPw=;
 b=z8QsLdipf7di+4LZSbaQvtHumbATy56CXDLH5PccFgDftNN6PuN/0o5Ybl6C7vr5BK8go4sz76rCx9WZUNPJVfiYd5UxzVg81AE8BGJT176UP19ULJupBU7pZOHyZrmQ4Hpo8dXN+46y0NKvUbGeI/9BWdS15r7oPahB7uPSk18=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:10:03 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:10:03 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 25/25] btrfs: zoned: provide zoned specific reclaim sweep
Date: Mon, 26 Oct 2026 17:09:13 +0100
Message-ID: <20261026160913.207909-26-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2eb50264-542b-42f9-f838-08df337b97df
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|5023799004|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ciy4sH3HIH8gS34Tc1TUIvK4XeBe+1JZQGm0HTbK4kMtdtu4Qf2dWJnzz0nMoQiqCDGyIIWgLYQlmjk9WSI0UFDUPO3ZX/TBdYbjiTttpj08Fzjpb5Se2SkIGwzSsVPdxwbci2vpLTCnuN46rT46dWOKUuf5n8mqC9J7c8ncrC90rPJZBCg+o/W4zg9Ss+PCiblWZ6WHJZQJcVBJAgX4VuR/pqkCRY65Zg+X/wnQ4O2MCOc0IF82SwMvuvqdkLz95z+PC3ATCGd9tuShnTgWLtKO6tzIM1V5f08thfxy3uLX6C7/UrkwI1QfmvFeTdEmQnfCnsluWAUSO9G6pGP0Xlu8pg4LQHQD6NOSfkompWHGQzYGxwI0nfeqfUnTOJEsV7wMcLOE2iuCRFGzST8PpgeGkjv7fHBidEt7RI6DHZpDcw5D4bziRn0qKi9yYa8370IMa7UJ6LM/b4AVnqYMuIuUphm43KPlROCYuiLhNMML/YucntHflGENJ5UN36/4D0ktq0dPh9XCAOVEwIsy7oxDu7aIksqjoT/xfmNqGDir4lI8FQqjUSumhgl3f+7hCKaNPlOQFIwMzj1bLZkVQ+yN7r0AIB/t6D916iCAq0YmrndVSU1er6WNyZGjKQtNptXMdsms4aWUow2gQZjEcIf41GZfkWe3K0gGDXrHR0E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(5023799004)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mYIy6Ivm8OqgZLKGj129iq10cLDUXPCo3RE9Go3NMwlPfQE/lCBIOzYj+rO1?=
 =?us-ascii?Q?5pLhGd8MypH2uoFEsFV4NDM64xPem08qTwxPTmem5pYMV70s+xy2p64vvsNI?=
 =?us-ascii?Q?ftwCq5JdjLTuFLmjzuCUArYMfJetvUwE1B6f3vZ/JOgmlrmUZEc/co72epNK?=
 =?us-ascii?Q?h+DyGVQJKBYHj97GK5BelqomnZsKJ2kGeXKdkbCIalIil2HMDYs0ResJSFpa?=
 =?us-ascii?Q?YxTNV2lzVHwmG+QGYoeiy3L/sKvGAjFWSaCa/FrY1rH8X+NDJWgkM0cnp5D0?=
 =?us-ascii?Q?ci6e1zUvX/61PbziYXCikv8QdvGJa+U3RSxUwo4xNyHNnhGxa7TELxbb3HF5?=
 =?us-ascii?Q?nWlvDyQZjJC70+5nqW1uTKW6jeL19JUq2mWWk29jzJTxzF0kDkIHVKOWe8el?=
 =?us-ascii?Q?xp6zidJZWL/AzA7bSYt3R4N7+0HqNn9Mrqz+cVZiOqDn6NsnpgmLGtt9YJUK?=
 =?us-ascii?Q?8SADwUQcgG5zZ1h+1Ij0JnAYHLNem57rwyk2iZ7osjIZsmec7g9xAoQS1zOu?=
 =?us-ascii?Q?kDA0ud2COc4rMEI1zqtG/OgdDXKJMjXWYDRgizG/w9RY55QqPCKCOxVbIDou?=
 =?us-ascii?Q?Ta3O2sR7/61LHsPuz+A6BdzGVuvEd7Y23/8e3NDI8Os43HpAA0s8906Ux+0u?=
 =?us-ascii?Q?L3hqq25d7326ZcUsoUSEwhGGMRTytE1Tx0754exGtwe8WB53vLb347mQhrqL?=
 =?us-ascii?Q?B3KIafO9g2HA6gffvvVbCHXmypI/Yv73abh2HJcDQ/n2Y6Z6dMRGiaskW9We?=
 =?us-ascii?Q?sqKxii4rocRjVywTOe6m5m0rLQM5+eTa6jfhGc5t/5TeV7snAtt0lYhDH7SN?=
 =?us-ascii?Q?thjsQHJejuBwsB8EBsxoQBfReRLBUNzU5Jw2+n4Q4ZLHIGAw6MK6SyijoyXE?=
 =?us-ascii?Q?Dh//2OcwyX7tJrCj7KjGwcB+57MnMTvFiuGKYvGgNuuZ8pyDzxDBwd4Xf5N3?=
 =?us-ascii?Q?p2PDmkKoy1KSxCUtoc0G/WFM4HxMGD1wRLjtrhlgHhJlbPE8EgaDWsbJ1wxi?=
 =?us-ascii?Q?vA/nfcRwiqSEk+cymDq5n1bhyml7btwcAh9Cl0CHe40TePvpv9nowAYV5nKn?=
 =?us-ascii?Q?RrgSDvVHGTmwb8iWhEhZCPXP9UG1Go3Zawp5ZdqkvVZkBXwehvvflWCTFt9A?=
 =?us-ascii?Q?wPpt24S/fRKxl87Zw5HNFtZU5MBJmIqI1/AeWRWKtlbKC+Mrdkv5NGZGHf/H?=
 =?us-ascii?Q?HopCDz+uZU2pLRVt+E12TtanM+Z8DA1ynUN0XNmMOSV/yp8KR95T2rbGedjb?=
 =?us-ascii?Q?rqzOncPLyuil0QlfagBvgv2xwC3jrsR3h9IHWYOqyMcdsA9juP0SFrEjrcyq?=
 =?us-ascii?Q?yX7wyPlx5khOTN3mFEZxeloMixVJ2p7esvfANHqJ7tgUuLCMMhOXqk2Fslhz?=
 =?us-ascii?Q?1DvJQd3bW3jb3J7Umw3moUMO4Y9ospGDJR0MZbgwSGT6Ogb+k/Js5QpPhUzT?=
 =?us-ascii?Q?vH7pTA6Uq4yRfmFRfbnaebOvB61tbut2IoTu9BevPvPRJN9SIPmrj4tSSO30?=
 =?us-ascii?Q?oLihOyT3I60Xi5wyCfLAD2Fwfei7DZXNeOXMKOH5DtWH8QfFnuVXFQPYlIpy?=
 =?us-ascii?Q?+MOmwKjq+JdCCEs1+TWjXIOf9jkkF9pObEkTvVhBPZ+qs5mYRJ+dzjWn+363?=
 =?us-ascii?Q?3DAy4fjVVapq7A1EYkHzv9GQDj9ko7NJhexZ0LZ8P3k2CXbN79QbPi83b3wp?=
 =?us-ascii?Q?ynaxVC9/r8fh13oO9gAX0DP2DSYjOtdXxeSzYWOHYxzY1UwM939Du9IoM99N?=
 =?us-ascii?Q?pC+rSpNGKL4nP6kFUYsW+RHbPR9xffmyo4K/bG1Fl0oYJEuvuhZEDMch8Dfh?=
X-MS-Exchange-AntiSpam-MessageData-1: +5sf28+MrmA6rA==
X-Exchange-RoutingPolicyChecked:
	CYzAw/QF9PfRSaigSlguT7olVihqDtOX0XAxPgeH0HO+yhZtYuWrZ8mfNZWO1ruShby+DulFE86G+Lvq6ADyTSx5rOEuht0EWHM12fdlWe7la5Ipktdbn4Xv4aKm4mz2sx6WSEqBoAeiCoShf7bzE5iIIPL3PEVNsiarXoZsmF8xsxMQVdI3wHZrNzB7+mmbtzE40vQX+f0LvfqZWC6yaRVepLpTtbE/NXmYQZd1XqnangwM8BN/a0eTXZ7807I7sTl5MtFUx1quSlGJdknlEeQhgc6pdtL65Z532ZStnCaeKRGuucTxNDCLg1obDreX2qnq+6IBQ9FNzIWksf+PZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NDwLDfbR/ieV1U0Yd3WrWfu3nE9BfujizPkEW02XUo3Xu75lBkovZ+LsatH0F9DYBA6aiicrMeNed/cdbG3XuGff7oimemH0wGGcdE4qXZ/pi97PgJAJ/j/tKd/iDY1TuhJH7cgcPLrpoOzhUIckRjPX3dw4FdDRpxBHy+UmmVWirPg1JhT1g+CsRMDYoU2UBEJ/Ue8ffJAd/1Z3JroezNCGT0wFOuVlFrgdceaGhpC2dzxcHfivwAPTSJ1eraHHDe8UAejIY/rMpJWos+H+LBbwVuDsP0ka83mWSXeJCxVuHk4I61Jg8F2abPXvwCCHpjtF77qm7bCVjlbM1SycfSCXJcLQyJ6V/saSIBUJ8mqArkwJrd4eCtKp5enwTPM5CX9MG3MSd9xS7pP2JkFsgVO/wSKM+FUTY6N+WbvX9Fx+qOLH9p46hKF2pzWo+HtZXzS3wNmj1MajyvaVwIzAQeTCBgd3NE6SstnnVBPBgADc1CUXPFcnGGl72Tq97Hw+IqTCcb8290s6NoUtSYtcN/w+pNT7h7I5NE+4z+vYZGsc/R/WNmATVCYvR1LPnP4M6Nut2MuT7B4JpBST1S1EkIWszScqEo87YjIf0YPLhO2TyTJCigMgZKU+QgWUobZm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb50264-542b-42f9-f838-08df337b97df
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:10:03.4499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zO+w18fc8f7TVlX5B/U9M7Do3Lq2iOq6F7LSx1fpk6VsN9m+Q0R3hXGE+41ebaAGaZUXTH6uEbkOsZVtaOL3L2EfQtl/t69FMk0GHkSM/x8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

The RECLAIM_ZONES flush state calls btrfs_reclaim_sweep() to find
victims for garbage collection. That sweep does nothing unless periodic
reclaim is enabled for the space_info, which it isn't by default. And
even when it is enabled, it only queues a block-group the second time a
sweep sees it below the reclaim threshold.

Apart from that, block-groups only get queued for reclaim when their
usage drops below the threshold while space is freed. Block-groups that
were already below it, or whose garbage comes from many small frees
spread over the filesystem, are never picked. With data tickets waiting
for space, RECLAIM_ZONES then relocates nothing and fails the tickets,
although relocation could recover zone_unusable space.

Replace the call in RECLAIM_ZONES with btrfs_zoned_reclaim_sweep(),
which:

- queues every full data block-group below the reclaim threshold,
- then adds the full block-groups with the most garbage, until the
  queued garbage adds up to two zones. As soon as the data relocation
  block-group fills up, relocation uses the zone kept free for it, and
  the waiting writer needs another zone on top before a new data chunk
  may be allocated,
- also considers the block-groups of the data relocation sub-group, as
  relocated data turns into garbage there as well.

The periodic sweep keeps running from the cleaner, adding an additional
layer of garbage collection.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c |   2 +-
 fs/btrfs/zoned.c      | 125 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h      |   3 +
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 77a133ea6d5a..e13b134c66f3 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -917,7 +917,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
 			flush_work(&fs_info->reclaim_bgs_work);
-			btrfs_reclaim_sweep(fs_info);
+			btrfs_zoned_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
 						   BTRFS_ZONED_SYNC_RECLAIM_BATCH);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 36865426432d..b751ab883463 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -6,6 +6,7 @@
 #include <linux/sched/mm.h>
 #include <linux/atomic.h>
 #include <linux/vmalloc.h>
+#include <linux/sort.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "zoned.h"
@@ -3636,6 +3637,130 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
 
+static u64 zoned_bg_garbage(const struct btrfs_block_group *bg)
+{
+	const u64 slack = bg->length - bg->zone_capacity;
+
+	if (bg->zone_unusable <= slack)
+		return 0;
+
+	return bg->zone_unusable - slack;
+}
+
+static bool zoned_bg_reclaimable(const struct btrfs_block_group *bg)
+{
+	if (bg->ro)
+		return false;
+
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+
+	if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags))
+		return false;
+
+	return zoned_bg_garbage(bg) > 0;
+}
+
+struct zoned_gc_candidate {
+	struct btrfs_block_group *bg;
+	u64 garbage;
+};
+
+static int zoned_gc_candidate_cmp(const void *a, const void *b)
+{
+	const struct zoned_gc_candidate *ca = a;
+	const struct zoned_gc_candidate *cb = b;
+
+	if (ca->garbage > cb->garbage)
+		return -1;
+	if (ca->garbage < cb->garbage)
+		return 1;
+	return 0;
+}
+
+static u64 zoned_sweep_space_info(struct btrfs_space_info *sinfo, int thresh_pct,
+				  struct zoned_gc_candidate *cands, size_t *nr,
+				  size_t max)
+{
+	struct btrfs_block_group *bg;
+	u64 garbage = 0;
+
+	down_read(&sinfo->groups_sem);
+	for (int i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		list_for_each_entry(bg, &sinfo->block_groups[i], list) {
+			u64 bg_garbage;
+			bool below;
+
+			spin_lock(&bg->lock);
+			if (!zoned_bg_reclaimable(bg)) {
+				spin_unlock(&bg->lock);
+				continue;
+			}
+			bg_garbage = zoned_bg_garbage(bg);
+			below = bg->used < mult_perc(bg->length, thresh_pct);
+			if (below)
+				btrfs_mark_bg_to_reclaim(bg);
+			spin_unlock(&bg->lock);
+
+			if (below) {
+				garbage += bg_garbage;
+			} else if (*nr < max) {
+				btrfs_get_block_group(bg);
+				cands[*nr].bg = bg;
+				cands[*nr].garbage = bg_garbage;
+				(*nr)++;
+			}
+		}
+	}
+	up_read(&sinfo->groups_sem);
+
+	return garbage;
+}
+
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *sinfos[] = {
+		data_sinfo,
+		data_sinfo->sub_group[0],
+	};
+	struct zoned_gc_candidate *cands;
+	const u64 target = 2 * fs_info->zone_size;
+	u64 total_bytes = 0;
+	u64 garbage = 0;
+	size_t nr = 0;
+	size_t max;
+	int thresh_pct;
+
+	spin_lock(&data_sinfo->lock);
+	thresh_pct = btrfs_calc_reclaim_threshold(data_sinfo);
+	spin_unlock(&data_sinfo->lock);
+	if (!thresh_pct)
+		return;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		total_bytes += READ_ONCE(sinfos[s]->total_bytes);
+
+	max = div64_u64(total_bytes, fs_info->zone_size);
+	cands = kvmalloc_array(max, sizeof(*cands), GFP_NOFS);
+	if (!cands)
+		max = 0;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		garbage += zoned_sweep_space_info(sinfos[s], thresh_pct, cands, &nr, max);
+
+	sort(cands, nr, sizeof(*cands), zoned_gc_candidate_cmp, NULL);
+
+	for (size_t i = 0; i < nr; i++) {
+		if (garbage < target) {
+			btrfs_mark_bg_to_reclaim(cands[i].bg);
+			garbage += cands[i].garbage;
+		}
+		btrfs_put_block_group(cands[i].bg);
+	}
+	kvfree(cands);
+}
+
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index ef5292ec771d..c8197dafa502 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
@@ -336,6 +337,8 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info) { }
+
 static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
 						  u64 flags)
 {
-- 
2.56.0

