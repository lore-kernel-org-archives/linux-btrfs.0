Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF2EC6786F
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBAD22064C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="QOAjJLKC";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="djzeC6iO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBAD22064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbeKBAoG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:44:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45844 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727950AbeKBAoF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 20:44:05 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA1FeRkj001716;
        Thu, 1 Nov 2018 08:40:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=U0ilg3+rclR6MBPZArRUGp7M72Yk4QqdjYitBAP9Lvk=;
 b=QOAjJLKCVLPbbMoiJwNzetAPfQxe3PDs56oxPSFv8l58qGvjhM8AGySX1Vy2/ukpoe7i
 vJi3yGRVdkAgMvbK2ZhlNYnsNvI2dwqQca265ew+6P3rcRdZ3wjL+xZAFYEiNu1hDzdb
 5QN7nJzkthJ/nm61ZCTWeyOWlp9c23x7PmE= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ng3qx84yh-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Nov 2018 08:40:35 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Thu, 1 Nov 2018 08:40:07 -0700
Received: from PRN-CHUB08.TheFacebook.com (2620:10d:c081:35::17) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1531.3
 via Frontend Transport; Thu, 1 Nov 2018 08:40:07 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.18) with Microsoft SMTP Server (TLS)
 id 14.3.361.1; Thu, 1 Nov 2018 08:40:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0ilg3+rclR6MBPZArRUGp7M72Yk4QqdjYitBAP9Lvk=;
 b=djzeC6iO6hvWQfA07gziWm/qXVizqDsKxpI9oFkbHSPMcjNQ8iVAmaTOVZN1CQJhrJfR6ks0B00aZKvr8UsB9qPnbwLCQDxqq9ipzQzkYl+kr1hZ+kIN/uGCb2xI2CNPDKLFmev8YWBYeXgKlhG1b+dI2w2C//ARGiGzgJFLYhI=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2025.namprd15.prod.outlook.com (52.132.150.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Thu, 1 Nov 2018 15:40:05 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::c554:8f41:4255:796f]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::c554:8f41:4255:796f%3]) with mapi id 15.20.1294.024; Thu, 1 Nov 2018
 15:40:05 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Timofey Titovets <nefelim4ag@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>, Omar Sandoval <osandov@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "jenniferliu620@fb.com" <jenniferliu620@fb.com>
Subject: Re: [PATCH v2] btrfs: add zstd compression level support
Thread-Topic: [PATCH v2] btrfs: add zstd compression level support
Thread-Index: AQHUcUU6RfVouuPlxU+dBPN4xpFtkKU6sA0AgABfuIA=
Date:   Thu, 1 Nov 2018 15:40:05 +0000
Message-ID: <3018B572-E3B9-4212-A8DE-506CF9907EED@fb.com>
References: <20181031181108.289340-1-terrelln@fb.com>
 <CAGqmi75-K4sZmSgp6f-zCki9FWga_vvKZ-9ajtV71hSwac9tqA@mail.gmail.com>
In-Reply-To: <CAGqmi75-K4sZmSgp6f-zCki9FWga_vvKZ-9ajtV71hSwac9tqA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c091:200::5:8512]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2025;20:k3ojMMe+UofobgHTivlkg0+DbRSjqJMYUSfq9+tq2fDsCc2wWRqAMpOQJVk135xBYto81XYPUGjrgH+dIgOC5Q8AWiYiyVN3Q1PXl7m7xFf6mVDmD95+Zqu+KZcQVTWfC/8abYq+QNgTY1y3dc3wFa5V8tKF93P27D7AySUFjUc=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-ms-office365-filtering-correlation-id: 300df58b-5cc6-4891-ad9e-08d640104bcc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2025;
x-ms-traffictypediagnostic: MW2PR1501MB2025:
x-microsoft-antispam-prvs: <MW2PR1501MB202509B5010AFBF390948212ABCE0@MW2PR1501MB2025.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(192278398808882)(166708455590820)(85827821059158)(67672495146484);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(823302103)(3002001)(10201501046)(93006095)(93001095)(3231382)(11241501184)(944501410)(4982022)(52105095)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:MW2PR1501MB2025;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2025;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(376002)(39860400002)(366004)(199004)(189003)(476003)(6486002)(6436002)(68736007)(229853002)(14454004)(478600001)(83716004)(102836004)(53546011)(6506007)(6246003)(6512007)(16799955002)(6306002)(256004)(14444005)(53936002)(347745004)(486006)(6916009)(2616005)(97736004)(39060400002)(76176011)(71200400001)(966005)(71190400001)(5250100002)(4326008)(36756003)(25786009)(2900100001)(46003)(446003)(106356001)(81156014)(105586002)(81166006)(8936002)(8676002)(15188155005)(11346002)(82746002)(7736002)(54906003)(5660300001)(99286004)(305945005)(186003)(86362001)(2906002)(6116002)(33656002)(316002)(1411001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2025;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: FGRX/URp9g4phjjiNZA/tlH4R1Q4sNmQsoMS68u2gaWVcnt7GjnzKvPt2zjpkhufDQswA9R6OBCh6tG7nR7+EZ61kFCLeKvfdD3k2MXvAmT2leKNc8nzNRz6Yhbre/w0M/2mXN2l2cFJzqGdpfWfFg+0gaWDV0R4UeCCWO8VOB4QCC7+Ndk6lYLkQPaYR7smks53X7MUuW1B3ChYGgU2zzzr5vkcnVYlA7LviSBuTpRBnWs1QeeN+Yf8uV1i0Hn43XgaE1UtVVHnV9axdUJAReRuar93Gi9ooRTzNrtpp737xk4Gfd9EgSvJA3XMdKOBy0wSCkTifP43+/Tvs+tamyUg6qC8OmywSk3ff+toxY0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9ED2859780CA84B996D48293553BDA1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 300df58b-5cc6-4891-ad9e-08d640104bcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 15:40:05.3492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2025
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-01_11:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

DQoNCj4gT24gTm92IDEsIDIwMTgsIGF0IDU6NTcgQU0sIFRpbW9mZXkgVGl0b3ZldHMgPG5lZmVs
aW00YWdAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+INGB0YAsIDMxINC+0LrRgi4gMjAxOCDQsy4g
0LIgMjE6MTIsIE5pY2sgVGVycmVsbCA8dGVycmVsbG5AZmIuY29tPjoNCj4+IA0KPj4gRnJvbTog
SmVubmlmZXIgTGl1IDxqZW5uaWZlcmxpdTYyMEBmYi5jb20+DQo+PiANCj4+IEFkZHMgenN0ZCBj
b21wcmVzc2lvbiBsZXZlbCBzdXBwb3J0IHRvIGJ0cmZzLiBac3RkIHJlcXVpcmVzDQo+PiBkaWZm
ZXJlbnQgYW1vdW50cyBvZiBtZW1vcnkgZm9yIGVhY2ggbGV2ZWwsIHNvIHRoZSBkZXNpZ24gaGFk
DQo+PiB0byBiZSBtb2RpZmllZCB0byBhbGxvdyBzZXRfbGV2ZWwoKSB0byBhbGxvY2F0ZSBtZW1v
cnkuIFdlDQo+PiBwcmVhbGxvY2F0ZSBvbmUgd29ya3NwYWNlIG9mIHRoZSBtYXhpbXVtIHNpemUg
dG8gZ3VhcmFudGVlDQo+PiBmb3J3YXJkIHByb2dyZXNzLiBUaGlzIGZlYXR1cmUgaXMgZXhwZWN0
ZWQgdG8gYmUgdXNlZnVsIGZvcg0KPj4gcmVhZC1tb3N0bHkgZmlsZXN5c3RlbXMsIG9yIHdoZW4g
Y3JlYXRpbmcgaW1hZ2VzLg0KPj4gDQo+PiBCZW5jaG1hcmtzIHJ1biBpbiBxZW11IG9uIEludGVs
IHg4NiB3aXRoIGEgc2luZ2xlIGNvcmUuDQo+PiBUaGUgYmVuY2htYXJrIG1lYXN1cmVzIHRoZSB0
aW1lIHRvIGNvcHkgdGhlIFNpbGVzaWEgY29ycHVzIFswXSB0bw0KPj4gYSBidHJmcyBmaWxlc3lz
dGVtIDEwIHRpbWVzLCB0aGVuIHJlYWQgaXQgYmFjay4NCj4+IA0KPj4gVGhlIHR3byBpbXBvcnRh
bnQgdGhpbmdzIHRvIG5vdGUgYXJlOg0KPj4gLSBUaGUgZGVjb21wcmVzc2lvbiBzcGVlZCBhbmQg
bWVtb3J5IHJlbWFpbnMgY29uc3RhbnQuDQo+PiAgVGhlIG1lbW9yeSByZXF1aXJlZCB0byBkZWNv
bXByZXNzIGlzIHRoZSBzYW1lIGFzIGxldmVsIDEuDQo+PiAtIFRoZSBjb21wcmVzc2lvbiBzcGVl
ZCBhbmQgcmF0aW8gd2lsbCB2YXJ5IGJhc2VkIG9uIHRoZSBzb3VyY2UuDQo+PiANCj4+IExldmVs
ICAgUmF0aW8gICBDb21wcmVzc2lvbiAgICAgRGVjb21wcmVzc2lvbiAgIENvbXByZXNzaW9uIE1l
bW9yeQ0KPj4gMSAgICAgICAyLjU5ICAgIDE1MyBNQi9zICAgICAgICAxMTIgTUIvcyAgICAgICAg
MC44IE1CDQo+PiAyICAgICAgIDIuNjcgICAgMTM2IE1CL3MgICAgICAgIDExMyBNQi9zICAgICAg
ICAxLjAgTUINCj4+IDMgICAgICAgMi43MiAgICAxMDYgTUIvcyAgICAgICAgMTE1IE1CL3MgICAg
ICAgIDEuMyBNQg0KPj4gNCAgICAgICAyLjc4ICAgIDg2ICBNQi9zICAgICAgICAxMDkgTUIvcyAg
ICAgICAgMC45IE1CDQo+PiA1ICAgICAgIDIuODMgICAgNjkgIE1CL3MgICAgICAgIDEwOSBNQi9z
ICAgICAgICAxLjQgTUINCj4+IDYgICAgICAgMi44OSAgICA1MyAgTUIvcyAgICAgICAgMTEwIE1C
L3MgICAgICAgIDEuNSBNQg0KPj4gNyAgICAgICAyLjkxICAgIDQwICBNQi9zICAgICAgICAxMTIg
TUIvcyAgICAgICAgMS40IE1CDQo+PiA4ICAgICAgIDIuOTIgICAgMzQgIE1CL3MgICAgICAgIDEx
MCBNQi9zICAgICAgICAxLjggTUINCj4+IDkgICAgICAgMi45MyAgICAyNyAgTUIvcyAgICAgICAg
MTA5IE1CL3MgICAgICAgIDEuOCBNQg0KPj4gMTAgICAgICAyLjk0ICAgIDIyICBNQi9zICAgICAg
ICAxMDkgTUIvcyAgICAgICAgMS44IE1CDQo+PiAxMSAgICAgIDIuOTUgICAgMTcgIE1CL3MgICAg
ICAgIDExNCBNQi9zICAgICAgICAxLjggTUINCj4+IDEyICAgICAgMi45NSAgICAxMyAgTUIvcyAg
ICAgICAgMTEzIE1CL3MgICAgICAgIDEuOCBNQg0KPj4gMTMgICAgICAyLjk1ICAgIDEwICBNQi9z
ICAgICAgICAxMTEgTUIvcyAgICAgICAgMi4zIE1CDQo+PiAxNCAgICAgIDIuOTkgICAgNyAgIE1C
L3MgICAgICAgIDExMCBNQi9zICAgICAgICAyLjYgTUINCj4+IDE1ICAgICAgMy4wMyAgICA2ICAg
TUIvcyAgICAgICAgMTEwIE1CL3MgICAgICAgIDIuNiBNQg0KPj4gDQo+PiBbMF0gaHR0cDovL3N1
bi5hZWkucG9sc2wucGwvfnNkZW9yL2luZGV4LnBocD9wYWdlPXNpbGVzaWENCj4+IA0KPj4gU2ln
bmVkLW9mZi1ieTogSmVubmlmZXIgTGl1IDxqZW5uaWZlcmxpdTYyMEBmYi5jb20+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBOaWNrIFRlcnJlbGwgPHRlcnJlbGxuQGZiLmNvbT4NCj4+IFJldmlld2VkLWJ5
OiBPbWFyIFNhbmRvdmFsIDxvc2FuZG92QGZiLmNvbT4NCg0KPHNuaXA+DQoNCj4gDQo+IFlvdSBk
aWRuJ3QgbWVudGlvbiwgc286DQo+IERpZCB5b3UgdGVzdCBjb21wcmVzc2lvbiByYXRpby9wZXJm
b3JtYW5jZSB3aXRoIGNvbXByZXNzLWZvcmNlIG9yIGp1c3QgY29tcHJlc3M/DQoNCkkgdGVzdGVk
IHdpdGggY29tcHJlc3MtZm9yY2UsIHNpbmNlIEkganVzdCByZXVzZWQgbXkgc2NyaXB0IGZyb20g
YmVmb3JlIFswXS4NCg0KSSByZXJhbiBzb21lIGxldmVscyB3aXRoIGNvbXByZXNzIGFuZCBnb3Qg
dGhlc2UgbnVtYmVyczoNCg0KTGV2ZWwJUmF0aW8JQ29tcHJlc3Npb24JRGVjb21wcmVzc2lvbg0K
MSAgICAJMi4yMSAJMTU4IE1CL3MgICAJMTEzIE1CL3MNCjMgICAgCTIuMjggCTExNyBNQi9zICAg
CTExMyBNQi9zDQo1ICAgIAkyLjMyIAk4MSAgTUIvcyAgIAkxMTIgTUIvcw0KNyAgICAJMi4zNyAJ
NDcgIE1CL3MgICAJMTE2IE1CL3MNCjE1ICAgCTIuNDEgCTcgICBNQi9zICAgCTExNSBNQi9zDQoN
ClVzaW5nIGNvbXByZXNzIHByb2JhYmx5IG1ha2VzIHNlbnNlIHdpdGggbG93ZXIgbGV2ZWxzLCB0
byBnZXQgaGlnaGVyIHdyaXRlIHNwZWVkcywNCmJ1dCBpZiB5b3UncmUgdXNpbmcgaGlnaGVyIGNv
bXByZXNzaW9uIGxldmVscywgeW91J2xsIGxpa2VseSB3YW50IHRvIHVzZSBjb21wcmVzcy1mb3Jj
ZSwNCnNpbmNlIHlvdSBsaWtlbHkgZG9uJ3QgY2FyZSB0b28gbXVjaCBhYm91dCB3cml0ZSBzcGVl
ZHMuIE9idmlvdXNseSB0aGlzIHdpbGwgZGVwZW5kIG9uDQp0aGUgZGF0YSB5b3UncmUgY29tcHJl
c3NpbmcuDQoNClswXSBodHRwczovL2dpc3QuZ2l0aHViLmNvbS90ZXJyZWxsbi81MWVkM2M5ZGE2
Zjk0ZDYxM2MwMWZjZGFlNjA1NjdlOA0KDQotTmljaw0KDQo+IA0KPiBUaGFua3MuDQo+IA0KPiAt
LSANCj4gSGF2ZSBhIG5pY2UgZGF5LA0KPiBUaW1vZmV5Lg0KDQo=
