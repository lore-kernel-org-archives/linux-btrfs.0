From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: drives with more than 2 TByte
Date: Thu, 24 Mar 2011 20:23:48 +0100
Message-ID: <4D8B9A44.4030604@libero.it>
References: <BiSR8y$i1uB@helmut.hullen.de>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BiSR8y$i1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/24/2011 05:43 PM, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> what about disks with more than 2 TByte? Other filesystems (?) need GPT.

The filesystems don't care about the partition system. The 2TB limits is
related to the maximum partition size. Of course a filesystem cannot be
greater the partition where it is allocated.
> 
> When I use
> 
>    mkfs.btrfs /dev/sdc
> 
> (p.e. with drive sdc), does that work without problems with btrfs?

It should. BTW, why you dont' use a GPT partition table ?
> 
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

