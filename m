Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:34909 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751841AbdDCMcc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 08:32:32 -0400
Received: by mail-it0-f49.google.com with SMTP id y18so45239790itc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Apr 2017 05:32:31 -0700 (PDT)
Subject: Re: Is btrfs-convert able to deal with sparse files in a ext4
 filesystem?
To: Kai Herlemann <btrfs@linux.kai-herlemann.de>, linux-btrfs@vger.kernel.org
References: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <145e6e59-42d6-ca9b-1bfa-5f0249e930be@gmail.com>
Date: Mon, 3 Apr 2017 08:32:25 -0400
MIME-Version: 1.0
In-Reply-To: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-01 05:48, Kai Herlemann wrote:
> Hi,
> I have on my ext4 filesystem some sparse files, mostly images from
> ext4 filesystems.
> Is btrfs-convert (4.9.1) able to deal with sparse files or can that
> cause any problems?
I would tend to agree with some of the other people who have commented 
here, but with a slight twist:
If you just want to test BTRFS short-term, then in-place conversion is 
fine.  The moment you decide to keep using BTRFS for production systems, 
you should be creating new filesystems instead of doing in-place conversion.

There are a couple of reasons for this:
1. In-place conversion will give you an inherently sub-optimal on-disk 
data layout.  You'll need some extra work to remedy this, and because of 
that extra work, it will generally not be any quicker to convert 
in-place than to create a new filesystem.  You can of course choose not 
to fix this, but performance will likely suffer. (This can also be 
slightly mitigated by making sure to defragment the filesystem before 
conversion).
2. Slightly related to 1, btrfs-convert can leave behind artifacts from 
the conversion itself that may cause issues later.
3. Tying in with both 1 and 2, there's very little testing done on 
converted filesystems.  You are therefore by definition more likely to 
run into bugs or other issues.
4. In-place conversion is inherently risky.  If something goes wrong, 
you're going to have to restore from a backup anyway.

