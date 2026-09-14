Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA6B385D68
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 18:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789410287; cv=none; b=TdpuAg6jr/y2Wsj7vYzAmGF43T50lHlZ58zWnABZiHcZ66duR64Her1U9UKD75h3Jyk/rcBV5I3h3yqikUXQfNgxauQEflUTyv/uurn6dlwp/MDqjwiYj4WaFUriyXZoPrKnhcdR4RBUj7MVYkRiL1CdRjO84+NasbN4wK+37XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789410287; c=relaxed/simple;
	bh=Fm4tgTaSmgpgFdHd7tjZfgP4r+h+X3d+P5SZ77fNrWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OXF7DJ3nVrqacJRhQo8tekMYWiqgURer3rhLM9QDBiO/RQTPNqNlPNk7vvLIpocou1PbOiS9oNKEXIxeE30jVXkNJXOxXsmrGNwSxFlhs9j43m+hMelrCWN3TDkHBS8/T5DztBnESlGyZnwLOl62iCP12/zop+bF+9nO+HSIAZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/FESnz5; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/FESnz5"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f55eff0so291317066b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 11:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789410284; x=1790015084; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1SXocK9P+hsO6kZIQPRw1L21/tKAk0Rlxc3YfvsUxyU=;
        b=h/FESnz50xYa8LpZCZtMojvaAOR+d552l3CpAivTGCvON7h1DdEt+RITU92AG88Smx
         DdBJfZiHrGRn28f23EWeakfYlGeaYqlcIIW5SjM95Aw1rXanY9kP0CNJmacE70Relw47
         H/4LxsVwMRhFcs244v0cZGhfTbDc5b9V3fgSVt6IhOVmB4C1ocjlHsfA7PoAZm1V3RNX
         /rT0xe250WKtx1f88QSbEaoRp/Vj3g3rTDL3hkbMqya/A98DcRD1pCAc+6YtRnUaVENS
         0iTGTLXQpYpdc9SeszvdCa86tInkVNtrCH35k9VBghOxe/6qKoaYgOp1wrgOUscR731s
         lx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789410284; x=1790015084;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1SXocK9P+hsO6kZIQPRw1L21/tKAk0Rlxc3YfvsUxyU=;
        b=mnS8CzbhS+mxfuFa0a1eM4zf8AnMF5Yoc43cZfoDMKx+/+g6QEUDTeD0qe9D1zt3SA
         5nF9l51lZMed48yOCUtRLcDMftMd9KfxQguZpBwgruVlJqvZYmxSWSbJLzUHu4F2/TCi
         LXEsMFL7PoLB4I+/yCoG8Tfj6kOboRrtfySBAh/xnJBibk4R1CED4mSCuasbzwC3IT6F
         RMdcp10H3pMBRsV2jqxeLkqcxYd/xFdjpxs2g6BHGWvR0ch9mKmZvCoEk6UqFpug/+6q
         COxik9zJgZI2PIIIdd7C5n91TZdwSZiXlHHRLtEVHxGiwpvhahVKuh0WFYCOQYG3sOPE
         okHg==
X-Gm-Message-State: AFuF++nMqdxTYk5dOQEUoVQ1RSmmA7hQZC3RgwR5V94jn0/IP3q04Ar/
	FRXlQ6xxzANfKGXFtyBP1YgS7t+8HjqwMeUGR0pwFgoGy4fOUkJ1M0II
X-Gm-Gg: AYBFou25GAxDqDHPDANEONztKdsR6E43+HiyY8JSOky/bHgcG9yDm2WCcC4wy+zSbkb
	iOlmUd7FhzgcwUUjQ3ITlz3c034lY5g8gLNXgg8abvuvZmvK5wKUNGdXSVx2Od/oaXjeJy4Ggsj
	Dsm+YWAdBtQ84waakVBYGXbOaLvbByDX+mBrQDrFp3F0xmc4OTsRHJiUKmG9ODRoNjId0vFdh6D
	MjHlK9Nlf+4T6km+CSA7LTElFA76VWgKEBTPCJTcU4t3A30PF+kKZV0bz/kl9DurlQI6LpGfXj1
	z+LscjG0RO5lAQvJ9E1agOyB2z9M65y5WU433mbvLzOojMK31cDPNX64AT1i7+mc2XDeQRKJ3HR
	w/y3H/Js3IG8Y3BxU7meNRkioueu1XukcFaQ5BOYzakiOEnMgf6jE6MqI6t7tKJvPUVMdG0DFUb
	bLhEfuhnUtafIIdopcEf19y+vtF+X6O8R91j54kFrdqtOUO/xVvUsp4Mn+TGJyDFll91S3emeoL
	/vJMhwqKZE99lZyja0=
X-Received: by 2002:a17:907:9484:b0:c29:47b9:965 with SMTP id a640c23a62f3a-c29b86f07f5mr241909666b.25.1789410283921;
        Mon, 14 Sep 2026 11:24:43 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29b1b44ff7sm174728166b.37.2026.09.14.11.24.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:24:43 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <ea2a1fbd-a505-4da9-a4f3-51721c914d5b@gmail.com>
Date: Mon, 14 Sep 2026 23:24:42 +0500
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Inline data is compressed unconditinally even when results in
 increased size
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com>
 <CAL3q7H5dn+NFK+At8+C76r=u==AC_ZivnrvyezwOoWLfjjq9PQ@mail.gmail.com>
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <CAL3q7H5dn+NFK+At8+C76r=u==AC_ZivnrvyezwOoWLfjjq9PQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> It's a recent regression, independent of the compression algorithm used.
Good that I remember it right, I wasn't sure.
By the way, the actually worst case scenario when it's just 1 byte.

Processed 1 file, 0 regular extents (0 refs), 1 inline.
Type       Perc     Disk Usage   Uncompressed Referenced
TOTAL      1900%      19B           1B           1B
zstd       1900%      19B           1B           1B

