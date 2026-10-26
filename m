Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031029;
	b=b/9KzOrwBvsgbjXJifI/rj+K3pk7N4nJXPvUpM1nFadMp3fsXH4MvD96Y6SAYBVwFc+8
	 fu8PWRT65a5MG5olqWQd0gMMv+rLPjKunNGgruhEh39wJva1jKwE6xIYOBahF9LC7Q0qU
	 hQAvH2mUeevzIVaf68BwriovwS7KKysRAxEI0w+P9KRGojUl/EeZPv/RHCo0oL+I8gSfp
	 8DEdoqlZGkxku0OcgQe5OJ13T10wsmNNf+RaY144We4peYAnWmqG4HErtYLIM8wWBVfu8
	 LmDAHNvCHUUEcptOMLlTvzOzhJp0hlxFgaha+TFGVHy4fzJluQFQhUenTU4VmrMgP1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031029;
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
	bh=ugQ8zF0dz2/8QxN+Ix192A5BgP0x/tyiEqD1SRzTVA4=;
	b=N3Vk/1LZbW9/JC1fIQkYWtcFiPc83Ls1jXd3/gIVAgyFVoVn7KgldA4J8kCv9KxiJBjt
	 iW/8ZdTO4wZOJeGIXOkk2l+sRfPMBQWGya9HKYnLbqxFDMl9x/92uFgeBPjKhXSW/gaht
	 Iz0y0RUkwyD20mgA1peyxMpzkAPA8vdtTrrT2UzePOWT1/7SsXyeOHxX3bPQnL4ZEvSxQ
	 +X22L1CL75HCNVlFiHUd052Gl8+H3fnGsdOcNqXSpso83lfqbB5LkPrlnR2tG/Raqoziz
	 sl8gL9Qt04w+SgRGCmDeoqMEygaDRuhE19Ck4tFwojVlugj/71Por1qhKhl7h5dtxEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="E0czPi1/";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mrhvfbQM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30D6606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F30D6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=E0czPi1/;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mrhvfbQM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031028; x=1824567028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Gd8jjfyKsxMvH7siacx2tuLczabGE9xfumH7+wvkuIU=;
  b=E0czPi1/9XzH++F3RODp5u58dgaiFoEbTP2fKp64wFd8r0JavI3kINcz
   PGqS+8Z0sI0LmT2N/3xS8RkcXnCgtoarVQcmzRV7fM4QpbovTHlMP3W8G
   KQ6Ibi3rqPSeMw9w4XD1op0ocGGSLHluOSVqmz//6nluYlXAigez+rYAw
   6pOGNKw3WzCEA3m7JhyS6a6nsUqcHCZnDsb8sQ+7fIa6l5im1mzPWmP9n
   AnIkWGKb2hgX0aUCHqGkIpN2XwN4+ke28GCtsrgBfgQmvS583wszTsZtC
   QIjnCBNVMdR3tEQOI0UOG2XFU2XX/ObrJP2hSwf0NzWEjSJLtr/BM4vO1
   g==;
X-CSE-ConnectionGUID: F8vSsjAqSryi7b80yp2znw==
X-CSE-MsgGUID: /4vcQp/UTvmVMFC2v5Sadg==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158929294"
Received: from mail-westcentralusazon11010070.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=anju39/4D82uu3V7s3k8SvIYYLgx/yoSxCIHp0kLg0oH/jgyH2qTbVA+716oL3auurS87nzbTslfYJ7fuzMsnf9hK9DW3TLH+K+x/xuXumMrkFX5YvSfexE1dstNk59bds//nN5wAjvP+3lG8thZy6TfghG08zxW0o2zWk9t8oIVgdyuaW2NnLBn+aeK7IaIxqPC27B/OBpYocGV2/dtALewAXZ9GEX56wEcsmm9oteiXgqiglaiUpCBde5Tmqym52k3mbVjBnOZLgy4sWbfv8WIqNcikCeGR1errt5D4R0zd7+1ixC60yMKZBG1osXoZOfHsJHEmCKwyD5X9G5D4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugQ8zF0dz2/8QxN+Ix192A5BgP0x/tyiEqD1SRzTVA4=;
 b=ulyNk+6bjE9N4GqR5LPQ98iEEmbvCxa/sRMzTDSXhmipb3fPiSETI8a1QtNwPx7KdpvaNgPP/NyPSbQtYJBR3hRxrYVSf6unkfwtJ5zdCxXaUkwhlf2oyzI8sKydXBz9t0fEn+dR9VujjAPV7gswHMtJvFsXcGUK97a5h8OKsuLENksFtvtoU/183EfFlLzK/AwscQuQ6lVi0bgqftwXyWFHTLOOdhhKdEr5gny9n5I5asxn0Wszwvzf6xVAUwfnk9oTyzDDhLrdI6YMXgnxgIJagGDXBUf4Mnvc3iSQqBlWJbTB6q8ERu4iBdZweVy4wG18sS/21TtdGu7YvxRtqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugQ8zF0dz2/8QxN+Ix192A5BgP0x/tyiEqD1SRzTVA4=;
 b=mrhvfbQMYBm4sLU7uiFFJZ8SR+VvDWGG5kYI2att2foo/Nd838hALfN02/uVR51OPAmgKyNiR/3kxPcIq69Dm+P8Lo0qX7+Nv5RJkebXdwk7LNt9L1ywmLQgj5T+mAJcS1+2wzXFVf8zuLnQnaOyE6FKpC6MlhjFVVyX/K95rec=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:39 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 07/25] btrfs: zoned: allow restricting the dev extent search to a zone type
Date: Mon, 26 Oct 2026 17:08:55 +0100
Message-ID: <20261026160913.207909-8-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1ed5845f-9db6-43b7-e902-08df337b8914
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	N9JomaLfUAzZ4Cy6AMZVEhHd0ZXTbfzGj0nN+zgN0j4tRoqXdn6bMhEgQvg82hf31tFgBgU8TLOIf6Xg0WJ0NXUGgheO8N+G0Wb19mU99AzDF3kpgGXwVXMzqn6sj4l4DIaFfSeQusuR3PF96llsb1fxVhmhXkC9rIuWjEd6E51sd365iahSuATjk1uCKy8rkBvJ5l4wYUstgOEH0yOKoarOZGuRxsOkc1r2UkEq6x8wqWgST+Y5N3Ny07vdVj9DdPKa6/oqjm+DVNUuQ6gscawGtHGaBRB7RE9MHAQyWqyHZDMlmayKrb7g9nYhmiMbKWTwhWbjaiy5tule0cMZYxdx6X/YKz6EPq7tImV/PyBk5QHf6+887gskI/yLWX9h7YyBO0rIOZ7Eej/Rea4NU916/BLR/5CepXrdPfTKHXvNSiqX6wDz2X+HIqijJibg8Ksz4WjjNv1klvoYiyOhaTUUTxrY5MvmMsPW8Qb9MpUQRp9zhSRjkrjQqfHt+4gGindz7+KlCuQnyn/9mJZSwDE7eIdvefrOm/kGCtDKY/KscmhtxE/cuCexMdaZ0Auw4BBmI2oZ34S08RdtIT6AOA5sAF9mnm/2vY/w6sx7H59eERlqoPIpFUY6J21rtP38ghtEBk677dEWhVPkkuvJiUlQE1R7cSmGrf2vs1ragQ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pQxc9FLuhrzbDW/FlEG0Z4pK4mRBHFYtu19I7Y4GEmsaZz80gXVbks5YbJFp?=
 =?us-ascii?Q?Ur+GysXThscJDuyq1QaD6MCkd+ercoi4zMLjFKIk3+9cZOg8E2knus6hDboh?=
 =?us-ascii?Q?5wLKLJ/4y5vOyHheewRhz/SullomrEEbzPGHZKTZtq/iTgJZPPJ1zFFq9mTj?=
 =?us-ascii?Q?7lkM0UBahl2yzxhb0/HLzSEXQ+x1q81fkgt+CmzWnED4S6adqXGS1vpSSEEc?=
 =?us-ascii?Q?dg3nNj2f7T/1PjD3l6eUeNi4E/yI6sgM+/e804rOD12Jgzw/1fz5TlRsA6wT?=
 =?us-ascii?Q?52wXMLwpsvdBnCxBPvgp+HbwTe8Dp5nqgFErJAqP1Lv+2nwk+WWay/bA+RSx?=
 =?us-ascii?Q?7hi4jk9dBtbLRbMfP4ycA+mzc02ujrRzXt2dEY45icJhOk4cwWfk15stwiuH?=
 =?us-ascii?Q?1lEElAXAXfRNpUGEUYXOGctj+PiHzhR1Y5LeaiySt2C7fPbFA0HePZ4LWUCW?=
 =?us-ascii?Q?7CzZMVJ81PyJqOfxxmaZoY8WEw/shhxq+gonZ9v14ubTwBnnn5S7l/BtFAiE?=
 =?us-ascii?Q?tBEWPZyjS1mobdNUPLLjqoWhJJlyGW/yNy1WNXxYVfcOmYQaH9MDOAUkbsDJ?=
 =?us-ascii?Q?CAIrVqh7jElVTUrfZ2HfwlNQKVJ9CymOSnoz0bk3pq4Sk8HT6O514XAn/xzM?=
 =?us-ascii?Q?+4OfMufER3P4oLkjw0C3pK4OvrcXE7JszZYk4LNwJyJDst/btuC26VQJgvmv?=
 =?us-ascii?Q?7oiUoWY7fozRAvUnxjBoeoQ2pE/F32fx94m843c7BqITPPQrFGVdVOSkiJUY?=
 =?us-ascii?Q?o6eTaJXMcd6OIfhJAoJIx9h2D5LZtV7+rS544Ftmet6/Q0UbFMAzZoiRavjS?=
 =?us-ascii?Q?MC2kAsV5PnZu0I5ThwccDM7pa1MeBKWgHmB2fxJw+kcksRo0073LnebrYeLo?=
 =?us-ascii?Q?T7NFEsiKkGS3raXUJmYve1+sFpFYD81L8mizR23rw+uIgafRbdt3GvU2rHLE?=
 =?us-ascii?Q?VcxuQ7TPBMgHG/IfxP5vk6W5480+5UQM7ahsNV5jwYTUMlxO0GeCi87ZqNxc?=
 =?us-ascii?Q?ooH+FuWOunjquxkvVqe6x/c3wi8LGLWyiV6qm5O4Fy71Np8SAuJ3+mnpRwDf?=
 =?us-ascii?Q?WD1flGMEkvxWIw0LM+UKjA4wOsKYQpV2bP5PSdAtwdqf5psu58yvXXj7jjTE?=
 =?us-ascii?Q?dcNP6/auHFTKPjuT0900m78D4fJMaFan3qDWpp8BNJt7vL3pd8a9jeQJBlh3?=
 =?us-ascii?Q?L8/lVegiuJwNLd7B95jU8GKhTF3ga8KuKCDliXLIiPuxFvIHGiAxyNmcATNQ?=
 =?us-ascii?Q?1EdvljDwwm7jCEM375FBpDDSK/wvai3t7rCVfLAE7B7D0WzGmpiQ1P8oOkUc?=
 =?us-ascii?Q?SrKYRfJowmr6j4mf+rvJbWa3ccyFSOFQ1Nb+bIPaGjmEPThAmhQkbmd5/Go4?=
 =?us-ascii?Q?x0P0Pr0jeu+jmwi2oTDpWKOWdVQw2d+3VIjH2hfLlcn2xI6VcdnBPtT/nJnZ?=
 =?us-ascii?Q?VwK+PLYfKPJ7ftBkQ36pqVmjkxtHclhjyLubR4eVaJtkCqcDTJJE+U9wO5Cf?=
 =?us-ascii?Q?gwQ0g01RPbp6fAj2gYNsqTiWFeHEgSOZ+lHgNVFns1FalvNN04Uwozf1hfyi?=
 =?us-ascii?Q?DI2TU4L3zfHQ9YgLzHCKLQo+Ch5IHRtTLfirkjYNg3lz13lbX8YO/p8U1WWn?=
 =?us-ascii?Q?Zca15IP+4ZhIZxKRvyUwaWx9lprXzr99rYQ+hU5r3KSsbAM7TEj5+0+P7vPc?=
 =?us-ascii?Q?1I5dSt0MdtxZxgk9zGCt0Y83boQCLi0yxHLpcUBvV2dy2be/tgdJ5BROXvHH?=
 =?us-ascii?Q?+X4KrF94lxosVIEtXFpUenG2nELNPW8OXau25azSelqvwx98st8wUiItPkL7?=
X-MS-Exchange-AntiSpam-MessageData-1: VPZ2s7rYZbXE5A==
X-Exchange-RoutingPolicyChecked:
	dJEDLOnzQjZ4q2rrKyOvmWsJfPywKwwZVVj0Z0nmB20HSb45WRBYO/wgNZAOK5AEijDOpM/LhswsV5oZO779RoVkLCSIG7/qBdKqiyO5+7SN1C6f3q6m2JKTL42G0utBH9ZZgxiLKBTGeo7ZWmolIJTpiL0402xNxpQMuKEQGjgulCtH78XQ4DZxDjPZWnUVAKeHf0V5T/MlOmJ+nep97m6Ps+gF+PR5bs0nk/psVsmJdhzsoxnCT1v7clEpxSuf2DYG85FAN5g8uPyzQFDWeuNWsoGPyvQ5fBtLSjSYbubcozfL0eaC7T16J2j2pbyGJorAP7UyL+jtE2nBxU20rw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Oj+eaKL9ifI1DRS4AyaYYg5zAmRCHkL5j405L49jDyICCSVvlC+YkZFJ+DAcK9wGSFnWQcCNSSftRYyarUMKoXBC6GHAYvpvLdk4j0sCML5nRRg9DQ04aXRFtmKYksCBsSCdltpfGEdpr9pFYas7X570JFRc/rOrtOPNyuKOUK3l5razWkBZ1xrvR6Y9P66CSNz2pBUbSPDOTekFlIGcoSqNLX7fwdBcQfWRjmvZpvdVD1kbHdKMKub/s7ou3Gbdv5LmzEmmr8kJmredf9ljYUKUaBztKJ9mdJ9Y50Tn2DLcqV1c3jo/y9BqVrViKXxWtf3gpmwgzSVt34yuIZb1nbooUFa5iDtK0JP+SdpSUYfKG6cwUgDKIvZq+PGX5+R96tteb6ewynhmDalSK+RQUVBGhBGG028ZxNaE+dBHVdt5nr3kGggsOdyaK2MNHq3ZBgGTD2p/AXbKcxvtigaQB3UCFWjx5IHlpKpkBf9RECksazRUTGdIsLjxivr3wRmLA/9IcMh9q9p4IDwfOWFaQ4gwsbgsdjG5la+dIw7MY8C1u6IOAo9FX9uFNdhU45agtNgoiJZwdimdupgqUnRcJiLiQXac3m3i4aMn8EII4FUScUHuaHaIiJ+WtzADrope
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed5845f-9db6-43b7-e902-08df337b8914
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:38.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: id/ECo6p3MZvPI8f3dOk9mK5mdKBCmlkmNh0XGaGdTtBNcbSivNyCpVCLqxp0QqWHlOAzAT/8DZJR2deU6ixjioG+QPs1hXnHadPg+ZtTmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

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
index 42c9b120cd0e..e60578abcba0 100644
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

