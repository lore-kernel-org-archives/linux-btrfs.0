From: Josef Bacik <josef@redhat.com>
Subject: Re: BTRFS, encrypted LVM and disk write cache ?
Date: Thu, 12 May 2011 11:42:24 -0400
Message-ID: <20110512154224.GD19041@dhcp231-156.rdu.redhat.com>
References: <1305179125.3106.3.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305179125.3106.3.camel@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2011 at 07:45:25AM +0200, Sw=E2mi Petaramesh wrote:
> Hi list,
>=20
> I'm a new BTRFS user and will try not to ask FAQs ;-)
>=20
> I'm currently using Btrfs v0.19 on stock Ubuntu Natty (kernel 2.6.38)
> and use a BTRFS inside an encrypted LVM.
>=20
> The wiki "gotchas" page https://btrfs.wiki.kernel.org/index.php/Gotch=
as
> states :
> =AB btrfs volumes on top of dm-crypt block devices (and possibly LVM)
> require write-caching to be turned off on the underlying HDD. Failing=
 to
> do so, in the event of a power failure, may result in corruption not =
yet
> handled by btrfs code. (2.6.33) =BB
>=20
> ...So I've turned my write cache off, but I notice this is stated for
> kernel 2.6.33, so wonder if this still is an issue with 2.6.38, or ha=
s
> it been addressed since ?
>=20
> Thanks in advance for your help.

If you mount and start writing and don't see a message in dmesg about d=
isabling
barriers then you should be good to go.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
