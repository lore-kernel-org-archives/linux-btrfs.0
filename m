Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45795 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752157AbdLWVCH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 16:02:07 -0500
Date: Sat, 23 Dec 2017 21:02:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hans van Kranenburg <hans@knorrie.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Fix progs_extra build dependencies
Message-ID: <20171223210206.GK18793@carfax.org.uk>
References: <20171223205238.19678-1-hans@knorrie.org>
 <20171223205238.19678-2-hans@knorrie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="j/HO4hzKTNbM1mOX"
In-Reply-To: <20171223205238.19678-2-hans@knorrie.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--j/HO4hzKTNbM1mOX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 23, 2017 at 09:52:37PM +0100, Hans van Kranenburg wrote:
> The Makefile does not have a dependency path that builds dependencies
> for tools listed in progs_extra.
> 
> E.g. doing make btrfs-show-super in a clean build environment results in:
>     gcc: error: cmds-inspect-dump-super.o: No such file or directory
>     Makefile:389: recipe for target 'btrfs-show-super' failed
> 
> Signed-off-by: Hans van Kranenburg <hans@knorrie.org>

   Hans and I worked this one out between us on IRC. Not sure if you
need this, but here it is:

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>

   Hugo.

> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 30a0ee22..390b138f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -220,7 +220,7 @@ cmds_restore_cflags = -DBTRFSRESTORE_ZSTD=$(BTRFSRESTORE_ZSTD)
>  CHECKER_FLAGS += $(btrfs_convert_cflags)
>  
>  # collect values of the variables above
> -standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs)))),$($(dep)))
> +standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs) $(progs_extra)))),$($(dep)))
>  
>  SUBDIRS =
>  BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))

-- 
Hugo Mills             | My code is never released, it escapes from the git
hugo@... carfax.org.uk | repo and kills a few beta testers on the way out.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             Diablo-D3

--j/HO4hzKTNbM1mOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaPsRNAAoJEFheFHXiqx3kFyUP/ii//vhFc4wCzyxrDboxGwKs
MOVH+vifXw8VSeuXDPmaT+NgDdVm+mjuV0/Yb/lGcWE2gzvbDejsAPh8LvaGdwqo
8LvfgoSPhGDjVoaW0px3smGIq6gmNOYJmTTzYTcaNgyhE8Nh8ps4tfxtr1G6BpM9
7JXA7/Tk824ZDedM1+EOBYrq82feJtXP3PWjW2P3hv5hT5w6zyW11uZeT2dXRNSh
4xQmX8k0i/dDfJlPFCqayeS2DumIJ8Ef7LNVrU3sYWPKSDsksHVLzKADU0bk7CWe
nURrbJQzLn6rE+hfMOmL6Y7K+4XroI8pD+AHJjGHRgvIbgppZKMr2zfIV0jhDmZa
zFUQfLyB4rwQoCtqcbB9zdRbKac3Z9xAxg5vwSdqCt/jno7Da/meueyRJK6UPG2q
o+xULtuyj9TokhfQYRzH7lRK4LH3DnS1XmQlEefrcRCHaB5WaocvAsWHaVFE/ifY
z8rcakwq0fO20x+pV2IW5AxcspFbteXLzAIeD4H9XQUVxdQ5sWKeUdjDISsAjlC7
oUO9lf5LHMwuuw6+ueaiaqvdCmqY37FLO/VsEdv2oEIoebXXg7i/Ksha2D5Fv+pl
wfbjrXa+ovNqyQCG06m+cVNjxcvtUiA8/GNpBgG6hNTp11QBsFaF3nLQnAcnkcNZ
AA+AxfQt011fBc29NAAL
=5hqz
-----END PGP SIGNATURE-----

--j/HO4hzKTNbM1mOX--
