Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031005;
	b=CbO8alJ4HVSUeWaCTPgRNjHOW0lsYw002CipRskXTegnaObK6+of13RE6QflGUI4LZ/b
	 AD+frMI27PNTD+gjyJxCFbdjTp60R4xRq2AvT3vkRdueHpIznS0qG2vVjEKzNT7+0w5Lz
	 1K/eLcUndOAxKT/mc0gGjB/l2Liv2MdhC0P9ZWI7IXRkxYmM22xZKP4pWiiiQGN3Ty8CQ
	 U7uY7Ndy3k23OGLsfGF4+y0d2lzW0dF3YfqLoy1Wsh7IYLtJ9YYUWUiHGrcAyJsTiIWQX
	 OdLROzouM87OHxuMVr3dy2on2JbmEwXsQJDZApB4MAAcaStFBhUDNi8Z94LeVsVYRQQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031005;
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
	bh=hmQmRjrg5T5GHdQtIsV+WilVYPVX4l9oFzpZ6corH3E=;
	b=n1sa/6H2cvXu66XIDScWsIcofzGZUtr5FnV4/Kesr4cZXjYwGAS0GsZ5HZ+/3jh403He
	 H5JoN5Bu7tOS3SSCHXbEw9i2IOsK5/JJNZIgCe7OOSZ2dIxZz2nrA6mZAGa1eNUHO8XKa
	 8/leOBtIqyOC3t1eYvAll8Ji9+cFtTsbFdixxMsl7pnX3lRMjVh8f9/Sj6MV1xOXqWLVN
	 ODkQsgt0Z6xn41Pe/As/FQyuwUt+etlY0i9DhVIOd7IJ/8QKG4HD1Ra+WFaDWgBefFKke
	 e2cCdLFivvJQ/er6/w3xXTe56ygynQKBT+H35/8tMDp+D2yo9GxodsNZePL1T373Log==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jpPFSnRh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=L9h+NXht;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D4C606A32D
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38D4C606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jpPFSnRh;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=L9h+NXht
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031005; x=1824567005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=VPLT2B9UbWQ8nt2xz5oOYCgtbnrPPWIpGioNoKCJsEA=;
  b=jpPFSnRh+VvLaSqEGdZvNO8xxeCIuKc1Z9I6S0cp7jtui6lydC25o44+
   n1l+reLqq2aw3X3Tp728pEiRmvoidFWQt7qmCz2z1iMMN0dObp3YQMd4W
   AurjDldPqJ8ZGEvOgxtxqNTJ9IgGwu2uP4OU5yeQf5crPiIPsr6MCmW2V
   Y0QXjdVwX5wrFR9kZKMiWkisN58WiQ3gmsu69KaNHr1Y+5+UF/4EbIWd+
   LRGts9k0/A1OcDDGiuSd0rMiuhrl5nSEQpg6pl7WLrsew7+AIEMIiv+vU
   ZRqNjNoruIU3SGFKcCIzR6AOFTodnW5PnHlUdKy+keKcC0cSrcqWXeqGO
   g==;
X-CSE-ConnectionGUID: 5TfUjClbTTOobDzYb885fw==
X-CSE-MsgGUID: Wa1nBPIQS2+3iFYHeXmsBA==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158068812"
Received: from mail-westcentralusazon11010050.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8PlnWSPAle3UwCcmTU94D0UPv1rq2qOg5xwg8PgdAw85+Dn9VyEeo8cwTyQ+K27UdygPGClqiJO493GSQjxUfoIYRbJ/DTS0MHizIiA0tu/6bo0QvoqFo27pA/7kvCVQF37+mhuKxypBqwXuhM9p9TQsl2wVweK6tgVDWcsmVdYt8v4nZVDbvP605xGkoSsUfW7OZeuMxwiMViX7nf4HDrs8yyx+qKdnIxtEomsM0lfX92DQqlPsRtWr4CeKKtk66ScJxYhsEC6MHZpdKTBe/alJ2/rd/nMXhIcFxsbmRP8VD98LfLq7KE4OOdSflMtdldypYenjjRMAOkrsmedkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmQmRjrg5T5GHdQtIsV+WilVYPVX4l9oFzpZ6corH3E=;
 b=m0FLe5C4HRNKN8Ew2lul/pEl7luF4LCI3snpCU0kKAvd3AYuM7yQ/rl6iuviDJPblea1N5jfRGnr1g1eDmZj4Uq8XoAZ1/SQH+SbgySrulmnEmXUsz3uQDV4Zr8shl3L9Hc2FpXSqkX6RxtWvjzaDTwKN4+nh52GBGW4NClrMrWHQsOdTtGVURoB/WB18pNTH1TFpvtNsWKMElcanj9JtNKpSr4MS76EmZJ7/kUKJc9+a8AOOZ3PbbCjO9LXG80Ky2ZEAnoSEOdODuAljhYHnzNI1EYmw7ko0NKIo+urxxujICjP+QwxgG4qdfN/4vdM+6nIdqDO5batDdmzncrT/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmQmRjrg5T5GHdQtIsV+WilVYPVX4l9oFzpZ6corH3E=;
 b=L9h+NXhtQLsT8Q+74VELM4cP8wCHiLKV4XWy1riPw9PZtuP7pXNvtjBbH4N4T+t/vk2w0LPRz2+rE4PbCmehjbeFoh4F7AMzcD4GA/avSdQlI4jUrCIp6Vi5FpM2NTEkzojcy+M8coQyJ22P60jBoARp9USg5A2qeKb984QtlPw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB8472.namprd04.prod.outlook.com (2603:10b6:a03:4e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:35 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:35 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 05/25] btrfs: zoned: use the regular allocator for conventional metadata block groups
Date: Mon, 26 Oct 2026 17:08:53 +0100
Message-ID: <20261026160913.207909-6-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 25f04dad-3ed8-49c1-3154-08df337b8746
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|366016|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	7pIvvoU4skgFDlpg4ZLh30G9WGg0/Sl3gVYrDLZrHrGaTLoQoFdBZ7gNqwkfuSn5VHqlD4m8d2C0q60h0Z/VbfFHanMMU3zWCg6WyFhq6xWpo5/Eb/OO3Uf2MtBPSnNIg+niEMpimyO30BSdEBHsupHE5MqD17Nnk49aHKLal9HoIAFF3BnCDeR9tNgo80wQfLdXabfrSr6xqAptx25lz+nJx4CMsWhq1Y9t/ApaCRbddcRo+v3T1wfsWyJxB7ccWT4eB3zceGZKQT/j/rMHFCfbnaIn+0U3Nm0rj5jg41olaOXuwsmQeTUV2K52z8As8utAnojG1HTql5X2AKdm92LDathgjax3umx56pyenX8K/Szy6xlk+EayRuHF32ZIk0x/LwMSJKjcvJXyhORvWTx5Pmig2Nz6JKLSgAEJyep65bypqDswYotN0U2FsjGyU9cKywzhWaJIzLMVpBtLi5FkyO6elVM/QZzSXKOYe3NZwXpEm4WvyNjFxjlAIzDA5qzliKRu1B44UzJwQ2I4yiwD1X1A4NVOHtqmrVWYh4/pnQy56WFkolPnikISFXgf2ZI3LH2iiLEeBlfHt1IYW9BapYe1toNFBrtLHq9ZHo88rkPjgmN1YJVaT4EZ5kf/F0qKTWGw4bz+CwyHFlEd+pakitGEf3q5TSpOxRc8nJ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(366016)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mhT+/InqdktMEQDtbLtrt+b/zmdbWfrFh/9a0aNnlsRtNOHKwsWeZaArYHc0?=
 =?us-ascii?Q?VgZKBqZg008jKgVPstt1GVdGj6EZpZbXq0jNJQd7Yl+WozsWv7B5Ij4cRsEB?=
 =?us-ascii?Q?wXHbbAtney754dW74htmjgsKk9xKmPddc2SyCUlnFn+KrtLKY6tPl6WnAGol?=
 =?us-ascii?Q?JMBCFxAqYqte95bZJ+VaGq8kg90FfMiMg/MpKNW0vLNwFuOBwzEm7cpAg514?=
 =?us-ascii?Q?Mig6xrAMhbhM+79uXYki0HvgQc/wBMpHqbK4JakFw/c8fLN9wKPuS7FHP+A0?=
 =?us-ascii?Q?CAEvlGNX7XlO++WQMbYiNlyIkK2irVSmQBeTkd0UiG55xDUJkhFK7ju/uOfq?=
 =?us-ascii?Q?HrRXPULM67ohj7LuGz0+2tbDTZn62kFD3OQscgTRUIai6bCnqLx9aKrXJ245?=
 =?us-ascii?Q?YJxknCXkDJeJDWwbwcv+jLF8wN2XcodC9sAbWDeXXRizdnWPjx6564U6M0DC?=
 =?us-ascii?Q?votZcRpYWBc3O755An00+g5a39ZGWHF/Qw3mCoZ0dE22EEks4IqXUHAstOIh?=
 =?us-ascii?Q?zLhBx1ipYqhIT4O/ho+4NVHnsioZYjpRtDKbwBs3eh+u1NEzCRRSIsoFoq6W?=
 =?us-ascii?Q?nDIq1Fr2FXp4K3vhlnI2B7CvS2PE5caek99vaFjxcotYuNuRfb72pD7HAGHy?=
 =?us-ascii?Q?1lVdEDbYbsqZop9Kkp20tIs2qlxmdCFmkF+tZ6bEH1EmtV06j5oPOBikLBND?=
 =?us-ascii?Q?YmSjdfgwgXP5CdB67PTRDTJG8CT6iZx/8oMaOx8PimTN69duKQtukzDW6es/?=
 =?us-ascii?Q?mvLjpbsS8eyIWZCvf094CSx+CdikHXJaNPBdozh/ivw0PtG9px8WgW+EGVhM?=
 =?us-ascii?Q?zJqgHU8USeAoVUi0b2uipzmeNXIdwDlO2wcS20bNIjBIQlJNDZjOogjHZLm9?=
 =?us-ascii?Q?FujXEbuz3K+DYsi+5hPmdc8dblht/PUCSpuhjXGTsTKTfqipbkSMl8nY36Zn?=
 =?us-ascii?Q?igZfD00B/UOy4S+Uu0u6hwAvvpJqF8DzLlzL99XZ+7kRk0Ed0lxU7G52UOtp?=
 =?us-ascii?Q?yvaLuvrD6R/MxIekNB9nym+5T/qsTRXUZIuIi5F+lMZgfSA1dbSsAirrF/pe?=
 =?us-ascii?Q?rbOdLZ6gUjoUYHalFe3U1SeDdHpVHm2VKon422fH+uolcvkyFvLq8LbqHddv?=
 =?us-ascii?Q?fmbJdSbtSY1NSuGzRRo8Fh4ReWVYDH6S7xNua2IBrcsburhjp4Biy9yUsFcd?=
 =?us-ascii?Q?YNQ4+NMSr1fJEgOYL2OHLuqVnEQgY/PcK/d9NgCHGWk3SCI6rpqGOa7hOfY+?=
 =?us-ascii?Q?XExGhtMKx/HEplR4j8MD2FHm3pYNvCi867H35nEFgKzXskuIVmxHD1TDnYqI?=
 =?us-ascii?Q?/rv769BdSvL4H5Vp0x4UbUGac/xamzCV7thEGb+s4SgMg9FilibSrtqLpX1j?=
 =?us-ascii?Q?KiqDC25wY5c90xWlq+Hf2QunQse+rY07Jq0WHSJyx2gukorfEnrAU/ml5BNn?=
 =?us-ascii?Q?5kvEqeeNNcLm+g9VC5DDMJV7fD5DF8KUlMRPH4ItQ/vCBMN7WRve6NNFZFdx?=
 =?us-ascii?Q?utXN09LZX3eNce51NZewfxkOOUx3bGF+bAawEcdxKpa9CqV37nO3B25m4RSd?=
 =?us-ascii?Q?PqmZbkeNwYn0wvA2+kN60Skn7vNVK5G7rfs8bGf80xoABeul9KbGMg1ALyHH?=
 =?us-ascii?Q?xC/yDcPsLWJLsKX8OqJCpAmPqnw1ZdYtUQ8mEXRh9MkYsz75buD+ddrcTpjj?=
 =?us-ascii?Q?8i2IMGl9wL2/1fV5iJy7Q8NnAFcp88I6MTvKmUhMqNZjIREzo1JQufCKibBz?=
 =?us-ascii?Q?e5Mo6CcpBh4as0G+gi774DVQTMT98UntianIHdeWvUcG+PV+izQBIuiIDimN?=
X-MS-Exchange-AntiSpam-MessageData-1: 5ffAR5PjRSsjIQ==
X-Exchange-RoutingPolicyChecked:
	fTETscObgnZ0iCOLDc2j4UvWf7WxvByHIShGkpBnP6q3miTmR7V0ekQnSoZU/SjWYG2VRx1R1W0qoYOADA1VThoxEqOd7cxUpdm8Wio+OET3wNMJF0w323iRFGluk1QmO76I9i07dU02qzx46sNV0L3Wxa3Oa51P+y2RswJTWAMrm346oSmRY+DDf54gQ2p4Q3aUF864sS+WmvlzmDkhjZYJokW80U4QkCIAMMTxwnIuqwZPEbL8aWVvrkHgkfSTQOzhzOb3H/727m8ufgFNZlPpm1DfgPKOpilvsyS+Bf6CAgJJUvprouRhzIcKxDitR5XKgvlxxVZ+2GZwd1zUEQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nxaVzBMmE77S7ooDw73w5qxSae57b187CThXmNCghxbTiGoz/Myz6vF18oI7zq/d+UB8eG7wQ3D74hdM7wrOjYIPDpIQso74tK+MME62eGil5YwRd+fdoR/8A3UL+HaRz0OAuttEEL07yGaTWjL4hQlUYxjFzuTIQ8JVdRj3Iv0x4/muL/Bd6WBD/mwg83cRGp4We8nSqbHyRY0trxyfMavWLrQVJyi4wuT7TDHrod7ln1YcJ2ROalEL9Lq40+qm6e1wfswh4Fu2j/XzZ7SL3cjVz2TMHX37S4dsANmDqYOx+8AqAwOuNvcoNaco0meZVHZMPu+Lbh6il67A2/6rFmzZ6sfo3TyM1qXpkuUjoyhzm7cHAi0l+fYzbGPt4nbLO9QH1dcPQxb4K+TYNNXeQ8KmRn9tQ47flBn5xmcME15oKvJNjriqEqbrAGkeC7jboD2bf/MQeL8CHrTvjNeLKC1tPzq8X931fvBrlMit9OejNEQeHllfw5XiwCzAAhSBBVBopPII2GEkRrh4BuKfVHCasGBvX9oBLoXKy/BsCGKb7TMAlb+kApmJmKNkSpQrdCk7eUSPGtHjT//5m7pijb2L/mXFWfQmuz9JRB8tWvmBlUddjp24TK8rNJkHJ1+/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f04dad-3ed8-49c1-3154-08df337b8746
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:35.6711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: beOWACrzZS6f2DcK2bRINKUF861CVqDgLeMvWUeZ/9/JKgrixAyXHbv4y/SiqH/mf+GruN2AbvqnkBoQyVDw/VtXB7ntpDqboQXeGf8MIqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8472

The zoned allocator hands out space strictly sequentially from
block_group::alloc_offset and accounts everything freed below it as
zone_unusable, so freed tree blocks can only be reclaimed by relocating
the whole block group.

A metadata or system block group backed by conventional zones only can
be overwritten in place, so it can use the regular free space cache and
the free space cache based (unclustered) allocator instead, and freed
tree blocks become immediately reusable.

Pick the allocation scheme per block group rather than per filesystem:
replace the filesystem wide btrfs_is_zoned() tests in the free space
tracking, the space accounting and the extent allocator with
btrfs_zoned_bg_is_append_only().

Such block groups no longer need an allocation pointer either, so skip
calculate_alloc_pointer() for them when loading the zone info. As a
consequence they are no longer marked active and put on
fs_info::zone_active_bgs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c      | 16 ++++++++--------
 fs/btrfs/extent-tree.c      | 29 +++++++++++++++++++++++------
 fs/btrfs/free-space-cache.c | 23 ++++++++++++-----------
 fs/btrfs/zoned.c            |  6 ++++++
 4 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8bf93661aef4..83d62228e5ad 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -953,8 +953,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
 	struct btrfs_caching_control *caching_ctl = NULL;
 	int ret = 0;
 
-	/* Allocator for zoned filesystems does not use the cache at all */
-	if (btrfs_is_zoned(fs_info))
+	/* The append only allocator does not use the cache at all */
+	if (btrfs_zoned_bg_is_append_only(cache))
 		return 0;
 
 	/*
@@ -1455,7 +1455,7 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
 
 	if (!ret) {
 		sinfo->bytes_readonly += num_bytes;
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes to readonly */
 			sinfo->bytes_readonly += cache->zone_unusable;
 			btrfs_space_info_update_bytes_zone_unusable(sinfo, -cache->zone_unusable);
@@ -2553,8 +2553,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	}
 
 	/*
-	 * For zoned filesystem, space after the allocation offset is the only
-	 * free space for a block group. So, we don't need any caching work.
+	 * For an append only block group, space after the allocation offset is
+	 * the only free space. So, we don't need any caching work.
 	 * btrfs_calc_zone_unusable() will set the amount of free space and
 	 * zone_unusable space.
 	 *
@@ -2564,7 +2564,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	 * in and be done with it.  This saves us _a_lot_ of time, particularly
 	 * in the full case.
 	 */
-	if (btrfs_is_zoned(info)) {
+	if (btrfs_zoned_bg_is_append_only(cache)) {
 		btrfs_calc_zone_unusable(cache);
 		/* Should not have any excluded extents. Just in case, though. */
 		btrfs_free_excluded_extents(cache);
@@ -3246,7 +3246,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable =
 				(cache->alloc_offset - cache->used - cache->pinned -
@@ -3728,7 +3728,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
-	else if (btrfs_is_zoned(cache->fs_info))
+	else if (btrfs_zoned_bg_is_append_only(cache))
 		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
 
 	space_info->bytes_reserved -= num_bytes;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..4539a775cdcc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2896,7 +2896,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 
 		if (readonly) {
 			space_info->bytes_readonly += len;
-		} else if (btrfs_is_zoned(fs_info)) {
+		} else if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Need reset before reusing in a zoned block group */
 			btrfs_space_info_update_bytes_zone_unusable(space_info, len);
 		} else if (return_free_space) {
@@ -3685,8 +3685,8 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	 * contend with.
 	 */
 
-	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags)
-		     || btrfs_is_zoned(fs_info)) {
+	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags) ||
+	    btrfs_zoned_bg_is_append_only(bg)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, true);
 		btrfs_put_block_group(bg);
 		return 0;
@@ -4037,7 +4037,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	int ret = 0;
 	bool skip = false;
 
-	ASSERT(btrfs_is_zoned(block_group->fs_info));
+	ASSERT(btrfs_zoned_bg_is_append_only(block_group));
 
 	/*
 	 * Do not allow non-tree-log blocks in the dedicated tree-log block
@@ -4191,11 +4191,28 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	return ret;
 }
 
+/*
+ * On a zoned filesystem ffe_ctl->policy is BTRFS_EXTENT_ALLOC_ZONED, but block
+ * groups that are not append only are allocated from with the regular free
+ * space cache. As prepare_allocation_zoned() does not set up a cluster, this
+ * always ends up in find_free_extent_unclustered().
+ */
+static enum btrfs_extent_allocation_policy
+bg_alloc_policy(const struct find_free_extent_ctl *ffe_ctl,
+		const struct btrfs_block_group *block_group)
+{
+	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
+	    !btrfs_zoned_bg_is_append_only(block_group))
+		return BTRFS_EXTENT_ALLOC_CLUSTERED;
+
+	return ffe_ctl->policy;
+}
+
 static int do_allocation(struct btrfs_block_group *block_group,
 			 struct find_free_extent_ctl *ffe_ctl,
 			 struct btrfs_block_group **bg_ret)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		return do_allocation_clustered(block_group, ffe_ctl, bg_ret);
 	case BTRFS_EXTENT_ALLOC_ZONED:
@@ -4209,7 +4226,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
 				struct find_free_extent_ctl *ffe_ctl,
 				bool delalloc)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		ffe_ctl->retry_uncached = false;
 		break;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bff6e5b372d6..5d830a827cda 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -26,6 +26,7 @@
 #include "accessors.h"
 #include "file-item.h"
 #include "file.h"
+#include "zoned.h"
 #include "super.h"
 #include "relocation.h"
 
@@ -1370,7 +1371,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group *block_group,
 	int ret = 0;
 	u64 filter_bytes = bytes;
 
-	ASSERT(!btrfs_is_zoned(fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
 	if (!info)
@@ -1499,7 +1500,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 	if (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)
 		return 0;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -1512,7 +1513,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 int btrfs_add_free_space_unused(struct btrfs_block_group *block_group,
 				u64 bytenr, u64 size)
 {
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    false);
 
@@ -1529,7 +1530,7 @@ int btrfs_add_free_space_async_trimmed(struct btrfs_block_group *block_group,
 {
 	enum btrfs_trim_state trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -1548,7 +1549,7 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
 	int ret;
 	bool re_search = false;
 
-	if (btrfs_is_zoned(block_group->fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		/*
 		 * This can happen with conventional zones when replaying log.
 		 * Since the allocation info of tree-log nodes are not recorded
@@ -1663,10 +1664,10 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
 	int count = 0;
 
 	/*
-	 * Zoned btrfs does not use free space tree and cluster. Just print
-	 * out the free space after the allocation offset.
+	 * Append only block groups do not use free space tree and cluster.
+	 * Just print out the free space after the allocation offset.
 	 */
-	if (btrfs_is_zoned(fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		btrfs_info(fs_info, "free space %llu active %d",
 			   block_group->zone_capacity - block_group->alloc_offset,
 			   test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
@@ -1838,7 +1839,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
 	enum btrfs_trim_state align_gap_trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 	bool use_bytes_index = (offset == block_group->start);
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&ctl->tree_lock);
 	entry = find_free_space(ctl, &offset, &bytes_search,
@@ -1971,7 +1972,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 	struct rb_node *node;
 	u64 ret = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&cluster->lock);
 	if (bytes > cluster->max_size)
@@ -2789,7 +2790,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
 	int ret;
 	u64 rem = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	*trimmed = 0;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 00cf54d20b36..a78f1f4c7dcc 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1957,6 +1957,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (num_conventional > 0) {
+		if (map->num_stripes == num_conventional &&
+		    !btrfs_zoned_bg_is_append_only(cache)) {
+			cache->zone_capacity = cache->length;
+			goto out;
+		}
+
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
 			btrfs_err(fs_info,
-- 
2.56.0

