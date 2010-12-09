From: Tom Kuther <kuther@gmx.de>
Subject: Re: Fsck, parent transid verify failed
Date: Thu, 9 Dec 2010 16:21:03 +0000 (UTC)
Message-ID: <loom.20101209T171330-48@post.gmane.org>
References: <003501cb9147$09197540$1b4c5fc0$@gmail.com> <1291306826-sup-7837@think> <AANLkTim5-5KQ3_sEb9WY+O1Uj36=3M3i_yQKeuSb7Qe5@mail.gmail.com> <1291326502-sup-1726@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason <at> oracle.com> writes:

> [...]
> Build the latest tools, then:
> 
> btrfsck -s 1 /dev/xxx
> btrfsck -s 2 /dev/xxx
> 
> If either of these work we have an easy way to get it mounted.  Just let
> me know.
> 

Hello,

I get those "parent transid verify failed" errors too after a system failure.

# btrfsck -s 1 /dev/md0 
using SB copy 1, bytenr 67108864
found 1954912653312 bytes used err is 0
total csum bytes: 1892054684
total tree bytes: 3455627264
total fs tree bytes: 1082691584
btree space waste bytes: 584155173
file data blocks allocated: 12808940421120
 referenced 1933520879616
Btrfs v0.19-35-g1b444cd-dirty
# btrfsck -s 2 /dev/md0 
using SB copy 2, bytenr 274877906944
found 1954912653312 bytes used err is 0
-snip-

Both seem to work.
What would be the steps to get it mounted?

Thanks in advance.

~thomas


