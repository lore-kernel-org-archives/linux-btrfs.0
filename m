From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 16:04:42 -0400
Message-ID: <20091012200442.GA8830@think>
References: <4A74401B.90801@mccme.ru>
 <20090803145741.GC3765@think>
 <4A76FB78.5000207@wpkg.org>
 <20090803235920.C13173@mccme.ru>
 <87my3y3r8u.fsf@faran.nsc.liu.se>
 <4AD35667.3020103@hp.com>
 <DEABA03B-2896-484C-8DF9-F62E3E5AD342@ubuntu.com>
 <4AD372A7.2020907@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: John Dong <jdong@ubuntu.com>,
	=?iso-8859-1?B?UORy?= Andersson <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AD372A7.2020907@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 12, 2009 at 02:17:11PM -0400, jim owens wrote:
> John Dong wrote:
> >
> >I don't think that's a good counterargument for why this is not a bug.
> 
> it is not a "bug".  hard links are not a required feature of all
> filesystems nor is a defined large number required for those with
> hard links.
> 
> >Can't think of any off the top of my head for Linux, but
> >definitely in OS X Time Machine can easily create 200+ hardlinks.
> 
> so 311 is 50% than the app uses... plenty of growth.

Just to clarify again, the max link count on btrfs is 2^32.  The lower
limit is only in place on links to the same file in the same directory.

Jim is correct about the link count on subdirs being unrelated.  The
link count on btrfs directories is always one.

-chris

