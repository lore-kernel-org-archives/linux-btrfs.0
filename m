Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37961 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbbKZXIn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 18:08:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a25eY-0007SD-Oh
	for linux-btrfs@vger.kernel.org; Fri, 27 Nov 2015 00:08:38 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 00:08:38 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 00:08:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Thu, 26 Nov 2015 23:08:34 +0000 (UTC)
Message-ID: <pan$3c463$5dc6ffa1$704b2ca2$141e65cc@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Thu, 26 Nov 2015 01:23:59 +0100 as
excerpted:

> Hey.
> 
> I've worried before about the topics Mitch has raised.
> Some questions.
> 
> 1) AFAIU, the fragmentation problem exists especially for those files
> that see many random writes, especially, but not limited to, big files.
> Now that databases and VMs are affected by this, is probably broadly
> known in the meantime (well at least by people on that list).
> But I'd guess there are n other cases where such IO patterns can happen
> which one simply never notices, while the btrfs continues to degrade.

The two other known cases are:

1) Bittorrent download files, where the full file size is preallocated 
(and I think fsynced), then the torrent client downloads into it a chunk 
at a time.

The more general case would be any time a file of some size is 
preallocated and then written into more or less randomly, the problem 
being the preallocation, which on traditional rewrite-in-place 
filesystems helps avoid fragmentation (as well as ensuring space to save 
the full file), but on COW-based filesystems like btrfs, triggers exactly 
the fragmentation it was trying to avoid.

At least some torrent clients (ktorrent at least) have an option to turn 
off that preallocation, however, and that would be recommended where 
possible.  Where disabling the preallocation isn't possible, arranging to 
have the client write into a dir with the nocow attribute set, so newly 
created torrent files inherit it and do rewrite-in-place, is highly 
recommended.

It's also worth noting that once the download is complete, the files 
aren't going to be rewritten any further, and thus can be moved out of 
the nocow-set download dir and treated normally.  For those who will 
continue to seed the files for some time, this could be done, provided 
the client can seed from a directory different than the download dir.

2) As a subcase of the database file case that people may not think 
about, systemd journal files are known to have had the internal-rewrite-
pattern problem in the past.  Apparently, while they're mostly append-
only in general, they do have an index at the beginning of the file that 
gets rewritten quite a bit.

The problem is much reduced in newer systemd, which is btrfs aware and in 
fact uses btrfs-specific features such as subvolumes in a number of cases 
(creating subvolumes rather than directories where it makes sense in some 
shipped tmpfiles.d config files, for instance), if it's running on 
btrfs.  For the journal, I /think/ (see the next paragraph) that it now 
sets the journal files nocow, and puts them in a dedicated subvolume so 
snapshots of the parent won't snapshot the journals, thereby helping to 
avoid the snapshot-triggered cow1 issue.

On my own systems, however, I've configured journald to only use the 
volatile tmpfs journals in /run, not the permanent /var location, 
tweaking the size of the tmpfs mounted on /run and the journald config so 
it normally stores a full boot session, but of course doesn't store 
journals from previous sessions as they're wiped along with the tmpfs at 
reboot.  I run syslog-ng as well, configured to work with journald, and 
thus have its more traditional append-only plain-text syslogs for 
previous boot sessions.

For my usage that actually seems the best of both worlds as I get journald 
benefits such as service status reports showing the last 10 log entries 
for that service, etc, with those benefits mostly applying to the current 
session only, while I still have the traditional plain-text greppable, 
etc, syslogs, from both the current and previous sessions, back as far as 
my log rotation policy keeps them.  It also keeps the journals entirely 
off of btrfs, so that's one particular problem I don't have to worry 
about at all, the reason I'm a bit fuzzy on the exact details of systemd's 
solution to the journal on btrfs issue.

> So is there any general approach towards this?

The general case is that for normal desktop users, it doesn't tend to be 
a problem, as they don't do either large VMs or large databases, and 
small ones such as the sqlite files generated by firefox and various 
email clients are handled quite well by autodefrag, with that general 
desktop usage being its primary target.

For server usage and the more technically inclined workstation users who 
are running VMs and larger databases, the general feeling seems to be 
that those adminning such systems are, or should be, technically inclined 
enough to do their research and know when measures such as nocow and 
limited snapshotting along with manual defrags where necessary, are 
called for.  And if they don't originally, they find out when they start 
researching why performance isn't what they expected and what to do about 
it. =:^)

> And what are the actual possible consequences? Is it just that fs gets
> slower (due to the fragmentation) or may I even run into other issues to
> the point the space is eaten up or the fs becomes basically unusable?

It's primarily a performance issue, tho in severe cases it can also be a 
scaling issue, to the point that maintenance tasks such as balance take 
much longer than they should and can become impractical to run (where the 
alternative starting over with a new filesystem and restoring from 
backups is faster), because btrfs simply has too much bookkeeping 
overhead to do due to the high fragmentation.

And quotas tend to make the scaling issues much (MUCH!) worse, but since 
btrfs quotas are to date generally buggy and not entirely reliable 
anyway, that tends not to be a big problem for those who do their 
research, since they either stick with a more mature filesystem where 
quotas actually work if they need 'em, or don't ever enable them on btrfs 
if they don't actually need 'em.

> This is especially important for me, because for some VMs and even DBs I
> wouldn't want to use nodatacow, because I want to have the checksumming.
> (i.e. those cases where data integrity is much more important than
> security)

In general, nocow and the resulting loss of checksumming on these files 
isn't nearly the problem that it might seem at first glance.  Why?  
Because think about it, the applications using these files have had to be 
usable on more traditional filesystems without filesystem-level 
checksumming for decades, so the ones where data integrity is absolutely 
vital have tended to develop their own data integrity assurance 
mechanisms.  They really had no choice, as if they hadn't, they'd have 
been too unstable for the tasks at hand, and something else would have 
come along that was more stable and thus more suited to the task at hand.

In fact, while I've seen no reports of this recently, a few years ago 
there were a number of reported cases where the best explanation was that 
after a crash, the btrfs level file integrity and the application level 
file integrity apparently clashed, with the btrfs commit points and the 
application's own commit points out of sync, so that while btrfs said the 
file was fine, apparently parts of it were from before an application 
level checkpoint while other parts of it were after, so the application 
itself rejected the file, even tho the btrfs checksums matched.

As I said, that was a few years ago, and I think btrfs' barrier handling 
and fsync log rewriting are better now, such that I've not seen such 
reports in quite awhile.  But something was definitely happening at the 
time, and I think in at least some cases the application alone would have 
handled things better, as then it could have detected the damage and 
potentially replayed its own log or restored to a previous checkpoint, 
the exact same thing it did on filesystems without the integrity 
protections btrfs has.

Since most of these apps already have their own data integrity assurance 
mechanisms, the btrfs data integrity mechanisms aren't such a big deal 
and can in fact be turned off, letting the application layer handle it.  
Instead, where btrfs' data integrity works best is in two cases (1) btrfs 
internal metadata integrity handling, and (2) on the general run of the 
mill file processed by run of the mill applications that don't do their 
own data integrity processing (beyond perhaps a rather minimal sanity 
check, if that) and simply trust the data the filesystem feeds them.  In 
many cases they'd simply process the corrupt data and keep on going, 
while in others they'd crash, but it wouldn't be a big deal, because it'd 
be one corrupt jpeg or a few seconds of garbage in an mp3 or mpeg, and if 
the one app couldn't handle it without crashing, another would.  It 
wouldn't be a whole DB or VM's worth of data, down the drain, as it would 
be for the big apps, the reason the big apps had to implement their own 
data integrity processing.

Plus, the admins running the big, important apps, are much more likely to 
appreciate the value of the admin's rule of backups, if it's not backed 
up, by definition, it's of less value than the time and resources saved 
by not doing that backup, any protests to the contrary not withstanding 
as they simply underline the lie of the words in the face of the 
demonstrated lack of backups and thus by definition, low value of the 
data.

Because checksumming doesn't help you if the filesystem as a whole goes 
bad, or if the physical devices hosting it do so, while backups do!  (And 
the same of course applies to snapshotting, tho they can help with the 
generally worst risk, as any admin worth their salt knows, the admin's 
own fat-fingering!)


In general, then, for the big VMs and DBs, I recommend nocow, on 
dedicated subvolumes so parent snapshotting doesn't interfere, and 
preferably no snapshotting of the dedicated subvolume, if there's 
sufficient down-time to do proper db/vm-atomic backups, anyway.  If not, 
then snapshot at the low end of acceptable frequency for backups, backup 
the snapshot, and erase it.  There will still be some fragmentation due 
to the snapshot-induced cow1 (see discussion under #3 below), but it can 
be controlled, and scheduled defrag can be used to keep it within an 
acceptable range.  Altho defrag isn't snapshot aware, with snapshots only 
taken for backup purposes and then deleted, there won't be snapshots for 
defrag to be aware of, eliminating the potential problems there as well.

Based on posted reports, this sort of approach works well to keep 
fragmentation within manageable levels, while still allowing temporary 
snapshots for backup purposes.


> 2) Why does notdatacow imply nodatasum and can that ever be decoupled?

Hugo covered that.  It's a race issue.  With data rewritten in-place, 
it's no longer possible to atomically update both the data and its 
checksum at the same time, and if there's a crash between updates of the 
two or while one is actually being written...

Which is precisely why checksummed data integrity isn't more commonly 
implemented; on overwrite-in-place, it's simply not race free, so copy-on-
write is what actually makes it possible.  Therefore, disable copy-on-
write and by definition you must disable checksumming as well.

> 3) When I would actually disable datacow for e.g. a subvolume that holds
> VMs or DBs... what are all the implications?
> Obviously no checksumming, but what happens if I snapshot such a
> subvolume or if I send/receive it?
> I'd expect that then some kind of CoW needs to take place or does that
> simply not work?

Snapshots too are cow-based, as they lock in the existing version where 
it's at.  By virtue of necessity, then, first-writes to a block after a 
snapshot cow it, that being a necessary exception to nocow.  However, the 
file retains its nocow attribute, and further writes to the new block are 
now done in-place... until it to is locked in place by another snapshot.

Someone on-list referred to this once as cow1, and that has become a 
common shorthand reference for the process.  In fact, I referred to cow1 
in #1 above, and just now added a parenthetical back up there, referring 
here.

> 4) Duncan mentioned that defrag (and I guess that's also for auto-
> defrag) isn't ref-link aware...
> Isn't that somehow a complete showstopper?
> 
> As soon as one uses snapshot, and would defrag or auto defrag any of
> them, space usage would just explode, perhaps to the extent of ENOSPC,
> and rendering the fs effectively useless.
> 
> That sounds to me like, either I can't use ref-links, which are crucial
> not only to snapshots but every file I copy with cp --reflink auto ...
> or I can't defrag... which however will sooner or later cause quite some
> fragmentation issues on btrfs?

Hugo answered this one too, tho I wasn't aware that autodefrag was 
snapshot-aware.

But even without snapshot awareness, with an appropriate program of 
snapshot thinning (ideally no more than 250-ish snapshots per subvolume, 
which easily covers a year's worth of snapshots even starting at 
something like half-hourly, if they're thinned properly as well; 250 per 
subvolume lets you cover 8 subvolumes with a 2000 snapshot total, a 
reasonable cap that doesn't trigger severe scaling issues) defrag 
shouldn't be /too/ bad.

Most files aren't actually modified that much, so the number of defrag-
triggered copies wouldn't be that high.

And as discussed above, for VM images and databases, the recommendation 
is nocow, and either no snapshotting if there's down-time enough to do 
atomic backups without them, or only temporary snapshotting if necessary 
for atomic backups, with the snapshots removed after the backup is 
complete.  Further, defrag should only be done at a rather lower 
frequency than the temporary snapshotting, so even if a few snapshots are 
kept around, that's only a few copies of the files, nothing like the 
potentially 250-ish snapshots and thus copies of the file, for normal 
subvolumes, were defrag done at the same frequency as the snapshotting.

> 5) Especially keeping (4) in mind but also the other comments in from
> Duncan and Austin...
> Is auto-defrag now recommended to be generally used?
> Are both auto-defrag and defrag considered stable to be used? Or are
> there other implications, like when I use compression

Autodefrag is recommended for, and indeed targeted at, general desktop 
use, where internal-rewrite-pattern database, etc, files tend to be 
relatively small, quarter to half gig at the largest.

> 6) Does defragmentation work with compression? Or is it just filefrag
> which can't cope with it?

It's just filefrag -- which it can be noted isn't a btrfs-progs 
application (it's part of e2fsprogs).  There is or possibly was in fact 
discussion of teaching filefrag about btrfs compression so it wouldn't 
false-report massive fragmentation with it, but that was some time ago 
(I'd guess a couple years), and I've read absolutely nothing on it since, 
so I've no idea if the project was abandoned or indeed never got off the 
ground, or OTOH, if perhaps it's actually already done in the latest 
e2fsprogs.

btrfs defrag works fine with compression and in fact it even has an 
option to compress as it goes, thus allowing one to use it to compress 
files later, if you for instance weren't running the compress mount 
option (or perhaps toggled between zlib and lzo based compression) at the 
time the file was originally written.

And AFAIK autodefrag, because it simply queues affected files for 
defragging rewrite by a background thread, uses the current compress 
mount option just as does ordinary file writing.

> Any other combinations or things with the typicaly btrfs technologies
> (cow/nowcow, compression, snapshots, subvols, compressions, defrag,
> balance) that one can do but which lead to unexpected problems (I, for
> example, wouldn't have expected that defragmentation isn't ref-link
> aware... still kinda shocked ;) )

FWIW, I believe the intent remains to reenable snapshot-aware-defrag 
sometime in the future, after the various scaling issues including 
quotas, have been dealt with.  When the choice is between a defrag taking 
a half hour but not being snapshot aware, and taking perhaps literally 
/weeks/, because the scaling issues really were that bad... an actually 
practical defrag, even if it broke snapshot reflinks, was *clearly* 
preferred to one that was for all practical purposes too badly broken to 
actually use, because it scaled so badly it took weeks to do what should 
have been a half-hour job.

The one set of scaling issues was actually dealt with some time ago.  I 
think now it's primarily the fact that we're on the third quota subsystem 
rewrite and it's still buggy and far from stable, is what's holding up 
further progress on again having a snapshot-aware-defrag.  Once the quota 
code actually stabilizes there's probably some other work to do tying up 
loose ends as well, but my impression is that it's really not even 
possible until the quota code stabilizes.  The only exception to that 
would be if people simply give up on quotas entirely, and there's enough 
demand for that feature that giving up on them would be a *BIG* hit to 
btrfs as the assumed ext* successor, so unless they come up against a 
wall and find quotas simply can't be done in a reliable and scalable way 
on btrfs, the feature /will/ be there eventually, and then I think 
snapshot-aware-defrag work can resume.

But given results to date, quota code could be good in a couple kernel 
cycles... or it could be five years... and how long snapshot-aware-defrag 
would take to come back together after that is anyone's guess as well, so 
don't hold your breath... you won't make it!

> For example, when I do a balance and change the compression, and I have
> multiple snaphots or files within one subvol that share their blocks...
> would that also lead to copies being made and the space growing possibly
> dramatically?

AFAIK balance has nothing to do with compression.  Defrag has an option 
to recompress... with the usual snapshot-unaware implications in terms of 
snapshot reflink breakage, of course.

I actually don't know what the effect of defrag, with or without 
recompression, is on same-subvolume reflinks.  If I were to guess I'd say 
it breaks them too, but I don't know.  If I needed to know I'd probably 
test it to see... or ask.

It _is_ worth noting, however, lest there be any misconceptions, that 
regardless of the number of reflinks sharing an extent between them, a 
single defrag on a single file will only make, maximum, a single 
additional copy.  It's not like it makes another copy for each of the 
reflinks to it, unless you defrag each of those reflinks individually.

So 250 snapshots of something isn't going to grow usage by 250 times with 
just a single defrag.  It will double it if the defrag is actually done 
(defrag doesn't touch a file if it doesn't think it needs defragged, in 
which case no space usage change would occur, but then neither would the 
actual defrag), but it won't blow up by 250X just because there's 250 
snapshots!

> 7) How das free-space defragmentation happen (or is there even such a
> thing)?
> For example, when I have my big qemu images, *not* using nodatacow, and
> I copy the image e.g. with qemu-img old.img new.img ... and delete the
> old then.
> Then I'd expect that the new.img is more or less not fragmented,... but
> will my free space (from the removed old.img) still be completely messed
> up sooner or later driving me into problems?

This one's actually a very good question as there has been a moderate 
regression in defrag's efficiency lately (well, 3.17 IIRC, which is out 
of the recommended 2-LTS-kernels range, but it was actually about 4.1 
before people put two and two together and figured out what happened, as 
it was conceptually entirely unrelated), due to implications of an 
otherwise unrelated change.  Meanwhile, the change did fix the problem it 
was designed to fix and reports of it are far rarer these days, to the 
point that I'd expect most would consider it well worth the very moderate 
inadvertent regression.

Defrag doesn't really defrag free space, tho if you're running 
autodefrag, free space shouldn't ever get /that/ fragmented to begin 
with, since file fragmentation level will in general be kept low enough 
that the remaining space should be generally fragmentation free as well.

Meanwhile, at the blockgroup aka chunk level balance defrags free space 
to some degree, by rewriting and consolidating chunks.  However, that's 
not directly free space defrag either, it just happens to do some of that 
due to the rewrites it does.

As to what caused that moderate regression mentioned above, it happened 
this way (IIRC my theory as actually described, but others agreed in 
general, tho I don't believe it has been actually proven just yet, see 
below).  Defrag was originally designed to work with currently allocated 
chunks and not allocate new ones, as back then, there tended to be plenty 
of empty data chunks lying around from the same normal use that triggered 
the fragmentation the first place, as btrfs didn't reclaim empty chunks 
back then as it does now.

But people got tired of btrfs running into ENOSPC errors when df said it 
had plenty of space -- but it was all tied up in empty (usually) data 
chunks, so there was no unallocated space left to allocate to more 
metadata chunks when needed, and having to manually run a balance
-dusage=0 or whatever to free up a bunch of empty data chunks so metadata 
chunks could be allocated.  (Occasionally it was the reverse, lots of 
empty metadata chunks, running out of data chunks, but that was much 
rarer due to normal usage patterns favoring data chunk allocation.)

So along around 3.17, btrfs behavior was changed so that it now deletes 
empty chunks automatically, and people don't have to do so many manual 
balances to clear empty data chunks any more. =:^)  And a worthwhile 
change it was, too, except...

Only several kernel cycles later did we figure out the problem that 
change was for defrag, since it's pretty conservative about allocating 
new and thus empty data chunks.  It took that long because it apparently 
never occurred to anyone that it'd affect defrag in any way at all, when 
the change was made.  And indeed, the effect is rather subtle and none-
too-intuitive, so it's no wonder it didn't even occur to anyone.

So what happens now is there's no empty data chunks around for defrag to 
put its work into, so it has to use much more congested partially full 
data chunks with much smaller contiguous blocks of free space, and the 
defrag often ends up being much less efficient than it would be if it 
still had all those empty chunks of free space to work with that are now 
automatically deleted.  In fact, in some cases defrag can now actually 
result in *more* fragmentation, if the existing file extents are larger 
than those available in existing data chunks.  Tho from reports, that 
doesn't tend to happen on initial run when people notice a problem and 
decide to defrag, the initial defrag usually improves the situation 
some.  But given the situation, people might decide the first result 
isn't good enough and try another defrag, and then it can actually make 
the problem worse.

Of course, if people are consistently using autodefrag (as I do) this 
doesn't tend to be a very big problem, as fragmentation is never allowed 
to build up to the point where it's significantly interfering with free 
space.  But if people are doing it manually and allow the fragmentation 
to build up between runs, it can be a significant problem, because that 
much file fragmentation means free space is highly fragmented as well, 
and with no extra empty chunks around as they've all been deleted...

So at some point, defrag will need at least partially rewritten to be at 
least somewhat more greedy in its new data chunk allocation.  I'm not a 
coder so I can't evaluate how big a rewrite that'll be, but with a bit of 
luck, it's more like a few line patch than a rewrite.  Because if it's a 
rewrite, then it's likely to wait until they can try to address the 
snapshot-aware-defrag issue again at the same time, and it's anyone's 
guess when that'll be, but probably more like years than months.

Meanwhile, I don't know that anybody has tried this yet, and with both 
compression and autodefrag on here it's not easy for me to try it, but in 
theory anyway, if defrag isn't working particularly well, it should be 
possible to truncate-create a number of GiB-sized files, sync (or fsync 
each one individually) so they're written out to storage, then truncate 
each file down to a few bytes, something 0 < size < 4096 bytes (or page 
size on archs where it's not 4096 by default), so they take only a single 
block of that original 1 GiB allocation, and sync again.

With a btrfs fi df run before and after the process, you can see if it's 
having the intended effect of creating a bunch of nearly empty data 
chunks (which are nominally 1 GiB in size each, tho they can be smaller 
if space is tight or larger on a large but nearly empty filesystem).  If 
there's a number of partially empty chunks such that the spread between 
data size and used is over a GiB, it may take writing a number of files 
at a GiB each to use up that space and see new chunks allocated, but once 
the desired number of data chunks is allocated, then start truncating to 
say 3 KiB, and see if the data used number starts coming down accordingly.

The idea of course would be to force creation of some new data chunks 
with files the size of a data chunk, then truncate them to the size of a 
single block, freeing most of the data chunk.

/Then/ run defrag, and it should actually have some near 1 GiB contiguous 
free-space blocks it can use, and thus should be rather more efficient! 
=:^)

Of course when you're done you can delete all those "balloon files" you 
used to force the data chunk allocation.

I'm not /sure, but I think btrfs may actually delay empty chunk deletion 
by a bit, to see if it's going to be used.  If it does, then someone 
could actually create, sync, and then delete the balloon files, and do 
the defrag in the lag time before btrfs deletes the empty chunks.  If it 
works, that should let files over a GiB in size grab whole GiB size data 
chunks, but I'm not sure it'll work as I don't know what btrfs' delay 
factor is before deleting those unused chunks.

It'd be a worthwhile experiment anyway.  If it works, then we have now 
nicely demonstrated that defrag indeed does work better with a few extra 
empty chunks laying around, and that it really does need patched up to be 
a bit more greedy in allocating new chunks, now that btrfs auto-deletes 
them so defrag isn't likely to find them simply lying around to be used, 
as it used to.  Because AFAIK I was actually the one that came up with 
the idea that the new lack of empty chunks lying around was the problem, 
and while I did get some agreement that it was likely, I'm not sure it's 
actually been tested yet, and not being a coder, I can't easily just look 
at the code and see what defrag's new chunk allocation policy is, so to 
this point it remains a nicely logical theory, but as yet unproven to the 
best of my knowledge.

> 8) why does a balance not also defragment? Since everything is anyway
> copied... why not defragmenting it?
> I somehow would have hoped that a balance cleans up all kinds of
> things,... like free space issues and also fragmentation.

Balance works with blockgroups/chunks, rewriting and defragging (and 
converting if told to do so with the appropriate balance filters) at that 
level, not the individual file or extent level.

Defrag works at the file/extent level, within blockgroups.

Perhaps there will be a tool that combines the two at some point in the 
likely distant future, but as of now there's all sorts of other projects 
to be done, and given that the existing tools do the job in general, it's 
unlikely this one will rise high enough in the priority queue to get any 
attention for some years.

> Given all these issues,... fragmentation, situations in which space may
> grow dramatically where the end-user/admin may not necessarily expect it
> (e.g. the defrag or the balance+compression case?)... btrfs seem to
> require much more in-depth knowledge and especially care (that even
> depends on the type of data) on the end-user/admin side than the
> traditional filesystems.

To some extent that comes with the more advanced than ordinary 
filesystems domain.  However, I think a lot more of it is simply the 
continued relative immaturity of the filesystem.  As it matures, 
presumably a lot of these still rough edges will be polished away, but 
it's a long process, with full general maturity likely still some years 
away given the relatively limited number of devs and their current rate 
of progress.

> Are there for example any general recommendations what to regularly to
> do keep the fs in a clean and proper shape (and I don't count "start
> with a fresh one and copy the data over" as a valid way).

=:^)

When I switched to btrfs some years ago, it was obviously rather less 
stable and mature than it is today, and was in fact still labeled 
experimental, with much stronger warnings about risks should you decide 
to use it without good backups than it has today.

And since then, a number of features not available on the earlier 
versions have been introduced, some of which could only be changed on a 
new filesystem

Now my backups routine already involved creating or using existing backup 
partitions the same size as the working copy, doing a mkfs thereon, 
copying all the data from each working partition and filesystem to its 
parallel backup(s), and then testing those backups by mounting and/or 
booting to them as alternates to the working copies.  Because as any good 
admin knows, a would-be backup isn't a backup until it has been tested to 
work, because until then, the backup job isn't complete, and the to-be 
backup cannot be relied upon /as/ a backup.

And periodically, I'd take the opportunity presented at that point, to 
reverse the process as well, one booted onto the backup, I'd blow away 
the normal working copy and do a fresh mkfs on it, then copy everything 
back from the backup to the working copy.

With btrfs then in experimental and various new feature additions 
requiring a fresh mkfs.btrfs anyway, it was thus little to no change in 
routine to simply be a bit more regular with that last step, blowing away 
the working copy whilst booted to backup, and copying it all back to the 
working copy from the backup, as if I were doing a backup to what 
actually happened to be the working copy.


So "start with a fresh btrfs and copy the data over", is indeed part of 
my regular backups routine here, just as it was back on reiserfs before 
btrfs, only a bit more regular for awhile, while btrfs was adding new 
features rather regularly.  Now that the btrfs forward-compatible-only on-
disk-format change train has slowed down some, I've not actually done it 
recently, but it's certainly easy enough to do so when I decide to. =:^)


But in terms of your question, the only things I do somewhat regularly 
are an occasional scrub (with btrfs raid1 precisely so I /do/ have a 
second copy available if one or the other fails checksum), and mostly 
because it's habit from before the automatic empty chunk delete code and 
my btrfs are all relatively small so the room for error is accordingly 
smaller, keeping an eye on the combination of btrfs fi sh and btrfs fi df, 
to see if I need to run a filtered balance.  But I've not had to do that 
in awhile, so how long the habit will remain around I really don't know.

Other than that, it's the usual simply keeping up with the backups, which 
I don't automate, but generally pick a stable point when everything's 
working and do whenever I start getting uncomfortable about the work I'd 
lose if things went kerflooey.

Tho I'm obviously active on this list, keeping up with current status and 
developments including the latest commonly reported bugs, as well. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

