Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:62152 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaLTIio (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 03:38:44 -0500
Received: by mail-yh0-f42.google.com with SMTP id v1so1070977yhn.1
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 00:38:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
Date: Sat, 20 Dec 2014 01:38:43 -0700
Message-ID: <CAJCQCtQV3tQZ0WpTt0k3geKUfDJ23EDskyxDCTqkx0FFrSWCsA@mail.gmail.com>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 19, 2014 at 7:07 PM, Richard Sharpe
<realrichardsharpe@gmail.com> wrote:
> Hi folks,
>
> I need a Linux file system that supports XATTRs up to 64K.
>
> Can BTRFS support that or is XFS the only Linux file system with such support?

I'm feeling too lazy to actually go look for evidence of this; but I
made a file system a while ago with 64KB node/leafsize and ran into a
bug I reported for send/receive. I'm pretty sure this was related to
xattr being limited to nodesize, and I'm also pretty sure it got
fixed. But I'm not sure whether the problem was on the send or receive
side, and I'm not sure when.



-- 
Chris Murphy
