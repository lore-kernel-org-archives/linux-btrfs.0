From: Kyle Gates <kylegates@hotmail.com>
Subject: RE: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Mon, 30 Jan 2012 08:58:41 -0600
Message-ID: <COL113-W485767962008EF29E7E27EB08D0@phx.gbl>
References: <pan.2012.01.26.15.41.32@cox.net>,<201201291223.40161.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: <linux-btrfs@vger.kernel.org>
To: <kreijack@inwind.it>, <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201201291223.40161.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>


I've been having good luck with my /boot on a separate 1GB RAID1 btrfs filesystem using grub2 (2 disks only! I wouldn't try it with 3). I should note, however, that I'm NOT using compression on this volume because if I remember correctly it may not play well with grub (maybe that was just lzo though) and I'm also not using subvolumes either for the same reason.

Kyle

----------------------------------------
> From: kreijack@inwind.it
> To: 1i5t5.duncan@cox.net
> Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
> Date: Sun, 29 Jan 2012 12:23:39 +0100
> CC: linux-btrfs@vger.kernel.org
>
> On Thursday, 26 January, 2012 16:41:32 Duncan wrote:
> > 1) My /boot partition and its backup (which I do want to keep separate
> > from root) are only 128 MB each. The wiki recommends 1 gig sizes
> > minimum, but there's some indication that's dated info due to mixed data/
> > metadata mode in recent kernels.
> >
> > Is a 128 MB btrfs reasonable? What's the mixed-mode minumum recommended
> > and what is overhead going to look like?
>
> IIRC, the minimum size should be 256MB. Anyway, if you want/allow a separate
> partition for /boot I suggest to use a classic filesystem like ext3.
>
> BR
> G.Baroncelli
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  