Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62351 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbcCTJS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 05:18:29 -0400
MIME-Version: 1.0
Message-ID: <trinity-864ec27a-d0e1-4c15-a29b-6eb23d63f8f5-1458465506167@3capp-gmx-bs14>
From: "Patrick Tschackert" <Killing-Time@gmx.de>
To: lists@colorremedies.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unable to mount btrfs partition, please help :(
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Mar 2016 10:18:26 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for answering again!
So, first of all I installed a newer kernel from the backports as per Nicholas D Steeves suggestion:

$ apt-get install -t jessie-backports linux-image-4.3.0-0.bpo.1-amd64

After rebooting:
$ uname -a
Linux vmhost 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.5-1~bpo8+1 (2016-02-23) x86_64 GNU/Linux

But the problem with mounting the filesystem persists :(

> OK I went back and read this again: host is managing the md raid5, the
> guest is writing Btrfs to an "encrypted container" but what is that? A
> LUKS encrypted LVM LV that's directly used by Virtual Box as a raw
> device? It's hard to say what layer broke this. But the VM crashing is
> in effect like a power failure, and it's an open question (for me) how
> this setup deals with barriers. A shutdown -r now should still cleanly
> stop the array so I wouldn't expect there to be an array problem but
> then you also report a device failure. Bad luck.
 
The host is managing an md raid 6 (/dev/md0), and I had an encrypted volume (via cryptsetup) on top of that device.
The host mounted the btrfs filesystem contained in that volume, and the VM wrote to the filesystem as well using a virtualbox shared folder.
The vm then crashed, but I shut down the host with "shutdown -r now".
After the reboot, one disk of the array was no longer present, but I managed to rebuild/restore using a spare disk. The RAID now seems to be healthy.

> I think in retrospect the safe way to do these kinds of Virtual Box
> updates, which require kernel module updates, would have been to
> shutdown the VM and stop the array. *shrug*
 
After this, I think I'll just do away with the virtual machine on this host, as the app contained in that vm can also run on the host.
I tried to be fancy, and it seems to needlessly complicate things.
 
> These drives are technically not suitable for use in any kind of raid
> except linear and raid 0 (which have no redundancy so they aren't
> really raid). You'd have to dig up drive specs, assuming they're
> published, to see what the recovery times are for the drive models
> when a bad sector is encountered. But it's typical for such drives to
> exceed 30 seconds for recovery, with some drives reported to have 2+
> minute recoveries. To properly configure them, you'll have to increase
> the kernel's SCSI comment timer to at least 120 to make sure there's
> sufficient time to wait for the drive to explicitly spit back a read
> error to the kernel. Otherwise, the kernel gives up after 30 seconds,
> and resets the link to the drive, and any possibility of fixing up the
> bad sector via the raid read error fixup mechanism is thwarted. It's
> really common, the linux-raid@ list has many of these kinds of threads
> with this misconfiguration as the source problem.
 
> For the first listing of drives yes. And 120 second delays might be
> too long for your use case, but that's the reality.

> You should change the command timer for the drives that do not support
> configurable SCT ERC. And then do a scrub check. And then check both
> cat /sys/block/mdX/md/mismatch_cnt, which ideally should be 0, and
> also check kernel messages for libata read errors.

So I did this:
 
$ cat /sys/block/md0/md/mismatch_cnt
0

$ for i in /sys/class/scsi_generic/*/device/timeout; do echo 120 > "$i"; done
(I know this isn't persistent across reboots...)

$ echo check > /sys/block/md0/md/sync_action

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid6 sda[0] sdf[12](S) sdg[11](S) sdj[9] sdh[7] sdi[6] sdk[10] sde[4] sdd[3] sdc[2] sdb[1]
      20510948416 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
      [>....................]  check =  1.0% (30812476/2930135488) finish=340.6min speed=141864K/sec
      
unused devices: <none>

So the raid is currently doing a scrub, which will take a few hours.

> Hmm not good. See this similar thread.
> http://www.spinics.net/lists/linux-btrfs/msg51711.html

> backups in all superblocks have the same chunk_root, no alternative
> chunk root to try.

> So at the moment I think it's worth trying a newer kernel version and
> mounting normally; then mounting with -o recovery; then - recovery,ro.

> If that doesn't work, you're best off waiting for a developer to give
> advice on the next step;  'btrfs rescue chunk-recover' seems most
> appropriate but again someone else a while back had success with
> zero-log, but it's hard to say if the two cases are really similar and
> maybe that person just got lucky. Both of those change the file system
> in irreversible ways, that's why I suggest waiting or asking on IRC.

Thanks again for taking the time to answer. I'll wait while my RAID is doing the scrub, maybe a dev will answer (like you said).
The friendly people on IRC couldn't help and sent me here.
