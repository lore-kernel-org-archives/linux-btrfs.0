Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52605 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753005AbdLNPSt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 10:18:49 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 50580ADF1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 15:18:48 +0000 (UTC)
Date: Thu, 14 Dec 2017 16:16:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix bio leak
Message-ID: <20171214151642.GJ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1513165807-12261-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513165807-12261-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 13, 2017 at 01:50:07PM +0200, Nikolay Borisov wrote:
> Commit e0ae99941423 ("btrfs: preallocate device flush bio") reworked
> the way the flush bio is allocated and used. Concretely it allocates
> the bio in __alloc_device and then re-uses it multiple times with a
> very simple endio routine that just calls complete() without consuming
> a reference. Allocated bios by default come with a ref count of 1,
> which is then consumed by the endio routine (or not, in which case they
> should be bio_put by the caller). The way the impleementation works now
> is that the flush bio has a refcount of 2 and we only ever bio_put it
> once, leaving it to hang indefinitely. Fix this by removing the extra
> bio_get in __alloc_device.
> 
> Fixes: e0ae99941423 ("btrfs: preallocate device flush bio")

Sigh, so many bugs. Hopefully that was the last one.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
