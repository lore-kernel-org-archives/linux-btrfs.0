Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602643;
	b=VSdiWSX1twM1V0vd0Xcy6LELBZIlFvL7ju23cjP85J6PmP+n8kJOO7DC7AGdgWCDG21s
	 wanTLCKbdUGcndJAMVgT2iK1Xxv0S3cTYJvmm6iq+lzFvzAssS9JnncmQhBn9atB9UgC7
	 cx7cGTtp41aRgNcJqW1+TZQRH6RxLGGWW5OSBpprXGVGzDmzumyv8sibK+auTuWkhW9Rv
	 Ge/4ea9zaxxfaHjChEQs9KIKdkVgfEJUveOC15gB6SfwzMuSVYelAuHz0Uc9dIpC1Rdny
	 XiwjgrmbHomcrBfxKAEdFePORbkhPsYVrJcMlwtVp+KdgtPUlhd2FAySjABTb63zsag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602643;
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
	bh=KMFR2fT/l3ZwVEpt6nBNGXswk8kHwgcyjLEVBRAvWaY=;
	b=RZbJutccO+LBrbNarNvMSi8Vb1N+PIaeT3a7p8eWeTKbxIrX1fN1QloP6tms5fgFK0PJ
	 HkrXT+RJjexP4/mi/LjJb+bZ9h9JdPr1sd2aLHrPltq585wFre91pBhQjWXkvgz5NxCTK
	 RaF9YTzL7hvIXysCsarKkDHzPE9R9Dx6dQrglHouhX0EvElr13zSenPZdmg4pR/+T9Onm
	 SDTTCbBZlX+1zq1WkU6b3NMfckqnmxVYG63aGi3a6BQ78KI52pA+uN0xs9eS6zWIkjuyu
	 YPI7fo4MFdv3P+Q2cUPljyeN5qUO2qVdYrxWycuWRzots+j7O5qEr8bZ6iaWgl7FKOQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iDXUwqrh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=msvofOUs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66978606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66978606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iDXUwqrh;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=msvofOUs
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602643; x=1827138643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=DsNCMINfQqXBYOMEZOXqQ2PQ1egkg9DZCkzwNMYE3uE=;
  b=iDXUwqrhfRzz0kRhq5xyQ1O7/rlfNeiO8HFbNWfJM3WO2hc3Vz6FJYaX
   ttSXloWjUtw/q+KAtmq4uF4AFCK+MP034G80uG4P6fCx2A+oVUmIK5/zs
   ByLczgJfZkXsn70LzvBknbnit7Bx8mSmA3gq1uqcNWlMUE4NoXHKsg2f+
   SVP1NBc1LzNB4b1TKlwHTkISxFvHFyZfBYfmJcAAbSJXxlym3WZ0gWRe3
   kXM0UknvZJPwo8rcSLYpbapR82cXw8V7+xzg07am2hcsoE2fMrwuxUKNU
   2Hs+0HqF/YWbHHfqmTNsCc7YClC6sEdsnpyjSBDP3XHKGaNdB99WHJOJi
   w==;
X-CSE-ConnectionGUID: lTsNCRDaQs+1W0g/3s3/2Q==
X-CSE-MsgGUID: dyUiJj+kT6m66cZzMBEJYQ==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662179"
Received: from mail-westus2azon11012068.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hnLsEwxxebogtuhaQMTGasL5tVJo5UawvIHY4UuuwtiAlNusyVu8NGfHiXhNnv0EGnRcYG+xHDL6sBPoVYOkd0uSplKJxcs5RGpl1vLl8RnDG1i4VIogV3+3fqGdTlgyZ32m+hGYNx/ogbDPa129O5UylLqyIZMnjSBvKaDAdA2pn7WWgy2f9QFyGrIcOI0X38dT+rwx+CJkRNyia31g+PZZyJsC/CP2bV9PHv186ehgMdEWpF8XoCyI/1WrUw1ExdKb8mElU3hNNc8yz31DEcc1zkDhFIHZ5oFP77EU9IJnFnyJuiqV5lrKVZO1afIneFZpNgNu+DR2dOoGz0ZF7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMFR2fT/l3ZwVEpt6nBNGXswk8kHwgcyjLEVBRAvWaY=;
 b=JKw8XE+G2WPEs52PMV8UM+f0jZfEpA5keu1EOxV0G325fPYw6ogkJ22ZIrwOTqtdjeRTgZiIvR4onQfZAeg+zlXiLK93dBF6I0y7JnORjt/ccIsPINZ+3/Z1vuvG9jRAjBxky5fqUysHID7EhNPwbcD6Mug/o+MpvipjT6XFb+kRg82QsKWNquxPxIuY0srashNHjcRIv+XUIo6MWyPfYmtgTCnR5egVwElpbfVbpuV5eO7IYzI2LZFiOyOJbt67XiFaltsj0A4XaSkHrlibDsPnKySeaRBMkbGO55prqugo9ygE0qjXeYUoXElNpb6Jl2BTzPsd2vOotiSgT80d9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMFR2fT/l3ZwVEpt6nBNGXswk8kHwgcyjLEVBRAvWaY=;
 b=msvofOUsRpXg79HsbijA3t341gP13UX2WRHxli6JUJp5hS1LvNNbs0xlGjEDprcBOcVkELIl4IynEOKCGdAats8dPO59wubL0rDqvTEBNEAhGOQP4aWsHxH6ceoIsB6Bhb2zvYeeS+otK2eJOJaMu/xtVelVMNAzoUAsHoB7v30=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:41 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:41 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 12/27] btrfs: zoned: use plain mutex lock in btrfs_zoned_release_dirty_metadata
Date: Wed, 25 Nov 2026 11:29:41 +0100
Message-ID: <20261125102956.266389-13-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 16f84c6d-831f-4b61-756a-08df4adf2785
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	T8/8kvhRz5zt7Ijgd+vPj1bogeN3mKsOAFKCxOMZr5c3gftVVOVQetRCs60aYA3tLCFFjOYvGGjWltUd3Drux67o4OycTxIXLyE0/GDRQNx5e8/k7Yw9umi7EvHvFHEo7e6qzI9xQwy3spyMYNI45vGSgUMkGWPtGYv5NsITLCntTQBAaNopliex8kUTe5dgZxcl5nmOMzWosYtfZ8ymKaAItAZrrg0G9Hixr/JybSWwbqhCoMB3iP3IIRkYhrZZSq1y5UXqqY6/eQVAtq7c1V+/0dp56JjyyZvY86GGxWsfRDiIkxaDl8+rVSIQjBqUoFh2qVFsxXwIuwVdEUYmIY9CZcTLL5XTD1u/aFvUKdKTzM7Dna1JI507CngeOgdIXhgu3ZMgAuq6c/ZagUUaGZj8VSyU2Ehi7Uzd0JyKY+UXu7HUVhk1B2M/P57E1DeTNVMUhvjH+NUE/9NP/4wYCdlqpoAUzlNNUvUGAjlcUVjQGxC36pvNFdvJA7Ze233pdv77t7gq/vm4o8vNdSG6QPoI+JqBwlOVACKr+0Z09R6zN1W46WNgHaUrTR0ZECBa23UK1r3NNo6pybb8XFSO7ioNJwE3fIJrjIDTwrLrXg7iN2/2gYHsJZ2qcRVotesY69c5xMgZJU641yu1sRjeVucHEZJL5Objy3YjVkQ8LUg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2D16JnXV6lBEN85Fa1CGwyXp1q+i53EojDp7TXcU6MukoAjZTzjQ6mIw2Ns7?=
 =?us-ascii?Q?asSrT1oJnUmCj9Kz4J/iJCPHNdq+KTPiWX3EtA1IEWhVh2f15w8CCJyDDfZU?=
 =?us-ascii?Q?xx7I74iiYBt4OmmSTHkHEJqz/jkOGxL4zSOIHBs++Uh0H4MyuQJrXvEqshjk?=
 =?us-ascii?Q?Ku+pkFIgxg4i4UctrLVOGUbhJ/4yhOcD9J7GK2065/hwExGCo0r1Uu3MWR7D?=
 =?us-ascii?Q?MwAWeNsVe1Hui8dDdch0zSI15RLXOcV8qA3pIQCMZQlIH0oFkPGEB0DD7INt?=
 =?us-ascii?Q?5QGvukkSIKMkoTWVoi9m+9qaW6TXhTdf0V7+FRr53Ql8Q1tW1a1zZpHzx2j4?=
 =?us-ascii?Q?KaM63rAZO65rHrrW0DMbpkhfhZbcEezOVgzC1vOwqkmgzKMdYGwGMSthBTN+?=
 =?us-ascii?Q?Df0a+tuZquU7WK9PaaB66/ki/KfU41qySzjYNu2lEqauz8cFFRyG9hfLW0hs?=
 =?us-ascii?Q?a5krlFINtiISU5uk9EAYLDUZ4xEoB6m6I+/LSXOHlMDRlgxScy4q98gr4oTB?=
 =?us-ascii?Q?AG5TI7TKOnNUUip+6eVL9X9LYx66m45y9BVcp/wCxcxy9c5jDevDYLk+erFw?=
 =?us-ascii?Q?yH9X2n42JmFP+dUu00me+GttGx6l83L2H066J+BKOD2yLp0MWfEeuXDz0Mib?=
 =?us-ascii?Q?v2gr0FINH0TcZe3pr/AxwyhRr18nGpV/10IcTDo2SF3PuYezwnIKNRMnT+6A?=
 =?us-ascii?Q?FgiBkVqY52gOu19H6zXjUkgwFBOpoqAHQCa+SIbZpqBlEwDjAXGczaChwx8s?=
 =?us-ascii?Q?3vfvh/6/2oWqXVNFolhY3AMrNMMeNLDREdv3yo+FD7ocmmylpFhbKj3l+s43?=
 =?us-ascii?Q?4kpEHvrjX9HK2Hh5pkDuvgKB76exFvk3CYF52LwV1toNJtw33Vl59Iu78XaN?=
 =?us-ascii?Q?IXd48dmt48y72nK6nqV0ZyRUuw8Lvyh9nkf0nHSHLI7AYfFfCIC8yxgyoAze?=
 =?us-ascii?Q?BlSSTB3CwevwmynaLH5tfLK2C+6t+8keQYHr1jCTw0Uxr72brJWtPrdkv1ub?=
 =?us-ascii?Q?/ncdNs5Qly3ou84L6n6H+aLEOnAmvYU8bw15Woxnzc/7YnkPnDUgcIi/vpra?=
 =?us-ascii?Q?sIoG5SzoRD7+r8RlEmrcw1fJyQ/SYzHRRmt64FcfQs3ugKlhOiROd5BfK0Hx?=
 =?us-ascii?Q?5UI89y9gfbxQTcJEA0DRGD6bOQlhkigpD+gaMJ9Lq+7pSwuenHARoKDYBoaO?=
 =?us-ascii?Q?q8fn2EFcFWuBXzNK1+/T3nHNhpmHO6YEyl32ayCLBk0yzckCoPu/CvfXz9SY?=
 =?us-ascii?Q?As57QYY557ZoCB4bBO7a6UY1/tudlvTgqAfcskUxtP9gDcU4IsXD64/buLQ2?=
 =?us-ascii?Q?SYHmqz0F+I5z0KykyxAXWfhcCpUGWbSRptjlj28ZzDkkX7bUNAGMRDFcU4r5?=
 =?us-ascii?Q?cCvT2PIuj5CfZe6fZfIRpModCx2lAd2I5D09BMcDNjxqts34svMpX0sGty7/?=
 =?us-ascii?Q?YlliW0A81ViRkK0/lxA17C3OM+vRV7+EpTL8K5b4FOSWulReFv8esQodeveo?=
 =?us-ascii?Q?rlH09Q375ASYR4y/mnn3DMzVM4MiDxJM1pmUnkzCZoMUvWaLMe7iUNaj7+nT?=
 =?us-ascii?Q?ECb2UdzNLEGXRMvGrtlt0r4Yk9aDokuaek+XiqKz5hQH3Uv4AnkbLGdvP2CM?=
 =?us-ascii?Q?oSnNZCBj3QprlXfyQnLwG/mJhV1+gtxPrZ9064s6IAV2eoKpwCjkNWweWDDP?=
 =?us-ascii?Q?RYGjJKWZGBDHCjdV/N8lHVleI7hi/L4VRlepZGwN0z56HK6aEv2/JfsoJE98?=
 =?us-ascii?Q?za+We8UDsSemF8q3d5cFSTNG+KS9wAYFekIUPr5ddoohv8dB18yKt8fpARPz?=
X-MS-Exchange-AntiSpam-MessageData-1: 7se1irwom6zRcZpxojp41wcDbQv0sWvWGL8=
X-Exchange-RoutingPolicyChecked:
	cCSppF+eXggil3/vb+KuEWo/qVPP2e1H65hM3Dl+/Gfqbd47l2We+XzUu2M89VhmWrtJL89e/lgRDUj6vSuZM07J+DdPyU3D2Ipu2qm4WrmubW5wC/whqXiLpfuGtsu26PphpmEUbPRZ03xUeEh2RyeiBQGneDiKSeYiX5AEIa0npMQo1RIye+kOmHBimNZGmkzHFsO7o+1W6NsJE5Xsp9bLbY/YDqMbge8R7vbiHSIJdGbBnUOo7ns4gs7zyO2wjgXGHheAFfuectlbs7P/O2T0z24MJw4tpSIhbuKCF2iIhO4D2Iu9lFkFvdC9ulZULOi9WwLdjAGrHbCO6BLxrA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	txPRyZc1S4L5D5ShXHQJBXpyqwgKlLVH8A+atXJrW0SrqBhUPsKhzM5Xvfg9cq32dfqhrFLqCuorfDdjSVdYT0isrkvECNyHiZhKmY9QNn/iqvVdIoT7HfDPcp6lnaVrR9pG0tChe/A8P89XSWjkm6ggt2BvZVJLijd2wBaRQuvcNSWF6QKM4KBtKsSIVUyQXkh7g6r9DEqm0PYBzOv8wsrXQU/tybMf2lgKhMCAhQVBgysbkBTWlVkHDbYdtvZc8mY0/1gk/jafv87WhQ6nhrE+LUMio2LMQjhDtd2gCWxwsxsLNg3Yo4DByPN+I4Wjm26J7NFElTvqrePaV3ZCpDFQ3Oz3PMWHy1HLL2FDxtrTMSgST1yXjEeLpBbJAyr9JtZ8MjF/372Ww8n/tthZRajPC3EmbGf93uh7S/NYxbkzdiY6fX4OOvl1YLCiBpjGQk/7ncDVlJdFUc7MWnORW7diJobmhpRnW0iwF2X9dK7RNM7kgb0Is3vRa8XHqsuths6RG6KZ8dswHZfyoDksEV1GQ8A3NssypI/WY/oL86ClOz59U9fpQvq6UNtZVFbchHi2DmVvnuMBnuuU05sFVIkKvL13wxO0z9+Jd5mcdocCY4nVRdZH3o/d3OVJteLm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f84c6d-831f-4b61-756a-08df4adf2785
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:41.3531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /65sIX7QPzwmFzBdyGvDi6eg7PQmpVVOo2DAFeqlVN4+RTKjMvt3KGsgLGsTD1hqMPuVT973V0AEm5RN4eAyU0PALd8O8CjuTt7mGM1SSsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

btrfs_zoned_release_dirty_metadata() already bails out if it is not
called on a zoned filesystem, so there is no need in using the wrapper
for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b58482e62aa..0b04b6aebac6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4223,7 +4223,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	btrfs_zoned_meta_io_lock(fs_info);
+	mutex_lock(&fs_info->zoned_meta_io_lock);
 	eb_batch_init(&batch);
 	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
 				       PAGECACHE_TAG_DIRTY, &batch)) {
@@ -4239,7 +4239,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 		eb_batch_release(&batch);
 		cond_resched();
 	}
-	btrfs_zoned_meta_io_unlock(fs_info);
+	mutex_unlock(&fs_info->zoned_meta_io_lock);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
-- 
2.56.1

