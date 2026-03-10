Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E5B372B3F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 10:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138997; cv=fail; b=YPoVu8EqmHJUzBH+zP3tB6ywADqt6YLAW9xYk1A+Kc5zCmEl/thkYKl0faRq3VRCD1+VK6SUIO5iCo8nUVcDFyrCbHCT+YMJI0MN9EGe6HgE//odp/KiawDT8Gm2wSkWVbCFCUqToxR+zwkdsVHsTd3OwX1+hzKxMKt+peJt4XI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138997; c=relaxed/simple;
	bh=o3mAMutce2ai+IjGWTZzLhKRRnrivPdcAJNLTO+f6lM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KWzTRu/ZcYm3s5xoJxZAaktjraQkzFYz0k59He0ICdrSilpfEsRDPX/eWj07DxvzZ1yNewp8s3ZMTCRsoOSR5N5aBbBp7OPh3KwRZKJJZzON4L/dheSFODBDMAkvs8A1+Ntru+W2qjXzz8CmhBa2qLKpvHpHcGtKIQk6BhvZZ/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=W9re+3pW; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=bUYsW6bd; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="W9re+3pW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bUYsW6bd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773138995; x=1804674995;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=o3mAMutce2ai+IjGWTZzLhKRRnrivPdcAJNLTO+f6lM=;
  b=W9re+3pWM9QMgpebuiXdVGB5Q9f792XZJGQOxgbb7mrctyUfX4VuelOo
   Ph8vqQTsBooLhjSuJz2fVEHt4fMkI3NID1rEXwWdmwZoObbGvLDIWH+gI
   Yxbibmz0H5GM3w43kWg/qHgFMwH/x70jV5nSv6Z81F2PE463hRX23Xm4g
   gF7JRTmhvdlC9JWCfUUkF1Z/BUjZ44oMh7V6lmgw3C25HO1TbR/fAbAJ3
   Jr4nNLlVwCdN9PlO2ok1ub/IyuaFf/XFC2T0pBDM8rBacznTld7vGjVRB
   qwr6gYcy08ozfCMqNqtvqS/9vO2GyEXqPRrbGbUKGvPbpcYQoqwF+GiS0
   Q==;
X-CSE-ConnectionGUID: T1XK6H04ST23fXwbPrmn1Q==
X-CSE-MsgGUID: s0t7cQPwTj6yU0W/IiuzPg==
X-IronPort-AV: E=Sophos;i="6.23,112,1770566400"; 
   d="scan'208";a="141255876"
Received: from mail-eastusazon11012008.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Mar 2026 18:36:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aeDa5byeGw1wxYDLIGqv8ajVxkXsWlCbcEH6pVHj/EFZcBbJbcp8ERbVFikJH8S6V6JqREjTFfOdbkUuUW8fYX6rivv8jBaAIp2CDC9pns0AGl9ocfsYf9OL4ddN2csn7m/YEgomH2kcaNi0XN6A4NnQWgs6R2KNL1MAIhyK02Yacuk9L8r1HXo/1Yp6UUj2zKaXslcBz4K0ZwvkE2/8JAvc7dcBcmrOvJEhE6dcmw7htToZOHu4d7p1KSrrwHPvDpIScBNSCLN0z0d0ugqHIT14+EEAKUL4xekkuFz8Cu8Xpotoqt7NEtnjiiCjMSV3NS28IaOIX0mdo5ZtqQD2yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3mAMutce2ai+IjGWTZzLhKRRnrivPdcAJNLTO+f6lM=;
 b=rXkPn5NO9go1SPTFvbIt44dXTMJj64l5iafHPDgtHeGZEN+u+k9LZlgBTLybWEJgLLcxDCSO8u4npzSBXFQGA2kwjlg1aUDuIxLEEIQ7AQx/pLs1UCh1oAVZpasnqHj0NpIjsLt5E7DDEDLkarOUFmauv7+3FCPN65SaNZ5O3OgrP41D41dwtBmqRG4EIiDwKBbk5IyHFPBJHz+PA2GrP0P8xWWIp4i6ZFgMaVMRn74kOFcb1EFbz29QevHwm+BjHlcyXaPKToYSZvVz5xbpLr1tGBEQlyPHHQOK1LS8H2pRY3JU7Qm3gT0wjhF3EVeg7XOpv9HoWpQyIc/XOyWkLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3mAMutce2ai+IjGWTZzLhKRRnrivPdcAJNLTO+f6lM=;
 b=bUYsW6bdjuZfewZXyANERoRYDa/GWt7c21VU2II5uM81WOAZqRyFv5PVi0FGjbEemrs52Zvo3dkO05L0xUUvGHqertfHDJnoDs+trRoqjuPKvo3OOzpQPU7lnEipX644YsSldCne6fGX0r6TVuhcVR+v0DHpa8ZVi+bOqgXx8Qc=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by CH0PR04MB8004.namprd04.prod.outlook.com (2603:10b6:610:f4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 10:36:32 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9678.024; Tue, 10 Mar 2026
 10:36:32 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: WenRuo Qu <wqu@suse.com>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>
CC: "gality369@gmail.com" <gality369@gmail.com>
Subject: Re: [PATCH 1/2] btrfs: tree-checker: introduce checks for
 FREE_SPACE_INFO
Thread-Topic: [PATCH 1/2] btrfs: tree-checker: introduce checks for
 FREE_SPACE_INFO
Thread-Index: AQHcsBLuLY8L0YCMCkKLBMlOjU3OYrWnk1KA
Date: Tue, 10 Mar 2026 10:36:32 +0000
Message-ID: <8a1b20e2-20fd-42dd-ae25-c2d1bf09555f@wdc.com>
References: <cover.1773094579.git.wqu@suse.com>
 <dcc4425060fb18e7dc5b45e4ea05cd8afec13f6c.1773094579.git.wqu@suse.com>
In-Reply-To:
 <dcc4425060fb18e7dc5b45e4ea05cd8afec13f6c.1773094579.git.wqu@suse.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|CH0PR04MB8004:EE_
x-ms-office365-filtering-correlation-id: a04ca6d4-fe8d-4b1a-0bad-08de7e90e5b0
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|19092799006|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 Jd3PjA/tiAtiLGeqC6ZJAhp4LCqBtA0TqsqQPZFr+/4xSwGsIDJF6msK81tWF5wa/l+I00X3/qZ2LQqGXDlafOXGLqtgD+YpGgY8fcNGVox9bA+KjIEVtSdJVsmIfK6duwwmGByLgfiCH9yV8OD4Q/pgp6OS9Smk3k207K7y2mx+jL8KwSlGj7DsK1lf2AIGtfYg02cTG1xoXEHzzbxluqKuVYBHlY1hgk1UbDjkwQs/SyczM5JrSzGvDeSE71XCvDfY5Hu7ZwY0RHeUch4LwuaBKCKXZafNk1SiHBQvHgTOtHOJKWI5v+IsIoVpLZdhTZAtL0tHgkj9azljPE6y6QWb94doffr2nw4Z6s8c2+0ZHPV/HzdBHIExmEGCt8j5u125GmV2tsjKl2rRT4no95/KWG8dVVzXwRcg9SqoMfkMk/5WooxHFQYFqyPQm+u/7fnQ0GAVqpe5ixleovgQ2xiJkyCQ+1ceXwumPXRfzOvK/W9C7AlQufpw/218fxBTPId3xdZj5BZ9Y2QmK6rHBItM4Z8ztEsoCEzN0gLkUmnFyRosfC3/hhtgnz3199qsR9faJkHzS7vMnV48fMORSP21rHFWNGyM0LXqHVxd/2ce9uL2UEbo6kGy+L3CTkk651NH/VGBw3QKvl5tGzW5HjczsilxpvwlNqMtQidgmaLb4LzikxWUTBJDmgoEPjjSEgFAYj7JzfU0b0w/Ug8sIXWySCl90wQQh5v8dhaL5qtb18+OrDwVHQweurBShwQlRVjKlYvgGEGCXwpFfhRCDWVQo0REer8sZ+1eeiO+i/E=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(19092799006)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dGdOWWhsRG9WRlVZUDJIb050U2U1VUVoM1NjQjFPUitMRkRvSzlHZit2SHBP?=
 =?utf-8?B?Vkc4VWpFUE4xb28wdDhhMkxkTEtqRjJQWnp2UmJBTEpqeUhiZGYvSGo0YVBs?=
 =?utf-8?B?V04rR0pwNE16NVlBcHBuSWNxSWluWnNLZDFPTXo4QkJzeGc2ZzVpUDZmTEtD?=
 =?utf-8?B?VDkyT3RXdmI4V090ZlJmZlJvT2lOQVpUL05ybEh5NGlhNXJ4TmJHU1hvRXda?=
 =?utf-8?B?T0JvWTZ3UkNkR1lyOWhGRmEzWisrenNFeXNQQ2laNkVIdW9tcEx4VGVuQSt4?=
 =?utf-8?B?SEErSDV1d3Rwam14bEpTYkhxdVpEeE43RkR0b3hIcWFoWjIwcXd5Wmh3WGxN?=
 =?utf-8?B?eXd4SHJzR1RpWWYxS1A3QkQ5eTB5d2dna2QySjdGWkk2aFVlMlBIUjNFUXY0?=
 =?utf-8?B?Wm5KYTZ3TWY3TTUyejBpSEV1cHJwazZTR1g3VFdma3dBRUE4b0FIczE2UkxG?=
 =?utf-8?B?VjlsOTY4S3pLSjVQdE5RaXdPVHhNNXV5d28xT3p0SllLbUlRYmROZUUyT3g2?=
 =?utf-8?B?YTFNclcyUHorSU1wZ1VNRXpLT2pCMjN2c25UVVJPRHJiNXk5SysrWkZaaDZw?=
 =?utf-8?B?SXlBbEhBcmZIbkJmU0pUNFVLdEU0OVAyOWFoa0FRNVhXbElHRW9kaGFQbWtz?=
 =?utf-8?B?NDI4UjNMV2lQMFBxc09kTTBza1NYWnllQkxaUUp4TGdwKzlBNVZEYklVWVM1?=
 =?utf-8?B?U2YzbUpRdGxkV250NXd3dmhhWStxMVZwT0dOdktSZUNjRjNzWEtja2ZoTVFM?=
 =?utf-8?B?L1JMQ2ZTcVMvWmFsZFE5bmNWUWZ5VTZncW9ld2VpZFNCV3RjaFZMcDVJZDhB?=
 =?utf-8?B?clBIR3dHSXBQTXE0NTZlRkszMFkyS0FVKzF3dFJlMXg1SXpaZDltQWN2aG92?=
 =?utf-8?B?Z2NaeExZMHVQTWMrSlB1cW9CV3lONmJoUmpRbWFPUy9ON2lta3BORVRUM3Na?=
 =?utf-8?B?WFFXL2tyYm9kaHYwNmdkdy9mU0FWb25MUDQwRmtYckpHcUFaUmxlRUxxSUI2?=
 =?utf-8?B?L283KzMrVjJ3L1gzMXZnYXR1QjhkbVYyMk1Hc2I4cSt6V0VFSmJKUjRSb2Np?=
 =?utf-8?B?RktKOGhzeDBacHZQZ1NVazMzYkFzbjI0dytlRFV3N2o0YUJhT2NzemltcHN4?=
 =?utf-8?B?b01MMmF3cUpNelN0MjZrc1Mzdyt0em55eElNbmFobVBDNTJUVUkzSTc2elJP?=
 =?utf-8?B?YUJPUWN0ZlI4WElEUlh5Y1BFSERWdDMzaUM4bFVVNVprcWVhQXlKU3FvaGZX?=
 =?utf-8?B?SWV4S3FGRkFyMVNaa0V2QjU2MkdubnpzMXF5Um5YMW5xb3lML1EreVhEMkNh?=
 =?utf-8?B?Y0FoRk9rZFp2dFN0aTd2UEFJVURoeW8vOXV0TiswNktKUjNpdHNNclFTZDJQ?=
 =?utf-8?B?TXpYdDJ2TFZGaVJMVllpOVNsUk0xd0lKeTRNZzczQTlPS0x0MWQ4SGVPNHFS?=
 =?utf-8?B?UzRxa3RmbU9VV3c0RU9aQ0cvRGtQeXNUQWhGM0JSRmtIS29RNVIyWnlEeUVO?=
 =?utf-8?B?THZmYmh0VGIvVUxSRGtzU1J2RURTYzlLbVQyOEpLczBmNkVqaHhuYzUyZFZn?=
 =?utf-8?B?cHQ4aXp4TWdub0pKVzVRT2hlRm1qMlRzY2t3Z0tKeFY3dWEveW5wa0VUTVZI?=
 =?utf-8?B?cnF6SXhaUnRIWCtnQmhQRDNodHVFQnR4NzlhMmx5Rzd0OThSZ1dJdjA1bEVK?=
 =?utf-8?B?Z3pBM2tiVmh2TUdlcmxrVGZxTWpWS3E4dUJLblpPQ1FqOFZEREMwZklYRG5y?=
 =?utf-8?B?TUgyTWVTamtXMXZLR01JbDNtMDF4a3RWTGJmYVJJbm5rUUg0aGRMNnUvaHNq?=
 =?utf-8?B?ZXdmT1M0bGNuMXFJWUJVL0ZCZ1ppQWRkQkhJcmtYem41Sys1N1NmVzFvVjdX?=
 =?utf-8?B?WUlYL1pMM2swRHJjZEF2eE5ZZ2g4dEpudEZSZDNTb1ZzVEJsOUtvQTRRbVpL?=
 =?utf-8?B?Y050WWVhWHI4WlRqZzhSYUhlKzI3cjI3aFRqSTZXNGthblp1enR5V3Rqd2Js?=
 =?utf-8?B?WEEvdmdVaWRnTUZBZm81NmFnTVBuazJXQlR3SW13RCsydENmZnJFbm9VTytj?=
 =?utf-8?B?VXpTbDJZcysyK3grdEdxT05VWlp5ODNzZHFJRFI3UXgwazJGU1JrSXk2YlJO?=
 =?utf-8?B?dUNUVXhDN2gxOFMxOGtUcllaY25USVFtOGREbnZTUGhNbk9pa1RHcDVFNGFx?=
 =?utf-8?B?dmMxNjkzaENhRmxCb0sveDgrWGVlSXR3Y040RzFEdnQ3ZURqK2MzaU5tSlkv?=
 =?utf-8?B?a0xteXkrbXJBUWlqVzlSclJpTFRJcjF3Tld2ejdEdjFpZWFaeTVKTk1GYTVu?=
 =?utf-8?B?ZlNNZmEwdkUxVzRWakdKYkJnT0NtdjZ6a0h5RU5IamtkclgxRmNxclVtZnVT?=
 =?utf-8?Q?XLOC/FfVZhUdZXoyEq4SBO2ZhtIAC+JzusCiUgrp39NNR?=
x-ms-exchange-antispam-messagedata-1: MlLc5xw6GDE9VcItiNVE/CCO9ZJc36U5tNA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <059CE793796ABA408D3746FF1872AEC8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	CNCdY/GHKORLbXFJKCxVGptVnEoSIGcUD3HCKqMQjc1EBZNhbUL69Nll8IonK+KHB25rklppJkW/TJ3DvEhH8zARl+NxC/R/uEAkZQAHlydUSKVLeIBp9X0S36lselmt9FAibFW60lBnxLTL8g1cE3Nm2rENgOI0pdUDUYfKLlXkeg1f1APyhW2tRMkNRc5ls9A1a6jqun6eTUDOOUq5R/w8SIGzrB4L+Ps4PvnxgPu4jvoP+ab37mWMP90/6HBY2bwezkPt+TIxLTwYitaRDsSNYuChoNep9EPRGhpW2BbnNBKH5taIvm8dIJWeQa7oBE0uKXgjPlUjQA7ydt2yPA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ONEItwHH+FaWKj7wTQIGTgjOuozr6L78BbJCAz1RQXfDwrGEWWrGUPleeEKB9CfbR1sNJ7gJIbvq+ahqN7rwQH75LNe2qChzflvCqGlxP168wJwr0Dl3cJ2nSaHmzuMUB80Yry7WTtnCb54qn0uLsqI7lJMEL3HNz5+k8Ptd/JOd1Gaf58CAhMl1Fy5fK8DFbDS/MSUVww9Zolz10TvjKFXCEXtOn8QBjbyKBhPR3D19iEWB7tcMUeff3kp7tgLikr+pJo0zG2kJk/nXZv3+iqYw66cNvTTLbW/vHJlH1fo8mlgQ4VwBE6gDuzbwfH0bplAtXe29XA6vlgk4vEqVhnkd6rtY8vKAC/0pXsl83mBV00vZywZ/4isHM9j2yFtFONzyvvGMzQ+82VIh2GbTdf9iJ0qQxbZjfhhULiFVBJT5ImpKWQsjJ599uprFu1Ahx8qCCirzWvEKClzmmZ3wpTe3zVM7t4If1CZe5jpHGfIOsjj+ypO5Hzoh3eh8vnc2+kc3AXLbTXAmXonlg3i4DnQnaLkQQoaQotlc5UaubLStwxeVoTzngVnfdVfcbM1YkCLpDO4H6FUl72d45YENBv3kClJ+EU0RxTlY/sSNTPhYdOxIrtkhS38+qjn7kdzP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a04ca6d4-fe8d-4b1a-0bad-08de7e90e5b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2026 10:36:32.6937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ArBRDnuM1ECHHCzfbd7/ILD88Lfka3v9/ihFMZ8uWjy5IXfIOlq+P8HC4WFzs+eTFrBKai0aY/oQbt0ba7lD4dMicxPFSPY3ogxDZTUqwKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8004

T24gMy85LzI2IDExOjIwIFBNLCBRdSBXZW5ydW8gd3JvdGU6DQo+IEludHJvZHVjZSBjaGVja3Mg
Zm9yIEZSRUVfU1BBQ0VfSU5GTyBpdGVtLCB3aGljaCBpbmNsdWRlOg0KPg0KPiAtIEtleSBhbGln
bm1lbnQgY2hlY2sNCj4gICAgVGhlIG9iamVjdGlkIGlzIHRoZSBsb2dpY2FsIGJ5dGVuciBvZiB0
aGUgY2h1bmsvYmcsIGFuZCBvZmZzZXQgaXMgdGhlDQo+ICAgIGxlbmd0aCBvZiB0aGUgY2h1bmsv
YmcsIHRodXMgdGhleSBzaG91bGQgYWxsIGJlIGFsaWduZWQgdG8gdGhlIGZzDQo+ICAgIGJsb2Nr
IHNpemUuDQo+DQo+IC0gSXRlbSBzaXplIGNoZWNrDQo+ICAgIFRoZSBGUkVFX1NQQUNFX0lORk8g
c2hvdWxkIGEgZml4IHNpemUuDQogwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgaGF2ZSB+Xg0KPg0KPiAtIEZsYWdzIGNoZWNrDQo+ICAgIFRo
ZSBmbGFncyBtZW1iZXIgc2hvdWxkIGhhcyBubyBvdGhlciBmbGFncyB0aGFuDQoNCnMvaGFzL2hh
dmUvDQoNClsuLi5dDQoNCj4gK3N0YXRpYyBpbnQgY2hlY2tfZnJlZV9zcGFjZV9pbmZvKHN0cnVj
dCBleHRlbnRfYnVmZmVyICpsZWFmLCBzdHJ1Y3QgYnRyZnNfa2V5ICprZXksDQo+ICsJCQkJIGlu
dCBzbG90KQ0KPiArew0KPiArCXN0cnVjdCBidHJmc19mc19pbmZvICpmc19pbmZvID0gbGVhZi0+
ZnNfaW5mbzsNCj4gKwlzdHJ1Y3QgYnRyZnNfZnJlZV9zcGFjZV9pbmZvICpmc2k7DQo+ICsJY29u
c3QgdTMyIGJsb2Nrc2l6ZSA9IGZzX2luZm8tPnNlY3RvcnNpemU7DQo+ICsJdTMyIGZsYWdzOw0K
PiArDQo+ICsJaWYgKHVubGlrZWx5KCFJU19BTElHTkVEKGtleS0+b2JqZWN0aWQsIGJsb2Nrc2l6
ZSkgfHwNCj4gKwkJICAgICAhSVNfQUxJR05FRChrZXktPm9mZnNldCwgYmxvY2tzaXplKSkpIHsN
Cj4gKwkJZ2VuZXJpY19lcnIobGVhZiwgc2xvdCwNCj4gKwkJImZyZWUgc3BhY2UgaW5mbyBrZXkg
cmFuZ2UgaXMgbm90IGFsaWduZWQgdG8gJXUsIGhhcyAoJWxsdSAldSAlbGx1KSIsDQo+ICsJCQkg
ICAgYmxvY2tzaXplLCBrZXktPm9iamVjdGlkLCBrZXktPnR5cGUsIGtleS0+b2Zmc2V0KTsNCj4g
KwkJcmV0dXJuIC1FVUNMRUFOOw0KPiArCX0NCg0KDQpJJ2Qgc3BsaXQgdGhhdCBpbnRvIHR3byBp
Zigpcywgb25lIGZvciB0aGUgb2JqZWN0aWQgb25lIGZvciB0aGUgb2Zmc2V0LiANClRoYXQnbGwg
aGVscCBmaWd1cmluZyBvdXQgd2hpY2ggb2YgdGhlc2UgdHdvIGlzIHVuYWxpZ25lZCB3aXRob3V0
IGRvaW5nIA0KdGhlIG1hdGggYWdhaW4gb24gYSBwb3NzaWJsZSBidWcgcmVwb3J0Lg0KDQpUaGFu
a3MsDQoNCiDCoCDCoCBKb2hhbm5lcw0KDQo=
