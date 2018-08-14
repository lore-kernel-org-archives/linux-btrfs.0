Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33376 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbeHNFfD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 01:35:03 -0400
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Thomas Leister <thomas.leister@mailbox.org>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <b121976e-fcbf-1349-9e1d-c14904604a17@suse.com>
Date: Mon, 13 Aug 2018 22:49:54 -0400
MIME-Version: 1.0
In-Reply-To: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fiAVEemN63VTUzIdMJbsGsK0iKT2vm76A"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fiAVEemN63VTUzIdMJbsGsK0iKT2vm76A
Content-Type: multipart/mixed; boundary="nHnbLbC7FcMZASh90I8KYkSj8Ge7iWFfN";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Thomas Leister <thomas.leister@mailbox.org>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
Message-ID: <b121976e-fcbf-1349-9e1d-c14904604a17@suse.com>
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
In-Reply-To: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>

--nHnbLbC7FcMZASh90I8KYkSj8Ge7iWFfN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/31/18 9:49 AM, Thomas Leister wrote:
> Dear David,
> hello everyone,
>=20
> during a recent project of mine involving LXD and BTRFS I found out tha=
t
> quotas on BTRFS subvolumes are enforced, but file system usage and
> limits set via quotas are not reported correctly in LXC containers.
>=20
> I've found this discussion regarding my problem:
> https://github.com/lxc/lxd/issues/2180
>=20
> There was already a proposal to introduce subvolume quota support some
> time ago:
> https://marc.info/?l=3Dlinux-btrfs&m=3D147576434114415&w=3D2
>=20
> @David as I've seen your response on that topic on the mailing list,
> maybe you can tell me if there are any plans to support correct
> subvolume quota reporting e.g. for "df -h" calls from within a
> container? Maybe there's already something on your / SUSE's roadmap? :-=
)
>=20
> As more and more container environments spin up these days, there might=

> be a growing demand on that :-) Personally I'd really appreciate if I
> could read the current file system usage and limit from within a
> container using BTRFS as storage backend.

In addition to Qu's deeper dive into the qgroup internals, the bigger
issue is that statfs(), which df uses, only allows the kernel to report
two numbers to describe space usage: total blocks and free blocks[1].

Currently, the only space tracking we have at a subvolume level is
qgroups.  There are other trees than "file" (i.e. subvolume) trees in
btrfs and those aren't accounted using qgroups.

So what should these numbers contain to describe to the user what their
space usage looks like?  We can have subvolume qgroup limits, nested
qgroup limits, disk capacity limits.  Df on btrfs is already confusing
enough with the data/metadata allocation split combined with potentially
different allocation policies for each.

That's the biggest hurdle to reporting per-subvolume information via df.
 It's a feature request that's been in my TODO inbox for a while.  I
started in on it again this year and came to the conclusion that wiring
qgroups into df would be easy[2] - but would ultimately raise more
questions than it solved for the user.  That's pretty much what I'm
seeing in this thread.

So, what I have mostly working is adding support for 'btrfs qgroup show'
to output in JSON format so that tools can be easily written to use the
numbers available to provide exactly what information the user wants
(given the limit of what's available.)

-Jeff

[1] There's f_bavail too, but that's not really relevant and runs into
the same issue as above in any case.
[2] Well, wiring it into statfs would be easy.  Publishing vfsmounts for
every subvolume so df actually calls it on unqualified 'df' executions
is rather a bit more involved.
--=20
Jeff Mahoney
SUSE Labs



--nHnbLbC7FcMZASh90I8KYkSj8Ge7iWFfN--

--fiAVEemN63VTUzIdMJbsGsK0iKT2vm76A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAltyQ1MACgkQHntLYyF5
5bLTjBAAojc2rIjgkHuhpoZQl0tAXAzBwZnfMETOYg/9bNqbbnMa2WKINcMU14FZ
K1VpYu3g7R7j7ElHk99NnM8iaDgSs4iCKXAoYKIZ24BHfWOq5TWJ6u/GOb47GlNz
mBz0GQ1qRel5WIYMqgGqouKZR7LWzYCAMTqV9fQqDTPyNWypMMrA9kEmTAbJrAeU
Q8z7s1I9HmVgfa8AMTTe9tv1m2+xyYxVocYNXG/qlH5w1scslQmX7kYhCN68mz6l
MQpn28dS8+Y705s/KxsFSsiH4rijMUIY/NSlq9NpgjO5mYMQ+c9nCAQyhHM0VFEz
/oKb7Y2ttXbd/gWY7nyIam5j8Zjnn3vEfxoqS9Mu0J9uvuv3UB+oomfYlT7f7ZWQ
GUeonby3sxr9eCzu30tb52KcOxZYOUNCBPN7LkcpZC2ilAnLO+7TdZ9Qa5tpZkcN
LNoBQCdnaeoSPkpWgZNX8hig7RvBECPp8z+lkDayqP9WVzFt4AvkmbFAccIX1i8n
Y3MU+LyPNrU+LIjboq+rJU+DsXNNQUvtCkkfHLcDbz8H07XcbY4OuACC2+WihiOB
KMvzFHoDqfm2Mpe0ywJjivjF1Sz5H226pty8j9z5EoevX+7XeC5hz3X2F2x5+83X
wGeDXe9Pw5kk4UY3XaMMv6U8FEYvdcUClDAsh1+UB+83CewCLSs=
=psND
-----END PGP SIGNATURE-----

--fiAVEemN63VTUzIdMJbsGsK0iKT2vm76A--
