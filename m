Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60933 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab3GVMJp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 08:09:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V1Evv-0000RS-Vc
	for linux-btrfs@vger.kernel.org; Mon, 22 Jul 2013 14:09:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 14:09:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 14:09:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: autodefrag by default, was: Lots of harddrive chatter
Date: Mon, 22 Jul 2013 12:09:26 +0000 (UTC)
Message-ID: <pan$42252$33d9c63c$845648e4$82c91343@cox.net>
References: <ksf42h$suu$1@ger.gmane.org> <
	pan$7e18b$b2c36a61$b1f22c8c$6c61ba6e@cox.net> <51EC7249.3010005@chinilu.com
	>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Mitchell posted on Sun, 21 Jul 2013 16:44:09 -0700 as excerpted:

> But I think the only unanswered question for me at this point is whether
> complete defragmentation is even possible using auto-defrag.  Unless
> auto-defrag can work around the in-use file issue, that could be a
> problem since some heavily used system files are open virtually all the
> time the system is up and running.  Has this issue been investigated and
> if so are there any system files that don't get defragmented that
> matter?  Or is this a non-issue in that any constantly in use system
> files don't really matter anyway?

I believe Shridnar has it right; writes into a file/directory are the big 
fragmentation issue for btrfs.  But there's one aspect he overlooked -- 
this is another reason I so strongly stress the autodefrag-from-newly-
created-empty-filesystem-on point: for the general case, if autodefrag is 
on when the files are written in the first place, they won't be 
fragmented when they're loaded and the file is thus in-use, so there 
won't be any need to defrag them when in-use.

There's two main forms of always-in-use files, executables/libraries etc 
that nay be memory-mapped, and database/vm-image files where the vm or 
database is always running.  (And arguably, given a broad enough 
definition of database files, nearly anything else that would fall in 
this category including vm-images is already covered by that, so...)

In the executables/libraries case, the files are generally NOT in-place 
rewritten, and installations/updates don't tend to be a problem either.  
Unlike MS where in-use files (used to be? I've been off MS for years so 
don't know whether this remains true on their current product) cannot/
could-not be replaced without a reboot, on Linux, the kernel allows 
unlinking and replacement of in-use files, with the references to 
previously existing file maintained in memory only; no actual storage-
location overwrite allowed until there are no further runtime references 
to the old file.

Sometime after you've done some in-use library/elf-file-executable 
package updates, try this.  Look thru /proc/*/maps, where * is the PID of 
the process you're investigating.  (You'll need to be root to look at 
processes running as other users.)  This is a list of files that process 
has mapped.  (It's documented in the kernel documentation, see $KERNELDIR/
Documentation/filesystems/proc.txt and search for /proc/PID/maps.)  On 
the right side is the pathname.  What's we're interested in here, 
however, is what happens when one of those files is replaced.  To the 
right of the pathname there will be a notation: "(deleted)".  These are 
files that have been unlinked (deleted or replaced), with the kernel 
maintaining the reference to the old location even tho a file listing 
won't show the old file any longer, until all existing runtime file 
references are terminated.

There are actually helper-scripts available that will look thru /proc/PID/
maps and tell you which apps you need to restart to use the updated files.

Another user of this unlink but keep the reference trick is certain media 
apps such as flash, that will download a file to a temporary location, 
load it and keep the open reference, then delete the file so it no longer 
appears in the filesystem.  Among other things, this makes it more 
difficult to copy files some people seem to think the user shouldn't be 
copying, since the only way to get to the file once it is unlinked is by 
somehow grabbing the open reference to it that the app still has.

Coming back to the topic at hand, as a result of the above mechanism, 
updates aren't normally rewritten actually in-place, normally allowing 
them to be written as a single unfragmented file, or if fragmented, 
autodefrag will notice and schedule a defragment for the defrag thread.  
With the exception of something like glibc, where the new library is put 
to work the next time something runs, that generally leaves time for a 
defragment if necessary, and ideally, it won't be necessary since the 
file should have been written in one piece, without fragmentation (unless 
there's so little space left the filesystem is in use what we can find 
mode and thus is no longer worried about fragmentation).

VM images and database files are a rather different story, since they're 
OFTEN rewritten in place.  The btrfs autodefrag option should handle 
reasonably small database files such as firefox's sqlite files without 
too much difficulty.  However, there's a warning on the wiki about 
performance issues with larger database files and VM images (I'd guess in 
the range of gigabytes).  The issues /may/ have been solved by now but 
I'm not sure.  However, it's possible to mark such files (or more likely, 
the directory they're in, since the marking should be done at creation in 
ordered to be effective, and files inherit from the directory so will get 
it at creation if the directory has it) NODATACOW, so they get updated in-
place and thus don't fragment any further on in-place writes.  Yes, 
that's individual handling, but we're talking database/vm-image files in 
the gigabytes, so it's not like /most/ people would be managing hundreds 
or thousands of them, and if they are, they should be scripting the 
handling anyway, and can just throw the nodatacow handling into the 
script.

So as I said, ensure autodefrag is one from the new and empty filesystem 
state as it fills up, and with the exception of big database/vm-image 
files which can be handled separately, it should "just work", since 
you'll be handling fragmentation routinely as it happens.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

