Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792758913;
	b=rDOhf4HjSsnfqVCvnhdt8NMncTJiK3KxoqEIi9JTs0CvfND2rbfSo9vxWbR4wwBXGGUz
	 31x10gzD6UN6cyA6AKjVoOY1sU3yzcCZkMik1gPGNVJ9WzkI6cFnYlqA0tGKYYqf6qSjn
	 p5zoZxbkJlmTdGzTnQQYIS0kfxEsIofSR3HKY1I9NTcrwCgRD5A0zNG+yWKFYpzf7mcCK
	 XOV4OCEtO6w7DLSr5J0F06atyu4Y0zvQciPXN9vM+8asxaSBFyV73AP7RAAgBAKf7SMzx
	 9WRcY5hfWBH2mdQ8FcoifcvvCd9swQl03IYxrN1k8ohDeakWXzh1NvzyYkrBccRV8mA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792758913;
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
	bh=K8Zpj3TRpKOeSwQTRGCMI1K7i++mZvyQEYmGve3iHUg=;
	b=sgeweu3TKYSQFIHOrID7o//fj5HAGAhppiTwFiLi9YvOOZQzRDMBTUBoqiyBxuhe+ga3
	 Oh/bbH+NlwxMM0NAqc7SsE0aM8o9MK3HMsNHKA9OxThosH1kbB4PT3Sde3UmpsYcs99WV
	 Khfl0n971FxMZj2KNe5uDxLwCwWAs2PlQju7GwIkuNQO/QrUdfkpR05n4GF85xBqxK/mv
	 Xq1KW52ZIFMQMWvZbStKY9oOgVETybDt1Ae6qmcvZI/bGdSzQSwVywYk0LUkkqWU3+t+x
	 q8eXN9IKDUZrmEi9ThvXCg6RiEJGRqd0SklnzkhdfoZ0Pvcm5WcVyni/qVNMopxVN2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DYgBGXim;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ub2ELCVP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E535606A31A;
	Fri, 23 Oct 2026 12:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E535606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DYgBGXim;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ub2ELCVP
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792758912; x=1824294912;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=oQc/+nSuuIBt7iz7Q+RJu1fG04tlqTti2T37Gj9fNHY=;
  b=DYgBGXimGsH86NWYBO5w80al4zHxjM8+HzQwcdH7CRBR5DZeRTynUQY2
   WRTtJEnrYY0SCzSDXgIsPKD0gF1WvF6XYxiDOMJTSbXUEwVVcKPgFvj7T
   C97D9iyOiw4oaKNCXdqk3xWzOJaz10/08BzCHVn3C/LaNuI9+u//KhAZK
   rZgCHR5cVBIPXqq+DyBG+PWhmjdkYZ7Hf5Iora8Cxa2KN7uiCsQFazhA8
   pg0pISNbw+5xU3wG8VdApNuUOVfk3mIqHBEbxY4pR469MgKcASCIQj1bR
   IEKKtdJylxnu/eIuFNZm88Nrvsx+ZUQNQtDq2zNAWQwgT30F0OHIcSKRC
   g==;
X-CSE-ConnectionGUID: MUVbseNDTLyK2Qdi1t6qOQ==
X-CSE-MsgGUID: QV7Lhm6jRrqLHHFI+5QP4Q==
X-IronPort-AV: E=Sophos;i="6.27,174,1786982400"; 
   d="scan'208";a="158734375"
Received: from mail-westcentralusazon11010019.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2026 20:35:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BtNxZ5amDwOhojYNzFtwV897ZPUpnzAAFqKYli6guqk8X7+AAvpMN/pdTNN1XcsangP326VpSM4ajU4RetvrRPxpNeN7YKKRm9HZPYZGF3t6saG3woHS7bF9but2io7JxIXNnJl+jgZ8EODoiFWwIaDctshJmW6Btcz0GYV4HDkXXEhJ00POQJ7dH2ZMieRevhWPSdelnmvuUDEaKrjlOBJJZ5Uu2/QF6cJCnK5IkksD2T4017mIvL+C6ne3Cu8QFNREB7GpP5SP02IruybAen8BV/H70TisVdxTo8xSAe5bSXu8cZ+syubL+hM0ppNc2eisOJqr5f2kj4uFxTP5jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8Zpj3TRpKOeSwQTRGCMI1K7i++mZvyQEYmGve3iHUg=;
 b=QAqy0lXkshjCJLMWOENM0BZatq08xDQjlR0Gsb8gg1BC11dnvxmvesKDut1bVbaWGEvCt4ywwdi/eWRek+trN6+yyLWKb8u14F+a/A4UWsZ0LEuV4wjCUay6B9YYAJ1JLL5/p6MbZwq6or4gRAKAS5zkipLmt+T/EKkkqHR+QSwExkSPtN8kpLYSyhnp9gT5nNWbMAmrnhhyG268YANNNW6jE09VLIVLFbv4e5wGgB17xViNB8DbJRdJqiPC6p2rvfWuQRmHYKMdPjHg0JuU9mYskpvXtTCWWaofqZlGUH31PFsseet+vv0ASD35LN4nm6tWACsiwWif2POUkhRAOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8Zpj3TRpKOeSwQTRGCMI1K7i++mZvyQEYmGve3iHUg=;
 b=ub2ELCVP6qPn1A9RYP/6Hi7dwIyhsXRjCpXBW7bwYUerD+bX1Dk8JynGSnuC6fcqyGn4cqeT3brL2P2TLX+AhEDEjzT5KUhCKZUsTGtaJfBymWL2ULRFk4l+PPrSBSuoKMilQNQCOLdmRd7b0bIIIg9Ital5h6Mzii3TDn15fi0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9481.namprd04.prod.outlook.com (2603:10b6:610:242::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 12:35:07 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.016; Fri, 23 Oct 2026
 12:35:07 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>,
	linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3] btrfs: test that fsynced data on a RAID stripe tree survives a power failure
Date: Fri, 23 Oct 2026 14:34:51 +0200
Message-ID: <20261023123451.90365-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0087.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9481:EE_
X-MS-Office365-Filtering-Correlation-Id: 1798e19e-85fe-4a2c-941c-08df31021213
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|10070799003|376014|6133799003|18002099003|3023799007|56012099006|11063799006|261022113327099003|261022105027099003|261022075727099003|261021121427099003|10067099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
 3poQmNtoLHqgnujXxQmgJOY7dS5Mw0cJu0YF4ZZUgKD4oH2Ez+M8vcZeCRbRkcxdqDOn1NEcsMI3Yl9UTKegU1CMIoTO/bkevUmvutwiVe2i6w5Uc9WGrW6QWM9X1qRhP8zZeDEob4RcRMva2WAKGB6MazW1s+EiDYAnokq+x/5gaVXrqyziDnQpPT1WK+gJGmtpXVdwU0JT7TkFOGmvYAO5gQlxA+RiYduM4tdpHFFRTbn4sU677XvHmJVQvzs2rPFHsvUI8swq+4mT1ylk5FoOkXGfmDEuKFP5QPHlEoyt5vXOJzaWqTM+nCfasX5DxUlUUpq0SJUS47elDOxbOQoqhTzqUZvzv/v/9OxFQ3RAmN9iZd/qgpI3swUl8s7OnvtZDewt/NjErCGOzY4kZkO86jx8HTNd20W6VslQWROYvCmLqpas6oORwF6dKy/I6KkmK3LINr5rcxnfIkq51gVcA/pAL0qlr9Zaqkn4+J06oZDDWnw/22J3+6hjjQtUmNLJRctoktM6A9CxuLHJ6SYaBV0VIvwcrgrE5wtdCoc1fJUQbs482YxPJxotMzntLKsbfBwKXnLCG3ZxRif3rsTD9moYNtKfdYlR/1g13KHVV4KvequN8J6uqI5yULH1FETAMGLlNh/htZKqfNrkTgMWaYt04N+2vnJ1u3zPcuI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(10070799003)(376014)(6133799003)(18002099003)(3023799007)(56012099006)(11063799006)(261022113327099003)(261022105027099003)(261022075727099003)(261021121427099003)(10067099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?cKb9/rJ76GSuw0RD5BAtA3PyPDNvLle5UmS3+ahEabXZvKfegEDm6I7R+A1S?=
 =?us-ascii?Q?27vLyjldNRtX2YX6+wxTdyqkNP/2cBvahDuCEVI6OtuV/FskuVV0FcOTBmtE?=
 =?us-ascii?Q?ZVIJ4FtnimkYhl7b2tj1ek88xOvyjSvR6GFfbZT6F9wVRoTQgiuzQ2QFITe8?=
 =?us-ascii?Q?AwZUOOfiH9rnDCyACBwECSrEL7TR8cfPFilxd/HzLzGkG5Ktb93z4EbR/Rah?=
 =?us-ascii?Q?iD5lq2X1ynCF3y6vlxP2g4DObGYYvBe3djQRmssDMPTukaL4x/wlDGemJ6pZ?=
 =?us-ascii?Q?DPfkGuqkFikTIf9AO1CmjmWIrxVoOAf7Bo6vo5q+bR6jHs+ISYmSkRH7OaTv?=
 =?us-ascii?Q?YKjfQ8guZZhkVnNFl53ZHUBFa5JJ/CbecrBrydrdI8PxpSooqWHOwy+OdDX5?=
 =?us-ascii?Q?tQwuU65um39xqnzsE9SfeVujiua82z0BeCIAlFfEalZNcHcQ2bQL+hi96sJw?=
 =?us-ascii?Q?NExYCjWqGxp4JLHC+I/ubS+8EsdZTzLdSWU4J1IF/6uAZvtccPv63QguXpBB?=
 =?us-ascii?Q?5VjXt0ylYXeG9WIrcrVtpW01SA53YLxrXpuxErmmlA2cBd+FWsONjoqSn1Jq?=
 =?us-ascii?Q?2v62P4g+Hj7LSvN0uwQxESIPBbBqOHNyN8INZ0snxH7+tX5z/DG95JyMsjX6?=
 =?us-ascii?Q?LdqYf7XPzRoETD74UTpjV8lmJopF2nfnCyUvbrm9O+3e68nE8HrKdeDrXtts?=
 =?us-ascii?Q?lLIQz9hZ3nSH7KCQDezDr2EfPlh8V40NeFv0UdSrDkr7g2ETXG5QqYky39Np?=
 =?us-ascii?Q?dKBfYx98wMofPe+Th1kgpUy+72c3OWmeDXAaL8PetlQoF5mALxXCT5oBHOn+?=
 =?us-ascii?Q?a20BioLkdkBqre72HxnveWraPYr/S00w3CjMlPoC4VOK04Of0zfSjzCrh+rZ?=
 =?us-ascii?Q?aYhl/iO4ogMgChdO7YP53bMfWSLQs3Sfz6ZbTKcoiGIQgss1Pxm0jeCUnc3t?=
 =?us-ascii?Q?sxMxok6h/baTXQAubqMbsMIqgnSPv8rO7DUEEVodkVc6MLFVQtIg8iZxeDbr?=
 =?us-ascii?Q?L+awLy9c/vs1Tgj/gJlGm6Yr9Rg7ock/b4hEx6h3zgWeMxUAO9V3J807DevZ?=
 =?us-ascii?Q?bKsbzlYGOgQTrVNXG5EAFPgq9xIW/HT7FLrCMye8AoDI4MHDlh1KRosiDNig?=
 =?us-ascii?Q?Bya7zuODIeHJD9IpLRH+Jo1Eg5kw2hDMIAVUtkEIzRN8c32QYOZLWD6bo3sh?=
 =?us-ascii?Q?i+XzrTlCWwRQnLJ4vbtgRvG7NwuIk0Tqj0fSt9TFkHjPXEnzlo29kZhS+JQD?=
 =?us-ascii?Q?Y02jlRAxzpYbpFVrggj89A+6NJhG+J08fpnIeda1z3HN8kwTLFliDP8QZnYK?=
 =?us-ascii?Q?MMfcWt1D7mx8Pi1Xyzv9kUcBJHrV8FZzpkjfB7bWiUEIPscTSRFkcdzsq5so?=
 =?us-ascii?Q?ZLzxzWVs1nAiYyp9UWAZM1C9hbPGINalmixpIA4/wC0hRUBL36lnLxmKEU1l?=
 =?us-ascii?Q?paFmzXaphkxsaQ31aU6Wkk+ItS+DQ6qGXGTKYa/574IZdxAbQUDC69P1dFBa?=
 =?us-ascii?Q?Y9QD2cOPPPzI10GEXhIixeR+6WkKl/TvpQj5jh3T7hMbWwuI+NaCb7GMSyxT?=
 =?us-ascii?Q?lzF0Oy9ON9pVVTH+I0YGIqcZfE/z8QlMAR2NZ0vsekOh2fLpyhzoiP1koVbX?=
 =?us-ascii?Q?uVvqWpOCziv2HJxUNSmoROqIVrJhc6eeljG+Uq3+DFPlf+u0SEcbFAsqXFMy?=
 =?us-ascii?Q?4/SMoZW0zVMUCrWkZRmGoUmOHiOr4KHT/3DYbLcF7XXQc5np127z6TxcWqEv?=
 =?us-ascii?Q?XCFZkIweJS/7hTRBeHN/B98sG5kNkwJxYtjNydfFTcE3DO5b1t+v0jIgYTmQ?=
X-MS-Exchange-AntiSpam-MessageData-1: bur7dlFL5/OQTchFhQAGrcTzDPUONPmRkjk=
X-Exchange-RoutingPolicyChecked:
	VVtlCxW7oh8nOq3ZWY8oGqawIDx2SlwEyt0kDW26dWNU1smqV5S722cyOwN1dl7aa/xBP7wMRwokhDazQDJN/PM03A+LcidV1wzN+l29Io2SRV0SnP57Z6WlVtVANabLOKMdkpY8Kk0YX33LyV9E1AQXsC+MUd3PxRkBZtKCoTl5je21rZpWEZASGM9hhm/y/zSKb9EkvjayQId2H8K4QPJTqbk9SxoCY+79iTAZRqLVp3ZxacnQipzwYZzcLMaMjtZjU++tBVWWvctPVm80KhwgJoJEBi3C7n9Od8wISl7Z86AtxwFyRSjGHgEHXNb6FonatWcrhPSxDgnBoDTx1A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SjlaVBW7JcCzCSM+twGLvSbaQeSEPB1PFFy/vxz364viy4+aBXB8nR1Zj+a7TOOOeVoGG4FprJS4aDbUdxh9AHjo6uAXH04W5DqMyLEK35OWmYlk2diYkv5OjKaiInV1FJcvgg9wZrv0sOudDLR+6HjUicQPrO4KjjgKaWI4c0WVOX+J5Ps3cAtd8FHrwyIIqxHu+R9+9R4MC2qLubvilDWZC53Bkprf2HQ3Rl1AKoxRHOVRCdVvVU7M8cJ9CEjAIPp4j3k39qyispi/5z6akfE0oX0R0KNClMBuOsev3CP+JpDA6zT/S8179vLb1uHE9VEtC0eZLbs96aUZ0vbXDLGdZPEN7jTbcP8Vi1WfZBxawlssD6iNXTJKJBEae9V2W4BGLZRg/zlBRbhGr78GYvd4IVvaaakvzNQWozwmHxp9GtZ1gEPgfhjha0pkkoMeixMJKIPhRGyE6i2bOqhbYY1eQQ24h17XrtHiVj8OQ27p1P1qHWx8M69sPvQ92/wV/pV8nJU09Mtcf9B3+zgrVGm6srwh1k+Y5ziGVWKYsZG+cNpXEMDaDMLyLj1oidi3WoDHM6erTVg4gJpClDRK6xlQW+ZmfLkCQo0WxvPVFla74sNz0tLDMs6bKWYv3tMV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1798e19e-85fe-4a2c-941c-08df31021213
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 12:35:07.3826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8hmAd64owYpTGsxRygihvuKZB4A/OrdssednkPV+weDkP0+z0SOKK/jPQA24a19yicWq1lWZmbei02y3Piq/SeIiOKYQhV/o0SQzdEJNeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9481

A data extent in a block-group that uses the RAID stripe tree has its logical
to physical mapping stored in that tree, which only becomes durable when the
stripe tree is written out at transaction commit. The log tree cannot carry
that mapping, so an fsync served by the log logs a file-extent item whose
logical range could not be resolved afterwards. Log replay restored the file
with the correct size, but reading it failed with EIO.

Extents reach the log both from log_one_extent() and from copy_items(), so
cover a fast fsync and a full fsync. Each one is followed by its own power
failure, so a transaction commit triggered by one cannot hide a bug in the
other.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v2:
- Add a _flakey_drop_and_remount between the fast and full fsync

 tests/btrfs/363     | 68 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/363.out | 15 ++++++++++
 2 files changed, 83 insertions(+)
 create mode 100755 tests/btrfs/363
 create mode 100644 tests/btrfs/363.out

diff --git a/tests/btrfs/363 b/tests/btrfs/363
new file mode 100755
index 00000000..b71dff0f
--- /dev/null
+++ b/tests/btrfs/363
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 363
+#
+# Test that data fsynced on a RAID stripe tree file system is still readable
+# after a power failure, both for a fast fsync and for a full fsync.
+#
+. ./common/preamble
+_begin_fstest auto quick log volume raid-stripe-tree
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"btrfs: force a transaction commit when fsyncing stripe-tree extents"
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -fr $tmp
+}
+
+. ./common/filter
+. ./common/dmflakey
+
+_require_btrfs_mkfs_feature "raid-stripe-tree"
+_require_btrfs_fs_feature "raid_stripe_tree"
+_require_scratch
+_require_dm_target flakey
+
+# DUP keeps its mapping in the stripe tree, so a single device is enough and
+# dm-flakey can be layered on top of it.
+_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || \
+	_fail "mkfs failed"
+
+_init_flakey
+_scratch_mount
+
+# The first fsync of an inode is always a full fsync. Do one here and then
+# commit the transaction, so that the second fsync of this file below is a
+# fast fsync.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/fast | \
+	_filter_xfs_io
+_scratch_sync
+
+# Fast fsync: only the extents changed since the last fsync are logged.
+$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/fast | \
+	_filter_xfs_io
+
+_flakey_drop_and_remount
+
+echo "fast fsync:"
+_hexdump $SCRATCH_MNT/fast
+
+# Full fsync: this is the first fsync of this inode, so all of its items are
+# logged.
+$XFS_IO_PROG -f -c "pwrite -S 0xcc 0 128K" -c fsync $SCRATCH_MNT/full | \
+	_filter_xfs_io
+
+_flakey_drop_and_remount
+
+echo "full fsync:"
+_hexdump $SCRATCH_MNT/full
+
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/363.out b/tests/btrfs/363.out
new file mode 100644
index 00000000..9e5f1fa2
--- /dev/null
+++ b/tests/btrfs/363.out
@@ -0,0 +1,15 @@
+QA output created by 363
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+fast fsync:
+000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >................<
+*
+020000
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+full fsync:
+000000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  >................<
+*
+020000
-- 
2.56.0

