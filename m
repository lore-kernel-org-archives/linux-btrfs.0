Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:50353 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbA2PXu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 10:23:50 -0500
Date: Thu, 29 Jan 2015 15:23:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to get
 vfsmount from a given sb.
Message-ID: <20150129152347.GE29656@ZenIV.linux.org.uk>
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com>
 <20150129123758.GJ3641@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150129123758.GJ3641@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 29, 2015 at 01:37:58PM +0100, David Sterba wrote:
> Adding Al Viro into CC
> 
> On Thu, Jan 29, 2015 at 10:24:39AM +0800, Qu Wenruo wrote:
> > +struct vfsmount *get_vfsmount_sb(struct super_block *sb)
> > +{
> > +	struct vfsmount *ret_vfs = NULL;
> > +	struct mount *mnt;
> > +	int ret = 0;
> > +
> > +	lock_mount_hash();
> > +	if (list_empty(&sb->s_mounts))
> > +		goto out;
> > +	mnt = list_entry(sb->s_mounts.next, struct mount, mnt_instance);
> 
> from include/linux/fs.h:
> 
> struct super_block {
> ...
> 	struct list_head        s_mounts;       /* list of mounts; _not_ for fs use */
> ...
> };
> 
> I hear a storm in the distance coming our direction ... so I'll
> preemptively NAK this change.

Could you explain what the devil is that for?  The primitive looks rather
bogus - if nothing else, it includes "make random instance of the filesystem
in someone's namespace appear busy to umount", which doesn't look like a
part of useful interface...  The only piece of context I'd been able to find
was something vague about sysfs-inflicted operations and wanting to use
mnt_want_write() but having nothing to pass it; BTW, what if the (random)
instance you run into happens to mounted r/o?

Assuming that your superblock is guaranteed to stay alive and usable for
whatever work you are trying to do, what's wrong with sb_want_write()?  

If it's _not_ guaranteed to stay so, and this is what you are trying to
solve, you are doing that at the wrong level - just take sysfs entry
removals earlier in shutdown process and be done with that.  Beginning of
close_ctree() would probably be early enough to be safe, but if that's
not enough, you can take it into the beginning of btrfs_kill_super().
