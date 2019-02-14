Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A96C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 17:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D6321928
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 17:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="gs7i6vMw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395181AbfBNR2N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:28:13 -0500
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:51008
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391441AbfBNR2M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 12:28:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPHxCO+puvwxozRnoTUmjyeIN3OWJas57g2DP2gUL0k=;
 b=gs7i6vMwMlySectF1e4cs9y1DmLCB6OG7W4l9XcLuK4URAipZVhBnB+rrfFdmzF0HpYIx1S8snpQIeqo9P3VOcVih9nHIesh1bgDB3LvIfN++KdIIVyZkk61+/gcnNaA2Zn9jFzJ36mESDlmW/R9Z6kMgPRn/ArTafhPqszjq8E=
Received: from DB7PR06MB5177.eurprd06.prod.outlook.com (20.178.44.15) by
 DB7PR06MB5573.eurprd06.prod.outlook.com (20.177.193.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.18; Thu, 14 Feb 2019 17:27:28 +0000
Received: from DB7PR06MB5177.eurprd06.prod.outlook.com
 ([fe80::6855:ccee:d387:58eb]) by DB7PR06MB5177.eurprd06.prod.outlook.com
 ([fe80::6855:ccee:d387:58eb%5]) with mapi id 15.20.1601.023; Thu, 14 Feb 2019
 17:27:28 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
CC:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Liu Bo <obuil.liubo@gmail.com>
Subject: Re: [PATCH] btrfs: ensure that a DUP block group has exactly two
 stripes
Thread-Topic: [PATCH] btrfs: ensure that a DUP block group has exactly two
 stripes
Thread-Index: AQHUw6gZqnPJlYBhsEOwuBwDjZ5cqaXdyrcAgAABTICAAcHJgA==
Date:   Thu, 14 Feb 2019 17:27:28 +0000
Message-ID: <c4b193c5-d95c-fc00-f75e-fab8fa385440@mendix.com>
References: <20190213142602.20436-1-jthumshirn@suse.de>
 <cbc103a1-3558-fac1-a45b-dcaf5d4d72ea@mendix.com>
 <74e12497-9d05-43c7-f2bb-213710cfbc85@suse.de>
In-Reply-To: <74e12497-9d05-43c7-f2bb-213710cfbc85@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
x-originating-ip: [85.146.242.35]
x-clientproxiedby: AM6P194CA0099.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::40) To DB7PR06MB5177.eurprd06.prod.outlook.com
 (2603:10a6:10:70::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c92e2c7-e390-4579-db16-08d692a1b162
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DB7PR06MB5573;
x-ms-traffictypediagnostic: DB7PR06MB5573:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtEQjdQUjA2TUI1NTczOzIzOmV4Wnd0RDdvQjQzS1I2UkgwTVg2YTBMT3Nz?=
 =?utf-8?B?cFhvNkxXZENUTzdVZGtxMEsvMUc3TGxsdnc5WHMwMkFTeHNwdmZrQTdkay8x?=
 =?utf-8?B?ZkREQStpdHBOSHByWUk0UWtSaEl1MWVmN1Z5M1N3YjZndWUrRTZDeE5KdEh3?=
 =?utf-8?B?WktWMTdoQ0lENjhRZmpOdGFkYVpadURGTmRVUi9Bd29lUUlnK1cwKzE4c3lW?=
 =?utf-8?B?UDhSNTZhY3hIY092YmJESzRNN09qOXhBNVZiRjBaaGkrbWk3aUhVWSs4clho?=
 =?utf-8?B?akVlSU5TNGdzWVlGSzl4eXFHMU4zcmNhd2tBalBYN0FDdkt6U2RzUnpaamN5?=
 =?utf-8?B?WUVKRzVBME9IeXlvWVIyU3BvMHhaM2gxQlllRTVneVZ1ajFBR01hU04zOCta?=
 =?utf-8?B?VVBpY1lJTzRubnNZdldRTzE2Tmk3V2lTSFhPSFRqWU1rOXhoUkF0ckF1T2Zz?=
 =?utf-8?B?QVNLUXNvQ3JFaC9xSnZseFlPOElUSlBZaTBJa24xQ0ZCUnZnbThjaEoxaU56?=
 =?utf-8?B?MWI1OWNpYmN0UFVZcitEQnRXT2JKa2w1QmI3SUxmNk1XTFpmVHdTem1hY0k3?=
 =?utf-8?B?Uldsbm9sOHppLzkxVmhhaldDTWd3b3dEaXBrcjErdy9mWSttbkNWY1Z0RHlC?=
 =?utf-8?B?bFBzUTQxa3FNTms5VWQzTTB6MEhHVjJOWWtSWkZ3S2dZRTNaRFRYa1dqYzRn?=
 =?utf-8?B?ZUE0MFBqTWxyU29xSmc1cit2RWE1VFNnK0orRDQ5VUxWVnVSTkpLTkNSYVph?=
 =?utf-8?B?RXF4QW1odVFUMFpLUDFIRGNzVE95bmRBQ0ZWU2VnOThTT1IvRVhONnN0b2g5?=
 =?utf-8?B?WmJ0SEhOam5OZnJud0hvUFpUbnZFWVJkOFRCZGFDbVpwK25PaTdsQmxLdmFZ?=
 =?utf-8?B?elhReXVJcDJhd0FReTRSQ1pGeTA2UjVJaE5qd0EwenVCN2dyZGhFUWhoNU95?=
 =?utf-8?B?WmZONHBvQ1BOL0lCOHdXOGJjSmg3bnIyUU1lRUxhRVZXenJxZ2JpMmNySjRx?=
 =?utf-8?B?Q0Znay85cFFlQWhUclZPZ0UxU1RWa3hLaEpSTldEWENxQkp5eXQ1Qmp5OUIz?=
 =?utf-8?B?azFwSlp4S1BoUWJla3JVMVRmdlFZcG1mZS8zYkVnd1lwdXYycUsvV1l3dXpI?=
 =?utf-8?B?OUxya0N4MDl5akxxZEdpWDFpQ0ZTallyUWdrNStLVVdsbXpQZ2tRZ1JtLzcr?=
 =?utf-8?B?azZZNzRjYWpCQnNIQnB3NHl1YWs5OTR2RHRNYVFzbTNRNmlRSHk1VlJjTXpi?=
 =?utf-8?B?UFhNVkd3a0p4RHlUTVBFSzYvZlc5TlhWNGZDZ2lwMUgwOFg5N1BwNXJacVJO?=
 =?utf-8?B?VkRpOWkxa3NxcmZVdklKNWUzS0hlWTdvaWVmSUxGRnBTRnRaTy90NEJkczRm?=
 =?utf-8?B?ZHhRK2Rld0cvdTdWa2NmZzczb2VXMnY0bTZoa2I5WFAxNWUzU3o5YWcyTVBx?=
 =?utf-8?B?STk2RHFiU3BLU1pwRjhLdUsxZCtNalJCbmRtd1pEdXhhbjF1VzRzU3lTUnhX?=
 =?utf-8?B?WCtBZEU3WHEwYnl2bE9wQjJtTXNmeVJLaWovRXcvcWEwUTRTUDRORk1kVVlM?=
 =?utf-8?B?ZklPUkg0N2M4SFhKaHNzUDNSejR2dXRYU2NxVHdwajBEVVF0aU82Tm9veCt3?=
 =?utf-8?B?emM0VmdnZ3JYMmppWGZMa0hRSkVLNU5sTGdTNEFkd21kTE1HTDQ5ZGc5cHBh?=
 =?utf-8?B?aDNkb2czSHYzaXVUOGNwSnhMdnQzZEZkaytSQzN4RXFvQXByWUFROUkxVkp6?=
 =?utf-8?B?U1ZJdkNSM0pYQkN2ajlpWnhNMUgvVDBzd29wdEtyU2RybVM1NG4zK3l5VlQ2?=
 =?utf-8?B?SFFnVllMVU8veEk5TUdDK1ZOemhQSzlxUlRHN1Rkc0ZZNFRtQ2psSWtwWGwv?=
 =?utf-8?Q?UI9JRvwcVGXmducHOhhJh+ofouqky3sk?=
x-microsoft-antispam-prvs: <DB7PR06MB55735F538B3AAFF7C804E6A0D4670@DB7PR06MB5573.eurprd06.prod.outlook.com>
x-forefront-prvs: 09480768F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(39850400004)(396003)(346002)(189003)(199004)(256004)(7736002)(305945005)(14454004)(31686004)(81156014)(81166006)(8676002)(54906003)(97736004)(58126008)(86362001)(110136005)(31696002)(65826007)(72206003)(316002)(478600001)(6116002)(99286004)(52116002)(3846002)(386003)(53546011)(6506007)(102836004)(186003)(6346003)(76176011)(26005)(8936002)(2906002)(6436002)(66066001)(65956001)(65806001)(64126003)(6246003)(68736007)(6486002)(36756003)(53936002)(229853002)(11346002)(476003)(4326008)(25786009)(106356001)(6512007)(486006)(2616005)(446003)(71200400001)(71190400001)(105586002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB5573;H:DB7PR06MB5177.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8NHbwvOqd3fp0o1E2PwG9t/VtYnSDmgF4xV0mCGs5L+kqY9xtkVTkmoLHN/cSWjwYYyoG1xSmwCYxR57IgH23qTFfzWhHjTEFiayBxGFNdLgf8bdGsA8Xwx9r9LvxyMUqO56PMz9Kz5VRTIQ0hsc3eMgA9+DsBdQn/xAWv4ZAQAysecHVjt/Dle+3+FrqYjGbQ6l6HXnYPLHeNM8vzME6BlFrcUWnPdNTJkcuTV9cTt7ZvTAYt0P1vzERWlj57Y/DYXUaPZxmQ6rwmjf+4ty7DiXZJip1agEddfidyWI7sp38CeJA9huF9pv5vShQGzqN5obMar43Lf6GLSncxvPv/vNn0jAvvbFvUzJGKLhFI5P8DHEV7j8o9cBDGddWgbx1sFWX/Da9co+NW3DO3gqeRA/WjjjRXZRWzNC9+UOYDQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48FF46562A48D64B96A458390106E956@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c92e2c7-e390-4579-db16-08d692a1b162
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2019 17:27:28.1428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB5573
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMi8xMy8xOSAzOjM3IFBNLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6DQo+IE9uIDEzLzAy
LzIwMTkgMTU6MzIsIEhhbnMgdmFuIEtyYW5lbmJ1cmcgd3JvdGU6DQo+IFsuLi5dDQo+IA0KPj4+
IGRpZmYgLS1naXQgYS9mcy9idHJmcy92b2x1bWVzLmMgYi9mcy9idHJmcy92b2x1bWVzLmMNCj4+
PiBpbmRleCAwM2YyMjNhYTcxOTQuLmI0MGNjN2M4MzBmNCAxMDA2NDQNCj4+PiAtLS0gYS9mcy9i
dHJmcy92b2x1bWVzLmMNCj4+PiArKysgYi9mcy9idHJmcy92b2x1bWVzLmMNCj4+PiBAQCAtNjc5
NCw3ICs2Nzk0LDcgQEAgc3RhdGljIGludCBidHJmc19jaGVja19jaHVua192YWxpZChzdHJ1Y3Qg
YnRyZnNfZnNfaW5mbyAqZnNfaW5mbywNCj4+PiAgCSAgICAodHlwZSAmIEJUUkZTX0JMT0NLX0dS
T1VQX1JBSUQxICYmIG51bV9zdHJpcGVzIDwgMSkgfHwNCj4+PiAgCSAgICAodHlwZSAmIEJUUkZT
X0JMT0NLX0dST1VQX1JBSUQ1ICYmIG51bV9zdHJpcGVzIDwgMikgfHwNCj4+PiAgCSAgICAodHlw
ZSAmIEJUUkZTX0JMT0NLX0dST1VQX1JBSUQ2ICYmIG51bV9zdHJpcGVzIDwgMykgfHwNCj4+PiAt
CSAgICAodHlwZSAmIEJUUkZTX0JMT0NLX0dST1VQX0RVUCAmJiBudW1fc3RyaXBlcyA+IDIpIHx8
DQo+Pj4gKwkgICAgKHR5cGUgJiBCVFJGU19CTE9DS19HUk9VUF9EVVAgJiYgbnVtX3N0cmlwZXMg
IT0gMikgfHwNCj4+PiAgCSAgICAoKHR5cGUgJiBCVFJGU19CTE9DS19HUk9VUF9QUk9GSUxFX01B
U0spID09IDAgJiYNCj4+PiAgCSAgICAgbnVtX3N0cmlwZXMgIT0gMSkpIHsNCj4+PiAgCQlidHJm
c19lcnIoZnNfaW5mbywNCj4+Pg0KPj4NCj4+IEl0IGxvb2tzIGxpa2UgdGhlIFJBSUQxIGNoZWNr
IGhhcyBhIHNpbWlsYXIgcHJvYmxlbS4gU2hvdWxkbid0IHRoYXQNCj4+IGNoZWNrIGFsc28gYmUg
IT0gMiA/DQo+IA0KPiBIbW0gSSBndWVzcyBhIGRlZ3JhZGVkIFJBSUQxIGNhbiBoYXZlIG9ubHkg
MSBzdHJpcGUsIGRvZXNuJ3QgaXQ/DQoNCkl0J3MgcmVhZGluZyB0aGUgbWV0YWRhdGEgZnJvbSBk
aXNrIGhlcmUuIFNvLCB0aGVyZSBhcmUgYWx3YXlzIHN0aWxsDQpleGFjdGx5IHR3byAnc3RyaXBl
JyBzdHJ1Y3RzIGluc2lkZSB0aGUgY2h1bmsgaXRlbSBkYXRhLg0KDQpIYW5zDQoNCg==
