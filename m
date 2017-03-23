Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:50633 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932967AbdCWRlw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 13:41:52 -0400
Date: Thu, 23 Mar 2017 10:41:47 -0700
From: Sean Greenslade <sean@seangreenslade.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Cross-subvolume rename behavior
Message-ID: <20170323174147.GA4354@coach>
References: <20170323053723.GA32087@coach>
 <20170323100950.GI11714@carfax.org.uk>
 <8f7c4e4b-f311-27d7-f312-235dafbac30e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8f7c4e4b-f311-27d7-f312-235dafbac30e@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 23, 2017 at 07:23:40AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-03-23 06:09, Hugo Mills wrote:
> >    Direct rename (using rename(2)) isn't possible across subvols,
> > which is what the EXDEV result indicates. The solution is exactly what
> > mv does, which is reflink-and-delete (which is cheaper than
> > copy-and-delete, because no data is moved). In theory, you probably
> > could implement rename across subvolumes in the FS, but it would just
> > be moving the exact same operations from userspace to kernel space.
> >
> Doing so though would have the advantage that it theoretically could be made
> (almost) atomic like a normal rename is, whereas the fallback in mv is
> absolutely not atomic.
> > 
> >    I think that the solution here is for the sshfs stack to be fixed
> > so that it passes the EXDEV up to the mv command properly, and passes
> > the subsequent server-side copy (reflink) back down correctly.
> 
> This would be wonderful in theory, but it can't pass down the reflink,
> because the SFTP protocol (which is what sshfs uses) doesn't even have the
> concept of reflinks, so implementing this completely would require a
> revision to the SFTP protocol, which I don't see as likely to happen.

Thanks for the insights, Hugo and Austin. That's more or less what I was
expecting, so I guess my next stop will be with the openssh folks.
Though I was looking over the SFTP protocol, and none of the SSH_FX_*
errors seem suitable for this purpose. This might require a workaround
in sshfs...

--Sean

