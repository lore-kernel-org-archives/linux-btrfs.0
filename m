Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38629 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbcEQOAn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 10:00:43 -0400
Received: by mail-wm0-f49.google.com with SMTP id g17so32792096wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 07:00:42 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 May 2016 10:00:41 -0400
Message-ID: <CAEwOqv5fDHNVe7Q_+PH_k+W-WRPMt3W3psjzh2vjYfEKq-XWPw@mail.gmail.com>
Subject: BTRFS RAID 1 broken: Mounted drive(s) basically empty after repair attempt
From: Quanttek Jonas <quantugie@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey there,

first up, I'll provide the basic information:

(I'm using Fedora 23 on my system with newest available kernel etc,
but I'm currently booted up with a Live-USB-Stick)

    $ uname -a
    Linux localhost 4.2.3-300.fc23.x86_64 #1 SMP Mon Oct 5 15:42:54
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

    $ btrfs --version
    btrfs-progs v4.2.2

    $ sudo btrfs fi show
    Label: 'Fedora'  uuid: 4ba9cb30-37d0-493d-8e52-59b69ec8d6ba
        Total devices 1 FS bytes used 27.23GiB
        devid    1 size 138.47GiB used 65.01GiB path /dev/sda5

    Label: 'Data'  uuid: a4cddadf-0a26-4eca-ba7f-7df179152247
        Total devices 2 FS bytes used 1.49TiB
        devid    1 size 1.82TiB used 1.52TiB path /dev/sdc
        devid    2 size 1.82TiB used 1.52TiB path /dev/sdd

    $ sudo btrfs fi df /mnt/sdc
    Data, RAID1: total=1.52TiB, used=1.49TiB
    Data, single: total=8.00MiB, used=0.00B
    System, RAID1: total=8.00MiB, used=240.00KiB
    System, single: total=4.00MiB, used=0.00B
    Metadata, RAID1: total=3.00GiB, used=2.05GiB
    Metadata, single: total=8.00MiB, used=0.00B
    GlobalReserve, single: total=512.00MiB, used=0.00B

FYI GParted reports usage with 762.88 GiB of a 1.82 TiB disk, which
seems to be the correct values if I recall them correctly

dmesg.log: http://paste.fedoraproject.org/366440/32506321/raw/. I
should note that I had multiple stack traces
and errors, with soft lockups of the CPU cores (like here:
http://ubuntuforums.org/showthread.php?t=2205211) and "task
btrfs-transacti blocked for more than 120 seconds" and wasn't able to
mount the system, but that changed (mainly because I probably tried
some stupid stuff).

___________________

So to start with the "story": I locked the screen for a few minutes
and when I came back my system was frozen, so I used the reset-button,
but I wasn't able to boot up (took forever). So I forced systemd
emergency mode and checked the logs, which stated that systemd was
unable to mount /home. So I tried to mount it, which took forever and
I was unable to cancel it, so I forcefully restarted. Same happened
using the "recovery" option. Looking into the logs, the errors laid
out above appeared.

I restarted and used "btrfsck /dev/sdc": Error output was relatively
strong (unlike the current one linked below as "btrfsck output.txt")
talking about "Errors found in extent allocation tree or chunk
allocation", "cache appears valid but isnt" and "total csum bytes: 0"
IIRC (unfortunately I didn't save the output and only vaguely
remember).

So I did some googling and using "btrfsck --repair" got recommended,
which I did (and later learned, that this was a big mistake). I got
thousands of lines along the kind shown in "btrfsck output.txt", just
with a little "Trying to rebuild inode" added at the beginning of each
line. I waited multiple hours, but it never finished.

Interestingly after that I was able to mount the filesystem, but only
the root dirs existed (Music, Downloads, Videos etc) and they were all
empty. After that I tried mounting each drive with "-o degrading, ro,
recovery", but still same problem. Basically I followed the quoted
comment after that:
https://bbs.archlinux.org/viewtopic.php?pid=1321989#p1321989 (though I
didn't use "btrfsck --repair" a second time). Interestingly the
"btrfsck /dev/sdc" output was relatively short, with similiar output
like in the beginning. Trying different superblocks with "btrfsck -s #
/dev/sdc" didn't change the existing errors however.

Following this http://askubuntu.com/questions/157917/how-do-i-recover-a-btrfs-partition-that-will-not-mount
I tried mounting with "-o recovery,nospace_cache,clear_cache", which
brought back the long btrfsck output. This is also the log attached.
At this point I also created a btrfs-image (following the
bbs.archlinux.org post), which is only 1.6 GB big and a "real" image
using dd.

I cleared the logs with "btrfs-zero-log" and tried "btrfs check
--init-extent-tree" and then btrfs restore with basically no results,
so I restored the dd image. Here I also tried btrfs restore, but I
only got hundreds of "parent transid verify failed on", with "extent
buffer leak: start 31571968 len 16384" at the end. It also is only
able to recover the root folders (like ~/Downloads). Also using
"btrfs-find-root", left me with this:
http://paste.fedoraproject.org/366427/24974814/. And using btrfs check
now, mostly results in those "parent transid verify failed" errors

___________________

So, the question is: How can I recover from this? How do I get my data
back, after foolishly using "btrfsck --repair"?

Thanks for any help in advance!

___________________

"btrfsck output.txt": http://paste.ubuntu.com/16382852/
