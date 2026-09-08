Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7BF3AB289
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788854318; cv=fail; b=dDHoyUk/6SFOwkQYS3cB/CVdsQbzfSOyNv1hSZ8vGQnrP5A7Rfk4hvP2bQ7MbPMEt/zbde1fOL50JQJKVjTopoSKzsT/EPaYdxSRMBDzZDQ9gzpbC050kTU1eNDaFcSW0I7YG8w2G3ImLUMqCeysPigc0kEGgDfBik65QilMpjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788854318; c=relaxed/simple;
	bh=vcOswGBr5o4Lmk5GJ9D/hS6OIvKmNXPsjvVJNyQaUYM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IF4AbCQTiw2qdtMueRHrvQ00LaqDGyYF4f/LVpRF2pWQnUGNxksVViaZ9oPFkngH1uwFD1hNW0nJ6QcfgrdvbuBTG7+OqZ60zyyGcvV67ieaTo6e/Wug4zDfNHFwBiJB4V0qqDZO6UtANHnaeJK9gpdNdQScEUkDfei04ojga/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LeYl98K+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jASuHgys; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LeYl98K+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jASuHgys"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788854316; x=1820390316;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=vcOswGBr5o4Lmk5GJ9D/hS6OIvKmNXPsjvVJNyQaUYM=;
  b=LeYl98K+MdoBMQrVaTlYh9FrWSE4ZMB41yY5mc1pAdXIzEfK72Hoc0IP
   TXu14ZyF7a4zUIK+z1tAwTrQtDAVR6aTY9GtrIau2VgfvSM93kvOwx5pm
   r44MBTgj1Lz0C5ItBpMjiBNFF6z/6czXf0RU8kGLI4zRDHHC5fOIB4rps
   9rk5YFvKVzAQ8JtTvxlvezJ0ZjZPYuQHCJ/lzQ/GGCxPKNIKxID0aDA4y
   ZBdyyjsO+dco+oUJ7BKqTlYTaqMbj9lfuw3WFmIFFsPsMqQsgkCHRFVkg
   B6CKcFMUQoUjbDYX6MwxfYORfpowl0jFAI7Oy/oR01ZqqqRTj+51J7KY3
   Q==;
X-CSE-ConnectionGUID: hDlIdMyyQWCKtwXEmILDZw==
X-CSE-MsgGUID: KqsJ/zeDRsG7tzKnMEPbbQ==
X-IronPort-AV: E=Sophos;i="6.25,268,1779120000"; 
   d="scan'208";a="153594131"
Received: from mail-southcentralusazon11012058.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 15:58:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvp0kKb5ZvI2R60ezmPmjzQnq1+yNBBz1m/uWx2N5odkDozAsbMbf4ldmnNpVx0iMC72hjfgaoGJEklofX9kaPHiu5OhWaArj5B5hCqO+8nviUFco4BcN0BfyC+D5iURsljbiwmm/lsogLEyh9ejxxKsofyzbuMVbA+WhlurLeEVkzvlzz0l5IVnCwnx7unHk6H3Jevqx1O+Ur+ogMhkKJaa+HhYx4TRzQgio2jPNu1NBva8KGU8tw1DqEqBOn6HrpvScL9dPYTm+5FEduVlS4KMkECovXJvgkx7PqM6XbKzJgvyzyBw/Ls8PW6DCltqebxaWggao0Th7eDN9p1Ugw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UppY24SZiEt60h+TaK6UdcH+861S1e1zZEMwpxnZugw=;
 b=TcD79rztSllBpIa4pvO6PRJJIp7d852e5HSmFpBNSOKShxd4Fq9NSMXvCkhvtcSSD7Ta0EBdw+XGz43E+72mrSlboOOjrLV0p1sjFq6g/8+3lm2it8gKnAsKFlijxvKVZHT/bNJLrI00bMTIM4JJyKlIGXQXo1q8yB4VTFlj2FrOJtWHCI5iIVCnzyf8Kz0D9xWSgBtHbIogE4c6GqnHOf+XT/q8g2P4pZWFYhMOYER1t142YkUJzOyWw05Y96VWiI814apYgWDq7J8ySpA9nmsWTDLl3wgifRRQEhS3LFCBdk4bwZW3MU5x0Wm2X7LMrgkpfu+8UJXozM4YsXU4Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UppY24SZiEt60h+TaK6UdcH+861S1e1zZEMwpxnZugw=;
 b=jASuHgysqhv5WLU1H7tiTzBBxbRMDRz/tMBiQu20t52v7zbZDVXrhlSv9fSl4edlT6jyPSPlXbuyt3hVOX4UTDvj3g5VNjGtEl2iIjhZQY0OJ86SHtlLnboWrTn196AvttQkAcfREXVeGNSyQ8a9/PbFnEK4HKfthpxWdhmtBfI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA1PR04MB9042.namprd04.prod.outlook.com (2603:10b6:806:388::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 07:58:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 07:58:33 +0000
Message-ID: <d4041f87-58a9-4b3d-9f08-e069de350e1b@wdc.com>
Date: Tue, 8 Sep 2026 09:58:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] btrfs: use kvmalloc() for allocations that can be
 larger than page size
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1788851649.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1788851649.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA1PR04MB9042:EE_
X-MS-Office365-Filtering-Correlation-Id: eda6b5a3-c069-43ca-b035-08df0d7efaed
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|376014|1800799024|366016|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
 hFOzkMs69l7V4af0TDi81a/EBXWzNo1zK1AzUf27mSF9HWQxq+5jG/anRNn4YPe0Nel/DobeOekTcGuGwM756G7Wb2v6FpjrbUTYyJ2O/fwVNi2GxjSta3MMVyQVixfnADwyC5jQkCQN896UPEyEK9ZCJtFWc7mUBe2/yWrwZJCEOyKdKirWzByCqM8tCeF8MzHQsGPLabJBX54Pg9VovyfHfZV6R2whqs2Uik0tuE4ISb5QfbmrSyOwTW0mS5K6FW7vtBa+w/UUhRljRcY1/btvPV+kir4TFDXbirebzAi303Bl0XRgOFauz3FFsRO27qfURappPffA+KiJbpALIBkbF5e802ZBwlxgU1ppAZicQhtS4Q9C9dFqEd74+JjQquJYjLNzT9CJdQtUMsg+5etORIesqRjyTtKaDCO4Uf0bcQtR2Vfqjb1KAEtc6MdYnToS7rPWUlkhL81OQW+W2vEwrbuTTO/inho2dzRZVGPEHXXotFnsuGUitRMA3Bi4fPzbrXpwxMMLHR1/iIn9JLcucjfYOrlOmCTJRC4soszGQB0jzYVimHACutzxalfxZnhbq3J/2EalVcKTVSMqpDq+anHGw6Vji2dyq9Nvtjrofdx6dZf2skImHD3RHrE5RfXr2so0/q08r8e7Md/tCh0v1iX3XwkqN6N3j/xu7N4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WjR6UGYvcU80WTdlSFFPVnIzV0NhbHc3Zy9wQVFUU0JDWWZkRmdNT3NQYXJU?=
 =?utf-8?B?cENuSlJDZVR1Y2Q0WTlMaWJYRlNIOEI1aWhkSlJ1WGdlV0tlV2dVeDR0MnpH?=
 =?utf-8?B?QUt5RWJyWkhsaVowbkRyTS9JeFhOUHppRmxPZmJ4WGVxSlVjRHNCanZSOFdv?=
 =?utf-8?B?QlJ2ZWV1QVR4Yi81RHhUdHY1WHZSRnlEd3l2eGcvd0IwYWFiMDFZcHR0Mkl6?=
 =?utf-8?B?cWM5RmNaWmJnSDU1amVLT1dlOHFmT3pWaUFtS01jN0h5KzRCTUdqUE9BM0VT?=
 =?utf-8?B?dXJ5QkNFVVQxUlkyclVvbVVKS1NzQlBsWk05R0paT044TlY3UE5NM1AwYXY0?=
 =?utf-8?B?ZzcwYXNzbU4yOFUxdHN2aERNTlNRYU5YMlVXTjBjNEE0SlJGZVZpSFpLaUdK?=
 =?utf-8?B?SHp2OHBNV3lmMytRTnNEUm9RMUtZUE1hZUZEUVhhSWtFVW5ITlVXallJRlov?=
 =?utf-8?B?NlF5MVd6Qmt3RFlGWVZYdTVFSlRGWS9lek8zcTIvcnVXL2NGNU1TNFdOS0pL?=
 =?utf-8?B?Y3ZVb05MQ3NuZjBEcEFXOWtCSVk3cFJFR0VlODRuRlovM0poWVNtNGJ1Ulhu?=
 =?utf-8?B?c01qZmhSSkFsN05lbGxZMS92SnNpQVJSOW8yQlJ0ZDFrNjVmVzJSaTAyMTlF?=
 =?utf-8?B?dWVrTDNGTTJHUG95ZjVZMi85dDJ4djF0aTRNRkEwbHZUeStVOHMwUklhTkYr?=
 =?utf-8?B?YkMwL3l0Q3hDYVFTNE9GNjRBdmsyazloMlVKeGYva2RiZVdzalAzQkxOcklJ?=
 =?utf-8?B?ZHN3RXZBUDN6UkF5Rk5MeTRueE14MXRkamlnYzg2Q1BpR1IyZ3ZtV0NxRk0v?=
 =?utf-8?B?QVR3VE1EcGhYM1F1QjZyNWlrTE9LRHJBVGk4ZlAzWHd5Y2RVaEVOQnNVV1RU?=
 =?utf-8?B?blZaWWJodWxOS1ptd2xQdzloZUxlaStnOWNHeGtmUDRtYlFoR05qRmJwN0NW?=
 =?utf-8?B?cWhJRzV6bzNFcUE4L0RDdjR0QkRjcTBBVHA4d1huVlJTNVlpOHUvcGpCQlNn?=
 =?utf-8?B?c0UwQWhzU2tXK2dQSHJTK1N1Z2JFbDlRaWxqOEl4eS9WYTh1SER2TlZ2KzRN?=
 =?utf-8?B?MmdKVklWUUU4a2Y4VG9McXRqOXpGZTRpY3lyMjk0N2lhUk1kMFpYKzlsallY?=
 =?utf-8?B?Qkdudm8rbEtZaitMOWV2bytSQWl2NWR2U2tEeVQyeUk3UHJTeVU2VmxDaTJQ?=
 =?utf-8?B?M2k5eFh0Z08vdHJKdXNwQUVMY1hITFBldkFzenhDdmxyUEVSSkdJZC9nL1dk?=
 =?utf-8?B?VktpbklDZ0cwQ2E0TDFreFlGbkd4N2ZpUHY4UEVSMWcrWDIvd2JmRWdXUzJU?=
 =?utf-8?B?MDE3N2FaN3Y0Um9kRFdra3h1ejArWDlxK1RHZGIvNEcrQXM1NUVpT1hMRG83?=
 =?utf-8?B?TldLSUcyWk96a2xiNVJNVTJtSCtrK01NTXBRalNQRXFMNG1DYWNpZnRKMWhC?=
 =?utf-8?B?bWJBZzlySmNIUS9XQURjRHNRaGJGT1JYeDMwSFl0cFNzcHcvUlJmaW1PQTZq?=
 =?utf-8?B?SzBBaTIzbkhNY3dDeitrZGEwNDBpMTJZdHF0djlCMlJNamVWdStDWWt2OGdm?=
 =?utf-8?B?elpmSzNIYkduNTJtOWNvRk1SeVVWRHdLd2UxWEpwOXJrTEtyMTJ3bFhpajVl?=
 =?utf-8?B?WlcyUmVDM0k3VXhlbGd6VjRlYWZUS2ZXVFNLcnBjMXV1NDRXQytLWmo4VWpw?=
 =?utf-8?B?bWlmdE1LdlArR05pbEY2Qy9sTGNMc0RuVno0WkFWckdEVEJCcG1od1NCOTlP?=
 =?utf-8?B?VGdPR1RKUGcxOWxBU0FtMWt0MXlZWldJNFN2aGJEZ0RXNUVQK3pqTzIybFpC?=
 =?utf-8?B?WEdlOC9RN0E5V0JHMVhTU0RZNDBkVnZkSTV6L3hxRm51QW01WnJreGZma2tM?=
 =?utf-8?B?T3I1MjhmYzNRMmczMXFPUGNiWk1DQjRBaXBFYzNXTTBtaUd5QmlWSXMrYVZY?=
 =?utf-8?B?VThMcGpWWDljeFNUbmcvaE55REJwY3IvSHNKeHR3WVg5SG9MNk5NVlZNTThu?=
 =?utf-8?B?QzlHU2d0QjQxeVliRjZkT3pxRDFiUTlCU3JmUkNaY1piMDFuR3hUa3pmSjZW?=
 =?utf-8?B?L3BmazBrOXBuS2xlYk9USmxZckx6R0hzOWhNcWdta1cybHVTRDk1eU1SQlFJ?=
 =?utf-8?B?YXo2OEFQU0YyMjV4QXg0eEFTYWgxOElQMVZYWmg0V1hoeElxSWtZOUF1NGw3?=
 =?utf-8?B?RVhzWmhwVnZqbG9BeVNjL2N3OG9BQXhyRGRQWEZSdFVMYTFoVVR4Tm5QQUVM?=
 =?utf-8?B?aU9OdnQ0bGtITUhXTWcyNldvOFpuUTFSSmxlQk1pTU1zVi91OFJSZ2xVandm?=
 =?utf-8?B?STFlRWlXcmwwT21DZjR1Nlh2SGZKcWV1amF0bEk5WW1zVkFNRll2aXNDNVNH?=
 =?utf-8?Q?SasnfgbJbigApLpw=3D?=
X-Exchange-RoutingPolicyChecked:
	QsaV9DGJty/Oxg9riuj0aOVX7KPmA2bU+Ce2tVGrhBh9VP6KTLmC/HvY81XIwTse/5/0ZrW5AqtboxWPXL2kvN+/+G1xn0eFLH45EBj1H+HHWUmy7FEUZ4zygmp7Rgi2hNwjNPHod5sNNzovTs3+yMRifofe2+lLiH6rwZES4x8ocBZ19YBEPg/IKd3gexI+MCi+nzRuJlQbLF8dSG/azr5gXJf+d1oBA6D6sHWy9okmE0JC3jmUBjI94QRslw7jCDFr5cvafjb30o5hX8RpIs2DBGc+g1Pag44yggxp73sIMxO0vVS58eUMTDFDWxxVpEEhwPpE0SZfiJNf772jzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sIK6Az7dpVDKq6KA0WcGWXMxuXXzt/gdXw/XQhx7k3GOAHHjFE4jzTQ3nwH9sbaGrOReMIGhv8LWnH272Qx8HJvSzV0Zdk2QcZO3t8L//zMJOJhLYUoPinMJlQ7M/lQjyxc6++NRd5IVsE/K7HK6xqNyhjauEX17+XB0wOSozWf74tvh7zIMRw0/bQTRum3QdNfilwHMeGu8kO2K3CR+ENb7HPOYky9LCf8xwZulostkUXedjsU6+fh1DdHTXWJQlKHsxpD+UJkZ4Z2So1p0xYtNo6rCeV+QIzETwvOHA7pgHBoRuzGk6OF5niuuGax9t9HDmvZagcPcKSUVwNWOm61QbmSmN4IH3cvouGPNDoNVeBYTfK3PjUK3qnv8HnXKiYdwSmXrktUsj3Q1B/mcJFqGfsoJbPCs8xpXLgkJrmfponXvcom7+MH4Z1gWhODqvo21qCDsLwq+flkgUplskD23kY+gS/JYeGGK/V2z9rIxes0xKxvLRyr+PScL9b6ExgAe1rVyLU2sGyCywcTThTl6QyNSZIe5Gy+rVzsTE+2EVo0Oy9MdjPKA7F/y5FCQRZTJ2ojnDHCkU+75ie4jQ/EY4VTPH0zQ3OyhO9/Tz9KLDTfKFmlwcROh8+BDZB/2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda6b5a3-c069-43ca-b035-08df0d7efaed
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 07:58:33.8553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVhVKYhZvEjdyyWltmvQyCmC3NK5uovmU9eg2+qW4lRHQpgvynrgrApxa4KomMgbvUTvLLmDXOWmlgucCoNwUUW5VgQO9fqz5UO5rPuRyDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB9042

On 9/8/26 9:15 AM, Qu Wenruo wrote:
> With the experimental bs > ps support, btrfs can hit several kmalloc()
> call sites requesting physically contiguous memory that are larger
> than a page, sometimes such allocation can be as large as 64K.
>
> This means those kmalloc() has a much higher chance to fail if the
> system's available memory is very fragmented on 4K page sized systems.
>
> And there is already a report that with 64K nodesize, even bs == ps we
> can still hit such kmalloc() failure.
> (https://lore.kernel.org/linux-btrfs/250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com/)
>
> But we do not really require any physically contiguous memory for a lot
> of kmalloc() call sites, we just want a buffer to save some data
> temporarily.
>
> So change those possible larger than page size kmalloc() to kvmalloc()
> to reduce the chance of memory allocation failure.
>
> And since kvmalloc() falls back to kmalloc() if the allocation is not
> larger than a page, it means for most cases it's still calling
> kmalloc(), not affecting the most common cases anyway.
>
> The first patch is a special case that affects the existing bs == ps
> cases already.
> The second one only affects bs > ps cases.
> The third one mostly affects bs > ps cases, but can still improve S390's
> hardware accelerated path with 4K page size.
>
> Qu Wenruo (3):
>    btrfs: use kvmalloc() for overwrite_item()
>    btrfs: use kvmalloc() for uncompress_inline()
>    btrfs: use kvmalloc() to allocate compression workspace buffer
>
>   fs/btrfs/inode.c    |  4 ++--
>   fs/btrfs/tree-log.c |  4 ++--
>   fs/btrfs/zlib.c     | 10 +++++-----
>   fs/btrfs/zstd.c     |  4 ++--
>   4 files changed, 11 insertions(+), 11 deletions(-)
>
For the series,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

