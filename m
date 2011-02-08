From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: mkfs.btrfs - error checking /dev/sda5 mount status
Date: Tue, 08 Feb 2011 21:00:25 +0100
Message-ID: <4D51A0D9.9000701@libero.it>
References: <iiqphe$217$1@dough.gmane.org>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <iiqphe$217$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/2011 07:57 AM, Lubos Kolouch wrote:
> Hi,
> 
> I'm hitting this issue - sda5 is a normal device, nothing to do with 
> loop, encryption etc.
> 
> # mkfs.btrfs /dev/sda5
> 
> WARNING! - Btrfs v0.19-35-g1b444cd-dirty IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> error checking /dev/sda5 mount status
> 
> Is there something I can do to resolve this?

Some months ago I posted a patch [*] which allows to create a filesystem
even if an integrity tests fail.
Anyway it would be interesting understand why mkfs.btrfs fails. It is
possible to have a strace of the command ?

Regards
G.Baroncelli


> Thank you
> 
> Lubos
> 

[*] email dated 01/03/2011 - subject: [PATCH] add a --force option to
mkfs.btrf [was Re: Odd mkbtrfs behavior inside of chroot]

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

