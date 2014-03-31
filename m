Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57486 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaCaQfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 12:35:41 -0400
Date: Mon, 31 Mar 2014 09:35:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Filipe David Manana <fdmanana@gmail.com>
Cc: Chris Mason <clm@fb.com>
Message-ID: <20140331163531.GH2972@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5mxvN+TxtK3_Oeef=S3rVGu2QywD6d8Zd6ABUj1B44Nw@mail.gmail.com>
 <20140330002123.GP22552@merlins.org>
Subject: Re: determining snapshot size -> adding "work to do" info to btrfs
 send
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 29, 2014 at 05:21:23PM -0700, Marc MERLIN wrote:
> I had a look at
> http://bj0z.wordpress.com/2011/04/27/determining-snapshot-size-in-btrfs/#comment-35
> but it's quite old and does not work anymore since userland became
> incompatible with it.
> 
> Has anyone seen something newer or have a newer fixed version of this?

While watching a btrfs send|receive going for hours, keeping the
backup disk array spinning in my living room, and my wondering "how far
is it from being done", I was thinking:

Would it be reasonably simple for btrfs send -p to have a few more
features?
1) don't read all the data from disk, just read the metadata and tell me
how many megabytes it will take to send.
I can do this with 
btrfs send | wc -c 
I believe, but it would be better if it could do this without reading all
the data blocks to send when I'm only caring about the byte output

In turn this could be used to easily compute snapshot size diffs at
least from one another.


2) output a list of files added/changed/removed, maybe with how much
data is related to each.
Arguably this would supersede 1) above even if it would be a little bit
more work to do


3) when a real btrfs send is running, just like dd, I could send it a
USR1 signal and it would output some kind of progress report.
The Ted T'so motto (used for e2fsck) is "everything with a progress bar
is faster" :)
Note, the progress wouldn't have to be perfect, it could be by number of
blocks, number of files, anything reasonably easy to implement it on.

Does that sound reasonable?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
