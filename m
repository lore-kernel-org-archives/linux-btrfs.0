Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795686525;
	b=cne55eDkyb0K8vFgZtG4NJZLe+6An0MGwSkEaA5E4gbqDw+uuWjEZYLR1y+eAslrQJxm
	 msykyPiMydpQHCvTjRyd+24IZadaR0PY3+Pth+S4uKJblcG3dHAlr8RJfJ3s9caM6XRq4
	 inFVPMmPqwnnhR7Qra4n/u/WH1wxfk1+GWdiZvZw4ajz+luAqMMqEjFp00TSZrqJzkLQp
	 OE8xdote8NIEY9N9/GFfhLaav3fJ9Tz8XFt/rpPr+M7drvkIRc9NWwvpc2Oe0l1dx28Rj
	 EjCeR6vRfcKNjqpAXcVqOYkmAgDiAOEkAZGq61zWNQ/5CYt3QiCkL+HCTASL/YVJNdA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686525;
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
	bh=En2CwoMav3H8eXCtYrIE6MbXJUA1dG79GdJINr8Qs3s=;
	b=obL2b7A5Zydl8Mg/ElXDqunr52iAzcBbzjovBW0BRO0xU9tJ8xggPXqrf5PboVWRO1o8
	 //KTLNP/RcYp7n2OvXAnueC6VknRL5qzh9JYCfOTH66h4vusOuG2NIGE3Odv9gjuRQwHn
	 R0csR5v1mmL9j5d62SlhQbQ3geJlQ88jH18hpIywTbZ9DkNPc3R6DRjd0Mrij3yqbI2ei
	 vKm4FNXpOQH2zIb4k7DTRQ8brURN4cJOj+nV63Vd/ENZVo8342i/qTVQ4hEsZPipiuxWH
	 eU8JRAJZQdN21JeCUK7cdKlK23K4WxfhIwqCLg6BBeLMvMHiWxeXr0bv0vmAGYrWeYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="WZeiq/v+";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=httcQo7h;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3C606A331
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:48:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0A3C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=WZeiq/v+;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=httcQo7h
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795686524; x=1827222524;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=TVwM7el+GUjTzrJkJbNY81GRByAxG+KGnn1ZvF3e2co=;
  b=WZeiq/v+eDmLABC6eyp5fHg1mpBh91RgRsTZBqbzRBAoh1oz3bjFqOfz
   Lon+Qbq6VU5J34DiIi1/W5cco/WxtvW0voCOCX9jgA/grvnG5DI2zeXKM
   MtM3nkoIwSRdn5E32hJdXDN3S6n9vzM6xNlrOdMVJjDR9zmLnYrQ/TCCN
   5y9yIi3m5g9k3bMMJylzSwpJW5bwv9TGfg4CVv+qVWiRHu7qE+wqxLtaG
   Dg/uvA7+cGDWNphbpPXFJ4leZxbTffbmRzhh+HzL7GpG30Kd1QbJltIhC
   bWTx46+3ZSvKMumfoP/yTssB7jFJNkBZJQ40jGotqomsMgGLX07xySgui
   Q==;
X-CSE-ConnectionGUID: iSetHAnzRPuqHLZv2Ooy+w==
X-CSE-MsgGUID: XqoyrZJmQ+mb24ZkGDQ+9Q==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="161749085"
Received: from mail-northcentralusazon11013066.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 17:48:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pSePrrqNsefoD1BewL10ztPn9wxWfS74sNQNyjKnRkub9JYUZMeVkcuvOw2JVUryvIsLerhGpcx3KK6Khx0ML0PsTdXwhVBtdIGL5QpGCrJzTrEgsQIIi+RlrlRF5civhlj/eIwsIWJP8BZkZUwqTnxvh06sF0cVXIxQ5TD4WKB6MZgzcHwpWQl0t6KyjXapsRYn/k1KfNxru+zD9QgCIYN18jELC/i1eZgB0rEuWY7JjVHe3avPF3rWSKBz5EEF3X1SQzBxFNvaa9jENIuJmLPYZ8gcfbLWl8PzMWULVrMpehLI8DFoxq/8dy2YlyV1xPMSU+XP2w5vcvFoBSaCxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=En2CwoMav3H8eXCtYrIE6MbXJUA1dG79GdJINr8Qs3s=;
 b=J6rncHt8nWpQShReJikOpj5bp3imxNfBL6crGa4gMAUCnXggFl+ZaKPfGAzZSINAXXO+dqIP0VdZgULd91+YQ92DtR+zn4W6cPpQPd2G+bE1lerrscDhOQcaGo1rgz3KSb2k+brlTS8SBp1WIyGIrM/uv7NgwHbwAMivOI1Np9nD0aPK3R4mCa1XJqSAkL7UraztHja5WV1E3Xaqu2vFEDAf1g9U2BHj3mQJbMh5qUU8Y1KGGM6e6+8fNzPWFuZpuGs3QVePEBQhrl1cTD8iRgjIepB60EKGIU2QT8+5C+jlxizDtoKaEHVkDN3tnsm6PPzLI1IlKT4VtTOlAiKrdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=En2CwoMav3H8eXCtYrIE6MbXJUA1dG79GdJINr8Qs3s=;
 b=httcQo7h1PSNufZxm1F2jwFaG0/S04DLd8AuPQmlO5QKjMdOc+Rnt7TA1UJzuBNGLQ0dnWwrpupCmtloxUEyI+UF+bvLwnR3XoFp4LwmzsgyTdfI4NSL1zh28JFwB6X4Qx5ATfnRr+siXI3XYjpK2LamadVmiZaJqsbD/+92jno=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB6883.namprd04.prod.outlook.com (2603:10b6:a03:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 09:48:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 09:48:40 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Mark Korenberg <socketpair@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 3/4] btrfs-progs: zoned: add btrfs_get_max_active_zones()
Date: Thu, 26 Nov 2026 10:48:14 +0100
Message-ID: <20261126094815.479691-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
References: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0182.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fcd7bca-046c-4133-1f71-08df4ba2738f
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|376014|1800799024|10070799003|11063799006|261009223027099003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 qCfVygGv4pRMkdg4aYK9vf/msHMGBy98BHW4sgm0KHRBpqOGheUIu5VSqxFQn+fcu5NvwrcOWZBbp6A5upi4Pyt3VvuBl2h1ytuaUL2JSg/5linbZ+mGTv00wNJkvY+ZpUhF1UgdpPmSROSYkkge/6vDapIYu0Vg4MC4PrITeNiHjXHq9CeWljUAwSvD9IbfcS3fruSvA6gPmlVVG+Ojw/egVkJokMXvcNCl9H3jCNPa5niaH/G77hNCs6gkBxf9Nyt+nMkwxWWY2QiqCB8Jm5OllXtTD6awvUN9GPfxzfIXOwFi6epslHQuNSiBdLpUCkU9zq+Ya/MKVbvCS23NSc/bxK18BjdOZjKspsxy8ZL4lPvXXHI71DF41Wu5IGulkvZSK7PUz45lrB1wO8FoDga9pQ6NdqfFwWZDPKJgvljS44o7tPuUUu9/SRMYu7HQtO5J4B13enqWh/3fw3rwoWmBjYWjn1LxaCerbnltIq74kEAK+QjFzPrkpq6N0culWB3zd+Gzxz8Yg98Mm6Tmoo7OIp9a+rGdvDkhPmFWNxHMdBUBVrqnJgn+dKLQ0ZzNm3SJ8TEz20iYYj2fE4TnJ3mcLFa8iAHhFisU6AHei8tzdCMO39mmCdvpu2pXdjNrsDASiehfsvgjZb33R2JFFksAvK94OWrOk9orM9iECzk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(376014)(1800799024)(10070799003)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?QuPjmjAT71QhbzQ0R1GSKgJRIj2kJG2nIz+Bnyz7jQKxfp6xDeDcBWSoLcl+?=
 =?us-ascii?Q?h1DzVE7/imk8NGOJTFhSORd5XuN8lEgWpSqCYGlqUjr3ZdcIDOLA8inTD3L/?=
 =?us-ascii?Q?0CEP1xUi2Ss/3ggQ9/0MybZgjEHto1O/nZAkTwO5LrzZqmaArn01QQpWxJB7?=
 =?us-ascii?Q?zUVcLhLydCcMs4TvWvSH9R2MEi/BVCAUcw7S/hN5R6+LMa8BRXqxoR6KuznV?=
 =?us-ascii?Q?TRd9vu0pDo+t0uGwcwg7VoDrxkp994nGroMvc9SNHY/1zXuMxUoEfvaz/xEr?=
 =?us-ascii?Q?neqZofY61LGHVT+zaxihGlGUNRXwOqVunpg9M2veqd6PpOOg48h4H3Ksz4nM?=
 =?us-ascii?Q?ncCH8FMnm1tJ3+7PmH4zRLDhF3MMiQBL6INNK4VEFiW1pc0/QDv6qp0nC3U9?=
 =?us-ascii?Q?o6+fWvAcipZjIMOJlTxxcHkgp2Zr+R0M/M4FKxo53m6r6nzoa+meBClboU+g?=
 =?us-ascii?Q?gcxxe/tKKN3eWE1THonLusn99XAESsn2gNa+NaOVmysjyjR95yaxUuP8BcXY?=
 =?us-ascii?Q?eaxArawFSXpPvR+yFlLKewDAZKxH4L7GiFeQW2bptrjCyzUnCtQygc4r0mZR?=
 =?us-ascii?Q?gn1nWKO2SML3vDI3dBKQQbul++rQgON1RqQIZsg4WHM10Vl4HxgIJvS0CWbq?=
 =?us-ascii?Q?hCZ/ZTf0Fu2rttk2sOJpzRByPlkUL/FvoBn3JZ1LOBuZ/fygMxZ9V0Tl9xkz?=
 =?us-ascii?Q?y9cU6DQTAgTneB+kwH2DlUTFtOo5ri76AFyUHegVBHGhvO4nEnAvBEr1bIfj?=
 =?us-ascii?Q?CSm/mEjF3hJ/k5NQAJwUMTAkPnpfOwqVbtuscSE05uxAKXVE4ax8Ry6MlQUJ?=
 =?us-ascii?Q?XkTAqfQRr5jYZuU7H4ik8F4r+RZdrBgR3Dsu3CkpADCGF4mmUMx/YUFDxeM4?=
 =?us-ascii?Q?NeKMuS3IH7yzZdWcm9IAc1GlbONlupEjELKZnRliNbXBQPEceXkUViWEshlT?=
 =?us-ascii?Q?9PC5NI3+L7J0N3VrbnIUldMs8Jwbw6b6ANhsU9HmrHgm0eMO0sjYpLmHfh69?=
 =?us-ascii?Q?5AxRzmTgW+rVCVXFq0yhEuCaHE4dqIqH/n4u++KKAnMJcpIOCg5t8mYtJt/Y?=
 =?us-ascii?Q?6IeI7zeA+qSPYxsenlMgROjQ1BXXOqKj/0skkqR5/Gls9XMRlAdtOA02xEpy?=
 =?us-ascii?Q?SzKd6wNzkAXYpKUV7XnFtrGFAiqwMSz+oQTthSkwTscrSQxg+0DZoEqeXU2k?=
 =?us-ascii?Q?FC49CxjefaoI/AhVfJkrWDSHAJNMfqP8QmWmSens/1w5CUQipaZMsvRrF8zi?=
 =?us-ascii?Q?HNDkjPZ7I/nd6TVHLwk6535fPy/zi8lCxpmE12rskD+WJKetHOFIvLn7zXQV?=
 =?us-ascii?Q?sVcO1QE81G8DH6e7TJvuHMBSlzeKP4SUdZ4fnPe6G/F8C8DrHa0FmgrO4/Ws?=
 =?us-ascii?Q?shFg17b+dLHvgIxwau99uaw8G0PS40WA1iu6rz5Tf2JwdYHOosM8i/9ESgop?=
 =?us-ascii?Q?HirNTszdXQ/b28qZJ9eUqIO5a0PSaePRmrUB6z5aibbfgpi0S+WHFqX/SIbT?=
 =?us-ascii?Q?BqSOOBqpldpNfaIb2WizvD9r7RZmsApTx8e9z4kBruzcfx+ZP+1UhHNMWzPR?=
 =?us-ascii?Q?aHQzDhJqwSK1m5Cv1w6IrWdhsj4wca1qI6DgtAyXTcqk8TaTleNLVpuTXWtk?=
 =?us-ascii?Q?u3xfUcFjvgw7llylY/jY4JxU+SBar5vZ5D7kPty9oYpBMYne+L23I2cQl2Xd?=
 =?us-ascii?Q?WNY5nfzIsL43eJPXXjNotY9mDj4F8Pxb8hcXDV+WOqq80p9ZPWzHHjuHV/jb?=
 =?us-ascii?Q?B8Qi6/HYk3yB6JieTlrMQH8K4EPOBjoyXWwTa+LyUnojg4mdaRiSHm3Iz0YV?=
X-MS-Exchange-AntiSpam-MessageData-1: UqmvFrVH9QgQtJpF6HJAMrERy91lVqRBPRE=
X-Exchange-RoutingPolicyChecked:
	itpcXjb/uroZ5y6xCrU8Knj+Yz8BW/xYCzB9SBar1Az/I3WYyrEEmwPnBl5SzYsXqX9aYD6K4KTCNP0Kr51DIRhBRhIJufj8Y58COOgV5SefwdWUHcPG1ERbgBsuMboB1l8YwPP/oaEQOqYmJoTt+qDX/wXjut3/fTjwfZ53C1Azu+Kwkbhu3I+0xd589GgTAgn8UUfltaeZ6puhJmuPRfg3yIiXJjz5ZD7gbpspFaPamkfwSn29ppujnjNNehj3pUOn19pwBDlg0Eg12Ni7WBEAV3+QZqDDfPnMBh+RxB2/fn682zd1n3Q2KWonGogNEMaFgtHNMLtcLm5NciTRuQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UNE+lPm8QrU4L4/4l9vtR2RtW3oROaONrGmgjdTKKG7P1D7ksp9E+g/3UcHpxrv9hRHjX7PK8RcRJLPvXys2XgLV6rN/8piCPQKmfejZcgy74cWcEIr/D0nveo8iq6ztd7zu2vUiKAMDugPyab21ob1/6ihlcQyFp4fHOs8Ci6GhXNxleLWM5sQpMBDtzXEjj6T3o1XZVYvcDYhoFTy03g7ZjZHtZ3LoWdwCXqgtpjzp5eZpOOABKE9gEGpwdnERPOBhtyX1BbDSyCw4gYlbRXTEIJ+90ou9HhMzvZWLPBN3z927WEYrg9IAjNRbSUkABHFR8XOLtSaKIdM/le4HKmzDzBaZWVUzNluAENNj2G7yRvnnGH5fa3dtiprUsPNIhbJPlOhMq67SgWikw2lvtv0Y49uPkR6XJvM72N1afu6BgCrHgocvBHpry/1UMsx5HXah9u/ZNKspd0y09TkXze8R4OV2W/YsDP3YVb/wyY509bbCmrUiK0WbYKsIsv+JnwYSJnaglb9YCp3NQ0p22WTdZTFc/IkfEr9RBsinJVzXZwDT5dQtS7n6+vDpwYD1FybE5nvWBwriKdrhFBsXtLnyJOzGFeeRkNTFYCNzu2APvE2JxwJYKup285D7iZQ1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fcd7bca-046c-4133-1f71-08df4ba2738f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:48:40.6430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QTeG/L4A/E7Qc9BCcneMsPcbtbS/wXQL1CjJFwUa66L/5NPGjkXN3VtDHJrdcxrr7FfiTi/1RhllTl6aJuRYi/iRnklVpMDcNxOsY5tXsHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6883

Return the active zone limit the kernel uses for a device, the same as
btrfs_get_max_active_zones() there: the smaller non-zero of
max_active_zones and max_open_zones, a default otherwise, at least
BTRFS_MIN_ACTIVE_ZONES.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 25 +++++++++++++++++++++++++
 kernel-shared/zoned.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index 48313ccc..d00d6178 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -67,6 +67,7 @@ static u64 emulated_zone_size = DEFAULT_EMULATED_ZONE_SIZE;
  * - 1 zone for relocation
  */
 #define BTRFS_MIN_ACTIVE_ZONES		(BTRFS_SUPER_MIRROR_MAX + 5)
+#define BTRFS_DEFAULT_MAX_ACTIVE_ZONES	128
 
 static int btrfs_get_dev_zone_info(struct btrfs_device *device);
 
@@ -155,6 +156,30 @@ static unsigned int max_active_zone_count(const char *file)
 	return strtoul((const char *)buf, NULL, 10);
 }
 
+/*
+ * Same limit as btrfs_get_max_active_zones() in the kernel. Unlike the kernel
+ * this returns it instead of setting zone_info->max_active_zones, which stays
+ * the device's max_active_zones in progs.
+ */
+unsigned int btrfs_get_max_active_zones(struct btrfs_device *device)
+{
+	unsigned int max_active_zones = max_active_zone_count(device->name);
+	unsigned int max_open_zones = 0;
+	char buf[32];
+
+	if (device_get_queue_param(device->name, "max_open_zones", buf, sizeof(buf)) > 0)
+		max_open_zones = strtoul(buf, NULL, 10);
+	if (!max_active_zones || (max_open_zones && max_open_zones < max_active_zones))
+		max_active_zones = max_open_zones;
+	if (max_active_zones == 0)
+		max_active_zones = min_t(u32, device->zone_info->nr_zones / 4,
+					 BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
+	if (max_active_zones)
+		return max_active_zones;
+
+	return BTRFS_MIN_ACTIVE_ZONES;
+}
+
 #ifdef BTRFS_ZONED
 /*
  * Emulate blkdev_report_zones() for a non-zoned device. It slices up the block
diff --git a/kernel-shared/zoned.h b/kernel-shared/zoned.h
index 363ef4a7..e323baf1 100644
--- a/kernel-shared/zoned.h
+++ b/kernel-shared/zoned.h
@@ -99,6 +99,7 @@ static inline void btrfs_free_zoned_device_info(struct btrfs_zoned_device_info *
 }
 
 int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
+unsigned int btrfs_get_max_active_zones(struct btrfs_device *device);
 int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
 
 #ifdef BTRFS_ZONED
-- 
2.56.1

