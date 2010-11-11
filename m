From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Unhelpful error message from "btrfs" tool
Date: Thu, 11 Nov 2010 14:10:04 -0600
Message-ID: <AANLkTin1Ra8MMCxL1Nsbyog82ke7yemAFur_XQ_1NuXj@mail.gmail.com>
References: <AANLkTi=8e5fBDKhKDOP0ayXCZ5uZrTNVxikM8mwqobGs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josh Berry <des@condordes.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=8e5fBDKhKDOP0ayXCZ5uZrTNVxikM8mwqobGs@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 11, 2010 at 2:04 PM, Josh Berry <des@condordes.net> wrote:
> Hi,
>
> I have a cron script that runs periodically, taking new snapshots and
> cleaning up old ones when space gets low on my filesystem. =A0This
> morning, the script suddenly stopped being able to remove snapshots.
> When I tried to remove one manually, I got the following:
>
> # btrfs subvol del 2010-11-07-01:17:01
> Delete subvolume '/btrfs/snapshot/2010-11-07-01:17:01'
> ERROR: cannot delete '/btrfs/snapshot/2010-11-07-01:17:01'
>
> There is nothing in dmesg or in the above output to tell me what the
> problem is, how to fix it, etc. =A0I'm running kernel 2.6.36, and I
> updated btrfs-progs-unstable to the lastest Git revision
> (1b444cd2e6...), with the same result.
>
> How do I diagnose this issue? =A0I'm not even sure where to start.

do you have other nested subvols in it by accident?  try `btrfs sub
list` to be sure.

and it's not mounted right?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
