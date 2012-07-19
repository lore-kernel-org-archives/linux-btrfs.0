Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35971 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab2GSB2T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 21:28:19 -0400
Date: Thu, 19 Jul 2012 03:28:05 +0200
From: David Sterba <dave@jikos.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: dave@jikos.cz, Arnd Hannemann <arnd@arndnet.de>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ierdnah@gmail.com
Subject: Re: [PATCH v2] Btrfs: allow mount -o remount,compress=no
Message-ID: <20120719012805.GD17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120406102232.GH14256@twin.jikos.cz>
 <1334582871-3670-1-git-send-email-arnd@arndnet.de>
 <20120416144233.GC20982@twin.jikos.cz>
 <4FE95B45.8030909@arndnet.de>
 <20120628154037.GA28144@twin.jikos.cz>
 <CAKcLGm_cMiEBinmSxkWpY9jm8tW1qbBALcNS-u7DNQhHRF+NFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm_cMiEBinmSxkWpY9jm8tW1qbBALcNS-u7DNQhHRF+NFg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 13, 2012 at 10:19:14AM -0500, Mitch Harder wrote:
> I was testing the lz4(hc) patches, and I found the the compression
> INCOMPAT flags are not being updated using the method in this patch.
> 
> The compression INCOMPAT flags are generally checked and updated in
> the open_ctree() function.
> 
> But, on remount, open_ctree() is not called.

This currently happens with lzo as well, right?

* mount without any compression
* remount -o compress=lzo
* write data
* umount
* => filesystem has lzo data without incompat bit set

> I was going to test a patch to update the INCOMPAT flags similar to
> the way lzo INCOMPAT is updated when specifying the compress method in
> defragmentation.
> 
> http://kerneltrap.org/mailarchive/linux-btrfs/2010/11/18/6886194

This is clear that the incompatibility should be set, because the user
wants it so and the lz4 patches should do the same. I see that the hc
incompatibility does not though, that has to be fixed.

> But, let me know if it is preferred to just return -EINVAL when trying
> to remount with a compression method that has an INCOMPAT not yet seen
> by that volume.

Let's say it returns EINVAL upon remount, then I need to do umount/mount
with the desired option. Remount is usually not done by accident, so
similar to the defrag, I'd expect the operation to succeed, but I as a
user may not know that it brings a backward incompatibility. Getting rid
of an incompat is not straightfoward at all, so I understand the
caution.

My preference is to let remount succeed and set the incompat bit,
possibly with a KERN_INFO message to syslog in case the bit is yet
unseen by the volume.


david
