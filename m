Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B5739936F;
	Mon, 27 Apr 2026 08:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777277706; cv=fail; b=C2dcLTc0CsT0z+nrHzCojho8QTAZ28HmNavNvEFhBuOeqTRFDuQgNFDZX/Y6+ehRvhN3SA/H/63Lh5q9jfOiQCnmHLAwkU7VRhg6DYRzWKuLvJ3oZldoC8ZGuVAJnRWlOYRtGMETdMqj3ZzzSyALV/cSqrGAnO8qW+OrvEbmruM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777277706; c=relaxed/simple;
	bh=Gl9t4VKhU5PZWV4YWluGIznz5FgFhW4ILI/9ffAX3Is=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CIxL38yO9poGAiLRJ/Y6fuxZdKu5NXCZuuEGTri2Cg9rwDBvzoQdaIgHLvd6Ft/llL76xoN0SgjFJTTbqomWKGuB+Vndd29weeGVUEpZxoyzZ9d1zj652/b8DfwMELwfQw05sWRs1LGq5fU5CmX2ifnMH6EA1qZoKnx3ZBVNYIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YXfoWg/R; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jovvOoVc; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YXfoWg/R";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jovvOoVc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777277704; x=1808813704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Gl9t4VKhU5PZWV4YWluGIznz5FgFhW4ILI/9ffAX3Is=;
  b=YXfoWg/RxQ8kksB/gRw6EpgIAXUUDU7JZEOqK3uQZGcKhkS0RmRXzuGi
   HaLOqBXyQTaYTKuMPTI9n+6fA88Md9fMt8QinqYVO3cpZ8Q/4k8Y7UVfX
   NqkGFkz4x5Q7BO1zsKxjNO6JgMshmijFN1DQrzK/9gObBabpvAQdNFBRi
   RbEGgwzXfY01XIQa0tUuMjmJ8QD2b4/r9ZOecCbzzGnKKkT2nvO1a1dj+
   OC1heO5RNcraFF8B5LqGC7GomVNCdRlcZTKojHKPUoxFg5FMSq+jmQ9Cc
   1RXM2iugRD/x64ZGWUct7gnlED4mat5sY+pq7BFRjy4hdD/jYFG8DFxGx
   A==;
X-CSE-ConnectionGUID: JrE+T9aKSfO4bcHagoRVAw==
X-CSE-MsgGUID: PQtWI3+HQYmhcig4LLWLRA==
X-IronPort-AV: E=Sophos;i="6.23,201,1770566400"; 
   d="scan'208";a="141563033"
Received: from mail-westusazon11010065.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Apr 2026 16:14:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h9nxOYNTgKu997mDAkQ1lERhR+ZxwFtPyqtWdrWyoFwjSQREXjtoKQkQvRRCZ5g98mY9+nG+Ptj0hjGdky9Am25Zix8rr+IoYSGAopyNEnozsgTxVn8sLYHekiYzvrB9us7wMP4CELo5mX2rawxiLOLWgcmlSXwbZEuMy7RLQUhNHOazu5lh1OGAZAq6WcZ6yKzCOC2ZIcWwEI8nWACfKGdzQR9Q69WG4Kck/7lJvp3VG89VxA8sQJVVZOQLOAl9GX84hPmNIvb1md5VaRBiUYNn4Nwox+Q+cvzKcDoqxrmd2rMR3mQMNe6Pzkps/twiuHnacyKM/ofMFC9/3QbjTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gl9t4VKhU5PZWV4YWluGIznz5FgFhW4ILI/9ffAX3Is=;
 b=T6ims2eu3+OOTSyzx1EEcb+exq1ISXsSzJafhYyrZbOUYQtf6h8ojb80c0cqkZfxCUzRB8eekm/oKQ7lQsn2+GwzF77TwJJkLzoOT/35WrgyOTNJCoUdyMGKIffNLArgeFcWeTAjFGkT3PbuxtLmmFR20yaYgk/21VT3HNIvzpkLULFYgcdpqIlChGiupP4r7I3cLlF9NK/3tCFU1rg7RpMbbU3B/B/j25JMH9kk5QR8+Br2slYiX5mLgilTJyZ1GNxCn2Eq4M73NJxUZnVTEMYfNEnvqov4fP6HiyKwHJisosozZlgR9OAEtOrW9TS/0Pm6L23+GpsCOeL9bzTM/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl9t4VKhU5PZWV4YWluGIznz5FgFhW4ILI/9ffAX3Is=;
 b=jovvOoVc9uNoLX2bIXa7oBwmyP7q3OdrH/5vPL9cElY0HPeS7SB+3Y44sTjemnUb/anRdzBuZBiypTEmDdHqcA3IjwAkJxtbHbp9i81zg4X9xVCdm/MphGgojeK+qkhV79ZV3pKjYdK5Uf63FrCuebSM15g+oEZWV/4ivn1xujU=
Received: from LVXPR04MB9982.namprd04.prod.outlook.com (2603:10b6:408:37e::17)
 by DM6PR04MB6795.namprd04.prod.outlook.com (2603:10b6:5:24f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 08:14:55 +0000
Received: from LVXPR04MB9982.namprd04.prod.outlook.com
 ([fe80::a7f:ee0e:59e0:428e]) by LVXPR04MB9982.namprd04.prod.outlook.com
 ([fe80::a7f:ee0e:59e0:428e%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 08:14:55 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Zorro Lang
	<zlang@redhat.com>
CC: Naohiro Aota <Naohiro.Aota@wdc.com>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Shinichiro
 Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2] generic/793: limit number of overwrites
Thread-Topic: [PATCH v2] generic/793: limit number of overwrites
Thread-Index: AQHc0+BN6cAdM2T8HkmdWMp29Q4gt7XylBuA
Date: Mon, 27 Apr 2026 08:14:55 +0000
Message-ID: <a0e01cc2-f692-4269-a9f5-f29159a86a0c@wdc.com>
References: <20260424114819.177805-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260424114819.177805-1-johannes.thumshirn@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LVXPR04MB9982:EE_|DM6PR04MB6795:EE_
x-ms-office365-filtering-correlation-id: 933a3f69-930b-42a8-b903-08dea43510f5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|19092799006|366016|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 kBdAjn3m9nQ7C048PpJj2X1UqZn8te5q6u0Mlgw68ucvbl54288PchrqfdirFWtYc4RHpDS0RBeGxGrctEYj3Al7Ez2eo8AMRupnuSrjsA4lSKmbQF7wFLR59WnA1iN4Wa1kzlySwAe0EHH05smTwsCpxi1T7Z5b52/ngrr+0/2LRlbUfCViOl/829We48cfht7rSmF+R/sYAmNEP7/QFIOg+Z5pQaubvjK96aISUOBvwyDIR40shiCR5UlecJHsQ7MA0MZKnd9F3tnpUjW7aG+yeFPojgwK05m6Old1YZzoE3yNP/go14tKtzvw1snPSfo2HvhgVXXVbZZKoPSJN7R/97zN5jVrf4JbCz69qo/FUPolsGOYBuHe4ed4vCTkZiua4cYsp2NSTswWw/+XfXwRD4mQyxy9lZ3A6Rs636xKUA+IxYkthrDxQqWdzVVIjv0qeXgm3Vqs9BcSeBYQgMyiuDuklsIVB+5rHDG+x2jZ0IxTdX6YOWvidR7roY4TGGY0mwIvbHOw+BDj9skxIK+JIKj6Q5ZOIRSB0qU1LYAGcpYGJiTp/GVMRNwgF6EI3rMbBfIwp11xSxMQLafyUi/Yp7hkXk0H0+UzosOtToLXRYt8bq+fJFQsZyzlsu44w3d3grMEIwmqNGpjbOiZd9iJJCZcHxELT0VvNK9PK0Io7AofvemLwUKfHrNwoTUDbvsqnEzLBUTgvbX1RHqQABMIh5cH8BEUK3uw2EbcbAywzuTeuk8nu82kimOs7oQapZH6EwyWFbgTN5nbjtM7PCFptLkgKdP9/JrbV0HvTmY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LVXPR04MB9982.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(19092799006)(366016)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NUw2bktIUXdLeTFlSnI3UjBHVGJxcHljUWNRaDAwNXduNDRGY0ltd0dRK0xt?=
 =?utf-8?B?YVdlYXNzSENGMmk4NERLUkdCQnBIbkswSmdtdDBBNzYyY2l5NHVuVm13L2U4?=
 =?utf-8?B?MC81Z0ZZaHBPbjRpU0JvbmdkY1dLbVQ1MWM2blpPMGxCWlZGU3o4aDR3VHpX?=
 =?utf-8?B?TVRUaERSQUszYXZDaTZOeG5LZHhubDAyL29EQ2NkMkw5dys5R0tuMmFQVUlj?=
 =?utf-8?B?dDF6ZHY0U3lOVVpDSmpKd1ZZRHd0M21iMUdDTUk4MkhSeFpBKzMraUNKSWVo?=
 =?utf-8?B?RzF3ZDZIbmwrdzYyUGtzWk5pcG5PRkZ5U25GdllqWEFrMkZiVHA2eWtteUNF?=
 =?utf-8?B?Tzluck93NmZIR3MyY3lXby9jUk43OU5VSFkzU3ROMERsZ0VXblZJVlZGeGNU?=
 =?utf-8?B?WG1ETUxEZCsyN3kzeVB4cUZKcyttNFRVQk5HZGhLL1hDeWJ4Sy9HZEU0dElD?=
 =?utf-8?B?QThkN3ltWHBZUk9qT0RwcVlEazFIUXRtZnJIaFlQMHJPNGJ4WEt1S1ZuZmU0?=
 =?utf-8?B?a3YvT3R1WXFPSzhIUnFJWTRCdU1XTXdXTkY4S1RmZC9JN1QrRDRKODlOYlBF?=
 =?utf-8?B?cFdvWWFyVFhobXhkRTAvOHhCQ25xdW51ZHZGWXpIbEV2NjJCWmgwMS8vQ056?=
 =?utf-8?B?VklSWnM1UGRWTEEraTc4a1J5bXd3eTFhQUZYWno0OXlLTmM0UGprV2FMSHJo?=
 =?utf-8?B?dUgrV0picXRtMk9jbm5ZRDNTa044RjlDbWFMNk9aM3VaZnFuRXgrQmtnTGpH?=
 =?utf-8?B?YThZY0NEREFLY3Zyd2pKaUlNU0U3STFjUmtKTFpJVU5EYllyenFMZDQyUlpI?=
 =?utf-8?B?dlMyaG1jc1pOWUFmZVM5YlhUSzdDT1FhbWFTeGFaNTNYRnFqQndCY2VabWhV?=
 =?utf-8?B?eHBEcXhpUWltdGwxdmFHVFRrcnpoM1AwL2RPNmhHVkJ6NytRTVBIclBnVFZj?=
 =?utf-8?B?eXZZTHBteEVIcVZ5aWdxMVJxeUhtNGlBS1FqdWxkZFlic0dqa1dESXhLQ0I5?=
 =?utf-8?B?d1QzNDJGeklxa3Ntbm0vd2VBYUxRNkVUNm1ocVg1Z05nRGVyTENic1NVWmY4?=
 =?utf-8?B?YndQdm81MzhMWVlIQnZ4eHJ6amZYa1hxQUhaYnBvQTBTQmFFNXo2bGNjbUxN?=
 =?utf-8?B?aWwxV2hHMTdUMzUvMjFhSjFNNW4rWWtXZmlPdVFrNnFNa29wTjFnYW9WaHhO?=
 =?utf-8?B?Um52cGw2WkMvTWtRZldaVUVVQUNUNG0wbXRqWG5FRzd2SE1lbnoyWHREL01i?=
 =?utf-8?B?R216NlRFL3ljR3hGM0l4eDVDb2Q2M3Z2ODhSU0tpSVlHeDlCKzRnSWlEWVl6?=
 =?utf-8?B?L1ZYdnc1UHcyajZxWHhoL2xMZWZuVkR6N3BNMFVOWmY3QTFXZnBSbk9aUUIy?=
 =?utf-8?B?YitrQUtOc1lqc09tUnNPYnQ5QzNFRmpoemZ5RlZmbFlaNHZkQlMzSkp5RzVT?=
 =?utf-8?B?U1FHNTMyYnFaNThhRmZUeFlKNHZhTWNUWlhoYXhkalhhVGNDSnZ5cUg4ZkRB?=
 =?utf-8?B?bFA1QkdsY2cvdFY4MVBuLzl4UzJBNFdrRTUrMHBBeno1aWNyNVlSV0RnaTZ4?=
 =?utf-8?B?emx3cGk2UFdrWTgzZ1JVNXZRWU5FYUhBemQ3K0lQSmYvSGRiR0dhNFI0dGMz?=
 =?utf-8?B?R3lHVVdlaWt2T2phbVlJdklHdnJCTHlPYzlyYkpSL3ZvaUZ3emt5QUsxSkgw?=
 =?utf-8?B?MmVoM1BMeTBWR05jOEhaY1JTZ0pqL3QxTUhPcFRNRTJWdENYSDlwN3NSQVVw?=
 =?utf-8?B?ZlZkdGphd0pneWh0ODMvcnJJRUIvbHEzTThDRURqaTBZUmhwQTAzbnduQWgv?=
 =?utf-8?B?R3B5aDY5Y2hqM2lJRncrVXJvMEJmTHViYk9hS25mNllpaDE2UFJkZ3RoWTRJ?=
 =?utf-8?B?QjdLUGg0Vk03d0w0UG5pNW5sT2NTME5wOE8zdEhCbnRqTEdqRm9IYUt3ZFU0?=
 =?utf-8?B?SHl0SVZSZU0yUmFRYzN0emJrenNYVnlITkNBcFhIZU83QWlsOHc2T3VORk9k?=
 =?utf-8?B?QTZDNW5EbThiRGo4Nk85NUw1SWorZVVROHVCb0RDMVVCTTQ4N3VoZzcwbWxt?=
 =?utf-8?B?VzRPL2xzaGxrV2VzTlJkMkcva3Y4VnRWY282UlZDNFNmV2RVWFVWYTBjcmlX?=
 =?utf-8?B?ajRxRXpEbDRWMnhKQkVla2JtMEo4VXUwSWRLdlNQeUZJYVI0VWJ6eUNjTDU0?=
 =?utf-8?B?QWRtK0xUb2x3L0dZbGFZOXJEK2Z5dmFJeE5WQ1psdUxlSDRGb0xXak82OWxR?=
 =?utf-8?B?TzNPNGh1YzQ0VTdWNnJpbGE0M0RJL1lRa2p1MWFmUDlvL1U4L1E3UmFnekR5?=
 =?utf-8?B?dXYrdlFOMVNxVGZybkcvdzFYV0RobnFkckl1SmZUQ2JLY1NjVGYzZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B94D3409CA6274D9E650D8DDEF92552@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	nCQYs/OhX/L3vW9vsYgdksTig1uJb1jr1m0OYu3hISZfZldyNncmBMvHk/WrhN5Lp0c6a8PAWNwQ0n3SME8EJauW4SuSKEhY/yuZ9U/gqJCEXRt1NCnmN3b22mn4eCKYfXOupH8EVCbdiIIO1de6cIBpmn4kI2Cusf/3QPQgoaBFZMAUIPIQqe5Eat20IJi9gJPXHLcdqppOJyLUVxImyyJxL8Hn2U5c5iYadOYM2CBoaSOGqJ7pBASAV1DUXacM/xpYer2PSXr2Srm0XAXD80alzLOPs9ams5sF7n9+r929zE90vaVfxYqJa0p43HYQKRqwQBlaxLgB5VGv3CFtLg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QJ7HTA6nzYs4OQsmzMIZ297yMBYHpC02QgVssQcDI+Y3+hteZn/JGUnzJfqinM+KI8xebjuoLkjdh0LuHYCzZLpqNTjAuJe3ENYoYH/JhXzvmGYSd795a9kbsg/ra7y0WuUyOU9FLtjmSwFhUpavwmRUoVzKFDiglFjT4eHVjWsfJyQkfoLIQ9Epj5jxjS+aFJlv642L/4fbmNfOlKZ1ZdzZps3Z7SyYc6+GO4T3IzvPX2meHYVFGih6N/LFiZaJuGoznNrdXFVsuS/jyarnfGHTgBpOD103cMyCL4UpsiUnCIoJ2kvi4N1MWBOpiv1/n0mib0fTQziJTMCdcc3S/t+ECOxREOVE8CnaQOknZHivAjNa0+sTNt1OOBuvZUvqoR1lNBo+igIGMwY9YMdSwmjPCgFjbBsBhHQmdo/zue2OMn/CZtPTfWMd96KhiVXjMTvsZQk0AWyoAt2JUHFxJoPqbfXT7fmZZxqaiqPaGDMNEPMQRbt7B5X6lAcwhxmiacdWkvz+jXDSYj4RgYXaGb9F4rkSL+92nyvyDY2QhMZnNI7O4qHMsD9Vew+Q8V76QLX/230ho7Cb9S5m8HyVC2P70AWw1//5G1R29RNFgRNRw9xy6G3K/ujk3Qn+yyQ+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LVXPR04MB9982.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933a3f69-930b-42a8-b903-08dea43510f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2026 08:14:55.7646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UC6aLby8rUiI3pSf2miX0DxfZM65m3+VzLPRDG2ObI0+UjNzWyAZsGC2kBbfSRB+iU4oFXDT/HYmepLfJKWv4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6795

T24gMjQvMDQvMjAyNiAxMzo0OCwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOg0KPiBUZXN0Y2Fz
ZSBnZW5lcmljLzc5MyBvdmVyd3JpdGVzIGEgMUdCIGZpbGUgIm51bWJlciBvZiBzZXF1ZW50aWFs
IHpvbmVzIg0KPiB0aW1lcyBpbiBvcmRlciB0byB0cmlnZ2VyIGEgYnVnIGluIHpvbmVkIEJUUkZT
JyBnYXJiYWdlIGNvbGxlY3Rpb24uIEJ1dCBvbg0KPiBzY3JhdGNoIGRldmljZXMgd2l0aCBhIGh1
Z2UgbnVtYmVyIG9mIHNlcXVlbnRpYWwgem9uZXMgKGxpa2UgU01SIGRyaXZlcykNCj4gdGhpcyBj
YW4gY2F1c2UgdmVyeSBsb25nIHJ1bnRpbWVzLg0KPiANCj4gQXMgdGhlIHRlc3RjYXNlIGFsc28g
bGltaXRzIHRoZSBmaWxlc3lzdGVtIHNpemUgdG8gMTZHQiwgY29uc3RyYWludCB0aGUNCj4gbnVt
YmVyIG9mIG92ZXJ3cml0ZSBsb29wcyB0byB0aGUgbnVtYmVyIG9mIHNlcXVlbnRpYWwgem9uZXMg
aW4gdGhlDQo+IGZpbGVzeXN0ZW0uIFRoaXMgc3RpbGwgZ3VhcmFudGVlcyB0aGF0IHRoZSBmaWxl
IHdpbGwgYmUgb3ZlcndyaXR0ZW4gb2Z0ZW4NCj4gZW5vdWdoIHRvIHRyaWdnZXIgdGhlIGJ1ZyB3
aGlsZSBub3QgZXhwbG9kaW5nIHRoZSBvdmVyYWxsIHRlc3QgcnVudGltZS4NCj4gDQo+IFJlcG9y
dGVkLWJ5OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGly
bkB3ZGMuY29tPg0KPiAtLS0NCj4gIHRlc3RzL2dlbmVyaWMvNzkzIHwgMTAgKysrKysrLS0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS90ZXN0cy9nZW5lcmljLzc5MyBiL3Rlc3RzL2dlbmVyaWMvNzkzDQo+IGlu
ZGV4IGE1OWU4NDY5NDMwOS4uZmNmYmM0OTgzZDdjIDEwMDc1NQ0KPiAtLS0gYS90ZXN0cy9nZW5l
cmljLzc5Mw0KPiArKysgYi90ZXN0cy9nZW5lcmljLzc5Mw0KPiBAQCAtMTEsNiArMTEsNyBAQA0K
PiAgX2JlZ2luX2ZzdGVzdCBhdXRvIHF1aWNrIHpvbmUNCj4gIA0KPiAgLiAuL2NvbW1vbi9maWx0
ZXINCj4gKy4gLi9jb21tb24vem9uZWQNCj4gIA0KPiAgX3JlcXVpcmVfc2NyYXRjaF9zaXplICQo
KDE2ICogMTAyNCAqIDEwMjQpKQ0KPiAgDQo+IEBAIC0yMSw3ICsyMiw2IEBAIGVsc2UNCj4gIGZp
DQo+ICANCj4gIF9yZXF1aXJlX3pvbmVkX2RldmljZSAiJHpvbmVkX2RldiINCj4gLV9yZXF1aXJl
X2NvbW1hbmQgIiRCTEtaT05FX1BST0ciIGJsa3pvbmUNCg0KX3pvbmVfY2FwYWNpdHkgdXNlcyBC
TEtaT05FX1BST0csIHNvIHRoaXMgbmVlZHMgdG8gc3RheS4NCldpdGggdGhhdCBmaXhlZCwgdGhp
cyBsb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVy
Z0B3ZGMuY29tPg0KDQo+ICANCj4gICMgVGhpcyB0ZXN0IHJlcXVpcmVzIHNwZWNpZmljIGRhdGEg
c3BhY2UgdXNhZ2UsIHNraXAgaWYgd2UgaGF2ZSBjb21wcmVzc2lvbg0KPiAgIyBlbmFibGVkLg0K
PiBAQCAtMzQsMTIgKzM0LDE0IEBAIF9maXhlZF9ieV9mc19jb21taXQgYnRyZnMgMjU4ZTQ2YTYz
ODVjIFwNCj4gIF9maXhlZF9ieV9mc19jb21taXQgYnRyZnMgZTJhN2ZkMjIzNzhmIFwNCj4gIAki
YnRyZnM6IHpvbmVkOiBhZGQgem9uZSByZWNsYWltIGZsdXNoIHN0YXRlIGZvciBEQVRBIHNwYWNl
X2luZm8iDQo+ICANCj4gLV9zY3JhdGNoX21rZnNfc2l6ZWQgJCgoMTYgKiAxMDI0ICogMTAyNCAq
IDEwMjQpKSAmPj4kc2VxcmVzLmZ1bGwNCj4gK2Zzc2l6ZT0kKCgxNiAqIDEwMjQgKiAxMDI0ICog
MTAyNCkpDQo+ICtfc2NyYXRjaF9ta2ZzX3NpemVkICR7ZnNzaXplfSAmPj4kc2VxcmVzLmZ1bGwN
Cj4gIF9zY3JhdGNoX21vdW50DQo+ICANCj4gLSMgT3ZlcndyaXRlIHRoZSBkYXRhICJudW1iZXIg
b2Ygc2VxIHpvbmVzIiB0aW1lcywgdGhpcyBpcyBhcmJpdHJhcmlseSBjaG9zZW4NCj4gKyMgT3Zl
cndyaXRlIHRoZSBkYXRhICJudW1iZXIgb2Ygem9uZXMgaW4gZnMiIHRpbWVzLCB0aGlzIGlzIGFy
Yml0cmFyaWx5IGNob3Nlbg0KPiAgIyBidXQgdHJpZ2dlcnMgdGhlIG9yaWdpbmFsIGJ1ZyByZWxp
YWJseQ0KPiAtbG9vcHM9JCgkQkxLWk9ORV9QUk9HIHJlcG9ydCAkem9uZWRfZGV2IHwgZ3JlcCAt
YyAiU0VRX1dSSVRFX1JFUVVJUkVEIikNCj4gK3pzaXplPSQoX3pvbmVfY2FwYWNpdHkgMCAkem9u
ZWRfZGV2KQ0KPiArbG9vcHM9JCgoIGZzc2l6ZS96c2l6ZSkpDQo+ICANCj4gIGZvciAoKCBpID0g
MDsgaSA8ICRsb29wczsgaSsrICkpOyBkbw0KPiAgCWRkIGlmPS9kZXYvemVybyBvZj0kU0NSQVRD
SF9NTlQvdGVzdCBicz0xTSBjb3VudD0xMDI0IHN0YXR1cz1ub25lDQoNCg==
