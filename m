Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34078 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbcAJHNQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 02:13:16 -0500
Received: by mail-wm0-f41.google.com with SMTP id u188so180202029wmu.1
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jan 2016 23:13:15 -0800 (PST)
Date: Sat, 9 Jan 2016 22:11:05 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.cz>, jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20160109221105.6b18fb8e@gmail.com>
In-Reply-To: <56887B40.10105@gmx.com>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net>
	<20151228153801.6561feff@gmail.com>
	<1451352069.7094.3.camel@scientia.net>
	<20151228164333.2b8d8336@gmail.com>
	<1451360528.7094.7.camel@scientia.net>
	<20151228190336.59a3f440@gmail.com>
	<1451363188.7094.23.camel@scientia.net>
	<20151229180643.GD4227@twin.jikos.cz>
	<20160102065207.4eec760a@gmail.com>
	<56887B40.10105@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 3 Jan 2016 09:37:04 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> Btrfs checksum are calculated in 3 different method:
> 1) Metadata: Per nodesize, stored in tree blocker header. (struct 
> btrfs_header->csum)
> 2) Data: Per sectorsize, stored in csum tree.
> 3) Superblock: Per 4K (fixed), stored in its header (struct 
> btrfs_super->csum)
> 
> I didn't the need to change any of them, as you are not changing any
> of the csum behavior.

Good, that means I do not need to compare csums, just the data at the
end of the re-sizing operation. 

I have finished most of the actual implementation details and 
documentation for the re-size. However, before I undertake the last 
part of the development, the integration of kernel-space and user-space,
as well as the integration between my code and the kernel code. 

> Stripe size only affect how btrfs does IO, not the csum size.

I have a question regarding this statement. I wanted to confirm that
the re-size will result in all the data blocks being re-written. Is
that correct? 
Because the single statement above may also mean that all that needs to
be done is change one option and the kernel code takes care of the rest.

Just clarify that for me.
 
> And since you are making the stripe size configurable, then user is 
> responsible for any too large or too small stripe size setting.

I have also left the option to use an un-conventional stripe size to the
user, for e.g., 768, 3072, 6144, etc.

Thanks.
