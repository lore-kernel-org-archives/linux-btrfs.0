Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795699728;
	b=HRPZ2YzBQ9Z41GX4FhqA0nMCoFbw4p4YPX51yvifYUlyTWN2zm2W6MywTUme+BlmUW8P
	 7YuOxwQHMgta5d4gnPkPWKHRXummjwZ5oG/rkTLR3OzOAkr/BXpMyLjF6EKBkL5b31Qzv
	 nG5YNgaVayx3bffHI4wvJlZUY4QyL/MbNHk/PiQcvwjlS5jXn5AOUtDMvmyid8XZ+Pc//
	 Yj/5M6IQgzFbSpBeMBFFmRdkY60IL8Lwff72E+I/2F+1Cf7Pct3TEWJh0407ikPWM98qb
	 FNsGShzmCuRj5qPRSK2cx+Y1yof/gttf5V0JNleZK4hj5n5KIbB/pynnELcTp2RnV4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699728;
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
	bh=CW1Sx6ScdybOpePU5BU8gHIWvZzrG8dz0cF7Rqzo8Yw=;
	b=iWHM4XCvfg5xZli4JXtYz1gSxqUkg+gUAonhIN0TyyI1nR1DHv2tqo3/nSnWpgJii6tq
	 g1DtIgQJ6FnyRRLwISbE+KncxqkEwyBuBrCqUSBrhKpRmgjcp8H+ALNgq2zdizLkKdTYk
	 +Ntq7GO7vUJYW2lu6pqTTmGigQ35Ax6PJsGQEEiPvTOicwAunsVhvKRA4Cb8orxYXge67
	 IXlwa+G7ezqjal5JUmhJA0c3PjS9LBfRdSyA/0FpXMmU2pL/eOhYqtCAfoER5mRuh5rLi
	 rzMmi6+YB4TZOP4nrguW0lQo5vNsjHPCj/FFad6s9p3iG+j8/JtRKAeQ45UayiY1/Aw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nQoVTN3O;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=H6fkhiGx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DA6606A33E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 13:28:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75DA6606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nQoVTN3O;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=H6fkhiGx
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795699727; x=1827235727;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=dmGVO61zVV1eBFtn1LvXs5uKQLUy9DbpYPGgQjWBE34=;
  b=nQoVTN3Oa3vSdGGfHvm++RgIy/vvsstjozxhr0h0KQIljD2himb3Qh+W
   bc9T5mdEd/lSapu3pr1aiIBmBeG8ZbXp80rcDnMInO7NR5Z2JmjgKp+G5
   g/GZBNUbVl1j1qFfPReNh4F1J94VPGRiiikRB49ej7uZN3e1OyROKLf56
   1y5osivBpCD4oRZJ1g6zp6XWDUq0NYNT9kuH7JPH6WPth95ImnjNnUDAf
   3Higv1zKr2tZhWeyCxKJdPjCKV1X7BYZe6E2wtiMLFPUqb5kxolbdqGsT
   iZ+2UrsUrOu9RlGbxLmrkQAwADcjUnM58df4LixDu6Nv63Kp7w2i+8Cvc
   g==;
X-CSE-ConnectionGUID: Ir8Yawr8SFmG8aTSG0SmBw==
X-CSE-MsgGUID: AVf6FveKS3W2ho80GvQTMw==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="162817775"
Received: from mail-northcentralusazon11013042.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 21:28:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hd84dzqKAcGGTDyDYNO8JwtIxoHyoRRzTIBajZvI+DVo79o51U130WVjGIsqkava1XPok5B7BwsE4aP/2uVwRsJkT4dFOrmY8tKF/SjkRXf9SCGLWdozXz0FMZpDifQI9qFFofX172KEHKYIdnFlYeT2Osg7+2GamqSRjcRrFgxz8WqSVmzokQ+s14j4SNe7tSPE05AJiTKnr6T0yVh4yRTaOIYWX7d/DKigcNon6NJ3WxFo/su05RAwJOU7RsQo80YxvLaU1Korb2Tz2oVyNZPyKq8TcZZOwZdOeh2bfAuMlh+BV86VmcaFHDS5seW6H/Jvh1xS0igiObdIsPomyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CW1Sx6ScdybOpePU5BU8gHIWvZzrG8dz0cF7Rqzo8Yw=;
 b=XR5OwW+9hrZ9OxpJS8dqYVDbqiD7mgzSIrrODfwVjNRIMvTdQS1ls7JKpnKpWLrzJf9uaTVJsEymT/AyAK/Mv0SozcEokeqmqxu0PlJ39gJDIdQvmKEdam6fnG8bM2j3x5ktF9bScnLlPSAHrqzIerV2dZYuBQEoEU6srawuzh9y1R2Yn+g5B8rI/aOcK/KBRTgmdox0xZ68mGJiiBpMMs1smSkHfaYNM/P5OafhW2n58cCNA8LIVfdNJcq75cz4XxmsqSmz0kNHFQmiUhYQtbP7i99ee2rR0JINw0d2U1gsGM+mWdLzILYSHta+B97xOLbrahhhxrN4XfW/W6N+xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CW1Sx6ScdybOpePU5BU8gHIWvZzrG8dz0cF7Rqzo8Yw=;
 b=H6fkhiGxV/7nC26YRA1lff9fd2smVVx2ALJQj61wDVtxfg43LGNhgCDTc6R3j0fDbsryLLS7R/Ox1z+EoOjdOm8NgxSXrk+kBNc0sf4Vy3/3+4RaS8ZafOiXugqfdOuqQWbsLY2EeVcknAq+C6lbavJyZEs+1lupxPbtFTEY4ZI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9155.namprd04.prod.outlook.com (2603:10b6:610:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 13:28:38 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 13:28:38 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/5] btrfs: rework data placement on zoned devices
Date: Thu, 26 Nov 2026 14:28:15 +0100
Message-ID: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9155:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f833c26-163a-482f-9bfc-08df4bc12ddf
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|376014|366016|23010399003|1800799024|261009223027099003|18002099003|10067099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
 wrB3KTDYroq/5KcN0Zwcb+upkmV15YI152CGygoft391N6d9EWpKpEbYfTWVpcRsImlB0b71Q8HAcszuzQ8l3ekeZ0iMYG6QKpnIozqsrENP4LXmfpf7hb3QX7l+HJC/j46y5bMahTe9IJhpks3+gYIUfU0P+QZai1s/VTdCQpreieAiCMgGBjEmFYtzkNbT+dnUaGn/WeR5ybqgxOh6vALWO1/Ckf23Q6k22dRiYOZiYS/ydmDl+5b8VUwsfdN/o+b58bQ8efn5UZr+EuKqWSKajFXeksqGkgUF/WDnX2RY8j1lKG6JxadNK2YqH1bebam0tRkrLS+0pLigsxUYEDo8pDC406E/EO11TlTKki+3DqSuxdk7j7RN1NgS9n4/59buvVbCn/2wXr2nrFxKDaGFbeDuaa7Nr0KUkqlEvnKtiJ7FmtLC6BGJ2CltYceq+2N6gvxWExEtGgxCPu7RjakaUmr5mzfeKHhxRCgZG/bzUy10YV+770dIVlMDjpHuQKWpOij/1hcxDdWPG4+7ekvBbQTTOvfyNX1tupDPeT3tZ3hxRl36Bgj4hnBD9QMAGA93RXCofy/3F0Pwn2/SATApXpIG2J+/iufBGGQ4TjH50pQf5vK3ZaMEuEEW1yxl1HfKYn3hdUZDP71UIAC0gts66kWVtv+Z73DSKScoDCw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(18002099003)(10067099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?GAMYo9WsXtBRzRz5oG4DsR02OxhTaYkp87fLbu2jCt33Vud3PjF/h5FHYnyO?=
 =?us-ascii?Q?DCYqTFfzN0Hjvc00Xgk8GYFFWkO7NCWRmSL3PBUNmFuSW0LQprwiREjEmWMd?=
 =?us-ascii?Q?SQk/+/H7eblfOeH9LZJKnB58vqH26PkLpiWROTXWEU3g9jSAyLK6gYYz1sg5?=
 =?us-ascii?Q?J20wpR87rDFptDDKlBgrpJXGJO5vN61Ec4XDoVeuVSmawKw+5JeRJ21skj9i?=
 =?us-ascii?Q?vbSyxlExUAEDIv6+1+TbLxekeOG9kq6A6D2O04UgyTiU4LehIPqHbUBhRGHd?=
 =?us-ascii?Q?OxT2vkEJyA5kYojFlhmq7/BKS2AILEFj/YMPwMmwJWSLgYupxtoTxL5TSylC?=
 =?us-ascii?Q?SgeRozbjvs9/t+xJOThS/VpfgExMWRjtgmyPwWA/gas/z9mxJWWN/aibpQmL?=
 =?us-ascii?Q?tMZyyy5KOSWnazAPBJ7uDG2Ui/nus2GsJmgLMKK0pdSK9jY8BludnciDxoNo?=
 =?us-ascii?Q?Fa7RXyLR2G4TUc0K0ZsNOX6zUnjNYHDMYWh3vw5H4v68S1HmtQ1UnpLTMPsY?=
 =?us-ascii?Q?dY33n7piMjoDaKSUzvOLfdMfHhXrID0NZzBq124hFaQ+/3o3QksEyqGBMQWf?=
 =?us-ascii?Q?nXWgwUhnM6ryiZT8RMSnfTSuwdl1Nix+FY8M86W6rZm3VoGw2Qy6P5TQmy/u?=
 =?us-ascii?Q?9yIxqfdfYjHL5dXYUSv09vo+fPtUcB59/G6F4iOtkS4Do9KTjQj1OALmJ0w4?=
 =?us-ascii?Q?FkX9uqy4BqjzP4htK9dGTZl2p2DYWR2LEteDQMxGAb4bOQwkK/aTWHdR5TYl?=
 =?us-ascii?Q?5tjqQ/ik6WiA1/qexfNHTZJUUFmgDHqQE6vo2PSHT0iTl7653NDrp9CdHCzv?=
 =?us-ascii?Q?DaU1z/GGouhugWtD7zRAbpSav646MT7IATCSTFeD6hODndwoiJ3HZUvHIJsQ?=
 =?us-ascii?Q?PBFC2pJ7AyQTFT92cu1HIXtMCvrbtHcV9CB6ru691leRShfE7Gz4aH49/c5i?=
 =?us-ascii?Q?dyflgo/8KzMssNKmvQK8hb4GU2SdbsTGw+BwkXGluwNgL6/RDCVxWV+7wip+?=
 =?us-ascii?Q?tp1nbEgJsEqAAWjp1RGwYyeF14YTTzpHTyDFL42S+VA8Axt1rBhis3Wzz5l8?=
 =?us-ascii?Q?13UDQDvT+Zqa3mJSL+BratjpZD0JXvhXXcKXJzX5jZRmet4I2MH8Bdv8p6+i?=
 =?us-ascii?Q?4kGhwvLaF0eMOWuRgoXRQxdDpPP4kYRbUK/2WnuewsPYiXnuUiltM9qExRcI?=
 =?us-ascii?Q?5EFAS31uk0atuClM4CG1F2edyS6mZoJ89Pqb1+20J9n91RtXDsALHyLeWeGa?=
 =?us-ascii?Q?d4QCcwN6MH5X4efp97AMvyeYgQ9jQoPer+dU3dKm38RKcNOhC8g7ZhT33kUS?=
 =?us-ascii?Q?uvv/UGi3a4cuNVoz5U5sTELsiWTicl97uk9J9CUINYQTZwMMI5MRalQCUpRU?=
 =?us-ascii?Q?wOu0Ne7IwF3eKEFy9Vg/qgS76Kg+AM1w98Wkm2Wnz926VfzYJn/kIgh8QbLP?=
 =?us-ascii?Q?QrI9Ks4HZa43Rus5tK4dRBXH/MLKPnv80tO1tXMDHyKA7c9BzpwjTE78K0Ko?=
 =?us-ascii?Q?tQFNP52uBga7SF4hTbxNCQUQRMOFvxcxqgIr2yl7WdYizMh0eer7L7rnMzO1?=
 =?us-ascii?Q?hxIqWXES/yki72cqVHLNHzXt1JdIXqS/FjeBNP7qDyWP1thWRUd9wlVbh+b+?=
 =?us-ascii?Q?DT70v8cwrkLt9EnVyNVou5/Gg1TbDXkfWEOqMuudQb+zOLUEZTXT3yPTPjow?=
 =?us-ascii?Q?LzZ0FXdpFrV23FcI62h1EHXvdrdeskv6qf/54el/76ZhssMnHqJgYL5mBOkg?=
 =?us-ascii?Q?cweXPoagjKzQ2u6p6vQLL5jcTO2EN+KDA3NwG0Ml5SOUlB+QyREltmN6D1yX?=
X-MS-Exchange-AntiSpam-MessageData-1: Rdjrla1aPWcwICNOluqtv/XsVppDmZMAWZE=
X-Exchange-RoutingPolicyChecked:
	WEf02hV1rNz4P22kcPfvg4OvJVeTPzt6WSyDluHjc8yu/v6IquuO22ReFlM7JH69+x/f3IxA6aHRPSsLB9a3dTCXkgrtAKdnoY5951Sc1Rfg/Iyn2HBYFnb07OOkB56Ji7A0QxD9GGyywoxFdgFiySy+wSCQIgpzq9biQ6PvgkuzJ1bjQgAeDvnxX/DJg91f/yMfuHchkRTNVyj7cTwDn0l4NjuaAOScj7Ko7WrCWMtX+T3w5dhA/QM4xid6lbwsKKOek5hKdjhD1Yy4DwEQCCZPSEIHIKL7ZK7tsv6m2QczKWLTaAnOdPV+mRaR/kAcOvSSj9cWjRbVRLC6LADoVA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b+wQQNJU8zDZ2PUkKE6RM85/tiyZX+HkJANwxLsnZT7/k6gTzlJ4dI76l5tv7kAVq7+zdH0R9XkYW4IqQ490RQe3fZOaaJsEnnQUiJpTUG3T42fNc5fWSZ29lpRxbWaO13p1Udh4TR022dleMyJewnhL39SkLMRxiOdI/7j7o6MOsWg7rN+R8mo9+aGVBxFmq+vdwAURJJJuKZiWXynG8tamYaXIL0JSP/Rn00WI5jsboq16Sn6fKR5PdF+6wnM/JyPoMenoDw1OJOkGdfk6crIPr6bboJY5rtXyA+uOYx83lzpvTidrKMmp5TqAC9PEYeVkd7oM4f/GYsS8PA6ewLAVegxyBFVhOl3ZE6YGMLZvnjEkNQWff6wVuS3K+mmxEkk9e4lXGENebcapCrligyqeYxgB6b//B+1X3+lCZ3k8bhJEV92IkpMi6VHBnEbfZxuErI/xnWq/lN8Wnw9VoFYY1sMg9c/+TAdiOfWry95ACqSmCKxsQ4rwaQ9UzlASEKpJjr5rIVy+p9xCXma9UKwQeZbk5K6BnoMM0q2yYvBDs8InlhGTg71wHDWQqjZrj5BjaunmAS/833eVBHifO6czwssNJQifB719j2Q9j8y/cx4Xl/GIpYObu7hnd13b
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f833c26-163a-482f-9bfc-08df4bc12ddf
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 13:28:38.1718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mseWsO2zg+g+CpovE1WUiBg0hR6X3FvFnGi7dkiZaHWBMqE3NYWSpONtg2QBI6r/n9eVBnkjn1ZjbcEl+sETc6FUBp+iP+pCsBGaTvMcUGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9155

Rework data placement on zoned devices. Currently zoned BTRFS ignores
the write hint passed to the extent allocator and always picks the first
block-group in the active_bgs list as extent allocation target.

This causes high fragmentation, which then in turn causes high demands
for garbage collection due to the append only nature of zoned block
devices. As the fragmentation is high garbage collection cannot reset
a full zone when one hughe file is overwritten, but has to evacuate data
that is still referenced by other files first, before performing a zone
reset.

Mimic what XFS on zoned realtime devices does for this setup: As long as
we can still allocate new zones from the underlying devices, allocate a
new block-group and place, the new file there. For extent-allocations of
already existing files, remember the last allocation of this inode and
use it as a hint for the extent allocator. If two allocations race for
the same block-group, retry to see if another block-group can be chosen.

Test setup
----------

QEMU VM (virtme-ng), 8 vCPUs, 8 GiB RAM, base btrfs for-next 98768e7ccd0f
with and without the series. Each test runs 3 times per kernel on a
freshly created filesystem (mkfs.btrfs -d single -m single) on a memory
backed zoned null_blk device:

  memory_backed=1 blocksize=4096 size=4096 (MiB) zoned=1 zone_size=64 (MiB)
  zone_nr_conv=0 zone_max_active=12

btrfs uses 10 of the 12 active zones for data. Writes are done with
xfs_io pwrite in 1 MiB blocks, buffered writes are followed by fsync.

Workloads:

- Interleaved appends: 4 files are appended round-robin in 1 MiB steps,
  each step followed by fsync, until every file is 192 MiB (3 zones).
- Parallel writers: 5 writers start at the same time and each write a
  new 128 MiB file (2 zones).
- More writers than active zones: 20 writers start at the same time and
  each write a new 64 MiB file (1 zone).
- Fill to ENOSPC: 8 O_DIRECT writers write until the filesystem is full.
- GC churn: 5 writers create 6 files each (16-96 MiB, 1.5 GiB total).
  Then, in 8 rounds, every writer picks 2 of its files and either deletes
  and re-creates it with a new size, overwrites it completely, or
  overwrites 25% of it in random 1 MiB pieces. The sequence of operations
  is generated from a fixed seed, so both kernels run the same sequence
  (about 5 GiB of writes in total). There is one sync per round instead
  of fsync per write. GC is the regular zoned reclaim with default
  thresholds; the counters are read after reclaim has settled.

Metrics:

- files/zone: number of files with data in a data block-group, averaged
  over all data block-groups used (1.0 = no sharing).
- extents/file: extents per file as reported by FIEMAP.
- GC copied: bytes relocated by zoned reclaim
  (/sys/fs/btrfs/<uuid>/allocation/data/reclaim_bytes).
- zones freed without copying: data block-groups removed without being
  relocated first.

Results (mean of 3 runs)
------------------------

Workload                              files/zone      extents/file
                                      base -> series  base -> series
------------------------------------  --------------  ----------------
Interleaved appends
  buffered                             4.00 -> 1.00     192 -> 3
  O_DIRECT                             4.00 -> 1.00     192 -> 3
5 parallel writers
  buffered                             4.42 -> 1.48      41 -> 6
  O_DIRECT                             5.00 -> 1.00     964 -> 2
20 parallel writers (2x active zones)
  buffered                            16.98 -> 4.47      53 -> 44
  O_DIRECT                            19.60 -> 5.25     503 -> 244
Fill to ENOSPC, O_DIRECT               8.00 -> 2.35    3920 -> 1261

                                      GC copied        zones freed
                                      base -> series   w/o copying
------------------------------------  ---------------  --------------
GC churn, buffered                    261 -> 4 MiB     17 -> 36
GC churn, O_DIRECT                     70 -> 0 MiB     16 -> 35

Further numbers:

- 5 parallel O_DIRECT writers: every file has its own zones in all runs
  (at most 1 file per zone, base: 5).
- 20 parallel writers: above the active zone limit allocations are spread
  round-robin over the active block-groups; at most 6-10 files per zone
  instead of 20.
- Fill to ENOSPC: the filesystem fills to 92% of the device size with and
  without the series.
- GC churn per run: base copies 45-677 MiB (buffered) and 49-100 MiB
  (O_DIRECT), the series 0-12 MiB and 0 MiB. GC write amplification
  ((written + copied) / written) goes from 1.008-1.129 to 1.000-1.002.
- The series doesn't use more data block-groups for the streaming
  workloads; with more writers than active zones it uses 1-4 more
  (24-25 instead of 21-25).

Performance changes (all numbers in MB/s):

Workload                  write                parallel read          single reader
------------------------  -------------------  ---------------------  --------------------
 5 writers, O_DIRECT      1660 -> 1981 (+19%)  10335 -> 11996 (+16%)  4077 -> 5691 (+40%)
20 writers, O_DIRECT      2346 -> 2928 (+25%)  12584 -> 12920  (+3%)  4561 -> 5283 (+16%)
 5 writers, buffered       643 ->  628  (-2%)  13165 -> 13091  (-1%)  5353 -> 5168  (-3%)
20 writers, buffered       842 ->  831  (-1%)  14507 -> 14620  (+1%)  6240 -> 6370  (+2%)


Johannes Thumshirn (5):
  btrfs: zoned: search for hinted block-group in
    prepare_allocation_zoned
  btrfs: zoned: save last allocation as placement hint
  btrfs: zoned: allocate a new block-group per file
  btrfs: zoned: try to fill hinted block-groups
  btrfs: zoned: break concurrent chunk allocation race

 fs/btrfs/btrfs_inode.h       |  2 +
 fs/btrfs/extent-tree.c       | 85 +++++++++++++++++++++++++++++++++---
 fs/btrfs/extent-tree.h       |  8 ++++
 fs/btrfs/inode.c             |  5 +++
 fs/btrfs/ordered-data.c      |  7 ++-
 fs/btrfs/zoned.c             | 31 +++++++++++++
 fs/btrfs/zoned.h             |  7 +++
 include/trace/events/btrfs.h | 33 ++++++++++++++
 8 files changed, 170 insertions(+), 8 deletions(-)

-- 
2.56.1

