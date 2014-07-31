Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45910 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaGaTJf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 15:09:35 -0400
Date: Thu, 31 Jul 2014 20:09:10 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support to check for FALLOC_FL_COLLAPSE_RANGE  and
 FALLOC_FL_ZERO_RANGE crap modes
Message-ID: <20140731190910.GP31950@carfax.org.uk>
References: <1406829213-4759-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fjEAjMKpll6GDq3U"
In-Reply-To: <1406829213-4759-1-git-send-email-xerofoify@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fjEAjMKpll6GDq3U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 31, 2014 at 01:53:33PM -0400, Nicholas Krause wrote:
> This adds checks for the stated modes as if they are crap we will return error
> not supported.

   You've just enabled two options, but you haven't actually
implemented the code behind it. I would tell you *NOT* to do anything
else on this work until you can answer the question: What happens if
you apply this patch, create a large file called "foo.txt", and then a
userspace program executes the following code?

int fd = open("foo.txt", O_RDWR);
fallocate(fd, FALLOCATE_FL_COLLAPSE_RANGE, 50, 50);

   Try it on a btrfs filesystem, both with and without your patch.
Also try it on an ext4 filesystem.

   Once you've done all of that, reply to this mail and tell me what
the problem is with this patch. You need to make two answers: what are
the technical problems with the patch? What errors have you made in
the development process?

   *Only* if you can answer those questions sensibly, should you write
any more patches, of any kind.

   Hugo.

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  fs/btrfs/file.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 1f2b99c..599495a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2490,7 +2490,8 @@ static long btrfs_fallocate(struct file *file, int mode,
>  	alloc_end = round_up(offset + len, blocksize);
>  
>  	/* Make sure we aren't being give some crap mode */
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE|
> +	FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
>  		return -EOPNOTSUPP;
>  
>  	if (mode & FALLOC_FL_PUNCH_HOLE)
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The glass is neither half-full nor half-empty; it is twice as ---  
                        large as it needs to be.                         

--fjEAjMKpll6GDq3U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9qUVlheFHXiqx3kAQL+qw/9HV1Y2bBRYUCgboJXscwoLC+8YF3JBlo5
WfDCnkUxw+w7m8yXP9N7ZS7nztyb3bAinrP+h4qTf2MP09EVIYH6CYHq0DDavGwr
LwuLsgJS6CTgW6Fgu0XXtQFZAQhwZYHidSm/+bfH9dQ9rnBHXecM+uE2jfpSiF5Z
TBu+HH5AP+tvqkMtk8SNI7SR2ISYQZWkHB/kN7YQsloZdUkzyIRyee1E6LSrOb4/
kEbjblUbIAJpNiJuAmMbe9hUJ1rzeE08joTzKUu9O0Yq34/pMiMy5yeZZCZCn88P
7K9msBgL+9zwxUBhBsKJd3Lmmo/9AmZObwDhbozfhhb20IosedDhlxMxbrbYdZ7p
Q0PHL3VLrU/RVBcy+KbLF10Kb6YBwjagjnjUSQO7T6kHlcz7nPWpedxNwLKb4nqq
DmkAaWM9QNo2u0/Sw3Ef3O+gE+ZS5y5n9evWSnuNzUb78BnRmG9HfpFptEi7rFrw
NhBCSvlaLPJ2w36PDh/VkQUAyfQJP88dD8Okbk6BOBcqonCqGZgyjFlE5pKmnfXY
YdlmMcB7DHEY/KJlfYwNM9eVjkvuE2pA4ZZPtXhw64JceKD5/VMeQjaQXjqoUcX1
9dxeqzh6bzVeoTt+PoBuHHXfWvZ6qmv4Cd3zC6IMlmc/KsIsiHyfmE9XMdKw13b6
DFBgCSpXxiQ=
=W+li
-----END PGP SIGNATURE-----

--fjEAjMKpll6GDq3U--
