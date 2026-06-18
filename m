Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914EA3385B2;
	Thu, 18 Jun 2026 12:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781786458; cv=fail; b=UBg+KLyGTgLkHTg1qpT1rChoqb33sb8R4uxPHdLOGl+bHybAg1Id+09juI/7urVjni+7zH5Wi0rxbOgVhCpnxGqbziL3ePV61xosIN8Cs7Nt5Q/b3XrVekZg24sQ6WcPnuuAM0ytCASl4ZOX+ny2Wm1d0j5AkFZ9JtAHh0QCjuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781786458; c=relaxed/simple;
	bh=4k7ZSXbftV0dmW/Y6rYnaOwwF5ARXWw4EcVoEMNlJ2Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QUObWpuD7GCfNR+sdepR+myrXw/woGU7uznHlrS4sjbuk/MBEraOYC7tLMKHjKppmA79gFjNpo9X2uaJ65vOD78bCw+GcdTKUaxE1UitMnIXU74yx2StWeUvwhUMWbnMs3c9hcoZj+QjG3GEj1ym0cWVVn+vg9Is214COicZFtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fmHEC/Sv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=uWJpRebv; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fmHEC/Sv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uWJpRebv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781786458; x=1813322458;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4k7ZSXbftV0dmW/Y6rYnaOwwF5ARXWw4EcVoEMNlJ2Y=;
  b=fmHEC/SviBKriSD7IxYHt+mbPizeKZHjEUEA3dGAfjakhx+6blLtrogN
   yq7dGrq6XOHAdiiD1UFJndiJ7sZBCPFeU5Q1gUxowhUgN7X5sLdqllGoz
   Wp0oTRL4W6ROPFVW01KMyFHwQcIj/w39e5LpDtkOF43OYqShcFv/s6B+v
   8eshocF2WsVIi5FgxE4ieBALB1Z+CGbpCbhbrURhEBF/vDVTpxB5st2u5
   I9mIvlf7PImN3M/AI4kloyxW0RlH7sWZrkjdH6s1KMNGZ1ADtsbDBqblI
   psUT925Y2/LDOhuoARQuFtwjvOgHr8J6xAenDB4WzfaBJYixfjG6JfmGM
   A==;
X-CSE-ConnectionGUID: oWAJJy+IQB+ZOYTx9Lz32g==
X-CSE-MsgGUID: GQnOJdOISE2+AWRdagf6VQ==
X-IronPort-AV: E=Sophos;i="6.24,211,1774281600"; 
   d="scan'208";a="150292533"
Received: from mail-southcentralusazon11013009.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jun 2026 20:40:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jA+EabFQJmsljAyUzlL4dm9tw/oGpjeGL6mQkX8qfzMSF84ELbfGktEa7hzIbB3XuvYGS1JVpJqT0tzaTdcFcKwiT1/Ji9so9aM9IeDVNsZYPRQo8WbDARQ1WAgAPIPrq7isYhq4EuIgw/PKyJn8IeJ68mVCcorD7pibwkAW7k0s5Hq2mMcpK9NFkDuHQ9Qg3BFlQFefnEs70/SXRGlhvSagJF+vo62DKpx6cnz4WS/WNiPZUOMywMIzN37yn23tX7emKvSI2rb2RvzL/mGx24PliNEwJYvmUh05tABW8XIimsXLUlhFbaZyfb9n941+Cr/HgQJcQR2nsxsIPKIz0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4k7ZSXbftV0dmW/Y6rYnaOwwF5ARXWw4EcVoEMNlJ2Y=;
 b=O3XZCKDc+XcS7AFUwhVF1duaYhZShNEcoSd/d+gzNz49lpBv/CJB5FbSRdFosN3WBQ3nOOZI9nro55nJ5XGtajYUrBUir/KaB+TXJ2neUoCSHeC49Az9tHJH7r0lEHjxQqKNytzTHA72fZmMUGZbYd9sq7gSQ7ZLjsvjU2edgek/eF7R1PsXm1f/Z9fIXk2eMYp2pAocffpVuO2560iPXurMuXdZFd+bDWJxXfrzJrEOBq8ySmUaRZucvpS4pZByN9eqDRt9+ymHnYVmld/3jvdc2b2nzb/3jJ4689Q5wyGP7piL1t2MqLIAUd71c7L8qNQYQlI47yZkGY6+P6ApFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4k7ZSXbftV0dmW/Y6rYnaOwwF5ARXWw4EcVoEMNlJ2Y=;
 b=uWJpRebvYYKpONaUPLCXTMoY+ST90ApJkcY4sZJpqyWbBWS4Y178TmP2qcV+oOPVuu9Sl4+hTN/H97NducFPARS1Vdl3GUq5dEICamopJxNugMT40MhHvv6osHQ8gUDnjb6VRc26+1mfr+J2mHrlP6cwun6ArGvNRFqXAEprlBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LVWPR04MB10076.namprd04.prod.outlook.com (2603:10b6:408:3be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 12:40:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 12:40:48 +0000
Message-ID: <abe168aa-a1b0-4930-b383-57ca9366c2d9@wdc.com>
Date: Thu, 18 Jun 2026 14:40:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] block: split bdev_yield_claim() out of bdev_fput()
To: Christian Brauner <brauner@kernel.org>, Chris Mason <clm@fb.com>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
 <20260616-work-super-freeze_deny_upstream-v2-2-b3567c7f994b@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260616-work-super-freeze_deny_upstream-v2-2-b3567c7f994b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0203.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::6) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LVWPR04MB10076:EE_
X-MS-Office365-Filtering-Correlation-Id: 36dc2f2c-d1ba-422a-cf18-08decd36d2e5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|23010399003|10070799003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	LrEoBHRQoF3pOzPmK0Yl12ihgPW9CTaisOfEPoWtWE4JonwjqxlqKUXBwyMLhq8uKTU9HgqbsDIFpuoV56JfBEZmsQ1ZCPTBIXbQXYEascpZeZTM/pNVGJQRFHK8coY8GY31PTqpNfj3YbzogWgEiC6sXASkeInHTMLUMarXeSXHGsDgVUksVriE7yUse5Ri0onrJ6F/MLzfF/rDJ6TuahnIqDQ7bIRTIfegvlOOPvD34m957Jz8AIDaK3ikIjxpXe7Ky3E5ByUbb+DI7uMFKS64OJE0Q1KTpaR7v/ICkZyMRfoCAgCP0SqLcB8/fVkl0tSK3g68Gxuw28f+3O/0wI5ASFSCeX7U2/XjGnuX7r6FxKBt6nkJuNN2kLkvBUNCxUScqS+GEXs5ObmJiyWZLxbAPtmRp5oY2hLznb3SEf72PdL74D7S2attEbt8jsWt9J88HLr7f0N0Wok5sg0QbslWKUzgb51ATkWufw8ijnEeSnk2b3NAdXf62c30n/dKg8m9KmyR9L8ambiWsrg2rDNQQ8WwiLHtyEuDZcHvleYp5De86L4h0Xd2sCFXWGbn6pMQCkZR1DNKDHmb/q8uXTL4wpr7bmB9J4v3PQqjz3mmTSSdaqN2GG7tUK/VxIkpxXL4J+JTm/j0EKNtz5YyqFDYYonM5gpJA4vYy1ntkM4pFFn7TXiDNf0sY/WhMJJ3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(23010399003)(10070799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXVkUlNJb3lISXFwbkJEaFpsdXR5b3VTZ3Y3Zmg1TEgrK0FaditmUXJybUNj?=
 =?utf-8?B?cDZLUzVaekVjUEFZTUpxK2hRQ1dHUWJ2dE1GRVgwUkVNV0tZSkF1MFE5VW1H?=
 =?utf-8?B?Z0hxemphc2YxMFF6b0VOc3Z1QnkrZHkxVlg5SzJsQWhlOEtiMXRnMml0Rk9F?=
 =?utf-8?B?V2R1OEc1a240VThpc3NvdzdORk9wRUtPQ2k1T1phNWRMOElZOXBZU2tQcCto?=
 =?utf-8?B?dWpYT2tNOVhqdnRrSGxqbEtUMzhZRExlV0lVY2dmT25jV3dKMlhlR2ltaWpC?=
 =?utf-8?B?YnAvYWplTVU3NmVsbG05YXZjSjkyZXlFTHduOWxMdk5MOTdnRXhMUmhCdnlW?=
 =?utf-8?B?a3VaMHlBUDIyTUl6WVVZaDgrcG1rOEc2NFNRTkhUM2JlU3Y1QU1USzZ6aFZi?=
 =?utf-8?B?TjFhV1VnblJBeUdydmwrNVlWMm9BaXFMNktkczNHZjhXdUsxaHU1dFJYOVh5?=
 =?utf-8?B?TGUybXJhOVh0L1FZZkNNMEdWVkRVVTVFcEEwRU9uU2RDMldWNHJ3WXdqVDlE?=
 =?utf-8?B?OE5rNnJpK0ZYaEVxZXVQS0VyN3ErbHRlYkxPcUdTQjIrcTR6QWx1MzNwekxF?=
 =?utf-8?B?UHdmR3EveTJRZTJGcHZaU0x3cS9pR1U4VzBqdi9QaFRadGJIRFFBRE1UcEtO?=
 =?utf-8?B?bHRJclkrWWk5ZkJkcG5aUlMrL2R2ZmFxWGRTUTlVb1ZXOWRXVUtIcjh3b0M3?=
 =?utf-8?B?T1NXZTJwYlBhMklHOHRoeGhFaFVWU3pnU3pTeGJ1TGx6VmZZbm93Z3hrV0lj?=
 =?utf-8?B?QTk2azZrNUZrWnJ5MXJOdmlpK2UxTWpTYzlqSE9YT3ExdW5JRVF6ejkrYWw5?=
 =?utf-8?B?MXlOczlNcWFDRkUzM2gzdkhJVThHNlpqSVFVaytPSTVNaWJhV3pKV0ZwTWZs?=
 =?utf-8?B?ZC9iTktjYnU0eUlrbTk5T25oek5aTjEyaVgrbk9QallRemsrYVN0TWIrbi9G?=
 =?utf-8?B?M0F3OVByN2dadEVzS1h2UTFLeDhWUGJyc1hORm1Fa0t1MTdrd1VZZ3dEL1Vn?=
 =?utf-8?B?VmtkNkdDVS9FMlI3OC9HeVRkUXUrTUNkZEtiUzBmZS9UcmQwTTZTVHNNcTZo?=
 =?utf-8?B?UlFXK0ZMcDRwMDFNaCt5eGxpZ1pPTUFmS2hBZlNpUkZiRXBienJEQ3RTeHRn?=
 =?utf-8?B?Qm45cHIrWHZsMGQvb0FaaXQ4TU1ydVMxbHZYUW5qU3ZEU2RmZkJkb0wzZ0ha?=
 =?utf-8?B?ZHIxRmVRVUpVOURPdUNRdmVDMlVZVmJ4MEEvY2R3QVMyTVRudjNnbmljalg0?=
 =?utf-8?B?SXp1Z3prMW50NlAyZlNUTEpHbzE4REI0M0ZORUtTOHlNZkZyUHdpMTFkazk2?=
 =?utf-8?B?aTlsV1BQbjFxeGlIUU44OE9kb0dMZ1g2WWdIR3ViVEtoVnBSeUdQblNqMXF4?=
 =?utf-8?B?a0tKU1NJQnhzRGlGR3NyNDZTb24yNFZtT3dGQWY3NmJVb1ptRzV2TXBpWGN1?=
 =?utf-8?B?R0NFbEkyZGhtdTFRTTg4RVNhTElDaEUxYmJCNGphWExJN2padXQrVDYrQkoz?=
 =?utf-8?B?eVRMb295d2g0Ym5UUk52REZTeDhiT0ZsQjRnMnZXZXhvWmtYK3lvUGxaZ3lC?=
 =?utf-8?B?b1VqSlFHcXJGK1E1ZVJPdG8rd2hTQ1JPeGc3TUdhSE0za00vczNob0pSWndH?=
 =?utf-8?B?bXhUZDFnRXFVamp5RStYRFhjbTB2NENiNzFkNGNSWUlHUUpyL0k4QllCNGFY?=
 =?utf-8?B?cEwwN084SVAwNkZubEd2RjVQWUtjMkprWTZJZzBhWWZuQlQxdjUrZWtDUTFB?=
 =?utf-8?B?TnJGTlIxZjZNZWZ1QVFBVEQvcEVLVk9OYnJQaVh4Wmk0b1lqc0lJN1RSN3FR?=
 =?utf-8?B?ZU5XNUVpL3owL0RrNTRKUkhCZlBuVndEL09hV0VFT0tVTE1BbEtBMmdtbHRL?=
 =?utf-8?B?Ukp4S0F0ektpTkdzcFpqT2hnRWtyWklZRnl0bXQ0N09acXYrT3NyaGlpdVpq?=
 =?utf-8?B?akY1U2lwQW1rRnZRU0JaenVLNGRsenJaZEhzeVN5dTJqQ1dPRTM1TEthdjVJ?=
 =?utf-8?B?Sm1ueFFreVpGT1JncWlRVjVmeEFiUjFoSm9GQ1hEUU9OejQ0OHRqQml5ZkFI?=
 =?utf-8?B?Uk93V0ZNWDdqMU1WZ3BEeEoxVzlYUFZ3ZFRrUHlYdVArcFpocWFoVmE5dXVy?=
 =?utf-8?B?N0pLbnFyb1BmWmU4ZVkvRVJ5NkFPRUlWMXhaSjVWd2tkTEpFMXBYWU00Yy9Y?=
 =?utf-8?B?djVmZ1ZheE9Qekh6UkFDaEtzdFphUk1hUjcwTzNRYkl1enBwcEFaU1pQbkFK?=
 =?utf-8?B?TXREeS9VVVlvczFuQTBUQkhib1VGTGZCOG1JVXpOdjIrYkNsdy8raVdqeGow?=
 =?utf-8?B?bXJwbk9vMHFVVFhyMkdVTU03YTZnOFUwSGk5NnRoanphZjgwaFBtTXhEUXhZ?=
 =?utf-8?Q?0mCMKhumjKl+G73WcRX5m/sI4GrsDPR3OpKx4D65iX3RS?=
X-MS-Exchange-AntiSpam-MessageData-1: /U1QfEFfVPn4oYcoMhNi8XI+wrMzxYJ2DBM=
X-Exchange-RoutingPolicyChecked:
	Lq430fSmUpk4sPFyWbwXrSHr9Pa6Y6QiNrjYfq1PdUvJIwzo24ua5nEg/+57GwpHtHcn4360E4OubNhvLRWH7hOh/O/TCP+GzYCghglIz6kHa3zeJQIhHjehZhrBtJJ7n/GNLXjpop9LD371KxQCedbS+ZSi6nHaVUwAGNK5ubOqVSqOcpjhki4b2ayKyOZV41Gpju++oRm7JnADfoOU0GoLJPDwj8kyPgngbY92tk0iL3Du40UTI24JeyN3Rm3DqAFo5uGzxanM3lY7AiYrF8wnpjRKnab3P3V98B43LYucUyMzpxjS9EQH5J3+4FK88LNrzhNbCDYE+gqh8cDJ2g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7y32pCju1Eg5VB99vGmbNnRYY59sEw/VSdCWcePvEMElGtrsPebyx16+tPpaeiBsw7vEEFLSH8gJWVX4dl3DYAJhHkfSKix6EdV03qzUj5aFyaGowehTXRavUuvSnAb+GGzRm1mbLHAVfakfyv064OUFnDgnbLnutJ1yuS5GNmoctyH5BuMALHYTUBSXB3fRKQfpHTvl3KNXGJN+dVzWCHyDV35mojuo/3nNP0j0piW6wV/TGzEO/ql44E2+HSTUnOoC07EvePCfhVg+vDMFmMy1gndQE7OFgpVq7oJJ4zfKbba6E0UF4CCwlvDLBuIXD/7PYJPlJki3o5T7+vu3oe5nwm4IdAhTddYh+TrJ+2tvt2yM5XCKj7Rm5KEf098Z6sgKv6E9br1c8HhLsr4nF3z602AtHnYy9fh19j2fNkaijOmxSLzwRA09ry/KsdfefC5gF2Xuy14h3ZT4HuBTwitSEdq925BYwDjnsgBiolkUckkPYL0w2Z1NNroawHKTSaYFA24WHQaoGyPNzlDLdEHfaZie0L8T32aMVU7ptwUkDGxc6YMNa/11M3Lfl+CzxN/M7jBqryR5q9dpbTMLBEspxbcw2tA4Q1AmttZ9wUk6ti/1AVuJaDN+6nFCJYIS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36dc2f2c-d1ba-422a-cf18-08decd36d2e5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 12:40:48.6302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JkSw0cfEqR2iAl0+sYPqLmYqF6MGbMqghWIbczOTM/l3bLB2933lMG/uwkEr9yx7+S+CJ1HpEFNqn5F1E/t2VuYW8823XmV6uYvhOn8NFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVWPR04MB10076

Looks good to me,

Reviewd-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

