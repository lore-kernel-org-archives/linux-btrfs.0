Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rx0ar-terminal-systems-international.ed.BIGPIPEINC.COM ([208.118.95.38]:58278
	"EHLO mail.terminalsystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932293AbaLJTxS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 14:53:18 -0500
Message-ID: <5488A495.9070404@terminalsystems.com>
Date: Wed, 10 Dec 2014 13:52:53 -0600
From: James West <james@terminalsystems.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Possibility to have a "transient" snapshot?
References: <5481F91B.6090700@terminalsystems.com> <CAJCQCtTy9SRj1pX4wdQ83hDKf3JU4RfJ9wWTU=+JYbsYd-xiRw@mail.gmail.com>
In-Reply-To: <CAJCQCtTy9SRj1pX4wdQ83hDKf3JU4RfJ9wWTU=+JYbsYd-xiRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was just looking into using overlayfs, and although it has some 
promise, I think it's biggest drawback is the upperdir will have to be 
some sort of storage backed filesystem. From my limited understanding of 
tmpfs, it's not supposed to be the greatest with many large files (and 
my system in particular would be downloading many large movies/videos, 
and doing any kind of os update to test it would involve many changes 
all over the volume, which could be problematic to commit to a golden 
state.)

I could partition the main drive in 2 parts, and dynamically zero-out 
then create the volume in the second partition on each boot, but I'm 
still saving no drive writes, and not really extending the life of the 
hardware (which is one of my premises.)

On 05/12/2014 11:12 PM, Chris Murphy wrote:
> On Fri, Dec 5, 2014 at 11:27 AM, James West <james@terminalsystems.com> wrote:
>
>> General idea would be to have a transient snapshot (optional quota support
>> possibility here) on top of a base snapshot (possibly readonly). On system
>> start/restart (whether clean or dirty), the transient snapshot would be
>> flushed, and the system would restart the snapshot, basically restarting
>> from the base snapshot.
> Sounds similar to this idea:
> http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
>
> About 1/3 of the way down it gets to a proposal to Btrfs as a way to
> get to a stateless system, which is basically what you want to be able
> to rollback to. A variation on this that might serve the use case
> better is seed device. You can either drop the added device that
> stores changes to the seed device, or the volume (seed+added device)
> can become another seed if you want to make the current state
> persistent at next boot.
>
> And still another possibility is overlayfs, which isn't Btrfs specific.
>
>
>

