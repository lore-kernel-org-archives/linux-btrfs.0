Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56901 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaGSSXL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 14:23:11 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Cody P Schafer <dev@codyps.com>
Cc: Chris Mason <clm@fb.com>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
Date: Sat, 19 Jul 2014 20:23:08 +0200
Message-ID: <1745216.hDa4tC2HJJ@merkaba>
In-Reply-To: <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <53C7CD0F.7070603@fb.com> <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 19. Juli 2014, 12:38:53 schrieb Cody P Schafer:
> On Thu, Jul 17, 2014 at 8:18 AM, Chris Mason <clm@fb.com> wrote:
> > [ deadlocks during rsync in 3.15 with compression enabled ]
> > 
> > Hi everyone,
> > 
> > I still haven't been able to reproduce this one here, but I'm going
> > through a series of tests with lzo compression foraced and every
> > operation forced to ordered.  Hopefully it'll kick it out soon.
> > 
> > While I'm hammering away, could you please try this patch.  If this is
> > the buy you're hitting, the deadlock will go away and you'll see this
> > printk in the log.
> > 
> > thanks!
> > 
> > -chris
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 3668048..8ab56df 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -8157,6 +8157,13 @@ void btrfs_destroy_inode(struct inode *inode)
> > 
> >                 spin_unlock(&root->fs_info->ordered_root_lock);
> >         
> >         }
> > 
> > +       spin_lock(&root->fs_info->ordered_root_lock);
> > +       if (!list_empty(&BTRFS_I(inode)->ordered_operations)) {
> > +               list_del_init(&BTRFS_I(inode)->ordered_operations);
> > +printk(KERN_CRIT "racing inode deletion with ordered
> > operations!!!!!!!!!!!\n"); +       }
> > +       spin_unlock(&root->fs_info->ordered_root_lock);
> > +
> > 
> >         if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> >         
> >                      &BTRFS_I(inode)->runtime_flags)) {
> >                 
> >                 btrfs_info(root->fs_info, "inode %llu still on the orphan
> >                 list",
> 
> Thanks Chris.
> 
> Running 3.15.6 with this patch applied on top:
>  - still causes a hang with `rsync -hPaHAXx --del /mnt/home/nyx/ /home/nyx/`
> - no extra error messages printed (`dmesg | grep racing`) compared to
> without the patch

I got same results with 3.16-rc5 + this patch (see thread BTRFS hang with 
3.16-rc5). 3.16-rc4 still is fine with me. No hang whatsoever so far.

> To recap some details (so I can have it all in one place):
>  - /home/ is btrfs with compress=lzo

BTRFS RAID 1 with lzo.

>  - I have _not_ created any nodatacow files.

Me neither.

>  - Full stack is: sata <-> dmcrypt <-> lvm <-> btrfs (I noticed others
> mentioning the use of dmcrypt)

Same, except no dmcrypt.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
