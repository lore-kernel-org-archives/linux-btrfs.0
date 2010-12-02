From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Fsck, parent transid verify failed
Date: Thu, 02 Dec 2010 16:50:42 -0500
Message-ID: <1291326502-sup-1726@think>
References: <003501cb9147$09197540$1b4c5fc0$@gmail.com> <1291306826-sup-7837@think> <AANLkTim5-5KQ3_sEb9WY+O1Uj36=3M3i_yQKeuSb7Qe5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tommy Jonsson <quazzie@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTim5-5KQ3_sEb9WY+O1Uj36=3M3i_yQKeuSb7Qe5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tommy Jonsson's message of 2010-12-02 16:45:39 -0500:
> I can't remember if i used -m raid0.
> I think i just used "mkfs.btrfs /dev/sda" then "btrfs device add /dev/sdb"
> and same for sdc.
> I am sure that i didn't explicitly use -m raid1 or raid10.
> Is there a way that i can check this ?

The defaults will maintain raid1 as you add more drives.  We can check
it with btrfs-debug-tree from the git repository.  But, more below.

> 
> If i do have raid0 for both metadata and data is there anything i can do ?
> I've been looking at the source but haven't got my head around it yet.
> 
> What whould happen if i just ignore/bypass the transid error?
> 
> The error:
> [265889.197279] device fsid 734a485d12c77872-9b0b5aa408670db4 devid 3
> transid 39651 /dev/sda
> [265889.198266] btrfs: use compression
> [265889.647817] parent transid verify failed on 2721514774528 wanted 39651
> found 39649
> [265889.672632] btrfs: open_ctree failed
> 
> Or could i update the metadata to want 39649 ?

The first thing I would try is:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git

Build the latest tools, then:

btrfsck -s 1 /dev/xxx
btrfsck -s 2 /dev/xxx

If either of these work we have an easy way to get it mounted.  Just let
me know.

-chris
