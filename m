From: Aaron Straus <aaron@edgestreamlp.com>
Subject: Re: Removing snapshots
Date: Wed, 14 Jul 2010 12:55:22 -0700
Message-ID: <AANLkTinAvz4FgpoVc_ZLiZhCsmxGoDy7XTZulk1uv2np@mail.gmail.com>
References: <BB8A38D2-8990-4B87-8A4E-E9BD530D340F@noir.com>
	<AANLkTik359_CjeNj4dS_LMOEMdP3AMXR9WUiJP4dMuLY@mail.gmail.com>
	<AANLkTilAOzycyOU2PlIjDJqmocPOWgmpPZVFWTx9cMUG@mail.gmail.com>
	<4C3E0CE4.4020309@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C3E0CE4.4020309@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 14, 2010 at 12:15 PM, K. Richard Pixley <rich@noir.com> wro=
te:
> =A0Here's what I'm getting on ubuntu-10.04 with standard tools,
> (/sbin/btrfsctl), and freshly built tools, (/usr/local/bin/btrfsctl).
>
> Are we sure that the btrfs kernel module in this release is supportin=
g the
> right ioctls?

Yes it works for me, see the correct arguments below.

> rich@diamonds> sudo /usr/local/bin/btrfsctl -D snaptest /home
> ioctl:: No such file or directory

The snaptest snapshot is in your home directory (I think), not in
/home, so you need to specify the full path i.e.:

sudo /usr/local/bin/btrfsctl -D snaptest /home/rich


Cheers,
=3Da=3D


--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aaron Straus
aaron@merfinllc.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
