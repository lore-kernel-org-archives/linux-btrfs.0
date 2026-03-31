Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3F4395260;
	Tue, 31 Mar 2026 08:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944852; cv=fail; b=AmeeqJ/djSdvC520qDSgCKhUkJRrmkT2FGsTrCX72xLm1C92syj3UkzksYquHdPFJL7UhKJFpIWg0p5vMGtGUWZh60+LuEfmxppvuVOqrgDQSU8axBWR05LZwXmBQF0Ch40Nn0VqF5OKMZ1kMqO2VZGOUj1uuKbjjyMiKuUXziU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944852; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GgOFap3hsc9ftYlDO0pypmyEazQFG2bdm10/QOTrsiRLpORKf5RDcOUPZre9ZEWsoPAUcnAA0WieGmN6MFmT3DaLoYCIeLRql7dmkxqe8hqGUOEx9vOAUkNDtPtKLPUpPPBJKqZGOzKJn5wfhOML0W3gVcKP8B6Oxn3IOC+24RM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ADVVHd63; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ITfJrydW; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ADVVHd63";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ITfJrydW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774944850; x=1806480850;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=ADVVHd63wZCU2OXdHCzG/9jpSK7+gaYQHKKbnMUs8mME9wOi2Rm13X+I
   mVpV51T1miLSg1c+dzbtGbTcoxr0lqW5cuKS0WhWna2+n1bP8adc2HEEW
   yLNgtMsPFdwaV3+je11gdjDIuL7910zHLwpa1HdWj+0JyizZHQ68Ryg+x
   /9MOvLk8SiIL1xKqejZIJUWdSxVbftbNqIwwk5AS+jMJ/dHbqVwCSgStt
   y90P0zp0OPeY0puu9WfF1GSTusaHZhFR/E+Prc4QSe1I1Sll21XxPb6Ae
   aNRfF/fGzuHYED94UsDkbSbI8lDcZGU/SRjkl7rsF4YJ6qGbwmXVuAsKG
   w==;
X-CSE-ConnectionGUID: BhhfOUlbTESYz6Hl09af7Q==
X-CSE-MsgGUID: 5ODk///ORdSVb95EUyOt9Q==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="143144045"
Received: from mail-westus3azon11011059.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 16:13:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gGEwqc9rJzLYpz3PhtQmA+q3ujdq96kl3JgysU6PasIH3fh9lX20LTwEPl8wifI2bwRjopPBEamD5JtfTPViyFFkOS3W7lkWIs8rkHr71h35O+Canefmmy2XANqAKdGbN2gNMH7edUbJfW+04uoRFgaigxnpZNANbVnGAOrnn6/sAJ3VcVDTr5SSrQ0W5/swhDcAsCRHrl/6lpdDrcSoy6aZg20Odm+CfOszLYltRcOjya6utUgscVFtq82KOdb5nS6PBw756NIevny98UOXfSpn+EI8+GxBb+Y3ogMGUfBMXS/QcTTlWc/QYIO4yYeLdnPgqvS2uqjK63VYXdQ4QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=K628blP2wxBsePCRaV2/BmmAsOaYeLJyHP8sP5l+RHvIG0YzJEdgiXmaFY8WmngQARZ15EhqmC1OTqGSyof+QgRBy7hiSbQAd+msl6s7Zw6Ur3knrI3Zrnf1iioSGFQ+FhqAUOLCCPl4Lj/s8tenuAmn85BgK6Io3y01jRhTniGEmfOu8+6QmuvWRjFuy18RRI+DQ45qDM91UEw65S/t84vq2FhgRf78eGbdBx1xamzYKPkaAEnwEpSI22pXyxuqfpbA/Pfs5nSfhu1IxXNumjXzrRBcKCYrqN4VS6B0TeNccwGR1GqQXd7BADgMBMzrODqKNTisOO5gH5ID6h4y2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=ITfJrydWz/DUmpa/qZnZ9JKLaY7wCuQJ6o41QmFNiomr00xRDbQcgrMWJc5iN8lJgELjyMmYlI1uJtQgKks7afzU5jXPiCVFNm+wyXvFYx0lv9q+lLer9cEBuSPuYdOvbU2O4L5XjZo1es2o00hQpUDLFV18o04u6hb0Wfa3jDU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by SA2PR04MB7722.namprd04.prod.outlook.com (2603:10b6:806:14c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 08:13:00 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 08:13:00 +0000
Message-ID: <df29cc73-c972-48f3-b323-b0482040885f@wdc.com>
Date: Tue, 31 Mar 2026 10:12:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix silent IO error loss in encoded writes and
 zoned split
To: Michal Grzedzicki <mge@meta.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
References: <20260330160644.3678224-1-mge@meta.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260330160644.3678224-1-mge@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::18) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|SA2PR04MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: df20ec0d-5987-4b92-e563-08de8efd52a2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|10070799003|19092799006|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TxmfzO2Yc5wE63Ns691z5ciJbvWm4IWn5/EPltA6v00pWlOgFLz0qCr343RQSULyR93+Odtpm21HGW4KZwOwot5mmgeZLfBhgTDNvz7AcqWd395wMwWkh7iZzJskpxGPT8UvzZQDjx9Ob+y8EyTG6aw2ZP5VZvWoNiHUb9mCPqB8CGhKphpLLqOCJotgJ+g/4pBEbYuZ6dudBsKA9NdhOqoZINNrk73sG5TBErJERTl8WAFIvSEBqXqVJvpHSJ6fJnyd/xmiFbwQujHprf/Fb6hZeQ/92lfYGzZrC+/axhL5X8v4z6Rc2YE8hMHy6zQwr/u/qv+Bz6eAosQOVO5vIJZPqY5wAT2aiTHLOZm9nFh3jmnKMMN+tPnuTIV7dL3V1Lcpo++vr36QMdag+GnnVF7WJoSft9cm0gaUpLBKD3TFKUIEeEHQwZw45J95hO2YIajorDVjKZJCnB+kFch77ZPiautdaG18qo0Gn3gQvELwbJudw12j2tQ6DgQIm4F/RugIA7kKacVG3bRt6tQGfWKxcepz2+AH2E9wZRb0sw6CkHRJdizcnwZPE4CClJqv4RlohZW2KLfIi1A8cpISvR47LQXtxqEnAWQy136E3aKwhli1HcIC2c3OflPLnTFexIC7whz9bNxd9QqrS14ZI0K064m1hallERBov3FyHfcVXjatsLQIT99gHgdC4JeCy3KUklYxAjAJsJN35yjfJ7SEPwT/Oxt7nn2QD49cXw8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(19092799006)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akdSUTNQTTl3dSs1bkY2ejJoRlFPUkE3NS9pODRSN1gyRzFmQWRiZW1MRXUw?=
 =?utf-8?B?MGV6Uk9CMGNsL2krV3RBS1FONmRSbmhCU2J4NWgxc0lxbEVTS1AxWG5yanJu?=
 =?utf-8?B?aStDVXIycEcycFNIdXZ0WXg3V21GZEV3MWx4dFk3aWllL2Q5OHpDellrZ3h5?=
 =?utf-8?B?VUFoU216TkhtUEU5N3Z3bzFSdEdBVXBJZEpuR0YwRlpHOHJIVFZ5cCt4TnZG?=
 =?utf-8?B?QTJnNFJPTXB3am9jTnBnaGU5dW1iUFlsZHlkZTQzdjJNM3B2NnlMMVpWWUxm?=
 =?utf-8?B?ZGdhTG9Ja3RjQzg5UFJvRnVaNGNqVlJqRmp6MmR4d3hqYjBrdktEcWFUN2ZY?=
 =?utf-8?B?NXBialFVT203cHd4WEZNemVHb2huK09yaXhZMUo3RVlmSkU4V1NIREZ1ZmNM?=
 =?utf-8?B?ajJlYVFZZ08vci9IcklJNC9iaDRYaTdkNmRTQTBqUkRENXlHQnBSTzR1UFBV?=
 =?utf-8?B?czBnU3YwZDJFK2RBTzQxT0pLUmQyZEdIdEdhbUZHTHVHb29uMC9pdXlhUnlj?=
 =?utf-8?B?cFVsYWxiT25VQjAyaks1ajlEbGh6Z3JVR1B2cU5rQVJxbVpWSWZ3TXhpVDFa?=
 =?utf-8?B?QlVyNTNIWnJVRzNnLzBWRFkzdzRkSkl1bm1ybmxkeVFLNms4c0FNZlFxaWxR?=
 =?utf-8?B?T3VxMXRXWWw0dHk2ZjBETXA4aTFYWFMzK0lsOVJxOUZsbWoxaHhNWTlYbkph?=
 =?utf-8?B?OGhtV3Y2bTc1OHpkOUZ3U1BZK3hFR3U0NkxnOE9VejR6OUY0c09NRlhHZURu?=
 =?utf-8?B?OEoyclUvdWpKTGxicXZwOXNNSURCNzhIT3hIY0xoMEtIYWc0bU1RMFMxK2sv?=
 =?utf-8?B?a2c5clFRM3daN09JK1hCOG4wSFhCRHNZZzhIRndQbXN4NnlSbEt0R1RxeXFa?=
 =?utf-8?B?dUV2YU9pU0VFNy9OaitMNit3dDZ6TFplbmVCS3pXYTdSbjJvQWhuOHU4TVpn?=
 =?utf-8?B?UUhKOCtUaVNWQldOWXVDQkMwVFdaWTJDdExURUl2SDdvSlNydGQwSHpKUVJ6?=
 =?utf-8?B?bkVLRm1zeFlYaUtiVEJFZldiRXVWb25qU0k0WWUwcEE0ODJqY1ZTMU5Ua3NB?=
 =?utf-8?B?anBEUlo1QmNZbm1VV3FkYlJUS3o5Um1KVWNjcjZWL0hJeHRBZXZ3cXFhcEFx?=
 =?utf-8?B?WWk1cWJWODcxSFpPZUg0ejI3MTBpbklqSVBpNktXRmFwbmRad2pVTzNkZ3Jr?=
 =?utf-8?B?enlFblhOeXpEYXNGZ3RRd1JoOG5FWCtobVZXcE1sOGVyeTNGZFpSODdvYkFv?=
 =?utf-8?B?T05BZytnZVdSVXE5Ry9Cckx4QnZqaTVnMVg4Ym9pNU12aHFoQ1kzU2szTkFt?=
 =?utf-8?B?U2ZQV1JrVGRjZFFOaGd1L2RNQ0txSWJxcjluL2pwT2NKaVJ1TWlrMGYzU014?=
 =?utf-8?B?ZjVkOXN6QXMvbnhoMTFHVjNRTFBBZFY4L2ZDNHpJcmxIRmwvYVVNTTJkK3lq?=
 =?utf-8?B?NUxzQUhXaGFzOFgvQ044dXdmWVJublpzL0tveEIwS3o0OGJWbmRhVElkeDNZ?=
 =?utf-8?B?ZWJ6ZXlVU24zZ3JTeXFOd3V5cXY0bkN0ejlORWlHWWI0eU56NWI5L3hyVkhJ?=
 =?utf-8?B?cEJ6Mmh5cE1tSkVQbkxNb0lhMmRpVlY0SCsyWkkwVUtHYTZNUGtNbWlLc0JM?=
 =?utf-8?B?R0NKNW92bld5TkZpNkpmT25ZZVAzS0FUNWpvdnN0WnRLenQ4MXhXMGxCSDIx?=
 =?utf-8?B?ZFpnbldzN0xnT2MvQ1hUZWM4QnpXYlV2bXJHNmM4RE1ZMmViVDc2MndDdmJ6?=
 =?utf-8?B?U2laR0FQVEhrZjFqUGdtN21EbmtoTEtQNkNXRXNUQmtDdDBNYnFkYUlaanNO?=
 =?utf-8?B?T1dRUmw2R1RGc0xkZ2pJRGQ4YzhnbG1FZUZrNm4ya3hPQ2lTcmszSVVFL3l0?=
 =?utf-8?B?TGhNZ3ZaVFZNd1BIbHN6aGZuSDVqR254c0J4d3FpNStOd0lLcnRiM1N3aFYz?=
 =?utf-8?B?dCtUeXJqYTJUVHFYUlAvNVd6TnFxNW9haXRLNGhFVU1scUg5VDdmNFVobkcw?=
 =?utf-8?B?enh4N2hhWlRlamRCNnhnd1NlQzMzSVJzUWwyQWU1UVRpaXRjSFhRSTU1WTRR?=
 =?utf-8?B?c3F5eDIzUGhHcndSV0gwOW5HVTN6YVZrc0xsTFpZMG8razhmWUpoOHJwbkNO?=
 =?utf-8?B?eHVKTW5TNm9PVmhDMk1mR2hSY25tNUJWbmMyZVZrUjNVVy9PKzc0d3FobWhI?=
 =?utf-8?B?NXNRNjdFYVlMekxWcFlJaUxSQW9BVFB6bUdiWkUzOVJJb0tnMnJ3QUFiakU5?=
 =?utf-8?B?ajk5MGxneUh4MFRkMzZZVDRhb0xNeVN0TnhyZkZqenQ1RkNoT0FESWJveEhz?=
 =?utf-8?B?YjhoWnpMT1BUOTJZSVZUby9mUEJncitmRjJkUGRlRmUrNFlpalptNGRpRXlT?=
 =?utf-8?Q?jRmT3H7X5PoLZ1j08+IuoJM/fTIjjbPKMo8KuSKLxM5DV?=
X-MS-Exchange-AntiSpam-MessageData-1: bSoFusIjHkwzXRrDYN3JZstN1RIhtmKHox4=
X-Exchange-RoutingPolicyChecked:
	etL7vDT+GUhZsx51zxcRAFhpch6L3mt03ghe5I7Cb7KtzTcif5zl1X2xnfQ01ufkcZwVITudrJgWz2H/VFafWwqw3LmRWLW6m2jW0v5JzQa7Qr1LAL58FoY5b6OjJEILDSLYTe6krvwOHoYb0GHzLbQReNTmZmyj23ZWK/GKhjyFr8V2RRMdoUpI6Uo2uNmAOUl8B1u0zaQF7zbegYNVL3PGNFsxUgLC4mFckAcg7s0/+mKamANSc9twhYNw3TBXsnYTd4SniJTVprct1/Ag3H4yTUxKDyHak881dKj/YjEYrffLGk6EcBDkyMBnGeru9BzupgzSVbconC1xQ7VhlA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Wd9s8JcYftqKQqX3EIGE+JY4OoVg+4zle0C3/DIHnfHHJbSJ/zkYRjpZyBKrdB015z8hzUKPImKZAD6eHCbn8683xvKB5gm7rMFSzWrjgRyT/BqwdGND+OnTwQ2vCeKaM1zCgh5P2/EIjHMsHP9RrOb+V++zZKCUl9fUx8laUhh3HSMmYwV9tKt1o/Wcl/njVok/oE929Z27Ks9HHyRx4Z0LVqJ6gsW0AHLTAGphcQQ3ruY2kZfQ7tw3iWhWRd1xPhJAJ+UM6JYYyxhZjRwd1XglJ9/lW+FqsmNCSjOT7ZDm3cgH1j8U3EmKfa0Tdei+6haKy3MX89Gw2neToRg6LKj6My9W4/WXjFhcqoUp5VwZ2o5d05Rbw3YlMKJycZuiysdwLZd4gHS9G5+SXEpDjEMU6WzWTAxncsbc2BM4M/uhqYyLuDx1LSVGA/b1zqXTOoVRrK4CiXm89vbaaaLNLoqA2Ba10F/17sX1IGBNplB/0ywm1FjCJqCcrfX1YU+H55oKYGBDPa4VNWkM+tA6LXs3AZHFemo9tPn4nuO4CQtFa7UAahRAxd6wIib1+WlVh5R1k9WDyl9TniGqXKH6GvUCqkdyguh/fXt6lBmlJromxgKZdXnBNDrj+RXnZSnB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df20ec0d-5987-4b92-e563-08de8efd52a2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 08:12:59.9964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rr9CJ113pLpD2v2t3qzR0LZkHQ4oSleCX1i3Nlvv3XtH1mXKB8JDkzo8QObtr/GxF0ExHBpOQaKNqxemcF58NoQIPBZiMm5Yjs6k4ASASjo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7722

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

