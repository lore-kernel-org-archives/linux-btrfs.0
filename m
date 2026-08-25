Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4E73EFFD7
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 10:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787652160; cv=fail; b=kus0UBSnAVYo2sNOBngKxDxYrePMNGv62ziaW7VCgJyg+QEwRVNfW6Btl1Ie+Y482P/w/hB5dK4uzhqcJoXTRanj7FVtj4vgy8aU6fyp6i11GO4i9ynKE2/QQ5wiONwazFBjeF1m60FoJFGv5VLY5dVjFjWCuKp6knkp31CKOMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787652160; c=relaxed/simple;
	bh=FAhEuT3ebYJLgii66Bb/8vNwI+ejVI9to6OtxW/qPeQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X6/o3ymxmko0jmP5HABczSRX0m3hRy+iCGGaHzZHhVJJTYa8C/Y/necozIC/Zv4Z4EolKs+zF2uYesDomZFINO2kiYJsRvcs7GFLdmAEJQbEjO2157FXmXjkA2qoWV/scdwkp7PEkBAAPFb3zQA5kChsPQGXHDckiUsQpKcqYcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lDqce8tK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=kDit73tW; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lDqce8tK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kDit73tW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787652158; x=1819188158;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FAhEuT3ebYJLgii66Bb/8vNwI+ejVI9to6OtxW/qPeQ=;
  b=lDqce8tKibLRjMCerHdd3RzhFo5IGktoQPXUTn2XkShSX4BWuthrPYNV
   olw2H9EH0hIqSnq7i/80Yl1VWWtV+paFMGp/jk6P5TtVpjVTKSM5zrVzT
   jlMd9tlMm2SWuUnpMkRJtMXJGbQdSCu+/CX7IW/9iGqoxiJUHlaa6OXCA
   S7NDW3UhIxQym8MoLJ15bMH31RazV51KizW0/7hmGw6EKSyBqU+/C6Me3
   stkDnxfOUbfRQ8Bf4nUdatdCpGsCi6uJgNmxbar/sU1UWUJ/hyzYStv1t
   RKwHUYSDhuaHmpItp92sD3tR2+CQsDwV+JqWNDYjWjzHzhn5Riz8/afr/
   A==;
X-CSE-ConnectionGUID: aQH5kHaQTParRIGWVptqYA==
X-CSE-MsgGUID: EVegGy9TQcKGUnoBMHVKnQ==
X-IronPort-AV: E=Sophos;i="6.25,242,1779120000"; 
   d="scan'208";a="155135033"
Received: from mail-eastus2azon11010033.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2026 18:02:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aaLJxrTC746negYFBqTHHMwiMBWnrAG0hhW3VGuxznfl3C2QUI1Bc7+OXYU2si/6r6zdPbucviHYEVp50uekZSiHIBn5jWtT7WLRK5MSR3TKi5HnDM+67Ov7gN44c4ySs+dSR18ByDveRzuSaSgyMV6oZWEvom41oy2IicP5vRO5Zt9ihsDkDD/p0aYmLnYPfiicv/jMA9aH8Hhasmta4uuWkM6uB7UgtwEEizKbfqsWZKWjTBx9O5c7BTJiRWNCqRVEt+ss7nBF75Pl8kYM4RqTtNE1kgmH9CeUO66GvLrbmlu88RW083w+JOyRtdH+zX2/gP0AEQO4FhGI6MeMLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUQBWoOw6hoq3HUY100no4T1q7vXGugKHHp7HutNRpg=;
 b=fHQqqyvWPaKz/EVUYX6iEOylSfD3lzGES4IwMn3hDvkb6pQDm9SMIVwzHihUWGuVPvTqY7GHzwoO80BNMxPTBh9Tgo5YvyewDen908IWtAz5QQiJ5qn7eFCJeZkYMsucoBk96kSq1ilr4A3psk7xXBqdFwKz/uA7jz1tDc5+6idEnkqe93poaHkn0ClGmGhglgLBkYiVebA9n2Wz0sPo+pTsGHYd0kSiP6ob/ECx3mwlvG+F18BjumNWcPKea/CzMZcqtuxOP6PNhZbv7pw7iSj9pn9Unk4NsDBFA7cEYMeWF7gWy853QPx6/uuB4wGfzMj2clPkihj8uXScJgbI7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUQBWoOw6hoq3HUY100no4T1q7vXGugKHHp7HutNRpg=;
 b=kDit73tWztBkptU5I0dTog2rgQvWuIm92Ga7IOVlw0TK0XPF6DpoQJ5B8P1BxleqbeBYax/rI+YP2FT0dl3TXJh4vON7KLZvxMLkoGOnGROsox7Wy20g1DB87YCZezyytHMFRugZgZz8Cm1q1IuxqWnMOyo15K3x31R5Wz96qns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7543.namprd04.prod.outlook.com (2603:10b6:510:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 10:02:17 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.005; Tue, 25 Aug 2026
 10:02:17 +0000
Message-ID: <51e1abac-79c9-4543-abb8-c710f739819f@wdc.com>
Date: Tue, 25 Aug 2026 12:02:09 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] btrfs: zoned: recover active non-data block group
 roles on mount
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com
References: <cover.1787551793.git.zhudongjiang@fygo.io>
 <8956aae5225383d3c9ec3b08a3a9d42da1396eb2.1787551793.git.zhudongjiang@fygo.io>
 <aoxPwPbpoad66hrG@mayhem.fritz.box>
 <810f5525-58c7-4cfb-ae3c-c7e4e0ed0f2b@fygo.io>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <810f5525-58c7-4cfb-ae3c-c7e4e0ed0f2b@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7543:EE_
X-MS-Office365-Filtering-Correlation-Id: e0462687-5eb5-403f-1a83-08df028ff216
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|376014|366016|1800799024|10067099003|6133799003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Q8jReqWP1DBEk1nijQg9Y6jZxHJ09Herig4Kl9uTC1194zkmd/CKj8DVVjaaMqI5eacIBgWWkZWiB4Qnlny8bbo6poj5qPy8zAqBbI7K/A9gp0kbYAuclhL7oqh9WompM7HhxoKAT/9RFeJhSqXUhK3JmHTTH4nzm/bSb/Nm2mpo3zoPhMUBekervDW2B2MdPZ0Mt4bztZBkWtDw9E6aFcprnxFlMRSgP2YbzYe1CnceIhkF/q524vvdt4fS+QnVBvmISn/xxUMl8wDHR73c2TPty1GtnFRla0LGQ+T3XvgOOw/EWMjaqSK0gRetcom1mh3zXIHcrBlglXra1QQ0lveO5t2sKSIUcnluctIco71bCE8+PDRK/jD8M281o58fM1LmCwHIkzo8gHLbb38yH7haheoF2QuzvlprYX9yOhBQIDM9XC2DFTeZ25mohL91gqi3We9H5tgXQNnil1yE+XT6zm5zn4T/vMkMggmJsXi0gZHU5Qu8xkBk+FKpngS4xBTe9/8eKSKJdeuv/I8s/ta5rZSjrZzageRNleCihFdMhBqdCiXOqrX6SsZojOyGypyjal/dAT09wrO/tymO1HLaJ3n8GTW+n5d0Mk7MTPHS9l1rXBHoQjU/W8lZLfMIOo+OnxD51k6TrUauN7I5OIzFwk2R+vTiMiKpAUvnFKE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(366016)(1800799024)(10067099003)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azNqNFpFamcyWHM0MERiMytRSitGVllLMnRMT2tHWGFlcHBGNVVHdEZtc05t?=
 =?utf-8?B?azVGZDdaWUhZa1hIVkNTZDV4WVFhOGtqaWd3bnpkTGlrU1BiaVRHdXVnRG1V?=
 =?utf-8?B?eTF5cmZXZTJMMkpVMVJWRnhqY3N3Yy85M0JEakJvYWRjdFd3WjJMY2pPZyt0?=
 =?utf-8?B?NmgzZGtKN0J4TjJpODlRYVQ5Q3ltZTZDalVYS0hqVUk3MjNJQmNLdlBSSjRw?=
 =?utf-8?B?YWZuZDhKUGhJcGdFbnpLekpNVFNaNkZpbCt4RFg5WXYzblR1N0VpVEN3NUpz?=
 =?utf-8?B?Rmlya2xqdjNxbG5nQUxNRDFJVUpQaHl6OXF3SHk0NXBDS0RLU0JvSEtKN25B?=
 =?utf-8?B?ZnowTXNKNnhsYllxM3pzSldGMXdTRHYvNmtyUWM4Y3AxSER0K0JLaDB2Ym0z?=
 =?utf-8?B?TVI2dWQ0eVNoVDY2MXVxN3pyY2tzdlV2b2FYQXhReTkzRDgwYlJCWWdJYUxS?=
 =?utf-8?B?emFxaVl2OUhIb3pjLy83TVE0NFRyNGtZa3g0ZlR5bGs4QVNlZUh6VU9DWHVj?=
 =?utf-8?B?RGtJanhmN25YaGN5aGhwKzRoNjZVcTFhZWFyRFlSd0FISWlTclRkbjI3YnVP?=
 =?utf-8?B?UmNWVHhFMlloaVNPZzg0UzRyT1NRN2owbEhRNTkzVFZFMENMWko5elJRRFlu?=
 =?utf-8?B?OXhTZU9Ea3kzQm5JZXExenpzYWhhWDBWdCtDR1hXS3FoM2lvUGFQMGFmSXcx?=
 =?utf-8?B?Q3EzK3RTaGkrM2xhMzBmRlorQkxST1JKN2JvcjNtQlg4ZmpFQnBXVlpWT0tG?=
 =?utf-8?B?Zy9lcmRHeVFzRVEybWRsbXFRMDZNZ0x4RUhuWHc2SGV0dzQzdFhScUF6SDhn?=
 =?utf-8?B?QnpCMmtKb0gwREhMQUVHb21PNFMrVFllWlJDakVabElDYkF1QzBqZ1l2cEc1?=
 =?utf-8?B?VStCNXJBcytXNHhhTURTaTVnQXl2cUQ4WEhwcG5YTkhUbmtEZnAzSlNnOU5t?=
 =?utf-8?B?STBqQzZHU29uL3ArTCs2SGtsNlIrZlBmak1hck8raWQ3U0pkdDFEMU9nMFhB?=
 =?utf-8?B?Vm5MVFJWTjR3N3VMT01IajI3NENrZlZ5a29hNUpKTjd6bm83SElrNzN6Mm5l?=
 =?utf-8?B?Tlk1bUxsWUdUM3FrdjdwalFiNzZqL25IZ282UjV2Tm8wZ0s2bEl2Z0RnVWti?=
 =?utf-8?B?L0x2K0VsWW9rc2hoQnZKQVdJTnIzME1Vck4rVDRaZlM5TkFsN3NZQUJxQ2hT?=
 =?utf-8?B?NFV1UU8vR3puN1k0U1lFWk5ISzcyL3pKYi9qcDUzSElINnpIc0hqTjlhd0dZ?=
 =?utf-8?B?T25lRnA1UGxqblcxZlVSMys5Uk9IVjN0VXBnUXgzUnUzeis2TDVzb1VmdlVa?=
 =?utf-8?B?UHplZ0RZb3JKWk42VGtBeEcxckpha2N5TWV3MFE5M3NXU2xqZVlZZTVUUWhn?=
 =?utf-8?B?QS9LZUx2am9VMDhpRkk1QjNYbUladzV4R3U1cFkxb2JiVHlyM21HakxqZWlz?=
 =?utf-8?B?Y2tzRHhEdC9iU0xYVkxrR1VjS3J5Z3JEZ1lhUHp4NTYwMGJ3azF0RXJ0L29Y?=
 =?utf-8?B?b1pxaDdYVnpLYWVUNndKZVlqWVdHRGtYZXI2MWlSZ1JhaVNiK2xBWTRmQk4r?=
 =?utf-8?B?OTZNbklwY2ZCcGlhK240elpXWW5GbDdmQ2RqdDlNZnN6UHljNEhJakRBNkha?=
 =?utf-8?B?dWtjN3NpQzkyLzl5V1BycFJBT05PeWJNRlRhRlRhV1F5Zk9WY2FTd0p4RUZI?=
 =?utf-8?B?ZlpwamR5NFJqSVRmY1FnaFNWcVo4ck1FNFdJR0svYmo5cWpyc052Y001SDBK?=
 =?utf-8?B?T2I1NVFnVVJnM1dsbmpleVBvUHB2SnUxUE55aEZGR1RZaDRSNTZvS1FLY3NE?=
 =?utf-8?B?ZVcxTVg5Y25HNk9lcWVjdktVRWpJQ1RTTTJnT3Z6anEzTVRSM2g1Nm1xbFgw?=
 =?utf-8?B?SGtHZXlnR1VPTGs3ME1wYkRGY2kzdS9QTHZpa3I5OFYzMTJkK2c1YklOcUhv?=
 =?utf-8?B?RklzR21aK3J5dThlNEQ1aGlhRTEweVZHT2VFc2ZLRG9ERk9kcDRFckVVUTZX?=
 =?utf-8?B?bktQQmovcEZ0ZUxEYW5GY0pLeTlGcVYyN09OYldDUnFqV28wejVuYVY1bWIr?=
 =?utf-8?B?NDN4Q3NZNHdIUEpNT0tuNkdLc3ovUzZGTWFuY0wydENWNHFVUWtYWXcyYy8y?=
 =?utf-8?B?RjFzSURVZndaU1dSRE5LUnB1b3p5cmhpYUdLbUtCOHEzWUJuS3lpSGtSVE42?=
 =?utf-8?B?L2s2bWVCZnhDRjFaZXBiQnJ6Zm1aYXd1Sy9vNVVvai9TWXE3eUlWeGVQZzdU?=
 =?utf-8?B?a1cvTkl2dWRtVUVwcmJ6aHNVTW81SFlRMWZrR1Q4Y2tZaUJ3ZitlSnJDdDdi?=
 =?utf-8?B?ZFJaeG5PdjdYUVlYM01LNFRsbWpFQ09kQlIvNTBETUZjUWlQUWZhVjBnZ2k2?=
 =?utf-8?Q?2Lf/vkv4poC+nOjY=3D?=
X-Exchange-RoutingPolicyChecked:
	0sQq+ZSPROgg1UYwfSlgnZJNGCGR6gaHJ0tT/lyBPA/DLpyd/T5E0KPfeC1yzMVvH9u9XUezi+CklGubknOxw+1JcBC2mXaVJhFtIDcyOKrrzEQiQD3Ya91gtRakpa9bRPRIs+yih2koI2WY4AsCA9PDY5idQk4ehJ/1hZIQdpdAvK5K197oh7tUafZVmvv7sh4+h+tUI0cAhycUCOet/MoqDwmmfyIMCzm9do6FytYR9WEMAnEDSFedYGSox/6i0P1rCkirxW3jf/D2wfkyy/CsASrN+lmeQNRL/JNLnDq+HEujQq7XmCEIB7NcJaj1AUI33Sry2kcNVYwVGMd+Sw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wFo/eQaecPFG3pobsoPcJ0XQMoM2vbDsmLszd23X6UxAgPodz5ScKLH3wGkVmACFkplIVwmU4Rpo2K2/i4LgFJ9hVDhhclNjmF0BjM9gT9I6xDWXpU4hs/dxzxOll0oGT28J1qR5lK9PtuROii6Evp8kxOon/5A4HOW7ErzRossh8uBQNV9t4nYgkGUbpaPW/5/UPBzmlnep5lLCb1MPnMUKwkwy/L/nrnm05FprXLPkpy4zt/aK6y8e775qqWhUrfbjXsVKdGufM8kFv/MCkcrY2TfqjxIXqUPXSA2AKJe7kQhSp/tKKloUfOQ9IixOgHaDZRHBREUVp4WRyoWJnltld3xaRgXwTqkgG6RvIwmg5389i1wzNr6pUaxViZd/9OCxiwsreUqHWii2m3ihU4HvfdnNVlGxf616CEDpqxPXKSkFHMBwyNNWXg+PIpIyxgf6YSh23rTMejfc1SyZMjbxHB6aWEL8IxRIIGOv5LoaP9s6kKC2oVFDqRdEl2l8oF3s0XKU7BI3ObF0PQt2Zzyt2Hy6CSpCQuaKG/2lmYeOBSuNQoADcXjiAcyx3xDArRF8pBrUreGqQIqJxCNGM4zIwb+kgs109WKZbDDAyZ0zGiO2FQmtJB7cbhHRfDSr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0462687-5eb5-403f-1a83-08df028ff216
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 10:02:17.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LEF+EIXYPEh6YcFWWjh2JQzFwbJdr4RZz2NqqjT73WuDtUDpl0B9dm0HupqUa/PpF2Lp7ZZm7ov0kUJU9zCcZli3uC5rzfOPcBV/uwAYrTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7543

On 8/25/26 5:08 AM, Dongjiang Zhu wrote:
> 在 2026/8/24 22:42, Johannes Thumshirn 写道:
>> Can you submit a fstest for that please? Maybe even in generic/ so XFS and
>> F2FS also get coverage?
>>
> Yes, I can work on a separate fstest. To make sure I understand the
> suggestion correctly, do you have in mind a zoned-device test that
> creates a metadata-heavy workload, syncs, fully unmounts and mounts the
> filesystem repeatedly, and then verifies that further writes and syncs
> still succeed?

Yep.


>>>    
>>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>>> index bd079d3b31ba..7d91c074a24a 100644
>>> --- a/fs/btrfs/zoned.c
>>> +++ b/fs/btrfs/zoned.c
>>> @@ -3050,22 +3050,73 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
>>>    	return 0;
>>>    }
>>>    
>>> +static int finish_extra_active_nondata_bgs(struct btrfs_fs_info *fs_info)
>>> +{
>>> +	struct btrfs_block_group *block_group;
>>> +	struct btrfs_block_group *next;
>>> +	u64 tail_unusable;
>>> +	int ret;
>>> +
>>> +	list_for_each_entry_safe(block_group, next, &fs_info->zone_active_bgs,
>>> +				 active_bg_list) {
>>> +		if (!(block_group->flags &
>>> +		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
>>> +			continue;
>>> +
>>> +		if (block_group == fs_info->active_meta_bg ||
>>> +		    block_group == fs_info->active_system_bg)
>>> +			continue;
>>> +
>>> +		btrfs_get_block_group(block_group);
>>> +		tail_unusable = block_group->zone_capacity - block_group->alloc_offset;
>> Shouldn't these be accessed under the block_group->lock?
>>
>> [...]
>>
>> Same here, don't you need the block_group->lock?
> Both accesses only happen during open_ctree(), after all block groups
> have been loaded and before the background threads are started. Following
> other mount-time initialization code, I assumed that block_group->lock
> was not necessary because the allocation state cannot change concurrently.
>
> On the other hand, taking the lock would make the usual protection of
> alloc_offset explicit and avoid relying on the mount-time context for
> future maintenance. Would you prefer that I add the locking around both
> reads in v2?


Yes please.

