Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:43528 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbeBOFyo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 00:54:44 -0500
Received: by mail-ot0-f176.google.com with SMTP id q12so22463789otg.10
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 21:54:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com> <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 14 Feb 2018 22:54:43 -0700
Message-ID: <CAJCQCtTk6tATnkE0iFqDSQy_R6oK-4L2Pmz+h3mk1G1FuVxLPg@mail.gmail.com>
Subject: Re: Status of FST and mount times
To: Nikolay Borisov <nborisov@suse.com>
Cc: "Ellis H. Wilson III" <ellisw@panasas.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 14, 2018 at 10:08 AM, Nikolay Borisov <nborisov@suse.com> wrote:

> V1 for large filesystems is jut awful. Facebook have been experiencing
> the pain hence they implemented v2. You can view the spacecache tree as
> the complement version of the extent tree. v1 cache is implemented as a
> hidden inode and even though writes (aka flushing of the freespace
> cache) are metadata they are essentially treated as data. This could
> potentially lead to priority inversions if cgroups io controller is
> involved.
>
> Furthermore, there is at least 1 known deadlock problem in freespace
> cache v1. So yes, if you want to use btrfs ona multi-tb system v2 is
> really the way to go.

I've been using v2 on a couple of systems' rootfs for a couple of
months. I'm not totally certain it's v2, or another enhancement circa
4.14, but system updates (rpm based) are definitely faster. So it may
not only be a Nice To Have with big file systems. I haven't tried it
yet but if the file system face plants on me, I figure I'll use btrfs
check to wipe the free space cache (hopefully that's allowed even if
the file system is hosed) and then try to repair.


-- 
Chris Murphy
