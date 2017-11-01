Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:52258 "EHLO
        smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751721AbdKAIeJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 04:34:09 -0400
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru>
 <CAH=dxU7APYANHn3PjqepY9dr9F3RRhzE1OSgtar9tN-74haS9g@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <ca0bc340-25eb-bf80-82a1-fbb0e7ca1a44@rqc.ru>
Date: Wed, 1 Nov 2017 11:34:08 +0300
MIME-Version: 1.0
In-Reply-To: <CAH=dxU7APYANHn3PjqepY9dr9F3RRhzE1OSgtar9tN-74haS9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/11/17 09:51, Dave wrote:
>> As already said by Romain Mamedov, rsync is viable alternative to
>> send-receive with much less hassle. According to some reports it can even be
>> faster.
> Thanks for confirming. I must have missed those reports. I had never
> considered this idea until now -- but I like it.
>
> Are there any blogs or wikis where people have done something similar
> to what we are discussing here?
I don't know any. Probably someone needs to write it.

>>> We will delete most snapshots on the live volume, but retain many (or
>>> all) snapshots on the backup block device. Is that a good strategy,
>>> given my goals?
>> Depending on the way you use it, retaining even a dozen snapshots on a live
>> volume might hurt performance (for high-performance databases) or be
>> completely transparent (for user folders). You may want to experiment with
>> this number.
> We do experience severe performance problems now, especially with
> Firefox. Part of my experiment is to reduce the number of snapshots on
> the live volumes, hence this question.
Just for statistics, how many snapshots do you have and how often do you 
take them? It's on SSD, right?

> Thanks. I hope you do find time to publish it. (And what do you mean
> by portable?) For now, Snapper has a cleanup algorithm that we can
> use. At least one of the tools listed here has a thinout algorithm
> too: https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
It is currently a small part of yet another home-grown backup tool which 
is itself fairly big and tuned to particular environment. I thought many 
times that it would be very nice to have thinning tool separately and 
with no unnecessary dependencies, but...

BTW beware of deleting too many snapshots at once with any tool. Delete 
few and let filesystem stabilize before proceeding.

>>> Should I consider a dedup tool like one of these?
>> Certainly NOT for snapshot-based backups: it is already deduplicated almost
>> as much as possible, dedup tools can only make it *less* deduplicated.
> The question is whether to use a dedup tool on the live volume which
> has a few snapshots. Even with the new strategy (based on rsync), the
> live volume may sometimes have two snapshots (pre- and post- pacman
> upgrades).
For deduplication tool to be useful you ought to have some duplicate 
data on your live volume. Do you have any (e.g. many LXC containers with 
the same distribution)?

> Also still wondering about these options: no-holes, skinny metadata,
> or extended inode refs?
I don't know anything about any of these, sorry.

P.S. I still think you need some off-system backup solution too, either 
rsync+snapshot-based over ssh or e.g. Burp (shameless advertising: 
http://burp.grke.org/ ).

--

With Best Regards,
Marat Khalili
