Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33903 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbcCWGRz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 02:17:55 -0400
Received: by mail-io0-f180.google.com with SMTP id m184so19517784iof.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 23:17:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F22F80.501@gmail.com>
References: <56F1E7BE.1000004@gmail.com>
	<56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
Date: Wed, 23 Mar 2016 00:17:53 -0600
Message-ID: <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
From: Chris Murphy <lists@colorremedies.com>
To: bradtem@gmail.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 11:54 PM, Brad Templeton <bradtem@gmail.com> wrote:
> Actually, the URL suggests that all the space will be used, which is
> what I had read about btrfs, that it handled this.

It will. But it does this by dominating writes to the devices that
have the most free space, until all devices have the same free space.


> But again, how could it possibly know to restrict the new device to only
> using 2TB?

In your case, before resizing it, it's just inheriting the size from
the device being replaced.

>
> Stage one:  Add the new 6TB device.  The 2TB device is still present.
>
> Stage two:  Remove the 2TB device.

OK this is confusing. In your first post you said replaced. That
suggests you used 'btrfs replace start' rather than 'btrfs device add'
followed by 'btrfs device remove'. So which did you do?

If you did the latter, then there's no resize necessary.


> The system copies everything on it
> to the device which has the most space, the empty 6TB device.  But you
> are saying it decides to _shrink_ the 6TB device now that we know it is
> a 2TB device being removed?

No I'm not. The source of confusion appears to be that you're
unfamiliar with 'btrfs replace' so you mean 'dev add' followed by 'dev
remove' to mean replaced.

This line:
        devid    3 size 5.43TiB used 1.42TiB path /dev/sdg2

suggests it's using the entire 6TB of the newly added drive, it's
already at max size.


> We didn't know the 2TB would be removed
> when we added the 6TB, so I just can't fathom why the code would do
> that.  In addition, the stats I get back say it didn't do that.

I don't understand the first part. Whether you asked for 'dev remove'
or you used 'replace' both of those mean removing some device. You
have to specify the device to be removed.

Now might be a good time to actually write out the exact commands you've used.


>
> More to the point, after the resize, the balance is still not changing
> any size numbers.  It should be moving blocks to the most empty device,
> should it not?    There is almost no space on devids 1 and 2, so it
> would not copy any chunks there.
>
> I'm starting to think this is a bug, but I'll keep plugging.

Could be a bug. Three drive raid1 of different sizes is somewhat
uncommon so it's possible it's hit an edge case somehow. Qu will know
more about how to find out why it's not allocating mostly to the
larger drive. The eventual work around might end up being to convert
data chunks to single, then convert back to raid1. But before doing
that it'd be better to find out why it's not doing the right thing the
normal way.


-- 
Chris Murphy
