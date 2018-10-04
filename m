Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48345C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C407220854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=panasas.onmicrosoft.com header.i=@panasas.onmicrosoft.com header.b="PCO2NDnR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C407220854
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=panasas.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbeJEE2q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:28:46 -0400
Received: from mail-by2nam01on0051.outbound.protection.outlook.com ([104.47.34.51]:45376
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbeJEE2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 00:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=panasas.onmicrosoft.com; s=selector1-panasas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Hdg4Uit6cJZvBykvjwHt8CG6DJOpmphRx9R2mGI+bM=;
 b=PCO2NDnRt2+VPOYBqojUE6dCeQQa1M5h7ESV1tFmdVwFXaBJmabCi/LI0GbdY6ZhA07PL68BOZRCboDNU4AlGDjZ7NYyxSbx92tHYRAOEp0armqCo93JLK2S9ty4hX7M81/WAmHUmZXL0soNa+81KT13OYKNiUonsJ7BdURl3TU=
Received: from CY4PR08MB2886.namprd08.prod.outlook.com (10.173.60.8) by
 CY4PR08MB3573.namprd08.prod.outlook.com (10.171.254.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.25; Thu, 4 Oct 2018 21:33:29 +0000
Received: from CY4PR08MB2886.namprd08.prod.outlook.com
 ([fe80::9def:574e:6056:3ca4]) by CY4PR08MB2886.namprd08.prod.outlook.com
 ([fe80::9def:574e:6056:3ca4%8]) with mapi id 15.20.1185.024; Thu, 4 Oct 2018
 21:33:29 +0000
From:   "Wilson, Ellis" <ellisw@panasas.com>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Understanding BTRFS RAID0 Performance
Thread-Topic: Understanding BTRFS RAID0 Performance
Thread-Index: AQHUXCnk0kG4gJyuskOKS9/F7Px/iQ==
Date:   Thu, 4 Oct 2018 21:33:29 +0000
Message-ID: <54026c92-9cd1-2ac8-5747-c5405dd82087@panasas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR1701CA0023.namprd17.prod.outlook.com
 (2603:10b6:405:15::33) To CY4PR08MB2886.namprd08.prod.outlook.com
 (2603:10b6:903:144::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ellisw@panasas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [65.205.22.243]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR08MB3573;6:PcHluZthv8j8uaowevu5DQhnr61M3UBSVSEBGYCg4C1xACKh7VaAP+w64OPf2XZSY5ogUnKq00R3zGzvfvwe7Kzpa9nYR5EqENF9rqwxOahZkjyAYo3C5D2HZgrgdsgf5iGxug/qoFzDuW8aa/Sm2pyqp3WHLnKnWIT+nS4silIpjnzuUZJBIJeX+Qg+QRLUxcjYVdz000ACLFM9WTVLSQDV+2vaJAM/lGP1IlDqge7R50jFal1gTb/ywF0tTY/Shx4hESv7NXrC7ASO8hmnRfaescGipzofpqwDM85Ls2fVtFpehPoqQztRsiJkkgsrSrtfCBtqj83IC9nLKPQPHhuZ+wMk6+KS+XdxZmhCk6mXSQPIGWhRAkKe3lqaEa32uuQ+NptsvhJ66qELZ9hDXtnig1rWAnZe2yy7c0vAVwXpBbzaHZYtbZLL0Re+VSUpkxt3gsKCA+Pd3O5isvbRwg==;5:9p6KIKYhbF7ihI4jfThGLgsWVmpPsK/uv81H3ArjU/891JAx8W15LtcyEzeScQTrMHCN+zhE7db9jGxNpVUZeFHsIlBcJgwl0HVDHTrqkKSsZY6tgwGsTFdnV5y7+IXPsURGmA7RV1G4mjk2Lk5EY1uUwEt50SSBFfhmgSO9+YE=;7:qcgIokCC6QZpyOYBOJJGoCfpyGH313FjwQ7EnDojpkjh4gXJItOD+2VcDtJhsQvKQK+3rtKs+qNoZatj8UgULNI24O1lRB0kCsaBBRbNzE9vEk02wLFDsz24oh1ERCsBsKxnfAkQXWB4YZjAFaoVhKIMywLErp1ZyQM8mP3nT5NBQD2M6Oa08X97ArEa9ELsfvIvUbzF5uDNLYeluD+1eFXvW3ZebFiR9ainnevgWR4rGsqjmYUdOZWMJG8H2FRD
x-ms-office365-filtering-correlation-id: aac71e82-62ce-42ae-6c58-08d62a410697
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR08MB3573;
x-ms-traffictypediagnostic: CY4PR08MB3573:
x-microsoft-antispam-prvs: <CY4PR08MB35739250867B582B72E258F0C2EA0@CY4PR08MB3573.namprd08.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991048);SRVR:CY4PR08MB3573;BCL:0;PCL:0;RULEID:;SRVR:CY4PR08MB3573;
x-forefront-prvs: 0815F8251E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(39830400003)(136003)(346002)(189003)(199004)(53754006)(8676002)(6116002)(186003)(478600001)(2616005)(36756003)(14454004)(256004)(26005)(476003)(2900100001)(81166006)(25786009)(486006)(81156014)(52116002)(6512007)(6916009)(386003)(105586002)(106356001)(5660300001)(6506007)(316002)(2906002)(6436002)(6486002)(68736007)(53936002)(3846002)(102836004)(66066001)(31696002)(7736002)(86362001)(97736004)(5250100002)(99286004)(8936002)(71190400001)(305945005)(31686004)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR08MB3573;H:CY4PR08MB2886.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: panasas.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: JZxOPBfGPKUZHGAhwbZIWGrm40ZjgPMabuVdJfV7VAIrE/jLVCTzE6r8rxEpI3vYsEM+vyhs+PuK6yFRt78tHg4sDQwR5tflt6sAbmk4D1J9UUkseZ/Pbee5a4daEhuMackxKBBcxSr9g9+FWnS+ynuDFX3FPwJMerxRIE8NPfHGzNHOH/SYPpTnKKlgdHPMDfnI6PfRYrXRl2FkqU2Wq4YjTXJ2DNfzMojE8aA+ioZghytnXZnE1olMIceGPP4za/XcMb9aWZytGkpV+NRUr5Q5wA2rzjQqj2ZOHlN+vAkT3sq+z5f0gfY1pL3/1wLQ+3e6HX7eWAewHT50mVaLtOIDtDcRKgcR8R+M6RTS+BU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E3ACB118AAF414DBF54D1D8850A9FBB@namprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: panasas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aac71e82-62ce-42ae-6c58-08d62a410697
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2018 21:33:29.7581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: acf01c9d-c699-42af-bdbb-44bf582e60b0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR08MB3573
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGkgYWxsLA0KDQpJJ20gYXR0ZW1wdGluZyB0byB1bmRlcnN0YW5kIGEgcm91Z2hseSAzMCUgZGVn
cmFkYXRpb24gaW4gQlRSRlMgUkFJRDAgDQpmb3IgbGFyZ2UgcmVhZCBJL09zIGFjcm9zcyBzaXgg
ZGlza3MgY29tcGFyZWQgd2l0aCBleHQ0IGF0b3AgbWRhZG0gUkFJRDAuDQoNClNwZWNpZmljYWxs
eSwgSSBhY2hpZXZlIHBlcmZvcm1hbmNlIHBhcml0eSB3aXRoIEJUUkZTIGluIHRlcm1zIG9mIA0K
c2luZ2xlLXRocmVhZGVkIHdyaXRlIGFuZCByZWFkLCBhbmQgbXVsdGktdGhyZWFkZWQgd3JpdGUs
IGJ1dCBwb29yIA0KcGVyZm9ybWFuY2UgZm9yIG11bHRpLXRocmVhZGVkIHJlYWQuICBUaGUgcmVs
YXRpdmUgZGlzY3JlcGFuY3kgYXBwZWFycyANCnRvIGdyb3cgYXMgb25lIGFkZHMgZGlza3MuICBB
dCA2IGRpc2tzIGluIGEgUkFJRDAgKHllcywgSSBrbm93LCBhbmQgSSBkbyANCm5vdCBjYXJlIGFi
b3V0IGRhdGEgcGVyc2lzdGVuY2UgYXMgSSBoYXZlIHRoaXMgc29sdmVkIGF0IGEgZGlmZmVyZW50
IA0KbGF5ZXIpIEkgc2VlIGFwcHJveGltYXRlbHkgMS4zR0IvcyBmb3IgZXh0NCBhdG9wIG1kYWRt
LCBidXQgb25seSBhYm91dCANCjk1ME1CL3MgZm9yIEJUUkZTLCBib3RoIHVzaW5nIGZvdXIgdGhy
ZWFkcyB0byByZWFkIGFuZCB3cml0ZSBmb3VyIA0KZGlmZmVyZW50IGxhcmdlIGZpbGVzLiAgQWNy
b3NzIGEgbGFyZ2UgbnVtYmVyIG9mIG15IG5vZGVzIHRoaXMgDQphZ2dyZWdhdGVzIHRvIGEgc2l6
YWJsZSBwZXJmb3JtYW5jZSBsb3NzLg0KDQpUaGlzIGhhcyBiZWVuIGEgbG9uZyBhbmQgd2luZGlu
ZyByb2FkIGZvciBtZSwgYnV0IHRvIGtlZXAgbXkgcXVlc3Rpb24gDQpzb21ld2hhdCBzdWNjaW5j
dCwgSSdtIGRvd24gdG8gdGhlIGxldmVsIG9mIGJsb2NrIHRyYWNpbmcgYW5kIG9uZSB0aGluZyAN
CnRoYXQgc3RhbmRzIG91dCBiZXR3ZWVuIHRoZSB0d28gdHJhY2VzIGlzIHRoZSBudW1iZXIgb2Yg
cmF0aGVyIHNtYWxsIA0KcmVhZCBJL08ncyB0aGF0IHJlYWNoIG9uZSBvZiB0aGUgZHJpdmVzIGlu
IHRoZSB0ZXN0IGlzIHZhc3RseSBkaWZmZXJlbnQgDQpmb3IgbWRhZG0gUkFJRDAgdnMgQlRSRlMs
IHdoaWNoIEkgdGhpbmsgZXhwbGFpbnMgKGluIHBhcnQgYXQgbGVhc3QpIHRoZSANCnBlcmZvcm1h
bmNlIGRyb3Agb2ZmLiAgVGhlIHJlYWQgcXVldWUgZGVwdGggZm9yIEJUUkZTIGhvdmVycyBpbiB0
aGUgDQp1cHBlciBzaW5nbGUgZGlnaXRzIHdoaWxlIHRoZSBleHQ0L21kYWRtIHF1ZXVlIGRlcHRo
IGlzIHRvd2FyZHMgMjAuICBJJ20gDQp1bnN1cmUgcmlnaHQgbm93IGlmIHRoaXMgaXMgcmVsYXRl
ZCBvciBub3QuDQoNCkJlbmNobWFyazogRklPIHdhcyB1c2VkIHdpdGggdGhlIGZvbGxvd2luZyBj
b21tYW5kOg0KZmlvIC0tbmFtZT1yZWFkIC0tcnc9cmVhZCAtLWJzPTFNIC0tZGlyZWN0PTAgLS1z
aXplPTE2RyAtLW51bWpvYnM9NCANCi0tcnVudGltZT0xMjAgLS1ncm91cF9yZXBvcnRpbmcNCg0K
VGhlIGJsb2NrIHNpemVzIGFuZCBjb3VudHMgb2YgSS9PcyBhdCB0aGF0IHNpemUgSSdtIHNlZWlu
ZyBmb3IgYm90aCANCmNhc2VzIGNvbWVzIGluIGxpa2UgdGhlIGZvbGxvd2luZyAobXkgbWF4X3Nl
Z21lbnRfa2Jfc2l6ZSBpcyA0SywgaGVuY2UgDQp0aGUgYWJvdmUgdHlwaWNhbCB1cHBlci1lbmQp
Og0KDQpCVFJGUzoNCiAgQ291bnQgIFJlYWQgSS9PIFNpemUNCiAgIDIxODQ5IDEyOA0KICAgICAg
MTggNjQwDQogICAgICAgOSA3NjgNCiAgICAgICAzIDEyODANCiAgICAgICA5IDE0MDgNCiAgICAg
ICAzIDIwNDgNCiAgICAgICAzIDI1NjANCiAgICAxMDExIDI2ODgNCiAgICAgNTA3IDI4MTYNCg0K
ZXh0NCBvbiBtZGFkbSBSQUlEMDoNCiAgQ291bnQgIFJlYWQgSS9PIFNpemUNCiAgICAgICA5IDgN
CiAgICAgICAzIDE2DQogICAgICAgNSAyNTYNCiAgICAgICA1IDc2OA0KICAgICAgMTkgMTAyNA0K
ICAgICA3MTYgMTUzNg0KICAgICAgIDUgMTU5Mg0KICAgICAgIDUgMjUwNA0KICAgICA2OTUgMjU2
MA0KICAgICAgMjQgNDA5Ng0KICAgICAgMjEgNjY1Ng0KICAgICA0NzcgODE5Mg0KDQpCZWZvcmUg
SSBkaXZlIGludG8gdGhlIEJUUkZTIHNvdXJjZSBvciB0cnkgdHJhY2luZyBpbiBhIGRpZmZlcmVu
dCB3YXksIEkgDQp3YW50ZWQgdG8gc2VlIGlmIHRoaXMgd2FzIGEgd2VsbC1rbm93biBhcnRpZmFj
dCBvZiBCVFJGUyBSQUlEMCBhbmQsIGV2ZW4gDQpiZXR0ZXIsIGlmIHRoZXJlJ3MgYW55IHR1bmFi
bGVzIGF2YWlsYWJsZSBmb3IgUkFJRDAgaW4gQlRSRlMgSSBjb3VsZCANCnBsYXkgd2l0aC4gIFRo
ZSBtYW4gcGFnZSBmb3IgbWtmcy5idHJmcyBhbmQgYnRyZnN0dW5lIGluIHRoZSB0dW5pbmcgDQpy
ZWdhcmQgc2VlbWVkLi4uc3BhcnNlLg0KDQpBbnkgaGVscCBvciBwb2ludGVycyBhcmUgZ3JlYXRs
eSBhcHByZWNpYXRlZCENCg0KVGhhbmtzLA0KDQplbGxpcw0K
