Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3KYVBG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 16:01:06 -0500
Date: Mon, 25 Nov 2013 13:01:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: dsterba@suse.cz, Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: relocate csums properly with prealloc extents
Message-ID: <20131125210104.GA24160@kroah.com>
References: <1380289020-2515-1-git-send-email-jbacik@fusionio.com>
 <20131125165116.GR5007@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131125165116.GR5007@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 25, 2013 at 05:51:16PM +0100, David Sterba wrote:
> On Fri, Sep 27, 2013 at 09:37:00AM -0400, Josef Bacik wrote:
> > A user reported a problem where they were getting csum errors when running a
> > balance and running systemd's journal.  This is because systemd is awesome and
> > fallocate()'s its log space and writes into it.  Unfortunately we assume that
> > when we read in all the csums for an extent that they are sequential starting at
> > the bytenr we care about.  This obviously isn't the case for prealloc extents,
> > where we could have written to the middle of the prealloc extent only, which
> > means the csum would be for the bytenr in the middle of our range and not the
> > front of our range.  Fix this by offsetting the new bytenr we are logging to
> > based on the original bytenr the csum was for.  With this patch I no longer see
> > the csum errors I was seeing.  Thanks,
> > 
> > Cc: stable@vger.kernel.org
> 
> The patch had the right CC but I don't see it in the mail's CC list (now
> added by me). I'm afraid that this never reached stable and explains why
> the patch did not end up in 3.12.1.

No, it made it to my list, I was waiting for 3.13-rc1 to come out with
this patch in it before I could queue it up.  Don't worry, it's not
lost.

thanks,

greg k-h
