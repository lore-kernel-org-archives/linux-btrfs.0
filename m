Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602653;
	b=dDNt7c2jItZll1EFfrjFRVX68PO86YT5GUyy5NCE64EyT070K3ePbxawJPnBriO38oVF
	 wiWHhyj/tvndQJc1VHKLsRZvTgnlG7QsiHqRaUfMQJpkm13kwSkxLTV9mPbika3iKFldH
	 L22WTSmQ36XdM0oVEWhrR19+rmUDE7FeYp7kNxu5h4Gl+OFv2PO9H7ui2I/IIwrjwKQ5U
	 u5VfwZt8LVRGXDwSCtH3qeUV6m/GELygzcFHtx9M+wotP8IFnTiOyhT0euERkNp3DXV94
	 yFCRX7QnC9pkNkLVVNPUjutyFe4CXngNyGDjHd0B8MSx2oQcSrXoB9VpqJjDI0DZ82w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602653;
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
	bh=bujmc8QdQUoYQUoOVyfc4iIgRBO4cRBVMe2QNG4VTzo=;
	b=D2bD0SrhErhiRcmnwLU6CYij2yVzMjUFxkpwHIq9RM7GAFNOm7MzOm/JDjL9yqUOq2c8
	 Bec45Wh7bLbEZnb182OLb+xaKLiVFwlwl8ti7DM1Fb/lvDcCVjxfy5yby4WrN5t2xzInP
	 rJxJ+H+gOS1pOfagAlLLCkD53M5JdYV9yGkI7u8pvp422eBdXxkTCYlqdGu91bZyyS+gA
	 Z6oO39LNa8OyZ8kdTJ0R4Xf/+aJ6KOU8WnB3uDnGKFr9cxwswdZg+m1g/R4BY7IXU+jPV
	 iANQT91MVFzYMTD2q0TFQjyHjzltXazBuDLVxEuK7lGC8leb37YlOZvSkgHVKsFuBpw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pTxc6MhN;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CmdOxDod;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1494606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1494606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pTxc6MhN;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CmdOxDod
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602652; x=1827138652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=GqYbr2gsc2BGAjrL6AlpeQj89n9FisUEUSLy1UVgaio=;
  b=pTxc6MhNgQVrL/VBc6GM+nE5FR+D12QTn+wziSlOkPg2Q5sCriAXUOuv
   uqMXkOGBPSAz7y6hO0AkfW+u5mZFeOYgTqrbLc49MAWYDpcDmQ3YUaRiv
   XOz4G/JuVZReuNT66vJKrGwsY7GLTiNLEZMwjHzO8H9gcqBQqlygIhwvY
   cCVB0T++CSRTQECjtZKftVQijmkoEpNGynGkIVpy2IPNlBynBG9fvTPfv
   CyWvudDlIj/N6hGYoEMRVwBMiON0NRcYFztAnbjEBmwVeyTA81Lp3D6qv
   NLLF5B5+Grlic372OoFddoHEmaYoPP4YtcMLWpFhhXeJPTjCKgbGfKrF8
   g==;
X-CSE-ConnectionGUID: Jvc/fHiSSOSPfgK5MbDy3Q==
X-CSE-MsgGUID: yi2g4EC3TjKnOqZoq/JbRQ==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662203"
Received: from mail-westus2azon11012011.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YbUv8sL5wWPT2p663tnkRj4hiGJbx4iCn7bJzfUBKWduLmCG1ZYkceWv5/MMogMRQzvTIto1FGtsdjWNMMdDAmaolRCZplW4C09AO2PoBNxdBvFbcqT6H9RQbZ9tO+2ErDi58WtYER2jZsOBBHOuhynJQDGNKDpuZqdfTfmuP3xN4b6/XVClp07TkfomN+qY7mGxxjgv/nufDIet1oc7YvQb3gEUQTH19qOSVWg0p5EZ09zaNvIslddEOhjeAUney6SAsHdykFd15Nkskhe/JieuikYzOdalMXw7d2LG5iG6GreV0ixSP/n+WOcIW+sxqcgS5giMZWg0AF598lFUBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bujmc8QdQUoYQUoOVyfc4iIgRBO4cRBVMe2QNG4VTzo=;
 b=jklmRlr4Y+fpa0bXd3y9pOK7Uqfgx4saNF8wtgImDMNgAUZNr8fPG1O2FJkb79S50A5BjEFEXzmDdFsRCtjEZXQqRaTF4MYwsIfMnuCHHCZLlPT43QX1449Yr++xM5/MBNzBQuIRjU8YMx/+WpvYB3leHymatefHnVy9Lvja/zYqWyutPnA9qRzcX4xghmxmOW1Dd9yJpFnYa0y3tUoafLvoYcfmqzdIBb/nJeVoKC1IkNRsSOTiJucoS/TU4RoBAJruXR8HWATOHjEmgS9ftF9jSuq0pxQfhT5lnZ+Qy5qHE/IKkg2lcl/lHwB0aLO2qoHVZNcvf8bAqFjpOQ5gFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bujmc8QdQUoYQUoOVyfc4iIgRBO4cRBVMe2QNG4VTzo=;
 b=CmdOxDod1ASXpX1nFhK+Rva6Nv7N/5j8ANxfJfzhNS+9FpxM7kijI/LumoR62Gux3oa0pqRF4akI0vOAgUlEf6o/yM94zcqFSKJwsy5BzJJx+Be3FridWCSgleSaR1AKKv8sezqSmoFeG+V1k/8zH80bv6qS0mSpHp0hD6b7/PY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:50 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 16/27] btrfs: zoned: don't count in-flight data as available in statfs
Date: Wed, 25 Nov 2026 11:29:45 +0100
Message-ID: <20261125102956.266389-17-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 49f1ba11-6699-458b-463c-08df4adf2d34
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7PKel2YQ1trv2N10SW59zIyxmQ0ELbbdNJZfTsdBS/yU7ZaGjBgzh68ZhrB0N1b3OPXAB8TRHd6icee8oIRQF2xEr5r6pUXBq7Qcu6IX1T3AK4Vz4YTr3rnDgREC5VB8XPdronkgQj92vkpdXIrDSWs494OwId3AZhguyCVbK+xiJoBWs2O8agbei7kfsRAU2JFFCpaCf1kL7yXj5vueYip5uaHDHDTcnJaI0uhNfSg4sbh7k9F+9g0GEhsqzjD9Zd1stu9RGdSwaQQH5pTPbD85V0jcR7lxnSGrc+RqRhfuKVuQSweZidmg4owqBD5ASrDPbeoC+a9qdz5l3NGb/KFrIoDJY0gK8nmZ1eB0EuR4pl1gK5RWouxwoJnI5ITfRSwhgA8Vlq59TsKlVtiecShgxHNQE/ncWepRoeBubR1w4MuliyjH4XeZY7Ucw3OSXo+fTu3yNhQK3yyw4yfwMhqIdxc8VMnZWOccjhDfgkPHw1F5H64maYT2zPOfBkA/ieE4U+W+fotLovLpx+hKUfMXYbb1TJZBGDLzyWsQtdFera5X3pumUnQ47b6vb5y75pqoPnUrcUSeWrwU8f47p64ifcyZwNHSQZfFDfTlowFVcp+gaiIjNB93Wpo/dbA+r70bTvfC7pm/WqoAAu8mIOrgIZsOtpHL80Sd6PI9c94=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dHTx2bPNWOP9efls544/MVBRVv6mKnGVE/O5RV4LCVYCvvbPtKrLDyShUw24?=
 =?us-ascii?Q?KFMb/QJ1yMnLfE2m+OhHnGIM5yOhBsI1iT7Cb4kpistNkJ+5auO8cwPUZT4n?=
 =?us-ascii?Q?lRUCbBt4OIndL/0F1sOGBZ9pIj4ha3GRT2hUnQ0h49/ennhe+OrQzWQhHK7T?=
 =?us-ascii?Q?GD5n/rjSfKlW/eq8bmyvnKyhzVlXdPPXlVR38D8JrhGnpE9Kw4jCzbegxa06?=
 =?us-ascii?Q?amkrVQqUn5zd0KkyZeyWczPpUatQ8rAwYN9Xs/PZwAZOGPu24lhs/NtDp8X7?=
 =?us-ascii?Q?clPCamlJAjdG/Q41vVT3SSMKyem65Khx/Hdk2X6xFtma3e8dB9CJjA5RlYHr?=
 =?us-ascii?Q?2I0zrEH/xN9wyZgLoDyqGoqdld1OWO/DPV7pi+hLykMp++vcAhV6N5w69A2P?=
 =?us-ascii?Q?nwqo754xNssPwissX87kHIoIQsAY99lRIOKrZ33WeIQB8Glg6WQPaSQOFAE7?=
 =?us-ascii?Q?sresAtDzNzUMwR2xQkKoT64g94rYQ9fXnXyfGNHG68gSU0AF3KCv9jfxgvaM?=
 =?us-ascii?Q?0Y3Fmsi1Uc853W2X+THBAhTkTjDGejmig3EWY9qWeIUbzHUYxhM36pwj/pRL?=
 =?us-ascii?Q?1lVFOLUuJGa9F7KtetuYJLqYuLvOPgqrAe0IUaCMZ1Q+55ari/gKaMwFOiI9?=
 =?us-ascii?Q?6ZwwFWEvvNSDfti6oF86aeGT5lIjHwKCPYzlQcNLolLf1E/1vz4SzgoqK0rP?=
 =?us-ascii?Q?W3vuEPSksWKMh8XwADBhK+13EuWEm+sBqY3Mkozau9PlkQXJIpSbe6Zdb1vb?=
 =?us-ascii?Q?aQ45amBtgr3lnYGV705m+vS6Y4AFz7okZCSPLppaAOFMLsdU1QCtzzc38Dmw?=
 =?us-ascii?Q?ZMfNXU4BIkaOpN4W/kPLGTB0kdadISU7c3apsSyFQGmdopWka1slDxV331PY?=
 =?us-ascii?Q?d8/ZtzdNjFl3XHJ8+d8sd9KP5sbxM0BAFDaigyLTRiIXM8AclE/1+OAOl6Nb?=
 =?us-ascii?Q?m91ovkdTr+Gnth3czks2Q87wHWBdkB9iI+hDb1kC+m2mO9oHSgmK4UypGIoX?=
 =?us-ascii?Q?5PIApXkKKyhhftACOYMBftiR1KF3agCwPtLt1R60Pp7Wv5u45caPE5OBDloo?=
 =?us-ascii?Q?sw5qmNakAFO6+bx8EIWTtxZGrRf/TpHl7C3ZHmBQIGI3jtM9366fxba7+eWq?=
 =?us-ascii?Q?15vCdsezogtx0yLcc2hOQYiOrspja1H+hUiGa79l11RkIPjGmRitXnEwwEYt?=
 =?us-ascii?Q?209oZJHl1Opcs7bavCf5epiz4LYL1kPOaK6gAm27x0gvox9ocRxQfHxIY0m9?=
 =?us-ascii?Q?DyVkaiFySO/FMJS4Nxyf9HeP+bYgmg0UMU8L9eHTHg23ZnacAZbHd1YBCCvm?=
 =?us-ascii?Q?TQFMYS4s3rmA/Bq79SITNO1B34IPqfz+P0CC2paEFV6IEK47W1qsGtztDgMp?=
 =?us-ascii?Q?fz0X1Dqox7gtLE6iJnVBlgHG6vMcAnoKTAcaAyv5s8c7MnRUbR+dY/0d8+VC?=
 =?us-ascii?Q?6ruuYmjFIxtr9Dz06jCPUwZ+cat1dDJoxfmmMH8WCu4K327WP1hGlV5sGEob?=
 =?us-ascii?Q?5O4RA+nesbivyaCMiDsl0uhnOTd1XjrVBpIaEddPO07I1jF/wiIt0xyjZVc6?=
 =?us-ascii?Q?g4ERc9TDt+mfdY157LDHLy50j0bjPBvwHib1ghNjBcEAdbc7TdAEzFG3cMZR?=
 =?us-ascii?Q?8oYNYOzBbe8kaCOKaBiiEzRZs5paUPT+frHcmNDx4sUOM89froySF3YGueIz?=
 =?us-ascii?Q?vxOyzEv5ETE/3bF49eKac+R2UmZAFv1WA1agcpwrvgHDtqbgdlfo03vlfInl?=
 =?us-ascii?Q?J6pxnpT5OUVmeV2Lu0KGfBj8wMsiAmsfrfW8UgeWqV2Kmd1wd+dSTR7YlU/e?=
X-MS-Exchange-AntiSpam-MessageData-1: gFZ58YEe8s335MlFsuFV6aYdZm6F8O2CwDc=
X-Exchange-RoutingPolicyChecked:
	UQL4s77bgC+OpBBC78+wx2xXVYXKQqWRD9wLQ68AUrxtL1Fav8/0KQdUWT+xKYupvPUafhLOmHjyeq/uC3Ps80mF8yv+uxJvBOJnw9Qk7r1qNaLiKyWw8b7CcoNkJyeoIWunz3acSIBXyFvgc9qjunCIZ/GzCJDKl6P4sVTC7tJNMg4pNDnJBIpOSndv7gP0Wtqr156+1LsqosJuTAXed96k1LZmO4QEJYaiktbzpG6JtrhTPu/zp8xX9t2qNYc9WTms426/j2ODszIBbWPIMS+GVUbL9FSnqhRZTaxVzCDXxUjXHUU1v5qP2DOK4970OhYzWunrcvZunsYjiz5xRA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y6iuWOoMDdJnwD1NeBUNn9Z53lt+SqoEAAOx/vcUaRulfZYAs2hw+Fbsnreu2f3vgrqcL+pXQQB7g7eAYTD8yaEkX/IJm1U6S96FefsXDEebZipbVNLkjA8XmTz0m7n4s5URML1iBMILKJqPydskZxLaLiAOWbllt3CeCm+/aE1MfwVKDO4UeaeSzlGNDG8eHWnl3qandlP6AbOmoDHPB7HD7GUyIWOZMfuGv+3yC8sLvWYeDIoNMLzP31ujuBfdStqbsJBf5YzwneDSt1ZARbj//Nr5V7lIcZPHISiAjLZ0I/X9wiZt4Uvn9aCtIfUpOtUhLJ8B7NZFImNbHy5j7BpBPUibWQm3lw5j7dmZJ59Rwr1JWkxnEGx/GV4HlLeUVrmOVJAi6GeyRmb6bUz1wrhfE3IbVva1n2QG99v81ULnA4S6kDMZ4aVpBxZpTkG/EBjVf8fg/87r+UL8m/fdIoXRSE1tWhh81oKi768eZRjHS5I/hkkiPMuPeKKDfTG43jUhMRFDkws1rREcNpdS4Mechgn9q5HpdNXsWnji5ySujO5aU+mHglG4EjN3AKzXGUyeh5oPuVRzdZzpmA8Uar2nvnAq3AeLM8RW4EjBf5ry9xFDHlIK6mG0Gjl7iTxv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f1ba11-6699-458b-463c-08df4adf2d34
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:50.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OlOrrV6/qfCtAdcHLTkEPtAnjJibFunGlmyk40cBK3y2cXIjdHpCr6S8l4qBB+YOjzIxNV7N/AfylthJDcf2cErM2sG1e1i6h1VJn6OnPsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

On a zoned filesystem, space of a data block group below the allocation
pointer is used even before the extents written there are accounted as
used, and freed space only becomes usable again after GC reclaimed the
whole zone.

Don't report reserved, but not yet used data extents as available in
statfs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2609d7783e8a..eeaef816025a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1691,6 +1691,21 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
+{
+	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
+	u64 reserved;
+
+	ASSERT(btrfs_is_zoned(space_info->fs_info));
+	ASSERT(space_info->flags == BTRFS_BLOCK_GROUP_DATA);
+
+	spin_lock(&space_info->lock);
+	reserved = space_info->bytes_reserved;
+	spin_unlock(&space_info->lock);
+
+	return reserved * btrfs_bg_type_to_factor(profile);
+}
+
 /*
  * Calculate numbers for 'df', pessimistic in case of mixed raid profiles.
  *
@@ -1730,6 +1745,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
 
+			if (btrfs_is_zoned(fs_info)) {
+				u64 inflight = btrfs_zoned_calc_inflight(found);
+
+				total_free_data -= min(total_free_data, inflight);
+			}
+
 			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 				if (!list_empty(&found->block_groups[i]))
 					factor = btrfs_bg_type_to_factor(
-- 
2.56.1

