Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35873 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbcF2JvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 05:51:00 -0400
Received: by mail-wm0-f47.google.com with SMTP id f126so173431793wma.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 02:50:59 -0700 (PDT)
Received: from system (dslb-092-074-022-141.092.074.pools.vodafone-ip.de. [92.74.22.141])
        by smtp.gmail.com with ESMTPSA id f189sm13228627wmf.19.2016.06.29.02.50.55
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2016 02:50:56 -0700 (PDT)
Date: Wed, 29 Jun 2016 11:50:55 +0200
From: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160629115055.29018e6a@system>
In-Reply-To: <CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
References: <20160627233612.662d2a9a@system>
	<CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
	<20160628002602.022258bf@system>
	<CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
	<CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
	<20160628010618.58e235fa@system>
	<CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
	<20160628024940.3b323b26@system>
	<CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
	<20160629005208.5e9addcf@system>
	<CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 28 Jun 2016 22:25:32 -0600, Chris Murphy
<lists@colorremedies.com> wrote :


> > Well I made a ddrescue image of both drives (only one error on sdb
> > during ddrescue copy) and started the computer again (after
> > disconnecting the old drives).
> 
> What was the error? Any kernel message at the time of this error?
> 

ddrescue reported an error during operation ("error: 1" displayed).
Dump of /var/log/syslog during the ddrescue operation is appended at
the end of this email.

> 
> > I don't know if I should continue trying to repair this RAID1 or if
> > I should just cp/rsync to a new BTRFS volume and get done with it.
> 
> Well for sure already you should prepare to lose this volume, so
> whatever backup you need, do that yesterday.

Already got a backup. I just really want to try to repair it (in order
to test BTRFS).

> > On the other hand it seems interesting to repair instead of just
> > giving up. It gives a good look at BTRFS resiliency/reliability.
> 
> On the one hand Btrfs shouldn't become inconsistent in the first
> place, that's the design goal. On the other hand, I'm finding from the
> problems reported on the list that Btrfs increasingly mounts at least
> read only and allows getting data off, even when the file system isn't
> fully functional or repairable.
> 
> In your case, once there are metadata problems even with raid 1, it's
> difficult at best. But once you have the backup you could try some
> other things once it's certain the hardware isn't adding to the
> problems, which I'm still not yet certain of.
> 

I'm ready to try anything. Let's experiment.

> >
> > Here is the log from the mount to the scrub aborting and the result
> > from smartctl.
> >
> > Thanks for your precious help so far.
> >
> >
> > BTRFS error (device sdb1): cleaner transaction attach returned -30
> 
> Not sure what this is. The Btrfs cleaner is used to remove snapshots,
> decrement extent reference count, and if the count is 0, then free up
> that space. So, why is it running? I don't know what -30 means.
> 
> 
> > BTRFS info (device sdb1): disk space caching is enabled
> > BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14,
> > flush 7928, corrupt 1714507, gen 1335 BTRFS info (device sdb1):
> > bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21622, gen 24
> 
> I missed something the first time around in these messages: the
> generation error. Both drives have generation errors. A generation
> error on a single drive means that drive was not successfully being
> written to or was missing. For it to happen on both drives is bad. If
> it happens to just one drive, once it's reappears it will be passively
> caught up to the other one as reads happen, but best practice for now
> requires the user to run scrub or balance. If that doesn't happen and
> a 2nd drive vanishes or has write errors that cause generation
> mismatches, now both drives are simultaneously behind and ahead of
> each other. Some commits went to one drive, some went to the other.
> And right now Btrfs totally flips out and will irreparably get
> corrupted.
> 
> So I have to ask if this volume was ever mounted degraded? If not you
> really need to look at logs and find out why the drives weren't being
> written to. sdb show lots of write, flush, corruption and generation
> errors, so it seems like it was having a hardware issue. But then sda
> has only corruptions and generation problems, as if it wasn't even
> connected or powered on.
> 
> OR another possibility is one of the drives was previously cloned
> (block copied), or snapshot via LVM and you ran into the block level
> copies gotcha:
> https://btrfs.wiki.kernel.org/index.php/Gotchas
> 

I got some errors on sdb 2 months ago (I noticed it because it was
suddenly mounted read-only). I ran a scrub and a check --repair, and
a lot of errors were corrected. I deleted the files which were not
repairable and everything was running smoothly since. I ran a scrub a
few weeks ago and everything was fine.

I never mounted in degraded mode or made a snapshot via LVM (I only
upgraded both drives through "replace" 6 months ago).

> 
> > BTRFS warning (device sdb1): checksum error at logical 93445255168
> > on dev /dev/sdb1, sector 54528696, root 5, inode 3434831, offset
> > 479232, length 4096, links 1 (path:
> > user/.local/share/zeitgeist/activity.sqlite-wal)
> 
> Some extent data and its checksum don't match, on sdb. So this file is
> considered corrupt. Maybe the data is OK and the checksum is wrong?
> 
> > btrfs_dev_stat_print_on_error: 164 callbacks suppressed
> > BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14,
> > flush 7928, corrupt 1714508, gen 1335 scrub_handle_errored_block:
> > 164 callbacks suppressed BTRFS error (device sdb1): unable to fixup
> > (regular) error at logical 93445255168 on dev /dev/sdb1
> 
> And it can't be fixed, because...
> 
> > BTRFS warning (device sdb1): checksum error at logical 93445255168
> > on dev /dev/sda1, sector 77669048, root 5, inode 3434831, offset
> > 479232, length 4096, links 1 (path:
> > user/.local/share/zeitgeist/activity.sqlite-wal)
> 
> 
> The same block on sda also doesn't match checksum. So either both
> checksums are wrong, or both datas are wrong.
> 
> You can make these errors "go away" by using btrfs check --repair
> --init-csum-tree but what this does it it will totally paper over any
> real corruptions. You will have no idea if they're really corrupt or
> not without checking them. Looks like most of the messages have to do
> with files, not metadata although I didn't look at every single line.
> 

All these files are expendables (it seems to be files which were
written only recently). So I can safely delete them if necessary.

> I think the generations between the two drives is too far off for them
> to be put back together again. But if the --init-csum-tree starts to
> clean up the data related errors, you could use rsync -c to compare
> the files to a backup and see if they are the same and further inspect
> to see if they're corrupt or not.
> 
> You definitely don't want corrupt files propagating into your future
> backups. That's bad news.
> 

So if I understand correctly, you advise to use check --repair
--init-csum-tree and delete the files which were reported as having
checksum error ?
After that I can compare the important files to a backup, but there is
always the non-important files which are not backuped.

Is there anyway I can be sure afterwards that the volume is indeed
completely correct and reliable ?
If there is no way to be sure, I think it is better that I cp/rsync all
data to a new BTRFS volume.

Thanks for yout help !

Jun 28 11:34:43 system kernel: [49846.737005] perf: interrupt took too long (2509 > 2500), lowering kernel.perf_event_max_sample_rate to 79500
Jun 28 11:35:23 system kernel: [49887.681350] ata2.00: exception Emask 0x0 SAct 0x600 SErr 0x0 action 0x6 frozen
Jun 28 11:35:23 system kernel: [49887.685258] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 11:35:23 system kernel: [49887.689251] ata2.00: cmd 60/00:48:80:d7:70/01:00:0f:00:00/40 tag 9 ncq 131072 in
Jun 28 11:35:23 system kernel: [49887.689251]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 28 11:35:23 system kernel: [49887.696884] ata2.00: status: { DRDY }
Jun 28 11:35:23 system kernel: [49887.700353] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 11:35:23 system kernel: [49887.703749] ata2.00: cmd 60/00:50:80:d8:70/01:00:0f:00:00/40 tag 10 ncq 131072 in
Jun 28 11:35:23 system kernel: [49887.703749]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 28 11:35:23 system kernel: [49887.710243] ata2.00: status: { DRDY }
Jun 28 11:35:23 system kernel: [49887.713250] ata2: hard resetting link
Jun 28 11:35:24 system kernel: [49888.023941] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Jun 28 11:35:24 system kernel: [49888.037132] ata2.00: configured for UDMA/133
Jun 28 11:35:24 system kernel: [49888.037143] ata2: EH complete
Jun 28 11:35:27 system kernel: [49890.782261] ata2.00: exception Emask 0x0 SAct 0x2000 SErr 0x0 action 0x0
Jun 28 11:35:27 system kernel: [49890.783864] ata2.00: irq_stat 0x40000008
Jun 28 11:35:27 system kernel: [49890.785437] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 11:35:27 system kernel: [49890.787034] ata2.00: cmd 60/00:68:80:d7:70/01:00:0f:00:00/40 tag 13 ncq 131072 in
Jun 28 11:35:27 system kernel: [49890.787034]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 11:35:27 system kernel: [49890.794700] ata2.00: status: { DRDY ERR }
Jun 28 11:35:27 system kernel: [49890.796272] ata2.00: error: { UNC }
Jun 28 11:35:27 system kernel: [49890.811742] ata2.00: configured for UDMA/133
Jun 28 11:35:27 system kernel: [49890.811755] sd 1:0:0:0: [sdb] tag#13 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 11:35:27 system kernel: [49890.811758] sd 1:0:0:0: [sdb] tag#13 Sense Key : Medium Error [current] [descriptor] 
Jun 28 11:35:27 system kernel: [49890.811760] sd 1:0:0:0: [sdb] tag#13 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 11:35:27 system kernel: [49890.811763] sd 1:0:0:0: [sdb] tag#13 CDB: Read(10) 28 00 0f 70 d7 80 00 01 00 00
Jun 28 11:35:27 system kernel: [49890.811765] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 11:35:27 system kernel: [49890.813241] ata2: EH complete
Jun 28 11:35:29 system kernel: [49893.533391] ata2.00: exception Emask 0x0 SAct 0x4000000 SErr 0x0 action 0x0
Jun 28 11:35:29 system kernel: [49893.534241] ata2.00: irq_stat 0x40000008
Jun 28 11:35:29 system kernel: [49893.535065] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 11:35:29 system kernel: [49893.535883] ata2.00: cmd 60/08:d0:08:d8:70/00:00:0f:00:00/40 tag 26 ncq 4096 in
Jun 28 11:35:29 system kernel: [49893.535883]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 11:35:29 system kernel: [49893.537511] ata2.00: status: { DRDY ERR }
Jun 28 11:35:29 system kernel: [49893.538319] ata2.00: error: { UNC }
Jun 28 11:35:29 system kernel: [49893.553353] ata2.00: configured for UDMA/133
Jun 28 11:35:29 system kernel: [49893.553360] sd 1:0:0:0: [sdb] tag#26 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 11:35:29 system kernel: [49893.553362] sd 1:0:0:0: [sdb] tag#26 Sense Key : Medium Error [current] [descriptor] 
Jun 28 11:35:29 system kernel: [49893.553364] sd 1:0:0:0: [sdb] tag#26 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 11:35:29 system kernel: [49893.553365] sd 1:0:0:0: [sdb] tag#26 CDB: Read(10) 28 00 0f 70 d8 08 00 00 08 00
Jun 28 11:35:29 system kernel: [49893.553367] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 11:35:29 system kernel: [49893.554172] Buffer I/O error on dev sdb, logical block 32381697, async page read
Jun 28 11:35:29 system kernel: [49893.555125] ata2: EH complete
Jun 28 11:35:32 system kernel: [49896.284548] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Jun 28 11:35:32 system kernel: [49896.288067] ata2.00: irq_stat 0x40000008
Jun 28 11:35:32 system kernel: [49896.291516] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 11:35:32 system kernel: [49896.295130] ata2.00: cmd 60/08:00:08:d8:70/00:00:0f:00:00/40 tag 0 ncq 4096 in
Jun 28 11:35:32 system kernel: [49896.295130]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 11:35:32 system kernel: [49896.301235] ata2.00: status: { DRDY ERR }
Jun 28 11:35:32 system kernel: [49896.304039] ata2.00: error: { UNC }
Jun 28 11:35:32 system kernel: [49896.320080] ata2.00: configured for UDMA/133
Jun 28 11:35:32 system kernel: [49896.320097] sd 1:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 11:35:32 system kernel: [49896.320102] sd 1:0:0:0: [sdb] tag#0 Sense Key : Medium Error [current] [descriptor] 
Jun 28 11:35:32 system kernel: [49896.320106] sd 1:0:0:0: [sdb] tag#0 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 11:35:32 system kernel: [49896.320110] sd 1:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 0f 70 d8 08 00 00 08 00
Jun 28 11:35:32 system kernel: [49896.320113] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 11:35:32 system kernel: [49896.322349] Buffer I/O error on dev sdb, logical block 32381697, async page read
Jun 28 11:35:32 system kernel: [49896.325007] ata2: EH complete
Jun 28 11:44:13 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 11:44:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 61 to 57
Jun 28 11:44:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 99 to 97
Jun 28 11:44:13 system smartd[783]: Device: /dev/sdc [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 51 to 53
Jun 28 12:14:12 system smartd[783]: Device: /dev/sda [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 59 to 56
Jun 28 12:14:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 12:14:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 57 to 55
Jun 28 12:14:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 97 to 99
Jun 28 12:14:12 system smartd[783]: Device: /dev/sdc [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 53 to 56
Jun 28 12:44:12 system smartd[783]: Device: /dev/sda [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 56 to 55
Jun 28 12:44:13 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 12:44:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 55 to 54
Jun 28 12:44:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 99 to 95
Jun 28 13:14:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 13:14:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 95 to 97
Jun 28 13:44:13 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 13:44:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 54 to 55
Jun 28 13:44:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 97 to 98
Jun 28 14:14:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 14:44:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 15:14:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 15:14:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 98 to 97
Jun 28 15:44:12 system smartd[783]: Device: /dev/sda [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 55 to 56
Jun 28 15:44:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 15:44:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 97 to 95
Jun 28 16:03:34 system dhclient: DHCPREQUEST on eth0 to 192.168.1.1 port 67
Jun 28 16:03:34 system dhclient: DHCPACK from 192.168.1.1
Jun 28 16:03:34 system NetworkManager[774]: <info> (eth0): DHCPv4 state changed renew -> renew
Jun 28 16:03:34 system NetworkManager[774]: <info>   address 192.168.1.200
Jun 28 16:03:34 system NetworkManager[774]: <info>   plen 24 (255.255.255.0)
Jun 28 16:03:34 system NetworkManager[774]: <info>   gateway 192.168.1.1
Jun 28 16:03:34 system NetworkManager[774]: <info>   server identifier 192.168.1.1
Jun 28 16:03:34 system NetworkManager[774]: <info>   lease time 86400
Jun 28 16:03:34 system NetworkManager[774]: <info>   hostname 'system_ethernet'
Jun 28 16:03:34 system NetworkManager[774]: <info>   nameserver '192.168.1.1'
Jun 28 16:03:34 system dbus[801]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Jun 28 16:03:34 system dhclient: bound to 192.168.1.200 -- renewal in 32692 seconds.
Jun 28 16:03:34 system dbus[801]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Jun 28 16:03:34 system nm-dispatcher: Dispatching action 'dhcp4-change' for eth0
Jun 28 16:14:13 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 16:14:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 55 to 56
Jun 28 16:14:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 95 to 99
Jun 28 16:14:13 system smartd[783]: Device: /dev/sdc [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 56 to 55
Jun 28 16:16:13 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 16:21:50 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 16:38:20 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 16:44:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 16:44:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 99 to 96
Jun 28 16:50:21 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 17:02:21 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 17:14:13 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 17:14:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 96 to 100
Jun 28 17:14:21 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 17:21:24 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 17:28:25 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 17:40:34 system avahi-daemon[800]: Invalid response packet from host 192.168.1.32.
Jun 28 17:44:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 17:44:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 100 to 99
Jun 28 18:14:12 system smartd[783]: Device: /dev/sda [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 56 to 57
Jun 28 18:14:12 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 18:14:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 56 to 57
Jun 28 18:14:12 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 99 to 100
Jun 28 18:14:12 system smartd[783]: Device: /dev/sdc [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 55 to 54
Jun 28 18:44:13 system smartd[783]: Device: /dev/sdb [SAT], 1 Currently unreadable (pending) sectors
Jun 28 18:44:13 system smartd[783]: Device: /dev/sdb [SAT], SMART Usage Attribute: 242 Total_LBAs_Read changed from 100 to 96
Jun 28 18:45:44 system kernel: [75710.247647] ata2.00: exception Emask 0x0 SAct 0x10000 SErr 0x0 action 0x0
Jun 28 18:45:44 system kernel: [75710.249226] ata2.00: irq_stat 0x40000008
Jun 28 18:45:44 system kernel: [75710.250775] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:45:44 system kernel: [75710.254223] ata2.00: cmd 60/08:80:08:d8:70/00:00:0f:00:00/40 tag 16 ncq 4096 in
Jun 28 18:45:44 system kernel: [75710.254223]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:45:44 system kernel: [75710.260891] ata2.00: status: { DRDY ERR }
Jun 28 18:45:44 system kernel: [75710.262803] ata2.00: error: { UNC }
Jun 28 18:45:44 system kernel: [75710.277857] ata2.00: configured for UDMA/133
Jun 28 18:45:44 system kernel: [75710.277868] sd 1:0:0:0: [sdb] tag#16 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:45:44 system kernel: [75710.277871] sd 1:0:0:0: [sdb] tag#16 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:45:44 system kernel: [75710.277874] sd 1:0:0:0: [sdb] tag#16 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:45:44 system kernel: [75710.277877] sd 1:0:0:0: [sdb] tag#16 CDB: Read(10) 28 00 0f 70 d8 08 00 00 08 00
Jun 28 18:45:44 system kernel: [75710.277879] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 18:45:44 system kernel: [75710.279274] ata2: EH complete
Jun 28 18:45:47 system kernel: [75713.009880] ata2.00: exception Emask 0x0 SAct 0x200000 SErr 0x0 action 0x0
Jun 28 18:45:47 system kernel: [75713.012309] ata2.00: irq_stat 0x40000008
Jun 28 18:45:47 system kernel: [75713.014680] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:45:47 system kernel: [75713.017163] ata2.00: cmd 60/08:a8:08:d8:70/00:00:0f:00:00/40 tag 21 ncq 4096 in
Jun 28 18:45:47 system kernel: [75713.017163]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:45:47 system kernel: [75713.021895] ata2.00: status: { DRDY ERR }
Jun 28 18:45:47 system kernel: [75713.024094] ata2.00: error: { UNC }
Jun 28 18:45:47 system kernel: [75713.039089] ata2.00: configured for UDMA/133
Jun 28 18:45:47 system kernel: [75713.039102] sd 1:0:0:0: [sdb] tag#21 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:45:47 system kernel: [75713.039106] sd 1:0:0:0: [sdb] tag#21 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:45:47 system kernel: [75713.039109] sd 1:0:0:0: [sdb] tag#21 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:45:47 system kernel: [75713.039112] sd 1:0:0:0: [sdb] tag#21 CDB: Read(10) 28 00 0f 70 d8 08 00 00 08 00
Jun 28 18:45:47 system kernel: [75713.039114] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 18:45:47 system kernel: [75713.040604] Buffer I/O error on dev sdb, logical block 32381697, async page read
Jun 28 18:45:47 system kernel: [75713.042117] ata2: EH complete
Jun 28 18:45:50 system kernel: [75715.816494] ata2.00: exception Emask 0x0 SAct 0x20000000 SErr 0x0 action 0x0
Jun 28 18:45:50 system kernel: [75715.819694] ata2.00: irq_stat 0x40000008
Jun 28 18:45:50 system kernel: [75715.822831] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:45:50 system kernel: [75715.826094] ata2.00: cmd 60/08:e8:08:d8:70/00:00:0f:00:00/40 tag 29 ncq 4096 in
Jun 28 18:45:50 system kernel: [75715.826094]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:45:50 system kernel: [75715.832324] ata2.00: status: { DRDY ERR }
Jun 28 18:45:50 system kernel: [75715.835140] ata2.00: error: { UNC }
Jun 28 18:45:50 system kernel: [75715.852239] ata2.00: configured for UDMA/133
Jun 28 18:45:50 system kernel: [75715.852263] sd 1:0:0:0: [sdb] tag#29 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:45:50 system kernel: [75715.852271] sd 1:0:0:0: [sdb] tag#29 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:45:50 system kernel: [75715.852277] sd 1:0:0:0: [sdb] tag#29 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:45:50 system kernel: [75715.852285] sd 1:0:0:0: [sdb] tag#29 CDB: Read(10) 28 00 0f 70 d8 08 00 00 08 00
Jun 28 18:45:50 system kernel: [75715.852290] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 18:45:50 system kernel: [75715.856216] Buffer I/O error on dev sdb, logical block 32381697, async page read
Jun 28 18:45:50 system kernel: [75715.859438] ata2: EH complete
Jun 28 18:45:53 system kernel: [75718.634863]  sdd: sdd1 sdd2
Jun 28 18:47:07 system kernel: [75793.402923] ata2.00: exception Emask 0x0 SAct 0x4000 SErr 0x0 action 0x0
Jun 28 18:47:07 system kernel: [75793.404224] ata2.00: irq_stat 0x40000008
Jun 28 18:47:07 system kernel: [75793.405487] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:07 system kernel: [75793.406743] ata2.00: cmd 60/01:70:09:d8:70/00:00:0f:00:00/40 tag 14 ncq 512 in
Jun 28 18:47:07 system kernel: [75793.406743]          res 41/40:00:09:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:07 system kernel: [75793.409295] ata2.00: status: { DRDY ERR }
Jun 28 18:47:07 system kernel: [75793.412577] ata2.00: error: { UNC }
Jun 28 18:47:07 system kernel: [75793.428802] ata2.00: configured for UDMA/133
Jun 28 18:47:07 system kernel: [75793.428819] sd 1:0:0:0: [sdb] tag#14 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:07 system kernel: [75793.428824] sd 1:0:0:0: [sdb] tag#14 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:07 system kernel: [75793.428828] sd 1:0:0:0: [sdb] tag#14 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:07 system kernel: [75793.428832] sd 1:0:0:0: [sdb] tag#14 CDB: Read(10) 28 00 0f 70 d8 09 00 00 01 00
Jun 28 18:47:07 system kernel: [75793.428835] blk_update_request: I/O error, dev sdb, sector 259053577
Jun 28 18:47:07 system kernel: [75793.431406] ata2: EH complete
Jun 28 18:47:10 system kernel: [75796.154073] ata2.00: exception Emask 0x0 SAct 0x80000 SErr 0x0 action 0x0
Jun 28 18:47:10 system kernel: [75796.157105] ata2.00: irq_stat 0x40000008
Jun 28 18:47:10 system kernel: [75796.160078] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:10 system kernel: [75796.163212] ata2.00: cmd 60/01:98:0a:d8:70/00:00:0f:00:00/40 tag 19 ncq 512 in
Jun 28 18:47:10 system kernel: [75796.163212]          res 41/40:00:0a:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:10 system kernel: [75796.169209] ata2.00: status: { DRDY ERR }
Jun 28 18:47:10 system kernel: [75796.171919] ata2.00: error: { UNC }
Jun 28 18:47:10 system kernel: [75796.187795] ata2.00: configured for UDMA/133
Jun 28 18:47:10 system kernel: [75796.187813] sd 1:0:0:0: [sdb] tag#19 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:10 system kernel: [75796.187819] sd 1:0:0:0: [sdb] tag#19 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:10 system kernel: [75796.187823] sd 1:0:0:0: [sdb] tag#19 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:10 system kernel: [75796.187827] sd 1:0:0:0: [sdb] tag#19 CDB: Read(10) 28 00 0f 70 d8 0a 00 00 01 00
Jun 28 18:47:10 system kernel: [75796.187831] blk_update_request: I/O error, dev sdb, sector 259053578
Jun 28 18:47:10 system kernel: [75796.190051] ata2: EH complete
Jun 28 18:47:13 system kernel: [75798.916308] ata2.00: exception Emask 0x0 SAct 0x4 SErr 0x0 action 0x0
Jun 28 18:47:13 system kernel: [75798.919315] ata2.00: irq_stat 0x40000008
Jun 28 18:47:13 system kernel: [75798.922296] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:13 system kernel: [75798.926192] ata2.00: cmd 60/01:10:0b:d8:70/00:00:0f:00:00/40 tag 2 ncq 512 in
Jun 28 18:47:13 system kernel: [75798.926192]          res 41/40:00:0b:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:13 system kernel: [75798.932238] ata2.00: status: { DRDY ERR }
Jun 28 18:47:13 system kernel: [75798.934953] ata2.00: error: { UNC }
Jun 28 18:47:13 system kernel: [75798.950911] ata2.00: configured for UDMA/133
Jun 28 18:47:13 system kernel: [75798.950932] sd 1:0:0:0: [sdb] tag#2 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:13 system kernel: [75798.950937] sd 1:0:0:0: [sdb] tag#2 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:13 system kernel: [75798.950942] sd 1:0:0:0: [sdb] tag#2 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:13 system kernel: [75798.950947] sd 1:0:0:0: [sdb] tag#2 CDB: Read(10) 28 00 0f 70 d8 0b 00 00 01 00
Jun 28 18:47:13 system kernel: [75798.950951] blk_update_request: I/O error, dev sdb, sector 259053579
Jun 28 18:47:13 system kernel: [75798.953386] ata2: EH complete
Jun 28 18:47:16 system kernel: [75801.678506] ata2.00: exception Emask 0x0 SAct 0x40000 SErr 0x0 action 0x0
Jun 28 18:47:16 system kernel: [75801.679200] ata2.00: irq_stat 0x40000008
Jun 28 18:47:16 system kernel: [75801.679875] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:16 system kernel: [75801.680558] ata2.00: cmd 60/01:90:0c:d8:70/00:00:0f:00:00/40 tag 18 ncq 512 in
Jun 28 18:47:16 system kernel: [75801.680558]          res 41/40:00:0c:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:16 system kernel: [75801.683620] ata2.00: status: { DRDY ERR }
Jun 28 18:47:16 system kernel: [75801.685104] ata2.00: error: { UNC }
Jun 28 18:47:16 system kernel: [75801.699814] ata2.00: configured for UDMA/133
Jun 28 18:47:16 system kernel: [75801.699822] sd 1:0:0:0: [sdb] tag#18 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:16 system kernel: [75801.699824] sd 1:0:0:0: [sdb] tag#18 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:16 system kernel: [75801.699825] sd 1:0:0:0: [sdb] tag#18 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:16 system kernel: [75801.699827] sd 1:0:0:0: [sdb] tag#18 CDB: Read(10) 28 00 0f 70 d8 0c 00 00 01 00
Jun 28 18:47:16 system kernel: [75801.699828] blk_update_request: I/O error, dev sdb, sector 259053580
Jun 28 18:47:16 system kernel: [75801.700513] ata2: EH complete
Jun 28 18:47:18 system kernel: [75804.429671] ata2.00: exception Emask 0x0 SAct 0x4 SErr 0x0 action 0x0
Jun 28 18:47:18 system kernel: [75804.432653] ata2.00: irq_stat 0x40000008
Jun 28 18:47:18 system kernel: [75804.435586] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:18 system kernel: [75804.438532] ata2.00: cmd 60/01:10:0d:d8:70/00:00:0f:00:00/40 tag 2 ncq 512 in
Jun 28 18:47:18 system kernel: [75804.438532]          res 41/40:00:0d:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:18 system kernel: [75804.444640] ata2.00: status: { DRDY ERR }
Jun 28 18:47:18 system kernel: [75804.447298] ata2.00: error: { UNC }
Jun 28 18:47:18 system kernel: [75804.463171] ata2.00: configured for UDMA/133
Jun 28 18:47:18 system kernel: [75804.463191] sd 1:0:0:0: [sdb] tag#2 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:18 system kernel: [75804.463197] sd 1:0:0:0: [sdb] tag#2 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:18 system kernel: [75804.463201] sd 1:0:0:0: [sdb] tag#2 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:18 system kernel: [75804.463206] sd 1:0:0:0: [sdb] tag#2 CDB: Read(10) 28 00 0f 70 d8 0d 00 00 01 00
Jun 28 18:47:18 system kernel: [75804.463209] blk_update_request: I/O error, dev sdb, sector 259053581
Jun 28 18:47:18 system kernel: [75804.465591] ata2: EH complete
Jun 28 18:47:21 system kernel: [75807.191900] ata2.00: exception Emask 0x0 SAct 0x20000 SErr 0x0 action 0x0
Jun 28 18:47:21 system kernel: [75807.194879] ata2.00: irq_stat 0x40000008
Jun 28 18:47:21 system kernel: [75807.197469] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:21 system kernel: [75807.200204] ata2.00: cmd 60/01:88:0e:d8:70/00:00:0f:00:00/40 tag 17 ncq 512 in
Jun 28 18:47:21 system kernel: [75807.200204]          res 41/40:00:0e:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:21 system kernel: [75807.205435] ata2.00: status: { DRDY ERR }
Jun 28 18:47:21 system kernel: [75807.207823] ata2.00: error: { UNC }
Jun 28 18:47:21 system kernel: [75807.223069] ata2.00: configured for UDMA/133
Jun 28 18:47:21 system kernel: [75807.223087] sd 1:0:0:0: [sdb] tag#17 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:21 system kernel: [75807.223092] sd 1:0:0:0: [sdb] tag#17 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:21 system kernel: [75807.223096] sd 1:0:0:0: [sdb] tag#17 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:21 system kernel: [75807.223100] sd 1:0:0:0: [sdb] tag#17 CDB: Read(10) 28 00 0f 70 d8 0e 00 00 01 00
Jun 28 18:47:21 system kernel: [75807.223103] blk_update_request: I/O error, dev sdb, sector 259053582
Jun 28 18:47:21 system kernel: [75807.225080] ata2: EH complete
Jun 28 18:47:24 system kernel: [75809.954101] ata2.00: exception Emask 0x0 SAct 0x2 SErr 0x0 action 0x0
Jun 28 18:47:24 system kernel: [75809.954785] ata2.00: irq_stat 0x40000008
Jun 28 18:47:24 system kernel: [75809.955447] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:24 system kernel: [75809.956111] ata2.00: cmd 60/01:08:08:d8:70/00:00:0f:00:00/40 tag 1 ncq 512 in
Jun 28 18:47:24 system kernel: [75809.956111]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:24 system kernel: [75809.957465] ata2.00: status: { DRDY ERR }
Jun 28 18:47:24 system kernel: [75809.958127] ata2.00: error: { UNC }
Jun 28 18:47:24 system kernel: [75809.971936] ata2.00: configured for UDMA/133
Jun 28 18:47:24 system kernel: [75809.971944] sd 1:0:0:0: [sdb] tag#1 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:24 system kernel: [75809.971946] sd 1:0:0:0: [sdb] tag#1 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:24 system kernel: [75809.971947] sd 1:0:0:0: [sdb] tag#1 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:24 system kernel: [75809.971949] sd 1:0:0:0: [sdb] tag#1 CDB: Read(10) 28 00 0f 70 d8 08 00 00 01 00
Jun 28 18:47:24 system kernel: [75809.971950] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 18:47:24 system kernel: [75809.972624] ata2: EH complete
Jun 28 18:47:27 system kernel: [75812.705263] ata2.00: exception Emask 0x0 SAct 0x10000 SErr 0x0 action 0x0
Jun 28 18:47:27 system kernel: [75812.708197] ata2.00: irq_stat 0x40000008
Jun 28 18:47:27 system kernel: [75812.711087] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:27 system kernel: [75812.714039] ata2.00: cmd 60/01:80:09:d8:70/00:00:0f:00:00/40 tag 16 ncq 512 in
Jun 28 18:47:27 system kernel: [75812.714039]          res 41/40:00:09:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:27 system kernel: [75812.719889] ata2.00: status: { DRDY ERR }
Jun 28 18:47:27 system kernel: [75812.722480] ata2.00: error: { UNC }
Jun 28 18:47:27 system kernel: [75812.738338] ata2.00: configured for UDMA/133
Jun 28 18:47:27 system kernel: [75812.738358] sd 1:0:0:0: [sdb] tag#16 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:27 system kernel: [75812.738364] sd 1:0:0:0: [sdb] tag#16 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:27 system kernel: [75812.738369] sd 1:0:0:0: [sdb] tag#16 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:27 system kernel: [75812.738374] sd 1:0:0:0: [sdb] tag#16 CDB: Read(10) 28 00 0f 70 d8 09 00 00 01 00
Jun 28 18:47:27 system kernel: [75812.738377] blk_update_request: I/O error, dev sdb, sector 259053577
Jun 28 18:47:27 system kernel: [75812.740705] ata2: EH complete
Jun 28 18:47:29 system kernel: [75815.467499] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Jun 28 18:47:29 system kernel: [75815.470432] ata2.00: irq_stat 0x40000008
Jun 28 18:47:29 system kernel: [75815.473288] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:29 system kernel: [75815.476150] ata2.00: cmd 60/01:00:0a:d8:70/00:00:0f:00:00/40 tag 0 ncq 512 in
Jun 28 18:47:29 system kernel: [75815.476150]          res 41/40:00:0a:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:29 system kernel: [75815.482017] ata2.00: status: { DRDY ERR }
Jun 28 18:47:29 system kernel: [75815.484556] ata2.00: error: { UNC }
Jun 28 18:47:29 system kernel: [75815.500453] ata2.00: configured for UDMA/133
Jun 28 18:47:29 system kernel: [75815.500472] sd 1:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:29 system kernel: [75815.500477] sd 1:0:0:0: [sdb] tag#0 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:29 system kernel: [75815.500481] sd 1:0:0:0: [sdb] tag#0 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:29 system kernel: [75815.500486] sd 1:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 0f 70 d8 0a 00 00 01 00
Jun 28 18:47:29 system kernel: [75815.500489] blk_update_request: I/O error, dev sdb, sector 259053578
Jun 28 18:47:29 system kernel: [75815.502596] ata2: EH complete
Jun 28 18:47:32 system kernel: [75818.229731] ata2.00: exception Emask 0x0 SAct 0x8000 SErr 0x0 action 0x0
Jun 28 18:47:32 system kernel: [75818.232312] ata2.00: irq_stat 0x40000008
Jun 28 18:47:32 system kernel: [75818.234886] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:32 system kernel: [75818.237860] ata2.00: cmd 60/01:78:0b:d8:70/00:00:0f:00:00/40 tag 15 ncq 512 in
Jun 28 18:47:32 system kernel: [75818.237860]          res 41/40:00:0b:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:32 system kernel: [75818.243629] ata2.00: status: { DRDY ERR }
Jun 28 18:47:32 system kernel: [75818.245984] ata2.00: error: { UNC }
Jun 28 18:47:32 system kernel: [75818.261562] ata2.00: configured for UDMA/133
Jun 28 18:47:32 system kernel: [75818.261581] sd 1:0:0:0: [sdb] tag#15 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:32 system kernel: [75818.261586] sd 1:0:0:0: [sdb] tag#15 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:32 system kernel: [75818.261590] sd 1:0:0:0: [sdb] tag#15 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:32 system kernel: [75818.261595] sd 1:0:0:0: [sdb] tag#15 CDB: Read(10) 28 00 0f 70 d8 0b 00 00 01 00
Jun 28 18:47:32 system kernel: [75818.261598] blk_update_request: I/O error, dev sdb, sector 259053579
Jun 28 18:47:32 system kernel: [75818.263682] ata2: EH complete
Jun 28 18:47:35 system kernel: [75821.003002] ata2.00: exception Emask 0x0 SAct 0x40000000 SErr 0x0 action 0x0
Jun 28 18:47:35 system kernel: [75821.003677] ata2.00: irq_stat 0x40000008
Jun 28 18:47:35 system kernel: [75821.004332] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:35 system kernel: [75821.004985] ata2.00: cmd 60/01:f0:0c:d8:70/00:00:0f:00:00/40 tag 30 ncq 512 in
Jun 28 18:47:35 system kernel: [75821.004985]          res 41/40:00:0c:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:35 system kernel: [75821.006304] ata2.00: status: { DRDY ERR }
Jun 28 18:47:35 system kernel: [75821.006996] ata2.00: error: { UNC }
Jun 28 18:47:35 system kernel: [75821.020725] ata2.00: configured for UDMA/133
Jun 28 18:47:35 system kernel: [75821.020732] sd 1:0:0:0: [sdb] tag#30 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:35 system kernel: [75821.020734] sd 1:0:0:0: [sdb] tag#30 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:35 system kernel: [75821.020736] sd 1:0:0:0: [sdb] tag#30 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:35 system kernel: [75821.020737] sd 1:0:0:0: [sdb] tag#30 CDB: Read(10) 28 00 0f 70 d8 0c 00 00 01 00
Jun 28 18:47:35 system kernel: [75821.020739] blk_update_request: I/O error, dev sdb, sector 259053580
Jun 28 18:47:35 system kernel: [75821.021400] ata2: EH complete
Jun 28 18:47:38 system kernel: [75823.743062] ata2.00: exception Emask 0x0 SAct 0x4000 SErr 0x0 action 0x0
Jun 28 18:47:38 system kernel: [75823.743872] ata2.00: irq_stat 0x40000008
Jun 28 18:47:38 system kernel: [75823.744661] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:38 system kernel: [75823.745446] ata2.00: cmd 60/01:70:0d:d8:70/00:00:0f:00:00/40 tag 14 ncq 512 in
Jun 28 18:47:38 system kernel: [75823.745446]          res 41/40:00:0d:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:38 system kernel: [75823.747035] ata2.00: status: { DRDY ERR }
Jun 28 18:47:38 system kernel: [75823.749511] ata2.00: error: { UNC }
Jun 28 18:47:38 system kernel: [75823.764986] ata2.00: configured for UDMA/133
Jun 28 18:47:38 system kernel: [75823.764997] sd 1:0:0:0: [sdb] tag#14 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:38 system kernel: [75823.765000] sd 1:0:0:0: [sdb] tag#14 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:38 system kernel: [75823.765002] sd 1:0:0:0: [sdb] tag#14 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:38 system kernel: [75823.765005] sd 1:0:0:0: [sdb] tag#14 CDB: Read(10) 28 00 0f 70 d8 0d 00 00 01 00
Jun 28 18:47:38 system kernel: [75823.765007] blk_update_request: I/O error, dev sdb, sector 259053581
Jun 28 18:47:38 system kernel: [75823.766111] ata2: EH complete
Jun 28 18:47:40 system kernel: [75826.494226] ata2.00: exception Emask 0x0 SAct 0x20000000 SErr 0x0 action 0x0
Jun 28 18:47:40 system kernel: [75826.497139] ata2.00: irq_stat 0x40000008
Jun 28 18:47:40 system kernel: [75826.500020] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:40 system kernel: [75826.503200] ata2.00: cmd 60/01:e8:0e:d8:70/00:00:0f:00:00/40 tag 29 ncq 512 in
Jun 28 18:47:40 system kernel: [75826.503200]          res 41/40:00:0e:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:40 system kernel: [75826.509006] ata2.00: status: { DRDY ERR }
Jun 28 18:47:40 system kernel: [75826.511670] ata2.00: error: { UNC }
Jun 28 18:47:40 system kernel: [75826.527534] ata2.00: configured for UDMA/133
Jun 28 18:47:40 system kernel: [75826.527554] sd 1:0:0:0: [sdb] tag#29 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:40 system kernel: [75826.527560] sd 1:0:0:0: [sdb] tag#29 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:40 system kernel: [75826.527564] sd 1:0:0:0: [sdb] tag#29 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:40 system kernel: [75826.527569] sd 1:0:0:0: [sdb] tag#29 CDB: Read(10) 28 00 0f 70 d8 0e 00 00 01 00
Jun 28 18:47:40 system kernel: [75826.527573] blk_update_request: I/O error, dev sdb, sector 259053582
Jun 28 18:47:40 system kernel: [75826.529882] ata2: EH complete
Jun 28 18:47:43 system kernel: [75829.256439] ata2.00: exception Emask 0x0 SAct 0x2000 SErr 0x0 action 0x0
Jun 28 18:47:43 system kernel: [75829.257615] ata2.00: irq_stat 0x40000008
Jun 28 18:47:43 system kernel: [75829.258774] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:43 system kernel: [75829.261778] ata2.00: cmd 60/01:68:0f:d8:70/00:00:0f:00:00/40 tag 13 ncq 512 in
Jun 28 18:47:43 system kernel: [75829.261778]          res 41/40:00:0f:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:43 system kernel: [75829.267570] ata2.00: status: { DRDY ERR }
Jun 28 18:47:43 system kernel: [75829.269152] ata2.00: error: { UNC }
Jun 28 18:47:43 system kernel: [75829.283951] ata2.00: configured for UDMA/133
Jun 28 18:47:43 system kernel: [75829.283966] sd 1:0:0:0: [sdb] tag#13 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:43 system kernel: [75829.283969] sd 1:0:0:0: [sdb] tag#13 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:43 system kernel: [75829.283972] sd 1:0:0:0: [sdb] tag#13 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:43 system kernel: [75829.283976] sd 1:0:0:0: [sdb] tag#13 CDB: Read(10) 28 00 0f 70 d8 0f 00 00 01 00
Jun 28 18:47:43 system kernel: [75829.283978] blk_update_request: I/O error, dev sdb, sector 259053583
Jun 28 18:47:43 system kernel: [75829.285422] ata2: EH complete
Jun 28 18:47:46 system kernel: [75832.007561] ata2.00: exception Emask 0x0 SAct 0x10000000 SErr 0x0 action 0x0
Jun 28 18:47:46 system kernel: [75832.008238] ata2.00: irq_stat 0x40000008
Jun 28 18:47:46 system kernel: [75832.008896] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:46 system kernel: [75832.009551] ata2.00: cmd 60/01:e0:0f:d8:70/00:00:0f:00:00/40 tag 28 ncq 512 in
Jun 28 18:47:46 system kernel: [75832.009551]          res 41/40:00:0f:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:46 system kernel: [75832.010882] ata2.00: status: { DRDY ERR }
Jun 28 18:47:46 system kernel: [75832.012345] ata2.00: error: { UNC }
Jun 28 18:47:46 system kernel: [75832.026973] ata2.00: configured for UDMA/133
Jun 28 18:47:46 system kernel: [75832.026981] sd 1:0:0:0: [sdb] tag#28 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:46 system kernel: [75832.026983] sd 1:0:0:0: [sdb] tag#28 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:46 system kernel: [75832.026985] sd 1:0:0:0: [sdb] tag#28 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:46 system kernel: [75832.026987] sd 1:0:0:0: [sdb] tag#28 CDB: Read(10) 28 00 0f 70 d8 0f 00 00 01 00
Jun 28 18:47:46 system kernel: [75832.026988] blk_update_request: I/O error, dev sdb, sector 259053583
Jun 28 18:47:46 system kernel: [75832.027654] ata2: EH complete
Jun 28 18:47:49 system kernel: [75834.758706] ata2.00: exception Emask 0x0 SAct 0x1000 SErr 0x0 action 0x0
Jun 28 18:47:49 system kernel: [75834.759523] ata2.00: irq_stat 0x40000008
Jun 28 18:47:49 system kernel: [75834.760319] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:49 system kernel: [75834.761111] ata2.00: cmd 60/01:60:0e:d8:70/00:00:0f:00:00/40 tag 12 ncq 512 in
Jun 28 18:47:49 system kernel: [75834.761111]          res 41/40:00:0e:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:49 system kernel: [75834.762712] ata2.00: status: { DRDY ERR }
Jun 28 18:47:49 system kernel: [75834.765211] ata2.00: error: { UNC }
Jun 28 18:47:49 system kernel: [75834.780699] ata2.00: configured for UDMA/133
Jun 28 18:47:49 system kernel: [75834.780707] sd 1:0:0:0: [sdb] tag#12 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:49 system kernel: [75834.780709] sd 1:0:0:0: [sdb] tag#12 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:49 system kernel: [75834.780711] sd 1:0:0:0: [sdb] tag#12 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:49 system kernel: [75834.780712] sd 1:0:0:0: [sdb] tag#12 CDB: Read(10) 28 00 0f 70 d8 0e 00 00 01 00
Jun 28 18:47:49 system kernel: [75834.780713] blk_update_request: I/O error, dev sdb, sector 259053582
Jun 28 18:47:49 system kernel: [75834.781377] ata2: EH complete
Jun 28 18:47:51 system kernel: [75837.509851] ata2.00: exception Emask 0x0 SAct 0x8000000 SErr 0x0 action 0x0
Jun 28 18:47:51 system kernel: [75837.511330] ata2.00: irq_stat 0x40000008
Jun 28 18:47:51 system kernel: [75837.512771] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:51 system kernel: [75837.514209] ata2.00: cmd 60/01:d8:0d:d8:70/00:00:0f:00:00/40 tag 27 ncq 512 in
Jun 28 18:47:51 system kernel: [75837.514209]          res 41/40:00:0d:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:51 system kernel: [75837.517114] ata2.00: status: { DRDY ERR }
Jun 28 18:47:51 system kernel: [75837.520241] ata2.00: error: { UNC }
Jun 28 18:47:51 system kernel: [75837.534463] ata2.00: configured for UDMA/133
Jun 28 18:47:51 system kernel: [75837.534472] sd 1:0:0:0: [sdb] tag#27 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:51 system kernel: [75837.534474] sd 1:0:0:0: [sdb] tag#27 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:51 system kernel: [75837.534477] sd 1:0:0:0: [sdb] tag#27 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:51 system kernel: [75837.534479] sd 1:0:0:0: [sdb] tag#27 CDB: Read(10) 28 00 0f 70 d8 0d 00 00 01 00
Jun 28 18:47:51 system kernel: [75837.534480] blk_update_request: I/O error, dev sdb, sector 259053581
Jun 28 18:47:51 system kernel: [75837.535423] ata2: EH complete
Jun 28 18:47:54 system kernel: [75840.261004] ata2.00: exception Emask 0x0 SAct 0x800 SErr 0x0 action 0x0
Jun 28 18:47:54 system kernel: [75840.263953] ata2.00: irq_stat 0x40000008
Jun 28 18:47:54 system kernel: [75840.266842] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:54 system kernel: [75840.269741] ata2.00: cmd 60/01:58:0c:d8:70/00:00:0f:00:00/40 tag 11 ncq 512 in
Jun 28 18:47:54 system kernel: [75840.269741]          res 41/40:00:0c:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:54 system kernel: [75840.275705] ata2.00: status: { DRDY ERR }
Jun 28 18:47:54 system kernel: [75840.278279] ata2.00: error: { UNC }
Jun 28 18:47:54 system kernel: [75840.294204] ata2.00: configured for UDMA/133
Jun 28 18:47:54 system kernel: [75840.294225] sd 1:0:0:0: [sdb] tag#11 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:54 system kernel: [75840.294230] sd 1:0:0:0: [sdb] tag#11 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:54 system kernel: [75840.294235] sd 1:0:0:0: [sdb] tag#11 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:54 system kernel: [75840.294240] sd 1:0:0:0: [sdb] tag#11 CDB: Read(10) 28 00 0f 70 d8 0c 00 00 01 00
Jun 28 18:47:54 system kernel: [75840.294244] blk_update_request: I/O error, dev sdb, sector 259053580
Jun 28 18:47:54 system kernel: [75840.296588] ata2: EH complete
Jun 28 18:47:57 system kernel: [75843.023208] ata2.00: exception Emask 0x0 SAct 0x4000000 SErr 0x0 action 0x0
Jun 28 18:47:57 system kernel: [75843.024342] ata2.00: irq_stat 0x40000008
Jun 28 18:47:57 system kernel: [75843.025445] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:47:57 system kernel: [75843.026543] ata2.00: cmd 60/01:d0:0b:d8:70/00:00:0f:00:00/40 tag 26 ncq 512 in
Jun 28 18:47:57 system kernel: [75843.026543]          res 41/40:00:0b:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:47:57 system kernel: [75843.028757] ata2.00: status: { DRDY ERR }
Jun 28 18:47:57 system kernel: [75843.031683] ata2.00: error: { UNC }
Jun 28 18:47:57 system kernel: [75843.047781] ata2.00: configured for UDMA/133
Jun 28 18:47:57 system kernel: [75843.047798] sd 1:0:0:0: [sdb] tag#26 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:47:57 system kernel: [75843.047803] sd 1:0:0:0: [sdb] tag#26 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:47:57 system kernel: [75843.047807] sd 1:0:0:0: [sdb] tag#26 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:47:57 system kernel: [75843.047812] sd 1:0:0:0: [sdb] tag#26 CDB: Read(10) 28 00 0f 70 d8 0b 00 00 01 00
Jun 28 18:47:57 system kernel: [75843.047815] blk_update_request: I/O error, dev sdb, sector 259053579
Jun 28 18:47:57 system kernel: [75843.049799] ata2: EH complete
Jun 28 18:48:00 system kernel: [75845.785467] ata2.00: exception Emask 0x0 SAct 0x400 SErr 0x0 action 0x0
Jun 28 18:48:00 system kernel: [75845.788096] ata2.00: irq_stat 0x40000008
Jun 28 18:48:00 system kernel: [75845.790665] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:00 system kernel: [75845.793238] ata2.00: cmd 60/01:50:0a:d8:70/00:00:0f:00:00/40 tag 10 ncq 512 in
Jun 28 18:48:00 system kernel: [75845.793238]          res 41/40:00:0a:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:00 system kernel: [75845.799173] ata2.00: status: { DRDY ERR }
Jun 28 18:48:00 system kernel: [75845.801521] ata2.00: error: { UNC }
Jun 28 18:48:00 system kernel: [75845.817189] ata2.00: configured for UDMA/133
Jun 28 18:48:00 system kernel: [75845.817207] sd 1:0:0:0: [sdb] tag#10 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:00 system kernel: [75845.817212] sd 1:0:0:0: [sdb] tag#10 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:00 system kernel: [75845.817216] sd 1:0:0:0: [sdb] tag#10 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:00 system kernel: [75845.817220] sd 1:0:0:0: [sdb] tag#10 CDB: Read(10) 28 00 0f 70 d8 0a 00 00 01 00
Jun 28 18:48:00 system kernel: [75845.817223] blk_update_request: I/O error, dev sdb, sector 259053578
Jun 28 18:48:00 system kernel: [75845.819164] ata2: EH complete
Jun 28 18:48:02 system kernel: [75848.547661] ata2.00: exception Emask 0x0 SAct 0x2000000 SErr 0x0 action 0x0
Jun 28 18:48:02 system kernel: [75848.548345] ata2.00: irq_stat 0x40000008
Jun 28 18:48:02 system kernel: [75848.549008] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:02 system kernel: [75848.549668] ata2.00: cmd 60/01:c8:09:d8:70/00:00:0f:00:00/40 tag 25 ncq 512 in
Jun 28 18:48:02 system kernel: [75848.549668]          res 41/40:00:09:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:02 system kernel: [75848.550997] ata2.00: status: { DRDY ERR }
Jun 28 18:48:02 system kernel: [75848.551663] ata2.00: error: { UNC }
Jun 28 18:48:02 system kernel: [75848.566255] ata2.00: configured for UDMA/133
Jun 28 18:48:02 system kernel: [75848.566263] sd 1:0:0:0: [sdb] tag#25 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:02 system kernel: [75848.566265] sd 1:0:0:0: [sdb] tag#25 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:02 system kernel: [75848.566267] sd 1:0:0:0: [sdb] tag#25 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:02 system kernel: [75848.566269] sd 1:0:0:0: [sdb] tag#25 CDB: Read(10) 28 00 0f 70 d8 09 00 00 01 00
Jun 28 18:48:02 system kernel: [75848.566270] blk_update_request: I/O error, dev sdb, sector 259053577
Jun 28 18:48:02 system kernel: [75848.566938] ata2: EH complete
Jun 28 18:48:05 system kernel: [75851.298823] ata2.00: exception Emask 0x0 SAct 0x200 SErr 0x0 action 0x0
Jun 28 18:48:05 system kernel: [75851.301447] ata2.00: irq_stat 0x40000008
Jun 28 18:48:05 system kernel: [75851.304035] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:05 system kernel: [75851.307092] ata2.00: cmd 60/01:48:08:d8:70/00:00:0f:00:00/40 tag 9 ncq 512 in
Jun 28 18:48:05 system kernel: [75851.307092]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:05 system kernel: [75851.312926] ata2.00: status: { DRDY ERR }
Jun 28 18:48:05 system kernel: [75851.315313] ata2.00: error: { UNC }
Jun 28 18:48:05 system kernel: [75851.330867] ata2.00: configured for UDMA/133
Jun 28 18:48:05 system kernel: [75851.330884] sd 1:0:0:0: [sdb] tag#9 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:05 system kernel: [75851.330889] sd 1:0:0:0: [sdb] tag#9 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:05 system kernel: [75851.330893] sd 1:0:0:0: [sdb] tag#9 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:05 system kernel: [75851.330897] sd 1:0:0:0: [sdb] tag#9 CDB: Read(10) 28 00 0f 70 d8 08 00 00 01 00
Jun 28 18:48:05 system kernel: [75851.330900] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 18:48:05 system kernel: [75851.332856] ata2: EH complete
Jun 28 18:48:08 system kernel: [75854.061061] ata2.00: exception Emask 0x0 SAct 0x1000000 SErr 0x0 action 0x0
Jun 28 18:48:08 system kernel: [75854.064004] ata2.00: irq_stat 0x40000008
Jun 28 18:48:08 system kernel: [75854.066928] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:08 system kernel: [75854.069862] ata2.00: cmd 60/01:c0:08:d8:70/00:00:0f:00:00/40 tag 24 ncq 512 in
Jun 28 18:48:08 system kernel: [75854.069862]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:08 system kernel: [75854.075700] ata2.00: status: { DRDY ERR }
Jun 28 18:48:08 system kernel: [75854.078200] ata2.00: error: { UNC }
Jun 28 18:48:08 system kernel: [75854.093765] ata2.00: configured for UDMA/133
Jun 28 18:48:08 system kernel: [75854.093784] sd 1:0:0:0: [sdb] tag#24 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:08 system kernel: [75854.093790] sd 1:0:0:0: [sdb] tag#24 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:08 system kernel: [75854.093794] sd 1:0:0:0: [sdb] tag#24 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:08 system kernel: [75854.093798] sd 1:0:0:0: [sdb] tag#24 CDB: Read(10) 28 00 0f 70 d8 08 00 00 01 00
Jun 28 18:48:08 system kernel: [75854.093802] blk_update_request: I/O error, dev sdb, sector 259053576
Jun 28 18:48:08 system kernel: [75854.095918] ata2: EH complete
Jun 28 18:48:11 system kernel: [75856.823270] ata2.00: exception Emask 0x0 SAct 0x100 SErr 0x0 action 0x0
Jun 28 18:48:11 system kernel: [75856.828337] ata2.00: irq_stat 0x40000008
Jun 28 18:48:11 system kernel: [75856.833178] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:11 system kernel: [75856.837483] ata2.00: cmd 60/01:40:09:d8:70/00:00:0f:00:00/40 tag 8 ncq 512 in
Jun 28 18:48:11 system kernel: [75856.837483]          res 41/40:00:09:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:11 system kernel: [75856.845437] ata2.00: status: { DRDY ERR }
Jun 28 18:48:11 system kernel: [75856.849104] ata2.00: error: { UNC }
Jun 28 18:48:11 system kernel: [75856.865558] ata2.00: configured for UDMA/133
Jun 28 18:48:11 system kernel: [75856.865580] sd 1:0:0:0: [sdb] tag#8 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:11 system kernel: [75856.865587] sd 1:0:0:0: [sdb] tag#8 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:11 system kernel: [75856.865593] sd 1:0:0:0: [sdb] tag#8 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:11 system kernel: [75856.865599] sd 1:0:0:0: [sdb] tag#8 CDB: Read(10) 28 00 0f 70 d8 09 00 00 01 00
Jun 28 18:48:11 system kernel: [75856.865603] blk_update_request: I/O error, dev sdb, sector 259053577
Jun 28 18:48:11 system kernel: [75856.868467] ata2: EH complete
Jun 28 18:48:14 system kernel: [75859.596611] ata2.00: exception Emask 0x0 SAct 0x800000 SErr 0x0 action 0x0
Jun 28 18:48:14 system kernel: [75859.599558] ata2.00: irq_stat 0x40000008
Jun 28 18:48:14 system kernel: [75859.602487] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:14 system kernel: [75859.605430] ata2.00: cmd 60/01:b8:0a:d8:70/00:00:0f:00:00/40 tag 23 ncq 512 in
Jun 28 18:48:14 system kernel: [75859.605430]          res 41/40:00:0a:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:14 system kernel: [75859.611286] ata2.00: status: { DRDY ERR }
Jun 28 18:48:14 system kernel: [75859.613896] ata2.00: error: { UNC }
Jun 28 18:48:14 system kernel: [75859.629738] ata2.00: configured for UDMA/133
Jun 28 18:48:14 system kernel: [75859.629760] sd 1:0:0:0: [sdb] tag#23 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:14 system kernel: [75859.629765] sd 1:0:0:0: [sdb] tag#23 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:14 system kernel: [75859.629770] sd 1:0:0:0: [sdb] tag#23 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:14 system kernel: [75859.629775] sd 1:0:0:0: [sdb] tag#23 CDB: Read(10) 28 00 0f 70 d8 0a 00 00 01 00
Jun 28 18:48:14 system kernel: [75859.629779] blk_update_request: I/O error, dev sdb, sector 259053578
Jun 28 18:48:14 system kernel: [75859.632107] ata2: EH complete
Jun 28 18:48:16 system kernel: [75862.358828] ata2.00: exception Emask 0x0 SAct 0x80 SErr 0x0 action 0x0
Jun 28 18:48:16 system kernel: [75862.360301] ata2.00: irq_stat 0x40000008
Jun 28 18:48:16 system kernel: [75862.361754] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:16 system kernel: [75862.364673] ata2.00: cmd 60/01:38:0b:d8:70/00:00:0f:00:00/40 tag 7 ncq 512 in
Jun 28 18:48:16 system kernel: [75862.364673]          res 41/40:00:0b:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:16 system kernel: [75862.370474] ata2.00: status: { DRDY ERR }
Jun 28 18:48:16 system kernel: [75862.372162] ata2.00: error: { UNC }
Jun 28 18:48:16 system kernel: [75862.387053] ata2.00: configured for UDMA/133
Jun 28 18:48:16 system kernel: [75862.387063] sd 1:0:0:0: [sdb] tag#7 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:16 system kernel: [75862.387066] sd 1:0:0:0: [sdb] tag#7 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:16 system kernel: [75862.387068] sd 1:0:0:0: [sdb] tag#7 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:16 system kernel: [75862.387070] sd 1:0:0:0: [sdb] tag#7 CDB: Read(10) 28 00 0f 70 d8 0b 00 00 01 00
Jun 28 18:48:16 system kernel: [75862.387071] blk_update_request: I/O error, dev sdb, sector 259053579
Jun 28 18:48:16 system kernel: [75862.388038] ata2: EH complete
Jun 28 18:48:19 system kernel: [75865.109980] ata2.00: exception Emask 0x0 SAct 0x400000 SErr 0x0 action 0x0
Jun 28 18:48:19 system kernel: [75865.112951] ata2.00: irq_stat 0x40000008
Jun 28 18:48:19 system kernel: [75865.115836] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:19 system kernel: [75865.118735] ata2.00: cmd 60/01:b0:0c:d8:70/00:00:0f:00:00/40 tag 22 ncq 512 in
Jun 28 18:48:19 system kernel: [75865.118735]          res 41/40:00:0c:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:19 system kernel: [75865.124025] ata2.00: status: { DRDY ERR }
Jun 28 18:48:19 system kernel: [75865.126375] ata2.00: error: { UNC }
Jun 28 18:48:19 system kernel: [75865.141986] ata2.00: configured for UDMA/133
Jun 28 18:48:19 system kernel: [75865.142001] sd 1:0:0:0: [sdb] tag#22 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:19 system kernel: [75865.142005] sd 1:0:0:0: [sdb] tag#22 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:19 system kernel: [75865.142009] sd 1:0:0:0: [sdb] tag#22 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:19 system kernel: [75865.142013] sd 1:0:0:0: [sdb] tag#22 CDB: Read(10) 28 00 0f 70 d8 0c 00 00 01 00
Jun 28 18:48:19 system kernel: [75865.142016] blk_update_request: I/O error, dev sdb, sector 259053580
Jun 28 18:48:19 system kernel: [75865.143675] ata2: EH complete
Jun 28 18:48:22 system kernel: [75867.872211] ata2.00: exception Emask 0x0 SAct 0x40 SErr 0x0 action 0x0
Jun 28 18:48:22 system kernel: [75867.875153] ata2.00: irq_stat 0x40000008
Jun 28 18:48:22 system kernel: [75867.878041] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:22 system kernel: [75867.881003] ata2.00: cmd 60/01:30:0d:d8:70/00:00:0f:00:00/40 tag 6 ncq 512 in
Jun 28 18:48:22 system kernel: [75867.881003]          res 41/40:00:0d:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:22 system kernel: [75867.886814] ata2.00: status: { DRDY ERR }
Jun 28 18:48:22 system kernel: [75867.889458] ata2.00: error: { UNC }
Jun 28 18:48:22 system kernel: [75867.905133] ata2.00: configured for UDMA/133
Jun 28 18:48:22 system kernel: [75867.905151] sd 1:0:0:0: [sdb] tag#6 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:22 system kernel: [75867.905157] sd 1:0:0:0: [sdb] tag#6 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:22 system kernel: [75867.905161] sd 1:0:0:0: [sdb] tag#6 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:22 system kernel: [75867.905166] sd 1:0:0:0: [sdb] tag#6 CDB: Read(10) 28 00 0f 70 d8 0d 00 00 01 00
Jun 28 18:48:22 system kernel: [75867.905169] blk_update_request: I/O error, dev sdb, sector 259053581
Jun 28 18:48:22 system kernel: [75867.907275] ata2: EH complete
Jun 28 18:48:25 system kernel: [75870.634424] ata2.00: exception Emask 0x0 SAct 0x200000 SErr 0x0 action 0x0
Jun 28 18:48:25 system kernel: [75870.635895] ata2.00: irq_stat 0x40000008
Jun 28 18:48:25 system kernel: [75870.637347] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:25 system kernel: [75870.640275] ata2.00: cmd 60/01:a8:0e:d8:70/00:00:0f:00:00/40 tag 21 ncq 512 in
Jun 28 18:48:25 system kernel: [75870.640275]          res 41/40:00:0e:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:25 system kernel: [75870.646083] ata2.00: status: { DRDY ERR }
Jun 28 18:48:25 system kernel: [75870.647747] ata2.00: error: { UNC }
Jun 28 18:48:25 system kernel: [75870.662682] ata2.00: configured for UDMA/133
Jun 28 18:48:25 system kernel: [75870.662696] sd 1:0:0:0: [sdb] tag#21 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:25 system kernel: [75870.662700] sd 1:0:0:0: [sdb] tag#21 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:25 system kernel: [75870.662704] sd 1:0:0:0: [sdb] tag#21 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:25 system kernel: [75870.662707] sd 1:0:0:0: [sdb] tag#21 CDB: Read(10) 28 00 0f 70 d8 0e 00 00 01 00
Jun 28 18:48:25 system kernel: [75870.662709] blk_update_request: I/O error, dev sdb, sector 259053582
Jun 28 18:48:25 system kernel: [75870.664257] ata2: EH complete
Jun 28 18:48:27 system kernel: [75873.407746] ata2.00: exception Emask 0x0 SAct 0x20 SErr 0x0 action 0x0
Jun 28 18:48:27 system kernel: [75873.409213] ata2.00: irq_stat 0x40000008
Jun 28 18:48:27 system kernel: [75873.410663] ata2.00: failed command: READ FPDMA QUEUED
Jun 28 18:48:27 system kernel: [75873.413638] ata2.00: cmd 60/01:28:0f:d8:70/00:00:0f:00:00/40 tag 5 ncq 512 in
Jun 28 18:48:27 system kernel: [75873.413638]          res 41/40:00:0f:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
Jun 28 18:48:27 system kernel: [75873.419444] ata2.00: status: { DRDY ERR }
Jun 28 18:48:27 system kernel: [75873.421118] ata2.00: error: { UNC }
Jun 28 18:48:27 system kernel: [75873.436057] ata2.00: configured for UDMA/133
Jun 28 18:48:27 system kernel: [75873.436071] sd 1:0:0:0: [sdb] tag#5 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 28 18:48:27 system kernel: [75873.436075] sd 1:0:0:0: [sdb] tag#5 Sense Key : Medium Error [current] [descriptor] 
Jun 28 18:48:27 system kernel: [75873.436079] sd 1:0:0:0: [sdb] tag#5 Add. Sense: Unrecovered read error - auto reallocate failed
Jun 28 18:48:27 system kernel: [75873.436082] sd 1:0:0:0: [sdb] tag#5 CDB: Read(10) 28 00 0f 70 d8 0f 00 00 01 00
Jun 28 18:48:27 system kernel: [75873.436085] blk_update_request: I/O error, dev sdb, sector 259053583
Jun 28 18:48:27 system kernel: [75873.437641] ata2: EH complete
