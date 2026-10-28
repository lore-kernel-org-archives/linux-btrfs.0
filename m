Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211709;
	b=vUvtNN5w/8pTFy9AfiP1lEo3wiXBmPljVeIJ9MIVaaoJwhYA0v61McnGe7UFaxemaICS
	 UZ5PQBTW5fg9KICX50/YOp5QFl9ovzg+lLnnqe24ThB+Sv2N1TJSWh7FpKOWFoBaPKMdY
	 dv/wwNjzsZxp6cBSD+MO3ysUqm2V/uh5zd3WI1zgOj3nTyolLGkBtcZ3np4ls/ts94Icc
	 9yNDqHvPRm5+DpOjX9NzSPBAkbjps1qW/nwIAjF1boil2wWWwnUKNqWBIrNPAYXhKq0u4
	 xvg+elLBusVr+2N/UJ8MuZh09Vxr3u+Zya8B7SuoWdXQZXLO4QqGDdJbYp0BuKapm4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211709;
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
	bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
	b=5K9qb34YSWWmUD034vytHZgm1uyUGhWP3SDaZf31xjTWcXT/ppngQqNC+yfSUmpQTh/k
	 dWaB3jJbmVQ4YYFLl+I7AnlKoT4NosYYU99KndQUWVfVy4myenCBfojy+/TSCjD1tkRWs
	 LpBEAnL5ICcYKWz9q/o0/AR+7bcvQ+Y7HU7RLPL236fMuDeLxRj3paFvuo2XE13W0kYC8
	 yIwZHQZoAnMMGXm9QPJHJi6eqxP8ooidfSBzFyrG7yH72uf0+/2yFAW/aE5wWiAIzH/fc
	 +e1q7t01HHUwqonYF9mhij5Rd8GLhMp70rW0JbydB0BjRklhiMISPb7x5ZoqjygYHKw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=US3bKVYF;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ppO4sa6k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8209660A2636
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8209660A2636
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=US3bKVYF;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ppO4sa6k
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211708; x=1824747708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sdV30EnUMZAr3aVKN/dXLREMkBoxXUp7g1yIiItDRrg=;
  b=US3bKVYFq6d/L9OheNc5gTcWkSga61DIUD6GW0d/6YvIKlLpFH4/ToMr
   tHaTMLLH313nasHRW6LLgUoccFIMxZoZ6oEd4m8E5eisygb2G/xocTrCm
   23F2Xk8jzfdFNJm0TQZFyAFxLA/P8U8l5CqwShkKI4URysK9lfqrgnPQg
   tkVIgbTwItp6uv6yd6SA13ILbVUxA58WpgVyS5QlaVxpAOHW6dIm1qhjb
   4+UheaGVenVQCFzXUSJHIZtZ7Pamq8LWZbHlqH22qOs6u/EdyaJ0Hwqzs
   9QvrM9bJmMncSLwMYwDAp5WMzs7qvy/2fEl3a/Jyd9Xjk4OI4xFjr8ubd
   Q==;
X-CSE-ConnectionGUID: wveSjdw7SYyrMUtYgInpkA==
X-CSE-MsgGUID: O/sBi/6jTAaEOvl4lKgu2Q==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194176"
Received: from mail-eastus2azon11010059.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dvu7koscC54GaZJw7+tp7/pBg2654CUsMmlVDSFg/2i0qdEdBtj0kUb9DywoaOVO9YmGzl6wkHXOO0icOT7hJh+xSbzu8l8sYXC6HCwBGeuY+uE+IEnA36QJzC9mvH5jkfgfoQdAmll+/Qn1vXa1aRkS1f6pn2zeW01HQ4zW+jHbd4210zOc1gMentMPxThEiY7OObNvaB3atQAXs02GP2Im8SKJepGX7z9xvDp3EZZkJO40ByjiAXoLgmCoAK2bAsMXMurLCshD2j7hAkI9TfQnP0x9Jg5h94CAbqJ3KSARCNS9GBtC2q3vjTPGRSEKG4gy9XtJaKyFGj/lrm2bVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
 b=IfHqYRwwjDjSPyBEDKZxAx/7vdv81l/19g3dLbdecAoeXohxxYOyrJqpTc/USQSeTjSJMEBDH9KdQnneYV1fQMF88CjUOTYkoZXOobcbeQ2NDlnJSAGFvhoMOcfHkrS2p7dDmq3Ju+ni1EcQEu7DrLvj3Kzc10mCEJhi56TxbkJKxzW69njOpvkxQm8lJxwwL3PTq5gc/AGrR5eujvVxP14kq/ybnwvqisXZHPmkOONMF7toGAn0M0eL+MBJYJGOjbELs/US1CItJyqs1VYfsZV+sc8+yWg58yTyuP74cuNVdzo6sFPZtESS1sUTdQ3zjw4qnvyF+WD7caSe0rF3cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
 b=ppO4sa6kPHAiMmPKgEdC8rzZBv7gChGuVGli1CpCd8k311sMfU38rc9LeQy9WHjEygW3QpsRJBU5t1ptH5VeG8DyaUPRS/ADZKAYAojWZX+3oKwAs5C1plebxntOg3Lxbelbw0dgopVND2BlYwFSf1ELtpL7+KMI8qhQASTcOVA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:45 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:45 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 14/25] btrfs: zoned: don't count in-flight data as available in statfs
Date: Wed, 28 Oct 2026 19:21:00 +0100
Message-ID: <20261028182111.160492-15-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9264fb5e-f1a3-4b69-b7e2-08df3520528c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iVO6v0lrosu8UagptX8EbEaBN+izi3W1W+WTrDxUukpBR/D/xYwEbQbxN5T7oIDjzLZ2VYR4Vb3Y774eNU1RqfQUpj/NKjjL2d6qmlSWXR99wGqN/9nNSidoLyCsPiAAr0feXpJCjV8Qxx+/YzwgqktWutP1xUGkovklwAUfct0Mt6Rp8N0sWtPH2OQ0W7OW5hZXA/QbmgPkLk/OuMRmi3Yd5FY9KLTRJwfNGE7HBZ8oHoNYDmb1+cun03gx7VzbPxQWk6Aw21xCu5DJhwx2jZdorjM7k/i7mvJedIFgPXejfSkunnZgdLhniFgrUIV9m31VbX9rFaOtYkqUcIxk6Q1SXvh78D+2aT8A+wxvnhTdN6oVjF+Uvj3+LupfIg3OWVBVtf5FRlYxoyQinyLjVLAtjw69mFTlLdSehUEl+Rd28bMRngKIHHjTd3Dhamm4UfgOic+z1jeuUTQufFKw/HRdz3a9dQ2ZsFCvuH09RPbgyWPTNhv3Of8Ui7yk2EmTt4q98XQr305Ony5/Ncj0H5kB8i3ip6DG3Z8Hp01W6co+yGvMSq6I7T7+FKkaFkLN0954mh8y9/Qqw5ak0zDPV81+wjVybGYFHxvzsk3JEdyOWWUxIzit+1LmZbrMVHIIGgFb7qTIZSZDc2H51aoMlNC3vMT+EqcCK02OBRErAOc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2QCGZXXZE7jbQwUlYHMK4lslgHX3UAYkGO7g3QeFYobxbuGTx7H7jnlDKMGZ?=
 =?us-ascii?Q?av6IAHpJWFRqbS8y8Q9tQ9p9NIp5HJDhmURIaIo8ItXOyYhz2CPoRWCPCNmR?=
 =?us-ascii?Q?NWEF0QvZ6Yt6MiTImj/wtrdUwUJsFEv9gUIEEoIPCAwj548X18jPTLlEbt1Q?=
 =?us-ascii?Q?lpLXGTad4RpAsQDOlPUQVNbwydtQvASF845uo0kAYuK2lss6/2lVG2usb0Bt?=
 =?us-ascii?Q?hUzHBg/MSa6H0vi4uSFaBtwUbx5HmWaZ457dZv45zk2kP1E26H9CsXfwQLrE?=
 =?us-ascii?Q?YnoRNWMJ7lhIBMNVoKhYj+Jj9lPpxG1j2binpFM7eCgLCiQBhs/HJ9EPr6DB?=
 =?us-ascii?Q?AYP2YWvh3uDVbZ0etZiIvcnwQeM/0vkELYpovfQtBpln4MJ+C/H1c59wnKrZ?=
 =?us-ascii?Q?baEFoloP6Bw+cMsYA7rabGMmlMxGET7hfJECUNsAxPj0MG6uHJ06OT9BV1hc?=
 =?us-ascii?Q?Y6O8QJh/omoVZ/on1yqwytT17zIY1OHsdpQp6wn1+kmCU88On8deUBP+gE5x?=
 =?us-ascii?Q?A7pWXEJA/AWLlxf1UnXRgFyeyasr5qCpePU6mzd1eDbNcwNuHYBH+7/Xnu3W?=
 =?us-ascii?Q?FEmA1yBxYp6uhbccQ53Uz+bPdCnTsAKneMNrju91aihkFu1z1UuUOAJI2DJx?=
 =?us-ascii?Q?9mLyyQobCS7gOlFrxEPOZNEF3Kz95LHhvWrqQIW4y+i+Xlhgv3BDT+7auueL?=
 =?us-ascii?Q?o8jzY+cgkwuwHsFtYjl4TUlPVRAGBY6FhUnZD/w5us1TxD4sdlCiExK5/099?=
 =?us-ascii?Q?Efd8KVgEHiMT1j7Cw9HB+AMIWvEIDp/IaDGSwFic9Mdx4WxRrDfawaTVCBqW?=
 =?us-ascii?Q?cjDuhQeRni7B3tKYZqlmDbO8EhAABWSzlaMtNgcQvR+o0lO7LEWq+zh4DB+C?=
 =?us-ascii?Q?ieu9fZ9ZztYsDGWTiBdsGxekyyBpOWzbhnhPALd9pRZQHT7BCWmGjMjXhUfp?=
 =?us-ascii?Q?4V6TYiVXOWL9ef6UpfciFCatxYXGjceB0Cbrp4WCm/08tuaHdj+XqzW0/B51?=
 =?us-ascii?Q?ToshtcwOtGbOwSMS8LMyKPDm8VViUHefZU3gm5aKv05xP1AKXeXdcj7zuejF?=
 =?us-ascii?Q?6aat/rWB0tQ3MQOouBSb7ZF8mnr/ilFpeuJp7+yGSJ303PzF8OH3K+czZT77?=
 =?us-ascii?Q?c8G3ucyR4BcqUzpWRP5LDiczrzX4WwpYwp9ot6p1a4jmN0vwB2BTDhAxBF8b?=
 =?us-ascii?Q?aFhWf3yzuGrl4CvoguUkvjxjMF+XyE9Q9jaVHc1toW5M7kyLct2c2a72jrxq?=
 =?us-ascii?Q?Z5jYfh0H8uvNi1PfKuIGZqwX+zSTizgdsbZhMIHCQL0YKkHWlvd05nPEkuMt?=
 =?us-ascii?Q?H/PCcvjEeikjdimQWNwv2SH7EFIK4anDMY3yrkm8iPkkyu4VMZ9lckLDFaI0?=
 =?us-ascii?Q?2VPrJZl4HsU9tRKvxcLNdsiHsVR2bNNRPlxWSEhhK4bc/ot0CUaHu9/zZul2?=
 =?us-ascii?Q?jLZKnzJRj/5Z3jYS8MRPDGjoIzsq0VJOtGHFuWLkm6ul6rRhxW+3jHBwuhBx?=
 =?us-ascii?Q?1jqQqM4SYacCj/DJbZv2XAhtAkEc9DgeZFLWLvR3dTmQmXVJcZP/rRfIFfQ/?=
 =?us-ascii?Q?397fhKjDAFjpwxiY778HXoUzIljhrseuZFUV5JUg/gR05DYhi1D7d47fuz6S?=
 =?us-ascii?Q?Gi2XW+LIAbaY3GYI8toHuVHbVR9miJL6kPQSkSrS0FsS2mjmZx1VJzBZ/Q6t?=
 =?us-ascii?Q?10R4zbAVdOI2p4JapXw0AV3WuYR0zxNOqdUo87+UhtucqweOqrZj0SJsrLX/?=
 =?us-ascii?Q?gSAO2qKilJ8iYFELod3UEC/YwQUFcXGlpy1iZCJ4Nmy82YFVZPRc75oIteBn?=
X-MS-Exchange-AntiSpam-MessageData-1: WBZoeBB26kaXKcMPGFaInnKI7YBw3pGj2g8=
X-Exchange-RoutingPolicyChecked:
	csxGfMcE/l1qehBwcLXFAOGwiFXQMVRNsBuhtpat8z8lD5SWzTlyf0BJQ/ZlCNG9re88deO/4g0WItXX81v+GYY0U836+GmG0DpJ/lhTj5VuEbkDRiM8IR52GpVUxspAuUFVItBEa0TfdoU+ePaYB2o7KiI+Vr3ZKT/yGhkVv4+T3H9Qa9GFMdiHGKGH6h59SsZAvc3jEYX7rJS+BQk9im8iPu4VOOIwkZifBDBB8kcCWnw49aSKzeUY2it/MsnkvkH8XSX2b9nxF3IgnxlP9E8VqdZjVD/ZgWMKfASUmO/BW7P2rwiRWUNFcOq1hx449pOe0xnYceNRKmp+3FBIxw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5fZwJA3i5c0wIwglx40SPAO2ZHGjt9JpRMwpVaJF74U9tyrXXtmMwUdLHaP+YruehzFBjMsZZ00iyN4AjpgjS4NqSwNywQoxWvhNRouHzwJhmu2NLoGko7vqbg/5jtk1GddH3hF2GJjOKIRCUr9hpaiFhmYZTEl2xB3KT0DH3wADUPijvCpEuKtMKNCY56vL5nAGZcIZb16frzlrHpDvSlNDbYn9vEARnFI64d7bN9f6MISkDFBVxDvrdRtBipdQCxffzQ8/Sq/3Nr2WV5vZDazcfXlKEGT+zuXQGSDU30BTiecFP4uImBVsKL1qoxjv2ioASVVQCCYwhfmw7coMiF6i0czrFvYj2zd2XIGur8vdu22Ab6yqefi2gXW+rnhRk2umJdFYW8nDOm0RHa0mURQQuVFSr1VGfNZ1q7UNLzaON+ghofoUL6t7zqHSzXY4E0AihNuCFSaL+bsTJFJeYAoI60GAtuoSl2yBy9FcX2/MxSvN3xrZgcScQUKVzbviWwtd7K1ZSkDlul2EhuMPdygZ+pSx7v3gQRtfBl7NRbxg9KGMg38EQC+JO3YJuRqw/doP1zy7XxvkD/Z4HnSjowZfwOq4Z5rGJlhQXBJxAxNKjK3PxsOrrB7fscnPUUA2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9264fb5e-f1a3-4b69-b7e2-08df3520528c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:45.1710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /OqiIHLfAjAl9FURRXoNOmiBpH0bUQ5d0F1yLkNvfBVHdK78ofUPHoLy4BFM6Kp1xdbIm0ynusfE6v0Smv13KsueC2QHkIqHocTLS47d/Pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

On a zoned filesystem, space of a data block group below the allocation
pointer is used even before the extents written there are accounted as
used, and freed space only becomes usable again after GC reclaimed the
whole zone.

Don't report reserved, but not yet used data extents as available in
statfs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..9bf211916870 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1691,6 +1691,18 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
+{
+	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
+	u64 reserved;
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
@@ -1730,6 +1742,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
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
2.56.0

