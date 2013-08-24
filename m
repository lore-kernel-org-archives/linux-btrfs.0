Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from crane.lixil.net ([71.19.157.101]:55445 "EHLO crane.lixil.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab3HXRYo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 13:24:44 -0400
Received: from webmail.lixil.net (crane.lixil.net [71.19.157.101])
	(Authenticated sender: mrjoel@lixil.net)
	by crane.lixil.net (Postfix) with ESMTPSA id 6BBB7142D79
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 17:24:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 24 Aug 2013 11:24:44 -0600
From: Joel Johnson <mrjoel@lixil.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Help interpreting RAID1 space allocation
In-Reply-To: <25d36b2410416c9a767766fb9be313b6@lixil.net>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net>
Message-ID: <093e4c7d21b5e734c86fc4bb1703a69e@lixil.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Aug 23, 2013, Chris Murphy <li...@colorremedies.com> wrote:
> When replacing a failed disk, I'd like btrfs to compare states between 
> the
> available drives and know that it needs to catch up the newly added 
> device,
> but this doesn't yet happen. It's necessary to call btrfs balance.

> I can only test device replacement, not a readd. Upon 'btrfs device 
> delete
> missing /mnt' there's a delay, and it's doing a balance. I don't know 
> what
> happens for a readd, if the whole volume needs balancing or if it's 
> able to
> just write the changes.

Similar to what Duncan described in his response, on a hot-remove 
(without doing the proper btrfs device delete), there is no opportunity 
for a rebalance or metadata change on the pulled drives, so I would 
expect there to be a signature of some sort for consistency checking 
before readding it. At least, btrfs shouldn't add the readded device 
back as an active device when it's really still inconsistent and not 
being used, even if it indicates the same UUID.

> And still further, somehow the data profile has reverted to single even
> though the mkfs.btfs was raid1. [SNIP] That is a huge bug. I'll try to 
> come
> up with some steps to reproduce.

> If I create the file system, mount it, but I do not copy any data, upon 
> adding
> new and deleting missing, the data profile is changed from raid1 to 
> single. If
> I've first copied data to the volume prior to device failure/missing, 
> this
> doesn't happen, it remains raid1.

And yet, the tools indicate that it is still raid1, even if internally 
it reverts to single???

Based on my experience with this and Duncan's feedback, I'd like to see 
the wiki have some warnings about dealing with multidevice filesystems, 
especially surrounding the degraded mount option. Specifically, it 
sounds like a reasonable practice with the current state is that after a 
device is removed from a filesystem which receives any subsequent 
changes, the removed device should be cleared (dd if=/dev/zero, at least 
the superblocks) before being readded in order to remove any ambiguity 
about state. Adding such a note to the wiki now would communicate the 
potential pitfalls (especially with the difficulty determining what the 
state it by bugs below), and also allow updating once things are 
improved in this area.

Looking again at the wiki Gotchas page, it does say
On a multi device btrfs filesystem, mistakingly re-adding
a block device that is already part of the btrfs fs with
btrfs device add results in an error, and brings btrfs in
an inconsistent state. In striping mode, this causes data
loss and kernel oops. The btrfs userland tools need to do
more checking to prevent these easy mistakes.

Which seems very related, however perhaps adding the workaround and 
clarifying that even hotplugged devices may be added and bitten by this.

Should I file a few bugs to capture the related issues? Here are the 
discrete issues that seem to be present from a user point of view:

1. btrfs filesystem show - shouldn't list devices as present unlesss 
they're in use and in a consistent state

If an explicit add is needed to add new device, don't auto-add, even for 
devices previously part of the filesystem. Although I would claim that 
auto-adding and being consistent is most desired (when it makes sense 
with an existing signature, an empty drive has no indication on where to 
be added), it should be all or nothing instead of showing the device as 
being added (or at least how I interpret it being present in the 'fi 
show' listing) but internally being untracked or inconsistent.

As Chris said, "There isn't a readd option in btrfs, which in md 
parlance is used for readding a device previously part of an array." 
However, when I hotplugged the drive and it reappeared in the 'fi show' 
output, I assumed exactly the md semantics had occurred, with the drive 
having been readded and made consistent - it didn't take any time, but I 
hadn't copied data yet and knew btrfs may only sync the used data and 
metadata blocks.

In other words, I never ran a device add or remove, but still saw what 
appeared to be consistent behavior.

2. data profile shouldn't revert to single if adding/deleting before 
copying data

3. degraded mount option should be "allow degraded if needed", allowing 
non-degraded when it becomes available

Shouldn't force degraded, especially after adding (either manually or 
automatically) sufficient devices to operate in non-degraded mode. As 
soon as devices are added, a rebalance should be done to bring the new 
device(s) into consistent state.

This then drives the question, how does one check the degraded state of 
a filesystem if not the mount flag. I (quite likely with an md-raid 
bias) expected to use the 'filesystem show' output, listed the devices 
as well as a status flag of fully-consistent or rebalance in progress. 
If that's not the correct or intended location, then provide 
documentation on how to properly check the consistency state and 
degraded state of a filesystem.

Joel
