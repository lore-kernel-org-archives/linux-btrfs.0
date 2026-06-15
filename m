Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90643F6C5A;
	Mon, 15 Jun 2026 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781532163; cv=fail; b=CJZPMu+7Mq08dSOcCMAjRnY6eutyFI22sJQCtFQdtufAEyhoPvFFnacaf92leBKkcEvNu1r053mU+biLE9x9G6mN474MVg2Veh2R583gD45Mzqh5G6jhnP5YCqCtwkeEr0IUkZCv8DbGlLvr/aykhbt4cIZcWrP0v7aEcdd9agE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781532163; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kI0BgiOffAYiHQP0Ki/579csdoi3cXgvpFwA646lM4ujSQfyT/nE4pLABkRk8txbn7hlLIjaQhyaiFSLTWysROLXkQG1EPAtC3OB7UwylnE1XCNa0MAuxlcQz3ejUo+DjL+rnKVDyg39xp3g+O3NrGzI5nDEyrBC+N7X8KhAPag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=po/UJAyR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oaCRnGhL; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="po/UJAyR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oaCRnGhL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781532163; x=1813068163;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=po/UJAyRAtxhBa8Rb13A7pOd2NfvcokC740zCHzTS8RHs2sMXrXYiogb
   fbmheE1f+rMivSunkICOpPI0FM2LyVuKWmQmduuBye1VixQhs5WpCGd4O
   bahnET5TuutID+Sdt/HxnG/kLWMMwGIf3RgxEJKKWFIX+ctBG5dR3mZbE
   N+B7ZT7xjln6w/f7Tw6j5eJ84ptq9rpmwr7Dds+1/ysoopuZ6SP+HlUqL
   MWaFMP1krqNqGEI2+D0N3dzd82F00Q8rHiAr00OP0Ev8wXZcS2BelgoEy
   y02W1aLTHKRwjGzxqyaWkV59m2iIF6pIN/HjqJSLW0EhIl43UMzUGJDLE
   w==;
X-CSE-ConnectionGUID: Vkx4KpGHSAOfEsewLxFsIg==
X-CSE-MsgGUID: MsPLLZkeQW+a2mUEI/Fdlg==
X-IronPort-AV: E=Sophos;i="6.24,206,1774281600"; 
   d="scan'208";a="147673986"
Received: from mail-eastusazon11011022.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.22])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Jun 2026 22:02:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPkuNPNe31MTezicew9YQtw9aL8QSvxz0O2SrIt51XeTOi1BBgiZYI++OAM+ITSc4s/+GldEVKh/9AeuXhqZA6Cjw24+xjbbtmdUk9lCC9HtiVunfuU39ONESJ/ujlcGMvsDwZlld0m1wvkp3Q+JxTNYEOj8RB70S1c8G9+oAUSME+uNtdjJoSPzUKnp33Ws1FPnjZAHRxkYDboHOf2dHcM6+mDn3OyEN066k7OgyeA/ENn/1iGGuZ9lAQB1jLsB7EP4P+608gqERN9/UWBctIS4fJ+R034Ea7Ta1ICA3ksQIEPVmdMR1uahPkTnVQrTNk8SyqMPRsj8PaKFjo3ykA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=nLjKAUO06QCeAhbFo2wdKa3g9SBomaXcJX7WYteO49rbQukpONguHfbeP67b29DK+V5fJxapWZgBCM3TGe+yEHghmgm55XuVMiXVE6ygjZ5S6eLXh7BsAunZsqPIoTfjQJW5GLENQ18RCwdvqfvs0UXQgtr6cmdoM6VLaEihDUZEWn7ovcE9dHo9fmR2nYpegf+SyMOg5y8zqDK/k3Ewfnuq5JF87pDXHXpaMrfI5ap6TmAJwA2qvQ+opD2JVzOnlpcHRyYGheT4SJyN2JC7qJ37Rpt+u8MZlc8ZKqA8I8SHkqr4YqkdtCHXTdkobqeYwihO8Au21HBX2Pmpk46i/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=oaCRnGhL/9x2B00YAV7co/WJcpiJGAcW4T7QMCvEbrIIV01g8A/aIliUoGxZ1ukjsTVBXPZhs/4Hz0SZ3QqcgOSLR73BpCpFVX39n3dBZHS7J08LENsXtBawdtsPXqGBYz+vqY4007Rdft9aB4QSemSU5KxbIqu+8aConKlLRuE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB6695.namprd04.prod.outlook.com (2603:10b6:610:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 14:02:38 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 14:02:38 +0000
Message-ID: <85850a21-54c8-443d-879c-f8335a5fd003@wdc.com>
Date: Mon, 15 Jun 2026 16:02:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/6] btrfs: destroy the target device when
 mark_block_group_to_copy() fails
To: Christian Brauner <brauner@kernel.org>, Chris Mason <clm@fb.com>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
 <20260615-work-super-freeze_deny_upstream-v1-1-a6c72b840e7d@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-1-a6c72b840e7d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 36eaccac-41ea-4c0e-20c4-08decae6c1e4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|19092799006|10070799003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EufzBag2E19aY9WhblsbaZBsm8JjB8GyLNrCxeVc/Pj56W1EkaiSvnDCkH1MnFrKp6NNWfz8z4+1+mPBeOktGdV6FKmv8McKOx50GMtcf33EESGlM8Adh2/ZxmtCok5dTO2JsuOAjrz7N6LbQoo9Gq+EY5NHYQaC0/btWMCKbsC4fuu2g/ffNwVcdnqjp5anBqJdW3BC3ZPtXHBKmGuwwscMjEFWrtF4p7KdxF25HmefVgiDFYyyi5LJWG87TaS4l1MioQ3Q6LTPvCRtDbrzss+s74ImgTjOwkypPs+G78QztOKYFN8qkyLgDEhdBlfSkzYDrYJmj2qYm9M/Dv3uTZRiOxIPjopqr3OdliyIOu2GXDSlK5CIzRgAK6gIee/KVm4pZXteVqcagkwYZ1hQXC9JoEXSJTLYPQupM8xx+sCJJ3kb8r09TZdQ/+VhIvMWC2rf1O7OyvCOi4sQQsEnddHY/0rhmHRdiftjhxJgJ+3SArXtcokAnAc0l7p84d+UzsS0tUDes2JcH07HOBRGsHnXmdVr1yBw43lpqHzzp3kyU96NuypgX5ukdwU/Sc320Oq9k/V/qLbth+LuZ+usj2VmA/SqWDJzfprEbzbeq6i+eDDS1fC4RCxiSE5AfewkPEHnMsRJ/XR0z8uHUi6UIayQRKmFctQrRFt9/2nmANcfIdym2RRvmc/uZUh1rotV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(19092799006)(10070799003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnhRRE95OVk5SzJsOFBERlAxN3NGc3RUTUFmQVBOMmJReTkwM244cHVsVDRO?=
 =?utf-8?B?bjN3NGkrc0J3VVIwWUI3YjlMSnhiaURuR3hzQW1HMTZScnUvOEFvZEVwdnY3?=
 =?utf-8?B?M0lrVTdtLytESDBWaytMMkNnemgvT1BDR3k0czBsT0xObG1DNGxiUys5U0o4?=
 =?utf-8?B?d0RqazVZenRhbWRtd2pHQTRuM0RkaGxOcHNybGFmUVV4LzBmNE9hNWoweW5h?=
 =?utf-8?B?bEVqdk90eVNyUGE3a2FZTEtkbWlzV081TFRlUDE4NGdxVTNjbU5zUGRlV3B6?=
 =?utf-8?B?bWJkQVQ1dEh6U2l1MnJhbm1OMjNIbE5uQ3ZLc2RGUDNtYnpSK2dTTzJudVB6?=
 =?utf-8?B?MWp3UE1lL2hOS2lZNEZ4UjU4c2ZIVEtPNkdma1g1b0lVTGN3Skh0WDc4eCtt?=
 =?utf-8?B?QVBBMzdUTXI4UlB0Vmh2R1VJM2ZQKzI2UVpDK2E1Z0E0UEVwYUNhSGZxYWMr?=
 =?utf-8?B?eWVTV0UydzBjTEhjVGFYNnV3U0M1NHFqdWdrTW92b012SjhkcTM5cDY2YllY?=
 =?utf-8?B?Q3NmbWFML2k5YWZ4OHR6NXNVb250TlROcFpabzd2bzNiRXlWQ1Zmb0NBNU44?=
 =?utf-8?B?SkNOdHZoYkk0OW9mNVNBajFBanpCdk5uTUhKa3liTXJPdFVqbkNwS0xqMW03?=
 =?utf-8?B?a0JYbTd1OTUzeWw1YUlWWm1qZ1hvZ3R4YmR3ZUIrOU1iWEw1ZTlwNW41djZy?=
 =?utf-8?B?enBGTHU2VktIRFVpeHVjYnZ3M2Y1cjVTSjhlOExGMmw0ekt6VWk1YThCbnEv?=
 =?utf-8?B?dDFtVDZXbGljTWJuS1pXVS9PM0pPd1hkdGdoeVpxTDdhK08zWXBVblNXTUFs?=
 =?utf-8?B?NEtNTk11WHZFazMwa01CQWdGUUNsbEJWZHlpMXJGTkc4VVA5Y3E3U1I3U1FO?=
 =?utf-8?B?RkYva1d0eEplUHVwZTlZdHByZCtYR1g0WTNNa3dtZ1pOTlNuSW85a1lXcGJn?=
 =?utf-8?B?WlA2TytMczcyVFA3KytiT2xTNEJHaFEvUnMyL1U3ZktXMlFQdmhLemdtN0Vr?=
 =?utf-8?B?T3lYZzZoR1UxWGM2Q3lTd3pSZzJMYUp0VG4raG5rOXY4VXJJZURFY0FMbk5t?=
 =?utf-8?B?MWRoWmVmblBDT0d1b2ZzNXVtN0RHU2ZLRXhDYnU1SGcxejBhLzBPV29zc2Qy?=
 =?utf-8?B?R09uZEFLUlJ5MThkSFZ2V2lFaUR2QStxcG42cTNNNGtkRitWanM1QUZqRUNK?=
 =?utf-8?B?eDd0N3dyUks3dTFTQlI2QUlwaDNwdUlRY3ZNVVNUN1l5RzR0eC9EQ0dQQVBY?=
 =?utf-8?B?SWt6aVVRekVMbjVjYUE1TEQ3MkdDalNSZkt0SHRzdTg3dEVGVWloVk9VNHpR?=
 =?utf-8?B?b2h2SWpJUXNOd3lpRzg3ZGVwZWk3Y0NFQXJlcTNUTTBaMHVhQWdUS2RaMkwz?=
 =?utf-8?B?MnNGbGFBNURWWVZkNmtnOS80UHNLOVZqemFrZEVQajhmdFI0MTkxSDVOaEFo?=
 =?utf-8?B?MTBSMjByek9CM0l0T3lPd0NZU29uNDNPMXlFZGRMT2tBY3pXWmpTZWtUdEpC?=
 =?utf-8?B?VGZsbHRkNXl5bG5KMXQxSDNqTk04VUhwVTBOaHdhRXVJR2w2SEpMSlI3RUZE?=
 =?utf-8?B?aUdyTlNlRzRRYVg2dXpJRkNjRG9jMEE1enVMUnhzR2pPY0x0UVVXY1RHQUZy?=
 =?utf-8?B?ZGZwNEFoOG92aTcyOUg5d3doNURiWGswc3NqOWxOcDJaQ0N6Z2ZRV3dLZ2RY?=
 =?utf-8?B?eFozWEd6U3lnSUFqaEpma3M5MGpwSDYveEFXWlZUQ0R0OW9VNnRnQVVsVFJY?=
 =?utf-8?B?Nkg1VWIwWWF4dnV0Sk9ZRCtEeW16dFBkeFI0Nnl2NkM1TlBaajFZdHlWUmpw?=
 =?utf-8?B?elMwN3JVVmpGL1Q2UExjSFl6NHVtZFY5bE05azlVRGlRcTVxdkw1eTEwK1ZJ?=
 =?utf-8?B?VFNwRCt6dmpFdjVlVUhtN1F3RTVXSnpqbHZDNEdXY01aOFQzOVRROHpSdmUw?=
 =?utf-8?B?bENwMTVrQWlOUjhKWHlkbWhmTFZJeVEvZG45eUVmeUJxbUJUVkh4amJvZzJJ?=
 =?utf-8?B?b2xSRUcvTjl1djVaTU5ZY1dCSmpoTHRXcDkrK0wvY3VFQ0hSZDZiYTBLRUlS?=
 =?utf-8?B?V2NwaGJMSUR0UW5QS0VKanRkN2QvN0lEUFBNM2xEZ1FydmN0RjVWWnVOaVhI?=
 =?utf-8?B?ekV6Yk9zTnNxdlBYQmNRWC93cEk3bXNNVmVsYnVXNnBGUmVvRnJIazRqSUFr?=
 =?utf-8?B?c2hQWEttcjB5T25CcmF6cU9LeTN6ZENNZkxMdDBqSEJ3TnBieUQyTVJPQXJR?=
 =?utf-8?B?Q09OdndUMm00aHpGQVFGelk3RkNMNUJpMElwTjRXVnZacUQ5djdjb0d5Qk1G?=
 =?utf-8?B?b1JHcDM2c2dUa2djRGx2R1pmaGI3RlorL0xrZ2pBYmphRGVSQUMxSHA4Y09D?=
 =?utf-8?Q?gzWADF4Zcs9ptutn+zt9AQ6Gj0PqFwFevT+2+QsuaNbS4?=
X-MS-Exchange-AntiSpam-MessageData-1: tlsghS6iN32fYA==
X-Exchange-RoutingPolicyChecked:
	N0Ze2G7A242MZNoayeBXO7ow46xuO00xF1HSTSr3GtXEjUvp+4qWvb3n36u6kpKX0WeoXJO1Mumzfd0rAK+KX48mTPcaG167bugllp+R/t8fJDA3wMiUuNJr81YOkLFnqFqFp/5YRwNDOmsk4qPH9FCSVtkda2/gh3A2dMI8y6/F3L0dkYp/jIxf7daP5bg5YE4V8KR69AcWLgL+uHngjwyl9LSXV6nIATvjoxUKhjnmtC9z1Ueja4DQlDdCOqLKzSU2wwWosSQ/oBsJvW02I8uuZU/fQmCi/OzckN3VrvlECsN8rm3a0nJlrvr/F2JhpAuAiBlGmReLgvYE7sGbwQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e7hvoyWHlzR6qx1f1G1EOS23wm9KyVIWXoetCLuvwy4Zv5iAfxnqrP4h9U33pv7EEMcza19fsTg4i6G6pPMu9BuZWye76PHmtH1Mv2DNjmy+oxxTfmTxRUka5MJl8ZtiR8MNrzsHdSQwgsfDi/qoTBMkSGADBnv2B0Xq+O2d5wVfUnq42buReR/whnbFlPOBNiLyozC/hBDparVcEbmugJrKWvirnwQMZZWaK+3B6OsCAj9pFSX1VuHVrzhbFwy/ko6mVqnMN1fjkfXdxI6YXqM1q2WWynrIBeb0CLTI9qTH4a8LoJIBfzMmS4tSx6wiDoVL34z+6Av0Pw4M8TTu1jzp1AFNdT0LFJ/C3YE1su9lXthKy0QjvK0Arrb2Lobz55vJi4bts2Q6wqmrDZSLUbVP3HEUGCER3QVzNrQChbzZQadGlzWR4i2Px9Dwe32n4lu9H53uK14RPJIXliMqIOsTQnXLZzaAb6PfuvaHPexAoBO5ZELmJdmh1WdPS2jeZxkYoki+k7R2qhqnJgToGjKUlqOyPLY/b2bRzln6Z+AIfkhO7Z7FrJf3P9Fxoi3p8FVaHuuDdZGosb6RNU8hv8RT2LV9zq92ih6ui9Tww7cPnushWyo3U+/Fakc/LJV7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36eaccac-41ea-4c0e-20c4-08decae6c1e4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 14:02:38.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPQA+J/02k+bSMdVWFIOxRkAWc9bcZ+CFz8TeVAFTZ26GA2Qn16h5+b5XtXiJNcVQGMEI/BtCnUZrLh5qJDwSmcTXcns99ptqA3PVCVIp1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6695

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

