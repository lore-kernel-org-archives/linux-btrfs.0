Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944F335F197;
	Tue, 13 Oct 2026 08:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880524; cv=fail; b=i+Oysb8YMjZd2SuFrwVBUBCl0gyXsif5A+S6Oti79aw+eODqCPjjov+kDGKabXBAfv05obKW6ehQQX0D2X2zMCbi5SQV5ZuERl8M/Rjfy663Am1oXypFoo6cV2L6iSqLs6r2Np2ZgAiugueq651lY521AlL6nOqE0gFIBZMOF5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880524; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ApvvPlC9Cv5rReDBPgmN+jGJjoOfDjveu1C7v2A8DURfZBGuaVVrLLefxLdlAEOdwRqej7CpS167FFAEauhm58ogNF0kpoiZ0LkRp1re0zTdRJyfZwycbLBzdvAsJ00uslatIsGlSCazZ+g+uVwrviI/R2QQZan/gSwsJ7N1ehs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=auuzfjg8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=SuPn2jQw; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="auuzfjg8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SuPn2jQw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791880519; x=1823416519;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=auuzfjg80Frc0dk1CaWtFVcaLaLPxgdaJj+O7rZMN/i8G1c7SEsV6Y1Y
   WIcFXJ1WAVW69i/AxZdkmPv7DWVKoVnCfVysbS1z+Qc8DGCOgavbIjHi+
   t9KOQBayJ/h0RPyOnyqSZadHy3Fe5Mmw/Sb9zrXFSxmqn7EVnokUgqrF9
   gKlZIGdQDVN0D+m/hKsqVzo7FYBwI9h+G0QZpSUx+97V7qDYEXaOYeLpR
   zai0KBZTpmdtp+TlfU0BqieX/7wbS4BbROqjwQRicc+0PJf64Kd8tGGdw
   i9jC4VZazihI/mkywZqVyt5ojqjkWBb1uLA7hhTTViZ6oCI6P7io3SxRr
   Q==;
X-CSE-ConnectionGUID: dcsKt201Tzy13Q3iMU0JIw==
X-CSE-MsgGUID: NJIMBCumR7ivqfRkVTyXFQ==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158921252"
Received: from mail-eastus2azon11011056.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 16:35:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CHp0UXNsL019Ys9xX6C2U5xBIMr9EtCZtOptsoFZ9E9gMV1d/gl/Ugtt+v3tkXzODxFCfhULsFeet1Pao22OjVL6BUEELAMuKrKEC8TJNWJ4d2FmVtoAx9RZpCKd/Ckx4v5P/NleJlPz8O/sHCYdBi20Q+aoqlYHMVtVT8T32SJ3dHM3EXhjftaCg34BB1aUmaPXorUH7zGIXYEtZReuENHs9EZQ/PIUiuX1uHzwywHJihzfFyBubmdGGPQZumvqYLJI/humhkbairGWBeBoq93LFMMA8N0RUxFs78rCoeiHfvvd+0kD9zkU7UvVM4Qs2fFnObjWcdPkytrop/qM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=YHqAAZn8SwwKdHSZn5iqWmc2E6Ou1N70sETfCWdmAUzu25V7OlZFLqmbmObvqlocqOOm5pkND2zU+Mdw0wAjilmvd/jXuYMfiCgDSGEEKCHpAxB8n/+0rvaDraZkxB6l/9gmr1C95ziR+WjXXdLlNBSLFSLtkXmpti/QeWB1k6VyLNMJYZsR4hyrLXb5HannhYrkAS3x5RWMhqtPW5BOd74ncQ98Dj/ZMNHuo55tMe1OvO6SisUQ2uMKxcIfPgubA3SY0SQqhVnHoPdq4XNwELglKxOsBNMa5sch28GEYXZB5oip6NrzMog2rk7lDBY4z2bLikBAcaoCPRx9Y2vniA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=SuPn2jQwBJmBuUpJR56zrhkKr6x+QbeOagCA07mhtWnh+ii/t0q30ODMCfiZuPiOYlCZXvDUW3EhAJe2LvysWoWHgLwIAaUhSCpcP7yfTND9+DrlPbmS98fhGNDfROuTOpbF06kSOYC99vTrgS7OneayaULje3OgTOa1EpRtQYQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA3PR04MB8978.namprd04.prod.outlook.com (2603:10b6:806:382::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 08:35:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 08:35:13 +0000
Message-ID: <baa37ffd-074f-426d-8fa7-750b97391d28@wdc.com>
Date: Tue, 13 Oct 2026 10:35:09 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: unwind device add when sysfs registration fails
To: Adarsh Das <adarshdas950@gmail.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, mason@kernel.org,
 syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
References: <eb63c9f9-a158-4a70-b3ed-30046b15de11@wdc.com>
 <20261007160349.22411-1-adarshdas950@gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261007160349.22411-1-adarshdas950@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA3PR04MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cabcc72-fa1a-4b23-8b6a-08df2904e67d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|366016|10070799003|1800799024|23010399003|4143699003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	N0lZ50tBBQQAVmhFeqrjOov5r5l4s1NodH3qSl5P6Uo4QTCYFxufM+maf8ugTwaJwBZXEjvwbkAqVcQvMG47BR9BnzNtTERr+w4Xv+miFNJn1wUWhM3CkEpXjK9TsPURqoAPFNK3ZJ562xs+Bjsfuei3mI9NyuyqxnCbyOYhBIxwVbAa/hliOiTRlzViNK2h6K7zpXQbUXkpN3nefbeh7lHOy2g5QBKrVBM8Gw0R23l+gswBu/BI9qZleB8dmnWFsZvUDqYPeSXjKdDmyCU4itB34DC01lJXJYMLmw2KAQx/hqW/fGduuHwdX/055DYc/tSxxpNKTfH1fnteHdH1ZaP/xVzkJ3023eg5NgN3OkWwULfW0pqUM19DQufFLjG2mttfvqvYv/sPjwt3jLxvW5HYh+9GG5Boc2MFSrvpVDJ1MnZf20wDegtY9r2YYJPNSBiCL/S/IL084He472zlXZ2lu3Gds/x6Bb10p4PK0w27tyNpJ6yuPHw3xfImK1KwDVh8FnuZfFUoqmmWmZU6iVAGD1APcrkDBS/OUtv80/TwrJ3h0TbJyP1mcCydsgoC12clkGQmMJByJxEEM0nSR/L+u/4tTS6CutxG3ViWNkf5u3LHZIf24gVoxqaSBfbUUkQEhRxG2yoqaIwf24ZHLpwyb8qBpFnNBxsFCf+SGN4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(366016)(10070799003)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXdOVzdvWjBmQjhCaFZTSkhIYmdJWFZaejNhSWJBRlZrMVl1TndKUHkwVmlj?=
 =?utf-8?B?TW1WQ0RwcnlPRzJGQ04ycElEZmhXekNPLzlIbkE4aEwzQStOaXNtcW44LzMz?=
 =?utf-8?B?bEh1dGpmTXBXM3ZGc0VaL3BwT2d3alM3MXVwdkFqcGVLWUgyNDg5MFNaZjdR?=
 =?utf-8?B?OUhKRDN4SWcwUlMrOExoZUVYTy9PZnM1TTBlai92YmxIVVM1NU14TktnbHQz?=
 =?utf-8?B?QTRaQWg1d2Z2VXYyc1VZMldiaUFzSTJ2WmRoMUZGc3VGMEJaOHB0VzFjYkQx?=
 =?utf-8?B?c0JkZG41L0pLNFFpcHhSVnE1RGxnK0JxN2dGRzhzL0dwNjZaYzZ0WVk4TlR1?=
 =?utf-8?B?eHZFTWZqT1RQYkFtNGJQVnBmeU52RkNxaEtTUUQxVzlsWHU1VXdobVZTMU0z?=
 =?utf-8?B?VGdrYytpazZPbzlLNit6MkVCOHhJOTNqSENHbUhkUHJka3lJZjRGODNFTXNn?=
 =?utf-8?B?WDBnRW9ZOFdVcTN4NVBCa05KS2lwN3YrZ3BPVXRoeS9sSndTczl0a0tpbm4x?=
 =?utf-8?B?VWJYeHdOQmZIeXJsMXkxZVV6cWV3K3QyWjdMMTh4anRMR08rWnFKWlEyc2dE?=
 =?utf-8?B?bHpON0FHSCtRNzdZczRqSjErNEVST1c4KytpS3ErTVlFTlpWalFWRVJ5QjRH?=
 =?utf-8?B?aHNwSWxrcm1hM2dEdDFZRWVsdTdWK21lK2RvVjF0UVp0dEFhYnpKWlc2WUps?=
 =?utf-8?B?SWNnOWlLZFRQdW1VMHh4M29PU3dyTk11Tjg4d2p4RFFMUHJSZlNxN3BuOGRo?=
 =?utf-8?B?bldDU1RPOE1FOUZpNjVLWGtXUVpqU3I1WnhqYzhRSk9VdnI5d0g0Z1RURXNZ?=
 =?utf-8?B?d3Zsc1JTcVR1clFhNjZHTElnbHVvcFBiSndqMXBMWnE5a0xTQnMwS2Y0dTln?=
 =?utf-8?B?a1B0YlJhK1B2MXZuUnVUZ2w0U2pQY2JwVjJrVWowR3hLcG9MTXZMN0huNEVl?=
 =?utf-8?B?UFBodkVMb0poTGhqWW5OMjZ3OFZENkxVOGZtWkhuaHF5SnRjVmVJeHBLRG9B?=
 =?utf-8?B?cnIwZHRJR2ZMS2FUOEZLYVR4R3pjTjVma2w4ZUtQR29WOGVLdnlXdmtRUzVv?=
 =?utf-8?B?dW5lUFhVZ0FkNzFHZ21zSEw4elQ4TStXNFFnWHdQbUV1R0JYOVU1ZEVzVmty?=
 =?utf-8?B?bC9UQUFjMXl1b0tmVkh6ZmpmRnpjU3pXQjJkVUw3N3hGVmhwaE1XZkwweXNM?=
 =?utf-8?B?MU9Qa1E2aTMzbEUzdG9KcGlReXhET2RGcEk2c1g2T0htU1owWlJTYWZVdmZo?=
 =?utf-8?B?TTBaWnlmUkRvNUFUM3VlTFFBSmNsejFLT2plNVdQWmdyeEFrc0xRN3FTL0p3?=
 =?utf-8?B?UDhnV0dYeDR4ZlpPQWcrMm1ZdDhzTWthclJweG9GTGg2c05WYmJPUmY4TlpH?=
 =?utf-8?B?UHd5S2VlYTdkYVhKRHF3clp6UHUwRmExUW4zcEkyQjJObzZtdnhPWjNsa0lK?=
 =?utf-8?B?UGhHTUdvbkpJSXRBY1YwcllhWkVpdEpHRUV2STl4QTNRVUdEN0dQOU9zUDFs?=
 =?utf-8?B?RUI4VVBaWVZnTUFjUzlYS1RIeHFGRFVqVmV0bFN0OHR6SHh5alVYZjY0bmw4?=
 =?utf-8?B?OVZXeVFJekJ5aW9OVHoxNDJDb0lWRnBjUmNKZXRuWUEvc2VFaExNSk5Ya3dn?=
 =?utf-8?B?WGg2K21mQ1RFb3JsSXFXNnpxZXpORFJ3NWNRU21HdkNwTXVHT3NWdmg1RDFk?=
 =?utf-8?B?bVovSnZ5emhJNllyWW1hZUJSczBmOWM4azF4c0I2RU43SUxOWXB6aTBxRXJI?=
 =?utf-8?B?MzhQSGhsbWx3bklUclBieVFJTThzenFUN2xENDA0OTEyZUd6Ui9zTmhaaXNM?=
 =?utf-8?B?dDBhZVdQWUZKU3NDbFIwcm4vOGtmR3U3L0tYTURlVG1FWU5ORlZlWnAwRENV?=
 =?utf-8?B?YUlsYi9qMVZJRE9iYjNaUXJhYUE1UU81blZYUGsxcFBGVzdJeFllM0RiWlQv?=
 =?utf-8?B?TDlJUlp5TWFDS2hDbTF0aWNLQW5FM1QzVUo1VmxkM2Roa3VOWWNaL0hHaVRK?=
 =?utf-8?B?VXNaQ21xM1BIYndhdys5UTdocHhHa1hKTlNkLzg1dFZCWTA2UXJQM1B0bThB?=
 =?utf-8?B?TkQ4QkZFeGRKSG9qNXNqWXdOK3pjTkIwdWdjSStva0g4Y2hYVmZHb1J3V1dv?=
 =?utf-8?B?QUprejdtTGdzbnE4d1kwTlk4aFY5Yk55akNvZ0xaQ2lYb0xwdFR5V3hpUTV3?=
 =?utf-8?B?dTZoR2IzbnBYVVM5Q1hKYVFDcFBCKzc5eWhJRXJqaHQwVG9EQnAvakNVTzFJ?=
 =?utf-8?B?Y3lqZE9KY2FSbXhBNTdtVTZYT1BrZWhFMlRJeTd4K1BBenJhMGVRWnFHbTJ6?=
 =?utf-8?B?aUNXU2U0YmI0b2JTaW9uY3RZemVOZUFaR3dtc0JnODVkS2lVSndWUHRiUUpU?=
 =?utf-8?Q?6IAsqsy6bhLzPouHPCXFq2fn8Hxq5w4/zqCx7RrB+ymX/?=
X-MS-Exchange-AntiSpam-MessageData-1: X8z8hAmLykgaO7VzW+Zh8Fjcm3TT0GJoHrI=
X-Exchange-RoutingPolicyChecked:
	YXOxm45a3Pl363pXM2ly/7lFjp/bVcuNsEBiiT/Fb7pxaH8o9VQbksqd0vM8Jd/Ji1CeP5PE6u/ebOfNaE7cTaw3R8AfiwvtBURtzvzdbAKb76Fby5w5Oo5AnJ2uUO85LtZ7DXwfdSh/tGXEU/o1bF9ZeToTL44q9jgiDMd5w2L5OdVPdUi50oke1auoaGEJyTECqxpvieeCNAWFh2mmq3aZhB2LuMAKJD4vG38B743N7YcqoSK6NhGDUkghUfpBbgKzudMYctf1TEGOTfJs2+aGY/faFyNyAMjMmRYLulb6WF82oZSdKyzxaeHerNuscC2f3nVlo7dyYxB/o8k+pQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4tGgMo0D9EH4sCwYXnlGYy7nqtmiiQCV75xOby2RgQUhUOKhU733fkkHPDvatEX7Sq1ilQ7OcOqkXHT4qy2Oac/xyUDN9SUzQV2kb/p/2wuT1mHWcciRbWaU7tDb71nDDtVwaY51cPrVYWykhmx7RrsTHifWR1zzw1+1Lu1Q51Inrigzp6IHJR08k8AmpbwZ10NgSJUpzwvqQ+OWRW23w353EdPAQEoDdwnLkeuOJGqTKVly3/3SANtmaCe70rMATbn4dP8A0505MFEs7X+OMVuoUk6rpb3ELPpqD8FOVUW9u949taN7sF97hIQVhVeyC3Ax3yJhPcemLp4nJF2p//eP9Z4nNRM5P8hvXEwTRLIoVOCGoE7cP3kKoqCSPH8V7vbDwHwEr+eXNGt4k7jXvHqpcE+eJ+Ssf+T33qQ3eXA5E4Kv2cF9leN3p1XNX2NlvD8NDMKHnPbD3t9CevjO3eAIVR5iQlxiXQ9e6JbyMHIGyX95CM+U8lwjZ4/FNXzPkNCZ+bGmXlVKjja/Of3ImjMTNw2RHhlSt0u9ADLLcT2V9JkAnU+D9MHeZ0gW20iLUl6/wwRc3uUxQS12IiyU/KcjuX2RkMu71FcSSHla04JrU1fItHUvmzrxHye2cM/W
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cabcc72-fa1a-4b23-8b6a-08df2904e67d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:35:13.5928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I++9Lo131eeoq5vLjWbF8UQvKLik+PPjURuytHaI/ownKKlMtIjnrsnqsWDAngzfB18roBUy/Pn45ZtWg6fcBzRx2G6AJZmK2x9k/S7qYlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8978

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

