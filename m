Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35097 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcCKXmd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 18:42:33 -0500
Received: by mail-wm0-f48.google.com with SMTP id l68so38293391wml.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 15:42:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtShrmtnO-d3u+jnFOWqct5QQ0oKErJpDeC+0pw-XiECBA@mail.gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<CAJCQCtShrmtnO-d3u+jnFOWqct5QQ0oKErJpDeC+0pw-XiECBA@mail.gmail.com>
Date: Fri, 11 Mar 2016 18:42:31 -0500
Message-ID: <CAD=QJKjohwOz=yRJzFy2T6XN+OODdbMW9ggj6Qg0qDYoVVpj_A@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 March 2016 at 16:26, Chris Murphy <lists@colorremedies.com> wrote:
>
> It's normal and recognized to be sub-optimal. So it's an optimization
> opportunity. :-)
>
> I see parallelization of reads and writes to data single profile
> multiple devices as useful also, similar to XFS allocation group
> parallelization. Those AGs are spread across multiple devices in
> md/lvm linear layouts, so if you have processes that read/write to
> multiple AGs at a time, those I/Os happen at the same time when on
> separate devices.

I'm not sure if I can pull it off... :-)  At best I might only be able
to define the problem and how things fit together, and then attempt to
logic my way through it with pseudo-code.  My hope is that someone
would look at this work, say "Aha!  You're doing it wrong!" and then
implement it the right way.

On 10 March 2016 at 03:10, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Call me a conspiracy nut, but don't be too surprised if someone's
> introducing some product with btrfs and encrypted subvolumes a year or 18
> months from now...  I know I won't be! =:^)

In that case, couldn't an "at a glance" overview of what needs to be
done for distributed read optimisation entice a product-manager
somewhere out there to throw some employee-time at the problem? :-p

Best regards,
Nicholas
