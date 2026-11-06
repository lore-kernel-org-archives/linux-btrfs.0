Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793970870;
	b=Sp2jNs0wcFSI1zPVGzA4zW2nIMUibmYp15edXwMRVXtxuuownCvihWlqhkdJFFl9aaVa
	 vCFS5AZ1KB+Cst1OW4gDRavP7hkq0uI0pAsxHLKZH9acMR995ThxdEubx2jgAoqtDV8Je
	 awoMt+HelqnpTldoZ+Nh4gGgO7LDsuQAUrlHUZz/e8p5amJ6bZJOYAwGNLb22MdIKhYem
	 boS4oxpAZF8lHmDmVDFRqTkEKYcRsALbwVPfxsp2eEsoxP3yGr7iTMtMrhN2GBUg8yr5y
	 fFjpbYxDCe/Y2vzVI0uuBUJhZHYEFpid8xopGo7YM/+mWgGntwWFHVKbls1lRV6s7HQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970870;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
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
	bh=MVMtsIChlls6bL6CViQMjyS+VzoPeb1drF9JjZRDfl4=;
	b=BY9i4RswjpP08PzBwiFXU6g41VA7/9sFV6N9ULd2xfBSJ0QWqKOFhk/DMik+gJ3m9MRT
	 zHoXVZwZX1ouDWKanaLBzwsZsrPDvqZS/DPyT0XIwk+Yckzw1EdV5jP1AqyD2stZCYVLf
	 ze0a7eYsNSgHT0pxCU38QflRoY/Hf7vaG61zKLQrc9929AUvmqUPtpPXov27clDDD7qTd
	 49PueE6WdEq+vXU/W36tH98/sUaWZ/vTFhyONrvSfTp68++QoUJwctj7+WG+Rns09flB7
	 zLS8zzUpUEfuRsnFiX5jH8D5zYk3yRnkbqjV1fRna8iaD+O0dGCZZqcrN41dolaA8fA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rDtSMky0;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wNMK7YRM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E107606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 13:14:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E107606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rDtSMky0;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wNMK7YRM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793970870; x=1825506870;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wDAR78tMiMWM19O3Ds9HpLUSWiGBDV9BLPjX9aq5H5Q=;
  b=rDtSMky0Y8pVOP1EE5dnRmRsTVZ+X+fYGBznxPp0fA3Yz255dc3YysvF
   Rbw6AWp5db+w++2fMxm/9IPlai5nB4EqWcBO7gLM5nssNpfrmKXMR0K9E
   EPDLixvpFd/HZw9Uv4IqhmatycJ9RA8qzrNwHEl0qgkAJ2GiyuIfyMgpN
   fzsBy5kP5yO1yS0zKiTeaT0fCViPy78IGRALBij9RZv0oB7JP2+QG3YHk
   7bpeWSn96nCv0zNmfdkonoogNnqi65ZhC5x6xkjislBP31NkULqyVLqaH
   o9I5jERNPQCuC9vLt/zKS1XSXk0h98Fxpqlin7WE11yB0W+vYXlpodhJb
   w==;
X-CSE-ConnectionGUID: aOe1bEroSPCd49mMash/uw==
X-CSE-MsgGUID: wSQ8qkEITQeZporz/AsAMA==
X-IronPort-AV: E=Sophos;i="6.27,197,1786982400"; 
   d="scan'208";a="159919047"
Received: from mail-northcentralusazon11010042.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Nov 2026 21:14:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NlTwcA2skV6P3bbEaFjIDJZ59zDlE6quTGb/6pyz3Xw0KVi9WhBTYrwD3RfqpRevYzyf0oot5HrmohUe0D1aIXCkt/wLxhFuZdoMi8m6T01pt8PGRba/wThw1i2hDbIMj/k3B7v+k6SMKwRFCDCTDotEDhrCwKWiHDj91RuEZx1UlxSy1EED04atbvPl26QcD1DVcLdkeonoBA2mXr6zYg5WcfwOAmwUR/5KZm2lXrzvokKAAB+86gBjKGGmqV/VwRv7LDnXK6B9FR1RLLWmvHyQg9m/xsg1LPRSsTd/nex63apW3sgELanRsbJRpnAYv0QVioICZok0mtPOGxWWUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVMtsIChlls6bL6CViQMjyS+VzoPeb1drF9JjZRDfl4=;
 b=t4KJrJj5KzorfhBTOw+2oW8l2mPyYW4/vj5TJwWXptr0aN2ShazR9akAWmE3FkMAxMWdUoIikTGICG1+zbA+Ry8EsJefmOgI8dAx1rUFcvnUUwkMd25AKCcf3mEc9TAVIdmrO+LNwjEQBAcGgIF/aZUdAmEx8dzYp4UTYIY8BJdg3uHsPrj8yzji8oARbJK5SqHOigs6AtBpgX4TdX2ixNp0EStHgPcrTK4P+ncPiiBGoXETqpyfQM9xnuzbRHG7uGaGlM/WfDhvh+wG2ptWwET6zmz0tKnSdUaQmXt6Z7CWd/lb1oG8ZXEjsKfLA5jFXhQ4kEkBm25fyuaDI7CHqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVMtsIChlls6bL6CViQMjyS+VzoPeb1drF9JjZRDfl4=;
 b=wNMK7YRM3jXUxBUGJSmF/rVO0SuhUbmItP+RYKWt2wIBs7FMF5C5r7YpJDNE7SDkazUFsF57r7vyyTCcPZkwR78taeG2DMaw/XFFh9J1SzmHcGpT1xQ1J2G4Ty3y5dLcucuCkbFfqO6yFN7H4+DxfG4VzXJoa+vCUnJvAnkDnGU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB7778.namprd04.prod.outlook.com (2603:10b6:303:13e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Fri, 6 Nov 2026
 13:14:26 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 13:14:26 +0000
Message-ID: <1a991e40-211e-4da0-bbce-2359d9db5f08@wdc.com>
Date: Fri, 6 Nov 2026 14:14:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/25] btrfs: zoned: fixes for generic/747
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Filipe Manana <fdmanana@suse.com>,
 WenRuo Qu <wqu@suse.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Dongjiang Zhu <zhudongjiang@fygo.io>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::16) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB7778:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b66be5-e3ef-44da-02b0-08df3c07e20a
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|1800799024|366016|56012099006|11063799006|261026121527099003|261021121427099003|261102123227099003|261009223027099003|261022075727099003|261026140227099003|261022105027099003|261028144727099003|10067099003|18002099003|22082099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
 cB3EBCsKFXCo2I035EQhtdf7Q9WDrnZs2OffVIrQBVjOw4U/pKAgySQ34fikymaCMd//Hlp+5XVFOk3s2DGeGO7nwfNgz9jPjd6tJiCFCZ7uDQfKG2Z0QbTvdWG9k9vB04c/A1pX5wkZuyzjvwyvbuZZFObB2kXCnTVK4Qn/yAjZDGaUkIZmNkuiNnmFKbEEIIGIi8GXPUtrqCHbCXbDPry+Um8mW6AOLdbFnBGo1/oNnvZUVGNCiM9aLumii39e2di11NSMXIMw0W/jC1AUwVdTqmbvtJLLT8OnSzqVaaxEhhlueFo0v5czjzc5fmw+pGHXd9nf6Qp4qIp13pjJ4/Ty6XnCe1TkqlXZupv71UgqS2Bn/qF1qcawWbItAHibKHwYN7ffwyxYs+VTir+dtyfDg9OR3ZCGsDUwmAh8dcsdNb3Bixu0uvzdRNOgkN0mYHdv60VuC2o5LkiY0gXMGg60F7M9CKMAS5qnTeHA7uN9a2GI6x7eN4ACWC2MDonq2mIos2nK2AZj/psrsecsfM2loae43Odsmp5+UKwLuRkFfX+JUI+tVkf2JcmYoErxhy6VhfImDXxRgyTeBTnHtMYRCyMpLKCCOBf0RqOcv30Wx7/YCMEUnGjm5IdKCiv0
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(1800799024)(366016)(56012099006)(11063799006)(261026121527099003)(261021121427099003)(261102123227099003)(261009223027099003)(261022075727099003)(261026140227099003)(261022105027099003)(261028144727099003)(10067099003)(18002099003)(22082099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WFhZWlBWVWozN2JGNUd5b20vVGN0VzZNR3ZuNlRJbmdLUkhkQlV3WnIxaklE?=
 =?utf-8?B?OHBoWW1BVGNpZEZvT3BGM2d2dFRzYzl6NXJLczJGYld3eHJNbGJyTjlVLzlP?=
 =?utf-8?B?cFp2WGl0TitTRzNocGNBelhwYVV2endMS2RVY3FHNEhjbVZKSHZHYVl0M2dK?=
 =?utf-8?B?ZGhHbGlScGlRUDY1WDQwbmNFWTVLRzhpSng4SkFOQzkwbUpOWXRIUWMwOUVQ?=
 =?utf-8?B?TlA1UE9iOTBxV3pjWFAweXNpUjltU0svcVpGUkVBSkZZblMvWDR4NGN1bFNh?=
 =?utf-8?B?S2ZYZ0p2SEcwdVdLS2N2M3JDNnArNXhDRlFmcElzWWRET09ZLzFZYVAvNGFQ?=
 =?utf-8?B?ZUNibWptOFk1OHN5d2Ivcm1rY05VdkZmNUQzMkw2MktGdVZTLzYydi8rYzJs?=
 =?utf-8?B?WjY3WUo5bW1HRk1IamIvaGZKdFphZ0dZQkZ5cFZWZlo3bW0vL2tsVHpac21F?=
 =?utf-8?B?T0FKaUszSG05ajNYK0xSdHJmNXpKMFQzZ2NyV0l2cHk3NDFqZjlDLzg2MEFL?=
 =?utf-8?B?dWJObkJJdm5WRGRQL3Y2bjVxUEtrRnI1eEx1Q2NwME41RnpFNkVkUklKV0pw?=
 =?utf-8?B?em5JS0g2N0w4UmdFa1RxVEtFSElmZlNheTI1M3pUbTBzaUtoRklsLzJMbjRQ?=
 =?utf-8?B?aVVEbEVZY29HWEJXR1V4eFNhUnNZNUNJWHBWZ0gvN05GZUpITVF2djJFbC9F?=
 =?utf-8?B?bDFSbTNwUnBJQVhaUk5FWDY3OU41MzBwNkNRS0tGRi9zZ0pLZkJvN0ptanRL?=
 =?utf-8?B?bDhkSyt2Uzh4UjJuNkNEOTAzY0p2QkF4a2NBMm5ycU14M0ZRTUlCSU90UXVj?=
 =?utf-8?B?NDZWYXBaSUFRbE1HQ0ROV3E0cFBNTTBkWFJWVVRTVE9LTkRNamlkWk9OcXc0?=
 =?utf-8?B?cC9idys1YmhtaktDd2pjMVhGU3R0YktsYWpIblh1QWZ6TmVWalk4MVZodDJO?=
 =?utf-8?B?R000ZU5qL3V5S0Y3a2RaNzhMbDZYY0RnZnRLM21lNkZvczBzM3JEanhmSStt?=
 =?utf-8?B?aFNmalovdVU5MS9tdGh2RDhIaFc5WUpsWUtkV0tOVTNGSGVHOXhVSEEyd3l1?=
 =?utf-8?B?WXV2UzNqM2k5blR6NGQyVkltMXdoYU9PSFIzQXlIYlFEbDdYUmZobStCMmJl?=
 =?utf-8?B?TlRVNWhxVmN5WmZMUE5ySnkwVUxNY3RuU3FHaElEbEs3VzhxQUZPRHh1eWtC?=
 =?utf-8?B?bElPTzRudnhwNUdJelA2L3ZGeElFL3EwUHdGZkRKTUt0bGQ4RytYSEthRGNT?=
 =?utf-8?B?eHYzL0YxaFFES1gxMFlKcURCTnRQei9VbHZMMlZDYlp1TG95UHVTL2dsS1F0?=
 =?utf-8?B?alFZeGF2OXA3eVJ5L1N0cHArNGlmVTgwSGxPcHpRaDh2WkRweUJWcE9kaDEx?=
 =?utf-8?B?YXVhamlCUXdDSmtPUHBXSWkrUUJteXpDb0w5YllPOW1ETlZNMndzSzBnVXVP?=
 =?utf-8?B?MUFiWmJ4T2ZlRm5kOWhqamVrTVEwRTFlRnZCaVpQWU5mMlhvTXpwWHBWQTFK?=
 =?utf-8?B?dVBjSVVQYlNxcjNNT2VRUXZsQVhwazNGOUQzNHJpYndYT2V0dFZKZUVGbUEz?=
 =?utf-8?B?MzV1eHMvV2k3VUF4WTNPRE1FYlluQ3lhRUpkYU5kd2hKZk9ucUs1Y0UrcE5C?=
 =?utf-8?B?dmsxRVU1U3FHTjdpN0trY1pKcTc2amtoSTNhQ3NNOXpFSmY0RFZiTFhDSlV3?=
 =?utf-8?B?ejc4RGw5anBDeTBxdzc5bFFGa20vZnBIOTg3Ny9wWmNRYjBQVUNOelpYRFRQ?=
 =?utf-8?B?RktKYVFDOFZHT2d6SWRXYzRocFZRMXlIQTFrK3NmbE9Sd3lWejdpQnRmQVRQ?=
 =?utf-8?B?clBpcmNidVhUd0xFcmdGd1g3RTM3VTg1d054bmxmOXdvT0Ztc1VmSzd5ajZX?=
 =?utf-8?B?NWViNU41WnRmK1QxRHB4K3ZsMEdTUnd0NzdzL1FDZDRybWRxRnBuUnFaQnlW?=
 =?utf-8?B?SGFDZmVydVA5b0tEWHE0U3R5SVNXQ1l5UXIvTVZvcnFVZjFqUnNza1o1ckY1?=
 =?utf-8?B?ZzdhdnVEVk9RbEl5YkRqK3JPRUQrYlJOWWlKU240cUVTRjljWms5ZGV1VGhj?=
 =?utf-8?B?VUxiNGVxR3VRN3BWK1VtZjk4bGcvT3UvMzRTalQydVcvemxTdi9pSkQ0ZFM0?=
 =?utf-8?B?RXhYZ3FGS3Q2amF3RVNPN05jVG4vQjJOcDNONnh1ak1rVDZUai9MMjVVZk5I?=
 =?utf-8?B?ZFpRNXR1K3NkUVVyNkZnUzJNaVEvd1lTTXBPbUlUT1JmNThHdmZXdk5lU2pq?=
 =?utf-8?B?MjNxQ3BWOWlObXI1b0xPUGpGOGJyakNqb2I3TWpNU1FOTTB2ZmFSMnlOY3dI?=
 =?utf-8?B?YnRmd2FSemhlb2J6Y3ZGeEFvNmZRbGJSZVNoQ1BwbkVmSDY5MU5KOGpjRTBM?=
 =?utf-8?Q?jYvxNZH4isfDlXsEq7t1+MkVp/79IXRG/l8U5cctrB77L?=
X-MS-Exchange-AntiSpam-MessageData-1: uM/aI3zZHn8rg1lnsrLTcb4vtbndl5ItYTU=
X-Exchange-RoutingPolicyChecked:
	VyurjW9ysOusjdOozj1hIC7Pg9jdKBcxRpLyMALXv+XF7iQ5rUu1wo8dyNCwaJxHVrJVwzicAlnesr8V0MPyM+G/cy+RZKfOzO1iBYXa7CCuig8f+C9B9/rnaEqf86clNL8drcsjJeq7GcnP6/5ilFjJGckVUf9eBjghVbjtu08Rgra+XBBxV4THyGpBn5O1CEVfX95s3aa4VpCVpc9XbhacRmAs/QZPXOTU/pKE3QX+A5j7cxECEICkrzXPCqq0yjJZWK46bfYzBdkQUdR2o7DeKg/hsjKQd2wMABnbMQMvbiAikRbEWSZaqXiZIhtFZnfvKXwQInPyDlO2ePZgQw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NYj4IjWGUWlQ3hSheAJhi0dW+c9/JiVtwcW8H5mxCodTZGJK1jGO0QN9O+e04maNdQagOZXKjbzd3kz+Ww0oMpHKQLq2aMqRssOMVpnsEbUOHr+WT4t0UZNpoDKGp8mS5YEjwd05gpUrLRl20a8Wqqc2EMrywweSEBxnvaKztw3qjjbfh9uYdq950BJ/d9sHLYgfxdV/i0dqSBp8o4197VZZBff6xNH0Q8/V8VjJdIFPyxQQ2EVCDGv/oB/MG5/eLTUv534zyWY48eg+Z2dX2ige4BHFFm/YCT3dBpdxSgvGmO9Ly10gOY4DDMbhn8SuFU6/r7KeN+t8Hyrg7b4r1rYdEUMNrNTXh48IL4m/6Ru4q9Xash1qI3rJQ5GsNyML4AmyyEhg0h/xp4PiX0nlVReSyySX/Vkh7E2pYoRFQIUxkYTcu4HdZGMSt9vdjiNNtAxDPSjCOzOd7jSCDiiWsT9bHL+soLjJc+00ENHhfQASKsJgKlH5gCeaa7tM4zL1h8V6qOcPsYk+T8bd1M564x+aLu7chvDQ7L9vcrrVnbuVEYMLop4Dx5E3ejsXqVli2qxvFUpulXjyUFTHkoGWJlRtwZvz465PHDUq9nm3OC50mNg2+HmmtxYLpXQPVWjO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b66be5-e3ef-44da-02b0-08df3c07e20a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 13:14:26.5667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afo9crDvyxQlDe2seUyrg9eKWzNf1wE6w1ChyVpXa/kQN/ElDG2CyQp6hvSL/4Ksj4NseSZcnrMVpzyUIQAcpKLdqfipckt3riCWg3Wv2zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7778

On 10/28/26 7:20 PM, Johannes Thumshirn wrote:
> At the moment, zoned btrfs places doesn't distinguish between DATA and
> METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
> METADATA and SYSTEM block-groups can end up on sequential write only
> zones of a drive. This adds a lot of complexity, as we can only append
> to these zones (and not perform random writes) and for METADATA we need
> to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().
>
> Also the write stream for METADATA is not allowed to have any "holes" in
> it and must be aligned to the write pointer, which was a source of hard
> to fix bugs in the past.
>
> This series introduces a split in the block-group allocation path on
> zoned filesystems. For METADATA and SYSTEM block-groups try to place
> them on conventional zones if the device has them and enough are free.
> Then change the allocation in these block-groups from the zoned
> allocator to the unclustered allocator. The reverse is done for DATA
> block-groups, which can be trivially written on sequential write
> required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
> a high queue-depth.
>
> In addition to this, this series reworks how garbage collection works in
> zoned btrfs by a tackling the remaining accounting problems and
> relocation still being triggered not timely enough to evacuate the space
> the user write needs.
>
> NOTE: this is a combination of
> https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
> and
> https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
>
> Because it makes more sense to see both patchset as a single feature.
Can someone have a look into that series, it really improves the user 
experience on zoned devices a lot.
