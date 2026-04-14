Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A500849C;
	Tue, 14 Apr 2026 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776176863; cv=fail; b=APUNJo2U5yck2RDd4ICSn05coFXbs61sYcw9iGcvChJ731oeimVgYT/zW8BECRBuNW+Cok+iJ8t0xUEVETnIRa7+asYC8BsU3mhWABpeEXI+HHbVh7EO7cPgtyMoS+LomY6T45MEQwjveqDXTWk4K9xjn/LzM6nbFHegNcLTD8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776176863; c=relaxed/simple;
	bh=f46nyzt+ZV3wWItrJbBUUs1vEcSi7GyhLGZVMDs011s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YfkANGOIDk9IViON2nXKh7rakurgxTWUHAmO1P3a2XjzFPpv7wsfbauehB4KilV5P+65T/LZwB6keaKCR2Xp0j+pZk7nh6LjJTJpE1H1c5fn7fsx7lg7sXba9eHw2znw++9DvExBeHWbtQVGYtQquk7N/Kb8ScMr/g6XR90EWLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mwQVUHek; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HqWXo2/k; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mwQVUHek";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HqWXo2/k"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776176862; x=1807712862;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f46nyzt+ZV3wWItrJbBUUs1vEcSi7GyhLGZVMDs011s=;
  b=mwQVUHekm7r6Yfc5t9sqVAPrp9LkQRiHkOHf5pWq/z3Sp7xc7ZhNuP74
   dPbT4jCxnOyG8Ok1tMG6HTzubesOQduL4v49o9dLeZrO5O4ZCfRZ2KHnj
   D1v+7A4U8nblr3G/QBC17yAe9Casd6EmJkzCljHtZSiKaK2gJGI0MymNU
   4V0dB7M4e7yw1FA+duC4xw+Wn/A4U8DRbZpFYeEHeEpCGSTZP4r8sy0Dj
   mxIbn7yxFNgYrvFwX1Qrqz2L6BTuVLE0fEbv6TG81jSjpAOPuRwCwKvmJ
   PCo2SoFF0dYjb/S/dT/Lnc+ScfmE5eh1hKJcQzgbk0x3vs+Meb2yQwnls
   A==;
X-CSE-ConnectionGUID: 0Yd1YTfZQfa4P20c1i3YEQ==
X-CSE-MsgGUID: qE93pjHrQ/iOSF3oB6EmAQ==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="145636762"
Received: from mail-northcentralusazon11012027.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2026 22:27:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XgmUwFAyQgvb++ghMpQdrOrIgEzD54YIyXBaCZwj40z1OtDgsY91c922q7la+C8Pwdub+/+s/E+DM6ANgMsNFQjujzOPEi+kZTBypKSf0s8nyYlCGA6C+9rU+WDhRCmJQMBjJAwGUTpJS581e/ISgfsCE9DBGhSUMckpdIwwKRSB1k0S9Gb6xEnPNV1pZ3sbZnUWRclD9Sz+7ztFCMM7xdMqBsDvHQcjHOS4RMvCOWSD8BoKFG8l4zPvfs+iRvNYDOlUauQr/xQ5cc+8gKu1FtmlMrN3mObXd/0LJ7hb8FzxOy9iJ6GHDrr0qxqoA3FLlwkuQT1adY5c7msKO0u1/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5kbNHgL3DNTbn6dFanB+iSLY21eK93Fr/199gZ/l6c=;
 b=Jjgb0UGFmv48XKazID0AsOLoXPD0We/eTbbP3TtbRdf7hOToJPRKPrZx9GKEIxbnGSvD584Kq+VVysHDqEMxyEXG2DbyF4YM1verCGekl59O5YjNkIYvH5bonQjLi25HarO5eU1hRAPV4rWCotckcSbsjyv8DDLNfKISTAagbdDGD2V4hCrLY8WhzDVbScuqF2urWpXVka7MnIjNi5zalLzbrMVWXkyA1U0rGu88F7vgYt9DOBcIC97nePTkAXYM8+/aKINA/VGneRg85qkjAoUKXIPCTKPJunX+dMCS3VzX3dNkF4a+DAtSCVO6HE+i/FUCcd6SPNvva9uGHP172w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5kbNHgL3DNTbn6dFanB+iSLY21eK93Fr/199gZ/l6c=;
 b=HqWXo2/kDe5yDT7RcBV/h/JATpUSkNivU5bEyxsGPNYjg0UKMo9ON2n5fC7ZrjjBvSdCt5jpUF60NDGQ/bF9rW4jo8ChPUEkbBUnf8Xknjwwp6owNEz5cNpKAL0OFn7WYr3xnPCiSGYUx+nYP0UIDMqeauYZA31Jx3tZ/GtdVYk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by DM6PR04MB6361.namprd04.prod.outlook.com (2603:10b6:5:1e4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 14:27:38 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 14:27:38 +0000
Message-ID: <7513f92b-f029-46cd-9391-8c1e915e967c@wdc.com>
Date: Tue, 14 Apr 2026 16:27:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fstests: test premature ENOSPC in zoned garbage
 collection
To: Filipe Manana <fdmanana@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20260414134458.153318-1-johannes.thumshirn@wdc.com>
 <CAL3q7H42ddA_HtL9yuO4rWuLhtFht_UjUy3jDr+FgjOQQTcJ8A@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAL3q7H42ddA_HtL9yuO4rWuLhtFht_UjUy3jDr+FgjOQQTcJ8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0267.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::13) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|DM6PR04MB6361:EE_
X-MS-Office365-Filtering-Correlation-Id: 59901d78-ca71-459e-a1b3-08de9a31fa94
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|19092799006|1800799024|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MSnv/ADFxcsQ4rIVp9WR8rqw/oDX0OrmceHSpTvx1jAc9KsfCREyLgjHeYFf0jZxswyqUdExDm27GK9WqB0UI16CBMR9HgCs2UfxOFry9m2RUTMRqMTqF/ezSUlWUc7GroGzoJhlsHs+TYdkZG1GT5JRKmJzKk+/MLZ1GQEnbkZVoKRiAvmjlZt5U6iRbZ9spG1TgaZ7fbO5doO4B/Hk4kx2xoYE6whlAOIgwrGMs74Qvva2QOdMJoo/3mIB9vYSVFkihRlIgPP5LGKwsnj9+YVtjLbQMUr5Yo38tBzCDTquy6q8LsDmZW96Pd4a1zehONSD0DXg/xbLwh8b3Rij9f28kopVwi2HyE2+FjYo4m8Pe57t+O+AsHNRZrCgKYrje6M83o078735PqIkL4w4YjjqTb2mYtVEqIdTE+EDPMOVsj5PMINQaJfASD8FTUbmZrOA05IknFy6MB4pez9bIL2R8/mQhOsnQidiTnCXEjgT2pIFoiD+2bILmw4WfzUZCZ9VEn6TVtFnPZjFzlFm9h1vFeRsndonLafQA8Hl6/U+ocDnT6tZLsCRyEv7m4qf3/1ApjaL64sgGuCUu86feXdFzQGs0L7ZXj2s4Hqx4Ep/7gu3I4XYiNZ98tCRPzmytgLJwmIhWbEsLRrPsobbW8wJA8a4EIFJ4nIPAykX3Gprl5Sp712ccntmVF7ZO7a2pVUPMFt4X+Hy0C0MgqJgCxgsgipQb1+08xGxHL6sg1E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(19092799006)(1800799024)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmZKcVh1M1dlZG0yeFJjZ1Z3NWxQVFFLMlFERUFWWDgvem9zZXN2bFNselJq?=
 =?utf-8?B?ZVJKWFpJWC8vVlRUTTA0TGJva1hVOTh3Z1piMUIyb29KeDlVUWVRUnpnOFdF?=
 =?utf-8?B?SUR5ZGZ5bUI0Zm5scU1oRnptaER1VkNxU0lnS2p5SE5TdVh4cDRLaFR6ZmRp?=
 =?utf-8?B?OUt6V3gvbG1nWDJESnhoQlBLMU9BaUY1RnF3WC8xUUJBTU1xUUFjbWV2VG9n?=
 =?utf-8?B?dWMzM2J6SmFDSjVvQ2t6TEVTbkdRcUYveEFtd0I2TS9qL0hvanAwVDkrK2F2?=
 =?utf-8?B?Tnl1YUJOSm9Wc2NwaXpmTTdUL1h1aDhuMkdMOEROeldYUVBnY3Z0Z3pIVndQ?=
 =?utf-8?B?QkNQN0ZOZUduMHRTcHpoK0dJMnVGZkhFZUlrazAwdkRodTJvUzJOemNHenJZ?=
 =?utf-8?B?dGJ5dmVjVk50cGRxZDgwYkpoUk9wa0gvUlpkYWJtZ2s0dzUwWEtvamFOZ05u?=
 =?utf-8?B?UGpiRnp4NFhDZElUcGowYndDTWZ0Vm12ankzbXU5aUxmV08vUlFZMXA5d0xM?=
 =?utf-8?B?VldpRU5reXJ2UVg2YU1adjlpQ0Q0aVVOeTZWaEUwU2NaVDVRQkM5ZDRNcFho?=
 =?utf-8?B?VXNTaDhnR28ydkpwWHZTSlQzKzVTb3UyU0VqY2JaRm12eVkzbWZsU29PL00v?=
 =?utf-8?B?SUVJbmFEejhoZy9OQ3JROGVWc0ZLaTZwMnBGbEpYbXRwT1E5TkpJNnpwNUk0?=
 =?utf-8?B?Z2F2ckxIa3lxUnFTVTlXK2kwUVFEaURENmkrZzdZR2ZRZWZiellMb1k4NW9K?=
 =?utf-8?B?UFdGWFMrWC9ITnJ1OFBLQTJZbmpuWGJpZGwyNnBobWZIVXhLZ05HMVNCa09j?=
 =?utf-8?B?NmVxQVdDa2g0RGdKQ1JoWTZYa0lHdW8wdjRjOUlkZTZtMlhGbG1hNEZCN09P?=
 =?utf-8?B?bnV1RFBPRVBMTitUVmFLcjNZUVNMS0FRb3VTa0lPUTJZVmx3bGl0VnN6bW1Q?=
 =?utf-8?B?Z1lRTzh1RXF6cThzNmJxc0NseWhhczNhSXY4bEJPYXhjb1draW51cHBiSldu?=
 =?utf-8?B?NDFaeEdqbC93b3QrcEZEMzQ2Y29FNEl0M2dVeXpneGc4QjNRcXVCMXNhcTdl?=
 =?utf-8?B?OVk0MXllNldsU1pmR0lLQjIwOFJlOGMyVHZlMVhKNkJXbGdMNlBvVXBpb09K?=
 =?utf-8?B?ZXVwekFjc25rSFNDYlMwRCs5OGxpdElLMXc4QjFGRFQ3TlBTOUY0aUFoSWZl?=
 =?utf-8?B?aG5IaE9FbG9ZVFF0eGVYS0VGb0lNaGhOTDQ4SS84OHhUZ0I4NXpNWUUxc2Rt?=
 =?utf-8?B?WTNQdy94QUxqbEQ4K1FWdnByM1c4anl2ZENKNmsxejNSNGpMU0VsSmlQUlVX?=
 =?utf-8?B?b0tNRGtGeFlDSnBMQkZXNGtlNXBZaTZGMXhJaW1OZHl1OStPeUNvaDk1YmNk?=
 =?utf-8?B?ZVFkd3VSdDgyS2lzWkJZNUFzS0pvcVZGRnRSNXh5dTNSWXZ2SWpUL3NwZlZy?=
 =?utf-8?B?UDNVaUdtQ25XNzRkNDZBZE9wZ3cwWktjTFZCSHBLMzlaTHo5c01hS0k5VWln?=
 =?utf-8?B?UEZQZzhuQm5HZHRFODRlNG5pN2VHODk5cFZ6NDV0b1FmRnZPNmxBRzlpOVdH?=
 =?utf-8?B?SThKVXhiVmNoOWNZNmJBV1JpUW9mRkNmVkZKc3NyaXFOY056bkNCYVBKcmp4?=
 =?utf-8?B?VXkyMkdlTmlJc29HWGYzSnpZMSt5Zjc4UHlNSS8xa0lCV1NQQTdvbHRXQ3Nm?=
 =?utf-8?B?Z1dPMGNVSnYraUFrS2pxdjBicFMzK1VpdmRFZnBBY0d5d0lneTJUZHVuTGtS?=
 =?utf-8?B?cWExSW84ZURhMXRzZjY2YkdDSXBoKzZ5dDJaYytGOHZGZGUwZkkxUGhWeUpM?=
 =?utf-8?B?ckJJMlhEN3R6Q1VjbGNkWVd0akFzM0VuOGFMdmdwaDQyVnBldHBieERBZEV3?=
 =?utf-8?B?NHB1VktJbEZxdjFLaEFDd09MK2JFd0RuV1ZCL3lVVTl0SXFMYldOUkxrL1RC?=
 =?utf-8?B?QTQ0dVlhV0dTRFZLNUtvSk5pZFNaamFIWUxaWDhGMVk0QVk0cENPSUczcUNH?=
 =?utf-8?B?dmk3NGlFWVM2RlczUnltbVdPeExmeGovSHJTM0lEV25DWHYyNWY5Nk5ZR3po?=
 =?utf-8?B?dnk0V2V4NGxFWExTL1RhUzVRakFWQ2ZOT1NHcnRFTlFkc0w0clVHM2NRSUto?=
 =?utf-8?B?eTFQQVFGdnBtYkNiQzBiZnJ4RVVyNmR1WVVqMGNmVjhaa0VJWU4xL25Ya3FH?=
 =?utf-8?B?UnlMTFE5RDY0QzI5dmllZWVWMkpaWGs4ZHZDQlJuc0dmRzFRQktURE5NakZ4?=
 =?utf-8?B?MGQ3ZDBLTFpiQ2FHcVJoMHNqNkZWWGhyUlZrSDVvT1VhZW1kUFROTmY5cllE?=
 =?utf-8?B?ZFlzZjl0bERadThzU090TWk2eEVsMXhUUlFqUXZxejVBTVpxMnloOG5obkZr?=
 =?utf-8?Q?xHmbcY+x+wLEhWSfEmsg32xSdTDFvVuVghrf/TI8YFDLx?=
X-MS-Exchange-AntiSpam-MessageData-1: dT1VyFuxkpehKRRSDSyt9vEBgX+3v5iI5fA=
X-Exchange-RoutingPolicyChecked:
	Xy2eCFUdIYlUpDiFbpVWophZaslzAeEryfK6Z6cBTrZ/qRceyeMReEb91x4AYteApO75SBynBEmVNZNH856AH5QI70R4poNvfnj+erOORWXK3PA0OqacCZo7KkIZkNYkQsB+JBbfM2GS3Y6wLQwvanSJlSMog+kLkQSac7YG4ZrZewtciJ1U27aCm5f3VE6aSgtaiGtizjY5kp0joiJsv7qvVMHg3VdeCncT2w3zp4MzDNQEwDFXnjmbwIARiUZLg3yovKBlQA0kvlsO5T7RXfIi8GeejLDt8vWGf9N3MX2cqj/H1rwDFVeKrVGCO7PCgxBi5CH1Yj/OlQV6WbapcQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ce37g2Veb1uTd8X6mm862THH94WNts2UckQCjECv/XvvJum6myhxVooJGu15iFm2LEHGNzx5VrXcgxcP2aLJw0ohOuOYNprlfTTWwGSOo0v6lfoMUPwtYgmkX1CerDSBOm/ebaKMa0pzFo299aiLWp0oMFvdPJsr9juSEkKwazMApVFPC7VeddMAHNhnBHd9d8lu8B7DKCLbf/DqZvV4gyDThgYNlBeYJXDXVJ0raXYuY0DniWqscG36LMvf3Y302XxwtINZUeiXQkDalhQp0gaVO4bRcueSWV38ov/wRPRgEDViG1hNuaHB/eOve1e2/NwbOyrazvckayDQMNDdcCrSJS7jZ9T7lA6Elr5Wptfg4cc7WXdLX4vEXicaXOCAbQexoaPa6szCIc6mtdnF3iZ3/HeNcS3TLyGSsjk5HxbpmizUGSMzdDWhOiQ8bGQ5fQrArtgOYqevotNi/IygCeDq7XL6bTPxUlOG7+PTQ5uz3VhTAgu0fHglL7ChnbALBBa2VjdiIOdQ92QgPMGK7XNtTWhna4Exzbv2CJEi1XGWfTgvxuyRURheTN22hBBMSvFDgN6TBt2osXcNEgZtFLaeptUezDglCfRNTehffhNGHOkFUOg7N87dS23XC6fr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59901d78-ca71-459e-a1b3-08de9a31fa94
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 14:27:38.3750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fLVZl3mAbdRXxCz4WxeNTVvGnDmTtD9CSMDStQexSGJtwUisqcD2LOYJZ7SBORo3/aWLuoz6RyFbAyP5/v7gH40JYO6qSaWui70Y8nhG5gE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6361

On 4/14/26 4:23 PM, Filipe Manana wrote:
> On Tue, Apr 14, 2026 at 2:50 PM Johannes Thumshirn
> <johannes.thumshirn@wdc.com> wrote:
>> This test stresses garbage collection in zoned file systems by
>> constantly overwriting the same file. It is inspired by a reproducer for
>> a btrfs bugifx.
>>
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>> Changes to v1:
>> - Rebased onto patches-in-queue
>> - Use "generic/999" to avoid any conflicts
>> - Change the number of loops to number of seq zones
>> - Remove bogus "2>&1"
>>
>> Link to v1:
>> https://lore.kernel.org/all/20260210111103.265664-1-johannes.thumshirn@wdc.com/
>>
>>
>>   tests/generic/999     | 48 +++++++++++++++++++++++++++++++++++++++++++
>>   tests/generic/999.out |  2 ++
>>   2 files changed, 50 insertions(+)
>>   create mode 100755 tests/generic/999
>>   create mode 100644 tests/generic/999.out
>>
>> diff --git a/tests/generic/999 b/tests/generic/999
>> new file mode 100755
>> index 000000000000..4ac6c0ff935c
>> --- /dev/null
>> +++ b/tests/generic/999
>> @@ -0,0 +1,48 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
>> +#
>> +# FS QA Test 999
>> +#
>> +# This test stresses garbage collection in zoned file systems by constantly
>> +# overwriting the same file. It is inspired by a reproducer for a btrfs bugifx.
>> +
>> +. ./common/preamble
>> +_begin_fstest auto quick zone
>> +
>> +. ./common/filter
>> +
>> +_require_scratch_size $((16 * 1024 * 1024))
>> +_require_zoned_device "$SCRATCH_DEV"
>> +
>> +# This test requires specific data space usage, skip if we have compression
>> +# enabled.
>> +_require_no_compress
>> +
>> +
>> +_fixed_by_fs_commit XXXXXXXXXXXX \
>> +       "btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit"
>> +_fixed_by_fs_commit XXXXXXXXXXXX \
>> +       "btrfs: zoned: move partially zone_unusable block groups to reclaim list"
> Already in Linus' tree, commit hash 258e46a6385c.
>
>> +_fixed_by_fs_commit XXXXXXXXXXXX \
>> +       "btrfs: zoned: add zone reclaim flush state for DATA space_info"
> Also in Linus' tree, commit hash e2a7fd22378f.
>
>> +
>> +
>> +_scratch_mkfs_sized $((16 * 1024 * 1024 * 1024)) &>>$seqres.full
>> +_scratch_mount
>> +
>> +blocks="$(df -TB 1G $SCRATCH_DEV |\
>> +       $AWK_PROG -v fstyp="$FSTYP" 'match($2, fstyp) {print $3}')"
>> +
>> +loops=$(echo "$blocks * 4 - 2" | bc)
> nit: why pipe to bc? Wouldn't a simple bash expression like the following work?
>
> loops=$(( blocks * 4 - 2 ))
>
> Otherwise it looks fine to me, thanks.
Disregard that, stupid me forgot to git commit --amend...
