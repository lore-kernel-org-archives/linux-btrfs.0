Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19216 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751633AbcEKJ3N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 05:29:13 -0400
Subject: Re: Device replace issues and disabling it until they are solved
To: Filipe Manana <fdmanana@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAL3q7H6R=Sii-Qn3G7ZL5d4vT33jj-MZOF92fH7T-QHjHSNtow@mail.gmail.com>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <01228c8e-a55f-3bcc-934b-3b0a2ec90914@cn.fujitsu.com>
Date: Wed, 11 May 2016 17:29:06 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6R=Sii-Qn3G7ZL5d4vT33jj-MZOF92fH7T-QHjHSNtow@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/05/11 10:09 +0100:
> Hi,
>
> I've noticed some time ago that our device replace implementation is
> unreliable. Basically under several situations it ends up not copying
> extents (both data and metadata) from the old device to the new device
> (I briefly talked about some of the problems with Josef at LSF).
>
> Essentially it operates by iterating all the extents of the old device
> using the device tree's commit root, and for each device extent found,
> does a direct copy of it into the new device (it does not use the
> regular write paths). While it's doing this no extents can be
> allocated from the new device, this is only possible once it finishes
> copying all device extents and replaces the old device with the new
> device in the list of devices available for allocations.
>
> There are 4 main flaws with the implementation:
>
> 1) It processes each device extent only once. Clearly after it
> processes (copies) a device extent it's possible for future data and
> metadata writes to allocate extents from the corresponding block
> group, so any new extents are not copied into the new device.

Not quite familiar with dev replace though, but IIRC, current dev 
replace will commit current transaction and mark that block group 
readonly to prevent any incoming write.

So that's to say, the readonly setup and commit_transaction() has a race 
window to allow new write into the ro block group.

Or I missed something?
>
> 2) Before it copies a device extent, it sets the corresponding block
> group to RO mode (as of commit [1], which sadly does not really fix an
> issue nor does it explain how the problem it claims to fix happens) to
> prevent new allocations from allocating extents from the block group
> while we are processing it, and once we finish processing it, it sets
> the block group back to RW mode. This is flawed too, as when it sets
> the block group to RO mode, some concurrent task might have just
> allocated an extent from the block group and ends up writing to it
> while or after we process the device extent.

So the problem is the timing of commit_transaction() and set block group RO.

Or is there any possibility to allocate extent while can still escape 
the control of commit_transaction()?

>
> 3) Since it iterates over the device tree in an ascending fashion, it
> never considers the possibility for new device extents with an offset
> lower then the current search offset from being allocated for new
> block groups (just take a look at the while loop at
> scrub_enumerate_chunks() to see how flawed it is). So it totally
> ignores that device holes can be used while we are doing the replace
> and never looks back to check for any and copy the respective device
> extent into the new device. This is much more likely to happen
> nowadays since empty block groups are automatically removed by the
> cleaner kthread, while in the past this could only happen through
> balance operations triggered from userspace.

It seems that the problem is still a result of problem 1 and 2.
Still commit_trans() and set block group RO problem.

Just as stated, I'm still not quite familiar with dev replace,
it would be quite nice if you could point out any misunderstand from me.

Thanks,
Qu

>
> 4) When we finish iterating "all" device extents, we call
> btrfs_dev_replace_finishing(), which flushes all delalloc, commits the
> current transaction, replaces the old device in all extent mappings
> with the new device, removes old device from the list of available
> devices for allocation and adds the new device to that list. So when
> flushing dellaloc more extents are allocated from existing block
> groups and new block groups might be allocated, with all the
> corresponding bios writing to the old device and not the new one, and
> after this flushing we surely don't copy all new or changed extents to
> the new device.
>
> These are the 4 major issues I see with device replace. Issue number 2
> is trivial to solve but it's pointless to do so without addressing the
> other issues.
>
> Solving this isn't easy, not without some trade offs at least. We can
> keep in memory structures to track which new block groups are
> allocated while we are doing the replace and which new extents are
> allocated from existing block groups. Besides the needed
> synchronization between the allocator and the device replace code
> (which would bring yet more complexity), this can imply using a lot of
> memory if there's a significant number of writes happening all the
> time and ending up in an endless copy loop. Maybe some sort of write
> throttling would work out. There's also a bit of a chicken and the egg
> problem, as while the replace operation is ongoing we update a
> progress item in the devices tree (btrfs_run_dev_replace()) which in
> turn results in allocating new metadata extents.
>
> Anyway, I'm just hoping someone tells me that I'm completely wrong and
> misunderstood the current implementation we have. If not, and given
> how serious this is (affecting both data and metadata, and defeating
> the main purpose of raid), shouldn't we disable this feature, like we
> did for snapshot aware defrag a couple years ago, until we have these
> issues solved?
>
> thanks
>
>
> [1] - https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=55e3a601c81cdca4497bf855fa4d331f8e830744
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


