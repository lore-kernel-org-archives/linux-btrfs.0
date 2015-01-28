Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42449 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbbA2DVi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 22:21:38 -0500
Date: Wed, 28 Jan 2015 10:07:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: Make option parsing more robust to code
 modifications
Message-ID: <20150128100728.GL1654@carfax.org.uk>
References: <1422371153-17355-1-git-send-email-hugo@carfax.org.uk>
 <54C8383E.3030500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iAzLNm1y1mIRgolD"
In-Reply-To: <54C8383E.3030500@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--iAzLNm1y1mIRgolD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2015 at 09:15:42AM +0800, Qu Wenruo wrote:
> -------- Original Message --------
> Subject: [PATCH 1/2] btrfs-progs: Make option parsing more robust to
> code modifications
> From: Hugo Mills <hugo@carfax.org.uk>
> To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
> Date: 2015=E5=B9=B401=E6=9C=8827=E6=97=A5 23:05
> >The current approach to option parsing, where long-only options are
> >selected on the basis of their position in the long_options array is
> >fragile and painful to modify if options are to be inserted into the
> >list, rather than appended.
> >
> >Instead, use the last field of struct option to return a value which
> >cannot be a char (and hence a short option), and simply switch on those
> >within the case statement.
> This is much much better than original immediate number.
> The original way always takes me extra time to count the number.
> >
> >Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> >---
> >  cmds-check.c | 49 +++++++++++++++++++++++++++----------------------
> >  1 file changed, 27 insertions(+), 22 deletions(-)
> >
> >diff --git a/cmds-check.c b/cmds-check.c
> >index f06e029..a1226c6 100644
> >--- a/cmds-check.c
> >+++ b/cmds-check.c
> >@@ -8403,13 +8403,15 @@ out:
> >  	return bad_roots;
> >  }
> >+enum { OPT_REPAIR =3D 257, OPT_INIT_CSUM, OPT_INIT_EXTENT, OPT_CHECK_CS=
UM };
> >+
> I'm a little interested in why assigning 257 to OPT_REPAIR.
> Does it have any extra meaning?

   getopt_long returns the character code of the option, for short
options, and returns the struct option->val value for a long
option. If you want to avoid handling options twice (once for the
short, and once for the long), it makes sense to return the short
character code as the "val" for the long options, where one
exists. Where it doesn't exist, we need some other value which isn't
going to cause clashes with the single-character namespace. Hence
starting above the value range of char.

   In hindsight, starting at 256 would have been good, but it's
actually completely irrelevant, as long as the value is strictly
larger than 255.

   Hugo.

> >  static struct option long_options[] =3D {
> >  	{ "super", 1, NULL, 's' },
> >-	{ "repair", 0, NULL, 0 },
> >-	{ "init-csum-tree", 0, NULL, 0 },
> >-	{ "init-extent-tree", 0, NULL, 0 },
> >-	{ "check-data-csum", 0, NULL, 0 },
> >-	{ "backup", 0, NULL, 0 },
> >+	{ "repair", 0, NULL, OPT_REPAIR },
> >+	{ "init-csum-tree", 0, NULL, OPT_INIT_CSUM },
> >+	{ "init-extent-tree", 0, NULL, OPT_INIT_EXTENT },
> >+	{ "check-data-csum", 0, NULL, OPT_CHECK_CSUM },
> >+	{ "backup", 0, NULL, 'b' },
> >  	{ "subvol-extents", 1, NULL, 'E' },
> >  	{ "qgroup-report", 0, NULL, 'Q' },
> >  	{ "tree-root", 1, NULL, 'r' },
> >@@ -8483,23 +8485,26 @@ int cmd_check(int argc, char **argv)
> >  			case '?':
> >  			case 'h':
> >  				usage(cmd_check_usage);
> >-		}
> >-		if (option_index =3D=3D 1) {
> >-			printf("enabling repair mode\n");
> >-			repair =3D 1;
> >-			ctree_flags |=3D OPEN_CTREE_WRITES;
> >-		} else if (option_index =3D=3D 2) {
> >-			printf("Creating a new CRC tree\n");
> >-			init_csum_tree =3D 1;
> >-			repair =3D 1;
> >-			ctree_flags |=3D OPEN_CTREE_WRITES;
> >-		} else if (option_index =3D=3D 3) {
> >-			init_extent_tree =3D 1;
> >-			ctree_flags |=3D (OPEN_CTREE_WRITES |
> >-					OPEN_CTREE_NO_BLOCK_GROUPS);
> >-			repair =3D 1;
> >-		} else if (option_index =3D=3D 4) {
> >-			check_data_csum =3D 1;
> >+			case OPT_REPAIR:
> >+				printf("enabling repair mode\n");
> >+				repair =3D 1;
> >+				ctree_flags |=3D OPEN_CTREE_WRITES;
> >+				break;
> >+			case OPT_INIT_CSUM:
> >+				printf("Creating a new CRC tree\n");
> >+				init_csum_tree =3D 1;
> >+				repair =3D 1;
> >+				ctree_flags |=3D OPEN_CTREE_WRITES;
> >+				break;
> >+			case OPT_INIT_EXTENT:
> >+				init_extent_tree =3D 1;
> >+				ctree_flags |=3D (OPEN_CTREE_WRITES |
> >+						OPEN_CTREE_NO_BLOCK_GROUPS);
> >+				repair =3D 1;
> >+				break;
> >+			case OPT_CHECK_CSUM:
> >+				check_data_csum =3D 1;
> >+				break;
> >  		}
> >  	}
> >  	argc =3D argc - optind;
> The rest looks good to me.
>=20
> Thanks,
> Qu

--=20
Hugo Mills             | "You know, the British have always been nice to mad
hugo@... carfax.org.uk | people."
http://carfax.org.uk/  |
PGP: 65E74AC0          |                         Laura Jesson, Brief Encoun=
ter

--iAzLNm1y1mIRgolD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUyLTgAAoJEFheFHXiqx3kPLEP/R5RbFWnhqKV3cs6/3fO0PSN
gPDL0SUAsvNMv3HHtOysXt/p9XzivYFroXiP1P/WJ8smunv8aH0755IyO1yr8jdn
WywgQ44fFcMpRSMpKmWOb+B3836M2g7Rf0/Kbe/vggtjR0Njuynw0uAnfk9tl6PC
wjM1mrMMxUHGg9MbdFMfhtI/+00N1hph1MItn5WSC03ZCqFJAFo3vSV1RHDCC8ZO
ERkqCTnL0rpkRUY3xZKc8ej3QNm/0vCU/GhWYz8c6RJ2DJDgA/uI92buSDpHlPDI
O1dEqdXnt6sz8N1NI5wPdk66ca9TkYgOsiE3iKAFNCb6sWEyCqtxPZq4gClJl8O1
wqU42UPcS2gOSNow3gl4NBNCNpA15DVqDycDbxTl8eCulZKy9MDCnK+tr7x50wvV
H4lwI1T7dSCmZfY9tNSlSStZ/T1mOxTy3Kn0vgPoiwQp/PqOCQ8cyA4rojaEgrNW
50ddfkvPpDJ0b9csNGY1RX4rtMlm7tcEfEqT+XDc5MZReb1c0VK0tTM7HTnz5PjM
zECyi+laoSDx6IFyTPYlYoCpNLZhub9ndYu07DHE13gwqwN44NxTAIe7By7Ar9YV
jfyIT77D+N7Wtuvh1GymHHfk78uleIVPCDx+tXtiKfV0QELMdDJy9CcEiU0tQWkz
JzNafCUL3mQwPTgfvz+7
=atLu
-----END PGP SIGNATURE-----

--iAzLNm1y1mIRgolD--
