Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:45347 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAUWKA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 17:10:00 -0500
Received: by mail-vb0-f45.google.com with SMTP id m10so3808279vbh.4
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 14:09:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD_cGvFie41PxiJqa1tL04vZYNsfk8fCHrf4=znXO2Ds=sF8Vw@mail.gmail.com>
References: <CAD_cGvFie41PxiJqa1tL04vZYNsfk8fCHrf4=znXO2Ds=sF8Vw@mail.gmail.com>
Date: Tue, 21 Jan 2014 23:09:58 +0100
Message-ID: <CAD_cGvHMX0=EaThq3u_ZOGGcXgi0hmmW-_zUVf5WK5dEzPg2vQ@mail.gmail.com>
Subject: Re: failed to read the system array on sdX
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, I think I found the issue. The array was okay and mounted
successfully after running "btrfs device scan", and the samba issue
was unrelated and had something to do with winbind integration with AD
which the reboot cured after getting the btrfs store to mount.

It has always done this automatically for me on Debian Wheezy however,
but then I remembered that I removed the old btrfs-tools package when
installing btrfs-progs from git. I noticed that the btrfs-progra
package did an update-initramfs when installing which I guess is the
clue here. I is probably adding the old call of btrfsctl -a during
boot, while this is gone with btrfs-progs.

1. How can I manually add btrfs device scan to initramfs with
btrfs-progs like the debian package?
2. There is no uninstall target in the btrfs-tools Makefile. How am I
supposed to uninstall btrfs-progs if wanting to go back to older
versions (or newer)?



On 21 January 2014 22:31, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:
> Hi
>
> I suddenly got issues accessing a samba share and rebooted the server.
> After the reboot the btrfs mount does not come up and prints the
> following messages in dmesg:
>
> [  530.881802] btrfs: device fsid 9302fc8f-15c6-46e9-9217-951d7423927c
> devid 4 transid 138602 /dev/sdt
> [  530.882734] btrfs: disk space caching is enabled
> [  530.883697] btrfs: failed to read the system array on sdt
> [  530.898188] btrfs: open_ctree failed
>
> Probably some kind of issue with btrfs was the reason for the samba
> share failing.
> --
> - All seven 4TB drives is in one btrfs RAID10 with no lvm/mdadm
>
> btrfs fi show
> Label: none  uuid: 9302fc8f-15c6-46e9-9217-951d7423927c
>         Total devices 7 FS bytes used 9.91TiB
>         devid    2 size 3.64TiB used 3.07TiB path /dev/sdm
>         devid    3 size 3.64TiB used 3.07TiB path /dev/sds
>         devid    4 size 3.64TiB used 3.07TiB path /dev/sdt
>         devid    5 size 3.64TiB used 3.07TiB path /dev/sdo
>         devid    6 size 3.64TiB used 3.07TiB path /dev/sdp
>         devid    7 size 3.64TiB used 3.07TiB path /dev/sdq
>         devid    8 size 3.64TiB used 3.07TiB path /dev/sdr
>
> Btrfs v3.12
>
> /etc/fstab:
> UUID=9302fc8f-15c6-46e9-9217-951d7423927c   /btrfs
>               btrfs   defaults,compress=lzo,noatime          0   2
> UUID=9302fc8f-15c6-46e9-9217-951d7423927c   /storage/storage-vol0
>               btrfs   defaults,subvol=storage-vol0,noatime   0   2
>
> uname -a
> Linux merkur 3.12.6 #1 SMP Sat Dec 21 02:23:32 CET 2013 x86_64 GNU/Linux
>
> Hardware:
> Supermicro Xeon server with 16GB ECC RAM, LSI HBAs and WD SE 4TB drives.
>
> Adding recovery to mount options:
> # mount /btrfs/
> mount: wrong fs type, bad option, bad superblock on /dev/sdt,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
>
> ----
>
> What is the correct steps forward to mount my array again?
>
> Best regards,
> Hans-Kristian
