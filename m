Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD56B3955F9;
	Mon, 13 Jul 2026 07:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783929325; cv=fail; b=ZalV1IYXocmzDxcM2HqIspPPG2arj7AqV6MFRQdnZMlCqFYuvMKXWHVQOr7Vmz9HeNnFPWtza51rXXL6MVSQDK/ilaFem7VQ+8Od6pOj8W41ewXYOg8QVl9CSUnMh4jgLuDk2fCCxySw1o5ibQbK6+cgR2TebPysXiPayx9cBI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783929325; c=relaxed/simple;
	bh=69T2IhxVtz5AY0sVEPwO0W+QOr0tAHVxdlDQ5zIgtj4=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=iMM75jgKQ1BknTAjQIIOzM0ZuVxqozDrxQ5NDBxg5zxklcxagv429JrW1uCrgfEcjM/ELOklXdr5RP9UM4cayhUusYLN9qG6a30xi2mjRo3dOgbFExreKaqqjrzh9NQLhxwOKJ0+Bq1Sf52pERyK9oBzs5e7wqyHADteaJyKNeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Q8fAl+5d; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=R62f0D7J; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q8fAl+5d";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="R62f0D7J"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783929323; x=1815465323;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=69T2IhxVtz5AY0sVEPwO0W+QOr0tAHVxdlDQ5zIgtj4=;
  b=Q8fAl+5dnv4Rjyamn3PtQodWRJaWzRWZKt0xasSg3jEjHJ/5t8XoT2nX
   0t/K+11MqYLqw/KOuZmAbDcMTsAi6j5riIivFriSSv/eVU258jozMarvL
   UghpWpA2i2B/k1137MZxRfj5H9ATRYku0T7yqhG3l70t4YWduuk7e8BUe
   B7Zs4AX10Uo+ek1eef2rQqANl+K2oFAt5HGuUIVKAGkaorYDLuRO82xiw
   YWtf4iIIbRPiPBE2c398ln97VCvDIAPK+rhHJJxKYjpPnaK4skC6xtmwF
   eKrrbTDTsSQPB63CT1YR5EefunZ3pJAUTMJvDHH4xJgpB8TDtBuB2uFPw
   A==;
X-CSE-ConnectionGUID: 8RXdZcppS7W+XEf9+5FsRg==
X-CSE-MsgGUID: Is8I1d0PSfyw2t06LlfJ0g==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="149375566"
Received: from mail-southcentralusazon11011054.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2026 15:55:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVOCL9Q4PiK8xgr3kCE0pv8AbQ3wdUoy01CPNsxRekMOMearcLHom6SMF2PnLsW3Ibqf8cCa2UTYGKOIv93qIHcBwsOfoErTJBpNANTLFYr/R4glZigJnosSFJSQJlYBHwbT8KfXa0i8ge32ysHLOJY8mD6yy2SLr7xJ6e3qsfGp2iATYzIEYrBrNa+IV2xSxhHVIS5lnrqqRzTybFKdEWkGCL+HMzbiSW159HTO//KNb1ERGohIpWhmDZLN5VWVYmVdaj04Um94/erI4UK3vApEGdaSCpxui5xvMVH6DJpy3cGcSfIWmU86ZQXj27ptJPQIQ4O278Tbb/d+0V8xqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5IFBOorN9cWgfBD+h2XsIlRI+soeficqjDALqlksEU=;
 b=OUyMh2awHwDzp7GVmfCLtG7KLu1ktpc455IQgybAUNt8KVCZrzrfdvekOTwLmRGgKwGP7hgwSngVrw4lSikn7cvYgIUYOwT2dUQKjoENmX7VTzbiOBLd9bgztV9X7heyQ6WI/5Ta2XHVgaPUM7oNHkFND90DXBc3ifaSJuFV+4Xa/0P2EsXXlBRZYZyVk7hHk61cMEVR9In6Q2peNfFVRuNBmXu1Ff/r2F7/aqL9y2dSfgFRU/vYc77tsRzrv3ubaRIso17Nd21pHP4sM/6Lq36NhAHQjfGjwHbuyIU8jmT3rc8dy+qiBfQieZ7bnlYO7t6jGfMbeDxJpUidgDgS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5IFBOorN9cWgfBD+h2XsIlRI+soeficqjDALqlksEU=;
 b=R62f0D7JeDm5U+yIIzJHF9UpPlxdXQx2vgYt6i5/MjlzFZEs91TiEuZB0/oekVBfQZUUwJ+nyIWUm3PA/Jf3dHHVDEXtM1paaMkb7ZxX80YUyjS0CfG6xW0dPjMP6VMVLWVkpsrw2x2/V4GR/IoCO3fae8YmFSyL9H7wm7zwS0A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by BN0PR04MB7919.namprd04.prod.outlook.com (2603:10b6:408:152::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Mon, 13 Jul
 2026 07:55:15 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0181.016; Mon, 13 Jul 2026
 07:55:15 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 16:55:11 +0900
Message-Id: <DJXA5VV29ZVI.BNMG6SJ4KJNE@wdc.com>
Subject: Re: [PATCH] btrfs: zoned: fix deadlock between metadata writeback
 and transaction commit
Cc: "Naohiro Aota" <naohiro.aota@wdc.com>, <stable@vger.kernel.org>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260703055440.117200-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260703055440.117200-1-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TYCP286CA0367.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:79::14) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|BN0PR04MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: be91e692-8062-4e04-8db6-08dee0b41348
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|19092799006|1800799024|376014|10070799003|22082099003|18002099003|6133799003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	5M0AGjsUpU94LcV0xlhu3Tc3cUUEWx89nPqfE/0lBKGYJlV+UiuyLCDBNPM0O/wsRAOIQdApik+n+B/cm3jZPKrwJYYjeBUmeGIVEsh/5Jjuj9XV7qDwSRTM+nFBXdPoxNCcFI8VIp+bjNFPHQvFHn4NzUEF5YNZFvw1EEzU5b9MLlDVnSdZ/ID9D7teT1O7lBW/qsy+GROlcupYrc5bksfGzUPiw9Q2aA02tr4GBaFbXDCvVPBiHXhc5Z6rgxP/143J15E/ra8UEFG7jQNZIKB9db0c9kEmUh9MJJ/+Wp0k1LoqddvHcjSCfq3Ou+lSRlZoz7VL/L3z6VXiodiOHT36+s5vL0qAk/bn6CyZfQWkoQRsryhN7aMfCaMX6lkV6AUFDrED1IX/YDpOfLurahDQUoBBZCMpWSLNJ6dAK+HL4JSHJxPO+ZeASrARmKcMEDgRjlPYjZQy7nxXJDfetTOfYxz6utNhv7AzZUuyPV1zKeM7F97zmcbG2ro4kXMUlNWNSQX7PAlKIr8n9z6hmtiKNaV67REdCgd+ifpkU1Rmp9jYhFRTFGRWHvv7wdIZAduKPb5uBjAuwBHSz9pvxq7MR86Xa2tnm37j0WBP1aB46ukYGI6X8lsFVffq3Tdx/buJWwqsfde+AAzLgKqzddS7gCJNjBcLlv2oMJ3bJXc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(19092799006)(1800799024)(376014)(10070799003)(22082099003)(18002099003)(6133799003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2Y5S09PUW9RUTg5UExUTGY1QjIzakw1Wnp4V1lXSFB1bnhZUy9hTVIxTnhH?=
 =?utf-8?B?VVlmMHByOHBlWlBqckxPc0FOdHl2SGZEdVE2dHpKU21yMnVLdEVleDY1cC9a?=
 =?utf-8?B?bDFlSDIyNFA5S0NqY0VpMnhGNDhQSlhhcUlQTXRNOTN3Vk12YWtoRW1DNkND?=
 =?utf-8?B?SGRhcE5iR1g2SzZmYkNhQ1cxazUvT0JyQ2FoSXQrczVRMC85L0ZoclRvM252?=
 =?utf-8?B?Rm14MktkVVpQSEFMVzMwVUhlODNHd3hUMlg3b05vdHN4MkZ0aXZpVHlEaEV1?=
 =?utf-8?B?T2p3dGQ3SGZjNldCUDh6dVd4emtqNmpKN0l2c2Z3WjErYTczcFRmd2dldk9o?=
 =?utf-8?B?YXlPeVhqenpQUThUV2ZFeHNaMWNrUDN4Mml3a3MydWdhQ0dxQUJPN1JlcG9T?=
 =?utf-8?B?YVd6NjdwUkVEeWFONnE4S28zNWQyd1c5S0YvYnJITllZMXpiTXFpS1JOVU0w?=
 =?utf-8?B?QkhMMHRjdFA1Qy82bkZmN3pWTG8wRStoR1ZQaDFNRzFieldnbS8wUm1mWURy?=
 =?utf-8?B?ditIK3U1WG9RODlUWHl6WVJPaGxkNUl6Sllxc2JWZUNDZWZ5NEV3eXMyTnhv?=
 =?utf-8?B?VnorVXMyejlsZ05ZdlBuQnRoeHhvZmZZYmwzTDFSTmtoVGQ2Q3YvMXVZZWlM?=
 =?utf-8?B?UDV4c3ZlSUpGb3FpUEhMVUdoTjZyZkxBeExCbjBWVzNUdXFJTUtOMldWbzkw?=
 =?utf-8?B?dnhBQlRMZjBHTnptRjdRek1jSkRSVkxXdEhOczV2YjQ2NHROenhvcXI5UjlU?=
 =?utf-8?B?NWg1M210SmJYNUpNNWhkOUN5Z0M1VW1rV1V1Ly9JMThManZINjNNTEhraG8z?=
 =?utf-8?B?blNkSHdTYi9kaVdzZlZ1dUlnMDRIR3ZTWUx4MGdyejlra3RmL3NNeXN1Yjhz?=
 =?utf-8?B?c0xnYk0xblBNL0hyYmVGZzJOTnRiYy9MWGVIbld2cnN5MTF0azIvU1lXZ1gz?=
 =?utf-8?B?MEZyNldGVlFNOVJvZ21zT0lxVHNDVGxnd1YwaWdDU1d2c1NOTDRQUGlDWWx4?=
 =?utf-8?B?NWFFcEp4VEpWRnRvRno4SGdCTTZ5Y2VKUTRreEZxS0FKb1JnSmdRTno4b2xV?=
 =?utf-8?B?bnFHdVJGTDE5ZzBrZGpXYkZrZ1pJRWRpYlEvVVV5MWtXaHZySnJQSnRtV3Vs?=
 =?utf-8?B?M29HRmQxUDI3K2toTW5mOGVJa3ZHK2ZhK0k3KzdtVmQzbUVKdDRpd2NkRk9i?=
 =?utf-8?B?TUlrYUhLeUN0SjlyUmR6STdTRlNwWkZQKzNCNDFPWG04SlZLNE8waWxzVXkr?=
 =?utf-8?B?dkxkMmRBNlF6ekp1bWozQmtHeTFydGQwNVVuYy8rY2N4NGtSZ1ZjQ0lDNll2?=
 =?utf-8?B?bi9zc21ONVV5VmozT3plN2hrdWZJTjlmc3FxYkMxaCtreUd3VVF2bDVzSklQ?=
 =?utf-8?B?QVVRZDdYMGtPcThmTlJtbzRuWHJrT2VOQkM4MENla0ZhbzVjMTRZMmhweTk4?=
 =?utf-8?B?MXdXVHJyWFdxdnNkaVEwT1lSeWNuK1lTUkd5VTdaQzYwZ25Bb3JjOFVUT1lR?=
 =?utf-8?B?VkJGOXJDMU5qeEZGNTVXM2UyZWxTYTB4Qk05aWZnUWV0NEl0RlZ5cVZvL1BH?=
 =?utf-8?B?T1YxdjBwUFo4bE9BWUxIOUd2eitTQlpwdW5WOWN3bDVncGdiaGU1enkzRExG?=
 =?utf-8?B?UXMwT3Z5UDAzRjRMWXZLMW9iM21lQVJ1eE5DYThmZ2tyRW1XQTFiOStaaFpN?=
 =?utf-8?B?YVZkYU5TeG50VlBHekVsVkJPRXFMMDhXd3NQZTUwWTFCb0tYTm1zQmVOenYz?=
 =?utf-8?B?b2hOeHpKamYwZzU3cWJqSEdmamRDMlRtMk5hSG1Kbm9UbDRhelJ0alVZZDMx?=
 =?utf-8?B?dDBGQVFSSWl3RVRocDd1SzFNUHRoa1RZTjh6SFE1VWZoS1YyT2dDbGpiSDlt?=
 =?utf-8?B?RllVRk1SWmsvdmUxOHFsMzhMWkhNejNzUzJPMzlBR1dGYWQ3eVl6RWUvTmJE?=
 =?utf-8?B?MkZoT2JzU3dKbFhVK2plZm1ENzJMOVpPem16aURuZnhPMzJsVlFJb2pHb2Y4?=
 =?utf-8?B?bzY4R0xGR1MvalQ5M014U3hLcTF2VDFQSDFUR0Z5ZGVSZm9pUkxPd0t3TlBX?=
 =?utf-8?B?K2FnRjJKUE5iQU9Fc09KY0xuZlE0SGlJVkZzTzNVaUFmMGtYYWY5VzJDa3B1?=
 =?utf-8?B?V0RveTJybmhWV2dET0pLZkd1M1FFRWFjUnNUVDBCNW84MWM1Tkc3OGg4bzAr?=
 =?utf-8?B?bXRsTzNZek1yMVI4ZXBuUFpEL1VQU0NuaFVQWXBaWXpSMUMzTDM4Smhvay81?=
 =?utf-8?B?MEtaenUzalAzN3VhTU5Ca2gyMWFVV3Q2N3VZR1RRVzVmMEVRelVKTDcxMVJu?=
 =?utf-8?B?cjVORStGMm1yaWlXek9xRU1HaXU3b0Nqc0J2dEIrTlhRUGp4NFFFQnhVVEhQ?=
 =?utf-8?Q?j5XVa5WETvc3Kzd5KLKiGHAueafn05jZFyIghdd1f+Yak?=
X-MS-Exchange-AntiSpam-MessageData-1: btJcHhr8y9VgVg==
X-Exchange-RoutingPolicyChecked:
	gvpb5VAo2o9LfJGwa4fL6EK0z2xWZb1z5YvLDVzX/+WwQwBH2YYnArtepwMSj6qOpyE/F1sbYny3IbxnLX9nDfvIdsveEkomqBJsddm5Tc3M9lCZYW+bXDadPeSwfVmhJ+C9DRMowXwsY65Z7JvwspHHVjj3o9nLth51Fu2U0Pff3S7zsbvlbU25J4IYqijjBBNhgtu4I4jcjLfUD1Urz6O+6zZcGQqfiCJci9ChEobjzIoiahQUDihazXFbHaH+MS6OUDPL+AxU+Ct/ZRFH0tDOeSDOSA5s2uV/+8lLac2FnJKmmFqjnLuP5EB63zRbvHGHlwFH/Q/L1SzY8QLtIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vIqmvXo/WK98X3fmPRsZ16jo1GSpLev7SYx7Z8VqasYNs4UAF9LqN0vW9zXwguHPshcvVB01b1oK/cDPfdvXfL64sR9y0LjB95WzLpAr5b13pyjwa38Jke25vYeTQXCVgUMb9+gM/uXCmt2kZciRpaUt0YMIY0hscYaYcPs4+x1MAgUKyr7YBN31ndrS4kfPtoBtxV6y+n6ZTOZks/vZx8JrH7CdHWfSRJdPmrqevpIjtGInbw8SG27EUNLGYChWVcqB2LUfwlvqcXYv2blsJ/B2jirtTpXMa3yjxHLgL6+DWNrfbnNtBOKsI9mG0ovCvJOjspENiwdMX1YnOG3O2R563pkZ7Ee1qF2Yslo0D3dsll5JkbocKMpyIsXZ2yWhx6NEWpKXAzNAn00mUCvledXgM6wo1fDrolGdqaMkd1As2A6Oq+24SVNe5c6QqvABcnmcxzwMm9fvESyAq7NI2apgl0aRCiG6q2i2B+dVczSq9ZQmgVXe7t1pfbvOma8vIK7sQILOXryqbTKm3/0rKkAwFQ460o2yi1qutw9IIPRPRWmgcb0PXBmdJG0Lo4mfl7Usda2AsUYAfCbW5HspjlWt8TckG4r7y/u94AibQUZjBsFwnYbCgw9MRHHUvwyP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be91e692-8062-4e04-8db6-08dee0b41348
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 07:55:15.6949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZFPK+ctyFdqklquqqEqqnZp5y5q4l5JMDAxtEMNyM4YaFD4kSDfqKe4tuJ7Ja9TvDHcrXAydPGxTVDIHLncBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB7919

On Fri Jul 3, 2026 at 2:54 PM JST, Johannes Thumshirn wrote:
> When writing out metadata extent buffers in a zoned filesystem,
> btree_writepages() holds fs_info->zoned_meta_io_lock across the whole
> writeback loop, including the call to btrfs_check_meta_write_pointer() ->
> check_bg_is_active().
>
> For the tree-log block group, check_bg_is_active() may fail to activate
> the zone and fall back to btrfs_zone_finish_one_bg() to free an active
> zone. That path waits for the running transaction to commit while still
> holding zoned_meta_io_lock, but the committer needs that same lock to
> write out the tree extents, so the two tasks deadlock:
>
>   Task A (kworker, metadata writeback)      Task B (fsstress, transaction=
 commit)
>   ------------------------------------      -----------------------------=
--------
>   wb_workfn()                               btrfs_commit_transaction(T)
>    btree_writepages()                        btrfs_write_and_wait_transac=
tion()
>     btrfs_zoned_meta_io_lock()                btrfs_write_marked_extents(=
)
>     btrfs_check_meta_write_pointer()           btree_writepages()
>      check_bg_is_active() [treelog_bg]          btrfs_zoned_meta_io_lock(=
)
>       btrfs_zone_finish_one_bg()               <blocks on zoned_meta_io_l=
ock,
>        btrfs_zone_finish()                      held by Task A>
>         do_zone_finish()
>          btrfs_inc_block_group_ro()
>           btrfs_wait_for_commit()
>            <blocks waiting for commit
>             of transaction T, done by
>             Task B>
>
> The sibling branch in check_bg_is_active() already drops zoned_meta_io_lo=
ck
> around do_zone_finish() for this exact reason. Do the same in the tree-lo=
g
> branch: release the lock around btrfs_zone_finish_one_bg() and re-acquire
> it afterwards. The lock only protects fs_info->active_{meta,system}_bg,
> which this branch does not touch, and ctx->zoned_bg keeps a reference to
> the block group across the unlock, so nothing is lost while the lock
> is dropped.
>
> This hang occasionally reproduces with fstests generic/475 on a zoned
> btrfs filesystem.

looks good,

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>

Note: I'm thinking to make treelog_bg reserved, and pivot like as
metadata block group. It will be more reliable and naturally aligned
with the metadata block group.

>
> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on writ=
e time")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 97f06dd01693..44a13ed6b8b2 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2190,7 +2190,11 @@ static bool check_bg_is_active(struct btrfs_eb_wri=
te_context *ctx,
> =20
>  	if (fs_info->treelog_bg =3D=3D block_group->start) {
>  		if (!btrfs_zone_activate(block_group)) {
> -			int ret_fin =3D btrfs_zone_finish_one_bg(fs_info);
> +			int ret_fin;
> +
> +			btrfs_zoned_meta_io_unlock(fs_info);
> +			ret_fin =3D btrfs_zone_finish_one_bg(fs_info);
> +			btrfs_zoned_meta_io_lock(fs_info);
> =20
>  			if (ret_fin !=3D 1 || !btrfs_zone_activate(block_group))
>  				return false;

