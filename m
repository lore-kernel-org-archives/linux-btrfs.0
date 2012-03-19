From: Martin Steigerwald <ms@teamix.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Mon, 19 Mar 2012 17:03:09 +0100
Message-ID: <201203191703.10539.ms@teamix.de>
References: <201112171833.34720.Martin@lichtvoll.de> <201203190931.26493.ms@teamix.de> <20120319154810.GB8176@kroah.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120319154810.GB8176@kroah.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 19. M=E4rz 2012 schrieb Greg Kroah-Hartman:
> On Mon, Mar 19, 2012 at 09:31:24AM +0100, Martin Steigerwald wrote:
> > > <formletter>
> > >=20
> > > This is not the correct way to submit patches for inclusion in th=
e
> > > stable kernel tree.  Please read Documentation/stable_kernel_rule=
s.txt
> > > for how to do this properly.
> > >=20
> > > </formletter>
> >=20
> > What point of the rules do you refer to? Is it
> >=20
> >  - It or an equivalent fix must already exist in Linus' tree (upstr=
eam).
>=20
> Yes.
>=20
> Without that, there's nothing I can do with this.
>=20
> > Or do you want the patch quoted in the mail?
> >=20
> > Anyways its not yet in linus tree AFAIR and from my side it was a
> > question whether it should be included at all. I thought it might b=
e
> > good ccing you on that question already.
>=20
> It's nice, yes, but note that you sent this to me directly, didn't cc=
:
> the proper stable mailing list so that others who maintain other stab=
le
> trees also didn't get the notice, and again, there's really nothing t=
hat
> the stable maintainers can do about this at the moment.

I did, but got the address wrong, missed the vger in it.

Anyway, I try to follow-up on this, when its in Linus tree (via git wai=
t and=20
notify for commit? - nah just kidding, but would be useful ;)

Thanks,
--=20
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
