Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35805 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754228AbcJRMjO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 08:39:14 -0400
Received: by mail-io0-f176.google.com with SMTP id f5so37153610ioj.2
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 05:39:14 -0700 (PDT)
Subject: Re: Monitoring Btrfs
To: Anand Jain <anand.jain@oracle.com>,
        Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
 <05b79b4d-3f8d-7b78-d386-495b1dab1e70@gmail.com>
 <c40e1675-f002-b2e4-b252-c5e17200f72a@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a813c70b-e230-726e-e0bc-e8f15848cc44@gmail.com>
Date: Tue, 18 Oct 2016 08:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <c40e1675-f002-b2e4-b252-c5e17200f72a@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-17 23:23, Anand Jain wrote:
>
>
>>> I would like to monitor my btrfs-filesystem for missing drives.
>
>> This is actually correct behavior, the filesystem reports that it should
>> have 6 devices, which is how it knows a device is missing.
>
>  Missing - means missing at the time of mount. So how are you planning
> to monitor a disk which is failed while in production ?
No, in `btrfs fi show` it means that it can't find the device.  All that 
`fi show` does is print out what info it can find about the filesystem, 
nothing more, nothing less.  It's trivial to see from the output (two 
different ways I might add) that you're missing devices and how many you 
still have.  The only way without poking at the FS directly to figure 
out how many devices the FS is supposed to have (or at least, how many 
it thinks it should have) is the device count output by `btrfs fi show`.

Now, for production usage, you have three things you should be monitoring:
1. Output from `btrfs dev stats`.  This reports per-device error 
counters, and is one of the best ways to see if something is wrong, and 
also gives you a decent indicator of exactly what is wrong.
2. Status from regular scrub operations.  Pretty self explanatory.
3. SMART status of the underlying devices themselves.  This will catch 
pre-failure conditions, and the direct access from smartctl will error 
out when the drive has failed to the point of not being present.

You can additionally monitor:
1. Filesystem flags.  These will change when the filesystem goes 
degraded, and it's actually good practice for any filesystem, not just 
BTRFS.
2. Total filesystem size.  If this changes without manual intervention, 
something is seriously wrong.
