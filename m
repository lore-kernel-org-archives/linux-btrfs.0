Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D06539EF19;
	Fri,  3 Jul 2026 10:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072898; cv=fail; b=dafrawD1Mt8jbJaTqzNxTsW/tYTfemRpGyoezwlQhtZV6Hrr8SfM1HFhtak+MzSPr3xVlW/bE6eFngZmie6miePOlYjBMfkM9GDrDKtoH54mAX4CMyG10K+9UFNklspw1nRz6ek5KryQfluuAkNeKd8zwhro9x0zKjSzeaIYTG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072898; c=relaxed/simple;
	bh=WkLXsYQjQgM1q+k6jsQIhcmRZtyExi//lF1BrY9L2iY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pe6KmsB5zlOkOyG6Yxj0mp9zrlO7HB7rZNC0LbzZwF7vK3QhPPoo+T78zPcOL7tjiYDrGrxIhApEavRHHwjHDe8CttEniZRSkOHUvlN2yldbl+sq+iw7fJVcJP0//DjvoLHMvmgG5k+hyL1YSGjxRjHf8XuCmg47J3ubdcSZT80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=caWqPOFZ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=f3AhPcUg; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="caWqPOFZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f3AhPcUg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783072897; x=1814608897;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WkLXsYQjQgM1q+k6jsQIhcmRZtyExi//lF1BrY9L2iY=;
  b=caWqPOFZ+f415on2MKK5t0DywS2g5PoMjKURBagsyTAqneHiZOzxLIVQ
   4G67TGdS/2d7U4WABJnAQ4SJpVlPY6JVPUNpWijex+8TJvKIFO8z9Jlll
   sJilaeskp0pDq4Dfzy9WLA5MDp350KwNogxcmZrxB0Wt7zeILEeYpgbTh
   a9MnOsak9Pr4alm88i2C4kVIU2HBJeCEr5VHNK9mDCRylsSsS9OtqJykn
   sjeetlPNp/qsGdCIOxx/RuywpaHK8GtCm6JgbnYyJypP2++re6qKj4LEN
   1KXTMM3Tr7z3QBrsZjWjnDztMDH4jJEmQ++DV5Is07WqH3lO0jDuVecvh
   g==;
X-CSE-ConnectionGUID: YksEpT5lSvSLPqL8eyhpNA==
X-CSE-MsgGUID: d1dLgUUGQO6f+T//+K9ZoQ==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="150320893"
Received: from mail-eastusazon11011017.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.17])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jul 2026 18:01:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JB1AcrPH800zLryRmTtiMpdXxH9sOVmO8vG6azn1sDwR/d9SxsNZN7T/8gkVnxNutXxLqyAYyKLiaWeiDOVRIUA1IHk/jmXLyq9GVcMJplsNzsWkWaxKoa/AsdzfIjJsGVxUxBYsOR+t3wjmIkUJnPza97TuAycVpihUZxeqMtyR60bq8PPieEiywCaXigkRcs1jndeuIfp5G8YglQBitY29APPEaZSzadHalrUgglGfgIXbiN83njbY5uGS3vSWw1++HqE3kcs0NnnkztebKOpZ9z57wnQfFxD9DjTAnJNknZE+kNMkLbjU2gjn0OagaLF2zFSXKcI9RyvcoJYG5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ipdvKceqHriW74XzRYpNqFYFnlxRCy53zbPvWqJ8Pg=;
 b=xeSHr0qF1TQo3UOgGWuYTob8kMS7XcKetreVBpTptI9oTYkggiwtwqEbeegPjcKdgFIS/S4Iutz9R2hlaNTNUOffbU9Zgv7MKCzC3qu9xbdyxaQTKFJkHkWm2plsFUgnDhTbyXNYXhlPXlGbDYoHm0rBOZfPYnDqyGVCIl7CBKADT1/SuL2IsdoK7Q3LsOUakM3VlVW7Xx5eJDlPuhJ1RU6UTpdWGUffhEf23Lg4KjEaevizNorJb2iYar7qcYE1PKy9J/eIn1HFvh4LFzcjc9ET2xp1dSLucN9PdCrJIyiA2b2Qwg2b8eWOT9sfOd5bc80NRLODyP2tOMyDxNkRaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ipdvKceqHriW74XzRYpNqFYFnlxRCy53zbPvWqJ8Pg=;
 b=f3AhPcUgwOh+7AQooyUaK+5vpYhy/4B+InLj7j2/uDDyC58LqzpGy4aNrP+L64qBPAFIj8HKQvee7V67HMpc2KkVB3CVlzk/zKQXou4Te7uwroTqUbzTJqiOz1TM23Ou6RDbdcJTYOcW+pR4JgWkpWEJGC06PbsHMoB5pQ1/bOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA3PR04MB8978.namprd04.prod.outlook.com (2603:10b6:806:382::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 3 Jul 2026
 10:01:26 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:01:26 +0000
Message-ID: <9c8421f2-7f17-430a-9f87-26fab7b1d73d@wdc.com>
Date: Fri, 3 Jul 2026 12:01:22 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: reset active_meta_bg on zone finish
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260703084559.136605-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260703084559.136605-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA3PR04MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: 35f91053-3eb1-4fcf-de1e-08ded8ea0ba5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|19092799006|1800799024|366016|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	83i+YvPL1uMu1pLecrUOtBzXnQclyOeeh3ko1QUgnM2Op8ZeDcuAeWe8C+Lp43bQhROijntREFI5I6PpCeUtb7syctDq8fQ+GhB8kU0TLBiSBSNurt7q2VhzbxT38BrZ7uKYBl1tuS8ToXui+kNXghtAow4vEO3Lg/RuFsRQFLmDycSyhI646mtVSP4karcy+o09jyHVMrit1wvYt77r0hSWFYmK8lO7AFWiLyGJqqlYbKgCWdoRCDM/oZ1FXmpNoxnh+2WCKNRk1tkmLF0IQGLWAzajXqkb2i3K4SmDWXxhHPRRu6uQL93SalY5kuse4X7Z3idsguTrXP3pSxs0gsgxutecaoE1veQcId5GPL/heedv+xcTHdMV/Q0h3oV1rYGp9MMkxfhc0wsRI3G4Usx7x4HNwgvs6wd/+Os6D6qZpEmOMJwKragbFvqh9Y+gW6qIBEpgGldFqbYqjYgpyCqQdp73YjihVp0V0kirmbA84ojgqnk7P+IgGZjsaZlysLILdZRurgMwcG99niMdwrGiAQDHOPaoAEnmMLpS7jLp8QskeOVinFpTLQecm83qE3P7B1cWfxR8QyyCXS29XhHgkNb6kPdTug1fGMfT6AY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(19092799006)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bW1iY2wvSmZXRkZ4VFU1OTVzUDI5V1hBanMvL00xdk9CNXhwYnRYUVJPaU1a?=
 =?utf-8?B?MDZ0QzB5ZkszeERxQ3pIdnhvdFJJTFU3N3Z5aUtyb2pMcWozOTJUUitmQUYv?=
 =?utf-8?B?MDBGRkFjbXJhZVoxNC9MYllMdzVia0VmTXNidmxJSjVJYzErWXMxWmIwL3R5?=
 =?utf-8?B?bExUS0s0QXhtRHV2cklqYXlqN3UzVEF6eEtxS1VSMFkwWWtYZklad0kwVmox?=
 =?utf-8?B?dlJWa1QxZk1HSkR1MG5tVDJCT2tBTG5TbjZtTGZULzJoTjNsZmdlMkFTampD?=
 =?utf-8?B?TXI1WE9TRERLckt2MlQ5UWtxTXQvVW11M1RNeStqcUJQVmxaVE1RM3EyaHJ4?=
 =?utf-8?B?eXRJdXNEUWt3UERoMitMVTBnYzFNQUlja3ZDZkhqU3FxTUg4UytZSUcvRkZQ?=
 =?utf-8?B?QjBld2FRamluWTE4THd0ZkZFT2kyZ3Q5MkU3dmlCWFJvSnZyZkxvTlhMUytF?=
 =?utf-8?B?TWx0NXg1MHI0Z1R0R0RwclZGaWx5SkhMdTdPNkhpUHlnZHZXSXR0TCs0U01V?=
 =?utf-8?B?cHNaamxZb0V1S1JRdnBneHZWaXpKdDhGZUhPdlhKNVcyaUJ2U2RlMjB0UVVU?=
 =?utf-8?B?dnRvMzFvRThsTC9YTXhrWlZ2bVJ0dGViOTBhOXBCQUFmeUhHY0tjWVhLbGVQ?=
 =?utf-8?B?YUNvMC9LdnRlenZVVmVibkw1cmh2c1c4SWVVSHVqeVNXVnVuVU1YdzBvSk55?=
 =?utf-8?B?VE1RRXNxYkhjeHlja1pNM2F0RkNWQTN6WHNuTWN6WXVSM1ZpRytTc21xdDNH?=
 =?utf-8?B?VnJQOEF6aUZuOGFWQjdkaTFkdU9iKzRxK2FlT0FYYi9xVExTR0tUODc4Wk9o?=
 =?utf-8?B?NUhzWjFxLzNSUHRJdElRQ3BYV3RuQ1FXbStPMnc2Y1RaeXFZeXVJWVR3Vndr?=
 =?utf-8?B?ZFFQVWQwNGVsbFd1dWNKL3FZRHNUdHJ1T1dDRk1xS0pESmdMQmx2T1VISE9F?=
 =?utf-8?B?cmliQlNwdytCQklxckY4V1IrdHpFMVdtSU8zdVRRdkMyVTlUUGhpV3ZXNFUy?=
 =?utf-8?B?b3NVOGVNVkk5a1BMSDVFVTY2bXJlN1YxUmlSUmpTMDQ5UXM5cU5sTUtpOFZE?=
 =?utf-8?B?Snl0T0c4OHhzNndtZXpQZXJPRm41ZFhSVXFvSXVxNnBwL1FWUDlLVU5rcHRS?=
 =?utf-8?B?aS9RTk1FREgyNmxGbkhlNVU4ZnNhQkdxNzl5MkZSUGgzZDJVQWg2SmRFMUk4?=
 =?utf-8?B?Y0cvLzNYV2hDWmk1dXlqMU5GUk9WZjZocyt6Z25uZjJJTGlTOW4zT2RicFpJ?=
 =?utf-8?B?V0tlODk4eEN3MElvMFFLNXZORFI5US82OTFuTFA2bDhYcEVpNktuQkgzR2hV?=
 =?utf-8?B?RytZOEFZcGZRdUdlMzV6aUU2alVPMlV1K1cvSi9YSG5BZjdndi9OV1lsSDQw?=
 =?utf-8?B?dDhkSTlyY2NWVG9aenkyMEF4dDg0aldBeHoyaExUZ1VneUc3eEhLanBVa2Zo?=
 =?utf-8?B?RGd0WWNqQWRNWkYyalNRNTB4U2JXZnFkL3VxNjZTNjA5NGRKeHBMQUdVWXF0?=
 =?utf-8?B?RjlvTDlDVTNwaFFQSklWVEhSS1VxR0RwQzhwUklOVUFQbnVqRTkrcktFbEhu?=
 =?utf-8?B?VGF5QnRtYk1OdFd5ZzE5bUpTc3hCOElIbXo3QUlwQ0xLS0ZyMEs2c0xkTTdQ?=
 =?utf-8?B?UTZtMUErbnIwMWtNZkE4aDRmMm96VS9IYnZ5MTRmcGlENjB0K0lXbk5VbHlH?=
 =?utf-8?B?NlpkK1FMbmp6M3J0WnZSOEREdFVQdUFIdXYzVndJVndqd0wrM1ZpRUpVaHgx?=
 =?utf-8?B?bDJzRWhDSGJrSWlGcUFxWm9KSXg2V2VGK2N5UFVBWENJQnpaakFER1NCMVAz?=
 =?utf-8?B?dGNmZS85czZnREhYTzVTRzNTdVNPZGU2a3VLdW5wUUJaa3YyZDJROUJ0MTBm?=
 =?utf-8?B?eTlpVkhyNzFaaThqOHRSaHc5d2MyaEo0L0luSFc2T3VJK1VYNlp0enpheU40?=
 =?utf-8?B?YUVsRUJXNTUxbGNhSDQ2YnZudXdUMnRjUHlIaWRoS3RHc2Jjb2FaeDJ1V0Nm?=
 =?utf-8?B?VTdUUkQ0SEJIUlJrZ1lvN290dnY0ZkVLdmF0UU43alNyc2NRS052eDB2djNF?=
 =?utf-8?B?NG1CNFhnZE85Y3BwWXVYUUdDRTJaQ1Y4UFJXekVGSGJsRmYraklBanNIMlho?=
 =?utf-8?B?RVFIbnJZZEFtdHpNZmoyang3TWtEaUE2cUl0R0hEdUF5UDJkVTQ4d2NRb040?=
 =?utf-8?B?YkM5WXVqbmxCbFEwelVUSG9yVmJVUzFxTnVhd3JzSm9rRzc5RjlGRTNuLyt1?=
 =?utf-8?B?S0FyVU9tNFZUdW1TdlNpVjZtWktqTjJJZ3FwbDZwOUg0RnViNHpNK0tzaWg3?=
 =?utf-8?B?RjluY3VKL09RVFFnSmFmRUkyNmpZK0Nzd1QxbkgydTN2bUFMZjIyZ2Y4dUhF?=
 =?utf-8?Q?4uhU54l5Drd360nw=3D?=
X-Exchange-RoutingPolicyChecked:
	dtv+F7yCMX4PJBiTZu4meU+zmYS6S2pCf/KHYrVpzcqKw3o8kC0yisSRSzzXZlYIba3kUe6DKj/tpomcMfZJ/eKLQnJxNaskolDu3tWk+eixz4YoNNmYYJCr7kb1oG9RUf63KhOwrUUki0sMWOhXEHY72d+jqINHrx/VzlgnupOzQVSPhfuHO65fvkoGjMq1zgHthUdYjQmfKOKeJLqfMNrmzpwZ3JUy58SJ720SrbFtkJRrawubOCeW12Om8luM9JPsdAqN0S/58XfiuYelH2KkGvkeNsaJiTVV02JkARt2aBoVUhZDZmQbN9ApO8ZLmWew0uKmb31TevPFAbbvpw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QEfAdmfyOkwvyFNt/+TD5+/NP911vjUEJY0ENdEtgEQovjjsytLxo3Mxx5emADn2wd3jfRTI5fuUKwS/Q1+IBVO37/8RmdU2OguNVoY65daO0rjyoCGcbKsK5t8309jpmUaeDWhcgdqnD6QOlyjLrECP+TbaEIMVyRms6xhsCgsLVtkxRtr9CSMezYEzimzCKuf7RwqYF8KUorlOziViOMdbeuAYRnEhu8rtYMXxhhZ8HYhmCrgXEbCluK4lvHB/SwbsNbQRDRY6VZuJ4J6Vxp3KIGRS+V9REwhEveaBatCgRq3jcZC8Vg517k25VVFIiZqCwFv9rfZCYV7ysLHe+s7K7J2kFMu3X8m9BVF4su/bf4wUdkb15CARHIg6/mSGhRlVv28k3iSdpGlWJ9ACE2r8ssXgPMWpL7RcnVYrfiDhq+2RPiqGawogWAMezK/UFFiuj/BkkRsqU+m+n5f/D6jN6t38xuyk72OTqnZkN3mRpBzRD50tenpDrdQ3nBTMwbmDcI63SoGThGZkuCFe/t2f2zHljXB+ihSDoBGahh6XsPjLz4nJc2lkAMRVZUf2ZGyJ0siXrz/OvdGbYLhOAqOFdbFef59G+uejrAZuLz68gQmBlIBYM5kc3AqP/Za/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35f91053-3eb1-4fcf-de1e-08ded8ea0ba5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:01:26.3206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgZs/2qu7v+8zQLKUITJPOVgxZw7eotmYzW8ti4bNRzyD3Ftcfr6r2QAGBLp2HZ4KgEy58K0iga6SM1v/ktKlYF9ZdiEwENuhYApwnGqJAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8978

On 7/3/26 10:45 AM, Johannes Thumshirn wrote:
> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE and removes the
> block group from zone_active_bgs, but only the path in
> check_bg_is_active() resets fs_info->active_meta_bg / active_system_bg.
> Any other finish path leaves active_meta_bg / active_system_bg pointing
> at an inactive, fully written block group.
>
> Reset the corresponding active_{meta,system}_bg pointer in do_zone_finish()
> so it can never go stale.
>
> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   fs/btrfs/zoned.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 44a13ed6b8b2..c8c850de1702 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2539,6 +2539,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
>   	const bool is_metadata = (block_group->flags &
>   			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
>   	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
> +	struct btrfs_block_group **active_bg = NULL;
>   	int ret = 0;
>   	int i;
>   
> @@ -2636,6 +2637,20 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
>   	/* For active_bg_list */
>   	btrfs_put_block_group(block_group);
>   
> +	if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)
> +		active_bg = &fs_info->active_system_bg;
> +	else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA)
> +		active_bg = &fs_info->active_meta_bg;
> +
> +	if (active_bg) {
> +		btrfs_zoned_meta_io_lock(fs_info);
> +		if (*active_bg == block_group) {
> +			btrfs_put_block_group(block_group);
> +			*active_bg = NULL;
> +		}
> +		btrfs_zoned_meta_io_unlock(fs_info);
> +	}
> +
>   	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
>   
>   	return 0;

I think Sashiko has a point here:

https://sashiko.dev/#/patchset/20260703084559.136605-1-johannes.thumshirn%40wdc.com

check_bg_is_active() should take a reference before calling into 
do_zone_finish() or actually clearing fs_info->active_{meta,system}_bg 
can even be done in check_bg_is_active() after calling do_zone_finish().

That'll then also eliminate Miquel's concerns.

