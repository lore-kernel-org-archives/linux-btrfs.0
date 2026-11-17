Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941987;
	b=n+sISLTCkX0UjP2a9XaJnSU0y4tf1XwFEVKn6WZp6+CHr6gfIasEjZX/ZMQSwUECxSJ9
	 dgWxfCStVSHm7i70MT69dwX4v8NmhF/lo/HoGnADk0+YJtsEEFLsqNC7sMpWG3DA1wv+f
	 jjB2nFFZwFRcxaC9YnOHqMtQeP3VcZddiOWvqfovBvohE1favBHbQZeGkxj6g/kA0EM6L
	 VZSmKYVkdCgJi3xk7TK6Tt2SoZYubJ4BtPL7zWfrfWBN09g3HmdxdXTP52KuoeZHhb5u9
	 kddsOi2JSKXEZIe8n8FY5WkVFZy3JQb7SmGjOWF15w7ArNdDkTeCeVmUFRjkFXwEt9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941987;
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
	bh=KseEE9QJPvzob9AL8KWrlqbE51rMPXKclXu3/WDBTvE=;
	b=A10ZsKAD+hQ8t5mEmncBlxALqyCYug23DLDWKNLefF7NgHnw4JH2Z7IRmOxY4LidUAx1
	 sii3WYhtjttEA6M73sG26JRf4BMyarvPYIkpNoRon/sn2BxFMokgvs6kJmrYNdi0im5i9
	 IaTXdphsydwt8G8QfPFnmVpCiMlrz3cIOUsJ76JMbhRPEN7DWvZBQGVoV8I4gl3vL8wKt
	 Hn/KPuTLDA8BTFQPXY+4Bzx5MdMYT3H8xJCk8NreRAn6BzyDTE1d36pbs43g4y8sfsUWW
	 rAvY6yRi12sLATEwByTxJGAonrDqUyZ+pMhpCoFBQuTS1Ql10yYIjgWAxlLrKXOV0Eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=GDD1Is4f;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="f/e9S8ls";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00765606A332
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00765606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=GDD1Is4f;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=f/e9S8ls
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941994; x=1826477994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=IfrcYSqU++urNcYJg9cf/HZv3DMA/4kykxqV22YhtH4=;
  b=GDD1Is4ft6LV8DsAHvh5Uzf3OVfgBwJy92zSbtwdTKM4lDXutHkqndTJ
   HT/5JJR/LviF1geguyfye+Ep/8vGII/BskQLqa+CcWBzx6Ng+bB+WBqNp
   WlrHhs0D0NDtee6wkF7BEGHSzGJlYfExkxq1Mm1oQdan+Kjqpr1ehaySv
   pcguYg9awc+ox1kKu5rT7FZTFtfaJ/6oYIXyB3kV8ahY/T5AlqkJiXm/E
   09nqNaaT18y+mr0CdM1BGzE2pI2g7rkB+u3teYd8HvQPHTlliOn3RXdTT
   0I8HAJ/ne093rMwA46iXxhrMC6LBlMSzaBoGk/DFaYSivDSUeGFQujiCt
   Q==;
X-CSE-ConnectionGUID: q0sLfgTFQ+OPws5A2R84pQ==
X-CSE-MsgGUID: Z7fnjPwBSx+hLbFEAfOUPg==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160148982"
Received: from mail-eastus2azon11011010.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.10])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZ+mNzvdQKRiNXFoD2im8yOLdDvQbeJ/cH5kH5ZVGGptb21qnDVhFCuZjxQLE4Z271KiNVOMlwmg77dQx+iqItjEtqp8uPvxFHuZqEzeEQpPxyR2irPwZR8WoumTWWsyd23GumBs2zi5PQoQo6OBpKyR2qB+2twiCbwUB3CpelMk0DqHQoExGFPs3k+JTO7B98AXMR20o1whdnPqA/Nv9n8c5iOHb9KFoczBpdH3Txc9jFTmdNi8iE84qKPqFM4qtIkxCKWldjZG8JX+4K/5Z7FbcrWs0N0if7LAn7L7ikL/+LZdRoJo87RNuTaF+ZVWbMqG2yYUzwseTfj7dXauwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KseEE9QJPvzob9AL8KWrlqbE51rMPXKclXu3/WDBTvE=;
 b=TbjBp2kSSs++AYUMwNJzTrZiXnmZaPMHDU4LpKk+Q1iMQyBbaZr4QOwQmzfr74rxl6HDENZpjNgGmxhlZibjXzZke4ymGja9jTvimn4mueJadWGSvgibOKQaJHjb2ha/pG9YHXeHIyHrPLZ/ytKf/iO1/8cWqXN0c47aIQ2f/vrAySJQSclro8U0oNUtz1jidA7z/yYLMK8wrOOPk9fPrazj593ik5Jz4sDENlebclfe1rLhFcQF9vGbknHLnfeMPpcWM4caDlbYakpzhYPUZCytzHjNg/ns4/5aVpVD5pMIepYv2ssaiO4xAVAp7I6W/4hn7jv0LOSPGd6LX7lbBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KseEE9QJPvzob9AL8KWrlqbE51rMPXKclXu3/WDBTvE=;
 b=f/e9S8ls5IAhuk81UkvN6eOuI8/o+LH4/8nrgA/tnii2O0QXufgvHKzCLwscSRtyny/SISj33Wnj3uCpBClSnPr2dkB1mYNuecP2G02ngnF5JeW958DjboDye0wXxdCgfY/agFkDtwxxm0eNNQzs6cox4FStj9R7PiyX/1dgH10=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:40 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 13/27] btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
Date: Tue, 17 Nov 2026 19:58:36 +0100
Message-ID: <20261117185850.4128157-14-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: bbd3486b-460e-436f-e255-08df44dcee6a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|6133799003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261021123027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	Ip0niNj+lKISfoQTlL1b41SHo9wGhDiOxB7CtQCAtGmmH+b5yDZPeMTZNsU2m5Lk9cqR/VGGGoUDlGQEngJlOe7QoEUDTGbG2CJwJ3Ywf0eJV5aJ7Kh1jSPypWmWkZgfOOTZEr5K4sN+dKBexHUBUA6QJf5eMD7or14PqS+jQ8LjbsWA4z3zZjpOLCpzThCpqnky5S1Q1aLWeqTRq4GbXIq+yeQSTTdBlhnACDXutt6FqYo4OGNf5W3WrZ6jLVva+ti01XEbkuMG946K9T1NIAwaDOJE/hTvUuSdWuBCEexSA+48+HDo4W5qSOGQOdkdQoN9bgzSROuJ64/wJnwDjYl+z+D9GMQk1IpV17L43vYP5GkSg4qOCWjNBY1dttID89IFL3sWhNI1r90vyfM7w/byxn3TWSS8kiV1sdoFqLX+QiZ+rEgwLe4iZ62i+16MhsxCNr7cHq0d+Ga2Wv+s+NKFaZ/CWLCIm5Xuh8TfBWjT9ig4vy5S5n/j3ajuRXPKfEAzzKnEim9cZjYCyDI2kODIt2T8d5aBivc6ivpfrGcIq/wkNpYJGY/1UGcmEZ/6J3/dzQIIWrgFqrVaPRGzDGF+w9JrXiDAkHAUwlFCcOn95lNOLIYyBOC9jhBj+y3iSc70SIDSwENbVzzHJeA7Ye+aBtUlmiwXjgZzNb8qRs4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(6133799003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261021123027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j2DvdlZZc99zxAFvxrU4cUSO5iYsJIsvFrypji1L9YsUjz8aoFbZQV+hVxJ2?=
 =?us-ascii?Q?9V7JqcuKiNmjU07ecSqSo+H03cLgqheviXty6SsYAeIjeQ/Itwo8Of6G/nN9?=
 =?us-ascii?Q?TbalAoNOw4uCURPavpzTlHy0yM2N7G2+uvbixL/oKLds1vHmvSAwIm57MTou?=
 =?us-ascii?Q?bJCDy0PWM5VZpV5iQXibMMu23if9OiBHRKl1Siyp0+RjWq1hNEWBSK7yaPgD?=
 =?us-ascii?Q?1fbi9nSoC5QLxnlU5wAZ+t6rAu7OZP8Vu9VhwOPnRufnfIg8JvyeL909KkOA?=
 =?us-ascii?Q?wj5Ck+ayn++cpxacpXNuEkhPB8Kvb5MWK1SHAX9vtkbh3NCnQ1ZUxFWr7qga?=
 =?us-ascii?Q?tzAVhav0w7ABefLgjFRtQaPSv2CzTRqpmVa8NzEAjNZ2zshFr7fwUV5Aj/NZ?=
 =?us-ascii?Q?m74T4FQ0JtCvK3lguuiRfFkFC3j/zX9vjfzIebrCJ77QtbxV/sprLqG1uwyU?=
 =?us-ascii?Q?/fKPLRw6zsnXo10YMip0nlGexdi31tekwntTjgdjRnb8Yirncn8V2/Lp5+Un?=
 =?us-ascii?Q?uoR/Akoozyj9puXp+PCWXVUXnKqRCd2Q60UOHXgqI9C7kz1sELhoqV6dFjcq?=
 =?us-ascii?Q?AAImuAgGCwByYdw5jj0TA7c4UtIFzIlmVv1pPzgOJ8BzsFYd1Q+yKaveHW1v?=
 =?us-ascii?Q?rQMMooyNyUZm6dRVFdUpZCLSstRX/qyHm/gIFx0yqL8+TxZUX+h5+0dOOJ+W?=
 =?us-ascii?Q?YvLIApepp19aqk2GhoSSOnPiAVnz4eR4U1Q8ouYSipx7UxqJ3EkMTV2nqWf9?=
 =?us-ascii?Q?xYbz0rmke826hqSczrTx3+16ZQR7nSohoP4I3RNqXW+b1FDs57knzrykPC+M?=
 =?us-ascii?Q?yhnQUa/9YtePLmiEsKiLHZkfrJG8e4kbYgaYvoEWF8HOQZKRfXWADA+P7ous?=
 =?us-ascii?Q?u8Q1+6XfibeboHuaLmDCPWwEAMIDvzcfswF8rNqoGzDyL2/32kA6PmvHvmBM?=
 =?us-ascii?Q?/3aTRgsVpyWEJsFGyQhc8IPOaXpZApFNo+EGXLn9YVAi2dPWFxjJmZW9wRJ1?=
 =?us-ascii?Q?CByEjIieS53+QTg/TmvHRO5+VxL3w6fXnQxP4Gewwe1xD5urSZ3khD/OjdeU?=
 =?us-ascii?Q?jEYFDeDkaxiXamcO73fKClYgFqroYAL9w9ql9CowoRNhVfsUmQE6v2qvKIgw?=
 =?us-ascii?Q?oKjuL/mIrzC9ZgEbjJkF9QjN9WfuZKkLg9pOjbWCY18uDN35iJJqtLOSzTjm?=
 =?us-ascii?Q?WTL0gO1BvBvRoiaEqhDTcqDfi8qs9iSppub8Pw9OoOGUf5c0/5ihtwvO2NLf?=
 =?us-ascii?Q?0eUXyRNiP/khnetoX7qESQ+kSL6PF+jJs0cKV+2iVdrrcJO2KE6sXHBKQG03?=
 =?us-ascii?Q?r2I50izQLmJUSS3S38K1uSORLri9/U80z/FQhqCpk4+RtQgHoRa/sDrZ23GH?=
 =?us-ascii?Q?vOT2ZHSySgjB9oTJBH/74CZFcsNSFzrFDXyv27JMcfY98EMqk5jMbgvsXczy?=
 =?us-ascii?Q?aDAyDli/6XGwewQakrgSEmVl5jt/vmAuJXNRbGiuoBrsVek845tLD44Wj/M3?=
 =?us-ascii?Q?mkcpLwLLgDti2O0linrvqWkLZr3PLU0DLI2xtpfZoyQ22w4YGB4tnkZe1QVh?=
 =?us-ascii?Q?isMfs95LMfrkkfZpsK0Yrv1yBQ1Ohs8pGUaWcrYFpN5/eiBfma4bVyPu9Pv9?=
 =?us-ascii?Q?e4Spd12s9dXXPKG+TqXJqdbbGC8ZG14ZtGzPOjfS/1+UY5AGXt77BXShekKb?=
 =?us-ascii?Q?aDuObwhgesTKdwjOjXBT5n8ZhF1rwDld4TszOy6XcBPqPZJGvO7guC/PcUY8?=
 =?us-ascii?Q?v430ndyln2xTer9FMK/LHjBe/sgjNeaQ8GjdZ/6neOl/svTl6EmpGlFP+5Ng?=
X-MS-Exchange-AntiSpam-MessageData-1: cFFpXJ9YhxXh3pRXh2ylJvZxVArm5TnvKd4=
X-Exchange-RoutingPolicyChecked:
	0now667REzG+tYCswbh1Y4DRurPdoC8Ta8SZ+pxFBmz0asW7Ibc8Jxe3yx9fHsP3+67rJH06rLtjDVgQQX6+NZhi/QcUfA43O1KhXYFcFu18lQ4fyUfdiSuZoHlLRU0Cz+q5K9KpNeU0umf9RyYGwYRjIuEpfjnz5Xt/npt0e/j+kPEQ6lXg9cu9+RAnlAEmzeEK1dC1MfFvxh/K6LIQ2Fkgkm9AImrQk94PakmbucX8/eNoVlpJoEWDr0m52aIqjrCbn9vlCLtMeO9W1SP74U3dztIJegz8UAtaVFthyXz2Mo4SD9nbr97YC0mKa1ZS/w057tEzLmURxvd3TOzN3g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b40Q2NJZw9V14StYcH7P/y2324GXOXMRIM978z4UhB+64u4wrWJj1QIooOb+RAySsSM2/ZvexOX8Z6NWOt01njd4zKsZHY0KlOoa9Imd7SSV/8Nh2pnVihute9s++WVjROePraQ+M87BytG2ZJOAGL+XQSIK/qKEeVG9vH0ZApxWcXSDIEdQ2n0MtUf8wYfZb0Mijye/6+UBZvLlawnArLBWsGYEq5ViU80x4BFXcWa+qB+8USgcc2WfSsxeyx6lPTBoFiZ3BU5PPd1L1Fxr5T4PW75E5az+aipaVJqZkOm/MfQ1oGLiXyK9xI+Fs1ajm7JZhAhWgwpF626AVkj5Belwo1nOKfDRiU+mfV6tNbivZ4+c4PI0cEAWV6OseXG2WlNbVYgls9ppf+hlaPRS8k6oUaksmtzfaaj+7LIRQNmCPt4OKdkbo6WfX54PnVNnuuZonrbO2fmdTRA0dtp6Twjze7gdxHJiHSJO2Bc0aOSQK+Sh1gchRlU2lpEdpG7nHCHJKpAyt2SrgnnH/0rpGEypQhNe3T6wIWF7BhFXHWeEA+Vz1eBTO0n/vizvu45AY6Dbp+E/E0PTWEXtl4ACTu1aSG6AK/MkJIlyFe1vlPkxoKEW6MHwQ4+7EuXKza3L
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd3486b-460e-436f-e255-08df44dcee6a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:39.7593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aln7/IuSJkz0VY+gdFtzU0/iPmASfkq8zyDE2gAT5of0Sy1QNE0ZBMIkcOTBUhcqiXeVt8WmaOXCDITi8//1yPO6BpstN3NNyUGapPnnQ7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

Now that all users of btrfs_zoned_meta_io_lock() and
btrfs_zoned_meta_io_unlock() are gone, also remove the functions.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index ecce74f67a5d..af03ea8e1754 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -438,20 +438,6 @@ static inline bool btrfs_can_zone_reset(struct btrfs_device *device,
 	return true;
 }
 
-static inline void btrfs_zoned_meta_io_lock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_lock(&fs_info->zoned_meta_io_lock);
-}
-
-static inline void btrfs_zoned_meta_io_unlock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_unlock(&fs_info->zoned_meta_io_lock);
-}
-
 static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
-- 
2.56.1

