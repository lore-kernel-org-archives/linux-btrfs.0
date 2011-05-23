From: =?ISO-8859-1?Q?Robert_Sch=F6ftner?= <rmu@unfoo.net>
Subject: cannot mount btrfs - parent transid verify failed
Date: Mon, 23 May 2011 20:57:42 +0200
Message-ID: <4DDAAE26.1010907@unfoo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello!

A power outage damaged a btrfs - it could not be mounted upon startup.
kernel: 2.6.38 (from ubuntu kernel ppa).

dmesg:

[   88.562819] device fsid 844676ff057abdd4-ccd6cf8af4e14dba devid 1
transid 112504 /dev/sdb1
[   88.596515] verify_parent_transid: 6 callbacks suppressed
[   88.596518] parent transid verify failed on 408626470912 wanted
111124 found 111474
[   88.596686] parent transid verify failed on 408626470912 wanted
111124 found 111474
[   88.600062] parent transid verify failed on 408626470912 wanted
111124 found 111474
[   88.600067] parent transid verify failed on 408626470912 wanted
111124 found 111474
[   88.670071] btrfs: open_ctree failed

I compiled the latest btrfs-progs-unstable and tried btrfsck:

root@tesla:/root/btrfs-progs-unstable# ./btrfsck /dev/sdb1
parent transid verify failed on 408626470912 wanted 111124 found 111474
parent transid verify failed on 408626470912 wanted 111124 found 111474
parent transid verify failed on 408626470912 wanted 111124 found 111474
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)'
failed.
Abgebrochen

root@tesla:/root/btrfs-progs-unstable# ./btrfsck -s 1 /dev/sdb1
using SB copy 1, bytenr 67108864
parent transid verify failed on 408626470912 wanted 111124 found 111474
parent transid verify failed on 408626470912 wanted 111124 found 111474
parent transid verify failed on 408626470912 wanted 111124 found 111474
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)'
failed.
Abgebrochen

root@tesla:/root/btrfs-progs-unstable# ./btrfsck -s 2 /dev/sdb1
using SB copy 2, bytenr 274877906944
parent transid verify failed on 408626470912 wanted 111124 found 111474
parent transid verify failed on 408626470912 wanted 111124 found 111474
parent transid verify failed on 408626470912 wanted 111124 found 111474
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)'
failed.
Abgebrochen


root@tesla:/root/btrfs-progs-unstable# ./btrfs filesystem show /dev/sdb1
failed to read /dev/sr0
Label: none  uuid: d4bd7a05-ff76-4684-ba4d-e1f48acfd6cc
        Total devices 1 FS bytes used 544.12GB
        devid    1 size 931.51GB used 547.79GB path /dev/sdb1

Btrfs v0.19-36-g70c6c10

The data on this filesystem is not important, though it would be nice if
i could regain access to it. Is there anything I can try to salvage it?

thanks

Robert
