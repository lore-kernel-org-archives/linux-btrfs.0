Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40027 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936216AbeCBPUZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 10:20:25 -0500
Date: Fri, 2 Mar 2018 16:18:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Menion <menion@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: dmesg flooded with "Very big device. Trying to use READ
 CAPACITY(16)" with 8TB HDDs
Message-ID: <20180302151805.GB5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJVZm6etk=bL0LY3FZXkm5Wun64F4w6HMxdLhKRD-v+mEGm08w@mail.gmail.com>
 <CAJVZm6e0+urcBNrVkXSwvuckTt1A2R8uj536ZzHcB9eG9FoqpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJVZm6e0+urcBNrVkXSwvuckTt1A2R8uj536ZzHcB9eG9FoqpQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 12:37:49PM +0100, Menion wrote:
> Is it really a no problem? I mean, for some reason BTRFS is
> continuously read the HDD capacity in an array, that does not seem to
> be really correct

The message comes from SCSI:
https://elixir.bootlin.com/linux/latest/source/drivers/scsi/sd.c#L2508

Reading drive capacity could be totally opaque for the filesystem, eg.
when the scsi layer compares the requested block address with the device
size.

The sizes of blockdevices is obtained from the i_size member of the
inode representing the block device, so there's no direct read by btrfs.
You'd have better luck reporting that to scsi or block layer
mailinglists.
