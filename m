Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45540 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdIPLsC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 07:48:02 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dtBZg-0006jI-5g
        for linux-btrfs@vger.kernel.org; Sat, 16 Sep 2017 13:47:52 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: A user cannot remove his readonly snapshots?!
Date: Sat, 16 Sep 2017 13:47:48 +0200
Message-ID: <20170916134748.00a7e1d8@jupiter.sol.kaishome.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
        <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
        <20170916101901.GM32347@rus.uni-stuttgart.de>
        <e1b1e123-67f5-6911-494e-da9ebdbd65cc@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 16 Sep 2017 13:43:23 +0300
schrieb Marat Khalili <mkh@rqc.ru>:

> On 16/09/17 13:19, Ulli Horlacher wrote:
> > How do I know the btrfs filesystem for a given subvolume?
> > Do I really have to manually test the diretory path upwards?  
> 
> It was discussed recently: the answer is, unfortunately, yes, until 
> someone patches df to do it for us. You can do it more or less 
> efficiently by analyzing /proc/mounts .

Or you do "btrfs device stats .", it shows the associated device(s). You
can put any path instead of "." in the command.

Next, look at "lsblk <devicepath>".

The problem is that the root subvolume id may not be mounted anywhere,
so /proc/mounts may not help.

On my system:

$ sudo btrfs device stats .
[/dev/bcache16].write_io_errs    0
[/dev/bcache16].read_io_errs     0
[/dev/bcache16].flush_io_errs    0
[/dev/bcache16].corruption_errs  0
[/dev/bcache16].generation_errs  0
[/dev/bcache48].write_io_errs    0
[/dev/bcache48].read_io_errs     0
[/dev/bcache48].flush_io_errs    0
[/dev/bcache48].corruption_errs  0
[/dev/bcache48].generation_errs  0
[/dev/bcache32].write_io_errs    0
[/dev/bcache32].read_io_errs     0
[/dev/bcache32].flush_io_errs    0
[/dev/bcache32].corruption_errs  0
[/dev/bcache32].generation_errs  0

$ lsblk /dev/bcache16
NAME     MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
bcache16 254:16   0 925,5G  0 disk /mnt/btrfs-pool


-- 
Regards,
Kai

Replies to list-only preferred.

