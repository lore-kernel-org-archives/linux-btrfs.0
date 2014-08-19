Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbaHSPds (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:33:48 -0400
Message-ID: <53F36E58.1090108@redhat.com>
Date: Tue, 19 Aug 2014 10:33:44 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs-progs: random fixes of btrfs-filesystem documentation
References: <53E888C3.70807@jp.fujitsu.com> <53E8F7F0.3060300@redhat.com> <20140819151005.GX1553@twin.jikos.cz>
In-Reply-To: <20140819151005.GX1553@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/19/14, 10:10 AM, David Sterba wrote:
> On Mon, Aug 11, 2014 at 10:05:52AM -0700, Eric Sandeen wrote:
>> (What seems to be missing, though, is why would the user ever choose to use '-d?')
> 
> That's a fallback method if blkid or udev are not available. We've had
> reports in the past that this functionality should not be dropped.

Seems like using /proc/partitions would make more sense in that case
than a recursive scan of every file under /dev, wouldn't it?
Any details on those reports?

I'm just wondering when you might possibly have success looking deep
into the /dev tree if you didn't have success in /proc/partitions.

It looks like the functionality was added with:

commit 0dbd99fb3e117cd5f87eda492b6b4fab1b5bea23
Author: Goffredo Baroncelli <kreijack@inwind.it>
Date:   Wed Jun 15 21:55:25 2011 +0200

    Scan the devices listed in /proc/partitions
    
    During the commands:
        - btrfs filesystem show
        - btrfs device scan
    the devices "scanned" are extracted from /proc/partitions. This
    should avoid to scan devices not suitable for a btrfs filesystem like cdrom
    and floppy or to scan not existant devices.
    The old behavior (scan all the block devices under /dev) may be
    forced passing the "--all-devices" switch.

but I'm not sure why it was preserved.

It just seems a bit bizarre to have so many ways to get the same info.

Thanks,
-Eric

