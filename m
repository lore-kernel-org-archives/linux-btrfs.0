Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:60646 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbcEKSZY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 14:25:24 -0400
Date: Wed, 11 May 2016 20:25:14 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>
Subject: Re: WARNING at fs/btrfs/inode.c:9261 btrfs_destroy_inode()
Message-ID: <20160511182514.GA6423@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160510235758.3ow2wdumtisauw4n@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Tue, May 10, 2016 at 06:19:20PM -0500, Eric Biggers wrote:
> > The following warning has been triggering for me since about v4.6-rc3:
> > 
> >       WARN_ON(BTRFS_I(inode)->csum_bytes);
> > 
> > On one machine the warning has occurred 657 times since v4.6-rc5.  On another it
> > has occurred 3 times since v4.6-rc3.  Both are now on v4.6-rc7, where I have
> > still observed the warning.  The warnings occur in groups, and do_unlinkat() and
> > evict() are always in the call stack.
>
> It is a known issue, but I'm having a very hard time triggering it
> quickly enough to track it down.  I do know csum_bytes is only 4096 or
> 8192 when it hits, but beyond that I haven't been able to trigger it
> consistently enough to test a patch.

It happens for me after no more than a few minutes of regular use that
includes unlink, destructive rename or snapshot deletion, even without
deliberately trying to trigger it.  On the other hand, repeating the same
operation that triggered the warning doesn't trigger it again (on live fs, I
did not try a whole-device snapshot of the filesystem).

Effective mount options for this fs:
/dev/sda1 on / type btrfs (rw,noatime,compress=lzo,ssd,space_cache,subvolid=4996,subvol=/sys)
/dev/sda1 on /var/cache type btrfs (rw,noatime,compress=lzo,ssd,space_cache,subvolid=263,subvol=/syscache)
/dev/sda1 on /home type btrfs (rw,noatime,compress=lzo,ssd,space_cache,subvolid=258,subvol=/home)
/dev/sda1 on /mnt/btr1 type btrfs (rw,noatime,compress=lzo,ssd,space_cache,subvolid=5,subvol=/)
/dev/sda1 on /home/kilobyte/.cache type btrfs (rw,noatime,compress=lzo,ssd,space_cache,subvolid=259,subvol=/kb-cache)
/dev/sda1 on /home/kilobyte/tmp type btrfs (rw,noatime,compress=lzo,ssd,space_cache,subvolid=260,subvol=/kb-tmp)
/dev/sda1 on /srv/chroots type btrfs (rw,noatime,compress=lzo,ssd,space_cache,subvolid=5,subvol=/chroots)

I've been running with asserts/etc and a s/WARN_ON/printk/ patch I'll send
after this mail for almost two weeks already, no data loss or any
inconsistency.  My use is mostly sbuild: snapshot+lots of dpkg+lots of
gcc+snapshot deletion.


Could you confirm my understanding?  I don't know btrfs internals, but it
appears to me that unsaved pending checksums attached to an inode don't
matter if the inode is being deleted anyway.  Is this correct?

If so, please apply the patch to silence the warning in non-ASSERTS builds;
people rightfully panic when they see a WARN with tainted kernel and so on,
believing the filesystem needs an immediate fsck + possibly restore.
Having such pending checksums means badness elsewhere -- they should have
been already saved at this point, right?  But no matter the cause, it
doesn't break btrfs_destroy_inode.


Meow!
-- 
How to exploit the Bible for weight loss:
Pr28:25: he that putteth his trust in the ʟᴏʀᴅ shall be made fat.
