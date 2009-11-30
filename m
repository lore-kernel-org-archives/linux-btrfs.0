From: =?iso-8859-1?Q?Jean-S=E9bastien?= Trottier <jst1@email.com>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Sun, 29 Nov 2009 23:28:51 -0500
Message-ID: <20091130042851.GG25509@jsoft.dyndns.org>
References: <200911192026.04694.lists-receive@programmierforen.de>
 <4B05D64B.7070705@hp.com>
 <200911202022.19306.lists-receive@programmierforen.de>
 <20091127053336.GD25509@jsoft.dyndns.org>
 <4B0FF6F9.9010603@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Andi Drebes <lists-receive@programmierforen.de>,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B0FF6F9.9010603@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2009 at 10:57:45AM -0500, jim owens wrote:
> Jean-S=E9bastien Trottier wrote:
> >In the case of RAID1 (or even RAID10), what happens if loop0 is the
> >current master but is corrupted/dead and you want to mount loop1 to
> >recover your data?
>=20
> The problem does not occur with raid1.  In that case, both copies
> are updated and either can mount.  For raid10, 2 of the 4 devices
> should always be mountable (you still have to find which 2).

Hmmm... But Andi's original post shows he was having this problem with
RAID1, no?

JST.

>=20
> The "guess who is the mountable device" problem occurs on raid0
> and on the (not yet in-tree) raid5/6. Better error recovery is
> one of the projects that needs to be done.
>=20
> jim
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
