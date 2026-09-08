Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2602545D84
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 14:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788877579; cv=fail; b=QpOS4dVrzeS2Vw2j4D25gADPEol7tGdk9ft2NhIAceDfa1HSPn0+KboqyFA5D6SmgxlOigjoR3OpLfHRSazlZWdZVaaO5MDjGvsF6vejtvwEjnwnZJit2VF3bXI4bhLasDEd8vlgTerbxPDYWZBLDhppTdEcW3jxJPzoYNcsWDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788877579; c=relaxed/simple;
	bh=QSyqqK6d/WrT+nbMTTpnU1EKaGJqlJeq0/JW7Y3FyvY=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JF4eaeJzR5zBH3IZhzR8m5GZLJa6P8wcHtd7vEePsEQdPpAdMkt9HHmSLYjS/Ix3pQEoc0ViNjZOYlANMbxcN7cniF3NDNWKj2MK+ntlHNqiy2MAdcZyHLA73joQiI5Foc0oEXseUXR98nRHhFCw+7VpAjj8Fv6zqd+Q1E/T74Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DB8oJzr5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pqWu54Lw; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DB8oJzr5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pqWu54Lw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788877575; x=1820413575;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=QSyqqK6d/WrT+nbMTTpnU1EKaGJqlJeq0/JW7Y3FyvY=;
  b=DB8oJzr5hKDY2NwhIxu/REqPbt4vyrw5c1UNRiaL6kLtzohstAwsWVmA
   /efuM3t5fsi37tHVE4JYKCKSrEXa0M6dIKSAOwQUO4su8d8/Gbeh6UMzp
   Tp+pnSBqalLrvaXbI2Itfj9Kj6nf6lji0/Qb9LFIMXPslW/F8fYqUFFgh
   JBCr5nrUo53UPyKmo+dMd+dKyG1KahIfvB648PkWqCeHMIk+AQrwm3Bzt
   rQkw0GncZiv9uLqUa5KNiaQm5Dod444zuqXizBH79wycI+smKHa/tI0cb
   e5j+eQNXFCOTINnT3pzzleBekqh36JA1JN+zvATZXhyALa9FDTl/aJT1/
   A==;
X-CSE-ConnectionGUID: jPcyJns+QmSh91Q26OsXjA==
X-CSE-MsgGUID: 8tT1R811T7ycCbP/bbF9rg==
X-IronPort-AV: E=Sophos;i="6.25,269,1779120000"; 
   d="scan'208";a="150993174"
Received: from mail-westus3azon11011052.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 22:26:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/bIaxfppZ+sSlD4nxxkjoxreICYMRwMfwygyBg1xDQBmB8JZu6vfDH6KcCTGo7Es0XMwNXdviww6ksh2GCm2X93roEfipkSTlttglFy+bfl48OH9O5U0Y1NYvJQCOunx2LhC53oQc/T/UGaO5AEqKTsVxKRkX7Z5KUj4X61uUFvY/cflEjng0mbU/JEkFkq6rXKHI3q8ATLCVOarsL4Fq1LJmniB+7U+s90BhBViUKk7AFo99DTnJVwiieo6DS3pD542E/RfB+UD+3ELMVktLFp/s03XsiPNKWXpQueUmUVlam9RYp3Dvdgt+3DeeU3HlEa3htuLxNULz7nS+zc4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eO0ksCFcJ63oAVmbZQw8xY6jjeipO0hqSIw1F+qyo1o=;
 b=SfRl9h01XUOwa4ZtjsvSg4hhRfAzhcXZrn/g1g2hnlnB2cKhooB52h2Z+/6O4V8UApXEvJ1IAm6CWQtumBoUjfyM6ltluqV9Edlt45N08nY0sY4jB5FO4F3WJ9DjjeK8I+V6WOO5sfmPiuWeenXNK/s4vdEctVtB1gTxiC5AnNrkqBEtGwY1REHcOBM1+wmSa49Nzo23eGx9BmVULG8m6ilXeMfm0TvngoLWcjWRjC7BKOgBbtmyfFmTlizIUaOT3+Q6nwLqfQls93Sl1doMTKChRoVHC16dl9MsrkkG89MvFDkhWrtL04z90tnM4iyCiNFi25+M8ojJtOifyJmfqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eO0ksCFcJ63oAVmbZQw8xY6jjeipO0hqSIw1F+qyo1o=;
 b=pqWu54LweCGpcqzpr2+X1CgOppamPh4Tl0n46e7BPh2xPz9Qh33SrdkMIjzBiNQbnaTIYg6d2U2AXBmXjvJ+u4BJID99+Ho8iXF0dSrAmura4lcjzeIXMPfLZidoCrb69OjkemEZUl93TwI7yLNw2FYZWFvIKj4O2un5Z4Qdh+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB6554.namprd04.prod.outlook.com (2603:10b6:610:35::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 14:25:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 14:25:44 +0000
Message-ID: <b991417d-9332-4597-812c-f58315e21cfd@wdc.com>
Date: Tue, 8 Sep 2026 16:25:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] btrfs-progs: check: introduce --backup-slot option
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1788743334.git.wqu@suse.com>
 <7d6e89441f38b5893b17a03619aa3460c5a5438b.1788743334.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <7d6e89441f38b5893b17a03619aa3460c5a5438b.1788743334.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB6554:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d9ab767-b631-4104-ef8f-08df0db51158
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|19092799006|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 Sp3rm1uVQgD9OY4deagSAgbZ/im5GAybqFu4kFH7GJz/Abo+PD0gcEpAnXjJ3203e0TMISODkPN4y8ZR+3qKOC46nL/yOMCrrK+x+gu8Cw0ql0jxf7e9B5Y7tJJk/7D56PJIbgsSXZ0TBvQVhR0LlPkDaNGjSY3VstH+vGz0eznZDzf9rwVG+Uo78JPWRaSSvnEwouKJ6n9Uc2FMR7ebt2ybxX12nh51rlWBjja5uNyNNcfRphz6RvQ6sMBrT2HS1nSjHp4JL7/dzoS4Zj9povyi33I6y+zMdb9WJxkvrN5G+QlwIakbA9VihQ18AJjYghCzeOYWUWC16jlURNDI8XG/cqVQsR+UAEdG3RTIjDshvjWr2AK44aVDhH/kYnRNsF8DEeVcyZxr3y8szGAW8ZhHcIHp2ljgBXxvgih2Ki2LxQaUb9XfOYvqRogpTigRcl7+DaPG4cUeFz5s9HeRQJFCxU5N1QTdS5WrPKZfd/nTeHRUCIqt6d9+TlwLw8vXrkk7aJOeScaI+x660r7uPrSv8wxaGhCgbTivMvLy8OhE/Ufxdsm8/4JlyaFAooZ2teDPnt0GCW/5PcszSmbq/WFwIs5Yuxzn8fjDF6cE/lfsa/J1yrUxJauj7/lze9kHyVxG06bQTh833PGEavowPPhd4q23gjoVNL7dmTiKoL8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(19092799006)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VmJBZUFyNkRGbnNCdEo3RHZERDIxNXh3N0tBcm5Vak9qUXRRcGhoeldHRUg0?=
 =?utf-8?B?eGhreDJObkVzT0s2VEQ5VVVaMVhYR3ZQV0JWZjYxWGc0VDFMTE1aWTBjcGhF?=
 =?utf-8?B?WmNISTFEZXAwYVhXeFJDRzlobXRZK3NQbkR1TkhJYlNldkJ3UUduOGRQdllO?=
 =?utf-8?B?RUUzYXpSMmdiandLWTlmVkJSY3Y5Q2xmUG1qSHQzRVZFT2Y3eGNjaGRzdUEw?=
 =?utf-8?B?d1pNNlVtNHNBUmpsZnVUYndKVUt1cEw0RVhYcWd5WjNQbTBQczFWNE91WlJK?=
 =?utf-8?B?MWhBK0pBM2dhVDZMek1UU0JIdElKUkQ0dHJEazl3Z290RVVBcDh6a2NXUVpI?=
 =?utf-8?B?d0lKZ0dsMHF2dk9HelBNblUyOW52QmdIZE03NlBheEVkM0lNdDErV3F2Y2pk?=
 =?utf-8?B?NUtkSEdDeDRPRjZ0cTB6VGx2SURob2lCM3FFSXlqc29PYTd1bUtad0tldmND?=
 =?utf-8?B?QnY4REd4QnA3bWJKZC84SWdIQml1b1QyTFJkRDZKVm15UEg0NGZ2UC9QNmx4?=
 =?utf-8?B?WkNLL3FTa1F0SVZ0Y0F0WitjaTEvbWFtbWVDTjJDbVhZMDl1WmdYWlRERzZS?=
 =?utf-8?B?dWZLVFlSYjZlYkpTcjkvS0pOaDZkN2J4d2EvbHplRlFtVEZvemNpYlcrWlpC?=
 =?utf-8?B?bm10aEpRWDhtZHhRM3NocGM0ZmlpU3BtZFRaRXZ1UjhSSVd1b3hIRzNKUy9D?=
 =?utf-8?B?d0xSUWZySlp2OG1yaGFUVFV0cGdLRks3MEpOR2xGS2EvcTNiR2U1SmZ5TXdx?=
 =?utf-8?B?ajNDNnFJVkxzN1RwMFJ0NDEzdnlyRXgvVXpseXJPcVp3cDJoM05NNlNQb2gr?=
 =?utf-8?B?aFFwbC8rVnpFZGpZZEV1cVp6R1pzSGxyTnV4M08xSThGdVpPd0xNb2JJWHNx?=
 =?utf-8?B?VjJQVmlDTVVHOXJVMHIyZTBUQk5OeXFGWUZ4YU05cXBpK3Izdm9XTHM5cjBi?=
 =?utf-8?B?Nm9PMjcxQlZvSVRsUHhZUkl0M2ljUm5ad0piNVprWGdNaFFYK2NIdXFKVHFj?=
 =?utf-8?B?V1NFWDlMUXI1eFlNZkFQWGo2ZTI1dnI1aTQ3WjVQVXF5anhZeVhaRzF3Ukla?=
 =?utf-8?B?Qm1QVDdGLzF4bnJBeGloRkRRTXJ4OHFVQWpYRkkyLzljcFQ2L2JGeC9FbVZM?=
 =?utf-8?B?QXZPblFPemczYTIxaDZ1eUVGSDdta3hSbUlvaVF6MFNnYjcrVFQrRzRBVGht?=
 =?utf-8?B?TVdyck1UVVJhV05XSjFYZGhDRUVvTlF3QVgyc3kybm1Ma2UzZFJ4emlwSnNz?=
 =?utf-8?B?WitvS2hYMWVpQUtnVnNhUzdYbFlXREpHQ3BDNm1EdzgxcURVQXp1L1ZrdER6?=
 =?utf-8?B?NWZDTGhhc0w5Qy9oekxUMDQzTnRsVm1hNWZkS2orNDhlbDExK1UzaURRM1Iv?=
 =?utf-8?B?VnBCd05JSDdDSE9GRTlNVnZjRVpvM2l1S1NYbnJ4bEVlSU1sUk1Ga2ZsN2Yr?=
 =?utf-8?B?Y2dKb3pJcDF3eTluUnl6YzBtL1JmNUJTN2E2OUd6UEo3Ym85OWVVNFNlVHZT?=
 =?utf-8?B?WjRCN0lNZlFUMDU4Z3lnYUNnOHFpR0U3U1R0Z2JmRTlpTmVGWGxLck5pVUp0?=
 =?utf-8?B?Y2ZNOUdUSmJNUnNhK1M3VlZqWVZlM1loaCtMakxET3hoVWszT0NpZkRYaXUx?=
 =?utf-8?B?T1NDaGJsaFg3bHlmckxEK2VObUw5TytVN3FjYjRzb3BkVkJyVDVEaWQzbHRu?=
 =?utf-8?B?TUoyVGdnYzFnKzNVUXlTaWkzSEZTUmttMFV4SDh1eGU5QlNmSkk2S3ZzVHoz?=
 =?utf-8?B?aFl0VDArZHo4NXpYR0pudFRPUmYvQ0dqU1psaVRpZG1KckRkandzUjJXdU9l?=
 =?utf-8?B?TldEWGIxQWRmbVBwUTRsNTgxS2JlbVVwbzlZY2k2SXJSQXRiKzhGbVZlSXZy?=
 =?utf-8?B?OUxmMXllWUpEenR5UXBScld1L1VZWElYMUFlaU5hWThuQm51K05vQUluRk50?=
 =?utf-8?B?VmdmYnNBcysrMjRKRFRGZmE5TlR0bER3QlB2QlRua1VIU2llZzhrbHJ0WVJQ?=
 =?utf-8?B?eGplR1RKUk91OUsrR0x6RnhheTgveklTamtJOXBpSVROYVl6eDdWUWYzamtm?=
 =?utf-8?B?RDBIN1RHQ2ZqeC9MVTllQTRTa2hrZ1VTZlNnV0cwUW5uVTlJaVI0dVhWaXhN?=
 =?utf-8?B?bTgrdFVnMVdoYTM1dXBIVUdJWWZDTUFNY1RxSlVtNGltTzk2YTdONnhhbW9F?=
 =?utf-8?B?WitjZHB1ZVFLNWNRcVVuNEd4a05iNDNaaTNRcFkwc2oyZ0FKZXNvb2trQ245?=
 =?utf-8?B?dW94OTdYWDl3bllXZkM5OE93ZWlHd1RnbktPeXNaNTVFUkdZUzFXUFlEM2hn?=
 =?utf-8?B?dSszM0lFUmJJN3NITkpGS2JYZlp4RElYUndjdkJGTkxGMUtia21Dam8yK3pw?=
 =?utf-8?Q?+FUqP8bu2ZOWbI2c=3D?=
X-Exchange-RoutingPolicyChecked:
	GS7JUylVNP8TVRcbk6RRqWE3boEBblER5AorXs0DIsLkuF+NLOpKZQ5LsyUaU0FurI+zt6TirbgBqsab3ZWbPt4eX5gBucY4Wp62finbJd+G+z0BTPzA+eS/OKmiQ8HpQ509/Ahq3UdRU6+jY0MceXl3cfC80OeQwf1rDWOsFPo7kuyBebTdw5ucBvYvp0u/n7CkFc47x4rPz89fzsa3GlSuWiFudm2aHcJwtDwoy9AlEJewHgpcZdhMolMpJg4pfwMLK+Z7vDYCy/Doc+YZQ8D6j+ollfeGQbinYcPkzUuGJZe3czsIvUjfZhfnKxF/bm0QbwAnmJRwBsUvptv1fg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I5Avq+qbpBIgy3LLZkInu/+qOX1eJOtCa9loaK9JpfY8wY1i7HHE4OPTMxYRLmgUDbO/MxPM1tq05nsJ1Y6jDzMFRXGQqUYMRHukSAque8sri/nXSsW/A83In3TnjkI2GoFeg9PExzt9q0iagGT1SmTqcUiknpZgjpBae9FlSyO8RKhjcik71FAxhWxz0cqGCupiKi5+H8lrP6lkcybMbLWpgjxLYaMtM/eWQwLlwUk6t4V/4rb1r9iNWGJeIJu4TAcEz/Vjd4TncXUubqaJAWFxfpl/50Lr86XE4ZyZSQr/zgIv3N6UeKmbKuMLGL/rTxyJUcu82fPgc59itddtgFwtFPolOKlTh6KHb0IPy/jz4HdJ01K3z7e4Gb4ZkC/1Q8bzfg6ObkYkYU5KKMcnfz6XZ/11yBevpc+RcTKkP5tjlKvhGvjaVEqdEeWtjvoOfl7nv4za1qCZ6PlphdravvP9D85KW3Q+9MuRrW8innN093usMSmKVaC/dCuE2CyU9JscOVhGvVfc/ukRr3ofPF48FQ66+gUsYCx/mQIsfMKHS9oMO878sF3vHQDc3HKTF09n3inReZowv7TiQI1DO87d8Rdu8q5LFVswvQ/BmzWB9ZhasBe+wXS5vgMVOLsA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9ab767-b631-4104-ef8f-08df0db51158
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 14:25:44.3441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YIwXN2esO0xhemzu4Sw5YCppYwQKbUUqLf77myWNVBBeng4b+Z5xFy+AzZR5pbcKkuc3thXCWDldBlxJRXum3fSVI8tq2FhvVF26826fsJI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6554

On 9/7/26 7:07 AM, Qu Wenruo wrote:

[...]

>   		switch(c) {
>   			case 'a': /* ignored */ break;
>   			case 'b':
> -				ctree_flags |= OPEN_CTREE_BACKUP_ROOT;
> +				ret = parse_backup_slot("1", &ctree_flags);
> +				if (ret < 0) {
> +					error("invalid backup slot, must be 0/1/2/3");
> +					exit(1);
> +				}
> +				backup_slot_set = true;
>   				break;
>   			case 's':
>   				num = arg_strtou64(optarg);

The error message doesn't make sense here, the backup slot is hardcoded 
to "1" above.


