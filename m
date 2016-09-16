Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35999 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbcIPXqB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 19:46:01 -0400
Received: by mail-oi0-f54.google.com with SMTP id t83so1185731oie.3
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 16:46:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160916232552.GA18014@coach.home>
References: <20160916192459.GA13514@coach.home> <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
 <20160916232552.GA18014@coach.home>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 16 Sep 2016 17:45:59 -0600
Message-ID: <CAJCQCtSW0zrWdYgWsWmokBDGBY8Lkd0E-cKKmBf7CfoZdR5aFA@mail.gmail.com>
Subject: Re: Post ext3 conversion problems
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 5:25 PM, Sean Greenslade
<sean@seangreenslade.com> wrote:

> In the mean time, is there any way to make the kernel more verbose about
> btrfs errors? It would be nice to see, for example, what was in the
> transaction that failed, or at least what files / metadata it was
> touching.

No idea. Maybe one of the compile time options:


CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
This also requires mount options, either check_int or check_int_data
CONFIG_BTRFS_FS_RUN_SANITY_TESTS
CONFIG_BTRFS_DEBUG=y
https://patchwork.kernel.org/patch/846462/
CONFIG_BTRFS_ASSERT=y

Actually, even before that maybe if you did a 'btrfs-debug-tree /dev/sdX'

That might explode in the vicinity of the problem. Thing is, btrfs
check doesn't see anything wrong with the metadata, so chances are
debug-tree won't either.

-- 
Chris Murphy
