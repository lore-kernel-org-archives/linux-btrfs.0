Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4159F2E7F20
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 21:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781127893; cv=pass; b=OyduHilzN1Cz1g7J9+gV/Yz7QQxmfKj5tDftzo5oAjdNJquoEoKuK5O9QjTVI680OWu+l9kYK+pSLSuobRciUa2WjHFAcJB+V9PKcK8neH/2iwcUkCM2ON25nk8CAOZ7tLlvOnob4bZMvCcpmP9ftH4VEgWdEortlMfQ4/KGZlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781127893; c=relaxed/simple;
	bh=6liXjIwaHNEhZKqn4H1gsphqzwMdWBEXQ1wJmF5lNNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oCqC22yZjhh/JPbbP4meB4PxqXOZdmu+wauWgwruqGRDe3q7PXNdCe5YjRuH0x6InbFka9Zp+8ugM3TiilUeJAFsIHrZytsDKKXaKTVxBUryzrdAPJ9cmkzJNUj1oUP1QayJmZkrl+o34E6MdtpO7aUm9WOnWPtMUZScw6bueUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=dn8jILd/; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="dn8jILd/"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8422524cb38so2565675b3a.0
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 14:44:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781127891; cv=none;
        d=google.com; s=arc-20240605;
        b=NzqdHf3LBUKSrJOxtTOjfa8gyQ4Ws8KMLZp/hhkMw3OfR97cDM8LFZCP8Ge3MUb1Ow
         4aheMPa18g4VbBsIk00r8IJWAnDKzDluztKaJMEXFTcbBJlCoB4q6m7g2k2hSmkkeQG3
         x4U3STzDJnLFWZPdxHZdh0nLb+0Gi7NQtqmegjW26kyRb25iEfoUemtz9Wl5jbIUCjug
         MQpeqB2PL+eTm8DEq1OKiRnJfQWYDKTgZpQDf96hnAzAs+QHT6/kXBCJiiJJgQ7BkhhP
         /4IX4l+AqZ8rXRejzJ8Jiu4jz6VZrSfuwv9OizwdUh0hlzKBr2xGw+cZua+y/sWN8qIk
         WuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cUHgsVczJSA93yZ+fhYXexxpS9C4rpRnSUSwhXFUiPg=;
        fh=nwRpmqtxqzFv2jRlun1+ZTn4xZMY1q4dMunv8oj8gzs=;
        b=V65+tieZ9araA/EnLWfRJqNKmqr40wLKl2eyKbRGdXknoGBYFEoPsdy0VqoYX62NL2
         sanuKlfly823Zrkugp9aIST5fFHkH72FrbNX2g2zbd/xEK7HAFDPAEBnO6pAICIJjDv4
         idrgvr28Y4uV93CuTd1f3+xXWfX9bqySwugT/6PQHZYKBSK6AVtFlemnaqzdSdnxxZSQ
         QzzdNdk5X56MlTyrLo9MZIxWVaX6adUEp0FzEWyrqC5e5tfZAmQntF5pKHbBhpSFyZsh
         feRj9NS4YYk9MEE3wKy/jHuAbtLV/IN4qXX/CNjdLKFr7+2JNv1orKkklntSBPBe41g4
         Dyig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781127891; x=1781732691; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUHgsVczJSA93yZ+fhYXexxpS9C4rpRnSUSwhXFUiPg=;
        b=dn8jILd/JPH2DJMo1MXisdIfgZC2MlIBFEJpy8NWgOGO6xcPzh2dOo6N/B2ISURvEx
         c6xiTYupTOoa/6/fqj3yaWKdSCz8VJBgIM+EcknRcOW2EnmclcFOTekh2awRENYQfhm3
         k7nQHpNaum7Kkvs2H+lLJR5YN11E8FBdyshFcFzQNPyhMUERx4vazgjPiQ3mf6oF25jM
         HgoIYMmN7f9cB7MCzGMJs9YCtGFBxUqEJ+DNtGimC4HwkMJYoAK4bF4gtHwX1l/oWUzA
         pgHss+WbccrFyB1NmrXklOrex46EAUgVWJOSOqbHpPzeXQpdJyBR1F1dVTfdF0v8SnOP
         XyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781127891; x=1781732691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cUHgsVczJSA93yZ+fhYXexxpS9C4rpRnSUSwhXFUiPg=;
        b=cTEqxphtlXhClSUebs66gui1XNw4e38px0R4bBtkK8k+yMnqPzqnXBmMWdeFWcU3cN
         eZEQiHPjTHnLAt/E9dL1rXgddUo8K9gq776TQG7bqgx/8V2YTY8Haa5lRHbei5755yCv
         rOek2nhrIxLRX8Zr8yCWdI2SSeIB3Eb6ukgbzV5LN+47t7NZIpwnpCNgiB+ipCNhFtH/
         mC8pEGiUTyQiayFq+IwkM9aejtIPBtnwpApRDwoE5+rmAx8x012PyOTLOA9lJo+3xSES
         25eeDoSuh4iLF4W8UjudoDzwbsjI+aTs42doEo9gXINb8SvhgetneN4iAEsmu0MRsvnI
         P8Gg==
X-Forwarded-Encrypted: i=1; AFNElJ9lOfeEh+nTMMdYWsCVCcIUV+HqHaI/pHYmOw+MJlFTcr5xpNSTnyBAsAvs6yggUp+rBHcmT/XpJQINmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKS+fEFGf3s1NfHr6Ej1/e7q1idvJdsAWD/ZDBo7ajF91hK44D
	rQDj48AYVrddYtQZWdDEfKNczLxSCoXt7GEIScB7FvJsk1LOuiWCBlIFjZhhnpsPY7LKvHDvVqv
	CiRk5r1WW3jKgzuWVv+lbiULo6Yp/P5/4U3ZAinA7
X-Gm-Gg: Acq92OFQWVdGcRJ7assMY5I3RtlMAm1lpJ/UC2E6DzfJ9vKvcQHFzHQtcoxax3E6yPO
	+1/PCVr7KCCjarUd4eW09dztN3PsliNLlAt3G5zNrFHoIAqGLlpd58oRFN8cMLn6wjb0zG6zWn/
	38z20gSmorDkzW4txuDAGZRNbRFXh2W35hr0qyKZ+6uEUMVQybZF05R1w0uXXKuqhcBw4cBrOmm
	ts3/nAlm+GmMOaCq5Xbd7CxmBk4p947Hk8GmtZQ5PHideU7TmoN8ddXCs5pbOaposzB4K0X+0uC
	lWLCXVw8dr9oBwBaaNNpDVHsgOR4MTlh6YIPTDwD4m61GQ==
X-Received: by 2002:a05:6a00:a13:b0:837:e9cc:d46e with SMTP id
 d2e1a72fcca58-842b0e95e0fmr28679856b3a.21.1781127890609; Wed, 10 Jun 2026
 14:44:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610172926.844265-1-xmei5@asu.edu> <ac0ae1f0-8c8a-46de-ab9b-bdf7bfb1c799@suse.com>
In-Reply-To: <ac0ae1f0-8c8a-46de-ab9b-bdf7bfb1c799@suse.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 10 Jun 2026 14:44:37 -0700
X-Gm-Features: AVVi8Cd6sQBmL7_FqbmSZ4WUC3VDyxs_uJeGMLy2rfCKpdUS_up2jqTzP1NIXZU
Message-ID: <CAPpSM+Tbq1YeQQLhMKRnd+aVB+7yo9mxkjie-D==_aHWTRB9xQ@mail.gmail.com>
Subject: Re: [PATCH btrfs v2] btrfs: reject free space cache with more entries
 than pages
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, 
	Josef Bacik <josef@redhat.com>, Weiming Shi <bestswngs@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for your review. We'll have a bug report for the future bugs
before sending the patch.

Xiang

On Wed, Jun 10, 2026 at 2:30=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/6/11 02:59, Xiang Mei =E5=86=99=E9=81=93:
> > When loading a v1 free space cache, __load_free_space_cache() takes
> > num_entries and num_bitmaps straight from the on-disk
> > btrfs_free_space_header. That header is stored in the tree_root under a=
 key
> > with type 0, which the tree-checker has no case for, so neither count i=
s
> > validated before the load trusts it.
> >
> > The load loops num_entries times and maps the next page whenever the cu=
rrent
> > one runs out, going through io_ctl_check_crc() -> io_ctl_map_page(), wh=
ich
> > does io_ctl->pages[io_ctl->index++]. But pages[] is allocated in
> > io_ctl_init() from the cache inode's i_size, not from num_entries:
> >
> >       num_pages =3D DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> >       io_ctl->pages =3D kcalloc(num_pages, sizeof(struct page *), GFP_N=
OFS);
> >
> > So if num_entries claims more records than the pages can hold, io_ctl->=
index
> > runs off the end of pages[]. The write side never hits this because
> > io_ctl_add_entry() and io_ctl_add_bitmap() both stop once
> > io_ctl->index >=3D io_ctl->num_pages; the read side just never had the =
same
> > check.
> >
> > To trigger it, take a clean cache (num_entries =3D <N> here), set num_e=
ntries
> > in the header to 0x10000, and fix up the leaf checksum so it still pass=
es
> > the tree-checker. The cache inode has i_size =3D 65536, so num_pages is=
 16 and
> > pages[] is a 16-pointer (kmalloc-128) array. The load now tries to read
> > 65536 entries, io_ctl->index walks up to 16, and pages[16] is read past=
 the
> > array:
> >
> >    BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc (fs/btrfs/free-sp=
ace-cache.c:420 fs/btrfs/free-space-cache.c:565)
> >    Read of size 8 at addr ffff88800c833a80 by task kworker/u8:3/58
> >     io_ctl_check_crc (fs/btrfs/free-space-cache.c:420 fs/btrfs/free-spa=
ce-cache.c:565)
> >     __load_free_space_cache (fs/btrfs/free-space-cache.c:655 fs/btrfs/f=
ree-space-cache.c:820)
> >     load_free_space_cache (fs/btrfs/free-space-cache.c:1017)
> >     caching_thread (fs/btrfs/block-group.c:880)
> >     btrfs_work_helper (fs/btrfs/async-thread.c:312)
> >     process_one_work
> >     worker_thread
> >     kthread
> >     ret_from_fork
> >
> > free-space-cache.c:420 is io_ctl_map_page(), inlined into io_ctl_check_=
crc()
> > at line 565, which is why that is the frame KASAN names. The out-of-bou=
nds
> > slot is then treated as a struct page and handed to crc32c(), so the ba=
d
> > read turns into a GP fault.
> >
> > Add the missing check to io_ctl_check_crc(), which is where both the en=
try
> > loop and the bitmap loop end up. When num_entries is too large the load=
 now
> > fails like any corrupt cache: __load_free_space_cache() drops it and re=
builds
> > the free space from the extent tree, so a valid cache is never rejected=
.
> >
> > Fixes: 5b0e95bf607d ("Btrfs: inline checksums into the disk free space =
cache")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>
> I'll add a Link: tag to the reproducer at merge time.
>
> But I still strongly prefer you guys to submit a bug report/reproducer
> before sending out a fix.
>
> > ---
> > v2: add more details in the commit message
> >
> >   fs/btrfs/free-space-cache.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> > index ab22e4f9ffdd..bbc4db7fe74b 100644
> > --- a/fs/btrfs/free-space-cache.c
> > +++ b/fs/btrfs/free-space-cache.c
> > @@ -555,6 +555,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io=
_ctl, int index)
> >       u32 crc =3D ~(u32)0;
> >       unsigned offset =3D 0;
> >
> > +     if (index >=3D io_ctl->num_pages)
> > +             return -EIO;
> > +
> >       if (index =3D=3D 0)
> >               offset =3D sizeof(u32) * io_ctl->num_pages;
> >
>
