Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB6441A903
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 07:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791963453; cv=fail; b=Xg66SeL5VrsJ7Rnt+ZciF0xwO0FiRhka1lUq1aJt0XdBaXjbDdyg4PG9wLgTlSrb39oCT6qrEBKluVJXBFfQMOYN4PCWE3bT9nMcZ5Dqh15I+roJuU8AnVBsLA7dOoHGwqpKbRad7njRElZaa04pL25ZPV7zu7wqbEND4mSEMmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791963453; c=relaxed/simple;
	bh=HlD5FN3vJHGMSUysN6Qz83bUe0cG2SJomhSWL0CSWao=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=t/ZEluJo8b58ElCmbMW+UJiFdVf43P5UR/Z9ZoqRXmL2dMdv2qQxmZOyQDEc6qXb8cYWh2Ag7UqiI6pyaIo9PeuNfVXqXCxhYZlYG7pj2ytB+BOM+bguqfZkPMo9IQEsrTNXPd8nLWi4xC+wCQZraSaIx3LcGbmt9IHvu41SDgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KqFMlzRA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Al/3RKlV; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KqFMlzRA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Al/3RKlV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791963445; x=1823499445;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=HlD5FN3vJHGMSUysN6Qz83bUe0cG2SJomhSWL0CSWao=;
  b=KqFMlzRA5H31H/Mqf/n0WYL5/H+7sDRm1LHbdUfpSSCKYWvgdlmSiePw
   KTS4XgtpVzhVgqW2euSVgEoIGg+ufZAK1YKwspBrSdqnBd5jsHZ5bbdQm
   CV4vG1lnlh/wR0DBh36ECAwouWnoD/d4MxU3M+JukmofDWDVBhCUj7qDr
   Hjn5OVaJYceJEFPRk0vczJs1UZaMdXCeHYkHkOPwQsgw/sQ9bTrQPTxwS
   y+SdNSpv9dOQKkspjB/CGMTqrjOEstzSGW78kwka0UoSW2SVboCQztpZ8
   0oPNzi8NGPtIGCBGj8hdk02bwW96nTZkeKWNLzyTMjMmWBiJWwJpYK/Uz
   A==;
X-CSE-ConnectionGUID: pTl/3TiFTg2GpuC9OQRAOw==
X-CSE-MsgGUID: hdRGB84eQyKxB9G2Yvu0wA==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="159009576"
Received: from mail-westus3azon11010000.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.0])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 15:37:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vNLL2gM16rD4wOvzUDGJC1hxvJ7BHXQ6lVnDdohuEeUbHp/TaO4alAFnRnudeFTioUcNIkkKHZLK1kGncYWYVqqRqmS0kX7olgwbaR5/FbY0K1lCAehp69WsOJT44GWAO/Jp4n49G5W5N6xn5HsK5Sde+BJZ9NSJXiX3wBJRt90KJCPlsXuvtkTul7uldILMwD9YMyxoLNkCtfEfWX90sF/2RBDedLXBpmN2IN0Dmvt5pcP1CZUmSECjCU9dlemgHMj5WZimF30vxKjA5yWsIhYENL2n5FPcGc9TSkh0PVULWNKmRFtbZ33yS7L9xvT2IHfr45cr3kgaynQe7AoUeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rAN0FD6uUY2n5fifIq/BC4at1Urb+Wl65v/ODOQrLM=;
 b=bgCKKR+pVO/5kLc0yIXcPO/ZjfdrKfQAvDxtCodeaU39zf2QzIh1+aHicOK2b16Z9CSrt6CIyc4F5RnXO1IJcX0n9fBoUzGLmLeH9JYeVioChjqvTrKLqkto+274hzyWuV6QmpTlokbmXYsbzxknBMmeAG746mIHoJJCjm2XIdltEEyFa0mWziRUYDu+blG6kyRdYtd+0CTgOdqiZeN51+iLyR3FULcYGTzzvlybJoFekoCIw4RIjfKTHa/yiBMGmI85Ay7mWJBpvW01KPrg1D5pX97Iu1+hitdOQSA81qDz/xN7o4LJ3bdEpv9KNr7a/1Zce0NLPXlNiYQelpTHIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rAN0FD6uUY2n5fifIq/BC4at1Urb+Wl65v/ODOQrLM=;
 b=Al/3RKlVjJ2Jn5lRFUajT+FcHS1FRIRl1FHZYNSD4xdrI60hzg9dJ+i/8KAzUxTlyQ38oFeFRmKvMCsI2ppTukZ0uURulV8vveXdler49nwSSpdndMEwNZ6FZAYN8LJOGF9FdjcT96ER0u3Qq0yK0RpqHMssGj3pOau44j3lwcw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by BY5PR04MB7091.namprd04.prod.outlook.com (2603:10b6:a03:227::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 07:37:15 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 07:37:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 Oct 2026 16:37:10 +0900
Message-Id: <DM4E0R5WYR4O.12LSV2VUB7NXS@wdc.com>
Subject: Re: [PATCH v2 02/12] btrfs: zoned: don't activate conventional
 zones of mixed block groups
Cc: "Damien Le Moal" <dlemoal@kernel.org>, "Naohiro Aota"
 <naohiro.aota@wdc.com>, "Qu Wenruo" <wqu@suse.com>, "David Sterba"
 <dsterba@suse.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
 <20261013072941.424029-3-johannes.thumshirn@wdc.com>
In-Reply-To: <20261013072941.424029-3-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TY4PR01CA0019.jpnprd01.prod.outlook.com
 (2603:1096:405:2bf::9) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|BY5PR04MB7091:EE_
X-MS-Office365-Filtering-Correlation-Id: 29edb742-3fa6-4cba-d55f-08df29c5f6fc
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|376014|10070799003|1800799024|366016|6133799003|10067099003|18002099003|22082099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 KeIOxCAeA5aJoWheyW49Kagh9zSqNZ+vSddk+B90zAnhysZAKhps5DCk8EyVfImAbv0cIim70KGnGoen8PLm5HBlWiCknJs0mu+tcgokIpdGtPqSOrv42q01NCTPmLeBU8g13mkIKvstWTI4ohzUrJA8/C4ZH2F3C9N62B6XdfqOaLD1Dow+3ODcHFpmSD7qEEMG/tFXItd+h1+UmTWt1gBsrDHybPEgKh4Htnj4MxhcUhYYfEzSG+S4ol163BvcNo4JTUTeFVuYTecrgxkiVIKK+oKcVVK2FrZMnSwaHPu8rFtrKt002T3cGFaPeQGL8HC6ttQpDXxAUfGENa4xh/+MfbNq94ZxXGpEyCmwThRvN9KZtd91wzqiecwywC5ZtKHvsME0sccjVzsXMppfBkA4GrxSMcthav0zaOqWdcvQwoaMYNN2sTF+QLP1015fCIzk4uadfTfsDLgaiSnVmEULeOWRO2KRplWOPGxAoXyNY5s2zhjdDfYZRTN78iZWdPgswQG71WR4O+YKVBfPXoMfhqooS6dJ454MRYjHdrkZJoQyu1WI19+9KE2/xwm+IJTfZ6zIWb6u4ZBg/57i4hwXOVctrsI0IDrnONVRFqDi2vllKLtKoPIhrScffQ3FwhdX3PTYAWg/fiyrXRpZb++9QVVX+t2b8BJVDymMVQs=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(376014)(10070799003)(1800799024)(366016)(6133799003)(10067099003)(18002099003)(22082099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UGpjMjdFcjg3ZVA1SFN2Ry9uV01uQU95dDh4OFpUd0tPKzFIU3FhZjVMT2ZH?=
 =?utf-8?B?QXlSMGttTEhLYVpiOXc3UG5zbDZZekVNQlRkOGVSbVFxeVU3UzA3N2ZQV3dn?=
 =?utf-8?B?aEIzZEk1enhuK2dreGlqYTZBRE5UWG93NDJ1bkRLL3BCVzNveTFkVzloTG5M?=
 =?utf-8?B?eGx6OHVhOUFrMnRJdXhHRzEzZHFoTGlOWk5ndmhySGNSb2R1ZTdTMjF2VGhO?=
 =?utf-8?B?Q2NjNk41a0ttWkl5QTF1L3BEUSs3L2srV2ZHQmsvMlpKZks3bXAzWkdibnFk?=
 =?utf-8?B?bTB3NkV3Yk5mdEhVMzVvM3pnVTJnS1lYMXlYN20vWkx5cXdYaG54LzdYWk1p?=
 =?utf-8?B?M3Q4VGFaYllmV1F3UXowNUZRY3ZJb1pGNHRCQmFyTUZvanByK3REODZmMUNG?=
 =?utf-8?B?bGE4ZEI1QkdiWVZIdUlyYmlRbUtrZjFFVHlJL3UwdGFoT2ovVTZjZzJCTXlj?=
 =?utf-8?B?UUNFU3ZpQ1dseHBLSjNSY0tXVXpweFR3U2JPZHV5TldrWWxwVWtPZCtnWVhz?=
 =?utf-8?B?NUxBRjQzRjk5YmpDeTZwM0pZa3ZncFFlb3JQL3U3R3VyM1pQNDBObjZiS3Qw?=
 =?utf-8?B?U08vZmw4QzFQNEFuZldiUTFsTW4waWZOc25HU2JaR2M4cm42dTVuc1RqbmlS?=
 =?utf-8?B?d2x4UzM3V2ZRYXJxQjBPVjRRMktudGphcjNNd2phanRKa0F1bnlSNzNUbEVh?=
 =?utf-8?B?KzgzZjZycGkvdjc4RkVoK2x6SklnbWgwS1ZrYXdxNHhkckRpTTdFbzBvaXcx?=
 =?utf-8?B?aVptK3Ywb3kvcEt3eTk2MWZoRWxZUEczcmlWVkJocEtnbWg5a0kvRWlDWDdv?=
 =?utf-8?B?cDVpZkVzM05MWlBRbTNTUUJ4b2NtRE5CWHBBaUhJb3Z2ZVF6cUdlRVZicTZZ?=
 =?utf-8?B?NitmcGRLL1FrYlJJeCs2TU1KWERzbDM2ck9mZTlyRVF0T1B5aGhBdjZZRmtn?=
 =?utf-8?B?ODI5TEUwR3RKOC9UN3FDRW5WUXZUSUdzTkNibmhlK3pqM0lpYUVMSVVsWW83?=
 =?utf-8?B?dHRuQlNrbVk0VXVVRHBITU9VNk1uMlNmSk10UlVYWnNkNnBjN0NaYzUwZlE0?=
 =?utf-8?B?S3A0c2VzSWQvbFA5dzkyS3R6ZmE3dndrNkZHa21NdkxoUjg3U0VZWXlqZHJR?=
 =?utf-8?B?R0RpT0JzZkZmZWU1QWloNnFaeHM2Q0lwTEtDRTFIdkVyTVlRd05rbFFVV2Vn?=
 =?utf-8?B?Uk9aTmd2Yzh4MnZMMHpuNW1XYndrTmlHTGJLcXl6UjJpVGhFNm5hNXAzMDJP?=
 =?utf-8?B?bTNOczBBWWhiQXFoditnaUNSTVIzVHFxVURIUVNTMS85TGhuc1lsK3o3QWRJ?=
 =?utf-8?B?SmxFcVZrOWJLRlRLNUJOZGxJeENzKzhDR2J2eWMxQzk0SlduV1Urekp5TDN5?=
 =?utf-8?B?S1VZcmNLTUtHYlU5aHVLS01aWUI5d1VvREpMbmY1NTRMTVFLcXJTNDhWYlBp?=
 =?utf-8?B?MmIxaU1KZ2NlVlpJN3dEeGpwU1ZzajM1OEI3NWczU0RCMFNaYTdWZ2dzQ0t3?=
 =?utf-8?B?Skg2UGk2TjM4UFdnaVFVL1A5Ny9UZWNMcTJiSWpoUmRuNkZBWUlUYlpWRWEz?=
 =?utf-8?B?Y2ttRXlYMTBuakZFdXBpeFkrMjdHRHJoRmNCR29qLzZzVzZac0ljaE1pemsx?=
 =?utf-8?B?UTNOM0NNeE9FVXVmN3kwUzY5M2RyTnlxT3ZRd1BsWERNWStNSSsyRm5KbEZY?=
 =?utf-8?B?OWVJSmFvcG1yOHFMSGVxKytqY2pyME1laHg5SzVsVEZvMk5YNlZNQVpZU0pp?=
 =?utf-8?B?bG1hMEJBV2JLeVJwY1FSMk5wVXAwUmlUNEtkdHozR1ljbEVuTW9UL0VwU0Q4?=
 =?utf-8?B?ZGRmeUxHSnRFZDFLRkJQNk9SQld0c3NYVVZqaUFlenlwMGcyWmMzNWRvM1Uv?=
 =?utf-8?B?UEMvcTJLdDFyQ0dKTjdzN3N6WkxUUk9CUnpoZjFxS3FmcitZL2prYVA4ZWxw?=
 =?utf-8?B?MlYrREh5bWdQcElsOUZQQlBtQ0h4NmxYK2ZOOFBvN0J5czB2V2xxb1dmOXVX?=
 =?utf-8?B?OHRhYmtMaWo4dWV2MlE1b1BVV0dvTXNyWm9oTmVmamp5eEVRVE9GR0QvaFN4?=
 =?utf-8?B?WTJ4YXgrdGtIRW1yWGJLdWlqWGd3Qk1XQVZyNExLTDJIVnBlT1RtUmVBWXor?=
 =?utf-8?B?TG5wQndYRTFNT3RwUmtQSGhMUm1uNThYc1pDMExVTWc4RjBremRvM0NTNEc3?=
 =?utf-8?B?MXg4N1pxQW5lbEd1Nm50M2JqaDIzWEo5ejZpRzlJYzRSMXB6di9URSs5Zjcv?=
 =?utf-8?B?a1p1UUtTY1pQLzY2aUxGL1Z1YWtSZjVST2JPaHNyN0hpZUxUOWg2Z1Q3dCtH?=
 =?utf-8?B?RUZRSnk5SHY0TjNod2R1MkRTak9ob3FsTHhrRWY3Mmh0cHFrZnpXUFF1Vklz?=
 =?utf-8?Q?kPzjD5fCS6sEn9KKI5p06tH7zKMY1x3lacSxgMqHAqYxR?=
X-MS-Exchange-AntiSpam-MessageData-1: P14iTS+UCs2l/w==
X-Exchange-RoutingPolicyChecked:
	5DkbZIj2ZwHnGT7QQfg4rLUvu/Bnd+8nizuizr1E3k8yTRLFjX6YOgIEur2XxE0ydw8EtAEvwCoBnoD4sGK+ET6Fit1qcsfoCAQf567rKgMslbBhD/G7PE+wCykIyQeRnFsdWYCYZAxFv4nuT3KOQ+JaXB+9hwkNBC/QiqrHVBl8e9ZB6GHIlNdgloooqqzTuarxQkvzdkVhvinr7nwYCXjwpvhfAuhK4sKaIRRM+BdOwWQIs9TsQVaQGaQJ1NcfMXeFytsonm5dDVAcq3NrHcbkJhWttIv2GHJgSQ+BqUtB0Jl1n1Ojb1vOKXtsGjL0v4uF3XTShT7I+Gy1LZzkeg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z0d3+a9JAGwjuiygzlTKVzajBHPQTbiCxTI4w5tDaYzAjQN30NxOsw6B1k7o23qlcEJEB0bYlnlNCHDHnkCn2HpuOFbBRymVjrWsRg+tt2UWQ/xctuWdV12WXkjEUtC7H7++e+wg7csm/sPQrnyUVIkgZdtQD9ivCVyhhSoZIYlRld3KzLb+2WYw5ni8t3CIUMoMVsNbqtEoUl9BaM66mYc6Kfue0kvJyP7nzmJ9a8IfXuy306jIVkQHu8+St4OAfShDXHSI9obN5b1m8GPHKQ/xWQt6iqpsDb+YGCeaunO9LH1iS/YQmpEpKN3PJlgKGWHeAtUkhKKgkhJIbwmy/vfmlS4ojv+z0kViYeiJF33/1CBMiYnpcKzs6RgLibsbPj77pS6tI4RpOgUtlz8DoSbkJwCbWcaLdqWZr/DwX6z8KBPNNLpX/OirMZF8PiNzkF+ZmGX/A1nLcR7SkrHhAr45v86Fjb2/PqDo+/qR4joTtg7CMqJDc27SkF1NpdUTYhJsdtfCkA/TA5ZTaF6xulT91z+Z3xyLz7FDiRbCGGGkOD5R+3KugRNxoWCgtjIpUbNxgJr8NZ8AvzGAtOAYdVOSGPfRlQ9k9FpEhYYKyZWSeQ0jN5XOMI2vOWns06gj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29edb742-3fa6-4cba-d55f-08df29c5f6fc
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 07:37:14.0658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nTWw9WcbKM4/4QZGKucFFr0Rv+Rkaht8SkwxDTG/GaKs9Vrw/fPLXWeSfdPHz5NwZZUvJUbKxCLtD7yDwS/+ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7091

On Tue Oct 13, 2026 at 4:29 PM JST, Johannes Thumshirn wrote:
> A block group can be backed by both conventional and sequential zones,
> e.g. a DUP chunk straddling the conventional/sequential boundary of a
> device or a RAID1 chunk with one stripe on a conventional zone of one
> device and the other one on a sequential zone of another device.
>
> On a device with an active zone limit, btrfs_load_zone_info() never
> marks a conventional zone as active, as there is no zone condition to
> derive it from. If the sequential zone of such a block group is active,
> the DUP and RAID1 loaders see an activeness mismatch between the stripes
> and call btrfs_zone_activate(). That takes an active zone from the
> device's budget for the conventional zone as well, although conventional
> zones never consume an active zone resource. The same also happens at
> runtime activation of a zone, not only in the mount path.
>
> Let the conventional zones of a mixed block group inherit the activeness
> of the first present sequential zone.
>
> Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 50 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 38 insertions(+), 12 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 51699136405d..3af234dea6f5 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -1959,6 +1959,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_=
block_group *cache, bool new)
>  	if (num_sequential > 0)
>  		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
> =20
> +	if (num_conventional > 0 && num_sequential > 0) {
> +		int ref;
> +
> +		for (ref =3D 0; ref < map->num_stripes; ref++) {
> +			if (zone_info[ref].alloc_offset !=3D WP_CONVENTIONAL &&
> +			    zone_info[ref].alloc_offset !=3D WP_MISSING_DEV)
> +				break;
> +		}
> +
> +		if (ref < map->num_stripes) {
> +			for (i =3D 0; i < map->num_stripes; i++) {
> +				if (zone_info[i].alloc_offset =3D=3D WP_CONVENTIONAL)
> +					assign_bit(i, active, test_bit(ref, active));
> +			}
> +		}
> +	}
> +

Here, conventional zones inherit the activeness of the first available
sequential zone's activeness, so it can properly synced and not causing
issue on DUP/RAID1 case. But, how about activate conventional zones when
any sequential zone is active? If all sequential zones are active, it's
fine all the zones in this block group is active. Same for all zones are
inactive. Otherwise, at least one of the sequential zones is inactive,
we can still activate conventional zones safely. We only need to work
with the inactive sequential zones.

>  	if (num_conventional > 0) {
>  		ret =3D calculate_alloc_pointer(cache, &last_alloc, new);
>  		if (ret) {
> @@ -2450,6 +2467,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *=
block_group)
>  		if (!device->bdev)
>  			continue;
> =20
> +		if (!btrfs_dev_is_sequential(device, physical))
> +			continue;
> +
>  		if (zinfo->max_active_zones =3D=3D 0)
>  			continue;
> =20
> @@ -2516,6 +2536,7 @@ static int call_zone_finish(struct btrfs_block_grou=
p *block_group,
>  	struct btrfs_device *device =3D stripe->dev;
>  	const u64 physical =3D stripe->physical;
>  	struct btrfs_zoned_device_info *zinfo =3D device->zone_info;
> +	unsigned int nofs_flags;
>  	int ret;
> =20
>  	if (!device->bdev)
> @@ -2524,18 +2545,17 @@ static int call_zone_finish(struct btrfs_block_gr=
oup *block_group,
>  	if (zinfo->max_active_zones =3D=3D 0)
>  		return 0;
> =20
> -	if (btrfs_dev_is_sequential(device, physical)) {
> -		unsigned int nofs_flags;
> +	if (!btrfs_dev_is_sequential(device, physical))
> +		return 0;
> =20
> -		nofs_flags =3D memalloc_nofs_save();
> -		ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> -				       physical >> SECTOR_SHIFT,
> -				       zinfo->zone_size >> SECTOR_SHIFT);
> -		memalloc_nofs_restore(nofs_flags);
> +	nofs_flags =3D memalloc_nofs_save();
> +	ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> +			       physical >> SECTOR_SHIFT,
> +			       zinfo->zone_size >> SECTOR_SHIFT);
> +	memalloc_nofs_restore(nofs_flags);
> =20
> -		if (ret)
> -			return ret;
> -	}
> +	if (ret)
> +		return ret;
> =20
>  	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
>  		struct btrfs_fs_info *fs_info =3D block_group->fs_info;
> @@ -3098,8 +3118,14 @@ void btrfs_check_active_zone_reservation(struct bt=
rfs_fs_info *fs_info)
>  		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
>  			continue;
> =20
> -		for (int i =3D 0; i < map->num_stripes; i++)
> -			map->stripes[i].dev->zone_info->reserved_active_zones--;
> +		for (int i =3D 0; i < map->num_stripes; i++) {
> +			struct btrfs_device *dev =3D map->stripes[i].dev;
> +			struct btrfs_zoned_device_info *zone_info =3D dev->zone_info;
> +			u64 physical =3D map->stripes[i].physical;
> +
> +			if (btrfs_dev_is_sequential(dev, physical))
> +				zone_info->reserved_active_zones--;
> +		}
>  	}
>  	spin_unlock(&fs_info->zone_active_bgs_lock);
>  }

