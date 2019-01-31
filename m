Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DACC169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 18:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77364218AF
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 18:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfAaS4y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 13:56:54 -0500
Received: from mx0b-00176a03.pphosted.com ([67.231.157.48]:49136 "EHLO
        mx0a-00176a03.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727858AbfAaS4y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:56:54 -0500
X-Greylist: delayed 4847 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2019 13:56:53 EST
Received: from pps.filterd (m0048205.ppops.net [127.0.0.1])
        by m0048205.ppops.net-00176a03. (8.16.0.22/8.16.0.22) with SMTP id x0VHYlsR039273
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 12:36:06 -0500
From:   "Karollil, Anoop (GE Digital)" <Anoop.Karollil@ge.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: mkfs.btrfs reports Device or resource busy for unmounted device
Thread-Topic: mkfs.btrfs reports Device or resource busy for unmounted device
Thread-Index: AQHUuYtw/wRHjaW6k0KmGNfn+EkV6Q==
Date:   Thu, 31 Jan 2019 17:36:03 +0000
Message-ID: <573D8C58-27F7-4C0E-B05B-D149F3BA9030@ge.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [205.173.89.14]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5P101MB0267;6:a37SIYGJky+dboivonYi6djvfplfoTkwBm3AOkoJ2zbLQPEhGu9KCE5xyQykCGT6rpHv3d0PLqBJppp7jmtapBcK+2v9ptLxodL/bfzE6A/91Gu4Z18nPOmfJAFpxAMpnlyBH7pe8sgvxupaxZAJ3FRoVac/RQPj/h0YxSi81uBjonOoUBK2P4xx1TVs42PVO0I4up4J+67VZMTDw+8zl1jTr7QHV+VJwj2BQqpKcyy9xzE3e8rcuyHrilCx2BPze/RZaLctFzN159Eulz1VadWaHMii7FKvkwEpKsXe3mREqAb0SBrxo/cn68HP1LSOycY+hadWf/5eCrC1xEOauFT6YwT5qmttDsGlMD+elOSDgUMPyyhBhP6nT7GFojDzm9cGfVJPiZ0oAZVMwUZQrdTZejtH0InoVCD5mijbZx2a8wQl/2ZDEyBf9LO8LUhgA1hONgA1kL7XKvW4nU9Bzw==;5:Xno/ZLXo1Bk0C5zTzN80QA58nYPrScB5cwcF6DYlui00ozBPvJ9PQ2JfQPOKohE9uWdr9Thyo6p0h/aA3JRPQ04Y7AG3tfCiWkBNoTwKk8WBfP27I0/umrTIh3Bbt0xPUz3kgGzWyY1u1RWE/Y2SafRmNS8/3CEGr7EdeGjDLBAKNUbF+2ORjYbyOuWF2dM+I/meYK/GenoDvSqrQflHyA==;7:7s/qSnnaUJ3qwO3Z49OP7ZoaItdZA3uIxav3a1dE+oIC5xWRrwCLi5Jrhh5Ubti39aGC5rTfCTMiC2a4Bhm2k0gMYNi5RnjV/DVbyDQMGUHlsx6VlFPtQ1nZ8WTliZVrTkyWBlcHg4G/3nJHFCTTzA==
x-ms-office365-filtering-correlation-id: ae011e2a-9dc2-494b-568a-08d687a292ad
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:DM5P101MB0267;
x-ms-traffictypediagnostic: DM5P101MB0267:
x-microsoft-antispam-prvs: <DM5P101MB0267645D729FD83356CDC857F4910@DM5P101MB0267.NAMP101.PROD.OUTLOOK.COM>
x-forefront-prvs: 09347618C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(6486002)(6512007)(99286004)(53936002)(14454004)(36756003)(2351001)(66066001)(2501003)(71200400001)(71190400001)(3846002)(6116002)(33656002)(2906002)(83716004)(105586002)(82746002)(106356001)(25786009)(5640700003)(6916009)(256004)(16799955002)(97736004)(6306002)(72206003)(966005)(347745004)(6436002)(478600001)(2616005)(316002)(476003)(8936002)(7736002)(305945005)(81166006)(102836004)(6506007)(86362001)(486006)(8676002)(68736007)(81156014)(186003)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5P101MB0267;H:DM5P101MB0139.NAMP101.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ge.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uFcKM0ahqWklWsEm2Y6ZEBECHhkbd7IrQe1D2YPa2bUYBHuqudKB+0bUlgkzlNyq2Bm21PNaGtJYWqMFB3s9/6xRroIgh6/UjDHrgDsWVwKWJXP5clzYQm5XVoq+8FEZm65rckfFg/uN4+f1PrO8CJ7Go3wthkJytAzQpvrrxg7McZR07z7r8icfcC/ZjGwCN8+FaUqYUpiIHA2/BxsaI6qLVtdqTEPKubHOzg1lYTC3OUN81TLi/pt9lJIidfqFH0ugQziIprfbViF7wiKcwDMgXBd3ZzbALz3S2l/uKab6xUivUwfxUzLpzqm7sOsflNN3MuhHHFedThHF0j2e6c/v9Rllvcl65dg19Q9Mn955RPWef/cbQJl8pdMrT3iOHnTbWOcmxRRR7IbwImsIFWSEuM3r5pBSgZEyPJ7jF7o=
Content-ID: <ACBDE0C122C4C24B92F8E04CF537ECEE@NAMP101.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ae011e2a-9dc2-494b-568a-08d687a292ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2019 17:36:03.4007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 15ccb6d1-d335-4996-b6f9-7b6925f08121
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5P101MB0267
X-OriginatorOrg: ge.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-31_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=918 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1901310135
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGVsbG8sDQogDQpJIGZhY2VkIGFuIGlzc3VlIHdpdGggbWtmcy5idHJmcyByZXBvcnRpbmcg4oCc
RGV2aWNlIG9yIHJlc291cmNlIGJ1c3nigJ0gZm9yIGFuIHVubW91bnRlZCBkZXZpY2UuIE1heWJl
IHRoZSB1bW91bnQgc2hvdWxkIGhhdmUgZmFpbGVkIGFzIGEgcHJvY2VzcyBsaXN0ZWQgdGhlIGJ0
cmZzIGZpbGVzeXN0ZW0gaW4gaXRzIC9wcm9jL1BJRC9tb3VudGluZm8gYWZ0ZXIgdGhlIHVtb3Vu
dC4gQSBzdWJzZXF1ZW50IG1rZnMuYnRyZnMgZGlkIGZhaWwgd2hlbiBpdCB0cmllZCB0byBvcGVu
IHRoZSBkZXZpY2Ugd2l0aCBPX0VYQ0wuDQogDQpJIHRoaW5rIEkgYW0gc2VlaW5nIHRoZSBzYW1l
IHRoaW5nIGJ5IGRvaW5nIHRoZSBmb2xsb3dpbmcgb24gVWJ1bnR1IDE4LjA0LjEgeDg2XzY0IHdp
dGggYnRyZnMtcHJvZ3MgdjQuMTUuMS0xYnVpbGQxIGFuZCBrZXJuZWwgdjQuMTUuMC00My1nZW5l
cmljOg0KDQpJbml0aWFsIHNldHVwIGJhc2VkIG9uIGh0dHBzOi8vYnRyZnMud2lraS5rZXJuZWwu
b3JnL2luZGV4LnBocC9EZWJ1Z2dpbmdfQnRyZnNfd2l0aF9HREI6DQogDQpkZCBpZj0vZGV2L3pl
cm8gb2Y9YnRyZnMuaW1nIGJzPTRrIGNvdW50PTEwMDAwMA0KbWtmcy5idHJmcyBidHJmcy5pbWcN
Cmxvc2V0dXAgL2Rldi9sb29wMSBidHJmcy5pbWcNCm1rZGlyIC9tbnQvdGVzdA0KbW91bnQgLXQg
YnRyZnMgL2Rldi9sb29wMSAvbW50L3Rlc3QNCiANClRoZW4gcnVuIHRoZSBmb2xsb3dpbmcgaW4g
b25lIHRlcm1pbmFsOg0KIA0Kc3VkbyBzaCAtYyAid2hpbGUgdHJ1ZTsgZG8gbW91bnQgLXQgYnRy
ZnMgL2Rldi9sb29wMSAvbW50L3Rlc3Q7IGVjaG8gImZvb2JhciIgPiAvbW50L3Rlc3QvZm9vYmFy
OyB1bW91bnQgL21udC90ZXN0OyBzbGVlcCAxOyBkb25lIg0KIA0KQW5kIHJ1biB0aGUgZm9sbG93
aW5nIGluIGFub3RoZXIgdGVybWluYWw6DQogDQp3aGlsZSB0cnVlOyBkbyBzdWRvIG1rZnMuYnRy
ZnMgLWYgL2Rldi9sb29wMTtzbGVlcCAxO2RvbmUNCiANCllvdSBzaG91bGQgc2VlIHRoZSBta2Zz
LmJ0cmZzIGZhaWwgb2NjYXNpb25hbGx5IHdpdGgg4oCcRVJST1I6IHVuYWJsZSB0byBvcGVuIC9k
ZXYvbG9vcDE6IERldmljZSBvciByZXNvdXJjZSBidXN54oCdLiBTb21ldGhpbmcgc2ltaWxhciBz
ZWVtcyB0byBoYXZlIGJlZW4gZml4ZWQgYnkgdGhpcyBwYXRjaDogaHR0cHM6Ly9wYXRjaHdvcmsu
a2VybmVsLm9yZy9wYXRjaC8yMjQxMDgxLyBidXQgSSBjb3VsZG7igJl0IHJlcHJvZHVjZSB0aGlz
IHByb2JsZW0gd2l0aCB0aGUgc3RlcHMgbWVudGlvbmVkIHRoZXJlLg0KIA0KVGhhbmtzLA0KQW5v
b3ANCg0KClVuc3Vic2NyaWJlIGZyb20gR0UncyBjb21tZXJjaWFsIGVsZWN0cm9uaWMgbWVzc2Fn
ZXM6IGh0dHA6Ly9zYy5nZS5jb20vKmNhc2wtdW5zdWJzY3JpYmUgCkTDqXNhYm9ubmVyIGRlcyBt
ZXNzYWdlcyDDqWxlY3Ryb25pcXVlcyBjb21tZXJjaWF1eCBkZSBHRTogaHR0cDovL3NjLmdlLmNv
bS8qbGNhcC1kZXNhYm9ubmVtZW50Cg==
