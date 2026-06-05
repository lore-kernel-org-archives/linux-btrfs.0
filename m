Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7924837EFFD;
	Fri,  5 Jun 2026 02:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780626180; cv=fail; b=T2V+kqCu8loQoBoGvd4UEh3Dw/tKYkz0XnQmB6J371C0KFB5yp8pTlypu2mrmKXh05m4jmD/WZBOvJ8K+iGGo79Nx/6mKea3MLkE1QGYW3kUakFAp6uW3l8UYAaWbYYTetIrCXyCTVTIafusjTroEHcw5EX3j8WFrEbaU+cT/do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780626180; c=relaxed/simple;
	bh=HJzXVxNcC5U9BaPtkNAcqVG0fu0AGKXsFKFn85AqwIw=;
	h=Content-Type:Date:Message-Id:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=uYq10IAg8bN7IQkQucar2DcYpIIW+u/59vgRSU6roeqTYEJ5A3SVnqt2ZwjQI7nkb52u+UouyLEHCI7JkHkgVEuBmYOXf8FQgfxsLcrluCeuKyc52tvebLmJGL9bsoI6T8PbOPM6xOHqzr2jkAvw5bTJTAc35z91cW9aD35UVVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DfJbm8tg; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=L6s87P6y; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DfJbm8tg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="L6s87P6y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1780626173; x=1812162173;
  h=content-transfer-encoding:date:message-id:subject:from:
   to:references:in-reply-to:mime-version;
  bh=HJzXVxNcC5U9BaPtkNAcqVG0fu0AGKXsFKFn85AqwIw=;
  b=DfJbm8tgH37dqN1QDRbu7Qwc2w3ORSaiwKw7P+zb431AZMDO9h5XW+b/
   O6FhTUYnIGd+ZoAlmLze8uP+lK1FznProeRfTNDH2UO0GSAIstW3j77aJ
   X8cBsu4nwabdB0fUin1UhIONvRu0TwTUnVSXyj+wWWphI07XYQUbBdntp
   rtNo7C0Ey0HGigCMon5l2rQbjfs0CBe8TN9x3f+k2uwlH5Zivw2D0Oxsh
   kZ37UUW0xfcsZjoKxnLMQFPoFfOxl5KKqhOfLY+ZzX421/bIUucbqOlc8
   PTUEySt+1qQEpx925qyAoV0b4WOArbV/L8WlafBenWND2bRSl4mZojIJe
   A==;
X-CSE-ConnectionGUID: LlvPT8sFS3SVl0ww6EOJLQ==
X-CSE-MsgGUID: zUQwqxhdRuuuAn3Qkc/hEw==
X-IronPort-AV: E=Sophos;i="6.24,188,1774281600"; 
   d="scan'208";a="144345981"
Received: from mail-centralusazon11011045.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Jun 2026 10:22:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vi3DhBFcweDiy9ooNfQqzzMxZxbHDr6zsNg9E7jaFfy98CnI85lT3sXEpgX2FR5h/tK52ENlXRWCMLsq42bsxc12Hqw4LhkMQaDAln4U7V4iFWtFTB5vTfcLTUO97jVgWY6zLuW/ZXUjhzHr5rrlvlxbisbhA2ShNQmDQ5reAXMw0rUbp6E2Y7XMr61PZyv4B+hhShKFrqcC6j0ed2uKUwHudMyN35WbrQhCpyVF8aVn4IR9TkNr4u2tfyRHUrVUtAIhkESpRjjKHjeUrtILOn7SY3ybY+LfgdF1lsTVffCOR2073fbpd7l3rtnEv9ZUvPVGLI7WpwwzX44dYqUdCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fzMGT4RUq6lfHnxvUfzNsXQrxgM8ARE9mWoqTPD6CLY=;
 b=Rvw+LKjWeCLkfiPXncryzTKEtPWj/2E44qznmIziRv6iqcXxrsiuZZUjPQ2bdpILMlUOzMGiKKorI9F0Diw/q6epvepjhHntq0uL+SLu4xbb6y8XBiDjPs/nrUz+iyYZIUlX8gWgX6sK4yA7ArgqokHMW2B7x9g/Z63c5JxSn+ZkI3nD/CuD0MPF+J9yObv9mF5iCSJgcTyBIi1J5xmx7+QqDSUi7V9rpqcguoI2G0pT8kx/WyomGx9i6Cv5cqzhQ6u3mFGz1O8hDqf9jKjCt4DIiJhIR1CN6d5szh8CmNtMWDckRQATYltoQZQInzVtzne9B7gDhWVz+JDBRa8FQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzMGT4RUq6lfHnxvUfzNsXQrxgM8ARE9mWoqTPD6CLY=;
 b=L6s87P6y+Ir6m41by9MbOoiSBLLdXhU3LGHB0mQJk824h+qFVhz+XepYRbjENxo/S7+Qs/ObgJxVLhBal0G6XfK363r4pLvogITqaV2ZvVf0M5he5OKzXtFZQpPxD6IrDHpZb2+fP5YDWilgndwfAdHlfVdlaSacqHabQLkCWbY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by BY1PR04MB8702.namprd04.prod.outlook.com (2603:10b6:a03:527::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 02:22:48 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 02:22:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Jun 2026 11:22:43 +0900
Message-Id: <DJ0RAMUVW89X.C3T31TKENNYN@wdc.com>
Subject: Re: [PATCH] btrfs: fix zoned sub_group leak on space_info sysfs
 failure
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Guangshuo Li" <lgs201920130244@gmail.com>, "Chris Mason" <clm@fb.com>,
 "David Sterba" <dsterba@suse.com>, "Naohiro Aota" <naohiro.aota@wdc.com>,
 "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260604121043.1425201-1-lgs201920130244@gmail.com>
In-Reply-To: <20260604121043.1425201-1-lgs201920130244@gmail.com>
X-ClientProxiedBy: TYCP286CA0307.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:38b::15) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|BY1PR04MB8702:EE_
X-MS-Office365-Filtering-Correlation-Id: 61374273-6644-403b-3b52-08dec2a95621
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|1800799024|10070799003|5023799004|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lZRgEaCvykBy4CTueqjsK78vZ2z4ImatWxtyFy2utfBRZbMJUAxqHzMnud0I7uPq95yjrQOJnCdwSlh5bq26yt7/iINtczfb+LUa50cOywjhmN8OWGKQzKY+qkgQbTiEXwBYNXhZHSS4kC9K7qaLQhGp2PRt5dqjBOkmDr66qZqqQIbDb/zAV1mEUcp24TCCF81UODvrbXfdjLVmjUZhMVibQIir6twEjDI5KRpXV8DwAPJVo25P/y4/kAVVlxUKpPC5UzAZDl4fkYFF+0yRjOt+tB4TZ2bKNkKgiZwL6RgCKd4c44cufyIy8a039NsXfytwdcOaEf8Gite65NjrQbleH2OKrXrNiZM+jjnL9D71keQfMqswEHkNqbly21q1WVlSSFWwGtKWkK0CtJasHldF/4/agaac9d3xHB4dwoL/SiWFH6woL17G/X3WGiNaGahXnIopc6rMufrEZrYdFhG5NaVoVHsAkwy5Xq1tqiRKTysKp5SMsgunuUXaySPlOVr1cRZAELGK0ma9g9KIlP9BH/Rzu3p6WiYTm2SeIByzcPDZBaGNk+BH+t3F05sZs6CCMt6uED68k+wuZvE+U0w8Jwj3HK1LyCqiUvmCX9ZBjfZCLKRbbtN7pd1roQs9PUwdrVPHEp4pA3r800S23apDO0XqBYunq2BZm85/Pu5gKT6Zp3WsMj+PaY6Ll3ok
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(1800799024)(10070799003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NW9JS1hkTmpuNG55Z3pkN0h6RWR3MGUwMElYOG5GV1ZpQUZ5OEhZbXNaa1FP?=
 =?utf-8?B?M0oyMkZKTDBsT2svc05HWnJnTk43ZktsaE9mVVArV0plQ3MvNnVFdkdPOUc2?=
 =?utf-8?B?Y3k2Tk80TXVtYk5IMzlkT2NYYmw3M0V1V1A4VmpmUkRWbmhSTEpzTk5oTzVW?=
 =?utf-8?B?RXBqWkMvK210T0NxNkNrbzZJVnBmK1p3TGNOSTd5ckcycXpMc2Z4ektsaUky?=
 =?utf-8?B?UXRXWC9DTmpET09rZmNXNGdFWjVVa1pCZ3luZW1HaXptRnpKM0RMWGo5cDNr?=
 =?utf-8?B?N1hpcnAyU1gvbUpXZnlUOVBJN3l6YnNOa3lQRUtLcUV5ODdtNm5BK0RUd3J5?=
 =?utf-8?B?cStQWWJka05ONUFRbXlsNkEzQ2V3ZGRrLzR4R1ZNak9GREhvOHlpR2pZNkVj?=
 =?utf-8?B?ZHcxWkhwTnBNZmF3dFFBVGlUbStkVkE5TjZ3dVBnL2VIRFRPeU41MDZ0NkpD?=
 =?utf-8?B?Mm1oaUx3QWNKU0trSUJYVmZmM2RuL25QZHVUaTJQN0J2UzJBa2Rwdmw4NnRi?=
 =?utf-8?B?QzRodlFwVUxKc1BZanRWRjFWakhPZzJjeENIbHoyVEJmRjZ1QXM0WWZxZlpH?=
 =?utf-8?B?NzRtaDhzM1BBOXl2ZG52MGkydXAwUFJabjFiZUsvTk11Z3FsZDVSZUROeXli?=
 =?utf-8?B?cEE4UEVpL1lrbnlmRjh4Q2hCMVIrZXNMTUUyWWhVYlV5d1dNUjlhL1Z2S3l3?=
 =?utf-8?B?VWkzaFZEWGI1V056TXYwRHVESE50UDMvVHlXVFlTN1pSVVNIaEFMcWxNWWZO?=
 =?utf-8?B?Tzd5dUFoNHRiSWJkUzUyL1ZxaXFkdG5EZEIvaGpYTk0yazhHNFNuYWdRa0dJ?=
 =?utf-8?B?bU5ZMDMwbjRPTHk2MkVOUVlPS082OUJuNG5NblhSRU55WlhjWWh5eW0wa0l2?=
 =?utf-8?B?M240MXpVallTMnlVQmZKYVZ1ZVNIYmY4Q2ZyK3RtNmpkSmpKaWlFbHdUVklQ?=
 =?utf-8?B?Ymx4ZjA0MFp3KzlHUTlIN05nZm0yRjZjdHpHNXQ0dFlEYW50UnI1b0V3bWlF?=
 =?utf-8?B?STF1UEJQTXlHcHNZN0xIQXJGdk9WUU0wUFJ1Mndpbjh4cElCZlFhV0pQSlhR?=
 =?utf-8?B?YXBHeXRWdlY3eFUyZVUzRnZrN05FU1NIMTkzMkgza0wvRlZMNG1BWTBYSkhn?=
 =?utf-8?B?blI4QkRMY1J0MW0zUWMzUVdadWg4cEZaNlQvc1dkYXZFaElZUDF6WkN0a2Ri?=
 =?utf-8?B?RzZTc3lQWkV2Z3poNUNGUDM2UStCTkV4Z2JSeDczZUlSRkxUaTlob2Mwdkgw?=
 =?utf-8?B?YUx5MkszU3BQV0xzM3RpaTlCbmVQVllFdExRMlBmUGk1dk5JeDRkNTAydld1?=
 =?utf-8?B?MXhqUFg5MzZoL3N1OHRiQWhBNTBwdkdEK1FDY2c0YnBaN0hoZWZTTFlVdDNh?=
 =?utf-8?B?emlaUFNWU3lmalZRcTVtcDFVcTdWOFNCeHZFR0wyb1pzSnVIQnNiNEVTNURj?=
 =?utf-8?B?aTJ3V2dsSjk5Z2RhUkF5anJYb1I1QzFNNEdiSDdkdFNvbTBFQVNJTVhZeWll?=
 =?utf-8?B?TXZOWU56L2NPejU5c3V0QkNGMmhGM3g1SjlUZW5JcnZEOWl4bDREMElURFdh?=
 =?utf-8?B?Z3N3c29rSFpVY2NIQXpJK1ZXQmRYN2w1NzAydHhBZUpGSjVJU1ZMcnBLSlkz?=
 =?utf-8?B?blNWSk9Tc2RGU0JZQzh2d0FiUTR4SU1kMldGQnRBbUtwSXB1NHMvbGVQbzhr?=
 =?utf-8?B?eXFEaFpSS0EwV0ZhQ083UGJtRFhjY1hzTjlEeXNQUmtoYy9RNnNPMDNKZUx0?=
 =?utf-8?B?WmNZVlBEc3czUkFaQUV0UEVQbFE1Q29HNUZTZkhNZWdPM2RwcklWTGloK2pC?=
 =?utf-8?B?UXA3K2JjeHg5ZHlnMFdMRnp2K3VwVXF1bFQrd3pKU1RMSGdzMUxSQUtqOXd2?=
 =?utf-8?B?NFhpU0hudmIwME1jS2tzRGF5YkRuMkNpTTJXeVdPV2lMLytRZlBwL2JnL21j?=
 =?utf-8?B?dGtkdjM3bDZKS2lOam8zZnphd1Zpbk5qZlJlRWU1a1B3UGROTnBKUGxwWGlT?=
 =?utf-8?B?ZG9DaTNiS0JOMk9HaDRGUFR1eWtUT0c2bTM5Z1pHZmxtbkEvc3d6QXZLN0NX?=
 =?utf-8?B?Qy91VnJRZFcwMGhaSmZKU1czTEgyM3BYN1BOdVhjc2crMWUvMmE0ejJONTNm?=
 =?utf-8?B?T1IxZTVuNjVhSTNGelMzeUJiS2ZxelNqOEJGM0ZxNFR6QkFEOTZZZU5lRHFB?=
 =?utf-8?B?aytKUDJhYW1nQzd0ckRQemMvUmVnTUZFUURRS3h6N1BqYjV0UEFyWDJHUHJ4?=
 =?utf-8?B?SmNLRnpTSkNJemFvK0VYNnR0b0M2encwMklwMU1YcFRMUFFzY3lyUGh6OXIw?=
 =?utf-8?B?Nm1ITlNDSFEzYlYrS0F0Wi9ETzh2eUZQTGhmRG5WKzBPMUNRN2ZaVndkMUht?=
 =?utf-8?Q?N3oGmAEfhQ77MHthKozS7nAuQ+g/EqoswuJnT7zP5hafY?=
X-MS-Exchange-AntiSpam-MessageData-1: Wr4PtoZasSzn2Q==
X-Exchange-RoutingPolicyChecked:
	P2KgkYrWRqPcvVDuNIGPPKdwCRtQ8RgnNgUgbL1t0PS6qF8HJ7DJNEDmSgOxziqb+2HJc4EnL3PgGIfUN3HUqswpiSvDNdd6SQ8F8vVL8JCPNG8M8rRLh/uaZJHiIqu0Nfkye3IYsIOzfUXDN3BxvGSZl1dSVdN/CxO0i7tp8+8I9gKrMqkEQxi6vejk65gq1JhtFqcElc5eL//Y5BZaF8JAmnsfJ14dXWraiFPEIPgTP7uldibi9KSO3F5W7u3X2kIJ8gBnTiHWDwZ8zZIJWM+kTn3VYVs9TZ6vLurDjKmPp7XpSF/zs80lOFGiXPC1HCQ5XD0Nj9pV/LeoX2u5Zg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	buUQPHQB0IR3tuWPJHPO37OVOeaoCvhEJ8x1YUDAuX+QUNjjhw6LGGssh5KCbwSxi+cfyfo/T+y15zsD1hNEz6dUGXx6afPAZ9GCAbL/+rug2/f00hjYtOepfqg93N12jlCyb5TwkPNExPUGLk1gOT4kgD0iunFYXVEUfyV2AfSMpbYQF9phEGpnZnfoCJiXGgPXbAJawIsORpORC78o7LP1HLNW2Vou51dR4VPEPgRk3QVApQRB9F3TB3+fhUTedGO0p1Zkre4Y8Nx1ovS4yb6Ci9S2jtnjcByEDg0bCUFcuT3o0Tw3ve2Hmj3A2+WXjqUWj8VlLkrdumossEetBwJVM5XY53OxbUoHTFoAriwFbuYlR1Dn5S/BEcqDfqpXab6OVumGLVeFGmIZ9/BXu9vO0vWIu/XYrCDvuENjUPqdgiFO3ujAbTex/rOqriuWfo7TDtJ4r0yBHcZSDp2Ab9sD5FKT6ij54whB+TtzONKkNviZvWeifVrFEzFSVzTY5ogobsRScNJl+kNf1Zu3WW0Aia+IRg8lNhUuRm22WgHjXp4q1eJNzsmKLiiCp1Q1tGcEJVqHG54Av490yVkwmORHYBjVaESJQIdvlyZHoJSJBPTZKefyIdIkTpDsr/d0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61374273-6644-403b-3b52-08dec2a95621
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 02:22:48.4240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKhnZFnWvww1nc+nMmEYmDZzwCxDvRB9NSqN1yoYiv1eEMyGJkNcR08sgXcU1Nn+FSvIE5usYFVHgXG+H7e2GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB8702

On Thu Jun 4, 2026 at 9:10 PM JST, Guangshuo Li wrote:
> On zoned filesystems, create_space_info() creates a space_info sub_group
> before registering the parent space_info in sysfs.
>
> If the sub_group registration succeeds but the parent
> btrfs_sysfs_add_space_info_type() call fails, the parent space_info is
> released through its kobject release path, but the already published
> sub_group is left behind. The sub_group also keeps its logical parent
> pointer, which then points at freed memory.
>
> Remember the created sub_group before registering the parent and remove i=
t
> when parent sysfs registration fails. Cache the sub_group pointer before
> calling btrfs_sysfs_add_space_info_type(), as that helper may already hav=
e
> put and released the parent on failure.

Thank you for the patch. The logic itself is correct, but I think there
is a better alternative. My suggestion is making
btrfs_sysfs_remove_space_info() responsible for removing sub-groups (if
any) first.

With that change, we can reverse the space-info creation order in
create_space_info(). If the parent space-info registration fails, no
sub-groups exist yet, so nothing extra needs to be cleaned up. If
sub-group creation fails, we can call btrfs_sysfs_remove_space_info() on
the parent to clean everything up.

This change also has a side benefit. Currently,
check_removing_space_info() is also removing sub-groups, which
contradicts its name. We can remove those
btrfs_sysfs_remove_space_info() calls for sub-groups from the function,
making it a pure checker.

>
> Fixes: f92ee31e031c7 ("btrfs: introduce btrfs_space_info sub-group")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  fs/btrfs/space-info.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index f0436eea1544..03659dfcb830 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -296,6 +296,7 @@ static int create_space_info(struct btrfs_fs_info *in=
fo, u64 flags)
>  {
> =20
>  	struct btrfs_space_info *space_info;
> +	struct btrfs_space_info *sub_group =3D NULL;
>  	int ret =3D 0;
> =20
>  	space_info =3D kzalloc_obj(*space_info, GFP_NOFS);
> @@ -316,11 +317,15 @@ static int create_space_info(struct btrfs_fs_info *=
info, u64 flags)
> =20
>  		if (ret)
>  			goto out_free;
> +		sub_group =3D space_info->sub_group[0];
>  	}
> =20
>  	ret =3D btrfs_sysfs_add_space_info_type(space_info);
> -	if (ret)
> +	if (ret) {
> +		if (sub_group)
> +			btrfs_sysfs_remove_space_info(sub_group);
>  		return ret;
> +	}
> =20
>  	list_add(&space_info->list, &info->space_info);
>  	if (flags & BTRFS_BLOCK_GROUP_DATA)

