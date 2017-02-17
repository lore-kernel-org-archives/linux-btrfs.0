Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:50578 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754805AbdBQInm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 03:43:42 -0500
Date: Fri, 17 Feb 2017 13:43:37 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 4.10/4.11 Experiences
Message-ID: <20170217134337.6610299d@natsu>
In-Reply-To: <CAK5rZE4=34O2d+Tz8=r=_u2tMsipB3OKh3c3YWukX-YzL1JCaA@mail.gmail.com>
References: <CAK5rZE42HLb6kxGWmLqhwBb8arjZDc8yr6H6FLKkWu5XMQMW6Q@mail.gmail.com>
        <CAK5rZE4=34O2d+Tz8=r=_u2tMsipB3OKh3c3YWukX-YzL1JCaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 16 Feb 2017 13:37:53 +0200
Imran Geriskovan <imran.geriskovan@gmail.com> wrote:

> What are your experiences for btrfs regarding 4.10 and 4.11 kernels?
> I'm still on 4.8.x. I'd be happy to hear from anyone using 4.1x for
> a very typical single disk setup. Are they reasonably stable/good
> enough for this case?

You should always check with https://www.kernel.org/ what are the current
versions and what is their status. As you can see, 4.8 is basically dead in
the water, nowhere seen on the website, it does not get any updates anymore
by the kernel devs. If yours is a distro kernel, you now have to rely on
whatever fixes (and with what kind of quality) the distro maintainers are able
to backport.

Personally I took a liking to always running the latest longterm series, i.e.
right now staying on 4.4 and after a few initial hiccups it appears rock-solid
Btrfs-wise (as you said for single device, no multi-devices, no qgroup etc).

I'd suggest that you either upgrade to 4.9 (from the news it appears that one
will be granted the next longterm serues status), or switch to 4.4, which may
or may not be less preferable, given there are some scary sounding reports
about 4.9 (if you have this list's archive, search for "4.9" in thread
titles) with little to no conclusive resolutions.

-- 
With respect,
Roman
