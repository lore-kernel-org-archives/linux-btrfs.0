Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56584 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbbFPJca (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 05:32:30 -0400
Date: Tue, 16 Jun 2015 09:32:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ingvar Bogdahn <ingvar.bogdahn@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: CoW with webserver databases: innodb_file_per_table and
 dedicated tables for blobs?
Message-ID: <20150616093228.GH9850@carfax.org.uk>
References: <557E9C2B.9030404@gmail.com>
 <20150615095720.GF9850@carfax.org.uk>
 <557FCB10.7050304@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nOM8ykUjac0mNN89"
In-Reply-To: <557FCB10.7050304@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nOM8ykUjac0mNN89
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2015 at 09:06:56AM +0200, Ingvar Bogdahn wrote:
> Hi again,
> 
> Benchmarking over time seems a good idea, but what if I see that a
> particular database does indeed degrade in performance? How can I
> then selectively improve performance for that file, since disabling
> cow only works for new empty files?

# mv file file.bak
# touch file
# chattr +C file
# cat file.bak >file
# rm file.bak

> Is it correct that bundling small random writes into groups of
> writes reduces fragmentation? If so, some form of write-caching
> should help?

   No, that's unlikely to help -- you're still fragmenting the
original file. Imagine a disk with a file (AAAABAAAACAAAADAAAAEAAAA)
on it, and the blocks B, C, D, E being modified. On the disk, you
might then end up with:

...AAAA.AAAA.AAAA.AAAA.AAAA.......................EDCB....

   Reading this file sequentially is going to involve 8 long seeks,
which is the fundamental problem with fragmentation. This kind of
behaviour in a CoW filesystem is inevitable; the main question is how
to minimise it.

   autodefrag, as I understand it, looks for high levels of
fragmentation in the few blocks near a pending write, and reads and
rewrites all of those blocks in one go. (I haven't read the code -- this
is based on my understanding of some passing remarks from josef on IRC
a while ago, so I might well be mischaracterising it).

> I'm still investigating, but one solution might be:
> 1) identify which exact tables do have frequent writes
> 2) decrease the system-wide write-caching (vm.dirty_background_ratio
> and vm.dirty_ratio) to lower levels, because this wastes lots of RAM
> by indiscriminately caching writes of the whole system, and tends to
> causes spikes where suddenly the entire cache gets written to disk
> and block the system. Rather use that RAM selectively to cache only
> the critical files.
> 4) create a software RAID-1 made up of a ramdisk and a mounted
> image, using mdadm.
> 5) Setting up mdadm using rather large value for "write-behind="
> 6) put only those tables on that disk-backed ramdisk which do have
> frequent writes.
> 
> What do you think?

   Benchmark it. Also test it for reliability when you pull the power
out in the middle of a bunch of writes -- you're caching so much in an
ad-hoc manner that I think you're unlikely to be achieving the D part
of ACID.

   Hugo.

> Ingvar
> 
> 
> 
> Am 15.06.15 um 11:57 schrieb Hugo Mills:
> >On Mon, Jun 15, 2015 at 11:34:35AM +0200, Ingvar Bogdahn wrote:
> >>Hello there,
> >>
> >>I'm planing to use btrfs for a medium-sized webserver. It is
> >>commonly recommended to set nodatacow for database files to avoid
> >>performance degradation. However, apparently nodatacow disables some
> >>of my main motivations of using btrfs : checksumming and (probably)
> >>incremental backups with send/receive (please correct me if I'm
> >>wrong on this). Also, the databases are among the most important
> >>data on my webserver, so it is particularly there that I would like
> >>those feature working.
> >>
> >>My question is, are there strategies to avoid nodatacow of databases
> >>that are suitable and safe in a production server?
> >>I thought about the following:
> >>- in mysql/mariadb: setting "innodb_file_per_table" should avoid
> >>having few very big database files.
> >    It's not so much about the overall size of the files, but about the
> >write patterns, so this probably won't be useful.
> >
> >>- in mysql/mariadb: adapting database schema to store blobs into
> >>dedicated tables.
> >    Probably not an issue -- each BLOB is (likely) to be written in a
> >single unit, which won't cause the fragmentation problems.
> >
> >>- btrfs: set autodefrag or some cron job to regularly defrag only
> >>database fails to avoid performance degradation due to fragmentation
> >    Autodefrag is a good idea, and I would suggest trying that first,
> >before anything else, to see if it gives you good enough performance
> >over time.
> >
> >    Running an explicit defrag will break any CoW copies you have (like
> >snapshots), causing them to take up additional space. For example,
> >start with a 10 GB subvolume. Snapshot it, and you will still only
> >have 10 GB of disk usage. Defrag one (or both) copies, and you'll
> >suddenly be using 20 GB.
> >
> >>- turn on compression on either btrfs or mariadb
> >    Again, won't help. The issue is not the size of the data, it's the
> >write patterns: small random writes into the middle of existing files
> >will eventually cause those files to fragment, which causes lots of
> >seeks and short reads, which degrades performance.
> >
> >>Is this likely to give me ok-ish performance? What other
> >>possibilities are there?
> >    I would recommend benchmarking over time with your workloads, and
> >seeing how your performance degrades.
> >
> >    Hugo.
> >
> 

-- 
Hugo Mills             | emacs: Eighty Megabytes And Constantly Swapping.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--nOM8ykUjac0mNN89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVf+0rAAoJEFheFHXiqx3kAkAQALkb6otjn+Rp7Ve1y85fqRQi
rLLR97VyeCDfR38YNOxOkOJRbkGXOOpcx8W4c2XB43zifbcUo4u02vxL8N5kuMfd
OBhqdGXNEefsOOv2uDOSrgqR+7g9hCs4njsdxF5FkWIaAvbOHpvp1dlqWW3dP21G
3XGVyJyzhVP+Fl+EdTIFxcUbQR2dIQrcKwr+JgprY3sAcNaEF16dQ6+tAeBpVjfJ
turOSXGfQIDnWlh6KAFntHG26zPu88YgwBLZIwzeeAvdru8YFWnhdwPQnowDmDUV
+yebLu7pwAKQHGqvMw5toGNg44qw4U5dNfh/6NNp5yYl/x5Oz8jsVbNtZURItYt1
Q3Epj4O+3kn8gG/OBi3ihpN6JdFmspbHGcOWjYlNqSOgCVnQzU7WI5PV0wCFCMsW
XSw57MOtS109jUaJTQfdi66DNQONkEWTWfAmFhuHxLMgYnA7hSO27HOnMhVub3XV
/bFFxLpM+CHp8LdpjF79FWUO7n1LYXTmf98GQlUpZwR3ChCWHlQ1YPr3MgqN5rba
RFiu1WhhQUgtM2ir65IOfryOZJLAxttBk1O6TaNkWGsA8MJuNVtn8PgNkoSeWIKK
CzKlcPjLjt68d9zLaLc6Ol9niSqwygau+K1B/zjKorpFOmKCFEmaXTmGWyBq9IBN
cFI3OjJd8SjUwVmLn8EU
=AGlt
-----END PGP SIGNATURE-----

--nOM8ykUjac0mNN89--
