Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794942002;
	b=hgUvQzUS00ZbbhtgpGj/DQ8IhSMSnVjl3WAyCuyHltP2FFNS8vR/fv0qkbClByaDUV1v
	 eMpTG0D2QaLMWi4ycsov1V6UC+fEajCS/ONIsZmluXFnfPAaL4R6z7Nlin+DBawXHasfu
	 uVUaTkbcBtYIQ2XnQWL3lOJm3LyuGsqjmXWBowryaNarWaYKoDFNEBeFHu0d+11S2LMBa
	 hMBZub6cRblAz6bS61H6kxLLmBASNMl1s1U4kV+NG+cE6fNdpoodESQakO/9l4N+cCCUY
	 /PesHBhYSqXlha2OAax/BCqR1h5b9L5FQJqZkpTKKskAevlO2BOa76mgA1wCgJ+x2HQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942002;
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
	bh=upefS6hByP3WnK3CjhllA6yl0ILnUYpDdzwHed29VwQ=;
	b=q9u9/wR5RfhU92+INbaDCrzAKzauAj+uErb2fc7kP9bp69Uf7dXbmJ8mfMwLyIFj+aIs
	 ABe+Ou5t+IEM2aQ2lck774FK0i8mV53iCpsbfW80GuN/aQe6evFnJWEtg7dl6WUZRY5R8
	 etxkb8RFdA9JBkbsvIdjh/njNC9bp068RNOvP7kxt/4MQbIXRTY5gm/5juzP9GOk5e9kV
	 WCOdk2zz5fd5pDhTUxy6snA7ekIcvhdtWIHj/J+vczneeQmfxmfzBDGpVIULT31KItgnZ
	 Xaz6Ry6OXGoRJOVEVoFN+iocLaLdobK7E5P421rZs3Rq1dgBHwcR/UaUPprA85XbdpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DgQi7iBd;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=cbaPuwbM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54DB606A337
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 19:00:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C54DB606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DgQi7iBd;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=cbaPuwbM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942002; x=1826478002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=TXCkQbFxNSc22JD6kQBYTVg8p7sVmjquQdDd2ERUVZE=;
  b=DgQi7iBd1lPQKNuoPJQqREhTTuYM1NFVELbsV1jPsKAFfP3uSQkHX8/3
   NsGIAgn2TUc8jU/BTBWdYunHmKcnef19fLyS7fkfnvE5S7m91RW/srnqo
   HaUDLHE2LL8D07uTClefCL107UgyGq/EVC9kVtul5oICzZhC0Gm5/Pwvl
   F586bGNqpvlPfCNj6ac6/KnScZ8KZw44Y9o/6c7Ax8Rpdet2/ETJEn5AN
   0muf2CllY1L+uoHpaJlgzIDLk4W5F1vDuCwWqVco0Utdxgj1rI4ZBXtWb
   8coW1cLhsIyWiA4VhW78JDxdpJmLbXCV97VemMB8zCDMPEIy3LXRPtXJR
   w==;
X-CSE-ConnectionGUID: YHHnodAzRaOXI53nBcSaqQ==
X-CSE-MsgGUID: 0zTPBfq3S4ajwTauSzBe/A==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161122894"
Received: from mail-northcentralusazon11013038.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.38])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fUeSq//8w68aururFlUTkyOQberM86VuEQXYmGobcZhOtYuQWqwXa3XjUrk6A6U0hghhkhEjvgFibTkFr55rIMv9qITyGFI7k30Gl+Dc/mgQaYSnZAjDNECZmQ39ukldPGYJK54IR/Cw4oucJcjBTB/m2tb9916VOOKN3TNX+73BGoYdaGn/fyaLQbL6lisZnJJldLrjRg1a5fyUL0nYE4d3hjhMONSAtZ2qJqbLcoRvqYLfZDJXb+Fj22Ia1Fujw5Q+EN2HmLDFQDXSE7FTOzXHgjMIpqTxVX1nCunvOe+B9zvljeefmJjN6aRXOHmos1pqWu5xpyljO3xKBBN9FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upefS6hByP3WnK3CjhllA6yl0ILnUYpDdzwHed29VwQ=;
 b=x3HE3jhlzvyPb1y+MM0AWSyADDw5lFoxBwhfJJ5SIYlaPuc9v+C75Lsv6uwL/cUcP++w3u8fkfrxPMw/i3equfQSinVcc3EnA0SieV7xzxFxthZickao82MxPnkBW6PsPFgJtgB1oxySTKXwKDsQWwYZu0/ixnTtoiOPxIZ6+3mLj3F5kFSneq0S5xXjsxZR05z2GfC7h/TIE5z1tFnx7qF/4YNj4hTU/FPwxtxAcE1Lq6z03Pbu4I7dkpLgvlbZJ8mt6PAlqkbxd3c3ppSUGJo68+L3Re9ksxZeA0KtnIF6yPo8ggPOnQtLoX8WUjTSktFKQLKO2nCXc1gA8T9l6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upefS6hByP3WnK3CjhllA6yl0ILnUYpDdzwHed29VwQ=;
 b=cbaPuwbMjw4wnNpqoIFa+54FWzQgNzXXCWdRnkqnD1b9DDKC4L4WP2nnURONQRxnvEOld1R65nZGfzEJ0p5UUPijIaxgOnLV8Obi2Xbst7mCpHaaYToEHuxlrIkGWnehWlwlrqzzFRJJjsRR/3Yg1XJ72mUDZpqq9NfYND0utN4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:58 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 21/27] btrfs: zoned: promote reset data block groups to the relocation target
Date: Tue, 17 Nov 2026 19:58:44 +0100
Message-ID: <20261117185850.4128157-22-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: d5528b44-da36-4a30-5814-08df44dcf949
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	UF/PpyP2XeAaQ0kNrbGeLo6sERELUCOPAE6e3CpAjI4TUd7jS4lQU2KZPZ8SQasim6LOTpDj8k0he7973G+0TOij1BPQV0mc8Bwhe0nxWUQPZdCh+xD5SacqWd2QcKgIglrru2nLSeInaeMmT3GERm+pvi5iiMdtisxIg6r/0onTLxKqjxaebBrLwqbopRS4cb468lqtLcS7m5BfeGaHO+3g+JpBzxd3pIMfLXWOKG3aiMw6WTC7wIe7Fnkohz+8S5Nl2T5ITusweCmBx390zvLdo1AnR6MO9XcOEw6MJVyi+vLjLcX63khI0zeKD6M0bWgYbsYe/frUY9MmihKe62feOHjF/WIQ4EtjEAliigOQ958tA7kBs1EagpiUHcsz8LQDJ1UGmPtIxoLIkpFNHVoZ5x2dR4/SP6DJS3EaRNXa9oE4ZYFgnA50ku3zCQ0xaB8TnEYWJHjNcLBqjaDlyeJ2J8bgyDwUQKDAE67XwwPSYQDW7PJuJTqxh9psMw5PqUzcjFOcTB9+xEadNy2XvMeCLhP8juOz3ThvmtQeSBfLbCD723NT+mVz0MyB1R6IEKuVIveTp78VGr7zP9sdDU27TpevR3kw0OUxBipSLvQB2yljuz7IvNAlZCC7Ha/YXWUh4ghRCp/Jb1r45v8wEiQ/L+5DjlPyhLKQfVM+5SI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MNxKUvHp5Flp/VXAr4ZLQgVmp76z1Ng/agO6o0ZCSpjPHoWOqcyUQzcx1glH?=
 =?us-ascii?Q?eBLK3eFHeYZrr3mEIMfmEuAwSobLIPOpMkfZ1aVJ3I3tFt3D6vvw5Ck86iRd?=
 =?us-ascii?Q?1y6gRPzOu7MDluax2jOqdy1m63Y4Ml10l6TlYenKrQH0Wap4qnc6c+GHmwih?=
 =?us-ascii?Q?9Ps1xjeLHP6B9fXxGpN+Rjfw10ifuZxw8XHiUsfohbLX74Ak8DglFjxOcrSW?=
 =?us-ascii?Q?tfCkJThgthZHssBSFEQcNF+hGkJy1pzVpLkArI0BUMShtMUViNZ0cObUFXHS?=
 =?us-ascii?Q?gziGVFQYBtqz39rrDgaMg9/xDAXzwsdyJuKLtEt18l1dGcy/J4xK+6ur0RWI?=
 =?us-ascii?Q?ayMNquVE0UySnf8JTsxMBIUXTCI1Zdkvj0YjKYQlld4XiOdO66PvzXo26Ugp?=
 =?us-ascii?Q?qIgo+QuoiQK6Rgh2jKNyVlUXEdrLemajarBHEk58IrGvk7ImxLvUPMX78JBu?=
 =?us-ascii?Q?+fn+nF/PKNOAwtJD3iKmwOSk3oBCk3hrQTl6ct1ldxb7MHf/9BQXm9lF8HUa?=
 =?us-ascii?Q?5s4mIh2mrMrfEdYW58oX1jlM3RbzkoF69Cl8l+AxLWbhzA0xkl5XWuXXYFJH?=
 =?us-ascii?Q?8keNiPqjPlE+adXmyi7tc0r/IpRqCoYd7CAu8/4S++LmvXD4S3y6Ptt6E/7H?=
 =?us-ascii?Q?V6Xf33l4DyBFFzzkD4e+7cZ0SaoWPVbE+OnfH1o/P2wA5sYvqYfcrZEa9/sR?=
 =?us-ascii?Q?/eie42SIEjVfc33HYIQm8i3dJDQ7a3PPljn88kv8y1LE7VRtKgnu8hQFnANr?=
 =?us-ascii?Q?UPD4WZ+z3+7gmyJWK/87pg9GSlCA9oERBXuTML25BQPhQ7YIpai3o/dxXvRQ?=
 =?us-ascii?Q?W9+BF++M3tGUyDeWVTvwBkl+1LkTrkfGzyQfJvoVjfwZ6vD8pptG/wLFwsTD?=
 =?us-ascii?Q?gkDwhrkCwdnGl2kJpVK/Hxe7fGvoQ9vDxetQqc1ftYiNcn9rluGUhTgQAEfj?=
 =?us-ascii?Q?Ka7Z6xS3oSW9pBDSv14MaVTbtvEZiEz7taBMS9DYJ0M0Zr/0akm07L1Wh+Ff?=
 =?us-ascii?Q?d/SH5GayCYacDnyACeLAJtZp1Ya4wBwfp75evjOLp17CQwlOiUSIyBiAnwBh?=
 =?us-ascii?Q?VKsQeyU7xwhl8PASnytm7PjU05RlRUiJJlxiXTKspT0ze+P+WM0gI6KNFQ5q?=
 =?us-ascii?Q?E6NA4NBAHTP08QPvWtZUw0jE/G80hT+yVtatkrP8awkwyf3QNk6ACKdFom4+?=
 =?us-ascii?Q?f8TrSumRGzo8Zpu26Yo+NGvyqe3jLfib35dG7v3/8AjNOu86fQFdpOS55zL3?=
 =?us-ascii?Q?lPr0gcLVYgCgV2eV8+Z4WNNEOKXw20IOhV+XiOVo/3tsOjPGGuZRygR2j4NF?=
 =?us-ascii?Q?NOWB2sxvyxyXuhej8Ts8Eine7W7yNxdUJbZgBAaZEZ1raTBGoWeMTsjCfZUF?=
 =?us-ascii?Q?PO34eLn1eU0cRKkWLwRIQU3E1CAUM0/I0lFce1afb+oli4HcMOHpPcBMyzct?=
 =?us-ascii?Q?WWwo43WS65jsnzJcJSKsN6lZl1kJN1AHjAMUiN/YW6KR8oY6PIiv2jOIXcby?=
 =?us-ascii?Q?2WSgcgdNqUBYKa8Vi5YVfhnlMgfAFsg9HO6BL7a8gsDAx5Td+XK6Vc6tOeRM?=
 =?us-ascii?Q?MzbDe0VWUppF/QEZJu/0bvYbGGYuSAern0gEBTjCoCwr8aU8w/kyxRg2OG/k?=
 =?us-ascii?Q?BMRHqHa/YOb4YJkVmfiB05t74JGdTkWrCOuyz9rTmIIcs/iMDi5Xq3inQ3vQ?=
 =?us-ascii?Q?t+qrFgIriP8eG9XrbE+1lpU8jadlTcTc6VKofZrhiI2mmTHsVIv/oHetBcM8?=
 =?us-ascii?Q?N3jX/rkb+5vngzwUJOzFbp0jmky3DgCq/vg5RvbJnB/1pCG/r1hbuUxWinR3?=
X-MS-Exchange-AntiSpam-MessageData-1: Fp5sH+02Wx/aLUaUn3wU99+Gdda8ENb5II0=
X-Exchange-RoutingPolicyChecked:
	Crjyx9DV0rGnSnBl+TWwX9SEiZ0A54odNGI7ptBakCZ+y0iFKeNxhPuIgXEl0+XnJTSY/7PAQHdI4SKG7jPMkuE3VpCy1zFM/ZqmjKzgGW2zPuH9xP2jc6Q+VZlXFhSWe0F3XIsH6Z/yoA9Gy+IOzV1Mp5skTC91TNikfWPVSCKybZC+eQnAQjC9bvAjY3uJvWTX4jaRcIxtAffabExulkgj7+jdHT1L7eVLAvmyLY6RnT8BmVKuf6OBoaKpgdroSFpDtOnX9fbG29wQUSuxvAuW0fbu93+lwyl8hgOGHkBEDJU4/QCKnwjp4i9luilkp7CG5eyxKItwEzAXQ9rpLA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	swfwGP1wUpoDBEUf9JAIGG3Bp55RCfo4kA8P30GW3PgZwDmEnvWvYg9tklbwT5xFc1n9njlESEbg1wyTnIqnaN2xDH/PD5Plhus/FMkK7VdQogz0i7DP3b3z5SNvc/0CyIjMpnKCwmY2UptcjiH73ttCc4791hkF3uAE3cgUr3YccwoXCMf8NZe4MnPRUO6DJve4nRFEgKiGJUwPXnYg7GnCgpkFWU50Nute3Ng9rL59aCZw20gJ4S/M39guZmUQfGnbEyDe3a5DQxmFtCuIyatki/aGGrWQUl5mrErYkWman1CEgvhTglyxI4Qiv9PNFpfEu1iLk4s8rzb7B89Yij8DvlwCp/+bw0XGFYPF03OGDRQ41yy2jShCUE2ysrF1jRuw1ztXli/g2LcPd5l7e4FV2U0IVum32/STAvtAzCn+7NAHIxRVS5JNKDMZkarpZL548S2C5Ds5ok+7galsGIgRXrJ9407S3OGUHWZWYlMP67m/3e5RO9SJvoxLdWxMZkkbGPNUCKoq7DcFwJQoH/Q6dS6+96mva3Bb/aOkpeU4n3OMu5prPP0l2pNQRCDKJowi8xWwnkq9nTFi4Uq6+Zjo3KAh4HvPgW8hfyPUp2rE3wx1wN6dtIH579durdVc
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5528b44-da36-4a30-5814-08df44dcf949
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:57.6722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQL26T0Q4L5M+7fi6vqmLKE/hcAiNU0hZMPW+PVQvlNxsrU0RetzhmHPKW0UQ3r+1GTNbDUVcH6iuFGom6Z8N6blGh0lUdDyqEKy7RwyjZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

When btrfs_reset_unused_block_groups() resets a data block group in place
and there is currently no data relocation block group, use the reset
block group as the new data relocation block group, instead of returning
its space to the data space_info.

Returning the space first would let a waiting data write take it, only
to have the block group moved into the data relocation sub space_info
afterwards.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5840c97aa9a3..dd05687f398b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3097,7 +3097,8 @@ static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
 	return true;
 }
 
-static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
+				   u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	struct btrfs_space_info *space_info = bg->space_info;
@@ -3157,9 +3158,28 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 	bg->free_space_ctl->free_space += *reclaimed;
 	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
 	spin_unlock(&bg->lock);
-	btrfs_return_free_space(space_info, *reclaimed);
+
+	/*
+	 * If we need a data relocation target, promote this just
+	 * evacuated and reset zone to be it directly, instead of
+	 * returning its free space to the data space_info. Otherwise the
+	 * returned space could be handed out to a waiting data write and
+	 * then yanked away by the migration into the relocation
+	 * space_info.
+	 */
+	promote = promote && (space_info->flags & BTRFS_BLOCK_GROUP_DATA);
+	if (!promote)
+		btrfs_return_free_space(space_info, *reclaimed);
 	spin_unlock(&space_info->lock);
 
+	if (promote && !btrfs_set_data_reloc_bg(fs_info, bg)) {
+		struct btrfs_space_info *space_info = bg->space_info;
+
+		spin_lock(&space_info->lock);
+		btrfs_return_free_space(space_info, *reclaimed);
+		spin_unlock(&space_info->lock);
+	}
+
 	return 0;
 }
 
@@ -3542,7 +3562,8 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		ret = zoned_reset_bg_in_place(bg, data_race(!fs_info->data_reloc_bg),
+				&reclaimed);
 		if (ret || !reclaimed)
 			goto requeue;
 
-- 
2.56.1

