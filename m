From: Mathijs Kwik <mathijs@bluescreen303.nl>
Subject: how stable are snapshots at the block level?
Date: Sun, 23 Oct 2011 09:45:10 +0200
Message-ID: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm currently doing backups by doing a btrfs snapshot, then rsync the
snapshot to my backup location.
As I have a lot of small files and quite some changes between
snapshots, this process is taking more and more time.
I looked at "btrfs find-new", which is promissing, but I need
something to track deletes and modifications too.
Also, while this will help the initial comparison phase, most time is
still spent on the syncing itself, as a lot of overhead is caused by
the tiny files.

After finding some discussion about it here:
http://www.backupcentral.com/phpBB2/two-way-mirrors-of-external-mailing-lists-3/backuppc-21/using-rsync-for-blockdevice-level-synchronisation-of-backupp-100438

I found that the official rsync-patches tarball includes the patch
that allows syncing full block devices.
After the initial backup, I found that this indeed speeds up my backups a lot.
Ofcourse this is meant for syncing unmounted filesystems (or other
things that are "stable" at the block level, like LVM snapshot
volumes).

I tested backing up a live btrfs filesystem by making a btrfs
snapshot, and this (very simple, non-thorough) turned out to work ok.
My root subvolume contains the "current" subvolume (which I mount) and
several backup subvolumes.
Ofcourse I understand that the "current" subvolume on the backup
destination is broken/inconsistent, as I change it during the rsync
run. But when I mounted the backup disk and compared the subvolumes
using normal file-by-file rsync, they were identical.

Can someone with knowledge about the on-disk structure please
confirm/reject that subvolumes (created before starting rsync on the
block device) should be safe and never move by themselves? Or was I
just lucky?
Are there any things that might break the backup when performed during rsync?
Like creating/deleting other subvolumes, probably defrag isn't a good
idea either :)

Or any incompatible mount options (compression, space_cache, ssd)

Thanks for any comments on this.
Mathijs
