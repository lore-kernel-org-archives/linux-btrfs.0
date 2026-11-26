Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795699733;
	b=ulEPU9imReOcfKqP4fTsUcptQtHycx8wYn5lZLoCFg0OLAOSoTfYs5F5uNc+Zjf567YU
	 mj2N46iHixul2PdYn28kKfUdQoDllgoOEHi6UFkPLuQWcfrnHjoD/MQPT4pMIhh7mZVhV
	 gr14n5PwxzQeaezLqbf2NBsyLm/yOD7sJcFDqdqUmK4mT3ibRdnol3ityJfrNMEgEa6Nf
	 uHPi64sZWYViQYGfVwDTw9hjfY8p0gx1HhM5DngFS31no036Zl+Ejm8k+XkOfBBs215dU
	 xmSes9TxuHbKvSmErhSKVPZ6yMxfj8WqjCRZMwl6lQnW77RopKKn0hZ1n7qE2oGpFXQ==
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
	bh=cSSzjn+biI8xhSIBQQl2kCxc9NyMmCsUptbI1NwkQDM=;
	b=hoRuiGjtFcSm1EkJJQt3y5CnXIkujgaw3gbyJQzcfqBEevTWjRDEduwZcenV1vS42VpE
	 tJAd8uql0YVCw0/e3+3D+Pt2L/wm9iOQ6M4AZnLJ47S/Oy9iyf+Kmkcb3/edzhXt4Dq3L
	 b7CFwrk+6yU1IE+J3+9DN3r9IVrVc3jTd68HrYn0sqtBowkaFAlw9LzHI3EQvG6jc24tx
	 RZEf6kKp1VM3qL/OaWxl1Qwn1BOW5LRVsCEuxs0xJfIKEY+4Fh8sbRbqvXSiUL73vmOv9
	 NdvgHUnH70e6GWOBZyIM59jJ32i7HVV5874DtT8rPRtxStb5TvTKxXTe+7c5Z9L3ruA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ntVRhsJ2;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HtRH5JG2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE66D606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 13:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE66D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ntVRhsJ2;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HtRH5JG2
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795699732; x=1827235732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Y2AXwSHQ1KUPqKkv/iHrvye8JJB/ZPtODIHZiAmxDMI=;
  b=ntVRhsJ2XqghH2VuI/eVZpHTe86QpNH68mRxNrnQs2IE8djlpJjlIo/i
   Rxts6JvnUiHi79KwI88P3P2kGNRcLknAovAj7uYYfrB+LqVlY9XX2FM/Q
   WjI43zaTJ6nJ4wV5K3RFnqDQgh7DIhW6VSejlpGnjJE0HNYj3NujgLJUH
   F5xy5h/1JX0I3yG4lGXYjxlztoPKfpqC9CjpJETbn5fZ4P5HskOXfKt/D
   DVogbXXPk4mYV+dojAA75spL8303GoaBONaE/WUU+Z2ngZGbyEDWlOAK1
   0d8tskk2S2gkyp4WivWG5S4Br7K32rH0gzSefiFqQzNug9I7aWlw4X3Qo
   g==;
X-CSE-ConnectionGUID: rpLRZOKVSLyx3qu8sl2HEQ==
X-CSE-MsgGUID: IheOFxoLRneRsOPDN7t74g==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="162817801"
Received: from mail-northcentralusazon11013015.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 21:28:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=megqh2IYFyEcgh3Yq8wdYqo3YbOJWJjp9sfVrbLs2ccJgUPoxecGMcaVItE0EkAlm6/Kwb1RSFk5gpCdQqyUmp6yM7J20kCUK0AgYB9Fd0ZWEY2Rszybz82GEPsA52Tv3qsUX9KVt3bkzhQhjhb5k2x0UE+143bqAi2BSsaOeu66W2tJqMKmXTzMjSOJHpl6coczs17dtbyfGaj59k9qdk8CgLXfZV13yRJP9fnq+sJda4cRN7zYUa7LCfUYIV+ZAjIAbPza0qKmJb7CftLcz4tEixmQi1rxb7kWosuUjIvLGW9dyKfFsHH4dCVrWpGWA+2EE2Ae+55+zKX4I6HC1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSSzjn+biI8xhSIBQQl2kCxc9NyMmCsUptbI1NwkQDM=;
 b=C3WtI1v+T92CzG4s/8PglTSbV+X70VpIKyvrMvcOmMOyj2F9FML7L7UOUM8QV3S3iehUW7fbOAPzZ+1f4Hi8nTC1yfFcqtuVtDVkQDrYH+ha3dsA0ZHQ80EJVa3Pd4vQf5hxEubx5955hocyVNCNdC8FyHctu6ga7EQG9J/a2UcBSUXrAnxHCHOzifrdPF6LTCMSl1KR0Q0FBOsEvQuVFSP8GxMNvIP/ITzdZ7MJR3vjGcetZIuKeL1hc0jJr5ovtyyPQ4FBTL18PoCY8sY97Jnky5x4xVBfioTEPj7o3FsBD17KfeO0ObeHiihD5aM9A8le33xrdLS1/CgSJS7wRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSSzjn+biI8xhSIBQQl2kCxc9NyMmCsUptbI1NwkQDM=;
 b=HtRH5JG2ziVCnJlIW3jT73fl/WSm8twDPahwnNnlxBndNK0A5DOL3omp3cJI8sRf24TpLcSTgbAwL7ug8eI9QlVsezxFrrN1FjB2R1UJUq8jDGLlG+QF28PlGr1h8uWPquz170UTBhYEZEgO2FHPlzT1/UTQW2W6Zzz9qcnFNR4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9155.namprd04.prod.outlook.com (2603:10b6:610:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 13:28:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 13:28:48 +0000
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
Subject: [PATCH 4/5] btrfs: zoned: try to fill hinted block-groups
Date: Thu, 26 Nov 2026 14:28:19 +0100
Message-ID: <20261126132820.570379-5-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 831e8368-104a-41ad-3fa0-08df4bc133ca
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|376014|366016|23010399003|1800799024|261009223027099003|22082099003|18002099003|10067099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261021123027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
 hhFmdwA++WjNGFuBbP2/TN8wYn41tFaAShC8APVBalS9FSa8eVFO6tO8/fEuafiXencBY6fjd2Ibl3tA0FCZgBmX9hICOsaTQ+tjk5O16Tet2hjNL4c8TwqARhjXPaKW60E8/p6zBcjixX3zzbkTxm6T87Rf0FAuLFpkp8yN3xQEK+1DvXJMncS949EFNoxA+8P/AehMwc5WyaHwuoUSypz8/vu3JHZiLvaDMvsluD+NdbXnZIUw3bIXf0hx2isnBrUyLQzzktX0DtS4R5JyzHEI5p9+EmWnONVIbRsN69abKc25r6JEPx9yWXMZydM+QN+IKkKlsdcJ0MRFNNgL239Q6kgGRdHgLFH9YWH0/DLC00BxTkZ7VY7WLitEC7BzKJvBuiLJOjSYPzhNOAF2iE2Ig+6rABhEgSinz0G/PiexcK728Wl9mQoWNM5gLfY9LPesebWD+Xf/TeXp8JNwzlEBCFD9vnU8vs74rghWpa69PnZ3s9B+0dNmyP1FMSgl88QcatZPB6uQUeVebQ4V0zvx90pcevTze0XjUq8owdmoORl5PvQlKgCWdck0fLnV2ErhiKSX+OXtIKeH+El0QzBTw/O2n+J3emqE/VvIFH95odg/jdjhRzU3d2hmCqqSPkX701rXqkQn6zKZwyLBBZWlon92jsW/WuypxG/o34g=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261021123027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?GIkV0Sr2ocMp1aVgCKzU48ay7gvZsQM5QYTvSbe5zkGj4B6jSPJBe9d3xYwJ?=
 =?us-ascii?Q?CsCR6WZONpFyebrU5RcO4QbFhVC0TQQxE7dzWUKv2kKvbg5MV3zmnGUw/JWk?=
 =?us-ascii?Q?8JzuYTs6DXDrLyob8u5gFfakmdSV6xvQvu32rW91VsoKGsIx/tq5dIDX3Gwp?=
 =?us-ascii?Q?odR20PLGu0vQnx61kkLst+svdnFjobuDsCq+h5Cm86I3yCQSWWil+aCkIa4N?=
 =?us-ascii?Q?paqL2g32pY9lvv4CKItQ9EMaCYhM1izbU982lyLDlZR+pWYTInAu4OK5fEw8?=
 =?us-ascii?Q?ffQAXGRi/1C3opmrJjrXV//aDApitc1RuM3m8/+My8ElnofOMJ47RTYjTsmt?=
 =?us-ascii?Q?poqhJurgWfy/i92JnGHv0zkYVEC6tDHyXFxcx8Y5HTlNNM3g6K2Xy9mXBXRs?=
 =?us-ascii?Q?qkflUAqpi7jxh0h2ZvZt4qPJQrGst8njXyO5cwkmyyoyl3VWUDn8nJBwTgAJ?=
 =?us-ascii?Q?pTgUTXS/nAz+QQucrOruUjp82yf92ynI1GCVauhVXA4EsR5BgVUtZ5c1apqf?=
 =?us-ascii?Q?e2B5Ozjk4tFVQxJGgTL8dN0J8JtkEWyoll2B86KDQ9fT3ib8b/ULMiLl5N9m?=
 =?us-ascii?Q?5grRBAQQjn2lQI4fexJE2blYkx8QVzvMM52Efpk2wermIz0EzVOuCGdesFT/?=
 =?us-ascii?Q?XFolgvGwBLSG4S4dJvcmU3FCoju0ROMSmgzlGqGHyPc0tl1jvmhkxIrI4WeG?=
 =?us-ascii?Q?71aXjc5yBhWdIZVHmAnKNT5L4lUvHjYfeeFl09GznmxTru+K1/z/tEZznAjP?=
 =?us-ascii?Q?qV1hIc/3xcKHtj/UZAMZOf+pBGNfX2vvyEEN2X5hQ/+j21MKkgomhiErIfMd?=
 =?us-ascii?Q?6w3uZIOw0rCwvhRbRP3YW8/p9q6Ez7GX1Mw7vU6V6YcEp3FbnWzrtarAnWdl?=
 =?us-ascii?Q?QztpizO6sG0ffT9r0uUMFGSta1FlJMS88IUbD04ijPwFF6YKT/kFVj8HOoCs?=
 =?us-ascii?Q?HRGRCCRTvOW2EEV2hkG0ksnMIdiCTg7HUk8pjxBb+gRHwtCHWOc3oo8Q5aWZ?=
 =?us-ascii?Q?Yn4kgewwEDCO3MnNvsgYJSVeRpvoS05yzlMGTPcabt5TE28czPP41x+qRmCh?=
 =?us-ascii?Q?RhkqNfo3aGEIbgpqb6lgiZNnIZKPNhgj0DkjhVCEg4hhSLv17V5bAloGF4dp?=
 =?us-ascii?Q?4LBGl9hLe3ReXx/1DXVw9bzSlKK/lR83o35UX/+oK1+GzjPqExuBs4QZehac?=
 =?us-ascii?Q?9lWYbw4lgpQ9kESAeb+ZKjLFyKWtEZwq4tsUz8DQH8SU7rdyXx+Xz0LTQuU2?=
 =?us-ascii?Q?tEyqR1W0CLPNdIbG+yVR+qgH+FwEY1z3vEdMEzrNpHscO+t4Ue6o8HPN0ga0?=
 =?us-ascii?Q?tI+5FUa9aEiBCGYlyzI7Zsb/K/dbu14DAyCNesvE67OeP+XhYwO8JDeZC216?=
 =?us-ascii?Q?ljvQijX1hS8Z8l+zuQI6ntheXgbEduOuOsR3gZQBAlkmdq5TFMtI634hxNas?=
 =?us-ascii?Q?yg3fNkbZAHXlqoTTOI36hB+1xOPfaXRohs2sED+sJXOPSznu/q2dxFyGkP7Q?=
 =?us-ascii?Q?uuncUd/kHCga1vCHMtsDptY7llquBOzuspQQPreoooQllbN1Z5cOmt+omE2L?=
 =?us-ascii?Q?SGJzSCwVAFTuaiBeZYLV8bRtGiu1wriUHFcIRuY7QKQjccFmq45ra6a8WHMl?=
 =?us-ascii?Q?6mc/txzVg+ydyY0kjm2pppPWQe44mbwC/iz4U7uCHr5fW7Xl9W0DOWW9hKCR?=
 =?us-ascii?Q?qtCnstyUO2vG+HbLUsqRsnjXO9jV0laRb496Oq6W2j2gY2Mp3aBBFS/1nUCW?=
 =?us-ascii?Q?lBxgqECReVcV5+XVMEc9dnDmMNkgRXdppYVU/slti6Hq93nh5z9yo8o8rx7R?=
X-MS-Exchange-AntiSpam-MessageData-1: xzLtZdAbsvgWjMBAsDuXMMTM4dDMkiVxjLc=
X-Exchange-RoutingPolicyChecked:
	h+2nd5h3x7r5CbILWnSp3NElcIMUBab2SUom4cT1ivr6w+3fRsXRyZkpDbQNsIz/q7DY7nM5gCRHo9KDTHBi5q6unZh4rXQubS5WwJWafC5o7zlHpAX7bGWDQm2rLyH44sSnL+VaIr+oSDaB1ZdoQivQ3notkK+b7V38d0JVuqJKkvaMMwsDSi+q9tGqi6PvfizzymDYguaB1B6WmcKZWuKxpDSnw2ytyuhM0nS0WtU0w4YAz/VUclJ4LOF8eLRC4wQMErVGVinz8tpbMl/N6jPMLUCc2cqP/DyUcQY7SAK4iu/VNG/TSXxBMsC6U/t5z3kTN5rZpdZEYY7+4GpXOg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v8M9X1bq0IYbB8FIExMEKB56uyr2DSqPSwafaXaMBoHDmOFvRZFg2TngFnoOvpJpF/By1/easN1CTBmwIMfqJvigwaWi9z3Hi1sYKweDhZ96IXB66ijwWRaX9wnUQ/lzO5Rq6zwFWcxcPoDlHTBIpZsSgLXbCcx1+7Z7/VEy7JSRJam8g/vTyGBjAlo9p9YM+JipWRLJC9gwHr29VwoDj4HBi+DNXDoK9AALPbBt/IzrzYTzjEfAUsY3DkILEPjREdJqRBBjp//Syj8B5aMRWnC7idUgGuyXfwPGkqAoNM1MXtAaHYDv85PnVrpU8I8KBNcZDwY228SiJt6AfGc2LpbAycefGVg1v7DSODW0FxXJeZrd2LAWbTpmpA5INzfM5Hq/uu5kbxfM3VWbFYaUpEvrLsB4cyfUunslWwUJXAUcinIl/gc4uR3UmoQaeBKG3Cl1xptklXPuV0x24cvR9qM92WpMURUYgWEqc3GJjjmGVt8FLqbfOCOVaEToLe/lrMWIwzoUmI2bbw1rzmT38kTYPsDmwUjRsP92yWOAOA5U488N5o98G6h8XzamEsfiFj1mK32dC5RDsBMLeCk6Jkauu3XDnTRav18ZqWuh54WtwLgtV7uYQMMNkLrzPkmp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 831e8368-104a-41ad-3fa0-08df4bc133ca
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 13:28:48.0413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmVM+2MLIoey5CXZREldhAXbO3L0Kpgyp7iElrIWfyN5XVtxUp1mX8s9WvsnhPzLrckI5yoLnIns7JdyTYICM0yCHix0hI8ttY4k6ftUOwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9155

If the hinted block-group has less space left than the allocation, the
allocation goes to a new block-group and the old one stays active with
its leftover. With buffered writes this happens for nearly every
block-group, the leftovers use up the active zones and new files fall
back to round-robin.

Shrink the allocation to the space left in the hinted block-group
instead, as long as it is not smaller than min_alloc_size. The
block-group becomes full, gets finished and releases its active zone.

5 parallel buffered writers on null_blk, 64M zones, max 12 active zones:
files per zone 3.09 -> 1.46, extents per file 29.6 -> 5.8.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7169f296a523..d8dc43655b16 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4526,8 +4526,23 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 					&block_group->runtime_flags))
 			continue;
 
-		if (avail < ffe_ctl->num_bytes)
+		/*
+		 * If we have less space available in the block-group but can
+		 * fit the allocation into the hinted block-group if we shrink
+		 * it, fill up the block-group.
+		 */
+		if (avail < ffe_ctl->num_bytes) {
+			avail = round_down(avail, fs_info->sectorsize);
+			if (avail >= ffe_ctl->min_alloc_size &&
+			    in_range(ffe_ctl->hint_byte, block_group->start,
+				     block_group->length)) {
+				if (ffe_ctl->ram_bytes == ffe_ctl->num_bytes)
+					ffe_ctl->ram_bytes = avail;
+				ffe_ctl->num_bytes = avail;
+				break;
+			}
 			continue;
+		}
 
 		/*
 		 * Remember the first block-group that fits the allocation. Then
-- 
2.56.1

