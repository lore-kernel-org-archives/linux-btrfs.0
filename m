Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795707579;
	b=ATbiFshQiHb45/+wa1zUHyC1b8kiFToiylm/jGHFuuXCY00QxQUlHSefh48V1kVJ/AKY
	 PWTELOUsMHY+gIKBKQRd0n7Rs3p4e9ApKiJTblUSYsG1dpxVU7LreGWjQ2fOsQnqTi2VN
	 ntpyxbbIGQSSGc0xr17u0Bx4TPLB0GYHTzInlzao7fs5Y+539FSJm2tZ7S0JEkqYK+1DG
	 MIeBRK8Q7rVHHHqLKr7vyLH6doB9xUHsL0JCsXgvf2zZ66Vb5uEN3f9ZuFDwO3+dH8zYY
	 0GTDQRwmeuN5IPbEZQxhRJoxI44gOeaDrwwts56xEQOgdf3yW9k4iEDbOYGsUfRR90Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795707579;
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
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	b=CwSMSVg9I5sMKE9Faziu7vXyLIeNMbbQBPWgm93kiRj/G6iVScBa8hsSP8TcVLc/sD2x
	 WLKquJ8P0scMzd8mpagSvkx4+5LCMMFw+xtCaWotG5A3SYBg4RMg2vqmVD0mTJg7ulTeF
	 V77aYdGhVIqGehOX6y2ECEzeXSUpiuhjAJhWM59ZUtL0+kGeVUr8PQGe4+PPS2S2b8tqG
	 bnHpOgROr5SDTZ7WOyayWNZHDp/GOS0T8XcsvsXtQ6zIbWnvJT3KQQGd8WZ39wLWOQLC+
	 BIVV5D3EkXyXBHP+Bd8xzFVY1FtIRy8p1Dv+KffsGA2YvCS2z1bDQV+J/2i67zFbaGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Yla1Cj3R;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=WpgHowLM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08624606A31C;
	Thu, 26 Nov 2026 15:39:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08624606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Yla1Cj3R;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=WpgHowLM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795707578; x=1827243578;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Yla1Cj3RgnEFQKJ6KHrIm1At4WGz09Hq/dH+X0Nk0NjMiNyBdlMMQyuV
   oxsVDUgApejH9nIe8gZDqSo0XV3N+GwkVAVVHffYMgaG0O50vdQgzx6Hp
   i0b3klYBXRSdZr6rAvFA23CyJSUolZa8kybW66UEX9FuiIjd31Fm74o/G
   V9e99+juoQDUAQFZk5WD62NFGXCsrYC1JYj1UFDGt8XLPwlBZXg7nDz4s
   5Y/LuCVwkJrUDTqKvVNdbhSbSmM6FlMlKllWk+rFTWta3t0MqqR0mQzca
   HvM4uw/iOt7Sbt0/682QyrPwLWD/jQqUscBUNsXzQIw0Czb78nmQZ1gBa
   g==;
X-CSE-ConnectionGUID: YDPTHtU+SnKTF9rULKlh6w==
X-CSE-MsgGUID: SjklePvaQqaR8lvHAS3jjQ==
X-IronPort-AV: E=Sophos;i="6.27,235,1786982400"; 
   d="scan'208";a="160220446"
Received: from mail-northcentralusazon11013062.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.62])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 23:39:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=je1y+sI3SFhLvRHZ3U3oLDBVPVOI6EPxaIbljP1r0vw+vme3b34A4gxOdmrCNnqOyWo3a1RL8l53rHbn+WQXv9mKmoGLFWtL3k+DWwkSoirU+NokAo0vSRX7jFvbt3CIVG76NcDtLsplQvqdD0hklJPtJ2zWV46+8Cj5CbhEzEpcSaBZpTPrP/S9V4ZNnC1qosr5HndEnLfbax0vrT2IoZvNHCQoZJzvCwgygGAarx4J+zmsyRMhltqQXhqT0/NDUAuS4YAgm6Lu1nsUu32B5P5z7YrApNIEUfI5pK79ulJnDO5L/iYmrFcmSkKp4A6RQIIwQ67ybGINm1dmMy9Ycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=I9dOALkWv33vi+9xqvlfao0di8yBlgl7rk2vqOcK4WJ/IcfRbLnJ3G7/PkCK6EVQo1vUqlmsHow/oNCS+qI7nXBNV2sRlzWNdm/1HFBqPsawPUpYI8iNGIzpriqRs0SPk8l2UDPaWaton2IvICvR9IbKDU+mxqiJ1RX/qvh5bK7C9JmjQ070LZG62An5fQ7hZYUcGRF9SIM06N6BPr51zI4imkC7zinZC90uPbfMckJgPvBgMosajtv9Fxh1PV3FREof4+omx2ACkKdrJBo8dYJ/Dmiru1Wzyp3C6rOJvqWPqvvNM+D6ZnyjOWpm5HeLQqlcXR+ENrTrNdNwiamN/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=WpgHowLMJjZcUkZ/i0KjeuPfWgv+mh1iAK8o1b+qx+QGg6UHGUWQ10b5HVankXFtHCcV4NvOxoKkj4F15nttj9WnuW9gUi3gYS3k96qXmz+2K/m1GGDY6Q0ak4FMFTPHSheBAnSXM/gme8/lhPIxCQBqBrECUoO9ExxiZd6ePKQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993738.namprd04.prod.outlook.com (2603:10b6:207:301::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 15:39:29 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 15:39:29 +0000
Message-ID: <cb5a7739-a768-41a5-b7f1-ce375bf2165a@wdc.com>
Date: Thu, 26 Nov 2026 16:39:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: zoned: do not WARN when zones fail to finish
 before relocation
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
 Damien Le Moal <dlemoal@kernel.org>, linux-kernel@vger.kernel.org
References: <20261122232310.4099580-1-mc@raidlab.org>
 <20261122232310.4099580-4-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261122232310.4099580-4-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0212.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::11) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993738:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dea054e-a10f-476b-091d-08df4bd375aa
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|23010399003|19092799006|366016|10067099003|11063799006|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
 DZX5b4mWfnikojMgQSCQpkoJ2zyF0WRwGol/lzq/i3l5RMA3Mc+5PRmhlOnaXl1W9ZmchG4EMnVQx/uivA+/RnioNgIsTIZ+E3Eeac0ZDhFOC1/nSDUhiiTSLo3PS8tsdr3+jL/M+rwCVPIXbYhwEIUEXQIJCNqz4gqmYtgH49eqPpIWfCvKf7Syb6bx6L4nXuuz68AHIpG73U1NogSfokwfQu9Hmuw83aeAe5mIoCc2oja5+LWFiX112y2LDCUX4PYdpbuC1Nm8jLR6fmL6dWDLI/93dISqWpPziTUEeol288lSjRdrdo0/I7kZHPE2UnOJhBxHU9p49ebPpXNTh4bEJRb1tjjJebynWMKeBe4xDaC2tthhynImwe/FyG61f5Et/w83UgCfdOMUvB9aIGHqbTz10g6Ip+V60JMyLP0l4FqulOOVK2xMvmQ8jcBFbLZMc6n0eX4sjLVOsMNWsxF27S5yDGVta2dJKGIDalDeS8L5J1uDNyN2wtU7RBu8eFbmZYIgN6HG1G4Ehwsp+7ZGjLqa2ngyBOX2YoM4VuHIGA5dVNykqr6cGfW0gXZX7KzE1PF91/P2YGL0A1JnOZbTBFKxvQDisx/cFBFqhSUoJfivnCcp73dvUAtx+Bh4819TxWAUIdm7QMrqPlRdDh9I8P4BbO6cL47coVetHfc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(23010399003)(19092799006)(366016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?YXNEaGpmNHdQTEExbnBLbkE2VXRWRU1BYjJ2ZEpQUE4yTnVMaS9zemgvQUNJ?=
 =?utf-8?B?aTZIMlZZbWtsd3FKeGVCT0R4a29QQnN2WXBKUXBuY0ZFWkVpb0k1Z2xNUFE2?=
 =?utf-8?B?TDVpWldLWVEwQ1NoOXJMTkxMTDdBaCtTendING5HRUo2a3hVU0lxcHZkOUM4?=
 =?utf-8?B?L0ZUcnkvN1RWMzNQZ1ljeUhQOEZMMURWczRIWHFFbTg2cUNJQ1RIeEVlUFZt?=
 =?utf-8?B?SHJ5VmRVcXdyOVgzQUU0YnBRK084QzZJQVhuMU1KeGFJNjQ0RWdWcGFhNDRa?=
 =?utf-8?B?QlJ5YkxRSitYbFp4T3orUWxMSHk4bnZCbVVBbHI2N01NalZLOFFCK3o5akxs?=
 =?utf-8?B?NXgrSklOOG51UTRpMXRBckhNWGwxRmpTN0dUSzROUyt5SXZKc0FKZTg4Tk1p?=
 =?utf-8?B?eTdkZmRxdGtYZDl6WEFPUTZoSDl1Wk1mUFQ2NVozSXhkQWh4NkplK2kxc1Fx?=
 =?utf-8?B?bWJtczlQMHVvSm9QN1N6VzFWWHF0UVdWaHVucHZmVFd4T2lrajFyVU82TlZE?=
 =?utf-8?B?T3c5RTVpUFRodU0rOWU1Qm1ldWNmdzJ6THBIbVlaU2VUdFUrbGpyS2YzTFg2?=
 =?utf-8?B?OUJ3ek5udmdQclk3Y2c5Y0hBOVhnZXRLTVJtMUlndXhBa3pDU002QUhLWW9V?=
 =?utf-8?B?cjc4NFA1YTRRN0lYUFR1QXAyRXlRbHRiTnAzNG9lNklseXJaZXhVSzJHRThD?=
 =?utf-8?B?Yzh4eTUxS0FWbjlESThxOHVLTUpuUXdsZHJQYm9ndTlPS1FjbVhPVVd1cHVU?=
 =?utf-8?B?YU0zb3Z1elNaTnhuWnNFamdvSHNxbTl2bTduK2ljM3ZraWVZbmFtMEV3RTVU?=
 =?utf-8?B?djM2cEZrUFUyV3dQNHJNazF3U3o2VjlPVjJSSkJadVZ1UldGMjB1bzJYSXFj?=
 =?utf-8?B?TWg0MVQ3bzE4eUlVMWtoQVBQVk5MeFgvdHkxTkZ3aTN2M3lnZWQ2YlBDYjZQ?=
 =?utf-8?B?ZFhDek1IazBRNnlyOUdmNVNoTmxYdjhUNGRVMGRjZmh6cEQzUGZqeXJYY0pr?=
 =?utf-8?B?UVFNOENkQTFjMWFtM3FLbnJlY3g3UWlUK2dxQllVdW50UzdjZFZnTTQ5NWo0?=
 =?utf-8?B?akxjTi8wVDZoQWM0Y2VRNTdVeWNqSjE1L01sTHpFSGF2N1NvZGFKOS9iOVUz?=
 =?utf-8?B?WFM3bkdnUFI1R2tuSEd5TDdWMnhWYjd0a2lUUkYyYm1tVk1mZGx0RDFMUjIz?=
 =?utf-8?B?SEJ5aUV1VExUbWtrb2c4NTBvdk9UVEZhc2ZVaFRHOEtvTlFnWnM2MTJudkIz?=
 =?utf-8?B?QnM3ektoc0Z3M3NoNnB0L0xuT2JMeCtCQi9CL2NiV2JBWjlwc1VRei80a2hK?=
 =?utf-8?B?U1hGejQ5TWxmeE1NRk93OGtJMGdTakhBZ2J0TUUwMTYwS1V3WVdHNEx1U2hu?=
 =?utf-8?B?dDQ3QnNwd0NjeDN0UkQ4V2w3OEVVb2xqUDlkMis0Q2tYc1JXandFSXh1Ym4y?=
 =?utf-8?B?ZWxOVmJqSlN6aWlIbzBrcEZ6U3JqR0Q2bEZwdzBZMnJHK3paclVTM3NwcVpZ?=
 =?utf-8?B?blNMZUlzUEdLa0lKMFY2My80V040WkI3ak16R09jc093UjJxSWdLQVE5Y2VB?=
 =?utf-8?B?SUFhZnBVNHJvYnJ0ZGo3NHVGZWhDUm52ZUpONWJNYlJFSmw3U2xWRUlNSW5i?=
 =?utf-8?B?RDkwbGtJWWhSZHlSY01aKzJYNUtRZXhTNC9sMWE1L1BYUUErZnlJL0lpYWdh?=
 =?utf-8?B?TGVTWm9UVW84OHpJVFlZSGxxMjl1eEFPKzNrNGVvSFRmOTk3MnZVR05aVmN0?=
 =?utf-8?B?NWxHUkhNN2hDNG52LzFaNEpETEIxb2txdC9mNjRkczR1eGp6YWZPTFd6Y2J4?=
 =?utf-8?B?V09jMWc5UGphc0hEUnc4ZG14SE42dnppQWRHUEVLREUvYVo4ZFFlalpRTDdD?=
 =?utf-8?B?ckFpQytPdVNucW9waElsdzViUlQxZllyUjFxVFAyc2FxaUNDWk1CcHBGZEFE?=
 =?utf-8?B?ci82TzV1Vno2dVF1WXNySkFJM2xPV0FGVW0xdnpCMDMvQlpObm5ZcjkzNms3?=
 =?utf-8?B?VUdraVBzS0gxaTJRdFJxVXRkVDNzZDQ4Q29aMU9SalNSejNnMm80b29lMGFa?=
 =?utf-8?B?V0JYMnJ2ZXA3MHE5bmdyaU9nekxFeThBNjFiRHFkbXZ4Y0t6MGVoZEJhbjFB?=
 =?utf-8?B?MGcyV0R4MWlaczRVM0U5WDlScnYyYWlDLzcxL0lwd2Fyb1QrZTNDcFlMOHk0?=
 =?utf-8?B?K2swVEJlSnVhYnIxMmJTeFJESmlNWE1Za3ZCQlZCTjNvUS9udTlxeFdldFBq?=
 =?utf-8?B?enBpdG0rb3huM21Cd0JoZ01NWTFtVGFnelFlKzNFcU91bklFMGkvNDhTdjIw?=
 =?utf-8?B?a01pNDdUWkd2bVl4ZEVMYklvOHVHNjdCQnd4ZjZiMzh2ejNsRFVlV2hGa3Fk?=
 =?utf-8?Q?qA5HeiAikgXXyaEMFnEUAP0dlZZovNGeTLRWXGW0gaU0s?=
X-MS-Exchange-AntiSpam-MessageData-1: QMtOsgyQNWzAdcMwXTnhPwdu7HQtOG1daPU=
X-Exchange-RoutingPolicyChecked:
	Vob+WbWsj7G6wjI6PWoUzsJlPJW9cy9ap4OYcZlHEYq5nymWMccp2H6qJo0MxY12lWWMrdvWp2+jYVFfh8SYbjNAFr6UbWV9Zip6/0jgg1npkSdfMvxm2QEgVxXj16dF0Im0SmqUQdHq8ztIDXu73WzphOVTyyVC+y1Ihi8gPxw4zJx/ZDOu9zLQrxDedrqV3uNmDsCI0OLiGGJBsOvaF6VP3VlIJsziLdb31CDFSyvrbwZjdpzzOUNwJCASDGv5wkWQeC+GGaE8wAE88VwfwEa5GtJrvaUfNeMLvVkkveqhAHtcHiRVbVBP9HRIF2xVSg9f7C0ZQPtTE8t5mcIE0A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y8uSsHaOtOkXlx640sBbDYWK4F6IPN2FiCWoMxpfBPuadQtHmGoTBGjBsUCXJwbk++YUxZqApIJ1XS8/W/eToz1j+uOLNXtHHPy+7lsglenRw9PjAXjQ1pPSa30gf+ggo1SUoNNf0wVkusUBiQORyWPmPfeIj8AKOEgUz9c/v2A4x+Z25rizTO7HVdvQgTwfHNK0nnjfMDo5eYQ845EYjPjeE9CvejEB79ARXBtw1rMNe4BDsjGrIMq9BFopApI1grt5vfngwbri1s8NHprLGcQlDxfayztjQ+54nzaymhBedrtY5twUTIdcOqV3J1aL1uw/J5c7SHwnPVT9arOgskHH/hiQIkk5xMRs1JjMfMOqDsOA0CTkICceWBuUKsic8crd7mmnI6bASwCpk5XQIUb2jZVqUhW8krXwow1rrNZCYnikA3xPukAoZRUp5lQ6paKif+Pro7y6Xmink598stXyK+6enAxFgSmfrWT9AmGsLFBg6lFBjCSyYuz2/mIi+DmXYcVQ6g8UQyW4sx00iZh/UaYwWKZtLiq6JKY4essDKKUgPUe4fN3r0GGmV5tp+zFnauqfRQTls+8OA78OArLaKUufZauDwGRPkBt+p2mxytqWeUZTtR7w7gLazXgv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dea054e-a10f-476b-091d-08df4bd375aa
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 15:39:29.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bzvm4bv8YP4jv0hrgAR/Vxe8a4yY3G4S7WrY4VeIQisu4vS0+rV80uVOAOy5NqJeHlqOceSni+w0PEvExC17Xnpr0G7Qqxl6JsVW0MoXwFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993738

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

