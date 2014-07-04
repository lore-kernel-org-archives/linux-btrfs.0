Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41847 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaGDOZT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 10:25:19 -0400
Date: Fri, 4 Jul 2014 07:24:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org
Message-ID: <20140704142416.GI26932@merlins.org>
References: <20140704011938.GO11539@merlins.org>
 <1937402.nCIA16QR35@xev>
 <53B6486D.9010006@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B6486D.9010006@jp.fujitsu.com>
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your answer. I'll put the conclusion and question at the
top for easier reading:

So, should I understand that
1) I have enough RAM in my system but all of it disappears, apparently
   claimed by the kernel and not released

2) this could be a kernel memory leak in btrfs or somewhere else, there
   is no good way to know
 
If so, in a case like this, is there additional output I can capture to
figure out how the memory is lost and help find out which part of the
kernel is eating the memory without releasing it?
While btrfs is likely to blame, for now it's really just a guess and it
would be good to confirm.


On Fri, Jul 04, 2014 at 03:23:41PM +0900, Satoru Takeuchi wrote:
> >Is there any correlation between such problems and BTRFS operations such as
> >creating snapshots or running a scrub/balance?
> 
> Were you running scrub, Marc?

Yes, I was due to the other problem I was discussing on the list. I
wanted to know if scrub would find any problem (it did not).
I think I'll now try to read every file of every filesystem to see what
btrfs does (this will take a while, that's around 100 million files).

But the last times I had this OOM problem with 3.15.1 it was happening
within 6 hours sometimes, and I was not starting scrub every time the
system booted, so scrub may be partially responsible but it's not the
core problem.
(Also I run scrub on this system every few weeks and it hadn't OOM
crashed inthe past)

> Marc, do you change
> 
>  - software and its setting,
>  - operations,
>  - hardware configuration,
> or any other, just before detecting first OOM?
 
Those are 3 good questions, I asked myself the same thing.
>From what I remember though all I did was going from 3.14 to 3.15.
However this machine has many cronjobs, it does rsyncs to and from
remote systems, it has btrfs send/receive going to and from it, and
snapshots every hour.
Those are not new, but if any of them changed in a small way, I guess
they could trigger bugs.

> You have 8GB RAM and there is plenty of swap space.

Correct.
 
> ===============================================================================
> [90621.895719] 2021665 pages RAM
> ...
> [90621.895718] Free swap  = 15230536kB
> ===============================================================================
> 
> Here are the avaliable memory of for each OOM-killer.
> 
> 1st OOM:
> ===============================================================================
> [90622.074758] Out of memory: Kill process 11452 (mh) score 2 or sacrifice child
> [90622.074760] Killed process 11452 (mh) total-vm:66208kB, anon-rss:0kB, file-rss:872kB
> [90622.425826] rfx-xpl-static invoked oom-killer: gfp_mask=0x200da, order=0, oom_score_adj=0
>                                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> It failed to acquire order=0 (2^0=1) page. So it's not
> kernel-memory-fragmentation case. Since __GFP_IO(0x80) and __GFP_FS(0x80) is
> set in gfp_mask, it can swap out anon/file pages to swap/filesystems to prepare
> free memories.

Thanks for explaining.
 
> [90622.425932] active_anon:57 inactive_anon:92 isolated_anon:0
> [90622.425932]  active_file:987 inactive_file:1232 isolated_file:0
> [90622.425932]  unevictable:1389 dirty:590 writeback:1 unstable:0
> [90622.425932]  free:25102 slab_reclaimable:9147 slab_unreclaimable:30944
> 
> There are few anon/file, in other word, reclaimable pages.
> The system would be almost full of kernel memory.
> As I said, kernel memory leak would happen here.
> 
> [90622.425932]  mapped:771 shmem:104 pagetables:1487 bounce:0
> [90622.425932]  free_cma:0
> [90622.425933] Node 0 DMA free:15360kB min:128kB low:160kB high:192kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15980kB managed:15360kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
> ~~~~~~~~~~~~~~~~~~~~~~
> 
> "all_unreclaimable? == yes" means "page reclaim work do my best
> and there is nothing to do any more".
 
Understood. I moved my question that was here at the top.

Thank you,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
