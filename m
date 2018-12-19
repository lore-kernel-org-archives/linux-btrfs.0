Return-Path: <SRS0=k4qV=O4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C46DC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 14:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 049CA20874
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 14:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="JxP2XRm7";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="Ka+ZZjQn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbeLSOWp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 09:22:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728448AbeLSOWo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 09:22:44 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wBJEI6cU001893;
        Wed, 19 Dec 2018 06:22:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4JetbmWPSjdbO7Path8QDVeWmSy54UMhf4bJVc+LBe8=;
 b=JxP2XRm7RQa23sOxZCzRuDYvlkBwh0rHAYpipi6NB2linaHvdF3P1PhGDo5ieTb1U74j
 8D+qqXtLhYsNUAJ9y3cQ98+kmyg3oa9d0q8zZb3nZQ8Agw4eESNk6taSMRPZETpGelNm
 ST3EZttDJWDDYNDa9lGFoSxVEJwPM0zvMD4= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2pfkyt0m9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Dec 2018 06:22:25 -0800
Received: from frc-mbx07.TheFacebook.com (2620:10d:c0a1:f82::31) by
 frc-hub01.TheFacebook.com (2620:10d:c021:18::171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Wed, 19 Dec 2018 06:22:24 -0800
Received: from frc-hub01.TheFacebook.com (2620:10d:c021:18::171) by
 frc-mbx07.TheFacebook.com (2620:10d:c0a1:f82::31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Wed, 19 Dec 2018 06:22:23 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Wed, 19 Dec 2018 06:22:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JetbmWPSjdbO7Path8QDVeWmSy54UMhf4bJVc+LBe8=;
 b=Ka+ZZjQnblFhN6j2TRKPV9AU0bshU+op7DI//DPsOs4th3gEUfYUaxi2OXvyu2HqKeJ4DlnTLGtTvsAk2naCAdQOWraNL4ovjVEqi3iKhFJ9vQHshWgtMtlMoGfgsF16VhcTdBwyhK9k9zlYh//0qVxKcKdvJCkkyoemV1sslKQ=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1212.namprd15.prod.outlook.com (10.173.209.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.17; Wed, 19 Dec 2018 14:22:05 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::c:d0cf:b91e:6c79]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::c:d0cf:b91e:6c79%9]) with mapi id 15.20.1425.021; Wed, 19 Dec 2018
 14:22:05 +0000
From:   Chris Mason <clm@fb.com>
To:     ethanlien <ethanlien@synology.com>
CC:     Martin Raiber <martin@urbackup.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        "linux-btrfs-owner@vger.kernel.org" 
        <linux-btrfs-owner@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Thread-Topic: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Thread-Index: AQHT9keZ7Z3eAayDI0yo6F7kEUsUfaV8Es4AgABdrQCAAqr7gIAFGcgAgALqrYCAAD/vgA==
Date:   Wed, 19 Dec 2018 14:22:04 +0000
Message-ID: <CBB68D09-D591-4A36-9792-219CA7314EF1@fb.com>
References: <20180528054821.9092-1-ethanlien@synology.com>
 <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
 <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
 <d324045eb532b2fa525203c20c57bed1@synology.com>
 <01020167bc7811f0-cb1970f5-3d51-49f9-a5bb-63ba1ea35eea-000000@eu-west-1.amazonses.com>
 <362642e5e618dbf17effc17e0cb7457f@synology.com>
In-Reply-To: <362642e5e618dbf17effc17e0cb7457f@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.3r5579)
x-clientproxiedby: BN7PR06CA0070.namprd06.prod.outlook.com
 (2603:10b6:408:34::47) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:3b85]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1212;20:+lb6Sfflrv1//GgqLPH2meU2QSqU69UCEOoFzGvBqxYcMQGjqpO9eUeP96O4czOhHZV/4sPekOVwuxFpAm0+/BbcPmISutnOiMwCX1QKujJ7eGBuTGE2a/3WDyvVKTyTKBGMGLoGTBgg4puBFM1bY06yaeZCdz6otRRNsCSi304=
x-ms-office365-filtering-correlation-id: 266131ee-fc99-4a95-f31d-08d665bd598b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1212;
x-ms-traffictypediagnostic: DM5PR15MB1212:
x-microsoft-antispam-prvs: <DM5PR15MB1212D109BCF25072269E9583D3BE0@DM5PR15MB1212.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(999002)(11241501185)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1212;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1212;
x-forefront-prvs: 0891BC3F3D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(366004)(136003)(39860400002)(189003)(199004)(476003)(52116002)(106356001)(5660300001)(2616005)(105586002)(478600001)(229853002)(486006)(6246003)(76176011)(102836004)(25786009)(4001150100001)(53936002)(6436002)(386003)(36756003)(2906002)(6506007)(305945005)(97736004)(186003)(53546011)(6512007)(33656002)(446003)(11346002)(46003)(86362001)(93886005)(7736002)(6486002)(68736007)(14444005)(99286004)(256004)(54906003)(71200400001)(71190400001)(83716004)(4326008)(6116002)(6916009)(8676002)(50226002)(81166006)(316002)(81156014)(14454004)(82746002)(8936002)(14143004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1212;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: GBDvILODdAygf2yo7n3Fvf/gCedLn027EzZAtu1vZBXMTE+lytc5uNK3IPLcYleHNUWKSP5q6CYwpfAp5R1phc06ioJJVRHDF7zk90AEY5yhDjCzLb0uOL7ayActahppxpGWgL8Sx6Ldmcl4A7DIJJeSbSN9QDYgW7tzAjndl7I4sq/Wtwb1dkT1/qfoWIvw/Sx/WcMUXZ9lIS71gsMI8S/OWr+ca58Mm0PN9ep7otl/ymiYak+1CH9wUgP9BONU1oV3QqyJvTluku0WPoGUb9Ju+wYWEHOAWeMgG2b9n+O0QYo1X1pykqsQH0qqKbGt
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <9906B0A58D594B45B3D6E0B9D0C8F8B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 266131ee-fc99-4a95-f31d-08d665bd598b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2018 14:22:04.9759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1212
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-19_07:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTkgRGVjIDIwMTgsIGF0IDU6MzMsIGV0aGFubGllbiB3cm90ZToNCg0KPiBNYXJ0aW4gUmFp
YmVyIOaWvCAyMDE4LTEyLTE3IDIyOjAwIOWvq+WIsDoNCj4NCj4+Pj4+DQo+Pj4+IEkgaGFkIGxv
Y2t1cHMgd2l0aCB0aGlzIHBhdGNoIGFzIHdlbGwuIElmIHlvdSBwdXQgZS5nLiBhIGxvb3AgDQo+
Pj4+IGRldmljZSBvbg0KPj4+PiB0b3Agb2YgYSBidHJmcyBmaWxlLCBsb29wIHNldHMgUEZfTEVT
U19USFJPVFRMRSB0byBhdm9pZCBhIGZlZWQgDQo+Pj4+IGJhY2sNCj4+Pj4gbG9vcCBjYXVzaW5n
IGRlbGF5cy4gVGhlIHRhc2sgYmFsYW5jaW5nIGRpcnR5IHBhZ2VzIGluDQo+Pj4+IGJ0cmZzX2Zp
bmlzaF9vcmRlcmVkX2lvIGRvZXNuJ3QgaGF2ZSB0aGUgZmxhZyBhbmQgY2F1c2VzIA0KPj4+PiBz
bG93LWRvd25zLiBJbg0KPj4+PiBteSBjYXNlIGl0IG1hbmFnZWQgdG8gY2F1c2UgYSBmZWVkYmFj
ayBsb29wIHdoZXJlIGl0IHF1ZXVlcyBvdGhlcg0KPj4+PiBidHJmc19maW5pc2hfb3JkZXJlZF9p
byBhbmQgZ2V0cyBzdHVjayBjb21wbGV0ZWx5Lg0KPj4+Pg0KPj4+DQo+Pj4gVGhlIGRhdGEgd3Jp
dGVwYWdlIGVuZGlvIHdpbGwgcXVldWUgYSB3b3JrIGZvcg0KPj4+IGJ0cmZzX2ZpbmlzaF9vcmRl
cmVkX2lvKCkgaW4gYSBzZXBhcmF0ZSB3b3JrcXVldWUgYW5kIGNsZWFyIHBhZ2Uncw0KPj4+IHdy
aXRlYmFjaywgc28gdGhyb3R0bGluZyBpbiBidHJmc19maW5pc2hfb3JkZXJlZF9pbygpIHNob3Vs
ZCBub3QgDQo+Pj4gc2xvdw0KPj4+IGRvd24gZmx1c2hlciB0aHJlYWQuIE9uZSBzdXNwaWNpb3Vz
IHBvaW50IGlzIHdoaWxlIHRoZSBjYWxsZXIgaXMNCj4+PiB3YWl0aW5nIGEgcmFuZ2Ugb2Ygb3Jk
ZXJlZF9leHRlbnRzIHRvIGNvbXBsZXRlLCB0aGV5IHdpbGwgYmUNCj4+PiBibG9ja2VkIHVudGls
IGJhbGFuY2VfZGlydHlfcGFnZXNfcmF0ZWxpbWl0ZWQoKSBtYWtlIHNvbWUNCj4+PiBwcm9ncmVz
cywgc2luY2Ugd2UgZmluaXNoIG9yZGVyZWRfZXh0ZW50cyBpbg0KPj4+IGJ0cmZzX2ZpbmlzaF9v
cmRlcmVkX2lvKCkuDQo+Pj4gRG8geW91IGhhdmUgY2FsbCBzdGFjayBpbmZvcm1hdGlvbiBmb3Ig
c3R1Y2sgcHJvY2Vzc2VzIG9yIHVzaW5nDQo+Pj4gZnN5bmMvc3luYyBmcmVxdWVudGx5PyBJZiB0
aGlzIGlzIHRoZSBjYXNlLCBtYXliZSB3ZSBzaG91bGQgcHVsbA0KPj4+IHRoaXMgdGhpbmcgb3V0
IGFuZCB0cnkgYmFsYW5jZSBkaXJ0eSBtZXRhZGF0YSBwYWdlcyBzb21ld2hlcmUuDQo+Pg0KPj4g
WWVhaCBsaWtlLA0KPj4NCj4+IFs4NzUzMTcuMDcxNDMzXSBDYWxsIFRyYWNlOg0KPj4gWzg3NTMx
Ny4wNzE0MzhdwqAgPyBfX3NjaGVkdWxlKzB4MzA2LzB4N2YwDQo+PiBbODc1MzE3LjA3MTQ0Ml3C
oCBzY2hlZHVsZSsweDMyLzB4ODANCj4+IFs4NzUzMTcuMDcxNDQ3XcKgIGJ0cmZzX3N0YXJ0X29y
ZGVyZWRfZXh0ZW50KzB4ZWQvMHgxMjANCj4+IFs4NzUzMTcuMDcxNDUwXcKgID8gcmVtb3ZlX3dh
aXRfcXVldWUrMHg2MC8weDYwDQo+PiBbODc1MzE3LjA3MTQ1NF3CoCBidHJmc193YWl0X29yZGVy
ZWRfcmFuZ2UrMHhhMC8weDEwMA0KPj4gWzg3NTMxNy4wNzE0NTddwqAgYnRyZnNfc3luY19maWxl
KzB4MWQ2LzB4NDAwDQo+PiBbODc1MzE3LjA3MTQ2MV3CoCA/IGRvX2ZzeW5jKzB4MzgvMHg2MA0K
Pj4gWzg3NTMxNy4wNzE0NjNdwqAgPyBidHJmc19mZGF0YXdyaXRlX3JhbmdlKzB4NTAvMHg1MA0K
Pj4gWzg3NTMxNy4wNzE0NjVdwqAgZG9fZnN5bmMrMHgzOC8weDYwDQo+PiBbODc1MzE3LjA3MTQ2
OF3CoCBfX3g2NF9zeXNfZnN5bmMrMHgxMC8weDIwDQo+PiBbODc1MzE3LjA3MTQ3MF3CoCBkb19z
eXNjYWxsXzY0KzB4NTUvMHgxMDANCj4+IFs4NzUzMTcuMDcxNDczXcKgIGVudHJ5X1NZU0NBTExf
NjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YTkNCj4+DQo+PiBzbyBJIGd1ZXNzIHRoZSBwcm9ibGVt
IGlzIHRoYXQgdGhlIGNhbGxpbmcgYmFsYW5jZV9kaXJ0eV9wYWdlcyBjYXVzZXMNCj4+IGZzeW5j
cyB0byB0aGUgc2FtZSBidHJmcyAodmlhIG15IHVudXN1YWwgc2V0dXAgb2YgbG9vcCtmdXNlKT8g
VGhvc2UNCj4+IGZzeW5jcyBhcmUgZGVhZGxvY2tlZCBiZWNhdXNlIHRoZXkgYXJlIGNhbGxlZCBp
bmRpcmVjdGx5IGZyb20NCj4+IGJ0cmZzX2ZpbmlzaF9vcmRlcmVkX2lvLi4uIEl0IGlzIGEgdW51
c2FsIHNldHVwLCB3aGljaCBpcyB3aHkgSSBkaWQgDQo+PiBub3QNCj4+IHBvc3QgaXQgdG8gdGhl
IG1haWxpbmcgbGlzdCBpbml0aWFsbHkuDQo+DQo+IFRvIG1lIHRoaXMgaXMgbm90IGxpa2UgYSBy
ZWFsIGRlYWRsb2NrLiBUaGUgZnN5bmMgY2FsbCBpbnZva2VzIHR3byANCj4gc3RlcHM6DQo+ICgx
KSBmbHVzaGluZyBkaXJ0eSBkYXRhIHBhZ2VzLCAoMikgdXBkYXRlIGNvcnJlc3BvbmRpbmcgbWV0
YWRhdGEgdG8NCj4gcG9pbnQgdG8gdGhvc2UgZmx1c2hlZCBkYXRhLiBTaW5jZSBzdGVwMSBjb25z
dW1lIGRpcnR5IHBhZ2VzIGFuZA0KPiBzdGVwMiBwcm9kdWNlIG1vcmUgZGlydHkgcGFnZXMsIGlu
IHRoaXMgcGF0Y2ggd2UgbGVhdmUgc3RlcDENCj4gdW5jaGFuZ2VkIGFuZCBibG9jayBzdGVwMiBp
biBidHJmc19maW5pc2hfb3JkZXJlZF9pbygpLCB3aGljaA0KPiBzZWVtcyByZWFzb25hYmxlIHRv
IGEgT09NIGZpeC4gVGhlIHByb2JsZW0gaXMsIGlmIHRoZXJlIGFyZQ0KPiBvdGhlciBwcm9jZXNz
ZXMgY29udGludWFsbHkgd3JpdGluZyBuZXcgZGF0YSwgdGhlIGZzeW5jIGNhbGwgd2lsbA0KPiBu
ZWVkIHRvIHdhaXQgdGhlIG1ldGFkYXRhIHVwZGF0ZSBmb3IgYSBsb25nIHRpbWUsIGV2ZW4gaXRz
IGRpcnR5DQo+IGRhdGEgaGFzIGJlZW4gZmx1c2hlZCBsb25nIHRpbWUgYWdvLg0KPg0KPiBCYWNr
IHRvIHRoZSBkZWFkbG9jayBwcm9ibGVtLCB3aGF0IENocmlzIGZvdW5kIGlzIHJlYWxseSBhIGRl
YWRsb2NrLA0KPiBhbmQgaXQgY2FuIGJlIGZpeGVkIGJ5IGFkZGluZyBhIGNoZWNrIG9mIGZyZWUg
c3BhY2UgaW5vZGUuDQoNCkkgdGhpbmsgd2Ugc2hvdWxkIGhhdmUgYSAgYmV0dGVyIHVuZGVyc3Rh
bmRpbmcgb2YgeW91ciBvcmlnaW5hbCBPT00gDQpwcm9ibGVtIGJlZm9yZSB3ZSBrZWVwIHRoZSBi
YWxhbmNlX2RpcnR5X3BhZ2VzKCkuICBUaGlzIGlzbid0IGEgZ3JlYXQgDQpwbGFjZSB0byB0aHJv
dHRsZSwgYW5kIHdoaWxlIGl0J3MgYWxzbyBub3QgYSBncmVhdCBwbGFjZSB0byBtYWtlIGEgaHVn
ZSANCmJ1cnN0IG9mIGRpcnR5IHBhZ2VzLCBJJ2QgbGlrZSB0byBtYWtlIHN1cmUgd2UncmUgcmVh
bGx5IGZpeGluZyB0aGUgDQpyaWdodCBwcm9ibGVtIGFnYWluc3QgdG9kYXkncyBrZXJuZWwuDQoN
Ci1jaHJpcw0K
