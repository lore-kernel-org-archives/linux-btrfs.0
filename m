Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41166 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3JBBPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 21:15:23 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 869E09A03DD
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Oct 2013 19:15:22 -0600 (MDT)
From: Chris Mason <clmason@fusionio.com>
To: Greg KH <gregkh@linuxfoundation.org>, "dsterba@suse.cz" <dsterba@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Handful of btrfs fixes for 3.11.x stable
Date: Wed, 2 Oct 2013 01:15:19 +0000
Message-ID: <FD85C8284EBEEA498A3405D29590BB980E67BC47@MBS1.int.fusionio.com>
References: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
 <20130920165301.GA11262@kroah.com>
 <20131001170344.GA8551@twin.jikos.cz>,<20131001174910.GA19880@kroah.com>
In-Reply-To: <20131001174910.GA19880@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry,

I misunderstood and thought you had already queued them.  Both are fine with me.

-chris
________________________________________
From: Greg KH [gregkh@linuxfoundation.org]
Sent: Tuesday, October 01, 2013 1:49 PM
To: dsterba@suse.cz; stable@vger.kernel.org; Josef Bacik; Chris Mason; linux-btrfs@vger.kernel.org
Subject: Re: Handful of btrfs fixes for 3.11.x stable

On Tue, Oct 01, 2013 at 07:03:44PM +0200, David Sterba wrote:
> Hi Greg,
>
> On Fri, Sep 20, 2013 at 09:53:02AM -0700, Greg KH wrote:
> > Thanks for this, I'll queue them up soon.
>
> 3.11.3 has been just released and the btrfs fixes are not there nor in
> the stable-queue git repo. There's a fix for a crash that affects
> a number of users. Please queue the patches or let me know what's needed
> to get them to stable tree.

Chris implied that he was going to add them to a tree and then send them
on to me.  So I was waiting.

If this isn't the case, I'll be glad to queue them up for the next round
of kernels.

Chris, any opinions?  Either way is fine for me, it's your call.

thanks,

greg k-h
