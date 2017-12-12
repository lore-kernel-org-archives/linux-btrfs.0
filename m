Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43859 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752436AbdLLRov (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 12:44:51 -0500
Date: Tue, 12 Dec 2017 18:42:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/5] define BTRFS_DEV_STATE
Message-ID: <20171212174249.GN3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171210091522.6061-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171210091522.6061-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 10, 2017 at 05:15:17PM +0800, Anand Jain wrote:
> As of now device properties and states are being represented as int
> variable, patches here makes them bit flags instead. Further, wip
> patches such as device failed state needs this cleanup.
> 
> v2:
>  Adds BTRFS_DEV_STATE_REPLACE_TGT
>  Adds BTRFS_DEV_STATE_FLUSH_SENT
>  Drops BTRFS_DEV_STATE_CAN_DISCARD
>  Starts bit flag from the bit 0
>  Drops unrelated change - declare btrfs_device
> 
> v3:
>  Fix static checker warning, define respective dev state as bit number

The define numbers are fixed but the whitespace changes that I made in
misc-next while merging the patches are not in v3. I'd expect that you
update your patches if there's another iteration and there have been
changes to the merged ones, or send me only incrementals to the merged
code or instructions how to fix it up if it's a trivial change like
that.
