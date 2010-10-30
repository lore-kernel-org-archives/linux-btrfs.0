From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [patch 0/2] Control filesystem balances (userspace)
Date: Sat, 30 Oct 2010 19:49:12 +0200
Message-ID: <201010301949.12516.kreijack@libero.it>
References: <20101030001022.247934404@carfax.org.uk>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101030001022.247934404@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 30 October, 2010, Hugo Mills wrote:
>    These two patches complement the previous two kernel-side
> patches. The first implements a way of displaying the current progress
> of any running balance process. The second patch allows a running
> balance to be cancelled.
> 
>    I'm a bit uncertain about the best name for these commands. Several
> options:
> 
[...]
> 
> 4)
> btrfs balance progress <path>
> btrfs balance cancel <path>
> 
>    My current favourite, although we introduce a new namespace
> ("balance") for commands. We could add "btrfs balance start <path>" as
> a synonym for "btrfs filesystem balance <path>", for some degree of
> consistency.

I like this.

Regards
G.Baroncelli
> 
>    At some point, I'll add a "monitor" function, which will poll at 1s
> intervals for progress updates, and print out progress when it changes.
> 
>    Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>    --- "No!  My collection of rare, incurable diseases! Violated!" ---   
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
