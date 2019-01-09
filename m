Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D333C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 02:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 104FA20883
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 02:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=oakvillepondscapes.onmicrosoft.com header.i=@oakvillepondscapes.onmicrosoft.com header.b="goVpEWWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfAICjQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 21:39:16 -0500
Received: from mail-eopbgr1360081.outbound.protection.outlook.com ([40.107.136.81]:2304
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727917AbfAICjP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 21:39:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oakvillepondscapes.onmicrosoft.com; s=selector1-pauljones-id-au;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbz+fxWZolrvXrL00rssUUHmnEDNJgz3gZqmAxvIqkQ=;
 b=goVpEWWqaP8YPkKnFQdNPLkjVDvjekrNN6Ism2Eghk5CkI+2ufxrgbFtN+Y0H2toyy5eLJTSabLbsCWeYkIFMdlZWxaM6xKWVTOKAoUFvn295S1RfwUmmCgY5FXbL2TBPkdU+jkNeBVZjyfEPM8/c4ZdWzQVLJtbTUdZh5Kkv8A=
Received: from SYCPR01MB5086.ausprd01.prod.outlook.com (20.178.187.213) by
 SYCPR01MB4352.ausprd01.prod.outlook.com (20.178.184.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.14; Wed, 9 Jan 2019 02:39:10 +0000
Received: from SYCPR01MB5086.ausprd01.prod.outlook.com
 ([fe80::cdcb:2679:f49f:bf0b]) by SYCPR01MB5086.ausprd01.prod.outlook.com
 ([fe80::cdcb:2679:f49f:bf0b%5]) with mapi id 15.20.1495.011; Wed, 9 Jan 2019
 02:39:10 +0000
From:   Paul Jones <paul@pauljones.id.au>
To:     Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: RE: dedicated metadata drives?
Thread-Topic: dedicated metadata drives?
Thread-Index: AQHUpDD1VK4Y/J2aKUuzOTyeNgSz4qWmP8fQ
Date:   Wed, 9 Jan 2019 02:39:10 +0000
Message-ID: <SYCPR01MB5086891E71B5CDBDED74CBD19E8B0@SYCPR01MB5086.ausprd01.prod.outlook.com>
References: <fcdfebdcb0e8d5fd291d08f844274212@virtall.com>
In-Reply-To: <fcdfebdcb0e8d5fd291d08f844274212@virtall.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paul@pauljones.id.au; 
x-originating-ip: [220.244.158.242]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SYCPR01MB4352;6:MMR121+WW/3HGHJAgpS9f8MI3FWVRptUumQ1P/Qn+jdsokFzV9Oru2joNW8OsFfKOTYtP6FYTdQSFWcPZ2tWYjAHJ6AUehlbR+U1xqqOH1tuRRf6fFAWJIX3vvN3R6aNKGeFDdUqY7vhnqsWz5oF5BiRKRLMLmF16CNvkYuk08kX1+I0+8AU3DK3zWC4+sjjIPMQmCMKleAP2ECe5s5PGCevE/l1a9dVImvH56hV7QC6GNMdHT8oTb/qIPc3OjhCxywoHVOuIMEI2OtDV3GU9tguwh6xgouz+ZFlpKPPtbXgeS447C88T0eCvhALPqEcLTVLJthNBrNCvlTpk9awHg23ekBWqg2ot86Q3HOhII0UpYWJLHY/6qYdRlplBqDUFsImT0kKLEnEttzFtKXjofgaWWRoKV1zsq3iv7KsfzMFoYkraAYDf4yLh+29PFQxjLJCDx7qI6uvPhk3P6W22g==;5:LVmUxe2ctNX7aSbqhDxEreskBmjypVvYXBkF99sUjWrCPfaR3CoPUBOE1Jqi8nSStn7TZzQKnkdSYVnhK2vL/CYFz1RYoSeGsprX/EYe9e5L3tnjSUPwWIOxy39Evr4FECQ69KAKjcHOaFDbWTBW7oFEbi19vElkJeivwvhu6Rdjt7lOLLbRobe3DMHv2vapUf4BWs+NZhcLat04YULoaQ==;7:EXqA3Illxef47lir/btsQ+eBazANFVCdmSs1jwc3Z8l0gmn3lK2KS8T0b3eB/YptRvsxYWLIWPf5IE/aaqMwUZb0AebkKFMmpaue7xnBw9+tmmmwb7n1ryZvXCcRZ0Rho4suYYqI42EBsykAwg247A==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: ebeffe08-4f96-45f0-5e30-08d675dba286
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SYCPR01MB4352;
x-ms-traffictypediagnostic: SYCPR01MB4352:
x-microsoft-antispam-prvs: <SYCPR01MB4352AE9599446C4D15BAD9C09E8B0@SYCPR01MB4352.ausprd01.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(3002001)(3231475)(944501520)(52105112)(93006095)(93001095)(10201501046)(6041310)(2016111802025)(20161123558120)(20161123560045)(20161123562045)(20161123564045)(6043046)(201708071742011)(7699051)(76991095);SRVR:SYCPR01MB4352;BCL:0;PCL:0;RULEID:;SRVR:SYCPR01MB4352;
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39830400003)(346002)(136003)(366004)(396003)(189003)(199004)(13464003)(81166006)(55016002)(476003)(11346002)(8676002)(74482002)(81156014)(6436002)(53546011)(6506007)(76176011)(86362001)(7696005)(105586002)(14444005)(256004)(16799955002)(305945005)(106356001)(110136005)(3480700005)(229853002)(316002)(446003)(25786009)(8936002)(71200400001)(71190400001)(2906002)(33656002)(74316002)(99286004)(97736004)(508600001)(6306002)(9686003)(5660300001)(6246003)(966005)(3846002)(6116002)(26005)(186003)(102836004)(486006)(66066001)(7736002)(14454004)(53936002)(68736007)(7116003)(347745004);DIR:OUT;SFP:1101;SCL:1;SRVR:SYCPR01MB4352;H:SYCPR01MB5086.ausprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: pauljones.id.au does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 13PF1a8MalHOxJNm7FthI9K8bjG9Ie/2EJZcKiIRH5kCFbfZgLyRJzlnk/GOwMiMoKt0BzEUFMTxXfe9PM64J7eOMQzcf6JeCmo0pFyQp/DcaFteds2H76ScKPWpuarCYBF1DDdAT/SvMpFU5uDG/LiIfsC1RA4m4O4NWCm/SjKK9W0e6coATU8bUGVy97kTFABt6RGSAbVLpe5xrC5F/FYinKhmT6aEhMkHQWqnHwRNmzI9EfAoaRXQaqk9xlNtYbEZrX9nDm24CMj8HucCinVuZlo4BBmHcr8GKcve1J8CM4PZjMckPlkJbiiLbSYK
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: pauljones.id.au
X-MS-Exchange-CrossTenant-Network-Message-Id: ebeffe08-4f96-45f0-5e30-08d675dba286
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 02:39:10.3555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8f216723-e13f-4cce-b84c-58d8f16a0082
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYCPR01MB4352
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1idHJmcy1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWJ0cmZzLQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9u
IEJlaGFsZiBPZiBUb21hc3ogQ2htaWVsZXdza2kNCj4gU2VudDogU2F0dXJkYXksIDUgSmFudWFy
eSAyMDE5IDEyOjI1IEFNDQo+IFRvOiBCdHJmcyBCVFJGUyA8bGludXgtYnRyZnNAdmdlci5rZXJu
ZWwub3JnPg0KPiBTdWJqZWN0OiBkZWRpY2F0ZWQgbWV0YWRhdGEgZHJpdmVzPw0KPiANCj4gQWNj
b3JkaW5nIHRvIGJ0cmZzIHdpa2ksIHNvbWUgcGF0Y2hlcyBoYXZlIGJlZW4gc3VibWl0dGVkIHRv
IHN1cHBvcnQNCj4gbWV0YWRhdGEgb24gZGlmZmVyZW50IGRldmljZXMgdGhhbiBkYXRhIChpLmUu
IG1ldGFkYXRhIG9uIFNTRCwgZGF0YSBvbg0KPiBIREQpOg0KPiANCj4gDQo+IGh0dHBzOi8vYnRy
ZnMud2lraS5rZXJuZWwub3JnL2luZGV4LnBocC9Qcm9qZWN0X2lkZWFzI0RlZGljYXRlZF9tZXRh
ZGF0YQ0KPiBfZHJpdmVzDQo+IA0KPiAgICAgRGVkaWNhdGVkIG1ldGFkYXRhIGRyaXZlcw0KPiAN
Cj4gICAgIE5vdCBjbGFpbWVkIOKAlCBzdWJtaXR0ZWQg4oCUIE5vdCBpbiBrZXJuZWwgeWV0DQo+
IA0KPiAgICAgV2UncmUgYWJsZSB0byBzcGxpdCBkYXRhIGFuZCBtZXRhZGF0YSBJTyB2ZXJ5IGVh
c2lseS4gTWV0YWRhdGEgdGVuZHMgdG8gYmUNCj4gZG9taW5hdGVkIGJ5IHNlZWtzIGFuZCBmb3Ig
bWFueSBhcHBsaWNhdGlvbnMgaXQgbWFrZXMgc2Vuc2UgdG8gcHV0IHRoZQ0KPiBtZXRhZGF0YSBv
bnRvIGZhc3RlciBTU0RzLg0KPiANCj4gDQo+IA0KPiANCj4gVGhpcyBhcnRpY2xlIChhbG1vc3Qg
Mi41IHllYXJzIG9sZCkgY2xhaW1zIG9uZSBjb21wYW55IGlzIGFscmVhZHkgdXNpbmcgZWl0aGVy
DQo+IHRoZXNlIHBhdGNoZXMgb3Igc29tZXRoaW5nIHNpbWlsYXI6DQo+IA0KPiBodHRwczovL2x3
bi5uZXQvQXJ0aWNsZXMvNjk4MDkwLw0KPiANCj4gICAgIEF1Z3VzdCAyNCwgMjAxNg0KPiANCj4g
ICAgIFRvIGNvbWJhdCB0aGF0LCBoZSBoYXMgYSBzZXQgb2YgcGF0Y2hlcyB0byBhdXRvbWF0aWNh
bGx5IHB1dCB0aGUgQnRyZnMNCj4gbWV0YWRhdGEgb24gU1NEcy4gVGhlIGJsb2NrIGxheWVyIHBy
b3ZpZGVzIGluZm9ybWF0aW9uIG9uIHdoZXRoZXIgdGhlDQo+IHN0b3JhZ2UgaXMgcm90YXRpb25h
bDsgZm9yIG5vdywgaGlzIHBhdGNoIGFzc3VtZXMgdGhhdCBpZg0KPiAgICAgaXQgaXMgbm90IHJv
dGF0aW9uYWwgdGhlbiBpdCBpcyBmYXN0LiBUaGUgcGF0Y2ggaGFzIG1hZGUgYSBodWdlIGRpZmZl
cmVuY2UgaW4NCj4gdGhlIGxhdGVuY2llcyBhbmQgcmVxdWlyZXMgbGVzcyBmbGFzaCBzdG9yYWdl
IChlLmcuIDQ1MEdCIGZvciA0MFRCIGZpbGVzeXN0ZW0pDQo+IGZvciBGYWNlYm9vaydzIGZpbGUg
d29ya2xvYWQgdGhhdA0KPiAgICAgY29uc2lzdHMgb2YgYSB3aWRlIHZhcmlldHkgb2YgZmlsZSBz
aXplcy4NCj4gDQo+IA0KPiANCj4gRG8gdGhlc2UgcGF0Y2hlcyBleGlzdCBhbnl3aGVyZT8gSSBj
b3VsZG4ndCBmaW5kIHRoZW0gaW4gdGhlIGxpc3QgYXJjaGl2ZS4NCg0KSSBtYW5hZ2VkIHRvIGZp
bmQgdGhpcyBzdWdnZXN0aW9uIGFib3V0IGhvdyBpdCBjb3VsZCBiZSBkb25lOg0KaHR0cHM6Ly9w
YXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC85NTU2OTczLw0KDQpJIHdvdWxkIGxvdmUgdG8gdXNl
IHRoaXMgZmVhdHVyZSBhcyB3ZWxsLiBNeSBjdXJyZW50IHNldHVwIHVzZXMgYnRyZnMgb24gbHZt
IHdpdGggY2FjaGluZyBlbmFibGVkLCBidXQgSSB3b3VsZCBwcmVmZXIgYSBzaW1wbGVyIHNldHVw
Lg0KDQpQYXVsLg0K
