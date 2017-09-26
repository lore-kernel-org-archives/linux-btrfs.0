Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:48252 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964856AbdIZUjw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 16:39:52 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:60064)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dwwdw-0004qh-Vn
        for linux-btrfs@vger.kernel.org; Tue, 26 Sep 2017 21:39:49 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dwwY4-0001hY-5m
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 21:33:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-ID: <22986.47527.263713.439274@tree.ty.sabi.co.uk>
Date: Tue, 26 Sep 2017 21:33:43 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs performance with small blocksize on SSD
In-Reply-To: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
References: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> i run a few performance tests comparing mdadm, hardware raid
> and the btrfs raid.

Fantastic beginning already! :-)

> I noticed that the performance

I have seen over the years a lot of messages like this where
there is a wanton display of amusing misuses of terminology, of
which the misuse of the word "performance" to mean "speed" is
common, and your results are work-per-time which is a "speed":
http://www.sabi.co.uk/blog/15-two.html?151023#151023

The "tl;dr" is: you and another guy are told to race the 100m to
win a ¤10,000 prize, but you have to carry a sack with a 50Kg
weight. It takes you a lot longer, as your speed is much lower,
and the other guy gets the prize. Was that because your
performance was much worse? :-)

> for small blocksizes (2k) is very bad on SSD in general and on
> HDD for sequential writing.

Your graphs show pretty decent performance for small-file IO on
Btrfs, depending on conditions, and you are very astutely not
explaining the conditions, even if some can be guessed.

> I wonder about that result, because you say on the wiki that
> btrfs is very effective for small files.

Effectivess/efficiency are not the same as performance or speed
either. My own simplistic but somewhat meaningful tests show
that Btrfs does relatively well on small files:

  http://www.sabi.co.uk/blog/17-one.html?170302#170302

As to "small files" in general I have read about many attempts
to use filesystems as DBMSes, and I consider them intensely
stupid:

  http://www.sabi.co.uk/blog/anno05-4th.html?051016#051016

> I attached my results from raid 1 random write HDD (rH1), SSD
> (rS1) and from sequential write HDD (sH1), SSD (sS1)

Ah, so it was specifically about small *writes* (and presumably
because of other wording not small-updates-in-place of large
files, but creating and writing small files).

It is a very basic beginner level notion that most storage
systems are very anisotropic as to IO size, and also for read
vs. write, and never mind with and without 'fsync'. SSDs without
supercapacitor backed buffers in particular are an issue.

Btrfs has a performance envelope where the speed of small writes
(in particular small in-place updates, but also because of POSIX
small file creation) has been sacrificed for good reasons:

https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Copy_on_Write_.28CoW.29
https://btrfs.wiki.kernel.org/index.php/Gotchas#Fragmentation

Also consider the consequences of the 'max_inline' option for
'mount' and the 'nodesize' option for 'mkfs.btrfs'.

> Hopefully you have an explanation for that.

The best explanation seems to me (euphemism alert) quite
extensive "misknowledge" in the message I am responding to.
