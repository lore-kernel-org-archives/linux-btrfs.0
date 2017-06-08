Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:46076 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750788AbdFHSrk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Jun 2017 14:47:40 -0400
Date: Thu, 8 Jun 2017 23:47:37 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About free space fragmentation, metadata write amplification
 and (no)ssd
Message-ID: <20170608234737.2a1c8db0@natsu>
In-Reply-To: <3e8876c3-b8b9-0922-8962-17f6cf38b81d@knorrie.org>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
        <d5ebd421-52a1-5b91-72a3-f97a2fb9628f@mendix.com>
        <3e8876c3-b8b9-0922-8962-17f6cf38b81d@knorrie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 8 Jun 2017 19:57:10 +0200
Hans van Kranenburg <hans.van.kranenburg@mendix.com> wrote:

> There is an improvement with subvolume delete + nossd that is visible
> between 4.7 and 4.9.

I don't remember if I asked before, but did you test on 4.4? The two latest
longterm series are 4.9 and 4.4. 4.7 should be abandoned and forgotten by now
really, certainly not used daily in production, it's not even listed on
kernel.org anymore. Also it's possible the 4.7 branch that you test did not
receive all the bugfix backports from mainline like the longterm series do.

> I have no idea what change between 4.7 and 4.9 is responsible for this, but
> it's good.  

FWIW, this appears to be the big Btrfs change between 4.7 and 4.9 (in 4.8):

Btrfs: introduce ticketed enospc infrastructure
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=957780eb2788d8c218d539e19a85653f51a96dc1

-- 
With respect,
Roman
