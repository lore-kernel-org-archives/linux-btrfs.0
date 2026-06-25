Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE15332EC1
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 14:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782397634; cv=fail; b=WCBlmNw6Yf0pVPf15oe5Cn8Qsd9yHWx/AAPYZ51CjMu3s8yIDZmu7aRv2i0VwRwQfIycwwbtZJugxXWR1Uv9vYo+/vjVvsG3vrX/wtPDM8l4pxL226MctPngvdwN6MBrTa03PXqDh22x+K1ycc3bbv0zzPX79bISlW8iTDRzLyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782397634; c=relaxed/simple;
	bh=cxtnuhh3Gbbwm8HxhLnpCrG7x9StVWA3e+1mdlaGjrM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bHsZ23AAjqc6ZWNYjJHYNNQsVUbbj5maSa+szVyabaKedMY8LHtemRjH66/HbDR+mRFdo03fLFFqqf2WSBYqRRDHhCPCRc5XzczbusBMIhED13d5L1MDEXoGIOdLjKgSKPVo3uuSRZriuqfSJ/PKG8JHLRQR6IBPkmAvpOd2hR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ElktdbkK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HXtc2Eeq; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ElktdbkK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HXtc2Eeq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782397630; x=1813933630;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=cxtnuhh3Gbbwm8HxhLnpCrG7x9StVWA3e+1mdlaGjrM=;
  b=ElktdbkKDA32qb1xfnZS/paNRL9oj7mzfl77f82ZhlDvgVk7zv1L2Ljj
   /l3uA1ZTj18n32ipZjWHvjn/8lg1JWsogJW+bxw8SA0h+7Z0Wc2I8yreH
   nTrFzO0g3kBO+/WAjGV+3UdLMz3U0mIQivIFt33ApDQMuV3YU+snJunQz
   WDxGkR46sM7rRiRZ4UQP0UOV/m6iPX7h2B9qRNYbw9TnSqjoak+Mroc2k
   rlq0kFp18dMu/j1uPaEfTv8uYf3qNAy/4TX9REKQ5EHApvmGHaR12uV1X
   qLj+prsbNTdYgDYjbjWie8SQc0t4ccrxYLA+dcRCpHyhtDVjz3+56mgRh
   w==;
X-CSE-ConnectionGUID: NBBmQB62SMGV/m35x5Gr+w==
X-CSE-MsgGUID: cPzJKvd9SJOC5lkI/u+m6A==
X-IronPort-AV: E=Sophos;i="6.24,224,1774281600"; 
   d="scan'208";a="150720078"
Received: from mail-northcentralusazon11012048.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.48])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jun 2026 22:27:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hNsOQWOYKgE7F/LAW0qEjujbYU9H7QUQ60PNlEs9ysjIB1G/xcq+PwRpkps0TUSstMzCorOsboKvxfXekE2DXkeRgxqv+e2WxWZ8eDzAAGmYPVLTXuIeU00aLOGOqp0opVXf/QsOgQ5kUFXDOdNySf7RrXdqaR5vhTJgVSTir11BYVYTaOuBauh7JYBmJaNWc71RVhAynu0MJYUv64Dx3ZkQ+1EIX52abH0tCbyX/hkeHkgmCNjnT9VhQ3D0FQrPpM9VNX17Zy4rsGtUGpSKKbhjGXEpClF7SoWCpS4ayfOMhrDNK3rDXMiEviBkMrvt9ganYMGkoDxjTbuciemMYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9koJWcox9JaxnpRVIoLvCoWydxn7igNI7hZ8ldepCQ=;
 b=hikyymGI0qIUwadCj365B14V4FsRJvgGrKhXXkgcbVocMiTjmAHHDKufXHGcCjjUwVK7i0sPoeJ+bF6FP7AVpF+X3wgcH7h2Hti8+CGu+hVNzElJxApgzjLXTwV7zSfVxdKWhbzKfQExpa3Eti6/CyBk00I/SNNw4XTt+kl5otDYRExSLGT/5dh1wC3bF1T9mIOFgd4J6jTuK/KgrMV4BY3MwzQdvYY7QkdYH9tlvSxcfihjokBWh2G2P129TtnMAalpY/QK0VkWeJ8awCHT7Ys5hRECry68nI493VdctBgiNTojGGr7b0khhsuC5cxNxcs/QXVIIEAlYEvjrIwusQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9koJWcox9JaxnpRVIoLvCoWydxn7igNI7hZ8ldepCQ=;
 b=HXtc2EeqQ+TX+Oi8uthNoOEYhQnx3o0nLvjtoQfbM+YxuQQXYFWe+TeXbwUzRzHwnNKbvviIpKV1E+eeGW0sqX3lRR/VF9MxpyUDjNcoHx3+IEero/7Aws3x5ZEe/TxDWiXQ13A5Cx603YrE8+uFRlpF/rOtvBCIVNjyAUFRgew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB8167.namprd04.prod.outlook.com (2603:10b6:8:2::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.17; Thu, 25 Jun 2026 14:27:00 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0159.014; Thu, 25 Jun 2026
 14:27:00 +0000
Message-ID: <44af21bb-507a-42af-a908-66fa67c2a273@wdc.com>
Date: Thu, 25 Jun 2026 16:26:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] btrfs: factor init_extent_buffer from
 __alloc_extent_buffer
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <cover.1782249000.git.boris@bur.io>
 <420436ec8cb5db154adfd65cfd5fb350b380a4ec.1782249000.git.boris@bur.io>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <420436ec8cb5db154adfd65cfd5fb350b380a4ec.1782249000.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: 84a6652c-d450-4c6f-c115-08ded2c5d1c0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|19092799006|10070799003|23010399003|376014|11063799006|4143699003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lQ0V/5KYy9oMnno3ZhJ3zOZAiwXT9ce2/8Uv13XZPvOHvQYFT03biwDEDWRhaAsTPTadMeuh4xCZmjFQ9Q0/MTw/pa3uB5ztfg3EOx1TIDS6hYSV2gR6635HiX+CQBDPCd3M4JcCliXS9jzgoyU++tn+y6x8R0bCuJISSfoUPujYIHs7Qa45MUfsIOwwK8JCt8jc2hIiFNX7mZfnire8oZ9oJGx2WLTbSt/H2fV9wJxh/RIm9q8TjlKdS5cmkyr4EMU//quDNzF6R5CdrjfVvEfAHz0o4qA8oPIKHNuKGEhL+TsRtnT5AsFfUht7g93+dilxDy7JmHpofoiDVlcTaOMNDfTzIPyO+9I7BBkiuYDUGXsXd8ACngrwXKQMXQzw80k1jpNkZ/WYysjVIUsEcB07IPHrKvTsw/c6LK9DFcKX0w4WcjKn2SIYsbWLj1/jAOZQpoFGb1pv2WVLnXpSG8wvZjJe8QvS0khJ8clLbwDBgUIycOB+GVn+WzUwsZyCqyOy5wsQsGBZKM6ldLrZ7HUzLaMpaIFS1+kknmKKMHSo4DvpHhibv/WgY3UfzEIK6+gtiUB5oERSB3cwHP5dtXeRA5WP//QGcatQAh9ybe68xoBsLc3NHAD458FSrz041zOOuMOuojYipxtUYDKXcwXbah3CY8ZsagZciptILf4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(10070799003)(23010399003)(376014)(11063799006)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yy9OWncrcmZZWXREeVhVSis5bFlJeDM2U0FXUDdIVVlHRzRZV2RiRFhSM3cr?=
 =?utf-8?B?SmU1VWhtcXFzYThhWXlsVHFxLzF3ayt3YTRuaGo4U1hoWnNDZWhtaDQ4OWMx?=
 =?utf-8?B?VzJBY2x4c1c0ZENGd2o4MU93b2UyQitNT0dpMTBKYXBpNFNQa01leTRSNGxo?=
 =?utf-8?B?enBUVFAyc2hRNnlCcnFZNDJmVERucUlsSElDZlFMbUkrY3pINkdRV3pub29x?=
 =?utf-8?B?WEJkQUxvZWRqc2NzRVZxR1dDMFl6bEhnR1ljU3JjTU1CN1RRUk1lYTY5d2hp?=
 =?utf-8?B?RkhIYkphK0wxd1ZzTGRkZlJsY0NpU1R0eURMcU91eDRyY0FDbUlROWt1cUQy?=
 =?utf-8?B?d1dmaUhEVUozcStJVi9DUnZicTlrSFpPTU94Y01Pa0hodzJwMzhZOCtXbVFK?=
 =?utf-8?B?L3RnMGdWY3dWZnNxNG9GM1RzUWdJZHk4VVR4Z2dIM1dNVHlWZXBvc2ZwK0tr?=
 =?utf-8?B?c0hieHlTbDNweDRqUzFnaHViSE1VWDEzdHErTCtlZmZ3MDJtSmttUEFxMEVL?=
 =?utf-8?B?U1VXeHUxcTdWcy93RGtGcGFEdDZTQ3BQTmVJcFVXV1pPcnFNcW1EVlJuTVkz?=
 =?utf-8?B?dG8zSEZ4cmcwR0VobWNhN0JKVUQxREJhMXg1WEpTMG41WnR0OVYwS1FYcis2?=
 =?utf-8?B?eTV5TjZ2a3BPTENUckVCYkVhNVdybWxwSGNpOUppTW4xeFAzNHNHYUViUFlM?=
 =?utf-8?B?QjgyN01lSk5Td2NuQ051RnAxVHdTYXZLMUZEMCtTR3JEckZWWjRyQ09RME1v?=
 =?utf-8?B?SlNJLy9mN1JXblhsbXZBWURtckkyYkJhMS9LaW1xQzFRWkg3YWxqWUdOekZE?=
 =?utf-8?B?STJtU3BqLzNtT1QvMXR4N0JzUHBpNmVyVjJJTU55cnY2L3kwWk1yNHV0eGtt?=
 =?utf-8?B?SnNBRkViSDdMSTFmVmwwN1hWS3JGTWl1NHo5UFR6YWFmKzdzeDVyYjRFSUpW?=
 =?utf-8?B?bjlFRWtYSWtuWGM2Vm82NWhPUDcrZzh0Si9WdGN4ZE83cDFGV1o4M09Sb0Nu?=
 =?utf-8?B?R1FxVWxXcEp4dlRlREEyVHgrNlBYVDhwb3JETFc2NkFmb0RrWXBGaVZMZG9u?=
 =?utf-8?B?Q2YzRUE4S0ZsZGpZMFA3MG1ZOTlXQmc4VFdTRlJDV2R6YjBKbEEvTjU5WXNl?=
 =?utf-8?B?MkM3Z2VWdllTM29xRnlGS1JKM2JyU3gxMDJBcFJhMmhIdjhWMU05cGtYYm05?=
 =?utf-8?B?Ly9FQ1JlODhmMzNYbXBzMHNNTTEwOG9jWGxGTklRMDNVSmJLRk1NTHFNVzA2?=
 =?utf-8?B?RjhRcnpQTUZRbjE2dlR5SVJqN1FyZlAzR3NKZU5vUU5ja0NKTEFFNGtDQzg5?=
 =?utf-8?B?MDV0Q3hJQWNMWTFSdVlPWllaVHdVVTlsRm4vczhleUNEY29md1lub1ZhdDNT?=
 =?utf-8?B?ak91dUxtTENTWHowV0M5dmxobTc2dkdEekYwSDJVTzFoUktlSkNrci82Q3RC?=
 =?utf-8?B?V3BDTHNHa2pwdm4zQThidUJQR1d2S05HMndpeEhhcEpoRDZtY1RSOW9TVTJW?=
 =?utf-8?B?NTVvNFVjVnRNekFvWmdscjBwaThiVFRDMHIrUXpEblR1a2xyMDhCb1JDajh3?=
 =?utf-8?B?Ym5LZ3RYUzc1c3QzQVdjeTY1WkRmV041VWtrRUs0YXNBY2hkVUIveTc5MGxU?=
 =?utf-8?B?M1BwNVJkeDBEUFh2b3RuOXVlQW9RRHFidzVUSW8wM21MZnlDYXV4WHd4cW1H?=
 =?utf-8?B?SVRDZUEwWkxyKzBPQWNLOXlmNnhTR2lCS29BaU5LQnl1aEx6aHF3QXRSOFpS?=
 =?utf-8?B?M1VYbmJHOUgzdVRLdDFjMHVwUHEvOU4wRGhEVkFESU04S0ZKeTI3M1N4dmFY?=
 =?utf-8?B?ekVEMW5udDJIZ2hpbElzRzhQejFxczZFem9RREY3TzhTYVdPY2plckQrbnV6?=
 =?utf-8?B?a1FVcUcvU0VtL2I0M093K01VWjlSNzlhSjVLQTI1ZEFzdFZDVXFrR1JYMmNQ?=
 =?utf-8?B?cy9xVUVMRSsvbEpoWG1wYXRITHFxV1pVSWNraXBGYmo2TDZnUDltcTJDRG5u?=
 =?utf-8?B?bG4rNFdmQ3VIRzY5UEptRlpsUVNEY3JDM25JV0crK1B5M1Z0Mk5INUtlcWhN?=
 =?utf-8?B?TnM2WmRPSjM3Z2NtemlzTFZXTEdsM0dGUmo2YjIrYytrc1VlMlk3Vm9icW9q?=
 =?utf-8?B?cVBoWUFkeFJDTDZhUkl2UUY3azY1d0w1L2paMEc5NFpZdnpQU2RTWEQ5QmpQ?=
 =?utf-8?B?eXdQZFJLRkVTNkFYV3FlQTdhNk11SURCZ2RESXhKeWhETWJweWhDYTZ6SkdK?=
 =?utf-8?B?OFd0YTRSZEJ6ZUZTSHY5SEs4TFVFY05IVFRQQVZKRFBRb3dSakVCdkx1MTRJ?=
 =?utf-8?B?dVNvK0NwR0FvYXJaWGhPT3hNY0JLYS8waGwwY1NZU21xZ2VrbnkyVDlHM0g5?=
 =?utf-8?Q?iGVB7Q1zS5E/tpETd3DF0EMBsLmKzcnH3cUY9wa56Ibkv?=
X-MS-Exchange-AntiSpam-MessageData-1: Mp1zR063+9Q53A==
X-Exchange-RoutingPolicyChecked:
	gn93A7Ql9ut1SUkDQILLWXIXc2doRhE4w19AwTfeiouNSMED3gWLFKRRoBXndIo1e/qdwTY/xLXqEMuDdjWHpd50yDQkr1Tlx7CYFAck7CaH0mlOVbmI+iTPSY2XXbEB4ac5wcVvEeSxHhsTQSS1oE7kwN7DnMYRapV+nMzVRQQTxnc70hZrEv97NLRCnNsap/b2rcmaH309JjP4t1UzPQED2V6quUAadsWDuHGqv2tGaDuYcQiRlgxsdwcAvJUSBYQmxY/utNeUDqDNGhQx/8X+H9CS2lr6ix1TcP0iaYprhh9CUbWwTRWzojLjedaBzWqMt0P1O3+kcv8LB+lpdw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LKCRlL+oFFqSVSJpOsexPCsKtqP1yWseP3u/4hgKnlylbhi6hrblLlGq0JbiaCkzoc5AhJ6rGNK6f0bxr8VbuquPBxMFB/gKzZEmKYs0mi3YogutwkkdHl2hPUjQfDN2oGl7v4rJr6K9CpckUceozggnnHpCzKuyh3h7uQHlBCI5zAH+bbVMqfyHfUAkLY8QMTmtWqpvvhP7DSLch2fRfIoivcWe512A1O+Be3JfLjmpXAFjh5Dw+8wQ6bPrZJzoRdCICh7nL0gIBAJ5bQidFNQ2o0UEVYsue8TX0iT87b7bwIsVeTqE+Ilv5FslurWSh5yOyoRBAbNwaGyyms+Lbvh6ire/blorta7OaL0ctR2DnBww1sXt6Gs5VEPMrRMn0P+++bvz86NjMIg8MDiazC5blhEhcqGNhU/RU5JPLJgTmX57RzBhDidKUV7Ohous+bxEXoYaRp2EiIV9Y65o6/wpyfkSsTmwOi9bhUv9obgmLyyazIjDFqQst76826rQJ5/C4wIzN7weGKLWSZ0lPY7Z/lv2QunCcOsOG/5IAILaaY3buDYulnPpx9+ZFP2Yy5z22T7eRwlF8J/7+gEKL5hhBiuZpVfNRqdCD8m0wJ6rPUl8hTxOuzAgZZwtflgm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a6652c-d450-4c6f-c115-08ded2c5d1c0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 14:27:00.4916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LlEQWQjaiy7zcefv2AbUJ+IIrXkv9mzZCcF/r4l4aFFRbajwJPxfIL86ag+GniniT1dib2hmtsccRYMt76DxNMUyTpv7eQ4QX857IFNVGiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8167

On 6/24/26 12:35 AM, Boris Burkov wrote:
> In preparation for preallocating extent_buffer data, factor eb
> initialization away from specifically allocating it. This allows us to
> allocate the eb, bfs, folios, etc. together in the main search_slot code
> paths, but still share initialization code with the dummy/test/clone
> allocation paths.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>   fs/btrfs/extent_io.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0edd532174fa..fa4cc8bcd1af 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3054,12 +3054,9 @@ void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
>   	xa_destroy(&trans->writeback_inhibited_ebs);
>   }
>   
> -static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> -						   u64 start)
> +static void init_extent_buffer(struct btrfs_fs_info *fs_info,
> +			       struct extent_buffer *eb, u64 start)
>   {
> -	struct extent_buffer *eb = NULL;
> -
> -	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
>   	eb->start = start;
>   	eb->len = fs_info->nodesize;
>   	eb->fs_info = fs_info;
> @@ -3072,7 +3069,15 @@ static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info
>   	refcount_set(&eb->refs, 1);
>   
>   	ASSERT(eb->len <= BTRFS_MAX_METADATA_BLOCKSIZE);
> +}
> +
> +static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> +						   u64 start)
> +{
> +	struct extent_buffer *eb;
>   
> +	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
> +	init_extent_buffer(fs_info, eb, start);
>   	return eb;
>   }
>   
> @@ -3476,9 +3481,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>   	if (eb)
>   		return eb;
>   
> -	eb = __alloc_extent_buffer(fs_info, start);
> -	if (!eb)
> -		return ERR_PTR(-ENOMEM);
> +	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
> +	init_extent_buffer(fs_info, eb, start);
>   
>   	/*
>   	 * The reloc trees are just snapshots, so we need them to appear to be

This looks wrong to me. Not the split out code, but how it is used in 
alloc_extent_buffer(). Either you keep calling __alloc_extent_buffer() 
in alloc_extent_buffer() OR don't call init_extent_buffer() in 
__alloc_extent_buffer(). I see this is an intermediate step (and I 
haven't looked at the rest of the series yet) but it looks wrong.

