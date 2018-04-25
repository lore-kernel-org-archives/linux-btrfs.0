Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:46634 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbeDYLkA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 07:40:00 -0400
Received: by mail-io0-f172.google.com with SMTP id f3-v6so26396043iob.13
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 04:40:00 -0700 (PDT)
Subject: Re: status page
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXhQA-yx1kE2CJLboxMyay+54qb9DxiRZkNrGhsPP8LkXw@mail.gmail.com>
 <20180423151618.GY21272@twin.jikos.cz>
 <CAJH6TXiAUi2yWYKQ6gPbGkxG1aZ=DL+99H53VRM_LQsKF6Cm=g@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4ca73e54-85d2-3ba7-48b1-8f9983daac06@gmail.com>
Date: Wed, 25 Apr 2018 07:39:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAJH6TXiAUi2yWYKQ6gPbGkxG1aZ=DL+99H53VRM_LQsKF6Cm=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-25 07:13, Gandalf Corvotempesta wrote:
> 2018-04-23 17:16 GMT+02:00 David Sterba <dsterba@suse.cz>:
>> Reviewed and updated for 4.16, there's no change regarding the overall
>> status, though 4.16 has some raid56 fixes.
> 
> Thank you!
> Any ETA for a stable RAID56 ? (or, even better, for a stable btrfs
> ready for production use)
> 
> I've seen many improvements in these months and a stable btrfs seems
> to be not that far.

Define 'stable'.

If you want 'bug free', that won't happen ever.  Even 'stable' 
filesystems like XFS and ext4 still have bugs found and fixed on a 
somewhat regular basis.  The only filesystem drivers that don't have 
bugs reported are either so trivial that there really are no bugs (see 
for example minix and vfat) or aren't under active development (and 
therefore all the bugs have been fixed already).

If you just want 'safe for critical data', it's mostly there already 
provided that your admins and operators are careful.  Assuming you avoid 
qgroups and parity raid, don't run the filesystem near full all the 
time, and keep an eye on the chunk allocations (which is easy to 
automate with newer kernels), you will generally be fine.  We've been 
using it in production where I work for a couple of years now, with the 
only issues we've encountered arising from the fact that we're stuck 
using an older kernel which doesn't automatically deallocate empty chunks.
