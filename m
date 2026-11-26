Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795686520;
	b=xtBEVKc/cAb77mKtYDF22mKFOVxWL5D/XgroSI0H7mT6pqGaly1VzL5Y6mHlNeLX3MLq
	 7BACm5gFfXI4ii2RikaxP5dPRgs+z7tb9sT3lfh6WeZsVB/pzAY3LP0nCoiyioQ867JHB
	 C4sg29gChNTxaOApRP7lDYA8OZntznkZ5RoJI24AVV7FDzz6AVRW+JEqq3IeZvBu+qrZf
	 j5uQC7b9h4jeCuOXvXt148/rkwxGrI2wKgwCro6SqXVbO5Wdzei08BWbGSZvL4ZoGOm7r
	 XGYjKuolqMSCefToKL1f1leyxljPXGtjHzszHsYYjwpiGQICYOFFH775hbg5SsEW9fQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686520;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=Tm34rvbG16fChPu8yubRnvtenBZ17JFfyl41d3cSyQk=;
	b=mMvGrmFjHWEXVxS2y+PfaE2KtXBQHmW7kOub8Tqiy0dGO/RFOh7t1C9e+R3UVICrJ1N0
	 18Pl4pjb4o0/xogs6qUmVfS2fR2iRW+hBkTu8XhGCccsq1Agq88APcI1iEYJ4Bc9E3dZy
	 I9ibdCzlO7XFrUr0WJypVmUHBnz5jjbLE58PORdwjzAJlCh0U0Jl2WrzJZDdwr5qbIKb8
	 MCWNmS7DClZbH1Dic3zeO2taV9jJwNAYKpHb2kIv3wJzNApLhYX9t3KlJjIdAWgR2IIUA
	 yRqLv/EOYX4i8GUVkdNJMEhnLA1HnuEMgPpOjrFeww60IL5byqClcjQF2GLM/7sK41g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=CWLhfjmk;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sKd4H4fd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F83606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5F83606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=CWLhfjmk;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sKd4H4fd
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795686519; x=1827222519;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=yweOJlzauQD4yKhuBzw26D5Ir84OwO8dqHt8Mj2upnQ=;
  b=CWLhfjmkq7NTiDfU7F/EArGXFXRiNW32BhO0/Z0T0Pv8AdX6/t7HcYa6
   ryyL1Vlk1MwYrBa9VA36H9k6+W72BWID71sZ5MhgKJsxo6784z41bFaFa
   eZn4bVlfhgJMhnBmGxnKV0c8vBhdmwDAlE5IPu4cjdZgcOnAJf2AV4ehv
   NdR5EpE3JWiR5G+yLs3w69jCZLlBfN+PN1nWqIOA8IgUnwEFr4g9yjUJm
   A6neHSXsURgARC3rBBLGR374QBiXeZVWSFaZSw2hMRVg+0Z591ABEUzpE
   cjaZH1xRVa60Zjz5SAyHuWfNO1sFmRqcPDnDdd0Dg3N6ma+pFIVLLyE6l
   w==;
X-CSE-ConnectionGUID: FECyNlP2Q5qXoaEn5F+INg==
X-CSE-MsgGUID: 2UoD+ye4TiKe5fro9RPxIg==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="161749070"
Received: from mail-northcentralusazon11013066.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 17:48:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdQE/pkAV6rcYuCuX8G60g8Qj4mbU5qrRpM0aqAQXkukB9op+cIDCB87n3mjinlZ/ZJptEWZquuN4tbI9zbi8QfzuT9oTXPbm79slwUWEXzvxXSW4zhnek/CceZLCqRNzeRBPxq2b5LO/uOP/FKduLRV9FCsQfjhrcbOTQGKy8mdNNclkLn2v6zW/YpvCj5wBw1ylgDLCUWZqpj8EjZXflNU3bwcEfEqKdnzx74Qal5/BBZlBp3uvbYGO/4S3V3t1jLBx0rD3mTI1g4uw5S3CUEDGDDKA5hgWbpqyQ7vg2wHOZH4PrPbisPwv6BoPpZ/JSOLOLDUI50hX+ONhTNfaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tm34rvbG16fChPu8yubRnvtenBZ17JFfyl41d3cSyQk=;
 b=BJ8/wHyUyc4CSBlMCSVpXbHgX9fSNzSxpXGVlY4tdQUV3vtxdhIOBGGSghPaRjGSLjyOIF7eeuD6GOE23XBkAgVcxMUJ1jcFnfjvv9Fk4d39lpXRUjFZ1rEo1Ju+l5dGGO/DV3GgpuF1A0aPtezz1rlG9MhW+3K73CynefaUdtFyFhmgPd2IoWD+KqLnvoU7SGHsSQeVixjvIEGK/k+a7z34M0IvUIfvsybDdzkXmOAZ/QX8ByYrRp3KomW/RExXuqs5f/F1P/Oas4pK63u4ER8+3+4nsII53ckwH8PEnOsePAYBeuskh5hxKvHNISPdHbF4ZV6AcNrIvMiCstckoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tm34rvbG16fChPu8yubRnvtenBZ17JFfyl41d3cSyQk=;
 b=sKd4H4fdQkVQu28coF607ixlt+X5cNlnIJ1LcnbY2wZVo17UqAWMkm7EHpcS9ZgtdGob/Vhzq9yox3xeltiGYGmILsBd/oTp3p1AqI4oR4BLp9jh/kGgn5Jv2Mjba6BYayYVoy0zQeUyFSzMks1pTSy4y7GRhIMCpY9yjGp7k+E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB6883.namprd04.prod.outlook.com (2603:10b6:a03:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 09:48:35 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 09:48:35 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Mark Korenberg <socketpair@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/4] btrfs-progs: zoned: detect and repair FS with exhausted active zones
Date: Thu, 26 Nov 2026 10:48:11 +0100
Message-ID: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
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
X-MS-Office365-Filtering-Correlation-Id: e3d0abc2-2c31-4c9b-5cd2-08df4ba27025
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|376014|1800799024|10070799003|11063799006|261009223027099003|18002099003|10067099003|56012099006|261102123227099003|261028144727099003|261026140227099003|261021123027099003|261022105027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 SZtXDQmfWHswDY2UBPSia7834cpcDx/dD1x9SKUi5DA6hiAPPOISuf4XyrN6i8R9fGhNUNTlRWlLhK2FtgqMf9W8PSUAT3TMoEBAQDcL5Sa9anAtaX3Px2i3Te7M3mVweIVEE/NzNIGQF3I5i5qxn5H6dzAANafaCEh+obaVjL038jEv55KizAQws7oFufShQVSh6R3XqNOoYdKVI36GwH/mFeuahtitKJdPnpn1Cvj2/yAEHN17sGfHI5AO6k6/8SbNT8K3r+3ZjX/23F+EFDi1VIoBoRgxsN3RhQqf46vqAdaUffZkMAlxRm9ykAxSZunAZBjq3znL3iXQTxkO+iBuAFWl8hNv0D29jjEwDO+5Ojkr5eS1bdsupXcZAuTtNf5zftU/vQS9wBSXhCMYo2q8NIJJDNeZyworOWpqd8wySQlnAUrseSX8CnRUuGHMesXyQU99jIVVMrW7neztUFpn3dWYITq5wX/3PujDgjkJ6OgV+X+fIXPWwXR1Sx8+cZN7wEDZ+P/df0ldxaS4BYbLQRD9C9Ew/6Ycu2YstJvI7BrRDOYha6PlNsCl8nfcDMMUg3j9qCkFUuCdbGL0sEdYb8yvrIhs9t0xDMTmlc8js0GbKoO12isq4s5lg7NnUux0rrLhzz80rZwfvAvLl5vRt3/QATKUyizcWEDUJTo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(376014)(1800799024)(10070799003)(11063799006)(261009223027099003)(18002099003)(10067099003)(56012099006)(261102123227099003)(261028144727099003)(261026140227099003)(261021123027099003)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?j+OVFC18AgBARzY2cffOh2tfEW/gbK1M84fyTm4DD46NgYnLI25VGS9fy4AO?=
 =?us-ascii?Q?lNEim10YAvAhiyzd+uPEiiBuI7Gr33yn5gwWoHavua29sL3PMPXJt4eS/h0x?=
 =?us-ascii?Q?z3m0Sht5RT2pdbuYcvcByd8sq4wfn6tvjUSZ+LbFwjX55HIJQEZT1OJt9UdE?=
 =?us-ascii?Q?qVQoCIg0pvk4PfPK/c/kG8PRVEFAniEh6kBepw9VjtbsQC2aMFnhWFIQoO6N?=
 =?us-ascii?Q?r0dLkZu59rROLoAIM6sEaH+Y2Vp8MFlGA3sNWgeD16GTuvI3byZuj/7lPJId?=
 =?us-ascii?Q?V968G9Fu567lgP0H5zN29GBkOMLFZIhiXKXGFXBVndfu48V/iB6Swj8EYlmB?=
 =?us-ascii?Q?vJod9Iw/yTW68kuMMjpNHJEGbuGYMrNP3h5MqOelR95Gj6cMo9eCdoc23U+D?=
 =?us-ascii?Q?bxYHUnXuYjaHoxG2lcDMV5UoPhTB1/Y2atZ8kHHEkf58vMqhFPMskEQ/4RMM?=
 =?us-ascii?Q?cLJq4buXKrUvfv+aUN3mzrei/rfGHJvhV78xjTrDiBeg3AtS0zpZfHS3CA+M?=
 =?us-ascii?Q?6pweckjJaZ4ycmrkfuxgPcKkEiL4vFdagMMyoh+V58diGiOdoQaq0lShoC0e?=
 =?us-ascii?Q?hoIheGlnY4T4SDMaiepB7SUVDQymAD4JpS1EXF1NKwkXIrp6R+hpJSUo0+ZN?=
 =?us-ascii?Q?ntNNkXsUUNQImER8f0LOyzaB8M4cKZVvKmCpBcID+BtJ1acMj2MIOaJc8GOg?=
 =?us-ascii?Q?Vqu83+zbcf0OJm4H88b3F8N2LB20t+lik4XBt7Q5eW8XuyIaPU7RZ6UDHyFl?=
 =?us-ascii?Q?rKIGLRg6K6J7160Bg4hm8tRWW8MKWncJi5jFY8r9ZWMjTSfZbWAnckyqpNhY?=
 =?us-ascii?Q?q5MFQLC+T7VK1mu4NG0TVpjWBRBTWyd1r2w2R0hL69BAj8q8aYnxhcAzqR4I?=
 =?us-ascii?Q?xswELsmBXgg5z+JGwCHvPGi6EO97nITaPu0ylgq/4JsZ2V+m75ALoqjixCEu?=
 =?us-ascii?Q?a0lGb/w0zCzpRMiEZmTHRg8lSV5ZwZAyqMsSjUzX/wocl24Ah4u3indNrZNs?=
 =?us-ascii?Q?Jyiu66wpAbc9jS4Uhb3x/+m4SLBDJOtP3KcuF2/tBHxbqnfbysBexOZrsmtO?=
 =?us-ascii?Q?2P+ZJFassITMxCzDJj3id9/kk52Fvs7AccBKoxhwH0skXuJT1Jor9ZplEz8+?=
 =?us-ascii?Q?rX6BdDA0dnqRHfMGWm/IHjptOkF0IeBGBNEIyDyk51GscIeUJxIJXkHavzZx?=
 =?us-ascii?Q?ZgMkSPbPtIuj7LVTqZN4Qq+RAAjbXNZML53MwvNedgyCK9XpQkJh/3AfWNOe?=
 =?us-ascii?Q?GpanMry6/b8Ig4SsPVNflVZDtsqw2UfC3G1SmhxxNK4uioq14O6Fz756sRXv?=
 =?us-ascii?Q?4UYC2Saodzr+Imz1+3bwAHG5OKz1eTKgCFhLbmvl9nHGRao6lnrKcNFehH65?=
 =?us-ascii?Q?uslD+1KYykyuFbuTg3mGXXcS/AnSYFXK4pwUGcITTcjXlMClhhCRp/2jaDiV?=
 =?us-ascii?Q?Wze7PuuJa/lH7yqap38j7wo75pOiZ++dzut4tOJne2qZmr5AOyvnylE2c3cd?=
 =?us-ascii?Q?+Gtl3IGr+qdsZz14O5WwgykCgZAPyv2n3hVGMZtCCCrC+5bbrxSt4YBd7I3E?=
 =?us-ascii?Q?MjLnszvbQzpR43EF7Pxt/R2noPmjchk6DWl4Ue+jRHTa8ZXFknl5IzDKHPVl?=
 =?us-ascii?Q?4jQJTLkg6T9zXlEO3GeXoioskrYzo7SVGvJE9sD2szvuGjz8VUypbNgAp9H6?=
 =?us-ascii?Q?5wZ/JXT4H20eJ/m25waeCZGnOnEJToxpIS82//slbL8PQGBLmOD8fM1izApV?=
 =?us-ascii?Q?PCacvdzWmRz+tLq/4JOWQZnHgQ7qLK6/jDvd10iafo4+GuElI0UjOkKc8eGA?=
X-MS-Exchange-AntiSpam-MessageData-1: OJ8zYCUaBE5NEWfyLLTopxr/OS0oHe+0xBk=
X-Exchange-RoutingPolicyChecked:
	B+MuJmJM2VEbCVaw8zcDtSkF4xkZBubHfuZ9ZLlqPshw/jTCK08sk1CpJoNIy+X7MZp8J5y8ztBvaorU3JnvqtAKDjlQ0F2wW20PlYfu+9VbKqm3EAfF/pYNpcUh4NWjripELKrGCI+8Oq19n4VwoEtbhvC7LQYH77wddgHErOCYVdmUSFHGQsYTPfR/pl/ayr2pd2Q/sMaoKiVotTzR9Fcaxv73YsAA96x3d5wsKzTypm9Kt2IBGeelSCndIBeKw+0Wi6d6+AvsvNTEr3UTurMHUNBTbn9zVP9bJrVtCORqMrcQ3DMWZ+y0SijPHbWwmsObIgWwT8PKrjLmjQBL5g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cGXBQedhC1Efza0tQbDDUCZ2QdVquY4Xm0rq03uCIU5PfwpW2QmelJ7B696mYuSUFKOavif513oICVKmtiVP5ymuVC8PzoOaUq8PgwW6NnUAOBGoTyDdMNXY1r9z7Cw+FEDIlwoPXe0MD6jZjtJMMgwSGycJD+2uU9hhLlcwLEizhEly0HpFx+hvsgbuBNZD4pihWWg7lf7A7JEbRrM2jwI/uCKzOWca5mE73CX0TEW57tVpEqZz9MxNPpKkS4zbFIxXjljXQ7NWi0ppQdKvDG6yNlICx3M2hA12TDlspPirmcnhnx2QmCDAz1W1hu0JdLdhYFWVnGdkQuZl7poybCfth2jEVWJrLUTUyCrGc1048klO0Tt8c6ZPdd6ll/7ViwOzf2sEr9iZzu/CsrjdHh5RAqPEfYhlNQ+U2iDLB5An/mduxPoB3mlT5mCmdlySjhUeelaxldwRL1rMC8i3YeR2QteimMxwzzvt4763s3iHtsxQpdPBz/ejvSXr76BqRrNGH3iUk+nb4LK09A7MREmf+OmQ/sIAbyCRpQnXH4cOwcaLAtm2G3Cuo+orAObDnFJbP4gtCNXFoGNd/jM4T/GTprYPrXDBQWlDwW3qm5+RAuYodyGLcbbUP0ZTpTA8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d0abc2-2c31-4c9b-5cd2-08df4ba27025
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:48:35.2061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGfKCGYz1hZU5pTXZ9v+dNMyuqBEaIcMZeJh1XB0TgUMBWQMwucKK1BfsIkC1dQE/xEf9y3S+oWAN4Aq4bWweog8aUwWQJMfVDzqcBv83sU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6883

Detect and repair a filesystem with exhausted active zones in fsck.
While we're at it, also add a patch to use the "new" cached zone reports
that landed in Kernel 6.19 in progs.

Changes to v1:
- Add Reviews
- Fix max_active_zone brainfart
- Increment active_zones_left when finishing a zone

Johannes Thumshirn (4):
  btrfs-progs: zoned: use cached zone reports if available
  btrfs-progs: zoned: add btrfs_finish_dev_zone()
  btrfs-progs: zoned: add btrfs_get_max_active_zones()
  btrfs-progs: check: detect and repair exhausted zoned active zones

 check/main.c          | 190 ++++++++++++++++++++++++++++++++++++++++++
 kernel-shared/zoned.c |  79 +++++++++++++++++-
 kernel-shared/zoned.h |   7 ++
 3 files changed, 272 insertions(+), 4 deletions(-)

--
2.56.1

