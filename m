Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.alfazone.pl ([91.222.140.5]:34769 "EHLO mail.alfazone.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbcCSIWv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 04:22:51 -0400
Subject: Re: recovery problem raid5
To: Chris Murphy <lists@colorremedies.com>
References: <56EC3DCC.6060101@alfazone.pl>
 <20160318180207.GA1802@carfax.org.uk>
 <CAJCQCtQyyk3XnyCBW0vij1RSypYXF7yEAhBqaztzmXMvMU=0ng@mail.gmail.com>
 <CAJCQCtT_AHeRDV27eVm9VM8reT7HjvSorPJW6D5cv1Lh4cY5cg@mail.gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Marcin Solecki <solo@alfazone.pl>
Message-ID: <56ED0C26.5040809@alfazone.pl>
Date: Sat, 19 Mar 2016 09:21:58 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT_AHeRDV27eVm9VM8reT7HjvSorPJW6D5cv1Lh4cY5cg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



W dniu 2016-03-19 o 00:40, Chris Murphy pisze:
> On Fri, Mar 18, 2016 at 5:31 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Fri, Mar 18, 2016 at 12:02 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>     The main thing you haven't tried here is mount -o degraded, which
>>> is the thing to do if you have a missing device in your array.
>>>
>>>     Also, that kernel's not really all that good for a parity RAID
>>> array -- it's the very first one that had the scrub and replace
>>> implementation, so it's rather less stable with parity RAID than the
>>> later 4.x kernels. That's probably not the issue here, though.
>>
>> It's a 4.5.0 kernel with 3.19 progs. I'd update the progs even though
> And actually I'm wrong because it's possible progs 4.4.1 might help
> fix things. But really the problem is that -o degraded isn't work for
> the volume with a single missing device and I can't tell you why. It
> might be a bug, but it might be that progs 3.19 --repair wasn't a good
> idea to do on a volume with one missing device.
>
> I'm really skeptical of any sorts of repairs being allowed without a
> scary warning and requiring a force flag on volumes that are degraded.
> I know this is possible with ext4 and XFS, but that's only because
> they have no idea when the underlying raid is degraded.
>
>
I try on fedora 23, kernel line 4.x and btrfs progs 4.x ( don't remember 
), already I resigned to the loss of data but I want to try anything 
what you suggest

-- 
Pozdrawiam Marcin Solecki

