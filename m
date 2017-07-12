Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34632 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdGLSrb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 14:47:31 -0400
Date: Wed, 12 Jul 2017 11:46:29 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: report errors when checksum is not found
Message-ID: <20170712174628.GB4268@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170711204316.11283-1-bo.li.liu@oracle.com>
 <20170712144036.GC2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712144036.GC2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 04:40:36PM +0200, David Sterba wrote:
> On Tue, Jul 11, 2017 at 02:43:16PM -0600, Liu Bo wrote:
> > When btrfs fails the checksum check, it'll fill the whole page with
> > "1".
> 
> One could ask, why is the page filled with 1s. Brought by commit
> 07157aacb1ecd394a54949 from 2007, without mentioning any justification.
> I'm more inclined to revisit this behaviour and drop it eventually.
> 
> > However, if %csum_expected is 0 (which means there is no checksum), then
> > for some unknown reason, we just pretend that the read is correct, so
> > userspace would be confused about the dilemma that read is successful but
> > getting a page with all content being "1".
> 
> Here 'no checksum' means that no checksum was found but was expected,
> right?

Yes, no checksum was found.

> An EIO would fail the read, I don't see a reason why the page
> needs to be "zeroed". The contents would be inaccessible anyway.
>

Right, resetting page's content is needed when we return 0 instead of
-EIO.  I guess it was introduced for testing.  So yes, I'm glad to
remove that part, will do in a v2.

> > This can happen due to a bug in btrfs-convert.
> > 
> > This fixes it by always returning errors if checksum doesn't match.
> 
> Independent of the above, this fix makes sense.
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

Thank you for the comments.

Thanks,

-liubo
