Return-Path: <SRS0=UsBE=QC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993DBC282C7
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 19:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5893C2085A
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 19:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="BQ3Zc4Io"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbfAZTzP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 26 Jan 2019 14:55:15 -0500
Received: from mail-eopbgr00077.outbound.protection.outlook.com ([40.107.0.77]:61120
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726344AbfAZTzO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Jan 2019 14:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHy6mBd3+UEd4adWFcxU4euBAKMSrWJNkHO9Cz0y8Sk=;
 b=BQ3Zc4IozTHf4JUgORpXuqmU5ywyIQAbh6aL+sigoV7shpIBytgkhky9qOsGrJOFy16o+p+dQm+QUb/Yehl0xxNp8RrBgE1yy2Po2udXrMQj/AMF8aUpPi9Mpk8H0eDtjswpA8CHseRpOL2LNlnqFcPc62RDa8RJhPFRROEtelQ=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB3275.eurprd06.prod.outlook.com (10.171.197.157) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.20; Sat, 26 Jan 2019 19:55:11 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44%3]) with mapi id 15.20.1558.021; Sat, 26 Jan 2019
 19:55:11 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs-heatmap v8
Thread-Topic: btrfs-heatmap v8
Thread-Index: AQHUtbELm1sg6fBYiUW20qUapeep/A==
Date:   Sat, 26 Jan 2019 19:55:11 +0000
Message-ID: <d2ece024-d09c-2015-c246-99c8b5ab3fba@mendix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6PR0402CA0033.eurprd04.prod.outlook.com
 (2603:10a6:209::46) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB3275;6:meGxvRyxn1yHWmOj3QVCJ2ZEpg3qmP2Jrv3yIjE2suhFQA2rUEWUHsY/A7uQQbZ4Jfr+nGP7Y1tWi0NdOXL/wlg+8upObViXDEh8zI3y13+XMt7Tt8wuu7NW0xKnerFuwKk9GdfvsVByzrGg9bVJk6eipO6e1BYvXfpCGbv/ttRi79Qa3bmgUxh2m7/e4PITbUDkDvF1El+uL6cCgZFLbj+oyAXl5c28imCzDRtIQ4C1SOWIjbHehlLIlJlEt7HDMpqZBU37hKzCVA3CFR4dUiJ631YdGldzDGfNGX1QFPuA5LqBpEc8xGVF5nI0XUlN0nwUvgRffDsZMqzt+kK6gCy5JVxPFp0NvXxvQYWUwhvFY7XESeX+SpJLB7vKq4Uc54QNKhdKHPcw3LSSvtA5o75cV0lR+XUVL5zsQglGxRMcrUq0EbKhds/Q8Xa/HU2nGM0sxsHb1tHh2+GyXK6nZw==;5:eSq/2epDRJ/fTsdWDsAcXaM3yqZinmmti6pOWpUKTwSOPnQcRfJNsm/B9D1Jd+57qg5XU2KgfnmYeQeQOWUWK/6fldGkNQq/RR0VUOJUpYS6z2hSiX56xDpWbA1gC/nWU37hgS8GUyqISBmXN1zdqdK1wIJrJpdOuxLK6r4s+d5viTY8BDoU7WWaLsMk6d4Wj3/uc/S7k7I5BTMPiDimVg==;7:7337PfKlPrir3Sc2Ux7d4FRsArS31Z+8lViHmdNUbjQQS+efCPheA2xdE6OJq+2t5MjKz3BMxkC+t13EncUdo5VrVcaqy50TF7rLXO+Ks/E/XHwCgBp8QKxDDFBFDUt+GBmS+czjUwW4dx908OcCrw==
x-ms-office365-filtering-correlation-id: e11faa28-b058-4d4b-398d-08d683c82dee
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:HE1PR0602MB3275;
x-ms-traffictypediagnostic: HE1PR0602MB3275:
x-microsoft-antispam-prvs: <HE1PR0602MB32754ED4B4B930D30CFA42D0D4940@HE1PR0602MB3275.eurprd06.prod.outlook.com>
x-forefront-prvs: 0929F1BAED
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(2351001)(97736004)(5640700003)(65826007)(14454004)(7736002)(102836004)(71190400001)(58126008)(316002)(2616005)(46003)(386003)(2501003)(305945005)(52116002)(476003)(6116002)(4744005)(25786009)(106356001)(71200400001)(31686004)(105586002)(6506007)(6436002)(72206003)(68736007)(486006)(186003)(65806001)(966005)(65956001)(64126003)(8936002)(6306002)(8676002)(36756003)(478600001)(53936002)(81166006)(81156014)(14444005)(6512007)(6916009)(2906002)(31696002)(86362001)(99286004)(256004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB3275;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 795JdUI1U59faVfx2WUNAT3iWi8RNeXoZ4OLuKKUQNl204AgZsyAGzWX5fMcdgWC7dTKpbQepezRLWjDA91FXXfmS+JSOIARtUKHT8XGG4jckttDz9wFi5J/2igKSppsyoRRhvKU+DrWV041vm+ct1Yd4gnRcBO1djMfxuFfQXCscMc+BbbzEvYV3eqUBWWZfT/ApOGFiLv013JcVD7dVM1E5pfExyT3q7m3IIjqatuN5KZXH0NqH7krj5sKzGcSDbu/ExiaK+UFHbLVYk8DislU5G915TI3yNefd/w3kmLVYTz0a7ULe96WHhwkE2SRwvkuKd6PjgDMefY668xNQpYXwLqV+iwv9zeWOTkLWr3Lu/ZOZxPo9yyXAY7dFCxDrRmsBd1BRTycXcDo6o4jATctpCPQjHwKNvioPCZulv4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAA0CAEC4F04C444B9BDB0C30C0AF4FD@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11faa28-b058-4d4b-398d-08d683c82dee
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2019 19:55:10.5226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB3275
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Tm93IHRoYXQgcHl0aG9uLWJ0cmZzIHYxMCBpcyBvdXQsIEkgY2FuIGFsc28gZmluYWxseSB1cGRh
dGUgYnRyZnMtaGVhdG1hcC4NCg0KVGhlIG5ldyB2ZXJzaW9uIHY4IGlzIGF2YWlsYWJsZSBhdA0K
ICBodHRwczovL2dpdGh1Yi5jb20va25vcnJpZS9idHJmcy1oZWF0bWFwDQpvciwgcHJvYmFibHkg
aW4geW91ciBkaXN0cm8gcGFja2FnZSBtYW5hZ2VyIHNvb24taXNoLg0KDQpOb3RlOiBKdXN0IGxp
a2UgcHl0aG9uLWJ0cmZzLCBJIGNvbnZlcnRlZCB0aGUgYnJhbmNoZXMgaW4gZ2l0IGZvciBkZWJp
YW4NCnBhY2thZ2luZyB0byB0aGUgREVQMTQgc3RhbmRhcmQuIFRoaXMgbWlnaHQgbGVhZCB0byB1
bmV4cGVjdGVkIHdhcm5pbmdzDQp3aGVuIHVwZGF0aW5nIGEgY2xvbmUgb2YgdGhlIHJlcG9zaXRv
cnkuIEFsc28gc2VlOg0KICBodHRwczovL2dpdGh1Yi5jb20va25vcnJpZS9idHJmcy1oZWF0bWFw
L2lzc3Vlcy82DQoNCkhlcmUncyB0aGUgc3VtbWFyeSBvZiBjaGFuZ2VzIChmcm9tIENIQU5HRVMp
Og0KDQpidHJmcy1oZWF0bWFwIHY4LCBKYW4gMTksIDIwMTkNCiAgKiBUaGlzIHByb2dyYW0gbm93
IG5lZWRzIGF0IGxlYXN0IHB5dGhvbi1idHJmcyB2MTANCiAgKiBNYWtlIHNvcnRpbmcgb24gdmly
dHVhbCBhZGRyZXNzIGFjdHVhbGx5IHByb2R1Y2UgY29ycmVjdCBvdXRwdXQNCiAgICBmb3IgUkFJ
RDAsIFJBSUQxMCwgUkFJRDUgYW5kIFJBSUQ2Lg0KICAqIENoYW5nZSBsaWNlbnNlIHRvIE1JVCAo
RXhwYXQpDQoNCi0tDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=
