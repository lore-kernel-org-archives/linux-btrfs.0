Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:53188 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753093AbbAEETL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Jan 2015 23:19:11 -0500
Message-ID: <54AA10B3.3010900@ubuntu.com>
Date: Sun, 04 Jan 2015 23:18:59 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Uncorrectable errors on RAID-1?
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>	<20141223211605.GC436@hungrycats.org>	<CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>	<549F7539.4050801@ubuntu.com>	<CAJCQCtQOxfoeE9xRLpqohHK8WXW63x1gsOgJQEc8TtbRp67RoA@mail.gmail.com>	<54A30F19.5050801@ubuntu.com>	<CAJCQCtSyu7dvp9SoF4u6QV9hF3jAQLtpYv8-6MOHSoP_NQyQ7A@mail.gmail.com>	<54A36A7C.1000005@ubuntu.com> <CAJCQCtR5qZmD2RgfQMSUe9BLtUtimTyf-itBM1Y+9hiRftfwgg@mail.gmail.com>
In-Reply-To: <CAJCQCtR5qZmD2RgfQMSUe9BLtUtimTyf-itBM1Y+9hiRftfwgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/03/2015 12:31 AM, Chris Murphy wrote:
> It's not a made to order hard drive industry. Maybe one day you'll
> be able to 3D print your own with its own specs.

And wookies did not live on endor.  What's your point?

> Sticking fingers in your ears doesn't change the fact there's a 
> measurable difference in support requirements.

Sure, just don't misrepresent one requirement for another.  Just
because I don't care about a warranty from the hardware manufacturer
does not mean I have no right to expect the kernel to perform
*reasonably* on that hardware.

> This is architecture astronaut territory.
> 
> The system only has a terrible response for two reasons: 1. The
> user spec'd the wrong hardware for the use case; 2. The distro
> isn't automatically leveraging existing ways to mitigate that user
> mistake by changing either SCT ERC on the drives, or the SCSI
> command timer for each block device.

No, it has terrible response because the kernel either waits an
unreasonable time or fails the drive and kicks it out of the array
instead of trying to repair it.  Blaming the user for not buying
better hardware is not an appropriate response for the kernel failing
so badly to handle commonly available hardware that doesn't behave in
the most ideal way.

> Now, even though that solution *might* mean long recoveries on 
> occasion, it's still better than link reset behavior which is what
> we have today because it causes the underlying problem to be fixed
> by md/dm/Btrfs once the read error is reported. But no distro has 
> implemented this $500 man hour solution. Instead you're suggesting
> a $500,000 fix that will take hundreds of man hours and end user
> testing to find all the edge cases. It's like, seriously, WTF?

Seriously?  Treating a timeout the same way you treat an unrecoverable
media error is no herculean task.

> Ok well I think that's hubris unless you're a hard drive engineer. 
> You're referring to how drives behaved over a decade ago, when bad 
> sectors were persistent rather than remapped, and we had to scan
> the drive at format time to build a map so the bad ones wouldn't be
> used by the filesystem.

Remapping has nothing to do with it: we are talking about *read*
errors, which do not trigger a remap.

> http://www.seagate.com/files/www-content/support-content/documentation/product-manuals/en-us/Enterprise/Savvio/Savvio%2015K.3/100629381e.pdf
>
>  That's a high end SAS drive. It's default is to retry up to 20
> times, which takes ~1.4 seconds, per sector. But also note how it
> says

20 retries on a 15,000 rpm drive only takes 80 milliseconds, not 1.4
seconds.  15,000 rpm / 60 seconds per minute = 250 rotations/retries
per second.

> Maybe you'd prefer seeing these big, cheap, "green" drives have 
> shorter ERC times, with a commensurate reality check with their 
> unrecoverable error rate, which right now is already two orders 
> magnitude higher than enterprise SAS drives. So what if this means 
> that rate is 3 or 4 orders magnitude higher?

20 retries vs. 200 retries does not reduce the URE rate by orders of
magnitude; more like 1% *maybe*.  200 vs 2000 makes no measurable
difference at all.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUqhCxAAoJENRVrw2cjl5RhDYH/RLbHXEPyjK4j6u33ElOyS5S
W5/nfiT1ZZjVAFxJwD0y/gt2L61hB1PQdlUjBm2NayExfCXn3sEuccAxvjMDrvsL
dFJOV8G/7GBbUfsD0uBustG5639QGc30bRzuiw/URT77zNf+T6+5SmTPSC3Oaj3j
fCcDdiKCwNcYiUF3/Q3gdh4XVI8wgoABHC2S/GqvRB+FmmqD6Yt6yG50TG5sPBzq
zSUSxWjOPwVinZOlPfCUCFr3buw+yzg5fclcvaNRStJM38gtK0UGgeIHFgCViHtN
0xNRCKWMu3XkfjfOI/cYVor79K4sQlz9K83Ja/UAMrOtopdlKjn9N04oIiPdsbg=
=u/i9
-----END PGP SIGNATURE-----
