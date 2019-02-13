Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804EFC282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 14:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 323CA222B2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 14:33:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="ax2U6G1Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389296AbfBMOdF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:33:05 -0500
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:2992
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732843AbfBMOdE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 09:33:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyT5jMecNGUsHYwNfH5ZqUxnczEEHUV75CcW+GOllW4=;
 b=ax2U6G1ZQRUq1rHgujdr/Uo6IZsg6K0ZIVyIjzDjWfSTo2S+npS08yeNK/RwGMXQvDMJTwAj9GYzODvfad9+fwiXm8yVkpRkgFqkq+3dABba+jqzTdTX5jX5aNC+Tfn2H91wGtiN8ubHgwHWTsgM0gIAu7O6Pt+U4TH4ACAbxGw=
Received: from DB7PR06MB5177.eurprd06.prod.outlook.com (20.178.44.15) by
 DB7PR06MB5547.eurprd06.prod.outlook.com (20.178.104.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Wed, 13 Feb 2019 14:32:59 +0000
Received: from DB7PR06MB5177.eurprd06.prod.outlook.com
 ([fe80::6855:ccee:d387:58eb]) by DB7PR06MB5177.eurprd06.prod.outlook.com
 ([fe80::6855:ccee:d387:58eb%5]) with mapi id 15.20.1601.023; Wed, 13 Feb 2019
 14:32:59 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
CC:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Liu Bo <obuil.liubo@gmail.com>
Subject: Re: [PATCH] btrfs: ensure that a DUP block group has exactly two
 stripes
Thread-Topic: [PATCH] btrfs: ensure that a DUP block group has exactly two
 stripes
Thread-Index: AQHUw6gZqnPJlYBhsEOwuBwDjZ5cqaXdyrcA
Date:   Wed, 13 Feb 2019 14:32:59 +0000
Message-ID: <cbc103a1-3558-fac1-a45b-dcaf5d4d72ea@mendix.com>
References: <20190213142602.20436-1-jthumshirn@suse.de>
In-Reply-To: <20190213142602.20436-1-jthumshirn@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
x-originating-ip: [85.146.242.35]
x-clientproxiedby: AM5P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:206:15::17) To DB7PR06MB5177.eurprd06.prod.outlook.com
 (2603:10a6:10:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 412d3bd8-97a1-47e6-12ad-08d691c026f5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:DB7PR06MB5547;
x-ms-traffictypediagnostic: DB7PR06MB5547:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtEQjdQUjA2TUI1NTQ3OzIzOm9SQW1KRmZXbDhQN3BZTTV3UVd2dkNJMjNW?=
 =?utf-8?B?WDM0Y3J0bWIwNlZtUFcweDdTS3RzRU9oMnNpSTQ2eGMyOFZpMkpjcGhPbVpq?=
 =?utf-8?B?bGgzb3hoWG1rckorbEhkaVk4K0FXaTllVWtlaFBBM1I1SnpVVE0yQU1vT3Nx?=
 =?utf-8?B?aXArYlpOcWVTd2hTVzNVeFJNU2pPeWRqU0psVmhKSE9HY2VoMjRzNHljcmVv?=
 =?utf-8?B?TFNjZ2xIWmdHeUVTTFFkR3VpNUg4ZkNsZ2xjbC96RHBtenpYWFVJUDBxcC90?=
 =?utf-8?B?VStSQk1nRW1sbzVZRTNxMCtpYWpUZmZtaVNMUmdobmh0eExrMDJFMFdsdVNa?=
 =?utf-8?B?ZUhmeHBtQk9MKzJlVERTM1BNNWxKT01xbkk0bTZoMzJyTDVneVZNQ3plVEF5?=
 =?utf-8?B?MlZPbmpveXloNC9YVWFraGJtOFgwTHN0Y1djcWd2ZmdGcXVFRjRvdHI1Qkdo?=
 =?utf-8?B?aWhHMG5JT1Q3NEo5eHNiQ2EyWVo5QnNwQjRSQ2Y0Y3RhY2QzVUZmUXY3VndG?=
 =?utf-8?B?WkJjSEhaOEFhSThxa1A5dUtJRVdTMDlYUlIwOE1mZ216UWhyTkQ0cTc0TDVI?=
 =?utf-8?B?QjRIZzlzNHFzWStXMVJhRitEK3Z4YVZWc0hJbUJMY1RiQVlPdnh1NFdBM2hh?=
 =?utf-8?B?bTB4RTlPbm5JZGxRcU5uQ1phdlY2a1BHRCs2bEZjTit0Rkw0RGhFd3JUTXFw?=
 =?utf-8?B?ZHZCaTdkRHBxd1IzcDZ0djVZaldFbU14VDBYYnB5SmdyZWhBMG5mQlpTcHRJ?=
 =?utf-8?B?YTZCM2Uyc05XR0ZOdFNpNnRXdk5ZYnlPSjNpeUtYVHVTalp3VWtQLzJ5bGFF?=
 =?utf-8?B?MFU4cC8ySHZWbDdMb1BXWlA0ME1VbnZWTCtvOFo0NW5kRk5PY2pqNXZ5dGYy?=
 =?utf-8?B?c3RYWndPc20wQjgzR0g1UWRqd0R6aXR1Y3g5SGQ2T01nN0QvV2t4NkNjdHFK?=
 =?utf-8?B?TCtpUVdERGFENmxkcGJxV2praGtPWkdkVGZNTkhlUEtrR0ltVWdQaUZTSHF2?=
 =?utf-8?B?Z214L1hiK0oxMmFRVjNQWlFlcDRORjlzQWc1K0NjRFFTVUg5Q1JpZVMxYnJp?=
 =?utf-8?B?ZHhsMXZrYkcyUWZmRXVQc1ZFeC9ydGp2MG8rMTZMYWdNNTFDMzlOU2N2NkV6?=
 =?utf-8?B?d1h1d295ei9hK0pPdGFzZ1h5aGI4dGcyZFY4NGgxYUlHUHc2N0Uwb2ZwQWVk?=
 =?utf-8?B?Q0VnY1VEbmhUT3p6ZE83SXNKL1l1anpzM2dwTDRqdVJ5dFpNanliZ1BkY1N2?=
 =?utf-8?B?VzdLd01JRGQ0cGNTZlg3U1lmQ0JUYm9JU0QzZkJUYXJmKy94R0pwc0M1WVlW?=
 =?utf-8?B?MnJsSHU3NEljSFU3bFRXR2picXpJQXZGYUNsdDF1bEV1SzV4L2ROQjV0WmVh?=
 =?utf-8?B?b1pSQU56Y0txbXNLWHFDcTlFcXNXMjdVTzFVTTJvMW1sR3ErYk9qUEJuYjJm?=
 =?utf-8?B?QXI0VitUOCtWeGh2ZnhWM2hackVwQjlGOEhUTmZlR0dSWXZLalo4VXJ1VXpi?=
 =?utf-8?B?aXJ1Qjlnd1hMVHdHN2NuWTRkTUNTcFMxQXNSWmFubFZZMmNDWHd2V1hCT2Ir?=
 =?utf-8?B?eWJVMGpRSmpHQzd4eUZEbkl1endjYXBSNldkTUYza3Q0bUoyNkNLOU1WVG9T?=
 =?utf-8?B?cDhBVlNudE5adVZhUEFVSk53M1FBOGYvV2JHeXVCYkFCWUx1MjhyK0NjTFox?=
 =?utf-8?B?M1ZVTTFUZ0J6ak5QdnhPMlJHWG9WQjQ0K21PY2w2czFyMkttZ2EvVnU5WjRz?=
 =?utf-8?B?MnZBYU1YeUpsTHo2M01rc1BEeTVoNmdQb1JmblJ2VnFkOW8yK0ErS3FzNjg3?=
 =?utf-8?B?NWRvTGVJMVdpNTVDb21LN25GMWU3UDJoWHA2UTF0VUs5blM2bDRST2hoakUy?=
 =?utf-8?Q?nh8eqxK2gzzS1XW70uGU52bUB5KP6WnO?=
x-microsoft-antispam-prvs: <DB7PR06MB5547A5591BC2FC1A4B5068B3D4660@DB7PR06MB5547.eurprd06.prod.outlook.com>
x-forefront-prvs: 094700CA91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(189003)(199004)(186003)(305945005)(256004)(14444005)(36756003)(6486002)(478600001)(72206003)(2906002)(65806001)(68736007)(8936002)(7736002)(65956001)(26005)(65826007)(66066001)(102836004)(86362001)(97736004)(11346002)(81166006)(81156014)(106356001)(316002)(76176011)(2616005)(14454004)(25786009)(6116002)(71200400001)(476003)(6506007)(386003)(105586002)(54906003)(6512007)(71190400001)(53546011)(446003)(31696002)(31686004)(6246003)(110136005)(229853002)(6436002)(64126003)(99286004)(4326008)(58126008)(53936002)(8676002)(3846002)(486006)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB5547;H:DB7PR06MB5177.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jT9yHLMLB5PUUUhtvC4a8z7v0BwXaPvnpXMhi5UIMpfv/mV8Z7X+ybcbg7R99cA7qxDGmmOJOInt+OPVxZi0yDRBIhPlFAPZ9soqhzaoeYyWwwmIt4TPZlnVlRMTsSHM1xFd8BuJxAj+/KfsUmkqZ+atZpm4d1iioUJujoLggKMosYY1dZh1vA1d4cV7d8r3cSFWKIdL8M4pJPE2sA41iABvDRKYXgrUJ9wYU8Bd6FD4wHEhkwStU4Z6J3nQx0HV81AxgJ7+B5hSilyZtDCLDzSwyZQgFqZZvPpERYN6dIvS1owUJIwIdmaIMddeT5Ke6qc7NV9vmUB1f1JeodiKV8bGmgfdrBo+XbZtiYRJDdvutiGYf+gTaWk7kwAezf1KTRUu5n1TV7/+jJKBbCxeZnn2jBsr3llgw9oi6+ZVMwU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C377257DD4A735419E3B11349F0905CA@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412d3bd8-97a1-47e6-12ad-08d691c026f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2019 14:32:59.1266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB5547
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMi8xMy8xOSAzOjI2IFBNLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6DQo+IFdlIHJlY2Vu
dGx5IGhhZCBhIGN1c3RvbWVyIGlzc3VlIHdpdGggYSBjb3JydXB0ZWQgZmlsZXN5c3RlbS4gV2hl
biB0cnlpbmcNCj4gdG8gbW91bnQgdGhpcyBpbWFnZSBidHJmcyBwYW5pY2tlZCB3aXRoIGEgZGl2
aXNpb24gYnkgemVybyBpbg0KPiBjYWxjX3N0cmlwZV9sZW5ndGgoKS4NCj4gDQo+IFRoZSBjb3Jy
dXB0IGNodW5rIGhhZCBhICdudW1fc3RyaXBlcycgdmFsdWUgb2YgMS4gY2FsY19zdHJpcGVfbGVu
Z3RoKCkNCj4gdGFrZXMgdGhpcyB2YWx1ZSBhbmQgZGl2aWRlcyBpdCBieSB0aGUgbnVtYmVyIG9m
IGNvcGllcyB0aGUgUkFJRCBwcm9maWxlIGlzDQo+IGV4cGVjdGVkIHRvIGhhdmUgdG8gY2FsY3Vs
YXRlIHRoZSBhbW91bnQgb2YgZGF0YSBzdHJpcGVzLiBBcyBhIERVUCBwcm9maWxlDQo+IGlzIGV4
cGVjdGVkIHRvIGhhdmUgMiBjb3BpZXMgdGhpcyBkaXZpc2lvbiByZXN1bHRlZCBpbiAxLzIgPSAw
LiBMYXRlciB0aGVuDQo+IHRoZSAnZGF0YV9zdHJpcGVzJyB2YXJpYWJsZSBpcyB1c2VkIGFzIGEg
ZGl2aXNvciBpbiB0aGUgc3RyaXBlIGxlbmd0aA0KPiBjYWxjdWxhdGlvbiB3aGljaCByZXN1bHRz
IGluIGEgZGl2aXNpb24gYnkgMCBhbmQgdGh1cyBhIGtlcm5lbCBwYW5pYy4NCj4gDQo+IFdoZW4g
ZW5jb3VudGVyaW5nIGEgZmlsZXN5c3RlbSB3aXRoIGEgRFVQIGJsb2NrIGdyb3VwIGFuZCBhICdu
dW1fc3RyaXBlcycNCj4gdmFsdWUgdW5lcXVhbCB0byAyLCByZWZ1c2UgbW91bnRpbmcgYXMgdGhl
IGltYWdlIGlzIGNvcnJ1cHRlZCBhbmQgd2lsbCBsZWFkDQo+IHRvIHVuZXhwZWN0ZWQgYmVoYXZp
b3VyLg0KPiANCj4gRml4ZXM6IGUwNmNkM2RkN2NlYSAoIkJ0cmZzOiBhZGQgdmFsaWRhZHRpb24g
Y2hlY2tzIGZvciBjaHVuayBsb2FkaW5nIikNCj4gQ2M6IExpdSBCbyA8b2J1aWwubGl1Ym9AZ21h
aWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGp0aHVtc2hpcm5A
c3VzZS5kZT4NCj4gLS0tDQo+ICBmcy9idHJmcy92b2x1bWVzLmMgfCAyICstDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9mcy9idHJmcy92b2x1bWVzLmMgYi9mcy9idHJmcy92b2x1bWVzLmMNCj4gaW5kZXggMDNmMjIz
YWE3MTk0Li5iNDBjYzdjODMwZjQgMTAwNjQ0DQo+IC0tLSBhL2ZzL2J0cmZzL3ZvbHVtZXMuYw0K
PiArKysgYi9mcy9idHJmcy92b2x1bWVzLmMNCj4gQEAgLTY3OTQsNyArNjc5NCw3IEBAIHN0YXRp
YyBpbnQgYnRyZnNfY2hlY2tfY2h1bmtfdmFsaWQoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2lu
Zm8sDQo+ICAJICAgICh0eXBlICYgQlRSRlNfQkxPQ0tfR1JPVVBfUkFJRDEgJiYgbnVtX3N0cmlw
ZXMgPCAxKSB8fA0KPiAgCSAgICAodHlwZSAmIEJUUkZTX0JMT0NLX0dST1VQX1JBSUQ1ICYmIG51
bV9zdHJpcGVzIDwgMikgfHwNCj4gIAkgICAgKHR5cGUgJiBCVFJGU19CTE9DS19HUk9VUF9SQUlE
NiAmJiBudW1fc3RyaXBlcyA8IDMpIHx8DQo+IC0JICAgICh0eXBlICYgQlRSRlNfQkxPQ0tfR1JP
VVBfRFVQICYmIG51bV9zdHJpcGVzID4gMikgfHwNCj4gKwkgICAgKHR5cGUgJiBCVFJGU19CTE9D
S19HUk9VUF9EVVAgJiYgbnVtX3N0cmlwZXMgIT0gMikgfHwNCj4gIAkgICAgKCh0eXBlICYgQlRS
RlNfQkxPQ0tfR1JPVVBfUFJPRklMRV9NQVNLKSA9PSAwICYmDQo+ICAJICAgICBudW1fc3RyaXBl
cyAhPSAxKSkgew0KPiAgCQlidHJmc19lcnIoZnNfaW5mbywNCj4gDQoNCkl0IGxvb2tzIGxpa2Ug
dGhlIFJBSUQxIGNoZWNrIGhhcyBhIHNpbWlsYXIgcHJvYmxlbS4gU2hvdWxkbid0IHRoYXQNCmNo
ZWNrIGFsc28gYmUgIT0gMiA/DQoNCkhhbnMNCg==
