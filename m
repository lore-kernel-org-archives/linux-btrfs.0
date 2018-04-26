Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33841 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbeDZBN7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 21:13:59 -0400
Received: by mail-io0-f193.google.com with SMTP id p124-v6so3861652iod.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 18:13:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180425200109.GP21272@twin.jikos.cz>
References: <1524620434-108372-1-git-send-email-bo.liu@linux.alibaba.com> <20180425200109.GP21272@twin.jikos.cz>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Thu, 26 Apr 2018 09:13:58 +0800
Message-ID: <CANQeFDD6zueNVoevy4ufAUYsQ5qM_4CPOi1XVBgWA2v+iOZ8Lw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: set keep_lock when necessary in btrfs_defrag_leaves
To: David Sterba <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2018 at 4:01 AM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Apr 25, 2018 at 09:40:34AM +0800, Liu Bo wrote:
>> path->keep_lock is set but @path immediatley gets released, this sets
>> ->keep_lock only when it's necessary.
>
> Can you please write down more details for context? This mostly repeats
> what the code does, but not why. Thanks.

Urr, right, I missed the important piece.

->keep_lock may hold the locks of all nodes on the path instead of
only level=1 node and level=0 leaf.  As it's more likely that lock
content happens on tree root and higher nodes, we have to release as
less locks as possible.

Will update in v2.

thanks,
liubo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
