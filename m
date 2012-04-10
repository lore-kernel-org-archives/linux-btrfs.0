From: "Matthias G. Eckermann" <mge@suse.com>
Subject: Re: snapper for Ubuntu? (WAS: btrfs auto snapshot)
Date: Tue, 10 Apr 2012 16:35:57 +0200
Message-ID: <20120410143557.GC5850@suse.com>
References: <CAG1y0sdzOXhWowTiBomc6CDEVGJdpJy983P5suQfFC_-NmnYtQ@mail.gmail.com> <20120410114623.GA24057@suse.de> <CAG1y0seZqb+KkSA8Ae0cSfoGWCfBFnPotCM3FUs4q9fND5XjXw@mail.gmail.com>
Reply-To: "Matthias G. Eckermann" <mge@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>,
	Arvin Schnell <aschnell@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0seZqb+KkSA8Ae0cSfoGWCfBFnPotCM3FUs4q9fND5XjXw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-04-10 T 20:48 +0700 Fajar A. Nugraha wrote:
=20
> Anyway, I got snapper-0.0.10-0 installed now, but having a small
> problem. I use different subvolumes for multiple directories. For
> example, /home and /data. Creating the config for both results in an
> error
>=20
> $ sudo snapper list-configs
> Config | Subvolume
> -------+----------
> $ sudo snapper create-config /home
> $ sudo snapper create-config /data
> Creating config failed (config already exists).
> $ sudo snapper list-configs
> Config | Subvolume
> -------+----------
> root   | /home
>=20
> How can I create config for /data or other directories (other than
> manually creating the config file and .snapshots directory)?
=20
This should do it:

sudo snapper -c home create-config /home
sudo snapper -c data create-config /data

The reasons for the extra "-c <name>" is that you have to
tell snapper, which name to choose for the configuration
you want to create. This name is the one you can reference
in future actions such as create/modify/delete.

HTH

so long -
	MgE

--=20
Matthias G. Eckermann     Senior Product Manager   SUSE=C2=AE Linux Ent=
erprise
SUSE LINUX Products GmbH  Maxfeldstra=C3=9Fe 5          90409 N=C3=BCrn=
berg Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer, HRB 16746 (AG N=C3=
=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
