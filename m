Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43444 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930AbaAISk4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 13:40:56 -0500
Received: by mail-pb0-f54.google.com with SMTP id un15so3390578pbc.27
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 10:40:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140109174335.GL15634@carfax.org.uk>
References: <20140109170945.GK15634@carfax.org.uk>
	<CAPpBBdNKSUHCtM3fk7=ujJFZSL8LMf_iQXdZ-O-bXcTRN69c3g@mail.gmail.com>
	<20140109174335.GL15634@carfax.org.uk>
Date: Thu, 9 Jan 2014 19:40:55 +0100
Message-ID: <CAPpBBdMbrEMjHaacu-ZYzEdJ5zTaGLu=70C+N71aFbZmoB5rkg@mail.gmail.com>
Subject: Re: How does btrfs handle bad blocks in raid1?
From: George Eleftheriou <eleftg@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Hugo,

Since:

-- i keep daily backups
-- all 4 devices are of the same size

I think I can test it (as soon as I have some time to spend in the
transition to BTRFS) and verify your assumptions (...and get my wish)



>    If you have an even number of devices and all the devices are the
> same size, then:
>
>  * the block group allocator will use all the devices each time
>  * the amount of space on each device will always be the same
>
> If the sort in the allocator is stable and resolves ties in free space
> by using the device ID number, the above properties should guarantee
> that the allocation is stable, so each new block group will have the
> same functional chunk on the same device, and you get your wish.
>
>    It's been a few months since I looked at that code, but I don't
> recall seeing anything directly contradictory to the above
> assumptions.
>
>    Of course, if you have an odd number of devices, the allocator will
> omit a different device on each block group, and you lose the ability
> to survive (some) two-device failures. I suspect that the odds of
> surviving a two-device failure are still non-zero, but less than if
> you had an even number of devices. I'm not about to attempt an
> ab-initio computation of the probabilities, but it shouldn't be too
> hard to do either a monte-carlo simulation or a simple brute-force
> enumeration of the possibilities for a given configuration.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>    --- <Diablo-D3> My code is never released,  it escapes from the ---
>           git repo and kills a few beta testers on the way out
