Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34452 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdGMX01 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 19:26:27 -0400
Received: by mail-wm0-f65.google.com with SMTP id p204so7883406wmg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 16:26:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170713223205.GB6181@lim.localdomain>
References: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
 <20170713223205.GB6181@lim.localdomain>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 13 Jul 2017 17:26:25 -0600
Message-ID: <CAJCQCtSpJkVzH=jL7+1J2jHncCBxwFS_eDNs_q+q6uUdTG8DAQ@mail.gmail.com>
Subject: Re: Containers, Btrfs vs Btrfs + overlayfs
To: bo.li.liu@oracle.com
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 4:32 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Jul 13, 2017 at 02:49:27PM -0600, Chris Murphy wrote:
>> Has anyone been working with Docker and Btrfs + overlayfs? It seems
>> superfluous or unnecessary to use overlayfs, but the shared page cache
>> aspect and avoiding some of the problems with large numbers of Btrfs
>> snapshots, might make it a useful combination. But I'm not finding
>> useful information with searches. Typically it's Btrfs alone vs
>> ext4/XFS + overlayfs.
>>
>> ?
>
> Is there a reproducer for problems with large number of btrfs
> snapshots?

No benchmarking comparison but it's known that deletion of snapshots
gets more expensive when there are many snapshots due to backref
search and metadata updates. I have no idea how it compares to
overlayfs. But then also some use cases I guess it's non-trivial
benefit to leverage a shared page cache.

> Btrfs + overlayfs?  The copy-up coperation in overlayfs can take
> advantage of btrfs's clone, but this benefit applies for xfs, too.

Btrfs supports fs shrink, and also multiple device add/remove so it's
pretty nice for managing its storage in the cloud. And also seed
device might have uses. Some of it is doable with LVM but it's much
simpler, faster and safer with Btrfs.

And that's why I'm kinda curious about the combination of Btrfs and
overlayfs. Overlayfs managed by Docker. And Btrfs for simpler and more
flexible storage management.


-- 
Chris Murphy
