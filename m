From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Mass-Hardlinking Oops
Date: Tue, 13 Oct 2009 16:03:16 -0400
Message-ID: <20091013200316.GC7850@think>
References: <4A74401B.90801@mccme.ru>
 <20090803145741.GC3765@think>
 <4A76FB78.5000207@wpkg.org>
 <20090803235920.C13173@mccme.ru>
 <87my3y3r8u.fsf@faran.nsc.liu.se>
 <4AD35667.3020103@hp.com>
 <DEABA03B-2896-484C-8DF9-F62E3E5AD342@ubuntu.com>
 <4AD4BCC7.3060204@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: John Dong <jdong@ubuntu.com>, jim owens <jowens@hp.com>,
	=?iso-8859-1?B?UORy?= Andersson <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AD4BCC7.3060204@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2009 at 10:45:43AM -0700, Zach Brown wrote:
> 
> >>> this thread. I get EMLINK when trying to create more than 311 (not 272)
> >>> links in a directory
> >>
> >> what real-world application uses and needs this many hard links?
> > 
> > I don't think that's a good counterargument for why this is not a bug.
> 
> I strongly agree.  Our ignorance of users operating inside existing
> limits of existing file systems shouldn't justify tightening those limits.
> 
> Sure, this is a weird corner case.  But given how early btrfs is in the
> deployment stage, it seems worth changing the format to get rid of this
> risk of teaching people to question their expectation that btrfs will
> just work in environments that previous linux file systems worked in.

This hasn't been at the top of my list for a while, I remember a bunch
of planning sessions where you weren't worried about it ;)

But, we can look at ways to resolve it in the future.  My big concern
right now is the enospc support, but there is room to update this
without forcing a full format change.

-chris

