Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590147;
	b=ihD2/jZGSZDNU7pr/HvFInf41rBhLVUzvBNkc+ysJc/qfXWqepENf4UVplWYeVFpUd3r
	 oMd8+EmZ0OAS3C/JcBPghRyRdLCvImUpS2kLowZHItLs3int7ewGt92UsqdWB7CYeIIJD
	 n12cI4KIkJMIMTe3sW+vjfNZayqTArExkx6UGMFUta7wD8kcpDFck3WKdXIBRG9FPHwm5
	 rnDE7cAvJyjXn3N6bnlytyng+etmu/X3Brc+zDz+TnhJXb1xh0ZPZNuc5jNSFyrxy/wFs
	 /8KsqcDhSiKSxqUub9BvapHaA1WL7QJ5KwF6JjR8TprbNNv3EOxtslPFvZRCxzxNr9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590147;
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
	bh=+yKZwYJB991Qc+smG3W6IkWDu/pMiFc2g979nc8WC6c=;
	b=bJma7WwI2ZafOcgL2O+IFml4Jjhckp4h+3bRRSxb4WSLXeTrBtU1l+Iw82dPL3wALsx7
	 1eN7dqCBmy30NPrP2hgwnyoAbprefxvAYa/ukY2jJjhEpyWq76Hq4IPUFW8V+wLiuf3Ob
	 0GGRkSiG4wlLQjRF2xQ/x2Comu5jcapD+S6EPHXmFTLi0WGdEW7OzxUHD0T/K+Vdho4aA
	 yCz1DZ77GvQujhfXkmSjyNCbiLYe4kty/CtmFMObqNl5723iWD2ON/Y/EHlsD9BIJJUJL
	 GYC/fVeC4jJ1ZXKj9i8aNJvvRkxtYyreeWxWfkJKi0Iw5HdcmXG9hyPmucPM23HQl0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=VcBJmBwS;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=z3mkAxC0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F02B60A2624
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F02B60A2624
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=VcBJmBwS;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=z3mkAxC0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590147; x=1824126147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=v1wRdl+DzNPMqr9LO2y4fCjZ+PtCXqcNDmaTWz1+6Co=;
  b=VcBJmBwSwPq9BF/KxbfkFj0KBape4Ljcn8D+z7HLhGhtzvWzxqBz/DJE
   Gn3ggqyQw4VzpOu30hzQ9e7wDFfrhnKDgjLM5gPwG5B/X9Ga8bQMbUNYe
   aush2pSZdD25Nrq1pp8Ad+nBlWD57zXaZ+OmRIuxrHP8hHWg4ZvnaWiV2
   pcP0omO87uaxDsgXsBO3BUpfs3nrkIJ7AJb0fQScqDAZQr3yTW14OsG+P
   dgWaPbbi7fGYq3o/GSBGw5ZdYwMkcsAC1i4alM6Rh26b4lmvX+hb5sK6L
   dKGyug+d3ZH9chCvnN8tAQ9Syfm8auYIFeOy+2QNup7PaspstkvWHtQj9
   A==;
X-CSE-ConnectionGUID: Ypb3kjF5R7u5dhk+N9vcFg==
X-CSE-MsgGUID: hcSvb5+CTMm6TIRw7C2QFw==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601531"
Received: from mail-eastusazon11012011.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IDD/XZcztspOJqV2sOPH8cmqOoKXuKTdksZTqXtSxZ8Lqyb09pWB+Rl1nOvEV2Q70hzFBIWEpjYEi0NyPqoBMZoX7qJco2liCq6jRH17SfDUG9sftyTPu7uJ9m1RpilDRFenPD/+tlVLGTVtTSuBgvlhkleGZeWCzrFyqk2J0bAqtDIHcQMOafMG6QXbpKbtmvj1cNeZbgzOyI11BWZwlNOJMDLaXPCb3cCq2m2/hNaA+3qgeCjTN1yrJVwyb8HbvzJ59nnqSN4lRtxY9YnRyUw5DX9Pw3OSeTLS2slQmMT5gHIc29/OUMlY8vylzGS9PqcavNkdMTutl5DFF6m7lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yKZwYJB991Qc+smG3W6IkWDu/pMiFc2g979nc8WC6c=;
 b=MysjkRvbIT4mkXgjddjWzcyLXppCZ45uFaP/MTM8Bvl+1UK2pR7FvztpnGsZdyqktHzJeKZbuFIdUj9qXns+e52+2TS2sy3jIjSWvhhKKI2RiS0O2noaHC8HG9AR8GBoS3mWHiaMMsZbm/S9OGDy2lL3tXZq5uRoGFwMiNainlQ1vjSTtHfXVIy7Uz0ro7+yGQ76UhAojTLNmu/fSTB8JxfA0IgF5cWWCapAAEm2gmp0asWojcnp0Z44gPCMORz40wxZ6G3s2sGTWcFsAn/KNwEhbgJP/24A3AIf39vQnzeWaDW+UkEwzXTWv8SvBj1OfJkNNLZK2PCmCa5vepipqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yKZwYJB991Qc+smG3W6IkWDu/pMiFc2g979nc8WC6c=;
 b=z3mkAxC0vHWOlTuhjo8DZoUhrhqyW0RrBt3yV3cVA5vS1ACqm4pJVNuEsLx/O3mHWKbT1Xnz06jD8j8A2jfTF4XKsnFet5vjbkZLt40WU4oWQ1KXc8oRaiRKd4SM+h6vXaz3Y7atZMSLX0mmau1TWikZnuhnR4ye0nUBYX4kb8Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:24 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:24 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 25/25] btrfs: zoned: provide zoned specific reclaim sweep
Date: Wed, 21 Oct 2026 15:41:24 +0200
Message-ID: <20261021134124.2338902-26-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993834:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf6f9f7-409c-4db8-cb61-08df2f79236e
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|22082099003|18002099003|10067099003|5023799004|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 8RGUlAdFILfqWBbx3LjINED1QN3SWEgrh3wEvuHMPa12mIj+W3kfY0dZyoB56i7AgMW/+BZcaS1p9aX3+napv+Z8qL254M/yNF5AQEdFKAf5ez6On9S+sIPVaNZ6+3f1OiVfhPtNjRM+o141tgdny0cXiCuWDKJgKX8nd5scXpfgDYgOW2FqwPfG6ntfGdkhPQjmxpIVq9GXTAJXYNo0RYoxH9cIA57cCKV3zAlHUp6fCBH3NBSo4Mzh2jaQm9dAlkmMw3kv4crrROwxanFPt8BEYx8zAKnxxuYO64szKFb/ggiRXvtLFjXApw8Imt6Fl4LdCF7yieMzqTqeagvA8MqTCiH41+EPOpeBB5TGaoAbjYrd6A/V+SI3rtzSv7sqXh80I+grh2twJ4jIcKh5MH36xgAMEO03WR+thHzbkJVBsGlZ++RRHNBWACXafF5RLYkQBj1zjAZzByPvnbkZnNmoDetTEEFNxS0LZF+wgMcXub6jiCQaPJJCB8mYOfZ4+AVagp7FRtp0ESc82KHgUyjoJTgPjfGc1/ZMqd75sgmDWuEKPi+d4ygBZB5VthsMLuDkLC/hzP47ByECHENSXHw04iWdw66l6ZoaKgzoBIFBGhSj1ijq03XKql5svUN75xLC7pdgUuRI9km2/OHowFsbWOLMltZN2xw751HGtm8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?EYTxXmhKsoB95EC/wXum+x1UphU3xztwb+nW9QN9l90IoUl01mkasKUxz+np?=
 =?us-ascii?Q?WXox8gCRw9ECAPppBpROKeQg8RavwKc/RonsUhfdFXH1FJENz5lkKPpZRe9o?=
 =?us-ascii?Q?NwK+nEz05zbAqeriLooke6H2j7tyWtCFmxcP9ZUTMZWXsicsCS8Si5Cz2v5W?=
 =?us-ascii?Q?dJRbJZzNVgWVpv4lOo/JS5F/h7xZiueU5zij+Ndp6pmu+kJnF3MVAynVgRi7?=
 =?us-ascii?Q?NJMXmxkW+qXDkDyZFi3j97MxKTj1V+q1Zhxd4MvJOjnJtRPhY6SBJ3yUfwqv?=
 =?us-ascii?Q?YOFN5b/plEuPVeqADHZS15J9CbKifEgCetbAnSIWpiKjDPCCP4XxogFP29rv?=
 =?us-ascii?Q?YX/CZe2qAvnZld3r24/n8ZyFFFV0pq5mE+qzsurum19sPV5pNpcgC6cvGIPp?=
 =?us-ascii?Q?NcZi5WjO1/R/PgLAGgJc67LurhpSJBjxXeTAZP4WLBoHhTY1x9mE4sPjWfti?=
 =?us-ascii?Q?WMC+SbjryFLBOnG7byOj1SQZmyMJu6QFsgbf/cyse3cAfcrOg9wj/H/i6FAf?=
 =?us-ascii?Q?gOuMlMmqS/vv/t3oKsQqBss5l2EDZquu9y3BTRaJfIP9m1Xpi2fakCAd/T6a?=
 =?us-ascii?Q?1IdJP7hmKCBENpUEGnajRvOAPveM95sS86MnHp97QoNxLFy7W5TKq4PHIxS2?=
 =?us-ascii?Q?nSt/kXf7w0nN5TRG+a2j+uh9whTTpm3Z8LZAYfA4XERSX/9ZpqgfRU1SZp94?=
 =?us-ascii?Q?4ftI4BtfHwLS8AUDPBP2639gThF5c2+XnGCRuJVwX4yEnphfCEa0OpOYBnHQ?=
 =?us-ascii?Q?xSwhut8J56z8OShamVHkh+GPMP2tlTwzThgD9Jn9/Sy3aMf2WM/PHs/cmi68?=
 =?us-ascii?Q?qLBpWHO9hnGTDTzlcBePvawgyZ7rL5blm7Y00Ru1I66wIdXt+ggdyVBtGgz6?=
 =?us-ascii?Q?jd7vpz7ozFot4HHUIfmDSo1d7pkRsSoi98UQD/N76IGTvT0OE9jLXeyjNLDN?=
 =?us-ascii?Q?zRrKGytIaBYyfm/MCm8n/X7be6yEKdnK0QjYYFaj/7FmzpyhB3prW0qeMsD4?=
 =?us-ascii?Q?ht2KIhE+4c3U059yhshWRHxKpkaJdCer/vI0DF9hjQxoyE3sFHROMoIseBiu?=
 =?us-ascii?Q?MbiKezOxl2jA4wDXZGaQT24lfyLVVczIk84unQd13yWuF3XvBiqRLhIGQ0IJ?=
 =?us-ascii?Q?bpVF9CC+WdDf2U4jAJCPd4fQYnfBSW5UhV00t2N0wIITJbs+VRkTHrbUIguT?=
 =?us-ascii?Q?s835SK2v+htPXMWscm/YfEfWwqd9l8u6URS2OoJLqooi4Bd2qk2lpL+5Sob2?=
 =?us-ascii?Q?v9O1ERvjIubdFJcLKYIreN4lVQgjf2XGFxL7U0elLjt9WFcY2YJKRbKYNRQp?=
 =?us-ascii?Q?xDgIHqbi4mkwV042QrTe2d2GHuXX1xrhpJk1QtycSaiSMHBUh+ReJWav2PdI?=
 =?us-ascii?Q?MXk+ze/ESYyAPgLnNYSJL0WolU6/Tjf1IguLGM4KE/mYuPqDGYVa2iRTLARt?=
 =?us-ascii?Q?OsvDc+OaawkBS2zxks2b/7nCyZDarXFtR5B0E/D7iTGd8mNsbaFp/roQF8p+?=
 =?us-ascii?Q?/hlTrfk4CCrgLXofSGU5NiBm2el1OgMqyrQKySVNzFNfGrR2eY5Au3M9ENZK?=
 =?us-ascii?Q?INO3cngd1vYr1pEL/cEZOlM9d2lNTStjbCYn3LSaXN5kdHoePd8PN6gtGIHY?=
 =?us-ascii?Q?2WgEKVt6LK/2jBdOXNF6C7mvzsWVvbUcUe5z/wb1t/utkIrHAFODzV7rccDS?=
 =?us-ascii?Q?gIJOkB17pSNS36SUB3rw1XIx1hAK4IoZ0+sWM2PqyP3Q2jat+HYH2xlUld+y?=
 =?us-ascii?Q?0cqTsNy2cCjl/1TWn5yV2kZe6NKUWySv7O1Gsth2s2Sg/+WW2r8vzCGgafW0?=
X-MS-Exchange-AntiSpam-MessageData-1: N3KZ151PN1d5C2uh61D7oekLqESnc0nw8+A=
X-Exchange-RoutingPolicyChecked:
	QHy6RkEFdj00Ik1OHXMqwM+szBRokYo+hB7MKRGLpyA2SZtENYzbPi5clnlpfz2ZbGs37spVQ0I9lE6cFRy3RIL71XRV6Tk7fstF/cbZDPiSNRxQ69NNeYhKaIDBcPk/MRlUo0icykrQ7lnWFNqkn0KKn5XwaA1uzJ79WNf2tgypAaXnkdq4pR48LjB2HNRdOwTNbdE5LiZD7vWcmVeZGVB6Cw9aUUqvw4OGHkJmXI3OgmXQ0Lkoy6yODqF+8Rs4IDaqmCj9m9yOhFL/bsHvhhCGSgtLOZZoLVsaWK9AZJvEPpxWghJeoJe5FHVqxAeJIPkz2w80R1qCRzMSQTe5jA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ctsWwK16ylT8c6GcOatlD0Hil9LBXuzUBAbj0R7nWpEA2329Gs8N6PHupdNROfQ0Xde5RenPENcdk1zxZy0kfy0X6+g7OXc3/sZyL4ge3G0hEmKWvZFW4JZw6TRBmmi7barpTgDIYkjOqrbUgAIZD1gRlshnO0WwZ2fDSINTO9k1ZQsjLIWsa9UxbmVPMBTn9E2ddDpR6STildvvyGwqDVOj8QGzttdK+t0Bt0lXAO/kCZDRVEDkeMMG2BQavcI7WLwxwsl0nv3OnPTSbDnMvXUhJrreYoXqvlCNBjlUgcjdcpOseVKkWJzt4W4zVMR5vE/bNf9+D0yAzdefEgKlo5/ttKoOtbK7xPWaln2V4Nsys9iMALD7BCpT7uq+bdJI+g8AB0NUNQKXX31bGtKDezvcpHCx0J0L4VwD+ArVjuw5WuE+ZlPg1cM/Pfyzo4YO0UedqxeWUeIXIxdBh6/q+aRgnAAeFHX2r99WjjJVS1CL73e6izFHImf3F7j7ytgbkEVj9PnoccvISnJqDPX3PzcDQOMgnZUZJy0vZ34XkjW+glpLsJ1hEIdYKJ0zONBnKh1cLKpv7pVuNd6cThOZZ82NUNtG+tu7V1+kIxu6IYXNEFpcGSW5LEKQTDQlOx7F
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf6f9f7-409c-4db8-cb61-08df2f79236e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:24.3435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Li4WNH7C92jJl0c38BT/wsJGAfSXzgjsXL7gaVdGjniyxSHL1VLXBuixWRmfmn/1r1sOjGqMRuXhtwvmAxREKsy5fI+Nu5LqctUHJsk0Zu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

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
 fs/btrfs/zoned.c      | 125 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h      |   3 +
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 77a133ea6d5a..e13b134c66f3 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -917,7 +917,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
 			flush_work(&fs_info->reclaim_bgs_work);
-			btrfs_reclaim_sweep(fs_info);
+			btrfs_zoned_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
 						   BTRFS_ZONED_SYNC_RECLAIM_BATCH);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 205f7ed207eb..191815c62dfd 100644
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
@@ -3652,6 +3653,130 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
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
+			below = bg->used < mult_perc(bg->length, thresh_pct);
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
+	struct btrfs_space_info *sinfos[] = {
+		data_sinfo,
+		data_sinfo->sub_group[0],
+	};
+	struct zoned_gc_candidate *cands;
+	const u64 target = 2 * fs_info->zone_size;
+	u64 total_bytes = 0;
+	u64 garbage = 0;
+	size_t nr = 0;
+	size_t max;
+	int thresh_pct;
+
+	spin_lock(&data_sinfo->lock);
+	thresh_pct = btrfs_calc_reclaim_threshold(data_sinfo);
+	spin_unlock(&data_sinfo->lock);
+	if (!thresh_pct)
+		return;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		total_bytes += READ_ONCE(sinfos[s]->total_bytes);
+
+	max = div64_u64(total_bytes, fs_info->zone_size);
+	cands = kvmalloc_array(max, sizeof(*cands), GFP_NOFS);
+	if (!cands)
+		max = 0;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		garbage += zoned_sweep_space_info(sinfos[s], thresh_pct, cands, &nr, max);
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
index ef5292ec771d..c8197dafa502 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
@@ -336,6 +337,8 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info) { }
+
 static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
 						  u64 flags)
 {
-- 
2.56.0

