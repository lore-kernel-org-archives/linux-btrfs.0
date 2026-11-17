Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941996;
	b=Tx+1aso5xBHS+TncZRJAB5SoP/e5lWArBnni9V0Y5X8McKsQknb7dz4rxXJmaPggBO4p
	 d0uUOJ/iwxarW90WRvA1i23dU56/hAMGYA5vOXCPBe1w7GHDGygG7H3cLEi7ATsSEU7DS
	 JRsgBZre1Uv198CFCgxmZnHqR5KLD69QIVsWF7H/s5eXw5re1FRx6YxTTl8qVPN4ysC2j
	 8hgTujZrpUzb9UcIkKHyYL3HmVl5R03pWK1rrcDwCPECY17FnxlSD0uBKY3JedB7RULfJ
	 C9M599B4YeJipvziXSFzD/prSCrUfZeYQyG0rt5r0Oa5jJMqHcFpKwjXIIymZTAKPbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941996;
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
	bh=WTckcHRvDqodONsOpQc+j2MvqR3Vl485x3aNkSrHj3U=;
	b=ij0GyC6KUc4XKVzGORs+It6JeelSql2M5XRGtLCIzhNHq7NHGCVEtYlsJOYvaYWw4pbM
	 TAvgucjTqwQVDqgRwvs5nIzQl9m1IPoS6JDg/sOU10qfBaPTDW/S7Fc4Wt8RQsNWuLb7g
	 wirvD6NP0paYVScgGrSAl+k65ZJdPjoPSlGkYkLCdNA50+Ahh3u/b4mYQPngnlOG/5UwR
	 he6z6iMXhLwEgEnS8SeJXXN3o5lFH9V/LYGM53FczrU6+Q5bmH6MSCVMPNhJy0jq/yr2R
	 g2Gka26OxBrSp+oIl/1ARiqRirFeUDH/WnCdzP8xMABPsX5IBRz7+nWoJyfM7majwsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bCsd6r35;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=cblJBm1N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5478606A32F
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5478606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bCsd6r35;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=cblJBm1N
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941996; x=1826477996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RhpsKEn2W9sMJ8ZJyhk+ny78Q3AJol3TLhmSS/4Inj8=;
  b=bCsd6r35F3p+7YI31/29igCSCV7CldADVi6eNHHi5EN7trlJ6OJS2ff3
   NUwQXlcyfvknMBNgaDwUMqtcoHotZImMrlpkxKRcTALELFxp6ewci4zPi
   hDqaAUtr7eXwxPoQrwk5ptLupp+QJ1mH/J9Mv9HfAlUTlNx1fvafFZD4Y
   67mC9iOtfR3EWMiI1QYnSKvvasTgiq3l/yzuGyIQcYWE6zd1qPdnxQ5nL
   pLSDZqYUiJWHmLOqMSfrTM9j5MEiB8JFkKziqsCYzCdA+RYbWyrTIs8oi
   0FJklsXXAqvKB8BxIkUqOPTpDFuIFmoZrO6TXruSvGCV9WszCGR32W9ud
   w==;
X-CSE-ConnectionGUID: XfhOUX+TSSumosvI5QOdmA==
X-CSE-MsgGUID: N1m/08/dR8Wazt5UuCcgug==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161122883"
Received: from mail-northcentralusazon11010024.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.24])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FWBtg+DrOOeUznEetRwRh41npBJpuBP3+YCbkJBQXbsjjKFCcs1W+8m4q0BUprcf4tKvfs4MfD3wGgunLINtFOZN4j5jEuUw+fmX0WXtT/8NyurBtgHhBX+vGbWsWg5ztOZa7OFWhSR5fhsdROqsy5NlNlvLWkRpiaVwGEFvc6xmNUhXAP07buQWtunAVwjHQzlYis0z9XzjQ5mCAig1/h8MBJWSPhtA445WsNWMQ+13RVmTN8YaulvGJxS78DCwjC8rlXgjc/B+aIA8LY4EPQm8/JoHOFnCgavl9pA4SZ2plzFiRxKGZ7o4bm6/26SNwwn76mhzcMUAPj1Dn2qzHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTckcHRvDqodONsOpQc+j2MvqR3Vl485x3aNkSrHj3U=;
 b=v6GdsC46l96a+Gqz1XzMqhnOOmA1IJ1L1bB8t9gJr/vNbNy7dCVdy60+fJxzA1MRBeYs+6mKHEzxs/86s8lkJ0xe0rBLYluVpOgcIK6dyLPRo4JcGOD1zqG6nAiQmzOEQkYgviViRFVHAdRWKv+lXo2K46SVhlyHWQ8iqaR0iXChWHPB5Oz+VexER7ePLEAcbHYJnrEKEbfVKOUdVRrwhslvfWC1IwRAaB337oVb4rtHztI1+UJ0Lhjk9fn5dOtifbpKPSQRjpiuh/YhkdeLcLImWwbumh/u0msSNz9dvE9nEHxAr59ElfxaTPEQRzYaE5pd9PqNufnADvj4rKQQlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTckcHRvDqodONsOpQc+j2MvqR3Vl485x3aNkSrHj3U=;
 b=cblJBm1Niq1e9T6pESZKRbvPp9nR+8nHQH4X30I/8uC379w5WA5FSsENeIqGHi0tvaPAyIg2PSd8pKthyKkfRrcBxEYP7isZv8GLOPvsd2uuIUAHY2OCKkZ8/Ym3CcTIsLnpFlAxt/X5WjrN/dPzKyxF6DGZozrx7OvtlPC3mFU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH6PR04MB993818.namprd04.prod.outlook.com (2603:10b6:610:382::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:11 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 01/27] btrfs: zoned: don't wait for a zone finish after a filesystem error
Date: Tue, 17 Nov 2026 19:58:24 +0100
Message-ID: <20261117185850.4128157-2-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 39dc5931-0161-49f1-3aea-08df44dcdda1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|6133799003|22082099003|261009223027099003|11063799006|56012099006|260925022911599003|260925021911599003|260925021311599003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003|261022075727099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	YDeytjs5gMVRBtVqPP7TDsbNlg0ALIcxarxs4LXLPCgJykRGgv3qzVbm/CRrIb7Fo0W42oHDlPq7BKcypcNx1d+Y3TeV6iYGKrbAK9kxjEyh4ZiFhbZjvrhgs95/gv2BWAY20mSIEy0/3qySTP0FTB2gE4oZ4sde0WjF7UbS7DeXNjC4PHl14vWxCie0rc/XJggJHJ+jZn5WUgJrv2RVCnjym77ZBRN0DMMOXVTS79WnDgwq4bNrO6FK063X/GopyPwiZbju8qRpnLRCs1pq8ei3fnXWHj900RD34BJzMhl1tzQO0OSWDnc6nVisXYoA0SOI9LKGueP1nyP/EkGH1FeUxqgQyRRv8oA0zCnV6uj+fjZLHKEtBUNKKmuyegHYq/d4CIQfy66vz8+46D5S2hB7rn43Zw8pP5f6S20KX4C896WjCMdDNBIo93q6RXY7vLYSNIz+gUtdgcmCi7Mu5vUGGA3K7juxunP7e41pZC+EHFh/PAzC4FDl+DTxr3GDhOlwr1g2EeBhQL8N6wDFtyKKNynM6Lgzj++EeGcBRMEqU6hL+iHqdnM5+FJctG/6ro799Jpx1nfAk/rmvaH3yETx9LBANdUGMjEASUuioVJPHIF0KtYr4ENOqmZfLwsUJdEVZfMgHMSiZjfoU41M2qF/b+iwBjGTAPeMQh4X2n8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(11063799006)(56012099006)(260925022911599003)(260925021911599003)(260925021311599003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003)(261022075727099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fqez4pfN+m6vS0yrO8ebiLB+sfLlqZTMKt72FxxRPpndVwH+aX0y+DXdTLBF?=
 =?us-ascii?Q?wLOJBBN7TdShMb8pt7eY0Qj81Ae3MpPjiXr7814jJ8FFTVBZWJmrLGZzclR7?=
 =?us-ascii?Q?kQ8pdWvZY8RPMe7svfph38gj1P0TcK4a7hkliGtZqLkA5d6kokE5/k+hfX+y?=
 =?us-ascii?Q?1w6rNPL4d/pQPUMJxkP2bEADHVSZCfTAznhCv249opEhcgMrZf+X4cbnK45F?=
 =?us-ascii?Q?Xwd8PxD4qaPh1++7m1tHyKilHl3LG9AzsMbBGR6Spvz0XkgKmXjCIIS9iFsO?=
 =?us-ascii?Q?0WHLPOOCpShBRYRZIQPD5JUg8EMz8wT4/APwkMrbB7E8nOpkcSS0hUT4uS+p?=
 =?us-ascii?Q?2KyUD1j2jMlKzSAfCI7NB0TbP7Xi/E54PUdzazeOgkrBJAW3Z/07bsd8gqfy?=
 =?us-ascii?Q?oA4v3Wnqw8LZvfKxxzKwr/ASIDPg39OfltHYpFfLHJfa67PqQ9RYi3MF0sKo?=
 =?us-ascii?Q?DGkVerEXnge4qdc7r1nwPTFNHVqpAdFkvutdE1Gs9U3Nmu0t8NmC9dlTWKz1?=
 =?us-ascii?Q?7NvRgsrbSQ4lVxl+D7rnYeIyijstAUDlCsVyA2qpr2Sc4TObXD+DXX+5qqiL?=
 =?us-ascii?Q?8X9/fW9TPLbrBT83W6ZpARmll1M08AYlPgSSlEnlwMm9t36oHiKPyIdnCfs5?=
 =?us-ascii?Q?6dc9pDdo9JTcVD4wehJ29vcQWB7avUhCOB+7agesyVC4siAlve4i61fG540g?=
 =?us-ascii?Q?KSp7TRcVzWboeM+wIv9rH4cwF35RmIPxfoUo/Eq2z31vLlwd5u9QWy7YSr9l?=
 =?us-ascii?Q?TnkXonfnnK0WEauWlwAA++Xm6xZSomRDgs0ZMUwjoVPmV1ES712wncW46PG9?=
 =?us-ascii?Q?Ut63xWySWalAiSVxTimwluNi/BqytVfXUXGw/MscpVQTSv7yK6BFt6GNrKCh?=
 =?us-ascii?Q?MygMQU1vafYQW8HLyIoh1igo58vryV/kA++Gs8iekU6Y973v9FUiNx4Wb8BU?=
 =?us-ascii?Q?FrXSaG4v0lUbCLXeD6jcapcdJvfhiMa0oUBfwmvvXL41kq4lWdO74wamF7VJ?=
 =?us-ascii?Q?y8AyuE5/VeV7SZRfGnxKANbZ+I+JL7xX6uqd1wY+lW6stOF4ECGYo+PXos7M?=
 =?us-ascii?Q?/s3I6K1zC+9+excJ589LT27PaKTPI+FR/HTargutLD0nnNUy6OQoEckQvHng?=
 =?us-ascii?Q?CPQjSwjFOd0449bCv8Qp4XlSwF8NI4HYlHvZYta5bLLK6krvf81wNVu/z64d?=
 =?us-ascii?Q?ie+ePO+vfmzT6CWtlbtd1xp3Q/O7co4dHvlCcDSfz9GdtZKcqSeN674adb4/?=
 =?us-ascii?Q?axqAMtXzbQ3m27DU082pSzOFuZH+DLCjP/hoXrGjP3fFSwEQ1EQhSZ4yvL5j?=
 =?us-ascii?Q?y4IqX7HkN+Alzy0l5OOV74NfYd18T7/oQEQbgheFGYZ3dQ/wQq6MZJMX7VP2?=
 =?us-ascii?Q?ymYsFlY5iDKwt/Kndz5eW8FgecMjQDSm8Uy7j7kLeucVV0yc3aRjsA1e/aJW?=
 =?us-ascii?Q?e0rkc3Cacv1gRvnQGh9P/RRwBm4ncUm515qsFjvJFMBfZwlNgDlqq7tFCidR?=
 =?us-ascii?Q?6hzyztW8kMBesECZFmQ+0HyO0nv0FYvrwhaCcGn0cc0lHeqQmP+4jqxgTfVp?=
 =?us-ascii?Q?+2RlvpXLVHqrhwzFI90QsX07+5Z7xr0CYnQZW6k8v97lpdQrXKlk6hyabaBv?=
 =?us-ascii?Q?Rt2vaw6EaU7o4byHLv9YARy176winMw7tcCL5vyAdeWinD01PxiW0kpRp8QW?=
 =?us-ascii?Q?TSOepb9GmIszogGFzQTOCe/k1zs4ES4xw2mL7KRZhJqjEum2LZ/U5F96u77O?=
 =?us-ascii?Q?6tCObQ4/PeYsBR2JoiQUZ82L0yvrY4LSY0DsBFWctIWd6utm3x1yEPSe4iuq?=
X-MS-Exchange-AntiSpam-MessageData-1: nYQ7ElIvSXuwMdzmQkARfCXfAFgPCpysSf8=
X-Exchange-RoutingPolicyChecked:
	nix7aSbHvneM3px+8+ORZu2qrADOLzP7Mj+9tFVnu3tvVcOj+zQ00lqhrEdwNE6yGCAWBC1EQPDXpQRfK7gjpNwQQgtRDlbKu7ukUPLb6PvDz2zdnFr8Dx36p55+PQSTGnkhSOKMOGwibgr1LUP7uB38PM9sFlp2w8IPLbmNwY4LLKRG3InfutfVVjb66WsN7aDZJo+pdRtwrhL/Q1hvk44GK1qfECAHGFMh/P0d01Im9FK1hfLO50B0yIihmwUrfGpLr89TfLs0mIKOquNY9z+vL79uBy+alL2iabaM76BQTUwc19OiT6ho42+HJE7Y+S/XC1FAkKhl/UIkTBFi/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p55ifP8mu0Qr2hl6D+Qq33Rsf0vUZNe3QMCRpgy4YAyn92eWgYNKyynyXrVZ/CCeriIe7wK/NHTOjCZuVfx7jwpaf48ngMtSla3MY3C0Pr8Mmz6bPC4LBWSvSr99/UlltgNCy8Egde2LGAsRLihKNxmJIwSnF7Ft+PUfY6lmf5c11MiyImNn6gDpuAcM2dPNEa20y0CkTgTTL3iNAwRFxp7qaPHBleXD08YdClH3F/f6QcO7fCFRzbJGVbNWsRGvegO8ZrV1nczPE4b/y7Xn0KooiUn9aQ/ankyXeQdwheOcYt1Xe2y32IFFTOAL2BKe77GAkOGvbspmSts9yKPOSQniArsoW/NSUpFt+sKV0m0BO01C4NOG7GFAA+CrWf9B+EZq7h0pPm9zS1qyKboAR1+4Xn0PrNGil1w3DC8pV7EYRah/tJ4lnfn5BuSagvsPHinMY5N2ifr7PEcKmj/SLbxAsP1dv3X4TouX3Q+DBV/tkNNpSWshz6mtudKliT6ZQ4tRvLUYV+0EDazRGtffcNi2j1TzO6CCt0bmDVJ3SwKEMD07YbIFB18iM5PrSbBUauSBT08+VrJM4PjflU53ANRVg9JRZF1z6XUPEmyR5KcHWEzrvlgNeKrOrEib3RKV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39dc5931-0161-49f1-3aea-08df44dcdda1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:11.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p78IfIyUwwmxuMFQT25DstVSZGuKdy/dZFZSynUlca0mmTKhsioXBwCsyb6+WlYHMG8EbAXQgnvm1IZ6x6Fpxk+DavIgLTdQKgUTUC5TB/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH6PR04MB993818

When no zone can be activated, buffered writeback in cow_file_range() and
direct IO in btrfs_new_extent_direct() wait uninterruptibly for
BTRFS_FS_NEED_ZONE_FINISH to be cleared, which only happens once a zone
is finished.

After a transaction abort or an emergency shutdown no zone gets finished
anymore, so the waiters sleep forever. With writeback holding locked
folios, btrfs_cleanup_transaction() then blocks in
invalidate_inode_pages2_range() as well. generic/388 hangs this way.

Clear the bit and wake the waiters when the filesystem error is set,
clear it again if it gets set after an error was recorded, and let the
waiters bail out with the filesystem error.

Fixes: 2ce543f47843 ("btrfs: zoned: wait until zone is finished when allocation didn't progress")
Fixes: 776a838f1fa9 ("btrfs: zoned: wait for data BG to be finished on direct IO allocation")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/direct-io.c |  4 +++-
 fs/btrfs/fs.h        |  1 +
 fs/btrfs/inode.c     |  3 +++
 fs/btrfs/messages.c  |  1 +
 fs/btrfs/zoned.c     | 10 +++++++++-
 5 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 2cad9f048f4a..7bf048dfced6 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -191,7 +191,9 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 		ASSERT(btrfs_is_zoned(fs_info));
 		wait_on_bit_io(&inode->root->fs_info->flags, BTRFS_FS_NEED_ZONE_FINISH,
 			       TASK_UNINTERRUPTIBLE);
-		goto again;
+		ret = BTRFS_FS_ERROR(fs_info);
+		if (likely(!ret))
+			goto again;
 	}
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..84a6eb2ebf83 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1232,6 +1232,7 @@ static inline void btrfs_force_shutdown(struct btrfs_fs_info *fs_info)
 	 * So here we only mark the fs error without flipping it RO.
 	 */
 	WRITE_ONCE(fs_info->fs_error, -EIO);
+	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 	if (!test_and_set_bit(BTRFS_FS_STATE_EMERGENCY_SHUTDOWN, &fs_info->fs_state)) {
 		btrfs_crit(fs_info, "emergency shutdown");
 		fserror_report_shutdown(fs_info->sb, GFP_KERNEL);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b29b82eb180..319488794320 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1409,6 +1409,9 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 				wait_on_bit_io(&inode->root->fs_info->flags,
 					       BTRFS_FS_NEED_ZONE_FINISH,
 					       TASK_UNINTERRUPTIBLE);
+				ret = BTRFS_FS_ERROR(fs_info);
+				if (unlikely(ret))
+					goto out_unlock;
 				continue;
 			}
 			if (done_offset) {
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 73acb69c3849..2722751401b0 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -163,6 +163,7 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 	 * send it down to the disk.
 	 */
 	WRITE_ONCE(fs_info->fs_error, error);
+	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
 	/* Don't go through full error handling during mount. */
 	if (!(sb->s_flags & SB_BORN))
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index b1be02eeba68..ca0aedb916bf 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2773,8 +2773,16 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 	mutex_unlock(&fs_info->chunk_mutex);
 
-	if (!ret)
+	if (!ret) {
 		set_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
+		/*
+		 * No zone gets finished after a filesystem error, don't let
+		 * anybody wait for it. Pairs with the clear in the error paths.
+		 */
+		smp_mb__after_atomic();
+		if (unlikely(BTRFS_FS_ERROR(fs_info)))
+			clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
+	}
 
 	return ret;
 }
-- 
2.56.1

