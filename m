Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:55131 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628AbaLREHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 23:07:35 -0500
Message-ID: <549252FF.10400@pobox.com>
Date: Wed, 17 Dec 2014 20:07:27 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Standards Problems [Was: [PATCH v2 1/3] Btrfs: get more accurate
 output in df command.]
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>	<548B4117.1040007@inwind.it>	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com> <CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com> <548E377D.6030804@cn.fujitsu.com> <548E7A7A.90505@pobox.com> <548E929B.2090203@pobox.com> <548E9B38.9080202@cn.fujitsu.com> <548EABBB.4060204@pobox.com> <548FA762.2070504@pobox.com> <549017E8.7060107@cn.fujitsu.com> <54908D8A.8040101@pobox.com> <54916B39.5080409@cn.fujitsu.com>
In-Reply-To: <54916B39.5080409@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't disagree with the _ideal_ of your patch. I just think that it's 
impossible to implement it without lying to the user or making things 
just as bad in a different way. I would _like_ you to be right. But my 
thing is finding and quantifying failure cases and the entire question 
is full of fail.

This is not an attack on you personally, it's a mismatch between the 
storage and file system paradigms that we've seen first because we are 
the first to really blend the two fairly.

Here is a completely legal BTRFS working set. (it's a little extreme.)


/dev/sda :: '|Sf|Sf|Sp|0f|1f|0p|0p|Mf|Mf|Mp|1p|1.25GiB-unallocated|
/dev/sdb :: '|0f|1f|0p|0p|Mp|1p| 4.75GiB-unalloated               |


Legend
p == partial, about half full.
f == full, or full enough to treat as full.
S == Single allocated chunk
0 == RAID=0 allocated chunk
1 == RAID=1 allocated chunk
M == metadata chunk

History: This filesystem started out on a single drive, then it's 
bounced between RAID-0 and RAID-1 at least twice. The owner has _never_ 
let a conversion finish. Indeed this user has just changed modes a 
couple times.

The current filesystem flag says RAID-1.

But we currently have .5GiB of "single" slack, 2GiB of RAID-0 slack, 
1GiB of RAID-1 slack, 2GiB of space where a total of 1GiB more RIAD1 
extents can be created, and we have 3GiB of space on /dev/sdb that _can_ 
_not_ be allocated. We have room for 1 more metadata extent on each 
drive, but if we allocate two more metadat extents on each drive we will 
burn up 1.25 GiB by reducing it to 0.75GiB.

First, a question.

Will a BTRFS in RAID1 mode add file data to extents that are in other 
modes? That is, will the filesystem _use_ the 2.5GiB of available 
"single" and "RAID0" data? If no, then that's 2.5GiB of "phantom 
consumption" space that insn't "used" but also isn't usable.

The size of the store is 20GiB. The default of 2x10GiB you propose would 
be 10GiB. But how do you identify the 3GiB "missing" because of the 
lopsided allocation history?

Seem unlikely? The rotten cod example I've given is unlikely.

But a more even case is downright common and likely. Say you run a nice 
old-fashoned MUTT mail-spool. "most" of your files are small enough to 
live in metadata. You start with one drive. and allocate 2 single-data 
and 10 metatata (5xDup). Then you add a second drive of equal size. (the 
metadata just switched to DUP-as-RAID1-alike mode) And then you do a 
dconvert=raid0.

That uneven allocation of metadata will be a 2GiB difference between the 
two drives forever.

So do you shave 2GiB off of your @size?
Do you shave @2GiB off your @available?
Do you overreport your available by @2GiB and end up _still_ having 
things "available" when you get your ENOSPC?

How about this ::

/dev/sda == |Sf|Sf|Mf|Mf|Mf|Mf|Sf|Sf|Sp|Mp|Mp| .5GiB free|
/dev/sdb == |10 GiB free                                 |

Operator fills his drive, then adds a second one, then _foolishly_ tries 
to convert it to RAID0 when the power fails. In order to check the FS he 
boots with no_balance. Then his maintenance window closes and he has to 
go back into production, at which point he forgets (or isn't allowed) to 
do the balance. The flags are set but now no more extents can be allocated.

Size is 20GiB, slack is 10.5GiB. Operator is about to get ENOSPACE.


Yes a balance would fix it, but that's not the question.

In the meantime what does your patch report?

Or...

/dev/sda == |Sf|Sf|Mf|Mf|Mf|Mf|Sf|Sf|Sp|Mp|Mp| .5GiB free|
/dev/sdb == |10 GiB free                                 |
/dev/sdc == |10 GiB free                                 |

Does a -dconvert=raid5 and immediately gets ENOSPC for all the blocks. 
According to the flags we've got 10GiB free...

Or we end up with an egregious metadata history from lots of small files 
and we've got a perfectly fine RAID1 with several GiB of slack but none 
of that slack is 1GiB contiguous. All the slack has just come from 
reclaiming metadata.

/dev/sda == |Sf|Sf|Mp|Mp|Rx|Rx|Mp|Mp|Rx|Rx|Mp|Mp| N-free slack|

(R == reclaimed, e.g. avalable to extent-tree.c for allocation)

We have a 1.5GB of "poisoned" space here; it can hold metadata but not 
data. So is that 1.5 in your @available calculation? How do you mark it 
up as used.

...

And I've been ingoring the Mp(s) completely. What if I've got a good two 
GiB of partial space in the metadata, but that's all I've got. You write 
a file of any size and you'll get ENOSPC even though you've got that 
GiB.  Was it in @size? Is it in @avail?

...

See you keep giving me these examples where the history of the 
filesystem is uniform. It was made a certain way and stayed that way. 
But in real life this sort of thing is going to happen and your patch 
simply report's a _different_ _wrong_ number. A _friendlier_ wrong 
number, I'll grant you that, but still wrong.

