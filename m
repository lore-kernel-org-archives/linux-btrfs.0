Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602624;
	b=GEifzGFsNhT/vUYrazzusJNU8lhE9tKFj6Oh0wFBnO4Q0fMFslUo68dYpJVNH3dKyU26
	 Ug7APlm8ApW+vYrMKOb7Lx/5drBaVGY5DnFA7fzY5Qu62nh2B0cUUdrM1mTjDpH3mhK9g
	 zVIg/x3+Y39Y+WuxD6kLC4ZFOLRRN38kQfM4bZHhdy2gE65DBP4Fi8Fn9M/ReYPVjoucF
	 zkdjZTnTyOBnS2bAUcyelO6Q28dm+NTr8/xYIz9M0i+UPzYLxIsOWZ6Atg2hh06HSjREn
	 d171PeGFcK7gGJ8YZ1Ji6Xwanx78ZjGKf3qrK+LL/DP1DV83FRY+Ta72A2Suo2ypFeg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602624;
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
	bh=lvx6l46HKC+//AGmwPzD1mGXrzN8MaLmES464Fl45co=;
	b=bpBv5C4d7ClRk7Lsd/+GWRLk2uj2bCQDKknpZm3Z660TBdC9yUXLs35O3lhcQtI4jZFJ
	 R7+Gyiap21k67Wx3K7o58Nce0iKaxc4hg5AEt1uAL1xif/Yr5HLkY+KIKyXxpV2le3qQT
	 ADKZd8Ck1jcYS8h9v/ileQjWxTb4VMfa3+cJM2FCsa51ViL9yCkPAEGbOOf4jjNtREwNB
	 avBu33/E9lXR/0rHrzE89PxzOQ6EFLw1sdIiWhc3xqF9J7MPgjdggb64barUkM+DooD/H
	 uU7tvlcdbum7MQmjkQcEYea12gkSgTcS4z5TsUjbvuY0H/wHpwOxNvNJp7sww4EnYNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=IjzvOjR6;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HkSTp5+J;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618FE606A32D
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 618FE606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=IjzvOjR6;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HkSTp5+J
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602624; x=1827138624;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+iYLQD96omTkjz/KI7kICTI0v+iGT06uvSoBUmAUDrU=;
  b=IjzvOjR65mrgg1vM/1DFvPx3wnXTqfImJwGZGipiU15wXhWcJjFZl1kO
   mmkNJKnAwrxiYwsf3NpRFMiEtxD206ZWlzWHndrzFgR04AGZvRoovFB8j
   FT6Zz50i6TgSU5JE0Zd6y1+lVJCInLnCHJNZQF0N2kBnnPsNs9rfIFFc+
   7Xj/k1XjNQhqh4Zax6XNu9jm3u3CU/lP/qDb3Nfpb9WMvND1J3FFSfIdG
   qCw6mYquR/PoOoPO5K7sWRJYPabUYl++jS04UrEf5faBIcycpVn99BeBF
   6qancO21TQwI66w4UsqXNya9E2fGQBh/92rH159bwzR1PTF+gW/qhEywP
   Q==;
X-CSE-ConnectionGUID: Z4cdWqCMQaisiUSKFjI+oA==
X-CSE-MsgGUID: E7DLaHMgTUmmsyK10bcrgw==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662129"
Received: from mail-westus2azon11012067.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nr0STz3uwxVpTjt73jabL95E0xSqx92T+Y52PxKO5tPz77jqvq/jGdpN4YaWzVtehnMbjoCZJBGPWBqSnO+A0XXafgmD4FvOle6oeizs4ki40RTLYRcgkHFv5fIHeEgTsmYMA+RAhi2nEsU8MsLJW7yUNZ4RQazJNOVCTPljHgnU0cgUjcGu/+TGBNQAZAugDGe+rlqZCLFwUgUeK99sqfK1gR0Hrv0/A8uHRH4T7eoMUN1yW3aMd9dWP3HzCnh/gdC0sKu5egJwmKHVxbX1r7Fumde1DFcaStzOWXpnDrueJfRSudng0MrBrOzJAavFvx2nS539pBKgti3EGP8Psg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvx6l46HKC+//AGmwPzD1mGXrzN8MaLmES464Fl45co=;
 b=q9xUIPP1WwGHA7CMyjV9o4b80BUX8TLTfSiSpR8+0ZazOJucdlt4ytGSyLGAEoIiT8EiWvguzWqbOmRpVtlJYhrWfJmEZQUxTDHOw2uDfs8RrbF2PlvRSxuxGWMOKEtPDRPfWzhM76wsQGSZVQ+FYlqlAMf2dVTCcV7XHvoFkP02HSzEZikQgVmiA4Eik6FOHyiftU0JD29Dp959cVHUjIq4ZuY5Zcs6ozv8xvJdreeyU+gBOzWhO9wVBYF2MHmtEoIWnGA7/K1pDQ14EZl0S/iL67XvIGtZpIjaFakM/6srwvC4KF6aC69Glmy39IQ+kcaxRA05b4/lsGkkwvvmeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvx6l46HKC+//AGmwPzD1mGXrzN8MaLmES464Fl45co=;
 b=HkSTp5+J7OiP5j+c4YkaeNfvMutfyI+2tWxsxNEeqlRcUqA4hx9Ppezb/DZg4wrkk76lTp0SupklZyETYh7/B1LPBYTuYlCiy/ohCzsx6TJHQzMix0Q9hJvrRYTN+DOhvkl+9LJ9q7XKxdxmSX6c0I+Uf049kdhhSWCIAAxra7I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:16 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 01/27] btrfs: zoned: don't wait for a zone finish after a filesystem error
Date: Wed, 25 Nov 2026 11:29:30 +0100
Message-ID: <20261125102956.266389-2-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7b4df711-6520-4538-80f7-08df4adf186f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|260925022911599003|260925021911599003|260925021311599003|261022105027099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	NST+sDYGmPBBEQ9zL7Vmww4OIKMsZyfmOqFljFCGj2i+M29ExCKMRvz0Luus+HT5Uu84oIi8KlZkoRLuueWL+5Zpj4EvIg3cJ3QLRTDcTNv992NljmDoBgwQDo0PvX3uPkAVYUdZPsqJ1HTrtXYKAh/MGipTe6iEVNOR7ecRixFoWzrOuwpcgbqCF/1BuBJiGcw6iEoXioXCq/rcTzacJWLOPuIQDJq//TV7B9aghx458zWfd3AgTpXdEaUOzcJ6z+mpeRyvgDAVDohncmBVuzGgphKKELgJoaJg6w3HMD7e8oEgxKGCwsJSZHbn5I1+4uV9xL7BynpuFi3o/yqlMgxzuAlaKrGtqp6czXtMu7AgAMqNyzAr5NbZF3gvFTARLd76KRrMIhUvAp/6Y/0+f1EDwdH6cwetjtm9NZ9uK2ChmBBmXFBKsp7S/RbeEdV+NbCbps2XKu7P3ywdIBosXGf9cttDh0zh1mbMIsxzpF4JjHPcywuO1TqpvhQFVByve0Ad0plVkzQtrcJ1Labup5fJyLkJyLho7rolrzVkxAsdhdU507XXXMboFwcyeKD+O5acMpUKLgKFSLn9dwts4dI58NACaws1TMHchM5hoREruhPWNMomGA2rp0jWMFseucl1W6JiqYM72PIIipBzQXeUAMZPHOs797PNXv2dyoU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(260925022911599003)(260925021911599003)(260925021311599003)(261022105027099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2JtJ8WI83mSy7OjgADEyblK5I/Peoo8N5jfKQC/e+fUycyClwGIpHaIUguz0?=
 =?us-ascii?Q?wAVPLqzJcDK0UldGKtRrVGk9KIeWbMAiuz+re2BhLyFoEintS23U84J6UAIj?=
 =?us-ascii?Q?5opg6X6r4sKYVrTQBvcAiKDEv+SqEeONeZyxR1uPXmFBzFnjCGsYl0TBix+M?=
 =?us-ascii?Q?EcpSyhaWrHMNrQAr609CGbtB4awN9SVZHVTI9vf6WeT9PGTaAeylJ0ba9Jkf?=
 =?us-ascii?Q?vLB90k7nj32k/RxS4iDlS2FXing0aJdPtzWO73cvAA4NPtOh+z1ExZCvECGl?=
 =?us-ascii?Q?XQxB8xt3LRUjlFs0Wt3xL9c5I8wuZA/oGQ2YIZNWKMgUW27J/JP0XVNnhnEV?=
 =?us-ascii?Q?UfJgwooE1pr49pLLSL38jVIquqK0QWmNql6F9Ypl3XnwZpTY260mO/Uozqk0?=
 =?us-ascii?Q?pbYOrLWCjbgVrYjHhvkhvw2Z1Ph14T0wm+5vbCFlVeu8s+DNxf10j/g2V361?=
 =?us-ascii?Q?lvbmDGq38dDDFTMx57FKbDHiOhOrq9CsMJpmNBsKr/F591z4jY6vjxx0Oehz?=
 =?us-ascii?Q?Bmh9x5PDwFAjszSzl+8i3e2IwpeHrLupzxkckSfD3Cjm8C5Z1QRUauyRhBhT?=
 =?us-ascii?Q?qyqr/MDp1SrojOf0pgJIGmtvYnwdEY/fuongLILewJTuSUO8H1z9pZzpqWR2?=
 =?us-ascii?Q?tAG9mdHaZEPpHcDO+utJf1VphyaNxe+0g4sodkPNMuPLsr42oll5Zxi/32if?=
 =?us-ascii?Q?A1cIY3S49SS2sG2D0/BC6KPaN0Iu7BaNXB7Ve61MvYz+5c1ZBPnYvKfnwjuv?=
 =?us-ascii?Q?E9fMYwIpAp+/VpQeE8CHKXNg+nkoFdeD7AZEtbauO0k4QQFusR7e5VRkk+kA?=
 =?us-ascii?Q?9nvplKJi53P4eGriGjIUq4HtcquwSk5rOZJQ9rNNnpcKCpfviQIMzx7UYt+0?=
 =?us-ascii?Q?gA6vLQKTuZe3IfQLNW9gsHGWcUrqBKcgFViuyDSgsUELXE20AMsrK8G7sXNU?=
 =?us-ascii?Q?Mr+Oyh45/WeubwqNvk6KpwwAhdd1KZfMbbgGINBWadY34c3Msz3VzLVcJWZh?=
 =?us-ascii?Q?TxQ3RhDq9cWdU2PTGVXC6i/5IyObuXYvRLpRFs/nmG1Y0kOUa38dmWGm4axh?=
 =?us-ascii?Q?dM6MRuci428VmHuVm2kEkTVRdo3HKZeDlwaJY/2pQYVU7pMpwDeXh7rBisy9?=
 =?us-ascii?Q?2NLh9MzsM9ClrjqV+TylFj9DntInuyeQDyaDAmGqlrKaXU0J3nl6gETo2BS8?=
 =?us-ascii?Q?IAcdVOWe7hwvaOl6+3FRJm46/tyG0YLF+4xX9AxahVfLDMXUuzIng1WciL5n?=
 =?us-ascii?Q?Qwn0WSNJl/q/jimiZBLENkpv0r9CwHn5D+O30ZdCWdfurgT3PwKlKISNtKHu?=
 =?us-ascii?Q?FDkvayk45KZXMmf6cwbya8EUsOxZqALvGs/kIRhK4nLPHm6OUXF+QWdHtxYn?=
 =?us-ascii?Q?oMpi0D+EF7tFOw9g/XDJIVS/TVGag8eMiatJzofwqrsfXUgo3L236W50X0KL?=
 =?us-ascii?Q?e/PdxIo2SYDixrNEt1Q9R5q1Q7Erdd0EtZVRyXbPwSY5UoCjeUrmWXxeDMnz?=
 =?us-ascii?Q?UFlGExpAa28923X0Zw1HJVEXFknq3xeYSp+/ZC6OHpD85wmErPylWfg+iIsR?=
 =?us-ascii?Q?aNh1Tyxau1j3YdgQQzysKT/Gi3JrQGDZbP3wayKBwUq3snnVsS1D4jaF9TRl?=
 =?us-ascii?Q?hPYvEP0MpyzVMRUr2ZqI6/FXG6P65tNFTuUggPXuLX5Ljo8lShnVIkw1AM4M?=
 =?us-ascii?Q?RWs/+iQyt6VssHD/xyrigUgWFfdpS0x8aPd5BeHHDH9QDI0WxBRAM5BbiT4V?=
 =?us-ascii?Q?oXunN9MPyn5R//6LMUcXQXcZ+z7JtBI/Iq/SwSgu4tBCSry6JSujSQsiLmv4?=
X-MS-Exchange-AntiSpam-MessageData-1: rsRMYFZNnCMJxIxrS8vgUl587E2Q6uO2SSs=
X-Exchange-RoutingPolicyChecked:
	ImYBe7Q0BAo5XjZIOj09+aPTtHeygZp4FodbQHjD+7Y7FqJYGILGH3X+W2qZpPBpsOGho8k/ltqO4NtorJYdh/VXV8wP5B4JznIkUSI3SuQuOAVJ7CIf3v+Svtwo5aQ2qSvC2SITFzLQ6HrMTVC0GhBcFnQS943B97uRtgERFOih5PkwCdXxPsKeKsArAoxs+Nc5OGY/9jMmmpm+j2DISudx98p5V7JKaxG4V5xxOlso+6aB1ULsKJ+tj/OxsUZyghgzqnzj1w7AOQfmsJlljKISOdgP5clPmlkjDplvsrnBLpu02sjxtDv+QZLRXFj1G3NS95XP7Fe5xHW7QWtakg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/bg7GWo9xyq2uVvAN07gav5E2rID3KEkZhxPG5tSeMAOtzaPIfHUVZXlgTJ7QrKc9Mx2e4nH2JyFWxqH+7h/RJyhVpMtt4ZD2FdiMKCGxxesHXvh8o0T1ud0TBjejOAw5SK8zK0SOPknhIEpwb7JB23aUl8bJnnYHltW4ncA0F4hzXmwR6U6e/fxJGmVapGUK0BjVMhrmaxUcjaZ87tF3HaMe663Dsic9CEVoMhYkJwySngiZZoxwtxFslP8lXsPz/MJWWCjyDtU+/lj1+jq44vf3ICG2fz+vroHTu5wpi1f+ACj7m65WIUMVpLmxbNTfgUYHtuaCgiCaMi/bIxXe9X4utfqSH8Fq5QBdlKdeS2vpsivP7n8XyyD2XwTn+K9bPDyFEAMkKTdagqfBuy2B+la9NVrISuvmssvoviaxAyHA7ztYbdVYu+p08a95IxAk8DMkonmAzOLUkMJHCcZrH1e1P81Konm7BVveE28gnx5MKB6isS3yPtTpCX9qyxH9JgrFBg5LqqQQw/OsgNcM/vXWW+O7BU4KRPYubCq4mg622s34eN6s15py3R9X9dSYI3jDaFeVR6BOl4LUxJZXZeoxMkpvgM8o596sQYQeU3XvNBiMHLPj7OmDt28HbUz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4df711-6520-4538-80f7-08df4adf186f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:16.0069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LW8MBN188HDzzE7ioMinICc7zpoMQyANH2f4/wX28yAYO4iiXb2vcNV1VwJt+Q3VTLdwFzYwd2fV0WlMJvO+R0eDyFaK5ds1z84EAFt7LNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

When no zone can be activated, buffered writeback in cow_file_range() and
direct IO in btrfs_new_extent_direct() wait uninterruptibly for
BTRFS_FS_NEED_ZONE_FINISH to be cleared, which only happens once a zone
is finished.

After a transaction abort or an emergency shutdown no zone gets finished
anymore, so the waiters sleep forever. With writeback holding locked
folios, btrfs_cleanup_transaction() then blocks in
invalidate_inode_pages2_range() as well. generic/388 hangs this way.

Clear the bit and wake the waiters when the filesystem error is set,
clear it again if it gets set after an error was recorded, and let the
waiters bail out with the filesystem error.

Fixes: 2ce543f47843 ("btrfs: zoned: wait until zone is finished when allocation didn't progress")
Fixes: 776a838f1fa9 ("btrfs: zoned: wait for data BG to be finished on direct IO allocation")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/direct-io.c |  4 +++-
 fs/btrfs/fs.h        |  1 +
 fs/btrfs/inode.c     |  3 +++
 fs/btrfs/messages.c  |  1 +
 fs/btrfs/zoned.c     | 10 +++++++++-
 5 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 335326d18150..183fa3c96bd7 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -193,7 +193,9 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 		ASSERT(btrfs_is_zoned(fs_info));
 		wait_on_bit_io(&inode->root->fs_info->flags, BTRFS_FS_NEED_ZONE_FINISH,
 			       TASK_UNINTERRUPTIBLE);
-		goto again;
+		ret = BTRFS_FS_ERROR(fs_info);
+		if (likely(!ret))
+			goto again;
 	}
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..84a6eb2ebf83 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1232,6 +1232,7 @@ static inline void btrfs_force_shutdown(struct btrfs_fs_info *fs_info)
 	 * So here we only mark the fs error without flipping it RO.
 	 */
 	WRITE_ONCE(fs_info->fs_error, -EIO);
+	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 	if (!test_and_set_bit(BTRFS_FS_STATE_EMERGENCY_SHUTDOWN, &fs_info->fs_state)) {
 		btrfs_crit(fs_info, "emergency shutdown");
 		fserror_report_shutdown(fs_info->sb, GFP_KERNEL);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40dd87276cc9..730a72f1cb64 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1409,6 +1409,9 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 				wait_on_bit_io(&inode->root->fs_info->flags,
 					       BTRFS_FS_NEED_ZONE_FINISH,
 					       TASK_UNINTERRUPTIBLE);
+				ret = BTRFS_FS_ERROR(fs_info);
+				if (unlikely(ret))
+					goto out_unlock;
 				continue;
 			}
 			if (done_offset) {
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 73acb69c3849..2722751401b0 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -163,6 +163,7 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 	 * send it down to the disk.
 	 */
 	WRITE_ONCE(fs_info->fs_error, error);
+	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
 	/* Don't go through full error handling during mount. */
 	if (!(sb->s_flags & SB_BORN))
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e6ce6f05ad75..4057f3f21b85 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2773,8 +2773,16 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 	mutex_unlock(&fs_info->chunk_mutex);
 
-	if (!ret)
+	if (!ret) {
 		set_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
+		smp_mb__after_atomic();
+		/*
+		 * No zone gets finished after a filesystem error, don't let
+		 * anybody wait for it. Pairs with the clear in the error paths.
+		 */
+		if (unlikely(BTRFS_FS_ERROR(fs_info)))
+			clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
+	}
 
 	return ret;
 }
-- 
2.56.1

