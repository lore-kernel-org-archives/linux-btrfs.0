From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Sun, 29 Jan 2012 12:23:39 +0100
Message-ID: <201201291223.40161.kreijack@inwind.it>
References: <pan.2012.01.26.15.41.32@cox.net>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.26.15.41.32@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 26 January, 2012 16:41:32 Duncan wrote:
> 1) My /boot partition and its backup (which I do want to keep separate 
> from root) are only 128 MB each.  The wiki recommends 1 gig sizes 
> minimum, but there's some indication that's dated info due to mixed data/
> metadata mode in recent kernels.
> 
> Is a 128 MB btrfs reasonable?  What's the mixed-mode minumum recommended 
> and what is overhead going to look like?

IIRC, the minimum size should be 256MB. Anyway, if you want/allow a separate 
partition for  /boot I suggest to use a classic filesystem like ext3.

BR
G.Baroncelli
