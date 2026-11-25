Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602641;
	b=l9DNDIfmRPogCGsds/4NfDKWGU0HtuXBiuol1hcwO/OZzPMZAyboi86o6LNgCMS7T/pA
	 kKyZTmVdoOF9wpEvnTwfp48SfHYJN8jJf6rkXxN0BQIutNWrFuGw+TrUtGV7Dg3mQwH0D
	 FFRsOYHocKLAGbjFhlYHWbCPDn54lt6wbeAHcZIq0LzUIxKOcHlG3rPggBOPkGrbsQ/ey
	 lsp9bjx8YaW6kBuqSq3sx6iYOx2l3rwBccrG4BAfzjw0B25ESLSPxgLcoI6CUzDowSHsB
	 inoeTycsJtEa8+rWjUST0w8gdEoCat6HX9r+Y10BbaWJMvf61RWKV2FmDCPLfT8y/cg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602641;
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
	bh=jZDrdMvG2pZqR/1WE/1gJMeEgIJdtR+eo7qXtf11e/s=;
	b=YvM25gTac8IHwyiCClmtZG1bs2wYDJ2SZUzvJcUbKrV3MetTVnABKc80UlKpiIZGBdUV
	 YvtVkFBidM8+5q4Bn66C1Laea0mLibSsZ/5gVwnhiFQfZozRd5MOOxl8e90hvPWaXMFy4
	 SXJKwwTe1SA8jjFwOAmj4Y60zV1YiF/4GhHhVF5B74Kk65CCOLibO/cvR5hbbpK/kIhmZ
	 WCNQLWg6iSlsXtYWlEoq35FOmBkZohj4XozvY2T8PHfOjO2XEtv7HdgLo815QSjPEIths
	 3i2JNkKT7gRK+YTa1K0oEvjsgHGSqu4pjNMq7nOOl2Xy3Za9f8YMHDSaCY9IsPpbP3A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bgQHRbI6;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=WFTIC5H8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2205F606A32D
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2205F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bgQHRbI6;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=WFTIC5H8
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602640; x=1827138640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=mcm8topDONaHP0jS5S78Rnqf4UB4eaMZ+U8jD3YRdBo=;
  b=bgQHRbI69itt/Bqmd7JA5mmGvaYyFcmUOogT7+iMErUlHiGjUIu5BDfE
   SBYU0+NXZiN5WdS6aPNW9vqSaechLEMUeLqDiwlX3eZJj4sPgPOTmrsHG
   XgJYLraOzbNQB2E722zYKFwWxVxGiCWC2LBsEYBXWpwVuy4Iisojnn7np
   n7MXxVQlPq3hUmSMXMQCa9NwtX5nulE/38UZtKONMnrF2P7pqtzQ6YzRI
   RLGtmOcpacV1PXO0sRXSRNzYbQgM6BGGiwguPgHk5slHm8kv6oU5L34wA
   HDIrTEhr8KG6GWzPR9SBjxYcNDPGFnKUeslTwfnTrpjBQHVRHXG3gZman
   Q==;
X-CSE-ConnectionGUID: ozWkmDqASB2N1X+CnJM/3w==
X-CSE-MsgGUID: 0IiOmRylST+La1zi/pfi9g==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662172"
Received: from mail-westus2azon11012042.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EL/QP7Qq5EgnXx2dkb5heNzjhhMSUbGL8y/bOhWbhZ47O6lJdyDwv692b37CKcOYLltXjnmOwhWih56bZPNDLK5XDRXLf0mTTom6+qndafufxKp9Wg9KsSy7kxas1zX3D39oqzp/+tSOsL+9XnnHJxPac++eBaggmiCA7SGwbNFB4gKJy9ZAldQV77ay7D9NfMda9DF7OVLr8t9ohznhaCNAayeQbFmrGMntw17L81FJMvxPfMsz8h0XLeGZZtr1vVrqJuYNv93AvJrmGYyhj6Yiy+4uF2aU2CpE2CD0IGXdzbq0x0kgscdCa38bWb8EHjwXf3iiXbLXyTcq2THSDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZDrdMvG2pZqR/1WE/1gJMeEgIJdtR+eo7qXtf11e/s=;
 b=psZxYhNoaTPOGewZxnFGnWYQe/mWIVWS2Ty7F9FZAFZO9Ta8djZNWB//b04JcjHapATLnL0Bfe+GZXL/f4d7whnff7e7nPsRFhUVSJSpTE+NhL9shZ84yGUzXMYMma8JTskT20uQVhhHHTPcahm8WrbVSAcVHgYY1mRSMOaqD+ih6sH4Kl4iOf1m/B1JLSLqBklmbXOjqvZfV8N7TcD6LWVORv/F55MJJWaXGFj9LbXYje1J00MTCBeZs7nLzqlwCMNPSAuD3uE4GOxWJ/n9afY8s0pf13z9vxMSltDRBlY0Qu8+YJiFqnmKyiXa1nMog4iKgpGLRuufQinM9/5MVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZDrdMvG2pZqR/1WE/1gJMeEgIJdtR+eo7qXtf11e/s=;
 b=WFTIC5H8jeZFCA6zR+If/+li0Xkt/xF//sTkDLV+USWTbpGEwj1lZWrbpPMg7yRSnnF6LRDR3IQH9ISID4NuMRy14FtZHcZCzr9cl2PJo9jw8dRnmYbBAwSu/84LqxpSOALIg096vBE4USaKQTF3Urp3Ybn/X34/KKYq/X3xKZo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:38 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:38 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 11/27] btrfs: zoned: use plain mutex lock in check_bg_is_active
Date: Wed, 25 Nov 2026 11:29:40 +0100
Message-ID: <20261125102956.266389-12-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: c362a193-5aea-4438-cf0c-08df4adf2607
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jMTv3pQfu9XI33gjwO+iyb/0K5leb7avamprXPNwaj2qk3F5WV59sToaqAIOf2oeLLc1KqbK1jjpi5POHNzaakGY6ThY1NOUoOkZPsH951bgH1YZIWEPj+vAE8k16TeHrCX0cc5hatiTIlkNzLRpJJQ3j0FA4fIDtEU0krWex1L41J+7jHjKTPFvXJJZB+zyW0YCNDao00ldicvUR4GOb9jsk8g4ooCkb3+lLvxOVL14ZLWJ+xCKy0nsEpuP53xv0wJPcoffKQDhXOW0osyhQ/FlOsFNgvyjtVvVaG2yBWdSnGJlvY4K10NrYL/mvge1+DI1aq73cCJhJ2FaLsftc9NHrE15EBugLDv7OBQe4mGgRtZ5FARbWaSWy7WAfiGrNK6Sfvwnhtaxz81pEAZFxX80iQmtdSkN1DzRzxeSfHQKNbhiaaB68LNvW8skG3sc8lg383gSP8i7Ps7yj6SU7bYCpEvH96EbTZdZ3o2nkXvqnifpIVjox4CMmnD8ppi5yXI2+BOdmCHOMaLE5EI82/1eQQJSYc8ey6mtjSEvaTcJ5euw66gYpyqvhimeN3EaFW53hSnXDJEa96TCpZohOtWw/uaNOD3jGiPGPgOoiNUvbnw+QVMjmmLMNHXtFnHSbQv95QdX3qISIEdXxveujzpW6AEUwNO2NmlvAYL09xQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MSgaULGM4asYtO6uGbyjQIbw1dikXZ2e3jZEz3b63n/EP8f+/deazmVFNwJw?=
 =?us-ascii?Q?YlkkyPj/ak6LXfvAF0T5GDdxK7WelazC73ChHvmnwOSmaJXddkObfLPqawC+?=
 =?us-ascii?Q?TRa6cC9Gd/34OmdPGcWcRUKJAwtGO/ahH6NZebvEkQFPr6UiDApVj+6d0MN8?=
 =?us-ascii?Q?jD6O7qXh3CJZAMlx0ZBFHIvqExGI48mrIXCbyKeY1HGtFZ8fX7M3EImV1wUY?=
 =?us-ascii?Q?vY9r+KfBUll2pmHUShtQqVLe8N9CTz9wx42J7HXKBbyMttBnVVQFMkQ3dVsl?=
 =?us-ascii?Q?xXuE6/GPUQjiW2hYDRsEda3rNoktlxQoTfkM5ifsTMUrrIe7TJJPLPlh7DNn?=
 =?us-ascii?Q?86MHxLMgMQL4U7+7KMt5ruQcBchSLQ9V9PofX7jevLDWHvkJGNVisCMFNKUo?=
 =?us-ascii?Q?GWIACRLk5wz7ns7/YtBxP740HjbhE19HDN6/uPtT4jiRIS804Tmfad8nHM+g?=
 =?us-ascii?Q?U7hLSjVYzOwVppMUF1yO/GWH2kJHLhv2LLRN18E6ka0cPEjmcx+H71rQfE2J?=
 =?us-ascii?Q?NW/deXhzhfCjFS16wbEakst8XSXW6r9B/xIskmLcjPtEKuncH25WcmC0dOJo?=
 =?us-ascii?Q?dIQGwbi5Fjw0HWMhi3K0tIJy87fzOeGbePOHF5EAz8ccrcEtGY5GTDrHhmaB?=
 =?us-ascii?Q?dZwZZKDFAtd3KuHragYhpf9qUwd8i5IX5LtF/DyDK2kjdjSGl3bpKKy2ge7u?=
 =?us-ascii?Q?sIawBPm9baFuSiuJN0O0J1ICi5y9poOgX8/+wMV7NOzG2oRKicb5Cq1ub6xz?=
 =?us-ascii?Q?ZEMd5kg/H3mvLdush4B8t5UCHNajOhyA3NThyTFILDNUL8UP6sgh8zcG66r4?=
 =?us-ascii?Q?UNCgBGF+0BpGdU6YZfVLKkLBh7UXjsSVGO3FgmtVKQ5cqVRhZPVFz8DU9wWt?=
 =?us-ascii?Q?iRD+qWzYSH8nRE5nZ9a2JZoVahPTFsjUvHtmBB8f6A4r0J/ZkCaHWGeGn3LA?=
 =?us-ascii?Q?2ShIL6nRQlqr11yeHIaTZOxbRy8XK4A0mEAWZfI4Lxj3FAvTODQCnxuFfQGe?=
 =?us-ascii?Q?ae6VmQpVAox8Jvz9ZiUn5tjMWgRUokoboKdUD6JqWEMkc5ZfkqiJGjJ3Vpvw?=
 =?us-ascii?Q?f5Jsma7/4DLlTW23FusDEpetj92roxnqHpVJsNRJs/6yYsqYHNk3TdLVCUFb?=
 =?us-ascii?Q?yMqYIzSUJ2YTglLR/NT6LLqIwY15zxKVsy2lVXYA1Pe04X/LSXs1Gl7Igcf3?=
 =?us-ascii?Q?1RA4EBbia5VluMQ1yVWrqTKKu44r+m9w6bU11sdz7DGpU5Pye4wtWwuI8xUs?=
 =?us-ascii?Q?hxwIdYTX/vlCUZ3VZKpm5e4rabUdFQZPLKELlKC4q1TS5Y+VxxKns0Usp/Dd?=
 =?us-ascii?Q?EsL6sDrvRaUfDLsRoyyIjDprlVC+Tv8sgK6AK78Nq1wZ4Dkgm85TNBY2XEBT?=
 =?us-ascii?Q?ElZSAh8q+zyIQikqFRf3y+sUcBTPqMpaHjhKo2pY3mUZlR6xpwTNopBGnufg?=
 =?us-ascii?Q?Hp+mLxcWQaqdy2AVlOdhBzbAFQuRhiZf3ImODx8CwCqz3KHY0iBv46W10w4T?=
 =?us-ascii?Q?P744ng+9dFcYinDI8gbB18HW2LPlJTPKjJgKMbStfB51H+vihDHRtA1M0v2j?=
 =?us-ascii?Q?TDh0oeWZ4bVWXKemgVE/E8qchEbSobYeynxbdc5CjRjnqf+CJ5I9AyguP1q/?=
 =?us-ascii?Q?GQNX8OYRQu2aJFTg5tmYyu+RNHriv5rnHpjWK910UAxdwDkXFSwh1JvewJif?=
 =?us-ascii?Q?7KaXVA+s/SbUzov51OzitTbeaZ4S/U6COqKgVIM5+184XTUCTrzKqPtQR3nK?=
 =?us-ascii?Q?wg8FmE8d0evdJr3O3lUZfRV08M/FCwiUzbqbZwP0W3qd2svio772YcQD4Ez4?=
X-MS-Exchange-AntiSpam-MessageData-1: qX1pL9cfPVoEmU0drMjjzCj9fj1/RyrYIYs=
X-Exchange-RoutingPolicyChecked:
	QzIoaT6uh2Jny81mW+2zq0+/Ob03TPD4nPEu8tbuXPzlOlAu1AgdV3f9Biah3tCFQ1ykS6Gm7uJQIzuyWyyxS3rSk+02pnJT9W6Smow6odDIe38tFsBN9lH9434Uh5mczQMEsI3z5ipoSiWsQJH8AAOGsAI5ip1URp6Ik4ghf/Oih3qpzL3JdhfptlIz5orPBE4SUATq5xNGC9zNQGYdb3EbyIQvNf7euijgE9mkJ7xht/cVXsTbc1RSw4Qj0x+QmeeKulTza/xc0IaKa6XMOlM/mEHbWU3OoyxH7Lixtdg48TNZ1qGRWg5lW0WHefbqvbHHxMdx+8p015fhZsGTOQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KSzLpWgpiPs2QGrvTyC6wI6KyfdjHxH3ERK0Y/2rjZHDHA3VE9cQzcKR0lBHNIwHcGWrjB1J8QiKGs/XmBP/AP3sxk05c1PBTw/W8eNY+jtWAYlIimVZ0giaxxX2mu++jKmxHOe9qI16GZcu5XGl04+FmeRe1wkEBAMx3CKeIuNsIhMrtX4oZmPvfuIDYMZG9xTu+mI+jiW1L7o1PmzOmfmE+d44ndXphJ3wrZMvB6u4S2HwuW0+yAN3ezzujRCvljeHuoQdG28Eys/tEKxhxTnthyqP+TsnGps0H8j+L0m9u2KvHoRHfJ0gC765xjdYUPkc+vw+h3Oe6pouawAB+YQFZffNFE1ToCsNQzcMtE9SP/1htUl/Zu9K3DdF7+yTf0TnRxvclv7LI+Y5utvnjoLwfEjhwOnULTNGEqhuC9BTewqrgeGjiScGrLTs3Tgnnh6dPleqePNniZ0YnBWF2CHmJP9EhKSm3TqEtZbHH3/z1whdTyW5zTSK8fHcN2k7DakuQVFIje2+KUj1P2r9cOBv6szCDx0NH1JNgrqIPhG4sNvxZJKapOZe0tig2N68gEosFQEO1rJitCLCTJxTtJQjfsIbDBiZV2ZDxVeXlKF2pZd/WWtI3tn93HVyGBGd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c362a193-5aea-4438-cf0c-08df4adf2607
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:38.7953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pcfzi5j9vFrge9VbDcOUmJRDxwXd/uCrNMX9+6OAM0H10c+1NntIKK8gd3y+gZjYmPPG+f2DX65Rf8JInIAh5TryiMJQQo74IXBJ+roUdGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

check_bg_is_active() is only called for zoned filesystems, so there is
no need in using the wrapper for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 09e8346dc418..bd3e9203a650 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2249,9 +2249,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
 
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			ret_fin = btrfs_zone_finish_one_bg(fs_info);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
@@ -2274,10 +2274,10 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 			}
 
 			/* Pivot active metadata/system block group. */
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			wait_eb_writebacks(tgt);
 			do_zone_finish(tgt, true);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 			if (*active_bg == tgt) {
 				btrfs_put_block_group(tgt);
 				*active_bg = NULL;
-- 
2.56.1

