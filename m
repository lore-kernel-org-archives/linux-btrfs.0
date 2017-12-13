Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752854AbdLMC2U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 21:28:20 -0500
Date: Wed, 13 Dec 2017 03:26:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/5] define BTRFS_DEV_STATE
Message-ID: <20171213022619.GD3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171210091522.6061-1-anand.jain@oracle.com>
 <20171212174249.GN3553@twin.jikos.cz>
 <d37abb08-087f-7372-2196-c98b60229b63@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d37abb08-087f-7372-2196-c98b60229b63@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 13, 2017 at 06:38:12AM +0800, Anand Jain wrote:
> 
> 
> On 12/13/2017 01:42 AM, David Sterba wrote:
> > On Sun, Dec 10, 2017 at 05:15:17PM +0800, Anand Jain wrote:
> >> As of now device properties and states are being represented as int
> >> variable, patches here makes them bit flags instead. Further, wip
> >> patches such as device failed state needs this cleanup.
> >>
> >> v2:
> >>   Adds BTRFS_DEV_STATE_REPLACE_TGT
> >>   Adds BTRFS_DEV_STATE_FLUSH_SENT
> >>   Drops BTRFS_DEV_STATE_CAN_DISCARD
> >>   Starts bit flag from the bit 0
> >>   Drops unrelated change - declare btrfs_device
> >>
> >> v3:
> >>   Fix static checker warning, define respective dev state as bit number
> > 
> > The define numbers are fixed but the whitespace changes that I made in
> > misc-next
> 
>   Will do next time. Thanks. I don't see misc-next. Is it for-next ?

The kernel.org repository only gets the latest for-next, that is
assembled from the pending branches, and also after some testing. You
could still find 'misc-next' inside the for-next branch, but it's not
obvious.

All the development branches are pushed to

https://github.com/kdave/btrfs-devel or
http://repo.or.cz/linux-2.6/btrfs-unstable.git

more frequently than the k.org/for-next is updated. I thought this has
become a common knowledge, but yet it's not documented on the wiki so.
Let's fix that.
