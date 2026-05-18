Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF113ECBDF
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 11:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779103030; cv=fail; b=GRUqBZqQM2u9JqQWoI2Z8afmamndQ7kuDb9seAkvzYJspxPgbmi4TQPMu5/OxPMb8GWSKRiRRdoyZQl4JHiWoV9ZIHIJ2l3G4bK2a1jLElGj58NYkZU7T+qryOLm7WWVo3oP5G4IdP7Gkl7r1sVtHFC/1EHTVSnVnJNXhmJrlGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779103030; c=relaxed/simple;
	bh=4W+KqEpqpUUvDcpf4zyIgpF3tw+ByV9NxldHpxQwV2w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EFefixDcFNDapKzoct0MrDc10jC6qL8mqaG71g/CFFZncPG0YtoL6z9yCi0zuiVqKn9noDHUBvL9bb583BLz3/4gaGXu1iMow6OdgQu8bb2tr3pHq5P27Ilk9IWbW+8LAZd7Rc0e4TtIScxucZD2HRFJ7XR0Hg0Ys//YF0pIE0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WV8G7HN+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Vn8C3/WF; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WV8G7HN+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Vn8C3/WF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779103015; x=1810639015;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4W+KqEpqpUUvDcpf4zyIgpF3tw+ByV9NxldHpxQwV2w=;
  b=WV8G7HN+3H079iDxE9SJpir80GGdT7nf+feuzv5rYN1p0usUKWY54W+S
   hIDEbhgBkg7RWB9pcBshIhHvXC0sDb/a3Cdo0/b6Pr5RGc8q46QYpQ7xl
   pgfBoi0m+qZzC0A4kHUw/bIX4affEAlGFrQCkQhpJfD/AJr2ZsRVSZoQT
   aqt/bFdx84TRJbV+3/uMaLTx6ZYkxnU+mKVSwBXe91gd+o/XX8KRkxHw8
   jyk3XYqwHdfxpiKeegxpZVNv1NOcjMY58+Nf5GIecDNbXk/q+0WpItZoM
   p/XhLSmBtCHfuDQmoLQVfSp4LcVUBvHECPPPe+VHR4L7Cg77KRfXdLTdG
   w==;
X-CSE-ConnectionGUID: PdjSMXRPSaSDEc1J8hFVfw==
X-CSE-MsgGUID: sZ6ixIMWRDK1TM36xA/yYg==
X-IronPort-AV: E=Sophos;i="6.23,241,1770566400"; 
   d="scan'208";a="143045669"
Received: from mail-eastus2azon11010048.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.48])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 May 2026 19:16:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YjobUlxEksfaoXvyoZz/Q0xliC08xM+0dhYxuR+04wClSKj5uz9ww5OJQwzPFP3S7Zuc6oLDUjHpUqbOngcEgw9Cv8sWhY9FzrouTvMlqGdHg4nGzh0QGpvvhyqygFWLzIi7fsUoJElxjewbzpBJz2kR+1vtuzsAYgZGMnPrywR+IcxR/7Mxtu2rOk3fPH0d8v8s6vP9CuepL+N7XNq5p/3UW/I5yTc11mwenPwDViGIIvJ4GTEVi1SEaeC/6gyTMa6lKmuaCWIUJsWUrkCAbvyvNtOKF9TnuuI3SpneuClNrn7oZgrhTcbvnzUu05j55hipNbrltYbL4x8oTOVbdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XnTc/e7CYCiWaIbbgHdBpN70WA4OB3NSd/Id7C0hNj0=;
 b=OO1qNVlgFJtWHefEkOt68itFqV7FrJGiaeuxeCcfcuoyGqCq+OZVxBFnTdtcyiOAaeY69WNoGmpyJVR1/dZmgbeRd/wZ+VUyl5uSNbXTAsuFuEf25FMdQ7zwaIw0dNd6rwULZwmoRfgeoEQOaJgRat0aambOJRNmXhWzhN2pW8YadL3+9iV/Kpnl6ohqOJoMsuHGNWgVkK0xFu5eRnKNLwyaeXjmKCHQVIxQ4b97VvrTiupG5Qi9phDuK/fA3YVJb72O5bcsEsKyafB+nuKzY1QnhesjKqQIs+TGEbMlQRT7a0w3HdYoOBbpbmxceVBNW2dvfIcT+4p2ncmuFBkHtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnTc/e7CYCiWaIbbgHdBpN70WA4OB3NSd/Id7C0hNj0=;
 b=Vn8C3/WFWtxeA9Ab1QNwNSA6IRHNkXCCU6HqQGTDttZzj6kI0l/DowxMTH2M7Nw7tk7JODZ/pGQ4/8PbD0tzY+56gXVTifprxGxpsFtaoxjGDxHTLLy8dxWhoj6ZagAAIrJqKOv1m4SXdxzvhrEE9RGlidEB+dbmRWTWvWCDGWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH5PR04MB9523.namprd04.prod.outlook.com (2603:10b6:610:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 11:16:49 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 11:16:49 +0000
Message-ID: <1b9193e5-47d4-412e-97d2-08a718f73111@wdc.com>
Date: Mon, 18 May 2026 13:16:44 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: always set max_active_zones for zoned
 devices
To: Damien Le Moal <dlemoal@kernel.org>, linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
References: <20260518095503.132430-1-johannes.thumshirn@wdc.com>
 <bd7d1f30-a6f3-4497-b584-8b81db6599e1@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <bd7d1f30-a6f3-4497-b584-8b81db6599e1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH5PR04MB9523:EE_
X-MS-Office365-Filtering-Correlation-Id: 98fb9608-e1bd-4d5b-4cbf-08deb4cef447
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|11063799003|4143699003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+jUjmWW5leOUYgxEoGcUIbRliPc8XZZ6HUv13/5tev11A2m+eqg1Jfxvtoemgs0a0kT4ftYkRnvQd2Xf41+JOJAZhkkFiuQxyntcA7SjtcP83NdyGSkp+oDsZrJ+FnPxfrJI5HXz6MP7eB15fQugBuBb3rhK/sRBoZAu0X39BSNQgK/HEhvVt9QyKAmZzkQw2JgoXbT+GWisw/jedDLqS1ukDfZqwUEQLXc2XmM+ADSODUP4cvyCsehjD1sdQGNf0ur1OWCewI5aWsgteef6/jIiQzkQbE1BKIn02r8HAjFsEup8JHmR5V+jgYQKVqhQ27/0vH3I1VUDYLwNWqO0bJ2wGTU46GvUy9OIP2NqprVlFmDMDN0YRSSgQ6NK/LHYCcPbKMSeCTRxk8NxDb4MxvTMh0I5v8d+wo86C+4LpuDrrmnhhq/PhKTw26VRlm133CtDzrA+IMSTFGRUo4NixxPRiVVupY04fdnK42Dkr/Ww1TeiK8qgPS1FIBfGCaNGXHCnPhwGqQ8xQHZof4rPCDwfhhReFBsUpp+jyNCDzskNufpWzj2as5b13k8NnLsR8l7IcbQDmKEK/Mb0w/cZOPR+FR1VPQUqdI6YphJCkqipmAEcxuLcGcr5Wjcox6L6EfkkR4LNZko85m/O1xaokGjMxhv3KmUdY+hyrqxfsDmE7XOtfq28DUBA2IDdQxqH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(11063799003)(4143699003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blFRY2wyY3BDSGZVL3ZIZjRubmpKWUkybnNMRVhpT3V2UGl0czlPMFB1ekI4?=
 =?utf-8?B?RnFhOThxNXpTallTZVltbjVUSHhWTUx5L3Z5U04wbDQvMlRYRVA1WWpXbmZn?=
 =?utf-8?B?ODVFbHZORjlRdHlXR3NxYmcwVnoxdTIvaU1OT2Nqa09pL3FJSjZyQS9tdk5t?=
 =?utf-8?B?MHFGWjNwOTJ1bkhMcGpvbWZZUmxRZUYrZ0Vnbi9xTDF2UCtaVlB5eElhTnBR?=
 =?utf-8?B?U0dKc1h6ZUUxNEUyL0RyZEd1aVNIWmdlc1NONjhSWDZRUDlhT1RQK3o1VytC?=
 =?utf-8?B?ZXFZdFMxOGUvZko1c0gydTJpYW5ZeUpJYVpTY2cyTkFjckl2Q3Y1SHUzL3Ju?=
 =?utf-8?B?OW15THhlUlJIOGJxdWp2TXRvYjRhSHB2VXFpTjhkM0dPNERzd3k0WFFOL1RJ?=
 =?utf-8?B?V3BZaHIwZ0xQME9vNXVaY3ZETGUzS3ByMVpWN05WMlQwbzk4b3FpQXV1SjF2?=
 =?utf-8?B?eElzdVVwbHNhVzVsQmxxdUE0bnBKMFVqSU1PN29zQ2ludmZobGF1WG8yKzZ3?=
 =?utf-8?B?N0tPVEVsUDJlM1FSS3A2bnIrL3VWdmtFRkdNTng0YVFtbkphdktHY09zYzg0?=
 =?utf-8?B?T2g1NDZDTEk3aDNrWGpqV21KUmJnNUVyK20vRjc2cGVwK2RrZ1g0UU40alJs?=
 =?utf-8?B?Uld6M3V1dHZYY2kyem1pOUM4TzN1Uk1RYUR6VkRMa3R5dThPQnNLT3ZhSGdj?=
 =?utf-8?B?V1lhVWZ6ajd0bTUrNTZFb2t6L3NtMGRtb2FJM0I2aHZZRjBqRkxQVmZ0OVgx?=
 =?utf-8?B?S1pRS1JROS9nN2Q2NUhMcU9oNzRrUHFyUFlLVnE1bDhlZlFodWNvZG5xZDNw?=
 =?utf-8?B?eDNCclpwaWhjQ1hVb0J4Y29PdjdYNktOMCtRczlDb0p4dDZiS3d2VS9oMGxl?=
 =?utf-8?B?R3BKdkR3S0pmQ1pLT3NHSEIxMWNQZURGK25KTUw5WjZKM0lZY3VqVS83eXNQ?=
 =?utf-8?B?Wll4MDZTeTZiMnN2Ty9BZy9YZUozV0ppRVczaHhFODNzYkFDNmc0aitKZ09t?=
 =?utf-8?B?MFpDak93WjF6NC9RanBCKzhWMG5pQnBKK280RGg1czdFeFBLTzh3RWF1eVgv?=
 =?utf-8?B?c3hwVWFEdmNRczlTT0RsZ2YwMGZqeEV5ZTM5TC83L3Rpay9GR1hHWDBNcUtW?=
 =?utf-8?B?K1BzMG04RVJaNTZCaisrWldlb2Y1QnlOVlpydXYzeHdXTnJ5RUFPTmpvM3I4?=
 =?utf-8?B?NDFLZFlHdUJQVHZmVlEvUWtCWGs3Qkp6bEQ2d3JURHh0N2VCWTl5cHVGNUNr?=
 =?utf-8?B?WDJadGVsUDN6RWxYRnVXeFlyOHcrcXdvZWVWZ1VtblQwK2J1YkRjZkNIdnVQ?=
 =?utf-8?B?U3ZuS2xUTDJjL2NqOGt6UEVnTEVlclYyRGJjdXhma2hDMWs3NWY2cHZOL2Nu?=
 =?utf-8?B?NEVzVTNKKzFKbkdORVhJVXNmaGY3R0FMU2pJa0pMdHhqZ1I1cGcwYUNlR1M3?=
 =?utf-8?B?TXc0RUdhL0dqbWU4SE9SOEszeXlkUmdIaDREMEZ1ekxtc3ZXOU9FUzlTckNI?=
 =?utf-8?B?dzRONlFvOWd1S3BXSFhBSURoUDZBdXhqd0M5bWd1ZU55Uk9MdHVJK3IwVGFv?=
 =?utf-8?B?L1VmTGpJTFg4Z3JUQmlDYVl5dHQxeGttUUZocjF5S3FmZ2NvbW5keXc5QlJ2?=
 =?utf-8?B?aWdTODR4OW1DL09oN2VNMnhxZmhvc0g4SnJMb3ZKWjZiVjVsYTNQZGtBNldi?=
 =?utf-8?B?a3pUQTJBa3poTy9OK1ExY0R6T1FQaWV3Z2NHeUVqa0hqOUZyWjBLRzZxZ3d4?=
 =?utf-8?B?OEd6aGxESEFwS0dZV3ZjK3NDVXY5YkxseVdtdFNBNjZtK1pSaHE4Yi81WVFP?=
 =?utf-8?B?UFpWem9NYm1BVHNsSmx5d0krbXlSeVNSRFNFRjNlWHVkMEdBeVRuazNFRVB5?=
 =?utf-8?B?TWMzWVcxeTMvaHBueEcwbnlRbGU4S1NhcTBuSlhQa0RqRUJjNFV5S0t4Sitq?=
 =?utf-8?B?d0Z4a3NWWisrLzNzeUxjVzZLOTNOTyszWFVLbGN2ckEycytsUnVlaVFHanFG?=
 =?utf-8?B?ZkhFVHNuYk5TWWNFeUlFNFVKREd4RmMwTnBDNndnVU8yL0Mxbk5TbFZuT0RB?=
 =?utf-8?B?TWVwK1JxcHhPRXpyZzg2bUlwYUVKQnMyRk5rdmNUeWFMZk1ZWnB3VEFhbFY0?=
 =?utf-8?B?Ynozci90VVcrZGFyK0ZxLzZCN3JtUDlZY1BJZHpaVWVMS29yemVoQ1YvT0tM?=
 =?utf-8?B?RXI0VVV2UXRzMGFnT0p6Y2orVEl4cUhVSU1xYVNJOFhQQWFoN0xTV1dHNGRq?=
 =?utf-8?B?Y2dzbnIxRS8ydWl3QTRCV0RnczkwamdLZGlTOTVqMGxkWlVJR0pjTHZ1TWY5?=
 =?utf-8?B?d20yNGRoaE1hb1QyMHBBT1ZjK0Q3d1VkT1UvQnBEOUtlWVRtb1BUdFE0VUtm?=
 =?utf-8?Q?5HU31ZnngZDLOLlM=3D?=
X-Exchange-RoutingPolicyChecked:
	ThcPw4kuB68FghooSQiz8BYM9iPT10X9GB2SZ5NjxVQ2gIGbvmO1jQpeUC7hwhDQ1R/w/EoDsfIszqua0cfbr6+LQgPmqJWF7fQ1sG+REHo8EXlMw756YgnEA2QDlrw5lIZ1j1GGc0Ow/ABCiP8V3Qx340b1ySu3Cfd9E12c4ibfNdiQxWM9zaMkNsBwqNB6xQP+mYVrsra8BJvu8/eTNKcVQh5OkGCSLnxKkHHbh7c+YLX7SySTKddJPj6pNYUx7p+ibGhi/FfoU1w/5bcvPQta2jv/XdNPqlsEbOMgBvzBhlY65Wh8dkcRQKRKV3pQeOzY3XPnQXr+HfvYczN+2g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nv0pM4dSuNpW/MuMNwhMW3SmFDadI0qxOQd319/ntIy+YdJPcD3yhCMvBO15covjMCeuyLVYKOYCepajknxgC8pcOcj+IwhH5qGcfypgxvGsgEDpXYhd/GkXY4YXtM1N2paLcx6Izz1N3sc+/v1nTvSjlmYfmvK2OE1DbPLnrinsFz64jNnkpbBHIf2bmqSgoKVFsN/kKpp1UpgiSJrbc9feV8bLyq/X7w5t3A61WFqoWxQFA2BeFYPCl0Ho4xbxp5nCbigUpP4yn4dhdFmF9SEXDM6i9B+82C/HXpR7EtlYpoJAH8D7gdAPqBATwYJv4wLAtj3EjJVnYqGIaYo4Xx3YCEUx6qi428dxsQKkh8IbpallKF247qbWVFTCdT+GLcgHkvDrWRR2/O6sepW31rawBMUDVyGrusb56S3dQHWkjhr2hdgaHw0iFlYuvXOi3phzmwnUTuQIt/3K5LcqoETlqqOyglA360gzTzCmuBtOop1de8Ne+SWPUEcXVeR3l3HUXQRmAjjICOpOl5478bZRnql0n2FNGkhpT1AlO2LQKOeykrYxgbp+RMrJDnankVsUH5DHI+ly8U7YLbTlp6aLQoYTZSgr1C8YZV+OoPOvLpZWvXHBxgkuc7n7c2Mv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98fb9608-e1bd-4d5b-4cbf-08deb4cef447
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 11:16:48.9815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpcdiZCqK3egjT23eXaNpddRhdQmedlHgp7I1sFe7xMeILmlgsnZlLH+gFyftz/DT6hojTEUUcDTCGp9RYKS50kXXkwEjgLx8eoOiC0X9Y4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR04MB9523

On 5/18/26 12:09 PM, Damien Le Moal wrote:
> On 2026/05/18 11:55, Johannes Thumshirn wrote:
>> When a block device does not report a maximum number of open or active
>> zones, btrfs currently assigns BTRFS_DEFAULT_MAX_ACTIVE_ZONES (128) to the
>> internal limit, if the device has more than BTRFS_DEFAULT_MAX_ACTIVE_ZONES
>> zones.
>>
>> But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
>> internal max_active_zones limit will stay at 0.
>>
>> If a device doesn't report a number of max open or active zones and it has
>> less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES, set the internal limit to the
>> number of zones on the device divided by 4.
> I would rephrase this like this:
>
> But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
> internal max_active_zones limit will stay at 0, even if the device has zone
> resource limits. Furthermore, if the device has a total number of zones that is
> less than BTRFS_DEFAULT_MAX_ACTIVE_ZONE, max_active_zones should be set to at
> most the the number of zones.
>
> Fix both issues by changing max_active_zones to the total number of zones of the
> device divided by 4 when the device does not report any zone resource limit,
> i.e. when max_active_zones is zero.
>
>> Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>   fs/btrfs/zoned.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index 0b80b498fb85..bdd6fac93c93 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -426,8 +426,10 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>>   
>>   	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
>>   					bdev_max_open_zones(bdev));
>> -	if (!max_active_zones && zone_info->nr_zones > BTRFS_DEFAULT_MAX_ACTIVE_ZONES)
>> -		max_active_zones = BTRFS_DEFAULT_MAX_ACTIVE_ZONES;
>> +	if (!max_active_zones)
>> +		max_active_zones = min(zone_info->nr_zones / 4,
>> +				       BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
> zone_info->nr_zones / 4 could endup being smaller than BTRFS_MIN_ACTIVE_ZONES.
We do that here actually:
> +
>   	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
>   		btrfs_err(fs_info,
>   "zoned: %s: max active zones %u is too small, need at least %u active zones",
>

