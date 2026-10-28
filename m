Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793184214;
	b=ARld8SPnB8MRLHNMTQHxV30Ut06LUiQhYnD2+CdeHjQrnjTkEoDEtD59aJWEI3MlCyQb
	 L2vjurz8437ML07v4ShpH/XZtMzpKZ/03fAPP4w3uTy7DI3x2t6Xgbk0khCeU99SmyUTi
	 Q/AdOCsr1ZObwA5wzlRVfChFZHu83IsPWTz81aEugjb70NYsbQ1P32dDIDxHw9ZGESnk0
	 SQxBQa+JTygfggjV1J/L64bHZdDDMVGYOGFDWvQ1+VIJYbeu/v3rYqH5ksriPHJNHVwko
	 I8HPoQPKmJkyNOB4BL1KNYBJ2GCfBgHiwoRwLFtt6SMdRfFph8Y0JmitCJ5pTcFYHcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793184214;
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
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	b=u+LUA3tDNKY1TvV5w+q402KZnjIRftxCVb9V7x30yuO+78lPppeuJomegotzAOpAE1NR
	 aOzf10DWreLb0N+nqynf7RA9IhpSgDSBzZINRutG2q2Zkcn2KSwlzT7eDSNb9N7YC3i+X
	 1eA1v9nxAKDvCuEll+ut6guYNC7FEdEQ4PJJW6O2yUnZghb1QAJzftiGiPnu+WIwsmrhh
	 0K9MO0IJrmIGPv+1JUtqcvHaS5m+ixqoT8De5+I81esZUwizFyMnWndC3lUZjvYOCkQFh
	 8wVJSvIfAQd0+M/UWfMclQM5MESfnobKivZACZh8tsuFyy1Jf0y9uYF3H086rCGISTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="c/sQ8GVR";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FYeFbC9j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83168606A31A;
	Wed, 28 Oct 2026 10:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83168606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=c/sQ8GVR;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FYeFbC9j
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793184213; x=1824720213;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=c/sQ8GVRgKaESJccK9nK0+qyv2PucjujJgMWT9oTxpMvsw+n3WhutF3/
   HqXPQ6y7UbXRUATXHT78wUsqTtvQDEpO/R+LRmAz7KGXEDEvMm9dTVx+o
   eHIG8c5WhoiLzqmNMoTx31GiOTVuA3BrcqKZRoDDt2Bbi+x1/6Bgxrxrs
   DD/ijxTlXw0qPH64zm+MhA+pVwYO6HxX7auZrMEgstNTO3CVQauSc389n
   olzzRDoiy7FrZk9y9rCcSZ4IWLX6K05yd/EQf6HzEWKqLuu6mq53jugA/
   6PYB5ZVvKVEppQNzkRKglR8+Hzr9cyl/VeaK41KFunc/rHpyHE6b+br6o
   Q==;
X-CSE-ConnectionGUID: 5EC3z0/qTMCsPUpLbD0j0A==
X-CSE-MsgGUID: N4eJ/QOVT72ELr+kSMHYxQ==
X-IronPort-AV: E=Sophos;i="6.27,182,1786982400"; 
   d="scan'208";a="159203923"
Received: from mail-centralusazon11011056.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2026 18:43:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OuNnHP/sq1LcyAAm16gw3AVSYK5uY43xyY5tEy8rljtF6TMWuP8UgNBlqThiHu/jQF2QDJGT0wgLx+7h2mqsS/rSf8L07sCP8hRZ/Acmkpm3U19usmwkkZC8Iw8E0SXzycUWV9c307Z0lSR8FSesDPrOh+Va38w6fcIepxcYVKpNHbfJU00+TVe8su7GEi48++5X85ekfKydVyW+NWrLbCxBPeOLhYFmjPv83BxnouQUILOhTGNeJb/hr8vPTEHb8zBzpzTeTC0ukIkQk76yrUfcTIqDsMchzeJGAMWQuk1LAqzC3G/TbDL8Fx6Sik/81jh5eViLWNQeGkNpUkCOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=pSdRxY9NxE+OkjHJbh6gsIpKzXmd6DuARbHScWt9L3iaeUDfmpsc/e5aWeGOuWVLrqOBUEgRWdJCP67+poH4d9x4bZm/vXqyF/ffPOWsAvYF0rfWkFc+G3oQMvrJbqVs4oCBWbLh8UqPkNtWhrr+qcSRF9DQYdwo1ko6nuppEMh18BTLOxPEXFtdWJtsUvm4EOkw0vuaFkhbVG7dvRqYu+pUi1PKhETFRZW+1wKG9895ftl9VO92u+YHVZCwcLsuhlA8xk0vbU/FSsdn4Sfz8x8TQbBQizqUsOn7WVRTc13i9k/R1X36QtSVn1/LEweMlLaCwS3xkKeuTuII993V9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=FYeFbC9j4Diqm9NvHt8/Pvw0SAPLUdlmISQU4Lk0xWOKPaWN2QgSmT9tKukl3GToX2e71mPQbo7qUZu/ZvRZmL05pUp6yPGFenO4VIVRJdVVnixU93HBgN3rhbBlvvDtxVP39m8Z4w7onhdDp6t2VV6yJm2PK9/alq/GMm0z7v8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS3PR04MB993945.namprd04.prod.outlook.com (2603:10b6:8:604::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 10:42:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 10:42:49 +0000
Message-ID: <2316e12f-c8d4-4a07-9218-ace10641fc7d@wdc.com>
Date: Wed, 28 Oct 2026 11:42:45 +0100
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
X-ClientProxiedBy: FR0P281CA0065.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS3PR04MB993945:EE_
X-MS-Office365-Filtering-Correlation-Id: 42962018-6d87-4663-5efc-08df34e03615
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|23010399003|19092799006|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cE1pfob4rcipSKjSCFd67vDJsCrzgo6NLuSDnIpUOd2Ze0u08d/dDfWp8yj2Y9oWS9cXBR9ORzyewR9kNfa8qWoIOPnGTShs4yez40E5JhFsSismyFdqmukmyxWY5paUoedjWrA/pRTMcbBwEK5EFRVyapessRG5lotAVCX+C+26+GW8vuvVt9EmfZX1RJgzVnIbIKFnlFVLHVQ5k/2m8jLVRPkT8eYzbjfcvWlR68Tj6kfbCWbJmhOWeVlmLYUyDT0OwJ1SzzdwHswR7E33BOHcfGOKz9n+HjtnqbPBMa6SSnD/qav/5HbIGkroRMWl704FuGQF2V1rhfs1mar8VoTFXnWUJjfdnP7rnQ1S0LXm8fFHMCD4S3kuUEzIo0vf88fUfK536LFpuuXxv1+s8Q4FumU5gsyvupW66W0slZmhxmvgH3qHrFF2rmj19pX1b80eJ9iVXM5XhCCN8NIiNKHGYxGbI4dHFD1JDUa5obtmykAp/oEDMQwhL1Zer6kIqZmSQ8RqIj6dfooNojYhLgkCpqExrD6U9zvU43iGJAF/Tku5AqEuDs5+5vVGPJ/2yC99q8Dsva63HdQ+sQmiAKXFXI81izhQn1k/ELEvzFmqsLIgxaGHDDCJrcg7TOA5b0Bv0o1MELbWk9igjwZQ0X8xs+b1AtipdMXi1VqaJfM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmljL3JvaVJlcEFpdFNoWkx5K1JONStpcjlIMmdQUW04UWlXcEIvREFxMTFk?=
 =?utf-8?B?YlE5bTVzR3htcnFGdk1Hak5zZWlJUStqaWI3S1BtUVJZcXRMZ0lWZThPWE16?=
 =?utf-8?B?L2RSQWdmamUvOW9TMzdTYWxkcmhEWDdWTHFza2llVzBvMUpFREQ0dE5Qdk9t?=
 =?utf-8?B?VjE2Y1owMGQ2emVmSGlYcDg3S3AvZFpMRmlvWXVKaW16OTk3VENqUENhakJo?=
 =?utf-8?B?VTVzQThETXdTTFY3MFN2QzF0b2h2SGNtNk9XN0gzVld0Mm9XZ1NYRDF6UjN4?=
 =?utf-8?B?QzhmL045aDUxVVE1M0VyY2tsazZwcXpYbytEMDZ6cnYzM1IwNE1WeFprQjB1?=
 =?utf-8?B?K0dNZUFxZ0lYVlFmYXUzZjBBSkgxY2lwak92Y2YxWFNCTHM4VDh2a0g3U0VH?=
 =?utf-8?B?YUxCZllSWTRVQVVGTFZUNEFPc0dYVjJMWmlPMWxkQ2FtWXhPa0pqdWJOVVpX?=
 =?utf-8?B?OWY3bkZqdmJJbTRKOGpqYjByOEJEQUJBNjhKUlcrbUh3ek9aSk1jeWw1OHhW?=
 =?utf-8?B?VGhBeEJ6dmcybVozM1FtREdzM28zYjhqaXF3UGlQbXJHWW9yekxiQ2xERzdJ?=
 =?utf-8?B?cnRDdFZaYjVURHcycUN3UURqc01zMlRONUtoYVM2dkxMMGo3Y1paODQ5MWZX?=
 =?utf-8?B?ZU1iS085Uk9pUkxKUmRScndIOVF1MCtYWC9BRnNCSlNGWnB4Y0NlckpWbHRM?=
 =?utf-8?B?WDhPUi9jY1lLN2ZmR25IcFdmUk81emlpMTBWTDVTSU95L0Q0TTVZbDFQVnBk?=
 =?utf-8?B?ZXdGZFNZRlpTSTRsV0UwanVXTVFNZVBLMkRkNFFZRnNYMnY1WkpkbUVSbnY2?=
 =?utf-8?B?dmxTSFBvVERTY1JCRmczZmpkRXZTT2FXV3Z5eTkzUzV3OWNOVmdXOTZ6VmNp?=
 =?utf-8?B?SGVmT3hQZjl4VzhSNWZZSGpFTWFBdHUwVFJzKzV3WkttTEwvZkkvY3Q1bGNR?=
 =?utf-8?B?UjR3TEhOcHh4SmIyL3I5QlVJS1dzVlVJZk9aaEtlRGhqbHBoUTF2YUQvVVJi?=
 =?utf-8?B?Nno3Z2xBTE9VbFdUMDJ0UW1TbW5teHBhNEMxZnJMc0NZRlJVVks0ZUEyVzk1?=
 =?utf-8?B?R1ZZWW1OTWxocXRYQzlNVkdFdCtyaVN2dVFURm43OHBGaWN0VVJCMW03RkRh?=
 =?utf-8?B?dFpoTTFQb0J6Q0JOb3RXUmQwOXczNjQzVGlHcW1TODVFQXd1a20yTGxzOVRx?=
 =?utf-8?B?WmtncGdQa1pZcjAvUzdjRUhXS1cxRm5tV25BNzR4VkJLaTcrb3FVQmp6cjdy?=
 =?utf-8?B?RXZSdnJ6K3hvN0NhZHFKSkhQSVZIQmdCZlI3NDlOTktWdWtiekdZbGg1Q09C?=
 =?utf-8?B?VHNnelZoWm03NnFqY3REcVROMWQydmczV3Rlcm1xZlRQaGR1YkMwdmRzZ3FW?=
 =?utf-8?B?YW8zUXNRZStCNFlKSkRoOG9CRlUyZUhUVFhkdWNwc293aHRReldmL3ZsQksy?=
 =?utf-8?B?QmxoMS9uTTZ5Q3Y4MndaNGw1NmZsa0pyaG91Sk0rUHF0akxsNUJXeVVUcngz?=
 =?utf-8?B?VmRMYklzZXhneDBqK3d6VmxZQnBqS0F3SU5sN0p1VzFiSXNRVUlLK3AyRktC?=
 =?utf-8?B?S0R5czEvYWRWYzVwbzY4SXZLUEtIMWFtMi9FMjl5ZjQzQnd4RkZwVWFQUEZp?=
 =?utf-8?B?d1JVUW41UFNoSjZFbHMzZmRFWS9sckc2YXA1VmF6QzJqdE9RTDlvTWorZWJt?=
 =?utf-8?B?dk0zTVdFSHkrS1FtU3h1K1JybEd1cENpTVdEU3hGVkoyR1RlM25TczlrM1U1?=
 =?utf-8?B?UkZGNS8vd2JnUHBMRGEzeUFTQmJxL3IzTGZDdGhhV3k2cGRzR2tyb09JblFO?=
 =?utf-8?B?NjgxNytWL1pyZmhIdUI1RjZ2dUw5RFFhTFdWMmdyMDNUcHhiNk03ZDdqSlB2?=
 =?utf-8?B?Nm9qNGFlaUVFa2xydHNudHkydE5qVDJuNFgrS3o3UDA2dVA5WGcwMXcvdnJC?=
 =?utf-8?B?YXdQQTh0ZE53clR0REw4NDE1MWI3WEVGOGRDQ3NwZ0lsSUtoQ21UY1ljZS82?=
 =?utf-8?B?dGZ2amNYMGxHV1B3Tm9RUy9MangwcHlueGVyWHJIeVREOWkxN1NBd2NCUlps?=
 =?utf-8?B?N0RWT1VOQU1VMzVZLzVuNmVLZ1FhVXlubTY0QXJYcE0rQ1BNbVF4TXZNQXYv?=
 =?utf-8?B?djBOYmNaS0RRODhoVTFEOHlpY01CbkFxbmIzZWdsNEFxOTJmYlFjdkhXN0F4?=
 =?utf-8?B?SjRUdzhMSSsxTVBLMVFDMUZMdUdSRFVFK0Fza1dCZW1vZWxwc282dEY0OC8r?=
 =?utf-8?B?T08wS0pSdm1mS1FTZE1mRENtRXFUb2tSd3JScVF0V1NhREtseWZUTm9BZ1N1?=
 =?utf-8?B?S1k1UEYzYi9UNG5DVUpLWFVOd2toeDErZ1hXSUFhYXVaT2JFeEJmOVQ1NVhl?=
 =?utf-8?Q?ijpi1isPqKqTRqXeLcloMuYzRmagjX9HGR4s2eKyy/u8/?=
X-MS-Exchange-AntiSpam-MessageData-1: Dzl3cNPXdEKY4xPjtnk6Y3Ow5J6Nt7Ondus=
X-Exchange-RoutingPolicyChecked:
	RFieGvCHdufgRtxPOxJnjQnhZGsCq4zc3kpeWxWb4H9mY3jbm3Yj7SozW7csCMQNsULL7oeq7Kvl6MfyiWpfSEvrbdiFdv5kOcS8uA01Lh5ExAleD25s4HGkUoz2oGtpDvTbfHFWbW9HNT6HUI5VuP1P02wWy+R1+2fDN7FthcOit2SHvdS/hmmMO/GXnnohubtRdxvbsBOvQyPx91HpIJoNaEz0tAA2dRY6JsteZXXSR0swaneppWtv+hIaxRnWaY1Cr4mJJrD+gBMQ6LorFYgKRgX25LtTK981N3O7MpYS4uMPjPyG85Q8oj+6ZoqHb+xy9AvR0wXf38T/IjueGg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	adxOVYPM81onp3GJqVPxwQMujycOwozHbb9y/S40BfXmJU0C5FvOvPQrKYPCVrOAsBRrtRAbhtFdZGyXfK/AZb4I2qx55VN0E2htNQJFP3H6V/ZE1KbjI48Tdkm7I1HLDDtcNNDv8wG7x+pdoYLK6+ou2ScIT9ukft3E4QhVcKUP45Too2IacFeW2AbIHBFMTOvHlCASFDE4WwWYiOSt+j5BwLauPUA+PXPzK5O/n4XFubujdAPPznFBKdCeeWHkh2GvyQL0A5iCWVIOzDS+VmuxKUDmJn96PkpYOmi4vSyrImuE9WnP7iRdtWabV+EngHBM+w6Htp1EI6ATrznGxGWGFCUzoa7dFDlxoWjJdSTK3fVnJKTqEfR+0c6GbKV829JwdaWhak3/cAgGCVdgh5ZMVshBtPdbaNiwThimv5zOVXz+mDp2xe/MnH5Hrlf/K8+ZPfiY1n6WNhTu1tH2OwrFcrJo/eWpjlTxIgE/wQHAUmPUQ9avRBuASetJfi5E0DR4MK2QZsWfNBPFdOUIPdeoOC7ElgCc/klfkpKzNciRpD+omgPKTUNd7daDQvUDw0gO5h1Xu5gyRsgRQo0WyCL6WGdxHgmm0laWZlgeVg1VuJSiBLUc+m5DlvwiVm7p
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42962018-6d87-4663-5efc-08df34e03615
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 10:42:49.6234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GnKQex/2GDZUw9ia6HvHgop2sAj5MP7o6c3I8lxmkBKZuY144aBYCFGFE9wvHY3che1PsE0gKB7sgmOYiy8Iyr7pN/JvwtGJ7XxAEUvojo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR04MB993945

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

