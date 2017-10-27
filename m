Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56019 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdJ0OPm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 10:15:42 -0400
Date: Fri, 27 Oct 2017 16:13:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, misono.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH] btrfs-progs: when unable to find out fsid of a dev just
 skip
Message-ID: <20171027141351.GJ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171027072848.24702-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171027072848.24702-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 27, 2017 at 03:28:48PM +0800, Anand Jain wrote:
> %fi_args.num_devices provides number of devices excluding the
> seed device. So when looping through the device list for a
> given fsid, determine if the given device is a seed device
> by reading its superblock and then skip it if its a seed device.
> Reading of the superblock is done by the function dev_to_fsid()
> which can fail if the user is not root OR if the device has media
> errors as well. So skip the seed check altogether if we fail to
> know the device superblock and thus the fsid.
> 
> With this now we are able to view the btrfs fi usage when the
> device is bad.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> cc: misono.tomohiro@jp.fujitsu.com
> Fixes:
>   btrfs-progs: fi: enable fi usage for filesystem top of seed device

Thanks, the misc-test/023 fails due to that on my machine, but not in
the CI. I'd like to keep the tree bisectable, so I'll merge the two
patches together.
