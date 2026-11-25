Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602680;
	b=ibLD46XEtr7OqiPhD9Z/8IGVgUSNVQIYNKYp5XJmouDpcBhG5LBVchel8NKUMO7A+6Gz
	 LYZbDff91T2a9jZljanL3z+w1JJi1u1CSHF71wKkPkhAs24TuxVCee0T3CMxoWPrxxqdN
	 ikrdsO8CYr5uS5ZH0L294AqaZnj8Ssw90twqBeNXNtOKWle/GmUvfZbxognYnv+2qkzEd
	 YpyrAQfLuesgNUr3CkrvAm2waK+zL97pKQxsEw/yPyCz9OPIc0HebCSiHlLsey2hUUyn8
	 HdzV+1rdQGY7o+5bDReVI538C0dpl8C+ITOrZYBBSAbhL7Z1NR7AN2U5XhKrQ8jmCcw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602680;
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
	bh=RwSGD17/qpRD7lOCKDWH5OxUnmM7y6xjZkePqqWC2FY=;
	b=RpvniigET7TI2lh6XAZnPt+6SKW8G2ItK4Bq9b/1jVADnaOzoZGnqrD+VnGedbw9xtmj
	 a4MqMdrchzJwdxyT2DtxNgIqJHp3Hf/3d30Trx+2dtlf8hl/OeVxMV2pBrahcWi98i8p+
	 /PZQV8ufxw8cG5GMgSkyL3KvpuWKUjKJC/EKaaKxbBuPuCHo66SnGgRcq9r3NgjHmkRvd
	 uRPDUflpqqiaLybesLwS/mDifdV1A89qZ2HAc+dpzcdqWVzKRD773Hdy2ggK5tKzcOxAo
	 ydthHhB1uoPIpKciuOZadTlPDROALhrYDR2tGQunhohcq4Vf711ax8JNBLh4q6o7NUw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BmfeVD31;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=PU7pd3J5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001D7606A331
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:31:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 001D7606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BmfeVD31;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=PU7pd3J5
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602680; x=1827138680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nlh137BBRg/epx0ChV8oayBdWsqbVBnm5snHKPatqQo=;
  b=BmfeVD31yg1SpFgPa0TEVGJndJYgVHqKqN40HpvPu6mp31C6mhgFMn2g
   C3F0gocFydCBUtZ5ualw8h49VNE3dzKh6qj0N/e9TLDB5kYaCHXMkeXLa
   Jv81Z8W4eD3g4gTLOn5p1ijgw/dptVCUvmqlDj2mm95lx25P7nCkSZgkX
   nCti4WBvQ2ORUO8sKQS8BKIW+v5EhDO7iAt+YqGmG1iUsEPa0xIPAfUpZ
   CCKxwh89qjNO2Tg9lpeKkEDX1hMZwy5w2SJRfp0l3uaYPbTLLceZV4zyG
   Cl9y8jMxfcszx3SAA7AOE+kKsUN8aTou2qv322UGZZ854olLWYQbdfuvq
   g==;
X-CSE-ConnectionGUID: 1Kx8jNpiSGmfQinC7iGcXQ==
X-CSE-MsgGUID: lPF+lPJyQoGiXwYOn52aZg==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492475"
Received: from mail-southcentralusazon11013004.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.4])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:31:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w4/1YE4VUt4jkrdOcdWTa6e0yT9drZe0eI82aQuCj5Whoutx/5PTwySoz5c0MzA2fSCRA4sCNC8zWjDBKiXyjUbEdsDpSqc5QzJO7Bd6sZaspemzJ9kta29u7FxsH8saKZD7t4WpA7W/ke0YjpBTdjGEBl9PBmtdpDGR1hZqJI6YFfRiuwh6Do5DLA2ovezEO5/R3jhD7tl5FvnJNQ1KbebT9Jllbxdttb/ugZYkawlwqMAAQTHalwNJYFpH8Xg52MxN9MhXdLeOsTu+0V2zSFaUebfNFiwwDwnY8ngaXGsJfFgs3xgMmz4Ls1/lB99g4Ub0O/e5ejyCpNkhWLFaGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwSGD17/qpRD7lOCKDWH5OxUnmM7y6xjZkePqqWC2FY=;
 b=LgG0ECtHehK6npevuo63sBoREQqeodVHE/SBr3SdLc+I3sFRUZxFVJUuQsZ4qOMFlXPe5vLloLxdFiLlHedveveTFds7ZIF911sf5UmFYUwc/8dWZiDskxoDL6L9B0dQV2svTvdFZ/zwmU9tsjzBRvw/kkuVegzJXH0MV5qpaRB4E2qUz49g80BgV6w6T8woimN+FE60KfBt/OY1ndvyeapqL0tGo5eNHp8ZmACioGKEio0woRweKDa3eGMGJCtefJYNgtBKRoJ34boODIS9L763rpzjiOXLPmsfWeJIjpyHqLkXe4hoWFbEwkhU5YVD658lJmAlMY7igLrWv6pf2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwSGD17/qpRD7lOCKDWH5OxUnmM7y6xjZkePqqWC2FY=;
 b=PU7pd3J5hK53aB3CsVNagzhgR3R6Hyk8d9uWEjkWzf6odAI/NuU+ompbkFvtCVRc6UIuLzT40CZ9qcF7tyK71UxO/k2y9Pi3JqnpEsv/VOpCT5cTfNHv6iRzkSFMpN9Ep6j93XEn6Nq+4TLmq1GLzf/sjbAlUMEDxNvGelMdSr8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:31:17 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:31:17 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 27/27] btrfs: zoned: provide zoned specific reclaim sweep
Date: Wed, 25 Nov 2026 11:29:56 +0100
Message-ID: <20261125102956.266389-28-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f96529d-19df-4f91-6168-08df4adf3d43
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|10067099003|261021123027099003|56012099006|11063799006|261009223027099003|261026140227099003|5023799004|261102123227099003|261021121427099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6YlN1nw+rAjnstBAE0oJFpnzyAPjqIDsTBaP0/QDQEcCY4WDAeDsEK+PlPO4yZiyA6Frs6uY6+pyg4JYQlR2bzvY424iCmpe7ESKqI/kxD1WNDQjzCUIJUHHArxlzPAaq8Ve4QbX5dXNNx2KxBC3pw8U2rXhYr9B1e64pHB7hsvA5r3X+eBndXJQMh2msB5hAc/TbQ9iTDnAO1Or7khL5NZySeEVV4UgkfcQjmkRmx4ip12hJ0iSyX9HwHlOdfG697MEAyaQfPK15XmAKS9u+gsWM96XLfzosRHUPCUSY8qef/HFHMyNNRPiu+N8H/SGlVBdLFLNRCA+c5f3qLbzSIG1DvPDPapB1Nuj2Sz4XrQjDldg0qkL7kIOHPVVPnknHFGYvx6P4B3lXQxZ5mF9ZJq5dfHpLMDJz5YdPeaazoklBdvuL0ctytSKTP0WRHzs0qJ9MAypgQkIJgeSbeXMDAiPEssQHSM2sLcDaljgzMgvtcYs/XGK1BYgYc38pkkfhhojhs7U8cCukuUaJnZtt6SRRWqIc0jjBw1Ai8tvrFp7Hb328iLizVDOb74ijQUqL+2Th+3m9PiCnHHLrTjHDKGiBLQMx8/m3HkvvsuBkDdn8xijB+CRNXLhWB0AXNOkqTNACHin9q6cZRajpZrdIcplpJifGIYTSfVnoXCQwMU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(10067099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(5023799004)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pln4F3+UCohIziKjA6G/1B34uhVnTwfhjSQ83qwNiaZubqDgEgbF2kWgracT?=
 =?us-ascii?Q?7NZ6La+/e+C82z2lTKw0bHs1jVNuqF/bnWSJcRJYQnQRkXgwyuv+ZVEKqIIW?=
 =?us-ascii?Q?zf5RzS/4r5xOZlJljOB5sgHgTAofELuYpewdpriyqOrXmtIhIi0uP3hCi2Lj?=
 =?us-ascii?Q?aG0SCduolLDBJr6xazM2mNIY603//tB5mWLePB33Chy394+cWxC+IBrWV03n?=
 =?us-ascii?Q?fh6f/72GK4rZhxI4lDI6/oLOz6mz8xidX62tvUaMWGmDrdW0o/uwEj+BJYKG?=
 =?us-ascii?Q?3aNcgGzLCZBFqnk2gX6C8FcWcSiFOi/iYLLFzhetgoLreOKfkjn58uRhGIQ3?=
 =?us-ascii?Q?YwmohQm4FBC7U+fsRTtpq16BGOALAC/XBdXp9i6rXopMpbvGOiFRxkE3NoXW?=
 =?us-ascii?Q?FquXugObZl5m2BN9hmkeHRqlWtJr6tbwIh1f7Ol4kTD0Dtyn+Ug5Qea4qCpT?=
 =?us-ascii?Q?JDy5sVyw8LhLE9UQSt5ry8PuPl7XR6U6wK8n9u7bqMgcGHw6Ts0L+tLXTAJQ?=
 =?us-ascii?Q?2Jnawy6XgKedVBS174phhuwHhXqStJxz2jkGGNZCyOh4I4kHglHtzGB0QBP9?=
 =?us-ascii?Q?mTzHAIdTQQlv+txINxsiLAGlcfzIOdfBOo43IYdAnClwhwcHQ5nqdAjdwDMw?=
 =?us-ascii?Q?3lM/XvxKdtShQHhsB+lsYs8BFaQCZM3BoKhhBNTU1dKzm3pPavaVFpBA3SyK?=
 =?us-ascii?Q?yocB+Q2NpWU+qmFu8wlHRbri/vZENNCGD+hAc6pQbS65e/jdllxVAAJSTiBy?=
 =?us-ascii?Q?dCwJWxCNvYSiWvxy9QtzT94aIy96+TGKtAquZcm8FrwfOxb0h/QsVT06kTXT?=
 =?us-ascii?Q?Xpg4mo2fxJ6uPfS8sfBprNs1SFaJTTeKhTqvwZ6dUmh/NRkUalOT9ei9bmiM?=
 =?us-ascii?Q?7DC1mqmngPugsLJ4z0k4EQ87ShURYeWPjZtrwyH/8XI0Z2eK0+S4puNMN91M?=
 =?us-ascii?Q?Il97NtspcyhappSEwb5wvgkjZ60YJmtESWt2w43WrRDcmZff/gO9qumilA9a?=
 =?us-ascii?Q?/5u+CLL36JHFmzkk/yUgO/0WcmZmTvdbBkOFRXyE+WgqgtIEgabtc8i7eqrC?=
 =?us-ascii?Q?3JblsUoOyYgrbfziw6Bc9Jgaye6VNPcF4H8BZMP0RA8ZXNULqVhQYiYiY6G7?=
 =?us-ascii?Q?cy71WUntf2RHO4s24JH28htIRg7bLZKCCLykv3P2cmtwwxF0Awwws3o5OdNd?=
 =?us-ascii?Q?pSSzyn8hfsl8OLI1vxTgnj3P/FDQbVQd9yZ5UPUyvfglTAB6Y5Bpvm7a5zLG?=
 =?us-ascii?Q?y2D3X5Q+kMvnf5MYRaWBz5MqTWtPlYpdsRRcTsBHU0mTxNsfj7kw7a6EwHxa?=
 =?us-ascii?Q?dINzXQ3dW4LtXebTtvKH/R8xzn/HEe9Hy/fxUYE+Q4CJV39C9X27tPltZiyJ?=
 =?us-ascii?Q?Gd1LAp0v07HXU/ek7GrwaO0tbxcqHME3h86bWinr9V/OL56locklptvsQIyn?=
 =?us-ascii?Q?ebF1L95ibz9B//cz+goKgxQ7fyaprZ72ctoo5jHF59MYaIzyLpQQHMKhNpb9?=
 =?us-ascii?Q?+FzRV8rP2LnYjJcs7kzHzyngn08QKyhQ7TzZCFXjlr0Czb7cf3EttAyYz40u?=
 =?us-ascii?Q?ZJO78bQCaTa31CUyHfSLrzzSr2ub6qdqONU/6bGEcchIRTSU309p3njNuqzU?=
 =?us-ascii?Q?B+fgKoR6BhgJMqng6RAdRWf16yvy3nl6i0luBLaaMWYKd+U2J/SDd3sdFE7r?=
 =?us-ascii?Q?bxQ8o/cY7qkuSoaKU1skdOoVHaVwWXEEMrKHn1bM7Iz6pEp8m9TLxHrK1Gcg?=
 =?us-ascii?Q?hcXnZ/9Bgu98BF7vwBAQjEMOWmlXbkErEgbGNvsQFoSlRIfLNqXrduykI6kW?=
X-MS-Exchange-AntiSpam-MessageData-1: OfdWFSpu10Wrl4I60A00iuJ4mswgct9LEG4=
X-Exchange-RoutingPolicyChecked:
	GscyYn85il//PSDjal6wItfIrLss1qM8egKODdo7ZP69qu4z2JunK2E2CskhXj/ZC3EtMPR919GXbkEd67HLsXqezP5KrYhGy6uGPcnw5m/ubMCWSiHlMo6VucPb4s9ZF5Zm3g82vNbveXugZGyQl2p5gtIj5PW9RflcLqg1wGhFavdw55nzYyjhr6+G9/A0nnS/kJDRZBx0XcYDhtMO1WxXX33Nmtf+oGIL4+ybuRdyBvRSMvRGhiX+VvCX+am/nvEFj2ymITQux3uKU3dCCbQWJeJVYhhF9wT5iNUIWYWkZq1xFpJrD+wVI52MVbC/agS0KmtXhUySEHnoJ1wvTQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YGwJ1t0uPDf0luf1giJsRMvXhY3O2YTC5swwnk001rm7KnJ/QxzL6+u19IH5L1J2xVyBLXObH2V8XzMmLhLazhbcebuUskXmu2ukYRG5KXKw1rzuRm8u10kgnvcoJ1t8wq5g0mD8QYYo8/9Se9/I2Zi2ZkWA3M2YiA5bRvBkfCDLnkEGFcDOOoTUgxIqp7FnEi+GfNAXUf8mDCmiQSk+C3H/wocLkyCJBHFuC6L27EpH16NrGtGpyBUt9ycO4xVbnEkdIwkDpBVJQ/6fv31eISZq55g11W6eUuoQjBBQZIF933Q5TUaLr9vpBJ33zcjJeG4Wb1harBjt66MCUxO4hzpXm0C3NSE3hVr3//1kGtvyf1h15ix9hy7mI6LG9s0PNikULpXGeDS7Qgm7C8JyN6ozLRfiJAJcPW2Xj7PY6F3Gv+qLwWUV0k7PL4zSm5HF3+RZnK3nVXWm/luFx3gZrwl8sbbTshHUVawt6P07Bm7KHhGjMuDKjw0/pn/oN5TEcWoExuDNuAqDyvs94gzfS7ajKsb266jlDnCNp582f0TCqjL4ncQ3Ex/UMP5gmWgirOl1SJOzyd5H9h3Xt/1tJSJe6uTnbjgCFtzyn0nbCAPj27y+mdqch5LoitS9ksaZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f96529d-19df-4f91-6168-08df4adf3d43
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:31:17.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zg6l+mdrPy14HmKQgRpxLnnHbEwiuUFxHjuQT1rljZxUSx3Gz38ubz6GHlGpyVHmAHuWhnkn41hl2y14D4u+5mBFHTPniYrHuQBAu+loe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

The RECLAIM_ZONES flush state calls btrfs_reclaim_sweep() to find
victims for garbage collection. That sweep does nothing unless periodic
reclaim is enabled for the space_info, which it isn't by default. And
even when it is enabled, it only queues a block-group the second time a
sweep sees it below the reclaim threshold.

Apart from that, block-groups only get queued for reclaim when their
usage drops below the threshold while space is freed. Block-groups that
were already below it, or whose garbage comes from many small frees
spread over the filesystem, are never picked. With data tickets waiting
for space, RECLAIM_ZONES then relocates nothing and fails the tickets,
although relocation could recover zone_unusable space.

Replace the call in RECLAIM_ZONES with btrfs_zoned_reclaim_sweep(),
which:

- queues every full data block-group below the reclaim threshold,
- then adds the full block-groups with the most garbage, until the
  queued garbage adds up to two zones. As soon as the data relocation
  block-group fills up, relocation uses the zone kept free for it, and
  the waiting writer needs another zone on top before a new data chunk
  may be allocated,
- also considers the block-groups of the data relocation sub-group, as
  relocated data turns into garbage there as well.

The periodic sweep keeps running from the cleaner, adding an additional
layer of garbage collection.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c |   2 +-
 fs/btrfs/zoned.c      | 123 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h      |   3 ++
 3 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index bb08294cbf9a..22b5ecd8b464 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -914,7 +914,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
 			flush_work(&fs_info->reclaim_bgs_work);
-			btrfs_reclaim_sweep(fs_info);
+			btrfs_zoned_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
 						   BTRFS_ZONED_SYNC_RECLAIM_BATCH);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8db1e058e178..3dc6bc30f8a4 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -6,6 +6,7 @@
 #include <linux/sched/mm.h>
 #include <linux/atomic.h>
 #include <linux/vmalloc.h>
+#include <linux/sort.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "zoned.h"
@@ -3839,6 +3840,128 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
 
+static u64 zoned_bg_garbage(const struct btrfs_block_group *bg)
+{
+	const u64 slack = bg->length - bg->zone_capacity;
+
+	if (bg->zone_unusable <= slack)
+		return 0;
+
+	return bg->zone_unusable - slack;
+}
+
+static bool zoned_bg_reclaimable(const struct btrfs_block_group *bg)
+{
+	if (bg->ro)
+		return false;
+
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+
+	if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags))
+		return false;
+
+	if (!btrfs_is_block_group_used(bg) || bg->pinned || bg->reserved)
+		return false;
+
+	return zoned_bg_garbage(bg) > 0;
+}
+
+struct zoned_gc_candidate {
+	struct btrfs_block_group *bg;
+	u64 garbage;
+};
+
+static int zoned_gc_candidate_cmp(const void *a, const void *b)
+{
+	const struct zoned_gc_candidate *ca = a;
+	const struct zoned_gc_candidate *cb = b;
+
+	if (ca->garbage > cb->garbage)
+		return -1;
+	if (ca->garbage < cb->garbage)
+		return 1;
+	return 0;
+}
+
+static u64 zoned_sweep_space_info(struct btrfs_space_info *sinfo, int thresh_pct,
+				  struct zoned_gc_candidate *cands, size_t *nr,
+				  size_t max)
+{
+	struct btrfs_block_group *bg;
+	u64 garbage = 0;
+
+	down_read(&sinfo->groups_sem);
+	for (int i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		list_for_each_entry(bg, &sinfo->block_groups[i], list) {
+			u64 bg_garbage;
+			bool below;
+
+			spin_lock(&bg->lock);
+			if (!zoned_bg_reclaimable(bg)) {
+				spin_unlock(&bg->lock);
+				continue;
+			}
+			bg_garbage = zoned_bg_garbage(bg);
+			below = bg->used < mult_perc(bg->zone_capacity, thresh_pct);
+			if (below)
+				btrfs_mark_bg_to_reclaim(bg);
+			spin_unlock(&bg->lock);
+
+			if (below) {
+				garbage += bg_garbage;
+			} else if (*nr < max) {
+				btrfs_get_block_group(bg);
+				cands[*nr].bg = bg;
+				cands[*nr].garbage = bg_garbage;
+				(*nr)++;
+			}
+		}
+	}
+	up_read(&sinfo->groups_sem);
+
+	return garbage;
+}
+
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct zoned_gc_candidate *cands;
+	const u64 profile = btrfs_data_alloc_profile(fs_info);
+	const u64 target = 2 * fs_info->zone_size *
+			   btrfs_bg_type_to_num_stripes(fs_info, profile);
+	u64 total_bytes;
+	u64 garbage;
+	size_t nr = 0;
+	size_t max;
+	int thresh_pct;
+
+	spin_lock(&data_sinfo->lock);
+	thresh_pct = btrfs_calc_reclaim_threshold(data_sinfo);
+	total_bytes = data_sinfo->total_bytes;
+	spin_unlock(&data_sinfo->lock);
+	if (!thresh_pct)
+		return;
+
+	max = div64_u64(total_bytes, fs_info->zone_size);
+	cands = kvmalloc_array(max, sizeof(*cands), GFP_NOFS);
+	if (!cands)
+		max = 0;
+
+	garbage = zoned_sweep_space_info(data_sinfo, thresh_pct, cands, &nr, max);
+
+	sort(cands, nr, sizeof(*cands), zoned_gc_candidate_cmp, NULL);
+
+	for (size_t i = 0; i < nr; i++) {
+		if (garbage < target) {
+			btrfs_mark_bg_to_reclaim(cands[i].bg);
+			garbage += cands[i].garbage;
+		}
+		btrfs_put_block_group(cands[i].bg);
+	}
+	kvfree(cands);
+}
+
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index ddbc93d0b8ad..7837dcc91684 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -121,6 +121,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
@@ -343,6 +344,8 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info) { }
+
 static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
 						  u64 flags)
 {
-- 
2.56.1

