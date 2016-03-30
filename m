Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbcC3Nv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 09:51:27 -0400
Date: Wed, 30 Mar 2016 15:50:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Jean-Denis Girard <jd.girard@sysnux.pf>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: page allocation failure
Message-ID: <20160330135051.GC27917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ndfmob$ed5$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ndfmob$ed5$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 07:04:10PM -1000, Jean-Denis Girard wrote:
> Hi list,
> 
> I just started to use send / receive for backups to another drive.
> That's a great feature, but unfortunately I'm getting page allocation
> failure, see below.
> 
> My backup script does something like this for 11 sub-volumes:
>   btrfs subvolume snapshot -r vol /snaps
>   btrfs fi sync /snaps
>   btrfs send -p /snaps/vol_old /snaps/vol | btrfs receive -v /mnt/backup
>   btrfs fi sync /mnt/backup
>   btrfs subvolume delete -c /snaps/vol_old
>   mv /snaps/vol /snaps/vol_old
>   btrfs subvolume delete -c /backup/vol_old
>   btrfs subvolume snapshot -r :backup/vol \
>       /backup/vol_$(date +'%Y%m%d')
>   btrfs fi sync /backup
>   mv /backup/vol /backup/vol_old
> 
> This is on a up-to-date Fedora 23 system, with kernel
> 4.4.6-300.fc23.x86_64, and btrfs-progs v4.4.1 (recompiled on the
> system). The system is mostly idle when the error happens. The backup
> file system seems clean: btrfs check or scrub report no errors.
> 
> [ 3734.651439] btrfs: page allocation failure: order:4, mode:0x2404040

Order 4 is 64k, and most probably it's the allocation of a nodesize, the
IP offset in the function is close to beginning, there are two other
allocations that are served from the slab.

So do you have a filesystem with a 64k nodesize? Just checking.

The memory is fragmented so a contiguous 64k cannot be found, what we
can do is a fallback to vmalloc, that can assemble th 64k memory from
smaller pages. I'll send a patch.
