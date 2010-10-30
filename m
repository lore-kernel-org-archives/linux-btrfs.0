From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: [patch 0/2] Control filesystem balances (userspace)
Date: Fri, 29 Oct 2010 20:30:50 -0400
Message-ID: <7786692913512733804@unknownmsgid>
References: <20101030001022.247934404@carfax.org.uk>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101030001022.247934404@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

You could always use btrfs filesystem balance progress which would not
introduce a new root level option and still be short to type. That
would mean balance should have a "start" option or default to start
when no sub options are used.

Sent from my mobile device.

On 2010-10-29, at 20:11, Hugo Mills <hugo@carfax.org.uk> wrote:

>   These two patches complement the previous two kernel-side
> patches. The first implements a way of displaying the current progress
> of any running balance process. The second patch allows a running
> balance to be cancelled.
>
>   I'm a bit uncertain about the best name for these commands. Several
> options:
>
> 1)
> # btrfs filesystem progress <path>
> # btrfs filesystem cancel <path>
>
>   Way too vague (cancel *what*?)
>
>
> 2)
> # btrfs filesystem balance-progress <path>
> # btrfs filesystem balance-cancel <path>
>
>   Clashes horribly with "filesystem balance" -- no abbreviations
> possible.
>
>
> 3)
> btrfs filesystem balance -p <path>
> btrfs filesystem balance -c <path>
>
>   Changes behaviour significantly on a switch, in contrast to the
> behaviour of the rest of the btrfs tool.
>
>
> 4)
> btrfs balance progress <path>
> btrfs balance cancel <path>
>
>   My current favourite, although we introduce a new namespace
> ("balance") for commands. We could add "btrfs balance start <path>" as
> a synonym for "btrfs filesystem balance <path>", for some degree of
> consistency.
>
>   At some point, I'll add a "monitor" function, which will poll at 1s
> intervals for progress updates, and print out progress when it changes.
>
>   Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- "No!  My collection of rare, incurable diseases! Violated!" ---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
