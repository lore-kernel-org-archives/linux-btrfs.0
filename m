Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC9DC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 15:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35C652184C
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 15:25:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="Ye7g0JQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfAWPZb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 10:25:31 -0500
Received: from mail-eopbgr40054.outbound.protection.outlook.com ([40.107.4.54]:38392
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbfAWPZa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 10:25:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LirtcDc7CG1X2cz90BZ4GwPrh4AU3VAQJByb2qQgGlU=;
 b=Ye7g0JQPXWBFvLrvffSid+rvGzthdfX0XBmUJQcZ2I+rvbHbpIKaXvQEpdbaRU/Qd9tkNUhHrnv/+Uq5GaTE7iP0D0xYtFzyQvBRPlU7ZhRk1UM6iLT0Imi/CNO94qzEYjCKYD63d3DHFSNGSc0u3Mx7jL4g47klwod5xzDTDZQ=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB3258.eurprd06.prod.outlook.com (10.170.254.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.31; Wed, 23 Jan 2019 15:25:22 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a%2]) with mapi id 15.20.1537.031; Wed, 23 Jan 2019
 15:25:22 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Dennis Katsonis <dennisk@netspace.net.au>
CC:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Incremental receive completes succesfully despite missing files
Thread-Topic: Incremental receive completes succesfully despite missing files
Thread-Index: AQHUsKvEidmBdsnBU0uW4O415p7q16W6TmeAgAJhdwCAAAtbgIAAQyMA
Date:   Wed, 23 Jan 2019 15:25:22 +0000
Message-ID: <8e5c7ee5-4507-66d2-6642-2e37ff11b897@mendix.com>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
 <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
In-Reply-To: <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM5PR0601CA0038.eurprd06.prod.outlook.com
 (2603:10a6:203:68::24) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB3258;6:zP/zO1mcZg5dDLfq2YdpVu9kdjlJwX5niCqG6uhjfMqfMjXE5TN5g8221WjUkbtNF8YZ5GV6K15ZaU5pjb7AB8+BwU2yTA9g5y98Ix1Pmr9IYiWf1tTFYjNiwObU/K/MpOymtJq1P7wMETPJphezbjRQPIjnTuYmNbHkx51oRfganbf4VFQxClNB/EcFTfQZsk0YglGYxbPiku0ZT95pCfcTMlvXWE8AATYPHf5HHzzQ2G5dsl0dSXlS3MU4kEvmlhO4b/02ei4PH+amDYZufpItuidphmBZ1tMncUJ1ARMqp+iQxqn/wgwLHqgVjkFF+FCjD8qvlG6esIJvZDo+IGfiF5U3qPN+rikSdHmkzSDC4a5LCR833ebQbnmrD0k4Wj7LDLVjlE2xBLRVnPP6sN6e/+uxp5sG5K7qeBvcrQh5VRrzqovHAzsm8O9InWIVDySiRFcHofFeh1v6KiUOJg==;5:JgH/b3qnoZIZAvmlNqcBFvrdCmeXJuk522a/OxAXJfZBce5rWk1fYg9/llIuip8t3ClpM/BtsSv0K65dF3vVcweUv+G82fZKFQHaNIQCQICuuwgCYU68nMkL21Pjo5lxsWPpHkJpCPQ7yL02ONBeWZNQEx8PuM1DBlV+UvUOBUrYPbnTqS+eRiWjH437hLIbQLKuKhmEOe55vruqBJVisw==;7:uuBgw7ph5CKOSWrrH/cDF704+UasaSYKlLj3bbcK14fu+6CnU770scBzVu8toII7xMtAY+K29qDtTdY4gIU293zt3HmHb76ehZcPjPZidFd4Dp8r8IFAmi16b3Zi42u0F9kCYr/2LaKfza6NZzEdxA==
x-ms-office365-filtering-correlation-id: 2cef4def-f19c-4c0a-a6ba-08d68146fd89
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:HE1PR0602MB3258;
x-ms-traffictypediagnostic: HE1PR0602MB3258:
x-microsoft-antispam-prvs: <HE1PR0602MB3258AD70472A445A82C78EECD4990@HE1PR0602MB3258.eurprd06.prod.outlook.com>
x-forefront-prvs: 0926B0E013
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(366004)(346002)(396003)(376002)(199004)(189003)(305945005)(76176011)(2906002)(102836004)(6346003)(93886005)(486006)(81156014)(81166006)(11346002)(52116002)(446003)(65806001)(2616005)(65956001)(316002)(386003)(53546011)(99286004)(7736002)(6506007)(105586002)(31686004)(106356001)(6436002)(8936002)(229853002)(6486002)(46003)(186003)(8676002)(64126003)(97736004)(31696002)(53936002)(65826007)(68736007)(4326008)(39060400002)(478600001)(14444005)(256004)(6512007)(6246003)(14454004)(36756003)(72206003)(6116002)(110136005)(25786009)(58126008)(476003)(86362001)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB3258;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AvW2jNP2HEfVrRtg1w4tN5Q3gULwozowskGt7j4gtg7DvRA4C8qgVZXYFIqMmAz7ITaPuCmDHmoYe0ln3pR8I39ml8GePC1RR1WhUOOdlV9rSeemZzLnl8ncIxI4IEu4uqSXLaE0PlwPB7UIO9txa23HeArnZBoFZihxPx+2O+lqhungpdKYF4VBEi3XDK272i5aMS+b2BPeRjQtveLkEdE8UNCEJ+pu0iVtjBBSLmhZbC86RAMHSlVp5DDyHeFsXpCN/h61JUuQL3tUIZaSVeTmUJUB1q37Ahs7Blfxy7BukCHII0zrERWjUl+D+f9KqaM7aDMZJD7JR5zIPw1neb9+N9EQPMwSPlDHOJrw4QHJZFC31Lw2rxm3nZ/EOPYSBPeqMEbFOSijSQBvzScoopepM0MOIoI3HZP2A+eLhHQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A77E02BA58D59840B0163CBCBC9F7CA5@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cef4def-f19c-4c0a-a6ba-08d68146fd89
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2019 15:25:21.6641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB3258
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMS8yMy8xOSAxMjoyNSBQTSwgQW5kcmVpIEJvcnplbmtvdiB3cm90ZToNCj4gT24gV2VkLCBK
YW4gMjMsIDIwMTkgYXQgMTo0NSBQTSBEZW5uaXMgS2F0c29uaXMgPGRlbm5pc2tAbmV0c3BhY2Uu
bmV0LmF1PiB3cm90ZToNCj4+IEkgdGhpbmsgbXkgcHJldmlvdXMgZS1tYWlsIGRpZCBub3QgZ28g
dGhyb3VnaC4gIEJhc2ljYWxseSwgaWYgaXQgaXMNCj4+IGFzc3VtZWQgdGhhdCBhIGJ0cmZzLXJl
Y2VpdmUgb3BlcmF0aW9uIHdpbGwgcmVzdWx0IGluIGEgc3Vidm9sdW1lIHdoaWNoDQo+PiBtYXRj
aGVzIHRoZSBzb3VyY2UgZmlsZSBmb3IgZmlsZSwgdGhlbiB0aGlzIGFzc3VtcHRpb24gb3IgZXhw
ZWN0YXRpb24NCj4+IHdvbid0IGJlIG1ldCBpZiBvbmUgZGVsZXRlcyBmaWxlcyBmcm9tIHRoZSBz
dWJ2b2x1bWUgYXQgdGhlIHJlY2VpdmluZw0KPj4gZW5kIHdoaWNoIGlzIGdvaW5nIHRvIGJlIHJl
ZmVycmVkIHRvIGFzIHRoZSBwYXJlbnQuDQo+Pg0KPiANCj4gVGhpcyBpcyBveHltb3Jvbi4gYnRy
ZnMgc2VuZC9yZWNlaXZlIGFwcGx5IHRvIHJlYWQtb25seSBzdWJ2b2x1bWVzLg0KPiBZb3UgYXJl
IG5vdCBhYmxlIHRvIG1vZGlmeSB0aGVtLiBBcyBzb29uIGFzIHlvdSByZW1vdmUgcmVhZC1vbmx5
IGJpdCwNCj4geW91IGFyZSBmdWxseSByZXNwb25zaWJsZSBmb3IgY29uc2VxdWVuY2VzLg0KPiAN
Cj4+IFRoaXMgY2FuIGhhcHBlbiBpbmFkdmVydGVudGx5LA0KPiANCj4gSXQgY2Fubm90LiBZb3Ug
ZG8gbm90IGluYWR2ZXJ0ZW50bHkgbWFrZSBzdWJ2b2x1bWUgcmVhZC13cml0ZS4gQW5kIGlmDQo+
IHlvdSBkbywgeW91IGFyZSBleHBlY3RlZCB0byBrbm93IHdoYXQgeW91IGFyZSBkb2luZy4NCj4g
DQo+IFRoYXQgc2FpZCwgYmV0dGVyIGlmIGJ0cmZzIGRpZCBub3QgYWxsb3cgZmxpcHBpbmcgcmVh
ZC1vbmx5IGJpdCBpbiB0aGUNCj4gZmlyc3QgcGxhY2UuDQoNCisxMDANCg0KQnV0IHRoZW4gb25s
eSBkaXNhbGxvdyBpZiB0aGUgc3Vidm9sIGhhcyBhIHZhbHVlIGluIHRoZSByZWNlaXZlZF91dWlk
DQpmaWVsZCwgSSdkIHNheS4NCg0KQW5kIHRoZSB0b29saW5nIGNvdWxkIGRpc3BsYXkgYSBuaWNl
IGVycm9yIG1lc3NhZ2UsIHRlbGxpbmcgdGhlIHVzZXIgdG8NCm1ha2UgYSBydyBzbmFwc2hvdCBv
ZiB0aGUgcmVjZWl2ZWQgc3Vidm9sIGluc3RlYWQsIHdoaWNoIHdpbGwgaGF2ZSBhbg0KZW1wdHkg
cmVjZWl2ZWRfdXVpZCBmaWVsZCBhZ2Fpbi4NCg0KRVJST1I6IHN1YnZvbHVtZSBpcyBhIHJlY2Vp
dmVkIHN1YnZvbHVtZSwgd2hpY2ggY2Fubm90IGJlIG1hZGUgcmVhZC13cml0ZQ0KRVJST1I6IHN1
Z2dlc3Rpb247IG1ha2UgYSByZWFkLXdyaXRlIHNuYXBzaG90IG9mIGl0IGluc3RlYWQNCg0KU2V0
dGluZyBzb21ldGhpbmcgcm8gbWFudWFsbHkgKGUuZy4gdG8gcHJldmVudCBhY2NpZGVudGFsIGRl
bGV0aW9uIG9mIGENCnN0YXRpYyBzZXQgb2YgZGF0YSkgaXMgc3RpbGwgYWxzbyBhIHVzZSBjYXNl
Lg0KDQo+PiBvciBldmVuIHRocm91Z2ggZmlsZXN5c3RlbSBjb3JydXB0aW9uDQo+PiAod2hpY2gg
SSBleHBlcmllbmNlZCkuDQo+Pg0KPiANCj4gQW5kIGlmIGNvcnJ1cHRpb24gaGFwcGVuZWQgYWZ0
ZXIgYXBwbHlpbmcgY2hhbmdlcz8gRW5kIHJlc3VsdCBpbiB0aGUNCj4gc2FtZS4gT2YgY291cnNl
IGl0IHdvdWxkIGJlIHBlcmZlY3QgaWYgYnRyZnMgY291bGQgbm90aWNlIGFuZCB3YXJuDQo+IHlv
dSwgSSBqdXN0IGRvIG5vdCBzZWUgaG93IGl0IGNhbiByZWFsaXN0aWNhbGx5IGJlIGltcGxlbWVu
dGVkLg0KPiANCg0KDQotLSANCkhhbnMgdmFuIEtyYW5lbmJ1cmcNCg==
