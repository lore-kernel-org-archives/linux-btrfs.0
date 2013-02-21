Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42769 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3BURrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 12:47:32 -0500
Message-ID: <51265DB0.2060407@petaramesh.org>
Date: Thu, 21 Feb 2013 18:47:28 +0100
From: =?windows-1252?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Another defrag question
References: <51264146.3070504@petaramesh.org> <1361462073.18057.23.camel@cwalton-XPS-8300> <512644DA.3050409@petaramesh.org> <20130221163844.GD14283@carfax.org.uk> <51265355.1020409@petaramesh.org> <20130221172502.GF14283@carfax.org.uk>
In-Reply-To: <20130221172502.GF14283@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 21/02/2013 18:25, Hugo Mills a écrit :
> Correct. But btrfs isn't at that stage yet. It's getting visibly
> closer, but it's not quite there. Hence the very strong recommendation
> to keep up with the latest code. Hugo. 

The matter is that BTRFS had many early adopters just because it is -
and has been for long now - in the mainline Linux kernel, so supposed
stable and good choice for the future.

To be honest (and not wanting to troll, promised) this is the only
single reason for which I use BTRFS on 5 of my 6 machines at home - just
because I thought that "Just upgrade the distro every 6 months and it
will become better and better over time, no hassle, make my life easy".

OTOH my 6th machine runs native ZFS on Linux, and I have to tell that it
shows orders of magnitude better performance and never gave me a single
problem in several (3 ?) years. Only upgrading the distro is always a
big frightening and problematic. And initial installation was a bit tricky.

Probably a lot of BTRS early adopters choosed it for the same reason why
I did : Included in the standard kernel, easy to install, and *expected*
to improve quickly - yes, I already made the move back and forth twice,
between ext4 and BTRFS, on 2 machines... About one year ago I choosed to
jump "for good" and stay, but performance degrades so quickly and so
much that every couple of days I wonder if I won't rollback to ex4 again
(and again), or shift to ZFS once for all and just forget about it...

Everytime I show my Linux machines to friends and say : “Hey, I got the
most advanced filesystem on earth !” I soon get the answer “Oh boy,
that's the slowest machine boot and FS I've ever seen since I was
reading floppy disks on my 386SX in 1991 ! Can you really live with this ?”

So, for "not quite there" and the return codes "+20" that have been a
minor pain in the arse for a couple years but the line is still in the
code... I can understand developer's PoV, been there, done that, but
still, BTRFS might in the end lose a numer of its early adopters if it
keeps being "not quite there" too long.

Shitfing to ZFS is just a PPA and 2 apt-get install commands away... It
will definitely be easier than start playing with mainline PPA Ubuntu
kernels...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

