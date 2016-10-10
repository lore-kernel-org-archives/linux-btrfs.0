Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33760 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbcJJVFt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 17:05:49 -0400
Received: by mail-oi0-f46.google.com with SMTP id y2so2100122oie.0
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 14:05:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161010234227.69746d3f@natsu>
References: <CAG6KGPS8Gvy2zGCe22mMmk4uXrqVyRP8FHayhe0ph-8vC+kA4A@mail.gmail.com>
 <CAG6KGPSeR1zAuU0Xo9DrEpd-0QC9agB7p7z+Lb69hxS233_Cvg@mail.gmail.com> <20161010234227.69746d3f@natsu>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 10 Oct 2016 15:05:12 -0600
Message-ID: <CAJCQCtQh2C95=ug3x7wT98CA-fRAVXxd5Ghz4suYkENFCf8jQg@mail.gmail.com>
Subject: Re: csum failed during copy/compare
To: Roman Mamedov <rm@romanrm.net>
Cc: Martin Dev <mrturtledev@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2016 at 12:42 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Mon, 10 Oct 2016 10:44:39 +0100
> Martin Dev <mrturtledev@gmail.com> wrote:
>
>> I work for system verification of SSDs and we've recently come up
>> against an issue with BTRFS on Ubuntu 16.04
>
>> This seems to be a recent change
>
> ...well, a change in what?
>
> If you really didn't change anything on your machines and the used process,
> there is no reason for anything to start breaking, other than obvious hardware
> issues from age/etc (likely not what's happening here).
>
> So you most likely did change something yourself, and perhaps the change was
> upgrading OS version, kernel version(!!!), or versions of software in general.
>
> As such, the first suggestion would be go through the recent software updates
> history, maybe even restore an OS image you used three months ago (if
> available) and confirm that the problem doesn't occur there. After that it's a
> process called bisecting, there are tools for that, but likely you don't even
> need those yet, just carefully note when you got which upgrades, paying
> highest attention to the kernel version, and note at which point the
> corruptions start to occur.


There  have been various trim bugs, in Btrfs but also in the block
layer. And I don't remember all the different versions involved.  I'd
like to think 4.4.24 should behave the same as 4.8.1, so I would
retest with those two, using something without ubuntu specific
backports (i.e. something as close to the kernel.org trees of those
versions as possible). I have no idea what Ubuntu generic 4.4.0-21
translates into. Because of the 0, it makes me think it's literally
4.4.0 with 21 sets of various backports, from some unknown time frame
without going and looking it up. If that's really 4.4.21, then it's
weirdly named, I don't know why any distro would do that.

In any case I would compare 4.8.1 and 4.4.24 because those two should
work and if not it's a bug that needs to get fixed. Independently,
check the SSD firmware. There have been bugs there also.

-- 
Chris Murphy
