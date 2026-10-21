Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590144;
	b=p7I1n8+aRpL0ToySQvZrMabdYx1332slxR8Ebvp2MRkXvV9Ia4hSF2heOdlK4S6R0Ewu
	 eKqgqFqkfyzksaC652CRKfkKse4dUj92acOGB5HzqIqCM0U53aD1vqOtD0iSS6JF4FjKN
	 PokdH0XEoamyh24nlYVh0JioWfv7ojBYGb48oAwoYACqojeAA99snWDwNM0Slsml7yUdX
	 cAJaCwc6d8ZTdvKfz7dXW3fitJ2ivuZhduLz9vthNOZt55QSogxBkF0TWtyH+QkeFxq3k
	 1vc981dSagRsmgSqpW8s/JJ1Kv/TzQWqEEX2pMl0OXArXKr3/CFxDg11RXxXWy6jhkQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590144;
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
	bh=G+TbQFMvW8NAcWL6UM7/VLq4ErNOtiHqZjlmAPVeFtk=;
	b=YC9dnYc7TTqzSb+nfVa5ESvxbsZjTWnOSMCUWj6YZY+MkgNk/OqcUsjrpySNCTQQy+Mv
	 kvsEnNssVKmmyr3+iqQS36698cyRLTTtNivJ8jNSaW7lypf0eJ0fEYhzWfh2z2sy6RwMb
	 IKcTq5Sx9pZC5J6H9DZQHXjffQHF7+brmmAQYeYHuDoxo7wL2Hn8x2nyyVmARO06juth2
	 AjIr/ap7yl4JjFrt81i16C9m9EW8Q1n7Sr3YSeo0ofT+nxOY7772IZrwrRP5ll3FPpBGh
	 YoQd3/aBB0vdXvjO0LhxwgDau4KXCO8hq4V8Yk+voBbVbzG9Yi6290EDT9sKYo/3fUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZtEZPTUt;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XLejLye0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39E0606A331
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F39E0606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZtEZPTUt;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XLejLye0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590143; x=1824126143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=z0ao9lQrkM2bMz5hJqPdglOv+jxK18c/nfRbslOpRpM=;
  b=ZtEZPTUtxt+N6cH+z86bxqHp94nKyxGdLcOA1nv/ILWrShPLpXgoBpDq
   +pA1Ue+B8OYtJd5aiwEnT1Y2JZVLuuFDksALE9OYO6iRb/hdEL6nnB59k
   T2UhcADjNGbdASVPkqa1vBdsEb3a3sPqaJ6rRED3RmeA5W6+xTkJde4Pr
   M+ShJ7QmnvY271ULaQq07WYOxbspTNNBNb9XsFhcaGlY7ykYNeXUt/LTF
   Xbs4Jd57dPtN/zmcJztUijdYmZFt/Pjn9HZnWFaga78CcOw0y999WcYbI
   8nBESzGiY/kzWwgnCux1qS+KJph9DHZgF8tTQsY6DfMyef5A0sChydrAP
   A==;
X-CSE-ConnectionGUID: 7286+GAmQA6ADF0F99SAHQ==
X-CSE-MsgGUID: nEJf6u+qT5quljQQC2oBdg==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="154422366"
Received: from mail-eastus2azon11011011.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C49hQrbSjvpjhkjJbZCyaPffS227+RJBUiTSS7xprZrLQ7H9uJzC4FwjofqKiHsHshX2BiRKaaX8dC1zQnj8g15LwD2JU8LmFrRI16db1M3TwbHNjGiUtMCTY9RMdvcnhliQ9r1ZSDBiEyUfY0wDuW/oWHwO5HH3dNCkJOOQqurm0qpw4TBoVmwlMvJQPeHktax2ryT12+MfDy5UojZMpraYhDoX/vQWgUmLmK8O4pFl7ZPgOCxqiq6OuK8EymG3JX105TW6lU5ylXpHzt5DnZQTGEXoaQF3JpI2ERWCHB8xikb87ZWG2k/HhRNpkFbU+J0yStLqxf6NeaBkqNt5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+TbQFMvW8NAcWL6UM7/VLq4ErNOtiHqZjlmAPVeFtk=;
 b=Ajtqm9bCYuROs7pmBce08waZZgxSeeCo8AXJ5ymH/vLeNTrwcEjzOTEmMytzNVTxbEUWso+08BoyBk42GGK5PVCMZZ5+JHTnuwauRXCtURitmRcaGKwva3whN71PsaqiKBDsm1WtrmKrnUviywEnh94v12QQfSWgAmc9E9za9aRP0jM0zj5JfIKu6QSG6G3pMN06y4enDNfZzByzaGdfdpQIrenSVKZ+S+iMc9wkfj7DiVkCuATBAXbCkTPOVF3SaTq8kovf6Oo5J5Fh2lTgvYDrvksC2w7Hy4E6oAA+pe3F8PwGcDMP3JT+moO8ay7yzfof5qNSindmiCL9OrsDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+TbQFMvW8NAcWL6UM7/VLq4ErNOtiHqZjlmAPVeFtk=;
 b=XLejLye01arGwVoBAUBhRbv4pie7cguEfk9gW+PAataai4t+LbRosWZOjLVdURsRuswSNmgxD8u5H4ilTzsxf69zICrY4l2tQbkojQQMNlsL0u28HT2pUEnD6qsuOLaVXNlVSjBQaIgAy4E1/wDCvfpzjUHEjM/IaPqxiiUb12Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN7PR04MB023717.namprd04.prod.outlook.com (2603:10b6:208:5f2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:20 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:19 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 18/25] btrfs: zoned: prepare reserving the data relocation block group at runtime
Date: Wed, 21 Oct 2026 15:41:17 +0200
Message-ID: <20261021134124.2338902-19-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN7PR04MB023717:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f2c2911-dc80-4c4f-f3b0-08df2f791c8f
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|10070799003|19092799006|1800799024|376014|366016|22082099003|18002099003|10067099003|5023799004|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 cMUE0IfhT5b+yVsAOHCtvJOP+NsRIh1HAI+nETq1gWH2Mgl2sh4WDm0KgsLdFbfMzY8iKc/ugne0XEebGgr6NYYePl3ZM2oxfiam76eR3urGmP5SYnjdcvsn0OK5QBNJC1P8trG8NCBM1qqFFQqBykKIKY0BGmyKeeZaZbHUKhx5pqzWqFntUTTSXJRPSIusOGwXPDUH2u73LFrikeyVC6AR/Yp7RCW2psuBIn0hYvpHCbCA1hGldSFlKJjYCXehsDqXoDXqzmy36b3X8SjvZao3r2sUBZgprzFJ4e2vaH7MGzksCfJ3vNCsTbH/XGSaEU6hDsoP146MRiFINtsp3RwiWI1dxqSWsuPZt1QPc3udifb4pSrvLlm6SjaE/vjvONNRvV9RQ/2xpge3AxSTQrcmIRcSpFz/2VzeYwFv1ch10uVhgFi0PWURVvtoDVNvOIV3FyJcoRklgDL0MYXjTe7Lz5twAprvqmQJ5IZg9GHcmh2mKzj4r1ldFHgZd1UzK24SdK43kKR2p9iQAGY42A41+ot+ywqTIBuHXOOSZceeos1rqnXrY01Vl0L8j/9GEx39CD5qg8NywmxIHqhE0m/DGIlEZqVwUphjua8PbXboEEyq7f4PiQV6fBilvoMRSDqLEjSggB0ycNuKxDKZ0OhTnzpCO23Xh0OOybEKg5s=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(19092799006)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?kbNJe8C0XliH/CWr2cPaJR9ahkbWoRvvTWjfV7VULpSsmUlPmOh77XYgvIhr?=
 =?us-ascii?Q?poEacElOD0UQxDnPzR1wVRsA1uHjK6Y06rfBUa5Wy+YyWwJg1kXnkh3Rmqhe?=
 =?us-ascii?Q?TQtGgkIMnLCQQ2adbTX5wGuYYxkOoNT4luUjSfH3nau+uY66GiS+phOgnjEv?=
 =?us-ascii?Q?Nr+41ZOp2xMi5bOdHy+3ln/nF4zy5IizIGRd3I13Uqezw64WuFIfWAz+cl2m?=
 =?us-ascii?Q?BCESuDGC+F82LjdhhwFjOZpQaOSmL5nYBcPcszaDcuJSw6Ar6rJKG7OFmahv?=
 =?us-ascii?Q?va7tx0OBfJaHUzNOmqMcTVvH1VQlViWDvF/i2qw4ow2Ua8frhEFZX91TWrRC?=
 =?us-ascii?Q?zUiTDllfCO/JMlSyxw1y5e18M+d+hISrPBAR1Gm14IIbACRUiDlmr+qt1O6t?=
 =?us-ascii?Q?lVMdA2QqOYwN4/R/cI7TxBaoMVFnCCWf8ID8kX73XjsDif0uPRd8Q41qx7xL?=
 =?us-ascii?Q?svHVmGrBqVRvSZO4QicEJGkMj3NdPSN8Bs40fVwQp4gZ1v4i7CrFXSCjFX5l?=
 =?us-ascii?Q?GMzPpICC/J3MV0ujcc1PgDLSphPWj5ShKVU6TugSgcsKH+hhjbuf9Y2GV6Wz?=
 =?us-ascii?Q?zH+8Wa1eRtAi2wBV9oTbAtNaLt9IcEoKj/N94dMHPrx5THwiq1GFoSGdLRWJ?=
 =?us-ascii?Q?qpUCJtNTDOsi2PbT1NTuX2ykVF9GytpbzDYgYWB2Y9NNgTPPoJQrWr4INTsW?=
 =?us-ascii?Q?0RnC3jAMC+cPCeO49O4AN2p02Czl6k3tpkVzwKCuIGMKUu7nCGCm5DFgQ0hy?=
 =?us-ascii?Q?0HspT/dWFTvBHOCPJzEgh1siU6AjINOqo4ELf88fa9SSgcy00oGd/F6VECLN?=
 =?us-ascii?Q?gdxiT6YwSFyVBf627LP96MPdpS2rnekYPZfQ/Y3JbGOYg+4SAef4LGZs3Ydj?=
 =?us-ascii?Q?ElVR6qLQgjNllxMS8uPRBPMqe+1/7g6aNGFbxg5etf3LF0FNeweTrx6/g1Jv?=
 =?us-ascii?Q?XrPnkMWjeecDJFmEJRWoF0XKQsLWuc9svFLkQYvllGr3DG5FAz221a8OggxQ?=
 =?us-ascii?Q?iV17JpU0FZPxeEzXXXWrgExSprDVsC5gPDe6nTyka7pqW+bu4bNHl7j1cWXO?=
 =?us-ascii?Q?F1WqMfwOV698/cj/hyWhQe5mFQ6F1EVtVEgXusF64Mqf6S7+jM5Xx9MCT424?=
 =?us-ascii?Q?JLLFzZYes9X1sjvn1eiBuJ9vZJE3Lxi+bA3Uq7qeOXOOB/hDAxDvnOAL1q2b?=
 =?us-ascii?Q?6kM08t5lxPcAIvwZGbqqt5Q5Wy9TFptiLBbmVSiW9GxLgjOJaBuU9+pBBliH?=
 =?us-ascii?Q?oYo98zKnlVME5jwaTyjY+DMQmj6/WDy6Xuid737z8YruJgCrn4gSNiPsZNDh?=
 =?us-ascii?Q?h308wxW5scnM5IU08MkNJodwLVC+TxbAgwX+6Lcu/WLXaBzn6vAovXJ/Hs5P?=
 =?us-ascii?Q?m0xdDs2OWEZUp5mT5TsgI+GgkkXwpoCQed58NqG9W1JhfQAEEVpBf9OtMOkp?=
 =?us-ascii?Q?pOdDr6WmKaN10XSm0kFuQ/nk7OMWRcw3qeik+0Qrd8oZxCeChXGQK94StUAr?=
 =?us-ascii?Q?uPsmWx7LGnaFBNnHh3qq77fzBMrLIQA1XNOPqjUcJPM3OLPC8jOezC6/KK50?=
 =?us-ascii?Q?FlwHffSUepEh+fHGKfJ6VuwPOotoHWA9NTnM+BrKwRF3GNghmd0yhQ91giEL?=
 =?us-ascii?Q?T2tqBVwH8nE9E5Ntos0c3hSmKFPsDT6EBddZ7nBeNOWhEzYEB5STEBlPk2Ha?=
 =?us-ascii?Q?56YfrDur6TzY+Z9fivPsDdROcJh24zf1X+1SCXLnjN68TaVZBU3FBDLXfLdp?=
 =?us-ascii?Q?zfcJCsHlB2QIRZYlrw3+E4U07zPGC5XCQnn5qKVMrGagfGH4DO5GkWFd7ADu?=
X-MS-Exchange-AntiSpam-MessageData-1: 1DKq5VWbT1FqhjG9De9tXiS7YFBeJ/vdcuA=
X-Exchange-RoutingPolicyChecked:
	38TmaYvZCk1hH3DX4yktSkA6IaWut5djSmb28oePTXHZGoZcN0QInE0suD/cvC+03mGcP0cgnYEGkas5GqZPkO/0E9P4XtDU2NUJB+jBr4sGhpBsdmQFwQQvCak5hYE1+LMWpOB+lyvQTd6IUFWMta38fUs6Ibfzy0MBqiIKGrfXScxIHHUQwAxr4RoiHczBikSbyL6JR4N1PXT1c6sK7hxFzSClKTbBh3DLyKRUET1Eh5iVj0B3PgIO5veeNY061NLdAThsv/IVT8+S7BeiBTCNhD1gVxZ+ewwxg6bNBbCw9T5148d8xkqVRk4V/Z/qFO5tU72c4j+7oGBCGo31mg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9/x3q624l6mjBFjYC95LH4GEU0Q+IeQp1OL0JUKJNbc/TVGCvavFTzLkE8jmzT9Tj/+mJn5b7Jba+VslCrLSjoRdw3c57plpbSKMhA8RzvxO4ouO/al2f/WvC+ce1gbeYxCixjL74t0XFu5UK+kEp9UPtoWhdihoA4cK/lTUFxzdvwFcniiUOm9e7nS4awpNnNxQVUbHmPdxjqKnwgc4ypVpnnlISiO1aZ4Lej2KHsktWvD4MP3PbG88Iu3YulURhojcRqgy6aa8eS8KrYUMVFPPUXxywwmWHVMIcUjtV2PaBUL5QGSc1A3AcUPfY3SzDJkEjKtm1Wh/zxbWnLMx/mynqYojXS/DRokyZZ84pjuJGufR1CRfsUsbSaMpkhyXg5fhuUJuO+Km79TVpDYDU2LyKRtuI+aQmlhmdEboUzWKGUERjJ0JG8FfkDHjD7ltYue/7ila5INBnlcgMlsPEJITLfgYUFo0ahIp+50JkZe3JkXK/78AtrfB9aljTzi6//QA4RTnUWV8MgBmzQiFNSC2dDq4emjwhFKLw9snyU2kLTZsE95pwdy4X3SJIC3TKzfNrsY0JT+wBAvs4OcvDjUa9oSTCPk6o8WnJFJy7DI4nKXQUfA6SrG5j67w0yfv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2c2911-dc80-4c4f-f3b0-08df2f791c8f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:12.7954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCA8O8i8mLmwvCU8NZvISGjsrac2NZD7/GoFc3S14W6MGy9p6T38luJckm6a10ec2FmD/RqTRaDAnODsI9wKZhW+36HEKkHMnPfE8RWvFK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR04MB023717

btrfs_zoned_reserve_data_reloc_bg() is only called at mount time, so it
walks the data space_info's block group list without locking and does not
expect the candidate block group to change underneath it.

Prepare it for being called at runtime, concurrently with allocations:
walk the block group list under groups_sem, pin the candidate with a
reference and recheck that it is still empty under the write lock before
moving it to the data relocation sub space_info.

Factor out setting the data relocation block group into
btrfs_set_data_reloc_bg() and transfer the complete accounting of the
block group, including its zone_unusable bytes, to the data relocation
sub space_info.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 133 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 96 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1bb8716915a9..62a5cd1c9de2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2921,6 +2921,75 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static void zoned_move_bg_to_space_info(struct btrfs_fs_info *fs_info,
+					struct btrfs_block_group *bg,
+					struct btrfs_space_info *to)
+{
+	struct btrfs_space_info *from = bg->space_info;
+	int factor = btrfs_bg_type_to_factor(bg->flags);
+	int index = btrfs_bg_flags_to_raid_index(bg->flags);
+
+	spin_lock(&from->lock);
+	from->total_bytes -= bg->length;
+	from->disk_total -= bg->length * factor;
+	from->bytes_used -= bg->used;
+	from->disk_used -= bg->used * factor;
+	from->bytes_readonly -= bg->bytes_super;
+	btrfs_space_info_update_bytes_zone_unusable(from, -(s64)bg->zone_unusable);
+	spin_unlock(&from->lock);
+
+	bg->space_info = to;
+	if (!to->block_group_kobjs[index])
+		btrfs_sysfs_add_block_group_type(bg);
+
+	btrfs_add_bg_to_space_info(fs_info, bg);
+}
+
+static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
+				    struct btrfs_block_group *bg)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	const bool migrate = (bg->space_info == data_sinfo);
+
+	if (migrate) {
+		bool still_empty;
+
+		ASSERT(data_sinfo->sub_group[0]->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
+		       "subgroup_id=%d", data_sinfo->sub_group[0]->subgroup_id);
+
+		/*
+		 * Recheck under the write lock: an allocation may have started
+		 * using this block group after the caller found it empty.
+		 */
+		down_write(&data_sinfo->groups_sem);
+		spin_lock(&bg->lock);
+		still_empty = (bg->alloc_offset == 0 && bg->used == 0 &&
+			       bg->reserved == 0 && !bg->ro &&
+			       bg->space_info == data_sinfo);
+		if (still_empty)
+			list_del_init(&bg->list);
+		spin_unlock(&bg->lock);
+		up_write(&data_sinfo->groups_sem);
+
+		if (!still_empty)
+			return false;
+
+		ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
+	}
+
+	spin_lock(&fs_info->relocation_bg_lock);
+	fs_info->data_reloc_bg = bg->start;
+	spin_unlock(&fs_info->relocation_bg_lock);
+	set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+
+	if (migrate)
+		zoned_move_bg_to_space_info(fs_info, bg, data_sinfo->sub_group[0]);
+
+	btrfs_zone_activate(bg);
+
+	return true;
+}
+
 static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -2992,7 +3061,7 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
 	struct btrfs_space_info *space_info = data_sinfo;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_block_group *bg;
+	struct btrfs_block_group *bg, *tmp;
 	struct list_head *bg_list;
 	u64 alloc_flags;
 	bool did_chunk_alloc = false;
@@ -3012,46 +3081,36 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	index = btrfs_bg_flags_to_raid_index(alloc_flags);
 
 again:
+	/*
+	 * Find a completely empty block group. Unlike at mount time, this can
+	 * now run concurrently with allocations, so iterate under groups_sem
+	 * and pin a candidate with a reference before dropping the lock and
+	 * operating on it.
+	 */
+	bg = NULL;
 	bg_list = &space_info->block_groups[index];
-	list_for_each_entry(bg, bg_list, list) {
-
-		if (bg->alloc_offset != 0)
+	down_read(&space_info->groups_sem);
+	list_for_each_entry(tmp, bg_list, list) {
+		bool usable;
+
+		spin_lock(&tmp->lock);
+		usable = (tmp->alloc_offset == 0 && tmp->used == 0 &&
+			  tmp->reserved == 0 && !tmp->ro);
+		spin_unlock(&tmp->lock);
+		if (!usable)
 			continue;
+		bg = tmp;
+		btrfs_get_block_group(bg);
+		break;
+	}
+	up_read(&space_info->groups_sem);
 
-		if (space_info == data_sinfo) {
-			/* Migrate the block group to the data relocation space_info. */
-			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
-			int factor;
-
-			ASSERT(reloc_sinfo->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
-			       "reloc_sinfo->subgroup_id=%d", reloc_sinfo->subgroup_id);
-			factor = btrfs_bg_type_to_factor(bg->flags);
-
-			down_write(&space_info->groups_sem);
-			list_del_init(&bg->list);
-			up_write(&space_info->groups_sem);
-
-			spin_lock(&space_info->lock);
-			space_info->total_bytes -= bg->length;
-			space_info->disk_total -= bg->length * factor;
-			space_info->disk_total -= bg->zone_unusable;
-			/* There is no allocation ever happened. */
-			ASSERT(bg->used == 0, "bg->used=%llu", bg->used);
-			/* No super block in a block group on the zoned setup. */
-			ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
-			spin_unlock(&space_info->lock);
-
-			bg->space_info = reloc_sinfo;
-			if (reloc_sinfo->block_group_kobjs[index] == NULL)
-				btrfs_sysfs_add_block_group_type(bg);
-
-			btrfs_add_bg_to_space_info(fs_info, bg);
-		}
-
-		fs_info->data_reloc_bg = bg->start;
-		set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
-		btrfs_zone_activate(bg);
+	if (bg) {
+		bool set = btrfs_set_data_reloc_bg(fs_info, bg);
 
+		btrfs_put_block_group(bg);
+		if (!set)
+			goto again;
 		return;
 	}
 
-- 
2.56.0

