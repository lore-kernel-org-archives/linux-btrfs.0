Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085782;
	b=oWPEizrG0nzLOhsA7sZJZWUR4BfVmzBXyoK0t4MquH7m1RV0SHOfKAhTHH6E7RIK7tlE
	 wCP5UtizjM9bNspADJeog33oEvCZnpnY9EHWxJoZb3xphL7NroCRKfZvhXn9Ne0Ma87Z3
	 H9Mu7/lZkHBAWX3BGu/DF9RC84gbnSC5S49SAt1ZYPVJ8ZYHI5QsmKsGDl92PBbfpCepZ
	 vYnhi8S0hytPw84Squnt/zkPKwZrzh2BdplO7vwYLPyo4y8wyRZ/X6Y8MQyecrDZ1ELiP
	 up6ikshyB4VY4R+4b14Q2CZu8f1DCZo8UY6oPvvNHr0tSR3fX2j5YQSCloUh3VB3zRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085782;
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
	bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
	b=Kwsk+VAm0L8G9kZ4L/bAYrlxX9wCghHwQgvX2Kt+obWWdHG830FLU5UxV2nC0vK/s2CS
	 v0WmcPvjiEtsb5w/4HoYxyjMwo0xlqefsxwgfnsX0EbZ3wrylnpp8lb8GjHx3okp9dFoy
	 /soDxJmLorOPL7Ci+0AG+elrRpzrufoR2tszxfohWKN+DVI74hQWF8f1Wl1vcIhJf5TJg
	 GXvHpQgXRDbg/5fa5F23LlDDEuuwd83Gaj/IAuMAaHw4AVAoU7DAWzDtHGNIMD10vQDCn
	 BSk4QyGM/JPAe0WAyIxzUp6j3S83OyixM9Zm4iELJbeokMw5nrSF8sD1swYuboFcwTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nbiRtKFz;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=0QRtZias;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5E9606A332
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B5E9606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nbiRtKFz;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=0QRtZias
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085782; x=1824621782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3F4P4/q6IS5daclCQNXs6rcgHM2VTM9cAuRMwXON0Y0=;
  b=nbiRtKFzBkpvW3119LyzZYj0ThA3ezJ1wQF1lFuqd/z8pY9kArv6rggR
   e36dNI/dQRWACeT1ay3KqaLa9yCml2K6zVNkcp9nqxXY05+A3pQmi408E
   KIafVxb2mXGJqMUPYpJWFgzWwcF5X8BY/AwvXbruiiapmqrLb8a9PKDrA
   G5FpU5ggqyQ5/XzKyKleOFbJe41HOdNZ6sqJbxbln/KX+t6nYs42oTZZY
   0oSbRyMLP2vSYAIpyqACU/2GPr5pJTk+7vV7zZvZJCKwZqo/JKKnlPyWL
   7c9017OZYACahkQ3R4A5pT7dN2W3Ug4DcmfbN3XNNqV9+ViQQzWmnHZ7h
   A==;
X-CSE-ConnectionGUID: QdpQp28KTNy9iGmK7IF2Iw==
X-CSE-MsgGUID: /0mJvQYrTVyKAi9+9ZY47A==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863264"
Received: from mail-westus3azon11011065.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eoTU5AQruDuIb97/IwMyHPQdTviGlzLE0uCJyo4ig4JwAL8PUYLTdUJFhToSkcNlGGhtJmeOAUazaOTadDjbsk8KsdQGXb0mjrvaenAkHfsN08KAXNEhh8mwuofEXYhdRC4Bw0uN2wq+5MfciKRj5nBV6XgQn5ij1WX54NF/oi+67iu2TQKe1cn22tOAD0BQBo2zYHi3Yu6sh1AKxFelSZGvEBs9ok0yphTtr4mji0m+67gplB5I5AspUCWORu2hF7vBCgtxw5kFAJfbsnVSvPl9JXiMMckanV4L4b6gVGTs/ZknWupZLc2JyJwY/5X1LA4Vn1HlCT/QzmQ/Pceqwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
 b=qtiyKxZinZuyFH+jgDFX2drrTPjEPCMNyghdTHpCq26HqUxKirW1jw3yCxZ2aEERQ0afdWh8SigbN8YHwHrhOd/Sp4eyeqxgsCaLRFth0EO6mPfdLhaMuHfpY1nQsQJaiLhgymWxNBIAPTOTfNXIcSOISOoH2T7GayTCqouPofurY48HGjwzTu34P2hptt/yIZ+VJvsPhpVfHtou2Qd+ygkaFzejw+Oo4x/fJFqIxlijbkGfC2qi0WO75IAR4hh05AruZt+iHawlI7mMLnmAY+xglY4xcDkGxpLLZIkmvnKmMunfVoTVR6WhKNb3RpwyB9cJ/tR8WsV7WpYmY2jOVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaPBnd/QNCK8c7VR55bEH2lkFdoNR/C/R/1gsRzlF8A=;
 b=0QRtZias6tnt29O9Ok0f8I5xQ7TZyhLUB6bX0uTOREUGvYprejn7udGW1KC7z8UCKI5Q2YxJhcogLNqknCRu2ZJPovvovK/xeyRWK0E3OLYacDXHfxmdKLol6/Fqd+jWG061GdwcU+yOzuFRtqNKyxtVFhsZujkV5BQnxfo5X7k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:00 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:00 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 12/25] btrfs: zoned: prefer sequential zones for data chunks
Date: Tue, 27 Oct 2026 08:22:18 +0100
Message-ID: <20261027072232.419318-13-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: e21620b3-c2d6-40e5-c02f-08df33fb21a8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|6133799003|22082099003|18002099003|261026121527099003|5023799004|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	H2lQ16UWt0qAD93FaiCmyOejJF2YqiHq1y9qTy0W/vIciyQb8Ai11fajqqe/Y6Rjjy+hnxJHVDK5qw97J5wwK7Om5W8w81ectsK8/vwhgqPDYeYNzgNsiGABH82SwU+T8pMB6JS0Aojmmwc2CnUiWp00HnCMbGIExWVzhOR1pHTOtKvBdAfBCy7tKVLZcxwoDVShkChFx20uK8L2bjMiWx7vKtqkLizOeXaVTKLPWuLUW+hcD5Xe/ImW35wLGKJCG15vdU7OitXe8b6R4OwRbg6SX4dzJNJFMhkGNqbqnJNDn6O1TMusyvTb9auke3OfEIHJCbqWASuwNkVga7nj9+qq5WqSfdmJ3Yd1qS5blCU7inu0V8+cJtq/F1HVbxGkJWRMA/vnPZCttRw2/eWjOL23K+ULFK47e6S1+tiKeEKTgJ4c0LaFfEDPQpx+K3dXsMmExkMYZSjFHgucC3ze030N9J+s0tK8ciBhjxPyWdr0lFF6/jRKURlJkWms6aaaeuE8tAhdWemjI+ZvwA2yZpEkVmT2sMkY61/cqDbnDKtSIIYu4RZPq340bKxQ1WO5VI8hwvhx4X4S0kwLMwthH9ij3f/J5ron+Ci3YSYjqJ2D7sZuk5+JmERZCUgghVvOYz9VcGBKUiXFUsku4YwJX/vdqSY7yn26o6gSM4UCLUw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(22082099003)(18002099003)(261026121527099003)(5023799004)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5sOXC/0mGbmcjjNH1ryD6veMSw1yJU5S5sbnb8EkugnqwfqOb49myrgZbn9w?=
 =?us-ascii?Q?/vOjQqC7e6/zZhXgeXV5OArtvZUYONCbLOrpNPEXDLEJjj4/x6MizbTsP6Q3?=
 =?us-ascii?Q?v0fC1VbtkkoNB8JtAjTS8QW16pMwx8mF1J1JvNHN7cD/expGTyv/RvtfMXpZ?=
 =?us-ascii?Q?WzYr1EQ7vOgPfTx+T9gDnDQHfasFF1gV6u7fB3HoNzsL708WZl9ZbK2579Wl?=
 =?us-ascii?Q?8fqZAmVeDreIfIOgG4HEZizgl++K1iHdlvO9ehbwnoROoo9vq4lJfZLDwqHV?=
 =?us-ascii?Q?jTYIKshsAv391sK6o5cdXcf6UPUaAScTEADtFJ+1JtBgtHvieSQ/kOrkWn0i?=
 =?us-ascii?Q?9iJgwQdc9zaKZf06qGAGlbo3ChXG7SAc3HGgY93ZsLTW3IYQJBJfDnz884gD?=
 =?us-ascii?Q?nqx6Dk1xpz1oPkBolh3PWlAWqZURWADzkqhTjV8JvZ8C7FNZxuzcB3ZnoqmR?=
 =?us-ascii?Q?V7TG6tclUimoG99jHn+ynD1mQ9/7XMcQEI+eonc5uO1xgZ2wqeiC6hOgCLa4?=
 =?us-ascii?Q?X/jKJPBWozMjK77VRmfmi4cLaoyTm2u3jMXqJEPcQSDRGClRcVMUIOJvYwfz?=
 =?us-ascii?Q?u8qeW6fdM/oBGsCfHDOeURWVExBt5CQPK4Dz29dvfJ03VBZ5Oz2WAyoZ4bSM?=
 =?us-ascii?Q?iW6KV/WD7P9NATwrWV+p8reQudm43bwgOy05n08zvza0CXvkcX/4LiXazzYl?=
 =?us-ascii?Q?7LCkPPwGqKpOvTS9Mp0I+4IwyiE6JkL6Dt++lYv86wvelZTNWRrwHTc+CPBg?=
 =?us-ascii?Q?E9lsc3VaD4x7ZWsz43qrzVpbFD1SZmqCv9Ol3p+isc+gzuAdSWfKeprxGWfz?=
 =?us-ascii?Q?3+AuQUeZO9G7VIDMgStYNfPzf0bPD+qKVQYaGHS16EihlWSMjYjhUcRISDsy?=
 =?us-ascii?Q?wXIndEOWKbzLd14D/kYXy1n2RgMU92OeZ50+jCU4jZpzwegGmWL+0NNJJwB5?=
 =?us-ascii?Q?JLN+3xfBOpMj1UTjYo+/WcdkSq+TgFLh6KViT0/qTjA8jv1QNt9/SfuPwQZN?=
 =?us-ascii?Q?MgpOwgoji0xV1//GIO1gf6WkAX5XHuEwimwTdtO+7BLzMs6zMiue4wX3jEb2?=
 =?us-ascii?Q?jeIaujfP/zcWl0BFA7KI8s6E6U4JPg5Y6F4ImC0PJ7O4cXYVnkpTXi9FrOgb?=
 =?us-ascii?Q?vIU37yYmElXltobk2877utChU8ZEP9IIgUU6WqxwEUJOWPIlbmaOdPE+dKwN?=
 =?us-ascii?Q?7+8e7QsNcrtWodlv6u34rlJsjIQMNpSFuPOkZBEuBDHj+gYn2r1uFNxTM7gJ?=
 =?us-ascii?Q?0w4nIs9V5RQEB7vOv11PdvvfScQwHuTEg7hmvQv1LtIz4C2w3ihz9rb0vOVM?=
 =?us-ascii?Q?G+EhoLGrS3OMtMhlIvznUivubmB/qOnx5LJRAlFUfsqblUkS62rRB/1W0LJT?=
 =?us-ascii?Q?8xT+mRzJj44mnrTtrZwkyobE8iVjuuz/H2kTZFxgi0aGH4VuNRwt7zdtVWml?=
 =?us-ascii?Q?BUUFkVVXYcBZ5HWTECTQhUlC9OtCc61C6xYxBSzLYJR+c5suFDkdN/z9BI0o?=
 =?us-ascii?Q?b/Hxi3fYO0lr07mcx1ScrAGKKp7Fz8Hm5O9gp1tZst3IuTRxBH8Imx3ThRO6?=
 =?us-ascii?Q?GV9zSBE60nC8VvNHxvIxk79zTF4qCE49HMz3zCunugZ7R+u1KRC0ISAHnuaO?=
 =?us-ascii?Q?/7C0sZsXfckJroWRJzIUsgWuoa8L6Bihb1VJetTVAbvYLLpekBBZKmUDspfJ?=
 =?us-ascii?Q?1ivvMZF7pUXf3E+nOl9e+NyUC0tuYZw51boB5PCTf6ZcAqx936vu6pZUWqkT?=
 =?us-ascii?Q?Rd2Zr6Yjcn5Ezh9ODmB5fuJ3/F0LNhKyBAwu3iTsA0qKMYOH/ViXF2Tlt3nx?=
X-MS-Exchange-AntiSpam-MessageData-1: LW3s+86p+hmpgoei0FYr1ZYQGVWoC/RaDKg=
X-Exchange-RoutingPolicyChecked:
	tjV/UtsHWKQktmSPVlT4ZqYXP3tn4CrwvQnAN65LdnXFa5QlT+cOU2lvX0P+o3RW78IDw0lppWdUA6Qr/nVO80bClk5KGi6treA06xRC/YVZd/om7gYa2+Vb7r+D2y28yGDMUqpK7SeHzBG2qdsxd5Moc2ccOdLf6wyAQHczePQlwuxGKxK1eiBMYEPfHwcwmIqaSDBTBByIal3rkS0Mm+tUnQHIGeEB9mie89u1xBHS0AjcNyA6osdt0cCr8b7HldbNuQH6lS2SuBpOw59LwoSlrpgcXO67iIJvlrfT72vJoVPGV+qSjSjKmzPf8B/qF8ow84uh3cfeVR6tLQQJgA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G38Bgux84GiZg08I0uYLpZtoGmRz9UsmZlrT1xkU3wDRuTmyhTtG8A8uqUbWHlxtBAFnz0KK2ft7O7Thcy+md6KV3t20NoMiqAC0bHMCO3OAkF4kK/EQ9Q1+Y5jQ4xJvbJmvDcONzvQ/B/cLLGGn5GIEMNjt13+Z5hVBs7ANCuduxwjeSBX2ht8IC7cmMJz9G5P4lFLeuw+0d0u6hM0PJOfi6lPidDtZRq5PCWfjlsaQYCS2c7qFnCwyeJFkoSWCTmapi7jm8aBgH6zSBimpSuMYtCGqnhAyfaaWIRris4s6NtdkEz60THN9KdzrO8f5Sev0tURW+8jWsbcgsNPgnFCJqAjG+a/yJ2wd8+Nm2Nk44VlzPWf78e+CaAnF+q6WwQTeKlTHQEY0W3xvdpXk9qva+RL60yieWl3SiyTbElrTrqY+PzVZMsNKo016JPXc44dzF7BeBAd5AgVSKfIkkS0yynr8uKpJpKhJ+iYwCGo3VAGQNLJvcXlqNaphRArRiKiQnl9dEouFuHvF4WuZOFgIsm/a3H5bwOMZejjFdNsIlO1IpPVL7yaf1fpzCfIRuxtKZ2iNodeMC2qvy2MI9AplcVRezimV592sUyLtrtImtICX4luRQRQ2mXrFOGE/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21620b3-c2d6-40e5-c02f-08df33fb21a8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:00.5129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMqYZwqbU9K04TkA319oyioWwjr0gLdDj6A7ftd0rOyXzc7j+HSjVgPjn3BkeuCztqdlTwnIUeaVck4GklaB6wconkZjSaFl8ou3HJ5yOeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

Data on a zoned filesystem is always allocated append only, even when it
is placed on conventional zones, and its volume dwarfs the conventional
area a device typically exposes. So there is nothing to gain from placing
a data chunk on a conventional zone. Doing so does hurt though: it
consumes the conventional zones that metadata wants, and metadata is the
only consumer that actually benefits from being able to overwrite in
place.

Mirror the metadata side and search the sequential zones for a data
chunk first, falling back to all zones if that does not yield enough
devices for the requested allocation profile. Devices without
sequential zones, e.g. regular devices with emulated zones, skip the
restricted search and keep working as before.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 76bd54af8720..09449381fe2e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5897,6 +5897,15 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+/*
+ * Metadata and system chunks are preferably placed on conventional zones.
+ * Those can be overwritten in place, so such block groups do not need the
+ * append only allocation and writeback paths.
+ *
+ * Data is always allocated append only, even on conventional zones, and dwarfs
+ * the typically small conventional area of a device. So keep it on sequential
+ * zones and leave the conventional zones to metadata.
+ */
 static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
 						const struct alloc_chunk_ctl *ctl)
 {
@@ -5907,9 +5916,9 @@ static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *f
 		return BTRFS_ZONE_FILTER_NONE;
 
 	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
-		return BTRFS_ZONE_FILTER_NONE;
-
-	filter = BTRFS_ZONE_FILTER_CONV;
+		filter = BTRFS_ZONE_FILTER_SEQ;
+	else
+		filter = BTRFS_ZONE_FILTER_CONV;
 
 	/* Avoid a pointless first pass if no device has such zones at all. */
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-- 
2.56.0

