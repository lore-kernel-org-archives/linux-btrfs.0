Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:5217 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2JKR6w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 13:58:52 -0400
Message-ID: <507708DA.3040804@ubuntu.com>
Date: Thu, 11 Oct 2012 13:58:50 -0400
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Mitch Harder <mitch.harder@sabayonlinux.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Varying Leafsize and Nodesize in Btrfs
References: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com> <20120830162512.GA2879@localhost.localdomain>
In-Reply-To: <20120830162512.GA2879@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/30/2012 12:25 PM, Josef Bacik wrote:
> Once you cross some hardware dependant threshold (usually past 32k)
> you start incurring high memmove() overhead in most workloads.
> Like all benchmarking its good to test your workload and see what
> works best, but 16k should generally be the best option.  Thanks,
> 
> Josef

Why are memmove()s neccesary, can they be avoided, and why do they
incur more overhead with 32k+ sizes?



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQdwjZAAoJEJrBOlT6nu75rkYH/RYXBbAJfIG2KmmmFA8kSIiL
EEvdA9KRnVH08h2lnB26xNdCPbf59M7GrH2hZK48gM9x4OQPzKXf8eCTYTy4mFKy
mqTPFsgcPveTFtgoRXkuhZvUXMpFV4M8I7MLZRCcxk5KWTwA/slcunQxG7BMz/V4
tBxE8ya2Hxej2VJe4AbLR6PJbvCGsFXNlxBpUy9Qh7q0TmDeGzsoaZ1We1itNjQZ
wWjTerka2qe9dyP8EOUp/uZqGUQXu1TUKbTLygsfMb11/vGMkoUkZtTa0f9lQosw
10UlA8TyqAkLX3gpQzsJVCwiRuNWQBbQqvdYq3dCQOgzBbvOdvD6TtmeS1saO4o=
=qV0c
-----END PGP SIGNATURE-----
