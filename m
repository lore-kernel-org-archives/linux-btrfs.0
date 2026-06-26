Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DBA2BE026
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 10:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471116; cv=fail; b=sE0xtUL65oh+u6PzYp2vRrXllRQk9FmgMEf/jqXFgqugRRwljJqtZN4usMQthE8vv5wZsu+8ae32p4DAhjvWNe4u4jMbmqqncoUaumkwpileNa0dSdbYSJFy/XLNX2jgiXqIXvQs+/WdBhIZc/l3yrUu9ddN8LubR/yvSRJDUhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471116; c=relaxed/simple;
	bh=QhLeBTjUgK3CRedQeCJYjcPFwFBgpQlTL1nMv3PgxKk=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d5pfnUtJMrR1TZFhHHMtEoPyUdPB4p2AfFKgCDLopPuARNiTk8Yg+CMugDb9sG8oFkZx18UfYGVOe8tya7hr4zT7tK0L0dvrrrFNah8+ORRqkFFdxn4hM5rgxvrusC7BL6wUBNvHVkNW0R6cxcmyr/liT6U7R5RwteABoyXu52k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RcDt63fI; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=0KV1pM7m; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RcDt63fI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="0KV1pM7m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782471114; x=1814007114;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=QhLeBTjUgK3CRedQeCJYjcPFwFBgpQlTL1nMv3PgxKk=;
  b=RcDt63fIcV5tF9n+hedSh+XJBtfqF+/dOPQu76vGEI6dMPPjaREZY2aA
   E9H7R1Z6Ehdyo2k1Qc7KNjXD5Q/Prpc5pe6TDbPKstug35ekE+Xpga/y1
   VYsyLBCg7pnAsW6AjeveWxY12EKFF/YIjuQs5QpS3vixwgK1RS6IUgTlT
   9roQGqkPBHl/6aKMLq4/UPyrxWdojtqxBaphAY+6lcN/ugICB9NIdPd2t
   CFUcr0gKAWKc0onmFpUMsGHDMzaBzQNdwrgzKN4GN4uz/1Qnzgwoor11z
   vuUV0LiZRXLc8WyY2ZxtByESvp0kwevfevaMwuEjPjR2a8rESYDOLr50F
   g==;
X-CSE-ConnectionGUID: tZHFH5o1R+yGj0q0i42agQ==
X-CSE-MsgGUID: /nYEMgYaSxqTsQONDlK2Bg==
X-IronPort-AV: E=Sophos;i="6.24,226,1774281600"; 
   d="scan'208";a="150781043"
Received: from mail-northcentralusazon11010021.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.21])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Jun 2026 18:51:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a0Q761dX279ca4R/dMVehlmYyQM0l4xr1hULIemK7LQ+TKISZO6UtyCtAmP2qHDQz/yI18AAinW+BnLJDwxZ3imYd25khr42RHXUZ2macbOWIp8wsVM+pg8sbnJE8/rTFml7astUGFphyCA0sHK1HIq50fS6aJoZixPDF4CgBv4xBgtP7ffWVZrlrJ2SFQej+C7Iah81bjnQcVXFMQXUMGdujCP1vFiaw46NKb7zOwaJnGm05gE3ZCWb+PtpbazILSeJswoONQ+HPBoeSj+EH95x6lCFn+z5SUPG4hAe8R6puKyrBijVAkcpU1zHzagy9KzWsq0ymPsaF5NQH0MnCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFY7SosYbQPtst+slNAAvA50KaD7iwPn1s4xGlk7G0I=;
 b=e93GX8cf8+EjXV5TP9E4HjI+wRw04bTxHMWlWZJ6x/7Q7+KkDgkuDFkElDdB2rlehP47BUr8NyojaUudQJI6irxpSnxNqr4HUHb6mkbnYxAJaCraMJUJ1Ab4HJI2eqa504fYJxNmb1r1+4Bh72F+SgoXQqhhRi9CCzvAPYnbzOSacWuNT3TsOpd4qKjiXWDKICreCB94KkGBpmVCHP+omZa8DD5R3QZyCaGBaYoSPWoMfgAQS+Hl1WRFuzEeNFQJY+76btU0mkBRR001FXqYI8JY4MMSvGCLCSayDaFIA/zeYGEI7tRZJriJRPp4yIzecVWNqTIP+BLdA525mzgAUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFY7SosYbQPtst+slNAAvA50KaD7iwPn1s4xGlk7G0I=;
 b=0KV1pM7mBrME+ZEBiZxGpwFlqmgZLduMYcllrBfl5v8J371XzLbn95VOLjauTfsoeVLwFzG+7kTJlpS/bCtEQi/CAMn45ekh/zg6EOWHPCFvm8UHOlQ8gLx3T9+7Wap6+K12IDoH5KrRRJDvDTa6oshLA9ZGDvbq/hyUT3rpki0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from DS0PR04MB9439.namprd04.prod.outlook.com (2603:10b6:8:1fd::6) by
 PH0PR04MB8293.namprd04.prod.outlook.com (2603:10b6:510:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 10:51:51 +0000
Received: from DS0PR04MB9439.namprd04.prod.outlook.com
 ([fe80::13c8:d439:54a3:c77]) by DS0PR04MB9439.namprd04.prod.outlook.com
 ([fe80::13c8:d439:54a3:c77%4]) with mapi id 15.21.0159.015; Fri, 26 Jun 2026
 10:51:51 +0000
Message-ID: <4df214fd-d3d3-4e88-b2a5-1a5a6ca4c04c@wdc.com>
Date: Fri, 26 Jun 2026 12:51:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 08/15] btrfs: implement RAID stripe-tree RAID5 writes
To: XIAO WU <xiaowu.417@qq.com>, linux-btrfs@vger.kernel.org
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
 <20260619090211.497100-9-johannes.thumshirn@wdc.com>
 <tencent_276F7EF21CF219623E5C48630C8A64190D06@qq.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <tencent_276F7EF21CF219623E5C48630C8A64190D06@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::10) To DS0PR04MB9439.namprd04.prod.outlook.com
 (2603:10b6:8:1fd::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR04MB9439:EE_|PH0PR04MB8293:EE_
X-MS-Office365-Filtering-Correlation-Id: c6b7f21f-1304-479c-361e-08ded370edb6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|1800799024|366016|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rKO7cWQELUGDfRQKhBXw46KNp6QONd7j3wCmHeTuZud+0DquJeE4IXPI71ej+c3LCppMMAovRxtFOCT4YFq3YlwXImnHu7V4JI0E6bePzJP7o2YTVBJJXy6BYQefyCsmUwU9ZGLKD6CAyTFtxHVMAjdKrdczu25aIqr9zrfp2tRX/suLsikzrhbOq2V/oOCDuFo4No+4jrKVITm50ExGbfml8/okBoeOudK2Q8zBBXe8p5AvKEObH4Pz3PixmhMBjIHJiop5r1fgtsAYCq+1/V1QS8LY9saLM/aNytFPce07djQ4+ck7T4hemGzb10RGk+ntYHdu9wU+Q57IfQPuU5nXwz5cReYjpOvevmgn0vH48ph4jVfav8Wm7KeCfiteG5K9nAZtqjO0UVwhbb8mCDq0LlFecvber/bR4JfnH0WXHaI1tRSoSQSelRh8E2yBi79l0Mf6LMiuhmpW4V4NE9Pqbv/dQmhL5p95LIqrOhQk8P3jXG0X5gg+1tpQ9ie0Qb6YHDE+tSBddLDCqGUdcne8ePJPTyasUrTkBJHiCSZEXaoQ7ffpiLCDTo32GRBTc8TVKlDMrNBKAegt4C7RvWquD+DYU1FtXxDfScuohCg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR04MB9439.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2V0WlpLZ0dzS2Y3SHJkQVNJZkxyM3J2MGFXdWdMOXdDdWxhY3dBZHBVVS8r?=
 =?utf-8?B?K0wvS2VkaFBORXpOQUhNUEZNYWx5SnJqZW1yVXZ1cUpYMFB4QURHbGZnY29l?=
 =?utf-8?B?Qlh4ZGJ5ZzRmUWF0SXR0RzFFaXRseHEwL0o1cjhhWmZCN2NiTkE5ZTdzWU05?=
 =?utf-8?B?azhEK3o2WW91ZWs1aFdQWElhS1ptOGlQLzFKQ1VDL25LaTZPWndmT0ZIaENX?=
 =?utf-8?B?a0YwUi8xTlJKMWhnSmU3L1ZNVDBKYzhVdzAxQmxyQmVXNFZsd05PcytJQ2VE?=
 =?utf-8?B?ZjhOSHZzRWVlbTFpdGdvMWR3NDR6TG9oNjBTOXgyMGhUVExtOExvYk1xWnNN?=
 =?utf-8?B?NyswT1QxRFdvS3BVNzJTNzJ4dXRFMGxUUjFjNlNzU3hjaDBHODZSUHlXYzFo?=
 =?utf-8?B?MnQ2YzVvOWJXZjdlSUVRakU1c2JocUEvNC8vVWNvRFNONWw5c1N6QzhBbHlr?=
 =?utf-8?B?bXBsZlBqZGtxWkM0eHZxNE5LdXJoS0Z0TU9ld0FmWFJnTlRzc2VjWWF2UzEv?=
 =?utf-8?B?ZzlMSVBaVStoWDhJYmJ2aDY5UXNDMzlEZmdRVEtHMmQxVkZXOFVHV3RVQ2Ra?=
 =?utf-8?B?SUFRSTBNZUNUa2hQU0ZIRmV6RHBFMWliR0ZJVTlEcU9NRlV5QzNlQkRUR2h6?=
 =?utf-8?B?T2YwZ2NpU3hFWHFyYTQzTURGS0V6SEMrRmRGbnJLejQxa2dqclpid1VobnRG?=
 =?utf-8?B?bkt0OVNKUnVXdDRSN1RZdWZGdmV4TGI0b1MwQ0pVRDdBbUoyM0hNQnErTkxz?=
 =?utf-8?B?TEV0OFA5SnM4QTBnY0NNQmVmNk53VVZoU3JtUzAxbHJISkhOSHY5b3k0QWdU?=
 =?utf-8?B?dS9Md3lVKzFNY2lYZElVVURCZEF6R2JvNUk5a3htM0ZuVTN0cmtoS21KV1Bo?=
 =?utf-8?B?U0Y5RFJoTkFkZ2RhYVl6MERPQjduSWVtNG5JOVRHN2NIT1djbHJTVlBwQXQz?=
 =?utf-8?B?dUJEQXRrT3JORlpEbXpwZWtQbUVheDhLVHlCTFpsNkhrQUFWcWpuRUhzTGhD?=
 =?utf-8?B?U3NHdUlJWWZBVnRWQTExL0NMaUxEUE5vbEVURXIrWXJJUzZXZ3c4bFFaQnFy?=
 =?utf-8?B?YTZVQW05MlZWQ3M1WlFUczlmdUU1azhndXdNWW1yRHJ2SjJ6UmdnaGlyU09t?=
 =?utf-8?B?RURGVmpNdytSZFFhbFpFWW9ydHY3U1VnWE1rc0kwV3o2cGJibEJJdGFGZ2Z6?=
 =?utf-8?B?dWt5YWdqYUV3cjJpN1NwbmtqMlp5UUVpTG1vZWdObDZneG9jV2U0bWp0RW1O?=
 =?utf-8?B?OUJxeWpsKzJWTlR5cUw2TWxxeWFNNWI3N3p5MFhkTUdLdHZLN29GQnlPYzlF?=
 =?utf-8?B?Rmozb05uZzJxR041L0hTOUxvaEdkczMrZXhBcFJ4bnh3VFFVTmIwVWRVTXNV?=
 =?utf-8?B?VFNLVUVXMXlyb2VENitTN1hTR2J3UjVzT0wvME1oM0ZyZDVieThmaWxiWFhP?=
 =?utf-8?B?NWpPamtiNEZvMTd6U3MvM3ltZEpFMG5RWUtFUVhGSEVZRXZRTFNNTHNOSlJQ?=
 =?utf-8?B?NHhCMlluMTBsdXJ3S1NRcUlWaFoyUjhaZ0RkU0pDV2hyS3VLR0xhZjFiUHEw?=
 =?utf-8?B?Wndqa1Y0MVEwMjE5TWVLYnhxWWVCaHljYUplMUIwdytKWklnbkE0S1g5VElr?=
 =?utf-8?B?WW9peFRkUjJ2VjVNenZpOHhmK1dQamplc2NVS25kdElGT0c4RFpVNjUxVkhB?=
 =?utf-8?B?Y2hYcGtiOHdnOXJ5YXFHTEw3WEFjbjVUQ0ZDYVhPUDMzMWxJTmFGcDJHUlVW?=
 =?utf-8?B?ZEpEemo5ZGNyK0JxdkVoUjNLbEwvU0lNMnl6eW1zRGhEZG1rN0xxT2VwVHcz?=
 =?utf-8?B?bTk4N1BTQlhRNmJSSGpUNURjNTh1MldkYUtXZDZpcVVBSmxiZk5LSWFOOTgw?=
 =?utf-8?B?WUx3cmNBWVo1K2xSbDl6SHZHM0YvUmVsK1IzSkc2ZUI4bCtvWThKL2FRT0N6?=
 =?utf-8?B?dDgwR1Z2OHVnaG9pRlJlMmRCTWNEbFFyNEZPN1VtbzM2Lys2T3pBTDdZWlI0?=
 =?utf-8?B?ZnlOQ2I2Q0FENTVEVVZ4d3VYazJsUUFkY3RiSzVPNlpHZjN1bGdCN041ZDlI?=
 =?utf-8?B?MFR3ZExpZEQ4WCtZeXB0Zk84SXZ1di9RSjNkeWR1UWdlakREeU1xbzQyeElO?=
 =?utf-8?B?WXBxa0llQldjWHF0bjdZN2tjcTYvbmRZNitwSGRqZ2wwUllRM1VBbUhxei9W?=
 =?utf-8?B?MjFTTVhoZjVsZmZHRzRRa1crYU1UOUZDS3h0QWR6RGNhdXlFQXQ4Mm5Pd28z?=
 =?utf-8?B?d25IcStRdzdtWmlCWk5QVHFkY3JXYWJXcU03VkFrVXhNYWovbWo5N09qWTV2?=
 =?utf-8?B?T0dOdjlhSVpEaFUwMXM1NDJTRUFtYXVEaWgvdXFQNktpTTZxUGRVbzRpVE8x?=
 =?utf-8?Q?UancenEzltFEC2qiJ34ujwcZOBGVuabQLsndQcYw6qMUS?=
X-MS-Exchange-AntiSpam-MessageData-1: 5XRK3l/iaN+BUA==
X-Exchange-RoutingPolicyChecked:
	K0eYFQ4VdaSw3WXKyfaWuV1/kDE5eIeehsbWUU8dYEX7EZNw/1pFemXaFJiy1AnQ8BEYFn2eX9Kq1pYUjX2jHcu4dlJYty5lxdBEr1simz2CFaFp95rjShG1wCC4WzzVC2Rr2Cq2zsnB0ozGxj+MXKVpZxOgnQazwQNx7gs1K/j4jf2t/0sKEEPtwku+/nrNleJwCCb72dMyF5K/cj1+QnzUh57Ewx1EOeFCitjCufECGiTsRopSIxE1h9kSS7jzyUoe/mOraPFaMTxEmyhla33hafPARgeHDWvgTtSxLcFat5EonkPvIrqHPy71qoF2tZe9/Y365Vqnl/QhdbX6aQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	41ldgjknZDr6iOG+FJdIBdJCP4DgynbYYt7LFDNLwlPKb4xptyuYvgE5YfLkLTliS3LmHxr5peEoaO5u6uM7h966Emxe1rdvP0LiUyauk3q5VrE4Sx5LxuFdA/Pb0jOoc0Mrnif/IqK2ZpH9EVIy65lnLL1oZ1jbvsO95R95q3WBChmZ+82qBbPNW1/7vnDCuxkaKgEQpVDEyzKon/FKn7+3WrkJ6c1ijZ0ba9PO7VoyTmBb6cJtAajV4mfePTsGxH8WyveLxBrvUYSrjxkIiAoahTo6AYlXXnqcX+yqEDJgMzI+BpWPi9t4cY+CVA5D5B68PkmKNEfQMH2ftPbpeYhn+t7B6KIRrRLl51+Jv6E+Ar7M1htkOl/nsikzr25KI4FRqYQqAmRM1YJApzpJ9oaFiDchTcrYbM1aSnZA8PuPzXLI1jr+b1Jn2gbeEkYsIVEEUTo+0laQoXNp7YAPYCG2yHbpDmmXNwFGJKaa71XqDrxtVTQbGbhJeZxjbJv7EqdEehpuV9mlGgyBaHu+MFBEMvG6MfMvO9OPM4YMFzpJB8ZwpWO4sdMJDMf2Cq+MND1ClRBRXlL+NUTOg8vzaaLfPHS/AfUQRKV//pQ9Hn4/ANR45xntz9Ulw5K2Er3c
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b7f21f-1304-479c-361e-08ded370edb6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 10:51:51.2242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6tZ1rJ2Xi4iTc1qm0tq0h5DZd/HSjN76L6sYNzyL2wAfrdcjj+d9BxQEV+4yywghXWObf3U07M78j3UFQgrM1Rd8wUJiLrHEG7OUXNhq7Us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8293

On 6/22/26 10:20 PM, XIAO WU wrote:
> Hi Johannes,
>
> I came across the Sashiko AI review [1] of this patch and was able to
> reproduce a null pointer dereference during mount on a RAID5 filesystem
> with the raid-stripe-tree feature enabled.  I wanted to share the
> concrete evidence since it crashes deterministically with KASAN.
>
> > +    set->stripe_units[i].pstripe = pstripe;
>
> The Sashik identified that btrfs_stripe_set_alloc() stores a
> direct pointer into bioc->stripes[] without taking a reference on the
> bioc.  When the data bios complete first, the bioc can be freed before
> the async parity workqueue dereferences pstripe.  The review also noted
> several other issues in the same patch:
>
> - raid56_write_end_io_work() completes the data ordered extent before
>   the parity bio finishes — an fsync could return success while data
>   remains without parity protection on disk.
>
> - btrfs_submit_raid56_write() overwrites bio->bi_end_io and may leak
>   the base bioc allocation reference on every chunk write.
>
> - btrfs_rst_raid56_write() folds the full unsplit bio size into the
>   parity buffer, which could cause double-folding on the remainder
>   when the caller loops after btrfs_split_bio().
>
> - bio_set_dev(bio, pstripe->dev->bdev) followed by submit_bio()
>   will panic on a degraded array where the missing device's bdev
>   is NULL.
>
Hi,

Sorry for the late reply. Thanks for the report. As I wrote in the cover 
letter this is a pure RFC and not intended to be used yet. I'll fix it 
up so the 1st official submission won't have this bug.


> [Reproduction]
>
> The PoC creates three loopback devices, makes a RAID5 btrfs, then
> manually flips the raid-stripe-tree incompat flag in each superblock
> (recalculating CRC32C) before mounting.  The null pointer dereference
> occurs deterministically during mount in btrfs_read_block_groups().
>
> [Crash log — kernel 7.1.0-g3b216e369cba, CONFIG_KASAN=y, SMP]
>
>   BTRFS info (device loop0): first mount of filesystem df5f7a81-...
>   BTRFS info (device loop0): using crc32c checksum algorithm
>
>   Oops: general protection fault, probably for non-canonical address
>   0xdffffc0000000020: 0000 [#1] SMP KASAN NOPTI
>   KASAN: null-ptr-deref in range [0x0000000000000100-0x0000000000000107]
>
>   RIP: 0010:btrfs_update_global_block_rsv+0x452/0x960
>   RAX: 0000000000000020 RBX: 0000000000000000 RCX: 0000000000000000
>   RDX: dffffc0000000000 RBP: 0000000000000000
>
>   Call Trace:
>    <TASK>
>    btrfs_update_global_block_rsv+0x452/0x960
>    btrfs_read_block_groups+0x16ee/0x2e20
>    open_ctree+0x4804/0x8370
>    btrfs_get_tree+0x1346/0x2740
>    vfs_get_tree+0x93/0x340
>    path_mount+0x7c4/0x2390
>    __x64_sys_mount+0x298/0x310
>    do_syscall_64+0x129/0x850
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>
>   Kernel panic - not syncing: Fatal exception
>
> The PoC is attached below.  It compiles with:
>
>   gcc -o poc poc.c -static
>
> [1] 
> https://sashiko.dev/#/patchset/20260619090211.497100-1-johannes.thumshirn%40wdc.com
>     (Sashiko AI code review — "Use-After-Free", Severity: High)
>
> Thanks,
> XIAOWU
>
> /*
>  * PoC: btrfs RAID stripe-tree RAID5 write Use-After-Free
>  *
>  * Bug: In btrfs_stripe_set_alloc(), raw pointer into bioc->stripes[] is
>  * stored as pstripe without incrementing bioc refcount.
>  */
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <stdint.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <sys/mount.h>
> #include <sys/wait.h>
>
> #define MOUNT_POINT "/mnt"
>
> int main(void)
> {
>     char cmd[1024];
>
>     setbuf(stdout, NULL);
>
>     system("losetup -D 2>/dev/null; umount /mnt 2>/dev/null");
>
>     printf("[*] Creating backing files...\n");
>     for (int i = 0; i < 3; i++) {
>         snprintf(cmd, sizeof(cmd),
>             "dd if=/dev/zero of=/tmp/disk%d.img bs=1M count=512 
> 2>/dev/null", i);
>         system(cmd);
>     }
>
>     printf("[*] Setting up loop devices...\n");
>     for (int i = 0; i < 3; i++) {
>         snprintf(cmd, sizeof(cmd), "losetup /dev/loop%d 
> /tmp/disk%d.img 2>&1", i, i);
>         system(cmd);
>     }
>
>     printf("[*] Creating RAID5 btrfs...\n");
>     system("mkfs.btrfs -f -d raid5 -m raid5 /dev/loop0 /dev/loop1 
> /dev/loop2 2>&1");
>     system("sync");
>
>     /*
>      * Write Python script for superblock update to a file first
>      * to avoid quoting issues.
>      */
>     printf("[*] Writing and running Python fix script...\n");
>     system("cat > /tmp/fix_sb.py << 'SCRIPT'\n"
>         "#!/usr/bin/env python3\n"
>         "import struct, os, sys\n"
>         "\n"
>         "# CRC32C using polynomial 0x1EDC6F41 (reflected: 0x82F63B78)\n"
>         "table = [0] * 256\n"
>         "for i in range(256):\n"
>         "    crc = i\n"
>         "    for _ in range(8):\n"
>         "        if crc & 1:\n"
>         "            crc = (crc >> 1) ^ 0x82F63B78\n"
>         "        else:\n"
>         "            crc >>= 1\n"
>         "    table[i] = crc\n"
>         "\n"
>         "def crc32c_calc(data):\n"
>         "    crc = 0xFFFFFFFF\n"
>         "    for byte in data:\n"
>         "        crc = (crc >> 8) ^ table[(crc ^ byte) & 0xFF]\n"
>         "    return crc ^ 0xFFFFFFFF\n"
>         "\n"
>         "# Verify with known test vector\n"
>         "test_csum = crc32c_calc(b'\\x00' * 4064)  # 4096-32=4064\n"
>         "print(f'Test CRC32C of 4064 zero bytes: {test_csum:08x}')\n"
>         "\n"
>         "for dev in ['/dev/loop0', '/dev/loop1', '/dev/loop2']:\n"
>         "    for sb_base in [65536, 67108864]:\n"
>         "        try:\n"
>         "            with open(dev, 'r+b') as f:\n"
>         "                f.seek(sb_base)\n"
>         "                sb = bytearray(f.read(4096))\n"
>         "                \n"
>         "                # incompat_flags at offset 0xBC (188)\n"
>         "                val = struct.unpack('<Q', sb[188:196])[0]\n"
>         "                new_val = val | (1 << 14)\n"
>         "                print(f'{dev}@{sb_base}: 0x{val:x} -> 
> 0x{new_val:x}')\n"
>         "                struct.pack_into('<Q', sb, 188, new_val)\n"
>         "                \n"
>         "                # Compute CRC32C over bytes 32..4095\n"
>         "                csum = crc32c_calc(bytes(sb[32:4096]))\n"
>         "                struct.pack_into('<I', sb, 0, csum)\n"
>         "                \n"
>         "                f.seek(sb_base)\n"
>         "                f.write(bytes(sb))\n"
>         "        except Exception as e:\n"
>         "            print(f'Error: {e}', file=sys.stderr)\n"
>         "os.sync()\n"
>         "print('Done!')\n"
>         "SCRIPT\n");
>
>     system("python3 /tmp/fix_sb.py 2>&1");
>
>     printf("[*] Attempting mount ro,rescue=ignorebadroots...\n");
>     if (mount("/dev/loop0", MOUNT_POINT, "btrfs", MS_RDONLY,
>           "rescue=ignorebadroots,rescue=usebackuproot") != 0) {
>         perror("mount with rescue");
>         /* Try without usebackuproot */
>         if (mount("/dev/loop0", MOUNT_POINT, "btrfs", MS_RDONLY,
>               "rescue=ignorebadroots") != 0) {
>             perror("mount simple rescue");
>             system("dmesg | tail -5");
>             goto cleanup;
>         }
>     }
>     printf("[+] Mounted ro!\n");
>
>     /* Try to remount rw */
>     if (mount("/dev/loop0", MOUNT_POINT, "btrfs", MS_REMOUNT, NULL) == 
> 0) {
>         printf("[+] Remounted rw!\n");
>         unsigned char *buf = malloc(262144);
>         if (buf) {
>             memset(buf, 0xA5, 262144);
>             int fd = open(MOUNT_POINT "/test", O_CREAT | O_RDWR, 0644);
>             if (fd >= 0) {
>                 for (int i = 0; i < 50; i++) {
>                     write(fd, buf, 262144);
>                     fsync(fd);
>                 }
>                 close(fd);
>             }
>             free(buf);
>         }
>         sync();
>         usleep(500000);
>     }
>     umount(MOUNT_POINT);
>
> cleanup:
>     system("losetup -D 2>/dev/null");
>     for (int i = 0; i < 3; i++) {
>         snprintf(cmd, sizeof(cmd), "rm -f /tmp/disk%d.img", i);
>         system(cmd);
>     }
>     return 0;
> }
>

