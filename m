Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211718;
	b=iUakH/8R2qQbZTaR/fmGaxzrgw3dvKLA4/0Nvmjz9Hj8PM4Cf4Z1OTQO4N92sAMECZgd
	 fG685DB7XtBd/3NK41V1I5y9LXBfTuJ2HHhNa/ItRqEOzg6HoSV5tjstCt6vaRm2+RI1w
	 7PKyk4SadiSgXQ3nas76xgRhid8+WODiSOeSVNm2gswY41PZp14mN+9tQK/YGLmhklnd4
	 iv1dI5iqx4FLtPPQ6X2drmFMnbzWgb8RHBMS34//STZBjUnzHQpXx3Gk6h2BAhE4ky3JC
	 WnriqZPTvK2tJA2A3jdGC1w/RooiTyEivBJ/eDT6lTnwNUBCfm38cYYqmaUjHbKqHYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211718;
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
	bh=DlbSEwmNLMxyjvbNRpPePpz+rtpoXNMKv/aHL5y9/yU=;
	b=O9NbQ/IHC1J0DhE0uyhVzCTryM6RZrnLgWy0GoNm82zIrJpDPaMV+pEIwnqvpl2xe73o
	 dSVEXc2EfxQkAVV9Zpyf94/gKoz95ZYl8dRJXcDgVVlEm8tlRnof5xdZZUNOyf8eFhp2D
	 omZUaPn34UtdKdll7v1Sc2XwQLWCbpbWIqj+7py9R6EN98nG368zHAKXw9+LdmY+ReW8h
	 aYzGXJoUKk7wimRpkon4qP/zJDjqCqtr5PGIRddw3y+vpp/Ip0bV/X0TxOwqvgssmrUxA
	 oPxAssgwlCu6hKOC0pAoxcAu2J2m8hr9QnMtRJe2bKdqmzFdtX83qgVGoFAWnNq2cMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=G1c2Jn69;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="Zg/zMcM1";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F373C60A3825
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F373C60A3825
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=G1c2Jn69;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Zg/zMcM1
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211718; x=1824747718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xt6/hQAKHkEzBNaDB98yVxs5Q8Cq5c34lHiW7t3AHsY=;
  b=G1c2Jn69G5YhiljIvCdSy3UNOTz6WhcwngQZSf+Yqm5Nj98tV8jszTb1
   CuTOzQjJ0bKhmY8RWHt1LJfGFRI4H1UcUcGpwi+Ltwlsu3U/lgGoOfbdd
   B9bV6nLAzEs4g2As6Y22y+3gAs+3EhB5NrzT7m8wCA/EQlE1cISRRiON9
   8q1lX179sz1nIUB9KNfj6TDvKUmsiB0vis4O6gZ9rc091kaFQQB2PA1k/
   Y9CsPOIpx1NoHVcZW4QVn4DlfG2w83DMHtadeRnc4oAmQwA2zCMuxlEf+
   zVWwNzG0RW2Ps+lc5XK6mH+e+U+vLqijIsXa+lc5czNdYuAqvddQHYN9+
   w==;
X-CSE-ConnectionGUID: oW+HMDATTk63U4xS5JPRVw==
X-CSE-MsgGUID: z7wVwJgAQu2mEm2QfG9HlQ==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="155004275"
Received: from mail-westus3azon11011040.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SoWpaOw8vsEBkgrszcdzXFev8KoSuG6T7HjSLdeLEibKSWVUc4tyseOqEmhRwvznWTnVtQsgx41fYFAnBktj0IalJRCExSGQ2SjXaX/ZeNqFNn3HC6AiqCctceW4bvVB4vlZtg8PB9hDGrjInb2mNn2INm0ZX4+gMCk5fIwua7Ft4spYgzyjIy8eQ12bUszYLYDEswME3VW0DN6d58ZbIZ+nxvP5RppC44hu0jt5FxfYFme8Z/AA6yuO0g4V13WlwqdRZzNDKH3x0RWr6n1AaCj7xbdcbayj816V/gkpTZZkQ9XReXEwco8Om1Gf74bWWBwjduG7oYgtWojg1+ZQ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlbSEwmNLMxyjvbNRpPePpz+rtpoXNMKv/aHL5y9/yU=;
 b=V+q5xwswbZ88Shfcv5SiA5fIo8LXXvKT5NvwI4l8r79pUABJCTMJt39BURD8zBbSF4cPRGc8+wFf/G0YXH6eOzJ0pFS1TRJs0EQKPBM66a/UF3vD17l4zgcxB/2hmqTcBndLcVsnD2vpDN/2/i2BwEKG/gVigHf88MZVfWp9F9WDo2az51rQsnLmbYA0t8mC/0Xaa4a6+R5jJM0syryiULxwnkzmsUoGX/e3XDJNZVxVJF/lgNu7rvtWGG+/QCOB7yiqXUUSCYyVK2mmFh3ZKEmWAyQ5N/2PBAGf5lMi5s6pZlirpLA/yDCdebETD8Y/o2EYFD9BeDnlhtWxOXVyng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlbSEwmNLMxyjvbNRpPePpz+rtpoXNMKv/aHL5y9/yU=;
 b=Zg/zMcM105+1BuRPOeNJ/sVULzWi8UwoLNP0c3plsVMKFhpahDa4y/6+tWwpTlrK/gD0wdXRLZFo5bzwnYV8VMjOXRhVbMF0Mc3HikOwccy7Zg+jRJv8PVNxcH/i0lcmPbAZWZe1B8bBVuY+MZXqYEy3eoiXeOsAw5m/FwTaqXU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:52 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:51 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 20/25] btrfs: zoned: return finished relocation block groups to the data space_info
Date: Wed, 28 Oct 2026 19:21:06 +0100
Message-ID: <20261028182111.160492-21-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 64606e26-36a4-437c-7369-08df35205695
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|261022075727099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Q4DKpnMRhDhjcLVXcdub98u5losp7vmrwx4RjpD4K2Qi1YMLcq3EIpCEqKO6VXW7V16Qsu+9MBfRBQQL3opVHopoZy3lK+vZ6se2JXB/sT0K9uhT0C/dpHZHazkUFG6b1kD5BCnewKTQ7fbJBZ2X9kmTZS4Xoj89Ucy2Wm9OGmQSj76V7/6278sK293eJVnZqx42BR8EyasMGHnDEr6ppWRo0uPrV3jKhnSgDjQTC/tfOgc+sQ/zw7GBbDaOvo8TDJ+CfjG9u5NLfT6J/ZmIkZh+0WNZlG5e1+U19jqsRbqtaxb+89jTYRErNEk50VgDb7yOvrXb8Rd72LwQlMx2x6Zp/Ase0nAWev1CJvjkkKpOwqzq2v3WPrV3rE6NJhScSNmgo10saKEEj2DFUDdJPMJPFB0RF/eRpDYAkYvLFSexaa3hZclxazP23o9pBWxkDMUwCfeIt875AlSAHv/L5CMsNqIIov8zEGrqMhS0QRMm9JGWt3xZV/zy53+UNOoiMcUty5ASoZH3C0jp3X8yjhp0iFjqeB8RbC0348EiF/aorin1gn6PURKM+OmxSHA52fBBAFyKNpVesS7XxEFzqOcLsLqELA1fXATIPlYALwj0tHZB5AAK2h4DXoMf6yxldXcB9MVztkdy2zaKngmKpkj6dAnt+TsSNB429HVLM98=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(261022075727099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jwg2R8BayMZmPTDx8uUaIa83zohIeApAZNCrdYFC49Xxjkw8Eq/nnrdpZgjc?=
 =?us-ascii?Q?diDWVSKv4qfEc1hFVQq0pNzv0c9av8SnWzbiCdJpQU8DX2lhs/yiPGX5JJH5?=
 =?us-ascii?Q?1ZTbuYPSLY+zm3lqxH0+KJWPtM7iXJ7a049JC0s0gOIydcXn5c+g98OOo0Ne?=
 =?us-ascii?Q?HQbE0msjG214lhoRoOJ/y05CPYVAhZgfG/xNI2+k0di5rUJ7lz4wkkoQcgC0?=
 =?us-ascii?Q?IRSrLznD3KdjSRymRA+9dTdA1J3H13QP62RT5DJbuAz5PUEFjwPvtGMTDZUI?=
 =?us-ascii?Q?AfDWcWR/hPHx36rJgpe9WZeFqL0+oz2/If5OE6GedL4X8fcJnlaByfZZ1Feq?=
 =?us-ascii?Q?KqVWL7MJLZK1cbwsjKyqrBE0raWFVpuhawa6e+0gIzhQw/QZ8FIVSh0OQ751?=
 =?us-ascii?Q?yapJAPpEhlnNNS1H264iWih2AT9n+hWqrKUyapnaikIXSAkFH6ODsX1foPbs?=
 =?us-ascii?Q?UA8S1+1QtkYkYCFmU8W01biGsUafRoNorCL6qVhbgwHnsW4KcA1KViC0wtpe?=
 =?us-ascii?Q?CTgVtIdKxzd2Vi9XUIPI9easfl4oFMWHtG1HYQ806R3A3zvfr+UPufOyYJZo?=
 =?us-ascii?Q?yWyTGC2e58PB5okHH3xnqMgZXypGRav69XuQzTceS8Pqh1etckYdX5iUyXEF?=
 =?us-ascii?Q?bRKRq3WNnp2iEBa7Qf5BTayyoG0Q3HhboRQjhCwuqKkr0LPCyOfY5DjS9ImR?=
 =?us-ascii?Q?M85sGGl7mF6KhWbLQ3O44XDqzcTUaZYi+Oj9Vm0Q20ij4DteisQsSI7aVcpc?=
 =?us-ascii?Q?/RDnKV4O8QDA2/yz7hXA9ys9/XsX+Ql38brwqS9vZuFMiDIzYWhb7IYTbLsM?=
 =?us-ascii?Q?w9Lv7XjidmfTzEFXaGN9u+2u6tnDQm8KZiV1jFKQ9rDyO/JlKPcsYvARbzxF?=
 =?us-ascii?Q?8gk+PkI1oGoiYoM6ycOPbh6oAHGwe4QS92GL2MlMYaplRUFlxzakaJBChMnr?=
 =?us-ascii?Q?zOdBWwGynv+j1UStJhFlH2Y3cRPKzGJxgS33Rc3wT+pLElgLq8cozMHD00OC?=
 =?us-ascii?Q?fbEDRthYwlgTj+BeaVOO/q5AO6Xc72jqncEiRUbxkADhiQ5L1+l2inaDxTPj?=
 =?us-ascii?Q?3sxMedkqexHKrLWHixpK/KOZkeg/0aFpIMqRQ/cUU1pq853Sk14m4xuYL6uy?=
 =?us-ascii?Q?tZJlX6SVndQW8exjBA5Tcx/GgFnJyGcCWluPbxo7zklpYl8zqvJGjaNQVHUS?=
 =?us-ascii?Q?yaiZOJ7ULvQvqZLaHhg7ymMqOWZTLlrJfDtRpn27CjH6bLCDIIVZ1B1VMYMy?=
 =?us-ascii?Q?NKV+iH+mopmk0V8MwLJrXtRoDM1tpnRtBEHB4m9Xvf9QAdU9SRIhmO0OtqCh?=
 =?us-ascii?Q?ZX2stL2BJzaoygkFZX9sCumyIPGaPyi+ji7L+Wuof/h1ScTdX7gkwwHXZmWd?=
 =?us-ascii?Q?O4fmqbh+aUJ0auVVA9i6p1g87R9jp/fCNLXrtISokpdm9NBxo3pKSpIPn8SV?=
 =?us-ascii?Q?q/W4DleKJkFisKsMtTdw/seu17hh0x9IOOtNO+lUAvuOZvk3DLqPg9EbXB6M?=
 =?us-ascii?Q?LguWpHkqgMt6U8fA4onSclL8AlbgmMixLU2NYcjpMft09l98yzGqEWbX7xk2?=
 =?us-ascii?Q?Hngsrrki8D0MKbXAUcTZvs4TrgJQGgkt76lj22cQ9n+3RTkBDak/FFQONHSm?=
 =?us-ascii?Q?OgNjXThDvD6k5xGfngoaddAv78r1n1SnxtidtquMzAxOhVB613Glz8cQyQws?=
 =?us-ascii?Q?Xj7mc1/NJ5VeGCDlzktXJYRQfJKScOUi3ISo1aGsy+kbvgdWpuiO4L3DXHsa?=
 =?us-ascii?Q?vTaxnl/2wKpTfmtrLSqftRgJaGDgs9Om1KM05O1O/W8IB0gLwbLlz6xafdol?=
X-MS-Exchange-AntiSpam-MessageData-1: oBESL/ounrR3ypd8GEhFJHxGKqkXxJGmtQA=
X-Exchange-RoutingPolicyChecked:
	WsQkxznGQD/WeHTq2T+HbV+DOs22W7lxMXENvEHKDRckTb2KujAk674XIT3akWmaKyic+UPFB1m7ZYLoO8R1l6G8yNrbfP5XR0aigRfNwBXaF3CcFYo/TzoRx1sz8eknSJANoDfq1nfEy7bKYKBPvCgTlLgUEIKQtOaOJVQNzL+Xz399ZTkNDR/XA9vKFrk0/71VSUYwHUWzpGKUUePpYCk3kl5EJDlhB2TPtdnDOJjJFt4bamh+da9V8uOUlPqS4uQjjuIWVr2qgICW5oZVsQ7fD9u7k/3uP4tRx6xMV56rspQOrOJZIfofaSKJi4eoaCqKpZyufJ6/nonAwY2sow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SwYBPDl+IKCt4TTG4I3Tl1QS0tQP2kZWdhYnx85/oiJ6YZtAf5ppsxOlc4hYqd3JjI2OwbrvWj4Q86ZJ/tOT5Bh20QRfF8SHdE9KeNziPYzeXVWzaEsSu4quNK/I9ROMLQm0ALDmxHUt+P7VIhv8SjaKY3lwfcyFyQe8G7ONWJbOpTgoRc1kZbV/PlTiUl4zTh41Us+y2vJSlVM2chs8P1E/98O3YTHwdKWhVxtEUPDRe1cZRoR0uHf0ans1c1S2SzxcDV08LynLhWPiXe8KCAgrthsf5G4pWBloThZKr2OHla244N9uvaJjg5YPEncDT9KNyZODWOn9Nn1ZDAzfQ2t4Xvn57PGQQ0ltVt8aHCRjPkE+ct4ruhfxYPW3dw24rjY9TEdmtg+g5A/SV2klg1is2ejPI9ncRGXzcVFhBTtZc81wavQaHugq92J2AitYWcfC7UQAnL7zdzAdleLOjduBHbwbceGtx+5dyqO+giCBZbDCXkxLa+IbnDcUHSiXHRY2ZdrAEmjbOsKNfTCRUUX6KqxAE4yADK7C9MoANqx6hmz0ZKfcebN1lLDxXUvna8fxEGjaoyBdy+fKkMksrPZrYGOocX2N0m1E3KodHdGtt0QyZjaYQi4zN+NrZdvE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64606e26-36a4-437c-7369-08df35205695
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:51.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRN182k49NsM+9KS4DmQXsU/nPHKleyImc3IYCmNabOR+B7cz6MS40jP+j++NyKFkbeYM1xMxXb/cbtryXj5iTQizk8r7RI4YPTtVlMHYNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

On a zoned filesystem, the dedicated data relocation block-group lives
in the data relocation sub space_info. Once it is no longer the
relocation target, it stays there, so filled relocation block-groups
accumulate and their space is never available to regular data again.

After each block-group reclaim run, move the relocation block-groups
that are no longer the target back to the primary data space-info, and
reserve a new data relocation block group if needed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 +++
 fs/btrfs/zoned.c       | 57 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  3 +++
 3 files changed, 64 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 70f8ea56df69..a7e3fa71e426 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2161,6 +2161,10 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	spin_lock(&fs_info->unused_bgs_lock);
 	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
+
+	btrfs_zoned_return_data_reloc_bgs(fs_info);
+	btrfs_zoned_reserve_data_reloc_bg(fs_info);
+
 	btrfs_exclop_finish(fs_info);
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 55706f95acf8..00b220e30569 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2949,6 +2949,11 @@ static bool zoned_move_bg_to_space_info(struct btrfs_fs_info *fs_info,
 		goto out;
 	if (to == reloc_sinfo && bg->alloc_offset)
 		goto out;
+	if (to == data_sinfo) {
+		if (bg->start == READ_ONCE(fs_info->data_reloc_bg))
+			goto out;
+		clear_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+	}
 
 	readonly = btrfs_block_group_available_space(bg);
 
@@ -3211,6 +3216,58 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	}
 }
 
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo;
+
+	if (!btrfs_is_zoned(fs_info) || !data_sinfo)
+		return;
+
+	reloc_sinfo = data_sinfo->sub_group[0];
+	if (!reloc_sinfo || reloc_sinfo->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC)
+		return;
+
+again:
+	for (int raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++) {
+		struct btrfs_block_group *bg;
+		struct btrfs_block_group *found = NULL;
+		bool moved;
+
+		down_read(&reloc_sinfo->groups_sem);
+		list_for_each_entry(bg, &reloc_sinfo->block_groups[raid], list) {
+			spin_lock(&bg->lock);
+			/*
+			 * Only return written but now empty block groups that are
+			 * no longer the active relocation destination.
+			 */
+			if (!bg->ro && bg->alloc_offset && !btrfs_is_block_group_used(bg) &&
+			    bg->start != READ_ONCE(fs_info->data_reloc_bg)) {
+				found = bg;
+				btrfs_get_block_group(bg);
+				spin_unlock(&bg->lock);
+				break;
+			}
+			spin_unlock(&bg->lock);
+		}
+		up_read(&reloc_sinfo->groups_sem);
+
+		if (!found)
+			continue;
+
+		if (btrfs_inc_block_group_ro_notrans(found)) {
+			btrfs_put_block_group(found);
+			return;
+		}
+		moved = zoned_move_bg_to_space_info(fs_info, found, reloc_sinfo, data_sinfo);
+		zoned_dec_bg_ro(found);
+		btrfs_put_block_group(found);
+		if (!moved)
+			return;
+		goto again;
+	}
+}
+
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 20180934aff6..31d1fcb6303d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -105,6 +105,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -291,6 +292,8 @@ static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info) { }
 
+static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.0

