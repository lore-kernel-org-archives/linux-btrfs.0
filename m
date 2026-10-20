Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792495433;
	b=n6AhBazv6leEFuxLTOd960V/TsKWcvz+GU5uSGhsrUfNXxf9GJIia76bcK9Dw202hXM4
	 VYI+I4cqZ0SdEpMfYuGk//IvPRcahoJLJfE46BfU1JFOjEKpilAC0f8vpuqiFIYbrJH2Z
	 VvYPbOuvXG+FA4ybQzG98hKTXID+M33CvnBpElww67utRqdeRcVvwhsaXCqFxhRZkCgZl
	 lbRAfYalxPml77wkUa5i4dWC8QsS3peTRRQLkBpHU3ds4weTU0WE49wTfZ+RCHtB9QoWd
	 BHKebXpKR1SathJDlC7VC8FfGoGA5CNQCwA3EFkdQrdeZhztrZpeALvlh5Z8zNQpRIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792495433;
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
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	b=FA4lECQFhIAYttgDu6CRA48PzrJn9OIl3kuOb8O3rGyUSDl0x10IwGJwp5zicrPhTXRV
	 0EFX+DT8MRN6vb66KGrlO9CMn8a4ZRekIL3DnAqhN/gwKclOik4RIXRTudeuE3UnuyoHw
	 1kS74dhn5adk4Fv/JYFJW646worlfKA1KEUGn4Zq8r821tpOt3FcPysXuyfN09SQFpCvP
	 1gLaAvtAoV52DuD2/xFxzmuN8fo7nVkXvPeCLm2LWdjry41j8QUgCcI5UBDR/GhEe4JX5
	 z1zm7e0z1jqpAI6k4AuM7D5RfyGmXQj5OB2kftXtmMBgqYBzMn/VDdiYCqyrsdy1H4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=X+LoqRZn;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=L+RpaKAp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7F9606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 11:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F7F9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=X+LoqRZn;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=L+RpaKAp
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792495432; x=1824031432;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=X+LoqRZnseHT9s4qS/iLv/bf0oTIt0+ZZdlkhVQ6HPeAepjBx6nUF2FO
   9IDa/WN9a+eFMgtkOHHBQUEzXBstrMNqhVEjfcXT80Z97JccHeQwlWeHm
   4FDtP9zHked4RGxVZOMXQ78iZOSlNVbfamUmzYPrsh262VLazsnRuvuaa
   el+KBFAPaR7BubczYq1avY5M7SdyL2kxYkkm3gktyy78KS//tB7V7sN47
   SRqLzxMNfPUCb95NHqBhF4pqu9CcHl8RaShF4uDQ81Zv8rm1QY+6c3f+Y
   V9sS3WWoktss6B/vO1ED+KvCT5dfVROYHeBQUtiDc9Hs3wagk2gDdJWax
   g==;
X-CSE-ConnectionGUID: SU9ZwMcZSnmn+4Idfxj0pg==
X-CSE-MsgGUID: G6nUOWwvQu2NCBLNAVLGGg==
X-IronPort-AV: E=Sophos;i="6.27,168,1786982400"; 
   d="scan'208";a="154314308"
Received: from mail-northcentralusazon11013069.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.69])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2026 19:23:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fVE0Q4I12dox8Ydb8lb33Y0A/gVzUSc3x0yD8WXvCBeIUYWRFycKtkR+54NVfCElqPNtTFdaIyVLcxuIAS33R+DF29JYuGbV6kB8HREcZFaGsJJGrZJsZZnzcA8rbcSeWGQ3z6oTNtRFipgl68veRBQgYKERwFYJrrO8UOOPIbkZevUIOXNpxpY5ItqwxmudTvAtyImJSOrndNSUmb4zojaiD7/aZzzrHE6ARocfqZc907OquFfJ+9jTvw4qd0V0qwHxSRozvtMvCGt7FpvB6IpAJwHCKsY5wjkoooNK4+5MxDY3Mez05ZzsrEZrAJB5VW6fINkry9rGKBp1iCzUkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=V9mEMGEad3XZTW4janujOvq6q4qe3EyciICLqLPisE/SaO9idyv3mhtlIvvVHCSz4sVpht+IDOgY7aD620e7UaFnuiNshvBxcK1jlPR2hFGFmEwWHbpoSz0PQFyXCeINQK723n1ioMLLUI4JdBoFKOK1+I7jwT43eOwO6HibKB5/0Kwmq93icyVIYOF03jQhajBAkK98PGkxYE7jGfbPjMNqaoGPrNSwNkoF9i0ohsIIbHHviw+2TWiC1v2YRrgXODvq53E8af+4Ib94+px7o2TUUXAkoBJ3N84HJnKu8e9FDB4Bg4Pn6RjyA7BCzEh44hk5KmK3NWyjVcpGurrtiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=L+RpaKApsRPKGCS2Dji7pVtQ71klUM08b5VmzrasFwFpL1LgbZAmr3H40EedqIaRoJWgbvcyQUP0Y/2EFFVc9luTnm80iUS6rHr8rQJx+S1X2bH+lFlLsEPd/l7OmSZqHFUVwScsEdrDg6t4eQ2hk7nFCEJO/N52F/3LoGG4g5s=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS1PR04MB9080.namprd04.prod.outlook.com (2603:10b6:8:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 11:23:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 11:23:48 +0000
Message-ID: <8e053040-346a-4dbc-a40a-0d0e67c9290a@wdc.com>
Date: Tue, 20 Oct 2026 13:23:44 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] btrfs: introduce extra limits on
 btrfs_chunk::stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <371fea59c3e0fbf0b2a21ce228eca8ed24c98e80.1792391732.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <371fea59c3e0fbf0b2a21ce228eca8ed24c98e80.1792391732.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0217.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::19) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS1PR04MB9080:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfea4a5-12c9-4bf4-adb7-08df2e9c9c3b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|366016|376014|1800799024|10070799003|18002099003|22082099003|11063799006|4143699003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 640lIRxKXxEao+HSycNQskKC0jpak6meEh7DaH/S/1GuCADBuxm5AtqGK5H+PiFn1fGW9NYfCpu2suxkidmNTT8rYn6g56Ewth+/x1U+S6uqo/jjAepVoxub/tAJEQO5+nFZJ/DnnbBCheJmlp+Z8AgbQn0ZlPmOwYVzxTTdHg61RdVcCX7GkUTD7kwCZtNdCpoheDbNmom1VCdVU6wZpTTS+W9d40WdwFPBenlCTv0DSmdHrMBkhfXvb8r8tCsRLGXx71F9jG5c0T8raGWqfQ/FTE4VSuhQ94cGE2swf6FizJUsAtYxrAdCvP9M7SykBFydi+iCZ2fKUgNhCkyuJTUAq5tlG9bNAUK+Eer9M6S/9QRkiRHWDiqk6JU/ePDJvF9k7L9uP6/OMjUVd0pzKOCvA6LlKBXGJWDLiX0sOSz9KyUB3KsX5UCnabzDjR7UZkIkU95GV3q2t8yZm7u4qrrwVQaL9ClfgEzKT/Pk59FM4Lcx1qgYW8UuqQJIvswNG1pvbL8Om3JwfpAeEaa8ZyswXfI85SEnaR+uRuRJrvdRwpJnfxyo55h/O/l91wqqnfX1ylIkQtW+K7Dh78dgAldCkyomEnyLFAzxNK4iVWwbTf1bNlX4HLbTA0tonHVwm7XuHTeAmnzXojeXNOduFYnStoxhbVGZenLTx5jBJNw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(376014)(1800799024)(10070799003)(18002099003)(22082099003)(11063799006)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NzhaWWVsczY3eFB5em1pM2prc3VYYzJnSFI2cHRUVmV5L253MDl5QWUyWWVq?=
 =?utf-8?B?NzVES3Z1K1Z1WjFhaExuUDROU3dJVE5hbDlONjUvNmVHT1A1UCt4UWV0eFZi?=
 =?utf-8?B?VmJ5S0Zzc2FpakVVQ25OSWJ4MkNvc0dOZCt5VVhLVU9obUdkenRPVDBVQnd0?=
 =?utf-8?B?MWp6aGFPTjk5aTVhME5SNkNadE95cWFDNTF2NFdUalBsN2o0dkRuMVFYRE53?=
 =?utf-8?B?VHRKWElWUFBTUjdHaTl5eHV5Yyt4eUw4WFBRWS9vYTAzSW1wcTNyazdTMW01?=
 =?utf-8?B?UE9KaS9ZM2J0d3BOaHVyb0VkUklKaEhEOXVVVmdxSEN3NXI4MURpbFFCbkQ3?=
 =?utf-8?B?L0lwb0czUXpEVnZ1alNMcGUweVh6YkZYcktkVExzUlByV0hVZTlxdlZJS1VW?=
 =?utf-8?B?Mml2ZXpmc3kyRTM2UndicklWY21vcnB1TmhDZ3NiSWJuelV5dWJ1R0VGTnZ5?=
 =?utf-8?B?UnJzRkRjdUR5U1ZYZE9wT28xWExhdTcrT1RkdnR5cDlDNjRwakM5bG5uQmRR?=
 =?utf-8?B?L1hGNDhOaGh3dVFncmdtNTZHSnBiYUlyNEJUUHgvRVdsc0d2QysrYmZIOGZO?=
 =?utf-8?B?QUZ4bGlGYktjbG5jakt4cGZwZVNjTkdQQ3BFcnl0T3d1enVxQTlrMGxjWmlC?=
 =?utf-8?B?K1djZ2wvK1Y5bVR3NXFtWGF6STlqbUo4M0gwNzhocG10WSs0VXc4ZVlNOU1i?=
 =?utf-8?B?eUFRdk1FN3RITHM0ZTVjbUd0aVhLMmtKNFBYeDEyVmx4WitRYU5KNlB0OXpN?=
 =?utf-8?B?WjFQSUJySjBzS2kzT0NjQyt0SnNpcy9FVTR0d29hY2kvb1pTdTEzM2h2N3Q4?=
 =?utf-8?B?eDJGK1NrVmJ0VUN6ZUVNVDFLcTNEa3UrZ21rdDYrdGtZTVE5MUNxaU1XR3lu?=
 =?utf-8?B?VXlaMU5oTy83N21RTjYxSFhSRityR0FvWGlUWVhVaU5tZGJxcWg0N2pabDUz?=
 =?utf-8?B?V1JrSXlSUXNuVVVJK1pmSW0rVUgyWjdwQ1Y0TDhINk1HdEpTOFFXdUh4ZXFh?=
 =?utf-8?B?ME92Q1o0YTdXQjFMY2hwL0kxTmlENWhkVzJrZVR6RHB6S1BZOUgxWk0xZW00?=
 =?utf-8?B?bEVwczdrdFd2UXA1N1Z6cW1yOE1LWTYybXRiNWVySzVaamlsSlc4RnZaU0ha?=
 =?utf-8?B?S2tNbmVZUHMwNkptVGU0V3UzbW1xU1NEV1VMVWU5M0tQc0ZrMFBVcVFuSElI?=
 =?utf-8?B?bUJZSzlORGpzZStOdXdFbWVBN0htOENlNjZTMkx2YUlvRjMxS0pYTUdVOXU4?=
 =?utf-8?B?SUF1aTQvYkxtK0V0WXF5SHp5MWU2Q2Z2cGhIT2QyUThFK05LdGRablNrRUpD?=
 =?utf-8?B?VHg4WC9JaGNHNkd2dE53NmkzdVpmZlIySEZUb0dOOVdTM1hpeDZTdnIvZWZx?=
 =?utf-8?B?aEV2ZnJMRFlmY242QnNEbGVTbjJYUEU2Rm5Uc0ltSTh0R1M2RzE2SS9MaVpQ?=
 =?utf-8?B?eXVWdHZOeFYzNXNhK3QydHhFWG9CTEcvZERheHRFZVV0aVZWb0c1ekZ1N0ZH?=
 =?utf-8?B?OEJCWHJtZW5GNzhyVGdIaHVocEpNVnJlU1hUZ2JaU29uUTQrQm9mb2x1S2tB?=
 =?utf-8?B?K3VOS1JucFFBTUJHWUVjWndkbllvTHhWbDNQeWJHNDg0UEpOQ2JqSTZiOGVC?=
 =?utf-8?B?Uit4VTU4SEFzelpYbUJSbldyckpCdzNoLzVPOWRndzNMaTRtZ0Qyb2Rwb2p6?=
 =?utf-8?B?NUNtTU1IZndGT3dVcHN3RTE0eVJGaktKaUE2aFR5OCtOaStFeTdaakl6aHVT?=
 =?utf-8?B?aDZwQTFWZmIyZmZKRmVyTnMrVjh5Qk9QRnpycDFxYU40RGp5cDYzNy9qRFBt?=
 =?utf-8?B?Yjh0YUg2QktEVkpQYmZYSHJEZDB1dGVpaU16SzhyRmtZdmNxTE9mdzJDWGRk?=
 =?utf-8?B?WmZpYlI1WFFYK0dkcW1ZZ3pFMk1hZi9IQmpQdHZRUFhRUTJSaEZhUDk1T3VN?=
 =?utf-8?B?TGowTXVNTkZyMEpMbmJkWFBGcERjNW1jclRMUmpQNlhKQ3Y0VWZxZzNXaGRm?=
 =?utf-8?B?UU5iRktUY2NKSk1lb1pHQ1N1V09DYldxMHFTd2ZIT0pEdEEyT0FLL1BvVXlV?=
 =?utf-8?B?ZC9La3NPRnRZU3dvb3Q3aFlVd0x3M2xEUThFNys0NjNiWUFYOHNLNWR2R3c0?=
 =?utf-8?B?MmRxL29JOUxtaTA1V2J3L0dmdFVieWcwSStpSU1tckFtZm9OQ2dYUVE2dE5o?=
 =?utf-8?B?WWZKSTFnOFBUMGtTc1RGYUFody9iaDdJNU0rNGlvUmVXSE8ybCtBUk9oNUNh?=
 =?utf-8?B?aXBlUFBUS013LzlMcUdQcXRteWZIR1N2VVRnaGs2Q0NWVTNTTENOeDlxN05t?=
 =?utf-8?B?RFIxbUNHSkx3bGRtUHlUR0k4V2JjSXorTWh4ZFF5WkgwT0M5cG0welV4V2Zw?=
 =?utf-8?Q?qEIIp5SSVFyGWApO0OTUrema7YO5NcYYB1x/9emvXg0d8?=
X-MS-Exchange-AntiSpam-MessageData-1: Jkkphfzd96ubdxJ9Tv2mqoxrHKGzPyFWIus=
X-Exchange-RoutingPolicyChecked:
	IqcsB29RbcdJZMaNM1b1DjbokYwQXyhF8V5AMFH5H/jx2WFK2CdPAWcYupWI/iXJXqDueyR7e0w7wWFNTouqaPwWDVJ2qFMFH5DVJMz3p1JhGqrQ0qoQ5P7AVL0wTrE4irCuZ1C0H5kqEI83GxJbXBJOgP3/c0U759mw46Z4dJWELkPP80AOBObQ+W/rT/e9RsdzVUfL7krQilpg06hLccxoI8AaCX3edSNqS9n3gzNNkVGkLaeMQTiedaq7GlRsm2NCcnl/2BQ5X6oNi5IKaYa0ACMDmysbGEQFeEP3ftYTUL9bWnSL4zgYA5w7xI09cMbNzm4gQp1xQ/yCJ8sCpQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LCI6IfYRoiLXy3nH6udzpRwHCvQFXUY0q1DhaiQG0Jyir148y5YjBwpVllDCHQW0B5POhdkSvnTsf+vYYmwF95/nDWi+HS4DGjNlfBlEuOti7CtoHvIey1GgaIPxGpZps5rkJ9t6QO24QgaHZH63z1HIsQdWSt77viCCjF5P6QdFrAcdkZoa+uALUsE850e5E6h8ByUtVwoTm4DwpOikuvdCVE6JCuTrXJbQykl3lNmOlmdHbaJYE6jNH7c/pt8DUdzAHLZJaScEgbF01kwyxaWHt7qHjNZKnr1wDRP9heAp/mGGeExXcwb+AWVGGcMbyfHT5hFCyYf34NR4ziPHF4ZGhRwZ4KrAUlpV10Y3lfhFvhA3a2fYo5l6QzyEVH3h0gkuXK+E6mqq6YqQyLaByn3RontDbFf3IY4OcEGUl3hldHu8mlJHkc46a3LZhMk09tOzRDQW+692DgbxSwz3e3XxqNuvllUWu1IPodZJVGh+XopjzYvEt20145liwKZwMhg+rXHjcJ4rU6j5Nphplqc7zPnFAAsei4mCWg6gxHaH8nvx/kFTAjPAUZuaEUBVnom9OnjPq4+z22SVp/lBTVtbpkcXnxqkToNhRxxjQzr1y7XybrsiW7qxPbFwX1+1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfea4a5-12c9-4bf4-adb7-08df2e9c9c3b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 11:23:48.3300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: voVlbcTOEADmVRDm1pz1NqniBsZ5VU2tkZS3gbjKn6G1A4NwEvGom5Dlt38kUHQDUVs77Y3HcuQLqeBPKj+ICWFsiV13oTP+1AZUCyKwsNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9080

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
