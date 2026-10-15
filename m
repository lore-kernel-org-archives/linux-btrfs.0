Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80AC3AA1BB
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 02:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031662; cv=fail; b=UcpHETxeDcCpS5Vu6RhCZdvMIaPfS34o1prw+Yha3U1lVyKdR2rFyUMT+AlDqitJ2gIg/mwbFB/eAT+TpFjvs4l2U+Ppu1c3zoENwcniltlqt/8AAlkA5yvO4erMSxuzeL2A8c3Bj8dNGFmqGUc00Yr+e/YyMxh9KNmHfGQPbos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031662; c=relaxed/simple;
	bh=2tr6DmDv4DETmzxhCvxo8gp4jU1536GTLplTU81JYp8=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=HPZ7D7uM/Ej4+pbBQVv3HTNuwDVysqgsdFwlsPlAc1de+a9na9VTdUrl/7688XaV1C64zoKXfKjEKzsu8jhNkcBR+0yLyuIp4HtQxMEWw12NFhsHl9VYKJio1dpj4rlRFOU4iIYOErAEZ4PKVauJDn1j0YnA8kIzpxxGGhbA8es=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Jb9sfzB+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=de2C16Xe; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Jb9sfzB+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="de2C16Xe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792031660; x=1823567660;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=2tr6DmDv4DETmzxhCvxo8gp4jU1536GTLplTU81JYp8=;
  b=Jb9sfzB+uBNulXHi/Yc1uGJ2rb5dOCsWFG7eVNmbaJ3TAORmb4Dtu2hn
   e4YO9luKDlCd+IXaIno//MkzU+UrTVuoGwR6JIiJPKRprU5nKntLN8FF8
   qM642BH18u6wxgDkl2Ntmn3Sq2R1kjYKwBLF6LYJu+tWHSL5zsMbyZ0Co
   dV3vacBvQgQGMhUWMrHaZo5/XGE6vxaBXBGRbd54aSlPKnviPcE7bTrx0
   6g6fBQKC+VCms2Pu9usFrFJpt2DMYUbqVFlTpXQAvEMeFro6PPLjjzWKl
   lP8a3nqcSs57hRetGzz0tRjnApOOyu4lZJtdToVLDG/xkxLLkdbOjuweu
   g==;
X-CSE-ConnectionGUID: 8q26fzjgQPihm3pwe3k30w==
X-CSE-MsgGUID: B6Zm7NUxT8qLEnGY+YfCvg==
X-IronPort-AV: E=Sophos;i="6.27,159,1786982400"; 
   d="scan'208";a="157175369"
Received: from mail-southcentralusazon11011037.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Oct 2026 10:34:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULxu9Zn709eN5XPyFSzUFjk3l6t3ru+1Ag2wn01X9fPaq+OVN6HTMhw9rLwxNQedcto/atTsNkGU62Av489tgOs2Xwk4oqCcDced4iOCZ9kpEX0XfkIP2uJOq/gMSf7iY3vX66mGQW5ahsMHR0s0B8x2F+4jLXvVPOzdmIUEsPlq2LKMkJx66HqQAPzxdB4oh7rvWANul26h5+UUQeQkEjFoveP95XLxswNzHNwMoC8US/G4fx+ruIK66O44fPNX5lB85VHpIqKt5M8aMLsRjLmaGuRtnSyUpFkXvhwbpC5nTPw0z98fCaQYC9HgOPpQ0NNM/o8noQ1ZDdVQAljY7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXtPtowBgNOzVe05VPJZC/B9rqH6CWGa5uaD5NFXr8M=;
 b=Y+8QlkVOdTynhGE15Dmwn/MD71tMm9ZUt7qHlJhtVzh6zedzHaZloqz0AgYfQUBbpOjkPKbOZIw/q76Y8vvVbQmMvmpiiwCXFy+b66kt/Jku+GGkqBfjGYa+VjBAn0j8wfi7015ds6mLWxhoJI5qukt0Y4iE6gU90VmU9AnuAcCd91uiCdg1JMMVT2PYelFiEv1TNc3rvonZnm/BF08aI3/yP+sY9pD7sjDEyxM+6XkIeyD9Ipqjpx0/35EZ5N6kf63/5eusg5F9WQY1SmymxKrujW1bs/Qu9PBElEdxI6KnYw2Q2XCA3NF7qWB2+olYr542djVc1QhPrqBqwjbXSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXtPtowBgNOzVe05VPJZC/B9rqH6CWGa5uaD5NFXr8M=;
 b=de2C16XeQVoFDWHgwuqx6vDC4yvutqMPrw24EQn5m4NYbBsF/LKM4RZH3udQODLX4oB7Pm/CjDtTonRUEE4TfqMuxQdGrZo1rmrjOUz5zoaJRQaP1sjSS0mvP/yoOsou9QH0KCGrIT4VC7loV5Afh3nri4spEM7Wh3OkFoptJb8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by PH7PR04MB8554.namprd04.prod.outlook.com (2603:10b6:510:2bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 02:34:11 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 02:34:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Oct 2026 11:34:06 +0900
Message-Id: <DM52795IOW2A.29N64WD1LGX3R@wdc.com>
Subject: Re: [PATCH v2 03/12] btrfs: zoned: skip the append only metadata
 writeback path for conventional block groups
Cc: "Damien Le Moal" <dlemoal@kernel.org>, "Naohiro Aota"
 <naohiro.aota@wdc.com>, "Qu Wenruo" <wqu@suse.com>, "David Sterba"
 <dsterba@suse.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
 <20261013072941.424029-4-johannes.thumshirn@wdc.com>
In-Reply-To: <20261013072941.424029-4-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TYCP301CA0011.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:386::14) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|PH7PR04MB8554:EE_
X-MS-Office365-Filtering-Correlation-Id: fed4a863-e755-4d54-a6f6-08df2a64cb85
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|10070799003|376014|366016|1800799024|19092799006|6133799003|10067099003|22082099003|18002099003|11063799006|5023799004|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 c2rW5nKE3uNDnmuWxIkK//vxdcE5ppvluwIz772IZfwRPxADTL9hpeTRf2FqtXLH+k6vrALu/M54oTJdpdBHRaorkJOypOjPMvM9qOvek4UpQx8IBiOi/oA2NueaaRzs5XKoca1YxZI6hgbPaWdJYsdgX+XhDkJgCnxDb0+V5u6RirYRRe7fWiqrrE9rtZ86HIamDg1o/XC7fk6i9f0/wukh+nvC1EUlTMhrTHHvBdfCmKjDjxgNdkb82tTiyguwjI4v5VJ8vliMv43J62t0mULdzd5pci9qsDCUIjNc+48e1Hc+MEPK8X71UYmzHnDFTme+TJcVq7+IgxoosLVb+U7OWi3AjMRITfMBXchZNyYyc18fM89fCDYMp0qBb/c4KUoX5HJiQDFkXJC/fFn/b55e7l50K0iNg3rxUJSMeRMHoJOuqYeGlgKfz8MKT+eeHPDovVVyG8LIyIdaY92Qf3U1Api50AQJRoKh5/fj7a8k/ey+kJwFx+bhCEClj2eCppyEN7O1NfUsOC0ViSC2QqsWDlhjFYa+F6OIP87E36aIB6ebAbjiDgFYsqcBZJxdQGhtxrM7/rDOw+br+Kx70pdMdotQkQsT5+fl7j9ZQcySKvHVhmAg+M5MCQczZ2MlgLGEbcw9wqlSANYNJG5fBVXK7FYs3KYiW+XQY75Qfmg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(376014)(366016)(1800799024)(19092799006)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006)(5023799004)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QVhheWRML3pZL0s0cVgxQTlLSUpqQkx3czJpd0c4dDdkblRUS08xY1JrYWZ5?=
 =?utf-8?B?dDMvZFFvY0hrS2F2d2ZCNms0TytNUGNjMzBpUG40S2ZUQWpyL1RwWk1aZDZS?=
 =?utf-8?B?Z2pTT21KOTRQNjVMVE0vRyt1SWx3aHUvN3dpTXF0dGVtQnRiVnhwamxhRDQ0?=
 =?utf-8?B?ZFZkRlF5MjFUTGRzeWZjZ3VpM1RsRW1pYXZUc0VqRHZ5SDVDSld4UVE2RFpi?=
 =?utf-8?B?TzA3RHJJTngyNFA1TjFHNG9JeWRicjEyVWY4QXdaNFdDUFRhbmJJUm9sdHhS?=
 =?utf-8?B?WWJtb1daR2Z5R1AvTkM5czZsb0xBaWtGZSt2MTRacjl0OXlwbUtYcnFiOTha?=
 =?utf-8?B?cWozSWlOeFpGVmVLOTdLMnN6dkt5bmlBc203d2xtYy9KaFRKekZablg0ZjR5?=
 =?utf-8?B?ejVQdEhBZUNweG9PdmNRckdJS3FVa0hDaHl6b0doVmtQMnlta2hoY0FNTGEv?=
 =?utf-8?B?SThXMk5mcm1IRW1KTExmNnMzNmIvQWhPZHl4MlZWNFhjOWZNMStKakpDWTd3?=
 =?utf-8?B?bHdEczRzRms3REZHQVNrb2t2T0RvU3Y1WkEyRHk5T2RsY3RMZ0IxVFFnb055?=
 =?utf-8?B?OHd0YjhiYVVPcDA4TkpWTm9ZRUNHQmRtTDNSZ3R0azJtc3RCdTJBVUd0eEpa?=
 =?utf-8?B?WGpjYVorU0NiaG1wRjFXS3VzTkZMbFZYU3FQcjZTaHNuWWR2dnJ3VlVveThq?=
 =?utf-8?B?dTJrY3FJTkR6SStQTFM2SzlrakcxUDQ0RUlvTXowQVZqa2xoUEVGTlF6MkhC?=
 =?utf-8?B?R0xTaS93ZWM1VHNZdXE1d29oMkQ2YXBJYm56WUVaTjd1dHFnU2ZSZS9SNVlx?=
 =?utf-8?B?VWpVbFpvaUxFRTZ3akQrazRwNlhUNFNDZWVjRDFTWE0zQkRSb3M1UmJqL3FI?=
 =?utf-8?B?UzFubTR5OVJaRVpFYkxmSkROYkUvdVFZNTFCMUtrL2QyeXNKdHNjSkw1MXhF?=
 =?utf-8?B?a2JzVGNDUWlwSERkNTY3NnNBNWFCUG5raFdXV1pEbk16RlZqMXg0OWlvY0tS?=
 =?utf-8?B?WUJrbng0dFdoYzdzNzk3M0I1YjNsTkYyaUQ1V25rM2ZHMkx0dHRYUGxob0VJ?=
 =?utf-8?B?REVDUVJhdkwrM1U4Uk45ZEhLRnhLL2FMYlhFalNheFhsWG9rVi9BOFNSdDdj?=
 =?utf-8?B?OEJkT2gzU2ZMN1JKVzBLOUIzM2lnaTNzVjMwS2FGR0dYWXdlTnhlN2prTGNt?=
 =?utf-8?B?UXV5SzUvNHVqZXBxSGFPa3ZFaGFva3pVeVRZVmQvdUIwMU5pcmtwR3haL3dj?=
 =?utf-8?B?dmRRWXRJMnVqeEZxelZHd0lScm44bUoyK0NLKzNpd3VWeHZUZFZsdExlbG56?=
 =?utf-8?B?MG40QVhITVNXNVVFaTh3M2d6b2NLdHRxWFg0Mzh2WUZZTTlmdlRrcXFCcXJq?=
 =?utf-8?B?MkFVd2JhSTRoTER0YVBGbUVsZEtma2RMeUxWQnJ5QzRVWTgyUXJUVlFGZUZv?=
 =?utf-8?B?N2dhTGU3Y20xQVBONDFtUzAzci9OVlFyMU90WUpMSzhHWmRBMjBoWEgyVlZK?=
 =?utf-8?B?cmt4Q21nR0tXRC8rbXNNZjdOUE5RcUliWGJaZ09JOWVFUndsT0lRaHBudlp0?=
 =?utf-8?B?bkdzQmJRekZuQW4yZ0EweUhiYWRqMytoOVJYOWJoYkJwK0Q3VXE0S3hlaWJq?=
 =?utf-8?B?Q0VVQ0FWbkVLVGVxdUVwYVBDVU9HQUEweXJOOERqQXJQN055N0dvK0JHNUtU?=
 =?utf-8?B?S21iOEpXMjJESWRxUjRVWmtQWThDd09adGR4bGdDRU1KMHM0WWc1WmlaVWRN?=
 =?utf-8?B?YWlhUUJGMHdzVllBdGFJQWpNL2QrL20rN2crNWJxelAvVEU4bzB5alFRN2Yr?=
 =?utf-8?B?UDlJdHIzb1NlMXhScTVZa0ZsMmsvc0ZmQ1psSkY0by9sRXFtV0hYYlNrakgz?=
 =?utf-8?B?czI3Qk9HN05QSitYbFNaZENURmRqdXVESmRSdGlFd05DM1FDSDN0MTk1KzUy?=
 =?utf-8?B?dFBYNnEwR3crRFU0eDJLRnVhOUdKRTNBMlNNdjd6R1Vqak8xRm9JeVU2Y3Nl?=
 =?utf-8?B?VC8rR0NkaGc1a0Q0Snp4OG5zbVludndUd2R5TXBHVFh1YnlZNXVSYUhTaE8y?=
 =?utf-8?B?bVRVRkhkcGV6Sk9iQ0FBNlA3d0VVS3Y5VWs4c1FUa21lUXc2YjhLQUR5NkRL?=
 =?utf-8?B?OW5Oa0l5Q21wNlRtNU5KTDUrZUxYcHA2RXEzQmZyZEVHVitSTDlWN1ptTytw?=
 =?utf-8?B?dEc0OERRVXhTbksvcTRiekU1UnZPa1FZemZyanNqZkJOMDhhcTJLSVJ2KzMy?=
 =?utf-8?B?SDUxTXFFa0g1WTYvTzFzdkxOL290VmIySmVieWlVSlFudStDTWxvVkd6QjI4?=
 =?utf-8?B?MVRSUG5qaDBkY2dBaks2SnZPRDZ1VWcwNC9ybjhheG03NXdGMGRaSzh5MTUy?=
 =?utf-8?Q?F8pyjyjk4jLuSa7WW6md8bC84YUJ6fabQ5X/XPOjTuQq0?=
X-MS-Exchange-AntiSpam-MessageData-1: PWTjacg0oxlpqg==
X-Exchange-RoutingPolicyChecked:
	mhzPIHYM66Sk8PiWaax5tMReBIaVXD8Ju238NnJJQIeFTsGooTrUlunzelKf5cMEtqAOwqSIOFo4JOittqAuTEgKe4cUjEf2Q4BfoYAJeXv7qlTd2oDbUuUOJeqLWPBsykNwAn6zIyaP66LawVi8vq3i2GoZ6lbOP89xeU4Ul+7N8lCpUAVNAjCbpvQfFkrcFDrgxQiq1UKfekl05wRPcXqzIcoHm5AbjCYgx7jvES/UMo2QwG/1KgvpAlhuz7TjsUU/5LTTZR0pHNJOJpaO0l9+7JJtS8U28JmPFWqI2b8huBqJb0uCnU30Fw0qVyasucqBQcS+z1o7ThgvqrWQDA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aqMLA3Do2TmBdt6NttEQ0rzcEktwY5SePsvHro1nz1DEw5T7/wv4Sg4TU2JBz3/E4r6b1baFVmbh7eqiK1WBtmFHkivvZKpuzcUdD8f14hq/eLC1N9n4AnwOfdTSy3/V3lr77ztAw+WP70eeF63yDUdx1bk/dwPoq8AuW4e9vIz00MfrMGbE34+M1Fvm3Ei7LoBRDlr/eyph8oSm9PTgBRYIYe3O2ujR6+aJm5kRQJb0QyYAufO8QJIvMGnjt9y6LSyMiOj+uDK53/n0sd3DMcenAXE8H2cQDtKNdluqayKQwyR9bYsHCtfIkfHfsT8LYEWn7+Xcj1EK0ZHSt2kBQK+P/iIoO8b1zftULDTYppasWUW1DyJpM6zd3WpHoSVS0vVTfhxDKsdVs2He7vAnhv191KuzC3nNxbNsLePj+ZqcJT+2AJ7IkY8FfxkYY3RwejNd70mPiC9uMSmnSN4ZiufTRCr9I8TmdARs/njrgSQRvB5mUTyOSDgXh4qrlRWCDhLtDhS4Ki06e3LYWWBn30lPzzjr7G2Dm4Fr5WvHI3BB5rhzNj0Rhnrs8tNIa0/HsON+HR4UENWqMUCKxX7BqjKpwf19+cOCadGPgAjLSbS1tHOtrJH5+iPClbxXxH6p
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed4a863-e755-4d54-a6f6-08df2a64cb85
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:34:11.0750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtsVjDHhUjuRuBRH0nIbGJHf7vr9eKXhqn5VM4a8pyDK5WaST92htFIfkTm0dsj2z9KxFNnOoYFTV+upAMAJjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8554

On Tue Oct 13, 2026 at 4:29 PM JST, Johannes Thumshirn wrote:
> Metadata living in a block group backed by conventional zones only can
> be overwritten in place and in arbitrary order. There is no write
> pointer to honour, so there is no need to serialize the extent buffer
> writeback against block_group::meta_write_pointer, to keep a zone
> active, or to write out a freed tree block as zeros just to advance the
> write pointer.
>
> Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
> for such block groups, which lets metadata writeback proceed out of
> order and with a queue depth larger than one.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/block-group.c |  6 +++---
>  fs/btrfs/extent_io.c   | 10 +++++-----
>  fs/btrfs/zoned.c       | 23 ++++++++++++++++++++++-
>  fs/btrfs/zoned.h       | 21 +++++++++++++++++++++
>  4 files changed, 51 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 8ff21dde9a46..bd17880039d3 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -64,11 +64,11 @@ int btrfs_should_fragment_free_space(const struct btr=
fs_block_group *block_group
> =20
>  static inline bool has_unwritten_metadata(struct btrfs_block_group *bloc=
k_group)
>  {
> -	/* The meta_write_pointer is available only on the zoned setup. */
> -	if (!btrfs_is_zoned(block_group->fs_info))
> +	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
>  		return false;
> =20
> -	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
> +	/* The meta_write_pointer is tracked for append only block groups only.=
 */
> +	if (!btrfs_zoned_bg_is_append_only(block_group))
>  		return false;
> =20
>  	return block_group->start + block_group->alloc_offset >
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 55e9144d4759..bd745b913d15 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2535,8 +2535,7 @@ static int write_meta_extent_buffer(struct btrfs_eb=
_write_context *ctx,
>  	if (!lock_extent_buffer_for_io(eb, wbc))
>  		return 0;
> =20
> -	/* Implies write in zoned mode. */
> -	if (ctx->zoned_bg) {
> +	if (ctx->zoned_bg && btrfs_zoned_bg_is_append_only(ctx->zoned_bg)) {
>  		/* Mark the last eb in the block group. */
>  		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
>  		ctx->zoned_bg->meta_write_pointer +=3D eb->len;
> @@ -4170,13 +4169,14 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_=
handle *trans,
>  	/*
>  	 * Instead of clearing the dirty flag off of the buffer, mark it as
>  	 * EXTENT_BUFFER_ZONED_ZEROOUT. This allows us to preserve
> -	 * write-ordering in zoned mode, without the need to later re-dirty
> -	 * the extent_buffer.
> +	 * write-ordering in append only block groups, without the need to
> +	 * later re-dirty the extent_buffer.
>  	 *
>  	 * The actual zeroout of the buffer will happen later in
>  	 * btree_csum_one_bio.
>  	 */
> -	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflag=
s)) {
> +	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) &&
> +	    btrfs_zoned_meta_is_append_only(fs_info, eb->start)) {
>  		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
>  		return;
>  	}

I'm a bit afraid of querying block group every time we clear an extent
buffer. I tried avoiding that in the write path using the ctx->zoned_bg.
Well, it is relatively small than the write path and I don't have exact
comparison. But, still, I want to think of some optimal method here.

> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 3af234dea6f5..fef7cf390425 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2301,6 +2301,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_=
info *fs_info,
>  		ctx->zoned_bg =3D block_group;
>  	}
> =20
> +	if (!btrfs_zoned_bg_is_append_only(block_group))
> +		return 0;
> +
>  	if (block_group->meta_write_pointer =3D=3D eb->start) {
>  		struct btrfs_block_group **tgt;
> =20
> @@ -2328,6 +2331,24 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs=
_info *fs_info,
>  	return -EBUSY;
>  }
> =20
> +bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 =
logical)
> +{
> +	struct btrfs_block_group *bg;
> +	bool ret;
> +
> +	if (!btrfs_is_zoned(fs_info))
> +		return false;
> +
> +	bg =3D btrfs_lookup_block_group(fs_info, logical);
> +	if (!bg)
> +		return false;
> +
> +	ret =3D btrfs_zoned_bg_is_append_only(bg);
> +	btrfs_put_block_group(bg);
> +
> +	return ret;
> +}
> +
>  int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical,=
 u64 length)
>  {
>  	if (!btrfs_dev_is_sequential(device, physical))
> @@ -2586,7 +2607,7 @@ static int do_zone_finish(struct btrfs_block_group =
*block_group, bool fully_writ
>  	}
> =20
>  	/* Check if we have unwritten allocated space */
> -	if (is_metadata &&
> +	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
>  	    block_group->start + block_group->alloc_offset > block_group->meta_=
write_pointer) {
>  		spin_unlock(&block_group->lock);
>  		return -EAGAIN;
> diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
> index 8e21a836f858..c5116db8cb0f 100644
> --- a/fs/btrfs/zoned.h
> +++ b/fs/btrfs/zoned.h
> @@ -77,6 +77,7 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
>  void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
>  int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
>  				   struct btrfs_eb_write_context *ctx);
> +bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 =
logical);
>  int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical,=
 u64 length);
>  int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logi=
cal,
>  				  u64 physical_start, u64 physical_pos);
> @@ -215,6 +216,12 @@ static inline int btrfs_check_meta_write_pointer(str=
uct btrfs_fs_info *fs_info,
>  	return 0;
>  }
> =20
> +static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info =
*fs_info,
> +						   u64 logical)
> +{
> +	return false;
> +}
> +
>  static inline int btrfs_zoned_issue_zeroout(struct btrfs_device *device,
>  					    u64 physical, u64 length)
>  {
> @@ -432,4 +439,18 @@ static inline bool btrfs_zoned_bg_is_full(const stru=
ct btrfs_block_group *bg)
>  	return (bg->alloc_offset =3D=3D bg->zone_capacity);
>  }
> =20
> +/*
> + * Data is always allocated append only, even on conventional zones. Met=
adata
> + * only has to be, if the block group has at least one sequential zone.
> + */
> +static inline bool btrfs_zoned_bg_is_append_only(const struct btrfs_bloc=
k_group *bg)
> +{
> +	if (!btrfs_is_zoned(bg->fs_info))
> +		return false;
> +	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
> +		return true;
> +
> +	return test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
> +}
> +
>  #endif

