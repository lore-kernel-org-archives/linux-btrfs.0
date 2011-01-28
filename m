From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Fri, 28 Jan 2011 11:53:24 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB685DF762B45@shsmsx502.ccr.corp.intel.com>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com>
 <1296166345.11397.16.camel@mainframe>
 <1865303E0DED764181A9D882DEF65FB685DF7629F2@shsmsx502.ccr.corp.intel.com>
 <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: =?utf-8?B?TWFyaWEgV2lrc3Ryw7Zt?= <maria@ponstudios.se>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Q291bGQgeW91IGRlc2NyaWJlIHRoZSBzdGVwcyB0byByZWNyZWF0ZSBpdD8gDQpJdCB3aWxsIGJl
IGEgZ3JlYXQgaGVscCBmb3IgbWUgdG8gbG9vayBmdXJ0aGVyLiBUaGFua3MhDQoNCi0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKb2hhbm5lcyBIaXJ0ZSBbbWFpbHRvOmpvaGFubmVz
LmhpcnRlQGZlbS50dS1pbG1lbmF1LmRlXSANClNlbnQ6IEZyaWRheSwgSmFudWFyeSAyOCwgMjAx
MSAxMDo1NSBBTQ0KVG86IFpob25nLCBYaW4NCkNjOiBNYXJpYSBXaWtzdHLDtm07IGxpbnV4LWJ0
cmZzQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtQQVRDSCB2Ml1CdHJmczogcHdyaXRl
IGJsb2NrZWQgd2hlbiB3cml0aW5nIGZyb20gdGhlIG1tYXBlZCBidWZmZXIgb2YgdGhlIHNhbWUg
cGFnZQ0KDQpPbiBGcmlkYXkgMjggSmFudWFyeSAyMDExIDAyOjI2OjQzIFpob25nLCBYaW4gd3Jv
dGU6DQo+IFBsZWFzZSB0cnkgdGhlIGZpeCBpbiBiZWxvdyBsaW5rOg0KPiBodHRwOi8vd3d3LnNw
aW5pY3MubmV0L2xpc3RzL2xpbnV4LWJ0cmZzL21zZzA4MDUxLmh0bWwNCj4gDQo+IFRoYW5rcyEN
Cg0KVGhpcyBkb2Vzbid0IGZpeCBpdCBmb3IgbWUuIEF0IGxlYXN0IHRoZXJlIGlzIGEgZGlmZmVy
ZW5jZS4gV2hlcmVhcyB0aGUgc3ZuIA0KcHJvY2VzcyBzdGFydGVkIGNvbnN1bWluZyAxMDAlIENQ
VSB3aXRob3V0IGFueSBmdXJ0aGVyIGludGVyYWN0aW9uIGJlZm9yZSwgdGhlIA0Kc3lzdGVtIGp1
c3QgaGFuZyBub3cuIFRoZSBzdm4gcHJvY2VzcyBzdGFydHMgZWF0aW5nIHRoZSBDUFUgd2hlbiBJ
IGNhbmNlbCB0aGUgDQplbWVyZ2UgdmlhIGN0cmwtYy4gQWRkaXRpb25hbCBJIHNlZSBhIGZsdXNo
LWJ0cmZzIHRhc2sgbm93IGNvbnN1bWluZyBDUFUgdGltZS4NCg0KcmVnYXJkcywNCiAgSm9oYW5u
ZXMNCg==
