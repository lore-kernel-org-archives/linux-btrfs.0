Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.111.35.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890493;
	b=OA/+RHQQedT4/WUd8ucBrJVgf4BFoe+T2L6nR+rk2TZApZGx9aUDo2sfTjNnS4uhhkQA
	 kMmq0SG15C9/dVqpgHjgXz+W/IMOWvvQPOk6nnZhibc+YSluqhZMrNG7xG7j7jRtrnEPR
	 bvtXsLfssmQtO+U7k28caV/oxYgxdt7IM1FKsHZDv7oRz0f2LKIp7V0WGkYKhwWs2ki+Q
	 pdr26S8nWwvaTunAh+o6y6sp1pnz+hbeNhcY8uH/9WgHymG95+ofB/w2V0pC+h/M2DwG3
	 FfjYjdjQsZN0A8K09ibkxSafN/5AiRFR4kn1UMzFEgFcjTBmLF7cADTLo8dYt9sHtpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890493;
	h=DMARC-Filter:X-Originating-IP:X-Works-Smtp-Source:Received:
	 DKIM-Signature:X-Session-ID:MIME-Version:Message-ID:Date:From:
	 In-Reply-To:References:Importance:To:Cc:Subject:X-Originating-IP:
	 X-Works-Send-Opt:Content-Type:Content-Transfer-Encoding;
	bh=niFXUB9dLz/IyDbir8jyhTxXozRONvjAvDjzMsZJrFA=;
	b=EswXh0OR01PiDTtS6be4YJWKIzGJW1NGen4U4LJTzQq5m6Vl8gUd8tFKoYGyz67rV9nh
	 m/XOcUFM8vN+oVx+Rw5xsuAYcTFtfxvy95X4f+OgHn4AZuaidR7JHhOGCfS5v4SWkqNfq
	 RGuJG9sUGnZqoc3rbG23ncXycZtHz4ArJlW87CWV+0PoeREdeqRJzxBWReePn2lNgdk7I
	 S7gsQQrpjqYOeBIr//LSzKp+ug0gj0fwfOm8QU0TieFBoHp5/LI3yvWTJsX5RwDTUCKzP
	 Qr0MAO1AIYr6RInKblgdCNcc7C6hX8lmmx/GVSHMcdNBqWOT1xSDyunS8M9JQeIvBTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=naver.com;
	spf=pass smtp.mailfrom=naver.com;
	dkim=pass header.d=naver.com header.i=@naver.com header.a=rsa-sha256 header.s=s20171208 header.b="f793/JtV";
	arc=none smtp.remote-ip=114.111.35.158
Received: from cvsmtppost15.nm.naver.com (cvsmtppost15.nm.naver.com [114.111.35.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9590606A31C;
	Tue, 17 Nov 2026 04:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9590606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=naver.com header.i=@naver.com header.a=rsa-sha256 header.s=s20171208 header.b=f793/JtV
X-Works-Smtp-Source: VrY9aAtlFqJCpNmdaAg/WHF0
Received: from nv1m-hmac-real-7 ([10.174.201.121])
  by cvsmtppost15.nm.naver.com with ESMTP id 57TqJ3PjRcW4HzvQkmgjlg
  for <multiple recipients>;
  Tue, 17 Nov 2026 04:41:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1794890483; bh=niFXUB9dLz/IyDbir8jyhTxXozRONvjAvDjzMsZJrFA=;
	h=Message-ID:Date:From:To:Subject:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=f793/JtVoLcls055Zexa4bTKfiGL3yPPZvQuPB9SoKLtlCrv6XJ8HtduVMIZFdlPE
	 NkyCscZmcQF7gjRFGm6Z0EMZmDBVBNhg7xf7Vws4tYFfYTXb0+V8jmflM7vJevDsWW
	 kgdmUt4QDnpQIyqKfeMM8a1pm1n8L7lunuiaRl7jn8MXA60kFOFyvQ6xR6JiOble7o
	 dIMvv27ZPW0zr8IopUsAk9cGQAv5AP4uLY80uSj7JXvEwsDCGbj7I04uLYkDqk6WNS
	 1+FnC53jbY6WASries5DqZ0Zfyzjh3/YvmeH0caLpRdnr097AJCoD9ZsvDNGPnQsWN
	 rhPxNjBukcbdA==
X-Session-ID: 1fa9f93f43cc9c2547e6decbb5923f4a02abba9332889e8350c11476aa3a609f
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-ID: <d22b71efbe22b3dab362e4c94062e073@cweb005.nm>
Date: Tue, 17 Nov 2026 13:41:23 +0900
From: =?utf-8?B?U2lldW4gWWFuZw==?= <didtldms2525@naver.com>
In-Reply-To: <652bf9fd6e20ef231652b95efa65355@cweb018.nm>
References: <652bf9fd6e20ef231652b95efa65355@cweb018.nm>
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
Q0VTLCBidXQKICBhbiBPX1dST05MWSBvcGVuIHN1Y2NlZWRzIGFmdGVyIHRoZSByZXN0cmljdGlv
biBpcyBpbnN0YWxsZWQuCi0gREFDIG1vZGUgMDIwMCBkZW5pZXMgT19SRE9OTFkgYWZ0ZXIgQ0FQ
X0RBQ19PVkVSUklERSBhbmQKICBDQVBfREFDX1JFQURfU0VBUkNIIGFyZSBkcm9wcGVkLCBidXQg
YWxsb3dzIE9fV1JPTkxZLgotIFdpdGggQ09ORklHX0JUUkZTX0ZTX1BPU0lYX0FDTD15LCBhIFBP
U0lYIEFDTCBncmFudHMgb25seSB3cml0ZSBhY2Nlc3MKICB0byBhIG5hbWVkIHVzZXIuIFdpdGgg
ZnN1aWQgc2V0IHRvIHRoYXQgdXNlciBhbmQgdGhlIERBQyBieXBhc3MKICBjYXBhYmlsaXRpZXMg
ZHJvcHBlZCwgT19SRE9OTFkgZmFpbHMgYW5kIE9fV1JPTkxZIHN1Y2NlZWRzLgoKT24gTGludXgg
Ny40LjAtcmMzLWc2NjY1MzllZWNkZjQsIGJvdGggZW5jb2RlZC1yZWFkIHBhdGhzIHJldHVybmVk
CnRoZSBzYW1lIDgxOTIgYnl0ZXMgZnJvbSBhbiB1bmNvbXByZXNzZWQgQnRyZnMgZXh0ZW50IGlu
IGVhY2ggY2FzZS4KTm9ybWFsIHJlYWQoKSBvbiB0aGUgT19XUk9OTFkgZGVzY3JpcHRvciByZXR1
cm5lZCBFQkFERi4KCkNoZWNrIEZNT0RFX1JFQUQgaW4gYm90aCBlbnRyeSBwb2ludHMsIG1hdGNo
aW5nIHRoZSBGTU9ERV9XUklURSBjaGVja3MKYWxyZWFkeSBwcmVzZW50IGluIHRoZSBlbmNvZGVk
LXdyaXRlIHBhdGhzLiBCb3RoIGVuY29kZWQgcmVhZHMgdGhlbgpyZXR1cm4gRUJBREYgZm9yIE9f
V1JPTkxZOyBPX1JET05MWSBjb250cm9scyB3aXRoIHJlYWQgcGVybWlzc2lvbiBzdGlsbApzdWNj
ZWVkLiBUaGUgTGFuZGxvY2sgYW5kIERBQyBjYXNlcyB3ZXJlIGFsc28gdmVyaWZpZWQgb24gTGlu
dXggNy4zLjQuCgpGaXhlczogMTg4MWZiYTg5YmQ1ICgiYnRyZnM6IGFkZCBCVFJGU19JT0NfRU5D
T0RFRF9SRUFEIGlvY3RsIikKRml4ZXM6IDM0MzEwYzQ0MmUxNyAoImJ0cmZzOiBhZGQgaW9fdXJp
bmcgY29tbWFuZCBmb3IgZW5jb2RlZCByZWFkcyAoRU5DT0RFRF9SRUFEIGlvY3RsKSIpCkNjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFNpZXVuIFlhbmcgPGRpZHRsZG1z
MjUyNUBqbnUuYWMua3I+Ci0tLQp2MjogUmVzZW5kIHdpdGggQVNDSUkgc3BhY2VzIGluIHRoZSBk
aWZmIGNvbnRleHQuIFRoZSB2MSBlbWFpbCBoYWQKICAgIFUrMDBBMCBhdCB0aGUgc3RhcnQgb2Yg
Y29udGV4dCBsaW5lcy4gTm8gY29kZSBjaGFuZ2VzLgoKIGZzL2J0cmZzL2lvY3RsLmMgfCAxMCAr
KysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBh
L2ZzL2J0cmZzL2lvY3RsLmMgYi9mcy9idHJmcy9pb2N0bC5jCmluZGV4IDZiYTg4M2RiMS4uZjFl
NDZiNGU2IDEwMDY0NAotLS0gYS9mcy9idHJmcy9pb2N0bC5jCisrKyBiL2ZzL2J0cmZzL2lvY3Rs
LmMKQEAgLTQzOTIsNiArNDM5MiwxMSBAQCBzdGF0aWMgaW50IGJ0cmZzX2lvY3RsX2VuY29kZWRf
cmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgdm9pZCBfX3VzZXIgKmFyZ3AsCiAJCWdvdG8gb3V0X2Fj
Y3Q7CiAJfQogCisJaWYgKCEoZmlsZS0+Zl9tb2RlICYgRk1PREVfUkVBRCkpIHsKKwkJcmV0ID0g
LUVCQURGOworCQlnb3RvIG91dF9hY2N0OworCX0KKwogCWlmIChjb21wYXQpIHsKICNpZiBkZWZp
bmVkKENPTkZJR182NEJJVCkgJiYgZGVmaW5lZChDT05GSUdfQ09NUEFUKQogCQlzdHJ1Y3QgYnRy
ZnNfaW9jdGxfZW5jb2RlZF9pb19hcmdzXzMyIGFyZ3MzMjsKQEAgLTQ3NzksNiArNDc4NCwxMSBA
QCBzdGF0aWMgaW50IGJ0cmZzX3VyaW5nX2VuY29kZWRfcmVhZChzdHJ1Y3QgaW9fdXJpbmdfY21k
ICpjbWQsIHVuc2lnbmVkIGludCBpc3N1ZQogCX0KIAlzcWVfYWRkciA9IHU2NF90b191c2VyX3B0
cihSRUFEX09OQ0UoY21kLT5zcWUtPmFkZHIpKTsKIAorCWlmICghKGZpbGUtPmZfbW9kZSAmIEZN
T0RFX1JFQUQpKSB7CisJCXJldCA9IC1FQkFERjsKKwkJZ290byBvdXRfYWNjdDsKKwl9CisKIAlp
ZiAoaXNzdWVfZmxhZ3MgJiBJT19VUklOR19GX0NPTVBBVCkgewogI2lmIGRlZmluZWQoQ09ORklH
XzY0QklUKSAmJiBkZWZpbmVkKENPTkZJR19DT01QQVQpCiAJCWNvcHlfZW5kID0gb2Zmc2V0b2Zl
bmQoc3RydWN0IGJ0cmZzX2lvY3RsX2VuY29kZWRfaW9fYXJnc18zMiwgZmxhZ3MpOwoKYmFzZS1j
b21taXQ6IDY2NjUzOWVlY2RmNGRiNjIzZjVlM2MzZTU1Y2Y5ZjJkZmFkMjRhYTQKLS0gCjIuMzku
NQoKCgo=
