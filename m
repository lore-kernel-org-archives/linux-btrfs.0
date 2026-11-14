Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794624528;
	b=k6tEnhxyZ0lu0C0EffoSlGVhx6zZCk8P6cEzZ2SXAK+PMQVnNAkek8eXsFQNd8elWJTl
	 f/CvsVksiGtD1E3bQMaVAnTeCwPP6mCNgL6wk6MQZFG+bMjIr5Wd0eEqNLW5+U0tezmEm
	 E/aIkqDgLtl2LHrMlzYsNN/RbM7e3vRgGXh7iv3bS02jRRtNm52L8WxQP4F1dLJ/Or6Bv
	 paT8+B3fIgZo6s12AsMXuQDGFH9Y0lBK6jUPo0PHOemWvOfXYVhNOxckiyFckSInNcqDS
	 MlFkKQEB8hfplSX1jiyNKAJt59UOA9oZhlVXrtS2uBv+E2UvbY9O0NLSMZ023TCVqNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794624528;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=te1chXPJKHQxJDguKPBCfQg+bfiSUq4ZKiWOXGVbEI4=;
	b=PX2XUoXkIgm99LQuRinjMlIX+6K80vOtKIBDtf8HPxkRZwfRDmKauv2T1TUBYbGT0Vb3
	 t8Lfj26Guc74ELASlBE31RGw+P7PjhYSgslG439s3hnXB0C7gGStC+48Ft8OUd/+YQeFO
	 hUfsc0V7jw2WP9dKUkbxCUux8GwWy1u0vaWMUHQzNTrJqXIOpH4Sgl0tffzl17mcOl2tH
	 EiTy8bmMMbpXMpKVPOIG+UpGJCFf1XymQ+vFtxn1kVWIsjzDPqR+Ew+zlGzb/ZY7J+zEr
	 CNHmypQ/J0DKimkuEf65PEAQpUIuF/rS3rmLM3RNRjAV/hTqYeABoUYDQl2ASsgHVUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iYXXIZAW;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE410606A32D
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 02:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE410606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iYXXIZAW
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so20621865e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 18:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794624526; x=1795229326; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=te1chXPJKHQxJDguKPBCfQg+bfiSUq4ZKiWOXGVbEI4=;
        b=iYXXIZAW2wY38PuMrY+hZpENMAL2GgyeXHkZUdybwAbScAnPPR2C7KF+0FV5TW7vhK
         JudGmXnOeA1DbIQ2H/QQrR5pt5S18T/gRrsbUq8WgmaD8zGqFYmQV3s7tHJluiqBPn3f
         MQO73+nCG3J4DRVJgRq9qNY1wyHg83/5x3g7XmRiZeQIdKuTiMRQ8tmP4kbdCe3+25oZ
         +tEz4MLyszM3tx8DAGfw//AMZdkhrcyH3rHUfusny7QuqR4+eKO3M/kOXL7rydlULZ70
         oWFy5OQjnPAHMc3CTxYl4mac5d8Y57IQEscqoUuActBZ81E2RdCmALEpIigMl5HfeUZk
         FqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794624526; x=1795229326;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=te1chXPJKHQxJDguKPBCfQg+bfiSUq4ZKiWOXGVbEI4=;
        b=EivsK0d/7nAefvmVlq7XfGnVJ0Irk/zo5+ac1NtdXtbF+NpZEDb11Hewar7ww7sZVK
         WqLdxDe1mA3ZR3qEBhp7C0o156qMv6DYEyoGob6GhqBUhtBhptCZS3bTQTdfFMIDG47K
         zuAnuLZ+cxMNtNkm0lv+U+m0Q4HEDBvosYy52MIvLpq8ZBgJkqNyLVYb2Jx3A4EbDVWD
         Av/sXtOUjXO7ah9wns3Kd4olHgFBSaucQawk3GR1h+JhtmadsMaTxx0tRWE8IcANRTJV
         1nTjDk4MiuzoRt59RKkqc0cfwUPJn6/gxgPS2we56ZykewFBM4N++W2hGMpIXXClFMSM
         aTwQ==
X-Gm-Message-State: APuU4Z/wNDuSExPSQUmIs9AQBLLjhSp8T8rA3ORyGAIVZWXwIrGVwbOH
	XFVtyMb8e0Paus7DCq9szE38Bm80I3P/FCe55/NpXE3Mf2UBR/4+DyS/sW8kpQ77wVo=
X-Gm-Gg: AYBFou1+vhHRRhb8GSjyO16F2ETb04FCjJvpMVqCAYkLxGy6JDckxY45RsKNfGxr7VU
	PfU5+SExPeD4YlWEUb0hTazx2Aq6mTQ1NcaPQrQHNtuDUI8+w6YW8/Wt4nLiib98kPNx3HT1lpP
	QYZ/sE5PwrBaD/VhNKbNAKqW/5I/6JodA7zqVUH+EJYH2lgNoKscKlOfLAmLaQmahqsEKmstVLY
	MLdTqHcrSLPiZhVlRWwOAMy0fQC+/cuygI2Akl2Kq/LNmZhNzbLTM8IRKhKNuie+MqwoWJt5sGK
	WG6y7RlUeD/KAiGOSaCew2PS1SPpMyrCR5YuCQP0B7MoqDyZO119+LmdpY9Py/JJJ8BsvPxENES
	sPmbuDb0zxJ3vh7dCawt34SnJRapACegNfQ/jXSVkmoCZlSl3yqOjxl+VC8XDgTi3ErADMBi81E
	4W39guDCh0ianpnXFx1x3OKhHPgjG1VE5FBO+vwy4+qnysSLuoNAL3pkY9R5dhsbdEH5vF9zyV6
	yn1Og8rQhTLElVXuiH7jUWpucexr/dlI0IHslg8vLMTFg0PsQfe5MPCppScV/NWsfj3bpKVC5kY
	67ZDA91axHl3M83V3pnyD18S1SyssJQJ8jsHS3wUu/7Hwb7xIDCRp7dDiFl2bwDhncuF2jIRjUQ
	fgKAD7J4XSF6b5bWo1Hqe6qWDHVDAwiWhLUE7ikgoqB70CEE8Q6mIW9sSW67XndUz3rqdyufcBG
	LZShPl
X-Received: by 2002:a05:600c:8b76:b0:4a1:fae5:f2e2 with SMTP id 5b1f17b1804b1-4bb55a01a31mr85550885e9.4.1794624526029;
        Fri, 13 Nov 2026 18:48:46 -0800 (PST)
Received: from maskinen.tail34f753.ts.net (c-92-34-161-199.bbcust.telenor.se. [92.34.161.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm202481355e9.4.2026.11.13.18.48.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 18:48:45 -0800 (PST)
From: Elias Jernberg <eliasjernberg@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: speed up steal_from_bitmap_to_front() with a backward word scan
Date: Sat, 14 Nov 2026 03:47:30 +0100
Message-ID: <20261114024824.710267-1-eliasjernberg@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <50cfbe7d-e925-447d-9131-bfd019bf97ea@suse.com>
References: <d829648c-3fc2-4f6e-ad07-ffce8be579a8@suse.com> <50cfbe7d-e925-447d-9131-bfd019bf97ea@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

(Resent to the list in plain text; my first copy was rejected as
HTML. Qu, David, Filipe and Chris already have it, sorry for the
duplicate.)

On 2026/11/14 11:11, Qu Wenruo wrote:
> Would it resolve the latency problem on 16K page sized systems?

It helps a lot, but not fully, and on top of my patch it adds nothing
measurable in this test.

I measured on an Apple M5 MacBook Pro (16K pages) running a 7.3 based
Asahi style tree, btrfs with 4K sectorsize, space_cache=v2,
compress=zstd:3, discard=async. The test writes a 4 GiB file into a
fragmented free space (about 1.05M extents), removes it, then times a
buffered 4 GiB write plus fsync. Two runs per kernel:

  kernel                      time (s)            MB/s
  neither (older base)        36.1 / 33.6 / 29.3  119 / 128 / 147
  your diff only              4.47 / 3.20         1106 / 1578
  my patch only               1.28 / 1.23         5107 / 4881
  your diff + my patch        1.40 / 1.34         4308 / 4559

The "neither" numbers are from an earlier measurement on an older base
of the same tree; I did not build a third kernel on the current base
without both changes. The other three share the same base and config.

A sysrq-l sample on the "your diff only" kernel still lands in
_find_next_zero_bit() called from steal_from_bitmap(), so the bit by bit
walk is still the hot spot, now over 32768 bits instead of 131072.

So with 4K bitmaps alone it is about 10x better here, but still 3 to
4 times slower than the backward word scan. On top of the word scan
I see no gain from the smaller bitmaps in this test (slightly lower,
within the noise of two runs). I have not measured other workloads,
64K pages, or anything where the extra bitmap count could matter.

Two notes on your diff:

1) fs/btrfs/tests/free-space-tests.c has its own
   #define BITS_PER_BITMAP (PAGE_SIZE * 8UL), which would need the same
   change. I did not run the sanity tests with your diff.

2) The tree I tested on is 7.3 based and still has the v1 cache
   load/write path, where io_ctl_add_bitmap() and io_ctl_read_bitmap()
   use copy_page(). With 4K bitmaps on a 16K page kernel that copies
   past the 4K slab object, so for the test kernels I replaced it with
   a memcpy() of BITS_PER_BITMAP / BITS_PER_BYTE (not exercised, the
   filesystem uses space_cache=v2). for-next has removed that path,
   so this only matters for a backport.

My reading of the numbers is that the word scan is the part that
fixes the latency on large page systems, and the 4K bitmaps are an
independent change on top of it.

Thanks,
Elias
