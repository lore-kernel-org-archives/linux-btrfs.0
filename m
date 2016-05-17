Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36264 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcEQV1o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 17:27:44 -0400
Received: by mail-oi0-f68.google.com with SMTP id i2so5979510oib.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 14:27:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJVJNe4Ek8UR3Qq+p9fAu3bU-2dCdDcothgR=S6CsQKOo6zKFg@mail.gmail.com>
References: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
	<4218ab2f-def8-6541-427d-49091f70e342@gmail.com>
	<CAJCQCtRCFTEHoGxDMccJx7CLSPwLqSiqhd6--niCzrQ1FtJ+Bg@mail.gmail.com>
	<CAJVJNe4Ek8UR3Qq+p9fAu3bU-2dCdDcothgR=S6CsQKOo6zKFg@mail.gmail.com>
Date: Tue, 17 May 2016 15:27:43 -0600
Message-ID: <CAJCQCtTKDoZEKovqm4k=pPNDenDVAiFDGZDMvns4T9DD4tJsZw@mail.gmail.com>
Subject: Re: Corrupted system due to imbalanced metadata chunks
From: Chris Murphy <lists@colorremedies.com>
To: Goni Zahavy <goni1993@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Peter Kese <peter.kese@viidea.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 2:27 PM, Goni Zahavy <goni1993@gmail.com> wrote:
> Guys, just remember that this crappy-installer behavior works "as-expected"
> on every other filesystem.

It also fails as expected on every other file system if the upgrade is
interrupted for reasons that have nothing to do with the file system;
what's in common is the lack of a fail safe upgrade design. And this
is not a ding on Ubuntu, it's a widespread and well recognized risk.
All that's happening here is Btrfs has one more vector to expose that
deficiency.


> I think we need to treat this as a trigger to unwanted/unexpected behavior
> on btrfs's part, especially in this "dead-simple" setup, in order for us to
> gain a bug/behavior fix in the near future.

There are work arounds:

use -M when creating the file system, accepting some loss of
performance and inline small file packing efficiency;

run a preemptive filtered balance on a timer.

Fixing it in the kernel is a great idea, but if that were trivial I
think it'd have been done by now. It's not like this problem is
unknown on this list.

> In my opinion, we simply cannot "blame" the user/installer code in the
> current state of btrfs especially in the "considered stable enough" feature
> sets.


OK blame was the wrong word for me to use, but the root cause of the
problem is shared.

I agree the user is least to blame, but so long as the status of the
fs overall is benchmarking and review it's difficult to say the user
has no role whatsoever in helping prevent it, as tedious as that is.

-- 
Chris Murphy
