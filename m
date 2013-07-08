Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:41003 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3GHOPk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 10:15:40 -0400
Received: by mail-qa0-f47.google.com with SMTP id i13so5744887qae.13
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jul 2013 07:15:40 -0700 (PDT)
MIME-Version: 1.0
From: Mathieu Malaterre <mathieu.malaterre@gmail.com>
Date: Mon, 8 Jul 2013 10:15:19 -0400
Message-ID: <CA+7wUsxNA=8t0QuU8jBsmGuScKQbkW72+8ThtrsMmZAMvcPF2w@mail.gmail.com>
Subject: btrfsck: cmds-check.c:2063: check_owner_ref: Assertion
 `!(rec->is_root)' failed.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is a wrap-up of what is going on on #btrfs. I am trying to boot
my debian/squeeze system with btrfs filesystem. System was setup with
an initial kernel 2.6.32.
The system now refuses to boot.

Booting using a live knopix 7.2.0 (kernel 3.9.6), I can see:

$ sudo vgchange -ay /dev/voxbox
$ mkdir /tmp/sda1
$ sudo mount -v -t btrfs -o recovery /dev/mapper/voxbox-root /tmp/sda1
$ dmesg | tail
[...]
[13429.460451] device fsid af7e6809-af9d-474f-a332-295cdba1c09f devid
1 transid 2207957 /dev/mapper/voxbox-root
[13429.461584] btrfs: enabling auto recovery
[13429.529165] parent transid verify failed on 201236885504 wanted
1822936 found 2125997
[13429.532014] parent transid verify failed on 201236885504 wanted
1822936 found 2125997
[13429.587204] btrfs: open_ctree failed


If I now use the cmd line tools from git:

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
$ cd btrfs-progs/
$ make
$ ./btrfsck /dev/mapper/voxbox-root
parent transid verify failed on 201236885504 wanted 1822936 found 2125997
parent transid verify failed on 201236885504 wanted 1822936 found 2125997
parent transid verify failed on 201236885504 wanted 1822936 found 2125997
parent transid verify failed on 201236885504 wanted 1822936 found 2125997
Ignoring transid failure
Checking filesystem on /dev/mapper/voxbox-root
UUID: af7e6809-af9d-474f-a332-295cdba1c09f
checking extents
btrfsck: cmds-check.c:2063: check_owner_ref: Assertion `!(rec->is_root)' failed.
Aborted


For reference:

$ sudo vgdisplay
  --- Volume group ---
  VG Name               voxbox
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  6
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               2.73 TiB
  PE Size               4.00 MiB
  Total PE              715398
  Alloc PE / Size       715398 / 2.73 TiB
  Free  PE / Size       0 / 0
  VG UUID               mxbe5Y-Wjh1-fC2C-WS27-Fy0X-2JB6-PvrA0Q

Regards,
--
Mathieu
