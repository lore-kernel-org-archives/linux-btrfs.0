From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Tue, 24 Jan 2012 11:39:51 +0100
Message-ID: <201201241139.51350.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <201201241116.11489.Martin@lichtvoll.de> <4F1E8806.5080504@gmx.net> (sfid-20120124_113314_976059_C4B56A78)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F1E8806.5080504@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 24. Januar 2012 schrieb Arne Jansen:
> On 24.01.2012 11:16, Martin Steigerwald wrote:
> > Am Dienstag, 24. Januar 2012 schrieb Arne Jansen:
> >> On 21.01.2012 11:49, Martin Steigerwald wrote:
> >>> Am Dienstag, 20. Dezember 2011 schrieb Martin Steigerwald:
> >>>=20
> >>> When I do btrfs scrub start / the machine locks immediately up
> >>> hard.
> >>=20
> >> Can you please give me the output of sysrq-w when the machine is
> >> locked up?
> >=20
> > What would be the easiest way to do that?
> >=20
> > The machine is locked up, means, no mouse, no keyboard, no ping - a=
s
> > far as I remember I tested a ping, but I can verify -, no nothing.
>=20
> Hm, I always use a (hardware) serial console, but I think on default
> loglevel the sysrq-output goes to dmesg only, so you have to adjust
> the loglevel also. Normally I have a ssh into the box running with a
> tail -f /var/log/messages. This locks up very seldom.
> Have you tried some sysrq combinations? It might work, even when the
> keyboard looks locked up in all other respects.

Ok, so I may try the SSH way, maybe I get something before network gets=
=20
nonfunctional. Or maybe I didn=B4t even test ssh/ping and network still=
=20
works. But I think I tried accessing the machine via network, I usually=
 do=20
this in such cases.

If that does not work and USB to serial adapter might work.

But then as far as I remember even audio locked up hard replaying the s=
ame=20
sample all over again, so I do not know whether the kernel will do=20
anything at all.

Aside from that I got the idea to try to scrubbing with kernel 3.1 to=20
verify whether thats an regression.

Well I try some things and report back. Since the / filesystem on that=20
ThinkPad T23 is the only one it might have some wierd issues. Its one o=
f=20
my oldest BTRFS filesystems.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
