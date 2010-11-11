From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Unhelpful error message from "btrfs" tool
Date: Thu, 11 Nov 2010 21:32:06 +0100
Message-ID: <201011112132.06687.kreijack@libero.it>
References: <AANLkTi=8e5fBDKhKDOP0ayXCZ5uZrTNVxikM8mwqobGs@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Josh Berry <des@condordes.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=8e5fBDKhKDOP0ayXCZ5uZrTNVxikM8mwqobGs@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 11 November, 2010, Josh Berry wrote:
> Hi,
> 
> I have a cron script that runs periodically, taking new snapshots and
> cleaning up old ones when space gets low on my filesystem.  This
> morning, the script suddenly stopped being able to remove snapshots.
> When I tried to remove one manually, I got the following:
> 
> # btrfs subvol del 2010-11-07-01:17:01
> Delete subvolume '/btrfs/snapshot/2010-11-07-01:17:01'
> ERROR: cannot delete '/btrfs/snapshot/2010-11-07-01:17:01'
> 
> There is nothing in dmesg or in the above output to tell me what the
> problem is, how to fix it, etc.  I'm running kernel 2.6.36, and I
> updated btrfs-progs-unstable to the lastest Git revision
> (1b444cd2e6...), with the same result.
> 
> How do I diagnose this issue?  I'm not even sure where to start.

This error is due to a failure during the ioctl. Could you "strace" btrfs 
subvolume delete ?

# strace btrfs subvolume delete /btrfs/snapshot/2010-11-07-01:17:01

Definetely we need a more verbose error handling, about the return of the 
ioctl.

> 
> Thanks,
> Josh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
