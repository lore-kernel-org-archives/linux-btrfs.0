Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941994;
	b=EpkkiZbBCcG/70cceeW8LUxUEMCitVJGsEJrz8DbhS8WXvegnSSvpYOv86gKvXa4fmmM
	 0JyxkReHw8kUzGDDcrSSRsBxh28G4XJwmrCHKBST9rp5oDdsa6C5CbK7jGHt9tXlft7xi
	 HTFJuXFyJAnOvo2tqEx7aY3UkOcA26WAobGfl+THVApKa5XItzpujYF/0mLtsN9NDMnNA
	 FuQqGV2/oVz0m1EcG11COuPiXRNcaSU2/5hAYhKCUScOp4edgWbkzWuaTkQUxF8Pl2C52
	 sQl+OkD8wDQvpJYqRxShhXpkKW/HUjYUK+2b+8BX7MGlaHdkrMemMUmAdZVg47X5qOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941994;
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
	bh=ubPKLNjc+bLLnNPcPGzOksQh5c8Qfvo9DbT4VCRyK2A=;
	b=UUrWwigHbIyoQ2RDLKvpiWXGbWtXGwBLNWWhYbPNA62bzSTiWZ0JsvM3XdGK/23C/54T
	 os7b2mvg80X7VjtoPyiU0z6EqHfyp/ItIQF1f40fBo8jr9Djskid1zn6ahvgotRqKkCB0
	 UdqnVWBiUyLp30pKFVhW5VMxstsui73EiVcS+WXXVprQ1N1J4VAuc/CCEv1Wa9wucvPk8
	 8xHDk0lzzSsRkw1mg/Ee+1jusc5Ed3XFqRr3LnpfxBuQo2+M7EqRyM26ukYnf5pf1kVky
	 TcWdd1btV/ZvBDSxIkdiNO/JTuRZjq6mARs6H5rwlw7NssTJWcJgibzoUGi8DpSSTrg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="V/QIRA4Q";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=teEWJdRW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B84B606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B84B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=V/QIRA4Q;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=teEWJdRW
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942001; x=1826478001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=L+r+/wHpCE6jh0pDUv1XhMe4JS+QzeBzTUO7q8+R8vw=;
  b=V/QIRA4QicN7wFdxIIM64HCBx+sz3QdO9ZvwSCG6lpixDbSX0eVjIbIw
   X4EAxQWr7TL+hRYZxqOZKLb+NXPwBIUTLe754fQWyk6Ar2UDHi3XHk2bM
   qj/oG5l6X9psrrgXal+TjWf2X3p6i3chELOoPheqo+/XPY16bP4VHX3O4
   dX2g70a49Elfn3OHp7PxgI8XxbqGBAVDOvi7cK1sLQ4yg7fvO2cBXlXb5
   4wuVr4syf7hSf5E2oOHfs+Tx7rbNICBaxcX48f7x1RRDm+Kb7M3TZvMNO
   p8DVES38jveBhMdpsI26JVc6Tc60aDXNbNJEVQ1Es2xEja2cm7heWXPcW
   w==;
X-CSE-ConnectionGUID: O9xrL4gITOa3ZmTi46fv+A==
X-CSE-MsgGUID: uAdRltCnSxSzr2KwOuGoTg==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160149009"
Received: from mail-eastus2azon11011061.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=My/C2ooROZEFUzJDuYC732y8aATXAYb2wSP9ljRBA7TT1ndx0ZEfUMdfyme5MMVZO7OIOSh3Wrudx+ILS3oQo3vk/+/onetR1kyi4AuOY9gghrG77NcAOsBgAJltBupysXNff4r+bjG6KujzfnevChPekGeq7jVkIydKsENDQFv04Zb44B8yQG1pLWKKm76v5gttw+Lm/jil3cn3sy8y+HVYlUkAOd0wOLeQsnUGM2SVtRShh6crOmc9+A3JTX7avdgChUzRt87Jzemaq1+fAe+pbimyv7D6aJ5BN1/LhCtmdglwX8G7tXRGTcAhRQqLjys+s67EPaqBtcjoLG/bng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubPKLNjc+bLLnNPcPGzOksQh5c8Qfvo9DbT4VCRyK2A=;
 b=YFA4u/yOXYYjZ4PR89VLsmLj9nxiTv65ZoHRORaWBb/AUeWieTMwaUnsvtJLI5fipVxpdwIRycQYmniOLyMGMbc9tGw+rN+5mSw8b+IUfJr6gXjpINAPnobDSiVVPOx0gV1mBYsPqR9KaU439E1p5jy8/DHYqYR8/mpTPKCoQCid9wi8d7kPMDSyRGEROhKTmMF7h7ppvW93PKiC7q0/NID/MohTevQVVTXCmzxqjvdPdM3Gha79yb+SM+pUzwXs5oaYeckacIZzNZ6KFnYJnCyWizJf5Nb3XLzNxfgQ1YcvfAByi7CV8C+DuUbbVhtgtbjSTBUgfkXd1QeleU4CqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubPKLNjc+bLLnNPcPGzOksQh5c8Qfvo9DbT4VCRyK2A=;
 b=teEWJdRWLM5Zpmbu3UoRySqWJQTrokMU44hK/r5vGlbj25Glnft0tt9yPEiMWjXEa+m6cRDgzpVDRmmuuFzwilE5rbXDg8YBzqh5t+4u5PvYBo91dXSn5vywd0YBgHVjReg0YPMmDdcocNeE68/qXvObZmBiZPresUvH+V/MPWY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:51 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 18/27] btrfs: zoned: don't account superblock zones as available data space
Date: Tue, 17 Nov 2026 19:58:41 +0100
Message-ID: <20261117185850.4128157-19-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: dcc14bc6-f130-446c-d53b-08df44dcf54e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	0HCIgnasXuJp1EhaXgo35YGDbxsPwb4JeezANb4RSLXZo62O8ZXDGCrEJkmLgRLdbEdz9+TS/wsNpFFdsQ/EC//u6uLbHGsg+un+Jg52nzL7hhlnVoUK7XmnTX3wMMIzaKKcZyT75rVz9v8t/qkMWgyAj90DPyZbQsgmxCPYKV5ZNO0YIy1mGsY2slMxTL6mHKeufTnetvd28kAovZerCaJPEE4bfbiKmhcAY4asXCbcRIf4fJGH4vBGi/jEb0kDqS3V33/KPGc3Bot4yn+Bt6xi7V5uRviV2eyCFsqFuHrwpvH9KDDnghnT4V8wQRr4mz3bZhuWfwInChjPzqYq//kWSAly4hlrpITe7eMDAJE85ltM91E26xUiSp4rRzLP7LR13t2CfEBwvduBdTJHB9mUTVUDdGTxOAzkS1/cXu7opOKxCjMFzMBHwmqjHMjVFQMHtpv0Mf0Wgxr8difO4Pzs/ShpJ4e9LCCNQ3PUxerP+Q+3NPUEBgQwSYFFnzuOMoA4z7hw9qrVU716fIe8AWehM9xN1KknugR0dWEm86RxJnwjRj11SQjp+JWbOPTIzNdmycS18S7wzP5u3OuVWCkQc7LDzwfmqkxJeToH9UKswJljddnnayT0Se5djUX9gk15qiburNNPt1lD3wWaOigxqjeZ8Zq1t3R6Ld1Y0KE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W3/3eYLrNyZB2fGIwlgdEIoJFeLx2q7X9dre+dTvtfu0hMgoH61YgE8yiY+w?=
 =?us-ascii?Q?X294AEv5Cb2/hbkR3WO15mBMQw54r8NnCARTO3/14ammfpOaWxTpGFCudbvJ?=
 =?us-ascii?Q?D3PeiJf2hkBUlu8EzbiOwZpw1tABBdcEkd1XPqZzCd7rCR/CxplY63nAFrB6?=
 =?us-ascii?Q?hN7kfsn7oxCDxX9cjVsnuv3ae58G57/BcyLhn1rC4q7QV1hZR2agGX0NZ8aZ?=
 =?us-ascii?Q?t/h3ulvx4FU/JHTWK+PgiPJqt9ESzRy6+Pa+HgHcMa4iXQ1hH+C88cWRzZp1?=
 =?us-ascii?Q?9+xsVmgqn76scwbHChJIzaHh4YyZNw6SLE78AP3YdGBtANtQFEyuPZomAy8c?=
 =?us-ascii?Q?0wdgGMN/76X8ZT7zGyzIeaQFxI3X8wV+b7hIlNOajwG7RxA0PN0Unrt9iv7Z?=
 =?us-ascii?Q?9Cp2A5V9dNA2v2O8ErcQ6OQUam9Arx4+mhuqbn8GHw9vEyBy5UhAWGRBK7Qf?=
 =?us-ascii?Q?9TWUfvK89jNcoAg4ozuAmVSFMMQhc9MDFM42R7I5uYrzCnpGjOG+mH761NvT?=
 =?us-ascii?Q?PC1Tj3eu58udRjqPjFT738CQFKFF9AjgBAu6ZSaocUH7lI64Y96toQdhBsTS?=
 =?us-ascii?Q?cEYwayZHlY525sX6hrz3iGjhf9BH5UuSv8qQhdmynRIHcqlLIJ75xaNbK/Ir?=
 =?us-ascii?Q?Wf3I93cT+MbErwGUNlcRsD1f5kjhT83Jv8cE4HLY5mn8NeamHio4EPtDpMVs?=
 =?us-ascii?Q?dGX+Ku2UhLdpEpVDhlVJuOO+tk3RPAqoPWO+v9SVECT+6Kw9sMoyrzo2rGzH?=
 =?us-ascii?Q?ttNmpi1Lo/f5NkLWMRaGb9bviiNB4NOSiBf9O8B10z/L2KOpWAmTE+3shqMC?=
 =?us-ascii?Q?uVnoOJeQDlml6vgynGYp5m4TAg+aUOgssG2S6YWfVYn3kDKhtFbE6TgEaUtD?=
 =?us-ascii?Q?HfEvkyOfuf6pk25PJU/pSRq6Of8cxc+NoqpBjsIeAwtYxDVeC5KmG1009PMF?=
 =?us-ascii?Q?LQq2obR7Jzrdi7iJvdOwk1XI8z6U5XYGPmvg350m4sRy/7wlw4YDpqtGkZvR?=
 =?us-ascii?Q?ZdOI/42mdb2LBtLUZeevWXWfgw9VvyEdeNE1jYO06qB0VNkwONo4oTV2+Miw?=
 =?us-ascii?Q?74RztnjC8juaI/WNY6XqWfbFhl2FRZfY7wa3eWdPEF7dUROUXXOJcykqX+9+?=
 =?us-ascii?Q?EYGJgkT7owWt2oqdIiEBHXPzhl9bljY1DbAH9Z03DGHNicRFBP0/rCeUsKpH?=
 =?us-ascii?Q?GSYolRqbYFgLuLBofsffd9mrhJTw2IVCj0AQJZ+kcB3XFzEtP78GC3yx+RhC?=
 =?us-ascii?Q?3nslEZ42T0V10gwqI1QfiBLBno/M0Bs9pgYEtZM5FL1hGUGr4eCC9M4xaLMz?=
 =?us-ascii?Q?jD4BmjD34M29fqcbGaff34oA/0+8TM5pUrgLHxfahQgz3amWjZaGaG2R0BI1?=
 =?us-ascii?Q?qh/DFsz7je6RQ4hRaz7Mfk9AAMXw8HdTh17dbPqiiv1VrchAau398UYD5Pf7?=
 =?us-ascii?Q?FpHezsTNIJtvX6QYn3whuJVE5G5jwCMoPHIx+PspkZ4YwjA+Ei0AewWjDPVG?=
 =?us-ascii?Q?g/MERfV2M4bViEyOiwFU7+1aIowV8OqsfWfVhMU5W7WxfzkN1t8A6jO8GXrG?=
 =?us-ascii?Q?FTFDY9rhsf92k66qqqYZBo7syF67+9rosHHKqdCbUgPKdmUPX5uGHPNv7Ss4?=
 =?us-ascii?Q?lO/lzM6AMiQTyCD8nnxLXpwZHbwLyUVT8avGK3ddXhI/2EEBOp4RefZNcXWI?=
 =?us-ascii?Q?odaRZ2gA2SwL6RzwKgNkwn6rg/Sd8W7iVNPMGOLLvkZP6G9m2bI0VzY2TK2t?=
 =?us-ascii?Q?7Z78Ke6olZrnQr53FWTkR6yUGpZhFtM6tI1pMxrDwRpqw/QBHB1veNBpXljW?=
X-MS-Exchange-AntiSpam-MessageData-1: gMrj44F6hTegIxFCK2qtTbNGk5HFVhkei2s=
X-Exchange-RoutingPolicyChecked:
	5azVeWAJz8adc0JVxfAltYbeGfJlPtZoM8b9JWRhiY+9LbIcNWge0wvszVg4HxncEmYAufnGIdlknQaXrdKnkG6Dc3YT+t0ps5wrY7fNRdF2ZGiuZ5m519sQJmckESpTN5TMlzfHtRUbhynxdEFvYoXdvCZsFXbEF+FJ47qu3bGpJ3SbU7C2LgxwjehOvY9hyepWyv9VChjbVJupAguGRWdYy/WI61SBwkI0tBabGiiH9a+UxcIOkTIBwolpehKuCDIEUoWoqWvTQkz2PuKXsgYpSItIeKiZyo+N/EqR0PXkvbUuvs3ZL3muX6gIMIXK8lXioEl0xaicI8300SPodw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PR2KFRgcsnGDlOxpfo6zucgdTwXj3mKb+iXRK4hHMPOb4drijDPwTrxCZAFvxddMYnR90YrIZkI0vV2f2pFC3ZVJWZpORxxDEz9xACeTCjW6Uewbo/ab9cRk1Wj+HajjU0dDlgihYX5u+xJEgbrpEMLe2EPADyRM/LRZb5anMsK8oXVPXwBQQKcD18AyAKQ3IE4N9TAcFv1NVtr7UK5HvtnIuGvc6Ss12pjd3fG+Ypo/KnKqouAvwO6fxiZZAYqbTzbGMrmFLi22Iu5YUjBL59tAilp3sowD+lky1U+7BUr/hiOHUHsyE0wEQ268vreRq7XXXvEpVDP6e2kp0Di+zQBEAHIzEefkh4jM2VPASJa/iCX+Ub8sfxCRfgoiAE6t27e+wlGn1T48zqS2ukaGll1k5rzNZQp5j94rGyD5sMeAjyrrfpC7yk9hQI2XOyZZGZ+lynloxi8NaVS8TYMVttGU4hb8KKZi98Vpw1bJm1cEUgfmeCyKM9tQuLobzbwOgeEHZxLr3zMEg2K1okyFlR/qkxTPwp7C3oeTnc3qBf/EO0lkaa43mBlMSTDlzI6IVXvutKl31iSYsgpq3t7lTSziR47xrUpIM9xlcFZ0ragx/umDzUDkhpLmXluaSpFJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc14bc6-f130-446c-d53b-08df44dcf54e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:51.1859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNGu4/zyNqhD2V38hjeElHFmFJkuC4s5PjXm2pIEftTOQS0GJ6ClCfuf7mlkGJsHbQMttz3hnFVHlwHXg6iNsBOumyfQw0ZZHy05rJia1+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

On a zoned filesystem, the zones used for the log structured superblock
are not usable for the allocator, so don't account them as available
data space.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c |  6 +++++-
 fs/btrfs/zoned.c | 22 ++++++++++++++++++++++
 fs/btrfs/zoned.h |  6 ++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 02ec4ce8370e..99cb01788315 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1646,6 +1646,9 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 
 		avail_space = device->total_bytes - device->bytes_used;
 
+		if (btrfs_is_zoned(fs_info))
+			avail_space = btrfs_zoned_dev_avail_bytes(device, avail_space);
+
 		/* align with stripe_len */
 		avail_space = rounddown(avail_space, BTRFS_STRIPE_LEN);
 
@@ -1656,7 +1659,8 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		if (avail_space <= BTRFS_DEVICE_RANGE_RESERVED + min_stripe_size)
 			continue;
 
-		avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
+		if (!btrfs_is_zoned(fs_info))
+			avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
 
 		devices_info[i].dev = device;
 		devices_info[i].max_avail = avail_space;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c4dcd8d1bdd2..cc96a47320e9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -968,6 +968,28 @@ static inline bool is_sb_log_zone(struct btrfs_zoned_device_info *zinfo,
 	return true;
 }
 
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	const u64 total = btrfs_device_get_total_bytes(device);
+	u64 sb_bytes = 0;
+
+	for (int i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		const u32 sb_zone = sb_zone_number(zinfo->zone_size_shift, i);
+
+		for (int j = 0; j < BTRFS_NR_SB_LOG_ZONES; j++) {
+			if (zone_start_physical(sb_zone + j, zinfo) < total)
+				sb_bytes += zinfo->zone_size;
+		}
+	}
+
+	if (avail <= sb_bytes)
+		return 0;
+
+	avail -= sb_bytes;
+	return round_down(avail, zinfo->zone_size);
+}
+
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index af03ea8e1754..02298f408102 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -80,6 +80,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 			  u64 *bytenr_ret);
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 				 u64 hole_end, u64 num_bytes,
@@ -187,6 +188,11 @@ static inline int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 	return 0;
 }
 
+static inline u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	return avail;
+}
+
 static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 {
 	return 0;
-- 
2.56.1

