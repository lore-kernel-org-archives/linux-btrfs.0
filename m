Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:62012 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932754AbcHYWkw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 18:40:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 26 Aug 2016 00:33:05 +0200
From: Gert Menke <gert@menke.ac>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Switch raid mode without rebalance?
In-Reply-To: <CAJCQCtRuQvgTj-jj=k8Ehsnq0uEkbbzJJwRR6T16H+R4d6SeTw@mail.gmail.com>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
 <CAJCQCtRuQvgTj-jj=k8Ehsnq0uEkbbzJJwRR6T16H+R4d6SeTw@mail.gmail.com>
Message-ID: <392b5e39596611f0ec15501dbf300c0e@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2016-08-25 21:50, Chris Murphy wrote:
> It's incidental right now. It's not something controllable or intended
> to have enduring mixed profile block groups.
I see. (Kindof)

> Such a switch doesn't exist, there's no way to define what files,
> directories, or subvolumes, have what profiles.
Well it kind of does - a running balance process seems to have just that 
effect, it's just not persistent (and has the side effect of, well, 
balancing the existing data).

>> How does btrfs
>> find out which raid mode to use when writing new data?
> 
> That's kindof an interesting question. If you were to do 'btrfs
> balance start -dconvert=single -mconvert=raid1' and very soon after
> that do 'btrfs balance cancel' you'll end up with one or a few new
> chunks with those profiles. When data is allocated to those chunks,
> they will have those profile characteristics. When data is allocated
> to old chunks that are still raid0, it will be raid0. The thing is,
> you can't really tell or control what data will be placed in what
> chunk. So it's plausible that some new data goes in old raid0 chunk,
> and some old data goes in new single/raid1 chunks.

I'm not quite familiar with the concept of a chunk here.
Are chunks allocated for new data, or is the unallocated space divided 
into chunks, too?
In the former case, when creating a new chunk, does btrfs just look into 
a random already existing chunk and copy the raid mode from there?
In the latter case, could you (in theory) change the raid mode of all 
empty chunks only?

I know this is not an intended usage scenario; just being curious here.

Thanks!
Gert
