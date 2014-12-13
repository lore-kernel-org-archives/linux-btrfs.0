Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:55795 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaLMVwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 16:52:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 13 Dec 2014 22:52:43 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
In-Reply-To: <548CA76C.1060900@pobox.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
 <542EE83D.8050701@fb.com>
 <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
 <438e043f73392614d1453892b7fe225c@admin.virtall.com>
 <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
 <548B5FD6.5080306@pobox.com>
 <ce7dba343916e4262a92071af863d014@admin.virtall.com>
 <548B6D58.6080804@pobox.com>
 <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com>
 <548B7329.80208@pobox.com>
 <016ec9492d0340f8ac439ba4bcec03ad@admin.virtall.com>
 <548C0942.6020304@pobox.com>
 <a54531e35f70cb4d15a606385d2b581e@admin.virtall.com>
 <548CA76C.1060900@pobox.com>
Message-ID: <df28609e5b5449b25076bfcf38f9a3de@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-13 21:54, Robert White wrote:

>> - rsync many remote data sources (-a -H --inplace --partial) + 
>> snapshot
> 
> Using --inplace on a Copy On Write filesystem has only one effect, it
> increases fragmentation... a lot...

...if the file was changed.


> Every new block is going to get
> written to a new area anyway,

Exactly - "every new block". But that's true with and without --inplace.
Also - without --inplace, it is "every block". In other words, without 
--inplace, the file is likely to be rewritten by rsync to a new one, and 
CoW is lost (more below).


> so if you have enough slack space to
> keep the one new copy of the new file, which you will probably use up
> anyway in the COW event, laying in the fresh copy in a likely more
> contiguous way will tend to make things cleaner over time.
> 
> --inplace is doubly useless with compression as compression is
> perturbed by default if one byte changes in the original file.

No. If you change 1 byte in a 100 MB file, or perhaps 1 GB file, you 
will likely loose a few kBs of CoW. The whole file is certainly not 
rewritten if you use --inplace. However it will be wholly rewritten if 
you don't use --inplace.


> The only time --inplace might be helpful is if the file is NOCOW... 
> except...

No, you're wrong.
By default, rsync creates a new file if it detects any file modification 
- like "touch file".

Consider this experiment:

# create a "large file"
dd if=/dev/urandom of=bigfile bs=1M count=3000

# copy it with rsync
rsync -a -v --progress bigfile bigfile2

# copy it again - blazing fast, no change
rsync -a -v --progress bigfile bigfile2

# "touch" the original file
touch bigfile

# try copying again with rsync - notice rsync creates a temp file, like 
.bigfile2.J79ta2
# No change to the file except the timestamp, but good bye your CoW.
rsync -a -v --progress bigfile bigfile2

# Now try the same with --inplace; compare data written to disk with 
iostat -m in both cases.


Same goes for append files - even if they are compressed, most CoW will 
be shared. I'd say it will be similar for lightly modified files 
(changed data will be CoW-unshared, some compressed "overhead" will be 
unshared, but the rest will be untouched / shared by CoW between the 
snapshots).



>> - around 500 snapshots in total, from 20 or so subvolumes
> 
> That's a lot of snapshots and subvolumes. Not an impossibly high
> number, but a lot. That needs it's own use-case evaluation. But
> regardless...
> 
> Even if you set the NOCOW option on a file to make the --inplace rsync
> work, if that file is snapshotted (snapshot?) between the rsync
> modification events it will be in 1COW mode because of the snapshot
> anyway and you are back to the default anti-optimal conditions.

Again - if the file was changed a lot, it doesn't matter if it's 
--inplace or not. If the file data was not changed, or changed little - 
--inplace will help preserve CoW.


>> Especially rsync's --inplace option combined with many snapshots and
>> large fragmentation was deadly for btrfs - I was seeing system freezes
>> right when rsyncing a highly fragmented, large file.
> 
> You are kind of doing all that to yourself.

To clarify - freezes - I mean kernel bugs exposed and machine freezing.
I think we all agree that whatever userspace is doing in the filesystem, 
it should not result is kernel BUG / freeze.


> Combining _forced_
> compression with denying the natural opportunity for the re-write of
> the file to move it to nicely contiguous "new locations" and then
> pinning it all in place with multiple snapshots you've created the
> worst of all possible worlds.

I disagree. It's quite compact, for my data usage. If I needed blazing 
fast file access, I wouldn't be using a CoW filesystem nor snapshots in 
the first place. For data mostly stored and rarely read, it is OK.


(...)

> And keep repeating this to yourself :: "balance does not reorganize
> anything, it just moves the existing disorder to a new location". This
> is not a perfect summation, and it's clearly wrong if you are using
> "convert", but it's the correct way to view what's happening while
> asking yourself "should I balance?".

I agree - I don't run it unless I need to (or I'm curious to see if it 
would expose some more bugs).
It would be quite a step back for a filesystem to need some periodic 
maintenance like that after all.

Also I'm in the opinion that balance should not cause the kernel to BUG 
- it should abort, possibly remount the fs ro etc. (suggest running 
btrfsck, if there is enough confidence in this tool), but definitely not 
BUG.


-- 
Tomasz Chmielewski
http://www.sslrack.com

