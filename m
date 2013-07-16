Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f41.google.com ([209.85.128.41]:37560 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3GPKAd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 06:00:33 -0400
Received: by mail-qe0-f41.google.com with SMTP id b4so252846qen.14
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 03:00:33 -0700 (PDT)
MIME-Version: 1.0
From: Mathieu Malaterre <mathieu.malaterre@gmail.com>
Date: Tue, 16 Jul 2013 12:00:12 +0200
Message-ID: <CA+7wUsx8WJsGzNcOcS0aE1QVtwRmgKNrdBw2m01X_-UQZDf=5Q@mail.gmail.com>
Subject: Errors found in extent allocation tree (was: btrfsck:
 cmds-check.c:2063: check_owner_ref: Assertion `!(rec->is_root)' failed.)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef,

  Thanks for your help so far. I am continuing on your recommendations:

08:55 <josef> knoppix: ok i pushed to for-knoppix
08:55 <josef> pull and build
08:55 <josef> and then run ./btrfsck --init-csum-tree /dev/whatever
08:55 <josef> it will clear your csum tree and re-populate it
08:55 <josef> once thats done re-run ./btrfsck /dev/whatever
08:55 <josef> and make sure it doesnt complain about anything
08:55 <josef> and then you should be good to go

  However as mentionned on IRC, when running:

$ ./btrfsck /dev/mapper/voxbox-root

I get:

http://gdcm.sourceforge.net/thingies/second-run.log.gz

Here is an excerpt:

[...]
Errors found in extent allocation tree
checking free space cache
checking fs roots
root 5 inode 36548371 errors 800
root 5 inode 37487771 errors 800
root 5 inode 41402100 errors 800
root 5 inode 41402104 errors 800
root 5 inode 41402106 errors 800
root 5 inode 41402108 errors 800
Checking filesystem on /dev/mapper/voxbox-root
UUID: af7e6809-af9d-474f-a332-295cdba1c09f
adding extent start=192631939072, nr=4096, item_refs=0
adding a tree backref for 192631939072, found ref 1
adding extent start=20987904, nr=4096, item_refs=0
adding a tree backref for 20987904, found ref 1
adding extent start=192631799808, nr=4096, item_refs=0
adding a tree backref for 192631799808, found ref 1
adding extent start=770289664, nr=4096, item_refs=0
adding a tree backref for 770289664, found ref 1
adding extent start=196437823488, nr=4096, item_refs=0
adding a tree backref for 196437823488, found ref 1
adding extent start=355315712, nr=4096, item_refs=0
adding a tree backref for 355315712, found ref 1
adding extent start=29380608, nr=4096, item_refs=0
adding a tree backref for 29380608, found ref 1
adding a tree backref for 355315712, found ref 0
adding a tree backref for 770289664, found ref 0
adding a tree backref for 29380608, found ref 0
adding a tree backref for 196437823488, found ref 0
adding a tree backref for 192631799808, found ref 0
adding a tree backref for 192631939072, found ref 0
adding a tree backref for 20987904, found ref 0
cache and super generation don't match, space cache will be invalidated
found 704384384322 bytes used err is 1
total csum bytes: 1744520208
total tree bytes: 9188548608
total fs tree bytes: 6794817536
total extent tree bytes: 532430848
btree space waste bytes: 2180175539
file data blocks allocated: 2840214335488
 referenced 1776183914496
[...]


What should I do now ?

Thanks much.

On Mon, Jul 8, 2013 at 4:15 PM, Mathieu Malaterre
<mathieu.malaterre@gmail.com> wrote:
> Here is a wrap-up of what is going on on #btrfs. I am trying to boot
> my debian/squeeze system with btrfs filesystem. System was setup with
> an initial kernel 2.6.32.
> The system now refuses to boot.
>
> Booting using a live knopix 7.2.0 (kernel 3.9.6), I can see:
>
> $ sudo vgchange -ay /dev/voxbox
> $ mkdir /tmp/sda1
> $ sudo mount -v -t btrfs -o recovery /dev/mapper/voxbox-root /tmp/sda1
> $ dmesg | tail
> [...]
> [13429.460451] device fsid af7e6809-af9d-474f-a332-295cdba1c09f devid
> 1 transid 2207957 /dev/mapper/voxbox-root
> [13429.461584] btrfs: enabling auto recovery
> [13429.529165] parent transid verify failed on 201236885504 wanted
> 1822936 found 2125997
> [13429.532014] parent transid verify failed on 201236885504 wanted
> 1822936 found 2125997
> [13429.587204] btrfs: open_ctree failed
>
>
> If I now use the cmd line tools from git:
>
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> $ cd btrfs-progs/
> $ make
> $ ./btrfsck /dev/mapper/voxbox-root
> parent transid verify failed on 201236885504 wanted 1822936 found 2125997
> parent transid verify failed on 201236885504 wanted 1822936 found 2125997
> parent transid verify failed on 201236885504 wanted 1822936 found 2125997
> parent transid verify failed on 201236885504 wanted 1822936 found 2125997
> Ignoring transid failure
> Checking filesystem on /dev/mapper/voxbox-root
> UUID: af7e6809-af9d-474f-a332-295cdba1c09f
> checking extents
> btrfsck: cmds-check.c:2063: check_owner_ref: Assertion `!(rec->is_root)' failed.
> Aborted
>
>
> For reference:
>
> $ sudo vgdisplay
>   --- Volume group ---
>   VG Name               voxbox
>   System ID
>   Format                lvm2
>   Metadata Areas        2
>   Metadata Sequence No  6
>   VG Access             read/write
>   VG Status             resizable
>   MAX LV                0
>   Cur LV                3
>   Open LV               0
>   Max PV                0
>   Cur PV                2
>   Act PV                2
>   VG Size               2.73 TiB
>   PE Size               4.00 MiB
>   Total PE              715398
>   Alloc PE / Size       715398 / 2.73 TiB
>   Free  PE / Size       0 / 0
>   VG UUID               mxbe5Y-Wjh1-fC2C-WS27-Fy0X-2JB6-PvrA0Q
>
> Regards,
> --
> Mathieu



--
Mathieu
