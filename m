Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50390 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbdGLWhD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:37:03 -0400
Date: Wed, 12 Jul 2017 15:35:43 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: report errors when checksum is not found
Message-ID: <20170712213542.GC4268@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170711204316.11283-1-bo.li.liu@oracle.com>
 <20170712144036.GC2866@twin.jikos.cz>
 <20170712174628.GB4268@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712174628.GB4268@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 11:46:29AM -0600, Liu Bo wrote:
> On Wed, Jul 12, 2017 at 04:40:36PM +0200, David Sterba wrote:
> > On Tue, Jul 11, 2017 at 02:43:16PM -0600, Liu Bo wrote:
> > > When btrfs fails the checksum check, it'll fill the whole page with
> > > "1".
> > 
> > One could ask, why is the page filled with 1s. Brought by commit
> > 07157aacb1ecd394a54949 from 2007, without mentioning any justification.
> > I'm more inclined to revisit this behaviour and drop it eventually.
> > 
> > > However, if %csum_expected is 0 (which means there is no checksum), then
> > > for some unknown reason, we just pretend that the read is correct, so
> > > userspace would be confused about the dilemma that read is successful but
> > > getting a page with all content being "1".
> > 
> > Here 'no checksum' means that no checksum was found but was expected,
> > right?
> 
> Yes, no checksum was found.
> 
> > An EIO would fail the read, I don't see a reason why the page
> > needs to be "zeroed". The contents would be inaccessible anyway.
> >
> 
> Right, resetting page's content is needed when we return 0 instead of
> -EIO.  I guess it was introduced for testing.  So yes, I'm glad to
> remove that part, will do in a v2.
>

Since this __readpage_endio_check() is also called by directIO's
btrfs_retry_endio(), in the dio case, userspace can read out the page
content.

For that reason, I think we would have to keep it and return errors to
userspace.

Thanks,

-liubo

> > > This can happen due to a bug in btrfs-convert.
> > > 
> > > This fixes it by always returning errors if checksum doesn't match.
> > 
> > Independent of the above, this fix makes sense.
> > 
> > Reviewed-by: David Sterba <dsterba@suse.com>
> 
> Thank you for the comments.
> 
> Thanks,
> 
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
