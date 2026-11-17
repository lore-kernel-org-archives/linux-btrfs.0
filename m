Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794942008;
	b=jqXfC/+O1rmsc7iA7VkNb1pVn2XKsVHEl9T12cugdttjoO7SN1rh+7H/uqip8hjIZ1oh
	 j5jnGqzcmrXDnUgqYwzFy/jeIQFI53RK/WmQjzLzRY7xdZtBANK1Gl7DpuoZj3nbJKeX/
	 t8XQtuZ3koPZ2R06eBQ6Li1sxqOUTHg8bioO5X317jFaFSYMo9X932BdiXobcig7AhIwY
	 fGPXT/L8npcBYXT4g43VW6obukHvX/cozI2xohNm2k2BrNrNoH89DCFdi1joSo9OA0M92
	 lGufaKqkFcW45PYz6y4bLAgQOw2/OztYX0Zqc2fkGZrV4mZOW75dKs373bGs+j4nZbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942008;
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
	bh=CgSws78YqhzrjqsgA8ePWuDDBGO3H0on7hwB5yZ+yUw=;
	b=DKG54qxY8QmFpV8LC06MUcsaTac/SagLoPccR/OyFpEkHgEXIPuIVwtjdY9rEjBglGRS
	 gTjLUkRGxzlxt8Ck+c5avCYzDVJedDsgZFiVQjp3imi7d9wSKE5D0jDVf5obdtpis8OBZ
	 zeXvT2PbWCB8ntWs7See3SSI1CEJ2Xu65rNGVGZ2I64HeZ/P4aki4SvaSDnC72tjuhZhC
	 4cnbsLCUNpIz8dJRsvqra5GAglvj6ttnAKhurmDSOtOpmkCBVwMqPbLZ31GGYYW4zSYPo
	 hmNcKBngli06LOTTupaE62TLItmMAq9uV8B9NhsqZyRpkAT+sKT5D/8d2YR0kUlartg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=OhVi4cto;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=R1Iu+6iM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC0A606A32A
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 19:00:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DC0A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=OhVi4cto;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=R1Iu+6iM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942016; x=1826478016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6/UE+Nq/rusvIrtkzu+K3CPul4b30LLugmMxmOzEZbU=;
  b=OhVi4ctoGPx9VnW3pVJOvi6LWyJEhUU6HITGzzfJCWV+u3gNLTBDMXHL
   RaVRDv3JxOT7uTcZ05LFUCcX+LBnnPlBjLyVFNsacNcJJMH4L3qYyjOVX
   BLOu4GBiGlaIlOa/f+Uj+negqxkrafaTRuV+w/9Uu8KO0xTMDHq+8L6Wd
   DJUa/f0iD2A3mvUNrOSNkbCtj45xGGU+hoz/FCvrPCVJM9ppPUapgF60u
   wli1FIx2zG5YXTIZPG1MS7z0BLr9+a+tKU81qO7jxznM1oTMa5HOQ6guJ
   L5hl893CSaB0x8Bhahtna/6O2SgnW0Ym7+/CusVglAUsVVOgmMYghs0Ab
   Q==;
X-CSE-ConnectionGUID: waadPcrRS+OJZFPutZzerg==
X-CSE-MsgGUID: y4DVnwe1QcK4B9nRW+MlRQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160149050"
Received: from mail-westus2azon11010065.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kYVOaJv3Dln5dfVTho/4DZjXd2SCFIo/LfhdQBDQpRzkcOTKlGI/DyJF6N+omsjb2d8tKY++0wOsyXg0n90O2NgALpib8iYynTsjmcxyOUiBA2y8uIxAphlmSTDLAApWgn+Z4MYWi/PuD5Y5RItIn8zSqlHqYJtfqnzr9cHv9LrnasRhCbqB16PVnia8e4sqQuqBmwDZoO/YfT4i/RDFc08xlYnL8W1bTsrMOa08ei5+odbG9NmCevYvIkByoyTfSci5g6LlIfNdSvkSg6xxo7oJjmgO286M/YFsJaaFGmM2fdUU4f6bUeQJOhyqztIIlAbZnXxSa5XwjlqIVwzdsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgSws78YqhzrjqsgA8ePWuDDBGO3H0on7hwB5yZ+yUw=;
 b=FUO0+za4qZkb4ynagO8qlyny6xTpm7M0HvzYOjO5yOvZ89+Shc1hBpo0YEyj2RmwHlfjnTy4IDiZcQlwfjCS9JVo6s5iksiE5G1Jv4nKuAzObwpFp6p8ke0pwu9OoBXBNcVXJUy77YTeHVGIgq5sWA/Vuow0c98gNYLnwncMTu0C6RigQRYXCCrdnc69dqlsCGOeDkqi1G44Ai2sMFfG3vy9OxAJxG5KFAB47yaX4BoswMEgNWgPau88jkqpJ3KsTAdlCxcHuEYJxinFpttuMYcqQW4Qp2s2DyCYONYYqYAfV7Jp6WLzy8oLfR1nUNkc+TtUEZc+9qVd++YmUtVgqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgSws78YqhzrjqsgA8ePWuDDBGO3H0on7hwB5yZ+yUw=;
 b=R1Iu+6iMEoEih7XOf2a+eQPhiSACl7/W0R+Yi80shtpAXDqWe+U/NKth/8Mfbya2ePY+BeWDjziBrc2oayEyAMukRkg+BxvBR7VlRcM474s9suZVRlFja9d+RBAvulqTHL+ftM7M6rDaS4Bt3Sqzos26vePGJFbcM7JqTqnVIzQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7483.namprd04.prod.outlook.com (2603:10b6:806:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 19:00:04 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 19:00:04 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 24/27] btrfs: add btrfs_bg_type_to_num_stripes
Date: Tue, 17 Nov 2026 19:58:47 +0100
Message-ID: <20261117185850.4128157-25-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7483:EE_
X-MS-Office365-Filtering-Correlation-Id: 90c7ebbf-161c-4eed-d726-08df44dcfd0e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|22082099003|261009223027099003|11063799006|56012099006|260925022911599003|260925021911599003|260925021311599003|261102123227099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	XN2yQc4Z+GAtE20xe+s90pKlkpgF3ODCWmyBw8645TCmdGyyjG4RZEJR94BPT1hQLYcYAph7PDrwzkhEFrB1xRSCNANzb3u3wKeaCUisBTKqr+59YYywiuEeAdzwQh3uCsjrs6MkyRt5uk7JSBPJixKn9gmdBVAVEsecjYJxBMdNR1LJkGoVLS9Mkr7/g43f9UMOzmEkunghkicZPp9zZjRRGmn47zlJZZ8L7Zt6l7cIElGrhxzqT2zgFaRywXz+1DYkvlkwcilQg2L0XaxlzaZ0ZHvyY6JXMDhBREu+26hOrjZ3lFAp5DFrFOBHncBpEOt0zNjoRJ+JIrh5VPqU2ZNobOK31nlolR6fpZWcx+XyWQRhd+bExwOLSFEEnbGBDzsrqZr/9KFkUlQNXVZiogi5SrA6nUH//SNsp1PvmdraKXxOZQz8M/dNTuNxZtXrB6s4RH+xDj7ndDWqfIRw5Nsk8VOrkXTBtQrcL9OYhedZianL9MbADOoQ5VvFvqJ4pD3A3fU8kAYbmms7fniMVxydC0C8W2xj2bMccvWCbjoXBwwlb8JUQFt9tm7DGHoTx6l2anQAXCn27WroppvbKsirf4SyGusL1UpYVAIZBi7lqKtZdYUImVxuouT5M59CAoNm4sUd/DlHZHD/gx8NaNInXZrNuJyVjXhKopA0BVQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(260925022911599003)(260925021911599003)(260925021311599003)(261102123227099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cXMoXsdsRfgS1Kycs3j1RIAP+NjvrGJartXVrWQoNYAm1ax0pwrz6mxWQx2W?=
 =?us-ascii?Q?LiqZ642iDgh/OxdtZxM3ZFMdh6bmBzBv9tuIjZUp/Yj3ZZz9kaJb0M0CMV4C?=
 =?us-ascii?Q?fffSV28izJkKslp4qDO7WqYYqKfa853uOSuJmY68fjSdnvf3hX0AywsH+caZ?=
 =?us-ascii?Q?go4HYlwI3VazJEzNDaludbCjMtNm19E4+Tuk/Gt2vINxQNCGfV9eCETOcsRb?=
 =?us-ascii?Q?M/FhkVoZtCv2l7B3LE2bAAP1T629yX+G7dyCCsTA+4FN8bBmryycfJcgkLeo?=
 =?us-ascii?Q?bRZSrRGsLGtC9YhALaj2UoCJAFTLqprwGtZZxMwu2n4EWnhimPS3Na6wUoGJ?=
 =?us-ascii?Q?P5WUbI/ibCW0YuIyTJv4TKMJ5J3s3H6RsoZp4X31QK2ODPgz5DmSk+Y3uN5N?=
 =?us-ascii?Q?BfoZ4O+JukADswpEZl0UH0hEIQ3Guil2cLLedZdumOSM17lMgFoCg9Ir68HK?=
 =?us-ascii?Q?u8NW0xKL9+QmaVcwvuuu+YHcZBBI/7U0AgRjqaB4SjE0VG3a/fYJe0tuGbIw?=
 =?us-ascii?Q?7KELRL2Cvk5sezziiPh1XNjtila3a6fp8PAOd34hV7noHK/BZmk6Rk8ycXTo?=
 =?us-ascii?Q?w8U5T0Yb0XlWQsDL5B8d6mcPbw+ayO2t+aNwTKlgi/eBwZ842x7GhhPdJ+HF?=
 =?us-ascii?Q?/ZVhmK7yCz8CKZNnNXXpe0dLy4Kdpv8qwA8BZHHJ+lam/mp0cCSdkhNgIgyu?=
 =?us-ascii?Q?XaJzK8471el8VatXWAqWiCGAqtWODoO8ojbmDqPODSCeY/8J51NBdeQbAYPj?=
 =?us-ascii?Q?abxbt12xpvhpp/m0FG+j8AFxsVnp1JoHZlKsucUmAtTPVX7O1ogu0dG+8mS9?=
 =?us-ascii?Q?XnG/rXl6YCLxU1qkQlbDqxWan+LezL7IzJDZBqgLP+/AFo7x9qEVaXRdEk9M?=
 =?us-ascii?Q?nn6rrFNh2AJTSkqIQTDRb7sfLoezwmmTO1U50FpYAsEt0KOgbT+nN5Feaa57?=
 =?us-ascii?Q?KZ7QKj79xxfK5i+CVzEKxxjdj6tFteXIRL/tN/YtGXz7hMOLFqDy4y57GR/1?=
 =?us-ascii?Q?4+a8agoKmMnIvWhnn5Vi6cE+0m4dGpvvykQSWR+Mv3TA87jeM73aRhOx0OSD?=
 =?us-ascii?Q?D/PT+hfk+HxulKTLFNKR9KraRNuzmw5fRompfK7UOSuMti/GNnsxZ7ZZDFbN?=
 =?us-ascii?Q?Pf350qr1yi4IVDBkzM9rDvD59LAt4ZBQDFnr6Liqm3NaoH2+6ynfQbf4zzqW?=
 =?us-ascii?Q?nkh3mPn0Zish0eUBuqOsJjT2t+C52QsS3KvsNm35pFGWeT7ljsC3fMWfoncN?=
 =?us-ascii?Q?FjTw+7kYD92GTsXYymvDnPmeQASvzjB8ZvtAsICZS2uXnlWF6R6wRWXtdOq9?=
 =?us-ascii?Q?j83F28RfiEuDIoH85ozEPCbuZZfX0vnFlUuX+3qQjks3MVn2NpMO5SQ+k6D1?=
 =?us-ascii?Q?F3Ay8Slbo+hjE8JfFqSqvXEgf8JsBC2NAdRidBCNyNUFH4MpLDR8ga4ihf1V?=
 =?us-ascii?Q?ufn47rFVi/2mnSEyvSNNs3oIiV2e8+MCKir7PJRpBxcx0BJOwegjHZzwhMGX?=
 =?us-ascii?Q?/5hm7VtJEh8gOxO6v405eJ4IOSD6gtFS0V3ABVFRt52QSk+2+w9Oos0inF8y?=
 =?us-ascii?Q?wZnaNCpHVhTFcN7sYQf4MlDCe76KpUelOWg798ym31GdO2IHDLglzBMyJmv6?=
 =?us-ascii?Q?0hRDcZY9268bg6kV04duw/UHiDiFLyTREAcCeJKiJXKhTviUvLjgnmSAa5BP?=
 =?us-ascii?Q?wL7E164M2N5DWaGW3Rjl2kncKF39X4t3AhDwHkv8OD+j0ev72tS4HFDLCnHZ?=
 =?us-ascii?Q?RvJ9yLG4rTZe1wj3NX2EnfBTS10QfcRt/cbeThpyalUiqbhoK+RUtJEXJE+q?=
X-MS-Exchange-AntiSpam-MessageData-1: 0NkMxlMbpolXwux4ArSD0VmxL8XEXFmuY3c=
X-Exchange-RoutingPolicyChecked:
	DXpX4/c/wuhqV9bu9bWm4NRSYZhwyOT7Z/VXw4/21cS9cDJ0lItzdGfy5okn3Ov/tqRTFuXwF6FdbtImcFnk+nYT+iM1H0k7SlSRdW41jdctF+Mk/FGcA/VWg1ADXZCz/I4krYozHTgmdBTROyCu3YotzVSY0YD/b5pRr4th5+5ddIKXRUPXMXC0DAGCNMcSbev6U/kU6MuY9tSj9kKyhsN/KNaAhtQmAWleVFviP2PjESUqFRpnVJts3H0DzUH5WxWnWNyi06hSEaxokXOdfqIyDzetuADnyeWj+vJSxLOOmECiV30EY4UpPUF90gCjOUhZdi9VLTqwJT96GSVjbw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9nXy4gvU/UbQibSMkmgpO7DD/vHDvXB6imYdanvtTMctAQQi0Y0R1uD0/5l0jc+u6FMtTIx3GqWTCVwx8n+lcRE1Wbd/mdy1rkz7TVlMvLWQAvPwcHcXeBVhfL1oPO5VX5hux0+wo3P8gY1ycvmA/9dRON7gqDhufHT4/hRojRudFYrZwdz72Qv+m+Vc5+8XgCbj0oX45aSbZrffMrJtzexTkOps2q6w5iSm4iCgAhkhicioYQbWvnMdg3b1mEP4b2hF4nqXgrVd9e8ZGfoW0i7+tD33hxaytkywqq4W3dmi2Dx860SzIDhUkyhduOEJPPeskiSqvdR7WQ+WR3qeq8u72TRNOBf9+9CSkBQvOMWLvOq2EBIsxUcsXX2gVOg67+f6LGPlOMDdiij2gYBoMU0Vy6UFFWVxjeM1H/Jmg/BcgozVjjdWXG82duyx97Wo5WaBsGbpt74e99/1uOLsmBRJi8I9zpSiHbQzfS2qupDdUHLr/Kvnz3h72eoHNchOx4yvsGTU/FaIHe49W2UdARHHBxMzJSiK9Jq4Od3dOR200sFXa1KLRt/D5Qf/mCcYIrnaD3tFl26vx8psfsMYL5h0h9/jdcMCVSsupTWgRXKT91nMIxMzSv+XtsUAfXcN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c7ebbf-161c-4eed-d726-08df44dcfd0e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 19:00:04.0885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yvfstrkcjgcu7flZTIVvXDSDhU6RijnG7uaDjJgGkvQAPRyIIcQJcdkan6wKFtxtFxFChmJDY73TYED38N6EhJuZK8bswRmhVRrWEhvKPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7483

Add btrfs_bg_type_to_num_stripes() a helper to get the number of device
stripes a new chunk with a given allocation profile takes. Profiles
without a device limit span all writebale devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 13 +++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 72768f29b8f4..2090687966ca 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -195,6 +195,19 @@ const char *btrfs_bg_type_to_raid_name(u64 flags)
 	return btrfs_raid_array[index].raid_name;
 }
 
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	const int index = btrfs_bg_flags_to_raid_index(flags);
+	int ndevs;
+
+	if (btrfs_raid_array[index].devs_max)
+		ndevs = btrfs_raid_array[index].devs_max;
+	else
+		ndevs = fs_info->fs_devices->rw_devices;
+
+	return btrfs_raid_array[index].dev_stripes * ndevs;
+}
+
 int btrfs_nr_parity_stripes(u64 type)
 {
 	enum btrfs_raid_types index = btrfs_bg_flags_to_raid_index(type);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 891bc2432870..d48d4d1d9aff 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -913,6 +913,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info, struct btrfs_devic
 enum btrfs_raid_types __attribute_const__ btrfs_bg_flags_to_raid_index(u64 flags);
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info);
 void btrfs_update_per_profile_avail(struct btrfs_fs_info *fs_info);
-- 
2.56.1

