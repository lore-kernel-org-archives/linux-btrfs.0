Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:36529 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbHNTtT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 15:49:19 -0400
Received: by vkbf67 with SMTP id f67so33542887vkb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 12:49:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8i119-igp=cE_djV2RvOX4unpg1pcDkaeDh-AY=gn3qA@mail.gmail.com>
References: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
	<CAJCQCtQBey_UvXLDBrDkKxbEmWLZw6N1NbGVJV3XCjwF+exBLg@mail.gmail.com>
	<CAK7bmU8i119-igp=cE_djV2RvOX4unpg1pcDkaeDh-AY=gn3qA@mail.gmail.com>
Date: Fri, 14 Aug 2015 13:49:18 -0600
Message-ID: <CAJCQCtS46Li6E41Rf2CHumq3P5FWZ4w=5hCDStxM6DMOEOiy_g@mail.gmail.com>
Subject: Re: Can't mount degraded. How to remove/add drives OFFLINE?
From: Chris Murphy <lists@colorremedies.com>
To: Timothy Normand Miller <theosib@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 1:03 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> I'm not sure my situation is quite like the one you linked, so here's
> my bug report:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=102881

I can easily reproduce with just 2 device RAID. I updated the bug.
It's best these are separate bugs, but I think the underlying problems
are related.

The work around is to mount -o ro,degraded, and then move data to a
new Btrfs volume with btrfs send/receive or conventional copy for data
that's not already in a read-only snapshot.


-- 
Chris Murphy
