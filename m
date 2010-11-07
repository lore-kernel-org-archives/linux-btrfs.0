From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: btrfs tool return codes
Date: Sun, 7 Nov 2010 09:10:52 +0100
Message-ID: <201011070910.52583.kreijack@libero.it>
References: <20101107003240.GA7386@vlad.carfax.org.uk>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101107003240.GA7386@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, 07 November, 2010, you (Hugo Mills) wrote:
>    Hi, Goffredo,
> 
>    I'm just looking through the code for the btrfs userspace tool, and
> I was wondering if you had a consistent set of meanings for the return
> codes? There's a bunch of values in the 10-25 range, and some 30s, but
> no apparent documentation for what the codes mean. Were they
> arbitrarily assigned, grandfathered in from something Chris wrote, or
> simply not documented?


When I wrote btrfs I only put attention to the fact that the return codes were 
different. But I din't track the codes, nor documented it!
> 
>    Thanks,
>    Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- But people have always eaten people,  / what else is there to ---  
>          eat?  / If the Juju had meant us not to eat people / he         
>                      wouldn't have made us of meat.                      
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
