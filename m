Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB66C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 15:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 825E220834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 15:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=panasas.onmicrosoft.com header.i=@panasas.onmicrosoft.com header.b="Xg79kfPc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 825E220834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=panasas.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbeJEW3H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 18:29:07 -0400
Received: from mail-eopbgr700047.outbound.protection.outlook.com ([40.107.70.47]:12800
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726082AbeJEW3H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 18:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=panasas.onmicrosoft.com; s=selector1-panasas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bw0cFy0VWM7NjcFdcVWCug1BROK4/ECcJknypx+0kZ8=;
 b=Xg79kfPcTxDbWhruO3gaPnAB7FYOMaozvYdqj7Efv+mJzO6NcpRzBXuTXTMLjifhglSb2nRWG6pbl6D9zP4xwU7wIa8YniwCYqGRS4J2BqtW2UADJM/kajqIfcV4tZFAkwfNRXY5PVhFLsvab/XvBvQVu5vFCx/SlNtkcpRRd08=
Received: from CY4PR08MB2886.namprd08.prod.outlook.com (10.173.60.8) by
 CY4PR08MB2535.namprd08.prod.outlook.com (10.172.156.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.25; Fri, 5 Oct 2018 15:29:52 +0000
Received: from CY4PR08MB2886.namprd08.prod.outlook.com
 ([fe80::9def:574e:6056:3ca4]) by CY4PR08MB2886.namprd08.prod.outlook.com
 ([fe80::9def:574e:6056:3ca4%8]) with mapi id 15.20.1185.029; Fri, 5 Oct 2018
 15:29:52 +0000
From:   "Wilson, Ellis" <ellisw@panasas.com>
To:     Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Understanding BTRFS RAID0 Performance
Thread-Topic: Understanding BTRFS RAID0 Performance
Thread-Index: AQHUXCnk0kG4gJyuskOKS9/F7Px/iaUQd/J3gABQfoA=
Date:   Fri, 5 Oct 2018 15:29:52 +0000
Message-ID: <591cce01-0bdb-19ca-5454-1398283cd86e@panasas.com>
References: <54026c92-9cd1-2ac8-5747-c5405dd82087@panasas.com>
 <pan$77fbd$8ebaf02d$210deb71$a2b73f29@cox.net>
In-Reply-To: <pan$77fbd$8ebaf02d$210deb71$a2b73f29@cox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR02CA0091.namprd02.prod.outlook.com
 (2603:10b6:208:51::32) To CY4PR08MB2886.namprd08.prod.outlook.com
 (2603:10b6:903:144::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ellisw@panasas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [96.236.218.245]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR08MB2535;6:II2sM0p9QfdtOIkFisARWmA/mT1HKPIfC3DLNVJDJUSz09OzzTr5fxy9aR0XB3byaLVafxr0RfZx/rGQYxt9ZBa5HoM6nmUCnbWFuexIXeMBIR5X3eFeXiaGiy0Tz8HcI4grUk9SXSbNrDkSlGn15sALutcY+6wd1qrZsAmU41LnAIeNbzaWqnUnLWwH85MGa4Csbm+DNZUcg7qH1m4kkWxRqi6oYU3OYKQbHDVWiuhsRTj9BkdbZogWuKYvvitf4UCeK2BAtdOGY/cUKrHK8/7WfYJiyWJFnonbZG/gpF1p9AsMvY/oHK7oTA221iYVNGVDxmfQq9roo7gSDZUYYiUsonfF5paDcYAJeGs13DK3sO8CZ6CpSJs5QPXyfrGAApHET5Y8E1jaD3m8KEAsGsnq+Nd1ID77g1jLtYx9reb0iZfUq39r1umc8mZNwroPaW3EUn2dmWlqTeOZTgZ8qA==;5:tU+OsmknxbxU4uDjnVwLYOTcow2yV009FWde3QDMHfMexgAsYX7cK590eI9AyKlaqeXyaeU9ONZIUTUMMaZ4MZ4fRn6khYIVHb3agx7orYJBpG0kMItgj64wr0mrMXVUO9/Kd0CXsNH8HwkNe5XUe0YCKyklXZ0HrxUGsZ22DxI=;7:7IaQWt9Wu6va+ylBvao0bw9XsS9Uyd27S+TFJKLsGyRxgX3GIxR/4lKTGX0n1gxih4lwq/KpBE7DERP4oBqvYR69Qk4qowxWgjNEaNJAIbDR5Q79q3hNJMdM17UD961bW/VjqW/dmubxt3/wFjHlZX4K37xZr4YuaO5T/ycye48ozRUbNVia251M//vI/WhKdkDsv3F7UBj/iP++0zie3Nz4ONT1uBg0E7Hod3Kt+nhLKJbfHw0O/DpdeOgrnIuY
x-ms-office365-filtering-correlation-id: d275c489-ff37-49f0-00ff-08d62ad764dc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR08MB2535;
x-ms-traffictypediagnostic: CY4PR08MB2535:
x-microsoft-antispam-prvs: <CY4PR08MB2535E505E80F72DD7F59A6ABC2EB0@CY4PR08MB2535.namprd08.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(148717330147763);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051)(76991048);SRVR:CY4PR08MB2535;BCL:0;PCL:0;RULEID:;SRVR:CY4PR08MB2535;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(39830400003)(396003)(199004)(189003)(53754006)(2501003)(486006)(105586002)(7736002)(71200400001)(2616005)(11346002)(305945005)(39060400002)(68736007)(6486002)(5250100002)(3846002)(446003)(6116002)(106356001)(97736004)(8676002)(36756003)(476003)(81156014)(2906002)(256004)(14444005)(186003)(66066001)(5660300001)(26005)(81166006)(52116002)(6246003)(386003)(31696002)(316002)(76176011)(86362001)(99286004)(71190400001)(53546011)(6512007)(8936002)(31686004)(14454004)(25786009)(229853002)(575784001)(53936002)(6436002)(478600001)(102836004)(6506007)(110136005)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR08MB2535;H:CY4PR08MB2886.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: panasas.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: bAm9M+W9kjrJ1dhMSz7LD/z1RTeJ4nlvoepKAZuuzxSXPn7GWLt7/nGLTV9HcWBrXolpAuGxlUP2cLJV5g1+znSWfidpVGSY+RdBv6TMjTkQv1XF7efOl2Pp2M5D+BK4UY3hkI6ekQ4F7mezBbDC915px+FPJ/tCAybLRRbWVwuWtJA07zTe+eg2nzjqcSlIctRBScrvL7w6e0iPME3sT9mhR6oISYNoVz7w21xCyzSoAL7NE+p5d2DYQYHOkoR/x+H1bZd6G6YaFyf+RBIZ4Sko4oAEUA9IPxjz+Iu7aR2I+Pjz4qJkrpRJ7wAB42oLnHLz6goP9k04YVnZbaMm59bkVGY/gRvbYjxJ1Bvf6QM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CB60BE5EB960549B019FB04CC24EAEC@namprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: panasas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d275c489-ff37-49f0-00ff-08d62ad764dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 15:29:52.3604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: acf01c9d-c699-42af-bdbb-44bf582e60b0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR08MB2535
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDUvMjAxOCAwNjo0MCBBTSwgRHVuY2FuIHdyb3RlOg0KPiBXaWxzb24sIEVsbGlzIHBv
c3RlZCBvbiBUaHUsIDA0IE9jdCAyMDE4IDIxOjMzOjI5ICswMDAwIGFzIGV4Y2VycHRlZDoNCj4g
DQo+PiBIaSBhbGwsDQo+Pg0KPj4gSSdtIGF0dGVtcHRpbmcgdG8gdW5kZXJzdGFuZCBhIHJvdWdo
bHkgMzAlIGRlZ3JhZGF0aW9uIGluIEJUUkZTIFJBSUQwDQo+PiBmb3IgbGFyZ2UgcmVhZCBJL09z
IGFjcm9zcyBzaXggZGlza3MgY29tcGFyZWQgd2l0aCBleHQ0IGF0b3AgbWRhZG0NCj4+IFJBSUQw
Lg0KPj4NCj4+IFNwZWNpZmljYWxseSwgSSBhY2hpZXZlIHBlcmZvcm1hbmNlIHBhcml0eSB3aXRo
IEJUUkZTIGluIHRlcm1zIG9mDQo+PiBzaW5nbGUtdGhyZWFkZWQgd3JpdGUgYW5kIHJlYWQsIGFu
ZCBtdWx0aS10aHJlYWRlZCB3cml0ZSwgYnV0IHBvb3INCj4+IHBlcmZvcm1hbmNlIGZvciBtdWx0
aS10aHJlYWRlZCByZWFkLiAgVGhlIHJlbGF0aXZlIGRpc2NyZXBhbmN5IGFwcGVhcnMNCj4+IHRv
IGdyb3cgYXMgb25lIGFkZHMgZGlza3MuDQo+IA0KPiBbLi4uXQ0KPiANCj4+IEJlZm9yZSBJIGRp
dmUgaW50byB0aGUgQlRSRlMgc291cmNlIG9yIHRyeSB0cmFjaW5nIGluIGEgZGlmZmVyZW50IHdh
eSwgSQ0KPj4gd2FudGVkIHRvIHNlZSBpZiB0aGlzIHdhcyBhIHdlbGwta25vd24gYXJ0aWZhY3Qg
b2YgQlRSRlMgUkFJRDAgYW5kLCBldmVuDQo+PiBiZXR0ZXIsIGlmIHRoZXJlJ3MgYW55IHR1bmFi
bGVzIGF2YWlsYWJsZSBmb3IgUkFJRDAgaW4gQlRSRlMgSSBjb3VsZA0KPj4gcGxheSB3aXRoLiAg
VGhlIG1hbiBwYWdlIGZvciBta2ZzLmJ0cmZzIGFuZCBidHJmc3R1bmUgaW4gdGhlIHR1bmluZw0K
Pj4gcmVnYXJkIHNlZW1lZC4uLnNwYXJzZS4NCj4gDQo+IFRoaXMgaXMgaW5kZWVkIHdlbGwga25v
d24gZm9yIGJ0cmZzIGF0IHRoaXMgcG9pbnQsIGFzIGl0IGhhc24ndCBiZWVuDQo+IG11bHRpLXJl
YWQtdGhyZWFkIG9wdGltaXplZCB5ZXQuICBJJ20gcGVyc29uYWxseSBtb3JlIGZhbWlsaWFyIHdp
dGggdGhlDQo+IHJhaWQxIGNhc2UsIHdoZXJlIHdoaWNoIG9uZSBvZiB0aGUgdHdvIGNvcGllcyBn
ZXRzIHRoZSByZWFkIGlzIHNpbXBseQ0KPiBldmVuL29kZC1QSUQtYmFzZWQsIGJ1dCBBRkFJSyBy
YWlkMCBpc24ndCBwYXJ0aWN1bGFybHkgb3B0aW1pemVkIGVpdGhlci4NCj4gDQo+IFRoZSByZWNv
bW1lbmRlZCB3b3JrYXJvdW5kIGlzIChhcyB5b3UgbWlnaHQgZXhwZWN0KSBidHJmcyBvbiB0b3Ag
b2YNCj4gbWRyYWlkLiAgSW4gZmFjdCwgd2hpbGUgaXQgZG9lc24ndCBhcHBseSB0byB5b3VyIGNh
c2UsIGJ0cmZzIHJhaWQxIG9uIHRvcA0KPiBvZiBtZHJhaWQwcyBpcyBvZnRlbiByZWNvbW1lbmRl
ZCBhcyBhbiBhbHRlcm5hdGl2ZSB0byBidHJmcyByYWlkMTAsIGFzDQo+IHRoYXQgZ2l2ZXMgeW91
IHRoZSBiZXN0IG9mIGJvdGggd29ybGRzIC0tIHRoZSBkYXRhIGFuZCBtZXRhZGF0YSBpbnRlZ3Jp
dHkNCj4gcHJvdGVjdGlvbiBvZiBidHJmcyBjaGVja3N1bXMgYW5kIGZhbGxiYWNrICh3aXRoIHdy
aXRlYmFjayBvZiB0aGUgY29ycmVjdA0KPiB2ZXJzaW9uKSB0byB0aGUgb3RoZXIgY29weSBpZiB0
aGUgZmlyc3QgY29weSByZWFkIGZhaWxzIGNoZWNrc3VtDQo+IHZlcmlmaWNhdGlvbiwgd2l0aCB0
aGUgbXVjaCBiZXR0ZXIgb3B0aW1pemVkIG1kcmFpZDAgcGVyZm9ybWFuY2UuICBTbyBpdA0KPiBz
dGFuZHMgdG8gcmVhc29uIHRoYXQgdGhlIHNhbWUgcmVjb21tZW5kYXRpb24gd291bGQgYXBwbHkg
dG8gcmFpZDAgLS0NCj4ganVzdCBkbyBzaW5nbGUtbW9kZSBidHJmcyBvbiBtZHJhaWQwLCBmb3Ig
YmV0dGVyIHBlcmZvcm1hbmNlIHRoYW4gdGhlIGFzDQo+IHlldCB1bm9wdGltaXplZCBidHJmcyBy
YWlkMC4NCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBEdW5jYW4uICBJIGZhaWxlZCB0byBtZW50aW9u
IHRoYXQgSSdkIHRyaWVkIHRoaXMgDQpiZWZvcmUgYXMgd2VsbCwgYnV0IHdhcyBob3BpbmcgdG8g
YXZvaWQgaXQgYXMgaXQgZmVsdCBsaWtlIGEga2x1ZGdlIGFuZCANCml0IGRpZG4ndCBnaXZlIG1l
IHRoZSBiaWcganVtcCBJIGV4cGVjdGVkIHNvIEkgZm9yZ290IGFib3V0IGl0Lg0KDQpJIHJldGVz
dGVkIGFuZCBidHJmcyBvbiBtZHJhaWQgaW4gYSBzaXgtd2lkZSBSQUlEMCBkb2VzIGltcHJvdmUg
DQpwZXJmb3JtYW5jZSBzbGlnaHRseSAtLSBJIHNlZSB0eXBpY2FsbHkgOTkwTUIvcywgYW5kIHVw
IHRvIGFyb3VuZCANCjEuMUdCL3MgaW4gdGhlIGJlc3QgY2FzZS4gIFNhbWUgb3B0aW9ucyB0byBm
aW8gYXMgbXkgb3JpZ2luYWwgZW1haWwuIA0KU3RpbGwgYSB3YXlzIGF3YXkgZnJvbSBleHQ0ICh3
aGljaCBhZG1pdHRlZGx5IG1heSBiZSBjaGVhdGluZyBhIGJpdCANCnNpbmNlIGl0IHNlZW1zIHRv
IGRldGVjdCB0aGUgbWQwIHVuZGVybmVhdGggb2YgaXQgYW5kIGFkanVzdCBpdHMgc3RyaWRlIA0K
bGVuZ3RoIGFjY29yZGluZ2x5LCB0aG91Z2ggSSBtYXkgYmUgb3Zlci1yZXByZXNlbnRpbmcgaXQn
cyBpbnRlbGxpZ2VuY2UgDQphYm91dCB0aGlzKS4NCg0KVGhlIEkvTyBzaXplcyBpbXByb3ZlIGdy
ZWF0bHkgdG8gcGFyaXR5IHdpdGggZXh0NCBhdG9wIG1kcmFpZCwgYnV0IHRoZSANCnF1ZXVlIGRl
cHRoIGlzIHN0aWxsIGZhaXJseSBsb3cgLS0gZXZlbiB3aXRoIG1hbnkgcHJvY2Vzc2VzIGl0IHJh
cmVseSANCmV4Y2VlZHMgNSBvciA2LiAgVGhpcyBpcyB0cnVlIGlmIEkgcnVuIGZpbyB3aXRoIG9y
IHdpdGhvdXQgdGhlIGFpbyBpb2VuZ2luZS4NCg0KSXMgdGhlcmUgYW55IHR1bmluZyBpbiBCVFJG
UyB0aGF0IGxpbWl0cyB0aGUgbnVtYmVyIG9mIG91dHN0YW5kaW5nIHJlYWRzIA0KYXQgYSB0aW1l
IHRvIGEgc21hbGwgc2luZ2xlLWRpZ2l0IG51bWJlciwgb3Igc29tZXRoaW5nIGVsc2UgdGhhdCBj
b3VsZCANCmJlIGJlaGluZCBzbWFsbCBxdWV1ZSBkZXB0aHM/ICBJIGNhbid0IG90aGVyd2lzZSBp
bWFnaW5lIHdoYXQgdGhlIA0KZGlmZmVyZW5jZSB3b3VsZCBiZSBvbiB0aGUgcmVhZCBwYXRoIGJl
dHdlZW4gZXh0NCB2cyBidHJmcyB3aGVuIGJvdGggYXJlIA0Kb24gbWRyYWlkLg0KDQpUaGFua3Mg
YWdhaW4gZm9yIHlvdXIgaW5zaWdodHMsDQoNCmVsbGlzDQo=
