From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: [patch 0/2] Control filesystem balances (kernel side)
Date: Mon, 1 Nov 2010 13:52:17 +0100
Message-ID: <20101101125217.GA16601@mother.pipebreaker.pl>
References: <20101030000726.286517546@carfax.org.uk>
 <201010301944.35962.kreijack@libero.it>
 <20101101125821.GH13149@jeru.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101101125821.GH13149@jeru.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 01, 2010 at 01:58:21PM +0100, Xavier Nicollet wrote:
> Le 30 octobre 2010 =C3=A0 19:44, Goffredo Baroncelli a =C3=A9crit:
> > I like the idea that these info should be put under sysfs. Somethin=
g like
> >=20
> > /sys/btrfs/<filesystem-uuid>/
> >                              balance	-> info on balancing
> >                              devices	-> list of device (a directory=
 of
> >                                            links or a file which co=
ntains=20
> >                                            the list of devices)
> >                              subvolumes/ -> info on subvolume(s)
> >                              label       -> label of the filesystem
> >                              <other btrfs filesystem related knoba>
>=20
> Well, mdstat stats are under /proc/mdstat.
> Is sysfs the ideal place ?

  mdstats are in sys: /sys/block/md127/md/
sync_action, sync_completed, sync_speed, reshape_position etc.

/proc file is legacy.


--=20
Tomasz Torcz               "Never underestimate the bandwidth of a stat=
ion
xmpp: zdzichubg@chrome.pl    wagon filled with backup tapes." -- Jim Gr=
ay

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
