From: Josef Bacik <josef@redhat.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 6 Aug 2009 11:20:58 -0400
Message-ID: <20090806152058.GF3655@dhcp231-156.rdu.redhat.com>
References: <200908061657.50989.Dessa@gmake.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Robert =?iso-8859-1?Q?F=F6rster?= <Dessa@gmake.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200908061657.50989.Dessa@gmake.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2009 at 04:57:50PM +0200, Robert F=F6rster wrote:
> Hello,=20
>=20
> i thought i'd jump in since i have the same issue:
> btrfs-show output:
>=20
> Label: none  uuid: 7f4f3bcb-7ba1-49c5-8996-e897b5483c7c
>         Total devices 1 FS bytes used 5.32GB
>         devid    1 size 51.22GB used 51.22GB path /dev/sdb1
>=20
> df -h output:
>=20
> Filesystem            Size  Used Avail Use% Mounted on
> rootfs                 52G  5,4G   46G  11% /
>=20

Alrighty, so btrfs-show says you have used up all of your disk, but for=
 some
reason statfs is saying you havent.  Can you cd into / and run

du -h -s

and then wait a very long time and then tell me what it comes back with=
 :).
That will tell us for sure what the hell is going on.  Thank you,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
