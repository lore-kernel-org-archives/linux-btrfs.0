Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11785 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751380AbaLaDQN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 22:16:13 -0500
Message-ID: <54A36A7C.1000005@ubuntu.com>
Date: Tue, 30 Dec 2014 22:16:12 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Uncorrectable errors on RAID-1?
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>	<20141223211605.GC436@hungrycats.org>	<CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>	<549F7539.4050801@ubuntu.com>	<CAJCQCtQOxfoeE9xRLpqohHK8WXW63x1gsOgJQEc8TtbRp67RoA@mail.gmail.com>	<54A30F19.5050801@ubuntu.com> <CAJCQCtSyu7dvp9SoF4u6QV9hF3jAQLtpYv8-6MOHSoP_NQyQ7A@mail.gmail.com>
In-Reply-To: <CAJCQCtSyu7dvp9SoF4u6QV9hF3jAQLtpYv8-6MOHSoP_NQyQ7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 12/30/2014 06:58 PM, Chris Murphy wrote:
>> Practically available right now?  Sure.  In theory, no.
> 
> I have no idea what this means. Such drives exist, you can buy them
> or not buy them.

I was referring to the "no way around this part".  Currently you are
correct, but in theory the way around it is exactly the subject of
this thread.

> Clearly you have never owned a business, nor have you been involved
> in volume manufacturing or you wouldn't be so keen to demand one
> market subsidize another. 24x7 usage is a non-trivial quantity of
> additional wear and tear on the drive compared to 8 hour/day, 40
> hour/week duty cycle. But you seem to think that the manufacturer
> has no right to produce a cheaper one for the seldom used hardware,
> or a more expensive one for the constantly used hardware.

Just because I want a raid doesn't mean I need it to operate reliably
24x7.  For that matter, it has long been established that power
cycling drives puts more wear and tear on them and as a general rule,
leaving them on 24x7 results in them lasting longer.

> And of course you completely ignored, and deleted, my point about
> the difference in warranties.

Because I don't care?  It's nice and all that they warranty the more
expensive drive more, and it may possibly even mean that they are
actually more reliable ( but not likely ), but that doesn't mean that
the system should have an unnecessarily terrible response to the
behavior of the cheaper drives.  Is it worth recommending the more
expensive drives?  Sure... but the system should also handle the
cheaper drives with grace.

> Does the SATA specification require configurable SCT ERC? Does it 
> require even supporting SCT ERC? I think your argument is flawed
> by mis-distributing the economic burden while simultaneously
> denying one even exists or that these companies should just eat the
> cost differential if it does. In any case the argument is asinine.

There didn't used to be any such thing; drives simply did not *ever*
go into absurdly long internal retries so there was no need.  The fact
that they do these days I consider a misfeature, and one that *can* be
worked around in software, which is the point here.

> When the encoded data signal weakens, they effectively becomes
> fuzzy bits. Each read produces different results. Obviously this is
> a very rare condition or there'd be widespread panic. However, it's
> common and expected enough that the drive manufacturers are all, to
> very little varying degree, dealing with this problem in a similar
> way, which is multiple reads.

Sure, but the noise introduced by the read ( as opposed to the noise
in the actual signal on the platter ) isn't that large, and so
retrying 10,000 times isn't going to give any better results than
retrying say, 100 times, and if the user really desires that many
retries, they have always been able to do so in the software level
rather than depending on the drive to try that much.  There is no
reason for the drives to have increased their internal retries that
much, and then deliberately withed the essentially zero cost ability
to limit those internal retries, other than to drive customers to pay
for the more expensive models.

> Now you could say they're all in collusion with each other to
> screw users over, rather than having legitimate reasons for all of
> these retried. Unless you're a hard drive engineer, I'm unlikely to
> find such an argument compelling. Besides, it would also be a
> charge of fraud.

Calling it fraud might be a bit of a stretch, but yes, there is no
legitimate reason for *that* many retries since people have been
retrying failed reads in software for decades and the diminishing
returns that goes with increasing the number of retries.

> In the meantime, there already is a working software alternative: 
> (re)write over all sectors periodically. Perhaps every 6-12 months
> is sufficient to mitigate such signal weakening on marginal sectors
> that aren't persistently failing on writes. This can be done with
> a periodic reshape if it's md raid. It can be done with balance on 
> Btrfs. It can be done with resilvering on ZFS.

Is there any actual evidence that this is effective?  Or that the
recording degrades as a function of time?  I doubt it since I do have
data on drives that were last written 10 years ago that is still
readable.  Even if so, this is really a non sequitur since if the
signal has degraded making it hard to read, in a raid we can simply
recover using the other drives.  The issue here is whether we should
be doing such recovery sooner rather than waiting for the silly drive
to retry 100,000 times before giving up.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUo2p7AAoJENRVrw2cjl5RBRQH/iPeByoKWCBCNcSH+slHQpLu
UgFw1Sb0VhkcMV7LWGHRPVCOqOqRUyiDUIWBqjnnKAtGWvngqoVa8oCrYXYfgzeT
snarm36vtm5jWQygn62mpZKoFVby5ttKTP3+rwQi+OjZ3+EWKKVkuXRFYpwt5ylt
f/Xix2EpgMrl9hi8Bt8D/aLPtyPIF47D5vwa2nw7f5/gU0rKDfG9OZ4B7Bs1Jl0Q
UA+bXlz4zi0cD6S7gwKStrDljAmMKjLnpWqMPHHnTWUgKuRRM/VKwzIhZmEZraqD
y3SdY1JBj1qli50ZvKH+lkEag0mixMLvzN4mC6gYKqXjG2EAsHMp8185kK97gSQ=
=agsX
-----END PGP SIGNATURE-----
