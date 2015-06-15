Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53502 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbFOJ5W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 05:57:22 -0400
Date: Mon, 15 Jun 2015 09:57:20 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ingvar Bogdahn <ingvar.bogdahn@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: CoW with webserver databases: innodb_file_per_table and
 dedicated tables for blobs?
Message-ID: <20150615095720.GF9850@carfax.org.uk>
References: <557E9C2B.9030404@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lIrNkN/7tmsD/ALM"
In-Reply-To: <557E9C2B.9030404@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lIrNkN/7tmsD/ALM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 15, 2015 at 11:34:35AM +0200, Ingvar Bogdahn wrote:
> Hello there,
> 
> I'm planing to use btrfs for a medium-sized webserver. It is
> commonly recommended to set nodatacow for database files to avoid
> performance degradation. However, apparently nodatacow disables some
> of my main motivations of using btrfs : checksumming and (probably)
> incremental backups with send/receive (please correct me if I'm
> wrong on this). Also, the databases are among the most important
> data on my webserver, so it is particularly there that I would like
> those feature working.
> 
> My question is, are there strategies to avoid nodatacow of databases
> that are suitable and safe in a production server?
> I thought about the following:
> - in mysql/mariadb: setting "innodb_file_per_table" should avoid
> having few very big database files.

   It's not so much about the overall size of the files, but about the
write patterns, so this probably won't be useful.

> - in mysql/mariadb: adapting database schema to store blobs into
> dedicated tables.

   Probably not an issue -- each BLOB is (likely) to be written in a
single unit, which won't cause the fragmentation problems.

> - btrfs: set autodefrag or some cron job to regularly defrag only
> database fails to avoid performance degradation due to fragmentation

   Autodefrag is a good idea, and I would suggest trying that first,
before anything else, to see if it gives you good enough performance
over time.

   Running an explicit defrag will break any CoW copies you have (like
snapshots), causing them to take up additional space. For example,
start with a 10 GB subvolume. Snapshot it, and you will still only
have 10 GB of disk usage. Defrag one (or both) copies, and you'll
suddenly be using 20 GB.

> - turn on compression on either btrfs or mariadb

   Again, won't help. The issue is not the size of the data, it's the
write patterns: small random writes into the middle of existing files
will eventually cause those files to fragment, which causes lots of
seeks and short reads, which degrades performance.

> Is this likely to give me ok-ish performance? What other
> possibilities are there?

   I would recommend benchmarking over time with your workloads, and
seeing how your performance degrades.

   Hugo.

-- 
Hugo Mills             | You are not stuck in traffic: you are traffic
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                    German ad campaign

--lIrNkN/7tmsD/ALM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVfqGAAAoJEFheFHXiqx3kk1EP/Rv7JIpqvup1Q3Uy6wwhkhmf
Pz2e9Rl0qbTEMDabjSJdGAOockh8NaQdNBANFPqXtHzhed5XP32DCjmYEB3OYLLi
b6chKJ0LCZ8Rq11+j3hv/sphzBbHUQma7BnwZAm/YqjObi2iLjQnMv07UIbu75/x
e/YJMmY1OEJlmzAY5gF4drtnV0rZC27vdsk0AUnbX/VYNxGc4RVusez3h2sKbBjV
t+TfsZO464w3k41tcW/0VofxaxYRljNWrADH+mK51aRbHl74x7bNfAwqSfRcGabN
1nZ4yKkcFASe+6I7oQKj25K72klwtSz6Y7/naqEc01u4QHRx4HgWx7I8xTLtw/aX
FFtsnMiyKWU2TZygMNbslElRdXZulCjKJib+TzBhmRoOsb97ZxBaVp3/LUQm5xuF
zygpd1ggl+t/ettdV8zpDCL/N5J/20ExM84ieqGtvTM9zebZrbhRCTp+0lRaG0tG
JM4Go9KcsN2Bo6kkUO0a1NaeBozkOjxBc2CQThQ1KWR+2KtNXKtTfZz6ChHYw1W7
g8GPpVJTxLX6Nrliv9dN76w05KaiP71yKm3/wCQSTC5yGloozl2oFphOpuX8BI2C
hYYXLhX8WfU7ibK62hcPFuHIoEpnsRNJIAPjK3m00M0HnkbakFf2NmkoWAAeKiZQ
hoGzbQpM7KYioJehw9pl
=b5ju
-----END PGP SIGNATURE-----

--lIrNkN/7tmsD/ALM--
