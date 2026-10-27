Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085790;
	b=gnkBUqV0iigzY+WpMGYbVFyHNYMFT5DTWaB6ieA3Wp64MCVNkkJlkjMQJ2C9KVC+/IDh
	 N7KQUQnyk3Ct1dBJZuycC84H2Qz6ug0V/o5+SxQXgziwHdDaxVs8nlvSB3URTkWEyJ0i7
	 Vou+IE1oIvhxBSXIN8r379G/lNs6Yv85l7Nw91anQteNQoGfwuYZKoyES+ynO7E1gzTV0
	 tXNML4699wfAiYztpOOL7iqt9AOgUayYAH7L0zc3EUfJfFNa7jXWzWORPjcCdLu+Hd6Ku
	 /K66V2zlfyNptNxOx5QXGsXh7LS29oTjYiju3Fo4NZ1QZBN2zzdAVmeFXvXY3MlTm9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085790;
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
	bh=MiMnMdcT8XfUxQ2UsEkI2ECmziz7B11+wBDAEQ4J1dQ=;
	b=OpabLFcrbCuX+GqduMq5T6dtxCGnn9dsErAx6sBkGJicUxb7TOVQUJHEVGydpvsozSsW
	 HSqit7G9S7T8elPih1Nfl/cKfKc9XvTnkcapJ590VKwiWRW9NgawgmkuqlMz4+5pRGJEn
	 GBmV/Bz5uokLTQPcI1YERSIYVBrUlf3Qmq3CisvX3Y94fBTX2gLlBBOsb8k/9bmWdO+A4
	 SkrtDeU1cjWJbGln93gJADoXYWH3m94OJ/JwobTpK25LH65Yx75mnB1XDB0+zVxJ+hOz9
	 0kmpf/PoQM1OzOSKercCefDsKBYDSaCHbLuMt4yc/e5ixISFNReBBdaFp+klL+Bk29w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=oyn5s2w1;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=O2M+Edgu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F057606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F057606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=oyn5s2w1;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=O2M+Edgu
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085789; x=1824621789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QgBOelrIlaH5jae0AhSFGjAckZ0Yo/izEeH1gVok36E=;
  b=oyn5s2w1FXo/6Q6/Zo5oo7pb6wulju5d+v29pl/i+GMF429+avODa+6H
   Uvk8zezrfZuNxLi5v+bZblF8KVmmQBbhHkqEB/sv9vyH3rzDH1FVxcLZs
   oRlslSu7UA5+35/1+vGfEaQNpKf6PY1Jd/C5g11t8razR1HDXE8EFbyox
   Q8xBdr44m7iwZaXTI1w+fV5eIzpjXHXNncp45PmKHA8NbBVzjW/yghyno
   SAxdhwi1g+PUeyZfG/WwK/h6ptzI/Wsa7Meu30QSBMjTrJe4iS8bruven
   iQ40Qm2Tw9xczDntBZYtNI9vUdE8TeiwVFcJ/NVqp7GPfmY1lTPDwVlkI
   A==;
X-CSE-ConnectionGUID: cb8DSqqoRXyoqlzhgI70Jg==
X-CSE-MsgGUID: 0gHC3i2xSeaN+PLS7lDewg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863279"
Received: from mail-westus3azon11011016.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AahtvLcoXPMhhJmtQGO7PA2D74F/2te4oYXGMRt+kgl2/SOpjj9D3qNDOEcB/8Ssa3WiFIegQ9HxzHcmrGZDkcDuNVw/CFjViQCuUkUC5/8yySN4EBlRCQEazEeLmXcPSL+InfDACEkvIx1SPqJg2Ve3e+imLw8f1TjnJt210Uq0dHyaOEkpfpe+rawyxGr8Vx6O3x9z8v3eIrnpIorytuRZHlDp2/cwvHfmJ01H6D6k/6fy/5TQhCWAp9ncRui7DM7phUvbTdwoyUJUZdMadRdXZ2L2elYWmcKO/7aSIFcimVFFcQP+nexkvC21nT12x9z7cQU3RpX3NGUiGgGAEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiMnMdcT8XfUxQ2UsEkI2ECmziz7B11+wBDAEQ4J1dQ=;
 b=OTgr1n766VRNGjhVVpwBv/JYM6j7eFjSg9nLo5UKeB4B5F8LG5ptDoZ+ZW1IPM/AVkuaff3ji8J6TPt3fCT/Sw5BmaMsc4KaCqrljPI7H7b4/JVgL5zCtpCigBRTcRYRkFppUVV9Lb/OzEAboHi16B6ljk4ayC2pSskVmOvjWa8GhIUYzdeC3QcY63uMsU/7DX1yWcAg7jCJTIasJGiQb/Vp0r94+L48Y2/zaB6kSjZC4uJRQTKhwjPdZ0nN4Rf0nl6Ai+3xfQj0JI5733NcwW74A1Fl55yaO2SfvWy/Ua/b5Tzy/93SAf4/HmmO97ZJwHdTNpIZDbmcdSf4AMxeKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MiMnMdcT8XfUxQ2UsEkI2ECmziz7B11+wBDAEQ4J1dQ=;
 b=O2M+EdguYf0ITLyZEBR0Jxvh+ELczC8YGmeiCKAiBgtZTEqUl9nScKGjnoqJjMia1FGnx45YZ2s0w4SIWm+GI7AsOwbCL5ZJQCO9hREQVHCwsLf2Fwod5OoaimeG4lSJhWLWBwmaJlZHh2FUAkAN2c6Mwo7SjiW2tWY+5SJEwCU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:07 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:07 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 18/25] btrfs: zoned: prepare reserving the data relocation block group at runtime
Date: Tue, 27 Oct 2026 08:22:24 +0100
Message-ID: <20261027072232.419318-19-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: c8129129-3283-449d-f9ab-08df33fb25ed
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|261026121527099003|5023799004|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	LLyMgfmW4P6mAmN1lxUGm19CWYq0FHLk3hgYjCAOCZVz3Bs6Slx59Xgi57NNPfAxbzX8Ohg3zjC6uIazoLtXaKdNK3Ui0LquMgQ/25XO1fplbLRuIAKn+JKVf5bvftlW26rO/xXS2RmMybRtcq4h0fWbJXeIV7pH/7A837EvxYZcG0Ou54hierRvFXJhxqujCGbinR7DFzZPnZn08SF6MvD5ig6e5A6e2GNBlDJ4blBqQtGSiJKa1lEAoNmRPH4NzHSZJ4EE+TlGBKNPXm2VR6qN4Lixk12fe4lG43Or8GmpA3OYs3Sw/19k/INo1PoG9LhqCCxznK5dR58rVxRQi0PgDPSr2lLeMHnIQQA4utlQE4ve3bj9zkybYlToyXM8YUZQJu0pPilFJ44TFaUi+KeC+bGUaSRViG78OwawU2iiZ1JuMCMSfYsnbRbBLVTc0zn5nOR3wevN9zoiSaY02yoBZFZUH9lTl27VCs+8onzvhAkuDVpB+Nf5F6JolomLila4hQ0GPi1IbXfaT3i+H9QMe3U79dUG4garnxmO8wcZuvewFYOJk4dA+1l+qdYfC/8anwpPfIcp08VjqqeumCHgr9ABBAfV+QZ1yE4tyd+SOYDZ+82kU93QaOx5L+H6/S42XPi30jSbSF4+Dsg6nCTykzHuIhU+45uIj3z/+pQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(261026121527099003)(5023799004)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u2jwpAbLmsziW7buc9+xVStM2yx2leubQ4RRT2R1Xym1R+dm3NNgKKirYJe2?=
 =?us-ascii?Q?N4dcr0Lsy12LfCqJ6boBSO1Yb+LnbOYGPBDTbWuq2wm80/1VYIv52yQ4+R0E?=
 =?us-ascii?Q?Xrxm/y7zBh/7tm9g0nKrcRT3Ta4FMP3WjXHEcNfPZrOGVjHi1SdiEvOB3W2Q?=
 =?us-ascii?Q?+vDnop+NOVzHMjLnaiXB04RP24ytZ2DvCkueFIBE6NbH14hhZZK4oPvwxRqm?=
 =?us-ascii?Q?f3PWRBxb02TcdMYRIrdNv+Yh86wzUxClmAzrz90C1+PyJCoMdBReBIajeuKU?=
 =?us-ascii?Q?L/Nv1gis8U26MQ3v+BS8XrPjSsdaAN797d17iuG71Ghay00WcvE0XcWfP9QV?=
 =?us-ascii?Q?6hf3BHzkzDJGJnYrmtmUxgOKFkXKW5EVN1rqeKEU+443es17IgnbYBI3rTDG?=
 =?us-ascii?Q?vcn3ryqRTPib6FFOozMjtCSD9luxoHL/0dmSM55eoC1rA7+a6uPUp6IIK//8?=
 =?us-ascii?Q?U+k8AhPNW43WpcK8Y17k4ok7DlolBGbP2r/rAliLTzT8bLAQcyHzvDzssCBd?=
 =?us-ascii?Q?qXIqTkt8McTA7jtiCL654QS9az4ecB7bpXoUoMYtxa7GhQk7bMkJZWX5huCt?=
 =?us-ascii?Q?u1CSfDc7sIHP4uzKyt/OLdgTsS1+fBUp3tqvf3ety8WevbTeD54rRvXmIPLT?=
 =?us-ascii?Q?W0/+JYO6W2ord371cP8RCNCpyX1+p+ogPA4zv4gaj4czekPKKqVjXTYxzmOV?=
 =?us-ascii?Q?s16FygYoTR+YQlMkhowHsZNc8pf28j+uDLd2rDLEA5l4dlQW7E6QQ60SXzEa?=
 =?us-ascii?Q?ffAlqKfN3x+Y5aZ5yCwDDzTJyiGUb6n0qGJhQ9IwNrp5cT+bOpfy6rfGOrGi?=
 =?us-ascii?Q?jApx7C8I8ptowPLo3nKjbkIygU5txlbK+gOnAkNzZbnpY4wIU15csUezLwsY?=
 =?us-ascii?Q?nTsxotc6nXHQa1CpjxVVxGngTqxE1z6gLBhJ9h7Vi6BUjIYqogH0DYvAsxi8?=
 =?us-ascii?Q?LtI0fMY0ABtvIfr/XvCdV97Wulhf6DmEn4GEL8AFGzqzH0P2ZFZPwLi9dzbV?=
 =?us-ascii?Q?+Knoz0y76d7CphTSP9USJHP0JVHenD30G/JSB2lcMsnnKDdXAH8EAymKJOyR?=
 =?us-ascii?Q?coa+puFZSx/qeR4VccAXhlbsCMjQ9bzFcpjDFUeLzvmhMI3Hruhd7r+I8bHp?=
 =?us-ascii?Q?wKz0C3wgxGMQjMrd5qKwlTKhKHLeosbWu6PSQre/4c23ZViBVHYJgVeGcuJo?=
 =?us-ascii?Q?JDqv45J+YcffXJC21LxjVSRY2DGW28f4hGqhM4jX7hHrReSKlu5ado5WW3/e?=
 =?us-ascii?Q?w8XiQzODQy5BefXbSiTE8mEG1T03MCpB6atMOaOn5VRoEHv+PoYu6gwoTFJV?=
 =?us-ascii?Q?3DfWeUS+o4RsXciAlI9rPkaSiQJtLDn0G1bmUljutzVzAToi11jAdU1s0EQn?=
 =?us-ascii?Q?XA1h3AbijYeviScOt0tV7xDVQqj+c/VoAIAfhNGBEKLcvqF7aqVU0QcCfytA?=
 =?us-ascii?Q?ia74IOSXX989DEtpsnamCVo8F+xz3pCL/O80vMm8lyFZQAc3u8FqrUmaL8K7?=
 =?us-ascii?Q?VxkbG3zp7c8uOrNH83VKW2CV0OCaXRs6DDqMbhw0KbO3hGHptEyX/yFPvKrl?=
 =?us-ascii?Q?2KXJDPFG5ltqGFhvMXonQKZEtcGCABaJ+PRG4IVZJ7GnIA+RxKpaTvh6L1GW?=
 =?us-ascii?Q?v3PEVVvf9OsU+zGUXeP/D6m2+u4ET8RMKRvx+zAtwPpbLQ1kaAtN0Focgqs9?=
 =?us-ascii?Q?9LXJVptqsAaJf84yoIMAtG/iKmRbNB54UPL3GdqvMbpoyHZuK4JR5v6KaJ0t?=
 =?us-ascii?Q?fPUCn+p2bCmxWj8eT4jeMRpXQ5zHxMsGgAnBuBioBvbIFsI2TMhB+mOQ2pSP?=
X-MS-Exchange-AntiSpam-MessageData-1: I6fheVfDiQSwvZlJoM23mIh7vqBoPF8pvvI=
X-Exchange-RoutingPolicyChecked:
	jd8q8Kws2keBBRNVyJUT+2L2UMRoTMdnIG+HnEH/KxvzGWSskNvYRnHkwXLAmihBOGTF5hqaI4ILI7IvYrfU3rac2g6zNeUpzfdvHVrDKlIyuwoCNd2QolFeJNxo6Wn2RG9zzrkn8fuO384e9Za2VGBFQ4NahB3dvtCGchTZQ+MvYZ/D2pshPLCUCIzaGuHUP58+PJnrP9I591PnY+ZsYXblYcKu9dizINrUlw5uv/IYWcso/7XyOWDMNYUg1A9biugGkE/5GH04C2pqNsa3QfMdHQtvJHkIrnX/WxIvLq+cdopFQlIQwvI+UH2IQZ9MVAKUYq+nOio/xouq8xbgJA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3m3HGGVgP/g7/N6pjXKsuDuXGq/43PnQNFOOOQTmbnokRfNQBDytWXVG0sKBm3UVbLCcnjTtn1kUM3UdkFBccBSgl1etnH+7QbJcqS+1D0exPw4vUVN7E1F0f35LW7srPqX/jpX1xgvPOwy6UavE7s9gfVpKBe/vJhQmHkFQjAp0US1NNHXkI1CdWEj9nN9bz0tYUbGuQUMbsI3QlIDKlWiFyhQDT6gQ8neKWbWS8H0mVi8+ueRVOB+UMttU7kpGrEoHKYPtW2a4cqYmlQb57g/zFV7uOATyRWCahj7s6WWayAKV8L9t9r8MeyjBdmrkg21+rp2oQAMEgBy1zhH+QcHtHAxuILO+0TL5HP31jMPvNOsP0tF97EdHNtBGlgmlyrybQpS8zq5ebtZ0aL37oQ/haizxUH0lrf6Hi6/4z3rkYToI1a+22yd8K+GUaMHVTBbBp4vmCqOLOb9Fm42S9TY/lBrxfzNfkOip/6k3B9jsisU3fIO40MzlWe/H/ObxDnx6A0CgYBwci5tBlQz+fFTjsWmh74ZAacG4W+UUwxQCYux8mZZvPm0eVTKpua/IUaFrosd/sIfvcdKfsJHf7TTX9SG2AvS+twa9JlInNDefgQfD/yK14zCQUVHfHVCA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8129129-3283-449d-f9ab-08df33fb25ed
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:07.6840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: izQRwUme2PtxmwCPwXNyuPKAzGVmGZ7qG6Zex+3QSsJ706uh6HLkcIOuY3sgpujdLDch/6Mt/McxhRnnk4QjPn8GuXQ2sO2NMJQ3UPVWR80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

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
index 8a94f7cfa1ff..0857b24a3169 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2905,6 +2905,75 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
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
+	btrfs_add_bg_to_space_info(bg);
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
@@ -2976,7 +3045,7 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
 	struct btrfs_space_info *space_info = data_sinfo;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_block_group *bg;
+	struct btrfs_block_group *bg, *tmp;
 	struct list_head *bg_list;
 	u64 alloc_flags;
 	bool did_chunk_alloc = false;
@@ -2996,46 +3065,36 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
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
-			btrfs_add_bg_to_space_info(bg);
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

