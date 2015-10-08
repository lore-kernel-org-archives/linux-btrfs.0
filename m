Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fep26.mx.upcmail.net ([62.179.121.46]:48736 "EHLO
	fep26.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbbJHQlA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 12:41:00 -0400
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS RAID1 behavior after one drive temporal disconection
Date: Thu, 8 Oct 2015 18:40:56 +0200
References: <201510052226.47051.pisa@cmp.felk.cvut.cz> <201510081028.02178.pisa@cmp.felk.cvut.cz> <561657D5.1070809@gmail.com>
In-Reply-To: <561657D5.1070809@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201510081840.56447.pisa@cmp.felk.cvut.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Austin,

thanks for reply.

On Thursday 08 of October 2015 13:47:33 Austin S Hemmelgarn wrote:
> On 2015-10-08 04:28, Pavel Pisa wrote:
> > Hello everybody,
...
> > It seems that SATA controller is not able to activate link which
> > has not been connected at BIOS POST time. This means that I cannot add
> > new drive without reboot.
>
> Check your BIOS options, there should be some option to set SATA ports
> as either 'Hot-Plug' or 'External', which should allow you to hot-plug
> drives without needing a reboot (unless it's a Dell system, they have
> never properly implemented the SATA standard on their desktops).
>
> > Before reboot, the server bleeds with messages
> >
> > BTRFS: bdev /dev/sde5 errs: wr 11715459, rd 8526080, flush 29099, corrupt
> > 0, gen 0 BTRFS: lost page write due to I/O error on /dev/sde5
> > BTRFS: bdev /dev/sde5 errs: wr 11715460, rd 8526080, flush 29099, corrupt
> > 0, gen 0 BTRFS: lost page write due to I/O error on /dev/sde5
>
> Even aside from the below mentioned issues, if your disk is showing that
> many errors, you should probably run a SMART self-test routine on it to
> determine whether this is just a transient issue or an indication of an
> impending disk failure.  The commands I'd suggest are:
> smartctl -t short /dev/sde

Yes, I have run even long as reported in the first message.
No problem has been found. The cause has been sudden stop
of DISK SATA communication after more months of uninterrupted
communication/service. When connection has been restored
by HDD power cable disconnect/connect then disk has been
OK, no SMART problems, no problem to read/write to other
filesystems.

So it seems to be BTRFS internal prevention to write to that
portion  of FS (whole block device?) on temporary disconnected
drive where transid do not match. Situation changed after reboot
(only way for new mount) when BTRFS has restored operation somehow.

> That will tell you some time to wait for the test to complete, after
> waiting  that long, run:
> smartctl -H /dev/sde
> If that says the health check failed, replace the disk as soon as
> possible, and don't use it for storing any data you can't afford to lose.
>
> > that changed to next mesages after reboot
> >
> > Btrfs loaded
> > BTRFS: device label riki-pool devid 1 transid 282383 /dev/sda3
> > BTRFS: device label riki-pool devid 2 transid 249562 /dev/sdb5
> > BTRFS info (device sda3): disk space caching is enabled
> > BTRFS (device sda3): parent transid verify failed on 44623216640 wanted
> > 263476 found 212766 BTRFS (device sda3): parent transid verify failed on
> > 45201899520 wanted 282383 found 246891 BTRFS (device sda3): parent
> > transid verify failed on 45202571264 wanted 282383 found 246890 BTRFS
> > (device sda3): parent transid verify failed on 45201965056 wanted 282383
> > found 246889 BTRFS (device sda3): parent transid verify failed on
> > 45202505728 wanted 282383 found 246890 BTRFS (device sda3): parent
> > transid verify failed on 45202866176 wanted 282383 found 246890 BTRFS
> > (device sda3): parent transid verify failed on 45207126016 wanted 282383
> > found 246894 BTRFS (device sda3): parent transid verify failed on
> > 45202522112 wanted 282383 found 246890 BTRFS: bdev
> > /dev/disk/by-uuid/1627e557-d063-40b6-9450-3694dd1fd1ba errs: wr 11723314,
> > rd 8526080, flush 2 BTRFS (device sda3): parent transid verify failed on
> > 45206945792 wanted 282383 found 67960 BTRFS (device sda3): parent transid
> > verify failed on 45204471808 wanted 282382 found 67960
> >
> > which looks really frightening to me. Temporary disconnected drive has
> > old transid at start (OK). But what means the rest of the lines. If it
> > means that files with older transaction ID are used from temporary
> > disconnected drive (now /dev/sdb5) and newer versions from /dev/sda3 are
> > ignored and reported as invalid then this means severe data lost and may
> > it be mitchmatch because all transactions after disk disconnect are lost
> > (i.e. FS root has been taken from misbehaving drive at old version).
> >
> > BTRFS does not fall even to red-only/degraded mode after system restart.
>
> This actually surprises me.

Both drives has been present for all time / except that for about one week
on drive (in fact corresponding SATA controller) reported permanent error
for each access.

> > On the other hand, from logs (all stored on the possibly damaged root FS)
> > it seems that there there are not missing messages from days when discs
> > has been out of sync, so it looks like all data are OK. So should I
> > expect that BTRFS managed problems well and all data are consistent?
>
> I would be very careful in that situation, you may still have issues, at
> the very least, make a backup of the system as soon as possible.

I have done backup to external drive before attempts to reconnect
failed drive.

I have done btrfs replace of temporary failed HDD to new bought HDD.
I have planned to replace old drive (that one which did not experience
problems but reports some relocated sectores). So I have done
replace of sustained drive back to the drive with disconnected with
hope that it has been single event problem. I keep all data/system/meta
in RAID1 anyway so I hope to be able to keep data healthy. In the fact
the whole event at the end proves quality of BTRFS.

I have have untarred all backups and run complete recursive diff -r -u
of the root fs and containers fs (secondary mounts to eliminate /proc etc.)
to backups.

It seems that all is correct, only difference seen are in these files
and logs which should differ from start of problem investigation and
rescue. Same for missing files - only expected ones has been missing
(media files excluded from backup and new files and broken sysmlinks
- broken in both backup and live data.

It seems that all git repos changes and other stuff which happened
on system from disk disconnection to backup is there. Even git repos
changes after reconection before backups compare.

So it seems that even that some mesages looks really strange,
BTRFS selected right copy and generation during whole phases
of operation and maintenance.

> > I go to use "btrfs replace" because there has not been any reply to my
> > inplace correction question. But I expect that clarification if
> > possible/how to resync RAID1 after one drive temporal disappear is really
> > important to many of BTRFS users.
>
> As of right now, there is no way that I know of to safely re-sync a
> drive that's been disconnected for a while.  The best bet is probably to
> use replace, but for that to work reliably, you would need to tell it to
> ignore the now stale drive when trying to read each chunk.
>
> It is theoretically possible to wipe the FS signature on the out-of sync
> drive, run a device scan, then run 'replace missing' pointing at the now
> 'blank' device, although going that route is really risky.

Yes,  I have been considering this but in the case that other drive
has real data errors then it would lead to data lost (and in my case
drive with actual data is worse according to the SMART).

So it seems that best recommendation is to run replace of problematic
partition to to other drive or even other partition on the same drive
and the run replace to copy already synchronized data back to the original
place. There would be at least two physical drives with at least with one
data copy in play for whole operation so even consequent failure to read
some data has high chance to have one health copy.

Anyway confirming that correct behavior in my case has been result
of design and not only of my luck would be nice. Option to run
inplace synchronization instead of all data shuffling would be yet
another nice feature to have.

Thanks,

            Pavel



