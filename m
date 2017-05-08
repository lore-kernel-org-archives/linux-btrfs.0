Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41988 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdEHSkt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 14:40:49 -0400
Date: Mon, 8 May 2017 11:39:16 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: help converting btrfs to new writeback error tracking?
Message-ID: <20170508183915.GB20619@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1493897177.2783.4.camel@redhat.com>
 <20170505192105.GA18638@lim.localdomain>
 <1494015078.3117.4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1494015078.3117.4.camel@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

On Fri, May 05, 2017 at 04:11:18PM -0400, Jeff Layton wrote:
> On Fri, 2017-05-05 at 12:21 -0700, Liu Bo wrote:
> > Hi Jeff,
> > 
> > On Thu, May 04, 2017 at 07:26:17AM -0400, Jeff Layton wrote:
> > > I've been working on set of patches to clean up how writeback errors are
> > > tracked and handled in the kernel:
> > > 
> > > http://marc.info/?l=linux-fsdevel&m=149304074111261&w=2
> > > 
> > > The basic idea is that rather than having a set of flags that are
> > > cleared whenever they are checked, we have a sequence counter and error
> > > that are tracked on a per-mapping basis, and can then use that sequence
> > > counter to tell whether the error should be reported.
> > > 
> > > This changes the way that things like filemap_write_and_wait work.
> > > Rather than having to ensure that AS_EIO/AS_ENOSPC are not cleared
> > > inappropriately (and thus losing errors that should be reported), you
> > > can now tell whether there has been a writeback error since a certain
> > > point in time, irrespective of whether anyone else is checking for
> > > errors.
> > > 
> > > I've been doing some conversions of the existing code to the new scheme,
> > > but btrfs has _really_ complicated error handling. I think it could
> > > probably be simplified with this new scheme, but I could use some help
> > > here.
> > > 
> > > What I think we probably want to do is to sample the error sequence in
> > > the mapping at well-defined points in time (probably when starting a
> > > transaction?) and then use that to determine whether writeback errors
> > > have occurred since then. Is there anyone in the btrfs community who
> > > could help me here?
> > > 
> > 
> > I went through the patch set and reviewed the btrfs part particular in
> > [PATCH v3 14/20] fs: retrofit old error reporting API onto new infrastructure
> > 
> > It looks good to me.
> > 
> > In btrfs ->writepage(), it sets PG_error whenever an error
> > (-EIO/-ENOSPC/-ENOMEM) occurs and it sets mapping's error as well in
> > end_extent_writepage().  And the special case is the compression code, where it
> > only sets mapping's error when there is any error during processing compression
> > bytes.
> > 
> > Similar to ext4, btrfs tracks the IO error by setting mapping's error in
> > writepage_endio and other places (eg. compression code), and around tree-log.c
> > it's checking BTRFS_ORDERED_IOERR from ordered_extent->flags, which is usually
> > set in writepage_endio and sometimes in some error handling code where it
> > couldn't call endio.
> > 
> > So the conversion in btrfs's fsync() seems to be good enough, did I miss
> > anything?
> > 
> 
> Many thanks for taking a look:
> 
> There are a number of calls in btrfs to filemap_fdatawait_range that
> check the return code. That function will wait for writeback on all of
> the pages in the mapping range and return an error if there has been
> one. Note too that there are also some places that ignore the return
> code.
> 
> These patches change how filemap_fdatawait_range (and some similar
> functions) work. Before this set, you'd get an error if one had occurred
> since anyone last checked it. Now, you only get an error there if one
> occurred since you started waiting. If the failed writeback occurred
> before that function was called, you won't get an error back.
> 

Since all filemap_fdatawait_range() called in btrfs checked the return value, it
is supposed to catch any errors that are occured from filemap_fdatawrite_range()
which is called twice by btrfs_fdatawrite_range()[1], so with this set, it's
possible to fail to detect errors if only calling filemap_fdatawait_range().

[1]: filemap_fdatawrite_range() needs to be called twice to make sure compressed
data is flushed.

> For fsync, it shouldn't matter. You'll get an error back there if one
> occurred since the last fsync since you're setting it in the mapping.
> The bigger question is whether other callers in this code do anything
> with that error return.
> 
> If they do, then the next question is: from what point do you want to
> detect errors that have occurred?
> 
> What sort of makes sense to me (in a handwavy way) would be to sample
> the errseq_t in the mapping when you start a transaction, and then check
> vs. that for errors. Then, even if you have parallel transactions going
> on the same inode (is that even possible?) then you can tell whether
> they all succeded or not.
> 
> Thoughts?

That may not work, a transaction here is kind of unrelated to mapping and
writeback of a mapping can be processed accross two transactions.

Is it possible to provide another version of filemap_fdatawait_range() to take
@since as an argument?  If so, we can sample wb_err before calling
filemap_fdatawrite_range() (or btrfs_fdatawrite_range()) and collect any wb_err
after filemap_fdatawait_range().

Thanks,

-liubo
