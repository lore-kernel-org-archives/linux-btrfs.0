Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab3GRRdj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 13:33:39 -0400
Date: Thu, 18 Jul 2013 19:33:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Florian Lindner <mailinglists@xgm.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Questions about multi-device behavior
Message-ID: <20130718173337.GN24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1860433.azE0Vf7tMy@horus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1860433.azE0Vf7tMy@horus>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 17, 2013 at 11:24:22PM +0200, Florian Lindner wrote:
> I create a btrfs volume comprised of two partitions:
> 
> # mkfs.btrfs -m dup -d single /dev/sdd1 /dev/sde1

DUP does not work on multiple devices, I assume you mean RAID1.

> metadata ist mirrored on each device, data chunks are scattered more or less 
> randomly on one disk. 
> 
> a) If one disk fails, is there any chance of data recovery? 
> b) If not, is there any advantage over a raid0 configuration.

Regarding data layout, raid0 will always place the small (64k) chunks on
multiple devices, with single this does not happen every time and the
data are spread in larger contiguous chunks on each of the device.
Rewriting data makes the placement unpredictable, so it may end up
random.

The missing data blocks return IO error and the valid data can be read.


david
