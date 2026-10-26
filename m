Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793029007;
	b=j1wonHQaAYTUYfKJUklk69vLyjTln1AyGa5x9GPPK/FURp8pMV6HNHjS/c9Nhxx9do1F
	 woL8Y3T27AbLx20Uj4Xk36V9rDUfGSiydj6nTMNkytzYJkxtJqR5akJmNAuT8lP5sIBiv
	 /jJWw9DFJKLgt0/WsW4zKdbpPRjZ/gRw0Tq6DJc4P/joV0EXxp4h5qPrSPBbmecskSoCP
	 vLDD8n610J+ygj1e96x6T7IAfsIxsyCi7ZRbUXPuhdnzJipE/hyTJUOq12LSofiCkqY12
	 ONB2gy/TcNIyiUI015YSDWZv06nY9cAnmIuonwMdKkVA1lCZiiLWrNcsoLEVIF/E0gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793029007;
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
	bh=w4M6FYhl6qwbPTnAJ3reUELJVeAMeei7INIuLxgItQM=;
	b=sjJZQKNEb3gZ8hpMKX98hHB+SHPj15X/KpT1OZnUo887jbfWt5t03QHZT9ronbJ3GG2c
	 CAc2OQPn1Ai4aUVTn3yVq62YWZboShRA2kG2eWbUIWpEPrdHMzm5YLo74DpBsUI/RUYI9
	 8jy0NYdESbCqbVJjSqudJN7eVW8Ho0GIDJu6gd/qSagWen3WHwk4N4m6lkYGBCQTfUyMi
	 OnygVEbccN3Wpq+kdkbeVuxHrIU3eq4ofA3bvae1D1T17EHa2XDtKqn1MfJ5OJ4+d5+Ca
	 GtviEChRd/fyksGMPnIbTI5Zjh4rNVAOhoSSdPEOsc1QSS8IjPlOIY7ln1IykT8JH5w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Ea97K4jx;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=q3AN8KbZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915F8606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 15:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 915F8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Ea97K4jx;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=q3AN8KbZ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793029006; x=1824565006;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=BH1WZabrnGcnrr3mMFtfNeABl0IXNj5pIrkxT0aFggk=;
  b=Ea97K4jxaFn6NeU6aAxdex3+ZJgTMyvJgpglmjYIveLvtf77NNrHusrq
   Yd8FMvhE/tn6bYb4IHPv6z96zsIlcYGDZmociKnf45qWlMEUU+XNw2IFX
   cu+rXOL6vY5Yic0vUyFENXinOmy7aKniq7Gu2KfnlZcWTvZtTQ3sEDk58
   98t07RxkeMni6OmrqXLP+LwegWXK17EbQ5bYENdyN0i7H7Di2EZs3i9nx
   VZkApUp8xESaRUtrOPSEjoWI4YjYDNwbo/7b/ASFua+b2Tr96QT7lcuVS
   XOWdiI3/6LCAmv8LgSYSDsyTUpyetMmUqksWTlf/hPwYvJETJw1F/DA0b
   A==;
X-CSE-ConnectionGUID: 7pr6yTwnSj27z/84RE3pdQ==
X-CSE-MsgGUID: m1Avx4vvQm6ZTK/elOYZTg==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158066425"
Received: from mail-southcentralusazon11012008.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2026 23:36:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=daKs6kE/Ige4ND8gOUVxQv8XJCERW2iDM1IbQA67SZ8kqeZv8xeYrj74NLr9Kzjk1c2fVtKvgVPfl8XWGA8Ai+nlu47sNjojx3Jhg08a70C7QMGmJdgDSs9ZVyc0RqbDhTmusPHNG6El7r92+424SHjwKd2QOVtInT31N7T2rN5VGuOlMpS4BI7cChlJ2ReWwYlxTQ+vDaSp7VHlfaOdI1BRM/oSCORqW3s25fzydgXUwGQAfZ1ohmQWFxBpiH+NFV7WOCUAgv2rxMCf23PyUgPmzONye21T/LPAHF7WTQjszKLnIf5FA0oPxsLf4NiJAttKot5kBR9B9aIaQfJS5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4M6FYhl6qwbPTnAJ3reUELJVeAMeei7INIuLxgItQM=;
 b=iNNmkU90rVh9NdoTfqgX8bnEEVGRLq68q4OBwvujMt8Bsfh7xGHIqUnPRVLYaUkCnBhgQk3t7pdWr2nH+XR6CSfHzH46Givd3tYaisj1wWKT0jP5OY2G2/GpnFdKTAYV3D9hrTI+atKMiPnE3fUpHHvzFjKsualj9kJef93VscrCeWezzbEWPZ2Cx+SJ3vutxlkiXViKwS3xd7Z9b3VoKI4zpfnQDSRgU/gC3lGWY61m1IEIR7T3VRhnbezRFNjd8D98IPNB7e/Glu6nek0E5xFiHVJcvtueolnlZwtznBDhAuS/KDP8opTmlL3omDacohmoud3dsLmYe26D8WbCfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4M6FYhl6qwbPTnAJ3reUELJVeAMeei7INIuLxgItQM=;
 b=q3AN8KbZ2tcchRzmpUFfs8dvgQ62iGdyNTu2RmoW4Vci+lwMdGC4zcoDDToqw1oXdPSWx4MMVhklNTBInfnE7e/J4R6+8qqe6rLJ8LrJvwuJ79kXXwbHF2AA97/4zSOCLJMSkeI8Wrp5ff0kV2181d++bJSiXjzzlP/0JqK6+AQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CY5PR04MB994355.namprd04.prod.outlook.com (2603:10b6:930:123::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 15:36:38 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 15:36:38 +0000
Message-ID: <9aaab5c2-b23b-4a3a-8cf8-4b8a4b530372@wdc.com>
Date: Mon, 26 Oct 2026 16:36:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: add stripe_len < PAGE_SIZE support for
 alloc_rbio_*_pages()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792661955.git.wqu@suse.com>
 <537e80067fc55362a47b06404295b7777c0c27b6.1792661955.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <537e80067fc55362a47b06404295b7777c0c27b6.1792661955.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CY5PR04MB994355:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c94d304-b3e4-48db-c4ef-08df3376ecea
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|1800799024|10070799003|376014|261022105027099003|10067099003|56012099006|261026121527099003|22082099003|18002099003|11063799006|4143699003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
 BTw97epzgroGa1KEOgX07jZnfBQwIV8rrWcb1n5F/OTybYYiQBk4GLCQuRAdbuIDHzIauWJRe1Hu0zZVnHx+kDQ2487i4if0OpGLYJ9AIQQcNbMFaKmjpp6snANj/lGQIexJWbgxWwzvCvSi7R/B8HNnKFP5aOtRVquDLJrK3M5lr6/hKJz6WsWsEZZHR/a4ruFdE75NNxnmzdEK2kwsN192IcoOx5eVA4okfHq3XzYNhqvH10w+gVeB+ssQ+Px2V528t6eoAK27w/6Fl6YEeJfCLLJizujnSpC5Zsu9z4bCCux+wz328TqHbUKWL4JkPuFDZHU5xcmPknxH7EDuN/j0myIxLpJCGvlHH+6g2doPCrLTXp1va9iuH8OV37PPibbz9SDkoQsan300siYxzFWThF2E72sQAwgY6pniJfyUWHIkdHkCig70llzBmS3nCHws9sJNrJ+8x6CAR/uDcpVY+pe/DDxwRn0SjUy2T0Lw6cpxcQc+0v8przdEUkjW9mzuWyEmE/gbqUFORmiUI6fhu+e/7NC6KkU5BKFubWjoUYz6Or1bHMs9yC/L9KwybU6510wVN6liw+cHx1A2QgPywsY78VY33rxqiX7r72ZmBxSr700CAn8Ye2WAnhQVk30cc65A44pgF/VU+CiKWRGKC3Tix+8OQAn8H2qY8DM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(1800799024)(10070799003)(376014)(261022105027099003)(10067099003)(56012099006)(261026121527099003)(22082099003)(18002099003)(11063799006)(4143699003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RFBUQVFxVmdneTBWTjRjMDRtUG4xdk1YQUcyMkxhUndKWWFzOXEzRWUza2ll?=
 =?utf-8?B?UFQydVM4WWxiUEN3Mk5veHVicHJJL1hsN2pYR0lzWnJHczl5YU42eFg1QzVz?=
 =?utf-8?B?a1M1dTR1NEs2RjBMM09XbThHUDV3aTB1ZlE4blYyVXdQRmF2R0FHQUtEeVMw?=
 =?utf-8?B?TkNvNlVIc1BtNWNFTHZuL05XT1FQZXI1M1FtQjRUOXMwMHIxbnArSk1LUVJn?=
 =?utf-8?B?VWRpRXNlcVhmbWNSZ2E1YjNvaFNPN3U4ZnZGbjJGc1ZiUE8wRS9FSEQ1MjRV?=
 =?utf-8?B?M1ZwZUJnYzJpRXkwMWptSVhKQVNEMlVhaEgxMCtsc3N1UHEzdW9VeDgyNTBu?=
 =?utf-8?B?SklJUGtmclk4UStBMlYrcHpxeFBZdk45TFNhL0c4dkdsd3RURXVlVG1wQzJ6?=
 =?utf-8?B?U3FsYXNFT2JFQ09HQ2Z1UWxkZVlIeHAzblZHNkY4dGJvbTZVUDVvWG9GWTZv?=
 =?utf-8?B?VEd4WWxwSXB1aDBCVnU4eFkwVjd2SlZKR29IczBjQnhvNG1ZQTNhWWNGSUNI?=
 =?utf-8?B?SW1iYUVITUlNL2U4NDVrNGFKTFFzK2VaWUlYQyt5OWthZnVkK3FQSnNIUFBI?=
 =?utf-8?B?d2J0N1J0UHdiREllb2I0NEVYRkUzU1hVQ2JIOUFqblRKcld4bkxDVlZVYjFk?=
 =?utf-8?B?MVJqcFoxQmRoRngwVVdjeFZNUXYxUUxjR09MSm96RHBrZ3dGVGtITiszQlJz?=
 =?utf-8?B?OTZPdW9TU3p3Smh2SGxPSTdhdjBQUkRsZStQZEhhcEJOcXpjRGs5Rldwb0M3?=
 =?utf-8?B?cTVUNm5DRHUzdjVVNm13NUc4OVZXSWlWTnR3SVg4U1huMEtWUWhQVXFxRFl1?=
 =?utf-8?B?UGw2SDd0c1grcjFsMGlrODZJRXJ6Qm94N0NVLzcrbEIvU1ZFWWpHcHZXMUZI?=
 =?utf-8?B?QVZyUVJGZzJQZkF0S1ladWZWRUNVMUFDTUw3ZkVsYU9TMWhjOXVDM0hDUG12?=
 =?utf-8?B?VzVZczl1aDUyclR0V1VFRVJGM0hvVXVscWlCdkdHNmlJK2cwT0lLeG53a2cv?=
 =?utf-8?B?RTNKL05ub2NxVysyOVdYRStJMmUzT3RPVE10NXdOTXVZOGV3WHpLOWxCYlBL?=
 =?utf-8?B?dWZoZmVjMEdjdUNaYno2Nzlyd2F5ZFp0Y0ZLcE5nUnlhWEJ0OEJ2ampiRyto?=
 =?utf-8?B?OFp4WUVVL3V2ZTlDOXVuckFINDhHcVQwdkZwWHBSdVoyVXJESk11RTZob2Rq?=
 =?utf-8?B?azF5TTJqUUtZZHN1MXBIbStYRjdwQWdmMDFaQ05CdXgwS25rbCtuK3Z6WmpS?=
 =?utf-8?B?dnZPcDZqVm9XSUdDMXF4OFgrbitTOER3NFdjczFtZXJkZDNqTFYvOFlqV3c1?=
 =?utf-8?B?VmhWNjZtc1FQcjNZTnRtSmVPNENYbUNDSFc0Z0txaHcrcXdSS0p2Qk45QUdU?=
 =?utf-8?B?enNNQmoyK3p5N2JKUm1oRTdWQnUvL24vcDhVRTZqdmwzNjZEQTNRQmVvNWF5?=
 =?utf-8?B?aEZCUVJoYUhTT0t1RCtmMkQ3b21FdEdsVzdubFA5SHAxTmp4Q3c2bTRuTlhL?=
 =?utf-8?B?cGMvNlJHcEJ2cmRrK0xBS3AybzVHMmJjRExKZE84dkxlZUdEMTdsRFQyTmF1?=
 =?utf-8?B?M1BXRHl6RGNXWkY0aUorVHo0cCtoY3FRRW5XRXVUV1M1elN0VmE4V1NRVWVW?=
 =?utf-8?B?aENiT2xsWmNsTGxvQ3FGSkJYVWZ2QUx1SVBDeUsyNEtBODkwbEpUcHlBT1RN?=
 =?utf-8?B?V3dQZjF1Q2JneVNISTEzSGQ1dXFPNWl5MGxCNGlaYy9Kd3RPeGNxdzV0WHZp?=
 =?utf-8?B?OWNjZnFBRVc1S0FkU0drZjRzaW9KQzJScFFBOUJMeXF2ZjBvcGVCWk5jZS9o?=
 =?utf-8?B?ek1FNldNSWt0blM3dlkvY0d5Zno1Qk1MeHh2aEJENFM3ZDlJdnJwdThsaGlJ?=
 =?utf-8?B?UEVwd2RCZVRnK1JiRFZ3MEZraDdTdWZkZW9HYmRGOExvNFo4NlNUTWtSWVpZ?=
 =?utf-8?B?VzVZNy9ybEU0NUJMV2wrMi81RkFJTUpWSjZJMHVqbVc4clg5TjZST0ZnOGJz?=
 =?utf-8?B?NzJ6NHRxUlVHZzNNbWZ6ZkFxMjcwak9RRjlEL1B0SlRTVG5pdnZqTWJ6SmFI?=
 =?utf-8?B?cm9TYklWUnhReHI5Z0xRMDlzNkI2Q2Foc0JWUW1oQ2NWTkZPMUdxVGN0eUlq?=
 =?utf-8?B?RUVxMW5id2hvcWxzb09penZTVlJvMHNqSDBPM3B0R1BLRjA2MURwbDJMMStP?=
 =?utf-8?B?QmhIdy81bXVNN0RtVXlsS2tIaGRiMkY3dEpwZmw5ZHZpbS9wcVRldzhrblBT?=
 =?utf-8?B?SU5MVVFHSlQxSGl0R2xld0FWYmN2aWhDZkJpbDZIdEc1Zkt4ZzhLaDJCcGpD?=
 =?utf-8?B?eGg3V0IwS3c4Nko4Y0RWVU1ETXIyWlUvYjhQT2N0Vm1iL1JjbFRadUlnYU5m?=
 =?utf-8?Q?rRFGuBsHYpJKx18KK81d/vjaYBdZXBYLW9Lfc73BBnZhV?=
X-MS-Exchange-AntiSpam-MessageData-1: tEikhQZfp+Qyiw==
X-Exchange-RoutingPolicyChecked:
	srX5W/7OarM+3d3iE9+yLTBF9JihfsbsK5rkVdzV4g8XhNwK4x2EANyiDdcZSwf5CbmNzgFoBBBk3/jvRKfO0IVrYmXcZ4hNALKxL+dz/T1GxkVH5v/jY7SS1s8ImE1GnjYlPZhtD9NfVIjk/zz6zQ7aOY/qXQBYotBSTA8QQNV2fdo0yJ0FmA1lHOWuLiS139ovdZIw1fYyEYxLDaLABjWRC0YYm+FNrGTkGJh/pRGf7nncRKMKOcSCOKD4J/JzZDsTJzBLI/SRwZH/2qgwgM/edJE29WWx4Bu+75Y0RzTnQ1FNZAkptJM326iFKM2pE9vXgUaUiCDmsCHrRV2Gsw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/jDPJFFdZ1noh4vmqtadyARwNFDKioAEXylY8BrEhzHHYT+OyXtBsOOgnEv9Oy2HIz2SiojnkaySPeszgLVwKMExGMUdeJGel1XFYIKlKh9Ici1AacnT9flW1Qt6i2iKgNFBsV+75WMkkcSzO/E9wUygHDTO0IyAfP3tYcnkTFpw/K/qkDW0m/WWv9a1WthsY1jpHARZQO6XHstoX0b4ACGuQ45zf6xh6ySKL93GCGM4Qmc4w7JZtzK5ihWxttfkQQx1VmMr2+Sv+Q03gf0rcr3Z6pyHfGSc6+J7/WddwrZhUtY9er31fgMn8Z2L20PiSH+48ll0EH53GIHiOHey8m3AAzMSueUsAwLhHz7SawLObhMnTiUZfGx+HCio0J3f1D8LunnofrGGFN8O9930gBXODUbjUcIwRN4Ocp/HyshMgZe+APJUx/k9d2fYe9YK+FZgJA1dyQm2F8UHrduTJCpRFAriZ0HGRnJNBLimLtfLGePVai6768feerIT+5hzjjn8O/KDE00GAj+uspxDrUk3VRKUfKEaAxU1ZmKYUTjLJcsvdhZqtagJmeAkftsn984D0C79M3BL5g/xaTY6ahb9GFl3dlwb50ZEL9qsDvCoN9Mys43uX1QX51hw8VG1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c94d304-b3e4-48db-c4ef-08df3376ecea
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 15:36:38.6268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGBZx/pai3P7SKTnYkhaeYB5gbS3GnH1541NP5GJ/Fhn6nr8X+SeMriKbv3VNbrLJCA3xD188EP+hLW8x5KwTaN3OAsEPuldD+xSsHn0hk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR04MB994355

On 10/22/26 11:39 AM, Qu Wenruo wrote:
> +	const unsigned int first_pq_page = round_down(rbio->nr_data *
> +					rbio->bioc->stripe_len, PAGE_SIZE) >>
> +					PAGE_SHIFT;

>   static int alloc_rbio_data_pages(struct btrfs_raid_bio *rbio)
>   {
> -	int data_pages;
> +	const unsigned int data_pages = round_up(rbio->nr_data *
> +			rbio->bioc->stripe_len, PAGE_SIZE) >> PAGE_SHIFT;

This is the same calculation twice, maybe extract into a 'unsigned int 
rbio_nr_data_pages(rbio)'?

