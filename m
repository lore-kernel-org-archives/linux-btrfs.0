Return-Path: <SRS0=NsLk=QI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC521C282DB
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 19:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90453218AF
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 19:13:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="cwnBw8N8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfBATNV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Feb 2019 14:13:21 -0500
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:15819
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbfBATNU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Feb 2019 14:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APLBZPg3q/OjDX9LnrfxQ8R/+WEpR9Vk3k0Tfgbl5vw=;
 b=cwnBw8N8r0N9CVw2+3qcNdoUcBoXlsUNDIMvA7gy1snJ9aJjpxGxfVdXJx7SdNqjscfDkyVNwBhbjSwZujLo467Uz56itvoWIpLsWJPmCjr0buOsTGxnuMIP+Pev2LQIYnMIHCjW83gIiV8zFpFCjU4eawPyR+I6pqtAt0H+X+k=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB2986.eurprd06.prod.outlook.com (10.175.33.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Fri, 1 Feb 2019 19:13:16 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44%3]) with mapi id 15.20.1558.025; Fri, 1 Feb 2019
 19:13:16 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Stefan K <shadow_7@gmx.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs as / filesystem in RAID1
Thread-Topic: btrfs as / filesystem in RAID1
Thread-Index: AQHUuhjZ6+WlgNaD1kKPvxbgzFrFyKXLUCoA
Date:   Fri, 1 Feb 2019 19:13:16 +0000
Message-ID: <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
References: <33679024.u47WPbL97D@t460-skr>
In-Reply-To: <33679024.u47WPbL97D@t460-skr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6PR0402CA0030.eurprd04.prod.outlook.com
 (2603:10a6:209::43) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB2986;6:FAJwpVGExPC3h7Jr+hJJDpu7eSJ5ilW9uyWA78noZRr99/EUZDOEmuOGDVtapXmRwbwS/FJN3x0t4WzBrW+9C+/R0WY8xhlSgyy+AxnyxHc90DqObd2PYnLJfWtItvxpPC1h4fgOAsCRkItei48WVpeMnSekuEBtyns3eFtHPcEZf6MiWewSooRH+zt/WlqSiZ3oWIra6ERupigWiSvxKZcmdukElVdIgF3Tf8N/EpMrX+D+eNTn9d4XlTLAucWFHXbXwfIyxzhgeGnOSnxFKf6XD1SfJYRKnuawhpqUHWEd9HzFSLp4ZnexK+RtyTPbuTXvxeXstvh6PYkG2+zIYBbLPM7r6GcXhexLlSXVgyXP6u+26B99VT/QaYRGQnxzQyGipankDFNND1TsrH2n5DSycc4B8VuH0iFc9O+QL/PPR7KoBoD0TdpN97BXsvSWQ3b8BQuudJ6F6iKKCKxpaw==;5:8DEVjboJZ+7hhKOI2iRIUoUJ2Typ66R5wOgkjgem2qrplYM3w1c+/4Es0CDzwXonuPKeCJ3CrdYomViZChP6STb9rYk2PZE79p6/RzZPJaXUtf/nO44FecNif8mAN/WQSZfOd9WUKd0r0UGFg7Yvg9xeIBhGc28TE73EpFzWqcGAxHMOhc5u7FyP78UwUGe6yRweHjluMfVmANz2vAHa5A==;7:rvTFVceVR/1fAUZyP8syx4lbtMT1XTlJUQrQawlt72Pvf/75cql5EK2+FtvnpdR3cZwT3+h/cELRQkM9odgCra5OINZ3yI485BLTbKl6I13W7eg+7rouTgIJKVm4kcZpAkxljZHS29uxWJlbgZlSPw==
x-ms-office365-filtering-correlation-id: 8ddc5805-1603-4922-c9c4-08d68879517e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:HE1PR0602MB2986;
x-ms-traffictypediagnostic: HE1PR0602MB2986:
x-microsoft-antispam-prvs: <HE1PR0602MB29860DA68E706C3A0E9F7DDDD4920@HE1PR0602MB2986.eurprd06.prod.outlook.com>
x-forefront-prvs: 09352FD734
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(136003)(376002)(346002)(396003)(189003)(199004)(106356001)(76176011)(6486002)(64126003)(53546011)(71190400001)(71200400001)(6436002)(6116002)(6246003)(52116002)(31686004)(105586002)(386003)(6506007)(2501003)(229853002)(256004)(6512007)(65826007)(2906002)(53936002)(486006)(476003)(2616005)(11346002)(446003)(31696002)(81166006)(8676002)(58126008)(46003)(110136005)(97736004)(7736002)(25786009)(36756003)(72206003)(8936002)(99286004)(81156014)(86362001)(316002)(68736007)(65956001)(305945005)(65806001)(478600001)(186003)(102836004)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB2986;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dTCPM/lh1/mbIk3cZ++DjGzMQKF9prmWiig1KZBuzAQPmLaChZATsJe7QmydS9ZoLZ6PtV3JcHKstbS/u4SnO9yNu/UXMMAJ4+JkcqdebNwewXO1bBURo73wYqD/qFKA1xpUy5XRho3GaeglzKm6+MlugnPHwUIhZ/C+OWKdc9pQXQ4scqJLNVmGTPbr3uSWIDDgaPrCBhcHagXICDucd5ncPf9t+HHTHwKOvTHR+LJIoUdYSm5HIoNk9OlCPYL+XdAdnrHhttMU3LoQBwun89LCsfymYrs42Y8/9dayWAOeMeuvayrBwVsbJP5G0QxsEzMMttHBA6Jl9cSNurIKxfJi2C97HvxlL9ga2FtaQHZfrKwnhO7dqhs2gwJa3RkBSEBY2INNp5qJNRe8RkZ9W7XBRsCvZ1RZCXReynyw63Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C3672DBBE8AAB4EA247CDB595C0B734@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddc5805-1603-4922-c9c4-08d68879517e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2019 19:13:15.7156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB2986
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGkgU3RlZmFuLA0KDQpPbiAyLzEvMTkgMTE6MjggQU0sIFN0ZWZhbiBLIHdyb3RlOg0KPiANCj4g
SSd2ZSBpbnN0YWxsZWQgbXkgRGViaWFuIFN0cmV0Y2ggdG8gaGF2ZSAvIG9uIGJ0cmZzIHdpdGgg
cmFpZDEgb24gMg0KPiBTU0RzLiBUb2RheSBJIHdhbnQgdGVzdCBpZiBpdCB3b3JrcywgaXQgd29y
a3MgZmluZSB1bnRpbCB0aGUgc2VydmVyDQo+IGlzIHJ1bm5pbmcgYW5kIHRoZSBTU0QgZ2V0IGJy
b2tlbiBhbmQgSSBjYW4gY2hhbmdlIHRoaXMsIGJ1dCBpdCBsb29rcw0KPiBsaWtlIHRoYXQgaXQg
ZG9lcyBub3Qgd29yayBpZiB0aGUgU1NEIGZhaWxzIHVudGlsIHJlc3RhcnQuIEkgZ290IHRoZQ0K
PiBlcnJvciwgdGhhdCBvbmUgb2YgdGhlIERpc2tzIGNhbid0IGJlIHJlYWQgYW5kIEkgZ290IGEg
aW5pdHJhbWZzDQo+IHByb21wdCwgSSBleHBlY3RlZCB0aGF0IGl0IHN0aWxsIHJ1bnMgbGlrZSBt
ZHJhaWQgYW5kIHNhaWQgc29tZXRoaW5nDQo+IGlzIG1pc3NpbmcuDQo+IA0KPiBNeSBxdWVzdGlv
biBpcywgaXMgaXQgcG9zc2libGUgdG8gY29uZmlndXJlIGJ0cmZzL2ZzdGFiL2dydWIgdGhhdCBp
dA0KPiBzdGlsbCBib290PyAodGhhdCBpcyB3aGF0IEkgZXhwZWN0ZWQgZnJvbSBhIFJBSUQxKQ0K
DQpZZXMuIEknbSBub3QgdGhlIGV4cGVydCBpbiB0aGlzIGFyZWEsIGJ1dCBJIHNlZSB5b3UgaGF2
ZW4ndCBnb3QgYSByZXBseQ0KdG9kYXkgeWV0LCBzbyBJJ2xsIHRyeS4NCg0KV2hhdCB5b3Ugc2Vl
IGhhcHBlbmluZyBpcyBjb3JyZWN0LiBUaGlzIGlzIHRoZSBkZWZhdWx0IGJlaGF2aW9yLg0KDQpU
byBiZSBhYmxlIHRvIGJvb3QgaW50byB5b3VyIHN5c3RlbSB3aXRoIGEgbWlzc2luZyBkaXNrLCB5
b3UgY2FuIGFkZC4uLg0KICAgIHJvb3RmbGFncz1kZWdyYWRlZA0KLi4udG8gdGhlIGxpbnV4IGtl
cm5lbCBjb21tYW5kIGxpbmUgYnkgZWRpdGluZyBpdCBvbiB0aGUgZmx5IHdoZW4geW91DQphcmUg
aW4gdGhlIEdSVUIgbWVudS4NCg0KVGhpcyBhbGxvd3MgdGhlIGZpbGVzeXN0ZW0gdG8gc3RhcnQg
aW4gJ2RlZ3JhZGVkJyBtb2RlIHRoaXMgb25lIHRpbWUuDQpUaGUgb25seSB0aGluZyB5b3Ugc2hv
dWxkIGJlIGRvaW5nIHdoZW4gdGhlIHN5c3RlbSBpcyBib290ZWQgaXMgaGF2ZSBhDQpuZXcgZGlz
ayBwcmVzZW50IGFscmVhZHkgaW4gcGxhY2UgYW5kIGZpeCB0aGUgYnRyZnMgc2l0dWF0aW9uLiBU
aGlzDQptZWFucyB0aGluZ3MgbGlrZSBjbG9uaW5nIHRoZSBwYXJ0aXRpb24gdGFibGUgb2YgdGhl
IGRpc2sgdGhhdCdzIHN0aWxsDQp3b3JraW5nLCBkb2luZyB3aGF0ZXZlciBlbHNlIGlzIG5lZWRl
ZCBpbiB5b3VyIHNpdHVhdGlvbiBhbmQgdGhlbg0KcnVubmluZyBidHJmcyByZXBsYWNlIHRvIHJl
cGxhY2UgdGhlIG1pc3NpbmcgZGlzayB3aXRoIHRoZSBuZXcgb25lLCBhbmQNCnRoZW4gbWFraW5n
IHN1cmUgeW91IGRvbid0IGhhdmUgInNpbmdsZSIgYmxvY2sgZ3JvdXBzIGxlZnQgKHVzaW5nIGJ0
cmZzDQpiYWxhbmNlKSwgd2hpY2ggbWlnaHQgaGF2ZSBiZWVuIGNyZWF0ZWQgZm9yIG5ldyB3cml0
ZXMgd2hlbiB0aGUNCmZpbGVzeXN0ZW0gd2FzIHJ1bm5pbmcgaW4gZGVncmFkZWQgbW9kZS4NCg0K
LS0gDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=
