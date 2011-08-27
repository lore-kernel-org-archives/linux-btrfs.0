From: Diego Calleja <diegocg@gmail.com>
Subject: Re: WARNING in -rc3-00023-g14c62e7
Date: Sun, 28 Aug 2011 01:40:24 +0200
Message-ID: <201108280140.25014.diegocg@gmail.com>
References: <201108252117.04108.diegocg@gmail.com> <CAKcLGm8BDyUP7XeNVFusuVOW0fG9LcH6dV1a3jBmpN9U1FHkCA@mail.gmail.com> <201108270033.51177.diegocg@gmail.com>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201108270033.51177.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On S=E1bado, 27 de Agosto de 2011 00:33:51 Diego Calleja escribi=F3:
> On Viernes, 26 de Agosto de 2011 22:59:54 Mitch Harder escribi=F3:
> >=20
> > Do you have autodefrag enabled?
>=20
> Yes

It seems that this problem has already been solved by Konstantin
Khlebnikov, he posted a patch on 17 August

[PATCH] btrfs: fix warning in iput for bad-inode

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
