Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36541 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750754AbcLCUPW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 15:15:22 -0500
Received: by mail-yw0-f194.google.com with SMTP id r204so23907956ywb.3
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Dec 2016 12:14:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFuzrVfF61EYSuxfb-68EsnN3evJaMWrABtGj-79OCmb8-ncnA@mail.gmail.com>
References: <CAFuzrVeWdz2Lup-x1OiJjVcknQRysiiZVYG1doxNdGKiHB+Jaw@mail.gmail.com>
 <4533be53-6c95-11a4-e101-6df9ca88410f@bouton.name> <CAFuzrVfF61EYSuxfb-68EsnN3evJaMWrABtGj-79OCmb8-ncnA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 3 Dec 2016 13:14:28 -0700
Message-ID: <CAJCQCtTq7-q=yBg_JK=9AcQfr6zB17cHY8NcHV6-zz23eACbmA@mail.gmail.com>
Subject: Re: missing checksums on reboot
To: Blake Lewis <blake@portworx.com>
Cc: Lionel Bouton <lionel-subscription@bouton.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 2, 2016 at 1:36 PM, Blake Lewis <blake@portworx.com> wrote:
> Well, 3.10 is what you get with the RHEL7.x distributions, so that's
> why people are running it.
> Apparently, it is "good enough" for many purposes.

Nope. Btrfs in RHEL 7 is a technology preview, and ...

"Technology Preview features are currently unsupported, may not be
functionally complete, and are not suitable for deployment in
production. "


> My real goal here is to understand the scope of the bug and whether
> any mitigation is
> possible.  Of course, I don't expect anyone else to make a patch for
> me (or even to accept
> my patch), but if I knew what the bug is and what was done to fix it,
> I'd be in a much better
> position to decide what to do.  If anyone can shed any light on this,
> I'd be very grateful.

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/diff/?id=v4.8.12&id2=v3.19&dt=2

There's more than 10000 lines changed between 3.19 and 4.8.12. You're
in the right place, but it's a shot in the dark if any developer
remembers the particular problem you're having compared to the massive
pile of bugs fixed and changes made since then. The RHEL 3.10 kernel
as I understand it has v3.19 Btrfs code. You might test with a 4.1.36
kernel to see if your problem reproduces. There was some O_DIRECTbug
fixes a while back but I have no idea what kernel versions those were.

If the fix is relatively recent, it simply may not have been
backported very far because kernels go EOL and backporting just
doesn't happen, not that it can't be done. So you might search the
list for O_DIRECT, and see if anything looks familiar. If that doesn't
pan out you can start doing simple bisects with longterm kernel.org
kernels, starting with the oldest (which is where I got 4.1.36) and
see if you can find a commit that fixes the problem, and then if it
applies cleanly to the much older kernel you're using.



-- 
Chris Murphy
