From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: [patch 0/2] Control filesystem balances (kernel side)
Date: Mon, 1 Nov 2010 13:58:21 +0100
Message-ID: <20101101125821.GH13149@jeru.org>
References: <20101030000726.286517546@carfax.org.uk> <201010301944.35962.kreijack@libero.it>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010301944.35962.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Le 30 octobre 2010 =E0 19:44, Goffredo Baroncelli a =E9crit:
> I like the idea that these info should be put under sysfs. Something =
like
>=20
> /sys/btrfs/<filesystem-uuid>/
>                              balance	-> info on balancing
>                              devices	-> list of device (a directory o=
f
>                                            links or a file which cont=
ains=20
>                                            the list of devices)
>                              subvolumes/ -> info on subvolume(s)
>                              label       -> label of the filesystem
>                              <other btrfs filesystem related knoba>

Well, mdstat stats are under /proc/mdstat.
Is sysfs the ideal place ?

Just asking.

--=20
Xavier Nicollet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
