Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211721;
	b=Aow/L8KZQv83Ry2r7QtZ9WW9bIkG4VTLa57VQfQ1P656mKxR/cDv6afTX34jCutSZnFM
	 h6K+Z1++6zhLfJ9GErwxavwTIbeFivIeyGsSh6SoK5CZ/aIiHZpy4CTgVfD2znMAD2Ugu
	 Jx2Q5rk+esxZit45yCvckTSbXx74wB7AoywhrjBHm+lKZQyaFkiYI0KloTcfPgCiPsg0t
	 nuEh4EKzY4Wl2zXLwaAQ+CsFmhRMWvk4GzZz6CCa67/9ZF0T2pHwrJu/kpwewXft99YN3
	 8upPGJxf5CjNbzK2Jv3v3ZWHiSQ/qw6ceTVZJsQyNHQW3cSDmrVgkE2HV1DaecfeJkw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211721;
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
	bh=VcvNvR61adkRODmpOyQ8lM60tuuQI5V6EbNjmEALCKQ=;
	b=WS4CiXNqL2Lgh+RTtxk7wEk3U9YmXFv/au6p6WXMHAWycE1yqOV1laQcIRw/jXW2HwkW
	 9J5aP6YXFU6j1xUuuSGgQf2C8tkSYpXFQkC1qnUZVMAZxdSMBw3MNg0xCTRUII+SHnUhJ
	 vCRGq7wSc970xxMZTU9giCipxi1H89CG4uneV91Uj2UBva5Ya/bnNE3cljvIKA3u/hpsq
	 FuqrEhCMtYafSYObG8WKt61TrJcIuCvTf3kC84IQD9okf+7OY2rLUQx//GjbrGxo7LzOD
	 TinwmBOjt8DJrPOeP8r/KcU4Up2dcPqOIvjXzkYgiFyNQ/js83cwriZQNXyGHoBG4KA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=gfmChkwJ;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=gXalnGcM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2E660A381F
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:22:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E2E660A381F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=gfmChkwJ;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=gXalnGcM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211721; x=1824747721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ljqjWbTCjiacQQZqZRr0//EQJLOf9DKCtHsFyaQPLhQ=;
  b=gfmChkwJG3U+xKGOSLEYASZ902H0P49WWTR8D1XHEiU07Z0mjuFsXB5e
   BAdN/EgWLTIvJ+OpQF7qYMC4/MzNUYVBdqFxE+4kQT3wvhjqC3txDq6qp
   NNsfI/SlwtraLRmzdiATSjFD9lAX2x5Ypwh6jbKR5B02ss8BupsdMx++i
   rD3n/KTCxmX81s11AInyRDPUyZe0N9pKQ9Y/FXwo4tUFHr/RcnyaKnlR3
   eJ9MDAqbulAapnR1WM3xpZnaAV0XNJOzDaRCX4dGsfgUTy4jlub90APPC
   UJMwtHhqqnCHhvws4VvFgl/Ujmg5+35lfrsLLdV0vaLDuUzg2+CDecrir
   A==;
X-CSE-ConnectionGUID: +oxUUgxzR/WDeNOhv6XeKw==
X-CSE-MsgGUID: intsyxWoQWKl6TWHkwaj8w==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="155004283"
Received: from mail-westus3azon11011058.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:22:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvJ/p4NgpUeVlJYsLhUCjNdrCLmwVXsVHOfJ5pnrUHj35KqRZdIIQ7kr2lUQRV1sBLdUEfk3O/MWH6WYcXzYdD62iYrNElImwrEQhi7flQ5bl+47uRQGrpV3RyimrieK9I3nZE3s2VsIYaaxFwooUcDGNUDqJYC/qRdY6uaM6dUP9sTtR3dPCtB9QeppJxRQDFp+minNeWIrg3ll0H7GVhQCtpPBjHV22fkPcR5eadv78/dm7qQx0E+OTI/IXlmok6H4aQWawNdT+iRRMedefGMNMeR7Yd0bpqfGoifJZEWIZGpclprqSjhoY2xlG5cLYEX2uRg3Ueses8CT9fUZXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcvNvR61adkRODmpOyQ8lM60tuuQI5V6EbNjmEALCKQ=;
 b=t6E+UCelluOQbhLCjEqsLCaRKBzYFZqYon5k7SH443CE3KA3bpWrxeo4KuJUDGLoyvaGEt6Dgu2XnU/fa9tPmgnZKfvOx9oo0QrTOsAT84jAZwBQmVceNqxadtunYa6YrFzhv2g8T7HZIkZ6uNj2hmy5K21fpEhUvmv9bu2m+OLS5Snx9+CzK8BntWUYQB9zhZh82VUbOqvj6bPuvbmHStXEEfmOQQLH+IneAneaXuJApfbTa9rjoTivS/0/cOlV69ybsLDvWC+P8CErNzp1317xbQgK1sbvYIuVpWyb3T7vxa5ZQET5HFBDKJ4l/He6EhwaaG2UR9mB5AXqmNzjCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcvNvR61adkRODmpOyQ8lM60tuuQI5V6EbNjmEALCKQ=;
 b=gXalnGcMYxGujtNi1/sRY/7ik9dX3b5VuGMO2Py+Oy2t5+1XZUrM/GGATQXz2xLd2up0SMYIKO1sZ0q2Eqc7FYbapsiG7L3GxyKU+fDc7rEdRbjBYduc3ja0k6TWq/fY+OfMXzjsFyqVsAx6yc81m9NnVQq7n5bknKhnjeF4M0Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:57 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:57 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 25/25] btrfs: zoned: provide zoned specific reclaim sweep
Date: Wed, 28 Oct 2026 19:21:11 +0100
Message-ID: <20261028182111.160492-26-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: d3d96d4f-8ab2-4154-e063-08df35205a0f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|5023799004|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KFQic3b/9pSMZK6I84f4fDUfSIvOPy3it6p7iflm2aivExZ+PqWHO+I+WR+c03bg/64GMzWsVcfArX2bSvaIT7BjOcHsEYCkdBhaFjg2lLhYXOYRHr3OJkI3cYq26HR+yJysRliInGm37d1VLOBZAacePpk7rtHP4uIYuAHKSQ97qIUK+e7tRBdk3U8J2HFCjcgiqlmMNqsLLnFt2rquUuSfwVL6rR73xFEK4nG6N57X3ZyibxS0oKodeQTIwHmgaQJPcYfXKimBUaH4SNqekqxshbbiiu80EfBnfV6MV+4NXxY0RWEPJZ9jXBS/6M/ubiZN9wg+zKyuNycusaa3AaY5Nrgy6FKWuBRtMMxfcictJcFa0ELll3cdKLQyKNjLe2jMiRdeg9UotNAx2HKr8Xmmoq6mU2W9QWYNlYhHe1mBuiSk9zSH9AUBOoWGUqdPEvhPbGxq4WKmdrPTISTZSF3QAwHZwDEa6LZ29ziZ5/sJwiIiaJdCZpnUZFcCR5Dq/yopB1Xbp5kpkxq0oy/aFhWDPSoN5VGR2x9a2+73ncGtrsNJC1bbp4f7tsn0vpRyl/jz+Wjpw3hmGgJ0M3FiP+iAU8Wo9n0r5FaNfL3d3q+77IybibYh+9k+Dto2eypRTZ3w+hg4cYmZSCUAhmTCep22OWQ7QK994ZcnYrkgNtQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(5023799004)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vSGyI6fKIujtY5qmgc7ME+TE8BjShfYeEw+an2VXXFK/GyPf8sGKFWzOXSaU?=
 =?us-ascii?Q?4OqzJ5htaIuZAQk44i/zjQ1XkaflgAHnHi8imAmJrow29Vp5eeCDWXJxVQ0w?=
 =?us-ascii?Q?Ha186MhKVZGYmbrfaFY1pBDSw5FS3xXkGG3WI3I8za6NsRew6liydWOZOsYU?=
 =?us-ascii?Q?6WdaPtjb6kKoPYUezESVbaO/XzASYOeC5uwZKKsxVKuEG4nU0c/BBC0EnLKA?=
 =?us-ascii?Q?GWfMZQA0Jkv3RHaTXqz8/Mirx496aWp1gIkH6u9UaLmtQMI1ncP1cDWoQnXL?=
 =?us-ascii?Q?D+us0TeTrAXbVzGA06Ppotq1Zbd88y1wvWXNoUK+R+b63vygksFNSAr/V22P?=
 =?us-ascii?Q?cf8NnwfCaahxqOaoveB0VjJniNgg7Q/yRT1mMSWXtw2s3GiVkNtofnGbsjbS?=
 =?us-ascii?Q?cU2XB4XWKRLitczbCWARFcIxMr3zz/LMs7ErA8z34KsT1XrShm4Rjh6wGNCq?=
 =?us-ascii?Q?20uAGU+AlPGBb1LPtNkq581Secl52dSvK638fWp50JaksVCoK0pbNUKPuAl2?=
 =?us-ascii?Q?z/nuqPdl0rWG0Mj7TDkJS5GBGKieBbwmijTQ9JZucaTrALZWr4isvldFDM3H?=
 =?us-ascii?Q?WRIEZC7kdp9L77tm7CRBlLoqTON6zdtZZT9KiQyRg5TB/XGxgULrnP0HToGu?=
 =?us-ascii?Q?PlcJ8pykCtNa01R+Bs0XLd1tlkjGZ1Zs6xxxNjVIdZGICU7aoOivHYpu3U10?=
 =?us-ascii?Q?XBqfA0QJu/2FB+L+cBZF1wpSRZFuO6LcPR5sG6lwxHdPQU3LyEN3bJUpi2Lk?=
 =?us-ascii?Q?LlEWYSydYdnOxLXDlsKqENXSefQUz36twfS2tfTpEM/W1Uhu0Iyimy2wmXWW?=
 =?us-ascii?Q?XBlK3kIvTSfubm7aIGikkdFCTzDyCJHUx4whKU34Z4WTlfqai+/UwR5lrr6B?=
 =?us-ascii?Q?3UmT9KpjYjaPeM7sUTwLmgJeV8sUvH98EBcMz7+nS2hppluLUuZ6Tr2W3Nhh?=
 =?us-ascii?Q?6Z8miwS3xtORB5u8CLD1UfShBUQFiAi6V6RsWvpMWtqqhGojgbm2SYGnEmpp?=
 =?us-ascii?Q?JIJtjo1YpwAezdSt1orU6+SiiaK4L60ChwQdzXWXkvl0hPjXLIonEnYO7Qja?=
 =?us-ascii?Q?LgSdGyxo4eoYPD3Z+AhlvhRYYOEm6iYb8SHhV0Pd5z+p/KwVUGLf0gz4ElyH?=
 =?us-ascii?Q?YPIoQGJHFnarzUJyXsRvRoL7oaSsfWWQ9gPyLShZk4cupy3YYw8FclwcNay4?=
 =?us-ascii?Q?s3OnsXKkP3tQ7oOFxqpT4jHRhkXz0muIVqnja9bFTPYa7MNrvK6X9U6xVzzK?=
 =?us-ascii?Q?CpVqeGNnUcOiDDDTEvJfdvvoQ+YczLtCEsiYBV/7GixFC+VaQoPLb0r/KwPZ?=
 =?us-ascii?Q?nCAr6FjazRWN1tsMYHKqjrLRlLjaOO4m3FW0ttNkrQmV8cGFcMoiwv9NSSWj?=
 =?us-ascii?Q?bhZoUbGEtoQibC8QM8xvFTg7HUWoHMfh/6xoIUs3VU2HqNhT/QioaUqCENmg?=
 =?us-ascii?Q?ZtVLEUSsSmKNDVV77o5hOqAllVthGyjT/19FMuL4MqkF6LY5UDJU+e25Db44?=
 =?us-ascii?Q?yGkVYaVutW7A+VWc4EFtvDxj7DrjXkr8PDAu38gx59Fgsx7OZQOcugPxHgOd?=
 =?us-ascii?Q?e24tG6NZuKr6T47s2VwKjiSGe+IQyLUtfVa1XU7NvbAmTYepOtyo8im61Pwg?=
 =?us-ascii?Q?yQvF+RJEZIBv7yWyQgKr3GpdHb19p8Qr0WG7/0at3+bLqR/ZBMLAwi6fznYX?=
 =?us-ascii?Q?Ef5rn1+0SE1ki4BA74ed/IBIHF6uURZuZ4XS5WNJsskK6JpE1BjTXFq1jqkg?=
 =?us-ascii?Q?tWY1MaTOti/kJD8/355V+rtH46/lTEyigQwo2TKI1RtII/FajGtg3XjjMh0h?=
X-MS-Exchange-AntiSpam-MessageData-1: d7OVZobNjm+mlteuybK2P5ClGDnbz6aZYGs=
X-Exchange-RoutingPolicyChecked:
	a78vuTnezocF209fVsabyLAKK9X/aqxo48L+rbhHxBZsEFdmWf77+YcSN8NL4UrWUMcWmSRAeprOQp4MNlZbFtnmaYDlIztSde4nxeGxVbyYrjVN1er6ev57wMArd6/5UgoAWVZ5a48L7cuTz8RvZrRBvauS+Gyi7DG5G210mD6Q7cgAgnX7QYmNrVx1+pQBsauQwll0hhUoPlKdsd/naZE0hNNehvVmSoq4jK2CxYBtKfMwCZ7bTWl+9NDVKUK6z+g/udqQh1Ozne8HjABB06Ou0IFGd4BHRvsBZlzhYjEBEgSzkXiL6BUEtY8zxCnpI9vBJE+At/YAiv8M88/9Ug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Qw5jHtq8A9xFolv8b8pGXaqbJGQvX3OqjOASnOpVUTAxvFOZlsq8q9rF6I5aHmvJ/J3IYN74eGSA7EDLjHb1AuU2CfBhdeZF4ZiNCWZrJXH74gIEskRf4L9xuMr2IPk/RZsZGFBHcPYSIApZ01wy36NnvoPxTguwokC/exS73I94bnKO6N867JeAhP4+vDZdN1K1aRm6qR4Obs31Jk3rYxUG+A50S5zU/y8WFoQsQlj+dBAifLChAOanTuptp/bk34H5e7z+TZcBwxvSWKfrR4tNCZzdc/s1e4Lfic/On5sHfseCX9lkHXPjNfYBUvjiQTrtnfNMOonG2PeRPaR4lz6stDy9QLZbVXlt0jDIPibIom2jdgu3wmOCaNmZd17FCW1YDL7J7xKJkqSZR9XYTwspghgVWg8BPenAKgZLazdyqxVJKeP0akF0DFWRJdEJkPHmByzSPkvSpX31pAjSzaclWAdXylO2+6ab+HtJ+f7G61411PrSuCtX5wt5KOpNMvnYNoZWUK6HANLNHMt/Vbsz9LIiZ0oI7oR53tfkFC6Rf0u1I/OrJGc9zBtBWp8E9UH8hwbYHc4cd1wgxutYX3Fg+/0F3SFBFN0UEMUQ82tYNj3gVhY8mljImoUbSrGy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d96d4f-8ab2-4154-e063-08df35205a0f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:57.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7C66UqQfFQ3hRZb97A9MVUY4Iu5uDmMIudT+WMI+lP4/YRRI4qj+m26qWAkhJt4k89bf0YMFL6fSsEqCtH4qURthdkejBrA+JuD6KZbqXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

The RECLAIM_ZONES flush state calls btrfs_reclaim_sweep() to find
victims for garbage collection. That sweep does nothing unless periodic
reclaim is enabled for the space_info, which it isn't by default. And
even when it is enabled, it only queues a block-group the second time a
sweep sees it below the reclaim threshold.

Apart from that, block-groups only get queued for reclaim when their
usage drops below the threshold while space is freed. Block-groups that
were already below it, or whose garbage comes from many small frees
spread over the filesystem, are never picked. With data tickets waiting
for space, RECLAIM_ZONES then relocates nothing and fails the tickets,
although relocation could recover zone_unusable space.

Replace the call in RECLAIM_ZONES with btrfs_zoned_reclaim_sweep(),
which:

- queues every full data block-group below the reclaim threshold,
- then adds the full block-groups with the most garbage, until the
  queued garbage adds up to two zones. As soon as the data relocation
  block-group fills up, relocation uses the zone kept free for it, and
  the waiting writer needs another zone on top before a new data chunk
  may be allocated,
- also considers the block-groups of the data relocation sub-group, as
  relocated data turns into garbage there as well.

The periodic sweep keeps running from the cleaner, adding an additional
layer of garbage collection.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c |   2 +-
 fs/btrfs/zoned.c      | 125 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h      |   3 +
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index bb08294cbf9a..22b5ecd8b464 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -914,7 +914,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
 			flush_work(&fs_info->reclaim_bgs_work);
-			btrfs_reclaim_sweep(fs_info);
+			btrfs_zoned_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
 						   BTRFS_ZONED_SYNC_RECLAIM_BATCH);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4bc5e5c3f395..e4131589d848 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -6,6 +6,7 @@
 #include <linux/sched/mm.h>
 #include <linux/atomic.h>
 #include <linux/vmalloc.h>
+#include <linux/sort.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "zoned.h"
@@ -3715,6 +3716,130 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
 
+static u64 zoned_bg_garbage(const struct btrfs_block_group *bg)
+{
+	const u64 slack = bg->length - bg->zone_capacity;
+
+	if (bg->zone_unusable <= slack)
+		return 0;
+
+	return bg->zone_unusable - slack;
+}
+
+static bool zoned_bg_reclaimable(const struct btrfs_block_group *bg)
+{
+	if (bg->ro)
+		return false;
+
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+
+	if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags))
+		return false;
+
+	return zoned_bg_garbage(bg) > 0;
+}
+
+struct zoned_gc_candidate {
+	struct btrfs_block_group *bg;
+	u64 garbage;
+};
+
+static int zoned_gc_candidate_cmp(const void *a, const void *b)
+{
+	const struct zoned_gc_candidate *ca = a;
+	const struct zoned_gc_candidate *cb = b;
+
+	if (ca->garbage > cb->garbage)
+		return -1;
+	if (ca->garbage < cb->garbage)
+		return 1;
+	return 0;
+}
+
+static u64 zoned_sweep_space_info(struct btrfs_space_info *sinfo, int thresh_pct,
+				  struct zoned_gc_candidate *cands, size_t *nr,
+				  size_t max)
+{
+	struct btrfs_block_group *bg;
+	u64 garbage = 0;
+
+	down_read(&sinfo->groups_sem);
+	for (int i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		list_for_each_entry(bg, &sinfo->block_groups[i], list) {
+			u64 bg_garbage;
+			bool below;
+
+			spin_lock(&bg->lock);
+			if (!zoned_bg_reclaimable(bg)) {
+				spin_unlock(&bg->lock);
+				continue;
+			}
+			bg_garbage = zoned_bg_garbage(bg);
+			below = bg->used < mult_perc(bg->length, thresh_pct);
+			if (below)
+				btrfs_mark_bg_to_reclaim(bg);
+			spin_unlock(&bg->lock);
+
+			if (below) {
+				garbage += bg_garbage;
+			} else if (*nr < max) {
+				btrfs_get_block_group(bg);
+				cands[*nr].bg = bg;
+				cands[*nr].garbage = bg_garbage;
+				(*nr)++;
+			}
+		}
+	}
+	up_read(&sinfo->groups_sem);
+
+	return garbage;
+}
+
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *sinfos[] = {
+		data_sinfo,
+		data_sinfo->sub_group[0],
+	};
+	struct zoned_gc_candidate *cands;
+	const u64 target = 2 * fs_info->zone_size;
+	u64 total_bytes = 0;
+	u64 garbage = 0;
+	size_t nr = 0;
+	size_t max;
+	int thresh_pct;
+
+	spin_lock(&data_sinfo->lock);
+	thresh_pct = btrfs_calc_reclaim_threshold(data_sinfo);
+	spin_unlock(&data_sinfo->lock);
+	if (!thresh_pct)
+		return;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		total_bytes += READ_ONCE(sinfos[s]->total_bytes);
+
+	max = div64_u64(total_bytes, fs_info->zone_size);
+	cands = kvmalloc_array(max, sizeof(*cands), GFP_NOFS);
+	if (!cands)
+		max = 0;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		garbage += zoned_sweep_space_info(sinfos[s], thresh_pct, cands, &nr, max);
+
+	sort(cands, nr, sizeof(*cands), zoned_gc_candidate_cmp, NULL);
+
+	for (size_t i = 0; i < nr; i++) {
+		if (garbage < target) {
+			btrfs_mark_bg_to_reclaim(cands[i].bg);
+			garbage += cands[i].garbage;
+		}
+		btrfs_put_block_group(cands[i].bg);
+	}
+	kvfree(cands);
+}
+
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index ef5292ec771d..c8197dafa502 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
@@ -336,6 +337,8 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info) { }
+
 static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
 						  u64 flags)
 {
-- 
2.56.0

