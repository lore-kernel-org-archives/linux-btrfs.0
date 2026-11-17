Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.111.35.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794889755;
	b=ZPrryM5b9m1u4NOpsQcn8khmHNVEYtuCIAKEBnLZuZ2S9RO17skUuiWvAzAmvtrUOIbU
	 ehpNo0dSFMykJQurqexGtja02gf2Iv0MLPxRnYi+XIQUdGOFAPwO1yO4bWhvpZxSkOVMh
	 k8ObdCGO2Ck+gqVh+DnTKd/Hmj5mviUPgCltMDf58fgKC6xgqgjQqb1diEteo5YdVLg3O
	 vdoLfEPwOwtIB2DzmejVAIy9B6+YaAkdDEAe5dy5IyNxT1p4MlM/hi4OuCIz+WMKXmgUL
	 cQo8/eN5EWit3PB4AJa7eRdZ3tGnElXOyxw2aLQsshWec5vKpmUx6dDv3wUmC25gfnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794889755;
	h=DMARC-Filter:X-Originating-IP:X-Works-Smtp-Source:Received:
	 DKIM-Signature:X-Session-ID:MIME-Version:Message-ID:Date:From:
	 Importance:To:Cc:Subject:X-Originating-IP:X-Works-Send-Opt:
	 Content-Type:Content-Transfer-Encoding;
	bh=VBKHRt+1rWWAgiBbsb4DvQCF9QJO4kV/l0okGQpWWl0=;
	b=Px+jqqXIiS8Axt/wlI0kqTmleuU48gM6i5Goj/BnaaThKYQUNAJu4jzMcHhE6AhKjRJs
	 EiIRryzAgtclh6BSwMMFb6qYWrmRSjEnwfnjgaRg4YZuxBsLfyHpVwynHT524PF5UXeQP
	 Y7aNCK2fHiebgOq7f32G1arct8ULapWCo9CsFlgPbiPAt3/F7dJUUsHdVW9jQS2uRaXp4
	 84e+2ByPwVP1gkG6ds1/DRABWjCr2GHbRw/XCQ4XNrklJJYRtOWux2dLjOtioIas7yJap
	 x3padvdwjTDKNyMkljjL+podxsWBcSZwQceK1KH5TvoV1jav33vDurbD//2Nui6//pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=naver.com;
	spf=pass smtp.mailfrom=naver.com;
	dkim=pass header.d=naver.com header.i=@naver.com header.a=rsa-sha256 header.s=s20171208 header.b="Q/sjmCuS";
	arc=none smtp.remote-ip=114.111.35.152
Received: from cvsmtppost03.nm.naver.com (cvsmtppost03.nm.naver.com [114.111.35.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754B5606A31C;
	Tue, 17 Nov 2026 04:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 754B5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=naver.com header.i=@naver.com header.a=rsa-sha256 header.s=s20171208 header.b=Q/sjmCuS
X-Works-Smtp-Source: VXK9aAtlFqJCpNmXFAKXWHF0
Received: from nv1s-hmac-real-24 ([10.180.31.91])
  by cvsmtppost03.nm.naver.com with ESMTP id KobLbu+YTG+DKyiFa5AIgg
  for <multiple recipients>;
  Tue, 17 Nov 2026 04:29:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1794889747; bh=VBKHRt+1rWWAgiBbsb4DvQCF9QJO4kV/l0okGQpWWl0=;
	h=Message-ID:Date:From:To:Subject:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=Q/sjmCuS8Gzrk+o1/qb8jsgsoHnd90TyKeYMiFdUxoN8zvGFMvw6bMy05Dkb+HIeM
	 cxLqStaaf0vmVsFHYehqV7uilB6rNUvjYQxj9ScPnn7osQ4r1fQXO/3HYaBvWayex4
	 8ar09wB47UHUOsLDlnNWLfGeqe/5h7HhOQLDmVFS2swQZT621JfTMm7D6QuPY8nsOa
	 snSWN1Jms1qQtspLUY8+6nDWfA6UnSMID341IAXSuQ4FHF42qcxjp6TezAZ5XJpIdK
	 qj2b6qgFvDYFd6qWaBO3PAH8TXpmZoGgJqYp1QZc/RQ/r0B4gMnWZZtZg+zPPlwJMJ
	 vHi4Jvgwal5Wg==
X-Session-ID: 1ec920f968e172c92b77e4e940f71ce214bfd5f279ac19e8cc5a8b28aea1f10e
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-ID: <652bf9fd6e20ef231652b95efa65355@cweb018.nm>
Date: Tue, 17 Nov 2026 13:29:06 +0900
From: =?utf-8?B?U2lldW4gWWFuZw==?= <didtldms2525@naver.com>
Importance: normal
To: <dsterba@suse.com>
Cc: <mason@kernel.org>,
	<linux-btrfs@vger.kernel.org>,
	<axboe@kernel.dk>,
	<io-uring@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?W1BBVENIXSBidHJmczogcmVqZWN0IGVuY29kZWQgcmVhZHMgZnJvbSB3cml0ZS1vbmx5IA==?=
	=?utf-8?B?ZmlsZSBkZXNjcmlwdG9ycw==?=
X-Works-Send-Opt: +9Fdpz0vjHmZFxiqW63nFBmmjA+YKxtwFA2wKqbqaBwtxBmwjAg=
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64

QlRSRlNfSU9DX0VOQ09ERURfUkVBRCBhbmQgdGhlIG1hdGNoaW5nIGlvX3VyaW5nIGNvbW1hbmQg
cmVxdWlyZQpDQVBfU1lTX0FETUlOLCBidXQgbmVpdGhlciBjaGVja3MgRk1PREVfUkVBRC4gQSBj
YWxsZXIgY2FuIHRoZXJlZm9yZQpyZWFkIGZpbGUgY29udGVudHMgdGhyb3VnaCBhbiBPX1dST05M
WSBkZXNjcmlwdG9yLCB3aGVyZWFzIHJlYWQoKSBhbmQKSU9SSU5HX09QX1JFQUQgb24gdGhhdCBk
ZXNjcmlwdG9yIHJldHVybiBFQkFERi4KClRoaXMgaXMgb2JzZXJ2YWJsZSB1bmRlciB0aHJlZSBy
ZWFkIHJlc3RyaWN0aW9ucyB3aGlsZSBDQVBfU1lTX0FETUlOCmlzIHJldGFpbmVkOgoKLSBMYW5k
bG9jayBkZW5pZXMgUkVBRF9GSUxFLiBBIG5ldyBPX1JET05MWSBvcGVuIGZhaWxzIHdpdGggRUFD
Q0VTLCBidXQKwqAgYW4gT19XUk9OTFkgb3BlbiBzdWNjZWVkcyBhZnRlciB0aGUgcmVzdHJpY3Rp
b24gaXMgaW5zdGFsbGVkLgotIERBQyBtb2RlIDAyMDAgZGVuaWVzIE9fUkRPTkxZIGFmdGVyIENB
UF9EQUNfT1ZFUlJJREUgYW5kCsKgIENBUF9EQUNfUkVBRF9TRUFSQ0ggYXJlIGRyb3BwZWQsIGJ1
dCBhbGxvd3MgT19XUk9OTFkuCi0gV2l0aCBDT05GSUdfQlRSRlNfRlNfUE9TSVhfQUNMPXksIGEg
UE9TSVggQUNMIGdyYW50cyBvbmx5IHdyaXRlIGFjY2VzcwrCoCB0byBhIG5hbWVkIHVzZXIuIFdp
dGggZnN1aWQgc2V0IHRvIHRoYXQgdXNlciBhbmQgdGhlIERBQyBieXBhc3MKwqAgY2FwYWJpbGl0
aWVzIGRyb3BwZWQsIE9fUkRPTkxZIGZhaWxzIGFuZCBPX1dST05MWSBzdWNjZWVkcy4KCk9uIExp
bnV4IDcuNC4wLXJjMy1nNjY2NTM5ZWVjZGY0LCBib3RoIGVuY29kZWQtcmVhZCBwYXRocyByZXR1
cm5lZAp0aGUgc2FtZSA4MTkyIGJ5dGVzIGZyb20gYW4gdW5jb21wcmVzc2VkIEJ0cmZzIGV4dGVu
dCBpbiBlYWNoIGNhc2UuCk5vcm1hbCByZWFkKCkgb24gdGhlIE9fV1JPTkxZIGRlc2NyaXB0b3Ig
cmV0dXJuZWQgRUJBREYuCgpDaGVjayBGTU9ERV9SRUFEIGluIGJvdGggZW50cnkgcG9pbnRzLCBt
YXRjaGluZyB0aGUgRk1PREVfV1JJVEUgY2hlY2tzCmFscmVhZHkgcHJlc2VudCBpbiB0aGUgZW5j
b2RlZC13cml0ZSBwYXRocy4gQm90aCBlbmNvZGVkIHJlYWRzIHRoZW4KcmV0dXJuIEVCQURGIGZv
ciBPX1dST05MWTsgT19SRE9OTFkgY29udHJvbHMgd2l0aCByZWFkIHBlcm1pc3Npb24gc3RpbGwK
c3VjY2VlZC4gVGhlIExhbmRsb2NrIGFuZCBEQUMgY2FzZXMgd2VyZSBhbHNvIHZlcmlmaWVkIG9u
IExpbnV4IDcuMy40LgoKRml4ZXM6IDE4ODFmYmE4OWJkNSAoImJ0cmZzOiBhZGQgQlRSRlNfSU9D
X0VOQ09ERURfUkVBRCBpb2N0bCIpCkZpeGVzOiAzNDMxMGM0NDJlMTcgKCJidHJmczogYWRkIGlv
X3VyaW5nIGNvbW1hbmQgZm9yIGVuY29kZWQgcmVhZHMgKEVOQ09ERURfUkVBRCBpb2N0bCkiKQpD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBTaWV1biBZYW5nIDxkaWR0
bGRtczI1MjVAam51LmFjLmtyPgotLS0KwqBmcy9idHJmcy9pb2N0bC5jIHwgMTAgKysrKysrKysr
KwrCoDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvYnRy
ZnMvaW9jdGwuYyBiL2ZzL2J0cmZzL2lvY3RsLmMKaW5kZXggNmJhODgzZGIxLi5mMWU0NmI0ZTYg
MTAwNjQ0Ci0tLSBhL2ZzL2J0cmZzL2lvY3RsLmMKKysrIGIvZnMvYnRyZnMvaW9jdGwuYwpAQCAt
NDM5Miw2ICs0MzkyLDExIEBAIHN0YXRpYyBpbnQgYnRyZnNfaW9jdGxfZW5jb2RlZF9yZWFkKHN0
cnVjdCBmaWxlICpmaWxlLCB2b2lkIF9fdXNlciAqYXJncCwKwqAJCWdvdG8gb3V0X2FjY3Q7CsKg
CX0KwqAKKwlpZiAoIShmaWxlLT5mX21vZGUgJiBGTU9ERV9SRUFEKSkgeworCQlyZXQgPSAtRUJB
REY7CisJCWdvdG8gb3V0X2FjY3Q7CisJfQorCsKgCWlmIChjb21wYXQpIHsKwqAjaWYgZGVmaW5l
ZChDT05GSUdfNjRCSVQpICYmIGRlZmluZWQoQ09ORklHX0NPTVBBVCkKwqAJCXN0cnVjdCBidHJm
c19pb2N0bF9lbmNvZGVkX2lvX2FyZ3NfMzIgYXJnczMyOwpAQCAtNDc3OSw2ICs0Nzg0LDExIEBA
IHN0YXRpYyBpbnQgYnRyZnNfdXJpbmdfZW5jb2RlZF9yZWFkKHN0cnVjdCBpb191cmluZ19jbWQg
KmNtZCwgdW5zaWduZWQgaW50IGlzc3VlCsKgCX0KwqAJc3FlX2FkZHIgPSB1NjRfdG9fdXNlcl9w
dHIoUkVBRF9PTkNFKGNtZC0+c3FlLT5hZGRyKSk7CsKgCisJaWYgKCEoZmlsZS0+Zl9tb2RlICYg
Rk1PREVfUkVBRCkpIHsKKwkJcmV0ID0gLUVCQURGOworCQlnb3RvIG91dF9hY2N0OworCX0KKwrC
oAlpZiAoaXNzdWVfZmxhZ3MgJiBJT19VUklOR19GX0NPTVBBVCkgewrCoCNpZiBkZWZpbmVkKENP
TkZJR182NEJJVCkgJiYgZGVmaW5lZChDT05GSUdfQ09NUEFUKQrCoAkJY29weV9lbmQgPSBvZmZz
ZXRvZmVuZChzdHJ1Y3QgYnRyZnNfaW9jdGxfZW5jb2RlZF9pb19hcmdzXzMyLCBmbGFncyk7Cgpi
YXNlLWNvbW1pdDogNjY2NTM5ZWVjZGY0ZGI2MjNmNWUzYzNlNTVjZjlmMmRmYWQyNGFhNAotLSAK
Mi4zOS41CgoK
