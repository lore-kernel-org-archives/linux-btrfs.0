Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5964052CD
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 08:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787128469; cv=fail; b=Hv21CZPPPtNTdF8K+gFoi1YMz9s+/q2ql4hfinUU7R5YxML0PzBRZJWNt37kommnz1EWE0GrGfRltv1P9DK6E1PofIu+09BB7I5fT4vZPDaP5GUT+CumTwIA8ncbJ7HyScK7qdehXKQtPOZygtISWMRSGZT4rc/4KG+P5UWceww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787128469; c=relaxed/simple;
	bh=nX+6XytclJZ2B2wSIA+wIXixvo6ZFusc/Be09zjBSGQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=orjxpc1aXHzR/77rC6djrknf8NcY5YqOYm7gWASYK9bzosQiIJ0gj0gfVI03tj9yBHNHNB7NVtJOs+E0cq5THfsK4tODcvHZVRVxYP3PCR4uIbfTr4fcXrtroenKQ8ErK9wM7kT0DcSt+KYBF+C3foryoujjFDxp8Hg5fXwdLRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=N9GPcZfC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BUJQqp6m; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="N9GPcZfC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BUJQqp6m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787128468; x=1818664468;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nX+6XytclJZ2B2wSIA+wIXixvo6ZFusc/Be09zjBSGQ=;
  b=N9GPcZfCyeu5Y2cZdIlUswS1exbxJwF/dtdnBros7wjENvLZsNLHNjFj
   gHmLLeqjS8QT4EkuybkTU/vcrD0lcrmejcicVWb1+4cLV5mQuGreWi9hD
   t6rGcf0i0iVdwNcXlB1sgOWMLWf/mMT7bZ1DTulzevmP+ov95jt5OsNWf
   GlIyWDnFI/JO8U6GRxtdL71pxcbpt4BLD6rO3aeRbRkm16ocyWVtRGoup
   BsvBnVWX3iPyR9y2UfNaXUBnVLm9Tz73KD+/YQvVBokTOHaqXdInIvBA/
   PqUyvJHfFjRb84kHsXPwGWb86VK8cLTMoynp0DWkKLlna/80BO4O36oWs
   A==;
X-CSE-ConnectionGUID: abdVlopMSeGbGc9FsePi2Q==
X-CSE-MsgGUID: Uc6VFeDpTcq34QX65MGbWA==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="152261788"
Received: from mail-westcentralusazon11010063.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 16:34:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=alGlX4G8/yvCkyM4kzD/e8+ByzDaz0dEAGnl6HgQ+rE3BuvDekxNIdOn5gMQtd0Gl4THrMy73EfR1zaUy0D8tdY9hN3RYb6SDoDp0nD4uQbCvpfmuHHX9DHeckVhay6Z3UMdO2VSjKZlUkfmJe4cCKxjZWm0AmwYOgQ/lAKHBBgHhGqSB03jSY/seAvHdqsdc42Or4vJbAtDlzS7ICBsiLlVbhCRWmqhItJPSPqiVFAV4DCNQUoLoq39hhOXtTK90ZKnEExfYvmFhN4M45bExCcos7bbi2dpgDndOvRu7bfBixR7A3BOn1w9nvM4WrXu0VxJ7B2vlRzzS2kE2RPjOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88AH7HPUuccVU8KvMlZk6oVJ+K7Hc3uotycYVDZ5b/Q=;
 b=CQg8Tc+VyMf5cUcQ0Q3GRTD+bune+fLty41qu6RWTQbqF0foH1Z1bhrZd4kas7u+0s7p0QtYoihsq4newMtcvtqN/Q4vxqtxrcx7GjAjDXFo/dUKjZJ792qv3dZRNF7Zs/jIBScMW8knmxenC34uknY2XMtefQX+OZ0TvsjE33Vadz7ESKq5HZLE1CyzdzB2utlT841BN9gfDYF9bkNUly6wyDG9CqotfnJRn3D6EJHIn7/63qmF0RNlJovsAsm4OoRKTmWD8UeZuTv/BAazK+BSobO9g/UALLWUxsU9vTrdAZuX/SlCvUgqdEbtbg6hMD4LRyQyU5lWL6EcgO9xPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88AH7HPUuccVU8KvMlZk6oVJ+K7Hc3uotycYVDZ5b/Q=;
 b=BUJQqp6mZoTkEWOMjXJMxaXHIfVDw9mhRKjupal9hTOSB66BeXdK+OpcWEkRVxC5BhMBkXtKMhck0uCZi0gefqi6kqjQvB0i4d0HhZ259exm0F5sm+oSDJUMfklFvUHITyPLwlMFzrAnXSEbavCWO7KcXnGZWPp9tmAR3UoHxGo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB8712.namprd04.prod.outlook.com (2603:10b6:510:254::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 08:34:26 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 08:34:25 +0000
Message-ID: <a1e2bc7f-2b37-4dba-9355-616fcaa67de4@wdc.com>
Date: Wed, 19 Aug 2026 10:34:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: propagate do_zone_finish() error in
 btrfs_zone_finish_endio()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
References: <20260818100037.1366563-1-johannes.thumshirn@wdc.com>
 <c96becbd-1f39-486c-8474-7a854af73044@gmx.com>
 <d3ba712b-9403-4cd4-9c28-c3c6fba59c19@gmx.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <d3ba712b-9403-4cd4-9c28-c3c6fba59c19@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0398.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::16) To DS0PR04MB9439.namprd04.prod.outlook.com
 (2603:10b6:8:1fd::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB8712:EE_
X-MS-Office365-Filtering-Correlation-Id: dcdea8e0-72bf-4750-fdff-08defdccad12
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|10070799003|1800799024|366016|4143699003|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5nJ13y1by42fpjj307tYvKF1nhnqanTB2Vf0otOpt/JcVf4VBAQJfpJgDmDHBrfSzZbt1dZlkeQ47qao5QZKysgXvA93ftYkIKEh9b9PZ6w8eL4Xk4UnpVrAGBXnrEraDC/BfhngpcJTBuJtBJolA9b+aGeKkBHeWUNQ5xXTD1ojVVHy6k+s6uKYD46rucmeIAD4jfRMlWLk2pwybZ9Zv3ErtL3lLiJMYdfD15939V+4djiWavSwg+BQ3paLPphdo6QAEiWZWZBO2mEYMIREep6yeU2ckhXNPDZSWVmMCeW23z00xYy4BJlQxvNGXfZUTtZNIPncVFHw5+52uE4PA4MQ7NvaNKjCVnpDz00oS/+cdVmx7YT8nop/IFuUNmDDPqB4LJ/xWRbiPmQYOPVkjarOYu012aFvTuoFDHXrSS64/0TLPCd8zj9klMyesExgM57WRIHg6oNzfs20kFhBB+7CMAnqJIf/xhoFroigS4LJTy4cmAKiNS1/FR55YR8yCzt2RYcVfJFIm6Hfy3+UGpZo6+u67mzbEJAYCM91zQJDKB0b67axUqSVb+NM49Z8yg4BKRaAk3+pvSqW5Wxim+xg5WQM/DE4rIza5WsXWcc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(10070799003)(1800799024)(366016)(4143699003)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWZ4NUxvMEVQbWJxZ1B3UUQxaFBVSWZhMUU3NUkvSnJpVGtVbi9FcWhMQUVl?=
 =?utf-8?B?VDBHWVo4aEtpbS9qTktuODlqS01UQUtDVlNXekxmWldaL1VoeFFiYS9KK3hl?=
 =?utf-8?B?YlNhVE9GZXozTnhCNkNxOFdCSFR1MWJoYUlnOEgxMjBrbmMyS0pjUjR2RmRa?=
 =?utf-8?B?V2tKZWp2bStLbWNXRUpMeGhqNnRhTVhTbUo3eHpjYUMwRXNwZlV0bXdKZ3Jq?=
 =?utf-8?B?M2JRQUs3Qi9aKzZvOWs5SlNMU0Z6WmVkUW9qaFlZWTlvY01iWVA2Z1JDODha?=
 =?utf-8?B?aFowVzVhaVk4MG5FMjJMRnZMbUdyQ3JFVUpDYmpuU29nMVB4T2kwT3R5aW4x?=
 =?utf-8?B?TlZ3eFhjazMxYmx0enJoZVpVakZucm9vNmorRG5MaG1ZOTIzYVhUMnpPTm1I?=
 =?utf-8?B?bmhmSkFBZ0VKampoUWdPOG5qOFg0MWMvSXNkb0ttSlZ6OE10Nk9yUkZBYzJa?=
 =?utf-8?B?L1pQbjM0NS8vZ3NjdEgrQWw1cDlFREZGb2gzSm1TSFkvV1EwOTI5WS9NVmZ3?=
 =?utf-8?B?YWFXTTFTMWFoSjlvQ2JnR2JVTC9makhSdnVISHN5SXM4UXZmUmNHRGs3NWNF?=
 =?utf-8?B?UVN1V1hPejVIOWRISnhUQnoycm5BU0p3VXMwQ0xpZ2tTWk0xaHlSK2Zzd3BX?=
 =?utf-8?B?cDR5VXJVVm5vNVl3enVKVEJtM1orU3AweC9ZOWlCVUhjV1pXTXduT2xMNVBp?=
 =?utf-8?B?d05zMU1GU1llaVVheXFJaEJmT0JrejlOZ2NvZzJSeWZkNGhVN2p5bUl6U3F3?=
 =?utf-8?B?ODl3SU9SNnJHUWtHeC94L3N1Q1F4TGlGNnE5THFYS2tDcm5pT1Z5RVlLYjBW?=
 =?utf-8?B?eU0xSjBBYnExd3FDS29TNzd1b1pxYzR3N0wxRjJiZTZFMk93R0dTd2dnZStu?=
 =?utf-8?B?NmNHR1pUZE9zc2R0azE3SjBtNzVCSGF1VzQ4YUxwalFtUjg1OW9ZcUZCa3Bi?=
 =?utf-8?B?Mmd6L2JUUnBmN09zTE5ML0x5MklWRFVNUkc2dGl5VWEzd04yVjhkTDNib3JD?=
 =?utf-8?B?bDR6Z0hETC9jVHF5RzQremhZb2d2eEgyaTY3SHVBbUdZTW9za3NGSVVTRjkv?=
 =?utf-8?B?TUN5T3dLQXhlbEg5VVRQVlV6WUs4eWQ3bnNqbDBtdDFqYkJIVnJiVGQrenNH?=
 =?utf-8?B?dkppb2RHZWx6VXV1VFZJZTBXWisraUxUbUg1bWFqenlPSWdVUWNYaEJQK1Jm?=
 =?utf-8?B?Y2kwcUJSNzBEODJieGI5SlB6MTdEKy9DM1FZdkpKdDdEQlZydFdRYS8ydUFu?=
 =?utf-8?B?dHRBbjBhQWtQdWR0WlZBWTcySDQ1TDFZMTZnUEdqL1ZjcGNpcUtOeGU4Z0JL?=
 =?utf-8?B?VCtydk1NcEdlSXQ5amlOQ01xaFgxeXRqdXEyRVZtZ1RIQW9OY0xmWWNrcjEx?=
 =?utf-8?B?aTNSaTlFcWZIQlFJbG93NDJmcEJGbWFpbFlPV1JkeGVZV3Rua2ZkNGk4UjVZ?=
 =?utf-8?B?bkd0aklxY1phUVcwamhZSjZ6SUR3TmFQU1dnTHlCSjBYRVg4NmIweExUR0ZQ?=
 =?utf-8?B?bmNyb0VvSXIxczdTbkh4MGlibHpDcmoxcDV3MStiYmVYaUJZeFpSRXVYcGN1?=
 =?utf-8?B?Q3NVU2lrRTVSOHJnenZRQU1WVG5ESzhGOEFmSFJTYW4rQTNHd291SW81SndR?=
 =?utf-8?B?Sm8xUGJtZlR6VDduNU10cHdBa0o4am9UUkhtdlMzazUxemdCMHhLck5WWmsv?=
 =?utf-8?B?YnpUK2k5MDIrS1JRbjZ0ZUVIMm1iNXJWNWE2T25vTktpNmhiYWNaNk1OY1Jx?=
 =?utf-8?B?UHNTeks4bUtndjhHTjhnUWFzNktDZ3czWDNlSU5pWkxISmlVbVdFWEtxckg1?=
 =?utf-8?B?aDN2dndia1dXM080cjUvV1M0azlhK043bVBOYytZQm5DemZDZGpNS2poM29J?=
 =?utf-8?B?S3RwSE5QY2JYSWE5WlJ2V0MzSW8zMERiMEo1WWh3QkR3UjIzRElIR2dPRHBm?=
 =?utf-8?B?dzRoWXRVNXB5TWd2QTEyUlhhT0YzZllPblNUWUxWT3ZtSjhVSDAxeWpMeWNv?=
 =?utf-8?B?YS9INURPYVo0UHBhSEJCSTJaSmRWdVRpSWxyeER0QWRFMXZmQi9URjU3U1dn?=
 =?utf-8?B?VGlnQTZXMmtKUWRzVUNJeGxibHl5NVRZUVA1S2hTNFI5VmhqM1ZwYmRrQit5?=
 =?utf-8?B?OXRZeE9ob1h6aGtIR2dUU2ZFY1hZVlhvTXk5eFRycU9maGYrUFJ1bnN1aXd5?=
 =?utf-8?B?dkJXZXA3UHdaM2tITUJmdUNYWTN6OEhqaG1oeDJnZEFpblpDcHlYMndEMjJv?=
 =?utf-8?B?dW5OSitpaUM4NktINllsT280TGJJdkNxNzFBb085M0VxZis2N1B2b1dkSTR4?=
 =?utf-8?B?N2VlalJFSVBROEhMUkJZNXh1MDZleWtiSDV6aThsK1pqNm8yREd6N0NlVFVw?=
 =?utf-8?Q?hSAeDLHqj6hvr16/b6KA9NmhrxTxhzMIGPlb8r+mNFBBr?=
X-MS-Exchange-AntiSpam-MessageData-1: F+riN3ZOAAFq31WaruVqginTQN4XvK4Ig+M=
X-Exchange-RoutingPolicyChecked:
	Jkam7UL9iiZTpe4lxBCMYUN68T4BwbOtChYymvGgSLC32SsJdgHbwZ5j9711vpeCUhVrQzJGyQLSJr3QQb5ILbS4zQ9yfLOZQ8kFy0ZTJud6ZfGjYIfxRXeMWH1v3vR/Exl/5q5ev8jb2uUjj5Z5kffa4B0kkZxpE/JCekaHtQCnr23Ly2Qz4TU678gwL6oM/KDrZUxcEIgwBxKl1MNzESlomW4IA/2rD7bhoMkJYb1KcSh2sIqCmxdSTDgVHvVmuP9PINfY0yaCAJr3exKwNdiJmCzsWJ0q3Yx0RGuD9LOk0+QPrH0z82NiZu2Xl5CQLfVrevU1WL1OUfQ1YBg7eQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nudzqdQRMMX0ed+euy44hVOPNqkVjzY0ZoYP4J8X/nG23OIvf1wcAY8wJflLYFzoS/TiXry07+NO/xa7bDurW4iyu1fEK1oUo0Vg+8Xf3HehyJ1dHxCNXZkDOEH3EM1r4iOh4ISoOPX8mT2ULY/ZLopB3wO9pY78sKIm3DUgxvGBUOeuq2hGRx7MveTZDgIOW7vMR0oEfdKuf8J7E0+GpPODy8ialaFmr2SMOR03yVNGqAK8Df0bCVECZICA+AcI0c/d19w49OWVUIJ+Rg/oU1GfrJKexzBKUWL9NUlvqbxd/VkVHXPzZYz0gJslhkGundRjfcn7Km4MrSWLt6v/N5i7GHh4IHORmRHe9lA1JfQ3jhbzZ7yeQ6adCe2CDZul3WOM9tpUgWt3ZQ+x+lDYJsaH5nMhp4icw1MuCNExf4XHelAOcu9nexdcreQ/+AtXwIuHW3ivehJeMG8lwIAdXg6bSg5Ni39zwDcTyCAwzuSecpk0gClAnQR4XdCpcIZ25CZ8qQn32s3YS61sz1o/W7QsQteF1hEX6biqOFMkMgPmtL+OvPHUYYfC2GO1k2HzkCA7KU4Lo3SObkXBwAvXsYjisQ53ZZqgTDYLHW07py4G5bPC57KXi5zlEWxNPF+Y
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcdea8e0-72bf-4750-fdff-08defdccad12
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 08:34:25.8974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rCgPwtf+AGyN7ytkrpNytvSjjzKLRfFShP8GZRDFBX2ObCvgzcp6BUMLdAp/zLbK6wuYb4F38EVQ9sqA6Ag4M/tMq1cMtBjPvl87dpK8luU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8712

On 8/19/26 12:44 AM, Qu Wenruo wrote:
>
>
> 在 2026/8/19 08:11, Qu Wenruo 写道:
>>
>>
>> 在 2026/8/18 19:30, Johannes Thumshirn 写道:
>>> btrfs_zone_finish_endio() ignored the return value of do_zone_finish()
>>> and always returned 0, silently dropping a failed zone finish.
>>>
>>> Instead propagate any error from do_zone_finish() as the caller
>>> btrfs_finish_ordered_io() already handles it.
>>>
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>
> BTW, you may still want to check the sashiko review, which exposed an 
> pre-existing bug in the error handling path:
>
> https://sashiko.dev/#/patchset/20260818100037.1366563-1-johannes.thumshirn%40wdc.com


Oh thanks, I would've missed this. From a quick glance it looks valid. 
I'll take care of it.

