Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57545 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbeAXBfR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 20:35:17 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ee9vn-00056C-Tt
        for linux-btrfs@vger.kernel.org; Wed, 24 Jan 2018 02:32:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
Date: Wed, 24 Jan 2018 01:32:39 +0000 (UTC)
Message-ID: <pan$146ab$ccb28e94$94ee37a$841504f0@cox.net>
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
        <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
        <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
        <pan$ef8df$2d463ba0$6a8d2cfc$bcf35f@cox.net> <5A66F475.3010902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ein posted on Tue, 23 Jan 2018 09:38:13 +0100 as excerpted:

> On 01/22/2018 09:59 AM, Duncan wrote:
>> 
>> And to tie up a loose end, xfs has somewhat different design principles
>> and may well not be particularly sensitive to the dirty_* settings,
>> while btrfs, due to COW and other design choices, is likely more
>> sensitive to them than the widely used ext* and reiserfs (my old choice
>> and the basis of my own settings, above).

> Excellent booklike writeup showing how /proc/sys/vm/ works, but I
> wonder, how can you explain why does XFS work in this case?

I can't, directly, which is why I glossed over it so fast above.  I do 
have some "educated guesswork", but that's _all_ it is, as I've not had 
reason to get particularly familiar with xfs and its quirks.  You'd have 
to ask the xfs folks if my _guess_ is anything approaching reality, but 
if you do please be clear that I explicitly said I don't know and that 
this is simply my best guess based on the very limited exposure to xfs 
discussions I've had.

So I'm not experience-familiar with xfs and other than what I've happened 
across in cross-list threads here, know little about it except that it 
was ported to Linux from other *ix.  I understand the xfs port to 
"native" is far more complete than that of zfs, for example.  
Additionally, I know from various vfs discussion threads cross-posted to 
this and other filesystem lists that xfs remains rather different than 
some -- apparently (if I've gotten it right) it handles "objects" rather 
than inodes and extents, for instance.

Apparently, if the vfs threads I've read are to be believed, xfs would 
have some trouble with a proposed vfs interface that would allow requests 
to write out and free N pages or N KiB of dirty RAM from the write 
buffers in ordered to clear memory for other usage, because it tracks 
objects rather than dirty pages/KiB of RAM.  Sure it could do it, but it 
wouldn't be an efficient enough operation to be worth the trouble for 
xfs.  So apparently xfs just won't make use of that feature of the 
proposed new vfs API, there's nothing that says it /has/ to, after all -- 
it's proposed to be optional, not mandatory.

Now that discussion was in a somewhat different context than the 
vm.dirty_* settings discussion here, but it seems reasonable to assume 
that if xfs would have trouble converting objects to the size of the 
memory they take in the one case, the /proc/sys/vm/dirty_* dirty writeback 
cache tweaking features may not apply to xfs, at least in a direct/
intuitive way, either.


Which is why I suggested xfs might not be particularly sensitive to those 
settings -- I don't know that it ignores them entirely, and it may use 
them in /some/ way, possibly indirectly, but the evidence I've seen does 
suggest that xfs may, if it uses those settings at all, not be as 
sensitive to them as btrfs/reiserfs/ext*.

Meanwhile, due to the extra work btrfs does with checksumming and cow, 
while AFAIK it uses the settings "straight", having them out of whack 
likely has a stronger effect on btrfs than it does on ext* and reiserfs 
(with reiserfs likely being slightly more strongly affected than ext*, 
but not to the level of btrfs).

And there has indeed been confirmation on-list that adjusting these 
settings *does* have a very favorable effect on btrfs for /some/ use-
cases.

(In one particular case, the posting was to the main LKML, but on btrfs 
IIRC, and Linus got involved.  I don't believe that lead to the 
/creation/ of the relatively new per-device throttling stuff as I believe 
the patches were already around, but I suspect it may have lead to their 
integration in mainline a few kernel cycles earlier than they may have 
been otherwise.  Because it's a reasonably well known "secret" that the 
default ratios are out of whack on modern systems, it's just not settled 
what the new defaults /should/ be, so in the absence of agreement or 
pressing problem, they remain as they are.  But Linus blew his top as 
he's known to do, he and others pointed the reporter at the vm.dirty_* 
settings tho Linus wanted to know why the defaults were so insane for 
today's machines, and tweaking those did indeed help.  Then a kernel 
cycle or two later the throttling options appeared in mainline, very 
possibly as a result of Linus "routing around the problem" to some 
extent.)


So in my head I have a picture of the possible continuum of vm.dirty_ 
effect that looks like this:

<- weak                         effect                        strong ->

zfs....xfs.....................ext*....reiserfs.................btrfs

zfs, no or almost no effect, because it uses non-native mechanism and is 
poorly adapted to Linux.

xfs, possibly some effect, but likely relatively light, because its 
mechanisms aren't completely adapted to Linux-vfs-native either, and if 
it uses those settings at all it may well be via some indirect 
translation mechanism.

ext* pretty near the center, because it has been the assumed default for 
so long, and because much of the vfs stuff was ext* first and then later 
moved to the generic vfs layer and exposed to other fs to use too.

reiserfs near center also, but a bit more affected because it's a bit 
more complex, while still similar enough to use the settings directly.

btrfs on the strong effect end, because its implementation is quite 
complex and features such as cow and checksumming increase the work it 
must do, but it still works in size-based units (potentially unlike xfs 
which apparently works with objects of varying sizes), so the effect of 
out of adjustment settings is far stronger.


But as I said I have little experience and know little about zfs/xfs, so 
particularly at that end, it's almost entirely extrapolation from 
admittedly thin evidence and very possibly not entirely correct 
conclusions I've drawn from the evidence I've seen, so if you're on xfs 
(or zfs) or it otherwise strongly matters to you, I'd strongly suggest 
double-checking with the xfs folks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

