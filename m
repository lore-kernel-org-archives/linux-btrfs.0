Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47942 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaEXQo6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 12:44:58 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so2279069wiv.13
        for <linux-btrfs@vger.kernel.org>; Sat, 24 May 2014 09:44:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 24 May 2014 18:44:56 +0200
Message-ID: <CANg_oxybdjtOXrqo=yLPEKEz=NrJtSRfGgMxDeCQP+0EAbV_Qw@mail.gmail.com>
Subject: is it safe to change BTRFS_STRIPE_LEN?
From: john terragon <jterragon@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I'm playing around with (software) raid0 on SSDs and since I remember
I read somewhere that intel recommends 128K stripe size for HDD arrays
but only 16K stripe size for SSD arrays, I wanted to see how a
small(er) stripe size would work on my system. Obviously with btrfs on
top of md-raid I could use the stripe size I want. But if I'm not
mistaken the stripe size with the native raid0 in btrfs is fixed to
64K in BTRFS_STRIPE_LEN (volumes.h).
So I was wondering if it would be reasonably safe to just change that
to 16K (and duck and wait for the explosion ;) ).

Can anyone adept to the inner workings of btrfs raid0 code confirm if
that would be the right way to proceed? (obviously without absolutely
any blame to be placed on anyone other than myself if things should go
badly :) )

Thanks

john
