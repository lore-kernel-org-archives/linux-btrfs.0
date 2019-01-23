Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C668C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 15:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE4CC21019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 15:54:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="XRtT944/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfAWPyG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 10:54:06 -0500
Received: from mail-eopbgr150041.outbound.protection.outlook.com ([40.107.15.41]:4608
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfAWPyF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 10:54:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fptp0XOkjoErG/aO3uFgFkuifCuL3B+Fb3UTMWFQl20=;
 b=XRtT944/J2iI3ofn37fklEzJZtFhuSRu5qklu1iMKC1VbWTPgfe8zSudywlcUUTeYUYB1nVgLA+uM1Uwt0O4a5th+W4/deP47Mmp5eXvf8ViqHhC8nWoNSqBCIva/C6e/nVVPIneAquXE/IvR77NykXwPMitjortLBi8kUPHLB8=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB3308.eurprd06.prod.outlook.com (10.170.254.159) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Wed, 23 Jan 2019 15:54:00 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a%2]) with mapi id 15.20.1537.031; Wed, 23 Jan 2019
 15:54:00 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Thread-Topic: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Thread-Index: AQHUp4hbmz1G2p+3LUilnjxye6F3E6WmG/0AgBbnSwCAABVaAA==
Date:   Wed, 23 Jan 2019 15:54:00 +0000
Message-ID: <cb62ab8d-7d6f-de02-2912-3d9391a2bbb2@mendix.com>
References: <20190108192628.121270-1-sashal@kernel.org>
 <20190108192628.121270-72-sashal@kernel.org>
 <783ccf1f-65df-d388-079c-9449d4319c27@mendix.com>
 <20190123143732.GL202535@sasha-vm>
In-Reply-To: <20190123143732.GL202535@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM5PR06CA0004.eurprd06.prod.outlook.com
 (2603:10a6:206:2::17) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB3308;6:NtCc5O1HmYLx8gSUFnN1ji5My0H8nTzyuCWYS/s3XY7Ho+Eu2DuPVF6mDA4lIk9hzF1W2EEVsPDs1Np3OAgUfP85BemDvieA4UKSJcXhZrNMXhYkvHTMT2OnwsmGoj1oKORQhcHNq7DECNOBlnD6jkNqp2ba44v9SVpdhuBbkoBS+QxHDTLDsCHF1oKD7UzSIx8tWkNFM2+Ne5IOXpHrHkR8pQbwHTsB3SNQ87IjJ7MryL8RXYqtEpsdjVmuKdbLQDgdrAwfWzB4ZDZYqZa+cml44gnkTUNArqiOB+2o8izceGlI+ARLcf8z+DzHjMt6majhPVMKhKeYi4wC2z06+NmfbnP7mIw1Rj4N4Op57Q9Tv4t9zS6sRhl0GMdavCFDPKlMIGyJUfZPx6eTsL0+3S6HZT2Wi59l1mmBf2cNcErIgflM6dlexonZ9SksYLW9IQM05yZkrIl4iJ8QcJL5jw==;5:/0zddcxEjHvQP/r/ozYejvVsLJTThyoRJ+kb7VifmMZFksHsExspB9L//Q3UsEZadD1gleNGJfJCgdwgXHQzeFYor8TyYwXTxX3II4v+4cockY1JOuF5pRjB/kwDUqV8CPWohWg6pNoq9OdfbdHwaEk3boN/36K2l5HbSx0iAfwCGc6A+dLZtPyNba6bg0KXcGjxhi8G9bhCUUWTLitpDQ==;7:KHJvZeiePX5DpZfwJWcI2MIcTJ6+mJhgWNBElPCb7H0JWMVVr1haK3x9Rk175IRCpBH5XT4ImdBKz9xDFf99VxamTZLB91HM3D+69Is5fuYXPlwYYkI4ScNXdWOwjFlUMqZD+QsDZR8YNClWRfr4+w==
x-ms-office365-filtering-correlation-id: a9b29b2e-9286-4c31-d4bb-08d6814afd81
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:HE1PR0602MB3308;
x-ms-traffictypediagnostic: HE1PR0602MB3308:
x-microsoft-antispam-prvs: <HE1PR0602MB33086DD6148BE57838885BA3D4990@HE1PR0602MB3308.eurprd06.prod.outlook.com>
x-forefront-prvs: 0926B0E013
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39850400004)(136003)(376002)(346002)(366004)(199004)(189003)(386003)(305945005)(6506007)(72206003)(478600001)(102836004)(76176011)(71200400001)(71190400001)(36756003)(97736004)(6116002)(58126008)(316002)(99286004)(217873002)(81156014)(14444005)(8936002)(256004)(53546011)(7736002)(54906003)(68736007)(106356001)(14454004)(8676002)(6246003)(81166006)(93886005)(65806001)(186003)(65956001)(105586002)(53936002)(6916009)(31696002)(31686004)(6512007)(86362001)(229853002)(46003)(64126003)(52116002)(4326008)(65826007)(446003)(486006)(6436002)(476003)(2616005)(11346002)(2906002)(6486002)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB3308;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2mNpHCPkjkacTtwU0pcg/2JkEEWHJLnwuW0H/6CForBbr7fvx+jdzXRHAiGduykwJy1tZeKi4mU5aIpDTNFnNTf+Ak7a40SMYtBtDkNd3+VCW9mrhYFJGqSU4O8e34Jeo9319F/H4uuOjUkLR2W7vm98iDjhHKW+STSHXrlnfVViu8b8lTI+wbgJtkSSNAVuv27vpjR3aoREuHEQkJKv4uk77QWeqfUHrwkxYOMFsm5+bSV8rZa0dxgqTOvRtVokKNiorzNlILf/GqPXL3kMYusmnhaB2iwSL/mI/kzwy3PJZDmaDl3+uz+IgazVLn9Rg/NkIUDa1RjKtM6egMRu82+xjeeLDm1/K8wyrsefP+fAyGYhdcsGvIw9o5laa6pqdTBPRHdkBciTxLlXCVutgvC4rNovIvjvNUntfUJkzlQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC67C4A8EEF943429A3D3F6CEA0431A9@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b29b2e-9286-4c31-d4bb-08d6814afd81
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2019 15:53:59.4897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB3308
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMS8yMy8xOSAzOjM3IFBNLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4gT24gVHVlLCBKYW4gMDgs
IDIwMTkgYXQgMTE6NTI6MDJQTSArMDAwMCwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4+
IEhpIFNhc2hhLA0KPj4NCj4+IE9uIDEvOC8xOSA4OjI1IFBNLCBTYXNoYSBMZXZpbiB3cm90ZToN
Cj4+PiBGcm9tOiBIYW5zIHZhbiBLcmFuZW5idXJnIDxoYW5zLnZhbi5rcmFuZW5idXJnQG1lbmRp
eC5jb20+DQo+Pj4NCj4+PiBbIFVwc3RyZWFtIGNvbW1pdCBiYWY5MjExNGM3ZTZkZDYxMjRhYTNk
NTA2ZTRiYzRiNjk0ZGEzYmMzIF0NCj4+Pg0KPj4+IENvbW1pdCA5MmUyMjJkZjdiICJidHJmczog
YWxsb2NfY2h1bms6IGZpeCBEVVAgc3RyaXBlIHNpemUgaGFuZGxpbmciDQo+Pj4gZml4ZWQgY2Fs
Y3VsYXRpbmcgdGhlIHN0cmlwZV9zaXplIGZvciBhIG5ldyBEVVAgY2h1bmsuDQo+Pg0KPj4gVGhh
dCBvbmUgYWxzbyBlbmRlZCB1cCBhczoNCj4+DQo+PiA0LjE0LXN0YWJsZQ0KPj4gMDEzNmJkNzIz
OGIyY2I4MjM4NDI2YWY0MTgzZWQwYjAyMTY1YzNmOQ0KPj4NCj4+IDQuOS1zdGFibGUNCj4+IDg4
OTBiYWUwM2Y0ZGJhMWMyMjkyZTU0NDU2ODJiNTU2YWY0ZThmMWINCj4+DQo+PiA0LjQtc3RhYmxl
DQo+PiA5N2MzZTQ2ZWY1Mzc0ODI3ODI4NmZjMDlkY2MzMGIxMzhkNjY3N2M0DQo+Pg0KPj4gMy4x
Ni41Ny1yYzENCj4+IGY2OGY0NjI4NGExOTlmNjgzN2MxZDViOTRhNmFlOTc5YTJjYzQ2M2MNCj4+
DQo+PiBXaGlsZSBoaXR0aW5nIHRoZSBmYWlsdXJlIGNvbmRpdGlvbiB3aXRob3V0IGFkZGluZyAi
Y3JhZnRpbmciIHN0ZXBzIHRvDQo+PiBtYWtlIGl0IGV4YWN0bHkgbWF0Y2ggdGhlIHNjZW5hcmlv
IGlzIHVubGlrZWx5LCBpdCBtaWdodCBiZSBnb29kIGlmIHdlDQo+PiBqdXN0IGdvIGFsbCB0aGUg
d2F5IGJhY2sgd2l0aCB0aGlzIHJlZ3Jlc3Npb24gZml4Pw0KPiANCj4gV2hhdCBkbyB5b3UgbWVh
biB3aXRoICJhbGwgdGhlIHdheSBiYWNrIj8NCg0KT2gsIGFwb2xvZ2llcyBmb3Igbm90IHVzaW5n
IHVuYW1iaWdpb3VzIHBocmFzaW5nLg0KDQpJIG1lYW4sIGl0IHNlZW1zIHRoZSBhdXRvc2VsZWN0
aW9uIG9ubHkgZm91bmQgOTJlMjIyZGY3YiBpbiBwbGFjZXMgd2hlcmUNCml0J3MgYWN0dWFsbHkg
Y2FsbGVkIDkyZTIyMmRmN2IsIGFuZCBub3Qgd2hlcmUgaXQgd2FzIGNoZXJyeS1waWNrZWQuDQoN
ClNvLCBmb3IgbXkgb3duIHVuZGVyc3RhbmRpbmc6IElmIEkgaGF2ZSB0byBkbyBzb21ldGhpbmcg
bGlrZSB0aGlzIGV2ZXINCmFnYWluLCB0aGVuIHNob3VsZCBJIGhhdmUgYWRkZWQgaXQgbGlrZSB0
aGlzIGluc2lkZSBiYWY5MjExNGM/DQoNCkZpeGVzOiA5MmUyMjJkZjdiICgiYnRyZnM6IGFsbG9j
X2NodW5rOiBmaXggRFVQIHN0cmlwZSBzaXplIGhhbmRsaW5nIikNCkZpeGVzOiAwMTM2YmQ3MjM4
ICgiYnRyZnM6IGFsbG9jX2NodW5rOiBmaXggRFVQIHN0cmlwZSBzaXplIGhhbmRsaW5nIikNCkZp
eGVzOiA4ODkwYmFlMDNmICgiYnRyZnM6IGFsbG9jX2NodW5rOiBmaXggRFVQIHN0cmlwZSBzaXpl
IGhhbmRsaW5nIikNCkZpeGVzOiA5N2MzZTQ2ZWY1ICgiYnRyZnM6IGFsbG9jX2NodW5rOiBmaXgg
RFVQIHN0cmlwZSBzaXplIGhhbmRsaW5nIikNCkZpeGVzOiBmNjhmNDYyODRhICgiYnRyZnM6IGFs
bG9jX2NodW5rOiBmaXggRFVQIHN0cmlwZSBzaXplIGhhbmRsaW5nIikNCg0KVGhhbmtzIGZvciB5
b3VyIHBhdGllbmNlLCA6KQ0KDQotLSANCkhhbnMgdmFuIEtyYW5lbmJ1cmcNCg==
