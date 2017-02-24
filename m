Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:36152 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdBXMaY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 07:30:24 -0500
Received: by mail-it0-f53.google.com with SMTP id h10so18101702ith.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Feb 2017 04:30:24 -0800 (PST)
Subject: Re: Downgrading kernel 4.9 to 4.4 with space_cache=v2 enabled?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Christian Theune <ct@flyingcircus.io>,
        linux-btrfs@vger.kernel.org
References: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
 <fe942684-deb3-08f1-d4c1-ae25a912f799@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bb8ea7fc-8607-f130-47f0-94175e20e330@gmail.com>
Date: Fri, 24 Feb 2017 07:23:42 -0500
MIME-Version: 1.0
In-Reply-To: <fe942684-deb3-08f1-d4c1-ae25a912f799@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-23 19:54, Qu Wenruo wrote:
>
>
> At 02/23/2017 06:51 PM, Christian Theune wrote:
>> Hi,
>>
>> not sure whether it’s possible, but we tried space_cache=v2 and
>> obviously after working fine in staging it broke in production. Or
>> rather: we upgraded from 4.4 to 4.9 and enabled the space_cache. Our
>> production volume is around 50TiB usable (underlying HW Raid 6).
>>
>> The machine crashes silently every 15 hours or so and takes _ages_ to
>> reboot. It current is stuck trying to mount the local filesystems and
>> I guess btrfs is doing something, but I don’t have shell access yet.
>>
>> I’m wondering whether we can downgrade by booting back into 4.4 or
>> will this break things even further? (We’ve had some unpleasant
>> surprises with FS’ in the last months, so I thought I’d rather ask.)
>
> You could use "btrfs check --clear-space-cache" to completely cleanup
> space cache. Both v1(free space cache, file based) or v2(free space
> tree) are supported.
>
> And specially for v2 space cache (space cache tree), "btrfs check
> --clear-space-cache" will also clear the ro_compat flag, so older kernel
> should mount the fs without problem.
That's really good to know.  I hadn't remembered that using mount 
options didn't clear the flag.

