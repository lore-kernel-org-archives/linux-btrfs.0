Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:35050 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751704AbcIOX7G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 19:59:06 -0400
Received: by mail-vk0-f49.google.com with SMTP id b133so3773470vka.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 16:59:06 -0700 (PDT)
MIME-Version: 1.0
From: GWB <gwb@2realms.com>
Date: Thu, 15 Sep 2016 18:58:24 -0500
Message-ID: <CAP8EXU2fx5ipNQ77WrntCvMZ8GWSke0yNs-jduaetpM_=RDGVw@mail.gmail.com>
Subject: df -i shows 0 inodes 0 used 0 free on 4.4.0-36-generic Ubuntu 14 -
 Bug or not?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't expect accurate data on a btrfs file system when using df, but
after upgrading to kernel 4.4.0 I get the following:

$ df -i
...
/dev/sdc3               0       0          0     - /home
/dev/sdc4               0       0          0     - /vm0
...

Where /dev/sdc3 and /dev/sdc4 are btrfs filesystems.

So is this a bug or not?  I ask because root (/dev/sdc3) began to
display the error message "no space left on device", which was
eventually cured by deleting old snapshots then btrfs fi sync and
btrfs balance.  fi show and fi df show space, even when df -i shows 0
inodes:

sudo btrfs fi show /
...
Label: none  uuid: 9acdb642-d743-4c2a-a59f-811022c2a2b0
        Total devices 1 FS bytes used 23.86GiB
        devid    1 size 60.00GiB used 42.03GiB path /dev/sdc3


 sudo btrfs fi df /
Data, single: total=37.00GiB, used=21.11GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=5.00GiB, used=2.75GiB
unknown, single: total=512.00MiB, used=0.00

Please excuse my inexperience here; I don't know how to use btrfs
commands to show inodes.  btrfs inspect-internal will reference an
inode as near as I can tell, but won't list the used and free inodes
("free" may not be the correct word here, given btrfs architecture).

Many Thanks,

Gordon

Machine Specs:

% uname -a
Linux Bon-E 4.4.0-36-generic #55~14.04.1-Ubuntu SMP Fri Aug 12
11:49:30 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

% btrfs --version
Btrfs v3.12

% sudo btrfs fi show
Label: none  uuid: 9acdb642-d743-4c2a-a59f-811022c2a2b0
        Total devices 1 FS bytes used 23.86GiB
        devid    1 size 60.00GiB used 42.03GiB path /dev/sdc3

%Label: vm0  uuid: 72539416-d30e-4a34-8b2d-b2369d1fb075
        Total devices 1 FS bytes used 349.96GiB
        devid    1 size 374.66GiB used 374.66GiB path /dev/sdc4

dmesg does not appear to show anything useful for btrfs or device, but
mount shows:

% mount | grep btrfs
/dev/sdc3 on / type btrfs (rw,ssd,subvol=@)
/dev/sdc3 on /home type btrfs (rw,ssd,subvol=@home)
/dev/sdc4 on /vm0 type btrfs (rw,ssd,space_cache,compress=lzo,subvol=@vm0)
/dev/sdc3 on /mnt/btrfs-root type btrfs (rw)
