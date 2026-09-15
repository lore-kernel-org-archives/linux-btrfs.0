Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454B345C6EA;
	Tue, 15 Sep 2026 07:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458909; cv=none; b=EuW3pZyUEL8m6YD+t7/HNpQMPGsdhdE/K7zX0WVY2hyRREt36aS2HCU7hQ4ZaJjMT1WCqJyBC/zNYoS9a1P4KhbLgHSFQfZIzgIZahckBReYB6uAEFkwoibYHb4CPocyiw88qevvfC13rkg26m5/++MyIW55RXEYX6AJeo83URc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458909; c=relaxed/simple;
	bh=G48mGUEJR7leGAKi03i2dA2zjKMW6IanxumXW2D9mO4=;
	h=Date:From:To:Cc:Subject:Content-Type:MIME-Version:Message-ID; b=BeSryDUvBcUHgG7CrAA8xMhrFwFS8S3jXJjHPelfxDCO4H9dR1pWfdHIpP/p+yL4TiZ2M1lyTRehCzSEAMwZhs7qVQ2bBpG2IWRYSaZ4SaEaY2IVSsCH5qYH9/WcOoVBgsDjpFOCeqA8NN9WBRBHp0A2hkAc/Hp55ZDHTRpOifA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bR8yp8du; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bR8yp8du"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=G48mGUEJR7leGAKi03i2dA2zjKMW6IanxumXW2D9mO4=; b=b
	R8yp8dusN/ryiSh7tanWo6eqBX/hyt/Le/gkBF1v0bvJaX/10LmlReEhJ/MZDpG2
	+U4xdZRKO01F3ZZAnmzp/2gV8R7enWa4X4YIzDsYM08fIOuQ9uExV8YMJwecobvO
	daA1rQ4w3qx7xzE6Nf16pXkwCanyjZAtwqbL0H2NCk=
Date: Tue, 15 Sep 2026 15:54:50 +0800 (CST)
From: CJ <firefly0158@163.com>
To: clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] btrfs: WARNING in btrfs_create_pending_block_groups
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
X-NTES-SC: AL_Qu2TC/iet0Ai5iiebekdmEsTju82UcS4ufQl245Xc98Figbk+QAgeFpPNFDG1NiRKyuJkh+TdQFs6cJxc45/HfA3iZpcE6O8rjHThBpnGA==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <4ac537fb.6f6b.1a0a40fc080.Coremail.firefly0158@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:hygvCgD3H7PK+ahq7w4QAA--.21722W
X-CM-SenderInfo: piluvw1o1qikqy6rljoofrz/xtbC3gp1J2qo+crtywAA3R
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkhpLAoKCkkgYW0gcmVwb3J0aW5nIGEgV0FSTklORyB3aGlsZSBidHJmcyBjcmVhdGVzIHBlbmRp
bmcgYmxvY2sgZ3JvdXBzLCB0cmlnZ2VyZWQgYnkKYSBzeXprYWxsZXIgcmVwcm9kdWNlciB0aGF0
IG1vdW50cyBhIGNyYWZ0ZWQgYnRyZnMgaW1hZ2UuICBUaGUgaXNzdWUgaXMKcmVwcm9kdWNpYmxl
IHdpdGggSEVBRCBjb21taXQgY2VlOTM5NWFjZDgwNDNiZTA2NDRiMjVjMzRiZmE4NjYyM2YyYjkz
NQoodjcuMy1yYzEsIExpbnV4IDcuMy4wLXJjMSkuCgoKVGhlIHJlcHJvZHVjZXIgbW91bnRzIGEg
Y3JhZnRlZCBidHJmcyBmaWxlc3lzdGVtIGltYWdlIG9uIGEgbG9vcCBkZXZpY2Ugd2l0aCB0aGUK
ZnJlZSBzcGFjZSB0cmVlIGVuYWJsZWQsIGFuZCB0aGVuIHN0YXJ0cyBhIGJhbGFuY2Ugd2l0aCB1
c2FnZSBsaW1pdHMuICBUaGUKY29uc29sZSBzaG93cyB0aGUgbW91bnQgYW5kIHRoZSBiYWxhbmNl
IHN0YXJ0IHN1Y2NlZWRpbmcgYmVmb3JlIHRoZSB3YXJuaW5nLgoKClRoZSBjb25zb2xlIHNob3dz
IGEgV0FSTklORyBhdCBmcy9idHJmcy9ibG9jay1ncm91cC5jOjI5NDQgd2l0aCBSSVAgaW4KYnRy
ZnNfY3JlYXRlX3BlbmRpbmdfYmxvY2tfZ3JvdXBzLCByZWFjaGVkIGZyb20gdGhlIHRyYW5zYWN0
aW9uIGNvbW1pdCBwYXRoIHdoaWxlCnRoZSBiYWxhbmNlIGlzIHR1cm5pbmcgdGhlIGJsb2NrIGdy
b3VwIHJlYWQtb25seS4gIEluIHRoZSBvcmlnaW5hbCByZXBvcnQgdGhlCnNhbWUgd2FybmluZyB3
YXMgcmVjb3JkZWQgYXQgZnMvYnRyZnMvYmxvY2stZ3JvdXAuYzoyNDQxIGluIHRoZSBzYW1lIGZ1
bmN0aW9uLCBzbwpvbmx5IHRoZSBzb3VyY2UgbGluZSBoYXMgbW92ZWQuCgoKT25lIHBvc3NpYmxl
IGNhdXNlIGlzIHRoYXQgdGhlIGJsb2NrIGdyb3VwIGNyZWF0ZWQgZnJvbSB0aGUgY3JhZnRlZCBp
bWFnZSBkb2VzCm5vdCBzYXRpc2Z5IHRoZSBhc3N1bXB0aW9uIGJ0cmZzX2NyZWF0ZV9wZW5kaW5n
X2Jsb2NrX2dyb3VwcyBtYWtlcyBhYm91dCB0aGUKYmxvY2sgZ3JvdXAncyB0eXBlIG9yIHJlc2Vy
dmF0aW9uIHN0YXRlIHdoZW4gaXQgaXMgY29tbWl0dGVkLCBzbyB0aGUgaW52YXJpYW50CmNoZWNr
IGZpcmVzLiAgVGhpcyBsb29rcyBsaWtlIGEgdmFsaWRhdGlvbiBnYXAgZm9yIGRpc2stZGVyaXZl
ZCBibG9jayBncm91cApzdGF0ZSByYXRoZXIgdGhhbiBhIHRyYW5zYWN0aW9uIHByb2JsZW0uICBJ
IG5vdGUgdGhhdCA4YmM0ZDcyMDk2MTEgYW5kCmU1NDkwOTNjMTFhMiB0b3VjaGVkIHRoZSBibG9j
ayBncm91cCByZXNlcnZhdGlvbiBwYXRoIGJ1dCBub3QgdGhpcyBjaGVjay4gIEkgYW0KcmVwb3J0
aW5nIHRoZSB3YXJuaW5nIGFuZCB0aGUgcGF0aCBhcyBvYnNlcnZlZC4KCgpUaGlzIGFwcGVhcnMg
dG8gYmUgYSByZWN1cnJlbmNlIG9mIHRoZSBzeXpib3QgaXNzdWUgd2hvc2UgZXh0ZXJuYWwgaWQg
aXMKZWNlZjEwOWExNTdlNzBjMDZlMjUuICBJdCByZW1haW5zIHJlcHJvZHVjaWJsZSBvbiB2Ny4z
LXJjMS4KCgpSZXByb2R1Y2VyOgoKCnN5eiByZXByb2R1Y2VyOiBodHRwczovL3Bhc3RlYmluLmNv
bS9yYXcvdTJRNGZuakIKCmNvbnNvbGUgb3V0cHV0OiAgaHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3
L3h0eWZ3MmJtCgprZXJuZWwgY29uZmlnOiBodHRwczovL3Bhc3RlYmluLmNvbS9yYXcvTkhhdnB5
NlIKCgpLZXJuZWw6CgoKSEVBRCBjb21taXQ6IGNlZTkzOTVhY2Q4MDQzYmUwNjQ0YjI1YzM0YmZh
ODY2MjNmMmI5MzUKZ2l0IHRyZWU6IHVwc3RyZWFtIChsaW51eC5naXQpLCB0ZXN0ZWQgdGhyb3Vn
aCB0aGUgdjcuMy1yYzEgYW5ub3RhdGVkIHRhZyBvYmplY3QKwqAgwqAgwqAgwqAgwqAgwqBlNWUw
NDcyNmNkZDA0M2UzMDk2NzcwNzFhYjFiNjVhNGIxOGY0MjJiCmtlcm5lbCB2ZXJzaW9uOiA3LjMu
MC1yYzEgIzEgUFJFRU1QVChmdWxsKQp0ZXN0ZWQgdGFnOiB2Ny4zLXJjMSAoTGludXggNy4zLXJj
MSwgMjAyNi0wOC0zMCkKCgpMZXQgbWUga25vdyBpZiB5b3UgbmVlZCBtb3JlIGRldGFpbHMgb3Ig
dGVzdGluZy4KCgpCZXN0IHJlZ2FyZHMsCkNoYW5namlhbgoKCgo=
