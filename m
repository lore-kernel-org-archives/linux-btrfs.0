Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941986;
	b=H1KDB+IbpZdBw+qrbn2mqB+cH9f2U1aiLNq3UdNAdZTc+OXGJE69V/cE9IDHuyTEklSB
	 THIY2L5M0ETQhMkcq3eIFwtthW6d7RRna2mMp+nXzeLhDvHq6x+EEaBcxtBVkqUIQhhCk
	 GAnYun/Dndz8BhwaZ2PzWJ6mxfX8ZkifAhYbdsz/9D4rcGXgpGGgr1WZ1M3fUgpZBejGp
	 WC60GLEZta0z52SOYHlijSNpNGpJdybOcLdarCYQ0ois4dF+DEa2k9ekRZWnMWdrEatpP
	 /V8OS5pl2cPGrbGw/uMT/zEDDZ6HaceK9MmEBj6NiFyNLWXAKtpvc8UlAuIFAE55Yrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941986;
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
	bh=KMFR2fT/l3ZwVEpt6nBNGXswk8kHwgcyjLEVBRAvWaY=;
	b=svXf5666HWubEnnYYGcsLsh7OIAlNhLO8458BJ6XHBmhs9TSpYMnj1BaZ0YMibkU20g/
	 4gRqGRqyk4c6s2iEbKMGpLf5GuzBUtB8rcqcl8ZAvaMioqFc555XWiq4AUUtsNjaBWbmS
	 aBoHmxlDuKCPrzPakcfFCUn8fZ4WTYWY89oNFtuIdTaOlAFXFM0XARqgV9FmE4ZYo3VbD
	 edjQhcc7UV7wIHyv2Ff84rDFQFb3HaFp51vLQDnOM68CHjAvngsO7ptrvy6LuL4lNvwHO
	 MlxhcjSS4++ca3BfIa0wdVsnwCJfGsfgF14KdAm2Ivbdc0eyUYunk+NBPEKkGbyZzXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HXmMqY+n;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CbRtuSfK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6163A606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6163A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HXmMqY+n;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CbRtuSfK
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941994; x=1826477994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=DsNCMINfQqXBYOMEZOXqQ2PQ1egkg9DZCkzwNMYE3uE=;
  b=HXmMqY+ndYyylzV29yA49JrWOlqUkZNLGzzErwcwWBsRozZDDTSA7Iac
   Vp/tWx/NiJhgt31YXb2ZudyatS5+42a7fV7chqQXvt4l5tYy4qDlcFvSX
   bjgMXxyRA5wa1ngT94S/oeuGka8zBGIAE+Gka1uZkQLDv+hImRjA76OxJ
   tCuB7+/J2g3WcMMPN9XfxcSy7MKIfm72utkh+IskQGyNebMUlXZHnxyji
   flBG2jaSKOhMTwSxCjlw1tOfdNGeXLC3sWbY6cvzKQxEJoKkjz/XqWN9I
   XrYTs9kfCTaimZwe6f2xg4egjh/19ImVkkKND8ukx60iv41eSVOwRNTvU
   A==;
X-CSE-ConnectionGUID: ipWihTYtTNicetuppu8ocg==
X-CSE-MsgGUID: m2+gtzZ0SUKqZ9WcoCVO1A==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="160148979"
Received: from mail-eastus2azon11011006.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.6])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PUo7Ciqfx0icFRH13qv+2c2q5iD1uOz1kDajrMpGWAy+oGgvUy6kp4u6sr58uIauGlkZvz3nzKMag8n/vyLvER3GsmvKyVH5p6Co3u1zstzn4pJNzy1UkrLAVYyMqn7E7gQ0AnVNPptS3YLBXIt5JUzcPRFN6r3wiZcZafuZec6j/BBw3RA1K6DjbdSWYrW4wrc6enmb3iruYY0pEhYsJI65wgIuaQxwGWOosxxwNv4h3aqJ0icJJw7kh2h60iN9MN3tTCtN2nnXFgjlwaiQOak+EwsSUem9db7OGCN9mS0tpCxazzriaHiI3vkXZQMaz1yyiiPZ4WW1Bg6RXU5+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMFR2fT/l3ZwVEpt6nBNGXswk8kHwgcyjLEVBRAvWaY=;
 b=K6zykho6juKJjuR6IGF9U0eSory9iitsr1By0dz9M83+yi3gcpioNAUOTi8eZ++Qx/jl6l3baAn/aDU6FIvkdsrZtFnCQh4+buVjapUFAMEo/vqxuzULLOg7dr9kIF2BvjhPuGWuVAYe1JQR6S6A5Ng7KdNLY3QQ5LLLgH/qb/8t/fbjI5spygN+kxNZjFbNyytsUIANtfJe5ysTc4MO/r0Qvbc8PYF1VQlFOn1oxJgbRIkU24txwahgWG3CgN7V5aJR+6iPB2uFS2E1AaAtjogNkdNtA3ulnTMh5gYHtGpe5Js+3O2/bKzjSShag9YDjinE+irwFhzcBFhXEy+Q1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMFR2fT/l3ZwVEpt6nBNGXswk8kHwgcyjLEVBRAvWaY=;
 b=CbRtuSfKPM7J3pLuWvnC1FyAvxHbYzeeBer/lvWH+Ii/izWRINLej9b1S8w46mBqi2pLUJ1gdaKPvwgZXTp0I0jh1QVScUq27V+yLPyzyQjXAztf5An9dQ+Em3bAKZw837Kudt99WaRkgSZ4c4x9m6/in9ac02iA6f/j/cOwMVg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:37 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:37 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 12/27] btrfs: zoned: use plain mutex lock in btrfs_zoned_release_dirty_metadata
Date: Tue, 17 Nov 2026 19:58:35 +0100
Message-ID: <20261117185850.4128157-13-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0cc3f589-63f1-42c8-fbbf-08df44dced32
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	alGcTDngGQGuD+f81Eeg2Vyfm2RtTkteY2npV5ZujTehHwD6I2+X0rFZIrDCk8L10vh4dBE3t9gjpSqbOxEob8rQ7xfjm9dJpZcl2pmfW7uOVAxL76rJf055Ny63Vq21Nbm6jU6yMV3TvCN54aTQpMOGRC2k/YXUcvUmxDvrNAPpcF6Zk8LuvJDs7p10CBc5if9WcQRZJCw1SeifIa6jxypic3aXgq5gF0t/vBTGFcK85l3mIuDlbTvpuzquyDusCwVIjAADyhsiTIEQvrkXMA3SwXTew1alYNBzLoKHWQnJiAhsL0ByR4Bn3kHERD76LH3hZkWf2C+Jkj1uQJYtaF5BjQ58rITmwdzOAaFbPHaq/aiA9d8LEbhVJhd1325amELNY1IpAgaMxST+fjiNeF4h0vUHWti2UEOJK5WIJW9TUg2omQm5eobrHjJqO0A/+7p2e236/diOmjvabk+n/RpWROnIYerbB2EhJ1WzjRS8Fegcaz5pZ88T8/aAN7Op6Y06g2+tSGlSmZojaA/7zum/KNNZV5d39dtC/2t3BwPLQqoop5ONO46E2vWgOle8MlkeDssYnmSE5upGex8GKEgysFRsNv7LANkHL/Vls81QvjSdWC1Q+DA2QVb5fOppPMLdHLzpY7wNi1SRmP4F9F+84equYkwUJujWrdGGQIo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ye1jo3gJab0VexHX920Bak1h0ZgEE2/c4lFeUWmtXgS8rmpPJCNZ+xP/4lS/?=
 =?us-ascii?Q?3omEj7uVg5VyKYjiondawAyNGGUN1S/qeIoYlEFiFMe9FiQfxhC4u9EKxe1o?=
 =?us-ascii?Q?bGp1NiaqUHaPlHmbk9gAzmA0lsAOCdmyzvnFnEeATeH2z4Zj0YB0tWYQD52U?=
 =?us-ascii?Q?i0MkcFzBS477iHlfifK+F1aB2H0RVnZ2OY/hHWmQXkdXXdjbLjGJAlRDGShO?=
 =?us-ascii?Q?IUEU3duQ/HrwlkYMjfo5BiBkpUh9PR1WzO9ifVEaAmAbdghregOqzxcPdVKT?=
 =?us-ascii?Q?vDTziiLBHJu0tk68pe8z8uS6PB7q6pQ2/43n6HAuVK8ngRed0yNZ7UfWblzo?=
 =?us-ascii?Q?oVYMd/TgFw2QjVPqJbIVpXcVQqc3LoN6cnyfUkpJMdicVPis2joJqS8Dws7i?=
 =?us-ascii?Q?vnqfn7kzfb6TXTpSJs9j6Jc/MhoQLF5+chcCJJMXjnP2HuGjf+nM8oEgLxRb?=
 =?us-ascii?Q?7Unzck9ANYUHW419MYuitv+t/Go+Veaql4WDHFQtLbv/fV+U7cGUMVdH1i1Z?=
 =?us-ascii?Q?iz2GguL8BmQfVoBHiyYQuxtyZQlgLx8j3EtrLREj3KMqFHUlLyw/wyrfrxhA?=
 =?us-ascii?Q?qTzgtpAr4tJhMqbZpfGD+MrM9k+EMj5VsUw0ljiBDsi7lcJH3a2Tjxx8SqGQ?=
 =?us-ascii?Q?ikZD+hse78oCTzTgKihtbMMMFy/7NdW/sEeWdwfO+J9h+Zh5b49D0vq8U499?=
 =?us-ascii?Q?O2DSihHoQGp7n+o7HGZ/GuSRVayxw/+2eUQ4hTqE7cmFGIrxfRo92o7Wv4rE?=
 =?us-ascii?Q?5Hukp3kwf01lTCUe3HUT22VuzM2hQYnnJjelPgMg7B4EUR01vt4xwQCU/73j?=
 =?us-ascii?Q?nlfz8DY3BdbjB7zV6ADWppTUjIZyEZ2ByKWMBw0BOO6XVMBTJkWreYGnE+51?=
 =?us-ascii?Q?Nq9EVNWLFvqsWudPvU3Ps8W+5Q44rWLBaRR8J0o8d/x9dMlxdeixJvsNAmUD?=
 =?us-ascii?Q?A79BphGHSzRlaOOLZXljsdAGMlcjTL8ZyK56ipILDWsIO5aa4UuQULKrONFC?=
 =?us-ascii?Q?szLKLqvZaPGCPKYEXB96MqrqRbfZFKj6V6le2CQ0TmZ6G+QLEJ8ijA/3sGaZ?=
 =?us-ascii?Q?tlZBIX/hmszlTKvKktkS7qj0GdTDtp/mjvd9bM9pVJ6cHUE8F/z5ahhIdSG4?=
 =?us-ascii?Q?gGUMJ+81yAxJiGEA6IqRMvh/CBoD964aSqBTIkH+DqCrdm9gCNYwVWSlVlUp?=
 =?us-ascii?Q?s64YcyaZZOUpT9kHV/hEceA3CGYIXFptxCIU7ouB61haNIUGSyTYk36r39A3?=
 =?us-ascii?Q?yPQ8yksVxanpVGL2ToNggrXw152L+Nc30tXJ391TArzSYESP2LbdGsbwCDt2?=
 =?us-ascii?Q?lYXstVCHvlsNT5CgRa+6NNwQBkndd+HAJTXRnSWdUC7nX6cvnYTHK0ynigcQ?=
 =?us-ascii?Q?Y7lhIFgD/OzcRByjQoYe1cI+C7znbUcwK9WClQzLdo/cm9rRE9c1Ku5M7J3n?=
 =?us-ascii?Q?6HYSWulGl8G6f7tM9eP8zgHP+Z9uGB5DBWnqKzwJCJa5iQrPaR7w3hz1OcsR?=
 =?us-ascii?Q?VIQPsvzE2R2eoxD7r9QbiyQCejZJljn/BsflagXW3+IwD5tX2IOLE7dRTXBy?=
 =?us-ascii?Q?fVxr80v09a89HKf6lts1R2xgvnPzNg9CShwd1JvuMRoI0JopEfLzljOODLFC?=
 =?us-ascii?Q?rOxQkz/mCKHDvDF/c2llafeR+zpfzAqUkCeQzM8lwxlCvM427hnxyt6EIiTK?=
 =?us-ascii?Q?7bOudbD8njdvedOVi/E1Lr8irJSCCd4JVhCgoxxKVafPYp9DZ5JXwBi5PIUb?=
 =?us-ascii?Q?l3ea8kg+zlURBGuWqNV/e0Juche9gDQV62oL4jPaDJyxwVqpH4aBYom+gFaS?=
X-MS-Exchange-AntiSpam-MessageData-1: S7yvBva5+8ubSY6FgTu9WasASOWHKljXCY0=
X-Exchange-RoutingPolicyChecked:
	goZAbKXTx5xYRxAO5LeCuJ2H66ALO251S/wRy4vfjA5+8JaT/j0sIAMHTAMOIBWgF4/nYzu13VYl8GlankIu9vCVPwGvVai6JyEwN5n8A/ChW4m0RCNRNgH1Ha5sI26gg1wbRtbEbHRJ/esAuQ6q4MEY/wwCGEia/C5KsF+MQZzQWKlw7XOALuHVJ5j+soKeruGD4AJITrOhDZOf50YMwb1Np0ywwjkcS26B8Pz/j9Wo2auDct7T9Tf+6XVtroR7hZNyJqWs2xH4h1Z7lhQIO5ot47Wyw1Hs5NPO6sbLHobzzQ9jBM5JtUDQ3Ht5rYv39w45hwuTmgG9etajaibPTw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KtZcv6OeAvmPy4jT4lAS4fpBSmwghHrQue3V4uA4w585HmLiKBVaVp4IAm8ypPk2D0pfe9YInRdWI/KPnP02ptxBXxUGg7oTrR6k0YAVLC3iFz0N5F/gKZYK4YtteJd21imQ5E3RId+B2GU4sc8s5vx7qda2ylC94p7C5Ek16ox/qCtPE2wWoKHn4SWD0h4a6H7xLJE/kwA448gIYehJXl+282rGDJgiEyuP/7Fik41hkpuqXG7PdKe/CzMAcEcMcYWxI4yeX/0EC2XYx9ZixOuhttBepqhFpLYECEVttZaN0Cw35wcAx/L/fUOhfTUIXIEaDqbt/lSMjLUzdp3UuhyQShN+XmItz6fLGOtVdqbCQXVITbppqpVxKEPHfF8/eDi0lHBn50Y30Yq9ZORTAc/m7UfjPpO7DFen5724Xvlu9iIym+hYW0EfykdpEvNOdWst6ry5cIrRvrA7xUPDlOTeFYUYHw9YgY80xHF9xjPxLPY/wS3E7hiaW0dlzfpi7kFhCopTFiPJ6+9tYcpL9oeJe4rXIiU2U97It4sjcF4sIvx1/CWcSpxVrsSchWFnnYctqHUfuj2hQltsFUlV2f+lb5zmFIUhKuz7eFZIQgnyopAYniXq42b8Q/SHEer9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc3f589-63f1-42c8-fbbf-08df44dced32
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:37.5737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i83Cd7W6Pk2DWxwUZJOakWfJ0XYIFUN4VjGrt0ixDuC/UwpQR92ZynD40cnBj0ecfRURkmTOk7OiEgXx23FptJ0qfrNLRwYNfl95nAGNma8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

btrfs_zoned_release_dirty_metadata() already bails out if it is not
called on a zoned filesystem, so there is no need in using the wrapper
for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b58482e62aa..0b04b6aebac6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4223,7 +4223,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	btrfs_zoned_meta_io_lock(fs_info);
+	mutex_lock(&fs_info->zoned_meta_io_lock);
 	eb_batch_init(&batch);
 	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
 				       PAGECACHE_TAG_DIRTY, &batch)) {
@@ -4239,7 +4239,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 		eb_batch_release(&batch);
 		cond_resched();
 	}
-	btrfs_zoned_meta_io_unlock(fs_info);
+	mutex_unlock(&fs_info->zoned_meta_io_lock);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
-- 
2.56.1

