Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37194 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbdKFN0E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 08:26:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C8540AAC5
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 13:26:02 +0000 (UTC)
Date: Mon, 6 Nov 2017 14:24:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/11] btrfs: add missing device::flush_bio puts
Message-ID: <20171106132411.GA28789@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1509471604.git.dsterba@suse.com>
 <0c6045183bbefe81b5e37cf0c84e31c5193ba191.1509471604.git.dsterba@suse.com>
 <9e15868b-4337-b735-528e-d9b53c068ec1@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9e15868b-4337-b735-528e-d9b53c068ec1@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 02, 2017 at 11:41:44AM +0200, Nikolay Borisov wrote:
> 
> 
> On 31.10.2017 19:44, David Sterba wrote:
> > This fixes potential bio leaks, in several error paths. Unfortunatelly
> > the device structure freeing is opencoded in many places and I missed
> > them when introducing the flush_bio.
> > 
> > Most of the time, devices get freed through call_rcu(..., free_device),
> > so it at least it's not that easy to hit the leak, but it's still
> > possible through the path that frees stale devices.
> > 
> > Fixes: e0ae99941423 ("btrfs: preallocate device flush bio")
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
> Verified that every kfree(device) has a matching bio_put via:
> 
> grep -ir -B2 "kfree(dev.*)" fs/btrfs/volumes.c

I've used this coccinelle script to cross-check, in case the variable is
is not named 'dev*':

<smpl>
@@
struct btrfs_device *DEV;
@@
* kfree(DEV);
</smpl>
