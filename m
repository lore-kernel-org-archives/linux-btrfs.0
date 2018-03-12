Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932687AbeCLDY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Mar 2018 23:24:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6345BAEBF
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Mar 2018 03:24:28 +0000 (UTC)
Subject: Re: [PATCH 13/20] btrfs-progs: use cmd_struct as command entry point
To: linux-btrfs@vger.kernel.org
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-14-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <d81d6ee4-0fd9-9185-261d-38e414515f72@suse.com>
Date: Sun, 11 Mar 2018 23:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <20180308024047.10104-14-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T9e1Oy9HvZHlC0NflaGS0sbtbaK8P3kBc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T9e1Oy9HvZHlC0NflaGS0sbtbaK8P3kBc
Content-Type: multipart/mixed; boundary="GhxnPLD1VkHO57L3lpvKOeCax6pwEtr54";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <d81d6ee4-0fd9-9185-261d-38e414515f72@suse.com>
Subject: Re: [PATCH 13/20] btrfs-progs: use cmd_struct as command entry point
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-14-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-14-jeffm@suse.com>

--GhxnPLD1VkHO57L3lpvKOeCax6pwEtr54
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/18 9:40 PM, jeffm@suse.com wrote:
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 62112705..ec038f2f 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -1075,6 +1078,7 @@ next:
> =20
>  	return !!defrag_global_errors;
>  }
> +static DEFINE_SIMPLE_COMMAND(filesystem_defrag, "defrag");

"defragment"

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--GhxnPLD1VkHO57L3lpvKOeCax6pwEtr54--

--T9e1Oy9HvZHlC0NflaGS0sbtbaK8P3kBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlql8uoACgkQHntLYyF5
5bJVgQ//ZNADTgk4ApGcLMALsHvI59H3PFC2dug3vc9YeluDfpXs3aXrtkJ9IOH7
ZfP7WVDVJUg/J9pGynOd0XgCLlLDu23ayPzCXnqL8zYwOfLu91LMtppsY+P4JQ4j
VJ+iCcsMllDLs87SqyJMOe3Q29TEOO1AmdJ6Te8L6pudsGbZ2yY4P05rxry2LBHA
+3FagFr92ANH8GtXxpxiHoIXURvTzu5oYy61mCKBmz9LXhj96M0FOSjoHNWhFZ68
Fb80C9plqe9GxmhmLjaz/mzWEh8bB93/D0utNlPbvMqRlz2Jps+bHSaTtpW1Wz10
EOULyrj2dH5hjfwSNKPH8I5PMA2kShTP9xyaRBTRRjL2arNO1spk0MyKI1dTIV7X
da2KMOpeo1Zhy94HGDs8SHlSWbKeGTQ5GJkbTympdcbzfyR6wZtMKQXY7DtAJiYy
loXl5wu6T0hY/8Fy5m7i9pVTki86FASRNjLbCt56sz1pcPpXsVbeQ0obokHSB08L
xBOZjKnbPvyqKSRu6Ccbl7ElizW9+PQ7f+ftrIFLyMDdFkpU1OjTUaZ35cvLtIai
F4IlfI4uotcfoBZIbbrBE/IB2We3HY8IEuU713wp/atPq5YWYxUqXhlffBg0ycUQ
mU9dvtWHlVF9QB+FxWUz9u94VwdiutwWfBTZ2oMwZ8+zJXjt5k4=
=PU05
-----END PGP SIGNATURE-----

--T9e1Oy9HvZHlC0NflaGS0sbtbaK8P3kBc--
