From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Wed, 9 Nov 2011 21:15:21 +0100
Message-ID: <201111092115.22001.Martin@lichtvoll.de>
References: <4E54F884.9090004@cyberwizzard.nl> <201108251955.35283.Martin@lichtvoll.de> <1314310608.3448.8.camel@picard> (sfid-20110826_001754_062321_C6DB914A)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org, uzytkownik2@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314310608.3448.8.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Maciej,

Am Freitag, 26. August 2011 schrieb Maciej Marcin Piechotka:
> On Thu, 2011-08-25 at 19:55 +0200, Martin Steigerwald wrote:
> > That said I also do not have any issues with BTRFS on a ThinkPad T2=
3
> > for /
> > and /home. But then the machine has an hibernate-to-disk-and-resume
> > uptime
> > of almost 120 days, so it didn=C2=B4t see a power loss for a long t=
ime.
> > Thats
> > still with 2.6.38.4.
>=20
> Which method of hibernation are you using?
>=20
> I got enormous problems with btrfs+toi including:
>=20
>  - Freezes resulting in umountable partition (twice so far, 2 results
> in google including one message I sent to list)
>  - Sometimes a random program (Skype, Firefox) cannot be frozen and
> stacktracke includes btrfs AIO.

I do not use TOI since quite some time anymore since I had some issues=20
with it I do not remember anymore, I think it didn=C2=B4t work reliably=
 back=20
then. I like to try again, but did not come around to do it.

I use in-kernel-suspend, now with 3.0, debian packaged, thus not even s=
elf=20
compiled anymore, and its just rock solid on the T23. Its not that rock=
=20
solide on my new ThinkPad T520, but that might also be some driver issu=
es=20
and I do not use BTRFS on the new one, only on the T23.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
