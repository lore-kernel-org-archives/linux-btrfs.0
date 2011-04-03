From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: minor ID for btrfs-control
Date: Sun, 03 Apr 2011 12:24:05 +0200
Message-ID: <4D984AC5.3040207@libero.it>
References: <Bj8lm4ND1uB@helmut.hullen.de>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj8lm4ND1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Helmut,

On 04/03/2011 05:11 AM, Helmut Hullen wrote:
> Hallo, Goffredo,
[..]
>> As wrote by Tomasz the minor number of the btrfs-control is allocated
>> dynamically.
> 
> At which place?

I replied you too fast. Btrfs register a "misc" device, but its number
is not dynamically allocated (see [1] for further information), but it
is static.

$ grep BTRFS_MINOR -r include/
include/linux/miscdevice.h:#define BTRFS_MINOR          234

I can conclude that _now_ the minor is 234 and not 55. But I don't know
if it is a _stable_ interface.

I think that during the boot you should check the minor with

grep btrfs-control /proc/misc | awk '{ print $1 }'


Regards
G.Baroncelli

[1] http://www.linuxjournal.com/article/2920

> 
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

