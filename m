Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35259 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbcKAPUx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 11:20:53 -0400
Received: by mail-oi0-f41.google.com with SMTP id i127so299351867oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Nov 2016 08:20:53 -0700 (PDT)
Date: Tue, 1 Nov 2016 08:20:50 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Tobias Holst <tobby@tobby.eu>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: cannot mount read-write because of unsupported optional features
 (2)
Message-ID: <20161101152050.GA1707@vader>
References: <CAGwxe4jsSHNP5qXy=wL6MuYNzKTQF70MpD-0aYhHaUzVR4SuLg@mail.gmail.com>
 <51d348af-54f1-0f11-6478-6561693477e6@cn.fujitsu.com>
 <CAGwxe4hVacU31ZNQnw9tCPM8WZDdShmTSJwHi=fBA7hr3exQHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGwxe4hVacU31ZNQnw9tCPM8WZDdShmTSJwHi=fBA7hr3exQHw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2016 at 04:03:38PM +0100, Tobias Holst wrote:
> Ah thanks! Looks like I missed this bug on the list...
> 
> But as I understand it, it should be mountable with btrfs-progs
> >=4.7.3 or when mounting it with "-o clear_cache,nospace_cache". But
> both doesn't work. Is it only mountable with kernel >=4.9 anymore?
> That would be interesting since I never ran a kernel newer than 4.8...
> 
> Regards,
> Tobias

Hi, Tobias,

The fix was backported to v4.7 and v4.8 stable, so it's not just v4.9.
The btrfs-progs version doesn't matter for mounting. If you use a stable
kernel newer than v4.7.10 or v4.8.4, you will be able to mount it. If
you really need to use it with an older kernel, you can clear the free
space tree with -o clear_cache,nospace_cache from the newer kernel.

Sorry for the trouble, we really had to add this incompatability bit
even for x86 because of a btrfs-progs bug that could potentially corrupt
the free space tree.
-- 
Omar
