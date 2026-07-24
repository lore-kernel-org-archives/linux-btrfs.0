Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B2C361977
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2026 06:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873352; cv=fail; b=AaNBZow4Lna8mi2aQVKsdwx9YHT6GbjNgSiQW8ZLnFU20q91cRiYBY5xUySALpZx/ezJmc6OG8b5CEJ3RQ3NHNc66CWHEYBvYN297ZGqHQKRf7ONhZShq7mptQfJCrGXgyETakss1Dz8GFdt0edbxi+IZcW2SiRmgUhFMMeqi3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873352; c=relaxed/simple;
	bh=ZFx1+dUY4ESB+waCuuy2/UH0a/5DP6xE0Sd8h2/VwAI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NwNbmrvLSjk6pSmJcYF3adciImMiiHSrSMT+wc/dM/w11LjSF78lNGA4WNDdYr/7AoiI2Hus6uiQzE1KNq0bnWS2V5icRWD/ucuqKvqbOuWZ+x/5XuYm+mg+aqtdDJyi8gXv6EAuIiUhnd67yQ2gTgw/yQnuiX96vbxvx/QIZCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qh2/IJVa; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wqee+ntV; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qh2/IJVa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wqee+ntV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784873350; x=1816409350;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ZFx1+dUY4ESB+waCuuy2/UH0a/5DP6xE0Sd8h2/VwAI=;
  b=qh2/IJVawDqK3HrmnmItWvy1RNxoiDZVGGpJWzKXVftWZTGMlqsebAO8
   dW+7hb3nQTbI2uYOorrM1ehAf82e1z+T5lqNNf4PqfoOXDmTuOGplAzDk
   gozvCGNi8Rqg5Mn9VH4ClE7lt5PCgc8+iu/PyWJC2ZFS0jYZZCE3OzQml
   Jcbe8AO3PRsWYP8YJA1l7x6C2l2Au6132ZcBayyPpKVLUtHrNMIATa8Lr
   vUm2ocIHD1Bo8SmOyGkjBez+GqilIQBIqlaKcVhAbV/Fau5eEMF6oyGwn
   6QkPJfZsXsEa8nv4KULu1acw2XOX3H/BDOvynU2wDV0R0S0RWDVT+PnzP
   w==;
X-CSE-ConnectionGUID: EO9CrZMPR12A9qcsSl9O/g==
X-CSE-MsgGUID: VmP6vpJ4RU6ZYKG7tgyYgQ==
X-IronPort-AV: E=Sophos;i="6.25,182,1779120000"; 
   d="scan'208";a="151411422"
Received: from mail-westus3azon11011051.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jul 2026 14:09:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jp+rHT3pndyFyLkOKVQkIdXU1Q32pZ4NtG1AIryvYJn40QrDe2SpIIziCT/oLmpQzP6oXrNQhX/yh2qnOk6A7xqJRKmWFxH+81xLUFaRkXhO6zpCYhKyaY+P53Dgc+0D7X4cCthfrSEnhJ7HfeiixC9GyGxlQAWZhMnZ7Y7x1eTH7TUPtZlkVk8HOKy/cvDUr88sC4qZWJVT4dphuhBpqujAZF4O213jLr4VY+TBDPDkNCaaTuARkrIMyuRdUN5EAyCOHgmCLxO4u+4VEwLn54162gqDt20MiPDswkFsP+QIYBTZ396PrCFfKqJcdXHpnEhUKi/ZYnKztv/Ih+yzcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yryFZ/1ZHRyDrn6fQPfRM0jU6tVJtoIhtM1LwhZyWr4=;
 b=OEScifo4+rNV/pw0MmLEtE+CJWz4iza61tX8QG3FpoyZSs8gcxyqS/gQAcB/Z22+vYIZzy75zIH/jdCpVsLlCk8jtlicCj1haIZ1PpKQHuacU44z1BoX6gpu46WAU8eMdwVkkWdendx8jzQAGQ8RlfHmkPdQ+svGkzwOnFy91x62rZc63M+zgReA7ZeT43mZ4qg8a5GDvgwozivDRnXRgFWPyS1H3PyCVEET1cyHCVifUbMiW6g7l6DDnYLtFULrpc6dm+J6JSuBsmXOWAGzDXAlGY9b1pbMiUqp06wSEShAgbICasCY0pAOBJcldSW0vQUzwfcV42xitU7VXoiO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yryFZ/1ZHRyDrn6fQPfRM0jU6tVJtoIhtM1LwhZyWr4=;
 b=wqee+ntVtOAQLKO6HC8jriMjUgyWuhK+PECqrXs5luK1AVHmCIG2t+mek9YR3lxqG1TD3YAcwFrFqrTTc9EwI/yNbx7KEV4KalL5d3w6/hQnJJn8ozcjJnqMr+XEZ0coK6p4fdKbZU9u/lnfYfkWT8298JJJCKS/Og4p46eD7QU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6479.namprd04.prod.outlook.com (2603:10b6:208:1a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 06:09:01 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 06:09:01 +0000
Message-ID: <a391c628-dfb3-4eab-b9cf-5e5bb1931c7e@wdc.com>
Date: Fri, 24 Jul 2026 08:08:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use ordered extent to grab the logical address for
 submission
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <2d35e00bd75f890fd61937b9fbf29a7f621e5605.1784868445.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <2d35e00bd75f890fd61937b9fbf29a7f621e5605.1784868445.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e99656-516f-46ac-9266-08dee94a0e51
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|19092799006|23010399003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
 2W4SognpkdrY+USs4skMC+xbRuKCYg0iuLi+Z2XucYPZ5brdjydRWtFXZ448V1hYl+pd/hcw8oTZGy2+f498ctNVQH/rbfMylSJWaS1DFlul2S/XLCHfqgY5m+DYoEky5XiXfFgNKS/NAORf0xeUdfXD1tHMu2GmLIclSc3Yc0X8012Q8c/nJnWDGu9rR2B1a//w20EKhMhiimOKIPqoFd92RnkhwgGmrJ/zZOvpJf/hK4Z7DUprsIfqpHkpcciwqGphhaorylEc8U2VS81FBvUpVBs4O8kxd2Cj65n1PYd5LM9wc3h5qS2+ZOfFHI78KwiWz6E384ZI8ZHr7ZQknqMeKhDxzTUQYTzD4xXeHiMykEqofyWFXj4brYz4Oe3/H1LiRGVT29UMMZO+WRSpufYVnCG1KhHr7j9r5t6axyV5lm9e3ZVbc+xt50Q1oOBE8xvuxuGx4k1LgC+c9tl5Z2LULup0jHXt2pTn5pbhWgYbiVC2Qrlu1dPuO/fT7Cgbc7PMQcSuxnWt+od+m3pAf97oM6z5C3l3MALWJeopFsPCACUVzCJ3rKCh5eFDGCLDPuvuMH6BQzZmAwEZro6H5s5jYUHigdXs30UMOk67jAfQycoNOrQrYyv1Sqx4np6jvfizBpkqDrw4rF2hKKtXY4Vez6AGP1ZYT4TgFLwBenc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(19092799006)(23010399003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WUZjaStYbzlocUVCVFdsMWJsUWtLWmcrOFF1eCtNa0FUOGx1Ri9JSkRCMklP?=
 =?utf-8?B?YWhYbnR2aUpyL2Q1N0ZjWW9IOXB3UXVrVU1aQUZaYitOWWRTa1N4SXREVGxJ?=
 =?utf-8?B?dXJlWnByRUVycFgvRGtDM2crVWwzajFieWdVMHBneHhEL0VsdHM0QWZaUm80?=
 =?utf-8?B?QzE2R3l4V1FSQmRNdmZSYW5jNitEb3haUzNkNnlJU3o2WVF1bHhnQUtYUldi?=
 =?utf-8?B?UlNHd2xPelJRVnY4TzRVNDBBVmdKWWNtSTRRLzJLYTlGMTJLdFZaY1pEbkdw?=
 =?utf-8?B?c054bG05TGFEaG1YTFgyNi92bnJxMmpoSjFrd3JvVWNtQzRlNDZZcWtPQ1Zu?=
 =?utf-8?B?Mk5nMElRdU93SmI3dFE0dXJkK1FHOHJta2RXS1plZVczOUxuZkxUWG95Vnh0?=
 =?utf-8?B?bkdmYXZXL2UyTWQ5NXdMMGxvRHhhNTRFMVc0N0JNeWhXOUptd2VicW1DV1BU?=
 =?utf-8?B?MEp1L2tmTStOczc5djFsNmVpWkFLQlVkT2hNS3pwSUMrcEIxK2NCZHRvWFo5?=
 =?utf-8?B?V3hDNWgrZlFuajBoZjVQMUtwd0dmejMzWHlTNmo2OWRiZm5WZUkzUFlLVnVZ?=
 =?utf-8?B?OWRJaDRNSHZuOXprZzNSc0dEZHpJamhYUFYwNzlSQWFUSGJ6dVZPS0d6Sll5?=
 =?utf-8?B?WjhMdXFZYk5BUGlHQk00b3BJbks5Y0NzU2czbnRIN3ZTUkJ0MUg4Y2NlQ3ZJ?=
 =?utf-8?B?dXdnQ2NvNWtNUFk3OVprTTR2eWF3OFJ6WS9qdk5EWjl0RHJzak82aVZTM3Nn?=
 =?utf-8?B?YXg2L0VRdzYvY2RudnNKSVlGRmV6WFB3ZTZvVWJvOWJCMWx1ZG0vdjN0SitJ?=
 =?utf-8?B?UkFlRlhjTS8ranh1N2dneUJ5NDNKYXV4R3FuQ3FsVWtQbzJCaWdMWGtxdTRZ?=
 =?utf-8?B?TnBkdDRtVlg4eXIxR3UyRUFNWjVQUEd0dWZFUUVKRE8xcGRQbDd6YlRhL1lq?=
 =?utf-8?B?VXFJVWtPWUN5c3IzTXdPTHo3RThDR0RiV21QckVESE9QU0h4RlpRQVdqQmJa?=
 =?utf-8?B?azhWWnRUNC9NMkpESE9FeWU0c1ViUllzaWwrRjBVaHpJT2xJKzBVSzNPTkRp?=
 =?utf-8?B?dlh3ZlFScmVxemhlSjlyZHRnejcrRHBZZ29tcXVhWHlvOFlVdHFmbDhyZWE2?=
 =?utf-8?B?WXNBZVJPUG5RdHlmQWZ1ZjcxbFlyTEZROExMb251bFdwNVM2Y0QwT1A2Ymo0?=
 =?utf-8?B?QnUzUmJaSFZ4RVUxS2VvbmxlNTFXTnBxVFZlaERQRlYxTE90M2ZwOWlXR0FF?=
 =?utf-8?B?OVJsalRtQ2ZvbmZUdytjVDN4Y3RXWXlNVHZhdVhwSFFLbXQ5cUtGV3BoQTNr?=
 =?utf-8?B?UWJCL2YzUit2ZHEyY3RpdnhkSWxIRW5tdlFrcEJ1NmtuY3E5RUF5a0djMGVD?=
 =?utf-8?B?Y29Dd01UczdrcGlqZjF2Z3d0Nm5jd0tIVTFRZ2t2SXhwOUIwR29XZ1I4WFhj?=
 =?utf-8?B?bW5kNTJDUDJPcWpUTjZZWVdsQW5CWUppeU41WCtvS0lyTW1ZSHFZT0dsUDFH?=
 =?utf-8?B?Ym45V0JqV0tncVFIVjVpenUrMnlvQmg2bG92Ym1SQ2d0djZmWHJ5TDcyUDF5?=
 =?utf-8?B?WDhGNGV0Mk01M2pLSWU5akVCV3JwK1gzVXpTU3c0aVhaT1dlNXVlTHRITU9o?=
 =?utf-8?B?azZLOGtGcGZQbExPdnpVNHB6M051NXZybUEraXBQV2NqYVp6RTZDQzNyT2ky?=
 =?utf-8?B?alQrUFFqTEw3b3RGMngvdHhlMW9IRHBON0puNlZraFBCSjhFeWxQM2paaFh4?=
 =?utf-8?B?NWFtbWVCdjZRNmFBSW1Qc0FHZ284djVCRy9XSWNnYUpLNE1ORWkxTXd0ZUl6?=
 =?utf-8?B?dVRKWTBDZmxlZGFQN2xOY285WUdzYXVGL0I0MlN1cmpTTk8yZkxJQ2x0aTRK?=
 =?utf-8?B?SWNhNlNFemNhWlNiVXY0YTFDUXk5SU1DMk5wVGd1MjNGbk9ob0xSTWk5RXhm?=
 =?utf-8?B?a2FsV2RRREFtK1pBT2lkYjlrZ1BCZXZyazVpVTN6VXU4MUMybmRkOTdQN0Vy?=
 =?utf-8?B?eDFDR0x4MzU4aGhmdnhNSTZYdlEvTVYyNUZVMU54blFrK09NRytCcUlhM3dO?=
 =?utf-8?B?dGZBdTE1WjhqcjdJUDFXdEdSRENKc3FNY0NSVXNvbnZsYWY5VDNhdi96eURP?=
 =?utf-8?B?bDMxaytMV1dDMThTUlVHQVF4djhreUVNdHl3YTJxanNmSnhiL3k4a0dGSGJn?=
 =?utf-8?B?cFNmUC9uTWRwMXUrMy9HZ1FDWFVaVUhscElhZUY4bzh1RVpsQmFqSEx1ZHBB?=
 =?utf-8?B?bWRzOG1HSTUxblJoWXJ4bEZmc2xsSHpMWEVHUmxIRjNSWTFTWDkwQUNJZ1RV?=
 =?utf-8?B?VkdvNlRGRDk2Z1I1bjRqNElXVWZxc3dmWE4xdE10K2k2WEFMU3RjSEJZek9m?=
 =?utf-8?Q?/CYLI7m4lid0VE56iaHOAEk9wr6m9IjZQlRN3kG4yLcse?=
X-MS-Exchange-AntiSpam-MessageData-1: aiOZuZQIVxPWlo+mLvTA3O171n5DlH8mLIc=
X-Exchange-RoutingPolicyChecked:
	brHnBslGOMZzbJW7+9AOpiYBluXs2IMlhHgAC8IzOfQX7a/rTH32YqtnVGAZjtG2liinsmWYGl7vHIRnNydDzgE3a8jdi3IJ2gmk/jCt930tvmKnI71LXfGEBePgzg3daeO+PjhmHf7TW0CdLb+AVXikOOyocMw4KUm4i7hfuVcMDNyjp+hsvHq5Zw89bbpSMHyy5vQmdMimWMSQhkSdJGOnI3sDBF/CtFNwfpcbCgSYxJ3zN2kXngzvKNK7a9eHnCwuw7GIinKlXG3kI6je4mnRLclumRXgjxZ3Pn+GAC7qGuipH/QpjelQ3svYP0FZ+E4HFNDJGzC05+xQMcL6sg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j+2QktImdmknnlOjA3XpX4x3/ptyGS00uQcHUR9+fKlFSwZR0y9zVM11gcLMdWEKc20/Q4sAVEBALT3jzfbglkX3A6GbO8v0jFMm8VCMMWXTJUpeKzzMZprHcev1JX8g/p+nAEOmHxFIDy6RuhrnYjkLmGLoTefXcXWvQyzF8ehKICmc9n/AFjOftksiLHy58Q10Jvr1WNxcCGKqaSWai1TssL9x+s8mJ9yoAuxB6mjIrxn2QqwGXOe7MM7WSVLoXy9anoAIoVDDhV+ReiGyMfUOmwG4gudoWun+3bBcaQ43UEhqso0AIlb8+bLTBUyGTm+C6Pz+A1YvRxWB5mNBymKjUYBCiSbvpMQgMxaE6AormKrBXe6hs0grDNHOSAMXRb71JZ1N32botgh+2sGmwqdOnkTEs/fk7mLtrTZbhXAmvfiMHYtpvNIguIQppmRGP9b+gp9o3j387k6sCyb74e3hWKc1oaLgJkdSu62m320c02xiJdDaHP5lLwSA3OBi6VRfR3i4aV1uvO9s5HaU7bVaD5RL1DgOBdMx+AzLNPTa/SAL9RllZWlqMzc4Kacvug/6pmr5KDy4/YE+6y6tvIk7joS49OkNO0o+9ivKHzhWH7wc1DvIHMcLvDC3THQb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e99656-516f-46ac-9266-08dee94a0e51
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 06:09:01.2824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTtlrIC8PVLwz2jfTb3fl096Xqq2yCMMmGG04xeELwm9LOgXXltog0o+fIUpqc2EgSoGB4+ayjcAhgDjsE0zzvKvM25AZEHc7DWx0CstLXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6479

On 7/24/26 6:47 AM, Qu Wenruo wrote:
> +	/* Try to reuse the existing OE from bbio first. */
> +	if (bio_ctrl->bbio && bio_ctrl->bbio->ordered &&
> +	    filepos >= bio_ctrl->bbio->ordered->file_offset &&
> +	    filepos < bio_ctrl->bbio->ordered->file_offset +
> +		      bio_ctrl->bbio->ordered->num_bytes) {

Nit: in_range()?

