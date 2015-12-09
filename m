Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50032 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbbLIQgx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 11:36:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6hjW-0000D4-VS
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 17:36:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 17:36:50 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 17:36:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Wed, 9 Dec 2015 16:36:45 +0000 (UTC)
Message-ID: <pan$7e682$345fe6d2$de13162d$f5ac4118@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	<pan$3c463$5dc6ffa1$704b2ca2$141e65cc@cox.net>
	<5667C00B.4010100@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 09 Dec 2015 06:45:47 +0100 as
excerpted:

> On 2015-11-27 00:08, Duncan wrote:
>> Christoph Anton Mitterer posted on Thu, 26 Nov 2015 01:23:59 +0100 as
>> excerpted:
>>> 1) AFAIU, the fragmentation problem exists especially for those files
>>> that see many random writes, especially, but not limited to, big
>>> files. Now that databases and VMs are affected by this, is probably
>>> broadly known in the meantime (well at least by people on that list).
>>> But I'd guess there are n other cases where such IO patterns can
>>> happen which one simply never notices, while the btrfs continues to
>>> degrade.
>> 
>> The two other known cases are:
>> 
>> 1) Bittorrent download files, where the full file size is preallocated
>> (and I think fsynced), then the torrent client downloads into it a
>> chunk at a time.

> Okay, sounds obvious.
> 
>> The more general case would be any time a file of some size is
>> preallocated and then written into more or less randomly, the problem
>> being the preallocation, which on traditional rewrite-in-place
>> filesystems helps avoid fragmentation (as well as ensuring space to
>> save the full file), but on COW-based filesystems like btrfs, triggers
>> exactly the fragmentation it was trying to avoid.

> Is it really just the case when the file storage *is* actually fully
> pre-allocated?
> Cause that wouldn't (necessarily) be the case for e.g. VM images (e.g.
> qcow2, or raw images when these are sparse files).
> Or is it rather any case where, in larger file, many random (file
> internal) writes occur?

It's the second case, or rather, the reverse of the first case, since 
preallocation and fsync, then write into it, is one specific subset case 
of the broader case of random rewrites into existing files.  VM images 
and database files are two other specific subset cases of the same 
broader case superset.

>> arranging to have the client write into a dir with the nocow attribute
>> set, so newly created torrent files inherit it and do rewrite-in-place,
>> is highly recommended.

> At the IMHO pretty high expense of loosing the checksumming :-(
> Basically loosing half of the main functionalities that make btrfs
> interesting for me.

But... as I've pointed out in other replies, in many cases including this 
specific one (bittorrent), applications have already had to develop their 
own integrity management features, because other filesystems didn't 
supply them and the apps simply didn't work reliably without those 
features.

In the bittorrent case specifically, torrent chunks are already 
checksummed, and if they don't verify upon download, the chunk is thrown 
away and redownloaded.

And after the download is complete and the file isn't being constantly 
rewritten, it's perfectly fine to copy it elsewhere, into a dir where 
nocow doesn't apply.  With the copy, btrfs will create checksums, and if 
you're paranoid you can hashcheck the original nocow copy against the new 
checksummed/cow copy, and after that, any on-media changes will be caught 
by the normal checksum verification mechanisms.

Further, at least some bittorrent clients make preallocation an option.  
Here, on btrfs I'd simply turn off that option, rather than bothering 
with nocow in the first place.  That should already reduce fragmentation 
significantly due to the 30-second by default commit frequency, tho there 
will likely still be some fragmentation due to the out-of-order 
downloading.  But either autodefrag or the previously mentioned post-
download recopy should deal with that.

> For databases, will e.g. the vacuuming maintenance tasks solve the
> fragmentation issues (cause I guess at least when doing full vacuuming,
> it will rewrite the files).

If it does full rewrite, it should, provided the freespace itself isn't 
so fragmented that it's impossible to find sufficiently large extents to 
avoid fragmentation.

Of course there's also autodefrag, if the database isn't so busy and/or 
the database files are small enough that the defragging rewrites don't 
trigger bottlenecking, the primary downside risk with autodefrag.

>> The problem is much reduced in newer systemd, which is btrfs aware and
>> in fact uses btrfs-specific features such as subvolumes in a number of
>> cases (creating subvolumes rather than directories where it makes sense
>> in some shipped tmpfiles.d config files, for instance), if it's running
>> on btrfs.

> Hmm doesn't seem really good to me if systemd would do that, cause it
> then excludes any such files from being snapshot.

Of course if the directories are already present due to systemd upgrading 
from non-btrfs-aware versions, they'll remain as normal dirs, not 
subvolumes.  This is the case here.

And of course you can switch them around to dirs if you like, and/or 
override the shipped tmpfiles.d config with your own.

Meanwhile, distros that both ship systemd and offer btrfs as a filesystem 
option (or use it by default), should integrate this setting much as they 
would any other, patching the upstream version in their own packages if 
it's not a reasonable option for their distro.  So for the general case 
of people just using btrfs and systemd because that's what their distro 
does, it should just work, and to the degree that it doesn't, it's a 
distro-level bug, just as it'd be for any other distro-integration bug.

>> For the journal, I /think/ (see the next paragraph) that it now sets
>> the journal files nocow, and puts them in a dedicated subvolume so
>> snapshots of the parent won't snapshot the journals, thereby helping to
>> avoid the snapshot-triggered cow1 issue.

> The same here, kinda disturbing if systemd would decide that on it's
> own, i.e. excluding files from being checksum protected...

... With the same answer.  In the normal distro case, to the degree that 
the integration doesn't work, it's a distro integration issue.

But also, again, systemd provides its own journal file integrity 
management, meaning there's less reason for btrfs to do so as well, and 
the lack of btrfs checksumming on nocow files doesn't matter so much.

So the systemd settings are actually quite sane, and again, to the degree 
that the distro does things differently for their own integration 
purposes, any bugs resulting from such are distro integration bugs, not 
upstream bugs.

Meanwhile, those not using distros to manage such things (or on distros 
such as gentoo, where by design, far more decisions of that nature are 
left to the admin or local policy of the system it's deployed on) should 
by definition be advanced enough to do the research and make their own 
decisions, since that's precisely what they're choosing to do by straying 
from the distro-level integration policy.

>>> So is there any general approach towards this?

>> The general case is that for normal desktop users, it doesn't tend to
>> be a problem, as they don't do either large VMs or large databases,

> Well depends a bit on how one defines the "normal desktop user",... for
> e.g. developers or more "power users" it's probably not so unlikely that
> they do run local VMs for testing or whatever.

Well yes, but that's devs and power users, who by definition are advanced 
enough to do the research necessary and make the appropriate decisions.

The normal desktop user, referred to by some as luser (local user, but 
with the obvious connotation)... generally tends to run their web browser 
and their apps of choice and games... and doesn't want to be bothered 
with details of this nature that the distro should be managing for them 
-- after all, that's what a distro /does/.

>> and small ones such as the sqlite files generated by firefox and
>> various email clients are handled quite well by autodefrag, with that
>> general desktop usage being its primary target.
> Which is however not yet the default...

Distro integration bug! =:^)

> It feels a bit, if there should be some tools provided by btrfs, which
> tell the users which files are likely problematic and should be
> nodatacow'ed

And there very well might be such a tool... five or ten years down the 
road when btrfs is much more mature and generally stabilized, well beyond 
the "still maturing and stabilizing" status of the moment.

>>> And what are the actual possible consequences? Is it just that fs gets
>>> slower (due to the fragmentation) or may I even run into other issues
>>> to the point the space is eaten up or the fs becomes basically
>>> unusable?

>> It's primarily a performance issue, tho in severe cases it can also be
>> a scaling issue, to the point that maintenance tasks such as balance
>> take much longer than they should and can become impractical to run

> hmm so it could in principle also affect other files and not just the
> fragmented ones, right?!

Not really, except that general btrfs maintenance like balance and check 
takes far longer than it otherwise would.

But it can be the case that as filesystem fragmentation levels rise, free-
space itself is fragmented, to the point where files that would otherwise 
not be fragmented as they're created once and never touched again, end up 
fragmented, because there's simply no free-space extents big enough to 
create them in unfragmented, so a bunch of smaller free-space extents 
must be used where one larger one would have been used had it existed.

In that regard, yes, it can affect other files, but it affects them by 
fragmentation, so no, it doesn't affect unfragmented files... to the 
extent that there are any unfragmented files left.

> Are there any problems caused by all this with respect to free space
> fragmentation? And what exactly are the consequences of free space
> fragmentation? ;)

I must have intuited the question as I just answered it, above! =:^)

>> But even without snapshot awareness, with an appropriate program of
>> snapshot thinning (ideally no more than 250-ish snapshots per
>> subvolume, which easily covers a year's worth of snapshots even
>> starting at something like half-hourly, if they're thinned properly as
>> well; 250 per subvolume lets you cover 8 subvolumes with a 2000
>> snapshot total, a reasonable cap that doesn't trigger severe scaling
>> issues) defrag shouldn't be /too/ bad.
>>
>> Most files aren't actually modified that much, so the number of
>> defrag-triggered copies wouldn't be that high.
> Hmm I thought that would only depend on how badly the files are
> fragmented when being snapshot.
> If I make a snapshot, while there are many fragments, and then defrag
> one of them, everything that gets defragmented would be rewritten,
> loosing any ref-links, while files that aren't defragmented would retain
> them.

Yes, but I was talking about repeated defrag.  A single defrag should at 
most double the space usage of a file, if it unreflinks the entire thing.

But if the file is repeatedly modified and repeatedly snapshotted, and if 
autodefrag is /not/ snapshot aware, then worst-case is that every 
snapshot ends up being its own defragged fully un-reflinked copy, 
multiplying the space usage by the number of snapshots kept around!

By limiting the number of snapshots to 250, that already limits the space 
usage multiplication to 250 as well.  (While that may seem high, given 
that we've had people posting with tens or hundreds of thousands of 
snapshots, if autodefrag was breaking reflinks and they had it enabled... 
250X really is already relatively limited!)

But, as I said, most files don't actually get changed that much, so even 
assuming autodefrag isn't snapshot aware, that 250X worst-case is 
relatively unlikely.  In fact, many files are written one and never 
changes, in which case the autodefrag, if necessary at all, will happen 
shortly after write, and there will very likely be only the single copy.  
Others may have a handful, but only 2-10 copies, with more than that 
quite rare on most systems, so space usage will be nothing close to the 
250X worst-case scenario.  It may be bad, but it's strictly limited bad.

And of course that's assuming the worst case, that autodefrag is /not/ 
snapshot-aware.  If it is, then the problem effectively vaporizes 
entirely.

>> Autodefrag is recommended for, and indeed targeted at, general desktop
>> use, where internal-rewrite-pattern database, etc, files tend to be
>> relatively small, quarter to half gig at the largest.

> Hmm and what about mixed-use systems,... which have both, desktop and
> server like IO patterns?

Valid question.  And autodefrag, like most btrfs-specific mount options, 
remains filesystem-global at this point, too, so it's not like you can 
mount different subvolumes, some with autodefrag, some without (tho 
that's a planned future implementation detail).

But, at least personally, I tend to prefer separate filesystems, not 
subvols, in any case, primarily because I don't like having my data eggs 
all in the same filesystem basket and then watching its bottom drop out 
when I find it unmountable!

But the filesystem-global nature of autodefrag and similar mount options, 
tends to encourage the separate filesystem layout as well, as in that 
case you simply don't have to worry, because the server stuff is on its 
own separate btrfs where the autdefrag on the desktop btrfs can't 
interfere with it, as each separate filesystem can have its own mount 
options. =:^)

So that'd be /my/ preferred solution, but I can indeed see it being a 
problem for those users (or distros) that prefer one big filesystem with 
subvolumes, which some do, because then it's all in a single storage pool 
and thus easier to manage.

> btw: I think documentation (at least the manpage) doesn't tell whether
> btrfs defragment -c XX will work on files which aren't fragmented.

It implies it, but I don't believe it's explicit.

The implication is due to the implication that defrag with the compress 
option is effectively compress, in that it rewrites everything it's told 
to compress in that case, of course defragging in the process due to the 
rewrite, but with the primary purpose being the compress, when used in 
that manner.

But, while true (one poster found that out the hard way, when his space 
usage doubled due to snapshot reflink breaking for EVERY file... when he 
expected it to go down due to the compression -- he obviously didn't 
think thru the fact that compression MUST be a rewrite, thereby breaking 
snapshot reflinks, even were normal non-compression defrag to be snapshot 
aware, because compression substantially changes the way the file is 
stored), that's _implied_, not explicit.  You are correct in that making 
it explicit would be clearer.

> Phew... "clearly" may be rather something that differs from person to
> person.
> - A defrag that doesn't work due to scaling issues - well one can
> hopefully abort it and it's as if there simply was no defragmentation.
> - A defrag which breaks up the ref-links, may eat up vast amounts of
> storage that should not need to be "wasted" like this, and you'll never
> get the ref-links back (unless perhaps with dedup).

I addressed this in a reply a few hours ago to a different (I think) 
subthread.


>> I actually don't know what the effect of defrag, with or without
>> recompression, is on same-subvolume reflinks.  If I were to guess I'd
>> say it breaks them too, but I don't know.  If I needed to know I'd
>> probably test it to see... or ask.
> How would you find out? Somehow via space usage?

Yes.  Try it on a file that's large enough (a gig or so should do it 
nicely) to make a difference in the btrfs fi df listing.  Compare before 
and after listings.

> However when one runs e.g. btrfs fi defrag /snapshots/ one would get n
> additional copies (one per snapshot), in the worst case.

Hmm... That would be a

Very.

Bad.

Idea!

>> and having to manually run a balance -dusage=0
> btw: shouldn't it do that particular one automatically from time to
> time? Or is that actually the case now, by what you mentioned further
> below around 3.17?

Yes, (effective, of course it's all kernel side, btrfs balance userspace 
isn't actually called) balance -dusage=0 is automatic now.

>> So at some point, defrag will need at least partially rewritten to be
>> at least somewhat more greedy in its new data chunk allocation.

> Just wanted to ask why defrag doesn't simply allocate some bigger chunks
> of data in advance... ;)

It's possible that's actually how they'll fix it, when they do.

>> Meanwhile, I don't know that anybody has tried this yet, and with both
>> compression and autodefrag on here it's not easy for me to try it, but
>> in theory anyway, if defrag isn't working particularly well, it should
>> be possible to truncate-create a number of GiB-sized files, sync (or
>> fsync each one individually) so they're written out to storage, then
>> truncate each file down to a few bytes, something 0 < size < 4096 bytes
>> (or page size on archs where it's not 4096 by default), so they take
>> only a single block of that original 1 GiB allocation, and sync again.

> a) wouldn't truncate create a sparse file? And would btrfs then really
> allocate chunks for that (would sound quite strange to me), which I
> guess is your goal here?

As I said to my knowledge it hasn't been tried, but AFAIK, truncate, 
followed by sync (or fsync), doesn't do sparse.  I've seen it used for (I 
believe) similar purposes elsewhere, which is why I suggested its use 
here.

But obviously trying it would be the way to find out for sure.  There's a 
reason I added both the "hasn't been tried yet" and "in theory" 
qualifiers...

Of course if truncate doesn't work, catting from /dev/urandom should do 
the trick, as that should be neither sparse nor compressible.  
 
> b) How can one find out wheter defragmentation worked well? I guess with
> filefrag in the compress=no case an not at all in any other?

I recently found out that filefrag -v actually lists the extent byte 
addresses, thus making it possible to manually (or potentially via 
script) whether the 128-KiB compression blocks are contiguous or not.  
Contiguous would mean same extent, even if filefrag doesn't understand 
that yet.

But certainly, filefrag in the uncompressed case is exactly what I had in 
mind.

> Take the LHC Computing Grid for example,...we manage some 100 PiB,
> probably more in the meantime, in many research centres worldwide, much
> of that being on disk and at least some parts of it with no real backups
> anywhere. This may sound stupid, but in reality, one has funding
> constraints and many other reasons that may keep one from having
> everything twice.
> This should especially demonstrate that not everyone has e.g. twice his
> actually used storage just to move the data away, recreate the
> filesystems and move it back (not to talk about any larger downtimes
> that would result from that).

Yeah, the LHC is rather a special case.

Tho to be fair, were I managing data for them or that sort of data set 
where shear size makes backups impractical, I'd probably be at least as 
conservative about btrfs usage as you're sounding, not necessarily in the 
specifics, but simply because while btrfs is indeed stabilizing, I 
haven't had any argument on this list against my oft stated opinion that 
it's not fully stable and mature yet, and won't be for some time.

As such, to date I'd be unlikely to consider btrfs at all for data where 
backups aren't feasible, unless it really is simply throw-away data 
(which from your description isn't the case there), and would be leery as 
well about btrfs usage where backups are available, but simply 
impractical to deal with, due to shear size and data transfer time.

> For quite a while I was thinking about productively using btrfs at our
> local Tier-2 in Munich, but then decided against:

As should be apparent from the above, I basically agree.

I did want to mention that I enjoyed seeing your large-scale description, 
however, as well as your own reasoning for the decisions you have made.  
(Of course it's confirming my own opinion so I'm likely to enjoy it, but 
still...)

> Long story short... this is all fine, when I just play around with my
> notebooks, or my few own servers,... at the worst case I start from
> scratch taking a backup... but when dealing with more systems or those
> where downtime/failure is a much bigger problem, then I think
> self-maintenance and documentation need to get better (especially for
> normal admins, and believe me, not every admin is willing to dig into
> the details of btrfs and understand "all" the curicumstances of
> fragmentation or issues with datacow/nodatacow.

Absolutely, positively, agreed!  There's certainly a place for btrfs at 
its current stability level, but production level on that size of a 
system, really isn't it, unless perhaps you have the resources to do what 
facebook has done and hire Chris Mason. =:^)  (And even there, from what 
I've read, they have reasonably large test deployments and we do 
regularly see patches fixing problems they've found, but I'm not sure 
they're using it on their primary production, yet, tho they may be.)

>> But in terms of your question, the only things I do somewhat regularly
>> are an occasional scrub (with btrfs raid1 precisely so I /do/ have a
>> second copy available if one or the other fails checksum), and mostly
>> because it's habit from before the automatic empty chunk delete code
>> and my btrfs are all relatively small so the room for error is
>> accordingly smaller, keeping an eye on the combination of btrfs fi sh
>> and btrfs fi df,
>> to see if I need to run a filtered balance.

> Speaking of which:
> Is there somewhere a good documentation of what exactly all this numbers
> of show, df, usage and so on tell?

It's certainly in quite a few on-list posts over the years, but now that 
you mention it, I don't believe it's in the wiki or manpages.

I'm starting to go droopy so won't attempt to repeat it in this post, but 
may well do it in a followup, particularly if you ask about it again.

>> Other than that, it's the usual simply keeping up with the backups
> Well but AFAIU it's much more, which I'd count towards maintenance:
> - enabling autodefrag
> - fighting fragmentation (by manually using svols with nodatacow in
>   those cases where necessary, which first need to be determined)
> - enabling notatime, especially when doing snapshots
> - sometimes (still?) the necessity to run balance to reorder block
>   groups,.. okay you said that empty ones are now automatically
>   reclaimed.

I agree with these, but I consider them pretty much one-shot, and thus 
didn't think about them in the context of what I took to be a question 
about routine, which I interpreted as ongoing, maintenance.

Autodefrag I use everywhere, but for VM and DB usecases it'd take some 
research and likely testing.

General anti-fragmentation setup is IMO vital, but one-shot, particularly 
the research, which once done, becomes a part of one's personal knowledge 
base.

Noatime I've been setting for a decade now, since I saw it suggested in 
the reiserfs docs when I was first setting that up, so that's as second-
nature to me now as using mount to mount a filesystem... and using the 
mount and fstab manpages to figure out configuration.  I'd suggest that 
by now, any admin worth their salt should similarly be enabling it on 
principle by default, or be able to explain why not (mutt in the mode 
that needs it, for example) should they be asked.  So while I agree it's 
important, I'm not sure it should be on this list any more than say using 
mount, should be on the list just because it /is/ routine.

Entirely empty block groups are now automatically reclaimed, correct, but 
I just saw today the first posting I've read from someone who didn't 
realize btrfs still doesn't automatically reclaim low-usage blocks, say 
under 10% but not 0, and that those can still get out of balance over 
time, but that with the entirely empty ones reclaimed, it does actually 
take longer to reach that ENOSPC due to lack of unallocated chunks than 
it used to.

So balance can still be necessary, but if it was necessary every month 
before, perhaps every six months to a year is a reasonable balance target 
now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

