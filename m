Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50219 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbeFSEew (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 00:34:52 -0400
Subject: Re: About more loose parameter sequence requirement
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c0e6891d-7ec3-87fe-5eb7-ca6178b9ec50@gmx.com>
Date: Tue, 19 Jun 2018 12:34:43 +0800
MIME-Version: 1.0
In-Reply-To: <20180618120200.GK24375@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fWPoMfR7dn6TxXKZbdQ0kdw4z8lW3leKX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fWPoMfR7dn6TxXKZbdQ0kdw4z8lW3leKX
Content-Type: multipart/mixed; boundary="Ed0JYzbDE26t35vvzqazT9oEHQKFSqOOn";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>
Message-ID: <c0e6891d-7ec3-87fe-5eb7-ca6178b9ec50@gmx.com>
Subject: Re: About more loose parameter sequence requirement
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
In-Reply-To: <20180618120200.GK24375@twin.jikos.cz>

--Ed0JYzbDE26t35vvzqazT9oEHQKFSqOOn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8818=E6=97=A5 20:02, David Sterba wrote:
> On Mon, Jun 18, 2018 at 07:40:44PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8818=E6=97=A5 19:34, David Sterba wrote:
>>> On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
>>>> I understand that btrfs-progs introduced restrict parameter/option o=
rder
>>>> to distinguish global and sub-command parameter/option.
>>>>
>>>> However it's really annoying if one just want to append some new opt=
ions
>>>> to previous command:
>>>>
>>>> E.g.
>>>> # btrfs check /dev/data/btrfs
>>>> # !! --check-data-csum
>>>>
>>>> The last command will fail as current btrfs-progs doesn't allow any
>>>> option after parameter.
>>>>
>>>>
>>>> Despite the requirement to distinguish global and subcommand
>>>> option/parameter, is there any other requirement for such restrict
>>>> option-first-parameter-last policy?
>>>
>>> I'd say that it's a common and recommended pattern. Getopt is able to=

>>> reorder the parameters so mixed options and non-options are accepted,=

>>> unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more
>>> strict requirement, 'btrfs' option parser works the same regardless o=
f
>>> that.
>>
>> But currently it doesn't work.
>> Just as the example, btrfs check /dev/data/btrfs --check-data-sum won'=
t
>> work.
>> It's different from a lot of other common programs.
>=20
> With POSIXLY_CORRECT set, it expectedly won't work. With POSIXLY_CORREC=
T
> unset, it would work in general, but not for 'btrfs'.
>=20
> As this is per-application decision I find it ok, besides that I also
> find the 'options anywhere' pattern bad. Does it really save you that
> much time while typing the commands with new arguments? There are
> movement shortcuts to jump by words, you get the previous command by
> up-arrow. About the same number of keystrokes.
>=20
> New code needs to be tested, documented and maintained, that's the cost=

> I find too high for something that's convenience for people who are use=
d
> to some shell builtins.
>=20

Well, after some testing, the result looks pretty strange on my side.

With the testing code (*), mostly just copied from check/main.c, it
works to detect the final --check-data-csum without problem.

I'm originally planning to use '-' to make getopt_long() to keep the
original order, but the experiment I did shows it unnecessary.

And furthermore, even changing the optstring of btrfs check
getopt_long() with leading '-', it still doesn't work as expected to
detect non-option parameter.

Is there anything wrong/special in btrfs-progs getopt_long() usage?

Thanks,
Qu

*:
---
#include <stdio.h>
#include <getopt.h>
#include <unistd.h>

int main(int argc, char** argv)
{
	char *real_argv[] =3D { "btrfs check", "device", "--check-data-csum" , N=
ULL};
	int real_argc =3D sizeof(real_argv) / sizeof(char *) - 1;

	while (1) {
		enum { GETOPT_VAL_REPAIR =3D 257, GETOPT_VAL_INIT_CSUM,
			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE,
			GETOPT_VAL_MODE, GETOPT_VAL_CLEAR_SPACE_CACHE,
			GETOPT_VAL_FORCE };
		static const struct option long_options[] =3D {
			{ "super", required_argument, NULL, 's' },
			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
			{ "readonly", no_argument, NULL, GETOPT_VAL_READONLY },
			{ "init-csum-tree", no_argument, NULL,
				GETOPT_VAL_INIT_CSUM },
			{ "init-extent-tree", no_argument, NULL,
				GETOPT_VAL_INIT_EXTENT },
			{ "check-data-csum", no_argument, NULL,
				GETOPT_VAL_CHECK_CSUM },
			{ "backup", no_argument, NULL, 'b' },
			{ "subvol-extents", required_argument, NULL, 'E' },
			{ "qgroup-report", no_argument, NULL, 'Q' },
			{ "tree-root", required_argument, NULL, 'r' },
			{ "chunk-root", required_argument, NULL,
				GETOPT_VAL_CHUNK_TREE },
			{ "progress", no_argument, NULL, 'p' },
			{ "mode", required_argument, NULL,
				GETOPT_VAL_MODE },
			{ "clear-space-cache", required_argument, NULL,
				GETOPT_VAL_CLEAR_SPACE_CACHE},
			{ "force", no_argument, NULL, GETOPT_VAL_FORCE },
			{ NULL, 0, NULL, 0}
		};
		int c;

		c =3D getopt_long(real_argc, real_argv, "as:br:pEQ", long_options, NULL=
);
		if (c < 0)
			break;
		switch (c) {
			case 'a':
			case 'b':
			case 'Q':
			case 'E':
			case 'p':
				printf("option: %c\n", c);
				break;
			case 's':
			case 'r':
				printf("option: %c %s\n", c, optarg);
				break;
			case GETOPT_VAL_CHUNK_TREE:
				printf("option: chunk tree %s\n", optarg);
				break;
			case '?':
			case 'h':
				printf("option: help\n");
				break;
			case GETOPT_VAL_REPAIR:
				printf("option: repair\n");
				break;
			case GETOPT_VAL_READONLY:
				printf("option: readonly\n");
				break;
			case GETOPT_VAL_INIT_CSUM:
				printf("option: init cum tree\n");
				break;
			case GETOPT_VAL_INIT_EXTENT:
				printf("option: init extent tree\n");
				break;
			case GETOPT_VAL_CHECK_CSUM:
				printf("option: check csum\n");
				break;
			case GETOPT_VAL_MODE:
				printf("option: mode %s\n", optarg);
				break;
			case GETOPT_VAL_CLEAR_SPACE_CACHE:
				printf("option: clear space cache %s\n", optarg);
				break;
			case GETOPT_VAL_FORCE:
				printf("option: force\n");
				break;
			default:
				printf("unknown option %d\n", c);
				break;
		}
	}
	return 0;
}
---


--Ed0JYzbDE26t35vvzqazT9oEHQKFSqOOn--

--fWPoMfR7dn6TxXKZbdQ0kdw4z8lW3leKX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsoh+QACgkQwj2R86El
/qiUHAgAhKtUGOHTKr7AOMkX5nldpY62E+w6e3tgikkmexBUn9laEioP6ra74SR4
rfRFNKOsyHcSwii7Kvhjde3Z1IFfHuVNNS806QwxkHA4VM5bl6UxU8NdcD6SzmCw
CIfhEEd05aWUQIQnrhvCSNkBpAsLaB+Ze5xp8p7tIAzuNxxhUtJl2KKULoFy9DJ7
4SLAgFdVNA1ktHYYVnFRMysfJg8q/M3PD4DEwc47lomV4uE+vS4XwzFBzwTN7pJ1
K7UUAkfvbaNIBOv72fhkd+28ZglGMHeRd35tC029B1XyyYHz6mREFbiilgFkgR1N
rHjbKACZ8IO5K+jCytUXgrJGmNNyQQ==
=VHhF
-----END PGP SIGNATURE-----

--fWPoMfR7dn6TxXKZbdQ0kdw4z8lW3leKX--
