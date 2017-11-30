Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:40844 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbdK3MoA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 07:44:00 -0500
Received: by mail-it0-f52.google.com with SMTP id f190so8254535ita.5
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 04:44:00 -0800 (PST)
MIME-Version: 1.0
From: Eric Mesa <ericsbinaryworld@gmail.com>
Date: Thu, 30 Nov 2017 07:43:59 -0500
Message-ID: <CAKYHq8+crFyGA7UjaTQehOY5BcKnFLXPVMQ=VZqbeV-XhU63Yw@mail.gmail.com>
Subject: btrfs-progs - failed btrfs replace on RAID1 seems to have left things
 in a wrong state
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Not sure if this is a reportable bug, so I figured I'd start on the
mailing list and then report a bug if it is a bug and not user error.

Here is the original state of a RAID1 in which I wanted to replace the
smaller drive (except the /dev/sdX was different):

     btrfs filesystem show

     Label: 'Photos'  uuid: 27cc1330-c4e3-404f-98f6-f23becec76b5
            Total devices 2 FS bytes used 2.56TiB
           devid    1 size 2.73TiB used 2.57TiB path /dev/sde1
           devid    2 size 3.64TiB used 2.57TiB path /dev/sdb1

I added a 6TB HD to the system via a Zalman "toaster"-like external
hard drive via USB2.0. I ran the command:

btrfs replace start -f 1 /dev/sdl /media/Photos/

For some reason - perhaps pertaining to the USB enclosure having
errors, I ended up with this as the output of status:

Started on 29.Nov 21:32:46, canceled on 29.Nov 21:52:31 at 0.0%,
236415 write errs, 0 uncorr. read errs

So I moved the computer inside by disconnected an optical drive and
connected the drive via its SATA data and power cables. The system now
recognizes it as /dev/sda.

When I do a btrfs fi show, I get the same output as above.

But when I try to go again:

btrfs replace start -f 1 /dev/sda /media/Photos/

ERROR: /dev/sda is mounted

And when I do a dmesg | grep sda

[    1.448727] sd 0:0:0:0: [sda] Attached SCSI disk

[    3.920449] BTRFS: device label Photos devid 0 transid 158105 /dev/sda

btrfs device delete 0 /media/Photos/

ERROR: error removing devid 0: unable to go below two devices on raid1

I tried reformatting the drive, but still have this issue. Here are
some outputs of commands I ran:

    # umount /media/Photos

    # btrfs check --readonly /dev/sda
    parent transid verify failed on 3486916509696 wanted 158105 found 158107
    parent transid verify failed on 3486916509696 wanted 158105 found 158107
    parent transid verify failed on 3486916509696 wanted 158105 found 158107
    parent transid verify failed on 3486916509696 wanted 158105 found 158107
    Ignoring transid failure
    Checking filesystem on /dev/sda
    UUID: 27cc1330-c4e3-404f-98f6-f23becec76b5
    checking extents
    checking free space cache
    checking fs roots
    checking csums
    checking root refs
    ERROR: transid errors in file system
    found 2816405245952 bytes used err is 1
    total csum bytes: 2746708244
    total tree bytes: 3087089664
    total fs tree bytes: 180305920
    total extent tree bytes: 40058880
    btree space waste bytes: 106866688
    file data blocks allocated: 3245113991168
    referenced 3179709394944

    # btrfs fi show
    Label: 'NotHome'  uuid: 09344d53-db1e-43d0-8e43-c41a5884e172
            Total devices 1 FS bytes used 1.79TiB
            devid    1 size 3.64TiB used 1.81TiB path /dev/sdd1

    Label: 'Home1'  uuid: 89cfd56a-06c7-4805-9526-7be4d24a2872
            Total devices 1 FS bytes used 949.91GiB
            devid    1 size 2.73TiB used 1.65TiB path /dev/sdc1

    Label: 'Photos'  uuid: 27cc1330-c4e3-404f-98f6-f23becec76b5
            Total devices 2 FS bytes used 2.56TiB
            devid    1 size 2.73TiB used 2.57TiB path /dev/sde1
            devid    2 size 3.64TiB used 2.57TiB path /dev/sdb1

    Label: none  uuid: 659edd01-d563-4e7e-b8a7-5b192b814381
            Total devices 1 FS bytes used 112.00KiB
            devid    1 size 5.46TiB used 2.02GiB path /dev/sda1

    # btrfs replace start -f 1 /dev/sda /media/Photos/
    ERROR: /dev/sda is mounted

    # btrfs fi show
    Label: 'NotHome'  uuid: 09344d53-db1e-43d0-8e43-c41a5884e172
            Total devices 1 FS bytes used 1.79TiB
            devid    1 size 3.64TiB used 1.81TiB path /dev/sdd1

    Label: 'Home1'  uuid: 89cfd56a-06c7-4805-9526-7be4d24a2872
            Total devices 1 FS bytes used 949.95GiB
            devid    1 size 2.73TiB used 1.65TiB path /dev/sdc1

    Label: 'Photos'  uuid: 27cc1330-c4e3-404f-98f6-f23becec76b5
            Total devices 2 FS bytes used 2.56TiB
            devid    1 size 2.73TiB used 2.57TiB path /dev/sde1
            devid    2 size 3.64TiB used 2.57TiB path /dev/sdb1

    Label: none  uuid: 659edd01-d563-4e7e-b8a7-5b192b814381
            Total devices 1 FS bytes used 112.00KiB
            devid    1 size 5.46TiB used 2.02GiB path /dev/sda1

    # cat /proc/mounts  | grep sda
    #

    # btrfs dev usage /media/Photos/
    /dev/sdb1, ID: 2
    Device size:             3.64TiB
    Device slack:              0.00B
    Data,single:             1.00GiB
    Data,RAID1:              2.56TiB
    Metadata,single:         1.00GiB
    Metadata,RAID1:          5.00GiB
    System,single:          32.00MiB
    System,RAID1:           32.00MiB
    Unallocated:             1.07TiB

    /dev/sde1, ID: 1
    Device size:             2.73TiB
    Device slack:              0.00B
    Data,RAID1:              2.56TiB
    Metadata,RAID1:          5.00GiB
    System,RAID1:           32.00MiB
    Unallocated:           166.49GiB



There appears to be some kind of weird situation going on:

     # btrfs device remove /dev/sda /media/Photos/
     ERROR: error removing device '/dev/sda': unable to go below two
devices on raid1
     # btrfs device remove /dev/sdb /media/Photos/
     ERROR: error removing device '/dev/sdb': unable to go below two
devices on raid1
     # btrfs device remove /dev/sde /media/Photos/
     ERROR: error removing device '/dev/sde': unable to go below two
devices on raid1

who (filesystem? disk? some program?) maintains the info on what was
going on with /dev/sda? I feel like there's some kind bit I need to
clear and then it'll work correctly.

---

So my question is two-fold.

1) Where do I go from here to get things working for me? I have my
photos on these drives (which is why I went RAID1 so I could have high
availability backup-ish situation) so I don't want to do anything
destructive to the two drives currently working fine in the array.

2) The fact that a failed replace left the (system|disks|filesystem)
thinking that the drive is both part of and not part of the RAID1 -
does that need to be reported as a bug?
--
Eric Mesa
http://www.ericmesa.com
