Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35579 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbFNTir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jun 2015 15:38:47 -0400
Received: by lbbtu8 with SMTP id tu8so42207932lbb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jun 2015 12:38:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 14 Jun 2015 21:38:45 +0200
Message-ID: <CAN8=bazs9GeqtA5+kOoN=MWrtaQQw0+TUxA8jrTfY5ouuqVm+A@mail.gmail.com>
Subject: I_ERR_FILE_EXTENT_DISCOUNT when there are no file extent holes in inode
From: =?UTF-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?=
	<przemyslaw@pawelczyk.it>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I wanted to move and resize /home btrfs partition of my debian jessie
v8.1 (w/ btrfs-tools v3.17) in virtual machine using gparted 0.22.0
after booting from latest SysRescCD 4.5.3 (w/ btrfs-progs v3.19.1).
GParted does fs check before, to make sure that everything is fine,
but it wasn't. There were following errors from `btrfsck`:

checking fs roots
root 5 inode 1521611 errors 100, file extent discount
Found file extent holes:
start: 12288, len:4096
root 5 inode 1521634 errors 100, file extent discount
Found file extent holes:
root 5 inode 1521645 errors 100, file extent discount
Found file extent holes:
start: 8192, len:4096
root 5 inode 1521647 errors 100, file extent discount
Found file extent holes:
start: 8192, len:8192
start: 20480, len:4096
root 5 inode 1521648 errors 100, file extent discount
Found file extent holes:
root 5 inode 1521649 errors 100, file extent discount
Found file extent holes:
...

As you can see not every inode w/ file extent discount error flag has
file extent holes. I'm not sure of exact definition of this error
flag, so cannot tell myself how (ab?)normal it is. I was using this
partition almost daily for almost a year (back then it was debian
testing when installed) and beside occasional VirtualBox hangups
(during rsync from USB), I had no problems at all.

Qu Wenruo's discount file extent hole repairing function landed in
btrfs-progs v3.19, so I couldn't use debian's old btrfsck to improve
the situation, but sysresccd's one was recent enough (and I was
already booted into it), so I went with its `btrfsck --repair`. I got
many 'Fixed discount file extents for inode' messages, but next
`btrfsck` run still reported file extent discount errors. Looking
closely there was some improvement, because 2 inodes were no longer
reported (only one within visible part of the below log dump):

checking fs roots
root 5 inode 1521634 errors 100, file extent discount
Found file extent holes:
root 5 inode 1521645 errors 100, file extent discount
Found file extent holes:
root 5 inode 1521647 errors 100, file extent discount
Found file extent holes:
root 5 inode 1521648 errors 100, file extent discount
Found file extent holes:
root 5 inode 1521649 errors 100, file extent discount
Found file extent holes:
...

I cloned btrfs-progs.git with latest stable v4.0.1, and executed
self-built `btrfsck --repair` from my debian, hoping that maybe there
were some improvements in that department. Sadly no, I got many 'Fixed
discount file extents for inode', but next `btrfsck` revealed same old
file extent discount errors. It looked like flag error is simply not
cleared, so I finally looked into the code.

When I found repair_inode_discount_extent() in cmds-check.c, I though
I've found the bug. I_ERR_FILE_EXTENT_DISCOUNT is cleared only within
while (node) loop, so if there are no file extents hole, it won't be
cleared. So I moved

    if (RB_EMPTY_ROOT(&rec->holes))
        rec->errors &= ~I_ERR_FILE_EXTENT_DISCOUNT;

after the while loop. It must have helped clearing error flag during
`btrfsck --repair`, but rerunning `btrfsck` revealed that there are
still the same file extent discount errors, so apparently they were
reset in some other code path.

I added some debug printf to verify that RB_EMPTY_ROOT(&rec->holes)
was not false (i.e. 0) and other one in maybe_free_inode_rec() after
conditions that lead to setting I_ERR_FILE_EXTENT_DISCOUNT error flag,
to see the values that met the conditions:

    if (rec->nlink > 0 && !no_holes
        && (   rec->extent_end < rec->isize
            || first_extent_gap(&rec->holes) < rec->isize
           )
       )

Rerunning `btrfsck` gave me this new info:

Checking filesystem on /dev/sda7
UUID: 8b889e4c-5dba-43e3-a116-e13874bfb311
!Set discount file extents for inode    1521634 (nlink=1 extent_end=0
        isize=1408       first_extent_gap(holes)=18446744073709551615)
!Set discount file extents for inode    1521645 (nlink=1
extent_end=20480      isize=47496
first_extent_gap(holes)=18446744073709551615)
!Set discount file extents for inode    1521647 (nlink=1
extent_end=36864      isize=37728
first_extent_gap(holes)=18446744073709551615)
!Set discount file extents for inode    1521648 (nlink=1 extent_end=0
        isize=936        first_extent_gap(holes)=18446744073709551615)
!Set discount file extents for inode    1521649 (nlink=1 extent_end=0
        isize=936        first_extent_gap(holes)=18446744073709551615)

(This long number is ((u64)-1)

So extent_end < isize for these bloody inodes.

Now I have a few questions related to my problem.

1. What is the exact meaning of I_ERR_FILE_EXTENT_DISCOUNT nowadays
and are the conditions leading to setting this error flag proper
w.r.t. current btrfs state?

2. How these errors should be fixed?

I guess extending repair_inode_discount_extent() to fiddle with
extents properly, even if there are no file extent holes, will be
required, but I don't have enough btrfs knowledge to do it myself
right now (first time looking into btrfs-related code today). My
moving of error clearing out of the loop was bogus, because real issue
is apparently not fixed then (and clearing within loop can be bogus as
well for the same reason).

Regards.

PS Please CC me when replying, as I'm not on the list.

-- 
Przemysław Pawełczyk
