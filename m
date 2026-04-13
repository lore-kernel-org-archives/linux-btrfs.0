Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18F33AC0FC
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 09:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776071527; cv=fail; b=NwJMMBYXivran2EBaV/AFUE1Wi2685oEJ0UH/6YS9sCzFaKrF8YuMOzOB49ybLRzQLZD4dctvyqc52UXGmhLBrQb+Wf4zG7pHnrqeXV0WZ7xHT4+quhI6/HQf2mtfYoBnoiedGumzLAF5mFNA9DyHFuITRdZlhh0dVxZUyKpC5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776071527; c=relaxed/simple;
	bh=RKrQH0s0EqH2cODKO/l5esD4XDU4qmMmh/3Bcke+gdI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k0mha9ZvwEviFv7Y1uaN4t8O5HBcZOAvx6HzggzZ1whSEP7A/BdOBxfFf1+cIiWLvYeR5BcRcYmMr1cJnMmpgl5RqE5VCLweDfLzctsdDDpqiRpBy6dB82mMGSrXjaa73xNS8AzLTc4hKxxRvrVXLNhIlaGj/v98wKM1yfDlPWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lvOmF2Yb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=c6RmP0A9; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lvOmF2Yb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="c6RmP0A9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776071525; x=1807607525;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=RKrQH0s0EqH2cODKO/l5esD4XDU4qmMmh/3Bcke+gdI=;
  b=lvOmF2Ybjp7zdWeb+IoZvyOwXx1J7e+DtWuBDTOVPStJnPe5Z63nsdFE
   Sl6rYoY+krQE2hiekoCFFBRlFh/Ge4p394X3+ryQEmrieOR/BEgiv8CWq
   bmsvcg9mq7QB9wh5afhlb2n7AvWwbOeFq1u8P11TmtYdHdq1nifawYQ3h
   Btl39HHmBV7PMNMvLKfnsRosRjbDECCtlxGPqCvJE/mkzDPyHGqgvwLKP
   xV6IBo9YdorXMHauC+cKCl+xYH6tUyonJ7UGZk9DI7fn/8YdbnE5cLcq2
   jSr7iv8/AaDRahAHVPmuExFTYqqaVZfhNBY9ak603Xsys+EPr4zj97V73
   A==;
X-CSE-ConnectionGUID: 1PuZcOyFREGi7ac2kJSAEw==
X-CSE-MsgGUID: 9soQ4vluSsSeLP/cQpyVXQ==
X-IronPort-AV: E=Sophos;i="6.23,176,1770566400"; 
   d="scan'208";a="144875503"
Received: from mail-southcentralusazon11013008.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 17:11:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiCHnkeyNunNZwyQbi9BmB1eKOy8lWwaAuQTmWmzRaYLLsdBAahW1LthPEUuDbeXq4DeqQ67ZDXbhWz9iqDsK8PAiWVH92zXg34h9XfKGKjEPf6MF4JahA0RlZmndGCAgSh5TPBAutPQ7yIs/mryYeFMz9ITaQg0i1sbQB3jyTIez4AqrfU4ccfz1i6SpyQWs6NhFpwvBdNoQSsN0lGdkzSkzbJNls6MK+F6tPb3NvWfqnoC5/FN2zmH54BTStVYraR/XVJzkQ8466gZrE8NtlNqqbt7NjdHlo7OGgGxl/HyM9zuT/sN7c/rvJcD4C7GnpjpFAEylZtevfXw0nYDIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8isUluk4TOZQj+DEKSTUuF+eLrK8j7lfiVsGJcK5Dn4=;
 b=cnqKqaYBNt932QW1ftLyLk8Nx/ezc/797WAt97TxZ5Gg7GAelTMve/k78x+dpBaE0EvfBa0LaFe3npTd2gzEeDkLSxO6KsUgA9HFnD2PrhHiQB6SMdiluxpl3FGKbJOSRyuczLYJIuWYax2mdUDeqvpxw7zOcCDkrSWMYt9Bl4wpjHFMeI5tNHuVQLIuUAIXaGTcZwhMbaDrmz86lcRuR7z/F4rWh+gyFZyX5lUnovGu6upuJbvctLvmd3fyDazuIDmtrCOWiCF3Kk9C36de7YCMc941BnwdZIcg0X8col0GsemhSMo3MdKx5jhR5I8GbTixkCYClOq/COopwnx7pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8isUluk4TOZQj+DEKSTUuF+eLrK8j7lfiVsGJcK5Dn4=;
 b=c6RmP0A9bY38xQqN4Xifdz6R/PZ67DL/IN3lJldEWhi5AtLRertLTCd/FbYJ2C2v/JNGXmsnGF5PZB99yeF2sEr0apEccFadKb6VvrPg1+34lSgbskYbKe6Y5Hy+zfc3p+peCaTkU9vOktovOEhiTjNFBZ2VI+7lafIYKwUX7Wk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by SA2PR04MB7499.namprd04.prod.outlook.com (2603:10b6:806:14f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 09:11:57 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 09:11:57 +0000
Message-ID: <1356d8b5-8708-414c-ad96-86a021fa216c@wdc.com>
Date: Mon, 13 Apr 2026 11:11:53 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] btrfs: fix multiple bugs in raid-stripe-tree deletion
 path
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <20260413065249.2320122-1-robbieko@synology.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260413065249.2320122-1-robbieko@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0282.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::7) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|SA2PR04MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: 906301c1-62c2-4b39-a8ba-08de993cb639
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|10070799003|11006099003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Q/yksD2EHLGeCVBhfas3f1H4OL1f6prcTLNB3Uy5U5U77hiUqy7iJUc8nuj3UVGVEN1Ey50MHzjmdaCMyEqM6CYD/TVWDerCUFE4lJpr+3az4X+1FpzF9Gu/PCroE0uz4JEGytd+XyzJa+pUPVVU/oVsDX6lsTWohFBThdFkz+X2qTfu7/RudcmhOEm3geWgMMKXV2A2ybF6UHbkhHGpjl0vdZgGZp7GGjjMAhLD57AECbR+lXXCcCTXU8Utq4zFEGyQ/UdMQ04ZJrtB1QFZKGh2DoejmIIswIgjlxrUdHzgP3I+ondRjbiIWdOK/D4qvJTlM9hsh6mzvI8s4ibGdT8udjy7Q2ND48+am8X/G9fYC7Z2SDDkNgkpud+pdr5GHahxi4ifutOJBCECJR3VZa2i6rXWwT41jrzTxB2l6O824R0eAuNpblp1hTnhg9k3DbQHqotiEm5P1lzGbVxpdfw5wK2F5+duOVSaPnltkvZjctP+qZ8fT0S/UKUc3PNB6GvPWWIjyc3MxKSzG5abpYtO9JnmB7TpdTWt1rM6UqYXlfsL1xDIu64kAS8+uLS6wH7/mJJTrHgGhRGQw4wLB2gUl5Lmj71uPgToAsSNFjJNA6Gwg9+Wv/9OanFA1DN+M071usprRVQpHF/qwc5pyLdDofC559G6O1BmBy2rLUl1sgPLoKThkP6joMAKHhBlJ3GVb7/YV99uBCaou0FQ/9ctkIu2Ij/KxwpRaA4+3K8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(10070799003)(11006099003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c21DWmFXL1lWRmVWMUxta0FTWHMrdDQ2b1NwbHB6bDAwaHhaOVByQ0lCdDdI?=
 =?utf-8?B?VVBhNDJtaGgzQmc2SWgySXBuc3JqTHUrdElqaldUM1kzK0QwdEJQUWUvWThD?=
 =?utf-8?B?dVVwZFYxbmdXSU1nclMvc3o1bjNYVVNyTFh0ckh1L3ptRjR3ckhNZ25ETWYr?=
 =?utf-8?B?cFU1ZVpqbmxSamdEV0xiNDVWaU56YU1HUmdiZ3F5TjhwcTB2cWRJTHlEdGhn?=
 =?utf-8?B?SkoxTUZ5NnIxRDA0a3ZITk8xdVoxRU1YdnorU05GaktoN3NkbjVlNUxFOEdM?=
 =?utf-8?B?ZHplVitHLytpeENTU1RtVXVEd3RhcnlzMk9rVWNKTTVYbktJU1BoZkxzT1RD?=
 =?utf-8?B?cUJjanNzcWZhVjBCYllNTURETWZwMHZjZWVnYmZWRVE1TUsvUk5scGpjNU9s?=
 =?utf-8?B?OUd6MExDU1pJQm0zMGEweFlkekNIbVVZc0crQktZQ1dyemc5OXJWOGc0bTFS?=
 =?utf-8?B?Z0RUTldteUdTTUJ5dXFGRUVYckhqdTRQUWtBVk5zUHE4UzAvVnY0Zm1hUHZ4?=
 =?utf-8?B?cUxLUmwvdEVmZVJ6dGZGeitCck5PbjlZMkdyb1FyeVZRZkN3Vm5zTy91NUlN?=
 =?utf-8?B?dnVSaTh0OWFCSmVWemhTM1hlVDRZeDRNOFBpZmZudGhuSHNFSTAzOUs2eCtt?=
 =?utf-8?B?RXNlNWJMYnJyaEQySnBzeUdTUWpDWUsxNXZmTkNSeEhaNGRaVVpneDBtLzIw?=
 =?utf-8?B?ZW4xQmgzWU41bHhqdFVaZDFtWDVYS0RUR0lIZ1R0eTB6TVlPWFhrTDBSRDBM?=
 =?utf-8?B?UXlsWDRjaElZZ0p6TTNQZi9IK3AvQjJrM3RFVEhZRWJjZ01sZjA0NWVWS2pU?=
 =?utf-8?B?ZlJiQm5lUDFDaklQMWpybGxMUkc4U3dnZGJRYnBPYzZqRi9YOHpGSlRMRHhn?=
 =?utf-8?B?Y3BTVkd2S0lSbE5GZ3VCY21Ca2U2VGxHa3pQM0tPZ25YTGEyN05RSmtxNzFM?=
 =?utf-8?B?YlAxQTVzMVh2Y0ZTMGRNclcxYkZ1clowS3NKcHJkMC9UQ0tpWXdYRGFoekc5?=
 =?utf-8?B?eXU2UUpjN0Z1U3o4K294Ykg1QWpFUVBFRllGUEhzem9IQmRXYTFUY1YzL2t1?=
 =?utf-8?B?UVhUOEQrNUY3ZVlJMDFsTHM0U0NlL2tsRzVXZTRIQ2NYY1pqUm5OZ0Rib2Nm?=
 =?utf-8?B?dDdETTczOEtQSjAwU1dNbWJldDY5TEdwZWRlbzdlVnFud0RPQnNwanR0cXRJ?=
 =?utf-8?B?NThRdFcza1JSeGtETmlMWm1mNFMwU3A3UDl2R2JiWTYwd0twNGJ2T2V2dWhO?=
 =?utf-8?B?QjNkU3RTdXRlNVhwci9pQlJoV01nbEUvME9ualcrMzVoR2pUYWJhQUU4SGZP?=
 =?utf-8?B?NXRVU0dtNXZzVlpiOC9rQ0dSMEJIb1ZLOEswbHhvalRxUmpCYnFxZlh0RjZC?=
 =?utf-8?B?SEFJN0V4Wm9mcitSYyt2WTUvUnhwTE9QU0xZYVlTMVoxbGtmRWw2cXdJYXVF?=
 =?utf-8?B?VU1icnk0QUFETFF5Y1ltM3hBajNwbzNxQjVBVHdCbFh0TVJaNVpWRXF0V0dU?=
 =?utf-8?B?QXpUWWFZUHhMdjdJTk5BK1hBRDVkVmZWWlgwaktyVXpucmRSSGVFM005cVo1?=
 =?utf-8?B?MkU5Q2dNRkR1SjE5R2Z2MDFiMldBUW5rTHFWdVlIUlFRVnJpQXNHOXFWbi9Y?=
 =?utf-8?B?cm1KY2NqdlltSkpCdWhDTDZ1TURZV0NFRmxuN3I4cTBQODJQWE1ESG9zb3dh?=
 =?utf-8?B?NGRSdG1NK2c4T2RaVHZGVURIN0MrV1NnU0VYL3MyT2RsVjZONzdpNjMzSnYz?=
 =?utf-8?B?V3MxY0pMQnpncFgyZ2VlUHUrN2c5amUyb1FyZEEvWmZ4cVRZWTErZFdKTEE2?=
 =?utf-8?B?NUtQU0ZMU0k3cmlPaEgxMlhsMW1IditjdUs2V1FJY1d4ZlFHSzJGVDB3NFdX?=
 =?utf-8?B?S3YzUmxDSWdwUFdEeHVlUXgwV2xmek9tZ09SNjJ0YU9KcDRwSGtuWWJTdXgv?=
 =?utf-8?B?aEFwV1JHbkxmRVZXR25MTSs3a3NkQjYvYTZiWVNsMXhxYzNtVWV5S0ptUHor?=
 =?utf-8?B?b01DVkxBYzhSalhYVGhYaG1tY2JHamU2SG5QYzlsWXlxd3l5emgzZnVnR2wy?=
 =?utf-8?B?Tk0yYkR4SHJKWE5vK3JURGFaVFlwVlpMN2hGOURQdmtjaEd3VkVvQitMNzlY?=
 =?utf-8?B?cDVTdVJQNHhPKy9XWFBIMXVxTzZZWjJacS9iRUgxbEdudmFXdEtiYm11bUdC?=
 =?utf-8?B?R3J3NWJuNEpSTElRU2syR2dCTXVYbC94ZkdUSTdUWWkrTE9SZFlsWFVMQ0I2?=
 =?utf-8?B?b2dBejlYT3NPMHJZMGZScnN4SzAwNTMzZmg0S1hIa0JvenRRamFTS1hqUEpN?=
 =?utf-8?B?Z3pwNHhGWkE1M3MyYWQ3dmU0NWZzN0M0Rm5rbTRYUkRwYVBZa01oYTQ3a2t2?=
 =?utf-8?Q?y4+CO6/HFd73sJyOrRvDI46fiy57ZNxS/x6UtseJOfrgS?=
X-MS-Exchange-AntiSpam-MessageData-1: rw81i29iaKXoWcw0IK03HtJSRcqaYmN16W4=
X-Exchange-RoutingPolicyChecked:
	rrJVK7LI4zeCv0aQnalPmPlM16DGa/4is5Dr+UIXACS7I3si4d3GGcbvK1Efn5FEY+Wh+oi8ABPbKIQPekA+/KfC9bV9axFD00sPoZ5OzL/HxzLpds2XgbzZXThctVZlr0Ubwkn6Ss9b/8BGSEXEM0iiCrL5+8d5jnKiwtZ3PwlKmOkeSbssv/igx4m35UXSvuWqCT0Vl3Xg+Ot11Qx55umgXuupuJnplfCx2L0loX3JcvW5ItBTsaHLbJqUQLAuZOpXwkofglMBV2QCNsb91NkDJ155XT6Keav32CQmEyoM2IMMj2OY07HcQCw+9qOLwx4ev/XvQQFBNdCDt03ryw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z4WBlaFd7UY84jDHX+7kiRw3EXrZewn3qUZEAIkmlVma3EFu2QMtkZrUwa/nUMpqMZL4q/tHy0M3Th48+H5zJtmP+89tkHG7GC2OvzvYZjvscKeSBZiU1FLnNztXo9fJWYMbkhvgtls91yomEwzR5EiC3TSROuE+6bnQCKhvjeSOc8bRd0Fp1Q6XsN39ok8k7byDz7zV7ZqQyVebpg4qAJTkk/iNrDoEoFRYfeWa/XQJEBpSOWnPiP6bwxaJaGx+sGG8I/Q4V7yGFr+EfcVG94+mJitrlhuHkP0u1sPnLXiD/YSlFA20ipyG796Cbk9qn5xeOZ25Bk/y56i/bQxuKAaM2BOkEvKgxclXKOBTX+mTkcVy7bp89z7xKP8BfY79cqF0VKCfHOP9A5JKhKVZoJ4IQGkEuu92oZKO5i0K1kqu5BC7stZXLEu21rJdj9n2ZPuA8QcN/VASY1240ZWXOrpy49Ew1LfIVflofjn+DDQytvJQaZQKGs0Vg0QjE2qZc2KQ7n/5kJvG6nLcJeuFU5OfK2P4n9mDv2ysy93HWNwa63R+71Kv7iPdy94V9bIYnYVyD0N6/C6VpWU0O/XOsWYH4/BAbq51bZXrU+Mvlao98pL0Mf5RFx9zARqzdS85
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 906301c1-62c2-4b39-a8ba-08de993cb639
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 09:11:56.9669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNLVP4Tpdo07etVyU18M4izuRzOsLDszJnIH3N4AJd49wvfOPvZX8phZjulUZSqhgugniynoScBmvQT8UPzJyV19DXno1kN1Zew+R9Zedp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7499

On 4/13/26 8:52 AM, robbieko wrote:
> This series fixes six bugs in fs/btrfs/raid-stripe-tree.c, all within the
> stripe extent deletion and partial deletion code paths.
>
> Patch 1 fixes btrfs_partially_delete_raid_extent() failing to copy the
> devid when rebuilding a truncated stripe extent, resulting in zeroed-out
> devids and corrupted stripe mappings.
>
> Patch 2 fixes btrfs_delete_raid_extent() using offset=0 for the search
> key, which can miss entries when the target is the first item on a leaf.
> Changed to offset=(u64)-1 with proper boundary handling.
>
> Patch 3 fixes btrfs_previous_item() being called with min_objectid=start,
> which prevents finding the preceding stripe extent whose objectid is less
> than start.
>
> Patch 4 replaces an ASSERT(found_start <= start) with proper error
> handling that returns -ENOENT, avoiding kernel panics on unexpected
> B-tree states.
>
> Patch 5 handles -EAGAIN from btrfs_duplicate_item() in the punch-a-hole
> case and refreshes the stale leaf pointer after a potential leaf split.
>
> Patch 6 adds return value checking for all three call sites of
> btrfs_partially_delete_raid_extent() to avoid silently losing errors.

Hi Robbie,

Thanks for the patches, I'll run through them separately, but there's 
tests cases for RST, can you also add tests checking for the above 
conditions?


Thanks,

     Johannes

