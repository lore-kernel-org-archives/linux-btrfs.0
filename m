Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbaFBPjq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 11:39:46 -0400
Date: Mon, 2 Jun 2014 17:39:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jeffm@suse.com, clm@fb.com
Subject: Re: [PATCH 4/4] btrfs: create sprout should rename fsid on the sysfs
 as well
Message-ID: <20140602153944.GB22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
 <1401096626-13210-5-git-send-email-anand.jain@oracle.com>
 <20140529125422.GB29992@twin.jikos.cz>
 <538C343C.20308@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <538C343C.20308@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 02, 2014 at 04:22:20PM +0800, Anand Jain wrote:
> >>--- a/fs/btrfs/volumes.c
> >>+++ b/fs/btrfs/volumes.c
> >>@@ -2084,6 +2084,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
> >>  	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
> >>
> >>  	if (seeding_dev) {
> >>+		char fsid_buf[37];
> >
> >Is there a symbolic constant available? We have one in userspace, but I
> >can't find one for kernel, only a few locally defined.
> 
>  now defined the same (as in progs) in kernel as well.

In progs it's in utils.h

 40 #define BTRFS_UUID_UNPARSED_SIZE        37

but I don't see where it's defined in kernel. Can you please give me a
pointer?

On the other hand, progs have a local define, we can do the same, I
don't see any other potential users.
