Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shout01.mail.de ([62.201.172.24]:57708 "EHLO shout01.mail.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbeHKEvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 00:51:05 -0400
From: erenthetitan@mail.de
To: ce3g8jdj@umail.furryterror.org, linux-btrfs@vger.kernel.org
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Date: Sat, 11 Aug 2018 04:18:35 +0200
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
Message-Id: <20180811021835.D223C8038C@smtp03.mail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Write hole:


> The data will be readable until one of the data blocks becomes
> inaccessible (bad sector or failed disk). This is because it is only the
> parity block that is corrupted (old data blocks are still not modified
> due to btrfs CoW), and the parity block is only required when recovering
> from a disk failure.

I am unsure about your meaning. 
Assuming you perform an unclean shutdown (eg. crash), and after restart perform a scrub, with no additional error (bad sector, bit-rot) before or after the crash:
will you loose data? Will you be able to mount the filesystem like normal? Additionaly, will the crash create additional errors like bad sectors and or bit-rot aside from the parity-block corruption?
Its actually part of my first mail, where the btrfs Raid5/6 page assumes no data damage while the spinics comment implies the opposite.
The write hole does not seem as dangerous if you could simply scrub to repair damage (On smaller discs that is, where scrub doesnt take enough time for additional errors to occur)

> Put another way: if all disks are online then RAID5/6 behaves like a slow
> RAID0, and RAID0 does not have the partial stripe update problem because
> all of the data blocks in RAID0 are independent. It is only when a disk
> fails in RAID5/6 that the parity block is combined with data blocks, so
> it is only in this case that the write hole bug can result in lost data.

So data will not be lost if no drive has failed?

> > > If the filesystem is -draid5 -mraid1 then the metadata is not vulnerable
> > > to the write hole, but data is. In this configuration you can determine
> > > with high confidence which files you need to restore from backup, and
> > > the filesystem will remain writable to replace the restored data, because
> > > raid1 does not have the write hole bug.

In regards to my earlier questions, what would change if i do -draid5 -mraid1?


Lost Writes:


> Hotplugging causes an effect (lost writes) which can behave similarly
> to the write hole bug in some instances. The similarity ends there.

Are we speaking about the same problem that is causing transid mismatch? 

> They are really two distinct categories of problem. Temporary connection
> loss can do bad things to all RAID profiles on btrfs (not just RAID5/6)
> and the btrfs requirements for handling connection loss and write holes
> are very different.

What kind of bad things? Will scrub (1/10, 5/6) detect and repair it?

> > > Hot-unplugging a device can cause many lost write events at once, and
> > > each lost write event is very bad.

> Transid mismatch is btrfs detecting data
> that was previously silently corrupted by some component outside of btrfs.
> 
> btrfs can't prevent disks from silently corrupting data. It can only
> try to detect and repair the damage after the damage has occurred.

Aside from the chance that all copies of data are corrupted, is there any way scrubbing could fail?

> Normally RAID1/5/6/10 or DUP profiles are used for btrfs metadata, so any
> transid mismatches can be recovered by reading up-to-date data from the
> other mirror copy of the metadata, or by reconstructing the data with
> parity blocks in the RAID 5/6 case. It is only after this recovery
> mechanism fails (i.e. too many disks have a failure or corruption at
> the same time on the same sectors) that the filesystem is ended.

Does this mean that transid mismatch is harmless unless both copys are hit at once (And in case of Raid 6 all three)?


Old hardware:


> > > It's fun and/or scary to put known good and bad hardware in the same
> > > RAID1 array and watch btrfs autocorrecting the bad data after every
> > > other power failure; however, the bad hardware is clearly not sufficient
> > > to implement any sort of reliable data persistence, and arrays with bad
> > > hardware in them will eventually fail.

I am having a hard time wrapping my head around this statement.
If Btrfs can repair corrupted data and Raid  6 allows two disc failures at once without data loss, is using old discs even with high average error count not still pretty much safe?
You would simply have to repeat the scrubbing process more often to make sure that not enough data is corrupted to break redundancy.

> > > I have one test case where I write millions of errors into a raid5/6 and
> > > the filesystem recovers every single one transparently while verifying
> > > SHA1 hashes of test data. After years of rebuilding busted ext3 on
> > > mdadm-raid5 filesystems, watching btrfs do it all automatically is
> > > just...beautiful.

Once again, if Btrfs is THIS good at repairing data, then is old hardware, hotplugging and maybe even (depending on whether i understood your point) write hole really dangerous? Are there bugs that could destroy the data or filesystem whitout corrupting all copies of data (Or all copies at once)? Assuming Raid 6, corrupted data would not break redundancy and repeated scrubbing would fix any upcoming issue.
-------------------------------------------------------------------------------------------------
FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSITÄT UND KOMFORT
