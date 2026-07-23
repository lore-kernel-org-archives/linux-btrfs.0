Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CD1474256
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 18:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784831624; cv=fail; b=fiLYk+CPyWG59JoA6pvcpi4lhY4LmpkQtK45P834NtI5STnqCPIy+C8Rsglor4NTZmePF+rNi6dpbbIAwCyReTeQD2FAQWQpU3qPFtwDpKravR8K6Zut7ak+5mONSMEmSrf+3keyVi+uO94vJJf2WuOqLg2Mt/tyCoF9ohy0nE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784831624; c=relaxed/simple;
	bh=TozNEQe+izJ+tnml6EEmrA2PkyBbX9qESuU6Zob5XkA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s5LxmoBlHHpJxSJnt2jdHUrmq8ykUoopGRhR/6Bymo13xww3TZADpWDt4FZfRKkD7UkBMeU2OHMa5x+XaddnWPEc7/yaRWrFGq2GmmPVYlZksA/MrOmsDi7i1CmjbSPvgWC8/m2AAU4EP/F4e7aQj/dJkqpYKW2Iqs3vOmwaPp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hJebWPba; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Jzf6KHSJ; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hJebWPba";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Jzf6KHSJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784831619; x=1816367619;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TozNEQe+izJ+tnml6EEmrA2PkyBbX9qESuU6Zob5XkA=;
  b=hJebWPbaEss93YOV05o1CEE8IEgSYZCizJXYXC+IMzkLCHc5W9yAKueW
   y1oj51qWXfqtTz1Wu8ROa6KVbxlC9MYVjgsoh1utQQCPpq38pvBddz7Wh
   eZ8QsIr1Ce85u6KrxaF6eBA7krZiNX0uQMykzkmIBlE40AQ3+N+1hhFzG
   2L5s2Jo+EWQu1GP2oinZ9GN5g+vTK6uIa6DE5mgdyQB/hQpIeaqabRzbl
   bQzeXqumdCVdkX6TOOKCclJSo5EzDvfifOS7AW1lPk4At+YNRJxWxEW8p
   DSh/gBYvASlT5HXOkswLh+qG3VpO8fJXOdcGJCQwk+hwtOr6CtK1QlMer
   g==;
X-CSE-ConnectionGUID: SJxvfFV+QqivS0106nj0Ww==
X-CSE-MsgGUID: 6eUVLl6rQSaF5dgp6Xzibw==
X-IronPort-AV: E=Sophos;i="6.25,181,1779120000"; 
   d="scan'208";a="147487073"
Received: from mail-westus2azon11010000.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.0])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jul 2026 02:33:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0blp+ZNBKAITg3K/Z2kWGxxm/k1EqPr/1O2Iuupgos5UU7kuqhalYUlDxHgFFs+IqsGBKrda+PdOpisqGSeqCR+k81wierevYVtfvWE0b+xoNGagJPnB/261C9sB0ASwfXydrgKcEesBHXpjVBICNidGJipkB/BM3ex3B7RdjPY15gIPxW+fLa0OcHTwEJ9TPyJb8z5ef1i8HooIlQyxGyuv5V/+MqNBTKdkfpej+3u32iyezTrG/gORqxJPW5GN6vUJbD+3N09WMpoJpCA61VXilPpzUT8k3Vn+StRSQuC6uhf9XBqJdhmzxYxRqj4G2qTJVQmjqRLV6Y1lqFjyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHQGFtOgAbIixzgj/fehLWZLB1QWCQZvLwy6v67wEqE=;
 b=I4Q7/CFGblZn0Rxj8HqNZ1OSsF7S8Wt+i0KEqovaEHMqO+UJ/oj5OIXfs/EIbXZNWrHL9y536y4OHV2uaoSUJgvoJQB6d9DKQ6+ArkrZyxvpe0cl43PW8wMyIQwvAPg0NV4kRxG9zPffTaENONundv/5jJt21cLFzbhbSfKz2ez7x+MPgMOLfLGf5vrM3fnoiUKwVsid8GY0/SQS/s10Toa+ggs9JeigXOlixYeOGdQG4deT5+IEOLBaw3qLcObNfnj6wjgQ5ZaoaS/tGFmFInVIBP5EGsDCxB/nzzJ8BZp7qsOhdKZAlB/hXVIUc6TJrxm1PK6Y84zFEgvkONtSAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHQGFtOgAbIixzgj/fehLWZLB1QWCQZvLwy6v67wEqE=;
 b=Jzf6KHSJ6a39Z0Tna3P7tTpRK4OoeGc/YiS9DRnFua8I9G57juWSnU4GRqJwSh2ZEAFYcTmpXF8AStJju2wjgTWF0X6kegLuEAoC1Ki5+6n4VA2GRdAZXhYVm65jkP1IDiRdw5ZoX4K/dha9xsa28nCBMQaarY+oYhiWUC+hnJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB8117.namprd04.prod.outlook.com (2603:10b6:8:c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.11; Thu, 23 Jul 2026 18:33:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 18:33:25 +0000
Message-ID: <46c5eef9-37de-4ec3-9aac-7962fe171d1b@wdc.com>
Date: Thu, 23 Jul 2026 20:33:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] btrfs: zoned: don't clobber the extent buffer when
 zeroing it out
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
 <20260723155428.94187-5-johannes.thumshirn@wdc.com>
 <20260723181830.GD752950@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260723181830.GD752950@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: 52522b69-7090-4c0c-5385-08dee8e8e1ea
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|19092799006|23010399003|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 15vtV0FqVLlv0wZVrEQh999tz+KiEZ85a0MOOaoIhV2VESUpzo4p2AB5rBwMU737VIOk7ARZcZs1/EqBoAWUccq3GykzMGlniR5KISXmJ5yQs3G2YF+wNrd+wyMaDuoIZh+SYUuvqUsdkJ8fvzGYei8k3rHsfWxYP6oG+uE6d7qMGVaNXHkxcdvaFLLcK5Gd/nB59M4UliIE0Rzne+VH71r9Hz4NcwqrZWLjlGo+OyaZyUJ2j7QUFSvklB/ZCvnTSRdONezQiCI/Dj+tbA/OInS4XWwlWi2MLFwtDmaA7FHZ7+6qn0jCoWDCrNW2Afk2oUw1iFFCiiCV7f/S4weDX5au7o2w3b151yJO9lbBSokiKLOqgnF37kSwRAc3bVpS56foFe5sCwdCeLgWJeRloCtRpzKZ0b4d+vb5wqQ4ykurLhJk/b9POyCUdi0bz29CJs41TAhDnC05wURIjkCaBvivYh7tyx0ctRS0OxjqMOkIjGZy/7sbIswvgsby47zo5Ovh8FavW3RElxwhydzgF0Lrgpa/QUkfm+NeC02h3ESoDnoZufLYgZ8uvNh2jKgbVxQYZsAT5Pt6ychA/T+5YoVJgv9GTSBGLRSgo6ErJqNehZ5ilajvzWzMR7qN2G75gEmq+g/qrliZB5USBGG6Qr2Fkn0WvU5S8+Kxo7wbTPc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(19092799006)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UWd6amJhR01qd0JpQ1FxQnNnSUlGL0VOQnJNdVlndUZsdkdtZTZpNVZBeFd6?=
 =?utf-8?B?VFZjMHJuNlZRMkNGamZFTHZTdHNsOUhwZmF4aXI4YnJaOVZXeE1sYlZKdVV4?=
 =?utf-8?B?MEk4NTVDTnU1OGxaN0ZhVE1vK1NXaUhpb0RpckxMejdYN1FzZmpGbHR1NWNU?=
 =?utf-8?B?a3c5S3kyMkoyZ3RqMEwrcXllYWRESXRSYVFpRU1ENmZqNklNdVlhS1VFSVRy?=
 =?utf-8?B?YW0zZzUzWnNkWFpmR3JWVEFUSDJCTHRwM3c0RmN4M0lMelRxY3FYcGRKUmdz?=
 =?utf-8?B?czNDNVA3cVlKdlVSWk9xN01wZzQ1am5tdzhPa2NRcy9qRlBGQjc5UXljODcv?=
 =?utf-8?B?bHRpNHVCUW5uMldLYjRwMGdwYzdUMWlvRXQ0WWJtSXpyWk9HZmJqSmFrV3Zq?=
 =?utf-8?B?a2pqcVk5Z29HNkhWK3pvRFo2VjdkSUZDbTMwRU1Vb0VyRHYzaHFJNG5yQUhZ?=
 =?utf-8?B?blNBbk5zTUtLQUI2dFcyZU1GVmxYd2JIbGF2SnV4RlIyeGt2SEdKTEgvY21T?=
 =?utf-8?B?ZmczS1hHVHpESitkKzM2cHRnd0t1SG5sSVJjemxVakM0MHQ2UjQvOTZWS2p6?=
 =?utf-8?B?eUxMMEhWaFJpaC9oZ2tiYVBLSGkyM2VvUjhncDByUnZSREx1QjBHQzVVell6?=
 =?utf-8?B?SGExRzNsbTM5SGJuMVVUbGJmell2UVZDZUxUYmlLVGJoZkY4OTlaUllEdklq?=
 =?utf-8?B?T2ZubjZLSklsNXlZeTcySTdKNFF3aCt0UzhLa2dBWXZ5UWFrSlF4OE5maTVm?=
 =?utf-8?B?MU1CK1M5dkJJdXRZeTllTjcyUVdQdUN0d2JMOGZ5VmtLc3NaWUU1ZTdmRXFQ?=
 =?utf-8?B?NWdxTG93bnNDenFzRitCK1lLb2JLNUt1RWIySHJybkFreTQ0MU9JR2YrYkVh?=
 =?utf-8?B?L010QjZqU2ZUODRWeGpmcGZkN0J5SXNNTlZneUFUd0NyUmU1R0Izci83cmJt?=
 =?utf-8?B?aG1LYlpseWQ4RlVpSGVDZUI4Yi9qdzdKdEhPQWZ5RkdETVBDMElUWG1HdU4z?=
 =?utf-8?B?azlXNW8yUGIwYmJSOUY5YldubDdScjhoRE1Jc2VlNGdudFB6em1vTEl5QkFR?=
 =?utf-8?B?SmFjY1M4VG4vbjNWcjl3L2xSUGltUVRjZjZvSWVlM2s3bk12a3BEV2RXMDh5?=
 =?utf-8?B?MWNmcURiSkZyKzFYckV0MmRDV3N4aW9lYis0YldFTk5LcDV3cU50T1IwRjNs?=
 =?utf-8?B?OEdETCtBNTJJR3Y5aWx3MGZIcEwyb2F4dFFuaTNabDlqYnVoNnhaMFlzZS9Y?=
 =?utf-8?B?MnJCSEJlMmE5QmNqVFR4NTRadjBTdVRmWjh1bnpnQnJBdHRRWG95aTA0MFZJ?=
 =?utf-8?B?NHpJZ3dZUWx6UlRhdXJQMytDc3NvUHk2YnVTTlRCWkVEMGxKYTZCQjlVbkZm?=
 =?utf-8?B?QUdRWjgxdW5pN01LUU5sSU9DSVdpT1h1ak9QTGJmZXRMSVZkMC9zZ2VCR3hj?=
 =?utf-8?B?NnFRYjA0dFRhcVhCRENsb3VkR2ZVQTYrRmUwRkJVaVFNeElyOUk3R3NNWmJm?=
 =?utf-8?B?eGI3QkYzdmhUdlUzWWVuenN0ZTdYdm4zQU90dGMxSDNUbCtTN3J3NzNBZ09x?=
 =?utf-8?B?TUdGSjhBSG9SSitpTWVNbHNmL2FXUXRUenlvWDRTSTZLZThSWUZjdkJObW0v?=
 =?utf-8?B?czhYamcyTmFhRmpnZU1LMGhBZm9LYXRGNlFtTjRNTlQ5dUdsZm8yaDEwU1lQ?=
 =?utf-8?B?R0JOUURwSm1PZnBEbHU3T0F3SVZYQ1Q2cWZ0TUpDU1lOQUpXZUV5M0gzK2ZZ?=
 =?utf-8?B?dTFCQUFwSlFTTnFmTGhwMFJEcWIvVU4vY0c4NFBvaXdVR1hCaWdqaDdKL1Iv?=
 =?utf-8?B?cW1uVitDS3ErTjh6M1A2S0MzaXp6S01GZU1nTTlxWEk1aHVzWDlYbC9QNWJn?=
 =?utf-8?B?N084aHlzeE1BSnIrNTNZUkdZY0YrSTNXTVRpUXF5REs0bElMOWtmRDRFb3Y2?=
 =?utf-8?B?WkY1THlrdVRKbzl3d1FXdy80M1JOUk5aaVNwMUQzK0hFZ29xSWMxMGE4YStE?=
 =?utf-8?B?S25GaWpUNlhDc2V3UFEzUGpZZ09ob0dtVW5FRXcyVjNqdVJIblo5Y1VOWUVm?=
 =?utf-8?B?VVRieUM1VC9jZHQ2dGxUbmIzZ05rdDNQUTB3YlpKY1V1SWUzTUtOaDRpWXVC?=
 =?utf-8?B?WUJHbU9oQmtVM0lVTUF6cWtGb3RUZHhCZFR3QW9oK1pSZ2ZDZXI2S1g4c1JG?=
 =?utf-8?B?OGtqYktiUFVRWEhCM2RUYjBjOFNyaUhkcWFLcjUza1dmT3JrNUM3SXFSa0VV?=
 =?utf-8?B?QVdHekFyWWtXQ1JkQnlzaW5pSEUyalo1STJJamFDeHRCSU5kSFJINTNGcG9Q?=
 =?utf-8?B?dm9iQStKMGt3QzlKOEt2T3RlWUJsdGdjUWFpWCtuTEdYVEw4SmRSdy9HZncz?=
 =?utf-8?Q?mrmwdPTj/MyCe3bu7I1vgiUgp7Yexi5lr5+VKCWaP4Gzi?=
X-MS-Exchange-AntiSpam-MessageData-1: rKHKQ4MhIHi/TlKobg8LwTHT1T+DjtPZlVo=
X-Exchange-RoutingPolicyChecked:
	QuDfwuO8g5hKLiv4D1l9zVBJg05NIUqbdGcuyCz28jvEyl2Pb/hP+Tm709rZH6XZ6Jf0C9OKcNgPtPEPaTNDlAVhHAXZ/on48tBW5HtsOakyzRWabhq9C6LOUiluolySafGd8BK2L36VNOciSmxr/Mv7ERllzRixGiytHiilKMbz6leWWyRq1646AHNbtpAF2wPymUuYaNU5AJ5AOnKVdJGj4qoYyR1DmwdZH8d9YltJDdLck9DysRaBvohSnbP7dZoumHDhFbFscm/KkjZq0fVwoo1e1bLYjgNf3EZiLcBg0ZlfWRRBaCFOqg9RPZQ6ZfTD2m2AVVjAqtbk0u2WXQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DEmZRC4ZeyqXbvxDIONmApMtvLhUpJaogFe5gnZxt/eALM6MYAXFe1ZlY1qnZc90G9Xx64IboxevmNDymf4b3yOb5Uf94jQAOl59raZRs8dM+DS5ieI/MqSMGxOZxBBA0Dy+tXPkbIWz+UfSkVVfBkbcTgWzkZhz9xS5aT52WtLbDzcYmvieFvQKslwpR8rMHGGAf2ntlU1BIV+TrpONc4ulLRpyVpp7l5kf4W+vTIQFh+ROm5yEDeU8efsfh4a3rKQ94BRBna45dwUjIpn9ye3PcGOrQoG6NGZBXjMVT7O/Ex2sxvbGvKyHIpzf9cAyGJUHVWZzxNAFx+dy/yN3uUk5CdvBhZ0JY25/yduv8b5qqhmh0FZdYTqJxCSJ9xHVY3n7WIOBHwkERTnU+7DEe67LnDjVnj9XQ8la5eOn1t9hItpnROMMC4AYfHvEREQwh+y1i8aX2beVqqDDFK6k6WRKtMUpgo5VqkNsugFO+PIdUzl3zyzqokkggQjlmGFzhn5F/3opZYJW9la9g+ZquhMDBGrwz16XvDnKBYI/SsLxicQ15muPK2ThelvpNrPHvaqS2R0boa09xISnI+VKtdOmurIOd4MsXRN+f5fm0s2ic+26VzhUnYauY1O8j2Ce
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52522b69-7090-4c0c-5385-08dee8e8e1ea
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 18:33:25.5748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1C0If0qn8Z+lsAg47ZkGdP3pp+Udj4MNWXLPF/qS2V76Ah4DVYhcQGfq+oOwdRJ45YPM7/rFTm3utBgVtPh66jMpniPjWL/OnlMBUzF4rrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8117

On 7/23/26 8:18 PM, Boris Burkov wrote:
>> @@ -2334,8 +2338,21 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
>>   		btrfs_meta_folio_set_writeback(folio, eb);
>>   		if (!folio_test_dirty(folio))
>>   			wbc->nr_to_write -= folio_nr_pages(folio);
>> -		bio_add_folio_nofail(&bbio->bio, folio, range_len,
>> -				     offset_in_folio(folio, range_start));
>> +		if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
>> +			u32 off = 0;
>> +
>> +			while (off < range_len) {
>> +				u32 add = min_t(u32, PAGE_SIZE, range_len - off);
>> +
>> +				bio_add_folio_nofail(&bbio->bio,
>> +						     page_folio(ZERO_PAGE(0)),
>> +						     add, 0);
> In your opinion would it be better to hang the zero_page off eb->folios[]?
>
> Gets rid of this special case but might do something surprising /
> unexpected (or just be a dumb idea and not work at all, lol)

Interesting question, I haven't thought about it. I'll try to think 
about that when trying the active bg first write.

