Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:53089 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbcGBPHd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 11:07:33 -0400
Subject: Re: Cannot balance FS (No space left on device)
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, ojab // <ojab@ojab.ru>
References: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
 <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
 <CAKzrAgTngBtK+eRGFh75GZ3MmuBKYyjbQXjD_LBhE8J-TuN0yg@mail.gmail.com>
 <575B378E.8050304@mendix.com>
 <CAKzrAgTSnSyNV7KO4ERkH1BohdPEzzwbqGVSx3UhET+5PwUH2g@mail.gmail.com>
 <575B4198.4050803@mendix.com>
 <57d127c6-8362-8d47-79c2-19f60d930858@gmail.com>
Cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <5785a25d-0bf4-53c9-0b85-eb50be140062@mendix.com>
Date: Sat, 2 Jul 2016 17:07:27 +0200
MIME-Version: 1.0
In-Reply-To: <57d127c6-8362-8d47-79c2-19f60d930858@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/13/2016 02:33 PM, Austin S. Hemmelgarn wrote:
> On 2016-06-10 18:39, Hans van Kranenburg wrote:
>> On 06/11/2016 12:10 AM, ojab // wrote:
>>> On Fri, Jun 10, 2016 at 9:56 PM, Hans van Kranenburg
>>> <hans.van.kranenburg@mendix.com> wrote:
>>>> You can work around it by either adding two disks (like Henk said),
>>>> or by
>>>> temporarily converting some chunks to single. Just enough to get some
>>>> free
>>>> space on the first two disks to get a balance going that can fill the
>>>> third
>>>> one. You don't have to convert all of your data or metadata to single!
>>>>
>>>> Something like:
>>>>
>>>> btrfs balance start -v -dconvert=single,limit=10 /mnt/xxx/
>>>
>>> Unfortunately it fails even if I set limit=1:
>>>> $ sudo btrfs balance start -v -dconvert=single,limit=1 /mnt/xxx/
>>>> Dumping filters: flags 0x1, state 0x0, force is off
>>>>   DATA (flags 0x120): converting, target=281474976710656, soft is
>>>> off, limit=1
>>>> ERROR: error during balancing '/mnt/xxx/': No space left on device
>>>> There may be more info in syslog - try dmesg | tail
>>
>> Ah, apparently the balance operation *always* wants to allocate some new
>> empty space before starting to look more close at the task you give it...
> No, that's not exactly true.  It seems to be a rather common fallacy
> right now that balance repacks data into existing chunks, which is
> absolutely false.  What a balance does is to send everything selected by
> the filters through the allocator again, and specifically prevent any
> existing chunks from being used to satisfy the allocation.  When you
> have 5 data chunks that are 20% used and run 'balance -dlimit=20', it
> doesn't pack that all into the first chunk, it allocates a new chunk,
> and then packs it all into that, then frees all the other chunks.  This
> behavior is actually a pretty important property when adding or removing
> devices or converting between profiles, because it's what forces things
> into the new configuration of the filesystem.
>
> In an ideal situation, the limit filters should make it repack into
> existing chunks when specified alone, but currently that's not how it
> works, and I kind of doubt that that will ever be how it works.

I have to disagree with you here, based on what I see happening. Two 
examples will follow, providing some pudding for the proof.

Also, the behaviour of *always* creating a new empty block group before 
starting to work (which makes it impossible to free up space on a fully 
allocated filesystem with balance) got reverted in:

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=cf25ce518e8ef9d59b292e51193bed2b023a32da

This patch is in 4.5 and 4.7-rc, but *not* in 4.6.

Script used to provide block group output, using pyton-btrfs:

-# cat show_block_groups.py
#!/usr/bin/python

from __future__ import print_function
import btrfs
import sys

fs = btrfs.FileSystem(sys.argv[1])
for chunk in fs.chunks():
     print(fs.block_group(chunk.vaddr, chunk.length))

Example 1:

-# uname -a
Linux ichiban 4.5.0-0.bpo.2-amd64 #1 SMP Debian 4.5.4-1~bpo8+1 
(2016-05-13) x86_64 GNU/Linux

-# ./show_block_groups.py /
block group vaddr 86211821568 length 1073741824 flags DATA used 
837120000 used_pct 78
block group vaddr 87285563392 length 33554432 flags SYSTEM used 16384 
used_pct 0
block group vaddr 87319117824 length 1073741824 flags DATA used 
1070030848 used_pct 100
block group vaddr 88392859648 length 1073741824 flags DATA used 
1057267712 used_pct 98
block group vaddr 89466601472 length 1073741824 flags DATA used 
1066360832 used_pct 99
block group vaddr 90540343296 length 268435456 flags METADATA used 
238256128 used_pct 89
block group vaddr 90808778752 length 268435456 flags METADATA used 
226082816 used_pct 84
block group vaddr 91077214208 length 268435456 flags METADATA used 
242548736 used_pct 90
block group vaddr 91345649664 length 268435456 flags METADATA used 
218415104 used_pct 81
block group vaddr 91614085120 length 268435456 flags METADATA used 
223723520 used_pct 83
block group vaddr 91882520576 length 268435456 flags METADATA used 
68272128 used_pct 25
block group vaddr 92150956032 length 1073741824 flags DATA used 
1048154112 used_pct 98
block group vaddr 93224697856 length 1073741824 flags DATA used 
800985088 used_pct 75
block group vaddr 94298439680 length 1073741824 flags DATA used 62197760 
used_pct 6
block group vaddr 95372181504 length 1073741824 flags DATA used 49541120 
used_pct 5
block group vaddr 96445923328 length 1073741824 flags DATA used 
142856192 used_pct 13
block group vaddr 97519665152 length 1073741824 flags DATA used 
102051840 used_pct 10

Now do a balance, to remove the least used block group:

1st terminal:
-# watch -d './show_block_groups.py /'

2nd terminal:
-# btrfs balance start -v -dusage=5 /
Dumping filters: flags 0x1, state 0x0, force is off
   DATA (flags 0x2): balancing, usage=5
Done, had to relocate 1 out of 17 chunks

After:

-# ./show_block_groups.py /
block group vaddr 86211821568 length 1073741824 flags DATA used 
837120000 used_pct 78
block group vaddr 87285563392 length 33554432 flags SYSTEM used 16384 
used_pct 0
block group vaddr 87319117824 length 1073741824 flags DATA used 
1070030848 used_pct 100
block group vaddr 88392859648 length 1073741824 flags DATA used 
1057267712 used_pct 98
block group vaddr 89466601472 length 1073741824 flags DATA used 
1066360832 used_pct 99
block group vaddr 90540343296 length 268435456 flags METADATA used 
236830720 used_pct 88
block group vaddr 90808778752 length 268435456 flags METADATA used 
224100352 used_pct 83
block group vaddr 91077214208 length 268435456 flags METADATA used 
248299520 used_pct 92
block group vaddr 91345649664 length 268435456 flags METADATA used 
218333184 used_pct 81
block group vaddr 91614085120 length 268435456 flags METADATA used 
223117312 used_pct 83
block group vaddr 91882520576 length 268435456 flags METADATA used 
66551808 used_pct 25
block group vaddr 92150956032 length 1073741824 flags DATA used 
1048154112 used_pct 98
block group vaddr 93224697856 length 1073741824 flags DATA used 
800985088 used_pct 75
block group vaddr 94298439680 length 1073741824 flags DATA used 62033920 
used_pct 6
block group vaddr 96445923328 length 1073741824 flags DATA used 
142331904 used_pct 13
block group vaddr 97519665152 length 1073741824 flags DATA used 
152297472 used_pct 14
block group vaddr 98593406976 length 1073741824 flags DATA used 0 used_pct 0

First, the new empty block group is created, after that (using the 
watch) I can see the data from 95372181504 moving into an existing bg at 
97519665152. The empty one is left behind.

Second example:

-# uname -a
Linux mekker 4.7.0-rc4-amd64 #1 SMP Debian 4.7~rc4-1~exp1 (2016-06-20) 
x86_64 GNU/Linux

-# ./show_block_groups.py /
block group vaddr 21630025728 length 33554432 flags SYSTEM used 4096 
used_pct 0
block group vaddr 21663580160 length 268435456 flags METADATA used 
108011520 used_pct 40
block group vaddr 21932015616 length 268435456 flags METADATA used 
171769856 used_pct 64
block group vaddr 22200451072 length 268435456 flags METADATA used 
89567232 used_pct 33
block group vaddr 22468886528 length 1073741824 flags DATA used 
1059094528 used_pct 99
block group vaddr 24616370176 length 1073741824 flags DATA used 
1024077824 used_pct 95
block group vaddr 25690112000 length 1073741824 flags DATA used 
661626880 used_pct 62
block group vaddr 27837595648 length 1073741824 flags DATA used 
824950784 used_pct 77
block group vaddr 28911337472 length 1073741824 flags DATA used 
939896832 used_pct 88
block group vaddr 31058821120 length 1073741824 flags DATA used 
816013312 used_pct 76
block group vaddr 32132562944 length 1073741824 flags DATA used 
984100864 used_pct 92
block group vaddr 33206304768 length 1073741824 flags DATA used 
541122560 used_pct 50
block group vaddr 36427530240 length 268435456 flags METADATA used 
79302656 used_pct 30
block group vaddr 58528366592 length 1073741824 flags DATA used 
579461120 used_pct 54
block group vaddr 69265784832 length 1073741824 flags DATA used 
462090240 used_pct 43
block group vaddr 70339526656 length 1073741824 flags DATA used 
700502016 used_pct 65
block group vaddr 71413268480 length 1073741824 flags DATA used 
255000576 used_pct 24
block group vaddr 72487010304 length 1073741824 flags DATA used 
348327936 used_pct 32
block group vaddr 73560752128 length 1073741824 flags DATA used 
476127232 used_pct 44
block group vaddr 75708235776 length 1073741824 flags DATA used 
301572096 used_pct 28
block group vaddr 76781977600 length 1073741824 flags DATA used 
476241920 used_pct 44
block group vaddr 77855719424 length 1073741824 flags DATA used 
844894208 used_pct 79

Now, let's do a balance that will remove the bg at 71413268480:

-# btrfs balance start -v -dusage=25 .
Dumping filters: flags 0x1, state 0x0, force is off
   DATA (flags 0x2): balancing, usage=25
Done, had to relocate 1 out of 22 chunks

Result:

-# ./show_block_groups.py /
block group vaddr 21630025728 length 33554432 flags SYSTEM used 4096 
used_pct 0
block group vaddr 21663580160 length 268435456 flags METADATA used 
107319296 used_pct 40
block group vaddr 21932015616 length 268435456 flags METADATA used 
175788032 used_pct 65
block group vaddr 22200451072 length 268435456 flags METADATA used 
89026560 used_pct 33
block group vaddr 22468886528 length 1073741824 flags DATA used 
1059090432 used_pct 99
block group vaddr 24616370176 length 1073741824 flags DATA used 
1061240832 used_pct 99
block group vaddr 25690112000 length 1073741824 flags DATA used 
879472640 used_pct 82
block group vaddr 27837595648 length 1073741824 flags DATA used 
824950784 used_pct 77
block group vaddr 28911337472 length 1073741824 flags DATA used 
939896832 used_pct 88
block group vaddr 31058821120 length 1073741824 flags DATA used 
816013312 used_pct 76
block group vaddr 32132562944 length 1073741824 flags DATA used 
984100864 used_pct 92
block group vaddr 33206304768 length 1073741824 flags DATA used 
541122560 used_pct 50
block group vaddr 36427530240 length 268435456 flags METADATA used 
76374016 used_pct 28
block group vaddr 58528366592 length 1073741824 flags DATA used 
579461120 used_pct 54
block group vaddr 69265784832 length 1073741824 flags DATA used 
462090240 used_pct 43
block group vaddr 70339526656 length 1073741824 flags DATA used 
700502016 used_pct 65
block group vaddr 72487010304 length 1073741824 flags DATA used 
348327936 used_pct 32
block group vaddr 73560752128 length 1073741824 flags DATA used 
476127232 used_pct 44
block group vaddr 75708235776 length 1073741824 flags DATA used 
301572096 used_pct 28
block group vaddr 76781977600 length 1073741824 flags DATA used 
476241920 used_pct 44
block group vaddr 77855719424 length 1073741824 flags DATA used 
844886016 used_pct 79

No new empty block group, yay. Data from the 24% filled at 71413268480 
moved into existing block groups 24616370176 and 25690112000.

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
