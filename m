Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58424 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaHFAiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 20:38:20 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so2361404pab.30
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 17:38:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5484676.xyTNESz9qN@xev>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<1875052.8GFlAMfPzL@quad>
	<pan$dbb9d$e1133995$a123d619$8316b9ab@cox.net>
	<5484676.xyTNESz9qN@xev>
Date: Tue, 5 Aug 2014 17:38:20 -0700
Message-ID: <CAN05THQQLTUMctn0ejwhjpW4kfViqNnSoRyzHUUV7iDBx4aLZg@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: russell@coker.com.au
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 5, 2014 at 5:20 AM, Russell Coker <russell@coker.com.au> wrote:

>
> Based on what I've read on this list it seems that BTRFS is less stable in
> 3.15 than in 3.14.  Even 3.14 isn't something I'd recommend to random people
> who want something to just work.
>
> The Debian installer has BTRFS in a list of filesystems to choose with no
> special notice about it.  I'm thinking of filing a Debian bug requesting that
> they put a warning against it.
>
> What do people here think?

+1 for a warning.

btrfs is still a young filesystem and not as stable as say ext4.
I think it would be very prudent to have a small warning.
