Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35330 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbeDYMp2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 08:45:28 -0400
Date: Wed, 25 Apr 2018 12:45:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: status page
Message-ID: <20180425124527.GA7776@carfax.org.uk>
References: <CAJH6TXhQA-yx1kE2CJLboxMyay+54qb9DxiRZkNrGhsPP8LkXw@mail.gmail.com>
 <20180423151618.GY21272@twin.jikos.cz>
 <CAJH6TXiAUi2yWYKQ6gPbGkxG1aZ=DL+99H53VRM_LQsKF6Cm=g@mail.gmail.com>
 <4ca73e54-85d2-3ba7-48b1-8f9983daac06@gmail.com>
 <CAJH6TXg3+j5g8Wk7jo5YM2dvTjvmp8Ddu2u0_v-u8r6agjRnLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
In-Reply-To: <CAJH6TXg3+j5g8Wk7jo5YM2dvTjvmp8Ddu2u0_v-u8r6agjRnLQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 25, 2018 at 02:30:42PM +0200, Gandalf Corvotempesta wrote:
> 2018-04-25 13:39 GMT+02:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> > Define 'stable'.
> 
> Something ready for production use like ext or xfs with no critical
> bugs or with easy data loss.
> 
> > If you just want 'safe for critical data', it's mostly there already
> > provided that your admins and operators are careful.  Assuming you avoid
> > qgroups and parity raid, don't run the filesystem near full all the time,
> > and keep an eye on the chunk allocations (which is easy to automate with
> > newer kernels), you will generally be fine.  We've been using it in
> > production where I work for a couple of years now, with the only issues
> > we've encountered arising from the fact that we're stuck using an older
> > kernel which doesn't automatically deallocate empty chunks.
> 
> For me, RAID56 is mandatory. Any ETA for a stable RAID56 ?
> Is something we should expect this year, next year, next 10 years, .... ?

   There's not really any ETAs for anything in the kernel, in general,
unless the relevant code has already been committed and accepted (when
it has a fairly deterministic path from then onwards). ETAs for
finding even known bugs are pretty variable, depending largely on how
easily the bug can be reproduced by the reporter and by the developer.

   As for a stable version -- you'll have to define "stable" in a way
that's actually measurable to get any useful answer, and even then,
see my previous comment about ETAs.

   There have been example patches in the last few months on the
subject of closing the write hole, so there's clear ongoing work on
that particular item, but again, see the comment on ETAs. It'll be
done when it's done.

   Hugo.

-- 
Hugo Mills             | Nothing wrong with being written in Perl... Some of
hugo@... carfax.org.uk | my best friends are written in Perl.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                  dark

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJa4HhnAAoJEFheFHXiqx3kEG0P/1qe0hK55ykKCvWdkDtH0iY+
3fvNCxUSe98pDneWdh/M+bn3WoRoqY5OsK+yJRjafLY2jMHdjtS5a27l+W43lD9/
HEzY0vVQk2LPJ5hmBbEbsH+cZ/fJL8RWL9YUKylSCIFlwH/CfXOB4qMeLU7IWCuu
tGso7LC1fkOBKR80nRIwWsXgkuBGLQZVakclmFyKoy4e7DqufAYNT5izrzuj9cc5
rsr2VEgsSEwdKvrWFd51a5XNlvYKK8CWdzXhh+Y0VO9QCv/5JDyeggBufxDXFm4+
wUCjxMm/Xtb8UXB3NSiOwP8huE1oJT/VNLmfekeEXYp59zcp6Y7sqvStCUhF5e5v
la5nMryn0hUjwqFHT/ERH/R5bUgcsY++wI/odzfdqV3vUBx1JoE742wmw7KpIRKF
KUq2xecRr9fKP1AOP8GXU0oqnREEW16zvEXMe34+XZRHxHclT8mVnFLA2FuXoxuj
8JUYsGGYW0DqgFT9e90N5fzWXCo5pd9lR+mPWyUKcRVwpzMV569MaVPWOQJxdxND
whXjDuTBkJ/8IMapfXwKPuG0ibjBEmup9RuG8XoH416C5IxqLZ9YZtCiEkMiLwao
pXpJeZ6B9mXgsKOvrw0xMsnrXmQxfpH0LsVGT7aiOFSwZQqip2LVKT1mA57IR+Rl
4p8KBpA+A+5zdTZpr9SW
=r2Tn
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
