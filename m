Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F2319049B
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 06:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503105; cv=fail; b=snYGAf1OAFVApM6JLGewQLrEJk8wkaG0qZ87tmitpr2NLrzbPJ+bRxgBUv59EGdEIPZa2ohV3pbrnhfk8Tuxy0spg/YTiaAy4J68UiBsABwkBusq4b3h+tMsAq7He36x7LimKYUKxVLN+W2reNamGT2LaKriSWcvT23Mni78bIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503105; c=relaxed/simple;
	bh=RDjxgDjxw4BP/KIXwevEV6bgtkeSX7KvxLr9XPF5tjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n3hdblz/5n3OguDanJOdjv2miImQJKzUe8B2MWeWyr5IQ/SrvWuZSintTtY3Fv4KEU1qAhtaCCeSj1qofYFgL/nBs8kScSsz0WT2ckEnmq3gIgGxx481vSxriHRIRVgLHILB9WWA7ui/OWuQPSwYRkmn/ccyyGhlY/Fkg0J7mhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fhoaPwD0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=KWtvL0LU; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fhoaPwD0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KWtvL0LU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788503103; x=1820039103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RDjxgDjxw4BP/KIXwevEV6bgtkeSX7KvxLr9XPF5tjI=;
  b=fhoaPwD0veVNkmFmCtEr01n8wJ/1OMJj53Z1k3bCDjXMcQ5XYEbqca59
   qtOQUZcjHqFFHzm4tP6eEXFZ98JiozBt7aAAPCadalHmc9QtzGkZCbBBW
   FPsnWN+VvZ7KGpGJzwteBadYhLBGDzEsVyox0GKB+c67QQd+2IDnOTD8R
   sc1dkD3VkayfY4dpV8PKlG1l8vHKs0HwrIoTYS2NogbXVUkD+DwgcdxQg
   vG7t3EEZ40otv1CoBmcty8ZcBPgJqM46y75Y2F2WX/w2tXD+WqYwI41Qt
   9WfopIU/uiuJU3SICFyvpoUpkmAMJt2qgIHyflekIC03muCDGBaWhmNHB
   w==;
X-CSE-ConnectionGUID: OkuWdbCzTT+98mAWQu790Q==
X-CSE-MsgGUID: ETyTdT9ER7mTmOM+TTPdaw==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="154938766"
Received: from mail-centralusazon11011058.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Sep 2026 14:25:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lDQFptTIc4KkOoCqM2/S7Edix2rzhIs8gqXHhLrDaMJcyl8O5LdvxUwfbGamtPIekMnsSVMOFsYYJUdPpest4m0HBtKbWMRk6o2xjpQTbxydwSZ4IdrDelzwI/dxeOVXo2kuN/rt2RVQz8y8Hv/rBNG0Ugwj7S8kFETlbKeaIavCkn51qkf96j1AlrdKGSKNbNa3QEbKvzcWlJPHVCg3+r21KccHhUF/9940aBppzL4OhmH8AmhHrsBlHxPtTF4ob8EY9j0ThUYpAIje9AOTk30Y745DVuVn0uRfmHJxAMr6RRUX6nfg478THSV8F2DSpEQnuJ5Q2M5WuRGiakFYcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfs1rWDeVHjz5YFByQa7K4AgYhW+K6WblZH6KP3CUzM=;
 b=Ah+MZuAbTdAst1+0/vQzpbXQAgDSSFY+I8RrypNMHNviWtChECUFuw5SNtUhuFum1UZ9eyUbWaruAug6ClhTzTO1tMpEndSOTacIoXEfI25uKKAiIbMx0SXYyQhiqxhcjrRjS1LBnB1jjufErENGcLzB0vOCZhCIZyQ1KxTQhNaL55T4pQcXN+VTm06iIGQyWJOJ2MLMBOTXbrTatRD0O/2vcA50eG24GVFep0rOwhvXe5KSsPpQOJPEB8qFD1XZk16NsHkgC1AX/+SLkAZ1qHOcYhSok2v7cjVUq6mfHw5fkyfK0GLs1+A3omDkQ63OIWIkOc1+FDvunGWFz4p/9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfs1rWDeVHjz5YFByQa7K4AgYhW+K6WblZH6KP3CUzM=;
 b=KWtvL0LU/YBQnV59dMFq4SELQ+J0H1Pql1iwFU2op9EzpP74euY9UR9oRcXf1hUgKlKHVfSFiIErnn2b2nrGOjPU4Lz77b6HN42umcd0OzyXv383PvRfSex4ZA3qF3MLbEmBm3o+EEExVXjxUqZt+G4l9Nqa7uuQVDgC/Qe1Ecc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB993561.namprd04.prod.outlook.com (2603:10b6:510:40a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 06:25:00 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 06:25:00 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/2] btrfs-progs: zoned: refresh stale cached zone state in btrfs_reset_dev_zone()
Date: Fri,  4 Sep 2026 08:24:43 +0200
Message-ID: <20260904062444.3467618-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
References: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5d800597-4272-443b-d6f4-08df0a4d3f92
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|19092799006|23010399003|376014|56012099006|22082099003|18002099003|11063799006|10067099003|5023799004;
X-Microsoft-Antispam-Message-Info:
 SKDBx6Yuy1vkLDWZV5edDj4pqbuOMOq4reYE1sGylmYlSi98ymdOz2m/6MB/mfnGjSFGnE93MHnVtujh/7g7nsdmJ3/fDAac3hdGfDK06HdxgsExSDmnjmzl0SqcJF3Xu5mJi/ELlOY8aL7rv8nSPJX88abn/gEe6dB3P3un8lZXeJcF2UWGHUXGmnPLRfVw/i/MCWwRy8KGSPa57p2olod9+pugwWY6IQES8v090xwtP6K3ntyCauEbmRySWXg0xCRGyTEq75xuFJdLLIE+YkFL2dGXeUrTRurwTPp/O8s0q9o4x4ReCcUd2obj+QB5RPG33V2im482GIHON5e6z411WNxkRknOTwZE51WYfxfsjGgmy6GZm4FjmZepFGR+f2Pm5qCuv40QiX4tpT5Flq50zLPorzUZu/85kXe0JdOGJPNcM76izsYowPHZpd8tzDDas7AXqw69ih3KsKboNVTSODqcSw517xw8iUEdhW7oLeCYzPR19TvmmEjmGee3abSfLZo+CDH1iEJpG3Zo54quHTczS+Sz3J4hG6nfLhcLoyoqQ0EY7F9f3uikIYu68VThiyMBhGIsKOBPRdQHQTT4AF6AK3paIM7RMzMG30qE+ue5mImwBhzPTOHall+kxIW1Pi7Gmky3cOMc0PO8EIBjmcmnfsE55xbH3RubqYM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(19092799006)(23010399003)(376014)(56012099006)(22082099003)(18002099003)(11063799006)(10067099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?qPyZml7zakBocVggP50v9J9EIDpSQmx20wLozz46B1Mr58WrGtqXnmMXiXSg?=
 =?us-ascii?Q?ncuu1K5Vs0Qjdpbj/NRRLPvppZzLcumu1yMm6R08e+i7MoDT9GyEee8NwG22?=
 =?us-ascii?Q?KksNMvudHUnGY8ABVt91oFBUeX337TIbXFkz3KWKTmB4Z2XeNdPfCtPm5JNu?=
 =?us-ascii?Q?tGjE2mAABtY6ulK5LYdb4zWtK2ZYdv3QxyojVqXHhupmJoUwtIXzUIZ0zzRb?=
 =?us-ascii?Q?ywRrBR8fS8c4TUFd4CBW952Svlx/HOhFGauZ3FfomsqwyKrvcPMIl0S3oBiM?=
 =?us-ascii?Q?GT1uvHswPpLhNsTnxr8s3BlLGUrzCYH3dBW981gWPS1fnoCSXq9ms0zke6R5?=
 =?us-ascii?Q?OeS1RDRLR7hGWyvER2sA/9uQ1h0TqQE/nggVSsWW5v7Lhl0NWsUV7lQWs0AA?=
 =?us-ascii?Q?SkVM6oL6bFnjxhdaOrqalx9pEAEJj9nqkG/gky1me/pQF7MqcLO86/pNsM4/?=
 =?us-ascii?Q?Q/O7xoyZeV8Wo511WtIhncy4mfTHeYMVxrWvL4ULfRZEDAtrlESy3J+SkD2W?=
 =?us-ascii?Q?dHLmK+HTwUpXLQNtKVVSaFxjQfIphRS6ZdZR8RkAI5SL8iNuRCAl9iA0xD2S?=
 =?us-ascii?Q?dDGeielY+qmGGi77F0qr9z5hd9lvyK+bEi1Uvh588pZycNhNXieg/hU4JjOm?=
 =?us-ascii?Q?W9QOx3Tb5PkwNE0Uwp8bkrA2lxv/5y4Opu80+Htj670lCLQeJnA2r5JdIq2x?=
 =?us-ascii?Q?Bh1wg/ZJmS0JCPlK8a65aFo/58jPN9GHwBD0t9JmaM0c9UtpIJZoytlzZCtm?=
 =?us-ascii?Q?AJ3q/pp6nARSr4rgdTwh0WHf7b+DJJSmcxNJpwGJg3cItUnb1ELV/wrdtxi/?=
 =?us-ascii?Q?d26qtfEVmpnrBaRVAtOJ58QU9nmpAjHRw32/c0Qjj2/0QUc/JpzqI3HpSBe8?=
 =?us-ascii?Q?n7KAZbMXM36N9ERMRYYSy1jBOpbaKxfZoek4L3YOjzexlJg4JN8p31x/C5L+?=
 =?us-ascii?Q?POA/W+GcaZfl6J48Tz8MLi8laoHKr1I58fRuuTwaDg3OnCpBy0bvIjmJtpph?=
 =?us-ascii?Q?JTH4F0PUXTgTgKTEV511L1SVB+Zby449AoxLs66vlXowaLX+MbjM9bIRfmZb?=
 =?us-ascii?Q?tUJScRPFGoDLrZgS/ytyiTkS4KKfrQ2YsWm1z9VUL6XPeNfhb09johvwNy9w?=
 =?us-ascii?Q?jdaMcY92NIjdOYqCM48+iDDNeghKsX4k8p8hivfJN+q5yE6LP4RvbMWeejcu?=
 =?us-ascii?Q?X6xQht4opANrVmsdIbkQs4LRzw+KJ1KiQ0UzECiVPzEkWFEAlITe8z03R+FK?=
 =?us-ascii?Q?gPJJR5MCbKHX0XDMvUUznZc6bhhZQLbKRSwwJqQZWmanv+39kZNGA1jhcBJN?=
 =?us-ascii?Q?6v1leSIxgjMwgWkegw2Sw8nVAfrMZcbOT6tmd9DhHiXHFk/grSG6HfblIeDf?=
 =?us-ascii?Q?2siUfzyYBisd1qzeNDA4W2t+G5gisuGH+3HjbqzoGe2OLt0qNBna0kCZXoEU?=
 =?us-ascii?Q?VggmLu6K5pu+ycNxgFu4kUif8P3XIq5R8eIROgBpFul5pGmZEa1tu0iWGPd1?=
 =?us-ascii?Q?W4O58UOWHhLwNncY+W6RiQqnDNY2kKW4gu+Gjt4ea8Y1iWU5sk2hwvqjMlnn?=
 =?us-ascii?Q?Df59av8Ch6truIVdlf2VG0W+lYHTDzCkM/VE/TAqH2CZAXoXGeMhJTKDvvsl?=
 =?us-ascii?Q?wyfOYERucS3R6iAW8BU8VNht3alfxiPP918IJKIFmJnTlGXniXhU44L5/aXR?=
 =?us-ascii?Q?i0qwznQxRJicb7YUOqMtSwicE9O033vbBHNkzy6A4t43tQoyRuv4+UGVrjKP?=
 =?us-ascii?Q?kCrYepD3yX/4BxHB2RRiqitO2oHnsJSGQQrjSJGHCg4x02db+i22rNCeE9uQ?=
X-MS-Exchange-AntiSpam-MessageData-1: 1Jlte+evhKSjQYn7zsalS4eSpM22DuOJcz0=
X-Exchange-RoutingPolicyChecked:
	z/vY/RVLbuq2lJDFoDv4heR7hxpm+5R+cekACEOLtkfoJP6T6rixVTqw+M+gTIT4Jc57KlqzYxKo+Umt8PnhoP1004ILVfoGNuHrZnKG1NKbKYCs05mTmKcWGBKAsEZdK5NNi0ghKK1X4KiXY0RTvFDQqkPvbP9VP6eKVALl7OmRr5RS5Wp1cP5kBoPDbNiuZV6O18qTu4LsRqCF5jNwiY1vQuK61GPckGCJiqopLE2+WwW+Wu+5gSWozDQNDpPllFiPGoF+yUdzgDRRmQw3xq4dk2dW+QX0XEiM0YrWv0Xb0nliXp2v1+6x0HO7hmJ+S0zogeLjFxv0uHjmgqPpdw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H2HPUejfRcA3wvws5xx01Ao7eu3bIc8jEnoPVG/y3fanotFVpCA0I9t5vavIltInlEL4m5TaKzWZRBEfepgRUTDM3mTo3mc/BrwVE2Twb+KWS/chBZh8+rAtlxtKWJjz49lvFnrzWvfWv++vcdl7f3oued5wPjaJOH1wA06CfPMEq7bha70KfGvE+weA6czJHAjUIJSF+mnnRx5oEn8Xd2BFp3pB0bifywo2VgRn/RamVteN0vH75j+0+Yzk2Uny17vtiUkkG4A0zfeMWitkLrY1vJUdNOmw/aDUOc4S4Nfnje8c8sJGkYZhj5wbDzTaStQ4xRUgnHIXrElca7xKrwTVRv0pJrk5zPyoL2+Bc+joypP9V8J5jmumLjBvTKpVpHNns0DQsJvle/AAZF2mUnjUTFIs9RS2VDyW0bxpRQslr+q1n5D3q3Lr4/yei6ULzs6NDJiUJJbqWYux4A3QJPyoZGuXilq1cwOPC0USlfSAZI65tMRef1PzwowMp6dTcfOu6EZXg9C4v+wQMM3aRht5XDROzdR58Ky2tJKuaGJ2hWGKrF/O8MIl7BPRjU8JlgWqsf7VmXInA2WQhvriTm+a9KpZovJ+0bAWiRq1wx4avGEUVK5QN+635abtSIhH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d800597-4272-443b-d6f4-08df0a4d3f92
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 06:25:00.6110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abpVFcKRKbWenPTemhmrIECgDV51+DAm7gdAe1ES1oK5q5IXfLT4CIUKnBIZM92jKQiIyAOC1X2IrwjyxqOjn2HwFSaQH60Y90B7G+mXPhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB993561

btrfs-progs reads the device zone layout once, in btrfs_get_zone_info() ->
report_zones() when the device is opened, and caches it in 'zinfo->zones[]'
without ever refreshing it afterwards. btrfs_reset_dev_zone() skips
resetting a zone whose cached condition is EMPTY, but that condition can be
stale: a zone written after open, for example a temporary chunk that mkfs
writes and then removes, can still be cached as EMPTY. Its reset is then
skipped and the zone is left open on the device, referenced by no chunk nor
dev extent, permanently consuming one of the device's limited active zones.
On a device with few active zones this results in premature ENOSPC or an
allocation hang.

Before skipping the reset of a supposedly empty zone, re-read its real
condition from the device and only skip if it is really empty.

Fixes: bfdb3ae23713 ("btrfs-progs: zoned: reset zone of freed block group")
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index 8a9d1f38..6b835b0c 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -276,11 +276,23 @@ int btrfs_reset_dev_zone(int fd, struct blk_zone *zone)
 {
 	struct blk_zone_range range;
 
-	/* Nothing to do if it is already empty */
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL ||
-	    zone->cond == BLK_ZONE_COND_EMPTY)
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
 		return 0;
 
+	if (zone->cond == BLK_ZONE_COND_EMPTY) {
+		char buf[sizeof(struct blk_zone_report) +
+			 sizeof(struct blk_zone)] = { 0 };
+		struct blk_zone_report *rep = (struct blk_zone_report *)buf;
+
+		rep->sector = zone->start;
+		rep->nr_zones = 1;
+		if (ioctl(fd, BLKREPORTZONE, rep) == 0 && rep->nr_zones == 1)
+			*zone = *(struct blk_zone *)(rep + 1);
+
+		if (zone->cond == BLK_ZONE_COND_EMPTY)
+			return 0;
+	}
+
 	range.sector = zone->start;
 	range.nr_sectors = zone->len;
 
-- 
2.55.0

