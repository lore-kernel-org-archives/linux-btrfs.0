From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH 1/3] Btrfs: Really return keys within specified range]
Date: Wed, 15 Dec 2010 20:13:17 +0100
Message-ID: <201012152013.17512.kreijack@libero.it>
References: <4D05EBC9.6020908@cn.fujitsu.com> <201012151942.23924.kreijack@libero.it> <1292438562-sup-7107@think>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292438562-sup-7107@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 15 December, 2010, Chris Mason wrote:
[...]
> > 
> > Hi Chris,
> > 
> > I am a bit confused about your answer.
> > 
> > The actual API is a bit confused (or almost not "obvious"). An application 
in 
> > order to work properly has to make some adjustment to the min_* fields AND 
> > filter the results (because if we tweak with the min_* field, not useful 
data 
> > is returned). Moreover this  means that we move between user-space<-
>kernel-
> > space a lot of unused data (un-necessary context switch).
> > 
> > On the basis of your answer, it seems that this is ok (please don't 
consider 
> > only the case of listing the subvolumes which is a very simple cases). And 
> > nothing have to do.
> 
> Well, it's ok in that I wanted the API to be very close to the way
> searches are done in the kernel.  I'll definitely agree it isn't
> perfect, especially as we hop between objectids or types.
> 
> But I don't want to extend it just yet, mostly because we don't have new
> applications making use of it.  I'd rather couple any new apis with new
> applications that we haven't yet thought of.
> 
> Thanks a lot for the time you're spending on review and looking at this.
> If you have killer apps that can really make use of new APIs, I'm happy
> to start reworking things.

Look at a my previous email about an enhancement of the find-new command 
([RFC] Improve btrfs subvolume find-new command - 11/12/2010). 
It would be sufficient ? (of course now on the basis of the last news of this 
API I know that this command is bugged :-( )

I can live with the current API ( tweaking the increasing of the min_* 
fields).. but think about another side of the question: now the only client of 
this API is the btrfs command (btrfs subvol list, which actually is broken) , 
and we can update this api with the minimum effort. Instead if we leave the 
current behavior in the future may appears an application which depends on it. 
So we may be obligated to maintain it ..



Goffredo
> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
