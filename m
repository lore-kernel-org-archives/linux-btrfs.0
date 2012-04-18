From: David Sterba <dave@jikos.cz>
Subject: Re: Btrfs in degraded mode
Date: Wed, 18 Apr 2012 18:54:35 +0200
Message-ID: <20120418165435.GJ20982@twin.jikos.cz>
References: <loom.20120417T181336-69@post.gmane.org>
 <pan.2012.04.18.06.42.15@cox.net>
 <201204181845.11400.Martin@lichtvoll.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201204181845.11400.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2012 at 06:45:11PM +0200, Martin Steigerwald wrote:
> You can echo 1 >
>=20
> martin@merkaba:/sys/block/sda/device> ls -l delete
> --w------- 1 root root 4096 Apr 18 18:40 delete
>=20
> of the device you want to get rid of. (Double check that you have got=
 the=20
> right device!)
>=20
> But you either need to reboot (tested) or to rescan the bus to get th=
e=20
> device back (untested, don=B4t know whether this works).

It does:

echo "- - -" > /sys/class/scsi_host/host6/scan

you have to know the right number of scsi host.


david
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
