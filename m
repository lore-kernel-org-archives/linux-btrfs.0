Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333E531A56C
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 02:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031442; cv=fail; b=Yi4I+IE5HaEsGJnTMrWTEWnEi3LZ/3r1BHFdDCWTFU2Ae2AevFpYYePSSuSDyv1C62QYDrMdvDMcmhlGAkbVmhXvVcLyFfQiZjN3FV411LV5gIn/RQPZX3u3yA0Wp6p2XgC/iYlaPjSCszD0pjHRvh7T9rRJOnKY7DOzh32zk7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031442; c=relaxed/simple;
	bh=CTNvCksf2b2WYF2tLJevkj3H3/N+pO3hp/iHRqXi6y4=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=S4SzoTWGE5BDV4I7fCcW0uiflch04911onZSYPQd+vZ+H4oGMfooyvwU/mAsu3kKytZJh/HJ596UY5MfDDs1JGa0AJTwiZ6N7A/6o0YEU1I3T/cR9IFfWIIzOB6Tp2oC+cNHtD5RJKT/086QvHsOGtJLQZVs17nlHBsoBliHzxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QnsFNT9G; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=kNjbAq6M; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QnsFNT9G";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kNjbAq6M"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792031447; x=1823567447;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=CTNvCksf2b2WYF2tLJevkj3H3/N+pO3hp/iHRqXi6y4=;
  b=QnsFNT9G407b7oBsUv0Y+fVMOTXvFFyUShv8J/Hq55zcVpIGA66/yM4V
   zxVAFIJ7l8Ks5LBDUdv0haWgxtOyZAW7qzn2X6jhvKCOsM5RKI5nM8HBr
   IReoX2kkJQN7m/7YF0GBmuS0Nfg+OaAeb7ftgwQNhLQ15kuUxY2hT+/02
   mz/UB7tODlUYF4YT9lhulSOcg1fEgynwPy1t8W6qhWHKYpb9PdRGXOElm
   ndcIY3UP0DjAhTi9gYLqaVuK8LUO400sF3c/GJwjE5BFcdQGiYdodMx4y
   La+y8/unGKMAssFt/Mzn9oMytTBOmeTulXXnPGmkWXl/IA6anvBH5Q+gQ
   g==;
X-CSE-ConnectionGUID: Y5oUMNCDRwCdSsNiLfqR0Q==
X-CSE-MsgGUID: L5Jxj80rSTuxmaPlLNmYzg==
X-IronPort-AV: E=Sophos;i="6.27,159,1786982400"; 
   d="scan'208";a="158138870"
Received: from mail-westcentralusazon11013045.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Oct 2026 10:30:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BnKcTELo2ZPofVLOfyrmtm7RYwj1kZPNOoKUHMmH0J9oIN5ysXFDS0rIdFjAhSVkyIQfStFBPuy9DbEw8OVmg9Q158AMtNwbKPNCj73J09q+viSDWLMWyg3lusAQlgeMJtWKM6nsvCGxD5xsTaHjy53tQjp/IQRKebi9uA4LDesGuaQPL4mhTgL9Zeu1FPvM9tlAuZl2HfCM63I9juzkShxpgw02kePFH7hyUvnOt8pfEAAkCr2I9RKCVl7bwyMzQa+PmELzF6Q511y+1oOGoQZ0ga8M5EgjIcOEPfF6I6SJR2hDjDMvOA09Jj5P6FWmq8wkfm2cKshFyC+7QpUycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPsbK91d40rsubjGVykEDC2FKakIiqq7cYyiOxYsL3I=;
 b=SXgeRpIGNnTfUdm254GUi8btQHlpPCOKjPVkBvy6P27ZhhYw9wZScDtuTiciPCupCOshdMWGWB7DYDOt7tfWPQDfZI3Y7NGs0+aHjGxXHy0y1AdyOxmyyifxel9Jba49cM7npWWcEGJBt7C17wjpmEBB5VtTXWr9Lux7/U43LRcMaXO/yb5FCDdNNNBUyErodOhs9rH5YtTfx7+K5/WiuBkCmQsZn+v0q7lVXuLF1DdKg3fq1z1Tf/kqXreeCORLcUjfboqRMNFUwT6YofPbY8pvmW6g0lFW3BaMk+W/otPpNTkjCEX8aHbazbxXJ5e8lXY4kREN9Lk+daGN+w9zQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPsbK91d40rsubjGVykEDC2FKakIiqq7cYyiOxYsL3I=;
 b=kNjbAq6MKL+m11u4KWy15+jPAuce+XV6yyBxzw9XPEIy16aDJXmzhABcGndKJ3Uuu7R1x+dF2ioN27pxAl+tNsW7Y6oHGe91Xm2Q4TjFKz5R2YXo95QfPyE4WjJwqRNX7Hk8a/EpwLBq9jNuvn6qqX4Lb/vzLRY+TiDu4yXzzkY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by PH7PR04MB8554.namprd04.prod.outlook.com (2603:10b6:510:2bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 02:30:37 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 02:30:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Oct 2026 11:30:31 +0900
Message-Id: <DM524IH18UA8.3T3XF1R1J4XIC@wdc.com>
Subject: Re: [PATCH v2 02/12] btrfs: zoned: don't activate conventional
 zones of mixed block groups
Cc: "Damien Le Moal" <dlemoal@kernel.org>, "Naohiro Aota"
 <naohiro.aota@wdc.com>, "Qu Wenruo" <wqu@suse.com>, "David Sterba"
 <dsterba@suse.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Dongjiang Zhu" <zhudongjiang@fygo.io>, "Johannes Thumshirn"
 <johannes.thumshirn@wdc.com>, <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
 <20261013072941.424029-3-johannes.thumshirn@wdc.com>
 <614d2012-675c-4463-9131-25524c56eed0@fygo.io>
In-Reply-To: <614d2012-675c-4463-9131-25524c56eed0@fygo.io>
X-ClientProxiedBy: OS0P286CA0028.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:9d::15) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|PH7PR04MB8554:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a2986e-6e93-4752-5944-08df2a644b95
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|10070799003|376014|366016|1800799024|19092799006|6133799003|10067099003|22082099003|18002099003|11063799006|4143699003|260925021311599003|260925022911599003|261009223027099003|260925021911599003|56012099006;
X-Microsoft-Antispam-Message-Info:
 RMOpCCNmlYDg+O+mn3+x4g9vQsOhSLlf0jVzhr5BiXuUZsXjPYSvtLLJqocQMB6qSWrsxxeCOgukFqMAI7ygV+tjzGQ4razZv5es6pApeMnoVjusZFu9fjjcVRtPmi7Pr4hhJOjIgmA4NJXm8/LbhTWpobALdTDhyqkV3AtUxgahSri63IVO/a+tRXcpr1xzQbzYeU5W6QMpI2n9qrjgGMhrHckZZnAdL0RnWFWbzoOEavKoU3XYvPmeRTvE297+1/umP3KMwmknim1sbrij0wui3q5wtzNBAr5NOAIzpr4TIDa6r3EgfwqubkAXJZRLeBlI2O3fkGVtq6O0hWyVyuAC6jrt+xYxA2+o5y98nUBH8mgJQJKu7G8SzipTS1mzJ1toudvMgon4xRxwy7eUnJ8jDfrHRzn9ytQRSq6D6n8u60sfABhSkaQeBw+Ww7Ky7CL8dcux7Idq0eTjvxiiySgS1/A/nqzazYvY36FDmGepfKaWRdVFkce+qZkb9LPV9a/3A2G4XT9ltEriFcZLtAmrDkh0oP3CgmoXEUKlBesIHYSQZNhJ9EGYYiUDehy4qARNc38ZEf4HMYr3vtim1EzwIZnLHq7tRHJdkWzaB/x62bvZSxqsJ7OSYPVqHhdj
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(376014)(366016)(1800799024)(19092799006)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(260925021311599003)(260925022911599003)(261009223027099003)(260925021911599003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?OFd2QXd0emRITTN1SDFMaVFvdCsvRXdBTGVRZjlhTDdwTEJRM05hU0hubjhF?=
 =?utf-8?B?V1U5aUJjZGc3R2JscTFkM3hQYjYveVhSZ3lmazJPVHdvdlV2K3lwZHAwU2VG?=
 =?utf-8?B?S2NQbHhBb0dUZXE2U3VmNkxsaldzS2NtRlphbU10WWdPSk9keUQ4VkJnWFVl?=
 =?utf-8?B?ZFRSWHJEYTJGOWwzVEMrNC9mYTFLVWI3V21WWjVuV0FremZRWXdYTU10ZCs3?=
 =?utf-8?B?aExobCtrRkxGdEQvRXg3eVBVNE5YUnQyYnhNbVBHVEo5cDZDcmYzNThrK1hk?=
 =?utf-8?B?TCtnb3BibFZEd2dDcDBYKzIwdVJ1QkM1dlRXRktBRnJRT1djdFVxQkpXMnJM?=
 =?utf-8?B?SXQxRnJwenZrc1ZUMjFqdTBBT1JlLzgwcWxnanlRNkliajVoaGVqMzRNOWZD?=
 =?utf-8?B?aWpXN3Y5QWw0QzRMblhJUXFmWnZBblF0ai8wNlpPM2Vka2liZVhzWjZwM3hM?=
 =?utf-8?B?K0t3a3U0Rk5jenlYUGNaRG9vbFJldGhTUksvKzdWWndBUFpkVUl6eGlhdmpx?=
 =?utf-8?B?UjRNejVsU0pScmNjNzhhUVpoMjUzbXRERU9Yd2ZKK2tuTHlhaEhwSDVFZ0lm?=
 =?utf-8?B?aTRQdnpPZlJyYjZMM2tSelRSNkxBZjlnZUNLbEZxdmpRRzJTTDRNWjJ4a0hD?=
 =?utf-8?B?QU9MUkgyVTNMd3l1YnAxZDRxNDZVQ2hYZTdQa09vQ0U5UzB0MUI4dkNnaGRJ?=
 =?utf-8?B?S3NuMmNVaWVCbkJrbWQ1Nk0xSktyd3V5KzdUbEFFK2c2M3VYazl3TnBrbFY0?=
 =?utf-8?B?anU4bE5vdGIwUFg2bHlFRjBPQzR5R0tsNzdISWM4U1d1amQ5L2VSRlBpS1dh?=
 =?utf-8?B?ZVNnNi9lNDl1Nm94bUpET1R3RCtNUXE0Smh4bjgxNGNpM3RrWEhnWC9ZMk5t?=
 =?utf-8?B?RFFJOTYxWXBZTVFTVVhGaHg1dmZoMjlsR1FLUi9mMlhQSmJTQmg0SUMrMlU5?=
 =?utf-8?B?ZXB4NUVzZDNsRlg4c3BQMnk3TXhmWHNOVnZjWE9aajYrMGQyVmRyRnl6cXZX?=
 =?utf-8?B?em9ZS1ZsUXNrcDR0TXhibXM3cDZPSjBqdjNMQWsrTHkvUm5mUjVndm9qa2pM?=
 =?utf-8?B?Nnhyd1hmbmxtVTVNK3c2bGVUUzZzVEl2azB1VmIxck5tRWcwOFA0OWJqQkli?=
 =?utf-8?B?Q0s2YXZ6Ry90UTNsazEvclQweW9zK0krcGpnNHE1MzRJUjRISkhSMUl3allI?=
 =?utf-8?B?RlljR0RrTzBIdms2a0pWUVQ3aG5Lc2NQU0dKeTVYd01leUl0Y3haZlZOWmor?=
 =?utf-8?B?Zk1NYVBkYSs4ZE9NSDBWajY3ZW1HK240ZFpOK281Q0p0WmdDaVFpVGR4NjZU?=
 =?utf-8?B?aE5CVkxZY0ZmaWhDR2tBUUNJQnFkYlQ5MVhuQTk4VkF6Z1QzOWgwMFZ6NHhO?=
 =?utf-8?B?MDFxVnljUUZtOExqb2tLaU14MkdORkZ0d01wVjZwV2dnb1JvVHh6blVUM29w?=
 =?utf-8?B?Y3Q2NGJOU1JjYVV1cTNENlVLMS9VZ29GSlF3bm1HdGUwOXc1K2tFU2oyUXBz?=
 =?utf-8?B?MzVUd2JBWWpaZnAxOC9PUTlXUUl5S0pRN1F2MjIrc1ZXL2hNcEJLRHFSd3ZM?=
 =?utf-8?B?TmdDOW1qYjNuYkFMMUlCS21iUGhQYWtiQ3VkaXZwS0dPMHZJRlQ2Q0hlNlVG?=
 =?utf-8?B?dXYydE96S2VCdDdXUXJsKzJ3OGJ4cm1XbVhBeXYrU2h6OXpMZjdMSXl1TkZ3?=
 =?utf-8?B?ZGZBTE5nTzQyZjFmZXFUVlF5bG9jR0lBeUF4RWxudlVEcUV0bWJKNlJ5d3Bj?=
 =?utf-8?B?b0VGNUlub2x1Q0VPL2RrZyt5OEc4Vi9OS3FKOUNGQjdsL3B6Um0wVVV0S1dI?=
 =?utf-8?B?NlR6VmJuQzRaRFJpcTUzSWozRkNZblJvRm1IMUN0MmlFUFpQMEMrTEpMeUd3?=
 =?utf-8?B?akZtcm5QemkwSkV2OUlHT1RaTmdKejBZQ0cxNHV3TFhFaDdUenlTRXNoYWhU?=
 =?utf-8?B?b0RTRjlmZVE2bi9WSlBSUVJ0N0ovVXN2ZTlPNkF4eDRmM3VIcXpNWWFnaXdH?=
 =?utf-8?B?UjVvYnl0OFBwNDcwZFJjejVZUjJMRjFER3pRNWFXSk92MC9aYUpJcDVpYmpl?=
 =?utf-8?B?aUQrWENPVFk0MGdaSXNYTmVGN3VDZ1VUdWo2SWtLeFdSSTdITXpKWDAyc1h4?=
 =?utf-8?B?Yi9kd0Fza2o0MGhPQ2YzSjJPbmNONkt3Wis4T3RDVzdMT3JYbzFON1dMUThm?=
 =?utf-8?B?R2ZaVGRqOThlc2dxTHg5a0l3LzR0cGhQMm1ncURjSlMwQ0ZqdWRicXRsOHdN?=
 =?utf-8?B?L2JLL3g3aGY1b2dJanVKTW1EbTlLVmJoWE5jSUdFbFdscFB3YnprU2tjTS83?=
 =?utf-8?B?U0RqbTRNdjRzeFg2cGJDaGY0dzlqRVZCdythcEVpdG9HQ3ZRa0s2bXVjNERK?=
 =?utf-8?Q?5SzQZOdwKnUpQc6hHoG0wX9RisJk6If3EyuaNlgT0XeH1?=
X-MS-Exchange-AntiSpam-MessageData-1: EnqicnT+Xp0xeQ==
X-Exchange-RoutingPolicyChecked:
	sSEYudB/BQqHVOfLWvtLFfRKukgAjATebTvRgkLhzaYz8pd1zEP7niIQXcRoh92m6iLV2zEVBcwrzfwmhwIXPjeZYDVTnf4ffk0mFBLnB733Cb/e6b+dBp78hneZZcV+WM1DYyh2zgL2HAx46GTN78r3RTBPsuh/7wh6+YpFN1uoa2IRtjLHeBo3NFKBpUZnJ72SUdn63mH3BBiOFynLWUJ2gmklA0qIh3/xGf9RvaEbJ/U1Zk6G6m/9PYoQFe4UWSzYU20kTtAFdj+WliLdUVVTOhhcMwwZs0YnVWyttD72XWQo9VewPcNmqiwlbypjv5Orz1FF7vsV8kMeqBzu7w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nhhEDUHC2Xba1OpqelPDZF9m3wi1H+MusZw5S0B/MiYaj6tTkNrNz/GvxYPDJV8K8/ZP9/24U18ooyh9OIKme4p4Y8adGjNhvOYG4h3Nyp6g1maf4N9wzTbqkNcvRD+h+W+VNznYVWqXppZPNf7CQ0bxPqr99sIlZ279ZGhsTMuKgvmgvH5G6oT3BzSudj0oJ6PopMR0D63i8i5jL1ohTMF9U3J5Qwwz8Tt0PCHxRwNuBTZ8WVQWGa17lSZ8KW48XSWq+265KzRzfX6G+S4b9a/DphoJVwqd0nkkQb7AJBUVtH7c1leOjbU9ShXwNNphM5HHOxjE3AsassHw98Ge16owQbhvpzBqmJFRyjw+qhcEvcr3yzmp4SZOaVi+5MQxZKuhu02yi3SIxMJl5RBrAjge1WDLPuBQTWqi1hEw1svECih9cJdw8G56AiJx2TluQtYOEu99trNPNQJtwffBbYUF69jXw7mdtbhcSMCh3XK/OfhfXSrnD06PiQYehfpyadd0SpFbSt4R1/oG5B8uJP29mV927REG7y68ESsAmgBlAr4rmsUS+AdW5HgdwO/2ec/YsqZhQ/TfAQ9jy5zTchOs2ilOfl62jOPgZx+gaicWtBrIMEp2+ElA2YXnBuqH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a2986e-6e93-4752-5944-08df2a644b95
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:30:36.4208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkqTyw7WhTc9tM9zVAC9pSK4+ZIh9/li4clGqC6Fa3PFkHeVDGJTJiXoKEgibmf7B5HhAl2vGfXeQzPVucYUEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8554

On Wed Oct 14, 2026 at 12:45 PM JST, Dongjiang Zhu wrote:
> =E5=9C=A8 2026/10/13 15:29, Johannes Thumshirn =E5=86=99=E9=81=93:
>> A block group can be backed by both conventional and sequential zones,
>> e.g. a DUP chunk straddling the conventional/sequential boundary of a
>> device or a RAID1 chunk with one stripe on a conventional zone of one
>> device and the other one on a sequential zone of another device.
>>=20
>> On a device with an active zone limit, btrfs_load_zone_info() never
>> marks a conventional zone as active, as there is no zone condition to
>> derive it from. If the sequential zone of such a block group is active,
>> the DUP and RAID1 loaders see an activeness mismatch between the stripes
>> and call btrfs_zone_activate(). That takes an active zone from the
>> device's budget for the conventional zone as well, although conventional
>> zones never consume an active zone resource. The same also happens at
>> runtime activation of a zone, not only in the mount path.
>>=20
>> Let the conventional zones of a mixed block group inherit the activeness
>> of the first present sequential zone.
>>=20
>> Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups"=
)
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>  fs/btrfs/zoned.c | 50 ++++++++++++++++++++++++++++++++++++------------
>>  1 file changed, 38 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index 51699136405d..3af234dea6f5 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -1959,6 +1959,23 @@ int btrfs_load_block_group_zone_info(struct btrfs=
_block_group *cache, bool new)
>>  	if (num_sequential > 0)
>>  		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
>> =20
>> +	if (num_conventional > 0 && num_sequential > 0) {
>> +		int ref;
>> +
>> +		for (ref =3D 0; ref < map->num_stripes; ref++) {
>> +			if (zone_info[ref].alloc_offset !=3D WP_CONVENTIONAL &&
>> +			    zone_info[ref].alloc_offset !=3D WP_MISSING_DEV)
>> +				break;
>> +		}
>> +
>> +		if (ref < map->num_stripes) {
>> +			for (i =3D 0; i < map->num_stripes; i++) {
>> +				if (zone_info[i].alloc_offset =3D=3D WP_CONVENTIONAL)
>> +					assign_bit(i, active, test_bit(ref, active));
>> +			}
>> +		}
>> +	}
>> +
>>  	if (num_conventional > 0) {
>>  		ret =3D calculate_alloc_pointer(cache, &last_alloc, new);
>>  		if (ret) {
>> @@ -2450,6 +2467,9 @@ bool btrfs_zone_activate(struct btrfs_block_group =
*block_group)
>>  		if (!device->bdev)
>>  			continue;
>> =20
>> +		if (!btrfs_dev_is_sequential(device, physical))
>> +			continue;
>> +
>>  		if (zinfo->max_active_zones =3D=3D 0)
>>  			continue;
>> =20
>> @@ -2516,6 +2536,7 @@ static int call_zone_finish(struct btrfs_block_gro=
up *block_group,
>>  	struct btrfs_device *device =3D stripe->dev;
>>  	const u64 physical =3D stripe->physical;
>>  	struct btrfs_zoned_device_info *zinfo =3D device->zone_info;
>> +	unsigned int nofs_flags;
>>  	int ret;
>> =20
>>  	if (!device->bdev)
>> @@ -2524,18 +2545,17 @@ static int call_zone_finish(struct btrfs_block_g=
roup *block_group,
>>  	if (zinfo->max_active_zones =3D=3D 0)
>>  		return 0;
>> =20
>> -	if (btrfs_dev_is_sequential(device, physical)) {
>> -		unsigned int nofs_flags;
>> +	if (!btrfs_dev_is_sequential(device, physical))
>> +		return 0;
>> =20
>> -		nofs_flags =3D memalloc_nofs_save();
>> -		ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
>> -				       physical >> SECTOR_SHIFT,
>> -				       zinfo->zone_size >> SECTOR_SHIFT);
>> -		memalloc_nofs_restore(nofs_flags);
>> +	nofs_flags =3D memalloc_nofs_save();
>> +	ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
>> +			       physical >> SECTOR_SHIFT,
>> +			       zinfo->zone_size >> SECTOR_SHIFT);
>> +	memalloc_nofs_restore(nofs_flags);
>> =20
>> -		if (ret)
>> -			return ret;
>> -	}
>> +	if (ret)
>> +		return ret;
>> =20
>>  	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
>>  		struct btrfs_fs_info *fs_info =3D block_group->fs_info;
>> @@ -3098,8 +3118,14 @@ void btrfs_check_active_zone_reservation(struct b=
trfs_fs_info *fs_info)
>>  		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
>>  			continue;
>> =20
>> -		for (int i =3D 0; i < map->num_stripes; i++)
>> -			map->stripes[i].dev->zone_info->reserved_active_zones--;
>> +		for (int i =3D 0; i < map->num_stripes; i++) {
>> +			struct btrfs_device *dev =3D map->stripes[i].dev;
>> +			struct btrfs_zoned_device_info *zone_info =3D dev->zone_info;
>> +			u64 physical =3D map->stripes[i].physical;
>> +
>> +			if (btrfs_dev_is_sequential(dev, physical))
>> +				zone_info->reserved_active_zones--;
>> +		}
>>  	}
>>  	spin_unlock(&fs_info->zone_active_bgs_lock);
>>  }
>
> Hi Johannes,
>
> For reference, here is patch 1 of my v2:
> https://lore.kernel.org/linux-btrfs/c51aaf7f4621dedc36c275bfa9ba1ec884de0=
9c4.1787717573.git.zhudongjiang@fygo.io/
>
> Initially, I thought your approach addressed Naohiro's allocation
> concern nicely: keeping conventional DATA block groups on the active
> list preserves the preference for allocating from active block groups.
>
> However, there seems to be one remaining issue. A fully conventional
> DATA block group does not consume active-zone tokens, but remains on
> zone_active_bgs. btrfs_zone_finish_one_bg() can therefore select it
> and return 1 without freeing any active-zone token.

This sounds reasonable. The patch 04 can also have skipping non-append
only block group in btrfs_zone_finish_one_bg().

> can_allocate_chunk_zoned() treats that return value as permission to
> allocate another chunk. The new chunk can then fail activation, and
> the extent allocation can ultimately return ENOSPC.
