Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:54558 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751633AbdJMQj2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 12:39:28 -0400
Received: from 82-132-216-97.dab.02.net ([82.132.216.97]:39214 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e32ze-0001m4-32
        for linux-btrfs@vger.kernel.org; Fri, 13 Oct 2017 17:39:26 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e32zM-0008Oa-9q
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 17:39:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23008.60459.486788.624046@tree.ty.sabi.co.uk>
Date: Fri, 13 Oct 2017 17:39:07 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs errors over NFS
In-Reply-To: <113b8299-1377-5a35-a727-ec21e67518f7@shaw.ca>
References: <87o9pcmfad.fsf@shaw.ca>
        <113b8299-1377-5a35-a727-ec21e67518f7@shaw.ca>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> TL;DR: ran into some btrfs errors and weird behaviour, but
>> things generally seem to work. Just posting some details in
>> case it helps devs or other users. [ ... ] I've run into a
>> btrfs error trying to do a -j8 build of android on a btrfs
>> filesystem exported over NFSv3. [ ... ]

I have an NFS server from Btrfs filesystem, and it is mostly
read-only and low-use, unlike a massive build, but so far it has
worked for me. The issue that was reported a while ago was that
the kernel NFS server does not report as errors to clients
checksum validation failures, just prints a warning, so for that
reason and a few others I switch to the Ganesha NFS server.

>From your stack traces I noticed that some go pretty deep so
maybe there is an issue with that (but on 'amd64' the kernel
stack is much bigger than it used to be on 'i386'). Another
possibility is that the volume got somewhat damaged for other
reasons (bugs, media errors, ...) and this is have further
consequences.

BTW 'errno 17' is "File exists", so perhaps there is a race
condition over NFS. The bogus files with mode 0 seem to me to be
bogus directory entries with no files linked to them, which
could be again the result of race conditions. The problems with
chunks allocation reported as "WARNING" are unfamiliar to me.
