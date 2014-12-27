Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57136 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaL0Sk1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 13:40:27 -0500
Date: Sat, 27 Dec 2014 18:40:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Robert White <rwhite@pobox.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Message-ID: <20141227184017.GL25267@carfax.org.uk>
References: <3738341.y7uRQFcLJH@merkaba>
 <549DE5C6.2000606@pobox.com>
 <4232026.31LFOYpm2s@merkaba>
 <20141227093043.GJ25267@carfax.org.uk>
 <20141227182846.GA11878@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tv2SIFopg1r47n4a"
In-Reply-To: <20141227182846.GA11878@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tv2SIFopg1r47n4a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 27, 2014 at 01:28:46PM -0500, Zygo Blaxell wrote:
> On Sat, Dec 27, 2014 at 09:30:43AM +0000, Hugo Mills wrote:
> > On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrote:
> > > Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
> > > > On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> >    Now, since you're seeing lockups when the space on your disks is
> > all allocated I'd say that's a bug. However, you're the *only* person
> > who's reported this as a regular occurrence. Does this happen with all
> > filesystems you have, or just this one?
> 
> I do see something similar, but there are so many problems going on I
> have no idea which ones to report, and which ones are my own doing.  :-P
> 
> I see lots of CPU being burned when all the disk space is allocated
> to chunks, but there is still lots of space free (multiple GB) inside
> the chunks.
> 
> iotop shows a crapton of disk writes (1-5MB/sec) from one kworker.
> There are maybe a few kB/sec of writes through the filesystem at the time.
> 
> The filesystem where I see this most is on a laptop, so the disk writes
> also hit the CPU again for encryption.  There's so much CPU usage it's
> worth mentioning twice.  :-(
> 
> 'watch cat /proc/12345/stack' on the active processes shows the kernel
> fairly often in that new chunk deallocator function whose name escapes
> me at the moment.
> 
> Deleting a bunch of data then running balance helps return to sane CPU
> usage...for a while (maybe a week?).
> 
> It's not technically "locked up" per se, but when a 5KB download takes
> a minute or more, most users won't wait around to see the difference.
> 
> Kernel versions I'm using are 3.17.7 and 3.18.1.

   OK, so I'd like to change my statement above.

   When I first read Martin's problem, I thought that he was referring
to a complete, hit-the-power-button kind of lock-up. Given that
(erroneous) assumption, I stand by my (now pointless) statement. :)

   I realised during a brief conversation on IRC that Martin was
actually referring to long but temporary periods where the machine is
unusable by any process requiring disk activity. There's clearly a
number of people seeing that.

   It doesn't stop it being a major problem, but it does change the
interpretation considerably.

   Hugo.

-- 
Hugo Mills             | Mixing mathematics and alcohol is dangerous. Don't
hugo@... carfax.org.uk | drink and derive.
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--tv2SIFopg1r47n4a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUnv0RAAoJEFheFHXiqx3kDVAQAId0ORftwohgRcoQZMiq2/li
vHBGWffCkTOA2hidyuV8BKZ7/jXG2jtsHUNzwbiFNDHs/cdKTYHaowNv5Zb372cN
GfMH/n3TrgmU7LhRes3iHcykweoFCWMUZ+E258NJqxqq4D9NXIts31GzFfmU2/+3
Ctf4YpMiKiY9FhOvvweQ0Qf/oWGekPbZ9NQTHtctx3Jv6wSE8Lw5fRhUqGUM7F2w
aUah1AcieQbOdFyzh1NTjf1X87ePzmDHCvIt5+/XVaOTfq6umWxpegkfJgqHyVOa
WBvT9dezJpm6JQmNjDbfITHp8jXvmiBDYwJ3FCcn8z81nMFUA65B4AB/g0LXKcY8
eTP67Np0XtP8BlKg1bpmIEJm/JOkTDM7MFJrbZWOcsxnujGr2Unma6R+5ZUP6/H7
SFGH5r4UC/EE9b78OLtafCVMC1UgxPrfg9N/PxzcyEST7upkeXUQh1VLnJ0YMMU7
c2wADEoOauwILZda9ET6BGJYsoT2k+Lb4j26Tkkh7e4T8bAVMu5mUYR/KAF0/ENM
v6TcctOsxvUCkVKmd8fO5MZYEQYr8JuCHCjxqOxO1PRlbVg4HeWO9k4GnMkg539Y
XZfTkmD0Gh5WXh3E+2vYJINezTSNKJnNlPkMyRMhExw3yyMP1z5Vwx8CIte87Q5A
T69OVd6DCe0F0glKMWiF
=Z6pv
-----END PGP SIGNATURE-----

--tv2SIFopg1r47n4a--
