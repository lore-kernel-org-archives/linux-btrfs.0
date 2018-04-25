Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:41680 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754037AbeDYMap (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 08:30:45 -0400
Received: by mail-io0-f181.google.com with SMTP id e12-v6so3577399iob.8
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 05:30:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ca73e54-85d2-3ba7-48b1-8f9983daac06@gmail.com>
References: <CAJH6TXhQA-yx1kE2CJLboxMyay+54qb9DxiRZkNrGhsPP8LkXw@mail.gmail.com>
 <20180423151618.GY21272@twin.jikos.cz> <CAJH6TXiAUi2yWYKQ6gPbGkxG1aZ=DL+99H53VRM_LQsKF6Cm=g@mail.gmail.com>
 <4ca73e54-85d2-3ba7-48b1-8f9983daac06@gmail.com>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Wed, 25 Apr 2018 14:30:42 +0200
Message-ID: <CAJH6TXg3+j5g8Wk7jo5YM2dvTjvmp8Ddu2u0_v-u8r6agjRnLQ@mail.gmail.com>
Subject: Re: status page
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-04-25 13:39 GMT+02:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> Define 'stable'.

Something ready for production use like ext or xfs with no critical
bugs or with easy data loss.

> If you just want 'safe for critical data', it's mostly there already
> provided that your admins and operators are careful.  Assuming you avoid
> qgroups and parity raid, don't run the filesystem near full all the time,
> and keep an eye on the chunk allocations (which is easy to automate with
> newer kernels), you will generally be fine.  We've been using it in
> production where I work for a couple of years now, with the only issues
> we've encountered arising from the fact that we're stuck using an older
> kernel which doesn't automatically deallocate empty chunks.

For me, RAID56 is mandatory. Any ETA for a stable RAID56 ?
Is something we should expect this year, next year, next 10 years, .... ?
