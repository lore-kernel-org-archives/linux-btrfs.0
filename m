Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60581 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab3JCAtR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Oct 2013 20:49:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VRX6Q-0005h6-FL
	for linux-btrfs@vger.kernel.org; Thu, 03 Oct 2013 02:49:14 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 02:49:14 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 02:49:14 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Thu, 03 Oct 2013 01:49:03 +0100
Message-ID: <l2ietn$jv1$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <l2a635$37m$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So... The fix:


(

Summary:

Mounting "-o recovery,noatime" worked well and allowed a diff check to
complete for all but one directory tree. So very nearly all the data is
fine.

Deleting the failed directory tree caused a call stack dump and eventually:

kernel: parent transid verify failed on 915444822016 wanted 16974 found
13021
kernel: BTRFS info (device sdc): failed to delete reference to
eggdrop-1.6.19.ebuild, inode 2096893 parent 5881667
kernel: BTRFS error (device sdc) in __btrfs_unlink_inode:3662: errno=-5
IO failure
kernel: BTRFS info (device sdc): forced readonly


Greater detail listed below.

What next best to try?

Safer to try again but this time with with "no_space_cache,no_inode_cache"?

Thanks,
Martin

)



On 29/09/13 22:29, Martin wrote:
> On 29/09/13 06:11, Duncan wrote:

>>> What does btrfs do (or can do) for recovery?
>>
>> Here's a general-case answer (courtesy gmane) to the order in which to 
>> try recovery question, that Hugo posted a few weeks ago:
>>
>> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999
> 
> Thanks for that. Very well found!
> 
> The instructions from Hugo are:
> 
> ####
>    Let's assume that you don't have a physical device failure (which
> is a different set of tools -- mount -odegraded, btrfs dev del
> missing).
> 
>    First thing to do is to take a btrfs-image -c9 -t4 of the
> filesystem, and keep a copy of the output to show josef. :)
> 
>    Then start with -orecovery and -oro,recovery for pretty much
> anything.

For anyone following this, first a health warning:

If your data is in any way critical or important, then you should
already have a backup copy elsewhere. If not, best make a binary image
copy of your disk first!


OK... So with the latest kernel (3.11.2) and btrfs tools
(Btrfs v0.20-rc1-358-g194aa4a) and the sequence went:


mount -v -t btrfs -o recovery LABEL=bu_A /mnt/bu_A

(From syslog:)

kernel: device label bu_A devid 1 transid 17222 /dev/sdc
kernel: btrfs: enabling auto recovery
kernel: btrfs: disk space caching is enabled
kernel: btrfs: bdev /dev/sdc errs: wr 0, rd 27, flush 0, corrupt 0, gen 0

Running through a diff check for part of the backups, syslog reported:

kernel: btrfs read error corrected: ino 1 off 915433144320 (dev /dev/sdc
sector 1813661856)

Also, the HDD was showing quite a few write operations so... Is
"noatime" set?... Ooops... Didn't include a "ro"... So, killed the diff
check and remounted:

mount -v -t btrfs -o remount,recovery,noatime /mnt/bu_A
mount: /dev/sdc mounted on /mnt/bu_A

kernel: btrfs: enabling inode map caching
kernel: btrfs: enabling auto recovery
kernel: btrfs: disk space caching is enabled

And running the diff check again... Now zero writes to the HDD :-)


Various syslog messages were given:

kernel: parent transid verify failed on 907185135616 wanted 15935 found
12264
kernel: btrfs read error corrected: ino 1 off 907185135616 (dev /dev/sdc
sector 1781823824)
kernel: parent transid verify failed on 907185143808 wanted 15935 found
12264
kernel: btrfs read error corrected: ino 1 off 907185143808 (dev /dev/sdc
sector 1781823840)
kernel: parent transid verify failed on 907185139712 wanted 15935 found
12264
kernel: btrfs read error corrected: ino 1 off 907185139712 (dev /dev/sdc
sector 1781823832)
kernel: parent transid verify failed on 907185152000 wanted 15935 found
10903
kernel: btrfs read error corrected: ino 1 off 907185152000 (dev /dev/sdc
sector 1781823856)
kernel: parent transid verify failed on 907183783936 wanted 15935 found
12263
kernel: btrfs read error corrected: ino 1 off 907183783936 (dev /dev/sdc
sector 1781821184)
kernel: parent transid verify failed on 907183792128 wanted 15935 found
10903
kernel: btrfs read error corrected: ino 1 off 907183792128 (dev /dev/sdc
sector 1781821200)
kernel: parent transid verify failed on 907183796224 wanted 15935 found
12263
kernel: btrfs read error corrected: ino 1 off 907183796224 (dev /dev/sdc
sector 1781821208)
kernel: parent transid verify failed on 907183841280 wanted 15935 found
10903
kernel: btrfs read error corrected: ino 1 off 907183841280 (dev /dev/sdc
sector 1781821296)
kernel: parent transid verify failed on 907183878144 wanted 15935 found
12263
kernel: btrfs read error corrected: ino 1 off 907183878144 (dev /dev/sdc
sector 1781821368)
kernel: parent transid verify failed on 907183874048 wanted 15935 found
12263
kernel: btrfs read error corrected: ino 1 off 907183874048 (dev /dev/sdc
sector 1781821360)
kernel: verify_parent_transid: 25 callbacks suppressed
kernel: parent transid verify failed on 915431288832 wanted 16974 found
16972
kernel: repair_io_failure: 25 callbacks suppressed
kernel: btrfs read error corrected: ino 1 off 915431288832 (dev /dev/sdc
sector 1813658232)
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
[...]

One directory tree failed the diff checks so I 'mv'-ed that one tree to
rename it out of the way and then ran an "rm -Rf" to remove it.

That appeared to run fine until:

kernel: parent transid verify failed on 915431862272 wanted 16974 found
16972
kernel: btrfs read error corrected: ino 1 off 915431862272 (dev /dev/sdc
sector 1813659352)
kernel: parent transid verify failed on 907185127424 wanted 15935 found
12264
kernel: btrfs read error corrected: ino 1 off 907185127424 (dev /dev/sdc
sector 1781823808)
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: BTRFS info (device sdc): failed to delete reference to
metadata.xml, inode 1846452 parent 5851502
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 0 PID: 3236 at fs/btrfs/super.c:253
__btrfs_abort_transaction+0x4a/0xfc()
kernel: btrfs: Transaction aborted (error -5)
kernel: Modules linked in: nfsd auth_rpcgss oid_registry exportfs
nfs_acl lockd sunrpc bridge stp llc snd_hda_codec_realtek
snd_hda_codec_hdmi ppdev evdev serio_raw pcspkr acpi_cpufreq
snd_hda_intel snd_hda_codec mperf snd_pcm freq_table snd_page_alloc
snd_timer parport_pc processor wmi bnx2 snd parport thermal_sys
i2c_piix4 button usbhid firewire_ohci firewire_core xhci_hcd ata_generic
pata_acpi
kernel: CPU: 0 PID: 3236 Comm: nfsd Not tainted 3.11.2-gentoo_muse11_07 #1
kernel: Hardware name: System manufacturer System Product Name/E45M1-M
PRO, BIOS 0502 09/21/2011
kernel: 0000000000000000 ffffffff81700892 ffffffff815261d1 ffff8801f91f1c18
kernel: ffffffff8102ea45 ffff88010b18e5a0 ffffffff811df675 ffff8801f91f1c38
kernel: 00000000fffffffb ffff880233afb000 ffff880230a3b960 0000000000000e4e
kernel: Call Trace:
kernel: [<ffffffff815261d1>] ? dump_stack+0x41/0x51
kernel: [<ffffffff8102ea45>] ? warn_slowpath_common+0x79/0x92
kernel: [<ffffffff811df675>] ? __btrfs_abort_transaction+0x4a/0xfc
kernel: [<ffffffff8102eaf6>] ? warn_slowpath_fmt+0x45/0x4a
kernel: [<ffffffff811df675>] ? __btrfs_abort_transaction+0x4a/0xfc
kernel: [<ffffffff812071e3>] ? __btrfs_unlink_inode+0x19a/0x2c0
kernel: [<ffffffff812093bf>] ? btrfs_unlink_inode+0x12/0x35
kernel: [<ffffffff8120943e>] ? btrfs_unlink+0x5c/0x94
kernel: [<ffffffff810f8e03>] ? vfs_unlink+0x69/0xc8
kernel: [<ffffffffa029f215>] ? nfsd_unlink+0x18e/0x1d1 [nfsd]
kernel: [<ffffffffa02a4e87>] ? nfsd3_proc_remove+0x67/0xab [nfsd]
kernel: [<ffffffffa029a9d2>] ? nfsd_dispatch+0x91/0x148 [nfsd]
kernel: [<ffffffffa0234fc7>] ? svc_process+0x3e1/0x630 [sunrpc]
kernel: [<ffffffffa0235211>] ? svc_process+0x62b/0x630 [sunrpc]
kernel: [<ffffffffa029a574>] ? nfsd+0xc0/0x117 [nfsd]
kernel: [<ffffffffa029a4b4>] ? nfsd_destroy+0x64/0x64 [nfsd]
kernel: [<ffffffff81047287>] ? kthread+0xad/0xb5
kernel: [<ffffffff810471da>] ? kthread_freezable_should_stop+0x41/0x41
kernel: [<ffffffff8152c5ec>] ? ret_from_fork+0x7c/0xb0
kernel: [<ffffffff810471da>] ? kthread_freezable_should_stop+0x41/0x41
kernel: ---[ end trace 53d6fb93a497e75d ]---
kernel: BTRFS warning (device sdc): __btrfs_unlink_inode:3662: Aborting
unused transaction(IO failure).
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: parent transid verify failed on 915444523008 wanted 16974 found
13021
kernel: btrfs read error corrected: ino 1 off 915433652224 (dev /dev/sdc
sector 1813662848)
kernel: btrfs read error corrected: ino 1 off 915433029632 (dev /dev/sdc
sector 1813661632)
kernel: btrfs read error corrected: ino 1 off 915433041920 (dev /dev/sdc
sector 1813661656)
kernel: btrfs read error corrected: ino 1 off 915433955328 (dev /dev/sdc
sector 1813663440)
kernel: btrfs read error corrected: ino 1 off 915433127936 (dev /dev/sdc
sector 1813661824)
kernel: btrfs read error corrected: ino 1 off 915434070016 (dev /dev/sdc
sector 1813663664)
kernel: btrfs read error corrected: ino 1 off 915433132032 (dev /dev/sdc
sector 1813661832)
kernel: btrfs read error corrected: ino 1 off 915433136128 (dev /dev/sdc
sector 1813661840)
kernel: btrfs read error corrected: ino 1 off 915433545728 (dev /dev/sdc
sector 1813662640)
kernel: BTRFS info (device sdc): failed to delete reference to
metadata.xml, inode 1846733 parent 5851559
kernel: BTRFS warning (device sdc): __btrfs_unlink_inode:3662: Aborting
unused transaction(IO failure).
kernel: verify_parent_transid: 96 callbacks suppressed
kernel: parent transid verify failed on 915431579648 wanted 16974 found
16972
kernel: repair_io_failure: 13 callbacks suppressed
kernel: btrfs read error corrected: ino 1 off 915431579648 (dev /dev/sdc
sector 1813658800)
kernel: parent transid verify failed on 915432382464 wanted 16974 found
16972
kernel: btrfs read error corrected: ino 1 off 915432382464 (dev /dev/sdc
sector 1813660368)
kernel: parent transid verify failed on 915444707328 wanted 16974 found
13021
kernel: btrfs read error corrected: ino 1 off 915444707328 (dev /dev/sdc
sector 1813684440)
kernel: parent transid verify failed on 915445092352 wanted 16974 found
13021
kernel: btrfs read error corrected: ino 1 off 915445092352 (dev /dev/sdc
sector 1813685192)
kernel: parent transid verify failed on 915445100544 wanted 16974 found
13021
kernel: btrfs read error corrected: ino 1 off 915445100544 (dev /dev/sdc
sector 1813685208)
kernel: parent transid verify failed on 915431026688 wanted 16974 found
16972
kernel: btrfs read error corrected: ino 1 off 915431026688 (dev /dev/sdc
sector 1813657720)
kernel: parent transid verify failed on 915432538112 wanted 16974 found
16972
kernel: btrfs read error corrected: ino 1 off 915432538112 (dev /dev/sdc
sector 1813660672)
kernel: parent transid verify failed on 915444740096 wanted 16974 found
13021
kernel: btrfs read error corrected: ino 1 off 915444740096 (dev /dev/sdc
sector 1813684504)
kernel: parent transid verify failed on 915444469760 wanted 16974 found
13021
kernel: parent transid verify failed on 915444469760 wanted 16974 found
13021
kernel: parent transid verify failed on 915444469760 wanted 16974 found
13021
kernel: parent transid verify failed on 915444469760 wanted 16974 found
13021
kernel: parent transid verify failed on 915444469760 wanted 16974 found
13021
kernel: parent transid verify failed on 915444469760 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: verify_parent_transid: 45 callbacks suppressed
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: parent transid verify failed on 915444518912 wanted 16974 found
13021
kernel: btrfs read error corrected: ino 1 off 915431141376 (dev /dev/sdc
sector 1813657944)
kernel: btrfs read error corrected: ino 1 off 915431165952 (dev /dev/sdc
sector 1813657992)
kernel: btrfs read error corrected: ino 1 off 915431272448 (dev /dev/sdc
sector 1813658200)
kernel: btrfs read error corrected: ino 1 off 915431161856 (dev /dev/sdc
sector 1813657984)
kernel: btrfs read error corrected: ino 1 off 915445268480 (dev /dev/sdc
sector 1813685536)
kernel: btrfs read error corrected: ino 1 off 915440472064 (dev /dev/sdc
sector 1813676168)
kernel: btrfs read error corrected: ino 1 off 915431170048 (dev /dev/sdc
sector 1813658000)
kernel: btrfs read error corrected: ino 1 off 915431174144 (dev /dev/sdc
sector 1813658008)
kernel: btrfs read error corrected: ino 1 off 915431378944 (dev /dev/sdc
sector 1813658408)
kernel: verify_parent_transid: 147 callbacks suppressed
kernel: parent transid verify failed on 915432869888 wanted 16974 found
16972
kernel: parent transid verify failed on 915444473856 wanted 16974 found
13021
kernel: parent transid verify failed on 915444473856 wanted 16974 found
13021
kernel: parent transid verify failed on 915433119744 wanted 16974 found
16972
kernel: parent transid verify failed on 915433656320 wanted 16974 found
16972
kernel: parent transid verify failed on 915433123840 wanted 16974 found
16972
kernel: parent transid verify failed on 915433050112 wanted 16974 found
16972
kernel: parent transid verify failed on 915444473856 wanted 16974 found
13021
kernel: parent transid verify failed on 915444473856 wanted 16974 found
13021
kernel: parent transid verify failed on 915444822016 wanted 16974 found
13021
kernel: BTRFS info (device sdc): failed to delete reference to
eggdrop-1.6.19.ebuild, inode 2096893 parent 5881667
kernel: BTRFS error (device sdc) in __btrfs_unlink_inode:3662: errno=-5
IO failure
kernel: BTRFS info (device sdc): forced readonly


Next best step to try?

Remount "-o recovery,noatime" again?


Thanks,
Martin














