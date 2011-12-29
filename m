From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: fstrim on BTRFS
Date: Thu, 29 Dec 2011 11:52:50 +0100
Message-ID: <201112291152.51148.Martin@lichtvoll.de>
References: <201112281757.16019.Martin@lichtvoll.de> <4EFBE668.7030800@cn.fujitsu.com> (sfid-20111229_114300_101340_9B187E4D)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFBE668.7030800@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 29. Dezember 2011 schrieb Li Zefan:
> Martin Steigerwald wrote:
> > Hi!
> >=20
> > With 3.2-rc4 (probably earlier), Ext4 seems to remember what areas =
it
> > trimmed:
> >=20
> > merkaba:~> fstrim -v /boot
> > /boot: 224657408 bytes were trimmed
> > merkaba:~> fstrim -v /boot
> > /boot: 0 bytes were trimmed
> >=20
> >=20
> > But BTRFS does not:
> >=20
> > merkaba:~> fstrim -v /
> > /: 4431613952 bytes were trimmed
> > merkaba:~> fstrim -v /
> > /: 4341846016 bytes were trimmed
> >=20
> >=20
> > Is it planned to add this feature to BTRFS as well?
>=20
> There's no such plan, but it's do-able, and I can take care of it.
> There's an issue though.
>=20
> Whether we want to store TRIMMED information on disk? ext4 doesn't
> do this, so the first fstrim will be slow though you've done fstrim
> in previous mount.
>=20
> For btrfs this issue can't be solved without disk format change that
> will break older kernels, but only 3.2-rcX kernels will be affected i=
f
> we push the following change into mainline before 3.2 release.

I can=B4t comment on the disk format change. But if it is accepted, I c=
an=20
give your patchset a spin before 3.3 merge window. Tell me when you=B4d=
 like=20
that.

If not, then AFAIK there is another disk format change necessary to rai=
se=20
hard link limit. So maybe then it makes sense to combine both disk form=
at=20
changes at some future kernel. Better an early one, before adoption rai=
ses=20
even more.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
