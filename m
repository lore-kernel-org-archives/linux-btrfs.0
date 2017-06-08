Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:45212 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdFHTTH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jun 2017 15:19:07 -0400
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
To: Roman Mamedov <rm@romanrm.net>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
 <d5ebd421-52a1-5b91-72a3-f97a2fb9628f@mendix.com>
 <3e8876c3-b8b9-0922-8962-17f6cf38b81d@knorrie.org>
 <20170608234737.2a1c8db0@natsu>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <721d581b-2560-301a-ea71-8588a07a100b@mendix.com>
Date: Thu, 8 Jun 2017 21:19:05 +0200
MIME-Version: 1.0
In-Reply-To: <20170608234737.2a1c8db0@natsu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/08/2017 08:47 PM, Roman Mamedov wrote:
> On Thu, 8 Jun 2017 19:57:10 +0200
> Hans van Kranenburg <hans.van.kranenburg@mendix.com> wrote:
> 
>> There is an improvement with subvolume delete + nossd that is visible
>> between 4.7 and 4.9.
> 
> I don't remember if I asked before, but did you test on 4.4?

No, I jumped from 3.16 lts (debian) to 4.7.8 to 4.9.25 now. I haven't
been building my own (yet), it's all debian kernels.

The biggest improvement I needed was the free space tree (>=4.5),
because with 3.16 transaction commit disk write IO was going through the
roof, blocking the fs for too long every few seconds. 4.7.8 was about
the first kernel that I tested which I couldn't too easily get to
explode and corrupt file systems. The 3.16 lts was (is) a really stable
kernel for btrfs.

> The two latest
> longterm series are 4.9 and 4.4. 4.7 should be abandoned and forgotten by now
> really, certainly not used daily in production,

I know, I know. They're already gone now. :)

> it's not even listed on
> kernel.org anymore. Also it's possible the 4.7 branch that you test did not
> receive all the bugfix backports from mainline like the longterm series do.

Well, I wouldn't say "all" the bugfixes, looking at the history of
fs/btrfs in current 4.9. It's more like.. sporadically, someone might
take time to also think about the longterm kernel. ;-)

>> I have no idea what change between 4.7 and 4.9 is responsible for this, but
>> it's good.  
> 
> FWIW, this appears to be the big Btrfs change between 4.7 and 4.9 (in 4.8):
> 
> Btrfs: introduce ticketed enospc infrastructure
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=957780eb2788d8c218d539e19a85653f51a96dc1

Since that part of the problem is gone now, I don't think it makes sense
any more to spend time to find where it improved...

-- 
Hans van Kranenburg
