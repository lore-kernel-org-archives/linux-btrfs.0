From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH] Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Tue, 14 Dec 2010 10:44:38 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB68594D0883B@shsmsx502.ccr.corp.intel.com>
References: <1291708775-4484-1-git-send-email-xin.zhong@intel.com>
 <20101207165433.GA976@infradead.org>
 <1865303E0DED764181A9D882DEF65FB68594D08540@shsmsx502.ccr.corp.intel.com>
 <1292290527-sup-3126@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: Christoph Hellwig <hch@infradead.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292290527-sup-3126@think>
List-ID: <linux-btrfs.vger.kernel.org>

Q2hyaXMsIHRoYW5rcyBhIGxvdCBmb3IgeW91ciBxdWljayByZXNwb25zZS4NCg0KVGhhbmtzIHRv
IFpoZW5nIFlhbiB0b28gZm9yIGhpcyBjYXJlZnVsIHJldmlldy4NCg0KLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCkZyb206IENocmlzIE1hc29uIFttYWlsdG86Y2hyaXMubWFzb25Ab3JhY2xl
LmNvbV0gDQpTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxNCwgMjAxMCA5OjM2IEFNDQpUbzogWmhv
bmcsIFhpbg0KQ2M6IENocmlzdG9waCBIZWxsd2lnOyBsaW51eC1idHJmc0B2Z2VyLmtlcm5lbC5v
cmcNClN1YmplY3Q6IFJFOiBbUEFUQ0hdIEJ0cmZzOiBwd3JpdGUgYmxvY2tlZCB3aGVuIHdyaXRp
bmcgZnJvbSB0aGUgbW1hcGVkIGJ1ZmZlciBvZiB0aGUgc2FtZSBwYWdlDQoNCkV4Y2VycHRzIGZy
b20gWmhvbmcsIFhpbidzIG1lc3NhZ2Ugb2YgMjAxMC0xMi0xMyAwMzoyNjowNCAtMDUwMDoNCj4g
SSBoYXZlIHNlbnQgbXkgdGVzdCBjYXNlIHRvIHhmcyBtYWlsaW5nIGxpc3QgKE5vLiAyNDgpLiAN
Cj4gUGxlYXNlIGhlbHAgdG8gcmV2aWV3IGl0LiBUaGFua3MhDQoNCllvdSBidHJmcyBwYXRjaCBp
cyBub3cgaW4gdGhlIG1hc3RlciBicmFuY2ggb2YgdGhlIGJ0cmZzIHVuc3RhYmxlIHRyZWUuDQpU
aGFua3MhDQoNCi1jaHJpcw0K
