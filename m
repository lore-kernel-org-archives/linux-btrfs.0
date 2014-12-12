Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:34829 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967821AbaLLOJv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 09:09:51 -0500
Received: by mail-yh0-f43.google.com with SMTP id z6so3278374yhz.16
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 06:09:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548AEDD6.1090904@pobox.com>
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>
	<548A13F7.30904@pobox.com>
	<CAA7pwKNKeuysdoS83m=z-Cn5ecWtGrQAfjNKwXjryRceHUV=3Q@mail.gmail.com>
	<548AEDD6.1090904@pobox.com>
Date: Fri, 12 Dec 2014 15:09:50 +0100
Message-ID: <CAA7pwKMkHnejeBO2YUKMTtWLpaTcmSQQR+U61S3uuibAzVx-1g@mail.gmail.com>
Subject: Re: A note on spotting "bugs" [Was: ENOSPC after conversion]
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12 December 2014 at 14:29, Robert White <rwhite@pobox.com> wrote:
>
> You yourself even found the annotation in the wiki that said you should have
> e4defragged the system before conversion.

There's no mention of e4defrag on the Btrfs wiki, it says to btrfs
defrag before balance to avoid ENOSPC, as the last step of conversion.


> What you are experiencing is a little vexing, but it's not a bug. It's not
> even a "huge problem". And if you'd stop banging your head against it it
> wouldn't be any sort of problem at all. Neither of us can change these
> facts.

I stopped banging my head several emails ago. I understand the problem
and I will start over.


> I feel your pain man, but thats about it.

I'm in no pain, it has been interesting. No data loss. No hurry.


> What more can I do?

The conversion wiki is lacking. It would be great if someone (maybe
you?) could expand upon the drawbacks of conversion.


> What is it that you want?

Nothing more.
