Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085777;
	b=mBCEUoot9vY2r/oCiY5CnPjoifnyLOAS8m0vUSjI5yPuIR2Hq/cPuhCBh26ZcsN60U4b
	 fC03p5zAD8CzdZfDqzv1UVjV6GOKTPgeUkplbyAuVztacAvpMs0ACr+CX03OqGuBBo613
	 bAsQlf+BaAQLnxzd2CxXMMjDnuGbpIlpM1jUsbABUhUGkR8sJcTLARWajt0trblRkX4Oy
	 UpM/e82nL200wWHp0oBJ6zfb1DbRe0q3TZpQ8cI225UI3/JJ3jaXDnF39BFFe8OBvn9zf
	 GzHgxftM0gTgdsV56j6KfsYtwISzC9qkoRNk/OyfRqcL10TPcsAvNFEVia0tijSofuQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085777;
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
	bh=LXGuUET2F/6HgHxcwp4oWUyfi3LwpgyyE73dOzI/JKo=;
	b=yq1jc9pljouqbpRP8YKeBU+uIht+bwOL6OIijTa/1xjyUcrUtvznkfX7Ir6Sev8OrwjH
	 9DB0f3a/xPOBTj8JKw1I5mCIlk3hVmLQz/Eoe0FypTh6Xc+JonLY/H9B41fe2EciK8hmq
	 Lsv8O/KTqnx11pyg5wReZrqdprVn5K6mEYVXamTFpyZZvktU+UZ0Ulyj1EIrwBfOjGa6X
	 UeslILr+Bw3tgvAT/V995d7YSbj/tf8KU03LO3LMs4Ae7fHVl5BZNJZwOQH3ZzM+MUIJl
	 P/xUCAmA9AqhYjP0Y+FWLFngxgefWON4vj/BZSR705JP8YmQZiH7t6YEBwZudfzVI4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bhSyGcFN;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=eAJQAvrN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD27A606A325
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD27A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bhSyGcFN;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=eAJQAvrN
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085776; x=1824621776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=AJXm7wcljTZ+WS+4dMOcrCTp5ipPb4cVp1vbaMyHLDQ=;
  b=bhSyGcFNY4n3kUw9K0ZS4Q5F4H47vGh0nyFndnodkIi6EIzDPJLYOie3
   QukANxB5ncYHnwYZKx5PiXoPUX+zZ8S6+e8MoW9yMUMOka5slGQAMUiEj
   HnS2QmMqAb0KWKpJWDedzBXdyeptt3PsQlR3myTh2Jvqhfpl955IOhuTc
   vjkF3/kB6PmUwfgiCaCfETHMhCjvZrv/0FBgc1WdNd4VWehOqR7LTONN9
   wcebhh5HK8JJryHk3qSneSulhFEEOkHJHtDoEdOFPZuw+YT4bonOzMzn+
   c4M3em6UKKhkm1oo7spXFHKG8szaDtuJ+yKpiyE8AI4oMY07MA/sdCz5w
   w==;
X-CSE-ConnectionGUID: 4RHQou/LQPOy3xHau6RT4Q==
X-CSE-MsgGUID: zvwlTi42TFOBrZdauFPzGA==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863251"
Received: from mail-westus3azon11011057.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.57])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ar9HP5PlPPg4/9k03Wv21/SxC4ALmcu2+4YXTYMsh0/dMAmxd1lsMb3qICTEMN0zFnJuC/2sle/RwyTBM8UJCOcFgdX3JeXqMXhJ/7WfsjFv0r4ygspvVJnONPgE7u3APvTNJxydRosf3+lrWTe8jl86mhkPQ47P1IY2N1VCqtkmJN2HTpTUbCTV240cuGNmt+xSMCoI016gliHKApaITTFhAgEGvdw4OTkeh4ieaEStBlnN+uwCtG77Sq9Gi8ARp6JSsjDUbUY4ElzCBcOu47iR4NIPjnWcpR9mGma5VFO4MKNK/dxPMexbH65sNrJePWBQkpbdpvz4CJ3AMqauuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXGuUET2F/6HgHxcwp4oWUyfi3LwpgyyE73dOzI/JKo=;
 b=yBbInovjoKOhLNKPkbCZ8qEfo6ISU/L6SvvEhG8LkupG6nfc6yeJ/ZKumCPqG3MvgkmOaVl0huQ5BOtFXJmyM3I1EOWgTj/N0K1ZPlAHeS3F2sHWox/PNtaHEQG9xQtFnB9RzKNLJA7aDQ5RIXn7nmKn71OGozAEmUBTw0unHSpzKiOEMU8MdAJ+uotU/Fjl3seg51TTROLT4Kx/jfE4t20jJH0STPSzn+nxTo3dRs6hROXx9ES7BAXuMvq2pJg6EFeRS6yLG/OcWEkQHRSban094L0P9MQUQvXOuqHdaYcH9rUy21ZDK+nYA47loP009XIYW32xyxOKugcs7LVgeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXGuUET2F/6HgHxcwp4oWUyfi3LwpgyyE73dOzI/JKo=;
 b=eAJQAvrNMjeIZ8A/z5wpqH/Ahq0R6g0VHGEaA//QmeaL/S0NtIunDheIr23mK4pBA7bLqFTAPDK/onWBWCyWT9QHb5DX9E7s2Lsmo3VXEuLio3XUlaOaF/u+21U8XBLGun9baFY6ptvjOZILoxCfoN/eLmIZiDYBpweY6HN8Iwk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:54 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 07/25] btrfs: zoned: allow restricting the dev extent search to a zone type
Date: Tue, 27 Oct 2026 08:22:13 +0100
Message-ID: <20261027072232.419318-8-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 139011b8-1836-4268-6992-08df33fb1e2d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|6133799003|22082099003|18002099003|261026121527099003|3023799007|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	JVZVfHQc8D9mpUcptc9EGCtQiMjlsbyty3jTa30sJezEiLXtudUqqHWZYYQpOE5pIhshQe2raRt+rlacKe2nAwyvH6Ohl76Xkawu5KV5lAo8aWv3wDqSOlQLyinN7qGEB8p+2adbwJMhyA1xrJkuUlUMCV6BguxhnzIUSVkIhg1KvFgCUZhzYN3RVkdBgxldqSIqmVHFXLXnnTm5GI98Ok7oWGJY6YGiBh16nACnRLzkkwC6kgNxRlTB/4rbLA4RB03EiW5aZ9Im4QqpadPOv7L60d/ybvxX73WIzKrQLccCDG0X7Xql5fGzsfOcq3aAlN/noc7gugDFvEchY3XBgcoCdNT+6OVWKNYNDW1NGzgMNRB4rm6BSC7H3H+nyLgg3WGM2zho6DX94ssx2NnChuipzAcUaxro9bFibZyUFMoidkJ1ZPNLVDW4Vh8jiLa8JlfR7s8k+G07knJNA7BKKkX4hY6XQarXP9QS1i3mONk6s0/+jNlwUUWo5hOEqWvHNr6z6OkE8z+yGUrXOI31P6Pfd+ZNx5GoE18/7631Ug5Ee0iOcSZGhibfzeCSFGtdSN6L/Gv49RRRoX9gEfivwmdF9Yv9bkfq9JTn7fuExIAmv0g2WtnFXMFAAlo2wSOcANshOTnR2km0XQFLE1IGUQt+mx8puLa2Tbm2ePhLzY4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(22082099003)(18002099003)(261026121527099003)(3023799007)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8/9P8QqGJh2oi0pXmN1CDdCl3bNdX2Cqi5saT99AF4a+r5BeRvRghX+N0anE?=
 =?us-ascii?Q?vaQEHO7O5iFG+m/xyjf4APhXNoynr+ziJR7cT4SppXbBG2YaUsm4D+i4ohSF?=
 =?us-ascii?Q?U4iGQ8/WpRAq/7qfMVAU4rokPqFmHXrIsUpZ2h7G0lCAtQqYhtBFuLVFpFM2?=
 =?us-ascii?Q?WISVNaSP7dYcbbx2DuTqGj2G6FmxSqIoVbG4agktA0uTTtVKFXp/WWf935Si?=
 =?us-ascii?Q?l4vFf2gvrGd1TBBI6zZPfl2vlrWIPxNujbW2yS5qUyONyq7T2IgUXQjZwImw?=
 =?us-ascii?Q?HS+up3TBdQoRIIr0Ka0GAEaRCGnWprjfjQlO8Nr3dnTiN2Saa8W9PGFJrreR?=
 =?us-ascii?Q?Dv/CrPjktcDqRgcXwNvFQIOI8ud0F+vVbPLKsbPJY2sGjq6V7fu3bf5EEyaD?=
 =?us-ascii?Q?xiCH/oVTB4wZgEPkGi2pvsMsdmVKPEoJctxcFCpngrBwIabUJniYbCf4Z3cz?=
 =?us-ascii?Q?o2OBYQHVqp9d+93j4wxi0YPzi/LK133+e2DgdEzoo0MHQVLVlB0KlBlapFrK?=
 =?us-ascii?Q?D/zhDGmZiGOBToDDuf2HKMt5RGRRE1/FZE4cU6HVQ1p/J3V+hgtfTOtHI0eL?=
 =?us-ascii?Q?mqCP1KYmbNMDtS2jNpFO58h8+cu1LxBasIytPMGIPKYQ3+XazMd6x6i8HrSo?=
 =?us-ascii?Q?NXe8snACfZsS46Q4QkCUk7W62133+B2/y9eRyr5OZbJjcU237KZe9iet3m3t?=
 =?us-ascii?Q?4ALbUbwN0EdTNbnhziQF7UsnznA4ivu0saa7iq4dNN7KZg14ldxiYPCi8MVA?=
 =?us-ascii?Q?ygh+c7gRQ32H8EuOK7D+rvm6WWFHNf0lHK/7BJwTh6etKPlTbhyiGRw7ykkJ?=
 =?us-ascii?Q?fWlVOPLtXI5qJ325I8+5gcLPwDz8bcIziRQUn5lyRXfcp7oVB0fVnGPrCvOR?=
 =?us-ascii?Q?cPOz5+a05zc8qQcal9i5Xh4PggU0mMnnJEtY2JQduRhr72gjvlrNBn2mO4Sk?=
 =?us-ascii?Q?FVH+RfJr++VwDcYGqRrocqPPgW1AeClvwnwsP5Bd7rBND6Zp2lyBhilyJaOP?=
 =?us-ascii?Q?rZTvsO6H973qVlxq4IDuG/9HBg7aDbagtn4J3Z2xoK080TF42+e5dOb8LQMc?=
 =?us-ascii?Q?FUTPw6ygIuav57ejTlqZHpisLXevHWhVYJll9i8w0agT3jml80nIl9N0yWol?=
 =?us-ascii?Q?pAIfXKFtEInO5KcQjZGzTIHZKFJDJAJfhVo3xc+gLJGzjHeHWgiG8mXE5nrz?=
 =?us-ascii?Q?UbBkWb1sBBGHaH1nnJPA4AoendX4BDLyibP9xgHaYRmFCF5g1W7h/AVIjqtY?=
 =?us-ascii?Q?EM9Oec2EtJxGNHVPK8JzpFKxhKoVWGTfIXwxpg6HW2p5/lKIA5ouRSuHDf1x?=
 =?us-ascii?Q?oR2yFyIpvXqx9q1Es9RmEXBB83ffgP3diFHO5YftveN9QeEs4SWHG2x8zQZ8?=
 =?us-ascii?Q?lbNf8aRBk8rqIncB4T9RZHiLRGoPXQdTZxH/3OnALwZiouZTabdgTIfiB7Jl?=
 =?us-ascii?Q?HG0sZ3pzEod3VpsjKBJKWM1uDvk/RjXdwWpR5PXWVGeS+nJQxL7pL65gdfeF?=
 =?us-ascii?Q?EAK0iQ488XeurO1owxE19u7rJuOazxY+FMSDLbwMDUoCAzdzwMsN617zO53S?=
 =?us-ascii?Q?/MBNAkg0AWuVSAQa8LomcSvY/4sjwTygnvUMOebW4HMiCDHalnwsKRwrBpsB?=
 =?us-ascii?Q?mzszdHEy5oObFko6+8pd8oy/aLsMuGNDtHbFHNZjuKwT9Ljwyqj4r5eLa7pQ?=
 =?us-ascii?Q?v5lKd0Bqkrv5gfJ2vTmfMHU99UBaJzuPLkkMvKC8Nsa6/SCPsoX0ejiBnXkd?=
 =?us-ascii?Q?uW6CwQWfo2ohOgSwx9AqsA5/E0XAIaZkQ22NzqEftfM0fu13qBED+blfm1l7?=
X-MS-Exchange-AntiSpam-MessageData-1: xS0eCS7aPKz2AIg0DngwmmPWBG9njkWCc6Q=
X-Exchange-RoutingPolicyChecked:
	y+/6fwv2ck5KNyxFmvKlMXJQaNQiZ7GAciXWg5pNDmx+p0lg4SuTnlLUD5q93eDI8gQ7gVGnpeJg3Efz4Dw1tCYozkKmJpppSTBgmZipwdgG/TIQqG/B+ewWILGIuH5nIcymQOZNsSRa1ya85TEe7Uxn3Fu6JdR4y6WCPxJhSIDE/mcX/Vgf3HpZhig/x1JHiuQuXq/HfmCG0khcZdrP555xkmrIXZT5XoW3ehssIsz16pCrKcdt7/SFOFLQz/56PHGZIMUnHSEFa4lzZj40pLjPPJX8mGrJRfw5Zwig2MFgzChqkC936ydOA8Fpv+4agiscK0onCmRhCWr/+mNo4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eF+Vf9U3cmDLrN84ypY2Z7cJBLtr23ax9uWwGW3hToei8e+2PMMo4Y75GnhqITgGy2qZy9r2aTGPV3KAYLk39KUc4/4MdEzErSPtRzz1R65xGtStvMdd5UITJwczRGZZjA9J3CEOepzXGyUknYyAUWk66OIvKIWP7s64XNQ7XYYtG4hen6lW8vEJjvAZT0SuICnaf8U8hJrNBEtybFEL2SdcQvzUjtqkAwnPHSiv50PP9iHBlNBqwln+YomCa3htMtPwYeL+ouklWAUW9OGvkCApYkLbRUfs88VsiBflCWguxNLvXXHmMXWSFkKDNwLYmnfeoHqO0EA1zUijkDc/hdiYrHncCUaG/QAXb7RETe4++jTAYeulETx+1zEQPbdcFu3pzA8jy1qahszFOzrMwGzUdMga0P0BnbWazp+PmzfnmRSQw1CzwquLfrTJ4HnW93t5udnTkl9jZCEqN6s4xlxX+LCwp6EtNG9w+ghMJ9fX1ujeV42K++HoR1NJP+Z3L/JW2yesy0JcSYVJGiNCqowjl5IJBfJlEJingYqOV5xSLZxdSc7JqZGtuRE3ObTsdK4umzUHG64rdJKNECsbTlSLaw0tw2frK+VWGo+9PwYzG88KH1IC4qjaviSVrZRm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 139011b8-1836-4268-6992-08df33fb1e2d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:54.6805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77irz98gbzSTMcsGgjx2DONSeVJP5r/TL/iZZgkPrMYMsDPUCubjXQ2GBXYTJWwvEz6qcC/EFahnujL/0fJMbe1O7G9eeGDY3fatSHFL78I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

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
index ce78a9441c64..1fa4ee803251 100644
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
@@ -5928,7 +5936,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail);
+					   &max_avail, BTRFS_ZONE_FILTER_NONE);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9b632108c117..6d9ddeb80310 100644
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

