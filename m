From: David Brown <david@westcontrol.com>
Subject: Re: Confused by performance
Date: Thu, 17 Jun 2010 08:57:01 +0200
Message-ID: <hvch0f$jme$1@dough.gmane.org>
References: <4BFAEABD.2070700@noir.com>	<4BFF2024.3040509@noir.com>	<4C191330.5060905@noir.com>	<4C19243E.9050507@robertoragusa.it>	<AANLkTinM6ab_KEynfgvVT9v5TmcogoLZ0PLAz2oPnsiS@mail.gmail.com> <AANLkTimKGCk7KlD4KQ8oXhnnOf0pj3VzzDmzzBIK0bNn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimKGCk7KlD4KQ8oXhnnOf0pj3VzzDmzzBIK0bNn@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 16/06/2010 21:35, Freddie Cash wrote:
> <snip a lot of fancy math that missed the point>
>
> That's all well and good, but you missed the part where he said ext2
> on a 5-way LVM stripeset is many times faster than btrfs on a 5-way
> btrfs stripeset.
>
> IOW, same 5-way stripeset, different filesystems and volume managers,
> and very different performance.
>
> And he's wondering why the btrfs method used for striping is so much
> slower than the lvm method used for striping.
>

This could easily be explained by Roberto's theory and maths - if the 
lvm stripe set used large stripe sizes so that the random reads were 
mostly read from a single disk, it would be fast.  If the btrfs stripes 
were small, then it would be slow due to all the extra seeks.

Do we know anything about the stripe sizes used?


