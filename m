Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41D33B530F
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 10:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074496; cv=fail; b=pI0vycE4VlrWkRXwwvhCut/NL8VDPdG0aqtlCiNnYJ/COh6XCv88ncjUejVAj45EboD0ZhGlikWPYTpcN6IN2uzMD9ZRsHvPDUYdn1t71nmomeC9KMuPpSrrU6f9U6ar0loO82zpMRUlmGztG679mI2JIyzadnTXb25QvYWKvY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074496; c=relaxed/simple;
	bh=+cy8qVcnIaB0ZHFpS5ybIJ9qUbqklnp9lQDtozKVdVE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RjolT6zhdHObwe1Qdk81v017zfgPwJ3gM2BL8bkHip/QFq8sko9MOIqtXo78reiTz5RdOrSYi/heSh4jFeJsieWuUGD/16BJ5SVDQta3koD/AKjk/wcbOqLG5lIt6Y65y2CUJtP/R8RVfFFV+z7M4uWcssM6msWLA+EYCMF+JVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pFsInikr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=KyKDvFpV; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pFsInikr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KyKDvFpV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783074494; x=1814610494;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=+cy8qVcnIaB0ZHFpS5ybIJ9qUbqklnp9lQDtozKVdVE=;
  b=pFsInikriugThdiBFZvBNiyaCM0eENX+4JRCJqEvnquCsGg2mCiPxGwK
   kYKmPc6LDV39WYegkRdNX9P62HLPhsQ61nRya7w9G0c7NEc2Em2ak/DFJ
   Ytj3L95+tp8Dvx0LsXf0dUYb8Dmz8EKUSgf8I0+zTMVE1EtVX+AR4QtFX
   ftBoxdtOpi21+2Bj+EqWWrgccH9HblLyE9NRmzU6bn4S/eN8F8KqVQ7zn
   2ic3wr2ONQt/Bwt6fLo4PGZCScV+LC77FfBQ1VNzYVGuTrO5foadBNn46
   J/tk5WKeOmZybWIKv4JYkbIwwWcM2pPox7gM1dol91wGa1TplmcEtfYj3
   Q==;
X-CSE-ConnectionGUID: ofsY6myfQrqPYMrB3tGrUQ==
X-CSE-MsgGUID: k9xGrsZqT+Kmxiz+64O5tg==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="150000359"
Received: from mail-westus3azon11012055.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.55])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jul 2026 18:27:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ljaqIMaBMV5XHt74h6NQlbK83eR7Vey82rlf1OlBygkgJ90/8txVeIUue1Z492vLWzPcgmDbGY0mdKglBMKUpN6txDQvHKHP8K0doEGGNLQ0JTfiNawpCLZaaiaqUWh3lusN00OFbAS0RSVSBzo+12bslkKpiq8Uu/461RNZcEOVEB/+tCF0u76/Waa1RQSn0jiGEau8a7uj1wkFVSnNg5tEzGUCt2/UJ29VGey6/JfFH4bpDldPa8r8vIkhD6sIMO5AK2NZJ68uSkqiVAwQKHxQGitPsxOn/FUt81FbcJrvzHGAXwx9m5IC801OQj/0GxP/AwDtsJw4PYbWbAMzbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cy8qVcnIaB0ZHFpS5ybIJ9qUbqklnp9lQDtozKVdVE=;
 b=WThaLzx+WMgQ6oRIOchqjIU8TALTznJJCrFepvYBWGq8ug5pGKBA1/KBSR4wShc8I+Ky4w2gzbHRTiiuZJmTKsztqWGLe/zmlYo0wZgTdDiB37CvzoGDyf3JFXTx1Uhtxkrp1554BfKBeNx1QjwxX/s9GGOW/HZvKXk1QyasJ8Rp+2sTBLXKAXMP/f3I6Idl1vYq6oya7hkg1dF5TAo+eD0sHVipv/6NnQE8R2+uXhv6YXdP6QtOOajeWW7NzjrhfW03cvijNUSx+Zxmer8YR342XlabT1JZmoiUZu4JnLol3SlKm/rwlcuUhYNDnErBWl6FFVZb52dQQr5s9Qjsmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cy8qVcnIaB0ZHFpS5ybIJ9qUbqklnp9lQDtozKVdVE=;
 b=KyKDvFpV+ZtrjAsPAnAt7mfHENN1ou2mPkyTBuyj8/1mx7N0/aCvKqePvDHtT6U39f1a/NRe6sgoNFxcObOlj8zdIgWHZ5kZJLTcvsvSLQsxJKLRUGuExmnyLdgrTTxJom+yzJvZv8q5SFxK0HRYx+QBwitgjw9wgnbVvhw1V9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7900.namprd04.prod.outlook.com (2603:10b6:510:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:27:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:27:05 +0000
Message-ID: <10669cf9-5fb6-4663-98b2-f0c7d909b2e3@wdc.com>
Date: Fri, 3 Jul 2026 12:27:01 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] btrfs: remove "usebackuproot" mount option
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1783071857.git.wqu@suse.com>
 <4d2862f2e418a7510862f80dcab5386a40e3b33c.1783071857.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <4d2862f2e418a7510862f80dcab5386a40e3b33c.1783071857.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0266.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: 51b45885-0ac9-4eb4-1ba9-08ded8eda0e6
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|19092799006|366016|1800799024|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 wfxrG8vEye/POqrI8ruh9iz0wAaraXWeMVaebnt8pz4XhiuK/+CO2ashpoEleEsbj3T5kcpmJbjX39nNHwq/e1Q8j/vtGpQRLtDXKhZZv3kgJ5rVcV7itAKdkwp3epRoAlww1NKoozE3HqcEZTuFNzBqD31MhDJeZxrRVaqVvByHJTR0DrM+Mcm+X/fr2Q7W3fWiE+heu58GuLC967a6BtroNxbaBvBHZXNrcR3Bgv62v/khR6IUggKiGX9P6urSlZEZz5hj4/DSb/iRHki0n+HoIWoRwgvZDXusXVWTMvfbFXNOTMcUv9hZY8h7DbCFDJtNp3sSFH47sRoKTgTsgoDJjaopmc/GugM6wXMPLUVzAjqdOKet2oz9kPrqi+SzyhwXi87ksXJBkrP3o+x7m7QQ9B5ltSJ6RUcloD17wd4QQDs/VCLnsYiCp2dBXXTrzrsw9IhrqteJVWd5jFb+WXfPPO4KSrYXpNHgjM7u2pVMbl+f4LnR36rTt9JhotF8iAIkZ2opv+ZuZfyYUnGmJ2uAR83JuZp8whXOKC+F36Oi0INYaBgm+eakMW3X3zDR/zEghNBJrpTr7y1gL8msxHDbIyNwnSnCLc/nXEsjifoqde2DMmK1jXQaEi8uf3QbANKyCO9CdcCyMnQTFZVy1GMY6YjfYG+aToAkM5Lm7oc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(19092799006)(366016)(1800799024)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QXpMWkZ6UVlQZ3N5K3llSDJZQ1o3S1BMc0ZIQ2hZUi9IK2c3OTdVaC9lSFhV?=
 =?utf-8?B?ZnRQMjl0NVdGQ1Nsc0NTQ0lXaUt0Y25YNWlYTHFENjYvdlRiWlRWYXdqSWx1?=
 =?utf-8?B?WUh6MUJwSXg1M21GQXM1QllDWU5yRlF5cnkyTXZ2b3Bjd3pKd2FaMFFvRUp5?=
 =?utf-8?B?VVlqZEoyMUMySHp5Q3lRTEZ1d1QxdmhxVmYva2lsTERmaW9jMklWNU12NzJG?=
 =?utf-8?B?MkpVenFTanJZUHV6TElsTUdhVjgrcDRsNHQ0NnRUcDBQMUg3LzY4RTR5VSt0?=
 =?utf-8?B?ZTl2QkRWMDBiRnZReHM0eEZGaS9nQXh2OCtKNmdNRmNSMmZuTU1XQ0dFU0FM?=
 =?utf-8?B?MGZWTEFpZzFvQ2w5Tm9yL2tSSUtkOGdLRG4zdWhpTU1tRFplNk12NlVGMFJr?=
 =?utf-8?B?L21KQlNwcHdyTHlES3VGeGhmdTdRZkhDQ0JIY25pdXE4RkViSFZyRDFwaWty?=
 =?utf-8?B?bEU1VU9oWUlDZUszYXpKZUtWSnlVTjM3ZWZERHd1b3FrOFBIM0ZpSEpkNjl4?=
 =?utf-8?B?RFc3Mm03bE1KbGZWYzE0VVhzNUhCbXB2U0dLc0xjWEQ1d0FTaml1RGY2eVVQ?=
 =?utf-8?B?U25CWXl4NWwyN0dNTXFYZnRhWSt2QkJKZVovdlQvQ3AvNWtwRW9UNC9UM1c3?=
 =?utf-8?B?TU1nd3JKbk9XV1hoNy9PM3lFT1hERGVydHRZUEx6ajVwRWpTYjBYcGJIcjBC?=
 =?utf-8?B?aWUra2wvTWdCM2JWQzl6TXlPd2UyRWJIdlg3R0VGdVprNk1WLzVZdlJSUEZR?=
 =?utf-8?B?aEJ1VWVjQVFUYUtsbTg3UGdKc05TL016b2RlbW1iMG9VSDVzNTkvRFpHa1hn?=
 =?utf-8?B?Ukg4Si9ETisrbjNuZE1DMHpzb2ZXbkRLUnJkRU9xUVZORHV2NkxReUUxWm0r?=
 =?utf-8?B?UW1zKzlZRnJBakJnZmlZd3VIMkEyTkg5Ymw1VnlxYzdEcmpkK2JFSmVaZEpx?=
 =?utf-8?B?SkNPNkVtZVJLdE9IUjZJVGxuOXR4b2VVUm02K21CVDRUdDlJWU1qTFhWWU9B?=
 =?utf-8?B?VWo5NlI4eEVBVE5SdzhRdWNuWFAyYW1mMzRhYjNXd0t5cDFFZDZmejhNVEZi?=
 =?utf-8?B?SzJ5OStSM3p5NUZvNjlCRE5hRGNFWGRUVnlOcmdpZml3N2I2MWh0RXFRSTZ1?=
 =?utf-8?B?WXFqbzI5UExVSWt4UDhFWE9EYjBKeXFQZkNNNWw1N3l4d3BvNHdyT0lRbnZy?=
 =?utf-8?B?UmhCVldtakw5V0tPdGVGKzlJdGlBQWtVN1NDaFIvMHBrRDBkTXVFenJhamFM?=
 =?utf-8?B?d0hxLzAvVWp3dXpTUDBIQ056NHZJbVI3UVF2N2Y2NkplYXNJOEpacXFkUVRp?=
 =?utf-8?B?YllmcGFUVXp3SUZ0Y3RPQXhYZ0FWdTVEMzdkWEMxbzdRMitodFBHOHBqeHc2?=
 =?utf-8?B?L2tmOHJZSlN2WllvQkRkS3R5YjVBZncwRXZ1dVl0ZUtCSEs4WW1ycEFwcHp3?=
 =?utf-8?B?UURURzljR3ZVcE90SnpEdWdLT1lqQU4zOWo5dDlkRlJnWnc2bmNZc0Fsdldj?=
 =?utf-8?B?NnQ5Yy8xSHp0MkNjVWNZczlXcjJVOUYzQzBvNk9oNnF4MzludTFsdnN3Vmwv?=
 =?utf-8?B?RFZlYlREaHhMMnpJMnNsL0hOeW9nRGNrdEQ1TXFrVWREczhBcmlyQ1dzbktY?=
 =?utf-8?B?ZGtJR3NsR0ovVTRYWENCdHlEVS8rUm50bTBHS1JRbVcwT1ZRM3R2YTRFc2RE?=
 =?utf-8?B?ajJmMWlhMG5kOG5ZTUsyU1hnUlRLd3FmTHlkT01CclBsSjRvZU5UdytSNTdp?=
 =?utf-8?B?Q25tVm5HcWx1a0pqa21qUnFuSlhiRStPWllzUVdVSWsvalVjRkZVYlZxVjU3?=
 =?utf-8?B?b216ZnM4enR2eTYrT0RPU09tRVdRQTFHTUFuUW1jYzhCeXhBcHRqMFZ1M2Y1?=
 =?utf-8?B?YVBEcnhGaUhGaHQ1c0JCZVV2dm5xNHR1K3pDMmd2aklmRWdVYnJiV1NLaDlV?=
 =?utf-8?B?N1M3Z1IyWlNKNE02SzZaWWJMNUxyUUhjRFJZckg4NlRIOXc4UTc4bThNaTVB?=
 =?utf-8?B?emx4MmE4bVQyOUJ0eDI1TkRiZzBpWjZDNkZVRGJQTVBxck9xT1FSOWV3ZTM5?=
 =?utf-8?B?RGcyc1VKeUNmNkJDaTRtZjFCSjl2L0lWK3ZURVJReDRwOW8vVkFYdEMrVndS?=
 =?utf-8?B?S3h4cG9UUk14OU42emNzOUp3T1E5OFh4QVRzS0w1VGZJRVA2YW1uKzhrRy9W?=
 =?utf-8?B?NFZjT0FmdEpsWjBqMHJvTmZrdERvaDZha0xJQzFIM1orYzUyTURhOUVIS285?=
 =?utf-8?B?LzBQNHRWOW5VZWp6WllZdmw3aStUNCtRNUgyN3JRdSsrMzBad0tpdzAvZ05K?=
 =?utf-8?B?SGl4K0ZPYitGNnlyZG8vQy9OOWhialB1WDY4RHFVYVVZQ3NpWk5DamtqMnlI?=
 =?utf-8?Q?/304PHt7SvWRkFfE=3D?=
X-Exchange-RoutingPolicyChecked:
	SdBRBrBS4R3qD3xc7h7QTfENYHWeS2wUGPQAZcz8W14ITfHcavSLwCR5G7UAgy0KcPbCurPEyUDEBeAyzZzBepqGcme6EZ/3CdQjnwjrjZflIr3gyq9kMIW8rg/ZawntP85J+fAOH5eMgJBuNj2dDU1W0HyD9hfelO2q0Ib2H0UdOPYb5GdFMRMe70QPUsDC2V0sWxXl3PHFkc0qDsyIuXvVGrqxrhEKPQ+ZRtCOyVv2Te2u2X5O//NXEt7tTZz75kwXo0SGYb//bALPHYUdIniK1hb4KHeVT6pBxlvreeqjhwLTVGx1D9WuwHWhS2PwJLK1wQgQ4VOTy28QCz2FCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IZnqLxEj7JW51qhjsMvs5awZ4AFSgu9mf17vNWSs8hAjegN+JWDKQhzP85SmhSv0O5lFJXKi1K7W19SL6yblhpPiUa0EkTdK2mCSKYbkLm4r1xoS1sFywBC10ia3BmRlNunoqhNyb/Uj2l073Jcp8Z1AbPKH7yVVNvBhR7ymkD7iUwM+oU3jUGHy0vW+XNP+umhCO4LNkkd5mzGijpMtcGdR3Ekwt5rf9DfO6ASFZQRSFyHKXpTKSQIfb0Q47s+6BYzNcDK4Vrwh0CmuxpbMuGkxRxyhe6pMK0S8NjFeenfi8aeXBjdxpX7MB2+R755kej6Xqx+UeVjvFSdFsCOVYuREzJ3bFUeuLfRzra7S4MLKYHLzoFtBIxNM7HSO3NNij2czb04wIm0ykjbzZ2uwORbL0HB3j+pyjVDscsiWZRfTbCjwYbc/G52WVpvqMdH4m2rSPc3lw0yTfjhPO7OtpFQmeDeq4w2feLSS/iHmX9MwJbJLDauzjVztKg6veJ7alP74kbK+ndAEkjxXg4VigWhEh7IrCOSAlW/yqkxLOSC+UgYL5aSmIVWGlpDnAiBP8NyjXGp+B+8gbK++GaTMsmp9a8nP8vH91DXOT4hdlJU4ecxVMk9+zO3DsxaNPxNR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b45885-0ac9-4eb4-1ba9-08ded8eda0e6
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:27:05.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IkhkibcUXDEaQ1lrcZ80ZPeNnlUm54ue2UpFVLrfMqZibvrsg2owYF58iHubRVMqIKkyq2JP8FMOICd2igpjoqcJnY18QjB7brNrm9x9Wvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7900

On 7/3/26 11:46 AM, Qu Wenruo wrote:
> This mount option is marked deprecated since the introduction of
> "rescue=" mount option group, in v5.9.
>
> That's already a long time ago, and it should be safe to completely
> remove the old "usebackuproot" mount option now.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Note, this has to be removed from the man page as well.
