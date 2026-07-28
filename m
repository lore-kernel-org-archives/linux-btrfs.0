Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE453D3D11
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 08:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785225960; cv=pass; b=fgbrPmn3At2oSuDJCqZHx7o+AFHX6/sJVrx+jMez0k0hylSvOd/suD5vXTBh1Je70zu7ibXFXFd6kdrnMTVijzdhUEKGK5h5ENmuwTLmtF/ZuypRomcqz/Urn0ec74ShaFpsQGgUScjCdREd/0f9p2Zm0IX/n+Lz0HPvh03pi+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785225960; c=relaxed/simple;
	bh=MUTKe3vgk3OYipgQAj01lcZUTW7Bp98VhC7DJlNmuPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Je99kEzmmcRfH08zlbbLtjwrk9CZ015f3/9BdE4++9lWZKW+Nco0UXCgkS/iEkfv3XLitvK62XZtDwpmyyhEdiNPyg4W55URalbs8zRMAxkNoZY5nlx9ckGhOtlkMFCy+CxW8p8WT91f6T9RKCbmM9BRLU8Kobdq3Crlos852nM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AqXlMamw; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AqXlMamw"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso2560540f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 01:05:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785225957; cv=none;
        d=google.com; s=arc-20260327;
        b=k/0llac0kpNg+sG22Wc7LzExvhrxWTwBl5K1dvUbwRgPKd1iGwOcMxBKh++ARXjA4C
         pAzKT00sGALsaGwmiWpNpSa1hqOY9Z4rpEP4LO7oPmcHsk7mAwix4AGTAIULXZx+mJGj
         I2euldppNd538Wg4eXPp0nLoAn6kYsiotGCWTLKyBnUtEMfxtcr+cocjXCvw12kYlfQd
         QrKw0p0V8ePLjNYkM9cAsFYcPeZz3FG4NZ1fR0GmGQ2VIhjy5IF8/0/w75I10mFiqE2t
         ayLHnHsxcffNeLXlOeDBDkE1e006XgSNUPjjD+4mAj1RHxt461Cj5NmeqVBasYK9Zlri
         lwpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MFW/PjvuguQ/9XlTC2uqhs/NNJnubbPxBggxrHHjhkw=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=r0alxnYUp/SkSOCkmGOmUrkO8ZPETGiDaxOFr5HY2GLV5j+ZhhOQ033RYPWQjjhV7Z
         iC9k8qGKyltNaychZAhnsbHnHCL01/d3rRQ/MZc7Q2sL3RlinCDU9kvm6h/bJy4OhvZO
         ZZlhiGLXacfVohqrP6rdUiIeQ8RkX0D9g+95hKKiHAwvm2HX6b6Gy8qfMWIYrc2f5JIQ
         RN4KdhgIeIUca6UFFIFVL287u14rEgM90r20C8kbzhkLflVO5bM+YW167pvu00OGwYdn
         57IijUuK+FKf40fOc7t7WmnwO3hdD8VCXVLV9u99nJNJsvg7jB5auBFggXLTdrmk8toS
         AXCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785225957; x=1785830757; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MFW/PjvuguQ/9XlTC2uqhs/NNJnubbPxBggxrHHjhkw=;
        b=AqXlMamw/HK1Q9VNlZpclhLZws3XWPREnBvyFdpv1fE7KKVR7hfc9fGPrxSiZLQtAz
         H0B5ifISjors27NMvqR1nlrsgg5+s6HuB8wwkZDd1TaAO6qVvD+hyPpi7BSBS3F5+EMR
         lY30quiLLUc8t2tClQa2Jow29Vwtc1DqB1OId4ycdGIgRr6fceyMmWJZQIryeHo3WNYy
         IduBY+OgSeW+Rc0eT4G1GL0NxCYfYgrtbKkVcyS3au/s6/Op2ng3yfTWKxQiYJjNX/7N
         j/PIGWMXpou/liuIXskvqpU6nOAmycDxPhbzbRYaA1fDKK6JM82nSLjb1Wb2mKNF545L
         TWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785225957; x=1785830757;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MFW/PjvuguQ/9XlTC2uqhs/NNJnubbPxBggxrHHjhkw=;
        b=djt+MM80GfgjuUot7en4dCTiitUg6PDD0UiqEu+DHsFCIjfwWfAwxlqa7wO0MpU5mD
         L95oanOPPyUeUyJ8NgtzblfQtgisc99IfP635YvkDsccBMPvBuRX922hDduWxadecYkh
         TuhBeXauOck9vvZgZNXQJN7LSs18FK91yvq+kD/u+s+tr9/oNd0gjeMcU7u+W9SdZULR
         wOZZMGEUzim6S7+qOzbQkShHjZcvC6ReMKbSX7gC/SOTdeF+x7J/G7WOK+gOkjzA0njr
         FjGlioWKb+tuTAdNJh7z0puVNfjZuZz+gAVHLEsCcIibU2JHUlHQBHMeqY75+NiRfGBh
         40Rg==
X-Gm-Message-State: AOJu0YyGHdEwZqbJl1aQ55TG7StebikBfKV4dvtfTJOd9yw7tPKrz8BI
	S8zBBe/a+ZTlkWIvIc47qj70VtUPEW1kZ6pnBOXX3Xm0S0nQBLRD0jOiVlAMhORg3KBA7fhSi3n
	ZTop1kVJInmZI4hEU8+5W7piACwL9YZIERugt9P/XEYGAiF7dLrD8b3rnZg==
X-Gm-Gg: AR+sD10qfMcHXBvyo1csMyKpQIyfxAIwzal/0eJPSC/AJ+IIOKjxNdOFfp0F2LKRnGi
	Uso3klOkisO18w3azgWjfucv8cC9Pf4n275Omjn7fUwUm2+DeiSB/8aret2cov+eni46Cl4DA4G
	J6Ah/vINT9nFR723uiBRm+x4o9T1oMEzDhxrr9Xh3s2TAEld8u2CKrK2ofuveQn6+TcbL3vhif1
	I6flNHnfP24b/e0NnOKaxtBDPZPfNSEYhEJX7Ppd3IYtuXX3YSjnPL4z9EU9vpbEdoppHzVcghM
	bnomnuhsMqY8yMuNTdrvFWLoEPeczFhUcm/yLp2Ba4xmIftjf2DF5G6QQoU=
X-Received: by 2002:a05:6000:2002:b0:47f:6d4e:4cdf with SMTP id
 ffacd0b85a97d-47fb1ee755bmr1381464f8f.58.1785225956649; Tue, 28 Jul 2026
 01:05:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785220613.git.wqu@suse.com> <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
In-Reply-To: <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 28 Jul 2026 10:05:44 +0200
X-Gm-Features: AUfX_myszNZEUn4lA1zRJkzftkLh5F28scViMlKOhPUnAOLFYCP7P1V_cbKctgc
Message-ID: <CAPjX3Fez2At9ZX1ga3YJt-rs+TGcXsV8WfJLXcmr64-4gjVQnQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: use proper inclusive end in extent_fiemap()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jul 2026 at 08:46, Qu Wenruo <wqu@suse.com> wrote:
> The @end parameter for all extent io tree helpers is inclusive, but
> the call site in extent_fiemap() is passing exclusive end.
>
> Fix it to follow the common pattern.
>
> Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/fiemap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
> index ba6a360074c0..2f2ae0b76799 100644
> --- a/fs/btrfs/fiemap.c
> +++ b/fs/btrfs/fiemap.c
> @@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>
>  restart:
>         range_start = round_down(start, sectorsize);
> -       range_end = round_up(start + len, sectorsize);
> +       range_end = round_up(start + len, sectorsize) - 1;
>         prev_extent_end = range_start;
>
>         btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached_state);
> @@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>
>                 /* We have in implicit hole (NO_HOLES feature enabled). */
>                 if (prev_extent_end < key.offset) {
> -                       const u64 hole_end = min(key.offset, range_end) - 1;
> +                       const u64 hole_end = min(key.offset - 1, range_end);
>
>                         ret = fiemap_process_hole(inode, fieinfo, &cache,
>                                                   &delalloc_cached_state,
> @@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *inode,
>         if (!stopped && prev_extent_end < range_end) {
>                 ret = fiemap_process_hole(inode, fieinfo, &cache,
>                                           &delalloc_cached_state, backref_ctx,
> -                                         0, 0, 0, prev_extent_end, range_end - 1);
> +                                         0, 0, 0, prev_extent_end, range_end);
>                 if (ret < 0)
>                         goto out_unlock;
> -               prev_extent_end = range_end;
> +               prev_extent_end = range_end + 1;
>         }
>
>         if (cache.cached && cache.offset + cache.len >= last_extent_end) {
> --
> 2.54.0

I don't really get why you left out these:

@@ -680,7 +680,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
                goto check_eof_delalloc;
        }

-       while (prev_extent_end < range_end) {
+       while (prev_extent_end <= range_end) {
                struct extent_buffer *leaf = path->nodes[0];
                struct btrfs_file_extent_item *ei;
                struct btrfs_key key;
@@ -809,13 +809,13 @@ static int extent_fiemap(struct btrfs_inode *inode,
        }

 check_eof_delalloc:
-       if (!stopped && prev_extent_end < range_end) {
+       if (!stopped && prev_extent_end <= range_end) {
                ret = fiemap_process_hole(inode, fieinfo, &cache,
                                          &delalloc_cached_state, backref_ctx,

Am I missing something?

--nX
