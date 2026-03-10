Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CE237268E
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773139357; cv=fail; b=INoCfCOHIsF10xyITi/Sh47ocOiz+9QilESVgcXExWD+RcCECrVC5RXSEQl7X8ujL6sM7ga1Ed5+2i0dprJ2/f2T88OwJPUwXgURzyOxY3Q4dLRvJjorx7Z1xv1lzmD35YIwqtbkMrmxJmxGWNc/SpKvPJp9Go4vCIbCnuomKY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773139357; c=relaxed/simple;
	bh=gd/YDC0ihdBBhBTFLSV80H31wn5sE06jQ5IhYCmoijE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c3ZjDsCldGiS/BNTCwEAB76Y4OLkLYr62h1h7+LkHrQYacTdZCOqlyFKCVNLavn1DhRKI+Lu893NFN+dMXbMjwri6QPFudLnBdabFfgI7vmWVGRiTCMXOQmontItmgPhabGLxA5amR4DqV1WXXyX/woUZI5NzPYKczt8k0b5wSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VUmvzDk+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BdrOeBnl; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VUmvzDk+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BdrOeBnl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773139354; x=1804675354;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gd/YDC0ihdBBhBTFLSV80H31wn5sE06jQ5IhYCmoijE=;
  b=VUmvzDk+VPoy3phKKxAnYn7j/E6nLY1A/opY5GDSBeduApRBcz3pyLOh
   7moV2EJBG++2uamwiBAbZ8TODqBFdaVABW9XndcM6lJXBM09QohZQVMLl
   5eRgZDT/GTBml2J9Q535SHkBppA8TVZJwDfPLVQPW9YTyuPb7LFSsWCRP
   tB5k+BOzhQSCLUiVoVNjEZS4j/U2stXeRwhtOLN+wK28BlGz2TdXzvoXi
   MSJq7y74XyiH+0pLe+hESsI/jtXTh72fCso9r+KV3RUdQFTcMc6RBahX2
   tS2DT2wGkvYrACletfUgJ2hHZqeFV8bY/MkeFYImL9sobyld0I3iTWLGe
   A==;
X-CSE-ConnectionGUID: QNa7/GWzTEOJ5Qor/XUkfw==
X-CSE-MsgGUID: sYhwOMVRS3euJB7yslMyxQ==
X-IronPort-AV: E=Sophos;i="6.23,112,1770566400"; 
   d="scan'208";a="142240387"
Received: from mail-southcentralusazon11011037.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Mar 2026 18:42:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=keS2eQEFPhBZI+Dd5yekJfxSmR9dVHELbY/tud32XfSOyTh/e39Yrf+Q1KoJ6g19L+H/LcMlg9xyr3SkrPEN/YFEidU4YTKWBt2odlMv8P5v7d3Sr/ChZ+6Pnnr1DjRLgVrW9cXb4xIRk28hmXq6RQg+cAnsDK4PxcI0hpvXupgk2xe94rRi3472ZkW+9g++9UHGO3fUNh7fEnDMh/L94MRbvh+r/1roMYjLm3kezyq3l7+0Rxp7IGs8K5JvT+SVpagpPSXphEXTQlGc1hU4ACIJi1c5GiwqhPjFQXqGx6U8cyAnFrYcgEEMKThaT0QiPxeiwtpSMj9Zh+e8NrmUpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gd/YDC0ihdBBhBTFLSV80H31wn5sE06jQ5IhYCmoijE=;
 b=v6s+BaZRg7YjNGN7RUTD5J9QR/LqQ+ZvWIz9dssWKZESXgxLUwEYJQA7Ti0BuoLULEij2neoQs+Ax+8wa+1l0i+ouhx0n75eS0JjuM0Wtv31X9BDocoY1wHd05HI+4U9yjj9UZRlMtSE8e29+c/qRnMCGLS6hsidXpQbIvMu+QLhS1ERvNfeEorVp9fPU+fevQ6Xxm5L7CAztLoscAPUNkVoyMFBEUMufJeRkJRGbhYtCYlbKVpsB4Vhwhy06PgNjP4SuYAKQr08O1s7Fxouk/IBONqt8/HZxk+MYBfDKm4cm5TSKhTBVjZWlQQ51jTHVh7df4szhpruZJJn5eK1KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gd/YDC0ihdBBhBTFLSV80H31wn5sE06jQ5IhYCmoijE=;
 b=BdrOeBnl84sw2DL0ZT4Q0loBHZets+JP4AthdQm8XSvrCCycLu1dS7wGrd8HCUz+ml9kPQA48FpfZkEeCrDocsa75E1z7jpNoZnN0g6I8oPfmwJRXce/2dS3nvTwt4E2ZbOa0lbBhRzkt1ssOtjKt8ga4pfgc2/jfz6WOaQT3NI=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by SAVPR04MB9958.namprd04.prod.outlook.com (2603:10b6:806:4e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 10:42:28 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9678.024; Tue, 10 Mar 2026
 10:42:28 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: WenRuo Qu <wqu@suse.com>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>
CC: "gality369@gmail.com" <gality369@gmail.com>
Subject: Re: [PATCH 0/2] btrfs: add free space tree checks except for
 FREE_SPACE_BITMAP
Thread-Topic: [PATCH 0/2] btrfs: add free space tree checks except for
 FREE_SPACE_BITMAP
Thread-Index: AQHcsBLo+7zw1+eJPUW+pkV1rGFKJLWnlQgA
Date: Tue, 10 Mar 2026 10:42:28 +0000
Message-ID: <0bd1b44f-cb03-4fa5-bdc7-efddf5d3365d@wdc.com>
References: <cover.1773094579.git.wqu@suse.com>
In-Reply-To: <cover.1773094579.git.wqu@suse.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|SAVPR04MB9958:EE_
x-ms-office365-filtering-correlation-id: 6a835fb2-7bd2-4966-38b7-08de7e91b9c7
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 SmCSwVvDjkXM4c5o5pIYrrS/BMUFFEIVKFuMGK0BjQ239jOWfLVlglmy7mgRfp57+3LyZk3N9fcAZiI8EcxQYGPkSeEe/3tNsQgVe36fX4wm39oUJ5bA1vipcdsWiXdvNt0SU0Y//xEZoe/uhbjNWNtexgCuXbNkieowgIVfy7CdtcXyM+9IdC2JnwORW5NgLKWpjN6iHM33TebUrLuTap+hq93/HMbnQoxqginWTcyL0nS598HFool+e7FP4bMlbwyMGtklTIQ09zUPf1lxc89z2zHWIClkHrPX0lthgt8ItFqRMtNjl/FpdC6YoGd6ZDATue1cH/vsfElqMhG5OeEUv+xErCqFJUVIdHpg12Jx62MsHjyk3Hq/LOorvpKHffFVOPWtBWsAn8N4uyeoP47UfrcJppx3PHkYbSq5XTQhk9FA53FLfzBcdxF/ySqqnY6YXzY7txVYrgF/5HmsgdnyYvbLpDA75pjzBtK/pyezvDfKTFff051dHZfW8asLstdytQM9I+rYJlwu6Ukm+F27awv3RaLBZjYb8CNHhTKMJE9P6bVnDo5flZkaOQ6nncwv2MjUEBK3GczgdatkO05wvJAi1UWoSHun4k9lrRjNqUg3skHuCKf0D1GymBRiPR8rzJYiowTI7iBOtMI94A0AcYOyG60xFmRlmTG4/AvVH6/WzNaGFvX/p+0+F2QgsUTRB1mf9eXKMg0WOqUWMX7kWOuRvhJy7gP0CQNQB7vcWAZyfNrkUwDAFcM+nWJrLJDN14vW3zrVFictVNt7TrjndziwOBQYfE0pbX10mAc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SG1OR2hCa1dmS0dyQW02ODJoZ3AxaFQwTCtPT29Sc0oxL29qUGVQTS9TQnp4?=
 =?utf-8?B?TytuZEJqdy9uQkkrVndiNHJhMFVYWTRHSTVndkRwTEM4V0NFZUE4bGMyVFBp?=
 =?utf-8?B?bUZ5d29DNDBydFFHN3Z0emtVYVlrdGhzZGZGRk9hSGY4VVJrUU5RY3lDRk8r?=
 =?utf-8?B?eVJhNmRqL0J4YU0xS3d3YnluTGhBVWMza0RldHdMVzVCN1VtblNxUm92T0w3?=
 =?utf-8?B?aGVkNmZCNGx1U2RBUVQ0NEEzbVpjcU8xZW5mbXNOdXE4em44dkVETFhFdk5W?=
 =?utf-8?B?cHZXYUxyQ2owcXkxSHJiSW16WFNjSXp4LzZXbEpza1VrZ2E2OHFYOWEvWDBP?=
 =?utf-8?B?aWZLd0I1RzlLdjdpWks3VGcvZU5Fc2x3bEdEeStrWU56ZE5oWGgxZTY5cGMv?=
 =?utf-8?B?U2l5REI1eXJiV29pNk5DWmNlNFBMVkxYSmxtaVhQZW5yYlZJbmZXcUc0QnI5?=
 =?utf-8?B?U2c4azdMc08yVmxjV0RiQUpYSk5WcSsvMHk3ZVhZYXY3cndYQ0JYVEI3eHJU?=
 =?utf-8?B?L3kwN2tjYlFRbE16V0IxaHI5MUk2cVJkSlM2cEVsZlJWd29pVFJ1TWlQc0Ri?=
 =?utf-8?B?UUFuU0cvVFpvUXJpRCtKVkRmYmprVzZqS1Y2dmFBTlk1QUZRZXFzZC90YXkw?=
 =?utf-8?B?eGwzNGp2ZitPRThiUXVQemVOYlY1MndORUthRGtOR1hOUFFaYVNUYm90Qkpa?=
 =?utf-8?B?VHRWRThoTFlaUGJYL21IUWtHcDdvVFdvTnlzeHZnYUZ0OXFhZHRLTjYxUnNa?=
 =?utf-8?B?c1VKVTVZdSsrQUtBUlBSZktPVWh6cGVvcFI5T0lCb1hEbSt5QVU2aTJKWnM2?=
 =?utf-8?B?L2dxVDlXR25GYlNMZ09ablFOcTVjVkRxNGNQUzR2bVNFbktIQzJES0dpb3J2?=
 =?utf-8?B?T0hoMXZ1WnpIb1VKUWRRN1JlOHp0ZklKNmpMRnQrcHhzeWx4WWNObWFRTjJP?=
 =?utf-8?B?NFB6WEFkTFdseTYrVkpza0JwTlkvekhjS2c3NUt4VFVkQk96RFl6ckNmTkJn?=
 =?utf-8?B?OGEyNkFMSFF3UGUrVkZZalZUSFRFVzd4SFd3TlZYWURKcHJha1g1R3VLNjdv?=
 =?utf-8?B?ak1zWEVQRlU1Y0xWb2hZeDd6TDRSVW5UWlhXSHRIaS9EdkxXQWQzUWMxNExJ?=
 =?utf-8?B?QmpLcXg5OFpMcmNvZDR5dHlQSnR3bS8xR1VZVFJmdFcyRmFBTWtQc2Jwenha?=
 =?utf-8?B?TXE4OS8xOTBVYlBQMVM0aUx3OGdZKzJNaS9JbFQvOXhBZEl6QTBWVUFFbmVQ?=
 =?utf-8?B?MThnaHgwai9qVUdsY1hqajE5VTVaZkwvR2F2VTQ1U2R6NHVWbGhYaXZMT3F0?=
 =?utf-8?B?aXU3QjBxQTZVc25iNlJXclRyaGYrQ2hwaC9RbGxtQ0FJRStYTVJMaDA0bngw?=
 =?utf-8?B?ckFkYzFSUkNDUlVlaVlnVkNkTnNIMzR1OFNQKzV3ZnZiRHdDVjdmdE43azQ0?=
 =?utf-8?B?SHZwVVR4dkxKajVqa1VhTlBHbVo2U2pmSzNCcStRUlJzc0hKUGVjYXVLMmNE?=
 =?utf-8?B?L3J5aFF3WXVoUU9JaDBWd3RHWE9LZXMzY3M2RVFtRW9oWTFQR1ZZOWRBVEJN?=
 =?utf-8?B?bmlvYVp3a04yQ0tQbnhIVytvUTdtSlUyclhIajVYczlBckdmeGRaV2c5dVZU?=
 =?utf-8?B?eUVNUDJhTVZ0Rzg1RGRCYjBqWGJPMFVyN2NlbWZ2QS85K2ZtaWFxamwwQnE2?=
 =?utf-8?B?OGNLNWNwY0lBcHhhUXRaS1p3bU5iK01VZjdJeklEbk91Z3p2MGxVdHBmM0xZ?=
 =?utf-8?B?TFE4Wm9BVnlzdlpDZkFGSG5pZ1c2aTBqendBc013NUhEb0Nsd0VnMTAwdGJJ?=
 =?utf-8?B?TWl5U3hIT3NhSXNGdXJYWHcrWWFWUGNNMENvMnBQdGQyUitzSnpVTEJ6UTJi?=
 =?utf-8?B?NnJtMzRsN0M2dUdNdTlTdklMUE5ZdTZnNW95NjdvVjIwYURnMStkSG9tdEE4?=
 =?utf-8?B?amNLZmg0QjkxNzBQK0Jmc3gxR01sRXc3WkFJNUU0NWJmUnFJTXdUVTZSV2FP?=
 =?utf-8?B?MjJaVVBUZDV0UnhkUENkVWc1enlrbkkrY0pZZVV3UzZHZlhMblRvRmFOY0RD?=
 =?utf-8?B?L0JLQzVuVTMzSmNwZE1MQ3AyM1lZTWNUOUEya2dpYlVTcTgwOE9qYms1WURL?=
 =?utf-8?B?VWN3KzY3MFBCOUEvR2NiMHd3NllYOVJRVDdQYzJMNDc3VVpRazlRN05id1BN?=
 =?utf-8?B?c2ltZ3JobXZlOTFoQUtjK3dwbGFZUlIzSmlvaXpNemF0K2ZSdnF5Rkw4REM4?=
 =?utf-8?B?eThLYTFlK3ZOeHErZk04dkZvM1NLbWRXYmJkVWQyYW9YaVNZNEdUdVhRMlcv?=
 =?utf-8?B?RUNWbkM1Ni94Q3pZOVp4RDBxMUk0NlM1NUo4K2hPaHVkR0owK3hENjVndmRE?=
 =?utf-8?Q?D7cPE4MI7O1xJ9QOnG1cAd1SI99oxMlKOfjTuS091FwuK?=
x-ms-exchange-antispam-messagedata-1: eXtRThjx7kjOc3/XCM8mkXO9ixb9NqLQuN8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3345904EC7B9374EA947D5A63E835C03@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	vN21gKs4jQutkxgPc5CtlEG4ohoY3vubQQ3TX8pEyHHCzeatS1L2K2+IGtOXkd6bqeReDDRVsIO/iCqXlQRdJWz5vBKn/Zv3mDTVSlyH5WU7B33xuSUsAxm6bZDbVWbtk0wFr1O7TtJPukTW/DSnlkBcbUIAyMs4JGHoU/yrYzY+w0MFVYEY49TIdWH66VTqGgewrnADfwJACrmScQB9SQYcOnwv+H0F392vC0y5At4U8shM/YB37A5VjcNqDEM76QExasn2XNw3BItrdWZV4nyRxUXmEgf8yOjXZhsj3xeXiCBBth0xZYJEVmLnArfT9AuyhewXutQ2tjF0AZjBug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mII9PgzotowGx62ArXVT9l+Yub8NfGwi5uI3KyVz5YqMOhS4xHfAFH3LIxKfjkJcgaOT3G3etJNzvefgLpQwSRwVbmTCI0pr4WQwaxPBpOJmy2PDF4bEIKtG2ooY7Q5ZB3lIoCGH/h+EVjY9rJ2AIenET5956HjUFH5nDPnncCIsxsRrf+wiTZcfKqZ+d9eUrcs9m1IeWGU26b1MfCCjLbcFDLz98ltg1cfmDTtyKra+WvH06OHBJRV3MuS/ywZR53f6QPKnJZQC95QR9p/nqLOOSWfxMGgg6GBE5lg9Vvrn2BCcGEuxHujviYcP36lBGokhrtnuZsMJNETx72DAji1ZSDdhO6tMjjji6Jgum27snomhU/KsWXDTkqYq/+mw16AdwezX9+eWVXPpJPl2qXi4KyzCYwHqwydese3jljcYgBESQRzHwrdjx/kGA6iQciLUka5QH3KAJh3MrBgXyVmTesym1pT4TiJjsJrMRjwrLtc2BTUHHDagtGzAR7COJWjvHibjcHeV7bS3snrk1jZau1TIz4JcI4tSZFJCQecu4xwXVn6wWfeiEGa7snUZQ/ao24eQxUVZI64RZ7uLjOZiXef4AS6JKm4vwkVcU1RjbmEeB4Lm1z+DGmijAKUx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a835fb2-7bd2-4966-38b7-08de7e91b9c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2026 10:42:28.4757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yH9arl8pF8STWJhJosYuOI6YR4eA8kabG++GtdguGx0cmJtEHpdrzCSayyhwSB45oZhqsRQTxj5bG07VrkFefsNQmylnO7RRudeeo1dI3Dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAVPR04MB9958

QXBhcnQgZnJvbSBzbWFsbCBuaXRwaWNrczoNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1z
aGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+DQoNCg==
