Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42978 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbbLNGVQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 01:21:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a8MVV-0000ap-1d
	for linux-btrfs@vger.kernel.org; Mon, 14 Dec 2015 07:21:13 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 07:21:13 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 07:21:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Still not production ready
Date: Mon, 14 Dec 2015 06:21:02 +0000 (UTC)
Message-ID: <pan$9174a$2018742f$398dd5e6$c274a59a@cox.net>
References: <8336788.myI8ELqtIK@merkaba> <566E2490.8080905@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 14 Dec 2015 10:08:16 +0800 as excerpted:

> Martin Steigerwald wrote on 2015/12/13 23:35 +0100:
>> Hi!
>>
>> For me it is still not production ready.
> 
> Yes, this is the *FACT* and not everyone has a good reason to deny it.

In the above sentence, I /think/ you (Qu) agree with Martin (and I) that 
btrfs shouldn't be considered production ready... yet, and the first part 
of the sentence makes it very clear that you feel strongly about the 
*FACT*, but the second half of the sentence (after *FACT*) doesn't parse 
well in English, thus leaving the entire sentence open to interpretation, 
tho it's obvious either way that you feel strongly about it. =:^\

At the risk of getting it completely wrong, what I /think/ you meant to 
say is (as expanded in typically Duncan fashion =:^)...

Yes, this is the *FACT*, though some people have reasons to deny it.

Presumably, said reasons would include the fact that various distros are 
trying to sell enterprise support contracts to customers very eager to 
have the features that btrfs provides, and said customers are willing to 
pay for assurances that the solutions they're buying are "production 
ready", whether that's actually the case or not, presumably because said 
payment is (in practice) simply ensuring there's someone else to pin the 
blame on if things go bad.

And the demonstration of that would be the continued fact that people 
otherwise unnecessarily continue to pay rather large sums of money for 
that very assurance, when in practice, they'd get equal or better support 
not worrying about that payment, but instead actually making use of free-
of-cost resources such as this list.


[Linguistic analysis, see frequent discussion of this topic at Language 
Log, which I happen to subscribe to as I find this sort of thing 
interesting, for more commentary and examples of the same general issue: 
http://languagelog.net ]

The problem with the sentence as originally written, is that English 
doesn't deal well with multi-negation, sometimes considering each 
negation an inversion of the previous (as do most programming languages 
and thus programmers), while other times or as read/heard/interpreted by 
others repeated negation may be considered a strengthening of the 
original negation.

Regardless, mis-negation due to speaker/writer confusion is quite common 
even among native English speakers/writers.

The negating words in question here are "not" and "deny".  If you will 
note, my rewrite kept "deny", but rewrote the "not" out of the sentence, 
so there's only one negative to worry about, making the meaning much 
clearer as the reader's mind isn't left trying to figure out what the 
speaker meant with the double-negative (mistake? deliberate canceling out 
of the first negative with the second? deliberate intensifier?)  and thus 
unable to be sure one way or the other what was meant.

And just in case there would have been doubt, the explanation then makes 
doubly obvious what I think your intent was by expanding on it.  Of 
course that's easy to do as I entirely agree.

OTOH if I'm mistaken as to your intent and you meant it the other way... 
well then you'll need to do the explaining as then the implication is 
that some people have good reasons to deny it and you agree with them, 
but without further expansion, I wouldn't know where you're trying to go 
with that claim.


Just in case there's any doubt left of my own opinion on the original 
claim of not production ready in the above discussion, let me be 
explicit:  I (too) agree with Martin (and I think with Qu) that btrfs 
isn't yet production ready.  But I don't believe you'll find many on the 
list taking issue with that, as I think everybody on-list agrees, btrfs 
/isn't/ production ready.  Certainly pretty much just that has been 
repeatedly stated in individualized style by many posters including 
myself, and I've yet to see anyone take serious issue with it.

>> No matter whether SLES 12 uses it as default for root, no matter
>> whether Fujitsu and Facebook use it: I will not let this onto any
>> customer machine without lots and lots of underprovisioning and
>> rigorous free space monitoring.
>> Actually I will renew my recommendations in my trainings to be careful
>> with BTRFS.

... And were I to put money on it, my money would be on every regular on-
list poster 100% agreeing with that. =:^)

>>
>>  From my experience the monitoring would check for:
>>
>> merkaba:~> btrfs fi show /home
>>          Label: 'home'  uuid: […]
>>          Total devices 2 FS bytes used 156.31GiB
>>          devid    1 size 170.00GiB used 164.13GiB path /dev/[path1]
>>          devid    2 size 170.00GiB used 164.13GiB path /dev/[path2]
>>
>> If "used" is same as "size" then make big fat alarm. It is not
>> sufficient for it to happen. It can run for quite some time just fine
>> without any issues, but I never have seen a kworker thread using 100%
>> of one core for extended period of time blocking everything else on the
>> fs without this condition being met.

Astutely observed. =:^)


> And specially advice on the device size from myself:
> Don't use devices over 100G but less than 500G.
> Over 100G will leads btrfs to use big chunks, where data chunks can be
> at most 10G and metadata to be 1G.

Thanks, Qu.  This is the first time I've seen such specifics both in 
terms of the big-chunks trigger (minimum 100 GiB effective usable 
filesystem size) and in terms of how big those big chunks are (10 GiB 
data, 1 GiB metadata).

Filed away for further reference. =:^)
 
> I have seen a lot of users with about 100~200G device, and hit
> unbalanced chunk allocation (10G data chunk easily takes the last
> available space and makes later metadata no where to store)

That does indeed seem to be a reoccurring theme.  Now I know why, and 
where the big-chunks trigger is. =:^)

And to add, while the kernel now does empty-chunk reaping, returning them 
to the unallocated pool, the chances of a 10 GiB chunk being mostly empty 
but still having at least one small extent still locking it in place as 
not entirely empty, and thus not reapable, are obviously going to be at 
least an order of magnitude higher (and in practice likely more, due to a 
likely unlinearly greater share of files being under 10 GiB size than 
under 1 GiB size) than the chances at the 1 GiB chunk size.

> And unfortunately, your fs is already in the dangerous zone.
> (And you are using RAID1, which means it's the same as one 170G btrfs
> with SINGLE data/meta)

That raid1 parenthetical is why I chose the "effective usable filesystem 
size" wording above, to try to word it broadly enough to include all the 
different replication/parity variants.

>> Reported in another thread here that got completely ignored
>> so far. I think I could go back to 4.2 kernel to make this work.
> 
> Unfortunately, this happens a lot of times, even you posted it to mail
> list.
> Devs here are always busy locating bugs or adding new features or
> enhancing current behavior.
> 
> So *PLEASE* be patient about such slow response.

Yes indeed.

Generally speaking, one post/thread alone isn't likely to get the eye of 
a dev unless they happen to be between bug-hunting projects at that 
moment.  But several posts/threads, particularly over a couple kernel 
cycles or from multiple posters, a trend makes, and then it's much more 
likely to catch attention.

> BTW, you may not want to revert to 4.2 until some bug fix is backported
> to 4.2.
> As qgroup rework in 4.2 has broken delayed ref and caused some scrub
> bugs. (My fault)

Good point.  (Tho I never happened to trigger those scrub bugs here, but 
I strongly suspect that's because I both use quite small filesystems, 
well under that 100 GiB effective size barrier mentioned above, and 
relatively fast ssds, so my scrubs are done in under a minute and don't 
tend to be subject to the same sort of IO bottlenecking and races that 
scrubs on spinning rust at 100 GiB plus filesystem sizes tend to be.)

>> I think it got somewhat better. It took much longer to come into that
>> state again than last time, but still, blocking like this is *no*
>> option for a *production ready* filesystem.

Agreed on both counts.  The problem should be markedly better since the 
empty-chunk-reaping went into (IIRC) 3.17, to the point that we're only 
now beginning to see reports of it being triggered again, while 
previously people were seeing it repeatedly, often monthly or more 
frequently.

But it's still not hitting the expectations for a production-ready 
filesystem, but then again, I've yet to see a list regular actually make 
anything like a claim that btrfs is in fact production ready; rather the 
opposite, in fact, and repeatedly.

What distros might be claiming is another matter, but arguably, people 
relying on their claims should be following up by demanding support from 
the distros making them, based on the claims they made.  Meanwhile, on 
this list we're /not/ making those claims and thus cannot reasonably be 
held to them as if we were.

>> I am seriously consider to switch to XFS for my production laptop
>> again. Cause I never saw any of these free space issues with any of the
>> XFS or Ext4 filesystems I used in the last 10 years.
> 
> Yes, xfs and ext4 is very stable for normal use case.
> 
> But at least, I won't recommend xfs yet, and considering the nature or
> journal based fs, I'll recommend backup power supply in crash recovery
> for both of them.
> 
> Xfs already messed up several test environment of mine, and an
> unfortunate double power loss has destroyed my whole /home ext4
> partition years ago.
> 
> [xfs story]
> After several crash, xfs makes several corrupted file just to 0 size.
> Including my kernel .git directory. Then I won't trust it any longer.
> No to mention that grub2 support for xfs v5 is not here yet.
> 
> [ext4 story]
> For ext4, when recovering my /home partition after a power loss, a new
> power loss happened, and my home partition is doomed.
> Only several non-sense files are savaged.

As they say YMMV, but FWIW, despite the stories from the pre-data=ordered-
by-default era, and with the acknowledgment that a single anecdote or 
even a small but unrandomized sampling of anecdotes doesn't a scientific 
study make, I've actually had surprisingly good luck with reiserfs here, 
even on hardware that I had little reason to expect a filesystem to 
actually work reliably on (bad memory incidents, overheated and head-
crashed drive incident where after cooldown I took the mounted at the 
time partitions out of use and successfully and reliably continued to use 
other partitions on the drive, old and burst capacitor and thus power-
unstable mobo incident,... etc, tho not all at once, fortunately!).

ATM I use btrfs on my SSDs but continue to use reiserfs on my spinning 
rust, and FWIW, reiserfs has continued to be as reliable as I'd expect a 
deeply mature and stable filesystem to be, while btrfs... has been as 
occasionally but arguably dependably buggy as I'd expect a still under 
heavy development tho past "experimental", still stabilizing and not yet 
mature filesystem to be.


Tho pre-ordered-by-default era, I remember a few of those 0-size-
truncated files on reiserfs, too.  But the ordered-by-default 
introduction was long in the past even when the 3.0 kernel was new, so is 
pretty well pre-history, by now (which I guess qualifies me as a Linux 
old fogey by now, even if I didn't really get into it to speak of until 
the turn of the century or so, after MS gave me the push by very 
specifically and deliberately shipping malware in eXPrivacy, thus 
crossing a line I was never to cross with them).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

