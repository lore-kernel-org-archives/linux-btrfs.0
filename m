Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33275 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752202AbdDDNwT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 09:52:19 -0400
Received: by mail-io0-f195.google.com with SMTP id f84so15090060ioj.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Apr 2017 06:52:18 -0700 (PDT)
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Brian B <brian@sd85.net>, Robert Krig <robert.krig@render-wahnsinn.de>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
 <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
 <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de>
 <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
 <0eda9836-a4ee-b666-2a05-b4bb26746b1a@sd85.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b6524e54-1b36-bfb5-4137-b755acb9e985@gmail.com>
Date: Tue, 4 Apr 2017 09:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <0eda9836-a4ee-b666-2a05-b4bb26746b1a@sd85.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-04 09:29, Brian B wrote:
> On 04/04/2017 12:02 AM, Robert Krig wrote:
>> My storage array is BTRFS Raid1 with 4x8TB Drives.
>> Wouldn't it be possible to simply disconnect two of those drives, mount
>> with -o degraded and still have access (even if read-only) to all my data?
> Just jumping on this point: my understanding of BTRFS "RAID1" is that
> each file (block?) is randomly assigned to two disks of the array (no
> matter how many disks are in the array).  So if you remove two disks,
> you will probably have files that were "assigned" to both of those
> disks, and will be missing.
>
> In short, you can't remove more than one disk of a BTRFS RAID1 and still
> have all of your data.
>
That understanding is correct.  From a functional perspective, BTRFS 
raid1 is currently a RAID10 implementation with striping happening at a 
very large granularity.
