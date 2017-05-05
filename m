Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17432 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbdEETWg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 15:22:36 -0400
Date: Fri, 5 May 2017 12:21:06 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: help converting btrfs to new writeback error tracking?
Message-ID: <20170505192105.GA18638@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1493897177.2783.4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493897177.2783.4.camel@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

On Thu, May 04, 2017 at 07:26:17AM -0400, Jeff Layton wrote:
> I've been working on set of patches to clean up how writeback errors are
> tracked and handled in the kernel:
> 
> http://marc.info/?l=linux-fsdevel&m=149304074111261&w=2
> 
> The basic idea is that rather than having a set of flags that are
> cleared whenever they are checked, we have a sequence counter and error
> that are tracked on a per-mapping basis, and can then use that sequence
> counter to tell whether the error should be reported.
> 
> This changes the way that things like filemap_write_and_wait work.
> Rather than having to ensure that AS_EIO/AS_ENOSPC are not cleared
> inappropriately (and thus losing errors that should be reported), you
> can now tell whether there has been a writeback error since a certain
> point in time, irrespective of whether anyone else is checking for
> errors.
> 
> I've been doing some conversions of the existing code to the new scheme,
> but btrfs has _really_ complicated error handling. I think it could
> probably be simplified with this new scheme, but I could use some help
> here.
> 
> What I think we probably want to do is to sample the error sequence in
> the mapping at well-defined points in time (probably when starting a
> transaction?) and then use that to determine whether writeback errors
> have occurred since then. Is there anyone in the btrfs community who
> could help me here?
>

I went through the patch set and reviewed the btrfs part particular in
[PATCH v3 14/20] fs: retrofit old error reporting API onto new infrastructure

It looks good to me.

In btrfs ->writepage(), it sets PG_error whenever an error
(-EIO/-ENOSPC/-ENOMEM) occurs and it sets mapping's error as well in
end_extent_writepage().  And the special case is the compression code, where it
only sets mapping's error when there is any error during processing compression
bytes.

Similar to ext4, btrfs tracks the IO error by setting mapping's error in
writepage_endio and other places (eg. compression code), and around tree-log.c
it's checking BTRFS_ORDERED_IOERR from ordered_extent->flags, which is usually
set in writepage_endio and sometimes in some error handling code where it
couldn't call endio.

So the conversion in btrfs's fsync() seems to be good enough, did I miss
anything?

Thanks,

-liubo
