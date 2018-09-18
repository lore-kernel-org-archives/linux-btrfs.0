Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36144 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729946AbeISAQV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:16:21 -0400
Date: Tue, 18 Sep 2018 18:42:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Gervais, Francois" <FGervais@distech-controls.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs receive incremental stream on another uuid
Message-ID: <20180918184225.GB5429@carfax.org.uk>
References: <BN6PR01MB2531F06B0557C31005C5E6E7F31D0@BN6PR01MB2531.prod.exchangelabs.com>
 <eeba538c-bcc1-8f70-c9b7-b277eec57b36@gmail.com>
 <BN6PR01MB253106EF09795A3F64C61AC8F31D0@BN6PR01MB2531.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
In-Reply-To: <BN6PR01MB253106EF09795A3F64C61AC8F31D0@BN6PR01MB2531.prod.exchangelabs.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 18, 2018 at 06:28:37PM +0000, Gervais, Francois wrote:
> > No. It is already possible (by setting received UUID); it should not be
> made too open to easy abuse.
> 
> 
> Do you mean edit the UUID in the byte stream before btrfs receive?

   No, there's an ioctl to change the received UUID of a
subvolume. It's used by receive, at the very end of the receive
operation.

   Messing around in this area is basically a recipe for ending up
with a half-completed send/receive full of broken data because the
receiving subvolume isn't quite as identical as you thought. It
enforces the rules for a reason.

   Now, it's possible to modify the send stream and the logic around
it a bit to support a number of additional modes of operation
(bidirectional send, for example), but that's queued up waiting for
(a) a definitive list of send stream format changes, and (b) David's
bandwidth to put them together in one patch set.

   If you want to see more on the underlying UUID model, and how it
could be (ab)used and modified, there's a write-up here, in a thread
on pretty much exactly the same proposal that you've just made:

https://www.spinics.net/lists/linux-btrfs/msg44089.html

   Hugo.

-- 
Hugo Mills             | Great films about cricket: Monster's No-Ball
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJboUcRAAoJEFheFHXiqx3ky0MP/jjI73keRZJViXfe8z5GzAqS
RKK1L83ZFSZm3EmqvH9m3WQeKmJ8tWyePT9xg94VOz9FF0prLy9KEgW6ADt+lzfk
8gsIFJ+L6Q1rGk/xmXIYJH/DLA+DiCRaE2MJtwyUsVtTg4ix2NqKyvQ7iOAQVqhB
Grrl3DEjiVfIFV/q2N8cdsAec8LjaQIbQkqpihvpFV8XRgZRoj1BoMRLSR5sGbm3
HH5UBhJOUYK0VVulEkQYXz9kQuiGnGwDlfYGpGtGuJAmQzZFYKXzzcdyqJigAZo/
dKV+EkvmuO7pmy9YEqO6HBl67x5+/YTnq0GeYwbRDROXoYEI6WupZSTEObv/Ia0/
nOEpGfEjCcW27IKMvsJ5A+uWqwOlK3Jebk+XwF8/s8SgzMh0YWaBscpkrjFGYjH0
IcdnnYNmfm0H5v9M/cChec+C6dtUryTlN6Z7gMcI6g2GwlS9vZa1LxqltKKyoc+X
gWukvFHuPrM+sVoF83JjTFjIeDaviSnzeDg9VVz2Y08EId06seHHcvarYWvfbj46
KCFu44p3GID+VxyRMwC/BM2sq+MTBqD81ydrtfM8tnWf3WqUqOp0yL9WufKo/q7i
zWIQeNxOZvS9RxfPoymX0vUSSZhfLh+EuaxWfFQB+wcy8cIbfx/64iQYlEtYpC91
vm3B4MNjL4ytgnpDv5AI
=XkSJ
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
