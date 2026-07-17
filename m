Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C6E42981E
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2026 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297871; cv=fail; b=ddqqRXXwZb3sNKI4X8j7qvCTU/905ITlP0iH0ZYKFcuU+Wui0RuJ8D/eSgwnsRaQ8eIO9hRtxbCMMy5McJy4kZKB2qN4kB9IIsRptiEOO4OhDx0DFoWWpEvIKxQOd+Ho+IeB4U+r7BWmkTXQXgL2uv4DG/c2hmf2IZ4RqU649Wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297871; c=relaxed/simple;
	bh=n7gytTYTvlbVzmCdrthSYNZXVe7CfW8vtpJeJIGAQH4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r7DGPkkRk4JDsindUj7X0llP0UgovvZKrN98XjIQ2DX03TrdjPSo3X//FUSePLVVHUmgHi5C43Dx9jKHAmdBemuE3OO/zIYqG3OKGnaBQLPAWXEr6dQQDTSL2m2iv9LPU/8Y85XKNgDQjsyDAVjmbMBYGe5WN7SJwFKPF9P/1tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mIPVSna9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vBqorNP7; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mIPVSna9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vBqorNP7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784297868; x=1815833868;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n7gytTYTvlbVzmCdrthSYNZXVe7CfW8vtpJeJIGAQH4=;
  b=mIPVSna9duOyAoPRg5j8XIfvfpixtbfUgI0MyZqhuYqv93dadY4qu6Jl
   ss5h/OZswY2Gwbw96sbBXL9LK2jjYw8BOJzHd4S6QDednlpfM6GaGq0l6
   JWEHILMC2+TGqnRnuHfBZnU82+O4K6Ki8waj8V0e1GRl3jeAwRfNLcGZR
   9ruLYE3uidOhEUJrA1OwWEHa9aCsjkfiCXgdvLEg0s7jo6VtNkNdPzMQO
   8oaugo6BmsTzREUQkuH08jft5kazZbRW0iSSVc/XYsZzQGQ/NOqQ1gbaA
   7X4ukB9F137dOgMZ8QzwBOsiqeWsxprgwCPmGsFAP0aqsQEZpjPfplXMx
   w==;
X-CSE-ConnectionGUID: WstvJBA4Qd2zwI/JhgvI/w==
X-CSE-MsgGUID: mQHxB6HmRxeizNoiQctIkA==
X-IronPort-AV: E=Sophos;i="6.25,169,1779120000"; 
   d="scan'208";a="150947560"
Received: from mail-westcentralusazon11010057.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.57])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jul 2026 22:17:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UauBVWiUAHEecB/sp0tl5QzAh4Xvplt4LD3i3nWikDc0qMwxPITFhgzfsp4diELIE1W5x8s+7i2rZxxnhF9wWpxQh3LyWt3u+mQR//9+yfXhO635xx7E7JzImfMN0Xw4PZZKtzAuUssn49Yemh267OuusqpZNTCMlLAXd+se/WU/yP+AWnLpMF+jBwNxl0Co2deta5iYrQat68C6bHFJuM+IgxDxP+93q4Lj7eiZpAkig6hVIhlEKCIeWPeSrGofa6ar+78fujAO8bxiByV+FBK5emyEzrJyyJ/LwJsPdxpJW2OlIiRU2zlR3K6Twl4F5wLZnpsIyDpGro9kBKl0Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7ASkEGfL3NKcq/sCaditTM0v1dAbsyIipnma3e7Z8c=;
 b=xVdkXouZA+PaG2gHafMOIqa5hac4i7NKegW0iTuE1O0Yu9N1obF/vyj2o93z3D8M5w394r1UjC8jg/5ORKnDSs+rmepNPnby7Om6fFYItcaJn5GJyvBGiQvBgmxHzn9naAv4aKBuInW5oTOwNy7XIN0JuEFOtzTAnbXVYC8zNqaZRyrJGObVnZtU8CB3y+BjM95yXMRUFI8CSrqo+T9L3YNRwd8zGJjhEnd5/AZ1MWFreP7jTGgZLCf60PnumGnpXmH8z1ObLDWzFj2NYmkN2hN8OfHpq7EOJAPwWrnRbmqCd9lNjyxJSYbYAW7Fe2sPlKj24IZalLCk48WCabt7jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7ASkEGfL3NKcq/sCaditTM0v1dAbsyIipnma3e7Z8c=;
 b=vBqorNP7ozK8j8xDMPOlpZAB247DqICky9AiK34MSn/2p2Q7xqQDOX5460kaLzDHTNS1mDAUBuAY3YzmqKMXeLFlzY9dKgvNQaRE6wh3LwlXHbVRos/JeokcrE89OdZ4T+dXUMNgy/mAbgZy5sIOoUAjfB6QPVBuk5ORNTzwdek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA1PR04MB10178.namprd04.prod.outlook.com (2603:10b6:806:4f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 14:17:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 14:17:39 +0000
Message-ID: <f19d3f3c-f36c-4fff-a6db-e4b640f6b8e5@wdc.com>
Date: Fri, 17 Jul 2026 16:17:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] btrfs: zoned: drop stale dirty btree buffers at
 close_ctree()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
 <20260716115656.1319295-3-johannes.thumshirn@wdc.com>
 <062d26d5-c340-4e3b-bf56-a38d1f98a546@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <062d26d5-c340-4e3b-bf56-a38d1f98a546@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA1PR04MB10178:EE_
X-MS-Office365-Filtering-Correlation-Id: ae629349-6c72-4b78-1f59-08dee40e2891
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|19092799006|10070799003|10067099003|6133799003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 SZ2NihK/+fmNGtdWelf13x4sjujJQGciNZN12+7YoYxe/6Lr5+gPyHmEVLLCeQCPSixTOl5ECRr2UKxL5oRDBewp5/DwKHXCVfeqUFN7qNWuwLgUN1Mkq3Jd6zR7TIi3Z/HfR2Qqp3sd6AgQj2bN77JUVy3oqDohLM6EPChKZmO+mDvapuynUIijFPGz9WWMD0hU4nDi0nhgl5RaAJo0Ch9OO9cacBmpvBNH0U63p0ad43jsZZc/CflG+OEM9Ac/0IYLeRSYIFnWJ8XyIhraSF8GVQcj1guau/xlj57SQRjCIf9Vq8x5qhGvJeyDVqDl0d2YFEupjri2YXTYtKmSpmRFBpqt/b+fMsY8P8fi7ZBD5/xzpblS3KZtqsYPuEG/IiXlGeCxqtVzOzbHByJKB9wITdvvhmq8LXqiW2YEredw9hHp0Md1ODIwO54JftAtabkD2NAbKRNQH2F2FAyH0bdxiEdhaVUtsenucHMNJKUCMYl5W3+BbM/1FPc9ybcuyxZJGTfEONPHJWVj5pJ7j+ubfhwhQRyfjU4Uh+69Mgy2YHqFM+q9Mkvv+5guwfusm/rPAV7xhtMSVylZEtgV+hUFvQsOykOT9AYbvzzIXlYeCifi+h8RW/6sM/vDhcUVprZHrxaV9U0GV3qfi8k+DGFsZAgeKebajSUjVAOVqfQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(19092799006)(10070799003)(10067099003)(6133799003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?U0NtcTBNK053UTRqaWdxUVpyMWJjWFlWZWswTUdXdTRLdWRCWGMrcS8yQTZm?=
 =?utf-8?B?WXJzcXJtQXJVTjhvYWUxQjdhMk5CZ2kycFdiRjdRcEpzeEptYlhCTHpZK3ly?=
 =?utf-8?B?MXVoS0FQNkVWZ25yQ3FNbnBGdW05SnRuYmxXMjc0VFVFSkZySmM5TjBOZ05z?=
 =?utf-8?B?UWxYcVpZbTlaOC9qREQyN2pkYUVza2NBRUNCdW1vMzlRVDRDRm5sKzcxVlRn?=
 =?utf-8?B?blRRNUZFV2ViS0pYSmhoRFJXOXdTQXZ2bGFRb3UvUFdRYWRJc1c5blQ2Mnhw?=
 =?utf-8?B?aHpyWE8wS3VIWWh4V1g4Qk93eUlKSHN6NFF3NE1QeUpQQVVpU1hZZ1FLbHJi?=
 =?utf-8?B?azVpbUJDUE1pbzFUaEV1MDBuVjFxajVmenNMQTVFcC9YSEoxR1dIZGgwc28v?=
 =?utf-8?B?N1VTLzlWbk1pYzVmNE5GbUpGTGRWbkxHVlVlNi9QbFBENTFXNS9sQ2QzdVFU?=
 =?utf-8?B?UHRBZzZRS0luL3oyaDF3SEtMMkxaZHBrbFdYR0RuK1lWR1pSNWJBakZneEZS?=
 =?utf-8?B?LzJVWENOWk1nbXpUcnovTDNaeWxodm10cFFwUXhrTFFCcjNvQXN1QWtBQ2Rr?=
 =?utf-8?B?ajNER2NENXZwWitybk90TEE5NThtNE1mZGU3RlI2Ti9hbG1HcXpMUFJYVzZ0?=
 =?utf-8?B?SkFrMFlubTIwL2I1WWkxMzg5bVBtRkdnVmpVU29RckV0ZEVDVzFsSmlZTTZr?=
 =?utf-8?B?eFFncHlWTmpkSEY1dENhTldZNTZ3eEtrYjdJSEJ0NmVLNkhpQVc5OHZCK3li?=
 =?utf-8?B?NFo4MWcvaHR5cG84L1YrVEluRVA0VHUzUTJpdjdPTHE0ZWxUUCtXODhhOENZ?=
 =?utf-8?B?ZlhMSFBBUUZWQ3VGR04yWFV0anZSd1lEWEd6dlkyOXNmcmtObTZXTWt3UzNH?=
 =?utf-8?B?MEhMeE1RdlFlRExvM0R0emFla1NqYjcwWUk3emVXZVhsMzJqcHpEcXdmQU9O?=
 =?utf-8?B?QzUwTTlIcmpmd2svdk1DZVlHMEFHb1lpalBJdlhTSUwrVTNZMWtxMEllaUNv?=
 =?utf-8?B?TE51QW44ZExteGpmVk9sKzRnWVZkYzJwaHQ5UzlMQ0NWaGwvM3RtSUg4L1Vz?=
 =?utf-8?B?YVRRWkJUQXNmMFYxVUhOdTcxMlNWY1UrOS9aWFhYZ2t1dk1XV2FtYmJWRXpI?=
 =?utf-8?B?WnhHMFU5eTFqM3luUFVzc3NBTHNTb3RUVzlRem93ekFtUWxvRGZCYThjbzZs?=
 =?utf-8?B?NWxCbXhtbEFrSEVSdGE0VHBmL0tCdm5WYmFlczV3ZWRoR3pkUVg1KzFpWWFi?=
 =?utf-8?B?VEJwdEkvcEoxOVBDNE1ZU1Q3NjVvbmV3eXFraWtqeFk1UW10cVJjbmpiZ1R4?=
 =?utf-8?B?YzRsZ3BzdFp1Y3dsWEtJdzdQSUFuTW8zSWEwcXRDY0hpMENWek43U3N4Y0J3?=
 =?utf-8?B?dG1ZQktwQ29rdmhYKzVnN2RTaktZc0xkRU1JYnc5eFhNNFM4em9XbDZ1NHVu?=
 =?utf-8?B?anhEOEQ5SFVQZHFtMFhQeEZiV2tKWGx5RHZiSmtXWDgrL0t0bjJhKy9rOFNQ?=
 =?utf-8?B?aC9PRWI4Q05SeXhRYTcwS2l2dmlqZFJtLzl5QWpoamg1TS83bDV5VE9wUWRa?=
 =?utf-8?B?NGhaVlNCeHhlMlVNVTJhQ0JTYW9HQWIxUlRPWFF5cUY3TlNScFB5ZHk4Y2d0?=
 =?utf-8?B?c0NURU9lMjJXUk03SmJYdlMrTW5sYWlBbzVkTVdKdVQySzZLSTJWdDBhSGZz?=
 =?utf-8?B?cldWeERWRWk3d3EwWitrVTAvM0ZsNTNjUXFoZEJpc0tmVWFYendpV3VnSHR0?=
 =?utf-8?B?dFlOMTFKdDJzazNTdFgxY2lmTHZuOEtqQ0pVZndGNDNBT0JzVnVNL2NuWkNo?=
 =?utf-8?B?d2dxTXppcGh5a1BBV3VzdnBIK2ppOVVZNlJGWWZ2dkt1SnJtb2JGQU5UMnJ1?=
 =?utf-8?B?UjFWTkNRNHR1WjJnWTBBT3RWZDdHVmQxUnV2NGVlQXNzN09qUnRCallyR1Nz?=
 =?utf-8?B?OUUrRXZWeGxxMFZKeXZOTDhBa3pNU0E1Y0JzeFFaeWl4QjU2Z0xHbzIzQ2hQ?=
 =?utf-8?B?aEVmbFVveVI4V1V0VnZnSkgyVFVYMWl5WmcrT3lEZTJqbTVrOGRvNGxtMEVl?=
 =?utf-8?B?VFJrVlY1S1M4MEhRalAwNGlSWXBSNHBDaEdlYkdqWG1GY1lKRzllbkhVV1Aw?=
 =?utf-8?B?cndlUm1RL2J4UkhLdm93MFJ4Y3hGcmo3VmFsOFlBYlpoeWxNblVibWxtQndM?=
 =?utf-8?B?dmoyTmxRbVlXSkE2Z0lHZ3lBNXpjNnZNakJhTW5mcSt3VDR0TnBpWmNjQnBp?=
 =?utf-8?B?bGlNKzM4cllMazhITzBwaCtkS0cza0pqa3ozazkzeWYxV1NSWEJsK1VibXRS?=
 =?utf-8?B?RHBsZFVpWWZDNXVLb2Y0ZWZyL3pNendXMVlYY1QxNktoMFFQc0tmSFJaQi9z?=
 =?utf-8?Q?sUpwY99BnDuvKeAyqSxzAGunMrcJWCGBAxrm0hJ3FL4fq?=
X-MS-Exchange-AntiSpam-MessageData-1: O9pCPCIPdWnMcg==
X-Exchange-RoutingPolicyChecked:
	oRot5QT4ttTMZvyfe+nrJz+iyAZ2Ct5OziJ+UCufqtzW5xUgn34X0GfkxGENOVwNrUniPv4M4SseXhwXXVUefXKavwPdsV0aFwjPoqE4GIDbAQ/KvTuRGuJbTsrROzL/bZSLczpW71W7QOi4zHbE3f+6XTZqIhxA2PIIpSOPTiGbUF4inS7QNu3OQw6l6V7QZsRNageFJYL63ayuR6ylZVeCMC7W+Oeyc5eUXgpWo9f453YU2uh3DZJJEIySZ7Fvle1Px8m2ynQ719prbAKVvz3l2DTDsIjVT6Jiy5yzLdhWRmmoFocu9h8eiyD6FbKtIAQwYq/L3K9dgvj9YQ5sbg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mR4y2y7ntVO7zs866FeGmwa62jet4gd5dFfnXcbUyoSYbkRJ+hKzZccDJFuZ+/8i4FhhETPtowZI+gAjd8BiatXYntLeLdU3rFimHFclNEh2WrYG1vhzxhULNAFJIGy2zsItL5ge0gcgAi8Yex8t3QHhiEvb2Bj/hywEEvexcFznpeVwQVMTnYZ4CHVKuQCN9M++DTKrCuAVxGBXrn+6mufRQJevSeJL4cD0f3mfQ8yjISlhsGTqDrq8PnH7Yo+ZCdocSkjp5F0sb/c8FpqNFKCGlKfstI+Cdqw3mHVjt4FPXAJp6vteUeW52iqvXLtNpfon+kxI0ib+mJZtmHTCUi2EXCiDrRNUjBLNOA93ilqESESkV5u6bo14lLpKXyDzOhRXjW/jsM4bIGfYQEa+I+FJ3SossEpqVCQ9FMxnN5PqhM3lrWxQQjX/1WmumIENqUkAt5QMDVPePG2HrIO3VJUkGAidJYrexH9LMLvBay5/rxFPrrtx8WSWSkVpcU9ZmUeQmirYy7yAVMwDsx+buipuezmyzrQ3mpYolbDURPrr0Qf9LiXqjSvZXHaxjmd3AgQpi9qPulYW9LBcpx48UOxbnnl4GKbJfG9JZjDWWlPFYA47ldjqVNKFHEFI3klp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae629349-6c72-4b78-1f59-08dee40e2891
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 14:17:39.6477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zDBIFBLum30Mc7AoSn5Wya6aiZPE+yXKyjTxtisZqVtfOZS+031ZarHAGT63nT/D6GlROpcUUxbs+xVWihHaXt6mRGme/3lNsNCr/aIGRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB10178

On 17.07.26 00:49, Qu Wenruo wrote:
> 
> 
> 在 2026/7/16 21:26, Johannes Thumshirn 写道:
>> On a zoned filesystem btrfs_clear_buffer_dirty() keeps a freed-but-dirty
>> tree block dirty (EXTENT_BUFFER_ZONED_ZEROOUT) so its zero-out keeps the
>> zone write pointer moving. A block left ahead of the block group's
>> meta_write_pointer (e.g. a tree-log block freed before being written) can
>> never be written by btree_writepages() and survives to unmount.
>>
>> close_ctree() stops the endio workqueues before the final iput() of the
>> btree inode but frees the block groups only afterwards. Once the block
>> group is gone btrfs_check_meta_write_pointer() no longer defers the 
>> buffer,
>> so the iput() submits it for writeback; its completion can no longer be
>> queued on the destroyed endio_meta_workers and umount hangs on writeback
>> that never finishes.
> 
> Can we just trigger a btree inode write back for zoned cases?
> 
> That sounds much simpler and less hacky.
I tried freeing the stale ebs in btrfs_reset_unused_block_groups() 
before actually resetting the bg, but then the WARN() in 
invalidate_and_check_btree_folios() triggered again. So that doesn't 
work sorry.
