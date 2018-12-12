Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CC3C67839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 00:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04ED52084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 00:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="D/tVvVdL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YS77Fr9d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04ED52084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbeLLAZ6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 19:25:58 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:36826 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbeLLAZ6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 19:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1544574357; x=1576110357;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=ID52LeEkKKz4qmibpwWcvfsmBws6izQbG6Z26CXBLR4=;
  b=D/tVvVdLRTT6VK+cajyqf2y1zZqNpt9BKWIonxt91OmMyAIsrcslv5if
   Lne3TBj81Y8dU7MjY6ta5M6btT4c6UOk1FqejIxWp0eX8t5cR0Name5y1
   08LOvlX7n7k2QH0CSl783o/w7u8rS7bZSogHY5OjAl0JEcxW53dTqPy7H
   7pTyIk5EWtLFbq1d+DwCobTTQrVs1xp1rBIu20cElKsZ2p+meCMq1/liE
   +MRqgXVVCMxk5ZUODCvEcW5T7reML/XAmS3wHUUz/b/lP+H0QeoG8b9ij
   VwNf+xvyd1QBSFO/qma7KmvR+I0gxLEdLvPmctxQD3PfLouftiPavR5zO
   A==;
X-IronPort-AV: E=Sophos;i="5.56,343,1539619200"; 
   d="scan'208";a="96363991"
Received: from mail-sn1nam04lp2057.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.57])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2018 08:25:56 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector1-wdc-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ID52LeEkKKz4qmibpwWcvfsmBws6izQbG6Z26CXBLR4=;
 b=YS77Fr9dDvqANwUXNtyS8HKS4hpdPwV4NWthXujC1gPur/WpqsNOiY3cLjixHctmiuP+2CksznXJ+zroYs/82NvBY6ZtqDu8iD+Oex9Zbf16Ko8jfWCjfKhQIdQvCX2cQ8ZRracOf/JT/h+/oVwvIW62rnQOEEPX8NpnCmE3R1k=
Received: from BYAPR04MB4823.namprd04.prod.outlook.com (52.135.240.94) by
 BYAPR04MB4904.namprd04.prod.outlook.com (52.135.232.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.22; Wed, 12 Dec 2018 00:25:55 +0000
Received: from BYAPR04MB4823.namprd04.prod.outlook.com
 ([fe80::a4a4:f84:f6:ca92]) by BYAPR04MB4823.namprd04.prod.outlook.com
 ([fe80::a4a4:f84:f6:ca92%4]) with mapi id 15.20.1404.026; Wed, 12 Dec 2018
 00:25:55 +0000
From:   Dmitriy Gorokh <Dmitriy.Gorokh@wdc.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: raid56: data corruption on a device removal
Thread-Topic: [PATCH] btrfs: raid56: data corruption on a device removal
Thread-Index: AQHUkbE/5XywBUZ+1kmu6/WYL+nGFQ==
Date:   Wed, 12 Dec 2018 00:25:55 +0000
Message-ID: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Dmitriy.Gorokh@wdc.com; 
x-originating-ip: [46.216.2.48]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR04MB4904;6:4s6gn75RyjJd9Cx9zvS4VvGfa6Vr0DHIIsGFCzk94wzrtijA9OKoBqTtQhVTu3QBQ9XYXYjidxQe4P7FNJ+mh/YF0JZvyaj5ur5uTsxQT4cXSkTTgIg+VvR7ICesYPclxjnaSTg6iEE09zDZstszPuqCmW7+1OQuFNwqwOGwIlOuT2RcswLqJ2oyDk1HW0tImf7jKlZMLdfi5+cCU7o7Ld32yeVzDRJgtPbTEV7wObcJgYWFuYlQCLalhHBYZCdcFEchkmFahofQTCE4HNax9MF5Zs5nWIpmW9A/bmsSRN3zzZj5ET1UOcs+F9lxC05s/RcUhfpnGKV98OsOQlAHZsC5+QhHhkmExo/36sQxh2kl8KI7HvA9AG0iS02xyMLqQdIzPua4vONxN+6oO6BTGCu/QfbZiOX2ko/BT8Y3n8jhTybQ99e+0jN5vAOYc+LxcJ3LwjUcKmVBl6EJXHMbHQ==;5:28VpLd/q4wkW9nL/hbhsHnUhikE7meqYuXIcyuEWmsKLoa5jdhEuzwqvzjPJq78FNlJ/RBS9WMb7hgD1iLiOi0nhg3M1dFyr+INcrRHXzAkOa5K34/35WzIugAZmI3hugZb3k6slmez+fhVeBLqmJ8n+IRY5i/KWSqRCqQ/awEE=;7:rzKIo/lX8ZUxzlMwuzHVQ0fMVkOkbW5xTO/jqVxU9Mekt4jBVWxcxPIM5nYGcApNnlJIAFf8iT6YO8/oLqBG95aX2IT0Z/bBSRIACfp//CwcgB9y+JZAL0+Q5IXZLN01JXFW+WQt8Qw10vaqwPBVGg==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 33399e9f-d9b1-44bb-99e9-08d65fc861b3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR04MB4904;
x-ms-traffictypediagnostic: BYAPR04MB4904:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB4904B11031F38735B658C5BA8BA70@BYAPR04MB4904.namprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3231455)(999002)(944501520)(52105112)(93006095)(93001095)(3002001)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR04MB4904;BCL:0;PCL:0;RULEID:;SRVR:BYAPR04MB4904;
x-forefront-prvs: 0884AAA693
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(136003)(366004)(376002)(199004)(189003)(476003)(6116002)(478600001)(2351001)(83716004)(86362001)(71190400001)(3846002)(71200400001)(25786009)(53936002)(33656002)(68736007)(2616005)(99286004)(486006)(6512007)(72206003)(105586002)(305945005)(106356001)(6506007)(97736004)(26005)(102836004)(6916009)(82746002)(81156014)(2501003)(186003)(5660300001)(36756003)(81166006)(8676002)(66066001)(8936002)(2906002)(14454004)(6436002)(316002)(7736002)(256004)(14444005)(6486002)(5640700003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4904;H:BYAPR04MB4823.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-microsoft-antispam-message-info: ba/j8MdXZ1zsQXtk6acBPXOfuW/nC5qwUo7gLujPoEBRuVeD50AnbTN9xvAK7HCxsMB6qZ+Mnfxxn2f+kK6z1KhGPhPIl61aR/tBLnYxJGifnbaOQcgAJG0t8H2Kt3L7TXtJttArh2TnlppnA5U834grlnfOqWoD3fS5vSTvDoUK8GubyBNj1aW1Gk2RbS6lIIB4Z3r2hvwRrTRlvYkJiisrIqjKHHKOM9LPYnAK16ocoT3q+UftWZZmMHSvhQKGOVmdAAqvGDgLS5oEJJ++PvMqhxQc9riKp5t0nfIapZEJtTYuEoxdkq3a6zKzwgMq
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D081ED9F6050B42981232D7249EF511@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33399e9f-d9b1-44bb-99e9-08d65fc861b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2018 00:25:55.4460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4904
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SSBmb3VuZCB0aGF0IFJBSUQ1IG9yIFJBSUQ2IGZpbGVzeXN0ZW0gbWlnaHQgYmUgZ290IGNvcnJ1
cHRlZCBpbiB0aGUgZm9sbG93aW5nIHNjZW5hcmlvOg0KDQoxLiBDcmVhdGUgNCBkaXNrcyBSQUlE
NiBmaWxlc3lzdGVtDQoyLiBQcmVhbGxvY2F0ZSAxNiAxMEdiIGZpbGVzDQozLiBSdW4gZmlvOiAn
ZmlvIC0tbmFtZT10ZXN0bG9hZCAtLWRpcmVjdG9yeT0uLyAtLXNpemU9MTBHIC0tbnVtam9icz0x
NiAtLWJzPTY0ayAtLWlvZGVwdGg9NjQgLS1ydz1yYW5kcncgLS12ZXJpZnk9c2hhMjU2IC0tdGlt
ZV9iYXNlZCAtLXJ1bnRpbWU9MzYwMOKAmQ0KNC4gQWZ0ZXIgZmV3IG1pbnV0ZXMgcHVsbCBvdXQg
dHdvIGRyaXZlczogJ2VjaG8gMSA+IC9zeXMvYmxvY2svc2RjL2RldmljZS9kZWxldGUgOyAgZWNo
byAxID4gL3N5cy9ibG9jay9zZGQvZGV2aWNlL2RlbGV0ZeKAmQ0KDQpBYm91dCA1IG9mIDEwIHRp
bWVzIHRoZSB0ZXN0IGlzIHJ1biwgaXQgbGVkIHRvIHNpbGVudCBkYXRhIGNvcnJ1cHRpb24gb2Yg
YSByYW5kb20gZXh0ZW50LCByZXN1bHRpbmcgaW4g4oCYSU8gRXJyb3LigJkgYW5kIOKAmGNzdW0g
ZmFpbGVk4oCZIG1lc3NhZ2VzIHdoaWxlIHRyeWluZyB0byByZWFkIHRoZSBhZmZlY3RlZCBmaWxl
LiBJdCB1c3VhbGx5IGFmZmVjdHMgb25seSBzbWFsbCBwb3J0aW9uIG9mIHRoZSBmaWxlcyBhbmQg
b25seSBvbmUgdW5kZXJseWluZyBleHRlbnQgb2YgYSBmaWxlLiBXaGVuIEkgY29udmVydGVkIGxv
Z2ljYWwgYWRkcmVzcyBvZiB0aGUgZGFtYWdlZCBleHRlbnQgdG8gcGh5c2ljYWwgYWRkcmVzcyBh
bmQgZHVtcGVkIGEgc3RyaXBlIGRpcmVjdGx5IGZyb20gZHJpdmVzLCBJIHNhdyBzcGVjaWZpYyBw
YXR0ZXJuLCBhbHdheXMgdGhlIHNhbWUgd2hlbiB0aGUgaXNzdWUgb2NjdXJzLg0KDQpJIGZvdW5k
IHRoYXQgZmV3IGJpb3Mgd2hpY2ggd2VyZSBiZWluZyBwcm9jZXNzZWQgcmlnaHQgZHVyaW5nIHRo
ZSBkcml2ZXMgcmVtb3ZhbCwgY29udGFpbmVkIG5vbiB6ZXJvIGJpby0+YmlfaXRlci5iaV9kb25l
IGZpZWxkIGRlc3BpdGUgb2YgIEVJTyBiaV9zdGF0dXMuIGJpX3NlY3RvciBmaWVsZCB3YXMgYWxz
byBpbmNyZWFzZWQgZnJvbSBvcmlnaW5hbCBvbmUgYnkgdGhhdCAnYmlfZG9uZScgdmFsdWUuIExv
b2tzIGxpa2UgdGhpcyBpcyBhIHF1aXRlIHJhcmUgY29uZGl0aW9uLiBTdWJzZXF1ZW50bHksIGlu
IHRoZSByYWlkX3Jtd19lbmRfaW8gaGFuZGxlciB0aGF0IGZhaWxlZCBiaW8gY2FuIGJlIHRyYW5z
bGF0ZWQgdG8gYSB3cm9uZyBzdHJpcGUgbnVtYmVyIGFuZCBmYWlsIHdyb25nIHJiaW8uDQoNCg0K
LS0tDQogZnMvYnRyZnMvcmFpZDU2LmMgfCAzICsrKw0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL3JhaWQ1Ni5jIGIvZnMvYnRyZnMvcmFp
ZDU2LmMNCmluZGV4IDNjODA5Mzc1NzQ5Ny4uOTRhZTcwNzE1MTk1IDEwMDY0NA0KLS0tIGEvZnMv
YnRyZnMvcmFpZDU2LmMNCisrKyBiL2ZzL2J0cmZzL3JhaWQ1Ni5jDQpAQCAtMTQ1MSw2ICsxNDUx
LDkgQEAgc3RhdGljIGludCBmaW5kX2Jpb19zdHJpcGUoc3RydWN0IGJ0cmZzX3JhaWRfYmlvICpy
YmlvLA0KICAgICAgICBzdHJ1Y3QgYnRyZnNfYmlvX3N0cmlwZSAqc3RyaXBlOw0KDQogICAgICAg
IHBoeXNpY2FsIDw8PSA5Ow0KKyAgICAgICAvLyBTaW5jZSB0aGUgZmFpbGVkIGJpbyBjYW4gcmV0
dXJuIHBhcnRpYWwgZGF0YSwgYmlfc2VjdG9yIG1pZ2h0IGJlIGluY3JlbWVudGVkDQorICAgICAg
IC8vIGJ5IHRoYXQgdmFsdWUuIFdlIG5lZWQgdG8gcmV2ZXJ0IGl0IGJhY2sgdG8gdGhlIHN0YXRl
IGJlZm9yZSB0aGUgYmlvIHdhcyBzdWJtaXR0ZWQuDQorICAgICAgIHBoeXNpY2FsIC09IGJpby0+
YmlfaXRlci5iaV9kb25lOw0KDQogICAgICAgIGZvciAoaSA9IDA7IGkgPCByYmlvLT5iYmlvLT5u
dW1fc3RyaXBlczsgaSsrKSB7DQogICAgICAgICAgICAgICAgc3RyaXBlID0gJnJiaW8tPmJiaW8t
PnN0cmlwZXNbaV07DQotLSANCjIuMTcuMA0KDQoNCg==
