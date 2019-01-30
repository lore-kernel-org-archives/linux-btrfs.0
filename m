Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6C5C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34DAE2087F
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="ZbjflAbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbfA3QiT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:38:19 -0500
Received: from mail-eopbgr140052.outbound.protection.outlook.com ([40.107.14.52]:46497
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbfA3QiS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 11:38:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zdpfoL489FEGNnMS7621f4AfmVMZ1CzvH0GT4XC6DA=;
 b=ZbjflAbzz8p7l76MOHwtMqfcdai1fJGegOkdwEgiCoqjmOnrEF4G/zsiAMUBNbSn+ly+ZVCO6cyU29MPGWvtkOIeKYrKI9uAYR22hE7qbONkGFImrphgxgCT+pMwUneKdK7TmmTqoV4knRlFPsFAiqQT03jUTOi045iMH9b7Llw=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB2857.eurprd06.prod.outlook.com (10.175.32.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Wed, 30 Jan 2019 16:38:15 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44%3]) with mapi id 15.20.1558.023; Wed, 30 Jan 2019
 16:38:15 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Christoph Anton Mitterer <calestyo@scientia.net>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: dm-integrity + mdadm + btrfs = no journal?
Thread-Topic: dm-integrity + mdadm + btrfs = no journal?
Thread-Index: AQHUuCiAG3pi3uHxbUi24d2HBU0LBKXHxooAgAApYwCAABQlAA==
Date:   Wed, 30 Jan 2019 16:38:15 +0000
Message-ID: <c83b2619-240f-4048-7c4d-545226f4ef0a@mendix.com>
References: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
 <5c11b6a4-de3d-2ba0-c5c6-65ea04cd0245@gmail.com>
 <6ce96b57897acb62101dd213f8127ffeb981ee90.camel@scientia.net>
In-Reply-To: <6ce96b57897acb62101dd213f8127ffeb981ee90.camel@scientia.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
x-originating-ip: [85.146.242.35]
x-clientproxiedby: AM5P189CA0001.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:206:15::14) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB2857;6:piKrMMi67EMr3w2p1gf+jmxIlQZOXznpVhwc+FUa1ha6Guof76Xqr+DebNphZJ3sZccMYmOqvLnCnkPq40OO2nbsRp7aKacvZRE+LPAYmVOGWTJU/IiuAgc9aexa5x85oXsostObjaQaFXIQxumC0t7CWELgTjq4Ao0V6MfjnoY0pJSIRW7ziDHVEay6GNhXUBV1uVrLa/auVi/y+wnt4o2KzFYhmNeFVa1QgNWp3IyzYGn1zdUnoruMpDd8RS/VYAFE2wTvhNtMLtd7jwCiC60PnKmfykeza2IQOLDu70MestSjIO3sswa09ifNRM+WDejvDBmfWdWw4LkDnCbGZbOjZoqm1oiUCxGbJCxvPRrIXCJGZQOxiq6wLZCi6heu07X7HXfQyeD0x2umiwPJcCbt3dEJQ3PkbA6+qKazA7WI07mAgdxkoO5a7HvrXaVBt5fomJf8MO49ywji8AqEVg==;5:JnsaRTaTDBwanBxZ/qJiQs2zqrSScDLRlaplfi9VatdGZAmPKGIYz/8zoW002fl653toEjS0CfH7Xs6YZg8iIk1zPOzdpStHxt2OWzsgFRRMzL5uqwbsDY5wstXBoFsKr64KjRBfgEy5SG/g6DtJpBriOHrOmXTgkwrwSIY/okWEvV4PwcOY1MQyHAFCfJie5M8EJ3kdmWvGViQrPGIWMA==;7:q1xUegqJ1CGyinXZ7oD3TwfRVnadCutQY2p1cunRqHG5SCQ/KUzTsvlJDzIpFA2PwHWVaWgTRVsw7pOBa2Ede4X8aAaBCZL3nAinQ3RuOqR6qG02DFr75hphMzvaSYhcSC5TRbWj8zn3K7qaov5cIA==
x-ms-office365-filtering-correlation-id: 75478ec8-670a-45de-dbf4-08d686d154fc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:HE1PR0602MB2857;
x-ms-traffictypediagnostic: HE1PR0602MB2857:
x-microsoft-antispam-prvs: <HE1PR0602MB2857AD1DCB84D917DD9CFF0FD4900@HE1PR0602MB2857.eurprd06.prod.outlook.com>
x-forefront-prvs: 0933E9FD8D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39850400004)(346002)(376002)(366004)(136003)(199004)(189003)(11346002)(446003)(966005)(31686004)(256004)(14444005)(476003)(486006)(52116002)(58126008)(316002)(2616005)(110136005)(186003)(26005)(72206003)(99286004)(68736007)(66066001)(478600001)(65956001)(65806001)(64126003)(65826007)(76176011)(102836004)(8676002)(71190400001)(53936002)(86362001)(6116002)(14454004)(3846002)(229853002)(8936002)(97736004)(105586002)(39060400002)(6246003)(71200400001)(106356001)(305945005)(25786009)(81166006)(31696002)(6506007)(36756003)(7736002)(2906002)(6436002)(53546011)(386003)(81156014)(6306002)(6486002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB2857;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QnWnJiMbthiriuP+AE0LzQTZaAapaOozjGnLyXj3tKvoRBCtz5SAz++PMP9RQtc+DWNuk02sa0coFZoPf0WxWsvkm8xcASHUPW8BAEMmncMFoLwHxcrZVZIbk+qLTShMBgf3jQ0/ySEN0slXvnOnhS47UjFhUZa4foXEmIetaQ0sYot32aNvuLIygYBZE4f3k2J3WLUKll/J3j5zKF+kaDJKR55Q5rdGMu04QJtbssDBHIyGjEVYIrw7B0hCQCzM6xYbGG4RGGr76LkCT4F6enWfBgc+1Xjp8raHPNaJEQROp0asHxVRVqMUK1H57sxMOPdSFB9YIShnpzUUw1F1xp6xpKUkGuUowlZhxYfaAAyTbs6uyOSySXuNW1J0WX1VvyNrweNWlCfgLsdl/2lgOvhdOKqytePQ9qBnebGli+s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75FB2E646EBF274886C15C3064846CFD@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75478ec8-670a-45de-dbf4-08d686d154fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2019 16:38:14.9617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB2857
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMS8zMC8xOSA0OjI2IFBNLCBDaHJpc3RvcGggQW50b24gTWl0dGVyZXIgd3JvdGU6DQo+IE9u
IFdlZCwgMjAxOS0wMS0zMCBhdCAwNzo1OCAtMDUwMCwgQXVzdGluIFMuIEhlbW1lbGdhcm4gd3Jv
dGU6DQo+PiBSdW5uaW5nIGRtLWludGVncml0eSB3aXRob3V0IGEgam91cm5hbCBpcyByb3VnaGx5
IGVxdWl2YWxlbnQgdG8NCj4+IHVzaW5nIA0KPj4gdGhlIG5vYmFycmllciBtb3VudCBvcHRpb24g
KHRoZSBqb3VybmFsIGlzIHVzZWQgdG8gcHJvdmlkZSB0aGUgc2FtZSANCj4+IGd1YXJhbnRlZXMg
dGhhdCBiYXJyaWVycyBkbykuICBJT1csIGRvbid0IGRvIHRoaXMgdW5sZXNzIHlvdSBhcmUNCj4+
IHdpbGxpbmcgDQo+PiB0byBsb3NlIHRoZSB3aG9sZSB2b2x1bWUuDQo+IA0KPiBUaGF0IHNvdW5k
cyBhIGJpdCBzdHJhbmdlIHRvIG1lLg0KPiANCj4gTXkgdW5kZXJzdGFuZGluZyB3YXMgdGhhdCB0
aGUgaWRlYSBvZiBiZWluZyBhYmxlIHRvIGRpc2FibGUgdGhlIGpvdXJuYWwNCj4gb2YgZG0taW50
ZWdyaXR5IHdhcyBqdXN0IHRvIGF2b2lkIGFueSBkb3VibGUgd29yaywgaWYgZXF1aXZhbGVudA0K
PiBndWFyYW50ZWVzIGFyZSBhbHJlYWR5IGdpdmVuIGJ5IGhpZ2hlciBsZXZlbHMuDQo+IA0KPiBJ
ZiBidHJmcyBpcyBieSBpdHNlbGYgYWxyZWFkeSBzYWZlIChieSB1c2luZyBiYXJyaWVycyksIHRo
ZW4gSSdkIGhhdmUNCj4gZXhwZWN0ZWQgdGhhdCBub3QgdHJhbnNhY3Rpb24gaXMgY29tbWl0dGVk
LCB1bmxlc3MgaXQgZ290IHRocm91Z2ggYWxsDQo+IGxvd2VyIGxheWVycy4uLiBzbyBlaXRoZXIg
ZXZlcnl0aGluZyB3b3JrcyB3ZWxsIG9uIHRoZSBkbS1pbnRlZ3JpdHkNCj4gYmFzZSAoYW5kIHRo
dXMgbm8gam91cm5hbCBpcyBuZWVkZWQpLi4uIG9yIGl0IGZhaWxzIHRoZXJlLi4uIGJ1dCB0aGVu
DQo+IGJ0cmZzIHdvdWxkIGFscmVhZHkgc2FmZSBieSBpdCdzIG93biBtZWFucyAoYmFycmllcnMg
KyBDb1cpPw0KDQpUaGlzLiBFeGFjdGx5IHRoaXMuDQoNClRoZSByZWFzb24gdGhhdCB0aGlzIGpv
dXJuYWwgb2YgZG0taW50ZWdyaXR5IGhhcyB0byBiZSB1c2VkIGlzIGJlY2F1c2UNCmRhdGEgYW5k
IHRoZSBjaGVja3N1bSBvZiB0aGF0IGRhdGEgZ2V0cyB3cml0dGVuIGluIHR3byBkaWZmZXJlbnQg
cGxhY2VzLg0KVGhlIHJlc3VsdCBvZiB1c2luZyBpdCBpcyB0aGF0IHlvdSdsbCBhbHdheXMgcmVh
ZCBiYWNrIGRhdGEgd2l0aA0KbWF0Y2hpbmcgY2hlY2tzdW1zLCBlaXRoZXIgdGhlIHByZXZpb3Vz
IGRhdGEsIG9yIHRoZSBuZXcgZGF0YS4NCg0KaHR0cHM6Ly9hcnhpdi5vcmcvcGRmLzE4MDcuMDAz
MDkucGRmDQpTZWUgU2VjdGlvbiA0LjQgIlJlY292ZXJ5IG9uIFdyaXRlIEZhaWx1cmUiLg0KDQoi
QSBkZXZpY2UgbXVzdCBwcm92aWRlIGF0b21pYyB1cGRhdGluZyBvZiBib3RoIGRhdGEgYW5kIG1l
dGFkYXRhLiAgQQ0Kc2l0dWF0aW9uIGluIHdoaWNoIG9uZSBwYXJ0IGlzIHdyaXR0ZW4gdG8gbWVk
aWEgd2hpbGUgYW5vdGhlciBwYXJ0DQpmYWlsZWQgbXVzdCBub3Qgb2NjdXIuIg0KDQpOb3csIHRo
ZSBncmVhdCB0aGluZyBoZXJlIGlzIHRoYXQgYnRyZnMgZG9lcyBub3Qgb3ZlcndyaXRlIGRpc2sg
ZGF0YSBpbg0KcGxhY2UuIEl0IHdyaXRlcyBvdXQgbmV3IGRhdGEsIG1ldGFkYXRhIGFuZCB0aGVu
IHRoZSBzdXBlcmJsb2NrLiBTbywNCmUuZy4gb24gcG93ZXIgbG9zcywgSSBkb24ndCBjYXJlIGFi
b3V0IHdoYXRldmVyIGhhcHBlbmVkIHRvIHdyaXRlcyB0aGF0DQphcmUgbm90IHZpc2libGUgYmVj
YXVzZSB0aGUgc3VwZXJibG9jayB3YXMgbmV2ZXIgd3JpdHRlbj8gQnRyZnMgd2lsbCBub3QNCnJl
YWQgdGhlc2UgZGlzayBzZWN0b3JzIGJhY2ssIGJlY2F1c2UgaXQncyB1bnVzZWQgc3BhY2UuDQoN
CkFsc28sIGl0J3Mgbm90IGEgd3JpdGUgaG9sZSBsaWtlIGluIFJBSUQ1NiwgYmVjYXVzZSB3aGVu
ICJwdWxsaW5nIHRoZQ0KcGx1ZyIgYmV0d2VlbiB3cml0aW5nIG91dCBkYXRhIGFuZCBtZXRhZGF0
YSwgdGhlIGNoZWNrc3VtcyBvZiBvbGRlcg0KZXhpc3RpbmcgZGF0YSBzZWN0b3JzIGFyZSBub3Qg
Y29ycnVwdGVkLCBvbmx5IG5ldyB3cml0ZXMgdGhhdCB3ZXJlIGluDQpmbGlnaHQuLi4gSSB0aGlu
ay4uLiBCdXQgdGhlIHRoZSBwZGYgaXMgc3RpbGwgbWVudGlvbmluZyAoYWxzbyBpbiA0LjQpDQoi
RnVydGhlcm1vcmUsIG1ldGFkYXRhIHNlY3RvcnMgYXJlIHBhY2tlZCB3aXRoIHRhZ3MgZm9yIG11
bHRpcGxlDQpzZWN0b3JzOyB0aHVzLCBhIHdyaXRlIGZhaWx1cmUgbXVzdCBub3QgY2F1c2UgYW4g
aW50ZWdyaXR5IHZhbGlkYXRpb24NCmZhaWx1cmUgZm9yIG90aGVyIHNlY3RvcnMiLiBGcm9tIHRo
ZSBkZXNpZ24sIEkgY2FuIGhvd2V2ZXIgbm90IHNlZSBob3cNCnRoaXMgY291bGQgaGFwcGVuLg0K
DQpJIGFza2VkIG9uIGRtLWRldmVsIGxpc3QgYSB3aGlsZSBhZ28gYWJvdXQgdGhpcywgYnV0IHRo
ZSBtYWlsaW5nIGxpc3QNCnBvc3QgbmV2ZXIgZ290IGFueSByZXBseS4NCg0KSGFucw0K
