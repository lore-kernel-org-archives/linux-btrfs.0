Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2047AC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 20:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4133D20C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 20:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="SHsdDuxX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4133D20C0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbeJIDQL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 23:16:11 -0400
Received: from mail-eopbgr60085.outbound.protection.outlook.com ([40.107.6.85]:49184
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726468AbeJIDQL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 23:16:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZToPFxr0VchH4sjz7spwNiH6SFG45mz6PrPRLygCbfY=;
 b=SHsdDuxXdY8Q5rs2xfK09yvnLCzOwB37JGd3yTR5mQ+7UrTQrPDloTQv8buVyvhNIhmYaONmC1LfUQ7iSnUcNZnVl6Gi18jPjBmbapPoQpqct33P64YJu8s6xOcbJDquQieNuAFV+4TeaOQnCrMRJEwmhkoYfk0tj7da9fHr1xE=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4276.eurprd06.prod.outlook.com (52.135.150.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.23; Mon, 8 Oct 2018 20:02:02 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Mon, 8 Oct 2018
 20:02:02 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     =?utf-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?= 
        <holger@applied-asynchrony.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Curious problem: btrfs device stats & unpriviliged access
Thread-Topic: Curious problem: btrfs device stats & unpriviliged access
Thread-Index: AQHUXxMak/ScarELJUS5tWBWYhmxkKUVa38AgAANzICAACY8AP//7NYAgAA5BgA=
Date:   Mon, 8 Oct 2018 20:02:01 +0000
Message-ID: <faab0e97-c853-11dd-243d-021232b0783a@mendix.com>
References: <05c64256-71d3-81dc-3189-628e8cc0a5db@applied-asynchrony.com>
 <5eafba35-c79b-17f2-e296-aafddf06ebf1@mendix.com>
 <7bcc7f99-a857-6ef1-d2df-a256424d2b29@applied-asynchrony.com>
 <650dd0a2-f945-163d-d44b-db0f1cf21ac1@mendix.com>
 <c13f4c95-ab2e-911d-6476-7f93f9c1e2c9@applied-asynchrony.com>
In-Reply-To: <c13f4c95-ab2e-911d-6476-7f93f9c1e2c9@applied-asynchrony.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: VI1PR0802CA0003.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::13) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4276;6:MhO68WaiEfSKw02LVuyY7bSvo6STujSpnvjQaJAvCw20BOFyLXQZ6jTaUXMPDln+7cJgG4qubhfvM43avrMZ3pB2b8WrmXPyJhgyMqlJ3/1SAEp1H4HMDyshJbB3TsMXn+gbPnJznrgdC807NMuE1/F/8QtGpo1g6VrPcIoENHlbimY/gdPs8bb7v2UW0tTbO1qMBEM6VkZf6lmFN85T/rk9TuVw4IheoOXMtHtvE3TKLt2biELJj8Skyuy1hpl7J0Q/PNgohrVNvT14QnNSgy1BoDgP/TUUxGOfZJkiH2SiObt/z1aBg57Iq8qlj0pnaGsuR4hFcIRPwgwecRwh1dHXr656/kXbFAW660TZINSnaRGiU8jPAML3iXl896BXoD4VbBP3pnSUGiSuprCytsJdZ59lnbGwxhuUmIQTI0pox2dkp039mzlMfmvjPEX16XfIi5Szeho8hT/4P6BQhA==;5:V76/2bpXWHFG/FHys2VO9JiSkR1iIUXMVbaWQvrs3qZ8br/qGYwYD88NlZOlvoJnDAVkO6i/ZH63zLza6SL3fjLofQbsTVos/sA8MwNCZypGD0FLQ7taJ/mW7QbUaar+Ma22J/ZHFzA1HduFZyY09uyjwNBcV9Lq77N3j24ZM3Y=;7:LogmNzPzZoSQwvxQVrKyGjMeC97JNQuHIQGbBI6e2Lkna324MZ5DEbX5mSiXnPvPn+pIMXhLYE+Rb664k1KRunLPHj+2ww5E5clMz+cfW4j2/3N1rgryDpBdp57VwWRJmFFe3jntrJS7CrVSWb7PDQ+QHvsIgbz6UIN7f7vrleNqfLeN9uOeKkaXTO7zFjFDGmyli4cp276Qe/2tU2h8r2BxfFl6ZtO6dCg/e4znFM+KX5fKxdoTAsDwVbZ4A94j
x-ms-office365-filtering-correlation-id: 63fe940f-250c-4935-8549-08d62d58e95a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB4276;
x-ms-traffictypediagnostic: AM0PR06MB4276:
x-microsoft-antispam-prvs: <AM0PR06MB42761C4E53748D6DBF03FB50D4E60@AM0PR06MB4276.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(166708455590820);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(93006095)(93001095)(3002001)(3231355)(944501410)(4982022)(52105095)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051);SRVR:AM0PR06MB4276;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4276;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(396003)(39850400004)(136003)(366004)(376002)(189003)(199004)(52116002)(99286004)(305945005)(110136005)(53546011)(966005)(6506007)(386003)(14454004)(97736004)(8936002)(5250100002)(76176011)(7736002)(478600001)(53936002)(105586002)(6436002)(68736007)(72206003)(6512007)(31686004)(6306002)(106356001)(65826007)(229853002)(2906002)(5660300001)(25786009)(31696002)(6486002)(64126003)(93886005)(6246003)(65806001)(36756003)(65956001)(186003)(46003)(8676002)(86362001)(2616005)(66574009)(2900100001)(11346002)(476003)(102836004)(71190400001)(71200400001)(446003)(81166006)(6116002)(316002)(81156014)(486006)(58126008)(14444005)(256004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4276;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: RZ20MR/zl7cLAzij2efp3M4iJeZ/PbioOPUlIhMOL3BWzaMGFONbB1yx6mD/9V9Dhy5EMJRdOfFF3jfu2fZDSa8JyMislsP5IkdtaxK2jrh+i5CX48mkp3paGwRkwIOLfQQbO3n6CHM+Plu4Kv/qvRS7U7Y9ntIX5KFwH2jQqe9m8xTSFsS9UT7DL6cQUkeoi/1HeQiCI5eDEZTCZOmL3cK5qIrQmZ3gbCcM+eVeOxib5KTPkdmxQFvF6rHjOGoOPUOpjsxLJhvfsPkgRpmB/UWKAmgCrViIqaaH4sMAAK4SOW0vDJ6amwhx2yGFEkwimTjHo/eyTGVHvgXy0NBe8VABJENEyZOdeNrSfwzDBcI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B49D25E7F912942A553AD4B552575B0@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63fe940f-250c-4935-8549-08d62d58e95a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 20:02:02.0293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4276
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDgvMjAxOCAwNjozNyBQTSwgSG9sZ2VyIEhvZmZzdMOkdHRlIHdyb3RlOg0KPiBPbiAx
MC8wOC8xOCAxNzo0NiwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4gPHNuaXA+DQo+PiBm
cy5kZXZpY2VzKCkgYWxzbyBsb29rcyBmb3IgZGV2X2l0ZW1zIGluIHRoZSBjaHVuayB0cmVlOg0K
Pj4NCj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9rbm9ycmllL3B5dGhvbi1idHJmcy9ibG9iL21hc3Rl
ci9idHJmcy9jdHJlZS5weSNMNDgxDQo+Pg0KPj4gU28sIEJPT00hIHlvdSBuZWVkIHJvb3QuDQo+
Pg0KPj4gT3IganVzdCBzdGFydCBhIDAsIGlnbm9yZSBlcnJvcnMgYW5kIHN0YXJ0IHRyeWluZyBh
bGwgZGV2aWRzIHVudGlsIHlvdQ0KPj4gZm91bmQgbnVtX2RldmljZXMgYW1vdW50IG9mIHRoZW0g
dGhhdCB3b3JrLCB5b2xvLg0KPiANCj4gU2luY2UgSSBuZWVkIHRvIHdhbGsgL3N5cy9mcy9idHJm
cy8gYW55d2F5IEkgKnRoaW5rKiBJIGNhbiBqdXN0IGxvb2sNCj4gYXQgdGhlIGVudHJpZXMgaW4g
L3N5cy9mcy9idHJmcy88ZnNpZD4vZGV2aWNlcy8gYW5kIHF1ZXJ5IHRoZW0gYWxsDQo+IGRpcmVj
dGx5Lg0KDQpCdXQsIHlvdSBzdGlsbCBuZWVkIHJvb3QgZm9yIHRoYXQgcmlnaHQ/IFRoZSBwcm9n
cyBjb2RlIGRvZXMgYSBSTyBvcGVuDQpkaXJlY3RseSBvbiB0aGUgYmxvY2sgZGV2aWNlLg0KDQot
JCBidHJmcyBkZXYgc3RhdHMgL2Rldi94dmRiDQpFUlJPUjogY2Fubm90IG9wZW4gL2Rldi94dmRi
OiBQZXJtaXNzaW9uIGRlbmllZA0KRVJST1I6ICcvZGV2L3h2ZGInIGlzIG5vdCBhIG1vdW50ZWQg
YnRyZnMgZGV2aWNlDQoNCnN0YXQoIi9kZXYvbG9vcDAiLCB7c3RfbW9kZT1TX0lGQkxLfDA2NjAs
IHN0X3JkZXY9bWFrZWRldig3LCAwKSwgLi4ufSkgPSAwDQpzdGF0KCIvZGV2L2xvb3AwIiwge3N0
X21vZGU9U19JRkJMS3wwNjYwLCBzdF9yZGV2PW1ha2VkZXYoNywgMCksIC4uLn0pID0gMA0Kb3Bl
bigiL2Rldi9sb29wMCIsIE9fUkRPTkxZKSAgICAgICAgICAgID0gLTEgRUFDQ0VTIChQZXJtaXNz
aW9uIGRlbmllZCkNCg0KQnV0Og0KDQotIyBidHJmcyBkZXYgc3RhdHMgL2Rldi94dmRiDQpbL2Rl
di94dmRiXS53cml0ZV9pb19lcnJzICAgIDANClsvZGV2L3h2ZGJdLnJlYWRfaW9fZXJycyAgICAg
MA0KWy9kZXYveHZkYl0uZmx1c2hfaW9fZXJycyAgICAwDQpbL2Rldi94dmRiXS5jb3JydXB0aW9u
X2VycnMgIDANClsvZGV2L3h2ZGJdLmdlbmVyYXRpb25fZXJycyAgMA0KDQo+IFRoZSBza2VsZXRv
biBidHJmc19leHBvcnRlciBhbHJlYWR5IHJlc3BvbmRzIHRvIGh0dHAgcmVxdWVzdHMgYW5kDQo+
IHJldHVybnMgZHVtbXkgbWV0cmljcywgdXNpbmcgdGhlIG9mZmljaWFsIHB5dGhvbiBjbGllbnQg
bGlicmFyeS4NCj4gSSd2ZSBmb3VuZCBhIG5pY2UgbGl0dGxlIHB5dGhvbiBzeXNmcyBzY3JhcGVy
IGFuZCBub3cgb25seSBuZWVkIHRvDQo+IGZpZ3VyZSBvdXQgaG93IGJlc3QgdG8gbWFwIHRoZSBi
dHJmcyBpbmZvIGluIHN5c2ZzIHRvIHVzZWZ1bCBtZXRyaWNzLg0KPiBUaGUgcHJpdmlsZWdlZCBh
Y2Nlc3MgaXNzdWUgd291bGQgb25seSBoYXZlIGNvbWUgaW50byBwbGF5IG11Y2ggbGF0ZXIsDQo+
IGJ1dCBpdCBzZWVtcyBJIGNhbiBhdm9pZCBpdCBhZnRlciBhbGwsIHdoaWNoIGlzIGdyZWF0Lg0K
PiBJJ20gYWxzbyAocmUtKWxlYXJuaW5nIHB5dGhvbiBpbiB0aGUgcHJvY2Vzcywgc28gdGhhdCdz
IHRoZSBhY3R1YWwNCj4gdGhpbmcgc2xvd2luZyBtZSBkb3duLi4NCg0KOikNCg0KLS0gDQpIYW5z
IHZhbiBLcmFuZW5idXJnDQo=
