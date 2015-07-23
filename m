Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:35409 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbbGWTMk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 15:12:40 -0400
Received: by lahh5 with SMTP id h5so908228lah.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2015 12:12:38 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Jul 2015 19:12:38 +0000
Message-ID: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
Subject: INFO: task btrfs-transacti:204 blocked for more than 120 seconds.
 (more like 8+min)
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Up to date Arch.  linux kernel 4.1.2-2.  Fresh O/S install 12 days
ago.  No where near full - 34G used on a 4.6T drive.   32GB memory.

Installed bonnie++ 1.97-1.

$ bonnie++ -d bonnie -m btrfs-disk -f -b

I started trying to run with a "-s 4G" option, to use 4GB files for
performance measuring.  It refused to run, and said "file size should
be double RAM for good results".  I sighed, removed the option, and
let it run, defaulting to **64GB files**.  So, yeah, big files.  But,
I do work with Photoshop .PSB files that get that large.

During the first two lines ("Writing intelligently..." and
"Rewriting..." the filesystem seems to be completely locked out for
anything other than bonnie++.  KDE stops being able to switch focus,
change tasks.  Can switch to tty's and log in, do things like "ls",
but attempting to write to the filesystem hangs.  Can switch back to
KDE, but screen is black with cursor until bonnie++ completes.  top
didn't show excessive CPU usage.

My dmesg is at http://www.pastebin.ca/3072384  Attaching it seemed to
make the message not go out to the list.

Yes, my kernel is tained... See "[5.310093] nvidia: module license
'NVIDIA' taints kernel."  Sigh, it's just that the nvidia module
license isn't GPL...

During later bonnie++ writing phases (start 'em", "Create files in
sequential order...", "Create files in random order") show no
detrimental effect on the system.

I see some 1.5+ year old references to messages like "INFO: task
btrfs... blocked for more than 120 seconds."  With the amount of
development since then, figured I'd pretty much ignore those and bring
up the issue again.

I think the "Writing intelligently" phase is sequential, and the old
references I saw were regarding many re-writes sporadically in the
middle.

What I did see from years ago seemed to be that you'd have to disable
COW where you knew there would be large files.  I'm really hoping
there's a way to avoid this type of locking, because I don't think I'd
be comfortable knowing a non-root user could bomb the system with a
large file in the wrong area.

IF I do HAVE to disable COW, I know I can do it selectively.  But, if
I did it everywhere... Which in that situation I would, because I
can't afford to run into many minute long lockups on a mistake... I
lose compression, right?  Do I lose snapshots?  (Assume so, but hope
I'm wrong.)  What else do I lose?  Is there any advantage running
btrfs without COW anywhere over other filesystems?

How would one even know where the division is between a file small
enough to allow on btrfs, vs one not to?

=======
bonnie++ -d bonnie -m kvm-one-disk -f -b
Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version  1.97       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
kvm-one-disk    63G           204281   8 80195   6           239780
10 197.7   5
Latency                       15369us    8649ms               358ms    1153ms
Version  1.97       ------Sequential Create------ --------Random Create--------
kvm-one-disk        -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16    17   8 +++++ +++    31  15    18   6 +++++ +++    26  25
Latency              1450ms     198us     666ms     932ms     170us    1366ms
1.97,1.97,kvm-one-disk,1,1437620483,63G,,,,204281,8,80195,6,,,239780,10,197.7,5,16,,,,,17,8,+++++,+++,31,15,18,6,+++++,+++,26,25,,15369us,8649ms,,358ms,1153ms,1450ms,198us,666ms,932ms,170us,1366ms
