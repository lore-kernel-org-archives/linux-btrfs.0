Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48950 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaG1KCQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 06:02:16 -0400
Date: Mon, 28 Jul 2014 11:02:03 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Subject: Re: Multi Core Support for compression in compression.c
Message-ID: <20140728100203.GG31950@carfax.org.uk>
References: <CAPDOMViXEgN1U8Og52Fd7EaM86Ad2Dfex9TVQ-+tRZ9SL9Kcig@mail.gmail.com>
 <53D5BBCA.3020109@gmail.com>
 <CAPDOMVjB9ErEwA7mf91X7pff5LAkeT=BT4pR7TuoEp3LL333Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
In-Reply-To: <CAPDOMVjB9ErEwA7mf91X7pff5LAkeT=BT4pR7TuoEp3LL333Lg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 27, 2014 at 11:21:53PM -0400, Nick Krause wrote:
> On Sun, Jul 27, 2014 at 10:56 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > On 07/27/2014 04:47 PM, Nick Krause wrote:
> >> This may be a bad idea , but compression in brtfs seems to be only
> >> using one core to compress.
> >> Depending on the CPU used and the amount of cores in the CPU we can
> >> make this much faster
> >> with multiple cores. This seems bad by my reading at least I would
> >> recommend for writing compression
> >> we write a function to use a certain amount of cores based on the load
> >> of the system's CPU not using
> >> more then 75% of the system's CPU resources as my system when idle has
> >> never needed more
> >> then one core of my i5 2500k to run when with interrupts for opening
> >> eclipse are running. For reading
> >> compression on good core seems fine to me as testing other compression
> >> software for reads , it's
> >> way less CPU intensive.
> >> Cheers Nick
> > We would probably get a bigger benefit from taking an approach like
> > SquashFS has recently added, that is, allowing multi-threaded
> > decompression fro reads, and decompressing directly into the pagecache.
> >  Such an approach would likely make zlib compression much more scalable
> > on large systems.
> >
> >
> 
> Austin,
> That seems better then my idea as you seem to be more up to date on
> brtfs devolopment.
> If you and the other developers of brtfs are interested in adding this
> as a feature please let
> me known as I would like to help improve brtfs as the file system as
> an idea is great just
> seems like it needs a lot of work :).

   Yes, it probably does need a lot of work. This is (at least one
reason) why it's not been done yet. If you want to work on doing this,
then please do. However, don't expect anyone else to give you a
detailed plan of what code to write. Don't expect anyone else to write
the code for you. You will have to come up with your own ideas as to
how to implement it, and actually do it yourself, including building
it, and testing it.

   That's not to say that you are on your own, though. People will
help -- provided that you aren't asking them to do all the work. You
are not an empty vessel to be filled with the wisdom of the ancients.
This means that *you* have to take action. You have to take yourself
as far as you can in learning how things work. When you get stuck,
work out what it is that you don't know, and then ask about that one
thing. This makes it easier to answer, it shows that you're putting in
effort on your side, and it means that you *actually learn things*.
Questions like "what function should I be modifying?", or "how do you
want me to do this?" show that you haven't put in even the smallest
piece of effort, and will be ignored (f you're lucky). Questions like
"I'm trying to implement a crumble filter, but in the mix_breadcrumbs
function, how does it take account of the prestressed_yoghurt field?"
show that you've read and understood at least some of the code, and
have thought about what it's doing.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Alert status mauve ocelot: Slight chance of brimstone. Be ---    
                   prepared to make a nice cup of tea.                   

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9Yfm1heFHXiqx3kAQJOAg//bKSpuGOK2gUzwcjtVisbymvtbVZ3uuuh
yVu7aV+KUeY4ZGnKq7N2vpLBJoc/XLaCS5hFXLkJyzDe7Hvc+yYCrzJNhwQC4u3S
JQwtBhLYi4p4fV1R3mRX9o+TfuIMuJuwgPJO6xhlUYgxaJcXsQ4aUkqqW3QHqmWR
gOcu0eLenWq/ZCcse8dEiq/qXaPwwS05XNUEmso9hcWRE4o7CdaXqeKqs1BHOjvP
1ubIuGxusPKTXpko+G9MmZQM3pwrCWuvV1a2oUkI5uALHSW3PLB0Iud040UUefVg
JcracmawTn9EVoMndR2FEOqfP5lydKuMb2SkrBPrp1qzBbn/1XXTln2KHyKxYXd2
WfROmmr5RDxoa+5+zq7uboknO1Pay4kYq1K9XNqfPDojpUsU/YI/EDIECmZcI+a9
A/CwYcq2eW0E2YliN+ZDgYXF9lg5Qk74Mi3j4/gTRJKt0Wpfiv7ffYiim2WoNkcV
vxIrtM0xFaDehE9/gS/9cvKBCVYThytwA2LItNkw9TwZe1f5BAyAXnk0PXz+gEEM
lxOGHRhHW5TH8Oaa5kvveFd9qV8zNYTopTi8dF7NoUaZR0uHnLOIM4xJO9tdlxJz
OciAeRZdBmKPUBPq0YHskZxpG/dGawS4nV625zq24fcsFR6pnxDQpINDrAy/1fSL
LUEwXU8Cc9w=
=eIGo
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
