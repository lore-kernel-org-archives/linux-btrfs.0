Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795686526;
	b=qCqfxRN6NEM5fK01INGrFSSEtPnFQmzHHb2jKurzZUFhIAxwajEDa02Wf2Uq0R2frKEv
	 zGQ11qNnfPjGMoM6Vx9EKH+1hOtTYyspZpis05nz/OUDdxRnWRCW4rp27soSVbPSJQnOL
	 h9wRL1/0cT2+cXH/QJZq5Kp1+NvkCVDzFX5Jx2Z4IQU98XZB6BGFNihJnO5jfOZwTcIIE
	 3XnwASyFvuSEKgjNqVTs/CtZnKkc8DvPhHRXq2lj0lSwze55TlUM55QGaJlmPzm5Ve3z1
	 lI9BL7qUx8DQppOmpDiUoSdA5CaJ1nIRyGLM8lAxsZ1efEDNmMYYwFquPXfYmBkRFWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686526;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=P0kW8Bc08FXaBIA0bY6zf/s50S343qSkkGlZ4Jtg7vY=;
	b=nXxOB8hIPn4SIeouSqtbseMFP9D0TsIIRAJyUranLwmQ/qZqSnmiXZODmDwQ4MllVlUV
	 7Q4MGSAzVOsJpbN7PlFwN5FEJWYz3uGWjR8ygLP86npMjffutz3FEcQm2FitzEvjO4gG9
	 B5SbrL4HZoWUydO4f6DpSMHGE7zd5EKLglmrs0l6z0s1lc6l0s85ReK4iVmYWgTHv49xK
	 f+uveT5eQmWXA+onwusbKWNrAXTjGV5Ebf/zRVVnus+LUmyenp3KHNIcrq3X3bNqGQJfR
	 ulg0rk+zaB5xblXo3/jpDf36v/a6aUbtQRzeIemVeLsIe4cU0K1sd5to9pT+s7k2nBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KEI5DqlB;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=QQFekrId;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C6A606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7C6A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KEI5DqlB;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=QQFekrId
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795686525; x=1827222525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0FHRsOokiP9CiFvcWbbLnzG4WZ6pvoLcdDXUBbw8DS0=;
  b=KEI5DqlB3lBTZDohvh2ukeN8DFVOhi3KUoZD/HWaFP3XxXfw75pnXplR
   OjaYoDPpPpCJofUK1iIdJFnA/sh5DqP150H6mw7nBQFYeqtQ/pLv3Clho
   DyPjJ0OnEVLr+gzKWrt3B2t/fEeN9m06bI8fIJ1jWpzltv1lHzNvZOOpx
   8XkTvlFC7rj1j70fbEV2aybg8TZ1IEuxesrz44w8SVLJ5GQ8xIlauu2+y
   8oGg+sU9FSjCyW6LgkNhDyTvaA8P1+RoSydUNH5JW3gjyrFLSSnYSNy46
   awRjB954hYJngwEdZ4MexqUN2odWSWRu6/lyAMOmevuHFpfRqzua/m/7h
   w==;
X-CSE-ConnectionGUID: /fFRQmwiST+VMOyjZD9YiQ==
X-CSE-MsgGUID: XiV/+p2aSwS2EXz75XGNlQ==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="161749089"
Received: from mail-northcentralusazon11013066.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 17:48:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vEoWsz2QLC274kCqLndot78RNWBn07DANL4mb3wZ158wVe6QIbtN8gXSuWqHlic1wF5D3TH3I+wf2uAhNAw2yAQe29njFh6oB6SLcgK7GoCTi3rBVhpp5kL65Juu91dsannO40VuvkftH5eax9svq0YYxETrfsuLKC1ot9BkSgXp449KwGVvuGCYl7vuaA/I690scpQb+XcyIqS6cAmu76x7okpxuKbLgkmbPeKlt010ygFfCzduKQ+YcZyI+OaL4K8tyte4ZlrBhzfBK6i7Ygve2dpBIA3SnZUdpcrtuVpI5qYgIUnMCUiK6Tem/7S+4Np1RmSnt1elKiBydNUJ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0kW8Bc08FXaBIA0bY6zf/s50S343qSkkGlZ4Jtg7vY=;
 b=Ip+VJ067h45HXgNbKuuAh8PFFws0pJ+ArAJ1Pn90VelDM8CaMq1UFXadMaJfr3/YPv5HOdPaUFN0jtPrMGlPYYkxAfIxHMh9/KCnyieiLdkXvZFRDFqI1oz4VlU3kBcHzrOSRILeErm7KgtA4VhBWpXYZQl+bWKOkQZ6liNglBvLzT5rGDTJj3htjUAo10UTbIvYQLUXXbvnPSVTRTvk/chxM3oktcoM2RZlccYCfwVnWxo7mzRnqumyPcDTSjgvatb+tzSkCQ6J7Wc3wOG27gydrEPOEfL7wlhMW86w2NvqvCUd7eUOQPSRTKFNJLxuUxK4RPJpT4r5z+JXm2Pl1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0kW8Bc08FXaBIA0bY6zf/s50S343qSkkGlZ4Jtg7vY=;
 b=QQFekrIdIYycFhohlxiNMKSd/EAqAWThN9X2GH2Yef4nMe7etwBvvOhmURozgy0BcSwG3/FC4Uw/Pj7DPyczHuJ4nCbXmnlbq8UF7OUV8m00iiXhzyh7w680uYxuhlNLnbI9qkFzwUrQOJEQpeWce3AXkYIH8QaPN1438PBQgoI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB6883.namprd04.prod.outlook.com (2603:10b6:a03:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 09:48:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 09:48:42 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Mark Korenberg <socketpair@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 4/4] btrfs-progs: check: detect and repair exhausted zoned active zones
Date: Thu, 26 Nov 2026 10:48:15 +0100
Message-ID: <20261126094815.479691-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
References: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0182.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ef3f165-71c8-45cd-04ab-08df4ba274a0
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|376014|1800799024|10070799003|11063799006|261009223027099003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261022105027099003|261022075727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 wShfXfPfXrIGlJ6iVtQqQcyXqaCgxwU/csjxyt1807fhTnLmZ4xZdY4V1+zhiOWamr3mtm0KyPlMjNgCXogczvnZ+dd2MglvzZRmiqfce9jzNefuF4Zw7u6N8LdesUT6fhwKftiAys0F4dYaS/OZISmhAPHKFDcCfTmuuxfG1dXjXUQWlI7Jd53cRvueEOTa6bpH0CpWcFAw/ZSCazqI0+Y5oqrPomJGuHNrEd32fTZKKh2vIYVpumMfKIYv2TdzdT3agJJRD8Ny0vTufiGaD/DINcIPas4tLyS6B6+R3dBf8+wFwY/po9rIFvsqNDgXzMVnocN/cptK2m8cFVnqq70c2BlNH+f7cD//8gO4PqDzVZjfrtr7Zo3JA9rEfT14HKECmZFsTLfj08vWaV+T9f05MyDdj+XuP7Xr7L6HpdWDfwZ/0wudrPz8ct4+iIYLHps4I+7+mDQ6kjwHoZwJYfN33RcaikX5ppdQIROsyiO234+VfWyXTSBe7IT/0U5gUX0//MZ6H4vK8NpBoeU5cJItZnj8d/1qOwqHd7QG9V09nGYcfPSZZMpoz668JckAg5Pyl/pA2D1ehqlQ8CuIY8nY24rDBImtU5nubn5wM/gDnGoJifNnoMP9ZAp22Vf3Kf1CP50gHrjomNYNjIt7lHz5Z6iZfRF+LdggsescXCg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(376014)(1800799024)(10070799003)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261022105027099003)(261022075727099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?8o33DKLN5SJvboTsYM+SjPbw5Dbss1OXRtrRMKx1sqFD3w9vZIj/V2lpNj8D?=
 =?us-ascii?Q?Vn+OZZuRuuWKsBV5VggpogscGOPZwvpEyTxKeO6pAE9V/Zxygiov7Tdh7fok?=
 =?us-ascii?Q?/Wk4TpG7Aw5CkJUHZ/1fpuSnMPeHCfGvDZ4RM0L2TVV4H5wyPdt4T61VWmUM?=
 =?us-ascii?Q?YVvBSS5Sy7DPuoOGNVBiXnV6TXke+FGbogD+HOuh0X8j29gStG8JLVOwWJzl?=
 =?us-ascii?Q?oZHCN2bkOFu7mH8VJBJzBnQaCNYgG9ud0dnllMOvvU5IP/5QgwE02dkmDgRO?=
 =?us-ascii?Q?aOMtUog7fY7+Kg1xasNWKIAT8l7EEAk/ymwWfV21BBsD/qxDFBWaoRmGva3a?=
 =?us-ascii?Q?YwpFrwP1Ni4TQOZv5lu/BW9nzB3yJiUbqAanqP44udS/MziEtIXZa+w6Xjlk?=
 =?us-ascii?Q?9gqvxDX7juL5fReoinE7kIadKc7k9tXRANxamHq2+idIPNHEGB2WJEDrDuLA?=
 =?us-ascii?Q?dGaA9+HDPkV0vvL8Yf4TUqgU2ZFcjBwX2sZZputlkgsFjTloazjqjJLSlneG?=
 =?us-ascii?Q?eCoxHnTT/mVe1MNBCNtI8E1ykuQoyjycvMI5IBTf8lgcwTWbQWvk40Wpr7kl?=
 =?us-ascii?Q?tjeNLArJUU3y6s2fR0DEAX4Vf202dtX2BZP2tKjAOqth0iWwwvxeLpYkKEpM?=
 =?us-ascii?Q?MZ3VxcjRyDqKAMQUb+Uw1Uob3fFWrDCvrMVvtMG7T58e39PNaT+Sm/c6WsOP?=
 =?us-ascii?Q?RTiOj8p0BIaeBHcPLP7FMMNgZyRrhBN8EJIGb5bsMp3B4WvGBaVDIIl6PXOb?=
 =?us-ascii?Q?0ktBTqa1M2LC2kpSKqUVFuRmAd5Bu0yEWsvgVFpypel2DUVg9Evl2y55+y83?=
 =?us-ascii?Q?K/CGohKCHrX4SumF15cgKRPVu1UXPGjHZAdwtLZo5iyd3Wzzhz8tx/lCtqZ6?=
 =?us-ascii?Q?IWUdYDvQSR1wdXEeI2R1JO15Nio7ueNEb689jVdh9Ar8yt9O/8hyXsSWKPwt?=
 =?us-ascii?Q?UDgPfRJlZDXJJnIwu3s7z+RX0QHpwKTQbCi0FexwV1TMT7vv8+QXsjOpk3yp?=
 =?us-ascii?Q?Cal3v5egQuT10HnPGn7cSLxytXP/ltVM6nyMvps3W7yPoGz0A+VouSOxPiNr?=
 =?us-ascii?Q?c0PIRd+YR4ffOyv3oAZRforQxLqmWTaoHA+5D4EOzYMocSGctVILWdU0TZLa?=
 =?us-ascii?Q?Kz9KgV0OVuR/lZKAWHNVV7WDUxsjNDfTK5g6rc9Vj3uX2v4dirTQYG61YWYN?=
 =?us-ascii?Q?B7d9R3WvA1+ZG8klX2GWRvGlOs1kbZc6LZP6AYbNR5OLoOSBZG1kf06Y5ema?=
 =?us-ascii?Q?UrYl/li5/byNH0LyAG/z44wiACkaL/AcAIAkYFVTczz8wEvM70jcW++Fm0fb?=
 =?us-ascii?Q?8skqGd0RYHF4pZZBkYk8hFd/3qHH2th1g2hZdzDVE6MCzhpf0pOsz6iGJTej?=
 =?us-ascii?Q?v9ugQkXhWrwLBQXf0FguwmpWyRmyT4/6FbYyKMVh68YG6RXf6SBM4qUxKnD6?=
 =?us-ascii?Q?NdEVxxFBMHitZMK2p0DhXBeo4LP+lPEOe4052okZYllrBEW7hzUyi/PlGXGU?=
 =?us-ascii?Q?NbwiCZ91xyiTtx9pB0njCVCOb7JtEU7bHKSnV4yRVodZqcYFJ491QufruIXn?=
 =?us-ascii?Q?at+7p0WAWoCGNP8r+uu1T0fXnxXF9m5BKPvKkQYX30CVw+y+y5LS/BMv7q2O?=
 =?us-ascii?Q?6IC5Zy1W4zEu/JmO33HTnPcuwVZsg5D7oX4e2uK2JYcHDNVlp5wSYTNWXW3/?=
 =?us-ascii?Q?Qb1ysnRMwX7f819krDgO5H4a0SCy2/QTP/LGV9dThfJT1xf2FpDUW0Dpa17U?=
 =?us-ascii?Q?PtDUO72Ok8ZAxa9l+Nviq5JzPfUbz6Lrtx7GuXq9st+J/k0WFEG3dwrtce41?=
X-MS-Exchange-AntiSpam-MessageData-1: EBgWF3fMqetGxOzK8qjAG/3JnUnCwKG/wYg=
X-Exchange-RoutingPolicyChecked:
	Uxy87TUJwf5+QZWb5kN45XuxfLpIJJ7SRXafwlJJXkuB7iSsIhYNdLJoMr3EavK85Ju1fyyYgCvtkDtBxWRnUwrWPoonDS+rFoBXjoPOM+1VThyUwkVNpoCj4V0bXZoTn8LA3q4PGG9Hu2lmA/moZIQuqM4LQwWeTbmQ5tYrp9GU91ByZVLwK0L3Y5aoqswnS36Na8268UzmVw+fLIUzxg421ix4JmidUzDmMXIG0utcaxlbyX4neO7+RjyTXvTaENXfpAjimxL81f57Vil9MR9EG49J00NhlY9Gsmnpb5uz7gHb5EEXmNwJouNGPEvmCf1d2sek79UrJs7WRvW/GA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	COObNd4UI2o4IdP9MmDH5J7tHd9oW7JG3yOyAG3pMD0r5XpyedA3hNrr8c8tle6Hll0Y112zWq7pAhK5/r3BWPjA1kWx6dierOq0SLZWTzUaO4etwHkWC0sB4jn4NEPIrGfl9B5AKWwDPE5eoq2KzFQh6Tu9ZndbHZFwp2zIMJR5O7L0kSbojjq29Fv3CLbQMhCLkGME9hzY71o9zJNR9cqcTlibnblLdracUBXIIT8/Xssd/D1KFNt9QZsNQeSVw4W2CCt8Aq+Nhk+7Y+Z4ElOp4QzA/XuN9oX/sIHxBrk/wbT+ULnRfMOrmPqs0GUkeljv4dte/4L6RjznRvbxurYhAvdHu6NFxksGx5M0V5RQpJqHPx89LqxVrrD7DWhrkQCJkwk66/kVBAv2KIo0Ri78hJLMKSk1rN+WtX0LCPtz5ZVrt9P6BHdqg478D6AmarGPBTJKD6hAhm8au0A4mcBC6atZx9PdfGSIYUiS8cqLJAZbdEoq0GZKE0ExZnpunb3gHIMgmZOJIEc+ws2GhpkJSeTq4YQK/F9VKS0n98UmureBQq5jDIyx7ucwD55MDhtKzxIbkg7485eTwsdtR85yBJxYhXWCNIVZ1cNrWh1Qh+FKmDS6CC6vJruPyfW6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef3f165-71c8-45cd-04ab-08df4ba274a0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:48:42.4506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZcG/7ungRhtFAJ3fhdoHionSBkRyrqUNaeE/trYSBiGl1kAcPWrCJJmJZMBaMuUw7iywD0kxlDFZ//deO+cQ/+XSm8fNM4dCTxXI8tPkL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6883

Kernels before "btrfs: zoned: don't release active zone reservations
for conventional zones" can leave all active zones to data. The first
transaction commit after mount then can't activate a metadata
block-group and aborts with -EAGAIN.

Report when the active zones in use exceed the kernel's limit minus its
metadata reservation. With --repair, finish the fullest single profile
data zones until it fits again, plus one zone for the relocation
block-group.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 check/main.c | 190 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 190 insertions(+)

diff --git a/check/main.c b/check/main.c
index 717d576f..fe209f22 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9203,6 +9203,191 @@ static int check_zoned_active_zones(void)
 
 	return ret;
 }
+
+static bool zone_is_active(const struct blk_zone *zone)
+{
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return false;
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_IMP_OPEN:
+	case BLK_ZONE_COND_EXP_OPEN:
+	case BLK_ZONE_COND_CLOSED:
+	case BLK_ZONE_COND_ACTIVE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+struct finish_candidate {
+	u32 zno;
+	u64 left;
+};
+
+static int cmp_finish_candidate(const void *a, const void *b)
+{
+	const struct finish_candidate *ca = a, *cb = b;
+
+	return ca->left < cb->left ? -1 : ca->left > cb->left;
+}
+
+/*
+ * The kernel keeps active zones in reserve for a metadata, a tree-log and a
+ * system block-group, and only activates metadata block-groups when writing
+ * them. If more zones are active on disk than the kernel's limit minus that
+ * reservation, the first transaction commit after mount can't activate a
+ * metadata block-group and aborts with -EAGAIN. Older kernels could leave
+ * filesystems in that state.
+ *
+ * Mirror the kernel's limit and reservation, see btrfs_get_max_active_zones()
+ * and btrfs_check_active_zone_reservation(), and finish the zones of the
+ * fullest single profile data block-groups until it fits again. Leave one
+ * zone more, for the data relocation block-group activated on mount.
+ *
+ * Return 0 if fine or repaired, 1 if a problem was found, <0 on error.
+ */
+static int check_dev_active_reservation(struct btrfs_device *dev, int reserved)
+{
+	struct btrfs_root *dev_root = gfs_info->dev_root;
+	struct btrfs_zoned_device_info *zinfo = dev->zone_info;
+	struct finish_candidate *cand;
+	BTRFS_PATH_AUTO_RELEASE(path);
+	struct btrfs_key key;
+	int max_active, nactive = 0, ncand = 0;
+	int shift = ilog2(zinfo->zone_size);
+	int left, need;
+	int ret;
+
+	max_active = btrfs_get_max_active_zones(dev);
+	for (int i = 0; i < zinfo->nr_zones; i++)
+		nactive += zone_is_active(&zinfo->zones[i]);
+	/* The kernel disables active zone tracking in this case. */
+	if (nactive > max_active && !zinfo->max_active_zones)
+		return 0;
+
+	cand = calloc(zinfo->nr_zones, sizeof(*cand));
+	if (!cand)
+		return -ENOMEM;
+
+	key.objectid = dev->devid;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		struct btrfs_block_group *bg;
+		struct btrfs_dev_extent *devext;
+		u64 pstart, plen, chunk;
+
+		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+			ret = btrfs_next_leaf(dev_root, &path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0)
+				break;
+		}
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.objectid != dev->devid || key.type != BTRFS_DEV_EXTENT_KEY)
+			break;
+
+		devext = btrfs_item_ptr(path.nodes[0], path.slots[0],
+					struct btrfs_dev_extent);
+		pstart = key.offset;
+		plen = btrfs_dev_extent_length(path.nodes[0], devext);
+		chunk = btrfs_dev_extent_chunk_offset(path.nodes[0], devext);
+		bg = btrfs_lookup_block_group(gfs_info, chunk);
+		path.slots[0]++;
+		if (!bg)
+			continue;
+
+		for (u64 zno = pstart >> shift;
+		     zno <= (pstart + plen - 1) >> shift && zno < zinfo->nr_zones;
+		     zno++) {
+			struct blk_zone *zone = &zinfo->zones[zno];
+
+			if (!zone_is_active(zone))
+				continue;
+			if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA |
+					 BTRFS_BLOCK_GROUP_SYSTEM)) {
+				reserved--;
+			} else if (!(bg->flags & BTRFS_BLOCK_GROUP_PROFILE_MASK)) {
+				cand[ncand].zno = zno;
+				cand[ncand].left = (zone->start + zone->capacity -
+						    zone->wp) << SECTOR_SHIFT;
+				ncand++;
+			}
+		}
+	}
+
+	ret = 0;
+	reserved = max(reserved, 0);
+	left = max_active - nactive;
+	if (left >= reserved)
+		goto out;
+	need = reserved + 1 - left;
+
+	ret = 1;
+	error(
+"zoned: devid %llu has %d of %d active zones in use and %d reserved for metadata, the first commit after mount can fail",
+	      dev->devid, nactive, max_active, reserved);
+	if (!opt_check_repair)
+		goto out;
+
+	if (ncand < need) {
+		error("zoned: only %d data zones on devid %llu can be finished, need %d",
+		      ncand, dev->devid, need);
+		goto out;
+	}
+
+	qsort(cand, ncand, sizeof(*cand), cmp_finish_candidate);
+	for (int i = 0; i < need; i++) {
+		struct blk_zone *zone = &zinfo->zones[cand[i].zno];
+
+		ret = btrfs_finish_dev_zone(dev->fd, zone);
+		if (ret) {
+			errno = -ret;
+			error("zoned: failed to finish zone %u on devid %llu: %m",
+			      cand[i].zno, dev->devid);
+			goto out;
+		}
+		clear_bit(cand[i].zno, zinfo->active_zones);
+		if (zinfo->max_active_zones)
+			atomic_inc(&zinfo->active_zones_left);
+		printf("Finished zone %u on devid %llu, %llu bytes left unused\n",
+		       cand[i].zno, dev->devid, cand[i].left);
+	}
+out:
+	free(cand);
+	return ret;
+}
+
+static int check_zoned_active_reservation(void)
+{
+	struct btrfs_device *dev;
+	int reserved;
+	int ret = 0;
+
+	reserved = (gfs_info->avail_metadata_alloc_bits & BTRFS_BLOCK_GROUP_DUP) ? 4 : 2;
+	reserved += (gfs_info->avail_system_alloc_bits & BTRFS_BLOCK_GROUP_DUP) ? 2 : 1;
+
+	list_for_each_entry(dev, &gfs_info->fs_devices->devices, dev_list) {
+		int err;
+
+		if (!dev->zone_info || dev->zone_info->model != ZONED_HOST_MANAGED)
+			continue;
+
+		err = check_dev_active_reservation(dev, reserved);
+		if (err < 0)
+			return err;
+		ret |= err;
+	}
+
+	return ret;
+}
 #endif
 
 /*
@@ -9219,6 +9404,7 @@ static int check_zoned_active_zones(void)
 static int check_zoned(void)
 {
 	int ret = 0;
+	int err __maybe_unused;
 
 	if (!btrfs_is_zoned(gfs_info))
 		return 0;
@@ -9227,6 +9413,10 @@ static int check_zoned(void)
 	ret = check_zoned_active_zones();
 	if (ret < 0)
 		return ret;
+	err = check_zoned_active_reservation();
+	if (err < 0)
+		return err;
+	ret |= err;
 #endif
 	return ret;
 }
-- 
2.56.1

