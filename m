From: Travis Shivers <ttshivers@gmail.com>
Subject: Btrfs Storage Array Corrupted
Date: Tue, 28 Feb 2012 18:13:35 -0600
Message-ID: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Recently, I have been having major problems with my RAID 1 btrfs
array. I know that btrfsck is not yet released, which is the main
reason why I cannot repair my filesystem. Is there a way for me to get
my data off the broken filesystem? After a reboot, my btrfs filesystem
was unable to mount and gave this error:

# mount /dev/sdh
mount: wrong fs type, bad option, bad superblock on /dev/sdh,
=A0=A0=A0=A0=A0=A0 missing codepage or helper program, or other error
=A0=A0=A0=A0=A0=A0 In some cases useful info is found in syslog - try
=A0=A0=A0=A0=A0=A0 dmesg | tail=A0 or so


I did as it suggested and took a look at dmesg:

[74702.033750] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 devid
3 transid 43477 /dev/sdh
[74702.037263] btrfs: use lzo compression
[74702.037276] btrfs: enabling inode map caching
[74702.037280] btrfs: allowing degraded mounts
[74702.037287] btrfs: enabling auto recovery
[74702.037290] btrfs: disk space caching is enabled
[74702.083683] parent transid verify failed on 5568194695168 wanted
43477 found 43151
[74702.083697] parent transid verify failed on 5568194695168 wanted
43477 found 43151
[74702.083705] parent transid verify failed on 5568194695168 wanted
43477 found 43151
[74702.083712] parent transid verify failed on 5568194695168 wanted
43477 found 43151
[74702.086495] btrfs: open_ctree failed

It seems that there is a problem with the btrfs ctree. I tried several
things including upgrading my kernel, trying to use recovery and
degraded mount options, trying to mount it on another computer all
without success.

Here is some more information about the problem and some of the things
that I tried:

# btrfs-debug-tree /dev/sdh
couldn't open because of unsupported option features (8).
btrfs-debug-tree: disk-io.c:679: open_ctree_fd: Assertion `!(1)' failed


# ./btrfs-zero-log /dev/sdh
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568195178496 wanted 43477 found 43151
parent transid verify failed on 5568195178496 wanted 43477 found 43151
parent transid verify failed on 5568195178496 wanted 43477 found 43151
parent transid verify failed on 5568195178496 wanted 43477 found 43151
Ignoring transid failure


Here is some basic information about my system:

Linux server 3.2.8-030208-generic #201202271435 SMP Mon Feb 27
19:36:27 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

In the storage array, I have:
2 (2 TB) drives
2 (500 GB) drives

I have also made a post about this problem on the Ubuntu Forums:
http://ubuntuforums.org/showthread.php?p=3D11726449#post11726449
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
