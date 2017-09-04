Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:60538 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbdIDIqM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 04:46:12 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:61766)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1don1G-0007f3-Ja
        for linux-btrfs@vger.kernel.org; Mon, 04 Sep 2017 09:46:10 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1don1A-0005Nu-Sp
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 09:46:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22957.4812.405800.654436@tree.ty.sabi.co.uk>
Date: Mon, 4 Sep 2017 09:46:04 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: read-only for no good reason on 4.9.30
In-Reply-To: <1841512.lHhB7WV3Ld@russell.coker.com.au>
References: <1841512.lHhB7WV3Ld@russell.coker.com.au>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] I ran "btrfs balance" and then it started working
> correctly again. It seems that a btrfs filesystem if left
> alone will eventually get fragmented enough that it rejects
> writes [ ... ]

Free space will get fragmented, because Btrfs has a 2-level
allocator scheme (chunks within devices and leaves within
chunks). The issue is "free space" vs. "unallocated chunks".

> Is this a known issue?

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space
https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28.3E16GiB.29
https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_new_tools
https://btrfs.wiki.kernel.org/index.php/FAQ#Why_is_free_space_so_complicated.3F
https://btrfs.wiki.kernel.org/index.php/FAQ#What_does_.22balance.22_do.3F

That problem is particularly frequent with the 'ssd' mount
option which probably should never be used:

https://btrfs.wiki.kernel.org/index.php/Gotchas#The_ssd_mount_option
