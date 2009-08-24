From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: Re: [PATCH]Re: The first character disappears
Date: Mon, 24 Aug 2009 16:52:06 +0300
Message-ID: <bcf98daa0908240652p22b786a9m9c9b3d563b0903f6@mail.gmail.com>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
	 <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
	 <20090824115232.GC15449@think> <4A928CEF.2060903@dpf.gov.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Atila <atila.alr@dpf.gov.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A928CEF.2060903@dpf.gov.br>
List-ID: <linux-btrfs.vger.kernel.org>

After this patch against the latest
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstabl=
e.git
bcp don't eat the first character anymore, thanks :)


2009/8/24 Atila <atila.alr@dpf.gov.br>:
> *
> Signed-off-by: Atila <atila.alr@dpf.gov.br>
> ---
> =A0bcp | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/bcp b/bcp
> index 5729e91..7c6b351 100755
> --- a/bcp
> +++ b/bcp
> @@ -107,7 +107,7 @@ if src_args > 1:
> =A0 =A0 =A0 =A0 exit(1)
>
> =A0for srci in xrange(0, src_args):
> - =A0 =A0src =3D args[srci]
> + =A0 =A0src =3D args[srci].strip('/')
> =A0 =A0 if os.path.isfile(src):
> =A0 =A0 =A0 =A0 statinfo =3D os.lstat(src)
> =A0 =A0 =A0 =A0 force_name =3D None
> @@ -136,7 +136,7 @@ for srci in xrange(0, src_args):
> =A0 =A0 =A0 =A0 =A0 =A0 srcname =3D os.path.join(dirpath, x)
> =A0 =A0 =A0 =A0 =A0 =A0 statinfo =3D os.lstat(srcname)
>
> - =A0 =A0 =A0 =A0 =A0 =A0if srcname.startswith(src):
> + =A0 =A0 =A0 =A0 =A0 =A0if srcname.startswith(src + '/'):
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 part =3D srcname[len(src) + 1:]
>
> =A0 =A0 =A0 =A0 =A0 =A0 if stat.S_ISLNK(statinfo.st_mode):
> @@ -152,7 +152,7 @@ for srci in xrange(0, src_args):
>
> =A0 =A0 =A0 =A0 for f in filenames:
> =A0 =A0 =A0 =A0 =A0 =A0 srcname =3D os.path.join(dirpath, f)
> - =A0 =A0 =A0 =A0 =A0 =A0if srcname.startswith(src):
> + =A0 =A0 =A0 =A0 =A0 =A0if srcname.startswith(src + '/'):
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 part =3D srcname[len(src) + 1:]
>
> =A0 =A0 =A0 =A0 =A0 =A0 statinfo =3D os.lstat(srcname)
> --
> 1.6.4
>
> *
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
