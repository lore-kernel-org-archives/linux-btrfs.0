Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:46910 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbbJCNZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Oct 2015 09:25:29 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Paride Legovini <pl@ninthfloor.org>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send -c fails saying "parent determination failed"
Date: Sat, 03 Oct 2015 09:18:44 -0400
MIME-Version: 1.0
Message-ID: <029ed05f-06a4-452e-92d6-190472e9a313@aei.ca>
In-Reply-To: <560B0E9B.7020500@ninthfloor.org>
References: <560B0E9B.7020500@ninthfloor.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have the same problem here.  I'd love to stop using rsync in place of 
send recieve.  As with Paride my _working_ scripts just stop functioning...

Thanks
Ed

on Tuesday, September 29, 2015 6:20:11 PM EDT, Paride Legovini wrote:
> Hi,
>
> btrfs send -c stopped working for me several months ago. My setup is
> actually very simple. On the "send" side I have:
>
> # btrfs sub list -u / | grep rootfs-snapshot-
> ID 2221 gen 93340 top level 5 uuid adf43113-0442-9847-9ce4-7d9c06e77602
> path rootfs-snapshot-20150923
> ID 2262 gen 96026 top level 5 uuid 49f34ca5-42da-7d4b-a159-c3027650d8e6
> path rootfs-snapshot-20150929
>
> Several other subvolumes also exist there, just in case it matters.
> On the receive side:
>
> # btrfs sub list -R /mnt/cryptobackup/ | grep rootfs-snapshot-20150923
> ID 1532 gen 3066 top level 5 received_uuid
> adf43113-0442-9847-9ce4-7d9c06e77602 path snapshots/rootfs-snapshot-20150923
>
> As you can see the uuids for rootfs-snapshot-20150923 are the same on
> both sides. If I try to send|receive /rootfs-snapshot-20150929 using
> rootfs-snapshot-20150923 as clone source it fails:
>
> # btrfs send -c /rootfs-snapshot-20150923 /rootfs-snapshot-20150929 |
> btrfs receive /mnt/cryptobackup/snapshots/
> At subvol /rootfs-snapshot-20150929
> ERROR: parent determination failed for 2221
>
> while it works fine if I use btrfs send -p. This is always reproducible,
> it fails every time across reboots and kernel upgrades; it works every
> time with -p.
>
> In both / and /mnt/cryptobackup I didn't mount any special subvolid:
>
> # btrfs sub get-default /
> ID 5 (FS_TREE)
> # btrfs inspect-internal rootid /
> 5
> # btrfs sub get-default /mnt/cryptobackup/
> ID 5 (FS_TREE)
> # btrfs inspect-internal rootid /mnt/cryptobackup/
> 5
>
> so nothing strange here. Some other possibly useful information:
>
> $ uname -a
> Linux mandragola 4.2.0-1-amd64 #1 SMP Debian 4.2.1-1 (2015-09-25) x86_64
> GNU/Linux
>
> so you have guessed that I'm running an up to date Debian system. Keep
> in mind that it is several kernel versions that I'm getting this
> problem, it's nothing specific to this one.
>
> $ btrfs --version
> btrfs-progs v4.1.2
>
> # btrfs fi show
> Label: none  uuid: 5651d651-5c48-425f-9fc9-56f2a9ad004f
> 	Total devices 1 FS bytes used 118.24GiB
> 	devid    1 size 237.97GiB used 218.02GiB path /dev/sda2
>
> Label: none  uuid: c4db7f4f-b976-4d36-bd76-76e818341cef
> 	Total devices 1 FS bytes used 934.71GiB
> 	devid    1 size 1.82TiB used 941.03GiB path /dev/mapper/cryptobackup
>
> $ btrfs fi df /
> Data, single: total=212.01GiB, used=116.98GiB
> System, single: total=4.00MiB, used=48.00KiB
> Metadata, single: total=6.01GiB, used=1.27GiB
> GlobalReserve, single: total=448.00MiB, used=0.00B
>
> $ btrfs fi df /mnt/cryptobackup/
> Data, single: total=932.00GiB, used=931.70GiB
> System, DUP: total=8.00MiB, used=128.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=4.50GiB, used=3.01GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> $ dmesg | grep -i btrfs | curl -F "sprunge=<-" http://sprunge.us
> http://sprunge.us/EiHE
>
> If I hit a bug I'll be happy to help in finding it, just tell me if you
> need further information. Otherwise, if I'm just missing something, I'll
> appreciate any hint.
>
> Thank you,
>
> Paride
>
>
>

