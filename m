Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36206 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbcFUMCH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 08:02:07 -0400
Date: Tue, 21 Jun 2016 11:33:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Is "btrfs balance start" truly asynchronous?
Message-ID: <20160621113339.GA3325@carfax.org.uk>
References: <f68639e5a41343c04fa4d76f3fb14370@www.centurion.link>
 <pan$7df97$9174e96e$7848d28b$295d4358@cox.net>
 <bc9cdbdf-060b-e903-0c74-c2b6f1f92077@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
In-Reply-To: <bc9cdbdf-060b-e903-0c74-c2b6f1f92077@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 21, 2016 at 07:24:24AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-06-21 04:55, Duncan wrote:
> >Dmitry Katsubo posted on Mon, 20 Jun 2016 18:33:54 +0200 as excerpted:
> >
> >>Dear btfs community,
> >>
> >>I have added a drive to existing raid1 btrfs volume and decided to
> >>perform balancing so that data distributes "fairly" among drives. I have
> >>started "btrfs balance start", but it stalled for about 5-10 minutes
> >>intensively doing the work. After that time it has printed something
> >>like "had to relocate 50 chunks" and exited. According to drive I/O,
> >>"btrfs balance" did most (if not all) of the work, so after it has
> >>exited the job was done.
> >>
> >>Shouldn't "btrfs balance start" do the operation in the background?
> >
> >From the btrfs-balance (8) manpage (from btrfs-progs-4.5.3):
> >
> >start [options] <path>
> >    start the balance operation according to the specified filters,
> >    no filters will rewrite the entire filesystem. The process runs
> >    in the foreground.
> >
> >
> >So the balance start operation runs in the foreground, but as explained
> >elsewhere in the manpage, the balance is interruptible by unmount and
> >will automatically restart after a remount.  It can also be paused and
> >resumed or canceled with the appropriate btrfs balance subcommands.
> >
> FWIW, there was some talk a while back about possibly providing an
> option to run balance in the background.  If I end up finding the
> time, I may write a patch for this (userland only, I'm not
> interested in mucking around with the kernel side of things, and
> it's fully possible to do this just using libc functions), as it's
> something I'd rather like to have myself, as the current method of
> using job control in a shell doesn't really work in some
> circumstances (for example, you can't easily start a balance on a
> remote system via a ssh command, which is the specific use case I
> have).

   There's quite a bit of infrastructure in the userspace tools to
deal with managing an asynchronous scrub. It would probably be worth
looking at that in the first instance to see if it can be reused for
balance.

   Hugo.

-- 
Hugo Mills             |
hugo@... carfax.org.uk | __(_'>
http://carfax.org.uk/  | Squeak!
PGP: E2AB1DE4          |

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXaSYTAAoJEFheFHXiqx3kIeIP/Aw36UNXhahHTwCGrqB4RjYW
1B4JTG8AMvW65YWukl0aGg4UtguPQCeXj/89qROACiroKB5Ss2KfZiB/igus4tVq
EuliL3vsaeF4U+Eq3kT/OjioVI9GIK73TSDFxtP+KfMezXERveMjbKZIJdPpFMJa
G34GhgLPkK04pErGHqYgcjSEQZgpEYk6K1TNigg8Q704uK6dEyrxIsoBCCaSa5P4
rtdpfsgZEVxvFYxm0iReZb/WbUWOxa5dv3nDthTRlwkILdpOk56VKz017AK1Mamz
ELhPexQr1s+2hCrzWPOK4kgvYJLzgPu7LK49WXOqmz/zY9ExyuECYoDj/0cNjahR
hBCpdoEP3rj7T2ojwplseHqEoEGvkzvHmf+83NtYJLo15sQip5C14LeiV6Nm428m
843x5K0/Lz91brOoTUln4KwDvc9zNeW3/PeUqxOXhwn8W01KmVOEykAyIq2GbGV6
fPGmaxH+Enh/4evSYXrECfEwcmJimW1wwXzsR/YU2C+SUnoCmVGF69h9x/lDcDC3
2J5WGnMWRDpscssva+jjoxMfnE9ZlkHcWDOqrf0LMh1figxSattQGDXkM0gsFa+f
W66NTJTTzp3YH8iFfIewaF05WReK7L4N0GfjXt1SY96l8wj55zPkTd5/aKDMQBO9
eVnCzBBUoIY2No4ThOOA
=lPvO
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
