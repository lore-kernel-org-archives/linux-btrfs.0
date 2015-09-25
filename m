Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:45517 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbbIYM4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 08:56:04 -0400
Subject: Re: BTRFS as image store for KVM?
To: Rich Freeman <r-btrfs@thefreemanclan.net>
References: <55F88ECC.1040604@menke.ac> <55FE0B42.50300@jrs-s.net>
 <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
Cc: Gert Menke <gert@menke.ac>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jim Salter <jim@jrs-s.net>
Message-ID: <56054462.10103@jrs-s.net>
Date: Fri, 25 Sep 2015 08:56:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I suspect that the answer most likely boils down to "the ARC".

ZFS uses an Adaptive Replacement Cache instead of a standard FIFO, which 
keeps blocks in cache longer if they have been accessed in cache.  This 
means much higher cache hit rates, which also means minimizing the 
effects of fragmentation.

That's an off-the-top-of-my-head guess, though.  All I can tell you for 
certain is that I've done both - KVM stores on btrfs and on ZFS (and on 
LVM and on mdraid and...) - and it works extremely, extremely well on 
ZFS for long periods of time, where with btrfs it works very well at 
first but then degrades rapidly.

FWIW I've been using KVM + ZFS in wide production (>50 hosts) for 5+ 
years now.

On 09/25/2015 08:48 AM, Rich Freeman wrote:
> On Sat, Sep 19, 2015 at 9:26 PM, Jim Salter <jim@jrs-s.net> wrote:
>> ZFS, by contrast, works like absolute gangbusters for KVM image storage.
> I'd be interested in what allows ZFS to handle KVM image storage well,
> and whether this could be implemented in btrfs.  I'd think that the
> fragmentation issues would potentially apply to any COW filesystem,
> and if ZFS has a solution for this then it would probably benefit
> btrfs to implement the same solution, and not just for VM images.
>
> --
> Rich

