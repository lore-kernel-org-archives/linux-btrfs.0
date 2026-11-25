Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602652;
	b=H1XP1NbWpoeEQG7R1Fjaim91zUy6dSbfz9sLb/Zbi7D89RqB4NqlzcoLquuzVvrMb8ap
	 6xnfTjZ8hJCBzIcLr4yGdOQDMXDV82PpXv3I+Wq6tKShoTtB6wYAcObk54fAVYTSFVLqz
	 WBVdhsuJ9SfZ7Gzg5O5fuviXfOXzrSmW8/XfSL9h13TSjI7WJC8lR4OtCBOPQoeTes70W
	 ZFy92RzRb2rIcm84j68DyZc1/Ev6vkP2OXxwd060v/ykORiUvKqbbfnmPGELuczQkeMif
	 GuYj7py2Zc46HZlpoa/KxK9BKDksGL7WupMtxCpJqiSBMjOuGoHyVr+OV/bJgzuydew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602652;
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
	bh=CBRlhbH2mZaws+I9EC7tnK3/hAikSEBVs8drHgqzrUM=;
	b=3vNx5Ht/kvPik1gVsi5kvHKY+LKBOPwAqqO//qnAQDXxTb4I+UMcSJ1Q7NAQ8v2bwM8I
	 f7Hzsz4eIMdl/OO+C1irWbL8lBw+5igbkMrlM+lDnWpk9WuWgfIeORN+AI+o4n6e201xy
	 JIZHHT8UcXeF0kdUc9D0uZBqgjadrlxJH5JxtzN29BVTTJ6/zffSdRBgD92OqZxlQCdL+
	 9EyCYJkiIoDWyIU2JPoORkhFJ57L92ct3yQi/DEgGumgLGBfllDHDCstxe9y2+fr7hGTd
	 erDck5g3B5c/0koFhPc5rUvSSdi3r9ctzesNQDjeY0/amyReIzyTmc1qL4tACy6CPZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HA3pAB63;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=aTx05CFF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF11E606A327
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF11E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HA3pAB63;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=aTx05CFF
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602651; x=1827138651;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=DQNo5Bzon7JilxRBjjoJ1z7XV2avGUuoJWVi9ghG40s=;
  b=HA3pAB63xZ245FTwn66ldqWdHocfAFhv6acpdU/9A7lOKKTNJh1wVaTo
   Al5Gu31nezm/23w/KrPlqZLDeF7iKtrpMC450g+wGROZ9geMBKZOAZ+FD
   3hK2mKS96YlKkkGiOr58TjMbIBHpMhFyw4zZxtkWrRfupli2MbVrqXPBu
   744+Xzsag8bXTRVEPKiCfLkGXrnz09ZV9a+AcvHgdWuFD/S5fSWc/d7yh
   AlqlNIxLOpGtI3hTWSqkSp5136kwjZUwNXsv7VT3oCER4XBSrNmfFI88F
   EBI+mMD3hgZM6SA9Qt82zChl7c4QWYJ7Za7d7J29D0ykWvnWRs0UkV7lq
   Q==;
X-CSE-ConnectionGUID: bgULup7FSSC5sjIywxH1yw==
X-CSE-MsgGUID: 8PkSkFQnRZOToizZr+ledQ==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662198"
Received: from mail-westus2azon11012003.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yjPku0jmzbxama/RZDth1lxE77ZfO0FGFRp+IGkGBuTLNvu7iZqLXHyBuKI8ZRcZH59RQoYK+d/PxJd7fCzEX5FTJ/nWUspx7h27l7jnmWklMiY1C101j91DrWecWklgBEd5VNe6jtErNnaZThu6QaVjTrMQm2Vd/ZA0/RoNm45wZrVi5QpMLRNXIV0+larE3CkcIVKmqehjO6vVLEC7gLZ3xIVTKLwe15GQ5xJGrEAppxjAjhTmfD2P6InBe5VwvK+ARM83yXvov2+MpVK/FBXayQ2JjeFRxlzCBeu0Hsuu2ocZO/9IeGQIBCnBsNMYktrFEedy30BmQYWOo9Rpkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBRlhbH2mZaws+I9EC7tnK3/hAikSEBVs8drHgqzrUM=;
 b=G6HunaBHlXL6CUsovpszGta+RE1sustQltorAbYKildfzKBjsXu7+LwxPNQTD4lq4PKs4pOeXGI+ytBEj90zGcusMHKDoS9hEoCkdR1J5O4rrN/uE15lU01C+fF9j9TIp/D8K0Dxl2Qq4wTcX4QG1R0YeFpMlhmmo8fA/tpRKC3SrAxTIKYWnIvoVmsKuZtPBRCrYOKcQZULfY/qG/rt3pJ4ZDY9YNBrSXXYgoSDYnVqSSPynISIDQ/yb0okcQHeOMNrx9zqSEXu6EFLPix9t3wLJEpa88yv/dliwe1fxXSMxOxBqFplGlrUYDftbzHKwpyo+1BE3JNXtnbyigs23g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBRlhbH2mZaws+I9EC7tnK3/hAikSEBVs8drHgqzrUM=;
 b=aTx05CFF9d/az7v2LvY94QTZd2H+Mw2KWzaYo50gJAKsX3MKxBr6SzKg8sLTj9Y+dkB8ZmFrSs1JxDx2jikinr/kp44fAcvfkwjjUm1fZzhYQSddfRVGKYwMWjWqaf21k6VovwqT5ir8jY998tHL4PiUV6FVsS34JkDQXN20eEM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:48 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 15/27] btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
Date: Wed, 25 Nov 2026 11:29:44 +0100
Message-ID: <20261125102956.266389-16-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: bcfff251-0c92-4e48-3634-08df4adf2be9
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aRewGHjT/eWcMYrw/vuJN0+fuKnsAiPNk0fGYSD3zA+uLFGsAo6tjqK6qkAtY7gvzO+GvkdmbP5RsrO8o0mUO4k2Eqz7UhRZeElwiotNAl408Gqh3ugpXbUypNrEIgis9h6OfyqvJw6PWOfSpkD1x+3fw8vx9c9BitYgVFrnM4RGZF/Jor7ZpvPnf7crFxuU4JM2ByeVGr8j6vCR4HJxYw78cLt6sIcpR3+DrLYz80Ns90CIo4jXd7f0mF5/BQRxCZLzkgXxg48cnvRe00WyCuu3minsGw1iV7248iazmdNDG0X9MDlyMlIWUQGIkjaE7qGC1kFSRSv+B1e4x3lJnHWS2S+EaKN0QCulVf2Ms1S4eYgONkwY7tlNY5KrGnmt5QMXcnNdPPzlw6OzStGIXXJbY7+07vvRUpbO4ki04tQFfMaawA7D4dD+k/J7QPtmXU2FIMZLYk4fzis45y5d85QjTE/HPgxpCsD7o8nRwR5ySC8yesQsS+qy9wj7xLq92ivIYaRD+Hl4JYyjN6Hazcie77Kz3KI41pTZRBkImvPJPiKxUovx66ENv5nJ++XbjZ3T7Auh+ZhlZT9hNAGOSMVMBm6pyIiDC7OW0IHgfpqNeytzU7XoQOsUDQ8SQ1HXpzWqG+6flK3c/I9Jh5n8+IDtZ78Bcy0H86ON8xvtrGM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bQbNdKFymdkzbm+/HKAJjT06WhbDnmJaVgbB0lzRU94cijf9wJA65eJq8JDO?=
 =?us-ascii?Q?EAXUxWvJ4HqGalPUD5H3XaoFs1Mr0ZZZcvV4wzD+RE6K486gyLzmyEaZlb5Q?=
 =?us-ascii?Q?LXv4ovNrOM1YmAe1rbK5TuHl1qbaEEwCYcExqCNRXZV2lEc6c64vnqAt9G0B?=
 =?us-ascii?Q?JacpC5go336OoiGHxZkHzMI8nOh5OWbELHtTizOBh5I+87iKev1tOB0Y1SQQ?=
 =?us-ascii?Q?uxA+7Gakh95ihiUZCI12vne8HODL+CJMX05HCgiP9sxK9V6D1/yYmf7RZi1l?=
 =?us-ascii?Q?qDNyv2x4VztE6GY9pxn4P9zPCGyD/xMQNNCdqexy3boLvcQf6311Y7uaVNVo?=
 =?us-ascii?Q?o6U6TT6Tmcyd/gvjZc0oASnO8xzrYcILMeVxDp+q1sR3aeT8XK+rMnR3QLQW?=
 =?us-ascii?Q?MRRTCcIqtPHOyeUmhR5Gcdlr/uh4Rps65s9RLJiAaL3F03SFO+nXaIm6G7nU?=
 =?us-ascii?Q?4RIOeZCf+HZv22Tp3K/GObxdHI7OraRJVQ/kvL+CeYlqJIjiouG+Xvrw3P1E?=
 =?us-ascii?Q?RNbu3d/72dUYNq5oFFCKFFFAVpAIVKymIMMNAMnN9voiK4EHdvhnpOrhmsPy?=
 =?us-ascii?Q?T64BX1oo6hhvpzb2VmSLLDL0V0YwCSDf/++YNW0ysQ1HFs7UIyldw7O9StR9?=
 =?us-ascii?Q?HRbDKfYfjPFsO1tOr4HZMt+7ToJu9kHm/u+aEc1Y67Y+gZTz+Q00C9aYl8TK?=
 =?us-ascii?Q?73Hs2GNZIL9vh3Be+QCl4lg6ouatB/rlDN4PVOraxFBICOlA3ch/ZdLT82kw?=
 =?us-ascii?Q?JhgCvgOvG1teEJWJnQxAMR0VTLf1hPMtrAM0OLEIb0MWFwccYnkdaKvjOmEU?=
 =?us-ascii?Q?a5G6jU/NtK2jYYdyfuq2tsof1SJiRwKtHOS6JazlTK0I7eC0ZK5dYq+SdWCB?=
 =?us-ascii?Q?ytT+SdATlUnDNzPVZtelk7iQMMpZypdOkiETH9m8h4Qa0OAkc6mqJWh1HkX8?=
 =?us-ascii?Q?U4joYsbtx8jAwAoLIsqYfTRalVVi6/ALjXpF0DuZV7b0ymCOiI0DqA7IP8uT?=
 =?us-ascii?Q?d0a2RICJ15k4QvsQlzFkg7wFSxBLzZDpr8djTgBNJcUGCi+dFId1p1h7CWRa?=
 =?us-ascii?Q?sIyuyIicuUxlO0zwVTbTrstBxjrJq6zoiYL3GDwaR5tIJ5L4BXwTpreXzc6a?=
 =?us-ascii?Q?l2/Ed0sOilS+YUgAz4LhOD9nQbJcvRqOnjsYW6kyPhfFj53O+OIeho2R13iY?=
 =?us-ascii?Q?jj4mesHyNmpZjqcEkv5wO8dpFV6NZKYXkX72+Iyh3DyKSSnvM6UqSARcI4P4?=
 =?us-ascii?Q?OBfuaeoX4rt1uK2YqWb29i/8kdQJyALaZxLsBQrnykEjJYDAf4FfHyWd3h3e?=
 =?us-ascii?Q?jWraVuXjZcZvQMASXJ+tvq9xMBAHXiDpLPvb4K7MAMKhWCcgvk57zoqkDUu0?=
 =?us-ascii?Q?+gKDylyZLM0ZiaA6FShWTjiTBWAP8g4AtTmEQBuWgdfLjUmVuGRdT7BFoK1d?=
 =?us-ascii?Q?X1RjAs1FGcfk6qirfOTTbwHfLaEAjMwH0RPh5x9r1rTKwx5P7uDyBff+vjMd?=
 =?us-ascii?Q?OsZPGElMXDSCG+WMYTJi2kjedps/naOt576loPLVSPqGROVhCgYTf2/XJdNi?=
 =?us-ascii?Q?mqImtoOJemExMsg/mZu1x/XAxwlv3/O9kG+eaHcPVvhXd5BMWAAQQIOnavko?=
 =?us-ascii?Q?YR2KYZA0N5b8idj/BljhOruaFeKxSF5xi4YQMUdi+RJBFpMVgNLlytGdX0ze?=
 =?us-ascii?Q?TeQ+9zTmUJlBnveKDy3a3mPnu5+UctwcRF1+17RbGARqi5/YdWvnA4xFQyQ+?=
 =?us-ascii?Q?B+r+n2Zsst13AHqOM+hO63naIJqWL6YZxWSifhpBRVVT/IQZg5yHPuu9Lwc6?=
X-MS-Exchange-AntiSpam-MessageData-1: 9gN/eP2CfsaOSm2saOZ5cLutJKaeU/zVp8k=
X-Exchange-RoutingPolicyChecked:
	RxzYj9ZXe70DLHvDGChTg6Li1LHnBL5qdP2qs0WJ7eJgbO1CbiYFNyBo4EUQVlYeKDU9IGKg8gfYls0zkXHwll7VDJa+bQ1kOe1VzGdzOXVRVURucA8O+WbDSMp++UaMIjwdhG/OhLSVfE7Z9azAplxsXzxqU87AigMYqJS/B7GEVO6w3l0T1rZl1HLvcbL+p+DgqU0vnpOG1FgEUOCilVD9tHgqxfbO4FA6VXDhRxgzaULcT3OMvzsrUbEuLFw9ycj0xRbei41jrxQZHP2ALPMv1amjUalP05Ngn2xSpU+iLGWqZ+6mi/KVnn74HfbUEWpuUCHFJ/EsLxNG8U0QIw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tlwMT51TE+eBeOJoZxdqqzypEMO2SgRzEQYsh0YpgOv/xYO3BxtyuI0hEvxwNADnyai8/cIbK49ZFljbQbcASkzLzIIdTlSj6CanOg8tzuhASWQMrw45lTsjEg5R5PB7ZeXIARXZvahl7YngmhNy7UIkonpU5B5oZ9LaiYyjrDMesN9ZqBAjJiX/E8snaYYtPCgUFg071fd5wxm3R7E0eDF6h4fcx2Ixh3NAFoVK+TetShFxrGDJu78DfQQuoptSQ9vgQaD2Y7pRR4JM1c8BmRMZrnIeXFAJk26+ZInbkNTdKlM/9JvtJwBoaA0sAnZJxi8QwtEh/fR6wTX9QHenL+/k+2PIWd3xAHo1zhOD9ZwLGoc8ZM2T6DAcASBSDG3CScTUvaNFc734hW4Ih6OKIf0trYwmY9/iuSsf5eYE4U/YpruQXpMwyntNl47UvtaBEZp7F0pL4x/B6xnTDDq++B9bXS8wcrtAHQ28AMBsRWoEkZ2dKztHF1QKdaICDjP90WXaXxluu/t/EkVEAe5otO4Pj7UY0LTlJgMLtYVENX4L9u0i93NLZujLPyAYhORKpgVHjb7pK2FMEAnsCRmBXgQgGBwCvKrxW1migzRqxxo0FhQkmYlt/TSwkNROebqa
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcfff251-0c92-4e48-3634-08df4adf2be9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:48.6074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eGWmcIALqlcLpGNohLUXZRVrJqOI0UKt4s8ZqZjDzVmhyjxV9jf4Kme9cXxp1uzSbKu6UAOMrGSlJ7L1V8/qvD+qq6ET4fE87Zgg2vwFylI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

If the reclaim worker is relocating right now,
btrfs_reclaim_block_groups() bails out, because it can't either grab
the reclaim_bgs_lock or blocks on the exclusive operation.

Wait for it instead of failing the tickets while it is about to free a
zone.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 9 +++++++--
 fs/btrfs/space-info.c  | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 622b9abbb2d8..b7b1fabeb081 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2102,10 +2102,13 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	if (!btrfs_should_reclaim(fs_info))
 		return;
 
-	guard(super_write)(fs_info->sb);
+	if (!sb_start_write_trylock(fs_info->sb))
+		return;
 
-	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE))
+	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE)) {
+		sb_end_write(fs_info->sb);
 		return;
+	}
 
 	/*
 	 * Long running balances can keep us blocked here for eternity, so
@@ -2113,6 +2116,7 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	 */
 	if (!mutex_trylock(&fs_info->reclaim_bgs_lock)) {
 		btrfs_exclop_finish(fs_info);
+		sb_end_write(fs_info->sb);
 		return;
 	}
 
@@ -2163,6 +2167,7 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
 	btrfs_exclop_finish(fs_info);
+	sb_end_write(fs_info->sb);
 }
 
 void btrfs_reclaim_bgs_work(struct work_struct *work)
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d5a84fa97462..bb08294cbf9a 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -913,6 +913,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 		break;
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
+			flush_work(&fs_info->reclaim_bgs_work);
 			btrfs_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
-- 
2.56.1

