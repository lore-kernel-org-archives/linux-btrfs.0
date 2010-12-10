From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Fsck, parent transid verify failed
Date: Fri, 10 Dec 2010 15:11:17 -0500
Message-ID: <1292011722-sup-5780@think>
References: <003501cb9147$09197540$1b4c5fc0$@gmail.com> <1291306826-sup-7837@think> <AANLkTim5-5KQ3_sEb9WY+O1Uj36=3M3i_yQKeuSb7Qe5@mail.gmail.com> <1291326502-sup-1726@think> <loom.20101209T171330-48@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tom Kuther <kuther@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <loom.20101209T171330-48@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tom Kuther's message of 2010-12-09 11:21:03 -0500:
> Chris Mason <chris.mason <at> oracle.com> writes:
> 
> > [...]
> > Build the latest tools, then:
> > 
> > btrfsck -s 1 /dev/xxx
> > btrfsck -s 2 /dev/xxx
> > 
> > If either of these work we have an easy way to get it mounted.  Just let
> > me know.
> > 
> 
> Hello,
> 
> I get those "parent transid verify failed" errors too after a system failure.
> 
> # btrfsck -s 1 /dev/md0 
> using SB copy 1, bytenr 67108864
> found 1954912653312 bytes used err is 0
> total csum bytes: 1892054684
> total tree bytes: 3455627264
> total fs tree bytes: 1082691584
> btree space waste bytes: 584155173
> file data blocks allocated: 12808940421120
>  referenced 1933520879616
> Btrfs v0.19-35-g1b444cd-dirty
> # btrfsck -s 2 /dev/md0 
> using SB copy 2, bytenr 274877906944
> found 1954912653312 bytes used err is 0
> -snip-
> 
> Both seem to work.
> What would be the steps to get it mounted?

If btrfsck -s is able to find a good super, I've setup a tool that will
copy the good super over into the default super.  It is currently
sitting in the next branch of the btrfs-progs-unstable repo.

git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git next

(or git pull into your existing checkout)

Then

make btrfs-select-super
./btrfs-selects-super -s 1 /dev/xxx

After this you'll want to do a full backup and make sure things are
working properly.

-chris
