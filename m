From: Edward Ned Harvey <kernel@nedharvey.com>
Subject: RE: how stable are snapshots at the block level?
Date: Sun, 23 Oct 2011 10:08:27 -0400
Message-ID: <000101cc918d$3ffb45b0$bff1d110$@nedharvey.com>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: "'Mathijs Kwik'" <mathijs@bluescreen303.nl>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Mathijs Kwik
> 
> I'm currently doing backups by doing a btrfs snapshot, then rsync the
> snapshot to my backup location.
> As I have a lot of small files and quite some changes between
> snapshots, this process is taking more and more time.
> I looked at "btrfs find-new", which is promissing, but I need
> something to track deletes and modifications too.
> Also, while this will help the initial comparison phase, most time is
> still spent on the syncing itself, as a lot of overhead is caused by
> the tiny files.

No word on when this will be available, but "btrfs send" or whatever it's going to be called, is currently in the works.  This is really what you want.


> After finding some discussion about it here:
> http://www.backupcentral.com/phpBB2/two-way-mirrors-of-external-
> mailing-lists-3/backuppc-21/using-rsync-for-blockdevice-level-
> synchronisation-of-backupp-100438

When you rsync at the file level, it needs to walk the directory structure, which is essentially a bunch of random IO.  When you rsync at the block level, it needs to read the entire storage device sequentially.  The latter is only a possible benefit, when the amount of time to walk the tree is significantly greater than the time to read the entire block device. 

Even if you rsync the blocklevel device, the local rsync will have to read the entire block device to search for binary differences before sending.  This will probably have the opposite effect from what you want - Because every time you created and deleted a file, every time you overwrote an existing block (copy on write) it still represents binary differences on disk, so even though that file was deleted, or several modifications all yielded a single modification in the end, all the bytes of all the deleted files and all the file deltas that were formerly occupied will be sent anyway.  Unless you always zero them out, or something.

Given that you're talking about rsync'ing a block level device that contains btrfs, I'm assuming you have no raid/redundancy.  And the receiving end is the same.

Also if you're rsyncing the block level device, you're running underneath btrfs and losing any checksumming benefit that btrfs was giving you, so you're possibly introducing risk for silent data corruption.  (Or more accurately, failing to allow btrfs to detect/correct it.)


> I found that the official rsync-patches tarball includes the patch
> that allows syncing full block devices.
> After the initial backup, I found that this indeed speeds up my backups a lot.
> Ofcourse this is meant for syncing unmounted filesystems (or other
> things that are "stable" at the block level, like LVM snapshot
> volumes).

Just guessing you did a minimal test.  Send initial image, then make some changes, then send again.  I don't expect this to be typical after a day or a week of usage, for the reasons previously described.


> I tested backing up a live btrfs filesystem by making a btrfs
> snapshot, and this (very simple, non-thorough) turned out to work ok.
> My root subvolume contains the "current" subvolume (which I mount) and
> several backup subvolumes.
> Ofcourse I understand that the "current" subvolume on the backup
> destination is broken/inconsistent, as I change it during the rsync
> run. But when I mounted the backup disk and compared the subvolumes
> using normal file-by-file rsync, they were identical.

I may be wrong, but this sounds dangerous to me.  As you've demonstrated, it will probably work a lot of the time - because the subvols and everything necessary to reference them are static on disk most of the time.  But as soon as you write to any of the subvols - and that includes a scan, fsck, rebalance, defrag, etc.  Anything that writes transparently behind the scenes as far as user processes are concerned...  Those could break things.


> Thanks for any comments on this.

I suggest one of a few options:
(a) Stick with rsync at the file level.  It's stable.
(b) Wait for btrfs send (or whatever) to become available
(c) Use ZFS.  Both ZFS and BTRFS have advantages over one another.  This an area where zfs has the advantage for now.

