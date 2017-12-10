Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36580 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbdLJPSy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 10:18:54 -0500
Received: by mail-qk0-f182.google.com with SMTP id t187so4263233qkh.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 07:18:53 -0800 (PST)
MIME-Version: 1.0
From: constantine <costas.magnuse@gmail.com>
Date: Sun, 10 Dec 2017 15:18:32 +0000
Message-ID: <CANcfdL3LFXYFcr-qJDNhEvCttc3yEKKWY53aun0eC_gF0CXrrw@mail.gmail.com>
Subject: ERROR: failed to repair root items: Input/output error
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a laptop root hard drive (Samsung SSD 850 EVO 1TB), which is
within warranty.
I can't mount it read-write ("no rw mounting  after error").
The data are not really critical (I will overcome the shock of losing
them within a couple of days).


Btrfs check --repair throws an error:

sudo btrfs check --repair /dev/sdb1
enabling repair mode
Checking filesystem on /dev/sdb1
UUID: a955bc5f-e5f0-42ce-bd5a-de5eb8d5d3aa
checking extents
ERROR: add_tree_backref failed (non-leaf block): File exists
parent transid verify failed on 103009185792 wanted 5026 found 345954
parent transid verify failed on 103009185792 wanted 5026 found 345954
Ignoring transid failure
leaf parent key incorrect 103009185792
bad block 103009185792
ERROR: errors found in extent allocation tree or chunk allocation
checksum verify failed on 103009173504 found 25334496 wanted 00003500
checksum verify failed on 103009173504 found 25334496 wanted 00003500
bytenr mismatch, want=103009173504, have=889192478
ERROR: failed to repair root items: Input/output error

What do these errors mean?
What should I do to fix the filesystem and be able to mount it read-write?


Thank you,

Konstantinos Tsardounis


PS:
I login with an Ubuntu LiveCD now which returns:

uname -a
Linux ubuntu 4.13.0-16-generic #19-Ubuntu SMP Wed Oct 11 18:35:14 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux
btrfs --version
btrfs-progs v4.12
btrfs fi show
Label: 'arch'  uuid: a955bc5f-e5f0-42ce-bd5a-de5eb8d5d3aa
    Total devices 1 FS bytes used 876.26GiB
    devid    1 size 931.01GiB used 931.01GiB path /dev/sdb1
btrfs fi df sdb1
Data, single: total=926.25GiB, used=872.65GiB
System, single: total=4.00MiB, used=128.00KiB
Metadata, single: total=4.76GiB, used=3.60GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

and the dmesg.log is on:
https://gist.github.com/anonymous/16344244259bb2989701f3ec43e26f39
