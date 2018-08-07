Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44554 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727155AbeHGUHM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 16:07:12 -0400
Date: Tue, 7 Aug 2018 19:51:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND v8] Add cli and ioctl to forget scanned device(s)
Message-ID: <20180807175138.GR3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180806010949.26915-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180806010949.26915-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 06, 2018 at 09:09:47AM +0800, Anand Jain wrote:
> Adds cli and ioctl to forget a scanned device or forget all stale
> devices in the kernel.

Please provide more details about your idea of the usecase, ie. how
excactly and when the command is supposed to be used.

I vaguely recollect that we've discussed the commandline interface but
don't remember the result. Nevertheless, I think that the 'forget'
command should be an option of 'device scan'.

  btrfs device scan --forget /dev/sda

Next I'm not sure the freeing all stale devices is a good idea. Should
it be more fine grained? Suppose there are several multi-device
filesystems on the host and some of them not mounted. The devices have
been scanned eg. via udev and the filesystems are ready to be mounted.
Calling 'forget all' will now prevent mount without another 'device
scan'.

What if a particular filesystem needs to forget the scanned devices, or
just one filesystem:device.

And there's the question how to specify the devices, it can be by device
path or uuid or maybe device id.
