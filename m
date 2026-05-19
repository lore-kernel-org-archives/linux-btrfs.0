Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D3846AF10
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 09:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779184775; cv=fail; b=c/dtYiVTttTMas+0KKvdK8BG0jddD00U+DjnJImd/TyzMyNOrQxgYYbjUpID6w5/45Z7FdV42Z3ciWV4fy/EBoMhP+520sBxUaFhwERVzhwCAFqQTBEKGlpm09/vzCsR34ocK5wWkZFywe/dBeWjI2YCi+NE0enCT1oShjVZlpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779184775; c=relaxed/simple;
	bh=WsMTio7Z080u4mrHwmN6/Y29/TDfq7DRiFjW0KtmIOM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JMQ8gYEZTEW2afDcz69kHc7U44ifihJfVSyCd199s4lzd2LKuap9rZ5i0Gdak+DiVEq/RMJcb3oXzFnVgW2vrbf487fl6fBci948kf03uKYnZYfKV37JvUUccxtXCZBCkdjQ+7YiWhNoVVt9gdKO0K5cuniWSIPpJGT3LcJ9SSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=i3ve6rz0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=DUOvzzNr; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="i3ve6rz0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DUOvzzNr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779184773; x=1810720773;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=WsMTio7Z080u4mrHwmN6/Y29/TDfq7DRiFjW0KtmIOM=;
  b=i3ve6rz0j7QJX1HZPp3m4SSfRLUj1U32uW1MTo6UBbfpKRD9JMsS83cW
   vDMbsbuQQ2jYHQaM9+csbmSBu7I/fao+C2OPknXickZQh7Gw5QSA2UoQQ
   RS3XQvBi57CMnbT1pcICrbUO/GdKK2IBdJHJWp5fBFz9ENiDtvRerSsCv
   YrOajX4CcnUZWHIPpj8QJTExCgMTsFZUoO6F3LtqWE7SO5YFsGSzGXjcY
   p2vikgAlp5h551uKupcrqPfGrRzMd5d07isEOIyKfNPxva6V3mzDZzmvO
   vOr1CIZWrvjEDIX2V1/UhzfwCS6ks4HW1CvpBJknig/kT/9K2f9utmGSZ
   Q==;
X-CSE-ConnectionGUID: pHyJTGr7S6W4hjW+EZPmSw==
X-CSE-MsgGUID: 3nvqFr4oSImRlOABjdsU+w==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="146303901"
Received: from mail-eastus2azon11010033.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 17:59:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEaLP3DUtfd48mjXLwmVPFbjUdJaO+9kVrnqmnnMrcBGdvE0PP8t4LS5NjnndwfI2j4fxPb5iFe7sl71TMkH7XYg4tx9b+3IBaBmDVznG5M6uJpbEalIveDC61kEAva6zmThZmI9Ak6fnAWN68F672i0jSF+EMMdb5TEPh8ev6vrQHN6GZVVHJ1w8jV3dNmOMqcaGgEsOPK+hL6A1QG8BJvJ+sJvo6w2CeqNGRjry0/SDF1BQXwRkwdnum6yFjUoEGySEgjzXcp/mzLsdr/WsIgR8awNHoX+IJU7csjxDJt5CGU9cTpgeYt4+mbdApp6u/S0aKRFSxBqwKBbNbYuYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHZtHfBFjPcTgY3IB8gB3wMwRziVR3hsAWpXgod2q90=;
 b=w5jOzwVopXYe4lbz9aq6GCQl0mzrrhMVOkdtUYJYFhsUJwudzxJ8sL/sMaM2GeMBkN95T9bw79+zDh89MvJF2uuCd+T9B/niU9jINb+l7cPScroKyAmt3g1avf/RwGjjNWIPe4aA/srAPJ/G/t/xPPMY7oKACDhTy7LMr8zPH0A4e47WFX+X40DoHWARl4xeCDNtKCmpYDCMho+G3U7FvR5CUCmm5QPqNG54WOGCjOImRnuPqaaZF6AHRQquk5LXYa+vzF1U3rlkJra0WIyKLuYs+y6s8VfOfX7ut+aSLRRP+ca6fRLfDFX1uuNH1DdS/rqdLMp00RICXL61Ob7gsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHZtHfBFjPcTgY3IB8gB3wMwRziVR3hsAWpXgod2q90=;
 b=DUOvzzNripvjWwoYRzIHmC56BoIsMYkhU1iDaYy2lPeSJrXFf6aVqTyACuLXiBIjYdcJicCHvOvaz1qhfYwLPezN3VsCFd37eirJy3xCPCLBhtLwvb6+30CZ4YMof22FjrlnKKYQyKE6kLXbs2CXx0UnlWy26/qLt/2QBHos4P0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS2PR04MB9702.namprd04.prod.outlook.com (2603:10b6:8:279::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Tue, 19 May
 2026 09:59:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0048.013; Tue, 19 May 2026
 09:59:22 +0000
Message-ID: <7244807c-dc19-4b24-bdf0-ea9853641c44@wdc.com>
Date: Tue, 19 May 2026 11:59:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/28] btrfs: add trace events for fsync and inode logging
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1778776706.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0208.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS2PR04MB9702:EE_
X-MS-Office365-Filtering-Correlation-Id: 68f35f62-9a55-4574-3e8c-08deb58d4cf1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|11063799006|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OoA9STCHowmdJnZV4UQdpMg2S5lIsMQ+SUtves54R+WQj6aENRYD8ukxLewd9zq9XzDX987diND4aE7/3mRcMUmuvjjZlY3do39y0lmilmKmlt90hPGCjuu28C22ChFM3LLCQyDeouA9VMxSADGXSSBCBefMJ+gA3CB02q2Hz/uQHTg/bfntCh4KeW2kevZYTqSGq14JPGUV4YRVFYvXxE/d5yai/MNTYPWAGTxtpyozw9fcV7N9bpcaaHKbb89Nv3/xk0zcIbOqyLx6H4mzEb3xr8EyXLhNgpWFbM3jqIbmeIlXNCkLHgRnjFAoH+JHH9qaRKxh7ClZmcWE4ygiCt00WfawzTp2zJyFWwLFG8+Nqvd4szqZ1eCOtZ9SWQnL4vAzWSdx9uoOj+tH18ufNUtx9oLZ0hiwcANHqkA0nattE6mRIBL2I/foXjzxbRbkdtGOSGlPMii1ClpOvMpShqspASryGIxiIp05Jz1JbSSPcJ7fRNqCGhsz1yHrwXJBUHqUsXLT/pYzWbjK493L6Yw+QMl7vsRVRfRpEhs4W3VeMFj7jbKF5AAqP/tfGSZANK+9/PS3MgSXKC2CWCX3GzQNTLKaiFtmOD9EhldHJtDtPHO+1fwzCfiw2U7IInKroUduNImgDV3kOpqQc9OhTCPz06WU/ybWBK6yzJlOT8Hl1nJU7C1VwGuTAEl0seKd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(11063799006)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVcyNU5SK3BUVWx1Y01CUktxMnpJNVVFL0JUb3M3OERnWWJuQzJ2MGxQdkZH?=
 =?utf-8?B?T2tRK2VHTFV2VXBsQ0pQZFZsWGlobm1mWkxxQ1hKNUMwSVBja0wvOXkwZnlV?=
 =?utf-8?B?dTh3dzdtSXNhM1lFTFl3V2w2UWlCdisrc3hHVm4rdEs4clltbVc3MVlnd2RQ?=
 =?utf-8?B?QXFEY0RTU0ZrZVIxU3N6K0dBTlFYN1ZUbk5ZT0dMbzA3a2orMkp1emV0SVA5?=
 =?utf-8?B?aVJNYmdhY21IYUNsVXZOWHhqYzdaZUtJdnlkdmdqbHFRZDRpNitwS0l4VmJE?=
 =?utf-8?B?MUwxcVFuQVIwb1dqWWttOVY3R1FIejJJWS9USldwVmcyWHV1NHpDejlSRVNs?=
 =?utf-8?B?MHhEWGd6NUcxazc2WWJpNWNYRDR4ZGllQkpzd0YyNmE2ZGtIUzZISTlBQmFz?=
 =?utf-8?B?TXkvcXpEZEd4ZjNpL1B5TnBQSTM3VnY1ZHA1K21NZytpaEh5eFBlbWxSdjdw?=
 =?utf-8?B?Y1Jacm9pUWgrcWlTV2NLZXcwQkNieFpCazhPN3RlQy9QOVRnSXZjdE1iV3hU?=
 =?utf-8?B?bXdjTmxvMnZBZDBxNzJTdk5KMjBndTN6emhpWkRQY2ZmVmh6QmY1OGJxVHQ2?=
 =?utf-8?B?OUZUanpIYmZRVTEyb2VDNHZpVkI3c1pGSmozQmNpRG1jL1Y0b3phVzVaK2kx?=
 =?utf-8?B?SWtJUmNPS3Rqak5sdG1nVlpGdW9ZU3JOQXYyV2NrcXVnSDZ5dkhzbGo5L0J5?=
 =?utf-8?B?MzdrUXlwZ1E3c1YyYk82UTk5bStUc3o2STcwRVppaVlBS3ZROTVpcWhEUGd0?=
 =?utf-8?B?Nm5IUlN0UHk5ZUxSSXB1eitLWnVER3gwNUhlNWI5U1R1TTZYZGxCMVpROTMz?=
 =?utf-8?B?M0xUNHJjdXgrYTMxcnhzeGcvZjIvL1MxZmNFZEdBVFhCaWlNeHVxSlNsMlZk?=
 =?utf-8?B?Tnh1cDVhQTF5dWxTQXdsNTUyRC9BTE9jd29vY2N5bllRZnd1am1zYVNXNjR1?=
 =?utf-8?B?SThUWUY0RnpUOUYxcUtnUHQwVzRaVlVuQWt4NVNGZllwU0VCT1VIZVZOdmgx?=
 =?utf-8?B?ZjRTeUNvWHprMEo5MzBzMTJ5TDNWdUc2THlTRGJZaE91MmJDdmJkNFFSQWgz?=
 =?utf-8?B?czNBR1ZkSittSlN2a05GT2d5b3FlR2JpRVlPc1VzSFZ5WmxNVlVZSEFxTHhr?=
 =?utf-8?B?ZEc2Qi8yZ3FiRC9TTmxpMTRxNEcvYk42NTBuRnJLU1NoSGhpSC9YRlV0ejli?=
 =?utf-8?B?VFlsdGJDaVR6RE1kcFdtd2FuN0xDMHljajhlNm1Cb0UwN2thQ0ZGS2piTnl5?=
 =?utf-8?B?YlZQMk5oeVU4QjFabWtmKzFWdlZmaG1tR3VSVHlBeU12NFFZbUsra2tkNGZi?=
 =?utf-8?B?VE9UdFdjWkIrdVdaRlZ2eHhxNUYvdW5vMDB1YUJFamoyZE9kOUZHM2R6MGtR?=
 =?utf-8?B?N1pOaTFlRFdNQzBLQmQ2V3EvS1RmNlY3SkFaTkxNM0t6ZVZqSlFuRXN3ekNF?=
 =?utf-8?B?bUh3MFlTaWJpdDhuKzJaNjdmY1RuNFNnTlhHQlRyMXNVdnNiWTMwWmhqMG0y?=
 =?utf-8?B?Ukd3Z2J3WnludjlKY2ZCQnAvUGl0MC9Ock9JYWpKWktub2tUb0hNT1cvYWV3?=
 =?utf-8?B?aWtDM000V1BZWmd4ZEhsNS9LbWs5YlptcDZKZzRucFBPamxXNDl3QkhkMURn?=
 =?utf-8?B?NStwbjBEYWNtSW5jdzYzQm5tSjlrZkplbmtvcEowRmN1WDFOcTQzbUp4RU5x?=
 =?utf-8?B?RG9LREJ4a2dUd0xHbXZRSk8wV0dpcHdTbURkaVU2cFYwajRkTXpuNFFlakNr?=
 =?utf-8?B?aTdGWmU4ZmcrT0ZtdkNTZy9RQzVESEVMZkxsUTQ4UDByVURabDFEdmwvK20x?=
 =?utf-8?B?VkFwa1lYREphVFFjRDNZRStxd3NaeEdxMGRYcWdaeWhEUW1nUlVjcUVJS3BH?=
 =?utf-8?B?aGtXUFZzWGN5OVZtTDIrcng0Mm9CZjZQWDA3V1ZXcmlNa3lqUkJlck9XZXFU?=
 =?utf-8?B?NURZQU5NWkhoYzdoSVFGK2d0cm0rM1pXUUhZRXZKOFF5aWFQbUM4TDI5b2ow?=
 =?utf-8?B?RjdqZkN4bCs5cTV1aHNabXJRNFNlL2h0S0plSEZiR0ovUWNPcElqN1l1NDVB?=
 =?utf-8?B?MGxud0EwTVpnWTRzMDlPY2Q3dHJTNDBsUmlUdVFyZmZDZklMMDJnUk1LS2Zt?=
 =?utf-8?B?b1UzbnMraWRYbk1meFUwa3hSamtKeXJmdjUzWFF1YVlOTUk2NXVTRHNwcEc4?=
 =?utf-8?B?d1JLNFhPcjdPcFJqZXI2dDdGQ2V3NEtoa0MzVDhjL1FXeEorU3IydnhQMTds?=
 =?utf-8?B?NzJrbTRjY2QwSmF5bEEwRis0S3R0K1VobUhTU1c1VVV3ZGVvWVdWRmE5MkRz?=
 =?utf-8?B?Zmg2YkNVem1YVFl6eEJlblptbUt3OFV0TUh0ck9tRHRNTlpwQjdNSW53RDJ5?=
 =?utf-8?Q?1FBSFMkWOBRC+8Jc=3D?=
X-Exchange-RoutingPolicyChecked:
	RfPE9J8UtPbQEXlxYANb33UPLpyrYEHiCrQ+7o4qaDMm+/9quQl4Cn2LJZW5JRmAh58OQhKvOjixT8pTPXRK3L0GsmxJaPvafGBEJ1tKyxg99T+P0e0RRL7kNc0p28/EwtJA+a86sA+AL14MmeJY7/Bfv3/NrOGuv7VKhfWPPvxjQaInfRL8Yny13KeRpy0WLcsTMD30QP2y9HiveMRXN+7sVRvz97YVndlVbVfTfKAEvN9G+RtDBowbRIVJsaO7BY3BW6DxHAoURpmqMZRpxTooIm76ZfV2S76sxzdCo0hx5jVbtEKVF1PYs+o8MaiIoy5BOZXgU2L6zMBSFjuAaw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PRmKyfY+kCMDauxPttct6KCV89qfW4fqFH3V7DdZ75pAIM8uZTkgUcp3PQy7k/6FXiDIdmSylAqW77L/D0zVYI64wBrrVdxXJBHB+wQFap8p1lUwT5yA7+ZCKbPMaO5wP2zqalNuBd2luNpXy2gx95C1yfnhlq9zLPMg/rlZ1dNiQqqHa2e66t9NUUqNqO3nYRj2WNLhVqG9rwxsdUUwwrMHbLdYjRqJCgWJclkJF4uwRKFgWXhWO4UTdbeMZ5Q06HZPvP7MoaJmB7O1oy6L8/MItEVI6AA0zCALEHzen5uxPd6qaOQVM1ezgRsj3z6PTvNkJSIJn4BMYnRpvVHNU5WoUVV7iP+KGsP3SbCqWRJpMrX9bst4Y4W26d6aONvEdGxWV45LbXyN/x8p9/0VcC7nW2QBGbRTMgadTxde9T1tIQeOk+ZhoYwb3BymjFYq0C2OAPtfIcW0EKVoZzb0MjQIJgCNTkjGV8DAppb3iQ9JYtGvIp+UaZjRstPJEICrz98Y9do8//q2leWaLUGqSDVKNLVCN9ig8jmSeDGXYI3nhxFwxcMWa8pTdFsGHwoiWJrW5TJ0RDilllIZBMP+q5ohyWUn51pi8MZxMLQ5E8WSHsKvstaKHC//SZxWw6a5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f35f62-9a55-4574-3e8c-08deb58d4cf1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 09:59:22.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIHV+9cfEmANtsHFaWxDEqLybK656EKtwwZUTWJictUma/Ncw/aedHxEftNDIDU4ZM1/bQAPmLiN824+OAMLzD0VVWlZp0LjUEvSIYMxVaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB9702

Are we considering tracepoints an ABI? I hope not, but if we do patch 
2/28 won't work.

Otherwise,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

