Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:37002 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaBRVcN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 16:32:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1392403428-4593-1-git-send-email-jbacik@fb.com>
	<20140214220525.GB3506@fieldses.org> <8761ohnoew.fsf@xmission.com>
	<20140215024524.GA6660@fieldses.org>
	<20140218202652.GA12374@fieldses.org>
Date: Tue, 18 Feb 2014 13:32:04 -0800
In-Reply-To: <20140218202652.GA12374@fieldses.org> (J. Bruce Fields's message
	of "Tue, 18 Feb 2014 15:26:52 -0500")
Message-ID: <8738jgrtt7.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [PATCH] Btrfs: unset DCACHE_DISCONNECTED when mounting default subvol
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Fri, Feb 14, 2014 at 09:45:24PM -0500, J. Bruce Fields wrote:
>> On Fri, Feb 14, 2014 at 05:40:55PM -0800, Eric W. Biederman wrote:
>> > "J. Bruce Fields" <bfields@fieldses.org> writes:
>> > 
>> > > On Fri, Feb 14, 2014 at 01:43:48PM -0500, Josef Bacik wrote:
>> > >> A user was running into errors from an NFS export of a subvolume that had a
>> > >> default subvol set.  When we mount a default subvol we will use d_obtain_alias()
>> > >> to find an existing dentry for the subvolume in the case that the root subvol
>> > >> has already been mounted, or a dummy one is allocated in the case that the root
>> > >> subvol has not already been mounted.  This allows us to connect the dentry later
>> > >> on if we wander into the path.  However if we don't ever wander into the path we
>> > >> will keep DCACHE_DISCONNECTED set for a long time, which angers NFS.  It doesn't
>> > >> appear to cause any problems but it is annoying nonetheless, so simply unset
>> > >> DCACHE_DISCONNECTED in the get_default_root case and switch btrfs_lookup() to
>> > >> use d_materialise_unique() instead which will make everything play nicely
>> > >> together and reconnect stuff if we wander into the defaul subvol path from a
>> > >> different way.  With this patch I'm no longer getting the NFS errors when
>> > >> exporting a volume that has been mounted with a default subvol set.  Thanks,
>> > >
>> > > Looks obviously correct, but based on a quick grep, there are four
>> > > d_obtain_alias callers outside export methods:
>> > >
>> > > 	- btrfs/super.c:get_default_root()
>> > > 	- fs/ceph/super.c:open_root_dentry()
>> > > 	- fs/nfs/getroot.c:nfs_get_root()
>> > > 	- fs/nilfs2/super.c:nilfs_get_root_dentry()
>> > >
>> > > It'd be nice to give them a common d_obtain_alias variant instead of
>> > > making them all clear this by hand.
>> > 
>> > I am in favor of one small fix at a time, so that progress is made and
>> > fixing something just for btrfs seems reasonable for the short term.
>> > 
>> > > Of those nilfs2 also uses d_splice_alias.  I think that problem would
>> > > best be solved by fixing d_splice_alias not to require a
>> > > DCACHE_DISCONNECTED dentry; IS_ROOT() on its own should be fine.
>> > 
>> > You mean by renaming d_splice_alias d_materialise_unique?
>> > 
>> > Or is there a useful distinction you see that should be preserved
>> > between the two methods?
>> > 
>> > Right now my inclination is that everyone should just use
>> > d_materialise_unique and we should kill d_splice_alias.
>> 
>> Probably.  One remaining distinction:
>> 
>> 	- In the local filesystem case if you discover a directory is
>> 	  already aliased elsewhere, you have a corrupted filesystem and
>> 	  want to error out the lookup.  (Didn't you propose a patch to
>> 	  do something like that before?)
>> 	- In the distributed filesystem this is perfectly normal and we
>> 	  want to do our best to fix up our local cache to represent
>> 	  remote reality.
>
> The following keeps the d_splice_alias/d_materialise_unique distinction
> and (hopefully) fixes Josef's bug, and does a little cleanup (including
> your suggested DISCONNECTED->CONNECTING rename).
>
> Any better idea for the naming of d_materialise_unique?
>
> I also didn't try to merge the implementations--the merged
> d_splice_alias/d_materialise_unique was a little uglier than I expected.
> I'll keep messing around with it though.

Your patchset sounds good I am going to aim for reading them through and
reviewing them soonish.

Eric

