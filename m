Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49585 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933355AbdIYOUB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 10:20:01 -0400
Date: Mon, 25 Sep 2017 14:19:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Marat Khalili <mkh@rqc.ru>, Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvolume: outputs message only when
 operation succeeds
Message-ID: <20170925141951.GD25529@carfax.org.uk>
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
 <20170925075250.GC25529@carfax.org.uk>
 <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
In-Reply-To: <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 25, 2017 at 04:04:03PM +0800, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B409=E6=9C=8825=E6=97=A5 15:52, Hugo Mills wrote:
> >On Mon, Sep 25, 2017 at 03:46:15PM +0800, Qu Wenruo wrote:
> >>
> >>
> >>On 2017=E5=B9=B409=E6=9C=8825=E6=97=A5 15:42, Marat Khalili wrote:
> >>>On 25/09/17 10:30, Nikolay Borisov wrote:
> >>>>On 19.09.2017 10:41, Misono, Tomohiro wrote:
> >>>>>"btrfs subvolume create/delete" outputs the message of "Create/Delete
> >>>>>subvolume ..." even when an operation fails.
> >>>>>Since it is confusing, let's outputs the message only when an
> >>>>>operation succeeds.
> >>>>Please change the verb to past tense, more strongly signaling success=
 -
> >>>>i.e. "Created subvolume"
> >>>What about recalling some UNIX standards and returning to NOT
> >>>outputting any message when operation succeeds? My scripts are
> >>>full of grep -v calls after each btrfs command, and this sucks
> >>>(and I don't think I'm alone in this situation).
> >>
> >>Isn't the correct way to catch the return value instead of grepping
> >>the output?
> >
> >    It is, but if, for example, you're using the command in a cron
> >script which is expected to work, you don't want it producing output
> >because then you get a mail every time the script runs. So you have to
> >grep -v on the "success" output to make the successful script silent.
>=20
> What about redirecting stdout to /dev/null and redirecting stderr to
> mail if return value is not 0?
> As for expected-to-work case, the stdout doesn't has much meaning
> and return value should be good enough to judge the result.
>=20
> >
> >>If it's some command not returning value properly, would you please
> >>report it as a bug so we can fix it.
> >
> >    It's not the return value that's problematic (although those used
> >to be a real mess). It's the fact that a successful run of the command
> >produces noise on stdout, which most commands don't.
>=20
> Yes, a lot of tried-and-true tools don't output anything for
> successful run, but also a lot of other tools do output something by
> default, especially for complex tools like LVM.

   btrfs sub create and btrfs sub delete, though, aren't complex.
They're about as complex as mkdir and rmdir, from a user point of
view. What's more, and like mkdir/rmdir, the effects of those commands
show up in the filesystem at the path given, so manual verification
could be as simple as "ls -d !$" or "ls !$/..". It's really, really
not necessary to have this command unconditionally print "yes, I
created a directory for you" to stdout.

   Yes, there's ways to deal with it in shell scripts, but wouldn't
life be so much better if you didn't have to? Like you don't have to
filter out success reports from mkdir.

> Maybe we can introduce a global --quite option to silent some output.

   Or drop the spurious output unless it's asked for with --verbose.
Because then it makes it so much easier to compose tools together into
bigger and more complex things, which is, after all, one of the
fundamental things that UNIX does right.

   Hugo.

> Thanks,
> Qu
> >
> >    Hugo.
> >>Thanks,
> >>Qu
> >>
> >>>If you change the message a lot of scripts will have to be
> >>>changed, at least make it worth it.
> >>>
> >>> =C2=A0--
> >>>
> >>>With Best Regards,
> >>>Marat Khaliili
> >>>
> >

--=20
Hugo Mills             | Great films about cricket: The Fantastic Four
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZyRCHAAoJEFheFHXiqx3kW88P/ilQSrwU/Nw3n6Qd6rPJB03b
xW6xJnp2cS5DESF2oWtmiGWHMrapygXUHyTn+b8v9/UcrySZM8K2t/WWDMuW6Ywu
PhQh7kgvzzx4X4jjmfSLyaiWBxct4z7IUaBhB5vtKG5DrLHvhS6JBuM7SxHaLuLC
m+L5nhj2mqep9rl+A84xmQP3G6m1RKyP3zViocDGbjsHnEYEZ7TuyN+TwSdhQWXd
Q3+ZIiM6r3pAAXwoABWj+BW4gr5AKJBl+o+2ESd84uCwiikJLGZCsH795XvEK2Hd
i+u+XUFk6x8r7DjYn8U+vuHBfh6d0v45a1elw6BIShRzL3ziBjSM1gVhhdl7ae4P
MYP4tmZe/2T+TO4K1HfYphaeC7jdm0XsMOQU+atc0P5MEocDmQtwzBIieYcXdyBe
TZTd3TFNuR4Mgm9t0vmSL/xl64mvoqxl+8+LMqinaCgnvFVkq61WsgCxxqo3nGuB
mFQh9//wZJhzw365pu5msqgBpYck2v7HiteRXzxPBVHo4erxXl4ETicIIvP9wMNc
AhVUKHW/feRMAE9doEVWmkT7QcBGR5Ou4biUTvCbjuFOlODAQSRPyfEm0olPXuoT
2rpoW2+CvpDqPDtgDiyvmNN9eh/smIMmbUb7e4a+oWHRiCPC9KqpfxsCs7tGkjd+
wk2JbpiaBAKSDtKNa7ok
=9bQt
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
