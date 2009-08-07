From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID[56] status
Date: Fri, 7 Aug 2009 11:43:10 +0200
Message-ID: <774E55AE-1639-4537-B001-E8F96311F4CD@karlsbakk.net>
References: <1249553833.568.23.camel@macbook.infradead.org>
Reply-To: linux-btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=UTF-8;
	format=flowed	delsp=yes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1249553833.568.23.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

This is great. How does the current code handle corruption on a drive, =
=20
or two drives with RAID-6 in a stripe? Is the checksumming done per =20
drive or for the whole stripe?

roy

On 6. aug.. 2009, at 12.17, David Woodhouse wrote:

> If we've abandoned the idea of putting the number of redundant blocks
> into the top bits of the type bitmask (and I hope we have), then we'r=
e
> fairly much there. Current code is at:
>
>   git://, http://git.infradead.org/users/dwmw2/btrfs-raid56.git
>   git://, http://git.infradead.org/users/dwmw2/btrfs-progs-raid56.git
>
> We have recovery working, as well as both full-stripe writes and a
> temporary hack to allow smaller writes to work (with the 'write hole'
> problem, of course). The main thing we need to do is ensure that we
> _always_ do full-stripe writes, and then we can ditch the partial =20
> write
> support.
>
> I want to do a few other things, but AFAICT none of that needs to =20
> delay
> the merge:
>
>  - Better rebuild support -- if we lose a disk and add a replacement,
>    we want to recreate only the contents of that disk, rather than
>    allocating a new chunk elsewhere and then rewriting _everything_.
>
>  - Support for more than 2 redundant blocks per stripe (RAID[789] or
>    RAID6[=C2=B3=E2=81=B4=E2=81=B5] or whatever we'll call it).
>
>  - RAID[56789]0 support.
>
>  - Clean up the discard support to do the right thing.
>
> --=20
> David Woodhouse                            Open Source Technology =20
> Centre
> David.Woodhouse@intel.com                              Intel =20
> Corporation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-=20
> btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres =20
intelligibelt. Det er et element=C3=A6rt imperativ for alle pedagoger =C3=
=A5 =20
unng=C3=A5 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de=
 =20
fleste tilfeller eksisterer adekvate og relevante synonymer p=C3=A5 nor=
sk.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
