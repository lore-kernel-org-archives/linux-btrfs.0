Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793028818;
	b=OFo8pXUkc26bIdmZ9c4HafPIb1tCP22hSxxhbgXQwHhqnZdafyGpHKFnJlI6nf8oc5Ed
	 U2+LYtQKWBGEyG4NcZuViul48wDkk2PbBkM4aIXPPywC/Z2cyE+5BcDmMDDVFKnKRMWju
	 6hLBPXuCMJwpQLayfKFKqg49FSoHl8JAhYGxqiQAK754wu15b5fbxFOidvuP9j+Dg8Tzy
	 AJC4aobAebLP4VS6FLRNtonILxHYfwrlcXu6ZW3x16yfh6iv1lw2ovQLQK4QxB35bt3I5
	 AlQg74FhBKCsiYF7ebQk6bwKTJT3bVeHbfybrWN+w9HUDjaQHnKv/q0f76KCgG4e/1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028818;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
	b=sftc4EE8M+n/IFHhR+0YzxiF15o1v8rObZQE1Ah5C78zrc8p6FR8oSzhotGxJYFiSsJz
	 SUJhhxZljgc+HJP3Il8oKvNC9ewYhTpAOnivpkef1yw1SVfedHqsq3cYI0myuKeWDiIgL
	 a8C5gb+Qc4AJpEmON+945wKn6RaLP1wkhRxOkZV/qQQUxHHcKsBo/9koLQNgZj/pJ5A6U
	 vUM9qjsh7/fmEPS5ACJnHjgeYwA/W3j8m2GqTQq7StRf6nI45ehhNqPubFPOTgsClZEg/
	 oe0QciW8ZAgObSPFGm7UmdKg4hksn/Jpnss8yZGcIoPvm+LG3FX6oyrU0AgT2hdlCgw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=N+WRUI6I;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ytVD7syd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91384606A322
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 15:33:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91384606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=N+WRUI6I;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ytVD7syd
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793028817; x=1824564817;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
  b=N+WRUI6IxTkpG7FWMWGi+fvsN5w3SsMDNVm4Huwk0bDbCSSU51/98BqS
   /So2/BROXoYFHUTFMJzxYEAJK1nRl6SuG6oi5JEWkRtr1CYNCZdincu/Q
   7raltALKzoukEKW1jDvURRmLMVo1aVVDucAPydRkUgOzTBcDeyf8k7m+1
   8a8GESfcPKQAVKkOQDpdhjSTr684uAtS9sgJE3usPy3qb/n1hBiL9yNsn
   8FHUWGej+NpkmVDmBjIbcANZPsRe5RzC5RYmTw51XVIMeA+NpJsNcDbK4
   G4WPVos7MhqwXAOKOgt3WiA+A7C72ornaqIC6Zt8XsVGZiAyUqwpg9ENT
   A==;
X-CSE-ConnectionGUID: EqD5bC6fRR6LAKpVidMDUA==
X-CSE-MsgGUID: KdR4t4+OQGq4t0pM0voerw==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158926495"
Received: from mail-eastus2azon11010009.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2026 23:33:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apXgjzjEbyhPL1g/tT5CfGoMaAGFKYzBV+mSYDkvjGpI1sc/dvvncoJbZzIIxWXnE9H9LRFRwWQLm/ym0ALpfhvXXCfBQy8CYhoaCzynyiLPOjZvqHhzV7L0YgEli84D+N1SJaP3ZQ3Qs72i4D/oKaMcFLxVMy1NOpwclz3CaZ63rcLsa9OCbCf85r3V1iMGR+5VVVH0DCRJ45uEFklCuYcdHj4UYfVvxZFa0DdelCaggLHPP1Dd4sWGk1LIvwHe8sc+4VxoR15vFSUYSLekpIUxDyi5v1E9TKr2cZoelToGawkeZIqSF4S795pbH1n3hJ3d32+KbHLS9SIDKkCL5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=NeUJDdcjFSYETCIIk6JN0kpIMR1AY+CLAIKnpWSz8AkgbCEcc5GT+c02hZadTaI3Nd1Va8QGaGyDp1sJ6LrQwsmgyzhKJW9DiYteiaxBAW5mTfo92fy3gqn+Rp/apPUcWPUE54ICPmhSDGW0IbrWr6nXqZcUk3Pgk6UQSbQzfMWjsL8urh5nMmQc8ZRTrOml314vV9idKSI229qnzs3KPRkz60ohB35ugXOqq7bTGu66EQMfPR0YIgEvclOoUWalS6yMUGWd4c/Dg/2PdxTrFiTt0t6OBqFnJVwas/8dkgN2bXcGRQDHngKAIDkgtkTl+rKMaDR1WHBDi5Lldc/pag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=ytVD7sydlzZm93sDK2LPVCsPy+uUWwCOolrUr+uwCQji4Dv5UZEAUmVUTZH5Cguk+I0oTO4LvdXhtG/HTJz7xkI09eiK/TQrVt+px1Z38oaY+HW1Vd29M+8Lj9WrrbPh/3qfEjj2DsGg/bnEj/aXoL5F22pCZMIWel00YC0HgE0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB7956.namprd04.prod.outlook.com (2603:10b6:610:fd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 15:33:28 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 15:33:28 +0000
Message-ID: <ac44b6f0-2063-4313-9006-1f2a805d1d8b@wdc.com>
Date: Mon, 26 Oct 2026 16:33:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] btrfs: add stripe_len < PAGE_SIZE support for
 steal_rbio()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792661955.git.wqu@suse.com>
 <b4ad468160a26d3d885895c9fbe58e081587fd20.1792661955.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <b4ad468160a26d3d885895c9fbe58e081587fd20.1792661955.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::19) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: b903b25a-23d1-4459-e0c4-08df33767b63
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|23010399003|19092799006|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 1U4joEo7OORsQXBiyupVpbiG/vMGBVCQFDCF3xZnNPxHBZ8p42ywP7MxGKD7MrrPTHzwhA527qlVg+gWHRdt2T/hZHeteHBOIRWSctPIs54kVOjCx1dW7SQ70H1S8tockYIJTHxZm5Kgk++ZMlTSPx5rM4S+bNXQfrt+3T5kIwFVoNSrSpDYsOggkOL9/SCz8TN6saMvF8Zb1PGhdffv5BJui/pcZxefWnsGJhF6NFMhZCSZlBylslBU3Cu8uy/nC1ZU6OzBYspBRngTMORHjdglgXAYEOWMvkIc6fyemAa5cuCnaA06nlJNtLBHsqCg9rWvf1jKkRu3E8hTcmO3eklHSLvgBMeOOLujSpbMbU1kePa70+KEX4tumRBo41UpK6Ud9hxppsw50zkkSLmw9eCVdx79ny2dVAtPxv7SsATG0iCDv/8e3S/V+TND2ohMaPaKdX9QQydHZpVxnD50s4zeYQkeRs+Oi1Nez0gOVebeix56+oX5r9ZmDN0Y3SqG62XkaQJqF+uggU36U6wyxQCQIVUiYewXe0A6YRGLgGaAjHYLpnXOVUGsmSDxh+6AWCTOo6jxQxSj3RJlTH7UOA60j7j5sfDesYMGB5PqLHmp6pxybLd0JenCv4ejD316mpJkyLySG9/eQr6lUwT+1MDMMUduYigudPiHY0dlme0=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(23010399003)(19092799006)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZzNZa2NPejR5b3docUl6elNtMUZRaytyYVN5T3ZhcVVoVExZTXppQktvRWRa?=
 =?utf-8?B?WmtBNEFMUkFZdU9NeXNUODdJRzJNQUNWZmhHU0pVWU1VYUVDSWZKQVNXWWpn?=
 =?utf-8?B?cW82TnhMTUg4MGhFTHF4V2E4aEx5dnJIM2ZBRDhsQTVMMldzQ0JyR3dmWEpG?=
 =?utf-8?B?K1UvTmZMdkZmd3cxUWI5b2RpckFNUFgrQzhUdWpvRUFvSE5VL1Y5Vmd3U1NP?=
 =?utf-8?B?cVl4NWN1M1NhRUkwM3lReTdVeXJXalJsaUVRaVI0dSt5RTEyb3VHUVRQdmNS?=
 =?utf-8?B?RVBhSVhaZXZydlhjdTFreHBldkoyblFXQUhGaXNyVHgrMnUxbUw0SHBON1pH?=
 =?utf-8?B?c0M0N1NvTVdUTlJVZmVPa1R1SVlVU3ZlMkt0TGRtY1ZJRDhud2x1S1JHWEZs?=
 =?utf-8?B?UHJwcEFjazF2dDR1Um1vUzV0ZG4rRzYyQ2h2V2tGN1BqaFlHNWlkVmJGZngz?=
 =?utf-8?B?dDFSQXk0VWdUcFpDczhYVytnaTVxOHhFT0tqdFQ5SXRjRDY3a1ovdXlqQmdJ?=
 =?utf-8?B?OXI4ZnZDZzlWV3RwRXRhZ2pGZXJqWXJFQktQbWlYUHI5aDhZbXM4VzFSU1U2?=
 =?utf-8?B?YXRRSzZLaU1kSmxxNitYSFAxU0dQMmd5UVJtVXlOaThJYkk2bmErLzVNdlp3?=
 =?utf-8?B?akdVWU4rWjRHQk9hY3RsS0tINkJOQk5VaWNvWldHc2tZdUQ2UHlUL2JZTXFN?=
 =?utf-8?B?THRRVHMxOTdldUp2VUZDTUtaUG42ajNOd2pQNm94ZnRIOVZvUk1uYmZTNUwz?=
 =?utf-8?B?YkxGSEVISm5kOGJ6b1B2QUtUWFpLVWdMRGtwVjNqOXNOVXpDbEdzcFJldXVG?=
 =?utf-8?B?TWIzem1tNXdDNTh1K1dCdGVhZTNQZ1E3Ui9WelFQYUx2MHhRa1VOYWdSY041?=
 =?utf-8?B?eU1FalhxVklSU0J4Y1BheW5CbDlCT3M0OEVXRjhNZ21CRXNEV0QvdmhqQlg0?=
 =?utf-8?B?akFMR2tPcEQ4UERxeitwRUJUQnpvanhnRGlzaERsQ3B5NVJLdzBuN3BOdUVl?=
 =?utf-8?B?aXJzWGg1aU9uaWZza1pBWEhnaVdiUlpZbGNrZHBKRE9KU1JiQnRpK3YzeDJ6?=
 =?utf-8?B?ZFdGV25LdzVrcDRMRlNheGw0aEg2ZW5qbC9NdFhDRnBHdG5IblBJZW1qcHJn?=
 =?utf-8?B?dWdBcDd1YVpXcGlOTnlWc1RKOE80d0xnb2NkOEFpMnZ5RVJvSlBZR2JUTFRN?=
 =?utf-8?B?a3ZRV3lWZkwrZ2c1THErUUQzY2o2eng4b3BDNjh0aW55YXZjbWtoSlUyTGxY?=
 =?utf-8?B?Q2Y4c25mMlRWeHVPL2FFZE9wMUVhYXVrWk4zamJxRU9KWVJnbDdwQ3J0TGw2?=
 =?utf-8?B?a3hxd3lRYWNwaGYrcnFhVFNZWnVvWk9STHVtcnh5MXVLU2crWjFEUW5NeSsr?=
 =?utf-8?B?VUR3RTVJOHVqYU5wSFRGenZZTlRiOVZMSnNTV3JXZ1JGQUNYbFpUR2tyM25Z?=
 =?utf-8?B?M2pNRHZYdUc3L2JxTk1sQ09vcnErQ011M2JubzhqOTdyQ1RYTHozRzlTZ2Ri?=
 =?utf-8?B?eldLa0N0MVJhTlFpMGNBamtHc0o1dTlRZmN5U0c3djNHYXNPT2hSeGJva1l5?=
 =?utf-8?B?TXorQU1wK0ZzYkJCdzFlejhyWkx0WklBZ29mRE1OMFpHcmRJOW1QTVh3N3BN?=
 =?utf-8?B?YVVzenFSYlVISkczNkNOUnlTNXQ5eUpFZjZSL2h6Titrc2pFNkYwTkw0d0Qy?=
 =?utf-8?B?MjU4dUp6VWZBZjhNTXlDSFZFQ0Jha0tMa0RGOU1IbjZUbktXTXEwekM3V1hI?=
 =?utf-8?B?dXRiemlIa05ZMkYvVWJ1QXA1Ym4vMnREWnV1UmFNZWllaWdkeUtXaWMvaGpZ?=
 =?utf-8?B?ckNBOFB5N2RkV0czVkZCcUlnRlF6bG1Td1g1MExBUVB1YlZrZk0vQ2I3c3JV?=
 =?utf-8?B?Njd5M0NzVlUxbk1mRG11NGY5WmNzaVlnc2lFOFBIS1BuUkU5R2M2VlI3ZUhV?=
 =?utf-8?B?K2lwaUR6RmRIS2xxdERjSGk4ZVZyb3FrNFJ6U1F6N1dyNUljMWs0dUl4KzBu?=
 =?utf-8?B?RE9tcU5mUXBON0FjeHB0TmtORjhDbXBGWGJleEpyT0hCTDJpbDJ6VDJ5TDYy?=
 =?utf-8?B?WldCQUdlZGR2UVJQbTBuNVdCN3VxS0tvU2djNW5KZUxzZFBKN0haUEh1R2Zi?=
 =?utf-8?B?VWhFUzZ5NjB0S1lMSGdJRTNCeUMrWmhUazFDMmtpZ3F4bm9GaTNQaVN0SHlh?=
 =?utf-8?B?SUt2QXljSUtRWjlMcy9ZVmdTZklxMDF5b3AyZTc3TythdDNzMDFlTGtIV3V6?=
 =?utf-8?B?L3VXR1Zma2tzbVhEUUZnSUdxT25NT25xK1NscG5jUWVkaGxlcHVDTHN4Z05a?=
 =?utf-8?B?SkJhOFdUQXkzN1ZCQ3FyWXVpYlBmWkQyRWh5bE1XdVpPWGcvSE9BbXBNUmd6?=
 =?utf-8?Q?tAZsDJ6KuLl0zaqJsvl7PIHTBRjTGEqf99nJdgPPuXGp+?=
X-MS-Exchange-AntiSpam-MessageData-1: tv58HVRc2fbr0Q==
X-Exchange-RoutingPolicyChecked:
	uppGMz2DGTkiXV0ZoNdk2+v3Q5bG1o/Bkj4HbwuIUcNz1wxzHbZN3KxTHzdMPiMdnnkZ4QCKAqXyyQ5X1nj1Gf/nWDXMPY1ExF2AxNBqJR5/Vc5Q9jgzjoVhjU/si2gigOK8kGIvsHfnmqGiKSCihVVoiqG+r6SHCRxyar14tRmFBtRvBMEqy9TORzmX+Ilkpzl/pWWnoL7wW9o5eJV90A4l+zp7fxP1SAywunTRhDhSOxbdJiFnU+sDh1C31nzjctPBUhtziwESBNmRXdFJ1i9rZcVUiS/C+mQDqMZX0uatfptNwet8GhKUy5Mf0WjJyqq9+zm3tM1E7Pm4RPg4OQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a8Q5x/i6pfhxuLH3umhouvZjxHOETF5ud4QDdS7RUB5yBcNQOlJnTQ6d2bUOVel6SOmPqtxCce1iqO9zduZ1pN1r7VxzLRwerwhwGsQByOGETGmpgr2CoXzMCPhcT6qUJI2vTOnlcKPiBq2dXfflxv/BKplFdfpu8gCiIhWT+NoGbm40iUnjUGm5BfMmekquMnE/JW83rQmEH5K0EsGzrCct1xuDojotX6VxefZEXxolDfYtuRKgTza55GANoL8hQDiQfXeS04ITbWRWI4rc/TLH+ZjjBtm6yAtK1UqewbYsz2FXRmTYgY8inxsOFbaJAM7APeV8cu+cr0Z00lFIbb2HQdVMtIzWk0NL4P7xID7kU5G8LeEx1WEbcwGnwuhAfTke4F8Dai88Jjf/GWfqk3ww5sgZfju4UYhJDNhqLVJCR7EsO6+HszgTLhSq/zMYEQ8z9pwAA+vxjjYuy25ybgFWidu0aE1wP2nelhP8G1BlCXVJSe2gGU/6MtDannZmcBCVLQFu3ziitCXT7bdVlk6fR+fgxmBsrtZIKRpYW9cOej1KVrhbSKQL2KXbyCGULqVsw+EyLVKCNtux0Ei8xXGNzV/i9xn1CvkjJ9sqt8qI5NRH4o91SVoC7bmpwrwb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b903b25a-23d1-4459-e0c4-08df33767b63
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 15:33:28.0263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEKHp1fzZWrKXOHMbFdDiWRvOIuGdfzKXnkFiCpW9NiY3+Rz9uzBA1q5u1zBtitrADHpdJdoFqgvO4KNtBEDjQ6tx0YJ0nFR7UN/kVxpnaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB7956

Looks good to me,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

