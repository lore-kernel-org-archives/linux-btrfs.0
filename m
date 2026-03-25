Received: from mail.mailmag.net (mail.mailmag.net [199.192.20.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C912FC893
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 04:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.192.20.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774412923; cv=none; b=cKJR+T9U5Afjq1lsqU0WV5cq0gnUhMn4AevbUxFVuhp9T68oQsPVa4baHSS+ULEj7jpQFOW1L3VLKL76Fo6POvYQJ5n+gQ+nPsKaGL5+X21cFf1v0h6CCEdMYebrTWkhG4SlGgehrDv9KwG1luJbzTcF83CQn46jcdXvydG6SuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774412923; c=relaxed/simple;
	bh=nVJZYpcoOW3ul0fyHdSpV1Hf1dV1ITxbu+zJSW15kF0=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=qiFwNgODl0NbxKmHHHoK+NNaOj/5vunjS+/G90JrWj8NxlzNRS3u6MkMHyTuHC1hG9rfUOv0QAAfeyODSaMIPLAIimByjTQdLkG7q2OSE6DDfrDPd4lmDMP2/ixA3A/FkLXvwPAK8Uwlf9Ttkr03RCNwU9xDN1aG8XR4GqR2LL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mailmag.net; spf=pass smtp.mailfrom=mailmag.net; dkim=pass (2048-bit key) header.d=mailmag.net header.i=@mailmag.net header.b=euQmyLPT; arc=none smtp.client-ip=199.192.20.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mailmag.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailmag.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailmag.net header.i=@mailmag.net header.b="euQmyLPT"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPA id E780D160D0A;
	Tue, 24 Mar 2026 21:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailmag.net; s=dkim;
	t=1774412284; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=nVJZYpcoOW3ul0fyHdSpV1Hf1dV1ITxbu+zJSW15kF0=;
	b=euQmyLPTHCnz9SQJ2DPfBU1ue5UV7Sj8rpMr0Bz7r75fGTC0EDBkhwK6B5L0bUcwzvSRcc
	eFdUpozvXnCRIX5wbSJqsY4FnZqLevSZPrefPCIQ+SyLY62eA8Ilg4e0/ADxLG1QD6P/n5
	ifnXV4+nmREk/RmBgd5gtjsSFj3JNygXalYhlKKywnjv7DMErtZpEi7NYmab+RWdTq0lsr
	v2Hj4qTWSFOyv/+IM85wBe6s8Cj4+qljajYhx3S51JvVQ7F1gcBOJZ2gz+QsDr0CuU2nbX
	4gDYfU2KTPlC1TNn6LFpd6YyJLLVEvGZlyq4eztgHRgoSyKzZYD/YETwhvnVxg==
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: base64
From: joshua <joshua@mailmag.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: Btrfs progs release 6.19
Date: Tue, 24 Mar 2026 21:18:02 -0700
Message-Id: <2A0C37E0-28BD-4829-9778-AB20F4482F6D@mailmag.net>
References: <f7b7f88c6f1b94b6f09f7f54bdaa3c0ee54f60ed.camel@scientia.org>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
In-Reply-To: <f7b7f88c6f1b94b6f09f7f54bdaa3c0ee54f60ed.camel@scientia.org>
To: Christoph Anton Mitterer <calestyo@scientia.org>
X-Last-TLS-Session-Version: None

Rm9yIHdoYXQgaXTigJlzIHdvcnRoLCAobm90IG11Y2gpIEkgdXNlZCAtLWNvbnZlcnQtdG8tYmxv
Y2stZ3JvdXAtdHJlZSBvbiBhIGxhcmdlIGZzIHdpdGggcHJlY2lvdXMgZGF0YSAofjEwIGRyaXZl
cywgfjEwMFRiLCBSYWlkMSBkYXRhLCBSYWlkMUMzIG1ldGFkYXRhKSBhbmQgaGFkIG5vIGlzc3Vl
cy4NCg0KQ29udmVydCB0b29rIGEgTE9ORyB0aW1lLCBidXQgYWZ0ZXJ3YXJkcywgYWxsIG15IGRh
dGEgaW50ZWdyaXR5IGNoZWNrcyBwYXNzZWQsIHNjcnViIHBhc3NlZCwgYW5kIG1vdW50IHRpbWVz
IGFyZSBhcHByb3hpbWF0ZWx5IDEgc2Vjb25kIG5vdywgY29tcGFyZWQgdG8gbWludXRlcyBwcmV2
aW91c2x5Lg0KDQrigJRKb3NodWEgVmlsbHdvY2sNCg0KPiBPbiBNYXIgMjQsIDIwMjYsIGF0IDY6
MDDigK9QTSwgQ2hyaXN0b3BoIEFudG9uIE1pdHRlcmVyIDxjYWxlc3R5b0BzY2llbnRpYS5vcmc+
IHdyb3RlOg0KPiANCj4g77u/T24gVHVlLCAyMDI2LTAzLTE3IGF0IDE3OjM0ICswMTAwLCBEYXZp
ZCBTdGVyYmEgd3JvdGU6DQo+Pj4gSG93IGFib3V0IG1pZ3JhdGluZyBhbiBleGlzdGluZyBmcyB0
byB1c2UgdGhlIGJsb2NrLWdyb3VwLXRyZWUNCj4+PiAod2l0aA0KPj4+IGJ0cmZzdHVuZSAtLWNv
bnZlcnQtdG8tYmxvY2stZ3JvdXAtdHJlZSkuLi4gaGFzIHRoYXQgYWxzbyBiZWVuIHdlbGwNCj4+
PiB0ZXN0ZWQgYW5kIGlzIGNvbnNpZGVyZWQgc2FmZSB0byBiZSB1c2VkIG9uIGZpbGVzeXN0ZW1z
IHdpdGgNCj4+PiBwcmVjaW91cw0KPj4+IGRhdGE/DQo+PiANCj4+IFRoZSBpbi1wbGFjZSBjb252
ZXJzaW9ucyBhcmUgYSBiaXQgbW9yZSB0cmlja3kgYXMgdGhleSBzdGFydCBmcm9tIGFuDQo+PiBl
eGlzdGluZyBmaWxlc3lzdGVtIGFuZCB0aGVyZSdzIGEgcG9zc2liaWxpdHkgb2YgZmluZGluZyBz
b21lIGNvcm5lcg0KPj4gY2FzZS4gTGFzdCB0aW1lIHRoaXMgd2FzIGluIDYuMTUuDQo+IA0KPiBJ
IHNlZS4gVGhhbmtzIGZvciB0aGUgaW5mb3JtYXRpb24uDQo+IA0KPiANCj4+IEl0IHNob3VsZCBi
ZSBkb2FibGUgdG8gdGVzdCB0aGUgY29udmVyc2lvbiB1c2luZyBkZXZpY2UgbWFwcGVyDQo+PiBz
bmFwc2hvdA0KPj4gZGV2aWNlcyBvbiBhbiBleGlzdGluZyB2YWx1YWJsZSBmaWxlc3lzdGVtIHdp
dGhvdXQgZGVzdHJveWluZyBpdC4NCj4gDQo+IEJ1dCB0aGF0IHdvdWxkIG9ubHkgdGVsbCBtZSBp
ZiB0aGUgYnVnIGFjdHVhbGx5IGhhcHBlbnMgKGFuZCBpcw0KPiBub3RpY2VkKSBkdXJpbmcgY29u
dmVyc2lvbi4uLiBub3QgaWYgc29tZXRoaW5nIGlzIHNpbXBseSBzdG9yZWQgaW4gYQ0KPiB3cm9u
ZyB3YXkgd2hpY2ggSSBtYXkgbm90IG5vdGljZSB1bnRpbCBtdWNoIGxhdGVyICh3aGVuIGl0IG1p
Z2h0DQo+IGFscmVhZHkgYmUgdG9vIGxhdGUpLg0KPiANCj4gVGhhbmtzIGFueXdheSA6LSkNCj4g
Q2hyaXMuDQo+IA0K

