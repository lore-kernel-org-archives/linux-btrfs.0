Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:39854 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340AbaLMUyK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 15:54:10 -0500
Message-ID: <548CA76C.1060900@pobox.com>
Date: Sat, 13 Dec 2014 12:54:04 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com> <542EE83D.8050701@fb.com> <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com> <438e043f73392614d1453892b7fe225c@admin.virtall.com> <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com> <548B5FD6.5080306@pobox.com> <ce7dba343916e4262a92071af863d014@admin.virtall.com> <548B6D58.6080804@pobox.com> <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com> <548B7329.80208@pobox.com> <016ec9492d0340f8ac439ba4bcec03ad@admin.virtall.com> <548C0942.6020304@pobox.com> <a54531e35f70cb4d15a606385d2b581e@admin.virtall.com>
In-Reply-To: <a54531e35f70cb4d15a606385d2b581e@admin.virtall.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2014 05:53 AM, Tomasz Chmielewski wrote:
> My usage case is quite simple:
>
> - skinny extents, extended inode refs
okay

> - mount compress-force=zlib
I'd, personally, "never" force compression. This can increase the size 
of files by five or more percent if it is an inherently incompressible 
file. While it is easy to deliberately create a file that will trick the 
compress check logic into not compressing something that would enjoy 
compression it does _not_ happen by chance very often at all.

> - rsync many remote data sources (-a -H --inplace --partial) + snapshot

Using --inplace on a Copy On Write filesystem has only one effect, it 
increases fragmentation... a lot... Every new block is going to get 
written to a new area anyway, so if you have enough slack space to keep 
the one new copy of the new file, which you will probably use up anyway 
in the COW event, laying in the fresh copy in a likely more contiguous 
way will tend to make things cleaner over time.

--inplace is doubly useless with compression as compression is perturbed 
by default if one byte changes in the original file.

The only time --inplace might be helpful is if the file is NOCOW... 
except...


> - around 500 snapshots in total, from 20 or so subvolumes

That's a lot of snapshots and subvolumes. Not an impossibly high number, 
but a lot. That needs it's own use-case evaluation. But regardless...

Even if you set the NOCOW option on a file to make the --inplace rsync 
work, if that file is snapshotted (snapshot?) between the rsync 
modification events it will be in 1COW mode because of the snapshot 
anyway and you are back to the default anti-optimal conditions.


> Especially rsync's --inplace option combined with many snapshots and
> large fragmentation was deadly for btrfs - I was seeing system freezes
> right when rsyncing a highly fragmented, large file.

You are kind of doing all that to yourself. Combining _forced_ 
compression with denying the natural opportunity for the re-write of the 
file to move it to nicely contiguous "new locations" and then pinning it 
all in place with multiple snapshots you've created the worst of all 
possible worlds.

The more you use optional gross-behavior options on some sorts of things 
the more you are fighting the "natural organization" of the system. That 
is, every system is designed around a set of core assumptions and 
behavioral options tend to invalidate the mainline assumptions. Some 
options, like "recursive" are naturally part of those assumptions and 
play into them, other options, particularly things with "force" in the 
name tend to be "if you really think you must, sure, I'll do what you 
say, but if it turns out bad it's on _your_ head" options. Which options 
are which is a judgment call, but the combination you've chosen is 
definitely working in that bad area.

And keep repeating this to yourself :: "balance does not reorganize 
anything, it just moves the existing disorder to a new location". This 
is not a perfect summation, and it's clearly wrong if you are using 
"convert", but it's the correct way to view what's happening while 
asking yourself "should I balance?".

