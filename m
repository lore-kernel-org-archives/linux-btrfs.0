Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F236A03F
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787734862; cv=fail; b=uGqHojQB9PxmFDJj52NTQygOLwpJZGUaQH1flhLUUWI7C4hyRx6FQjoxwfVpTC/6SiOZq6gQUy1g2CF/RS4XBGSsqdeytgkebuVvSXrZCICHX92TVe48LyySyjvXzc376Y5ptvUw23srFALnVwp5nEHGCkT8xF5ZLShhxnX1x7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787734862; c=relaxed/simple;
	bh=20V/EA+k3rYc1hUSBUHPZiDkX6TDuU9SPvbedzY1h60=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TdCPXggjFZurX2rk0mPkMzZt88L8O8SezL3lfmn0f0zXjgjfu2imf20bLDc+5cr1PWxDyzSwNR1VDgCckpCj5mqkChl5jTHB5yxXlk5PjkgOXZ3856OTpy3j8MyGGVJeaVCTo5yWyVtvCTKPjCYOsT1MIF7/kVBFI203JvDVrJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XuqxuQ02; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Wowx0bzg; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XuqxuQ02";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Wowx0bzg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787734860; x=1819270860;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=20V/EA+k3rYc1hUSBUHPZiDkX6TDuU9SPvbedzY1h60=;
  b=XuqxuQ02ze6JRu2pQfMiWH2ELh6WzEbYNgLhEE+37Swiedr44G5utc4U
   u7NRU6FSiNSnTG14AmclDq+2DOlDTOIayGQRN8IMd5VwywsPeZ/39lFGj
   w+H+rmcyf9qyz2mOkwIKNtToT3GIYITNswUN1QgHMruF2Zk/6kOmF7Auu
   l/JsIBH6X0dU276VtMwVqm41cxaITcwyLJP9/VBbuRPcEFXgvkwEwwPdb
   EH3d1R9qlaweJJIqWzvwZ0gWjJBujA+2tIKrxI8ypOPLLF6Q+dcF0dCUt
   5yBEQ7tu5MuyAFWm7AweMoAK4N0NanwMu/4wuxwrORUdRcxiZuULGxrZx
   g==;
X-CSE-ConnectionGUID: IqXeQd6qRp2wvYi80nJq6g==
X-CSE-MsgGUID: g7ii397PSsmgF3CHvfZf8w==
X-IronPort-AV: E=Sophos;i="6.25,244,1779120000"; 
   d="scan'208";a="152723437"
Received: from mail-centralusazon11011063.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2026 17:00:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V4ThUastQZzNOS4OuawmAx48l93dDMsKeWiTAxzInwVg2NLa5NkqqkwSCBRn2cI3NkD8YkXiNCDBSxuBho4+ncWzYFkFJ7n16ic/shKh5attIZQMziNfWj/u40HNVIexAX1Tof8oWc0A3qcUToU7YupBuZu8JibTQmsT8+17f/r0Jm1J+P1KnsxzYLbDzOh4bM79BP5pxO4Aeev8TFji/upPrB9kfOTryot0UAFuZm5Pjqs0B6jj7BkDCT+f5DHi3BqovkkpHtdFvkGlmgSULmS95We4dRZOhfOmq5SZL3Kr8X0P8mhYJbXGdmG3/CgiG/pTXoAub3l00yywo0bblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DnqrKpKOOOrlcsIASFxRXQiEA/I+bYzmGx+x3tn8FuU=;
 b=LNHnkmV0UJsVF8W3iU5QJFLBmXCq2cSp6mieQsjHYD1XkKNza0FfAwvCqzL90P99+RPFWkXWDnz/WUqCOGJT4Z8JjQRaiVASkUwgetISH6ZV1LOxpif63drY6C1Q7S47llsRRgpnjlcdoGn82CET1vZQSAOFW1NNfipqYBUrtraG/D25yq6SyTkW4l5nl24UJiOEOpTpDLLflRpjfxqB9K1ciXUGe7aCUSC8QnQc2azldOpGX7rkSECPESEMdM6dPpv+J8Lx6efvzy4QqpGigg0ptCn8CyqX4LpHra60QRBtscFLpeEMm8jug5Fg410h9uZgz2M1X+09P+f7OgE/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DnqrKpKOOOrlcsIASFxRXQiEA/I+bYzmGx+x3tn8FuU=;
 b=Wowx0bzgo1RA0V6R5ub8bUZ+ul+YPwPw9SyEzAkCPe053G68kOax/ktbwIYMZ+K/bhYKklE6lCAZzwl/Nfivmz84wRAWcFLkqypZwziK4YPYp9cvOSKuSXj6Muiz1i7Izd0cSbSxUGdwlLEzOZNLnHvyjTEv5sUqXJ2A7Hfu/xs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB6586.namprd04.prod.outlook.com (2603:10b6:610:6e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 09:00:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Wed, 26 Aug 2026
 09:00:49 +0000
Message-ID: <e852d4c2-6765-4d8e-aaa4-f7dd1dc21163@wdc.com>
Date: Wed, 26 Aug 2026 11:00:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] btrfs: zoned: track only sequential zones as
 active
To: Dongjiang Zhu <zhudongjiang@fygo.io>, linux-btrfs@vger.kernel.org
Cc: naohiro.aota@wdc.com
References: <cover.1787717573.git.zhudongjiang@fygo.io>
 <c51aaf7f4621dedc36c275bfa9ba1ec884de09c4.1787717573.git.zhudongjiang@fygo.io>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <c51aaf7f4621dedc36c275bfa9ba1ec884de09c4.1787717573.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::11)
 To DS0PR04MB9439.namprd04.prod.outlook.com (2603:10b6:8:1fd::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a6571d2-e566-4fa4-824b-08df03508513
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|10070799003|23010399003|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yLDIWQ3E5Iug9WHVA77E6LIn75vh9Qcp58J+O61JZiGsQKEZ/gkh6akz/nAev3hNW1TNspSEZTDaWJ5Ez4yXYluVKlhw1fCY+3DtgQqC0U6hG68yYyMhja/fFolNn1YYAgOOek8fF3rTRJqX7WvjN2b8T/+8ssvY9I9clX6bw5I6YeEBCYarGwW9rspRS7oAxbCQQIDG9kjiRba3B9IDEEYKfvOMs/TdDbrIi4FNkFOC8QockNwJk/k3onZK86ZajdJ07TPsmhUlNsyaPPp/cabKDugS/Wmx7NmmoWxTFHstefkhIxTEVp+rD05aPCkYNSi0xqOWKlUqbi2Bqcks2ar8oZa3czqKeD5h3/vnANuLW0qPno+/a/Tz1fniArwjghSrlA4ZC0QiQqKU1L5yEc3j1/KkTup9DM7L+eyf/yi8t/bJk+K2Ta53drJW7Ib9LqLnvaLTxCFjuVfI3PYC5CeCp3U4VDDbpiYBZ3fAsVqGrT4omT9KSXtMoIkP0rMcomhfHzjOUMEfBxy7VenZoLkW5dTiBLWauWNXg7/VF0Tt01MfT1ZBgrhjnzAQcdEjYLqJLR7fLiVhTL6/nF2Imm9dgcpRHgHPJ+ZgDBVMLz/dW2w/kkQri9YQuBTVcZj7sZaSPWaI3FFSq5YK4R9TR+49ajPlEYxpwOewMdsPOV4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(10070799003)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTdwd2gwK0VreDJlUnBwOWFOMjBndDlGN0I2bzlhakRJenkxcXJuRlRiNFhF?=
 =?utf-8?B?WEdVTERDcjJUUng3UTNWcG5hTUo1Z0JFck1qSlExQnNGN0RnUktjZDRXajdp?=
 =?utf-8?B?aEtDMVNrTUtZL2REZVF1cG0xdlAwc1Q0SlVKZERRZEs1NHJwMmhINTNDUnk1?=
 =?utf-8?B?Vk9md2RDZ0VmK1M5RUxRVDhYZHZOck9VK2wwS1FQcW4xZFIwRkVlM0JKeFlO?=
 =?utf-8?B?MEhQMENIVzRGTHp6ZGJENElCQWRnZDJ5UXV2Znp2Zmw1WkRPa0JtbmlGQUJE?=
 =?utf-8?B?RDRnUDlMb3I2QlFLZStHellpWUZwSkNqclhaZUg3SlVBRkYyREpYS09YTHpk?=
 =?utf-8?B?MlRpbFZnQ3pUSXk1d2VJbjBKSUNqY3JkbHFRbFgvZ2w5eTFLQlZ5bnQwNEhw?=
 =?utf-8?B?ZUpHQnpCaFpwU0FWbHdGeS9IRVJ5OUVuVkdlNUdnM1ZzYU9ZV2thR3lsd3Mr?=
 =?utf-8?B?azJLYWw1MitERldKZnNLdWgwT2JFV0ZrZFJ5NVFySXBncHpGc3dINmhraDh5?=
 =?utf-8?B?Y1dxRzRDVDc5Q21yQks4VzBiS0R3Y0QySUNHVVFTTzB2V3I2VlcrTUYraThX?=
 =?utf-8?B?bUlGbGsvcmMyR3F2VzdveUw3Y295UDVSMUQ5UjRLYUVNZ21KOVFNZk5Vb1Ra?=
 =?utf-8?B?d25RRmxLSElUa25vMXhvN2JiRnc5MWZPYWtGMkhyM1FkcWRSZG14Rk1LSDZw?=
 =?utf-8?B?Q3dXbS9uY2VidnFTRklvM0ZES3l3VDFCeVdwWUltK3ZuN1lDSlRqRWZDRG9t?=
 =?utf-8?B?TjhNbWwyN3NCeXdnT3BvUWNIWTEwZDAydndKcHR2THRRLzN1WFhpSjg1aFNB?=
 =?utf-8?B?MnJsbDRqa0E3Sy80QXV0TW9Qc0hZQjFac0VFd1ZsWlZRSDI4ZnVZejdVYUhW?=
 =?utf-8?B?Yzc5UkJZSXRsalc2MWNzYlcxVUlYRXlXRG5uV1IwQTRqbGF5NUVNbVlvbW9X?=
 =?utf-8?B?NjRHLzdyNE9EZ09ZMUk2TFpjbUhNTlRsR3VhUDFMcHFaWnlFVFNOVmFLV0Q1?=
 =?utf-8?B?RzV4dDY5OGZrN3NJY3RsMjdKNFQrNDlPRnNYQzB3ZzNwdk1ObmNHS2QwSzUz?=
 =?utf-8?B?UjFCbDE0clhTdXc0V044YnI0K0VPUnFKekhvV1VQczRBbjgxS3FBYXQwTGlT?=
 =?utf-8?B?T2NaQmZrVG5EU1FVUmFvVGtDcEJnNWVLSm1FcU9QVWR6LytjZThPWXlVaGlh?=
 =?utf-8?B?RjV3cGFYUmFNN2RhNzUxMHB4dDNaTmUyQUZJbVV3K2NrUkR5L2s5eHQzeWxG?=
 =?utf-8?B?QjZrWWpWSUFFK0krZGJIQWdNMElpZk1jdVV4YnhNUUxIZDQwZk00aUxMRnBE?=
 =?utf-8?B?VGswV3RwY1U2dUJVYWZRblBSTVVWWmJXRXpDWElYMnVhbUY0eEJJdVF4N2JL?=
 =?utf-8?B?ajVkU2pyS1VMT3NvcjJFeURXRlpPcGFHaGI0QzljZElVdnRlNk9qbTlDUUVQ?=
 =?utf-8?B?WHVhV0tuVzNRb1RiUGlLbHl6NWI3aldFZHcwa2NUOW1ZdnNYUmRqSVRiS05l?=
 =?utf-8?B?TEpIMnJ4MWdFVUdqMC93T1lsV2w2VHd5SXkrazVLV1hrcEoxTEU3WHFkem51?=
 =?utf-8?B?N1JqS0JBeXFLUGJLUmlLRzM0TUF5VnRlVWpDRDZ6RDBLVWNhZWhmVGVSQ1Qw?=
 =?utf-8?B?ZTZxUU5zTjBKem1EVGRwdlFEWXFNMkNJMG1xbEQvSWlkT0Nsblk4SVNXQ0JQ?=
 =?utf-8?B?MlJMOU9CUHRTSXJQZVFHTmdCenNzTEFGclJCaEdRWDhkbVJyNVNYRzVtTnM5?=
 =?utf-8?B?STVoNnV6WlZEUSt1U1JVMXl2eTY1MS9KMnUvaU5sWXVWWlR4Z1R5U1BueWRX?=
 =?utf-8?B?MWxYbEd5S01nY1FLaTVpV243YXNtUlVTOGtCTWlYbStyZXRBYVhhRW82cXl1?=
 =?utf-8?B?YW5iVzBRdnFhNVRaQmtCcUxrUmdEWGFSNVNtQ1g0Wk5lTDBmRTcyNkRGM1RI?=
 =?utf-8?B?QXdhNkNxbW9UTWJSbmo3YzROdXVPNk9VTVhxT0hSUXUyMUhINmo2NU9ucmty?=
 =?utf-8?B?eThUL0ZpVnByVnJXV3BkTUJXN0RFakNHQkVtU2dKQUt3UzhBZ1hTc2p6b01i?=
 =?utf-8?B?SUVhVExzOGUzZkVDcHZxWEtTbjVMckk3Ujc3bkdPZDZ5a0JIZTBYVExnaHVl?=
 =?utf-8?B?MWZ6LzVRR0hpYXVEM2FOWVpIYkIzMWZvM1d2cXk3QWtmemFtd3RoQzh2b2dO?=
 =?utf-8?B?aXVDZHFBeDNkK3Y5MlhxOGNYZkJDRU9tVG9QeEoxaDZpU2NXdUU1Y2wwU1p6?=
 =?utf-8?B?Zlg4M1ZmVHY5QUpLRUppeFJLbzlsUlJRZndZT1hvQXZ6S1lSL3Rvb2UyTGRs?=
 =?utf-8?B?Z0FsbTUvUVRSallTaHNUUnNwbnRLamlSZ3BrUzhicDBrTXVXWkl1Tk45N3Uy?=
 =?utf-8?Q?Cvk5rd62TTiAMP3ph/gOf0nR99l9/0yRZryFKS5r4uXXK?=
X-MS-Exchange-AntiSpam-MessageData-1: 5K7DcSSygWxxi9x7IEpNC8/aC/C+r18CMck=
X-Exchange-RoutingPolicyChecked:
	dDyoTgDvz3y71WtVNqyME/eQ6cpGDEslR2Xlskf1Ixy0MYFcayHMKsFbX4SLfTTC6y+Kw5uLqv+IJNoZtqvP4xa5Ntu0uQ0fon1yojB8xqWEPz1ghiKOgb+BbAm3FGJKwosAjJhsmiqdhRz+Er5b4XR7SAiWD1okij+CfQXd/2+m92RBPlsr/0o7aDtHneHvMVAFpaVE7iNJ8J5FmrqhCVLElhxzh4cmYpatm/ogffJChFEhiXoGFoNSghghxvi/uPozYmhH/DU1QnDhruic5TAQpLtEV6cFkKNbMmoWmWmTbtfyuI1UZ4QQXxJzUGrJ2d8UO0JULijRObPsgzpD6Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Hxc0Sq00kvaMAqbn/1NCT/JEWShh/2zOcap+e9jeYzeQydSielB/MUVlxFr1/j2+/Yb3Hw8Fz6ZQyqo/oJyGouhkpA7+9v+cARDMt5ceWdCUaZ1+lHi1mKzT/278CLHua23ACAuo7Mzxsva+8B+RixEbbQ6RbTrHLv7LujMGz3T1MWyqC3ugK9m3KwrvP8QGTofF4KWEw1N5x7GxiYO0KV4MGWerCqPl0AMEuBJsGReetFnct4Yi+9LuHFLE9kLBjbnjXqWgajk71AZt2EfxAN41d1i1ctU/ep0zerpGwkGmHznwZf6MKvla4L70AOPjXWmvt3ICMnpyNRP899WeogsShIzvn+zWhG7qOc2VMYGlNNytPUgE+9nzygQBuruXV0/TGcrZTfHarI8bdvWajRna7SIlYnw4+I+WY6F409oF51pn7Dn8ZYM9lMgh+SBExHdYwqSeLMXei0gj+QS7nn4O2mgP/pA/0/wRjeonXzqoZz68Lh24rePXbLrXK440N5TsDzFc6rbpTsqxQnnlKzJlDWhf3yZDlVrucETqG+TSz//8RUodWmB7vuZH116dA5VZdTHR+gNGyb+v3Ik/PZ1ev4/GC1kFTPRHqj/xsZLqsPN0K1x1Yt1r5KXeuT8Q
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6571d2-e566-4fa4-824b-08df03508513
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 09:00:48.8728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LI7x6DueTmKrxfk7yzgY2AZ3gTRcm6LMMenEgKqlfcx8ygW2zDSf+YU08g4OjLqJK7do0soALK7C4GI4QFo3VawZlwLCfCvvmuSBRH4kE24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6586

On 8/26/26 6:27 AM, Dongjiang Zhu wrote:
> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
> index 69d56864d4ba..37ab8b7eee9c 100644
> --- a/fs/btrfs/block-group.h
> +++ b/fs/btrfs/block-group.h
> @@ -80,13 +80,17 @@ enum btrfs_block_group_flags {
>   	BLOCK_GROUP_FLAG_TO_COPY,
>   	BLOCK_GROUP_FLAG_RELOCATING_REPAIR,
>   	BLOCK_GROUP_FLAG_CHUNK_ITEM_INSERTED,
> +	/*
> +	 * Only block groups containing sequential zones can have this bit set;
> +	 * conventional-only block groups never do.
> +	 */

Again this comment does not really serve any purpose.

