From: Arvin Schnell <aschnell@suse.de>
Subject: Re: snapper for Ubuntu? (WAS: btrfs auto snapshot)
Date: Tue, 10 Apr 2012 13:46:23 +0200
Message-ID: <20120410114623.GA24057@suse.de>
References: <CAG1y0sdzOXhWowTiBomc6CDEVGJdpJy983P5suQfFC_-NmnYtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdzOXhWowTiBomc6CDEVGJdpJy983P5suQfFC_-NmnYtQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 08:18:45AM +0700, Fajar A. Nugraha wrote:
> On Thu, Mar 1, 2012 at 8:48 PM, Arvin Schnell <aschnell@suse.de> wrot=
e:
> > We have now created a project in the openSUSE buildservice were
> > we provide snapper packages for various distributions, e.g. RHEL6
> > and Fedora 16. Please find the downloads at:
> >
> > =A0http://download.opensuse.org/repositories/filesystems:/snapper/
> >
> > I'll also add a link from the snapper home page:
> >
> > =A0http://en.opensuse.org/Portal:Snapper.
> >
> > I have tested snapper on Fedora 16 and found no problems.
>=20
> Hi Arvin,
>=20
> I noticed that openSUSE buildservice now provides debs for ubuntu as
> well. I can't seem to find a way to add it to apt source list though,
> using the usual line
>=20
> deb uri distribution [component1] ....

You can use these commands:

echo 'deb http://download.opensuse.org/repositories/filesystems:/snappe=
r/Debian_6.0/ /' >> /etc/apt/sources.list

apt-get update
apt-get install snapper

Regards,
  Arvin

--=20
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6=
rffer, HRB 16746 (AG N=FCrnberg)
Maxfeldstra=DFe 5
90409 N=FCrnberg
Germany
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
