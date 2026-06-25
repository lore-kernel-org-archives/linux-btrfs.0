Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0CE3C2B9C
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 11:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386692; cv=fail; b=ockcnVS4fgRznmbsgMatHquhxZnodTP/jl1q3EiyRwMoewMt+oItSiCulkMksWn4bx1dGTqn890UWC4QLW6Ypzk2Or08DftWDZQsQ2wkm66ifC6IDttFByzwcZ40CQ33lNfjA+MEt6imOKPkYT/HkWGWzzKO+eb26TibCPOnp58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386692; c=relaxed/simple;
	bh=H5/bGRVOFMdlj4XsjAgiLknIKIABgB5uF6tZOmpF65I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ueYAR0N1bLLwzwpVwZNyPcgoHnwlmlVGgeGO31S6UUcRaDJD0krfhvYU/enRYcygTDqg97vugSYCAaYAy0KK3i43FrwIRx/gnFT8q+A9bX4GiN7rkNEGWALV1uKcvi49p94uttFpSCWUx5Vf9d2O9ueV4hK+Fhh+TlOyLfVHUmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UsyE5KCo; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=VpSDwMeq; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UsyE5KCo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VpSDwMeq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782386690; x=1813922690;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H5/bGRVOFMdlj4XsjAgiLknIKIABgB5uF6tZOmpF65I=;
  b=UsyE5KCoIRQ9Pkn+6mAN6n/mvwGR/AHjcZMCiHvEH6DVlvfitwG18dY9
   0bKJzcVluv8E0eQ3+V97H8IZK9VNZG2sURof2URWGXjPgAot8ekr4O9v0
   j1aQb/Idn5udNBYNwKPm4GIqqzD4QNyWr9ZqLUCwxSCSh4SfjqbtBV6KO
   LdNmint0qYaZ9JLUrewbNprAdNvqmaR/lLDFIhzp5ybnRWZiwsEJfPrDN
   LyHpxM6VmzeiGmyWAT0i6xRube7fjJTzYC2Fp5PxUO8HT+yy9zD61qORA
   NzH7/b3fBe0uBQB37WTL9UmRsIQvcymClI3oMg04WZ3bQoOebCZcyebzL
   g==;
X-CSE-ConnectionGUID: K9dGcXEDQN+n016VOScLzg==
X-CSE-MsgGUID: 9wsiFfRbQ76n+0IWQgituQ==
X-IronPort-AV: E=Sophos;i="6.24,224,1774281600"; 
   d="scan'208";a="149817869"
Received: from mail-westus3azon11010015.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jun 2026 19:24:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPv5uOZSMd+zZ2rdneakzPDoJiSrr5Iw3CPOOqkX6qqIZisRR+4kB/0034P2kUGEl0wv3HAUyMJivq39k5h1dtVJ0A7z5PqhjHvPzv/b0++35Hs9D0VTBtyLf5ei2uizCudsN1EV6dnbDElkwEeHJbp+JJEFJigAiej8YNK/DOyrdAO/aPVCraSiHvU5Roewnz4bKA9cOutPE8TEMTfIHsYJzVzYw5Za53Hyj1LMe2dPbFP2BNTXreFm0/2xPNMln6dPPuZ/LVpxVH+I4pYwdTOkWSoT5D3PCjZAvjqrmjr65KUdgLGXd5n91VHwRGmV2QPsudM3CRLETaiUOJSBTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+BVQAV3in6UD/5vCoKvfFGD+KkWKfG4Io9vv50n/w4=;
 b=RVoDssmyDxAJXMmkp9qDVBLqfxf10KypJmcq8r0EQ4HdLTbsKphI+5yCtqxNEOEODqwdL8ugqUQ7RfFIS8tOjma3C1C8lLYtMhfZQoUTXte/tSrPxeJASfbh8YtqW0ntXn3Alq5S3yzzaWzOvgo72o/nv2N/EQeDdbTUDRvq9htRTm7DIriOe6glrakgJfEx+3VTfq9pKakP4dtyDdIIVwvFJc6jynkUS//il9lVMLeT5xDhIxYR4i/AcASaaG90T7NuLrrXKvR4TIP0CrNY3xlSZvtsvl+AfWLYhhN9qektEWzIJakewb92q0eK4/s+Z7xGeNlMEql2Y7llx7FI1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+BVQAV3in6UD/5vCoKvfFGD+KkWKfG4Io9vv50n/w4=;
 b=VpSDwMeqW60OPT9y9L8akUHhBiQWJC1zGVrBbCwns+V06XHmOQ5Xoxf8ruE/blQuLp6DzUxP3aky+ZjQ4JQ5SUF7yzgD/r9NKTsssOZR0+7gpeqCLhx6YxQMHiTiSi/5KSgT7TmZO9EZ/4vt0YH4gDMSDrFUNlmY2NDwbf1QbkE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA3PR04MB8713.namprd04.prod.outlook.com (2603:10b6:806:2f0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.21; Thu, 25 Jun
 2026 11:24:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0159.014; Thu, 25 Jun 2026
 11:24:48 +0000
Message-ID: <9d10ce34-9773-4b58-bcf4-57298aa4b08e@wdc.com>
Date: Thu, 25 Jun 2026 13:24:44 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/15] btrfs: RAID5 with RAID stripe-tree (zoned +
 non-zoned)
To: sun k <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
 <CAAuSuOqD+=nHVZu3czFe5JfQ3m1RDt0sWibVjPZdh4HeOom=Fw@mail.gmail.com>
 <b436c427-1d87-4c36-a159-0f5c03619771@wdc.com>
 <CAAuSuOpZkGX-mCYPKiD_Fni=0XdB2etgGrEkJJqBj4dSRqCZYQ@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAAuSuOpZkGX-mCYPKiD_Fni=0XdB2etgGrEkJJqBj4dSRqCZYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA3PR04MB8713:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ab615f5-8fea-48cd-c1b8-08ded2ac5d96
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|19092799006|366016|10070799003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0ZIMv622uSdx8f9eQPS0ZIEPXVDma+QP5Zt+fDrgE9q1YP+mmq5DFL78xCQlaTN3Eo/H5W5/GBubjWwbHUa0i0gF9m4uuqL/aImF5HLoDWLVBd1QtZcvqxCwm+qAp+aH+d+ybNvlKhXAacsjANiYr1kuxSVb/J3erNfffv1UZczjhqO/bwcNwfPt30xLm3tf2oguRr/4gyx+hmQQw9dkk7pOm9x3ftP7kWCulSB4Yd+3D0txZQMXF8WutctUqZtOq3u9YfkPiLr74afF9YGERbd24OZIrIJUJ59txh8tZfdRq5uTOpyY8hd2mffGCt54hWAHkaOm4Y/KLsrKFoPO7bS+r/BowYhfxo0MVtW+DsWGnXkGGOyti+HjXA6605IEsg8RNV55ABlEnhQNF02r67kdLBRcweyh8es0XSXGbGdhZ2TyFFcoYxT/TOStVkhUAbuXPX6fQ2+wAWNLONxasomog5/U8koAIf7zWw1dpslQT0dtphZOdrTht4YTLMPssqUVTspUCsmW6r4Eqze9CG6iRMIRF/d4bNNDjAdLjUOLWq/YXm667jFnZ3fquM+/cSEpnUGAcrjJ3uMLYU0b8gxBh2Db2G2UcgOYtfvj80/q8Qh3kMQN6Ry3ZvDa4FIOP1ukdk5q4rgaq9u+Lo5S9TWRxauxqPGdDmewekDziB0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(19092799006)(366016)(10070799003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WExQd1hRcGJWdFVTRytzZmJuU3J5M0g1NUJmOGw2OFNsTnpYanBKeGs4cUVN?=
 =?utf-8?B?Vmk5Tmg3ejdCamVPalczMWdObk1RUkZOV3FBYVRXYmVQQm5sVlRveXFWRGhv?=
 =?utf-8?B?RWV6VVlPREJYM0FNZDQvMHVGcFJUY3VUNTdDMWdZbFRhM3VuRWNpRzI1MEEz?=
 =?utf-8?B?bzduSy9ma0Jad0hjbVZZRlFLV0YwUjJ0VFR4Y1JxcGZzOHBVZXdkbjE2cGh4?=
 =?utf-8?B?a2dGYzB1S2tyWUVuai9VOVhld28xZjZHZ2l0VWZZem1uQ0IzVmtaV1llUDRa?=
 =?utf-8?B?b0pvOGFxYm0vS0JXemRIamV2R21jdzd6NFBrYnFxc0ZmK1haNTQwZ2p5SmhX?=
 =?utf-8?B?K3A5YWozSkVwN1hjaGpHYXhjWHMvZGtuRjFTWmR5QjdxSktScWlUV09sNUhW?=
 =?utf-8?B?bnovbUlodkVrdDJURG1UYXU1bmJCZ3JqUUR4c0RCRCtiOWNzZk1qL2Foc1Ro?=
 =?utf-8?B?NFRGS3E5L2kvOHRTYThMVzN6REJnVGJmb3hEQmV0Wkw4UWQwd1BER3RkS0oy?=
 =?utf-8?B?S0VZWmVZU1NvVGxOb2Y4VVFxVS9jRXpUQXhBbGZkWnMyOGRJb0pacGZJa2Jp?=
 =?utf-8?B?NCt3UEhoVnVZK3dmdGUwUUQ5UXlId1hIMENqeEx4aDRvcmlydk5ldlUrOGVQ?=
 =?utf-8?B?MGcvZmlrVkYxNk5abjhoOVpsbzNUMngvMWlaRlk3WFE5aTRTS1YxQ0dXcXY0?=
 =?utf-8?B?ZktsYk1uZWFFWE9PVUtFZ2ZBQVJGdW8zRHRwaXhHM2wzdFE1VTBFWFYxTVZu?=
 =?utf-8?B?ajRWOWV1T1FYY01YcXZXQVZmTnB0UzJBUFF2WTJuSXQwNkdTYWhVeGtVOGhQ?=
 =?utf-8?B?K0MybDdiNEwvL2M3bjd3ODFLc0hWS2hMV0hTSlNLZFlDRGhBa2pOY1ZqblVI?=
 =?utf-8?B?R3BZTG83Nk9DY29ldjZMUE5MczVEMzdtMGJHN2VhMTNLQTV4WmFMTWNUWmNN?=
 =?utf-8?B?OWc5bWhyNUdsV2hpNXAvVllaZzhIRjBJUHZ1dzBPNkU0ZDk0Y0ZPbmd0OXFk?=
 =?utf-8?B?ZnNRQjRYQkRLQlIzeml6TXBtcFB5dDU1aUo3cnBTbEZRQ2pHUEZtNURQbkZo?=
 =?utf-8?B?MTFsWUJZYlVUbDFEUE5jWXl3bFEwa3VDRHU4TlV0UG5pSE5UWjlRN2dQYXlh?=
 =?utf-8?B?Tnc2UnUvVFMvd091U2RyZHYwWW1VT3RoWlh5UjdGV0QwYVhaV3hPaVJ6YklS?=
 =?utf-8?B?bkJjRFJtNERkRnBvQURpOWh1MERuUXBXUHpONmNlM1hjR254Q3lndFg2Z1FJ?=
 =?utf-8?B?R3EzNTAxSkJwelRUOU0xMlN1b0MrMmdYbVh3RXB5K0x4VDVFOHFaMm1LdCtN?=
 =?utf-8?B?OVNPTngrTWtyNENqaFNMRkp2eU95UGJvVjk4bEpleXpUSjIwNFJ4dEJkVmtL?=
 =?utf-8?B?MlI1S1NPc2toTk5qR1dWOGFtTit5UDdKb2tFS0FTZnMvYVV6Y0d2bjF2T0Ir?=
 =?utf-8?B?NFZ2WXdQQVp5djVoTitOZ3VaVU5JL1d6SS9weW9XbjZlKzh4djdPTkd1Rndl?=
 =?utf-8?B?NkN5UnBjVGZqZHFlYTVxOC9JOVYyVGUrS2RlM0ZMUG5JS1VvWDZTRTVrblFE?=
 =?utf-8?B?MnlzWStsRnhJcjdpU1hzN3pSbzlkZmwxTStiL3Q5WlFiN25hb0kxejNTaFVW?=
 =?utf-8?B?Z0xSU01XeGF3NDVDYnZMS1ZqRzFxRTMrV0x6SHovZVJQMDdYZ05tZVlTMjY4?=
 =?utf-8?B?M3J2OTdGam9xQlBSNGlSbjJHU1ZLNUJNSE1JOWZyMTJKTGREYWdBQzFsNzJQ?=
 =?utf-8?B?bXUyVExWTk9jOEFIMU5ZcnFwTzVQSGlXaWNhUWp1UEpmdW1WODJjZVNWc0M4?=
 =?utf-8?B?RkRpT0trTGtzV2tyUUVZeGNIMHpIUXNBQmlHc3VkQnlFUXJTYXB0b0hmOEgv?=
 =?utf-8?B?LzFTSXlSQjJZdjE5OGlIelJKMVJWc2pJNEtkUjFEY0xBeGhMb0dlZXlkV09D?=
 =?utf-8?B?OS9kQXFsVHhQZXcyWUVQMHd3enhRMVl4aTdtMjFvVjBib1BBZnc5VEpBamcx?=
 =?utf-8?B?Mzl0bEZJL3dOZEt6bVhLcEhsNzc2dUluRXVjclBpS1d6cUJ0Q3E3b213Ylk0?=
 =?utf-8?B?eTdmN1U4dC9tN2FRNm0rS0VuOXBmMk55SFBQeWorbk1iZnFESDJhRnlxNEpx?=
 =?utf-8?B?Zko3Z0NuWXowRjZvU1BLZlg5bm9CcWdySWU2RUtCcTZCT3NScWhsZDhxQzll?=
 =?utf-8?B?NG9TNnBLbmcxMXhNVVpSQSs3Z2JFc0p3WklqV3BFYnVkdmV6UGdLNUJJQVgv?=
 =?utf-8?B?M3c1bzFTLzc2V0lvQUtRcitCSHY3TmcxNDIyMFE4RENRRHB0M2xNR0wwd0hZ?=
 =?utf-8?B?NVNmaUZGdGxPcEFsNk1JSzl4K2xOSG1SZkU5Ym9HUnVrb3Jod2p6ODdraUJh?=
 =?utf-8?Q?kCgq20XKZYKG5iBl8iDyjhYZ6CSm25CEN/LX+A6oEA80U?=
X-MS-Exchange-AntiSpam-MessageData-1: P+cVYihPJrttNJiRu2Q7vKGJA/4Zjyr5eYk=
X-Exchange-RoutingPolicyChecked:
	NIwUBD0pq1keJGirFndisyVQIkBlKTSzB3Bm7jN3o8YsDO96N4xZ02DGHOSJgHsr+vYLe6sWmRffY7TqIf+LBG+iSdHP14wtjTk9GcAuYWcxNahExirwR8n8TSuYR2Mlqi0jEfo4dwpFYVtU5P17Sy4Amf1oVMff5z9mXkUzISBlyEJImLdBqLc6GIcD362tnm2vWzzCSLe18Ejm/h9D/tOA0uvv0t3HCcm9dDn93A9qB4bTgBL+HbnqXmV62JUgATYgiywlzzGbsaDvjlmR/8eESmrlBCpoumhyg587nEStKFSxWV6qGQrWSnxgdqt8jjSo5wVqY7l0jJG5ATLqIQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9jbSuVOE+j7WP7zx3BruQ10zNjQsrHXQiBrLjRmCO0SwMIUKgRf6aHKP2b6BYPCSuQBlmGEzbTRokZBKZohZy4J0Bq/tTHBwYwl3YZkdU4fNghPJhMYSGTsPfHlarARGqay6ifXbyR8p580PmlxuKCFWjBUo5nuvpaF/8YkLe0+Tf2gyeBez+55ZAd7iIZ9Y/roFh0BS/bDw/PR/+IGUcCd1lyp2vTE9TNoS20GH11WPV0yhqnACMyYmorKwFlJPhIkiKwPq4IzUhHHa7ITMjORgaC7UicANnFe0He3OMVhuRkmfR3tc6lEHPikBwB0cTo8fOl0Y/qBOItmjk5Cx0l0DReKYFyFAqFPn/wFNiPWavoP8UQWwrpF1bfI/UnOJkY1ENy7iTB6JG3QiYBKq8kvSKo82qcbyzcCO88d0p5dcZieNvaNZA9Xs2JOU2IRtqVLQLK15XQKxluEUruNPX2y8ioEt/2cWOnQQ5M47MLra/VMd8sBDK+qeoDMcwxRXfeC+kgJpRSVAO1B6BQsoQuqVfwyDlxzRM2L2TvqnleLKSA8J/ruRV4nFYxtTW3/TnEbjcZOibW/lCKqUZPSylOxA5qB7fP47QncvK94k0XasijpoGjwRWEFKfEvCHO7T
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab615f5-8fea-48cd-c1b8-08ded2ac5d96
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 11:24:48.0419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJ5B0vpQ7S5g1acuoK5jAz2RJHW1Ih9bmFKpdE/6HmBkc4BkpFN6DwUy7DqWYaYeBtZyyF+vqJUz41hIrltNf2aA1ftxgCesYD7d3zEO87M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8713

On 6/23/26 12:39 PM, sun k wrote:
> I've just noticed that I'm not sure about your mindset of this raid5/6
> rst feature.
> So I want to know do you think the raid5/6 rst is extent layer raid or
> block layer raid?
> Because they are quite different and I need to align it with you
> before further discussion.

I did have a what you call block-layer parity raid without and RMW in mind.

But RST is only a mapping layer, so I think we can go "extent layer" as 
well.

Hence the early RFC, I'm still open to changes, as long as it works on 
zoned filesystems.

Qu's idea with a RAID4 style (I say style because I want to be able to 
use multiple parities in the future) with dedicated parity disks is 
something worth exploring as well IMHO.

[leaving the rest for context]

> For extent layer raid5/6, it's more like what zfs is doing now: we do
> the "raid" thing on each
> file extent, split big extent into stripes, and write them on
> different disks with parity. The issue
> of this is that the performance and efficiency on small extents is
> bad, but we can always
> do full stripe write, avoiding write hole issues.
>
> For block layer raid5/6, which is like what we currently have without
> rst, we need to deal with the
> write hole issue, possibly by
> 1. totally avoid read-modify-write for a partial stripe update. We
> always write into a new stripe
>    append only instead of modifying an existing stripe, like writing a
> zoned device even on non-zoned device.
> 2. or we allow read-modify-write for a partial stripe update, but
> write the D and P elsewhere
>    instead of in-place.
>
> Option 2 will cause another free space management issue I've mentioned before:
> let's take a 4 disk raid 5 as example.
> before the partial stripe update, logical address LA is mapped to
> physical address PA0(D0), PA1(D1), PA2(D2), PA3(P);
> after updating D2, LA is mapped to address PA0(D0), PA1(D1), PA2'(D2'), PA3'(P')
> then we need to allocate PA2' and PA3' , and free PA2 and PA3 on disk 2 and 3.
> Since currently btrfs manage freespace based on logical address, how
> to manage the allocation and manage physical free space?
>

