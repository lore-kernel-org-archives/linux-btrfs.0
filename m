Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53981 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbcAIVEa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 16:04:30 -0500
Date: Sat, 9 Jan 2016 21:04:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "cheater00 ." <cheater00@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Message-ID: <20160109210429.GD6060@carfax.org.uk>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
In-Reply-To: <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
> OK. How do we track down that bug and get it fixed?

   I have no idea. I'm not a btrfs dev, I'm afraid.

   It's been around for a number of years. None of the devs has, I
think, had the time to look at it. When Josef was still (publicly)
active, he had it second on his list of bugs to look at for many
months -- but it always got trumped by some new bug that could cause
data loss.

   Hugo.

> On Sat, Jan 9, 2016 at 9:26 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sat, Jan 09, 2016 at 09:00:47PM +0100, cheater00 . wrote:
> >> Hello,
> >> I can repeatedly trigger this bug by making the "data" portion fill
> >> up. If you remember the partition is 6 TB but in btrfs filesystem df
> >> Data is shown as only 2TB when in fact it should be nearly 6TB. So
> >> this has nothing to do with kernel bugs. The filesystem on disk is
> >> structured incorrectly. How do i fix this? How do I make "Data"
> >> bigger? What is it exactly?
> >
> >    This is *exactly* the behaviour of the known kernel bug. The bug is
> > that the FS *should* be extending the data allocation when it gets
> > near to full, and it's not. There is no way of manually allocating
> > more (because the FS should be doing it automatically). There is no
> > known way of persuading the FS to it when it isn't.
> >
> >    The only good solution I know of is to reformat the FS and restore
> > from backups. Even then, some people manage to repeatedly hit this
> > with newly-created filesystems.
> >
> >    Hugo.
> >
> >> Thanks
> >>
> >> P.S. Sorry about reposting twice, apparently Google's "Inbox" app
> >> doesn't allow posting plain text at all and the mail got rejected from
> >> the list.
> >>
> >> On Thu, 7 Jan 2016 23:22 Chris Murphy <lists@colorremedies.com> wrote:
> >> >
> >> > On Thu, Jan 7, 2016 at 3:04 PM, cheater00 . <cheater00@gmail.com> wrote:
> >> > > Yes, both times it was the same drive. I only have one usb drive now.
> >> >
> >> > That it's the same drive is suspicious. But I don't know what
> >> > errno=-28 means or what could trigger it, if some USB weirdness could
> >> > cause Btrfs to get confused somehow. I have one 7200rpm drive that
> >> > wants 1.15A compared to all the others that have a 900mA spec, and
> >> > while it behaves find 99% of the time like the others, rarely I would
> >> > get the reset message and most of the time it was that drive (and less
> >> > often one other). Now that doesn't happen anymore.
> >> >
> >> > >
> >> > > I am not sure if chasing the kernel makes sense unless you think there is a
> >> > > specific commit that would have foxed it. I only reported here in case
> >> > > anyone here wanted to do some form of debugging before i reset the drive and
> >> > > rescan the fs to make it writeable again. But since there seems to be no
> >> > > interest i will go forward.
> >> >
> >> > I'd chase the hardware problem then first. It's just that the kernel
> >> > switch is easier from my perspective. And it's just as unclear this is
> >> > hardware related than just a bug. And since there are hundreds to
> >> > thousands of Btrfs bugs being fixed per kernel release, I have no way
> >> > to tell you whether it's fixed and maybe even a developer wouldn't
> >> > either, you'd just have to try it.
> >> >
> >> >
> >

-- 
Hugo Mills             | Hey, Virtual Memory! Now I can have a *really big*
hugo@... carfax.org.uk | ramdisk!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWkXXdAAoJEFheFHXiqx3krsYQALThAeq57zJxFoL6kl6fLamF
bZhBN2XrWIDiC3KYzunk0+5elEtxQzLECY3v3ia7+ryvVswBf64vWRCb+WShodmm
ogjV+lMWolc+M8hGLYhDaAnetLM6U0bp46DW5QAsU3bpek84gZ0SgB24Um0v/2BS
uSXLf1IETNGAb4aFAkYG8mtP2DnjlL71LKuA9hUfEBGKcVUGX/gr5rYPVK8E52tW
jfS9YeZ0WUlYqUQvnX96xiEJj1H2RLUTZRnPvV1+4ov4si4iAVuRx5RuqHzs3Env
wgCIkVbYV+3YIHg5qZczI2K4/X870NYcaqea0Xar65QVhfGnWL+FCcJs9BDN/22D
1duqkLfICTffTuUCfcmmtg+QQ/0wDjsyV5b7lgIRYGtpZ78JgbQ8XAunOD9Teoyt
th3v9l7Q1ZIRe4ysLJASEGBmE15ikYBAMH6ESAeeueIzE37xIqLKkYoccB26niRN
q0b6Idr+RiSpcfHFijUfOz9442q7TowI71/sXGW07BGKWXTJWn69rnlfS2XFfNsB
kf11AaU/JePwLaio5Lubr6X2JO0CttnWRh/CoUJXiUP8NS/gjNgyuAfatvNk4Yus
x9vrfOEpgQG4Fhq+LGjHQYxBunJVNn90H3RXBX4XfxRmzEGB+oM1a7BD1ezZ1jc7
23HMgD32/9Nvl2f/MH9p
=ELGc
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
