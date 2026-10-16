Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0E14334B9
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 07:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136855; cv=fail; b=dGPa1Vxn5+IVNFj5P/roZLbyfyIheyO74F2HGr6MyPobrAuRgiDZ3gH0N2Um4OARp3KFLpIq2VGgjNE5Hqh7JjEMrApfrg/lu1ur1HFwIgHHQj62LOmmOoq/EwimfUvAYeZC0PpZ22y8MqzAhiiTz1xYGJYUPP8eOyk4RWW60aQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136855; c=relaxed/simple;
	bh=mb+9H3aMUnrKGU8fWgFwO+uUrTfGxzC38k/khPWTLAA=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=mNT/joRzQHgA+KJ00ka8BmXbD9xVR8rjlvccjRdwuhDT9L3ynm2ETCGVHrfymLecAMskBzUG/GhYtKA/p+s57D9W2qzC3WA554VTnyjqMTRxFFnrg2ZiprtSyrQ65nO8JljjLKzXPa1ceBYTN6pXIp8BW/nDI/e91ufI9Fs1IvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=a96fh13a; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JT87i9a8; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a96fh13a";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JT87i9a8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792136853; x=1823672853;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=mb+9H3aMUnrKGU8fWgFwO+uUrTfGxzC38k/khPWTLAA=;
  b=a96fh13a1n9vNUaJiotpzcvR0s9751mpgZ7+y9rL+ANja4mHToZ4bNg8
   XR8cfq4I/vW/VC12TlmfZSB+kzb/c1h57zhxpLgao9mNUxLwHtKKPl+yV
   sur5UF1ZQs3uIG/ln+jcsy/YxCda9Ai+LWsZJmmL7vmZEV0n/eC9PJm7p
   h2BoQIUtQT5apPoYHEGaskOa8ICQuIe9SfzllsOU3BuBA3CJSz+NAw+n4
   ps1UsxJFTeR4aTw4UjwAuTt9cOXdOuMQR6YeeOju+asyCeqyk7OnnBiYy
   5rta2JOlojKW6EXKzY0uULA007WIoyInL+xxW4BwXyJkZxigmP5Ulswcg
   g==;
X-CSE-ConnectionGUID: +aK5SOqiQYeUR7mOPdJs5Q==
X-CSE-MsgGUID: C80k0YqiQjuX4RM8n0YICw==
X-IronPort-AV: E=Sophos;i="6.27,161,1786982400"; 
   d="scan'208";a="159199860"
Received: from mail-eastus2azon11011041.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Oct 2026 15:47:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y6b/MyiiRfv1sI4T2Wmzv0fjqK8dCAe8TdPveRhk8QUF3QejpOhScD4v6EkLvGFZe8pk8cplZIIAhYVCzeXFwgLp08cCIk1Dh1V1NrUojSaif9H9syGHn0JwOsZxDEc4GJ4ivbO5U9g2kQI57Pdz/PIGUx502PFszF8p51XphE7E1vEagolr3Hxcmkd2czeLVC50Bn/yVJcD/M77hxLhhx5aFzzZvgC3e5cFkfYzDL4iiQIBSQetydrfzVYm3r5KqQTH0WiG7mYOLODZLoqDpKNso97WV3G6Mwz+ZYIECKyir6e/vGi/xOI5gKua20OK/1qm+Qdg33uZ+sTXD2yI0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0wuEaXgiDGzu7TpBdbM0HWMpQOOqSe3Ob642mA2Aqs=;
 b=wOaRppJPXDXG50gW7wuMYgE2e6jB9OJRe6kfw5hpqnphI8sSqR9RlPhjMhz7n+ieOhkAVjYVPhRo4C4tWIvRX8zB3nzU4okNH+d7w3NjcusAOUuSOyTP/NJIYlo01841ZnGDrpI9ly2/bAvM4uCc1AXvA7Z8t8d6LADMSIzxjrDyWP+/YePhzNywt0ixfAFFQyvAfRibq2/hhm6yCYbzVnBIvPSINXsDBWLMxbBFSKz236F9ncSDXOaOIJaVz37YglWyKhhFJYvmT0dNvmoZ//0ORYk2UO1m8BiTa3uAYIaYLbNt9zHApUMKtloK7CDcXKTmz30UsHMiJ3+BO2FJXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0wuEaXgiDGzu7TpBdbM0HWMpQOOqSe3Ob642mA2Aqs=;
 b=JT87i9a8SS6/kC3X437E9ObkC1g30eGkC89G2d0IYhlMFXNxvRDD2I+ZuV26eTXUjcHTuUovu+JZEcJM3gltPDh08Dlb7J+MrV8ZuXOci0nlTTepgGLcMCdGhTkm90xFJOjGoFf5Hf3vr6iPXfveZcJgQZWON19Hqbw6c3oySWY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by DS2PR04MB057852.namprd04.prod.outlook.com (2603:10b6:8:4e3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Fri, 16 Oct
 2026 07:47:24 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:47:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Oct 2026 16:47:19 +0900
Message-Id: <DM63HMFNJR0N.1HBGQV8SDMAT2@wdc.com>
Subject: Re: [PATCH 03/13] btrfs: zoned: don't recheck the reclaim threshold
 of zoned block-groups
Cc: "Hans Holmberg" <Hans.Holmberg@wdc.com>, "Naohiro Aota"
 <naohiro.aota@wdc.com>, "Damien Le Moal" <dlemoal@kernel.org>, "Christoph
 Hellwig" <hch@lst.de>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
 <20261014120353.757931-4-johannes.thumshirn@wdc.com>
In-Reply-To: <20261014120353.757931-4-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TY6P286CA0029.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:3b7::19) To SA6PR04MB9269.namprd04.prod.outlook.com
 (2603:10b6:806:417::19)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|DS2PR04MB057852:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c4687d7-9f52-4a2e-2726-08df2b59b715
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|10070799003|1800799024|23010399003|22082099003|18002099003|11063799006|4143699003|10067099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	JLjumi8SsaMX2FcMQrdVzDGIjcYBVwyy7Uth13jTWwXFcsv7djr1uYyQtATFATqw3q374MB2mbVe8E2ogWDT9bV1c90ozG9v5lbSK7bs/UWUDts8am+KFtgfQS7ysLcyRx+/FVCbR4kTrNkMGq6i431MytTEPPBX320lj4WbDMGOf/wIO212sZsCEVMXUhmBWWhBdqBWOMDbe/KuiYwTVPchL9bq0/RNxGK77+TjDNC+3Qqj97IQiXsdyjNKV9A9F5f7P+KwYVUFl0bwtqcHqsIM9pIlBoy7fFfNnQUIUR62VpRbkgjE7Ot4AAX7MkV0VoaSjUifvZquf+kb3j+hR4ey+Bug3+IO2o2H8qzKcGpXQ1m7pqk0SpLDXpjkM32XDFR/cz/lgUoLlcU+03/tA7rXSZsxksb3AdAaZHomhSkP9BV5UTm+pj8BnK3Z1CSOqTj74ZvHnf8u0hYHVEG2Hw2ZcaaxKdO5Hy2IWspEjR2Y8omV3/Dr5EpwVx2LRnRbWNyGwKdnyIxMWGESz2HJR5dxl0hvq7W9oQ06YlaptKtb+fADq7FWSeSXTux6EpV2m1zeg6HDa0YHxNrhmUK2rWa2e+zdeV+qNeOIZ3oA89wTwUnTqXyWM8XDx6Uyp0iNJ9q3rWnaFcSHNPZB2lSLADyJ9cgJ9VnZr8I81wJmcbA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(10070799003)(1800799024)(23010399003)(22082099003)(18002099003)(11063799006)(4143699003)(10067099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODhaSHRZN2hJdkZkY3RtdFZEQzFwLzhlUkt1Z2poQi9WYWpCRVdpSURvVTlt?=
 =?utf-8?B?UWczOUlnQVdVMmdNRUZrRCsrZ0tDc05GTWx5aUNoUVY5NG1vN1ltZjhtdml6?=
 =?utf-8?B?OFhVYVFaWmwvRUdXeFZkS2xhOHlRT042YlV2eWc2dWNzdVF0WXp5aU5YRXNq?=
 =?utf-8?B?RytBT0Y4L0dwRFpoM2lmbkphVE5wWmlHaU1HQ25mODBwWXBDVFVRUHVwdEkx?=
 =?utf-8?B?M0hsS25jWFh4T3hqeDZ4V0ZVdmRrUzUwdXBTL2NJSEp4ckgrMERFZGVqbGFo?=
 =?utf-8?B?dGlVeUg4aUM0aVp1T3FSdCszTXVJbjJaZ3hFbkxhaCsvc2xGZWdzcGRvcjBU?=
 =?utf-8?B?TFlibXRQdFRwUDBEbHNrTFlHV2o5Q2FxeXdBVEJhSHZCd2I5M1FWaTc1WjZq?=
 =?utf-8?B?UzBKODFlQjNSM0RubG5lcUZjdGVTeVZEQUFmUzlBTERxMFhSck5Ga1Y5Nm9N?=
 =?utf-8?B?VHp6ZDlHSkx4V1FjcWNvZm1oY0JjeWxzRzA5RXpmVzlLMlQ1UmQwUUhJUk9O?=
 =?utf-8?B?eFkxK2pSdzJNTlhFdU1PMTJKNW1JVmpaRG82SEg4VldhbzZHMkFicmJiU3Jv?=
 =?utf-8?B?d1FMNER6RVNwNlF1N0Ftc202Zi93SndadVV3Yk9uSHpDaVZkeHgwd3ZYa0FP?=
 =?utf-8?B?bnJnK1lrOXU0TU9EVkcvMFIyelJoYnQwTG80UTFBK1h4d29rTHBzTExHdys0?=
 =?utf-8?B?T2JzcWVDOFpSeGRmOUt3V3RsVHEvWWxRazRZd1FjZWtBamg3RTdiMkRBb2s3?=
 =?utf-8?B?OVF6NlZFV1VOakFNUW5BdUxlUXRuRDhHYUVYa3Q1QUgvOWFsM1pEK29SNCt1?=
 =?utf-8?B?bkp5d0k5S3BrZG1GRHo3YlFhNzdmS3BSdTQrOU9qTEtzTFZPWW54Mi81VkJp?=
 =?utf-8?B?RTFYZlUxQXBBRGVGZlB0MEdFWjBhcHM2RkhVU3YwL253NTFrUkxhNzdiU1dK?=
 =?utf-8?B?ODBEUXNnRkY2dm1WNktuazhZTnJKL1ZoMHRIUEZjSm1zenl0Um9VT0dJL0lD?=
 =?utf-8?B?UWZ1cTE5UENwVjRQVy8zcmtLRnQvMGJ4eWNYb0ZDb1c4NEs4YnljQmVRZnY5?=
 =?utf-8?B?dm44NlNmUW93bjFjRjF1OFhpdUdqS04yU3RrbDNrQXdId241N1YwRDlrUjhW?=
 =?utf-8?B?UTFqM3BaV1FRZEl5ak9MK2V1MUl3ZWxNa01lN09TWUFEMjFMZnhUTDNNVnFa?=
 =?utf-8?B?Wng0dkZyd3NhTlJiamxtUkl5ODJlL1NXNjErTGxoRnY0S3gvTXFRdXJIcSty?=
 =?utf-8?B?MVp5R0ZsL0tzWFhQZC9mUU81RGR3eFVmckxUVldDOXFINXdsd3lGbnhxc05R?=
 =?utf-8?B?d044WndMSCt3NW5TUXRZcks2NHJIcUNzT2orSms3WENMeVBQcWtnUlFYYkh6?=
 =?utf-8?B?RlZKeHkxV1MwckZzYVdQcmtxTi9qS1ZzU3NCSGlQcmVmR3dvTklDaDVTdzlL?=
 =?utf-8?B?cVdhQVRMZjh4U0xPRjVlY1gwZDBxeExwTkxZbnQrTEZPR3F6V1A2QnpJRytz?=
 =?utf-8?B?d1FnMmoyN1MzWjd5ajBDTjVnZ2VMeEJSV2FCUmRONUJtQUIxa29JR28xMXlk?=
 =?utf-8?B?Y0J5TlMrZHVVSHJXVFNobVVVdXJKcHNpa1Z1OXNkU2M1eGVUVHdyVmhHR1Y5?=
 =?utf-8?B?RlZOaDhMZHhSY0VLODRtR3NqYVJyVUJlODA3WnNnemFEQjVZZ0JZWDZvVzVO?=
 =?utf-8?B?d2RPMjI5bTljWHl0ZjZNS1NqdVY5aXFuWTVYeDZQNE4vWkNaK2crNW0vYTl0?=
 =?utf-8?B?STBYSmpvL093Tk9URklpRlExbHc3dTY2SVN3U3hiVjVBYUpoenhRTWxhT1ZJ?=
 =?utf-8?B?MUVTZDVjTm83MkZmZFBIcnliMVB3U1ljUXoySUhhYkEwNG1IempzZC8yMWlY?=
 =?utf-8?B?SDJHRkpxVWJxSkdncmRIenNTTkh2cDUyUFZ6TVNjNGszMXhEL1htcGVxU2hw?=
 =?utf-8?B?ZFMxakViNjN4MjZ5YVQxS2Q1eGJMNkpVQ1pRWHhFZXJDNWVKZnRtbTRDNEM4?=
 =?utf-8?B?emxRYXNjY0lrcDZmaUVZS1pQYjdtMC8wdG40QUJzanhYb2xCWWkzOTlSY256?=
 =?utf-8?B?UkZDU2N6ZHQxZU4zK1ZjRitOekVvaFEzZldlcVZFcVVRVEptbjd6b1lDejNO?=
 =?utf-8?B?bHczeVhXcXYyalU2SmVWNUlaQ1hGejVnRjZiR01QY3prenpSWHc1bENaTk1P?=
 =?utf-8?B?bEh6SGoxZm5iekdaSGhRVytqZWc1UFA1Mmova2RPWXo4Y3RpQmUvRjFJRlZU?=
 =?utf-8?B?VWp5aDlPY3BiQlBxMlZBREwvS2ZyaytEK25IN1llUUxRNndLb05ubEU4K2Ix?=
 =?utf-8?B?NWhXUGM3R3FVNm9kVGlKUnJqeGFNWUJJNnlJa1RTdmpNbUVxSWI5a0p5Ulhn?=
 =?utf-8?Q?6BcE+vXQOLoZokfXeLmVVuPDlOJrnM/Yz5e8b6Zv0P4h4?=
X-MS-Exchange-AntiSpam-MessageData-1: soDXwZMEibLmfg==
X-Exchange-RoutingPolicyChecked:
	0LM5zvskTjF3aMHXpbAA38h0RCuX7Txp0TdXUTmZ8TBZ+fr09+2luHR1nyyciEVUNUjH3pR95ADI/+4V5iaw5K6DfY8uvfeWB73/srWELJ9Qbtv0YFxKTJx3bUWASyUo52CnONWmyMsKAp6IFzC/Of3wLO5R/GTaHhU1FToYpYxGQEwuuUxRTgOo1FUyyzimEb3ec5NGptc5H3zgUnzIaStznyMCsf2i3x1QNRe7vyoa0/EnIRj4GkkqewZO4CTkuNRxAmJCiFyaLxeFHXvs2ykQzTaHSUVvUuZwbCiBlpTMKmg0eE720Hvlpw1qH2P5wIx5NP8RcToqEiczuWF/bQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	McSbGinzPayEFeC1tf4z+pbJ6C0sjpvcI48DzqGOhnRwsUDCf2IqKKQHBMUx7U6ICKI1KkCKcjBgD1i0ohg2DFjTFh7xVG2k0ddtPIyDntlQ/Tm/42BgQXJAj/AGSWOZYb99yHQ1F/GORRCZltqasSeEN5Em6wRuJ6zQTFk2B8F0FXkcBiKaRwk9YL9tyDnNAv7dVWwj9U1O9CoudhEU0nXG3ftaZu7xPgl8xKRyOXbWLbwTzqIs9dx4XBy8R7EtE+qPV+j3RVhcTsPIA5zboqDNRYK/e3i04wI4KQmWQ+W389LyR4Vs/6eiwat+5RZpiueiXAKE1SWsXrXCEiF2MaWyom/53thdV33x7zx7xEkn9uE0UsBGyO4W9yB5KsOQmdXjgORYYxtSMhLJp97thKvnht6ZMYSsnQb0uRAX4k+wGSy9fmLxdohIrJO2MjEz1SHn7aamNCSt1G+zmAlZkhugtIRxgjzmam2m3e2+jhvn5TsXTcW1Hn/qnsrtamMG1Zrvc8YtxGCz8IS5p59F4Kbn/FxdVaMmaxfpJPzEfa3SeMTK1vJMzN7tBcfIIqf/OdRhurvrZY8/Un/j56Rl6tGdbejAmX0qdETyuy28ippNrQGSv/SF6pqz9T3Mr/MV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c4687d7-9f52-4a2e-2726-08df2b59b715
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 07:47:23.9655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RsV0C8GSN43TLTrKM6leDMSknaYRq8H4L608D2opWGnlPFk1k8YcjGKpByX9wCDbCi3XpYmJznOXjH5NDoRXrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB057852

On Wed Oct 14, 2026 at 9:03 PM JST, Johannes Thumshirn wrote:
> On a zoned filesystem, block-groups on sequential zones are append only
> and their usage can only go down. So there is no need to re-check if a
> such block-group still qualifies for being reclaimed, once it is on the
> list it needs to be reclaimed.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/block-group.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 34ce3bac45a3..bad55ab4cbb2 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2033,8 +2033,13 @@ static int btrfs_reclaim_block_group(struct btrfs_=
block_group *bg, int *reclaime
>  	 * being freed, pass in a fake giant value to skip that extra
>  	 * check, which is more meaningful when adding to the list in
>  	 * the first place.
> +	 *
> +	 * On zoned, block_groups placed on sequential zones are append only
> +	 * and their usage can only go down, so the block group still qualifies=
.
                                           ^ on full block group ?

>  	 */
> -	if (!should_reclaim_block_group(bg, bg->length)) {
> +	if (!(btrfs_zoned_bg_is_append_only(bg) &&
> +	      btrfs_zoned_bg_is_full(bg)) &&
> +	    !should_reclaim_block_group(bg, bg->length)) {
>  		spin_unlock(&bg->lock);
>  		spin_unlock(&space_info->lock);
>  		up_write(&space_info->groups_sem);

