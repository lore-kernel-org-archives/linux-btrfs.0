Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB047549363
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085894; cv=pass; b=qiHHtRmPd0gjCm+n4uQBaTOMDFMIDiBEnPRCqmTR9k0zc1tQSm2nhLYt9j+HC35DqWaobg8zqb8BAWLSEOwrCA3LRrNdUcVqH5cmFdnj7tAGOU/Op6JLh0vcITR9H3CC6UfNlVRJKf98UWBBkxIl0mZ7Ux+C53EICmI0lZMhW3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085894; c=relaxed/simple;
	bh=HmtpJAgxyWzEhX/Kivuz0S1dXZLqzMoX1yiDfvCKtBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=It8b6am6O8usZm09DsE+zmIRJPUI+1AZlfyV71i9KUXPBuJ2hE0+O4dHktj0JXaYAr0lxB4n6JU0XlgiUNOccD8Eubx4cuVc8idqNErOHzGdl4wGnzF2YpN+GoOk1bZrVbag90GLBPEBObNaQvzpmvGpjnIo3Ml2F2MvLgK+xxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dGqCNwBa; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dGqCNwBa"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485b1d2874fso1563996f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 07:04:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790085891; cv=none;
        d=google.com; s=arc-20260327;
        b=GMfoB4CkIu7QSr874tTKRPqCD7QY5uVokkNKTAglV6Np7Lupu8Z3blBbUUTFU4Uo3s
         0Iyl013HqEt2W/TnxO99YhXTzdSoznom5k9QvZVGK6FUBiKypFvO6CLjXi78yfv7HAZV
         +EnhZmcx3KMS/jWt/4Nsez7n3Sv0tdAj+ZkEdOHykszUHn7IVK+whROnQWkuCYbGUrFt
         FZddWs7pGL0vY9iXG8rIQo+xXQsJ0gjRnC/7PXfPemG0Hhur1xnpQuCewM0oJb2aBbqh
         6swzcuqyNreSCazmfLnccrdljbidVwryf5Jyo42XWtiffFfhNGUhCGuoZqeux+c+e+6g
         M10w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CAZT4Mc0RtafwpZHvhYs12WjFLpfTV2iCIMjczEtukc=;
        fh=wYt0Fx7M+p6C5uQA5EZcgV098fT+naFtqXk4awOtHNY=;
        b=R+0FR4bBkUX79+ij+xLrh9CU7+eOwYrDdHV+Fi5i+4/VCXeuJ/QjPFFq6cnGR734P7
         E37x4EEqrkswRC7qQHbwHJXm76gYT7EAgHKkvJjNp7MsWDw1gQrVHzgPbdUUXl7fEySK
         PY/l4Kuau1XHNwGpeVC9mzJpJ8Qq2+8ksiHoB9puTeg/wnY3r29+XgosdLM/oH0is548
         w/avvUTMZ+5UmQfF1xQOOShlXyycs3Q3R1DfP90YnpcbCqBf3pu/5nBdhXrlyWaewmbG
         LU6ETtF8kFQWGfwapLxpx7bCz6Z5ibu2U8WOHKfFKVh3uSJeZ9/dxLVeTpR8hbCTnbn2
         ozcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790085891; x=1790690691; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CAZT4Mc0RtafwpZHvhYs12WjFLpfTV2iCIMjczEtukc=;
        b=dGqCNwBa0Xaq3jy4paXVSMBTT3MP2lYYULb9Z44yy0vkdbpC/0TNieXlYfrRijvAR2
         FmgvSvR6c8lzvqqh/BURrpsdbO46Yzd2hgV8tpdFGwsvixIkm4sVpMKgd+5bNjPZ2vpR
         bW+Q/cHTDqxjmhd/85X/NYbhWNZCNr0Py7emGirEG+76SSZAlJE7OIrNBX7ABd/RGtOm
         PLnjYyRh78a7ZU295wEU4PIz2sUQVYUgtnFHUsPk+uoYhewXMPxkJ/mf3WTIODwzCY91
         hjKNKNngiPhAn2JTjB0ObRRrzTb3U41X8jmzpecrXpsV+Li4cTxI4pi5sWSQRMzlTJJ2
         bZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085891; x=1790690691;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CAZT4Mc0RtafwpZHvhYs12WjFLpfTV2iCIMjczEtukc=;
        b=FBGbkiG+qrfs+tzAHc/jWR/40JFrIMVKSDKck6j6nxDjOMeH6O14WnC9kCNuAt24BP
         ltLbuBPiNEeGYTmmm2lmwmj2BAcMHm5WkWJBioLzIpCLn9AGQnVRdWunaUvNTbW/dltc
         kqB5cW3cnQQwn1+EJeNOCpeEsKrifCdBFTYZdutj4MLvKx1DGFShNd61RiuUdVqEfuhp
         ddla4ulTM56elHfFQVWbE59it+mx4IKo7iN79wAOU9omeXv7DnCJZBaRIHfo0bA5h7Wz
         DPtsQSNZq+xgkyc3ze+1Wdz8Q6O7HFDthxitoDNhBMd8/6gvVP7dHEXi2mXvCJdlJZS3
         +jTg==
X-Forwarded-Encrypted: i=1; AKwUvBwihQ90ca8jRLZKxkYd2LSx78G6oce3a2cFEa0ySe7rmLcgrNers2ASQKN/NvLU9MapSVowmf3+HWBs0g==@vger.kernel.org
X-Gm-Message-State: AFuF++lrLHCzlk0tAhyus3hYtv2XrG/Jq1UiwFFexPH+Rg0DZBuQD1br
	N83kNgF16ofOiz3OKd53fwYOoVuw2AmM1aoNDSQqiOhHGH2NBR1NMwgcZ0aUKuY8Xmln5st+ca7
	4/2BLCL2+5Qv2SrOdkAckhyswI8fkLmfeNAo9Err1oQ==
X-Gm-Gg: AYBFou22T3Ujvz6AXPR0i8RzNADLhekSPkx2EnI7AH8OqSn3vqGLgujUuFIXlks3F6m
	i41nlaTmMhJWr5wrcsIvQqBSQE3uBwZE+U8FQg+1LA1cQCDWLwV7TWq50IaOa+sgpZoMRqNF1Bh
	/HHm5NaBkpmFqsyffApdpulS8y87LcWMMXNCHFgYz4CQiOc1uJmjd6aUf7VftnWT7izt1ZypRGj
	JWhV8AGnVaj9JvVVDOBQuw6HsjqHUthoXLv/ONKXYbUrdJSuYIfjmUVWXWJYYuobY+R7Vieq+Pk
	rUZOUhAyq2+IcleafXpSAy9cfP9hYbSuWcvpZKKofbMBdmrP4m2keSQfT0gDCQaWV7PzlOK5E9m
	Fe5g/zGO+vuPLGsD0cEfF+q0likrkPUHd4bqrp/Cab9Xrl3oDC9C2
X-Received: by 2002:a05:6000:4384:b0:487:218b:bbc9 with SMTP id
 ffacd0b85a97d-48861021845mr4010977f8f.19.1790085891037; Tue, 22 Sep 2026
 07:04:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-11-neelx@suse.com>
 <20260602031251.GG2295@sol> <CAPjX3Fer=5gfiBuB0Nk8rRdUZdhpk9txeBYtGFy=p6W-DmiVDQ@mail.gmail.com>
In-Reply-To: <CAPjX3Fer=5gfiBuB0Nk8rRdUZdhpk9txeBYtGFy=p6W-DmiVDQ@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 22 Sep 2026 16:04:40 +0200
X-Gm-Features: AclHuK_rkaWCmtwpyZjV91f4SPFL36vekOWvX2NiWI_NE1BZdnnwGwyNNNf5oUo
Message-ID: <CAPjX3FdaOiWuTBp13mnOetOhi+qYH-5mNcLWLNv5YoD=bNgzqg@mail.gmail.com>
Subject: Re: [PATCH v7 10/43] btrfs: start using fscrypt hooks
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 05:14, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:44AM +0200, Daniel Vacek wrote:
> > @@ -9041,20 +9063,28 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
> >       };
> >       unsigned int trans_num_items;
> >       int ret;
> > -     int name_len;
> >       int datasize;
> >       unsigned long ptr;
> >       struct btrfs_file_extent_item *ei;
> >       struct extent_buffer *leaf;
> > +     struct fscrypt_str disk_link;
> > +     size_t max_len;
> > +     u32 name_len = strlen(symname);
> > +
> > +     /*
> > +      * BTRFS_MAX_INLINE_DATA_SIZE() isn't actually telling the truth, we actually
> > +      * limit inline data extents to min(BTRFS_MAX_INLINE_DATA_SIZE(), sectorsize),
> > +      * so adjust max_len given this wonderful bit of inconsistency.
> > +      */
> > +     max_len = min_t(size_t, BTRFS_MAX_INLINE_DATA_SIZE(fs_info), fs_info->sectorsize);
> >
> > -     name_len = strlen(symname);
> >       /*
> > -      * Symlinks utilize uncompressed inline extent data, which should not
> > -      * reach block size.
> > +      * fscrypt sets disk_link.len to be len + 1, including a NUL terminator,
> > +      * but we don't store that '\0' character.
> >        */
> > -     if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
> > -         name_len >= fs_info->sectorsize)
> > -             return -ENAMETOOLONG;
> > +     ret = fscrypt_prepare_symlink(dir, symname, name_len, max_len + 1, &disk_link);
> > +     if (ret)
> > +             return ret;
>
> This is off by one from the other filesystems.  Yes, the way the other
> filesystems do encrypted symlinks is weird, but this still doesn't fix
> it, since the unnecessary 'struct fscrypt_symlink_data' is still stored.
> If it's not being fixed completely, it should just be done the same way.
>
> Did you do it this way because you're trying to squeeze out an extra
> byte, to allow 4094-byte symlink targets instead of 4093 as the other
> filesystems do?  Or did you do it this way because btrfs doesn't count a
> nul terminator when checking unencrypted symlinks against
> BTRFS_MAX_INLINE_DATA_SIZE(fs_info), and you needed to preserve that
> behavior?  But at the same time, btrfs *does* count the nul terminator
> when validating against 'fs_info->sectorsize', and this changes that
> behavior.  So it's not clear what was intended here.

This comes from Omar/Josef authored [v1] of the patchset from September 2023.
I understand the intent was to utilize the last byte. But yeah, I
think it's perfectly fine sticking to 4093 bytes limit as other FSes
do. I'll drop the +1.

[v1] https://lore.kernel.org/linux-btrfs/912762ca48efcc684cd5cdde99b5a78cd25f1078.1695750478.git.josef@toxicpanda.com/

> > +     if (IS_ENCRYPTED(inode)) {
> > +             ret = fscrypt_encrypt_symlink(inode, symname, name_len, &disk_link);
> > +             if (ret) {
> > +                     btrfs_abort_transaction(trans, ret);
> > +                     btrfs_free_path(path);
> > +                     discard_new_inode(inode);
> > +                     inode = NULL;
> > +                     goto out;
> > +             }
> > +     }
>
> fscrypt_encrypt_symlink() already has an IS_ENCRYPTED(inode) check
> built-in.

Correct. I'll drop the check.

> > +static const char *btrfs_get_link(struct dentry *dentry, struct inode *inode,
> > +                               struct delayed_call *done)
> > +{
> > +     struct page *cpage;
> > +     const char *paddr;
> > +     struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> > +
> > +     if (!IS_ENCRYPTED(inode))
> > +             return page_get_link(dentry, inode, done);
> > +
> > +     if (!dentry)
> > +             return ERR_PTR(-ECHILD);
> > +
> > +     cpage = read_mapping_page(inode->i_mapping, 0, NULL);
> > +     if (IS_ERR(cpage))
> > +             return ERR_CAST(cpage);
> > +
> > +     paddr = fscrypt_get_symlink(inode, page_address(cpage),
> > +                                 BTRFS_MAX_INLINE_DATA_SIZE(fs_info), done);
> > +     put_page(cpage);
>
> This uses a different max_len from btrfs_symlink().

I'm not sure that matters. But unifying them shouldn't hurt.

> Speaking of symlinks, btrfs is also missing a hookup to
> fscrypt_symlink_getattr().

Uh, I was not aware of that. It seems like fstests is missing for this feature.

Thanks a lot.

--nX

> - Eric
