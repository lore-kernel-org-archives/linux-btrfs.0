Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794581160;
	b=R/oSnLYvzRmi2B/8ARFTZOZRHiAG9F2kosmZDr6pXl+KRH2XXjLwQ5rSB8uqBEf4oeiF
	 YOp4iggJoGx/ufb0jWekXPtznsBMQfIpB/KTDBrvgv5XdmCpLen+V5fjw3+J79tTWueWt
	 En2wCfXePgR+2gfZ8e5rectXqGOqySMgT4DDPKLbhVTF3x/u+J/OrbyBCOjbHfZVUGjy4
	 uG7vYuNaUGncO1v1B5hb/chG74Nlgno0U/p+GQnDRF8ZVkMgHDPL74Ybiu+rwaOqr5xTK
	 osNjnXX5BpHYcd0sd+PU7OiW3tX4GIG0qqGPsWjR0d0wJJQEPcZrFpBl5j60NyUgTeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794581160;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
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
	bh=a8qZ8N/907g/1LaJZTwiXixKupLPsHTSiCYEoQtT3AU=;
	b=HHChjlbL/VeCZnN4S0tdKswkIAk18qWPebQkVXW5w065KG0fwL9WqVWLa2iJuWZH3zxv
	 xZ4vQMvZPl4bpbcWhrnVb6M6Xuwu3aX4BcEfjkrsFJYHN8RdD8O35ARWtT5tIRGbNS1aE
	 aP+XBRdEPsARCKpKs8XTkbhbV9SRQvg08ADsaslPe33qNHS/ulYqRO8+/cE2z2AQZdCVf
	 pwMyFXt+4ebQfDo0iVKLTd+9GDuCbyiRQmkHTYvuuKxx/rJiuP47ICqbNPEplAqs5nqaE
	 RX+MWTMQ9MRcmkjxFCjm7CE8IrMhmDcBGdHQNp8slPWwOh1Y/tYL0cGcASlzfyrsdGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZAb4KwPm;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=teZuWp2k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56184606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 14:46:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56184606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZAb4KwPm;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=teZuWp2k
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794581160; x=1826117160;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A5i+TWWjjiMNEf1UHk5NRkdv9Nt8X+zoh7dpI7YKr2w=;
  b=ZAb4KwPm4IdoghjFSsHEoSbzOOMm9vjmv4+0I55z52qAd146/Z67nrQL
   IoXeFEbwsGwFeZoe6QQjrDrxvhxOj7ko6v8ZORVQwtbmPPDAuarMgz3c5
   eRkIYtSOK9Yxtl7HDG5kMT7IhmbiQGB/+5J2vCmjcPxy9yVXIShxFbrSi
   Ml4I3LshOvV2i4r22wKrnDKRnnZQrnHcMv0bMUVQj0Q6ilzCsMuCdZ8sw
   3Z+0JxEAssZq21G33Z1DqzF7+Hn7sQA4+4425FBWUa0g65Bnaw1ze//+q
   rq3sYh+gQ98+a/1OACVNoNAmr74rN9oV1hUfcozQM5fIKbbVpmkH32e4C
   Q==;
X-CSE-ConnectionGUID: /1jnZW9xQ3yGPOwx9BwTbw==
X-CSE-MsgGUID: oIJd6T5uQbOSjgu3m017+w==
X-IronPort-AV: E=Sophos;i="6.27,211,1786982400"; 
   d="scan'208";a="160812947"
Received: from mail-eastusazon11011015.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2026 22:45:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJgnr9absNjT0XofCS8VogK/+5q9ZbsTReSyeIGphB7olK8OxDggxdoimVzXYb7V6tiZny86emO1AdBotsZ8vLbBIEdzma1oSrRCkYEV3ONItTgfCXRUCsKGcoXdQnz9On2VTDx6UghUNxVZCyDbVzxHay87UrrqFqF/XC7YXfkH8B494boawRzg5zysogIxNWv+7TFD9hGzxPWZgGKhi/okW4Ag2D9AYBGzBY8R6GEVAET57ln9VZTGWQRdXNugFRa30Q2VpwCvRxNHZZ6MFW9+4CTnSug4yz7AkSYw1/M+ChjzFb1z5hIJPDenimVxTwDukjtUpwKrEBEKuuPlEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8qZ8N/907g/1LaJZTwiXixKupLPsHTSiCYEoQtT3AU=;
 b=rIOv4cpmsV5J/mWrcO92BbJfzVgrCN86NQKffFjnOCZQqD8epVslzuNHdCtIF+pB1uT4gegylAzg9eZR3w9sJx1xBXAwipA2RZ7yPWef60IUC3GZIfbyXJvqA0CnjyGnBka4WGxAEEXJEAvRRqvnblbQukp2HNcdQvWYgrBxcMhJAajXfzgkNx9PThVV1DniMuKxZ3wBraPZTBR5qoWj/CqlYPy7Nao0nm2G9qMkdylEhl++YLiG8GghByJTTZ60r9xqeMo1LJ4vhGVERS2ec5AEbkmQGdRZRa3Xmiiq5Ia484Blfi+UJYrYM1UAF4pCCQncyCV2eYUIwp058H6FIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8qZ8N/907g/1LaJZTwiXixKupLPsHTSiCYEoQtT3AU=;
 b=teZuWp2kO4Hyq9wFWHMxUSO4un9C3eJ2BImkwFMIVrwE9oxHww9xTUfdjnmDiMO0DclJk96Aa4zSAbPb8/Sh/UQYlL3Ua1tcMtHKS6KeVMYJMzgoCoTZG8xbv5Re2S9/k8oTyaPyeuHUXgksbvqtHUUyygTdU0VqEPZ9DgAaTSY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB7779.namprd04.prod.outlook.com (2603:10b6:303:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 14:45:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 14:45:35 +0000
Message-ID: <387ec20e-1fe0-4aa5-86a5-fd51f9be0f80@wdc.com>
Date: Fri, 13 Nov 2026 15:45:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations
 for conventional zones
To: Jochen Philipp <a2jphilipp@gmail.com>,
 Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com>
 <CAD=K2o8OvHTxo5o9ZNavnbzchtLqwFT2W6YiuKLMNux9qMRt6A@mail.gmail.com>
 <914ceff5-cce8-4716-8763-34e4e4a9b49f@fygo.io>
 <CAD=K2o-yjUDPKJ_kFUur62z-JsXdNhT6YnEUftgtgoCZ6qG-oQ@mail.gmail.com>
 <CAD=K2o8t1zO+-d0H093C6fEsD-tM6nDq5FRPadW8jjviuO6CSQ@mail.gmail.com>
 <CAD=K2o-ZYEY8dextmLedERe0kUxKCuvhcK2vVZeahB0VTKVCjw@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAD=K2o-ZYEY8dextmLedERe0kUxKCuvhcK2vVZeahB0VTKVCjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0048.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::16) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a30a3cb-10fa-462a-953d-08df4194c65f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|376014|366016|1800799024|11063799006|4143699003|56012099006|261026140227099003|261028144727099003|261022105027099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u9re3cOmx6+TulkZh6DEO33bHK5aIBtUtARA7v4rA7TE4tGzTTsZ9V3U1pWDk0elDLt+dWDz/dA4RYrwjB9u2C7oxM4/uvRJ+RyXSFHcGvM5HkF1+6UZTI43C57pQHqMJbt7Tu/DeBrvvwrwfrrYz/Sh5PXtqJjwZaVQfOo1VxYep2nonCSKLIx6QC+snBfeZL8mjWxRIW24nByOCawdIiy6tTvvCovRKhm5m0p1FZziH21QycGxuaZqA8mpWvzgWH9uRXJKwOXaB5BFgFZLTvYHDTwLhm8Kedq6WqRFFKpEGQSMsI8wwImJTrOCpQ2wm0mLwbcrqvMfJ26wo2+1PDkacGATHg2L+hIEPlmZ8jS7gQkVI/pAG+Hf7Dz26ou9gnwUAYYVCPhA5g2kenhpRZhuNAzfcQfgu8X+y51xrt88m1wSO7+r3nltS6QUWSidtGGoEgiNQzH6YW4jsP4j/C1zTcSzwvbMBAI7UV5UqDMa7AYpneHjGMYh7RiVhflkHsMY5btovejvVahtUwPSDLMJzNw8VFyMQ8sAtmnjtSD8J3BiRt8akZ3C05R14zPdha01tTEst5kcFEyfPG0rCrz/YpuZMcJoXRXankB4DlZAz5c5RXdVHo7SuO55MCt1mYxkOwGU/6Jwml01NzO9jvMRdjKy+KQu2S0r9CWzMV4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(376014)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(261026140227099003)(261028144727099003)(261022105027099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjlQc3Q1dk1XTzF6R2pKTk40ajNOT3lHczlhemsvYkNqdWI0SWZDUFVjSXVQ?=
 =?utf-8?B?aXZXMlFLS3FHYy9vQXZDWU41STA2S2E4cjZzb3M3c2VHQStCODJTY2RDRXVJ?=
 =?utf-8?B?emgvcDJhZkFrL04zQWFyMmJVTURIdkh3UDh1N29CZzFFSXZQcEsvdzR1S2tq?=
 =?utf-8?B?YXRWZkc2djM0enBYbllqNlpsdUMxWk5wRXFRRDdOYTVTeU5kSzcxNlBTcHZE?=
 =?utf-8?B?VjNJV1dUejcraitBQ3AyTnhqRjgwWXVjcS9Hc1NWOTNCRDlSMjM5Qi9qNloz?=
 =?utf-8?B?a0R4TWVieXh4VWN2WGRtdnRUY28yTkNrU2VnTmI4OWRGN2U1OFFreFREWjVt?=
 =?utf-8?B?aUExWnRlVDdGTUo1Q1RZQXE1QlJjK1FSUmg1UVdLVDVKQ00vL0xBSG56cVVs?=
 =?utf-8?B?aHo4VytLVCtwRXgyM0dFUmltdHk4WE5UaUZSVkl3LzlmRGpWTEtLMXR6QUtX?=
 =?utf-8?B?VldTQ0xhNlVRZDBySzQraEUySGtuQm9rZmx3a3RTRzNCaHJieklaZzNYRU9J?=
 =?utf-8?B?SFdZcCs1bG5Gb0VWcENiaGptVTliN05NWlhuRUdpdmMxZElVRzMrcEtlTThs?=
 =?utf-8?B?TVZqeXNlUVQvQ1ZoVnBQTjBpZzBJZ0VBOW5ZN3o4WkpreEQ4anlVNHUvSEJ3?=
 =?utf-8?B?UWthRjJhSnNUQzNvazJPSkxsM21Wc1kyU2RxeHl3UkVneUpKUmFMVXkrdWhw?=
 =?utf-8?B?YVlCcWl1WVRGUmJ1aEZTVVFLeWJaVlRBL0loTDlycEttN0NlcTRvRi80MlhI?=
 =?utf-8?B?WXhXYXZIbitHbVhOZ2l0bGFGMzhDREFDNzFUTTFaU25oNTgrWWhOVlZSMk5B?=
 =?utf-8?B?V1JXVmpLUDUyNHRNTU9ZTHpiMC96UGo1YXdqUVB4dDhCVUJhZTJTWnl1UG9n?=
 =?utf-8?B?bzVTS0VRZFRmWGQ4dWplYUF3Zzc5QTEwYTRoeXF0bmcxTVV1U2ZFcmJwK1VJ?=
 =?utf-8?B?c1YwTlpVNHd1czdaaVpVTk9HeUw1S3g0VGxReGJsdEpxMEFTOEVjOHQ1S1RX?=
 =?utf-8?B?Rm9kN0lzK2VIUHhNUFU1MThFSnQxMDhLOEZ2Z0tXendZK3FhZ3BjTTl5Q0hX?=
 =?utf-8?B?YnE1QzNjWmdwRFA3QTc4a2FwUFMrRjMxZjJCVTlsbjJFTHdhQVpnMWtkUkpv?=
 =?utf-8?B?aGNJK3l1S0VrY1R2ZWpNMVJPbzR2QlVSQUV5YzZ4LzNVVTkyd0pBZnF5NDM5?=
 =?utf-8?B?U2dwM1VvREd3N09sekNXSDNWS2RpOElTRGFOWWdaYVZsR0xuNVJkQTRwK1Rt?=
 =?utf-8?B?T2NUWTYrTDVJKy9jbDM1SDlvZEVQZm5mbklEV3lEM2dvbisrOW5qNmNPd0Qx?=
 =?utf-8?B?MWk2WllZR0RGNzQvSS9EYXV0WFFQQVgwMThWc0xDQm8xcTM4SHdwUDM3ZWJ3?=
 =?utf-8?B?RDB1ekdlb0syekJQUHNmQzFUdHRNSEpQbmZvcTBDd2ZPbVliU1NIakFiYlRE?=
 =?utf-8?B?Z2JjUGxkcCs0MG9ldk40WGFIVnNIZ1krbmQ3M2VNQ20zMzlxMURBTUttYkRt?=
 =?utf-8?B?UHNGSnVvajdGL2o2VlFIRktNVWEreTFuM3RiODQ2V0pBNktYNGd6cW5VVits?=
 =?utf-8?B?dDJIWm44SlNWUUZJaTN6ejdHWDJRdDZtQzJoWUEvRDBGd3ppbGs0aDFEL0g4?=
 =?utf-8?B?NU5XcGtPR2VHb1FiaW5OQzQrTE5PTUlrUzMzTEVKUzZGKzQ4aVBsREw5NTlG?=
 =?utf-8?B?dmtpSnhkbVlrWDVNYTBpZEJad205eExFNkkrbzBQZ0o3RmpGNHZxNGprb0U0?=
 =?utf-8?B?YmNPMEJSZ2g2YXA2MFhNdVNLS1VmYXRFTTZBNlJkOVBjLzExWG1zaVRyOWQy?=
 =?utf-8?B?WVZ4VUlYMzdpYk5xMXJ4RTE4TEtSQno2bVM3dStsVkxQS3NYeTFob1VVN01o?=
 =?utf-8?B?aU5KV0tORU9RMVpzT25sTXF5VEN6OUphRFpLOEo4cTlHU1FiaTdpekxoTjZ3?=
 =?utf-8?B?eEpIOFVWS0h2ZHJQZ1hYUkx4ZTBLbEV5VUdpWWZ4dWlQemh5VUlHQXhXVHdv?=
 =?utf-8?B?U0xuN1FvaEZ1dnphREhUdVcvTWxYTjhDa1Fqb2pUdDN2aDV1d3NPeGNoUy9T?=
 =?utf-8?B?b25vT29OcWsxOFNvMXdEK2JsODZLM3JZak5kS3pDTzVHUU9RSDdkeFkxUVRv?=
 =?utf-8?B?bWtiaW9uQjhpQU1NTzhrd0tTaEE0cFk1WCtxTHJDSnBEbHNacWdBYTdwUTB2?=
 =?utf-8?B?bjdPaHBRNVdyV1hwV2Z2alV3SDZ2Z21ycDRDenJHdWgvYWl2MUJ2V2FGSFpI?=
 =?utf-8?B?RXdJRjM0VEpIdHdFTEI5Szd1OEJRNWlLaCt5eTd4cTFGN1FkUVM1R2FWMHow?=
 =?utf-8?B?bmEzcW4wL0phOEhNZUJvdEVMSkxzUHVUamczcG1hUzRzR0V0ZDBtbTFtWTBw?=
 =?utf-8?Q?u0xuvcBMvUd+4neTArilhfvKz3qQAk4g/UU2rqKH4foR+?=
X-MS-Exchange-AntiSpam-MessageData-1: 7jkE5IEBF6lOBzGXJn6gCTpZ+KDJtWp41jo=
X-Exchange-RoutingPolicyChecked:
	Vcahb5MqVJNe+15g0V4FIKVkhcQqVdQFLwys9wfTRMJAbTG2Rie07aFgBW1TjntF4PBLojrvg0bGB6+kK+bw/lq70YH6zgA4JvSvWPsDHZ+Ce0+ZeubS+raoFQdUf82G/7PUq7cTkjPmTUZgOISmZAUcTGGPX8MsllH6V/tnGytjb/bGWEn/CyHEVM0hKmcBWJoUYVd1RMnfiR2MEqdLe0EVOYBHnttD+d6ygveJqWDWqEfmCHLSse2FVxs3MoTE8/+hy1M8LclV51NiSDuL7/GPw5QrPMBtIPFMPOYkkBJ/xvOSyA3xXd3C/jUY0aVTfnRDL/QVmUXwpM0plruqCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GP4qZWbReo7dzYfU+ugfTn18g2//zgSeK6NaUsVo5Z5yGOk4Bgsgxtg88Si/1CGh2DswEKHvGuyhV3Z4g1HzFIbUBZok5ogxoGSZqke2ACCR2VYkhIuEpFv1DFu1V1Ae/bqo0XQw5lhjMusXKSm12Ox58qzaxJv5iH9VRNXSPOx4u9RTunDOYlT92KgeoeZx64M+L2xJ82erAJXoivDSkBcdWzHL5FqGsMlyotOF4K+J2Ri0bI2H6JcKRm6h5YdELna7TUQrvPN+sf0c5EPpBkcxEKycZ8RTdEu2v5/cEND0fAgeHee+u5We7YPobOdT7/B8A70INcAqazB+sfHrWl4kGrJfJ3fB5ToekoyuDfSxf3yZFPsjHtgGSYJG8qVjC0CEb5Njq7pMnULPPN1fPtwF9UeXRP7/e41xnwfz6JZYJkAJF9oF0XNamzRDOo2TjbtsT9DHOwkVhZSz4ey73tJvDvI1ziNNFyvz6zorUN1aHtvEjwEQGlnT2ThAusz+BFv92Ugzu3jap8iWF+8aL8CY/EIJv9bCoJWodxblEyd/bwGiDSladuUS6H9Y4eW2NBbDCBuyT1h2QVPLnnUlLk2nIJEhT5/dZq8SeOBD4CivBkPxSyi3u0gudKvejBXW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a30a3cb-10fa-462a-953d-08df4194c65f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:45:35.1907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQOKympm4XIevh8+SIORaGitFfuwXjBTaMgne7K0sVrB9ZNG/cb7ReabtdK/GPwIy5qKDjLfJuhco76rDr00mbHCSXZhPVaUFlR0NmlX6Q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7779

On 11/13/26 3:00 PM, Jochen Philipp wrote:
> Hi Dongjiang,
>
> quick update after the first write test:
>
> - copied 57 GB via rsync, no errors in dmesg (only some
>    correctable PCIe AER messages on the chipset link, unrelated
>    to btrfs as far as I can tell)
> - closed zones dropped from 124 to 5 after the copy + sync
> - umount, btrfs check --readonly: no error found
> - mounted again, transid 875, stays rw past the first commit
>
> Next I'll do a larger run (a few hundred GB, maybe overnight).

I have two more patches that should prevent this and a 3rd refusing to 
mount such an FS RW. Additionally I have a series for fsck to repair it. 
And now that emails actually work again I can send it out once it's 
looking a bit more polished.


