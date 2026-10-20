Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792494465;
	b=0qMxQKRNVHDs+ky9fo41zc9MZ9oJkFKto3dUbuWX5ZJJjaJQvyw6CBGrwQZvCsmaBRtO
	 EODpJGdidIlZcN/cCLGOY7wIUY+s/TgEMqIuuSh39sBg2Z78QIbX0h9EtR9qh75O4Jrm7
	 mM+cxd05z/AJWJXKPnQMIe4VnKFwIUk7jYBOD48hT2tGxlMwU02eUMi/npKEPhTumwPJ6
	 UggY0ahEiELY7Ij7phbMuIKXP4rQqo33phV/eRycy3r/s1Gds8CgI2RL4z4mOP4I4CJ5o
	 fftLuTanrT00+OaYRWXvaTONhmb+nsqoJkqK/Ac+dRzyEZf54T5LbWcWgngfoTjBIuQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792494465;
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
	bh=9GFvS/6dU+wao99zx0fRHwQ0ObsXlr9L5uZQaZ7jmSY=;
	b=IVO3js4flrN/vhfTUiw1Xc/fAOD+Whd4a5aspYEsRqGN1tyUF4+Uuz5Avxrc/XRG5ZqD
	 fIyGyzZG9LlfNi8QVaH9H+QphKari6pwmGEgUPQn19U2erU5PRcxvNW/SVTYLgBHFj7GY
	 Hm38g3S+uFcUUf67A8b17eHkeCJf09NZk+xDrWwXQhzMb+67p5amDrMd6WVHt4ksgfAhl
	 M4H9EzaRA+9fyJSlZA3/Zoez0hkPpEFZuKTSAfMIvbRDJN8uGOWsbQLZ1uSmusD9QLUoh
	 R3FE9zKxN9SuGfxN8JXMH9UnneGucDNbitWrHUYKWP2NPHj6qXbLUau//rgH1m/PsrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=S+kRUFnH;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MyHpbTNT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F88606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 11:07:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13F88606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=S+kRUFnH;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MyHpbTNT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792494471; x=1824030471;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=E5xnzNU4w4x8YXlYu+7BXp5BNB00OtMM6qizqJnjVm4=;
  b=S+kRUFnHpJPk1Pk/NBFtCSkyViz4OBJ+lRuv1nUNmF8OVLHtcngOB8S0
   B/gJjgZpOx/IoExy3x64VI70SM1NQA/H5PXaivtxeNyVuAPUFa3sziHdH
   Kk3zw3br/wHWydNkydwAjI2/d8xymIaWqR9o3vOnsPIfqo+QPXK1mmTp9
   P7EtuawNPxCs0idtYQzzs8mVemJ0n2Us/UYBjhnkLtnTMrsaH5o7GR+23
   EvY0yjl3ymL7YlO/J/Y7xEr68PZJU07RLDzcObpGSSaTFpruQeznDY03t
   xMc1bedt0/3ZdTulqOLEm1/Cj5+tXxiwYOZVC2Y2YnyAdOdm9QwXyA+rN
   w==;
X-CSE-ConnectionGUID: ugcbuUESRPiTxPiI2aaG9A==
X-CSE-MsgGUID: QfiV7x5WTIW6C4IqyXlWqQ==
X-IronPort-AV: E=Sophos;i="6.27,168,1786982400"; 
   d="scan'208";a="158541303"
Received: from mail-westcentralusazon11010058.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2026 19:07:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tqmnUqKq3ozP7GZghz4OM508bBwrK3VidD3zFwA7PD/3YL8I0C/KRQUzyM5eMBwD/bcFis1lIuD9zDiH+ISmYsV0tLIIfMNdRrBF3z0xb/pxbTe/X9BmXsEblaD/NKcfCGyUrobrIywJ/lYk/cyRUTKch4skymEA0R+z+UnsNsagmTKi7as8raf24aWFikga7DS30PMMzdNvDwtSXB/mQ0JO2oTiO9KbtcevdZHphLPiQGStt6NSxl1PG1ihjDm72qJm46AmrmuFBM2qbRH16mThrW+1R8xij4goP0bBFOuCpc9I41KFQlNPE1AysMPv8rYc/zXdTUKRmjsBYispag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GFvS/6dU+wao99zx0fRHwQ0ObsXlr9L5uZQaZ7jmSY=;
 b=mUgXX8ZOIW3PjIKi7uLXOorZSC0N0xoUklsZSynGnygdZ/P8r1U5YHjQHTeuA1SNcAVG7oXcBSKqMdCjUtDhdjz0oTsCS558+n8iUWSSFttn50XTdec7nKwUb3PAH/EjdPzhUUHqPj4ETcSrhlWT7jB7HcnggENGZaaOooZk6U5SJwvcKtQlpkWkj8eKY7sAVaeL6N5MImwp9bsGK8Oz+7d0jd0xbjW9BGrbI73sFkqml5u+oVnV5XphfDERig+5cdLbV85sJI5r7pf94yxH6cgZz2zgU8+/kacGYT18d5oxt4JCnfL2HOR+abn6jm3sJ21Ape2NbUFLkSQxkQ389w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GFvS/6dU+wao99zx0fRHwQ0ObsXlr9L5uZQaZ7jmSY=;
 b=MyHpbTNTVeDLT1Ei2JmQuAFoPcygYhSbYfsbzu5L9YysEwe/Pi8Zln8yi7matzt0FyC83+T2U2QSPoRlFnLPuCaJwku5H7Lh56asOgbH+j/6NAfGIrGFU7oMiegHK3Vy78qkTMbJ9Rpb3SS2lk+/Tu+Qv1ECoWBqwDkUsCdbfdw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV2PR04MB9951.namprd04.prod.outlook.com (2603:10b6:408:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 11:07:35 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 11:07:35 +0000
Message-ID: <6bbc56c2-7853-408b-a5f1-7ae0de8b1444@wdc.com>
Date: Tue, 20 Oct 2026 13:07:31 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] btrfs: convert zoned.c to use map->stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <5b7b68cf9d8a6ccfb89b78939507146c3f52652f.1792391732.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <5b7b68cf9d8a6ccfb89b78939507146c3f52652f.1792391732.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0288.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::19) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV2PR04MB9951:EE_
X-MS-Office365-Filtering-Correlation-Id: 21c432bb-c04e-4628-4614-08df2e9a5844
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|10070799003|23010399003|376014|1800799024|18002099003|22082099003|10067099003|4143699003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 Ix+slD2B/+KiO2YkzUp8v6cPmEt1vkRmsM4IsA0MRNyHiqa/G+2/uMMHLDgil6Rfoy7IHulSXwj1OLDDoWWctFxjsyeiYb+81WSa3rt/5r0B0BjMHCtKx55oL25HN/OgbGS/iWul0JHDC4asYbUGij570Ox7EycskwCj8HtdMALfS9JYGXoJbI64z66xBXenVP2pBpaCaMBL89kVKL2S24LIVRK//DhknKONVbNgrpQoInBCVMwBLhdbFTyfFOc3rxXhn4Dfr4ZcWo7UTPXdMCGs/IP0/WjS/JYofxCEuiGiSmfr3LLmMtfHcz/V7CsRghNu4/k027rPC1aAP4LTOmPtK5kRgTilBB/VSvNq8fL6Aw5YTh5YX8A3Gjp+h86cjcNgkMRmuuOWtdnZRRr1Q+U549R8Dwud9q9mrbiU3hYoFnKOXxPmb6tbUvtmbMQNhxuYnRnVfCyELWOzFZmcsLbIus3WlN2OlC76iIdV9hJDNseph2qrh4iXtotb232FytVTJyODv+hHgPvA9L1/0qHJvXFwKnPg9n0QhZwWjPaDOlZXCWeD29hIf2JIyd5ytZP8QQ8b2hb/C4ky1fwKdRtyakXAy8fUpEruzLO6WdeV70BZ63RewLdBqu2wOhWYilAFzj+fqW8RPjsyzkgeGPtv+Jrg0yfElEIVC8Ex7Bw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(10070799003)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(4143699003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NHRvcEg0N0ZxRmdRTkY3YzlIdEpvSFVsWit6TjhVcmM1TkRqZ0pTb0FWcnp1?=
 =?utf-8?B?Y0p3ckdyUWljMmhMaHpDdEhCc01lZmtqZ3pGWmF0Uk5OU3VjL2VxSVJuS2ZH?=
 =?utf-8?B?MUlYazZPTFJkSG44ejd0akF4QUY4RmVkeEVLQnFXWm0xeWZGTDhHcEdTaW9R?=
 =?utf-8?B?U0hQUEdtU21pam5nWVpvQzY3VXUvZUc5aEJzcjNVbW9pRTVpTlBNc1RUMzlq?=
 =?utf-8?B?bnJLQ3lqTVJucy9BVFlkcENlc1c2enpPdGIzdU9BOUlPcnpmRXl0a2ZpQmhl?=
 =?utf-8?B?cmhtRXM5U3VQdGRvdnZqS0x6Y1YwQ011YnlYYUZzdyt1T1VBR0cvYS9UUitE?=
 =?utf-8?B?SlJmUU54Y1FJT0kvT2JwdUpldjFoOC8reFZFaDVWbnFrVW9iZldiUDRsQjdN?=
 =?utf-8?B?RXNyMmROVmRTOTI4NzRuaEJKVmUyUnliK1JiNUFiU01YZE45bnViRytVck5u?=
 =?utf-8?B?aWw1bTNiaWpYMmU3TVpaTUFGRS9IWDZjd29kR3pYdFgwSWIxdHpKYjYvN0dt?=
 =?utf-8?B?YnVpQnNpYysvQlY2bXN3d1JPbkNHeXZ1UzNWZmc2WWt2bkM3NmV6bkFGQTRk?=
 =?utf-8?B?NXJyYlhTZGxkNGJadnZQMzhNN1lxYjk4Q3ZNZGd4cDJXQ2JTNWJRbklVUm05?=
 =?utf-8?B?KzF2SWdUZlQvL25UelZRYk9vWGFubHlUb0VoWEpzTHdsaEJiSkM3SVIzRjJC?=
 =?utf-8?B?LytqS1FZNDRYWmt0N1d4cGNQRThVMHRsRGloMjlSbjdZNWxYYml4UkZndWRK?=
 =?utf-8?B?cmMrMFJGWm41NUZJU2xmQ0dnN2d4ZnJOSVVyTHNMVytmRXFZZlhZT2ZWelFo?=
 =?utf-8?B?c1hsTVNaY0dtT0lkdW5Ra2xZMWNBeGZQNWlhcVpMb25BUFpoS1I5bDdhV0Vm?=
 =?utf-8?B?V0c4cUtHU2lpOTNHR2UzNVNVSTU5bk4vTWQ5Wm5QeWJoeUdCQWpscDRjNEE3?=
 =?utf-8?B?em9iSzhmNGh4U0FxcWRVNHRLTDBNNXd0ZElMRFhRTWR0Qk9hRWh0U25vdEk4?=
 =?utf-8?B?TlBzUGEwaFhXL2I1SjZXck1LN0xnSUhha0ZEcGxiYUR3ZjVqY1hheHYrbTR4?=
 =?utf-8?B?c0RLU0NRTHdWTFdadk9jZWhoWHpZOE1IY3dqbnZwVkU2WkFFUG0xK3lrWHhl?=
 =?utf-8?B?Tk5iTlh3Tk84RGRmQXNNL25zOXVrU1JWdWFMcnJaV05uZlI1SERhMzR2cDBk?=
 =?utf-8?B?QUE2Vll2Sy9BNE5GQks5ZzVPSzVvajAyS2hNZ1owM3p6U3dDSFBvOEowdHI1?=
 =?utf-8?B?VzJzL2pSNk9PVDM0cWlpOXorZ21OM3lOMFdqeWNSa2JZaUFHSDc5TDNzcy9Q?=
 =?utf-8?B?UUx1cThhNjNmek1TdE5pYmxHOXdjSFdWMTZkVmUyeEdzSkRQK003dm9DRDQy?=
 =?utf-8?B?Q1Y0WGNrb2ZONlpwd2p0akFpUWxVc05YLzIyT09zMVpOdjczWWJZRkRRbU9k?=
 =?utf-8?B?azI1Q1VCTncyM1dmTEgyWmFwT2hRbDdTTkdBZkdEUXdsMkVhQm5sVG00cmVK?=
 =?utf-8?B?OERURzJjclRoYUtkT1BrcUZFVE1YS1UxTzVLcituOXFNUWZsenZHRlV2d1NR?=
 =?utf-8?B?ckFOTG5TMEJMY2cxWGhNdC93a3hnSCtGbnR1YjZYSGp4bVh5SjZlZmVWd3Vv?=
 =?utf-8?B?QTFzS3BsMmFkYUNBWUJ6VXZjcEFMQUtmcVhXMXNBRUdFdlk2Y3ZCNkwyQjBa?=
 =?utf-8?B?WXVtMUp5R29BblVNdUpUaDg0cXliZmpnUHR5U3cyU2VaR0lGbjhvN2U5QlBm?=
 =?utf-8?B?QVliMk5pRzJscmJXUmRROEg2c0NZd3BTeXlqOVZMWkhRZjJPKzY3QlZTZkUr?=
 =?utf-8?B?Y3ZudllQZk55UGQ3Ukw5ako5VTFRb3I0T203aVRQeVhBdVlJd3R0NzFFaUI0?=
 =?utf-8?B?T2h2VnBPVDl0V0lFa0lsZmNKWDhmZkJNTi90OGJmbmY5WlA0d09RWFZFNGhN?=
 =?utf-8?B?b24rMzZ2TDNsU3VxL1QzQWtIa0JSNUtzWDQ1RWk1aWpaVkw3MUFHOHNibjNU?=
 =?utf-8?B?b0tRL05JYzg1MXl2Z0ErZFVLUFBuVmE5SjJKRExzUHFwbHZidG9ac0RvWldD?=
 =?utf-8?B?NDNySCtFNUxJRVVPUWJ2ZE9CdmRYRC9TTGsvK1dYWVR0ak1PMmcwT2Z0YzNK?=
 =?utf-8?B?VWtNK1lJRXh2Z1U1dER2VXRwNDBlV2M2ZFJLV1FOQ0h1MXlIRURCVFZhaGR0?=
 =?utf-8?B?RllWdUVHeGJGRkxSUVdXbWdrVlhNK2djYmxnZlNqcXRMZllrbkljNCtMSy92?=
 =?utf-8?B?K2lzd052cDhOcGVXYkVQbnFod09GQ3B2QUZZckVJejVjTlN0d2RRMS8vWTIw?=
 =?utf-8?B?Y2tlSHJNZmRpWEluOUlENDUrNEdwUzdjS1hYYytpK214MVN4Z29jbUZlM2RL?=
 =?utf-8?Q?GE9ArviKsOUE/WZW03a862rWKsvi6qTaPgYZvJpeAaikP?=
X-MS-Exchange-AntiSpam-MessageData-1: AIxB6VuQqzl0WHbJg2d3yKbXcdYOV7mPcz0=
X-Exchange-RoutingPolicyChecked:
	I2TFtCJlENStt6xTkS6gIoaf0TfO2OBSfgf9dcE5Yqe3g/YZYDFCHmaXkgy7rtAGCBWQom9DdQk09JeS9vNThs4yJsvzZa3UZb1w+FPmCYcUwnkRQDgRTsEYRreIs71XAXrBQvGIb2chdawORJTOid83X3SbXMw7aVcqIAa5f8QBUsExfLcINptBafqQHV7hlWfQZd1Zeh2O29SrppzAvr/6NhSPd+EWX0v1m6o9Sl7UrT0Tx98twxRBwVERE/v39Lsbv1MKpp5M2txaTFN2HV1RRL715UQwgdFnIYmJtlLlS/mBoaPQCpwOGagp9pm4DBqubH+eCXg1INsknC4mbQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4sKnid7iSxjt4d5pj8qwN50y4f+nKASNHbCHCqlirYlUOLvwgSDziRPZDjX9WmQpzDcplCfOif5fPgOFmKQ3+lEemjdEOfb1giFeRJBe7tUz2f2Ki+8bZtEGFkZStBERcEG4VieqCPu70JLpy+7DOWZrx1dlsF5gJqLw8lywHp/PTlzOYzQa2RiJTUsjCc4VyRPxyCvTs2mED8JGpf086elLG1M30B7wKSC9V+SAvQkKNtvunbmTh9z54GHRJVFu4cYFkxo1rpugXHc317nacEunMUFPq9xyfvdct8kI+qOZvg/sF4CN4zqCIFPiIuTMSlL8VOttP1pf2FtC8oRQj4Ka1GiRWHmj2SGf8OG+G4ydhQ9wvbK44Tanfr7ANQzGnRJfFy0WQUkDeRCFZ2dxmwMdu4L6DI1thuCGqmHNHICZafD0I9BVnAHYHSibIyGbqVEywRgEJtj1JYsF7df9JVTu+FkDOt/1kkrfIjHEeNvBwHV/uXvxSN4wBNXZTDpYMTmAsg7+1RzDtg8aX5DJbWhxV0ku5YuAsgGv/bKRkzH8OIQVtHy67fB30Pu6VQ9ePGBqMwR5He/whU9r0a2T+gMHrxZIxHQdlpaXqWrq4OlyTqQ5JC/bagJ4YXFI45Lx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c432bb-c04e-4628-4614-08df2e9a5844
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 11:07:35.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBu/C6y15Ep3prv+E1pgsayAO0wMzFKGVT9EsxX2+chJ7ZHwliohH0Tyo4x7cvQkmMcbeh0KfJeAkTbph+RVqt4L2SCfvdYh0A1h6JfQL/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB9951

On 19.10.26 08:40, Qu Wenruo wrote:
> -		if (zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK)
> +		if (zone_info[i].alloc_offset & (stripe_len - 1))
>   			break;

I think this would be a good opportunity for using IS_ALIGNED() here.

>   	}
>   	stripe_nr = 0;
> @@ -1619,8 +1621,8 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
>   	if (last_alloc) {
>   		u32 factor = map->num_stripes;
>   
> -		stripe_nr = last_alloc >> BTRFS_STRIPE_LEN_SHIFT;
> -		stripe_offset = last_alloc & BTRFS_STRIPE_LEN_MASK;
> +		stripe_nr = last_alloc >> stripe_shift;
> +		stripe_offset = last_alloc & (stripe_len - 1);
>
And ALIGN()?
