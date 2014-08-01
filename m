Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49233 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaHAJ0a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Aug 2014 05:26:30 -0400
Date: Fri, 1 Aug 2014 10:26:24 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add support to check for FALLOC_FL_COLLAPSE_RANGE and
 FALLOC_FL_ZERO_RANGE crap modes
Message-ID: <20140801092624.GS31950@carfax.org.uk>
References: <1406829213-4759-1-git-send-email-xerofoify@gmail.com>
 <20140731190910.GP31950@carfax.org.uk>
 <CAPDOMVj8cEsgR1TTOkTUWaxMHiEbpnM6qcj7opRuRLP+3YOfTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOmQO3H5Qmmwdmk8"
In-Reply-To: <CAPDOMVj8cEsgR1TTOkTUWaxMHiEbpnM6qcj7opRuRLP+3YOfTg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hOmQO3H5Qmmwdmk8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 31, 2014 at 09:53:15PM -0400, Nick Krause wrote:
> On Thu, Jul 31, 2014 at 3:09 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Thu, Jul 31, 2014 at 01:53:33PM -0400, Nicholas Krause wrote:
> >> This adds checks for the stated modes as if they are crap we will return error
> >> not supported.
> >
> >    You've just enabled two options, but you haven't actually
> > implemented the code behind it. I would tell you *NOT* to do anything
> > else on this work until you can answer the question: What happens if
> > you apply this patch, create a large file called "foo.txt", and then a
> > userspace program executes the following code?
> >
> > int fd = open("foo.txt", O_RDWR);
> > fallocate(fd, FALLOCATE_FL_COLLAPSE_RANGE, 50, 50);
> >
> >    Try it on a btrfs filesystem, both with and without your patch.
> > Also try it on an ext4 filesystem.
> >
> >    Once you've done all of that, reply to this mail and tell me what
> > the problem is with this patch. You need to make two answers: what are
> > the technical problems with the patch? What errors have you made in
> > the development process?
> >
> >    *Only* if you can answer those questions sensibly, should you write
> > any more patches, of any kind.
[snip]

> Calls are there in btrfs , therefore will either kernel panic or
> cause an oops.

   That's a guess. I can tell it's a guess, because I've actually read
(some of) the rest of that function, so I've got a good idea of what I
think it will do -- and panic or oops is not the answer. Try again.
You can answer this question two ways: by test (see my suggestion
above), or by reading and understanding the code. Either will work in
this case, but doing neither is not an option for someone who wants to
change the function.

> Need to test this patch as this is very easy to catch bug.

   So why didn't you? It's your patch, testing it is your job --
*before* it gets out into the outside world.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to ---  
         eat?  / If the Juju had meant us not to eat people / he         
                     wouldn't have made us of meat.                      

--hOmQO3H5Qmmwdmk8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9tdQFheFHXiqx3kAQJqOA//Vj01fQ3Ym95zWZ9JlYpP9/gdpsnXC81P
j500M7Pgj0N6ZUXab5EPqL1kONsI0zrWpMsgALT+9JXGEki7fGkMP6jzTw4uLvJl
5TL/rpVYHvnPXHUmpU8TQqCt5RXaQ6U9cTQM+rsX8t9UNWF73ACAyYZcUj9zCjFx
iro9L7f4r+d2XegfAbdGJPim3YAh6clBNGg+kVzBPPuKtaI3MIoxQnDJRuewX0ut
DAk9MAYw5Q36XVtdFQEgrQ444JvSYWBHYIrV61L1fDZ20fQNC201htH+Aab6LAai
7XqJV8WKaSWHxRgrrdH8r/oEqX5x4W1Egm2Stxjmn2Kg1F07sV1MFDbsjSRLKuLe
LAVC3xBsgz/hn+Xm12hnHQS6OlFhBpBuU6CdZSJrfq7Q1R/cdEgx8U3D4ToeYw+Q
V0T6o6OhU/TozRm7ytK7YuOJJsRK7u4f8PqKWWSuMKgPXhYhUzaun6phTXsSzWEF
1W8zUriAQa5FyySqSeguvRQMXxjaicIh6GQbZIdLoaB/1w3s5iWIzyPSqC0AamJm
h4WDuFXTB5AQC/gkJ/jgG8B/DMnXdx0fMZxFZm7Ogjq9RWeK/stBFQN1d7h87wJ8
9/JnB6bcZA3eLI8uz/J9GmQpNQPCn3iWe6sD2RXQfOnoVnjsfxrJ0Cd+rQd6Luqa
RlOpAqlteAU=
=ORYb
-----END PGP SIGNATURE-----

--hOmQO3H5Qmmwdmk8--
