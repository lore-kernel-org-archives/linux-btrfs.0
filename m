Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941989;
	b=xUsZjHc0/VJsFcoxXu78MlSm60JGdWfW63O0a21gWJ/NqQn5HAoFp/4WVeJMb2UoDPk2
	 R6+6WwedobXR8h8zaaLbv1bXfca3kPi0HIGdh4umVLpIv/rE81ckWq9RzLh4DKArLEAjL
	 H5AQdr6PCIoHPL4W7UIvTleRnK6cja1QEIAiF9BGraoff3DAPJLU+AsAbV+3rjmR/aWG4
	 1h92Ti+UPWs55Cn1RE41fVSlFCL1J294tNCZb6tw8RWnAwM2Y8gMrB9i6U8A3j/OaXtoC
	 oARsXZK6cyuiNWsGhSpniWvUnUNuxgsETuzl9OGT7pXpwa7VhDZ+Yc7UJY8gnpKy3qw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941989;
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
	bh=di1+TiRrk0EBQiNDzh0He8B6tCWZlOknlif+uyNcmj8=;
	b=SeeAVvILG7p4Zn2b20NLKaOSFaQhf91f/sHuFjaE6TgeQK2DiwM0fqTfofoGkdm3T+4w
	 edGNmAUxAmmEB909JtTX4aGPoK7D9Cd80Qo0IPO2c6StmsuIaSI5M9dPI4fleUw6O1h2d
	 maFy1rGbHM36BEppGwuZ+U8u2pewRGGu0da7p0f2q8JE7fPwYBYCIflmSFLDTAcPAxMLz
	 eH3/dnlULmdsorScfv8G605scfVZDNi4jk46CzBrSYU2RQnGG3AOdGEGEmHCf3BKf7hGe
	 4Hu+BDwAPo5MmSVnR2vW80bvbNMaVpB73BRD5kDMiyoTW3sllw/vbpN/ALB975dOQgg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=G3YCC3jA;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=EhvE8s3s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254F8606A885
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 254F8606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=G3YCC3jA;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=EhvE8s3s
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941996; x=1826477996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=hZwTNl6A+PQEvB58al//zdi1aUC9InB6cDV3p9QBSUE=;
  b=G3YCC3jAz/5oRpHFBM5wZQNCGLvPwxXPlhmzYeQdymBRsbltDkSoL7gv
   GP0sC3NEZKcFh7WW9faMZUuTN/eJcxL0XL8cDqKKmi9CzCUXhEzGgU4w5
   oDdqK+e9tfoV4bFEfGDK2M2EIybzX8X2WrMbLKt9RGCp8X/kWW5gncJbO
   yJl1eCpds8tlThO/V88CjjmNTirVomz9AZkjVvccGEIEicU1OlGRYWtKY
   bcoZHME2gGqRAjVscgpXQZHN0Cd/RiEVJPvnfJmHnuEqh92uyWQR53Z5H
   69I2/R+S24XxnNTWkMUXg375xt3YIBZVW+UpwU9bXbMvYMQTQzaVXLVDr
   Q==;
X-CSE-ConnectionGUID: 1+KGG9qKR2KVYXPY58clGg==
X-CSE-MsgGUID: Kqa/5MCITcu4l8WbHsHqAg==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="162096912"
Received: from mail-northcentralusazon11012027.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=flDnlKec+TBACF7N+ZzswU+Ye7T015+ArKCe7K7TDmN7DSO5xawuDqZppIxUasg4Fa4GMB/HX1RYqj9aNsDogd6tD8xnNs+oonQrChjKjrEj7hlYiPADn5GlZkYkbEN62C7Gur14iqCorR7FxYVlytAYji1WJikbr9Hfnj+AyVYTWVRaJoM8bwKuitUz+Mv4+xjw6NdZERaFjMbTdtEVuWnhHjP/MAIq9dblWpnh/igGuvQFhaLUzrwp2Vr5goiG2AYW2lf2CexOIwlsQeaLscnEmnVhG8mGSKqRlPZYUnXT3eFGE8mh4j/AKrqjqYkurF6R6nxC7Ud0eTAHB4C9DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di1+TiRrk0EBQiNDzh0He8B6tCWZlOknlif+uyNcmj8=;
 b=QD9nQbClo71CH2csOifh8EG/5PKYNuJgTaAUh6vqamnXjCoGmKD6Tt+fpsuoD9jZuaMbpen1mV+rGC6owOZNi3jVBKXYNzG7DbnTa111ohDVSYk5lSz7Vv+Vri8iEiBeCU/0ne/+YVoicMUQfBfpJQe6iHFjHmDavRb8ipmlPTFnFrMZVso5aoqyUOByXfYmiyoGg4bQhwc1uY2TqP5WO3LVIJM54rY6m0hU/OHVOM4PWfFhUOYw1wg/yhgz3Qx7oQ1vV81Z8CHTB8u07Icu541I4EXlvmxAHoEU38nYq7MMnDaGPV3lFS4P2JaLmFNRyBE7GiHHlxu38e9cwkNL9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di1+TiRrk0EBQiNDzh0He8B6tCWZlOknlif+uyNcmj8=;
 b=EhvE8s3sY//DG5YF7dnjn1We/XToybo26c7bSlQS4NhKZ802aC15zItyBwYMcGVPBCTkm2AkMjgynhKohSwy75OoZqDfBMAym8I5E+DD7P0IMCExJN+827cEF81/kHYUkCubRaK1GLQ02314V4VG/Nd09m1Jp+fuMPZ+P2pOk2U=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH6PR04MB993818.namprd04.prod.outlook.com (2603:10b6:610:382::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:18 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:18 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 04/27] btrfs: zoned: don't use active zones for conventional stripes
Date: Tue, 17 Nov 2026 19:58:27 +0100
Message-ID: <20261117185850.4128157-5-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH6PR04MB993818:EE_
X-MS-Office365-Filtering-Correlation-Id: d576f93b-c83a-4bb1-111e-08df44dce1a8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|22082099003|261009223027099003|11063799006|56012099006|260925022911599003|260925021911599003|260925021311599003|261102123227099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|261022075727099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	+AlcT5ZehZwowMY0ItuHPXSpK4OAXSlEC6FA2JzJhCGKHtGmRZ5RTUWnjE3ABUv6ash+PmYIMOCoAb2lLAzUXIOFI3RuPmp0G5RfX2bAlwVSsEFXP/mFZr9dT4mEsbiUTZi4fSl6+DiDtFPx0JzUS9vVxQOSryUJybjeLUYaRFqaWUdz6oFTFeNpdPtfwcoYbCMot+LlBSv93xtvjf3m2BWc1gUR96eiesTM8a7BsCK2jwvPdGx9JeA33W0R8dvZ0SC/sdGMGyMWjQMUdTZOjfr5mFagRUzow7ZM5HrGtcixFeNHNKunqo9vzcPaAzrw6/HrMW4cnBZ4/rjGelMvR0lN5lx/XIWa1mrz/gZHOVdY9+htOrwsSl14HEWfWi05L+b99mkVA3F4zoTzC/cBRkRr+KAC+lEJ0NDqyEByt03Tlgl544w+uTro9IErYSu5GAInyZ8U0pWlDn3I/DMUe8bqqx52oV0llE2BZe/uIy0CZdMvPz5MeFiIpiu5qqoHQBynKtzO7vPlQ6NMAOCx//r1ewMk++OqJyXc6xqjpW+IigcI03mbVAEFMizcFNUErfbgMcq93ROd+Sx02ChdWQLPBVpbf3YSlvChLj1shF4QorqvACEG/3PlSb89tLkVVaWHTD19GRb/FrPKDjTPznnHgPw7xXqyzysLKYQLj2U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(260925022911599003)(260925021911599003)(260925021311599003)(261102123227099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(261022075727099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iKyFMDNadKlmpiMxCTtgM7VEQfnkT1jtUH4O0JOpnZNJ9S9DD97USIVyxKLN?=
 =?us-ascii?Q?qPquWwVu8G7SO+J3fUOy/Kq3tK5gsk5NdIzOZroq/GD09WCAv8xeDcRYTwgE?=
 =?us-ascii?Q?0NrBUR3hhXpfjfq/hNydOSczzKm01Wbyt3audu5m2T1pVaAKk+6Q8hJLB+1N?=
 =?us-ascii?Q?ufd5WMO4BDraodZ0VM12Pkx9CIKjtgazOACiWkjMLSa9DS4IDow6sbSq7oIM?=
 =?us-ascii?Q?YHettyya5lAcZ1RPOhAK6V0F2dqbfJX/RNdj2v2Ty8lVOh/2+Ydn0bUR2Sia?=
 =?us-ascii?Q?HnRO1TGuDDOBHpdwZmlmxQyPRd8GSgnw3zni5YCelks8pYoPLr5DrhsnVKtk?=
 =?us-ascii?Q?m4qOlIHzNNrXxryjUhZUf9M2O8OT8gr0MDeZRlysmpvFmYYtc0fcgTixz9eD?=
 =?us-ascii?Q?BO7cGYhXhoFLgGR/I9D3wfI25uFO9Ox+zfo5j5NRkm4ouPEthDId0cXFxTCR?=
 =?us-ascii?Q?YCR+nKBkLR9fLPaJ9K/z1UIVGLyGpKLRM5n2qR61hPMOxqeO+8AfdQMNF3wv?=
 =?us-ascii?Q?DJGlA7CFF6xCY6aPVMffSnODm88yzKN7GRycRF+fSUxeZ3Cb8G7S8N6se1gx?=
 =?us-ascii?Q?+6qe2cGgPsI/9IJYYkvyATlgZMQM6kxNoroq85TTrMVHCFsV2tTavETPztWc?=
 =?us-ascii?Q?aQKZP3ClpNMmG9W5toCQvi7X8+nOhbxZv4N8JefQU+jWjV2RJy8zkhUB9sSC?=
 =?us-ascii?Q?I8ygPwSJzXFR1T6pO5GIj4GhXYJT9Y9U9cCeW9lvqv978DpBiZk10HRs1GBX?=
 =?us-ascii?Q?gRvfWpDPUkDWHydVrvMh59epq3Zt7vAWkL9LXr+i8Ao4Hih7y2QmUpvVy2fO?=
 =?us-ascii?Q?mJFfzXOdX1xipJP01rm5s6hqyn75y8IROMGL/LDsvU70rtDcWsKtfbgxbFcH?=
 =?us-ascii?Q?hdGW/eoRh/YtDxIrH3E6HVm5yBHnTaYwHeFb3hFSJxPfI8IgEXgVSHmaZ7CS?=
 =?us-ascii?Q?/pdyY1hRDkiI/QwigrEzkbHphdzD6csAEHLqzyLnFeBgBGrYEAr5IdssJpJE?=
 =?us-ascii?Q?QHcpN7GyZsFxQ+icGJsbSyqlhZtgaxbyVP6E3ej1jmak0u3OQmfRa9gqbwCk?=
 =?us-ascii?Q?QWC6wZBg1OESVz5ZYLUN1PyhPolDnj1UjI4RR/CoCYWCs3Yua+7PKAllaxR9?=
 =?us-ascii?Q?4+TC6XTTBGNcvawhXVwaC4GPIjmOdni1AF4gSsjqdGiqjtDCgj9Pi6v81cQ3?=
 =?us-ascii?Q?WWtLSrbT9qCtodVDt2LK56u6Yc/4QLhcoTKAZh4/yX/cUo/uhGPDXsKGa7qb?=
 =?us-ascii?Q?STOZvG18dAP1k2AnC9HyLVqGO2TUEGCfE0kyFyzkeEw+qCA4ct5Xj1CZ/FvZ?=
 =?us-ascii?Q?anDUZxruYPvZZFS/Xf0dVK8TESEPgvROovX4u/eTIT1SjI4ouPf97ooqRxrj?=
 =?us-ascii?Q?7HIclxF+8jH/ybg+siKtg92QNb1nHWFK41Qiv+oCwy8T6rzsjis8+IU9e8r0?=
 =?us-ascii?Q?cmJkyOSkQWRMfyMwcRM253kHwCZAcaKH8RaOozKThbbVrX2+daOxko75kcoh?=
 =?us-ascii?Q?BbqkqrzpoUMu1pS0EyR5DenzhhcI0TBlXNpPJEM2sIXMc1XwXVCiwcwCCAbq?=
 =?us-ascii?Q?hqqfVT8WRhZ2oXldQF9fcgkYQaDM/ZbLZJyODgJUmKWLVVHL9KrJXmp5rJQu?=
 =?us-ascii?Q?kxI8UWEd5xqI9UxBqNRmOxtnSq3AtIzOYE65kahHQGxUqXE8qkigoSwWLJ5h?=
 =?us-ascii?Q?lqeGmCSPsBro93wCeRXLTQw5RTngnxOno4dxLB5aoaOY+p9HIFuhCAs8TVmU?=
 =?us-ascii?Q?lgjY4vRBNScUeh5OEeYkxWUh5oGBC5buOKw7D443DOF8BexVIUJ2f85LFJyF?=
X-MS-Exchange-AntiSpam-MessageData-1: BRKaRf+gzDt4SEMVua6KUjdekRVEuNx5mlo=
X-Exchange-RoutingPolicyChecked:
	1CH8HhjcOONp6fq2zoXTYz69XAq2TNBeHyFgor/RAr1HGv+pNakSr05h0WnTMugL6lBh/ROuJTDgTMbPHAffI1Sj90/jCjxBmLsl0BKgZaYLGGk5gBljL5vS8cgd2CaSozDQaTU/Mz9M/4m2CPYv0pUftlH6kWaEIikHeqVwwTQWoOgAsMEMVEhtT2oI51P7Eha4WNKZP/d9tFbeN9BliwbRC8PgB1DEr7zGXEyA/nWwkV/YR/nExiLVIqWbosNagdMVXDRyAzZ9MHBPyFXvmOf8ZmmrjGYcwaBe6P3btpTDp+3mJZk8uJGbplq/2mmWVbOItyDZocSVGHb0xaLCEA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8P4k7dT1+Dnr0ZEvkMHOpaC8PB1bAlcK7ZPxCqQvbJqzuu1xely8OKkJnmD3iCPeIVqzAeBq73fW4+EC5bT0Vd8rDPGybRuKzL3HXczGFo7v4AvpRemWBhIsGRRkLyAOQ5xpznUzGbWfm8pHJYBjfIsoBABCdxy1+vkiENnRYB4T4xz1vO3hZYg5ACcJnOT/sNve6GaJWuO4I95X1a4fgxroncGz0h1osFEOQaCLItFI1cBL9ny3JS1jXPHhTVr4fA46QGXAicjoLNL+4kcjKq+7K02kjyDntaPWEW966RGx5M6q4YMC54viwLH94rkmbnKKnBsJzHtTMrYiTzOmB/NcByfbysiYSAGNqEQ+j4agqqZuCkFy40FKxzJG51/IcUG+46eGEnfAwJvb2vNhMD/G02AwtRMJ5NF3QaerBsBRvvrbEO6nvDC0dRGxmIAU+Xlj+rGSfjemvHmjFFUe5FKAZ/n6IbjEak6To90RMITZCD1fQFcDNkUtiTrWO6FfSQqeld2WK1PKduPwCAuV4fimdOC2GsGT6No/R38wYWI4dys7iQaubjYyA/euFhPqkErH0v9krUQkyatCVpwWIWtCzA5mQ76PGtbgqNxHRjNNQhKgbOkB1mSRqrlAnYa0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d576f93b-c83a-4bb1-111e-08df44dce1a8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:18.2721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwZiGRpvtkDFV31Usa2F1DyftYpQxUIZ/mJeAsSAHnMoOA3HuL5ZosLoqpeUBJlz7ejh98IBuFM+o1r2Zoq/V4W7P9TTVP8jwsUQZt//jyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH6PR04MB993818

Conventional zones never consume an active zone resource, but
btrfs_zone_activate() and call_zone_finish() take and return one for
every stripe of a block-group. Also the DUP/RAID loaders activate a
block-group on an activeness mismatch between its stripes, which always
happens when a conventional stripe is paired with an active sequential
one.

Only take and return active zones for sequential stripes. When loading a
block-group that has both conventional and sequential stripes, the
conventional stripes take over the active state of the sequential ones,
so the block-group is marked active without activating anything for the
conventional stripes.

A fully conventional data block-group stays on zone_active_bgs but frees
no active zone when finished, so btrfs_zone_finish_one_bg() must not pick
it, otherwise the caller allocates a chunk that can't be activated.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/tests/zoned-tests.c |  16 +++++
 fs/btrfs/zoned.c             | 115 +++++++++++++++++++----------------
 2 files changed, 78 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
index bb9969210444..df730ac3fe9a 100644
--- a/fs/btrfs/tests/zoned-tests.c
+++ b/fs/btrfs/tests/zoned-tests.c
@@ -44,6 +44,7 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 	struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) = NULL;
 	struct zone_info AUTO_KFREE(zone_info);
 	unsigned long AUTO_KFREE(active);
+	unsigned int nr_active, nr_missing = 0;
 	int ret;
 
 	bg = btrfs_alloc_dummy_block_group(fs_info, test->bg_length);
@@ -80,7 +81,10 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 		zone_info[i].capacity = ZONE_SIZE;
 		if (zone_info[i].alloc_offset && zone_info[i].alloc_offset < ZONE_SIZE)
 			__set_bit(i, active);
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			nr_missing++;
 	}
+	nr_active = bitmap_weight(active, test->num_stripes);
 	if (test->degraded)
 		btrfs_set_opt(fs_info->mount_opt, DEGRADED);
 	else
@@ -101,6 +105,18 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
+	if ((ret || nr_active + nr_missing != test->num_stripes) &&
+	    test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
+		test_err("block group marked active before all stripes were checked");
+		return -EINVAL;
+	}
+
+	if (!ret && nr_active && nr_active + nr_missing == test->num_stripes &&
+	    !test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
+		test_err("block group with all present stripes active not marked active");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4b0a596c0c0b..169afbcd8be7 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1433,8 +1433,7 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 }
 
 static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
-					 struct zone_info *info,
-					 unsigned long *active)
+					 struct zone_info *info)
 {
 	if (unlikely(info->alloc_offset == WP_MISSING_DEV)) {
 		btrfs_err(bg->fs_info,
@@ -1445,15 +1444,12 @@ static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
 
 	bg->alloc_offset = info->alloc_offset;
 	bg->zone_capacity = info->capacity;
-	if (test_bit(0, active))
-		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
 	return 0;
 }
 
 static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 				      struct btrfs_chunk_map *map,
 				      struct zone_info *zone_info,
-				      unsigned long *active,
 				      u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1504,13 +1500,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 		return -EIO;
 	}
 
-	if (test_bit(0, active) != test_bit(1, active)) {
-		if (unlikely(!btrfs_zone_activate(bg)))
-			return -EIO;
-	} else if (test_bit(0, active)) {
-		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-	}
-
 	bg->alloc_offset = zone_info[0].alloc_offset;
 	return 0;
 }
@@ -1518,7 +1507,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1562,15 +1550,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 				  btrfs_bg_type_to_raid_name(map->type));
 			return -EIO;
 		}
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_test_opt(fs_info, DEGRADED) &&
-				     !btrfs_zone_activate(bg))) {
-				return -EIO;
-			}
-		} else {
-			if (test_bit(0, active))
-				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
 	}
 
 	if (zone_info[0].alloc_offset != WP_MISSING_DEV)
@@ -1584,7 +1563,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1676,13 +1654,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		if (!IS_ALIGNED(zone_info[i].alloc_offset, stripe_len))
 			has_partial = true;
 
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_zone_activate(bg)))
-				return -EIO;
-		} else {
-			if (test_bit(0, active))
-				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
 		bg->zone_capacity += zone_info[i].capacity;
 		bg->alloc_offset += zone_info[i].alloc_offset;
 	}
@@ -1706,7 +1677,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 					 struct btrfs_chunk_map *map,
 					 struct zone_info *zone_info,
-					 unsigned long *active,
 					 u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1828,13 +1798,6 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
 			zone_info[i].alloc_offset = raid0_allocs[idx];
 
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_zone_activate(bg)))
-				return -EIO;
-		} else if (test_bit(0, active)) {
-			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
-
 		if ((i % map->sub_stripes) == 0) {
 			bg->zone_capacity += zone_info[i].capacity;
 			bg->alloc_offset += zone_info[i].alloc_offset;
@@ -1865,27 +1828,35 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 					unsigned long *active, u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	const unsigned int nr_active = bitmap_weight(active, map->num_stripes);
+	unsigned int nr_missing = 0;
 	u64 profile;
 	int ret;
 
+	/* Missing stripes are never active, ignore them when activating. */
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			nr_missing++;
+	}
+
 	profile = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
 	switch (profile) {
 	case 0: /* single */
-		ret = btrfs_load_block_group_single(bg, &zone_info[0], active);
+		ret = btrfs_load_block_group_single(bg, &zone_info[0]);
 		break;
 	case BTRFS_BLOCK_GROUP_DUP:
-		ret = btrfs_load_block_group_dup(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_dup(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID1:
 	case BTRFS_BLOCK_GROUP_RAID1C3:
 	case BTRFS_BLOCK_GROUP_RAID1C4:
-		ret = btrfs_load_block_group_raid1(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid1(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID0:
-		ret = btrfs_load_block_group_raid0(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid0(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID10:
-		ret = btrfs_load_block_group_raid10(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid10(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID5:
 	case BTRFS_BLOCK_GROUP_RAID6:
@@ -1895,6 +1866,16 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 		return -EINVAL;
 	}
 
+	if (!ret && nr_active) {
+		if (nr_active + nr_missing == map->num_stripes) {
+			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+		} else if (bg->alloc_offset < bg->zone_capacity) {
+			bg->meta_write_pointer = bg->start;
+			if (!btrfs_zone_activate(bg))
+				ret = -EIO;
+		}
+	}
+
 	if (ret == -EIO && profile != 0 && profile != BTRFS_BLOCK_GROUP_RAID0 &&
 	    profile != BTRFS_BLOCK_GROUP_RAID10) {
 		/*
@@ -1970,6 +1951,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (num_sequential > 0)
 		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 
+	if (num_conventional > 0 && num_sequential > 0) {
+		bool any_active = false;
+
+		for (i = 0; i < map->num_stripes; i++) {
+			if (zone_info[i].alloc_offset != WP_CONVENTIONAL &&
+			    test_bit(i, active)) {
+				any_active = true;
+				break;
+			}
+		}
+
+		for (i = 0; i < map->num_stripes; i++) {
+			if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+				assign_bit(i, active, any_active);
+		}
+	}
+
 	if (num_conventional > 0) {
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
@@ -2013,6 +2011,13 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		ret = -EIO;
 	}
 
+	if (!ret && num_conventional && num_sequential &&
+	    cache->alloc_offset > 0 && cache->alloc_offset < cache->zone_capacity) {
+		cache->meta_write_pointer = cache->start;
+		if (!btrfs_zone_activate(cache))
+			ret = -EIO;
+	}
+
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
@@ -2462,6 +2467,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
+		if (!btrfs_dev_is_sequential(device, physical))
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 
@@ -2539,6 +2547,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	bool cleared;
+	unsigned int nofs_flags;
 	int ret;
 
 	if (!device->bdev)
@@ -2547,18 +2556,17 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	if (zinfo->max_active_zones == 0)
 		return 0;
 
-	if (btrfs_dev_is_sequential(device, physical)) {
-		unsigned int nofs_flags;
+	if (!btrfs_dev_is_sequential(device, physical))
+		return 0;
 
-		nofs_flags = memalloc_nofs_save();
-		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-				       physical >> SECTOR_SHIFT,
-				       zinfo->zone_size >> SECTOR_SHIFT);
-		memalloc_nofs_restore(nofs_flags);
+	nofs_flags = memalloc_nofs_save();
+	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+			       physical >> SECTOR_SHIFT,
+			       zinfo->zone_size >> SECTOR_SHIFT);
+	memalloc_nofs_restore(nofs_flags);
 
-		if (ret)
-			return ret;
-	}
+	if (ret)
+		return ret;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
 	cleared = btrfs_dev_clear_active_zone(device, physical);
@@ -3048,6 +3056,7 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 		spin_lock(&block_group->lock);
 		if (block_group->reserved || block_group->alloc_offset == 0 ||
 		    !(block_group->flags & BTRFS_BLOCK_GROUP_DATA) ||
+		    !test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags) ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
 			continue;
-- 
2.56.1

