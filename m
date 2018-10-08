Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB2FC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 22:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00D7020841
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 22:20:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="d0coKI5b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00D7020841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbeJIFev (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 01:34:51 -0400
Received: from mail-eopbgr00048.outbound.protection.outlook.com ([40.107.0.48]:45797
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbeJIFeu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 01:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM/pI/sajAByBmEapak/TXqdiANUjUr7QI/H19uDAdE=;
 b=d0coKI5baCPyvT7uNYJDkqjsQYQHwhO2UcMdLmwbf9LGy9RZsWjP/uZUGqSEVGgtvpgrmZyv5jj1cgy8w16pmZfCfLT6vj5eidJvwraPZQ3yFvbvv7y8nRimcO0+0yAIIQ+ODTLsRkQqPBp4W3bC/afm0ohbOSBpK15LIjWf54c=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4371.eurprd06.prod.outlook.com (52.135.150.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.26; Mon, 8 Oct 2018 22:20:53 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Mon, 8 Oct 2018
 22:20:53 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] btrfs-progs: lowmem check: Add dev_item check for
 used bytes and total bytes
Thread-Topic: [PATCH v3 4/6] btrfs-progs: lowmem check: Add dev_item check for
 used bytes and total bytes
Thread-Index: AQHUXwLGruo5PAspCE6ya/8CkSvwHqUV7FGA
Date:   Mon, 8 Oct 2018 22:20:53 +0000
Message-ID: <cd511cfa-baa2-6a13-2802-6eac1f47d8bb@mendix.com>
References: <20181008123044.13413-1-wqu@suse.com>
 <20181008123044.13413-5-wqu@suse.com>
In-Reply-To: <20181008123044.13413-5-wqu@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: HE1PR07CA0002.eurprd07.prod.outlook.com
 (2603:10a6:7:67::12) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4371;6:JWQcw+42x6rqCwEa8mBFft5mh3aJzUCdchYq7EUOfjhAuT5/F7EZHvM4jptjaFCjPjIFbS90sMlt6Ky7uZcfOQU2714EF1XTqBDmykkGLt0PTDmVPuCZNKTu1e6F6aGmZwSMvya+gW1fA23Gx9vH7fdxC3zYT1Byhsnoiq0jnsLoL7Tya8aLtdrgi9TPH5v8+bS+QIEz9/CPOhumCFwn8Lp1E5WNJiXSQjjFh1KVkcs0tD8APDN/d20FE2FcYBJjcNh5+OmTDN75YRLt6keuPro/9tYsYADLRujphp5ih79FTZEycbKNC3+tNOJtH8n2RfvNMx4FctWViCfk9N54dAgFpW3lsJHau5ty4hkKyiNS8ByIuaUbbhcTH/N9tYG1wgIVlYnJ/nPg0Y/mYSOT8pg6pwSIjkQ5quEqRf9tE52JRPURzvkeDHspYvLzkQfQbugAC8RHteHZfR9wk6G3+A==;5:gQMBaa3/+RV5XGdOrz2tKsGDn3b5mwK1r3POcM6eAv8HLXDNOQS0qqWJcsZIhNZgVrfHJuyr+yvXGWsILHrX7co3OYTU+qku5E+AvRWhvcLlrbTx803VpCDMa3bWomEigj9sp0+bPyE4v+BkH8QfyWdoYAmqP/3LZkDCkOm4Z6U=;7:adl6Yw6Y69p06vUrgHPT/teMa9XxQA8zLz706+5A3byQ3QsRsEb/Vo+4Lt1wmy1G/JfnO5WrpoQoEK3Ui9tfs/4hA7XegKTrCZZDFP8vxWDbHZQBhHUEDLDAcOUjeXWekceonz4A5PYgMR9cWxhDPJ68mvI9yUVdJCglec47NtD1fOodn5PlgNNPdxd8KauCUC1DbjXrvg68YHAIqsjWrlAoUz8laDbDKWBTUGwBPOYy/BoCJOZM+9RRnHIUTsXT
x-ms-office365-filtering-correlation-id: 0d19f4f2-637e-49c2-05f9-08d62d6c4f88
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB4371;
x-ms-traffictypediagnostic: AM0PR06MB4371:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-microsoft-antispam-prvs: <AM0PR06MB4371D400E0FB60C3986BA1EDD4E60@AM0PR06MB4371.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991055);SRVR:AM0PR06MB4371;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4371;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(346002)(366004)(376002)(396003)(136003)(199004)(189003)(6246003)(58126008)(11346002)(2616005)(486006)(36756003)(6512007)(446003)(476003)(5660300001)(65826007)(46003)(2906002)(2501003)(68736007)(5250100002)(64126003)(6116002)(106356001)(105586002)(7736002)(305945005)(8936002)(6506007)(81166006)(81156014)(6486002)(478600001)(86362001)(52116002)(71190400001)(71200400001)(25786009)(110136005)(256004)(53546011)(2900100001)(65806001)(31696002)(65956001)(6436002)(14454004)(31686004)(186003)(386003)(72206003)(102836004)(99286004)(76176011)(97736004)(53936002)(229853002)(8676002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4371;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: fsSPPBa9Ey9/betzaGhoR9+E6QUxtsgp3Xaf0476Xm5Dtx4j1WPxYxB3vEwIfFD94dvQeYkUkWK25JcLaK+qfr+2G5cN7X2EeN5AhFFi7Whi5PQmdyvHM1EGAZI/5kP6tS2BYPPI3JAO02qTiXKO35+EnrX8PQbL163dQmvosEY5ggSe4YV6UYbctVG3tvOazenbQHhcZ0R7JiZ/m5W29nxnmoI1nFD4PrTx6xnn8rs4/ygwjzT0P4lFojAAERHiX74d9rhwuXChby3M3NL9oc0v+Ool8c06liR0bcDixCISQhYQyOMJu+4oUjkqBucQAtjhHtU/HkH0TwXCDn9gf2LtBOAAObIxJwnPTIyoZtc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D58D7411E6E3B4BB74EE757FC665F73@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d19f4f2-637e-49c2-05f9-08d62d6c4f88
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 22:20:53.8770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4371
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDgvMjAxOCAwMjozMCBQTSwgUXUgV2VucnVvIHdyb3RlOg0KPiBPYnZpb3VzbHksIHVz
ZWQgYnl0ZXMgY2FuJ3QgYmUgbGFyZ2VyIHRoYW4gdG90YWwgYnl0ZXMuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBRdSBXZW5ydW8gPHdxdUBzdXNlLmNvbT4NCj4gLS0tDQo+ICBjaGVjay9tb2RlLWxv
d21lbS5jIHwgNSArKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2NoZWNrL21vZGUtbG93bWVtLmMgYi9jaGVjay9tb2RlLWxvd21lbS5j
DQo+IGluZGV4IDA3YzAzY2FkNzdhZi4uMTE3M2I5NjNiOGYzIDEwMDY0NA0KPiAtLS0gYS9jaGVj
ay9tb2RlLWxvd21lbS5jDQo+ICsrKyBiL2NoZWNrL21vZGUtbG93bWVtLmMNCj4gQEAgLTQwNzQs
NiArNDA3NCwxMSBAQCBzdGF0aWMgaW50IGNoZWNrX2Rldl9pdGVtKHN0cnVjdCBidHJmc19mc19p
bmZvICpmc19pbmZvLA0KPiAgCXVzZWQgPSBidHJmc19kZXZpY2VfYnl0ZXNfdXNlZChlYiwgZGV2
X2l0ZW0pOw0KPiAgCXRvdGFsX2J5dGVzID0gYnRyZnNfZGV2aWNlX3RvdGFsX2J5dGVzKGViLCBk
ZXZfaXRlbSk7DQo+ICANCj4gKwlpZiAodXNlZCA+IHRvdGFsX2J5dGVzKSB7DQo+ICsJCWVycm9y
KCJkZXZpY2UgJWxsdSBoYXMgaW5jb3JyZWN0IHVzZWQgYnl0ZXMgJWxsdSA+IHRvdGFsIGJ5dGVz
ICVsbHUiLA0KPiArCQkJZGV2X2lkLCB1c2VkLCB0b3RhbF9ieXRlcyk7DQo+ICsJCXJldHVybiBB
Q0NPVU5USU5HX01JU01BVENIOw0KDQpUaGUgbWVzc2FnZSBhbmQgcmV0dXJuIGNvZGUgcG9pbnQg
YXQgYW4gZXJyb3IgaW4gYWNjb3VudGluZyBsb2dpYy4NCg0KSG93ZXZlciwgaWYgeW91IGhhdmUg
YSBmdWxseSBhbGxvY2F0ZWQgZGV2aWNlIGFuZCBhIERVUCBjaHVuayBlbmRpbmcNCmJleW9uZCBk
ZXZpY2UsIHRoZW4gaGF2aW5nIHVzZWQgPiB0b3RhbF9ieXRlcyBpcyBleHBlY3RlZC4uLg0KDQpT
byBtYXliZSB0aGVyZSdzIHR3byBwb3NzaWJpbGl0aWVzLi4uIFRoZXJlJ3MgYW4gZXJyb3IgaW4g
dGhlIGFjY291bnRpbmcNCmxvZ2ljLCBvciB0aGVyZSdzIGFuICJvdmVyLWFsbG9jYXRpb24iLCB3
aGljaCBpcyBhbm90aGVyIHR5cGUgb2YgaXNzdWUNCndoaWNoIHByb2R1Y2VzIHVzZWQgPiB0b3Rh
bCB3aXRoIGNvcnJlY3QgYWNjb3VudGluZyBsb2dpYy4NCg0KPiArCX0NCj4gIAlrZXkub2JqZWN0
aWQgPSBkZXZfaWQ7DQo+ICAJa2V5LnR5cGUgPSBCVFJGU19ERVZfRVhURU5UX0tFWTsNCj4gIAlr
ZXkub2Zmc2V0ID0gMDsNCj4gDQoNCg0KLS0gDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=
