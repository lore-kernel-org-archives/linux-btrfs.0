Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:55346 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcE2AVV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 May 2016 20:21:21 -0400
Date: Sun, 29 May 2016 02:21:03 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
Message-ID: <20160529002103.GA31105@angband.pl>
References: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
 <20160527000401.GW7633@wotan.suse.de>
 <20160528015922.GI15597@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160528015922.GI15597@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 09:59:22PM -0400, Zygo Blaxell wrote:
> On Thu, May 26, 2016 at 05:04:01PM -0700, Mark Fasheh wrote:
> > On Fri, May 20, 2016 at 05:45:12AM +0200, Adam Borowski wrote:
> > > (Only btrfs currently implements dedupe_file_range.)
> > > 
> > > Instead of checking the mode of the file descriptor, let's check whether
> > > it could have been opened rw.  This allows fixing failures when deduping
> > > a live system: anyone trying to exec a file currently being deduped gets
> > > ETXTBSY.
> 
> Isn't there another copy of this check in fs/btrfs/ioctl.c?

I can't seem to find one.  But even if there was, dedupe_file_range() is
supposed to be not specific to btrfs, btrfs merely happens to be the only
implementation at the moment.  It'd be welcome in zfs, new xfs, ...

> > Hi Adam, this patch seems reasonable to me but I have to admit to being
> > worried about 'unintended consequences'. I poked around the code in fs/ for
> > a bit and saw mostly checks against file open mode. It might be that dedupe
> > is a special case due to the potential for longer running operations, 
> 
> The length of the operation is irrelevant.
> 
> If dedup is run over frequently executed files (e.g. /bin/sh), opening
> the files in write mode will randomly disrupt some normal execution no
> matter how quickly the dedup agent opens and closes the files.

And this is exactly the failure this patch aims to fix.

> The interference works both ways, too:  if a file is already being
> executed, it can't be opened with write access.   Executables often
> run for extended periods of time, effectively preventing them from ever
> being deduped by non-root users.

That's sadly not 100% true: it depends on handler in question.  A native ELF
file open for exec can't be opened for write, a binfmt-ed or hashbanged one
can, with disastrous results.

> > theoretically you'd see the same problem if trying to exec against a file
> > being cloned too, correct? If that's the case then I wonder how this issue
> > gets solved for other ioctls.
> 
> Clone could be used to change the content of the destination file, so
> it is right to insist on having the file opened for writing in that case.

Clone always writes to the file.  It may, as a special case, write the exact
same content as the file had before, but that's impossible to ascertain
without a race.

> Dedupe is an unusual case because it will never change the content of
> the destination file even if it is opened *with* write access.  The
> defrag ioctl is similar in this respect.

Changing defrag this way might be a good idea, too.  These ioctls are in
different parts of the kernel (vfs vs btrfs) though so let's do dedup first.

> Opening either dedup or defrag to non-root O_RDONLY access does have
> some concerns.  It could be used to create a lot of extra I/O load,
> particularly write load, that might otherwise be denied to an unprivileged
> user...but then, so can repeatedly calling sync(), so maybe this isn't
> a real problem.

As you have write access to the file, you can cause such load by... writing!

> There is a potential risk of exposing bugs in other parts of the system
> (e.g. the various recently fixed dedup races) but whatever those bugs are,
> we had them already without changing the permission checks.
> 
> I wonder if there is a risk of damaging files like this:
> 
> 	open A O_RDWR
> 
> 	open B O_RDONLY
> 
> 	copy B to A
> 
> 	do _not_ call fsync() here
> 
> 	dedup(A, B)
> 
> 	do _not_ call fsync() here either
> 
> 	some time passes
> 
> 	power fail
> 
> If A's extent isn't flushed to disk, what happens to B?  Does dedup imply
> fsync or data ordering such that A is written to disk before the extent
> ref in B is updated, or can the content of B change?  If root is running
> dedup, we can assume that whoever authorized root code execution also made
> sure that this case never arises (e.g. by ensuring the dedup agent always
> calls fsync, or otherwise ensuring that the extent at A is stable on disk
> before calling dedup).  If we allow non-root to do this then we have no
> such assurance--but on the other hand maybe the assurance is weak and
> bad things can happen here already even if we require root privilege.

I don't think this can happen on btrfs: the superblock is updated only after
a barrier when both the data and extent refs are already on the disk.
However, your scenario may apply to other filesystems that may implement
dedupe_file_range() in the future, thus it's prudent to require write
permissions. 

> I also wonder what happens if an executable that has called
> mlockall(MCL_FUTURE) gets its pages replaced by a deduped extent while
> it's running...do the replaced pages become un-mlockall-ed?  Is the VFS
> smart enough to swap in the new pages?  Am I just silly and insane for
> expecting shared mmap() to have meaningful real-time properties on btrfs?

mmap() has currently no relation to extents, even entirely identical files
don't share any pages:

dd if=/dev/urandom of=a bs=1048576 count=1024  # 1GB of junk
cp --reflink a b
time cat a >/dev/null  # all in page cache -- fast
time cat b >/dev/null  # every extent is shared with a, but...

It'd be nice to have such sharing in the future.  I don't see much
difference for mlock between pages that were shared before the mapping and
ones which become sharing on runtime, though.  The complexity will be on CoW
splitting rather than joining...

In any case, this patch doesn't introduce any cases not already triggerable
by root.


Meow!
-- 
An imaginary friend squared is a real enemy.
