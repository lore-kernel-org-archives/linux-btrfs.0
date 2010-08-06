From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Re: Number of hard links limit
Date: Fri, 6 Aug 2010 14:30:39 +0300
Message-ID: <20100806113039.GA18858@lh.kyla.fi>
References: <20100802114046.GA29926@lh.kyla.fi>
 <20100802130556.GF30325@jeru.org>
 <4ad406cb8ee6c52747b67b4c79a6d7dd@smtp.arbitraryconstant.com>
 <20100802215647.7466601d@simplux>
 <4C572DDC.5050108@robertoragusa.it>
 <0362zshcyx.fsf@msgid.viggen.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <0362zshcyx.fsf@msgid.viggen.net>
List-ID: <linux-btrfs.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 03, 2010 at 12:22:14AM +0200, Oystein Viggen wrote:
> IIRC, the limit on hard links is per directory.  That is, if you put
> each hard link into its own directory, there's basically no limit to the
> amount of hard links you can make to one file.

Yes, that's always pointed out in these threads. Still, it seems to be
breaking real use cases also beyond backuppc (someone mentioned
installing some Gentoo package).

> Thus, many generations of backup with BackupPC shouldn't trigger the
> problem, as each generation is stored in its own directory tree.  The
> problem appears when your source data has many identical files in the
> same directory, since these would be deduplicated as hard links to the
> same file in the backup pool.

I think you are right. I looked at the errors I reported in

  https://bugzilla.kernel.org/show_bug.cgi?id=15762

and figured out what happens there. In dbus's source tree, under
doc/api/man/man3dbus, there are 119 files with the content ".so
man3dbus/DBusProtocol.3dbus". I think these are redirects to a single
man page.

Interestingly (and only somewhat off-topic), because of deduplication
backuppc can be used to explore the merits of deduplication in
filesystems too. I looked at the files I have most copies of. Many of
them seem perhaps a bit silly.

The most common file has a single line with the text "# dummy". I have
54991 copies of that file. They are some kind of dependency files
(perhaps by libtool or something?), always in a directory named .deps
and with a file extension of .Po or .Plo.

There are also tens of thousands of copies of a file with a single
line with the text "END". Subversion VCS seems to have two of these
for every file under version control. In fact a large portion of the
most common files seem to be owned by Subversion.

	Sami

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJMW/JeAAoJEKLT589SE0a06BsQAIFI+ik1aU30Ug8hYTAWvBdc
5QsCl70OLDToZcu0PVmX4V+TdPHo+XcoSVtDjb+Hxatm/AOPr8SpsFFP0gJALV+A
7Ri6INdB4503vR3nZnSAfhylY/m9xL2eq651Kx/FoPnOVbf3lTAgnCLxXtMGiF17
Y38MmoLQ3yEe5Q/DYz7ZRZYwr29DwkalREIGbIpaiKYBTh0bb57uMlwW2UO0N5/A
0cYeu3JVEgdLRh6TOxBlK+R1UAzV341cs2ct8Jcbg2SyGsY2nLFtEyShggJyiazU
xEFkS6avbe/O1qOpd8ZQkM6J2Rf9LV5oCrRCEqU4gJP0QJzEghxF47jtgKvFpqm5
0SWpFke+7g9BFwZwVj4d4kfBhosFaWeAdWRdP6oDHB7YaBkLhM+U2Dc6dVPdo/Ye
oPPwjv/0u6GtPOyUJbDUvPVHgIMDBk5cxAnl9LEXOzi4SUf9VzcgiTdfUdYma8iE
hyv3zsJTRUeBQvV3D2Y0soyf3fzogt2cGiPb8+g9FaEqgHimGFO06clcjRt/bwyB
nqK075O1lPVa623CiXUXIiPTLaffMcbLwvEpBS9tjCrBcYqT6at5fOFlONOpocnZ
vHQy5R8Idf3065rxjyrlaNjpelRaFQMVPXEXUWbR+FHqaUbnWnuW7FQQBecgHESq
gjOczs8GGJqZDcWANi/M
=mLLb
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
