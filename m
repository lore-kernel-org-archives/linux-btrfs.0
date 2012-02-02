From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Thu, 2 Feb 2012 11:19:07 +0000 (UTC)
Message-ID: <pan.2012.02.02.11.19.06@cox.net>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx>
	<fgdov8-ord.ln1@hurikhan.ath.cx> <51epv8-2qu.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Thu, 02 Feb 2012 04:54:45 +0100 as excerpted:

> Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:
> 
>> Interestingly, the filesystem was not unmountable - system hung. After
>> reisub and checking again with "btrfs scrub" no errors where reported
>> and it just rsync'ed fine this time. This does not make sense to me.
> 
> btrfsck still shows a lot of errors, while scrubbing says everything is
> okay... *sigh
> 
> Now, how should one fix it if there is still no repair utility? I'm
> pretty sure sooner or later I will run into a BUG_ON again...

I had hoped someone else better qualified would answer, and they may 
still do so, but in the meantime, a couple notes...

1) This is unfortunately quite handwavy as I don't understand the details 
myself, but if I'm reading the list right, there's a known "phantom ENOSPC 
bug" that some are hitting when trying to write a large file (gigs, think 
dvd image), or do an rsync of several gigs, or...  It may be that you hit 
it, and on retry, enough of the file was already there that it didn't 
trigger the second time around.

I gather they've not traced what is apparently a timeout or race 
condition fully and are working on a temporary throttling-based 
workaround.  That's supposed to work for the time being, but it's only a 
workaround, and the throttling controls themselves are apparently rather 
rough at this point, so part of the testing is to make it a bit easier 
for ordinary users without the esoteric knowledge of a btrfs dev to use.  

So there's a short-to-medium-term workaround coming and a longer term 
fix, once they trace down the problem itself.  Meanwhile, don't be too 
worried about ENOSPC errors the occur under heavy write load and that go 
away on retry, as there's apparently others having the same issue.

2) Just a couple days ago I read an article that claimed Oracle has a Feb 
16 deadline for a working btrfsck as that's the deadline for getting it 
in their next shipping Unbreakable Linux release.  I won't claim to know 
if the article is correct or not, but if so, a reasonably working btrfsck 
should be available within two weeks. =:^)  Of course it may continue to 
improve after that...

Meanwhile, there's a tool already available that should allow retrieving 
the undamaged data off of unmountable filesystems, at least, and there's 
another tool that allows rollback to an earlier root node if necessary, 
thus allowing recovery of most filesystems at the cost of losing the last 
few seconds of work.  Given the experimental nature of btrfs and the 
known lack of a proper btrfsck at this point anyway, that's... actually 
quite reasonable, and the reason I decided it was time to start checking 
out btrfs myself (I'm still researching but have been on the list about a 
week now and had read a couple weeks worth of posts before I responded to 
anything).

Don't ask me what the names of those tools are.  I could certainly look 
them up, but so can you, now that you know they exist. =:^) (assuming you 
didn't before, of course.)

Hopefully that's somewhat helpful in pointing you in the right direction, 
at least. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

