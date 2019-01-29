Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8263AC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 23:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 398242175B
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 23:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="D/kWx3L5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfA2XPY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 18:15:24 -0500
Received: from mail-eopbgr00057.outbound.protection.outlook.com ([40.107.0.57]:64596
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbfA2XPX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 18:15:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0g9yScodnDgJsPTyDRfakTbbWjgQpfEJ7m8F+ZgS0dc=;
 b=D/kWx3L5EuBjU0gYF8FhafjBtshcSovjbuJOiobDO1uPwabztgpvrknHcaUTKgpf9xWFH6xTgNUlmkkb7RI1w09vfhpu26CSjf2l0elRXa4M1e2b9vhZFznzXh/WJ/JUe7sXBUrJJ02LGh6PWEFgBeUO4ierLB+8rjlnZSlrRAw=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB2971.eurprd06.prod.outlook.com (10.175.33.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.17; Tue, 29 Jan 2019 23:15:18 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44%3]) with mapi id 15.20.1558.023; Tue, 29 Jan 2019
 23:15:18 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: dm-integrity + mdadm + btrfs = no journal?
Thread-Topic: dm-integrity + mdadm + btrfs = no journal?
Thread-Index: AQHUuCh/43oR4YS6O0GbzZU+vBi49Q==
Date:   Tue, 29 Jan 2019 23:15:18 +0000
Message-ID: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6P193CA0096.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::37) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB2971;6:Z8ZQH43xU2+70v9wfN/xXJ5t24lCGcEzH2ungcFdadLdJnZj72bRtQEucj2ZBavvIkEaYc1Z0qTbABfuNSU7MREfZZ4KOJlOJuhq46Cune/OYtS6WL8ztwxLILK8y7ShF8ElCS74C0ciSwC3F+39WkB2UcqH9kY8jo3CpW7Br9Jp3/XKWHJ4HlGvJQ4RoFSSaEfuDbll6uqGKJq4tcAmDe4CwaHbMjeE0a6hvoG2KGUXhd4gDrLL39qP641uL+VPLoJXIVZ94PTUbKFYGFVH+sIbItLQZYN3j2iXiR5NE13DyefE+LQCMdrCSVcat4aHaJa0i3k3G3KtrVCw6fetcUe+pmXg4s6ST7IMR9nGsd9th0cWAdpr1WzR60QQxKJpxtifPnj3eiXWOFP8Pk50Bh2/cJiqU/LYm90qkyBjlvlGPHL9DElBu3u3g48lXFxMom7/3FE5fjTexiapcAG6kQ==;5:m1aYVydchq61CmNycovbxBeNAcPTPjDzqCMzkwPftaDZO6tXSSA/mlISuO2WzBQiwPIfiiN/SM1H/UBUDgjodz+IHt5m5lzxTTtGeCHD0LYdFoXCdKHLpvzCuiXS4DYVslOUMov2ya8c6BSst1KBLObn3mzrQAjr4lkXtTw7VKQxKD6z74+UI41Dvzb/Pc1Ef4rpbaqoJCSIX4FurFRahw==;7:kuqY51fOl+afx9ZKjxwrj1ZuHoYHbDRgMFjSiy8c2LNsmrK0XzwGirDVXzuYRMHY4D6xzLUElm1QUEvZvGEPNH+z7uLGpZipV/e0wGiCr6tFy9tOJv+ExA1mREx8WKxhKESKbqqmSBTPiSi66uF78w==
x-ms-office365-filtering-correlation-id: 8d8c2b22-5c6b-431a-2243-08d6863fa22c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:HE1PR0602MB2971;
x-ms-traffictypediagnostic: HE1PR0602MB2971:
x-microsoft-antispam-prvs: <HE1PR0602MB2971454B82139D1FD85B39F1D4970@HE1PR0602MB2971.eurprd06.prod.outlook.com>
x-forefront-prvs: 093290AD39
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(346002)(366004)(39850400004)(199004)(189003)(6916009)(6512007)(31686004)(105586002)(2906002)(52116002)(58126008)(64126003)(97736004)(53936002)(99286004)(71190400001)(6486002)(86362001)(71200400001)(6436002)(106356001)(31696002)(186003)(65826007)(386003)(65956001)(65806001)(46003)(81166006)(81156014)(102836004)(478600001)(8936002)(486006)(8676002)(256004)(14444005)(476003)(6506007)(14454004)(25786009)(72206003)(2616005)(68736007)(36756003)(316002)(305945005)(6116002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB2971;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eqv02h2TZ/CdJ20Ymh8sDbyOCTax604DkLKjqUxvqcLRYUv8CmwKrFtHWtND+j1eYc1ztZUHuJQfLhoasUqjZX2bgyT+vFsI1CBwr083eJM6oueuMHkk+R/cAMTDxd3syUXPeD8sbiN42OGTdzpxxF26tScx5QjMTBd3Vdnd/fksocXDDvYImwS3xU8bbUFnEJu9WzRitsXw8oSx9G3PdHb0Nv8ddWDyw9/M8I23DK+fJRnf8fkxX+GZhTDr3MPFY6UNDGosfgncwLJjiYddytkX87Mrxz8ayLggk1mj6hUBu+xb/UieXqqHovSxI1pHlCn4ypjpzXEZ0fJPeIPX+YkLsUUiMTeh++gSJNUtlZfWPeMZIJRgWSDs51RrKMlR1YI/nubEjTDPHDML1238djGMWwS36Nj2xlKJ65lkkt8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29D5AF1A138A43459679069A9E6F94FD@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8c2b22-5c6b-431a-2243-08d6863fa22c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2019 23:15:17.9804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB2971
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGksDQoNClRob3VnaHQgZXhwZXJpbWVudCB0aW1lLi4uDQoNCkkgaGF2ZSBhbiBIUCB6ODIwIHdv
cmtzdGF0aW9uIGhlcmUgKHdpdGggRUNDIG1lbW9yeSwgeWF5ISkgYW5kIDR4MjUwRw0KMTBrIFNB
UyBkaXNrcyAoYW5kIHNvbWUgc3BhcmUgZGlza3MpLiBJdCdzIGRvbmF0ZWQgaGFyZHdhcmUsIGFu
ZCBJJ20NCmdvaW5nIHRvIHVzZSBpdCB0byByZXBsYWNlIHRoZSBjdXJyZW50IHNlcnZlciBpbiB0
aGUgb2ZmaWNlIG9mIGENCm5vbi1wcm9maXQgb3JnYW5pemF0aW9uIChzbyBpdCdzIG5vdCB3b3Jr
IHN0dWZmIHRoaXMgdGltZSkuDQoNClRoZSBtYWNoaW5lIGlzIGdvaW5nIHRvIHJ1biBEZWJpYW4v
WGVuIGFuZCBhIGZldyB2aXJ0dWFsIG1hY2hpbmVzDQooY3VycmVudCBvbmUgYWxzbyBkb2VzLCBi
dXQgdGhlIGhhcmR3YXJlIGlzIG5vdyByZWFsbHkgc3RhcnRpbmcgdG8gZmFsbA0KYXBhcnQpLg0K
DQpJIGhhdmUgYmVlbiB0aGlua2luZyBhIGJpdCBob3cgdG8gKHJlKW9yZ2FuaXplIGRpc2sgc3Rv
cmFnZSBpbiB0aGlzDQpzY2VuYXJpby4NCg0KMS4gTGV0J3MgdXNlIGJ0cmZzIGV2ZXJ5d2hlcmUu
IFw6RC8NCjIuIEZvciBydW5uaW5nIFhlbiB2aXJ0dWFsIG1hY2hpbmVzLCBJIHByZWZlciBibG9j
ayBkZXZpY2VzIG9uIExWTS4gTm8NCmltYWdlIGZpbGVzLCBubyBidHJmcy1vbi1idHJmcyBldGMu
Li4NCjMuIE9oLCBhbmQgdGhlcmUncyBhbHNvIDEgTVMgV2luZG93cyBWTSB0aGF0IHdpbGwgYmUg
aW4gdGhlIG1peC4NCg0KT2J2aW91c2x5IEkgY2FuJ3Qgc3RhcnQgdXNpbmcgbXVsdGktZGV2aWNl
IGJ0cmZzIGluIGVhY2ggYW5kIGV2ZXJ5DQp2aXJ0dWFsIG1hY2hpbmUgKGEgYmlnIHBpbGUgb2Yg
aG9ycm9yIHdoZW4gb25lIGRpc2sgZGllcyBvciBzdGFydHMNCm1pc2JlaGF2aW5nKS4NCg0KU28s
IHdoYXQgSSB3YXMgdGhpbmtpbmcgb2YgaXM6DQoNCiogVXNlIGRtLWludGVncml0eSBvbiBwYXJ0
aXRpb25zIG9uIHRoZSBpbmRpdmlkdWFsIGRpc2tzDQoqIFVzZSBtZGFkbSBSQUlEMTAgb24gdG9w
ICh3aGljaCBpcyB0aGVuIGFibGUgdG8gcmVwYWlyIGJpdHJvdCkNCiogVXNlIExWTSBvbiB0b3AN
CiogRXRjLi4uDQoNCkZvciBhbGwgb2YgdGhlIGZpbGVzeXN0ZW1zLCBJIHdvdWxkIGJlIGRvaW5n
IGJhY2t1cHMgdG8gYSByZW1vdGUNCmxvY2F0aW9uIG91dHNpZGUgb2YgdGhlIGJ1aWxkaW5nIHdp
dGggc2VuZC9yZWNlaXZlLg0KDQpUaGUgV2luZG93cyBWTSB3aWxsIGJlIGFuIGltYWdlIGZpbGUg
b24gYSBidHJmcyBmaWxlc3lzdGVtIGluIHRoZSBYZW4NCmRvbTAuIEl0J3MgaWRsZSBtb3N0IG9m
IHRoZSB0aW1lLCBhbmQgSSB0aGluayBjb3crYXV0b2RlZnJhZyBjYW4gZWFzaWx5DQpoYW5kbGUg
aXQuIEknZCBsaWtlIHRvIGJlIGFibGUgdG8gdGFrZSBzbmFwc2hvdHMgb2YgaXQgd2hpY2ggY2Fu
IGJlIHNlbnQNCnRvIGEgcmVtb3RlIGxvY2F0aW9uLg0KDQpOb3csIHRvIGZpbmFsbHkgdGhyb3cg
aW4gdGhlIGJpZyBxdWVzdGlvbjogSWYgSSB1c2UgYnRyZnMgZXZlcnl3aGVyZSwNCmNhbiBJIHJ1
biBkbS1pbnRlZ3JpdHkgd2l0aG91dCBhIGpvdXJuYWw/DQoNCkFzIGZhciBhcyBJIGNhbiByZWFz
b24gYWJvdXQuLiBJIGNvdWxkLiBBcyBsb25nIGFzIHRoZXJlJ3Mgbm8gJ25vY293Jw0KaGFwcGVu
aW5nLCB0aGUgb25seSB0aGluZyB0aGF0IG5lZWRzIHRvIGhhcHBlbiBjb3JyZWN0bHkgaXMgc3Vw
ZXJibG9jaw0Kd3JpdGVzLCByaWdodD8NCg0KLS0gDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=
