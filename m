Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47326 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaDVOJD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 10:09:03 -0400
Date: Tue, 22 Apr 2014 15:09:00 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: read global reserve size from space infos
Message-ID: <20140422140900.GA30423@carfax.org.uk>
References: <1398172800-19548-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
In-Reply-To: <1398172800-19548-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 22, 2014 at 03:20:00PM +0200, David Sterba wrote:
> Kernels 3.15 > export the global block reserve as a space info presented
> by 'btrfs fi df' but would display 'unknown' instead of some meaningful
> string.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
> 
> Global_rsv or GlobalRsv or Globalrsv or something else?

   Personally, I'd probably go for the camel case GlobalRsv, or
possibly GlbReserve. (Assuming that it's going to be only a single
token without whitespace to make parsing easier).

   Hugo.

>  cmds-filesystem.c | 2 ++
>  ctree.h           | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 306f715475ac..5a3bbca91458 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -129,6 +129,8 @@ static char *group_type_str(u64 flag)
>  		return "Metadata";
>  	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
>  		return "Data+Metadata";
> +	case BTRFS_SPACE_INFO_GLOBAL_RSV:
> +		return "Global_rsv";
>  	default:
>  		return "unknown";
>  	}
> diff --git a/ctree.h b/ctree.h
> index a4d2cd114614..7e8ced718931 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -861,6 +861,8 @@ struct btrfs_csum_item {
>  /* used in struct btrfs_balance_args fields */
>  #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
>  
> +#define BTRFS_SPACE_INFO_GLOBAL_RSV    (1ULL << 49)
> +
>  #define BTRFS_QGROUP_STATUS_OFF			0
>  #define BTRFS_QGROUP_STATUS_ON			1
>  #define BTRFS_QGROUP_STATUS_SCANNING		2

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Some days,  it's just not worth gnawing through the straps. ---   

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1Z3/FheFHXiqx3kAQKr/g/6A9dwgWLQ+DCEbJ09fdnnc7IH0X0qZXGo
Ndvqy/1Eq1frepZQSD+Y496TYSMerfQblIUi2Aht0JTIkXVKMxqqxHV6yW1RA1Lc
lyQiQZbHsaVkGah4zl1y+hB3c8KW7tKeDaDJZNIreBfRBn4o060qJ77vgKbiQjiZ
eonJELuiK7qyM5AIRHfM14nV68TLzr9/JT/9xBCek8chBv2jSgJmS1GnYvWtogfL
LWqX1tmzLHDtkWsK409+y7w7ulOOMvDil95btQeC8/IdajXAJyZk50ZHBc7Q1BVE
1jN+BBGmYAmKO7DOoj3DDXqxSGf4FiYXMHxbfOGCbOiAR1cl52JeUXveYDZPUUJe
Pr5zjC8z5jXKY56tmpI2giqRYhiBPU7qAcBPlLH8KN5bqH3EzcSkR1RuXyZMs8Ex
EQOQpwgLYwFDJ7C04mvo1cIalY/c7//stBfTtbkYTokKmewT7JeJyFYZsiyUwocG
6xyE7/MptPVAeq2/zcJWeR1YAzBQ1cVJ1g/Iru5z0MZquOn4ZXTM6TvAZ3upblgW
5t8tOSwQ+KVGvOdNIZZQdvbWJsulyAoyq6IJQwokyfWXeEKGEVBL6z7Ji7OOim54
rEMRgwZkZXFxikDjB8lAgzT2ydmxmnhNrWtNJ6qPyRw04Yk6kGrhEOGgQtc/qOWT
VuP/1yYdgVw=
=UFxf
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
