Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34631 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbbL1A6h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 19:58:37 -0500
Received: by mail-io0-f174.google.com with SMTP id e126so293732882ioa.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 16:58:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451263174.6320.5.camel@scientia.net>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<1451263174.6320.5.camel@scientia.net>
Date: Sun, 27 Dec 2015 17:58:36 -0700
Message-ID: <CAJCQCtTmiKcapPpZ62Ko6mZK_MSDAFS2FAwU8CUJxkWwu-nYuw@mail.gmail.com>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 27, 2015 at 5:39 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Sun, 2015-12-27 at 11:29 -0700, Chris Murphy wrote:
>> then the scrub request is effectively a
>> scrub for a volume with a missing drive which you probably wouldn't
>> ever do, you'd first replace the missing device.
> While that's probably the normal work flow,... it should still work the
> other way round... and if not, I'd consider that a bug.

I think it's more complicated than that.

I don't see a good use case for scrubbing a degraded array. First make
the array healthy, then scrub. But I've not tested this with mdadm or
lvm raid. I don't know how they behave. But even if either of them
tolerate it, it's a legitimate design decision for Btrfs developers to
refuse supporting the scrub of a degraded array. Same for balancing
for that matter.

The problem here is, Btrfs itself may not even know the array state is
degraded. There's a degraded mount option, but since there's no device
faulty state yet, I don't see how it can know to go degraded, at which
point it could legitimately refuse to scrub.

Of course, the fs should get worse, there shouldn't be a crash, even
if degraded scrub isn't supported.



-- 
Chris Murphy
