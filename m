Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753560AbeFGMUR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 08:20:17 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 39503AD2A
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 12:20:16 +0000 (UTC)
Date: Thu, 7 Jun 2018 14:17:30 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] Add ioctl to clear unused space
Message-ID: <20180607121730.GA3215@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1524233244.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1524233244.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2018 at 04:21:43PM +0200, David Sterba wrote:
> This patchset adds new ioctl similar to TRIM, that provides several
> other ways how to clear the unused space.  The changelogs are
> incomplete, for preview not for inclusion yet.
> 
> It compiles and has been tested lightly, the clearing modes depend on hw
> capabilities (secure discard, sector unmapping instead of zeros), so
> I've tested only zeroing and discard.
> 
> I personally think the zeroing has a usecase and the other modes were
> easy to add. Further extensions can be considered, eg. WRITE_SAME,
> overwriting with a randomly generated pattern, or some filesystem canary
> patterns that can be used to report unused block read as metadata.
> 
> As this is modelled after the generic FITRIM ioctl, so this could be a
> new generic ioctl too. However, last time somebody wanted such ioctl,
> there was a pushback. I'll consider making a generic version and send it
> for comments to fsdevel eventually.
> 
> git://github.com/kdave/btrfs-devel dev/zero-free
> 
> 
> David Sterba (6):
>   btrfs: extend trim callchain to pass the operation type
>   btrfs: add wrapper to switch clearing operation
>   btrfs: add zeroing clear operation
>   btrfs: add new ioctl BTRFS_IOC_CLEAR_FREE
>   btrfs: add discard secure to clear unused space
>   btrfs: add more zeroout modes for clearing unused space

For the record, this patchset has been shifted to 4.19 or later.
