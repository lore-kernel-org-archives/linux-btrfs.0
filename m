Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17851387358
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 11:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776080266; cv=fail; b=h+rDvDgbM94GrMjqDdI9CsOzgkecdHVRRZwLNjKTDDd2PVXbJCBc6+TF72n+Fa0ihSkAA/ha2zXBrlkq1N/eUL6i+TRlBnO/g6/h1GE18uhE0Y+C0l437wHBAo5lYRsgc0Q5kyXo8/2VjCV+mc9I13UNrgJDI5tj9XC8dkpKnU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776080266; c=relaxed/simple;
	bh=JTLRJ7E84uFyVLqNCVfLIkcWx0cGKvxSZZL+YNmyq9s=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cSd3AT7YD9uvh4il8t6nu0sYKU+CtaMgheX+u+p3RPlGF7uZ1CzNE2Anr0OdwtIH+E2VlO3veA+gwWMsfYNElcQwUL1jADXteZtA6xW6YOtTgcEMHNG4sTdqfKKYiy8tsufm925qHuatiNQZVoc0FwTwndhbM0SUGSYQF1hJnSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kc/kg7Qo; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vlRyR9BB; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kc/kg7Qo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vlRyR9BB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776080265; x=1807616265;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=JTLRJ7E84uFyVLqNCVfLIkcWx0cGKvxSZZL+YNmyq9s=;
  b=kc/kg7QoAyIrASbSAE7NfDkbDuOhMj324pzrKfN2wYsJ8p1ObMdH95vV
   fpF7Vf2k8vN8wFuCt9RN2sekyIfHWXWXwJ/H5SB4a7fjl19tYjxRRAwxE
   SWb+mxgm648pqy4sVmY6fdVFO6ydjO4IENrKvOP5uEiKmiRwpm2E3ua/R
   pChtM/0lfTz/sTmn6EU5APZ3crHkWouBLOxcfVj/iWvJRTBGR08Woh+hL
   SuT7xBDUZUCSCl44/P/yGihq35czBvYaB0GPBxOygTVekp+ZM7wo2hIea
   e3+WTBKMBy4IeHZXeHrn07hidBjZfsCcQ/rh0/4Gez2ay25eqltVjxboB
   A==;
X-CSE-ConnectionGUID: AURTTtVJQz+ufPGEDqT70A==
X-CSE-MsgGUID: X/rtIXgjQsmDCDxJ67/0Pw==
X-IronPort-AV: E=Sophos;i="6.23,177,1770566400"; 
   d="scan'208";a="144881187"
Received: from mail-southcentralusazon11013043.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.43])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 19:37:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KYX5XjmaxQ1+XtpPIv0ob9WL3pJfYLYAOIZHPlKBPEHGHhtLhKC3JWFefR+9VlKPlvzUFDm5415H2QltZMvHoUdbPoTGQgA52eP1SePY/xA6cNoZy2WsJ9vKdNO2xW75jScln+KCjraIYJ5rEpyzI1M6tiGniG5sCSeMtKiPKqxChmHFBi9QxIVXtgiYFCmdoHtdtL58URnf5gHm0T9VUsHO43nyZ2Z4OtlWb7eMOgJeJNkmBI7S0q+jqABVSRzjgNux22BwTBRqM2zOiBhljtEzJUukPxwVEsBVqxF2nACisg7sNSkX/2KaR9xfcHdeHVU5b/YguKu4evGcgHRBRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxgBgAH3K1rc/vHgy7VLihIdRdfyb5DsyvNMF8JTKHw=;
 b=FnJJlbcgC5u5g1emsQ/X0O14ysc9Epw56N69zQHwBKBX0SftkfvBK4WATPY0XqRM9b2cq6dbv4QCg9GFgA9opQxn3zq/R1HhV1hpSk0PwoCEq4Np8RMvt5/TiKHI+MniRn+uGj6nSTl0eM9sJJ8OrekHDvCtHzGZRfJTttnjhI6/Rusp5r9OaTjXP+RfVKZ+f7VcU6XVMPiMM2htd0dJwgR+iy9QwcvjxA7DretVr+ahfBY3s4d4rE/ad+/n14sfIw2cHHHkl1OPWor5CL9apvPIRZzPCD8rgWcUCDbC+gqHy4eGV8nI4dwNPp1/KVJsBE1hRCQ0N7VpmOHMCMHnvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxgBgAH3K1rc/vHgy7VLihIdRdfyb5DsyvNMF8JTKHw=;
 b=vlRyR9BB+eV35AVHbETM4MPMGubnugFaRiceo7WHdjp3FO2Dc26dTv0RGuYRaCvEIkOuHS9CDlTZ/Qe7Ei64dzZSv3D1GgQycPrsAOC97BztOcC12W2D0D8i1lK+kqQjxLn9DDWJ2+ox1ezUp2L28hNHrBwQkVj9ivM6PZPA+bw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SJ2PR04MB8987.namprd04.prod.outlook.com (2603:10b6:a03:557::20)
 by MW4PR04MB7380.namprd04.prod.outlook.com (2603:10b6:303:71::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 11:37:41 +0000
Received: from SJ2PR04MB8987.namprd04.prod.outlook.com
 ([fe80::cfc5:d779:604d:ece2]) by SJ2PR04MB8987.namprd04.prod.outlook.com
 ([fe80::cfc5:d779:604d:ece2%6]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 11:37:41 +0000
Message-ID: <955a6526-96a9-4282-895e-d881d0411dea@wdc.com>
Date: Mon, 13 Apr 2026 13:37:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: What's the status of BTRFS RST instead of linux md raid5?
To: Marc MERLIN <marc_btrfs@merlins.org>, linux-btrfs@vger.kernel.org
References: <adbgT-3VINfJNctk@merlins.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <adbgT-3VINfJNctk@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0256.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::19) To SJ2PR04MB8987.namprd04.prod.outlook.com
 (2603:10b6:a03:557::20)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR04MB8987:EE_|MW4PR04MB7380:EE_
X-MS-Office365-Filtering-Correlation-Id: ac280111-55a5-481f-6a1a-08de99511220
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|10070799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NNkgFKEFhK2wOytmqoZD2hBBxw8K4sxZp3C8blhKv3w9/D7q1DtvOOoDx5jH7M1CrKpObtSshMCPDnH35GDpHd8zMUMDERI3/8NuY4Hx7G8TaGBTynl5Aw0ImeJIorAUOTjyActj2El/JYVYHanIsnCTM4piT/eIoLeZgXXsh6Dnad5OX+wMCVZYyvezQzmA7TycBEuatJQiyi4JefFLSLYyaBbU2GlTh5xJ674oBUYLDxJdJKWgQKtUOwPQgDJcC7LrLpyH8ECf1BUlRi4Tyr8NdpjTR6ly32ujvavYW0PyTP3k871h7yrApwq5TeyCdF2alBCDkiBwoms8tLhAdrfB1+U59wYl3n25oCY2dxEQQz7jJ1AC2eorwc5L2m3bs0+LKNbNbnSDeW5nAWLJO/RKy7yiKr+Hpcz8H6kTYSeTe+aatAPW/XJUL+hL4mhJoP4GUJ5I2uxb4Iy66ttoYF6j2LpMq9Wi87ujx5eWvqk+ZluJ/cDrtGEZbpDqyFHpURGPnKbygQ9MF7f6FncyzLbhe1yizN066SO3PChFwlc2b4h7lXyiMj+liVrc/tGuvfJjAjuZQS2UIgKb96LeK9Mz5YqeRodfBnVPUnoXzmVYhDIUdhh8GWN1RmDIUbuw2pjnS7FVVJnjeO+hSHPX6PO7XIGYAXFdpsuvUAoLVAPso+5i9aHmvufvO00jLA+FcEL4RF1z8ZPOPzgc9SvcoibQi1TW1HlAgJ7xUgdg0vc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR04MB8987.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(10070799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L053ZDhSdm1ZZVkxNFRJY2ErcTJqUE02ejBtVDhrSFFXTm44UG9Ed09GV0FM?=
 =?utf-8?B?dkQxUllXb1ViYzFLNWU0NDlpZEFPc3hyTGJsN2lGYjBQMFZLTEhnRWdWNFEy?=
 =?utf-8?B?T21ITWMwR0FXWVFISFVBQ3NiN3pIR0xGNi8zMjhrdGpMR1F2UFJxTTZtcXRr?=
 =?utf-8?B?UXJHaXFaMWRCSFB3WFQyV3lMWGs1SjZkb2tDK1JUQVhhYnR5NHkxZ0xpcHdZ?=
 =?utf-8?B?cGxDMW1reTNWTFVOTTFTNDVGa0dTSi83MVhleVZlNFpLeTc2TjVrWG5IemdL?=
 =?utf-8?B?cFZCM3hWZm00RDZxUEFpbXFUeVhzR3FjUWtrUG1kaEJTNmJabUY4aFRPRzZS?=
 =?utf-8?B?MFMvVVlyQ2R5WGtNVnA0Yk95WVUxM1l0V2czN0g3TUZTcXBDYzdqNGxaNEl6?=
 =?utf-8?B?WVFVcUpwU3dNczV3M2pJSnFpZ2RtUlYxYzhET2tsREgvSkl5M0h3ZGE1dm9I?=
 =?utf-8?B?RmV0Q2FJSXlGdFd6V0ZoOVlNRXBXMTFvdjVkQUF5K3pQR2RZWFRGUjVBd3VS?=
 =?utf-8?B?ZTAwOVFXRFM0Q2lZdmUyY3lpWUtiVWtXWUUyMHRWMmxLUklNMGZCWnB5TElS?=
 =?utf-8?B?RndnM1BZSVFBbHRzZkFBVytTSWE4VFBtUTVKTFZKdFAySzdoeXF3dm9qL1VE?=
 =?utf-8?B?c3JrZlJlV1NhY3NCVG5JbDBMcmxqMDI0aEE1WXdXSW5pWHZCc0xRSVBsVHFO?=
 =?utf-8?B?bUppdmh1SUQwajE0bnVYQVp6cGp5bHNkZXRFYkN0VHpLWWpzSk5scFRLaGlu?=
 =?utf-8?B?UDMrZmFrUUI0OUI3eGEyeE1sTkZINUgwNXpOYm44bGM1am5oYmdVcHJoN2VE?=
 =?utf-8?B?R0xVOTVCOUdZWFJGZ3hkV0MyQ0I2RkFUelpNMG5Jc0J0OG1MeVA4NVVXMXBm?=
 =?utf-8?B?RmVJeTI4dHNPdkhQdUZmN0FWcFdzSUNHVUJLUGJVVzR6dzZ3eVRrcy9EMGw1?=
 =?utf-8?B?NnlRZm5WVHFVNmlkV1lvR3N2Tkw5dlJLN3hHelg5Ty9ndDJENnJ5ZmNGVE54?=
 =?utf-8?B?OWZqS0x1NXEwMk5KanMxU2VveTJ3K0tEb1ZpeGdIYTdIRUVGRGc0QmVldzRM?=
 =?utf-8?B?dUNFWkJwdFE4RENwVHRWdGJwTkRNTWl1K0tSQ3o4OG9IMmwvVzhWaEcycUNO?=
 =?utf-8?B?NFV3UWVnbXkvd3h2ZDRiaG9MMDZ3Sk1Ucmhqd1dTL1NjSHJIdC9zNFJDM3hw?=
 =?utf-8?B?ckY1QXBkb1czT1hVSDZoY0Z6WFMwNTFXNDA0UWh1cit2VStPcEU5TTFiS2Nx?=
 =?utf-8?B?SVlQd3dMZEcrSmJIZU9hRzFod0J5ZndRa1RMdE9jd1o3WmlNSkhxbHp1bVFr?=
 =?utf-8?B?NlVIUGw3SVdlM2syTVkzNWFBR1VNNHJnendMWXlhNzJJNGhvRGZ2WG0zVi8x?=
 =?utf-8?B?bWQzaGxlVyt1Vm9GM3RGT0ozakxxTDNLY1lMa0tNcnZrU3F0YmRVeEJvNys2?=
 =?utf-8?B?UGxLMTJyaDZVekJJMDk0ZkgwNHZvZzlQWGV4NTFUNElEakpJMzdKcTczbFVv?=
 =?utf-8?B?anMwOG5KVHRxYk5PVHN1RUdBeTZlK0dSUDBta2JNYzJ3UmwrRlg3OEJab0hp?=
 =?utf-8?B?SGVLdVA0eWhGbUxxNFpSclh1dFJ6T0tHYzRTRlpHWk9pUFZ2Szh4eHlQMzlR?=
 =?utf-8?B?WE5DMkdtL29LNTNCRFNLcFRmWGlPSFQ4TVFlZTVZL2t3eVQrMnlTL2s2Wlpl?=
 =?utf-8?B?Vy9IWUFkTmtLVElGTFVuVm13M0l6dXBMV01zYjRBcUZNUEl1aUJVazYvZURz?=
 =?utf-8?B?TFZrR2gzVG5ybXMwemVaeldYQkpKclJvQS9XQXlHYnhzTnVoOEJ6dW0wcXkr?=
 =?utf-8?B?YmFUSE5PN0tPU0RIVW50MGhwMUxhU3lNRUNiOWFTdWJWcTFaazR2VlZOZlZQ?=
 =?utf-8?B?Wmc2TlQ0UTk0Y3p4enF1US9JU1RPd3ZETlhvN0pQcXNCQ2pEOThCdXBBNlVs?=
 =?utf-8?B?Nks5eHlyVkpKVlZzSFltalFQUVRHaUZPSEEzd3p3ei9FeDRrZmg2bmpvdStY?=
 =?utf-8?B?aUlFbHJLSTZQOVFKNzVPdGM2N3RyYldEZEMxbnRpVjZ3VGZ6MGZZQTRaWkZk?=
 =?utf-8?B?NmRHc0pYaE1xemZkSnE4RExMeUh6RTFOR1YwWjUwVzVmWldubnVLZzJoUUxo?=
 =?utf-8?B?SUN6NDZjVm05Nm9KbUVzaXVsVGxGT2c1Qi9aSHc1alBibDJIWWZuakIyNjMv?=
 =?utf-8?B?eEw0VVNGSGN5bnBKQUJZTHYwdnBxRUYzbitvNFlyMlhLdi92d1pLMHJkZURU?=
 =?utf-8?B?dkFqOVpyQVlQbzFIMUczVVp1akswL0czWGRDNVJyNG4rYjJLNkxSbXdQdDdD?=
 =?utf-8?B?clVNRzNxeFdlWW9henVWcU1zNi94V2Fud3BzcUNDYklxM1RMVTFUZDI3N0xu?=
 =?utf-8?Q?mNmNpM1sDlRMr7Cu0TbaBccCbMsjXbG6DG8O0k+Qbx1YW?=
X-MS-Exchange-AntiSpam-MessageData-1: ys0ftBodb38GmxZjDt43TC6wjaT5zPl75Bg=
X-Exchange-RoutingPolicyChecked:
	kGOFbRvmTVHQD92Pq8VR2Dkhf0MWo9KjE89m/8n02dKb0ISv1OBeXfM1c/hIrYnzAt8VuTEFaaKWFpmMdMrIqZkjqdyD35tx2K3ivrkRWpeD8uF0vvSOwkbyv72luE57ZIeQFp9Kz+bigTrrT7z3xze4Yk/7HNTXpL06NvhYXxbSLOwfhyEX6IjRSVJCcamsarXebDzos0D/S5PUzousE0L4LQZBh1z4xf5yCa7ShC8hfIgZX+JPUN62EhgX2pU7bbDh8K13qdAcoOmBGNbXTxabKPr6MSK5bVZDz+O4d3ml3TdQT5cKsdnuJSswgP+CJuBJlFlYDcAMqX76GuXM3A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A50oH2Eb3pGToRi8s9mxkUWAw+djEFRHa3UWn+05y/9BXPhhSoOh4JF/evdcmHMYxxr5lamCJBhtoFsvIKSjYXQhxCD6Xm58u+zgYsH3/HfDTOV7k5YZiZqSKRBFufGgVjicPeP/CujhJfqmLqLc5AumO8w6qiwG/Srb7uVH/W12y4kFngWjjR2q+/j3hbOmb0kPKCX3J0mZdwuWb0ACQZNEgokNQi4Rpbscx76FmKPAEf9ljBGnDizfuOvTSnwbesYgRG95hWCl6zHWaEPmCguBeWFdDEGyumb3nejVYOK1rqQFS/+A5C9doe6lPq+9eAH2S5HbZAcwgVy860hOzHcleTpm06RSZLX2uoHYlJ7sxRTBP/kvYpZAJrMirMH+1gYWXLJyKmER9LaJBn0RVwM4KSP3v1G+r1JOibCmfO4iJY6FJECB51YHOnlaN+LrjYfZOMhOhmOjsY+u9uK0vwjJQha+m7lQIwsUDSLhqgt3YkHZaulaa76vxxIbQ9rrPX8s4GiEeOgK8nar1z+phcB2b0b3QWXlQOmY5IhOBiS8ETAWMGEa3GZu2kAnAXAN3DQm5ppNYkp3vDaca2kR9BwVRJxMkuT1ARFO7mWtoZj6lnlqmpl3lvbvFXWaXGRt
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac280111-55a5-481f-6a1a-08de99511220
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR04MB8987.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 11:37:41.1341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fsxJJBRDKbbV5sRCzJVCQ+t7zhanSX6zA4l9GAkYixbvm8GWrOP/M94ZRfhkzepoAh8riEHl4LgF8pkEF3Avhrk2vIiDGClXhn3gPb+tK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7380

On 4/9/26 1:10 AM, Marc MERLIN wrote:
> So, I'm aware that the built in btrfs raid5 support that's been there
> for 10-ish years is not recommended due to hard to fix or unfixable
> flaws.
>
> But with raid5, once I have a checksum mismatch, btrfs could easily run
> all combinations of the blocks to find out which one can be removed to
> yield a correct checksum for that data block, but obviously those layers
> don't talk, so nothing happens outside of btrfs telling me the checksum
> is bad, and there is no good way to rebuild anything, especially when
> it's bit rot in a read only snapshot where I cannot reasonably delete or
> rewrite the file without some surgery.
>
> Gemini tells me that RST with the future that fixes this so I can use
> raid5 or raid6 directly in btrfs where everything talks to one another,
> but I can't find good docs or status on RST.
> Even this list has very little about RST outside of some old patches.
>
> So, is RST kind of ready and documented, or is it still very
> experimental and "read the source, luke" ?


RST is still considered experimental and the development on the RAID5/6 
support is unfortunately delayed due to different more urgent fires that 
have to be extinguished.

Note while RST can handle non zoned devices, it's primary focus always 
was always to enable RAID on zoned block devices. Which it does for 
RAID0, RAID1 and RAID10.

As for RAID5 I have a prototype doing writes and reads for the trivial 
cases (i.e. full stripe write/read).


My apologies to everyone waiting for this. I haven't abandoned the 
project, I just need more time to get it done.


If you're looking for documentation please have a look here: 
https://github.com/kdave/btrfs-progs/blob/devel/Documentation/dev/design-raid-stripe-tree.txt

