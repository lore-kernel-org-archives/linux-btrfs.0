Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793214361;
	b=rEmnACQpI/rs4VdcVULDBvkVgoEGATB6hNCVSWJwS9zInheHA2Drn7zGYt2nY+qi1wW/
	 TLm8q9FVeuEmnPdZKYBoVtAGc0b4dF/MY6o0qxt32rfJtnoRcf43YTMOffwJgMSr8xjht
	 fjofvReL0cNOmI1j/KZVPTAiz2EnJPvoeKLTqFBCzxxPmf6TwfL2PctNGXKZf9NxtFMvB
	 vpFb+n5u0hGBMGoKnr5ISFTKsBldIAg2ZajFf0oZdHK8uoBG8fWcWAqLJUu5YL26paDWE
	 tdYlIbFbEEKORkyn+hFuXjq3boKvnslu7G6qi9sjtP2+JJQUlPuSwdYP4im3d4p3OSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214361;
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
	bh=xAMFCSe7odcrFl+00qD38R+x6f8qheQoWmBxvLyBSc0=;
	b=WM1wRg03RLKtaxJgkbrI01WudcufNlqzIPU4BwzNb4m/z1ScRexMJssb/AVJXa2g+Uut
	 td9s9wabQtSogzz0dbj0lam0NFs9FSSD1x7/wHuNSYmKyW49o1q2f5Rb+yRM836aTcM5o
	 MAaAmZS45p8a0El9o/bnfBL2q0ADef+iHPVTXJoW2tMjPAL6xHD7UO1ztKL7FJ0kFNyzd
	 P/4jCAA3ViH1zPeNKSAxOuGCzpSuGZeDMD7iMCTsWrzbgM9Av9Ns3dcW8PMuCUpqc+vhA
	 wzMUdZtAxAxZ0FkTKexe0CybQqj7PRrMTYH1vyaRyl4qH0vL2mP0tPWlDpK8c95+tRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iFyD4oQf;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Fag5gbW2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2973160A262F;
	Wed, 28 Oct 2026 19:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2973160A262F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iFyD4oQf;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Fag5gbW2
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793214361; x=1824750361;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xAMFCSe7odcrFl+00qD38R+x6f8qheQoWmBxvLyBSc0=;
  b=iFyD4oQfjj4Vx1zK7pppIq4+sILRnMO4V+vidwVubYHqQL6QQ4CpxZi0
   Ykyv1a8KgRv8XQol/9Xoknn/bS+xcGN24foEmfPjkYIdx5nEB6R9dYv1K
   pb/gwHtDitJOcZmuUsVnW4rqFNQswd2n6xkN3nhKeXmbtmbT9IYMgTa0W
   lt9I0zLnc/DzZD1W452iW41Yd5OpRqUE70M2LNLFETlc8xjiLZDn1iVHi
   4SBVdJiTziAoHOCU9u/mwCPMhoJrWYmPS0Vk+4ZyFB9X+viVHo0t9xEoB
   5Jd3aH9AdkI99t5XHmJFuebs7vmO3VyPoWw45OSaMTfD/a33RLw/WUFap
   g==;
X-CSE-ConnectionGUID: 6omaMvvXQLaLYOjYpO7igQ==
X-CSE-MsgGUID: JfcGg/TNTLKUHDrtv+fvHw==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="157625180"
Received: from mail-eastus2azon11011016.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 03:06:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPmvIJKKM/xqaBzEAyIVH0YBbsh72EI/3dOVmAde0rPvfj0KH0SuGH2ZfvpGVcO+ysCRZkPAXcRqEIKT4v+zM96Z61RiUhZ/rCg0sshDq9MpBe9Kjfdi3ybn82q3xVDFcVWcEXRvbHwgBB4HURUzcyV7XGrdp70X7GJlzCG/PfM88zqlC5ZfbOe0l3EgybsaeXB5ck23wGY3mZRUlHj2NmUS1PW9xgWnoIpfm8SysNdOv7k1wa68o9xwcue28Hj6Lgh7oAAY+LA5j8h36e4M1y4oM38Krpyu9zZuCdpPdETvGkarfp6CyAqf5ORg5R5wsaxrNnSQtMmu1xbxDVD91Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAMFCSe7odcrFl+00qD38R+x6f8qheQoWmBxvLyBSc0=;
 b=ck/clgXTzNi1gntpTgJfEOpq9zRyqglviq5e4mepYMJGn/h9asZJKuuz6essxlZnFs+pARC0DKGZCGOfQnrNkAkNrcWbQPHMnaHyGnq5hzy8kSHGw8PhjQHxvRn59crPvOtChk+W5zq1IqrFmSrylmfDzrCXjnP0A9MUKtO/1fK3cSAMWupwwnOKhoaUAi94zgabDSVKR6WoNytJfOwtUdDdDVcmnjK9CbmhHqcnAQkxhpTtuxV7IKP6JLkAeK2Sx1HlUI8IBt/1NhIV3ehVSmO306GAHKer/OR74szujsysBDrAmwsTfDTvcva+y77kWTa9igwNRth9lfLvAugybg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAMFCSe7odcrFl+00qD38R+x6f8qheQoWmBxvLyBSc0=;
 b=Fag5gbW23mOBhADKKiG8uU98PTXGczUx9MkyE5TgXHOaVEoOSiTkJ6fYbz0NrAKKInSZXLmluVmvyJPtm2wdFKiozrH8nKlxnjRT5j5S2D7rVv3he5IpU8aXDWZJeWWYNSBd4fQOYbuz9FxBvnBjmDhYEqCFSTEH5+jwhZ0Q7ko=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by IA3PPF0185DB2FC.namprd04.prod.outlook.com (2603:10b6:20f:fc04::84) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 19:05:55 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 19:05:55 +0000
Message-ID: <4adaa928-a41d-4b36-8080-47f7da637560@wdc.com>
Date: Wed, 28 Oct 2026 20:05:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: fix double free of bitmaps on clone failure
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20261028095053.20459-2-fourier.thomas@gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261028095053.20459-2-fourier.thomas@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::25) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|IA3PPF0185DB2FC:EE_
X-MS-Office365-Filtering-Correlation-Id: dcad425f-a4c5-45c1-f48a-08df35267e2e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10070799003|19092799006|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IjGWBjPCf2SQJUZheCXJv1+h5QhZGOzFHBu5imdL5+YbfosOMZsTb8pXenVpCNOaX3pDPvVE15z4ayk0chH6SL/I5pGzTMfkCaISjsx8e5PA8QysHkXaVlsfXB+Q+W8j2JUSq0vddfpQTxAF+W2oGaKvzHCEP93Bio/3/BgaxdAVlw4duPQ8VdByAMx13hg0b4fJEpxUdC+kIvlkzEqOavPEtuJk5jYejTIclOmV1iXdtK44vMVjLh7O9ULhZMMkubLsuCP3vZHgkhYeydz1GzbDCFE2XMGCs2mdWx2Uh84BtcEO+SMF/gOXv4D8PWSW2Z+XC5xZMs/LU5VVjGFeXh1Kj20EVAUUGM0sE1OtaxojfoT2ZDqW3Yco9+tUItRQsx9eNgXqiNTJ8Vy1o1VDwT0Joci/yLlYkBUrBIt2NMJ1NF2xhaC7V5CVSYUjffbsuxMKXMC7Ui+ZYNhET4xicGSe39EOozjKCfVgiJw915O9QADJOfv0WH6MpaqRIqkYsPlXHYDfIr0EvnJUIWLAUR1uhLNgf9QQTmN432lmv40kLgG2tIOFTBAuLH1ZEcGwrOChqaCQE5aAxHyJZaLqq+ZdDYlP4qdlwG96hn+42fzkK2ZhemdAvtJw0NOKQoKa8VMdW/4aspsVLwgNAS0O8tkntWxmdd3wfkMjMyuBnzM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10070799003)(19092799006)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1VLR1dlSHJ3RmtvZUJ1b3BkK2R5UGphbGFsbFJmSTdUYk5peTZFZFEzZGZo?=
 =?utf-8?B?UzM1dDdUL29wM2YzbGlLbGRiZ3NZcXR3dy9vVkd6a0c1UUNhZ2ZWc0p1Z0w0?=
 =?utf-8?B?Mk44UkdNSnovSVB5NjdOcEJITDNUWGk5Q05sdTZEV2daVXJ0RGcwRXRyOG5q?=
 =?utf-8?B?a2E1N0orREdKT1dNNWlUdDUxYTZUVHZDOVFCWC8vbUp1dk5jeGdaZFNGeEJ5?=
 =?utf-8?B?cWdHcFl1ZUF5c2FoekZrL2U4ZVhKQy9vN2JnYkprUDlrSWthWEJWUjFSMHRq?=
 =?utf-8?B?TWZLUWFBNndyblVYcE5mZG95cDdJdndhblRqaStnekJ3Myt0Tm1yaVBBbkdL?=
 =?utf-8?B?MmxFWnlBWkpMcGZNVGwxNnhFVk9ranpWQVU4MUlPdHRLSlJMVm9LS0o1b01t?=
 =?utf-8?B?UFkvWmxrK0t1UlF3RVJyeGlUQ3lLdzZRdStNcXRUdEJ3ZnlTMndIdys4TGsx?=
 =?utf-8?B?SGhBU0JMaGVEa1AvdjZmSndRRXozblZFUEVEKzRBTDRHKzU5T2drZ3dpM2VH?=
 =?utf-8?B?cTg5QTVsUXBtVS9NdmJpVTNLNHRvQWpKS2IvTU85eXV2UjdLY2tONzUvNFpp?=
 =?utf-8?B?Ly9mcWxTMjUzOExjdEs2bm93TWE3WDlqRHR0RGJyVEtSWmd6ZU1POTAwQTVh?=
 =?utf-8?B?WXlDSjFZaXg1Y3FucmMxY0V1Y2xIcWlzM1dqelI1U2x3N2ppbllpcU9vZDFN?=
 =?utf-8?B?K3p0d3lyUEluL25IUjNDZGY5OVV1eHpCdlBOYnBGcUpKMHhnaFo5enBudVF2?=
 =?utf-8?B?NHpHUndEOC90RkJ0Tzh3VXdlUm1OQ2hCY3VOTkRGancwYTNveVQyemczQ0hX?=
 =?utf-8?B?R0wxbmQxbUtKaHYxY3ZZZEowMU5hRGlNTW9uYUwzQzVIaUE3TDFPakduSTk1?=
 =?utf-8?B?dmpiVlFIeTAwTlJuWmdBSUdRb3Z0RCtZZ2JzWUE0VGZYTXE5MFV4dEZCZjdL?=
 =?utf-8?B?OExQSGJDNHptNTJPZ1dOZlBMWVp2UzFabUFWam9xY3ExTnF1Q2xERFU0dnBv?=
 =?utf-8?B?UXYzWi9jNVVVa3NMVTJ5WFpWUFd1ZDl4SXowNU91bmI1VGtxUEpaYndmM1c1?=
 =?utf-8?B?QUh5REV5WmE3VHcrL3dwaVBzdEwvS2s4dXBOR3pBUDhHSDlmRWVDUk55alFP?=
 =?utf-8?B?WWRubTdyb1BJTElIOVFKSmJsZnM1aHZSTmxDeDNkTFIrNUJlSGJyeTFQUDcv?=
 =?utf-8?B?emZYUiswYXZHR2FMaUl4OW43NkJkMTQ5dnFwVzJBL25pTWxuejdEdGxRTTdr?=
 =?utf-8?B?WE9yeDF5VVpNOXcwQ3RlQzBqTFRPZXV0VndUWnpNcVRCcVN0Yytwclp1ZDU0?=
 =?utf-8?B?dzlkV3JmMDJrVmVPamNPV1A1VnQrS1V4TGVnQVIyM2JHS3BOWlFmdkFKWlhh?=
 =?utf-8?B?dFlzL3lMV1VwaHJ3WWxjbGR1dnBVd3ByanpKZ1QralV2MmZnV1A3NFh1YnNC?=
 =?utf-8?B?Z1BYU0pDVXFWd1Q2Uk1qU0VaMHdUY2IzUTZPeU5SK3h1Ulh1U1hKQTY2NGxQ?=
 =?utf-8?B?NHM1cGpXSW9KQno3R3lQemVqdElIMlI2Z2YwZG52QkNUVkVDVXFLL0VsckIw?=
 =?utf-8?B?YkNkc0JjNUhqc2lDdjAvdFFNQVNqZmo2OVdmVXI3SGl2KzhjalJYbTlsd1Jq?=
 =?utf-8?B?UXZkRG41cWZwOEZaaWdCUlVNaWpyK0R2cTJ5V1lSWXEvRHlqNlZRc3dlVDk2?=
 =?utf-8?B?S09IM096Y05UTExiT05yVHBwRkVlamJudlJkd2Zhb3l2WGJyMXRseEozVGgr?=
 =?utf-8?B?U3FhaG1TUHNRKzlqeGFCQmMrZ0NNK01aeEhKRmhNdkFaZ2lnT3RTRlJ0ZjFV?=
 =?utf-8?B?YWdGUjlhQ1huTmcxV2Z3T2FKTE4yTU5JbUdrM2MzbDRoam9YRWQrMWkyWDNE?=
 =?utf-8?B?aUxIRVBua2VsT0VzcW9xMTNhRnQvejVXeUZhWm1uZnYvN2toNEpWaThBc3JK?=
 =?utf-8?B?M0RhSCtzQlVvRVRTbW9iMVpIdzllek02NTd2aWE1QXRUQXhKd0FLKzNWZmNn?=
 =?utf-8?B?QlBkUXZLRnExUHZvLzFNUnpaeE5TWmIwaG13MlJBZk1QVXExWVBsSmtoeEZt?=
 =?utf-8?B?UCtGdzE0Z0NKVGFQVGUxV3BoZnZZWWhhQjYzK0NhMmQwZXY1L3VBL1VjZWJC?=
 =?utf-8?B?QVVMSEtmVitndFJMc29IREp3N3U2WGVab2wvWWZFWFE3bUZ1Q2JPNUhBcGlV?=
 =?utf-8?B?M0dZck8rVHJMNmI2VFN6RnZFcWJ0QWFMRWV5UnZPaGw5SSs3VlB4RzZrS3FF?=
 =?utf-8?B?V2NlQmRSSmFoeUYydUUyWXYvdXo0ZHQ5ajJwRnpxTjNhWFVIVmRGTCs1ajVL?=
 =?utf-8?B?YUpZbU0wcm9adWdRVEdqaE5DbTd3ZEZhd3N3dm1tM1FVK3B4UG9vRGt1VW5v?=
 =?utf-8?Q?rqru1Izwq9WLsVGdjb2CSkWk9PT8QAp/rc5rT2LwUiogn?=
X-MS-Exchange-AntiSpam-MessageData-1: nZVwRXL7R4zW55YHFZd2ZK6avaAATRO2I3s=
X-Exchange-RoutingPolicyChecked:
	pyhm4xA5OntXaKH97hii6j2Di3NDl6HJlHZ8HlfzTgwNgQZU3Ji+IaBNpf55FpXRIE4ZoPnjQeiHlvPMZWnW4AM0GaBwj8jUvE2qBhTAIud6zLDy4tU9EAA72ehpEKYlb+qxbQWZtmWHcQGdqQc+pbJMZxyzqTifKXKa0ksz8YC5cIJzW6e6iVaZKePg0/xDUJxpaMi5ZPemHVqhttbRyWqC34WK8ypmd+syo43HMLEsyugrjjhXmwgTLpd+htocv1sZGR4+NDptJUlIzjbazUPT/WFroydtuYGYyGm5833jhoTVbJ3d30X7qa15VzHjINOyxTFBE3KnKK8UTUKEjw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oSBGICEQ7phyar+1N5Q/mefXKnonMQMcd0F6l4ohl+PNry3x/392T41D/Q7iR8u3Mraq8WgEpyAVF+/d3j4TA545oZSFbMh457CdiObyGhTGRlF7O0JDTtADR5yzFBxFb9EDqlk83oD7EyQkz7IymfJCnyR9qraiwUO7NoyKBlGEU3WHgiLkXkjkSs+6OfbXrKjrR0iXKuvwTm6lyXTy1J9oPLLT5OYPV1MVmEqZrr9jG3JNNHE6fg6fu9x03GcW4HECC0+Cz+kzHnpbMtV4bZvJsXfwjPp1GmZ6mixmHhcs7+sx413TXXbThDGczWDl197tjWzrVj3x1ElvDPQ8s1Vxb9VjSxz8mzYoycHMkVhPcev1s1xpHdiWXAZCRLyHx7uqmGCWmG1k1SEAq0ZmV7KSn7du9VWpU01bl0davm0n7hDv7N2UChhFBYqXnYlHsoWr+EP9Q6SofiyXlF26l8BBbwG4PAbYQv110a1jBlDmIymnKGKNfGPvTHQGg0knLM5FnIsQQged07jaj1my/9Dsam/ZjsZA1+AY5vR1WAzV2VN64QHh+MqarpXGEtfXQ7JgBIuN6GhQNYhVQQVjKFOWKwVdGaJtdbR27KZD08DCKNBb7PTjcOjHqqlpAH01
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcad425f-a4c5-45c1-f48a-08df35267e2e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 19:05:55.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaaz9IKxjs8Ty3HxywSwgzSgz0SDNAsuilmELoH8+iQQJruECr0/7BzYlyUN1McDvZ+FtPds0ubW8vnyT9wVV1OW1+NDH0rIL2EvST/IVyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PPF0185DB2FC

Applied to for-next,

Thanks

