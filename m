Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37659 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbeCFMKd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 07:10:33 -0500
Subject: Re: [PATCH 0/8] btrfs-progs: qgroups usability [corrected]
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7fe42c8a-755c-099a-d430-0cae7e24b69b@gmx.com>
Date: Tue, 6 Mar 2018 20:10:22 +0800
MIME-Version: 1.0
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DmYEt9ZZhDXoL5QmYXCUDajHozQSatwkF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DmYEt9ZZhDXoL5QmYXCUDajHozQSatwkF
Content-Type: multipart/mixed; boundary="5hnFqzT7ahJbMn8MjXaCmD2vr8qotAnAx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <7fe42c8a-755c-099a-d430-0cae7e24b69b@gmx.com>
Subject: Re: [PATCH 0/8] btrfs-progs: qgroups usability [corrected]
References: <20180302184704.22399-1-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>

--5hnFqzT7ahJbMn8MjXaCmD2vr8qotAnAx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:46, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> Hi all -
>=20
> The following series addresses some usability issues with the qgroups U=
I.
>=20
> 1) Adds -W option so we can wait on a rescan completing without startin=
g one.
> 2) Adds qgroup information to 'btrfs subvolume show'
> 3) Adds a -P option to show pathnames for first-level qgroups (or membe=
r
>    of nested qgroups with -v)
> 4) Allows exporting the qgroup table in JSON format for use by external=

>    programs/scripts.

Going to review the patchset in the following days, but I'm pretty
curious about this feature.

Is there any plan to implement similar json interface for other tools?
Or just qgroup only yet?

Thanks,
Qu

>=20
> -Jeff
>=20
> Jeff Mahoney (8):
>   btrfs-progs: quota: Add -W option to rescan to wait without starting
>     rescan
>   btrfs-progs: qgroups: fix misleading index check
>   btrfs-progs: constify pathnames passed as arguments
>   btrfs-progs: qgroups: add pathname to show output
>   btrfs-progs: qgroups: introduce and use info and limit structures
>   btrfs-progs: qgroups: introduce btrfs_qgroup_query
>   btrfs-progs: subvolume: add quota info to btrfs sub show
>   btrfs-progs: qgroups: export qgroups usage information as JSON
>=20
>  Documentation/btrfs-qgroup.asciidoc |   8 +
>  Documentation/btrfs-quota.asciidoc  |  10 +-
>  Makefile.inc.in                     |   4 +-
>  chunk-recover.c                     |   4 +-
>  cmds-device.c                       |   2 +-
>  cmds-fi-usage.c                     |   6 +-
>  cmds-qgroup.c                       |  49 +++-
>  cmds-quota.c                        |  21 +-
>  cmds-rescue.c                       |   4 +-
>  cmds-subvolume.c                    |  46 ++++
>  configure.ac                        |   6 +
>  kerncompat.h                        |   1 +
>  qgroup.c                            | 526 ++++++++++++++++++++++++++++=
++------
>  qgroup.h                            |  22 +-
>  send-utils.c                        |   4 +-
>  utils.c                             |  22 +-
>  utils.h                             |   2 +
>  17 files changed, 621 insertions(+), 116 deletions(-)
>=20


--5hnFqzT7ahJbMn8MjXaCmD2vr8qotAnAx--

--DmYEt9ZZhDXoL5QmYXCUDajHozQSatwkF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqehS8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiwsgf/ZUFcoNhhmP8pVqZK6vnLf6eY
3+ALKqW47Axg8mVoWAv7CVLuPFY6A24N9/+tNhW+7C14OCxVV01/uGG5taBAJu1Y
4fsr6X/YQ1Um5FZqdJpTt5WfGWaM3n972wU9DUrYxiNUi1dcpHoin7hAWkSd5Uru
pR0cYKGDA79c18PCqHG8jTLOAGLn/OlD8Isc4CKFV4oJgltVm0RV6tv1JjvsAeGY
PuoQj7PCqtEGxxFZtss76o1OOQPLn7AlxfXoGdBKXsCVDPO1Gib7ZZbV5ILbpHYp
le6OHMsmdNxv9YnJD/hDNHpvH6/9yRucXQsZ/LUOj6i4SJ5YjxCzbEqdxqtsaQ==
=yaVX
-----END PGP SIGNATURE-----

--DmYEt9ZZhDXoL5QmYXCUDajHozQSatwkF--
