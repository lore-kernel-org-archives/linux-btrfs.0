Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C79CC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 16:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F4202184C
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 16:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="lHchsxxS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfAWQ7w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 11:59:52 -0500
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:12112
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbfAWQ7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 11:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9z8zYFmr1RIJJ7wMVgqqCDJ0ySdf3Xg1YM0iaqsGrW8=;
 b=lHchsxxSInekOz8SixveI3TTR3Gx0FyoCaL2RI6TMNYd5oudpyPi3LUXLRJ5V64vkKxEWWjfbYS6ViQxAoXN53YvJ5C5eGt28GEgIp0HEF6EsfzWltulqrqa7JqLvA/L4FP8DSvte0frNPwWA/c/cqwEP38MUzQzz7trXHnfAuE=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB2953.eurprd06.prod.outlook.com (10.175.33.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.29; Wed, 23 Jan 2019 16:59:47 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a%2]) with mapi id 15.20.1537.031; Wed, 23 Jan 2019
 16:59:47 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Remi Gauvin <remi@georgianit.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Incremental receive completes succesfully despite missing files
Thread-Topic: Incremental receive completes succesfully despite missing files
Thread-Index: AQHUsKvEidmBdsnBU0uW4O415p7q16W6TmeAgAJhdwCAAAtbgIAAQyMAgAAEIYCAABZAgA==
Date:   Wed, 23 Jan 2019 16:59:47 +0000
Message-ID: <01401e44-af81-c8bd-80b1-254978e19da1@mendix.com>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
 <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
 <8e5c7ee5-4507-66d2-6642-2e37ff11b897@mendix.com>
 <fdb6b51a-fbe4-c971-3c68-7e25f13aa323@georgianit.com>
In-Reply-To: <fdb6b51a-fbe4-c971-3c68-7e25f13aa323@georgianit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6P192CA0032.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::45) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB2953;6:nsuyGjicTeeUedMvXsg5Rw8haNx7hzGjD4MLlj8tL9q/IZaLdNPENe9s+YWsj9ICSsgDPV6MzKfbY4rJ4fKrqfY56yg21bNCeF/6g9Zqjwqnv1+T6wPuQHebL4XlwaRiNVO5ckqlIoRFDwT72nk5gZo8Q7BW9F2FmjwW9ZQbr6CsJCQYHncJyPhEsHN8RR0Dgbcz75gzww3hNuPukDHeFpyxtRymnOnaYVJycYNNrRw7RgnyxmutDhxyg+0IK+p22odd3K8zXEnzxPwoC33iZdpD3Fs+saB5rWeMxn1d4m/Wds/HT7fGYlGrUYNoVB100r3yYgKdQxVUiugo47UcAHwjc/BFq9glLq9bNYNbBu7okB13zwAfwzuS7DGkDdS9beiXo/x6wNpEsFrDQCS8TTgzoPf3WFylsnKAI6KerLjSnXftt6UQdIhL8jC2XmFYMJmg7blpxLjz+yS9XPuwUg==;5:KBQmYs/oTh/1t16rApQp6SzF6azgvyXW7KLp/UWE0TAc+F5b0SaAJiqdgBUciuJFJzFjWNnu73MNtWX5AWMnB0GPrfIFW+OevO0l4aj54549Yyk7KEbKXcQgb7hWXbDRQRDt4O6NRsrTlvvH4HCKp2fdu+CgNb8b3szsnzF8FItnJRrlD/sbUW+ATfMCMmOL/Afs2/vNsycmJqOKBgcaug==;7:CldVcKbWc8+WsIiKWliJHEdZTgChKSrr3BXvVMIl+lYibqykuMz0mnuMbtsMYG9q1p/RMl6JlNeE8ALFlTpMylgRTdogU1Z3QKWF2uikhSI/lKiCaS/r1XiCoCfZs9zSl3YR2esypUvNTixNma9AhA==
x-ms-office365-filtering-correlation-id: 6bd778e2-9fe2-4ce7-4768-08d681542e0a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:HE1PR0602MB2953;
x-ms-traffictypediagnostic: HE1PR0602MB2953:
x-microsoft-antispam-prvs: <HE1PR0602MB2953C932FCB1F0BCD73C16EAD4990@HE1PR0602MB2953.eurprd06.prod.outlook.com>
x-forefront-prvs: 0926B0E013
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(136003)(39850400004)(366004)(189003)(199004)(36756003)(65806001)(65956001)(6436002)(6116002)(64126003)(65826007)(256004)(68736007)(4744005)(229853002)(99286004)(6486002)(8676002)(71190400001)(71200400001)(81156014)(14454004)(81166006)(8936002)(72206003)(31686004)(478600001)(52116002)(6506007)(53546011)(386003)(76176011)(97736004)(2906002)(486006)(110136005)(106356001)(105586002)(86362001)(53936002)(31696002)(58126008)(316002)(476003)(93886005)(11346002)(6512007)(25786009)(305945005)(46003)(2616005)(446003)(102836004)(186003)(6346003)(7736002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB2953;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z96vQ+TSgvapX+RqWundZMIciOIkYZFvxISw4/Q+T1syG1dU9/Ft4/5Rck/RAixUGDd5xr83coLpVqzFhg1WBNJc4vEZqFYEj3j7oohW+EMjOUpBwSs/xYyvqI5oRX/hcWsHv476YuLtJw4/9kLka1Qykxesb4YELBAfP8UQTy9rQRn66XCiYex7iUnUBzX2pj5uYWv3Nk9aAXHE314dR0hdTWv2ztobvTt9OGBmekphbdRj0kIbSyFKIc6LZTfd65jPCqkLiMCbgwdxD6NKFRZ1fub26gEtrOGQny3nMDpecLZfFZdCZJJBwlOu/JWyFXipAvM7kdKz/IGU6PniugPPfDFUVnCtOHKW/y26cY6h4COZuedOpRG13+mX9cyXPKPoS1LbcLxF0nMDZgy++AFLqGEdnHiTMNGDPHrGdZE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46B777672BCFC54F97B09BB8DBB3ED47@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd778e2-9fe2-4ce7-4768-08d681542e0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2019 16:59:46.6283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB2953
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMS8yMy8xOSA0OjQwIFBNLCBSZW1pIEdhdXZpbiB3cm90ZToNCj4gT24gMjAxOS0wMS0yMyAx
MDoyNSBhLm0uLCBIYW5zIHZhbiBLcmFuZW5idXJnIHdyb3RlOg0KPiANCj4+DQo+PiBCdXQgdGhl
biBvbmx5IGRpc2FsbG93IGlmIHRoZSBzdWJ2b2wgaGFzIGEgdmFsdWUgaW4gdGhlIHJlY2VpdmVk
X3V1aWQNCj4+IGZpZWxkLCBJJ2Qgc2F5Lg0KPj4NCj4gDQo+IFRoYXQgd291bGQgb25seSBzb2x2
ZSBoYWxmIHRoZSBzZWxmLWhhcm0uICBVc2VyIGNhbiBzdGlsbCBtYWtlIGNoYW5nZXMNCj4gdG8g
dGhlIHBhcmVudCBzdWJ2b2x1bWUgb24gdGhlIHNlbmRpbmcgc2lkZSwgYW5kIHN1YnNlcXVlbnQg
c2VuZHMgdXNpbmcNCj4gdGhlIHNhbWUgcGFyZW50IHdpbGwgYmUgaW5jb25zaXN0ZW50Lg0KDQpX
ZWxsLCBzbyB0byBzYXksIGlzIHRoZSBnbGFzcyBoYWxmIGZ1bGwgb3IgaXMgaXQgaGFsZiBlbXB0
eT8gXDpELw0KDQpBdCB0aGUgc2VuZGluZyBzaWRlLCB0aGVyZSdzIG5vIGluZm9ybWF0aW9uIGN1
cnJlbnRseSB0aGF0IGluZGljYXRlcyB0aGUNCnN1YnZvbCBoYXMgYmVlbiBzZW50LiBBdCBsZWFz
dCB3ZSBjb3VsZCBmaXggNTAlIG9mIHRoZSBpc3N1ZS4NCg0KLS0gDQpIYW5zIHZhbiBLcmFuZW5i
dXJnDQo=
