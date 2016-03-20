Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33355 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbcCTTPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 15:15:35 -0400
Received: by mail-io0-f174.google.com with SMTP id c63so10806371iof.0
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 12:15:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2124409.2eB4lQbKqm@merkaba>
References: <trinity-864ec27a-d0e1-4c15-a29b-6eb23d63f8f5-1458465506167@3capp-gmx-bs14>
	<2124409.2eB4lQbKqm@merkaba>
Date: Sun, 20 Mar 2016 13:15:34 -0600
Message-ID: <CAJCQCtT9Lo7Sp2A2Y64hYdTKAVPFQiOE2J7YXsczigEJGqNu6g@mail.gmail.com>
Subject: Re: unable to mount btrfs partition, please help :(
From: Chris Murphy <lists@colorremedies.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Patrick Tschackert <Killing-Time@gmx.de>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 20, 2016 at 6:19 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> On Sonntag, 20. März 2016 10:18:26 CET Patrick Tschackert wrote:
>> > I think in retrospect the safe way to do these kinds of Virtual Box
>> > updates, which require kernel module updates, would have been to
>> > shutdown the VM and stop the array. *shrug*
>>
>>
>> After this, I think I'll just do away with the virtual machine on this host,
>> as the app contained in that vm can also run on the host. I tried to be
>> fancy, and it seems to needlessly complicate things.
>
> I am not completely sure and I have no exact reference anymore, but I think I
> read more than once about fs benchmarks running faster in Virtualbox than on
> the physical system, which may point at an at least incomplete fsync()
> implementation for writing into Virtualbox image files.
>
> I never found any proof of this nor did I specificially seeked to research it.
> So it may be true or not.

Sure but that would only affect the guest's file system, the one
inside the VDI. It's the host managed filesystem that's busted.

-- 
Chris Murphy
