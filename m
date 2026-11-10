Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794304795;
	b=rpH7lbDjINm3Fwa/diRdm6OFz6OkPiN+ns8Y62nUBRGeOL9fG1WhnbBMnxB8t8ioDVbn
	 0yw/wd3DJVVzXkCZgP4nvhEotlknXUtzYPa5+NgBMj5yu070gsMpdkXCpbbXA8BAKkVfh
	 crqeRO9KgfYOP5HYJ2KLYN5gqv5gZQl8KtBHbyziHmDhFLoAU+7PJ265s7JlPo3QJiinW
	 D96fwt/ninNwFtZevFo+t1WXKt96M44hDlUtxnSHJLCnf93YMFc2UBsk1lCCxSbnN3VET
	 lXroMHEXv6aek+Nu0x/XMuQjA158w5q+9N+p9yUOfLNzExhNe4UlrJqy0/8CVYuo3hA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304795;
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
	bh=ZbxD0n3NzE77ixQtSTgF0SF76bSPx3FdCgD3gLeGDIs=;
	b=YqG3/SvF00NgLYQmcQj3Wkx+2wn3qr0p6drFasJLd/HVgaGEIdDt++o29w9SFV6cpQMn
	 kINzbCZYpnLYGOq+YdSyH485CHsDlo7F+smVP2HBZgsydiYOsthRmPcB0N2PP49Yt5Fwx
	 CtSNEFaALKAlaE/rHQH3rfkONTmnq9LAA74i9P8vpGMCaFV5RjaX2wPbfznig2aCvwPSC
	 Wm0LVpUqgBJMA9vO9qoMnQSSzi7M362a3SSDx7Mm3IinCZOptrnhU71+2qCALCWs41swc
	 3BJ+zifRTl2nAp6QqzSVN/6ylaNQIOkyiDCrGh/y5vzag6vUNhpUfc+jqyPKA/0aJWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=P7VZBFF6;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ctUxYy23;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D15A60A380B;
	Tue, 10 Nov 2026 09:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D15A60A380B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=P7VZBFF6;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ctUxYy23
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794304801; x=1825840801;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=THltjYHXV/tjAM1usySTk38HKFSZ7rzu2hrtptLuxiE=;
  b=P7VZBFF6kIr4dMb9k/iwmuKnRI1XSksk+3EhdSB5gn/nrC/EyaDOehNi
   UPTZ3eRasISw4m4VfLDqo5HIUDeFuUevoVv5PQLBudh9m5+PtvT/5331b
   s9xqOPZFE4wpxPaR4kKthlkhtEWxO8I/TVGHO3/BTAXF0LBYvhsF9RnDA
   3ST+SKMNCOMsRljwpErhPItGNlfZJU14dwGhHCz0nt3ALg0J11Cfze/FF
   W6Rr1WFb44PHa1nx0FiiJ01ESbcHbg9VsrroAV7s9Bw9Q74dMk+v3SJbw
   OgeB13gO3Oai+Q+qwRo6Cp1iQQwYdSTo6JY6+pSjsYvozK+HMT8ToDqt6
   A==;
X-CSE-ConnectionGUID: IIA5rFnnThagCSrYX8cMiQ==
X-CSE-MsgGUID: KK4ktS5IT/qKbZVAVMJ0oQ==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="159534236"
Received: from mail-southcentralusazon11012033.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 18:00:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a3nKqh/LFKcMBD4z5pPDCoe8eJkqm/Fa4MAmFrJfZ6hmqEVn2UobEgjvo3zHiAJmR80HwhGO7ltKCH86JkPNFjH5MxowYFtryVp+iwsUjzz2YR32jvIw4BkZ+P1croOoj6aligOIoyTsoHfk/9v6hXP4FoSvBspAOoZ8K7RULki5DjssrGJv1XmDMUEfuZLDSvbsSHsEugt+0szkWgL00UpwRm4wFYQvup1Sfugej925ufe8EmUDqqOrqvNQNv+oKrpO4Kr3pCz5HvjiU7s195yrEXc4Xsn4ZRgumHG9GIOc9JDRU44f0iveu1l59E8QMNB9CpfX9c7Rin7DuAeevw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbxD0n3NzE77ixQtSTgF0SF76bSPx3FdCgD3gLeGDIs=;
 b=yvs+DV6xcOqvTDMAHrLWWt4OpiFr3Y8UWjAtESlYhNHz665NYDxZ98jvQxrW7tt6RqqgpRziLhpN73+1PKoPRUiawN3IKa9mv5ynAVkAHUN02tMqSAhTze/AWghzeLhfI27CH3C8Ve6PpWRBBL4SueVxlHtCA3rZ3T5hf90YAv0K6rJRI0My5Kw5denCQDbvC2x8ZAk+eeDvHLfTRTEeih9m9eCysxU3onSdlEQzpTEmKP7h/0e/Muyp7AZwayY3vYltg4j5HWDPMqwnxc2XddNUUuvQ6qzY9cSUv47ZqfAQGPVy4BYhMaOuG2wAKZe+j2Jhu597Ix5MKB4KR6dysQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbxD0n3NzE77ixQtSTgF0SF76bSPx3FdCgD3gLeGDIs=;
 b=ctUxYy23RZjnZboDE7Cd6INL64mfRKr2tlVri+qagQdaR5kwxrv/diFsmnO1nfW7zdJG9vmF4oYfdEDFj4JadnqR5/ql9zdODEd/cdQb+ED/t1lq2iQdfy5D/ir1NGgsy73tCm2Ig7U/gpggVN0ptcEupSFRjOSeBAE74jUNXoE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB7697.namprd04.prod.outlook.com (2603:10b6:303:a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 09:59:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Tue, 10 Nov 2026
 09:59:51 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: test that fsync on zoned doesn't fail with -EAGAIN
Date: Tue, 10 Nov 2026 10:59:11 +0100
Message-ID: <20261110095911.2013053-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0371.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: eda59316-c606-4dcc-2455-08df3f115cf2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|23010399003|19092799006|11063799006|56012099006|261022113327099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261026121527099003|10067099003|261026140227099003|261028144727099003|261102123227099003|261009223027099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	0O9c/wzMhedq8Sv10TlFDfGSEnZypFc6bsp8emq99PHSO3dJIz+UNk3ayRDwiXam9zm0RUguGb/r2G4kO5m5pKlQdba/CFXXIStp9VYEPCIR3oelvVRzeu/4oN/kFkJEf8m8Og5ybGKr/x0c6FURwu3XHjpNfNOABziSknyfLfvfwFAnYF/qlFrhhM2TyYPHAohhTQdNwoyLrNwnphjVt/89Ok8dIKozUQz8pnTco4XvbxVxuH4np71bJbP4kbzeBxgWECHiBRmMfKLO4gZk+4TloNNdAabpEli8JCWuYDEikc+QgWlxMI0/bzvU17FpI6T+1smS9GM3bfUbOaZdWeZlg7qadHcl+r6fr9KfmB61xE3px0uXxfNKkOsFcCwudZlA6KPt1NA6ZcJRVhVISBOF8sxNG7fW6TFXWhYLL/9ZLQzWZbQQZ4hQRLEVVrYmu7cdvxP2LqFtfVYRzXUA8YdiJ3YgaOK+zJyArKTOi9K6xqJOm/jHio3YI9MNWw4VAZsi7eEKrnk7wcL0Ucycd/grl9MmIud9ATIx10e31k66HDFwZHG30YrAmx67hyZJp+XbfAI/g3xqrYuRRTDejF5JUT8tVdU4NzxDNMiJtujSy+E6B8M/AUsepA1keRC6qzStkdK/ZG8PhwspP2w8SQsjAz62Mh1MLqVwNSKYSZg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(23010399003)(19092799006)(11063799006)(56012099006)(261022113327099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261026121527099003)(10067099003)(261026140227099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QTLTkjcepdLPgLZWpXeKOXeb8YOGYAjryydDPRtaA4Ac+bR1KHVhwsa+3H5C?=
 =?us-ascii?Q?ZH05CQtzuQeXN6JTWTHDD9nlCWydiHD0pnr8RjXs9gRhW5fmnCyTvDbBY5pu?=
 =?us-ascii?Q?RvaastREFiSDVNT/tI5Q6aM38iP5uRrdYdFqYi9OGXu6TGHHtTnNqFc+kWFe?=
 =?us-ascii?Q?5Bez8LdHB5HIvovEV9qHb6A06KUpKhRiDcTVtRbWxZfdCd8pYAR3ED9RSm5e?=
 =?us-ascii?Q?iqmo1ZBhcZQ6yTvYIACIJ2m5iSbHBpgpOoCJDGHsn0oP+lDHyIu9sTnUl1mW?=
 =?us-ascii?Q?zs4X6Sf64WtgYTKEF+mi9LFlCTYftjRmbsPlIVJZfmmcAAaKREev8vPX77SS?=
 =?us-ascii?Q?HhYBzI+2rrUo/tJJNADZVS54e+0yGogxP3DNeqrGPJmhz6kqwY7UvAZBVkjm?=
 =?us-ascii?Q?xEF5wZfPHIMdLto7IxWJbemxNAMiEBPXWpraPVJ8ktXlEn6ko0VfaHHZcnGo?=
 =?us-ascii?Q?DOpHxDvIcNFd55KhREx2bpx0dD6HNOvkH0aqf9NwAtDcYeTVO6dCqlw36lnI?=
 =?us-ascii?Q?iC1m8bntFdHyMoY7KpA09jGCmTLn8AkqKPaie2tFjSRY0s/eE0f2/r40rORi?=
 =?us-ascii?Q?cajiFr/6kyUqfoZSpuV+Qh+vofPu4+hjP1VmpVngnNmCElFxZ664sPVzul8C?=
 =?us-ascii?Q?YrwyF6E/Guqwdg3rdcGQp2BC/xekBvnHQZpx3io8C02j32soNe9dxzuQKMf/?=
 =?us-ascii?Q?WuJWqJEsTRg+tVVGtBP9HquJApnj6ninTQcsrzjHVSXfNINqRmjNbO3J6U5V?=
 =?us-ascii?Q?KGZqcM9hkM7y6ujc1feHlSc2WEewHjhwNvqRlJbtYNzZ4xY5GGU6qtx7FIek?=
 =?us-ascii?Q?nIBvG7JPtei04pm/ceisRqMtD7iP6ISCajalwUMc6ta99ifKrAcW8PqGN9gs?=
 =?us-ascii?Q?T3Llj5d9Fi5r9DTt+1y8ZTs2OL5xxMRJvNptoI8iSophctHjwenLyXGuzRET?=
 =?us-ascii?Q?jWB9tJJWNS4FSTdKFTIMR5bRG+9KxXchGptYZAEZQyZJGQPHBalxik6Ej1wA?=
 =?us-ascii?Q?O34aY5EuDCtNwz6+qTVXtbVDqpYQVDmYEu3m1kZmmRkUKYvn+QEWudiN7+ZS?=
 =?us-ascii?Q?c6U/iGiaXeMZ8fr7FN711JKpnyI5owq2SlvT3hzJVJ2n9xkBitlL5g6l5xxz?=
 =?us-ascii?Q?n2kisUbN0u1WXo4I0VvuAI6EuoeqHaSPjvdYh5dbH16rdkUcJ9w9L2U2BKKA?=
 =?us-ascii?Q?q2qGfrp5zoq2WOyffAaaSXTE3nEhUW336mpcewcGemo9Uaoo+LYoXwFU+HGu?=
 =?us-ascii?Q?bjECyFOqWPMK6linjVOH0IDNiEpMsxAa2r6v9ZIQUNnVwKadds81BY6/DYFt?=
 =?us-ascii?Q?l9yzR7Lhp4YUFjdNvmHMjo4fYhN1R3Y4TAK2ghwU/J8+iNF/RxopQELJjm5e?=
 =?us-ascii?Q?RER9HydBmM+r4x9/LflSMS+pQAzOV37vHUMrWLnCLZlvXIptcxs6vVSiyrhw?=
 =?us-ascii?Q?yPmNOrinO15rWNnbWFtODoNsSIGl6tTgbi15eYFSmIc4esfLhjCxUJLD+kyd?=
 =?us-ascii?Q?m0IMcZ5VUki3iq2PBbZaIyvQDtO514zPmw3A8sEFlmsmsjbvOgrzfMEomSLy?=
 =?us-ascii?Q?4TcmxqgcyMUMx8bTh6mW5GVU0720d/9SPkJCKEa5fCKGO78WVmuDbCejT3B/?=
 =?us-ascii?Q?+Vd8rK4gwlbW2/9EYf3mja2Zhye04/gLgbfgGG+RkhDJPTfl8cr47AbTKEIm?=
 =?us-ascii?Q?a5TmfhLJxHly49b0Hflol6wzz4cZ8jtEJxsIUszfZnVcczQd2DkhKd+bTzBn?=
 =?us-ascii?Q?WeBY0S20ZK/0f898gVX2Sl+F2hvSw6YI3A2bl/1oGKzfx+TbQSqAQyEpoqIO?=
X-MS-Exchange-AntiSpam-MessageData-1: HYarcM/btgSIdTeVDFTiRDjDtPRFTIPvNMo=
X-Exchange-RoutingPolicyChecked:
	z+Gqi5NILtpRCv9Gmrw1cYXRf2Qj22mFvXGhCREEsxsQfhaHP1p6cDsWDaqmJT93R7ewKkLRJ/ZTmWmiaRzTwxPCUvxF1Cr/OOchcNjxJRzbnNLdwiQ9szKhG27lzLiomq82JVNbEMpjnyxnsgt9AZsrl03SwJM0wkwqe+UI4leU/hy0rH11jZCis595gwwhMW5RLEO7GMLnLBgxR2kxJqdTVweGyPHEDQjDr9T9Rn5Ss6UxmJ2puPU+7PJcW+L4H2ccq4sRXvrBt+kZHlFi1K/KR8hFn3Z0b07h6/5BHTnhBkVPllB20Rrb9meIfQTOMMyehh02NC4rTOAsppbJaQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K4Eok/z8Cd+o8/Mw78MmNPheMSKqn3t5GxjINZdkAceSgOwExqc+kvm/UUJ1Oq+ocjTyqcm6YEM9AsQRUgSvPsN+u1hKYQWijKr/luBV4Wxhjxjfk0VY3Hrm3orhohD5jwYpbq99WU3M93905lK71ev7pKXLv5Q6xsiTFECLY45fhwcVWiX1eV0lthjyZ5r9r82v7Nc9kYA4OIaPh5OWoXOgPvIN/HLz8IkzCgjFol4+kiA0Cjsn5/2M99rbo5SEdDXx7kuD7zSIpeHvqnM70Ho7OdIea9c8ckdGQbdE5MdwpgVB5AoQLUJ9+enw6F/kHgvX4j+Koe7Tm6oAhONtdMU/P4tWT4UBdXIoxCTPZtUHdod1A1M1C8e+DsH5W/iY0yY1rTTNlhRo/WKrqhlMDBUSVMfXHzM+1utyQRkmtWvR4asNFCGFE+QHhSZKFWzwlixqpUDZ6E79zABR+xkQ2a3wWVSygOIK6/W8AIMRMeLW6BbbsBhxo+L5Z4llvlFBYygnQ64t+GTOFF1bvTX3QXyM8SII3GIfsLdaozoweuEDIyuuvDFAiumsITv4wb4y7bfGqHWRCY96jLd89zfHgUviPiq0x18p/klbnbpyZLWVulYMognRjfFmCfvBLoha
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda59316-c606-4dcc-2455-08df3f115cf2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 09:59:51.7090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JoSfcV6IZkpWgOkZqoqXCbRLbPoTTTvO/cKlBLTa+xCPqrsmnaShyc78GmgdvfxFgtQpwrOVVxOCFN6jPpWW4mx9eLlDhU8Y1zbCXlLEjMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7697

On a zoned filesystem, btrfs_start_transaction() forces a transaction
commit when the delayed refs reservation exceeds its zoned cap. If the
cap is still exceeded after the commit, it returned -EAGAIN, which
fsync passed on to user space.

Run parallel writers creating, overwriting and deleting small files with
an fsync after every write on a zoned device with a limited number of
active zones, and check that no fsync fails.

Assisted-by: LLM
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/btrfs/364     | 76 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/364.out |  2 ++
 2 files changed, 78 insertions(+)
 create mode 100755 tests/btrfs/364
 create mode 100644 tests/btrfs/364.out

diff --git a/tests/btrfs/364 b/tests/btrfs/364
new file mode 100755
index 00000000..39b0141e
--- /dev/null
+++ b/tests/btrfs/364
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 364
+#
+. ./common/preamble
+_begin_fstest auto quick zone
+
+_cleanup()
+{
+	cd /
+	[ -n "$pids" ] && kill $pids &> /dev/null
+	wait
+	rm -r -f $tmp.*
+}
+
+. ./common/zoned
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"btrfs: zoned: don't fail start_transaction() after a forced commit"
+
+_require_scratch_size $((4 * 1024 * 1024)) # kB
+_require_zoned_device "$SCRATCH_DEV"
+_require_limited_active_zones "$SCRATCH_DEV"
+
+nr_writers=$((8 * LOAD_FACTOR))
+nr_files=250
+nr_rounds=$((4 * TIME_FACTOR))
+
+_scratch_mkfs -d single -m single >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+# Every other file is deleted per round to churn data and metadata.
+writer()
+{
+	local dir=$SCRATCH_MNT/w$1
+	local r i sz
+
+	mkdir -p $dir
+	for r in $(seq $nr_rounds); do
+		for i in $(seq $nr_files); do
+			# 4K - 256K
+			sz=$(( ((i + r + $1) % 64 + 1) * 4096 ))
+			$XFS_IO_PROG -f -c "pwrite -q -S $i -b 64k 0 $sz" \
+				-c fsync $dir/$i || return 1
+		done
+		for i in $(seq 1 2 $nr_files); do
+			rm -f $dir/$i
+		done
+	done
+}
+
+pids=""
+for w in $(seq $nr_writers); do
+	writer $w > $tmp.writer.$w 2>&1 &
+	pids="$pids $!"
+done
+
+ret=0
+for p in $pids; do
+	wait $p || ret=1
+done
+unset pids
+cat $tmp.writer.* >> $seqres.full
+[ $ret -eq 0 ] || echo "writer failed, see $seqres.full"
+
+find $SCRATCH_MNT -type f | sort | xargs md5sum > $tmp.md5.before
+_scratch_cycle_mount
+find $SCRATCH_MNT -type f | sort | xargs md5sum > $tmp.md5.after
+diff -q $tmp.md5.before $tmp.md5.after > /dev/null || echo "data mismatch"
+
+echo "Silence is golden"
+
+# success, all done
+_exit 0
diff --git a/tests/btrfs/364.out b/tests/btrfs/364.out
new file mode 100644
index 00000000..6bc54ae6
--- /dev/null
+++ b/tests/btrfs/364.out
@@ -0,0 +1,2 @@
+QA output created by 364
+Silence is golden
-- 
2.56.0

