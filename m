Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35223 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750857AbcH1THC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 15:07:02 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1be5Q1-00086l-SH
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 21:06:57 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfstune settings
Date: Sun, 28 Aug 2016 21:06:49 +0200
Message-ID: <20160828210649.783d22ca@jupiter.sol.kaishome.de>
References: <20160828193559.09534344@jupiter.sol.kaishome.de>
        <18fb1730-2820-81b1-781e-02ee9435d308@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 28 Aug 2016 20:10:38 +0200
schrieb Oliver Freyermuth <o.freyermuth@googlemail.com>:

> > Try borgbackup, I'm using it very successfully. It is very fast,
> > supports very impressive deduplication and compression, retention
> > policies, and remote backups - and it is available as a single
> > binary version so you can more easily use it for disaster recovery.
> > One downside: while it seems to restore nocow attributes, it seems
> > to do it in a silly way (it first creates the file, then sets the
> > attributes, which of course won't work for nocow). I have not
> > checked that extensively, only had to restore once yet.  
> 
> Wow - this looks like the holy grail I've been waiting for, not sure
> how I have missed that up to now. 
> Especially the deduplication across several backupped systems on the
> backup target is interesting, I originally planned to do that using
> duperemove on the backup target to dedupe across the readonly
> snapshots. I'll certainly give borgbackup a spin as soon as I have
> time to look into it! 

Apparently, only one client can access the repo at the same time. So
you have to fiddle around with backup time windows and maybe the option
for lock timeouts and retries via your service manager. I'm using it to
backup a multi server shop system, it will first create an SQL dump,
then start backing up each host one after the next to a local
repository. In the end, I'll rsync it to an offsite location. It
requires some scripting and ssh foo but it works reliable.

At home, I'm using a simple systemd job to wake my system up at night
and put it back to sleep later:

$ systemctl cat internal-backup.{timer,service}
# /etc/systemd/system/internal-backup.timer
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=03:00
WakeSystem=true

[Install]
WantedBy=timers.target

# /etc/systemd/system/internal-backup.service
[Unit]
Description=Daily Backup Service

[Service]
Environment=BORG_REPO=/mnt/private/backup/jupiter.sol.local.borg
Environment=BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes
Environment=BORG_RELOCATED_REPO_ACCESS_IS_OK=yes
Type=oneshot
IOSchedulingClass=idle
IOSchedulingPriority=7
CPUSchedulingPolicy=batch
Nice=3
ProtectHome=read-only
ProtectSystem=full
PrivateTmp=yes
ReadWriteDirectories=/root/.cache/borg
ReadOnlyDirectories=/mnt/btrfs-pool
WorkingDirectory=/mnt/btrfs-pool
ExecStart=/usr/bin/systemd-inhibit /usr/bin/borg create -v --stats
--exclude-caches --compression zlib --exclude
'pp:gentoo/usr/portage/distfiles' --exclude 'pp:gentoo/rootfs/var/tmp'
--exclude
'pp:gentoo/usr/portage/packages' ::'system@{now:%%Y%%m%%d-%%H%%M}' .
ExecStartPost=/usr/bin/borg prune -v --prefix 'system@' --keep-daily 7
--keep-weekly 5 --keep-monthly 12 --list --stats --save-space


The result then looks like this:

$ sudo -H borg
info /mnt/private/backup/jupiter.sol.local.borg::system@20160828-0255
Name: system@20160828-0255 Fingerprint:
786c9c8a18d5d04ba2a745d91777cf30345613b78d2afaa74192db871aa220de
Hostname: jupiter.sol.local Username: root
Time (start): Sun, 2016-08-28 02:55:24
Time (end):   Sun, 2016-08-28 03:08:13
Command line: /usr/lib/python-exec/python3.4/borg create -v --stats
--exclude-caches --compression zlib --exclude
pp:gentoo/usr/portage/distfiles --exclude pp:gentoo/rootfs/var/tmp
--exclude pp:gentoo/usr/portage/packages ::system@{now:%Y%m%d-%H%M} .
Number of files: 2356372

                Original size  Compressed size  Deduplicated size
This archive:         1.73 TB          1.49 TB            1.02 GB
All archives:        17.26 TB         14.94 TB            1.78 TB

                Unique chunks     Total chunks
Chunk index:          2858371         28473400


Initial backup creation is much slower than rsync but successive runs
are much faster (around 15-20 minutes instead of 1 hour).

-- 
Regards,
Kai

Replies to list-only preferred.

