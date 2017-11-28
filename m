Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:40550 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753222AbdK1XmE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 18:42:04 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:41842)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eJpVq-0005z2-Pn
        for linux-btrfs@vger.kernel.org; Tue, 28 Nov 2017 23:42:02 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eJpVi-0007NZ-IV
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 23:41:54 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23069.62530.53658.314350@tree.ty.sabi.co.uk>
Date: Tue, 28 Nov 2017 23:41:54 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] retry write on error
In-Reply-To: <bd35756b-0089-0e20-a70c-b66dd3292208@suse.de>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
        <20171128192236.GE3553@twin.jikos.cz>
        <bd35756b-0089-0e20-a70c-b66dd3292208@suse.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> If the underlying protocal doesn't support retry and there
>>> are some transient errors happening somewhere in our IO
>>> stack, we'd like to give an extra chance for IO.

>> A limited number of retries may make sense, though I saw some
>> long stalls after retries on bad disks.

Indeed! One of the major issues in actual storage administration
is to find ways to reliably disable most retries, or to shorten
them, both at the block device level and the device level,
because in almost all cases where storage reliability matters
what is important is simply swapping out the failing device
immediately and then examining and possible refreshing it
offline.

To the point that many device manufacturers deliberately cripple
in cheaper products retry shortening or disabling options to
force long stalls, so that people who care about reliability
more than price will buy the more expensive version that can
disable or shorten retries.

> Seems preferable to avoid issuing retries when the underlying
> transport layer(s) has already done so, but I am not sure
> there is a way to know that at the fs level.

Inded, and to use an euphemism, a third layer of retries at the
filesystem level are currently a thoroughly imbecilic idea :-),
as whether retries are worth doing is not a filesystem dependent
issue (but then plugging is done at the block io level when it
is entirely device dependent whether it is worth doing, so there
is famous precedent).

There are excellent reasons why error recovery is in general not
done at the filesystem level since around 20 years ago, which do
not need repeating every time. However one of them is that where
it makes sense device firmware does retries, and the block
device layer does retries too, which is often a bad idea, and
where it is not, the block io level should be do that, not the
filesystem.

A large part of the above discussion would not be needed if
Linux kernel "developers" exposed a clear notion of hardware
device and block device state machine and related semantics, or
even knew that it were desirable, but that's an idea that is
only 50 years old, so may not have yet reached popularity :-).
