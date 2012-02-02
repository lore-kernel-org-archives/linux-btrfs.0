From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Fri, 03 Feb 2012 00:25:51 +0100
Message-ID: <mkirv8-uns.ln1@hurikhan.ath.cx>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx> <fgdov8-ord.ln1@hurikhan.ath.cx> <51epv8-2qu.ln1@hurikhan.ath.cx> <pan.2012.02.02.11.19.06@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you, Duncon...

Duncan <1i5t5.duncan@cox.net> schrieb:

> Kai Krakow posted on Thu, 02 Feb 2012 04:54:45 +0100 as excerpted:
> 
>> Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:
>> 
>>> Interestingly, the filesystem was not unmountable - system hung. After
>>> reisub and checking again with "btrfs scrub" no errors where reported
>>> and it just rsync'ed fine this time. This does not make sense to me.
>> 
>> btrfsck still shows a lot of errors, while scrubbing says everything is
>> okay... *sigh
>> 
>> Now, how should one fix it if there is still no repair utility? I'm
>> pretty sure sooner or later I will run into a BUG_ON again...
> 
> I had hoped someone else better qualified would answer, and they may
> still do so, but in the meantime, a couple notes...

Still I think you gained good insight by reading all those posts. I'm using 
btrfs for a few weeks now and it is pretty solid since 3.2. I've been 
reading the list a few weeks before starting btrfs but only looked at 
articles about corruption and data loss. I started using btrfs when rescue 
tools became available and the most annoying corruption bugs had been fixed. 
But I've been hit by corruption and freezes a few times so I decided to have 
that big usb3 disk which I rsync every now and then using snapshots for 
rollback.

> 1) This is unfortunately quite handwavy as I don't understand the details
> myself, but if I'm reading the list right, there's a known "phantom ENOSPC
> bug" that some are hitting when trying to write a large file (gigs, think
> dvd image), or do an rsync of several gigs, or...  It may be that you hit
> it, and on retry, enough of the file was already there that it didn't
> trigger the second time around.

On my first thought this was my suspicion, too. But otoh there was no ENOSPC 
message, neither in dmesg nor in rsync. Rsync just froze, I was able to kill 
it and my script continued to create a snapshot afterwards and unmount. I 
tried to mount again after btrfsck, it worked fine, I unmounted, system 
hung. I rebooted, scrubbed my two-disk array, no problems, I mounted the 
backup disk again, rsync'ed it, went fine, unmounted. But btrfsck still 
shows the same errors for this disk. *sigh

[...]
> So there's a short-to-medium-term workaround coming and a longer term
> fix, once they trace down the problem itself.  Meanwhile, don't be too
> worried about ENOSPC errors the occur under heavy write load and that go
> away on retry, as there's apparently others having the same issue.

I reported it here in the hope that it helps tracking down the bug or find 
people with similar experiences. Since "only" my backup disk is affected it 
is not a big problem. I can create it from scratch but try not to do it 
until someone guides me in tracking it down a bit. I think btrfs should try 
to fix such corruptions online while using it. From what I've learned here 
this is the long-term target and a working btrfsck should just be a helper 
tool. And the reason for the long delayed btrfsck is that Chris wants to 
have proper online fixing in place first.

At least I can tell this corruption was introduced by bad logic in the 
kernel, and not by some crash. The usb3 disk is solely mounted for the 
purpose of rsync'ing and unmounted all the other times.

> 2) Just a couple days ago I read an article that claimed Oracle has a Feb
> 16 deadline for a working btrfsck as that's the deadline for getting it
> in their next shipping Unbreakable Linux release.  I won't claim to know
> if the article is correct or not, but if so, a reasonably working btrfsck
> should be available within two weeks. =:^)  Of course it may continue to
> improve after that...

Sounds good. I wonder if Chris could tell anything on that point. ;-)

> Meanwhile, there's a tool already available that should allow retrieving
> the undamaged data off of unmountable filesystems, at least, and there's
> another tool that allows rollback to an earlier root node if necessary,
> thus allowing recovery of most filesystems at the cost of losing the last
> few seconds of work.  Given the experimental nature of btrfs and the
> known lack of a proper btrfsck at this point anyway, that's... actually
> quite reasonable, and the reason I decided it was time to start checking
> out btrfs myself (I'm still researching but have been on the list about a
> week now and had read a couple weeks worth of posts before I responded to
> anything).

The tools are btrfs-rescue and btrfs-repair from Josef's btrfs-progs 
available from github.

> Hopefully that's somewhat helpful in pointing you in the right direction,
> at least. =:^)

Well, no real news to me. But it is good having another soul here interested 
in gaining some knowledge. I think btrfs will become a great filesystem.

But if you could provide a link for the Feb 16 deadline I'd be eager to read 
the article.

Regards,
Kai

