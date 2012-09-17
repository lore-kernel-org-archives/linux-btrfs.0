Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52317 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2IQQTx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 12:19:53 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TDe36-000057-Pt
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 09:19:52 -0700
Date: Mon, 17 Sep 2012 09:19:52 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Root dentry has weird name <>
Message-ID: <20120917161952.GD18661@merlins.org>
References: <20120914170912.GH19051@merlins.org> <20120917161753.GU17430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120917161753.GU17430@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 06:17:53PM +0200, David Sterba wrote:
> On Fri, Sep 14, 2012 at 10:09:12AM -0700, Marc MERLIN wrote:
> > I only have btrfs on my laptop and just started getting this.
> 
> Afaik, this is not directly related to btrfs. Search for the "Root
> dentry has weird name" message and you'll see occurences from kernel
> 3.0, 3.1.
> 
> > I'm not too clear about whether it's in memory or on my filesystem somewhere.
> 
> It's reflecting a in-memory state.
> 
> > Can you recommend what I should do: reboot? fsck somehow? other?
> 
> Reboot should help, also check for potential NFS problems, like
> unreachable server.

Thanks for your answer. I indeed should have searched that first instead of
assuming it was btrfs related.
I can also confirm that rebooting made the message go away.

Thanks for your answer and sorry for posting to the wrong list.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
