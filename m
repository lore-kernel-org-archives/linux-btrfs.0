Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD2D372691
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773139306; cv=fail; b=gYga+xzjnZzbSPNxJ2UhqsuJXipgxyjus8CL2O4TCKvqHz/uJ4bOuYz99WoXGnGHTL+ZRyWjizcR2yTX37NbW6mqY8/1hPFC9L+TgEvlA8FGwzUmBe7c9nYi/HrEPbS7Za1xvfFQViTRnxuL9MgT1liIxokwWF0mAwW0bhpj11s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773139306; c=relaxed/simple;
	bh=CFc1ql28QCWxCGjHpvqIUW4Z2cD4wNfX0DByv9se64c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BblDJS/pXHPX84jMlqLs6b10z8oKIMwRekCwTDg0kjsQ568GYLl/zlSnh146PxpJ8bTBqjCAg5OIX519GUeTvOf1KiNRTxh12HvaA8ilmPopFOQSVsIW7ng1ZK4n3sc+l6WL+2bT6fu51A+1JTOqMh+ss50WxcZ+PMVa16KVHtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=L9UJZO2d; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Recgn3lk; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="L9UJZO2d";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Recgn3lk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773139304; x=1804675304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CFc1ql28QCWxCGjHpvqIUW4Z2cD4wNfX0DByv9se64c=;
  b=L9UJZO2diF1qK73W+pm2K7FtVqYMQlYkhDPSshuxCuXI9T3Xbhj2wnmE
   vsatPStk9NR6K58A+yHCuHZFY/NgJwI1QUsa+Q12NPoCCA6qVq1tjeV5P
   0EDa765IuDEsEyImIWZ+MN5kbaXKJsox/WZC09ugoP0QphN2bbyMp+jgZ
   yWvWLm5kwdE0OGBRqS0ebg6YtKmytowPoyrVyeLJS6Eh8AptULPpTbeN+
   o6yjoJNSKtIFItbo2MCngjugkc47NWDQIhBCJp6GZQdUJKYGew/U/Fosf
   jC5JyZSUWTb4jIOBkNp93GHIdnvLofXNetf5w0iDoeWVmo3LWWD210ksk
   Q==;
X-CSE-ConnectionGUID: x2mQia2zSsG9CrHqR3n1kw==
X-CSE-MsgGUID: fG891NEwT5W3xH+Fx9TmHg==
X-IronPort-AV: E=Sophos;i="6.23,112,1770566400"; 
   d="scan'208";a="142770223"
Received: from mail-centralusazon11011027.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Mar 2026 18:41:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mC8ghnuoXzrWUyfBscZAgZlbPZmuRCCE2ajUfuqVSJGNO/hsPQyxjibkj9nKXATyAMIanv1cExMaxgLAksJYrzM/gJqtU3ZKeZD60VFEywRIosqfay1vtwobtDD8DZt4DfZ7lMkvn5VCh0aypGLGEFVE4pTLgjqSq11Peb4Snd8RtggHenj+gQA9PqeVqxkLMnEOtIOCNIH5tWeOiDqgDF5rrkWXHRZ1vDZKeBG8iZJPg3De1XF8jh0fqQ5fEAsAFzVh53rGt143EzGHM/YXzjeV2J9jZ1muKVmmg0SS9SXJNjdC/no9mp2PtDkS2QCjS57d5TIP8XaXBL+GxI8mCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFc1ql28QCWxCGjHpvqIUW4Z2cD4wNfX0DByv9se64c=;
 b=WJnURBlRM4Psjo06cTswHUcJNBojB4nlTQ/TfONxKavpDn6cyieCbruGnIxTJdHkWDRh8ubQERybzjFhrNmfTWbJtB5SIkSKnPp9kMNREgThRkhESwSC8W4tC+FPG2hvXMcDxcioreKwbuVg+ZjX/qcjNhgRSXnx7wvayMyiWjw4je7SliA3sjQNW1XMALS3hO18k9G9DU9NZv+FgLP6fZQLaaAWfA6n+XqPKlG/F6prObpMK2JAdVPUrHIEz3rExXOANGExguPe0DOF49TA7gXU7CC9duJXF49BSg2OWKC+ufCkIYhk4uQcvfdLUzcVQQO8rudHGFL6ux0Tkp5J8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFc1ql28QCWxCGjHpvqIUW4Z2cD4wNfX0DByv9se64c=;
 b=Recgn3lkXXjI/xma09pvF9qcaG749GOoH+N7nCtDx6i1Xycw3wEgoCCeAJulvNPVuv/ansPsw/wews7S7H6s0GhWWMJprj1gOmkoxczlaGXDEd2ljd+tJBgQjTGRquX/M9Y26byOQ9Tq4cm18dTGvZBTsszXifEayMEcL2E46xA=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by SAVPR04MB9958.namprd04.prod.outlook.com (2603:10b6:806:4e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 10:41:42 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9678.024; Tue, 10 Mar 2026
 10:41:42 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: WenRuo Qu <wqu@suse.com>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>
CC: "gality369@gmail.com" <gality369@gmail.com>
Subject: Re: [PATCH 2/2] btrfs: tree-checker: introduce checks for
 FREE_SPACE_EXTENT
Thread-Topic: [PATCH 2/2] btrfs: tree-checker: introduce checks for
 FREE_SPACE_EXTENT
Thread-Index: AQHcsBLmpt4EfDbT4EKln1t7LOIJHrWnlNEA
Date: Tue, 10 Mar 2026 10:41:42 +0000
Message-ID: <d2dce605-7afa-40c8-91b6-3c97eb6d30e3@wdc.com>
References: <cover.1773094579.git.wqu@suse.com>
 <b47f690386fd086fad526c9991cca25479e9df27.1773094579.git.wqu@suse.com>
In-Reply-To:
 <b47f690386fd086fad526c9991cca25479e9df27.1773094579.git.wqu@suse.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|SAVPR04MB9958:EE_
x-ms-office365-filtering-correlation-id: 441b4ea5-6b14-43e0-442a-08de7e919e89
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 B/M5QSsWQcyOmGqhKJHAlfhKRM1aVMPzcWd568yo7EzSkBXcmhie867yGxbZOK3frhQWDutJS+KvkFGZ3xvW5HUZpF+tri8erXSqH46Vg+ac/qiRBxjSG4K8OyQ0DD8bHRDGdNN8ZeqM5859dId0ylJDovVvWmJfpJE4rgWFomE79ZEwk/YR6VtnbO6MZOMbxmNooT5u5Uu5gGGAbgVSycl2vPCshI1Q8lYiAC7fTpK1DAqyBXWom3tXX0RLg60vp0JVO38VlPxurh/LARiKwN5PYRauHGGe+D91PQZOH/U4bGLr3WaZwV4nNrL048YldcrDEdEnN+EyzjAz+Q4thaykptaygdUtLWDz9qLqKplOEORlipiuux25zf1rN948zoRb1Zp/yhLB/N4l6gaoSTJ2OULVdVL5pzJWjiYFrLJ8WgOAy9XS858ksLFGjOASV7kIEicl2rEd24ZPVzJ1XVABCLG8DM0NwuNIL7TwjeugAA/flwPygidJChGIJ/zp+WigDTk4OMWEPfTBuxqcph2xqQTJUpf0/Vh9hON3M6o5qYXj+qkgK4re9ndFLmemIk/cUfc2Qq6sP25uyCDqF6clNqBK6WxLOR+YL+qp4yDZ/GqXAkfjtc/2An7fr+Y/k8UmXh65Oy0V3mGJPK8Ya2BUXRUQ47ZxGWW7TrU0N7RrLf0sarMgoeQzUZfj9s8yj8b+uUY826zfs/WWz+gEPaB2xKWPWeadMyofD/IkxeHhdZQXGgzmjTMvDMSJFfaLJ5vSKm4swhnhVPKSnBGtKRwzTvHegshODVPq0f6mLUk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RnZZdjI5Q1U3UjJDVi9qb0pNQWVaM3drc0xodVYyaHRtOUNoUEp5OXNFcU84?=
 =?utf-8?B?RWRTK3BxSSthQTBya1c3T1FudDRBRXhqL2RRdVdaTDI3QTFFcG14YzdzOTB5?=
 =?utf-8?B?MU5pbm9yQVNsNDVxSXlZRU9kUkxHOWY4Q0JReDdPZkhlcnZzbjIrZlJ2a2xN?=
 =?utf-8?B?U25rZzJxaW5PV2pmVTZqTEpJcDNTK1ZoaHJRVTNBVGdaRXFIamRHejRlRy9W?=
 =?utf-8?B?bXRVZzJsNnBHd3VFdzgyaCt1WDhOQ3p4ZWdXMk5Kd2pHN1JSVlc2d0ZML0VB?=
 =?utf-8?B?Z3JBQlNselc5WHhBZVJpM2tPTWYwY3NuaHVIcTRGdGdKaXZ1cjBtVnlUNnlL?=
 =?utf-8?B?SXI4T0JnS21jTWtaMTlBVGgwTjdYSW1TS2VsMXpyWE1oLzVXOFQveVM5eFNJ?=
 =?utf-8?B?MU5lZllWT1BwcFlxSEpjeXMxRlVHbTA3dk9KbHlqeWkyd3U4bGlBS3dyQlBp?=
 =?utf-8?B?TWVOdVg2bUo1dHNkZEZPOFRGOHkxcVZkWUVUQVBEcUw5bVZVcndzS0gwbE5H?=
 =?utf-8?B?SnJaSnJpWmt2c1pudmk0Uk9SQXR4bjMrd3F4TUNkRWxvWGE2MzIyZFU2TW4w?=
 =?utf-8?B?OUxheHkxKzM5VmM4bkY1eVdqbFNSK3BLQlRhTFRYUUl6Ui8wOXNJbW5vTnMz?=
 =?utf-8?B?OHgzRkpidVJNVXpUNldsbW1CRDliR2lkNW9UYlp1dnp5djExWmRVUVBMTUpu?=
 =?utf-8?B?TzhmODlhNXluNk92dXJaVUM1QTVqaWF4VytxL25MTnd6bEt0YVc5VFZHUVJF?=
 =?utf-8?B?dkRUb05jQ1dYc05QY3lqMVhwazg0Vm9USkNpOUhCRXllR2ZuVHpXTkdNWHl5?=
 =?utf-8?B?S1RtcUJlVlNqY2ZlSzRlS05YOEpRL2ZUeVNJQnRJdUFOZmFlcllMOVVUNEpM?=
 =?utf-8?B?L3VFRjZPSGl3aS8zNmJ2d3M0TytNNEFoWUFEQUNjaHZWTHQ3T0hDMlYrMHVz?=
 =?utf-8?B?UDFaYnc0bGg3UG9QZjZNVXhQK1RsOW9SNkt3cDFGWWlSR1FvN24vd2JRVmIz?=
 =?utf-8?B?TFB2YjVrQXhNODVVdFhYWEpCOEEzdkNHMDdMbUtTVzNNTFZLWDdXbzZkOG5k?=
 =?utf-8?B?dTFVUm9XcmkxKzhmeTYrbndLbTh5RUUrdG80MWRabTFyVE5iQzY0bHZ2c0d2?=
 =?utf-8?B?ZzRGemxraEtMd3ZsVXRWb2JVWjBQcDgxUmR5ZDRaVXNHS3JPc09hN09JS1Ey?=
 =?utf-8?B?bXVOLzduWVRXcE1MNTFzdDhPbEhyQTFxTnYzZERsY1kxT1QrU1JiTmlYbWpa?=
 =?utf-8?B?aE0wUi9zektuazA3SEVCWko3b0hMQk0xbW5xeWdLRWo5T29Odkp4azd6UUU4?=
 =?utf-8?B?S1RBWDFlZG4vQ3k5Wk5nTHZrdG4zT3pOSm9QeUVWR2NyRFFhTGJ5NjlKZjFV?=
 =?utf-8?B?ZVdwUFdFWnlJbmJJYXJaelIvcHdDcjFGMmxKT1c3cXVQa0NxMEQ5WmVXUkFv?=
 =?utf-8?B?UVl4NlgxRmpsMFN6a0J1N1FaOUZQbDBKVmNYblNrTVZuUGhmV2IxOFZ6alZr?=
 =?utf-8?B?ZDJNR2JHUnJvem02Q1pEaU81YXljZHRycVFSemV3UGV3UzNweDZwcVNNWXI3?=
 =?utf-8?B?dkhEQjAwNlBJd05US3hKSWNmOWoxRTl4cXg5SVBuZHRYUDVDdG9GZWErRG9w?=
 =?utf-8?B?OGg4ZExWbUlzc1A2aXJlN1dvMk81aGpmNXVzK0NDTHdZRWJsZllRSHUzYVdZ?=
 =?utf-8?B?V1YySDNJblBidFluTXlIWkQ0TG5GOHpaNnFCRk5OVGJxR3FZRktwTHRvaHJ3?=
 =?utf-8?B?Ymh0bzV6SUFVYVBIeno4REZIbEFJcmVsM1J3NngxRzF3MnI2OUhJMFVYOW1Z?=
 =?utf-8?B?cmZUZWZiRlA5QURYQXVvOENYMStsbmprOUt3NVpkR3Z3RU1RK1hUUnlVc2I0?=
 =?utf-8?B?OXRkYVBQT2FOd0FJaW9Nai9la2RsMWpEUHdnT3BtWitwSndBVzdoV1JDR0h6?=
 =?utf-8?B?OHRmOXBhZFEybFVVbUFFcURyUmxmQmtuL0JWTHhGS3NQTE0zNVJIZUp2RURs?=
 =?utf-8?B?dEVsY0RmRmlxY3hNTVJpR0h0d2JGb2U0WSthUGpsUnU1MW5ZdHF5ZkJ0b0VV?=
 =?utf-8?B?d2R3NDNoSFVQNkhoMURvMVRlTTYyc3hqeUF6R0R3Tm1KMHB3SFZhdUIycEU3?=
 =?utf-8?B?clpOZ1hIcFBIRHRpOFgxNHByQ1VJYTl3ZklVUlBHTlFiSzA1NCtvSFlWS2k0?=
 =?utf-8?B?aVBCbTRTTVNRN0h6Z1d2anNhSTJnUmNrK0RsN0J3SCs4TmFPUUc3SldXOTBV?=
 =?utf-8?B?NHk1QmxLcittTDdhdDhFVUR0QzlUZVZXaGQweWRIQ3JSMGkreHRNd3pkclgy?=
 =?utf-8?B?aWE4clJWbCtKOEpLY0V5Tk0rK2FPVjlEYmpQcTVSeXY4QXZIQ3Q4RXBSSnBV?=
 =?utf-8?Q?dgMABfwOc9QMjFkQFamaDq3mJ3sSjDYAx0ngI7MeFmfQ1?=
x-ms-exchange-antispam-messagedata-1: 2D9+rZxfNvpM0F2G2cbSpPArqI7xnfbNFBQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A156B56B13C800469E8EDFF88CA37A3C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ovFlsH1o5gY6cBuACP09DYcTCVgpTK1juAIkszYegcLk5OS+Jec1goQTZt8gjk3SvQx8rsAdzNy/cwJS14cOXy7iDqhCW5AFfxfFBX+ye9YODIn9fyK2XWvPR7MgyerqRb69mWWM/oVLxV0pLJ2g+Hd8MGotzPSahnpAOidQAEA6aP1v5xHydt0LNbqOnyV0n4BlwoO8eUq9pv2+JhnmR/x5myPQHKowopWftM/DImU+J43t75tofEj7WQSBR/T1J9lcus+ktv8mx8B9eOSvPeok3A+F3kZ2hDUgR87kS635NBhT0hbeHmaY1RUE/B/OsR3e2C1lj6EB8mjzIGN2UA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+G3FoeoMhr0oZX6vo5Hkor44VXxcRHdFI3iwfy5NOeRBgzESL26AES76D6ufx/8QOHkCCX+8yKrrrg4cK6gnknkksit8Q/pBHqqHXP1gGJXvkpcjRUaWpXRZmGU5ZwjAsmZy2IfO46sqQbsYNRu21lC5BYIXdIFRP8adNRHkFSVCmFj/oNF0QSuWVV2pttsHqO+k2KhInXqvbVoQusFue9o/ogK5g5uVpxeSbjelKvG1jkxzN8NfJFNca9xZkfs2k804N5R1Amx65WaoHTUKbud67xCXyO3YJdYBcd/+nL+ObL7aecJP7fFIRIpq3zOKEFyAchDi/y3WcE3L9nHotWWwa9jPLvGGsEJO4i7G9rRsst1rZGZfXBocnP0OHwzYnjlTP5gxpSzRb3noimlHnOulaCupzvdW97jKcKtCzb7ujSMsxaoAJNnLOLKdF9suRuEXE2egDbh9XgzIrSY89PGjsoUI+TO6aIdOzU1BexBftr0c9Lh1o/nsym30rAsnT2P7egDQ8903rFlm9SOf/pZTVEVcBj5B74G/Bss/czs/sjCOlIsqfSChsVbyrg9fngZ1ShRESP7FOBnwBpPIBRgIVXP7b7ggiU1Qkd3MdPEcpxsJmbyi9yUTE6yQ7wSn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 441b4ea5-6b14-43e0-442a-08de7e919e89
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2026 10:41:42.7899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eZb9Njua1iX61G3eSDIUHgStbFGXn0t8Tkjl0FN/ntaME4UutVnlKLfJ4EbRBTYwZR1/EtMqqPhiY6MCFbVVclULBs1tk0YcjIlzGIXX3oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAVPR04MB9958

T24gMy85LzI2IDExOjIwIFBNLCBRdSBXZW5ydW8gd3JvdGU6DQpbLi4uXQ0KPiAgIHRvIHRoZSBm
cw0KPiAgICBibG9jayBzaXplLg0KPg0KPiAtIFRoZSBpdGVtIHNpemUgY2hlY2sNCj4gICAgVGhl
IEZSRUVfU1BBQ0VfRVhURU5UIGl0ZW0gaGFzIHplcm8gc2l6ZS4NCg0KUGVyaGFwczogVGhlIEZS
RUVfU1BBQ0VfRVhURU5UIGl0ZW0gaGFzIGEgc2l6ZSBvZiB6ZXJvPw0KDQpbLi4uXQ0KPiArCWlm
ICh1bmxpa2VseSghSVNfQUxJR05FRChrZXktPm9iamVjdGlkLCBibG9ja3NpemUpIHx8DQo+ICsJ
CSAgICAgIUlTX0FMSUdORUQoa2V5LT5vZmZzZXQsIGJsb2Nrc2l6ZSkpKSB7DQo+ICsJCWdlbmVy
aWNfZXJyKGxlYWYsIHNsb3QsDQo+ICsJCSJmcmVlIHNwYWNlIGV4dGVudCBrZXkgcmFuZ2UgaXMg
bm90IGFsaWduZWQgdG8gJXUsIGhhcyAoJWxsdSAldSAlbGx1KSIsDQo+ICsJCQkgICAgYmxvY2tz
aXplLCBrZXktPm9iamVjdGlkLCBrZXktPnR5cGUsIGtleS0+b2Zmc2V0KTsNCj4gKwkJcmV0dXJu
IC1FVUNMRUFOOw0KPiArCX0NCj4gKw0KQWdhaW4gSSdkIGRvIDIgc2VwYXJhdGUgaWYoKXMgdG8g
aGF2ZSBiZXR0ZXIgZXJyb3IgcmVwb3J0aW5nLg0K
