From: "kreijack@libero.it" <kreijack@libero.it>
Subject: R: [patch 0/4] Size reporting of btrfs tool
Date: Mon, 18 Oct 2010 12:46:56 +0200 (CEST)
Message-ID: <24982145.1571931287398816024.JavaMail.defaultUser@defaultHost>
Reply-To: "kreijack@libero.it" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
To: <hugo-lkml@carfax.org.uk>, <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

please, remember to update the manpage also.

Regards
G.Baroncelli

>----Messaggio originale----
>Da: hugo-lkml@carfax.org.uk
>Data: 17/10/2010 20.26
>A: <linux-btrfs@vger.kernel.org>
>Ogg: [patch 0/4] Size reporting of btrfs tool
>
>While playing around with resizing volumes recently, I realised
>that I didn't know whether btrfs fi show and btrfs fi df reported
>sizes in ISO (e.g. powers of 10^3) units, as they appear to from the
>labels they use, or in binary (powers of 2^10) units. Also, a mere
>three significant figures is somewhat less than I'm comfortable with
>if I'm about to resize the containing block device downwards.
>
>   This patch series adds the ability to pick which scale is used for
>show and df, and labels the amounts properly (e.g. MB for ISO, MiB for
>binary units).
>
>   Hugo.
>
>-- 
>=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>        --- emacs:  Eighty Megabytes And Constantly Swapping. ---        
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


