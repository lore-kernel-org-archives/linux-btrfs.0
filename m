From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Mon, 08 Nov 2010 12:55:02 -0500
Message-ID: <1289238847-sup-3860@think>
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

Have you tried the 2.6.36 + the btrfs unstable git tree?  It may be able
to help here.

If that doesn't do it we'll have to try old copies of the super block.
I doubt balancing caused this corruption, it probably dug up an old
corruption because it reads every single metadata block on the FS.

-chris
