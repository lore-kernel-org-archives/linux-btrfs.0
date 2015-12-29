Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35186 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbL2Fc6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 00:32:58 -0500
Received: by mail-wm0-f45.google.com with SMTP id f206so514887wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 21:32:58 -0800 (PST)
Date: Mon, 28 Dec 2015 20:31:11 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151228203111.7ba8b0be@gmail.com>
In-Reply-To: <1451363188.7094.23.camel@scientia.net>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net>
	<20151228153801.6561feff@gmail.com>
	<1451352069.7094.3.camel@scientia.net>
	<20151228164333.2b8d8336@gmail.com>
	<1451360528.7094.7.camel@scientia.net>
	<20151228190336.59a3f440@gmail.com>
	<1451363188.7094.23.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Dec 2015 05:26:28 +0100
Christoph Anton Mitterer <calestyo@scientia.net> wrote:

> I spoke largely from the user/admin side,... running a quite big
> storage Tier-2, we did many IO benchmarks over time (with different
> hardware RAID controllers) and also as our IO patterns changed over
> time...
> The result was that our preferred RAID chunk sizes changed over
> time,...

What is your experience like about running a production system on what
is essentially a beta product? Crashes?

Would something like ZFS not be more suited to your environment?
Especially as not all disks will be full, and, if a disk was to fail,
the entire disk would need to be rebuilt from parity drives (as opposed
to ZFS only using the parity data, and not copying empty blocks
(another feature that is planned for BTRFS)). That alone sells me on
ZFS' capabilities over BTRFS.
 
> Being able to to an online conversion (i.e. on the mounted fs) would
> be nice of course (from the sysadmin's side of view) but even if that
> doesn't seem feasible an offline conversion may be useful (one simply
> may not have enough space left elsewhere to move the data of and
> create a new fs with different RAID chunk size from scratch)
> Both open of course many questions (how to deal with crashes, etc.)...
> maybe having a look at how mdadm handles similar problems could be
> worth.

I do not believe it would be possible to guarantee crash or error
recovery when using an in-place rebuild, without slowing down the
entire rebuild to cache each block before replacing it with the new
block. That would slow it down considerably, as you would have to:

copy to cache > checksum > write in place on disk > checksum new data >
verify checksums

I suppose that is the only proper way to do it anyway, but it will
definitely be slow.

Let me know if that is acceptable, and when the developers come online,
they can also input their ideas.

Thanks.
