Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:52375 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3HAMOt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 08:14:49 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so1939091pde.38
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2013 05:14:48 -0700 (PDT)
Message-ID: <51FA512F.5040507@gmail.com>
Date: Thu, 01 Aug 2013 13:14:39 +0100
From: Andrew Stubbs <andrew.stubbs@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: How to merge two partitions?
References: <51FA3E2E.30405@gmail.com> <20130801110849.GZ20517@carfax.org.uk>
In-Reply-To: <20130801110849.GZ20517@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/08/13 12:08, Hugo Mills wrote:
>> I thought of using "btrfs device add" and just living with the
>> untidy underlying devices, but an experiment with loopback
>> filesystems shows that any data on the new device is silently
>> obliterated (it might be nice if the docs mentioned this!)
>
>     You would expect data in a different filesystem format to be
> integrated into an existing set of data structures? That would be...
> magic. :)

No, this was merging two btrfs filesystem of the same format. I hoped 
that, somehow, it would just add it into the tree, perhaps as another 
subvolume. Maybe even it might not show up in the overall volume, but 
could still be mounted from the partition volume. It's all about trees, 
right?!

Anyway, what's confused me is that one of the tutorials I found says 
that you should run mkfs on the new device before adding it, but 
experimentation shows that's just not necessary. The bogus instructions 
led me to believe that the contents of the new device was significant, 
somehow.

It would be nice if "man btrfs" had a big warning that the added device 
will get wiped, effectively.

>> Is there a cunning btrfs trick to do this? Can a btrfs filesystem be
>> extended "backwards", if you see what I mean?
>
>     No, using gparted to move it backwards into the free space is your
> best option here.

OK, thanks.

Andrew
