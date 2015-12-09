Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36947 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbbLIKTy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 05:19:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6bqi-0001jk-GE
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 11:19:52 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 11:19:52 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 11:19:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing recursive fault and parent transid verify failed
Date: Wed, 9 Dec 2015 10:19:41 +0000 (UTC)
Message-ID: <pan$39f4c$4a92c925$153447bf$d623c310@cox.net>
References: <20151207015715.GA13954@alistair-xps13>
	<pan$42653$68e1a3aa$3a4c1c2c$b0e89f8@cox.net>
	<20151207100256.GA6836@alistair-xps13>
	<pan$cb93a$b4f560b9$2dfdbdbc$17d7a835@cox.net>
	<20151207195504.GA9262@alistair-xps13>
	<pan$73edd$edd83c4d$2a373055$4b6032dd@cox.net>
	<20151208223847.GA4419@alistair-xps13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alistair Grant posted on Wed, 09 Dec 2015 09:38:47 +1100 as excerpted:

> On Tue, Dec 08, 2015 at 03:25:14PM +0000, Duncan wrote:
>> Alistair Grant posted on Tue, 08 Dec 2015 06:55:04 +1100 as excerpted:
>> 
>> > On Mon, Dec 07, 2015 at 01:48:47PM +0000, Duncan wrote:
>> >> Alistair Grant posted on Mon, 07 Dec 2015 21:02:56 +1100 as
>> >> excerpted:
>> >> 
>> >> > I think I'll try the btrfs restore as a learning exercise
>> >> 
>> >> Trying btrfs restore is an excellent idea.  It'll make things far
>> >> easier if you have to use it for real some day.
> 
> Thanks again Duncan for your assistance.
> 
> I plugged the ext4 drive I planned to use for the recovery in to the
> machine and immediately got a couple of errors, which makes me wonder
> whether there isn't a hardware problem with the machine somewhere.
> 
> So decided to move to another machine to do the recovery.

Ouch!  That can happen, and if you moved the ext4 drive to a different 
machine and it was fine there, then it's not the drive.

But you didn't say what kind of errors or if you checked SMART, or even 
how it was plugged in (USB or SATA-direct or...).  So I guess you have 
that side of things under control.  (If not, there's some here who know 
quite a bit about that sort of thing...)

> So I'm now recovering on Arch Linux 4.1.13-1 with btrfs-progs v4.3.1
> (the latest version from archlinuxarm.org).
> 
> Attempting:
> 
> sudo btrfs restore -S -m -v /dev/sdb /mnt/btrfs-recover/ ^&1 | tee
> btrfs-recover.log
> 
> only recovered 53 of the more than 106,000 files that should be
> available.
> 
> The log is available at:
> 
> https://www.dropbox.com/s/p8bi6b8b27s9mhv/btrfs-recover.log?dl=0
> 
> I did attempt btrfs-find-root, but couldn't make sense of the output:
> 
> https://www.dropbox.com/s/qm3h2f7c6puvd4j/btrfs-find-root.log?dl=0

Yeah, btrfs-find-root's output deciphering takes a bit of knowledge.  
Between what I had said and the wiki, I was hoping you could make sense 
of things without further help, but...

Well, at least this gets you some practice before you are desperate. =:^)

FWIW, I was really hoping that it would find generation/transid 2308, 
since that's what it was finding on those errors, but that seems to be 
too far back.

OK, here's the thing about transaction IDs aka transids aka generations.  
Normally, it's a monotonically increasing number, representing the 
transaction/commit count at that point.

Taking a step back, btrfs organizes things as a tree of trees, with each 
change cascading up (down?) the tree to its root, and then to the master 
tree's root.  Between this and btrfs' copy-on-write nature, this means 
the filesystem is atomic.  If the system crashes at any point, either the 
latest changes are committed and the master root reflects them, or the 
master root points to the previous consistent state of all the subtrees, 
which is still in place due to copy-on-write and the fact that the 
changes hadn't cascaded all the way up the trees to the master root, yet.

And each time the master root is updated, the generation aka transid is 
incremented by one.  So 3503 is the current generation (see the superblock 
thinks... bit), 3502 the one before that, 3501 the one before that...

The superblocks record the current transid and point (by address, aka 
bytenr) to that master root.

But, because btrfs is copy-on-write, older copies of the master root (and 
the other roots it points to) tend to hang around for awhile.  Which is 
where btrfs-find-root comes along, as it's designed to find all those old 
roots, listing them by bytenr and generation/transid.

In your case, while generation 3361 is current, there's a list going back 
to generation 2497 with only a few (just eyeballing it) missing, then 
2326, and pretty much nothing before that but the REALLY early generation 
2 and 3, which are likely a nearly empty filesystem.

OK, that explains the generations/transids.  There's also levels, which I 
don't clearly understand myself; definitely not well enough to try to 
explain, tho I could make some WAGs but that'd just confuse things if 
they're equally wildly wrong.  But it turns out that levels aren't in 
practice something you normally need to worry much about anyway, so 
ignoring them seems to work fine.

Then, there's bytenrs, the block addresses.  These are more or less 
randomly large numbers, from an admin perspective, but they're very 
important numbers, because this is the number you feed to restore's -t 
option, that tells it which tree root to use.

Put a different way, humans read the generation aka transid numbers; 
btrfs reads the block numbers.  So what we do is find a generation number 
that looks reasonable, and get its corresponding block number, to feed to 
restore -t.


OK, knowing that, you can perhaps make a bit more sense of what those 
transid verify failed messages are all about.  As I said, the current 
generation is 3503.  Apparently, there's a problem in a subtree, however, 
where the last update was gen 3361, but some intervening updates got lost 
and it can only find 2308 (with a couple updated to 2309).

Which is why I had hoped btrfs-find-root would find history going back to 
2308, since while it'll be old, that would bring that subtree back 
online.  But it wasn't to be.  However, it's still possible that 
something a bit newer references that old 2308, and if we're lucky, one 
of those newer generations will indeed give us access to that subtree 
once again, even if it doesn't have the latest changes to it.


OK, so normally, you'd try with the newest generation you can find that 
works, but here, we know we may have to use an older one to get access to 
that out of sync subtree.

So here's what you do.  Pick a generation from the list.  We'll start 
fairly new (high generation number), but go back a few commits, since 
it's obvious the current generation is screwed up.  Somewhat at random, 
I'll say 3480, 20-some generations back.

For generation 3480, find-root says the bytenr aka block is 564199424.

So now feed that into btrfs restore using -t.  We'll also want to use -l, 
to list the subtrees.

btrfs restore -l -t 564199424

What you're looking for there is a complete list of trees.  You want 
(based on the listing I have for a btrfs here) the extent, dev, fs, csum, 
uuid, and data-reloc trees.  If you have subvolumes I think they should 
be listed as well.  (I don't use subvolumes or snapshots here, so I can't 
say for sure.)

If you have a complete list of at least the base trees (forgetting about 
snapshots/subvols for the moment), it's a reasonable candidate to try 
restoring.  If not, try picking a different generation from find-root and 
feeding its block number to restore.

Once you have a good generation candidate based on restore -l, you can 
use restore -S -m -D -t <block> to do a dry run, and see if it seems to 
give you a reasonable number of files or not (tho note that the last time 
I actually used it for real, the actual number of files restored in a 
real run was somewhat more than in the dry run, I think there's some 
stuff the dry run doesn't or possibly can't try that a run for real does, 
but clearly, only a hundred files or so when you're expecting tens of 
thousands isn't a reasonable candidate).  Again, if not, start over with 
another generation pick from find-root, while if the number of files in 
the dry-run seems reasonable, try the real restore without the -D.


Meanwhile, in terms of picking candidate generations, the example one I 
used was reasonably current, but hopefully before whatever was lost in 
the crash.  If that didn't turn out to be the case, I'd try going back 
further, say to generation 3400, then to 3361 and something shortly 
before that, say 3360 and 3350, since 3361 was one of the wanted 
generations in the errors, then 3300, 3000, 2497, and try both of the 
2326s, one of which I'm guessing is an error and thus very bad.  (I 
didn't actually check that your find-root listing listed all of those in 
the middle, I'm simply using them as examples.)

Of course the further back you go (beyond whatever immediate damage), the 
more likely some of the subtree roots have been overwritten, so the more 
likely you'll fail at the restore -l step.

If you go back quite a way and hit a good one, then try coming forward 
again, using the standard bisect method.  If the first set of picks don't 
yield anything reasonable, try some others.

If you try quite a few and nothing seems to be coming up good, then it 
might be time to try using the check and rescue tools to start restoring 
bad trees as necessary.  But I've never gotten to this point and would be 
feeling my own way along as well, so I'm not going to try being the blind 
leading the blind into that.

But given a reasonable backup in any case, by this point you will have at 
least covered the find-root and restore basics, so even if you weren't 
particularly successful with it this time, you do have the backup and 
don't need to be, and you already accomplished your goal of getting some 
practice in case you do end up needing it at some point, and hopefully 
when you actually do need it, the problem will be different and restore 
will work better for you.

But of course, with good backups, you _should_ never find yourself 
actually needing to use this knowledge.  But it's still nice to have 
actually gotten a bit of experience with it, just in case. =:^)

> Simply mounting the drive, then re-mounting it read only, and rsync'ing
> the files to the backup drive recovered 97,974 files before crashing.
> If anyone is interested, I've uploaded a photo of the console to:
> 
> https://www.dropbox.com/s/xbrp6hiah9y6i7s/rsync%20crash.jpg?dl=0
> 
> I'm currently running a hashdeep audit between the recovered files and
> the backup to see how the recovery went.
> 
> If you'd like me to try any other tests, I'll keep the damaged file
> system for at least the next day or so.
> 
> Thanks again for all your assistance,
> Alistair





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

