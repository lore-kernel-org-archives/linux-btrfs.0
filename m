Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:50514 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbaLOGGz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 01:06:55 -0500
Message-ID: <548E7A7A.90505@pobox.com>
Date: Sun, 14 Dec 2014 22:06:50 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Btrfs: get more accurate output in df command.
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>	<548B4117.1040007@inwind.it>	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com> <CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com> <548E377D.6030804@cn.fujitsu.com>
In-Reply-To: <548E377D.6030804@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2014 05:21 PM, Dongsheng Yang wrote:
>
> Does it make sense to you?

I understood what you were saying but it didn't make sense to me...

> As there are 2 complaints for the same change of @size in df, I have to
> say it maybe not so easy to understand.

> Anyone have some suggestion about it?

ABSTRACT:: Stop being clever, just give the raw values. That's what you 
should be doing anyway. There are no other correct values to give that 
doesn't blow someone's paradigm somewhere.

ITEM #1 :: In my humble opinion (ha ha) the size column should never 
change unless you add or remove actual storage. It should approximate 
the raw block size of the device on initial creation, and it should 
adjust to the size changes that happen when you semantically resize the 
filesystem with e.g. btrfs resize.

RATIONALE ::

(1a) The actual definition of size for df is not well defined, so the 
best definition of size is the one that produces the "most useful 
information". IMHO the number I've always wanted to see from df is the 
value SIZE I would supply in order to safely dd the entire filesystem 
from one place to another. That number would be, on a single drive 
filesystem, "total_bytes" from the superblock as scaled by the necessary 
block size etc.

ITEM #2 :: The idea of "blocks used" is iffy as well. In particular I 
don't care how or why those blocks have been used. And almost all 
filesystems have this same issue. If I write a 1GiB file to ext2 my 
blocks used doesn't go down by exactly 1GiB, it goes down by 1GiB plus 
all the indirect indexing blocks needed to reference that 1GiB.

RATIONALE ::

(2a) "Blocks Used" is not, and wasn't particularly meant to be "Blocks 
Used By Data Alone".

(2b) Many filesystems have, historically, per-subtracted the fixed 
overhead of their layout such as removing inode table regions. But the 
it became "stupid" and "anti-helpful" but remained un-redressed when 
advancements were made that let data be stored directly in the inodes 
for small files. So now you can technically fit more data in an EXT* 
filesystem than you could fit in SIZE*BLOCKSIZE bytes. Even before 
compression.

(2c) The "fixed" blocks-used size of BTRFS is technically 
sizeof(SuperBlock)*num_supers. Everything else is up for grabs. Some is, 
indeed, pre-grabbed but so what?

ITEM #3 :: The idea of Blocks Available should be Blocks - BlocksUsed 
and _nothing_ _more_.

RATIONALE ::

(3a) Just like Blocks Used isn't just about blocks used for data, Blocks 
Available isn't about how much more user data can be stuffed into the 
filesystem

(3b) Any attempt to treat Blocks Available as some sort of guarantee 
will be meaningless for some significant number of people and usages.

ITEM #4 :: Blocks available to unprivileged users is pretty "iffy" since 
unprivileged users cannot write to the filesystem. This datum doesn't 
have a "plain reading". I'd start with filesystem total blocks, then 
subtract the total blocks used by all trees nodes in all trees. (e.g. 
Nodes * 0x1000 or whatever node size is) then shave off the N 
superblocks, then subtract the number of blocks already allocated in 
data extents. And you're done.

ITEM #5 :: A plain reading of the comments in the code cry out "stop 
trying to help me make predictions". Just serve up the nice raw numbers.

RATIONALE ::

(5a) We have _all_ suffered under the merciless tyranny of some system 
or another that was being "too helpful to be useful". Once a block of 
code tries to "help you" and enforces that help, then you are doomed to 
suffer under that help. See "Clippy".

(5b) The code has a plain reading. It doesn't say anything about how 
things will be used. "Available" is _available_. If you have chosen to 
use it at a 2x rate (e.g. 200%, e.g. RAID1) or a 1.25 rate (five media 
in RAID5) or an N+2/N rate (e.g. RAID6), or a 4x rate (RAID10)... well 
that was your choice.

(5c) If your metadata rate is different than your data rate, then there 
is _absolutely_ no way to _programatically_ predict how the data _might_ 
be used, and this is the _default_ usage model. Literally the hardest 
model is the normal model. There is actually no predictive solution. So 
why are we putting in predictions at all when they _must_ be wrong.

            struct statfs {
                __SWORD_TYPE f_type;    /* type of filesystem (see below) */
                __SWORD_TYPE f_bsize;   /* optimal transfer block size */
                fsblkcnt_t   f_blocks;  /* total data blocks in 
filesystem */
                fsblkcnt_t   f_bfree;   /* free blocks in fs */
                fsblkcnt_t   f_bavail;  /* free blocks available to
                                           unprivileged user */
                fsfilcnt_t   f_files;   /* total file nodes in filesystem */
                fsfilcnt_t   f_ffree;   /* free file nodes in fs */
                fsid_t       f_fsid;    /* filesystem id */
                __SWORD_TYPE f_namelen; /* maximum length of filenames */
                __SWORD_TYPE f_frsize;  /* fragment size (since Linux 
2.6) */
                __SWORD_TYPE f_spare[5];
            };

The datum provided is _supposed_ to be simple. "total blocks in file 
system" "free blocks in file system".

"Blocks available to unprivileged users" is the only tricky one. Id 
limit that to all unallocated blocks inside data extents and all blocks 
not part of any extent. "Unprivileged users" cannot, after all, actually 
allocate blocks in the various trees even if the system ends up doing it 
for them.

Fortunately (or hopefully) that's not the datum /bin/df usually returns.


SUMMARY ::

No fudge factor or backwards-reasoning is going to satisfy more than 
half the people.

Trying to gestimate the users intentions is impossible. Like all 
filesystems except the most simplistic ones (vfat etc) or read-only ones 
(squashfs), getting any answer "near perfect" is not likely, nor 
particularly helpful.

It's really _not_ the implementors job to guess at how the user is going 
to use the system.

Just as EXT before us didn't bother trying to put in a fudge factor that 
guessed what percentage of files would end up needing indirect blocks, 
we shouldn't be in the business of trying to back-figure cost-of-storage.

The raw numbers are _more_ useful in many circumstances. The raw blocks 
used, for example, will tell me what I need to know for thin 
provisioning on other media, for example. Literally nothing else exposes 
that sort of information.

Just put a prominent notice that the user needs to remember to factor 
their choice of redundancy et al into the numbers.

Noticing that my RAID1 costs two 1k blocks to store 1K of data is 
_their_ _job_ when it comes down to it. That's because we are giving 
"them" insight to the filessytem _and_ the storage management.

Same for the benefits of compression etc.

We can recognize that this is "harder" than some other filesystems 
because, frankly, it is... Once we decided to get into the business of 
fusing the file system with the storage management system we _accepted_ 
that burden of difficulty. Users who never go beyond core usage (single 
data plus "overhead" from DUP metadata) will still get the same numbers 
for their simple case. People who start doing RAID5+1 or whatever 
(assuming our implementation gets that far) across 22 media are just 
going to have to remember to do the math to figure their 10% overhead 
cost when looking at "blocks available" just like I had to do my 
S=N*log(N) estimates while laying out Oracle table spaces on my sun 
stations back in the eighties.

Any "clever" answer to any one model will be wrong for _every_ _other_ 
model.

IN MY HUMBLE OPINION, of course... 8-)


