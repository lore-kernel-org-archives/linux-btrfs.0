Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E4DC64EB4
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 15:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C861020868
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 15:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="FuLRaqO2";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="D2D9F8Fk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C861020868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbeLACcO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 21:32:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49000 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbeLACcN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 21:32:13 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAUFFD3j024828;
        Fri, 30 Nov 2018 07:22:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FyGWB4YigjCx7UhGKNd3C+rM7hdYFO3MUTjRAvP9WGs=;
 b=FuLRaqO2ehgmzotS8pAnWwM9Ti0W8t07y7Xvptjh34muCAqR/ljhJKYomzxnYminaIkI
 sEeikGgIz7WBxh6qfyK/Cnukuu4zEn2nHHRZJf+xcfLPi0MwnhVL5L76rVp36GQfpci1
 pNEPYRtQZz5Ap3aX0h9sJuAzXdTPocsMirc= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2p35328gcd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Nov 2018 07:22:30 -0800
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Fri, 30 Nov 2018 07:22:18 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1531.3; Fri, 30 Nov 2018 07:22:18 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1531.3
 via Frontend Transport; Fri, 30 Nov 2018 07:22:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FyGWB4YigjCx7UhGKNd3C+rM7hdYFO3MUTjRAvP9WGs=;
 b=D2D9F8Fk0jXCRGO9WphWh4qbMUfk99bImgqsNEvqOyKbjlytsDrmfRN3OTjz/nV7+Dyh4suuplKvvqzBl+SjgHcIM9VJLf53GRuThYZndqgVgzhgeffJqk+gNJwgxl4h7DsLPs7HC4ymvMFVFiWNjaWo3yp9phEm2/GcvGbh2No=
Received: from DM5PR15MB1883.namprd15.prod.outlook.com (10.174.247.135) by
 DM5PR15MB1579.namprd15.prod.outlook.com (10.173.222.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.18; Fri, 30 Nov 2018 15:22:16 +0000
Received: from DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205]) by DM5PR15MB1883.namprd15.prod.outlook.com
 ([fe80::f8d4:7c44:756a:6205%10]) with mapi id 15.20.1361.022; Fri, 30 Nov
 2018 15:22:16 +0000
From:   Chris Mason <clm@fb.com>
To:     Nikolay Borisov <nborisov@suse.com>
CC:     Jean Fobe <jeanfobe@ime.usp.br>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs development - question about crypto api integration
Thread-Topic: btrfs development - question about crypto api integration
Thread-Index: AQHUiAQG0ulyA8kPU0Kfa4amW9BnWqVnBFSAgAFskgA=
Date:   Fri, 30 Nov 2018 15:22:16 +0000
Message-ID: <017BD22D-F708-4DBA-B977-78AFCCF58D0F@fb.com>
References: <CAMHc_wN+-qHc1+q6fuRCzzJ9fsE2-vwa5N3031ANpZ8+tXb7WQ@mail.gmail.com>
 <8db22a5b-14de-3e8a-241f-d7e963ea5a57@suse.com>
In-Reply-To: <8db22a5b-14de-3e8a-241f-d7e963ea5a57@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.2r5568)
x-clientproxiedby: BN6PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:404:f5::15) To DM5PR15MB1883.namprd15.prod.outlook.com
 (2603:10b6:4:4f::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:180::1:39f7]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR15MB1579;20:To+C/FINnq3M6ihG8Z+c51wuy156sKlG830TBGlzwE4e0TREQjWXN1JAdhfbwJbcQvR7O44rjEz1e4h8IJ3nnYMyy0WvvQJtbucO4mQF+NRrLqxfUlokB6JquQjtXm2Wgaq8/IL79gPeygPAtE02Ndgfn36J49k6TSt/8xRSPx4=
x-ms-office365-filtering-correlation-id: c3fef4cc-32e4-46cc-0131-08d656d79c56
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR15MB1579;
x-ms-traffictypediagnostic: DM5PR15MB1579:
x-microsoft-antispam-prvs: <DM5PR15MB157979168DB07FADB2BB6252D3D30@DM5PR15MB1579.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(10201501046)(3231453)(999002)(11241501185)(944501466)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:DM5PR15MB1579;BCL:0;PCL:0;RULEID:;SRVR:DM5PR15MB1579;
x-forefront-prvs: 087223B4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(376002)(346002)(136003)(189003)(199004)(53754006)(6506007)(6436002)(68736007)(229853002)(6116002)(6486002)(97736004)(102836004)(4326008)(76176011)(106356001)(46003)(53546011)(52116002)(11346002)(446003)(5660300001)(2616005)(486006)(99286004)(81166006)(386003)(25786009)(105586002)(50226002)(53936002)(305945005)(7736002)(81156014)(316002)(6246003)(478600001)(8676002)(14454004)(6512007)(33656002)(82746002)(6916009)(476003)(2906002)(8936002)(54906003)(36756003)(186003)(71190400001)(71200400001)(86362001)(83716004)(256004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1579;H:DM5PR15MB1883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: cKLKi4tDejpv/11lMaO24Z46miD4iKtxo86mfZGzEcxj9H3IZ7UkdD2OCdaqxOy5Iy+IyGWgBNNpw2VZZMfC+gsQdiL1bxAtgv1eI62WhXtYUAfajBWR+w26AmNixeBaOMrVl/y9CELpQw4d9ZyJtWJds4yEZi9kFX9JhFvEvke6SUwSoH1CrnnjuZ4Qv0zJpG6nGBSkKqzSovP9NCYjpt3v3l1Cu8B2/tgyKPiFmZX7NkjPfyxXdvRltv/4ETStAb1g8bqiNnRTecgUazOHDyFdPSBc6yJrukTKGaqNZjgFvXYqMlx3QzFfHQ/0b1Dyv+HV7ZROMxZXATKn9SPxRRWxOqwHubjn7XXR0wyLkOY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3BF1C76AD1DB444AAAC55896FC3AC50@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c3fef4cc-32e4-46cc-0131-08d656d79c56
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2018 15:22:16.3624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1579
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-30_06:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMjkgTm92IDIwMTgsIGF0IDEyOjM3LCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6DQoNCj4gT24g
MjkuMTEuMTgg0LMuIDE4OjQzINGHLiwgSmVhbiBGb2JlIHdyb3RlOg0KPj4gSGkgYWxsLA0KPj4g
ICAgIEkndmUgYmVlbiBzdHVkeWluZyBMWjQgYW5kIG90aGVyIGNvbXByZXNzaW9uIGFsZ29yaXRo
bXMgb24gdGhlDQo+PiBrZXJuZWwsIGFuZCBzZWVuIG90aGVyIHByb2plY3RzIHN1Y2ggYXMgenJh
bSBhbmQgdWJpZnMgdXNpbmcgdGhlDQo+PiBjcnlwdG8gYXBpLiBJcyB0aGVyZSBhIHRlY2huaWNh
bCByZWFzb24gZm9yIG5vdCB1c2luZyB0aGUgY3J5cHRvIGFwaQ0KPj4gZm9yIGNvbXByZXNzaW9u
IChhbmQgcG9zc2libHkgZm9yIGVuY3J5cHRpb24pIGluIGJ0cmZzPw0KPj4gICAgIEkgZGlkIG5v
dCBmaW5kIGFueSBkZXNpZ24vdGVjaG5pY2FsIGltcGxlbWVudGF0aW9uIGNob2ljZXMgaW4NCj4+
IGJ0cmZzIGRldmVsb3BtZW50IGluIHRoZSBkZXZlbG9wZXIncyBGQVEgb24gdGhlIHdpa2kuIElm
IEkgY29tcGxldGVseQ0KPj4gbWlzc2VkIGl0LCBjb3VsZCBzb21lb25lIHBvaW50IG1lIGluIHRo
ZSByaWdodCBkaXJlY3Rpb24/DQo+PiAgICAgTGFzdGx5LCBpZiB0aGVyZSBpcyBubyB0ZWNobmlj
YWwgcmVhc29uIGZvciB0aGlzLCB3b3VsZCBpdCBiZQ0KPj4gc29tZXRoaW5nIGludGVyZXN0aW5n
IHRvIGhhdmUgaW1wbGVtZW50ZWQ/DQo+DQo+IEkgcGVyc29uYWxseSB0aGluayBpdCB3b3VsZCBi
ZSBiZXR0ZXIgaWYgYnRyZnMnIGV4cGxvaXRlZCB0aGUgZ2VuZXJpYw0KPiBmcmFtZXdvcmsuIEFu
ZCBpbiBmYWN0IHdoZW4geW91IGxvb2sgYXQgenN0ZCwgYnRyZnMgZG9lcyB1c2UgdGhlDQo+IGdl
bmVyaWMsIGxvdy1sZXZlbCBaU1REIHJvdXRpbmVzIGJ1dCBub3QgdGhlIGNyeXB0byBsaWJyYXJ5
IHdyYXBwZXJzLiANCj4gSWYNCj4gSSB3ZXJlIEknZCB0cnkgYW5kIGNvbnZlcnQgenN0ZCAoc2lu
Y2UgaXQncyB0aGUgbW9zdCByZWNlbnRseSBhZGRlZA0KPiBhbGdvcml0aG0pIHRvIHVzaW5nIHRo
ZSBjcnlwdG8gbGF5ZXIgdG8gc2VlIGlmIHRoZXJlIGFyZSBhbnkgbHVya2luZw0KPiBwcm9ibGVt
cy4NCg0KQmFjayB3aGVuIEkgZmlyc3QgYWRkZWQgdGhlIHpsaWIgc3VwcG9ydCwgdGhlIHpsaWIg
QVBJIHdhcyBib3RoIGVhc2llciANCnRvIHVzZSBhbmQgYSBiZXR0ZXIgZml0IGZvciBvdXIgYXN5
bmMgd29ya2VyIHRocmVhZHMuICBUaGF0IGRvZXNuJ3QgbWVhbiANCndlIHNob3VsZG4ndCBzd2l0
Y2gsIGl0J3MganVzdCBob3cgd2UgZ290IHRvIHN0ZXAgb25lIDspDQoNCi1jaHJpcw0K
