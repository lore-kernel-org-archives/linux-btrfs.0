Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759C9C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 12:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2361D2085B
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 12:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f5ncnptz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2361D2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbeJJTvQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 15:51:16 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39046 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeJJTvQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 15:51:16 -0400
Received: by mail-yw1-f65.google.com with SMTP id v1-v6so2067905ywv.6;
        Wed, 10 Oct 2018 05:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/dkY00Ij8F/sh1n14qEVJAmJCJ706EXTvoibm4ncxSQ=;
        b=f5ncnptzClrAN9Wrw0z9OgW3xST6w3CZcx4u1oUMr13Tyj56ZrgXxeo8qehh0vjVGs
         S25rR/BDd6AGjrm/Hhyr/bF3kVZuH0ndnqZLRqfDcZJVsKPCdSrNAe5azhKpW+h3m5EX
         lNfkYKZqXp/rsURfrLsKs527H23fWI0QIU7QavFXHmpq/2nAJfcfSX9HKdE4SK8ah81a
         AbFBTXDKhzxDlkPcLL2O+YmZ7pb6yQwMJnQtQS2zsYGQ2pssAVhn6z8ReqoOhcf+NkC+
         bna3xygQ+789DUe0YwYcZKI9CmPV6JoLzunArXgFnlUCXIZpLMHF08Y3NdZtRtVmOhXk
         248A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/dkY00Ij8F/sh1n14qEVJAmJCJ706EXTvoibm4ncxSQ=;
        b=e1O4cYKv8NLKO/B7BxRhCIotmNcCcBwcSdT3eXlPnQyGp7E0SP5lDA/vJP8wK3qz1t
         IG8yi+RhZfdcGYnWLgd1nyDXq7zCvnS+Bv7jGAhhEv5UTLDFV5E1xh1MzgLrIjch80UC
         wkaVeXC/UotU8PEbZvlwdmoY49yjLeA/yFYSEcBiKZ7ei6+dAecXYg0m8EmwKuTzHbrN
         fDEyBodKnqEs322skUAT5zgJLK761ksjJbSkmLV61mu3vIEi0AmEDC6j9G9+nffuLzbN
         3A5TNnC8kzyTtg7HRJnY+Z/vJ6LC9Ze9U8fCfVKQTWQwSBmzUiOyxAywoV7WP7NtEFXa
         7/gA==
X-Gm-Message-State: ABuFfog8SFeNhDk6lb/P+VaUc3uIuMhUxb9NYBS9RgJxeuKdpgvjtxpf
        sLExTPZ9v8ttdB2YO7fG6BIHA+cR/o3eY3OHxd4=
X-Google-Smtp-Source: ACcGV63Blfo7NspePBXhtvLQjDAWREJfz7rTZSTI1AJVbtplPt2jZm5wbOcRVejU0BVImN+Jd+3szItUgXEf8CNHycw=
X-Received: by 2002:a0d:d181:: with SMTP id t123-v6mr18216177ywd.241.1539174557969;
 Wed, 10 Oct 2018 05:29:17 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia> <153913043746.32295.17463515265798256890.stgit@magnolia>
In-Reply-To: <153913043746.32295.17463515265798256890.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 15:29:06 +0300
Message-ID: <CAOQ4uxivwLR5assf0VwHdp5p06Er4w7urB637Z3wiQ1eZoT9tQ@mail.gmail.com>
Subject: Re: [PATCH 17/25] vfs: make remapping to source file eof more explicit
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Create a RFR_TO_SRC_EOF flag to explicitly declare that the caller wants
> the remap implementation to remap to the end of the source file, once
> the files are locked.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ioctl.c         |    3 ++-
>  fs/nfsd/vfs.c      |    3 ++-
>  fs/read_write.c    |   13 +++++++------
>  include/linux/fs.h |    2 ++
>  4 files changed, 13 insertions(+), 8 deletions(-)
>
>
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 505275ec5596..7fec997abd2f 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -224,6 +224,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
>  {
>         struct fd src_file = fdget(srcfd);
>         loff_t cloned;
> +       unsigned int flags = olen == 0 ? RFR_TO_SRC_EOF : 0;
>         int ret;
>
>         if (!src_file.file)
> @@ -232,7 +233,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
>         if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
>                 goto fdput;
>         cloned = vfs_clone_file_range(src_file.file, off, dst_file, destoff,
> -                                     olen, 0);
> +                                     olen, flags);
>         if (cloned < 0)
>                 ret = cloned;
>         else if (olen && cloned != olen)
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 726fc5b2b27a..d1f2ae08adf6 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -542,8 +542,9 @@ __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
>                 u64 dst_pos, u64 count)
>  {
>         loff_t cloned;
> +       unsigned int flags = count == 0 ? RFR_TO_SRC_EOF : 0;
>
> -       cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count, 0);
> +       cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count, flags);
>         if (count && cloned != count)
>                 cloned = -EINVAL;
>         return nfserrno(cloned < 0 ? cloned : 0);
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 479eb810c8e6..a628fd9a47cf 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1748,11 +1748,12 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>
>         isize = i_size_read(inode_in);
>
> -       /* Zero length dedupe exits immediately; reflink goes to EOF. */
> -       if (*len == 0) {
> -               if (is_dedupe || pos_in == isize)
> -                       return 0;
> -               if (pos_in > isize)
> +       /*
> +        * If the caller asked to go all the way to the end of the source file,
> +        * set *len now that we have the file locked.
> +        */
> +       if (remap_flags & RFR_TO_SRC_EOF) {
> +               if (pos_in >= isize)
>                         return -EINVAL;
>                 *len = isize - pos_in;
>         }
> @@ -1828,7 +1829,7 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
>         struct inode *inode_out = file_inode(file_out);
>         loff_t ret;
>
> -       WARN_ON_ONCE(remap_flags);
> +       WARN_ON_ONCE(remap_flags & ~(RFR_TO_SRC_EOF));
>
>         if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
>                 return -EISDIR;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 5c1bf1c35bc6..9f90dcd4df3b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1725,8 +1725,10 @@ struct block_device_operations;
>   * These flags control the behavior of the remap_file_range function pointer.
>   *
>   * RFR_IDENTICAL_DATA: only remap if contents identical (i.e. deduplicate)

<bikeshedding> not that I care so much, but is there any reason you chose
to use _IDENTICAL_ vs. _SAME_? The latter is shorter and already engraved
in the dedup uapi. </bikeshedding>

> + * RFR_TO_SRC_EOF: remap to the end of the source file
>   */
>  #define RFR_IDENTICAL_DATA     (1 << 0)
> +#define RFR_TO_SRC_EOF         (1 << 1)
>

So what is the best way to make sure that all filesystems can
properly handle this flag? and the RFR_CAN_SHORTEN flag?

The way that your patches took is to not check for invalid flags
at all in filesystems, but I don't think that is a viable option.

Another way would be to individually add those flags to invalid
flags check in all relevant filesystems.

Another way would be to follow a pattern similar to
fiemap_check_flags(), except in case filesystem does not declare
to support the RFR_ "advisory" flags, it will not fail the operation.

Comparing to FIEMAP_ flags, no filesystem would have needed to declare
support for FIEMAP_FLAG_SYNC, because vfs dealt with it anyway
before calling into the filesystem. So de-facto, any filesystem supports
FIEMAP_FLAG_SYNC without doing anything, but it is still worth passing
the flag into filesystem in case it matter (it does for overlayfs).

I am not sure if giving fiemap_check_flags() as an example for sorting
out VFS API flags is a good idea, because I completely don't understand
what is going on in ext4_fiemap(). Why do FIEMAP_FLAG_CACHE and
the case of  !EXT4_INODE_EXTENTS bypass fiemap_check_flags()?
Is there a rational behind all this or just plain old API bit rot?
If bit rot, then perhaps the fiemap_check_flags() wasn't a good enough
coding pattern?

Thanks,
Amir.
