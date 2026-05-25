Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262DF322A
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 02:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779676576; cv=fail; b=fDR3kecQSpRkF8NSNNq6H45M/DEkYbBVW4MvhHhtBwKsdX9Lh7LBWdOG3f/9J8Of0YFQQ9jp2DcWgJZ/87WmO6+rCyNIalCFjT7TdEdMA2w6JzM0ZcebF5IX75PqlKaoK4obZXjZWmQU+JIcT4gHMZ3qJW/z6mUswbRC3ig1284=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779676576; c=relaxed/simple;
	bh=yVuUn6J0mExa8Xsh3I7acQbpW82YZ54LdZl6P8ZBUAo=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=VfqkWgoYrZEQvVCO9MC6GyD9kxH3KRFdTEwD+eHldJ/PQZW77rYPHavRyKXr1DBL6RkYiEO6Dxm6MZBEdjpudGx6Ibt//9uZEcdn5ED49YuNTmV/Q3z5T2Qi37n3HHdt+nBpU0NbVW4w0jYdwajGuWNvWr5rGgAVqmh5aLni7XI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gUdcB6hr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=f/h42O3Q; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gUdcB6hr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f/h42O3Q"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779676575; x=1811212575;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=yVuUn6J0mExa8Xsh3I7acQbpW82YZ54LdZl6P8ZBUAo=;
  b=gUdcB6hrG4yNZmRToNekvQAA5BQ4ZA59EIS6LvlETgq2BVwKegSVAe0B
   BkViY1ac4Fc0iW22lIvokoueorACQA3Y0mi7rrcuFd4jkAVk/6UO7f1TU
   vMw3XVtWn2G0cfRujAYVDnSCIKFziT1xgAqTaSfmGVSjx2SjNk79Dqrc5
   gNXpCK0ub9R5WhoDJYDyLwpQTS1b9GaNYQpH0SGqQcudfDfZ5Vd6ujYQl
   RkflPDoEv63PhZ77IhPtRjNMEs1kCVGIfD/KMslASOQHL8gKd/OBgGYGm
   PXmhPMonwkEH8e3+fPUuGlP59Pwb4MmaVdMXFwbbxM35gGEJ50FM4Sbqu
   Q==;
X-CSE-ConnectionGUID: Nw8kA5XYRwikH0nxRaf1pA==
X-CSE-MsgGUID: w+YQ1RWmTIOvdD5UD71FKQ==
X-IronPort-AV: E=Sophos;i="6.24,166,1774281600"; 
   d="scan'208";a="147667688"
Received: from mail-eastusazon11011044.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.44])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 May 2026 10:36:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jusYNTzU4rpHnODjmr7VTcQVgl5FRUflbZi2zE5uK2jAysAHfnPtQ52/LokIU4rfMA/A8KIe/WAQYxaNHujeS5B/H4gydJUj+xUE28Y7kHTzl457SfJG6v0CMN+7rJ9/BokTzyINqSYA6DQeqiu02YlsQQamg55RkQSetr9NjCWVHv170dnwi2EQ/5dQsxBPxUSUwZuwWd4aFSi64aVCxF1mKpB/4LaQmU04bZqjpVUe4+dDspCyy+8nRLU2SO+AvnjaIQvFL1+fDKS3ntm2gf9iMy1ULkuuo4p6EQELPWdlrMy3OHnpBD9zAYJ1hKFBvnDv2ykGGXe3aZe6Y1BQrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28Zjk9BjqAOH4tnJ/0YY9EMvU/kgpVYqLykWzZbNXlc=;
 b=knYmd+ARbJAFBF3sVC5h/btdAppeyZqVmqGM+YQQUqFfy1VvpQUBx5WtUUL0GmeJEs0mYMjMjc+5o2c788riMkrJ7wo5n+ZEOjaaij6aIh5tzcqqPBxK60vfPbhBymjPgZgofY/x7jspmsOcHT9b5rUfIAUKuhHLQvXp85qv7zHISpCaDqRnVnBMmvJosSrmO7bvpwMYD2+WITMV9JcXdMk1tuveYsvj22T/eAfgPx5FGsnDm8SDrlJYbeulo7Jzd4X8ADhlbnIbQoqZa2VXq01GB63QV2t+KJkPpqLd4MJIvJr4kdeaJf3a/i8/GJvcFBzyE3vZ7MXJ23yMCf2B0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28Zjk9BjqAOH4tnJ/0YY9EMvU/kgpVYqLykWzZbNXlc=;
 b=f/h42O3QLZ96jpv6/8rGsNJe6zpDFjfvPTQGUImXrCkqb3ffiLI7GiXCHOicOSNIP3mGAoy6S4i1YwVPf/z12U9b0LXC6yc9x/0VvU03ZHrzencDfzjRQptSzJYy+Wby98xumCKK2S/vjKKjBGdrcHPL3sJJzu6+GwjGV452YRQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by MN2PR04MB6287.namprd04.prod.outlook.com (2603:10b6:208:1b1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.19; Mon, 25 May
 2026 02:36:05 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0048.016; Mon, 25 May 2026
 02:36:05 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 May 2026 11:36:00 +0900
Message-Id: <DIREOT147OSP.YY2ABOT2IFNJ@wdc.com>
Subject: Re: [PATCH v3 3/5] btrfs: zoned: always set data_relocation_bg
Cc: "Filipe Manana" <fdmanana@suse.com>, "David Sterba" <dsterba@suse.com>,
 "Hans Holmberg" <Hans.Holmberg@wdc.com>, "Boris Burkov" <boris@bur.io>,
 "Damien Le Moal" <dlemoal@kernel.org>, "Naohiro Aota"
 <naohiro.aota@wdc.com>, "Christoph Hellwig" <hch@lst.de>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
 <20260522090247.27445-4-johannes.thumshirn@wdc.com>
In-Reply-To: <20260522090247.27445-4-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TYCP286CA0276.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c9::13) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|MN2PR04MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 78ef508c-49b5-4d80-35d9-08deba065e85
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|19092799006|366016|22082099003|56012099003|18002099003|5023799004|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	X5GhtBg4UtjNTPwabtg1MiP4Dvzjwfhrp8zpDcwDI8IYkLdBLjEvT65YD7o7QFRMJFzNGHyrPg4Q2zvk4pbB/D5svKpdbekVfhAuQWD3zE5YkCcUSVu25g3RSigI+d1HNWIjMcxfTTOgtlFhSxwFuJsPcd2oN8oUQ3bLsYmSwMSX0I3WRuAmYSX6LTjViFckXdqFsUtLrUmngrKA8mZrD/60wCLmkN838JYfsoqITDoU76C+p0ThTH6mYLPcNRCUoUuIftl4FcG07T2oZPghio+3GnxZzRN85FJkyJcEY6KxGdVab87Fg+AyXIbO2AHMFd4uy+zJwn4Oda1ax8flpC5gDM8q30BNDaDRW+dVJIHAd/oIPNQKqZHCm79iGz3aJ1u99851SJ6ZrMz96vMlMqCOQi9eysSDCrVT0Ml+c9E2n+WxZTX9XkRRWceHkPorZ54F7axzz+W9QTdcGLfs5HuNeBaZCns6OaBkPSA12Irtn5chc8IBGgLPCt9Pik5W7zPtkc0vRsEwPWf7rvwh9cyoq4UHnYRLBUJdgspwgf+kw3iGH5whxqd3AX7uaRtOf18iQ/A/AdThlDz8a6fpQn2QTD2q4irVng7c1WYsFCd/A+kZPpbPMuA8zu+JguGZcenOjZmwLyneDsVXo7ryAnDR4y7XnIyd5IKMD9kmWTjyNVEaoLMUPeka/hbxJ7LR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(19092799006)(366016)(22082099003)(56012099003)(18002099003)(5023799004)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THFTN2FtRW0reEF0NUlTMUlNUnpkT1AvdjNYZUNhdEpOVTYrOGRVb0dIdkgv?=
 =?utf-8?B?S0d1Vkx4TEtmSjdXMThFc2RuclBzbzRBdjZ4UEdVamUzb0tEMmVCd0M4ZTR3?=
 =?utf-8?B?eW1ZWmk0bjRFT05kYXNacHYwYXJwK1FwK2RudjJsVmkwWHc0SUJObFR5M1BG?=
 =?utf-8?B?MmtZenZhSDUxdWVsTi9sZnVVVWtwMVJJSlpSQW5ZcEtvN3QxaHV0anJFN1ZF?=
 =?utf-8?B?dDBsZURVME9Td0lybTFXNTBWcS9RaFJVb0RpR2J3S0hhdHRqSHFhRWxsY0VD?=
 =?utf-8?B?dXdVSXk0WXRUU1FKbXRkR0d5QkpQdkk2b1JrQXVFdlRmdjJLUThaeEZEU3Vl?=
 =?utf-8?B?bFJPRzkrM0FkN0VWdjBtbjNvaDFDeCtncHp4ZjlaNWRqamtSZmNPWUx4b1p5?=
 =?utf-8?B?RFdDN25CMDJLNGk0OUE4TDEyU2FjSHlvM252NFFwMXY3cjROZUtDVWlMYmhH?=
 =?utf-8?B?QjF5Y0VnT2kzRU9LSkx1eUpyWmRaV2hldmhiempyZFZkS3VLbFRGMStzYXBj?=
 =?utf-8?B?Y0NqTU91WVJHQlJNTVl0NmFyMlJYcDY2djNBZW83YmxvNkNnSlRlTVF4MHRB?=
 =?utf-8?B?a1JhQTU4YmxTczZ3ZlpERHVvaHMvVDV0SWdTdGNhL2laTW1wZmlVNXRtZS91?=
 =?utf-8?B?Z082a2ZQcDh2aFE4dTFrSlNnK0xxRzNQZXR1TGtPNHE2RjIwcElRcnNuK29m?=
 =?utf-8?B?WW1HcjVjY0I5RTZNcWJzaDFGdHFzQTZiSFVDbmNucVdFSDRxVWxKSkRCUHVD?=
 =?utf-8?B?MmphVGQ1RGhnMFRWc2xMQmU5aE9iLzcxSlhSTHR5RDJnbVJ1R1pLZnpTT2Q4?=
 =?utf-8?B?elJ5ZXM5MWNWYmVjZjBtcXhTM1pmZUFXUFlLd2xTMHNsZWNKM3NyUVJRR1hT?=
 =?utf-8?B?blIvZFE3bVZHYWVXc0VscFdMRG5Udk1qbklNRTR1WEJEOERmUW5pWWRJN2Zz?=
 =?utf-8?B?TzFJcXNtM3VXemYwbFV5eTRXUnM4S2R2Zm51V3BPemxWZUo4Z005Rkdlbmpp?=
 =?utf-8?B?M0RHYmVQSThZRkJ1RnZzdE43bHVRK281c0Rab3VyOXRSS0R6b2dlOTBkQXZO?=
 =?utf-8?B?c1YwdU5zOGE3SXJSd3ArYjR0K1RIWEhwSTcxWFB5S2xucllaYkFjQjErZ1Az?=
 =?utf-8?B?VThpUEZKNURWS0VtL04xTi9MQXpEaHpXZVpROFdqWjdVTDNUeWRIMnhCUXVI?=
 =?utf-8?B?bXdhRWxZWWxwUXF2cEtrb0ZOajNxaTNGR2hEYTJkaW52N3huWFd6MVNtS1NS?=
 =?utf-8?B?Z0FXbm16RmJTMnJpQUpzYlh1T2cyQSttZVkzaFhvOGFYd0NrT2lPYzRoalRE?=
 =?utf-8?B?YWM4TjRpalhHMm1UOVMvVk16OTRvd2I2K1M4cEVvb09TZnh1TDhmcTZiMTg5?=
 =?utf-8?B?WkptTkJTSXNKZjRMQ3FTZVZGdWVEb0h0VUY0akl4RkYrVmdwMllaOHgrRlpX?=
 =?utf-8?B?ZGVYeUVOUFJYVWZnMVc0UFF4LzJrNUwyRHlvQ2ViVDhQdkJyYmZDa09aTURD?=
 =?utf-8?B?UU9VVTV4bnJKdldzeGZqZDFlMGd3eERranBWVFU4Tm9WRFB6L0FUYnZNeUor?=
 =?utf-8?B?TkRzazZBZzJKcWRSZEpVc2FQWjdYZEJMK09oajhrL1B3cEpEK1dHQzZXNzRj?=
 =?utf-8?B?ZDc1THp1TEtXcGlJYVRVU3o3YXpFOUhLNTdobUx0TXA5cHgyR2lzUndHc0tC?=
 =?utf-8?B?dXV5Y01VbWlrNVZTQ1NPV0IxcWZWQlIybHkvYXFpS1NMckNvK1dOMGIvRURl?=
 =?utf-8?B?bk5sbnh2b0dZVXEvRWlKY2hFTVRpd2o3dkRiTGVnOU1tVnBoNGl2Y01kZTF1?=
 =?utf-8?B?eE9rVzdJZVh4OEdLSnY2Qi91VS9uVUFyS3dLR0Vua3ozRXZWM29MbmtnV0VR?=
 =?utf-8?B?cFFLa3paa3JLb2lKUm93T3k1Z2s2TmMxdThBa1RHRzhYQ2RiNGw2WldINitz?=
 =?utf-8?B?aHp4TWVFMUJieEU3TUdRejdxMlZRNG9ZT2dLWGhpOVdabktIZnNRWTZYdUVp?=
 =?utf-8?B?UnF5Z3BDWmowcnlEMVNpemV3SGJNc08xYnpDdFA3b0RkTTExNnp3VGY5bzVh?=
 =?utf-8?B?d1l5ZHV5a2VJcU9CTXhOOGRsS1FIYWlrNWpLWDRyWjlnMW1OaDdIR0JScnVJ?=
 =?utf-8?B?WkdKU2RFTkZqcVVQNjBNRWloU2Q0ZnlHU0tpQUVsRXlWeVdsVTZLdHJLU3RL?=
 =?utf-8?B?STJxM1pIWkQyVnVpQXc1dzF1TmNNMVl0a3F4S0FYeXkyU1JrTi8xUTJ6bGZu?=
 =?utf-8?B?eDJiQ3hxWUZ4ZWJIb2ZsQU1YSEhhNytwcWE1RDZSWDhxb3lZS0ZWbFMxcUlx?=
 =?utf-8?B?SCtJTlczYm16L1VuVWhpNHRzWSttR3hxNmVISlI5K0VVTTVMQ0Naa2RYNU9G?=
 =?utf-8?Q?rA5q69W17QMnNU0jV5rJh/dHpEoo22PutMGayPINpJqdh?=
X-MS-Exchange-AntiSpam-MessageData-1: dO/NVdKWgG6PGg==
X-Exchange-RoutingPolicyChecked:
	Pq5eyZ0ZguVzrKaQIcCRoGxs6lTBGsNRWu8N1nR2D0eKxfHYQX0w3M+a2+wbA8vthPJatyUDGVEmwwxhhgn++35Np1b9lx//AH86AbdDUMbFWnHTgzA7LAxeMwF7wFoGGEVHThMJfd2PI/G9fTPYpEtlZxNpaUvGxKUxDhAZqpDjacgOv/55Ez4Dg308rdmfcb9oc9fo8BYCA8BMdCvYGXdCj62fnULPOXl6AW5iacwiXpaCyrbh3DNV9jNUtN2eUbKkUB/bTEHO2Lj1CxyAk2j444mRkDHqQOQ4LmJ0Fe0f6gd6eWsBWMOQ8hPL7ajAd6AtmLkqdyI1F9kEHxjHzw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	liaVLzJBV1/vLC0Qw8t7+2tEx4iKCYN1ZOfu9j+rByuCLVR/vNMJKHqYaQUMC5x/adFmvP0T8irhkzdwUAM+9lp4vNFMeEghinsli5KArXCcF5kkwmBT4LwqaPo7J5vYy8ao4ehTGMf1ixzgf28Qs3gNsMZY/+65k0pHCp9c5gmHZ7eTNFQhkbDElxlp5Ki9w7qIzfh7kPQdVAAPXH3ukjkc8E+OmtLcjF9+S7/FEcu0dmwnNyreYsFgl+x992UFUeIjuA8J10jJ2yE5zPb4IUE4AwS+KuI34gdqoEEVYmC9qKfP0Yn4+S9paEjVnepaQYvK9piHbyz8Rb5oUJubR51onXaHtj6GLFEGzqsn1jDqIYfE2xXMBqir7xdBu6ow88BSW7ZYgnaHPjjTViLgP7tjfbuiA3hVlfIqqoV9d7jIpA4tAZ22PJ7NkJ0sOiGMFENifm3gvXLSghGzJvlKKvmMuj3e5+2pALpNQHvGtmafZLUnO0zizD+FGbsf8TWS1NdEngtlwyQG5WzbzEz/gJaokfxlrdx1ROgpZ1U33mKq16Znus4XVI9v3CxzlJ0ZlhDirGuHERqq62ZgpJDDOtsjodqtKWgJ+ZMv7K82uBs0OU2vNxlpi07Eq29SlQZv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ef508c-49b5-4d80-35d9-08deba065e85
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2026 02:36:05.2961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ckcykY+sMMkbAjlVhydXoUCZcO7vYKhmXD/EyRTzsFdlMCVjgyjB3DcZ/q1ZBUtXNpKlnHLxec1U18kBt0bORw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6287

On Fri May 22, 2026 at 6:02 PM JST, Johannes Thumshirn wrote:
> When searching for a data relocation block-group on mount,
> btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
> block-group. But it first checks if the block-group is empty and if yes
> continues the search, and then checks if it is the first DATA block-group=
.
>
> There is actually no point in looking for the second empty DATA block
> group as new DATA allocations will just allocate a new chunk for it. Pick
> the first DATA block-group without any allocations done and set it as
> relocation block-group.

I think we can add context here.

At first, the commit 694ce5e143d6 ("btrfs: zoned: reserve data_reloc
block group on mount") introduced the functionality. At that time, we
took second unused (used =3D=3D 0) block group, as the first one might be
a block group used for normal data.

Later, commit daa0fde32235 ("btrfs: zoned: fix data relocation block
group reservation") switched to look for an empty block group
(alloc_offset =3D=3D 0). At this point, there is no reason taking the secon=
d
one anymore. So, this commit is fixing an issue in commit daa0fde32235.

>
> Singed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 16dd87aa06f2..a4d2fb774f72 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2763,7 +2763,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs=
_fs_info *fs_info)
>  	struct btrfs_block_group *bg;
>  	struct list_head *bg_list;
>  	u64 alloc_flags;
> -	bool first =3D true;
>  	bool did_chunk_alloc =3D false;
>  	int index;
>  	int ret;
> @@ -2784,13 +2783,9 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrf=
s_fs_info *fs_info)

Could you please fix the comment here?

	/* Scan the data space_info to find empty block groups. Take the second on=
e. */

Other than that,

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>

>  again:
>  	bg_list =3D &space_info->block_groups[index];
>  	list_for_each_entry(bg, bg_list, list) {
> -		if (bg->alloc_offset !=3D 0)
> -			continue;
> =20
> -		if (first) {
> -			first =3D false;
> +		if (bg->alloc_offset !=3D 0)
>  			continue;
> -		}
> =20
>  		if (space_info =3D=3D data_sinfo) {
>  			/* Migrate the block group to the data relocation space_info. */
> @@ -2849,7 +2844,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs=
_fs_info *fs_info)
>  		 * We allocated a new block group in the data relocation space_info. W=
e
>  		 * can take that one.
>  		 */
> -		first =3D false;
>  		did_chunk_alloc =3D true;
>  		goto again;
>  	}

