Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33257 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965516AbdKPWcH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 17:32:07 -0500
Received: by mail-oi0-f67.google.com with SMTP id f135so435111oib.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 14:32:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com> <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com> <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com> <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 16 Nov 2017 15:32:05 -0700
Message-ID: <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 3:04 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> For example, if we use the following device mapper layout:
>
>         FS (can be any fs with metadata csum)
>                 |
>              dm-integrity
>                 |
>              dm-raid1
>                / \
>          disk1     disk2


You would instead do dm-integrity per physical device, then make the
two dm-integrity devices, members of md raid1 array. Now when
integrity fails, basically it's UNC error to raid1 which then gets the
copy from the other device.

But what you're getting at, that dm-integrity is more complicated, is
true, in that it's at least partly COW based in order to get the
atomic write guarantee needed to ensure data blocks and csums are
always in sync, and reliable. But this also applies to the entire file
system. The READ bio concept you're proposing leverages pretty much
already existing code, has no write performance penalty or complexity
at all, but does miss data for file systems that don't csum data
blocks. It's good the file system can stay alive, but data is the much
bigger target in terms of percent space on the physical media, and
more likely to be corrupt or go missing due to media defect or
whatever. It's still possible for silent data corruption to happen.




> I just want to make device-mapper raid able to handle such case too.
> Especially when most fs supports checksum for their metadata.

XFS by default does metadata csums. But ext4 doesn't use it for either
metadata or the journal by default still, it is still optional. So for
now it mainly benefits XFS.


-- 
Chris Murphy
