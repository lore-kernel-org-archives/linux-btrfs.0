Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031005;
	b=pEp6aUtfqp3FiD8x9B0AuKjITd4ZSyKY+26wDNHG7UkZtVMF+mk/dydg8qg/cnX+PvkJ
	 c5L+bCA7hX6qtts6t30QU5ocEQUktj7E4Fh9ChQm4ia9WD3ikO1NXlOQe7F+j9vFEYVvC
	 +55lWBPzfjBxrctCHwhPNnzJfF6gJlD6sazzhgAoVameM9QsZcKBtxyyFXeTN84by/BJv
	 bQ+fajWorGUFi+2pRTsPtYbiEqDO0OoCsJHqdoo45BA9pWPnjpcMo7wPyyU0Iu2yrYYrf
	 r+caMe6JcLFLjsdPlk/Zy0mIlsEr0g7usBT2O6c2PiT6ezhTtJfSKZWmcTd5gxsJ1mw==
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
	bh=hxC4req6poa3SvUiL8oJw0YPGwQ1ec8PkyMr9W/lmuw=;
	b=rmq8mhvXA9g8zxnAR6eNNPYn9gLCAvDO/5ZcT2MzZ1qsWfkEdF+3tcjV87pRjpByrRaV
	 qXL7KpVYcwUoQZz6X5mn+iz0EnFhUS5H3Gxmlo/8mz7aDY7nXvLpxdGBIlnIYUUm3GAVh
	 VvOroFKhHSTBnxVIlVF/Ht/f3JT3HNx86ffUQdbsjlDm7T1sQxiKmRbQr321Gqdj9xZVI
	 Vppz4ujl47alaSNY+4MB+5lRbXrUsI36Uk5uvkkHHunBx+nswUG3/lj5YKbv1RtElp3Qw
	 SEzhlFNEKIYkYf/4at6DGfrjsNXsE7SnjKQQgnzny0top7kg4UqYr8aRwNVsqRN4fYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=M51u13PV;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rvqfIZsC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9433A606A322
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9433A606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=M51u13PV;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rvqfIZsC
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031004; x=1824567004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=njPAK8FsSmGD/ZHJddRUJFwGzMMzFfX+kSyhLLKlh50=;
  b=M51u13PVOGqPXh+Q9ib8NWJbAcKJWpuqywOWjoo6QdvPdMrFSTfmtkCG
   AhyCMHmPCyadNOlSC+kzBlZ/Ga3gzKp3uQAptSOkgljhNd76TgV8trT74
   Jula7sEgrTI6GXc9KwTzHUMGSWE64jW686zWSkw68GuYiD9fMLX/vNg8H
   yGYQVMJsLMzVox8WUEo8xcOL395PwKO88ioEJr8VFzo69Nqluz60/PwNF
   MGm4c7kdOXwa9z+CQGZH8Ec9IauxVUkr2rb+RyIv04t8LgkniERx54Lpj
   Md+2sQ5fXHaqRjbzofuWGmwbyf0AI3Ie6CZtSAY2a+PvX6q7IGSrAhsKA
   A==;
X-CSE-ConnectionGUID: FIRcLhdyQ+yJj7+bI8gTGQ==
X-CSE-MsgGUID: agYDNE2FR8e575nrZ0En7Q==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158068810"
Received: from mail-westcentralusazon11010050.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nJSrfBNU2aRh/WOd1dA5VJc/2Q7truoMxtiEF0urUjm1VQ4/toYXRweh3a0tYTc8i9bul+sqV9lhKEMLAytLu5Bur6PYHAjlIraOEdAT5maiHCW0EevyMAaEXrhn3LMWcLLCJVQUaFMjG8M22KPV16ELB2gTWGT9tHRf4sM7zORggJCZiS5iOyA22Wz/rVVgZheMojncjce20Ui1lxG2VyWP0z9M6dZfOVLdGFbYPsDfyJ12al3fcjPf0W5YpDk+kCYpHbmuN9dqHrBa9zeSp/7nG3ukW9PmFpahUObF1ahQU+ALBV2TZRCEcUPm7WcczUpWf4TPZOCvPTHBTskVHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hxC4req6poa3SvUiL8oJw0YPGwQ1ec8PkyMr9W/lmuw=;
 b=LkTKDSbrD3++CngwF5qcj2BGNqrsf4nYyA+o7Nh2mFq7YIQjulLNYAVxLl1Zjb7HDuYUNPh1oID+G21G3HfG4Z5YAhZvuvNzZ+Hc31ilRBDPEwqqjgyZYxSmPfBE4XS4y7TRW1xmStA0elysf9SKar38QpYQMbusNTLunY98gxrPDPKgq6dut66ODtbOkNjQwaY3L6hUwt+jJwlsMVSMmDOS1QCRdZBFWOeN78/BJQMPigtWDEf1ko+37k8sn5TS05FfYSgDhX5Jgm0aMvJXhyPYXqOg5WYPgvmgcUmgb1DiNYF9R5Gaqcdgdn6c2Sz2mKuF2URFiuJwQDTC3tAcmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxC4req6poa3SvUiL8oJw0YPGwQ1ec8PkyMr9W/lmuw=;
 b=rvqfIZsCjb+OBpNIMroCddBVe+uARVbMj0J1hmmUhcSCDYVJI/ClEkRHOpz4LBUXgDglg7zcOwSgxKfiB6hQ7PbJhrgvuhuhYn4Np/GUdo+F8oMOoX5S+Jp+lOVAbe0pcwnKvybwJ9W9fH87M+KNNjfj0S/cQ4pykK3yzSde7mM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB8472.namprd04.prod.outlook.com (2603:10b6:a03:4e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:33 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:33 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 03/25] btrfs: zoned: skip the append only metadata writeback path for conventional block groups
Date: Mon, 26 Oct 2026 17:08:51 +0100
Message-ID: <20261026160913.207909-4-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 75fec1f0-7ee2-4ddf-3b5d-08df337b85bd
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|366016|1800799024|261026140227099003|11063799006|5023799004|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	DzLgxPkGnhPN7+DdfJmQkqXPLCUcmzxUqRKYw7sYZoPEfFttwRlCV7Q5zHXK1RHLZGJOhgZ+0ZmsQz90aeqWxHOlDhqFeiNTPMKR/ALdMvdf4lHbdRUGzcPzddx3dGmhHeEPhbY7/rNrYqOL7TpeclUmaKYeqnF+HQaiQ+wG7BdV14VRPTwcFHVU5qOhnFwztjJeQhiwch4pOl1ce4bws/hjBqDpOG0Zys/MkaqXW7erbGvlDiMQQ8a53BIlrKtCLr883+eb/pAHsAewlTZqppGCKgONcYPA4tuwF+8o4AjTMGwLdzYVCx7+gtQ/lYYy4Uadzi3Wc6waZQKvGJlBwzKKbcD+C+EyyYCUGKizHpcTxt0uGkhfJQ99JuLnyYMSF5x/SFxNMn4Dn5puBl8abQrW7LckXV69QuKU4C9k4sya5UP4BALNyGrznDzYeruVD5eb1s7qqt0407WGaDbqmJtb+Wn0PeFRDyZKrV7KiiqFsV3QqV8sxxFSRxM1QZ9FMxClJbPk5xNgeSKtT/5Y4elTvGEIqnpMWNaGv6BGW0vOQPu3Imeb2cXAlevxHiPKVSdGcvs7osxsS+9R895bEni/XSLTWPRbcggJDn9PovZkvbRGKMG1y+EarbqnAQ+CWQf1GsYx2pwYe9rt4uRtkk1PgUn3dCrejK5u3mohBew=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(366016)(1800799024)(261026140227099003)(11063799006)(5023799004)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nByFhEvvuI5LcQ8kUX+Z+qFnfDjMV+jCEjO32QaKVZpL1sYVBXaA4mqIaixJ?=
 =?us-ascii?Q?HETDfzrPhL3AxQkpflwQ9mcf+4ybuo2MWVQxEtDoTCzV1dr9gYgZHa9tk9g8?=
 =?us-ascii?Q?EYYAPbOy1PZlhvVDUD7LsCLoAmyrBhzVGKzQpw2fY2NoYX6X6Biqg/626ao/?=
 =?us-ascii?Q?3q3yEgju5Yy7YSqE1B8scFassfLhgvLduU+1jekAj2jdScJAbUKRCpvbMtp3?=
 =?us-ascii?Q?k/9MtI1Mj1JcX3uMZKPfEmvPa/pwdyVILS4wwKShmkSrPqtIctDsv0k220va?=
 =?us-ascii?Q?NNLLqckDIuvZGuRczkM9Z/VQ8BGMzn7jD72o8F6S4S9HLK2q+lfEPM7wEqZv?=
 =?us-ascii?Q?c0kQdb2R4UP7WmlQWs/jcbHt8LHA9DFPr1awu+J5zQXX3K1jLKupAUQZ9Zd3?=
 =?us-ascii?Q?R0vhgeycCuwEVjad5ovjUF8Wx2YcEqALNhvFKLqajygitsXbeys/ExOT6Cdz?=
 =?us-ascii?Q?wXAmSj+B5pMbrB3koGpduRCAgndaTV2XyN9X4e78Vsyk7LAM7diaHoUKUZ+s?=
 =?us-ascii?Q?poZMiKDFWclH2FGAcorA8sxw4KLR8FiOc/qHksTTs7OW4oZqkRd1TcFM1q+6?=
 =?us-ascii?Q?MejqX2bqXkt2nFMVQWKw6TjX1uWQu5l/990+Kw3LF5ARcpBD5xoqb/WggCc/?=
 =?us-ascii?Q?9YyyPFXdl4ksCLFSbXBD+edW0ht0r71qO0/4GHQca2THncV6lj+uVtZZ/ueP?=
 =?us-ascii?Q?MZL43E1SQdh7D/f20WOJ57M0cYsXpPVvzlHaQ7un8xi2IoWgYZY8aHLbksw0?=
 =?us-ascii?Q?RZ/YOjxeDqiexPCgYzEDFTF/2C+xHuFzhZ/AONNfb2uXVWfw+GbNsR0ayHVq?=
 =?us-ascii?Q?EOnxIEIhS2TBpp4epT6gbyaxePojpwxrEqgTvLBS5sDoNpD8LsLOM6VE7DRX?=
 =?us-ascii?Q?WgMZoQZ2wk3XSNbNH3qJ2Ui/xSYupqCS/zx0ovF1wpvGQlhKnj0+pf6vhhuL?=
 =?us-ascii?Q?03WI+y5UX1YSVdnjcCF3rrYZz41PiGdU0XdXAaErwHN2F+GcT6OLF+bRpI31?=
 =?us-ascii?Q?A0km/cY0SRu2aSXGaMS56D/ZqfSBY7DLJERL+zSCAzzV0xcWwguhVqhmyYxU?=
 =?us-ascii?Q?VlQ5/xgGFka1ydA/vWnPYgQ4Mqlxx5A/ukSUyvf8gQggm2LUn7HQxzYzQGsf?=
 =?us-ascii?Q?OP7PaxVa9LXwmLVVmFZa7hrHogQtDRvw5rp4G3otvhasCOl5k+MuyUZ2puYT?=
 =?us-ascii?Q?fbjmeQI9m/C1UMXzZAHB0yRsA8rJDywRfl9MCkVGXcXeFBE3FShERONZmrOT?=
 =?us-ascii?Q?OPTsmk1Ovg1CsTAIVGccvBoet9Jl9oWytHuyhJ9w/GVYAei5z/0evDO4iQSb?=
 =?us-ascii?Q?Fb5Mb5hTosiTmHXJ9wrH5MzNkK3VQipQI8+uT0dMJskmjMFqSP4l86DuLa42?=
 =?us-ascii?Q?r3voT4X5idZG640VqQgZX2ps4vLfI3ixrXljb5Q8MDGCcxytyhCbELxnWyVA?=
 =?us-ascii?Q?2ZkbnXnEsl8xh3VRz2qFCtHr/wPF4hFmcVZVcAhT8DJrrG4igYz4dpyyoQrU?=
 =?us-ascii?Q?xnZ6hwLKYHEc78MXta/+8WsGD0iws/AFcV9/TjvXrQ+6SEKRBNWikNNqBvTC?=
 =?us-ascii?Q?H6pz5GVveU0+usEuJgwMKFadIuJz7cEIFo6UhELSWC22aw8qv/euLbDM0U+A?=
 =?us-ascii?Q?l0ZL4VnA+ieniZ2gB8pkXY4jPLoVs8mkqIOWcJkliMnhOXKHXTUbYpf8mdLq?=
 =?us-ascii?Q?e6/1Tw/HKkVnf+CvLNTVM8/Ae5VDKUSZzq2u/FRHBknyEvTpKJqFDwDcPZBe?=
 =?us-ascii?Q?P9+fPKbiOlbLqJ56bhpUVe078zS4D8eCbKkMKRc2KuBk6Evq9d698lhWbO7O?=
X-MS-Exchange-AntiSpam-MessageData-1: BGctSLHApha/oA==
X-Exchange-RoutingPolicyChecked:
	5TLXEXlvy/OnzXmZ87rOb9pogfKsHCF8yD6y1Fst30HmFdA0cRnk3OwXBmggJdpTmXYxmeNP4DbDt6P0e89ejSZjLxe/6YPIkPKt2AxxFFGM8pch8LyXi7ATixMjfpxyiqi6tsq/Xa1n7Hp4WuQ9i1FpzwHvgmYg9J49HhLwZIcbGs+UBNaY1On5iVzJoQpGKMaYBG0gJaNLQQQls9SdMqcClmATU3OtePWf278NKGoNdDR7sbb6tgZeFEpkg2PBHdz4iKR4EjDvEJmqxfOaCLj/NwD3TVbUplndBNKPjEAxUDZAavq7CwILxvFIXmn8pi9Odq4Tmp/wNncCZXDNWA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9vYZtYF8rO9mibQ+YjofvjCdZPb0hPM7TjJMG5c0174SVRhoigDUF7RMG9EV/iAwSpG2i1UqGKQvH2mA5pKuax2JKqJVZom5JKsvNEry5uBSZ0hpVcyVoL6kMrm+wwLugX4qqTjMWds+r7dKljcLweNddvqM+HxcaXNfXPhcogyYVUgvvJp6r6wbfpb74y1wtxeH3jNNTEXpXKFEdccRUwYoVIcWsM8SMlYhG6R2++wXXGaBQZQyIpxhjIl8NwP6pua7odrZEHzLWbzwsJKof6kbNrtF5I1Cs/IuDY6uZ7w0/EoDjFYnABy2G/Sv+kSA1+OYSkj1YbVM5SyvyPEEEQlzcQo8YV9FDiJPRJtekKUPXYWDNbCYRjgStbCGatY+V5KA7ekYIyrmIm0c1MGlhEJnazEPDPVKPxU3jqXcs1qKJEJAnDq/aJUqBJWOoarsvu3aqUEyUHV46H+fqwGnae4J8G6wrAU9hrVyG0t2CpdmUpkDaEOsPij3uYlAyu7+hRG5eUaysGCfPvSMzNTOgrgUtpKMUzKC7q0TBmkNCxlFyfKAYuBj9KCeGO4Tc29wBKbDAQGHS7qvIGiGa/JhKOBgMvgS63wg1REINW9acHSpYuw/qLyDnMtRcdYo5u1X
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fec1f0-7ee2-4ddf-3b5d-08df337b85bd
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:33.0089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNFgCpiYO3b8v3nqYgRLpJemQtdIVApfahcnFtFMsSttWjNNwJ6xGodnTKl6ygxxzCtYpTRo5LmoL0m6S8CwuB/xPaWsTcUS56z/ZT9Tq9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8472

Metadata living in a block group backed by conventional zones only can
be overwritten in place and in arbitrary order. There is no write
pointer to honour, so there is no need to serialize the extent buffer
writeback against block_group::meta_write_pointer, to keep a zone
active, or to write out a freed tree block as zeros just to advance the
write pointer.

Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
for such block groups, which lets metadata writeback proceed out of
order and with a queue depth larger than one.

Freeing a dirty tree block needs to know whether its block group is
append only. Count metadata block groups with and without sequential
zones, so the block group lookup is only needed if both kinds exist.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++---
 fs/btrfs/extent_io.c   | 10 +++++-----
 fs/btrfs/fs.h          |  2 ++
 fs/btrfs/zoned.c       | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/zoned.h       | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 477c14fbcb4c..8bf93661aef4 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -64,11 +64,11 @@ int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group
 
 static inline bool has_unwritten_metadata(struct btrfs_block_group *block_group)
 {
-	/* The meta_write_pointer is available only on the zoned setup. */
-	if (!btrfs_is_zoned(block_group->fs_info))
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
 		return false;
 
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+	/* The meta_write_pointer is tracked for append only block groups only. */
+	if (!btrfs_zoned_bg_is_append_only(block_group))
 		return false;
 
 	return block_group->start + block_group->alloc_offset >
@@ -1204,6 +1204,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	rb_erase_cached(&block_group->cache_node,
 			&fs_info->block_group_cache_tree);
 	RB_CLEAR_NODE(&block_group->cache_node);
+	btrfs_zoned_account_meta_bg(block_group, -1);
 
 	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ff630630490..8b49581eeffa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2535,8 +2535,7 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 	if (!lock_extent_buffer_for_io(eb, wbc))
 		return 0;
 
-	/* Implies write in zoned mode. */
-	if (ctx->zoned_bg) {
+	if (ctx->zoned_bg && btrfs_zoned_bg_is_append_only(ctx->zoned_bg)) {
 		/* Mark the last eb in the block group. */
 		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
 		ctx->zoned_bg->meta_write_pointer += eb->len;
@@ -4170,13 +4169,14 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 	/*
 	 * Instead of clearing the dirty flag off of the buffer, mark it as
 	 * EXTENT_BUFFER_ZONED_ZEROOUT. This allows us to preserve
-	 * write-ordering in zoned mode, without the need to later re-dirty
-	 * the extent_buffer.
+	 * write-ordering in append only block groups, without the need to
+	 * later re-dirty the extent_buffer.
 	 *
 	 * The actual zeroout of the buffer will happen later in
 	 * btree_csum_one_bio.
 	 */
-	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) &&
+	    btrfs_zoned_meta_is_append_only(fs_info, eb->start)) {
 		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
 		return;
 	}
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..1597bd4512d6 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -919,6 +919,8 @@ struct btrfs_fs_info {
 	u64 max_zone_append_size;
 
 	struct mutex zoned_meta_io_lock;
+	atomic_t zoned_seq_meta_bgs;
+	atomic_t zoned_conv_meta_bgs;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1fc3d1e418c9..f3063da06978 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2007,6 +2007,7 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (!ret) {
+		btrfs_zoned_account_meta_bg(cache, 1);
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
 			spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2288,6 +2289,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return 0;
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
@@ -2315,6 +2319,29 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return -EBUSY;
 }
 
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical)
+{
+	struct btrfs_block_group *bg;
+	bool ret;
+
+	if (!btrfs_is_zoned(fs_info))
+		return false;
+
+	if (!atomic_read(&fs_info->zoned_conv_meta_bgs))
+		return true;
+	if (!atomic_read(&fs_info->zoned_seq_meta_bgs))
+		return false;
+
+	bg = btrfs_lookup_block_group(fs_info, logical);
+	if (!bg)
+		return false;
+
+	ret = btrfs_zoned_bg_is_append_only(bg);
+	btrfs_put_block_group(bg);
+
+	return ret;
+}
+
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length)
 {
 	if (!btrfs_dev_is_sequential(device, physical))
@@ -2581,7 +2608,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if (is_metadata &&
+	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8e21a836f858..3a2ca8bd68e5 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,7 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
@@ -215,6 +216,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
+						   u64 logical)
+{
+	return false;
+}
+
 static inline int btrfs_zoned_issue_zeroout(struct btrfs_device *device,
 					    u64 physical, u64 length)
 {
@@ -432,4 +439,31 @@ static inline bool btrfs_zoned_bg_is_full(const struct btrfs_block_group *bg)
 	return (bg->alloc_offset == bg->zone_capacity);
 }
 
+/*
+ * Data is always allocated append only, even on conventional zones. Metadata
+ * only has to be, if the block group has at least one sequential zone.
+ */
+static inline bool btrfs_zoned_bg_is_append_only(const struct btrfs_block_group *bg)
+{
+	if (!btrfs_is_zoned(bg->fs_info))
+		return false;
+	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+		return true;
+
+	return test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
+}
+
+static inline void btrfs_zoned_account_meta_bg(struct btrfs_block_group *bg, int delta)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	if (!btrfs_is_zoned(fs_info) || (bg->flags & BTRFS_BLOCK_GROUP_DATA))
+		return;
+
+	if (test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags))
+		atomic_add(delta, &fs_info->zoned_seq_meta_bgs);
+	else
+		atomic_add(delta, &fs_info->zoned_conv_meta_bgs);
+}
+
 #endif
-- 
2.56.0

