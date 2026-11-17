Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794905415;
	b=mesym7bhIgceIlXcbbJZdAWQVYQ9LiwEODNwmaIxHzL9WQQW/sBio7in1maZTCA+JwnY
	 b8DpD/1xyzLAvpcOHzeUKP5GL/Qylk7VnSnz+5yZqp8vxUxhCCH3lNl/MHg6PA5oHVasA
	 teLT8HV/3EsRsTqZD0Z9FibcYSaXUC0UIxn/YYPctsF7DzgwcKUN0rTsJ4w9w5BrRLKnH
	 CSlV/0Sx/rRSooobSQuD5+Pb8CJ3GE7zn53HU3Uq9CVb2oO6Ay9O8KatPRO8HP6NgA6oM
	 xG6DQbcq+y6FkbymBZ9yOU1cQlGmuT6I9qSGXBkEbaTiSRFlfU9/6+NdZamEYtPUp9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905415;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=9ekzxbpW6Pprrdn0FxYrL8hsSHzz/xhmYmqR2w554ag=;
	b=VcnsDT0aQ7gSYoUa/U6ddKhcnWu/3DbyM1mnYURLHq2o6cadSaBIfcNvSbmd6wXlIHZ9
	 c93C79yB8kwiSsbG7ozr7hA/vqzrlbxdmCWpchYn4CmqLdiJK5iVqC8DVWISg852tQwrL
	 EcWmsRZHh1SpdNPpRlqPA99Fbrf8NPU2ue+QjXZ0teyinzIgtWM+GE6PfMlUwOl95QWft
	 WQAjxsA7CEOxsrswpk0DXzqCNYfEXnzszhRbYRbn9eKrXpvlpI3qjfkKO5T/KBUjeB9yf
	 lFZH2z6E240CPTEh4zH/Eo17iCvLrta4sK0ThA43yNLJhT2aeX0LVJb+2UCmTrEXj9A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Y1C3CYOh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=kSTieUGy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5F8606A32C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 08:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D5F8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Y1C3CYOh;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=kSTieUGy
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794905415; x=1826441415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xxxgImzqUOnkKmYeNFSWGZZSmxBAdtrUebmuUruzcBw=;
  b=Y1C3CYOhMOKyM5fjr5ef8W0bm7IqbLPf4Uflp/VtWra2FTLvDblczfrm
   iQXEqemTXQeWcoilKIuJfFtwPFwhMRJ+kYYI+66cRhFoVIZdATRT7wQjZ
   xBFSt3i8Sge3GUovRH5HAA6lgWaq1Kjk1sv6OLNLaqlylX9stP/ZJVeMk
   lWn1u5ZcR+l4vN+ZFHrnT2w7D7vYNsP39YrY7K7gqXHeGFSSlvX49ySMr
   Ctv7V21Do353ZRjbj6ksDZC/aMUzgw2JaFoCFU08smdu3ieH5pmeBwjki
   L9pZip9hnBdYvvywOOzxehM2oyBGBmE5kxXMOSCeBVz41Et6O1sJAEO0m
   Q==;
X-CSE-ConnectionGUID: XefKrgeHSCiRQWNmOCJhLg==
X-CSE-MsgGUID: fpAVa52kQXibLoadPByYQQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161007164"
Received: from mail-eastus2azon11010015.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 16:50:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrfIBVBEgQOQapy2qs94sJPAHqr8f3sRKnFlqXdxLLb74nitygIfLnYBNbkKa9xRm8BdGN40oWq96sYMppvnc7xHSGJsJGx/J7fCzgfbZGqOw6gMaU8ijgGgKebxZG9jPrVkC3GyykA2R4ECvKk9KRl8kNg/PloW+KtrCbEdRUpEACWGicUZUqSCcbznQJYdG8qmo6bHt0f7pVgvY9ONfiXTudRwtDGWw0aokYM4mU8OV9DMUgQnlo+kpMYt2mhecuxKkmbUwxpt4pm9yTG/JX4oWFjQBFLLlh7FQXlOy15A4K1O/19DfZKFvE9LrQFbmLb/d9IIpU6ISNbI1BeTvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ekzxbpW6Pprrdn0FxYrL8hsSHzz/xhmYmqR2w554ag=;
 b=my2bJlZqgoswqh5dH9hIDn4R2NC52prgYrpsEIk3oW1o9cEUYWzBHHw488r3QruIpZzYxvBAQ1OA+ejsoraxmiX3yoNR4XVlMEV+88+aJGgA3MfghLtBnALHKLeouIIonoNDemUDSyxP4ywsJ3HTnALlFqBy7bseuDpWhOfLxY9dnv4e//GUa2tOITMjM41Zn8TdJiX8u7sGbwlTFV11ZRlCoa6R7mV1FZngCd1U853wmBWuF+P7tnmBV3U12eKx1wPLah3aLJztaeLJxJ4CivPnDoXlJtn3NwFHzyR/hRuqAS2DMPFRql0Mh5fWYyuMW37bRa+4XtV/10xCWT06lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ekzxbpW6Pprrdn0FxYrL8hsSHzz/xhmYmqR2w554ag=;
 b=kSTieUGy6ta83W1KhxKMD0/1UfiGAZOBTKZDQC/dezXNqxS0FiRIEBO1PbH8It+EwiUBuIMJ7tqz2HDCSEeuWNkDX/Fs2Nh0lhFacRKSFC+syIgCA0PyoLygfA1srW2PZKG6/BchCsDEmajp86tousrDIZzAsuZ4XcI6zn6gfPw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8145.namprd04.prod.outlook.com (2603:10b6:610:f5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 08:50:12 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 08:50:12 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Mark Korenberg <socketpair@gmail.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 3/4] btrfs-progs: zoned: add btrfs_get_max_active_zones()
Date: Tue, 17 Nov 2026 09:49:46 +0100
Message-ID: <20261117084948.3848762-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
References: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0401.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bac3fce-674e-4af6-4fd8-08df4487caa0
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|10070799003|10067099003|56012099006|11063799006|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 bwictHSQQuWKMcdHGiNkLAMdzwQTggFiQ6/NouwVtH4u0BHH/c5SrrF+e+kCcECG/4g/pmjGmhypQD5G+ryQFDE+yJVVLx+s0BcMsIk6C7YlTkLWjRPOml3PR231LhXUFwTWRvfgsGq3DfIeRxC7vo8XPBVsHxhyqsh4NiMexn54VEJTHjvpntwfj8PFiaMFtbgDcFx+Ml5+RT5vnY0aEqZwdP0391lGhsgY/Qr3uDGKjme1TN6B/RdXFXAL47zlu01oaIPrM5KOKtpwWet7waxYMI7gyOiu+X9RRRu70gLRZIE3G6hq6cJI4lQi3SuaK2DKK1LNpFDQaw8TR3/cUFFNPCkYKdxf2pXfMi1iwLMlzUjwitfSdwsihn53S1H+9fIwplisjRjSCwOwu/0/5w7jNzUD4X7ijuETCNRoKDSOdn5MONW7CCV1caKtgzzp73P+3dJY8Ed2qxfOoPz9ZMBzG4pnRwpzEDaSFmQZZpCh+qubgv7MHDrUOZMVbxVcKjlm3eHgtbDmw9sHZ1J5cnUyzB/9OzKd1NoavKQJqMiXGCneqGmW5jltOB+1ahYscr4GWJnCY8Qy8N/zHzx5TqD8PbsqN6044CFfKCUcE5AulXu/6LTVJ5Or4NTFjIHzQBFuT20LLqn8doWiS/AVjnJ2cfGCJAMXBKTHqbYtySA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?EmJulU4Fc3AJgnfmoCRa/5bwhxkvaAy3M8TBPTrT/z+VP+t5EUscFFZ9sm/9?=
 =?us-ascii?Q?bRNXu0LhZbovPHKOONSa29iWPND4jSMWHAr3FNcs33dq2SVztMWpPuQtVFA3?=
 =?us-ascii?Q?0AAYx0qlrIEGkBaCtGWc2Ye1l0NZM7bbCc/szKj/s/BwlrasB/Kd1h9PbcHn?=
 =?us-ascii?Q?SQ+Xq1vS2g2fJPkWBDnjMPibS/RBcQh6Q6iYSVVPMew+DwK2XifRYoomfE25?=
 =?us-ascii?Q?Lcvb9FoapBz0XMw1IS39lcCDrAf9y8Ka6slM8UIB+8a1RPkN3v4AvSp5i0xv?=
 =?us-ascii?Q?t111sW9M/ep59Hgx6Aj+DdOo7NAefQO00B4pteQA+RRmLMsVxjgMSLbnGTDk?=
 =?us-ascii?Q?561caD1GjGLVYbACtnRWGVs+duXR5clt23nXf0bGKNLgIcVxcnIq0GWUWfCe?=
 =?us-ascii?Q?A0I5i8MPdvAYJhCUZM/sGG/qr+stUXeZ8OFKqvnSbpdVY1LjCATBh8FXjXF1?=
 =?us-ascii?Q?aQfshLeNdejqiTcSxM/bruoN6EqNQwy/DnH10PgjaCBWxqo2a6+V9m+omJjh?=
 =?us-ascii?Q?R/OexqOXse/JX6/a2gkwe6tfZiXEJmQrt7o2oxR3PzD/HnWM9W3YTkf6siAl?=
 =?us-ascii?Q?bTiXwe26hPzADWaWOax5ovNTGEZBitQADeXNA6rHdoAh4+hw/+6o99SK8fe0?=
 =?us-ascii?Q?ZnCPqqCNll0wSi5XJ6iBizA7QuFB/OwtLgCYOTU/fYXM51FMueA8TyYseGQ2?=
 =?us-ascii?Q?4f/7/JLCDbdakIBeNKHKYOz8kzriNCvwgftajRm/494izorrsPiw//Vz3S7C?=
 =?us-ascii?Q?rMlpgy4KIjhxdAWbpWAOoHfK0N/TCTMKUDwXqOhjjl4+bZYIpKGOtv/TGyf5?=
 =?us-ascii?Q?xVlMSwhpU48Axw/pT8sB5tAJ84PkmqByONjoLPhA6XbHP4G7Ys0QUYpz7ItP?=
 =?us-ascii?Q?SdDie+dkQaHwYS0O0iMze0c1S7ktNjQu4z5OkquLRTkL6bL24fhS84+MSCIm?=
 =?us-ascii?Q?bJFTKZto+4TN6cn3t314UCa/fIndZpVlOMq5pJ21WvKyMlCMZEfBntldZZlW?=
 =?us-ascii?Q?Vg2ZuuSmvXm3af4CPoeXqzdhLHNCZ2vANbtO9ux8EmNVlP0Ul4GJ5RAO023o?=
 =?us-ascii?Q?iLBiDGN46GFSfdjKnJGXZeTpL3by68EQ3pTiWIN+av5l3s43HLJYDV+0ivQV?=
 =?us-ascii?Q?UpCdcz5jDo9gfmuCgpZVio2s0tZgGbaI7Va0qxZuabpU2lokL7YBxO5TeBN4?=
 =?us-ascii?Q?sFYuE05hNAo+xTAGbU7bfUiDSjN8CnnTh90z5fXvrOMdRiUswWTcASrAyaL/?=
 =?us-ascii?Q?f1e0nxK7PztBguLYczw7U3tYvt2BK+5Qe382WKz65gZ2sSLC5OBfpBtnCiyQ?=
 =?us-ascii?Q?lJ5AuU8NVOn1smElKyGnW3EAhYiroXxa8YY3uOX9MA6iDFnyvnMvaxRwSzDx?=
 =?us-ascii?Q?AYynXXwrWn8Xp+gR7xEyCZiMimYhanHJDFg3j/RYnc4P7cgNsokLWPINdF9Y?=
 =?us-ascii?Q?Io/PywgtF3ONzMGHJCv1V4g5sEnLhThQhLsDjg4NSCov6zkRU9T/pTzYKkYL?=
 =?us-ascii?Q?/dCfbXvvg+LVjcDXnkiyFIoxHFcolQfAXZVuffThh7+ou17BDfB1tKkNILXU?=
 =?us-ascii?Q?QhCg0qb/uzLTxeXNTH0uVDR1SEtmdwUPVF+rWfVrUV//w1EG8SqejeYs53Dw?=
 =?us-ascii?Q?VbCE34nLlbhqRE9IIkaiXO5gell5oVKtQyaOEYhdgGEM3sKBSTzDEn/Dp4Ox?=
 =?us-ascii?Q?KmFrDqvqWBZ7D+2NMSoTz8ZE2DinH0YOyKkT78ul4wIAAmqEsHm8gHIUw0Cy?=
 =?us-ascii?Q?myjz9jiohXrz2A7Y88jEECZ0l+tYknhAMNna6YWlElJh1dIDsYdo+6lFdNUc?=
X-MS-Exchange-AntiSpam-MessageData-1: 2wwxIeqqEzRp8HJdLh3R3IuM1VJwA/JNSdY=
X-Exchange-RoutingPolicyChecked:
	vgW5/sk0OZs/GdpIa3nPfWJu2B2+LfoM9Ga79cDF4Vt+nJIkJXlgeuL7UhsuVnPtHYja6PjXKOnJiT3cn5k5NKhSrOj0faFabPzc7XgFXH9svhKRV4+IijAjlz2/MDJ1FnCDOm15JHJCwmW5jPGcRsm4FadLUZjWBeVyE0Owm3Ai47uEOXu3fQjNDv0cHL3M1zv2hxB0DF5OjcR517aNbAF0gLAzrcWHPOmo3KD6DZ1lIqyCVHMRk6QI+HK/IFSu6uMaRsxBrB6QuWrQ9hRFWl3hbQ7ymwr8LSBkucYMkuzv1xOrayl5qIXuu2Wd+uOAbVVLT3yUMBjEc+wo6lcj4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xkM7bJKZkJNzWzCgqKImdhPquZhQ7uLwZWLNcSEfiGRXJC+IOanGFxfjnEg1yiXtXXyma3bv7J5QL0WXlzxzBFJ1g3ZBGuGwFkJ/WfYPUu8mrfeMdT++64cGgrQ4i3sr3GyoyztDI59akkTrdsiqABum5wWSZ/CPW0oxhr0VZCWJgQUr6Bhwzkw2Y7cPEjlLghW9VpXg1qq5F1IcBy0bgITbJUrN4HBOsktin79NYamrqhh3VsBhY9GQO/4pNMc8JA+DSBCRscEadU/DmqkVE2GgBUM3fTkpRM9SQJMI1tVlhyyqOUfMH+I7aDXBO60Qo3auiAQZy31tHqeU8AImfEXmzXjsiTskK01hZeiNnJro9bbaAI4dbtqVCLgBAf2kaXSusvUCA+a8V7qnZmjpUomXJLtgkOV0Y+ScYGf3guIUzvTB9+kiQ7HoxttXOXtu+De9DAlvEy6PG8v57wPgznmUVR7HkKiDo+fjt2w68uLReK86ukUZDLyt/epxDMnsPZLHO69v2rmWJLACdOCUnBqkMnarN+FXOhu7oKnhLl/b2wncQzDgJBzLRWhSHAuYoCVhusNs2zyUmK+GfvM+2mAfP+zj8T2LJz+1H84DGBEYa8Cav2v60KXhGNqN5AUl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bac3fce-674e-4af6-4fd8-08df4487caa0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 08:50:12.1596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVgyVk6TDMXSHsFEsLR4U5dM6qn91QPc3vmv9UaLlSoBwyvg/2LeOjaOZE7KM+kkpoCMdm4HfEE050JZR0k1IVMsbV5TglFSNA7O3WO0saE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8145

Return the active zone limit the kernel uses for a device, the same as
btrfs_get_max_active_zones() there: the smaller non-zero of
max_active_zones and max_open_zones, a default otherwise, at least
BTRFS_MIN_ACTIVE_ZONES.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 23 +++++++++++++++++++++++
 kernel-shared/zoned.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index 48313ccc..89ba544a 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -67,6 +67,7 @@ static u64 emulated_zone_size = DEFAULT_EMULATED_ZONE_SIZE;
  * - 1 zone for relocation
  */
 #define BTRFS_MIN_ACTIVE_ZONES		(BTRFS_SUPER_MIRROR_MAX + 5)
+#define BTRFS_DEFAULT_MAX_ACTIVE_ZONES	128
 
 static int btrfs_get_dev_zone_info(struct btrfs_device *device);
 
@@ -155,6 +156,28 @@ static unsigned int max_active_zone_count(const char *file)
 	return strtoul((const char *)buf, NULL, 10);
 }
 
+/*
+ * Same limit as btrfs_get_max_active_zones() in the kernel. Unlike the kernel
+ * this returns it instead of setting zone_info->max_active_zones, which stays
+ * the device's max_active_zones in progs.
+ */
+unsigned int btrfs_get_max_active_zones(struct btrfs_device *device)
+{
+	unsigned int max_active_zones = max_active_zone_count(device->name);
+	unsigned int max_open_zones = 0;
+	char buf[32];
+
+	if (device_get_queue_param(device->name, "max_open_zones", buf, sizeof(buf)) > 0)
+		max_open_zones = strtoul(buf, NULL, 10);
+	if (!max_active_zones || (max_open_zones && max_open_zones < max_active_zones))
+		max_active_zones = max_open_zones;
+	if (max_active_zones == 0)
+		max_active_zones = min_t(u32, device->zone_info->nr_zones / 4,
+					 BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
+
+	return max_t(unsigned int, max_active_zones, BTRFS_MIN_ACTIVE_ZONES);
+}
+
 #ifdef BTRFS_ZONED
 /*
  * Emulate blkdev_report_zones() for a non-zoned device. It slices up the block
diff --git a/kernel-shared/zoned.h b/kernel-shared/zoned.h
index 363ef4a7..e323baf1 100644
--- a/kernel-shared/zoned.h
+++ b/kernel-shared/zoned.h
@@ -99,6 +99,7 @@ static inline void btrfs_free_zoned_device_info(struct btrfs_zoned_device_info *
 }
 
 int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
+unsigned int btrfs_get_max_active_zones(struct btrfs_device *device);
 int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
 
 #ifdef BTRFS_ZONED
-- 
2.56.1

