Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.225]:65202 "EHLO
	dnvrco-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750869AbcAUWZY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 17:25:24 -0500
Date: Thu, 21 Jan 2016 14:25:48 -0800 (PST)
From: Rian Hunter <rian@thelig.ht>
To: Chris Murphy <lists@colorremedies.com>
cc: Rich Freeman <r-btrfs@gw.thefreemanclan.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: FS corruption when mounting non-degraded after mounting
 degraded
In-Reply-To: <CAJCQCtTSHepYgTxiJ49wPsrO0Hh-NFEcxbo6DzG7XyFyi9ySSg@mail.gmail.com>
Message-ID: <alpine.OSX.2.20.1601211317410.38375@ioko>
References: <alpine.OSX.2.20.1601190308520.34954@ioko> <CAGfcS_=0Fu96a=SZwYkkV7Ukk7Jc_8c6sn8ZeiacocTcRbMp8w@mail.gmail.com> <CAJCQCtTSHepYgTxiJ49wPsrO0Hh-NFEcxbo6DzG7XyFyi9ySSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 21 Jan 2016, Chris Murphy wrote:
> But none of this explains why corruption happened. So I'd say it's a
> bug. The question is, is it discretely reproducible? Once there's
> concise reproduce steps, it's much more likely a dev can reproduce and
> debug what the problem is.
>
> Maybe there's a problem where the reintroduction of a previously
> missing device in the middle of being replaced. The devid is different
> from dev.uuid, but they are mapped somehow, and mainly it's the devid
> being used by the filesystem chunk tree. So maybe confusion happens
> where there are suddenly two devid 2, even though they have different
> dev UUID.

Let me put the sequence of events into more discrete steps so that any
interested dev may reproduce the bug. For the record I maintain daily
backups and specifically made a backup before the events described so
I was not adversely affected by this bug except through lost time.

Kernel uname -a: Linux nori 4.3.0-1-amd64 #1 SMP Debian 4.3.3-5 (2016-01-04) x86_64 GNU/Linux

Start state: Normally functioning raid6 array. Device FOO intermittently
fails and requires power cycle to work again. This has happened 25-50
times in the past with no irresolvable data corruption. Decision has
finally been made to replace it.

* Unmount raid6 FS
* Disconnect array.
* Physically remove device FOO from array, add new device BAR to array.
* Connect array
* Mount raid6 array with "-o degraded"
* Run "btrfs replace start 2 /dev/BAR /mnt"
* Start VMs on FS
* Machine freezes (not sure why)
* Restart machine
* Mount raid6 array with "-o degraded"
* Replace job continues automatically
* Start VMs on FS
* After an hour: VMs have no started up yet (seeing hung-task
   warnings in kernel). "btrfs replace status /mnt" shows 0.1% done
* Cancel replace: "btrfs replace cancel /mnt"
* Unmount raid6 FS
* Disconnect array
* Physically add device FOO back to array
* Reconnect array
* Mount raid6 array normally (no "-o degraded")
* Run "btrfs replace start 2 /dev/BAR /mnt"
* Start VMs on FS
* VMs starting is still too slow, kill all VMs except for a critical
   one, VMFOO. Let VMFOO attempt to start.
* After an hour: lots of "parent transid verify failed" in dmesg, I get
   nervous. I attribute it to re-adding the disk. Also seeing
   "hung-task" corresponding to the starting of VMFOO.
* Forcibly Stop VMFOO.
* Cancel replace: "btrfs replace cancel /mnt"
* Unmount raid6 FS
* Disconnect array
* Physically remove device FOO from array
* Reconnect array
* Mount raid6 array with "-o degraded"
* Run "btrfs replace start 2 /dev/BAR /mnt"
* After an hour: Replace operation was automatically cancelled, lots
   of "parent transid verify failed" in dmesg again.
* Run "btrfs scrub," "btrfs scrub status" shows millions of
   unrecoverable errors
* Cancel "btrfs scrub"
* At this point I'm convinced this FS is in a very broken state and I
   try to salvage whatever data could have changed since beginning the
   process.
* Tried rsync'ing VMFOO off disk, lots of "parent transid verify
   failed" in dmesg, rsync reporting "stale file handle" and it seems
   stalled, iostat reporting no disk IO, all CPUS burning in system
   time (not user mode), system memory usage steadily rising.
* Unmount raid6 array
* Mount raid6 array with "-o degraded", fails:
   drive would not appear mounted for some reason. (no message in
   dmesg but there was nothing under mount point, and no failure from
   the "mount" command)
* Restart machine
* Mount raid6 array with "-o degraded", success
* Tried rsync'ing VMFOO off disk again, lots of "parent transid verify
   failed" in dmesg, rsync reporting "stale file h andle," seems
   stalled, iostat reporting no disk IO, all CPUS burning, system
   memory usage steadily rising.
* Tried rsync'ing other VMs, saw additional "parent transid verify"
   message in the kernel but the rsync completed successfully (though
   there was some corruption).
* Tried rsync'ing some other non-VM data, everything proceeded
   normally, invoked no "parent transid verify failed" errors.

After this I completely reformatted the FS and restored it from backup
so unfortunately I don't have any way to investigate the remnants of
what happened.

When I personally was trying to figure out what happened, some
observations stood out:

* The fact that VMFOO's data was in a very bad state 
* Yet the other VMs were in a bad, but less bad, state
* Also the non-VM data was uncorrupted.
* The errors first occured during replacing after mounting the FS
   normally after previously mounting it with "-o degraded"

>From a black box perspective, this led me to believe that the
corruption happened during the replace operation after mounting
normally after first mounting with "-o degraded." Of course,
knowledge of the internals could easily verify this.

HTH! I'm not on this mailing list so please reply directly to me.
