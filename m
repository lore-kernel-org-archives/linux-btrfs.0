Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590167;
	b=oc/8lkTnlbSlCvcZWcq7nvLbk4XRd5/XuxWI8T2kGqU16amm1iqfRPeLJv9H3pskL/hU
	 PDTb997IGGY7Haswk+BwENWXWySa3SVyBcANOR2AA5P6mlg8UiVpMhDujs+jv7R/apqUW
	 tx6rCRnPvS0s2JT024mKkRH0w6OxvyIQoinm20mE7Zp6i56N8jjeJde9xW6/Su9u2G07J
	 DpkhcO5/7TXEv9A3pSZ2s1fXh0pLuyp5VSM1CucpeZoc40H8uF8tPMvlQlFvI4YQvKm/j
	 r3IDI1bkizdx6QiGGOzpy3r7HtEadxIgkhyD3PYV67PY/CGm1YlK+A8I+ciFhswAh5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590167;
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
	bh=4meVrISSuyra3NUFbe7fuX7AhF7wAnSs86vDhZxZc9k=;
	b=Ks+8B49YkVqjmKBwQ3jK4rHbJL2MiuKPjkfS2cDhSctGXtoYLnDygBAj98iBpLyRFYu3
	 OKcCxHDZfl73nbAFbeiVtfrIxOzhNSety+EzKCeSzUbprZsftSV1dv3oLVaK/0x76p2+9
	 mKojEVAuzPiygZPweWfN3KRp7XvZ/liNAHYEiRIrZIsKn0WTP+COuxp5tiLNpiq9ki44W
	 dQQ8fwnhL/Bf1dlAqEIpRmXlIp/yESWhxMkroJOOQl5QwTq6XzKy0CfhbZ2fz0WLrHIEm
	 dztxNFLvZBcSifkbC1YFIQ8P01whLrcgyZL06P2j7bdmXpVM2i35TWpBKj1iPaqHq2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ElpEzXMh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=PFusLlm4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6031606A320
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6031606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ElpEzXMh;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=PFusLlm4
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590166; x=1824126166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xv9MVJwyVwc2HuChG9OqrB+IxcDUy3yoMpawxWGDa80=;
  b=ElpEzXMhPj647IQV6zsimJZX15E541vlMyyerbK26MOxZCptVrxGJlpY
   GQcoKsKtELPGFHIBaxzFYp6xZL4tmB5pge67LFgBT+hM2gomV6Etz+REd
   Eb+1OYFL6oa7rEl4VbAytSYVK20WaM2dqoF8kTWksrinlRGawYvch3leh
   QjO2osUg8dzhCuehNc55+J47oi6gsuQTfY5SWRLq+hzWKioUD5kFxPltZ
   +nZVJ7EDxdur9H7DMwwLzdIkwuzn1stGPVJZq0xEoJCHOmfWZHBMiCOqv
   17Deqn/iuYu9G5mlc8CMuA6cGDkm2ZSdfZkIRJ+Ki/gea8E3HoeqeskOK
   g==;
X-CSE-ConnectionGUID: xSajqYC8RD+pdsoKqSmlYw==
X-CSE-MsgGUID: abojKLu3QRO37aNBPhF3tg==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601550"
Received: from mail-eastus2azon11011005.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.5])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ThxPfzAiooVbLMxJfw7MTpKPBdhOwlvX+qjx5YIFK9by70CSgwWdj/EuRuVqYQdHKRqbgzNsNJXNlLcYPToiF+wafkAsbLhBfyj9TvTr9L2svXQ/B4kY4CBkCJCPgyEUSp6z0nWJpULMhJdUdjqhW2DeYFSY0S0ddbE2HchqaYLQxoZ7VOBDsGcjC5HvlKf7RAHI3l0zFqmwvWaK+NC+1J5uZyIiwO4ZO7wPI9s9ifh/3FmqarUj+fv3Hv6wOMluV/HGmzcCD5nxdcl+UCx0A1ebHIWL/zmfgxt3NYWlodyxK4sqEs6uqu1JNwepLp/8tywkGmYojSSrw5F5URotBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4meVrISSuyra3NUFbe7fuX7AhF7wAnSs86vDhZxZc9k=;
 b=Arc7NfC8feblQPshHcZz6zidujUJWhZ81t4j64ML6Hm/uxzVn6Er8LLou8ER+yvvlIaw9KSxrrMcjX5NEVpeXbrpHAxQQv1NdORQqEbBw8XDpsgns+AlD/RflnuneBPkKp8Q8WR6MB1GmYbG3yhnsn/ccH2BmRw1HQy4vJRKzEtzNzOlTIBJ1BSez9ldNWjZyeYhpSxB/qzb7cjINDXyDF9US6yFUXP+223Mc9xn8b9d5VFsGnx1gziCfl9+hWQ/Z/+9EkXSA/UODX4DV7+kfXnj4PhMMewON3w1URaCrYfWNlAMPpBhC8LSuMiTuksHY6Z5aQQQCt5UqbRWweJE2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4meVrISSuyra3NUFbe7fuX7AhF7wAnSs86vDhZxZc9k=;
 b=PFusLlm44X7BlLQhVN6FO0FHyJ/rfhA4RDM99Cpznhm70aGPeMb4MsZRYJseCGDsFdSgN9J3MLo6tlHlLe7fvdtccY+iIoXsmAgectVYLdE7Kd1qF68MtetUXwf4MnbnWGoL421EJTsxT7Juw/XCk3IS4Va9LdYC2SRQ+aY7ITs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL3PR04MB8042.namprd04.prod.outlook.com (2603:10b6:208:345::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Wed, 21 Oct
 2026 13:41:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:52 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 06/25] btrfs: zoned: only take the metadata IO lock for append only block groups
Date: Wed, 21 Oct 2026 15:41:05 +0200
Message-ID: <20261021134124.2338902-7-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL3PR04MB8042:EE_
X-MS-Office365-Filtering-Correlation-Id: 447ead70-4a06-42fe-2453-08df2f791078
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|10070799003|23010399003|6133799003|10067099003|18002099003|22082099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 M64DdgA3AJfcn4LwLtdjdzKOCfcOii65NJW0utwqLOHQQk68PQZ6nfKTDeOTpIgbG19wWr3ju6lM8dne2TF46N0ZP4Svj67SF/T5iWfoIsQ+lDghFD9Fpny0qaUFwIcrFRy9zdGegy9LZanouxL3NurkKdCeBwUivJ0ABPQnsiepP6//oS+N4ct8xg0Ystus7ewulVfHPN98Ii4uCJGOCvqwNY9p3UMBhizz20Bjf+FFRt2jY0H/1NsS+ZnSr0PdNhv4NBSzZYButP8GSzZVHVcj0rfprQWdnD2I3e2yhy3qVo/Goog73KoUGkciTuP4R+bMRGS4LwvCUcOlpnd1MB7TntMsnpcvGE/LK8RxFokdGeH2OX0au30mu2xbs+E31E1Gm1r4tC/rEHOFJQc8UYshb2m33dh1TQ06AuS+fDJzKL4ItYYQR23chCpiucZNP4vWolzJXIIKNze2/hOxWRmwCvn/17Hq9QFmZFRDmo5qXOKOaL6Psn2KaTNhJV7IhUEheYYY3GAhFfArKNxzlUQy37irEjNlFWu/Qtm+QPZbgCi0c5+TiSaiztH2pOFaCiyPUV1itG1GCU4L4Pu06eoLDFkIB6s9u/3YVtSIBkY0h2FcTkP0O30ruTNvg90i08gT5R95L+2DC9giVCQR1mIClir2uimQpbCZA05wnGo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(10070799003)(23010399003)(6133799003)(10067099003)(18002099003)(22082099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?CdDwiCuantZipsHbp/2vkbng8EFCH8csgia7PHI2YENFXJWILLb1s6rMhvtt?=
 =?us-ascii?Q?lxeI51nKqXBtJwwRNw7Y87/RsHiiRJxAGmUUs5plzpVT1dKyuib1vp3llxZR?=
 =?us-ascii?Q?KD4Z7KSsR5cJ3pUABl6BDzrmQ0PZxFZmXSHbznw05KW9se2PYcvQPqR5Wlx+?=
 =?us-ascii?Q?BQM5QkT74pOf61tAykoqTuUknfMKp8i8t42mIWgFewthr2IeCLlJIqLX/CFi?=
 =?us-ascii?Q?KDIA36lq/HvI5IqJJ+Q3CyQZsI3TBwZSDBP2U4bwUBHZ8o5/K/5vdOMrXZHr?=
 =?us-ascii?Q?UU/tbpUtQPqCxjIQWTTVyh1DmTyCBd4Yl4TcGRMMBRndLVlvVB6sHqDCOEWb?=
 =?us-ascii?Q?kkLz02YPXYBn0t/i4vY8rTRHkgpxzDUrfiHyxanPP5JyX83RCIKhtUuZ+6yf?=
 =?us-ascii?Q?I2WAQop2uArIRpS25lAhQVPnOQmaNmzLuVVgMpxLxCuK6ywWHA/n7zd4Xhu7?=
 =?us-ascii?Q?k3tvsocJA92ou4BaZ6dHFwWI1QGVUOImtbvW9pT0V07aLkabkNvlvXCtQN2r?=
 =?us-ascii?Q?i6Qv1YBszkQ4yIMx7ZhDKjHn6rHO8SfYTWtw+2859KNVZWcgCNXTdTxiSeXB?=
 =?us-ascii?Q?NFu/U8xCtUqeepdRtw2KFsRLHX11Mj3fa+2W+kMnypXwsJftuOWnOVtdjH0M?=
 =?us-ascii?Q?8AIV0/hvJYy8BB178yhj+iIb2gWABZm6XgHHV4eEwwY8fPWSBbk7TN1pl5nR?=
 =?us-ascii?Q?wUgyyzDW8ilXkxBTf22zvI+Jw0sxjvrZSPuzo5kPDhiySpdzBv3VaP95txTM?=
 =?us-ascii?Q?uTkkq/4cK613RiukkwPfG0f9mExHvPqH3ya6hd5wPN6SdpjFUMS9RYwt7uPM?=
 =?us-ascii?Q?ELOhPnl6Tp3qmhCYt6ERXfvqY6AqisyRQLeFdpOLxrtIJk+uac1LQtlDqA5K?=
 =?us-ascii?Q?22zNqX0VHoROn299q+xcDThfcl94nKDKtJvh6O0jsDqF8mtqlYc9a6xijJvp?=
 =?us-ascii?Q?OsOO11pONBB8ow+JD5OLAQDydZFK2cmJaTMAmQ+LkA7e1ZvphCnedyhKmQAe?=
 =?us-ascii?Q?IyAUrASRZQvcZ5UHhdDR6TZt12ZOW1DVakEY+LMDbq/2kZj1HjWS2ZDRUznB?=
 =?us-ascii?Q?dWKWYedypCgoMd/RBZgiSuxmNKJAm02qN5uP7UCRRDshZeC8mWMaURHGGsqk?=
 =?us-ascii?Q?PDi5S2TiWE9rRcrtJeOMo1d3OTJp/vjI6R+aY/3NYugXaYDeb8q8noCYvsSd?=
 =?us-ascii?Q?kUC1PxqdgY7/coddHG8pq7uZ0oJzRSKC3IzGQuakZ3bIXZaKuIrjO+bs6NaK?=
 =?us-ascii?Q?Ecxy9TvJEXlCAqlhauY9rHQ9NTMSw+8bDZwkGSLzRXf1Po5VzeL66BpKR03P?=
 =?us-ascii?Q?pNlrl3DTM9n75x2X9667eQ6zjHiXixyrXHY8ipzo52rqH7EValDbAdTzoIuv?=
 =?us-ascii?Q?yQyad6UMZw7f3szk35Br2m0jBQvYgmVG6+a0bQzkU4f118bJRiAHqA3Pc8p/?=
 =?us-ascii?Q?yA3wk4mMZoZ8RAF26rUjNoHWjHuc+j+KEYcvK3+KMla23EK5bTCJk/IWAgzA?=
 =?us-ascii?Q?Z0PkBygiWXSXxHBCo/ikonO3ENUW8+XzMGJQr9m45CgVKOeWEA1k5tWo5SbJ?=
 =?us-ascii?Q?hVA0hTowrwxL9R2bMFJWN5VC6ht17zZTPuDHfT8cLIqfXNWjjkx2qZBGdR+c?=
 =?us-ascii?Q?j4MVOFejh1JG7m9vDKZa8OVpW02o/NCHYRVFgvTTAXRklCg3bI/kzBAwHlx/?=
 =?us-ascii?Q?HEcEvhdOVHyvfOVPeOQslVA90Dwj9vUqM71LYBp4bvWbe9pnbnYGv45472mZ?=
 =?us-ascii?Q?nJ1vhqNRNbAGWBRYsLTRGVcFOZaXyO9R0YU5H2HQXfV9jdbZKY3KzTxY99Kg?=
X-MS-Exchange-AntiSpam-MessageData-1: mWv4PnpsFyS2itZg0t9q8BE6tdAmqMJv1mg=
X-Exchange-RoutingPolicyChecked:
	zO/orp+z2tqm7AcOAJdhKP9BYgb7v/mptmkEjQ1BTSE5h9qPtQULdDHXWfS3PHG3AT5Ji1nhKGhKlnS3Ha4OWzmEN0eJ9MXJOUaxI6LyyFJ4UXEWUE4lGDErQJvmHS3PYJjshibBz8n7ItpKod3+hhAsrlvZ0TZ3eAS3yKkmxDIK6NxoN0WmiBhmFELPaHdNcv7qQB50VgK+w0fdrQL5ftD5phwj/WM8w+vA1SsZjHKwbGI4kPFKflr54Vk2/z1kAxiO194+wm3olfgvyh3reAghUfDE3q21nXBXFk1kFiWRZnebPWXGG5rUoMoK3T/kNP0EEVIEKsf0Gb/wqQ1XcQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0sxhLRSyE5Y0HSJPXh47IeebOXKX41RJlTJ1PwD5kN9+msmgbt54u24pRWmvJy6P3cCV6DASznFAn5JVyIKAESWE252Outykg+2L7b0X8t7V6leBAcxTYPPGxXusXJQYC6FQs9j0q63Ssl1EixCu6txsG7avuCKxndSnretWbPf5fRuSaU1G882r8fjJMAS8S36rD8rNbtxlhCS3Qb7ioNIMluPfI6EscQ99jB6Vm2iSAw8cKfgqPUl05KWoLg7zABJrEpo10LXXmt9K5rThRpUmFE0gZpttpTfoFlUK+g7q0m5czk2FfDWKrzRsyi/iO+zOyXWPOgnxLJwpYRISC6sj+Zz9N/5UQati1t18IEq+FhJ2GXv5+/QV43w+5bhd1niUuiYAsHqJ54bFJcaEJ8yymsSrDljfd26eX29he2Ct9hLlKzNJLq6wFFKQqO4Zt7D6k9+4qPuP0vKkn8ATwfNGScV4jevGpzzeJylRWvjBOdAl+XiWrw/tEb+brZTXe3HI1YeN2uWleWyFIN8FUtVEfQGKfJ+aUT831T6DN7ZiDJwmF0z1G8vU/srgruPc4OIfaApNEv11Cy19BWEOLzJfAarS1h7SymJ6ac4wA4XSU4iK+ruQx8WzfUahFU6D
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 447ead70-4a06-42fe-2453-08df2f791078
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:52.4600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u7Pus61o4YO3lg8B3f3c50m92l19YaGWMnx2ICJR7WxMvjEoX6nHyDUDbKkUW4VYlGvajwFVMCwuL3pzX949u3VoLAVhDJUGNmg6Y7UkPYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8042

fs_info::zoned_meta_io_lock serializes the metadata writeback against
the zone write pointers and protects fs_info::active_{meta,system}_bg.
Metadata in a block group backed by conventional zones only is written
in place and in arbitrary order, so none of that applies to it.

Acquire the lock lazily instead of around the whole btree_writepages()
walk: take it on the first extent buffer that lives in an append only
block group and drop it when the walk is done. A filesystem whose
metadata is entirely on conventional zones never takes it at all.

To do so, split the block group lookup out of
btrfs_check_meta_write_pointer() into
btrfs_zoned_eb_write_is_append_only(), so btree_writepages() can decide
whether it needs the lock before writing an extent buffer.
btrfs_check_meta_write_pointer() now expects the lock to be held for
append only block groups.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 70 +++++++++++++++++++++++++++++---------------
 fs/btrfs/extent_io.h |  2 ++
 fs/btrfs/zoned.c     | 40 +++++++++++++++++--------
 fs/btrfs/zoned.h     |  8 +++++
 4 files changed, 85 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b49581eeffa..9a85fd478d0c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2547,16 +2547,15 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 /*
  * On a zoned filesystem, write out the currently dirty metadata extent buffers
  * of @bg. Used to flush the active metadata/system block group before the
- * ascending-address walk in btree_writepages(), so that walk can pivot the
- * active block group away (finishing it) instead of aborting the commit; see
- * the caller for details.
+ * ascending-address walk in btree_writepages() writes its first append only
+ * extent buffer, so that walk can pivot the active block group away (finishing
+ * it) instead of aborting the commit; see lock_zoned_meta_io().
  */
-static void flush_active_meta_bg(struct address_space *mapping,
+static void flush_active_meta_bg(struct btrfs_fs_info *fs_info,
 				 struct writeback_control *wbc,
 				 struct btrfs_eb_write_context *ctx,
 				 struct btrfs_block_group *bg)
 {
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
 	unsigned long index = bg->start >> fs_info->nodesize_bits;
 	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
 	struct eb_batch batch;
@@ -2591,6 +2590,43 @@ static void flush_active_meta_bg(struct address_space *mapping,
 	}
 }
 
+static void flush_active_meta_bgs(struct btrfs_fs_info *fs_info,
+				  struct writeback_control *wbc)
+{
+	struct btrfs_eb_write_context ctx = { .wbc = wbc };
+
+	if (fs_info->active_meta_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_meta_bg);
+	if (fs_info->active_system_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_system_bg);
+
+	if (ctx.zoned_bg)
+		btrfs_put_block_group(ctx.zoned_bg);
+}
+
+/*
+ * Take fs_info::zoned_meta_io_lock once the walk in btree_writepages() hits the
+ * first extent buffer of an append only block group, and keep it for the rest
+ * of the walk. Metadata in other block groups is written in place and in any
+ * order, so it does not need the lock.
+ *
+ * When writing back for a transaction commit, flush the currently active
+ * metadata/system block group(s) first, under this same lock, so the walk can
+ * pivot the active block group instead of aborting the transaction commit with
+ * -EAGAIN.
+ */
+static void lock_zoned_meta_io(struct btrfs_fs_info *fs_info,
+			       struct btrfs_eb_write_context *ctx)
+{
+	struct writeback_control *wbc = ctx->wbc;
+
+	mutex_lock(&fs_info->zoned_meta_io_lock);
+	ctx->meta_io_locked = true;
+
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
+		flush_active_meta_bgs(fs_info, wbc);
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
@@ -2625,23 +2661,6 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
-	btrfs_zoned_meta_io_lock(fs_info);
-
-	/*
-	 * On a zoned filesystem, flush the currently active metadata/system
-	 * block group(s) first, under this same lock, so the ascending-address
-	 * walk below can pivot the active block group instead of aborting the
-	 * transaction commit with -EAGAIN.
-	 */
-	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
-	    !wbc->for_sync) {
-		if (fs_info->active_meta_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_meta_bg);
-		if (fs_info->active_system_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_system_bg);
-	}
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		buffer_tree_tag_for_writeback(fs_info, index, end);
@@ -2652,6 +2671,10 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		while ((eb = eb_batch_next(&batch)) != NULL) {
 			ctx.eb = eb;
 
+			if (!ctx.meta_io_locked &&
+			    btrfs_zoned_eb_write_is_append_only(fs_info, &ctx))
+				lock_zoned_meta_io(fs_info, &ctx);
+
 			ret = write_meta_extent_buffer(&ctx, wbc);
 			if (ret == -EBUSY) {
 				ret = 0;
@@ -2684,7 +2707,8 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 
 	if (ctx.zoned_bg)
 		btrfs_put_block_group(ctx.zoned_bg);
-	btrfs_zoned_meta_io_unlock(fs_info);
+	if (ctx.meta_io_locked)
+		mutex_unlock(&fs_info->zoned_meta_io_lock);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d8dd2ae9ff9a..c73953a2e8d3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -143,6 +143,8 @@ struct btrfs_eb_write_context {
 	struct extent_buffer *eb;
 	/* Block group @eb resides in. Only used for zoned mode. */
 	struct btrfs_block_group *zoned_bg;
+	/* Is fs_info::zoned_meta_io_lock held for this writeback? */
+	bool meta_io_locked;
 };
 
 static inline unsigned long offset_in_eb_folio(const struct extent_buffer *eb,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9da4709a6608..c4a655a2fd24 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2274,22 +2274,17 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 }
 
 /*
- * Check if @ctx->eb is aligned to the write pointer.
- *
- * Return:
- *   0:        @ctx->eb is at the write pointer. You can write it.
- *   -EAGAIN:  There is a hole. The caller should handle the case.
- *   -EBUSY:   There is a hole, but the caller can just bail out.
+ * Look up the block group of @ctx->eb, cache it in @ctx->zoned_bg and return
+ * whether @ctx->eb has to be written in write pointer order.
  */
-int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
-				   struct btrfs_eb_write_context *ctx)
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx)
 {
-	const struct writeback_control *wbc = ctx->wbc;
 	const struct extent_buffer *eb = ctx->eb;
 	struct btrfs_block_group *block_group = ctx->zoned_bg;
 
 	if (!btrfs_is_zoned(fs_info))
-		return 0;
+		return false;
 
 	if (block_group) {
 		if (block_group->start > eb->start ||
@@ -2303,13 +2298,34 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	if (!block_group) {
 		block_group = btrfs_lookup_block_group(fs_info, eb->start);
 		if (!block_group)
-			return 0;
+			return false;
 		ctx->zoned_bg = block_group;
 	}
 
-	if (!btrfs_zoned_bg_is_append_only(block_group))
+	return btrfs_zoned_bg_is_append_only(block_group);
+}
+
+/*
+ * Check if @ctx->eb is aligned to the write pointer.
+ *
+ * Return:
+ *   0:        @ctx->eb is at the write pointer. You can write it.
+ *   -EAGAIN:  There is a hole. The caller should handle the case.
+ *   -EBUSY:   There is a hole, but the caller can just bail out.
+ */
+int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
+				   struct btrfs_eb_write_context *ctx)
+{
+	const struct writeback_control *wbc = ctx->wbc;
+	const struct extent_buffer *eb = ctx->eb;
+	struct btrfs_block_group *block_group;
+
+	if (!btrfs_zoned_eb_write_is_append_only(fs_info, ctx))
 		return 0;
 
+	block_group = ctx->zoned_bg;
+	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 3a2ca8bd68e5..f9dbab976a92 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,8 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx);
 bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
@@ -216,6 +218,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+						       struct btrfs_eb_write_context *ctx)
+{
+	return false;
+}
+
 static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
 						   u64 logical)
 {
-- 
2.56.0

