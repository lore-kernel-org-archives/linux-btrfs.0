Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BBAC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 13:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25FA12081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 13:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="dTNCqm79";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="XPQJeAR6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25FA12081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbeKAW1j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 18:27:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46942 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727644AbeKAW1j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 18:27:39 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA1DIgBu001952;
        Thu, 1 Nov 2018 06:24:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=77D0CxfQgEVpB58S4hp8V2qwCkt7s/i/7xutSUhsrLI=;
 b=dTNCqm79TCRu2jykwsvgj1W/qIF6kB5ZFM8angnlmdVluBb7xQW0HgLj+D0VoFPvboOP
 NXFk3PsaeB8VVMXmRsV7SWnbvNPAQ8T9qXZJ2DwUSt7Q85qcNzum0vEwLgpH+Osqxfiy
 n39e5M7dj4DCMxB9mkrBaZsUdNFNz6CxvGs= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ng0cw8ajm-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Nov 2018 06:24:26 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Thu, 1 Nov 2018 06:24:18 -0700
Received: from PRN-CHUB05.TheFacebook.com (2620:10d:c081:35::14) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1531.3
 via Frontend Transport; Thu, 1 Nov 2018 06:24:18 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.15) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Thu, 1 Nov 2018 06:24:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77D0CxfQgEVpB58S4hp8V2qwCkt7s/i/7xutSUhsrLI=;
 b=XPQJeAR6zTE1w/Xtqt7mQUXFd7PNnivm6V1eM+7QN6fwMV1TUH+SLR6+bijzvd6UEaJtRQDX6aubxzZfuhBAAPWemT9F8AFhK1taWPFfgg4xo2V3yC9BX3HiOViOGWfoMlXv0SGXe7Yo0exKIk083ZaszR0G8PLuOKsclBR28hE=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1290.namprd15.prod.outlook.com (10.173.209.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Thu, 1 Nov 2018 13:24:16 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::6023:3276:3d78:5943]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::6023:3276:3d78:5943%2]) with mapi id 15.20.1294.021; Thu, 1 Nov 2018
 13:24:16 +0000
From:   Chris Mason <clm@fb.com>
To:     ethanlien <ethanlien@synology.com>
CC:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-btrfs-owner@vger.kernel.org" 
        <linux-btrfs-owner@vger.kernel.org>
Subject: Re: [PATCH] btrfs: use tagged writepage to mitigate livelock of
 snapshot
Thread-Topic: [PATCH] btrfs: use tagged writepage to mitigate livelock of
 snapshot
Thread-Index: AQHUca8j8ltX9bkolUScDutzzhqzpqU6nxEAgAAP8gCAAAFBAIAABcsAgAAy7oA=
Date:   Thu, 1 Nov 2018 13:24:15 +0000
Message-ID: <67AC0ECC-B2EA-40EB-AB7B-150C7F359396@fb.com>
References: <20181101064903.11638-1-ethanlien@synology.com>
 <2e566c40-f61e-6cea-42ba-c0c3fa3b9d76@suse.com>
 <33824f7912f4d590d2425ef0ecebd039@synology.com>
 <5ebd95dc-f684-baef-494d-1a40760e6157@suse.com>
 <6404da122f4d63c5dfa6b6c256114b28@synology.com>
In-Reply-To: <6404da122f4d63c5dfa6b6c256114b28@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.10r5443)
x-clientproxiedby: BN6PR1101CA0010.namprd11.prod.outlook.com
 (2603:10b6:405:4a::20) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:ebf4]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1290;20:ldLb88IuUBpb+3swDdzMglueO1tly9AFm/xE6T33nnEzDRU6qwOtJXD8cdNx8y/xN3uRlzqGxcuRChmFMvQpSRRy0PDkNN8mMbirTiP/UGv4wFDMe2fVGKzMtPSvxH9E+E1XepcF56+tPsLGhD+Cc7U9BcDelfEbDUl2xCdrAAU=
x-ms-office365-filtering-correlation-id: 6c1dfe26-01bb-459d-2e15-08d63ffd5224
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1290;
x-ms-traffictypediagnostic: DM5PR15MB1290:
x-microsoft-antispam-prvs: <DM5PR15MB129034EBF0E5733041575B21D3CE0@DM5PR15MB1290.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(163750095850);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(10201501046)(93006095)(93001095)(3231382)(11241501184)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1290;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1290;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39860400002)(136003)(199004)(189003)(6246003)(6116002)(14444005)(81156014)(68736007)(478600001)(93886005)(2900100001)(53936002)(81166006)(8676002)(97736004)(106356001)(105586002)(256004)(5660300001)(6512007)(86362001)(229853002)(6506007)(8936002)(46003)(316002)(7736002)(53546011)(2906002)(476003)(2616005)(386003)(102836004)(54906003)(14454004)(83716004)(446003)(11346002)(71190400001)(71200400001)(36756003)(99286004)(6436002)(50226002)(6916009)(4326008)(82746002)(33656002)(5250100002)(76176011)(6486002)(486006)(186003)(25786009)(305945005)(52116002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1290;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 036UxCho91JyAkXPb+LXY1DpJdLZUPv2hJ4ihoyNLFUyYTXrc4hAg8Ep5L5Iw61XctYLv2Lsi3UtzpYaNuvbz4MimiQyWIIWQ7W5K4RljigFNJHobTi5pxN0SZwPBbM6oGksTQYmCo1ruDDrz3CeZTAKmL/cq6ooGgxTuZFm/CNOzZekqVhB6Ve4Fftl/dRbQTR3v5TJ3bzi9A12gkOZ97a0IDAhvYnaJdNruaQYDvVxBqX53Oq6pYgxK8Zr8rC/HwNAfyEpkVRmGyQHGSEV7K2j4iCL7dE3UH7tiypSjWHWCBppwgr/1bKu3MCMQWScIzwNjoHyPtjQxdooVMoaF+Ixhk59wnvKhJgcQEGP2as=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <35447163E29D6B4E928E0336FEE3C32B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1dfe26-01bb-459d-2e15-08d63ffd5224
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 13:24:16.0065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1290
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-01_09:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMSBOb3YgMjAxOCwgYXQgNjoyMSwgZXRoYW5saWVuIHdyb3RlOg0KDQo+IE5pa29sYXkgQm9y
aXNvdiDmlrwgMjAxOC0xMS0wMSAxODowMSDlr6vliLA6DQo+PiBPbiAxLjExLjE4INCzLiAxMTo1
NiDRhy4sIGV0aGFubGllbiB3cm90ZToNCj4+PiBOaWtvbGF5IEJvcmlzb3Yg5pa8IDIwMTgtMTEt
MDEgMTY6NTkg5a+r5YiwOg0KPj4+PiBPbiAxLjExLjE4INCzLiA4OjQ5INGHLiwgRXRoYW4gTGll
biB3cm90ZToNCj4+Pj4+IFNuYXBzaG90IGlzIGV4cGVjdGVkIHRvIGJlIGZhc3QuIEJ1dCBpZiB0
aGVyZSBhcmUgd3JpdGVycyBzdGVhZGlseQ0KPj4+Pj4gY3JlYXRlIGRpcnR5IHBhZ2VzIGluIG91
ciBzdWJ2b2x1bWUsIHRoZSBzbmFwc2hvdCBtYXkgdGFrZSBhIHZlcnkgDQo+Pj4+PiBsb25nDQo+
Pj4+PiB0aW1lIHRvIGNvbXBsZXRlLiBUbyBmaXggdGhlIHByb2JsZW0sIHdlIHVzZSB0YWdnZWQg
d3JpdGVwYWdlIGZvcg0KPj4+Pj4gc25hcHNob3QNCj4+Pj4+IGZsdXNoZXIgYXMgd2UgZG8gaW4g
dGhlIGdlbmVyaWMgd3JpdGVfY2FjaGVfcGFnZXMoKSwgc28gd2UgY2FuIA0KPj4+Pj4gb21taXQN
Cj4+Pj4+IHBhZ2VzDQo+Pj4+PiBkaXJ0aWVkIGFmdGVyIHRoZSBzbmFwc2hvdCBjb21tYW5kLg0K
Pj4+Pg0KPj4+PiBTbyB0aGUgZ2lzdCBvZiB0aGlzIGNvbW1pdCByZWFsbHkgaXMgdGhhdCB5b3Ug
ZGV0ZWN0IHdoZW4gDQo+Pj4+IGZpbGVtYXBfZmx1c2gNCj4+Pj4gaGFzIGJlZW4gY2FsbGVkIGZy
b20gc25hcHNob3QgY29udGV4dCBhbmQgdGFnIGFsbCBwYWdlcyBhdCAqdGhhdCogDQo+Pj4+IHRp
bWUNCj4+Pj4gYXMgUEFHRUNBQ0hFX1RBR19UT1dSSVRFIGFuZCB0aGVuIHdyaXRlIHRoZW0sIGln
bm9yaW5nIGFueSBwYWdlcyANCj4+Pj4gdGhhdA0KPj4+PiBtaWdodCBoYXZlIGJlZW4gZGlydGll
ZCBiZWZvcmVoYW5kLiBZb3VyIGRlc2NyaXB0aW9uIGtpbmQgb2YgZGFuY2VzDQo+Pj4+IGFyb3Vu
ZCB0aGlzIGlkZWEgd2l0aG91dCByZWFsbHkgc2F5aW5nIGl0IGV4cGxpY2l0bHkuIFRob3NlIA0K
Pj4+PiBzZW1hbnRpY3MNCj4+Pj4gbWFrZSBzZW5zZSwgaG93ZXZlciBpJ2QgbGlrZSB0byBiZSBz
dGF0ZWQgbW9yZSBleHBsaWNpdGx5IGluIHRoZSANCj4+Pj4gY2hhbmdlDQo+Pj4+IMKgbG9nLg0K
Pj4+Pg0KPj4+PiBIb3dldmVyLCB0aGlzIGlzIGRvbmUgYXQgdGhlIGV4cGVuc2Ugb2YgY29uc2lz
dGVuY3ksIHNvIHdlIGhhdmUgDQo+Pj4+IGZhc3Rlcg0KPj4+PiBzbmFwc2hvdHMgYnV0IGRlcGVu
ZGluZyB0aGUgZmlsZSB3aGljaCBhcmUgc3RvcmVkIGluIHRoZW0gdGhleSANCj4+Pj4gbWlnaHQg
YmUNCj4+Pj4gYnJva2VuIChpLmUgYSBkYXRhYmFzZSkgc2luY2UgdGhleSB3aWxsIGJlIG1pc3Np
bmcgcGFnZXMuDQo+Pj4+DQo+Pj4NCj4+PiB0YWdfcGFnZXNfZm9yX3dyaXRlYmFjaygpIHdpbGwg
dGFnIGFsbCBwYWdlcyB3aXRoIA0KPj4+IFBBR0VDQUNIRV9UQUdfRElSVFkuDQo+Pj4gSWYgYSBk
aXJ0eQ0KPj4+IHBhZ2UgZ2V0IG1pc3NlZCBoZXJlLCBpdCBtZWFucyBzb21lb25lIGhhcyBpbml0
aWF0ZWQgdGhlIGZsdXNoIA0KPj4+IGJlZm9yZQ0KPj4+IHVzLCBzbyB3ZQ0KPj4+IHdpbGwgd2Fp
dCB0aGF0IGRpcnR5IHBhZ2UgdG8gY29tcGxldGUgaW4gY3JlYXRlX3NuYXBzaG90KCkgLT4NCj4+
PiBidHJmc193YWl0X29yZGVyZWRfZXh0ZW50cygpLg0KPj4NCj4+IEFuZCB3aGF0IGhhcHBlbnMg
aW4gdGhlIHNjZW5hcmlvIHdoZXJlIHlvdSBoYXZlICBzb21lb25lIGRpcnR5aW5nIA0KPj4gcGFn
ZXMsDQo+PiB5b3UgaXNzdWUgdGhlIHNuYXBzaG90IGlvY3RsLCBtYXJrIGFsbCBjdXJyZW50bHkg
ZGlydGllZCBwYWdlcyBhcw0KPj4gVE9XUklURSBhbmQgdGhlbiB5b3UgaGF2ZSBtb3JlIGRlbGFs
bG9jIHBhZ2VzIGJlaW5nIGRpcnRpZWQgZm9sbG93aW5nDQo+PiBpbml0aWFsIGNhbGwgdG8gdGFn
X3BhZ2VzX2Zvcl93cml0ZWJhY2sgLCB5b3Ugd2lsbCBtaXNzIHRob3NlLCBubyA/DQo+Pg0KPg0K
PiBXZSBkb24ndCBmcmVlemUgdGhlIGZpbGVzeXN0ZW0gd2hlbiBkb2luZyBzbmFwc2hvdCwgc28g
dGhlcmUgaXMgbm8gDQo+IGd1YXJhbnRlZQ0KPiB0aGUgcGFnZSBkaXJ0aWVkIHJpZ2h0IGFmdGVy
IHdlIHNlbmQgdGhlIGlvY3RsLCB3aWxsIGJlIGluY2x1ZGVkIGluIA0KPiBzbmFwc2hvdC4NCj4g
SWYgYSBwYWdlIGlzIGRpcnRpZWQgd2hpbGUgd2Ugc2NhbiB0aGUgZGlydHkgcGFnZXMgYW5kIGl0
cyBvZmZzZXQgaXMgDQo+IGJlZm9yZSBvdXINCj4gY3VycmVudCBpbmRleCwgd2UgbWlzcyBpdCBp
biBvdXIgY3VycmVudCBzbmFwc2hvdCBpbXBsZW1lbnRhdGlvbiB0b28uDQoNClRoaXMgbG9va3Mg
bGlrZSBhIHByZXR0eSBnb29kIGNvbXByb21pc2UgdG8gbWUgYmV0d2VlbiBidHJmcyB2MCdzIGRv
bid0IA0KZmx1c2ggYXQgYWxsIG9uIHNuYXBzaG90IGFuZCB0b2RheSdzIGZ1bGwgc3luYyBvbiBz
bmFwc2hvdC4gIFRoZSBmdWxsIA0Kc3luYyBpcyBhbHdheXMgZ29pbmcgdG8gYmUgYSBsaXR0bGUg
cmFjZXkgd3J0IGNvbmN1cnJlbnQgd3JpdGVzLg0KDQotY2hyaXMNCg==
