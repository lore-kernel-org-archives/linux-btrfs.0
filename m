Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691A848B365
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114053; cv=fail; b=I22dKGoKY3ZaPeIvAeR2D6YjKUhtyMcKzygiwV24k423cQxZbFiA7vx8RUxtRvNfgnCi50v8shRvVllLuVr9K8L8H2gkLCt7z3tDKsRLXsAm+jVsycYcJ0vkVlWCK7wgcDqdZyIqNWa5n8b+bJZEY1jSpNN9FSbz3wZh9FgpvOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114053; c=relaxed/simple;
	bh=ztw8ip/MYyXS1x9kFw+1CXX9agFGrUJBmP1tA1jeCO0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FUK6pBWjz2b6pFq8k3+BfGHXBP3M5VU32u396Wuae6LZjQaRoWIdsbQRHg9pUEVTxG787GSlBFWve5ZaYaVAz8DytBQHdwvKgTmcVmndE6myPAGoSYoBfL+kcxfKGdVnWIGzPOutUuTbM/tZECKTI1Qo1VNYzQEBAbTJ+SjMj0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DK2Ar6r2; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ngB9TpOl; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DK2Ar6r2";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ngB9TpOl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779114046; x=1810650046;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ztw8ip/MYyXS1x9kFw+1CXX9agFGrUJBmP1tA1jeCO0=;
  b=DK2Ar6r24vyiNR1mEAQaJemipH6EbfFpN0/Yn1rto1Jkg5JNxgHFSyR4
   UpM+6ZeW7eXKFZNdq4xgdY0uNKU46fCx8WHLr9Y92Ii6WrwiYGsW1TCh/
   QAnCgwGhQ6z3cEj1WPIIGWRicyjPH1KjOYtmlsXIiZ4v5CWP4sZAVYZ5d
   heSOVyVrpu84wf2tJdDUDPRCjb67kgjg7kvkyxNMdgd1RC1odlCXBatCp
   D0GcR+qPMfh7EhRWIwFD4pRfMSDRgMEMJ+y+zHeXoYVq/Bzcba4FGYmqp
   a2mAhf4Bm7ujQftSgbQcnFJ85Ysue1yu1Gt0splebDM5bGbeJYEkk0yIk
   Q==;
X-CSE-ConnectionGUID: jA/aFnNTQIibpkoEDp/J9w==
X-CSE-MsgGUID: DHfgc7JiRiS43Ihu5OCD2A==
X-IronPort-AV: E=Sophos;i="6.23,242,1770566400"; 
   d="scan'208";a="147186643"
Received: from mail-centralusazon11011019.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 May 2026 22:20:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cH8lagi6IsLmEvvt7FQ0BDcVLbEsItaaQODPgULJCQL1iaGHMz6Qvb9YwElTyDbJAjXGNefx2K71Jut/vFeh8WcV5FHHhLWpVWHu8HwhNeXqf6ospqf7OLkHk/WL4hWDXMKWJnxf0U5YPe7Jp8QatBoBTbHF5YOviQYiUTtmszu+lPyElE/DKi+3/LWQGJqfXCvYFb6VohkVQYB/9VDBNZMZyePgUiJuG1WpPPDdJDFrMN/MVeJJVb2+ZSp3fkS1ycq/59vlONXklLBQ+Ctd7KbHuQ7ijs7VODyDA0sUI3dbg7Mw/P25fmd8KY1T2yDZvt47mI5K+/IQxdqkj0n7vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=inXQLNHAEudMQX2bP0ReQBVNA0xH6fptT8TEitQi23o=;
 b=AiuLAggBdwwlNMxiikuHFpmgVfW1Zl5ngFxLGWaQgRjikEwQPv5a1TkmsDpJhvc/+IPAyCmoGPxRJadSgp4byQSuhivlSMR3CPf9kuAg2yVpGepEiDNEusKHmHawSjUV08skF0O5PVAytZO3qE0M6px3d29jji4lYXbO29E8jRxGhK7XbhVDBJQV3fmnEh+zMUtZ7Czbrojf8xBoxVjK4fLpjlSx+Iv9FkIlATcuXEF5ElDNM5NHMkQM0V2vx/XsVbPzph0aVuYDeOWH0+HAIyvOX/P9j9aNinJVEmO6Pt7lKtyeee5ZqD5hHXJf8kmgg3bXhgifRnAASIU2oacTpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=inXQLNHAEudMQX2bP0ReQBVNA0xH6fptT8TEitQi23o=;
 b=ngB9TpOlV0EjN89DTDBj3sLBlKc9W7+zfPxFxpF7mKzlrfrnkbAFmdC8w9cP/Hn309OtfGOsCkBr4kafVLPQhD0A8JjsaKFe56ob6CKrsGqgB0TkxdTJHXXbVo5n805GBBpjaf0evujRF65+ypHGnAsumyGhhid1P8WFvdQC0Ek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB7921.namprd04.prod.outlook.com (2603:10b6:610:fa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 14:20:32 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 14:20:32 +0000
Message-ID: <19490a34-f087-44d4-9820-b4b093ec197a@wdc.com>
Date: Mon, 18 May 2026 16:20:27 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] btrfs: zoned: always set data_relocation_bg
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
 David Sterba <dsterba@suse.com>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Christoph Hellwig <hch@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-4-johannes.thumshirn@wdc.com>
 <20260514145422.GC1197064@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260514145422.GC1197064@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB7921:EE_
X-MS-Office365-Filtering-Correlation-Id: 1534d96f-039d-4173-57f3-08deb4e89e93
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|11063799003|18002099003|4143699003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EFGuj2nCdCJD7kqA1dtu7JNdmPfPZbGklGFKEWL8s/ibpCcp1qooyKUktUovlNNrvYWlU9uHPFtRR2LtWRgpj4wtw78iftCqcwwvCykIKiQ2EurkhHJL6Z5RE+KAajlXtyRQ4OXTqTzSHryrF1S+AxAdk4iOJzm0nko2U8AGTfVlniyR5ZiwRw2PhxHnRV0meO6Ln5Wes+mLFHGSpGVHDb6L5a6ZKOkDjzFomtMBkRlOdU/rugo5qpD1MgkhUDsOrI/DlyntcjL5Zf2QrsY2umEuL/dLVCmVjoeb8FJCPayKpszz46bc5EZE+dRP8/Hu/1J9E57zp3IM9RCLXVt6a0ABnCjGEn007vebqOAENU35Latu3MCpLJle5+nRQe1SNZ3Ox2IZ7Tsu3WpcXvpLD0t+MQ52S9K+KCEuSJ3FpXW1Bic1WFzMFBlSCc2Nj9QaNnBSAb9Vthy1/IWYj9c19mKHmBVscWBFWBKJ7KzkhX+ZBhGDaw9uaU6Lgk2sfSoim+DQdO05z8EbfDCGVuxGLPLRcs69/FdCIwyyNr/SvkJtmiFyynKvkgKU3ov1v8v9vRx7hM64Jcq2wHS53/Vc4PFj69CXcQTdzJSgOYtjNes5BDuIf7IkM3o08IREzmdsl3oE3hYx7+b93NXTM9ej1TrxwXM5CNUuZI14sKDeQ3VQLucHiwpqzfBHj+cWvH0b
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(11063799003)(18002099003)(4143699003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1JhY2xxSzQzTnNONlFmQ3QwWG9hNHoxSGFTMUl1WEl0eXh2U084VE42QmNH?=
 =?utf-8?B?dCtGZk12dUNpanBCMmNYdDQrdTRVWEk0RGxzOHZzZ1RHcXJNZlcyejJIUlA5?=
 =?utf-8?B?KzhRaytiTnlUTU41UlZIU0xLbk5sT3lvUXlVREIxZjdKR2VyZXlqNGthZE1Q?=
 =?utf-8?B?b0RRc3FSVVdyOTdWNzB2aWNXMXZhdHJjNWZpTkdaZHUvVTFEdkFBYmR3RzE1?=
 =?utf-8?B?NkJHUllXRlZsUXU1RE4rSXpzbmV5TVFKRzdhL2JRRW56V1JHVjlmZDZSRGVS?=
 =?utf-8?B?SzlCUVlQb2h2YzR3RXNoYXRUU3BGMTljN0ltcUdySVNQb1NBdWJJOUo1cXc2?=
 =?utf-8?B?Q3JSMGsyRkdrQXU3VFFzdzVsdHZtZEZ0R0hveE8zS3BGNDBuUUVhV3ZRM1Jx?=
 =?utf-8?B?ZHZmSUZjUUZPanZtTDhEbVZJNWIySDFkaEJuVnFENEptd0hxZzJ3eGpyMVBV?=
 =?utf-8?B?RlpPZXJxRXBBTkpyTnFnWjRUV3BvaXRwelY5QW90a0hDd3IxOVBnendoUHBV?=
 =?utf-8?B?SGtNdmEwU1cyVFdjWXlPdXJPWDk5L0pZbFRXaEF2c2J5bkNCOGt1dUljT0Ur?=
 =?utf-8?B?aml4RTUwcU00QVc0T0YyNjE2N0ZJN1N0K2dLU3d0R09VVlZqaW4vMHBjdS8r?=
 =?utf-8?B?VXpBRUsvenlhM3JwNHJjcmlsUUlFWG5hUWRGRFpaSldLUHloYTVQT1p0ZGJJ?=
 =?utf-8?B?R3FrS1BocitQeFVPbFZrRFoxZktxVFMvUXpIWTIveU5vREV6bGI1Vk9LRlBa?=
 =?utf-8?B?R0pUZXUxV2JuS2l5TVNsNGNBOXZ4a2FKTjVmdGQ4QW9uVVpIall3N1A3dU1R?=
 =?utf-8?B?NE4xQ2l1bzFuN1haMW8yZGlHQ1pmdi9OMlJuN1ViVzNLTXVubWhwdmNYTDdT?=
 =?utf-8?B?VitBZFlmTEU1aGE3Q0E0N2tYajdqRU5ORkNFZDJKSFZKb2ZWeTBtdktmWEUz?=
 =?utf-8?B?VWI4ck1tV0MwTjB4L2xjaWUwVlNmNHpDWnIrSVY2SXhCZzZKaGdDVFZjTGhH?=
 =?utf-8?B?a2dhYVNhb1FoOUoyMXRXZm9SdWNmaTJwOUlyMjNqdmY3Z0FuNkZybHphdDFl?=
 =?utf-8?B?dVhlUFBBelJLYUJXOFlEQlgyazlJdnBrZU13VzF6aGtPSkhlSFI1c09ZTzRD?=
 =?utf-8?B?OFlYUkJmZCtiOGR6TGl4VW40cWc5SWlUS1lEa2NscTQwY2JoMWJ0SWg4ZXRh?=
 =?utf-8?B?bEw2cksvZ3VPMW43NkN2akNQNTBQanh3RHliRkIyV1A5bHNLc3A0cmZNanZ1?=
 =?utf-8?B?SGNka3UvM3MvR0Z4WURNSDBvaWNyeVR4dWM4Sk0rSTI2aHV5UEtYOXlkUGwr?=
 =?utf-8?B?b056NFNubklBRkxIQ1dTVUg3SXIzM2o4ZXk2UFUrd3NLUExvdlYzTmVicS80?=
 =?utf-8?B?dXNNd0tYSjdrV1RBR0FkV3R1MXQxS1ZldlRLV2VyODBRWFZRNUYxMzJTYXYz?=
 =?utf-8?B?QXM3ZENOcjBDZTBOeFhUNmE0UGdCUlJ3NSt2NjlhZC9QU0VwUnVrbk12ZEs4?=
 =?utf-8?B?WnA1TmVHa3A5WkZTcHE2VzJTOExkMit1OXpZU2cybEQzMEJCbUd3N0tXWFFF?=
 =?utf-8?B?cHVERG1oRHphYllmWjFRNEl4eTFtZU0wVENjNjB2bGdWeW40SXpBZmU5UW1m?=
 =?utf-8?B?UXVXR1ZkREdiSXFadisxN1JqZzVRMlFPNEVScC95S1NseHpmM0tCVmFaMG5H?=
 =?utf-8?B?cWdwUDFONWV3TVh1NWk5UzEwdXJyWldjalhiQ1pXYkNiWmhQaGhpeU45WkEw?=
 =?utf-8?B?WjBUWTN1Q3BnQnVINCtJWEJmTDdoaE11MmNsN0hLaTJLWHpHbnNLV05adVhk?=
 =?utf-8?B?Vm5QbE5zUUYrWXpLa01uRFJ6NWJDaHhBcmU1bkRTZTBsczlDNHlkUnVHZW5I?=
 =?utf-8?B?VW00dU8vMDRHUlUzREQyWkZoVFc0YXI4d3BRZ25wUW45WVcvdHFKV2Z4Ly80?=
 =?utf-8?B?Wm1mdVBYVEhPcUxscW1oZStITitxV2x1ZWV2dGxSS0xGY0hiVGV3QmFzUmRh?=
 =?utf-8?B?eGxyQkczZGROczRadkh0SFpuQlRXbElXL2kwN0NsdTIrRXlvTzZUOS9CK1E4?=
 =?utf-8?B?M1lGeHNBSmk0SmJEQ093UmkxM3JEWkFaNENEZWRtVjdJeFNjY3h6UzBzbS83?=
 =?utf-8?B?aUpzV1Uyb3pVUGVLL0tScUtTRk9BMlNiTEVRZTR6ZzliTWlxaVJ6SXFnZG42?=
 =?utf-8?B?REdMc29EbE1IMGhud2tvWUx0L3kvNVJGdlk5VXdJOHR5NDNiT0FMMkZiS0Fi?=
 =?utf-8?B?UVY0OW43eVFzRjVlNEZQbzFUNVlPVEJuYTAveEducU1pdTBJT0RyTUVBV1hv?=
 =?utf-8?B?K3h5OEhQaDQ5VHBhTHhwS0g0VHRmMGZrdnVjWFJranVrUXhYVzZCaFNhaC9l?=
 =?utf-8?Q?QPG8biU8IwDvzbYA=3D?=
X-Exchange-RoutingPolicyChecked:
	gm2kS8PArzBn1FhHVbJukJoagPIWflh4OFUtgvSZphlCQeXCbxXVxp6P6VwDTc+8Y5c7OyL1GTxglJYwmbb/KQt4wZ91Mb+QENpyCfSguiiNVmeYXaXrphqYU2o+7bCJiHZxE1MXtwPH56jD1XzffgPvJAY6sxlxERqulfeefjK1II9gC0MR2P0+fsyUYNI69TB3eEJtZkzT1O/FIob/14dUfLTN2jNw/cPFggmiPYDr0CX9+A5GWJPHpmx1wi6aoNzrYa9Y1kjyFF7BM4IFcM7LnRVrq3bnGFBlaW+YDvYFrzFd4EUPEm51wj8/dMHu0mQAgC8m/VclpqR/yTl2ug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kkm8IlcyxHUXIxA1Uf7Gnr8se63+z9n+ea9rNGU0wXjJ4X6JhjJhh+WxLqk6Mp7OhyHi3uzmTCy+kzgz1Q5EWktCZH6nV8iu3U4mQ7UuTgX+RL3ciZ3RE0BIPSQCH92VyU20/t+BTG44h+++FdOUam/deIgh1MKfnJToIaeMxcWMoBdvpqfxv0fc0p9JahAlkiKFEc77fbCd6lLfvzlKbR8aVgW4Mj6TACC+qXwLX7M1PbmUdJy2RUpg+8fOWhXnAsFvL/p1T6SnRyRr/FBl9NLlTFNhETqMtel2RbLng+PNdSCOEnYgxI+GMC80xtWnhPj3LLQWkeVOrqIOmPSbOy3RR8xByK9Kr0aISnjf6fq6YJLklOgsmZ39nwJcF9ihMF2tNYEILNQtrFVjeCKaUr6A7yBfHBuF8N8TIEIKDMKwyiRss/AS9yuvyatpC0kWaGOuXm5aZ7eFyHcXUDSnKhpJV5GBb6SubNMHa6AyDEfdbOd6MuLUCE6GyGwQGqcDksOwh+njAmGX9dqBf7dDqn/O/r+8aHXcNffycddSb0xcZN8N4TT6HRBTNJ0ElrVMMBJcZClqq8ZY9WlT10+UiqONON4cq36v1vfiPjTGCHiKWoB6G6EF3eafCIT2vzKx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1534d96f-039d-4173-57f3-08deb4e89e93
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 14:20:32.1331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YF0N19caU109U60/20K1hdpWAyb3hp80pT04mejNKw4H+ZmzTDToTfjCxZaGzLmtmHAdIJWKsJ/J7KubyxrG2tG2XVH2MDGwElkTYltc+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB7921

On 5/14/26 4:54 PM, Boris Burkov wrote:
> On Wed, May 13, 2026 at 02:34:41PM +0200, Johannes Thumshirn wrote:
>> When searching for a data relocation block-group on mount,
>> btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
>> block-group. But it first checks if the block-group is empty and if yes
>> continues the search, and then checks if it is the first DATA block-group.
>>
>> Reverse the order, first check if it is the first DATA block-group found
>> and skip, then check if the block-group is empty. This enusres that there
>> is always a DATA block-group set as data_relocation_bg in the filesystem.
> You want the second empty block group? or the first? if you want the
> first, then checking for "first" ever seems pointless. If you want the
> second, then I think you need to layer the "if (first)" inside the
> successful non-empty check?

On first mount, we want the 2nd empty data block group, mkfs creates two 
data block groups for zoned devices, one for the relocation and one 
regular. On consecutive mounts we only want  an empty block-group as 
relocation target. But thinking more of it I don't even think we need an 
empty one, only one that has enough space left to host an extent. Once 
the first extent got relocated and it fills the relocation target BG, 
the next relocation will perform a chunk allocation to create a new 
relocation target BG.

The same goes for the data block group. So I think we can skip these 
steps entirely, as long as we end up with a dedicated relocation BG.
