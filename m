Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:60453 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3JXKld (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 06:41:33 -0400
Message-ID: <5268F958.60004@parallels.com>
Date: Thu, 24 Oct 2013 14:41:28 +0400
From: Pavel Emelyanov <xemul@parallels.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>, <dsterba@suse.cz>
CC: Andrew Vagin <avagin@gmail.com>, Chris Mason <chris.mason@fusionio.com>,
        <linux-btrfs@vger.kernel.org>, <kzak@redhat.com>, <xemul@openvz.org>
Subject: Re: btrfs: stat(2) and /proc/pid/maps returns different devices
References: <20130704095138.GB12359@gmail.com> <20130708215446.GH18204@twin.jikos.cz> <20130710163105.GR32502@wotan.suse.de> <20130710174545.GS32502@wotan.suse.de> <20130710222650.GI25386@suse.cz> <20130719205115.GK32502@wotan.suse.de>
In-Reply-To: <20130719205115.GK32502@wotan.suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2013 12:51 AM, Mark Fasheh wrote:
> On Thu, Jul 11, 2013 at 12:26:50AM +0200, David Sterba wrote:
>> On Wed, Jul 10, 2013 at 10:45:45AM -0700, Mark Fasheh wrote:
>>> Well, what do I get when I pretend I don't care any more? The little voice
>>> in my head says "keep plugging away". Here's another attempt at fixing this
>>> problem in a sane manner. Basically, this time we're adding a flag to
>>> s_flags which btrfs sets. Proc will see the flag and call ->getattr().
>>>
>>> This compiles, but it needs testing (which I will get to soon). It still has
>>> a bunch of problems in my honest opinion but maybe if we get something
>>> acceptable upstream we can work from there.
>>>
>>> Also, as Andrew pointed out there's more than one place which is return
>>> different device than from stat(2) so I probably need to update more sites
>>> to deal with this.
>>>
>>> Does anyone see a problem with this approach?
>>
>> The approach looks ok to me, the implementation is internal to vfs and
>> fairly minimal. The bit that bothers me is the name of the flag, it's
>> completely unobvious what it means.
> 
> I'll come up with something better for my next revision :)

Mark, David,

What are your plans about the next version? Any chance we can see it in the
3.13 merge window? (unless I've missed the fact, that it's already there)

I'd really love to see it, as this thing is a blocker for checkpoint-restore
on btrfs.

Thanks,
Pavel
