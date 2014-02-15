Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:60480 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaBOBlD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 20:41:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
References: <1392403428-4593-1-git-send-email-jbacik@fb.com>
	<20140214220525.GB3506@fieldses.org>
Date: Fri, 14 Feb 2014 17:40:55 -0800
In-Reply-To: <20140214220525.GB3506@fieldses.org> (J. Bruce Fields's message
	of "Fri, 14 Feb 2014 17:05:25 -0500")
Message-ID: <8761ohnoew.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [PATCH] Btrfs: unset DCACHE_DISCONNECTED when mounting default subvol
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Fri, Feb 14, 2014 at 01:43:48PM -0500, Josef Bacik wrote:
>> A user was running into errors from an NFS export of a subvolume that had a
>> default subvol set.  When we mount a default subvol we will use d_obtain_alias()
>> to find an existing dentry for the subvolume in the case that the root subvol
>> has already been mounted, or a dummy one is allocated in the case that the root
>> subvol has not already been mounted.  This allows us to connect the dentry later
>> on if we wander into the path.  However if we don't ever wander into the path we
>> will keep DCACHE_DISCONNECTED set for a long time, which angers NFS.  It doesn't
>> appear to cause any problems but it is annoying nonetheless, so simply unset
>> DCACHE_DISCONNECTED in the get_default_root case and switch btrfs_lookup() to
>> use d_materialise_unique() instead which will make everything play nicely
>> together and reconnect stuff if we wander into the defaul subvol path from a
>> different way.  With this patch I'm no longer getting the NFS errors when
>> exporting a volume that has been mounted with a default subvol set.  Thanks,
>
> Looks obviously correct, but based on a quick grep, there are four
> d_obtain_alias callers outside export methods:
>
> 	- btrfs/super.c:get_default_root()
> 	- fs/ceph/super.c:open_root_dentry()
> 	- fs/nfs/getroot.c:nfs_get_root()
> 	- fs/nilfs2/super.c:nilfs_get_root_dentry()
>
> It'd be nice to give them a common d_obtain_alias variant instead of
> making them all clear this by hand.

I am in favor of one small fix at a time, so that progress is made and
fixing something just for btrfs seems reasonable for the short term.

> Of those nilfs2 also uses d_splice_alias.  I think that problem would
> best be solved by fixing d_splice_alias not to require a
> DCACHE_DISCONNECTED dentry; IS_ROOT() on its own should be fine.

You mean by renaming d_splice_alias d_materialise_unique?

Or is there a useful distinction you see that should be preserved
between the two methods?

Right now my inclination is that everyone should just use
d_materialise_unique and we should kill d_splice_alias.

And by everyone I mean all file systems that are either distributed
(implementing d_revalidate) or exportable by knfsd.

One of the interesting things that d_materialise_unique does is get the
lazy rename case correct for a distributed filesystem.
check_submounts_and_drop can drop a directory when it is found not to be
accessible by that name, but later when we look it up
d_materialise_uniuqe will resuscciate the existing dentry.

Eric
