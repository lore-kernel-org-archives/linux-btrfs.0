Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59882 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbbHZUAH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 16:00:07 -0400
Date: Wed, 26 Aug 2015 20:00:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs duperemove corrupt data while dedup
Message-ID: <20150826200005.GF23769@carfax.org.uk>
References: <CAGqmi76J4XWv+ureSG66Da_E-xq3MqGahbhsaTR6Sf2rSHd4Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hK8Uo4Yp55NZU70L"
In-Reply-To: <CAGqmi76J4XWv+ureSG66Da_E-xq3MqGahbhsaTR6Sf2rSHd4Ug@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 26, 2015 at 10:33:38PM +0300, Timofey Titovets wrote:
> Hello guys,
> i like btrfs, and i want put it in production soon,
> one of the feature that i want use, is a deduplication.
> 
> i frequently testing duperemove on btrfs and already see this problem before.
> i know what btrfs before, change mtime while deduping, but after dedup
> fixes from Mark (https://github.com/markfasheh), i've try to get
> checksums.
> 
> As i know duperemove use kernel ioctl for deduping, i.e. it's not a
> duperemove issue, kernel must keep data consistent.
> 
> File system is fresh and btrfs check not show any metadata corruption.
> 
> Github issue:
> https://github.com/markfasheh/duperemove/issues/91
> 
> System info:
> $ uname -a
> Linux titovetst-beplan 4.2.0-rc8-next-20150825-0959-ARCH #1 SMP Wed
> Aug 26 10:27:18 MSK 2015 x86_64 GNU/Linux
> 
> Mount options:
> rw,relatime,compress=lzo,space_cache,subvolid=257,subvol=/@home
> 
> Okay, how i find it:
> 
> md5sum_recursive(){
>         find $@ -type f -exec md5sum {} \;
> }
> 
> cp -av --reflink=always ~/<src> ~/<dest>
> md5sum_recursive ~/<dest> > ~/dedup.before
> duperemove -vhrdb 8k ~/<dest>
> md5sum_recursive ~/<dest> > ~/dedup.after
> diff -up ~/dedup.before ~/dedup.after
> 
> what i've got (full diff in attach):
> --- /home/nefelim4ag/dedup.after        2015-08-26 21:36:55.773452558 +0300
> +++ /home/nefelim4ag/dedup.before       2015-08-26 21:21:01.203600761 +0300
> @@ -25139,9 +25139,9 @@ caf9d41036e46b85d90a9541e8bc9ce1  /home/
> ....
> -0ccbc9c81a51f59dcf2ac0d102de37cb
> /home/nefelim4ag/L4D2/left4dead2/pak01_003.vpk
> +e665b502ee977dc1c619ecbd415c91b8
> /home/nefelim4ag/L4D2/left4dead2/pak01_000.vpk
> ....

   Note that these are two different files, and would therefore be
expected to have different checksums. My guess would be that the order
of enumeration for the find is different in some way, and you should
sort the output before comparing it.

   Hugo.

> Files sizes not changed and it's > 1MB.
> 
> Every time i've get a random data corruption.
> Only dependencies what i've find it is what smallest block -> more
> corruptions and vise versa, i.e. more data deduped -> more corrupted.
> 
> Smart of the disk, it's not looks, like damaged. (attach)
> 
> What i can provide to help fix this issue?
> If it's needed, i can recompile kernel with some parameters if it can
> help, of course.

-- 
Hugo Mills             | Something must be done!
hugo@... carfax.org.uk | This is something.
http://carfax.org.uk/  | Therefore we will do it!
PGP: E2AB1DE4          |                                  Management syllogism

--hK8Uo4Yp55NZU70L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV3hrFAAoJEFheFHXiqx3kX/gQALeGu5bPzV6ETWqD+G90s59G
IjHqNeN7Rgxbv600yWPTbr0+SoMNS1rETypB8quvobDwrttvDsKRozpjJq0cDxlM
sZ7PMQkZEjXsP6Yez0Y1A7ktofK6gXPBYzAUD1HeypGKzfYhkNbSXs4yJ8s09ylV
leke64xsk7/h+Uh5fBUZn0NygYdMz5dOboxMhz8OiCqk0tPlTVjRnpq0x4uC4/UF
Ng12K3rSZdI8OEpK1wNP60vel/S8xRUcgThBFnBdTPk9nDgj+rEvsr8EJ6zsrS8Q
uCd4Q+1mFKHdhcNxt4rMhXFzpbTbs14BETnkD2WWeWIu013ErOQdX5JVuIpXWzbB
G5AsIjhtlkASnbfpzpkwaY2p5KYI/1UOvL91/4BbyVEeULz3+h4pRgDfY3qHNE5U
UiLqAj6rIyWHG9faLEVbb8p4Jbs2rekSPpVMpLDpyCPpcqBg63lWOcIsZ0/eJkN7
PMaMSwEK/csaFohLf3g/Gf3vlFT0C9APVfO9AjNoVo8OLUjXGifj2QbzYJlAsShp
nwcAj14oY2+hnho/CR6roRw+tDEJkQj2P8cRv/Fh1EBh260O9l7I3KdVrwvushXy
37orU0vC2lHDBEx5sSuGjzBnIyOcewLLoraVdnVuOcqFijY1aSagMrK4Ya82Xzku
pYC37Zy03RwJEntfTFcf
=UnNk
-----END PGP SIGNATURE-----

--hK8Uo4Yp55NZU70L--
