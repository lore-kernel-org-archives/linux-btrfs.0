Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941987;
	b=l3Znf74hp6IJ8QzcOlguW03L1ef57a7SZzEeyTvLCUNZsEaSN/DojYYLF7J4UpN3oJtF
	 Hxj+mt7drH8Gh7DH7uXZvCZc582nQ94fm0vdC9Y3s6h9z/EvWwEu41M3K1fCJTE0uk1xt
	 UtiHv+KRV3CL8wwqaDvarV+7VH9/B8evt6PKX3jcACNfjptNUIXS/X4F19Xwzu4cYP7rT
	 GQWRN6ngAEV6l27aZCeq05qe3qpsBRSXGuFoJxEGeGvsJpfKHh3xfqiOEyvgWc4kOmY4C
	 WrKMywUTy4PTWOf7hjlR5+OUDRn/b0iKXUlpIHK6ydjau1io7jOwLGCDVbxk1izeNmQ==
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
	bh=1lLpSTfmRPgdbPbHvq7l74KBxEoaYh5jO/U4vcS8P2c=;
	b=kfaR86HsNley6cvuKW1j/HOp2uBjNh08f3MsbktKu55lj3KQYy4DO7MHBYFq4LUqu9PU
	 26qbOY0i37todXx0E2XNj/DcEcmxUGCurU3FgbSKZIkCdEp1V71l7y0HjeB/67YHrHVkK
	 OeMZ9vKNUCMguq6tN4soO6SEMiQOa1lb94joHapac4U1mtEaqd2bRtJwyzW6kw2x7eU7b
	 X3eNniDq/7Q8t/mMwPFoDJDV1f4r/gEpZr64aZ604wokyJiVqkGU/il6nkqrOuOBH8wi2
	 Nk4SiKiIjoxii3CXvsJaidnVpwshw+9+PXWBciXfYOkPL5ZFj5CmaSXwHZV/SUg1OxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=n9lCv8k2;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=inWOGrwu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1D3606A335
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F1D3606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=n9lCv8k2;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=inWOGrwu
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941995; x=1826477995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=KGu3botvaDNse6tjhu9BiFwntHPI7PNTZsMEWF3s/YQ=;
  b=n9lCv8k24VhzLhb5fHuo6tQibjK3swWqvpG9x6sY2iOGIJ1WB2r1J2Pw
   eYPXlZowjum+dXdawp5+zjCMUdfvarwm+dOv0CJ98mwmXWwT+sWrzr+Wo
   dWAU/xtowzngAIsYh34fBXJ8Rz8EOoFjC7T5sJm+8e4+dsDC5uSB6i/9p
   g4spihQENVIkCk4ICyOUAkURZQIkrIigqZpF6n1yFwdSDVFEIk48Tt8FV
   iHYcAqZL2iQprKA7sBsPrVnZwnhOv2GpjZnvxicRRzNh2tcc4ZJM+hTt0
   u6l2QAieJUy8lYC9Ov0T9NcxCVEJRJtdFTrr78oyDXLK1oRdHnU38K/iI
   A==;
X-CSE-ConnectionGUID: XQ5LlODFSUaJBQDd7fI5QQ==
X-CSE-MsgGUID: nGaL77gjThaJmSjI5EUjRQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160148993"
Received: from mail-eastus2azon11011047.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o5kjt98cGmkiqPlIb34a/jVhNmJIdF2eVT6Ljo+M/8145odxnIDmg7xOx4i2tnd5ITFSNb0AtxikzJKrf1J6irDQ29rf3in97IsurU+nVYMPWMzi50IG6jBpuY6buEsKC0HwE8GdYbsEhJ6fmF211FnjS3LF+9WJ6WOTha3LDWbVd6wxxSKXehgJPVvTVM5BTnEmEloVwhr6LcB0fXcyRgYxf1Ooj/jqFjnh34ArQ2qE1lK4e5lHjrR72I7JVqw7H1esOxLzPmOJ9Drmit3+5q2Ptu8H3nYeknuo3bZbDl2vei6Tg/HXHjwxoF578+aVPZZq37C6Y7VuDRac1rmQfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lLpSTfmRPgdbPbHvq7l74KBxEoaYh5jO/U4vcS8P2c=;
 b=LH7aF30p6y9PTMoDBkSBu80E+5EEOJkpXXGv11PA4iacHRrR+6cG9sj70cGX77UNMdJh6quWyOP8JBC6pmhIUyWaG+mGc9mZ+g/m7DDZKqir/1dahSCiZXKsvVgbu9ejAejdrTeBV3tKoZYS85nwdBGOJADCvNEFcXAKk9QWTCs2nRAOP8s3kx8BsFJ2dl7fu6ulwiJ+jRVBXSaoZu6NeSQbWTTda3lbfEKURd4W18WQDXBiCUyTYGnXx/LsPVf6Jidye/75RbQ1B1wEDIRlXLAOP2/cunyRttSwkHJsK3knbcqh9QL3MWC3iztQhQpD64ERxqgTyqNLeF9ovotEqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lLpSTfmRPgdbPbHvq7l74KBxEoaYh5jO/U4vcS8P2c=;
 b=inWOGrwupEjpmHniOzZcb9rys6yP1TItZKpi36SEPQsrV/fLzxosOrc9asi10bKhRZQbqK9o27jGHsgw6FbVdHGUfCV+dZHhdhAIpTvrnYFsTo84qNStsfSOI3mfprlw3Z6jgQXcxYd+B8f8b5omKlDl6bNuLxT5rv/O9LGMup8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:44 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 15/27] btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
Date: Tue, 17 Nov 2026 19:58:38 +0100
Message-ID: <20261117185850.4128157-16-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6dbafb39-a061-4cb3-0bb7-08df44dcf135
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	eMUCJlA9e6EVaXqx+SUkkeU38g2OlkasgrTLfFFd/od6sNGLNFNwiVUlKAog6W7FWkwTIFLmWxs0QL/EhcZ+3xjEd4+Z5X7b39udsJRFKUlzgYyBxVD7ysAH8A1wUgv2mJbNV2wU1mbI4VYoXIrYDWYuiI5pkLq7h1Hm6M5/aV/xWuFbAwPyQZIzGQxe/6uoMg1DKuW7Z5NgceD73iaJVpBfSP7QpnGdDYs+O/x6xscLLR9gvoj8FCX7izMKvgib+OByo8ulBM+zDJOpi4g4/W5pUBNu1CEM/fWVRRkWXnsxenWcW+/a362Fj2sFL4pEd7YPC6aB6FBJgFwMx/45pe45Dark3qYLporl+pUnhPjFjBEy2NgSoHoODjxfv1J+6JRyzhp9bXOs6xZr7P3YeahM3Z/zEb3tJ1517eAHgilropIN3bSaHwTy5IWrCCyps2AXNuZEaMuxKyItRkU4iyBLhNNMxcPgGBeswdOes4oLnFwsvXMnz/Mby9Az4idkJRBeaXw/aFwGvM3+jTAkuAZLJZXhKCE6x7tYVVTaotrMAH44Y2TI87+ge5FPJ48fsqS25tDWBpiFuEcXZqY5E352GfPGVNxe/hmV4e8gDi8dl7TbhR5NGbHWLBj3OWOGrN800dUabKhp34LmlFyKSpgGl96G8wVEmOiw0Vl/mAY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gq6DAIDlcyZx9lMV83Hl2kL4kf9B0sgnS7MkGwmQElqRpNkAoGqF6tfKUKZ1?=
 =?us-ascii?Q?N4UJBhyh95bdeXWSxqHBp5+BuZyzqqzdV/uKz8v826zNZS8YYxsk9+MCxG1I?=
 =?us-ascii?Q?axpt5YiaFH+BDenvU5QcN/0l7xeuF6qMGpHg2V685eIAmsbTZ1hs6whBYy3t?=
 =?us-ascii?Q?fbadutlhEPpssEgOFAfg5iLFf+pT9ksZ6QaK0Q9MbekXZPplg1eAQdARhw9q?=
 =?us-ascii?Q?nKVdR3Mv1r8+SBzw2jEodEXHFOc+jUD5Zj/p10AlkQAHmDgTxx0MQ7tgYMMt?=
 =?us-ascii?Q?0XF6bX4GptP74TwzRHQyjDhD2Tp4hxVug42Vw6CPNuOj+FpKeqXuNkDn95MP?=
 =?us-ascii?Q?SH7pbcZyJsxqtgjlinHw9tD+8yqzSkw+8WpAmj8STt5mwszkj2J30qpJ/qgt?=
 =?us-ascii?Q?FwyeKOhCPUi21P20pL0/g0N4HNiICWG4UNzkJxo4IESnS+4eQZ6dUydVO4VN?=
 =?us-ascii?Q?OMLV0Q9JMgO7GR1M2q6jXvdAMVfU6rHM86okdaqg4qyAQPgvYNFvWxTdtIz6?=
 =?us-ascii?Q?NtgzIEUfK9+jHqGA0JbUZaOV/JKilleLHUb+dauQrjRpiDb5lUvURWKN/Mk9?=
 =?us-ascii?Q?Q77lpdI49SWcoFPudA0nmfjwW/n5flanXpDAYPvCuc3tIy0gAQOPOXic3pIU?=
 =?us-ascii?Q?WcopcyUPtc0WPTZbRmViVeHI+WqYAXi5oNJtZGD6cTTINDuBcas01DZR3JYA?=
 =?us-ascii?Q?nmDIMn+U2bEMQBFwmuT3QALoJHCdv4RLSRzxwLjnO8OhoOxhmuLcB8nUn9Ws?=
 =?us-ascii?Q?nNWtwyKiCkYdDq6VORBHRwRbt4SIxs75nVnBz//i6SIm2iVuuM4fyH65p15o?=
 =?us-ascii?Q?+orUb5NNmmH+GBh4EMUgatknqsDn3F8Lgc816X+q5F9DYbQIxCOe3qMbxdwS?=
 =?us-ascii?Q?wImmwLhXn0H5lFDluaA6X8mzWzjOSr3/69PbSojFvyOZ6zhOpjUL5gX0gyGY?=
 =?us-ascii?Q?TVw62KvRALehlAKXVFA6Vd8kim60fNxiBCF70chIf/ktN+2BUsMZVFR0yXSN?=
 =?us-ascii?Q?ePX/nSUUqLQVmcyCkajTEJmKwT8EDAkYAE/PZwLxvHBd7Zsrp2orC/CmTSEr?=
 =?us-ascii?Q?/Vci5bxMNx4k5zSAY6fXwQryDR9nmL3x+RfFxnEqy+lAtXr4hd8W9LYW28XF?=
 =?us-ascii?Q?/rwjHXYUP4GAZbf5wpRZR8EEBZx5DHVKlHGI64jRVVnmz7r+STN8HUXFkOZS?=
 =?us-ascii?Q?gJFRh+60rr3MhFy9k5boCVEY6fkmtTZYhpd97HD7W3HKCTuT1+QKjpnNgrdY?=
 =?us-ascii?Q?Y5NZy2aObwFnRSAS2BvJPfql+spAIn5Qv9yi9+y37QHWj3riO+v4YtUjyDsp?=
 =?us-ascii?Q?cosiYv9vuL3zndLxOQIT38esFSe1jttjA1VT1WRp3D8EnkINCR27U7iApNle?=
 =?us-ascii?Q?/8u2bOAOzaOOxd/FNSiuqKN1LLPs6m8ZwTBGYH9En8UsB6r5Ay/6VY08bdzK?=
 =?us-ascii?Q?9TUlbqcTsFahvrUmvlxfpg+puYEem686wZK2NLmacsXj0Eenh1A3VXtwdJGE?=
 =?us-ascii?Q?SW8dZR+TuuDzn9uDDd689+ke9nKxHma9ndS5TZOJW0Qd9zhIe3l1ioP/q9KS?=
 =?us-ascii?Q?+LqzfLS/icW+jT6mhdoASmBjLw1FLyTWfc8PGObpGPAVVB4BNIxRjJeEiQ9a?=
 =?us-ascii?Q?VO5B9dCWvTVPCXzYyq+UU1YSkRB955SbQIfEgrGBBn7BpNGHN9Sr3mQufSbo?=
 =?us-ascii?Q?CMTJJejoW8wWWJbIxpmZwO3qGb2vALsaqGMjj45CwJJuBeP/8nilSV5cmc95?=
 =?us-ascii?Q?AfgN+DDpQKgurrc5dEMZPfpInEOUkYouA+0qh8GkNSOYTwPgcqbp2M208vYV?=
X-MS-Exchange-AntiSpam-MessageData-1: QCGWBYNTDV+wZ56+dZ7FC0ESPykGfF/boa4=
X-Exchange-RoutingPolicyChecked:
	FHFlqXBQQBGcRelbuLtS/+YDSTMo94BLnJMfObgbl41XO1mAdRJAeyX4d4eu+6rLyLf8h2sD1985iRgf5GLbmlu0JIdQ7FW/dzi9ggzrP6bKFTb+yqGYV04QikRlPMvM4D9Ap23WlXuLlwI99xHygsoSFitTiAU48200Dahsqt+/TqKn0ZJnpzTi0bm1D4Rn7Nq6/qKM8xNbOu/rXWtHcfoRZpk8Wuq2j2eo2c4RBi6wSLJj6uCpPlKlxYcs7fEHDAF2bw99oygmE0DkFA7GtqRAuF/tqCzp3kyPWDR/XvoiQJUO94sl1tufcWpPJoj14XhAUscAC0Z0yNl2C19TJQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fyt3qbdZ9ToFpQaGQnhKK6Tk3LdNpuN+ew4fITUu7zg4vlLusS6J9t++PZfJN++n7wHEb/IvflVAFoOp4j2jI3MxzFU6P2xU4QpQjCbNl8PgJEShg2aeZpCm8exO9do61kDpkh+RMqnRybXemczskCU7Jq3fV+5VJ/lhEEGJHd8CUx0ENKTRF80MkTlPhxtDrbB3/riuBk/Qo4pzXJPUKWXAd+sI4HCIWgQj/7cXrBt4dORZU8j/y5Hjt6p87fMV8rb4YN1jh7EBQ4OLRrZl4juKEQ28w1Wg4AdOEIjE7KK/pml6dq+AQAI9mTkXa5lcy9mjzyye7Yr4KPSXSd+isyNTZMBmBPXBuSgu2ke6gsXSGxzEr7bJhnW3QMPQvMhyX1Roax9epSwhP9itS+A7+wp7lT5VP7JbAPH14IH9Yr6Nb6h+k+1ToLrav1QWBjKsRybXDQPUEkuQ1HYDvsE29xHPKYEQRy6NLZM4TlZ0nB4njHZbQ3We+/5OXozar0kHuT1YVX+XtWCC+FppJ0XE4f7Fg43MrrN1BkEHHV9SKZ4bzQQA4KfinoZNsbXzD2rrMbF+Qw7vqyK7Ya9/BtwX5dSWg4pfeWbvNUG6ZNbA1mGMZgBECYmLefeXp7498XxJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbafb39-a061-4cb3-0bb7-08df44dcf135
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:44.2770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKWJYgXSUo4BwT4raw5qUyTrPtsFlirVbURgcWb5fs+zYXZWyllkJkt4frZX7kgy97/J7llr/tb620XXhDe+dTg9+LOT0IHt2fxlODRvbgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

If the reclaim worker is relocating right now,
btrfs_reclaim_block_groups() bails out, because it can't either grab
the reclaim_bgs_lock or blocks on the exclusive operation.

Wait for it instead of failing the tickets while it is about to free a
zone.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d5a84fa97462..bb08294cbf9a 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -913,6 +913,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 		break;
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
+			flush_work(&fs_info->reclaim_bgs_work);
 			btrfs_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
-- 
2.56.1

