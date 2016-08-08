Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58739 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcHHSwm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 14:52:42 -0400
Date: Mon, 8 Aug 2016 18:52:37 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ivan Sizov <sivan606@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Strange behavior after "rm -rf //"
Message-ID: <20160808185237.GA9644@carfax.org.uk>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
 <CAJCQCtSs5bHZu5NLjVfJLgxL45BdNq7hrmV3VdCLz+WxLEXrMw@mail.gmail.com>
 <CAMG9ccwqnK63sbcF79VndBMitvFjX6pHPCU9YrrZcwEdiQxY5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
In-Reply-To: <CAMG9ccwqnK63sbcF79VndBMitvFjX6pHPCU9YrrZcwEdiQxY5w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 08, 2016 at 09:38:28PM +0300, Ivan Sizov wrote:
> 2016-08-08 20:13 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
> > Just a wild guess, the deletions may be in the tree log and haven't
> > been applied to the other trees (fs tree, extent tree, etc). So yes
> > I'd expect they get deleted on a rw mount.
> >
> > This is what kernel? Because kernel 4.6 offers mount option
> > "nologreplay" which suggests even if you do mount -r that log replay
> > happens, so you shouldn't see these deleted files unless you mount ro
> > *and* use nologreplay mount option.
> 
> Live USB has kernel 4.5.7. Maybe I should try to run "btrfs rescue
> zero-log" and then mount RW? Will the files safe in that case?
> 
> > Anyway, even 5 seconds of rm -rf damages too much. If you don't have
> > recent snapshots then it's not sanely salvageable, just reinstall.
> 
> As I could see, almost all the "deleted" files are present. Certainly,
> I'll make an rsync diff between two-week-ago snapshot and the current
> FS state. But it will better if in-place recover without backup is
> possible.
> 
> P.S. IMHO, log replay by default is a quite dangerous thing. I didn't
> know about that change and I could lose all files if the live USB had
> 4.6 kernel))

   Log reply on mount has _always_ been the default, and should remain
so. It gives you the expected semantics after a power loss: all th
efiles that you'd written up to the point of the power loss actually
appear afterwards. (If this didn't happen, you could lose up to 30s of
writes from before the crash).

   It's only very recently that there's been an option to prevent it,
which is useful in a limited number of cases (such as trying to
undelete a file, which is not really a supported operation in any
case).

   Hugo.

-- 
Hugo Mills             | "I lost my leg in 1942. Some bastard stole it in a
hugo@... carfax.org.uk | pub in Pimlico."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXqNT0AAoJEFheFHXiqx3kCNEQAKMVZIdxPpHTFwJRq0jNfHBD
M5qTCiCOsLjpSdlJsXcGTcXThSUMjrxMgA8dSQSBt7sChOHUcHGdalzTCXE9tOHT
dWG0D2CuwV4krYO/9Su0bbJlvgJa/lCZd9QzAYaZZd1miSbfLOP+HfGkLP0MrPJs
VcbX6+Qb2DJOrSyx9AjyGN2Zumtz3TUzMCK0rmygmYBJP27MzFaDJOh3m2qwFcbH
Cevak3Hi3rG/BmTJVhUiZbrrjVrpZCh6E5tJcFCTRpnsh4aeoN05dBVAhKDIBU84
SPMsm9sMdF6K2XByQaZQcLh9No7Q2WQYefldS91XjjB/UJHBFxaJK6CHxyOYjECB
dtwWECBH1NYcdlNqXcxQ/hFZv3WTDdw7Gj6IHtQssa/ORrIlNBO1m458absk65bp
gmeVvkcP4rPJdr1sRz/h2oAgzCm4zMWzTqxjExrKfuxtp5OYEnlmYsauuYgRhlIa
U7P4OyLERSBFvEsxzataSzruZceQ/5lr6JceFCQt3zrfbVT69TwGDi5YN3hgPkCe
jZH44cTKqIA+B8qt17u3mcJVaDG3XZF4rXUDDdl3u+ECU+I/hG4FlLuV0n49v3gO
pZiEzbxbDjg2L3gBtKsgOovt9hXGRVcsOSnOaLdulrP7rVYe5lEntqrvGs0G4epu
rI+a/rjatLDHEXuAH+i9
=VMPU
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
