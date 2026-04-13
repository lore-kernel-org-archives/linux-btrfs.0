Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0C5304BDE
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 09:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776074063; cv=fail; b=nrdnjfJ37BnxB/b7V9j4Hq/h8FhDdzluYO/EAzjz+G52RIEPCdFvRuN6Fp0MvMNg2QcncZDx7hVgD+4iKUmG1NYtcqfd8uJ133bwhiw/BwoalsknhR4KYSNf49K4qcf0C3lBkHkf97byYUASVPvO6i1O65mLswHEK2SwUEP5cQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776074063; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JyysUwtLoQ/dsn45kQq8dIZh0KLmUvCHCCpC3NRCAXTTjYqw/cLVNKX578W5ykUs2VbQ9+uIphDquYqmccHiLkOZ41sWLn0+zXGrR4o2tKum2wIIT7pL8naVgKN2HUffn6UTjpGtsJP9u6Erf1nbNN9ArJjs+tQfIF2m8nMTqVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YYN1Mi58; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=m4TjpCe9; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YYN1Mi58";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m4TjpCe9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776074061; x=1807610061;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=YYN1Mi58peEEhiQ3qnBNtK0Gp5ryvaOpzxLyBtrmcXp2amrfj8AD8JHL
   o95ay0ex5WPQk4l2324Fmn7fuR99/k1BzyC28cwH7IlhmxTPhcx9Tpz7m
   KNWiFXB+nMcyV8fZsJNA9OO/FiSKEpJnuqY6R7qT+QgwtsssQXoEKsk3c
   uj0cqBHp0ETHSrhOSUCdFFDXewxSMUi6o9Fjrni4LV7KdPokNjhxM9nf4
   3GZN+7584NZEeOhURTClVMYVhu/SN6alkvFnbaCGOLDZ2ClpFxVV0ERl8
   mQWcqERVq/XUHqNShDAs9nfDCTkhLhNQhxjbcxYWnHTaG02xV1Kkqvrza
   Q==;
X-CSE-ConnectionGUID: auvGo9SBRrGlbeYGcKs4Ug==
X-CSE-MsgGUID: S1gF4UISSiOe1xXKZfvExA==
X-IronPort-AV: E=Sophos;i="6.23,177,1770566400"; 
   d="scan'208";a="143938684"
Received: from mail-westcentralusazon11013048.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.48])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 17:54:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqR2jOGpJx3/OCUVEcfflLWy2a8WraQjAZuk/+Dz8VojtALawXfnHlD23GBGeiAwQFIMC8stYtZpFliwVDC76K8nBxQ8sAAXnFlHLiINNus0iXdH/U5+vOmh9WhaXv5uedKifPgpoFGJLSHtHXjBG4FrvO4DEsoBClRT7lPQfWu4b4k/3WTqYPOVxeMawR5JqaQ7/o++5GRubsuzv/vHfGi4YSY2sa557FXRwdZJiRubB0fBeWxwrLpxHxdGIFHyHPD/vAKg/PtE33OHGXiVaaYh387infON9XL5xryheIpK5EjsM5joG4QMOqgheb/jo3E2bwoWZHQdugZtHKzmxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=gbwclCKFT6yj3TCU+M9C2pCgFvDEN4cpiezovXZO0dhrUtkU0mH87Jm0l7InxHFSyn6FIneEpvqMcFHc+1BG5S5+nIsKh2zXGzDggTciOxFgc0/bmz7ITpYEBmCMEJzBXsE/CgfPYe1ou5WTgPZOsxNvTEIBYy48aysvm6lP3ZYLRFjnsyNy76wC6t9USbrtSrtIhtdKptVZHZVWWroY8QRDm061eBwHug6f78GlEs7QPSbmtZH92Z+/FIpDe9Qx7JP/eKqbeSstB2tcYDOy9mZazS7X256gv2PRkUdXGD74eJawrBzMeDKqGlVhM45Q9KaMsFpKXx5A1IbcWfnLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=m4TjpCe9HDBCmKWzRziEcAxnYaJX4VC4CqQVjcRFHDWmz5g4fo4x/F/WxIi+XK6KcVQZzFI6ABsTSzgwNvYhh3RZASmghcCQc2A/SspIyx4RT7ceNfCT1q3eMfhiLLnxqA8Yz/bQ+Z8d941rLQgdsVPpva6/CyhL9ckXCsjIb14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by DS1PR04MB9653.namprd04.prod.outlook.com (2603:10b6:8:222::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 09:54:20 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 09:54:20 +0000
Message-ID: <a90e7a54-4c25-424f-be4f-217692117f4e@wdc.com>
Date: Mon, 13 Apr 2026 11:54:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] btrfs: handle -EAGAIN from btrfs_duplicate_item and
 refresh stale leaf pointer
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <20260413065249.2320122-1-robbieko@synology.com>
 <20260413065249.2320122-6-robbieko@synology.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260413065249.2320122-6-robbieko@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::12) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|DS1PR04MB9653:EE_
X-MS-Office365-Filtering-Correlation-Id: c002c84a-351c-4054-1bca-08de9942a278
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pq6SxOg//r1zOOZZCZU39RoZjoSQrIj+v6/kdXYJm7iFLychuaOgA2Pq80w16vyxjLdBDirEO9vj0aKaU6QvoJedpaHJbGCkBtWuMCZyFkEfHfKr9cYZ2bIa7ISzHtBi2B7Dd1ItYJc5+xeiWwoY+tYhQ5gNN9Z3wj1WanVIanBhIv+GE4Ct5sVJLWK7fnzfmAPloIHDdMFlJVzPtQJl7or73+1HYpv4TF6bTVbe3GQJz/eiAZcGlYgi9A5wi1qikfF0BoX4DTH+uSfjP/8vFwyCB5EBcxP/QP7a5JJm637zSwA2SQIZ3Wc68G4IaD6HX6i0o+on+ok+S+bzC/lE/PlV3mCkvP9sL4cTLu5Ofb079mMKzGxkMghRRvqVIBm+gIp9DDUo9g9sZKhfIF8Q0DVVEb9BvVOC2hPYkOY8J3EG12ByRGwtQQY9Nttky5XLII3RLtTyaLXRBXD3z9kiSzl9KdGk0EULTyYwJtHiUgHrdWcFh12+3dnSnqfVxSua3APKuQFmRa4Iq7ieYkH8UEnBUTRk/0xoFBEO7rQrinCcybQKBREuN3mUPjR7oIm84Bt1+0fAh0pmGRmWeIuuXTyZ3YPmPhw/x46RgQ1QkeEzZn5QGuwfenIojx3umhfN7g3rXCjGnkU4E12Ekk00tov4vinZ/ks8GK8s8YRGLJF0eglTuGsyJyCnwnLB1f4UfvUsvs4Nj86qdNqVzjkgLfV4qyfACRCCEAzqjlVRfCw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVdtdllGU2p6NlcwSG1Xb2cySE51ZVhpV3gzVkI2MTVIV1lYbjdMMWcremhj?=
 =?utf-8?B?c2g5b2xjODRvTHJDcUtWWHNmcXFCa2dtcXRZVHpBTCtiSmsrWFJMS05DSlFC?=
 =?utf-8?B?eFJvNk1STC9qcVNkQnNxdlRZMnRkT0R1WVluTjBqeVRVS0c1Wi8wWE5JblZH?=
 =?utf-8?B?aTFobDBzbzdFL0wydHAveUM3ZnU3cVRVWlgybURhQmEyQXc0c3RyNXZ3YTNV?=
 =?utf-8?B?SmdKb2lraVRXenZIU29PTzFmQ1RrZzVjQ2VpSTE5OFBQSE13TnI2aCtNZDdE?=
 =?utf-8?B?YU40RDlxVVZ0bElhWGtQaGwrK0l4dHNGYVE1ekxkbTlNMVZTalNLYjEvcjU4?=
 =?utf-8?B?M0N1K0dXTnk5Y0RsbUFvV1g2eXRIMWtreUdSQUpJd3hrVHRZZ2ZKMGlZb3U4?=
 =?utf-8?B?cGEwQis5NVlqRnh1Y3FhT3l4TDQ5bC92Ni91UFFBb0dtanpGOFlsS1pUM3A0?=
 =?utf-8?B?V2RMZFRuVjN4YmFYSmZxVzR3czlESEptbHQ2eXQydG5QMlhKMm9ZZU15KzZX?=
 =?utf-8?B?SFhDZ2ZaUGxnT1RkRTZ1K3ZWMjRlQ05kR0h0UW90YWhlaEQ3dDQwSDdCaVhG?=
 =?utf-8?B?MkxxZmNIRjdtMkozOEx6RDVPSlVNbVBjMG5LaXJrMTVPTXhPMUNQMWFhVExh?=
 =?utf-8?B?dHJsSi9Hc0RYVE54VGxobkh4dG9qWFJDODc5S0pRUEh2VUxMVmd4bWl2ZE9Y?=
 =?utf-8?B?SGp0TXFZemVPb2cvdS9tLytUZExsSWdnN0pFWUc3Tkc3K3AxWlh0UW1ORTBh?=
 =?utf-8?B?K0hvbnJPT1liQ3BBWDh1Q1JUajBMUFYyZTYrcm1uaVJmcW9KNXJNVEtiaXpQ?=
 =?utf-8?B?ZmM4cmVKUnY3V3dqRk9pc0dDaUl0ek5ZN3RKUjFYanluUVMzTXVoZFN3NHg1?=
 =?utf-8?B?WGxybm1BdElMR016M29RNUtzWDh4eHJQUWxLdngxQ2UxV1ZVcVBxVnVRTlVi?=
 =?utf-8?B?NTFodDB6cCtnNmRvOU8ySFZtU3pqbk4zTjFLejhhanR2ZS91aFE0cmdPL2pP?=
 =?utf-8?B?NWNiYlBiZ1R6WHdsQWxuQmdiUVR2M1V3a0k2Uk5RcTdGaFl6a3MrZjJZaXhi?=
 =?utf-8?B?K2RqN2hyMHMzeEJyb0RRU0pjWllTOW4vdE1uU29IV2V6Z2tYcUpaZktiRlBN?=
 =?utf-8?B?NVV3dnZTTHlRc0FkRzZsZ2o4VFJaWlBvU1Y4ZFRETE5mTk9yMjU1Yld5YTFC?=
 =?utf-8?B?am4rNFljb0p4NnBaN2tQSzY4Sm5xK24yS2tXeWdRZzF5LzNKYzRBYkxGSmVJ?=
 =?utf-8?B?bkZMcncxMTRuUUhXbWFZV2tiZzlVaytnbmpnVXIvdEh6NjI3RkFoM1UzZ0w5?=
 =?utf-8?B?aXRPYVBxLyt1VGJaVzExMHNpUUo3c1BIWjRGa1hHYjRLcDVxMXRMNHV2dnhV?=
 =?utf-8?B?ajZBRHNoYm9IZGd4WjhBYUZxYUtwMHpDT3JFL3licWhkcXNFNGpNVjYyK290?=
 =?utf-8?B?SDhyQUVsekptYzhjUTF4QXIvQ25tUkUyUmk3cUVMeVVzK1NwMkhQeG55ZC9x?=
 =?utf-8?B?Yk9QT3dhMzBYR3B4SXZLZ2piWFZHVW9MN3NVVGhyeTJWQXNITTQ2VlN0MnBB?=
 =?utf-8?B?T05DSDFEbEViSGNkMnpyR2NJcXo3TEUyL0VmTGkvZmM1VTRyVWlIaXdLVVVj?=
 =?utf-8?B?ZXFXTHQ1VlpINWpnUGZPOFpUZmhlbElGb2pHdGVacnNzQWhCejlDcW40R2ln?=
 =?utf-8?B?TzdPZU93VUQwNkhDSU9udEl6a2RhUlA1cmtSSlc0Tms0My9wUTJrTlFxRm55?=
 =?utf-8?B?UktFTnJtMnU0ZzJVMEE2WGErbGo1WUNUVXFzQnhPV2RYQndzSEsvc2Y2d2F5?=
 =?utf-8?B?clNnUFR1Vy8vQVhVdE5xY1VCR1dwTDdxeCtvSkRtZ0ZEM1ArWUpGbjdoeVJa?=
 =?utf-8?B?VDAzcUdDRkdJQSswaHlvekJZY3owRU1tRUxOYVhHWWxtWTVzbkQ0N3ozdWU0?=
 =?utf-8?B?TityUUZBSlVuUnZydGRMZHFaYXJjRjlaTm9ZK2l6alNpOEd6NmtScFdKYnFt?=
 =?utf-8?B?WnJrTm1PSWtQQ3M3ckVUQmRPZ3ppYTAzNVZ3L1diLzEyMWRPcmVmUDErNVlN?=
 =?utf-8?B?WXhnbFVtR1BFWFVURUdSSzcvT2R6V2F0aE1QSW9pbCtsdUI5dnFyMXd1TUJr?=
 =?utf-8?B?aUd0MEpHVTU3OEtPOFdjZU44VXFWQWlDZkdNOGNqcGVhSmxrMmRoR3gxSW40?=
 =?utf-8?B?ZCs5WG1ROUFmN2RNNXhDS1JsVUNNKzJOdVpZcTU1am1WcnpmY0wyOThuREZo?=
 =?utf-8?B?dzUzcU9Jamh5c0pTMDZlVGxCSENjQU1WOEFBMzY1NDhsc0hibERWVmJxK1lx?=
 =?utf-8?B?WmhrV21KN2V6SkhrMXduZ0R3cHZJemo5WXVVQy94eG90U3RnT1pRMnFsNy9K?=
 =?utf-8?Q?/6BYXFlx1BcWn5QNcvREAHXFz8sBuLJCWEA93fEv+5GOy?=
X-MS-Exchange-AntiSpam-MessageData-1: MyxXYPzN2pFm99/0X5vkejXofrDxVy4IoSY=
X-Exchange-RoutingPolicyChecked:
	ttWndvYYqBdRpwK+nVjFzX5/+QDz+xhQKd7+3awTI2EJLO41oyB79OrrDp0IHzE7TEOD6SBW6UGQbuuyNWuS/jCX5hop0/gUzLSVn7ehQNn8mOGKZquUh6EFbmss19D8fO4XIKq8zb/bjSd8pp94Y4BpwJLjOWjYDi4q0eG9wd/DFfiTo+He0TZKUMhFqc7WKKlA6MwnrdC9HEZFfcDl+j6bJfDOEljWUcnAQ8exxhTKdcU0MFpNUMgRxYVmRNLrgFGUQfA6UN50LVpq3W4yXYGBRYxc9zOY3pXXrhXW7MNmVqRqHBELVGRtEqsC073LSsB5dHtpd026KGanUrgPNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dw3vYmV5GF8o/EgES7wY0TT16tp9/YpNWrRo4LhbigSzeJsaa3E17B1I1URbJ019Cf7yzhVXSN7yfL37VrAgmjQ6tVPu0TOH9TBnTOFqjg8zpfS+bXy2a9122+O7kvQ/CiY5/4DqmGqyfC7RLWc3kzeX7K6klyXq3UnQsTALkxgXdAEr/8LyinJQtUH1wGHPX5f4I6kjlHcu5TdLNvbS3Piuknh33AkC/FZbwjAvC0f97mZo/m8BfqKF7o/OETk0RMgKe9n2eBn3pTvCka2ibmQjRRtQA1aHn9vMwxOOSfCjfgktovrHkT2ChTdhMV3BUu8mNpZAOTHPP0OU8iFPY0Q3RQeKiXisVwHScLWc4xUpXAO59gJjIR+8pR3FpRxTMuJ4NypSu8WM1Vi4NqSCSjyHeltAkAuD81ccxdLKrWN1Fz0Rr5ln5RdUShHHdisAn48qm05YJG8zA+cQEtR6xkrMjdQ4yJ9M2jFGYSHk9ULH8U4vmi1B7izHNKkC27poNA3Hg8cSkXASg5Fif5FpZLKYtwVLEJzqegAsToO6mxzB3xp2NJw5kcGdbpv/0HAuCOzoiCIbzxDTwOpW7EYHXq/N2H1xjq/MsPivB6DEj94VS2VXcUSkbM/J52G67s3w
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c002c84a-351c-4054-1bca-08de9942a278
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 09:54:20.8340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0PWMxY8fpj/CbbTWn17b3NRFMLq0r9O/nkm4k7Ul9Q1tJ1jvz8w8cRvcalAb9W1TrEas/Sw7Y/NEQ7ed1AliVThH09y0gxnXPaYp8WUlXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9653

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


