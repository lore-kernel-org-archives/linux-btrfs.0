From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Tue, 09 Nov 2010 08:42:38 -0500
Message-ID: <1289310046-sup-839@think>
References: <1289236257.3611.3.camel@mars>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Shane Shrybman <shrybman@teksavvy.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1289236257.3611.3.camel@mars>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Shane Shrybman's message of 2010-11-08 12:10:57 -0500:
> Hi,
> 
> Got an oops last week while rebalancing that seems to have left me with
> a corrupted btrfs. Kernel was ~2.6.36 + Transparent hugetlb patchset +
> small misc. patchs.

We have a confirmed and reproducible case where the transparent
hugepages are corrupting btrfs (and only btrfs).  I'll work with Andrea
on figuring out the cause.

So, the first step to trying to fix it is to grab the latest btrfsck and
see if some old copies of the super are working:

btrfsck -s 1 /dev/xxx
btrfsck -s 2 /dev/xxx

-chris
