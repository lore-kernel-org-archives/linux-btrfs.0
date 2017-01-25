Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:36714 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdAYM22 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 07:28:28 -0500
Received: by mail-ua0-f169.google.com with SMTP id 96so157504827uaq.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 04:28:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
References: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 25 Jan 2017 13:28:21 +0100
Message-ID: <CAHc6FU50-m5v4X-n+_=HK8Bu1gYEO=1R7nrgAhhY+Mk54mFYrg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: disable xattr operations on subvolume directories
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        kernel-team@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Omar,

On Wed, Jan 25, 2017 at 3:38 AM, Omar Sandoval <osandov@osandov.com> wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> When you snapshot a subvolume containing a subvolume, you get a
> placeholder read-only directory where the subvolume would be. These
> directory inodes have ->i_ops set to btrfs_dir_ro_inode_operations.
> Previously, this didn't include the xattr operation callbacks. The
> conversion to xattr_handlers missed this case, leading to bogus attempts
> to set xattrs on these inodes. This manifested itself as failures when
> running delayed inodes.
>
> To fix this, clear the IOP_XATTR in ->i_opflags on these inodes.
>
> Fixes: 6c6ef9f26e59 ("xattr: Stop calling {get,set,remove}xattr inode operations")
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Applies to v4.10-rc4. Chris, this fixes the issue for me, could you please test
> it out? Andreas, does this make sense? I'll try to cook up an xfstest for this.

this change looks good.

Are those directories really read-only though? They have the S_IWUSR
permission set, and an update_time iop.

Also, the get_acl and set_acl iops seem dead: they were not called
before because the xattr iops were not defined in
btrfs_dir_ro_inode_operations, and they are not called now because
IOP_XATTR is cleared. Could you please check that as well?

Thanks,
Andreas
