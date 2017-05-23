Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35172 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764709AbdEWQtO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 12:49:14 -0400
Date: Tue, 23 May 2017 09:49:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20170523164902.tiwtyd4zpgrj7zxw@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org>
 <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
 <20170522013553.hspdrwpmxe5kyoas@merlins.org>
 <20170522163156.5hcuw5tqfavjkmnm@merlins.org>
 <CAJCQCtSO5O7Pi-4oLsZNr6r6PLVEL6EXA6wpWPjBSUKYe9m4Gg@mail.gmail.com>
 <20170522235754.GJ29894@merlins.org>
 <CAJCQCtR52d2EPgEGPNYDMf3zy7vV-5Yud_k3kVFDrb0JD80PKg@mail.gmail.com>
 <fe10e4c5-fa1b-3725-4680-e4daf939dc8c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fe10e4c5-fa1b-3725-4680-e4daf939dc8c@gmail.com>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 23, 2017 at 07:21:33AM -0400, Austin S. Hemmelgarn wrote:
> > Yeah although I have no idea how much swap is needed for it to
> > succeed. I'm not sure what the relationship is to fs metadata chunk
> > size to btrfs check RAM requirement is; but if it wants all of the
> > metadata in RAM, then whatever btrfs fi us shows you for metadata may
> > be a guide (?) for how much memory it's going to want.
>
> I think the in-memory storage is a bit more space efficient than the on-disk
> storage, but I'm not certain, and I'm pretty sure it takes up more space
> when it's actually repairing things.  If I'm doing the math correctly, you
> _may_ need up to 50% _more_ than the total metadata size for the FS in
> virtual memory space.

So I was able to rescue/fix my system by removing a bunch of temporary
data on it, which in turn freed up enough metadata for things to btrfs
check to work again.
The things to check were minor, so they were fixed quickly.

I seem to have been the last person who last edited 
https://btrfs.wiki.kernel.org/index.php/Btrfsck
and it's therefore way out of date :)

I propose the following
1) One dev needs to confirm that as long as you have enough swap, btrfs
check should. Give some guideline of metadatasize to swap size.
Then again I think swap doesn't help, see below


2) I still think there is an issue with either the OOM killer, or btrfs
check actually chewing up kernel RAM. I've never seen any linux system
die in the spectacular ways mine died with that btrfs check, if it were
only taking userspace RAM.
I've filed a bug, because it looks bad:
https://bugzilla.kernel.org/show_bug.cgi?id=195863

Can someone read those better than me? Is it userspace RAM that is missing?
You said that swap would help, but in the dump below, I see:
Free swap  = 15366388kB
so my swap was unused and the system crashed due to OOM anyway.

btrfs-transacti: page allocation stalls for 23508ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
btrfs-transacti cpuset=/ mems_allowed=0
Mem-Info:
active_anon:5274313 inactive_anon:378373 isolated_anon:3590
 active_file:3711 inactive_file:3809 isolated_file:0
 unevictable:1467 dirty:5068 writeback:49189 unstable:0
 slab_reclaimable:8721 slab_unreclaimable:67310
 mapped:556943 shmem:801313 pagetables:15777 bounce:0
 free:89741 free_pcp:6 free_cma:0
Node 0 active_anon:21097252kB inactive_anon:1513492kB active_file:14844kB inactive_file:15236kB unevictable:5868kB isolated(anon):14360kB isolated(file):0kB mapped:2227772kB dirty:20272kB writeback:196756kB shmem:3205252kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:215184 all_unreclaimable? no
Node 0 DMA free:15880kB min:168kB low:208kB high:248kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15972kB managed:15888kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 3201 23768 23768 23768
Node 0 DMA32 free:116720kB min:35424kB low:44280kB high:53136kB active_anon:3161376kB inactive_anon:8kB active_file:320kB inactive_file:332kB unevictable:0kB writepending:612kB present:3362068kB managed:3296500kB mlocked:0kB slab_reclaimable:460kB slab_unreclaimable:668kB kernel_stack:16kB pagetables:7292kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 0 20567 20567 20567
Node 0 Normal free:226664kB min:226544kB low:283180kB high:339816kB active_anon:17935552kB inactive_anon:1513564kB active_file:14524kB inactive_file:14904kB unevictable:5868kB writepending:216372kB present:21485568kB managed:21080208kB mlocked:5868kB slab_reclaimable:34412kB slab_unreclaimable:268520kB kernel_stack:12480kB pagetables:55816kB bounce:0kB free_pcp:148kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 0 0 0 0
Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
Node 0 DMA32: 768*4kB (UME) 740*8kB (UME) 685*16kB (UME) 446*32kB (UME) 427*64kB (UME) 233*128kB (UME) 79*256kB (UME) 10*512kB (UME) 0*1024kB 0*2048kB 0*4096kB = 116720kB
Node 0 Normal: 25803*4kB (UME) 11297*8kB (UME) 947*16kB (UME) 260*32kB (ME) 72*64kB (UM) 15*128kB (UM) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 223844kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
858720 total pagecache pages
49221 pages in swap cache
Swap cache stats: add 62319, delete 13131, find 75/76
Free swap  = 15366388kB
Total swap = 15616764kB
6215902 pages RAM
0 pages HighMem/MovableOnly
117753 pages reserved
4096 pages cma reserved


I'm also happy to modify the wiki to
1) mention that there is a lowmem mode which in turn isn't really useful
for much yet since it won't repair even a trivial thing (seen patches go
around, but not in upstream yet)

2) warn that for now check --repair of a big filesystem will crash your
system in bad ways if you are lacking physical RAM
If that occurs, the only ways out are
a) delete data/free snapshots if corruption is not bad enough to disallow it
b) move the filesystem to machine with more RAM.

What do you think?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
