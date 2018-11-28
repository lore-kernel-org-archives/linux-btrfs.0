Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3CEC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 19:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E75CE2086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 19:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="VO4O5+BW";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="C5EnDAUQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E75CE2086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbeK2GfU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 01:35:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54578 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbeK2GfU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 01:35:20 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wASJU8IP028214;
        Wed, 28 Nov 2018 11:32:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/NmLZz87w+htyTkz6pb/dIR11bpgLjKyxIjtBqqqFcs=;
 b=VO4O5+BWn0P73nHSEfdObGfxqeWDPPB3Yxw9E8mhC/NtsKO2RMcP137qIPjJutkWAZql
 fFCeFycQlj4ry1ybRHWyP8g/lufZvRrEoqMsKvcY6xLhGinXHDrCQMsj5gTV8SrmnQN6
 3k4cyRbyHgqBO+uXoUo5T2LGZ9zNk3SYZkM= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2p1xfwrm4f-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 28 Nov 2018 11:32:28 -0800
Received: from frc-mbx05.TheFacebook.com (2620:10d:c0a1:f82::29) by
 frc-hub02.TheFacebook.com (2620:10d:c021:18::172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Wed, 28 Nov 2018 11:32:26 -0800
Received: from frc-hub03.TheFacebook.com (2620:10d:c021:18::173) by
 frc-mbx05.TheFacebook.com (2620:10d:c0a1:f82::29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Wed, 28 Nov 2018 11:32:25 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Wed, 28 Nov 2018 11:32:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NmLZz87w+htyTkz6pb/dIR11bpgLjKyxIjtBqqqFcs=;
 b=C5EnDAUQZu9P2XZJ7HPhlI9KNzi5xRyJI+c5KjkjVGNVx/zEhvnudg7/B53KDU0eOwIsWx4+oKgz8JZbSLkkrfqdbHUwxnEzQCZ9TkK+oBEW84UIRfgVmbiz6HkyOFdIhZqdSsdwYc8vXJ8N6w79Wb85UFHjs9vM0+tQbofeh8w=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1897.namprd15.prod.outlook.com (10.174.247.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 28 Nov 2018 19:32:24 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205%10]) with mapi id 15.20.1361.019; Wed, 28 Nov
 2018 19:32:24 +0000
From:   Chris Mason <clm@fb.com>
To:     David Sterba <dsterba@suse.cz>
CC:     Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Thread-Topic: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed
 iput
Thread-Index: AQHUgc3JQh2lcZKqK0e6arI+VYlyZ6VjUh2AgADAZYD//62EAIAAVjIAgAGBIQCAAAczAA==
Date:   Wed, 28 Nov 2018 19:32:23 +0000
Message-ID: <01FF398F-7C30-4BAD-8562-D4A39589D2F1@fb.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
 <20181121190922.25038-3-josef@toxicpanda.com>
 <4e8aad56-42e2-d666-c909-d5d058b799c9@suse.com>
 <20181127195450.fjor2gewhp3hri56@macbook-pro-91.dhcp.thefacebook.com>
 <13D3592A-3719-4F9E-8E8A-944FE88F30D4@fb.com>
 <20181127200807.bdnvwap2kuuwuarg@macbook-pro-91.dhcp.thefacebook.com>
 <20181128190633.GZ2842@twin.jikos.cz>
In-Reply-To: <20181128190633.GZ2842@twin.jikos.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.2r5568)
x-clientproxiedby: BN6PR1301CA0034.namprd13.prod.outlook.com
 (2603:10b6:405:29::47) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:b8a7]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1897;20:pKwqFDazROz2Jk3ijI6tGAKw0aAK/eoMBBfZJ0ELtYORgbTMq2tEID6GAQu9zb4jsRO8AVENZhojA0rXQCuTQBnmNU56hIwleiXT8y8HXTOfHT8DOuyK/nGOZ0O/GwSRWgbx+P+IJt/5/i/YCLT14cZxi7MxTM2abKADtG0hd0c=
x-ms-office365-filtering-correlation-id: e8ed8f78-b7c6-409d-6d17-08d6556838bc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1897;
x-ms-traffictypediagnostic: DM5PR15MB1897:
x-microsoft-antispam-prvs: <DM5PR15MB1897BC04FCE59A31FB5D5A68D3D10@DM5PR15MB1897.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231443)(999002)(11241501185)(944501410)(52105112)(3002001)(93006095)(93001095)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1897;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1897;
x-forefront-prvs: 0870212862
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(376002)(366004)(39860400002)(189003)(199004)(2906002)(83716004)(186003)(6506007)(71190400001)(256004)(386003)(53546011)(71200400001)(33656002)(305945005)(6512007)(53936002)(68736007)(4326008)(6246003)(14454004)(82746002)(106356001)(2616005)(52116002)(97736004)(476003)(105586002)(551934003)(6116002)(486006)(446003)(5660300001)(36756003)(102836004)(76176011)(99286004)(46003)(11346002)(6916009)(6486002)(6436002)(54906003)(93886005)(316002)(86362001)(8936002)(7736002)(229853002)(478600001)(81156014)(81166006)(25786009)(50226002)(8676002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1897;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: RlLy720xHTdxd5QEkTVjQXX53Z0NDZlyI7oB9onC81dtJ08BdZ2L7DDHsz92Kd5M4aaP/LvWZim9a7lZQvtY7aZcTcALubAAY/tu4aP1I5tHHz5ipyAYB7vnot4PBvsslRzsCjBSN6RJs4QR1KF2YNsjikc89HfWJwunJqTtD/VvN+AAI04E4fwCgin1/gQRgCdB9zkokqmzSOa5SnQEyKFSURrXPvwWto1Rrg+O3fdFvwagwwcgSoNt/rptAVcoAIndu/PsTPdmSbdU5sRg3jaKBS2FUgpariYRkN708TBCnGdggBicE6cLMwqUacn82Yd16ogRvUdnabr8r9cjvyRiXOZYW9jTkJARMQo8GsM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <36EBCCC3F4E0CA4798BBCBE9FD6D4AEB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ed8f78-b7c6-409d-6d17-08d6556838bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2018 19:32:23.9461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1897
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-28_10:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMjggTm92IDIwMTgsIGF0IDE0OjA2LCBEYXZpZCBTdGVyYmEgd3JvdGU6DQoNCj4gT24gVHVl
LCBOb3YgMjcsIDIwMTggYXQgMDM6MDg6MDhQTSAtMDUwMCwgSm9zZWYgQmFjaWsgd3JvdGU6DQo+
PiBPbiBUdWUsIE5vdiAyNywgMjAxOCBhdCAwNzo1OTo0MlBNICswMDAwLCBDaHJpcyBNYXNvbiB3
cm90ZToNCj4+PiBPbiAyNyBOb3YgMjAxOCwgYXQgMTQ6NTQsIEpvc2VmIEJhY2lrIHdyb3RlOg0K
Pj4+DQo+Pj4+IE9uIFR1ZSwgTm92IDI3LCAyMDE4IGF0IDEwOjI2OjE1QU0gKzAyMDAsIE5pa29s
YXkgQm9yaXNvdiB3cm90ZToNCj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4gT24gMjEuMTEuMTgg0LMuIDIx
OjA5INGHLiwgSm9zZWYgQmFjaWsgd3JvdGU6DQo+Pj4+Pj4gVGhlIGNsZWFuZXIgdGhyZWFkIHVz
dWFsbHkgdGFrZXMgY2FyZSBvZiBkZWxheWVkIGlwdXRzLCB3aXRoIHRoZQ0KPj4+Pj4+IGV4Y2Vw
dGlvbiBvZiB0aGUgYnRyZnNfZW5kX3RyYW5zYWN0aW9uX3Rocm90dGxlIHBhdGguICBUaGUgDQo+
Pj4+Pj4gY2xlYW5lcg0KPj4+Pj4+IHRocmVhZCBvbmx5IGdldHMgd29rZW4gdXAgZXZlcnkgMzAg
c2Vjb25kcywgc28gaW5zdGVhZCB3YWtlIGl0IHVwIA0KPj4+Pj4+IHRvDQo+Pj4+Pj4gZG8NCj4+
Pj4+PiBpdCdzIHdvcmsgc28gdGhhdCB3ZSBjYW4gZnJlZSB1cCB0aGF0IHNwYWNlIGFzIHF1aWNr
bHkgYXMgDQo+Pj4+Pj4gcG9zc2libGUuDQo+Pj4+Pg0KPj4+Pj4gSGF2ZSB5b3UgZG9uZSBhbnkg
bWVhc3VyZW1lbnRzIGhvdyB0aGlzIGFmZmVjdHMgdGhlIG92ZXJhbGwgDQo+Pj4+PiBzeXN0ZW0u
IEkNCj4+Pj4+IHN1c3BlY3QgdGhpcyBpbnRyb2R1Y2VzIGEgbG90IG9mIG5vaXNlIHNpbmNlIG5v
dyB3ZSBhcmUgZ29pbmcgdG8gDQo+Pj4+PiBiZQ0KPj4+Pj4gZG9pbmcgYSB0aHJlYWQgd2FrZXVw
IG9uIGV2ZXJ5IGlwdXQsIGRvZXMgdGhpcyBnaXZlIGEgY2hhbmNlIHRvIA0KPj4+Pj4gaGF2ZQ0K
Pj4+Pj4gbmljZSwgbGFyZ2UgYmF0Y2hlcyBvZiBpcHV0cyB0aGF0ICB0aGUgY29zdCBvZiB3YWtl
IHVwIGNhbiBiZQ0KPj4+Pj4gYW1vcnRpemVkDQo+Pj4+PiBhY3Jvc3M/DQo+Pj4+DQo+Pj4+IEkg
cmFuIHRoZSB3aG9sZSBwYXRjaHNldCB3aXRoIG91ciBBL0IgdGVzdGluZyBzdHVmZiBhbmQgdGhl
IA0KPj4+PiBwYXRjaHNldA0KPj4+PiB3YXMgYSA1JQ0KPj4+PiB3aW4gb3ZlcmFsbCwgc28gSSdt
IGluY2xpbmVkIHRvIHRoaW5rIGl0J3MgZmluZS4gIFRoYW5rcywNCj4+Pg0KPj4+IEl0J3MgYSBn
b29kIHBvaW50IHRob3VnaCwgYSBkZWxheWVkIHdha2V1cCBtYXkgYmUgbGVzcyBvdmVyaGVhZC4N
Cj4+DQo+PiBTdXJlLCBidXQgaG93IGRvIHdlIGdvIGFib3V0IHRoYXQgd2l0aG91dCBpdCBzb21l
dGltZXMgbWVzc2luZyB1cD8gIA0KPj4gSW4gcHJhY3RpY2UNCj4+IHRoZSBvbmx5IHRpbWUgd2Un
cmUgZG9pbmcgdGhpcyBpcyBhdCB0aGUgZW5kIG9mIGZpbmlzaF9vcmRlcmVkX2lvLCBzbyANCj4+
IGxpa2VseSB0bw0KPj4gbm90IGJlIGEgY29uc3RhbnQgc3RyZWFtLiAgSSBzdXBwb3NlIHNpbmNl
IHdlIGhhdmUgcGxhY2VzIHdoZXJlIHdlIA0KPj4gZm9yY2UgaXQgdG8NCj4+IHJ1biB0aGF0IHdl
IGRvbid0IHJlYWxseSBuZWVkIHRoaXMuICBJREssIEknbSBmaW5lIHdpdGggZHJvcHBpbmcgaXQu
ICANCj4+IFRoYW5rcywNCj4NCj4gVGhlIHRyYW5zYWN0aW9uIHRocmVhZCB3YWtlcyB1cCBjbGVh
bmVyIHBlcmlvZGljYWxseSAoY29tbWl0IGludGVydmFsLA0KPiAzMHMgYnkgZGVmYXVsdCksIHNv
IHRoZSB0aW1lIHRvIHByb2Nlc3MgaXB1dHMgaXMgbm90IHVuYm91bmRlZC4NCj4NCj4gSSBoYXZl
IHRoZSBzYW1lIGNvbmNlcm5zIGFzIE5pa29sYXksIGNvdXBsaW5nIHRoZSB3YWtldXAgdG8gYWxs
IA0KPiBkZWxheWVkDQo+IGlwdXRzIGNvdWxkIHJlc3VsdCBpbiBzbWFsbGVyIGJhdGNoZXMuIEJ1
dCBzb21lIG9mIHRoZSBjYWxsZXJzIG9mDQo+IGJ0cmZzX2FkZF9kZWxheWVkX2lwdXQgbWlnaHQg
YmVuZWZpdCBmcm9tIHRoZSBleHRyYSB3YWtldXAsIGxpa2UNCj4gYnRyZnNfcmVtb3ZlX2Jsb2Nr
X2dyb3VwLCBzbyBJIGRvbid0IHdhbnQgdG8gbGVhdmUgdGhlIGlkZWEgeWV0Lg0KDQpZZWFoLCBJ
IGxvdmUgdGhlIGlkZWEsIEknbSBqdXN0IHdvcnJpZWQgYWJvdXQgYSB0aW55IGJpdCBvZiByYXRl
IA0KbGltaXRpbmcuICBTaW5jZSB3ZSdyZSBvbmx5IHdha2luZyB1cCBhIGZpeGVkIHByb2Nlc3Mg
YW5kIG5vdCBjcmVhdGluZyANCm5ldyB3b3JrIHF1ZXVlIGl0ZW1zIGV2ZXJ5IHRpbWUsIGl0J3Mg
cHJvYmFibHkgZmluZSwgYnV0IGEgZGVsYXkgb2YgSFovMiANCndvdWxkIHByb2JhYmx5IGJlIGV2
ZW4gYmV0dGVyLg0KDQotY2hyaXMNCg==
