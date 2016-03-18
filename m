Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35856 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbcCRXkP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 19:40:15 -0400
Received: by mail-ig0-f177.google.com with SMTP id nk17so33836150igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 16:40:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQyyk3XnyCBW0vij1RSypYXF7yEAhBqaztzmXMvMU=0ng@mail.gmail.com>
References: <56EC3DCC.6060101@alfazone.pl>
	<20160318180207.GA1802@carfax.org.uk>
	<CAJCQCtQyyk3XnyCBW0vij1RSypYXF7yEAhBqaztzmXMvMU=0ng@mail.gmail.com>
Date: Fri, 18 Mar 2016 17:40:14 -0600
Message-ID: <CAJCQCtT_AHeRDV27eVm9VM8reT7HjvSorPJW6D5cv1Lh4cY5cg@mail.gmail.com>
Subject: Re: recovery problem raid5
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Marcin Solecki <solo@alfazone.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2016 at 5:31 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Fri, Mar 18, 2016 at 12:02 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>    The main thing you haven't tried here is mount -o degraded, which
>> is the thing to do if you have a missing device in your array.
>>
>>    Also, that kernel's not really all that good for a parity RAID
>> array -- it's the very first one that had the scrub and replace
>> implementation, so it's rather less stable with parity RAID than the
>> later 4.x kernels. That's probably not the issue here, though.
>
>
> It's a 4.5.0 kernel with 3.19 progs. I'd update the progs even though

And actually I'm wrong because it's possible progs 4.4.1 might help
fix things. But really the problem is that -o degraded isn't work for
the volume with a single missing device and I can't tell you why. It
might be a bug, but it might be that progs 3.19 --repair wasn't a good
idea to do on a volume with one missing device.

I'm really skeptical of any sorts of repairs being allowed without a
scary warning and requiring a force flag on volumes that are degraded.
I know this is possible with ext4 and XFS, but that's only because
they have no idea when the underlying raid is degraded.


-- 
Chris Murphy
