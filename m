Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BA7C10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 17:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21C3320830
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 17:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="W1ccXHg5";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="FAFpYdh/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfDJR1d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 13:27:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56526 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728749AbfDJR1c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 13:27:32 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3AHNhmb020983;
        Wed, 10 Apr 2019 10:27:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Fz9y+da1Zj0TCr4FtsD+bK+ccLJgdl/bSYC43z1+zlQ=;
 b=W1ccXHg53Gwx/5BBrYhBTUtjI5I6DUO9235e8V/AihZ80muLVaJFyXkqRhlJyOklsr41
 ojrmP9SXehz2mPCV4bTLYQ2t5cy7LM/SkXJePX33Rcv2IpzW0k3cCuDyoyKZU+EaiVWZ
 9RPZi1Y99Y6FK7UUTxo+rjCkj+ZnxVGP+To= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2rsm6ugd5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Apr 2019 10:27:24 -0700
Received: from frc-mbx06.TheFacebook.com (2620:10d:c0a1:f82::30) by
 frc-hub06.TheFacebook.com (2620:10d:c021:18::176) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 10 Apr 2019 10:27:23 -0700
Received: from frc-hub02.TheFacebook.com (2620:10d:c021:18::172) by
 frc-mbx06.TheFacebook.com (2620:10d:c0a1:f82::30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 10 Apr 2019 10:27:23 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 10 Apr 2019 10:27:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fz9y+da1Zj0TCr4FtsD+bK+ccLJgdl/bSYC43z1+zlQ=;
 b=FAFpYdh/88MAkWJ1LBAam80RfuiHs6oaA0OXCA98l/i/Gwyl0Cr1JAtMk6IahkG/PHazlYRPnrfLE4ZkEZJ5ykcomA2rm4N+SZaiwvxJWTACmG41J9GbAAvznsstU0g965cM8bnQ4Py4zkmI/NQZu0xE4+wkoy8XEuArmLSwZwA=
Received: from DM5PR15MB1290.namprd15.prod.outlook.com (10.173.209.148) by
 DM5PR15MB1385.namprd15.prod.outlook.com (10.173.224.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.15; Wed, 10 Apr 2019 17:27:21 +0000
Received: from DM5PR15MB1290.namprd15.prod.outlook.com
 ([fe80::e828:23d4:87c9:b7f7]) by DM5PR15MB1290.namprd15.prod.outlook.com
 ([fe80::e828:23d4:87c9:b7f7%5]) with mapi id 15.20.1792.009; Wed, 10 Apr 2019
 17:27:21 +0000
From:   Chris Mason <clm@fb.com>
To:     Nikolay Borisov <nborisov@suse.com>
CC:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Is it a good idea to replace current eb leakage detector with
 bcc/ebpf based one?
Thread-Topic: Is it a good idea to replace current eb leakage detector with
 bcc/ebpf based one?
Thread-Index: AQHU72d2H+rWU5as80Gju7lIaepo3KY09POAgACxhgA=
Date:   Wed, 10 Apr 2019 17:27:20 +0000
Message-ID: <BE0ED7EE-44FF-41E7-ADEF-8406912003E3@fb.com>
References: <d0a50191-4506-7e21-5be9-4a5940563904@gmx.com>
 <b902732c-93e9-ddb5-231b-69012abf9d70@suse.com>
In-Reply-To: <b902732c-93e9-ddb5-231b-69012abf9d70@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.4r5594)
x-clientproxiedby: BN6PR16CA0022.namprd16.prod.outlook.com
 (2603:10b6:404:f5::32) To DM5PR15MB1290.namprd15.prod.outlook.com
 (2603:10b6:3:b3::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::6c86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b276043d-2b71-4f8a-4047-08d6bdd9c95e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:DM5PR15MB1385;
x-ms-traffictypediagnostic: DM5PR15MB1385:
x-microsoft-antispam-prvs: <DM5PR15MB1385318D48DA9734F7610766D32E0@DM5PR15MB1385.namprd15.prod.outlook.com>
x-forefront-prvs: 00032065B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(396003)(136003)(39860400002)(189003)(199004)(4326008)(478600001)(106356001)(81166006)(33656002)(6246003)(256004)(14444005)(82746002)(83716004)(81156014)(105586002)(71190400001)(71200400001)(8936002)(8676002)(229853002)(50226002)(14454004)(2906002)(6486002)(25786009)(186003)(6436002)(54906003)(446003)(6116002)(97736004)(99286004)(68736007)(36756003)(7736002)(476003)(386003)(6506007)(53936002)(305945005)(486006)(2616005)(76176011)(316002)(11346002)(6916009)(53546011)(102836004)(5660300002)(46003)(6512007)(86362001)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1385;H:DM5PR15MB1290.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: usBhEhZhxxeJIMOvZ58oWBKntXlgDjpIlgbwZ0MERZvmZcxeJzu8hKlyxOwg0HA+cmhw59e0he9nqBd5lmuRZKWnG8Bf2rGpodJoV5OYozFrLw+oJQpoJyREwsNU3reasPGzv8SVY5RW47r1YzSbpbeVePfSCOrSTborgrSMff8yJGwVJDbcwS7LbUN8GR6KJ9+PGnP4EFyKCr6GFDZRuwCjCWFDNB1Z5yWaSdpE6KYsL1uDK77BYXk15h6H7rjBSdKRGoDUEw6Utkq2WiDm0rLn1c57+nkLug5Y8IeqWB5aBSRVH+OgYViIekFB4+1WJrDxLSZpagD8Ckt5SEWtoPDGeKkJkseBz67htAqloT2a1XH052vUTYR19AjwV8bIcIXrscO+XIw197p4rflmFNs9CeoDdaWNiJm+B24behA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <64669EB23DB24E4ABF6F8DD7C4EAFC62@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b276043d-2b71-4f8a-4047-08d6bdd9c95e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2019 17:27:20.9719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1385
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-10_08:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAgQXByIDIwMTksIGF0IDI6NTEsIE5pa29sYXkgQm9yaXNvdiB3cm90ZToNCg0KPiBPbiAx
MC4wNC4xOSDQsy4gOTozNCDRhy4sIFF1IFdlbnJ1byB3cm90ZToNCj4+IEhpLA0KPj4NCj4+IEFz
IHdlIGhhdmUgbWVtbGVhay5weSBpbiBiY2MgdG9vbHMsIGFuZCBpdCBwcm92aWRlcyBiZXR0ZXIg
aW5mbw0KPj4gaW5jbHVkaW5nIHRoZSBjYWxsaW5nIHN0YWNrLCBJJ20gd29uZGVyaW5nIGlmIHdl
IHNob3VsZCByZXBsYWNlIA0KPj4gY3VycmVudA0KPj4gZWIgbGVha2FnZSBjaGVjayB3aXRoIGJj
YyBiYXNlZCBvbmUuDQo+Pg0KPj4gQW55IGlkZWEgb24gdGhpcz8NCj4NCj4gV2h5IGRvIHlvdSB3
YW50IHRvIGNoYW5nZSBpdCwgZ2l2ZW4gdGhhdCB0aGUgZXhpc3Rpbmcgb25lIGlzIG9ubHkNCj4g
YWN0aXZhdGUgaWYgYnRyZnMgaXMgY29tcGlsZWQgd2l0aCBkZWJ1ZyBlbmFibGVkIGFuZCBpcyAi
c2VhbWxlc3MiPyANCj4gV2hhdA0KPiBhcmUgd2UgZ29pbmcgdG8gZ2FpbiBieSBpbnRyb2R1Y2lu
ZyB5ZXQgYW5vdGhlciB0b29sIG9yIHJlcGxhY2luZyBhbg0KPiBleGlzdGluZyBpbmZyYXN0cnVj
dHVyZSB3aXRoIGJjYyAob3Igd2hhdGV2ZXIpIGJhc2VkIG9uZT8NCg0KYmNjL2JwZiBhcmUgYWJs
ZSB0byBnaXZlIG11Y2ggbW9yZSBpbmZvcm1hdGlvbiBhYm91dCB3aGljaCBjYWxsIGNoYWluIA0K
YWxsb2NhdGVkIHRoZSBleHRlbnQgYnVmZmVyLCBidXQgdW5mb3J0dW5hdGVseSBhbG1vc3QgYWxs
IGViJ3MgY29tZSBmcm9tIA0KdGhlIHNhbWUgcGxhY2UuICBCdXQsIHRoZSBicGYgdmVyc2lvbiBj
b3VsZCByZW1lbWJlciBldmVyeSBjYWxsIHN0YWNrIA0KdGhhdCBkaWQgYW4gaW5jL2RlYyBvbiB0
aGUgcmVmZXJlbmNlIGNvdW50ZXIsIHdoaWNoIGRvZXMgbWFrZSBpdCANCmRyYW1hdGljYWxseSBl
YXNpZXIgdG8gdHJhY2sgZG93biBsZWFrcy4NCg0KV2l0aCBhbGwgb2YgdGhhdCBzYWlkLCB0aGUg
cmVhbCByZWFzb24gSSBsb3ZlIHRoZSBleHRlbnQgYnVmZmVyIGxlYWsgDQpjb2RlIGlzIHRoYXQg
d2hlbiBjaGFzaW5nIGRvd24gYSBsZWFrLCBJIGNvdWxkIHJtbW9kIGJ0cmZzLCBoYXZlIHRoZSAN
CmxlYWsgZGV0ZWN0b3IgcHJpbnQgYSBoZWxwZnVsIHdhcm5pbmcsIGFuZCB0aGVuIGNsZWFudXAg
dGhlIHNsYWIgY2FjaGUgDQpzbyB0aGF0IEkgZGlkbid0IGhhdmUgdG8gcmVib290IHRoZSB0ZXN0
IG1hY2hpbmUuDQoNCmJwZiBjb2RlIG9uIHRvcCBjb3VsZCBkZWZpbml0ZWx5IG1ha2UgaXQgZmFz
dGVyIHRvIGZpbmQgdGhlIGNhdXNlIG9mIA0KbGVha3MsIGJ1dCBJIHRoaW5rIHRoZSBzbGFiIGNs
ZWFudXAgaXMgd29ydGgga2VlcGluZyBhcm91bmQuDQoNCi1jaHJpcw0K
