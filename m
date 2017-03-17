Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33002 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdCQTZf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 15:25:35 -0400
Received: by mail-pf0-f170.google.com with SMTP id e129so2710541pfh.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Mar 2017 12:25:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22731.59878.724789.333618@tree.ty.sabi.co.uk>
References: <CAAafysHAZ_1-4rTqsY4cw0rkBgq3f_F29nM+=XsDEhNvR8CkJQ@mail.gmail.com>
 <22731.59878.724789.333618@tree.ty.sabi.co.uk>
From: John Marrett <johnf@zioncluster.ca>
Date: Fri, 17 Mar 2017 15:25:34 -0400
Message-ID: <CAAafysFBYkAe9pgmnky4-Rxd0r1Xau3rb2ueT0Yu+rjDT9+Atw@mail.gmail.com>
Subject: Re: BTRFS Metadata Corruption Prevents Scrub and btrfs check
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter,

> Bad news. That means that probably the disk is damaged and
> further issues may happen.

This system has a long history, I have had a dual drive failure in the
past, I managed to recover from that with ddrescue. I've subsequently
copied the contents of the drives to new disks and expanded them. This
corruption probably stems from issues in the past and not from issues
with the current drives.

>> Incorrect local backref count on 5165855678464 root 259 owner 1732872
>> offset 0 found 0 wanted 1 back 0x3ba80f40
>> Backref disk bytenr does not match extent record,
>> bytenr=5165855678464, ref bytenr=7880454922968236032
>> backpointer mismatch on [5165855678464 28672]
>
> "Better" news. In practice a single metadata leaf node is
> corrupted in back references. You might be lucky and that might
> be rebuildable, but I don't know enough about the somewhat
> intricate Btrfs metadata trees to figure that out. Some metadata
> is rebuildable from other metadata with a tree scan, some not.

How can I attempt to rebuild the metadata, with a treescan or otherwise?

> In general metadata in Btrfs is fairly intricate and metadata
> block loss is pretty fatal, that's why metadata should most
> times be redundant as in 'dup' or 'raid1' or similar:

All the data and metadata on this system is in raid1 or raid10, in
fact I discovered this issue while trying to change my balance form
raid1 to raid10.

johnf@carbon:~$ sudo btrfs fi df /
Data, RAID10: total=1.13TiB, used=1.12TiB
Data, RAID1: total=5.17TiB, used=5.16TiB
System, RAID1: total=32.00MiB, used=864.00KiB
Metadata, RAID10: total=3.09GiB, used=3.08GiB
Metadata, RAID1: total=13.00GiB, used=10.16GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Thanks for your help, much appreciated,

-JohnF
