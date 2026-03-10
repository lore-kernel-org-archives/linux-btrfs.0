Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1893E717E
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 07:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773127376; cv=fail; b=sXmXGueeEUi2UAcGwg+0vocX+sMFR/yt/kabldT67CQT6+Tau41fPPTNdMDgZQwyZmzSe025WtGTSuMCTzEghzgNZpQrjRoD8koJubRV0wru9kizdaYWYgy/DIbi6mpflV3kogYZkAQBTv96oAZR5R7W5zjr9Rr1bs3xG/U7pw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773127376; c=relaxed/simple;
	bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gijzuaJOd8n0fCrI1/GuuVULnIGAz0lRNogGT70X703nAynDD1YgV0BBl14zNDcrRSi0FQwqdCrv5/ufHv4Yc8afFfX6jTFkPQXLQA7J6rVoKHP95jJiuuXdCt+E3uMjZCaPoPuPf3sFFdLtPRxbQrSAAq97WVkfwGMPZUhFMFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qWgDfzcR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=q++n4cBt; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qWgDfzcR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="q++n4cBt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773127375; x=1804663375;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
  b=qWgDfzcRWFZqN1PG40NEl/j0cmsa2vQ9wQygFbJg3vwCzQDkzclZxHoU
   scAdengbu0aGgH2EfRs60DXO8IYRQwXLBMDWflG3y/0GHiJ/t/ziBEcJ1
   aw1HOSJ4PBeNeVoGgR10jadcmSlJZBIo66WgO9HEGFuJVWdiMENPT2+yz
   0nk9Z3G9Xa6JhBUyvT2AAiO6vXkJsvAAtxE1fX5IYr6T+MPAf5YJraKY7
   qV9dLQ5yzZDjHbNdZIp/5EvoNzDW0S4C3Cm3zCASRCBLSD7n2Q6/fdjE4
   gLQrWtB7i4E16ae9ZDWV8jgzitb1Pi60ZtzX0Dtsxew0eoZPyIM5GJFTM
   g==;
X-CSE-ConnectionGUID: 1JVVqGMJQaaOeGrV0Y5edw==
X-CSE-MsgGUID: pQ90bUAKQraNGrWXo8R2vw==
X-IronPort-AV: E=Sophos;i="6.23,111,1770566400"; 
   d="scan'208";a="142761128"
Received: from mail-southcentralusazon11011068.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Mar 2026 15:22:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQ6tBu3SWP+nFohb76mrysHpbxjWTtGN55dDiUzcGPeuqS9/Lyz/tYB2IR1Ii6RaR1/+V47eqrPEFjn5lE9/y7VkEtSy47DX8yWl+TlQa3mwapNa40baqQxpk0IgzCttaqY8T1DgTGx4ssWyG6Gu2djP4kXbxlExm9sBoPLEMylgsdwbczXMq7T4ip3KYrwf3sA18b6rXggjjrDYtqQrG5O58K7r163LlEaEf1yHEykS4kP8St/D6cCrM+8S8CfI/iKD7fATTisFer3sutMos3a2/4Vn0E+st6Vm4XxfM55etpsy0CHyZ8aNa8t7u+YrKkoJl1LRpp3kcs2gEnVNIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=SQebpKPSYGuDx1W7GH2iPhpdhpL5oxoFJyNQSe+rnvkQzmccndC+P27amg/LR2DZyMe+46zGVQq+Hz6zVjSX3B2gCq3+4Rxm3qqtxF2uUYALOmJuPMFDy1ARybYOMSjahGrSZq8GlXCf3N/Gxd25/vZw2hxJo2nXrA03eTzML9tkXNbLilzDFSx9c3U9Z5kkwbN8GDXgHKr2oXxcngFK2Er+UOmYlPMKYci/sH9Gb7WsPhY2wh7IgsZ+9MZaQJBdje70ypkCJ8GpVkR4Zuk8GiDr669XtSl/DjrN+F7mfq63x0DMzSjJ9SO+yJFQWqxU/mha1dmf93wO8Q1T/IL5fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=q++n4cBtVqlgp5YYnYX782umjpFyUqnbiltsNogqGi141gVUnK0i+tLSxNSWc9Yc1w4aQ4mtsRtG37KdF/zt5IywJa5v02jqDVwOVV9YtgGMTU2h1VstzciGMhyFBbenIBcwwsM2RnHBYTlWBtntjs0Dm2Vf8JJ3CIe6vOe1Kq4=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by DM8PR04MB7944.namprd04.prod.outlook.com (2603:10b6:8:6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.25; Tue, 10 Mar 2026 07:22:52 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9678.024; Tue, 10 Mar 2026
 07:22:51 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Mark Harmstone <mark@harmstone.com>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] btrfs: fix potential segfault in
 balance_remap_chunks()
Thread-Topic: [PATCH v2] btrfs: fix potential segfault in
 balance_remap_chunks()
Thread-Index: AQHcr/WuE0QYjhsZOUKgToiCFxSHprWnXXyA
Date: Tue, 10 Mar 2026 07:22:51 +0000
Message-ID: <ed4b1add-4e57-4004-ba6b-0054812ee46d@wdc.com>
References: <20260309185050.5895-1-mark@harmstone.com>
In-Reply-To: <20260309185050.5895-1-mark@harmstone.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|DM8PR04MB7944:EE_
x-ms-office365-filtering-correlation-id: 0da7e2a4-859e-45dc-f1ab-08de7e75d721
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|1800799024|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 KUpzwEcM3iMkPJI/ipN1vORIeVQTEbAK9CRzUTDgcTcE5qO/ehEBeR+sXRMIB6aLY0tOwmBM8R1xb0ngRQnZD1Gz3N/QcU7gf/7qJF77gji3l7TN8ewYoymFEAO1GivEdfDFB92iEhWIRQ7ItjgZ29h2iGD8oDS9Zp2jTn+299yhm7/yaqu6efPviTrMO2sVZmHFAib7ryzdPbxupfspJUudsZKUsFnrHieFUH74pL6fcSnb+HLmUlYVHZiGketDUxB4jBU3UfvQT0ZWigmEHxvtaxNYU0LkJmlpOzGQ0rbB7X9mEo2IqR+l7LYgd+qg+lEKCHizBo0IxdfLsbLvWKCyOHTjNVl/KuqNY/7VMzkSx9++g1EHnRWcHzqBAmfUU8aPJnJvwNdJMu7qf/F2hHucMYjXXgo3j6MsomkWU0pMHWgNnH+uukp5rlcEhiR6JHvwdFsWjzwRvpcCROeOn/9m2dU4KE4uKzId9ihnWTA8Se5mWJmlh/ipoWJgqe2i2faaGW5+1D8JcKpMWbTvMOjLUWRbk3hePKQVhVcLO9zXzMcUjMriG9u1UMSgTNoOtZq+bkz5x/2/9w3fOdhbOeuUxlZ8UgJTRG+WhzUPtL29SooJZ8ORTM+DmIMTwgWc4ORPYNwyDaX28vjaIhA+LrGnHYkP4/VNr1v6VWlE+kTZGQ/zAjx+gKSTAe72jqnAony2We/hNh+FXSzL7mnG5C8rJpLcdQih3xZmNaXVukrDgY8KkqvpYHw6erpUSgjyfMCV14vFYJO9fbbnwcdhBY7Gd9N7yBxfDh4giw2dIpE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(1800799024)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a2ZPd0haWEg0SHJZZ21mUHBnNlIxL1VmcEJBQUtrVFgvOXpiWmVra1dIWjht?=
 =?utf-8?B?NVBha3JyWk0vR0ZsZEw2amRCTklTVERxRzVYdlEvWVFma1JEUlJydDVpUFJw?=
 =?utf-8?B?ZjRyYldwbGhBakNhN2tmVWd3RDlJcVRsOEo2M1JMTUtSYkRrKzFqamhQRGg1?=
 =?utf-8?B?bE9xc0dEM2MvMnh2WTlHaDhDeXd5UnZZYmY4QmlqbWU4eXF6WWZnUU5mRHph?=
 =?utf-8?B?bDU4NmJzVUZ1YlhPZVRnT1oxKzJFNXA1OVhrUUNmcDFjWUlmUUVSeGpOdmlj?=
 =?utf-8?B?WE5IK1VVeURDWXlqdUNhZzhYZVhkUFlYSm51TzdaTlhtNEJCdDFuWmptZWda?=
 =?utf-8?B?ZHRwVG1vcXNOVm1vamZRMVpOWVFwSjhIOXdvS0ZqenpIYTlkZmF4VUx5dnhx?=
 =?utf-8?B?RWc1blZ3VFZZRjdnMnpTY25EYWo5bUVJNm0zOFpYUm5PRWtodDUwaFRjUWNY?=
 =?utf-8?B?bFV0eEM5TmR1Qi9YbzlvUWlyaU1hVzVlbElGSWVjLzB3V0Yvbms1dXhLNGoy?=
 =?utf-8?B?UDQzYXBqRHN6eTdRWjdCWC84ZDBXUG9YRTRhdU1qQXV6OTFqejlBVzVpS2tS?=
 =?utf-8?B?YUkyNG1rUmw2WGJTRnhkMURmTm04d0ZXNnF6VlVub21uMXg3TUk0U2d0ZHd3?=
 =?utf-8?B?Z0ZoUlIxcWJxWlFEVWlBY3Q0cG1jZmw4dlpGVUl3THNiMWJ6V0hnS21DMmhk?=
 =?utf-8?B?anpyYmhJNENNbnZQM2h2Q1lSR3RaaXRpQWNCMDNmUzVKZlFucXhyRWJRWDlz?=
 =?utf-8?B?c2JoeENQZFIwQmNiVDB1ZnF4LzR6QmlaWjROYkdOU1g1K2NGL0FGbkVvblhy?=
 =?utf-8?B?QnVrSUxtUy9NZ0kvSTNGWVBKc0pISHVsY09paUpYT2gyQS9kWnF0Zm45OUVD?=
 =?utf-8?B?ODRkT2tPdnhueEEvT3ZxaUNnU2VScHJ6djRJVUsxdlA3QkJnVE9iOTloWGw1?=
 =?utf-8?B?aGFPWGdTVklxUTIzWVgyUFlPM0t0aHN1bVNJK1pOSDNRQ2dvVFV5NVArRG9o?=
 =?utf-8?B?OW50VE9ZQjlBUlB6UVNXWThRcVZsOWlVNjE3UVFJeWFZRVV2Y2RYSlNGUzY0?=
 =?utf-8?B?K1NlRlNCUEdJVkZCNHVienNFOEFoVTRjYlF4cWpUT20vWS9OZGoxNHg5YzR1?=
 =?utf-8?B?Y1RZang3WHJDN3I1WmJZeWh1Q2FDbU9Ub05CTVM4V3dpdXhWOUswU1l3Sk56?=
 =?utf-8?B?NS9ac25vd2wvK3ZxbmRsRWRXam1pZDY5VG5kNnA1Wm5aWUhPRUFEYjhKOTFs?=
 =?utf-8?B?Mk5SbnU1WG1TKzFKMUFrbVA1WGdXdGx5WmIzaXpNNGpHU1JTRkdnVmExWGFY?=
 =?utf-8?B?aStYalVId0IzMCtVS0EzMzF5M0Y2aEVDT2sxVUhGVjh6RVdVNmFBYW8zZUk0?=
 =?utf-8?B?ZXNSZXp1QmFzUHNvaGtUTXBSL0dIK1RDNWo3TG9rZWN1TTN1ODRGYkRtbDhX?=
 =?utf-8?B?VmpwWUQrbWRNcjNjS1dLVnVkdUg4MGVLU3FlbVJvTjdaay93UzJaTFZ1MGR0?=
 =?utf-8?B?cDVZNFgxVDZoU2oxYXpJdCtkU1ltMTJ1bkU2NVRYK0xsUEpLVkpjaVFUdHpu?=
 =?utf-8?B?WVoxU2dvd01ZNlV6SWMwZkd3K3Ewak9GMXBjT1JWU051emZXdXFreERITzNW?=
 =?utf-8?B?Q3NPdXhqTTFZS2N5TlRiRDM3TjJmZDdmVEJxckVkQ1FpY0NwUFZwSXNndEhL?=
 =?utf-8?B?MnRIdklqMjhnVDFWdnExRXRmZkJlckJUc0JPaFVGdENveXVpNTFIRDN3N3VX?=
 =?utf-8?B?S3NIaGdGcVdNaXJNL05KcVMxY3NsS0d4ZkcwdkhNcCtjcEJmSjZSaTErUjlr?=
 =?utf-8?B?bGh2c0ovemU5VDBQUDdQS2g2Q1RrS0I2ajRzYWx2Tnl1Z2NzaCswWmNPenB0?=
 =?utf-8?B?WXluWHU4QzVNNjJwQmw1QWsxbTZIYmhSclBJSDB6aXRHOGJsZUYwQkI1N1Y0?=
 =?utf-8?B?VnRHK1dCYzcvR1Z3Q0NLL0k2VjFVZ0U1SHVEdEFlVWlpYzVKam9oQ0w2bnlw?=
 =?utf-8?B?ZnRlZXNKREFsM2YyVXZNOGZROHdHYzk1eHBzRUtleEgrYlUzMnJwV0JYdXF1?=
 =?utf-8?B?NFgxMkgrRzVJTG9YenZvdzNaTXZRZFJPODdMdVlqbjZsUVVhZG4wLzdSVnd2?=
 =?utf-8?B?Vk5qYkM5SmhTTkg0RW53QjUvM29LNzljQmxWRStRVkdIU3RWK1BHSi9iK2pZ?=
 =?utf-8?B?TWVSczVjRlpobFowR3pnNGoyR3YyVXZEZGNuLytVQVF1c3Voa1pxU05yeUtP?=
 =?utf-8?B?WDBmbEdQeWJIYktnVUxZN2laQ240a2Fzc2hnTGd3aVBNODc2eXFadzducUla?=
 =?utf-8?B?c2w2YmF4ZHIwN3IrOU5GQXdrdkV3MUxlUGdId1BPZlVmUkgwek4yYkJacG5W?=
 =?utf-8?Q?CnkyLsC14Yzg0AoT0UFqw10JBagSmYfZMEcoNfQcMEqzG?=
x-ms-exchange-antispam-messagedata-1: wUqZ7QTpfD6nkKlouSD39wottMWvaUthWmE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <711CEBA65B13BF49B5C922E5A614B714@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	TyVFyzGimwJPikygmoPjG7L0/NcTG1p71mPfuRoTrRFAf1cOf8zBRDWoh6wCUvPswTs4sEKot9FrPJXZdoXQu+CHropoKeALBogNZpITMkQYiuPpU+uwSeAdyCE1v850vE4BEDNdHCyNHr+jkdGmYAMcwPLeoI20WyXoH4mw7HylZyQVpC0djA87u0z+OQh0AsKZw7xlWNOtBhu4gidTUmZVACdEgQEK48q3mcnTdQdcivpU4sfOVKtxaGCGMEnySZ5HoSR4YIaCfvA512ekopsf/seJuk1G931KFpL9Kv1cVNXqpkv5tvxp2hHH5bHvE5BCHvbLvyFzZvYKUWCJNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E2XhemsV3oRRAaGGmu1cjD531T3Ncv0Yb/2Ual6KZ/tEzrYfQUqK0ZNHM+3nehUSsm8kXfCvGN2s5dCOSiTwNzxMCmWdmmQiO9vpKEkrM2NILaI/43DDs7PIVptmeMOK61NonKShVMoaFmth9KWwqGiHQsyxLxF8+2lFWtG/DeK858Vz5zndq/x/TakN1SyUT30rgUdic8qCfFb7TvePqFd6TfI16IV0LUYjeO9Ze+syK/vQj19KKcARvXkDZwTH+YAHHLHJ+N64UUf6HtoJlL7WkkA7g4cLAlr/MKwMyqmvlm3kmAqQT57yxHOmUVsPbDhPuF/afP/TvbEtLcJKvez91QzeRpNGYfrpqo9LBFba3Wwp3rECQb+iFiftRYL7bB2p2R1H7YfxI3i5bTHEmyZ7/08ECRDW/dN+vpqrGk98lQgM3jtyZQKieGO1idWIXAuHGxjkGovTRMUF9MTiL0hXUb0K5ASurGNdEx5PP0rIYyHsbU0xOg6ttXMmeONCwh3+JgynoAWSe1vHm9KFjgYfB73/uVjBgYZxRNJRSzKPzZHIYSMdUkP7ExYGqWDCQvTdFsh1I85zNK9hScyx7TERmzQ0b0EBQfFEY6FDW4+U7pLU3ax5TLwJUG3Vlcm2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da7e2a4-859e-45dc-f1ab-08de7e75d721
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2026 07:22:51.8595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pqG9WVVY2lBQWhlJXRw+mMuQO+dvYaEXQ7df6Aaxlp4wHbWc9gBqcz+qZs4xIJex6OHgrefnbwDqKQmZs4CGLKbmxmi78ovdZv3y5M+PPL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7944

TG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+DQoNCg==
