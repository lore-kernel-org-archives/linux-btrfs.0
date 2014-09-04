Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51166 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755408AbaIDV4y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 17:56:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by gateway2.nyi.internal (Postfix) with ESMTP id 5D25D20B89
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Sep 2014 17:56:54 -0400 (EDT)
Date: Thu, 4 Sep 2014 14:56:08 -0700
From: Greg KH <greg@kroah.com>
To: dsterba@suse.cz, stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        clm@fb.com
Subject: Re: Btrfs stable updates for 3.16.x (and others)
Message-ID: <20140904215608.GD738@kroah.com>
References: <20140819111045.GQ1553@suse.cz>
 <20140903213209.GA20589@kroah.com>
 <20140904163758.GC5636@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140904163758.GC5636@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 04, 2014 at 06:37:58PM +0200, David Sterba wrote:
> On Wed, Sep 03, 2014 at 02:32:09PM -0700, Greg KH wrote:
> > >         6f7ff6d7832c6be13e8c95598884dbc40ad69fb7
> > This doesn't apply to 3.10-stable :(
> > 
> > >         ce62003f690dff38d3164a632ec69efa15c32cbf
> > Neither did this.
> 
> I'm sorry for the trouble. I tried to verify that the patches apply but
> must have missed that.

Care to provide backported patches?

thanks,

greg k-h
