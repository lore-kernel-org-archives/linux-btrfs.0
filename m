Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792534682;
	b=Xqk62Te0LxxSM0hj2cp0NFDJ+uyAVjz0ryYB+vmrRcw6wq2jR8MBn3Ak7Ionj+01NiU6
	 Mvc4tOWa/2xnzDbkv+RUhw9PB2uAHW0hN49ztZd7EH2Fj1yebWJvDDNNkslU8T3rFk5jT
	 A0TR/dRt5kBHnCUk+U0tL2sZvRPl9xHZTj7QNj/qcjH0fFEbLMnMrJH7UWNV9+QvpDySG
	 wRSYv3wtO9Vki2A6e95p/7h0A11sTwbjFf5QsIuOohPLL3+6ab/dgF0XCbhfgOF5k8H/T
	 m4iXW1M/ppRhadSjeTERqvb4Ahmkf4kcZXHqcVFwKwraRR5JjMy/53p2xiF+16vW+tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534682;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Provags-ID:
	 X-Spam-Flag:UI-OutboundReport;
	bh=Dra6rwyMt3a29VbY68Es5khpQkP2aYFaVnn2jqOP0aI=;
	b=U3yZaHYA8wUUignO+R4kDz9e69j1P7QPKOnYcTtig20yOJvZ7GwYd51ZpQuVi3fcEWk6
	 0nP43UHdanp2+be9dutUTIEM6p+LBkfvC9OZsrYap3X/pXKChkWcVmY1JRsUzL9WbMZxK
	 nDXbW4tdh8mbtWP+u6Urd8VCL1Jq0AOWxoJ15Pas/TtfOCPNVkOMEA1EFDoZsNq4uK/5+
	 gQs3yrPfOXxH1+TiSMnAyF/5C4lBbImPQfdDcKcDe1DVxfSiJvv9MvP7jc553zgF9XxH5
	 oBF38ouOJ5mvxeHC6zPOwCy4BjJ8kI9D+yt+MY5fUx4hQbRMHmHeKdzLBfr1wJ7avFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="KY5XsJ9/";
	arc=none smtp.remote-ip=212.227.15.19
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2F7606A319
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 22:18:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC2F7606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=KY5XsJ9/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792534679; x=1793139479; i=quwenruo.btrfs@gmx.com;
	bh=Dra6rwyMt3a29VbY68Es5khpQkP2aYFaVnn2jqOP0aI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KY5XsJ9/j9aBhEclz/Rwiu3Cm18pIM1WGrQ8zP/SM9B4TSSiYkSDv3RPQ+5siIUT
	 9GrjX+Xd9aKHeZoaa0mx5uBfkfwoHwiLIWUNAljZV66Wi48jvHZZ880FqqlsNtXkZ
	 FBP694BrL5JpBqXV6pZG7oza1KLjB60YefDgjdC67Oq95I3cvJzPL7cusUKNwiK91
	 TlUBcVefEipBsgETQ6oiLgnWiMOcBLtlpJK9JqmpobhUqUr945s9vPitUikNb1dGT
	 wtkUD+M5OdB6HrD4Xwz6vIloFgSMlAqbzWMfWJ8QQ+9L/RZBqRKRQhQ/DxZzw0Hg1
	 D1uT/vtrpA4nGqCbFw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M4JqV-1xJ1Al1Oi1-009GYY; Wed, 21
 Oct 2026 00:17:59 +0200
Message-ID: <098977c1-4cd0-4071-a507-297343899fce@gmx.com>
Date: Wed, 21 Oct 2026 08:47:54 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] btrfs: change scrub to use stripe_len
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <5413079aa6e5031a98157e33ec23a5962d2cb590.1792391732.git.wqu@suse.com>
 <d3885d3f-c7f9-4706-a1a6-e22a2b4ff35b@wdc.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <d3885d3f-c7f9-4706-a1a6-e22a2b4ff35b@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:fNsedM1E893kDIt00OdjPPSFaC5g//jjdUOlhCiQB4rETn/YyRE
 UsII7wlbeVhanqK7AWqVgNmwdec1lFpCHBQ/bwMHI2k6CrYkyjSzKriOgWVtahDQUyeAw1P
 xduh5+dURP7OOuuoPfrTNAP3Miv2ILe/7J+THSfkNtgHL5oMlL5YLcGDRopQUr9qWICOU/o
 GIOZr5dce+cDMS9v3I9AQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZVbyeBow3rs=;AjJmqhPZS44i20FZuJ3CvGwujh1
 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
 Su55qHx/YQ1JSIbLj2SqN0vcgg==

DQoNCuWcqCAyMDI2LzEwLzIwIDIxOjMxLCBKb2hhbm5lcyBUaHVtc2hpcm4g5YaZ6YGTOg0KPiBP
biAxOS4xMC4yNiAwODo0MCwgUXUgV2VucnVvIHdyb3RlOg0KPj4gwqAgc3RhdGljIHN0cnVjdCBi
dHJmc19iaW8gKmFsbG9jX3NjcnViX2JiaW8oc3RydWN0IGJ0cmZzX2ZzX2luZm8gDQo+PiAqZnNf
aW5mbywNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
YmxrX29wZl90IG9wZiwNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdTY0IGxvZ2ljYWwsDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHU2NCBsb2dpY2FsLCB1MzIgc3RyaXBlX2xlbiwNCj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnRyZnNfYmlvX2VuZF9pb190IGVuZF9p
bywgdm9pZCAqcHJpdmF0ZSkNCj4+IMKgIHsNCj4gQWxsIGNhbGxlcnMgb2YgYWxsb2Nfc2NydWJf
YmJpbygpIHBhc3MgYSBzY3J1Yl9zdHJpcGUgYXMgJ3ByaXZhdGUnLiBXaHkgDQo+IG5vdCBjaGFu
Z2UgJ3ZvaWQgKnByaXZhdGUnIHRvICdzdHJ1Y3Qgc2NydWJfc3RyaXBlICpzdHJpcGUnIGFuZCBh
Y2Nlc3MgDQo+ICdzdHJpcGVfbGVuJyBmcm9tIHRoZXJlPw0KDQpTb3VuZHMgYXdlc29tZS4NCg==
