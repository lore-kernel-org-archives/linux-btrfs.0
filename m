Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085797;
	b=UV1G8ZF0Pmsob73YqhXLClJl83tyJBS/fbEa+heqkQu/dwOlsB2sSnqggAEb69O787/B
	 Rr4G6jxabQxeB8JGRnwUiuFi61i0Inu+7fzaQIL1Ex7IcFPGELqHMP7BJZq7zNG2nx3XH
	 KNCSITyu4zZzuXfBT2QyQHKqFd0tsDyKum0MLODoXHc2YxfqPol83yg8P/oI2eyUxY3aD
	 70bg6dyUEAuzTj5GXsOjuYa1oFOv5FYneha0/Ohx+xzTcn0JW2DbgLuqf6qpfAmYaK+k6
	 ZGK3V4Dxet5wTwEvyGGcQ4yNlz3oy5pGyMb+fBQH78lyfcg+eX/5FocA1uCqdUyxOSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085797;
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
	bh=eCgF0ab8+dvcqyT1DOCDBqx7yszcwEOEoTlt/qQcokY=;
	b=H4ME99F/w1u5Pma32Pc4jSwsTH82nOvDh98pAxuyAB4swoEdScLdsaSrUmdRGHWR1N5W
	 W/eGr0OigqP62jUNd2CCiNwuMv6lO8Vdp4S/zB685nBZGU3MEBvr75LWZo2+xtoGbznbe
	 ivbx3FtUmyM6oCv6l/aJ5ah3m72DVTDCVdT18j9O3rB9O9mE+ytmq8Rr7k/Wg8mcvnGXP
	 kp0OhSGCrnzcSbXOp96O31GxAGG96EuWo6cMwKQjUqiKG2VFDceQyG+LjpFdLQzTrEdZk
	 M43ybeYNESDl4ksKsHnaIl5ktNV524hQf/83WcsjQimWyuKfxY97gGywqrgoAUoyxCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=SIdnNNIe;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=TiGQX2pA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2DE606A324
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F2DE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=SIdnNNIe;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=TiGQX2pA
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085797; x=1824621797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9ZX+m9ZE4zldSF2lF8sl4459/QmTAk55c7+y6Vzzr1Y=;
  b=SIdnNNIe0wiVnUE+GwzTupDMKZZ6mSgHS42q+ETNz4Cfg2VLmB8rUjDH
   V40r1vruj+NE1nxUKFeXnM7gVmZ+SewtC0E+4nz9y8xWNMEosBuQVzcoq
   4v1ZyC/QZT4KPY1BLlA6BljeeChdo4+qn+MbYqmMoboUBB0fUBdrp/hlP
   Indddc/7uDY/ontWKzYdfF709h2ilLjz3MqoaXwQ+R60elaL7Ckalx+Ht
   Ba0Cctq+5uOpE8TgPHjz3PuiGU/w68PmHnGdmA+WYNPTcZX3oNNxReYEO
   zAqgxNmCaBGAKCUqOCEEotZaV+6JlF3dbNSolm4Hnl3Md9eALIKugX/Wp
   Q==;
X-CSE-ConnectionGUID: v5phyCtZRAKZCtmHU6BBvQ==
X-CSE-MsgGUID: pcdnwuFuRGaAkQIbRyqbiQ==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="158990011"
Received: from mail-southcentralusazon11011049.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jooFPC/aLbgnbPgcvlEuWitXZS7+QFs4wgWsDKHAsJq5Vvc1KuNj8Ec5laiFBicAu2DbCo2HCWBope26r78mGpBL0k4SszJoj2ZF56nEJ6ip668TAHfHpQHDelxT1WehvMwLpGF8AN2PRubpvRD3rcMJpMrCeMIIf6V4STa3vdhU4NL44HqkQpTvp1XCYjw6TYB+i6VeFw+yDpUtzhuDz+PH5NXksvLzvOb3HAt6I5RfzU7iHefwnpFSoz2CiUy7NegAbGeXCoUtp3px6R5g7S4BFZyhGJFtfRdxGmT8qUu2Qf9/yn3O2HzxIlo1OykUvSBl/hVjpnpAau/qcLt92A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCgF0ab8+dvcqyT1DOCDBqx7yszcwEOEoTlt/qQcokY=;
 b=JQ6Q16MrxT/yfPgBKp5aCVatya1JxHbtbcQzlsG5yfXMe9xwuAr5ilrb+QeFKW99HzN6SHV+ANtGkfOYjiq+KD1UvRfwBOCRKegM907OI8J3PHaRDPeL6W8MWjt3BkiD0TPvnFFdhlVAUG9Pfrc4BKx98Pl7+dH72BNehqOXpOOG3iX3h9ow2CdwIsATgZAf9C56g8zcKWGAUiNCC+WJGFAjtn9nhSoi5N0pC+75hyXVjS+YkIahlufeoLwu91mDpyCIIGQdJUnziZF3aoK3FxUAt0RFk124wvXrn4faYFa6p6VVG+25+jEa6A71OE0uuAwLJ6nol+13JKIv4ZcWbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCgF0ab8+dvcqyT1DOCDBqx7yszcwEOEoTlt/qQcokY=;
 b=TiGQX2pAxTuQqOsu/7Tg0lZE5w0rRi9aRg+dRt038OzMom2r4kGTtrC6izRupkB65t8sToy5JDhi8WCGfSNMAg5X6olN3UnXuDVevOX6SXaNSK/Mz/2hiy6nyndE2QOZGA6tRlixmpBpFFMdebJ1DSiZyW4oIT3FR/3g9lG8kl8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7064.namprd04.prod.outlook.com (2603:10b6:610:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:15 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 25/25] btrfs: zoned: provide zoned specific reclaim sweep
Date: Tue, 27 Oct 2026 08:22:31 +0100
Message-ID: <20261027072232.419318-26-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7064:EE_
X-MS-Office365-Filtering-Correlation-Id: df286864-9d97-4aa5-c9b3-08df33fb2a6e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|1800799024|376014|261026121527099003|11063799006|5023799004|56012099006|261021121427099003|261021123027099003|261022105027099003|261009223027099003|10067099003|22082099003|18002099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	9YM6QkJcPPxjOZ08v7Ot2z9wTeZ+Tor82dbj9UOAlv8FNFb91+7C+YRolMriA1spS3wixet8OINlBWCMruO6Abh1loVIOQvOua3Y1sAj7D8LXeZMc79iB462pWKC4wjslrNOwYJ5o6XvYUmRV1QZs5kalVvy13Kmy6uubwU2KurzeGMvZhVzawdinfq0guFcLrVlYV2u5EWxI7fDqQHsDXdY2aU3ceMbixsZZKMX3VVxYMBqAooVJjOpBelGMFxDFwyis1JQwf7ykmWygsWqwhSpFx1F+HR9l0Y843sJ+k992VxfdBt8YD2hxUgQeRBd39H3XoNNoWl/DmAr9LyMM6eN7o6oprdYzfQvRj/fZLVXNaqstSUJehKcEmU3W0dLdGomciAa67M0jAaSwS/O/mRbVfZSXmDymsN096PLS5WEWHsrEbv4tDYrg/BXwtSe3F5GHOK9VGq0plhL1TJBGJiKp736lHzSpFbEQLz3ZEslztTFlurtE71KynMA9dk6ars8YrLN0h3fJPHXyTAM7czVZ2fVGGcHGyHEo58OwKMH1obo28F4u4fzZF5fQy9HT2uC2+f6LJSbMJxqUFw/UObTx2ZACfuIUs/VTTQIWYqgprkfmbXIcbHAyqMIeLeg4190A4cBcmomF/Up4KkqO7aTRhcr738zzqFbmsG13hg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(1800799024)(376014)(261026121527099003)(11063799006)(5023799004)(56012099006)(261021121427099003)(261021123027099003)(261022105027099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pEcYpHUv2gK0jUAk4jEY62QbZ0Vqw1Rxzx7nRvf8OhmR01JZDaoYSHaXOJ5b?=
 =?us-ascii?Q?NJdI2UcG+H+g0EXhE/I7t7M1qZkm8P8JAQw7yLsUKdijFLSnhrP/d8vpugKb?=
 =?us-ascii?Q?UyuxAl1z28T4BpbHPJDuZYIAXINnuC9y5XFCbgQhyGbqLlQZD5AEdIjyXokc?=
 =?us-ascii?Q?9YLeexTPehaxLVQNCpZJRtrsaw64pIsfuYIo6tC4WnNkds1iF43pFaxppMcv?=
 =?us-ascii?Q?s9p35sGHPuuBTu5leXNrhBeLx0XxDKQI9tXjqN0/2FBfsiwttu4euZVzFJO3?=
 =?us-ascii?Q?slwobEJr6xb0VdbWy5XV8OlQg/Vs7MkvrCyLuvbHU4IGUxTk32Sb2XTofRjk?=
 =?us-ascii?Q?XgGJpCjPSJrZqKdItR5oakkU5DhJmtE6+4yaPvx+COWqsAUSxe8Qiv6/zbl2?=
 =?us-ascii?Q?1cpFuXWB48bIIuACVXtirkusLaXsA8PTnezqC5pFhZrhblqJllKzA4MjkN5T?=
 =?us-ascii?Q?o5odGCQdYlpiKBeqLXMOhvQmmttylzUTVlUctJIv/tAmriMbOtegsaj0SHfR?=
 =?us-ascii?Q?ltmfd+zGtjmK7tZQKsDbylvQSJlp21washijLNVERnkkk5Yliu+Wjke0GKmf?=
 =?us-ascii?Q?HQsKb+mmFecze10V0Q/mH+HAMmRHSIPGcBEfOeJlxg6Qpvim4wPtaJIJSiJd?=
 =?us-ascii?Q?45GiVqCYfUoJWA20cpPRw+TYFi6PPOqOIR7rCpYDLy9xSORax+UxkS/F/ytv?=
 =?us-ascii?Q?aXQ4wVMILKqix8WN2ujHeIF6AbnvGDau7pEvIRadModJnm3oCpj0sAhCEijT?=
 =?us-ascii?Q?9x+5EMTR6Ich1joyDkj4StZVDDB2xM0SZKbRFWytIkt2ZeZiQKgQM8gGB+HH?=
 =?us-ascii?Q?7oe0cxYh4LQR9Wpki1taGyvygvtytvFLL7EB/LQIQNUB4b55+HLpDq1zDSp8?=
 =?us-ascii?Q?kPulS//rMhIz05K8SEzkojexCVfzcSo4aiiRmA0DyezHsZ2H+du3iTnyrLDr?=
 =?us-ascii?Q?AD3fO4/oZUWTjQkvVapNo+GoEqbuFYHu2HLsMgx7nzRhA1MmvylQnW0FR4kM?=
 =?us-ascii?Q?L9dd3rL3NoWVuV0wnzSDGRkF1gC/Bj68bVSIqx+ihbxvwgQ5Cn0Y5y7Yjdpz?=
 =?us-ascii?Q?ZBNMaNW2gqllzPIlUw+8r3Vsy14fwP2hdWxLVmCf0jxtmPY6gG+V/RoYCJAI?=
 =?us-ascii?Q?JgDTnrPRwWfpCE9HvWdCZimWQ1FQs9Y0LzOOa3z/6jdCpIjBjiM2qa6J6m5F?=
 =?us-ascii?Q?EFE4EUVhqGyQTSlFZnzPoX7ifDDfc+ntEg+8Pcx0g+Ur53t9EZKYy3bwEvI7?=
 =?us-ascii?Q?Ki2oUodOtpicSr1rxF/eJObSYOxvSmdDjHQ7cLAKPzWc4sGnXDh2cpJUZiOt?=
 =?us-ascii?Q?2UVT5WpX6lp6JB+v72HcNy1Wq0uP4/qAqjVUSEcJf0Vx3OkSgVowOAujaFcc?=
 =?us-ascii?Q?6xS+YUp3vlnUQeO913MpZ8mbHdxJ563T7O2omXeM9vmpe1GuXRDCouQdc6qp?=
 =?us-ascii?Q?N2NZMvWGbUunPbZEKyA0TA33Cm/XL9VPJ86ojONtxYbxkfxvZS2WWEHqMYr/?=
 =?us-ascii?Q?rrB44AQ9iNvCBzocyjxPrsb++azdSwvciTV1U/7Ep5AwnQJldLV/WdHwAsqE?=
 =?us-ascii?Q?xooiC7yX4zbHHm4ktAjQHMER2rDjEmom+3aK/pH8UE57E4jTBoBYOa2eUHI2?=
 =?us-ascii?Q?LLs3g8CSrFdwSVLdEN+O+nvU3rjOFC/L5EWFAsM+8PB0JT3KP4iANYbwK7ZX?=
 =?us-ascii?Q?ZicI6ubXcJjXBkTqrFqjCkxqKtNWlV6u20N5KkX3fGEA2kOHohQZC9H1g8EP?=
 =?us-ascii?Q?nxeiOPbYeo80IqqCNqzOxJOrBwTGOasLja7xsTYnxpeHGRjdbme99jGLSYbT?=
X-MS-Exchange-AntiSpam-MessageData-1: geZmESm8zvPIEiyVSSc7BmHXj32Qy2coshQ=
X-Exchange-RoutingPolicyChecked:
	3CSEybwtA7qZznjtOZ+Di8rv7a+uv1QBjXG9F11e/Ov7WeLpCxaDQK/4d610FKEXh7BpC/5gt76E6bAIfAinP9+laDZFhYehnGNMuiJvseBV+JIK/yRYnXc9P4A5/JbbwKb2PY6BYXT+sqG+lskwUR3m/RX5G1IcySR5EMuoKpbXSQRgWrJg+3jgovU0/FPBlWnLpHEnRlnfRnkeAZNJRoJmX1mz6YvRI7pDczplkLhGZJHQO970dApxJaQGnVECbr2OMhOuhkqg9Y/XmEdFsfKg+JWoesEyZJIH/BETekKhdnvLFFy73Nr4C/8O8CDzntAU8c73f4loi/xUwv3Y7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PDlkTlaG59uIwbH/DDnlOiY1JF5qib2CXPgZgQoEcQqbgv+1qIYZhc5BPoW9ra3WDidwLr50f0WCHQUDPFDrLQPsVUvn2K9rnTi5VmoApxfJ043/TokLE+66hndxWwVK1z18t2rj/aC2sOCcV2IKdbp2YWmJeYRZueMyCnGs2dfdmFZhZKElC59rGPryrnQwQoUQ4e8zWJD6bhll30+HI4VcdffDaaAS7G6R77gjh/9smwq1SXsSyjWH3M5KbF4qhfEiI/62zlHJKC/VC4FXcy4NXDqbq5i/eWAE7aiJAqLITBJg7WG0WnwP4p2ir5Um+MwWxlzoRkEMWrjUu1uEu/yKb4E2ZKnIwsUUH8EveOautd+RGGAwccmTq8nNcd88KWHI6hdGYdJekZTnH8mtXzkVziLKUYJquxGAF/bnD1rHiXRFQpHF/H1qIlx2Du0FmfwPZIsfoBY2VYsrCYggx9aMn1cVwAQ/zHcYcw/avsKOnVX1ZPFx64dYgbrfiQFBmmIKkYNf+opTt6SO4j4Zy5PTdnPdQRkVpu1zNa3+DsVwKz79hSHR96w9obFCEmwjZmN59JZVWfa+Dtt4VswCWB7GJ+vhd8bXb0jL5AEB1kRd82HeBaHaA0C0IX+ALrcT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df286864-9d97-4aa5-c9b3-08df33fb2a6e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:15.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i3PzFoJCFaUoy/wQ+t+9t06unQt2d79ItYGotfjjT7meNvnPyXz59YlZEoINc6OGZtHynj8OlSEuroil1ryt+lG0QFfMPRLhlk2i0Z/q2vU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7064

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
index 4b24f602afda..3743868f72d4 100644
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
@@ -3636,6 +3637,130 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
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

