Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2CFC04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 20:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 898C02081C
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 20:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 898C02081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=panasas.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbeLDUOt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 15:14:49 -0500
Received: from mail-eopbgr790075.outbound.protection.outlook.com ([40.107.79.75]:62688
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726206AbeLDUOt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 15:14:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=panasas.onmicrosoft.com; s=selector1-panasas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trF8LPyyslQO7zT8ZXaV0LeIA+FGfYRkFcNkBtcUksA=;
 b=Httx9m8aEW45V+9NACY4cb4ykI6V4A6RXt3M/fR1Gj+Pl3B+CylZUG/OhfJpIljVMvbpRy0yiLwIO3ZUzr45Dg55SQwK5RflzpZyo+7aq0SqiacBAEW1YoniVDtAX0G0GetOPbFmrJFq358KrXDG/ctMDeA3ifP4HubWQ7n699s=
Received: from CY4PR08MB2886.namprd08.prod.outlook.com (10.173.60.8) by
 CY4PR08MB3589.namprd08.prod.outlook.com (10.171.254.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.22; Tue, 4 Dec 2018 20:14:46 +0000
Received: from CY4PR08MB2886.namprd08.prod.outlook.com
 ([fe80::695d:2c94:133f:36bd]) by CY4PR08MB2886.namprd08.prod.outlook.com
 ([fe80::695d:2c94:133f:36bd%2]) with mapi id 15.20.1382.020; Tue, 4 Dec 2018
 20:14:46 +0000
From:   "Wilson, Ellis" <ellisw@panasas.com>
To:     Nikolay Borisov <nborisov@suse.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS Mount Delay Time Graph
Thread-Topic: BTRFS Mount Delay Time Graph
Thread-Index: AQHUizTqpABbJ5V+NEK7aSu9VpssYqVujkQAgAB3UAA=
Date:   Tue, 4 Dec 2018 20:14:46 +0000
Message-ID: <a511850e-c08b-d6c5-0471-e523eff73680@panasas.com>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
 <b4183c50-a2a3-7470-3038-1e759a99369c@suse.com>
In-Reply-To: <b4183c50-a2a3-7470-3038-1e759a99369c@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR12CA0046.namprd12.prod.outlook.com
 (2603:10b6:405:70::32) To CY4PR08MB2886.namprd08.prod.outlook.com
 (2603:10b6:903:144::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ellisw@panasas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [65.205.22.243]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR08MB3589;6:B4dofgPI349w/x8k+aiuva/uwNuRmOT+KrkLOzOIDWk6wB+Q/D1ySU0nId9icgFsbE8kFYe9vCrytq4sQMW/RKV8J5T2y55a+gNDYiHip/ANDsr90QFNlEU6LkpAWLv+y7508J1PknFwsfto9VVE6c/6gJzM7xYH/wcGzffWHAXBa07T8PTlH3c4PkGm1KEk2D/6BdYSxEXhtL99gk1eYpcONaLTaErcFoRrGNE+y8yiVx/F6ChPoMypDh6hEtbEZA+BqIidgaEv7vBHZfkbgyDFGqvNPwkURswnoenV77l4pf30uHHiBRRZ3gRTBni3N/FKYLfP4+zbsmhgCzLBUpssZrpGWHwX1dfueo6E/9DbwSIZ0dkj3+zHm8ZDQEWXJL38kxOj+a2pHblxuRW+vzDgkM1hkOh4cSzEFkUW9EtLs5/Ie6u23W2o9Hj4eOsTbS1I0OTjfUFZYNAc5wye5A==;5:lsDppCjo+1iQVRKhsJCeDJlYkGzoh+fP7rE5dqXxqrjF/K0/MppWanzGA4/CmfaKRVxaIae54GENsdb1+jFsCppM81fGWJvrf6zukuVzFFeRH35eKXxEOQyFZa97jr/Egf758Zk2jla7J9Pwyrc5qKwU5ltNZeRQBu03e1IhwcU=;7:k5bSTZv29mSwAQruvjznjBqLh4bRZpEPJA/aTCzYbEJq0mwZfK5IVWJLVMlO+o5SZrgLj/WQkqdRcFzqAOc2ZgV7Yonq6mxGjp7AUrM9Xok9MZNIbQhlcmCjeErhaoDI+4gRP29BVyPOsA4YWBq2nA==
x-ms-office365-filtering-correlation-id: 88cb499f-1e8a-42a9-f30e-08d65a2522d2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY4PR08MB3589;
x-ms-traffictypediagnostic: CY4PR08MB3589:
x-microsoft-antispam-prvs: <CY4PR08MB35897B5071B7C1ACFCEEEF9EC2AF0@CY4PR08MB3589.namprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231455)(999002)(944501493)(52105112)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:CY4PR08MB3589;BCL:0;PCL:0;RULEID:;SRVR:CY4PR08MB3589;
x-forefront-prvs: 0876988AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39840400004)(346002)(376002)(396003)(189003)(199004)(6116002)(6246003)(81156014)(76176011)(3846002)(53936002)(99286004)(97736004)(68736007)(186003)(8936002)(5660300001)(52116002)(110136005)(6512007)(305945005)(229853002)(316002)(6486002)(81166006)(66066001)(8676002)(71190400001)(36756003)(71200400001)(7736002)(31686004)(26005)(6436002)(25786009)(486006)(102836004)(478600001)(476003)(2906002)(14454004)(105586002)(86362001)(31696002)(6506007)(386003)(2616005)(53546011)(256004)(446003)(106356001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR08MB3589;H:CY4PR08MB2886.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: panasas.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: xCEiTeDcVH8m2NKfyI0mMHoG08fuGzZHpsxS30Rk/gO0gCnjCL7bsHppCWemY9gQfPPkYZ5XobZL7vgeNw8IutjKKxouf5TLxewCxNFmLKvhWmZmNkzbnahwsrQ5d5+QApskzCFIN4kR43ackue6hC6ZQfNq8iGFrmMN0pjNPMi9ds6Dk8J5dFAakKRbuB/kP/gr3nWORQjfjVvazCaNwGmiIcA3RiMQf3h0sFqKYTT5fwfcHyR9XDQkZJEzudXp00cMcW/Cu9zR093OeS5GbIK16gKQ6YoYRUyl8m7pAGFg5jq5RAqITZsBcy+RADnt9EbooRHD+RWzDOwt5Y0Y2scdsQFFNMe5hv2N6MFoel0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A0CB7646E12764681239425120B8F8E@namprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: panasas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88cb499f-1e8a-42a9-f30e-08d65a2522d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2018 20:14:46.7256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: acf01c9d-c699-42af-bdbb-44bf582e60b0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR08MB3589
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTIvNC8xOCA4OjA3IEFNLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6DQo+IE9uIDMuMTIuMTgg
0LMuIDIwOjIwINGHLiwgV2lsc29uLCBFbGxpcyB3cm90ZToNCj4+IFdpdGggMTRUQiBkcml2ZXMg
YXZhaWxhYmxlIHRvZGF5LCBpdCBkb2Vzbid0IHRha2UgbW9yZSB0aGFuIGEgaGFuZGZ1bCBvZg0K
Pj4gZHJpdmVzIHRvIHJlc3VsdCBpbiBhIGZpbGVzeXN0ZW0gdGhhdCB0YWtlcyBhcm91bmQgYSBt
aW51dGUgdG8gbW91bnQuDQo+PiBBcyBhIHJlc3VsdCBvZiB0aGlzLCBJIHN1c3BlY3QgdGhpcyB3
aWxsIGJlY29tZSBhbiBpbmNyZWFzaW5nbHkgcHJvYmxlbQ0KPj4gZm9yIHNlcmlvdXMgdXNlcnMg
b2YgQlRSRlMgYXMgdGltZSBnb2VzIG9uLiAgSSdtIG5vdCBjb21wbGFpbmluZyBhcyBJJ20NCj4+
IG5vdCBhIGNvbnRyaWJ1dG9yIHNvIEkgaGF2ZSBubyByb29tIHRvIGRvIHNvIC0tIGp1c3Qgc2hl
ZGRpbmcgc29tZSBsaWdodA0KPj4gb24gYSBwcm9ibGVtIHRoYXQgbWF5IGRlc2VydmUgYXR0ZW50
aW9uIGFzIGZpbGVzeXN0ZW0gc2l6ZXMgY29udGludWUgdG8NCj4+IGdyb3cuDQo+IFdvdWxkIGl0
IGJlIHBvc3NpYmxlIHRvIHByb3ZpZGUgcGVyZiB0cmFjZXMgb2YgdGhlIGxvbmdlci1ydW5uaW5n
IG1vdW50DQo+IHRpbWU/IEV2ZXJ5b25lIHNlZW1zIHRvIGJlIGZpeGF0ZWQgb24gcmVhZGluZyBi
bG9jayBncm91cHMgKHdoaWNoIGlzDQo+IGxpa2VseSB0byBiZSB0aGUgY3VscHJpdCkgYnV0IGJl
Zm9yZSBwb2ludGluZyBmaW5nZXIgSSdkIGxpa2UgY29uY3JldGUNCj4gZXZpZGVuY2UgcG9pbnRl
ZCBhdCB0aGUgb2ZmZW5kZXIuDQoNCkkgYW0gZ2xhZCB0byBjb2xsZWN0IHN1Y2ggdHJhY2VzIC0t
IHBsZWFzZSBhZHZpc2Ugd2l0aCBjb21tYW5kcyB0aGF0IA0Kd291bGQgYWNoaWV2ZSB0aGF0LiAg
SWYgeW91IGp1c3QgbWVhbiBibG9jayB0cmFjZXMsIEkgY2FuIGRvIHRoYXQsIGJ1dCBJIA0Kc3Vz
cGVjdCB5b3UgbWVhbiBzb21ldGhpbmcgbW9yZSBCVFJGUy1zcGVjaWZpYy4NCg0KQmVzdCwNCg0K
ZWxsaXMNCg0K
