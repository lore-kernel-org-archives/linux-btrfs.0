From: Dave Jones <davej@redhat.com>
Subject: btrfs io errors on 3.4rc1
Date: Mon, 2 Apr 2012 14:02:14 -0400
Message-ID: <20120402180214.GA1830@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Updated to rc1 this morning, and my machines with btrfs are all freaking out..

I got this from my cron email ..

/etc/cron.daily/prelink: line 41: /var/lib/prelink/full: Input/output error
cp: cannot create regular file `/var/lib/prelink/quick': Input/output error
/etc/cron.daily/prelink: line 45: /var/log/prelink/prelink.log: Input/output error

I tried updating my git tree..

$ gp
error: cannot open .git/FETCH_HEAD: Input/output error
$ gp
remote: Counting objects: 5101, done.
remote: Compressing objects: 100% (546/546), done.
remote: Total 3764 (delta 3233), reused 3738 (delta 3208)
Receiving objects: 100% (3764/3764), 783.19 KiB | 195 KiB/s, done.
Resolving deltas: 100% (3233/3233), completed with 831 local objects.
fatal: fsync error on '.git/objects/pack/tmp_pack_gq3edw': Input/output error
fatal: index-pack failed

I looked in dmesg, nothing out of the ordinary (disks dying etc -- plus it's happening
on two machines, so unlikely they both have hardware problems)

But anything that does writes seems to have serious issues..

$ fsx foo 
truncating to largest ever: 0x13e76
truncating to largest ever: 0x2e52c
ftruncate1: 2e52c
dotruncate: ftruncate: Input/output error
Segmentation fault (core dumped)

tried to send this email..

collect: Cannot write ./dfq32HpM1C010652 (fsync, uid=1000, gid=51): Input/output error
Error writing control file ./qfq32HpM1C010652: Input/output error


3.3 is fine.

	Dave
