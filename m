From: Chris Samuel <chris@csamuel.org>
Subject: Re: BUG while writing to USB btrfs filesystem
Date: Mon, 31 Jan 2011 13:57:17 +1100
Message-ID: <4D46250D.2090403@csamuel.org>
References: <AANLkTimjuO=RcVciFCo5MKPnVArvXBLnhs2taS5cOw6f@mail.gmail.com>	<AANLkTim6a_xv7gf-OHbhtV75eJesCF4gLDB-aHxkM-PX@mail.gmail.com> <AANLkTim_+yfC4i21uu65eaEapjwdc6X2yV9bunwXezOx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_+yfC4i21uu65eaEapjwdc6X2yV9bunwXezOx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 31/01/11 12:33, cwillu wrote:

> [33159.490003] kernel BUG at /home/kernel-ppa/COD/linux/fs/btrfs/inode.c:1629!

It looks like this happens when btrfs_drop_extents() returns
an error, and in the code the only time that seems to happen
without already calling BUG_ON() is if it runs out of memory
at the very start:

        path = btrfs_alloc_path();
        if (!path)
                return -ENOMEM;

Is there anything in the log from before that oops ?

NB: I just did a quick scan of btrfs_drop_extents() so it's
possible I missed something..

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
