Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:55542 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845Ab3FSVDx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Jun 2013 17:03:53 -0400
Received: by mail-ee0-f53.google.com with SMTP id c41so3517102eek.12
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2013 14:03:52 -0700 (PDT)
Message-ID: <1371675423.7211.22.camel@localhost.localdomain>
Subject: Re: BUG at fs/btrfs/print-tree when trying to mount after a crash
From: Michael Zugelder <michael@zugelder.org>
To: linux-btrfs@vger.kernel.org
Date: Wed, 19 Jun 2013 22:57:03 +0200
In-Reply-To: <1371557514.3293.21.camel@ivbl>
References: <1371496227.3925.44.camel@ivbl>
	 <pan$89a8$49bdccdf$48e0ce45$59d9acc9@cox.net>
	 <1371557514.3293.21.camel@ivbl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here's an update on my situation.

On Tue, 2013-06-18 at 14:11 +0200, Michael Zugelder wrote:
> Anyway, I tried using btrfsck from Josef Bacik's tree (commit f392a28d,
> git://github.com/josefbacik/btrfs-progs.git) and it doesn't crash.
> Output is this:
> 
> > Checking filesystem on /dev/mapper/cryptbtrfs
> > UUID: b3a88070-748c-4f19-9c7c-c78e8232797c
> > checking extents
> > corrupt extent record: key 19642421248 168 45056
> > corrupt extent record: key 19642904576 168 40960
> > corrupt extent record: key 19643248640 168 49152
> > corrupt extent record: key 19644252160 168 49152
> > corrupt extent record: key 19644645376 168 40960
> > corrupt extent record: key 19645878272 168 4096
> > corrupt extent record: key 19646754816 168 524288
> > ref mismatch on [19642265600 53248] extent item 18177, found 1
> > Backref 19642265600 root 259 owner 1647675 offset 1572864 num_refs 0 not found in extent tree
> > Incorrect local backref count on 19642265600 root 259 owner 1647675 offset 1572864 found 1 wanted 0 back 0x95f91a0
> > Incorrect local backref count on 19642265600 root 295 owner 1647618 offset 1573046 found 0 wanted 162 back 0x4efb2b0
> > Backref disk bytenr does not match extent record, bytenr=19642265600, ref bytenr=82290641
> > backpointer mismatch on [19642265600 53248]
> > Backref 19642318848 root 259 owner 1647675 offset 1703936 num_refs 0 not found in extent tree
> > Incorrect local backref count on 19642318848 root 259 owner 1647675 offset 1703936 found 1 wanted 0 back 0x95f92c0
> > Incorrect local backref count on 19642318848 root 259 owner 1647675 offset 148434071453696 found 0 wanted 1 back 0x4efb310
> > Backref disk bytenr does not match extent record, bytenr=19642318848, ref bytenr=1
> > backpointer mismatch on [19642318848 49152]
> [ ... ]
> > Errors found in extent allocation tree
> > checking free space cache
> > checking fs roots
> > root 1597 inode 553154 errors 0
> >         unresolved ref dir 473796 index 153 namelen 17 name browser_tests.log filetype 1 error 4
> >         unresolved ref dir 473796 index 17179869337 namelen 17 name brwser_te6ts.log filetype 0 error 3
> > found 62413098968 bytes used err is 1
> > total csum bytes: 71717016
> > total tree bytes: 2047426560
> > total fs tree bytes: 1812643840
> > total extent tree bytes: 129286144
> > btree space waste bytes: 427714485
> > file data blocks allocated: 186676146176
> >  referenced 125879046144
> > Btrfs v0.20-rc1

I recently discovered that the git btrfsck has a --repair option. It
seems like it was able to fix most of the errors. Here's what I did to
get rid of the rest (output from btrfsck):

> unresolved ref dir 473796 index 153 namelen 17 name browser_tests.log filetype 1 error 4
> unresolved ref dir 473796 index 17179869337 namelen 17 name brwser_te6ts.log filetype 0 error 3

Could not delete the file after mounting, so I just deleted the entire
subvolume and it is gone now.

> root 260  inode 12345 errors 42

Used "find -num 12345" to see which files referenced it. Since it was
just a sqlite journal file, I deleted it. But it was also referenced by
the snapshots of the last 24 hours, so I just deleted them, too.

> cache and super generation don't match, space cache will be invalidated

Mounted a few times with -o clear_cache, nospace_cache and then
space_cache. Dmesg shows "btrfs: disk space caching is enabled" and no
errors, so I hope it works again. Never noticed any long mount/unmount
times or heavy cpu/disk activity, though.

Then I ran btrfs scrub over it, which found 0 errors, but there were
still some corruption issues from the btrfsck repair. I used rpm -Va and
reinstalled a few packages whose files were missing and added myself to
the relevant groups again.

The system seems to work fine now, but I'll probably keep some easier
restorable backups from now on. If you want any details to be able to
fix some of the BUGs, assertion errors and/or crashes I encountered, I'm
glad to help, still have the original corrupted image.


Michael

