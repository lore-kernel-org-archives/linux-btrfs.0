Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53725 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932327AbaICVcN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 17:32:13 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by gateway2.nyi.internal (Postfix) with ESMTP id C80652095C
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Sep 2014 17:32:11 -0400 (EDT)
Date: Wed, 3 Sep 2014 14:32:09 -0700
From: Greg KH <greg@kroah.com>
To: dsterba@suse.cz, stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        clm@fb.com
Subject: Re: Btrfs stable updates for 3.16.x (and others)
Message-ID: <20140903213209.GA20589@kroah.com>
References: <20140819111045.GQ1553@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140819111045.GQ1553@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 19, 2014 at 01:10:45PM +0200, David Sterba wrote:
> Hi stable team,
> 
> please add the following patches to stable trees.
> 
> Patch #3 applies to all currently live stables, a 7 years old bug. I've
> briefly reviewed all 3 patches against 3.10/12/14/16 (ie. 3.4 skips #1
> and #2).
> 
> Subjects:
>         Btrfs: read lock extent buffer while walking backrefs
>         Btrfs: fix compressed write corruption on enospc
>         Btrfs: fix csum tree corruption, duplicate and outdated checksums
> Commits:
>         6f7ff6d7832c6be13e8c95598884dbc40ad69fb7

This doesn't apply to 3.10-stable :(

>         ce62003f690dff38d3164a632ec69efa15c32cbf

Neither did this.

>         27b9a8122ff71a8cadfbffb9c4f0694300464f3b

Was already marked for stable.

thanks,

greg k-h
