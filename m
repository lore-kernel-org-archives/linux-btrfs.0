Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8E83DD52E
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 09:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774345022; cv=pass; b=fW72BpB572CAzFJB01reeLvKHvTpIwNB72K3kssN3/MSOkwO3cbavxslI8DwrR2+V0HUXEbqnD6qXMnJ0n+gO+ueZEGGG4L77bdcA50PtqZy2IlATSci1FyirZfFb/QjZkvCx+o2ec0bnHml4gE35wRo8djHDg/6JCbNVn6me4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774345022; c=relaxed/simple;
	bh=JV481TRX/Dx8xXrjNX9tltXZwt52q0seBxFVj0eKdEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9G5EI4++jGNi3eLQ50lMZW6AIjORqASM5oNdbeC+doU8Gd5XyYh/DgzdGlYIPkTSUlr4e3G9sI5juBcxv4TPGsy8gd9cqKxSqa963bxqUvdXTspvD5VtNQvxF1xbM5ZW5v8u4eCvL60wcMNWNubV0hS84CHeBhmZyhZbr5FAa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LR/xx7SI; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LR/xx7SI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439b9cf8cb5so1331684f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 02:36:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774345017; cv=none;
        d=google.com; s=arc-20240605;
        b=LxpA8fdJVI+6p5qS9e6L4nfD6DSU4iYrafDdbR8Os5k0lX5MmIxNqAgeGYeaMRTmEi
         djgPdAuJhulKVYd9SgA40pFtyRILVKvJDG/+8UdtXX2SKjn10fPOFvB4mcdWuGJilWge
         esOEfkttCIctGpwHDez/1ghVXF+jdhmfuLVvWJFvaW5xE//2B05VNhXfNXjH71VPWC5C
         nxA/1qn4H1AfhzMRnqYxzZI+owqACsTR1JCKSuujN1Y3aXO8a+MsxffMplvU6ECKEQ4E
         /992Kvi+xh1GlxhOczPCclURTdznAD/zvvxcZJi2esLRaYPRgYlPCwllvYOoE4mLLv38
         8iVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ub5wN9amaO/DAAvFXES2RrEzabJn769sowl2xsPaADQ=;
        fh=/dEiaTEP9P4aG/y7+Iws6MPj00i72YkbY8Y9SDUzumc=;
        b=NlK9TOB7tMeWqAyZk/JDHlRHfOMU8IR6qvr3T/FHgCkavdVu2YMSpBUfOiZnOehdL7
         xrAldE41DE9mivimRDU7MoSIUNdz7LW30nMbIx3mVfEdvj9YEz6uNngOPpJTYDT1lfsA
         YuXsWIL73Z3M0eKXRD91QsB5wPlR57MPi5QwTUyC0eW4kwhaRTeleEYpYD8gG+lOKfpG
         2lA84NeNPk4BzFW6FmiWoTdScCvfo7eHtUQn4RCIuR+LdvW76HOyjlTltO44+9l87qjD
         9iX2ZL/qGbs1UVfvJFcr8gTgmHXRP+RAGRRptNTD329rYgHHkOlIL2/ww0ziRxcoIAel
         Izvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774345017; x=1774949817; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ub5wN9amaO/DAAvFXES2RrEzabJn769sowl2xsPaADQ=;
        b=LR/xx7SI5kncamtwfDMCZsdLzL9v2Vv+1wsvvSda4nYW33Dgt20Mwkq1nG278aI1h3
         QfOJpdmD6BSzA3Oqrr3lvmc3YSishR6XKUjKNqErydpJB/08lKKtkRrR7fjOn+K20yA0
         f2mEuXbkDWSUeT+FDPsVFKUMP73alN7cNy8NHTMcCLqsrGqwrl6mvm8vZbYK+o4a/+wM
         pZF8CyL72yj0UlFTqcGIoq4aj2alY/7p46cWd+QrxCNXGrZjAoJ5kZDzZ94RZEocUmOM
         Qx86u2UQbXXm6eYKnp6FD9sf2RK4r9xew6NLUI2bkBgA5jHBRygvDTuFNmq4DGnlVjIy
         eCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774345017; x=1774949817;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ub5wN9amaO/DAAvFXES2RrEzabJn769sowl2xsPaADQ=;
        b=Uq60R3t1CxXslv6zbqQSSz5hFAzKhjbI40FBCIbsStPNd9I4GJ74vfGN0AmKC/OhKI
         WfI5M2lXBuOaS/ER25J10BBEXvo3PFVoVOng5aHrKsEEK36pRV+BKXMl9rcw/PbXtZD3
         WadFT35SJDXuFnpQM7Mc687gUkIpEFEQffE4/OTMkZYiUH4j8deVSRgkaREGd6x5BZEM
         1HSKKpNa7MWBBrfAPsV0gdI7lKt9mXpWHDlVckBuVeQrZpRuiZB8IdKILWTDyQMvVdBk
         vhi9K9IQwEtJXVSWCsYEqI5PfeJSZCZ6c+FyQuwZpxDejtaupEcanTWRazzavqvY9oAQ
         QARg==
X-Forwarded-Encrypted: i=1; AJvYcCXfn3xdIYuY3sIWIdrXYNpeh1vnQere1VXactOPKfz7TggOtRzwQMyAfdW5JP8sySUI60mqeAfjQovwTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFhBPp4nqBHaN1xI2HsXDHWsMDHqNYZ+talJvpSMqkEBNa140Q
	8MaNszfEufBBPf0u4mf+B9jIASQXQGAGdYdPgRLGNA9QuoJ/Aov3Jfc2My1nM/M0+MI0dffqb45
	wnsEA7gT0QMK5YTAQET8bMIbZoQkoI+NQbFs6RXXM3Q==
X-Gm-Gg: ATEYQzwegEq9KaWI2oH7kkwTxfDmu3CUi6alf2GKiRgtMH3Hhix+8HouavkTOMApu9N
	95S8hcUSEpHwzrY2eneOT4qUEF8vvEgHT/bukydOucFb5KUrbwSIXCj+ut31inMgDAGIndx3GXk
	glkfQu94LN1Sl05RL+QmOFyTyT3QRCWLejLcvfG6GhBu5OcUq7no8hzLH8W+dGyYA0oEfGKV97X
	Ppu69H8QvcHfrtbv37LfeDLwhRDfeoJaPbMV5L3NMtiLHVSgNwVjDID1d595VcEAQG7Zcby7Fn4
	MhRRvVaWUrIqAq+pZ+HAeTP0a5FiWMcLMTEniTu9NL8bmscUWY5md/kAi09ym5UVlGS6qyzSjeX
	MEdpd
X-Received: by 2002:a05:6000:22c2:b0:43b:3caa:a20e with SMTP id
 ffacd0b85a97d-43b6426b68emr24185879f8f.32.1774345017497; Tue, 24 Mar 2026
 02:36:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-33-neelx@suse.com>
 <20260208151126.3129410-1-clm@meta.com>
In-Reply-To: <20260208151126.3129410-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 24 Mar 2026 10:36:46 +0100
X-Gm-Features: AQROBzAcrSb8NLZh900STza2vyMCNtV9c0i8E1h6tC3jXGjIJZj-4KJUOFxGeHU
Message-ID: <CAPjX3FchHbyQMUqogjyf4tUpT49HnO==_E6Uj=Zz7BXYUhJvsg@mail.gmail.com>
Subject: Re: [PATCH v6 32/43] btrfs: implement process_bio cb for fscrypt
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 8 Feb 2026 at 16:12, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We are going to be checksumming the encrypted data, so we have to
> > implement the ->process_bio fscrypt callback.  This will provide us with
> > the original bio and the encrypted bio to do work on.  For WRITE's this
> > will happen after the encrypted bio has been encrypted.  For READ's this
> > will happen after the read has completed and before the decryption step
> > is done.
> >
> > For write's this is straightforward, we can just pass in the encrypted
> > bio to btrfs_csum_one_bio and then the csums will be added to the bbio
> > as normal.
> >
> > For read's this is relatively straightforward, but requires some care.
> > We assume (because that's how it works currently) that the encrypted bio
> > match the original bio, this is important because we save the iter of
> > the bio before we submit.  If this changes in the future we'll need a
> > hook to give us the bi_iter of the decryption bio before it's submitted.
> > We check the csums before decryption.  If it doesn't match we simply
> > error out and we let the normal path handle the repair work.
>
> Hi everyone,
>
> I'm running the btrfs for-next branch, along with the encryption patch set
> through my AI review prompts:
>
> https://github.com/masoncl/review-prompts
>
> I'm working on some btrfs specific instructions, but hopefully these reviews
> are already useful.  I've kept the headers to make it easier to double check
> that I'm actually replying to the right email, but please let me know if any
> parts of this are incorrect:
>
> commit 2b25418669e46c939ff864b1144e2c27d618920c
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: implement process_bio cb for fscrypt
>
> This commit implements the ->process_bio fscrypt callback for btrfs,
> enabling checksum verification of encrypted data before decryption and
> checksum generation after encryption.
>
> > diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> > index 3b420866f3b82..c28f3f53bad28 100644
> > --- a/fs/btrfs/bio.c
> > +++ b/fs/btrfs/bio.c
> > @@ -300,6 +300,34 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
> >       return fbio;
> >  }
> >
> > +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *enc_bio)
> > +{
> > +     struct btrfs_inode *inode = bbio->inode;
> > +     struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +     struct bvec_iter iter = bbio->saved_iter;
> > +     struct btrfs_device *dev = bbio->bio.bi_private;
> > +     const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
> > +     const u32 nr_steps = iter.bi_size / step;
> > +     phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
>
> Can paddrs[] overflow here? BTRFS_MAX_BLOCKSIZE is 64KB, so the array
> has 16 elements (64KB / 4KB). However, nr_steps is calculated from
> iter.bi_size which can be much larger than 64KB for merged bios.
>
> If a bio has bi_size > 64KB, the loop below will write beyond the array
> bounds when filling paddrs[slot].

Indeed, that's very true and I can easily reproduce it.

> > +     phys_addr_t paddr;
> > +     unsigned int slot = 0;
> > +
> > +     /*
> > +      * We have to use a copy of iter in case there's an error,
> > +      * btrfs_check_read_bio will handle submitting the repair bios.
> > +      */
> > +     btrfs_bio_for_each_block(paddr, enc_bio, &iter, step) {
> > +             ASSERT(slot < nr_steps);
> > +             paddrs[slot] = paddr;
> > +             slot++;
> > +     }
> > +     if (!btrfs_data_csum_ok(bbio, dev, 0, paddrs))
>
> Does this verify checksums for all sectors in the bio? Looking at
> btrfs_data_csum_ok() in inode.c, it verifies one sector's worth of data
> (one blocksize). The function is called with bio_offset=0, meaning it
> only checksums the first sector.
>
> However, the bio can contain multiple sectors (iter.bi_size could be
> much larger than one sectorsize). If the bio has multiple sectors,
> shouldn't this call btrfs_data_csum_ok() for each sector, or pass the
> actual bio size so all sectors are verified?
>
> The existing btrfs_check_read_bio() function loops through all sectors
> and verifies each one individually.

This is also correct. Both points fixed this way:

--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -343,11 +343,13 @@ blk_status_t
btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *
     struct btrfs_fs_info *fs_info = inode->root->fs_info;
     struct bvec_iter iter = bbio->saved_iter;
     struct btrfs_device *dev = bbio->bio.bi_private;
-    const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
+    const u32 blocksize = fs_info->sectorsize;
+    const u32 step = min(blocksize, PAGE_SIZE);
     const u32 nr_steps = iter.bi_size / step;
     phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
     phys_addr_t paddr;
     unsigned int slot = 0;
+    u32 offset = 0;

     /*
      * We have to use a copy of iter in case there's an error,
@@ -357,9 +359,13 @@ blk_status_t
btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *
         ASSERT(slot < nr_steps);
         paddrs[slot] = paddr;
         slot++;
+        offset += step;
+        if (IS_ALIGNED(offset, blocksize)) {
+            if (!btrfs_data_csum_ok(bbio, dev, offset - blocksize, paddrs))
+                return BLK_STS_IOERR;
+            slot = 0;
+        }
     }
-    if (!btrfs_data_csum_ok(bbio, dev, 0, paddrs))
-            return BLK_STS_IOERR;

     /*
      * Read repair is slightly different for encrypted bio's.  This

Thanks!

--nX


> > +                     return BLK_STS_IOERR;
> > +
> > +     bbio->csum_ok = true;
> > +     return BLK_STS_OK;
> > +}
>
> [ ... ]
>
>
