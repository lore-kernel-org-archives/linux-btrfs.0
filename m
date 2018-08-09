Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f170.google.com ([209.85.210.170]:46671 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbeHIJx4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 05:53:56 -0400
Received: by mail-pf1-f170.google.com with SMTP id u24-v6so2404322pfn.13
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Aug 2018 00:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$b5a07$5993c1bb$cc37f579$529a3aaa@cox.net>
References: <CAP-4mcAfmp-rCrr5_-TJL4HNz8tVi5kpsOo-8WkZNRLRPOgD=g@mail.gmail.com>
 <pan$b5a07$5993c1bb$cc37f579$529a3aaa@cox.net>
From: Marijn Stollenga <m.stollenga@gmail.com>
Date: Thu, 9 Aug 2018 09:30:23 +0200
Message-ID: <CAP-4mcDEscL+sajfcBgkDehBhnqXPVrOviL-MMHdxtqBa6ioJw@mail.gmail.com>
Subject: Re: recover broken partition on external HDD
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply!

Indeed I should back up more properly, that was actually what I was in
the process of doing but yeah. I'll check out the pointers, and I
guess I'll just read the papers describing the whole btrfs system to
see how it works.
I would like to make an automatic scrubbing application that you can
just point to a block device where partitions are not even correct and
it tries to find as many files as possible.



On 7 August 2018 at 00:40, Duncan <1i5t5.duncan@cox.net> wrote:
> Marijn Stollenga posted on Sat, 04 Aug 2018 12:14:44 +0200 as excerpted:
>
>> Hello btrfs experts, I need your help trying to recover an external HDD.
>> I accidentally created a zfs partition on my external HD, which of
>> course screw up the whole partition. I quickly unplugged it and it being
>> a 1TB drive is assume there is still data on it.
>
> Just a user and list regular here, not a dev, so my help will be somewhat
> limited, but as I've seen no other replies yet, perhaps it's better than
> nothing...
>
>> With some great help on IRC I searched for tags using grep and found
>> many positions:
>> https://paste.ee/p/xzL5x
>>
>> Now I would like to scan all these positions for their information and
>> somehow piece it together, I know there is supposed to be a superblock
>> around 256GB but I'm not sure where the partition started (the search
>> was run from a manually created partition starting at 1MB).
>
> There's a mention of the three superblock copies and their addresses in
> the problem FAQ (wrapped link due to posting-client required hoops I
> don't want to jump thru to post it properly ATM, unwrap manually):
>
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#What_if_I_don.
> 27t_have_wipefs_at_hand.3F
>
>> In general I would be happy if someone can point me to a library that
>> can do low level reading and piecing together of these pieces of meta
>> information and see what is left.
>
> There are multiple libraries in various states available, but being more
> a sysadmin than a dev I'd consume them as dependencies of whatever app I
> was installing that required them, so I've not followed the details.
> However, here's a bit of what I found just now with a quick look:
>
> The project ideas FAQ on the wiki has a (somewhat outdated) library entry
> (wrapped link...):
>
> https://btrfs.wiki.kernel.org/index.php/
> Project_ideas#Provide_a_library_covering_.27btrfs.27_functionality
>
> That provides further links to a couple python projects as well as a
> haskell lib.
>
> But I added the "somewhat dated" parenthetical due to libtrfsutil by Omar
> Sandoval, which appeared in btrfs-progs 4.16.  So there's now an official
> library. =:^)  Tho not being a dev I've not the foggiest whether it'll
> provide the functionality you're after.
>
> I also see a rust lib mentioned on-list (Oct 2016).
>
> https://gitlab.wellbehavedsoftware.com/well-behaved-software/rust-btrfs
>
>> I know there is btrfs-check etc. but these need the superblock to be
>> known. Also on another messed up drive (I screwed up two btrfs drives in
>> the same way at the same time) I was able to find the third superblock,
>> but it seems they in the end pointed to other parts in the file system
>> in the beginning of the drive which were broken.
>
> OK, this may seem like rubbing salt in the wound ATM, but there's a
> reason they did that back in the day before modern disinfectants, it
> helped stop infection before it started.  Likewise, the following policy
> should help avoid the problem in the first place.
>
> A sysadmin's first rule of data value and backups is that the real value
> placed on data isn't defined by arbitrary claims, but rather by the
> number and quality of backups those who control that data find it
> worthwhile to make of it.  If it's worth a lot, there will be multiple
> backups, likely stored in multiple locations, some offsite in ordered to
> avoid loss in the event of fire/flood/bombing/etc.  Only data that's of
> trivial value, less than that of the time/trouble/resources necessary to
> do that backup, will have no backup at all.
>
> (Of course, age of backups is simply a sub-case of the above, since in
> that case the data in question is simply the data in the delta between
> the last backup and the current working state.  By definition, as soon as
> it is considered worth more than the time/trouble/resources necessary to
> update the backup, an updated or full new backup will be made.)
>
> (The second rule of backups is that it's not a backup until it has been
> tested to actually be usable under conditions similar to those in which
> the backup would actually be needed.  In many cases that'll mean booting
> to rescue media and ensuring they can access and restore the backup from
> there using only the resources available from that rescue media.  In
> other cases it'll mean booting directly to the backup and ensuring that
> normal operations can resume from there.  Etc.  And if it hasn't been
> tested yet, it's not a backup, only a potential backup still in progress.)
>
> So the above really shouldn't be a problem at all, because you either:
>
> 1) Defined the data as worth having a backup, in which case you can just
> restore from it,
>
> OR
>
> 2) Defined the data as of such limited value that it wasn't worth the
> hassle/time/resources necessary for that backup, in which case you saved
> what was of *real* value, that time/hassle/resources, before you ever
> lost the data, and the data loss isn't a big deal because it, by
> definition of not having a backup, can be of only trivial value not worth
> the hassle.
>
> There's no #3.  The data was either defined as worth a backup by virtue
> of having one, and can be restored from there, or it wasn't, but no big
> deal because the time/trouble/resources that would have otherwise gone
> into that backup was defined as more important, and was saved before the
> data was ever lost in the first place.
>
> Thus, while the loss of the data due to fat-fingering (which all
> sysadmins come to appreciate the real risk of, after a few events of
> their own) the placement of that ZFS might be a bit of a bother, it's not
> worth spending huge amounts of time trying to recover, because it was
> either worth having a backup, in which case you simply recover from it,
> or it wasn't, in which case it's not worth spending huge amounts to time
> trying to recover, either.
>
> Of course there's still the pre-disaster weighed risk that something will
> go wrong vs. the post-disaster it DID go wrong, now how do I best get
> back to normal operation question, but in the context of the backups rule
> above resolving that question is more a matter of whether it's most
> efficient to spend a little time trying to recover the existing data with
> no guarantee of full success, or to simply jump directly into the wipe
> and restore from known-good (because tested!) backups, which might take
> more time, but has a (near) 100% chance at recovery to the point of the
> backup.  (The slight chance of failure to recover from tested backups is
> what multiple levels of backups covers for, with the the value of the
> data and the weighed risk balanced against the value of the time/hassle/
> resources necessary to do that one more level of backup.)
>
> So while it might be worth a bit of time to quick-test recovery of the
> damaged data, it very quickly becomes not worth the further hassle,
> because either the data was already defined as not worth it due to not
> having a backup, or restoring from that backup will be faster and less
> hassle, with a far greater chance of success, than diving further into
> the data recovery morass, with ever more limited chances of success.
>
> Live by that sort of policy from now on, and the results of the next
> failure, whether it be hardware, software, or wetware (another fat-
> fingering, again, this is coming from someone, me, who has had enough of
> their own!), won't be anything to write the list about, unless of course
> it's a btrfs bug and quite apart from worrying about your data, you're
> just trying to get it fixed so it won't continue to happen.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
