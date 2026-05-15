Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F903DF01F
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 09:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778837192; cv=fail; b=C+6wVD+DY0QVgpoCTtSpMGCV9IV4Zo0KzCVqoYoiK5cAtsSgJMZ4gSeb2tU5fF3PhqgevUJL3mZbR3jELYBDi5sAtH7C7z+LpcNbs58nJeeAgIB9MRnZQFQoX1dDGegfjAeitmRQr+ifvjRiRHhKegt8u/8E5PxQA5rVDtEDkaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778837192; c=relaxed/simple;
	bh=U+AIuUfIVvt4L0twtMPAsY+HpFz1Oja2nwFv7nNR7M8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VGRN7Qx0XU/Jeq7xqgJpAkOrmVPs2mdmmIdwQ4DZno1oX+YFHVD0XvHtn/oRSZaWSFkN2f0AnjRW/MonRLXGTqLz7L+x/KdvgIlA+Gx5o1ch/UCXyCm0hI0J2r4YkGnrT+MX5t61O442VLiGBEsGkfthMpx/LKCNH/UK/hmyyYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fuSj7c3K; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yiKBzSE5; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fuSj7c3K";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yiKBzSE5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778837191; x=1810373191;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U+AIuUfIVvt4L0twtMPAsY+HpFz1Oja2nwFv7nNR7M8=;
  b=fuSj7c3K/osEHBaqkBu1KhxObepKBNwNOC9++XmvADmQHZhfhbUfFkgg
   1WTU2gp+CWqlWWlvqhsDivM6gX/QifzIPaoHMVQvybC4hRYZadHFOv3jP
   iQRAogh1dKmB1Wnn/yhWxpCF1b90MUvIXhi8kGg/4kkgpQ4RPgHcxiln9
   Qpk0dEAG9fq+BSJgJhmg/EZOJgBZmqHGzFFsIpQOQCntYG9N5JMtXZmyn
   Bh3iiiHjm0RSz6pfaKaSg5Sm+Zw6bSVfC/Gq92l3hWmMJ/HqSgU5zt1pg
   +J19SW9qF46ihktswABZMpzgXTux+BpmpD2f1u9aAFpzjPsw56BrimB0P
   A==;
X-CSE-ConnectionGUID: N47wt/e7Q9mScbY7ELkuSQ==
X-CSE-MsgGUID: DOd5L7feREuqP3hBwH1d9Q==
X-IronPort-AV: E=Sophos;i="6.23,236,1770566400"; 
   d="scan'208";a="142865125"
Received: from mail-westus2azon11012039.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.39])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 May 2026 17:26:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UsvJwNusTJb2UFlZLXChpw7BGjYqBf9WBrErxU1bQEA6pwm8XPD1axZma0juJY5/KuwQIp2yOIB+IEjgt7CvZ5dm30QV6kRRAV2RXyiGRLG0l8G2sNjJ72ee8mtdc7jckNdlGsL4Pl80AmDmJ+ERz/xpQNGydmuDyfv+PjIi/NLldfbjrp2E7Stkye0pfU9w0TelyqvxPkuJRCaickYBie92aXrTaoSAXWjjlKqHm80OKystyX0+DJzJsdCc4L0szzndK0nmHmJGnYT9WGV1nzsiNX/TsD5nB9WbR/XzNjn8wxV44oH6UUp0MyHDKrAm+HTms3bTlYAiWP/DOla1JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqDhKHP0X00EfqDivRdtHiG5qYyH5b1FEta+Ji4FDT8=;
 b=m6t5rtnhu6btscYKM6H59XpvXcnQWNgqqfl0OFvoC2KfEp9k6g+YHKpSAsvL3qkb1mJIbBJl/NaRTP70bo+IxkSHR/i2dA9LhfabKanFwOfZaGHuS/KTYQcscObVFZmwmNBSo4OuTqIZLAdIEDGVsI19PlUPOcaP5AkrSw802mdLvkJfnZb1EL3xLFriTTP5T/U85+m/VVFl18paXFu5xI8smsqsd7F4UKch4F23aBpJkfgic2PHCRG4tm8mbL/PDlJv1U2/hAI59HMwidecDj/qJmadOH93G/gWfGcQtt8rtD1J/UVesaAcZYesZ5GRgNCSxO9haF7ZpWuRiCKXBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqDhKHP0X00EfqDivRdtHiG5qYyH5b1FEta+Ji4FDT8=;
 b=yiKBzSE5ezyM/z0vVBjniP/8TbphNCHFdLcinIwGJQj7YRPLzHPyotrfsmEij+ZSHjtFzD0P86qgl8uC26u9PKrxZRegm8yyNISi4vEr/wADQ5WL0142mDg5zaQHtasLINvOLk5IC1lJanScs/XqZV/k2AnrS/u7k570To/Fnzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL3PR04MB8075.namprd04.prod.outlook.com (2603:10b6:208:34a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.20; Fri, 15 May
 2026 09:26:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0025.012; Fri, 15 May 2026
 09:26:27 +0000
Message-ID: <bc97d41f-55e2-44ed-a500-e74f8f25f006@wdc.com>
Date: Fri, 15 May 2026 11:26:22 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] btrfs: zoned: subtract zone_unusable space in statfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
 David Sterba <dsterba@suse.com>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Boris Burkov <boris@bur.io>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-6-johannes.thumshirn@wdc.com>
 <20260515043921.GB3936@lst.de>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260515043921.GB3936@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0166.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::9) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL3PR04MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: 68637fd1-0067-4849-151b-08deb2640a0d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|19092799006|18002099003|56012099003|22082099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	nJHm6y/+xWqZ4kgcFp4e1XuvAupt6Bs5Hl+NGegsG3ld2jab8OC/NWBN2DF4ogtaEGcHOF/UzIF26I1y4K3z1oFzfwtz1GgstqE4KddF3/anGEFldslT4dWwbkiI/eyCc4FR0JO8xcGfKvbx1AriZrFK6c+HVc3TYU2Bp6O/aJuQi31e/sdhtsJAtMSuEL7r7HQJ+HcvfTXAhvhZlLiMrehk+Nf2rdFtLsE1SoAeMR9fljGDl/s6gmJuD/cywc/cb45xM0AtoaEk6FJdm60dBNYC2ro/Zsdjy4Y1mgaUfhp3paRp7inRu1kFm6VTdOmKueggfh4Afj29eKDfmu1LS4z0rbddFB55W37sDv/7GmmorPvHQLYn1jR25zGHuLA1fjmgzn4CS94JMJpU5Ugv2YqZ6cI6oW2Mkj8vNzHY/71P84IhTtziVHCtMrLK27J96PMUE6Xmb7IQhrI1NsLsH+fUAvhAdkndo4NwhgsqyQOVBcF2SJe2M2Wnl6+w/LickhnUAcEleZaSmMM7beIAhV1SfyYQITWGusOBGoAFVxHq4qqIzW3z9HFVQU1qIn7fTCkjrDz50p70WVTuhnaLKg45Gy4KYUqUryCkr1t8NKZ5sukYqodd/ZF7wiLPfI5cjrkeoGdiy5ixQgCfUY1blyCu56foREGWRoOepVA+wkQOuNzt8e18KAAGbT3wVwGp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(19092799006)(18002099003)(56012099003)(22082099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZThVTkpFYno2b1E4dmtYQk5TblE5bW55MXh2TTNGMS9uWHU5alpoTWlYUHRV?=
 =?utf-8?B?aGdxZmhHS1dPVVRqSjlrVk5Uc09VK2l2WTJCdGdGcElpUXlsL1R0WTlKR1py?=
 =?utf-8?B?aGJOeFIrMmpZTC9wQTJoUEliK1J2WkU1QVpETm5rSzUyRWJDaWVySUtlUGZl?=
 =?utf-8?B?dE5FTmFuN2NCQkhLNmt5RXRUVGdwVHJ3Z3ZEYzVrcTI3ekhza2crckpWMnFn?=
 =?utf-8?B?KzkydVIwS2tXdXdLSlFFRk9aUEI2MWxJRXEvNWlpTTlnek5WeGx5S01yeFJt?=
 =?utf-8?B?eVBDT2ppOXlOejdLZWdSVjEvSndsZmV4NTVVMUFaRDhPa0IybmVieHAyRXVN?=
 =?utf-8?B?dTJ0MlhhaERHMTVyVE5oajkzSk1Nbm9pUGVNbmsxV3FMcFQyclovc3dPL25n?=
 =?utf-8?B?R3IxNDR1VXo2WndZTEV6Nm9oTTJ0ZEJxM2U1ZUdRNXJJb2dEdXVVZDJPVWVG?=
 =?utf-8?B?YjNhcUxGODVlVERGYjFqYUNYcksvWTJUK0NZNWNFdjJ0bWFveGZGU1czZXpv?=
 =?utf-8?B?L2VzN1prUHpNUkhkaHZsQ0IyRlBqejRMQUxaVjA3bk1jYzNTSFUxcmtKTHRY?=
 =?utf-8?B?V0c4YkV4d3Eva1NyTHp2Q2VuVWlxWXRZTU1va0F5UUdOOHdZZ3FOby80bVNJ?=
 =?utf-8?B?bU4raXlraUtIVGUvb0VTdk9sbldFaVhvMkg2ZExsWk0vVzJ5TUR0N1ZLT3Jn?=
 =?utf-8?B?ZUlMczQ1a3l2SXlTWDA5cWlrcXRUcjJ6SDVmNWtlQ1pZZ0Yzcno1a1h0WWw4?=
 =?utf-8?B?dUVZYVRUdUlGd1BhWklOTkpkci8yRmtzVjk3bGRnS0wxbHlWY09FejdiOVdX?=
 =?utf-8?B?Z3pjdS81Y2hWcVN4c3dmM2loZ29Cd1pjcjNYTUw4R0lMT1VjMVp6RFBHc05w?=
 =?utf-8?B?NUdmZEQ3YmxOZEwya1FJUXZGQTV6dldxR01QcXhJem5lY2pMNkhEbWY1YkdO?=
 =?utf-8?B?bU52RkN3TWVsanlsd3ZHUUxJZ3FSNUUwYjFhbmZ0VGJ6eGppNGw5eVFuMU5m?=
 =?utf-8?B?aGd6NnJVRWwwV1d5c2x3YWN3Q1Q3dXNSWkM1ZUs0ZURyZ1ZGWDVSM1VnSzc0?=
 =?utf-8?B?QktTZjJuU1ovMGtpaWtlMWMxQ1VuWFl6TURXaHFSUk1BUGczcVk3Rkt1Szln?=
 =?utf-8?B?Mmhxa0JVOGRPaU5JRzhDblNrZTYyMGdGQm9uY253SW9LRHVaY0VqWVBKRXBI?=
 =?utf-8?B?VWl6a080TnI4UGc3R2REVTRkbFp6RXhIUG05Qmg3R1ZETnlSczdYNkUrdGFX?=
 =?utf-8?B?NEFCa1lxc1Z0K0NRaXJvYWw1U3p2em9vMFErWlFBWTJJbm1EbktoaUtUNjdW?=
 =?utf-8?B?Z3JrVHB4MFJtdkszOTA4Yk5STkRXbFdDeUNPY3V3QnFJRlo2RDNQOVErNU9Q?=
 =?utf-8?B?bSs4NU9iaE5ZUXM2dnRmUDRJRTRvTS9HcWlPWmVGZnhhTTFMM1YyNDBiQ2V5?=
 =?utf-8?B?TmhTSm5PL05MZXp2K0VnYmpjcnJrSWNza3JlWk5KWjNLeHJwRzluVXhKSkJL?=
 =?utf-8?B?N0tCR0tjaHB0SmtLQkIwUE5EWkJ2N1NrWWh6b0F3N1UwbHVpYThVdWFzMytT?=
 =?utf-8?B?RmVxU0U0cjhOVmJXaGVWOGpVL0l0S0lVdE1oSTVoNEdIVDZ0Z2V2VnVoTVNq?=
 =?utf-8?B?ZzN4ak9Cem5rU3NCdXl2K2FlUFRjR01YY1ZBZWU0Q2p2MzZHTmcyMXdUK3NK?=
 =?utf-8?B?blQwaG5PWnlBTUdhcHNoZjRzdDQ3dHdtVmw2WVNDeFVMSFRmOTlrZXJsSlZR?=
 =?utf-8?B?Z0QzUmhjVVZuZ0RhS2tIcWhkUUNUbzI2T1RjaVBITFdyMEZVeHkyMThudFZS?=
 =?utf-8?B?MWFSV005MnVxaVJ3T1EyR29rcjdlNU5FdFpWaVJzOGJtNXIwaDRyb0JnODZE?=
 =?utf-8?B?NS9FbGtodVlGcEVDVHZkWlMwM1ZLQzk3LzlUZWhjWTF1cWloU2lFcWduQmMz?=
 =?utf-8?B?dS9DcTRVOUg4eTJUNnpDSjBLVCtIVzZETkN1ckZYTjNsYVFpVUt1UStLVDRX?=
 =?utf-8?B?NFJ3OHlsMW9paGsxaHFNWFZ0ME5lREszbUxyWG5SMUxOQmNiY0hCeFl1YkRQ?=
 =?utf-8?B?dDNXbFF6UFl1dURHclZQNUJ4MWpVUVFZN1QxRlRjWFFiRFVhZTZGYjNtZFNi?=
 =?utf-8?B?eUNKTGFGSmk5VHJ0UjFUNklQQ2hmZEdKQ2kyTFU2Q0M0eHovSUVDOUlvaUlR?=
 =?utf-8?B?VFFRRjFmTERPSUMzWDFkYXcrVHl2cWIwZ1R5S0FKREEwdjF1a3VFVDlhVll0?=
 =?utf-8?B?TzBvNW5RUFpITG9ISkV1c2FGNzgwM25XWDRwV09GY1JRTDdnWWRmckt4cldV?=
 =?utf-8?B?d3c5UjhKZjI1WUZpQ1hFbFg3Z0lVTm9RTW00ZGtISVRmaC9sdjZhZzFBS3B0?=
 =?utf-8?Q?Mwccbknf6fYvgu7K/eMdFWRRPRGQPuv33BNHYMOo6RAUC?=
X-MS-Exchange-AntiSpam-MessageData-1: aVMjLk2WwPczQltliDmpKKOc8jzKgS4QrU8=
X-Exchange-RoutingPolicyChecked:
	cPr4NTjbZbVq6Lf4JoBneCiRP3TwOIcpHzgOwEXTSO94eBnER605fnsg96qZmmBcHlv6NdJon2UslxzAvHQ8wUQiFouzx9B9RRUfpiO4ihoLz0Y/PlBDASaz6HyNBv/HGQJNrc5/oiJwX00bcamFLdmj3lTSfjwbg8PBXHDm1Z8nlcgh9K5/56TOYvuWPI4rF/xRN4mQsjvtGTkAxBfEY/WZ2KyYI0QX7jJcQaNw9YXE+SCX+s4cO0HQvkJYyFx2+zHh0UOcc3E/84kY5eoc7dpaMVmSfbHqw6+Vwh2eyqA8L2bcxNqrr4XG076XIEGbtM0d7y9F9ev2cDdksCNx2w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/aWwl/v3IQoPpIzlJoKqzbUVql3rL2VsJ54OEmFQyTpSTe0Rsmf7da9QQBo7eKYMekcAOAiQmgLmm4N7haNHZbNaVxKXK3CfHAUwI8HN0acCxwfcm8gAYTB9zbjuF+VxZSpn1jjTxYMSMO6QwUuDjc6Mn49Ki6YC2cD+BEp+9IyAiGnQL5/eu6VfobCq4GDstY5QJiPLAivMSHPJ1lbX1BJHdOZ4xrpPaIw/8CmDj4bKncnp1/aNAzWzJvJjjZGnE+UkzG1hJbYbhUYL8MnuOaKLi/MAtqsmIplJcYIsR+On/c8E/jgvwdc7yQrBwmPxvpErBP6wn3xOGahWqsxxyZjSX6VsTvmhmTXBQ0KWYIFj223DiNUAKyNiYcv7ev8UUyJxIw+A/pbl7sI49zlKl6YQPbLYQrMJnPiwcg4lvxLlPjj6IV69ACoEONygY+GNM74TmNjohsBt9cqF7KDBTstZUYET97ekKRF5Y1EtLSrreUmA716qQVRuJ9aHTH/lLtwNjyNisG2rRyPUnsWnYVh+EfJzTwCzRWBOQjevYufS80YKpgYTbkFeOwWNG42NLje/6pyQ4qBQlCVF4Cy5M4IqUNl4RbC4OhzUeGizsTH6EqUSLc1U6tcdPooLbhmo
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68637fd1-0067-4849-151b-08deb2640a0d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 09:26:26.9407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QyEqxQKtuP7qA+Xxu4Y7RLzEsSTJOKSCbH/ph5bBjTbtIrnaGUgxmdh/l96D/NPGMYe9pl6Oq9tPjgbAlA8jjDcUznqeMR2LJAtaVL/hCfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8075

On 5/15/26 6:39 AM, Christoph Hellwig wrote:
> On Wed, May 13, 2026 at 02:34:43PM +0200, Johannes Thumshirn wrote:
>> On zoned filesystems, space in block groups that has been freed but not
>> yet reset is tracked in bytes_zone_unusable. This space cannot be used for
>> new allocations until zone reclaim resets the zones, but it was being
>> reported as available space in statfs.
>>
>> This caused statfs to over-report free space, leading to ENOSPC errors
>> when applications tried to allocate based on the reported free space.
>>
>> Fix this by subtracting bytes_zone_unusable from total_free_data in the
>> statfs calculation for zoned filesystems.
> This OTOH sounds very wrong.  Freed but not reclaimed space is usable,
> it just needs work.
>
man statfs says:

                fsblkcnt_t f_bavail;  /* Free blocks available to
                                         unprivileged user */

which in my interpretation would include zone_unusable_bytes, as they're 
not "free blocks available". Or would that be accounted as f_bfree?

