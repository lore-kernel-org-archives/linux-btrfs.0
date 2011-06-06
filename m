From: Nirbheek Chauhan <nirbheek@gentoo.org>
Subject: Applications using fsync cause hangs for several seconds every few minutes
Date: Tue, 7 Jun 2011 04:28:04 +0530
Message-ID: <BANLkTimMv_MMVmsJeVvr_1_wEVam1WZ6BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I've been using btrfs on my personal machines for about two years now,
and on this machine for about a year with absolutely no problems.
Infact, it has held up better than ext4 with regards to reliability.

However, recently, perhaps with 2.6.39, or after I quickly started
filling up my disk again, it has become impossible for me to work for
long periods on my machine.

Every few minutes, (I guess) when applications do fsync (firefox,
xchat, vim, etc), all applications that use fsync() hang for several
seconds, and applications that use general IO suffer extreme
slowdowns. iotop shows various combinations of the processes listed
below doing writes, and the total write as 2-3MB/s.

[btrfs-dealloc-]
[btrfs-submit-0]
[btrfs-transacti]
[btrfs-endio-wri]
[flush-btrfs-1]

In some extreme cases, I've had hangs for 5 whole minutes. I'm really
beginning to appreciate how little I/O GNOME Shell does since it
remains completely responsive throughout this. I have a feeling that
the cause for this is extreme fragmentation.

My hard disk is a 500GB SATA hdd, my btrfs partition details are:

# btrfs filesystem show
Label: 'gentoo'  uuid: 6f539d7f-f70f-4216-a4a9-6f7a2117a04a
	Total devices 1 FS bytes used 246.37GB
	devid    1 size 345.13GB used 345.13GB path /dev/sda7

Btrfs v0.19-35-g1b444cd-dirty

What can I do to debug this issue? What other information should I
supply? Could someone guide me on how to figure out why my machine is
unusable now?

Thanks in advance,

-- 
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
