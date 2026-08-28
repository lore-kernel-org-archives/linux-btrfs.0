Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550482ECD35
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 05:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895816; cv=fail; b=StvUxfjCVmsKFSEb9nWAeNM7bgI9QsdneW4dKbmZ6oT8GBRuQeSx5s2U9LHWYeAmMc3p85PfyzR7SoXUl+RRm47JF2QRxCmQy33Q+y3ReGCNrVJekY3s7w0fhvuB0uyoUkCUXXy7WV9qQGxlrNH0KdoQbTPXR5+jg637pdmegAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895816; c=relaxed/simple;
	bh=Ygqga1yfJTOeBBP3LJvUk+fNdumhIlCVX0COhLd3pcI=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=WJvFUwyNBabwgV+2cqu3TcMgJjYJUHf+vRjvhTJ0+kzwiuOgyZNbkH8fG0e7oyBa7zeSIwfhZ2tHd0kXjFMcEHPu6TKZ150ur5uZl4W8nSTrz1cSZnq8GPsWftj9NTOTKa7leW4peAkZk9b9013ZDkYOvboCWU3C0p47fHTUKe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kbQGC8ro; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RJQwakNp; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kbQGC8ro";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RJQwakNp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787895814; x=1819431814;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=Ygqga1yfJTOeBBP3LJvUk+fNdumhIlCVX0COhLd3pcI=;
  b=kbQGC8roRcHMXp2GhQw8PHqXHPOLNlU/kgGpZ/e9NyI1L5287kW4uBWk
   ldeN+g7ZN8OJQ0tsMPqaDiWKPXYl9dZGniY+MRBoHHMc9f6H09ZRv3dRq
   C/b9808IC0Upclc0FYipEHhiT/vm6Fx45IYpCuvFHWR2ELrVtO+J7FfqL
   t9i93N2M1g0KP139YpqJpOl2Aooo4fZY+I2GWonCoLcC+YLASYOnON8/9
   9D5GdAUf1gN2elrFKkWJzhl70JzkPK8qcwyin80kVwldE4fTOf20q7gS2
   Ka73zr5qiBsYWUVxYae7ERpu6t3Rzaul59wDbOETwk0m9TwQEW0k+qJue
   Q==;
X-CSE-ConnectionGUID: PjJtLqfXTViw50l2c248PA==
X-CSE-MsgGUID: ZIxIAM1xQE2dl8yAJzan/A==
X-IronPort-AV: E=Sophos;i="6.25,248,1779120000"; 
   d="scan'208";a="153482275"
Received: from mail-southcentralusazon11013027.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Aug 2026 13:43:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9eHLY6LPGROOMHus8qAmHpxReyGIZpuQZJAoWsawh7a4Qyr7LqeYLDHRauMQAYvJgWO4kxuucET5w8qrEi1YtDGLioUPubfjvNuRDKx/Qaedb7ObmjCtCZ/Hosx1IJRN6JRxflefuGlFGVK11NDQCl8IX412GsjeKp4BpQi/sDWyQB0szD9AIRbu4/CmsEuEBI5NM9mPaeip90rltGjvb3zpQcKDCH7AwQC+Sy9XU1h53MA1LnKdkgVudR9WJeNch4W15ZKLva3xjldFaasrx3n5U4GRM2QikzfkEsULnEB6e/ahAvTSzNSoaKtD8cksURKMPLFE0I5xwFYIM4ing==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtvAp77Jvx6QhNHHlL3BVFAoV3vfdExJKJnBol/fgLA=;
 b=CWaogfalAYiwFEXGhUCR5pfZ2STm06pdqVvnRHC/FUxBjXMSmSMM9gVYCy+/Gj7dHkdnOuSKqB3gvD81bbLEn2gwspr1a5HcFMo3l3IoE1nHTObenFLEoSMa/+diZp4UwPowktOtNAzFzv9wKwINYuVeLIRcpcEqCqUQPgsF4ddNpYHA+YyrVbpJvG1nvJo71IJn5IQ6uvxROyDRCuESOManVG+yA+oTOPKQsqVjBIPKrwhOg5W1j9OhR48adyxqezXvxYhQlOBPrzlrjObe7xqIMdowayVZ48nm5MVtcwPedb1sZQJ25iAimG1t5jwjyCt4HZHw2fbHklI4Ml00OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtvAp77Jvx6QhNHHlL3BVFAoV3vfdExJKJnBol/fgLA=;
 b=RJQwakNpqMutdPa3tDQcXnqDZXNk+dUVFENmKQmSS5CMvcZu4OeJpLmdVYUmlRsCbRE0iAvssXDEGaiqZUz64ehmop+b7tGLPlRi7FkTs6YFbuBnkWLQW1uG49BHHhIiylP0bl6UPBkSGiCktc9bo1CHOBWRjBdrQwdUbGZd06g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by LV1PR04MB993596.namprd04.prod.outlook.com (2603:10b6:408:3f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 05:43:32 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 05:43:32 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 28 Aug 2026 14:43:28 +0900
Message-Id: <DL0C63K7IW67.257PVUA638Z6E@wdc.com>
Subject: Re: [PATCH v3 2/4] btrfs: zoned: recover active non-data block
 group roles on mount
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Dongjiang Zhu" <zhudongjiang@fygo.io>, <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <cover.1787887776.git.zhudongjiang@fygo.io>
 <65f5e1ca743e6c224009c4fe639945ee6c851d0c.1787887776.git.zhudongjiang@fygo.io>
In-Reply-To: <65f5e1ca743e6c224009c4fe639945ee6c851d0c.1787887776.git.zhudongjiang@fygo.io>
X-ClientProxiedBy: TYCP286CA0333.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:38e::19) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|LV1PR04MB993596:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a15595-87d5-45ac-440a-08df04c74b75
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|1800799024|10070799003|366016|6133799003|3023799007|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RYBeR1cchZ51VJ5BMjtjOZz1nXtHAOoxvoGSgrcDoxWyv+15kT7WXH5LeRm57UX3H3OntgfQzMbQ0zr06Z0qsYWlRDl09PsyHUEU1KyfzbM0mJ2UlYuG7ZFOBM5oV24W7vMIDxK+I6Y3DlHkSQUJajP4W+UcM5HqPf/UNRbTxcX2EFiDjE5j5WJ83+ooi8bSFAlYUBsAsxFnmy/1iOfu3xZpYvvnO4XHKKkcliYLv6iCigaLYwtDkpsxIZTglERsNMEnFKd8V7fqOAK+Pp36+zkN80KT+K+LipXxxX+Yw5sxucTJAHsdqRxZI6nb7iX8INLE3K5x6t7hzDK/zn2entLY3d9d7SVJL5eA5kMOmY3QVBzEfP2a9PgufN9C1QXx4D1Gleo0I/+yYPvyWiIqbnZRYdtFUYeTGS0nQQ9WB5KPopXfRvJOdpqxaYK3AgZQamg4ttU+gyZMXcexQQFvXra3b2ruo0aGNBUFVSKwNs7u9FE9UZDM5AUYYuWAmSUzqh3ti4w6YO1LPtBzLxtSFaqkGUqNej6pu+SrzOc5hDwViy5uYp1ysPp9X1jPKF2HM9OiE2qF+zuMuwogx0TdKIuFRIpv77rG0GYLzi5Y4ewQ3Am6rqcEOHvwP2UmJp4u61dIVjo7pw+97xd1M/G9nAokJXJHL0K6ZFKprnPZoio=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(3023799007)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3pCbUVRRVFzL3dXQzh6VXg5TXNVRE1FanJsSklqM0JDSEdPUWVNREwvZURE?=
 =?utf-8?B?SEFkNlhjV1NvMmQ4Q21PNGNmREJFMkVPdHp1bEtKWWNUaUIrR20wZ015Wmpk?=
 =?utf-8?B?c2NLa0tueGdBZTRyeVpHVWd0bld4VkFZNHFIWUxDMjM2eXNXSlEwL1FnQlRC?=
 =?utf-8?B?bjJocnEwZGRiZTFVZ1o1Q2hjd2h6R3dPaXEzbzRBQmo0eUR0T0RsakNIRnhm?=
 =?utf-8?B?dENjTWVyK1VKS21wVk9xUjZXR0MzY0I3eXZDb3FtU0trUHF0QjdWVTk3K2hV?=
 =?utf-8?B?ZGdjcU0ySXdGcmpzQmp1YjBDbjNBaG5yVERpWlpkQkVWaUIrVytNbkRSWmhU?=
 =?utf-8?B?RTR5TGpRYXdLb2wzL3llWnFTa252N1FjVUkxSHQ5dUU0U25JbVc3RXhwQjVV?=
 =?utf-8?B?ZUNWTGNLWllLVTR5Sk56bGZva1BDeW1wZDQyWlkvcU5makNYUkRhREJsS0c0?=
 =?utf-8?B?WnNwZVJJTlpMLytnTkJJTE9yQ0Znelp4cUh5R2xjWVpJK3hBdlYzMGFkVWN6?=
 =?utf-8?B?WUF6Y3JxRGdOYXdEeXQvVTBDQ0xDWnFjWXJhZS8vRFMvczlMNjlSaWx6K3Bs?=
 =?utf-8?B?MWJ6M3RPTWZiUHRzNXRiVnJpVDQ1Y3JEVy9jdFNhc1VDRHo3VDIxQVV2SGF1?=
 =?utf-8?B?RFdyWDUvOFFsS3lJejZzVWRwMGtMZHlqMVFoTjRFNlZ6Z0dDZHBwenhQSWRG?=
 =?utf-8?B?N2tvRkRwQTRGdGhQcHpUUU5rdFFnclhVL2xyOGw0MUFVWTIyOUlsZzkwZ1Ra?=
 =?utf-8?B?MHc4UG53TlU4NGNINnpvOXZ4bkQyOW5vU0lkZGkxRnFaWkY0SHN5V2F2N3dh?=
 =?utf-8?B?ZXc1aHRDQ2tyYWgyTnNnY004NnRNcncxdytmT0JFNWFVK2c5WHpsUHY3NXg1?=
 =?utf-8?B?QlZqQjUzTWRsNGZqZjBsOGpTTUxjclJ3V0p1VmJxNGtkU2FBNjVhcEhMM3R6?=
 =?utf-8?B?NVFWakNqblVMeVBnZ0hmK21OV0JPVGhLQUpzK3A5YjdzM1orY0ZpdzN3c0Vh?=
 =?utf-8?B?Y1dGSGVjWWpVbVBHWG9uQXJ1aEVXTFYzejhRdkYyeXFpNDQxTDJTVHYvNUY5?=
 =?utf-8?B?b1RqdzF6R3Jodkpzdkk2SmltdHdYekozVU5rQm5ZZ2F0VjJSMkNOZEFaT3R5?=
 =?utf-8?B?N1d0Z3lKVHJoc1BZUXZjZmRYb3NwNnpMN2w5K0FMUU5oak5jKzFLVUp0Zk1J?=
 =?utf-8?B?NVRHN3hXK1JnbnFpalNGYlBuR3FkaXB5b2cvZzlwUEJsa3d4TE9MeEN2bVFQ?=
 =?utf-8?B?U1RjbzIrbTY3QUI4ME0yNFdCd2FIcm53RmlpdzIyOHhXZWd3UGlqYmk3QnpY?=
 =?utf-8?B?QjNYNnRlVlY0eG5QcFR2RHh6MmEyZi92YkJhRG5SMEZBZWhqL0V3SENKUWlF?=
 =?utf-8?B?ZUZDeEtQTy9EcHk4SWNkUXJoa0VPVlp6YWNZN25reEJNWG5xcFBodC82Yll6?=
 =?utf-8?B?ZUs4MFhvNHF1Vm5aSDZnVFVyQ2J0ZlBYMGliWW1NZ3FidXordm1qZ05nRHBQ?=
 =?utf-8?B?OUVkRldjOXg2MlY4QlpOYXc3RU9vaCtaS0RtSUM2STJnblkvTUg4LzkxaStx?=
 =?utf-8?B?S2JRVGlOeTduVnR3UUY5bUhtcWpSU0dGMk1hSXZlZFpId0xvMVVYMGF1OUth?=
 =?utf-8?B?eUNQYktEVGlZcUpGbnc1ZW5xWXJhWHJzOWlFb2QvMFYwdjlmOHMySjEwNWtH?=
 =?utf-8?B?ZVZXdTJ4OFVIUmNucmVFZ0ZNeVdGamRGSTdVNzFEdXZTTXdkcEtzREc1eS9W?=
 =?utf-8?B?YVBYeW1PSVdEaDI4UTI1SWYzUDZtQjhwLzVuRWJrRHdrOHl1Z09PV3F5UUZI?=
 =?utf-8?B?UWp4dHFHOEdreG5jV0xrNUdxVEp2Q1A3SWVWUDl4VDZocWgxZE50VEJpWDJk?=
 =?utf-8?B?TkM0bnpZQnZ1VWpINUt5d1NaalR1Ym52cGIvQVh1WXRrekZST05jSmlxQjBr?=
 =?utf-8?B?cTRQcjBJVzhLOWJtTVRzNFFQV29IeGZyNkRMR2RXS3poT01NeDI4RkRmZVVP?=
 =?utf-8?B?OUdZY3Rta2Qwc25DTjdGME5hYUhvZ1plSDBsL3dEU1ROaFNqUDRnUElhbzhG?=
 =?utf-8?B?NHB0K3hmZFFPdDJmVm1KVjkrcFpORktwQjZXOUlGdHBHdUhRVnJYbXNZZDFL?=
 =?utf-8?B?UEhiNE1FSXBzMUZpQ1QvSC9HbkxFS1ZOWFhteUh3SFViWGJMRVZVN2wwMmNu?=
 =?utf-8?B?QUJ4cGYrUUpWaE96TGo1TjhTUkVtR1AwcXErdzBOc3NwNmhtNnZIdUZCb0Zp?=
 =?utf-8?B?dzBZSWZvQ0s2ZVdyR1FEME5GczlIMGQ3MkNrM1JSTkN2dlZJMlZLcTNuNWQ2?=
 =?utf-8?B?SGFkQVBiR2xXYkJyaE1QYk9TOVNpKzU1cDVLSGpJS3lPVXZiTlRwWVRuNDJ3?=
 =?utf-8?Q?Aiv6JDb6wEhas51mXa2r5dLehCRk7e4A+71y2nk99d93J?=
X-MS-Exchange-AntiSpam-MessageData-1: mQtjsVdrm9hUlA==
X-Exchange-RoutingPolicyChecked:
	qNmR0DsRXsBFr+zRNqk5LyOg7WjQWLd+OZNIj5LcgoA4VaOBBBsLqL/X0O12qxskdobG/ckTT1CN93RCPqcm2yAgkPR99ayOUbBEgsYvHAhTFsOHAZujKZhDISLlHGu4Pq6MDjygxe7kVtV3v/BGWwkl5Gqi3vDJEQ5uYSx+iomLalHukUIp7cNDq5/YCfw4w3B6rDLszcqLihpCYZFHhz77+iavv3ir4VIAAeuzJ55X5DMbhlldxBKplTsG5JyvcCh393UQcfZnvEwAh8bh5ydwGR74OMES2Q1JCUVdG7Xts8XIpQjN9dmyD0NHD5W+HG3EQYLiRcHZqtUH4kBRDQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1u5WNK5OX1uIrmZKsU2A95pLDRfcChfjwrrDdzdEIm+SubNjRLa6zqovXcNxqFb7k0AkAH70D0vg8OyYZ5xAl0+dlWQWsYUfy4l/0OT5ACKRLasfkdYBRHrqwrWxhfwqmx8U+zQq1AZTobvf9+aUmY5sOM6S/BsZU/AyxLV0YZ1q3dlrsl4GgG9KePb0MvTL/j5xzROx9NAOPH1YXv1YyPHvOz1SxKnUMd86Gk8lxU+C6TT85ZabysC1wv5JlqTluOmI61/XnuW1kSPE8/UQgY/ORADKgx8a55/TUGnLkEA7vzCb094i4lwrSTALF7UrqEKa6NwlWGB62b0I/kHKCgvMJKlWv0mOFoH7p5tZHDut2hhofFc8yYnP09pe1lMV0pLT5F/evhNMf3YspKFY8BYRkg/+R694Zh0ZyLFRa2fAiujmvyunoqb9wS3Ktw/UN9BPPlwYgeK5U0p+1tKkQu2bZpdPlEg6IWqrPw1ryyT9yaF7aeUoc+xU+IixniCV9HxeSu1KiVN0Z1K094MI9eVivOd9JnR2ZfmS8BCIwzxZMys7Ou/VT3WtvJdoCW/I5+Se+j/9B32ekBU3P+OGRc8tPPEPABak+UTEODM0Yxd+9qZRqin9yEBKkQCd82Nv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a15595-87d5-45ac-440a-08df04c74b75
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 05:43:32.1662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPK0IBZtcpRuzfm2wvvgSJLIBdbD6QjnxajmDFzzzX1Oggd8lZGL+spkWTGKi+UoMkiCkR+6bMY22K90dyEbqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR04MB993596

On Fri Aug 28, 2026 at 12:51 PM JST, Dongjiang Zhu wrote:
> After a remount, a later write can activate a new metadata or system
> block group without finishing the recovered one.  Repeating this across
> remounts consumes additional active-zone slots and reservations, and can
> eventually exhaust all active-zone slots.
>
> Once no slot is available, activation of a metadata or system block group
> fails.  During synchronous transaction writeback this propagates as
> -EAGAIN, aborting the transaction and forcing the filesystem read-only.
>
> A remount/fsync/remount reproducer on an HC620 left two partially used
> sequential metadata block groups active while active_meta_bg remained
> NULL:
>
>   bg=3D343865819136 alloc=3D176095232 cap=3D268435456
>   bg=3D344402690048 alloc=3D3260416   cap=3D268435456

Please show the reproducer.

>
> active_meta_bg and active_system_bg assign active block groups to the
> normal metadata and system write roles.  These runtime-only pointers are
> reset to NULL on every mount.
>
> Mount reconstructs partially used sequential block groups in
> zone_active_bgs and adjusts their reservations, but does not recover the
> role assignments.
>
> The write-time pivot can finish the previous block group only when the
> corresponding role pointer is set.  If it is NULL, activation proceeds
> without releasing an already active block group of the same role.

True. But, it is set to the written block group if e.g, active_meta_bg
=3D=3D NULL. Given that metadata is properly written to partially used bloc=
k
group, isn't it no problem with that? Apparently, this write-time
setting can be considered as the role recovery.

If it is writing into another block group leaving partially used one
intact, then that is an issue on metadata allocation.=20

>
> Restore the role assignments by selecting one active block group for the
> normal metadata role and one for the system role from zone_active_bgs.
> For each role, keep the block group with the largest writable tail and
> finish the others.
>
> The tree-log block group role is runtime-only and cannot be recovered
> after a remount.  Use the selected metadata block group for the normal
> metadata role and leave one metadata reservation for a new tree-log block
> group.
>
> Run the recovery on every mount.  ZONE_FINISH preserves existing extents
> but abandons the unused tail, so account that tail as zone unusable
> immediately.
>
> Assisted-by: LLM
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
> ---
>  fs/btrfs/disk-io.c |  7 +++-
>  fs/btrfs/zoned.c   | 97 ++++++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/zoned.h   |  7 +++-
>  3 files changed, 101 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e6bbb0b1b38c..cd1f46ec62f0 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3713,7 +3713,12 @@ int __cold open_ctree(struct super_block *sb, stru=
ct btrfs_fs_devices *fs_device
> =20
>  	btrfs_free_zone_cache(fs_info);
> =20
> -	btrfs_check_active_zone_reservation(fs_info);
> +	ret =3D btrfs_restore_active_nondata_bgs(fs_info);
> +	if (ret) {
> +		btrfs_err(fs_info, "failed to restore active non-data block groups: %p=
e",
> +			  ERR_PTR(ret));
> +		goto fail_sysfs;
> +	}
> =20
>  	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
>  	    !btrfs_check_rw_degradable(fs_info, NULL)) {
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 0d964ada3ad4..ee7d518bec15 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -3056,22 +3056,77 @@ int btrfs_zoned_activate_one_bg(struct btrfs_spac=
e_info *space_info, bool do_fin
>  	return 0;
>  }
> =20
> +static int finish_extra_active_nondata_bgs(struct btrfs_fs_info *fs_info=
)
> +{
> +	struct btrfs_block_group *block_group;
> +	struct btrfs_block_group *next;
> +	u64 tail_unusable;
> +	int ret;
> +
> +	list_for_each_entry_safe(block_group, next, &fs_info->zone_active_bgs,
> +				 active_bg_list) {
> +		if (!(block_group->flags &
> +		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
> +			continue;
> +
> +		if (block_group =3D=3D fs_info->active_meta_bg ||
> +		    block_group =3D=3D fs_info->active_system_bg)
> +			continue;
> +
> +		btrfs_get_block_group(block_group);

Why do we need to do this?

> +		spin_lock(&block_group->lock);
> +		tail_unusable =3D block_group->zone_capacity - block_group->alloc_offs=
et;
> +		spin_unlock(&block_group->lock);
> +
> +		ret =3D do_zone_finish(block_group, true);
> +		if (!ret) {
> +			struct btrfs_space_info *space_info =3D block_group->space_info;
> +
> +			/* Account for the unused tail abandoned by ZONE_FINISH. */
> +			spin_lock(&space_info->lock);
> +			spin_lock(&block_group->lock);
> +			block_group->zone_unusable +=3D tail_unusable;
> +			btrfs_space_info_update_bytes_zone_unusable(space_info,
> +								    tail_unusable);
> +			spin_unlock(&block_group->lock);
> +			spin_unlock(&space_info->lock);
> +		}

So, basically, do_zone_finish() should have handled this...

> +		btrfs_put_block_group(block_group);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
> - * Reserve zones for one metadata block group, one tree-log block group,=
 and one
> - * system block group.
> + * Restore one active block group for normal metadata and system writes.
> + *
> + * The tree-log block group identity is not persisted, so recovered acti=
ve
> + * metadata block groups cannot be distinguished by their previous role.=
 Keep
> + * one for the normal metadata role and leave one reservation for a new
> + * tree-log block group.
> + *
> + * Older kernels rebuilt zone_active_bgs at mount without recovering the=
 role
> + * assignments, which could result in multiple active metadata or system=
 block
> + * groups. Finish all but the selected block group for each role.
>   */
> -void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
> +int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info)
>  {
>  	struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
>  	struct btrfs_block_group *block_group;
> +	struct btrfs_block_group *active_meta_bg =3D NULL;
> +	struct btrfs_block_group *active_system_bg =3D NULL;
>  	struct btrfs_device *device;
> +	u64 active_meta_avail =3D 0;
> +	u64 active_system_avail =3D 0;
>  	/* Reserve zones for normal SINGLE metadata and tree-log block group. *=
/
>  	unsigned int metadata_reserve =3D 2;
>  	/* Reserve a zone for SINGLE system block group. */
>  	unsigned int system_reserve =3D 1;
> =20
>  	if (!test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags))
> -		return;
> +		return 0;
> =20
>  	/*
>  	 * This function is called from the mount context. So, there is no
> @@ -3093,14 +3148,38 @@ void btrfs_check_active_zone_reservation(struct b=
trfs_fs_info *fs_info)
>  	}
>  	mutex_unlock(&fs_devices->device_list_mutex);
> =20
> -	/* Release reservation for currently active block groups. */
> +	/*
> +	 * Account all active non-data block groups before selecting one for ea=
ch role.
> +	 * Finishing the extra block groups releases their reservations again.
> +	 */
>  	spin_lock(&fs_info->zone_active_bgs_lock);
>  	list_for_each_entry(block_group, &fs_info->zone_active_bgs, active_bg_l=
ist) {
>  		struct btrfs_chunk_map *map =3D block_group->physical_map;
> +		struct btrfs_block_group **active_bg;
> +		u64 *active_avail;
> +		u64 avail;
> =20
> -		if (!(block_group->flags &
> -		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
> +		if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
> +			active_bg =3D &active_meta_bg;
> +			active_avail =3D &active_meta_avail;
> +		} else if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
> +			active_bg =3D &active_system_bg;
> +			active_avail =3D &active_system_avail;
> +		} else {
>  			continue;
> +		}
> +
> +		spin_lock(&block_group->lock);
> +		avail =3D block_group->zone_capacity - block_group->alloc_offset;
> +		spin_unlock(&block_group->lock);
> +
> +		if (!*active_bg || avail > *active_avail) {
> +			if (*active_bg)
> +				btrfs_put_block_group(*active_bg);
> +			*active_bg =3D block_group;
> +			*active_avail =3D avail;
> +			btrfs_get_block_group(*active_bg);
> +		}
> =20
>  		for (int i =3D 0; i < map->num_stripes; i++) {
>  			struct btrfs_device *device =3D map->stripes[i].dev;
> @@ -3115,7 +3194,11 @@ void btrfs_check_active_zone_reservation(struct bt=
rfs_fs_info *fs_info)
>  			device->zone_info->reserved_active_zones--;
>  		}
>  	}
> +	fs_info->active_meta_bg =3D active_meta_bg;
> +	fs_info->active_system_bg =3D active_system_bg;
>  	spin_unlock(&fs_info->zone_active_bgs_lock);
> +
> +	return finish_extra_active_nondata_bgs(fs_info);
>  }
> =20
>  /*
> diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
> index 8e21a836f858..934a9368ed15 100644
> --- a/fs/btrfs/zoned.h
> +++ b/fs/btrfs/zoned.h
> @@ -95,7 +95,7 @@ void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_=
info *fs_info, u64 logica
>  				       u64 length);
>  int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
>  int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, boo=
l do_finish);
> -void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
> +int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info);
>  int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info,=
 u64 num_bytes);
>  void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_fi=
le *seq);
> =20
> @@ -279,7 +279,10 @@ static inline int btrfs_zoned_activate_one_bg(struct=
 btrfs_space_info *space_inf
>  	return 0;
>  }
> =20
> -static inline void btrfs_check_active_zone_reservation(struct btrfs_fs_i=
nfo *fs_info) { }
> +static inline int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info =
*fs_info)
> +{
> +	return 0;
> +}
> =20
>  static inline int btrfs_reset_unused_block_groups(struct btrfs_space_inf=
o *space_info,
>  						  u64 num_bytes)

