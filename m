Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53654 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaBKS5Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 13:57:24 -0500
Date: Tue, 11 Feb 2014 18:56:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
Message-ID: <20140211185657.GM6490@carfax.org.uk>
References: <52F9014F.6070901@fb.com>
 <52F95222.1010403@libero.it>
 <52FA224B.1030805@fb.com>
 <52FA69E7.7020206@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7vLGWvOrvbSM0Ba8"
In-Reply-To: <52FA69E7.7020206@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7vLGWvOrvbSM0Ba8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 11, 2014 at 07:20:23PM +0100, Goffredo Baroncelli wrote:
> On 02/11/2014 02:14 PM, Josef Bacik wrote:
> > 
> > 
> > On 02/10/2014 05:26 PM, Goffredo Baroncelli wrote:
> >> On 02/10/2014 05:41 PM, Josef Bacik wrote:
> >>> ===== New and improved btrfs fi df =====
> [...]
> 
> Hi Josef
> 
> > The problem I had with this patch was it didn't give me a way to get
> > the original output.  I as a developer really need to have the raw
> > dump of the block group info as I'm doing stuff.  So I like this
> > output, but I still need my old output, if you fix that part up I'll
> > review/ack it. Thanks,
> 
> I am open to improve this patch. What about the following output (it 
> was a copy and paste, no code for now, the number are invented)
> 
> $ sudo btrfs filesystem df /mnt/btrfs1/
> Disk size:		 400.00GB
> Disk unallocated:	 391.97GB
> Disk allocation:
>                         Allocated	Used
>    Data, single:           2.01GB,         1.00GB
>    System, DUP:            4.00MB          2.00MB
>    System, single:         4.00MB          1.00MB
>    Metadata, DUP:          2.00GB        750.00MB
>    Metadata, single:       8.00MB          2.20MB
>                            ------         -------
>    Total:                  7.00GB          1.75GB

   Two minor nits here: please put a space between the number and the
units, and distinguish between e.g. MB (powers of 10) and MiB (powers
of 2).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- But somewhere along the line, it seems / That pimp became ---    
                       cool,  and punk mainstream.                       

--7vLGWvOrvbSM0Ba8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvpyeVheFHXiqx3kAQKS8w//aUK/revrBZFHbpzZEtEtMQ1oifUG41Co
VwbzKpADqGEblscwBr2OVWnxJUDXWuuaF+0SJbZQIWk3B3f/ywIJYpZPQW8XeYrm
8aa4XQr8JEeEKduJtSAqaTwQfrjyUlew7v10se7WhgGaPheUD8+8vcCCIEKUvoV4
S+CyPG+wGrh0FpT47hGXt6IQVfPSOjLlE9xqvzFtx/KSq1tCHaQHz3uQICSishAe
xKdV6MzIH/rF2xdXbs1XNYxtmw0sQIH8WWomUOF/feMdCVcJ19vM6eopQbhpGCFg
YdmaEiqmKp8q05SC+uvSNvmexv9AdQSEzJ8Z+xbh9aeGZLix9AdJT1xHcO/Cwbjp
mOm+aUTfJAgIkBF47OdZJQThGPJN7VaC5Taw5Q0bcX+xPHT/eY9MTzpQhU+nvu/C
McxYO4W5PjopGvWrQW3+tejjA2SDrV3ecxc3jVXwQGHmhk9Lz+lc6JTrgebwT8UO
fpl9dmMLcEYgBPdnAF/JAVJx+Rk1vjXn+6OAhsLqRwkNpX98IsQFY2XMI8IRAFXq
xCLvx9mJWd7s5sD87vvmFHo0SQqOroo6svc+gpAWW0a2X6yx8w6ozgQkVgRc4+eg
3XK83Awh9LmR7gg0eppjG0Esp41P/CPAHuYNyqcla3/WmMjkRW5cndwH7aEF7F3O
nioNxfu5ZRw=
=0cix
-----END PGP SIGNATURE-----

--7vLGWvOrvbSM0Ba8--
