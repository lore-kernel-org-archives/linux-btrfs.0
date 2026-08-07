Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C383847DFAF
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107614; cv=pass; b=ibJuut62nHH5Bwwx5ybe1CfHADOvVXNwiuHQZgdeBGy4wRNgPGNqyb/gXgUW+nrX7LWCs/iPOr4g88YBEoYaFv5x0/ci4T+PwZUEeNrvsIbh80exzGzejN8hIdFS2A2lxFeNN3IPDepWMe4ZZKF4x2vSvFe/nXJhGNeWNwtOleE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107614; c=relaxed/simple;
	bh=+MmtmpxboSDDE35HHZ4aD3TzxhpUHa2I6zb40jgLWuY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=XQQXmHYbrwRg64DHgA+y11WljB2oPRk5Ztslwl3Uo/k5YbfiJPUq21SdU4nvTS+afiJGXbe5CLRmhkZz5UAfaBGr9TGZe4RUAfwi5uHY12qlbyR8n77FB9jsG5ZS+Evihgp2oCt9TId065ISgQoOkAR0udLEhZcmy0nnw1OtNAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BArRiSAp; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BArRiSAp"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69c600f76ccso4743081a12.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 05:59:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786107596; cv=none;
        d=google.com; s=arc-20260327;
        b=p4s2LsM4h38aik814yw8Emc9DJWLLtS21l/2j5g5RkCBY8AkJKvJQ7JVmTgfBtZIS6
         i6wS+p3oMq99wZeR/35bq1+d/4EzKCrhc/v0XmNuQQDxyrrKQVjuP6YEgF/j1p3TugPV
         2wjO4soYO9kaQwgUKz0Zc/X1XMVegTGMMTIcMzL0PWzFwKoZBOQH2zggoB7yJhCHItDU
         sm9qnSOi871gkhQF5Uj0nb4BLjgpC7yUQMC/BImKEso930cAM7iZfizfSiB1G1FHc0yY
         NvHnoAymZ4A42AqeQNUNUqSMD06t981wJbWB4LJAToLoiffboA7fS1/nArUMgMA4/bjE
         fDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=JA9lhS8SGqYyHpI6nXihRLfPZPaS4m8uGv9mshFPhsw=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=oBTQh7LDPNba924ugUPYDmDDcZ8xci34q82NsbzI9GSWe70WXpAKt0i+txbWabLYuN
         F2/bIOdRyEjCr7oo1320jy6XScW8hAGn5OhhR9bDhZg6vtKGlI7bciaRbigmtt6qJ6Q4
         GFIVV7jyyVruPoUVeVTKEMUwrcLWZ2+iNhsSVulXDGC91imdisPZDbT12/btTgD6KwjV
         Tf+KWxFWMFkDwNAax/xr7ScPe0oG2pyCRFUZc2vKHOAhQxkEaiG5qblPEly7ZdrEUq99
         p+G8oZImenKxfNK3hHOcLcu2F4pLp+cXIEgGmM37+bLBahpAvsxXIM5S/dEF7o9Z+Kf2
         4Mkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786107596; x=1786712396; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=JA9lhS8SGqYyHpI6nXihRLfPZPaS4m8uGv9mshFPhsw=;
        b=BArRiSAptwa4Yg9CmRPApwATmHqeCSvG9VendUSNeazArIV5Vm8aiDQgeXxBm2+eKG
         XIt2ThSa9ULVQKxAMwIEtZvFmJgZJVHLM68Yom/lwiWs9uMiQA6UIiC3mr+jjdsMTFOa
         KxZh2f3+pP++mUXCCyWMy0V45GQJkai3qEuJVUhSG4gXl3oqX9klTeV763pQ55s1kno5
         gfKzco/u1zXwqwkWmC3IMaPpmYuj4XKVGwu/+miHeH/xbHm0B5lRpQl0a2eOheDfY3KX
         YAz7iCr5ZaPegwvHuCGyvcVCNv88/00GFN7wqaN2hEQ1KKZDNCw/8BbkV1DHLqA3OuTM
         01fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786107596; x=1786712396;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JA9lhS8SGqYyHpI6nXihRLfPZPaS4m8uGv9mshFPhsw=;
        b=TFTBOEuYMAYxehHDVcHsdfEe83IC7pvgdm5sv4qYYBWy56gcs9z5Xd8Y266podcRUB
         Ugsmhz5ct4SfcSVYRpCS9Fz50pNVUwCoPJ6K1MGjZRac6q6iogoZcQa8O6sovIxCy8Ah
         DkV5Bt1WOmCqAXpJsVAXrxnsDzlKDwSPF0VPs0TCUUVAMOWixdLvNjH+QcLVpfaHpwTX
         +d/Lq8ZQ8oI2aHKYup7WTWjB60lso0HWyyhNsapd0SBnZixvc3OgQvsH3MlebhTJVxiA
         4q1Pg0f+Jxc/FjNdDdyadpINQo/tndjBtuz1nng+maG4lzdspyvAD+jH/e3oBRKskO/k
         uXOg==
X-Gm-Message-State: AOJu0YxrgA6ixKSyDr5gXMnUb1A+AJCzXssCUeuGZpL+qpol0g9Pvnr0
	OKvBROMrI3BM3x8qYla1fukhkjzp8EUgb8xumeixWFbyyE1l9rz16oUQwIhclDHjjLdNlUc9JWu
	prRPI5o4XgEyijdjen9JkRCCRS9/r8wLWcyCX
X-Gm-Gg: AR+sD10OrZNbyspMMzn/Nu98u3gyUDYp5N1lTmkUbNWf/qALNTE4o3xhY/wx1BJ2Pcd
	qWQz54b6xaSCDTAFY8PdkD/nhKkgaHFCjU6ScntDIZuD7U7WMwif7TjtLt6aIBIK9BB3kN/sq3F
	33WDI0Yb0mFs8F2gfRSUeq/6g7CmRQu97Hr4saJGxDgfKGzsA405gf4AiQZ+hvJ1oQ0tEvjXffY
	OdSyU+Zf0de+TxywjmxSwuwd9ea6lx8ORer0kQlmF61etpNgGB+rhQKNt0mQybhrrTOeDMx8ONu
	9sATu+O4tceAwAAbyo8clhxAM9UU1gav3icVINEFfdS9H6bgJK8JP3IBsLMQP8kMOD92mDzN0JQ
	vYg==
X-Received: by 2002:a05:6402:3506:b0:6a0:9cb5:4f33 with SMTP id
 4fb4d7f45d1cf-6a14f132857mr10166414a12.13.1786107595604; Fri, 07 Aug 2026
 05:59:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Martin Leitner-Ankerl <martin.ankerl@gmail.com>
Date: Fri, 7 Aug 2026 14:59:44 +0200
X-Gm-Features: AUfX_mzXF3VhyCrRjekaoUIBLUq2eEIEj3gY-JCVfJakjPZMn3Gc33ptRM1J0Ms
Message-ID: <CAAFOosY-roFVTBfviuFoL=1ahOKOerWbEidZW5Z66u2+XP5ZJg@mail.gmail.com>
Subject: [ANNOUNCE] oans: duperemove fork; FIDEDUPERANGE cost under memory pressure
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I've been running offline dedup on a large btrfs tree on a schedule, and
while profiling duperemove there I found something I didn't expect: once
the working set exceeds RAM, hashing is no longer the bottleneck. The
dedupe phase is, and by a wide margin.

FIDEDUPERANGE byte-compares every candidate range before sharing it, so
the data is read twice: once by userspace to hash it, once by the kernel
to verify it. When the tree fits in the page cache the second read is
free. When it doesn't, the compare falls back to cold reads and ends up
dominating the run.

Measured on two non-reflinked copies of a Linux kernel tree (189546
files, ~10.5 GiB), deduped inside a hard 4 GiB cgroup limit so eviction
actually happens, 10 interleaved rounds, median wall time:

  hash + dedupe   13.8 s     vs   179.7 s
  peak RSS         121 MiB   vs    243 MiB

The second column is duperemove v0.15.2, the first is my fork. Both read
the same 16.7 GiB, and "btrfs filesystem du -s" reports an identical
on-disk layout afterwards, so the work is the same and only the read
pattern differs.

What the fork does is read each dedupe round's source and destination
ranges (at most 32 MiB each) sequentially in userspace immediately
before issuing the ioctl, so the kernel's compare hits warm page cache.
It also stops calling POSIX_FADV_DONTNEED on data it just hashed when a
dedupe is going to follow.

My hypothesis for why this helps at all, given the kernel would read the
same pages anyway, is that one sequential userspace read of a 32 MiB
range is much friendlier to the device than the compare loop faulting
pages in as it walks two files in lockstep. I have not verified that
against the kernel side, and I would welcome a correction if the real
mechanism is something else.

Two questions I would genuinely like input on:

1. Is the cold read path in the in-kernel compare something that could
   reasonably be improved in btrfs, e.g. with readahead over the two
   ranges before comparing? Doing it in userspace works but feels like
   the wrong layer.

2. Are there workloads where prefetching like this would hurt, for
   instance on a system already under memory pressure from something
   else, where pulling 64 MiB into the page cache per round evicts
   something more useful?

The fork is at https://github.com/martinus/oans (GPL, same as
duperemove). It carries the benchmark methodology, the raw rounds and a
script to reproduce the numbers above. Full credit to Mark Fasheh and
the duperemove contributors; it is still their engine underneath, and
the fixes I found along the way have been sent upstream as PRs.

For completeness: much of the fork was written with AI assistance
reviewed and benchmarked on real data before landing. Dedup
still goes through FIDEDUPERANGE, so a userspace bug there can waste
work or miss a dedup but cannot make the kernel share data that is not
identical.

Thanks,
Martin
