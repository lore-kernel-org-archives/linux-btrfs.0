Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:35767 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3BUR2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 12:28:08 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id 3128B93980
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 18:03:47 +0100 (CET)
Message-ID: <51265355.1020409@petaramesh.org>
Date: Thu, 21 Feb 2013 18:03:17 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Calvin Walton <calvin.walton@kepstin.ca>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Another defrag question
References: <51264146.3070504@petaramesh.org> <1361462073.18057.23.camel@cwalton-XPS-8300> <512644DA.3050409@petaramesh.org> <20130221163844.GD14283@carfax.org.uk>
In-Reply-To: <20130221163844.GD14283@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 21/02/2013 17:38, Hugo Mills a écrit :
> Plus, if something does go wrong with your FS, and you're running an
> older kernel, you'll get limited amounts of sympathy, because quite a
> lot of the problems people encounter with older kernels have already
> been fixed in newer ones.

The matter, as usual, is that what may be a "new" kernel from a user's
standpoint, may be an "old" kernel from a developer's standpoint.

Should this exclude all standard users from developer's "sympathy", or
reduce it to very limited amounts ?

Users are supposed to use released material, not bleeding-edge
compile-it-yourself devs toys...

> Finally, Ubuntu publish the latest kernels in a PPA[1], so there's not
> really much excuse for not keeping up with them. 

Yep. AFAIK the MAINLINE PPA is a Ubuntu-packaged STANDARD kernel without
any of the specific Ubuntu kernel patches.

That makes it very inappropriate for daily use, and the Ubuntu devs ask
for trying it ONLY when reporting kernel bugs, to check if said bug may
have been fixed upstream in latest kernel, or not.

Last time I tried this standard kernel, on one of my machines, it just
wouldn't boot ; on another one, it couldn't manage power (battery etc)
correctly, and on the machine on which I write this email, it couldn't
see my SD card reader anymore - for this one is managed by a driver
which still didn't make it into the standard kernel.

I use Ubuntu on several -dekstop- machines that benefit and need the
Ubuntu patches on their Ubuntus. I'm not (currently) running a headless
generic server for which my main and only concern would be BTRFS...

So I try to stick to the very old - albeit maximum 6 months old ! -
stock Ubuntu kernel...

Well... Sometimes I upgrade to next Beta :-]

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

