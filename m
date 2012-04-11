From: Arvin Schnell <aschnell@suse.de>
Subject: Re: snapper for Ubuntu? (WAS: btrfs auto snapshot)
Date: Wed, 11 Apr 2012 11:53:16 +0200
Message-ID: <20120411095316.GA2850@suse.de>
References: <CAG1y0sdzOXhWowTiBomc6CDEVGJdpJy983P5suQfFC_-NmnYtQ@mail.gmail.com> <20120410114623.GA24057@suse.de> <CAG1y0seZqb+KkSA8Ae0cSfoGWCfBFnPotCM3FUs4q9fND5XjXw@mail.gmail.com> <20120410143557.GC5850@suse.com> <CAG1y0sdnXMuq4d-kDjrS6FkD1+iDBoF0-uz_d_FxwhO2wTP2Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: "Matthias G. Eckermann" <mge@suse.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdnXMuq4d-kDjrS6FkD1+iDBoF0-uz_d_FxwhO2wTP2Lg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 09:50:32PM +0700, Fajar A. Nugraha wrote:
> On Tue, Apr 10, 2012 at 9:35 PM, Matthias G. Eckermann <mge@suse.com>=
 wrote:
> > On 2012-04-10 T 20:48 +0700 Fajar A. Nugraha wrote:
> >> How can I create config for /data or other directories (other than
> >> manually creating the config file and .snapshots directory)?
> >
> > This should do it:
> >
> > sudo snapper -c home create-config /home
> > sudo snapper -c data create-config /data
> >
> > The reasons for the extra "-c <name>" is that you have to
> > tell snapper, which name to choose for the configuration
> > you want to create. This name is the one you can reference
> > in future actions such as create/modify/delete.
>=20
> Great! That works, thanks.
>=20
> Is there an oposite of create-config, i.e. delete for just one subvol=
ume?
> delete-config seems to delete everything (configs for all subvolume
> and all snapshots).

delete-config only deletes one config. Otherwise that is a bug.

> Also, one minor detail, I noticed that the cron configuration file is
> /etc/sysconfig/snapper. It should be /etc/default/snapper in
> ubuntu/debian.

Thanks for the hint.

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
