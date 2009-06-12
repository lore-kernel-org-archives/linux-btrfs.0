From: Chris Mason <chris.mason@oracle.com>
Subject: Re: cleanup after a small data loss on incorrect shutdown.
Date: Fri, 12 Jun 2009 07:42:30 -0400
Message-ID: <20090612114230.GH3834@think>
References: <4A30FC2E.3030804@rambler.ru> <20090612105332.GG3834@think> <4A32374A.6080900@rambler.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Michael Raskin <a0091f122@rambler.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A32374A.6080900@rambler.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 12, 2009 at 03:08:58PM +0400, Michael Raskin wrote:
> Chris Mason wrote:
> >> 	2. I found a file which is listed in the directory, but stat on it
> >> returns "No such file or directory". Certainly, rm and unlink cannot
> >> remove it. The partition has 14G in use. What can I do to provide a
> >> useful piece of FS structure information? How can I remove the file
> >> afterwards.
> > 
> > I'd say to send us the btrfsck output, it will help answer these
> > questions.
> 
> Oh, easily. "Bad block <number way beyond partition block count>".

Btrfs deals in byte numbers not block numbers ;)

> That's all. Reading one of the damaged file actually returned
> "Input/output error" - probably it tried to read beyond end-of-device. I
>  had to kill this file (practical testing means that to continue to use
> my notebook normally I had to nuke the damaged file and get intact
> copies). The "no such file except in readdir" is still there right now.

Ok, btrfsck will give us more output when it finishes, but it hasn't
finished.  It would help to use btrfs-image to send us a coyp of the
metadata so we can fix the btrfsck bug.

-chris
