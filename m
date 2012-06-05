Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36880 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab2FEMXf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 08:23:35 -0400
Date: Tue, 5 Jun 2012 04:54:08 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recovering a file from a snapshot without duplicating its blocks
 (--reflink across devs?)
Message-ID: <20120605115408.GD7572@merlins.org>
References: <20120605030100.GA7572@merlins.org>
 <4FCD803A.2070906@csamuel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FCD803A.2070906@csamuel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2012 at 01:42:50PM +1000, Chris Samuel wrote:
> On 05/06/12 13:01, Marc MERLIN wrote:
> 
> > First I though, I sure would be nice if I could take btrfs to reference
> > the same blocks from the snapshot to my current image.
> > But, --reflink failed across devices nodes, so I was forced to
> > copy/duplicate the blocks (36GB).
> 
> Patches for this were posted over a year ago, but it was NAK'd by
> Christoph Hellwig.  I don't know if it's got any further since then. :-(
> 
> Patch description:
> 
>  http://www.spinics.net/lists/linux-btrfs/msg09226.html
> 
> NAK:
> 
>  http://www.spinics.net/lists/linux-btrfs/msg09229.html

Thanks for that.

So, I'm not sure how common my use case is, but obviously for cases were
recovering a huge file is important, like disk images, being able to
re-link blocks without copying would be fantastic.

So here's my vote for that.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
