Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924AbaGXKsB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 06:48:01 -0400
Date: Thu, 24 Jul 2014 12:47:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: feature request: consider rw subvols ro for send when volume is
 mounted ro
Message-ID: <20140724104758.GP1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <EAC867F7-CBB2-4714-9917-A29566167A21@colorremedies.com>
 <20140723204736.GD17798@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140723204736.GD17798@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 23, 2014 at 01:47:36PM -0700, Zach Brown wrote:
> On Wed, Jul 23, 2014 at 02:10:29PM -0600, Chris Murphy wrote:
> > The use case is when it's possible to mount a Btrfs volume ro, but not rw. Example, a situation where
> > 
> > # mount -o degraded /dev/sdb /mnt
> > [   71.064352] BTRFS info (device sdb): allowing degraded mounts
> > [   71.064812] BTRFS info (device sdb): enabling auto recovery
> > [   71.065210] BTRFS info (device sdb): disk space caching is enabled
> > [   71.072068] BTRFS warning (device sdb): devid 2 missing
> > [   71.097320] BTRFS: too many missing devices, writeable mount is not allowed
> > [   71.116616] BTRFS: open_ctree failed
> > 
> > Yet this works:
> > # mount -o degraded,ro /dev/sdb /mnt
> > 
> > It would be great if it were possible to send/receive subvolumes to a
> > different btrfs volume. Currently it's not possible because those
> > subvols aren't ro, and because the mount is ro I can't make ro
> > snapshots first.
> 
> I wonder if that's as easy as the following totally untested hack.  I
> have no idea if a read-only mount would still allow background
> modification that might violate the send code's assumptions.

RO mount tries hard not to do any writes (eg. the from the background
threads), however a remount to RW during send would succeed and any
writes to the sent subvolume may (and most probably will) cause lots of
fun.

This could use similar protection as the subvolumes, the usecase 'allow
to send any subvolume on a RO mount' seems valid to me. The failure of
remount,rw is not silent and the user is able to decide what to do next
(stop send, or postpone remount). Remount may fail for other reasons so
I think we're not adding some unexpected surprises.
