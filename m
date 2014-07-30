Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:45380 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaG3XaR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 19:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
Date: Thu, 31 Jul 2014 09:30:15 +1000
Message-ID: <CAPM=9ty2PhMdLykVX4c074Tdkyh0OO_jtfw-CAFHk8ANcZA4kQ@mail.gmail.com>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
From: Dave Airlie <airlied@gmail.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> This patch removes the lines for releasing the page cache in certain
> files as this may aid in perfomance with writes in the compression
> rountines of btrfs. Please note that this patch has not been tested
> on my own hardware due to no compression based btrfs volumes of my
> own.
>

For all that is sacred, STOP.

Go and do something else, you are wasting people's valuable time,

Don't send any patches you haven't tested ever. If you aren't capable
of setting up a VM to run compressed btrfs volumes in, what makes you
think you can patch the code.

This isn't how you learn to be a kernel developer by wasting other
kernel developers time, if you can't work out why releasing the page cache
is necessary then don't send the patch until you have spent the time
understanding what the page cache is.

I know you'll just ignore this, and keep on trucking just like you ignored
the other messages from Stephen before.

But if you want to work on the kernel, this isn't the way to do it, and
nobody will ever take a patch from you seriously if you continue in this
fashion.

Dave.
