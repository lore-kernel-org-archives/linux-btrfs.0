Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760DBC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 20:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19DC920663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 20:00:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="EjYZoIEi";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="Z53Xm7B0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19DC920663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbeK1G7c (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:59:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38618 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725752AbeK1G7c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:59:32 -0500
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wARJvleE010467;
        Tue, 27 Nov 2018 12:00:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QHMlRXEDag3EVePweaGwxCrNunAX/InXVyXmcg8Es0w=;
 b=EjYZoIEif9TkC6ddemwk+3F0KKjT+WfbZeYTdEb96ImqwnXDExMZ1wxivIEgnTLMZ4/E
 b9UCF6UBS4zNb+zXgg+qfATNkiOEHNeg/C6RsE91VFSRK4w8afrnMKr0RXqYS/4H3zjv
 u9eccpeFRC4GHHqI8tkAplxtV5D+39SqmFE= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2p1ar68fk5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Nov 2018 12:00:21 -0800
Received: from frc-mbx02.TheFacebook.com (2620:10d:c0a1:f82::26) by
 frc-hub05.TheFacebook.com (2620:10d:c021:18::175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Tue, 27 Nov 2018 11:59:44 -0800
Received: from frc-hub04.TheFacebook.com (2620:10d:c021:18::174) by
 frc-mbx02.TheFacebook.com (2620:10d:c0a1:f82::26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Tue, 27 Nov 2018 11:59:44 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.183.28)
 by o365-in.thefacebook.com (192.168.177.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Tue, 27 Nov 2018 11:59:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHMlRXEDag3EVePweaGwxCrNunAX/InXVyXmcg8Es0w=;
 b=Z53Xm7B01q1Cs4VH7pxqLruMp3Awesh87A5CvceEpd+DKkf8us7hkIuWHOJPEbl8uLuKSEOTyiKg8VB+IeqzLVbMSb6MYvy8LV4fCO/lROKeLLDEiH1uBGR0UuXOaXRmY5D4zi62IJapfSBM6joZ1G//OUZK5/7/6K8q1J3QSHc=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1769.namprd15.prod.outlook.com (10.174.246.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.16; Tue, 27 Nov 2018 19:59:42 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205%10]) with mapi id 15.20.1361.019; Tue, 27 Nov
 2018 19:59:42 +0000
From:   Chris Mason <clm@fb.com>
To:     Josef Bacik <josef@toxicpanda.com>
CC:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Thread-Topic: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed
 iput
Thread-Index: AQHUgc3JQh2lcZKqK0e6arI+VYlyZ6VjUh2AgADAZYCAAAFWAA==
Date:   Tue, 27 Nov 2018 19:59:42 +0000
Message-ID: <13D3592A-3719-4F9E-8E8A-944FE88F30D4@fb.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
 <20181121190922.25038-3-josef@toxicpanda.com>
 <4e8aad56-42e2-d666-c909-d5d058b799c9@suse.com>
 <20181127195450.fjor2gewhp3hri56@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20181127195450.fjor2gewhp3hri56@macbook-pro-91.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.2r5568)
x-clientproxiedby: BN6PR0101CA0022.prod.exchangelabs.com
 (2603:10b6:405:2a::35) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:734e]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1769;20:9vZKYM60OlmM1edmqO7frgGPRbBkNaomG2jbdGusM1X26zyylRX0keFCcnyN1HOzpjtgWemQM2ZU6C8OoglTdAQa3m6euTQV7sQRglfReFRCY56aHGySaoo3DEx4q62a3rBHFBeirTL1efxEoG+heJE2e+efe/pzXHY91Ztry9I=
x-ms-office365-filtering-correlation-id: 775b9b93-b199-4097-6434-08d654a2defe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1769;
x-ms-traffictypediagnostic: DM5PR15MB1769:
x-microsoft-antispam-prvs: <DM5PR15MB176912FC55BA94085AE5E3FAD3D00@DM5PR15MB1769.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(823302103)(3002001)(10201501046)(3231443)(11241501185)(944501410)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123564045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1769;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1769;
x-forefront-prvs: 086943A159
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(346002)(376002)(39860400002)(199004)(189003)(81166006)(99286004)(486006)(52116002)(2616005)(446003)(11346002)(36756003)(6512007)(97736004)(106356001)(46003)(256004)(53936002)(6246003)(8676002)(81156014)(71190400001)(83716004)(105586002)(50226002)(71200400001)(478600001)(476003)(6116002)(14454004)(8936002)(54906003)(5660300001)(53546011)(86362001)(4326008)(229853002)(25786009)(2906002)(6436002)(305945005)(102836004)(316002)(6506007)(386003)(6916009)(7736002)(33656002)(68736007)(76176011)(93886005)(6486002)(551934003)(186003)(82746002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1769;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: B9/Ll0QrJxJzL5VIvPBLy2IqWivv357yONORW3nZ4xJDfUxL7Wd/0iv4j/4pqdR7D0S47F5BxFfjZIEwn2OHm+MWvPOWJDCf1Nt4+1psWJcwc8UMz84XFU8fGthwqoos58s86K0i1lPb9pAxv1zzap9JVvoCUYSDaqwsa2rLUQbxNED4nPwobQkRHwQICBW+9HWF6TDkOU9UmaWFTZ82w8ick8xj+IJOPW9JEfdfjyFsblXczX+ylqwGvKVwEgpuwiCe63XUEK2f1rx1AhD9lLTHd8os0BHxdh6ZbltnhWQz6pNo2u3TDkmyULPAwwz9nUsjF74W2z6UYG2sDM9kyCO4Qi+eot1go88ITT+ks9I=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D708D4C2507F24A993D5D7F1D8D99D1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 775b9b93-b199-4097-6434-08d654a2defe
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2018 19:59:42.7309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1769
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-27_16:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMjcgTm92IDIwMTgsIGF0IDE0OjU0LCBKb3NlZiBCYWNpayB3cm90ZToNCg0KPiBPbiBUdWUs
IE5vdiAyNywgMjAxOCBhdCAxMDoyNjoxNUFNICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+Pg0KPj4NCj4+IE9uIDIxLjExLjE4INCzLiAyMTowOSDRhy4sIEpvc2VmIEJhY2lrIHdyb3Rl
Og0KPj4+IFRoZSBjbGVhbmVyIHRocmVhZCB1c3VhbGx5IHRha2VzIGNhcmUgb2YgZGVsYXllZCBp
cHV0cywgd2l0aCB0aGUNCj4+PiBleGNlcHRpb24gb2YgdGhlIGJ0cmZzX2VuZF90cmFuc2FjdGlv
bl90aHJvdHRsZSBwYXRoLiAgVGhlIGNsZWFuZXINCj4+PiB0aHJlYWQgb25seSBnZXRzIHdva2Vu
IHVwIGV2ZXJ5IDMwIHNlY29uZHMsIHNvIGluc3RlYWQgd2FrZSBpdCB1cCB0byANCj4+PiBkbw0K
Pj4+IGl0J3Mgd29yayBzbyB0aGF0IHdlIGNhbiBmcmVlIHVwIHRoYXQgc3BhY2UgYXMgcXVpY2ts
eSBhcyBwb3NzaWJsZS4NCj4+DQo+PiBIYXZlIHlvdSBkb25lIGFueSBtZWFzdXJlbWVudHMgaG93
IHRoaXMgYWZmZWN0cyB0aGUgb3ZlcmFsbCBzeXN0ZW0uIEkNCj4+IHN1c3BlY3QgdGhpcyBpbnRy
b2R1Y2VzIGEgbG90IG9mIG5vaXNlIHNpbmNlIG5vdyB3ZSBhcmUgZ29pbmcgdG8gYmUNCj4+IGRv
aW5nIGEgdGhyZWFkIHdha2V1cCBvbiBldmVyeSBpcHV0LCBkb2VzIHRoaXMgZ2l2ZSBhIGNoYW5j
ZSB0byBoYXZlDQo+PiBuaWNlLCBsYXJnZSBiYXRjaGVzIG9mIGlwdXRzIHRoYXQgIHRoZSBjb3N0
IG9mIHdha2UgdXAgY2FuIGJlIA0KPj4gYW1vcnRpemVkDQo+PiBhY3Jvc3M/DQo+DQo+IEkgcmFu
IHRoZSB3aG9sZSBwYXRjaHNldCB3aXRoIG91ciBBL0IgdGVzdGluZyBzdHVmZiBhbmQgdGhlIHBh
dGNoc2V0IA0KPiB3YXMgYSA1JQ0KPiB3aW4gb3ZlcmFsbCwgc28gSSdtIGluY2xpbmVkIHRvIHRo
aW5rIGl0J3MgZmluZS4gIFRoYW5rcywNCg0KSXQncyBhIGdvb2QgcG9pbnQgdGhvdWdoLCBhIGRl
bGF5ZWQgd2FrZXVwIG1heSBiZSBsZXNzIG92ZXJoZWFkLg0KDQotY2hyaXMNCg==
