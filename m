Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794298235;
	b=17qoFAvBlmWoVfnpB/yJhiL1IONknC/iszAV9CyAVH3cxNdOKlzVwXn/j+OPrNbEibcm
	 dWSkZtRU9XXf3/3CRUAIyHHNsUo2ZUxgthD2s36U0QbVrlzr3RZb/kh1SZW09I2ZKsikK
	 ITcHU/SGdGgNTXo61Em6oRSsql4Y05RiLaDvf7KU598C5BSJNvo5ksWkc9bxcrk/eoibQ
	 UdOEPmAJqPWS+i9L1VjKcZreU76R/YwKGf7eNzkPjHDliTIquTahpRqDWhMfy73gf8op/
	 7v6Nt4bSC1i0AmKKq+qNnfxs1Sjd4uVZQD2qNSA5s1OBwlvZT9jmCDP2zMcppsxhXLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794298235;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
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
	bh=cJlhEb1IIIxbgL1jwtsdbwZa1cfUQCRlS5U83x1+ktc=;
	b=mkZ1qBQqcQ7dxlb2CsqLwAsJ9rGnuHAR/r43HYSkcrV5bBy7dklbWUbb6hqPxo+46S6s
	 9S6fIFW6EunQGm2wU+fuISzmuH4La11AX9wLpzE73jmNIVmldcBjJyURFHJoFHCoXrHT0
	 Vc9QCGXb+iErm6XiduoIFy65J4c07Q7ySj/pe5GkSacuJk3NBti9thIG+MctBFjTXVxzt
	 kgDmWpH9Uk8esp/xMthnceMcO6yPAWEp7QN7i716sFQT5NtvsYsZpTlk16f+5Qn12ey2f
	 8HE9DlU5jplVZGByKM+Ia9pdJyBcPFrRCMk7ZnW+lrZIxyTUK9ugJ11KavSqYmMUWPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=r10SRJZP;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hSWFgpj4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A0606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 08:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B88A0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=r10SRJZP;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hSWFgpj4
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794298234; x=1825834234;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=GPcVSVBeFeL6xXGgdvIAFK3gpcacBOS16zjianatXZQ=;
  b=r10SRJZP9IKm5wtyWSOZ3A3Zv9km/oF4ZiH6H9g2ZuKzoRbTrJjCf3XS
   fBPk5UA/SxUrTZt2l5FmSa+ij9ucxf5n3tLl4RhvItZcH7CaYkQFhRRdg
   9SFwZw/6Mtl0rSDXDa4ebOLjodYRCtkNFYA37Vp2zBBShMnOAIBZRKZIT
   LxNmt56lSlSJuK2NHoG8NLmYeEGZgAVZa+XMbz9kvj5qOG9niWmCw52uG
   STAq1HT/M2L1ik3hvQNLT2FMYa8UAhEaVYdj3/oRFgnQHJ7vmKYSizUOI
   oZA/G89HN19iUDT54P1ljFDQfhKGmT9rRKzTtjDnRcj9ZTxLs2Sy7hDYo
   g==;
X-CSE-ConnectionGUID: dQmorzA+Teu7Zz3owfSMYg==
X-CSE-MsgGUID: zIUAkZipT9qZrZDJm1iq1Q==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="159527789"
Received: from mail-southcentralusazon11011008.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 16:10:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v8edOnTXDMtDKPyA7qQdKZCe1yqQcugOAwYrEACNHkricTqX8rk1LgJR2+5/DbA5a0r+AEkEYvI7J5OQ/RQigzAV5v0ErbWzJ8yJYC9eRgF3xKxIh0tv+YCjTE0T3KKDYYapcuVj1mDsCeuiBoyDxrYLtaiKtpSj+IIdeczemrWuYwCMjwMmBl53gtR6jOGBdqS3S3c4Xxs81OsNdroWSxeoQ4BwVHJZ3Ju4ZqNLpoeZM6CIxFstBlVkaw0BiCnXayIbra5gR9YC1po/ObcDp2s21cfWDDbmJvsANf7T6rklibtoMyFkstlFo1B4L2Blr9pvukCv7CmSerYvT3gwog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJlhEb1IIIxbgL1jwtsdbwZa1cfUQCRlS5U83x1+ktc=;
 b=GPoA+kkLTUQyRFiCKKueii8/UtILEmIkKElHTKyfQI+2MT2N9wVZa9/1uXxOpkmXkVfZSWdLZMA5PE6rB+yy9dvllLkYTw6Q93srJM2yZBHyjWswZgWGDiPcnPB9OH2mr7aT4rm1zdf4SSkeOvpMCk+4l6rhrubnP4R5caRDXOk5ijstLQK/ufHrRsHJeBw+rbIzb/iZ/gEGC947BN+/eTmZjRzeYz/ci96+kqax8aMuYBedzdtt1pKl2/zPBB08I73eYFGcWvUCzoecE+bfxMkxr3WImXi5300v/88DsHeCE4Ub0v1bFcS31HWVz7Ktv/ftHMFm6tsuRCt7AgE7VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJlhEb1IIIxbgL1jwtsdbwZa1cfUQCRlS5U83x1+ktc=;
 b=hSWFgpj4J3lnbSP9GP/T1veu1bw1CCUhjFTeIBreOQbOeTA6MusrsqDgYB4kSxWZy8FfWvwdZFCEYgl0vL1WX56JgCMQ6D6g1k7dZZNaVm9EuloliFQV81ymTMNP2tlc9EkANfJK2QwS+2Ql2lQdRsqcECWU+tI+464hqCe+RC4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB7813.namprd04.prod.outlook.com (2603:10b6:8:26::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 08:09:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Tue, 10 Nov 2026
 08:09:58 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Jochen Philipp <a2jphilipp@gmail.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3] btrfs: zoned: don't release active zone reservations for conventional zones
Date: Tue, 10 Nov 2026 09:09:32 +0100
Message-ID: <20261110080932.1205332-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0117.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB7813:EE_
X-MS-Office365-Filtering-Correlation-Id: 90015237-6ca5-4956-8725-08df3f0202f7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|10070799003|376014|1800799024|23010399003|11063799006|56012099006|18002099003|10067099003|261009223027099003|261102123227099003|261026140227099003|261021123027099003|261021121427099003|261022105027099003|261028144727099003|4133799003;
X-Microsoft-Antispam-Message-Info:
	w8RK/+YMsK6BIsvWn62P39LTNhd+QcOsvuUTfWC7gVDEHo9QwHApiwXM9XnFlZvI+0uKVc30ERFapdJVrkCLjjLtB10BNa47IF/zCgkMCvkYi+4iDbBuv9C6HH96HuqSgiTFriYG8WbsuWfMxJ3RK44+2qwZJycX0x8cr07rDclLQpKkicGqDr7R71Sy3mTfWb75G9sGFcntAa3758Nn0jc6G0soNeeaikT/Jczm052iwUWqVLrMZHC1uWged+jaNhQX1Zj++qColI1pYjpTIbyuyoBohhti8+X6Pp/kX6wuuuaCU1L7pELQRRtI+U5haNCS2kml8/T2AlRs+WOcHidj8EV852HCDcNFgxfn4bwuopgOs4noPjIhsles/Jv5/DwHPlDjTLxO33+HGxVafN/J0Z5V+kydPOL5ogX2uzTkYydX6vtd3y39Ootry/m1j8wcUqeVWEPXf78ZR8LM5FRbyEaEO/wQ8Pvdv1bbwejGavl3XJPeF6v6P5sObHkkPA5HIrmBU1H7qw1PhrLPXRscWWV67x678WOk3d48pXQ5LLW3U/Hp5UOvB/ezrqByInDbK0waY/tIHtwf5siKNXPe2CegNssDoKn8DzgmthA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(10070799003)(376014)(1800799024)(23010399003)(11063799006)(56012099006)(18002099003)(10067099003)(261009223027099003)(261102123227099003)(261026140227099003)(261021123027099003)(261021121427099003)(261022105027099003)(261028144727099003)(4133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2exLPWj6fbcCJjOH1mg02I5wiGxZi5ykwdQT/gjAuY0nMYx1vJQDSIz+THgq?=
 =?us-ascii?Q?w0uaTvHPGRaZjVP3ZGnY92IFD/OH+1i5+ASbjquntfI36kByI+RCFUCAWqGz?=
 =?us-ascii?Q?C6TY6Fj39L2fc7x0mqkjSPBu6D9vYxzzsfhf+NX0QVpXqVwLqVu5PFX9tByD?=
 =?us-ascii?Q?5yCpxtCMgUMpFZ+EETT97IZ2ogsY64QyMU/UyfQ995Liv/9RoV8AUP6EEPvo?=
 =?us-ascii?Q?t1yYUXm5nnqhuKMJSGzcrcxPvPKgp5weZvdubqM1lxb4g0RVR5zl9NSN4UTy?=
 =?us-ascii?Q?Vz+u1juhb/ueWfnYE+IR2m9mayg6d5FsMw17KHiqQPPAmVKYwmYd1OCZeKg0?=
 =?us-ascii?Q?AhbECTUnWy/h7DKo8zhbURIJTAx5zRwNlll0vouJzkDeL5Q4P8yPdgzm55VP?=
 =?us-ascii?Q?zQXyAmHPNhtEXSemyY23xx0eRJey4UmM3OIreqAwtN+655UHerpfeMBxtblq?=
 =?us-ascii?Q?m3CYB+/gRJM17NmUmk/3eTeWnsPueMdESo31flOOjta3kuUNLYKVnyYEpqVh?=
 =?us-ascii?Q?xCbW5Q0Oeup73YpH/KDWo7pnazE3A1Rb9LLCq2aHBnOPWxcmJ2pnGt3mR56Z?=
 =?us-ascii?Q?FNDOas6MJO3Sj2au4QANRO2qctEDCUC7Q+bCjuzCFegVqwaf8gNx7yzb7vyl?=
 =?us-ascii?Q?U1rNDyYlwATzwJTL5zuvp8N7m+jy4cRkHxSlRZJQ6WpidZ2g+/O6qR6TUBfJ?=
 =?us-ascii?Q?7oN+esm8ZNXtzSCmT+WM7QZ1w6+SE5Bag/AqzBJXI2isUBhsrhKyoKIyurBd?=
 =?us-ascii?Q?PzI0PhdPkFFLCI85gN7X0WXcdhAYZ1kSx72hdhHeywhFCRDgm06ZpmA0WEAe?=
 =?us-ascii?Q?R9v2X61bOaI2hS5exz3TmUTMK701dM3WOd532bOwjvIf+T8QvqMBhhpGyHsb?=
 =?us-ascii?Q?L6afoq+P8c7YcaE1SN2CtfhKr88QsWXUBizgxWRS/rSdSeTqYUtGiLg4P/ra?=
 =?us-ascii?Q?B2MVT56Vj5Io4tob9k1p3BfnORr8LcCaksT2+3mWNVk4kSUPibgf6wVltDS6?=
 =?us-ascii?Q?YTifVidtkGl0fd+8V5/6YJVHV5WXIFVP8h8YrBpdFyblAlwoOYp9FVhtObat?=
 =?us-ascii?Q?c6l2o5jS0CAPan/ncFjq9PFPHXZaxwhY8DL2ItUi2jxGXB+4GUKoMcjgiivC?=
 =?us-ascii?Q?h/teXv3/tj/YJLsnHYYQtxHN+3sosL8gduIn1JQ81Rmx7k7P1Gwx467EuJQR?=
 =?us-ascii?Q?BxTxkVCFsx+4iXT4yQphXke3SgJxvuILTC7Ut+HDNkTIOhKJcjx+jTZeZHr3?=
 =?us-ascii?Q?D3SQB8n3O37GbdshP2JmgT6omGyP+F0sstTcotxd+r3uETuY8bgeYEoHnjM2?=
 =?us-ascii?Q?Adw6xdP9FYYCR4guhmgrhYgzRdZE6TYoZ9YAGJ8zQip3zDpWoxCT/WscRiHB?=
 =?us-ascii?Q?kHNNxpqqnT/Df071w7kbe4Ggc17CG4XVPj3OBBKwFbOtzl89mqWg3p2dJkMa?=
 =?us-ascii?Q?BkeS5u7puXIGMHGtolk9SkveNn8j/f/EEDKowZCQiCn4qe5fmU0d9Tg9/cDC?=
 =?us-ascii?Q?tfnVH94bI1+nwSZqNbcWQN17H08HABrMcBtwiz3Iw+vtxnaE8IlZAdNiqp3S?=
 =?us-ascii?Q?YnBeknRnm8FijqH4vWEG2SDEYM4QrlvwNCvnvqNRpCeVbaA0nGoT9FNzX+Eh?=
 =?us-ascii?Q?LReoo0BALs+d0ADwbMAmpEY1kj34nfIaOCc4TLtI+rVCggasi8mZlMAxSVXn?=
 =?us-ascii?Q?EMPFoe0eFk1GJ5Gw7Jzqk7VvqtQnOvA6hwlIFeYpoTmQebNsGshfRVXGZwIr?=
 =?us-ascii?Q?VvBuBcQME1BD7z2jh9WmfinTKW5tLrqknwJj2P1hhDSCTIXkC+z6Rdqg7W0i?=
X-MS-Exchange-AntiSpam-MessageData-1: RR4JvHNNxDrjcnz6Br+3eYk/7yyiTv6gzzA=
X-Exchange-RoutingPolicyChecked:
	FiYTe5Dyev8MCPW2t+js87iWb2n/yq4/cO+gUm/YUreKo9PKoVgRE7VLDLZSxx5XFl+g8b3KgIW0Fd8PoKDP/hjRbpHJ8tKhaS0Rh6cdal3apjpvD8Nq91LFhMhobtL1vtIcUudp4eb4rXA9fUbnGlpogTDuE8jBSwCI4fA2Jlbr/LUlKjQghxHZuvNFisoPBjSv57ycvCSAjwoFo/KxPV3IKO2cUhcbUk5DfQWhlIKlguVaP99twwq/dQ2PJ/MLCWGWDU4QQ5vMznCsEsgjpOmk/RyQS1ol1Gd9h6vES0URRiiPwUy1MwEGE2xpAfZ0piFLGg2ZzmJZXjRJSpPLBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/e5mm0x78GZhlIkeA2446lHA3URkoO54E/tNhc/S/hCcjjKq8eVyCXa70S0C0wSCq9r8mRk8wTSZXbnAugfpyqyc57U+Qk5Ml5zKavpHwklS7LCNOa3nbzloRIEjTdHyhX2jx4bg15Z3sbm8h4y2eka5xjQ78oi7wZFsatpDoJCU1QLy9wqHDxRWU28O2w+BmzQyaqAzPSYS6v30myud9YrAeo1yF6BrjnD+b2agulLVZYlkUdt5eTwIRoQknDmD4Sr7mMZfTMVecD4I/YSuWr8DyKVndVCAX62OyY1p0QlWwxqbw89cNzv6AOamrdw2qA0PjXBk36yqtgzyP03PYAFh4d0E4GTiyPwxdzxXm4qujJoTork/t1dt4MzZF5TpYjE0xAeKopO7qJ7igtqtTEji3KWy2mj+Ds9jD5ZD6WzLhrNNQrRkgzBAqywzOF9rZl2TixnWvoeSCZ+h6cjXEtcEwgvRCCUb6E7UUFIl7dcOJ4QspJU/smec/6+w5MvGBYStk4v9xNrzvBB6Bni4Y2VT1EAb8A3Hl81tjaWWMrCW4oUekXDE4QvGPh6Hgut7fZn0dzygub09QAtdG06KPghrIjJSydVDoz3+tMJTNSewjTVr169ivo3T/qZ99w+D
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90015237-6ca5-4956-8725-08df3f0202f7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 08:09:58.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0nQZ+mfRKauORRip69t4z4LHpX8bDbEjgQq8QunSiGSYFSWPxpQ7HbeRObUehxexCMey7mBmEB50Qr6t58I8pXFMfv9Ip7j4cgoF1x7VAMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7813

On mount, btrfs_check_active_zone_reservation() releases a reserved
active zone for each stripe of an active metadata or system block-group.
Stripes on conventional zones usually hold no active zone on the device,
so they use up the reservation. Once metadata moves to a sequential
block-group, its activation fails and the transaction commit aborts
with -EAGAIN.

Only release reservations for stripes holding an active zone, matching
what finishing the zone gives back.

Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Reported-by: Jochen Philipp <a2jphilipp@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com/
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v2:
- Only decrement reservation for zones marked as active (Shashiko) 

 fs/btrfs/zoned.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3192b86669b9..81489fa4a42d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3115,8 +3115,15 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_zoned_device_info *zinfo = map->stripes[i].dev->zone_info;
+			u64 physical = map->stripes[i].physical;
+
+			if (!test_bit(physical >> zinfo->zone_size_shift, zinfo->active_zones))
+				continue;
+
+			zinfo->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
-- 
2.56.0

