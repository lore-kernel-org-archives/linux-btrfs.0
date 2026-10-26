Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793030683;
	b=2l7ZbORaXO500gtuNqkDSMumeIG/sfa6Ae3hJHRO28wQmfJqIu+oSJlq3CE7tcNl06ml
	 yHsJ/01wNJTS0HFhiLyltpXksJIlikBQLuCUI1zFH9oa9HNV6xX2rGHuXMKkS2eMP9hor
	 IQaL97AHJmEbaVZL93I5iSBTLSJvB8sL2IPNcQYHY6W3VaP4j6TJoqQ6VkkL6izeXSWks
	 lZJh4K0tDM29dQI/57TtImvLbmM6GBSzJ1KUVA4LMaTVlzS5e0NtI22l8zRmf8UqXZ4Ro
	 YkHRtbj80o58Jf8HVq/c2qkF4E6tu/Fj+Uo23jpAe660LVKbJRKay2aA2vEc7VoUIpQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793030683;
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
	bh=s9ap7q2vBdcOkwJjT6hPT6pFbz9pTdi1CH1zw5owXdg=;
	b=TqIEzlO9nibW7d7SAeqEszS7x9VHg+3Fsa0KXYPe6m25BFayRqtHGAznFX/uNLbe7kgr
	 9kOKKpV2HF/v+eaSLR3dpe837zyakyVAYbDhzQEKVPSwZQLnA1cnyA0ISh2hchIxgkyRq
	 GohrObE9lqZIMnV7j3uiEnSK0afmssFchvSqM6O/+rExnOYUAIxDssTCOuMLX2xVPlImg
	 ILB9SLuzFlTZRC3ebbSaqm1H+l3YplVoOfomLoQrlbtLYNMHTQsWUjUp/NdiO31kgfWqG
	 we6TpZEFaDNN7XXON/REPJaJw6AridD3nZpbjZhU8/oJB5XSHUjLsU6bwmFSuAjG6Ag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nRZBb41y;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=G93jG9iz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74510606A31D;
	Mon, 26 Oct 2026 16:04:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74510606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nRZBb41y;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=G93jG9iz
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793030689; x=1824566689;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=s9ap7q2vBdcOkwJjT6hPT6pFbz9pTdi1CH1zw5owXdg=;
  b=nRZBb41ydLOjCAYxjfCHXVAtxvHBNXAXz3dcVjJH2tvZyQfRpC+ruGj3
   e5amX8Oxp/cx8fxHL4mlc0/tbhGQy359kxTDu2Hok8WpaLAKE4R2KlSbw
   QmUWANsqiCFiQpAPV/Gi5wIsELz85kDYoAwZgRYzAAgIQBAFikf1DpvHJ
   txgmoeel1dhQGqmkd93dQ2OJH4WzkiEsmBKegwRekMw9w9Ujc0r8U3HGQ
   hO1yZn6ycYLecmOW56JVn/V9x/SMjISYgnV3jkeVfXCQZIcwdiGkWsMV0
   zATHUpoQ8yGiSxrHEfe3y1I7YO7FjwumHpW5a19RsB8ENs5eN0aVklHef
   g==;
X-CSE-ConnectionGUID: pXNy/yRbQDG4WFRIKkU8BA==
X-CSE-MsgGUID: I/e7a6VFQsqsZZh0Hwuxhw==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="154803976"
Received: from mail-westus3azon11011031.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:04:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AcXKp3UaSIilW5T0jNvT9Rg4XTuYSrSISJfCBeuXP25opVyqhCEoJyXzH6br3ELuFKFOEkXAOe0r5QE9okDKe+grVHFzV2EutBrpdmorIhzul+OJECiA/lyF3njKQ5POqbH0S0GXtOiL1V0j/tmhATXkqd6/KUCYdXe54saR1ysYM8Krbn9AVQdRbh1mUZOkOTkJQc9NDPoCGB55NWwAgAAIiUaS8Nh5zLdp3exDgOli7mz8kNrFlTXE7V4kLDud3Kf7kou31EN+mIfHZhxPzF+hKlLBDztdkD36Zaw0gNfnDykQwdbGqw8SIWRWd6fVc8IteHQWovSdpKVWeHpWwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9ap7q2vBdcOkwJjT6hPT6pFbz9pTdi1CH1zw5owXdg=;
 b=WzWKoyzL56Zj0Hu8hUrVCvQY42/F+lOzV0pK7oFV+pqgXB12Ntl80sA6mP8ZXstRLGK/IymOwgQJG+gcUb+tG7OHnvjg6rW5eWFqbcyo+d9bCmCb6Bma0HUbXpJWRUmQ2FNPElTHlcsUIovY9szRkR4X5FfXYiufe43qn/z0VQHGXEFDYYZJGnlcizhe2HR6nDI8SVnvg9ZH08jYrhVNtpnKtF3vjIUu6NDzMU0sNZjV3jfiYNJoANVBnVv55Q2MyB+kC6id/JCXeyzQSrglfcSBf0OWV7h6ll7kAU/UB5wxPMwmJ0ta2SuR184g6B2UI4c29i5QcG4ChzGY6NJP4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9ap7q2vBdcOkwJjT6hPT6pFbz9pTdi1CH1zw5owXdg=;
 b=G93jG9izaIL2ZCvL8y3vwzjxJL7Z0Cwgi40sGRNt0QVpT8iamuqrkRAzst3A7x61bKG/1Cq6fdrVbagAANorVY16vJb6m/oObwNeZNmQzPdSTs8UjGHNtPgZllouQO63AEV608I2BAaiYqVOj8rQFeQcFwUNYKaPZ9e1+kUvrxE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB8472.namprd04.prod.outlook.com (2603:10b6:a03:4e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:04:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:04:31 +0000
Message-ID: <a122e47c-d40e-404e-af0c-533b2eb9a42f@wdc.com>
Date: Mon, 26 Oct 2026 17:04:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: test that fsynced data on a RAID stripe tree
 survives a power failure
To: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
 Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org,
 Qu Wenruo <wqu@suse.com>
References: <20261023123451.90365-1-johannes.thumshirn@wdc.com>
 <at9zEEwdEjoJW2bP@zlang-mailbox>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <at9zEEwdEjoJW2bP@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0144.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::20) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: ab9789e4-b3e0-491e-2ed0-08df337ad1e0
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|10070799003|366016|19092799006|1800799024|10067099003|56012099006|261026121527099003|22082099003|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
 GrP7atH/S2C+j+O19pYsdWiUO09lppWqronhwEs1D0uQCqq2x/Nm9axKQ77eAaF5N/ypJmS7ocjROzysIcAU7bewz57vLgK/5R4uS8L/F2LEPHMKwbFTSvj1Bj3ZuoMPZCMu8DT28gYzGd5HFLisca2TV1slYLF5MEyCoulxID9lS5yiiCxKPacoPRrL36Z91myQhPZWpwy4Ni01dT4lXUHY/HEkD0qc5cKc75rZdrbAOmbMU9Ic0epY2IQO5xMlqPUrJ1F9uRHEaqn+/eFGFmZae0AV2TwrMVK3T3hJ99ED9RL3yUeMFIFdpm1AqbRC/2k3n0lm4EuG1c39OQAwexlQNvenknvpxT7WlxaDgBsuAF0Cr7n0u2u1DUly6CWGYx76q5lU5Vu6kl/Oln5D0Gd5bfl/bXlprvT180AmL8GcTjNcZM5U0wuHowL1To1Y+XRFkpnQtGITrgXYwgxX3g1+gBBv9yIZH/EPH6e8ieko96VD9PAvdIPkcpLUnbvO4RZ63bIlQl6Iu3n1Bwap7stbqNrXCj5BEah4PCWrmWzawjNOymF5lUGRNCsj46o4M562yqJ0GmX6/Be0YeipfRAbNibHNWKMrWlZWrdhXaSVsT7CrdwTqtgis270ahRQPk9plPTZRwZScxOlm8xSkqe3UVCE5jFr99fK8sG7G9Q=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(366016)(19092799006)(1800799024)(10067099003)(56012099006)(261026121527099003)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?V3l4ZVE4cndwR3kydlZQRU5DVHNHQ216eTNTdVNGOEhSSVgyckRRSkZpL2Vq?=
 =?utf-8?B?YmRHdmlJQnlOaXlNNm9YSWhNcUF4anNLc1VvOUk3ZnhHOUhwRlArWGRWRzB2?=
 =?utf-8?B?SUo4TlNTalVFRU9xTWZmdWFSMHNZblJWUG5aSnpOLzNKeDBDZjg3anhUUEcy?=
 =?utf-8?B?bWR0RVlyWFRMWWxRVy91c3VCTDQ4b2k3QnliWWpINjVnMjdrYnFmS0NJR0ZG?=
 =?utf-8?B?TTdlKzJScXZBcEJjaHJ2R09EVEc0YlZ1VjlUUmVYTDFFS1VFWVZycTdpRm1h?=
 =?utf-8?B?a2grYytnQVhuRHdtcmZ3VjZOV0MrQUJaOGNEY3V4Vlk1OUJwNXRtRVlsZ0dF?=
 =?utf-8?B?bUs3MUl5cGNTUTMzclRZZVoyTWt1TnorejRiVGFzQUVhdFlIY2w2ZCtHMTlU?=
 =?utf-8?B?OVVkZDJZOWpYSndSU2VBazNHM0FwZlNYMDNpUEViWFkzbjB1MSt3WFhiaUFW?=
 =?utf-8?B?WTAzZUUvNUtQRzJ5dG1Ibk8xN3lkRy9ISGJPNWoxWTJSNE43L28zRjYzcTB1?=
 =?utf-8?B?ZkZxU3ZHcUlaZm9iaWxYQzZuTU5vcis0ajRkUjVPbi82WEd6QlJmRXhqYlpz?=
 =?utf-8?B?T3Y3QUFBUGgxTDB5dmJkM2dqZ25xU0MxRy9RUEQybzB6V0RxeUxkTnFuZllU?=
 =?utf-8?B?VktVSzFrVU1RK3NvbjZJT3lub2JaSnZFVHJjQUlXaUp5MnR4YzFCSk1tYVpi?=
 =?utf-8?B?a1Q3WEk2SDBVMFZ0aGtqVFNrcXFKMjdPYURWQTNOaUNIa0xEbVBMVDFURlJH?=
 =?utf-8?B?dkFzUFlJRGFNQzArQ2xaYWhTOFBNSE1lV0NDbENpM0ZOMlN1YnZIckhUVjBx?=
 =?utf-8?B?TnBBcXdqa3hoWGxIdmlqem9TaW9ZSjhTbzh4NVErcjE3a0JrcXgyK1NUZmp1?=
 =?utf-8?B?VHM0QW4ra2wyYzN6RXk4UDkwMnRsb0pJTlA3NkxONDRBeXNmNCtyaWd3cWl3?=
 =?utf-8?B?amU1aGthMHV5cGx3bk9ETDdxQnA4SEpIOE90VitqVm5RQk9laUliWUsrd3JT?=
 =?utf-8?B?TGt4b2ZCR0Z2WE5JWktwbVdjZ0M4c3lETEhFNTB5QmFzdElLbWRlV0tsL0k1?=
 =?utf-8?B?UWdNYi95U1ExTHpWQkhhWkQ3NTFRNTdqM3pBcHV3cnRZZmFiTERrZjZrQU1J?=
 =?utf-8?B?cjZCVHpJZHNraE1kQnJXY05tTDVFME5manZlYmNFbk1uWk0zWG80eVE0MzBF?=
 =?utf-8?B?TGowdmpjekIwcGE5Ym4rbDRnMk1NSHdMc1F6Z09qRytPWEhwdVdwbC9kUnV2?=
 =?utf-8?B?MEtvbXRVb3l1ektYekQ1V3Y2eVZ0NmhoYVJMZzlwMnRENGQrU2NpcklvNzVJ?=
 =?utf-8?B?dlFFOVFhUXFUcTFKNVFRL2I1WFNGT3hSeXNWQ3oyUlFsNTBCM3ZIdEF6NXFJ?=
 =?utf-8?B?NnhXYkZpWUlCQWdYL0x4UjVnSk9yUklZLzMwNjRsRDlFckRGQS9QaEdacTBN?=
 =?utf-8?B?MFFOdjN2RWlpNFRsc1ZBS0hMRnJ0VzlwVzUyVG16Y1F6TmN1Yi90dEduQmpp?=
 =?utf-8?B?M3p6bFEwRGFaZ3huRjNqZ21hTjlXazJmeGpaVWtpSytrSmdwSFdJTW0zTTYw?=
 =?utf-8?B?MElrQUh2NjZOb0xWTkVCenEyL2ZEalExVk8yRWVFeVlKYUNGNmZYeVZocFBT?=
 =?utf-8?B?Q0x5MEN5akp2ek5qYW1Yb3BFVmlNWXdnU2RPaG8wdU9YR3FVSjlJTDNCL0JK?=
 =?utf-8?B?dXAwNjMvM2VYaVdkWGRGNjVCTFBxNk1hN0luR3VUT2pseDhwT0tVbEIwMWk2?=
 =?utf-8?B?REpZMFZ0QkpqdmcyU1RJd2JuK1BseG9XRjRFYmV0d3JzUDZucGozeXJ3cDNl?=
 =?utf-8?B?OGkvYzJYbjgxOXZFRjhLU0k0TFJUeE9nYis5YWlKaXNZQmNubyt1MHlwQlVO?=
 =?utf-8?B?czBjNHlDd1pnd3hMdEtneTJlZ1FjRVFvT1NjL3VXZHVidk50ZDA5L255Q08v?=
 =?utf-8?B?UEZKYWZzSWxaVFJxWUd2Q0ZVcXBjUEF5OHBtTnA1aUdJeklZS1g2ZkRVYUgy?=
 =?utf-8?B?Q1ZRYzFhQlJwVTBJYnpBckEzOHQyT0tTek92aFhNeU5EcUhON2k2ZkpEaUlO?=
 =?utf-8?B?Y3ZqYVZkM1BsQTZBdEtCbHNIdmgrenduZ1ZPU1F0eTAwQ3F6bnMzci9uR3V5?=
 =?utf-8?B?cEtwa2hiUGtuNW16Z1pHLzAwVzlRTkZjZVFxRFc5R1U1VW1Mdkg5S0NRWisy?=
 =?utf-8?B?N2FwL2V3NkZzWEdZZ1QyN0lmeFZkNHNCa0ZmWlJBVXpSNUlVSnlkWWcrOGNL?=
 =?utf-8?B?amY3NzFpM3RWMkdwUXRFM2hlMG9ES3JrY1lNcW5IRUVGYUNRYzdMZjF1Z2FT?=
 =?utf-8?B?R003RUFsbFkzVGc0NFhwWXlXRzVUSnQyWkxaOXkzZ1NhYXBzNWExQW56aUQ1?=
 =?utf-8?Q?Ji+IueqV1Q0Ewj/iF4LQaGfGEmVqgKwM/qAURZi4I2325?=
X-MS-Exchange-AntiSpam-MessageData-1: i+aUQYycR38Wvg==
X-Exchange-RoutingPolicyChecked:
	XYxv1CZdljdMKLurUv80NgsXEmyWfTH8lQmNHJoNp6C0M2QNfOuEQJIiTYTwzQmzgexQwnbVgBtWF2ueal4onz55nBD4IkPMhHaKdaKIKOCZdF71soAESNifO+sM4/+ovy+sOrfjtnPx1bStz7Q1kU3Bv+5n5Rw7kK7CyLoBa1s49BRwVvSYAMPhv2lr7N6nAY5inZCHAYwcLzModWY76qFpAgJC7cbeZ1LzRI1kuRhm6mtcbxljRNah6tjDBsx4biKqWoVMB1RSotd0hdRr8YKmJQ+wvMWHZitYK7aexztiE6Xk6cWOCi4vIC+S9DfCbiwABJ0Z53ES+eEtkxkLGA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h8PZ1SLtGqHYnPG+MyD2TtS692Daf2okHroTGiOd53GbZxQTsGH5q70GEyN0BuSH+VfqajloLRpiqf1OdHxDAnz0IkyutyFQyqHwPupFkSLuXZDDEvOrJvZf705CHU0h2mBbcA5MTvxBvU7wDwL8lZm6xUDB1ovzoTQ7E1GiMKjPaXrJsmTDXRF3UtAT25CD+7dyLy86k+KOOEG8a2Sv1jpFyNAyMWfCFccrSGGY438C+me8+SUs0fN1l/a6Te2rE1+F33LKhaOBgpWwFp9vtm7/gqwxpRDbCrjMfkxEVbeayOjUtTTkTFxHrCMl3H4TVr30kE1u97CtRxitXKkJ6IZX5my5s3G68jgcaiWLbTd+TlJGRsA0iYWYc8n/eh8id71F3gqJBNlyVrsrOjx2nvMXT2isiW0Zf+wwnLoOSh4Z5Wnvzt+QcqQ7ilgoKWzmJrYcrcUPBLqEj8ENVipW4EpoqVMnfw32lcDdC1+0qGQKPSj6kCSOe2M0gx+DMgK9UzrR65Y6w6Us1DD1wYcb6fYztRng+QHRsx8c2eoHHCSZbe5OTdFfZuM75SLzT0tYgeaFgXSYU4bgdNwfWRdP79DSJQGCYnUeMnAmEDNYz8rFu/kDWhLLy3katSdY+RAS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab9789e4-b3e0-491e-2ed0-08df337ad1e0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:04:31.2878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbVg5xmzaCVc5ABUpL1vjv9W0uXBToj1xOgnaLvj4o9YZ/ShXTFhFgY2ZIE5fejmMa/hA/zEPX1n3vkCKHDFJmdoEvHbBhy0afMus4818KM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8472

On 10/26/26 4:47 PM, Zorro Lang wrote:
> These are all minor review points. If there are no other comments, I can
> do these changes when merging.

Thanks

