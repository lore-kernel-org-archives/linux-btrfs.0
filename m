Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA2BC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 17:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6BE721104
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 17:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="T10WQ3RB";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="iaS1eeSl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6BE721104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbeKTEXC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:23:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57986 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731799AbeKTEXB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 23:23:01 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.22/8.16.0.22) with SMTP id wAJHnWGC014530;
        Mon, 19 Nov 2018 09:58:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YLkvtDKMeTCSdV4mJDbPSZt3/j01AEzpiKMwB/a3sAs=;
 b=T10WQ3RBhkiHC8b4iPtamAkZZj197misvcM4GUOaiivz22RI9przUfqN552MaL+Ul/55
 z0KnOujP6iLY6SnRTWlbusFDXE5NgP2IUAT0bmz3FQ7ZAqHb6ViWrw/HooOBY+7Pnrl2
 mHQSDrwfpnSXPhnDFjlCRP7+e/lRXBs+43g= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0089730.ppops.net with ESMTP id 2nuxra8qqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Nov 2018 09:58:16 -0800
Received: from frc-mbx02.TheFacebook.com (2620:10d:c0a1:f82::26) by
 frc-hub03.TheFacebook.com (2620:10d:c021:18::173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Mon, 19 Nov 2018 09:58:15 -0800
Received: from frc-hub05.TheFacebook.com (2620:10d:c021:18::175) by
 frc-mbx02.TheFacebook.com (2620:10d:c0a1:f82::26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Mon, 19 Nov 2018 09:58:15 -0800
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Mon, 19 Nov 2018 09:58:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLkvtDKMeTCSdV4mJDbPSZt3/j01AEzpiKMwB/a3sAs=;
 b=iaS1eeSl+4dCzdvOd+UoSBBNq21bS409sFUFWP9T2zhdR5A7czL16Ij4YZo6PyR3rU/F+YDUX/XXI7a1IVX3KqaC202stoQQp8fH1tSx4f/BU3fbx97zVt0cemgQsdEZqtntGXoeDNpnEFcNiKTT2jqXV9b1DJ7VBWPuje6GTY8=
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com (52.132.149.157) by
 MW2PR1501MB2076.namprd15.prod.outlook.com (52.132.150.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.32; Mon, 19 Nov 2018 17:58:12 +0000
Received: from MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::f8d1:59bf:c5a8:1e8]) by MW2PR1501MB1993.namprd15.prod.outlook.com
 ([fe80::f8d1:59bf:c5a8:1e8%4]) with mapi id 15.20.1339.027; Mon, 19 Nov 2018
 17:58:12 +0000
From:   Nick Terrell <terrelln@fb.com>
To:     Daniel Kiper <dkiper@net-space.pl>
CC:     David Sterba <dsterba@suse.cz>, Kernel Team <Kernel-team@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>
Subject: Re: [PATCH v6 2/2] btrfs: Add zstd support to grub btrfs
Thread-Topic: [PATCH v6 2/2] btrfs: Add zstd support to grub btrfs
Thread-Index: AQHUfTPKDutk/PY690KqC9V988FJs6VXLE2AgAAM94CAAC8zlg==
Date:   Mon, 19 Nov 2018 17:58:11 +0000
Message-ID: <B0F4D069-61FF-477B-B256-0C2C34C51BB1@fb.com>
References: <20181115223603.3806542-1-terrelln@fb.com>
 <20181115223603.3806542-3-terrelln@fb.com>
 <20181119142251.xo3xmkbbpr6l22xu@tomti.i.net-space.pl>,<20181119150915.ktbaun6pu5uswgic@tomti.i.net-space.pl>
In-Reply-To: <20181119150915.ktbaun6pu5uswgic@tomti.i.net-space.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::7:9b73]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MW2PR1501MB2076;20:eqDVR1zGtDdnEYCiYwSksSlhf1HoJ6KMrFZ89jxqcaa0wFR6Y0ZeawswczVlr1mqYpPaEaMsRcHGN5HyOiroexXOdwkWgWFKFiVPubsdZeLRFnFxwH+tYP0opZiX1QdbEHGb4QAjiiFJ6QYrU30niMlSyRHjc7Ir2geUjBpU2yU=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: c3558132-e66e-4e24-9bf9-08d64e48926f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:MW2PR1501MB2076;
x-ms-traffictypediagnostic: MW2PR1501MB2076:
x-microsoft-antispam-prvs: <MW2PR1501MB2076A35EBF34693D208D10BEABD80@MW2PR1501MB2076.namprd15.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(67672495146484)(146099531331640);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(823302103)(93006095)(93001095)(10201501046)(3002001)(3231415)(11241501184)(944501410)(52105112)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:MW2PR1501MB2076;BCL:0;PCL:0;RULEID:;SRVR:MW2PR1501MB2076;
x-forefront-prvs: 08617F610C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(366004)(396003)(39860400002)(199004)(189003)(52314003)(6246003)(106356001)(68736007)(105586002)(7736002)(4326008)(305945005)(6916009)(36756003)(6512007)(82746002)(53936002)(2900100001)(6116002)(229853002)(14454004)(81156014)(8676002)(6486002)(8936002)(6436002)(33656002)(97736004)(81166006)(256004)(5660300001)(76176011)(86362001)(46003)(71200400001)(476003)(11346002)(2616005)(446003)(83716004)(25786009)(71190400001)(102836004)(316002)(486006)(186003)(54906003)(53546011)(93886005)(478600001)(99286004)(2906002)(6506007)(17423001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2076;H:MW2PR1501MB1993.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 1m4QbPql7mb1GGGm18zZnoBRgMYDaMeOONl00W8SDCXVhq2mv472zM4WMy6B7UEHaCnTwAQMXDKxsAw7xguT1Z/gKQYgNbsACSjGFdes+CSes2xaWDC3C4PR42M0m+P1NM/Zv/ZQcri14EE7Gd4Pe0Gls2JyhZmwjbderapQBQ1nF3F1QGlSY+PoWPw47vJFWeeHDd78Te1IRwZqk1cDP8uHn3EYJcTgFZlR66delzWK0sm9Kj4jK0OBQE0d4Mn0MzYrVbYI3FxefP3QUsr1bpg9NcsAmlmqYHDCX6bWVHe+TFBZzBus6ZKlWEXn8hKUTxw3Xz6HNfMAlXeSlnuYLV5wBfn/uz0lOp2ar7wWLVA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c3558132-e66e-4e24-9bf9-08d64e48926f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2018 17:58:11.9184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2076
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-19_06:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

PiBPbiBOb3YgMTksIDIwMTgsIGF0IDc6MTEgQU0sIERhbmllbCBLaXBlciA8ZGtpcGVyQG5ldC1z
cGFjZS5wbD4gd3JvdGU6DQo+IA0KPj4gT24gTW9uLCBOb3YgMTksIDIwMTggYXQgMDM6MjI6NTFQ
TSArMDEwMCwgRGFuaWVsIEtpcGVyIHdyb3RlOg0KPj4+IE9uIFRodSwgTm92IDE1LCAyMDE4IGF0
IDAyOjM2OjAzUE0gLTA4MDAsIE5pY2sgVGVycmVsbCB3cm90ZToNCj4+PiAtIEFkZHMgenN0ZCBz
dXBwb3J0IHRvIHRoZSBidHJmcyBtb2R1bGUuDQo+Pj4gLSBBZGRzIGEgdGVzdCBjYXNlIGZvciBi
dHJmcyB6c3RkIHN1cHBvcnQuDQo+Pj4gLSBDaGFuZ2VzIHRvcF9zcmNkaXIgdG8gc3JjZGlyIGlu
IHRoZSBidHJmcyBtb2R1bGUncyBsem8gaW5jbHVkZQ0KPj4+ICBmb2xsb3dpbmcgY29tbWVudHMg
ZnJvbSBEYW5pZWwgS2lwZXIgYWJvdXQgdGhlIHpzdGQgaW5jbHVkZS4NCj4+PiANCj4+PiBUZXN0
ZWQgb24gVWJ1bnR1LTE4LjA0IHdpdGggYSBidHJmcyAvYm9vdCBwYXJ0aXRpb24gd2l0aCBhbmQg
d2l0aG91dCB6c3RkDQo+Pj4gY29tcHJlc3Npb24uIEEgdGVzdCBjYXNlIHdhcyBhbHNvIGFkZGVk
IHRvIHRoZSB0ZXN0IHN1aXRlIHRoYXQgZmFpbHMgYmVmb3JlDQo+Pj4gdGhlIHBhdGNoLCBhbmQg
cGFzc2VzIGFmdGVyLg0KPj4+IA0KPj4+IFNpZ25lZC1vZmYtYnk6IE5pY2sgVGVycmVsbCA8dGVy
cmVsbG5AZmIuY29tPg0KPj4gDQo+PiBSZXZpZXdlZC1ieTogRGFuaWVsIEtpcGVyIDxkYW5pZWwu
a2lwZXJAb3JhY2xlLmNvbT4NCj4+IA0KPj4gSWYgdGhlcmUgYXJlIG5vIG9iamVjdGlvbnMgSSB3
aWxsIGFwcGx5IHRoaXMgcGF0Y2ggc2VyaWVzIGluIGEgd2VlayBvciBzby4NCj4gDQo+IEVycnIu
Li4gSSBoYXZlIGp1c3QgcmVhbGl6ZWQgdGhhdCB0aGVyZSBhcmUgdHdvIG1hbnkgc3BhY2VzIGp1
c3QgYXQgdGhlDQo+IGJlZ2lubmluZyBvZiBtb3N0IGxpbmVzLiBUaGVyZSBzaG91bGQgYmUgMiBp
bnN0ZWFkIG9mIDQuIFBsZWFzZSB0YWtlDQo+IGEgbG9vayBhdCBjdXJyZW50bHkgZXhpc3Rpbmcg
ZnVuY3Rpb25zLiBBbnl3YXksIEkgY2FuIGZpeCB0aGlzIGJlZm9yZQ0KPiBjb21taXR0aW5nLiBI
b3dldmVyLCBpZiB5b3UgY291bGQgcmVwb3N0IHdob2xlIHBhdGNoIHNlcmllcyB0aGF0IHdvdWxk
DQo+IGJlIG11Y2ggZWFzaWVyIGZvciBtZS4NCg0KSeKAmWxsIHNlbmQgYSBuZXcgdmVyc2lvbiB3
aXRoIHRoZSBmb3JtYXR0aW5nIGNoYW5nZXMuDQoNCj4gRGFuaWVsDQoNCi1OaWNr
