Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3JARtA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 13:49:00 -0400
Date: Tue, 1 Oct 2013 10:49:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: dsterba@suse.cz, stable@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: Handful of btrfs fixes for 3.11.x stable
Message-ID: <20131001174910.GA19880@kroah.com>
References: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
 <20130920165301.GA11262@kroah.com>
 <20131001170344.GA8551@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131001170344.GA8551@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
