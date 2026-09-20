Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1075B3D16FD
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 04:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789880213; cv=none; b=LDPklL3Bri0Q/oNMNAGo+FrccXQJqTKYlmawwLbeXfe5Px2VAjXByP6J5ib9Q+U0DfwiTImWI8OL8Y3woEyqDfSKAyB0v1C3C9ekPb4VYqLicjed3SlJISMNILEQS/rcqq9RV8/7wlbMgXwCh4W0233Jb9KpWpMb3OhOmApz6rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789880213; c=relaxed/simple;
	bh=/1Gh9AuwzBywnlKPgxsY9DpZ0/BorK4gMX+Y1JKgD/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhaPVYoZeTwyu4oSivjyMGhu5qZOw2S5NhtmZoyLRM3Eo24OzetfofYxmGs2RmmZQv68c4+WwFelc3Cl4HkA8SafYfHD3Ix+zGaYdu2FHxITCT0uQMeFZ0fcdJWFRhQzqfr6j4EL9ZHUkMLM30vO3epHAnS0V3dnz3nVbWNYzu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JO/KIQQP; arc=none smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JO/KIQQP"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f1651cso1843094e87.0
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 21:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789880210; x=1790485010; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N0Z7DCcddM/goOB1ZFchbN6XjfF2R5MqWtHBtaKO3y0=;
        b=JO/KIQQP8LT/8HeUi6Ucjradb18ByVQI/RgH32OvuTAzaaSDACDyIVQFgRyqRgDAQc
         oseu4vZaExOpTCZlmTyNb1eG+145WjQlhv2SNrTVtcLofiolO+Qp73z3iQT4BTlnqpcM
         z9AI8g5ToVd/d2hsukxW+fYOqpuKQk/Surww/Gr7LDpJO6OtHqWkIyCjtvAwtUmo9WUs
         5EVDA22st6IvPLGc5oSfi9BtZO9HTXz0KXSxs3XnlMclzLBvPUMsuyUjcZElM/MOLBrc
         HXxika2g3SFfAiZEBpGIykzZhL17O1rLw5LSpE0R2J1Lv0iHvu0aijKvYsw6SNcSv6bA
         yuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789880210; x=1790485010;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N0Z7DCcddM/goOB1ZFchbN6XjfF2R5MqWtHBtaKO3y0=;
        b=F7TQwAIFbrLtiuFwBF6d6JdLxe/Gxs9SXbl0gxwYE8ZiftrCPi1EHWOTZYK4F91/9M
         dcJybao3/md6KUXRFJZDmqlhs5O6V8BVYIffErfCH+eeLaoElyo++4vRaakskROg7nno
         jYEIXL89KghoTHmk0vDMDczTpdUzH/xNW1z8bmF5KETJnS32xcsDLJCnkL7BKqpRT6xP
         UqliF3RA7JZYFxCZbZoD3vCVz/bd1jc4sz+Q2KvAUJwdldNBKf6pulR8CbDWbP/ESWEI
         a76hK+094mY5lCuysuVHiKcYylj08y2Z+57zy+082TVnxblDtl8+bHDkj9VdM/ZtpP7i
         4f7w==
X-Gm-Message-State: AFuF++ls0qDNG63gelxYHc2atbplA4+URQBgtTCgT9EJ2VHt7W4Vo3vp
	MDde6E2SnFhiywDSTHw5fuziBgAhhbC8Zwhq+rQPdyaM8xRQQKVF9SAj4oJAFg==
X-Gm-Gg: AYBFou076a199fQBMAhiqyUHYVJ/KPAUoD9xpgt1292UBhEDKX8kobr4I/VzgNXz+wT
	McUCtHppBbY9u/gBvAELt7PftI25PEX0AD04ZdGywZAgeUUT7JW1kI1DU3XEy00RfgENdF5THQX
	fBU4NcIFlvrD6NxZHXQjzzKc/U3LIkoj4xaAkOxWSGWRO1D4F70aBX+EJp6cCmu2PiQct8H/Zea
	kQLwD3dlSl3pxVflqWLqVqoSUAY+dh/lCJOtDloRuZDpyTW92Okso+hP7dg8fxOVmGTnTfqHQAD
	zsCBdYL7yQLemGhgM1wZFO5q9LDFCGRrucqWKhp2s29uDobV0Nrp8MaDRMa1RfLsjUf3lxi3Tqz
	Cn5LMlVvb4iY+G3z1ZTFrmHJYD4rmmP/jpgK3JnK3sKKwcFUPPNWpreY97+oGQA1SSBiHhE8k0H
	lDlWYA4n5FRVucBStH9gO5zFoFeMqk06SXp1iQqZVj38C2wmD1S7j3P0FSbeFS7JGDDVq/5Fa3g
	/KrSxiPWtHxl38jKAPfnXUvpu5EsmmpnH9f5BmH+BGUzPI=
X-Received: by 2002:ac2:4c4e:0:b0:5b6:184c:7da8 with SMTP id 2adb3069b0e04-5b8c1850e69mr2055965e87.49.1789880209727;
        Sat, 19 Sep 2026 21:56:49 -0700 (PDT)
Received: from ?IPV6:2a00:1370:8180:5173:fa47:3ad7:ed3:65d7? ([2a00:1370:8180:5173:fa47:3ad7:ed3:65d7])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8c7966d35sm980742e87.76.2026.09.19.21.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 21:56:47 -0700 (PDT)
Message-ID: <bbec11f2-7ec8-4cf8-9d50-24681cdaf4bd@gmail.com>
Date: Sun, 20 Sep 2026 07:56:47 +0300
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: qgroup rescan worker makes suspend fail
To: Qu Wenruo <wqu@suse.com>, Johannes Thumshirn
 <johannes.thumshirn@wdc.com>, Richard Weinberger <richard@nod.at>
Cc: linux-btrfs@vger.kernel.org
References: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
 <aq7HYO9SKdIaqvr_@mayhem.fritz.box>
 <38c0b7f1-a876-45ab-92e2-223e2f70d82d@suse.com>
Content-Language: en-US, ru-RU
From: Andrei Borzenkov <arvidjaar@gmail.com>
In-Reply-To: <38c0b7f1-a876-45ab-92e2-223e2f70d82d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

20.09.2026 01:39, Qu Wenruo wrote:
> 
> To be honest, qgroup mode is no longer recommended, except for rigid
> subvolume layouts, and since you need rescan it's definitely the not
> recommended case.
> 
> The current only well known user is snapper, and we're pushing snapper
> not to utilize qgroup by default.
> 
> So unless you have a very clear use case, it's better just disable
> qgroups completely.

I am not aware of any other way to get true subvolume space consumption 
and thus implementing space based retention policy. "btrfs du" is hardly 
an option.

If qgroup is deprecated, what are other options to get this information?
