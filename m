Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51953 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760444Ab3B1PQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 10:16:49 -0500
Message-ID: <512F74DC.8050404@petaramesh.org>
Date: Thu, 28 Feb 2013 16:16:44 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
CC: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Does defragmenting even work
References: <512F6B30.1060409@petaramesh.org> <20130228150044.GN14283@carfax.org.uk>
In-Reply-To: <20130228150044.GN14283@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Hugo, ans thanks Calvin for your clear explanations.

I actually use compression on all of my FSes, and I have seen that
"filefrag -v" reports different "physical" and "expected" values for
many files, meaning of which I didn't understand at all.

This said, I now assume that my current script approach "check with
filefrag it the file presents any (apparent) fragmentation, if yes run
defrag on it" may be good enough, or would it be more efficient to
directly run defrag on all files without bothering checking it they
(may) be fragmented or not (which boils down to : "which of filefrag or
btrfs defrag runs faster ?") ?

Also, does "btrfs filesystem defrag" does anything smart for
defragmenting free space, or does it only care about defragmenting the
file it was asked to process ?

Anyway I hope to recover "brand new-like" performance after having
removed all snapshots and defragged everything...

Remains the issue of the open files, I'm not sure if it's worth trying
to defragment them with the system running from a live USB stick or so...?

Kind regards.

Le 28/02/2013 16:00, Hugo Mills a écrit :
> If you have a compressed file, each compression block (128k of
> compressed data, if I remember rightly) will show up as a separate
> fragment, even if it's contiguous with the others -- it's an artefact
> of the way that fiemap/filefrag calculates fragments, and the way that
> btrfs reports compressed files. Also, on a full filesystem, complete
> defragmentation may not be completely possible. Similarly, very large
> files may not be easy or possible to defragment fully -- a 2GB file
> with four fragments isn't exactly a problem, for example. Hugo. 


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

