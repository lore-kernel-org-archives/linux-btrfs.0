Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793114343;
	b=vyrBOZzel5E0N4xW1JTWSKbu/emA72IfaQGwFFO+xbMgDWKpgn1p3wwqF3Cl9dGRyo0p
	 Gb5Ukfw051dUkiSCE6OWAS2PLLW+Ih5gCwipi2foXijHFnHzGY5A+3Gk+e7Q3QdfNJiuk
	 TrnQ1YvpU5PiOheNQRhDjG0rvz8jVdvfIwW3zAluJ3IMzXDTPoZIgDjvoGcizkKYpkwkt
	 Z1kiW3hKeF8uqjdL/ia3yvM1n35PuesZYlx+RZeTaWcC7p+duxo5V7maWiDtbYq7w0XZH
	 SOLWnEkcaw9kttImimudYmhVpLf3K6Novzi3LzwzuyOrm21CGggx5vn3XjiOcrlAluA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114343;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:To:Subject:Cc:
	 From:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=WT/wtDtH3hHKn/B5xvjlpEISZskE8Zeg8pp5ANdCnzk=;
	b=ERdnBCUYZH1PdghvFVnVrt05XLVkr9GgfJIyyEsGhtbUY5g6LO4weDA9UCdaKQ1S1Axx
	 ZDziPbZlXiu4X6zY0Yd/j0t2yY8Mw45F3R2g3IewQPFaCXw5NFIMNF/jkJK2kX7jSsEH+
	 FM0ge+vGEqRyYMOqR0RfJoXwjcy81IRUarKzO0Z32LYseOHLq0ayiUbTvYGEeR7jRmge4
	 uiqtA+p8GdH6nXQLJryL7Zxx+JbpBp4np9+PI5SMdcTl1CQdbol+ScqYzqZU9ApFErw8v
	 xqpWX0GzP6JksiTsFh0axAUeESBtYLsheAytfYx94tEGjbeeOO79QEsdeHulk+YMT5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LHwo0uou;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="J/CzTLya";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AF6606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 15:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8AF6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LHwo0uou;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=J/CzTLya
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793114349; x=1824650349;
  h=content-transfer-encoding:date:message-id:to:subject:cc:
   from:references:in-reply-to:mime-version;
  bh=fOjVSg5MzIPmBVpg65lBG2/RLwj8pChQ7SoeQLZxe5A=;
  b=LHwo0uou8QdokFkWs2JGse7VbCNOjQrxEvlXMgmiU6lQCFQmJ06Q6ekb
   oOiv2so+AwJbWWLVKQXVVG6aubqj8QC2v7uJfes+VUwbBdSNDbK+2nUie
   IuI9PaKLgPL/CG04uRRCZgTrm44k1fx8Uq6GMHFWnooCUi/nzXDznJ7Sv
   9h3vZDwX96AeG3V/UPf8gCs2wD5lXCRdVYX5ubna0XMGrDehLwpV/kFLv
   zBW+pupWWU6+F2WFP7008u7RS2DxxlGZ+Tt7gWtGzJjGRpbZr9CPquzCm
   VStcnWk8N1MXdp0QWYOaOUHOS0wiPpso1auolUBJM9NEOVhupG+yGfZQ8
   A==;
X-CSE-ConnectionGUID: fIA7C9a4RQKG/PF4eNUVhA==
X-CSE-MsgGUID: Tgop8FH/RcmiKdJtztINfg==
X-IronPort-AV: E=Sophos;i="6.27,181,1786982400"; 
   d="scan'208";a="160080728"
Received: from mail-northcentralusazon11010049.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 23:19:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8BxfdfuIDbk+LDXfw1cTiZ2GibnAo05bJ1Q+rclOza7Rq4ckmcRjJPxSTNuhOWdtORfiohwJCgSUYqCfHYk8H4IWJDRrTIYvAokSkUH2gSkTu6LntEmdE9JaUcFC4aI5QBz/zfu1CETT7qlsKDOIVfpSP/QgWIRJBXpkoB4cwvf+laFmK2P+u/JFPUQFvVs3Xll17qY4WY3uVDVaVsZOc8x3w4HHERTaGOBnlLwlrEXqLAs9ib76LqKKU35d+Dafmv8YryUtLFGknCXQgtAzeLcuXlurRXYnd2ERqrTOdAE0Gd4j/mzPp/x645gKfNagI0pTXJ110iFe5Gltdnzfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT/wtDtH3hHKn/B5xvjlpEISZskE8Zeg8pp5ANdCnzk=;
 b=WtUTotrtSQH4BybfvGkQvhYs+142EE0iJ1CRZHRe8ZJ5MGK1nnlIPksgBBCcuoIIhrfJEtITvBoOmU4SgKBLfGnO+GJ8QbYHMXtUqA3R65sIACaOvrgAKtqUJoeeeITNOVfHyj916fB5Xg9D7LPSUihI6qsjwlmFtWb2AmIxKd/HHBsdQO6AaCWPUw6TYbJ4fUuO2aF5RR8ZspmujZ/70UExWk+Nk/t5IaCZy9PAFrA9M8JdoWxJoP5KTDSR+O8MtggsTSdyAwyWJcTr60VIsAHo9VSDoqMsDUEjKP7QY0VSFoTvRp5ybRbrdRDF/aN7qfwEetaZShI9pmdEiPfVLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT/wtDtH3hHKn/B5xvjlpEISZskE8Zeg8pp5ANdCnzk=;
 b=J/CzTLyaglAB5DZ/SIV0FqkfSIYGAmnzAq0biS4ZFIr+kM04JA7SZMNZ8Rvp8jsi2GuhvDKrj/IEfxazs8avUNvnRbhcfNpWaLBlk5hysqUE/csktjkgetJrvvmkbIOEQbjWPq4La9NhuIkOWwjWyODk1VyTGgvQoyjdWx7libY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by MN2PR04MB7053.namprd04.prod.outlook.com (2603:10b6:208:1e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 15:18:59 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 15:18:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Oct 2026 00:18:53 +0900
Message-Id: <DMFPZCZUIEYW.H4NR8AY3DXO2@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: zoned: don't wait for ordered extents in
 do_zone_finish()
Cc: "Naohiro Aota" <naohiro.aota@wdc.com>, "David Sterba" <dsterba@suse.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
X-Mailer: aerc 0.21.0
References: <20261027143305.4001082-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261027143305.4001082-1-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TY4P301CA0090.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:37a::12) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
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
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|MN2PR04MB7053:EE_
X-MS-Office365-Filtering-Correlation-Id: 2db23e53-8f9b-4c8c-faa2-08df343d9f4b
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|376014|10070799003|1800799024|23010399003|261026140227099003|11063799006|10067099003|261026121527099003|261021121427099003|261021123027099003|261009223027099003|56012099006|261022105027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FKoXvH5w8Eoszz6uHBR3rUmKMAlfBHOPr+fYSF3POFrCZiJRzgk0XoNbdWP6PjYAUfQJWZIbmbs9bDxEF89G7Eig9bMkMQ/Msfcy1tKSxkgzsN13TVNU/EwllSKYV7/nRJErJTU/TJa83/un7qxWK3PQFBMviwFxNHad/3UAlLRpU5PX2Z0nZY8Z2jti+0We7EXlMb1MfkHdA/EUoe02qi5RZ8UnBJM1AniC0HDmbEBWOThh7wW5oJRZlSYd+eekQbHxtNRpElPCOPlAviSiPlX+CGwePI4jWsZHtEVhq1r4INfq3uGeVS5WVamV7Za7nGAk+2FFBlHo2pdu0Th7Dtz4PVqNtEGgJzAJ1WRsdKoVE0tFtcBcBQB5hYV2qH7cwFYsEvn2Yn58kaaBFmaclU8lKKvIL+4E9zfyPzzHtmUqtYRYlmzfKxoynwLYU39EPEogMtP75RG9l4DANzrgoLjA60rDcxcNa1H5udvPei+/D5PLgD48ZY0SjHoIBwvmSWJWDpPKKkh/IGtGpDXJ3ne2ZUbbG16iIQeN1DPh7k5PH4DZLYXozzS5wXl6MuxRlkguFeqaS1KUDGMOm+v3bo5qK++gJ8Ks/bX7BT3ywzLxwFy73zK/PlDZrHL2QiCIc6kdlpQiX9kaLUiD/P5fQzmTnDN/DR+yVKj5P1LItT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(376014)(10070799003)(1800799024)(23010399003)(261026140227099003)(11063799006)(10067099003)(261026121527099003)(261021121427099003)(261021123027099003)(261009223027099003)(56012099006)(261022105027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEtxd2F6U3RMaXdoNjNRTjA3aWNMZStUYkxOMWJRMlN4TU55ZG9aSFdycE5q?=
 =?utf-8?B?L0U1WEQ1ODBQakdhYmZGT1VBbVBwbDVZY0svYVhFcXlMVW80NzgyMWZmVHJw?=
 =?utf-8?B?V3ZLQmcydFA3MGROS0xGUHN4d2lhdk5oa2czZnlpbmJaL3pGLzkzUmhGbXE5?=
 =?utf-8?B?cXF4NkorVzllTWQyZmdvQ3ZNNmd3U1ZKODEvdXIrSlJNWUM5a3BWb1dDdzcy?=
 =?utf-8?B?SG1qbHBIOTU2QzA3cG9ZcWRKaE13QVk1YS80a2Z6cy8zOWlBWUh6cTFKMmlm?=
 =?utf-8?B?bUtzUkJ3L05UUTJvN29HNXFlNHQyVktSRXBZaHF4OVBSWS81SzB3TXVtVm1D?=
 =?utf-8?B?dlkyWW9BSmw5UmgwTkVwZ28xbDgxSnhJd1EzQ0JOTENheCs2TVBQRXBEbW9R?=
 =?utf-8?B?ZGw2eUpLVmVlM3ZMZjl4Vmo3QXZMWkMzN0NNamRNbnlpTkhaZngyazJiZDRZ?=
 =?utf-8?B?TmVvNTF5R0JrY1VGTFdYS013dDh1SXRPRE4zZVM5R2tWYXBDZTRCWVZGeE5L?=
 =?utf-8?B?d0lRQVovdzNUa1VIZGFCY1lsL1d1Z3JwVkMwOFhnZi82TDF0dm1yOWs5am5a?=
 =?utf-8?B?eGlpbitjclR0Kzlzd25TNHAxT0J4U09aWHFFeW9uczkzMmdabSttZVl0c3Zu?=
 =?utf-8?B?K3BERWZjaHh6Zk1aVnBrbWRpeFFjTXVMTTBpZjdqTmF2VDJzWkxMTEVKeEJJ?=
 =?utf-8?B?MUIvY2tBenVxWHlPcUxsY056L1lJZUpyMUJmaCtqMmVPZkY2c2loVWNDa1dZ?=
 =?utf-8?B?MFY4T1JPRkcraDVXKytLam9zMkdYTjAzL21YSEtON3lHcmp0NWd1ODlsYzBZ?=
 =?utf-8?B?UVgzRkF1WTZFclN2Z1ZrRzZzemdwdFc1VmZFQk1vUVlRa3ZtTTZNY0VaYTlI?=
 =?utf-8?B?ZDF5T3NndlZKVERibC9GSmVHYWdjYjNhellCb3JPQ24ya0M4NGZsdzlVMjUr?=
 =?utf-8?B?RjFKMXBPZnNESjNuTDZNTE8reFE5UmxtNjVXazVOc0RHLzhEaXVKM3RBZVlQ?=
 =?utf-8?B?U3d2bkl4bzVZTGRiTUVkbDFWa09PUzU5NEV3Ni9NcXBzMkhISDdBSk9PaDFV?=
 =?utf-8?B?ajVOV0hnNjZPdUZDejcrTCtHYTZBQzdKOTM2SnNWUzJtMXB0R04wdElIbUgz?=
 =?utf-8?B?NENRQXJvbDUrZkRBTzRvUXduMG9qaTdRTnBJOFYycGdwcGd3L1V0TkRBVzJm?=
 =?utf-8?B?eWVCZmtCUEMxMXJod1U0a3BjT2VIVnhYbVBoUDJLV0tuTUZyc1lmV3Q0STJD?=
 =?utf-8?B?aVJ0aFVrRUExUGNmeUpCZUY5MC9DdHFUN0krUmZjNWsrM3BDUFAwZFM5UEUy?=
 =?utf-8?B?R3h0Q0c1bHFUZERwUTU5VXdUbUJjNjQ0MlNjN08yNDlvbCtFZ2MyODZjRG41?=
 =?utf-8?B?UHRKdms2a2hnZVM2S1ViMDZEOENYMWxkeERCelhNMmd3SmRSTEpWU3Byc3Fp?=
 =?utf-8?B?anNqWnBPZlkrSGhLOUpEcFdGUzFBdXMvbFhiZ3lnL2hyR3V1aDZkRDZJREtT?=
 =?utf-8?B?N3BybWRZS3VSRWYvaTFPR04xdkhuK3hiRGhCUTFNb2tkajlMUk9JYzZBRGdL?=
 =?utf-8?B?Z0FNRVFhRUhZWkZxSStPOUVFUWpsaGRnS0NQR3djNEYrSTJBS2MrNWtnRGdE?=
 =?utf-8?B?MXBUUFpTNWhWMlRSektyUUJyTi9KUDliOTZsdmtOYTQzTWhVTGE1ODBhdHBp?=
 =?utf-8?B?MjAvRWE4bHVYekFZRHJ0eTlqZWZlV0Y3Nmh1cjJ6ZDg5aFZSbHR4dU1URUUv?=
 =?utf-8?B?R1hFREUwTUQ3Rit2dEREVW4zK0NLa3FOUG55aHBwMmlXSTEwMWdoWElYWGJu?=
 =?utf-8?B?RTJudXFJNHphZjhaejE2SFJqS29CeW5qTktXOCtPYjM2QWNRbno5YXZNcFlu?=
 =?utf-8?B?blhxZ0ljd3BLUHNIUzhuaC9NK1pyOGM1aDJqL1ZvMG5QblloYnQ4V3NoakNp?=
 =?utf-8?B?L0dRYnlrdVNYS0VoMEgyWXppVHYvU0pZbTlOd3NhMnpmTVcvK2tyMENBMzE2?=
 =?utf-8?B?QjRCZU52b2xLV0NkRy9mSjZzTnMwTm4wRE91TmRoRzczZlcvMTFvaFp2empK?=
 =?utf-8?B?ZXh3RjBTSEFSd1g0WnNEblNlSFJHZGpoUllqWjI1NWRtTDNuL2dqQ0RYQXIx?=
 =?utf-8?B?UGx3ZStDVUM2MFJ5UHcrWXJURVhHR0h4ak9PY0VjZmwrSDMxby8wb1Jac0FS?=
 =?utf-8?B?UlhoYlljVjBWclZOaW9ISDVhZytvc3BpeEJnZ05JNDFyVVVWTVA4OTZaZktv?=
 =?utf-8?B?UHAweGdBTGxzMjMzSTlta29tcnNXdUEzcXdFRUVtNXFadVBpQlV6UXpyOXhj?=
 =?utf-8?B?WFVhejRrTndiMVVGN05pcEdPdGg1aXBpWTc5UmZPZGV1cXlnT1VrY2FqU0w4?=
 =?utf-8?Q?9Mgo7yP93CjW0eZbnQ8UHCOO9ozP3xFlUM1uiJJ3umI4p?=
X-MS-Exchange-AntiSpam-MessageData-1: 5oXCnue7ql4B8A==
X-Exchange-RoutingPolicyChecked:
	odt0VkgPXnnZ6mMPA646WEhpchJEkAtsUS55IHm+4VOeHnSUhsAU6CErplLKOuW4/caKQcMUKl64uH2kBiLHx4WWW9hXezOgLwmuvJ7Rpl5hADJrJNyjrRPX+YyybzjhCT1u5tRbktKOnm+33UZt8FNNb60F3ilnxlLIk2TrHmzIE39HwzSfAVhgcSLCN5P8UGI8ROd+2nfJK1vyCY82E0WE8jqik7te3RsMecoJcbIOtvglUvE3yz5zEIdT9IbE3IzUHVzw+rFBj1aW+vSouEGtS974AhJdbI/up7ZQGI4EZUnfDvlTwPA1bbKAKvudDaGWbCnYutI0f2sUQqZTTQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BLmcvSKEBHkdt2fODGxB5st/UMYhVK9Y3ajRUwlDVMf/egwUpj51+VKTfN5wMnT3/rDWDDVVbtNP57nDASoB3x77+GZelxNqYNAvmK52OjOWv2YjYxuenTPK9Qv/0ZrRqZjTM7PBUuwxOCoaGqfuyGoQnZmFtuHkY6OJNOMrOhy70IqTn6qTD9kJ1La/F4sHyYuSjNCD5fMnAR2UGclT0nnJWc75qs3CMZ3yDpaEmRUMTjf7Y1qDWH9BsTi/NWUnFSKt2tSDdBAK5/BFXGOKlJiMKFJ+nY7zU7ykLn2FdUnZkEpGpFIc+L91yQ9OQM0i1jpXWumhgtbw7yJfrUSWYzUsuPGG6A7f6vWYfdD+t1WjuOcDkP63Y1pLwwhXHyjlg0MVYycyDUh83J6zB/cMjd5p/ECw8FmtG4ELXXKw11SWlxDd1Xhv7C5qAdLB5hUzvX2U+R1nAU5xq64Wb40WWJ1HxcY6cUD3OFM6fMUophdVmBW4EZLH7ezO+mg/7dkR09In7dlWbFtx5SdgsEyJ1Yp9LBgv8OYF4fIlQJ23SXdjSdb4aOWLetCBP9xl5IGl1P10gXO2IIdfcfqAMaMe0k7r7KS5NbmKYDIrphBL1R6ZNPXysONBP7clMUgH1MOe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db23e53-8f9b-4c8c-faa2-08df343d9f4b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 15:18:58.6495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKaO/WyHvFn+IwIE7QZj4lOEqvpUnmpk88jcrdSscTf/4u58je1y9f3M8P2vee04sNf0SnzEpmIAkGuUo7QpeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7053

On Tue Oct 27, 2026 at 11:33 PM JST, Johannes Thumshirn wrote:
> In general, we want to ensure all writes in the block group to
> complete before finishing the zone, as relocation does. However, the
> current callers do not need the wait (or cannot wait) in do_zone_finish()=
:
>
> - Relocation already waits for reservations and ordered extents itself
>   before calling btrfs_zone_finish().
> - btrfs_delete_unused_bgs() checks that ->reserved is zero and sets the
>   block group read-only while holding groups_sem, so there can be no
>   in-flight data write.
> - btrfs_zone_finish_one_bg() is called from the allocation path and
>   cannot wait.
>
> Dropping the wait is still safe. Once the block group is read-only,
> ->reserved can only drop, and for data it only drops after the ordered
> extent's I/O has completed. So if ->reserved is zero, no data write is
> left in flight. If it is non-zero, do_zone_finish() returns -EAGAIN,
> which all callers handle.
>
> This makes btrfs_zone_finish_one_bg() fail with -EAGAIN when it races
> with an allocation in the selected block group.

Oops, I meant to keep the pragraph mentioning the deadlock and the call
chain. I think we can get that part back on the commit.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>

>
> Fixes: 393f646e34c1 ("btrfs: zoned: finish least available block group on=
 data bg allocation")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v1:
> - Reword changelog to undermine why this is safe (Naohiro)=20
>
>  fs/btrfs/zoned.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 1fa855a0c31a..35b422a53e2a 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2604,9 +2604,10 @@ static int do_zone_finish(struct btrfs_block_group=
 *block_group, bool fully_writ
> =20
>  		/* Ensure all writes in this block group finish */
>  		btrfs_wait_block_group_reservations(block_group);
> -		/* No need to wait for NOCOW writers. Zoned mode does not allow that *=
/
> -		btrfs_wait_ordered_roots(fs_info, U64_MAX, block_group);
> -		/* Wait for extent buffers to be written. */
> +		/*
> +		 * No need to wait for NOCOW writers, as zoned mode does not
> +		 * allow that, only wait for extent buffers to be written.
> +		 */
>  		if (is_metadata)
>  			wait_eb_writebacks(block_group);
> =20

