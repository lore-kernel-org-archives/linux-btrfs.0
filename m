Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:56368 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162723AbdD2Kqx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 06:46:53 -0400
Received: from 82-132-217-35.dab.02.net ([82.132.217.35]:50836 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1d4Ptr-001Zli-3p
        for linux-btrfs@vger.kernel.org; Sat, 29 Apr 2017 11:46:51 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1d4Pdv-0002Ss-7D
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Apr 2017 11:30:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22788.27454.815373.552901@tree.ty.sabi.co.uk>
Date: Sat, 29 Apr 2017 11:30:22 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
In-Reply-To: <22787.51857.303844.66350@tree.ty.sabi.co.uk>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
        <22787.33181.491103.496790@tree.ty.sabi.co.uk>
        <CAJCQCtRt4kr6We5wB7eLbN-9mdXyfy7QMwAqs15J5biyyc+KYg@mail.gmail.com>
        <22787.51857.303844.66350@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> [ ... ] these extents are all over the place, they're not
>> contiguous at all. 4K here, 4K there, 4K over there, back to
>> 4K here next to this one, 4K over there...12K over there, 500K
>> unwritten, 4K over there. This seems not so consequential on
>> SSD, [ ... ]

> Indeed there were recent reports that the 'ssd' mount option
> causes that, IIRC by Hans van Kranenburg [ ... ]

The report included news that "sometimes" the 'ssd' option is
automatically switched on at mount even on hard disks. I had
promised to put a summary of the issue on the Btrfs wiki, but
I regret that I haven't yet done that.
