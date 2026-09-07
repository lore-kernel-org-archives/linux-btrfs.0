Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B26D26AF4
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 22:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788819368; cv=none; b=EmLesrXB4ONT3pqM/NMpThXGYtVNQMXfUCAnbKySRY4eCud9sIR4VDsg1qxXIeHZ3MYxSkcRh5x3XwheAmOE1YA2b82oIhPssx5HBDF0urAwsKROt3XeJXZB/JBOXezYu9sBl4nQFmkYWiu1AASUim3wdp9cAYlGq1iCLSJ9jDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788819368; c=relaxed/simple;
	bh=d4JxKJStupt1N4m/1MxwjGB+LXPId4NIwYmxcp11CtQ=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:References:To:
	 From:In-Reply-To; b=b4V6BpV8pEy8NAZscF/6hYgOvB7OPFmSuTCZJFlpbcbBNIZS+SXE7Ium5Hvhx3t3WN++4QwgCRjvqdAxWoWtC2acSFW4o8pFHxcXKPyYd2gR5kMvCMQRxQPg0HZ69Gig1EFzgnbnFOMSA4ccNpTyKFMAmHNEaSWqykt+RpF6Bes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RXRaLHs/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RXRaLHs/"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4956869750eso35203495e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 15:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788819365; x=1789424165; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:to:references:subject:user-agent
         :mime-version:date:message-id:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bD1IonmVXHYUNe0Q3jL+I2bKll7/td7yN0Xx97E0ZQY=;
        b=RXRaLHs/DYDMYciIH9JFSb2Pkfx+ctzvO2I2ohYDl4mvY7Jm6XXYLs0HVlBTRFUjqN
         nDMIZNN4McyIlTIPtb3/YjzwlnaTioaqNhKQW/vOxCgO6Q0IlfxsSNH47Vpw44CghIs0
         WKsiWUkpD2xl2iEGE65Vml+50QNOVueP69w8a4EDcz4ZHYbp8nCMJFKs9OdkHCFpns1H
         xVqJiughuRvM+5Z37H7wMR6w7BLSvpIQkugDnH2/vMXhVlvvOe5nsY04SyntpGfXPIUv
         QKG4sIKwEB+07OJSciahggmzxyf1dfieyVvvKw+dpyQGtEttjMCdQkYKPQl7GXNcKmeH
         VYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788819365; x=1789424165;
        h=in-reply-to:autocrypt:from:to:references:subject:user-agent
         :mime-version:date:message-id:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bD1IonmVXHYUNe0Q3jL+I2bKll7/td7yN0Xx97E0ZQY=;
        b=PXLwq61qwXj9bvv9+/r9CkqenbrU7YJYUaVIdmcZx/pXy78F6VU32npCpgv6641UQY
         jnpckEqXAcdL3MG5u9Tn4u6yByyinJDy767OuvHBuwcMG1Cd6fmtnJkhSoGnFSSB9WEk
         kVl6wtJEF+1EyhfG4WNx+/ixhJsneFedbG7wzy11sQZqGn9Zb3HO5smIPpT9qmIEVUyr
         vYgEmPNTHZQ3cahyFcj9KnR7Ok4KrMqtyHJviSamxI2Vv2qfAsFxwoo2/CVruooe+/FU
         V9kJP/P6pRIOUkADza5c/Qjfkswj9/fjTALPpH/npUBkDOEhwr44GrBwwRGofiX7YG0b
         sxEg==
X-Gm-Message-State: AFuF++kF9FowDr57zhPlgCAD2BWlLi5QeAtghjHWNr2n4xnbBiB5HSsi
	Rk6pmS2ZKR/MZgbSkkjIqoEq9rYxO6tMsnAYCVxdPY7UDbqxDFmDfz2vJXSUl0oArx51fZlEQpZ
	uVPsjf5O5Jw==
X-Gm-Gg: AYBFou17SdSe+Kpp/Y9gREYRuI19CR95hgx+kizQHISUkiwpab2e/+mU1Pqer+qHNx8
	a02TAUMoW8KbsNlLq8fHcuZVfOCWSzL04/9WdN62IVH1PbRujHKOjRS0YSsPZIzy1YtW9nQuTze
	syM2RlXItxTaCJpJCx/NHuU6VUpx6+FeJMBre++jlWZdLv519OURTfNOQkgoK7xcCcozPYHioox
	Ca4LjfZ1A6GxPNCbn1+dFHKlxJI0lRr/rk6vaJezhEtIHcSrBPR1xjjKT5m+Xn1QG9hEYX7OayT
	eth8y/KcAf6d1OKbVG0AnTtkhjtHw0ZcsqUqcbbgqIiACu6VfpF84VpmmKPqjDuYVIM4Ssnlzta
	2zYKrvQxGyQZQfjDO6fYRaTZtA9kIQLqD82hDrDdPpIghGTcg26VagHISDE/MEclnElzo4ayTWF
	iezVRf79ceMhv6XrdhCOERBKKIVed05ZvFifhTn2FUoHQgmyHCIAimgQ==
X-Received: by 2002:a05:600c:37c8:b0:49c:cee2:a508 with SMTP id 5b1f17b1804b1-49cf826c4e2mr237909365e9.16.1788819364791;
        Mon, 07 Sep 2026 15:16:04 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc465376831sm3417480a12.9.2026.09.07.15.16.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 15:16:03 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------p0y7yBOhePROHRhVKNd6x6S8"
Message-ID: <250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com>
Date: Tue, 8 Sep 2026 07:45:58 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Fwd: btrfs: OOM in split_item().
References: <nka8fLGwxf2NcMXCcuLi4CkGSIKrKG4Sc9IbvTTBG5L6T63w6tImgOKYEmu-pWaoZZFO4Eqg8zDyMggihfvlFRTd1Vubz6E52PVEhU83gn8=@protonmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <nka8fLGwxf2NcMXCcuLi4CkGSIKrKG4Sc9IbvTTBG5L6T63w6tImgOKYEmu-pWaoZZFO4Eqg8zDyMggihfvlFRTd1Vubz6E52PVEhU83gn8=@protonmail.com>
X-Forwarded-Message-Id: <nka8fLGwxf2NcMXCcuLi4CkGSIKrKG4Sc9IbvTTBG5L6T63w6tImgOKYEmu-pWaoZZFO4Eqg8zDyMggihfvlFRTd1Vubz6E52PVEhU83gn8=@protonmail.com>

This is a multi-part message in MIME format.
--------------p0y7yBOhePROHRhVKNd6x6S8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Forwarded for archive purposes, as patchcheck requires a link: tag 
following reported-by: tag.

Meanwhile the original report is only a private mail to me.

-------- 转发的消息 --------
主题: 	btrfs: OOM in split_item().
日期: 	Mon, 07 Sep 2026 20:10:56 +0000
发件人: 	xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
收件人: 	wqu@suse.com <wqu@suse.com>



Hello.

Attached is a kernel log entry showing a strange out of memory issue 
that rarely seems to happen.
It's kind of annoying and makes me wish GFP_NOFS would go the way of the 
dinosaur.

Thanks and have a good day / evening.


--------------p0y7yBOhePROHRhVKNd6x6S8
Content-Type: text/plain; charset=UTF-8; name="btrfs_oom_splat.txt"
Content-Disposition: attachment; filename="btrfs_oom_splat.txt"
Content-Transfer-Encoding: base64

Cls1NTU4NjE1LjA0MTUyN10ga3dvcmtlci91Njk6ODogcGFnZSBhbGxvY2F0aW9uIGZhaWx1
cmU6IG9yZGVyOjQsIG1vZGU6MHg0MGM0MChHRlBfTk9GU3xfX0dGUF9DT01QKSwgbm9kZW1h
c2s9KG51bGwpCls1NTU4NjE1LjA0MTU0MF0gQ1BVOiAzIFVJRDogMCBQSUQ6IDExNTQ1Mjgg
Q29tbToga3dvcmtlci91Njk6OCBOb3QgdGFpbnRlZCA3LjAuMiAjMSBQUkVFTVBUTEFaWSAK
WzU1NTg2MTUuMDQxNTQ0XSBXb3JrcXVldWU6IGV2ZW50c191bmJvdW5kIGJ0cmZzX2FzeW5j
X3JlY2xhaW1fbWV0YWRhdGFfc3BhY2UKWzU1NTg2MTUuMDQxNTUwXSBDYWxsIFRyYWNlOgpb
NTU1ODYxNS4wNDE1NTNdICA8VEFTSz4KWzU1NTg2MTUuMDQxNTU0XSAgZHVtcF9zdGFja19s
dmwrMHg0Ny8weDYwCls1NTU4NjE1LjA0MTU1OF0gIHdhcm5fYWxsb2MuY29sZCsweDY3LzB4
ZWMKWzU1NTg2MTUuMDQxNTYxXSAgX19hbGxvY19wYWdlc19zbG93cGF0aC5jb25zdHByb3Au
MCsweDliZi8weGVkMApbNTU1ODYxNS4wNDE1NjVdICBfX2FsbG9jX2Zyb3plbl9wYWdlc19u
b3Byb2YrMHgxYWMvMHgxYzAKWzU1NTg2MTUuMDQxNTY3XSAgX19fa21hbGxvY19sYXJnZV9u
b2RlKzB4OWQvMHhjMApbNTU1ODYxNS4wNDE1NjldICBfX2ttYWxsb2Nfbm9wcm9mKzB4MTdi
LzB4MWYwCls1NTU4NjE1LjA0MTU3MV0gIHNwbGl0X2l0ZW0rMHg5ZS8weDJlMApbNTU1ODYx
NS4wNDE1NzRdICA/IG1lbXNldF9leHRlbnRfYnVmZmVyKzB4ZDMvMHgxMjAKWzU1NTg2MTUu
MDQxNTc2XSAgYnRyZnNfZGVsX2NzdW1zKzB4Mjg1LzB4NDAwCls1NTU4NjE1LjA0MTU3OF0g
ID8gcmVsZWFzZV9leHRlbnRfYnVmZmVyKzB4M2MvMHgxMDAKWzU1NTg2MTUuMDQxNTc5XSAg
PyBidHJmc19jc3VtX3Jvb3QrMHg5NC8weGMwCls1NTU4NjE1LjA0MTU4MV0gIF9fYnRyZnNf
ZnJlZV9leHRlbnQuaXNyYS4wKzB4NmRlLzB4MTJiMApbNTU1ODYxNS4wNDE1ODNdICBfX2J0
cmZzX3J1bl9kZWxheWVkX3JlZnMrMHg1MjIvMHgxMGMwCls1NTU4NjE1LjA0MTU4Nl0gID8g
X193cml0ZV9leHRlbnRfYnVmZmVyKzB4MTNkLzB4MWQwCls1NTU4NjE1LjA0MTU4N10gID8g
YnRyZnNfcWdyb3VwX2NvbnZlcnRfcmVzZXJ2ZWRfbWV0YSsweDIwLzB4MjkwCls1NTU4NjE1
LjA0MTU4OV0gID8gYnRyZnNfYmxvY2tfcnN2X3JlbGVhc2UrMHgxNTMvMHgxZjAKWzU1NTg2
MTUuMDQxNTkxXSAgPyBfX2J0cmZzX3VwZGF0ZV9kZWxheWVkX2lub2RlKzB4Y2IvMHg0NTAK
WzU1NTg2MTUuMDQxNTkzXSAgYnRyZnNfcnVuX2RlbGF5ZWRfcmVmcysweDRkLzB4MWQwCls1
NTU4NjE1LjA0MTU5NV0gIGZsdXNoX3NwYWNlKzB4MzRkLzB4NGUwCls1NTU4NjE1LjA0MTU5
N10gID8gYnRyZnNfcmVkdWNlX2FsbG9jX3Byb2ZpbGUrMHhhMi8weDFhMApbNTU1ODYxNS4w
NDE1OTldICA/IGNhbGNfYXZhaWxhYmxlX2ZyZWVfc3BhY2UuaXNyYS4wKzB4NTgvMHg5MApb
NTU1ODYxNS4wNDE2MDFdICA/IGJ0cmZzX2NhbGNfcmVjbGFpbV9tZXRhZGF0YV9zaXplKzB4
MjAvMHg2MApbNTU1ODYxNS4wNDE2MDNdICBkb19hc3luY19yZWNsYWltX21ldGFkYXRhX3Nw
YWNlKzB4ODkvMHgxZDAKWzU1NTg2MTUuMDQxNjA1XSAgPyBtZW1wb29sX2ZyZWUrMHgzYi8w
eDYwCls1NTU4NjE1LjA0MTYwOV0gIGJ0cmZzX2FzeW5jX3JlY2xhaW1fbWV0YWRhdGFfc3Bh
Y2UrMHg0NC8weDYwCls1NTU4NjE1LjA0MTYxMV0gIHByb2Nlc3Nfb25lX3dvcmsrMHgxNDUv
MHgyMzAKWzU1NTg2MTUuMDQxNjE0XSAgd29ya2VyX3RocmVhZCsweDE4NS8weDJlMApbNTU1
ODYxNS4wNDE2MTZdICA/IHJlc2N1ZXJfdGhyZWFkKzB4NGEwLzB4NGEwCls1NTU4NjE1LjA0
MTYxN10gIGt0aHJlYWQrMHhjYS8weDEwMApbNTU1ODYxNS4wNDE2MTldICA/IGt0aHJlYWRz
X29ubGluZV9jcHUrMHgxMC8weDEwCls1NTU4NjE1LjA0MTYyMF0gIHJldF9mcm9tX2Zvcmsr
MHgxNGUvMHgyMDAKWzU1NTg2MTUuMDQxNjIzXSAgPyBrdGhyZWFkc19vbmxpbmVfY3B1KzB4
MTAvMHgxMApbNTU1ODYxNS4wNDE2MjRdICA/IGt0aHJlYWRzX29ubGluZV9jcHUrMHgxMC8w
eDEwCls1NTU4NjE1LjA0MTYyNV0gIHJldF9mcm9tX2ZvcmtfYXNtKzB4MTEvMHgyMApbNTU1
ODYxNS4wNDE2MjhdICA8L1RBU0s+Cls1NTU4NjE1LjA0MTYyOV0gTWVtLUluZm86Cls1NTU4
NjE1LjA0MTYzNV0gYWN0aXZlX2Fub246MjI2OTUgaW5hY3RpdmVfYW5vbjo4MjI4OTYgaXNv
bGF0ZWRfYW5vbjowCiAgICAgICAgICAgICAgICAgIGFjdGl2ZV9maWxlOjMyNzQzMDcgaW5h
Y3RpdmVfZmlsZToyNTcxOTM5IGlzb2xhdGVkX2ZpbGU6MAogICAgICAgICAgICAgICAgICB1
bmV2aWN0YWJsZTo1ODIgZGlydHk6MjA5NzUgd3JpdGViYWNrOjE2MTA4OQogICAgICAgICAg
ICAgICAgICBzbGFiX3JlY2xhaW1hYmxlOjEwMjQ1Njcgc2xhYl91bnJlY2xhaW1hYmxlOjYx
MTY1CiAgICAgICAgICAgICAgICAgIG1hcHBlZDoxNTM3MDYgc2htZW06NDg4OTkgcGFnZXRh
Ymxlczo4NzU4CiAgICAgICAgICAgICAgICAgIHNlY19wYWdldGFibGVzOjAgYm91bmNlOjAK
ICAgICAgICAgICAgICAgICAga2VybmVsX21pc2NfcmVjbGFpbWFibGU6MAogICAgICAgICAg
ICAgICAgICBmcmVlOjI1NDQ5NSBmcmVlX3BjcDoxMDQgZnJlZV9jbWE6MApbNTU1ODYxNS4w
NDE2NDFdIE5vZGUgMCBhY3RpdmVfYW5vbjo5MDc4MGtCIGluYWN0aXZlX2Fub246MzI5MTU4
NGtCIGFjdGl2ZV9maWxlOjEzMDk3MjI4a0IgaW5hY3RpdmVfZmlsZToxMDI4Nzc1NmtCIHVu
ZXZpY3RhYmxlOjIzMjhrQiBpc29sYXRlZChhbm9uKTowa0IgaXNvbGF0ZWQoZmlsZSk6MGtC
IG1hcHBlZDo2MTQ4MjRrQiBkaXJ0eTo4MzkwMGtCIHdyaXRlYmFjazo2NDQzNTZrQiBzaG1l
bToxOTU1OTZrQiBrZXJuZWxfc3RhY2s6MTkzOTJrQiBwYWdldGFibGVzOjM1MDMya0Igc2Vj
X3BhZ2V0YWJsZXM6MGtCIGFsbF91bnJlY2xhaW1hYmxlPyBubyBCYWxsb29uOjBrQgpbNTU1
ODYxNS4wNDE2NDVdIERNQTMyIGZyZWU6MjU1MDQ4a0IgYm9vc3Q6ODE5MmtCIG1pbjoxMDMz
NmtCIGxvdzoxMzQwMGtCIGhpZ2g6MTY0NjRrQiByZXNlcnZlZF9oaWdoYXRvbWljOjQwOTZL
QiBmcmVlX2hpZ2hhdG9taWM6Mzk3NktCIGFjdGl2ZV9hbm9uOjEzNzIwa0IgaW5hY3RpdmVf
YW5vbjo5MTk0NGtCIGFjdGl2ZV9maWxlOjkyNDQ4NGtCIGluYWN0aXZlX2ZpbGU6Njc0MDEy
a0IgdW5ldmljdGFibGU6MjQ0a0Igd3JpdGVwZW5kaW5nOjE1MDM3MmtCIHpzcGFnZXM6MGtC
IHByZXNlbnQ6MzMyOTM2NGtCIG1hbmFnZWQ6MzA4NDQwOGtCIG1sb2NrZWQ6MjQ0a0IgYm91
bmNlOjBrQiBmcmVlX3BjcDowa0IgbG9jYWxfcGNwOjBrQiBmcmVlX2NtYTowa0IKWzU1NTg2
MTUuMDQxNjUwXSBsb3dtZW1fcmVzZXJ2ZVtdOiAwIDI4ODY0IDI4ODY0IDI4ODY0Cls1NTU4
NjE1LjA0MTY1NF0gTm9ybWFsIGZyZWU6NzYyOTMya0IgYm9vc3Q6NjU1MzZrQiBtaW46ODYy
MzJrQiBsb3c6MTE1Nzg4a0IgaGlnaDoxNDUzNDRrQiByZXNlcnZlZF9oaWdoYXRvbWljOjQw
OTZLQiBmcmVlX2hpZ2hhdG9taWM6NDA5NktCIGFjdGl2ZV9hbm9uOjc2OTY4a0IgaW5hY3Rp
dmVfYW5vbjozMTk5NjQwa0IgYWN0aXZlX2ZpbGU6MTIxNzI1NzZrQiBpbmFjdGl2ZV9maWxl
Ojk2MTQzOTZrQiB1bmV2aWN0YWJsZToyMDg0a0Igd3JpdGVwZW5kaW5nOjU3ODExNmtCIHpz
cGFnZXM6MGtCIHByZXNlbnQ6MzAxMzM3NjBrQiBtYW5hZ2VkOjI5NTU2OTIwa0IgbWxvY2tl
ZDoyMDg0a0IgYm91bmNlOjBrQiBmcmVlX3BjcDo0MTZrQiBsb2NhbF9wY3A6MGtCIGZyZWVf
Y21hOjBrQgpbNTU1ODYxNS4wNDE2NTldIGxvd21lbV9yZXNlcnZlW106IDAgMCAwIDAKWzU1
NTg2MTUuMDQxNjYxXSBETUEzMjogMjAzNDcqNGtCIChVTUUpIDEyMDk4KjhrQiAoVU1FSCkg
Mzk2MCoxNmtCIChVTUVIKSAyOTMqMzJrQiAoTUVIKSA3KjY0a0IgKEgpIDEqMTI4a0IgKEgp
IDQqMjU2a0IgKEgpIDAqNTEya0IgMioxMDI0a0IgKEgpIDAqMjA0OGtCIDAqNDA5NmtCID0g
MjU0NTU2a0IKWzU1NTg2MTUuMDQxNjc1XSBOb3JtYWw6IDExNjcwNSo0a0IgKFVNRSkgMjgx
MDgqOGtCIChVTUUpIDMzMzAqMTZrQiAoVU1FKSAzNzkqMzJrQiAoVU1FKSAwKjY0a0IgMCox
MjhrQiAwKjI1NmtCIDAqNTEya0IgMCoxMDI0a0IgMCoyMDQ4a0IgMSo0MDk2a0IgKEgpID0g
NzYxMTg4a0IKWzU1NTg2MTUuMDQxNjg2XSA1ODAxMzI3IHRvdGFsIHBhZ2VjYWNoZSBwYWdl
cwpbNTU1ODYxNS4wNDE2ODddIDgzNjU3ODEgcGFnZXMgUkFNCls1NTU4NjE1LjA0MTY4OF0g
MCBwYWdlcyBIaWdoTWVtL01vdmFibGVPbmx5Cls1NTU4NjE1LjA0MTY4OV0gMjA1NDQ5IHBh
Z2VzIHJlc2VydmVkCls1NTU4NjE1LjA0MTY5MF0gMCBwYWdlcyBod3BvaXNvbmVkCls1NTU4
NjE1LjA0MTY5MV0gQlRSRlMgZXJyb3IgKGRldmljZSBkbS0zIHN0YXRlIEEpOiBUcmFuc2Fj
dGlvbiBhYm9ydGVkIChlcnJvciAtMTIpCls1NTU4NjE1LjA0MTY5Nl0gQlRSRlM6IGVycm9y
IChkZXZpY2UgZG0tMyBzdGF0ZSBBKSBpbiBidHJmc19kZWxfY3N1bXM6MTA1MzogZXJybm89
LTEyIE91dCBvZiBtZW1vcnkKWzU1NTg2MTUuMDQxNjk4XSBCVFJGUyBpbmZvIChkZXZpY2Ug
ZG0tMyBzdGF0ZSBFQSk6IGZvcmNlZCByZWFkb25seQpbNTU1ODYxNS4wNDE3MDFdIEJUUkZT
OiBlcnJvciAoZGV2aWNlIGRtLTMgc3RhdGUgRUEpIGluIGRvX2ZyZWVfZXh0ZW50X2FjY291
bnRpbmc6MzE2ODogZXJybm89LTEyIE91dCBvZiBtZW1vcnkKWzU1NTg2MTUuMDQxNzA0XSBC
VFJGUyBlcnJvciAoZGV2aWNlIGRtLTMgc3RhdGUgRUEpOiBmYWlsZWQgdG8gcnVuIGRlbGF5
ZWQgcmVmIGZvciBsb2dpY2FsIDEyMDI5MTM4NzM5MjAgbnVtX2J5dGVzIDI3NDQzMiB0eXBl
IDE4NCBhY3Rpb24gMiByZWZfbW9kIDE6IC0xMgpbNTU1ODYxNS4wNDE3MDhdIEJUUkZTOiBl
cnJvciAoZGV2aWNlIGRtLTMgc3RhdGUgRUEpIGluIGJ0cmZzX3J1bl9kZWxheWVkX3JlZnM6
MjI0NzogZXJybm89LTEyIE91dCBvZiBtZW1vcnkKCg==

--------------p0y7yBOhePROHRhVKNd6x6S8--
