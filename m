Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33005 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031213AbcJRSO3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 14:14:29 -0400
Received: by mail-io0-f175.google.com with SMTP id q192so6850615iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 11:14:28 -0700 (PDT)
Subject: Re: Btrfs dev del
To: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAA3ktqmsf6S07MDrLhYfBJ2EYYConpHUj7A8FDWSZ09JsYP4eA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5e585cc7-f50b-1332-a5b7-849c5c5edf38@gmail.com>
Date: Tue, 18 Oct 2016 14:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAA3ktqmsf6S07MDrLhYfBJ2EYYConpHUj7A8FDWSZ09JsYP4eA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-18 11:02, Stefan Malte Schumacher wrote:
> Hello
>
> One of the drives which I added to my array two days ago was most
> likely already damaged when I bought it - 312 read errors while
> scrubbing and lots of SMART errors. I want to take the drive out, go
> to my hardware vendor and have it replaced. So I issued the command:
> "btrfs dev del /dev/sdf /mnt/btrfs-raid". It has been going on for
> about an hour now. It seems that removing the drive triggered a
> balance operation - "btrfs fi show"  shows /dev/sdf as having Zero
> Data on it, while the size of the data stored on the other drives is
> increasing. What I would like to know is where btrfs takes the data to
> be replicated from - from the others drive or from the device about to
> be removed? I am using RAID1 on data, metadata and system so there
> should be a good copy of all the files on /dev/sdf. I just want to be
> certain that the damaged data on /dev/sdf are not spread around the
> filesystem in which case restoring my backup would be the best idea.
This is expected behavior, any data that was on the device being removed 
needs to be relocated to other devices in the array, and the easiest way 
to do that is to leverage the balance code.  Because it's using the 
balance code, you should have no issues with data corruption being 
propagated to the other devices, since balance also functionally scrubs 
data as it's being moved (it has the same fall-back error handling that 
regular file accesses do, so if it finds a checksum error, the other 
copy of that block will get used).
