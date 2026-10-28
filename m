Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793194474;
	b=x6Hr7R5T0Za4e2EP7p4krP1dwrlyme0z6eBn7lD8L8xbVjKsNiD16w/80qbIRJ1dibjr
	 YE3XeuO78++DlA4aShWLfYkRBurnmEcAlwM3824bCejETr7xJEOGqfXR7n+ZMfctyhJCU
	 T3o94XIWubUpTKI+4K2iTkHAU064YQDyGLxjgm9o5/tP2HO9BVhXd+Zn74jk56YKLjAFX
	 n1iBDc/iPGGhz6xlp4PQUY3+85H4jtxtu5n7WKVQqoJUVc6aVsuwX4JKETk3KFwtMh/7K
	 FZed4BFMuxdm33CWSu7B8JwCjEdHfWq3RRnXvyiiblsIRzhklvy/0B0GZwQ0QTjZsbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194474;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Subject:Cc:
	 From:To:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=ORd4fNQGZ0dLssMovHmG+IqxXRAS4JT/rAPz/V3hxhA=;
	b=kUY04b9BuQww32YJRFUgep9npx19wQx4IfxuEJZxi48nhns/xTDZyw5ck1Ltw7u8lclc
	 QuhbaRo3zAociRJDai/ExLEdcuT7NTB5GonhwZTWFF8g6+BKvWMdPC5p0NfUpbQClE9bd
	 eVN6HXGkbsVOuaMjx8hOin0t78TyEL0JRRLaWMl0bE8PV9Jwi7lNuSYTeCVc8zWsvKy+1
	 166Ag3t4Du1nU/M1dXg+e0eeeELL9rEvMiCb4qzarOicyh/0LJJViU7jXK/OdzCG1XmZo
	 HRpQafF3OkJi4mXqpdi51bP961RK7kIUnn7X5zUM/dAnSqKUdITvgcAF/gGjdv2nZLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="IG8OAy/c";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rT1MlcXf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BD6606A33C
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 13:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9BD6606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=IG8OAy/c;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rT1MlcXf
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793194473; x=1824730473;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=U1HD1VVfAPBuSLw3Xa0G0pgvuB6fT52Bxc6L/SJaRHI=;
  b=IG8OAy/cL87FvwqXaGcF2CFKd1YgjPHqacXpO6I8JkDzf3euhXEED57t
   icAxUAsODnOkZTopyQVYA8fasKT74hV0efc9nii9OliqLh35/DgLFZ5lm
   aVgFdrz+ejAR9I8Vp8R6nSxtWWmNpyQosdxriIbvImLadzq5+Trv8ACnE
   8NO89JPjHSyYW6lz8rqOOEKEyDeYwlcRvFl4ftyTkXaP64euB4umsXrWK
   fMXHDMiof5nzF+jFArG8hba+cw3hgu0/96+0YyzD+U4sNCi/OJQZx6uF5
   Czfwokav1MxWEQsdoRzsJuO8l9xW1gXObYtoN6Elu6J4eAdPsV3X9ATYf
   w==;
X-CSE-ConnectionGUID: sUZ+IgnuSE+xkIAjpIdPHQ==
X-CSE-MsgGUID: KQOCHyoARv2WSt+2d+kArg==
X-IronPort-AV: E=Sophos;i="6.27,182,1786982400"; 
   d="scan'208";a="160172909"
Received: from mail-westus3azon11011031.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2026 21:34:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eNpFN5unGYgzEcM+vOkHeaybw5XjRDWJr8i+05l6aqSuLD8BXEKj1wvz8yg1CWxtYGc1oLznHcGvlInFdJJXS2H1O9KD3nuCBp6UlM5T/CoFdFgNjMpkH42bC4sGE7bIJQZG63a2WSC1sEjXv3C/og82sPD//NNnDRAB+EhxGDo3e7KoOL/9yPEExYmgsSvv3LAFV0WrM/Z0LmbxMrUUM0e0kXb+qQnufmamPDsFBXWyTAtZI7Y/e2JKI+YAL0cIpvb/FZom0q43z6Qv6uc8dDrZfCwHmd56imlNnPa5o0CGrdANZen78CZE+UHSlGoUnCr3ATV2gLOnnP1RffbAfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORd4fNQGZ0dLssMovHmG+IqxXRAS4JT/rAPz/V3hxhA=;
 b=qGtOB8dQtmKR8G5bsbyw5xeudB/hek6sYCXG4kyB9EH/M4bKKZX/EBVdoY2vGnAbt9gHwI6KXfP3O94Hh8fgBdk9rhv4ST6zMAP7snbQEFm465zr0AvGRCDKqn7a/zTpHuexwcrIJGcn05RI027maV3ibQwhCsP3dX44T3OtZQpH2yKUCNmJcTezNtbblO6VpK2RwMSBQsUuOp/OO4n2t2d5mHXHN5dqW72dKIBghs+3DCtAYtntJJAhX9xdPEeTqydd5YbwvPWs66iBNssLoQzSLXXpxBXE8ZoKClsoKjdRF0JVe3o+2OoMozPxqS5cTNNf/34lw1dBbn+bn3kwCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORd4fNQGZ0dLssMovHmG+IqxXRAS4JT/rAPz/V3hxhA=;
 b=rT1MlcXf2MWONvYIxnw351FC/O9Hi80yBC1TFlP1fTwgV4V7ZQIl9VXw1Xup4g7quaSPNuarZdQfvhehJhYXvNVXGYcGj32nSHuZDY2iJpmChtuf4UfwyAGU5BwYCP7ChJ9mD05Q3b7rxXTnxOcAHVwguJ9lSYCE0d/XjdY0FHY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from DS1PR04MB9276.namprd04.prod.outlook.com (2603:10b6:8:1ed::21)
 by SA6PR04MB9117.namprd04.prod.outlook.com (2603:10b6:806:41e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 13:34:31 +0000
Received: from DS1PR04MB9276.namprd04.prod.outlook.com
 ([fe80::1a75:e6a2:9c9c:659d]) by DS1PR04MB9276.namprd04.prod.outlook.com
 ([fe80::1a75:e6a2:9c9c:659d%4]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 13:34:30 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Oct 2026 22:34:26 +0900
Message-Id: <DMGIDXEPO8V3.2LE741KPVLNQO@wdc.com>
Subject: Re: [PATCH] btrfs: zoned: fix lockdep splat on mount
Cc: "Naohiro Aota" <naohiro.aota@wdc.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261028115727.72333-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261028115727.72333-1-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TY4P301CA0099.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:37b::15) To DS1PR04MB9276.namprd04.prod.outlook.com
 (2603:10b6:8:1ed::21)
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
X-MS-TrafficTypeDiagnostic: DS1PR04MB9276:EE_|SA6PR04MB9117:EE_
X-MS-Office365-Filtering-Correlation-Id: 22bf8650-14d7-40fb-842d-08df34f831cb
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|10070799003|376014|19092799006|11063799006|56012099006|261022105027099003|261009223027099003|261022075727099003|261026121527099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dposgTubUssxRgNGY3Gq0vA8N6pZogDYxCLr9yuKqvaIaTB6exADDiSKcjGnYsg9y7tgbnylKhyOAcyQHOWLmTdYDRxdhKd3bjO7rHUXllgEiwJAxswfDTB04Jen3ooNzAd3YrHtvq9Brfj6MwotAk8sOIuVByNbc2U4gPTUMg1vaHtsTWYgTTN6VE583VW9ElmIWZOSGItJLg1VbFk+nOeppJb3ofEL0vvGhHT3WEtazr5DE2Z87kb4UdOvz7ZZs2LZvhHs9pWMJdAYwst2CIBV+MyF3CwPLJJZ/uIaMTJYq1z8CG2aKdIzrvGFx28/7FIktPxEzg3KQSdW0PSKtxq9qnTw5vpr8IDkg7K+PFbr8Ng42MHIimDFhm95ggnLiEhh8lOH1HfMeFSgM1VR8HH+DNp6eY/7aBfVmK8o7E9Wwl4SAS+pk2HE0/2GFMUa1Oaxjxp6bHbGOw4jHIOTdbLeBD4CzQlazxF0E/g+CSW+9ZArasDJWWrS09yWVtq1a6k88LrmJREwAIvKfSklShwD4f73N3KZ2SoAzfjnek7nF5zYTKZXjfEy0J84Kz5Gy47k8yv4yz2q9VDPGoY8WTbRTwxY4mgjjm4+Poe/iTgsoaDJigzqxPaTqcbdlXwc/BqBc1oqad0eAFSllFm2pR0VlqwrBhxjM+XZjsm54Gc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS1PR04MB9276.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(10070799003)(376014)(19092799006)(11063799006)(56012099006)(261022105027099003)(261009223027099003)(261022075727099003)(261026121527099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vk5QcmtEWTJCMmd5dGo4MkdwekUwNFU2ZUx0OVlSMXFNU3dRbGhrVjRNQzRp?=
 =?utf-8?B?ekYrRW52UEU0TFVMNFh1MFpLUWRNS3BoeVJIUVNhS0lpQXhBMGlaTGlDQ3lw?=
 =?utf-8?B?cW1uWDBrSGd1SXVsSm9HWU96MFVGYWZHUUF2S3RIYVpwc0VOdEl1QzNHdVBz?=
 =?utf-8?B?R3dlR2EyUjVwV2d2dnJJT3BEdENnM2VmdUxGWHZjTW83VGVEcGQyMUd4Z2k3?=
 =?utf-8?B?eWpScnduaTk4QThLZzJZaWYxVFNhWmppWE51bzFlUDNMSUthc1VzNWdnODYy?=
 =?utf-8?B?cHFpd0VyVzA3TWtoVlVHajYvVFNCSzg0OWxGSzdSZnlHSHFzZzd5Ym80Znhl?=
 =?utf-8?B?NXR3Sis0NmhaK0Evc0pNbjE4NHhNU21kcUlTSkVZL2xISTRhQkVGc2IzMDdx?=
 =?utf-8?B?YjJvOS93NkRaMmRjVEYzalNmVTVFS1VnWWN3eHYrdEJMWmtOYkJmdzBUKzVm?=
 =?utf-8?B?eW9nczdDTVA1Ky9rT1FSZmZuMHdrZDd0VjFub293S3dIT1BsREdrUGdoVmhG?=
 =?utf-8?B?SU5pYUZSM2JnY2ZhUk5sY1hMUXB1RWU3RXhsaUlMdmdUNndHd3pBcVA1MFJO?=
 =?utf-8?B?Mlp5UjQvaHdUYXBaWGFtUU14MFlsSmg3ZEtDQXRmam9rcHJsbklzczZsREtO?=
 =?utf-8?B?b3pwMFR3eTNCT3NTdEE2QVRhSlYzcFF0WEtEc3FWdjAyR1JJTnBHVElmNC9F?=
 =?utf-8?B?M0hhVWc5ZUtVSWZqNStMTkQxOWlHaENRaE5UVldTbFhuUGRJU2pEc3Fsajg2?=
 =?utf-8?B?MTZOQjhKZXRodTU0SkhQYllDMEJ0d3IvV2R2ZW5ZeGFmK3JKejFremZlaStH?=
 =?utf-8?B?aGtPTmtYTU1sSFRXVXZsQ3RJelVXcG5nMnVXVFR0V1ZvcUJyT3NJK1NJelpQ?=
 =?utf-8?B?eThuYXhGSzYyTy9YS2VCM0xZMm93dVNzMDdJYkpZSjRSb1F3MmVPTlFmVWdx?=
 =?utf-8?B?anZmUCtoblFuWXp4a09sT3JwWFA3UXZ0Y3RQQi94QWh4T013elN4NmNzT0J4?=
 =?utf-8?B?cEw5YS90VjQwZzJ3VmFIZlAwMUs3Z2p4TUJBLzA0RXlTRWJjMldwT29jMFZF?=
 =?utf-8?B?NzQ4LzcvTklCWTlFZWR4anY5VlhOdnFtT2FWVWU2T1EvMEFhV0kwRU9JMFFF?=
 =?utf-8?B?b293LzBYaUtURFZ0b1JZNVBxOFo0bEQwNnAyL2VQZjRFK21FYmkvMlVLRFdu?=
 =?utf-8?B?QUl5bVA0enl5Z0pKZjZEUWpSWXQzY3R0Z28venFnbFhBbWd4czM4UXpLUGJE?=
 =?utf-8?B?WEwveE9Fb09XTWc2MHVJRlFObkVhT0htemlTU21IWWtCblpKSEswZ0lFWGc5?=
 =?utf-8?B?NDBIRXlQSk52ZVdLTmlPd2J5VjJFdzk4Ly9VdVczS1RlczBzdWNNYXdzVW9Y?=
 =?utf-8?B?T0p6eUppZDBSSjhQbWNUMk5aSGpleGhUcWJ6ZFA5N21DZjNYR01aanFORFhX?=
 =?utf-8?B?YlhwdW1FUE5OcHBmMzB1b3liOTJieDhiT0ZjU3B3d1RmUHJlVlQxemRWZUFs?=
 =?utf-8?B?dXg4ek1yQ1FOVkFXY3RCNUNsYzkvbklBTzE0RG5LWnpjU3F4QmpjSFIxNHly?=
 =?utf-8?B?aHNxdW5XSXdPUEU0SkV5aEw1Y1RlaTluazdHdE5jMml3REZaejNFRlkwbmgx?=
 =?utf-8?B?N2lkaU5IVTFpUStnTFdOak5jc1ZINVQzREFVTVdmeDg2Tno3QXJFQlJIc3lq?=
 =?utf-8?B?Rkg3bElxb3Yxd0I2a3JZd25pOGtTUHMyUUJmb3JndEEvN3dscGJzaGU0UDVy?=
 =?utf-8?B?Y1V6cjhCaWxFL3czanlOYTRrZjNXYTRVaHd1eE5pVDVUN1ZURkM3RzZTb2ds?=
 =?utf-8?B?TlhBWVhYaEF4TitLWDQ0cGpKM0Iyb3BzL2VHd2g1WVBHeHhpNkcyeWtQZ2RK?=
 =?utf-8?B?REJtZUNjREpreVordi85YzVMZ2NJRWdEaFVIZmhGeHRSclV2OWJCdndkNTM3?=
 =?utf-8?B?YnFWaGo5Q2x1TEdzVmVqNFhmdTdpSlQvVWozanFoTnN2cjhOSjZLZzU0Y0lK?=
 =?utf-8?B?YWUwSUdaQjA3YzRudXgrOURZTGs4NWt4MFY4cFRCWUw4QURUYzNWTFNiVlR3?=
 =?utf-8?B?eWlWOGZOOVFXWjE2a25UK2ZyQU9LOVFvSmIyWjRKSXQrVjFtYjVnL3orOEdP?=
 =?utf-8?B?WHdFRGNQU0h4bHdYU204NFZqRWZUK2hCQjRJRGxkVnQrUFdhbTd2b3pmdHEz?=
 =?utf-8?B?d1N3cUlDcWxrV1NZREppQWkrMkdtTFl6V1Y2aCt6NytyZWFFK1RNWkdiRGpn?=
 =?utf-8?B?WVNQZ1hKcHR2b3F1dVdmOWJBQkRaWnBOU2FyVWI3QVo0ZFNpMjQ5U01hUlB2?=
 =?utf-8?B?NFNPTHVMS21YbDM4MnNMckFmOVBDeHZESSt1NU9zcDJMQWt4dmFyaU0zNDBZ?=
 =?utf-8?Q?5ja+0Yv3c3PRDNGQikjBuDXcQX6hCZJfN8IJPwNf4f8AC?=
X-MS-Exchange-AntiSpam-MessageData-1: 2ohGhTbwRg8Bug==
X-Exchange-RoutingPolicyChecked:
	mF1DC8+Ta10OBc0zP+IYagufByN1Z6mLbccRZNt3RW+cmx4qlUfXLjHCb/TM7mLXbg2fvpNS3grpIwT0/Oq6EsMAKo0mb6v746x/1R66tu1FK1m4l9LHYp0Mw4Ub970dwl5CH2Ohu4LZw8+IzHPAtGoKWpQ4DmI0/PPRB3SMHi/q/o82C2YIMJzQ1gI6rlbO2vEwK2GJeX0GnnoayjhP3Kt6KDhWKUzmMYT29DBUsdiT5vVhkzAb+Q98n2t7z7srQer7uRhBUyT5rA5dbpZ2Lvo0xlnLhPkw9FPCjSLV4KNjGlSeuPhuasXHS462dnfspoVh2/49lgUz8a1bjZ5NNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cUoxDQPKqtZ3Hi5E9FXs8lKFi8QXB/0NRSp1wdOpRaaW1C09b1p5VuhKMuvmyh2oTBse8p6x0kcoQr8J/ChEX/zNQoWQgSElpn8KrFVWhpii+NqujnxtI38BwMWtZgCLewl183i6tGBzZ/7kofVhPNzadq2IxZextlv19tNCMX9AClyk3ah1scE/AfU9PSa3wOQ7K+FVFPl8PK6AGAvn0C1qMBvMKCo05eVeYys5pKtFtiEf3HzNDLaIkxrzNaIjifMj+xjJb6SSRkNIHHv7lfFl1xTFZLs4/I6wzNJiwjz67Lq9d8o4AZEd4h12fkdnpldjaxlx9GVXV2etJx/iHUan26SIe1aGCgpF1Hdz+hhO1iSOIWVIsNU6n/davMF0hCDuSvdQLqQMEYuP9pMF4f+AtWDZMYzEXxjXfG5nsOZTbZHBgA2izBsv0QbNpxrT5yUqcwqUMUq7RlLiljbagFwrfX2MGZ+qa2KtN+hMA/42WH8NhqAUkVVgzq7wEZ7sY2caIVSnS1UGRNYOZoQ87aZ3gD7OWIhofBdv+8TpVUrxAege7OXW4P7WRgpz2qOY4sOabHTjK7LQUTjnWMHU+ZHvO2YHpfzAko9oMzs1ikEtRTafMEKit9qTyn1rzUm3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bf8650-14d7-40fb-842d-08df34f831cb
X-MS-Exchange-CrossTenant-AuthSource: DS1PR04MB9276.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 13:34:30.4366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K76VfdpH/kRUzadziabfgxHtxv0KNmFbMsangRj5M7Vo+JDB5curUV3RxmHTpyEDEChhUEIsOQ0lWsvNDcQyjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9117

On Wed Oct 28, 2026 at 8:57 PM JST, Johannes Thumshirn wrote:
> When mounting a filesystem on a zoned drive passed into a VM via a
> virtio-blk disk lockdep sporadically complains about a possible deadlock
> between BTRFS' dev_replace::rwsem and virtio-blk's vdev_mutex:
>
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>  WARNING: possible circular locking dependency detected
>  7.3.0-rc6+ #317 Not tainted
>  ------------------------------------------------------
>  mount/7418 is trying to acquire lock:
>  ffff888102c07860 (&vblk->vdev_mutex){+.+.}-{4:4}, at: virtblk_report_zon=
es+0xda/0x440
>
>  but task is already holding lock:
>  ffff8881fd725ea8 (&fs_info->dev_replace.rwsem){++++}-{4:4}, at: btrfs_lo=
ad_block_group_zone_info+0x186/0xe50
>
>  which lock already depends on the new lock.
>
>  the existing dependency chain (in reverse order) is:
>
>  -> #4 (&fs_info->dev_replace.rwsem){++++}-{4:4}:
>         down_read+0x42/0x170
>         btrfs_map_block+0x1a6/0xe70
>         btrfs_submit_bbio+0x1a3/0x910
>         submit_one_bio+0x93/0xd0
>         btrfs_readahead+0x1c4/0x200
>         read_pages+0x56/0x200
>         page_cache_ra_order+0x27c/0x410
>         filemap_get_pages+0x12f/0x4a0
>         filemap_read+0xed/0x400
>         vfs_read+0x240/0x340
>         ksys_read+0x61/0xd0
>         do_syscall_64+0xa3/0x4f0
>         entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>  -> #3 (mapping.invalidate_lock#3){++++}-{4:4}:
>         down_read+0x42/0x170
>         filemap_fault+0xb0/0x1a40
>         __do_fault+0x34/0xc0
>         __handle_mm_fault+0x919/0x1db0
>         handle_mm_fault+0x97/0x240
>         do_user_addr_fault+0x21d/0x690
>         exc_page_fault+0x8e/0x230
>         asm_exc_page_fault+0x26/0x30
>
>  -> #2 (vm_lock){++++}-{0:0}:
>         __vma_start_exclude_readers+0x91/0x1b0
>         __vma_start_write+0x47/0xd0
>         vma_expand+0x4c/0x2a0
>         relocate_vma_down+0x126/0x200
>         setup_arg_pages+0x240/0x3e0
>         load_elf_binary+0x1be/0x1860
>         bprm_execve+0x2d2/0x7b0
>         kernel_execve+0x107/0x130
>         kernel_init+0xc2/0x130
>         ret_from_fork+0x1ff/0x2f0
>         ret_from_fork_asm+0x1a/0x30
>
>  -> #1 (&mm->mmap_lock){++++}-{4:4}:
>         __might_fault+0x68/0xa0
>         _copy_to_user+0x22/0x70
>         blkdev_copy_zone_to_user+0x22/0x40
>         virtblk_report_zones+0x297/0x440
>         blkdev_report_zones_ioctl+0xfd/0x130
>         blkdev_ioctl+0x20f/0x2c0
>         __x64_sys_ioctl+0x86/0xd0
>         do_syscall_64+0xa3/0x4f0
>         entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>  -> #0 (&vblk->vdev_mutex){+.+.}-{4:4}:
>         __lock_acquire+0x15a8/0x2850
>         lock_acquire+0xea/0x2f0
>         __mutex_lock+0xa7/0x10d0
>         virtblk_report_zones+0xda/0x440
>         blkdev_report_zones_cached+0x162/0x190
>         btrfs_get_dev_zones+0xdc/0x2c0
>         btrfs_load_block_group_zone_info+0x2b6/0xe50
>         btrfs_read_block_groups+0x338/0xc80
>         open_ctree+0x1aca/0x24b3
>         btrfs_get_tree.cold+0x105/0x26c
>         vfs_get_tree+0x28/0xb0
>         __do_sys_fsconfig+0x324/0x690
>         do_syscall_64+0xa3/0x4f0
>         entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>  other info that might help us debug this:
>
>  Chain exists of:
>    &vblk->vdev_mutex --> mapping.invalidate_lock#3 --> &fs_info->dev_repl=
ace.rwsem
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    rlock(&fs_info->dev_replace.rwsem);
>                                 lock(mapping.invalidate_lock#3);
>                                 lock(&fs_info->dev_replace.rwsem);
>    lock(&vblk->vdev_mutex);
>
>   *** DEADLOCK ***
>
>  locks held by mount/7418: 3, last CPU#0:
>   #0: ffff888110aa6868 (&fc->uapi_mutex){+.+.}-{4:4}, at: __do_sys_fsconf=
ig+0x2ae/0x690
>   #1: ffff888112ba20e8 (&type->s_umount_key#31/1){+.+.}-{4:4}, at: sget_f=
c+0x148/0x8d0
>   #2: ffff8881fd725ea8 (&fs_info->dev_replace.rwsem){++++}-{4:4}, at: btr=
fs_load_block_group_zone_info+0x186/0xe50
>
> Holding the rwsem was widened in 0090d6e1b210 ("btrfs: zoned: fix
> use-after-free due to race with dev replace"), but it now also covers
> calling into blkdev_report_zones_cached(). The device replace ioctl()
> only works on a mounted filesystem and the only caller with setting
> 'new' to false is read_one_block_group() which is only called during
> mount, so it is safe to drop the rwsem before calling into
> blkdev_report_zones_cached().
>
> Fixes: 0090d6e1b210 ("btrfs: zoned: fix use-after-free due to race with d=
ev replace")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good to me.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
