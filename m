Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4373B3B7742
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 10:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776074539; cv=fail; b=fcC+mNzcwjmHxEM3lkKIINdQyUxyofcOFh86auqE9rD1NFraDLITMXgQvnJBpMZNNtb0MyD94tXh+hZhTmg1kiMzM6l7Gq0YiNJW6iXC9P5+Mz16EUSyUnXGlXc55gAFwxhknVo7nK6VVy0zPSxZ50StOvH/TL1fx6XZZtiEZ9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776074539; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UijRmxT2PNsu2j237hMW8B37AGUsHdo7YMXEz3AoSvhHU2hCtw36iV02GwEroxhBTKhQrMdFWHpcM3ubvIlGq7EnDdxnLliLHKFzqit/7i+E4fsYESRyuaqPJBFAgI7KYFXtgooJ66dzIUpFgeFo6LTvB5zpXXDShf9eswl+MAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=S09uGRq1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UosYQW8c; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S09uGRq1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UosYQW8c"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776074536; x=1807610536;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=S09uGRq1pQpO7+5iBqQjP5PhZollJJTn0pEVqYSGmrv9MK5gmRp+2hfC
   93Z4Tn17AN5rVnwGU4XASrmh0HneE+qxTKfKUZQPlQCtuV1l7QsU/BsiR
   udi0JZXya6rXmciygQHPzrHkJOYH2M/qqGzKAD4U8wQiMEPH2LIZmctI+
   JTZg7ZA19HnxG/Mycv7swozQry8yHTFKBS2N28W8qPflxZgzDH1lxvN3h
   cmfzPD5HUaU7d0DERAoZ6o+90WvXZ4zB3OahldpnS/ZZlH0NZrQu1X8iW
   qkVE1Gyy8kFkjWEHLDILeTjtGToZzr42HPW2TuYgX3pE3w2ShGtnPJBGi
   A==;
X-CSE-ConnectionGUID: hNRBwZXsTnCsVyfsL0C/RA==
X-CSE-MsgGUID: wIrviFgtSoOGRltPThVI8w==
X-IronPort-AV: E=Sophos;i="6.23,177,1770566400"; 
   d="scan'208";a="143939105"
Received: from mail-westus3azon11011070.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 18:02:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YT1kruaBZLT+yj2nSH3QmKSzDpW/uUaOyNHzY2O1lct1yOw7yo9dRsv4v0DBb9QLnTLIfCm1qKkEmkU7asKzx1lvixyzGNQ2gt6KLoseuX6yOouBlEtba6QLhN0GOgfLFIqR+aHfpQLnidLpzO2ZtUZNwtlbDNLmfpUPY3EaSTa+q6j/KLJKErMgo3a6BkoZU/JDpX/QQiNUusR+MYbm/o7Gc5OJqPSj3IiTEf1tv6yls3qNuCYxIRQnTCvmiVOygJOxfi/Wx4cAbg7+IzSW8Q77yc4dMBO0CSQL/mE+jaQSDgKFPTYV0R3l0n2BVNd+oPGykTGRUiFKTFDO4RzT0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=wpq7Bh8Hy9pateSwmHlyvoErbxuUlFVZ/h0yxEGEEcEJEaI7aFMU+lAVWqLG83uRvtkLMMPfQ15Qh5+w5Yj8o+uqIlwEAb0vHNWhGvbKej5qKIapuWpk0yoqkqIvAYZ91cDIpv9t5NVNReYYmjYxj/F0gI83ETGb+A4n0qiAcvd4pZpLxQSezh6gb8O+o6QXX7L20dCeTZoY7CDDWqlhFDHD2zqnlPECWXQVVHkgDV4hrDoQPiIBlIv+umHiO630PABnk3ymYSYFoo6I6qJM1twSkqvAY3J0lZXzqrrGPttHpMysdCszqXEVZMzCxzfKY6woNoESn8iTt/KGVXPZzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=UosYQW8cFO7c6pO/AdRctPuCuHoQr6XQChhnyAQA1SFcq2+Q5FxWCBMfAZJaZW/bdrMu4VdqBsMitfNvJbFY3dt1i5UvIDV+BbKbvJSvxblP+3KevnyDVPDgACXuSE3RCw2BzLF89bGlXufRKzAY8D0xSlhGXKV1FdBSF1X0uhM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by DM6PR04MB6347.namprd04.prod.outlook.com (2603:10b6:5:1e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Mon, 13 Apr
 2026 10:02:13 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 10:02:13 +0000
Message-ID: <5909949d-366d-40d6-95b7-d03c32cda4b0@wdc.com>
Date: Mon, 13 Apr 2026 12:02:10 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] btrfs: fix raid stripe search missing entries at leaf
 boundaries
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <20260413065249.2320122-1-robbieko@synology.com>
 <20260413065249.2320122-3-robbieko@synology.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260413065249.2320122-3-robbieko@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::12) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|DM6PR04MB6347:EE_
X-MS-Office365-Filtering-Correlation-Id: 6279bc99-7245-442a-9d4f-08de9943bc50
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|10070799003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bulucgRasWVo80yWHVNVqVcE2hTys3NaaCHH5/isyiH0Vk8da9DAjphynOWQyjU6dsdIzq5vBXRD65CJ6od/qolqMkWvsaIQyQg9rEMZ2nv+xk8liMVDRQinA2LU2fHzdK9sqcfMQb7KJeolnmlQMrn54WBcbDmx+5/rmOex5eCiy7edX4VcMsgxOzKmjCS/xsCOgI1Z65XFONwoGd9BR9+ob2WLFjA1R31/B9WuNkJKhD8gc2mqna9fWB/xYIf/ulyPCQwyVymEEpderuBxyC2MUlLIKHjR2hHiOpqSWfgznXeC+cJwmJK1JuADx7BSYNRwpRxd05m5QkHSSGtt/Qm2YAdlO62iiK55oY5Icci8uMCEPKwJc2QBOmtSj8ohA1LW+BgSN/vhj7pM0LYcC8C8FYcc0enjSJKOmybNqBImg2015siVgYtHkGi2F2aDAJt6bbPCxZhcU4dWhBuT7WnSZ/9ypU0CICdciuiqzoAWMnqaLM8d9Ne/9V0aey8m+Di7TkOQR/akMWPKCnZ7jLPOPj8CCNGbiqSN2o9/0s++nIuJLOh9z6l1uMXCl9cZDlW77NDYbcD2RH4mTIZIyBTpmpcJiz1OY//UvYb544HKM0CcX8eYQ4KT58aXEkvTfwjAAXKT+ZA773KnY7QGiTXoXb4J/Mw1jMWJk1Yt7NDB+2JTaC69PSumUl8zHCmOWZR9YIUZjP5PGWhbuHGQnlBySqT4FwzSHh75mwEt8Kg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(10070799003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnZxTURxTjNraDBhaHBQN2Via1FkaXVQSjkzVGcrUHJRNkFJNGxxRUlxcVE3?=
 =?utf-8?B?YzRkcmwzb2dOTDdZZjBISlRRZTRsMkRVcHRkMUZaS2ZCQ2tOcWNSeG5yR0ZO?=
 =?utf-8?B?bFdCeXEzNlhQR0NKN2xkK0w3Vk9mNWIvRUozbE9QVWI2NTRQeGFxakVTYlhh?=
 =?utf-8?B?WHdWMStZQUgxMDFCd1k3eHNjT0g2ejlNZS92enpzWXV5TGIxZ3FQN1VIS0V5?=
 =?utf-8?B?VjBlMVZoclZOcER6eE5taHRONnRhVkdQdjdmTElLTitKU2FHaUFzUlkvUzBW?=
 =?utf-8?B?RlUwWU5DQmpyVGc0NWRMaloxaUxyUmxydE0ydTA4cWhjTUlCZUtSWXdHcDM5?=
 =?utf-8?B?MjdRTUZUdlFzQWhBeE55VkZoaldWTjMyVEFWMEJzWVRDSFppZ1VkelljSEUr?=
 =?utf-8?B?cnpnelZjT1IzUWk1bW1LQzI4dGJpTE9FS2RjbFhHWTZ6NlBkNy8weUplNG1J?=
 =?utf-8?B?Z2FMWmZzTzVNTkQwZGs2dHR5c1p1M0JYckg5NlRhUFRiUWNHSVdySjdOa3pr?=
 =?utf-8?B?RDdaZjF2bk5aYjkyUXJ0WDlMZGRnRmhadERqalE4cUprNEJTeVZsSWcvSkdE?=
 =?utf-8?B?M3RsbTI3TFZPRnV5VXoxRGVud1RUTitCSi9SL1Y4ckNNM1IxZ2crL1VFeTht?=
 =?utf-8?B?U01tV1dkVmNYWWphVzhvdEhQd09jcXprbzBEdldmOCsrRmlPd2cwbzFhVWdE?=
 =?utf-8?B?N1ZpRHJVZXo2a1NwOWVJL0M4TjRIY2lKQWpZVlF6QWp4ZDgzWXRLNFJwVUxq?=
 =?utf-8?B?bXVwS2NIeDJzM3hZVkpNVnFpYlJHNWU2dy9pV0xuM3R1Q1daZGhZZExhL2pn?=
 =?utf-8?B?L1RtU2xOTFgwWUg3U2lGam1Db1BzNUNKN3FEdXFUL2tZV1NublF2WjlKdUpP?=
 =?utf-8?B?ajJ3M3dNYlR5SXlDd01FcFM1TmhkV25GUTBMRVdMYitnUjlKTktGZnkwVU9E?=
 =?utf-8?B?NUdKL3NLZUVkTXhkZm1GUlEraXBuSVdlSEY4M1haRGZERW05Qlg4b1NvWWR2?=
 =?utf-8?B?WnBCem5pS3JvaTRCbWlUSGtpNjRQMVQ0RC9lMmJQVnljVFY1ZWJjYTRESnpn?=
 =?utf-8?B?Qys5T2N5ZWJlalloTHVSanlhUFEwSkkzd29VZ1luUFpYSXh0RGFCZE5QNmx0?=
 =?utf-8?B?SkRyTmNuaWNuNGN1UkI0cGc0OHJJYVRvZk1PUkhqUjNQcFJYQ0p2Y0tYNnI3?=
 =?utf-8?B?bXNyT0ZzSVo1M1BDazhvd3dyY2NscnA3dzAzbTJrQTRvaXVQTzNLVGN6Z2pT?=
 =?utf-8?B?SzNYQmdRNUhKSCtJU29OSjBVUFMzTUhTamlLZkZCTjBVeXduUjR3U0FIeEpo?=
 =?utf-8?B?NllYTXQ5MitQa08rQ3dIVDRRMm1vYzRLeVgvSWhLQmtUcUtvaUJTZlk4Q3Mw?=
 =?utf-8?B?WGJDR3FBNkhiaVFpeHJhdExraGFFZldrdlVhOFNNV2NqOWxDTVhPTk9oMTZu?=
 =?utf-8?B?d3lZY210amtBREFBc0tJVDFoNG9wTXVoMGZkTEdEa1FibzRndStsRWNHQ0Js?=
 =?utf-8?B?N2lsSTYwUFJpUGs4SHpkYkd5SzB1b1ZWKzRSbGZVcDBXREZWMm1xNWswMWZL?=
 =?utf-8?B?bjMrRFNnZnpTV3pMWi9pUitNS2JnTUtWdXBUYlhiVmRJNFczRXF6NE1DM2Rh?=
 =?utf-8?B?VldiN25uYW03N1pzOGVDT3RJM25Cdk53NGRlRXNtMzVSWXpaamZHT3M1ZkNP?=
 =?utf-8?B?MXhhSys4cnc2WVFyZEczd3VNSUltTjh3MXQ1WTZNeFBtSmdUVnlTcDU1Umlr?=
 =?utf-8?B?RlVCNTQ4Vjhha2svVjRpRjY4M081UEpDcGMzcVhQVUVNSEZRMVNBSnQyZnBY?=
 =?utf-8?B?S2ZCOHNZT0haaHJNNUJTVlFRWGpneGVqZTRsRzJIN2Vvc1FSQzJtWitYU0lY?=
 =?utf-8?B?a01pUFR5eWF5MkFsNmorWGRvUzB4ZmRQTDJLcUdPMkx5K0hFVldjczVMd2tP?=
 =?utf-8?B?TUE1b1U3cUZPZkxMRWY1cnV2MzB5dWhDanRUWjVlTmF3VlNaUXhPaFZYYWwz?=
 =?utf-8?B?akVTZEdaQkVSeHdRM3lmVDZqcnRnRlpvd2Z4bzJJTURjaE5Va0hNekZaZHRs?=
 =?utf-8?B?REVCMXZYVkVGNm5OWlJOYkdRbHZGRHowZng1cnJsRGpiMi9lZWhuQWRqKzhZ?=
 =?utf-8?B?ZlpVclh5ZG91WFlHTDZQQy9FbVVyb2t5bU93V3VkMGFSdERTUkJtUHZqU2tF?=
 =?utf-8?B?NFlnSXJFcHdUcGVVNkk1ZkZ5YVhmZnNPOVVWR2tsdlZqckY0blFPSjNxdG9W?=
 =?utf-8?B?WVFaOGk1L01xOXdCMGp4dTdSdW5FSjZLdTZZWXBMYnFhMVZKV25VamhFTng3?=
 =?utf-8?B?clFpWUVla2NmWmJkUlc5UDN5bmtVQ3czT2czeEI5bmE5SDE5eVNiRWxZRnN6?=
 =?utf-8?Q?VpnUGzn0lwJfBIAoHUU7g+oWYjQScd22aMsme+hBMHLmp?=
X-MS-Exchange-AntiSpam-MessageData-1: 8zBJE32tJXDJHPGf5JuwEOrwvpwQqp3K7xU=
X-Exchange-RoutingPolicyChecked:
	kC6lhaJheHwfAM6Svf3aICf5hAttLFLIW4g4mmvRq3MVyeRAhuV4uoPceYnR+gjwGOXAP+MiIVIDiPt0spuLERs7wLNW6zLOjBGLU0oHbugWl4QWOFiq07Q7qAVw9ekNh5xPO/de7ZXqoUhwzTid529BfFu9Mr2fwqDbDN+mjSO1wuE/Tkg7UYyndtpAlr98uQCMtY+lX9mt04dIo6RhQSQdubQ8m6W+Xk97pLxjtor9kxQGEroHz12vVvBr1qvq6NQeZEG0+3j8tDqblSbgGtIOie7ACrGtc1WyaD8/ozIfBUhCqcEU1zHZb7GqvMJrlrLBBsBzmyADMLebi/6v1g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TUtRX1WWP/58kgGS7CW/C/A049JTTJbwPtfk+THRgx0+3h5Bs2tN2k+AnLU7cGuoQeNTw1FGkYFaP7GV+8SXn4RLR7Jaba05rKjQQL/xNea0jSJKppVPDxT3KEJFfYP12ssN4qzYQJzpWV82IvoPS5sQqQpc6GFfDUXRbaSTlRsnUoSocZn1lCwNKG4HkMnivvnBcDJ6EvzEK3gEchPf/KBkKeEALWcnhWUoLNyjiM+mvH56TNsMP8FwOp/kk5qHs4e6G5vYMvbQbsPIj2QM4nH8ldWgnbqOD8LQJcHr/cMN0A2ijjZA6LNxGFLoXR178B9VYELSNN9SwwOqbSYO0QAqfII1fzEZUYgcTRyVWW1LjkoIAhdN657R7u91xvYJ6y32WSRasE93N97/pY7y0dlbPbPbdRLIqp/vLf6vYyBDAxWbLw66IuuThgJ/pQ4O2170WAUrz7VaTELNw3uXxp7G5UgP/rK6RRW1JgjImYalPV0rDIqSBF1C/TKV8DMPRvvqxEMMPHeO+qQP0OOBS1+cN1i8a/wWHMY5I+U38iPt2mwmUCWCXRV/ZPZsS+D7diFUUcevYGKnDP7tGAweQm01v3jAPpvIhcwHAwRQ4rtYEu5EuYkOSbCi2rUrBLGi
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6279bc99-7245-442a-9d4f-08de9943bc50
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 10:02:13.5350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgR9PZqFaZyOWciqnRJYIXIUqvUo2TeP/N61Q95X/2MDzCTWHvP4NXZMvOd/Cda34GoZTHhBLYlRFkmifrLDb0TPoVVN1dtLaVPciso+spU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6347

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


