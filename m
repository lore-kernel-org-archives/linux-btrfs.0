Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901187;
	b=uSD2ZVlUOiHwDh4oR/v5nF1loy6FdMUeSdpOOAhCx8tvoHVDtqzccx3iyz3wGXNpLLz7
	 Eh6SgGUbmnZNr3lh1Aosn9wBT28x6PxKEO/lrilrMYKR89bVYmQ9TPYPujtSdeytzrygP
	 DuyUkSkSeX/XKdrDF3vsYzlZ1/J5LWXqR3OeteneOggJhg2BWVr7cdv7XMzi34v5ahsGE
	 I4ZPNXZLot3KoCnvGRcfaF6i60ZjTalEsW5F7StXSZN+sLFXEQveagyxavPfry9gCv+5Y
	 wUWzN+l7udgZCrlMZYyk/sb4P+GpafnSPXxHpEa9uY3AUoKX2pjIvA/SCMWjz9yesNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901187;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=s9wUzlGzFd1RKxNPzo4f2vgY8WDmbO0ienfaNsKgswQ=;
	b=sgUSOK7CXlz10zPQCPwc5PryU3IzL2kzm/y8GURUOMt1XwND+/Fi7HHol0yXitnvItSq
	 5MCeXCErKPns72obdmMadoA3R+MIwlovZtXTXRpdtVBqg/H6wiFzaP0+EDC/H2aZadcKA
	 ZRDIvx4OHCz0OsJlQwU/NztYkQqOp08GbjCjMnzbK4HsoOeN8P5sEXpwPbvKy5b5Udq5a
	 CK7Fsnt4mfzH6rSUxaPgsQAzT4QC08lSo68ZIRX+VphlSnhm1MWkS4j9mcmTqG5SwaAy9
	 O/OX6YY4XsJ5XblyUNAqDub0BUISKyvO2Eua0U5DnstrW+hHp3fjwlphqZT3yJckb9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=L52lqOd+;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EBjyFGQT;
	arc=none smtp.remote-ip=202.12.124.150
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD65606A31B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 17:53:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AD65606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=L52lqOd+;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EBjyFGQT
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id B59B01D00023
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 12:53:05 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 05 Nov 2026 12:53:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793901185; x=1793987585; bh=s9wUzlGzFd
	1RKxNPzo4f2vgY8WDmbO0ienfaNsKgswQ=; b=L52lqOd+0EZ+TaDZBpZa7ySIMu
	ZLyFejqS7YCK0NpjtVPvikznSi87vJV0rk4rlNOdYH0jSrLGnQq5oljOZ7affDT9
	OR83JTIvI3IaB2RRVzMG0Z6uREBVNa6Y7VyoUzb9vGh7QzxndSC8uSR4FsveJssL
	LpygKH+WZjTjGUbM0pE6GGpfPsZgm8PUv/Ug9uBe/UlTPwP+4kh30S9Hz6GZI7ih
	U8rMrl/R/2wXHuBzP/0jNZdaAzXRpiyJNMFst8FcB+C89wdfOzf80ldjChLPS72A
	Ej5K8lL4A/qUOpQsnX4HUxNCyc8ycbIgdbi7tHYr5rmzl3hy+DrRY94K9KsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793901185; x=1793987585; bh=s9wUzlGzFd1RKxNPzo4f2vgY8WDmbO0ienf
	aNsKgswQ=; b=EBjyFGQTET75iQtGowZv6QOaXqP0fDpqCcC2Qr0Erq6yha4+eqU
	HqKrSReAJGaN9WMoWNGxs8zEk5Pr6cJ56kbomxeCV8XySvswUiWTQ+yC+eE9ykhP
	U4LJvTi6RLPc0Xx+Om5qM9tqfBUyzCklBzEXQX39zPJI6AZt3xyeQFBcwtrS/7ir
	Oabn4CunGbSPSVxCRo5s4HL9mpERz5GSzF1YBsptUKqjim/IV9byOVjpLcXjaPD5
	IEzNmjoGHC4akqvIMclelJXVA0E1tILB1W9zI/9UcQjA0W/EgYj3cYBAoNHXqwa2
	Nb54OrdWfszhWrTZXu5A/JXVyRuZzvAKr8w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793901185; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:aWxSwlSIH7XnFEAO6f5upXlP/NgMSQjSmV8U2aRUWemKeVM
	JMoSTN98cxh+SpfmSFUH4R/HtWMF+z6yy5r1rfwvUCtCp8jlfbmIl4Kru9SdYGSn
	ACMe3bmdrvWbyUFUqDvwOUof/cpcleTAy0Ye56NjvB0ZyXCjPESKFLyL7Ku/6n8a
	4xal7vPOUqEcmQ9SBfyZM0A541lvlijgBin7Iwc792RBTOpZ+UFPYrmhzPh0SPlx
	MYBk4HPUPgr2m/LcZVKfyufl1x/ZBmZ3VEM1NbQO5ED6EGlHPSU9sWR6Y8vQbmdd
	PoT4EeZpM8ririrEz0x2ADqO5vdjZhePz9joBHA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:kbtP4yKDe2IW2ddvtqEcK7mKtWDMvLvep9lgju732A8=:F+86diZaYWeQCXUjfSM6Gzo48+V4OZfPuP9ypSFG0nY=;
X-ME-Sender: <xms:gcLsamrDWdErybHbWXOIUPvHFzmc4Nbi8tp7NOxlUFlHfwmWCw0Ymw>
    <xme:gcLsalEmI-w_S-eEIX_-UwntApexJZwu_pvg-1I4n-awn4MOtUP4MRo50B7Tnek1c
    WmH47y5pKOGH-tAbZU_hR-D2NlTwy1YmsJUECpAOL-if2Ch_S5rXyVq>
X-ME-Received: <xmr:gcLsar4SF3mAFsjctUKg8YZqliFimb2iCS0eOBZV-8SX7RCK_ltgN2nH>
X-ME-Proxy-Cause: dmFkZTFNkbq3oflfiKRMQKnm7iDgMmA5pLBcg1U9Q+sh9sAX6FMeh2mj5oSt50GTBILcHQ
    NtFy08k5egVC03iKPjToZhWSSwYzt9ZsVwyyRgc5eettMrjSddaT9G39r2Nx6FyjP4L2C1
    CM7a/Q0X2ckQeoW65p3kKsAnFtwGCMjddFYK1kVbMQO49Tet+AZa2UjT29LXQiXGFDZz2P
    fFtXz7vS8Mb62xjS1zZyhO658FlPfrjFDYmxbEObW3VWGMtbSuqa04AV7QgX5dfCtFxvm2
    1g2I+mILEE/tZ1E6Fil7N4F32hcC1hm+780dfnCKYPw+6xh/+2XfxS6lqELzGEaFVx/0tX
    aROFiTbRjdDjjzeHCxJ99l+G1LLPvmiLu2+FflT4C0Bn4s8NqI/oi3KEXe+RQFWv2S47jH
    xJcxdutWDr1MRGF0Q5vak/fR15XSdUkALk+4MvTYTwxsCs+Y/p93TGoRHex8KuUT1GBDMz
    aas2EJUYbT7Gr/DLeQqDGl7iKveJeuFn07ThrO9ZwD5OszWM0tmJbP40yYBgvi8Ya7srMT
    0mO3B7ZxJyC5PVqSeYCY2ZHhQKJKutpVX6uVhj3Nn7xyfE9sa+aeRlacdLIl9THB4qgt6y
    wOEpMwFaZ/HJLE/8Kb4IUsZJtYFG1NaIDt2kcAsdeMAmZnj5kGcPjnOLXEbg
X-ME-Proxy: <xmx:gcLsateVncwvoRm17flKdWdle73LNBZcwI5NCqKgz8dYfv30Wb0LMw>
    <xmx:gcLsam4vkrsfxIuDt7moQaEadDdAhrpG2ZWmctX-tIUSPn2cQTURCg>
    <xmx:gcLsai8HuIGchFqmV30bpSVTA8UZJpfH4x68GerkQPefqJV5hskRjw>
    <xmx:gcLsagEhQU9P_nc5hHg6RZ07HbNZ1iFw4rw-TAnyfOai9CsPdEoZeQ>
    <xmx:gcLsagZez6HtWGLtrKFPRs7wik1G5GFZsNihD0bZ5tPQNW3NrQW87tDL>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 12:53:04 -0500 (EST)
Date: Thu, 5 Nov 2026 09:53:21 -0800
From: Boris Burkov <boris@bur.io>
To: Breno Leitao <leitao@debian.org>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Atish Patra <atish.patra@linux.dev>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: bug: btrfs: direct IO fallback racing with in-flight direct IO
 fails fsync
Message-ID: <20261105175321.GA3915752@zen.localdomain>
References: <auxv7Tg0xSq5yHmb@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auxv7Tg0xSq5yHmb@gmail.com>

On Thu, Nov 05, 2026 at 04:07:49AM -0800, Breno Leitao wrote:
> Hi,
> 
> Atish reported that arm64 production hosts (64K pages, 4K blocks) that
> keep VM disk images as NOCOW files on btrfs, opened with O_DIRECT, on
> 7.x based kernels, and it still reproduces in linux-next as of
> next-20261104:
> 
>   Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
> 
> Besides the message, dio_warn_stale_pagecache() records -EIO in the
> mapping, so the next fsync() on the image fails. The message blames the
> application for mixing buffered and direct IO, but every write here is
> O_DIRECT: the buffered writes come from btrfs itself, when it falls back
> for writes that are not 4K aligned.
> 
> It does not look like a regression, since the fallback never waited for
> in-flight direct IO. 64K pages make it easy to hit, as a folio then holds
> 16 blocks. Since e9b7b9d9e78e5b ("btrfs: use IOMAP_DIO_BOUNCE flag
> instead of falling back to buffered IO"), COW files are exposed too.
> 
> I was able to come up with a reproducer that hits the issue within
> seconds with 64K pages. With XFS on a loop device backed by such a file,
> standing in for the VM, XFS shuts down on "log I/O error -5":
> 
>         https://github.com/leitao/btrfs-dio-fallback
> 
> My robot identified this as the root cause:
> 
> 1. Task A has an async O_DIRECT write in flight to one 4K block of a 64K
>    folio. iomap invalidated the page cache before submitting it, and the
>    inode lock was dropped.
> 2. Task B issues an O_DIRECT write whose offset, length or buffer is not
>    4K aligned. btrfs_direct_write() falls back to btrfs_buffered_write(),
>    which does not wait for in-flight direct IO, and dirties another block
>    of the same folio.
> 3. Task A's write completes. kiocb_invalidate_post_direct_write() finds
>    the folio dirty, so invalidate_inode_pages2_range() fails with -EBUSY
>    and dio_warn_stale_pagecache() records -EIO. The next fsync() fails.
> 
> ext4 fixed the same race in 15cdefd0c052 ("ext4: drain in-flight DIO
> before buffered write fallback"), and ext2, ntfs and exfat are getting
> the same fix. Doing the same in btrfs_buffered_write() for the fallback
> case makes the reproducer clean, and I can send that patch if it looks
> like the right direction.
> 
> This patch is a copy of the fixes above (from other FS) and make the
> reproducer happy.
> 
> commit 16cd17d1e8205f9f86b8da0a9b1ccefdb2665764
> Author: Breno Leitao <leitao@debian.org>
> Date:   Thu Nov 5 02:59:39 2026 -0800
> 
>     btrfs: drain in-flight direct IO before buffered write fallback
>     
>     When btrfs_direct_write() cannot do a write as direct IO, because the
>     offset, the length or the user buffer is not aligned to the sectorsize,
>     or the range has compressed extents or page cache, it falls back to
>     btrfs_buffered_write(). That dirties the page cache without waiting for
>     direct IO still in flight from other tasks:
>     
>     1) Task A submits an async direct write to block 1 of a folio. iomap
>        invalidates the page cache in the range and submits the bio, and the
>        inode lock is dropped.
>     2) Task B issues a 512 byte O_DIRECT write to block 0 of the same folio.
>        btrfs_direct_write() falls back to btrfs_buffered_write(), which
>        dirties the folio.
>     3) Task A's write completes. kiocb_invalidate_post_direct_write() finds
>        the folio dirty, invalidate_inode_pages2_range() fails with -EBUSY,
>        and dio_warn_stale_pagecache() logs:
>     
>        [    2.048568] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
>        [    2.048574] File: /tmp/diorepro.JTCKpJ/block.img PID: 260 Comm: kworker/11:1
>     
>        It also records -EIO in the mapping, so the next fsync() fails.
>     
>     The two writes do not touch the same bytes, they only share a folio.
>     With 4K blocks on 64K pages a folio holds 16 blocks, so this is easy to
>     hit there. Meta's arm64 hosts with 64K pages hit it with VM disk images
>     that are NOCOW files on btrfs, opened with O_DIRECT. In a test, XFS on a
>     loop device with direct IO on such a file gets EIO on a log write and
>     shuts down within seconds.
>     
>     Wait for in-flight direct IO before the fallback dirties the page cache,
>     as ext4 does since commit 15cdefd0c052 ("ext4: drain in-flight DIO
>     before buffered write fallback"). btrfs_buffered_write() holds the inode
>     lock exclusively there, so no new direct IO can start until the write is
>     done. NOWAIT writes never get there, as btrfs_direct_write() returns
>     -EAGAIN for them before falling back.
>     
>     A reproducer that keeps 4K libaio O_DIRECT writes in flight while other
>     threads issue 512 byte O_DIRECT writes to the same folios of a NOCOW
>     file got 1123 fdatasync() EIOs in 10 seconds on a 64K page VM, and none
>     with this patch.
>     
>     Fixes: f85781fb505e ("btrfs: switch to iomap for direct IO")
>     Reported-by: Atish Patra <atish.patra@linux.dev>
>     Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f978c6524aa03f..2017a96814d857 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1334,6 +1334,14 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *iter)
>  	if (ret < 0)
>  		return ret;
>  
> +	/*
> +	 * A direct write that fell back to buffered IO must not dirty folios
> +	 * while direct IO is in flight: its completion fails to invalidate
> +	 * them and records -EIO in the mapping.
> +	 */
> +	if (iocb->ki_flags & IOCB_DIRECT)
> +		inode_dio_wait(inode);
> +

The explanation and fix make good sense, thanks!

However, thinking out loud, we do know that if we have started the DIO,
we will have an ordered_extent from:

btrfs_dio_iomap_begin()
  btrfs_get_blocks_direct_write()
    btrfs_create_dio_extent()
      btrfs_alloc_ordered_extent()

so perhaps rather than waiting for *all* dio on the inode we can just do
some variant of btrfs_wait_ordered_range() which only waits on dio OEs.

Anyway, that is an enhancement for later, and not necessary for a fix,
so I would be happy with this fix as-is.

Reviewed-by: Boris Burkov <boris@bur.io>

>  	/*
>  	 * We can only trust the isize with inode lock held, or it can race with
>  	 * other buffered writes and cause incorrect call of
