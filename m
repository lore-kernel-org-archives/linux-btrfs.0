Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B6834D384
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 05:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414092; cv=pass; b=okk+Zlj/NsDleqNSdOBZP6QuxNJcdwqOZqAboDcgimWFMUnn+OKT4/xYRRNMjTq+BwjHo9CWv/Q7pBmnWCov35Jlsr/yP5EDsD1VOPlllbtCpE61IJrR08l64w/owl+tTOydoJb6Hr6iuiSsN5Gen60z0DjViX7dqCxZJkv95jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414092; c=relaxed/simple;
	bh=lL/yAhvJ+8yKt1vH2Tj53fvL2dhuQg60gR7vZqaWWLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jGL9V7Xy7mAuDmgqr4nZMC6lOn58lKKSIFtQeqyZSj4CJyWKDIMVZuxsDW9cHKM3+PiP3WS2Xz0H+X6tm3JZdf/d+ttNUwxf8oM7yg90vLPVVmuGRQEXBhW0JVP47u+1rtDcgtUAVpMcJmmCNhna1l1A0ovFAL9NT8Bv2mrc1Mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U+4kBHxc; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U+4kBHxc"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-482dd6ee390so1820000f8f.3
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2026 22:41:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788414089; cv=none;
        d=google.com; s=arc-20260327;
        b=V07JpEPvnwq+LUBjTJkTEhv3hp0vFDxc/MnhyKSQKnec0X1/WR7Ef8VGSXlfA1F88/
         wq6iFdbR1JuDikYHiRYStx7Z/hZ3w4owcVUefhsolSfmqTmm6k9YbKxGxZfWYMnvTjgb
         OvqSt1C3qimZ2GmE/UnEPWHj/NLt6q4HqVKH/1ikq8v5Nwc8v8KBJ1n7MZ3XbE69fxhO
         3Z//Z91ptfjo2PWvjqhbiUra4Upb51vAjx5jlVh92EcZzCHh4ou4LWLfFbzvv2LZYi9b
         SOhF/psSrgS1+BmZ72oQZMUkXJY6/IYWBkxdcYKi/c2F0MdF6OVdxujwq+lchmmWT37S
         KaHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DRfodrbSGRbubTr6Zh+anR+u1fTdKVvtVTg7k87brZY=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=d0e8fMdeXfgshOp54mTIkWLJwblsldzq4jY2M3J7olImttyTSYMZJTflwl6ULXi546
         SnqVR+VCmyM0AmyBJ4ayTF/HsePR8I7oabWCCWWVfGqZUCbLDokzprg0PPd3EjzN36ug
         VigEQ66bQAjT96xJ3id1ImJt3GZwYHZstAz/ZwjQOFYWVLE8qmkfhzjlN2HqJ5MQYdmW
         4t/nDIjyySGYXiZPO0wh7IBoGEsl42idpRyeXc7ZzOWUKLP9+GgvgTEAKXlrM0y8EoK7
         /q/Znu8JXDMOp3PQfzMJGI6EQmmmLVFKGgm0SsT7+CWAQMh512l2OQX1d0oCWyyen3MN
         0SlQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788414089; x=1789018889; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DRfodrbSGRbubTr6Zh+anR+u1fTdKVvtVTg7k87brZY=;
        b=U+4kBHxcAKF+GrovBPuXSUVClp/4Jp5sXpbyNFnH4Jj46+L3TVym3SiKUh97JhPUg0
         HOL2DXXMtB3L3rYGv9PrWc2Cr64hZmexvLviBxQ4oMxMXKzlqwABHizpia8O2vkqMSJL
         Pj/wF0+uW1yL8ZiRsu2qZlyYN8znwL/X1dIioWEhtlWfoZnVOuWqmWyyoeJrmaohqn3W
         SxoCKOaqp2hv2G2e0LDFcMwmVVRjjjV7qOwkSXrPP3JGJDD1o2iOunt+u3LKmUTnGqQm
         C2CLiVVnvLSaSXj49dZ2vUPbj/bb7puOuNNMhwZJDFguX2oRtPr1/Tj8aeVDNJJsqZ8y
         DNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788414089; x=1789018889;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DRfodrbSGRbubTr6Zh+anR+u1fTdKVvtVTg7k87brZY=;
        b=XymoX65P79lHqM64bp4MAvZ/h8uqaDFE3MnCxP39frxrdAqVHbgTkGkJ1xHTaW6J5k
         Nnpyqigv5133suFt6cpytzj1+HuDjXJ/amuZpes96VzaHxzHjvAsLu66EmY/2alMopqC
         k27RIPzdk40AgMRuuvvku+wyS67yhQk+Wk7vs5EkJKl8qotfPKMqvEQXSoBOZ/pYCFgq
         1VOpDd1WginFx0xHEgdfaSKzWq55MsCsFnVgVWjPDp9dqLR3jr53TyfGFIVVbKKODQ1k
         Oyu2fc5kJecrigLf1fTJCjJ3andGmKi9YVNncVNVs1GEV7xRQ6kRdf7UGGoQzheM6D16
         2LQA==
X-Gm-Message-State: AFuF++nU0UEVJ9N1XGbI70I/dh8fIh+fUfpfBjvhSb31TQ8W1Mc56Q6J
	7i7n9qiT3Nwskd5LVXvQWYt7rVFWT4HAD1RZs2krg5i7caNUyPCzUbKaaSsHkJ80MX08rbwr27y
	j86mCcwrx3yuI5tztsUozh2R4GzgTGa02NUzdnDlo5A==
X-Gm-Gg: AYBFou0y6TKruuWNxxezk40EWOmeBBFfytcpRVsO2TUIslMO3ZvNCc7HlA2ROJ8tHMJ
	SjMLtR+SgjkGPhMNDmUU2kTmnk7xBvQ2kTgHLl00nV+tcyI0UKaIvUVt7GglRivmZwpFwIrbdqn
	rBxFHoLVqOop9qQ9Mr5Mw6kgI8XPDFWp43as5xpOKtzqtZQ2vwwr/fBK1nqbXVaC0JnhWwPVGNP
	d6pEpztxEmAoaRTsSJg0FvZ3fxHxLJlP+j/mN7weCQ5PrXcXFigGU5W9x2lH/EyHBkkqjyzwjM9
	ZQ6TPGR+gC07fYD6dqhtsswY1Rg7FNrzWpIflbq9NKRAIq8df/e2TrI8exyAqISho9p5IpzJSNc
	hmeF1tBpzCABzLhLkS7VwvZvzwxIrMe2j7/bndnM7eA==
X-Received: by 2002:a05:6000:4b19:b0:47f:762f:32a9 with SMTP id
 ffacd0b85a97d-48488f0961bmr17424308f8f.12.1788414088806; Wed, 02 Sep 2026
 22:41:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761715649.git.wqu@suse.com> <2b4ff4103f157ffd2d7206a413246990b3ef2746.1761715650.git.wqu@suse.com>
 <CAPjX3FfrPcXGPur5RNtGtDzMMNMNp735v9vKaO-KxFHn0TqvPQ@mail.gmail.com> <a8a47490-1a67-4765-a713-1c01b8d3d8d8@suse.com>
In-Reply-To: <a8a47490-1a67-4765-a713-1c01b8d3d8d8@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 3 Sep 2026 07:41:16 +0200
X-Gm-Features: AcwNN1VZVgKqywBcNNIt-O8_FBDvsVBCtJNDzxACzzzC3UBPxBYjbZdpMga3Sbc
Message-ID: <CAPjX3Fd-qS1LvUWK=y5rafvzhVe6pAWjUNjyY1qy4=mPvstfXA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] btrfs: introduce btrfs_bio::async_csum
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Sept 2026 at 07:24, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/9/3 14:37, Daniel Vacek =E5=86=99=E9=81=93:
> > On Wed, 29 Oct 2025 at 06:43, Qu Wenruo <wqu@suse.com> wrote:
> >> [ENHANCEMENT]
> >> Btrfs currently calculate its data checksum then submit the bio.
> >>
> >> But after commit 968f19c5b1b7 ("btrfs: always fallback to buffered wri=
te
> >> if the inode requires checksum"), any writes with data checksum will
> >> fallback to buffered IO, meaning the content will not change during
> >> writeback.
> >>
> >> This means we're safe to calculate the data checksum and submit the bi=
o
> >> in parallel, and only need the following new behaviors:
> >>
> >> - Wait the csum generation to finish before calling btrfs_bio::end_io(=
)
> >>    Or we can lead to use-after-free for the csum generation worker.
> >>
> >> - Save the current bi_iter for csum_one_bio()
> >>    As the submission part can advance btrfs_bio::bio.bi_iter, if not
> >>    saved csum_one_bio() may got an empty bi_iter and do not generate a=
ny
> >>    checksum.
> >>
> >>    Unfortunately this means we have to increase the size of btrfs_bio =
for
> >>    16 bytes.
> >>
> >> As usual, such new feature is hidden behind the experimental flag.
> >>
> >> [THEORETIC ANALYZE]
> >> Consider the following theoretic hardware performance, which should be
> >> more or less close to modern mainstream hardware:
> >>
> >>          Memory bandwidth:       50GiB/s
> >>          CRC32C bandwidth:       45GiB/s
> >>          SSD bandwidth:          8GiB/s
> >>
> >> Then btrfs write bandwidth with data checksum before the patch would b=
e
> >>
> >>          1 / ( 1 / 50 + 1 / 45 + 1 / 8) =3D 5.98 GiB/s
> >>
> >> After the patch, the bandwidth would be:
> >>
> >>          1 / ( 1 / 50 + max( 1 / 45 + 1 / 8)) =3D 6.90 GiB/s
> >>
> >> The difference would be 15.32 % improvement.
> >>
> >> [REAL WORLD BENCHMARK]
> >> I'm using a Zen5 (HX 370) as the host, the VM has 4GiB memory, 10 vCPU=
s, the
> >> storage is backed by a PCIE gen3 x4 NVME SSD.
> >>
> >> The test is a direct IO write, with 1MiB block size, write 7GiB data
> >> into a btrfs mount with data checksum. Thus the direct write will fall=
back
> >> to buffered one:
> >>
> >> Vanilla Datasum:        1619.97 GiB/s
> >> Patched Datasum:        1792.26 GiB/s
> >> Diff                    +10.6 %
> >>
> >> In my case, the bottleneck is the storage, thus the improvement is not
> >> reaching the theoretic one, but still some observable improvement.
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>   fs/btrfs/bio.c       | 21 +++++++++++----
> >>   fs/btrfs/bio.h       |  7 +++++
> >>   fs/btrfs/file-item.c | 64 +++++++++++++++++++++++++++++++-----------=
--
> >>   fs/btrfs/file-item.h |  2 +-
> >>   4 files changed, 69 insertions(+), 25 deletions(-)
> >>
> >> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> >> index 5a5f23332c2e..8af2b68c2d53 100644
> >> --- a/fs/btrfs/bio.c
> >> +++ b/fs/btrfs/bio.c
> >> @@ -105,6 +105,9 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_=
status_t status)
> >>          /* Make sure we're already in task context. */
> >>          ASSERT(in_task());
> >>
> >> +       if (bbio->async_csum)
> >> +               wait_for_completion(&bbio->csum_done);
> >> +
> >>          bbio->bio.bi_status =3D status;
> >>          if (bbio->bio.bi_pool =3D=3D &btrfs_clone_bioset) {
> >>                  struct btrfs_bio *orig_bbio =3D bbio->private;
> >> @@ -538,7 +541,11 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
> >>   {
> >>          if (bbio->bio.bi_opf & REQ_META)
> >>                  return btree_csum_one_bio(bbio);
> >> -       return btrfs_csum_one_bio(bbio);
> >> +#ifdef CONFIG_BTRFS_EXPERIMENTAL
> >> +       return btrfs_csum_one_bio(bbio, true);
> >> +#else
> >> +       return btrfs_csum_one_bio(bbio, false);
> >> +#endif
> >
> > Btw, what are your plans with async csums, Qu? You marked it
> > experimental here, but I don't really see any reason to limit it this
> > way. Shall we just go live?
>
> Oh, thanks for reminding me about this.
>
> Too many pending features make me forget that async csum is still
> experimental.
>
> I'll send out a patch enabling it soon.

No worries. I can add it to my series while cleaning up around...

--nX

> Thanks,
> Qu
