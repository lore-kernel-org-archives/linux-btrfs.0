Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53898 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933779AbeCGSYz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Mar 2018 13:24:55 -0500
Date: Wed, 7 Mar 2018 18:24:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Diego <diegocg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Improve error stats message
Message-ID: <20180307182453.GF20688@carfax.org.uk>
References: <1588327.cr4xlG2VNd@archlinux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uTRFFR9qmiCqR05s"
In-Reply-To: <1588327.cr4xlG2VNd@archlinux>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uTRFFR9qmiCqR05s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2018 at 06:37:29PM +0100, Diego wrote:
> A typical notification of filesystem errors looks like this:
> 
> BTRFS error (device sda2): bdev /dev/sda2 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
> 
> The device name is being printed twice.

   For good reason -- the first part ("device sda2") indicates the
filesystem, and is the arbitrarily-selected device used by the kernel
to represent the FS. The second part ("bdev /dev/sda2") indicates the
_actual_ device for which the errors are being reported.

   On multi-device filesystems, the two are not necessarily the same.

   Hugo.

> Also, these abbreviatures
> feel unnecesary. Make the message look like this instead:
> 
> BTRFS error (device sda2): errors: write 0, read 1, flush 0, corrupt 0, generation 0
> 
> 
> Signed-off-by: Diego Calleja <diegocg@gmail.com>
> ---
>  fs/btrfs/volumes.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2ceb924ca0d6..52fee5bb056f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7238,9 +7238,8 @@ static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
>  {
>  	if (!dev->dev_stats_valid)
>  		return;
> -	btrfs_err_rl_in_rcu(dev->fs_info,
> -		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
> -			   rcu_str_deref(dev->name),
> +	btrfs_err_rl(dev->fs_info,
> +		"errors: write %u, read %u, flush %u, corrupt %u, generation %u",
>  			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
>  			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
>  			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),

-- 
Hugo Mills             | Would you like an ocelot with that non-sequitur?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--uTRFFR9qmiCqR05s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaoC51AAoJEFheFHXiqx3kqHsP/RLYZxqMsGXPdf+e62EzXYd+
UKWIvM+L/ZEXhIlAxLQvMWVvvT+yQoRlNbmrAJKMhwtP+G/Z8xi6g+I7cJJSv2+N
MTy2apeSzUbE79lmsBXe5DCeOelg9/ebiL9cqb/QHd+bYsNa/acvfaXC0WDzDms7
kaTtX39tmyu2tN0UJEVy9JpJstQy2nYy7igY5L8wKT8PnwCdvnqCIMVdPr8lW7rC
AJGrKnRWChdjgzUTIvhJ1Oubkn7StK/cke9vDPtXjf8czNTJvzsrR4m8hPTHplmg
FQxuNVgPPsp3KzRi9XWpEOwitfTrT1Ak8LADhs79423mHM97BMIs2xWxlEOgiumG
TRrfDqI74+5GpWM1V/ZujmAO9mzsMTiijLjBxwSZjC3BdqWI2dOe13b47lm83rgI
lZgsak+SfVU8m5NJWtKrTftHIDpk9s5kGqqhgPUWJUGdxY7t/+Pu7DOHrk/ZdoJQ
aNyK/P0vP1fWScswCjWF1osh4XRPiFARZcPdU2AIWNHK6bLtVFA/HlQbjxs3EEWm
J0gNRbE3yiMiRyiBA7J9XpHLtZHZ8eSKvgns/y7Aw3Qp2ZuNVS8+A48O26t3Qedz
+U83YiWFvbf/5c1ekOTkmYNnPEwI2GY0EAjKOzKkXJL0FUNbnNxfl9aZGv1ZTMFW
8ksmvHADiDwKRLbE9ayG
=W2c4
-----END PGP SIGNATURE-----

--uTRFFR9qmiCqR05s--
