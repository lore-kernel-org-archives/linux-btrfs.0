Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33336 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdAYXrB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 18:47:01 -0500
Received: by mail-pg0-f53.google.com with SMTP id 204so68333050pge.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 15:47:01 -0800 (PST)
Date: Wed, 25 Jan 2017 15:46:33 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: disable xattr operations on subvolume directories
Message-ID: <20170125234633.GA19099@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHc6FU50-m5v4X-n+_=HK8Bu1gYEO=1R7nrgAhhY+Mk54mFYrg@mail.gmail.com>
 <CAHc6FU7ubp4-A-oF+0nuKf27QJMeG_UtQx0pjdL7uVS+UwX6uw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 01:28:21PM +0100, Andreas Gruenbacher wrote:
> Omar,
> 
> On Wed, Jan 25, 2017 at 3:38 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > From: Omar Sandoval <osandov@fb.com>
> >
> > When you snapshot a subvolume containing a subvolume, you get a
> > placeholder read-only directory where the subvolume would be. These
> > directory inodes have ->i_ops set to btrfs_dir_ro_inode_operations.
> > Previously, this didn't include the xattr operation callbacks. The
> > conversion to xattr_handlers missed this case, leading to bogus attempts
> > to set xattrs on these inodes. This manifested itself as failures when
> > running delayed inodes.
> >
> > To fix this, clear the IOP_XATTR in ->i_opflags on these inodes.
> >
> > Fixes: 6c6ef9f26e59 ("xattr: Stop calling {get,set,remove}xattr inode operations")
> > Cc: Andreas Gruenbacher <agruenba@redhat.com>
> > Reported-by: Chris Murphy <lists@colorremedies.com>
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> > Applies to v4.10-rc4. Chris, this fixes the issue for me, could you please test
> > it out? Andreas, does this make sense? I'll try to cook up an xfstest for this.
> 
> this change looks good.
> 
> Are those directories really read-only though? They have the S_IWUSR
> permission set, and an update_time iop.

Hm, so these inodes don't have an on-disk [mca]time, it's only in
memory. ->update_time() just updates the in-memory time stamp, which is
kind of weird. Not sure why these even have S_IWUSR; they don't have a
->create() iop either. 0555 really makes more sense here. I wonder if
anyone would care if we made that change...

> Also, the get_acl and set_acl iops seem dead: they were not called
> before because the xattr iops were not defined in
> btrfs_dir_ro_inode_operations, and they are not called now because
> IOP_XATTR is cleared. Could you please check that as well?

Yeah, those shouldn't be there, either. I'll get rid of them in v2.

On Wed, Jan 25, 2017 at 01:29:51PM +0100, Andreas Gruenbacher wrote:
> On Wed, Jan 25, 2017 at 3:38 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > Forgot to cc stable, but 4.9 needs this.
> 
> Huh, stable not CCed again?

I was hoping Dave would add it when he applied it, but since I'm going
to send out a v2, I'll just do it then.
