Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795699730;
	b=UB6DibW3GISAMzExm6RUBP3lKYkW4WS/qNv+QnYzC3JH4spxmIpWfc2iEZir8ZatSUrR
	 sS3GIpgG5tGoBchZaZ/U67wM6IgdfLMJ8A6m/v7sOx2q5KwBa/YDP970PRK3d/lp+rprl
	 gd763ekegnLGmafpmsAP7MnUpmDm5KsMaTiqCmL1vG3LvJMIejViVFGLFs9zQe30qVQgG
	 cUPs57jIRgWXnKBY5h3dvxsroU+jgaK8bzM4ba7vSwDf3ukd7LSFzpCeq+vq8szk7vbWJ
	 oeQWecfkx7ORGX4eXhkf1reLj8+i76GsshRO6GtIwIDSYfgGze/8ND8t7aSkJ3npR9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699730;
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
	bh=pZ8t3wLpKVscTd2kK8ja5k86a1V4TBRk+QsngVtxdEw=;
	b=CAgbcybwrioEiw+LNoi35FFN8esXJLQtfCmDg4qqT7ULdg6rSHMLMMCMP7mBaDX4N9dS
	 9V+WMjRCQfs7KpVbofPgWuDOtjDh5eDkcOJQUXx7abwvXdOTp3F/q50YjjPZ/muOLr6UT
	 VEb0WNmnKnaIjEzRArpo2e/HTyVZuqKejJu0dn3PfLu5IhQZ0ucgJ7HFYNKEV6aFtgu2h
	 acT3Od4Qu4cb4S1wztUAqS6qYCR+UyZfZnJkyRzYSShCClsIp7i8fwyR4k/2sI8RqceU/
	 Fe7V3N01Se+OrG1P4gr7lY0wvC5vXP0n4telB2hTiulVF7CKEWvBHUsPtAN6UrSvuKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="M/VOQl1W";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GCmNZiMg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11A606A683
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 13:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE11A606A683
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=M/VOQl1W;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GCmNZiMg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795699728; x=1827235728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1Sz60+iX2KV/OU/Q5xdzejT+fDEQwZ/cuYiQKmsU8aE=;
  b=M/VOQl1WM5oDQoAjvedwHlfhYEHi8lelo/YsyMy65nfeaHXl86p/jCak
   0WXsmwpbh1XavROuvmu3u23bFY/kZBz4H+uHUgkFg7GJwKw3xEUiJm+pp
   Dvo+dGYbqP9bYU1t5eYCsJmA95YKHR2mqbEK4C/QIiyNf7dO0xFF9ynlo
   EX1Tvv/e16jpv1O1S+3ZSolT0Ba1KX9Tq3aqdTguje5D8oOJfA4stAjhr
   DcNbpcCN1s/bdYmQxeFBYpCReSVbzZQyxF8nC2YKQu/qwXrwmL3QCSAIh
   uvIk5KjBsDHHi1cSlXwRdKNIBgt+JO8ZoJqIPIhVnUHJXBwq+yuUAMYet
   Q==;
X-CSE-ConnectionGUID: XN8AmgTbQW+XUfbtC4qLjg==
X-CSE-MsgGUID: rS/Yk49LQISbGnsj/zUMgA==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="162817790"
Received: from mail-northcentralusazon11013011.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 21:28:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auqJlxEYQOXlu/0iLbqECtv4BJFTInbjfI8fn5c0sd/YU4nMpOd/vPVTu6MySGxCpv1Wm/qxP+E3/uTR5VRn68/mBKhKjzoMW0XqOV8vYYKRY5ufYfSUGmeKAz9Jgwk/5tvMTo9KxPvGizfvPCULNA2wconxzxfKm1yNIhLG0SFM73ahQIbqUjnwQcNB+jAZ4g17ttn7Vlzkq5r6dnp6Odc1UzpI9UL6UuWIHTuZ0iY5BXlhbGm1eXbcitdA1JXiUSAqXSOr7QFmFBbidzvubFZJR7DCJ8nI3PrLZ95yD4Bxd3ynYeqQyqesBXWGx1U2nXR4kEPjMeWxmlhwHUVozA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZ8t3wLpKVscTd2kK8ja5k86a1V4TBRk+QsngVtxdEw=;
 b=HbJ/gI6pg/CTAYFdG2sW7hDBQRMxEcctfZPRn/U+bIUmJhGHn9bWOyW1D2uoJWkd3FkWMTYDY7eOd9dmE9sHvQug0gl5htLaItAl57s1gz6ufLznAslXaZPa75csLPR4loPN3+OnRlSK0IStp3Td0nnc8+XuCwSRye48Wu7WUSIJJPXQdN5lJ/JxfudtbJdMyIffh4HVT55SrT6fvNbDR/VTiZ5fqAduq562sbE1NFv8fwaQwCRBpA126rYqBNenNlICSVQxoR/PUwEYVD7TfWkYguATxXyT9Nmr1/ALZYcUENle9oAX6pjdDCN7LhWT/DjYSphYp1hc36V7evT/mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZ8t3wLpKVscTd2kK8ja5k86a1V4TBRk+QsngVtxdEw=;
 b=GCmNZiMgPvuBj8PABj/zoZ6vAGkgYuwRYIw+EvfEPqmBZ2Kq2LbxE+VS1QA1OhVyw1zyFjLO7/i0jsHhugSTC8PnApVjgg60DAWHLeOMQ0I9OhZwDfcKF1XSvqUoJV9sXat+flXNNbv4eDT7dKZZaMCn6Se3/Mdd5LqUFikPBWQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9155.namprd04.prod.outlook.com (2603:10b6:610:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 13:28:45 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 13:28:45 +0000
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
Subject: [PATCH 3/5] btrfs: zoned: allocate a new block-group per file
Date: Thu, 26 Nov 2026 14:28:18 +0100
Message-ID: <20261126132820.570379-4-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: fbfc600e-6d30-4b4f-7e00-08df4bc13259
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|376014|366016|23010399003|1800799024|261009223027099003|22082099003|18002099003|260925022911599003|260925021911599003|260925021311599003|10067099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
 7N0Y+2sldn0NMHRECeHnx+hu7MirQck9/ei4TVix3jxvtZxTLKzwgTbThRTZcXLrdzAB8JSK8M4lRmYrG2R35m2LU+xMhqGL63/0AT87hh2CjukL0EV70AVgpcYmvp1pXB5tZ1gSDqdIZcDKerObPQ/rCzc/f81eJv+SS2vQAcA+NrOmbDN5dc8In8Iwr9UVVatg+uQMxALEma+aDhV7u7siouOGpk4oYKPg2x7Nd7G0PWKYdXCGJN4gFGzq1jyqqbRlySkoFqjj6sMx1XYwecY41PNXFGU4yap1M7hWHO6OKFtGOK3iKrd8w1OUJVPenQGt9yNLRZCpp6hkgGXyY2RwOwX789XrLXV7NNIEWWY74+Shwq8DoTJca6Vtdn6K6wbO23+TFzmFZIrTiVl2Lz1N2hLNOUYUTLfY0qYKZAUmbyn/v2yAOg/75aW9O3GUScVdvwxchA2mHxvE9dvphGoWFS9Qt9ZJRGr+pqdrLAZkeRsPuYTzJ8ts8IItv/9N/uL754sKVz5qBqYScaSlcGKmrTlGRa94axsP60lsYs0iGOJVtTpoch0o3rkuBfSVwbm0lT64gyYV7e+KRTmCIOx7wcF7KRq6qz8IAT1QCXvN7oUisuPx48+yQC7nxyk/4kSAq4Issey+mXm4Daxbq3zFv97k3s4EsOLp2RUbFf8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(22082099003)(18002099003)(260925022911599003)(260925021911599003)(260925021311599003)(10067099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?OEtaQlqMpjXu3QqXdEBz09ke5WBZncVA4AmioYokfG8jrMoH2FZsXFPYNwbQ?=
 =?us-ascii?Q?Hde07bX3CFr3GwZ/hI2DvrqWpMggBrK6w2s1bAksUnOw3YVJHPxcdoygwrdB?=
 =?us-ascii?Q?fIEtoORMzTbzVjpy1StGnAcVpN4n4XXLvy3RSj0VJBXH5T6unkWV0HDZR+hK?=
 =?us-ascii?Q?5HEHJ8nSmyUwNwuIx+GwdhVLxmfO48EW9iJkFMpSdjtqoTH+fRiFv45/0Bo3?=
 =?us-ascii?Q?o/bS1mbJ5JS/mMkHzX1bsNpsxn1xi1ehvAVIM8/cN4xf+tvXwgoOYjOJCbAD?=
 =?us-ascii?Q?f3jmE8zA3iCX3fgjZ7z66EliM3EQkRwSJFTkRI/Sa1iPvnFVcWfemQpHZrpg?=
 =?us-ascii?Q?zWM1nfSwWLtAfgKOC5SQnmBJ4pAZUv2kXrFWrzcR3082Iwg+oJ2LyAmkP6F2?=
 =?us-ascii?Q?8SFMC/5pK6ulcgKB0TCw7XyGQ0hVHH9a/6zkwU9dJkpn6nxoCZD50VUWRsUA?=
 =?us-ascii?Q?i/Hy3v+YQqfutJxh9QNgmLMGRAIxPTJpv1uP6FnmcspQyqsxevF1VB53uVDW?=
 =?us-ascii?Q?n7cFQPfvQJZh2Mm4+Q4Yfp4J5UGId1YS6w9mCpe9VGqatxYB0aku6PYc3HHm?=
 =?us-ascii?Q?R8cWAHTfyB1eavS+DeA+yg0CDuWmYtjVewDmSzlxcQK/0z43SLmLQgfp91nM?=
 =?us-ascii?Q?bFvHtvY500fvGWetDQE+DzuWK/PNkCRaYCI33rdufZDl17Aj2TwT+7EQ5ma1?=
 =?us-ascii?Q?DyHc2EtiQvyMXd2bI+zrYjH96Npq0B5dzkApTFHlaoJsmJDs+en7EZO8q+1b?=
 =?us-ascii?Q?h+6YTU4HL/3n6hEQHKFBnZEdX5AxErIprnKdOqM1lHzYtmZU8TxydVdbOcYh?=
 =?us-ascii?Q?aXUyJsNRnP8CoHKYrEQXJ2twFMpz2GvxOE2hmxAkGXo3aJpx82VYwmG8Ri2f?=
 =?us-ascii?Q?MnyE8ZMByvpgV75grEr4XLbhYCP65017KvV6rqd4uSx5ny8XHr/rg7tDUrWE?=
 =?us-ascii?Q?oXu+wytbL8nizljgDJpJBzVp9m41bUOHM/YcHOgm53GNoT6hogVgIYNn+s0r?=
 =?us-ascii?Q?7lOaQ+ElxpQ3DVrWK78cBQ1cPCMD1lCPOuLA41Lc2O4Gg42R946DzmLcndqN?=
 =?us-ascii?Q?WrLUmkf7IQV1FhVmNteMvhv+XJgNvhZtc7RVwWn+Az0RkHGz1JrlwJhYfVqS?=
 =?us-ascii?Q?TQaF5LBFhUHzroflcIb+EWpk8I1uDS96a3N1oL5NrOSP3BKGBrqjbaDVL7io?=
 =?us-ascii?Q?0OfS65FW4uC7DhqJGoZg0PuR6zmyaTrFZWnbrc5J/58YGTXjr4JKRgj+IKA7?=
 =?us-ascii?Q?nytNWQ4jbr1NNWgY4646al+ihHfY17xf1VAMzx2JUw7euceEsDW0eAYxx/c8?=
 =?us-ascii?Q?PerOAP2hSYSbHuYGJuhdAu6ZMJCq414d1HVB+w2oTCcIWTv5OIeIPCg1a8K6?=
 =?us-ascii?Q?AuxOhIuoDV5G9rY8BUMxaf9X/Xc4mVhgxBX2ULxOlaAnRbByniBtG/1doaa0?=
 =?us-ascii?Q?atPnY9xB+MsQ5zsAhnN7247H6LdOo72EvMHwym03zFBCsxGRR/uAY8s1HZT0?=
 =?us-ascii?Q?aFjZTlJIKop/uOAS9qhet9Wk2VdD7XjbG6tVV8uNTe/MDQIwH5Zrh8Jjl9bK?=
 =?us-ascii?Q?WHvmkbDDXvNVeEyPN2SA+VY6R2hAZZ5cCikW7NrYjrolumlNArI56cNAqsRh?=
 =?us-ascii?Q?As8jHA/ILQQMEbu1GQNSdiVnjRjzrd9YciqyibcG1PUM33eyDn5MeMsDnYvc?=
 =?us-ascii?Q?hPPHVDM0fLIFRexMc+T7vR7I7emU/qMEDICd/cqJOcaIFyIxTf6T8S1yELBE?=
 =?us-ascii?Q?HNfEZ6RLIHVldd4/qKpmXrL/nXpXZAgF6EmVH2XBwUrbuRGFcQg1HzcFy38C?=
X-MS-Exchange-AntiSpam-MessageData-1: hAASm9Lu9hl2V7yyc144lnkip/LsdTMcY6o=
X-Exchange-RoutingPolicyChecked:
	Q9VqIItEFixjdXKwjvBssJhn7KrT430TwATC44fPPjTaY2O/xuthg58R/R+qT1qtQLNBOykcoXDmUOtWZIYXTvF/o+gqJLnpeGjZQH+BJoxLH7gL+yVGyTU4q0uAbLI6DSaghFQUWgj+hXsCm60WBm8C2CTTbF01v7VqKEdVC2ivZZ/uM+AYo89/+Qpj3wQ0hsuWwX2llSO9d89pt1ckHHvLDQ5fDDuJAGNo0VYcL0SqPAW49tSfHailvr8EZcWt3+gMuCgA5WMvbw/ZYGewmlb5V+lpyfmS0qZ9Tl33HZA+GxBr8aEfOQNqEjBeOusqXAv8UPulCDXCmAJkvMyfxw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qV0V3lzzVTIv1OuzuQHh032Xc8es/jUMrz1tv4lcNtr94CvD33lDXOoUHQNxWSTJfJnJmPuck1kGsN+SkK8W+T3QDz0f57pmdBa7EHnJRqmjw6adbhWA580G5aJ3lm7ecy8R1K58m9KO2/VRrsfMMIbAzh0LKPg1VNeYXT3hOXxIG30C7hrJHr+P9gElCRG+qcWzahDr85pgt1WjzzC9tVDNooAweGXxRFM1FtC/MR6Y5Zb9Rk6GBArQ3ShvVf7LRLR9wsKJmMFJD6AcQ4CDxPgUAo6nuvB0vodYLI8ENg2MSnqD0YmAkDfB+XwM/tlGzX6VX8OxgNcqQtYktP4Tq83gRAOD6c5q9E8lbxdt0wPsHdmFuhas8OkoSUaTxfayvb/W2gRiio0fJfw3Po/R5OBFwmFr4YABQOISypLhcBBb0kpwfYjIPEz18ewhd7++Zjo9+nhOvgmVXDV9PBcWlXZyRx2GMqJE87k3b8I4ZPxxzhgpC8bk+gO1SGC2Dnu0zSB5xiq6SX7JhP8t2SPkKKlWoFI+BClck6qK0oGBCSVFaDUVZ+akapG7YEvKKGHRKTBUGXSgeTNk+GYU6J7PH3wyqs/eERV4/zuMH7VE75IqPG9Fu266lfx9xBa0cpln
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfc600e-6d30-4b4f-7e00-08df4bc13259
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 13:28:45.6313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2M0WE3CaPMNnbeofT1FOygEurajjdgouE9Huyp1ig68rkrQcje8wXHXvxphCqazv+v+q6S1nQ0tsPVtCDU15NenC3LthFEZ8A8iC1/3xeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9155

On zoned filesystems all data writers share the first active block-group
with free space, so extents of parallel writers interleave. This is
causing high fragmentation in the filesystem, that also potentially
increases the need for garbage collection.

If the allocation hint doesn't hit an active block-group with enough
space, e.g. for a new file or after its block-group filled up, and an
active zone can be spared, allocate from an empty block-group instead.
If no zone can be spared, spread allocations round-robin over the active
block-groups. Never finish a zone for this.

On an expample null_blk device with 64M zones, max 12 active zones this
results in:

Test                          files/zone   extents/file
5 parallel O_DIRECT writers   5.0 -> 1.09  966 -> 74
4 files appended round-robin  4.0 -> 1.0   192 -> 3

Buffered parallel writers improve less (4.45 -> 3.09 files per zone):
block-groups with a leftover smaller than the next allocation keep their
active zone.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c       | 36 ++++++++++++++++++++++++++++++------
 fs/btrfs/extent-tree.h       |  3 +++
 fs/btrfs/zoned.c             | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h             |  7 +++++++
 include/trace/events/btrfs.h | 12 ++++++++----
 5 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0541b38129e5..7169f296a523 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3766,6 +3766,11 @@ enum btrfs_loop_type {
 	LOOP_NO_EMPTY_SIZE,
 };
 
+static inline bool want_fresh(const struct find_free_extent_ctl *ffe_ctl)
+{
+	return ffe_ctl->want_fresh && ffe_ctl->loop <= LOOP_ALLOC_CHUNK;
+}
+
 static inline void
 btrfs_lock_block_group(struct btrfs_block_group *cache, bool delalloc)
 {
@@ -4068,7 +4073,8 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 
 	/* Check RO and no space case before trying to activate it */
 	spin_lock(&block_group->lock);
-	if (block_group->ro || btrfs_zoned_bg_is_full(block_group)) {
+	if (block_group->ro || btrfs_zoned_bg_is_full(block_group) ||
+	    (want_fresh(ffe_ctl) && block_group->alloc_offset)) {
 		ret = 1;
 		/*
 		 * May need to clear fs_info->{treelog,data_reloc}_bg.
@@ -4102,6 +4108,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	       fs_info->data_reloc_bg == 0);
 
 	if (block_group->ro ||
+	    (want_fresh(ffe_ctl) && block_group->alloc_offset) ||
 	    (!ffe_ctl->for_data_reloc &&
 	     test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags))) {
 		ret = 1;
@@ -4259,6 +4266,13 @@ static int can_allocate_chunk_zoned(struct btrfs_fs_info *fs_info,
 	if (!(ffe_ctl->flags & BTRFS_BLOCK_GROUP_DATA))
 		return 0;
 
+	if (ffe_ctl->want_fresh) {
+		if (btrfs_can_spare_active_zone(fs_info, ffe_ctl->flags))
+			return 0;
+		else
+			return 1;
+	}
+
 	/* If we can activate new zone, just allocate a chunk and use it */
 	if (btrfs_can_activate_zone(fs_info->fs_devices, ffe_ctl->flags))
 		return 0;
@@ -4530,13 +4544,22 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 	}
 
 	if (list_entry_is_head(block_group, &fs_info->zone_active_bgs,
-				active_bg_list))
-		block_group = fallback;
+				active_bg_list)) {
+		if (btrfs_can_spare_active_zone(fs_info, ffe_ctl->flags)) {
+			ffe_ctl->want_fresh = true;
+			block_group = NULL;
+		} else {
+			block_group = fallback;
+			if (block_group)
+				list_move_tail(&block_group->active_bg_list,
+					       &fs_info->zone_active_bgs);
+		}
+	}
 
-	if (block_group)
-		ffe_ctl->hint_byte = block_group->start;
+	ffe_ctl->hint_byte = block_group ? block_group->start : 0;
 
-	trace_prepare_allocation_zoned(fs_info, hint, block_group);
+	trace_prepare_allocation_zoned(fs_info, hint, block_group,
+				       ffe_ctl->want_fresh);
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 
 	return 0;
@@ -4609,6 +4632,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 	ffe_ctl->cached = 0;
 	ffe_ctl->max_extent_size = 0;
 	ffe_ctl->total_free_space = 0;
+	ffe_ctl->want_fresh = false;
 	ffe_ctl->found_offset = 0;
 	ffe_ctl->policy = BTRFS_EXTENT_ALLOC_CLUSTERED;
 	ffe_ctl->size_class = btrfs_calc_block_group_size_class(ffe_ctl->num_bytes);
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index ff330d4896d6..50e0a16d2d8d 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -87,6 +87,9 @@ struct find_free_extent_ctl {
 
 	/* Size class of block groups to prefer in early loops */
 	enum btrfs_block_group_size_class size_class;
+
+	/* Allocate a fresh block-group */
+	bool want_fresh;
 };
 
 enum btrfs_inline_ref_type {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 216ca214d26a..4670db6a4fc8 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -67,6 +67,8 @@
 
 #define SUPER_INFO_SECTORS	((u64)BTRFS_SUPER_INFO_SIZE >> SECTOR_SHIFT)
 
+#define BTRFS_ZONED_GC_SPARE_ZONES	1 /* XXX: This needs a bump when zgc-final is merged */
+
 static void wait_eb_writebacks(struct btrfs_block_group *block_group);
 static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_written);
 
@@ -2721,6 +2723,35 @@ void btrfs_zone_finish_relocated(struct btrfs_block_group *block_group)
 			   block_group->start, ret);
 }
 
+bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	struct btrfs_device *device;
+	const int needed = (flags & BTRFS_BLOCK_GROUP_DUP) ? 2 : 1;
+	bool ret = false;
+
+	if (test_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags))
+		return false;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(device, &fs_info->fs_devices->devices, dev_list) {
+		struct btrfs_zoned_device_info *zinfo = device->zone_info;
+
+		if (!device->bdev || !zinfo || !zinfo->max_active_zones ||
+		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+			continue;
+
+		if (atomic_read(&zinfo->active_zones_left) >=
+		    READ_ONCE(zinfo->reserved_active_zones) + needed +
+		    BTRFS_ZONED_GC_SPARE_ZONES) {
+			ret = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 {
 	struct btrfs_fs_info *fs_info = fs_devices->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 2225090839f3..2c17c31437ca 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -103,6 +103,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -299,6 +300,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info,
+					       u64 flags)
+{
+	return false;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 1378e697a46f..830927b185a4 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -2244,15 +2244,17 @@ TRACE_EVENT(btrfs_find_free_extent_have_block_group,
 TRACE_EVENT(prepare_allocation_zoned,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info,
-		 u64 hint_byte, const struct btrfs_block_group *block_group),
+		 u64 hint_byte, const struct btrfs_block_group *block_group,
+		 bool want_fresh),
 
-	TP_ARGS(fs_info, hint_byte, block_group),
+	TP_ARGS(fs_info, hint_byte, block_group, want_fresh),
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,	hint_byte		)
 		__field(	u64,	bg_start		)
 		__field(	u64,	bg_flags		)
 		__field(	bool,	hit			)
+		__field(	bool,	want_fresh		)
 	),
 
 	TP_fast_assign_btrfs(fs_info,
@@ -2262,12 +2264,14 @@ TRACE_EVENT(prepare_allocation_zoned,
 		__entry->hit		= block_group && in_range(hint_byte,
 						block_group->start,
 						block_group->length);
+		__entry->want_fresh	= want_fresh;
 	),
 
-	TP_printk_btrfs("hint=%llu block_group=%llu bg_flags=%llu(%s) hit=%d",
+	TP_printk_btrfs("hint=%llu block_group=%llu bg_flags=%llu(%s) hit=%d want_fresh=%d",
 			__entry->hint_byte, __entry->bg_start, __entry->bg_flags,
 			__print_flags((unsigned long)__entry->bg_flags, "|",
-				BTRFS_GROUP_FLAGS), __entry->hit)
+				BTRFS_GROUP_FLAGS), __entry->hit,
+			__entry->want_fresh)
 );
 
 DECLARE_EVENT_CLASS(btrfs__reserve_extent,
-- 
2.56.1

