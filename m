From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Mon, 9 Apr 2012 21:07:22 +0200
Message-ID: <201204092107.22994.Martin@lichtvoll.de>
References: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com> <4F82F5BA.3080504@kraav.com> <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com> (sfid-20120409_204022_475677_05FF62C7)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Daniel J Blueman <daniel@quora.org>, Leho Kraav <leho@kraav.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 9. April 2012 schrieb Daniel J Blueman:
> On 9 April 2012 22:44, Leho Kraav <leho@kraav.com> wrote:
> > On 09.04.2012 17:35, Daniel J Blueman wrote:
> >> Leho Kraav<leho<at>  kraav.com>  writes:
> >> []
> >>=20
> >>> Apr  8 02:46:11 s9 kernel: [  189.691778] attempt to access beyon=
d
> >>> end of device
> >>> Apr  8 02:46:11 s9 kernel: [  189.691787] dm-3: rw=3D129,
> >>> want=3D23361976, limit=3D20967424
> >>=20
> >> I recently bumped into this too [1]. Liu Bo posted a patch for it
> >> [2], which tests out fine here. The workaround is to not mount wit=
h
> >> 'discard' until eg ~3.4-rc3 or later.
> >>=20
> >> [1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16409
> >> [2] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16649
> >=20
> > Oh wow, thanks. This sounds exactly like what happened. I got the
> > livelock post off my search results, but the patch post doesn't see=
m
> > to have any of the keywords I was looking for, since I had no idea
> > it could be related to discards.
> >=20
> > So can this become a problem earlier too, not only when the space
> > used is
>=20
> > approaching limits? If not, I think I should be good until 3.4:
> Looks like it affects at least 3.3 and 3.4-rc1/2 in all circumstances=
=2E

Is offline discard via fstrim also affected?

I used fstrim some times for my / BTRFS with 3.3.0-trunk Debian kernel=20
(should be 3.3.0) and

martin@merkaba:~> zgrep "beyond" /var/log/syslog*
martin@merkaba:~#1>

Seems I am safe.

But I think I won=B4t use fstrim for now anymore on any BTRFS partition=
=20
until I have some confirmation that it is safe.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
