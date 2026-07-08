Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703B4360ED1;
	Wed,  8 Jul 2026 01:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783473359; cv=fail; b=qTG+MDkBMRNEdixt3kgUl/2eyZXVKatvfPpm7hJ4HYWv4d/BCjk3CW1at1O03bVzDsh80hctQFzJ4spuRGxpY4aKRdYhFrXFa0bUdB2xNIOC+N/xGBUmVZ8M41YAOSf1aVIGMvwRYqTCVCqxIUuIMfmYAf/1L+8joqFXoTS22Zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783473359; c=relaxed/simple;
	bh=Ct7r0R0OhRZyME5STt3AzZaAlDbsmXe+ZeFSnzRuyjM=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To:MIME-Version; b=O/GAcLEbavfrTcfBSazmINnfO42qBjaTKY5v6sxy3cqyx+kaES21xu79/m4EiS8J9/hJctw31bGH07r+ygZYJcIWMTOjcsTKmCl48ZwbMPwLSVxjIhwKFPefctxKe5/vTr2bPUxxTWyUQ8drAbn4i1FWS9qjbT/4mnS5ZyWUPuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=L//xc37l; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=x601UDBe; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="L//xc37l";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="x601UDBe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783473358; x=1815009358;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=Ct7r0R0OhRZyME5STt3AzZaAlDbsmXe+ZeFSnzRuyjM=;
  b=L//xc37l4yyUYCnhz5nogAwU39Rspp9j4aOAI2NmH56EPc3bZAGMCu0v
   1+6O0QL/K9apAzA0Bf3yiH40uwY2YuEAIh1MhytnClRJcAOiEXyMnSbDP
   G7TvtHqqSFrHinnIdvnP8TME620Glw93lzEXXzsCEBgESS4XcbbjoXS7G
   rsJjQQYUEJfRxK7Cc46ND/aI/2Ogdf+hQsPn92qLCMWRN6LAZcZswXufG
   PMUQjTjHtBSGv3Rgtc98/bmmYHB6Q2AkkwVY33LW4AP0Mtw+e29e6VQXm
   ltSXUjM06KBZXHN9/19drNL46HKHtMnRRWCcA2OukLa1FHXdLHHtF8LcC
   A==;
X-CSE-ConnectionGUID: tsbO2/yBQ+q8V+KgDVZDFg==
X-CSE-MsgGUID: zzC9gL98R5iAMiHa3kYEkQ==
X-IronPort-AV: E=Sophos;i="6.25,153,1779120000"; 
   d="scan'208";a="149052759"
Received: from mail-northcentralusazon11012018.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jul 2026 09:15:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7/YKd7DB5DzhatKQiBGSti48m1tRpIuF1xzK1iJI966IOGBMVPtSuIQWa3MxMyjcM6E8diAVUs5Pt5rsIvbzZ9Jn2t54zYYbp0zZrAvV3nbZU3SSdf2nYkrs5T1lJwWKk1zQJw37B/lY4Q1CCK9bH5Yr4JecJwt7OBqUuhNOR6vKSzRYKtuf23A1UxBAUUlZ8soUkGLAfl6lDIo5+7vonKJOAXFxf61ZttS+4Js75VlW9X+VsFUuDvfsVOHX1VDsNHZUNCGtzHT9nvTRu+kLomHHTNiWVgQQRPuvObEWcFyAJA3zmq1AWEDd5WcA7vfmNufP3iZ9nElGGDtmtsGDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEupPR3JcQiSirx8N67SLLTIWH3SYHbDZzzxIV6BQSw=;
 b=KJ6jd0PgJ79inNGoWcQlLEoEitjmcFkAQX+dsNcJSjgCTQnolPvbZKh4qjKxQyrwhk7moxP5/e6xiTOUHcIhRYMs48rkRzXPhRNn96npcnvAQVnNG3zfGZCGYBFkBsJDOb7BmZW2gZzE7fOMeFXMp/oKbP72D7Xapi8ZtgwpzAKxQYHWh/tFS0iVZmkFJvjbTLmcxVgMmZTuQahOvdt6sSOfOm8Leb9tv/hVA81wPVfYaeNg5kwGPtXxlpSrh3lzJrr4tC0ou406TWVp2GBsvSJJ0LxqHBsyn5e0fDyXY5lV9KEI5E7ErdRF4iU6ItDlx6P8FxzPnhAJQXXOhjLPFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEupPR3JcQiSirx8N67SLLTIWH3SYHbDZzzxIV6BQSw=;
 b=x601UDBepV636KCk7TL2KYLDDP4dYj5Ap/M01vXE4wxCZhrrUAua9r349CbLqMd9Jjm8a+ZvXHJFTOj/LSMgPjTj0p3TQepwofXCiuLsNExeIurXqW0pfWA0fvRq5Rqb1xqg5fV5hc7k/ochWUHQAijwr7ueuSnDQlsP/KDgCAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by SJ0PR04MB7149.namprd04.prod.outlook.com (2603:10b6:a03:299::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 01:15:49 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 01:15:49 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jul 2026 10:15:45 +0900
Message-Id: <DJSSJBWWQYWH.1XMFMRZ5EDSEG@wdc.com>
Subject: Re: [PATCH v3] btrfs: zoned: reset active_meta_bg on zone finish
Cc: "Naohiro Aota" <naohiro.aota@wdc.com>, <stable@vger.kernel.org>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260706110216.232055-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260706110216.232055-1-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TYCP286CA0298.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c8::12) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|SJ0PR04MB7149:EE_
X-MS-Office365-Filtering-Correlation-Id: 19f5a864-6776-4d8b-0dda-08dedc8e722d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|366016|23010399003|376014|10070799003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5nv5erBdJ8BrL7ONmL3La1bydBRVRQTqZK4kW4zmPzDfIl2lJ72jxU6dJlB28jfHxmgvm/eoSEdjW/+Cb3zlUgRxVeh6Bw9uwVFzMROg29e71smjyXK7lwZPQ4T4a/CtVS4vWnusp+DZbzmxaU87ZSjxWEmS+/ek50DAblFhtGlbQRQl5zi/i3SbpNVEin/f8uaxsT3h8sb4oy21Nut4+Zh/oyjspsQysF0sw2xBmhBB0kshEjg1drKSKzSeeww6DPLZ2EOOM08jIoYaJj6cBzLFtCPygUSzgd8Kt8eQkPDz7BvvtoKqk+f7qe3cO+OLiG6CwRqNVsyUke+oWCtWpHf/R8lTbJk5GDkq2sTibmKSlRmHC9EwUSd/qn5I1TnHygptbbrpXYs3qR5oRAMKtOi6G+k6P6QZvE66cw1KHi7kKbXtr3Rr6/ZCvDAyyVfbFNGyqkj76yjZrRFQQK2O1rl8dsB/5hAtEXorQd2+rVm9/R9pASWLxz5xI8h61nVkUsCQ5Q5VjqHFQHELHQPrzLC3cOsDlR5UIBuFXRxc9OpVl5bvQec18E2x4FgkSIpVcRCdXRJm9MygT3A1msmkOqjfkZpuysGE8gFQuHNZtnYekYi/J2gbHv3r2L6AIAjDYVHVCI/qcxBHRCyTrNdeOG7UhMehpCoJxgPhyeOFw0w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(23010399003)(376014)(10070799003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFJKQytwT0lnQVByelNtVlRjYWl3WmJaUnBkSkF6bnFoL3BhaHpQUDhQZjJt?=
 =?utf-8?B?N0F2WDY4V2hPYzZYYzRKVFFVK1NKODFYVW04b29oYUVOQXVBRHpWWnhuY0JO?=
 =?utf-8?B?YnJzbktDdWRUVnB4dHBxdWFyVzczZUF6Ky9sOUpmL25hSSs3ZzJXUHppUTBn?=
 =?utf-8?B?SG1PeWw5SFpPMW5vR0NqUEZ0emxwMEVxQ0syUUx1UDM0SW1YZEd0UnRMQ2Ew?=
 =?utf-8?B?aTBhTm9HTXlBaEMzclRrZ2NGNHgraCtFMTAyQXlVSUZoMURsOEt0ajlwMStC?=
 =?utf-8?B?K0d0RmR3NU42ajdQbmhtM2pSR1NhMWkxYWU2M0Z6b1FBdncwdGd5NUpvZlht?=
 =?utf-8?B?Z20xWE9tZTdJK2c2Y1JYQUQyVmdteFZmOUhRQ2xxTTM2cmNOakt1N2NHM2FD?=
 =?utf-8?B?Y3FUaGtud1FXZDFPL1JjbUtJVGhpcUUvRnN4REVPYTdMMDNyVThwZUVwODI2?=
 =?utf-8?B?UmplNDhTa29Kako4WjZZMVo1U3F6YXJRMUQyUlRub09waVRqZklkUVF6QzVn?=
 =?utf-8?B?ZmlZcXArN1hSYzE4REVRdm1IQXYxNURKZnVackJIMkp1cU5vd0FOUWFVNnB1?=
 =?utf-8?B?K2RTQytMNS94bVVnTk9JaE1Uc1pQNlZxekZsWXJkdjNtdFlOelozcTJrczFG?=
 =?utf-8?B?enZFd3dOSHdwU0F1TlVUUzljL0YwTWJuTnIvZnUyamZndlBsODhkZm0wTldv?=
 =?utf-8?B?ZUVxS2tUbTA1Vkd2STlGWkJWVlBFU210MDVaVUZPVUYwR0dyU1N4T1dNLzRn?=
 =?utf-8?B?NFhaMTRVNTQwcmd5dS9NS1FnYW9HTEFJZDJiT0hLc215aFRQV0pWcVQyajN4?=
 =?utf-8?B?UHRyU0ltTnlnek5QbmlGSnpycUpxb0Q0bWhrNG15UzZYOWJVVUlnVFVFM0g0?=
 =?utf-8?B?Rnp5bVRpdlhOV0FseTlOTWRCaTl5WlcvTHZySDlVSkR2NU9EdlBqUGh1NFQy?=
 =?utf-8?B?MnpQSWg2d0kxSkVHaTJoUVFJdUZGcnh4YkUwbkRtczdZYXBwdS9TL0t5N1pZ?=
 =?utf-8?B?alNITWFjd0d5ejRFWjhvN0t4OFJ5bE44WmFxV3JGYThhN2tFeGU0UGNHYisv?=
 =?utf-8?B?QkYxQ2RTWUpsVXovNjNEUFh5Qmo3bGUwdlBCWmZmZU5SdWpZaHlnYmRJTXM4?=
 =?utf-8?B?QzMxem44bTg5cFRJQU9qdC9NeWg1dStES2hWN045WjArMCtZemxCRlJhNlFj?=
 =?utf-8?B?QW1waEI2TDVTRzNBMnhlUThRaE0zZnJENUg0cjhhVFh2Q2E3MjBoSkVpWWto?=
 =?utf-8?B?ZDVFN2RCMmFrVVhJaFlNUGpUTERlYTdkUklhS2N1YnRKZm1jWnNIdlVXaGdo?=
 =?utf-8?B?MmFIS1hydGNacDJMMWFhWEhYT25kNCtsZ3ZxMEV1d2R6RnIzZy9DaTkrRWVC?=
 =?utf-8?B?N0VNZEdFWG53S28rU1dDbmN0R2NhT21VVDFFVUJQaFhjNDg0YTBCbndhanIy?=
 =?utf-8?B?RDVEKytabFIxeUkrMzY3UG1acldVY1g0VHhaT0lPTnNyNnNmNzg1YXV5ZTVR?=
 =?utf-8?B?eDhCeS9UQ1I0QzYrY3M4a0VjNGg1WFNXVDBrU3lUOVQ4VEU2aVpUR0k2d0RE?=
 =?utf-8?B?amd1djJKTURUYkdJQ3U3emtwL3JVYko4czlWbHpENFNFTzVIUDVWVHBQNFk0?=
 =?utf-8?B?NG0zTm9MWU94dUJDQ1FGTEZhbEt3bk1lZUJkbFJMbUc4SmRITVQ1VjFuNnI3?=
 =?utf-8?B?ODM4NTJjM2ppejBKMXV4TjBVN3VRMHltQWVWOFVHQ0pJeThuaUFWRzdYaGJI?=
 =?utf-8?B?VG8zVzJQQTJQNkZ3Ny82V0cxaG9odFAvUERoWTdDdzJWMDBHSzVDYUhwUXpt?=
 =?utf-8?B?ZDB5US94b1ZSdVdLaGl6cnMvcmJpeXRGRjdkUXZWTkJEU3ZhSGIrMmQ5RGJP?=
 =?utf-8?B?eFBDVGpPV0NCZEZVRlp6SUNpc1ZVZTFtUFBDUUM5VnNWczYvUWkyV3NaRHhW?=
 =?utf-8?B?L2pWMG02TGovSGxrbXQ1S1pieUZjb2FiSjZ4T3RFRzRIR21Vc3E3Njl5ZytQ?=
 =?utf-8?B?T3ppM2N2TkwvZG9xaG0rVUszRGdxcU9sSlhTeW52TDFzd29sRFBQZTlDMG9a?=
 =?utf-8?B?MmlidE1kclRXeEV0QUFEdGY1MUxCTFFCTnhtUGJZU1pIV2tuNkgxbERYdklV?=
 =?utf-8?B?N1k5WnFEbzg0dDQyV2FHYVhNbVBGeThiR3kyVXNZT1dNdVZ1T1dwd1A0aHZH?=
 =?utf-8?B?M3ZrcDYrWXc0aW0wdnB6eW9tV2Ezc0Zpa0Y1WlR4REhoWVkwZVpQNmdHNEpu?=
 =?utf-8?B?d1ErQlNFRzU3dyt1RG1BTGpiSUlwSTRUQ2k3dm1yakpBejlKc1pwUnErdUgz?=
 =?utf-8?B?T2w1WkdQU1d3SnhtOER4QWtvc3NoaGpOaDdMVWxHRWxDYjBGNnFHVW5lTSsr?=
 =?utf-8?Q?aJKNSW8QQJZqnqx0T0+RlVuidiH/HmHTjixka95voCoge?=
X-MS-Exchange-AntiSpam-MessageData-1: XwunCj+rfG/XYw==
X-Exchange-RoutingPolicyChecked:
	JReTKpW2XSmgrxVQixSYbtr6gwflqGrYkbVluXe9bCRWKcswbL8twVtSjcXZd814pH6legVt+cZ4rmYqKYTQxW3BNH7GWNFPAQ0F96n+pFGnMPXAzbcVnXvAc8mi96rpDyfc46yyuOFOinA1w/iakP2PzTQ6yGxX4L5JCLVLH4zGps+jIDumKntxHOxsXPvbZilTeQalLhe4bGCvaaNMnm1MxvZX6B6+7UnEIEePvfljraE26uQ8yqd9FzMxrfMSxbB5P9x9bqgar926dUsdmO76PUcQ5XwsKWXQdL9Wj+jNC352UglFG1x76ISVKTTyWoOgnOJy7oj5brwmuqUZ+Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OgesT7Re1/o3OG0rUi0fbSsgJEDC45IMzrr7nl11dW0JfCTb2wXkpy9TDlCze0jg3s5eEik9fyUCOoh/X+HKthlnheWVtQfZ2PN0iJVnHghBkMMXV7GHeXRnx3VaxpVeKovJL7/MWb7F3rJLbwLWsrMBfcPNd+Nb9CYMkKIYBHOGKCA+P8BUYRTJrhBG5aHouxMUXiqzXLNC3TenKjqVJqAT5hUPRDed7TKcbVmMFP5PIjbkz54WHm2BC3F/wSX5Lg1Ardd/anpYVDd+4OhoHCiYQLDzLcuVwS9p+JGuzky2/BFzfxD0aC9vIV4Z185WHTxMAXxTX3PIgNjYiN7hSslIcz2+gBbP4C2oWDlTRX7jgk2FPfwwxNBHFu5ncIdRE+GCiq+OMfkxQUDQoPZW/1XkmL68Nt6fRjcO0/8zn6SfD49CTueVa1ILay+nxDv1qvphYmLt2WVSSPbOYT0pY7P8Lcdt0Dz23/IO58XUloFcCvtDBmp/RGEnPKmE1yCjFMPaZRzTCxYsoPY6gu9lbHpncv9PROHlPXxb7gjtoRz/4x2G/76rZjNcFHcv0Vh5SL9caJ/4rdpHKtXnG3rUJDlqHC3rFFA/22VwZh59Or/welqFT68KfbJSMIpVKpqs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f5a864-6776-4d8b-0dda-08dedc8e722d
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 01:15:49.3254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCkCLMozG8XLfaxOsiYtr/pl7RIK47fQnT369+godN07mUqc4YCH6ygQx7uZ5NAIMvkwAHgGhZltka0sOojj2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7149

On Mon Jul 6, 2026 at 8:02 PM JST, Johannes Thumshirn wrote:
> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE and removes the
> block group from zone_active_bgs, but only the pivot path in
> check_bg_is_active() resets fs_info->active_meta_bg / active_system_bg.
> Any other finish path (the async zone-finish endio work,
> btrfs_zone_finish(), reclaim) then leaves active_meta_bg / active_system_=
bg
> pointing at an inactive, fully written block group.
>
> Reset the corresponding active_{meta,system}_bg pointer in do_zone_finish=
()
> so it can never go stale.

Hmm, but we anyway clear and set active_{meta,system}_bg when btrfs is
writing into metadata. And, if the block group is already finished,
do_zone_finish() will just exit early with
!test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, ...) test. So, I'm not sure
the issue with it.

>
> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on writ=
e time")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v2:
> - Get reference to "tgt" inside check_bg_is_active() if it can actually
>   vanish underneath us.
>
>  fs/btrfs/zoned.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 97f06dd01693..fd578bef1f4f 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2213,6 +2213,7 @@ static bool check_bg_is_active(struct btrfs_eb_writ=
e_context *ctx,
>  			}
> =20
>  			/* Pivot active metadata/system block group. */
> +			btrfs_get_block_group(tgt);
>  			btrfs_zoned_meta_io_unlock(fs_info);
>  			wait_eb_writebacks(tgt);
>  			do_zone_finish(tgt, true);
> @@ -2221,6 +2222,7 @@ static bool check_bg_is_active(struct btrfs_eb_writ=
e_context *ctx,
>  				btrfs_put_block_group(tgt);
>  				*active_bg =3D NULL;
>  			}
> +			btrfs_put_block_group(tgt);
>  		}
>  		if (!btrfs_zone_activate(block_group))
>  			return false;
> @@ -2535,6 +2537,7 @@ static int do_zone_finish(struct btrfs_block_group =
*block_group, bool fully_writ
>  	const bool is_metadata =3D (block_group->flags &
>  			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
>  	struct btrfs_dev_replace *dev_replace =3D &fs_info->dev_replace;
> +	struct btrfs_block_group **active_bg =3D NULL;
>  	int ret =3D 0;
>  	int i;
> =20
> @@ -2632,6 +2635,20 @@ static int do_zone_finish(struct btrfs_block_group=
 *block_group, bool fully_writ
>  	/* For active_bg_list */
>  	btrfs_put_block_group(block_group);
> =20
> +	if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)
> +		active_bg =3D &fs_info->active_system_bg;
> +	else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA)
> +		active_bg =3D &fs_info->active_meta_bg;
> +
> +	if (active_bg) {
> +		btrfs_zoned_meta_io_lock(fs_info);
> +		if (*active_bg =3D=3D block_group) {
> +			btrfs_put_block_group(block_group);
> +			*active_bg =3D NULL;
> +		}
> +		btrfs_zoned_meta_io_unlock(fs_info);
> +	}
> +
>  	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
> =20
>  	return 0;

