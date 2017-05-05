Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:35502 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754833AbdEEULX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 16:11:23 -0400
Received: by mail-qt0-f177.google.com with SMTP id n4so13995069qte.2
        for <linux-btrfs@vger.kernel.org>; Fri, 05 May 2017 13:11:22 -0700 (PDT)
Message-ID: <1494015078.3117.4.camel@redhat.com>
Subject: Re: help converting btrfs to new writeback error tracking?
From: Jeff Layton <jlayton@redhat.com>
To: bo.li.liu@oracle.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 05 May 2017 16:11:18 -0400
In-Reply-To: <20170505192105.GA18638@lim.localdomain>
References: <1493897177.2783.4.camel@redhat.com>
         <20170505192105.GA18638@lim.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2017-05-05 at 12:21 -0700, Liu Bo wrote:
> Hi Jeff,
> 
> On Thu, May 04, 2017 at 07:26:17AM -0400, Jeff Layton wrote:
> > I've been working on set of patches to clean up how writeback errors are
> > tracked and handled in the kernel:
> > 
> > http://marc.info/?l=linux-fsdevel&m=149304074111261&w=2
> > 
> > The basic idea is that rather than having a set of flags that are
> > cleared whenever they are checked, we have a sequence counter and error
> > that are tracked on a per-mapping basis, and can then use that sequence
> > counter to tell whether the error should be reported.
> > 
> > This changes the way that things like filemap_write_and_wait work.
> > Rather than having to ensure that AS_EIO/AS_ENOSPC are not cleared
> > inappropriately (and thus losing errors that should be reported), you
> > can now tell whether there has been a writeback error since a certain
> > point in time, irrespective of whether anyone else is checking for
> > errors.
> > 
> > I've been doing some conversions of the existing code to the new scheme,
> > but btrfs has _really_ complicated error handling. I think it could
> > probably be simplified with this new scheme, but I could use some help
> > here.
> > 
> > What I think we probably want to do is to sample the error sequence in
> > the mapping at well-defined points in time (probably when starting a
> > transaction?) and then use that to determine whether writeback errors
> > have occurred since then. Is there anyone in the btrfs community who
> > could help me here?
> > 
> 
> I went through the patch set and reviewed the btrfs part particular in
> [PATCH v3 14/20] fs: retrofit old error reporting API onto new infrastructure
> 
> It looks good to me.
> 
> In btrfs ->writepage(), it sets PG_error whenever an error
> (-EIO/-ENOSPC/-ENOMEM) occurs and it sets mapping's error as well in
> end_extent_writepage().  And the special case is the compression code, where it
> only sets mapping's error when there is any error during processing compression
> bytes.
> 
> Similar to ext4, btrfs tracks the IO error by setting mapping's error in
> writepage_endio and other places (eg. compression code), and around tree-log.c
> it's checking BTRFS_ORDERED_IOERR from ordered_extent->flags, which is usually
> set in writepage_endio and sometimes in some error handling code where it
> couldn't call endio.
> 
> So the conversion in btrfs's fsync() seems to be good enough, did I miss
> anything?
> 

Many thanks for taking a look:

There are a number of calls in btrfs to filemap_fdatawait_range that
check the return code. That function will wait for writeback on all of
the pages in the mapping range and return an error if there has been
one. Note too that there are also some places that ignore the return
code.

These patches change how filemap_fdatawait_range (and some similar
functions) work. Before this set, you'd get an error if one had occurred
since anyone last checked it. Now, you only get an error there if one
occurred since you started waiting. If the failed writeback occurred
before that function was called, you won't get an error back.

For fsync, it shouldn't matter. You'll get an error back there if one
occurred since the last fsync since you're setting it in the mapping.
The bigger question is whether other callers in this code do anything
with that error return.

If they do, then the next question is: from what point do you want to
detect errors that have occurred?

What sort of makes sense to me (in a handwavy way) would be to sample
the errseq_t in the mapping when you start a transaction, and then check
vs. that for errors. Then, even if you have parallel transactions going
on the same inode (is that even possible?) then you can tell whether
they all succeded or not.

Thoughts?
-- 
Jeff Layton <jlayton@redhat.com>
