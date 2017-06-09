Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48444 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdFIQDm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 12:03:42 -0400
Date: Fri, 9 Jun 2017 16:03:37 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Filip Bystricky <filipbystricky@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs native encryption
Message-ID: <20170609160337.GA30723@carfax.org.uk>
References: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
In-Reply-To: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 09, 2017 at 08:50:12AM -0700, Filip Bystricky wrote:
> Dear btrfs maintainers,
> Google is evaluating btrfs for its potential use in android, but
> currently the lack of native file-based encryption unfortunately makes
> it a nonstarter. According to the FAQ (specifically the answer to
> "Does btrfs support encryption"), nobody is currently working on this.
> How up-to-date is that answer, and are there any new plans to add
> native FBE in the future?

   There were initial patches from Anand Jain back in September, but
they weren't well-received in terms of the (lack of) cryptography
design. IIRC, the patches provided file-level data encryption without
encrypting metadata. I haven't seen anything since then (although
Anand was planning on doing a session on btrfs encryption at LSF/MM in
March -- I don't know if that happened, or what the outcome was).

   So, there's some interest in a fairly minimal implementation, but
progress doesn't seem to be particularly fast.

   Hugo.

-- 
Hugo Mills             | "Are you the man who rules the Universe?" "Well, I
hugo@... carfax.org.uk | try not to."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                    Life, the Universe and Everything.

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZOsbZAAoJEFheFHXiqx3klo4P/1Yo4FUWVNZUx7f/e1Xdrw+O
w1d53KcJXDr3ED1QNqSF1ygcAgrQYxs625lQ2rm0r9wXDvi6z9DkaWgL4FWsVis+
M0EXtrBMVJ+ruy1MmtaSlUk5hoDlNORvq/xB09q6mPhHoWFtW6o66gojbucYZy0Q
w2cZTkReYBseB7YzTm5ah6YrpWzJOwgB05h9QjtCcL3fN+iQ06coCLxUhbeUC5Mu
U6SOyiOGagxQWKZHS0ElCv6tHeZJbtwWWmKtntu3UOLGFQ2uWNg+bquYF59wrWwX
UIz2DMASQkTJhwa6hDO7nBgyFx7S/H72B/Q63LBhEb+U5vwltq9wqKbqBjjqG0+U
NaDUheu+Ub07PpXKjTb3hwDqKjTaOfQ/LHjntEWmo4AOG+KCKxXY6juvOBXgLYGn
XrKisggGKxiTkS4Z/WN+XiiiYm4zt64vq8asnd/5Yj2O1iTsdm9Eqqpvsa6IBiCZ
XKRJ4qL/8cKhUnjY/nCSpidx9toH/JgZVRo3WDD4nmV4uDxg41joIgHur7KwncOd
q9FSQ09NFkY6MTOreWGBiEGUEolpZr+gLjbjvNU/Sm+/m9TJlGgjeAA4M8p9HIM6
1RnKo4a2PQsNtE6elGgmGCyInIUb/vL/KqK0pFu9JRd4IEU921HWjNF8UUDauVSy
QvkTiysDgkdgNc+pFNu0
=HOAs
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
