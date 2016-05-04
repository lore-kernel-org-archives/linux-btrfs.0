Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:59135 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbcEDXV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 19:21:59 -0400
Received: from localhost (unknown [192.168.1.189])
	by mail2.linuxsystems.it (Postfix) with ESMTPSA id 65745A3F18
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 01:21:53 +0200 (CEST)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: btrfs ate my data in just two days, after a fresh install. ram and =?iso-8859-1?Q?disk_are_ok._it_still_mounts,_but_I_cannot_repair?=
Date: Thu, 05 May 2016 01:21:49 +0200
MIME-Version: 1.0
Message-ID: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I really need your help, because it's the second time btrfs ate my data in 
a couple of days and I can't use my laptop if I don't find the culprit.

This was the mail I sent a couple of days ago: 
https://www.spinics.net/lists/linux-btrfs/msg54754.html
I previously thought the culprit was a bug in kernel 4.6-rc, but I was 
wrong.

Then I reinstalled the whole system (Arch Linux) from scratch, and after 
just two days I lost some of my data, again. Once again btrfs check 
--repair got stuck in an infinite loop and I can't repair my fs. The system 
has always been shutdown properly, except for a single time when I had to 
forcedly power it off just after the boot because I didn't see any signal 
on the screen.

First the obvious things:

- memory is ok 
(https://drive.google.com/open?id=0Bwe9Wtc-5xF1VnJ0SE9fT1FZMTg)
- disk is ok 
(https://drive.google.com/open?id=0Bwe9Wtc-5xF1NGRhd2daVDRJVGc)
- tlp has SATA_LINKPWR_ON_BAT=max_performance 
(https://drive.google.com/open?id=0Bwe9Wtc-5xF1dFAwUE5ETVpNWGM)
- rootfs mount options: 
rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,subvolid=257,subvol=/@
- Command line: BOOT_IMAGE=/@/boot/vmlinuz-linux 
root=UUID=4fc2278e-f6e8-4a21-8876-cabbf885bb2e rw rootflags=subvol=@ 
cryptdevice=/dev/disk/by-uuid/c7c8f501-507c-4bd2-a80a-8c7360651f02:cryptroot:allow-discards 
quiet
- scrub didn't find any error:
$ sudo btrfs scrub status /
scrub status for 4fc2278e-f6e8-4a21-8876-cabbf885bb2e
        scrub started at Thu May  5 00:57:30 2016 and finished after 
00:00:45
        total bytes scrubbed: 22.26GiB with 0 errors

I have the whole rootfs encrypted, including boot. I followed these steps: 
https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Btrfs_subvolumes_with_swap

Disk is a SAMSUNG SSD PM851 M.2 2280 256GB (Firmware Version: EXT25D0Q).
Laptop is a Dell XPS 13 9343 QHD+.
Distro is Arch Linux, kernel version is 4.5.1. btrfs-progs is 4.5.2.

After two days from the previous data loss I finished reinstalling my 
distro from scratch, then I decided to do a full backup from a snapshot 
using tar. This is what I got while trying to backup my data:

tar: usr/share/kig/icons/hicolor/32x32/actions/test.png: errore di lettura 
al byte 0 leggendo 810 byte: Errore di input/output
tar: usr/share/kig/icons/hicolor/32x32/actions/circlebpd.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/pointOnLine.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/bezierN.png: funzione "stat" 
non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/convexhull.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/centerofcurvature.png: 
funzione "stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/en.png: funzione "stat" non 
riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/circlebps.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/directrix.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/beziercurves.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/segment_midpoint.png: 
funzione "stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/distance.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/circlebcl.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/conicb5p.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/kig_polygon.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/conicasymptotes.png: 
funzione "stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/pointxy.png: funzione "stat" 
non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/attacher.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/coniclineintersection.png: 
funzione "stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/vectorsum.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/rbezier4.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/ellipsebffp.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/angle.png: funzione "stat" 
non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/kig_text.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/vectordifference.png: 
funzione "stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/segmentaxis.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/radicalline.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/polygonsides.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/projection.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/inversion.png: funzione 
"stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/bezier4.png: funzione "stat" 
non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/equilateralhyperbolab4p.png: 
funzione "stat" non riuscita: Stale file handle
tar: usr/share/kig/icons/hicolor/32x32/actions/areaCircle.png: funzione 
"stat" non riuscita: Stale file handle
tar: var/lib/samba/private/msg.sock/666: socket ignorato
tar: Uscita con stato di fallimento in base agli errori precedenti


[ 3057.008185] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.008195] BTRFS error (device dm-0): error loading props for ino 
183988 (root 505): -5
[ 3057.008417] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.008631] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.009165] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.009389] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.009734] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.009960] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.010664] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.010888] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3057.011201] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3331.795474] verify_parent_transid: 57 callbacks suppressed
[ 3331.795480] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283
[ 3331.795776] BTRFS error (device dm-0): parent transid verify failed on 
528089088 wanted 3458764513820541211 found 283

I made a copy of /dev/mapper/cryptroot with dd on an external drive and I 
run btrfs check on it (btrfs-progs 4.5.2): 
https://drive.google.com/open?id=0Bwe9Wtc-5xF1SjJacXpMMU5mems (37MB)

Then I tried to run btrfs check --repair on it but once again it got stuck 
in an infinite loop like this one 
(https://www.spinics.net/lists/linux-btrfs/msg54146.html) and after an hour 
of looping and several hundreds of MBs of logs I had to kill it. Here is 
the log, truncated to 30MB: 
https://drive.google.com/open?id=0Bwe9Wtc-5xF1SmRuVUlfeGRES3M

They are probably not needed but here is snapper -c @ list: 
https://drive.google.com/open?id=0Bwe9Wtc-5xF1N0llOFpfVXVwNVk
and btrfs subvolume list -p /: 
https://drive.google.com/open?id=0Bwe9Wtc-5xF1andCdWZzeV9VbDg

This is the link to the whole gdrive directory with all the logs: 
https://drive.google.com/open?id=0Bwe9Wtc-5xF1UFltcXhtRmt4YjA

I really don't know what may be the problem, maybe discard? I can't think 
about switching back to ext4 and losing snapshots, transactions, 
compression, incremental send/receive backups etc.
I would really love being able to do something to fix it, but I don't have 
the slightest idea about what's the problem. Hopefully someone here will be 
smarter than me and find the problem, otherwise I will have to switch to 
ext4 because I need my laptop to work.

Thanks,
Niccolò
