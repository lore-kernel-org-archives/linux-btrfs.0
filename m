Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f174.google.com ([209.85.208.174]:47069 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbeIPTVt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 15:21:49 -0400
Received: by mail-lj1-f174.google.com with SMTP id 203-v6so10960820ljj.13
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2018 06:58:43 -0700 (PDT)
MIME-Version: 1.0
From: Adrian Bastholm <adrian@javaguru.org>
Date: Sun, 16 Sep 2018 15:58:05 +0200
Message-ID: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
Subject: btrfs problems
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all
Actually I'm not trying to get any help any more, I gave up BTRFS on
the desktop, but I'd like to share my efforts of trying to fix my
problems, in hope I can help some poor noob like me.

I decided to use BTRFS after reading the ArsTechnica article about the
next-gen filesystems, and BTRFS seemed like the natural choice, open
source, built into linux, etc. I even bought a HP microserver to have
everything on because none of the commercial NAS-es supported BTRFS.
What a mistake, I wasted weeks in total managing something that could
have taken a day to set up, and I'd have MUCH more functionality now
(if I wasn't hit by some ransomware, that is).

I had three 1TB drives, chose to use raid, and all was good for a
while, until started fiddling with Motion, the image capturing
software. When you kill that process (my take on it) a file can be
written but it ends up with question marks instead of attributes, and
it's impossible to remove. BTRFS check --repair is not recommended, it
crashes , doesn't fix all problems, and I later found out that my
lost+found dir had about 39G of lost files and dirs.
I spent about two days trying to fix everything, removing a disk,
adding it again, checking , you name it. I ended up removing one disk,
reformatting it, and moving the data there. Now I removed BTRFS
entirely and replaced it with a OpenZFS mirror array, to which I'll
add the third disk later when I transferred everything over.

Please have a look at the console logs. I've been running linux on the
desktop for the past 15 years, so I'm not a noob, but for running
BTRFS you better be involved in the development of it. In my humble
opinion, it's not for us "users" just yet. Not even for power users.

For those of you considering building a NAS without special purposes,
don't. Buy a synology, pop in a couple of drives, and enjoy the ride.


------------
 root  /home/storage/motion/2017-05-24  1  ls -al
ls: cannot access '36-20170524201346-02.jpg': No such file or directory
ls: cannot access '36-20170524201346-02.jpg': No such file or directory
total 4
drwxrwxrwx 1 motion   motion   114 Sep 14 12:48 .
drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
-????????? ? ?        ?          ?            ? 36-20170524201346-02.jpg
-????????? ? ?        ?          ?            ? 36-20170524201346-02.jpg
-rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
root  /home/storage/motion/2017-05-24  1  touch test.raw
 root  /home/storage/motion/2017-05-24  cat /dev/random > test.raw
^C
root  /home/storage/motion/2017-05-24  ls -al
ls: cannot access '36-20170524201346-02.jpg': No such file or directory
ls: cannot access '36-20170524201346-02.jpg': No such file or directory
total 8
drwxrwxrwx 1 motion   motion   130 Sep 14 13:12 .
drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
-????????? ? ?        ?          ?            ? 36-20170524201346-02.jpg
-????????? ? ?        ?          ?            ? 36-20170524201346-02.jpg
-rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
-rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw
 root  /home/storage/motion/2017-05-24  1  cp test.raw
36-20170524201346-02.jpg
'test.raw' -> '36-20170524201346-02.jpg'

 root  /home/storage/motion/2017-05-24  ls -al
total 20
drwxrwxrwx 1 motion   motion   178 Sep 14 13:13 .
drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
-rwxr-xr-x 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxr-xr-x 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxr-xr-x 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
-rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw

 root  /home/storage/motion/2017-05-24  chmod 777 36-20170524201346-02.jpg

 root  /home/storage/motion/2017-05-24  ls -al
total 20
drwxrwxrwx 1 motion   motion   178 Sep 14 13:13 .
drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
-rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw
 root  /home/storage/motion/2017-05-24  unlink 36-20170524201346-02.jpg
unlink: cannot unlink '36-20170524201346-02.jpg': No such file or directory

 root  /home/storage/motion/2017-05-24  1  ls -al
total 20
drwxrwxrwx 1 motion   motion   178 Sep 14 13:13 .
drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
-rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw

 root  /home/storage/motion/2017-05-24  journalctl -k | grep BTRFS
Sep 14 09:41:58 jenna kernel: BTRFS: device label BTRFS Redundant
storage devid 4 transid 348450 /dev/sdd
Sep 14 09:41:58 jenna kernel: BTRFS: device label BTRFS Redundant
storage devid 2 transid 348450 /dev/sdb
Sep 14 09:41:58 jenna kernel: BTRFS: device label BTRFS Redundant
storage devid 3 transid 348450 /dev/sdc
Sep 14 09:41:58 jenna kernel: BTRFS info (device sdc): enabling auto defrag
Sep 14 09:41:58 jenna kernel: BTRFS info (device sdc): disabling disk
space caching
Sep 14 12:52:36 jenna kernel: BTRFS: Transaction aborted (error -2)
Sep 14 12:52:36 jenna kernel: BTRFS: error (device sdc) in
btrfs_rename:9943: errno=-2 No such entry
Sep 14 12:52:36 jenna kernel: BTRFS info (device sdc): forced readonly
Sep 14 13:02:26 jenna kernel: BTRFS error (device sdc): cleaner
transaction attach returned -30
Sep 14 13:03:41 jenna kernel: BTRFS info (device sdc): disk space
caching is enabled
 root  /home/storage/motion/2017-05-24 

 root  ~  btrfs scrub status /home/storage/
scrub status for 72ea6622-5098-4a0f-bea1-9a5e5a325735
        scrub started at Fri Sep 14 13:06:46 2018 and finished after 00:56:35
        total bytes scrubbed: 1.16TiB with 0 errors

 root  /home/storage/motion/2017-05-24  stat 36-20170524201346-02.jpg
  File: 36-20170524201346-02.jpg
  Size: 338             Blocks: 8          IO Block: 4096   regular file
Device: 29h/41d Inode: 12616879    Links: 1
Access: (0777/-rwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2018-09-14 13:13:35.477264025 +0200
Modify: 2018-09-14 13:13:35.477264025 +0200
Change: 2018-09-14 13:14:02.025170343 +0200
 Birth: -

 root  /home/storage/motion/2017-05-24  1  find . -inum 12616879
-exec rm -i {} \;
rm: remove regular file './36-20170524201346-02.jpg'? y
rm: cannot remove './36-20170524201346-02.jpg': No such file or directory

root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24  ls -al
total 20
drwxrwxrwx 1 motion   motion   178 Sep 14 13:13 .
drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jpg
-rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
-rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw
 root  /home/storage/motion/2017-05-24  rm 36-20170524201346-02.jpg
rm: cannot remove '36-20170524201346-02.jpg': No such file or directory

 root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24  rm -f 36-20170524201346-02.jpg
 root  /home/storage/motion/2017-05-24 
... more of the same
 root  /home/storage/motion  rm -rf 2017-05-24/
rm: cannot remove '2017-05-24/': Directory not empty
 root  /home/storage/motion  1  ls -al 2017-05-24/
ls: cannot access '2017-05-24/36-20170524201346-02.jpg': No such file
or directory
ls: cannot access '2017-05-24/36-20170524201346-02.jpg': No such file
or directory
ls: cannot access '2017-05-24/36-20170524201346-02.jpg': No such file
or directory
total 0
drwxrwxrwx 1 motion motion   144 Sep 14 14:25 .
drwxrwxr-x 1 motion adyhasch  60 Sep 14 09:42 ..
-????????? ? ?      ?          ?            ? 36-20170524201346-02.jpg
-????????? ? ?      ?          ?            ? 36-20170524201346-02.jpg
-????????? ? ?      ?          ?            ? 36-20170524201346-02.jpg

 root  ~  btrfs check /dev/sdb
warning, device 3 is missing
warning, device 3 is missing
Checking filesystem on /dev/sdb
UUID: 72ea6622-5098-4a0f-bea1-9a5e5a325735
checking extents
checking free space cache
failed to load free space cache for block group 9998483259392
failed to load free space cache for block group 10388251541504
failed to load free space cache for block group 10483848118272
checking fs roots
root 5 inode 11189411 errors 200, dir isize wrong
        unresolved ref dir 11189411 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
        unresolved ref dir 11189411 index 9477 namelen 24 name
36-20170524201346-02.jpg filetype 1 errors 1, no dir item
root 5 inode 12616877 errors 2000, link count wrong
        unresolved ref dir 11189411 index 9482 namelen 24 name
36-20170524201346-02.jpg filetype 1 errors 1, no dir item
root 5 inode 12616879 errors 2000, link count wrong
        unresolved ref dir 11189411 index 9484 namelen 24 name
36-20170524201346-02.jpg filetype 1 errors 1, no dir item
found 639613362176 bytes used err is 1
total csum bytes: 605048928
total tree bytes: 828735488
total fs tree bytes: 182419456
total extent tree bytes: 18399232
btree space waste bytes: 47806043
file data blocks allocated: 969656111104
 referenced 634590535680


  root  ~  1  btrfs check --repair /dev/sdb
enabling repair mode
warning, device 3 is missing
warning, device 3 is missing
Checking filesystem on /dev/sdb
UUID: 72ea6622-5098-4a0f-bea1-9a5e5a325735
checking extents
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs[0x43e418]
btrfs(btrfs_reserve_extent+0x5c9)[0x4425df]
btrfs(btrfs_alloc_free_block+0x63)[0x44297c]
btrfs(__btrfs_cow_block+0xfc)[0x436636]
btrfs(btrfs_cow_block+0x8b)[0x436bd8]
btrfs[0x43ad82]
btrfs(btrfs_commit_transaction+0xb8)[0x43c5dc]
btrfs[0x4268b4]
btrfs(cmd_check+0x1111)[0x427d6d]
btrfs(main+0x12f)[0x40a341]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7fd7a78002e1]
btrfs(_start+0x2a)[0x40a37a]


 root  ~  1  btrfs check --repair /dev/sdc
enabling repair mode
warning, device 2 is missing
Checking filesystem on /dev/sdc
UUID: 72ea6622-5098-4a0f-bea1-9a5e5a325735
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
reset isize for dir 11189411 root 5
        unresolved ref dir 11189411 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
        unresolved ref dir 11189411 index 9477 namelen 24 name
36-20170524201346-02.jpg filetype 1 errors 1, no dir item
invalid dir item size
Moving file '36-20170524201346-02.jpg' to 'lost+found' dir since it
has no valid backref
Fixed the nlink of inode 12616877
invalid dir item size
Moving file '36-20170524201346-02.jpg.12616879' to 'lost+found' dir
since it has no valid backref
Fixed the nlink of inode 12616879
        unresolved ref dir 11189411 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
        unresolved ref dir 11189411 index 9477 namelen 24 name
36-20170524201346-02.jpg filetype 1 errors 1, no dir item
checking csums
checking root refs
found 639613362176 bytes used err is 0
total csum bytes: 605048928
total tree bytes: 828735488
total fs tree bytes: 182419456
total extent tree bytes: 18399232
btree space waste bytes: 47806043
file data blocks allocated: 969656111104
 referenced 634590535680


  root  ~  251  btrfs check  /dev/sdb
warning, device 3 is missing
warning, device 3 is missing
parent transid verify failed on 9998522662912 wanted 348736 found 348741
parent transid verify failed on 9998522662912 wanted 348736 found 348741
Ignoring transid failure
Couldn't setup extent tree
Couldn't open file system

 root  ~  251  mount /home/storage/
 root  ~  watch btrfs scrub status /home/storage/
 root  ~  ls /home/storage/motion/2017-05-24/
ls: cannot access
'/home/storage/motion/2017-05-24/36-20170524201346-02.jpg': No such
file or directory
36-20170524201346-02.jpg
total 0
drwxrwxrwx 1 motion motion   24 Sep 14 14:25 .
drwxrwxr-x 1 motion adyhasch 60 Sep 14 09:42 ..
-????????? ? ?      ?         ?            ? 36-20170524201346-02.jpg

Back to square one

[12031.946724] BTRFS error (device sdc): cleaner transaction attach returned -30
[19272.100407] BTRFS error (device sdc): bdev /dev/sdb errs: wr 0, rd
0, flush 0, corrupt 0, gen 1
[19272.104100] BTRFS error (device sdc): bdev /dev/sdb errs: wr 0, rd
0, flush 0, corrupt 0, gen 2
[19272.120344] BTRFS error (device sdc): bdev /dev/sdb errs: wr 0, rd
0, flush 0, corrupt 0, gen 3
