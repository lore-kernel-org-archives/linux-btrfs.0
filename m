Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:43929 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3CKXuO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 19:50:14 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E44487C0435
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 17:50:13 -0600 (MDT)
Date: Mon, 11 Mar 2013 19:49:52 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Matthew Booth <matthew@heisenbug.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Unable to boot btrfs filesystem, and btrfsck aborts
Message-ID: <20130311234952.GF3058@localhost.localdomain>
References: <CAF8C-HiwkgnuMOgq_4AGYoK9pOKZoL-WGYVFc497BuU+_z2GbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAF8C-HiwkgnuMOgq_4AGYoK9pOKZoL-WGYVFc497BuU+_z2GbQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 04:44:58PM -0600, Matthew Booth wrote:
> My laptop crashed hard earlier today. It reset immediately to a black
> screen followed by the BIOS. I have no idea why.
> 
> However, it now fails to boot. I took a picture of the kernel panic
> that results from trying to mount the root filesystem:
> https://plus.google.com/107763699965053810188/posts/QZZt7GYzBZi
> 
> To make things worse, btrfsck aborts with a double free, without
> fixing it. I took a picture of that, too:
> https://plus.google.com/107763699965053810188/posts/gKYqGgFhWyT
> 
> As the kernel panic mentions btrfs_remove_free_space, I also tried
> mounting with clear_cache. Unfortunately it didn't dislodge anything.
> 
> This is on a fully updated Fedora 18 system. I would really like to
> get this data back. If anybody could offer a suggestion I'd be very
> grateful.
>

This is fixed in 3.9, I'll send those patches back to -stable, sorry I should
have done that before now.  If you can't get a 3.9 kernel to boot then just use
btrfs-zero-log and you'll be good to go.  Thanks,

Josef 
