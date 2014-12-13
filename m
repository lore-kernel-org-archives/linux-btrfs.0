Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:32932 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbaLMX4u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 18:56:50 -0500
Message-ID: <548CD23E.8080702@pobox.com>
Date: Sat, 13 Dec 2014 15:56:46 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com> <542EE83D.8050701@fb.com> <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com> <438e043f73392614d1453892b7fe225c@admin.virtall.com> <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com> <548B5FD6.5080306@pobox.com> <ce7dba343916e4262a92071af863d014@admin.virtall.com> <548B6D58.6080804@pobox.com> <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com> <548B7329.80208@pobox.com> <016ec9492d0340f8ac439ba4bcec03ad@admin.virtall.com> <548C0942.6020304@pobox.com> <a54531e35f70cb4d15a606385d2b581e@admin.virtall.com> <548CA76C.1060900@pobox.com> <df28609e5b5449b25076bfcf38f9a3de@admin.virtall.com>
In-Reply-To: <df28609e5b5449b25076bfcf38f9a3de@admin.virtall.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2014 01:52 PM, Tomasz Chmielewski wrote:
> On 2014-12-13 21:54, Robert White wrote:
>
>>> - rsync many remote data sources (-a -H --inplace --partial) + snapshot
>>
>> Using --inplace on a Copy On Write filesystem has only one effect, it
>> increases fragmentation... a lot...
>
> ...if the file was changed.

If the file hasn't changed then it won't be be transferred by 
definition. So the un-changed file is not terribly interesting.

And I did think about the rest of (most of) your points right after 
sending the original email. Particularly since I don't know your actual 
use case. But there is no "un-send" which I suddenly realized I wanted 
to do... Because I needed to change my answer. Like ten seconds later. 
/sigh.

I'm still strongly against forcing compression.

That said, my knee-jerk reaction to using --inplace is still strong for 
almost all file types.

And it remains almost absolute in your case simply because you are 
finding yourself needing to balance and whatnot.

E.g. the theoretical model of efficent partial copies as you present is 
fine... up until we get back your original complain about what a mess it 
makes.

The ruling precept here is Ben Franklin's "penny wise, pound foolish". 
What you _might_ be saving up-front with --inplace is charging you 
double on the back-end with maintenance.

>> Every new block is going to get
>> written to a new area anyway,
>
> Exactly - "every new block". But that's true with and without --inplace.
> Also - without --inplace, it is "every block". In other words, without
> --inplace, the file is likely to be rewritten by rsync to a new one, and
> CoW is lost (more below).

I don't know the nature of the particular files you are translating, but 
I do know a lot about rsync and file layout in general for lots of 
different types of files.

(rsync details here for readers-along :: 
http://rsync.samba.org/how-rsync-works.html )

Now I am assuming you took this advice from something like the manual 
page [QUOTE] This [--inplace] option  is useful for transferring large 
files with block-based changes or appended data, and also on systems 
that are disk bound, not network bound.  It can also help keep a 
copy-on-write filesystem snapshot from diverging the entire contents of 
a file that only has minor changes.[/QUOTE] Though maybe not since the 
description goes on to say that --inplace implies --partial so 
specifying both is redundant.

But here's the thing, those files are really rare. Way more rare than 
you might think.  The consist almost entirely of block-based database 
extents (like an oracle tablespace file), logfiles (such as is found in 
/var/log/messages etc.), VM disk image files (particularly raw images) 
and ISO images that are _only_ modified by adding tracks may fall into 
this category as well..


So we've already skipped the unchanged files...

So, inserting a single byte into, or removing a single byte from, any 
file will cause a re-write from that point on. It will send that file 
from the block boundary containing that byte. Just about anything with a 
header and a history is going to get re-sent almost completely. This 
includes the output from any word processing program you are likely to 
encounter.

Anything with linear compression (such as Open Document Format, which is 
basically a ZIP file) will be resent entirely.

All compiled programs binaries will be resent entirely if the program 
changed at all (the headers again, the changes in text segments, the 
changes in layout that a single byte difference in size cause the elf 
formats, or the dll formats to juggle significantly.)

And I could go on at length, but I'll skip that...

And _then_ the forced compression comes into play.

Rsync is going to impose its default block size to frame changes (see 
--block-size=) and then BTRFS is going to impose it's compression frame 
sizes (presuming it is done by block size). If these are not exactly teh 
same size any rsync block that updates will result in one or two "extra" 
compression blocks being re-written by the tiling overlap effect.

>> so if you have enough slack space to
>> keep the one new copy of the new file, which you will probably use up
>> anyway in the COW event, laying in the fresh copy in a likely more
>> contiguous way will tend to make things cleaner over time.
>>
>> --inplace is doubly useless with compression as compression is
>> perturbed by default if one byte changes in the original file.
>
> No. If you change 1 byte in a 100 MB file, or perhaps 1 GB file, you
> will likely loose a few kBs of CoW. The whole file is certainly not
> rewritten if you use --inplace. However it will be wholly rewritten if
> you don't use --inplace.
>
>
>> The only time --inplace might be helpful is if the file is NOCOW...
>> except...
>
> No, you're wrong.
> By default, rsync creates a new file if it detects any file modification
> - like "touch file".
>
> Consider this experiment:
>
> # create a "large file"
> dd if=/dev/urandom of=bigfile bs=1M count=3000
>
> # copy it with rsync
> rsync -a -v --progress bigfile bigfile2
>
> # copy it again - blazing fast, no change
> rsync -a -v --progress bigfile bigfile2
>
> # "touch" the original file
> touch bigfile

touching an unchanged file is cheating... and would be better addressed 
by the --checksum argument (unless you have something that really 
depends on the dates and you've already assured that any restores won't 
mess up the dates later anyway). --checksum, of course, slows down the 
file selection process.

>
> # try copying again with rsync - notice rsync creates a temp file, like
> .bigfile2.J79ta2
> # No change to the file except the timestamp, but good bye your CoW.
> rsync -a -v --progress bigfile bigfile2
>
> # Now try the same with --inplace; compare data written to disk with
> iostat -m in both cases.
>
>
> Same goes for append files - even if they are compressed, most CoW will
> be shared. I'd say it will be similar for lightly modified files
> (changed data will be CoW-unshared, some compressed "overhead" will be
> unshared, but the rest will be untouched / shared by CoW between the
> snapshots).

So while it is apparent that we both know how rsync works, I wonder if 
you've checked how much of your data load actually has a chance to 
benefit from --inplace and compared it to how much fragmentation it's 
likely to cause.

===

The basic problem I have with --inplace is, space permitting, you end up 
"better off" over long periods of time in a COW filesystem if you don't 
use it.

Consider any append-mode file. With each incremental append amidst a 
bulk transfer it will tend to have each increment separated from its 
next increment by one or more raw allocation extents. That, if nothing 
else, will cause the extents to _never_ reach the empty state where they 
can be reclaimed automatically.

If we were making an infographic-style representation of your disk 
storage the files with long histories would tend to look like lightning 
strikes "down the page" or "vertical scribbling up-an-down" instead of 
solid bars across the little chunks.

As snapshots come and go, the copied-and-replaced little bars would be 
memorialized for a time and then go away. The up and down result is 
semi-permanent, requiring you to do internal maintenance nonsense to try 
to coalesce the scribbles into bars.

So every time you defrag and balance the drive you are just taking steps 
to undo the geographical harm that rsync --inplace caused in the first 
place. That increases the total effective write cost of the inplace into 
the full copy cost _plus_ the incremental copy-on-overwrite cost spread 
over repeated activities (defrags or balances etc).

Without --inplace you'd definitely be using up more room for the copies 
(at least until internal data de-duplication comes along, presuming it 
does), but those copies will go away as the snapshots age off leaving 
larger chunks available for future allocation. The result of that will 
be smaller trees (not that that matters) and larger gaps (which really 
does matter) that the system can work with more optimally as time rolls 
forward forever.

In computer science (and other disciplines) "The Principle(s) of 
Locality" are huge actors. It's the basis of caching at all levels and 
it features strongly in graph theory and simple mechanics.

So yea, ten snapshots of a 30GiB VM disk image that hardly changed at 
all would _suck_, and might be worth its own selective rsync for the 
subdirectories where such things might happen; but turning a backup copy 
of your browser history file into a fifty-segment snail-trail wandering 
all through your data extents is not to be taken lightly either.

The middle ground is to selectively rsync the (usually) very-few 
directories that contain the files you _know_ will explicitly benefit 
from --inplace, such as /home/some_user/Virtual_Machines/*; then rsync 
the whole tree without the option. [The already synchronized directory 
will be automatically seen as current and you'll get optimal results.]


ASIDE :: I hope you are also using --delete when you rsync your backups. 8-)
