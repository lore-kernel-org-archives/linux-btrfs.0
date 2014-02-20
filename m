Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbaBTQ5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 11:57:45 -0500
Date: Thu, 20 Feb 2014 17:57:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH] btrfs: Allow forced conversion of metadata to dup
 profile on multiple devices
Message-ID: <20140220165743.GT16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5304D781.6020309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5304D781.6020309@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 19, 2014 at 11:10:41AM -0500, Austin S Hemmelgarn wrote:
> Currently, btrfs balance start fails when trying to convert metadata or
> system chunks to dup profile on filesystems with multiple devices.  This
> requires that a conversion from a multi-device filesystem to a single
> device filesystem use the following methodology:
>     1. btrfs balance start -dconvert=single -mconvert=single \
>        -sconvert=single -f /
>     2. btrfs device delete / /dev/sdx
>     3. btrfs balance start -mconvert=dup -sconvert=dup /
> This results in a period of time (possibly very long if the devices are
> big) where you don't have the protection guarantees of multiple copies
> of metadata chunks.
> 
> After applying this patch, one can instead use the following methodology
> for conversion from a multi-device filesystem to a single device
> filesystem:
>     1. btrfs balance start -dconvert=single -mconvert=dup \
>        -sconvert=dup -f /
>     2. btrfs device delete / /dev/sdx
> This greatly reduces the chances of the operation causing data loss due
> to a read error during the device delete.
> 
> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

Sounds useful. The muliple devices + DUP is allowed setup when the
device is added, this patch only adds the 'delete' counterpart. The
imroved data loss protection during the process is a good thing.
