Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CAF35B632
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 06:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503104; cv=fail; b=a3SgDmxVKi51TvCKK/yzUxI+BGCDALcpwncWT/1OchZ/iFghuDbRrSSpPY5nxxSPgk62nzl+L9dyfbbYq9E4ibZvschzaD+5tnGRJXgYfiPqfFutBn2PlpCUHud2kLC2HVfuL1OzJQToX6x+kWNJF6mbw+PM3+LjJd/l9GIBOXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503104; c=relaxed/simple;
	bh=NammyUIWVu/TDAKZMfDmU0seZcKPC6Q1lVPldRyfvJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OG1lB/WoObDrvv5GjX2Y9bjENb5+09nYuQIBERXcD0+H3gs9uxuM+YhDsy8EWx9ALH2sf75U8gtgdNm/wfTCBqAVtTqAK1RQ6PMKjZdWr9ADF95pc52TukTaqhQLVFwZBMBG798a8UIFAC0gJUj3VzbAwp4PTnfP5+YrvRfESmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CQ5SMox4; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EEUw8Wxn; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CQ5SMox4";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EEUw8Wxn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788503102; x=1820039102;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=NammyUIWVu/TDAKZMfDmU0seZcKPC6Q1lVPldRyfvJ8=;
  b=CQ5SMox4+/gRZ4nOXW+KGoWEJc4jgQXpW0ZO3lCTa+CibcAnOSP95oKf
   7VyBHl9odMSYEmwEbLi24g6yVdLykY2sJGnJsEmdn0NRUudkxcNfFGOsf
   eoyAw6xgVBhcpHPxLXYOVaqUgp+juMegotsoMKhW4DTodr6kiW344/Ikx
   YamxRggEEGqjmgzkVCvCBr0Q/t/jwJH12yFM+hmCxPjSJAITNc8+f9eE/
   e0GMWwdt98NaXBWOMt8iaK1Fs5U2IIRfkhjcY9couK5x9rvJi+ZTIWXju
   bV/SZ5tu7Ye5oltYUpS92uUPlsKRjCP6rxkCp7cxkTmShkPgT+RYx10ui
   A==;
X-CSE-ConnectionGUID: rcIwTbAgT06GdzpnwnOJ+w==
X-CSE-MsgGUID: MRmYYkj6TdSGs50fzDHI9Q==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="154938763"
Received: from mail-centralusazon11011058.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Sep 2026 14:25:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfv/UGTJx6CIDAUblDjFMY0NyzBZj4H5hj9alUbZcrnTAHMYWHUwX0MuhcwiGtw5YYjQ4GiFTwg5EFEP0i7xfX9VMJlDP/MrimBjs/j0NMT4QE+Pf0uCKaoxE6MfVxeAf5eAP+ST5SgfiBXBtGET1ZrD1wW+23Zg1XozSy3M7KQfUlU0QfgIfJfgZExbfS278U1WFKFdsIUfaKSIfDV4CjJzZMmghfUl3xKmF8CZHNwsOCUebv8t2/O7ss44xoPwVXktf45oWj92ZlN0o3TBHtwy0dCDnN5UKYyvzSKHLHlh9Ot4nM6M8pRAUsq5grwqS3G/VBFeg713IH717wjVow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vfUy67aI5uIziI2+LwdVLxtvaUkfWWNeFSg3DiAN1g=;
 b=oNqpV6YTmWFHEklt0bG/1uDXlkcJHzL+NPrxBYZGeEwymTbjO1TXwl9ZUdNzskvphRV9qtOSEwFSEbRS08EQw6iwu899d6/XeVZQOw8Dw+GZ9xYTLO5JOipoa0nFJO2efjSHSRvebFje7eqtRZNPlM0pSIyXeoIPbbwQ3dLv67hZ23pO7Kefnyjsp6wKKrmsiXppF29FoAGHzt3pGpCugw8iyULL55KLTFF6pzTPian+bCL16qY03p1bM7SsE/FD/PMXM2SWTDrz+59NDQo8hzrj82sdqhIUauA19dMOb2fl5yxYdUINvrgqW2b+Tc3wtbQwNdMlA+6JpCruhDRoKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vfUy67aI5uIziI2+LwdVLxtvaUkfWWNeFSg3DiAN1g=;
 b=EEUw8WxnU/sUfQJQKbAqSV8/ofyXRwP/XH7zvZ3lyQBfEYTez5DOYpBE3uwBpLRmIzoSZ9I1qSNuIBjqPhAlmcnYhLKGrk6+Kd+nLJcrAoRwUgMysq2geUFCFfuYdp9FE8LMFMVys1G5qYvgQL4UEZB9ase2HyU7zHUcCFscDUc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB993561.namprd04.prod.outlook.com (2603:10b6:510:40a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 06:24:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 06:24:59 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/2] btrfs-progs: fix stale active zone after mkfs
Date: Fri,  4 Sep 2026 08:24:42 +0200
Message-ID: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::19) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB993561:EE_
X-MS-Office365-Filtering-Correlation-Id: c616679a-f744-4901-6f0d-08df0a4d3eaa
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|19092799006|23010399003|376014|56012099006|18002099003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
 gttVlaofYNrovI7/nPc7/mRht3Xo36ibbZdYwTvhD77yKOUWp4LDliTiwmQkdcaVVIlPmJiPul/EKlBTqWMWQtkgIQGM27kKO2iU8I0SF/ww0XUJAmy5L5muiGnsu5XtHEcwmnG6JX25qwrlLxTFtxbVmj4JiTkJEUMI6CnbmoK1My71vQwpinbJ6rvpNxui6YnAgFgflN2oFNKUE1srqmbkxeABKmZrZQiMV1nwKRFw20Mq/OMziQoI95uaqYjxjh4KN7Pwz79osm7WRkI4VUjdR/UbmT0nPnRWy9YAnGD9qEB/wTLAHMKiKhZ5llq5k/PyzVIaqytEvQqpgFzzLZHASfN3rHNTB2JXLExAy5HY8CmEfPLdJaUZhrw2J8nkBWtaE6oAiok+uYdZuky6zQlPsYW1YJLFUMUAoDLp7Banes6ImoH7g05TdV1WtP8Og6mzjyxGb+zassIHRZ88VybXkPLS4IkRfslqQWVsP7IPY1ZLRTdMylw+u6JoBGbIBIoK3aB2DQs7iN9mpWFGTins0sKxUKtWaZ4+but5l/NRI26WQRUNAMWgyYfo92BoVRfP/5a/rqItxvfsX0pP+BTz65g/Mo9AJBpQFclGP5JuQcR9SOibt4bz+Zuzr/GMn7OD7DPTZXQm9CTBG1FcBD2bsv2p4O9EQUOdnEFZgyU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(19092799006)(23010399003)(376014)(56012099006)(18002099003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?KiH34acrqkNUOxhNd/RfLLmEh4Lv3XWBzDPpNG6HksOWCSR0CYYzp+qzfCtJ?=
 =?us-ascii?Q?Mki3MW5ge0UQmmjqC4moQ5+9gfGenYMhK2V119smhlWvxK0FCjZ20WvXOGKE?=
 =?us-ascii?Q?Mj54g+L6vQaQYAUA8rfuvDdM9QxaTuB66++IaRkhiJBuxIY/Vh3AQoePBz49?=
 =?us-ascii?Q?0ilpe4J1OC5H2fligIwEl0O/fHfxhi5R5P1r631/81RaEpWfudNGg6RdN4AO?=
 =?us-ascii?Q?AJUk8FQlzE9EL6qo6vDzelZQCw0k+2ohr5lwX+JL+wjHq7m94H5VGOb7nlsb?=
 =?us-ascii?Q?Usg1AA2n/k5geCV8xwMlMKv2kD5daelRtZDp2DT5W2OG6JC+MfhdMh3RNsL2?=
 =?us-ascii?Q?DysYeaItPAViuog3FOVldqMLOQ80vUHYSdQcg5rCrmddlSW9sksD07fsYsrk?=
 =?us-ascii?Q?R7M0iI6Rg6vA3r4RNePieplomV8OzxXnthkxYeVRC9npxgeyp6CXYY7CRg0P?=
 =?us-ascii?Q?twLsvOi5jMSLUGFLeElj0U9VRta1vNIAo+yglCj6D0dwysIyDjdIVuC+XHWr?=
 =?us-ascii?Q?Ozk4P6IWdAq0KOpLVVM00fvJSybC/ujKP7/x62bC5MBJu/vQggzaDvsuAn6P?=
 =?us-ascii?Q?l//qb0MJl3lcvEOrXTo2wViytz/WLNDLrXsLqM2zHzhXLLAnzP3yNoHR2/Z4?=
 =?us-ascii?Q?5MU54e/vzMMdyz4MTG1Jwz654nHEOB71xpO1bpapRr1gU+dIbZhcRtH76/y+?=
 =?us-ascii?Q?t4pPqfieOYVU3qNlt49Uy/Ldey6EUYFSdF+xschXMmI9+0FLGArcyBknxc3J?=
 =?us-ascii?Q?qUVeXvhmf+NRkI8v0vXkQpnDXoezbwJ3irPCuO0zBFeiPdkW+DlzczpLn8ES?=
 =?us-ascii?Q?TZpCWzmYTQenUa6ncvATovehAIm8RtfkhPI74ObhIZGdKlVSwpK+dTM6KuFX?=
 =?us-ascii?Q?XTpxIDQCfegBuH4Ij4FcQA4MXfY4osRfjQF+ujEw0XU7d1YDK5wND+35QjYO?=
 =?us-ascii?Q?UiNeFCNP+u5kBJjZzhw0kFQ8Kpz3vNiQ0DZF7NHkUexsztgMFewyReUA34gv?=
 =?us-ascii?Q?uDELVP/R9cXtnHaGjjbM2xxOGm90XmRtI+JjZTqNLIIaArqO38i8Afj7k13U?=
 =?us-ascii?Q?r5DJesoeR4cyGtMjiTzUQQlfIoZS6+kfk5kGyA46wLvisxKS/G+Sa7DaX/6L?=
 =?us-ascii?Q?x83HCzbavwFN60OEagjaiGYhC5XtpQW1LdrUCPaymsFVkRD5a7qX64U7Ge2O?=
 =?us-ascii?Q?l1Bxoixp3r28pTrtRA1VZzn3jXEwMHiy6fdakWhECsiMueqjHdIrGNOtBSkr?=
 =?us-ascii?Q?dYFEI3a5U8jkjJBwxibBqapTJNz+slTS9vH0pGWjfPBxuL7UQExp/4DlMc8j?=
 =?us-ascii?Q?W3I8vfxTJQjeDIJPvQSRNZPaMUT6c9jc9Jn8rMXEmtXSxP95gEGz3+TlkYGl?=
 =?us-ascii?Q?033ZvtbBzmXe229NpHapveYwkTw1NyG8WDe/9/hOjy4ajDmxF214dB/WEroS?=
 =?us-ascii?Q?nWC122w6fHj59jyZQSQHej/uYXzizSz7dhP8Ty8Om+9heGcf2rtf/0HYEctG?=
 =?us-ascii?Q?3dKVCiDul2/tvicKODB58+h9hSyWGg53fisC9FEIRv86yrkR70bEsJOXK1Zm?=
 =?us-ascii?Q?/h7SijuNbws4ZwG6Un1MMH+xdpjogh9sgjIqOm24Ro/l4WrJXtIVkbZh2DQ0?=
 =?us-ascii?Q?UtspPAn6XHYdh0MRsMlsnmWopWkX3UMmbSZ6igDhmvM0wzBfMeiHOZ3XAjCc?=
 =?us-ascii?Q?9b1UoMeOysJq4X+NBqlc6Bsi+8iRVTRXQGv8d09id/I5uxKqOvvueOn+busJ?=
 =?us-ascii?Q?oYMDCGcnsDtvXeYulicSl1pAOE3ISk13mnNeeQXeNvmQ9z4BG0VPq17bQmDB?=
X-MS-Exchange-AntiSpam-MessageData-1: cNWYxY0zQahlLg==
X-Exchange-RoutingPolicyChecked:
	E2h0V94zh4VCA2xYrHkZMhRj3GpesWpmKndr+XDQJpA5M1frMDc1VT3KUTu3f/jPaXoMXHhm/Pxm6X2TPQof+tX1VLMD41CZU1ltHxloxDvgr9TvvQ+HCiqjhHwwHFoPqbXbk3tuMZGiPH2pIdP5901vSREMUo6Qw5+tqx7uzoN5rp+JaGLFaSVilD1hGjz8GS9ujtFzwDpPZMzmSRUKS5oXjDY7cvUz/qxsRm6U5nc/sXVlDT9Bs6OYaVplBXtLFKz6soHIW6CVgpkL7dDrX4XtqgI/bI4j3tcuGL7BEOB2ib2W7B83MGTns1zvE+gVlgqms9qSh79NZdkgEMFqrw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	txqgEcnbImNv1xLW/kyfPtnxG6qjliL7paAFnaV8qC5un4L68SUpOiZAglr33fE+1mFg5H1WNMnZi6huejp1WS2O9CZJLsbNo/+K8xghBC11iFPlMb3JSPHPc2qcfkQwudbh/rTaREFqr+QXGfn5wCGjk+S5TpO0wR2kXJV0N65zVEQDOa5nnp+3ixr61dhiY8nDIrAnEilz4d3UFrAGAoF+1/NoQqMdbW4XKbUoc2uJOXuTnGVNVETQl8X0CMOi3KjGUyqpc8wyrzykR1/mdSUZPP6HrBKXbC0k/a0Rrp+YXyLONNr0fJtkCP6DMs23/TLfhZmz3Ra6esfq29OsmqoauMoKAqz9gGSIiyHJFiDtAr7+6BB9zDdeB3m/oqzOBpB8vbGQVYu82Sasob0DGDRKuXQdHxutt3z7deUg3MGnd2nb86iNkSr5CUHUePZ+hfaMMakIl8w6pBD/TJuQTVsDRLXhEHq9Tpm+39ox3c5iH/OiUM7wYBXnCaCQB0Sekz/AaEKlz0bcO9CuQfR7+9iT+fIwY3vxSjViv4iS4hQYKzoINR9YoY6Vro8ubtsSwfTLeMzznQny5z++jpK5yozdqdeea2Ajyop3aumYs30ndTRE5PuVjvjVHhtmcRD5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c616679a-f744-4901-6f0d-08df0a4d3eaa
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 06:24:59.2280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlrWU2uyNBHj9wENzvV/XaGLPpijJW0LVbfqN117hDGBtihOYP5lkfzNRYC/lLAXJXAOH6p3cFFcWr2Svj3b1Ft8Ny90HCi9vjGi4rJ9y/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB993561

On zoned devices, mkfs can leave a stale zone behind that is used as a
staging area but never reset. This zone is not backed by a chunk or
device extent, so the FS itself does not account it as used. On devices
that have a limitied active zone budget this can lead to premature
ENOSPC and/or an exhaustion of active zones.

Fix it in mkfs for new file-systems and also add a check to fsck to find
such zones and repair them with '--repair'.

Changes to v1:
- fix a bug in fsck where it had a stale return value propagated.

Johannes Thumshirn (2):
  btrfs-progs: zoned: refresh stale cached zone state in
    btrfs_reset_dev_zone()
  btrfs-progs: check: detect leaked active zones on zoned devices

 check/main.c          | 156 +++++++++++++++++++++++++++++++++++++++++-
 kernel-shared/zoned.c |  18 ++++-
 2 files changed, 170 insertions(+), 4 deletions(-)

--
2.55.0

