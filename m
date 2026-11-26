Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795686521;
	b=FRLyi/XCl29VNdVTZlgQ1THoyy5tJw8I25er4pmu/cMkkNlOqgCix9l9nx24ihsyilzr
	 3nIJDGxlBriUnmtilRV32HmMCjEh+CSXW3Rix4PbXNKhGT2kuR3pH4n1FKGwOs9XCAU+I
	 onPpiKNrRWe5a6XaCaWea8CqNsDbB5L6pkIjNVRae+XxZlt2xAlSb3tbkAwNQrVW2lzfz
	 plS+FFNsuekVYOBrYgJ5EpE2v3X3bPxIKp+Zt0RN+mGfoV8d7MVpcIZb3XsethTFkFNBX
	 vqSIrlAXJ99ibwaYjz772ylcZRQX7OqFFxo/Wva3Z8FV2U1MbbvhW6OHwSZrmxzpcOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686521;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=6mhdVeAtFbPS1rdDqBVOcYCkYVoU1HteE0NADe+9y0o=;
	b=xCllHlwKDnL5CX6ia78LWdSo/kyUjtigQumI9OuepvLIojSEwh7RddxnP9M1yAwIOXzy
	 9e76Hao0rOQhKi9RY/LwiN8T8tV1kMoOvFz2+zuKmH7k1DKb2Y1IoFxMbqZz3IxulYVA+
	 46XJQ75xcOtI5c5ZUwNcgB2bhlD9HUHhI6yubSXmQNcTGQnI6+gok4fHtxyQsrwEznJND
	 zy2VhDljimay271CElrALk/bVjpkCvScJt19oyJ+ASjjM4ZHV+UZ6Sa043IKKKidQZXHW
	 fnHCadD4HTw1gZbdyjJKB/o8hztD/SR7a8FMtIsTYzO+gW3i3QFw9b7f7j5clqh4F1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=H8KlNPBF;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="JNr5VB/L";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B66D606A336
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B66D606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=H8KlNPBF;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=JNr5VB/L
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795686520; x=1827222520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=gs4pnfh2wWWCMMDubn90bFlS64B61LgOWW3reMpm82U=;
  b=H8KlNPBFdxniGp1FYJrqS8GhS9hpjU+xFFLJMhc1NWopCcC/v4/rwK9E
   JEEWHG73v2IMHNG6F7GyvmKdZG27wyh5LCtkOi0Zwp5UVqwgp38rGMRjY
   MtrAakXKygaukZFCi4fAMGBe7zOlHstZe+ChQbrH/qcm2csYK12xNKGSX
   cwIYvapgD2o3jAPJ84+1t55yz2qNQPSXGENy3WSwQLo4MkXn0WQTtL4ra
   j5pOPyEWSo6LzAhz7OabengBmDpN8wkw1FRqjdh+fellG4o0RcBqIXAWN
   lReDnAGsRd+q1ZXn9jD5yVr2CF6TYE9ubMG1QxdyZn8QKGAxxpZuH+xGZ
   w==;
X-CSE-ConnectionGUID: el/rWnJjT9etNoUDnXsRCw==
X-CSE-MsgGUID: Pdx+f7pnS9WYdQ11xCdpeg==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="161749074"
Received: from mail-northcentralusazon11013066.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 17:48:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwFGoSET1n4e9ItezmgcNY2cDs3RJLKFYCvd5FQ/CmL5CNQ1cQB1hEsxOJCXdJs+0swTfwvdrTK1xDvbhYMj4VNOT/gvzdi3QfISjlzKB0fm55qyS317veuQliPkklO0sdHEnBNjcqgDxxuiGLe6k/rwNMEiVh2j27MsCP+0MeCsSw4ymUwRTpWpj+TvWDevB8yIHN5+5h4Il8RIfILVB9CFnG39Ega/JJTy5B+jc+dBLcrSsecP+K+qw9UKbm1ocGVb3BPV2O/iR3Br3dkcmIjSRzyxr2GvK+vk0JSW7yC7nrkAgkCqRjtUOUtRAhA3c+l9HWolrK3CqU34u4+0Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mhdVeAtFbPS1rdDqBVOcYCkYVoU1HteE0NADe+9y0o=;
 b=fZKsg0fUgAfElawP5CDXGGIlMJtwjFCeDLGWCIoQhlnDMICTuGIqRlaDCrCk6N6yGVwOUONd+sGXpWHMihBzOu/cT4pA0C3sghkBrCEWk4824IFd5NvkAZCHwDQEqKX1qcCiBMwEk1T50RpwieRwmXUAwZmMcETyYGxH4EAkLHAj2XQ+iBEQr7a8+OgpN335f39npjKcvx8/PIQ4ltLv/HlB8rU6Vamm8wbXnanRVPT05NPPEtmGxflX2HM4oO91IqOatVNpM9kWmJgIGSTll8vzYDkxmcwgNuDjiNv9tqRYIXNeOvRiJtmSnOLcMQvLTbctcmkfux5H6bAIhdJAgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mhdVeAtFbPS1rdDqBVOcYCkYVoU1HteE0NADe+9y0o=;
 b=JNr5VB/LLW4HgGhCb31Wab8eTTOgiGCb1lQk/KSil1OtK0iDtAY4dR58tXN+AA/FVIMJbZo2JpGULozqaN8YTNNnYLKR53t4xMM74ttGbT0HsZyAqDLNz161P8nSu7BtW7LmUyvSJNzn4ERTElyNOiWnagOUAj7pFevG/6nIav4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB6883.namprd04.prod.outlook.com (2603:10b6:a03:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 09:48:37 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 09:48:37 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Mark Korenberg <socketpair@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 1/4] btrfs-progs: zoned: use cached zone reports if available
Date: Thu, 26 Nov 2026 10:48:12 +0100
Message-ID: <20261126094815.479691-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
References: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: c704ddb1-6658-45c4-c4a3-08df4ba27163
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|376014|1800799024|10070799003|11063799006|261009223027099003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261022105027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 lFfjm/ECccoE5bQDz3bEIJ1hHY9i9UGvr9eyyp1OyYBvUdUPZzNrBICSV1SJQz8UNqpS8ftiNTPkseO90s0R2oy9+dI81iAbs/xlDQoMmDO5oOJWwAlGrMJ/VslnICyC4o4QLlmH9zXJUMjHtXCjOpw2r4lbLPJ8ml4ZYA8fpmRr5mtDIdSpntvMpECHz5ci/PoYQCRV15+uvSmwza1zdbW2JBhyY+SMjfWIBbNrbVUsQ2c+uObHy8h3uEEby05apZN3IzQx/wy+IN0Myo52J4r51zoB66uLfyc2oiDmKEPXyFId+jy2FSQHn3Ljr5yxIgQd5oAbwIdkzvJgbWZ8d+TFRGLdkKHvyn8VYzbB9ReWcOzSZHrh/XvIDT5vhfMK4gXFUkHJcqY2CICmGYAmJh6p/zpfCRKjsvlU+0iVZtO+CiPPJvSrk1KOBVGlA7bAnYJwedmFzpTWOBt1i7zwBYySRcFEW4uP35pyRzTQ/D2/MpXzPbaHbUiOvDAgaT2dMRX52UYLEyjnGPOir45m4mZ4sQkUr8Fgye92FgxX2WIlB3NAdvuNu1Ij7MTBaZLlxPQE1ZjKNUwacCDvc6n8V1xZzQhPWSVJ9mzCU9Yu1sWAPPrMWj9idCEZIMvik5A1kVmFeTwTrMa5+HTwa+1zZ91FeJdpiqWN80peWVYfNpQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(376014)(1800799024)(10070799003)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?yi+fBF4EA0F6eHP745DJbLiHbu5qTOW0DnJQljayEWq+kIV61NObj1EP6ws4?=
 =?us-ascii?Q?svw2wfivag2zDztMSHAdcUwoRfgp4aIvqiGHwt757huJFpoyUwt2RIDtNOj7?=
 =?us-ascii?Q?7DCw4bSmadu5vEXLNPYSE/1aiBoiimAZe3xvX+/O4bNuvOBXt+WdcQDc+Tub?=
 =?us-ascii?Q?aDrYYSQnPA6gTKlusaJ7zWjGcwBU+BntpaXNj+BVb27BhXEmpZ8OxAeQfuf9?=
 =?us-ascii?Q?qcuQJ7WadV6uotMg4ArHFeh9Cp0YgjSKhOYPE315zNgFHDfiH8DcZSFYW2i2?=
 =?us-ascii?Q?4GpWYcn76LkbasRrBMdXbB/7DfU1WhJ9so7uHVHUUgzXZYyHqSQS1fHVV6m7?=
 =?us-ascii?Q?qkOIagZIwxbrBPzW3uFd3F0QedtBsyuLWkBtYJNUlOxT4I3u+a+uYGLL4Dkk?=
 =?us-ascii?Q?biBdmD0w4QT+inOfbO0AlGAjA20cM5q6lFXPxYO/8T7MhA1nLHPbeT8lE1O9?=
 =?us-ascii?Q?LUajl1CiErEZDftHl2HZXykmGrDkU5a28UFf4Uhljw9/ETrAjgbAjQwUUOEC?=
 =?us-ascii?Q?2fudx/+X9BfTe7k+NxP2XoGyXzpvPUHOZK0HII+etDU7y4PjZGQglbpLlVvs?=
 =?us-ascii?Q?RaTsogD7pYdAvXybm8tethV0pT5yLxgGmrdW6vVBvNZ+9I6qybK8eNxIGOGV?=
 =?us-ascii?Q?A71HoLI24VlNKswiS4S0GZJHTooAsjAjruj+IDZMGTUtTAQfX7H4ZS6pyuvk?=
 =?us-ascii?Q?gtC7H1v2A/bPiBD148vTd0ykz4mDo7560n87A1XlHvwCk+fTVQ/VvHoh1mJB?=
 =?us-ascii?Q?ClrlBVf96ignc37FEP561Bj1g1mS50foib9FiH8GLYS5m42vTFEeb4OqUZI3?=
 =?us-ascii?Q?VRQgwNEkM2Gz5BGpY5YRFynODX4IpRHhq4YNWhMD/B2H4M8yJPLvQ5eJ1tVj?=
 =?us-ascii?Q?sFCA2vriUj10yVHqn38NNhcb/+2ThjQs5xxPvNu8V9MNgav/0yMZxWtu6CVb?=
 =?us-ascii?Q?pNxp/Ku3sM+riAxamJShIE2/UHbD8gkIU8cercdmLtbpg0yvq94QTSt1KSLl?=
 =?us-ascii?Q?YJ2qOiLgIqphNs8NpQrazxJ72tAp761hXCk7YyQP6DMjouxtp0EU6b+CscdN?=
 =?us-ascii?Q?3T+ZfMqFvmmtsJU73IhwOQ13b5mz+sWaGzFDdEqv+lekaHxnZ9NrRy/Q5jt9?=
 =?us-ascii?Q?jytortOuYqdYWj5wjtw+76NBfIunIcGLge/KUfUDdYHvPFz9/zVr4G/LeZ7q?=
 =?us-ascii?Q?VdLV1D3S3QL0VhyInVDPZ9rVWL6P/kLutCvjMnF1CS73Mat3PceeXtb1NL8e?=
 =?us-ascii?Q?0VNL+t4z2PiFUkG4D9bqZNsrk+IpgZdv+elGsZOmdOx8FUOaaAtmNZeFdFVh?=
 =?us-ascii?Q?fhJu1kcWiAUzf1VQ4vopyVMQYZpsuWkb8NxOdvDH9EDHcqYNjk5HoJ6I8N2F?=
 =?us-ascii?Q?ADwv4CKQVyLVqw5GzIe9rEGmxJ1oMU924R01Yy0HgSAy3OQYyk5Bhu60qfwy?=
 =?us-ascii?Q?nlLw0yMOsMGnzo3pCIsCxdh6M6i0CVNyD8v7fXqRGRCIfxcaPmmksxQ0XLEr?=
 =?us-ascii?Q?/TZO9D96BYY7BHWfsfQqDjiyO7FbQTaHHRho9p96ehoUzWy/Anylc9SfLeCA?=
 =?us-ascii?Q?bJ1s4Gxv2rZAXs4UBLuE7gVDhuSqRAzqm4jAShkWiFfcjbCI6YdneD411xmq?=
 =?us-ascii?Q?Vl0Jn/5pf9jzwWZU8ceZv3qe0T7gkKna4BYbucQmob28TjwgchIbrTTH4OWO?=
 =?us-ascii?Q?94RkNmVuR9yvxpSyAI1KrYwa1wbuYpgsWkeM1N91A1DI5L6/2ARKrFMaf7UT?=
 =?us-ascii?Q?11jb0C2oYXCosV4YLi/rVfmDL9Bm+MyNgOo+xlWd+BEGjyAW6b114+G28NcN?=
X-MS-Exchange-AntiSpam-MessageData-1: MT1wzDAX6U7kj0YCCfaS0BTxSCKsHbdeA/8=
X-Exchange-RoutingPolicyChecked:
	jBl/aUkHHjFRdFMWmjzN2A5+iDsXUt/i87+NgrqPB+J1LeUlQgGwpJq9TN8ZpnwPiFqpYKr6QhSlep/ZrmVaQnAqIziJueSc/5qhGoXSIPiBfayqwPWSovqsu/E1rLx+WewgrNT52HNKzEUKaGXLoso/Orik5FRB4rJlGk4J7nL9Mda++zHhesUTt6pSpVBB3ZLVvyo7Q7j/uFSztb5vunvz2ATrl36kCPq2UC4+QkTrsZX2wbaNwL5+uvV1k3FTopw0ze62+GEYyll36Ttl4/HnWy0xXX/w+7XZiP6gyttz3JbuB37CQJbuWIWeXz6nmntBLrtmeWqQgUG/4F+mHg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JDwNnLC0PHGn15uY4hASuspBhpnCWc/Zt46IqK3DXb/350ppwwOckPMJsKwWbsttrBLQ+TTew1IyZX0lGRTDYxt/QhG1kBiTxRaoxOKp0FEYgsQPuqmu4eu/2xU7wMpgw6p/XUlvriTz7R+XY2D1GIxicuCXVi5GM0PShTLCSDUTzrFH4nNUvBFdJBADG2RclIjEti6pIzxLwZCBw0VuqjqiiND7iOiLQMyLC7qg4QNqVRMcnGf8ZoecF2zKyr0BmqYOS9OfNCPry+ejicagkuMumgTqG86YK2sJ2asFULkxarZwP9t4wEWRk8H9SMs9iY4sIP7bqKEFZQjUeeDIcCgaVr0BODlGtm86eWetSDE+0+EvbL8Kz3PyW2pgS4W6WvXlNENWhcORP52trIQgkYAF7bMIy43NeiFFXbm8InVCHmX6W038lCCQaq1TAxoVbk0S+V7Fc3Jn52ZRAquBRgm462803igm4ezzMMry+YRuR7ZVbbQF9LlDwOk9NWUjl9vK0X7LID67ujp21wAQAksKqN6mNZzKH7HHTBkkshjzMn6LGFbd5yysCzMRfPJ84XfuDzkMzuzZBjvHM4IVUi8NHsH+J3wMBw9pkaHESC/Hfasu6zERDPxLzstHMXqs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c704ddb1-6658-45c4-c4a3-08df4ba27163
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:48:37.0044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A5LQAU72fZMV4LeDD9kdLIU2dEP6+pIbqhinJSO1KpuqpsrkNg/fmywPY8DcMuz3H9IqJ17bhglbgACcmKybOz6DtLAtl24WVEnlyECdP2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6883

Since Linux 6.19, BLKREPORTZONEV2 with BLK_ZONE_REP_CACHED reports zones
from the kernel's cached zone information instead of asking the device.
Use it when the headers and the kernel support it, fall back to
BLKREPORTZONE otherwise.

Cached reports return open and closed zones as BLK_ZONE_COND_ACTIVE,
handle it where open or closed zones are counted, and provide a fallback
definition for older headers.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 35 +++++++++++++++++++++++++++++++----
 kernel-shared/zoned.h |  5 +++++
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index b4ed4702..a06abdea 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -272,6 +272,31 @@ static int sb_write_pointer(int fd, struct blk_zone *zones, u64 *wp_ret)
 	return 0;
 }
 
+/*
+ * Report zones from the kernel's cached zone information if possible
+ * (BLKREPORTZONEV2 with BLK_ZONE_REP_CACHED, since Linux 6.19), which avoids
+ * a device zone report. Open and closed zones are then reported with the
+ * BLK_ZONE_COND_ACTIVE condition. Fall back to BLKREPORTZONE if the kernel
+ * or the headers don't support it.
+ */
+static int zone_report_ioctl(int fd, struct blk_zone_report *rep)
+{
+#ifdef BLKREPORTZONEV2
+	static bool use_cached_report = true;
+
+	if (use_cached_report) {
+		rep->flags = BLK_ZONE_REP_CACHED;
+		if (ioctl(fd, BLKREPORTZONEV2, rep) == 0)
+			return 0;
+		if (errno != ENOTTY && errno != EINVAL)
+			return -1;
+		use_cached_report = false;
+		rep->flags = 0;
+	}
+#endif
+	return ioctl(fd, BLKREPORTZONE, rep);
+}
+
 int btrfs_reset_dev_zone(int fd, struct blk_zone *zone)
 {
 	struct blk_zone_range range;
@@ -285,7 +310,7 @@ int btrfs_reset_dev_zone(int fd, struct blk_zone *zone)
 
 		rep->sector = zone->start;
 		rep->nr_zones = 1;
-		if (ioctl(fd, BLKREPORTZONE, rep) == 0 && rep->nr_zones == 1)
+		if (zone_report_ioctl(fd, rep) == 0 && rep->nr_zones == 1)
 			*zone = *(struct blk_zone *)(rep + 1);
 
 		if (zone->cond == BLK_ZONE_COND_EMPTY)
@@ -410,7 +435,7 @@ static int report_zones(int fd, const char *file,
 		rep->nr_zones = BTRFS_REPORT_NR_ZONES;
 
 		if (zinfo->model != ZONED_NONE) {
-			ret = ioctl(fd, BLKREPORTZONE, rep);
+			ret = zone_report_ioctl(fd, rep);
 			if (ret != 0) {
 				error("zoned: ioctl BLKREPORTZONE failed (%m)");
 				exit(1);
@@ -441,6 +466,7 @@ static int report_zones(int fd, const char *file,
 			case BLK_ZONE_COND_IMP_OPEN:
 			case BLK_ZONE_COND_EXP_OPEN:
 			case BLK_ZONE_COND_CLOSED:
+			case BLK_ZONE_COND_ACTIVE:
 				set_bit(nreported, zinfo->active_zones);
 				nactive++;
 				break;
@@ -511,7 +537,8 @@ int btrfs_reset_zones(int fd, struct btrfs_zoned_device_info *zinfo, u64 byte_co
 			continue;
 		if (cond == BLK_ZONE_COND_IMP_OPEN ||
 		    cond == BLK_ZONE_COND_EXP_OPEN ||
-		    cond == BLK_ZONE_COND_CLOSED)
+		    cond == BLK_ZONE_COND_CLOSED ||
+		    cond == BLK_ZONE_COND_ACTIVE)
 			return EBUSY;
 	}
 
@@ -669,7 +696,7 @@ size_t btrfs_sb_io(int fd, void *buf, off_t offset, int rw)
 	rep->sector = zone_num * (sector_t)zone_size_sector;
 	rep->nr_zones = 2;
 
-	ret = ioctl(fd, BLKREPORTZONE, rep);
+	ret = zone_report_ioctl(fd, rep);
 	if (ret) {
 		if (errno == ENOTTY || errno == EINVAL) {
 			/*
diff --git a/kernel-shared/zoned.h b/kernel-shared/zoned.h
index 2d01da7d..7dd86e4c 100644
--- a/kernel-shared/zoned.h
+++ b/kernel-shared/zoned.h
@@ -31,6 +31,11 @@ struct btrfs_fs_info;
 
 #ifdef BTRFS_ZONED
 #include <linux/blkzoned.h>
+
+/* Reported by cached zone reports for open and closed zones, Linux 6.19 */
+#ifndef BLK_ZONE_COND_ACTIVE
+#define BLK_ZONE_COND_ACTIVE	0xFF
+#endif
 #else
 
 struct blk_zone {
-- 
2.56.1

