Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47333 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbdEJJIl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 05:08:41 -0400
Date: Wed, 10 May 2017 09:08:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Roman Mamedov <rm@romanrm.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: runtime btrfsck
Message-ID: <20170510090839.GH9701@carfax.org.uk>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
 <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
 <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
 <20170510121840.06aa01b2@natsu>
 <39924a38-4c6a-b0ea-81a7-64c1d72cf7be@profihost.ag>
 <20170510074052.GG9701@carfax.org.uk>
 <6b19da67-47a3-6f75-a892-8812b84817ea@profihost.ag>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FUaywKC54iCcLzqT"
In-Reply-To: <6b19da67-47a3-6f75-a892-8812b84817ea@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FUaywKC54iCcLzqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 10:40:31AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 10.05.2017 um 09:40 schrieb Hugo Mills:
> > On Wed, May 10, 2017 at 09:36:30AM +0200, Stefan Priebe - Profihost AG wrote:
> >> Hello Roman,
> >>
> >> the FS is mountable. It just goes readonly when trying to write some data.
> >>
> >> The kernel msgs are:
> >> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> >> block=163316514816,root=1, slot=39
> >> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> >> block=163322413056,root=1, slot=74
> >> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> >> block=163325722624,root=1, slot=63
> >> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> >> block=163316514816,root=1, slot=39
> >> BTRFS: error (device dm-2) in btrfs_drop_snapshot:8839: errno=-5 IO failure
> >> BTRFS info (device dm-2): forced readonly
> >> BTRFS info (device dm-2): delayed_refs has NO entry
> > 
> >    Can you show the output of btrfs-debug-tree -b <blocknum>, where
> > <blocknum> is each of the three "block=" values above?
> 
> Can do that. But the lists are very long - should i upload them to
> pastebin? Is it ok to remove the name atribute - which provides filenames?

   On the mailing list would be preferable, as then the conversation
is completely preserved in archives. They shouldn't be so long that
vger rejects them. And yes, if you want to filter out the filenames,
do so (but _just_ the filename -- don't remove the whole line).

   Hugo.

> Stefan
> 
> 
> >    Hugo.
> > 
> >> Greets,
> >> Stefan
> >> Am 10.05.2017 um 09:18 schrieb Roman Mamedov:
> >>> On Wed, 10 May 2017 09:02:46 +0200
> >>> Stefan Priebe - Profihost AG <s.priebe@profihost.ag> wrote:
> >>>
> >>>> how to fix bad key ordering?
> >>>
> >>> You should clarify does the FS in question mount (read-write? read-only?)
> >>> and what are the kernel messages if it does not.
> >>>
> > 

-- 
Hugo Mills             | Alert status mauve ocelot: Slight chance of
hugo@... carfax.org.uk | brimstone. Be prepared to make a nice cup of tea.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--FUaywKC54iCcLzqT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZEtiXAAoJEFheFHXiqx3kSUoQAIjV9zpzXkYeGreToSZHFjlb
fofoFnVxPCrqktkbhfGtuIXLc6yysSvNkhyAafdrQZOOMKa/j4C1VaWigHIT/H3d
+lOZr9PPqqZM7MqHmwM3y6Qe0GXuylCJH4yCmfCFtMSqLBO/jQOlhyu2Gch5xySi
M7UXIfEQ7wUChVQbjQra1vtfXZm6go9/mU6uteW3U+saclFRNSdY19OxTsokpNCn
YLxaQvbJ7Fx2siWZgRgVG/nh8E4RMtTxswVEYdHaNycQuZyUH7VQmIMiqkzg9g0C
m/6IdoDwXeQKqfo3Hbh6TBfqTikcuCLCTJN9RJapJ9GK3AFuo1geOvTq/QEcUy5s
/03+FtxYCnfd72bs2qbUwbIndbJ9xGe9g6pIPuk+0IKa0TAJw+Kf9UIiTekT84MX
/xImK6wOzz02h324zfsTWZ1JmmEj0lYpNe2Q7qzENgAFQ7jxfILyCU8RUNHUOjKF
Ph6EuAEUUT5mI6ZS3qRFH+W/u+lEW3wN0/Q6V2hLPRViGdjX0K4Hk/6I91yw3heI
RioC/kiHcnscCdMf8PF+v6fqJSOJDReX+Zp2Fuapy3ecIGe6II4EcTM8ILNkmcrG
rVoagaGuSDRi9YKyybmYk974/X01D754wDNUmzc1agsHz8sWYRIhLOhmlKtNZu/D
tMEyAN/SORLBhf9kqE+v
=Nw3B
-----END PGP SIGNATURE-----

--FUaywKC54iCcLzqT--
